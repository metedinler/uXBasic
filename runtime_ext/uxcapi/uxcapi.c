#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <ffi.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <wchar.h>
#include "uxcapi.h"

#define UXCAPI_VERSION 200
#define UXCAPI_ERROR_CAPACITY 2048
#define UXCAPI_MODULE_CAPACITY 256

#if defined(_MSC_VER)
#define UXC_TLS __declspec(thread)
#elif defined(__GNUC__)
#define UXC_TLS __thread
#else
#define UXC_TLS
#endif

typedef union uxc_value {
    int8_t i8;
    uint8_t u8;
    int16_t i16;
    uint16_t u16;
    int32_t i32;
    uint32_t u32;
    int64_t i64;
    uint64_t u64;
    float f32;
    double f64;
    long double fld;
    void *ptr;
} uxc_value;

typedef struct uxc_type_descriptor uxc_type_descriptor;

struct uxc_type_descriptor {
    int32_t record_kind;
    ffi_type ffi;
    ffi_type **elements;
    uxc_type_descriptor **nested_types;
    size_t element_count;
    size_t element_capacity;
    uint64_t expected_size;
    uint32_t expected_alignment;
    int32_t finalized;
    LONG reference_count;
};

typedef struct uxc_argument {
    int32_t kind;
    uxc_value value;
    void *owned;
    ffi_type *ffi_type_override;
    uxc_type_descriptor *aggregate_type;
    size_t byte_size;
} uxc_argument;

typedef struct uxc_argument_list {
    uxc_argument *items;
    size_t count;
    size_t capacity;
} uxc_argument_list;

typedef struct uxc_call {
    HMODULE module;
    FARPROC proc;
    char dll_name[MAX_PATH];
    char symbol_name[512];
    int32_t return_kind;
    int32_t is_variadic;
    int32_t fixed_argument_count;
    uxc_argument_list arguments;
    uxc_value result;
    uxc_type_descriptor *return_aggregate_type;
    void *result_storage;
    size_t result_storage_size;
    char error[UXCAPI_ERROR_CAPACITY];
    int32_t invoked;
} uxc_call;

typedef struct uxc_module_cache_entry {
    char name[MAX_PATH];
    HMODULE module;
} uxc_module_cache_entry;

typedef struct uxc_callback_event {
    uxc_argument *arguments;
    int32_t argument_count;
    struct uxc_callback_event *next;
} uxc_callback_event;

typedef struct uxc_callback {
    int32_t return_kind;
    uxc_value default_value;
    int32_t *argument_kinds;
    size_t argument_count;
    size_t argument_capacity;
    ffi_cif cif;
    ffi_closure *closure;
    void *code_pointer;
    CRITICAL_SECTION lock;
    int32_t lock_initialized;
    uxc_callback_event *head;
    uxc_callback_event *tail;
    uint64_t pending;
} uxc_callback;

static UXC_TLS char g_last_error[UXCAPI_ERROR_CAPACITY];
static uxc_module_cache_entry g_modules[UXCAPI_MODULE_CAPACITY];
static int32_t g_module_count = 0;
static SRWLOCK g_module_lock = SRWLOCK_INIT;
static INIT_ONCE g_init_once = INIT_ONCE_STATIC_INIT;

static BOOL CALLBACK uxcapi_initialize_once(PINIT_ONCE once, PVOID param, PVOID *context) {
    (void)once;
    (void)param;
    (void)context;
    SetDefaultDllDirectories(
        LOAD_LIBRARY_SEARCH_APPLICATION_DIR |
        LOAD_LIBRARY_SEARCH_SYSTEM32 |
        LOAD_LIBRARY_SEARCH_USER_DIRS
    );
    return TRUE;
}

static void ensure_initialized(void) {
    InitOnceExecuteOnce(&g_init_once, uxcapi_initialize_once, NULL, NULL);
}

static void set_last_error_text(const char *text) {
    if (!text) text = "";
    snprintf(g_last_error, sizeof(g_last_error), "%s", text);
    g_last_error[sizeof(g_last_error) - 1] = '\0';
}

static void set_call_error(uxc_call *call, const char *text) {
    set_last_error_text(text);
    if (!call) return;
    snprintf(call->error, sizeof(call->error), "%s", text ? text : "");
    call->error[sizeof(call->error) - 1] = '\0';
}

static char *duplicate_string(const char *text) {
    size_t size;
    char *copy;
    if (!text) text = "";
    size = strlen(text) + 1;
    copy = (char *)malloc(size);
    if (!copy) return NULL;
    memcpy(copy, text, size);
    return copy;
}

static wchar_t *utf8_to_wide(const char *text) {
    int count;
    wchar_t *result;
    if (!text) text = "";
    count = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, text, -1, NULL, 0);
    if (count <= 0) {
        count = MultiByteToWideChar(CP_ACP, 0, text, -1, NULL, 0);
        if (count <= 0) return NULL;
        result = (wchar_t *)calloc((size_t)count, sizeof(wchar_t));
        if (!result) return NULL;
        if (MultiByteToWideChar(CP_ACP, 0, text, -1, result, count) <= 0) {
            free(result);
            return NULL;
        }
        return result;
    }
    result = (wchar_t *)calloc((size_t)count, sizeof(wchar_t));
    if (!result) return NULL;
    if (MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, text, -1, result, count) <= 0) {
        free(result);
        return NULL;
    }
    return result;
}

static HMODULE get_module(const char *dll_name) {
    HMODULE module = NULL;
    int32_t i;
    if (!dll_name || !*dll_name) {
        set_last_error_text("DLL name is empty");
        return NULL;
    }
    ensure_initialized();

    AcquireSRWLockShared(&g_module_lock);
    for (i = 0; i < g_module_count; ++i) {
        if (_stricmp(g_modules[i].name, dll_name) == 0) {
            module = g_modules[i].module;
            break;
        }
    }
    ReleaseSRWLockShared(&g_module_lock);
    if (module) return module;

    AcquireSRWLockExclusive(&g_module_lock);
    for (i = 0; i < g_module_count; ++i) {
        if (_stricmp(g_modules[i].name, dll_name) == 0) {
            module = g_modules[i].module;
            break;
        }
    }
    if (!module) {
        if (g_module_count >= UXCAPI_MODULE_CAPACITY) {
            ReleaseSRWLockExclusive(&g_module_lock);
            set_last_error_text("DLL module cache is full");
            return NULL;
        }
        module = LoadLibraryExA(
            dll_name,
            NULL,
            LOAD_LIBRARY_SEARCH_APPLICATION_DIR |
            LOAD_LIBRARY_SEARCH_SYSTEM32 |
            LOAD_LIBRARY_SEARCH_USER_DIRS
        );
        if (!module) {
            DWORD code = GetLastError();
            char message[512];
            snprintf(
                message, sizeof(message),
                "LoadLibraryExA failed for %s; Win32 error=%lu",
                dll_name, (unsigned long)code
            );
            ReleaseSRWLockExclusive(&g_module_lock);
            set_last_error_text(message);
            return NULL;
        }
        snprintf(g_modules[g_module_count].name, MAX_PATH, "%s", dll_name);
        g_modules[g_module_count].name[MAX_PATH - 1] = '\0';
        g_modules[g_module_count].module = module;
        ++g_module_count;
    }
    ReleaseSRWLockExclusive(&g_module_lock);
    return module;
}

