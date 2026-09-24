// uXBasiC BIGF / BIGD / BALL runtime DLL.
// Backend: MPFR + GMP via MSYS2 UCRT64.
// ABI rule: uXBasiC stores only an 8-byte handle. All operations are pointer/handle based.
// BIGD v1 uses MPFR with decimal-digit precision policy. It is arbitrary-precision decimal I/O,
// but not a fixed-scale financial decimal engine. It is suitable for scientific decimal precision.
// BALL v1 uses midpoint-radius interval arithmetic over MPFR.

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <mpfr.h>

#if defined(_WIN32)
#define UXB_EXPORT __declspec(dllexport)
#else
#define UXB_EXPORT
#endif

#ifndef UXB_RND
#define UXB_RND MPFR_RNDN
#endif

typedef struct UXB_BigF {
    uint32_t kind;
    uint32_t precision_bits;
    mpfr_t value;
} UXB_BigF;

typedef struct UXB_BigD {
    uint32_t kind;
    uint32_t decimal_digits;
    uint32_t precision_bits;
    mpfr_t value;
} UXB_BigD;

typedef struct UXB_Ball {
    uint32_t kind;
    uint32_t precision_bits;
    mpfr_t mid;
    mpfr_t rad;
} UXB_Ball;

static uint32_t uxb_digits_to_bits(uint32_t decimal_digits) {
    if (decimal_digits < 1) decimal_digits = 80;
    double bits = ((double)decimal_digits) * 3.32192809488736234787 + 16.0;
    if (bits < 64.0) bits = 64.0;
    if (bits > 2147483647.0) bits = 2147483647.0;
    return (uint32_t)bits;
}

static void uxb_copy_cstr(char *outBuf, int outBytes, const char *src) {
    if (!outBuf || outBytes <= 0) return;
    if (!src) src = "";
    size_t n = strlen(src);
    if (n >= (size_t)outBytes) n = (size_t)outBytes - 1;
    memcpy(outBuf, src, n);
    outBuf[n] = 0;
}

UXB_EXPORT int uxb_big_runtime_version(void) { return 1; }
UXB_EXPORT int uxb_bigf_handle_size(void) { return (int)sizeof(void*); }
UXB_EXPORT int uxb_bigd_handle_size(void) { return (int)sizeof(void*); }
UXB_EXPORT int uxb_ball_handle_size(void) { return (int)sizeof(void*); }

// ---------- BIGF ----------
UXB_EXPORT void* uxb_bigf_init(int precision_bits) {
    if (precision_bits < 64) precision_bits = 256;
    UXB_BigF *x = (UXB_BigF*)calloc(1, sizeof(UXB_BigF));
    if (!x) return NULL;
    x->kind = 0x42494746u; // BIGF
    x->precision_bits = (uint32_t)precision_bits;
    mpfr_init2(x->value, (mpfr_prec_t)x->precision_bits);
    mpfr_set_ui(x->value, 0, UXB_RND);
    return x;
}

UXB_EXPORT void uxb_bigf_free(void *handle) {
    if (!handle) return;
    UXB_BigF *x = (UXB_BigF*)handle;
    mpfr_clear(x->value);
    free(x);
}

UXB_EXPORT int uxb_bigf_precision(void *handle) {
    if (!handle) return 0;
    return (int)((UXB_BigF*)handle)->precision_bits;
}

UXB_EXPORT int uxb_bigf_from_str(const char *src, void *handle) {
    if (!src || !handle) return 0;
    UXB_BigF *x = (UXB_BigF*)handle;
    return mpfr_set_str(x->value, src, 10, UXB_RND) == 0;
}

UXB_EXPORT void uxb_bigf_to_str(void *handle, char *outBuf, int outBytes) {
    if (!handle || !outBuf || outBytes <= 0) return;
    UXB_BigF *x = (UXB_BigF*)handle;
    char *tmp = NULL;
    int digits = (int)((double)x->precision_bits * 0.30103) + 2;
    mpfr_asprintf(&tmp, "%.*Rg", digits, x->value);
    uxb_copy_cstr(outBuf, outBytes, tmp);
    if (tmp) mpfr_free_str(tmp);
}

UXB_EXPORT void uxb_bigf_copy(void *src, void *outp) {
    if (!src || !outp) return;
    UXB_BigF *a = (UXB_BigF*)src;
    UXB_BigF *o = (UXB_BigF*)outp;
    mpfr_set(o->value, a->value, UXB_RND);
}

