#include "uxonnx2.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#ifdef _WIN32
#include <windows.h>
#endif
#include "onnxruntime_c_api.h"

#ifndef UXONNX2_MAX_RANK
#define UXONNX2_MAX_RANK 8
#endif
#ifndef UXONNX2_MAX_IO
#define UXONNX2_MAX_IO 32
#endif
#define UXONNX2_MAGIC_TENSOR 0x32584E54u
#define UXONNX2_MAGIC_SESSION 0x32584E53u
#define UXONNX2_MAGIC_RUN 0x32584E52u
#define UXONNX2_MAGIC_RESULT 0x32584E4Fu

typedef struct UxTensor {
    uint32_t magic;
    int dtype;
    int64_t rank;
    int64_t shape[UXONNX2_MAX_RANK];
    int64_t count;
    void *data;
    char **strings;
} UxTensor;

typedef struct UxSession {
    uint32_t magic;
    OrtEnv *env;
    OrtSessionOptions *opts;
    OrtSession *session;
    OrtAllocator *allocator;
    int provider;
    char scratch[1024];
} UxSession;

typedef struct UxRun {
    uint32_t magic;
    UxSession *session;
    size_t input_count;
    char *input_names[UXONNX2_MAX_IO];
    UxTensor *input_tensors[UXONNX2_MAX_IO];
    size_t output_count;
    char *output_names[UXONNX2_MAX_IO];
} UxRun;

typedef struct UxResult {
    uint32_t magic;
    size_t count;
    UxTensor *tensors[UXONNX2_MAX_IO];
} UxResult;

static const OrtApi *g_ort = NULL;
static void *g_dll = NULL;
static char g_error[2048] = "";

static void set_error(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(g_error, sizeof(g_error), fmt ? fmt : "", ap);
    va_end(ap);
}

static char *dupstr(const char *s) {
    if (!s) s = "";
    size_t n = strlen(s) + 1;
    char *p = (char*)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}

#ifdef _WIN32
static wchar_t* utf8_to_wide(const char *s) {
    if (!s) return NULL;
    int n = MultiByteToWideChar(CP_UTF8, 0, s, -1, NULL, 0);
    if (n <= 0) return NULL;
    wchar_t *w = (wchar_t*)calloc((size_t)n, sizeof(wchar_t));
    if (!w) return NULL;
    MultiByteToWideChar(CP_UTF8, 0, s, -1, w, n);
    return w;
}
#endif

static int check_status(OrtStatus *st, const char *where) {
    if (!st) return 1;
    const char *msg = g_ort ? g_ort->GetErrorMessage(st) : "ORT status error";
    set_error("%s: %s", where ? where : "ORT", msg ? msg : "<no message>");
    if (g_ort) g_ort->ReleaseStatus(st);
    return 0;
}

static int64_t dtype_bytes(int dtype) {
    switch(dtype) {
        case UXONNX2_DTYPE_F32: return 4;
        case UXONNX2_DTYPE_F64: return 8;
        case UXONNX2_DTYPE_I64: return 8;
        case UXONNX2_DTYPE_I32: return 4;
        case UXONNX2_DTYPE_STRING: return (int64_t)sizeof(char*);
        default: return 0;
    }
}

static ONNXTensorElementDataType ort_dtype(int dtype) {
    switch(dtype) {
        case UXONNX2_DTYPE_F32: return ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT;
        case UXONNX2_DTYPE_F64: return ONNX_TENSOR_ELEMENT_DATA_TYPE_DOUBLE;
        case UXONNX2_DTYPE_I64: return ONNX_TENSOR_ELEMENT_DATA_TYPE_INT64;
        case UXONNX2_DTYPE_I32: return ONNX_TENSOR_ELEMENT_DATA_TYPE_INT32;
        case UXONNX2_DTYPE_STRING: return ONNX_TENSOR_ELEMENT_DATA_TYPE_STRING;
        default: return ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED;
    }
}

