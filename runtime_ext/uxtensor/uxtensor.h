#ifndef UXB_UXTENSOR_H
#define UXB_UXTENSOR_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define UXTENSOR_API __declspec(dllexport)
#else
#define UXTENSOR_API
#endif

#define UXTENSOR_DTYPE_F64 1
#define UXTENSOR_DTYPE_F32 2
#define UXTENSOR_DTYPE_I64 3
#define UXTENSOR_MAX_DIMS 8

UXTENSOR_API int uxtensor_version(void);
UXTENSOR_API const char* uxtensor_backend(void);

UXTENSOR_API void* uxtensor_create(int dtype, int ndim, const long long* shape);
UXTENSOR_API void* uxtensor_create1d_f64(long long n);
UXTENSOR_API void* uxtensor_create2d_f64(long long rows, long long cols);
UXTENSOR_API void* uxtensor_create3d_f64(long long a, long long b, long long c);
UXTENSOR_API void* uxtensor_create4d_f64(long long a, long long b, long long c, long long d);
UXTENSOR_API void  uxtensor_free(void* handle);
UXTENSOR_API void* uxtensor_clone(void* handle);
UXTENSOR_API void* uxtensor_reshape_copy(void* handle, int ndim, const long long* shape);
UXTENSOR_API void* uxtensor_slice_axis0_copy(void* handle, long long start, long long count);

UXTENSOR_API int       uxtensor_dtype(void* handle);
UXTENSOR_API int       uxtensor_ndim(void* handle);
UXTENSOR_API long long uxtensor_dim(void* handle, int axis);
UXTENSOR_API long long uxtensor_stride(void* handle, int axis);
UXTENSOR_API long long uxtensor_size(void* handle);
UXTENSOR_API long long uxtensor_elem_size(void* handle);
UXTENSOR_API void*     uxtensor_data_ptr(void* handle);

UXTENSOR_API int    uxtensor_fill_f64(void* handle, double value);
UXTENSOR_API int    uxtensor_zero(void* handle);
UXTENSOR_API double uxtensor_get_flat_f64(void* handle, long long index);
UXTENSOR_API int    uxtensor_set_flat_f64(void* handle, long long index, double value);
UXTENSOR_API double uxtensor_get2d_f64(void* handle, long long r, long long c);
UXTENSOR_API int    uxtensor_set2d_f64(void* handle, long long r, long long c, double value);
UXTENSOR_API double uxtensor_get3d_f64(void* handle, long long a, long long b, long long c);
UXTENSOR_API int    uxtensor_set3d_f64(void* handle, long long a, long long b, long long c, double value);
UXTENSOR_API double uxtensor_get4d_f64(void* handle, long long a, long long b, long long c, long long d);
UXTENSOR_API int    uxtensor_set4d_f64(void* handle, long long a, long long b, long long c, long long d, double value);

UXTENSOR_API void* uxtensor_add_f64(void* a, void* b);
UXTENSOR_API void* uxtensor_sub_f64(void* a, void* b);
UXTENSOR_API void* uxtensor_mul_f64(void* a, void* b);
UXTENSOR_API void* uxtensor_div_f64(void* a, void* b);
UXTENSOR_API void* uxtensor_scale_f64(void* a, double scalar);
UXTENSOR_API double uxtensor_sum_f64(void* a);
UXTENSOR_API double uxtensor_mean_f64(void* a);
UXTENSOR_API double uxtensor_dot_f64(void* a, void* b);
UXTENSOR_API double uxtensor_norm2_f64(void* a);

UXTENSOR_API void* uxtensor_matmul2d_f64(void* a, void* b);
UXTENSOR_API void* uxtensor_transpose2d_f64(void* a);
UXTENSOR_API void* uxtensor_matvec2d_f64(void* a, void* x);

UXTENSOR_API double uxtensor_blas_ddot(long long n, const double* x, long long incx, const double* y, long long incy);
UXTENSOR_API int    uxtensor_blas_daxpy(long long n, double alpha, const double* x, long long incx, double* y, long long incy);
UXTENSOR_API int    uxtensor_blas_dscal(long long n, double alpha, double* x, long long incx);
UXTENSOR_API int    uxtensor_blas_dgemm_rowmajor(long long m, long long n, long long k, double alpha, const double* a, const double* b, double beta, double* c);

#ifdef __cplusplus
}
#endif

#endif
