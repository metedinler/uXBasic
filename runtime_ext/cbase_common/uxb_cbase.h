#ifndef UXB_CBASE_H
#define UXB_CBASE_H

#include <stdint.h>
#include <stddef.h>

#if defined(_WIN32)
  #define UXB_EXPORT __declspec(dllexport)
  #define UXB_CALL __cdecl
#else
  #define UXB_EXPORT __attribute__((visibility("default")))
  #define UXB_CALL
#endif

#if defined(_MSC_VER)
  #define UXB_THREAD_LOCAL __declspec(thread)
#elif defined(__GNUC__)
  #define UXB_THREAD_LOCAL __thread
#else
  #define UXB_THREAD_LOCAL
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef uint64_t uxb_handle;
typedef int32_t  uxb_i32;
typedef uint32_t uxb_u32;
typedef int64_t  uxb_i64;
typedef uint64_t uxb_u64;
typedef double   uxb_f64;

#ifdef __cplusplus
}
#endif

#endif
