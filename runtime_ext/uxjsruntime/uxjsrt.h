#ifndef UXJSRT_H
#define UXJSRT_H

#include <stdint.h>

#if defined(_WIN32)
  #if defined(UXJSRT_BUILD_DLL)
    #define UXJSRT_API __declspec(dllexport)
  #else
    #define UXJSRT_API __declspec(dllimport)
  #endif
  #define UXJSRT_CALL __cdecl
#else
  #define UXJSRT_API __attribute__((visibility("default")))
  #define UXJSRT_CALL
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define UXJSRT_API_VERSION 110
#define UXJSRT_CONTRACT_VERSION 1
#define UXJSRT_EVAL_MODULE 1
#define UXJSRT_EVAL_DRAIN_JOBS 2

UXJSRT_API int32_t UXJSRT_CALL uxjs_version(void);
UXJSRT_API int32_t UXJSRT_CALL uxjs_contract_version(void);
UXJSRT_API const char *UXJSRT_CALL uxjs_quickjs_version(void);

UXJSRT_API int32_t UXJSRT_CALL uxjs_runtime_create(void);
UXJSRT_API int32_t UXJSRT_CALL uxjs_runtime_free(int32_t runtime_handle);
UXJSRT_API int32_t UXJSRT_CALL uxjs_runtime_set_memory_limit_mb(int32_t runtime_handle, int32_t megabytes);
UXJSRT_API int32_t UXJSRT_CALL uxjs_runtime_set_stack_limit_kb(int32_t runtime_handle, int32_t kilobytes);
UXJSRT_API int32_t UXJSRT_CALL uxjs_runtime_set_time_limit_ms(int32_t runtime_handle, int32_t milliseconds);
UXJSRT_API int32_t UXJSRT_CALL uxjs_runtime_collect_garbage(int32_t runtime_handle);

UXJSRT_API int32_t UXJSRT_CALL uxjs_context_create(int32_t runtime_handle);
UXJSRT_API int32_t UXJSRT_CALL uxjs_context_free(int32_t context_handle);
UXJSRT_API int32_t UXJSRT_CALL uxjs_install_native_host(int32_t context_handle);
UXJSRT_API int32_t UXJSRT_CALL uxjs_bootstrap_uxb(int32_t context_handle, const char *core_path, const char *provider_path);

UXJSRT_API int32_t UXJSRT_CALL uxjs_eval(int32_t context_handle, const char *source, const char *filename, int32_t flags);
UXJSRT_API int32_t UXJSRT_CALL uxjs_eval_file(int32_t context_handle, const char *path, int32_t flags);
UXJSRT_API int32_t UXJSRT_CALL uxjs_execute_pending_jobs(int32_t runtime_handle, int32_t max_jobs);

UXJSRT_API int32_t UXJSRT_CALL uxjs_call_json(int32_t context_handle, const char *function_name, const char *arguments_json);
UXJSRT_API int32_t UXJSRT_CALL uxjs_call_json_await(int32_t context_handle, const char *function_name, const char *arguments_json, int32_t max_jobs);
UXJSRT_API const char *UXJSRT_CALL uxjs_result_json(int32_t context_handle, int32_t result_handle);
UXJSRT_API int32_t UXJSRT_CALL uxjs_result_free(int32_t context_handle, int32_t result_handle);

UXJSRT_API const char *UXJSRT_CALL uxjs_last_error(int32_t context_handle);
UXJSRT_API int32_t UXJSRT_CALL uxjs_context_clear_error(int32_t context_handle);

#ifdef __cplusplus
}
#endif

#endif
