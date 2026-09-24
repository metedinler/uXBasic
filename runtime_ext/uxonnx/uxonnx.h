#ifndef UXONNX_H
#define UXONNX_H
#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define UXONNX_API __declspec(dllexport)
#else
#define UXONNX_API
#endif

UXONNX_API int uxonnx_global_init(const char *runtime_dir);
UXONNX_API const char* uxonnx_runtime_version(void);
UXONNX_API const char* uxonnx_last_error(void *session_handle);

UXONNX_API void* uxonnx_session_create(const char *model_path, int intra_threads);
UXONNX_API void  uxonnx_session_free(void *session_handle);
UXONNX_API long long uxonnx_input_count(void *session_handle);
UXONNX_API long long uxonnx_output_count(void *session_handle);
UXONNX_API const char* uxonnx_input_name(void *session_handle, long long index);
UXONNX_API const char* uxonnx_output_name(void *session_handle, long long index);

UXONNX_API void* uxonnx_tensor_create_f32(const long long *shape, long long rank);
UXONNX_API void* uxonnx_tensor_create_1d_f32(long long n);
UXONNX_API void* uxonnx_tensor_create_2d_f32(long long r, long long c);
UXONNX_API void* uxonnx_tensor_create_3d_f32(long long a, long long b, long long c);
UXONNX_API void* uxonnx_tensor_create_4d_f32(long long a, long long b, long long c, long long d);
UXONNX_API void  uxonnx_tensor_free(void *tensor_handle);
UXONNX_API long long uxonnx_tensor_count(void *tensor_handle);
UXONNX_API long long uxonnx_tensor_rank(void *tensor_handle);
UXONNX_API long long uxonnx_tensor_dim(void *tensor_handle, long long axis);
UXONNX_API float* uxonnx_tensor_data_ptr(void *tensor_handle);
UXONNX_API void  uxonnx_tensor_set_f32(void *tensor_handle, long long index, double value);
UXONNX_API double uxonnx_tensor_get_f32(void *tensor_handle, long long index);

UXONNX_API void* uxonnx_run1_f32(void *session_handle, const char *input_name, void *input_tensor_handle, const char *output_name);

#ifdef __cplusplus
}
#endif
#endif
