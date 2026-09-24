#define UXMATRIX_BUILD 1
#include "uxmatrix.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#if defined(UXMATRIX_USE_OPENBLAS)
  #include <cblas.h>
  #if defined(UXMATRIX_USE_LAPACKE)
    #include <lapacke.h>
  #endif
#endif

#ifndef CblasRowMajor
#define CblasRowMajor 101
#define CblasNoTrans 111
#define CblasTrans 112
#endif

typedef struct UXMatrix {
    int rows;
    int cols;
    double* data; // row-major
} UXMatrix;

static UXMatrix* as_m(UXMatrixHandle h) { return (UXMatrix*)h; }
static int valid_dims(int r, int c) { return r > 0 && c > 0 && r <= 1000000 && c <= 1000000 && ((long long)r * (long long)c) <= 100000000LL; }
static int idx(UXMatrix* m, int r, int c) { return r * m->cols + c; }

static UXMatrix* alloc_matrix(int rows, int cols) {
    if (!valid_dims(rows, cols)) return NULL;
    UXMatrix* m = (UXMatrix*)calloc(1, sizeof(UXMatrix));
    if (!m) return NULL;
    m->rows = rows;
    m->cols = cols;
    m->data = (double*)calloc((size_t)rows * (size_t)cols, sizeof(double));
    if (!m->data) { free(m); return NULL; }
    return m;
}

int uxmatrix_runtime_version(void) { return 1; }

UXMatrixHandle uxmatrix_create(int rows, int cols) { return alloc_matrix(rows, cols); }

UXMatrixHandle uxmatrix_from_array(int rows, int cols, const double* data_row_major) {
    UXMatrix* m = alloc_matrix(rows, cols);
    if (!m) return NULL;
    if (data_row_major) memcpy(m->data, data_row_major, sizeof(double) * (size_t)rows * (size_t)cols);
    return m;
}

void uxmatrix_free(UXMatrixHandle h) {
    UXMatrix* m = as_m(h);
    if (!m) return;
    free(m->data);
    free(m);
}

int uxmatrix_rows(UXMatrixHandle h) { UXMatrix* m = as_m(h); return m ? m->rows : 0; }
int uxmatrix_cols(UXMatrixHandle h) { UXMatrix* m = as_m(h); return m ? m->cols : 0; }
int uxmatrix_size(UXMatrixHandle h) { UXMatrix* m = as_m(h); return m ? m->rows * m->cols : 0; }
double* uxmatrix_data_ptr(UXMatrixHandle h) { UXMatrix* m = as_m(h); return m ? m->data : NULL; }

int uxmatrix_set(UXMatrixHandle h, int r, int c, double v) {
    UXMatrix* m = as_m(h);
    if (!m || r < 0 || c < 0 || r >= m->rows || c >= m->cols) return 0;
    m->data[idx(m,r,c)] = v;
    return 1;
}

double uxmatrix_get(UXMatrixHandle h, int r, int c) {
    UXMatrix* m = as_m(h);
    if (!m || r < 0 || c < 0 || r >= m->rows || c >= m->cols) return NAN;
    return m->data[idx(m,r,c)];
}

int uxmatrix_fill(UXMatrixHandle h, double v) {
    UXMatrix* m = as_m(h);
    if (!m) return 0;
    int n = m->rows * m->cols;
    for (int i=0;i<n;i++) m->data[i]=v;
    return 1;
}

int uxmatrix_zero(UXMatrixHandle h) { return uxmatrix_fill(h, 0.0); }

int uxmatrix_eye(UXMatrixHandle h) {
    UXMatrix* m = as_m(h);
    if (!m) return 0;
    uxmatrix_zero(h);
    int n = m->rows < m->cols ? m->rows : m->cols;
    for (int i=0;i<n;i++) m->data[idx(m,i,i)] = 1.0;
    return 1;
}

UXMatrixHandle uxmatrix_clone(UXMatrixHandle h) {
    UXMatrix* a = as_m(h);
    if (!a) return NULL;
    return uxmatrix_from_array(a->rows, a->cols, a->data);
}

UXMatrixHandle uxmatrix_transpose(UXMatrixHandle ah) {
    UXMatrix* a = as_m(ah);
    if (!a) return NULL;
    UXMatrix* t = alloc_matrix(a->cols, a->rows);
    if (!t) return NULL;
    for (int r=0;r<a->rows;r++) for (int c=0;c<a->cols;c++) t->data[idx(t,c,r)] = a->data[idx(a,r,c)];
    return t;
}

