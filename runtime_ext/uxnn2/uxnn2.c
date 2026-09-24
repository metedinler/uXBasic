#include "uxnn2.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define UXNN2_ACT_LINEAR 0
#define UXNN2_ACT_SIGMOID 1
#define UXNN2_ACT_TANH 2
#define UXNN2_ACT_RELU 3
#define UXNN2_ACT_LEAKY_RELU 4
#define UXNN2_ACT_SOFTMAX 5
#define UXNN2_INIT_ZEROS 0
#define UXNN2_INIT_UNIFORM 1
#define UXNN2_INIT_XAVIER 2
#define UXNN2_INIT_HE 3
#define UXNN2_OPT_SGD 0
#define UXNN2_OPT_MOMENTUM 1
#define UXNN2_OPT_ADAM 2

typedef struct UXNN2Layer {
    int input_dim, output_dim, activation;
    double *w, *b, *z, *a, *delta;
    double *mw, *vw, *mb, *vb;
} UXNN2Layer;

typedef struct UXNN2Network {
    int input_dim;
    int layer_count, layer_cap;
    UXNN2Layer *layers;
    int opt_kind;
    double lr, beta1, beta2, eps, weight_decay;
    unsigned long long step;
} UXNN2Network;

static uint64_t g_rng = 88172645463393265ull;

static double urand01(void) {
    g_rng = g_rng * 2862933555777941757ULL + 3037000493ULL;
    uint64_t x = g_rng >> 11;
    return (double)x * (1.0 / 9007199254740992.0);
}
static double urand(double a, double b) { return a + (b-a)*urand01(); }
static double nrand(void) {
    double u1 = urand01(); if (u1 < 1e-12) u1 = 1e-12;
    double u2 = urand01();
    return sqrt(-2.0*log(u1))*cos(6.2831853071795864769*u2);
}
static double act_forward(int act, double x) {
    switch(act) {
        case UXNN2_ACT_SIGMOID: return 1.0/(1.0+exp(-x));
        case UXNN2_ACT_TANH: return tanh(x);
        case UXNN2_ACT_RELU: return x > 0.0 ? x : 0.0;
        case UXNN2_ACT_LEAKY_RELU: return x > 0.0 ? x : 0.01*x;
        default: return x;
    }
}
static double act_derivative_from_za(int act, double z, double a) {
    switch(act) {
        case UXNN2_ACT_SIGMOID: return a*(1.0-a);
        case UXNN2_ACT_TANH: return 1.0-a*a;
        case UXNN2_ACT_RELU: return z > 0.0 ? 1.0 : 0.0;
        case UXNN2_ACT_LEAKY_RELU: return z > 0.0 ? 1.0 : 0.01;
        default: return 1.0;
    }
}
static void softmax(double *z, double *a, int n) {
    double m = z[0]; for(int i=1;i<n;i++) if(z[i]>m) m=z[i];
    double s = 0.0; for(int i=0;i<n;i++){ a[i] = exp(z[i]-m); s += a[i]; }
    if(s <= 0.0) s = 1.0;
    for(int i=0;i<n;i++) a[i] /= s;
}
static void layer_free(UXNN2Layer *l) {
    if(!l) return;
    free(l->w); free(l->b); free(l->z); free(l->a); free(l->delta);
    free(l->mw); free(l->vw); free(l->mb); free(l->vb);
    memset(l,0,sizeof(*l));
}
static int layer_alloc(UXNN2Layer *l, int in, int out, int act) {
    memset(l,0,sizeof(*l));
    if(in<=0 || out<=0) return 0;
    l->input_dim=in; l->output_dim=out; l->activation=act;
    size_t wc=(size_t)in*(size_t)out;
    l->w=(double*)calloc(wc,sizeof(double)); l->b=(double*)calloc(out,sizeof(double));
    l->z=(double*)calloc(out,sizeof(double)); l->a=(double*)calloc(out,sizeof(double)); l->delta=(double*)calloc(out,sizeof(double));
    l->mw=(double*)calloc(wc,sizeof(double)); l->vw=(double*)calloc(wc,sizeof(double));
    l->mb=(double*)calloc(out,sizeof(double)); l->vb=(double*)calloc(out,sizeof(double));
    return l->w&&l->b&&l->z&&l->a&&l->delta&&l->mw&&l->vw&&l->mb&&l->vb;
}
static void layer_init(UXNN2Layer *l, int init_kind, double scale) {
    if(!l) return;
    double lim = scale;
    if(lim <= 0.0) {
        if(init_kind == UXNN2_INIT_HE) lim = sqrt(6.0/(double)l->input_dim);
        else lim = sqrt(6.0/(double)(l->input_dim + l->output_dim));
    }
    size_t wc=(size_t)l->input_dim*(size_t)l->output_dim;
    for(size_t i=0;i<wc;i++) {
        if(init_kind == UXNN2_INIT_ZEROS) l->w[i]=0.0;
        else if(init_kind == UXNN2_INIT_UNIFORM) l->w[i]=urand(-lim,lim);
        else l->w[i]=urand(-lim,lim);
    }
    for(int i=0;i<l->output_dim;i++) l->b[i]=0.0;
}
static void layer_forward(UXNN2Layer *l, const double *x) {
    for(int o=0;o<l->output_dim;o++) {
        double s=l->b[o];
        for(int i=0;i<l->input_dim;i++) s += l->w[(size_t)o*l->input_dim+i]*x[i];
        l->z[o]=s;
    }
    if(l->activation == UXNN2_ACT_SOFTMAX) softmax(l->z,l->a,l->output_dim);
    else for(int o=0;o<l->output_dim;o++) l->a[o]=act_forward(l->activation,l->z[o]);
}
static void network_forward_internal(UXNN2Network *n, const double *input) {
    const double *x=input;
    for(int li=0;li<n->layer_count;li++) { layer_forward(&n->layers[li], x); x=n->layers[li].a; }
}
static void apply_update(UXNN2Network *n, double *param, double grad, double *m, double *v) {
    grad += n->weight_decay * (*param);
    if(n->opt_kind == UXNN2_OPT_MOMENTUM) {
        *m = n->beta1*(*m) + grad;
        *param -= n->lr * (*m);
    } else if(n->opt_kind == UXNN2_OPT_ADAM) {
        *m = n->beta1*(*m) + (1.0-n->beta1)*grad;
        *v = n->beta2*(*v) + (1.0-n->beta2)*grad*grad;
        double mh = (*m)/(1.0-pow(n->beta1,(double)n->step));
        double vh = (*v)/(1.0-pow(n->beta2,(double)n->step));
        *param -= n->lr * mh / (sqrt(vh)+n->eps);
    } else {
        *param -= n->lr * grad;
    }
}