static ffi_type *kind_to_ffi_type(int32_t kind) {
    switch (kind) {
        case UXC_KIND_VOID: return &ffi_type_void;
        case UXC_KIND_I8: return &ffi_type_sint8;
        case UXC_KIND_U8: return &ffi_type_uint8;
        case UXC_KIND_I16: return &ffi_type_sint16;
        case UXC_KIND_U16: return &ffi_type_uint16;
        case UXC_KIND_I32: return &ffi_type_sint32;
        case UXC_KIND_U32: return &ffi_type_uint32;
        case UXC_KIND_I64: return &ffi_type_sint64;
        case UXC_KIND_U64: return &ffi_type_uint64;
        case UXC_KIND_F32: return &ffi_type_float;
        case UXC_KIND_F64: return &ffi_type_double;
        case UXC_KIND_PTR:
        case UXC_KIND_STRPTR:
        case UXC_KIND_WSTRPTR:
            return &ffi_type_pointer;
        case UXC_KIND_LONGDOUBLE:
            return &ffi_type_longdouble;
        default:
            return NULL;
    }
}

static int kind_is_scalar_ffi(int32_t kind) {
    return kind_to_ffi_type(kind) != NULL && kind != UXC_KIND_VOID;
}

static void type_descriptor_retain(uxc_type_descriptor *descriptor) {
    if (descriptor) InterlockedIncrement(&descriptor->reference_count);
}

static void type_descriptor_release(uxc_type_descriptor *descriptor) {
    size_t i;
    if (!descriptor) return;
    if (InterlockedDecrement(&descriptor->reference_count) != 0) return;
    for (i = 0; i < descriptor->element_count; ++i) {
        type_descriptor_release(descriptor->nested_types[i]);
    }
    free(descriptor->elements);
    free(descriptor->nested_types);
    free(descriptor);
}

static int ensure_type_capacity(uxc_type_descriptor *descriptor, size_t wanted) {
    size_t next_capacity;
    ffi_type **next_elements;
    uxc_type_descriptor **next_nested;
    if (!descriptor || descriptor->finalized) {
        set_last_error_text("Type descriptor is null or already finalized");
        return 0;
    }
    if (wanted <= descriptor->element_capacity) return 1;
    next_capacity = descriptor->element_capacity ? descriptor->element_capacity * 2 : 8;
    while (next_capacity < wanted) next_capacity *= 2;
    next_elements = (ffi_type **)calloc(next_capacity + 1, sizeof(*next_elements));
    next_nested = (uxc_type_descriptor **)calloc(next_capacity, sizeof(*next_nested));
    if (!next_elements || !next_nested) {
        free(next_elements);
        free(next_nested);
        set_last_error_text("Out of memory growing aggregate descriptor");
        return 0;
    }
    if (descriptor->element_count) {
        memcpy(next_elements, descriptor->elements, descriptor->element_count * sizeof(*next_elements));
        memcpy(next_nested, descriptor->nested_types, descriptor->element_count * sizeof(*next_nested));
    }
    free(descriptor->elements);
    free(descriptor->nested_types);
    descriptor->elements = next_elements;
    descriptor->nested_types = next_nested;
    descriptor->element_capacity = next_capacity;
    return 1;
}

static int add_type_element(
    uxc_type_descriptor *descriptor,
    ffi_type *element,
    uxc_type_descriptor *nested
) {
    if (!descriptor || descriptor->record_kind != UXC_KIND_STRUCT) {
        set_last_error_text("Fields can only be added to STRUCT descriptors");
        return 0;
    }
    if (!element || !ensure_type_capacity(descriptor, descriptor->element_count + 1)) return 0;
    descriptor->elements[descriptor->element_count] = element;
    descriptor->nested_types[descriptor->element_count] = nested;
    if (nested) type_descriptor_retain(nested);
    ++descriptor->element_count;
    descriptor->elements[descriptor->element_count] = NULL;
    return 1;
}

static uxc_type_descriptor *new_type_descriptor(int32_t record_kind) {
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)calloc(1, sizeof(*descriptor));
    if (!descriptor) {
        set_last_error_text("Out of memory creating aggregate descriptor");
        return NULL;
    }
    descriptor->record_kind = record_kind;
    descriptor->reference_count = 1;
    descriptor->ffi.type = FFI_TYPE_STRUCT;
    descriptor->ffi.elements = NULL;
    return descriptor;
}

static ffi_type *argument_ffi_type(const uxc_argument *argument) {
    if (!argument) return NULL;
    if (argument->ffi_type_override) return argument->ffi_type_override;
    return kind_to_ffi_type(argument->kind);
}

static void *argument_value_address(uxc_argument *argument) {
    if (!argument) return NULL;
    if (argument->kind == UXC_KIND_STRUCT) return argument->owned;
    return &argument->value;
}

static void free_argument(uxc_argument *argument) {
    if (!argument) return;
    free(argument->owned);
    argument->owned = NULL;
    type_descriptor_release(argument->aggregate_type);
    argument->aggregate_type = NULL;
    argument->ffi_type_override = NULL;
    argument->byte_size = 0;
}

static void clear_argument_list(uxc_argument_list *list) {
    size_t i;
    if (!list) return;
    for (i = 0; i < list->count; ++i) free_argument(&list->items[i]);
    free(list->items);
    list->items = NULL;
    list->count = 0;
    list->capacity = 0;
}

static int ensure_argument_capacity(uxc_argument_list *list, size_t wanted) {
    size_t next_capacity;
    uxc_argument *next;
    if (wanted <= list->capacity) return 1;
    next_capacity = list->capacity ? list->capacity * 2 : 8;
    while (next_capacity < wanted) next_capacity *= 2;
    next = (uxc_argument *)realloc(list->items, next_capacity * sizeof(*next));
    if (!next) {
        set_last_error_text("Out of memory while growing argument list");
        return 0;
    }
    memset(
        next + list->capacity,
        0,
        (next_capacity - list->capacity) * sizeof(*next)
    );
    list->items = next;
    list->capacity = next_capacity;
    return 1;
}

static int add_argument_value(
    uxc_argument_list *list,
    int32_t kind,
    uxc_value value,
    void *owned
) {
    uxc_argument *argument;
    if (!kind_is_scalar_ffi(kind)) {
        free(owned);
        set_last_error_text("Invalid scalar argument kind");
        return 0;
    }
    if (!ensure_argument_capacity(list, list->count + 1)) {
        free(owned);
        return 0;
    }
    argument = &list->items[list->count++];
    memset(argument, 0, sizeof(*argument));
    argument->kind = kind;
    argument->value = value;
    argument->owned = owned;
    return 1;
}

static int add_aggregate_argument(
    uxc_argument_list *list,
    uxc_type_descriptor *descriptor,
    const void *data,
    uint64_t byte_count
) {
    uxc_argument *argument;
    void *copy;
    if (!list || !descriptor || descriptor->record_kind != UXC_KIND_STRUCT || !descriptor->finalized) {
        set_last_error_text("STRUCT argument requires a finalized STRUCT descriptor");
        return 0;
    }
    if (!data || byte_count != descriptor->ffi.size || byte_count > SIZE_MAX) {
        set_last_error_text("STRUCT argument byte count does not match finalized layout");
        return 0;
    }
    copy = malloc((size_t)byte_count ? (size_t)byte_count : 1);
    if (!copy) {
        set_last_error_text("Out of memory copying STRUCT argument");
        return 0;
    }
    memcpy(copy, data, (size_t)byte_count);
    if (!ensure_argument_capacity(list, list->count + 1)) {
        free(copy);
        return 0;
    }
    argument = &list->items[list->count++];
    memset(argument, 0, sizeof(*argument));
    argument->kind = UXC_KIND_STRUCT;
    argument->owned = copy;
    argument->ffi_type_override = &descriptor->ffi;
    argument->aggregate_type = descriptor;
    argument->byte_size = (size_t)byte_count;
    type_descriptor_retain(descriptor);
    return 1;
}

