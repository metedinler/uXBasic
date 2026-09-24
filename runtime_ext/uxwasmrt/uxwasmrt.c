#define _CRT_SECURE_NO_WARNINGS
#include "uxwasmrt.h"
#include "wasm_c_api_min.h"

#include <errno.h>
#include <math.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined(_WIN32)
  #ifndef _WIN32_WINNT
    #define _WIN32_WINNT 0x0601
  #endif
  #define WIN32_LEAN_AND_MEAN
  #include <windows.h>
  typedef HMODULE ux_dynlib_t;
  typedef FARPROC ux_symbol_t;
  typedef CRITICAL_SECTION ux_mutex_t;
  static HINSTANCE g_self_module = NULL;
#else
  #include <dlfcn.h>
  #include <limits.h>
  #include <pthread.h>
  #include <unistd.h>
  typedef void *ux_dynlib_t;
  typedef void *ux_symbol_t;
  typedef pthread_mutex_t ux_mutex_t;
#endif

#define UXWASMRT_ERROR_TEXT 2048
#define UXWASMRT_MAX_IMPORTS 16
#define UXWASMRT_MAX_MODULE_BYTES (64u * 1024u * 1024u)
#define UXWASMRT_TOKEN_INDEX_BITS 7u
#define UXWASMRT_TOKEN_INDEX_MASK ((1u << UXWASMRT_TOKEN_INDEX_BITS) - 1u)

#define UXWASM_E_OK 0
#define UXWASM_E_ARGUMENT 1
#define UXWASM_E_RUNTIME_LOAD 2
#define UXWASM_E_RUNTIME_SYMBOL 3
#define UXWASM_E_FILE 4
#define UXWASM_E_VALIDATE 5
#define UXWASM_E_MODULE 6
#define UXWASM_E_IMPORT 7
#define UXWASM_E_INSTANCE 8
#define UXWASM_E_HANDLE 9
#define UXWASM_E_EXPORT 10
#define UXWASM_E_SIGNATURE 11
#define UXWASM_E_TRAP 12
#define UXWASM_E_THREAD 13
#define UXWASM_E_CAPACITY 14

typedef wasm_engine_t *(*fn_wasm_engine_new)(void);
typedef void (*fn_wasm_engine_delete)(wasm_engine_t *);
typedef wasm_store_t *(*fn_wasm_store_new)(wasm_engine_t *);
typedef void (*fn_wasm_store_delete)(wasm_store_t *);
typedef void (*fn_wasm_byte_vec_new)(wasm_byte_vec_t *, size_t, const wasm_byte_t []);
typedef void (*fn_wasm_byte_vec_delete)(wasm_byte_vec_t *);
typedef bool (*fn_wasm_module_validate)(wasm_store_t *, const wasm_byte_vec_t *);
typedef wasm_module_t *(*fn_wasm_module_new)(wasm_store_t *, const wasm_byte_vec_t *);
typedef void (*fn_wasm_module_delete)(wasm_module_t *);
typedef void (*fn_wasm_module_imports)(const wasm_module_t *, wasm_importtype_vec_t *);
typedef void (*fn_wasm_module_exports)(const wasm_module_t *, wasm_exporttype_vec_t *);
typedef void (*fn_wasm_importtype_vec_delete)(wasm_importtype_vec_t *);
typedef void (*fn_wasm_exporttype_vec_delete)(wasm_exporttype_vec_t *);
typedef const wasm_name_t *(*fn_wasm_importtype_module)(const wasm_importtype_t *);
typedef const wasm_name_t *(*fn_wasm_importtype_name)(const wasm_importtype_t *);
typedef const wasm_externtype_t *(*fn_wasm_importtype_type)(const wasm_importtype_t *);
typedef const wasm_name_t *(*fn_wasm_exporttype_name)(const wasm_exporttype_t *);
typedef const wasm_externtype_t *(*fn_wasm_exporttype_type)(const wasm_exporttype_t *);
typedef wasm_externkind_t (*fn_wasm_externtype_kind)(const wasm_externtype_t *);
typedef const wasm_functype_t *(*fn_wasm_externtype_as_functype_const)(const wasm_externtype_t *);
typedef wasm_func_t *(*fn_wasm_func_new_with_env)(wasm_store_t *, const wasm_functype_t *, wasm_func_callback_with_env_t, void *, void (*)(void *));
typedef void (*fn_wasm_func_delete)(wasm_func_t *);
typedef wasm_extern_t *(*fn_wasm_func_as_extern)(wasm_func_t *);
typedef wasm_instance_t *(*fn_wasm_instance_new)(wasm_store_t *, const wasm_module_t *, const wasm_extern_vec_t *, wasm_trap_t **);
typedef void (*fn_wasm_instance_delete)(wasm_instance_t *);
typedef void (*fn_wasm_instance_exports)(const wasm_instance_t *, wasm_extern_vec_t *);
typedef void (*fn_wasm_extern_vec_delete)(wasm_extern_vec_t *);
typedef wasm_func_t *(*fn_wasm_extern_as_func)(wasm_extern_t *);
typedef wasm_functype_t *(*fn_wasm_func_type)(const wasm_func_t *);
typedef void (*fn_wasm_functype_delete)(wasm_functype_t *);
typedef size_t (*fn_wasm_func_param_arity)(const wasm_func_t *);
typedef size_t (*fn_wasm_func_result_arity)(const wasm_func_t *);
typedef const wasm_valtype_vec_t *(*fn_wasm_functype_params)(const wasm_functype_t *);
typedef const wasm_valtype_vec_t *(*fn_wasm_functype_results)(const wasm_functype_t *);
typedef wasm_valkind_t (*fn_wasm_valtype_kind)(const wasm_valtype_t *);
typedef wasm_trap_t *(*fn_wasm_func_call)(const wasm_func_t *, const wasm_val_vec_t *, wasm_val_vec_t *);
typedef wasm_trap_t *(*fn_wasm_trap_new)(wasm_store_t *, const wasm_message_t *);
typedef void (*fn_wasm_trap_message)(const wasm_trap_t *, wasm_message_t *);
typedef void (*fn_wasm_trap_delete)(wasm_trap_t *);