static int ux_dtype(ONNXTensorElementDataType t) {
    switch(t) {
        case ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT: return UXONNX2_DTYPE_F32;
        case ONNX_TENSOR_ELEMENT_DATA_TYPE_DOUBLE: return UXONNX2_DTYPE_F64;
        case ONNX_TENSOR_ELEMENT_DATA_TYPE_INT64: return UXONNX2_DTYPE_I64;
        case ONNX_TENSOR_ELEMENT_DATA_TYPE_INT32: return UXONNX2_DTYPE_I32;
        case ONNX_TENSOR_ELEMENT_DATA_TYPE_STRING: return UXONNX2_DTYPE_STRING;
        default: return 0;
    }
}

static int64_t shape_count(const int64_t *shape, int64_t rank) {
    if (!shape || rank <= 0 || rank > UXONNX2_MAX_RANK) return 0;
    int64_t c = 1;
    for (int64_t i=0;i<rank;i++) {
        if (shape[i] <= 0) return 0;
        if (c > INT64_MAX / shape[i]) return 0;
        c *= shape[i];
    }
    return c;
}

static UxTensor *as_tensor(void *h) {
    UxTensor *t = (UxTensor*)h;
    if (!t || t->magic != UXONNX2_MAGIC_TENSOR) return NULL;
    return t;
}
static UxSession *as_session(void *h) {
    UxSession *s = (UxSession*)h;
    if (!s || s->magic != UXONNX2_MAGIC_SESSION) return NULL;
    return s;
}
static UxRun *as_run(void *h) {
    UxRun *r = (UxRun*)h;
    if (!r || r->magic != UXONNX2_MAGIC_RUN) return NULL;
    return r;
}
static UxResult *as_result(void *h) {
    UxResult *r = (UxResult*)h;
    if (!r || r->magic != UXONNX2_MAGIC_RESULT) return NULL;
    return r;
}

UXONNX2_API const char* uxonnx2_last_error(void) { return g_error; }

UXONNX2_API int uxonnx2_init(const char *runtime_dir) {
    if (g_ort) return 1;
#ifdef _WIN32
    char path[1024];
    HMODULE h = NULL;
    if (runtime_dir && runtime_dir[0]) {
        snprintf(path, sizeof(path), "%s\\onnxruntime.dll", runtime_dir);
        h = LoadLibraryA(path);
    }
    if (!h) h = LoadLibraryA("onnxruntime.dll");
    if (!h) h = LoadLibraryA("uxb\\dist\\runtime_ext\\deps\\uxonnx2\\onnxruntime.dll");
    if (!h) { set_error("onnxruntime.dll could not be loaded"); return 0; }
    typedef const OrtApiBase* (ORT_API_CALL *OrtGetApiBaseFn)(void);
    OrtGetApiBaseFn get_base = (OrtGetApiBaseFn)GetProcAddress(h, "OrtGetApiBase");
    if (!get_base) { set_error("OrtGetApiBase not found"); FreeLibrary(h); return 0; }
    const OrtApiBase *base = get_base();
    if (!base) { set_error("OrtApiBase is NULL"); FreeLibrary(h); return 0; }
    g_ort = base->GetApi(ORT_API_VERSION);
    if (!g_ort) { set_error("OrtApi is NULL for ORT_API_VERSION"); FreeLibrary(h); return 0; }
    g_dll = (void*)h;
#else
    set_error("uxonnx2 dynamic loader currently supports Windows only");
    return 0;
#endif
    set_error("");
    return 1;
}

UXONNX2_API const char* uxonnx2_version(void) {
    if (!g_ort && !uxonnx2_init(NULL)) return g_error;
#ifdef _WIN32
    typedef const OrtApiBase* (ORT_API_CALL *OrtGetApiBaseFn)(void);
    OrtGetApiBaseFn get_base = (OrtGetApiBaseFn)GetProcAddress((HMODULE)g_dll, "OrtGetApiBase");
    if (!get_base) return "<unknown>";
    return get_base()->GetVersionString();
#else
    return "<unknown>";
#endif
}

