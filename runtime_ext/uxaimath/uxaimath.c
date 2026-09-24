#include "uxaimath.h"
#include <math.h>
#include <stdlib.h>
#include <stdint.h>
#include <float.h>
#include <string.h>

#if defined(UXAIMATH_USE_CBLAS)
#include <cblas.h>
#endif

static uint64_t uxai_rng_state = 0x12345678abcdefULL;

static double clamp_prob(double p) {
    if (p < 1e-15) return 1e-15;
    if (p > 1.0 - 1e-15) return 1.0 - 1e-15;
    return p;
}
static uint64_t xs64(void) {
    uint64_t x = uxai_rng_state;
    x ^= x << 13;
    x ^= x >> 7;
    x ^= x << 17;
    uxai_rng_state = x ? x : 0x12345678abcdefULL;
    return uxai_rng_state;
}
static double urand(void) { return (xs64() >> 11) * (1.0 / 9007199254740992.0); }
static double nrand(void) {
    double u1 = urand();
    double u2 = urand();
    if (u1 < 1e-15) u1 = 1e-15;
    return sqrt(-2.0 * log(u1)) * cos(6.28318530717958647692 * u2);
}

UXAI_API int uxaimath_version(void) { return 1; }
UXAI_API const char* uxaimath_backend(void) {
#if defined(UXAIMATH_USE_CBLAS)
    return "uxaimath:openblas_cblas";
#else
    return "uxaimath:fallback_c";
#endif
}
UXAI_API void uxaimath_seed(uint64_t seed) { uxai_rng_state = seed ? seed : 0x12345678abcdefULL; }

UXAI_API double uxaimath_sigmoid(double x) {
    if (x >= 0.0) { double z = exp(-x); return 1.0 / (1.0 + z); }
    double z = exp(x); return z / (1.0 + z);
}
UXAI_API double uxaimath_relu(double x) { return x > 0.0 ? x : 0.0; }
UXAI_API double uxaimath_leaky_relu(double x, double alpha) { return x > 0.0 ? x : alpha * x; }
UXAI_API double uxaimath_elu(double x, double alpha) { return x >= 0.0 ? x : alpha * (exp(x) - 1.0); }
UXAI_API double uxaimath_gelu(double x) { return 0.5 * x * (1.0 + tanh(0.7978845608028654 * (x + 0.044715 * x * x * x))); }
UXAI_API double uxaimath_swish(double x) { return x * uxaimath_sigmoid(x); }
UXAI_API double uxaimath_softplus(double x) { if (x > 40.0) return x; if (x < -40.0) return exp(x); return log1p(exp(x)); }

#define LOOP_APPLY(name, expr) UXAI_API void name(double* x, int64_t n) { if(!x||n<=0)return; for(int64_t i=0;i<n;i++){ double v=x[i]; x[i]=(expr); } }
LOOP_APPLY(uxaimath_sigmoid_inplace_f64, uxaimath_sigmoid(v))
LOOP_APPLY(uxaimath_tanh_inplace_f64, tanh(v))
LOOP_APPLY(uxaimath_relu_inplace_f64, uxaimath_relu(v))
LOOP_APPLY(uxaimath_gelu_inplace_f64, uxaimath_gelu(v))
LOOP_APPLY(uxaimath_swish_inplace_f64, uxaimath_swish(v))

UXAI_API void uxaimath_leaky_relu_inplace_f64(double* x, int64_t n, double alpha) { if(!x||n<=0)return; for(int64_t i=0;i<n;i++) x[i]=uxaimath_leaky_relu(x[i],alpha); }
UXAI_API void uxaimath_elu_inplace_f64(double* x, int64_t n, double alpha) { if(!x||n<=0)return; for(int64_t i=0;i<n;i++) x[i]=uxaimath_elu(x[i],alpha); }

UXAI_API void uxaimath_softmax_f64(const double* x, double* out, int64_t n) {
    if(!x||!out||n<=0)return;
    double m=x[0]; for(int64_t i=1;i<n;i++) if(x[i]>m)m=x[i];
    double s=0.0; for(int64_t i=0;i<n;i++){ out[i]=exp(x[i]-m); s+=out[i]; }
    if(s==0.0) return; for(int64_t i=0;i<n;i++) out[i]/=s;
}
UXAI_API void uxaimath_softmax_inplace_f64(double* x, int64_t n) { uxaimath_softmax_f64(x,x,n); }

UXAI_API double uxaimath_mse_f64(const double* yt, const double* yp, int64_t n) {
    if(!yt||!yp||n<=0)return NAN; double s=0.0; for(int64_t i=0;i<n;i++){ double d=yp[i]-yt[i]; s+=d*d; } return s/(double)n;
}
UXAI_API double uxaimath_mae_f64(const double* yt, const double* yp, int64_t n) {
    if(!yt||!yp||n<=0)return NAN; double s=0.0; for(int64_t i=0;i<n;i++) s+=fabs(yp[i]-yt[i]); return s/(double)n;
}
UXAI_API double uxaimath_huber_f64(const double* yt, const double* yp, int64_t n, double delta) {
    if(!yt||!yp||n<=0||delta<=0)return NAN; double s=0.0; for(int64_t i=0;i<n;i++){ double d=fabs(yp[i]-yt[i]); s += d<=delta ? 0.5*d*d : delta*(d-0.5*delta); } return s/(double)n;
}
UXAI_API double uxaimath_bce_f64(const double* yt, const double* yp, int64_t n) {
    if(!yt||!yp||n<=0)return NAN; double s=0.0; for(int64_t i=0;i<n;i++){ double p=clamp_prob(yp[i]); s += -(yt[i]*log(p)+(1.0-yt[i])*log(1.0-p)); } return s/(double)n;
}
UXAI_API double uxaimath_cce_f64(const double* yt, const double* yp, int64_t n) {
    if(!yt||!yp||n<=0)return NAN; double s=0.0; for(int64_t i=0;i<n;i++) if(yt[i]!=0.0) s += -yt[i]*log(clamp_prob(yp[i])); return s;
}
UXAI_API void uxaimath_mse_grad_f64(const double* yt, const double* yp, double* out, int64_t n) { if(!yt||!yp||!out||n<=0)return; double k=2.0/(double)n; for(int64_t i=0;i<n;i++) out[i]=k*(yp[i]-yt[i]); }
UXAI_API void uxaimath_bce_grad_f64(const double* yt, const double* yp, double* out, int64_t n) { if(!yt||!yp||!out||n<=0)return; for(int64_t i=0;i<n;i++){ double p=clamp_prob(yp[i]); out[i]=(p-yt[i])/(p*(1.0-p)*(double)n); } }