UXMatrixHandle uxmatrix_add(UXMatrixHandle ah, UXMatrixHandle bh) {
    UXMatrix *a=as_m(ah), *b=as_m(bh);
    if (!a || !b || a->rows!=b->rows || a->cols!=b->cols) return NULL;
    UXMatrix* c=alloc_matrix(a->rows,a->cols); if(!c) return NULL;
    int n=a->rows*a->cols;
    for(int i=0;i<n;i++) c->data[i]=a->data[i]+b->data[i];
    return c;
}

UXMatrixHandle uxmatrix_sub(UXMatrixHandle ah, UXMatrixHandle bh) {
    UXMatrix *a=as_m(ah), *b=as_m(bh);
    if (!a || !b || a->rows!=b->rows || a->cols!=b->cols) return NULL;
    UXMatrix* c=alloc_matrix(a->rows,a->cols); if(!c) return NULL;
    int n=a->rows*a->cols;
    for(int i=0;i<n;i++) c->data[i]=a->data[i]-b->data[i];
    return c;
}

UXMatrixHandle uxmatrix_scale(UXMatrixHandle ah, double s) {
    UXMatrix* a=as_m(ah); if(!a) return NULL;
    UXMatrix* c=alloc_matrix(a->rows,a->cols); if(!c) return NULL;
    int n=a->rows*a->cols;
    for(int i=0;i<n;i++) c->data[i]=a->data[i]*s;
    return c;
}

static void fallback_dgemm(int m, int n, int k, double alpha, const double* A, const double* B, double beta, double* C) {
    for (int i=0;i<m;i++) {
        for (int j=0;j<n;j++) {
            double sum = 0.0;
            for (int p=0;p<k;p++) sum += A[i*k+p] * B[p*n+j];
            C[i*n+j] = alpha * sum + beta * C[i*n+j];
        }
    }
}

UXMatrixHandle uxmatrix_mul(UXMatrixHandle ah, UXMatrixHandle bh) {
    UXMatrix *a=as_m(ah), *b=as_m(bh);
    if (!a || !b || a->cols != b->rows) return NULL;
    UXMatrix* c=alloc_matrix(a->rows, b->cols); if(!c) return NULL;
#if defined(UXMATRIX_USE_OPENBLAS)
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, a->rows, b->cols, a->cols, 1.0, a->data, a->cols, b->data, b->cols, 0.0, c->data, c->cols);
#else
    fallback_dgemm(a->rows,b->cols,a->cols,1.0,a->data,b->data,0.0,c->data);
#endif
    return c;
}

UXMatrixHandle uxmatrix_matvec(UXMatrixHandle ah, UXMatrixHandle xh) {
    UXMatrix *a=as_m(ah), *x=as_m(xh);
    if (!a || !x || x->cols != 1 || a->cols != x->rows) return NULL;
    UXMatrix* y=alloc_matrix(a->rows,1); if(!y) return NULL;
#if defined(UXMATRIX_USE_OPENBLAS)
    cblas_dgemv(CblasRowMajor, CblasNoTrans, a->rows, a->cols, 1.0, a->data, a->cols, x->data, 1, 0.0, y->data, 1);
#else
    for(int i=0;i<a->rows;i++){ double s=0.0; for(int j=0;j<a->cols;j++) s+=a->data[idx(a,i,j)]*x->data[j]; y->data[i]=s; }
#endif
    return y;
}

double uxmatrix_dot(UXMatrixHandle ah, UXMatrixHandle bh) {
    UXMatrix *a=as_m(ah), *b=as_m(bh);
    if(!a || !b) return NAN;
    int na=a->rows*a->cols, nb=b->rows*b->cols;
    if(na!=nb) return NAN;
#if defined(UXMATRIX_USE_OPENBLAS)
    return cblas_ddot(na, a->data, 1, b->data, 1);
#else
    double s=0.0; for(int i=0;i<na;i++) s+=a->data[i]*b->data[i]; return s;
#endif
}

double uxmatrix_norm_l1(UXMatrixHandle h) { UXMatrix* a=as_m(h); if(!a) return NAN; double s=0.0; int n=a->rows*a->cols; for(int i=0;i<n;i++) s+=fabs(a->data[i]); return s; }
double uxmatrix_norm_l2(UXMatrixHandle h) { double d=uxmatrix_dot(h,h); return isnan(d)?NAN:sqrt(d); }
double uxmatrix_norm_fro(UXMatrixHandle h) { return uxmatrix_norm_l2(h); }

double uxmatrix_trace(UXMatrixHandle h) {
    UXMatrix* a=as_m(h); if(!a) return NAN;
    int n=a->rows<a->cols?a->rows:a->cols; double s=0.0;
    for(int i=0;i<n;i++) s+=a->data[idx(a,i,i)];
    return s;
}

