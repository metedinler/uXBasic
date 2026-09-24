#include "uxonnx.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#ifdef _WIN32
#include <windows.h>
#endif
#ifndef _MSC_VER
/* ONNX Runtime declares empty SAL annotations for non-MSVC compilers. */
#undef _Check_return_
#undef _In_reads_
#undef _In_reads_opt_
#undef _Inout_updates_
#undef _Out_writes_
#undef _Out_writes_opt_
#undef _Inout_updates_all_
#undef _Out_writes_bytes_all_
#undef _Out_writes_all_
#undef _Success_
#undef _Outptr_result_buffer_maybenull_
#endif
#include "onnxruntime_c_api.h"

#ifndef UXONNX_MAX_RANK
#define UXONNX_MAX_RANK 8
#endif

typedef struct UxOnnxTensor {
    int64_t rank;
    int64_t shape[UXONNX_MAX_RANK];
    int64_t count;
    float *data;
} UxOnnxTensor;

typedef struct UxOnnxSession {
    OrtEnv *env;
    OrtSessionOptions *opts;
    OrtSession *session;
    OrtAllocator *allocator;
    char last_error[1024];
    char scratch_name[512];
} UxOnnxSession;

static const OrtApi *g_ort = NULL;
static void *g_ort_dll = NULL;
static char g_last_error[1024] = "";

static void ux_set_global_error(const char *msg) {
    if (!msg) msg = "";
    snprintf(g_last_error, sizeof(g_last_error), "%s", msg);
}

static void ux_set_session_error(UxOnnxSession *s, const char *msg) {
    if (!msg) msg = "";
    if (s) snprintf(s->last_error, sizeof(s->last_error), "%s", msg);
    ux_set_global_error(msg);
}

static int ux_check_status(UxOnnxSession *s, OrtStatus *st, const char *where) {
    if (!st) return 1;
    const char *msg = g_ort ? g_ort->GetErrorMessage(st) : "ONNX Runtime status error";
    char buf[1024];
    snprintf(buf, sizeof(buf), "%s: %s", where ? where : "ORT", msg ? msg : "<no message>");
    ux_set_session_error(s, buf);
    if (g_ort) g_ort->ReleaseStatus(st);
    return 0;
}

static char* ux_strdup(const char *s) {
    if (!s) return NULL;
    size_t n = strlen(s) + 1;
    char *p = (char*)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}

#ifdef _WIN32
static wchar_t* ux_utf8_to_wide(const char *s) {
    if (!s) return NULL;
    int n = MultiByteToWideChar(CP_UTF8, 0, s, -1, NULL, 0);
    if (n <= 0) return NULL;
    wchar_t *w = (wchar_t*)calloc((size_t)n, sizeof(wchar_t));
    if (!w) return NULL;
    MultiByteToWideChar(CP_UTF8, 0, s, -1, w, n);
    return w;
}
#endif

static int64_t ux_count_from_shape(const int64_t *shape, int64_t rank) {
    if (!shape || rank <= 0 || rank > UXONNX_MAX_RANK) return 0;
    int64_t c = 1;
    for (int64_t i = 0; i < rank; ++i) {
        if (shape[i] <= 0) return 0;
        if (c > INT64_MAX / shape[i]) return 0;
        c *= shape[i];
    }
    return c;
}

UXONNX_API int uxonnx_global_init(const char *runtime_dir) {
    if (g_ort) return 1;
#ifdef _WIN32
    char dll_path[1024];
    HMODULE h = NULL;
    if (runtime_dir && runtime_dir[0]) {
        snprintf(dll_path, sizeof(dll_path), "%s\\onnxruntime.dll", runtime_dir);
        h = LoadLibraryA(dll_path);
    }
    if (!h) h = LoadLibraryA("onnxruntime.dll");
    if (!h) h = LoadLibraryA("uxb\\dist\\runtime_ext\\deps\\uxonnx\\onnxruntime.dll");
    if (!h) {
        ux_set_global_error("onnxruntime.dll could not be loaded. Run fetch_uxonnx_deps.bat and copy runtime deps.");
        return 0;
    }
    typedef const OrtApiBase* (ORT_API_CALL *OrtGetApiBaseFn)(void);
    OrtGetApiBaseFn get_base = (OrtGetApiBaseFn)GetProcAddress(h, "OrtGetApiBase");
    if (!get_base) {
        ux_set_global_error("OrtGetApiBase not found in onnxruntime.dll");
        FreeLibrary(h);
        return 0;
    }
    const OrtApiBase *base = get_base();
    g_ort = base->GetApi(ORT_API_VERSION);
    g_ort_dll = (void*)h;
#else
    ux_set_global_error("uxonnx dynamic loader currently implemented for Windows only");
    return 0;
#endif
    if (!g_ort) {
        ux_set_global_error("OrtApi pointer is NULL");
        return 0;
    }
    ux_set_global_error("");
    return 1;
}

