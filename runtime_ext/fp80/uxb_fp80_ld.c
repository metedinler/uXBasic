#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <quadmath.h>

#ifdef _WIN32
#define UXB_API __declspec(dllexport)
#else
#define UXB_API
#endif

typedef long double UXB_F80;

static UXB_F80 uxb_f80_load(const void *p)
{
    UXB_F80 v = 0.0L;
    if (p != NULL) {
        memcpy(&v, p, sizeof(v));
    }
    return v;
}

static void uxb_f80_store(UXB_F80 v, void *outp)
{
    if (outp == NULL) {
        return;
    }
    memset(outp, 0, 16);
    memcpy(outp, &v, sizeof(v));
}

UXB_API int uxb_f80_size(void)
{
    return (int)sizeof(UXB_F80);
}

UXB_API int uxb_f80_storage_size(void)
{
    return 16;
}

UXB_API void uxb_f80_zero(void *outp)
{
    uxb_f80_store(0.0L, outp);
}

UXB_API void uxb_f80_from_str(const char *src, void *outp)
{
    UXB_F80 v = 0.0L;
    if (src != NULL) {
        v = strtold(src, NULL);
    }
    uxb_f80_store(v, outp);
}

UXB_API void uxb_f80_to_str(const void *a, char *outBuf, int outBytes)
{
    UXB_F80 v;
    int n;

    if (outBuf == NULL || outBytes <= 0) {
        return;
    }

    v = uxb_f80_load(a);
    n = quadmath_snprintf(outBuf, (size_t)outBytes, "%.21Qg", (__float128)v);
    if (n < 0) {
        outBuf[0] = '\0';
        return;
    }
    outBuf[outBytes - 1] = '\0';
}

UXB_API void uxb_f80_copy(const void *src, void *outp)
{
    uxb_f80_store(uxb_f80_load(src), outp);
}

UXB_API void uxb_f80_add(const void *a, const void *b, void *outp)
{
    uxb_f80_store(uxb_f80_load(a) + uxb_f80_load(b), outp);
}

UXB_API void uxb_f80_sub(const void *a, const void *b, void *outp)
{
    uxb_f80_store(uxb_f80_load(a) - uxb_f80_load(b), outp);
}

UXB_API void uxb_f80_mul(const void *a, const void *b, void *outp)
{
    uxb_f80_store(uxb_f80_load(a) * uxb_f80_load(b), outp);
}

UXB_API void uxb_f80_div(const void *a, const void *b, void *outp)
{
    uxb_f80_store(uxb_f80_load(a) / uxb_f80_load(b), outp);
}

UXB_API int uxb_f80_cmp(const void *a, const void *b)
{
    UXB_F80 av = uxb_f80_load(a);
    UXB_F80 bv = uxb_f80_load(b);
    if (av < bv) {
        return -1;
    }
    if (av > bv) {
        return 1;
    }
    return 0;
}