int uxmatrix_copy_to_array(UXMatrixHandle h, double* out, int max_count) {
    UXMatrix* a=as_m(h); if(!a || !out || max_count<=0) return 0;
    int n=a->rows*a->cols; if(n>max_count) n=max_count;
    memcpy(out,a->data,sizeof(double)*(size_t)n); return n;
}

int uxmatrix_copy_from_array(UXMatrixHandle h, const double* in, int count) {
    UXMatrix* a=as_m(h); if(!a || !in || count<0) return 0;
    int n=a->rows*a->cols; if(count<n) n=count;
    memcpy(a->data,in,sizeof(double)*(size_t)n); return n;
}

int uxmatrix_print(UXMatrixHandle h) {
    UXMatrix* a=as_m(h); if(!a) return 0;
    for(int r=0;r<a->rows;r++) { for(int c=0;c<a->cols;c++) printf("% .8g%s", a->data[idx(a,r,c)], c==a->cols-1?"":"\t"); printf("\n"); }
    return 1;
}

static UXMatrix* square_clone(UXMatrixHandle h) {
    UXMatrix* a=as_m(h);
    if(!a || a->rows!=a->cols) return NULL;
    return as_m(uxmatrix_clone(h));
}

#if defined(UXMATRIX_USE_LAPACKE)
int uxmatrix_solve(UXMatrixHandle ah, UXMatrixHandle bh, UXMatrixHandle* x_out) {
    if(!x_out) return 0; *x_out=NULL;
    UXMatrix *a=as_m(ah), *b=as_m(bh);
    if(!a || !b || a->rows!=a->cols || b->rows!=a->rows) return 0;
    UXMatrix* ac=as_m(uxmatrix_clone(ah));
    UXMatrix* x=as_m(uxmatrix_clone(bh));
    if(!ac || !x) { uxmatrix_free(ac); uxmatrix_free(x); return 0; }
    int n=a->rows, nrhs=b->cols;
    int* ipiv=(int*)calloc((size_t)n,sizeof(int)); if(!ipiv){uxmatrix_free(ac);uxmatrix_free(x);return 0;}
    int info=LAPACKE_dgesv(LAPACK_ROW_MAJOR,n,nrhs,ac->data,n,ipiv,x->data,nrhs);
    free(ipiv); uxmatrix_free(ac);
    if(info!=0){ uxmatrix_free(x); return info; }
    *x_out=x; return 1;
}

double uxmatrix_det(UXMatrixHandle ah) {
    UXMatrix* a=square_clone(ah); if(!a) return NAN;
    int n=a->rows; int* ipiv=(int*)calloc((size_t)n,sizeof(int)); if(!ipiv){uxmatrix_free(a);return NAN;}
    int info=LAPACKE_dgetrf(LAPACK_ROW_MAJOR,n,n,a->data,n,ipiv);
    if(info!=0){ free(ipiv); uxmatrix_free(a); return NAN; }
    double det=1.0; int sign=1;
    for(int i=0;i<n;i++){ det*=a->data[idx(a,i,i)]; if(ipiv[i] != i+1) sign=-sign; }
    free(ipiv); uxmatrix_free(a); return sign*det;
}

int uxmatrix_inverse(UXMatrixHandle ah, UXMatrixHandle* inv_out) {
    if(!inv_out) return 0; *inv_out=NULL;
    UXMatrix* a=square_clone(ah); if(!a) return 0;
    int n=a->rows; int* ipiv=(int*)calloc((size_t)n,sizeof(int)); if(!ipiv){uxmatrix_free(a);return 0;}
    int info=LAPACKE_dgetrf(LAPACK_ROW_MAJOR,n,n,a->data,n,ipiv);
    if(info==0) info=LAPACKE_dgetri(LAPACK_ROW_MAJOR,n,a->data,n,ipiv);
    free(ipiv);
    if(info!=0){ uxmatrix_free(a); return info; }
    *inv_out=a; return 1;
}

int uxmatrix_cholesky(UXMatrixHandle ah, UXMatrixHandle* lower_out) {
    if(!lower_out) return 0; *lower_out=NULL;
    UXMatrix* a=square_clone(ah); if(!a) return 0;
    int n=a->rows; int info=LAPACKE_dpotrf(LAPACK_ROW_MAJOR,'L',n,a->data,n);
    if(info!=0){ uxmatrix_free(a); return info; }
    for(int r=0;r<n;r++) for(int c=r+1;c<n;c++) a->data[idx(a,r,c)]=0.0;
    *lower_out=a; return 1;
}

