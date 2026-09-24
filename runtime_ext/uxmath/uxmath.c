#include "uxmath.h"
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>

#ifndef UX_PI
#define UX_PI 3.141592653589793238462643383279502884
#endif

typedef struct UxVec {
    int n;
    int cap;
    double* data;
} UxVec;

typedef struct UxMat {
    int rows;
    int cols;
    double* data;
} UxMat;

static UxVec* as_vec(void* h) { return (UxVec*)h; }
static UxMat* as_mat(void* h) { return (UxMat*)h; }

static int ensure_vec(UxVec* v, int need) {
    if (!v) return 0;
    if (need <= v->cap) return 1;
    int nc = v->cap > 0 ? v->cap : 8;
    while (nc < need) nc *= 2;
    double* nd = (double*)realloc(v->data, sizeof(double) * (size_t)nc);
    if (!nd) return 0;
    v->data = nd;
    v->cap = nc;
    return 1;
}

static int mat_index(UxMat* m, int r, int c) {
    return r * m->cols + c;
}

UXMATH_API int uxmath_version(void) { return 1001; }

UXMATH_API void* uxmath_vec_create(int capacity) {
    if (capacity < 1) capacity = 8;
    UxVec* v = (UxVec*)calloc(1, sizeof(UxVec));
    if (!v) return NULL;
    v->data = (double*)calloc((size_t)capacity, sizeof(double));
    if (!v->data) { free(v); return NULL; }
    v->n = 0;
    v->cap = capacity;
    return v;
}

UXMATH_API void uxmath_vec_free(void* h) {
    UxVec* v = as_vec(h);
    if (!v) return;
    free(v->data);
    free(v);
}

UXMATH_API int uxmath_vec_push(void* h, double val) {
    UxVec* v = as_vec(h);
    if (!v) return 0;
    if (!ensure_vec(v, v->n + 1)) return 0;
    v->data[v->n++] = val;
    return 1;
}

UXMATH_API int uxmath_vec_set(void* h, int idx, double val) {
    UxVec* v = as_vec(h);
    if (!v || idx < 0) return 0;
    if (!ensure_vec(v, idx + 1)) return 0;
    v->data[idx] = val;
    if (idx >= v->n) v->n = idx + 1;
    return 1;
}

UXMATH_API double uxmath_vec_get(void* h, int idx) {
    UxVec* v = as_vec(h);
    if (!v || idx < 0 || idx >= v->n) return NAN;
    return v->data[idx];
}

UXMATH_API int uxmath_vec_count(void* h) {
    UxVec* v = as_vec(h);
    return v ? v->n : 0;
}

UXMATH_API int uxmath_vec_clear(void* h) {
    UxVec* v = as_vec(h);
    if (!v) return 0;
    v->n = 0;
    return 1;
}

UXMATH_API double* uxmath_vec_data_ptr(void* h) {
    UxVec* v = as_vec(h);
    return v ? v->data : NULL;
}

UXMATH_API double uxmath_poly_eval(void* coeffs, double x) {
    UxVec* c = as_vec(coeffs);
    if (!c || c->n <= 0) return NAN;
    double acc = 0.0;
    for (int i = c->n - 1; i >= 0; --i) acc = acc * x + c->data[i];
    return acc;
}

UXMATH_API double uxmath_poly_derivative_eval(void* coeffs, double x) {
    UxVec* c = as_vec(coeffs);
    if (!c || c->n <= 1) return 0.0;
    double acc = 0.0;
    for (int i = c->n - 1; i >= 1; --i) acc = acc * x + ((double)i) * c->data[i];
    return acc;
}

UXMATH_API double uxmath_poly_integral_eval(void* coeffs, double a, double b) {
    UxVec* c = as_vec(coeffs);
    if (!c || c->n <= 0) return NAN;
    double sb = 0.0, sa = 0.0;
    double pb = b, pa = a;
    for (int i = 0; i < c->n; ++i) {
        double k = c->data[i] / (double)(i + 1);
        sb += k * pb;
        sa += k * pa;
        pb *= b;
        pa *= a;
    }
    return sb - sa;
}

