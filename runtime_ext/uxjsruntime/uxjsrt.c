#include "uxjsrt.h"
#include "quickjs.h"

#include <errno.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined(_WIN32)
#include <windows.h>
#define UXJS_THREAD_LOCAL __declspec(thread)
#else
#include <pthread.h>
#include <sys/time.h>
#define UXJS_THREAD_LOCAL _Thread_local
#endif

#ifndef UXJSRT_QUICKJS_VERSION
#define UXJSRT_QUICKJS_VERSION "2026-06-04"
#endif

#define UXJS_MAX_RUNTIMES 16
#define UXJS_MAX_CONTEXTS 64
#define UXJS_MAX_RESULTS 1024
#define UXJS_ERROR_CAP 8192
#define UXJS_MAX_CALL_ARGS 64

#define UXJS_HANDLE_INDEX(h) (((uint32_t)(h) & 0xFFFFu) - 1u)
#define UXJS_HANDLE_GENERATION(h) (((uint32_t)(h) >> 16) & 0x7FFFu)

static UXJS_THREAD_LOCAL char g_last_error[UXJS_ERROR_CAP];

typedef struct RuntimeSlot {
    int used;
    uint16_t generation;
    JSRuntime *runtime;
    uint64_t owner_thread;
    uint64_t deadline_ms;
    int32_t time_limit_ms;
} RuntimeSlot;

typedef struct ContextSlot {
    int used;
    uint16_t generation;
    JSContext *context;
    int runtime_index;
    uint32_t random_state;
    char last_error[UXJS_ERROR_CAP];
    char *last_text;
    size_t last_text_cap;
} ContextSlot;

typedef struct ResultSlot {
    int used;
    uint16_t generation;
    int context_index;
    JSValue value;
} ResultSlot;

static RuntimeSlot g_runtimes[UXJS_MAX_RUNTIMES];
static ContextSlot g_contexts[UXJS_MAX_CONTEXTS];
static ResultSlot g_results[UXJS_MAX_RESULTS];

static uint64_t uxjs_now_ms(void) {
#if defined(_WIN32)
    return (uint64_t)GetTickCount64();
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000u + (uint64_t)ts.tv_nsec / 1000000u;
#endif
}

static uint64_t uxjs_thread_id(void) {
#if defined(_WIN32)
    return (uint64_t)GetCurrentThreadId();
#else
    return (uint64_t)(uintptr_t)pthread_self();
#endif
}

static uint16_t next_generation(uint16_t current) {
    uint16_t next = (uint16_t)(current + 1u);
    if (next == 0u || next > 0x7FFFu) next = 1u;
    return next;
}

static int32_t make_handle(uint16_t generation, int index) {
    return (int32_t)(((uint32_t)generation << 16) | (uint32_t)(index + 1));
}

static void set_global_error(const char *message) {
    snprintf(g_last_error, sizeof(g_last_error), "%s", message ? message : "unknown uxjsrt error");
}

static void set_context_error(ContextSlot *slot, const char *message) {
    if (!slot) {
        set_global_error(message);
        return;
    }
    snprintf(slot->last_error, sizeof(slot->last_error), "%s", message ? message : "unknown uxjsrt error");
    set_global_error(slot->last_error);
}

static void clear_context_error(ContextSlot *slot) {
    if (slot) slot->last_error[0] = '\0';
    g_last_error[0] = '\0';
}

static RuntimeSlot *get_runtime(int32_t handle, int *index_out) {
    uint32_t raw = (uint32_t)handle;
    uint32_t low = raw & 0xFFFFu;
    uint32_t index;
    uint32_t generation;
    RuntimeSlot *slot;
    if (handle <= 0 || low == 0u) return NULL;
    index = UXJS_HANDLE_INDEX(handle);
    generation = UXJS_HANDLE_GENERATION(handle);
    if (index >= UXJS_MAX_RUNTIMES) return NULL;
    slot = &g_runtimes[index];
    if (!slot->used || slot->generation != generation || !slot->runtime) return NULL;
    if (slot->owner_thread != uxjs_thread_id()) {
        set_global_error("UXJS_THREAD_AFFINITY: QuickJS runtime must be used on its owner thread");
        return NULL;
    }
    if (index_out) *index_out = (int)index;
    return slot;
}

static ContextSlot *get_context(int32_t handle, int *index_out) {
    uint32_t raw = (uint32_t)handle;
    uint32_t low = raw & 0xFFFFu;
    uint32_t index;
    uint32_t generation;
    ContextSlot *slot;
    RuntimeSlot *runtime_slot;
    if (handle <= 0 || low == 0u) return NULL;
    index = UXJS_HANDLE_INDEX(handle);
    generation = UXJS_HANDLE_GENERATION(handle);
    if (index >= UXJS_MAX_CONTEXTS) return NULL;
    slot = &g_contexts[index];
    if (!slot->used || slot->generation != generation || !slot->context) return NULL;
    if (slot->runtime_index < 0 || slot->runtime_index >= UXJS_MAX_RUNTIMES) return NULL;
    runtime_slot = &g_runtimes[slot->runtime_index];
    if (!runtime_slot->used || runtime_slot->owner_thread != uxjs_thread_id()) {
        set_context_error(slot, "UXJS_THREAD_AFFINITY: QuickJS context must be used on its owner thread");
        return NULL;
    }
    if (index_out) *index_out = (int)index;
    return slot;
}

