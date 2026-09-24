#ifndef UXSTATS_H
#define UXSTATS_H
#ifdef __cplusplus
extern "C" {
#endif
#if defined(_WIN32) && defined(UXSTATS_BUILD_DLL)
#define UXSTATS_IMPORT __declspec(dllexport)
#elif defined(_WIN32)
#define UXSTATS_IMPORT __declspec(dllimport)
#else
#define UXSTATS_IMPORT
#endif
UXSTATS_IMPORT int uxstats_version(void);
UXSTATS_IMPORT void* uxstats_vec_create(int capacity);
UXSTATS_IMPORT void uxstats_vec_free(void *handle);
UXSTATS_IMPORT void uxstats_vec_clear(void *handle);
UXSTATS_IMPORT int uxstats_vec_count(void *handle);
UXSTATS_IMPORT int uxstats_vec_capacity(void *handle);
UXSTATS_IMPORT int uxstats_vec_push(void *handle, double value);
UXSTATS_IMPORT int uxstats_vec_set(void *handle, int index, double value);
UXSTATS_IMPORT double uxstats_vec_get(void *handle, int index);
UXSTATS_IMPORT double uxstats_vec_sum(void *handle);
UXSTATS_IMPORT double uxstats_vec_mean(void *handle);
UXSTATS_IMPORT double uxstats_vec_min(void *handle);
UXSTATS_IMPORT double uxstats_vec_max(void *handle);
UXSTATS_IMPORT double uxstats_vec_range(void *handle);
UXSTATS_IMPORT double uxstats_vec_variance_pop(void *handle);
UXSTATS_IMPORT double uxstats_vec_variance_samp(void *handle);
UXSTATS_IMPORT double uxstats_vec_stddev_pop(void *handle);
UXSTATS_IMPORT double uxstats_vec_stddev_samp(void *handle);
UXSTATS_IMPORT double uxstats_vec_median(void *handle);
UXSTATS_IMPORT double uxstats_vec_percentile(void *handle, double p);
UXSTATS_IMPORT double uxstats_vec_covariance_samp(void *hx, void *hy);
UXSTATS_IMPORT double uxstats_vec_correlation(void *hx, void *hy);
UXSTATS_IMPORT double uxstats_vec_regression_slope(void *hx, void *hy);
UXSTATS_IMPORT double uxstats_vec_regression_intercept(void *hx, void *hy);
UXSTATS_IMPORT double uxstats_vec_regression_r2(void *hx, void *hy);
UXSTATS_IMPORT double uxstats_mean_f64(const double *x, int n);
UXSTATS_IMPORT double uxstats_stddev_samp_f64(const double *x, int n);
#ifdef __cplusplus
}
#endif
#endif
