#include "uxclz.h"

#include <algorithm>
#include <atomic>
#include <cinttypes>
#include <cstdio>
#include <memory>
#include <mutex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {

constexpr uint32_t UXCLZ_ABI_VERSION = 0x00010000u;
constexpr uint32_t MAX_INHERITANCE_DEPTH = 256u;
thread_local std::string g_last_error;
thread_local std::string g_json_buffer;
thread_local std::string g_name_buffer;

void set_error(const std::string& message) {
    g_last_error = message;
}

std::string json_escape(const std::string& input) {
    std::ostringstream out;
    for (unsigned char ch : input) {
        switch (ch) {
            case '\\': out << "\\\\"; break;
            case '"': out << "\\\""; break;
            case '\n': out << "\\n"; break;
            case '\r': out << "\\r"; break;
            case '\t': out << "\\t"; break;
            default:
                if (ch < 0x20) {
                    char buf[7]{};
                    std::snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned>(ch));
                    out << buf;
                } else {
                    out << static_cast<char>(ch);
                }
        }
    }
    return out.str();
}

struct MethodRecord {
    uxclz_method_id id{};
    std::string name;
    uxclz_method_fn fn{};
};

struct TypeRecord {
    uxclz_type_id id{};
    std::string name;
    uxclz_type_id base{};
    uint32_t flags{};
    std::vector<uxclz_type_id> interfaces;
    std::unordered_map<uxclz_method_id, MethodRecord> methods;
};

struct ObjectSlot {
    uint32_t generation{1};
    bool active{false};
    uxclz_type_id type{};
    uint32_t refs{};
    void* payload{};
    uxclz_destructor_fn destructor{};
};

struct MultiKey {
    uxclz_method_id method{};
    uxclz_type_id left{};
    uxclz_type_id right{};
    bool operator==(const MultiKey& other) const noexcept {
        return method == other.method && left == other.left && right == other.right;
    }
};

struct MultiKeyHash {
    size_t operator()(const MultiKey& key) const noexcept {
        size_t h = static_cast<size_t>(key.method);
        h ^= static_cast<size_t>(key.left) * 0x9e3779b185ebca87ULL;
        h ^= static_cast<size_t>(key.right) * 0xc2b2ae3d27d4eb4fULL;
        return h;
    }
};

struct MultiRecord {
    std::string name;
    uxclz_multimethod_fn fn{};
};

struct ArgsBuffer {
    std::vector<uxclz_value> values;
};

struct ResultBuffer {
    uxclz_value value{};
};

class Registry {
public:
    uxclz_type_id register_type(const char* raw_name, uxclz_type_id base, uint32_t flags) {
        if (raw_name == nullptr || *raw_name == '\0') {
            set_error("type name is empty");
            return 0;
        }
        std::lock_guard<std::mutex> lock(mutex_);
        const std::string name(raw_name);
        auto existing = type_by_name_.find(name);
        if (existing != type_by_name_.end()) {
            const TypeRecord& rec = types_.at(existing->second - 1u);
            if (rec.base == base && rec.flags == flags) {
                return rec.id;
            }
            set_error("type already registered with a different contract: " + name);
            return 0;
        }
        if (base != 0 && !find_type_locked(base)) {
            set_error("base type does not exist");
            return 0;
        }
        TypeRecord rec;
        rec.id = static_cast<uxclz_type_id>(types_.size() + 1u);
        rec.name = name;
        rec.base = base;
        rec.flags = flags;
        types_.push_back(rec);
        type_by_name_[name] = rec.id;
        return rec.id;
    }

    bool add_interface(uxclz_type_id type, uxclz_type_id interface_id) {
        std::lock_guard<std::mutex> lock(mutex_);
        TypeRecord* owner = find_type_locked(type);
        const TypeRecord* iface = find_type_locked(interface_id);
        if (!owner || !iface) {
            set_error("type or interface id does not exist");
            return false;
        }
        if ((iface->flags & UXCLZ_TYPE_INTERFACE) == 0u) {
            set_error("target id is not registered as an interface");
            return false;
        }
        if (std::find(owner->interfaces.begin(), owner->interfaces.end(), interface_id) == owner->interfaces.end()) {
            owner->interfaces.push_back(interface_id);
        }
        return true;
    }

