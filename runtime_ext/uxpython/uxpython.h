#ifndef UXPYTHON_H
#define UXPYTHON_H

#include <stdint.h>

#ifdef _WIN32
#define UXPYTHON_API __declspec(dllexport)
#else
#define UXPYTHON_API __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

enum {
    UXPYTHON_FLAG_ISOLATED = 1,
    UXPYTHON_FLAG_IGNORE_ENVIRONMENT = 2,
    UXPYTHON_FLAG_NO_SITE = 4
};

UXPYTHON_API int uxpython_version(void);
UXPYTHON_API uint64_t uxpython_open(const char *python_home, const char *venv_path, const char *module_path, int flags);
UXPYTHON_API int uxpython_close(uint64_t session);
UXPYTHON_API int uxpython_is_ready(uint64_t session);
UXPYTHON_API int uxpython_add_path(uint64_t session, const char *path);
UXPYTHON_API const char * uxpython_last_error(uint64_t session);
UXPYTHON_API const char * uxpython_runtime_version(uint64_t session);

UXPYTHON_API uint64_t uxpython_import(uint64_t session, const char *module_name);
UXPYTHON_API uint64_t uxpython_get_attr(uint64_t session, uint64_t object_handle, const char *attribute_name);
UXPYTHON_API uint64_t uxpython_call_json(uint64_t session, uint64_t callable_handle, const char *args_json, const char *kwargs_json);
UXPYTHON_API uint64_t uxpython_call_module_json(uint64_t session, const char *module_name, const char *function_name, const char *args_json, const char *kwargs_json);

UXPYTHON_API int64_t uxpython_to_i64(uint64_t session, uint64_t object_handle);
UXPYTHON_API double uxpython_to_f64(uint64_t session, uint64_t object_handle);
UXPYTHON_API const char * uxpython_to_string(uint64_t session, uint64_t object_handle);
UXPYTHON_API const char * uxpython_to_json(uint64_t session, uint64_t object_handle);
UXPYTHON_API int uxpython_release(uint64_t session, uint64_t object_handle);
UXPYTHON_API int uxpython_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif
