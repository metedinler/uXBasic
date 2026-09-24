#include "std_backend.h"
#include <exception>
#include <thread>

namespace uxb {

static int invoke_callback(const TaskRecord& task, int input_value, int* output_value) {
    try {
        return task.callback(task.slot_id, input_value, output_value, task.user_data);
    } catch (const std::exception& ex) {
        RuntimeState::instance().set_error(std::string("callback exception: ") + ex.what());
    } catch (...) {
        RuntimeState::instance().set_error("callback exception: unknown");
    }
    return UXB_RT_FAILURE;
}

int execute_std_backend(const TaskRecord& task, int input_value, int* output_value) {
    if (task.task_type == UXB_RT_TASK_EVENT || task.task_type == UXB_RT_TASK_PIPE) {
        return invoke_callback(task, input_value, output_value);
    }
    int rc = UXB_RT_FAILURE;
    std::thread worker([&]() { rc = invoke_callback(task, input_value, output_value); });
    worker.join();
    return rc;
}

} // namespace uxb
