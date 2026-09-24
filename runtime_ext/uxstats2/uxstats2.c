/*
  uXBasic Advanced Statistics Runtime DLL - uxstats2
  Backend: ISO C + math.h. No Python, no new uXBasic keyword.
  ABI: CDECL, handle-backed vector API.

  Notes:
  - p-values use numeric approximations implemented here: normal, t, F, chi-square.
  - ADF p-value is approximate and not MacKinnon critical-value exact.
  - BIG models such as full MANOVA are represented here by Hotelling T2 2D two-group test.
*/
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <float.h>

#if defined(_WIN32)
#define UXSTATS2_EXPORT __declspec(dllexport)
#else
#define UXSTATS2_EXPORT
#endif

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#define UX2_MAX_GROUPS 128
#define UX2_EPS 1e-12

typedef struct UXStats2Vec { int32_t count; int32_t capacity; double *data; } UXStats2Vec;
static int valid_vec(const UXStats2Vec *v){ return v && v->count>=0 && v->capacity>=0 && v->count<=v->capacity; }
static int ensure_cap(UXStats2Vec *v,int32_t need){ if(!v) return 0; if(need<=v->capacity) return 1; int32_t nc=v->capacity>0?v->capacity:8; while(nc<need){ if(nc>1073741823) return 0; nc*=2; } double *p=(double*)realloc(v->data,(size_t)nc*sizeof(double)); if(!p) return 0; v->data=p; v->capacity=nc; return 1; }
static int min_count(const UXStats2Vec *a,const UXStats2Vec *b){ if(!valid_vec(a)||!valid_vec(b)) return 0; return a->count<b->count?a->count:b->count; }
static double sqr(double x){return x*x;}
static double clamp01(double x){ if(isnan(x)) return NAN; if(x<0) return 0; if(x>1) return 1; return x; }

UXSTATS2_EXPORT int uxstats2_version(void){ return 2; }
UXSTATS2_EXPORT void* uxstats2_vec_create(int32_t capacity){ if(capacity<0) capacity=0; UXStats2Vec *v=(UXStats2Vec*)calloc(1,sizeof(UXStats2Vec)); if(!v) return NULL; if(capacity>0 && !ensure_cap(v,capacity)){free(v); return NULL;} return v; }
UXSTATS2_EXPORT void uxstats2_vec_free(void *h){ UXStats2Vec *v=(UXStats2Vec*)h; if(!v) return; free(v->data); free(v); }
UXSTATS2_EXPORT int32_t uxstats2_vec_push(void *h,double value){ UXStats2Vec *v=(UXStats2Vec*)h; if(!valid_vec(v)) return 0; if(!ensure_cap(v,v->count+1)) return 0; v->data[v->count++]=value; return 1; }
UXSTATS2_EXPORT int32_t uxstats2_vec_set(void *h,int32_t index,double value){ UXStats2Vec *v=(UXStats2Vec*)h; if(!valid_vec(v)||index<0||index>=v->count) return 0; v->data[index]=value; return 1; }
UXSTATS2_EXPORT double uxstats2_vec_get(void *h,int32_t index){ UXStats2Vec *v=(UXStats2Vec*)h; if(!valid_vec(v)||index<0||index>=v->count) return NAN; return v->data[index]; }
UXSTATS2_EXPORT int32_t uxstats2_vec_count(void *h){ UXStats2Vec *v=(UXStats2Vec*)h; if(!valid_vec(v)) return 0; return v->count; }

static double sum_n(const double*x,int n){ if(!x||n<=0) return NAN; double s=0; for(int i=0;i<n;i++) s+=x[i]; return s; }
static double mean_n(const double*x,int n){ if(!x||n<=0) return NAN; return sum_n(x,n)/(double)n; }
static double var_samp_n(const double*x,int n){ if(!x||n<=1) return NAN; double m=mean_n(x,n),ss=0; for(int i=0;i<n;i++) ss+=sqr(x[i]-m); return ss/(double)(n-1); }
static double var_pop_n(const double*x,int n){ if(!x||n<=0) return NAN; double m=mean_n(x,n),ss=0; for(int i=0;i<n;i++) ss+=sqr(x[i]-m); return ss/(double)n; }
static double sd_samp_n(const double*x,int n){ double v=var_samp_n(x,n); return isnan(v)?NAN:sqrt(v); }
static double cov_samp_n(const double*x,const double*y,int n){ if(!x||!y||n<=1) return NAN; double mx=mean_n(x,n),my=mean_n(y,n),s=0; for(int i=0;i<n;i++) s+=(x[i]-mx)*(y[i]-my); return s/(double)(n-1); }
static double corr_n(const double*x,const double*y,int n){ double c=cov_samp_n(x,y,n),sx=sd_samp_n(x,n),sy=sd_samp_n(y,n); if(isnan(c)||sx<=0||sy<=0) return NAN; return c/(sx*sy); }
UXSTATS2_EXPORT double uxstats2_covariance_samp(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); if(n<=1) return NAN; return cov_samp_n(x->data,y->data,n); }
UXSTATS2_EXPORT double uxstats2_correlation(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); if(n<=1) return NAN; return corr_n(x->data,y->data,n); }