UXONNX2_API int uxonnx2_provider_available(int provider) {
    if (!g_ort && !uxonnx2_init(NULL)) return 0;
#ifdef _WIN32
    if (provider == UXONNX2_PROVIDER_CPU) return 1;
    if (provider == UXONNX2_PROVIDER_DIRECTML) return GetProcAddress((HMODULE)g_dll, "OrtSessionOptionsAppendExecutionProvider_DML") != NULL;
    if (provider == UXONNX2_PROVIDER_CUDA) return GetProcAddress((HMODULE)g_dll, "OrtSessionOptionsAppendExecutionProvider_CUDA") != NULL;
#endif
    return 0;
}

static int apply_provider(OrtSessionOptions *opts, int provider) {
#ifdef _WIN32
    if (!opts || !g_dll) return 0;
    if (provider == UXONNX2_PROVIDER_CPU) return 1;
    if (provider == UXONNX2_PROVIDER_AUTO) {
        if (apply_provider(opts, UXONNX2_PROVIDER_DIRECTML)) return 1;
        if (apply_provider(opts, UXONNX2_PROVIDER_CUDA)) return 1;
        return 1;
    }
    if (provider == UXONNX2_PROVIDER_DIRECTML) {
        typedef OrtStatus* (ORT_API_CALL *DmlFn)(OrtSessionOptions*, int);
        DmlFn fn = (DmlFn)GetProcAddress((HMODULE)g_dll, "OrtSessionOptionsAppendExecutionProvider_DML");
        if (!fn) { set_error("DirectML provider symbol not available; CPU fallback recommended"); return 0; }
        return check_status(fn(opts, 0), "AppendExecutionProvider_DML");
    }
    if (provider == UXONNX2_PROVIDER_CUDA) {
        typedef OrtStatus* (ORT_API_CALL *CudaFn)(OrtSessionOptions*, int);
        CudaFn fn = (CudaFn)GetProcAddress((HMODULE)g_dll, "OrtSessionOptionsAppendExecutionProvider_CUDA");
        if (!fn) { set_error("CUDA provider symbol not available; CPU fallback recommended"); return 0; }
        return check_status(fn(opts, 0), "AppendExecutionProvider_CUDA");
    }
#endif
    return 1;
}

static GraphOptimizationLevel graph_level(int graph_opt) {
    switch(graph_opt) {
        case 0: return ORT_DISABLE_ALL;
        case 1: return ORT_ENABLE_BASIC;
        case 2: return ORT_ENABLE_EXTENDED;
        case 99: return ORT_ENABLE_ALL;
        default: return ORT_ENABLE_EXTENDED;
    }
}

UXONNX2_API void* uxonnx2_session_create(const char *model_path) {
    return uxonnx2_session_create_advanced(model_path, UXONNX2_PROVIDER_CPU, 0, 0, 2);
}

UXONNX2_API void* uxonnx2_session_create_advanced(const char *model_path, int provider, int intra_threads, int inter_threads, int graph_opt) {
    if (!g_ort && !uxonnx2_init(NULL)) return NULL;
    if (!model_path || !model_path[0]) { set_error("model path is empty"); return NULL; }
    UxSession *s = (UxSession*)calloc(1, sizeof(UxSession));
    if (!s) { set_error("out of memory"); return NULL; }
    s->magic = UXONNX2_MAGIC_SESSION;
    s->provider = provider;
    OrtStatus *st = NULL;
    st = g_ort->CreateEnv(ORT_LOGGING_LEVEL_WARNING, "uxonnx2", &s->env);
    if (!check_status(st, "CreateEnv")) { uxonnx2_session_free(s); return NULL; }
    st = g_ort->CreateSessionOptions(&s->opts);
    if (!check_status(st, "CreateSessionOptions")) { uxonnx2_session_free(s); return NULL; }
    if (intra_threads > 0 && !check_status(g_ort->SetIntraOpNumThreads(s->opts, intra_threads), "SetIntraOpNumThreads")) { uxonnx2_session_free(s); return NULL; }
    if (inter_threads > 0 && !check_status(g_ort->SetInterOpNumThreads(s->opts, inter_threads), "SetInterOpNumThreads")) { uxonnx2_session_free(s); return NULL; }
    if (!check_status(g_ort->SetSessionGraphOptimizationLevel(s->opts, graph_level(graph_opt)), "SetSessionGraphOptimizationLevel")) { uxonnx2_session_free(s); return NULL; }
    if (!apply_provider(s->opts, provider)) {
        if (provider != UXONNX2_PROVIDER_AUTO) { uxonnx2_session_free(s); return NULL; }
    }
#ifdef _WIN32
    wchar_t *wpath = utf8_to_wide(model_path);
    if (!wpath) { set_error("UTF8 to wide conversion failed"); uxonnx2_session_free(s); return NULL; }
    st = g_ort->CreateSession(s->env, wpath, s->opts, &s->session);
    free(wpath);
#else
    st = g_ort->CreateSession(s->env, model_path, s->opts, &s->session);
#endif
    if (!check_status(st, "CreateSession")) { uxonnx2_session_free(s); return NULL; }
    st = g_ort->GetAllocatorWithDefaultOptions(&s->allocator);
    if (!check_status(st, "GetAllocatorWithDefaultOptions")) { uxonnx2_session_free(s); return NULL; }
    return s;
}

