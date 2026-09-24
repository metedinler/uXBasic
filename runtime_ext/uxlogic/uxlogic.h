#ifndef UXLOGIC_H
#define UXLOGIC_H

#include <stdint.h>

#if defined(_WIN32)
#  if defined(UXLOGIC_BUILD)
#    define UXLOGIC_API __declspec(dllexport)
#  else
#    define UXLOGIC_API __declspec(dllimport)
#  endif
#  define UXLOGIC_CALL __cdecl
#else
#  define UXLOGIC_API
#  define UXLOGIC_CALL
#endif

#ifdef __cplusplus
extern "C" {
#endif

UXLOGIC_API int UXLOGIC_CALL uxlogic_version(void);
UXLOGIC_API const char *UXLOGIC_CALL uxlogic_last_error(void);
UXLOGIC_API const char *UXLOGIC_CALL uxlogic_last_text(void);
UXLOGIC_API int UXLOGIC_CALL uxlogic_lua_load(const char *dll_path);
UXLOGIC_API uint64_t UXLOGIC_CALL uxlogic_lua_new(void);
UXLOGIC_API void UXLOGIC_CALL uxlogic_lua_close(uint64_t state);
UXLOGIC_API int UXLOGIC_CALL uxlogic_lua_do_string(uint64_t state, const char *code);
UXLOGIC_API int UXLOGIC_CALL uxlogic_lua_do_file(uint64_t state, const char *path);
UXLOGIC_API double UXLOGIC_CALL uxlogic_lua_get_number(uint64_t state, const char *name);
UXLOGIC_API const char *UXLOGIC_CALL uxlogic_lua_get_string(uint64_t state, const char *name);
UXLOGIC_API void UXLOGIC_CALL uxlogic_lua_set_number(uint64_t state, const char *name, double value);
UXLOGIC_API int UXLOGIC_CALL uxlogic_prolog_query(const char *script_path, const char *goal);
UXLOGIC_API int UXLOGIC_CALL uxlogic_prolog_query_ex(const char *swipl_path, const char *script_path, const char *goal);
UXLOGIC_API double UXLOGIC_CALL uxlogic_fuzzy_triangle(double x, double a, double b, double c);
UXLOGIC_API double UXLOGIC_CALL uxlogic_fuzzy_trapezoid(double x, double a, double b, double c, double d);
UXLOGIC_API double UXLOGIC_CALL uxlogic_fuzzy_and(double a, double b);
UXLOGIC_API double UXLOGIC_CALL uxlogic_fuzzy_or(double a, double b);
UXLOGIC_API double UXLOGIC_CALL uxlogic_fuzzy_not(double value);
UXLOGIC_API double UXLOGIC_CALL uxlogic_fuzzy_weighted(double value1, double weight1, double value2, double weight2);

#ifdef __cplusplus
}
#endif
#endif