UXONNX_API const char* uxonnx_runtime_version(void) {
    if (!g_ort && !uxonnx_global_init(NULL)) return g_last_error;
    const OrtApiBase *base = OrtGetApiBase();
    return base ? base->GetVersionString() : "<unknown>";
}

UXONNX_API const char* uxonnx_last_error(void *session_handle) {
    UxOnnxSession *s = (UxOnnxSession*)session_handle;
    if (s && s->last_error[0]) return s->last_error;
    return g_last_error;
}

UXONNX_API void* uxonnx_session_create(const char *model_path, int intra_threads) {
    if (!g_ort && !uxonnx_global_init(NULL)) return NULL;
    if (!model_path || !model_path[0]) { ux_set_global_error("model_path is empty"); return NULL; }
    UxOnnxSession *s = (UxOnnxSession*)calloc(1, sizeof(UxOnnxSession));
    if (!s) { ux_set_global_error("out of memory"); return NULL; }
    OrtStatus *st = NULL;
    st = g_ort->CreateEnv(ORT_LOGGING_LEVEL_WARNING, "uxonnx", &s->env);
    if (!ux_check_status(s, st, "CreateEnv")) { uxonnx_session_free(s); return NULL; }
    st = g_ort->CreateSessionOptions(&s->opts);
    if (!ux_check_status(s, st, "CreateSessionOptions")) { uxonnx_session_free(s); return NULL; }
    if (intra_threads > 0) {
        st = g_ort->SetIntraOpNumThreads(s->opts, intra_threads);
        if (!ux_check_status(s, st, "SetIntraOpNumThreads")) { uxonnx_session_free(s); return NULL; }
    }
    st = g_ort->SetSessionGraphOptimizationLevel(s->opts, ORT_ENABLE_EXTENDED);
    if (!ux_check_status(s, st, "SetSessionGraphOptimizationLevel")) { uxonnx_session_free(s); return NULL; }
#ifdef _WIN32
    wchar_t *wpath = ux_utf8_to_wide(model_path);
    if (!wpath) { ux_set_session_error(s, "UTF-8 to wide path conversion failed"); uxonnx_session_free(s); return NULL; }
    st = g_ort->CreateSession(s->env, wpath, s->opts, &s->session);
    free(wpath);
#else
    st = g_ort->CreateSession(s->env, model_path, s->opts, &s->session);
#endif
    if (!ux_check_status(s, st, "CreateSession")) { uxonnx_session_free(s); return NULL; }
    st = g_ort->GetAllocatorWithDefaultOptions(&s->allocator);
    if (!ux_check_status(s, st, "GetAllocatorWithDefaultOptions")) { uxonnx_session_free(s); return NULL; }
    ux_set_session_error(s, "");
    return s;
}

UXONNX_API void uxonnx_session_free(void *session_handle) {
    UxOnnxSession *s = (UxOnnxSession*)session_handle;
    if (!s) return;
    if (g_ort) {
        if (s->session) g_ort->ReleaseSession(s->session);
        if (s->opts) g_ort->ReleaseSessionOptions(s->opts);
        if (s->env) g_ort->ReleaseEnv(s->env);
    }
    free(s);
}

UXONNX_API long long uxonnx_input_count(void *session_handle) {
    UxOnnxSession *s = (UxOnnxSession*)session_handle;
    if (!s || !s->session || !g_ort) return -1;
    size_t n = 0;
    OrtStatus *st = g_ort->SessionGetInputCount(s->session, &n);
    if (!ux_check_status(s, st, "SessionGetInputCount")) return -1;
    return (long long)n;
}

