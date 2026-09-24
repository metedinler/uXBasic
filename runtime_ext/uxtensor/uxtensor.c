#include "uxtensor.h"
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

#ifndef UXTENSOR_NO_OPENBLAS
#include <cblas.h>
#endif

#if defined(_WIN32)
#define DLL_EXPORT __declspec(dllexport)
#else
#define DLL_EXPORT
#endif

struct UXTensor {
    int dtype;
    int ndim;
    long long shape[UXTENSOR_MAX_DIMS];
    long long stride[UXTENSOR_MAX_DIMS];
    long long size;
    long long elem_size;
    int owner;
    void* data;
};

typedef struct UXTensor UXTensor;

static long long elem_size_for(int dtype) {
    switch(dtype) {
        case UXTENSOR_DTYPE_F64: return 8;
        case UXTENSOR_DTYPE_F32: return 4;
        case UXTENSOR_DTYPE_I64: return 8;
        default: return 0;
    }
}

static int shape_ok(int ndim, const long long* shape) {
    if (ndim < 1 || ndim > UXTENSOR_MAX_DIMS || !shape) return 0;
    for (int i=0;i<ndim;i++) if (shape[i] < 1) return 0;
    return 1;
}

static long long compute_size(int ndim, const long long* shape) {
    long long s = 1;
    for (int i=0;i<ndim;i++) {
        if (shape[i] <= 0) return 0;
        if (s > 9223372036854775807LL / shape[i]) return 0;
        s *= shape[i];
    }
    return s;
}

static void compute_rowmajor_strides(UXTensor* t) {
    long long st = 1;
    for (int i=t->ndim-1; i>=0; --i) {
        t->stride[i] = st;
        st *= t->shape[i];
    }
}

static UXTensor* tensor_alloc(int dtype, int ndim, const long long* shape) {
    long long es = elem_size_for(dtype);
    if (!es || !shape_ok(ndim, shape)) return NULL;
    long long sz = compute_size(ndim, shape);
    if (sz < 1) return NULL;
    UXTensor* t = (UXTensor*)calloc(1, sizeof(UXTensor));
    if (!t) return NULL;
    t->dtype = dtype;
    t->ndim = ndim;
    t->size = sz;
    t->elem_size = es;
    t->owner = 1;
    for (int i=0;i<ndim;i++) t->shape[i] = shape[i];
    compute_rowmajor_strides(t);
    t->data = calloc((size_t)sz, (size_t)es);
    if (!t->data) { free(t); return NULL; }
    return t;
}

static int compatible_f64(UXTensor* a, UXTensor* b) {
    if (!a || !b) return 0;
    if (a->dtype != UXTENSOR_DTYPE_F64 || b->dtype != UXTENSOR_DTYPE_F64) return 0;
    if (a->ndim != b->ndim || a->size != b->size) return 0;
    for (int i=0;i<a->ndim;i++) if (a->shape[i] != b->shape[i]) return 0;
    return 1;
}

static double* f64data(UXTensor* t) { return (double*)t->data; }

DLL_EXPORT int uxtensor_version(void) { return 1; }

DLL_EXPORT const char* uxtensor_backend(void) {
#ifdef UXTENSOR_NO_OPENBLAS
    return "fallback-c";
#else
    return "openblas-cblas";
#endif
}

DLL_EXPORT void* uxtensor_create(int dtype, int ndim, const long long* shape) {
    return tensor_alloc(dtype, ndim, shape);
}

DLL_EXPORT void* uxtensor_create1d_f64(long long n) {
    long long s[1] = { n };
    return tensor_alloc(UXTENSOR_DTYPE_F64, 1, s);
}

DLL_EXPORT void* uxtensor_create2d_f64(long long rows, long long cols) {
    long long s[2] = { rows, cols };
    return tensor_alloc(UXTENSOR_DTYPE_F64, 2, s);
}

DLL_EXPORT void* uxtensor_create3d_f64(long long a, long long b, long long c) {
    long long s[3] = { a, b, c };
    return tensor_alloc(UXTENSOR_DTYPE_F64, 3, s);
}

DLL_EXPORT void* uxtensor_create4d_f64(long long a, long long b, long long c, long long d) {
    long long s[4] = { a, b, c, d };
    return tensor_alloc(UXTENSOR_DTYPE_F64, 4, s);
}

DLL_EXPORT void uxtensor_free(void* handle) {
    UXTensor* t = (UXTensor*)handle;
    if (!t) return;
    if (t->owner && t->data) free(t->data);
    free(t);
}

