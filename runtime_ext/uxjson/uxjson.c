#include "../cbase_common/uxb_cbase.h"
#include "yyjson.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct {
    yyjson_doc *doc;
    char *last_text;
} uxjson_doc_handle;

static UXB_THREAD_LOCAL char g_error[1024];

static void set_error(const char *msg) {
    snprintf(g_error, sizeof(g_error), "%s", msg ? msg : "");
}

UXB_EXPORT const char *UXB_CALL uxjson_version(void) {
    return YYJSON_VERSION_STRING;
}

UXB_EXPORT uxb_handle UXB_CALL uxjson_parse(const char *text) {
    yyjson_read_err err;
    uxjson_doc_handle *h;
    if (!text) {
        set_error("json text is null");
        return 0;
    }
    h = (uxjson_doc_handle *)calloc(1, sizeof(*h));
    if (!h) {
        set_error("out of memory");
        return 0;
    }
    h->doc = yyjson_read_opts(
        (char *)text, strlen(text), YYJSON_READ_NOFLAG, NULL, &err
    );
    if (!h->doc) {
        snprintf(
            g_error, sizeof(g_error), "%s at byte %llu",
            err.msg ? err.msg : "json parse error",
            (unsigned long long)err.pos
        );
        free(h);
        return 0;
    }
    set_error("");
    return (uxb_handle)(uintptr_t)h;
}

UXB_EXPORT void UXB_CALL uxjson_free(uxb_handle document) {
    uxjson_doc_handle *h = (uxjson_doc_handle *)(uintptr_t)document;
    if (!h) return;
    free(h->last_text);
    if (h->doc) yyjson_doc_free(h->doc);
    free(h);
}

UXB_EXPORT uxb_handle UXB_CALL uxjson_root(uxb_handle document) {
    uxjson_doc_handle *h = (uxjson_doc_handle *)(uintptr_t)document;
    return (h && h->doc)
        ? (uxb_handle)(uintptr_t)yyjson_doc_get_root(h->doc)
        : 0;
}

UXB_EXPORT uxb_handle UXB_CALL uxjson_pointer_get(
    uxb_handle document, const char *pointer
) {
    uxjson_doc_handle *h = (uxjson_doc_handle *)(uintptr_t)document;
    yyjson_val *v;
    if (!h || !h->doc || !pointer) return 0;
    v = yyjson_doc_ptr_get(h->doc, pointer);
    return (uxb_handle)(uintptr_t)v;
}

UXB_EXPORT uxb_handle UXB_CALL uxjson_object_get(
    uxb_handle value, const char *key
) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    yyjson_val *r;
    if (!v || !key || !yyjson_is_obj(v)) return 0;
    r = yyjson_obj_get(v, key);
    return (uxb_handle)(uintptr_t)r;
}

UXB_EXPORT uxb_handle UXB_CALL uxjson_array_get(
    uxb_handle value, uint64_t index0
) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    yyjson_val *r;
    if (!v || !yyjson_is_arr(v)) return 0;
    r = yyjson_arr_get(v, (size_t)index0);
    return (uxb_handle)(uintptr_t)r;
}

UXB_EXPORT uint64_t UXB_CALL uxjson_array_size(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    return (v && yyjson_is_arr(v)) ? (uint64_t)yyjson_arr_size(v) : 0;
}

UXB_EXPORT int32_t UXB_CALL uxjson_type(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    return v ? (int32_t)yyjson_get_type(v) : 0;
}

UXB_EXPORT const char *UXB_CALL uxjson_get_string(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    return (v && yyjson_is_str(v)) ? yyjson_get_str(v) : "";
}

UXB_EXPORT int64_t UXB_CALL uxjson_get_i64(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    if (!v || !yyjson_is_num(v)) return 0;
    if (yyjson_is_sint(v)) return (int64_t)yyjson_get_sint(v);
    if (yyjson_is_uint(v)) return (int64_t)yyjson_get_uint(v);
    return (int64_t)yyjson_get_real(v);
}

UXB_EXPORT uint64_t UXB_CALL uxjson_get_u64(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    if (!v || !yyjson_is_num(v)) return 0;
    if (yyjson_is_uint(v)) return (uint64_t)yyjson_get_uint(v);
    if (yyjson_is_sint(v)) {
        int64_t x = (int64_t)yyjson_get_sint(v);
        return x >= 0 ? (uint64_t)x : 0;
    }
    {
        double x = yyjson_get_real(v);
        return x >= 0.0 ? (uint64_t)x : 0;
    }
}

UXB_EXPORT double UXB_CALL uxjson_get_f64(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    return (v && yyjson_is_num(v)) ? yyjson_get_num(v) : 0.0;
}

UXB_EXPORT int32_t UXB_CALL uxjson_get_bool(uxb_handle value) {
    yyjson_val *v = (yyjson_val *)(uintptr_t)value;
    return (v && yyjson_is_bool(v) && yyjson_get_bool(v)) ? 1 : 0;
}

UXB_EXPORT const char *UXB_CALL uxjson_write(
    uxb_handle document, int32_t pretty
) {
    uxjson_doc_handle *h = (uxjson_doc_handle *)(uintptr_t)document;
    yyjson_write_flag flags = pretty
        ? YYJSON_WRITE_PRETTY_TWO_SPACES
        : YYJSON_WRITE_NOFLAG;
    yyjson_write_err err;
    if (!h || !h->doc) return "";
    free(h->last_text);
    h->last_text = yyjson_write_opts(h->doc, flags, NULL, NULL, &err);
    if (!h->last_text) {
        set_error(err.msg ? err.msg : "json write error");
        return "";
    }
    return h->last_text;
}

UXB_EXPORT const char *UXB_CALL uxjson_error(void) {
    return g_error;
}
