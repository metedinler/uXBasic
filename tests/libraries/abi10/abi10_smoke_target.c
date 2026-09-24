#include <stdint.h>
#include <stdlib.h>
#ifdef _WIN32
#define UXB_TEST_API __declspec(dllexport)
#else
#define UXB_TEST_API
#endif

typedef struct { double x; double y; } uxb_test_point;

UXB_TEST_API int32_t uxb_abi10_version(void) { return 100; }
UXB_TEST_API const char *uxb_abi10_text(void) { return "ABI10_TEXT_OK"; }
UXB_TEST_API int32_t uxb_abi10_sum10(
    int32_t a0,int32_t a1,int32_t a2,int32_t a3,int32_t a4,
    int32_t a5,int32_t a6,int32_t a7,int32_t a8,int32_t a9) {
    return a0+a1+a2+a3+a4+a5+a6+a7+a8+a9;
}
UXB_TEST_API double uxb_abi10_mix8(double a, int32_t b, double c, int32_t d,
                                   double e, int32_t f, double g, int32_t h) {
    return a+b+c+d+e+f+g+h;
}
UXB_TEST_API void *uxb_abi10_point_create(double x, double y) {
    uxb_test_point *p=(uxb_test_point*)calloc(1,sizeof(*p));
    if (p) { p->x=x; p->y=y; }
    return p;
}
UXB_TEST_API double uxb_abi10_point_sum(void *handle) {
    uxb_test_point *p=(uxb_test_point*)handle;
    return p ? p->x+p->y : -1.0;
}
UXB_TEST_API void uxb_abi10_point_free(void *handle) { free(handle); }