UXONNX_API long long uxonnx_output_count(void *session_handle) {
    UxOnnxSession *s = (UxOnnxSession*)session_handle;
    if (!s || !s->session || !g_ort) return -1;
    size_t n = 0;
    OrtStatus *st = g_ort->SessionGetOutputCount(s->session, &n);
    if (!ux_check_status(s, st, "SessionGetOutputCount")) return -1;
    return (long long)n;
}

static const char* ux_get_io_name(UxOnnxSession *s, long long index, int is_output) {
    if (!s || !s->session || !s->allocator || !g_ort || index < 0) return "";
    char *name = NULL;
    OrtStatus *st = NULL;
    if (is_output) st = g_ort->SessionGetOutputName(s->session, (size_t)index, s->allocator, &name);
    else st = g_ort->SessionGetInputName(s->session, (size_t)index, s->allocator, &name);
    if (!ux_check_status(s, st, is_output ? "SessionGetOutputName" : "SessionGetInputName")) return "";
    snprintf(s->scratch_name, sizeof(s->scratch_name), "%s", name ? name : "");
    if (name) s->allocator->Free(s->allocator, name);
    return s->scratch_name;
}

UXONNX_API const char* uxonnx_input_name(void *session_handle, long long index) {
    return ux_get_io_name((UxOnnxSession*)session_handle, index, 0);
}
UXONNX_API const char* uxonnx_output_name(void *session_handle, long long index) {
    return ux_get_io_name((UxOnnxSession*)session_handle, index, 1);
}

UXONNX_API void* uxonnx_tensor_create_f32(const long long *shape_, long long rank) {
    if (!shape_ || rank <= 0 || rank > UXONNX_MAX_RANK) return NULL;
    int64_t shape[UXONNX_MAX_RANK];
    for (int64_t i = 0; i < rank; ++i) shape[i] = (int64_t)shape_[i];
    int64_t count = ux_count_from_shape(shape, rank);
    if (count <= 0) return NULL;
    UxOnnxTensor *t = (UxOnnxTensor*)calloc(1, sizeof(UxOnnxTensor));
    if (!t) return NULL;
    t->rank = rank;
    t->count = count;
    for (int64_t i = 0; i < rank; ++i) t->shape[i] = shape[i];
    t->data = (float*)calloc((size_t)count, sizeof(float));
    if (!t->data) { free(t); return NULL; }
    return t;
}
UXONNX_API void* uxonnx_tensor_create_1d_f32(long long n) { long long s[1]={n}; return uxonnx_tensor_create_f32(s,1); }
UXONNX_API void* uxonnx_tensor_create_2d_f32(long long r,long long c){ long long s[2]={r,c}; return uxonnx_tensor_create_f32(s,2); }
UXONNX_API void* uxonnx_tensor_create_3d_f32(long long a,long long b,long long c){ long long s[3]={a,b,c}; return uxonnx_tensor_create_f32(s,3); }
UXONNX_API void* uxonnx_tensor_create_4d_f32(long long a,long long b,long long c,long long d){ long long s[4]={a,b,c,d}; return uxonnx_tensor_create_f32(s,4); }

UXONNX_API void uxonnx_tensor_free(void *tensor_handle) {
    UxOnnxTensor *t = (UxOnnxTensor*)tensor_handle;
    if (!t) return;
    free(t->data);
    free(t);
}
UXONNX_API long long uxonnx_tensor_count(void *tensor_handle){ UxOnnxTensor*t=(UxOnnxTensor*)tensor_handle; return t?t->count:-1; }
UXONNX_API long long uxonnx_tensor_rank(void *tensor_handle){ UxOnnxTensor*t=(UxOnnxTensor*)tensor_handle; return t?t->rank:-1; }
UXONNX_API long long uxonnx_tensor_dim(void *tensor_handle,long long axis){ UxOnnxTensor*t=(UxOnnxTensor*)tensor_handle; if(!t||axis<0||axis>=t->rank)return -1; return t->shape[axis]; }
UXONNX_API float* uxonnx_tensor_data_ptr(void *tensor_handle){ UxOnnxTensor*t=(UxOnnxTensor*)tensor_handle; return t?t->data:NULL; }
UXONNX_API void uxonnx_tensor_set_f32(void *tensor_handle,long long index,double value){ UxOnnxTensor*t=(UxOnnxTensor*)tensor_handle; if(!t||index<0||index>=t->count)return; t->data[index]=(float)value; }
UXONNX_API double uxonnx_tensor_get_f32(void *tensor_handle,long long index){ UxOnnxTensor*t=(UxOnnxTensor*)tensor_handle; if(!t||index<0||index>=t->count)return 0.0; return (double)t->data[index]; }

