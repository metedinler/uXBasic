#ifndef UXSTAT_H
#define UXSTAT_H

#include <stddef.h>

#ifdef _WIN32
  #ifdef UXSTAT_EXPORTS
    #define UXSTAT_API __declspec(dllexport)
  #else
    #define UXSTAT_API __declspec(dllimport)
  #endif
  #define UXSTAT_CDECL __cdecl
  #define UXSTAT_STDCALL __stdcall
#else
  #define UXSTAT_API
  #define UXSTAT_CDECL
  #define UXSTAT_STDCALL
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct UxbStatVectorF64 {
  double* data;
  unsigned char* missing;
  size_t length;
} UxbStatVectorF64;

typedef enum UxbStatErr {
  UXSTAT_OK = 0,
  UXSTAT_ERR_NULL = 1,
  UXSTAT_ERR_OOB = 2,
  UXSTAT_ERR_ALLOC = 3,
  UXSTAT_ERR_EMPTY = 4
} UxbStatErr;

UXSTAT_API int UXSTAT_CDECL uxb_vec_create_f64(size_t n, UxbStatVectorF64** out_vec);
UXSTAT_API int UXSTAT_CDECL uxb_vec_destroy_f64(UxbStatVectorF64* vec);
UXSTAT_API int UXSTAT_CDECL uxb_vec_set_f64(UxbStatVectorF64* vec, size_t idx, double value);
UXSTAT_API int UXSTAT_CDECL uxb_vec_get_f64(const UxbStatVectorF64* vec, size_t idx, double* out_value);
UXSTAT_API int UXSTAT_CDECL uxb_vec_set_missing(UxbStatVectorF64* vec, size_t idx, int is_missing);

UXSTAT_API int UXSTAT_CDECL uxb_stat_mean_f64(const UxbStatVectorF64* vec, double* out_mean);
UXSTAT_API int UXSTAT_CDECL uxb_stat_var_f64(const UxbStatVectorF64* vec, double* out_var);
UXSTAT_API int UXSTAT_CDECL uxb_stat_std_f64(const UxbStatVectorF64* vec, double* out_std);
UXSTAT_API int UXSTAT_CDECL uxb_stat_sem_f64(const UxbStatVectorF64* vec, double* out_sem);
UXSTAT_API int UXSTAT_CDECL uxb_stat_min_f64(const UxbStatVectorF64* vec, double* out_min);
UXSTAT_API int UXSTAT_CDECL uxb_stat_max_f64(const UxbStatVectorF64* vec, double* out_max);

UXSTAT_API int UXSTAT_STDCALL uxb_stat_mean_f64_stdcall(const UxbStatVectorF64* vec, double* out_mean);
UXSTAT_API int UXSTAT_STDCALL uxb_stat_var_f64_stdcall(const UxbStatVectorF64* vec, double* out_var);
UXSTAT_API int UXSTAT_STDCALL uxb_stat_std_f64_stdcall(const UxbStatVectorF64* vec, double* out_std);

#ifdef __cplusplus
}
#endif

#endif
