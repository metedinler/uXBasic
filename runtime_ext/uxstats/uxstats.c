/*
  uXBasic Standard Statistics Runtime DLL
  Backend: plain ISO C + <math.h>, no heavy external dependency.
  ABI: CDECL, exported symbols, handle-backed vector API + raw double pointer API.

  This library is intentionally small and stable so uXBasic can include it via
  libs/uxstats/uxstats.bas without adding new language keywords.
*/

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

#if defined(_WIN32)
#define UXSTATS_EXPORT __declspec(dllexport)
#else
#define UXSTATS_EXPORT
#endif

typedef struct UXStatsVec {
    int32_t count;
    int32_t capacity;
    double *data;
} UXStatsVec;

static int uxstats_is_valid_vec(const UXStatsVec *v) {
    return v != NULL && v->capacity >= 0 && v->count >= 0 && v->count <= v->capacity;
}

static int uxstats_ensure_capacity(UXStatsVec *v, int32_t needed) {
    if (!v) return 0;
    if (needed <= v->capacity) return 1;
    int32_t newcap = v->capacity > 0 ? v->capacity : 8;
    while (newcap < needed) {
        if (newcap > 1073741823) return 0;
        newcap *= 2;
    }
    double *p = (double*)realloc(v->data, (size_t)newcap * sizeof(double));
    if (!p) return 0;
    v->data = p;
    v->capacity = newcap;
    return 1;
}

static int cmp_double(const void *a, const void *b) {
    double da = *(const double*)a;
    double db = *(const double*)b;
    if (da < db) return -1;
    if (da > db) return 1;
    return 0;
}

UXSTATS_EXPORT int uxstats_version(void) { return 1; }

UXSTATS_EXPORT void* uxstats_vec_create(int32_t capacity) {
    if (capacity < 0) capacity = 0;
    UXStatsVec *v = (UXStatsVec*)calloc(1, sizeof(UXStatsVec));
    if (!v) return NULL;
    v->count = 0;
    v->capacity = 0;
    v->data = NULL;
    if (capacity > 0 && !uxstats_ensure_capacity(v, capacity)) {
        free(v);
        return NULL;
    }
    return v;
}

UXSTATS_EXPORT void uxstats_vec_free(void *handle) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!v) return;
    free(v->data);
    v->data = NULL;
    free(v);
}

UXSTATS_EXPORT void uxstats_vec_clear(void *handle) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!uxstats_is_valid_vec(v)) return;
    v->count = 0;
}

UXSTATS_EXPORT int32_t uxstats_vec_count(void *handle) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!uxstats_is_valid_vec(v)) return 0;
    return v->count;
}

UXSTATS_EXPORT int32_t uxstats_vec_capacity(void *handle) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!uxstats_is_valid_vec(v)) return 0;
    return v->capacity;
}

UXSTATS_EXPORT int32_t uxstats_vec_push(void *handle, double value) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!uxstats_is_valid_vec(v)) return 0;
    if (!uxstats_ensure_capacity(v, v->count + 1)) return 0;
    v->data[v->count++] = value;
    return 1;
}

UXSTATS_EXPORT int32_t uxstats_vec_set(void *handle, int32_t index, double value) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!uxstats_is_valid_vec(v)) return 0;
    if (index < 0 || index >= v->count) return 0;
    v->data[index] = value;
    return 1;
}

UXSTATS_EXPORT double uxstats_vec_get(void *handle, int32_t index) {
    UXStatsVec *v = (UXStatsVec*)handle;
    if (!uxstats_is_valid_vec(v)) return NAN;
    if (index < 0 || index >= v->count) return NAN;
    return v->data[index];
}

UXSTATS_EXPORT double uxstats_sum_f64(const double *x, int32_t n) {
    if (!x || n <= 0) return NAN;
    double s = 0.0;
    for (int32_t i = 0; i < n; ++i) s += x[i];
    return s;
}

UXSTATS_EXPORT double uxstats_mean_f64(const double *x, int32_t n) {
    if (!x || n <= 0) return NAN;
    return uxstats_sum_f64(x, n) / (double)n;
}