typedef struct UxWasmApi {
    fn_wasm_engine_new engine_new;
    fn_wasm_engine_delete engine_delete;
    fn_wasm_store_new store_new;
    fn_wasm_store_delete store_delete;
    fn_wasm_byte_vec_new byte_vec_new;
    fn_wasm_byte_vec_delete byte_vec_delete;
    fn_wasm_module_validate module_validate;
    fn_wasm_module_new module_new;
    fn_wasm_module_delete module_delete;
    fn_wasm_module_imports module_imports;
    fn_wasm_module_exports module_exports;
    fn_wasm_importtype_vec_delete importtype_vec_delete;
    fn_wasm_exporttype_vec_delete exporttype_vec_delete;
    fn_wasm_importtype_module importtype_module;
    fn_wasm_importtype_name importtype_name;
    fn_wasm_importtype_type importtype_type;
    fn_wasm_exporttype_name exporttype_name;
    fn_wasm_exporttype_type exporttype_type;
    fn_wasm_externtype_kind externtype_kind;
    fn_wasm_externtype_as_functype_const externtype_as_functype_const;
    fn_wasm_func_new_with_env func_new_with_env;
    fn_wasm_func_delete func_delete;
    fn_wasm_func_as_extern func_as_extern;
    fn_wasm_instance_new instance_new;
    fn_wasm_instance_delete instance_delete;
    fn_wasm_instance_exports instance_exports;
    fn_wasm_extern_vec_delete extern_vec_delete;
    fn_wasm_extern_as_func extern_as_func;
    fn_wasm_func_type func_type;
    fn_wasm_functype_delete functype_delete;
    fn_wasm_func_param_arity func_param_arity;
    fn_wasm_func_result_arity func_result_arity;
    fn_wasm_functype_params functype_params;
    fn_wasm_functype_results functype_results;
    fn_wasm_valtype_kind valtype_kind;
    fn_wasm_func_call func_call;
    fn_wasm_trap_new trap_new;
    fn_wasm_trap_message trap_message;
    fn_wasm_trap_delete trap_delete;
} UxWasmApi;

typedef enum HostKind {
    HOST_CALL4 = 1,
    HOST_PRINT_I32 = 2,
    HOST_PRINT_F64 = 3
} HostKind;

typedef struct HostEnv {
    HostKind kind;
    wasm_store_t *store;
    uint32_t rng_state;
} HostEnv;

typedef struct UxWasmSession {
    uint32_t generation;
    int in_use;
    unsigned long owner_thread;
    wasm_engine_t *engine;
    wasm_store_t *store;
    wasm_module_t *module;
    wasm_instance_t *instance;
    wasm_func_t *host_funcs[UXWASMRT_MAX_IMPORTS];
    size_t host_func_count;
    wasm_exporttype_vec_t export_types;
    wasm_extern_vec_t exports;
    int last_ok;
    int error_code;
    char error[UXWASMRT_ERROR_TEXT];
} UxWasmSession;

static UxWasmApi g_api;
static ux_dynlib_t g_runtime = 0;
static char g_runtime_path[1024];
static char g_global_error[UXWASMRT_ERROR_TEXT];
static int g_global_error_code = UXWASM_E_OK;
static UxWasmSession g_sessions[UXWASMRT_MAX_SESSIONS];
static ux_mutex_t g_mutex;
static int g_mutex_ready = 0;

#if defined(_WIN32)
static INIT_ONCE g_once = INIT_ONCE_STATIC_INIT;
static BOOL CALLBACK ux_init_once(PINIT_ONCE once, PVOID parameter, PVOID *context) {
    (void)once; (void)parameter; (void)context;
    InitializeCriticalSection(&g_mutex);
    g_mutex_ready = 1;
    return TRUE;
}
static void ux_lock(void) { InitOnceExecuteOnce(&g_once, ux_init_once, NULL, NULL); EnterCriticalSection(&g_mutex); }
static void ux_unlock(void) { LeaveCriticalSection(&g_mutex); }
static unsigned long ux_thread_id(void) { return (unsigned long)GetCurrentThreadId(); }
#else
static pthread_once_t g_once = PTHREAD_ONCE_INIT;
static void ux_init_once(void) { pthread_mutex_init(&g_mutex, NULL); g_mutex_ready = 1; }
static void ux_lock(void) { pthread_once(&g_once, ux_init_once); pthread_mutex_lock(&g_mutex); }
static void ux_unlock(void) { pthread_mutex_unlock(&g_mutex); }
static unsigned long ux_thread_id(void) { return (unsigned long)(uintptr_t)pthread_self(); }
#endif

static void set_global_error(int code, const char *text) {
    g_global_error_code = code;
    snprintf(g_global_error, sizeof(g_global_error), "%s", text ? text : "");
}