UXONNX2_API void uxonnx2_session_free(void *session) {
    UxSession *s = as_session(session);
    if (!s) return;
    if (g_ort) {
        if (s->session) g_ort->ReleaseSession(s->session);
        if (s->opts) g_ort->ReleaseSessionOptions(s->opts);
        if (s->env) g_ort->ReleaseEnv(s->env);
    }
    s->magic = 0;
    free(s);
}

static long long get_count(UxSession *s, int output) {
    if (!s || !g_ort) return -1;
    size_t n=0;
    OrtStatus *st = output ? g_ort->SessionGetOutputCount(s->session,&n) : g_ort->SessionGetInputCount(s->session,&n);
    return check_status(st, output ? "SessionGetOutputCount" : "SessionGetInputCount") ? (long long)n : -1;
}
UXONNX2_API long long uxonnx2_session_input_count(void *session){return get_count(as_session(session),0);} 
UXONNX2_API long long uxonnx2_session_output_count(void *session){return get_count(as_session(session),1);} 

static const char *get_name(UxSession *s, long long idx, int output) {
    if (!s || !s->allocator || idx < 0) return "";
    char *name=NULL;
    OrtStatus *st = output ? g_ort->SessionGetOutputName(s->session,(size_t)idx,s->allocator,&name) : g_ort->SessionGetInputName(s->session,(size_t)idx,s->allocator,&name);
    if (!check_status(st, output ? "SessionGetOutputName" : "SessionGetInputName")) return "";
    snprintf(s->scratch, sizeof(s->scratch), "%s", name?name:"");
    if (name) s->allocator->Free(s->allocator, name);
    return s->scratch;
}
UXONNX2_API const char* uxonnx2_session_input_name(void *session,long long idx){return get_name(as_session(session),idx,0);} 
UXONNX2_API const char* uxonnx2_session_output_name(void *session,long long idx){return get_name(as_session(session),idx,1);} 

