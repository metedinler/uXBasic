#pragma once
#include "../uxb_runtime_state.h"
namespace uxb {
int execute_tbb_backend(const TaskRecord& task, int input_value, int* output_value);
bool tbb_backend_available();
}
