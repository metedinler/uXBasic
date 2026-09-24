#define UXNN3_BUILD
#include "uxnn3.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>

static char g_err[512] = "";
static void set_err(const char* msg){ if(!msg) msg=""; strncpy(g_err,msg,sizeof(g_err)-1); g_err[sizeof(g_err)-1]=0; }
UXNN3_API const char* uxnn3_last_error(void){ return g_err; }
UXNN3_API int uxnn3_version(void){ return 3; }

typedef struct UXNN3Dataset {
    int rows;
    int input_dim;
    int output_dim;
    double* x;
    double* y;
    double* mean;
    double* scale;
} UXNN3Dataset;

typedef struct UXNN3Layer {
    int in_dim;
    int out_dim;
    int activation;
    double* w;
    double* b;
    double* vw;
    double* vb;
    double* z;
    double* a;
    double* delta;
} UXNN3Layer;

typedef struct UXNN3Model {
    int input_dim;
    int layer_count;
    int capacity;
    int optimizer;
    double lr;
    double momentum;
    UXNN3Layer* layers;
} UXNN3Model;

static double urand(unsigned int* s){ *s = (*s * 1664525u + 1013904223u); return ((double)((*s >> 8) & 0xFFFFFF)) / 16777216.0; }
static double act_forward(int a, double x){
    switch(a){
        case UXNN3_ACT_SIGMOID: if(x>=0){ double e=exp(-x); return 1.0/(1.0+e);} else {double e=exp(x); return e/(1.0+e);} 
        case UXNN3_ACT_TANH: return tanh(x);
        case UXNN3_ACT_RELU: return x>0?x:0;
        case UXNN3_ACT_LEAKY_RELU: return x>0?x:0.01*x;
        default: return x;
    }
}
static double act_deriv_from_output(int a, double y, double z){
    (void)z;
    switch(a){
        case UXNN3_ACT_SIGMOID: return y*(1.0-y);
        case UXNN3_ACT_TANH: return 1.0-y*y;
        case UXNN3_ACT_RELU: return z>0?1.0:0.0;
        case UXNN3_ACT_LEAKY_RELU: return z>0?1.0:0.01;
        default: return 1.0;
    }
}
static int valid_ds(UXNN3Dataset* d){ return d && d->rows>=0 && d->input_dim>0 && d->output_dim>0; }
static int valid_model(UXNN3Model* m){ return m && m->input_dim>0; }

UXNN3_API void* uxnn3_dataset_create(int rows, int input_dim, int output_dim){
    if(rows<0 || input_dim<=0 || output_dim<=0){ set_err("invalid dataset dimensions"); return NULL; }
    UXNN3Dataset* d=(UXNN3Dataset*)calloc(1,sizeof(UXNN3Dataset)); if(!d){set_err("oom dataset"); return NULL;}
    d->rows=rows; d->input_dim=input_dim; d->output_dim=output_dim;
    d->x=(double*)calloc((size_t)rows*(size_t)input_dim,sizeof(double));
    d->y=(double*)calloc((size_t)rows*(size_t)output_dim,sizeof(double));
    if((rows>0)&&(!d->x || !d->y)){ uxnn3_dataset_free(d); set_err("oom dataset arrays"); return NULL; }
    return d;
}
UXNN3_API void uxnn3_dataset_free(void* ds){ UXNN3Dataset* d=(UXNN3Dataset*)ds; if(!d)return; free(d->x); free(d->y); free(d->mean); free(d->scale); free(d); }
UXNN3_API int uxnn3_dataset_rows(void* ds){ UXNN3Dataset* d=(UXNN3Dataset*)ds; return d?d->rows:0; }
UXNN3_API int uxnn3_dataset_input_dim(void* ds){ UXNN3Dataset* d=(UXNN3Dataset*)ds; return d?d->input_dim:0; }
UXNN3_API int uxnn3_dataset_output_dim(void* ds){ UXNN3Dataset* d=(UXNN3Dataset*)ds; return d?d->output_dim:0; }
UXNN3_API double* uxnn3_dataset_x_ptr(void* ds){ UXNN3Dataset* d=(UXNN3Dataset*)ds; return d?d->x:NULL; }
UXNN3_API double* uxnn3_dataset_y_ptr(void* ds){ UXNN3Dataset* d=(UXNN3Dataset*)ds; return d?d->y:NULL; }
UXNN3_API double uxnn3_dataset_x_get(void* ds,int r,int c){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||r<0||r>=d->rows||c<0||c>=d->input_dim)return 0; return d->x[(size_t)r*d->input_dim+c]; }
UXNN3_API double uxnn3_dataset_y_get(void* ds,int r,int c){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||r<0||r>=d->rows||c<0||c>=d->output_dim)return 0; return d->y[(size_t)r*d->output_dim+c]; }
UXNN3_API int uxnn3_dataset_x_set(void* ds,int r,int c,double v){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||r<0||r>=d->rows||c<0||c>=d->input_dim)return 0; d->x[(size_t)r*d->input_dim+c]=v; return 1; }
UXNN3_API int uxnn3_dataset_y_set(void* ds,int r,int c,double v){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||r<0||r>=d->rows||c<0||c>=d->output_dim)return 0; d->y[(size_t)r*d->output_dim+c]=v; return 1; }

