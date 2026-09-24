#include "uxnn.h"
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>

#ifdef UXNN_USE_OPENBLAS
#include <cblas.h>
#endif

#define UXNN_LAYER_DENSE 1
#define UXNN_LAYER_ACTIVATION 2

#define UXNN_ACT_LINEAR 0
#define UXNN_ACT_SIGMOID 1
#define UXNN_ACT_TANH 2
#define UXNN_ACT_RELU 3
#define UXNN_ACT_LEAKY_RELU 4
#define UXNN_ACT_SOFTMAX 5

#define UXNN_INIT_ZEROS 0
#define UXNN_INIT_UNIFORM 1
#define UXNN_INIT_XAVIER 2
#define UXNN_INIT_HE 3

typedef struct UxNNNeuron {
    int input_count;
    int activation;
    double* w;
    double b;
} UxNNNeuron;

typedef struct UxNNLayer {
    int type;
    int input_dim;
    int output_dim;
    int activation;
    double* W;
    double* b;
    double* last_input;
    double* last_z;
    double* last_a;
} UxNNLayer;

typedef struct UxNNNetwork {
    int count;
    int cap;
    UxNNLayer** layers;
    double* buf_a;
    double* buf_b;
    int buf_cap;
} UxNNNetwork;

static uint64_t uxnn_rng_state = 88172645463393265ull;

UXNN_API int uxnn_version(void) { return 1; }
UXNN_API const char* uxnn_backend(void) {
#ifdef UXNN_USE_OPENBLAS
    return "uxnn-openblas";
#else
    return "uxnn-c-fallback";
#endif
}
UXNN_API void uxnn_seed(unsigned long long seed) { uxnn_rng_state = seed ? seed : 88172645463393265ull; }

static double uxnn_rand01(void) {
    uxnn_rng_state ^= uxnn_rng_state << 7;
    uxnn_rng_state ^= uxnn_rng_state >> 9;
    return (double)(uxnn_rng_state & 0xFFFFFFFFull) / 4294967295.0;
}

static double uxnn_rand_uniform(double lo, double hi) { return lo + (hi-lo)*uxnn_rand01(); }

static double uxnn_act(int a, double x) {
    switch(a) {
    case UXNN_ACT_SIGMOID: return 1.0 / (1.0 + exp(-x));
    case UXNN_ACT_TANH: return tanh(x);
    case UXNN_ACT_RELU: return x > 0.0 ? x : 0.0;
    case UXNN_ACT_LEAKY_RELU: return x > 0.0 ? x : 0.01*x;
    case UXNN_ACT_LINEAR:
    default: return x;
    }
}
static double uxnn_act_deriv_from_z(int a, double z) {
    switch(a) {
    case UXNN_ACT_SIGMOID: { double y = uxnn_act(a,z); return y*(1.0-y); }
    case UXNN_ACT_TANH: { double y = tanh(z); return 1.0-y*y; }
    case UXNN_ACT_RELU: return z > 0.0 ? 1.0 : 0.0;
    case UXNN_ACT_LEAKY_RELU: return z > 0.0 ? 1.0 : 0.01;
    case UXNN_ACT_LINEAR:
    default: return 1.0;
    }
}
static void uxnn_softmax(const double* z, double* out, int n) {
    if (!z || !out || n <= 0) return;
    double maxv = z[0];
    for (int i=1;i<n;i++) if (z[i] > maxv) maxv = z[i];
    double sum = 0.0;
    for (int i=0;i<n;i++) { out[i] = exp(z[i]-maxv); sum += out[i]; }
    if (sum == 0.0) sum = 1.0;
    for (int i=0;i<n;i++) out[i] /= sum;
}

UXNN_API void* uxnn_neuron_create(int input_count, int activation) {
    if (input_count <= 0) return NULL;
    UxNNNeuron* n = (UxNNNeuron*)calloc(1,sizeof(UxNNNeuron));
    if (!n) return NULL;
    n->input_count = input_count; n->activation = activation;
    n->w = (double*)calloc((size_t)input_count, sizeof(double));
    if (!n->w) { free(n); return NULL; }
    return n;
}
UXNN_API void uxnn_neuron_free(void* h) { if (!h) return; UxNNNeuron* n=(UxNNNeuron*)h; free(n->w); free(n); }
UXNN_API void uxnn_neuron_set_weight(void* h, int idx, double v) { UxNNNeuron* n=(UxNNNeuron*)h; if(!n||idx<0||idx>=n->input_count) return; n->w[idx]=v; }
UXNN_API double uxnn_neuron_get_weight(void* h, int idx) { UxNNNeuron* n=(UxNNNeuron*)h; if(!n||idx<0||idx>=n->input_count) return 0.0; return n->w[idx]; }
UXNN_API void uxnn_neuron_set_bias(void* h, double v) { UxNNNeuron* n=(UxNNNeuron*)h; if(n) n->b=v; }
UXNN_API double uxnn_neuron_get_bias(void* h) { UxNNNeuron* n=(UxNNNeuron*)h; return n?n->b:0.0; }
UXNN_API double uxnn_neuron_forward_ptr(void* h, const double* input) {
    UxNNNeuron* n=(UxNNNeuron*)h; if(!n||!input) return 0.0;
    double z=n->b; for(int i=0;i<n->input_count;i++) z += n->w[i]*input[i];
    return uxnn_act(n->activation,z);
}