static int copy_argument(
    uxc_argument_list *target,
    const uxc_argument *source
) {
    uxc_value value = source->value;
    void *owned = NULL;
    if (source->kind == UXC_KIND_STRUCT) {
        return add_aggregate_argument(
            target,
            source->aggregate_type,
            source->owned,
            (uint64_t)source->byte_size
        );
    }
    if (source->kind == UXC_KIND_STRPTR && source->value.ptr) {
        owned = duplicate_string((const char *)source->value.ptr);
        if (!owned) return 0;
        value.ptr = owned;
    } else if (source->kind == UXC_KIND_WSTRPTR && source->value.ptr) {
        size_t count = wcslen((const wchar_t *)source->value.ptr) + 1;
        owned = calloc(count, sizeof(wchar_t));
        if (!owned) return 0;
        memcpy(owned, source->value.ptr, count * sizeof(wchar_t));
        value.ptr = owned;
    }
    return add_argument_value(target, source->kind, value, owned);
}

static int add_i64_kind(uxc_argument_list *list, int32_t kind, int64_t value) {
    uxc_value v;
    memset(&v, 0, sizeof(v));
    switch (kind) {
        case UXC_KIND_I8: v.i8 = (int8_t)value; break;
        case UXC_KIND_U8: v.u8 = (uint8_t)value; break;
        case UXC_KIND_I16: v.i16 = (int16_t)value; break;
        case UXC_KIND_U16: v.u16 = (uint16_t)value; break;
        case UXC_KIND_I32: v.i32 = (int32_t)value; break;
        case UXC_KIND_U32: v.u32 = (uint32_t)value; break;
        case UXC_KIND_I64: v.i64 = value; break;
        case UXC_KIND_U64: v.u64 = (uint64_t)value; break;
        default:
            set_last_error_text("Integer helper received non-integer kind");
            return 0;
    }
    return add_argument_value(list, kind, v, NULL);
}

static int add_u64_kind(uxc_argument_list *list, int32_t kind, uint64_t value) {
    uxc_value v;
    memset(&v, 0, sizeof(v));
    switch (kind) {
        case UXC_KIND_U8: v.u8 = (uint8_t)value; break;
        case UXC_KIND_U16: v.u16 = (uint16_t)value; break;
        case UXC_KIND_U32: v.u32 = (uint32_t)value; break;
        case UXC_KIND_U64: v.u64 = value; break;
        default:
            set_last_error_text("Unsigned helper received non-unsigned kind");
            return 0;
    }
    return add_argument_value(list, kind, v, NULL);
}

static int add_float_kind(uxc_argument_list *list, int32_t kind, double value) {
    uxc_value v;
    memset(&v, 0, sizeof(v));
    if (kind == UXC_KIND_F32) v.f32 = (float)value;
    else if (kind == UXC_KIND_F64) v.f64 = value;
    else if (kind == UXC_KIND_LONGDOUBLE) v.fld = (long double)value;
    else {
        set_last_error_text("Floating helper received non-floating kind");
        return 0;
    }
    return add_argument_value(list, kind, v, NULL);
}

static int add_pointer_kind(
    uxc_argument_list *list,
    int32_t kind,
    void *pointer,
    void *owned
) {
    uxc_value v;
    memset(&v, 0, sizeof(v));
    v.ptr = pointer;
    return add_argument_value(list, kind, v, owned);
}

int32_t UXCAPI_CALL uxcapi_version(void) {
    return UXCAPI_VERSION;
}

const char *UXCAPI_CALL uxcapi_last_error(void) {
    return g_last_error;
}

void UXCAPI_CALL uxcapi_shutdown(void) {
    int32_t i;
    AcquireSRWLockExclusive(&g_module_lock);
    for (i = 0; i < g_module_count; ++i) {
        if (g_modules[i].module) FreeLibrary(g_modules[i].module);
    }
    memset(g_modules, 0, sizeof(g_modules));
    g_module_count = 0;
    ReleaseSRWLockExclusive(&g_module_lock);
    set_last_error_text("");
}

void *UXCAPI_CALL uxcapi_symbol_address(
    const char *dll_name,
    const char *symbol_name
) {
    HMODULE module = get_module(dll_name);
    FARPROC proc;
    if (!module) return NULL;
    if (!symbol_name || !*symbol_name) {
        set_last_error_text("Symbol name is empty");
        return NULL;
    }
    proc = GetProcAddress(module, symbol_name);
    if (!proc) {
        char message[768];
        snprintf(
            message, sizeof(message),
            "GetProcAddress failed: %s!%s",
            dll_name, symbol_name
        );
        set_last_error_text(message);
        return NULL;
    }
    set_last_error_text("");
    return (void *)(uintptr_t)proc;
}

void *UXCAPI_CALL uxcapi_type_struct_new(void) {
    uxc_type_descriptor *descriptor = new_type_descriptor(UXC_KIND_STRUCT);
    if (descriptor) set_last_error_text("");
    return descriptor;
}

void *UXCAPI_CALL uxcapi_type_union_new(uint64_t size_bytes, uint32_t alignment_bytes) {
    uxc_type_descriptor *descriptor;
    if (size_bytes == 0 || size_bytes > SIZE_MAX || alignment_bytes == 0) {
        set_last_error_text("UNION descriptor requires non-zero size and alignment");
        return NULL;
    }
    descriptor = new_type_descriptor(UXC_KIND_UNION);
    if (!descriptor) return NULL;
    descriptor->expected_size = size_bytes;
    descriptor->expected_alignment = alignment_bytes;
    descriptor->ffi.size = (size_t)size_bytes;
    descriptor->ffi.alignment = (unsigned short)alignment_bytes;
    descriptor->finalized = 1;
    set_last_error_text("");
    return descriptor;
}

int32_t UXCAPI_CALL uxcapi_type_add_field(void *type_handle, int32_t field_kind) {
    ffi_type *field_type = kind_to_ffi_type(field_kind);
    if (!field_type || field_kind == UXC_KIND_VOID || field_kind == UXC_KIND_STRUCT || field_kind == UXC_KIND_UNION) {
        set_last_error_text("Invalid scalar field kind");
        return 0;
    }
    return add_type_element((uxc_type_descriptor *)type_handle, field_type, NULL);
}

int32_t UXCAPI_CALL uxcapi_type_add_struct_field(void *type_handle, void *field_type_handle) {
    uxc_type_descriptor *field = (uxc_type_descriptor *)field_type_handle;
    if (!field || field->record_kind != UXC_KIND_STRUCT || !field->finalized) {
        set_last_error_text("Nested field requires a finalized STRUCT descriptor");
        return 0;
    }
    return add_type_element((uxc_type_descriptor *)type_handle, &field->ffi, field);
}

int32_t UXCAPI_CALL uxcapi_type_add_array_field(void *type_handle, int32_t element_kind, uint64_t element_count) {
    uint64_t i;
    if (element_count == 0 || element_count > SIZE_MAX) {
        set_last_error_text("Array field count is invalid");
        return 0;
    }
    for (i = 0; i < element_count; ++i) {
        if (!uxcapi_type_add_field(type_handle, element_kind)) return 0;
    }
    return 1;
}

int32_t UXCAPI_CALL uxcapi_type_add_struct_array_field(void *type_handle, void *field_type_handle, uint64_t element_count) {
    uint64_t i;
    if (element_count == 0 || element_count > SIZE_MAX) {
        set_last_error_text("STRUCT array field count is invalid");
        return 0;
    }
    for (i = 0; i < element_count; ++i) {
        if (!uxcapi_type_add_struct_field(type_handle, field_type_handle)) return 0;
    }
    return 1;
}

int32_t UXCAPI_CALL uxcapi_type_set_expected_layout(void *type_handle, uint64_t size_bytes, uint32_t alignment_bytes) {
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)type_handle;
    if (!descriptor || descriptor->finalized || size_bytes > SIZE_MAX) {
        set_last_error_text("Cannot set expected layout on this descriptor");
        return 0;
    }
    descriptor->expected_size = size_bytes;
    descriptor->expected_alignment = alignment_bytes;
    return 1;
}