int uxmatrix_svd(UXMatrixHandle ah, UXMatrixHandle* u_out, UXMatrixHandle* s_out, UXMatrixHandle* vt_out) {
    if(!u_out||!s_out||!vt_out) return 0; *u_out=*s_out=*vt_out=NULL;
    UXMatrix* a=as_m(ah); if(!a) return 0;
    int m=a->rows,n=a->cols,minmn=m<n?m:n;
    UXMatrix* ac=as_m(uxmatrix_clone(ah)); UXMatrix* u=alloc_matrix(m,m); UXMatrix* s=alloc_matrix(minmn,1); UXMatrix* vt=alloc_matrix(n,n);
    if(!ac||!u||!s||!vt){ uxmatrix_free(ac);uxmatrix_free(u);uxmatrix_free(s);uxmatrix_free(vt); return 0; }
    double* superb=(double*)calloc((size_t)(minmn>1?minmn-1:1),sizeof(double)); if(!superb){uxmatrix_free(ac);uxmatrix_free(u);uxmatrix_free(s);uxmatrix_free(vt);return 0;}
    int info=LAPACKE_dgesvd(LAPACK_ROW_MAJOR,'A','A',m,n,ac->data,n,s->data,u->data,m,vt->data,n,superb);
    free(superb); uxmatrix_free(ac);
    if(info!=0){uxmatrix_free(u);uxmatrix_free(s);uxmatrix_free(vt);return info;}
    *u_out=u; *s_out=s; *vt_out=vt; return 1;
}

int uxmatrix_eigen_symmetric(UXMatrixHandle ah, UXMatrixHandle* values_out, UXMatrixHandle* vectors_out) {
    if(!values_out||!vectors_out) return 0; *values_out=*vectors_out=NULL;
    UXMatrix* a=square_clone(ah); if(!a) return 0;
    int n=a->rows; UXMatrix* vals=alloc_matrix(n,1); if(!vals){uxmatrix_free(a);return 0;}
    int info=LAPACKE_dsyev(LAPACK_ROW_MAJOR,'V','U',n,a->data,n,vals->data);
    if(info!=0){uxmatrix_free(a);uxmatrix_free(vals);return info;}
    *values_out=vals; *vectors_out=a; return 1;
}

int uxmatrix_qr(UXMatrixHandle ah, UXMatrixHandle* q_out, UXMatrixHandle* r_out) {
    if(!q_out||!r_out) return 0; *q_out=*r_out=NULL;
    UXMatrix* a=as_m(ah); if(!a) return 0;
    int m=a->rows,n=a->cols,k=m<n?m:n;
    UXMatrix* q=as_m(uxmatrix_clone(ah)); UXMatrix* r=alloc_matrix(k,n); double* tau=(double*)calloc((size_t)k,sizeof(double));
    if(!q||!r||!tau){uxmatrix_free(q);uxmatrix_free(r);free(tau);return 0;}
    int info=LAPACKE_dgeqrf(LAPACK_ROW_MAJOR,m,n,q->data,n,tau);
    if(info!=0){uxmatrix_free(q);uxmatrix_free(r);free(tau);return info;}
    for(int i=0;i<k;i++) for(int j=i;j<n;j++) r->data[idx(r,i,j)] = q->data[i*n+j];
    info=LAPACKE_dorgqr(LAPACK_ROW_MAJOR,m,n,k,q->data,n,tau);
    free(tau);
    if(info!=0){uxmatrix_free(q);uxmatrix_free(r);return info;}
    *q_out=q; *r_out=r; return 1;
}

int uxmatrix_rank_svd(UXMatrixHandle ah, double tol) {
    UXMatrixHandle u=NULL,s=NULL,vt=NULL; int ok=uxmatrix_svd(ah,&u,&s,&vt); if(ok!=1) return -1;
    UXMatrix* sv=as_m(s); int rank=0; int n=sv->rows*sv->cols; for(int i=0;i<n;i++) if(fabs(sv->data[i])>tol) rank++;
    uxmatrix_free(u); uxmatrix_free(s); uxmatrix_free(vt); return rank;
}

double uxmatrix_cond2(UXMatrixHandle ah) {
    UXMatrixHandle u=NULL,s=NULL,vt=NULL; int ok=uxmatrix_svd(ah,&u,&s,&vt); if(ok!=1) return NAN;
    UXMatrix* sv=as_m(s); int n=sv->rows*sv->cols; double mx=0.0,mn=INFINITY; for(int i=0;i<n;i++){ double v=fabs(sv->data[i]); if(v>mx)mx=v; if(v<mn && v>0.0)mn=v; }
    uxmatrix_free(u); uxmatrix_free(s); uxmatrix_free(vt); if(mn==INFINITY || mn==0.0) return INFINITY; return mx/mn;
}
#else
#define UXMATRIX_FALLBACK_EPS 1.0e-12

