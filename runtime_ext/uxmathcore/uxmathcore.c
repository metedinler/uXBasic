#include "uxmathcore.h"
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <float.h>

#ifndef UXMC_OK
#define UXMC_OK 1
#define UXMC_FAIL 0
#endif

typedef struct UxMathBuffer {
    int elem_type;
    int elem_size;
    int count;
    int capacity;
    unsigned char* data;
} UxMathBuffer;

static UxMathBuffer* as_buf(void* h) { return (UxMathBuffer*)h; }

UXMATHCORE_API int uxmathcore_version(void) { return 1100; }

UXMATHCORE_API int uxmathcore_type_size(int elem_type) {
    switch (elem_type) {
    case UXMC_TYPE_I8: return 1;
    case UXMC_TYPE_U8: return 1;
    case UXMC_TYPE_I16: return 2;
    case UXMC_TYPE_U16: return 2;
    case UXMC_TYPE_I32: return 4;
    case UXMC_TYPE_U32: return 4;
    case UXMC_TYPE_I64: return 8;
    case UXMC_TYPE_U64: return 8;
    case UXMC_TYPE_F32: return 4;
    case UXMC_TYPE_F64: return 8;
    default: return 0;
    }
}

UXMATHCORE_API const char* uxmathcore_type_name(int elem_type) {
    switch (elem_type) {
    case UXMC_TYPE_I8: return "I8";
    case UXMC_TYPE_U8: return "U8";
    case UXMC_TYPE_I16: return "I16";
    case UXMC_TYPE_U16: return "U16";
    case UXMC_TYPE_I32: return "I32";
    case UXMC_TYPE_U32: return "U32";
    case UXMC_TYPE_I64: return "I64";
    case UXMC_TYPE_U64: return "U64";
    case UXMC_TYPE_F32: return "F32";
    case UXMC_TYPE_F64: return "F64";
    default: return "UNKNOWN";
    }
}

static int valid_type(int elem_type) { return uxmathcore_type_size(elem_type) > 0; }

static int ensure_capacity(UxMathBuffer* b, int need) {
    if (!b || need < 0) return UXMC_FAIL;
    if (need <= b->capacity) return UXMC_OK;
    int nc = b->capacity > 0 ? b->capacity : 8;
    while (nc < need) {
        if (nc > 1073741823 / 2) return UXMC_FAIL;
        nc *= 2;
    }
    size_t bytes = (size_t)nc * (size_t)b->elem_size;
    unsigned char* nd = (unsigned char*)realloc(b->data, bytes);
    if (!nd) return UXMC_FAIL;
    if (nc > b->capacity) {
        size_t old_bytes = (size_t)b->capacity * (size_t)b->elem_size;
        memset(nd + old_bytes, 0, bytes - old_bytes);
    }
    b->data = nd;
    b->capacity = nc;
    return UXMC_OK;
}

UXMATHCORE_API void* uxmathcore_buffer_create_capacity(int elem_type, int count, int capacity) {
    if (!valid_type(elem_type)) return NULL;
    if (count < 0) count = 0;
    if (capacity < count) capacity = count;
    if (capacity < 1) capacity = 1;
    UxMathBuffer* b = (UxMathBuffer*)calloc(1, sizeof(UxMathBuffer));
    if (!b) return NULL;
    b->elem_type = elem_type;
    b->elem_size = uxmathcore_type_size(elem_type);
    b->count = count;
    b->capacity = capacity;
    b->data = (unsigned char*)calloc((size_t)capacity, (size_t)b->elem_size);
    if (!b->data) { free(b); return NULL; }
    return b;
}

UXMATHCORE_API void* uxmathcore_buffer_create(int elem_type, int count) {
    return uxmathcore_buffer_create_capacity(elem_type, count, count > 0 ? count : 8);
}

UXMATHCORE_API void uxmathcore_buffer_free(void* h) {
    UxMathBuffer* b = as_buf(h);
    if (!b) return;
    free(b->data);
    free(b);
}

UXMATHCORE_API int uxmathcore_buffer_type(void* h) { UxMathBuffer* b = as_buf(h); return b ? b->elem_type : 0; }
UXMATHCORE_API int uxmathcore_buffer_count(void* h) { UxMathBuffer* b = as_buf(h); return b ? b->count : 0; }
UXMATHCORE_API int uxmathcore_buffer_capacity(void* h) { UxMathBuffer* b = as_buf(h); return b ? b->capacity : 0; }
UXMATHCORE_API int uxmathcore_buffer_elem_size(void* h) { UxMathBuffer* b = as_buf(h); return b ? b->elem_size : 0; }
UXMATHCORE_API long long uxmathcore_buffer_byte_size(void* h) { UxMathBuffer* b = as_buf(h); return b ? (long long)b->count * b->elem_size : 0; }
UXMATHCORE_API void* uxmathcore_buffer_data_ptr(void* h) { UxMathBuffer* b = as_buf(h); return b ? b->data : NULL; }

