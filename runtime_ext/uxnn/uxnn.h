#ifndef UXNN_H
#define UXNN_H
#ifdef __cplusplus
extern "C" {
#endif
#if defined(_WIN32)
#define UXNN_API __declspec(dllexport)
#else
#define UXNN_API
#endif

UXNN_API int uxnn_version(void);
UXNN_API const char* uxnn_backend(void);
UXNN_API void uxnn_seed(unsigned long long seed);

UXNN_API void* uxnn_neuron_create(int input_count, int activation);
UXNN_API void uxnn_neuron_free(void* h);
UXNN_API void uxnn_neuron_set_weight(void* h, int idx, double v);
UXNN_API double uxnn_neuron_get_weight(void* h, int idx);
UXNN_API void uxnn_neuron_set_bias(void* h, double v);
UXNN_API double uxnn_neuron_get_bias(void* h);
UXNN_API double uxnn_neuron_forward_ptr(void* h, const double* input);

UXNN_API void* uxnn_layer_dense_create(int input_dim, int output_dim, int activation);
UXNN_API void* uxnn_layer_activation_create(int dim, int activation);
UXNN_API void uxnn_layer_free(void* layer);
UXNN_API int uxnn_layer_input_dim(void* layer);
UXNN_API int uxnn_layer_output_dim(void* layer);
UXNN_API void uxnn_layer_set_weight(void* layer, int out_idx, int in_idx, double v);
UXNN_API double uxnn_layer_get_weight(void* layer, int out_idx, int in_idx);
UXNN_API void uxnn_layer_set_bias(void* layer, int out_idx, double v);
UXNN_API double uxnn_layer_get_bias(void* layer, int out_idx);
UXNN_API void uxnn_layer_init(void* layer, int init_kind, double scale);
UXNN_API void uxnn_layer_forward_ptr(void* layer, const double* input, double* output);

UXNN_API void* uxnn_network_create(void);
UXNN_API void uxnn_network_free(void* net);
UXNN_API int uxnn_network_add_layer(void* net, void* layer);
UXNN_API int uxnn_network_layer_count(void* net);
UXNN_API int uxnn_network_input_dim(void* net);
UXNN_API int uxnn_network_output_dim(void* net);
UXNN_API void uxnn_network_forward_ptr(void* net, const double* input, double* output);
UXNN_API int uxnn_network_predict_argmax_ptr(void* net, const double* input);
UXNN_API double uxnn_network_mse_ptr(void* net, const double* x, const double* y, int sample_count, int input_dim, int output_dim);
UXNN_API double uxnn_network_train_mse_sgd_ptr(void* net, const double* x, const double* y, int sample_count, int input_dim, int output_dim, int epochs, double lr);

#ifdef __cplusplus
}
#endif
#endif