DLL_EXPORT void* uxtensor_clone(void* handle) {
    UXTensor* a = (UXTensor*)handle;
    if (!a) return NULL;
    UXTensor* o = tensor_alloc(a->dtype, a->ndim, a->shape);
    if (!o) return NULL;
    memcpy(o->data, a->data, (size_t)(a->size * a->elem_size));
    return o;
}

DLL_EXPORT void* uxtensor_reshape_copy(void* handle, int ndim, const long long* shape) {
    UXTensor* a = (UXTensor*)handle;
    if (!a || !shape_ok(ndim, shape)) return NULL;
    long long sz = compute_size(ndim, shape);
    if (sz != a->size) return NULL;
    UXTensor* o = tensor_alloc(a->dtype, ndim, shape);
    if (!o) return NULL;
    memcpy(o->data, a->data, (size_t)(a->size * a->elem_size));
    return o;
}

DLL_EXPORT void* uxtensor_slice_axis0_copy(void* handle, long long start, long long count) {
    UXTensor* a = (UXTensor*)handle;
    if (!a || a->ndim < 1 || start < 0 || count < 1 || start + count > a->shape[0]) return NULL;
    long long newshape[UXTENSOR_MAX_DIMS];
    for (int i=0;i<a->ndim;i++) newshape[i] = a->shape[i];
    newshape[0] = count;
    UXTensor* o = tensor_alloc(a->dtype, a->ndim, newshape);
    if (!o) return NULL;
    long long block_elems = a->stride[0];
    long long offset = start * block_elems;
    long long bytes = count * block_elems * a->elem_size;
    memcpy(o->data, (char*)a->data + offset * a->elem_size, (size_t)bytes);
    return o;
}

DLL_EXPORT int uxtensor_dtype(void* handle) { UXTensor* t=(UXTensor*)handle; return t ? t->dtype : 0; }
DLL_EXPORT int uxtensor_ndim(void* handle) { UXTensor* t=(UXTensor*)handle; return t ? t->ndim : 0; }
DLL_EXPORT long long uxtensor_dim(void* handle, int axis) { UXTensor* t=(UXTensor*)handle; if(!t||axis<0||axis>=t->ndim) return 0; return t->shape[axis]; }
DLL_EXPORT long long uxtensor_stride(void* handle, int axis) { UXTensor* t=(UXTensor*)handle; if(!t||axis<0||axis>=t->ndim) return 0; return t->stride[axis]; }
DLL_EXPORT long long uxtensor_size(void* handle) { UXTensor* t=(UXTensor*)handle; return t ? t->size : 0; }
DLL_EXPORT long long uxtensor_elem_size(void* handle) { UXTensor* t=(UXTensor*)handle; return t ? t->elem_size : 0; }
DLL_EXPORT void* uxtensor_data_ptr(void* handle) { UXTensor* t=(UXTensor*)handle; return t ? t->data : NULL; }

DLL_EXPORT int uxtensor_fill_f64(void* handle, double value) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64) return 0;
    double* d=f64data(t); for(long long i=0;i<t->size;i++) d[i]=value; return 1;
}

DLL_EXPORT int uxtensor_zero(void* handle) {
    UXTensor* t=(UXTensor*)handle; if(!t||!t->data) return 0;
    memset(t->data, 0, (size_t)(t->size * t->elem_size)); return 1;
}

DLL_EXPORT double uxtensor_get_flat_f64(void* handle, long long index) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||index<0||index>=t->size) return NAN;
    return f64data(t)[index];
}

DLL_EXPORT int uxtensor_set_flat_f64(void* handle, long long index, double value) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||index<0||index>=t->size) return 0;
    f64data(t)[index]=value; return 1;
}

DLL_EXPORT double uxtensor_get2d_f64(void* handle, long long r, long long c) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||t->ndim!=2) return NAN;
    if(r<0||c<0||r>=t->shape[0]||c>=t->shape[1]) return NAN;
    return f64data(t)[r*t->stride[0]+c*t->stride[1]];
}

DLL_EXPORT int uxtensor_set2d_f64(void* handle, long long r, long long c, double value) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||t->ndim!=2) return 0;
    if(r<0||c<0||r>=t->shape[0]||c>=t->shape[1]) return 0;
    f64data(t)[r*t->stride[0]+c*t->stride[1]]=value; return 1;
}

DLL_EXPORT double uxtensor_get3d_f64(void* handle, long long a, long long b, long long c) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||t->ndim!=3) return NAN;
    if(a<0||b<0||c<0||a>=t->shape[0]||b>=t->shape[1]||c>=t->shape[2]) return NAN;
    return f64data(t)[a*t->stride[0]+b*t->stride[1]+c*t->stride[2]];
}