/* Probability functions: incomplete gamma/beta, normal/t/F/chi-square */
UXSTATS2_EXPORT double uxstats2_normal_cdf(double z){ return 0.5*erfc(-z/sqrt(2.0)); }
UXSTATS2_EXPORT double uxstats2_normal_p2(double z){ return clamp01(2.0*(1.0-uxstats2_normal_cdf(fabs(z)))); }
static double betacf(double a,double b,double x){ const int MAXIT=200; const double EPS=3e-14,FPMIN=1e-300; double qab=a+b,qap=a+1,qam=a-1,c=1,d=1-qab*x/qap; if(fabs(d)<FPMIN)d=FPMIN; d=1/d; double h=d; for(int m=1;m<=MAXIT;m++){ int m2=2*m; double aa=m*(b-m)*x/((qam+m2)*(a+m2)); d=1+aa*d; if(fabs(d)<FPMIN)d=FPMIN; c=1+aa/c; if(fabs(c)<FPMIN)c=FPMIN; d=1/d; h*=d*c; aa=-(a+m)*(qab+m)*x/((a+m2)*(qap+m2)); d=1+aa*d; if(fabs(d)<FPMIN)d=FPMIN; c=1+aa/c; if(fabs(c)<FPMIN)c=FPMIN; d=1/d; double del=d*c; h*=del; if(fabs(del-1)<EPS) break; } return h; }
static double ibeta(double a,double b,double x){ if(a<=0||b<=0) return NAN; if(x<=0) return 0; if(x>=1) return 1; double bt=exp(lgamma(a+b)-lgamma(a)-lgamma(b)+a*log(x)+b*log(1-x)); if(x<(a+1)/(a+b+2)) return bt*betacf(a,b,x)/a; else return 1-bt*betacf(b,a,1-x)/b; }
static double gammp_series(double a,double x){ const int ITMAX=200; const double EPS=3e-14; double gln=lgamma(a); if(x<=0) return 0; double ap=a,del=1/a,sum=del; for(int n=1;n<=ITMAX;n++){ ap++; del*=x/ap; sum+=del; if(fabs(del)<fabs(sum)*EPS) break; } return sum*exp(-x+a*log(x)-gln); }
static double gammq_cf(double a,double x){ const int ITMAX=200; const double EPS=3e-14,FPMIN=1e-300; double gln=lgamma(a),b=x+1-a,c=1/FPMIN,d=1/b,h=d; for(int i=1;i<=ITMAX;i++){ double an=-i*(i-a); b+=2; d=an*d+b; if(fabs(d)<FPMIN)d=FPMIN; c=b+an/c; if(fabs(c)<FPMIN)c=FPMIN; d=1/d; double del=d*c; h*=del; if(fabs(del-1)<EPS) break; } return exp(-x+a*log(x)-gln)*h; }
static double gammp(double a,double x){ if(a<=0||x<0) return NAN; if(x<a+1) return gammp_series(a,x); return 1-gammq_cf(a,x); }
static double gammq(double a,double x){ if(a<=0||x<0) return NAN; if(x<a+1) return 1-gammp_series(a,x); return gammq_cf(a,x); }
static double t_cdf(double t,double df){ if(df<=0) return NAN; double x=df/(df+t*t); double ib=ibeta(df/2.0,0.5,x); if(t>=0) return 1-0.5*ib; return 0.5*ib; }
UXSTATS2_EXPORT double uxstats2_t_p2(double t,double df){ return clamp01(2.0*(1.0-t_cdf(fabs(t),df))); }
UXSTATS2_EXPORT double uxstats2_chisq_p(double stat,double df){ if(stat<0||df<=0) return NAN; return clamp01(gammq(df/2.0,stat/2.0)); }
UXSTATS2_EXPORT double uxstats2_f_p(double f,double df1,double df2){ if(f<0||df1<=0||df2<=0) return NAN; if(isinf(f)) return 0.0; double x=(df1*f)/(df1*f+df2); return clamp01(1.0-ibeta(df1/2.0,df2/2.0,x)); }

