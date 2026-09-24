#include "libuv_backend.h"
#if defined(UXB_WITH_LIBUV)
#include <uv.h>
#include <exception>
#include <string>

namespace uxb {
struct UvTaskData {
    TaskRecord task;
    int input_value = 0;
    int* output_value = nullptr;
    int rc = UXB_RT_FAILURE;
    std::string error;
};

static void uv_work(uv_work_t* request) {
    UvTaskData* data = static_cast<UvTaskData*>(request->data);
    try {
        data->rc = data->task.callback(data->task.slot_id, data->input_value, data->output_value, data->task.user_data);
    } catch (const std::exception& ex) {
        data->error = ex.what();
        data->rc = UXB_RT_FAILURE;
    } catch (...) {
        data->error = "unknown callback exception";
        data->rc = UXB_RT_FAILURE;
    }
}

static void uv_after(uv_work_t*, int) {}

int execute_libuv_backend(const TaskRecord& task, int input_value, int* output_value) {
    uv_loop_t loop;
    if (uv_loop_init(&loop) != 0) {
        RuntimeState::instance().set_error("uv_loop_init failed");
        return UXB_RT_FAILURE;
    }
    UvTaskData data;
    data.task = task;
    data.input_value = input_value;
    data.output_value = output_value;
    uv_work_t request;
    request.data = &data;
    const int queue_rc = uv_queue_work(&loop, &request, uv_work, uv_after);
    if (queue_rc != 0) {
        RuntimeState::instance().set_error(std::string("uv_queue_work failed: ") + uv_strerror(queue_rc));
        uv_loop_close(&loop);
        return UXB_RT_FAILURE;
    }
    uv_run(&loop, UV_RUN_DEFAULT);
    uv_loop_close(&loop);
    if (!data.error.empty()) RuntimeState::instance().set_error(data.error);
    return data.rc;
}

bool libuv_backend_available() { return true; }
} // namespace uxb
#else
namespace uxb {
int execute_libuv_backend(const TaskRecord&, int, int*) { return UXB_RT_FAILURE; }
bool libuv_backend_available() { return false; }
}
#endif