UXMATH_API int uxmath_poly_derivative_coeff(void* coeffs, void* out_coeffs) {
    UxVec* c = as_vec(coeffs);
    UxVec* o = as_vec(out_coeffs);
    if (!c || !o) return 0;
    o->n = 0;
    if (c->n <= 1) return uxmath_vec_push(o, 0.0);
    for (int i = 1; i < c->n; ++i) if (!uxmath_vec_push(o, c->data[i] * (double)i)) return 0;
    return 1;
}

UXMATH_API int uxmath_poly_integral_coeff(void* coeffs, void* out_coeffs, double c0) {
    UxVec* c = as_vec(coeffs);
    UxVec* o = as_vec(out_coeffs);
    if (!c || !o) return 0;
    o->n = 0;
    if (!uxmath_vec_push(o, c0)) return 0;
    for (int i = 0; i < c->n; ++i) if (!uxmath_vec_push(o, c->data[i] / (double)(i + 1))) return 0;
    return 1;
}

UXMATH_API double uxmath_poly_bisection(void* coeffs, double a, double b, int max_iter, double tol) {
    if (max_iter <= 0) max_iter = 100;
    if (tol <= 0) tol = 1e-10;
    double fa = uxmath_poly_eval(coeffs, a);
    double fb = uxmath_poly_eval(coeffs, b);
    if (!isfinite(fa) || !isfinite(fb) || fa * fb > 0.0) return NAN;
    for (int i = 0; i < max_iter; ++i) {
        double m = 0.5 * (a + b);
        double fm = uxmath_poly_eval(coeffs, m);
        if (fabs(fm) < tol || fabs(b - a) < tol) return m;
        if (fa * fm <= 0.0) { b = m; fb = fm; }
        else { a = m; fa = fm; }
    }
    return 0.5 * (a + b);
}

UXMATH_API double uxmath_poly_newton(void* coeffs, double x0, int max_iter, double tol) {
    if (max_iter <= 0) max_iter = 50;
    if (tol <= 0) tol = 1e-10;
    double x = x0;
    for (int i = 0; i < max_iter; ++i) {
        double fx = uxmath_poly_eval(coeffs, x);
        double dfx = uxmath_poly_derivative_eval(coeffs, x);
        if (!isfinite(fx) || !isfinite(dfx) || fabs(dfx) < DBL_EPSILON) return NAN;
        double nx = x - fx / dfx;
        if (fabs(nx - x) < tol) return nx;
        x = nx;
    }
    return x;
}

UXMATH_API double uxmath_numeric_derivative_poly(void* coeffs, double x, double h) {
    if (h <= 0.0) h = 1e-6;
    return (uxmath_poly_eval(coeffs, x + h) - uxmath_poly_eval(coeffs, x - h)) / (2.0 * h);
}

UXMATH_API double uxmath_integrate_poly_simpson(void* coeffs, double a, double b, int n) {
    if (n < 2) n = 2;
    if (n % 2) n++;
    double h = (b - a) / (double)n;
    double s = uxmath_poly_eval(coeffs, a) + uxmath_poly_eval(coeffs, b);
    for (int i = 1; i < n; ++i) {
        double x = a + h * (double)i;
        s += (i % 2 ? 4.0 : 2.0) * uxmath_poly_eval(coeffs, x);
    }
    return s * h / 3.0;
}

static double logistic_f(double y, double r, double k) {
    return r * y * (1.0 - y / k);
}