/* t tests */
UXSTATS2_EXPORT double uxstats2_one_sample_t_stat(void*h,double mu0){ UXStats2Vec*x=(UXStats2Vec*)h; if(!valid_vec(x)||x->count<=1) return NAN; double m=mean_n(x->data,x->count),s=sd_samp_n(x->data,x->count); if(s<=0) return NAN; return (m-mu0)/(s/sqrt((double)x->count)); }
UXSTATS2_EXPORT double uxstats2_one_sample_t_p(void*h,double mu0){ UXStats2Vec*x=(UXStats2Vec*)h; double t=uxstats2_one_sample_t_stat(h,mu0); if(!valid_vec(x)||isnan(t)) return NAN; return uxstats2_t_p2(t,(double)(x->count-1)); }
static double welch_df(const UXStats2Vec*x,const UXStats2Vec*y){ double vx=var_samp_n(x->data,x->count),vy=var_samp_n(y->data,y->count),a=vx/x->count,b=vy/y->count; return sqr(a+b)/(sqr(a)/(x->count-1)+sqr(b)/(y->count-1)); }
UXSTATS2_EXPORT double uxstats2_welch_t_stat(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; if(!valid_vec(x)||!valid_vec(y)||x->count<=1||y->count<=1) return NAN; double vx=var_samp_n(x->data,x->count),vy=var_samp_n(y->data,y->count),se=sqrt(vx/x->count+vy/y->count); if(se<=0) return NAN; return (mean_n(x->data,x->count)-mean_n(y->data,y->count))/se; }
UXSTATS2_EXPORT double uxstats2_welch_t_p(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; double t=uxstats2_welch_t_stat(xh,yh); if(isnan(t)) return NAN; return uxstats2_t_p2(t,welch_df(x,y)); }
UXSTATS2_EXPORT double uxstats2_pooled_t_stat(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; if(!valid_vec(x)||!valid_vec(y)||x->count<=1||y->count<=1) return NAN; double vx=var_samp_n(x->data,x->count),vy=var_samp_n(y->data,y->count); double sp=sqrt(((x->count-1)*vx+(y->count-1)*vy)/(double)(x->count+y->count-2)); double se=sp*sqrt(1.0/x->count+1.0/y->count); if(se<=0) return NAN; return (mean_n(x->data,x->count)-mean_n(y->data,y->count))/se; }
UXSTATS2_EXPORT double uxstats2_pooled_t_p(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; double t=uxstats2_pooled_t_stat(xh,yh); if(isnan(t)) return NAN; return uxstats2_t_p2(t,(double)(x->count+y->count-2)); }
UXSTATS2_EXPORT double uxstats2_paired_t_stat(void*bh,void*ah){ UXStats2Vec*b=(UXStats2Vec*)bh,*a=(UXStats2Vec*)ah; int n=min_count(b,a); if(n<=1) return NAN; double *d=(double*)malloc((size_t)n*sizeof(double)); if(!d) return NAN; for(int i=0;i<n;i++) d[i]=a->data[i]-b->data[i]; double m=mean_n(d,n),s=sd_samp_n(d,n); free(d); if(s<=0) return NAN; return m/(s/sqrt((double)n)); }
UXSTATS2_EXPORT double uxstats2_paired_t_p(void*bh,void*ah){ int n=min_count((UXStats2Vec*)bh,(UXStats2Vec*)ah); double t=uxstats2_paired_t_stat(bh,ah); if(isnan(t)||n<=1) return NAN; return uxstats2_t_p2(t,(double)(n-1)); }

