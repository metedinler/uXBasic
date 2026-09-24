#ifndef UXFFI_H
#define UXFFI_H
#include <stdint.h>
#ifdef _WIN32
#define UXFFI_API __declspec(dllexport)
#else
#define UXFFI_API
#endif
#ifdef __cplusplus
extern "C" {
#endif

#define UXFFI_API_VERSION 131
#define UXFFI_MAX_ARGS 10

enum {
    UXFFI_VOID = 0,
    UXFFI_I32 = 1,
    UXFFI_U32 = 2,
    UXFFI_I64 = 3,
    UXFFI_U64 = 4,
    UXFFI_F64 = 5,
    UXFFI_PTR = 6,
    UXFFI_STRPTR = 7
};

UXFFI_API int uxffi_version(void);
UXFFI_API int uxffi_max_args(void);
UXFFI_API int uxffi_invoke10(
    const char *dll_name,
    const char *symbol_name,
    int return_kind,
    int arg_count,
    const int *arg_kinds,
    const uint64_t *arg_u64,
    const double *arg_f64,
    uint64_t *return_u64,
    double *return_f64,
    char *error_text,
    int error_capacity
);
UXFFI_API int uxffi_string_length(uint32_t token);
UXFFI_API int uxffi_copy_string(uint32_t token, char *out_text, int out_capacity);
UXFFI_API int uxffi_release_handle(uint32_t token);
UXFFI_API void uxffi_clear_handles(void);
UXFFI_API void uxffi_shutdown(void);

#ifdef __cplusplus
}
#endif
#endif
