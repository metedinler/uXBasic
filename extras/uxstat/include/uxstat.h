#ifndef UXSTAT_H
#define UXSTAT_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) || defined(__CYGWIN__)
  #define UXSTAT_API __declspec(dllexport)
#else
  #define UXSTAT_API
#endif

UXSTAT_API int uxstat_ping(int value);
UXSTAT_API int uxstat_add_i32(int left, int right);

#ifdef __cplusplus
}
#endif

#endif
