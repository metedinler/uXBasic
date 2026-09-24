#ifndef UXMATH_H
#define UXMATH_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#define UXMATH_API __declspec(dllexport)
#else
#define UXMATH_API
#endif

UXMATH_API int uxmath_version(void);

UXMATH_API void* uxmath_vec_create(int capacity);
UXMATH_API void uxmath_vec_free(void* h);
UXMATH_API int uxmath_vec_push(void* h, double v);
UXMATH_API int uxmath_vec_set(void* h, int idx, double v);
UXMATH_API double uxmath_vec_get(void* h, int idx);
UXMATH_API int uxmath_vec_count(void* h);
UXMATH_API int uxmath_vec_clear(void* h);
UXMATH_API double* uxmath_vec_data_ptr(void* h);

UXMATH_API double uxmath_poly_eval(void* coeffs, double x);
UXMATH_API double uxmath_poly_derivative_eval(void* coeffs, double x);
UXMATH_API double uxmath_poly_integral_eval(void* coeffs, double a, double b);
UXMATH_API int uxmath_poly_derivative_coeff(void* coeffs, void* out_coeffs);
UXMATH_API int uxmath_poly_integral_coeff(void* coeffs, void* out_coeffs, double c0);
UXMATH_API double uxmath_poly_bisection(void* coeffs, double a, double b, int max_iter, double tol);
UXMATH_API double uxmath_poly_newton(void* coeffs, double x0, int max_iter, double tol);

UXMATH_API double uxmath_numeric_derivative_poly(void* coeffs, double x, double h);
UXMATH_API double uxmath_integrate_poly_simpson(void* coeffs, double a, double b, int n);
UXMATH_API double uxmath_ode_rk4_logistic(double y0, double r, double k, double t0, double t1, int steps);
UXMATH_API double uxmath_ode_euler_logistic(double y0, double r, double k, double t0, double t1, int steps);

UXMATH_API double uxmath_sigmoid(double x);
UXMATH_API double uxmath_dsigmoid_from_output(double y);
UXMATH_API double uxmath_relu(double x);
UXMATH_API double uxmath_drelu(double x);
UXMATH_API double uxmath_tanh_act(double x);
UXMATH_API double uxmath_dtanh_from_output(double y);
UXMATH_API int uxmath_vec_softmax(void* src, void* dst);

UXMATH_API void* uxmath_mat_create(int rows, int cols);
UXMATH_API void uxmath_mat_free(void* h);
UXMATH_API int uxmath_mat_rows(void* h);
UXMATH_API int uxmath_mat_cols(void* h);
UXMATH_API int uxmath_mat_set(void* h, int row, int col, double v);
UXMATH_API double uxmath_mat_get(void* h, int row, int col);
UXMATH_API int uxmath_mat_fill(void* h, double v);
UXMATH_API int uxmath_mat_random_uniform(void* h, double lo, double hi, unsigned int seed);
UXMATH_API int uxmath_mat_add(void* a, void* b, void* out);
UXMATH_API int uxmath_mat_sub(void* a, void* b, void* out);
UXMATH_API int uxmath_mat_mul(void* a, void* b, void* out);
UXMATH_API int uxmath_mat_transpose(void* a, void* out);
UXMATH_API int uxmath_mat_apply_sigmoid(void* a, void* out);
UXMATH_API int uxmath_mat_apply_relu(void* a, void* out);
UXMATH_API int uxmath_mat_vec_mul(void* m, void* v, void* out_vec);

#ifdef __cplusplus
}
#endif

#endif
