/* ADIM44 BIGI runtime additions - GMP based.
   This is real runtime code, but it requires GMP headers/libs at build time.
   Do not pretend BIGI native runtime is available unless this compiles and links. */

#ifndef UXB_BIGI_GMP_H
#define UXB_BIGI_GMP_H

#if defined(_WIN32)
#define UXB_BIG_EXPORT __declspec(dllexport)
#else
#define UXB_BIG_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

UXB_BIG_EXPORT void* uxb_bigi_init(void);
UXB_BIG_EXPORT void  uxb_bigi_free(void* p);
UXB_BIG_EXPORT int   uxb_bigi_from_str(void* p, const char* s, int base);
UXB_BIG_EXPORT int   uxb_bigi_to_str(void* p, char* out, int out_len, int base);
UXB_BIG_EXPORT int   uxb_bigi_add(void* out, void* a, void* b);
UXB_BIG_EXPORT int   uxb_bigi_sub(void* out, void* a, void* b);
UXB_BIG_EXPORT int   uxb_bigi_mul(void* out, void* a, void* b);
UXB_BIG_EXPORT int   uxb_bigi_tdiv_q(void* out, void* a, void* b);
UXB_BIG_EXPORT int   uxb_bigi_mod(void* out, void* a, void* b);
UXB_BIG_EXPORT int   uxb_bigi_cmp(void* a, void* b);

UXB_BIG_EXPORT void* __uxb_rt_biginit(const char* kind, const char* value, int precision);
UXB_BIG_EXPORT int __uxb_rt_big_to_str(const char* kind, void* handle, char* out, int out_len);
UXB_BIG_EXPORT void __uxb_rt_big_free(const char* kind, void* handle);
UXB_BIG_EXPORT const char* __uxb_rt_biginit_text(const char* kind, const char* value, int precision);

#ifdef __cplusplus
}
#endif

#endif