static void fallback_swap_rows(UXMatrix* m, int a, int b) {
    if (a == b) return;
    for (int c = 0; c < m->cols; ++c) {
        double t = m->data[idx(m, a, c)];
        m->data[idx(m, a, c)] = m->data[idx(m, b, c)];
        m->data[idx(m, b, c)] = t;
    }
}

int uxmatrix_solve(UXMatrixHandle ah, UXMatrixHandle bh, UXMatrixHandle* x_out) {
    if (!x_out) return 0;
    *x_out = NULL;
    UXMatrix *a = as_m(ah), *b = as_m(bh);
    if (!a || !b || a->rows != a->cols || b->rows != a->rows) return 0;

    int n = a->rows;
    UXMatrix* ac = as_m(uxmatrix_clone(ah));
    UXMatrix* x = as_m(uxmatrix_clone(bh));
    if (!ac || !x) { uxmatrix_free(ac); uxmatrix_free(x); return 0; }

    for (int k = 0; k < n; ++k) {
        int pivot = k;
        double pivot_abs = fabs(ac->data[idx(ac, k, k)]);
        for (int r = k + 1; r < n; ++r) {
            double candidate = fabs(ac->data[idx(ac, r, k)]);
            if (candidate > pivot_abs) { pivot_abs = candidate; pivot = r; }
        }
        if (pivot_abs <= UXMATRIX_FALLBACK_EPS) { uxmatrix_free(ac); uxmatrix_free(x); return 0; }
        fallback_swap_rows(ac, k, pivot);
        fallback_swap_rows(x, k, pivot);

        for (int r = k + 1; r < n; ++r) {
            double factor = ac->data[idx(ac, r, k)] / ac->data[idx(ac, k, k)];
            ac->data[idx(ac, r, k)] = 0.0;
            for (int c = k + 1; c < n; ++c) ac->data[idx(ac, r, c)] -= factor * ac->data[idx(ac, k, c)];
            for (int c = 0; c < x->cols; ++c) x->data[idx(x, r, c)] -= factor * x->data[idx(x, k, c)];
        }
    }

    for (int r = n - 1; r >= 0; --r) {
        double diagonal = ac->data[idx(ac, r, r)];
        if (fabs(diagonal) <= UXMATRIX_FALLBACK_EPS) { uxmatrix_free(ac); uxmatrix_free(x); return 0; }
        for (int c = 0; c < x->cols; ++c) {
            double sum = x->data[idx(x, r, c)];
            for (int j = r + 1; j < n; ++j) sum -= ac->data[idx(ac, r, j)] * x->data[idx(x, j, c)];
            x->data[idx(x, r, c)] = sum / diagonal;
        }
    }

    uxmatrix_free(ac);
    *x_out = x;
    return 1;
}

double uxmatrix_det(UXMatrixHandle ah) {
    UXMatrix* a = square_clone(ah);
    if (!a) return NAN;
    int n = a->rows;
    int sign = 1;
    double det = 1.0;
    for (int k = 0; k < n; ++k) {
        int pivot = k;
        double pivot_abs = fabs(a->data[idx(a, k, k)]);
        for (int r = k + 1; r < n; ++r) {
            double candidate = fabs(a->data[idx(a, r, k)]);
            if (candidate > pivot_abs) { pivot_abs = candidate; pivot = r; }
        }
        if (pivot_abs <= UXMATRIX_FALLBACK_EPS) { uxmatrix_free(a); return 0.0; }
        if (pivot != k) { fallback_swap_rows(a, k, pivot); sign = -sign; }
        double diagonal = a->data[idx(a, k, k)];
        det *= diagonal;
        for (int r = k + 1; r < n; ++r) {
            double factor = a->data[idx(a, r, k)] / diagonal;
            for (int c = k + 1; c < n; ++c) a->data[idx(a, r, c)] -= factor * a->data[idx(a, k, c)];
        }
    }
    uxmatrix_free(a);
    return sign * det;
}

int uxmatrix_inverse(UXMatrixHandle ah, UXMatrixHandle* inv_out) {
    if (!inv_out) return 0;
    *inv_out = NULL;
    UXMatrix* a = as_m(ah);
    if (!a || a->rows != a->cols) return 0;
    UXMatrix* identity = alloc_matrix(a->rows, a->cols);
    if (!identity) return 0;
    uxmatrix_eye(identity);
    int ok = uxmatrix_solve(ah, identity, inv_out);
    uxmatrix_free(identity);
    return ok;
}