DLL_EXPORT int uxtensor_set3d_f64(void* handle, long long a, long long b, long long c, double value) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||t->ndim!=3) return 0;
    if(a<0||b<0||c<0||a>=t->shape[0]||b>=t->shape[1]||c>=t->shape[2]) return 0;
    f64data(t)[a*t->stride[0]+b*t->stride[1]+c*t->stride[2]]=value; return 1;
}

DLL_EXPORT double uxtensor_get4d_f64(void* handle, long long a, long long b, long long c, long long d) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||t->ndim!=4) return NAN;
    if(a<0||b<0||c<0||d<0||a>=t->shape[0]||b>=t->shape[1]||c>=t->shape[2]||d>=t->shape[3]) return NAN;
    return f64data(t)[a*t->stride[0]+b*t->stride[1]+c*t->stride[2]+d*t->stride[3]];
}

DLL_EXPORT int uxtensor_set4d_f64(void* handle, long long a, long long b, long long c, long long d, double value) {
    UXTensor* t=(UXTensor*)handle; if(!t||t->dtype!=UXTENSOR_DTYPE_F64||t->ndim!=4) return 0;
    if(a<0||b<0||c<0||d<0||a>=t->shape[0]||b>=t->shape[1]||c>=t->shape[2]||d>=t->shape[3]) return 0;
    f64data(t)[a*t->stride[0]+b*t->stride[1]+c*t->stride[2]+d*t->stride[3]]=value; return 1;
}

static void* elemwise2(void* ah, void* bh, char op) {
    UXTensor *a=(UXTensor*)ah, *b=(UXTensor*)bh;
    if(!compatible_f64(a,b)) return NULL;
    UXTensor* o=tensor_alloc(UXTENSOR_DTYPE_F64,a->ndim,a->shape); if(!o) return NULL;
    double *ad=f64data(a), *bd=f64data(b), *od=f64data(o);
    for(long long i=0;i<a->size;i++) {
        switch(op) { case '+': od[i]=ad[i]+bd[i]; break; case '-': od[i]=ad[i]-bd[i]; break; case '*': od[i]=ad[i]*bd[i]; break; case '/': od[i]=bd[i]!=0.0?ad[i]/bd[i]:NAN; break; }
    }
    return o;
}

DLL_EXPORT void* uxtensor_add_f64(void* a, void* b) { return elemwise2(a,b,'+'); }
DLL_EXPORT void* uxtensor_sub_f64(void* a, void* b) { return elemwise2(a,b,'-'); }
DLL_EXPORT void* uxtensor_mul_f64(void* a, void* b) { return elemwise2(a,b,'*'); }
DLL_EXPORT void* uxtensor_div_f64(void* a, void* b) { return elemwise2(a,b,'/'); }

DLL_EXPORT void* uxtensor_scale_f64(void* ah, double scalar) {
    UXTensor* a=(UXTensor*)ah; if(!a||a->dtype!=UXTENSOR_DTYPE_F64) return NULL;
    UXTensor* o=tensor_alloc(UXTENSOR_DTYPE_F64,a->ndim,a->shape); if(!o) return NULL;
    double *ad=f64data(a), *od=f64data(o);
    for(long long i=0;i<a->size;i++) od[i]=ad[i]*scalar;
    return o;
}

DLL_EXPORT double uxtensor_sum_f64(void* ah) {
    UXTensor* a=(UXTensor*)ah; if(!a||a->dtype!=UXTENSOR_DTYPE_F64) return NAN;
    double s=0.0; double* ad=f64data(a); for(long long i=0;i<a->size;i++) s+=ad[i]; return s;
}

DLL_EXPORT double uxtensor_mean_f64(void* a) { UXTensor* t=(UXTensor*)a; if(!t||t->size<1) return NAN; return uxtensor_sum_f64(a)/(double)t->size; }

DLL_EXPORT double uxtensor_blas_ddot(long long n, const double* x, long long incx, const double* y, long long incy) {
#ifndef UXTENSOR_NO_OPENBLAS
    return cblas_ddot((int)n, x, (int)incx, y, (int)incy);
#else
    double s=0.0; for(long long i=0;i<n;i++) s += x[i*incx]*y[i*incy]; return s;
#endif
}

DLL_EXPORT int uxtensor_blas_daxpy(long long n, double alpha, const double* x, long long incx, double* y, long long incy) {
    if(!x||!y||n<1) return 0;
#ifndef UXTENSOR_NO_OPENBLAS
    cblas_daxpy((int)n, alpha, x, (int)incx, y, (int)incy);
#else
    for(long long i=0;i<n;i++) y[i*incy] += alpha*x[i*incx];
#endif
    return 1;
}