    bool register_method(uxclz_type_id type, uxclz_method_id method, const char* name, uxclz_method_fn fn) {
        if (method == 0 || fn == nullptr) {
            set_error("method id and function pointer must be non-zero");
            return false;
        }
        std::lock_guard<std::mutex> lock(mutex_);
        TypeRecord* owner = find_type_locked(type);
        if (!owner) {
            set_error("method owner type does not exist");
            return false;
        }
        MethodRecord rec{method, name ? name : "", fn};
        owner->methods[method] = std::move(rec);
        return true;
    }

    uxclz_handle wrap(uxclz_type_id type, void* payload, uxclz_destructor_fn destructor) {
        std::lock_guard<std::mutex> lock(mutex_);
        if (!find_type_locked(type)) {
            set_error("object type does not exist");
            return 0;
        }
        size_t slot_index = 0;
        for (; slot_index < objects_.size(); ++slot_index) {
            if (!objects_[slot_index].active) break;
        }
        if (slot_index == objects_.size()) {
            objects_.push_back(ObjectSlot{});
        }
        ObjectSlot& slot = objects_[slot_index];
        if (slot.generation == 0) slot.generation = 1;
        slot.active = true;
        slot.type = type;
        slot.refs = 1;
        slot.payload = payload;
        slot.destructor = destructor;
        return make_handle(slot_index, slot.generation);
    }

    bool retain(uxclz_handle handle) {
        std::lock_guard<std::mutex> lock(mutex_);
        ObjectSlot* slot = find_object_locked(handle);
        if (!slot) {
            set_error("retain on invalid/stale handle");
            return false;
        }
        if (slot->refs == UINT32_MAX) {
            set_error("reference count overflow");
            return false;
        }
        ++slot->refs;
        return true;
    }

    bool release(uxclz_handle handle) {
        void* payload = nullptr;
        uxclz_destructor_fn destructor = nullptr;
        {
            std::lock_guard<std::mutex> lock(mutex_);
            ObjectSlot* slot = find_object_locked(handle);
            if (!slot) {
                set_error("release on invalid/stale handle");
                return false;
            }
            if (--slot->refs != 0) return true;
            payload = slot->payload;
            destructor = slot->destructor;
            slot->active = false;
            slot->type = 0;
            slot->payload = nullptr;
            slot->destructor = nullptr;
            ++slot->generation;
            if (slot->generation == 0) slot->generation = 1;
        }
        if (destructor) destructor(payload);
        return true;
    }

    bool valid(uxclz_handle handle) {
        std::lock_guard<std::mutex> lock(mutex_);
        return find_object_locked(handle) != nullptr;
    }

    uxclz_type_id object_type(uxclz_handle handle) {
        std::lock_guard<std::mutex> lock(mutex_);
        ObjectSlot* slot = find_object_locked(handle);
        if (!slot) {
            set_error("invalid/stale object handle");
            return 0;
        }
        return slot->type;
    }

    void* object_payload(uxclz_handle handle) {
        std::lock_guard<std::mutex> lock(mutex_);
        ObjectSlot* slot = find_object_locked(handle);
        if (!slot) {
            set_error("invalid/stale object handle");
            return nullptr;
        }
        return slot->payload;
    }

    bool is_a(uxclz_type_id type, uxclz_type_id expected) {
        std::lock_guard<std::mutex> lock(mutex_);
        return is_a_locked(type, expected);
    }

    bool has_interface(uxclz_type_id type, uxclz_type_id interface_id) {
        std::lock_guard<std::mutex> lock(mutex_);
        return has_interface_locked(type, interface_id);
    }