/* z tests */
UXSTATS2_EXPORT double uxstats2_one_sample_z_stat(void*h,double mu0,double sigma){ UXStats2Vec*x=(UXStats2Vec*)h; if(!valid_vec(x)||x->count<=0||sigma<=0) return NAN; return (mean_n(x->data,x->count)-mu0)/(sigma/sqrt((double)x->count)); }
UXSTATS2_EXPORT double uxstats2_one_sample_z_p(void*h,double mu0,double sigma){ return uxstats2_normal_p2(uxstats2_one_sample_z_stat(h,mu0,sigma)); }
UXSTATS2_EXPORT double uxstats2_two_sample_z_stat(void*xh,void*yh,double sx,double sy){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; if(!valid_vec(x)||!valid_vec(y)||x->count<=0||y->count<=0||sx<=0||sy<=0) return NAN; double se=sqrt(sx*sx/x->count+sy*sy/y->count); return (mean_n(x->data,x->count)-mean_n(y->data,y->count))/se; }
UXSTATS2_EXPORT double uxstats2_two_sample_z_p(void*xh,void*yh,double sx,double sy){ return uxstats2_normal_p2(uxstats2_two_sample_z_stat(xh,yh,sx,sy)); }
UXSTATS2_EXPORT double uxstats2_one_prop_z_stat(int32_t succ,int32_t n,double p0){ if(n<=0||p0<=0||p0>=1) return NAN; double ph=(double)succ/n; return (ph-p0)/sqrt(p0*(1-p0)/n); }
UXSTATS2_EXPORT double uxstats2_one_prop_z_p(int32_t succ,int32_t n,double p0){ return uxstats2_normal_p2(uxstats2_one_prop_z_stat(succ,n,p0)); }
UXSTATS2_EXPORT double uxstats2_two_prop_z_stat(int32_t s1,int32_t n1,int32_t s2,int32_t n2){ if(n1<=0||n2<=0) return NAN; double p1=(double)s1/n1,p2=(double)s2/n2,p=(double)(s1+s2)/(n1+n2); double se=sqrt(p*(1-p)*(1.0/n1+1.0/n2)); if(se<=0) return NAN; return (p1-p2)/se; }
UXSTATS2_EXPORT double uxstats2_two_prop_z_p(int32_t s1,int32_t n1,int32_t s2,int32_t n2){ return uxstats2_normal_p2(uxstats2_two_prop_z_stat(s1,n1,s2,n2)); }

/* F, chi-square */
UXSTATS2_EXPORT double uxstats2_f_variance_stat(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; if(!valid_vec(x)||!valid_vec(y)||x->count<=1||y->count<=1) return NAN; double vx=var_samp_n(x->data,x->count),vy=var_samp_n(y->data,y->count); if(vy<=0) return NAN; return vx/vy; }
UXSTATS2_EXPORT double uxstats2_f_variance_p(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; double f=uxstats2_f_variance_stat(xh,yh); if(isnan(f)) return NAN; double p=uxstats2_f_p(f,x->count-1,y->count-1); return clamp01(2.0*(p<0.5?p:1.0-p)); }
UXSTATS2_EXPORT double uxstats2_chisq_gof_stat(void*oh,void*eh){ UXStats2Vec*o=(UXStats2Vec*)oh,*e=(UXStats2Vec*)eh; int n=min_count(o,e); if(n<=0) return NAN; double s=0; for(int i=0;i<n;i++){ if(e->data[i]<=0) return NAN; s+=sqr(o->data[i]-e->data[i])/e->data[i]; } return s; }
UXSTATS2_EXPORT double uxstats2_chisq_gof_p(void*oh,void*eh){ int n=min_count((UXStats2Vec*)oh,(UXStats2Vec*)eh); double s=uxstats2_chisq_gof_stat(oh,eh); if(isnan(s)||n<=1) return NAN; return uxstats2_chisq_p(s,(double)(n-1)); }
UXSTATS2_EXPORT double uxstats2_chisq_2x2_stat(double a,double b,double c,double d){ double n=a+b+c+d; double r1=a+b,r2=c+d,c1=a+c,c2=b+d; double den=r1*r2*c1*c2; if(n<=0||den<=0) return NAN; return n*sqr(a*d-b*c)/den; }
UXSTATS2_EXPORT double uxstats2_chisq_2x2_p(double a,double b,double c,double d){ double s=uxstats2_chisq_2x2_stat(a,b,c,d); if(isnan(s)) return NAN; return uxstats2_chisq_p(s,1.0); }

