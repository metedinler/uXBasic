#include "uxdataset.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

#ifndef UXD_EXPORT
#ifdef _WIN32
#define UXD_EXPORT __declspec(dllexport)
#else
#define UXD_EXPORT
#endif
#endif

typedef struct UXDataset {
    int rows;
    int input_dim;
    int target_dim;
    double *x;
    double *y;
} UXDataset;

typedef struct UXScaler {
    int kind; /* 1 standard, 2 minmax */
    int input_dim;
    double *a;
    double *b;
} UXScaler;

typedef struct UXBatchLoader {
    UXDataset *ds;
    int batch_size;
    int shuffle;
    unsigned long long seed;
    int *indices;
    int pos;
    int current_rows;
    double *bx;
    double *by;
} UXBatchLoader;

static unsigned long long uxd_rng(unsigned long long *s) {
    *s = (*s * 6364136223846793005ULL) + 1442695040888963407ULL;
    return *s;
}

static int uxd_total_dim(UXDataset *d) { return d ? d->input_dim + d->target_dim : 0; }
static int uxd_good_ds(UXDataset *d) { return d && d->rows >= 0 && d->input_dim >= 0 && d->target_dim >= 0; }
static int uxd_xi(UXDataset *d, int r, int c) { return r * d->input_dim + c; }
static int uxd_yi(UXDataset *d, int r, int c) { return r * d->target_dim + c; }

UXD_EXPORT int uxdataset_version(void) { return 1; }
UXD_EXPORT const char* uxdataset_backend(void) { return "uxdataset.c/std-c"; }

UXD_EXPORT void* uxdataset_create(int rows, int input_dim, int target_dim) {
    if (rows < 0 || input_dim < 0 || target_dim < 0) return NULL;
    UXDataset *d = (UXDataset*)calloc(1, sizeof(UXDataset));
    if (!d) return NULL;
    d->rows = rows;
    d->input_dim = input_dim;
    d->target_dim = target_dim;
    if (rows * input_dim > 0) d->x = (double*)calloc((size_t)rows * (size_t)input_dim, sizeof(double));
    if (rows * target_dim > 0) d->y = (double*)calloc((size_t)rows * (size_t)target_dim, sizeof(double));
    if ((rows * input_dim > 0 && !d->x) || (rows * target_dim > 0 && !d->y)) { uxdataset_free(d); return NULL; }
    return d;
}

UXD_EXPORT void uxdataset_free(void* ds) {
    UXDataset *d = (UXDataset*)ds;
    if (!d) return;
    free(d->x); free(d->y); free(d);
}

UXD_EXPORT void* uxdataset_clone(void* ds) {
    UXDataset *d = (UXDataset*)ds;
    if (!uxd_good_ds(d)) return NULL;
    UXDataset *o = (UXDataset*)uxdataset_create(d->rows, d->input_dim, d->target_dim);
    if (!o) return NULL;
    if (d->x && o->x) memcpy(o->x, d->x, (size_t)d->rows*d->input_dim*sizeof(double));
    if (d->y && o->y) memcpy(o->y, d->y, (size_t)d->rows*d->target_dim*sizeof(double));
    return o;
}

static int count_csv_rows(FILE *f, int has_header) {
    char line[65536]; int n=0;
    rewind(f);
    if (has_header) fgets(line, sizeof(line), f);
    while (fgets(line, sizeof(line), f)) {
        char *p=line; while (*p && isspace((unsigned char)*p)) p++;
        if (*p && *p!='#') n++;
    }
    rewind(f); return n;
}

static int parse_line_doubles(char *line, double *vals, int maxvals) {
    int n=0; char *p=line; char *end=NULL;
    while (*p && n<maxvals) {
        while (*p==',' || *p==';' || *p=='\t' || isspace((unsigned char)*p)) p++;
        if (!*p || *p=='\n' || *p=='\r') break;
        vals[n]=strtod(p,&end);
        if (end==p) { vals[n]=NAN; while (*p && *p!=',' && *p!=';' && *p!='\t' && *p!='\n' && *p!='\r') p++; }
        else p=end;
        n++;
        while (*p && *p!=',' && *p!=';' && *p!='\t' && *p!='\n' && *p!='\r') p++;
    }
    return n;
}

