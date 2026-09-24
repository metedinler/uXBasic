#ifndef UXSTATS2_H
#define UXSTATS2_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
#if defined(_WIN32) && defined(UXSTATS2_BUILD_DLL)
#define UXSTATS2_API __declspec(dllexport)
#elif defined(_WIN32)
#define UXSTATS2_API __declspec(dllimport)
#else
#define UXSTATS2_API
#endif
UXSTATS2_API int uxstats2_version(void);
UXSTATS2_API void* uxstats2_vec_create(int32_t capacity);
UXSTATS2_API void uxstats2_vec_free(void *h);
UXSTATS2_API int32_t uxstats2_vec_push(void *h, double value);
UXSTATS2_API int32_t uxstats2_vec_set(void *h, int32_t index, double value);
UXSTATS2_API double uxstats2_vec_get(void *h, int32_t index);
UXSTATS2_API int32_t uxstats2_vec_count(void *h);
UXSTATS2_API double uxstats2_one_sample_t_stat(void*h,double mu0);
UXSTATS2_API double uxstats2_one_sample_t_p(void*h,double mu0);
UXSTATS2_API double uxstats2_welch_t_stat(void*x,void*y);
UXSTATS2_API double uxstats2_welch_t_p(void*x,void*y);
UXSTATS2_API double uxstats2_pooled_t_stat(void*x,void*y);
UXSTATS2_API double uxstats2_pooled_t_p(void*x,void*y);
UXSTATS2_API double uxstats2_paired_t_stat(void*b,void*a);
UXSTATS2_API double uxstats2_paired_t_p(void*b,void*a);
UXSTATS2_API double uxstats2_one_sample_z_p(void*h,double mu0,double sigma);
UXSTATS2_API double uxstats2_two_sample_z_p(void*x,void*y,double sx,double sy);
UXSTATS2_API double uxstats2_one_prop_z_p(int32_t s,int32_t n,double p0);
UXSTATS2_API double uxstats2_two_prop_z_p(int32_t s1,int32_t n1,int32_t s2,int32_t n2);
UXSTATS2_API double uxstats2_f_variance_p(void*x,void*y);
UXSTATS2_API double uxstats2_chisq_gof_p(void*o,void*e);
UXSTATS2_API double uxstats2_chisq_2x2_p(double a,double b,double c,double d);
UXSTATS2_API double uxstats2_anova_oneway_f(void*v,void*g);
UXSTATS2_API double uxstats2_anova_oneway_p(void*v,void*g);
UXSTATS2_API double uxstats2_posthoc_bonferroni_t_p(void*v,void*g,double g1,double g2,int32_t comparisons);
UXSTATS2_API double uxstats2_posthoc_tukey_q(void*v,void*g,double g1,double g2);
UXSTATS2_API double uxstats2_posthoc_scheffe_f(void*v,void*g,double g1,double g2);
UXSTATS2_API double uxstats2_covariance_samp(void*x,void*y);
UXSTATS2_API double uxstats2_correlation(void*x,void*y);
UXSTATS2_API double uxstats2_regression_slope(void*x,void*y);
UXSTATS2_API double uxstats2_regression_intercept(void*x,void*y);
UXSTATS2_API double uxstats2_regression_r2(void*x,void*y);
UXSTATS2_API double uxstats2_regression_f_p(void*x,void*y);
UXSTATS2_API double uxstats2_vif_pair(void*x,void*y);
UXSTATS2_API double uxstats2_durbin_watson(void*e);
UXSTATS2_API double uxstats2_breusch_godfrey_p(void*e,int32_t lags);
UXSTATS2_API double uxstats2_adf_stat(void*y);
UXSTATS2_API double uxstats2_adf_p_approx(void*y);
UXSTATS2_API double uxstats2_ancova_binary_p(void*y,void*x,void*g,double g1,double g2);
UXSTATS2_API double uxstats2_hotelling_p_2d(void*x1,void*x2,void*g,double g1,double g2);
#ifdef __cplusplus
}
#endif
#endif