static ResultSlot *get_result(int32_t handle, int context_index, int *index_out) {
    uint32_t raw = (uint32_t)handle;
    uint32_t low = raw & 0xFFFFu;
    uint32_t index;
    uint32_t generation;
    ResultSlot *slot;
    if (handle <= 0 || low == 0u) return NULL;
    index = UXJS_HANDLE_INDEX(handle);
    generation = UXJS_HANDLE_GENERATION(handle);
    if (index >= UXJS_MAX_RESULTS) return NULL;
    slot = &g_results[index];
    if (!slot->used || slot->generation != generation || slot->context_index != context_index) return NULL;
    if (index_out) *index_out = (int)index;
    return slot;
}

static int uxjs_interrupt_handler(JSRuntime *runtime, void *opaque) {
    RuntimeSlot *slot = (RuntimeSlot *)opaque;
    (void)runtime;
    if (!slot || slot->deadline_ms == 0u) return 0;
    return uxjs_now_ms() >= slot->deadline_ms;
}

static void begin_deadline(RuntimeSlot *slot) {
    if (!slot) return;
    slot->deadline_ms = slot->time_limit_ms > 0 ? uxjs_now_ms() + (uint64_t)slot->time_limit_ms : 0u;
}

static void end_deadline(RuntimeSlot *slot) {
    if (slot) slot->deadline_ms = 0u;
}

static void capture_exception(ContextSlot *slot, const char *prefix) {
    JSContext *ctx;
    JSValue exception;
    JSValue stack_value;
    const char *message;
    const char *stack_text;
    char buffer[UXJS_ERROR_CAP];
    if (!slot || !slot->context) {
        set_global_error(prefix ? prefix : "QuickJS exception");
        return;
    }
    ctx = slot->context;
    exception = JS_GetException(ctx);
    message = JS_ToCString(ctx, exception);
    stack_value = JS_GetPropertyStr(ctx, exception, "stack");
    stack_text = JS_IsException(stack_value) ? NULL : JS_ToCString(ctx, stack_value);
    if (stack_text && *stack_text) {
        snprintf(buffer, sizeof(buffer), "%s: %s\n%s", prefix ? prefix : "QuickJS exception", message ? message : "<exception>", stack_text);
    } else {
        snprintf(buffer, sizeof(buffer), "%s: %s", prefix ? prefix : "QuickJS exception", message ? message : "<exception>");
    }
    if (stack_text) JS_FreeCString(ctx, stack_text);
    if (!JS_IsException(stack_value)) JS_FreeValue(ctx, stack_value);
    if (message) JS_FreeCString(ctx, message);
    JS_FreeValue(ctx, exception);
    set_context_error(slot, buffer);
}

static int store_last_text(ContextSlot *slot, const char *text) {
    size_t needed;
    char *replacement;
    if (!slot) return 0;
    if (!text) text = "";
    needed = strlen(text) + 1u;
    if (needed > slot->last_text_cap) {
        replacement = (char *)realloc(slot->last_text, needed);
        if (!replacement) {
            set_context_error(slot, "UXJS_OOM: result text allocation failed");
            return 0;
        }
        slot->last_text = replacement;
        slot->last_text_cap = needed;
    }
    memcpy(slot->last_text, text, needed);
    return 1;
}

static int32_t alloc_result(int context_index, JSValue value) {
    int i;
    for (i = 0; i < UXJS_MAX_RESULTS; ++i) {
        ResultSlot *slot = &g_results[i];
        if (!slot->used) {
            slot->generation = next_generation(slot->generation);
            slot->used = 1;
            slot->context_index = context_index;
            slot->value = value;
            return make_handle(slot->generation, i);
        }
    }
    return 0;
}

static void free_results_for_context(int context_index) {
    int i;
    ContextSlot *context_slot = &g_contexts[context_index];
    for (i = 0; i < UXJS_MAX_RESULTS; ++i) {
        ResultSlot *slot = &g_results[i];
        if (slot->used && slot->context_index == context_index) {
            JS_FreeValue(context_slot->context, slot->value);
            slot->used = 0;
            slot->context_index = -1;
            slot->generation = next_generation(slot->generation);
        }
    }
}