UXSTATS_EXPORT double uxstats_min_f64(const double *x, int32_t n) {
    if (!x || n <= 0) return NAN;
    double m = x[0];
    for (int32_t i = 1; i < n; ++i) if (x[i] < m) m = x[i];
    return m;
}

UXSTATS_EXPORT double uxstats_max_f64(const double *x, int32_t n) {
    if (!x || n <= 0) return NAN;
    double m = x[0];
    for (int32_t i = 1; i < n; ++i) if (x[i] > m) m = x[i];
    return m;
}

UXSTATS_EXPORT double uxstats_variance_pop_f64(const double *x, int32_t n) {
    if (!x || n <= 0) return NAN;
    double mean = uxstats_mean_f64(x, n);
    double ss = 0.0;
    for (int32_t i = 0; i < n; ++i) {
        double d = x[i] - mean;
        ss += d * d;
    }
    return ss / (double)n;
}

UXSTATS_EXPORT double uxstats_variance_samp_f64(const double *x, int32_t n) {
    if (!x || n <= 1) return NAN;
    double mean = uxstats_mean_f64(x, n);
    double ss = 0.0;
    for (int32_t i = 0; i < n; ++i) {
        double d = x[i] - mean;
        ss += d * d;
    }
    return ss / (double)(n - 1);
}

UXSTATS_EXPORT double uxstats_stddev_pop_f64(const double *x, int32_t n) {
    double v = uxstats_variance_pop_f64(x, n);
    return isnan(v) ? NAN : sqrt(v);
}

UXSTATS_EXPORT double uxstats_stddev_samp_f64(const double *x, int32_t n) {
    double v = uxstats_variance_samp_f64(x, n);
    return isnan(v) ? NAN : sqrt(v);
}

UXSTATS_EXPORT double uxstats_median_f64(const double *x, int32_t n) {
    if (!x || n <= 0) return NAN;
    double *tmp = (double*)malloc((size_t)n * sizeof(double));
    if (!tmp) return NAN;
    memcpy(tmp, x, (size_t)n * sizeof(double));
    qsort(tmp, (size_t)n, sizeof(double), cmp_double);
    double r;
    if ((n & 1) != 0) r = tmp[n / 2];
    else r = (tmp[n / 2 - 1] + tmp[n / 2]) / 2.0;
    free(tmp);
    return r;
}

UXSTATS_EXPORT double uxstats_percentile_f64(const double *x, int32_t n, double p) {
    if (!x || n <= 0) return NAN;
    if (p < 0.0) p = 0.0;
    if (p > 100.0) p = 100.0;
    double *tmp = (double*)malloc((size_t)n * sizeof(double));
    if (!tmp) return NAN;
    memcpy(tmp, x, (size_t)n * sizeof(double));
    qsort(tmp, (size_t)n, sizeof(double), cmp_double);
    double pos = (p / 100.0) * (double)(n - 1);
    int32_t lo = (int32_t)floor(pos);
    int32_t hi = (int32_t)ceil(pos);
    double frac = pos - (double)lo;
    double r = tmp[lo] * (1.0 - frac) + tmp[hi] * frac;
    free(tmp);
    return r;
}

UXSTATS_EXPORT double uxstats_covariance_samp_f64(const double *x, const double *y, int32_t n) {
    if (!x || !y || n <= 1) return NAN;
    double mx = uxstats_mean_f64(x, n);
    double my = uxstats_mean_f64(y, n);
    double s = 0.0;
    for (int32_t i = 0; i < n; ++i) s += (x[i] - mx) * (y[i] - my);
    return s / (double)(n - 1);
}

UXSTATS_EXPORT double uxstats_correlation_f64(const double *x, const double *y, int32_t n) {
    if (!x || !y || n <= 1) return NAN;
    double sx = uxstats_stddev_samp_f64(x, n);
    double sy = uxstats_stddev_samp_f64(y, n);
    if (sx == 0.0 || sy == 0.0 || isnan(sx) || isnan(sy)) return NAN;
    return uxstats_covariance_samp_f64(x, y, n) / (sx * sy);
}

