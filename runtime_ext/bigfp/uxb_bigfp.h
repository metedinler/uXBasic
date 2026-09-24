#ifndef UXB_BIGFP_H
#define UXB_BIGFP_H
#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllimport) int uxb_big_runtime_version(void);
__declspec(dllimport) int uxb_bigf_handle_size(void);
__declspec(dllimport) int uxb_bigd_handle_size(void);
__declspec(dllimport) int uxb_ball_handle_size(void);

__declspec(dllimport) void* uxb_bigf_init(int precision_bits);
__declspec(dllimport) void  uxb_bigf_free(void *handle);
__declspec(dllimport) int   uxb_bigf_precision(void *handle);
__declspec(dllimport) void  uxb_bigf_from_str(const char *src, void *handle);
__declspec(dllimport) void  uxb_bigf_to_str(void *handle, char *outBuf, int outBytes);
__declspec(dllimport) void  uxb_bigf_copy(void *src, void *outp);
__declspec(dllimport) void  uxb_bigf_add(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_bigf_sub(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_bigf_mul(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_bigf_div(void *a, void *b, void *outp);
__declspec(dllimport) int   uxb_bigf_cmp(void *a, void *b);

__declspec(dllimport) void* uxb_bigd_init(int decimal_digits);
__declspec(dllimport) void  uxb_bigd_free(void *handle);
__declspec(dllimport) int   uxb_bigd_precision_digits(void *handle);
__declspec(dllimport) void  uxb_bigd_from_str(const char *src, void *handle);
__declspec(dllimport) void  uxb_bigd_to_str(void *handle, char *outBuf, int outBytes);
__declspec(dllimport) void  uxb_bigd_copy(void *src, void *outp);
__declspec(dllimport) void  uxb_bigd_add(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_bigd_sub(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_bigd_mul(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_bigd_div(void *a, void *b, void *outp);
__declspec(dllimport) int   uxb_bigd_cmp(void *a, void *b);

__declspec(dllimport) void* uxb_ball_init(int precision_bits);
__declspec(dllimport) void  uxb_ball_free(void *handle);
__declspec(dllimport) int   uxb_ball_precision(void *handle);
__declspec(dllimport) void  uxb_ball_from_str(const char *src, void *handle);
__declspec(dllimport) void  uxb_ball_to_str(void *handle, char *outBuf, int outBytes);
__declspec(dllimport) void  uxb_ball_copy(void *src, void *outp);
__declspec(dllimport) void  uxb_ball_add(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_ball_sub(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_ball_mul(void *a, void *b, void *outp);
__declspec(dllimport) void  uxb_ball_div(void *a, void *b, void *outp);
__declspec(dllimport) int   uxb_ball_cmp_mid(void *a, void *b);

#ifdef __cplusplus
}
#endif
#endif