int32_t UXCAPI_CALL uxcapi_type_finalize(void *type_handle) {
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)type_handle;
    ffi_cif cif;
    ffi_status status;
    if (!descriptor) return 0;
    if (descriptor->record_kind == UXC_KIND_UNION) return descriptor->finalized;
    if (descriptor->record_kind != UXC_KIND_STRUCT || descriptor->element_count == 0) {
        set_last_error_text("STRUCT descriptor has no fields");
        return 0;
    }
    if (descriptor->finalized) return 1;
    descriptor->ffi.type = FFI_TYPE_STRUCT;
    descriptor->ffi.elements = descriptor->elements;
    descriptor->ffi.size = 0;
    descriptor->ffi.alignment = 0;
    status = ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 0, &descriptor->ffi, NULL);
    if (status != FFI_OK) {
        set_last_error_text("libffi rejected STRUCT descriptor");
        return 0;
    }
    if (descriptor->expected_size && descriptor->expected_size != descriptor->ffi.size) {
        set_last_error_text("STRUCT size differs from compiler layout; use pointer or generated C adapter");
        return 0;
    }
    if (descriptor->expected_alignment && descriptor->expected_alignment != descriptor->ffi.alignment) {
        set_last_error_text("STRUCT alignment differs from compiler layout; use pointer or generated C adapter");
        return 0;
    }
    descriptor->finalized = 1;
    set_last_error_text("");
    return 1;
}

int32_t UXCAPI_CALL uxcapi_type_kind(void *type_handle) {
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)type_handle;
    return descriptor ? descriptor->record_kind : UXC_KIND_VOID;
}

uint64_t UXCAPI_CALL uxcapi_type_size(void *type_handle) {
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)type_handle;
    return descriptor ? (uint64_t)descriptor->ffi.size : 0;
}

uint32_t UXCAPI_CALL uxcapi_type_alignment(void *type_handle) {
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)type_handle;
    return descriptor ? (uint32_t)descriptor->ffi.alignment : 0;
}

void UXCAPI_CALL uxcapi_type_free(void *type_handle) {
    type_descriptor_release((uxc_type_descriptor *)type_handle);
}

void *UXCAPI_CALL uxcapi_call_new(
    const char *dll_name,
    const char *symbol_name,
    int32_t return_kind,
    int32_t is_variadic,
    int32_t fixed_argument_count
) {
    uxc_call *call;
    HMODULE module;
    FARPROC proc;
    if (!kind_to_ffi_type(return_kind)) {
        set_last_error_text("Invalid return kind");
        return NULL;
    }
    if (fixed_argument_count < 0) {
        set_last_error_text("Fixed argument count cannot be negative");
        return NULL;
    }
    module = get_module(dll_name);
    if (!module) return NULL;
    proc = GetProcAddress(module, symbol_name);
    if (!proc) {
        char message[768];
        snprintf(
            message, sizeof(message),
            "GetProcAddress failed: %s!%s",
            dll_name ? dll_name : "",
            symbol_name ? symbol_name : ""
        );
        set_last_error_text(message);
        return NULL;
    }
    call = (uxc_call *)calloc(1, sizeof(*call));
    if (!call) {
        set_last_error_text("Out of memory creating call");
        return NULL;
    }
    call->module = module;
    call->proc = proc;
    call->return_kind = return_kind;
    call->is_variadic = is_variadic ? 1 : 0;
    call->fixed_argument_count = fixed_argument_count;
    snprintf(call->dll_name, sizeof(call->dll_name), "%s", dll_name ? dll_name : "");
    snprintf(call->symbol_name, sizeof(call->symbol_name), "%s", symbol_name ? symbol_name : "");
    set_last_error_text("");
    return call;
}

void UXCAPI_CALL uxcapi_call_free(void *call_handle) {
    uxc_call *call = (uxc_call *)call_handle;
    if (!call) return;
    clear_argument_list(&call->arguments);
    type_descriptor_release(call->return_aggregate_type);
    free(call->result_storage);
    free(call);
}

int32_t UXCAPI_CALL uxcapi_call_clear_arguments(void *call_handle) {
    uxc_call *call = (uxc_call *)call_handle;
    if (!call) return 0;
    clear_argument_list(&call->arguments);
    free(call->result_storage);
    call->result_storage = NULL;
    call->result_storage_size = 0;
    call->invoked = 0;
    memset(&call->result, 0, sizeof(call->result));
    call->error[0] = '\0';
    return 1;
}

int32_t UXCAPI_CALL uxcapi_call_set_return_struct(void *call_handle, void *type_handle) {
    uxc_call *call = (uxc_call *)call_handle;
    uxc_type_descriptor *descriptor = (uxc_type_descriptor *)type_handle;
    if (!call || !descriptor || descriptor->record_kind != UXC_KIND_STRUCT || !descriptor->finalized) {
        set_last_error_text("Return STRUCT requires a finalized STRUCT descriptor");
        return 0;
    }
    type_descriptor_release(call->return_aggregate_type);
    call->return_aggregate_type = descriptor;
    type_descriptor_retain(descriptor);
    call->return_kind = UXC_KIND_STRUCT;
    free(call->result_storage);
    call->result_storage = NULL;
    call->result_storage_size = 0;
    call->invoked = 0;
    return 1;
}

#define CALL_ARG_SIGNED(name, kind, ctype) \
int32_t UXCAPI_CALL name(void *call_handle, ctype value) { \
    uxc_call *call = (uxc_call *)call_handle; \
    return call ? add_i64_kind(&call->arguments, kind, (int64_t)value) : 0; \
}

#define CALL_ARG_UNSIGNED(name, kind, ctype) \
int32_t UXCAPI_CALL name(void *call_handle, ctype value) { \
    uxc_call *call = (uxc_call *)call_handle; \
    return call ? add_u64_kind(&call->arguments, kind, (uint64_t)value) : 0; \
}

CALL_ARG_SIGNED(uxcapi_call_arg_i8, UXC_KIND_I8, int32_t)
CALL_ARG_UNSIGNED(uxcapi_call_arg_u8, UXC_KIND_U8, uint32_t)
CALL_ARG_SIGNED(uxcapi_call_arg_i16, UXC_KIND_I16, int32_t)
CALL_ARG_UNSIGNED(uxcapi_call_arg_u16, UXC_KIND_U16, uint32_t)
CALL_ARG_SIGNED(uxcapi_call_arg_i32, UXC_KIND_I32, int32_t)
CALL_ARG_UNSIGNED(uxcapi_call_arg_u32, UXC_KIND_U32, uint32_t)
CALL_ARG_SIGNED(uxcapi_call_arg_i64, UXC_KIND_I64, int64_t)
CALL_ARG_UNSIGNED(uxcapi_call_arg_u64, UXC_KIND_U64, uint64_t)

int32_t UXCAPI_CALL uxcapi_call_arg_f32(void *call_handle, double value) {
    uxc_call *call = (uxc_call *)call_handle;
    return call ? add_float_kind(&call->arguments, UXC_KIND_F32, value) : 0;
}

int32_t UXCAPI_CALL uxcapi_call_arg_f64(void *call_handle, double value) {
    uxc_call *call = (uxc_call *)call_handle;
    return call ? add_float_kind(&call->arguments, UXC_KIND_F64, value) : 0;
}

int32_t UXCAPI_CALL uxcapi_call_arg_long_double_from_f64(void *call_handle, double value) {
    uxc_call *call = (uxc_call *)call_handle;
    return call ? add_float_kind(&call->arguments, UXC_KIND_LONGDOUBLE, value) : 0;
}

int32_t UXCAPI_CALL uxcapi_call_arg_struct(void *call_handle, void *type_handle, const void *data, uint64_t byte_count) {
    uxc_call *call = (uxc_call *)call_handle;
    return call ? add_aggregate_argument(&call->arguments, (uxc_type_descriptor *)type_handle, data, byte_count) : 0;
}