static UxNNLayer* uxnn_alloc_layer(int type, int in, int out, int act) {
    if (in <= 0 || out <= 0) return NULL;
    UxNNLayer* l=(UxNNLayer*)calloc(1,sizeof(UxNNLayer));
    if(!l) return NULL;
    l->type=type; l->input_dim=in; l->output_dim=out; l->activation=act;
    l->last_input=(double*)calloc((size_t)in,sizeof(double));
    l->last_z=(double*)calloc((size_t)out,sizeof(double));
    l->last_a=(double*)calloc((size_t)out,sizeof(double));
    if (!l->last_input||!l->last_z||!l->last_a) { uxnn_layer_free(l); return NULL; }
    if (type == UXNN_LAYER_DENSE) {
        l->W=(double*)calloc((size_t)out*(size_t)in,sizeof(double));
        l->b=(double*)calloc((size_t)out,sizeof(double));
        if(!l->W||!l->b) { uxnn_layer_free(l); return NULL; }
    }
    return l;
}
UXNN_API void* uxnn_layer_dense_create(int input_dim, int output_dim, int activation) { return uxnn_alloc_layer(UXNN_LAYER_DENSE,input_dim,output_dim,activation); }
UXNN_API void* uxnn_layer_activation_create(int dim, int activation) { return uxnn_alloc_layer(UXNN_LAYER_ACTIVATION,dim,dim,activation); }
UXNN_API void uxnn_layer_free(void* layer) { if(!layer)return; UxNNLayer* l=(UxNNLayer*)layer; free(l->W); free(l->b); free(l->last_input); free(l->last_z); free(l->last_a); free(l); }
UXNN_API int uxnn_layer_input_dim(void* layer) { UxNNLayer* l=(UxNNLayer*)layer; return l?l->input_dim:0; }
UXNN_API int uxnn_layer_output_dim(void* layer) { UxNNLayer* l=(UxNNLayer*)layer; return l?l->output_dim:0; }
UXNN_API void uxnn_layer_set_weight(void* layer, int out_idx, int in_idx, double v) { UxNNLayer* l=(UxNNLayer*)layer; if(!l||!l->W||out_idx<0||out_idx>=l->output_dim||in_idx<0||in_idx>=l->input_dim)return; l->W[(size_t)out_idx*l->input_dim+in_idx]=v; }
UXNN_API double uxnn_layer_get_weight(void* layer, int out_idx, int in_idx) { UxNNLayer* l=(UxNNLayer*)layer; if(!l||!l->W||out_idx<0||out_idx>=l->output_dim||in_idx<0||in_idx>=l->input_dim)return 0.0; return l->W[(size_t)out_idx*l->input_dim+in_idx]; }
UXNN_API void uxnn_layer_set_bias(void* layer, int out_idx, double v) { UxNNLayer* l=(UxNNLayer*)layer; if(!l||!l->b||out_idx<0||out_idx>=l->output_dim)return; l->b[out_idx]=v; }
UXNN_API double uxnn_layer_get_bias(void* layer, int out_idx) { UxNNLayer* l=(UxNNLayer*)layer; if(!l||!l->b||out_idx<0||out_idx>=l->output_dim)return 0.0; return l->b[out_idx]; }
UXNN_API void uxnn_layer_init(void* layer, int init_kind, double scale) {
    UxNNLayer* l=(UxNNLayer*)layer; if(!l||!l->W) return;
    double r=scale;
    if (r <= 0.0) r = 0.1;
    if (init_kind == UXNN_INIT_XAVIER) r = sqrt(6.0/(double)(l->input_dim+l->output_dim));
    if (init_kind == UXNN_INIT_HE) r = sqrt(6.0/(double)(l->input_dim));
    for (int o=0;o<l->output_dim;o++) for (int i=0;i<l->input_dim;i++) {
        l->W[(size_t)o*l->input_dim+i] = (init_kind==UXNN_INIT_ZEROS) ? 0.0 : uxnn_rand_uniform(-r,r);
    }
    for (int o=0;o<l->output_dim;o++) l->b[o]=0.0;
}