UXMATH_API double uxmath_ode_rk4_logistic(double y0, double r, double k, double t0, double t1, int steps) {
    if (steps < 1 || k == 0.0) return NAN;
    double h = (t1 - t0) / (double)steps;
    double y = y0;
    for (int i = 0; i < steps; ++i) {
        double k1 = logistic_f(y, r, k);
        double k2 = logistic_f(y + 0.5 * h * k1, r, k);
        double k3 = logistic_f(y + 0.5 * h * k2, r, k);
        double k4 = logistic_f(y + h * k3, r, k);
        y += h * (k1 + 2.0 * k2 + 2.0 * k3 + k4) / 6.0;
    }
    return y;
}

UXMATH_API double uxmath_ode_euler_logistic(double y0, double r, double k, double t0, double t1, int steps) {
    if (steps < 1 || k == 0.0) return NAN;
    double h = (t1 - t0) / (double)steps;
    double y = y0;
    for (int i = 0; i < steps; ++i) y += h * logistic_f(y, r, k);
    return y;
}

UXMATH_API double uxmath_sigmoid(double x) {
    if (x >= 0.0) {
        double z = exp(-x);
        return 1.0 / (1.0 + z);
    }
    double z = exp(x);
    return z / (1.0 + z);
}
UXMATH_API double uxmath_dsigmoid_from_output(double y) { return y * (1.0 - y); }
UXMATH_API double uxmath_relu(double x) { return x > 0.0 ? x : 0.0; }
UXMATH_API double uxmath_drelu(double x) { return x > 0.0 ? 1.0 : 0.0; }
UXMATH_API double uxmath_tanh_act(double x) { return tanh(x); }
UXMATH_API double uxmath_dtanh_from_output(double y) { return 1.0 - y * y; }

UXMATH_API int uxmath_vec_softmax(void* src, void* dst) {
    UxVec* s = as_vec(src);
    UxVec* d = as_vec(dst);
    if (!s || !d || s->n <= 0) return 0;
    if (!ensure_vec(d, s->n)) return 0;
    d->n = s->n;
    double maxv = s->data[0];
    for (int i = 1; i < s->n; ++i) if (s->data[i] > maxv) maxv = s->data[i];
    double sum = 0.0;
    for (int i = 0; i < s->n; ++i) { d->data[i] = exp(s->data[i] - maxv); sum += d->data[i]; }
    if (sum == 0.0) return 0;
    for (int i = 0; i < s->n; ++i) d->data[i] /= sum;
    return 1;
}