UXAI_API void uxaimath_fill_zero_f64(double* x, int64_t n) { if(x&&n>0) memset(x,0,(size_t)n*sizeof(double)); }
UXAI_API void uxaimath_fill_one_f64(double* x, int64_t n) { if(!x||n<=0)return; for(int64_t i=0;i<n;i++)x[i]=1.0; }
UXAI_API void uxaimath_fill_uniform_f64(double* x, int64_t n, double lo, double hi) { if(!x||n<=0)return; double w=hi-lo; for(int64_t i=0;i<n;i++)x[i]=lo+w*urand(); }
UXAI_API void uxaimath_fill_normal_f64(double* x, int64_t n, double mean, double stddev) { if(!x||n<=0)return; for(int64_t i=0;i<n;i++)x[i]=mean+stddev*nrand(); }
UXAI_API void uxaimath_xavier_uniform_f64(double* x, int64_t n, int64_t fan_in, int64_t fan_out) { double lim=sqrt(6.0/(double)(fan_in+fan_out)); uxaimath_fill_uniform_f64(x,n,-lim,lim); }
UXAI_API void uxaimath_he_uniform_f64(double* x, int64_t n, int64_t fan_in) { double lim=sqrt(6.0/(double)fan_in); uxaimath_fill_uniform_f64(x,n,-lim,lim); }

UXAI_API void uxaimath_clip_value_f64(double* x, int64_t n, double lo, double hi) { if(!x||n<=0)return; for(int64_t i=0;i<n;i++){ if(x[i]<lo)x[i]=lo; else if(x[i]>hi)x[i]=hi; } }
UXAI_API void uxaimath_clip_norm_f64(double* x, int64_t n, double max_norm) { if(!x||n<=0||max_norm<=0)return; double s=0; for(int64_t i=0;i<n;i++)s+=x[i]*x[i]; double norm=sqrt(s); if(norm>max_norm && norm>0){ double k=max_norm/norm; for(int64_t i=0;i<n;i++)x[i]*=k; } }
UXAI_API void uxaimath_sgd_update_f64(double* param, const double* grad, int64_t n, double lr) { if(!param||!grad||n<=0)return; for(int64_t i=0;i<n;i++)param[i]-=lr*grad[i]; }
UXAI_API void uxaimath_momentum_update_f64(double* param, const double* grad, double* velocity, int64_t n, double lr, double momentum) { if(!param||!grad||!velocity||n<=0)return; for(int64_t i=0;i<n;i++){ velocity[i]=momentum*velocity[i]-lr*grad[i]; param[i]+=velocity[i]; } }

UXAI_API void uxaimath_dense_forward_f64(const double* x, const double* w, const double* b, double* y, int64_t in_n, int64_t out_n) {
    if(!x||!w||!y||in_n<=0||out_n<=0)return;
#if defined(UXAIMATH_USE_CBLAS)
    cblas_dgemv(CblasRowMajor, CblasNoTrans, (int)out_n, (int)in_n, 1.0, w, (int)in_n, x, 1, 0.0, y, 1);
    if(b) for(int64_t j=0;j<out_n;j++) y[j]+=b[j];
#else
    for(int64_t j=0;j<out_n;j++){ double s=b?b[j]:0.0; const double* row=w+j*in_n; for(int64_t i=0;i<in_n;i++)s+=row[i]*x[i]; y[j]=s; }
#endif
}
UXAI_API void uxaimath_dense_batch_forward_f64(const double* x, const double* w, const double* b, double* y, int64_t batch, int64_t in_n, int64_t out_n) {
    if(!x||!w||!y||batch<=0||in_n<=0||out_n<=0)return;
    for(int64_t r=0;r<batch;r++) uxaimath_dense_forward_f64(x+r*in_n,w,b,y+r*out_n,in_n,out_n);
}
UXAI_API int64_t uxaimath_argmax_f64(const double* x, int64_t n) { if(!x||n<=0)return -1; int64_t best=0; for(int64_t i=1;i<n;i++) if(x[i]>x[best]) best=i; return best; }
UXAI_API double uxaimath_binary_accuracy_f64(const double* yt, const double* yp, int64_t n, double threshold) { if(!yt||!yp||n<=0)return NAN; int64_t ok=0; for(int64_t i=0;i<n;i++){ int a=yt[i]>=0.5; int b=yp[i]>=threshold; if(a==b) ok++; } return (double)ok/(double)n; }