int32_t UXCAPI_CALL uxcapi_call_arg_ptr(void *call_handle, void *value) {
    uxc_call *call = (uxc_call *)call_handle;
    return call ? add_pointer_kind(&call->arguments, UXC_KIND_PTR, value, NULL) : 0;
}

int32_t UXCAPI_CALL uxcapi_call_arg_string(void *call_handle, const char *value) {
    uxc_call *call = (uxc_call *)call_handle;
    char *copy;
    if (!call) return 0;
    copy = duplicate_string(value);
    if (!copy) return 0;
    return add_pointer_kind(&call->arguments, UXC_KIND_STRPTR, copy, copy);
}

int32_t UXCAPI_CALL uxcapi_call_arg_wstring_utf8(void *call_handle, const char *utf8_value) {
    uxc_call *call = (uxc_call *)call_handle;
    wchar_t *copy;
    if (!call) return 0;
    copy = utf8_to_wide(utf8_value);
    if (!copy) return 0;
    return add_pointer_kind(&call->arguments, UXC_KIND_WSTRPTR, copy, copy);
}

void *UXCAPI_CALL uxcapi_args_new(void) {
    return calloc(1, sizeof(uxc_argument_list));
}

void UXCAPI_CALL uxcapi_args_free(void *args_handle) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    if (!list) return;
    clear_argument_list(list);
    free(list);
}

int32_t UXCAPI_CALL uxcapi_args_clear(void *args_handle) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    if (!list) return 0;
    clear_argument_list(list);
    return 1;
}

#define ARGS_ADD_SIGNED(name, kind, ctype) \
int32_t UXCAPI_CALL name(void *args_handle, ctype value) { \
    uxc_argument_list *list = (uxc_argument_list *)args_handle; \
    return list ? add_i64_kind(list, kind, (int64_t)value) : 0; \
}

#define ARGS_ADD_UNSIGNED(name, kind, ctype) \
int32_t UXCAPI_CALL name(void *args_handle, ctype value) { \
    uxc_argument_list *list = (uxc_argument_list *)args_handle; \
    return list ? add_u64_kind(list, kind, (uint64_t)value) : 0; \
}

ARGS_ADD_SIGNED(uxcapi_args_add_i8, UXC_KIND_I8, int32_t)
ARGS_ADD_UNSIGNED(uxcapi_args_add_u8, UXC_KIND_U8, uint32_t)
ARGS_ADD_SIGNED(uxcapi_args_add_i16, UXC_KIND_I16, int32_t)
ARGS_ADD_UNSIGNED(uxcapi_args_add_u16, UXC_KIND_U16, uint32_t)
ARGS_ADD_SIGNED(uxcapi_args_add_i32, UXC_KIND_I32, int32_t)
ARGS_ADD_UNSIGNED(uxcapi_args_add_u32, UXC_KIND_U32, uint32_t)
ARGS_ADD_SIGNED(uxcapi_args_add_i64, UXC_KIND_I64, int64_t)
ARGS_ADD_UNSIGNED(uxcapi_args_add_u64, UXC_KIND_U64, uint64_t)

int32_t UXCAPI_CALL uxcapi_args_add_f32(void *args_handle, double value) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    return list ? add_float_kind(list, UXC_KIND_F32, value) : 0;
}

int32_t UXCAPI_CALL uxcapi_args_add_f64(void *args_handle, double value) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    return list ? add_float_kind(list, UXC_KIND_F64, value) : 0;
}

int32_t UXCAPI_CALL uxcapi_args_add_long_double_from_f64(void *args_handle, double value) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    return list ? add_float_kind(list, UXC_KIND_LONGDOUBLE, value) : 0;
}

int32_t UXCAPI_CALL uxcapi_args_add_ptr(void *args_handle, void *value) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    return list ? add_pointer_kind(list, UXC_KIND_PTR, value, NULL) : 0;
}

int32_t UXCAPI_CALL uxcapi_args_add_string(void *args_handle, const char *value) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    char *copy;
    if (!list) return 0;
    copy = duplicate_string(value);
    if (!copy) return 0;
    return add_pointer_kind(list, UXC_KIND_STRPTR, copy, copy);
}

int32_t UXCAPI_CALL uxcapi_args_add_wstring_utf8(void *args_handle, const char *utf8_value) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    wchar_t *copy;
    if (!list) return 0;
    copy = utf8_to_wide(utf8_value);
    if (!copy) return 0;
    return add_pointer_kind(list, UXC_KIND_WSTRPTR, copy, copy);
}

int32_t UXCAPI_CALL uxcapi_args_add_struct(void *args_handle, void *type_handle, const void *data, uint64_t byte_count) {
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    return list ? add_aggregate_argument(list, (uxc_type_descriptor *)type_handle, data, byte_count) : 0;
}

int32_t UXCAPI_CALL uxcapi_call_append_args(void *call_handle, void *args_handle) {
    uxc_call *call = (uxc_call *)call_handle;
    uxc_argument_list *list = (uxc_argument_list *)args_handle;
    size_t i;
    if (!call || !list) return 0;
    for (i = 0; i < list->count; ++i) {
        if (!copy_argument(&call->arguments, &list->items[i])) return 0;
    }
    return 1;
}

int32_t UXCAPI_CALL uxcapi_call_invoke(void *call_handle) {
    uxc_call *call = (uxc_call *)call_handle;
    ffi_type **types;
    void **values;
    ffi_type *return_type;
    void *result_pointer;
    ffi_cif cif;
    ffi_status status;
    size_t i;
    if (!call || !call->proc) return 0;
    if (call->is_variadic &&
        (call->fixed_argument_count < 0 ||
         (size_t)call->fixed_argument_count > call->arguments.count)) {
        set_call_error(call, "Variadic fixed argument count is invalid");
        return 0;
    }

    return_type = kind_to_ffi_type(call->return_kind);
    if (call->return_kind == UXC_KIND_STRUCT) {
        if (!call->return_aggregate_type || !call->return_aggregate_type->finalized) {
            set_call_error(call, "STRUCT return descriptor is missing or not finalized");
            return 0;
        }
        return_type = &call->return_aggregate_type->ffi;
    }
    if (!return_type) {
        set_call_error(call, "Unsupported return kind");
        return 0;
    }

    types = (ffi_type **)calloc(
        call->arguments.count ? call->arguments.count : 1,
        sizeof(*types)
    );
    values = (void **)calloc(
        call->arguments.count ? call->arguments.count : 1,
        sizeof(*values)
    );
    if (!types || !values) {
        free(types);
        free(values);
        set_call_error(call, "Out of memory preparing libffi call");
        return 0;
    }

    for (i = 0; i < call->arguments.count; ++i) {
        types[i] = argument_ffi_type(&call->arguments.items[i]);
        values[i] = argument_value_address(&call->arguments.items[i]);
        if (!types[i] || !values[i]) {
            free(types);
            free(values);
            set_call_error(call, "Unsupported or invalid argument");
            return 0;
        }
    }

    if (call->is_variadic) {
        status = ffi_prep_cif_var(
            &cif,
            FFI_DEFAULT_ABI,
            (unsigned int)call->fixed_argument_count,
            (unsigned int)call->arguments.count,
            return_type,
            types
        );
    } else {
        status = ffi_prep_cif(
            &cif,
            FFI_DEFAULT_ABI,
            (unsigned int)call->arguments.count,
            return_type,
            types
        );
    }
    if (status != FFI_OK) {
        free(types);
        free(values);
        set_call_error(call, "ffi_prep_cif/ffi_prep_cif_var failed");
        return 0;
    }

    free(call->result_storage);
    call->result_storage = NULL;
    call->result_storage_size = 0;
    memset(&call->result, 0, sizeof(call->result));
    if (call->return_kind == UXC_KIND_STRUCT) {
        call->result_storage_size = call->return_aggregate_type->ffi.size;
        call->result_storage = calloc(call->result_storage_size ? call->result_storage_size : 1, 1);
        if (!call->result_storage) {
            free(types);
            free(values);
            set_call_error(call, "Out of memory allocating STRUCT result");
            return 0;
        }
        result_pointer = call->result_storage;
    } else {
        result_pointer = call->return_kind == UXC_KIND_VOID ? NULL : &call->result;
    }

    ffi_call(&cif, FFI_FN(call->proc), result_pointer, values);
    call->invoked = 1;
    call->error[0] = '\0';
    set_last_error_text("");
    free(types);
    free(values);
    return 1;
}

