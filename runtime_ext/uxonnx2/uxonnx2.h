#ifndef UXONNX2_H
#define UXONNX2_H
#ifdef _WIN32
#define UXONNX2_API __declspec(dllexport)
#else
#define UXONNX2_API
#endif
#ifdef __cplusplus
extern "C" {
#endif

#define UXONNX2_DTYPE_F32 1
#define UXONNX2_DTYPE_F64 2
#define UXONNX2_DTYPE_I64 3
#define UXONNX2_DTYPE_I32 4
#define UXONNX2_DTYPE_STRING 5

#define UXONNX2_PROVIDER_CPU 0
#define UXONNX2_PROVIDER_DIRECTML 1
#define UXONNX2_PROVIDER_CUDA 2
#define UXONNX2_PROVIDER_AUTO 99

UXONNX2_API int uxonnx2_init(const char *runtime_dir);
UXONNX2_API const char* uxonnx2_version(void);
UXONNX2_API const char* uxonnx2_last_error(void);
UXONNX2_API int uxonnx2_provider_available(int provider);

UXONNX2_API void* uxonnx2_session_create(const char *model_path);
UXONNX2_API void* uxonnx2_session_create_advanced(const char *model_path, int provider, int intra_threads, int inter_threads, int graph_opt);
UXONNX2_API void uxonnx2_session_free(void *session);
UXONNX2_API long long uxonnx2_session_input_count(void *session);
UXONNX2_API long long uxonnx2_session_output_count(void *session);
UXONNX2_API const char* uxonnx2_session_input_name(void *session, long long idx);
UXONNX2_API const char* uxonnx2_session_output_name(void *session, long long idx);
UXONNX2_API int uxonnx2_session_input_dtype(void *session, long long idx);
UXONNX2_API int uxonnx2_session_output_dtype(void *session, long long idx);
UXONNX2_API long long uxonnx2_session_input_rank(void *session, long long idx);
UXONNX2_API long long uxonnx2_session_output_rank(void *session, long long idx);
UXONNX2_API long long uxonnx2_session_input_dim(void *session, long long idx, long long axis);
UXONNX2_API long long uxonnx2_session_output_dim(void *session, long long idx, long long axis);

UXONNX2_API void* uxonnx2_tensor_create(const long long *shape, long long rank, int dtype);
UXONNX2_API void* uxonnx2_tensor_create_1d(int dtype, long long n);
UXONNX2_API void* uxonnx2_tensor_create_2d(int dtype, long long r, long long c);
UXONNX2_API void* uxonnx2_tensor_create_3d(int dtype, long long a, long long b, long long c);
UXONNX2_API void* uxonnx2_tensor_create_4d(int dtype, long long a, long long b, long long c, long long d);
UXONNX2_API void uxonnx2_tensor_free(void *tensor);
UXONNX2_API int uxonnx2_tensor_dtype(void *tensor);
UXONNX2_API long long uxonnx2_tensor_rank(void *tensor);
UXONNX2_API long long uxonnx2_tensor_dim(void *tensor, long long axis);
UXONNX2_API long long uxonnx2_tensor_count(void *tensor);
UXONNX2_API void* uxonnx2_tensor_data_ptr(void *tensor);
UXONNX2_API void uxonnx2_tensor_set_f64(void *tensor, long long idx, double value);
UXONNX2_API double uxonnx2_tensor_get_f64(void *tensor, long long idx);
UXONNX2_API void uxonnx2_tensor_set_i64(void *tensor, long long idx, long long value);
UXONNX2_API long long uxonnx2_tensor_get_i64(void *tensor, long long idx);
UXONNX2_API void uxonnx2_tensor_set_string(void *tensor, long long idx, const char *value);
UXONNX2_API const char* uxonnx2_tensor_get_string(void *tensor, long long idx);

UXONNX2_API void* uxonnx2_run_create(void *session);
UXONNX2_API void uxonnx2_run_free(void *run);
UXONNX2_API int uxonnx2_run_add_input(void *run, const char *name, void *tensor);
UXONNX2_API int uxonnx2_run_add_output(void *run, const char *name);
UXONNX2_API void* uxonnx2_run_execute(void *run);

UXONNX2_API void uxonnx2_result_free(void *result);
UXONNX2_API long long uxonnx2_result_count(void *result);
UXONNX2_API void* uxonnx2_result_tensor(void *result, long long idx);
UXONNX2_API void* uxonnx2_run1(void *session, const char *input_name, void *input_tensor, const char *output_name);

#ifdef __cplusplus
}
#endif
#endif