int uxnn2_version(void) { return 2; }
const char* uxnn2_backend(void) { return "uxnn2 pure-c training core"; }
void uxnn2_seed(unsigned long long seed) { g_rng = seed ? seed : 88172645463393265ull; }

void* uxnn2_network_create(int input_dim) {
    if(input_dim<=0) return NULL;
    UXNN2Network *n=(UXNN2Network*)calloc(1,sizeof(UXNN2Network));
    if(!n) return NULL;
    n->input_dim=input_dim; n->layer_cap=4; n->layers=(UXNN2Layer*)calloc(n->layer_cap,sizeof(UXNN2Layer));
    n->opt_kind=UXNN2_OPT_SGD; n->lr=0.05; n->beta1=0.9; n->beta2=0.999; n->eps=1e-8; n->weight_decay=0.0;
    if(!n->layers){ free(n); return NULL; }
    return n;
}
void uxnn2_network_free(void* net) {
    UXNN2Network *n=(UXNN2Network*)net; if(!n) return;
    for(int i=0;i<n->layer_count;i++) layer_free(&n->layers[i]);
    free(n->layers); free(n);
}
int uxnn2_network_add_dense(void* net, int output_dim, int activation) {
    UXNN2Network *n=(UXNN2Network*)net; if(!n||output_dim<=0) return -1;
    if(n->layer_count>=n->layer_cap){ int nc=n->layer_cap*2; UXNN2Layer *nl=(UXNN2Layer*)realloc(n->layers,nc*sizeof(UXNN2Layer)); if(!nl) return -2; memset(nl+n->layer_cap,0,(nc-n->layer_cap)*sizeof(UXNN2Layer)); n->layers=nl; n->layer_cap=nc; }
    int in = n->layer_count==0 ? n->input_dim : n->layers[n->layer_count-1].output_dim;
    if(!layer_alloc(&n->layers[n->layer_count],in,output_dim,activation)) return -3;
    n->layer_count++;
    return n->layer_count-1;
}
int uxnn2_network_layer_count(void* net){ UXNN2Network*n=(UXNN2Network*)net; return n?n->layer_count:0; }
int uxnn2_network_input_dim(void* net){ UXNN2Network*n=(UXNN2Network*)net; return n?n->input_dim:0; }
int uxnn2_network_output_dim(void* net){ UXNN2Network*n=(UXNN2Network*)net; if(!n||n->layer_count<1) return 0; return n->layers[n->layer_count-1].output_dim; }
void uxnn2_network_init(void* net, int init_kind, double scale){ UXNN2Network*n=(UXNN2Network*)net; if(!n) return; for(int i=0;i<n->layer_count;i++) layer_init(&n->layers[i],init_kind,scale); }
void uxnn2_set_optimizer(void* net, int opt_kind, double learning_rate){ UXNN2Network*n=(UXNN2Network*)net; if(!n) return; n->opt_kind=opt_kind; if(learning_rate>0.0) n->lr=learning_rate; }
void uxnn2_set_optimizer_params(void* net, double beta1, double beta2, double epsilon, double weight_decay){ UXNN2Network*n=(UXNN2Network*)net; if(!n) return; if(beta1>0&&beta1<1) n->beta1=beta1; if(beta2>0&&beta2<1) n->beta2=beta2; if(epsilon>0) n->eps=epsilon; n->weight_decay=weight_decay; }
void uxnn2_forward_ptr(void* net, const double* input, double* output){ UXNN2Network*n=(UXNN2Network*)net; if(!n||!input||!output||n->layer_count<1) return; network_forward_internal(n,input); UXNN2Layer *last=&n->layers[n->layer_count-1]; for(int i=0;i<last->output_dim;i++) output[i]=last->a[i]; }
double uxnn2_loss_mse_ptr(void* net, const double* input, const double* target){ UXNN2Network*n=(UXNN2Network*)net; if(!n||!input||!target||n->layer_count<1) return 0.0; network_forward_internal(n,input); UXNN2Layer *last=&n->layers[n->layer_count-1]; double loss=0.0; for(int i=0;i<last->output_dim;i++){ double e=last->a[i]-target[i]; loss+=e*e; } return loss/(double)last->output_dim; }