static int count_csv_rows(FILE* f, int has_header){ char line[8192]; int rows=0; rewind(f); if(has_header) fgets(line,sizeof(line),f); while(fgets(line,sizeof(line),f)){ if(strlen(line)>1) rows++; } rewind(f); return rows; }
UXNN3_API void* uxnn3_dataset_load_csv(const char* path, int input_dim, int output_dim, int has_header){
    if(!path||input_dim<=0||output_dim<=0){set_err("invalid csv args"); return NULL;}
    FILE* f=fopen(path,"r"); if(!f){set_err("cannot open csv"); return NULL;}
    int rows=count_csv_rows(f,has_header); UXNN3Dataset*d=(UXNN3Dataset*)uxnn3_dataset_create(rows,input_dim,output_dim); if(!d){fclose(f); return NULL;}
    char line[8192]; if(has_header) fgets(line,sizeof(line),f); int r=0; int total=input_dim+output_dim;
    while(r<rows && fgets(line,sizeof(line),f)){
        char* ctx=NULL; char* tok=strtok(line,","); int col=0;
        while(tok && col<total){ double v=strtod(tok,NULL); if(col<input_dim)d->x[(size_t)r*input_dim+col]=v; else d->y[(size_t)r*output_dim+(col-input_dim)]=v; tok=strtok(NULL,","); col++; }
        if(col>=total) r++;
    }
    d->rows=r; fclose(f); return d;
}
UXNN3_API int uxnn3_dataset_save_csv(void* ds,const char* path,int header){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||!path)return 0; FILE*f=fopen(path,"w"); if(!f)return 0; if(header){ for(int i=0;i<d->input_dim;i++)fprintf(f,"x%d,",i); for(int j=0;j<d->output_dim;j++)fprintf(f,"y%d%s",j,j==d->output_dim-1?"\n":","); } for(int r=0;r<d->rows;r++){ for(int i=0;i<d->input_dim;i++)fprintf(f,"%.17g,",d->x[(size_t)r*d->input_dim+i]); for(int j=0;j<d->output_dim;j++)fprintf(f,"%.17g%s",d->y[(size_t)r*d->output_dim+j],j==d->output_dim-1?"\n":","); } fclose(f); return 1; }