UXMATHCORE_API int uxmathcore_buffer_clear(void* h) {
    UxMathBuffer* b = as_buf(h);
    if (!b) return UXMC_FAIL;
    b->count = 0;
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_resize(void* h, int count) {
    UxMathBuffer* b = as_buf(h);
    if (!b || count < 0) return UXMC_FAIL;
    int old = b->count;
    if (!ensure_capacity(b, count)) return UXMC_FAIL;
    if (count > old) memset(b->data + (size_t)old * b->elem_size, 0, (size_t)(count - old) * b->elem_size);
    b->count = count;
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_reserve(void* h, int capacity) {
    UxMathBuffer* b = as_buf(h);
    if (!b || capacity < 0) return UXMC_FAIL;
    return ensure_capacity(b, capacity);
}

UXMATHCORE_API int uxmathcore_buffer_fill_zero(void* h) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !b->data) return UXMC_FAIL;
    memset(b->data, 0, (size_t)b->count * b->elem_size);
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_clone(void* src, void** out_handle) {
    UxMathBuffer* s = as_buf(src);
    if (!s || !out_handle) return UXMC_FAIL;
    UxMathBuffer* d = (UxMathBuffer*)uxmathcore_buffer_create_capacity(s->elem_type, s->count, s->capacity);
    if (!d) return UXMC_FAIL;
    memcpy(d->data, s->data, (size_t)s->count * s->elem_size);
    *out_handle = d;
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_copy(void* src, void* dst) {
    UxMathBuffer* s = as_buf(src);
    UxMathBuffer* d = as_buf(dst);
    if (!s || !d || s->elem_type != d->elem_type) return UXMC_FAIL;
    if (!uxmathcore_buffer_resize(d, s->count)) return UXMC_FAIL;
    memcpy(d->data, s->data, (size_t)s->count * s->elem_size);
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_slice(void* src, int start, int count, void** out_handle) {
    UxMathBuffer* s = as_buf(src);
    if (!s || !out_handle || start < 0 || count < 0 || start + count > s->count) return UXMC_FAIL;
    UxMathBuffer* d = (UxMathBuffer*)uxmathcore_buffer_create(s->elem_type, count);
    if (!d) return UXMC_FAIL;
    memcpy(d->data, s->data + (size_t)start * s->elem_size, (size_t)count * s->elem_size);
    *out_handle = d;
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_append(void* dst, void* src) {
    UxMathBuffer* d = as_buf(dst);
    UxMathBuffer* s = as_buf(src);
    if (!d || !s || d->elem_type != s->elem_type) return UXMC_FAIL;
    int old = d->count;
    if (!uxmathcore_buffer_resize(d, old + s->count)) return UXMC_FAIL;
    memcpy(d->data + (size_t)old * d->elem_size, s->data, (size_t)s->count * s->elem_size);
    return UXMC_OK;
}

static double get_as_f64_raw(UxMathBuffer* b, int i) {
    unsigned char* p = b->data + (size_t)i * b->elem_size;
    switch (b->elem_type) {
    case UXMC_TYPE_I8: return (double)*(int8_t*)p;
    case UXMC_TYPE_U8: return (double)*(uint8_t*)p;
    case UXMC_TYPE_I16: return (double)*(int16_t*)p;
    case UXMC_TYPE_U16: return (double)*(uint16_t*)p;
    case UXMC_TYPE_I32: return (double)*(int32_t*)p;
    case UXMC_TYPE_U32: return (double)*(uint32_t*)p;
    case UXMC_TYPE_I64: return (double)*(int64_t*)p;
    case UXMC_TYPE_U64: return (double)*(uint64_t*)p;
    case UXMC_TYPE_F32: return (double)*(float*)p;
    case UXMC_TYPE_F64: return *(double*)p;
    default: return NAN;
    }
}

static long long get_as_i64_raw(UxMathBuffer* b, int i) { return (long long)get_as_f64_raw(b, i); }
static unsigned long long get_as_u64_raw(UxMathBuffer* b, int i) { return (unsigned long long)get_as_f64_raw(b, i); }

static int set_from_f64_raw(UxMathBuffer* b, int i, double v) {
    unsigned char* p = b->data + (size_t)i * b->elem_size;
    switch (b->elem_type) {
    case UXMC_TYPE_I8: *(int8_t*)p = (int8_t)v; break;
    case UXMC_TYPE_U8: *(uint8_t*)p = (uint8_t)v; break;
    case UXMC_TYPE_I16: *(int16_t*)p = (int16_t)v; break;
    case UXMC_TYPE_U16: *(uint16_t*)p = (uint16_t)v; break;
    case UXMC_TYPE_I32: *(int32_t*)p = (int32_t)v; break;
    case UXMC_TYPE_U32: *(uint32_t*)p = (uint32_t)v; break;
    case UXMC_TYPE_I64: *(int64_t*)p = (int64_t)v; break;
    case UXMC_TYPE_U64: *(uint64_t*)p = (uint64_t)v; break;
    case UXMC_TYPE_F32: *(float*)p = (float)v; break;
    case UXMC_TYPE_F64: *(double*)p = v; break;
    default: return UXMC_FAIL;
    }
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_get_f64(void* h, int index, double* out_value) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !out_value || index < 0 || index >= b->count) return UXMC_FAIL;
    *out_value = get_as_f64_raw(b, index);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_buffer_set_f64(void* h, int index, double value) {
    UxMathBuffer* b = as_buf(h);
    if (!b || index < 0) return UXMC_FAIL;
    if (!uxmathcore_buffer_resize(b, index + 1)) return UXMC_FAIL;
    return set_from_f64_raw(b, index, value);
}
UXMATHCORE_API int uxmathcore_buffer_push_f64(void* h, double value) {
    UxMathBuffer* b = as_buf(h);
    if (!b) return UXMC_FAIL;
    int idx = b->count;
    if (!uxmathcore_buffer_resize(b, idx + 1)) return UXMC_FAIL;
    return set_from_f64_raw(b, idx, value);
}
UXMATHCORE_API int uxmathcore_buffer_fill_f64(void* h, double value) {
    UxMathBuffer* b = as_buf(h);
    if (!b) return UXMC_FAIL;
    for (int i = 0; i < b->count; ++i) if (!set_from_f64_raw(b, i, value)) return UXMC_FAIL;
    return UXMC_OK;
}

UXMATHCORE_API int uxmathcore_buffer_get_i64(void* h, int index, long long* out_value) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !out_value || index < 0 || index >= b->count) return UXMC_FAIL;
    *out_value = get_as_i64_raw(b, index);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_buffer_set_i64(void* h, int index, long long value) { return uxmathcore_buffer_set_f64(h, index, (double)value); }
UXMATHCORE_API int uxmathcore_buffer_push_i64(void* h, long long value) { return uxmathcore_buffer_push_f64(h, (double)value); }
UXMATHCORE_API int uxmathcore_buffer_fill_i64(void* h, long long value) { return uxmathcore_buffer_fill_f64(h, (double)value); }

UXMATHCORE_API int uxmathcore_buffer_get_u64(void* h, int index, unsigned long long* out_value) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !out_value || index < 0 || index >= b->count) return UXMC_FAIL;
    *out_value = get_as_u64_raw(b, index);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_buffer_set_u64(void* h, int index, unsigned long long value) { return uxmathcore_buffer_set_f64(h, index, (double)value); }
UXMATHCORE_API int uxmathcore_buffer_push_u64(void* h, unsigned long long value) { return uxmathcore_buffer_push_f64(h, (double)value); }
UXMATHCORE_API int uxmathcore_buffer_fill_u64(void* h, unsigned long long value) { return uxmathcore_buffer_fill_f64(h, (double)value); }

UXMATHCORE_API int uxmathcore_buffer_get_byte(void* h, int index, unsigned char* out_value) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !out_value || index < 0 || index >= b->count) return UXMC_FAIL;
    *out_value = (unsigned char)get_as_u64_raw(b, index);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_buffer_set_byte(void* h, int index, unsigned char value) { return uxmathcore_buffer_set_u64(h, index, (unsigned long long)value); }
UXMATHCORE_API int uxmathcore_buffer_push_byte(void* h, unsigned char value) { return uxmathcore_buffer_push_u64(h, (unsigned long long)value); }

UXMATHCORE_API int uxmathcore_buffer_copy_from_ptr(void* h, const void* src, int elem_count) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !src || elem_count < 0) return UXMC_FAIL;
    if (!uxmathcore_buffer_resize(b, elem_count)) return UXMC_FAIL;
    memcpy(b->data, src, (size_t)elem_count * b->elem_size);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_buffer_copy_to_ptr(void* h, void* dst, int elem_count) {
    UxMathBuffer* b = as_buf(h);
    if (!b || !dst || elem_count < 0 || elem_count > b->count) return UXMC_FAIL;
    memcpy(dst, b->data, (size_t)elem_count * b->elem_size);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_buffer_cast(void* src, int dst_type, void** out_handle) {
    UxMathBuffer* s = as_buf(src);
    if (!s || !out_handle || !valid_type(dst_type)) return UXMC_FAIL;
    UxMathBuffer* d = (UxMathBuffer*)uxmathcore_buffer_create(dst_type, s->count);
    if (!d) return UXMC_FAIL;
    for (int i = 0; i < s->count; ++i) set_from_f64_raw(d, i, get_as_f64_raw(s, i));
    *out_handle = d;
    return UXMC_OK;
}

static int same_count(UxMathBuffer* a, UxMathBuffer* b, UxMathBuffer* out) {
    return a && b && out && a->count == b->count && uxmathcore_buffer_resize(out, a->count);
}
UXMATHCORE_API int uxmathcore_vec_add_f64(void* a_, void* b_, void* out_) {
    UxMathBuffer* a=as_buf(a_), *b=as_buf(b_), *out=as_buf(out_);
    if (!same_count(a,b,out)) return UXMC_FAIL;
    for (int i=0;i<a->count;++i) set_from_f64_raw(out,i,get_as_f64_raw(a,i)+get_as_f64_raw(b,i));
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_sub_f64(void* a_, void* b_, void* out_) {
    UxMathBuffer* a=as_buf(a_), *b=as_buf(b_), *out=as_buf(out_);
    if (!same_count(a,b,out)) return UXMC_FAIL;
    for (int i=0;i<a->count;++i) set_from_f64_raw(out,i,get_as_f64_raw(a,i)-get_as_f64_raw(b,i));
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_mul_f64(void* a_, void* b_, void* out_) {
    UxMathBuffer* a=as_buf(a_), *b=as_buf(b_), *out=as_buf(out_);
    if (!same_count(a,b,out)) return UXMC_FAIL;
    for (int i=0;i<a->count;++i) set_from_f64_raw(out,i,get_as_f64_raw(a,i)*get_as_f64_raw(b,i));
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_div_f64(void* a_, void* b_, void* out_) {
    UxMathBuffer* a=as_buf(a_), *b=as_buf(b_), *out=as_buf(out_);
    if (!same_count(a,b,out)) return UXMC_FAIL;
    for (int i=0;i<a->count;++i) {
        double den=get_as_f64_raw(b,i);
        set_from_f64_raw(out,i, den==0.0 ? NAN : get_as_f64_raw(a,i)/den);
    }
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_scale_f64(void* a_, double scalar, void* out_) {
    UxMathBuffer* a=as_buf(a_), *out=as_buf(out_);
    if (!a || !out || !uxmathcore_buffer_resize(out,a->count)) return UXMC_FAIL;
    for (int i=0;i<a->count;++i) set_from_f64_raw(out,i,get_as_f64_raw(a,i)*scalar);
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_axpy_f64(double alpha, void* x_, void* y_, void* out_) {
    UxMathBuffer* x=as_buf(x_), *y=as_buf(y_), *out=as_buf(out_);
    if (!same_count(x,y,out)) return UXMC_FAIL;
    for (int i=0;i<x->count;++i) set_from_f64_raw(out,i,alpha*get_as_f64_raw(x,i)+get_as_f64_raw(y,i));
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_dot_f64(void* a_, void* b_, double* out_value) {
    UxMathBuffer* a=as_buf(a_), *b=as_buf(b_);
    if (!a || !b || !out_value || a->count != b->count) return UXMC_FAIL;
    double s=0.0;
    for (int i=0;i<a->count;++i) s += get_as_f64_raw(a,i)*get_as_f64_raw(b,i);
    *out_value=s;
    return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_l1_norm_f64(void* a_, double* out_value) {
    UxMathBuffer* a=as_buf(a_);
    if (!a || !out_value) return UXMC_FAIL;
    double s=0.0; for (int i=0;i<a->count;++i) s += fabs(get_as_f64_raw(a,i));
    *out_value=s; return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_l2_norm_f64(void* a_, double* out_value) {
    UxMathBuffer* a=as_buf(a_);
    if (!a || !out_value) return UXMC_FAIL;
    double s=0.0; for (int i=0;i<a->count;++i) { double v=get_as_f64_raw(a,i); s += v*v; }
    *out_value=sqrt(s); return UXMC_OK;
}
UXMATHCORE_API int uxmathcore_vec_normalize_l2_f64(void* a_, void* out_) {
    UxMathBuffer* a=as_buf(a_), *out=as_buf(out_);
    if (!a || !out) return UXMC_FAIL;
    double norm=0.0; if (!uxmathcore_vec_l2_norm_f64(a_, &norm)) return UXMC_FAIL;
    if (norm == 0.0 || isnan(norm)) return UXMC_FAIL;
    return uxmathcore_vec_scale_f64(a_, 1.0/norm, out_);
}
UXMATHCORE_API int uxmathcore_vec_minmax_f64(void* a_, double* out_min, double* out_max) {
    UxMathBuffer* a=as_buf(a_);
    if (!a || !out_min || !out_max || a->count <= 0) return UXMC_FAIL;
    double mn=get_as_f64_raw(a,0), mx=mn;
    for (int i=1;i<a->count;++i) { double v=get_as_f64_raw(a,i); if (v<mn) mn=v; if (v>mx) mx=v; }
    *out_min=mn; *out_max=mx; return UXMC_OK;
}

/* Compatibility layer: old uxmath vector API now maps to F64 buffers only. */
UXMATHCORE_API int uxmath_version(void) { return uxmathcore_version(); }
UXMATHCORE_API void* uxmath_vec_create(int capacity) { return uxmathcore_buffer_create_capacity(UXMC_TYPE_F64, 0, capacity); }
UXMATHCORE_API void uxmath_vec_free(void* h) { uxmathcore_buffer_free(h); }
UXMATHCORE_API int uxmath_vec_push(void* h, double v) { return uxmathcore_buffer_push_f64(h, v); }
UXMATHCORE_API int uxmath_vec_set(void* h, int idx, double v) { return uxmathcore_buffer_set_f64(h, idx, v); }
UXMATHCORE_API double uxmath_vec_get(void* h, int idx) { double v=NAN; uxmathcore_buffer_get_f64(h,idx,&v); return v; }
UXMATHCORE_API int uxmath_vec_count(void* h) { return uxmathcore_buffer_count(h); }
UXMATHCORE_API int uxmath_vec_clear(void* h) { return uxmathcore_buffer_clear(h); }
UXMATHCORE_API double* uxmath_vec_data_ptr(void* h) { return (double*)uxmathcore_buffer_data_ptr(h); }

UXMATHCORE_API void* uxmathcore_buffer_clone_handle(void* src) {
    void* out = NULL;
    if (!uxmathcore_buffer_clone(src, &out)) return NULL;
    return out;
}
UXMATHCORE_API void* uxmathcore_buffer_slice_handle(void* src, int start, int count) {
    void* out = NULL;
    if (!uxmathcore_buffer_slice(src, start, count, &out)) return NULL;
    return out;
}
UXMATHCORE_API void* uxmathcore_buffer_cast_handle(void* src, int dst_type) {
    void* out = NULL;
    if (!uxmathcore_buffer_cast(src, dst_type, &out)) return NULL;
    return out;
}
UXMATHCORE_API double uxmathcore_vec_dot_f64_value(void* a, void* b) {
    double out = NAN;
    uxmathcore_vec_dot_f64(a, b, &out);
    return out;
}
UXMATHCORE_API double uxmathcore_vec_l1_norm_f64_value(void* a) {
    double out = NAN;
    uxmathcore_vec_l1_norm_f64(a, &out);
    return out;
}
UXMATHCORE_API double uxmathcore_vec_l2_norm_f64_value(void* a) {
    double out = NAN;
    uxmathcore_vec_l2_norm_f64(a, &out);
    return out;
}
UXMATHCORE_API double uxmathcore_vec_min_f64_value(void* a) {
    double mn = NAN, mx = NAN;
    uxmathcore_vec_minmax_f64(a, &mn, &mx);
    return mn;
}
UXMATHCORE_API double uxmathcore_vec_max_f64_value(void* a) {
    double mn = NAN, mx = NAN;
    uxmathcore_vec_minmax_f64(a, &mn, &mx);
    return mx;
}