/* grouping helpers */
typedef struct GStat { double code; int n; double sum; double mean; double ss; } GStat;
static int find_group(GStat*g,int k,double code){ for(int i=0;i<k;i++) if(fabs(g[i].code-code)<1e-9) return i; return -1; }
static int group_stats(const UXStats2Vec*v,const UXStats2Vec*gr,GStat*g,int*kp){ if(!valid_vec(v)||!valid_vec(gr)||v->count!=gr->count||v->count<=1) return 0; int k=0; for(int i=0;i<v->count;i++){ int j=find_group(g,k,gr->data[i]); if(j<0){ if(k>=UX2_MAX_GROUPS) return 0; j=k++; g[j].code=gr->data[i]; g[j].n=0; g[j].sum=0; g[j].mean=0; g[j].ss=0;} g[j].n++; g[j].sum+=v->data[i]; } for(int j=0;j<k;j++){ if(g[j].n<=0) return 0; g[j].mean=g[j].sum/g[j].n; } for(int i=0;i<v->count;i++){ int j=find_group(g,k,gr->data[i]); g[j].ss+=sqr(v->data[i]-g[j].mean); } *kp=k; return k>=2; }
static double anova_parts(const UXStats2Vec*v,const UXStats2Vec*gr,double*dfb,double*dfw,double*mse){ GStat g[UX2_MAX_GROUPS]; int k=0; if(!group_stats(v,gr,g,&k)) return NAN; double grand=mean_n(v->data,v->count),ssb=0,ssw=0; for(int j=0;j<k;j++){ ssb+=g[j].n*sqr(g[j].mean-grand); ssw+=g[j].ss; } *dfb=k-1; *dfw=v->count-k; if(*dfw<=0) return NAN; *mse=ssw/(*dfw); return (ssb/(*dfb))/(*mse); }
UXSTATS2_EXPORT double uxstats2_anova_oneway_f(void*vh,void*gh){ UXStats2Vec*v=(UXStats2Vec*)vh,*gr=(UXStats2Vec*)gh; double dfb,dfw,mse; return anova_parts(v,gr,&dfb,&dfw,&mse); }
UXSTATS2_EXPORT double uxstats2_anova_oneway_p(void*vh,void*gh){ UXStats2Vec*v=(UXStats2Vec*)vh,*gr=(UXStats2Vec*)gh; double dfb,dfw,mse; double f=anova_parts(v,gr,&dfb,&dfw,&mse); if(isnan(f)) return NAN; return uxstats2_f_p(f,dfb,dfw); }
static int group_mean_n(const UXStats2Vec*v,const UXStats2Vec*gr,double code,double*mean,int*n){ double s=0; int c=0; for(int i=0;i<v->count;i++) if(fabs(gr->data[i]-code)<1e-9){s+=v->data[i]; c++;} if(c<=0) return 0; *mean=s/c; *n=c; return 1; }
UXSTATS2_EXPORT double uxstats2_posthoc_tukey_q(void*vh,void*gh,double g1,double g2){ UXStats2Vec*v=(UXStats2Vec*)vh,*gr=(UXStats2Vec*)gh; double dfb,dfw,mse; if(isnan(anova_parts(v,gr,&dfb,&dfw,&mse))) return NAN; double m1,m2; int n1,n2; if(!group_mean_n(v,gr,g1,&m1,&n1)||!group_mean_n(v,gr,g2,&m2,&n2)) return NAN; double nh=2.0*n1*n2/(n1+n2); return fabs(m1-m2)/sqrt(mse/nh); }
UXSTATS2_EXPORT double uxstats2_posthoc_bonferroni_t_p(void*vh,void*gh,double g1,double g2,int32_t comparisons){ UXStats2Vec*v=(UXStats2Vec*)vh,*gr=(UXStats2Vec*)gh; double dfb,dfw,mse; if(isnan(anova_parts(v,gr,&dfb,&dfw,&mse))) return NAN; double m1,m2; int n1,n2; if(!group_mean_n(v,gr,g1,&m1,&n1)||!group_mean_n(v,gr,g2,&m2,&n2)) return NAN; double t=fabs(m1-m2)/sqrt(mse*(1.0/n1+1.0/n2)); double p=uxstats2_t_p2(t,dfw); if(comparisons<1) comparisons=1; return clamp01(p*comparisons); }
UXSTATS2_EXPORT double uxstats2_posthoc_scheffe_f(void*vh,void*gh,double g1,double g2){ UXStats2Vec*v=(UXStats2Vec*)vh,*gr=(UXStats2Vec*)gh; double dfb,dfw,mse; if(isnan(anova_parts(v,gr,&dfb,&dfw,&mse))) return NAN; double m1,m2; int n1,n2; if(!group_mean_n(v,gr,g1,&m1,&n1)||!group_mean_n(v,gr,g2,&m2,&n2)) return NAN; return sqr(m1-m2)/(mse*(1.0/n1+1.0/n2)); }