UXD_EXPORT void* uxdataset_load_csv(const char* path, int input_dim, int target_dim, int has_header) {
    if (!path || input_dim < 0 || target_dim < 0 || input_dim + target_dim <= 0) return NULL;
    FILE *f=fopen(path,"rb"); if(!f) return NULL;
    int rows=count_csv_rows(f,has_header);
    UXDataset *d=(UXDataset*)uxdataset_create(rows,input_dim,target_dim);
    if(!d){ fclose(f); return NULL; }
    char line[65536]; int r=0; int total=input_dim+target_dim;
    double *vals=(double*)calloc((size_t)total,sizeof(double));
    if(!vals){ fclose(f); uxdataset_free(d); return NULL; }
    if(has_header) fgets(line,sizeof(line),f);
    while(r<rows && fgets(line,sizeof(line),f)) {
        char *p=line; while(*p && isspace((unsigned char)*p)) p++;
        if(!*p || *p=='#') continue;
        for(int i=0;i<total;i++) vals[i]=NAN;
        parse_line_doubles(line, vals, total);
        for(int c=0;c<input_dim;c++) d->x[uxd_xi(d,r,c)]=vals[c];
        for(int c=0;c<target_dim;c++) d->y[uxd_yi(d,r,c)]=vals[input_dim+c];
        r++;
    }
    d->rows=r;
    free(vals); fclose(f); return d;
}

UXD_EXPORT int uxdataset_save_csv(void* ds, const char* path) {
    UXDataset *d=(UXDataset*)ds; if(!uxd_good_ds(d)||!path) return 0;
    FILE *f=fopen(path,"wb"); if(!f) return 0;
    for(int r=0;r<d->rows;r++) {
        int first=1;
        for(int c=0;c<d->input_dim;c++) { if(!first) fprintf(f,","); first=0; fprintf(f,"%.17g",d->x[uxd_xi(d,r,c)]); }
        for(int c=0;c<d->target_dim;c++) { if(!first) fprintf(f,","); first=0; fprintf(f,"%.17g",d->y[uxd_yi(d,r,c)]); }
        fprintf(f,"\n");
    }
    fclose(f); return 1;
}

UXD_EXPORT int uxdataset_row_count(void* ds){ UXDataset*d=(UXDataset*)ds; return d?d->rows:0; }
UXD_EXPORT int uxdataset_input_dim(void* ds){ UXDataset*d=(UXDataset*)ds; return d?d->input_dim:0; }
UXD_EXPORT int uxdataset_target_dim(void* ds){ UXDataset*d=(UXDataset*)ds; return d?d->target_dim:0; }
UXD_EXPORT double* uxdataset_x_ptr(void* ds){ UXDataset*d=(UXDataset*)ds; return d?d->x:NULL; }
UXD_EXPORT double* uxdataset_y_ptr(void* ds){ UXDataset*d=(UXDataset*)ds; return d?d->y:NULL; }
UXD_EXPORT double uxdataset_get_x(void* ds,int r,int c){ UXDataset*d=(UXDataset*)ds; if(!d||r<0||r>=d->rows||c<0||c>=d->input_dim)return NAN; return d->x[uxd_xi(d,r,c)]; }
UXD_EXPORT void uxdataset_set_x(void* ds,int r,int c,double v){ UXDataset*d=(UXDataset*)ds; if(!d||r<0||r>=d->rows||c<0||c>=d->input_dim)return; d->x[uxd_xi(d,r,c)]=v; }
UXD_EXPORT double uxdataset_get_y(void* ds,int r,int c){ UXDataset*d=(UXDataset*)ds; if(!d||r<0||r>=d->rows||c<0||c>=d->target_dim)return NAN; return d->y[uxd_yi(d,r,c)]; }
UXD_EXPORT void uxdataset_set_y(void* ds,int r,int c,double v){ UXDataset*d=(UXDataset*)ds; if(!d||r<0||r>=d->rows||c<0||c>=d->target_dim)return; d->y[uxd_yi(d,r,c)]=v; }

static void swap_rows(UXDataset*d,int a,int b){ if(a==b)return; for(int c=0;c<d->input_dim;c++){ double t=d->x[uxd_xi(d,a,c)]; d->x[uxd_xi(d,a,c)]=d->x[uxd_xi(d,b,c)]; d->x[uxd_xi(d,b,c)]=t;} for(int c=0;c<d->target_dim;c++){ double t=d->y[uxd_yi(d,a,c)]; d->y[uxd_yi(d,a,c)]=d->y[uxd_yi(d,b,c)]; d->y[uxd_yi(d,b,c)]=t;} }
UXD_EXPORT void uxdataset_shuffle(void* ds,unsigned long long seed){ UXDataset*d=(UXDataset*)ds; if(!uxd_good_ds(d))return; if(seed==0) seed=88172645463325252ULL; for(int i=d->rows-1;i>0;i--){ int j=(int)(uxd_rng(&seed)%((unsigned long long)i+1ULL)); swap_rows(d,i,j);} }

