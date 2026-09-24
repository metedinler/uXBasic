#ifndef UXMATRIX_H
#define UXMATRIX_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
  #ifdef UXMATRIX_BUILD
    #define UXMATRIX_API __declspec(dllexport)
  #else
    #define UXMATRIX_API __declspec(dllimport)
  #endif
#else
  #define UXMATRIX_API
#endif

typedef void* UXMatrixHandle;

UXMATRIX_API int uxmatrix_runtime_version(void);
UXMATRIX_API UXMatrixHandle uxmatrix_create(int rows, int cols);
UXMATRIX_API UXMatrixHandle uxmatrix_from_array(int rows, int cols, const double* data_row_major);
UXMATRIX_API void uxmatrix_free(UXMatrixHandle h);
UXMATRIX_API int uxmatrix_rows(UXMatrixHandle h);
UXMATRIX_API int uxmatrix_cols(UXMatrixHandle h);
UXMATRIX_API int uxmatrix_size(UXMatrixHandle h);
UXMATRIX_API double* uxmatrix_data_ptr(UXMatrixHandle h);
UXMATRIX_API int uxmatrix_set(UXMatrixHandle h, int r, int c, double v);
UXMATRIX_API double uxmatrix_get(UXMatrixHandle h, int r, int c);
UXMATRIX_API int uxmatrix_fill(UXMatrixHandle h, double v);
UXMATRIX_API int uxmatrix_zero(UXMatrixHandle h);
UXMATRIX_API int uxmatrix_eye(UXMatrixHandle h);
UXMATRIX_API UXMatrixHandle uxmatrix_clone(UXMatrixHandle h);
UXMATRIX_API UXMatrixHandle uxmatrix_transpose(UXMatrixHandle a);
UXMATRIX_API UXMatrixHandle uxmatrix_add(UXMatrixHandle a, UXMatrixHandle b);
UXMATRIX_API UXMatrixHandle uxmatrix_sub(UXMatrixHandle a, UXMatrixHandle b);
UXMATRIX_API UXMatrixHandle uxmatrix_scale(UXMatrixHandle a, double s);
UXMATRIX_API UXMatrixHandle uxmatrix_mul(UXMatrixHandle a, UXMatrixHandle b);
UXMATRIX_API UXMatrixHandle uxmatrix_matvec(UXMatrixHandle a, UXMatrixHandle x_colvec);
UXMATRIX_API double uxmatrix_dot(UXMatrixHandle a_colvec, UXMatrixHandle b_colvec);
UXMATRIX_API double uxmatrix_norm_l1(UXMatrixHandle a);
UXMATRIX_API double uxmatrix_norm_l2(UXMatrixHandle a);
UXMATRIX_API double uxmatrix_norm_fro(UXMatrixHandle a);
UXMATRIX_API double uxmatrix_trace(UXMatrixHandle a);
UXMATRIX_API int uxmatrix_copy_to_array(UXMatrixHandle h, double* out, int max_count);
UXMATRIX_API int uxmatrix_copy_from_array(UXMatrixHandle h, const double* in, int count);
UXMATRIX_API int uxmatrix_print(UXMatrixHandle h);

// LAPACK-backed routines when available through LAPACKE/OpenBLAS.
UXMATRIX_API int uxmatrix_solve(UXMatrixHandle a, UXMatrixHandle b, UXMatrixHandle* x_out);
UXMATRIX_API double uxmatrix_det(UXMatrixHandle a);
UXMATRIX_API int uxmatrix_inverse(UXMatrixHandle a, UXMatrixHandle* inv_out);
UXMATRIX_API int uxmatrix_cholesky(UXMatrixHandle a, UXMatrixHandle* lower_out);
UXMATRIX_API int uxmatrix_qr(UXMatrixHandle a, UXMatrixHandle* q_out, UXMatrixHandle* r_out);
UXMATRIX_API int uxmatrix_svd(UXMatrixHandle a, UXMatrixHandle* u_out, UXMatrixHandle* s_colvec_out, UXMatrixHandle* vt_out);
UXMATRIX_API int uxmatrix_eigen_symmetric(UXMatrixHandle a, UXMatrixHandle* values_colvec_out, UXMatrixHandle* vectors_out);

// Convenience functions for uXBasic CALL(DLL) paths that cannot pass out pointers yet.
UXMATRIX_API UXMatrixHandle uxmatrix_solve_new(UXMatrixHandle a, UXMatrixHandle b);
UXMATRIX_API UXMatrixHandle uxmatrix_inverse_new(UXMatrixHandle a);
UXMATRIX_API UXMatrixHandle uxmatrix_cholesky_new(UXMatrixHandle a);
UXMATRIX_API int uxmatrix_rank_svd(UXMatrixHandle a, double tol);
UXMATRIX_API double uxmatrix_cond2(UXMatrixHandle a);

// Raw BLAS bridge for advanced libraries.
UXMATRIX_API double uxmatrix_blas_ddot(int n, const double* x, int incx, const double* y, int incy);
UXMATRIX_API int uxmatrix_blas_daxpy(int n, double alpha, const double* x, int incx, double* y, int incy);
UXMATRIX_API int uxmatrix_blas_dgemm_rowmajor(int m, int n, int k, double alpha, const double* A, const double* B, double beta, double* C);

#ifdef __cplusplus
}
#endif
#endif
