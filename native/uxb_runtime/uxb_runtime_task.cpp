#include "uxb_runtime_task.h"
#include "uxb_runtime_state.h"
#include "backends/runtime_backend.h"

namespace uxb {
int execute_registered_task(int slot_id, int expected_type, int input_value, int* output_value) {
    TaskRecord task;
    if (!RuntimeState::instance().snapshot_task(slot_id, task)) return UXB_RT_FAILURE;
    if (expected_type != 0 && task.task_type != expected_type) {
        RuntimeState::instance().set_error("task type mismatch");
        return UXB_RT_FAILURE;
    }
    int local_output = 0;
    int* destination = output_value ? output_value : &local_output;
    return execute_task_backend(task, input_value, destination) ? UXB_RT_SUCCESS : UXB_RT_FAILURE;
}
}