int uxmatrix_cholesky(UXMatrixHandle ah, UXMatrixHandle* lower_out) {
    if (!lower_out) return 0;
    *lower_out = NULL;
    UXMatrix* a = as_m(ah);
    if (!a || a->rows != a->cols) return 0;
    int n = a->rows;
    UXMatrix* lower = alloc_matrix(n, n);
    if (!lower) return 0;

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j <= i; ++j) {
            if (fabs(a->data[idx(a, i, j)] - a->data[idx(a, j, i)]) > 1.0e-9) { uxmatrix_free(lower); return 0; }
            double sum = a->data[idx(a, i, j)];
            for (int k = 0; k < j; ++k) sum -= lower->data[idx(lower, i, k)] * lower->data[idx(lower, j, k)];
            if (i == j) {
                if (sum <= UXMATRIX_FALLBACK_EPS) { uxmatrix_free(lower); return 0; }
                lower->data[idx(lower, i, j)] = sqrt(sum);
            } else {
                lower->data[idx(lower, i, j)] = sum / lower->data[idx(lower, j, j)];
            }
        }
    }
    *lower_out = lower;
    return 1;
}

int uxmatrix_qr(UXMatrixHandle ah, UXMatrixHandle* q_out, UXMatrixHandle* r_out) {
    if (!q_out || !r_out) return 0;
    *q_out = NULL; *r_out = NULL;
    UXMatrix* a = as_m(ah);
    if (!a) return 0;
    int m = a->rows, n = a->cols, kmax = m < n ? m : n;
    UXMatrix* q = alloc_matrix(m, kmax);
    UXMatrix* r = alloc_matrix(kmax, n);
    double* work = (double*)calloc((size_t)m, sizeof(double));
    if (!q || !r || !work) { uxmatrix_free(q); uxmatrix_free(r); free(work); return 0; }

    for (int j = 0; j < n; ++j) {
        for (int row = 0; row < m; ++row) work[row] = a->data[idx(a, row, j)];
        int projection_count = j < kmax ? j : kmax;
        for (int i = 0; i < projection_count; ++i) {
            double projection = 0.0;
            for (int row = 0; row < m; ++row) projection += q->data[idx(q, row, i)] * work[row];
            r->data[idx(r, i, j)] = projection;
            for (int row = 0; row < m; ++row) work[row] -= projection * q->data[idx(q, row, i)];
        }
        if (j < kmax) {
            double norm = 0.0;
            for (int row = 0; row < m; ++row) norm += work[row] * work[row];
            norm = sqrt(norm);
            if (norm <= UXMATRIX_FALLBACK_EPS) { uxmatrix_free(q); uxmatrix_free(r); free(work); return 0; }
            r->data[idx(r, j, j)] = norm;
            for (int row = 0; row < m; ++row) q->data[idx(q, row, j)] = work[row] / norm;
        }
    }
    free(work);
    *q_out = q; *r_out = r;
    return 1;
}