static char *read_file_all(const char *path, size_t *length_out) {
    FILE *file;
    long size;
    size_t read_count;
    char *buffer;
    if (!path || !*path) return NULL;
    file = fopen(path, "rb");
    if (!file) return NULL;
    if (fseek(file, 0, SEEK_END) != 0) { fclose(file); return NULL; }
    size = ftell(file);
    if (size < 0) { fclose(file); return NULL; }
    if (fseek(file, 0, SEEK_SET) != 0) { fclose(file); return NULL; }
    buffer = (char *)malloc((size_t)size + 1u);
    if (!buffer) { fclose(file); return NULL; }
    read_count = fread(buffer, 1u, (size_t)size, file);
    fclose(file);
    if (read_count != (size_t)size) { free(buffer); return NULL; }
    buffer[read_count] = '\0';
    if (length_out) *length_out = read_count;
    return buffer;
}

static int eval_internal(ContextSlot *context_slot, const char *source, size_t length, const char *filename, int32_t flags) {
    RuntimeSlot *runtime_slot;
    JSValue result;
    int eval_flags = (flags & UXJSRT_EVAL_MODULE) ? JS_EVAL_TYPE_MODULE : JS_EVAL_TYPE_GLOBAL;
    int jobs;
    if (!context_slot || !source) return 0;
    runtime_slot = &g_runtimes[context_slot->runtime_index];
    clear_context_error(context_slot);
    begin_deadline(runtime_slot);
    result = JS_Eval(context_slot->context, source, length, filename ? filename : "<uxjs-eval>", eval_flags);
    end_deadline(runtime_slot);
    if (JS_IsException(result)) {
        capture_exception(context_slot, "UXJS_EVAL_FAILED");
        return 0;
    }
    JS_FreeValue(context_slot->context, result);
    if (flags & UXJSRT_EVAL_DRAIN_JOBS) {
        jobs = uxjs_execute_pending_jobs(make_handle(runtime_slot->generation, context_slot->runtime_index), 100000);
        if (jobs < 0) return 0;
    }
    return 1;
}

static JSValue native_print_common(JSContext *ctx, int argc, JSValueConst *argv, int newline) {
    int i;
    for (i = 0; i < argc; ++i) {
        const char *text = JS_ToCString(ctx, argv[i]);
        if (!text) return JS_EXCEPTION;
        if (i > 0) fputc(' ', stdout);
        fputs(text, stdout);
        JS_FreeCString(ctx, text);
    }
    if (newline) fputc('\n', stdout);
    fflush(stdout);
    return JS_UNDEFINED;
}

static JSValue js_native_print(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    (void)this_value;
    return native_print_common(ctx, argc, argv, 0);
}

static JSValue js_native_println(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    (void)this_value;
    return native_print_common(ctx, argc, argv, 1);
}

static JSValue js_native_now_ms(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    (void)this_value; (void)argc; (void)argv;
    return JS_NewFloat64(ctx, (double)uxjs_now_ms());
}

static JSValue js_native_random_u32(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    ContextSlot *slot = (ContextSlot *)JS_GetContextOpaque(ctx);
    uint32_t x;
    (void)this_value; (void)argc; (void)argv;
    if (!slot) return JS_ThrowInternalError(ctx, "UXB_CONTEXT_OPAQUE_MISSING");
    x = slot->random_state ? slot->random_state : 0xA341316Cu;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    slot->random_state = x;
    return JS_NewUint32(ctx, x);
}

static JSValue js_native_version(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    (void)this_value; (void)argc; (void)argv;
    return JS_NewString(ctx, UXJSRT_QUICKJS_VERSION);
}

static JSValue js_native_api_version(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    (void)this_value; (void)argc; (void)argv;
    return JS_NewInt32(ctx, UXJSRT_API_VERSION);
}

static JSValue js_native_host_call(JSContext *ctx, JSValueConst this_value, int argc, JSValueConst *argv) {
    const char *name = NULL;
    const char *response;
    char runtime_info[128];
    (void)this_value;
    if (argc > 0) name = JS_ToCString(ctx, argv[0]);
    if (name && strcmp(name, "UXB_RUNTIME_INFO") == 0) {
        snprintf(runtime_info, sizeof(runtime_info),
                 "{\"ok\":true,\"value\":{\"provider\":\"quickjs\",\"apiVersion\":%d}}",
                 UXJSRT_API_VERSION);
        response = runtime_info;
    } else {
        response = "{\"ok\":false,\"error\":{\"code\":\"UXB_HOST_UNSUPPORTED\",\"message\":\"Native QuickJS host service is not installed\"}}";
    }
    if (name) JS_FreeCString(ctx, name);
    return JS_NewString(ctx, response);
}

static int install_result_encoder(ContextSlot *slot) {
    static const char helper_source[] =
        "globalThis.__uxbEncodeResult = function(value) {"
        "  try {"
        "    if (value === undefined) return '{\\\"$uxbType\\\":\\\"undefined\\\"}';"
        "    if (typeof value === 'function') return JSON.stringify({$uxbType:'function',name:value.name||''});"
        "    return JSON.stringify(value, function(_key,item){"
        "      return typeof item === 'bigint' ? {$uxbType:'bigint',value:item.toString()} : item;"
        "    });"
        "  } catch (error) {"
        "    return JSON.stringify({$uxbType:'unserializable',message:String(error && error.message ? error.message : error)});"
        "  }"
        "};";
    return eval_internal(slot, helper_source, sizeof(helper_source) - 1u, "<uxb-result-encoder>", 0);
}

