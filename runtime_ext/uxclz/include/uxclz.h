#ifndef UXCLZ_H
#define UXCLZ_H

#include <stddef.h>
#include <stdint.h>

#if defined(_WIN32)
  #if defined(UXCLZ_BUILD_DLL)
    #define UXCLZ_API __declspec(dllexport)
  #else
    #define UXCLZ_API __declspec(dllimport)
  #endif
  #define UXCLZ_CALL __cdecl
#else
  #define UXCLZ_API __attribute__((visibility("default")))
  #define UXCLZ_CALL
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef uint64_t uxclz_handle;
typedef uint32_t uxclz_type_id;
typedef uint32_t uxclz_method_id;

enum uxclz_type_flags {
    UXCLZ_TYPE_CLASS      = 1u << 0,
    UXCLZ_TYPE_INTERFACE  = 1u << 1,
    UXCLZ_TYPE_VALUE      = 1u << 2,
    UXCLZ_TYPE_ENTITY     = 1u << 3,
    UXCLZ_TYPE_COMPONENT  = 1u << 4,
    UXCLZ_TYPE_ACTOR      = 1u << 5,
    UXCLZ_TYPE_NATIVE     = 1u << 6,
    UXCLZ_TYPE_ABSTRACT   = 1u << 7
};

enum uxclz_value_kind {
    UXCLZ_VALUE_NULL   = 0,
    UXCLZ_VALUE_I64    = 1,
    UXCLZ_VALUE_U64    = 2,
    UXCLZ_VALUE_F64    = 3,
    UXCLZ_VALUE_PTR    = 4,
    UXCLZ_VALUE_BOOL   = 5,
    UXCLZ_VALUE_STRPTR = 6,
    UXCLZ_VALUE_HANDLE = 7
};

typedef struct uxclz_value {
    uint32_t kind;
    uint32_t flags;
    union {
        int64_t i64;
        uint64_t u64;
        double f64;
        void* ptr;
        const char* str;
        uxclz_handle handle;
    } data;
} uxclz_value;

typedef void (UXCLZ_CALL *uxclz_destructor_fn)(void* payload);
typedef int (UXCLZ_CALL *uxclz_method_fn)(
    uxclz_handle self,
    void* payload,
    const uxclz_value* args,
    uint32_t argc,
    uxclz_value* result
);
typedef int (UXCLZ_CALL *uxclz_multimethod_fn)(
    uxclz_handle left,
    void* left_payload,
    uxclz_handle right,
    void* right_payload,
    const uxclz_value* args,
    uint32_t argc,
    uxclz_value* result
);

UXCLZ_API uint32_t UXCLZ_CALL uxclz_version(void);
UXCLZ_API const char* UXCLZ_CALL uxclz_last_error(void);
UXCLZ_API int UXCLZ_CALL uxclz_reset_registry(void);

UXCLZ_API uxclz_type_id UXCLZ_CALL uxclz_type_register(
    const char* name,
    uxclz_type_id base_type,
    uint32_t flags
);
UXCLZ_API int UXCLZ_CALL uxclz_type_add_interface(uxclz_type_id type_id, uxclz_type_id interface_id);
UXCLZ_API const char* UXCLZ_CALL uxclz_type_name(uxclz_type_id type_id);
UXCLZ_API int UXCLZ_CALL uxclz_type_is_a(uxclz_type_id type_id, uxclz_type_id expected_type);
UXCLZ_API int UXCLZ_CALL uxclz_type_has_interface(uxclz_type_id type_id, uxclz_type_id interface_id);
UXCLZ_API const char* UXCLZ_CALL uxclz_type_metadata_json(uxclz_type_id type_id);
UXCLZ_API const char* UXCLZ_CALL uxclz_registry_metadata_json(void);

UXCLZ_API int UXCLZ_CALL uxclz_method_register(
    uxclz_type_id type_id,
    uxclz_method_id method_id,
    const char* name,
    uxclz_method_fn function_pointer
);

UXCLZ_API uxclz_handle UXCLZ_CALL uxclz_object_wrap(
    uxclz_type_id type_id,
    void* payload,
    uxclz_destructor_fn destructor_pointer
);
UXCLZ_API int UXCLZ_CALL uxclz_object_retain(uxclz_handle handle);
UXCLZ_API int UXCLZ_CALL uxclz_object_release(uxclz_handle handle);
UXCLZ_API int UXCLZ_CALL uxclz_object_is_valid(uxclz_handle handle);
UXCLZ_API uxclz_type_id UXCLZ_CALL uxclz_object_type(uxclz_handle handle);
UXCLZ_API void* UXCLZ_CALL uxclz_object_payload(uxclz_handle handle);
UXCLZ_API uxclz_handle UXCLZ_CALL uxclz_object_query_interface(uxclz_handle handle, uxclz_type_id interface_id);

UXCLZ_API uint64_t UXCLZ_CALL uxclz_args_new(void);
UXCLZ_API void UXCLZ_CALL uxclz_args_free(uint64_t args_handle);
UXCLZ_API void UXCLZ_CALL uxclz_args_clear(uint64_t args_handle);
UXCLZ_API uint32_t UXCLZ_CALL uxclz_args_count(uint64_t args_handle);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_i64(uint64_t args_handle, int64_t value);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_u64(uint64_t args_handle, uint64_t value);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_f64(uint64_t args_handle, double value);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_ptr(uint64_t args_handle, void* value);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_bool(uint64_t args_handle, int value);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_strptr(uint64_t args_handle, const char* value);
UXCLZ_API int UXCLZ_CALL uxclz_args_push_handle(uint64_t args_handle, uxclz_handle value);

UXCLZ_API uint64_t UXCLZ_CALL uxclz_result_new(void);
UXCLZ_API void UXCLZ_CALL uxclz_result_free(uint64_t result_handle);
UXCLZ_API void UXCLZ_CALL uxclz_result_clear(uint64_t result_handle);
UXCLZ_API uint32_t UXCLZ_CALL uxclz_result_kind(uint64_t result_handle);
UXCLZ_API int64_t UXCLZ_CALL uxclz_result_i64(uint64_t result_handle);
UXCLZ_API uint64_t UXCLZ_CALL uxclz_result_u64(uint64_t result_handle);
UXCLZ_API double UXCLZ_CALL uxclz_result_f64(uint64_t result_handle);
UXCLZ_API void* UXCLZ_CALL uxclz_result_ptr(uint64_t result_handle);
UXCLZ_API int UXCLZ_CALL uxclz_result_bool(uint64_t result_handle);
UXCLZ_API const char* UXCLZ_CALL uxclz_result_strptr(uint64_t result_handle);
UXCLZ_API uxclz_handle UXCLZ_CALL uxclz_result_handle(uint64_t result_handle);

UXCLZ_API int UXCLZ_CALL uxclz_invoke_args(
    uxclz_handle object,
    uxclz_method_id method_id,
    uint64_t args_handle,
    uint64_t result_handle
);

UXCLZ_API int UXCLZ_CALL uxclz_multimethod_register(
    uxclz_method_id method_id,
    uxclz_type_id left_type,
    uxclz_type_id right_type,
    const char* name,
    uxclz_multimethod_fn function_pointer
);
UXCLZ_API int UXCLZ_CALL uxclz_multimethod_invoke_args(
    uxclz_method_id method_id,
    uxclz_handle left,
    uxclz_handle right,
    uint64_t args_handle,
    uint64_t result_handle
);

#ifdef __cplusplus
}
#endif

#endif
