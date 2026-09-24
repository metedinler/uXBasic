#include "tbb_backend.h"
#if defined(UXB_WITH_TBB)
#include <oneapi/tbb/global_control.h>
#include <oneapi/tbb/task_group.h>
#include <cstdlib>
#include <exception>
#include <memory>
#include <string>

namespace uxb {
int execute_tbb_backend(const TaskRecord& task, int input_value, int* output_value) {
    int rc = UXB_RT_FAILURE;
    std::string error;
    int thread_count = 0;
    if (const char* env = std::getenv("UXB_TBB_THREADS")) thread_count = std::atoi(env);
    std::unique_ptr<oneapi::tbb::global_control> control;
    if (thread_count > 0) {
        control = std::make_unique<oneapi::tbb::global_control>(
            oneapi::tbb::global_control::max_allowed_parallelism,
            static_cast<size_t>(thread_count));
    }
    try {
        oneapi::tbb::task_group group;
        group.run([&]() {
            try {
                rc = task.callback(task.slot_id, input_value, output_value, task.user_data);
            } catch (const std::exception& ex) {
                error = ex.what();
                rc = UXB_RT_FAILURE;
            } catch (...) {
                error = "unknown callback exception";
                rc = UXB_RT_FAILURE;
            }
        });
        group.wait();
    } catch (const std::exception& ex) {
        RuntimeState::instance().set_error(std::string("oneTBB error: ") + ex.what());
        return UXB_RT_FAILURE;
    }
    if (!error.empty()) RuntimeState::instance().set_error(error);
    return rc;
}

bool tbb_backend_available() { return true; }
} // namespace uxb
#else
namespace uxb {
int execute_tbb_backend(const TaskRecord&, int, int*) { return UXB_RT_FAILURE; }
bool tbb_backend_available() { return false; }
}
#endif