UXNN3_API int uxnn3_dataset_shuffle(void* ds,unsigned int seed){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d))return 0; for(int i=d->rows-1;i>0;i--){ int j=(int)(urand(&seed)*(i+1)); if(j<0)j=0;if(j>i)j=i; for(int c=0;c<d->input_dim;c++){ double t=d->x[(size_t)i*d->input_dim+c]; d->x[(size_t)i*d->input_dim+c]=d->x[(size_t)j*d->input_dim+c]; d->x[(size_t)j*d->input_dim+c]=t; } for(int c=0;c<d->output_dim;c++){ double t=d->y[(size_t)i*d->output_dim+c]; d->y[(size_t)i*d->output_dim+c]=d->y[(size_t)j*d->output_dim+c]; d->y[(size_t)j*d->output_dim+c]=t; }} return 1; }
static UXNN3Dataset* split_copy(UXNN3Dataset*d,double ratio,unsigned int seed,int train){ if(!valid_ds(d))return NULL; UXNN3Dataset* tmp=(UXNN3Dataset*)uxnn3_dataset_create(d->rows,d->input_dim,d->output_dim); if(!tmp)return NULL; memcpy(tmp->x,d->x,(size_t)d->rows*d->input_dim*sizeof(double)); memcpy(tmp->y,d->y,(size_t)d->rows*d->output_dim*sizeof(double)); uxnn3_dataset_shuffle(tmp,seed); int ntr=(int)floor(d->rows*ratio+0.5); if(ntr<0)ntr=0;if(ntr>d->rows)ntr=d->rows; int start=train?0:ntr; int n=train?ntr:(d->rows-ntr); UXNN3Dataset*out=(UXNN3Dataset*)uxnn3_dataset_create(n,d->input_dim,d->output_dim); if(!out){uxnn3_dataset_free(tmp);return NULL;} memcpy(out->x,tmp->x+(size_t)start*d->input_dim,(size_t)n*d->input_dim*sizeof(double)); memcpy(out->y,tmp->y+(size_t)start*d->output_dim,(size_t)n*d->output_dim*sizeof(double)); uxnn3_dataset_free(tmp); return out; }
UXNN3_API void* uxnn3_dataset_split_train(void* ds,double r,unsigned int seed){ return split_copy((UXNN3Dataset*)ds,r,seed,1); }
UXNN3_API void* uxnn3_dataset_split_test(void* ds,double r,unsigned int seed){ return split_copy((UXNN3Dataset*)ds,r,seed,0); }
UXNN3_API int uxnn3_dataset_standardize_fit_transform(void* ds){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||d->rows<1)return 0; free(d->mean); free(d->scale); d->mean=(double*)calloc(d->input_dim,sizeof(double)); d->scale=(double*)calloc(d->input_dim,sizeof(double)); if(!d->mean||!d->scale)return 0; for(int c=0;c<d->input_dim;c++){ for(int r=0;r<d->rows;r++)d->mean[c]+=d->x[(size_t)r*d->input_dim+c]; d->mean[c]/=d->rows; for(int r=0;r<d->rows;r++){double e=d->x[(size_t)r*d->input_dim+c]-d->mean[c]; d->scale[c]+=e*e;} d->scale[c]=sqrt(d->scale[c]/(d->rows>1?d->rows-1:1)); if(d->scale[c]<1e-12)d->scale[c]=1.0; for(int r=0;r<d->rows;r++)d->x[(size_t)r*d->input_dim+c]=(d->x[(size_t)r*d->input_dim+c]-d->mean[c])/d->scale[c]; } return 1; }
UXNN3_API int uxnn3_dataset_minmax_fit_transform(void* ds,double a,double b){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d)||d->rows<1)return 0; for(int c=0;c<d->input_dim;c++){ double mn=d->x[c],mx=d->x[c]; for(int r=1;r<d->rows;r++){double v=d->x[(size_t)r*d->input_dim+c]; if(v<mn)mn=v;if(v>mx)mx=v;} double den=mx-mn; if(fabs(den)<1e-12)den=1.0; for(int r=0;r<d->rows;r++){double v=d->x[(size_t)r*d->input_dim+c]; d->x[(size_t)r*d->input_dim+c]=a+(v-mn)*(b-a)/den;} } return 1; }