static void* split_copy(UXDataset*d,double ratio,unsigned long long seed,int want_train){
    if(!uxd_good_ds(d))return NULL; if(ratio<0)ratio=0; if(ratio>1)ratio=1;
    int ntrain=(int)floor((double)d->rows*ratio+0.5); int n=want_train?ntrain:(d->rows-ntrain); int start=want_train?0:ntrain;
    int *idx=(int*)calloc((size_t)d->rows,sizeof(int)); if(!idx)return NULL; for(int i=0;i<d->rows;i++)idx[i]=i;
    if(seed==0)seed=1234567ULL; for(int i=d->rows-1;i>0;i--){ int j=(int)(uxd_rng(&seed)%((unsigned long long)i+1ULL)); int t=idx[i];idx[i]=idx[j];idx[j]=t; }
    UXDataset*o=(UXDataset*)uxdataset_create(n,d->input_dim,d->target_dim); if(!o){free(idx);return NULL;}
    for(int r=0;r<n;r++){ int sr=idx[start+r]; for(int c=0;c<d->input_dim;c++) o->x[uxd_xi(o,r,c)]=d->x[uxd_xi(d,sr,c)]; for(int c=0;c<d->target_dim;c++) o->y[uxd_yi(o,r,c)]=d->y[uxd_yi(d,sr,c)]; }
    free(idx); return o;
}
UXD_EXPORT void* uxdataset_split_train(void* ds,double train_ratio,unsigned long long seed){return split_copy((UXDataset*)ds,train_ratio,seed,1);} 
UXD_EXPORT void* uxdataset_split_test(void* ds,double train_ratio,unsigned long long seed){return split_copy((UXDataset*)ds,train_ratio,seed,0);} 

UXD_EXPORT void uxdataset_fill_missing_mean(void* ds){ UXDataset*d=(UXDataset*)ds; if(!uxd_good_ds(d))return; for(int c=0;c<d->input_dim;c++){ double sum=0; int n=0; for(int r=0;r<d->rows;r++){ double v=d->x[uxd_xi(d,r,c)]; if(!isnan(v)){sum+=v;n++;}} double m=n?sum/n:0; for(int r=0;r<d->rows;r++){ double*v=&d->x[uxd_xi(d,r,c)]; if(isnan(*v))*v=m; }} }

static UXScaler* scaler_fit(UXDataset*d,int kind){ if(!uxd_good_ds(d))return NULL; UXScaler*s=(UXScaler*)calloc(1,sizeof(UXScaler)); if(!s)return NULL; s->kind=kind; s->input_dim=d->input_dim; s->a=(double*)calloc((size_t)d->input_dim,sizeof(double)); s->b=(double*)calloc((size_t)d->input_dim,sizeof(double)); if(!s->a||!s->b){uxdataset_scaler_free(s);return NULL;} for(int c=0;c<d->input_dim;c++){ double mn=INFINITY,mx=-INFINITY,sum=0; int n=0; for(int r=0;r<d->rows;r++){ double v=d->x[uxd_xi(d,r,c)]; if(isnan(v))continue; if(v<mn)mn=v; if(v>mx)mx=v; sum+=v; n++; } if(n==0){s->a[c]=0;s->b[c]=1;continue;} if(kind==1){ double mean=sum/n, ss=0; for(int r=0;r<d->rows;r++){ double v=d->x[uxd_xi(d,r,c)]; if(!isnan(v))ss+=(v-mean)*(v-mean);} double sd=sqrt(ss/(n>1?n-1:1)); if(sd==0)sd=1; s->a[c]=mean; s->b[c]=sd;} else { if(mx==mn)mx=mn+1; s->a[c]=mn; s->b[c]=mx-mn;} } return s; }
UXD_EXPORT void* uxdataset_scaler_fit_standard(void* ds){return scaler_fit((UXDataset*)ds,1);} 
UXD_EXPORT void* uxdataset_scaler_fit_minmax(void* ds){return scaler_fit((UXDataset*)ds,2);} 
UXD_EXPORT void uxdataset_scaler_free(void* sc){ UXScaler*s=(UXScaler*)sc; if(!s)return; free(s->a);free(s->b);free(s);} 
UXD_EXPORT void uxdataset_scaler_transform(void* sc,void* ds){ UXScaler*s=(UXScaler*)sc; UXDataset*d=(UXDataset*)ds; if(!s||!uxd_good_ds(d))return; int m=s->input_dim<d->input_dim?s->input_dim:d->input_dim; for(int r=0;r<d->rows;r++)for(int c=0;c<m;c++){ double*v=&d->x[uxd_xi(d,r,c)]; if(!isnan(*v))*v=(*v-s->a[c])/s->b[c]; }}
UXD_EXPORT void uxdataset_scaler_inverse_transform(void* sc,void* ds){ UXScaler*s=(UXScaler*)sc; UXDataset*d=(UXDataset*)ds; if(!s||!uxd_good_ds(d))return; int m=s->input_dim<d->input_dim?s->input_dim:d->input_dim; for(int r=0;r<d->rows;r++)for(int c=0;c<m;c++){ double*v=&d->x[uxd_xi(d,r,c)]; if(!isnan(*v))*v=(*v*s->b[c])+s->a[c]; }}

