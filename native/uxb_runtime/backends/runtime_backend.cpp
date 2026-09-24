#include "runtime_backend.h"
#include "std_backend.h"
#include "libuv_backend.h"
#include "tbb_backend.h"
#include <algorithm>
#include <cctype>
#include <cstdlib>

namespace uxb {

static std::string mode() {
    const char* raw = std::getenv("UXB_RT_BACKEND");
    std::string value = raw ? raw : "auto";
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char c){ return static_cast<char>(std::tolower(c)); });
    if (value != "auto" && value != "std" && value != "libuv" && value != "tbb") value = "auto";
    return value;
}

int execute_task_backend(const TaskRecord& task, int input_value, int* output_value) {
    const std::string selected = mode();
    if (selected == "std") return execute_std_backend(task, input_value, output_value);
    if (selected == "libuv") {
        if (libuv_backend_available()) return execute_libuv_backend(task, input_value, output_value);
        return execute_std_backend(task, input_value, output_value);
    }
    if (selected == "tbb") {
        if (task.task_type == UXB_RT_TASK_PARALEL && tbb_backend_available())
            return execute_tbb_backend(task, input_value, output_value);
        return execute_std_backend(task, input_value, output_value);
    }
    if (task.task_type == UXB_RT_TASK_PARALEL && tbb_backend_available())
        return execute_tbb_backend(task, input_value, output_value);
    if (libuv_backend_available())
        return execute_libuv_backend(task, input_value, output_value);
    return execute_std_backend(task, input_value, output_value);
}

std::string active_backend_name() {
    const std::string selected = mode();
    if (selected == "std") return "std";
    if (selected == "libuv") return libuv_backend_available() ? "libuv" : "std(fallback)";
    if (selected == "tbb") return tbb_backend_available() ? "tbb+std" : "std(fallback)";
    if (libuv_backend_available() && tbb_backend_available()) return "auto(libuv+tbb)";
    if (libuv_backend_available()) return "auto(libuv)";
    if (tbb_backend_available()) return "auto(tbb+std)";
    return "auto(std)";
}

} // namespace uxb
