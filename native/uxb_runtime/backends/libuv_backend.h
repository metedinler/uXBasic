#pragma once
#include "../uxb_runtime_state.h"
namespace uxb {
int execute_libuv_backend(const TaskRecord& task, int input_value, int* output_value);
bool libuv_backend_available();
}