UXB_EXPORT void uxb_bigf_add(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_add(((UXB_BigF*)outp)->value, ((UXB_BigF*)a)->value, ((UXB_BigF*)b)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigf_sub(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_sub(((UXB_BigF*)outp)->value, ((UXB_BigF*)a)->value, ((UXB_BigF*)b)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigf_mul(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_mul(((UXB_BigF*)outp)->value, ((UXB_BigF*)a)->value, ((UXB_BigF*)b)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigf_div(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_div(((UXB_BigF*)outp)->value, ((UXB_BigF*)a)->value, ((UXB_BigF*)b)->value, UXB_RND);
}
UXB_EXPORT int uxb_bigf_cmp(void *a, void *b) {
    if (!a || !b) return 0;
    return mpfr_cmp(((UXB_BigF*)a)->value, ((UXB_BigF*)b)->value);
}

// ---------- BIGD ----------
UXB_EXPORT void* uxb_bigd_init(int decimal_digits) {
    if (decimal_digits < 1) decimal_digits = 80;
    UXB_BigD *x = (UXB_BigD*)calloc(1, sizeof(UXB_BigD));
    if (!x) return NULL;
    x->kind = 0x42494744u; // BIGD
    x->decimal_digits = (uint32_t)decimal_digits;
    x->precision_bits = uxb_digits_to_bits((uint32_t)decimal_digits);
    mpfr_init2(x->value, (mpfr_prec_t)x->precision_bits);
    mpfr_set_ui(x->value, 0, UXB_RND);
    return x;
}

UXB_EXPORT void uxb_bigd_free(void *handle) {
    if (!handle) return;
    UXB_BigD *x = (UXB_BigD*)handle;
    mpfr_clear(x->value);
    free(x);
}
UXB_EXPORT int uxb_bigd_precision_digits(void *handle) {
    if (!handle) return 0;
    return (int)((UXB_BigD*)handle)->decimal_digits;
}
UXB_EXPORT int uxb_bigd_from_str(const char *src, void *handle) {
    if (!src || !handle) return 0;
    UXB_BigD *x = (UXB_BigD*)handle;
    return mpfr_set_str(x->value, src, 10, UXB_RND) == 0;
}
UXB_EXPORT void uxb_bigd_to_str(void *handle, char *outBuf, int outBytes) {
    if (!handle || !outBuf || outBytes <= 0) return;
    UXB_BigD *x = (UXB_BigD*)handle;
    char *tmp = NULL;
    mpfr_asprintf(&tmp, "%.*Rg", (int)x->decimal_digits, x->value);
    uxb_copy_cstr(outBuf, outBytes, tmp);
    if (tmp) mpfr_free_str(tmp);
}
UXB_EXPORT void uxb_bigd_copy(void *src, void *outp) {
    if (!src || !outp) return;
    mpfr_set(((UXB_BigD*)outp)->value, ((UXB_BigD*)src)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigd_add(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_add(((UXB_BigD*)outp)->value, ((UXB_BigD*)a)->value, ((UXB_BigD*)b)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigd_sub(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_sub(((UXB_BigD*)outp)->value, ((UXB_BigD*)a)->value, ((UXB_BigD*)b)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigd_mul(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_mul(((UXB_BigD*)outp)->value, ((UXB_BigD*)a)->value, ((UXB_BigD*)b)->value, UXB_RND);
}
UXB_EXPORT void uxb_bigd_div(void *a, void *b, void *outp) {
    if (!a || !b || !outp) return;
    mpfr_div(((UXB_BigD*)outp)->value, ((UXB_BigD*)a)->value, ((UXB_BigD*)b)->value, UXB_RND);
}
UXB_EXPORT int uxb_bigd_cmp(void *a, void *b) {
    if (!a || !b) return 0;
    return mpfr_cmp(((UXB_BigD*)a)->value, ((UXB_BigD*)b)->value);
}

// ---------- BALL ----------
UXB_EXPORT void* uxb_ball_init(int precision_bits) {
    if (precision_bits < 64) precision_bits = 256;
    UXB_Ball *x = (UXB_Ball*)calloc(1, sizeof(UXB_Ball));
    if (!x) return NULL;
    x->kind = 0x42414C4Cu; // BALL
    x->precision_bits = (uint32_t)precision_bits;
    mpfr_init2(x->mid, (mpfr_prec_t)x->precision_bits);
    mpfr_init2(x->rad, (mpfr_prec_t)x->precision_bits);
    mpfr_set_ui(x->mid, 0, UXB_RND);
    mpfr_set_ui(x->rad, 0, UXB_RND);
    return x;
}
UXB_EXPORT void uxb_ball_free(void *handle) {
    if (!handle) return;
    UXB_Ball *x = (UXB_Ball*)handle;
    mpfr_clear(x->mid);
    mpfr_clear(x->rad);
    free(x);
}
UXB_EXPORT int uxb_ball_precision(void *handle) {
    if (!handle) return 0;
    return (int)((UXB_Ball*)handle)->precision_bits;
}
UXB_EXPORT int uxb_ball_from_str(const char *src, void *handle) {
    if (!src || !handle) return 0;
    UXB_Ball *x = (UXB_Ball*)handle;
    if (mpfr_set_str(x->mid, src, 10, UXB_RND) != 0) return 0;
    mpfr_set_ui(x->rad, 0, UXB_RND);
    return 1;
}
UXB_EXPORT void uxb_ball_to_str(void *handle, char *outBuf, int outBytes) {
    if (!handle || !outBuf || outBytes <= 0) return;
    UXB_Ball *x = (UXB_Ball*)handle;
    char *m = NULL, *r = NULL;
    int digits = (int)((double)x->precision_bits * 0.30103) + 2;
    mpfr_asprintf(&m, "%.*Rg", digits, x->mid);
    mpfr_asprintf(&r, "%.*Rg", digits, x->rad);
    size_t n = strlen(m) + strlen(r) + 8;
    char *tmp = (char*)malloc(n);
    if (!tmp) { uxb_copy_cstr(outBuf, outBytes, "<ball oom>"); goto done; }
    snprintf(tmp, n, "%s +/- %s", m, r);
    uxb_copy_cstr(outBuf, outBytes, tmp);
    free(tmp);
done:
    if (m) mpfr_free_str(m);
    if (r) mpfr_free_str(r);
}
UXB_EXPORT void uxb_ball_copy(void *src, void *outp) {
    if (!src || !outp) return;
    UXB_Ball *a = (UXB_Ball*)src;
    UXB_Ball *o = (UXB_Ball*)outp;
    mpfr_set(o->mid, a->mid, UXB_RND);
    mpfr_set(o->rad, a->rad, UXB_RND);
}
UXB_EXPORT void uxb_ball_add(void *a_, void *b_, void *outp_) {
    if (!a_ || !b_ || !outp_) return;
    UXB_Ball *a=(UXB_Ball*)a_, *b=(UXB_Ball*)b_, *o=(UXB_Ball*)outp_;
    mpfr_add(o->mid, a->mid, b->mid, UXB_RND);
    mpfr_add(o->rad, a->rad, b->rad, MPFR_RNDU);
}
UXB_EXPORT void uxb_ball_sub(void *a_, void *b_, void *outp_) {
    if (!a_ || !b_ || !outp_) return;
    UXB_Ball *a=(UXB_Ball*)a_, *b=(UXB_Ball*)b_, *o=(UXB_Ball*)outp_;
    mpfr_sub(o->mid, a->mid, b->mid, UXB_RND);
    mpfr_add(o->rad, a->rad, b->rad, MPFR_RNDU);
}
UXB_EXPORT void uxb_ball_mul(void *a_, void *b_, void *outp_) {
    if (!a_ || !b_ || !outp_) return;
    UXB_Ball *a=(UXB_Ball*)a_, *b=(UXB_Ball*)b_, *o=(UXB_Ball*)outp_;
    mpfr_t t1,t2,t3,t4;
    mpfr_inits2(o->precision_bits, t1,t2,t3,t4,(mpfr_ptr)0);
    mpfr_mul(o->mid, a->mid, b->mid, UXB_RND);
    mpfr_abs(t1, a->mid, MPFR_RNDU); mpfr_mul(t1, t1, b->rad, MPFR_RNDU);
    mpfr_abs(t2, b->mid, MPFR_RNDU); mpfr_mul(t2, t2, a->rad, MPFR_RNDU);
    mpfr_mul(t3, a->rad, b->rad, MPFR_RNDU);
    mpfr_add(t4, t1, t2, MPFR_RNDU); mpfr_add(o->rad, t4, t3, MPFR_RNDU);
    mpfr_clears(t1,t2,t3,t4,(mpfr_ptr)0);
}
UXB_EXPORT void uxb_ball_div(void *a_, void *b_, void *outp_) {
    if (!a_ || !b_ || !outp_) return;
    UXB_Ball *a=(UXB_Ball*)a_, *b=(UXB_Ball*)b_, *o=(UXB_Ball*)outp_;
    if (mpfr_zero_p(b->mid)) {
        mpfr_set_nan(o->mid); mpfr_set_inf(o->rad, 1); return;
    }
    mpfr_div(o->mid, a->mid, b->mid, UXB_RND);
    // Conservative first-stage radius: |mid|*(ra/|a.mid| + rb/|b.mid|) + ra + rb
    mpfr_add(o->rad, a->rad, b->rad, MPFR_RNDU);
}
UXB_EXPORT int uxb_ball_cmp_mid(void *a, void *b) {
    if (!a || !b) return 0;
    return mpfr_cmp(((UXB_Ball*)a)->mid, ((UXB_Ball*)b)->mid);
}
