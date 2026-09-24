#ifndef UXMATHCORE_H
#define UXMATHCORE_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#define UXMATHCORE_API __declspec(dllexport)
#else
#define UXMATHCORE_API
#endif

#define UXMC_TYPE_I8   1
#define UXMC_TYPE_U8   2
#define UXMC_TYPE_I16  3
#define UXMC_TYPE_U16  4
#define UXMC_TYPE_I32  5
#define UXMC_TYPE_U32  6
#define UXMC_TYPE_I64  7
#define UXMC_TYPE_U64  8
#define UXMC_TYPE_F32  9
#define UXMC_TYPE_F64  10
#define UXMC_TYPE_BYTE UXMC_TYPE_U8

UXMATHCORE_API int uxmathcore_version(void);
UXMATHCORE_API int uxmathcore_type_size(int elem_type);
UXMATHCORE_API const char* uxmathcore_type_name(int elem_type);

UXMATHCORE_API void* uxmathcore_buffer_create(int elem_type, int count);
UXMATHCORE_API void* uxmathcore_buffer_create_capacity(int elem_type, int count, int capacity);
UXMATHCORE_API void uxmathcore_buffer_free(void* h);
UXMATHCORE_API int uxmathcore_buffer_type(void* h);
UXMATHCORE_API int uxmathcore_buffer_count(void* h);
UXMATHCORE_API int uxmathcore_buffer_capacity(void* h);
UXMATHCORE_API int uxmathcore_buffer_elem_size(void* h);
UXMATHCORE_API long long uxmathcore_buffer_byte_size(void* h);
UXMATHCORE_API void* uxmathcore_buffer_data_ptr(void* h);
UXMATHCORE_API int uxmathcore_buffer_clear(void* h);
UXMATHCORE_API int uxmathcore_buffer_resize(void* h, int count);
UXMATHCORE_API int uxmathcore_buffer_reserve(void* h, int capacity);
UXMATHCORE_API int uxmathcore_buffer_fill_zero(void* h);
UXMATHCORE_API int uxmathcore_buffer_clone(void* src, void** out_handle);
UXMATHCORE_API int uxmathcore_buffer_copy(void* src, void* dst);
UXMATHCORE_API int uxmathcore_buffer_slice(void* src, int start, int count, void** out_handle);
UXMATHCORE_API int uxmathcore_buffer_append(void* dst, void* src);

UXMATHCORE_API int uxmathcore_buffer_get_f64(void* h, int index, double* out_value);
UXMATHCORE_API int uxmathcore_buffer_set_f64(void* h, int index, double value);
UXMATHCORE_API int uxmathcore_buffer_push_f64(void* h, double value);
UXMATHCORE_API int uxmathcore_buffer_fill_f64(void* h, double value);

UXMATHCORE_API int uxmathcore_buffer_get_i64(void* h, int index, long long* out_value);
UXMATHCORE_API int uxmathcore_buffer_set_i64(void* h, int index, long long value);
UXMATHCORE_API int uxmathcore_buffer_push_i64(void* h, long long value);
UXMATHCORE_API int uxmathcore_buffer_fill_i64(void* h, long long value);

UXMATHCORE_API int uxmathcore_buffer_get_u64(void* h, int index, unsigned long long* out_value);
UXMATHCORE_API int uxmathcore_buffer_set_u64(void* h, int index, unsigned long long value);
UXMATHCORE_API int uxmathcore_buffer_push_u64(void* h, unsigned long long value);
UXMATHCORE_API int uxmathcore_buffer_fill_u64(void* h, unsigned long long value);

UXMATHCORE_API int uxmathcore_buffer_get_byte(void* h, int index, unsigned char* out_value);
UXMATHCORE_API int uxmathcore_buffer_set_byte(void* h, int index, unsigned char value);
UXMATHCORE_API int uxmathcore_buffer_push_byte(void* h, unsigned char value);

UXMATHCORE_API int uxmathcore_buffer_copy_from_ptr(void* h, const void* src, int elem_count);
UXMATHCORE_API int uxmathcore_buffer_copy_to_ptr(void* h, void* dst, int elem_count);
UXMATHCORE_API int uxmathcore_buffer_cast(void* src, int dst_type, void** out_handle);

UXMATHCORE_API int uxmathcore_vec_add_f64(void* a, void* b, void* out);
UXMATHCORE_API int uxmathcore_vec_sub_f64(void* a, void* b, void* out);
UXMATHCORE_API int uxmathcore_vec_mul_f64(void* a, void* b, void* out);
UXMATHCORE_API int uxmathcore_vec_div_f64(void* a, void* b, void* out);
UXMATHCORE_API int uxmathcore_vec_scale_f64(void* a, double scalar, void* out);
UXMATHCORE_API int uxmathcore_vec_axpy_f64(double alpha, void* x, void* y, void* out);
UXMATHCORE_API int uxmathcore_vec_dot_f64(void* a, void* b, double* out_value);
UXMATHCORE_API int uxmathcore_vec_l1_norm_f64(void* a, double* out_value);
UXMATHCORE_API int uxmathcore_vec_l2_norm_f64(void* a, double* out_value);
UXMATHCORE_API int uxmathcore_vec_normalize_l2_f64(void* a, void* out);
UXMATHCORE_API int uxmathcore_vec_minmax_f64(void* a, double* out_min, double* out_max);

/* Compatibility aliases for earlier uxmath core naming. */
UXMATHCORE_API int uxmath_version(void);
UXMATHCORE_API void* uxmath_vec_create(int capacity);
UXMATHCORE_API void uxmath_vec_free(void* h);
UXMATHCORE_API int uxmath_vec_push(void* h, double v);
UXMATHCORE_API int uxmath_vec_set(void* h, int idx, double v);
UXMATHCORE_API double uxmath_vec_get(void* h, int idx);
UXMATHCORE_API int uxmath_vec_count(void* h);
UXMATHCORE_API int uxmath_vec_clear(void* h);
UXMATHCORE_API double* uxmath_vec_data_ptr(void* h);

/* Convenience return-value wrappers for uXBasic CALL(DLL) usage. */
UXMATHCORE_API void* uxmathcore_buffer_clone_handle(void* src);
UXMATHCORE_API void* uxmathcore_buffer_slice_handle(void* src, int start, int count);
UXMATHCORE_API void* uxmathcore_buffer_cast_handle(void* src, int dst_type);
UXMATHCORE_API double uxmathcore_vec_dot_f64_value(void* a, void* b);
UXMATHCORE_API double uxmathcore_vec_l1_norm_f64_value(void* a);
UXMATHCORE_API double uxmathcore_vec_l2_norm_f64_value(void* a);
UXMATHCORE_API double uxmathcore_vec_min_f64_value(void* a);
UXMATHCORE_API double uxmathcore_vec_max_f64_value(void* a);

#ifdef __cplusplus
}
#endif
#endif