static int parse_arguments(ContextSlot *slot, const char *arguments_json, JSValue *array_out) {
    const char *json = (arguments_json && *arguments_json) ? arguments_json : "[]";
    JSValue args = JS_ParseJSON(slot->context, json, strlen(json), "<uxjs-arguments>");
    if (JS_IsException(args)) {
        capture_exception(slot, "UXJS_ARGUMENT_JSON_FAILED");
        return 0;
    }
    if (!JS_IsArray(slot->context, args)) {
        JS_FreeValue(slot->context, args);
        set_context_error(slot, "UXJS_ARGUMENT_JSON_TYPE: arguments_json must be a JSON array");
        return 0;
    }
    *array_out = args;
    return 1;
}

static int resolve_function(ContextSlot *slot, const char *function_name, JSValue *function_out, JSValue *this_out) {
    JSContext *ctx = slot->context;
    JSValue current;
    JSValue next;
    const char *cursor;
    char part[256];
    size_t length;
    if (!function_name || !*function_name) {
        set_context_error(slot, "UXJS_FUNCTION_NAME_MISSING");
        return 0;
    }
    cursor = function_name;
    if (strncmp(cursor, "globalThis.", 11u) == 0) cursor += 11u;
    current = JS_GetGlobalObject(ctx);
    for (;;) {
        const char *dot = strchr(cursor, '.');
        length = dot ? (size_t)(dot - cursor) : strlen(cursor);
        if (length == 0u || length >= sizeof(part)) {
            JS_FreeValue(ctx, current);
            set_context_error(slot, "UXJS_FUNCTION_PATH_INVALID");
            return 0;
        }
        memcpy(part, cursor, length);
        part[length] = '\0';
        next = JS_GetPropertyStr(ctx, current, part);
        if (JS_IsException(next)) {
            JS_FreeValue(ctx, current);
            capture_exception(slot, "UXJS_FUNCTION_RESOLVE_FAILED");
            return 0;
        }
        if (!dot) {
            if (!JS_IsFunction(ctx, next)) {
                JS_FreeValue(ctx, next);
                JS_FreeValue(ctx, current);
                set_context_error(slot, "UXJS_FUNCTION_NOT_CALLABLE");
                return 0;
            }
            *function_out = next;
            *this_out = current;
            return 1;
        }
        JS_FreeValue(ctx, current);
        current = next;
        cursor = dot + 1;
    }
}

static int arguments_to_argv(ContextSlot *slot, JSValue args_array, JSValue **argv_out, int *argc_out) {
    JSContext *ctx = slot->context;
    JSValue length_value;
    uint32_t length = 0;
    JSValue *argv = NULL;
    uint32_t i;
    length_value = JS_GetPropertyStr(ctx, args_array, "length");
    if (JS_IsException(length_value) || JS_ToUint32(ctx, &length, length_value) < 0) {
        if (!JS_IsException(length_value)) JS_FreeValue(ctx, length_value);
        capture_exception(slot, "UXJS_ARGUMENT_LENGTH_FAILED");
        return 0;
    }
    JS_FreeValue(ctx, length_value);
    if (length > UXJS_MAX_CALL_ARGS) {
        set_context_error(slot, "UXJS_ARGUMENT_LIMIT: at most 64 JavaScript call arguments are supported");
        return 0;
    }
    if (length > 0u) {
        argv = (JSValue *)calloc(length, sizeof(JSValue));
        if (!argv) {
            set_context_error(slot, "UXJS_OOM: argument vector allocation failed");
            return 0;
        }
    }
    for (i = 0; i < length; ++i) {
        argv[i] = JS_GetPropertyUint32(ctx, args_array, i);
        if (JS_IsException(argv[i])) {
            uint32_t j;
            for (j = 0; j < i; ++j) JS_FreeValue(ctx, argv[j]);
            free(argv);
            capture_exception(slot, "UXJS_ARGUMENT_READ_FAILED");
            return 0;
        }
    }
    *argv_out = argv;
    *argc_out = (int)length;
    return 1;
}

static void free_argv(JSContext *ctx, JSValue *argv, int argc) {
    int i;
    if (!argv) return;
    for (i = 0; i < argc; ++i) JS_FreeValue(ctx, argv[i]);
    free(argv);
}

int32_t UXJSRT_CALL uxjs_version(void) {
    return UXJSRT_API_VERSION;
}

int32_t UXJSRT_CALL uxjs_contract_version(void) {
    return UXJSRT_CONTRACT_VERSION;
}

const char *UXJSRT_CALL uxjs_quickjs_version(void) {
    return UXJSRT_QUICKJS_VERSION;
}