static int fallback_jacobi_symmetric(UXMatrix* a, UXMatrix** values_out, UXMatrix** vectors_out) {
    if (!a || a->rows != a->cols || !values_out || !vectors_out) return 0;
    *values_out = NULL; *vectors_out = NULL;
    int n = a->rows;
    UXMatrix* d = as_m(uxmatrix_clone(a));
    UXMatrix* vectors = alloc_matrix(n, n);
    UXMatrix* values = alloc_matrix(n, 1);
    if (!d || !vectors || !values) { uxmatrix_free(d); uxmatrix_free(vectors); uxmatrix_free(values); return 0; }
    uxmatrix_eye(vectors);
    for (int i = 0; i < n; ++i) for (int j = i + 1; j < n; ++j) {
        if (fabs(d->data[idx(d, i, j)] - d->data[idx(d, j, i)]) > 1.0e-9) {
            uxmatrix_free(d); uxmatrix_free(vectors); uxmatrix_free(values); return 0;
        }
    }

    int max_iterations = 100 * n * n;
    int converged = (n <= 1);
    for (int iteration = 0; iteration < max_iterations && !converged; ++iteration) {
        int p = 0, q = 1;
        double largest = 0.0;
        for (int i = 0; i < n; ++i) for (int j = i + 1; j < n; ++j) {
            double candidate = fabs(d->data[idx(d, i, j)]);
            if (candidate > largest) { largest = candidate; p = i; q = j; }
        }
        if (largest <= UXMATRIX_FALLBACK_EPS) { converged = 1; break; }

        double app = d->data[idx(d, p, p)], aqq = d->data[idx(d, q, q)], apq = d->data[idx(d, p, q)];
        double angle = 0.5 * atan2(2.0 * apq, aqq - app);
        double c = cos(angle), s = sin(angle);
        for (int k = 0; k < n; ++k) {
            if (k == p || k == q) continue;
            double dkp = d->data[idx(d, k, p)], dkq = d->data[idx(d, k, q)];
            d->data[idx(d, k, p)] = d->data[idx(d, p, k)] = c * dkp - s * dkq;
            d->data[idx(d, k, q)] = d->data[idx(d, q, k)] = s * dkp + c * dkq;
        }
        d->data[idx(d, p, p)] = c*c*app - 2.0*s*c*apq + s*s*aqq;
        d->data[idx(d, q, q)] = s*s*app + 2.0*s*c*apq + c*c*aqq;
        d->data[idx(d, p, q)] = d->data[idx(d, q, p)] = 0.0;
        for (int k = 0; k < n; ++k) {
            double vkp = vectors->data[idx(vectors, k, p)], vkq = vectors->data[idx(vectors, k, q)];
            vectors->data[idx(vectors, k, p)] = c * vkp - s * vkq;
            vectors->data[idx(vectors, k, q)] = s * vkp + c * vkq;
        }
    }
    if (!converged) { uxmatrix_free(d); uxmatrix_free(vectors); uxmatrix_free(values); return 0; }

    for (int i = 0; i < n; ++i) values->data[i] = d->data[idx(d, i, i)];
    for (int i = 0; i < n - 1; ++i) for (int j = i + 1; j < n; ++j) {
        if (values->data[i] > values->data[j]) {
            double tv = values->data[i]; values->data[i] = values->data[j]; values->data[j] = tv;
            for (int row = 0; row < n; ++row) {
                double t = vectors->data[idx(vectors, row, i)];
                vectors->data[idx(vectors, row, i)] = vectors->data[idx(vectors, row, j)];
                vectors->data[idx(vectors, row, j)] = t;
            }
        }
    }
    uxmatrix_free(d);
    *values_out = values; *vectors_out = vectors;
    return 1;
}

int uxmatrix_eigen_symmetric(UXMatrixHandle ah, UXMatrixHandle* values_out, UXMatrixHandle* vectors_out) {
    return fallback_jacobi_symmetric(as_m(ah), (UXMatrix**)values_out, (UXMatrix**)vectors_out);
}

int uxmatrix_svd(UXMatrixHandle ah, UXMatrixHandle* u_out, UXMatrixHandle* s_out, UXMatrixHandle* vt_out) {
    if (!u_out || !s_out || !vt_out) return 0;
    *u_out = NULL; *s_out = NULL; *vt_out = NULL;
    UXMatrix* a = as_m(ah);
    if (!a) return 0;
    int m = a->rows, n = a->cols, minmn = m < n ? m : n;
    UXMatrix* ata = alloc_matrix(n, n);
    UXMatrix *evals = NULL, *v = NULL;
    if (!ata) return 0;
    for (int i = 0; i < n; ++i) for (int j = 0; j < n; ++j) {
        double sum = 0.0;
        for (int row = 0; row < m; ++row) sum += a->data[idx(a, row, i)] * a->data[idx(a, row, j)];
        ata->data[idx(ata, i, j)] = sum;
    }
    if (!fallback_jacobi_symmetric(ata, &evals, &v)) { uxmatrix_free(ata); return 0; }
    uxmatrix_free(ata);

    UXMatrix* u = alloc_matrix(m, m);
    UXMatrix* singular = alloc_matrix(minmn, 1);
    UXMatrix* vt = alloc_matrix(n, n);
    if (!u || !singular || !vt) { uxmatrix_free(evals); uxmatrix_free(v); uxmatrix_free(u); uxmatrix_free(singular); uxmatrix_free(vt); return 0; }

    for (int col = 0; col < n; ++col) for (int row = 0; row < n; ++row) {
        vt->data[idx(vt, col, row)] = v->data[idx(v, row, n - 1 - col)];
    }
    for (int col = 0; col < minmn; ++col) {
        double eigenvalue = evals->data[n - 1 - col];
        double sigma = sqrt(eigenvalue > 0.0 ? eigenvalue : 0.0);
        singular->data[col] = sigma;
        if (sigma > UXMATRIX_FALLBACK_EPS) {
            for (int row = 0; row < m; ++row) {
                double sum = 0.0;
                for (int k = 0; k < n; ++k) sum += a->data[idx(a, row, k)] * v->data[idx(v, k, n - 1 - col)];
                u->data[idx(u, row, col)] = sum / sigma;
            }
        }
    }
    for (int col = 0; col < m; ++col) {
        double norm = 0.0;
        for (int row = 0; row < m; ++row) norm += u->data[idx(u, row, col)] * u->data[idx(u, row, col)];
        if (norm <= UXMATRIX_FALLBACK_EPS) {
            for (int row = 0; row < m; ++row) u->data[idx(u, row, col)] = (row == col ? 1.0 : 0.0);
        }
        for (int previous = 0; previous < col; ++previous) {
            double projection = 0.0;
            for (int row = 0; row < m; ++row) projection += u->data[idx(u, row, previous)] * u->data[idx(u, row, col)];
            for (int row = 0; row < m; ++row) u->data[idx(u, row, col)] -= projection * u->data[idx(u, row, previous)];
        }
        norm = 0.0;
        for (int row = 0; row < m; ++row) norm += u->data[idx(u, row, col)] * u->data[idx(u, row, col)];
        norm = sqrt(norm);
        if (norm <= UXMATRIX_FALLBACK_EPS) { uxmatrix_free(evals); uxmatrix_free(v); uxmatrix_free(u); uxmatrix_free(singular); uxmatrix_free(vt); return 0; }
        for (int row = 0; row < m; ++row) u->data[idx(u, row, col)] /= norm;
    }

    uxmatrix_free(evals); uxmatrix_free(v);
    *u_out = u; *s_out = singular; *vt_out = vt;
    return 1;
}

