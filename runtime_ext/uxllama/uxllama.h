#ifndef UXLLAMA_H
#define UXLLAMA_H
#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define UXLLAMA_API __declspec(dllexport)
#else
#define UXLLAMA_API
#endif

typedef unsigned long long uxllama_handle;

UXLLAMA_API int uxllama_version(void);
UXLLAMA_API uxllama_handle uxllama_create(void);
UXLLAMA_API void uxllama_free(uxllama_handle h);
UXLLAMA_API int uxllama_set_cli_path(uxllama_handle h, const char *path);
UXLLAMA_API int uxllama_set_model_path(uxllama_handle h, const char *path);
UXLLAMA_API int uxllama_set_threads(uxllama_handle h, int threads);
UXLLAMA_API int uxllama_set_context(uxllama_handle h, int ctx);
UXLLAMA_API int uxllama_set_predict(uxllama_handle h, int n_predict);
UXLLAMA_API int uxllama_set_temperature(uxllama_handle h, double temp);
UXLLAMA_API int uxllama_set_top_p(uxllama_handle h, double top_p);
UXLLAMA_API int uxllama_set_top_k(uxllama_handle h, int top_k);
UXLLAMA_API int uxllama_set_seed(uxllama_handle h, int seed);
UXLLAMA_API int uxllama_set_low_memory_profile(uxllama_handle h, int profile);
UXLLAMA_API int uxllama_model_exists(uxllama_handle h);
UXLLAMA_API int uxllama_prompt(uxllama_handle h, const char *prompt, char *out_buf, int out_bytes);
UXLLAMA_API int uxllama_prompt_file(uxllama_handle h, const char *prompt_file, char *out_buf, int out_bytes);
UXLLAMA_API int uxllama_last_error(uxllama_handle h, char *out_buf, int out_bytes);
UXLLAMA_API int uxllama_last_command(uxllama_handle h, char *out_buf, int out_bytes);

#ifdef __cplusplus
}
#endif
#endif