    uxclz_handle query_interface(uxclz_handle handle, uxclz_type_id interface_id) {
        std::lock_guard<std::mutex> lock(mutex_);
        ObjectSlot* slot = find_object_locked(handle);
        if (!slot || !has_interface_locked(slot->type, interface_id)) {
            set_error("object does not implement requested interface");
            return 0;
        }
        if (slot->refs == UINT32_MAX) {
            set_error("reference count overflow");
            return 0;
        }
        ++slot->refs;
        return handle;
    }

    bool invoke(uxclz_handle handle, uxclz_method_id method, const uxclz_value* args, uint32_t argc, uxclz_value* result) {
        uxclz_method_fn fn = nullptr;
        void* payload = nullptr;
        {
            std::lock_guard<std::mutex> lock(mutex_);
            ObjectSlot* slot = find_object_locked(handle);
            if (!slot) {
                set_error("invoke on invalid/stale object handle");
                return false;
            }
            const MethodRecord* rec = find_method_locked(slot->type, method);
            if (!rec || !rec->fn) {
                set_error("method is not registered for object type or its bases");
                return false;
            }
            fn = rec->fn;
            payload = slot->payload;
            if (slot->refs == UINT32_MAX) {
                set_error("reference count overflow during invoke");
                return false;
            }
            ++slot->refs;
        }
        uxclz_value local_result{};
        const int ok = fn(handle, payload, args, argc, result ? result : &local_result);
        release(handle);
        if (!ok && g_last_error.empty()) set_error("registered method returned failure");
        return ok != 0;
    }

    bool register_multi(uxclz_method_id method, uxclz_type_id left, uxclz_type_id right, const char* name, uxclz_multimethod_fn fn) {
        if (method == 0 || left == 0 || right == 0 || fn == nullptr) {
            set_error("invalid multimethod registration");
            return false;
        }
        std::lock_guard<std::mutex> lock(mutex_);
        if (!find_type_locked(left) || !find_type_locked(right)) {
            set_error("multimethod type does not exist");
            return false;
        }
        multi_[MultiKey{method, left, right}] = MultiRecord{name ? name : "", fn};
        return true;
    }

    bool invoke_multi(uxclz_method_id method, uxclz_handle left_h, uxclz_handle right_h,
                      const uxclz_value* args, uint32_t argc, uxclz_value* result) {
        uxclz_multimethod_fn fn = nullptr;
        void* left_payload = nullptr;
        void* right_payload = nullptr;
        {
            std::lock_guard<std::mutex> lock(mutex_);
            ObjectSlot* left = find_object_locked(left_h);
            ObjectSlot* right = find_object_locked(right_h);
            if (!left || !right) {
                set_error("multimethod received invalid/stale object handle");
                return false;
            }
            const MultiRecord* rec = find_multi_locked(method, left->type, right->type);
            if (!rec || !rec->fn) {
                set_error("no multimethod matches the runtime type pair");
                return false;
            }
            fn = rec->fn;
            left_payload = left->payload;
            right_payload = right->payload;
            if (left->refs == UINT32_MAX || right->refs == UINT32_MAX) {
                set_error("reference count overflow during multimethod invoke");
                return false;
            }
            ++left->refs;
            ++right->refs;
        }
        uxclz_value local_result{};
        const int ok = fn(left_h, left_payload, right_h, right_payload, args, argc, result ? result : &local_result);
        release(left_h);
        release(right_h);
        if (!ok && g_last_error.empty()) set_error("registered multimethod returned failure");
        return ok != 0;
    }

    std::string type_name_copy(uxclz_type_id id) {
        std::lock_guard<std::mutex> lock(mutex_);
        const TypeRecord* rec = find_type_locked(id);
        if (!rec) {
            set_error("type id does not exist");
            return {};
        }
        return rec->name;
    }