int uxmatrix_rank_svd(UXMatrixHandle ah, double tol) {
    UXMatrixHandle u = NULL, s = NULL, vt = NULL;
    if (uxmatrix_svd(ah, &u, &s, &vt) != 1) return -1;
    UXMatrix* singular = as_m(s);
    int rank = 0;
    for (int i = 0; i < singular->rows * singular->cols; ++i) if (fabs(singular->data[i]) > tol) ++rank;
    uxmatrix_free(u); uxmatrix_free(s); uxmatrix_free(vt);
    return rank;
}

double uxmatrix_cond2(UXMatrixHandle ah) {
    UXMatrixHandle u = NULL, s = NULL, vt = NULL;
    if (uxmatrix_svd(ah, &u, &s, &vt) != 1) return NAN;
    UXMatrix* singular = as_m(s);
    int count = singular->rows * singular->cols;
    double largest = count > 0 ? singular->data[0] : 0.0;
    double smallest = count > 0 ? singular->data[count - 1] : 0.0;
    uxmatrix_free(u); uxmatrix_free(s); uxmatrix_free(vt);
    if (smallest <= UXMATRIX_FALLBACK_EPS) return INFINITY;
    return largest / smallest;
}
#endif

UXMatrixHandle uxmatrix_solve_new(UXMatrixHandle a, UXMatrixHandle b) {
    UXMatrixHandle result = NULL;
    if (uxmatrix_solve(a, b, &result) != 1) return NULL;
    return result;
}

UXMatrixHandle uxmatrix_inverse_new(UXMatrixHandle a) {
    UXMatrixHandle result = NULL;
    if (uxmatrix_inverse(a, &result) != 1) return NULL;
    return result;
}

UXMatrixHandle uxmatrix_cholesky_new(UXMatrixHandle a) {
    UXMatrixHandle result = NULL;
    if (uxmatrix_cholesky(a, &result) != 1) return NULL;
    return result;
}

double uxmatrix_blas_ddot(int n, const double* x, int incx, const double* y, int incy) {
#if defined(UXMATRIX_USE_OPENBLAS)
    return cblas_ddot(n,x,incx,y,incy);
#else
    double s=0.0; for(int i=0;i<n;i++) s += x[i*incx]*y[i*incy]; return s;
#endif
}

int uxmatrix_blas_daxpy(int n, double alpha, const double* x, int incx, double* y, int incy) {
    if(!x||!y||n<0) return 0;
#if defined(UXMATRIX_USE_OPENBLAS)
    cblas_daxpy(n,alpha,x,incx,y,incy);
#else
    for(int i=0;i<n;i++) y[i*incy]+=alpha*x[i*incx];
#endif
    return 1;
}

int uxmatrix_blas_dgemm_rowmajor(int m, int n, int k, double alpha, const double* A, const double* B, double beta, double* C) {
    if(!A||!B||!C) return 0;
#if defined(UXMATRIX_USE_OPENBLAS)
    cblas_dgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,m,n,k,alpha,A,k,B,n,beta,C,n);
#else
    fallback_dgemm(m,n,k,alpha,A,B,beta,C);
#endif
    return 1;
}
