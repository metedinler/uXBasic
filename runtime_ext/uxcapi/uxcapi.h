#ifndef UXCAPI_H
#define UXCAPI_H

#include <stdint.h>

#if defined(_WIN32)
  #define UXCAPI_API __declspec(dllexport)
  #define UXCAPI_CALL __cdecl
#else
  #define UXCAPI_API __attribute__((visibility("default")))
  #define UXCAPI_CALL
#endif

#ifdef __cplusplus
extern "C" {
#endif

enum {
    UXC_KIND_VOID       = 0,
    UXC_KIND_I8         = 1,
    UXC_KIND_U8         = 2,
    UXC_KIND_I16        = 3,
    UXC_KIND_U16        = 4,
    UXC_KIND_I32        = 5,
    UXC_KIND_U32        = 6,
    UXC_KIND_I64        = 7,
    UXC_KIND_U64        = 8,
    UXC_KIND_F32        = 9,
    UXC_KIND_F64        = 10,
    UXC_KIND_PTR        = 11,
    UXC_KIND_STRPTR     = 12,
    UXC_KIND_WSTRPTR    = 13,
    UXC_KIND_LONGDOUBLE = 14,
    UXC_KIND_STRUCT     = 15,
    UXC_KIND_UNION      = 16
};

UXCAPI_API int32_t UXCAPI_CALL uxcapi_version(void);
UXCAPI_API const char *UXCAPI_CALL uxcapi_last_error(void);
UXCAPI_API void UXCAPI_CALL uxcapi_shutdown(void);

UXCAPI_API void *UXCAPI_CALL uxcapi_symbol_address(
    const char *dll_name,
    const char *symbol_name
);


/* Aggregate type descriptors. STRUCT descriptors are libffi-callable.
   UNION descriptors carry layout metadata and are passed by pointer; direct
   union-by-value calls must use a generated C adapter. */
UXCAPI_API void *UXCAPI_CALL uxcapi_type_struct_new(void);
UXCAPI_API void *UXCAPI_CALL uxcapi_type_union_new(uint64_t size_bytes, uint32_t alignment_bytes);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_add_field(void *type_handle, int32_t field_kind);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_add_struct_field(void *type_handle, void *field_type_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_add_array_field(void *type_handle, int32_t element_kind, uint64_t element_count);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_add_struct_array_field(void *type_handle, void *field_type_handle, uint64_t element_count);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_set_expected_layout(void *type_handle, uint64_t size_bytes, uint32_t alignment_bytes);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_finalize(void *type_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_type_kind(void *type_handle);
UXCAPI_API uint64_t UXCAPI_CALL uxcapi_type_size(void *type_handle);
UXCAPI_API uint32_t UXCAPI_CALL uxcapi_type_alignment(void *type_handle);
UXCAPI_API void UXCAPI_CALL uxcapi_type_free(void *type_handle);

UXCAPI_API void *UXCAPI_CALL uxcapi_call_new(
    const char *dll_name,
    const char *symbol_name,
    int32_t return_kind,
    int32_t is_variadic,
    int32_t fixed_argument_count
);
UXCAPI_API void UXCAPI_CALL uxcapi_call_free(void *call_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_clear_arguments(void *call_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_set_return_struct(void *call_handle, void *type_handle);

UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_i8(void *call_handle, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_u8(void *call_handle, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_i16(void *call_handle, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_u16(void *call_handle, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_i32(void *call_handle, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_u32(void *call_handle, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_i64(void *call_handle, int64_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_u64(void *call_handle, uint64_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_f32(void *call_handle, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_f64(void *call_handle, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_ptr(void *call_handle, void *value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_string(void *call_handle, const char *value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_wstring_utf8(void *call_handle, const char *utf8_value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_long_double_from_f64(void *call_handle, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_arg_struct(void *call_handle, void *type_handle, const void *data, uint64_t byte_count);

UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_append_args(
    void *call_handle,
    void *args_handle
);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_call_invoke(void *call_handle);

UXCAPI_API int32_t UXCAPI_CALL uxcapi_result_i32(void *call_handle);
UXCAPI_API uint32_t UXCAPI_CALL uxcapi_result_u32(void *call_handle);
UXCAPI_API int64_t UXCAPI_CALL uxcapi_result_i64(void *call_handle);
UXCAPI_API uint64_t UXCAPI_CALL uxcapi_result_u64(void *call_handle);
UXCAPI_API double UXCAPI_CALL uxcapi_result_f64(void *call_handle);
UXCAPI_API void *UXCAPI_CALL uxcapi_result_ptr(void *call_handle);
UXCAPI_API const char *UXCAPI_CALL uxcapi_result_string(void *call_handle);
UXCAPI_API const char *UXCAPI_CALL uxcapi_call_error(void *call_handle);
UXCAPI_API uint64_t UXCAPI_CALL uxcapi_result_struct_size(void *call_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_result_struct_copy(void *call_handle, void *target, uint64_t target_capacity);

UXCAPI_API void *UXCAPI_CALL uxcapi_args_new(void);
UXCAPI_API void UXCAPI_CALL uxcapi_args_free(void *args_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_clear(void *args_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_i8(void *args_handle, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_u8(void *args_handle, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_i16(void *args_handle, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_u16(void *args_handle, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_i32(void *args_handle, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_u32(void *args_handle, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_i64(void *args_handle, int64_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_u64(void *args_handle, uint64_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_f32(void *args_handle, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_f64(void *args_handle, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_ptr(void *args_handle, void *value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_string(void *args_handle, const char *value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_wstring_utf8(void *args_handle, const char *utf8_value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_long_double_from_f64(void *args_handle, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_args_add_struct(void *args_handle, void *type_handle, const void *data, uint64_t byte_count);

UXCAPI_API void *UXCAPI_CALL uxcapi_memory_alloc(uint64_t byte_count);
UXCAPI_API void *UXCAPI_CALL uxcapi_memory_calloc(uint64_t item_count, uint64_t item_size);
UXCAPI_API void *UXCAPI_CALL uxcapi_memory_realloc(void *memory, uint64_t byte_count);
UXCAPI_API void UXCAPI_CALL uxcapi_memory_free(void *memory);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_zero(void *memory, uint64_t byte_count);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_copy(void *target, const void *source, uint64_t byte_count);

UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_i8(void *memory, uint64_t offset, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_u8(void *memory, uint64_t offset, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_i16(void *memory, uint64_t offset, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_u16(void *memory, uint64_t offset, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_i32(void *memory, uint64_t offset, int32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_u32(void *memory, uint64_t offset, uint32_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_i64(void *memory, uint64_t offset, int64_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_u64(void *memory, uint64_t offset, uint64_t value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_f32(void *memory, uint64_t offset, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_f64(void *memory, uint64_t offset, double value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_ptr(void *memory, uint64_t offset, void *value);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_write_string(void *memory, uint64_t offset, const char *value, uint64_t capacity);

UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_read_i8(const void *memory, uint64_t offset);
UXCAPI_API uint32_t UXCAPI_CALL uxcapi_memory_read_u8(const void *memory, uint64_t offset);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_read_i16(const void *memory, uint64_t offset);
UXCAPI_API uint32_t UXCAPI_CALL uxcapi_memory_read_u16(const void *memory, uint64_t offset);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_memory_read_i32(const void *memory, uint64_t offset);
UXCAPI_API uint32_t UXCAPI_CALL uxcapi_memory_read_u32(const void *memory, uint64_t offset);
UXCAPI_API int64_t UXCAPI_CALL uxcapi_memory_read_i64(const void *memory, uint64_t offset);
UXCAPI_API uint64_t UXCAPI_CALL uxcapi_memory_read_u64(const void *memory, uint64_t offset);
UXCAPI_API double UXCAPI_CALL uxcapi_memory_read_f32(const void *memory, uint64_t offset);
UXCAPI_API double UXCAPI_CALL uxcapi_memory_read_f64(const void *memory, uint64_t offset);
UXCAPI_API void *UXCAPI_CALL uxcapi_memory_read_ptr(const void *memory, uint64_t offset);
UXCAPI_API const char *UXCAPI_CALL uxcapi_memory_read_string(const void *memory, uint64_t offset);

UXCAPI_API void *UXCAPI_CALL uxcapi_callback_new(
    int32_t return_kind,
    uint64_t default_u64,
    double default_f64
);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_callback_add_arg(
    void *callback_handle,
    int32_t argument_kind
);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_callback_build(void *callback_handle);
UXCAPI_API void *UXCAPI_CALL uxcapi_callback_pointer(void *callback_handle);
UXCAPI_API void UXCAPI_CALL uxcapi_callback_free(void *callback_handle);
UXCAPI_API uint64_t UXCAPI_CALL uxcapi_callback_pending(void *callback_handle);
UXCAPI_API void *UXCAPI_CALL uxcapi_callback_next(void *callback_handle);

UXCAPI_API void UXCAPI_CALL uxcapi_event_free(void *event_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_event_arg_count(void *event_handle);
UXCAPI_API int32_t UXCAPI_CALL uxcapi_event_arg_kind(void *event_handle, int32_t index0);
UXCAPI_API uint64_t UXCAPI_CALL uxcapi_event_arg_u64(void *event_handle, int32_t index0);
UXCAPI_API double UXCAPI_CALL uxcapi_event_arg_f64(void *event_handle, int32_t index0);
UXCAPI_API const char *UXCAPI_CALL uxcapi_event_arg_string(void *event_handle, int32_t index0);

#ifdef __cplusplus
}
#endif
#endif
