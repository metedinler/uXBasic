// uXBasiC F128 runtime DLL.
// Backend: GCC __float128 + libquadmath.
// ABI rule: values are passed by pointer; results written to out pointer.

#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <quadmath.h>

#if defined(_WIN32)
#define UXB_EXPORT __declspec(dllexport)
#else
#define UXB_EXPORT
#endif

typedef __float128 uxb_f128;

UXB_EXPORT int uxb_f128_size(void) {
    return (int)sizeof(uxb_f128);
}

UXB_EXPORT int uxb_f128_storage_size(void) {
    return 16;
}

UXB_EXPORT void uxb_f128_zero(void *outp) {
    if (!outp) return;
    *((uxb_f128*)outp) = 0.0Q;
}

UXB_EXPORT void uxb_f128_from_str(const char *src, void *outp) {
    if (!src || !outp) return;
    *((uxb_f128*)outp) = strtoflt128(src, NULL);
}

UXB_EXPORT void uxb_f128_to_str(const void *a, char *outBuf, int outBytes) {
    if (!a || !outBuf || outBytes <= 0) return;
    quadmath_snprintf(outBuf, (size_t)outBytes, "%.36Qg", *((const uxb_f128*)a));
}

UXB_EXPORT void uxb_f128_copy(const void *src, void *outp) {
    if (!src || !outp) return;
    memcpy(outp, src, sizeof(uxb_f128));
}

UXB_EXPORT void uxb_f128_add(const void *a, const void *b, void *outp) {
    if (!a || !b || !outp) return;
    *((uxb_f128*)outp) = *((const uxb_f128*)a) + *((const uxb_f128*)b);
}

UXB_EXPORT void uxb_f128_sub(const void *a, const void *b, void *outp) {
    if (!a || !b || !outp) return;
    *((uxb_f128*)outp) = *((const uxb_f128*)a) - *((const uxb_f128*)b);
}

UXB_EXPORT void uxb_f128_mul(const void *a, const void *b, void *outp) {
    if (!a || !b || !outp) return;
    *((uxb_f128*)outp) = *((const uxb_f128*)a) * *((const uxb_f128*)b);
}

UXB_EXPORT void uxb_f128_div(const void *a, const void *b, void *outp) {
    if (!a || !b || !outp) return;
    *((uxb_f128*)outp) = *((const uxb_f128*)a) / *((const uxb_f128*)b);
}

UXB_EXPORT int uxb_f128_cmp(const void *a, const void *b) {
    if (!a || !b) return 0;
    const uxb_f128 av = *((const uxb_f128*)a);
    const uxb_f128 bv = *((const uxb_f128*)b);
    if (av < bv) return -1;
    if (av > bv) return 1;
    return 0;
}