static long long get_io_shape_dtype(UxSession *s, long long idx, int output, int want, long long axis) {
    if (!s || idx < 0) return 0;
    OrtTypeInfo *ti=NULL;
    OrtStatus *st = output ? g_ort->SessionGetOutputTypeInfo(s->session,(size_t)idx,&ti) : g_ort->SessionGetInputTypeInfo(s->session,(size_t)idx,&ti);
    if (!check_status(st, output ? "SessionGetOutputTypeInfo" : "SessionGetInputTypeInfo")) return 0;
    const OrtTensorTypeAndShapeInfo *tsi=NULL;
    st = g_ort->CastTypeInfoToTensorInfo(ti, &tsi);
    if (!check_status(st, "CastTypeInfoToTensorInfo") || !tsi) { if(ti) g_ort->ReleaseTypeInfo(ti); return 0; }
    if (want==1) {
        ONNXTensorElementDataType et=ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED;
        st = g_ort->GetTensorElementType(tsi,&et);
        g_ort->ReleaseTypeInfo(ti);
        return check_status(st,"GetTensorElementType") ? ux_dtype(et) : 0;
    }
    size_t rank=0;
    st = g_ort->GetDimensionsCount(tsi, &rank);
    if (!check_status(st,"GetDimensionsCount")) { g_ort->ReleaseTypeInfo(ti); return 0; }
    if (want==2) { g_ort->ReleaseTypeInfo(ti); return (int)rank; }
    int64_t dims[UXONNX2_MAX_RANK]={0};
    if (rank>UXONNX2_MAX_RANK) rank=UXONNX2_MAX_RANK;
    st = g_ort->GetDimensions(tsi,dims,rank);
    g_ort->ReleaseTypeInfo(ti);
    if (!check_status(st,"GetDimensions")) return 0;
    if (axis<0 || (size_t)axis>=rank) return 0;
    return (int)dims[axis];
}
UXONNX2_API int uxonnx2_session_input_dtype(void *s,long long i){return get_io_shape_dtype(as_session(s),i,0,1,0);} 
UXONNX2_API int uxonnx2_session_output_dtype(void *s,long long i){return get_io_shape_dtype(as_session(s),i,1,1,0);} 
UXONNX2_API long long uxonnx2_session_input_rank(void *s,long long i){return get_io_shape_dtype(as_session(s),i,0,2,0);} 
UXONNX2_API long long uxonnx2_session_output_rank(void *s,long long i){return get_io_shape_dtype(as_session(s),i,1,2,0);} 
UXONNX2_API long long uxonnx2_session_input_dim(void *s,long long i,long long a){return get_io_shape_dtype(as_session(s),i,0,3,a);} 
UXONNX2_API long long uxonnx2_session_output_dim(void *s,long long i,long long a){return get_io_shape_dtype(as_session(s),i,1,3,a);} 

UXONNX2_API void* uxonnx2_tensor_create(const long long *shape_, long long rank, int dtype) {
    if (!shape_ || rank<=0 || rank>UXONNX2_MAX_RANK) return NULL;
    int64_t shape[UXONNX2_MAX_RANK];
    for (int64_t i=0;i<rank;i++) shape[i]=(int64_t)shape_[i];
    int64_t count=shape_count(shape,rank);
    if (count<=0) return NULL;
    UxTensor *t=(UxTensor*)calloc(1,sizeof(UxTensor));
    if (!t) return NULL;
    t->magic=UXONNX2_MAGIC_TENSOR; t->dtype=dtype; t->rank=rank; t->count=count;
    for (int64_t i=0;i<rank;i++) t->shape[i]=shape[i];
    if (dtype==UXONNX2_DTYPE_STRING) {
        t->strings=(char**)calloc((size_t)count,sizeof(char*));
        if (!t->strings) { free(t); return NULL; }
    } else {
        int64_t b=dtype_bytes(dtype);
        if (b<=0) { free(t); return NULL; }
        t->data=calloc((size_t)count,(size_t)b);
        if (!t->data) { free(t); return NULL; }
    }
    return t;
}
UXONNX2_API void* uxonnx2_tensor_create_1d(int dtype,long long n){long long s[1]={n};return uxonnx2_tensor_create(s,1,dtype);} 
UXONNX2_API void* uxonnx2_tensor_create_2d(int dtype,long long r,long long c){long long s[2]={r,c};return uxonnx2_tensor_create(s,2,dtype);} 
UXONNX2_API void* uxonnx2_tensor_create_3d(int dtype,long long a,long long b,long long c){long long s[3]={a,b,c};return uxonnx2_tensor_create(s,3,dtype);} 
UXONNX2_API void* uxonnx2_tensor_create_4d(int dtype,long long a,long long b,long long c,long long d){long long s[4]={a,b,c,d};return uxonnx2_tensor_create(s,4,dtype);} 

UXONNX2_API void uxonnx2_tensor_free(void *tensor) {
    UxTensor *t=as_tensor(tensor); if(!t) return;
    if (t->strings) { for(int64_t i=0;i<t->count;i++) free(t->strings[i]); free(t->strings); }
    free(t->data); t->magic=0; free(t);
}
UXONNX2_API int uxonnx2_tensor_dtype(void *t){UxTensor*x=as_tensor(t);return x?x->dtype:0;} 
UXONNX2_API long long uxonnx2_tensor_rank(void *t){UxTensor*x=as_tensor(t);return x?x->rank:0;} 
UXONNX2_API long long uxonnx2_tensor_dim(void *t,long long a){UxTensor*x=as_tensor(t);return (x&&a>=0&&a<x->rank)?x->shape[a]:0;} 
UXONNX2_API long long uxonnx2_tensor_count(void *t){UxTensor*x=as_tensor(t);return x?x->count:0;} 
UXONNX2_API void* uxonnx2_tensor_data_ptr(void *t){UxTensor*x=as_tensor(t);return x?x->data:NULL;} 