int32_t UXJSRT_CALL uxjs_runtime_create(void) {
    int i;
    JSRuntime *runtime;
    g_last_error[0] = '\0';
    for (i = 0; i < UXJS_MAX_RUNTIMES; ++i) {
        RuntimeSlot *slot = &g_runtimes[i];
        if (!slot->used) {
            runtime = JS_NewRuntime();
            if (!runtime) {
                set_global_error("UXJS_RUNTIME_CREATE_FAILED");
                return 0;
            }
            slot->generation = next_generation(slot->generation);
            slot->used = 1;
            slot->runtime = runtime;
            slot->owner_thread = uxjs_thread_id();
            slot->deadline_ms = 0u;
            slot->time_limit_ms = 0;
            JS_SetInterruptHandler(runtime, uxjs_interrupt_handler, slot);
            return make_handle(slot->generation, i);
        }
    }
    set_global_error("UXJS_RUNTIME_LIMIT: no free runtime slots");
    return 0;
}

static void free_context_index(int context_index) {
    ContextSlot *slot = &g_contexts[context_index];
    if (!slot->used) return;
    free_results_for_context(context_index);
    JS_FreeContext(slot->context);
    free(slot->last_text);
    slot->last_text = NULL;
    slot->last_text_cap = 0u;
    slot->context = NULL;
    slot->runtime_index = -1;
    slot->used = 0;
    slot->generation = next_generation(slot->generation);
}

int32_t UXJSRT_CALL uxjs_runtime_free(int32_t runtime_handle) {
    int runtime_index;
    int i;
    RuntimeSlot *slot = get_runtime(runtime_handle, &runtime_index);
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_RUNTIME_HANDLE_INVALID");
        return 0;
    }
    for (i = 0; i < UXJS_MAX_CONTEXTS; ++i) {
        if (g_contexts[i].used && g_contexts[i].runtime_index == runtime_index) free_context_index(i);
    }
    JS_FreeRuntime(slot->runtime);
    slot->runtime = NULL;
    slot->used = 0;
    slot->deadline_ms = 0u;
    slot->generation = next_generation(slot->generation);
    return 1;
}

int32_t UXJSRT_CALL uxjs_runtime_set_memory_limit_mb(int32_t runtime_handle, int32_t megabytes) {
    RuntimeSlot *slot = get_runtime(runtime_handle, NULL);
    if (!slot || megabytes <= 0 || megabytes > 32768) {
        if (!g_last_error[0]) set_global_error("UXJS_MEMORY_LIMIT_INVALID");
        return 0;
    }
    JS_SetMemoryLimit(slot->runtime, (size_t)megabytes * 1024u * 1024u);
    return 1;
}

int32_t UXJSRT_CALL uxjs_runtime_set_stack_limit_kb(int32_t runtime_handle, int32_t kilobytes) {
    RuntimeSlot *slot = get_runtime(runtime_handle, NULL);
    if (!slot || kilobytes <= 0 || kilobytes > 1048576) {
        if (!g_last_error[0]) set_global_error("UXJS_STACK_LIMIT_INVALID");
        return 0;
    }
    JS_SetMaxStackSize(slot->runtime, (size_t)kilobytes * 1024u);
    return 1;
}

int32_t UXJSRT_CALL uxjs_runtime_set_time_limit_ms(int32_t runtime_handle, int32_t milliseconds) {
    RuntimeSlot *slot = get_runtime(runtime_handle, NULL);
    if (!slot || milliseconds < 0) {
        if (!g_last_error[0]) set_global_error("UXJS_TIME_LIMIT_INVALID");
        return 0;
    }
    slot->time_limit_ms = milliseconds;
    return 1;
}

int32_t UXJSRT_CALL uxjs_runtime_collect_garbage(int32_t runtime_handle) {
    RuntimeSlot *slot = get_runtime(runtime_handle, NULL);
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_RUNTIME_HANDLE_INVALID");
        return 0;
    }
    JS_RunGC(slot->runtime);
    return 1;
}

int32_t UXJSRT_CALL uxjs_context_create(int32_t runtime_handle) {
    int runtime_index;
    int i;
    RuntimeSlot *runtime_slot = get_runtime(runtime_handle, &runtime_index);
    JSContext *context;
    if (!runtime_slot) {
        if (!g_last_error[0]) set_global_error("UXJS_RUNTIME_HANDLE_INVALID");
        return 0;
    }
    for (i = 0; i < UXJS_MAX_CONTEXTS; ++i) {
        ContextSlot *slot = &g_contexts[i];
        if (!slot->used) {
            context = JS_NewContext(runtime_slot->runtime);
            if (!context) {
                set_global_error("UXJS_CONTEXT_CREATE_FAILED");
                return 0;
            }
            slot->generation = next_generation(slot->generation);
            slot->used = 1;
            slot->context = context;
            slot->runtime_index = runtime_index;
            slot->random_state = (uint32_t)(uxjs_now_ms() ^ (uint64_t)(i + 1) * 2654435761u);
            slot->last_error[0] = '\0';
            slot->last_text = NULL;
            slot->last_text_cap = 0u;
            JS_SetContextOpaque(context, slot);
            return make_handle(slot->generation, i);
        }
    }
    set_global_error("UXJS_CONTEXT_LIMIT: no free context slots");
    return 0;
}