DLL_EXPORT int uxtensor_blas_dscal(long long n, double alpha, double* x, long long incx) {
    if(!x||n<1) return 0;
#ifndef UXTENSOR_NO_OPENBLAS
    cblas_dscal((int)n, alpha, x, (int)incx);
#else
    for(long long i=0;i<n;i++) x[i*incx] *= alpha;
#endif
    return 1;
}

DLL_EXPORT double uxtensor_dot_f64(void* ah, void* bh) {
    UXTensor *a=(UXTensor*)ah, *b=(UXTensor*)bh; if(!compatible_f64(a,b)) return NAN;
    return uxtensor_blas_ddot(a->size, f64data(a), 1, f64data(b), 1);
}

DLL_EXPORT double uxtensor_norm2_f64(void* a) { double d=uxtensor_dot_f64(a,a); return d<0.0?NAN:sqrt(d); }

DLL_EXPORT int uxtensor_blas_dgemm_rowmajor(long long m, long long n, long long k, double alpha, const double* a, const double* b, double beta, double* c) {
    if(!a||!b||!c||m<1||n<1||k<1) return 0;
#ifndef UXTENSOR_NO_OPENBLAS
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, (int)m, (int)n, (int)k, alpha, a, (int)k, b, (int)n, beta, c, (int)n);
#else
    for(long long i=0;i<m;i++) {
        for(long long j=0;j<n;j++) {
            double s=0.0;
            for(long long kk=0;kk<k;kk++) s += a[i*k+kk]*b[kk*n+j];
            c[i*n+j] = alpha*s + beta*c[i*n+j];
        }
    }
#endif
    return 1;
}

DLL_EXPORT void* uxtensor_matmul2d_f64(void* ah, void* bh) {
    UXTensor *a=(UXTensor*)ah, *b=(UXTensor*)bh;
    if(!a||!b||a->dtype!=UXTENSOR_DTYPE_F64||b->dtype!=UXTENSOR_DTYPE_F64||a->ndim!=2||b->ndim!=2) return NULL;
    long long m=a->shape[0], k=a->shape[1], k2=b->shape[0], n=b->shape[1];
    if(k!=k2) return NULL;
    long long s[2]={m,n}; UXTensor* o=tensor_alloc(UXTENSOR_DTYPE_F64,2,s); if(!o) return NULL;
    if(!uxtensor_blas_dgemm_rowmajor(m,n,k,1.0,f64data(a),f64data(b),0.0,f64data(o))) { uxtensor_free(o); return NULL; }
    return o;
}

DLL_EXPORT void* uxtensor_transpose2d_f64(void* ah) {
    UXTensor* a=(UXTensor*)ah; if(!a||a->dtype!=UXTENSOR_DTYPE_F64||a->ndim!=2) return NULL;
    long long s[2]={a->shape[1],a->shape[0]}; UXTensor* o=tensor_alloc(UXTENSOR_DTYPE_F64,2,s); if(!o) return NULL;
    double *ad=f64data(a), *od=f64data(o);
    for(long long r=0;r<a->shape[0];r++) for(long long c=0;c<a->shape[1];c++) od[c*o->stride[0]+r]=ad[r*a->stride[0]+c];
    return o;
}

DLL_EXPORT void* uxtensor_matvec2d_f64(void* ah, void* xh) {
    UXTensor *a=(UXTensor*)ah, *x=(UXTensor*)xh;
    if(!a||!x||a->dtype!=UXTENSOR_DTYPE_F64||x->dtype!=UXTENSOR_DTYPE_F64||a->ndim!=2||x->ndim!=1) return NULL;
    if(a->shape[1]!=x->shape[0]) return NULL;
    long long s[1]={a->shape[0]}; UXTensor* o=tensor_alloc(UXTENSOR_DTYPE_F64,1,s); if(!o) return NULL;
#ifndef UXTENSOR_NO_OPENBLAS
    cblas_dgemv(CblasRowMajor, CblasNoTrans, (int)a->shape[0], (int)a->shape[1], 1.0, f64data(a), (int)a->shape[1], f64data(x), 1, 0.0, f64data(o), 1);
#else
    double *ad=f64data(a), *xd=f64data(x), *od=f64data(o);
    for(long long r=0;r<a->shape[0];r++) { double sum=0.0; for(long long c=0;c<a->shape[1];c++) sum+=ad[r*a->shape[1]+c]*xd[c]; od[r]=sum; }
#endif
    return o;
}