    std::string type_json(uxclz_type_id id) {
        std::lock_guard<std::mutex> lock(mutex_);
        const TypeRecord* rec = find_type_locked(id);
        if (!rec) {
            set_error("type id does not exist");
            return "{}";
        }
        return type_json_locked(*rec);
    }

    std::string registry_json() {
        std::lock_guard<std::mutex> lock(mutex_);
        std::ostringstream out;
        out << "{\"abiVersion\":" << UXCLZ_ABI_VERSION << ",\"types\":[";
        for (size_t i = 0; i < types_.size(); ++i) {
            if (i) out << ',';
            out << type_json_locked(types_[i]);
        }
        out << "]}";
        return out.str();
    }

    bool reset() {
        std::lock_guard<std::mutex> lock(mutex_);
        for (const ObjectSlot& slot : objects_) {
            if (slot.active) {
                set_error("registry reset refused while live objects exist");
                return false;
            }
        }
        objects_.clear();
        types_.clear();
        type_by_name_.clear();
        multi_.clear();
        return true;
    }

private:
    static uxclz_handle make_handle(size_t slot_index, uint32_t generation) {
        const uint64_t slot_part = static_cast<uint64_t>(slot_index + 1u);
        return (slot_part << 32u) | static_cast<uint64_t>(generation);
    }

    static bool decode_handle(uxclz_handle handle, size_t& slot_index, uint32_t& generation) {
        const uint32_t slot_plus_one = static_cast<uint32_t>(handle >> 32u);
        generation = static_cast<uint32_t>(handle & 0xffffffffu);
        if (slot_plus_one == 0 || generation == 0) return false;
        slot_index = static_cast<size_t>(slot_plus_one - 1u);
        return true;
    }

    TypeRecord* find_type_locked(uxclz_type_id id) {
        if (id == 0 || id > types_.size()) return nullptr;
        return &types_[id - 1u];
    }
    const TypeRecord* find_type_locked(uxclz_type_id id) const {
        if (id == 0 || id > types_.size()) return nullptr;
        return &types_[id - 1u];
    }

    ObjectSlot* find_object_locked(uxclz_handle handle) {
        size_t index = 0;
        uint32_t generation = 0;
        if (!decode_handle(handle, index, generation) || index >= objects_.size()) return nullptr;
        ObjectSlot& slot = objects_[index];
        if (!slot.active || slot.generation != generation || slot.refs == 0) return nullptr;
        return &slot;
    }

    bool is_a_locked(uxclz_type_id type, uxclz_type_id expected) const {
        if (type == 0 || expected == 0) return false;
        uxclz_type_id current = type;
        for (uint32_t depth = 0; current != 0 && depth < MAX_INHERITANCE_DEPTH; ++depth) {
            if (current == expected) return true;
            const TypeRecord* rec = find_type_locked(current);
            if (!rec) return false;
            current = rec->base;
        }
        return false;
    }

    bool has_interface_locked(uxclz_type_id type, uxclz_type_id interface_id) const {
        uxclz_type_id current = type;
        for (uint32_t depth = 0; current != 0 && depth < MAX_INHERITANCE_DEPTH; ++depth) {
            const TypeRecord* rec = find_type_locked(current);
            if (!rec) return false;
            if (std::find(rec->interfaces.begin(), rec->interfaces.end(), interface_id) != rec->interfaces.end()) return true;
            if (rec->id == interface_id && (rec->flags & UXCLZ_TYPE_INTERFACE) != 0u) return true;
            current = rec->base;
        }
        return false;
    }

    const MethodRecord* find_method_locked(uxclz_type_id type, uxclz_method_id method) const {
        uxclz_type_id current = type;
        for (uint32_t depth = 0; current != 0 && depth < MAX_INHERITANCE_DEPTH; ++depth) {
            const TypeRecord* rec = find_type_locked(current);
            if (!rec) return nullptr;
            auto found = rec->methods.find(method);
            if (found != rec->methods.end()) return &found->second;
            current = rec->base;
        }
        return nullptr;
    }