int32_t UXJSRT_CALL uxjs_context_free(int32_t context_handle) {
    int context_index;
    ContextSlot *slot = get_context(context_handle, &context_index);
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    free_context_index(context_index);
    return 1;
}

int32_t UXJSRT_CALL uxjs_install_native_host(int32_t context_handle) {
    ContextSlot *slot = get_context(context_handle, NULL);
    JSContext *ctx;
    JSValue global;
    JSValue native;
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    clear_context_error(slot);
    ctx = slot->context;
    global = JS_GetGlobalObject(ctx);
    native = JS_NewObject(ctx);
    JS_SetPropertyStr(ctx, native, "print", JS_NewCFunction(ctx, js_native_print, "print", 1));
    JS_SetPropertyStr(ctx, native, "println", JS_NewCFunction(ctx, js_native_println, "println", 1));
    JS_SetPropertyStr(ctx, native, "nowMs", JS_NewCFunction(ctx, js_native_now_ms, "nowMs", 0));
    JS_SetPropertyStr(ctx, native, "randomU32", JS_NewCFunction(ctx, js_native_random_u32, "randomU32", 0));
    JS_SetPropertyStr(ctx, native, "hostCall", JS_NewCFunction(ctx, js_native_host_call, "hostCall", 2));
    JS_SetPropertyStr(ctx, native, "version", JS_NewCFunction(ctx, js_native_version, "version", 0));
    JS_SetPropertyStr(ctx, native, "apiVersion", JS_NewCFunction(ctx, js_native_api_version, "apiVersion", 0));
    if (JS_SetPropertyStr(ctx, global, "__uxbNative", native) < 0) {
        JS_FreeValue(ctx, global);
        capture_exception(slot, "UXJS_NATIVE_HOST_INSTALL_FAILED");
        return 0;
    }
    JS_FreeValue(ctx, global);
    return install_result_encoder(slot);
}

int32_t UXJSRT_CALL uxjs_eval(int32_t context_handle, const char *source, const char *filename, int32_t flags) {
    ContextSlot *slot = get_context(context_handle, NULL);
    if (!slot || !source) {
        if (!g_last_error[0]) set_global_error("UXJS_EVAL_ARGUMENT_INVALID");
        return 0;
    }
    return eval_internal(slot, source, strlen(source), filename, flags);
}

int32_t UXJSRT_CALL uxjs_eval_file(int32_t context_handle, const char *path, int32_t flags) {
    ContextSlot *slot = get_context(context_handle, NULL);
    size_t length = 0u;
    char *source;
    int result;
    if (!slot || !path || !*path) {
        if (!g_last_error[0]) set_global_error("UXJS_EVAL_FILE_ARGUMENT_INVALID");
        return 0;
    }
    source = read_file_all(path, &length);
    if (!source) {
        char buffer[UXJS_ERROR_CAP];
        snprintf(buffer, sizeof(buffer), "UXJS_FILE_READ_FAILED: %s", path);
        set_context_error(slot, buffer);
        return 0;
    }
    result = eval_internal(slot, source, length, path, flags);
    free(source);
    return result;
}

int32_t UXJSRT_CALL uxjs_bootstrap_uxb(int32_t context_handle, const char *core_path, const char *provider_path) {
    ContextSlot *slot = get_context(context_handle, NULL);
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    if (!uxjs_install_native_host(context_handle)) return 0;
    if (!uxjs_eval_file(context_handle, core_path, 0)) return 0;
    if (!uxjs_eval_file(context_handle, provider_path, 0)) return 0;
    return 1;
}

int32_t UXJSRT_CALL uxjs_execute_pending_jobs(int32_t runtime_handle, int32_t max_jobs) {
    RuntimeSlot *slot = get_runtime(runtime_handle, NULL);
    JSContext *job_context = NULL;
    int executed = 0;
    int rc;
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_RUNTIME_HANDLE_INVALID");
        return -1;
    }
    if (max_jobs <= 0) max_jobs = 100000;
    begin_deadline(slot);
    while (executed < max_jobs) {
        rc = JS_ExecutePendingJob(slot->runtime, &job_context);
        if (rc == 0) break;
        if (rc < 0) {
            int i;
            end_deadline(slot);
            for (i = 0; i < UXJS_MAX_CONTEXTS; ++i) {
                if (g_contexts[i].used && g_contexts[i].context == job_context) {
                    capture_exception(&g_contexts[i], "UXJS_PENDING_JOB_FAILED");
                    break;
                }
            }
            if (i == UXJS_MAX_CONTEXTS) set_global_error("UXJS_PENDING_JOB_FAILED");
            return -1;
        }
        ++executed;
    }
    end_deadline(slot);
    /* Reaching the requested batch size is not itself an error. The await
       caller inspects settlement state and reports pending external I/O. */
    return executed;
}