UXNN_API void uxnn_layer_forward_ptr(void* layer, const double* input, double* output) {
    UxNNLayer* l=(UxNNLayer*)layer; if(!l||!input||!output) return;
    memcpy(l->last_input, input, (size_t)l->input_dim*sizeof(double));
    if (l->type == UXNN_LAYER_ACTIVATION) {
        if (l->activation == UXNN_ACT_SOFTMAX) { uxnn_softmax(input, output, l->output_dim); memcpy(l->last_z,input,(size_t)l->output_dim*sizeof(double)); memcpy(l->last_a,output,(size_t)l->output_dim*sizeof(double)); return; }
        for(int i=0;i<l->output_dim;i++){ l->last_z[i]=input[i]; output[i]=uxnn_act(l->activation,input[i]); l->last_a[i]=output[i]; }
        return;
    }
#ifdef UXNN_USE_OPENBLAS
    cblas_dgemv(CblasRowMajor, CblasNoTrans, l->output_dim, l->input_dim, 1.0, l->W, l->input_dim, input, 1, 0.0, l->last_z, 1);
#else
    for(int o=0;o<l->output_dim;o++){ double z=0.0; for(int i=0;i<l->input_dim;i++) z += l->W[(size_t)o*l->input_dim+i]*input[i]; l->last_z[o]=z; }
#endif
    for(int o=0;o<l->output_dim;o++) l->last_z[o] += l->b[o];
    if (l->activation == UXNN_ACT_SOFTMAX) uxnn_softmax(l->last_z, output, l->output_dim);
    else for(int o=0;o<l->output_dim;o++) output[o]=uxnn_act(l->activation,l->last_z[o]);
    memcpy(l->last_a,output,(size_t)l->output_dim*sizeof(double));
}