/* regression/time-series */
UXSTATS2_EXPORT double uxstats2_regression_slope(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); if(n<=1) return NAN; double vx=var_samp_n(x->data,n); if(vx<=0) return NAN; return cov_samp_n(x->data,y->data,n)/vx; }
UXSTATS2_EXPORT double uxstats2_regression_intercept(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); if(n<=1) return NAN; double b=uxstats2_regression_slope(xh,yh); if(isnan(b)) return NAN; return mean_n(y->data,n)-b*mean_n(x->data,n); }
UXSTATS2_EXPORT double uxstats2_regression_r2(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); if(n<=1) return NAN; double r=corr_n(x->data,y->data,n); return isnan(r)?NAN:r*r; }
UXSTATS2_EXPORT double uxstats2_regression_f(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); if(n<=2) return NAN; double r2=uxstats2_regression_r2(xh,yh); if(isnan(r2)) return NAN; if(r2>=1.0-UX2_EPS) return INFINITY; return r2/((1.0-r2)/(n-2)); }
UXSTATS2_EXPORT double uxstats2_regression_f_p(void*xh,void*yh){ UXStats2Vec*x=(UXStats2Vec*)xh,*y=(UXStats2Vec*)yh; int n=min_count(x,y); double f=uxstats2_regression_f(xh,yh); if(isnan(f)) return NAN; return uxstats2_f_p(f,1,n-2); }
UXSTATS2_EXPORT double uxstats2_vif_pair(void*xh,void*yh){ double r2=uxstats2_regression_r2(xh,yh); if(isnan(r2)) return NAN; if(r2>=1.0-UX2_EPS) return INFINITY; return 1.0/(1.0-r2); }
UXSTATS2_EXPORT double uxstats2_durbin_watson(void*eh){ UXStats2Vec*e=(UXStats2Vec*)eh; if(!valid_vec(e)||e->count<=1) return NAN; double num=0,den=0; for(int i=1;i<e->count;i++) num+=sqr(e->data[i]-e->data[i-1]); for(int i=0;i<e->count;i++) den+=sqr(e->data[i]); if(den<=0) return NAN; return num/den; }
static int solve_linear(double *a,double *b,double *x,int p){
    for(int i=0;i<p;i++){
        int pivot=i;
        for(int r=i+1;r<p;r++) if(fabs(a[r*p+i])>fabs(a[pivot*p+i])) pivot=r;
        if(fabs(a[pivot*p+i])<UX2_EPS) return 0;
        if(pivot!=i){
            for(int c=0;c<p;c++){double tmp=a[i*p+c];a[i*p+c]=a[pivot*p+c];a[pivot*p+c]=tmp;}
            double tmp=b[i];b[i]=b[pivot];b[pivot]=tmp;
        }
        double divisor=a[i*p+i];
        for(int c=i;c<p;c++) a[i*p+c]/=divisor;
        b[i]/=divisor;
        for(int r=0;r<p;r++) if(r!=i){
            double factor=a[r*p+i];
            for(int c=i;c<p;c++) a[r*p+c]-=factor*a[i*p+c];
            b[r]-=factor*b[i];
        }
    }
    for(int i=0;i<p;i++) x[i]=b[i];
    return 1;
}

