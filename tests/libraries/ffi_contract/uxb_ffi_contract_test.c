#include <stdint.h>

#if defined(_WIN32)
#define UXB_TEST_API __declspec(dllexport)
#else
#define UXB_TEST_API __attribute__((visibility("default")))
#endif

UXB_TEST_API double uxb_ffi_f64_from_i32(int32_t value) {
    return (double)value + 0.5;
}

UXB_TEST_API int64_t uxb_ffi_sum10_i32(
    int32_t a1,
    int32_t a2,
    int32_t a3,
    int32_t a4,
    int32_t a5,
    int32_t a6,
    int32_t a7,
    int32_t a8,
    int32_t a9,
    int32_t a10
) {
    return (int64_t)a1 + a2 + a3 + a4 + a5 +
           a6 + a7 + a8 + a9 + a10;
}

UXB_TEST_API const char *uxb_ffi_echo(const char *text) {
    return text ? text : "";
}
