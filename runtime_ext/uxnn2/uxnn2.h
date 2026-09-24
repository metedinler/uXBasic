#ifndef UXNN2_H
#define UXNN2_H
#ifdef __cplusplus
extern "C" {
#endif
#if defined(_WIN32)
#define UXNN2_EXPORT __declspec(dllexport)
#else
#define UXNN2_EXPORT
#endif

UXNN2_EXPORT int uxnn2_version(void);
UXNN2_EXPORT const char* uxnn2_backend(void);
UXNN2_EXPORT void uxnn2_seed(unsigned long long seed);
UXNN2_EXPORT void* uxnn2_network_create(int input_dim);
UXNN2_EXPORT void uxnn2_network_free(void* net);
UXNN2_EXPORT int uxnn2_network_add_dense(void* net, int output_dim, int activation);
UXNN2_EXPORT int uxnn2_network_layer_count(void* net);
UXNN2_EXPORT int uxnn2_network_input_dim(void* net);
UXNN2_EXPORT int uxnn2_network_output_dim(void* net);
UXNN2_EXPORT void uxnn2_network_init(void* net, int init_kind, double scale);
UXNN2_EXPORT void uxnn2_set_optimizer(void* net, int opt_kind, double learning_rate);
UXNN2_EXPORT void uxnn2_set_optimizer_params(void* net, double beta1, double beta2, double epsilon, double weight_decay);
UXNN2_EXPORT void uxnn2_forward_ptr(void* net, const double* input, double* output);
UXNN2_EXPORT double uxnn2_loss_mse_ptr(void* net, const double* input, const double* target);
UXNN2_EXPORT double uxnn2_train_sample_mse_ptr(void* net, const double* input, const double* target);
UXNN2_EXPORT double uxnn2_train_array_mse_ptr(void* net, const double* x, const double* y, int sample_count, int epochs, int shuffle);
UXNN2_EXPORT int uxnn2_predict_argmax_ptr(void* net, const double* input);
UXNN2_EXPORT double uxnn2_get_weight(void* net, int layer_index, int out_index, int in_index);
UXNN2_EXPORT void uxnn2_set_weight(void* net, int layer_index, int out_index, int in_index, double value);
UXNN2_EXPORT double uxnn2_get_bias(void* net, int layer_index, int out_index);
UXNN2_EXPORT void uxnn2_set_bias(void* net, int layer_index, int out_index, double value);
UXNN2_EXPORT int uxnn2_save(void* net, const char* path);
UXNN2_EXPORT void* uxnn2_load(const char* path);

#ifdef __cplusplus
}
#endif
#endif