UXNN_API void* uxnn_network_create(void) {
    UxNNNetwork* n=(UxNNNetwork*)calloc(1,sizeof(UxNNNetwork)); if(!n) return NULL;
    n->cap=4; n->layers=(UxNNLayer**)calloc((size_t)n->cap,sizeof(UxNNLayer*));
    if(!n->layers){free(n);return NULL;} return n;
}
UXNN_API void uxnn_network_free(void* net) {
    UxNNNetwork* n=(UxNNNetwork*)net; if(!n) return;
    for(int i=0;i<n->count;i++) uxnn_layer_free(n->layers[i]);
    free(n->layers); free(n->buf_a); free(n->buf_b); free(n);
}
static int uxnn_network_reserve(UxNNNetwork* n,int c){ if(c<=n->cap)return 1; int nc=n->cap*2; if(nc<c)nc=c; UxNNLayer** p=(UxNNLayer**)realloc(n->layers,(size_t)nc*sizeof(UxNNLayer*)); if(!p)return 0; n->layers=p; n->cap=nc; return 1; }
UXNN_API int uxnn_network_add_layer(void* net, void* layer) {
    UxNNNetwork* n=(UxNNNetwork*)net; UxNNLayer* l=(UxNNLayer*)layer; if(!n||!l)return 0;
    if(n->count>0 && n->layers[n->count-1]->output_dim != l->input_dim) return 0;
    if(!uxnn_network_reserve(n,n->count+1)) return 0;
    n->layers[n->count++]=l; return 1;
}
UXNN_API int uxnn_network_layer_count(void* net){UxNNNetwork*n=(UxNNNetwork*)net;return n?n->count:0;}
UXNN_API int uxnn_network_input_dim(void* net){UxNNNetwork*n=(UxNNNetwork*)net;return (n&&n->count>0)?n->layers[0]->input_dim:0;}
UXNN_API int uxnn_network_output_dim(void* net){UxNNNetwork*n=(UxNNNetwork*)net;return (n&&n->count>0)?n->layers[n->count-1]->output_dim:0;}
static int uxnn_ensure_buffers(UxNNNetwork* n) {
    int maxd=0; for(int i=0;i<n->count;i++){ if(n->layers[i]->input_dim>maxd)maxd=n->layers[i]->input_dim; if(n->layers[i]->output_dim>maxd)maxd=n->layers[i]->output_dim; }
    if(maxd<=n->buf_cap) return 1;
    double* a=(double*)realloc(n->buf_a,(size_t)maxd*sizeof(double)); double* b=(double*)realloc(n->buf_b,(size_t)maxd*sizeof(double));
    if(!a||!b) return 0; n->buf_a=a; n->buf_b=b; n->buf_cap=maxd; return 1;
}
UXNN_API void uxnn_network_forward_ptr(void* net, const double* input, double* output) {
    UxNNNetwork* n=(UxNNNetwork*)net; if(!n||n->count<=0||!input||!output)return;
    if(!uxnn_ensure_buffers(n)) return;
    const double* cur=input; double* next=n->buf_a;
    for(int li=0;li<n->count;li++){
        if(li==n->count-1) next=output; else next=(li%2==0?n->buf_a:n->buf_b);
        uxnn_layer_forward_ptr(n->layers[li],cur,next);
        cur=next;
    }
}
UXNN_API int uxnn_network_predict_argmax_ptr(void* net, const double* input) {
    UxNNNetwork*n=(UxNNNetwork*)net; if(!n||n->count<=0||!input)return -1;
    int od=uxnn_network_output_dim(net); double* out=(double*)calloc((size_t)od,sizeof(double)); if(!out)return -1;
    uxnn_network_forward_ptr(net,input,out); int idx=0; for(int i=1;i<od;i++) if(out[i]>out[idx]) idx=i; free(out); return idx;
}
UXNN_API double uxnn_network_mse_ptr(void* net, const double* x, const double* y, int sample_count, int input_dim, int output_dim) {
    if(!net||!x||!y||sample_count<=0||input_dim<=0||output_dim<=0)return 0.0;
    double* out=(double*)calloc((size_t)output_dim,sizeof(double)); if(!out)return 0.0;
    double loss=0.0; for(int s=0;s<sample_count;s++){ uxnn_network_forward_ptr(net,x+(size_t)s*input_dim,out); for(int j=0;j<output_dim;j++){ double e=out[j]-y[(size_t)s*output_dim+j]; loss += e*e; } }
    free(out); return loss/(double)(sample_count*output_dim);
}
UXNN_API double uxnn_network_train_mse_sgd_ptr(void* net, const double* x, const double* y, int sample_count, int input_dim, int output_dim, int epochs, double lr) {
    UxNNNetwork*n=(UxNNNetwork*)net; if(!n||!x||!y||sample_count<=0||epochs<=0||lr<=0.0)return 0.0;
    if(n->count<=0||n->count>4096) return 0.0;
    if(uxnn_network_input_dim(net)!=input_dim || uxnn_network_output_dim(net)!=output_dim) return 0.0;
    double** delta=(double**)calloc((size_t)n->count,sizeof(double*)); if(!delta)return 0.0;
    for(int i=0;i<n->count;i++){ delta[i]=(double*)calloc((size_t)n->layers[i]->output_dim,sizeof(double)); if(!delta[i]){for(int k=0;k<i;k++)free(delta[k]);free(delta);return 0.0;} }
    double* out=(double*)calloc((size_t)output_dim,sizeof(double));
    if(!out){for(int i=0;i<n->count;i++)free(delta[i]);free(delta);return 0.0;}
    for(int ep=0;ep<epochs;ep++){
        for(int s=0;s<sample_count;s++){
            const double* in=x+(size_t)s*input_dim;
            uxnn_network_forward_ptr(net,in,out);
            UxNNLayer* last=n->layers[n->count-1];
            for(int j=0;j<last->output_dim;j++){ double e=out[j]-y[(size_t)s*output_dim+j]; delta[n->count-1][j]=2.0*e/(double)output_dim * uxnn_act_deriv_from_z(last->activation,last->last_z[j]); }
            for(int li=n->count-2;li>=0;li--){
                UxNNLayer* l=n->layers[li]; UxNNLayer* nxt=n->layers[li+1];
                for(int i=0;i<l->output_dim;i++){ double sum=0.0; if(nxt->W){ for(int j=0;j<nxt->output_dim;j++) sum += nxt->W[(size_t)j*nxt->input_dim+i]*delta[li+1][j]; } delta[li][i]=sum*uxnn_act_deriv_from_z(l->activation,l->last_z[i]); }
            }
            for(int li=0;li<n->count;li++){
                UxNNLayer* l=n->layers[li]; if(!l->W) continue;
                for(int o=0;o<l->output_dim;o++){
                    for(int i=0;i<l->input_dim;i++) l->W[(size_t)o*l->input_dim+i] -= lr*delta[li][o]*l->last_input[i];
                    l->b[o] -= lr*delta[li][o];
                }
            }
        }
    }
    free(out);
    for(int i=0;i<n->count;i++)free(delta[i]); free(delta);
    return uxnn_network_mse_ptr(net,x,y,sample_count,input_dim,output_dim);
}