UXONNX2_API void uxonnx2_tensor_set_f64(void *tensor,long long idx,double value){UxTensor*t=as_tensor(tensor);if(!t||idx<0||idx>=t->count)return; if(t->dtype==UXONNX2_DTYPE_F32)((float*)t->data)[idx]=(float)value; else if(t->dtype==UXONNX2_DTYPE_F64)((double*)t->data)[idx]=value; else if(t->dtype==UXONNX2_DTYPE_I64)((int64_t*)t->data)[idx]=(int64_t)value; else if(t->dtype==UXONNX2_DTYPE_I32)((int32_t*)t->data)[idx]=(int32_t)value;}
UXONNX2_API double uxonnx2_tensor_get_f64(void *tensor,long long idx){UxTensor*t=as_tensor(tensor);if(!t||idx<0||idx>=t->count)return 0.0; if(t->dtype==UXONNX2_DTYPE_F32)return ((float*)t->data)[idx]; if(t->dtype==UXONNX2_DTYPE_F64)return ((double*)t->data)[idx]; if(t->dtype==UXONNX2_DTYPE_I64)return (double)((int64_t*)t->data)[idx]; if(t->dtype==UXONNX2_DTYPE_I32)return (double)((int32_t*)t->data)[idx]; return 0.0;}
UXONNX2_API void uxonnx2_tensor_set_i64(void *tensor,long long idx,long long value){UxTensor*t=as_tensor(tensor);if(!t||idx<0||idx>=t->count)return; if(t->dtype==UXONNX2_DTYPE_I64)((int64_t*)t->data)[idx]=(int64_t)value; else uxonnx2_tensor_set_f64(tensor,idx,(double)value);}
UXONNX2_API long long uxonnx2_tensor_get_i64(void *tensor,long long idx){UxTensor*t=as_tensor(tensor);if(!t||idx<0||idx>=t->count)return 0; if(t->dtype==UXONNX2_DTYPE_I64)return ((int64_t*)t->data)[idx]; return (long long)uxonnx2_tensor_get_f64(tensor,idx);} 
UXONNX2_API void uxonnx2_tensor_set_string(void *tensor,long long idx,const char*value){UxTensor*t=as_tensor(tensor);if(!t||t->dtype!=UXONNX2_DTYPE_STRING||idx<0||idx>=t->count)return; free(t->strings[idx]); t->strings[idx]=dupstr(value?value:"");}
UXONNX2_API const char* uxonnx2_tensor_get_string(void *tensor,long long idx){UxTensor*t=as_tensor(tensor);if(!t||t->dtype!=UXONNX2_DTYPE_STRING||idx<0||idx>=t->count)return ""; return t->strings[idx]?t->strings[idx]:"";}

