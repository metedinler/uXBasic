#include "../include/uxstat.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

static int uxstat_check_index(const UxbStatVectorF64* vec, size_t idx) {
  if (!vec) return UXSTAT_ERR_NULL;
  if (idx >= vec->length) return UXSTAT_ERR_OOB;
  return UXSTAT_OK;
}

static size_t uxstat_count_valid(const UxbStatVectorF64* vec) {
  size_t i;
  size_t n = 0;
  for (i = 0; i < vec->length; ++i) {
    if (!vec->missing[i]) n++;
  }
  return n;
}

UXSTAT_API int UXSTAT_CDECL uxb_vec_create_f64(size_t n, UxbStatVectorF64** out_vec) {
  UxbStatVectorF64* vec;
  if (!out_vec) return UXSTAT_ERR_NULL;
  *out_vec = NULL;

  vec = (UxbStatVectorF64*)malloc(sizeof(UxbStatVectorF64));
  if (!vec) return UXSTAT_ERR_ALLOC;

  vec->data = (double*)calloc(n > 0 ? n : 1, sizeof(double));
  vec->missing = (unsigned char*)calloc(n > 0 ? n : 1, sizeof(unsigned char));
  vec->length = n;

  if (!vec->data || !vec->missing) {
    free(vec->data);
    free(vec->missing);
    free(vec);
    return UXSTAT_ERR_ALLOC;
  }

  *out_vec = vec;
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_vec_destroy_f64(UxbStatVectorF64* vec) {
  if (!vec) return UXSTAT_ERR_NULL;
  free(vec->data);
  free(vec->missing);
  vec->data = NULL;
  vec->missing = NULL;
  vec->length = 0;
  free(vec);
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_vec_set_f64(UxbStatVectorF64* vec, size_t idx, double value) {
  int st = uxstat_check_index(vec, idx);
  if (st != UXSTAT_OK) return st;
  vec->data[idx] = value;
  vec->missing[idx] = 0;
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_vec_get_f64(const UxbStatVectorF64* vec, size_t idx, double* out_value) {
  int st = uxstat_check_index(vec, idx);
  if (st != UXSTAT_OK) return st;
  if (!out_value) return UXSTAT_ERR_NULL;
  if (vec->missing[idx]) return UXSTAT_ERR_EMPTY;
  *out_value = vec->data[idx];
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_vec_set_missing(UxbStatVectorF64* vec, size_t idx, int is_missing) {
  int st = uxstat_check_index(vec, idx);
  if (st != UXSTAT_OK) return st;
  vec->missing[idx] = is_missing ? 1 : 0;
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_stat_mean_f64(const UxbStatVectorF64* vec, double* out_mean) {
  size_t i;
  size_t n;
  double sum = 0.0;
  if (!vec || !out_mean) return UXSTAT_ERR_NULL;
  n = uxstat_count_valid(vec);
  if (n == 0) return UXSTAT_ERR_EMPTY;
  for (i = 0; i < vec->length; ++i) {
    if (!vec->missing[i]) sum += vec->data[i];
  }
  *out_mean = sum / (double)n;
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_stat_var_f64(const UxbStatVectorF64* vec, double* out_var) {
  size_t i;
  size_t n = 0;
  double mean = 0.0;
  double m2 = 0.0;
  if (!vec || !out_var) return UXSTAT_ERR_NULL;

  for (i = 0; i < vec->length; ++i) {
    double x;
    double delta;
    double delta2;
    if (vec->missing[i]) continue;
    x = vec->data[i];
    n++;
    delta = x - mean;
    mean += delta / (double)n;
    delta2 = x - mean;
    m2 += delta * delta2;
  }

  if (n == 0) return UXSTAT_ERR_EMPTY;
  if (n == 1) {
    *out_var = 0.0;
    return UXSTAT_OK;
  }

  *out_var = m2 / (double)(n - 1);
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_stat_std_f64(const UxbStatVectorF64* vec, double* out_std) {
  double var = 0.0;
  int st;
  if (!out_std) return UXSTAT_ERR_NULL;
  st = uxb_stat_var_f64(vec, &var);
  if (st != UXSTAT_OK) return st;
  *out_std = sqrt(var);
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_stat_sem_f64(const UxbStatVectorF64* vec, double* out_sem) {
  double std = 0.0;
  size_t n;
  int st;
  if (!vec || !out_sem) return UXSTAT_ERR_NULL;
  n = uxstat_count_valid(vec);
  if (n == 0) return UXSTAT_ERR_EMPTY;
  st = uxb_stat_std_f64(vec, &std);
  if (st != UXSTAT_OK) return st;
  *out_sem = std / sqrt((double)n);
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_stat_min_f64(const UxbStatVectorF64* vec, double* out_min) {
  size_t i;
  int found = 0;
  double minv = 0.0;
  if (!vec || !out_min) return UXSTAT_ERR_NULL;
  for (i = 0; i < vec->length; ++i) {
    if (vec->missing[i]) continue;
    if (!found || vec->data[i] < minv) {
      minv = vec->data[i];
      found = 1;
    }
  }
  if (!found) return UXSTAT_ERR_EMPTY;
  *out_min = minv;
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_CDECL uxb_stat_max_f64(const UxbStatVectorF64* vec, double* out_max) {
  size_t i;
  int found = 0;
  double maxv = 0.0;
  if (!vec || !out_max) return UXSTAT_ERR_NULL;
  for (i = 0; i < vec->length; ++i) {
    if (vec->missing[i]) continue;
    if (!found || vec->data[i] > maxv) {
      maxv = vec->data[i];
      found = 1;
    }
  }
  if (!found) return UXSTAT_ERR_EMPTY;
  *out_max = maxv;
  return UXSTAT_OK;
}

UXSTAT_API int UXSTAT_STDCALL uxb_stat_mean_f64_stdcall(const UxbStatVectorF64* vec, double* out_mean) {
  return uxb_stat_mean_f64(vec, out_mean);
}

UXSTAT_API int UXSTAT_STDCALL uxb_stat_var_f64_stdcall(const UxbStatVectorF64* vec, double* out_var) {
  return uxb_stat_var_f64(vec, out_var);
}

UXSTAT_API int UXSTAT_STDCALL uxb_stat_std_f64_stdcall(const UxbStatVectorF64* vec, double* out_std) {
  return uxb_stat_std_f64(vec, out_std);
}