UXD_EXPORT void* uxdataset_batch_create(void* ds,int batch_size,int shuffle,unsigned long long seed){ UXDataset*d=(UXDataset*)ds; if(!uxd_good_ds(d)||batch_size<1)return NULL; UXBatchLoader*l=(UXBatchLoader*)calloc(1,sizeof(UXBatchLoader)); if(!l)return NULL; l->ds=d; l->batch_size=batch_size; l->shuffle=shuffle; l->seed=seed?seed:987654321ULL; l->indices=(int*)calloc((size_t)d->rows,sizeof(int)); l->bx=(double*)calloc((size_t)batch_size*d->input_dim,sizeof(double)); l->by=(double*)calloc((size_t)batch_size*d->target_dim,sizeof(double)); if(!l->indices||!l->bx||!l->by){uxdataset_batch_free(l);return NULL;} uxdataset_batch_reset(l); return l; }
UXD_EXPORT void uxdataset_batch_free(void* loader){ UXBatchLoader*l=(UXBatchLoader*)loader; if(!l)return; free(l->indices);free(l->bx);free(l->by);free(l); }
UXD_EXPORT void uxdataset_batch_reset(void* loader){ UXBatchLoader*l=(UXBatchLoader*)loader; if(!l||!l->ds)return; for(int i=0;i<l->ds->rows;i++)l->indices[i]=i; l->pos=0; l->current_rows=0; if(l->shuffle){ unsigned long long s=l->seed; for(int i=l->ds->rows-1;i>0;i--){ int j=(int)(uxd_rng(&s)%((unsigned long long)i+1ULL)); int t=l->indices[i];l->indices[i]=l->indices[j];l->indices[j]=t; } l->seed=s; }}
UXD_EXPORT int uxdataset_batch_next(void* loader){ UXBatchLoader*l=(UXBatchLoader*)loader; if(!l||!l->ds||l->pos>=l->ds->rows)return 0; int n=l->batch_size; if(l->pos+n>l->ds->rows)n=l->ds->rows-l->pos; l->current_rows=n; for(int br=0;br<n;br++){ int sr=l->indices[l->pos+br]; for(int c=0;c<l->ds->input_dim;c++)l->bx[br*l->ds->input_dim+c]=l->ds->x[uxd_xi(l->ds,sr,c)]; for(int c=0;c<l->ds->target_dim;c++)l->by[br*l->ds->target_dim+c]=l->ds->y[uxd_yi(l->ds,sr,c)]; } l->pos+=n; return 1; }
UXD_EXPORT int uxdataset_batch_rows(void* loader){ UXBatchLoader*l=(UXBatchLoader*)loader; return l?l->current_rows:0; }
UXD_EXPORT double* uxdataset_batch_x_ptr(void* loader){ UXBatchLoader*l=(UXBatchLoader*)loader; return l?l->bx:NULL; }
UXD_EXPORT double* uxdataset_batch_y_ptr(void* loader){ UXBatchLoader*l=(UXBatchLoader*)loader; return l?l->by:NULL; }
UXD_EXPORT double uxdataset_batch_get_x(void* loader,int r,int c){ UXBatchLoader*l=(UXBatchLoader*)loader; if(!l||r<0||r>=l->current_rows||c<0||c>=l->ds->input_dim)return NAN; return l->bx[r*l->ds->input_dim+c]; }
UXD_EXPORT double uxdataset_batch_get_y(void* loader,int r,int c){ UXBatchLoader*l=(UXBatchLoader*)loader; if(!l||r<0||r>=l->current_rows||c<0||c>=l->ds->target_dim)return NAN; return l->by[r*l->ds->target_dim+c]; }