static OrtValue *tensor_to_ort(UxTensor *t) {
    if (!t || !g_ort) return NULL;
    OrtMemoryInfo *mi=NULL; OrtValue *v=NULL; OrtStatus *st=NULL;
    st=g_ort->CreateCpuMemoryInfo(OrtArenaAllocator, OrtMemTypeDefault, &mi); if(!check_status(st,"CreateCpuMemoryInfo")) return NULL;
    if (t->dtype==UXONNX2_DTYPE_STRING) {
        OrtAllocator *allocator=NULL;
        st=g_ort->GetAllocatorWithDefaultOptions(&allocator);
        if(!check_status(st,"GetAllocatorWithDefaultOptions")) { g_ort->ReleaseMemoryInfo(mi); return NULL; }
        st=g_ort->CreateTensorAsOrtValue(allocator, t->shape, (size_t)t->rank, ONNX_TENSOR_ELEMENT_DATA_TYPE_STRING, &v);
        if(!check_status(st,"CreateTensorAsOrtValue")) { g_ort->ReleaseMemoryInfo(mi); return NULL; }
        const char **arr=(const char**)calloc((size_t)t->count,sizeof(char*));
        if(!arr) { g_ort->ReleaseValue(v); g_ort->ReleaseMemoryInfo(mi); set_error("FillStringTensor: allocation failed"); return NULL; }
        for(int64_t i=0;i<t->count;i++) arr[i]=t->strings && t->strings[i]?t->strings[i]:"";
        st=g_ort->FillStringTensor(v, arr, (size_t)t->count);
        free(arr);
        if(!check_status(st,"FillStringTensor")) { g_ort->ReleaseValue(v); g_ort->ReleaseMemoryInfo(mi); return NULL; }
    } else {
        st=g_ort->CreateTensorWithDataAsOrtValue(mi, t->data, (size_t)(t->count*dtype_bytes(t->dtype)), t->shape, (size_t)t->rank, ort_dtype(t->dtype), &v);
        if(!check_status(st,"CreateTensorWithDataAsOrtValue")) { g_ort->ReleaseMemoryInfo(mi); return NULL; }
    }
    g_ort->ReleaseMemoryInfo(mi);
    return v;
}

static UxTensor *ort_to_tensor(OrtValue *v) {
    if (!v || !g_ort) return NULL;
    OrtTensorTypeAndShapeInfo *info=NULL;
    if(!check_status(g_ort->GetTensorTypeAndShape(v,&info),"GetTensorTypeAndShape")) return NULL;
    ONNXTensorElementDataType et=ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED;
    if(!check_status(g_ort->GetTensorElementType(info,&et),"GetTensorElementType")){g_ort->ReleaseTensorTypeAndShapeInfo(info);return NULL;}
    int dtype=ux_dtype(et);
    size_t rank=0;
    if(!check_status(g_ort->GetDimensionsCount(info,&rank),"GetDimensionsCount")){g_ort->ReleaseTensorTypeAndShapeInfo(info);return NULL;}
    if(rank>UXONNX2_MAX_RANK) rank=UXONNX2_MAX_RANK;
    int64_t dims[UXONNX2_MAX_RANK]={0};
    if(!check_status(g_ort->GetDimensions(info,dims,rank),"GetDimensions")){g_ort->ReleaseTensorTypeAndShapeInfo(info);return NULL;}
    g_ort->ReleaseTensorTypeAndShapeInfo(info);
    UxTensor *t=(UxTensor*)uxonnx2_tensor_create((const long long*)dims,(long long)rank,dtype);
    if(!t) return NULL;
    if(dtype==UXONNX2_DTYPE_STRING){
        size_t total_len=0;
        if(!check_status(g_ort->GetStringTensorDataLength(v,&total_len),"GetStringTensorDataLength")){uxonnx2_tensor_free(t);return NULL;}
        char *buf=(char*)calloc(total_len+1,1); size_t *offs=(size_t*)calloc((size_t)t->count,sizeof(size_t));
        if(!buf||!offs){free(buf);free(offs);uxonnx2_tensor_free(t);return NULL;}
        if(!check_status(g_ort->GetStringTensorContent(v,buf,total_len,offs,(size_t)t->count),"GetStringTensorContent")){free(buf);free(offs);uxonnx2_tensor_free(t);return NULL;}
        for(int64_t i=0;i<t->count;i++){ size_t start=offs[i]; size_t end=(i+1<t->count)?offs[i+1]:total_len; char tmp=buf[end]; buf[end]=0; uxonnx2_tensor_set_string(t,i,buf+start); buf[end]=tmp; }
        free(buf); free(offs); return t;
    }
    void *src=NULL;
    if(!check_status(g_ort->GetTensorMutableData(v,&src),"GetTensorMutableData")){uxonnx2_tensor_free(t);return NULL;}
    memcpy(t->data, src, (size_t)(t->count*dtype_bytes(t->dtype)));
    return t;
}