static double ols_r2_lag_resid(const double*e,int n,int lags){
    if(!e||lags<1||n<=2*lags+1) return NAN;
    int rows=n-lags,p=lags+1;
    double *a=(double*)calloc((size_t)p*(size_t)p,sizeof(double));
    double *b=(double*)calloc((size_t)p,sizeof(double));
    double *beta=(double*)calloc((size_t)p,sizeof(double));
    double *row=(double*)calloc((size_t)p,sizeof(double));
    if(!a||!b||!beta||!row){free(a);free(b);free(beta);free(row);return NAN;}
    double ymean=0;
    for(int t=lags;t<n;t++) ymean+=e[t];
    ymean/=rows;
    for(int t=lags;t<n;t++){
        row[0]=1.0;
        for(int j=1;j<p;j++) row[j]=e[t-j];
        for(int r=0;r<p;r++){
            b[r]+=row[r]*e[t];
            for(int c=0;c<p;c++) a[r*p+c]+=row[r]*row[c];
        }
    }
    if(!solve_linear(a,b,beta,p)){free(a);free(b);free(beta);free(row);return NAN;}
    double sst=0,sse=0;
    for(int t=lags;t<n;t++){
        double pred=beta[0];
        for(int j=1;j<p;j++) pred+=beta[j]*e[t-j];
        sst+=sqr(e[t]-ymean);
        sse+=sqr(e[t]-pred);
    }
    free(a);free(b);free(beta);free(row);
    if(sst<=UX2_EPS) return NAN;
    return clamp01(1.0-sse/sst);
}
UXSTATS2_EXPORT double uxstats2_breusch_godfrey_lm(void*eh,int32_t lags){ UXStats2Vec*e=(UXStats2Vec*)eh; if(!valid_vec(e)||lags<1||e->count<=lags+1) return NAN; double r2=ols_r2_lag_resid(e->data,e->count,lags); if(isnan(r2)) return NAN; return (e->count-lags)*r2; }
UXSTATS2_EXPORT double uxstats2_breusch_godfrey_p(void*eh,int32_t lags){ double lm=uxstats2_breusch_godfrey_lm(eh,lags); if(isnan(lm)) return NAN; return uxstats2_chisq_p(lm,lags); }
UXSTATS2_EXPORT double uxstats2_adf_stat(void*yh){ UXStats2Vec*y=(UXStats2Vec*)yh; if(!valid_vec(y)||y->count<=3) return NAN; int n=y->count-1; double sx=0,sy=0,sxx=0,sxy=0; for(int t=1;t<y->count;t++){ double x=y->data[t-1],dy=y->data[t]-y->data[t-1]; sx+=x; sy+=dy; sxx+=x*x; sxy+=x*dy; } double den=n*sxx-sx*sx; if(fabs(den)<UX2_EPS) return NAN; double b=(n*sxy-sx*sy)/den; double a=(sy-b*sx)/n; double rss=0; for(int t=1;t<y->count;t++){ double x=y->data[t-1],dy=y->data[t]-y->data[t-1]; rss+=sqr(dy-(a+b*x)); } double se=sqrt((rss/(n-2))/(sxx-sx*sx/n)); if(se<=0) return NAN; return b/se; }
UXSTATS2_EXPORT double uxstats2_adf_p_approx(void*yh){ UXStats2Vec*y=(UXStats2Vec*)yh; double t=uxstats2_adf_stat(yh); if(!valid_vec(y)||isnan(t)) return NAN; return uxstats2_t_p2(t,y->count-3); }

/* ANCOVA binary group: compare y ~ covariate vs y ~ covariate + group dummy */
static int solve3(double A[3][3],double b[3],double x[3],int p){ for(int i=0;i<p;i++){ int piv=i; for(int r=i+1;r<p;r++) if(fabs(A[r][i])>fabs(A[piv][i])) piv=r; if(fabs(A[piv][i])<UX2_EPS) return 0; if(piv!=i){ for(int c=0;c<p;c++){double tmp=A[i][c];A[i][c]=A[piv][c];A[piv][c]=tmp;} double tb=b[i];b[i]=b[piv];b[piv]=tb;} double div=A[i][i]; for(int c=i;c<p;c++) A[i][c]/=div; b[i]/=div; for(int r=0;r<p;r++) if(r!=i){ double f=A[r][i]; for(int c=i;c<p;c++) A[r][c]-=f*A[i][c]; b[r]-=f*b[i]; }} for(int i=0;i<p;i++) x[i]=b[i]; return 1; }
static double rss_model_binary(const UXStats2Vec*y,const UXStats2Vec*x,const UXStats2Vec*g,double g1,double g2,int full,int *nused,int *pout){ double A[3][3]={{0}},B[3]={0},beta[3]={0}; int p=full?3:2,n=0; for(int i=0;i<y->count;i++){ if(fabs(g->data[i]-g1)>1e-9 && fabs(g->data[i]-g2)>1e-9) continue; double row[3]={1.0,x->data[i], fabs(g->data[i]-g2)<1e-9?1.0:0.0}; for(int r=0;r<p;r++){ B[r]+=row[r]*y->data[i]; for(int c=0;c<p;c++) A[r][c]+=row[r]*row[c]; } n++; } if(n<=p||!solve3(A,B,beta,p)) return NAN; double rss=0; for(int i=0;i<y->count;i++){ if(fabs(g->data[i]-g1)>1e-9 && fabs(g->data[i]-g2)>1e-9) continue; double pred=beta[0]+beta[1]*x->data[i]+(full?beta[2]*(fabs(g->data[i]-g2)<1e-9?1.0:0.0):0.0); rss+=sqr(y->data[i]-pred); } *nused=n; *pout=p; return rss; }
UXSTATS2_EXPORT double uxstats2_ancova_binary_f(void*yh,void*xh,void*gh,double g1,double g2){ UXStats2Vec*y=(UXStats2Vec*)yh,*x=(UXStats2Vec*)xh,*g=(UXStats2Vec*)gh; if(!valid_vec(y)||!valid_vec(x)||!valid_vec(g)||y->count!=x->count||y->count!=g->count) return NAN; int nr,pr,nf,pf; double rssr=rss_model_binary(y,x,g,g1,g2,0,&nr,&pr),rssf=rss_model_binary(y,x,g,g1,g2,1,&nf,&pf); if(isnan(rssr)||isnan(rssf)||nf<=pf) return NAN; return ((rssr-rssf)/(pf-pr))/(rssf/(nf-pf)); }
UXSTATS2_EXPORT double uxstats2_ancova_binary_p(void*yh,void*xh,void*gh,double g1,double g2){ UXStats2Vec*y=(UXStats2Vec*)yh,*x=(UXStats2Vec*)xh,*g=(UXStats2Vec*)gh; int nr,pr,nf,pf; double rssr=rss_model_binary(y,x,g,g1,g2,0,&nr,&pr),rssf=rss_model_binary(y,x,g,g1,g2,1,&nf,&pf); double f=uxstats2_ancova_binary_f(yh,xh,gh,g1,g2); if(isnan(f)) return NAN; return uxstats2_f_p(f,pf-pr,nf-pf); }