static void set_session_error(UxWasmSession *s, int code, const char *text) {
    if (!s) { set_global_error(code, text); return; }
    s->last_ok = 0;
    s->error_code = code;
    snprintf(s->error, sizeof(s->error), "%s", text ? text : "");
}

static void clear_session_error(UxWasmSession *s) {
    if (!s) return;
    s->last_ok = 1;
    s->error_code = UXWASM_E_OK;
    s->error[0] = '\0';
}

static int name_equals(const wasm_name_t *name, const char *expected) {
    size_t n;
    if (!name || !expected) return 0;
    n = strlen(expected);
    return name->size == n && name->data && memcmp(name->data, expected, n) == 0;
}

static void name_to_text(const wasm_name_t *name, char *out, size_t cap) {
    size_t n;
    if (!out || cap == 0) return;
    out[0] = '\0';
    if (!name || !name->data) return;
    n = name->size;
    if (n >= cap) n = cap - 1;
    memcpy(out, name->data, n);
    out[n] = '\0';
}

#if defined(_WIN32)
static ux_symbol_t ux_symbol(ux_dynlib_t lib, const char *name) { return GetProcAddress(lib, name); }
static ux_dynlib_t ux_open_library(const char *path) {
    return LoadLibraryExA(path, NULL, LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR | LOAD_LIBRARY_SEARCH_DEFAULT_DIRS);
}
static void ux_close_library(ux_dynlib_t lib) { if (lib) FreeLibrary(lib); }
static int ux_file_exists(const char *path) {
    DWORD a = GetFileAttributesA(path);
    return a != INVALID_FILE_ATTRIBUTES && !(a & FILE_ATTRIBUTE_DIRECTORY);
}
static void ux_dirname(char *path) {
    char *a = strrchr(path, '\\');
    char *b = strrchr(path, '/');
    char *p = a > b ? a : b;
    if (p) *p = '\0'; else path[0] = '\0';
}
static void ux_join(char *out, size_t cap, const char *dir, const char *file) {
    if (!dir || !*dir) snprintf(out, cap, "%s", file);
    else snprintf(out, cap, "%s\\%s", dir, file);
}
#else
static ux_symbol_t ux_symbol(ux_dynlib_t lib, const char *name) { return dlsym(lib, name); }
static ux_dynlib_t ux_open_library(const char *path) { return dlopen(path, RTLD_NOW | RTLD_LOCAL); }
static void ux_close_library(ux_dynlib_t lib) { if (lib) dlclose(lib); }
static int ux_file_exists(const char *path) { return access(path, R_OK) == 0; }
#endif

