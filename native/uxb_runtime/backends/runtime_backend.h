#pragma once
#include "../uxb_runtime_state.h"
#include <string>

namespace uxb {

int execute_task_backend(const TaskRecord& task, int input_value, int* output_value);
std::string active_backend_name();

} // namespace uxb