    const MultiRecord* find_multi_locked(uxclz_method_id method, uxclz_type_id left, uxclz_type_id right) const {
        std::vector<uxclz_type_id> left_chain;
        std::vector<uxclz_type_id> right_chain;
        for (uxclz_type_id cur = left; cur != 0 && left_chain.size() < MAX_INHERITANCE_DEPTH;) {
            left_chain.push_back(cur);
            const TypeRecord* rec = find_type_locked(cur);
            cur = rec ? rec->base : 0;
        }
        for (uxclz_type_id cur = right; cur != 0 && right_chain.size() < MAX_INHERITANCE_DEPTH;) {
            right_chain.push_back(cur);
            const TypeRecord* rec = find_type_locked(cur);
            cur = rec ? rec->base : 0;
        }
        for (uxclz_type_id l : left_chain) {
            for (uxclz_type_id r : right_chain) {
                auto found = multi_.find(MultiKey{method, l, r});
                if (found != multi_.end()) return &found->second;
            }
        }
        return nullptr;
    }

    std::string type_json_locked(const TypeRecord& rec) const {
        std::ostringstream out;
        out << "{\"id\":" << rec.id
            << ",\"name\":\"" << json_escape(rec.name) << "\""
            << ",\"base\":" << rec.base
            << ",\"flags\":" << rec.flags
            << ",\"interfaces\":[";
        for (size_t i = 0; i < rec.interfaces.size(); ++i) {
            if (i) out << ',';
            out << rec.interfaces[i];
        }
        out << "],\"methods\":[";
        bool first = true;
        for (const auto& pair : rec.methods) {
            if (!first) out << ',';
            first = false;
            out << "{\"id\":" << pair.second.id
                << ",\"name\":\"" << json_escape(pair.second.name) << "\"}";
        }
        out << "]}";
        return out.str();
    }

    mutable std::mutex mutex_;
    std::vector<TypeRecord> types_;
    std::unordered_map<std::string, uxclz_type_id> type_by_name_;
    std::vector<ObjectSlot> objects_;
    std::unordered_map<MultiKey, MultiRecord, MultiKeyHash> multi_;
};

Registry& registry() {
    static Registry instance;
    return instance;
}

ArgsBuffer* as_args(uint64_t handle) {
    return reinterpret_cast<ArgsBuffer*>(static_cast<uintptr_t>(handle));
}
ResultBuffer* as_result(uint64_t handle) {
    return reinterpret_cast<ResultBuffer*>(static_cast<uintptr_t>(handle));
}

uxclz_value make_i64(int64_t value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_I64; v.data.i64 = value; return v; }
uxclz_value make_u64(uint64_t value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_U64; v.data.u64 = value; return v; }
uxclz_value make_f64(double value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_F64; v.data.f64 = value; return v; }
uxclz_value make_ptr(void* value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_PTR; v.data.ptr = value; return v; }
uxclz_value make_bool(int value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_BOOL; v.data.i64 = value ? 1 : 0; return v; }
uxclz_value make_str(const char* value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_STRPTR; v.data.str = value; return v; }
uxclz_value make_handle_value(uxclz_handle value) { uxclz_value v{}; v.kind = UXCLZ_VALUE_HANDLE; v.data.handle = value; return v; }

} // namespace