#define LOAD_API(field, symbol_name) do { \
    ux_symbol_t raw_symbol = ux_symbol(g_runtime, #symbol_name); \
    _Static_assert(sizeof(g_api.field) == sizeof(raw_symbol), "dynamic symbol pointer size mismatch"); \
    if (!raw_symbol) { \
        char e[256]; snprintf(e, sizeof(e), "Wasmtime C API symbol missing: %s", #symbol_name); \
        set_global_error(UXWASM_E_RUNTIME_SYMBOL, e); \
        goto fail; \
    } \
    memcpy(&g_api.field, &raw_symbol, sizeof(g_api.field)); \
} while (0)

static int resolve_runtime_symbols(void) {
    memset(&g_api, 0, sizeof(g_api));
    LOAD_API(engine_new, wasm_engine_new);
    LOAD_API(engine_delete, wasm_engine_delete);
    LOAD_API(store_new, wasm_store_new);
    LOAD_API(store_delete, wasm_store_delete);
    LOAD_API(byte_vec_new, wasm_byte_vec_new);
    LOAD_API(byte_vec_delete, wasm_byte_vec_delete);
    LOAD_API(module_validate, wasm_module_validate);
    LOAD_API(module_new, wasm_module_new);
    LOAD_API(module_delete, wasm_module_delete);
    LOAD_API(module_imports, wasm_module_imports);
    LOAD_API(module_exports, wasm_module_exports);
    LOAD_API(importtype_vec_delete, wasm_importtype_vec_delete);
    LOAD_API(exporttype_vec_delete, wasm_exporttype_vec_delete);
    LOAD_API(importtype_module, wasm_importtype_module);
    LOAD_API(importtype_name, wasm_importtype_name);
    LOAD_API(importtype_type, wasm_importtype_type);
    LOAD_API(exporttype_name, wasm_exporttype_name);
    LOAD_API(exporttype_type, wasm_exporttype_type);
    LOAD_API(externtype_kind, wasm_externtype_kind);
    LOAD_API(externtype_as_functype_const, wasm_externtype_as_functype_const);
    LOAD_API(func_new_with_env, wasm_func_new_with_env);
    LOAD_API(func_delete, wasm_func_delete);
    LOAD_API(func_as_extern, wasm_func_as_extern);
    LOAD_API(instance_new, wasm_instance_new);
    LOAD_API(instance_delete, wasm_instance_delete);
    LOAD_API(instance_exports, wasm_instance_exports);
    LOAD_API(extern_vec_delete, wasm_extern_vec_delete);
    LOAD_API(extern_as_func, wasm_extern_as_func);
    LOAD_API(func_type, wasm_func_type);
    LOAD_API(functype_delete, wasm_functype_delete);
    LOAD_API(func_param_arity, wasm_func_param_arity);
    LOAD_API(func_result_arity, wasm_func_result_arity);
    LOAD_API(functype_params, wasm_functype_params);
    LOAD_API(functype_results, wasm_functype_results);
    LOAD_API(valtype_kind, wasm_valtype_kind);
    LOAD_API(func_call, wasm_func_call);
    LOAD_API(trap_new, wasm_trap_new);
    LOAD_API(trap_message, wasm_trap_message);
    LOAD_API(trap_delete, wasm_trap_delete);
    return 1;
fail:
    memset(&g_api, 0, sizeof(g_api));
    return 0;
}

static int try_load_runtime_path(const char *path) {
    if (!path || !*path || !ux_file_exists(path)) return 0;
    g_runtime = ux_open_library(path);
    if (!g_runtime) return 0;
    snprintf(g_runtime_path, sizeof(g_runtime_path), "%s", path);
    if (!resolve_runtime_symbols()) {
        ux_close_library(g_runtime);
        g_runtime = 0;
        g_runtime_path[0] = '\0';
        return 0;
    }
    return 1;
}

static int ensure_runtime_loaded(void) {
    const char *override_path;
    if (g_runtime) return 1;

    override_path = getenv("UXB_WASMTIME_DLL");
    if (override_path && *override_path && try_load_runtime_path(override_path)) return 1;

#if defined(_WIN32)
    char path[1024];
    char dir[1024];
    if (g_self_module && GetModuleFileNameA(g_self_module, dir, (DWORD)sizeof(dir)) > 0) {
        ux_dirname(dir); ux_join(path, sizeof(path), dir, "wasmtime.dll");
        if (try_load_runtime_path(path)) return 1;
    }
    if (GetModuleFileNameA(NULL, dir, (DWORD)sizeof(dir)) > 0) {
        ux_dirname(dir); ux_join(path, sizeof(path), dir, "wasmtime.dll");
        if (try_load_runtime_path(path)) return 1;
    }
    if (try_load_runtime_path("tools\\wasm\\wasmtime\\wasmtime.dll")) return 1;
    g_runtime = LoadLibraryA("wasmtime.dll");
#else
    if (try_load_runtime_path("./libwasmtime.so")) return 1;
    g_runtime = dlopen("libwasmtime.so", RTLD_NOW | RTLD_LOCAL);
#endif
    if (g_runtime) {
        snprintf(g_runtime_path, sizeof(g_runtime_path), "%s", "wasmtime.dll");
        if (resolve_runtime_symbols()) return 1;
        ux_close_library(g_runtime); g_runtime = 0;
    }
    set_global_error(UXWASM_E_RUNTIME_LOAD,
        "wasmtime.dll not found. Run runtime_ext\\uxwasmrt\\fetch_wasm_deps.ps1 or set UXB_WASMTIME_DLL.");
    return 0;
}

static unsigned char *read_file(const char *path, size_t *size_out) {
    FILE *f;
    long length;
    unsigned char *data;
    size_t got;
    *size_out = 0;
    if (!path || !*path) { set_global_error(UXWASM_E_ARGUMENT, "WASM file path is empty"); return NULL; }
    f = fopen(path, "rb");
    if (!f) { char e[512]; snprintf(e, sizeof(e), "Cannot open WASM file: %s (errno=%d)", path, errno); set_global_error(UXWASM_E_FILE, e); return NULL; }
    if (fseek(f, 0, SEEK_END) != 0 || (length = ftell(f)) < 0 || fseek(f, 0, SEEK_SET) != 0) {
        fclose(f); set_global_error(UXWASM_E_FILE, "Cannot determine WASM file size"); return NULL;
    }
    if (length <= 0 || (unsigned long)length > UXWASMRT_MAX_MODULE_BYTES) {
        fclose(f); set_global_error(UXWASM_E_FILE, "WASM file is empty or exceeds 64 MiB core profile limit"); return NULL;
    }
    data = (unsigned char *)malloc((size_t)length);
    if (!data) { fclose(f); set_global_error(UXWASM_E_FILE, "Out of memory while reading WASM file"); return NULL; }
    got = fread(data, 1, (size_t)length, f);
    fclose(f);
    if (got != (size_t)length) { free(data); set_global_error(UXWASM_E_FILE, "Short read while loading WASM file"); return NULL; }
    *size_out = got;
    return data;
}

static wasm_trap_t *make_trap(HostEnv *env, const char *text) {
    wasm_message_t msg;
    if (!env || !env->store || !g_api.trap_new) return NULL;
    msg.size = strlen(text) + 1u;
    msg.data = (char *)text;
    return g_api.trap_new(env->store, &msg);
}

static int host_double_to_i32(double value, int32_t *out) {
    if (!out || !isfinite(value) || value < (double)INT32_MIN || value > (double)INT32_MAX) return 0;
    *out = (int32_t)value;
    return 1;
}

static uint32_t host_rng_next(HostEnv *env) {
    uint32_t x = env->rng_state ? env->rng_state : UINT32_C(0x6d2b79f5);
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    env->rng_state = x ? x : UINT32_C(0x6d2b79f5);
    return env->rng_state;
}

static wasm_trap_t *host_callback(void *opaque, const wasm_val_vec_t *args, wasm_val_vec_t *results) {
    HostEnv *env = (HostEnv *)opaque;
    if (!env || !args || !results) return make_trap(env, "uxwasmrt: invalid host callback state");
    if (env->kind == HOST_PRINT_I32) {
        if (args->size != 1 || args->data[0].kind != WASM_I32 || results->size != 0)
            return make_trap(env, "ux.print_i32 signature mismatch");
        printf("%d", args->data[0].of.i32); fflush(stdout); return NULL;
    }
    if (env->kind == HOST_PRINT_F64) {
        if (args->size != 1 || args->data[0].kind != WASM_F64 || results->size != 0)
            return make_trap(env, "ux.print_f64 signature mismatch");
        printf("%.17g", args->data[0].of.f64); fflush(stdout); return NULL;
    }
    if (env->kind == HOST_CALL4) {
        int32_t id, a, b, c, d, out = 0;
        if (args->size != 5 || results->size != 1) return make_trap(env, "ux.host_call4 arity mismatch");
        for (size_t i = 0; i < 5; ++i) if (args->data[i].kind != WASM_I32) return make_trap(env, "ux.host_call4 requires i32 values");
        if (results->data[0].kind != WASM_I32) results->data[0].kind = WASM_I32;
        id=args->data[0].of.i32; a=args->data[1].of.i32; b=args->data[2].of.i32; c=args->data[3].of.i32; d=args->data[4].of.i32;
        (void)b; (void)c; (void)d;
        switch (id) {
            double v;
            case 1: printf("%d", a); fflush(stdout); out=a; break;
            case 1000: printf("\n"); fflush(stdout); out=0; break;
            case 3: out=(int32_t)time(NULL); break;
            case 4: out=(int32_t)(host_rng_next(env) & UINT32_C(0x7fffffff)); break;
            case 5: env->rng_state=(uint32_t)a; if (!env->rng_state) env->rng_state=UINT32_C(0x6d2b79f5); out=a; break;
            case 10:
                if (a == INT32_MIN) return make_trap(env, "ABS host call overflows i32");
                out = a < 0 ? -a : a; break;
            case 11:
                if (a < 0) return make_trap(env, "SQR host call requires non-negative input");
                out = (int32_t)sqrt((double)a); break;
            case 12: v=sin((double)a); if (!host_double_to_i32(v,&out)) return make_trap(env,"SIN result is outside i32"); break;
            case 13: v=cos((double)a); if (!host_double_to_i32(v,&out)) return make_trap(env,"COS result is outside i32"); break;
            case 14: v=tan((double)a); if (!host_double_to_i32(v,&out)) return make_trap(env,"TAN result is outside i32"); break;
            case 15: v=atan((double)a); if (!host_double_to_i32(v,&out)) return make_trap(env,"ATAN result is outside i32"); break;
            case 16:
                if (a <= 0) return make_trap(env, "LOG host call requires positive input");
                v=log((double)a); if (!host_double_to_i32(v,&out)) return make_trap(env,"LOG result is outside i32"); break;
            case 17:
                v=exp((double)a); if (!host_double_to_i32(v,&out)) return make_trap(env,"EXP result is outside i32"); break;
            default: return make_trap(env, "uXBasic WASM host import is not bound in core-i32 profile");
        }
        results->data[0].kind=WASM_I32; results->data[0].of.i32=out; return NULL;
    }
    return make_trap(env, "uxwasmrt: unknown host callback kind");
}

static void host_env_free(void *opaque) { free(opaque); }

static int signature_matches(const wasm_functype_t *ft, HostKind kind) {
    const wasm_valtype_vec_t *p = g_api.functype_params(ft);
    const wasm_valtype_vec_t *r = g_api.functype_results(ft);
    size_t expected_p = kind == HOST_CALL4 ? 5u : 1u;
    size_t expected_r = kind == HOST_CALL4 ? 1u : 0u;
    if (!p || !r || p->size != expected_p || r->size != expected_r) return 0;
    for (size_t i=0;i<p->size;i++) {
        wasm_valkind_t k = g_api.valtype_kind(p->data[i]);
        if (kind == HOST_PRINT_F64) { if (k != WASM_F64) return 0; }
        else if (k != WASM_I32) return 0;
    }
    if (expected_r && g_api.valtype_kind(r->data[0]) != WASM_I32) return 0;
    return 1;
}

static void capture_trap(UxWasmSession *s, wasm_trap_t *trap, const char *prefix) {
    wasm_message_t message = {0, NULL};
    char text[UXWASMRT_ERROR_TEXT];
    if (!trap) { set_session_error(s, UXWASM_E_TRAP, prefix); return; }
    g_api.trap_message(trap, &message);
    if (message.data && message.size) {
        size_t n = message.size;
        if (n >= sizeof(text)) n = sizeof(text)-1;
        memcpy(text, message.data, n); text[n]='\0';
        char full[UXWASMRT_ERROR_TEXT];
        size_t prefix_len = strlen(prefix);
        size_t available = sizeof(full) > prefix_len + 3 ? sizeof(full) - prefix_len - 3 : 0;
        snprintf(full, sizeof(full), "%s: %.*s", prefix, (int)available, text);
        set_session_error(s, UXWASM_E_TRAP, full);
    } else set_session_error(s, UXWASM_E_TRAP, prefix);
    if (message.data) g_api.byte_vec_delete(&message);
    g_api.trap_delete(trap);
}

static void session_cleanup(UxWasmSession *s) {
    if (!s) return;
    if (s->exports.data) g_api.extern_vec_delete(&s->exports);
    if (s->export_types.data) g_api.exporttype_vec_delete(&s->export_types);
    if (s->instance) g_api.instance_delete(s->instance);
    for (size_t i=0;i<s->host_func_count;i++) if (s->host_funcs[i]) g_api.func_delete(s->host_funcs[i]);
    if (s->module) g_api.module_delete(s->module);
    if (s->store) g_api.store_delete(s->store);
    if (s->engine) g_api.engine_delete(s->engine);
    s->engine=NULL; s->store=NULL; s->module=NULL; s->instance=NULL;
    s->exports.size=0; s->exports.data=NULL; s->export_types.size=0; s->export_types.data=NULL;
    memset(s->host_funcs,0,sizeof(s->host_funcs)); s->host_func_count=0;
}

static int decode_handle(int32_t token, size_t *index_out, uint32_t *generation_out) {
    uint32_t u=(uint32_t)token, slot=u & UXWASMRT_TOKEN_INDEX_MASK;
    if (slot==0 || slot>UXWASMRT_MAX_SESSIONS) return 0;
    *index_out=(size_t)(slot-1u); *generation_out=u >> UXWASMRT_TOKEN_INDEX_BITS;
    return *generation_out != 0;
}

static UxWasmSession *session_from_handle(int32_t token, int set_error) {
    size_t idx; uint32_t gen;
    if (!decode_handle(token,&idx,&gen) || !g_sessions[idx].in_use || g_sessions[idx].generation!=gen) {
        if (set_error) set_global_error(UXWASM_E_HANDLE,"Invalid or stale uxwasmrt session handle");
        return NULL;
    }
    if (g_sessions[idx].owner_thread != ux_thread_id()) {
        if (set_error) set_session_error(&g_sessions[idx],UXWASM_E_THREAD,"uxwasmrt session used from a different thread");
        return NULL;
    }
    return &g_sessions[idx];
}

static int32_t allocate_session(UxWasmSession *built) {
    for (size_t i=0;i<UXWASMRT_MAX_SESSIONS;i++) {
        if (!g_sessions[i].in_use) {
            uint32_t next=g_sessions[i].generation+1u;
            if (next==0 || next>0x00ffffffu) next=1u;
            built->generation=next; built->in_use=1; built->owner_thread=ux_thread_id();
            g_sessions[i]=*built;
            return (int32_t)((next<<UXWASMRT_TOKEN_INDEX_BITS)|(uint32_t)(i+1u));
        }
    }
    set_global_error(UXWASM_E_CAPACITY,"uxwasmrt session table is full"); return 0;
}

static int setup_imports(UxWasmSession *s, wasm_extern_t **imports_data, size_t *count_out) {
    wasm_importtype_vec_t imports={0,NULL};
    g_api.module_imports(s->module,&imports);
    if (imports.size>UXWASMRT_MAX_IMPORTS) { g_api.importtype_vec_delete(&imports); set_session_error(s,UXWASM_E_IMPORT,"Module has too many imports for core profile"); return 0; }
    for (size_t i=0;i<imports.size;i++) {
        const wasm_name_t *m=g_api.importtype_module(imports.data[i]);
        const wasm_name_t *n=g_api.importtype_name(imports.data[i]);
        const wasm_externtype_t *et=g_api.importtype_type(imports.data[i]);
        const wasm_functype_t *ft;
        HostKind kind;
        char module_name[128], import_name[128], error[512];
        name_to_text(m,module_name,sizeof(module_name)); name_to_text(n,import_name,sizeof(import_name));
        if (!name_equals(m,"ux")) { snprintf(error,sizeof(error),"Unsupported WASM import module: %s.%s",module_name,import_name); g_api.importtype_vec_delete(&imports); set_session_error(s,UXWASM_E_IMPORT,error); return 0; }
        if (name_equals(n,"host_call4")) kind=HOST_CALL4;
        else if (name_equals(n,"print_i32")) kind=HOST_PRINT_I32;
        else if (name_equals(n,"print_f64")) kind=HOST_PRINT_F64;
        else { snprintf(error,sizeof(error),"Unsupported WASM import: ux.%s",import_name); g_api.importtype_vec_delete(&imports); set_session_error(s,UXWASM_E_IMPORT,error); return 0; }
        if (!et || g_api.externtype_kind(et)!=WASM_EXTERN_FUNC || !(ft=g_api.externtype_as_functype_const(et)) || !signature_matches(ft,kind)) {
            snprintf(error,sizeof(error),"WASM import signature mismatch: ux.%s",import_name); g_api.importtype_vec_delete(&imports); set_session_error(s,UXWASM_E_IMPORT,error); return 0;
        }
        HostEnv *env=(HostEnv*)calloc(1,sizeof(*env));
        if (!env) { g_api.importtype_vec_delete(&imports); set_session_error(s,UXWASM_E_IMPORT,"Out of memory creating host import"); return 0; }
        env->kind=kind; env->store=s->store; env->rng_state=UINT32_C(0x6d2b79f5);
        wasm_func_t *func=g_api.func_new_with_env(s->store,ft,host_callback,env,host_env_free);
        if (!func) { free(env); g_api.importtype_vec_delete(&imports); set_session_error(s,UXWASM_E_IMPORT,"Wasmtime could not create host import function"); return 0; }
        s->host_funcs[s->host_func_count++]=func; imports_data[i]=g_api.func_as_extern(func);
    }
    *count_out=imports.size;
    g_api.importtype_vec_delete(&imports);
    return 1;
}

static int open_module_into(const char *path, UxWasmSession *s) {
    unsigned char *raw=NULL; size_t raw_size=0; wasm_byte_vec_t binary={0,NULL};
    wasm_extern_t *imports_data[UXWASMRT_MAX_IMPORTS]={0}; size_t import_count=0;
    wasm_extern_vec_t imports={0,NULL}; wasm_trap_t *trap=NULL;
    memset(s,0,sizeof(*s));
    raw=read_file(path,&raw_size); if (!raw) return 0;
    s->engine=g_api.engine_new(); if (!s->engine) { free(raw); set_session_error(s,UXWASM_E_MODULE,"Wasmtime engine creation failed"); return 0; }
    s->store=g_api.store_new(s->engine); if (!s->store) { free(raw); set_session_error(s,UXWASM_E_MODULE,"Wasmtime store creation failed"); return 0; }
    g_api.byte_vec_new(&binary,raw_size,(const wasm_byte_t*)raw); free(raw); raw=NULL;
    if (!binary.data || binary.size!=raw_size) { set_session_error(s,UXWASM_E_MODULE,"WASM byte-vector allocation failed"); goto fail; }
    if (!g_api.module_validate(s->store,&binary)) { set_session_error(s,UXWASM_E_VALIDATE,"Wasmtime rejected the WASM binary"); goto fail; }
    s->module=g_api.module_new(s->store,&binary); if (!s->module) { set_session_error(s,UXWASM_E_MODULE,"Wasmtime module compilation failed"); goto fail; }
    g_api.byte_vec_delete(&binary); binary.data=NULL; binary.size=0;
    if (!setup_imports(s,imports_data,&import_count)) goto fail;
    imports.size=import_count; imports.data=imports_data;
    s->instance=g_api.instance_new(s->store,s->module,&imports,&trap);
    if (!s->instance) { if (trap) capture_trap(s,trap,"WASM instantiation trapped"); else set_session_error(s,UXWASM_E_INSTANCE,"WASM instance creation failed"); goto fail; }
    g_api.module_exports(s->module,&s->export_types);
    g_api.instance_exports(s->instance,&s->exports);
    if (s->export_types.size!=s->exports.size) { set_session_error(s,UXWASM_E_INSTANCE,"WASM export metadata/instance count mismatch"); goto fail; }
    clear_session_error(s); return 1;
fail:
    if (binary.data) g_api.byte_vec_delete(&binary);
    session_cleanup(s); return 0;
}

static wasm_func_t *find_export_func(UxWasmSession *s, const char *name) {
    if (!s || !name || !*name) { set_session_error(s,UXWASM_E_ARGUMENT,"WASM export name is empty"); return NULL; }
    for (size_t i=0;i<s->export_types.size;i++) {
        const wasm_name_t *n=g_api.exporttype_name(s->export_types.data[i]);
        const wasm_externtype_t *t=g_api.exporttype_type(s->export_types.data[i]);
        if (name_equals(n,name)) {
            if (!t || g_api.externtype_kind(t)!=WASM_EXTERN_FUNC) { set_session_error(s,UXWASM_E_EXPORT,"Requested WASM export is not a function"); return NULL; }
            wasm_func_t *f=g_api.extern_as_func(s->exports.data[i]);
            if (!f) set_session_error(s,UXWASM_E_EXPORT,"WASM function export cannot be resolved");
            return f;
        }
    }
    { char e[512]; snprintf(e,sizeof(e),"WASM function export not found: %s",name); set_session_error(s,UXWASM_E_EXPORT,e); }
    return NULL;
}

static int validate_i32_signature(UxWasmSession *s, wasm_func_t *func, size_t argc) {
    wasm_functype_t *ft;
    const wasm_valtype_vec_t *p,*r;
    if (g_api.func_param_arity(func)!=argc || g_api.func_result_arity(func)!=1) { set_session_error(s,UXWASM_E_SIGNATURE,"WASM function arity/result count does not match i32 call helper"); return 0; }
    ft=g_api.func_type(func); if (!ft) { set_session_error(s,UXWASM_E_SIGNATURE,"Cannot inspect WASM function type"); return 0; }
    p=g_api.functype_params(ft); r=g_api.functype_results(ft);
    if (!p || !r || p->size!=argc || r->size!=1 || g_api.valtype_kind(r->data[0])!=WASM_I32) { g_api.functype_delete(ft); set_session_error(s,UXWASM_E_SIGNATURE,"WASM function is not an i32-result core function"); return 0; }
    for (size_t i=0;i<argc;i++) if (g_api.valtype_kind(p->data[i])!=WASM_I32) { g_api.functype_delete(ft); set_session_error(s,UXWASM_E_SIGNATURE,"WASM function parameter is not i32"); return 0; }
    g_api.functype_delete(ft); return 1;
}

static int32_t call_i32(int32_t handle, const char *name, size_t argc, const int32_t *values) {
    UxWasmSession *s; wasm_func_t *func; wasm_val_t av[4]; wasm_val_t rv[1]; wasm_val_vec_t args,results; wasm_trap_t *trap;
    ux_lock();
    s=session_from_handle(handle,1); if (!s) { ux_unlock(); return 0; }
    clear_session_error(s);
    func=find_export_func(s,name); if (!func || !validate_i32_signature(s,func,argc)) { ux_unlock(); return 0; }
    for (size_t i=0;i<argc;i++) { av[i].kind=WASM_I32; av[i].of.i32=values[i]; }
    rv[0].kind=WASM_I32; rv[0].of.i32=0;
    args.size=argc; args.data=argc?av:NULL; results.size=1; results.data=rv;
    trap=g_api.func_call(func,&args,&results);
    if (trap) { capture_trap(s,trap,"WASM function trapped"); ux_unlock(); return 0; }
    if (rv[0].kind!=WASM_I32) { set_session_error(s,UXWASM_E_SIGNATURE,"Wasmtime returned a non-i32 value"); ux_unlock(); return 0; }
    clear_session_error(s); int32_t out=rv[0].of.i32; ux_unlock(); return out;
}

int32_t uxwasm_version(void) { return UXWASMRT_API_VERSION; }
const char *uxwasm_provider(void) { return "wasmtime-wasm-c-api/core-i32"; }

int32_t uxwasm_runtime_available(void) {
    int ok; ux_lock(); ok=ensure_runtime_loaded(); ux_unlock(); return ok;
}

const char *uxwasm_runtime_path(void) {
    ux_lock(); (void)ensure_runtime_loaded(); const char *p=g_runtime_path; ux_unlock(); return p;
}

int32_t uxwasm_validate_file(const char *path) {
    UxWasmSession temp; int ok;
    ux_lock();
    if (!ensure_runtime_loaded()) { ux_unlock(); return 0; }
    ok=open_module_into(path,&temp);
    if (!ok) { if (temp.error[0]) set_global_error(temp.error_code,temp.error); session_cleanup(&temp); ux_unlock(); return 0; }
    session_cleanup(&temp); set_global_error(UXWASM_E_OK,""); ux_unlock(); return 1;
}

int32_t uxwasm_open_file(const char *path) {
    UxWasmSession built; int32_t token;
    ux_lock();
    if (!ensure_runtime_loaded()) { ux_unlock(); return 0; }
    if (!open_module_into(path,&built)) { if (built.error[0]) set_global_error(built.error_code,built.error); session_cleanup(&built); ux_unlock(); return 0; }
    token=allocate_session(&built);
    if (!token) session_cleanup(&built);
    ux_unlock(); return token;
}

int32_t uxwasm_close(int32_t handle) {
    UxWasmSession *s; size_t idx; uint32_t gen;
    ux_lock();
    s=session_from_handle(handle,1); if (!s) { ux_unlock(); return 0; }
    decode_handle(handle,&idx,&gen); session_cleanup(s); s->in_use=0; s->owner_thread=0; s->last_ok=1; s->error_code=0; s->error[0]='\0';
    ux_unlock(); return 1;
}

int32_t uxwasm_has_export(int32_t handle, const char *name) {
    UxWasmSession *s; int found=0;
    ux_lock(); s=session_from_handle(handle,1); if (!s) { ux_unlock(); return 0; }
    clear_session_error(s);
    for (size_t i=0;i<s->export_types.size;i++) if (name_equals(g_api.exporttype_name(s->export_types.data[i]),name)) { found=1; break; }
    if (!found) set_session_error(s,UXWASM_E_EXPORT,"WASM export not found");
    ux_unlock(); return found;
}

int32_t uxwasm_call_i32_0(int32_t h,const char*n){ return call_i32(h,n,0,NULL); }
int32_t uxwasm_call_i32_1(int32_t h,const char*n,int32_t a0){ int32_t a[1]={a0}; return call_i32(h,n,1,a); }
int32_t uxwasm_call_i32_2(int32_t h,const char*n,int32_t a0,int32_t a1){ int32_t a[2]={a0,a1}; return call_i32(h,n,2,a); }
int32_t uxwasm_call_i32_3(int32_t h,const char*n,int32_t a0,int32_t a1,int32_t a2){ int32_t a[3]={a0,a1,a2}; return call_i32(h,n,3,a); }
int32_t uxwasm_call_i32_4(int32_t h,const char*n,int32_t a0,int32_t a1,int32_t a2,int32_t a3){ int32_t a[4]={a0,a1,a2,a3}; return call_i32(h,n,4,a); }

int32_t uxwasm_last_ok(int32_t handle) {
    int out=0; ux_lock();
    if (handle==0) out=(g_global_error_code==0);
    else { UxWasmSession *s=session_from_handle(handle,0); out=s?s->last_ok:0; }
    ux_unlock(); return out;
}

int32_t uxwasm_last_error_code(int32_t handle) {
    int out; ux_lock();
    if (handle==0) out=g_global_error_code;
    else { UxWasmSession *s=session_from_handle(handle,0); out=s?s->error_code:UXWASM_E_HANDLE; }
    ux_unlock(); return out;
}

const char *uxwasm_last_error(int32_t handle) {
    const char *out; ux_lock();
    if (handle==0) out=g_global_error;
    else { UxWasmSession *s=session_from_handle(handle,0); out=s?s->error:"Invalid or stale uxwasmrt session handle"; }
    ux_unlock(); return out;
}

void uxwasm_shutdown(void) {
    ux_lock();
    if (g_runtime) {
        for (size_t i=0;i<UXWASMRT_MAX_SESSIONS;i++) if (g_sessions[i].in_use) { session_cleanup(&g_sessions[i]); g_sessions[i].in_use=0; }
        ux_close_library(g_runtime); g_runtime=0; memset(&g_api,0,sizeof(g_api)); g_runtime_path[0]='\0';
    }
    ux_unlock();
}

#if defined(_WIN32)
BOOL WINAPI DllMain(HINSTANCE module, DWORD reason, LPVOID reserved) {
    (void)reserved;
    if (reason==DLL_PROCESS_ATTACH) { g_self_module=module; DisableThreadLibraryCalls(module); }
    return TRUE;
}
#endif
