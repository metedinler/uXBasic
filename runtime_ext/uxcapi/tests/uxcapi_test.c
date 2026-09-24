#include <stdint.h>
#include <stdarg.h>

#if defined(_WIN32)
#define TEST_API __declspec(dllexport)
#else
#define TEST_API __attribute__((visibility("default")))
#endif

TEST_API int64_t uxc_test_sum12(
    int64_t a1, int64_t a2, int64_t a3, int64_t a4,
    int64_t a5, int64_t a6, int64_t a7, int64_t a8,
    int64_t a9, int64_t a10, int64_t a11, int64_t a12
) {
    return a1+a2+a3+a4+a5+a6+a7+a8+a9+a10+a11+a12;
}

TEST_API int64_t uxc_test_variadic_sum(int32_t count, ...) {
    int32_t i;
    int64_t result = 0;
    va_list ap;
    va_start(ap, count);
    for (i = 0; i < count; ++i) {
        result += va_arg(ap, int64_t);
    }
    va_end(ap);
    return result;
}

typedef int32_t (*uxc_test_callback)(int32_t value, const char *text);

TEST_API int32_t uxc_test_call_callback(
    uxc_test_callback callback,
    int32_t value,
    const char *text
) {
    if (!callback) return -1;
    return callback(value, text);
}
