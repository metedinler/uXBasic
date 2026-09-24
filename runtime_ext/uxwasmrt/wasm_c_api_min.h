#ifndef UXB_WASM_C_API_MIN_H
#define UXB_WASM_C_API_MIN_H

/*
 * Minimal ABI declarations from the standard WebAssembly C API used by
 * Wasmtime. This file intentionally contains only the stable core API surface
 * needed by uxwasmrt.dll and does not expose Wasmtime internals to uXBasic.
 */
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct wasm_engine_t wasm_engine_t;
typedef struct wasm_store_t wasm_store_t;
typedef struct wasm_module_t wasm_module_t;
typedef struct wasm_instance_t wasm_instance_t;
typedef struct wasm_func_t wasm_func_t;
typedef struct wasm_trap_t wasm_trap_t;
typedef struct wasm_extern_t wasm_extern_t;
typedef struct wasm_externtype_t wasm_externtype_t;
typedef struct wasm_functype_t wasm_functype_t;
typedef struct wasm_valtype_t wasm_valtype_t;
typedef struct wasm_importtype_t wasm_importtype_t;
typedef struct wasm_exporttype_t wasm_exporttype_t;
typedef struct wasm_ref_t wasm_ref_t;

typedef char wasm_byte_t;
typedef struct wasm_byte_vec_t { size_t size; wasm_byte_t *data; } wasm_byte_vec_t;
typedef wasm_byte_vec_t wasm_name_t;
typedef wasm_name_t wasm_message_t;

typedef uint8_t wasm_valkind_t;
enum {
    WASM_I32 = 0,
    WASM_I64 = 1,
    WASM_F32 = 2,
    WASM_F64 = 3,
    WASM_EXTERNREF = 128,
    WASM_FUNCREF = 129
};

typedef struct wasm_val_t {
    wasm_valkind_t kind;
    union {
        int32_t i32;
        int64_t i64;
        float f32;
        double f64;
        wasm_ref_t *ref;
    } of;
} wasm_val_t;

typedef struct wasm_val_vec_t { size_t size; wasm_val_t *data; } wasm_val_vec_t;
typedef struct wasm_valtype_vec_t { size_t size; wasm_valtype_t **data; } wasm_valtype_vec_t;
typedef struct wasm_importtype_vec_t { size_t size; wasm_importtype_t **data; } wasm_importtype_vec_t;
typedef struct wasm_exporttype_vec_t { size_t size; wasm_exporttype_t **data; } wasm_exporttype_vec_t;
typedef struct wasm_extern_vec_t { size_t size; wasm_extern_t **data; } wasm_extern_vec_t;

typedef uint8_t wasm_externkind_t;
enum {
    WASM_EXTERN_FUNC = 0,
    WASM_EXTERN_GLOBAL = 1,
    WASM_EXTERN_TABLE = 2,
    WASM_EXTERN_MEMORY = 3,
    WASM_EXTERN_TAG = 4
};

typedef wasm_trap_t *(*wasm_func_callback_with_env_t)(
    void *env,
    const wasm_val_vec_t *args,
    wasm_val_vec_t *results
);

#ifdef __cplusplus
}
#endif
#endif