extern "C" {

uint32_t UXCLZ_CALL uxclz_version(void) { return UXCLZ_ABI_VERSION; }
const char* UXCLZ_CALL uxclz_last_error(void) { return g_last_error.c_str(); }
int UXCLZ_CALL uxclz_reset_registry(void) { g_last_error.clear(); return registry().reset() ? 1 : 0; }

uxclz_type_id UXCLZ_CALL uxclz_type_register(const char* name, uxclz_type_id base_type, uint32_t flags) {
    g_last_error.clear(); return registry().register_type(name, base_type, flags);
}
int UXCLZ_CALL uxclz_type_add_interface(uxclz_type_id type_id, uxclz_type_id interface_id) {
    g_last_error.clear(); return registry().add_interface(type_id, interface_id) ? 1 : 0;
}
const char* UXCLZ_CALL uxclz_type_name(uxclz_type_id type_id) {
    g_last_error.clear(); g_name_buffer = registry().type_name_copy(type_id); return g_name_buffer.c_str();
}
int UXCLZ_CALL uxclz_type_is_a(uxclz_type_id type_id, uxclz_type_id expected_type) {
    g_last_error.clear(); return registry().is_a(type_id, expected_type) ? 1 : 0;
}
int UXCLZ_CALL uxclz_type_has_interface(uxclz_type_id type_id, uxclz_type_id interface_id) {
    g_last_error.clear(); return registry().has_interface(type_id, interface_id) ? 1 : 0;
}
const char* UXCLZ_CALL uxclz_type_metadata_json(uxclz_type_id type_id) {
    g_last_error.clear(); g_json_buffer = registry().type_json(type_id); return g_json_buffer.c_str();
}
const char* UXCLZ_CALL uxclz_registry_metadata_json(void) {
    g_last_error.clear(); g_json_buffer = registry().registry_json(); return g_json_buffer.c_str();
}

int UXCLZ_CALL uxclz_method_register(uxclz_type_id type_id, uxclz_method_id method_id, const char* name, uxclz_method_fn fn) {
    g_last_error.clear(); return registry().register_method(type_id, method_id, name, fn) ? 1 : 0;
}

uxclz_handle UXCLZ_CALL uxclz_object_wrap(uxclz_type_id type_id, void* payload, uxclz_destructor_fn destructor) {
    g_last_error.clear(); return registry().wrap(type_id, payload, destructor);
}
int UXCLZ_CALL uxclz_object_retain(uxclz_handle handle) { g_last_error.clear(); return registry().retain(handle) ? 1 : 0; }
int UXCLZ_CALL uxclz_object_release(uxclz_handle handle) { g_last_error.clear(); return registry().release(handle) ? 1 : 0; }
int UXCLZ_CALL uxclz_object_is_valid(uxclz_handle handle) { g_last_error.clear(); return registry().valid(handle) ? 1 : 0; }
uxclz_type_id UXCLZ_CALL uxclz_object_type(uxclz_handle handle) { g_last_error.clear(); return registry().object_type(handle); }
void* UXCLZ_CALL uxclz_object_payload(uxclz_handle handle) { g_last_error.clear(); return registry().object_payload(handle); }
uxclz_handle UXCLZ_CALL uxclz_object_query_interface(uxclz_handle handle, uxclz_type_id interface_id) {
    g_last_error.clear(); return registry().query_interface(handle, interface_id);
}

uint64_t UXCLZ_CALL uxclz_args_new(void) {
    try { return static_cast<uint64_t>(reinterpret_cast<uintptr_t>(new ArgsBuffer())); }
    catch (...) { set_error("args allocation failed"); return 0; }
}
void UXCLZ_CALL uxclz_args_free(uint64_t h) { delete as_args(h); }
void UXCLZ_CALL uxclz_args_clear(uint64_t h) { if (auto* a = as_args(h)) a->values.clear(); }
uint32_t UXCLZ_CALL uxclz_args_count(uint64_t h) { auto* a = as_args(h); return a ? static_cast<uint32_t>(a->values.size()) : 0; }
int UXCLZ_CALL uxclz_args_push_i64(uint64_t h, int64_t v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_i64(v)); return 1; }
int UXCLZ_CALL uxclz_args_push_u64(uint64_t h, uint64_t v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_u64(v)); return 1; }
int UXCLZ_CALL uxclz_args_push_f64(uint64_t h, double v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_f64(v)); return 1; }
int UXCLZ_CALL uxclz_args_push_ptr(uint64_t h, void* v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_ptr(v)); return 1; }
int UXCLZ_CALL uxclz_args_push_bool(uint64_t h, int v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_bool(v)); return 1; }
int UXCLZ_CALL uxclz_args_push_strptr(uint64_t h, const char* v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_str(v)); return 1; }
int UXCLZ_CALL uxclz_args_push_handle(uint64_t h, uxclz_handle v) { auto* a = as_args(h); if (!a) return 0; a->values.push_back(make_handle_value(v)); return 1; }