static void layer_free(UXNN3Layer*l){ if(!l)return; free(l->w);free(l->b);free(l->vw);free(l->vb);free(l->z);free(l->a);free(l->delta); memset(l,0,sizeof(*l)); }
UXNN3_API void* uxnn3_model_create(int input_dim){ if(input_dim<=0)return NULL; UXNN3Model*m=(UXNN3Model*)calloc(1,sizeof(UXNN3Model)); if(!m)return NULL; m->input_dim=input_dim; m->capacity=4; m->layers=(UXNN3Layer*)calloc(m->capacity,sizeof(UXNN3Layer)); m->optimizer=UXNN3_OPT_SGD; m->lr=0.01; m->momentum=0.9; return m; }
UXNN3_API void uxnn3_model_free(void* model){ UXNN3Model*m=(UXNN3Model*)model; if(!m)return; for(int i=0;i<m->layer_count;i++)layer_free(&m->layers[i]); free(m->layers); free(m); }
UXNN3_API int uxnn3_model_add_dense(void* model,int out_dim,int activation){ UXNN3Model*m=(UXNN3Model*)model; if(!valid_model(m)||out_dim<=0)return 0; if(m->layer_count>=m->capacity){m->capacity*=2; UXNN3Layer*nl=(UXNN3Layer*)realloc(m->layers,m->capacity*sizeof(UXNN3Layer)); if(!nl)return 0; m->layers=nl; memset(m->layers+m->layer_count,0,(m->capacity-m->layer_count)*sizeof(UXNN3Layer));} int in=(m->layer_count==0)?m->input_dim:m->layers[m->layer_count-1].out_dim; UXNN3Layer*l=&m->layers[m->layer_count++]; l->in_dim=in; l->out_dim=out_dim; l->activation=activation; size_t wcnt=(size_t)in*out_dim; l->w=(double*)calloc(wcnt,sizeof(double)); l->b=(double*)calloc(out_dim,sizeof(double)); l->vw=(double*)calloc(wcnt,sizeof(double)); l->vb=(double*)calloc(out_dim,sizeof(double)); l->z=(double*)calloc(out_dim,sizeof(double)); l->a=(double*)calloc(out_dim,sizeof(double)); l->delta=(double*)calloc(out_dim,sizeof(double)); return l->w&&l->b&&l->vw&&l->vb&&l->z&&l->a&&l->delta; }
UXNN3_API int uxnn3_model_init(void* model,unsigned int seed,double scale){ UXNN3Model*m=(UXNN3Model*)model; if(!valid_model(m))return 0; for(int li=0;li<m->layer_count;li++){ UXNN3Layer*l=&m->layers[li]; double sc=scale>0?scale:sqrt(2.0/(l->in_dim+l->out_dim)); for(int j=0;j<l->out_dim;j++){ l->b[j]=0; for(int i=0;i<l->in_dim;i++)l->w[(size_t)j*l->in_dim+i]=(urand(&seed)*2.0-1.0)*sc; }} return 1; }
UXNN3_API int uxnn3_model_set_optimizer(void* model,int opt,double lr,double mom){ UXNN3Model*m=(UXNN3Model*)model; if(!valid_model(m))return 0; m->optimizer=opt; m->lr=lr>0?lr:0.01; m->momentum=mom; return 1; }
UXNN3_API int uxnn3_model_layer_count(void* model){ UXNN3Model*m=(UXNN3Model*)model; return m?m->layer_count:0; }
UXNN3_API int uxnn3_model_output_dim(void* model){ UXNN3Model*m=(UXNN3Model*)model; return (!m||m->layer_count<1)?0:m->layers[m->layer_count-1].out_dim; }
static double* forward_internal(UXNN3Model*m,const double*x){ const double* inp=x; for(int li=0;li<m->layer_count;li++){ UXNN3Layer*l=&m->layers[li]; for(int j=0;j<l->out_dim;j++){ double z=l->b[j]; for(int i=0;i<l->in_dim;i++) z+=l->w[(size_t)j*l->in_dim+i]*inp[i]; l->z[j]=z; l->a[j]=act_forward(l->activation,z); } inp=l->a; } return m->layer_count?m->layers[m->layer_count-1].a:NULL; }
UXNN3_API double uxnn3_model_forward1(void* model,const double*x,double*out){ UXNN3Model*m=(UXNN3Model*)model; if(!valid_model(m)||m->layer_count<1||!x)return 0; double*y=forward_internal(m,x); int od=uxnn3_model_output_dim(m); double s=0; for(int i=0;i<od;i++){ if(out)out[i]=y[i]; s+=y[i]; } return s; }
UXNN3_API double uxnn3_model_predict_dataset(void* model,void* ds,int row,double*out){ UXNN3Model*m=(UXNN3Model*)model; UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_model(m)||!valid_ds(d)||row<0||row>=d->rows)return 0; return uxnn3_model_forward1(model,d->x+(size_t)row*d->input_dim,out); }
UXNN3_API int uxnn3_model_predict_argmax(void* model,void* ds,int row){ UXNN3Model*m=(UXNN3Model*)model; if(!m)return -1; int od=uxnn3_model_output_dim(m); double*buf=(double*)calloc(od,sizeof(double)); if(!buf)return -1; uxnn3_model_predict_dataset(model,ds,row,buf); int idx=0; for(int i=1;i<od;i++)if(buf[i]>buf[idx])idx=i; free(buf); return idx; }
static double train_one(UXNN3Model*m,const double*x,const double*t){ double*y=forward_internal(m,x); int L=m->layer_count; UXNN3Layer*out=&m->layers[L-1]; double loss=0; for(int j=0;j<out->out_dim;j++){ double e=y[j]-t[j]; loss+=e*e; out->delta[j]=e*act_deriv_from_output(out->activation,out->a[j],out->z[j]); } for(int li=L-2;li>=0;li--){ UXNN3Layer*l=&m->layers[li]; UXNN3Layer*n=&m->layers[li+1]; for(int i=0;i<l->out_dim;i++){ double sum=0; for(int j=0;j<n->out_dim;j++) sum+=n->w[(size_t)j*n->in_dim+i]*n->delta[j]; l->delta[i]=sum*act_deriv_from_output(l->activation,l->a[i],l->z[i]); }} for(int li=0;li<L;li++){ UXNN3Layer*l=&m->layers[li]; const double*inp=(li==0)?x:m->layers[li-1].a; for(int j=0;j<l->out_dim;j++){ for(int i=0;i<l->in_dim;i++){ size_t wi=(size_t)j*l->in_dim+i; double grad=l->delta[j]*inp[i]; if(m->optimizer==UXNN3_OPT_MOMENTUM){ l->vw[wi]=m->momentum*l->vw[wi]-m->lr*grad; l->w[wi]+=l->vw[wi]; } else l->w[wi]-=m->lr*grad; } double gb=l->delta[j]; if(m->optimizer==UXNN3_OPT_MOMENTUM){ l->vb[j]=m->momentum*l->vb[j]-m->lr*gb; l->b[j]+=l->vb[j]; } else l->b[j]-=m->lr*gb; }} return loss/out->out_dim; }
UXNN3_API double uxnn3_model_train_dataset(void* model,void* ds,int epochs,int batch_size,int shuffle,unsigned int seed){ (void)batch_size; UXNN3Model*m=(UXNN3Model*)model; UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_model(m)||!valid_ds(d)||m->layer_count<1)return -1; double loss=0; for(int ep=0;ep<epochs;ep++){ if(shuffle)uxnn3_dataset_shuffle(d,seed+ep); loss=0; for(int r=0;r<d->rows;r++)loss+=train_one(m,d->x+(size_t)r*d->input_dim,d->y+(size_t)r*d->output_dim); loss/=d->rows?d->rows:1; } return loss; }
UXNN3_API double uxnn3_model_eval_mse(void* model,void* ds){ UXNN3Model*m=(UXNN3Model*)model; UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_model(m)||!valid_ds(d)||m->layer_count<1)return -1; int od=uxnn3_model_output_dim(m); double*buf=(double*)calloc(od,sizeof(double)); double loss=0; for(int r=0;r<d->rows;r++){ uxnn3_model_predict_dataset(model,ds,r,buf); for(int j=0;j<od&&j<d->output_dim;j++){ double e=buf[j]-d->y[(size_t)r*d->output_dim+j]; loss+=e*e; }} free(buf); return loss/(d->rows*od); }
UXNN3_API double uxnn3_model_eval_binary_accuracy(void* model,void* ds,double th){ UXNN3Dataset*d=(UXNN3Dataset*)ds; if(!valid_ds(d))return 0; int ok=0; double out[8]; for(int r=0;r<d->rows;r++){ uxnn3_model_predict_dataset(model,ds,r,out); int pred=out[0]>=th; int truth=d->y[(size_t)r*d->output_dim]>=th; if(pred==truth)ok++; } return d->rows?((double)ok/d->rows):0; }
UXNN3_API int uxnn3_model_save(void* model,const char* path){ UXNN3Model*m=(UXNN3Model*)model; if(!valid_model(m)||!path)return 0; FILE*f=fopen(path,"wb"); if(!f)return 0; fwrite("UXN3",1,4,f); fwrite(&m->input_dim,sizeof(int),1,f); fwrite(&m->layer_count,sizeof(int),1,f); for(int li=0;li<m->layer_count;li++){ UXNN3Layer*l=&m->layers[li]; fwrite(&l->in_dim,sizeof(int),1,f); fwrite(&l->out_dim,sizeof(int),1,f); fwrite(&l->activation,sizeof(int),1,f); fwrite(l->w,sizeof(double),(size_t)l->in_dim*l->out_dim,f); fwrite(l->b,sizeof(double),l->out_dim,f);} fclose(f); return 1; }
UXNN3_API void* uxnn3_model_load(const char* path){ if(!path)return NULL; FILE*f=fopen(path,"rb"); if(!f)return NULL; char magic[4]; if(fread(magic,1,4,f)!=4||memcmp(magic,"UXN3",4)){fclose(f);return NULL;} int in,lcnt; fread(&in,sizeof(int),1,f); fread(&lcnt,sizeof(int),1,f); UXNN3Model*m=(UXNN3Model*)uxnn3_model_create(in); if(!m){fclose(f);return NULL;} for(int li=0;li<lcnt;li++){ int ind,outd,act; fread(&ind,sizeof(int),1,f); fread(&outd,sizeof(int),1,f); fread(&act,sizeof(int),1,f); uxnn3_model_add_dense(m,outd,act); UXNN3Layer*l=&m->layers[li]; fread(l->w,sizeof(double),(size_t)l->in_dim*l->out_dim,f); fread(l->b,sizeof(double),l->out_dim,f); } fclose(f); return m; }