double uxnn2_train_sample_mse_ptr(void* net, const double* input, const double* target) {
    UXNN2Network*n=(UXNN2Network*)net; if(!n||!input||!target||n->layer_count<1) return 0.0;
    n->step++; network_forward_internal(n,input);
    UXNN2Layer *last=&n->layers[n->layer_count-1];
    double loss=0.0;
    for(int j=0;j<last->output_dim;j++){ double e=last->a[j]-target[j]; loss+=e*e; last->delta[j]=(2.0/(double)last->output_dim)*e*act_derivative_from_za(last->activation,last->z[j],last->a[j]); }
    loss/=(double)last->output_dim;
    for(int li=n->layer_count-2; li>=0; li--){ UXNN2Layer *l=&n->layers[li], *nx=&n->layers[li+1]; for(int j=0;j<l->output_dim;j++){ double s=0.0; for(int k=0;k<nx->output_dim;k++) s += nx->w[(size_t)k*nx->input_dim+j]*nx->delta[k]; l->delta[j]=s*act_derivative_from_za(l->activation,l->z[j],l->a[j]); } }
    for(int li=0; li<n->layer_count; li++){
        UXNN2Layer *l=&n->layers[li]; const double *prev = li==0 ? input : n->layers[li-1].a;
        for(int o=0;o<l->output_dim;o++){
            for(int i=0;i<l->input_dim;i++){ size_t idx=(size_t)o*l->input_dim+i; double g=l->delta[o]*prev[i]; apply_update(n,&l->w[idx],g,&l->mw[idx],&l->vw[idx]); }
            apply_update(n,&l->b[o],l->delta[o],&l->mb[o],&l->vb[o]);
        }
    }
    return loss;
}
double uxnn2_train_array_mse_ptr(void* net, const double* x, const double* y, int sample_count, int epochs, int shuffle){
    UXNN2Network*n=(UXNN2Network*)net; if(!n||!x||!y||sample_count<=0||epochs<=0||n->layer_count<1) return 0.0;
    int in=n->input_dim, out=n->layers[n->layer_count-1].output_dim; double loss=0.0;
    int *order=(int*)malloc((size_t)sample_count*sizeof(int));
    if(!order) return NAN;
    for(int e=0;e<epochs;e++){
        loss=0.0;
        for(int i=0;i<sample_count;i++) order[i]=i;
        if(shuffle){
            for(int i=sample_count-1;i>0;i--){
                int j=(int)(urand01()*(i+1));
                if(j<0) j=0; if(j>i) j=i;
                int tmp=order[i]; order[i]=order[j]; order[j]=tmp;
            }
        }
        for(int si=0;si<sample_count;si++){
            int sidx=order[si];
            loss += uxnn2_train_sample_mse_ptr(net, x+(size_t)sidx*in, y+(size_t)sidx*out);
        }
        loss/=(double)sample_count;
    }
    free(order);
    return loss;
}
int uxnn2_predict_argmax_ptr(void* net, const double* input){ UXNN2Network*n=(UXNN2Network*)net; if(!n||!input||n->layer_count<1) return -1; network_forward_internal(n,input); UXNN2Layer *last=&n->layers[n->layer_count-1]; int bi=0; double bv=last->a[0]; for(int i=1;i<last->output_dim;i++){ if(last->a[i]>bv){bv=last->a[i];bi=i;} } return bi; }
double uxnn2_get_weight(void* net, int li, int o, int i){ UXNN2Network*n=(UXNN2Network*)net; if(!n||li<0||li>=n->layer_count) return 0.0; UXNN2Layer*l=&n->layers[li]; if(o<0||o>=l->output_dim||i<0||i>=l->input_dim) return 0.0; return l->w[(size_t)o*l->input_dim+i]; }
void uxnn2_set_weight(void* net, int li, int o, int i, double v){ UXNN2Network*n=(UXNN2Network*)net; if(!n||li<0||li>=n->layer_count) return; UXNN2Layer*l=&n->layers[li]; if(o<0||o>=l->output_dim||i<0||i>=l->input_dim) return; l->w[(size_t)o*l->input_dim+i]=v; }
double uxnn2_get_bias(void* net, int li, int o){ UXNN2Network*n=(UXNN2Network*)net; if(!n||li<0||li>=n->layer_count) return 0.0; UXNN2Layer*l=&n->layers[li]; if(o<0||o>=l->output_dim) return 0.0; return l->b[o]; }
void uxnn2_set_bias(void* net, int li, int o, double v){ UXNN2Network*n=(UXNN2Network*)net; if(!n||li<0||li>=n->layer_count) return; UXNN2Layer*l=&n->layers[li]; if(o<0||o>=l->output_dim) return; l->b[o]=v; }
int uxnn2_save(void* net, const char* path){ UXNN2Network*n=(UXNN2Network*)net; if(!n||!path) return 0; FILE*f=fopen(path,"wb"); if(!f) return 0; fwrite("UXN2",1,4,f); fwrite(&n->input_dim,sizeof(int),1,f); fwrite(&n->layer_count,sizeof(int),1,f); for(int li=0;li<n->layer_count;li++){ UXNN2Layer*l=&n->layers[li]; fwrite(&l->input_dim,sizeof(int),1,f); fwrite(&l->output_dim,sizeof(int),1,f); fwrite(&l->activation,sizeof(int),1,f); fwrite(l->w,sizeof(double),(size_t)l->input_dim*l->output_dim,f); fwrite(l->b,sizeof(double),l->output_dim,f);} fclose(f); return 1; }
void* uxnn2_load(const char* path){ if(!path) return NULL; FILE*f=fopen(path,"rb"); if(!f) return NULL; char magic[4]; if(fread(magic,1,4,f)!=4||memcmp(magic,"UXN2",4)!=0){fclose(f); return NULL;} int in=0, lc=0; fread(&in,sizeof(int),1,f); fread(&lc,sizeof(int),1,f); UXNN2Network*n=(UXNN2Network*)uxnn2_network_create(in); if(!n){fclose(f); return NULL;} for(int li=0;li<lc;li++){ int lin,lout,act; fread(&lin,sizeof(int),1,f); fread(&lout,sizeof(int),1,f); fread(&act,sizeof(int),1,f); uxnn2_network_add_dense(n,lout,act); UXNN2Layer*l=&n->layers[li]; fread(l->w,sizeof(double),(size_t)l->input_dim*l->output_dim,f); fread(l->b,sizeof(double),l->output_dim,f);} fclose(f); return n; }