int32_t UXCAPI_CALL uxcapi_result_i32(void *call_handle) {
    uxc_call *c = (uxc_call *)call_handle;
    if (!c) return 0;
    switch (c->return_kind) {
        case UXC_KIND_I8: return c->result.i8;
        case UXC_KIND_U8: return c->result.u8;
        case UXC_KIND_I16: return c->result.i16;
        case UXC_KIND_U16: return c->result.u16;
        case UXC_KIND_I32: return c->result.i32;
        case UXC_KIND_U32: return (int32_t)c->result.u32;
        default: return (int32_t)c->result.i64;
    }
}

uint32_t UXCAPI_CALL uxcapi_result_u32(void *call_handle) {
    return (uint32_t)uxcapi_result_i32(call_handle);
}

int64_t UXCAPI_CALL uxcapi_result_i64(void *call_handle) {
    uxc_call *c = (uxc_call *)call_handle;
    if (!c) return 0;
    switch (c->return_kind) {
        case UXC_KIND_I8: return c->result.i8;
        case UXC_KIND_U8: return c->result.u8;
        case UXC_KIND_I16: return c->result.i16;
        case UXC_KIND_U16: return c->result.u16;
        case UXC_KIND_I32: return c->result.i32;
        case UXC_KIND_U32: return c->result.u32;
        case UXC_KIND_I64: return c->result.i64;
        case UXC_KIND_U64: return (int64_t)c->result.u64;
        default: return 0;
    }
}

uint64_t UXCAPI_CALL uxcapi_result_u64(void *call_handle) {
    return (uint64_t)uxcapi_result_i64(call_handle);
}

double UXCAPI_CALL uxcapi_result_f64(void *call_handle) {
    uxc_call *c = (uxc_call *)call_handle;
    if (!c) return 0.0;
    if (c->return_kind == UXC_KIND_F32) return (double)c->result.f32;
    if (c->return_kind == UXC_KIND_F64) return c->result.f64;
    if (c->return_kind == UXC_KIND_LONGDOUBLE) return (double)c->result.fld;
    return (double)uxcapi_result_i64(call_handle);
}

void *UXCAPI_CALL uxcapi_result_ptr(void *call_handle) {
    uxc_call *c = (uxc_call *)call_handle;
    return c ? c->result.ptr : NULL;
}

const char *UXCAPI_CALL uxcapi_result_string(void *call_handle) {
    uxc_call *c = (uxc_call *)call_handle;
    return (c && c->result.ptr) ? (const char *)c->result.ptr : "";
}

uint64_t UXCAPI_CALL uxcapi_result_struct_size(void *call_handle) {
    uxc_call *call = (uxc_call *)call_handle;
    if (!call || call->return_kind != UXC_KIND_STRUCT || !call->invoked) return 0;
    return (uint64_t)call->result_storage_size;
}

int32_t UXCAPI_CALL uxcapi_result_struct_copy(void *call_handle, void *target, uint64_t target_capacity) {
    uxc_call *call = (uxc_call *)call_handle;
    if (!call || !target || call->return_kind != UXC_KIND_STRUCT || !call->invoked || !call->result_storage) return 0;
    if (target_capacity < call->result_storage_size) {
        set_last_error_text("STRUCT result target buffer is too small");
        return 0;
    }
    memcpy(target, call->result_storage, call->result_storage_size);
    return 1;
}

const char *UXCAPI_CALL uxcapi_call_error(void *call_handle) {
    uxc_call *c = (uxc_call *)call_handle;
    return c ? c->error : "Invalid call handle";
}

void *UXCAPI_CALL uxcapi_memory_alloc(uint64_t byte_count) {
    void *memory;
    if (byte_count > SIZE_MAX) return NULL;
    memory = malloc(byte_count ? (size_t)byte_count : 1);
    if (!memory) set_last_error_text("Memory allocation failed");
    return memory;
}

void *UXCAPI_CALL uxcapi_memory_calloc(uint64_t item_count, uint64_t item_size) {
    if (item_count > SIZE_MAX || item_size > SIZE_MAX) return NULL;
    if (item_size && item_count > SIZE_MAX / item_size) return NULL;
    return calloc(
        item_count ? (size_t)item_count : 1,
        item_size ? (size_t)item_size : 1
    );
}

void *UXCAPI_CALL uxcapi_memory_realloc(void *memory, uint64_t byte_count) {
    void *result;
    if (byte_count > SIZE_MAX) return NULL;
    result = realloc(memory, byte_count ? (size_t)byte_count : 1);
    if (!result) set_last_error_text("Memory reallocation failed");
    return result;
}

void UXCAPI_CALL uxcapi_memory_free(void *memory) {
    free(memory);
}

int32_t UXCAPI_CALL uxcapi_memory_zero(void *memory, uint64_t byte_count) {
    if (!memory || byte_count > SIZE_MAX) return 0;
    memset(memory, 0, (size_t)byte_count);
    return 1;
}

int32_t UXCAPI_CALL uxcapi_memory_copy(
    void *target,
    const void *source,
    uint64_t byte_count
) {
    if (!target || !source || byte_count > SIZE_MAX) return 0;
    memmove(target, source, (size_t)byte_count);
    return 1;
}

#define MEM_WRITE(name, ctype, cast_type) \
int32_t UXCAPI_CALL name(void *memory, uint64_t offset, cast_type value) { \
    if (!memory || offset > SIZE_MAX - sizeof(ctype)) return 0; \
    *(ctype *)((unsigned char *)memory + (size_t)offset) = (ctype)value; \
    return 1; \
}

MEM_WRITE(uxcapi_memory_write_i8, int8_t, int32_t)
MEM_WRITE(uxcapi_memory_write_u8, uint8_t, uint32_t)
MEM_WRITE(uxcapi_memory_write_i16, int16_t, int32_t)
MEM_WRITE(uxcapi_memory_write_u16, uint16_t, uint32_t)
MEM_WRITE(uxcapi_memory_write_i32, int32_t, int32_t)
MEM_WRITE(uxcapi_memory_write_u32, uint32_t, uint32_t)
MEM_WRITE(uxcapi_memory_write_i64, int64_t, int64_t)
MEM_WRITE(uxcapi_memory_write_u64, uint64_t, uint64_t)

int32_t UXCAPI_CALL uxcapi_memory_write_f32(void *memory, uint64_t offset, double value) {
    if (!memory || offset > SIZE_MAX - sizeof(float)) return 0;
    *(float *)((unsigned char *)memory + (size_t)offset) = (float)value;
    return 1;
}

int32_t UXCAPI_CALL uxcapi_memory_write_f64(void *memory, uint64_t offset, double value) {
    if (!memory || offset > SIZE_MAX - sizeof(double)) return 0;
    *(double *)((unsigned char *)memory + (size_t)offset) = value;
    return 1;
}

int32_t UXCAPI_CALL uxcapi_memory_write_ptr(void *memory, uint64_t offset, void *value) {
    if (!memory || offset > SIZE_MAX - sizeof(void *)) return 0;
    *(void **)((unsigned char *)memory + (size_t)offset) = value;
    return 1;
}

