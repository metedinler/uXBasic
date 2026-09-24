#ifndef UXSCALAR_MODULE_H
#define UXSCALAR_MODULE_H

#include <stdint.h>

#if defined(_WIN32)
#define UXSCALAR_API __declspec(dllimport)
#else
#define UXSCALAR_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

UXSCALAR_API int32_t uxscalar_init(void);
UXSCALAR_API int32_t uxscalar_add(int32_t left_value, int32_t right_value);
UXSCALAR_API int32_t uxscalar_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif
