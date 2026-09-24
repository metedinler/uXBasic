#pragma once
#include "uxb_runtime.h"
#include <array>
#include <mutex>
#include <string>

namespace uxb {

struct TaskRecord {
    bool defined = false;
    bool active = false;
    int slot_id = -1;
    int task_type = 0;
    std::string name;
    uxb_task_callback callback = nullptr;
    void* user_data = nullptr;
};

class RuntimeState {
public:
    static RuntimeState& instance();
    bool init();
    void shutdown();
    bool register_task(int slot_id, int task_type, const char* name);
    bool bind_slot(int slot_id, int task_type, const char* name);
    bool set_callback(int slot_id, uxb_task_callback callback, void* user_data);
    bool control_slot(int slot_id, bool active);
    bool snapshot_task(int slot_id, TaskRecord& out);
    void set_error(const std::string& text);
    const char* last_error();
    bool initialized() const;
private:
    RuntimeState() = default;
    bool valid_slot(int slot_id) const;
    bool valid_type(int task_type) const;
    mutable std::mutex mutex_;
    std::array<TaskRecord, UXB_RT_MAX_SLOTS> tasks_{};
    std::string last_error_;
    bool initialized_ = false;
};

void copy_text(const std::string& text, char* out, int out_len);

} // namespace uxb