UXONNX2_API void* uxonnx2_run_create(void *session){UxSession*s=as_session(session); if(!s)return NULL; UxRun*r=(UxRun*)calloc(1,sizeof(UxRun)); if(!r)return NULL; r->magic=UXONNX2_MAGIC_RUN; r->session=s; return r;}
UXONNX2_API void uxonnx2_run_free(void *run){UxRun*r=as_run(run); if(!r)return; for(size_t i=0;i<r->input_count;i++)free(r->input_names[i]); for(size_t i=0;i<r->output_count;i++)free(r->output_names[i]); r->magic=0; free(r);} 
UXONNX2_API int uxonnx2_run_add_input(void *run,const char*name,void*tensor){UxRun*r=as_run(run); UxTensor*t=as_tensor(tensor); if(!r||!t||!name||!name[0]||r->input_count>=UXONNX2_MAX_IO)return 0; r->input_names[r->input_count]=dupstr(name); r->input_tensors[r->input_count]=t; r->input_count++; return 1;}
UXONNX2_API int uxonnx2_run_add_output(void *run,const char*name){UxRun*r=as_run(run); if(!r||!name||!name[0]||r->output_count>=UXONNX2_MAX_IO)return 0; r->output_names[r->output_count++]=dupstr(name); return 1;}

UXONNX2_API void* uxonnx2_run_execute(void *run){
    UxRun*r=as_run(run); if(!r||!r->session||r->input_count<1||r->output_count<1){set_error("run requires session, >=1 input and >=1 output"); return NULL;}
    OrtValue *inputs[UXONNX2_MAX_IO]={0}; OrtValue *outputs[UXONNX2_MAX_IO]={0};
    const char *in_names[UXONNX2_MAX_IO]; const char *out_names[UXONNX2_MAX_IO];
    for(size_t i=0;i<r->input_count;i++){ in_names[i]=r->input_names[i]; inputs[i]=tensor_to_ort(r->input_tensors[i]); if(!inputs[i]) goto fail; }
    for(size_t i=0;i<r->output_count;i++) out_names[i]=r->output_names[i];
    OrtStatus *st=g_ort->Run(r->session->session,NULL,in_names,(const OrtValue* const*)inputs,r->input_count,out_names,r->output_count,outputs);
    if(!check_status(st,"Run")) goto fail;
    UxResult*res=(UxResult*)calloc(1,sizeof(UxResult)); if(!res){set_error("out of memory result"); goto fail;}
    res->magic=UXONNX2_MAGIC_RESULT; res->count=r->output_count;
    for(size_t i=0;i<r->output_count;i++){ res->tensors[i]=ort_to_tensor(outputs[i]); if(outputs[i])g_ort->ReleaseValue(outputs[i]); outputs[i]=NULL; if(!res->tensors[i]){uxonnx2_result_free(res); goto fail;} }
    for(size_t i=0;i<r->input_count;i++) if(inputs[i]) g_ort->ReleaseValue(inputs[i]);
    return res;
fail:
    for(size_t i=0;i<r->input_count;i++) if(inputs[i]) g_ort->ReleaseValue(inputs[i]);
    for(size_t i=0;i<r->output_count;i++) if(outputs[i]) g_ort->ReleaseValue(outputs[i]);
    return NULL;
}

UXONNX2_API void uxonnx2_result_free(void *result){UxResult*r=as_result(result);if(!r)return; for(size_t i=0;i<r->count;i++) uxonnx2_tensor_free(r->tensors[i]); r->magic=0; free(r);} 
UXONNX2_API long long uxonnx2_result_count(void *result){UxResult*r=as_result(result);return r?(long long)r->count:0;} 
UXONNX2_API void* uxonnx2_result_tensor(void *result,long long idx){UxResult*r=as_result(result);if(!r||idx<0||(size_t)idx>=r->count)return NULL; return r->tensors[idx];}
UXONNX2_API void* uxonnx2_run1(void *session,const char*input_name,void*input_tensor,const char*output_name){void*r=uxonnx2_run_create(session); if(!r)return NULL; if(!uxonnx2_run_add_input(r,input_name,input_tensor)||!uxonnx2_run_add_output(r,output_name)){uxonnx2_run_free(r);return NULL;} void*res=uxonnx2_run_execute(r); uxonnx2_run_free(r); return res;}