int32_t UXCAPI_CALL uxcapi_memory_write_string(
    void *memory,
    uint64_t offset,
    const char *value,
    uint64_t capacity
) {
    size_t length;
    char *target;
    if (!memory || !value || capacity == 0 || capacity > SIZE_MAX) return 0;
    target = (char *)memory + (size_t)offset;
    length = strlen(value);
    if (length >= (size_t)capacity) length = (size_t)capacity - 1;
    memcpy(target, value, length);
    target[length] = '\0';
    return 1;
}

#define MEM_READ(name, ctype, result_type) \
result_type UXCAPI_CALL name(const void *memory, uint64_t offset) { \
    if (!memory || offset > SIZE_MAX - sizeof(ctype)) return (result_type)0; \
    return (result_type)(*(const ctype *)((const unsigned char *)memory + (size_t)offset)); \
}

MEM_READ(uxcapi_memory_read_i8, int8_t, int32_t)
MEM_READ(uxcapi_memory_read_u8, uint8_t, uint32_t)
MEM_READ(uxcapi_memory_read_i16, int16_t, int32_t)
MEM_READ(uxcapi_memory_read_u16, uint16_t, uint32_t)
MEM_READ(uxcapi_memory_read_i32, int32_t, int32_t)
MEM_READ(uxcapi_memory_read_u32, uint32_t, uint32_t)
MEM_READ(uxcapi_memory_read_i64, int64_t, int64_t)
MEM_READ(uxcapi_memory_read_u64, uint64_t, uint64_t)

double UXCAPI_CALL uxcapi_memory_read_f32(const void *memory, uint64_t offset) {
    if (!memory || offset > SIZE_MAX - sizeof(float)) return 0.0;
    return (double)(*(const float *)((const unsigned char *)memory + (size_t)offset));
}

double UXCAPI_CALL uxcapi_memory_read_f64(const void *memory, uint64_t offset) {
    if (!memory || offset > SIZE_MAX - sizeof(double)) return 0.0;
    return *(const double *)((const unsigned char *)memory + (size_t)offset);
}

void *UXCAPI_CALL uxcapi_memory_read_ptr(const void *memory, uint64_t offset) {
    if (!memory || offset > SIZE_MAX - sizeof(void *)) return NULL;
    return *(void * const *)((const unsigned char *)memory + (size_t)offset);
}

const char *UXCAPI_CALL uxcapi_memory_read_string(const void *memory, uint64_t offset) {
    return memory ? (const char *)memory + (size_t)offset : "";
}

static void free_callback_event(uxc_callback_event *event) {
    int32_t i;
    if (!event) return;
    for (i = 0; i < event->argument_count; ++i) free_argument(&event->arguments[i]);
    free(event->arguments);
    free(event);
}

static void callback_dispatch(
    ffi_cif *cif,
    void *result,
    void **arguments,
    void *user_data
) {
    uxc_callback *callback = (uxc_callback *)user_data;
    uxc_callback_event *event;
    size_t i;
    (void)cif;
    if (!callback) return;

    event = (uxc_callback_event *)calloc(1, sizeof(*event));
    if (event) {
        event->argument_count = (int32_t)callback->argument_count;
        if (callback->argument_count) {
            event->arguments = (uxc_argument *)calloc(
                callback->argument_count,
                sizeof(*event->arguments)
            );
        }
        if (!callback->argument_count || event->arguments) {
            for (i = 0; i < callback->argument_count; ++i) {
                uxc_argument *target = &event->arguments[i];
                target->kind = callback->argument_kinds[i];
                switch (target->kind) {
                    case UXC_KIND_I8: target->value.i8 = *(int8_t *)arguments[i]; break;
                    case UXC_KIND_U8: target->value.u8 = *(uint8_t *)arguments[i]; break;
                    case UXC_KIND_I16: target->value.i16 = *(int16_t *)arguments[i]; break;
                    case UXC_KIND_U16: target->value.u16 = *(uint16_t *)arguments[i]; break;
                    case UXC_KIND_I32: target->value.i32 = *(int32_t *)arguments[i]; break;
                    case UXC_KIND_U32: target->value.u32 = *(uint32_t *)arguments[i]; break;
                    case UXC_KIND_I64: target->value.i64 = *(int64_t *)arguments[i]; break;
                    case UXC_KIND_U64: target->value.u64 = *(uint64_t *)arguments[i]; break;
                    case UXC_KIND_F32: target->value.f32 = *(float *)arguments[i]; break;
                    case UXC_KIND_F64: target->value.f64 = *(double *)arguments[i]; break;
                    case UXC_KIND_LONGDOUBLE: target->value.fld = *(long double *)arguments[i]; break;
                    case UXC_KIND_PTR:
                    case UXC_KIND_WSTRPTR:
                        target->value.ptr = *(void **)arguments[i];
                        break;
                    case UXC_KIND_STRPTR: {
                        const char *source = *(const char **)arguments[i];
                        char *copy = duplicate_string(source);
                        target->owned = copy;
                        target->value.ptr = copy;
                        break;
                    }
                    default:
                        break;
                }
            }
            EnterCriticalSection(&callback->lock);
            if (callback->tail) callback->tail->next = event;
            else callback->head = event;
            callback->tail = event;
            ++callback->pending;
            LeaveCriticalSection(&callback->lock);
            event = NULL;
        }
        free_callback_event(event);
    }

    if (!result) return;
    switch (callback->return_kind) {
        case UXC_KIND_VOID: break;
        case UXC_KIND_I8: *(int8_t *)result = callback->default_value.i8; break;
        case UXC_KIND_U8: *(uint8_t *)result = callback->default_value.u8; break;
        case UXC_KIND_I16: *(int16_t *)result = callback->default_value.i16; break;
        case UXC_KIND_U16: *(uint16_t *)result = callback->default_value.u16; break;
        case UXC_KIND_I32: *(int32_t *)result = callback->default_value.i32; break;
        case UXC_KIND_U32: *(uint32_t *)result = callback->default_value.u32; break;
        case UXC_KIND_I64: *(int64_t *)result = callback->default_value.i64; break;
        case UXC_KIND_U64: *(uint64_t *)result = callback->default_value.u64; break;
        case UXC_KIND_F32: *(float *)result = callback->default_value.f32; break;
        case UXC_KIND_F64: *(double *)result = callback->default_value.f64; break;
        case UXC_KIND_LONGDOUBLE: *(long double *)result = callback->default_value.fld; break;
        case UXC_KIND_PTR:
        case UXC_KIND_STRPTR:
        case UXC_KIND_WSTRPTR:
            *(void **)result = callback->default_value.ptr;
            break;
        default:
            break;
    }
}

void *UXCAPI_CALL uxcapi_callback_new(
    int32_t return_kind,
    uint64_t default_u64,
    double default_f64
) {
    uxc_callback *callback;
    if (!kind_to_ffi_type(return_kind)) {
        set_last_error_text("Invalid callback return kind");
        return NULL;
    }
    callback = (uxc_callback *)calloc(1, sizeof(*callback));
    if (!callback) return NULL;
    callback->return_kind = return_kind;
    switch (return_kind) {
        case UXC_KIND_F32: callback->default_value.f32 = (float)default_f64; break;
        case UXC_KIND_F64: callback->default_value.f64 = default_f64; break;
        case UXC_KIND_LONGDOUBLE: callback->default_value.fld = (long double)default_f64; break;
        case UXC_KIND_PTR:
        case UXC_KIND_STRPTR:
        case UXC_KIND_WSTRPTR:
            callback->default_value.ptr = (void *)(uintptr_t)default_u64;
            break;
        case UXC_KIND_I8: callback->default_value.i8 = (int8_t)default_u64; break;
        case UXC_KIND_U8: callback->default_value.u8 = (uint8_t)default_u64; break;
        case UXC_KIND_I16: callback->default_value.i16 = (int16_t)default_u64; break;
        case UXC_KIND_U16: callback->default_value.u16 = (uint16_t)default_u64; break;
        case UXC_KIND_I32: callback->default_value.i32 = (int32_t)default_u64; break;
        case UXC_KIND_U32: callback->default_value.u32 = (uint32_t)default_u64; break;
        case UXC_KIND_I64: callback->default_value.i64 = (int64_t)default_u64; break;
        case UXC_KIND_U64: callback->default_value.u64 = default_u64; break;
        case UXC_KIND_VOID: break;
        default: break;
    }
    InitializeCriticalSection(&callback->lock);
    callback->lock_initialized = 1;
    return callback;
}

