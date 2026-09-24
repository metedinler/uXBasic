#ifndef UXAIMATH_H
#define UXAIMATH_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
#if defined(_WIN32)
#define UXAI_API __declspec(dllexport)
#else
#define UXAI_API
#endif
UXAI_API int uxaimath_version(void);
UXAI_API const char* uxaimath_backend(void);
UXAI_API void uxaimath_seed(uint64_t seed);
UXAI_API double uxaimath_sigmoid(double x);
UXAI_API double uxaimath_relu(double x);
UXAI_API double uxaimath_leaky_relu(double x, double alpha);
UXAI_API double uxaimath_elu(double x, double alpha);
UXAI_API double uxaimath_gelu(double x);
UXAI_API double uxaimath_swish(double x);
UXAI_API double uxaimath_softplus(double x);
UXAI_API void uxaimath_sigmoid_inplace_f64(double* x, int64_t n);
UXAI_API void uxaimath_tanh_inplace_f64(double* x, int64_t n);
UXAI_API void uxaimath_relu_inplace_f64(double* x, int64_t n);
UXAI_API void uxaimath_leaky_relu_inplace_f64(double* x, int64_t n, double alpha);
UXAI_API void uxaimath_elu_inplace_f64(double* x, int64_t n, double alpha);
UXAI_API void uxaimath_gelu_inplace_f64(double* x, int64_t n);
UXAI_API void uxaimath_swish_inplace_f64(double* x, int64_t n);
UXAI_API void uxaimath_softmax_f64(const double* x, double* out, int64_t n);
UXAI_API void uxaimath_softmax_inplace_f64(double* x, int64_t n);
UXAI_API double uxaimath_mse_f64(const double* yt, const double* yp, int64_t n);
UXAI_API double uxaimath_mae_f64(const double* yt, const double* yp, int64_t n);
UXAI_API double uxaimath_huber_f64(const double* yt, const double* yp, int64_t n, double delta);
UXAI_API double uxaimath_bce_f64(const double* yt, const double* yp, int64_t n);
UXAI_API double uxaimath_cce_f64(const double* yt, const double* yp, int64_t n);
UXAI_API void uxaimath_mse_grad_f64(const double* yt, const double* yp, double* out, int64_t n);
UXAI_API void uxaimath_bce_grad_f64(const double* yt, const double* yp, double* out, int64_t n);
UXAI_API void uxaimath_fill_zero_f64(double* x, int64_t n);
UXAI_API void uxaimath_fill_one_f64(double* x, int64_t n);
UXAI_API void uxaimath_fill_uniform_f64(double* x, int64_t n, double lo, double hi);
UXAI_API void uxaimath_fill_normal_f64(double* x, int64_t n, double mean, double stddev);
UXAI_API void uxaimath_xavier_uniform_f64(double* x, int64_t n, int64_t fan_in, int64_t fan_out);
UXAI_API void uxaimath_he_uniform_f64(double* x, int64_t n, int64_t fan_in);
UXAI_API void uxaimath_clip_value_f64(double* x, int64_t n, double lo, double hi);
UXAI_API void uxaimath_clip_norm_f64(double* x, int64_t n, double max_norm);
UXAI_API void uxaimath_sgd_update_f64(double* param, const double* grad, int64_t n, double lr);
UXAI_API void uxaimath_momentum_update_f64(double* param, const double* grad, double* velocity, int64_t n, double lr, double momentum);
UXAI_API void uxaimath_dense_forward_f64(const double* x, const double* w, const double* b, double* y, int64_t in_n, int64_t out_n);
UXAI_API void uxaimath_dense_batch_forward_f64(const double* x, const double* w, const double* b, double* y, int64_t batch, int64_t in_n, int64_t out_n);
UXAI_API int64_t uxaimath_argmax_f64(const double* x, int64_t n);
UXAI_API double uxaimath_binary_accuracy_f64(const double* yt, const double* yp, int64_t n, double threshold);
#ifdef __cplusplus
}
#endif
#endif
