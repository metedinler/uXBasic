#include "uxb_runtime.h"
#include "uxb_runtime_state.h"
#include "uxb_runtime_task.h"
#include "uxb_runtime_shell.h"
#include "backends/runtime_backend.h"
#include <exception>
#include <functional>
#include <string>

using uxb::RuntimeState;

static int guarded_bool(const char* operation, const std::function<bool()>& fn) {
    try { return fn() ? UXB_RT_SUCCESS : UXB_RT_FAILURE; }
    catch (const std::exception& ex) { RuntimeState::instance().set_error(std::string(operation)+": "+ex.what()); }
    catch (...) { RuntimeState::instance().set_error(std::string(operation)+": unknown exception"); }
    return UXB_RT_FAILURE;
}

UXB_RT_API int UXB_RT_CDECL uxb_rt_init(void) {
    return guarded_bool("uxb_rt_init", [](){ return RuntimeState::instance().init(); });
}
UXB_RT_API int UXB_RT_CDECL uxb_rt_shutdown(void) {
    try { RuntimeState::instance().shutdown(); return UXB_RT_SUCCESS; }
    catch (...) { return UXB_RT_FAILURE; }
}
UXB_RT_API int UXB_RT_CDECL uxb_rt_backend(char* out, int out_len) {
    uxb::copy_text(uxb::active_backend_name(), out, out_len); return UXB_RT_SUCCESS;
}
UXB_RT_API int UXB_RT_CDECL uxb_task_register(int slot_id, int task_type, const char* name) {
    return guarded_bool("uxb_task_register", [&](){ return RuntimeState::instance().register_task(slot_id, task_type, name); });
}
UXB_RT_API int UXB_RT_CDECL uxb_slot_bind(int slot_id, int task_type, const char* name) {
    return guarded_bool("uxb_slot_bind", [&](){ return RuntimeState::instance().bind_slot(slot_id, task_type, name); });
}
UXB_RT_API int UXB_RT_CDECL uxb_task_set_callback(int slot_id, uxb_task_callback callback, void* user_data) {
    return guarded_bool("uxb_task_set_callback", [&](){ return RuntimeState::instance().set_callback(slot_id, callback, user_data); });
}
UXB_RT_API int UXB_RT_CDECL uxb_slot_control(int slot_id, int state) {
    return guarded_bool("uxb_slot_control", [&](){ return RuntimeState::instance().control_slot(slot_id, state != 0); });
}
UXB_RT_API int UXB_RT_CDECL uxb_task_on(int slot_id) { return uxb_slot_control(slot_id, 1); }
UXB_RT_API int UXB_RT_CDECL uxb_task_off(int slot_id) { return uxb_slot_control(slot_id, 0); }
UXB_RT_API int UXB_RT_CDECL uxb_slot_on(int slot_id) { return uxb_slot_control(slot_id, 1); }
UXB_RT_API int UXB_RT_CDECL uxb_slot_off(int slot_id) { return uxb_slot_control(slot_id, 0); }
UXB_RT_API int UXB_RT_CDECL uxb_task_trigger(int slot_id, int input_value, int* output_value) {
    return uxb::execute_registered_task(slot_id, 0, input_value, output_value);
}
UXB_RT_API int UXB_RT_CDECL uxb_thread_start(int slot_id, int input_value, int* output_value) {
    return uxb::execute_registered_task(slot_id, UXB_RT_TASK_THREAD, input_value, output_value);
}
UXB_RT_API int UXB_RT_CDECL uxb_pipe_run(int slot_id, int input_value, int* output_value) {
    return uxb::execute_registered_task(slot_id, UXB_RT_TASK_PIPE, input_value, output_value);
}
UXB_RT_API int UXB_RT_CDECL uxb_parallel_run(int slot_id, int input_value, int* output_value) {
    return uxb::execute_registered_task(slot_id, UXB_RT_TASK_PARALEL, input_value, output_value);
}
UXB_RT_API int UXB_RT_CDECL uxb_shell_run(const char* command, const char* run_path, int timeout_ms,
                                            char* out, int out_len, char* err, int err_len, int* exit_code) {
    try {
        std::string stdout_text, stderr_text;
        int local_exit = 0;
        int rc = uxb::run_shell_process(command ? command : "", run_path ? run_path : "", timeout_ms,
                                        stdout_text, stderr_text, local_exit);
        uxb::copy_text(stdout_text, out, out_len); uxb::copy_text(stderr_text, err, err_len);
        if (exit_code) *exit_code = local_exit;
        return rc;
    } catch (const std::exception& ex) {
        RuntimeState::instance().set_error(std::string("uxb_shell_run: ")+ex.what()); return UXB_RT_FAILURE;
    } catch (...) {
        RuntimeState::instance().set_error("uxb_shell_run: unknown exception"); return UXB_RT_FAILURE;
    }
}
UXB_RT_API int UXB_RT_CDECL uxb_shell_start(const char* command, const char* run_path,
                                              const char* out_path, const char* err_path,
                                              int* exit_code) {
    try {
        int local_exit = 0;
        const int rc = uxb::start_shell_process(
            command ? command : "", run_path ? run_path : "",
            out_path ? out_path : "", err_path ? err_path : "", local_exit);
        if (exit_code) *exit_code = local_exit;
        return rc;
    } catch (const std::exception& ex) {
        RuntimeState::instance().set_error(std::string("uxb_shell_start: ") + ex.what());
        return UXB_RT_FAILURE;
    } catch (...) {
        RuntimeState::instance().set_error("uxb_shell_start: unknown exception");
        return UXB_RT_FAILURE;
    }
}
UXB_RT_API int UXB_RT_CDECL uxb_text_file_write(const char* path, const char* text) {
    try {
        return uxb::write_text_file(path ? path : "", text ? text : "");
    } catch (const std::exception& ex) {
        RuntimeState::instance().set_error(std::string("uxb_text_file_write: ") + ex.what());
        return UXB_RT_FAILURE;
    } catch (...) {
        RuntimeState::instance().set_error("uxb_text_file_write: unknown exception");
        return UXB_RT_FAILURE;
    }
}
UXB_RT_API const char* UXB_RT_CDECL uxb_last_error(void) { return RuntimeState::instance().last_error(); }