UXSTATS2_EXPORT double uxstats2_hotelling_t2_2d(void*x1h,void*x2h,void*gh,double g1,double g2){ UXStats2Vec*x1=(UXStats2Vec*)x1h,*x2=(UXStats2Vec*)x2h,*g=(UXStats2Vec*)gh; if(!valid_vec(x1)||!valid_vec(x2)||!valid_vec(g)||x1->count!=x2->count||x1->count!=g->count) return NAN; double m11=0,m12=0,m21=0,m22=0; int n1=0,n2=0; for(int i=0;i<g->count;i++){ if(fabs(g->data[i]-g1)<1e-9){m11+=x1->data[i];m12+=x2->data[i];n1++;} else if(fabs(g->data[i]-g2)<1e-9){m21+=x1->data[i];m22+=x2->data[i];n2++;} } if(n1<=2||n2<=2) return NAN; m11/=n1;m12/=n1;m21/=n2;m22/=n2; double s11=0,s22=0,s12=0; for(int i=0;i<g->count;i++){ if(fabs(g->data[i]-g1)<1e-9){s11+=sqr(x1->data[i]-m11);s22+=sqr(x2->data[i]-m12);s12+=(x1->data[i]-m11)*(x2->data[i]-m12);} else if(fabs(g->data[i]-g2)<1e-9){s11+=sqr(x1->data[i]-m21);s22+=sqr(x2->data[i]-m22);s12+=(x1->data[i]-m21)*(x2->data[i]-m22);} } double den=n1+n2-2; s11/=den;s22/=den;s12/=den; double det=s11*s22-s12*s12; if(fabs(det)<UX2_EPS) return NAN; double d1=m11-m21,d2=m12-m22; double q=(s22*d1*d1-2*s12*d1*d2+s11*d2*d2)/det; return ((double)n1*n2/(n1+n2))*q; }
UXSTATS2_EXPORT double uxstats2_hotelling_p_2d(void*x1h,void*x2h,void*gh,double g1,double g2){ UXStats2Vec*g=(UXStats2Vec*)gh; int n1=0,n2=0; for(int i=0;i<g->count;i++){ if(fabs(g->data[i]-g1)<1e-9)n1++; else if(fabs(g->data[i]-g2)<1e-9)n2++; } double t2=uxstats2_hotelling_t2_2d(x1h,x2h,gh,g1,g2); if(isnan(t2)||n1+n2<=3) return NAN; double p=2.0; double f=((n1+n2-p-1.0)*t2)/(p*(n1+n2-2.0)); return uxstats2_f_p(f,p,n1+n2-p-1.0); }