int32_t UXJSRT_CALL uxjs_call_json(int32_t context_handle, const char *function_name, const char *arguments_json) {
    int context_index;
    ContextSlot *slot = get_context(context_handle, &context_index);
    RuntimeSlot *runtime_slot;
    JSValue args_array = JS_UNDEFINED;
    JSValue function = JS_UNDEFINED;
    JSValue this_value = JS_UNDEFINED;
    JSValue result;
    JSValue *argv = NULL;
    int argc = 0;
    int32_t result_handle;
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    clear_context_error(slot);
    if (!parse_arguments(slot, arguments_json, &args_array)) return 0;
    if (!resolve_function(slot, function_name, &function, &this_value)) {
        JS_FreeValue(slot->context, args_array);
        return 0;
    }
    if (!arguments_to_argv(slot, args_array, &argv, &argc)) {
        JS_FreeValue(slot->context, function);
        JS_FreeValue(slot->context, this_value);
        JS_FreeValue(slot->context, args_array);
        return 0;
    }
    runtime_slot = &g_runtimes[slot->runtime_index];
    begin_deadline(runtime_slot);
    result = JS_Call(slot->context, function, this_value, argc, (JSValueConst *)argv);
    end_deadline(runtime_slot);
    free_argv(slot->context, argv, argc);
    JS_FreeValue(slot->context, function);
    JS_FreeValue(slot->context, this_value);
    JS_FreeValue(slot->context, args_array);
    if (JS_IsException(result)) {
        capture_exception(slot, "UXJS_CALL_FAILED");
        return 0;
    }
    result_handle = alloc_result(context_index, result);
    if (!result_handle) {
        JS_FreeValue(slot->context, result);
        set_context_error(slot, "UXJS_RESULT_LIMIT: no free result slots");
        return 0;
    }
    return result_handle;
}

static void clear_await_globals(JSContext *ctx) {
    JSValue global = JS_GetGlobalObject(ctx);
    JS_SetPropertyStr(ctx, global, "__uxbCallName", JS_UNDEFINED);
    JS_SetPropertyStr(ctx, global, "__uxbCallArgs", JS_UNDEFINED);
    JS_SetPropertyStr(ctx, global, "__uxbCallState", JS_UNDEFINED);
    JS_FreeValue(ctx, global);
}

int32_t UXJSRT_CALL uxjs_call_json_await(int32_t context_handle, const char *function_name, const char *arguments_json, int32_t max_jobs) {
    static const char await_source[] =
        "globalThis.__uxbCallState={done:false,ok:false,value:undefined,error:''};"
        "Promise.resolve((function(){"
        " const parts=String(globalThis.__uxbCallName).split('.').filter(Boolean);"
        " let parent=globalThis; let value=globalThis;"
        " for(const part of parts){ parent=value; value=value[part]; }"
        " if(typeof value!=='function') throw new Error('UXJS_FUNCTION_NOT_CALLABLE');"
        " return value.apply(parent,globalThis.__uxbCallArgs);"
        "})()).then("
        " value=>{globalThis.__uxbCallState={done:true,ok:true,value:value,error:''};},"
        " error=>{globalThis.__uxbCallState={done:true,ok:false,value:undefined,error:String(error&&error.stack?error.stack:error)};}"
        ");";
    int context_index;
    ContextSlot *slot = get_context(context_handle, &context_index);
    RuntimeSlot *runtime_slot;
    JSContext *ctx;
    JSValue global;
    JSValue args_array = JS_UNDEFINED;
    JSValue state;
    JSValue done_value;
    JSValue ok_value;
    JSValue value;
    JSValue error_value;
    int done;
    int ok;
    int jobs;
    int32_t result_handle;
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    clear_context_error(slot);
    if (!parse_arguments(slot, arguments_json, &args_array)) return 0;
    ctx = slot->context;
    global = JS_GetGlobalObject(ctx);
    JS_SetPropertyStr(ctx, global, "__uxbCallName", JS_NewString(ctx, function_name ? function_name : ""));
    JS_SetPropertyStr(ctx, global, "__uxbCallArgs", args_array);
    JS_FreeValue(ctx, global);
    if (!eval_internal(slot, await_source, sizeof(await_source) - 1u, "<uxjs-call-await>", 0)) {
        clear_await_globals(ctx);
        return 0;
    }
    runtime_slot = &g_runtimes[slot->runtime_index];
    jobs = uxjs_execute_pending_jobs(make_handle(runtime_slot->generation, slot->runtime_index), max_jobs > 0 ? max_jobs : 100000);
    if (jobs < 0) { clear_await_globals(ctx); return 0; }
    global = JS_GetGlobalObject(ctx);
    state = JS_GetPropertyStr(ctx, global, "__uxbCallState");
    JS_FreeValue(ctx, global);
    if (JS_IsException(state)) {
        capture_exception(slot, "UXJS_AWAIT_STATE_FAILED");
        clear_await_globals(ctx);
        return 0;
    }
    done_value = JS_GetPropertyStr(ctx, state, "done");
    ok_value = JS_GetPropertyStr(ctx, state, "ok");
    done = JS_ToBool(ctx, done_value);
    ok = JS_ToBool(ctx, ok_value);
    JS_FreeValue(ctx, done_value);
    JS_FreeValue(ctx, ok_value);
    if (!done) {
        JS_FreeValue(ctx, state);
        clear_await_globals(ctx);
        set_context_error(slot, "UXJS_ASYNC_PENDING_EXTERNAL_IO: promise did not settle in the QuickJS job queue");
        return 0;
    }
    if (!ok) {
        const char *error_text;
        error_value = JS_GetPropertyStr(ctx, state, "error");
        error_text = JS_ToCString(ctx, error_value);
        set_context_error(slot, error_text ? error_text : "UXJS_ASYNC_CALL_FAILED");
        if (error_text) JS_FreeCString(ctx, error_text);
        JS_FreeValue(ctx, error_value);
        JS_FreeValue(ctx, state);
        clear_await_globals(ctx);
        return 0;
    }
    value = JS_GetPropertyStr(ctx, state, "value");
    JS_FreeValue(ctx, state);
    if (JS_IsException(value)) {
        capture_exception(slot, "UXJS_ASYNC_RESULT_FAILED");
        clear_await_globals(ctx);
        return 0;
    }
    result_handle = alloc_result(context_index, value);
    if (!result_handle) {
        JS_FreeValue(ctx, value);
        clear_await_globals(ctx);
        set_context_error(slot, "UXJS_RESULT_LIMIT: no free result slots");
        return 0;
    }
    clear_await_globals(ctx);
    return result_handle;
}