UXSTATS_EXPORT double uxstats_regression_slope_f64(const double *x, const double *y, int32_t n) {
    if (!x || !y || n <= 1) return NAN;
    double mx = uxstats_mean_f64(x, n);
    double my = uxstats_mean_f64(y, n);
    double num = 0.0;
    double den = 0.0;
    for (int32_t i = 0; i < n; ++i) {
        double dx = x[i] - mx;
        num += dx * (y[i] - my);
        den += dx * dx;
    }
    if (den == 0.0) return NAN;
    return num / den;
}

UXSTATS_EXPORT double uxstats_regression_intercept_f64(const double *x, const double *y, int32_t n) {
    double b = uxstats_regression_slope_f64(x, y, n);
    if (isnan(b)) return NAN;
    return uxstats_mean_f64(y, n) - b * uxstats_mean_f64(x, n);
}

UXSTATS_EXPORT double uxstats_regression_r2_f64(const double *x, const double *y, int32_t n) {
    double r = uxstats_correlation_f64(x, y, n);
    return isnan(r) ? NAN : r * r;
}

// Handle-backed vector wrappers.
UXSTATS_EXPORT double uxstats_vec_sum(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_sum_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_mean(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_mean_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_min(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_min_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_max(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_max_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_range(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_max_f64(v->data, v->count) - uxstats_min_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_variance_pop(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_variance_pop_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_variance_samp(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_variance_samp_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_stddev_pop(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_stddev_pop_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_stddev_samp(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_stddev_samp_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_median(void *h) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_median_f64(v->data, v->count) : NAN; }
UXSTATS_EXPORT double uxstats_vec_percentile(void *h, double p) { UXStatsVec *v=(UXStatsVec*)h; return uxstats_is_valid_vec(v) ? uxstats_percentile_f64(v->data, v->count, p) : NAN; }

UXSTATS_EXPORT double uxstats_vec_covariance_samp(void *hx, void *hy) {
    UXStatsVec *x=(UXStatsVec*)hx, *y=(UXStatsVec*)hy;
    if (!uxstats_is_valid_vec(x) || !uxstats_is_valid_vec(y)) return NAN;
    int32_t n = x->count < y->count ? x->count : y->count;
    return uxstats_covariance_samp_f64(x->data, y->data, n);
}

UXSTATS_EXPORT double uxstats_vec_correlation(void *hx, void *hy) {
    UXStatsVec *x=(UXStatsVec*)hx, *y=(UXStatsVec*)hy;
    if (!uxstats_is_valid_vec(x) || !uxstats_is_valid_vec(y)) return NAN;
    int32_t n = x->count < y->count ? x->count : y->count;
    return uxstats_correlation_f64(x->data, y->data, n);
}

UXSTATS_EXPORT double uxstats_vec_regression_slope(void *hx, void *hy) {
    UXStatsVec *x=(UXStatsVec*)hx, *y=(UXStatsVec*)hy;
    if (!uxstats_is_valid_vec(x) || !uxstats_is_valid_vec(y)) return NAN;
    int32_t n = x->count < y->count ? x->count : y->count;
    return uxstats_regression_slope_f64(x->data, y->data, n);
}

UXSTATS_EXPORT double uxstats_vec_regression_intercept(void *hx, void *hy) {
    UXStatsVec *x=(UXStatsVec*)hx, *y=(UXStatsVec*)hy;
    if (!uxstats_is_valid_vec(x) || !uxstats_is_valid_vec(y)) return NAN;
    int32_t n = x->count < y->count ? x->count : y->count;
    return uxstats_regression_intercept_f64(x->data, y->data, n);
}

UXSTATS_EXPORT double uxstats_vec_regression_r2(void *hx, void *hy) {
    UXStatsVec *x=(UXStatsVec*)hx, *y=(UXStatsVec*)hy;
    if (!uxstats_is_valid_vec(x) || !uxstats_is_valid_vec(y)) return NAN;
    int32_t n = x->count < y->count ? x->count : y->count;
    return uxstats_regression_r2_f64(x->data, y->data, n);
}