int32_t UXCAPI_CALL uxcapi_callback_add_arg(
    void *callback_handle,
    int32_t argument_kind
) {
    uxc_callback *callback = (uxc_callback *)callback_handle;
    int32_t *next;
    size_t next_capacity;
    if (!callback || callback->closure) return 0;
    if (!kind_to_ffi_type(argument_kind) || argument_kind == UXC_KIND_VOID) return 0;
    if (callback->argument_count == callback->argument_capacity) {
        next_capacity = callback->argument_capacity ? callback->argument_capacity * 2 : 8;
        next = (int32_t *)realloc(
            callback->argument_kinds,
            next_capacity * sizeof(*next)
        );
        if (!next) return 0;
        callback->argument_kinds = next;
        callback->argument_capacity = next_capacity;
    }
    callback->argument_kinds[callback->argument_count++] = argument_kind;
    return 1;
}

int32_t UXCAPI_CALL uxcapi_callback_build(void *callback_handle) {
    uxc_callback *callback = (uxc_callback *)callback_handle;
    ffi_type **types;
    size_t i;
    ffi_status status;
    if (!callback) return 0;
    if (callback->closure) return 1;

    types = (ffi_type **)calloc(
        callback->argument_count ? callback->argument_count : 1,
        sizeof(*types)
    );
    if (!types) return 0;
    for (i = 0; i < callback->argument_count; ++i) {
        types[i] = kind_to_ffi_type(callback->argument_kinds[i]);
    }
    status = ffi_prep_cif(
        &callback->cif,
        FFI_DEFAULT_ABI,
        (unsigned int)callback->argument_count,
        kind_to_ffi_type(callback->return_kind),
        types
    );
    free(types);
    if (status != FFI_OK) {
        set_last_error_text("ffi_prep_cif failed for callback");
        return 0;
    }

    callback->closure = (ffi_closure *)ffi_closure_alloc(
        sizeof(ffi_closure),
        &callback->code_pointer
    );
    if (!callback->closure) {
        set_last_error_text("ffi_closure_alloc failed");
        return 0;
    }
    status = ffi_prep_closure_loc(
        callback->closure,
        &callback->cif,
        callback_dispatch,
        callback,
        callback->code_pointer
    );
    if (status != FFI_OK) {
        ffi_closure_free(callback->closure);
        callback->closure = NULL;
        callback->code_pointer = NULL;
        set_last_error_text("ffi_prep_closure_loc failed");
        return 0;
    }
    return 1;
}

void *UXCAPI_CALL uxcapi_callback_pointer(void *callback_handle) {
    uxc_callback *callback = (uxc_callback *)callback_handle;
    return callback ? callback->code_pointer : NULL;
}

void UXCAPI_CALL uxcapi_callback_free(void *callback_handle) {
    uxc_callback *callback = (uxc_callback *)callback_handle;
    uxc_callback_event *event;
    if (!callback) return;
    if (callback->lock_initialized) EnterCriticalSection(&callback->lock);
    event = callback->head;
    callback->head = callback->tail = NULL;
    callback->pending = 0;
    if (callback->lock_initialized) LeaveCriticalSection(&callback->lock);
    while (event) {
        uxc_callback_event *next = event->next;
        free_callback_event(event);
        event = next;
    }
    if (callback->closure) ffi_closure_free(callback->closure);
    free(callback->argument_kinds);
    if (callback->lock_initialized) DeleteCriticalSection(&callback->lock);
    free(callback);
}

uint64_t UXCAPI_CALL uxcapi_callback_pending(void *callback_handle) {
    uxc_callback *callback = (uxc_callback *)callback_handle;
    uint64_t value;
    if (!callback) return 0;
    EnterCriticalSection(&callback->lock);
    value = callback->pending;
    LeaveCriticalSection(&callback->lock);
    return value;
}

void *UXCAPI_CALL uxcapi_callback_next(void *callback_handle) {
    uxc_callback *callback = (uxc_callback *)callback_handle;
    uxc_callback_event *event;
    if (!callback) return NULL;
    EnterCriticalSection(&callback->lock);
    event = callback->head;
    if (event) {
        callback->head = event->next;
        if (!callback->head) callback->tail = NULL;
        event->next = NULL;
        if (callback->pending) --callback->pending;
    }
    LeaveCriticalSection(&callback->lock);
    return event;
}

void UXCAPI_CALL uxcapi_event_free(void *event_handle) {
    free_callback_event((uxc_callback_event *)event_handle);
}

int32_t UXCAPI_CALL uxcapi_event_arg_count(void *event_handle) {
    uxc_callback_event *event = (uxc_callback_event *)event_handle;
    return event ? event->argument_count : 0;
}

static uxc_argument *event_argument(void *event_handle, int32_t index0) {
    uxc_callback_event *event = (uxc_callback_event *)event_handle;
    if (!event || index0 < 0 || index0 >= event->argument_count) return NULL;
    return &event->arguments[index0];
}

int32_t UXCAPI_CALL uxcapi_event_arg_kind(void *event_handle, int32_t index0) {
    uxc_argument *argument = event_argument(event_handle, index0);
    return argument ? argument->kind : UXC_KIND_VOID;
}

uint64_t UXCAPI_CALL uxcapi_event_arg_u64(void *event_handle, int32_t index0) {
    uxc_argument *argument = event_argument(event_handle, index0);
    if (!argument) return 0;
    switch (argument->kind) {
        case UXC_KIND_I8: return (uint64_t)(int64_t)argument->value.i8;
        case UXC_KIND_U8: return argument->value.u8;
        case UXC_KIND_I16: return (uint64_t)(int64_t)argument->value.i16;
        case UXC_KIND_U16: return argument->value.u16;
        case UXC_KIND_I32: return (uint64_t)(int64_t)argument->value.i32;
        case UXC_KIND_U32: return argument->value.u32;
        case UXC_KIND_I64: return (uint64_t)argument->value.i64;
        case UXC_KIND_U64: return argument->value.u64;
        case UXC_KIND_PTR:
        case UXC_KIND_STRPTR:
        case UXC_KIND_WSTRPTR:
            return (uint64_t)(uintptr_t)argument->value.ptr;
        default:
            return 0;
    }
}

double UXCAPI_CALL uxcapi_event_arg_f64(void *event_handle, int32_t index0) {
    uxc_argument *argument = event_argument(event_handle, index0);
    if (!argument) return 0.0;
    if (argument->kind == UXC_KIND_F32) return argument->value.f32;
    if (argument->kind == UXC_KIND_F64) return argument->value.f64;
    if (argument->kind == UXC_KIND_LONGDOUBLE) return (double)argument->value.fld;
    return (double)(int64_t)uxcapi_event_arg_u64(event_handle, index0);
}

const char *UXCAPI_CALL uxcapi_event_arg_string(void *event_handle, int32_t index0) {
    uxc_argument *argument = event_argument(event_handle, index0);
    if (!argument || argument->kind != UXC_KIND_STRPTR || !argument->value.ptr) {
        return "";
    }
    return (const char *)argument->value.ptr;
}
