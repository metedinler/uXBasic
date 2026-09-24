#ifndef UXGSL_H
#define UXGSL_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) && defined(UXGSL_BUILD_DLL)
#define UXGSL_API __declspec(dllexport)
#elif defined(_WIN32)
#define UXGSL_API __declspec(dllimport)
#else
#define UXGSL_API
#endif

/*
 * Stable, narrow C-ABI10 facade over GNU Scientific Library.
 *
 * Every result-producing facade function updates a per-thread status value.
 * A successful call has UXGSL_STATUS_OK. Status/result query functions leave
 * it unchanged. Functions that return a floating-point value return NaN on a
 * facade failure; callers can then query uxgsl_last_status.
 */
enum {
    UXGSL_STATUS_OK = 0,
    UXGSL_STATUS_INVALID_ARGUMENT = 1,
    UXGSL_STATUS_ALLOCATION_FAILED = 2,
    UXGSL_STATUS_INVALID_HANDLE = 3,
    UXGSL_STATUS_OUT_OF_RANGE = 4,
    UXGSL_STATUS_DOMAIN_ERROR = 5,
    UXGSL_STATUS_RANGE_ERROR = 6,
    UXGSL_STATUS_BACKEND_ERROR = 7,
    UXGSL_STATUS_SHAPE_MISMATCH = 8,
    UXGSL_STATUS_INVALID_CALLBACK = 9
};

UXGSL_API int32_t uxgsl_api_version(void);
UXGSL_API int32_t uxgsl_available(void);
UXGSL_API const char *uxgsl_gsl_version(void);
UXGSL_API int32_t uxgsl_self_test(void);
UXGSL_API int32_t uxgsl_last_status(void);
UXGSL_API int32_t uxgsl_last_gsl_status(void);
UXGSL_API const char *uxgsl_last_error(void);
UXGSL_API const char *uxgsl_status_text(int32_t status);

UXGSL_API double uxgsl_bessel_j0(double x);
UXGSL_API double uxgsl_bessel_j1(double x);
UXGSL_API double uxgsl_bessel_y0(double x);
UXGSL_API double uxgsl_gamma(double x);
UXGSL_API double uxgsl_lngamma(double x);
UXGSL_API double uxgsl_erf(double x);
UXGSL_API double uxgsl_gaussian_pdf(double x, double sigma);

UXGSL_API void *uxgsl_rng_create(uint64_t seed);
UXGSL_API void uxgsl_rng_free(void *handle);
UXGSL_API double uxgsl_rng_uniform(void *handle);
UXGSL_API double uxgsl_rng_gaussian(void *handle, double sigma);

UXGSL_API void *uxgsl_vector_create(int32_t count);
UXGSL_API void uxgsl_vector_free(void *handle);
UXGSL_API int32_t uxgsl_vector_size(void *handle);
UXGSL_API int32_t uxgsl_vector_set(void *handle, int32_t index, double value);
UXGSL_API double uxgsl_vector_get(void *handle, int32_t index);
UXGSL_API double uxgsl_vector_mean(void *handle);
UXGSL_API double uxgsl_vector_sd(void *handle);
UXGSL_API double uxgsl_vector_variance(void *handle);

/* Double matrix handles own both the gsl_matrix structure and its backing
 * buffer. Rows and columns are zero-based at the public ABI boundary. */
UXGSL_API void *uxgsl_matrix_create(int32_t rows, int32_t columns);
UXGSL_API void uxgsl_matrix_free(void *handle);
UXGSL_API int32_t uxgsl_matrix_rows(void *handle);
UXGSL_API int32_t uxgsl_matrix_columns(void *handle);
UXGSL_API int32_t uxgsl_matrix_set(void *handle, int32_t row, int32_t column, double value);
UXGSL_API double uxgsl_matrix_get(void *handle, int32_t row, int32_t column);
UXGSL_API int32_t uxgsl_matrix_set_zero(void *handle);
UXGSL_API int32_t uxgsl_matrix_set_identity(void *handle);
UXGSL_API int32_t uxgsl_matrix_multiply(void *left, void *right, void *output);

/* A callback address is a real synchronous C ABI function:
 * double callback(double x, void *user_data).  It must remain valid until
 * uxgsl_integrate_qag returns. */
UXGSL_API void *uxgsl_integration_workspace_create(int32_t limit);
UXGSL_API void uxgsl_integration_workspace_free(void *handle);
UXGSL_API double uxgsl_integrate_qag(void *callback, void *user_data,
    double lower, double upper, double absolute_tolerance,
    double relative_tolerance, int32_t limit, int32_t key, void *workspace);
UXGSL_API double uxgsl_last_estimated_error(void);

/* A bisection solver owns its native GSL state and retains the callback until
 * it is reset or freed. The callback must therefore remain executable for the
 * entire solver lifetime. Its ABI is double callback(double, void *). */
UXGSL_API void *uxgsl_root_bisection_create(void);
UXGSL_API void uxgsl_root_bisection_free(void *handle);
UXGSL_API int32_t uxgsl_root_bisection_set(void *handle, void *callback,
    void *user_data, double lower, double upper);
UXGSL_API int32_t uxgsl_root_bisection_iterate(void *handle);
UXGSL_API double uxgsl_root_bisection_root(void *handle);
UXGSL_API double uxgsl_root_bisection_lower(void *handle);
UXGSL_API double uxgsl_root_bisection_upper(void *handle);
/* Returns 1 when the configured interval has converged, 0 when it has not.
 * A normal not-yet-converged result leaves uxgsl_last_status() as OK. */
UXGSL_API int32_t uxgsl_root_bisection_interval_converged(void *handle,
    double absolute_tolerance, double relative_tolerance);

/* Complex values are opaque owned values. Output operands are required to be
 * a separate live UXGSL complex handle. */
UXGSL_API void *uxgsl_complex_create(double real, double imaginary);
UXGSL_API void uxgsl_complex_free(void *handle);
UXGSL_API double uxgsl_complex_real(void *handle);
UXGSL_API double uxgsl_complex_imaginary(void *handle);
UXGSL_API double uxgsl_complex_abs(void *handle);
UXGSL_API int32_t uxgsl_complex_add(void *left, void *right, void *output);
UXGSL_API int32_t uxgsl_complex_multiply(void *left, void *right, void *output);

#include "generated/uxgsl_scalar_auto.h"

#ifdef __cplusplus
}
#endif

#endif