const char *UXJSRT_CALL uxjs_result_json(int32_t context_handle, int32_t result_handle) {
    int context_index;
    ContextSlot *slot = get_context(context_handle, &context_index);
    ResultSlot *result_slot;
    JSContext *ctx;
    JSValue global;
    JSValue encoder;
    JSValue encoded;
    const char *text;
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return "";
    }
    result_slot = get_result(result_handle, context_index, NULL);
    if (!result_slot) {
        set_context_error(slot, "UXJS_RESULT_HANDLE_INVALID");
        return "";
    }
    ctx = slot->context;
    global = JS_GetGlobalObject(ctx);
    encoder = JS_GetPropertyStr(ctx, global, "__uxbEncodeResult");
    JS_FreeValue(ctx, global);
    if (JS_IsException(encoder) || !JS_IsFunction(ctx, encoder)) {
        if (!JS_IsException(encoder)) JS_FreeValue(ctx, encoder);
        set_context_error(slot, "UXJS_RESULT_ENCODER_MISSING");
        return "";
    }
    encoded = JS_Call(ctx, encoder, JS_UNDEFINED, 1, (JSValueConst *)&result_slot->value);
    JS_FreeValue(ctx, encoder);
    if (JS_IsException(encoded)) {
        capture_exception(slot, "UXJS_RESULT_JSON_FAILED");
        return "";
    }
    text = JS_ToCString(ctx, encoded);
    if (!text) {
        JS_FreeValue(ctx, encoded);
        capture_exception(slot, "UXJS_RESULT_TEXT_FAILED");
        return "";
    }
    if (!store_last_text(slot, text)) {
        JS_FreeCString(ctx, text);
        JS_FreeValue(ctx, encoded);
        return "";
    }
    JS_FreeCString(ctx, text);
    JS_FreeValue(ctx, encoded);
    return slot->last_text ? slot->last_text : "";
}

int32_t UXJSRT_CALL uxjs_result_free(int32_t context_handle, int32_t result_handle) {
    int context_index;
    int result_index;
    ContextSlot *slot = get_context(context_handle, &context_index);
    ResultSlot *result_slot;
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    result_slot = get_result(result_handle, context_index, &result_index);
    if (!result_slot) {
        set_context_error(slot, "UXJS_RESULT_HANDLE_INVALID");
        return 0;
    }
    JS_FreeValue(slot->context, result_slot->value);
    result_slot->used = 0;
    result_slot->context_index = -1;
    result_slot->generation = next_generation(result_slot->generation);
    (void)result_index;
    return 1;
}

const char *UXJSRT_CALL uxjs_last_error(int32_t context_handle) {
    ContextSlot *slot;
    if (context_handle <= 0) return g_last_error;
    slot = get_context(context_handle, NULL);
    if (!slot) return g_last_error;
    return slot->last_error;
}

int32_t UXJSRT_CALL uxjs_context_clear_error(int32_t context_handle) {
    ContextSlot *slot = get_context(context_handle, NULL);
    if (!slot) {
        if (!g_last_error[0]) set_global_error("UXJS_CONTEXT_HANDLE_INVALID");
        return 0;
    }
    clear_context_error(slot);
    return 1;
}
