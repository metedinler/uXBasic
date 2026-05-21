#ifndef UXB_FP128_H
#define UXB_FP128_H

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllimport) int  uxb_f128_size(void);
__declspec(dllimport) int  uxb_f128_storage_size(void);
__declspec(dllimport) void uxb_f128_zero(void *outp);
__declspec(dllimport) void uxb_f128_from_str(const char *src, void *outp);
__declspec(dllimport) void uxb_f128_to_str(const void *a, char *outBuf, int outBytes);
__declspec(dllimport) void uxb_f128_copy(const void *src, void *outp);
__declspec(dllimport) void uxb_f128_add(const void *a, const void *b, void *outp);
__declspec(dllimport) void uxb_f128_sub(const void *a, const void *b, void *outp);
__declspec(dllimport) void uxb_f128_mul(const void *a, const void *b, void *outp);
__declspec(dllimport) void uxb_f128_div(const void *a, const void *b, void *outp);
__declspec(dllimport) int  uxb_f128_cmp(const void *a, const void *b);

#ifdef __cplusplus
}
#endif

#endif
