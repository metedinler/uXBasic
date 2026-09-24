#ifndef UXNN3_H
#define UXNN3_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
  #ifdef UXNN3_BUILD
    #define UXNN3_API __declspec(dllexport)
  #else
    #define UXNN3_API __declspec(dllimport)
  #endif
#else
  #define UXNN3_API
#endif

#define UXNN3_ACT_LINEAR 0
#define UXNN3_ACT_SIGMOID 1
#define UXNN3_ACT_TANH 2
#define UXNN3_ACT_RELU 3
#define UXNN3_ACT_LEAKY_RELU 4

#define UXNN3_OPT_SGD 1
#define UXNN3_OPT_MOMENTUM 2

UXNN3_API int uxnn3_version(void);
UXNN3_API const char* uxnn3_last_error(void);

UXNN3_API void* uxnn3_dataset_create(int rows, int input_dim, int output_dim);
UXNN3_API void uxnn3_dataset_free(void* ds);
UXNN3_API void* uxnn3_dataset_load_csv(const char* path, int input_dim, int output_dim, int has_header);
UXNN3_API int uxnn3_dataset_save_csv(void* ds, const char* path, int include_header);
UXNN3_API int uxnn3_dataset_rows(void* ds);
UXNN3_API int uxnn3_dataset_input_dim(void* ds);
UXNN3_API int uxnn3_dataset_output_dim(void* ds);
UXNN3_API double uxnn3_dataset_x_get(void* ds, int row, int col);
UXNN3_API double uxnn3_dataset_y_get(void* ds, int row, int col);
UXNN3_API int uxnn3_dataset_x_set(void* ds, int row, int col, double v);
UXNN3_API int uxnn3_dataset_y_set(void* ds, int row, int col, double v);
UXNN3_API double* uxnn3_dataset_x_ptr(void* ds);
UXNN3_API double* uxnn3_dataset_y_ptr(void* ds);
UXNN3_API int uxnn3_dataset_shuffle(void* ds, unsigned int seed);
UXNN3_API void* uxnn3_dataset_split_train(void* ds, double train_ratio, unsigned int seed);
UXNN3_API void* uxnn3_dataset_split_test(void* ds, double train_ratio, unsigned int seed);
UXNN3_API int uxnn3_dataset_standardize_fit_transform(void* ds);
UXNN3_API int uxnn3_dataset_minmax_fit_transform(void* ds, double a, double b);

UXNN3_API void* uxnn3_model_create(int input_dim);
UXNN3_API void uxnn3_model_free(void* model);
UXNN3_API int uxnn3_model_add_dense(void* model, int output_dim, int activation);
UXNN3_API int uxnn3_model_init(void* model, unsigned int seed, double scale);
UXNN3_API int uxnn3_model_set_optimizer(void* model, int optimizer, double lr, double momentum);
UXNN3_API int uxnn3_model_layer_count(void* model);
UXNN3_API int uxnn3_model_output_dim(void* model);
UXNN3_API double uxnn3_model_forward1(void* model, const double* x, double* out);
UXNN3_API double uxnn3_model_predict_dataset(void* model, void* ds, int row, double* out);
UXNN3_API int uxnn3_model_predict_argmax(void* model, void* ds, int row);
UXNN3_API double uxnn3_model_train_dataset(void* model, void* ds, int epochs, int batch_size, int shuffle, unsigned int seed);
UXNN3_API double uxnn3_model_eval_mse(void* model, void* ds);
UXNN3_API double uxnn3_model_eval_binary_accuracy(void* model, void* ds, double threshold);
UXNN3_API int uxnn3_model_save(void* model, const char* path);
UXNN3_API void* uxnn3_model_load(const char* path);

#ifdef __cplusplus
}
#endif
#endif