UXMATH_API void* uxmath_mat_create(int rows, int cols) {
    if (rows < 1 || cols < 1) return NULL;
    UxMat* m = (UxMat*)calloc(1, sizeof(UxMat));
    if (!m) return NULL;
    m->rows = rows; m->cols = cols;
    m->data = (double*)calloc((size_t)rows * (size_t)cols, sizeof(double));
    if (!m->data) { free(m); return NULL; }
    return m;
}
UXMATH_API void uxmath_mat_free(void* h) {
    UxMat* m = as_mat(h);
    if (!m) return;
    free(m->data); free(m);
}
UXMATH_API int uxmath_mat_rows(void* h) { UxMat* m = as_mat(h); return m ? m->rows : 0; }
UXMATH_API int uxmath_mat_cols(void* h) { UxMat* m = as_mat(h); return m ? m->cols : 0; }
UXMATH_API int uxmath_mat_set(void* h, int row, int col, double v) {
    UxMat* m = as_mat(h);
    if (!m || row < 0 || col < 0 || row >= m->rows || col >= m->cols) return 0;
    m->data[mat_index(m,row,col)] = v;
    return 1;
}
UXMATH_API double uxmath_mat_get(void* h, int row, int col) {
    UxMat* m = as_mat(h);
    if (!m || row < 0 || col < 0 || row >= m->rows || col >= m->cols) return NAN;
    return m->data[mat_index(m,row,col)];
}
UXMATH_API int uxmath_mat_fill(void* h, double v) {
    UxMat* m = as_mat(h);
    if (!m) return 0;
    for (int i = 0; i < m->rows*m->cols; ++i) m->data[i] = v;
    return 1;
}
UXMATH_API int uxmath_mat_random_uniform(void* h, double lo, double hi, unsigned int seed) {
    UxMat* m = as_mat(h);
    if (!m) return 0;
    srand(seed);
    for (int i = 0; i < m->rows*m->cols; ++i) {
        double u = (double)rand() / (double)RAND_MAX;
        m->data[i] = lo + (hi - lo) * u;
    }
    return 1;
}
UXMATH_API int uxmath_mat_add(void* a_, void* b_, void* out_) {
    UxMat* a=as_mat(a_), *b=as_mat(b_), *o=as_mat(out_);
    if (!a||!b||!o||a->rows!=b->rows||a->cols!=b->cols||o->rows!=a->rows||o->cols!=a->cols) return 0;
    for (int i=0;i<a->rows*a->cols;++i) o->data[i]=a->data[i]+b->data[i];
    return 1;
}
UXMATH_API int uxmath_mat_sub(void* a_, void* b_, void* out_) {
    UxMat* a=as_mat(a_), *b=as_mat(b_), *o=as_mat(out_);
    if (!a||!b||!o||a->rows!=b->rows||a->cols!=b->cols||o->rows!=a->rows||o->cols!=a->cols) return 0;
    for (int i=0;i<a->rows*a->cols;++i) o->data[i]=a->data[i]-b->data[i];
    return 1;
}
UXMATH_API int uxmath_mat_mul(void* a_, void* b_, void* out_) {
    UxMat* a=as_mat(a_), *b=as_mat(b_), *o=as_mat(out_);
    if (!a||!b||!o||a->cols!=b->rows||o->rows!=a->rows||o->cols!=b->cols) return 0;
    for (int r=0;r<o->rows;++r) {
        for (int c=0;c<o->cols;++c) {
            double s=0.0;
            for (int k=0;k<a->cols;++k) s += a->data[r*a->cols+k] * b->data[k*b->cols+c];
            o->data[r*o->cols+c]=s;
        }
    }
    return 1;
}
UXMATH_API int uxmath_mat_transpose(void* a_, void* out_) {
    UxMat* a=as_mat(a_), *o=as_mat(out_);
    if (!a||!o||o->rows!=a->cols||o->cols!=a->rows) return 0;
    for (int r=0;r<a->rows;++r) for (int c=0;c<a->cols;++c) o->data[c*o->cols+r]=a->data[r*a->cols+c];
    return 1;
}
UXMATH_API int uxmath_mat_apply_sigmoid(void* a_, void* out_) {
    UxMat* a=as_mat(a_), *o=as_mat(out_);
    if (!a||!o||o->rows!=a->rows||o->cols!=a->cols) return 0;
    for (int i=0;i<a->rows*a->cols;++i) o->data[i]=uxmath_sigmoid(a->data[i]);
    return 1;
}
UXMATH_API int uxmath_mat_apply_relu(void* a_, void* out_) {
    UxMat* a=as_mat(a_), *o=as_mat(out_);
    if (!a||!o||o->rows!=a->rows||o->cols!=a->cols) return 0;
    for (int i=0;i<a->rows*a->cols;++i) o->data[i]=uxmath_relu(a->data[i]);
    return 1;
}
UXMATH_API int uxmath_mat_vec_mul(void* m_, void* v_, void* out_) {
    UxMat* m=as_mat(m_);
    UxVec* v=as_vec(v_);
    UxVec* o=as_vec(out_);
    if (!m||!v||!o||m->cols!=v->n) return 0;
    if (!ensure_vec(o, m->rows)) return 0;
    o->n = m->rows;
    for (int r=0;r<m->rows;++r) {
        double s=0.0;
        for (int c=0;c<m->cols;++c) s += m->data[r*m->cols+c]*v->data[c];
        o->data[r]=s;
    }
    return 1;
}
