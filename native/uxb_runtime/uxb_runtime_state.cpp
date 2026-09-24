#include "uxb_runtime_state.h"
#include <algorithm>
#include <cstring>

namespace uxb {

RuntimeState& RuntimeState::instance() {
    static RuntimeState state;
    return state;
}

bool RuntimeState::valid_slot(int slot_id) const {
    return slot_id >= 0 && slot_id < UXB_RT_MAX_SLOTS;
}

bool RuntimeState::valid_type(int task_type) const {
    return task_type == UXB_RT_TASK_EVENT || task_type == UXB_RT_TASK_PIPE ||
           task_type == UXB_RT_TASK_THREAD || task_type == UXB_RT_TASK_PARALEL;
}

bool RuntimeState::init() {
    std::lock_guard<std::mutex> lock(mutex_);
    for (int i = 0; i < UXB_RT_MAX_SLOTS; ++i) {
        tasks_[i] = TaskRecord{};
        tasks_[i].slot_id = i;
    }
    last_error_.clear();
    initialized_ = true;
    return true;
}

void RuntimeState::shutdown() {
    std::lock_guard<std::mutex> lock(mutex_);
    for (int i = 0; i < UXB_RT_MAX_SLOTS; ++i) {
        tasks_[i] = TaskRecord{};
        tasks_[i].slot_id = i;
    }
    initialized_ = false;
    last_error_.clear();
}

bool RuntimeState::register_task(int slot_id, int task_type, const char* name) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!initialized_) { last_error_ = "runtime is not initialized"; return false; }
    if (!valid_slot(slot_id)) { last_error_ = "slot id must be in range 0..255"; return false; }
    if (!valid_type(task_type)) { last_error_ = "invalid task type"; return false; }
    if (name == nullptr || *name == '\0') { last_error_ = "task name is empty"; return false; }
    TaskRecord& task = tasks_[slot_id];
    task.defined = true;
    task.active = true;
    task.slot_id = slot_id;
    task.task_type = task_type;
    task.name = name;
    last_error_.clear();
    return true;
}

bool RuntimeState::bind_slot(int slot_id, int task_type, const char* name) {
    return register_task(slot_id, task_type, name);
}

bool RuntimeState::set_callback(int slot_id, uxb_task_callback callback, void* user_data) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!valid_slot(slot_id)) { last_error_ = "slot id must be in range 0..255"; return false; }
    TaskRecord& task = tasks_[slot_id];
    if (!task.defined) { last_error_ = "slot is not registered"; return false; }
    task.callback = callback;
    task.user_data = user_data;
    last_error_.clear();
    return true;
}

bool RuntimeState::control_slot(int slot_id, bool active) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!valid_slot(slot_id)) { last_error_ = "slot id must be in range 0..255"; return false; }
    TaskRecord& task = tasks_[slot_id];
    if (!task.defined) { last_error_ = "slot is not registered"; return false; }
    task.active = active;
    last_error_.clear();
    return true;
}

bool RuntimeState::snapshot_task(int slot_id, TaskRecord& out) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!initialized_) { last_error_ = "runtime is not initialized"; return false; }
    if (!valid_slot(slot_id)) { last_error_ = "slot id must be in range 0..255"; return false; }
    const TaskRecord& task = tasks_[slot_id];
    if (!task.defined) { last_error_ = "slot is not registered"; return false; }
    if (!task.active) { last_error_ = "slot is OFF"; return false; }
    if (task.callback == nullptr) { last_error_ = "slot callback is not bound"; return false; }
    out = task;
    last_error_.clear();
    return true;
}

void RuntimeState::set_error(const std::string& text) {
    std::lock_guard<std::mutex> lock(mutex_);
    last_error_ = text;
}

const char* RuntimeState::last_error() {
    std::lock_guard<std::mutex> lock(mutex_);
    return last_error_.c_str();
}

bool RuntimeState::initialized() const {
    std::lock_guard<std::mutex> lock(mutex_);
    return initialized_;
}

void copy_text(const std::string& text, char* out, int out_len) {
    if (out == nullptr || out_len <= 0) return;
    const size_t count = std::min(text.size(), static_cast<size_t>(out_len - 1));
    if (count > 0) std::memcpy(out, text.data(), count);
    out[count] = '\0';
}

} // namespace uxb
