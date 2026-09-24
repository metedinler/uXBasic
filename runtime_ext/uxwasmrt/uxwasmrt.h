#ifndef UXB_UXWASMRT_H
#define UXB_UXWASMRT_H
#include <stdint.h>

#if defined(_WIN32)
  #if defined(UXWASMRT_BUILD_DLL)
    #define UXWASMRT_API __declspec(dllexport)
  #else
    #define UXWASMRT_API __declspec(dllimport)
  #endif
#else
  #define UXWASMRT_API __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define UXWASMRT_API_VERSION 100
#define UXWASMRT_MAX_SESSIONS 64

UXWASMRT_API int32_t uxwasm_version(void);
UXWASMRT_API const char *uxwasm_provider(void);
UXWASMRT_API int32_t uxwasm_runtime_available(void);
UXWASMRT_API const char *uxwasm_runtime_path(void);

UXWASMRT_API int32_t uxwasm_validate_file(const char *path);
UXWASMRT_API int32_t uxwasm_open_file(const char *path);
UXWASMRT_API int32_t uxwasm_close(int32_t session_handle);
UXWASMRT_API int32_t uxwasm_has_export(int32_t session_handle, const char *export_name);

UXWASMRT_API int32_t uxwasm_call_i32_0(int32_t session_handle, const char *export_name);
UXWASMRT_API int32_t uxwasm_call_i32_1(int32_t session_handle, const char *export_name, int32_t a0);
UXWASMRT_API int32_t uxwasm_call_i32_2(int32_t session_handle, const char *export_name, int32_t a0, int32_t a1);
UXWASMRT_API int32_t uxwasm_call_i32_3(int32_t session_handle, const char *export_name, int32_t a0, int32_t a1, int32_t a2);
UXWASMRT_API int32_t uxwasm_call_i32_4(int32_t session_handle, const char *export_name, int32_t a0, int32_t a1, int32_t a2, int32_t a3);

UXWASMRT_API int32_t uxwasm_last_ok(int32_t session_handle);
UXWASMRT_API int32_t uxwasm_last_error_code(int32_t session_handle);
UXWASMRT_API const char *uxwasm_last_error(int32_t session_handle);
UXWASMRT_API void uxwasm_shutdown(void);

#ifdef __cplusplus
}
#endif
#endif