uint64_t UXCLZ_CALL uxclz_result_new(void) {
    try { return static_cast<uint64_t>(reinterpret_cast<uintptr_t>(new ResultBuffer())); }
    catch (...) { set_error("result allocation failed"); return 0; }
}
void UXCLZ_CALL uxclz_result_free(uint64_t h) { delete as_result(h); }
void UXCLZ_CALL uxclz_result_clear(uint64_t h) { if (auto* r = as_result(h)) r->value = uxclz_value{}; }
uint32_t UXCLZ_CALL uxclz_result_kind(uint64_t h) { auto* r = as_result(h); return r ? r->value.kind : static_cast<uint32_t>(UXCLZ_VALUE_NULL); }
int64_t UXCLZ_CALL uxclz_result_i64(uint64_t h) { auto* r = as_result(h); return r ? r->value.data.i64 : 0; }
uint64_t UXCLZ_CALL uxclz_result_u64(uint64_t h) { auto* r = as_result(h); return r ? r->value.data.u64 : 0; }
double UXCLZ_CALL uxclz_result_f64(uint64_t h) { auto* r = as_result(h); return r ? r->value.data.f64 : 0.0; }
void* UXCLZ_CALL uxclz_result_ptr(uint64_t h) { auto* r = as_result(h); return r ? r->value.data.ptr : nullptr; }
int UXCLZ_CALL uxclz_result_bool(uint64_t h) { auto* r = as_result(h); return r && r->value.data.i64 ? 1 : 0; }
const char* UXCLZ_CALL uxclz_result_strptr(uint64_t h) { auto* r = as_result(h); return r && r->value.data.str ? r->value.data.str : ""; }
uxclz_handle UXCLZ_CALL uxclz_result_handle(uint64_t h) { auto* r = as_result(h); return r ? r->value.data.handle : 0; }

int UXCLZ_CALL uxclz_invoke_args(uxclz_handle object, uxclz_method_id method_id, uint64_t args_h, uint64_t result_h) {
    g_last_error.clear();
    ArgsBuffer* args = as_args(args_h);
    ResultBuffer* result = as_result(result_h);
    if (!result) { set_error("result handle is null"); return 0; }
    result->value = uxclz_value{};
    const uxclz_value* data = args && !args->values.empty() ? args->values.data() : nullptr;
    const uint32_t count = args ? static_cast<uint32_t>(args->values.size()) : 0u;
    return registry().invoke(object, method_id, data, count, &result->value) ? 1 : 0;
}

int UXCLZ_CALL uxclz_multimethod_register(uxclz_method_id method_id, uxclz_type_id left_type, uxclz_type_id right_type, const char* name, uxclz_multimethod_fn fn) {
    g_last_error.clear(); return registry().register_multi(method_id, left_type, right_type, name, fn) ? 1 : 0;
}
int UXCLZ_CALL uxclz_multimethod_invoke_args(uxclz_method_id method_id, uxclz_handle left, uxclz_handle right, uint64_t args_h, uint64_t result_h) {
    g_last_error.clear();
    ArgsBuffer* args = as_args(args_h);
    ResultBuffer* result = as_result(result_h);
    if (!result) { set_error("result handle is null"); return 0; }
    result->value = uxclz_value{};
    const uxclz_value* data = args && !args->values.empty() ? args->values.data() : nullptr;
    const uint32_t count = args ? static_cast<uint32_t>(args->values.size()) : 0u;
    return registry().invoke_multi(method_id, left, right, data, count, &result->value) ? 1 : 0;
}

} // extern "C"