UXONNX_API void* uxonnx_run1_f32(void *session_handle, const char *input_name, void *input_tensor_handle, const char *output_name) {
    UxOnnxSession *s = (UxOnnxSession*)session_handle;
    UxOnnxTensor *in = (UxOnnxTensor*)input_tensor_handle;
    if (!s || !s->session || !g_ort || !in || !input_name || !output_name) return NULL;

    OrtMemoryInfo *mem = NULL;
    OrtValue *input_value = NULL;
    OrtValue *output_value = NULL;
    OrtStatus *st = NULL;
    st = g_ort->CreateCpuMemoryInfo(OrtArenaAllocator, OrtMemTypeDefault, &mem);
    if (!ux_check_status(s, st, "CreateCpuMemoryInfo")) return NULL;

    st = g_ort->CreateTensorWithDataAsOrtValue(mem, in->data, (size_t)(in->count * sizeof(float)), in->shape, (size_t)in->rank, ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT, &input_value);
    if (!ux_check_status(s, st, "CreateTensorWithDataAsOrtValue")) { g_ort->ReleaseMemoryInfo(mem); return NULL; }

    const char *input_names[1] = { input_name };
    const char *output_names[1] = { output_name };
    st = g_ort->Run(s->session, NULL, input_names, (const OrtValue* const*)&input_value, 1, output_names, 1, &output_value);
    g_ort->ReleaseValue(input_value);
    g_ort->ReleaseMemoryInfo(mem);
    if (!ux_check_status(s, st, "Run")) return NULL;

    OrtTensorTypeAndShapeInfo *info = NULL;
    st = g_ort->GetTensorTypeAndShape(output_value, &info);
    if (!ux_check_status(s, st, "GetTensorTypeAndShape")) { g_ort->ReleaseValue(output_value); return NULL; }
    size_t rank = 0;
    st = g_ort->GetDimensionsCount(info, &rank);
    if (!ux_check_status(s, st, "GetDimensionsCount")) { g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }
    if (rank <= 0 || rank > UXONNX_MAX_RANK) { ux_set_session_error(s,"unsupported output rank"); g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }
    int64_t dims[UXONNX_MAX_RANK];
    st = g_ort->GetDimensions(info, dims, rank);
    if (!ux_check_status(s, st, "GetDimensions")) { g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }
    int64_t count = ux_count_from_shape(dims, (int64_t)rank);
    if (count <= 0) { ux_set_session_error(s,"bad output shape"); g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }

    float *out_data = NULL;
    st = g_ort->GetTensorMutableData(output_value, (void**)&out_data);
    if (!ux_check_status(s, st, "GetTensorMutableData")) { g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }

    UxOnnxTensor *out = (UxOnnxTensor*)calloc(1, sizeof(UxOnnxTensor));
    if (!out) { ux_set_session_error(s,"out of memory"); g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }
    out->rank = (int64_t)rank;
    out->count = count;
    for (size_t i=0;i<rank;i++) out->shape[i]=dims[i];
    out->data = (float*)malloc((size_t)count * sizeof(float));
    if (!out->data) { free(out); ux_set_session_error(s,"out of memory"); g_ort->ReleaseTensorTypeAndShapeInfo(info); g_ort->ReleaseValue(output_value); return NULL; }
    memcpy(out->data, out_data, (size_t)count * sizeof(float));
    g_ort->ReleaseTensorTypeAndShapeInfo(info);
    g_ort->ReleaseValue(output_value);
    ux_set_session_error(s, "");
    return out;
}
