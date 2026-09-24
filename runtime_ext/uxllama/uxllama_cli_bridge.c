#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uxllama.h"

#define UXLLAMA_MAGIC 0x55584C4C414D4131ULL
#define UXLLAMA_MAX_PATH 1024
#define UXLLAMA_MAX_ERR 2048
#define UXLLAMA_MAX_CMD 32700

typedef struct uxllama_ctx {
    unsigned long long magic;
    char cli_path[UXLLAMA_MAX_PATH];
    char model_path[UXLLAMA_MAX_PATH];
    int threads;
    int ctx_size;
    int n_predict;
    int top_k;
    int seed;
    double temp;
    double top_p;
    char last_error[UXLLAMA_MAX_ERR];
    char last_command[UXLLAMA_MAX_CMD];
} uxllama_ctx;

static uxllama_ctx *as_ctx(uxllama_handle h) {
    uxllama_ctx *c = (uxllama_ctx*)(uintptr_t)h;
    if (!c || c->magic != UXLLAMA_MAGIC) return NULL;
    return c;
}

static void set_error(uxllama_ctx *c, const char *msg) {
    if (!c) return;
    if (!msg) msg = "";
    snprintf(c->last_error, sizeof(c->last_error), "%s", msg);
}

static int copy_in(char *dst, int cap, const char *src) {
    if (!dst || cap <= 0) return 0;
    if (!src) src = "";
    snprintf(dst, (size_t)cap, "%s", src);
    return 1;
}

static int copy_out(char *dst, int cap, const char *src) {
    if (!dst || cap <= 0) return 0;
    if (!src) src = "";
    size_t n = strlen(src);
    if (n >= (size_t)cap) n = (size_t)cap - 1;
    memcpy(dst, src, n);
    dst[n] = 0;
    return (int)n;
}

static int file_exists(const char *path) {
    if (!path || !*path) return 0;
    DWORD a = GetFileAttributesA(path);
    return a != INVALID_FILE_ATTRIBUTES && !(a & FILE_ATTRIBUTE_DIRECTORY);
}

static void quote_arg(char *out, int cap, const char *arg) {
    int pos = 0;
    if (cap <= 0) return;
    out[pos++] = '"';
    for (const char *p = arg ? arg : ""; *p && pos < cap - 3; ++p) {
        if (*p == '"' || *p == '\\') out[pos++] = '\\';
        out[pos++] = *p;
    }
    if (pos < cap - 1) out[pos++] = '"';
    out[pos] = 0;
}

static int run_capture(uxllama_ctx *c, const char *cmd, char *out_buf, int out_bytes) {
    SECURITY_ATTRIBUTES sa;
    HANDLE rd = NULL, wr = NULL;
    STARTUPINFOA si;
    PROCESS_INFORMATION pi;
    char *cmdline = NULL;
    DWORD read_bytes;
    char tmp[4096];
    int total = 0;

    memset(&sa, 0, sizeof(sa));
    sa.nLength = sizeof(sa);
    sa.bInheritHandle = TRUE;
    sa.lpSecurityDescriptor = NULL;
    if (!CreatePipe(&rd, &wr, &sa, 0)) { set_error(c, "CreatePipe failed"); return 0; }
    SetHandleInformation(rd, HANDLE_FLAG_INHERIT, 0);

    memset(&si, 0, sizeof(si));
    memset(&pi, 0, sizeof(pi));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdOutput = wr;
    si.hStdError = wr;
    si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);

    cmdline = _strdup(cmd);
    if (!cmdline) { set_error(c, "out of memory"); CloseHandle(rd); CloseHandle(wr); return 0; }

    BOOL ok = CreateProcessA(NULL, cmdline, NULL, NULL, TRUE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi);
    free(cmdline);
    CloseHandle(wr);
    if (!ok) {
        DWORD e = GetLastError();
        char msg[256]; snprintf(msg, sizeof(msg), "CreateProcess failed: %lu", (unsigned long)e);
        set_error(c, msg);
        CloseHandle(rd);
        return 0;
    }

    if (out_buf && out_bytes > 0) out_buf[0] = 0;
    while (ReadFile(rd, tmp, sizeof(tmp)-1, &read_bytes, NULL) && read_bytes > 0) {
        tmp[read_bytes] = 0;
        if (out_buf && out_bytes > 1 && total < out_bytes - 1) {
            int room = out_bytes - 1 - total;
            int n = (int)read_bytes;
            if (n > room) n = room;
            memcpy(out_buf + total, tmp, (size_t)n);
            total += n;
            out_buf[total] = 0;
        }
    }
    CloseHandle(rd);
    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD code = 0; GetExitCodeProcess(pi.hProcess, &code);
    CloseHandle(pi.hProcess); CloseHandle(pi.hThread);
    if (code != 0) {
        char msg[256]; snprintf(msg, sizeof(msg), "llama-cli exit code: %lu", (unsigned long)code);
        set_error(c, msg);
        return 0;
    }
    set_error(c, "");
    return total;
}

static int build_command_common(uxllama_ctx *c, const char *prompt, const char *prompt_file, char *cmd, int cap) {
    char qcli[UXLLAMA_MAX_PATH + 8];
    char qmodel[UXLLAMA_MAX_PATH + 8];
    char qprompt[UXLLAMA_MAX_CMD];
    char qfile[UXLLAMA_MAX_PATH + 8];
    if (!file_exists(c->cli_path)) { set_error(c, "llama-cli.exe not found; set cli path or build llama.cpp"); return 0; }
    if (!file_exists(c->model_path)) { set_error(c, "GGUF model not found; set model path"); return 0; }
    quote_arg(qcli, sizeof(qcli), c->cli_path);
    quote_arg(qmodel, sizeof(qmodel), c->model_path);
    if (prompt_file && *prompt_file) {
        if (!file_exists(prompt_file)) { set_error(c, "prompt file not found"); return 0; }
        quote_arg(qfile, sizeof(qfile), prompt_file);
        snprintf(cmd, cap, "%s -m %s -f %s -n %d -t %d -c %d --temp %.6g --top-p %.6g --top-k %d --seed %d", qcli, qmodel, qfile, c->n_predict, c->threads, c->ctx_size, c->temp, c->top_p, c->top_k, c->seed);
    } else {
        if (!prompt) prompt = "";
        quote_arg(qprompt, sizeof(qprompt), prompt);
        snprintf(cmd, cap, "%s -m %s -p %s -n %d -t %d -c %d --temp %.6g --top-p %.6g --top-k %d --seed %d", qcli, qmodel, qprompt, c->n_predict, c->threads, c->ctx_size, c->temp, c->top_p, c->top_k, c->seed);
    }
    copy_in(c->last_command, sizeof(c->last_command), cmd);
    return 1;
}

int uxllama_version(void) { return 100; }

uxllama_handle uxllama_create(void) {
    uxllama_ctx *c = (uxllama_ctx*)calloc(1, sizeof(uxllama_ctx));
    if (!c) return 0;
    c->magic = UXLLAMA_MAGIC;
    copy_in(c->cli_path, sizeof(c->cli_path), "uxb\\dist\\runtime_ext\\deps\\uxllama\\llama-cli.exe");
    copy_in(c->model_path, sizeof(c->model_path), "");
    c->threads = 2; c->ctx_size = 1024; c->n_predict = 128; c->top_k = 40; c->seed = -1; c->temp = 0.70; c->top_p = 0.90;
    return (uxllama_handle)(uintptr_t)c;
}

void uxllama_free(uxllama_handle h) { uxllama_ctx *c = as_ctx(h); if (!c) return; c->magic = 0; free(c); }
int uxllama_set_cli_path(uxllama_handle h, const char *path) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; return copy_in(c->cli_path,sizeof(c->cli_path),path); }
int uxllama_set_model_path(uxllama_handle h, const char *path) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; return copy_in(c->model_path,sizeof(c->model_path),path); }
int uxllama_set_threads(uxllama_handle h, int v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; if(v<1)v=1; if(v>64)v=64; c->threads=v; return 1; }
int uxllama_set_context(uxllama_handle h, int v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; if(v<128)v=128; if(v>131072)v=131072; c->ctx_size=v; return 1; }
int uxllama_set_predict(uxllama_handle h, int v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; if(v<1)v=1; if(v>8192)v=8192; c->n_predict=v; return 1; }
int uxllama_set_temperature(uxllama_handle h, double v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; if(v<0)v=0; if(v>5)v=5; c->temp=v; return 1; }
int uxllama_set_top_p(uxllama_handle h, double v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; if(v<0.001)v=0.001; if(v>1)v=1; c->top_p=v; return 1; }
int uxllama_set_top_k(uxllama_handle h, int v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; if(v<0)v=0; if(v>10000)v=10000; c->top_k=v; return 1; }
int uxllama_set_seed(uxllama_handle h, int v) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; c->seed=v; return 1; }

int uxllama_set_low_memory_profile(uxllama_handle h, int profile) {
    uxllama_ctx*c=as_ctx(h); if(!c)return 0;
    if(profile <= 0) { c->threads=1; c->ctx_size=512; c->n_predict=64; c->temp=0.65; c->top_p=0.85; c->top_k=30; }
    else if(profile == 1) { c->threads=2; c->ctx_size=1024; c->n_predict=128; c->temp=0.70; c->top_p=0.90; c->top_k=40; }
    else { c->threads=4; c->ctx_size=2048; c->n_predict=256; c->temp=0.75; c->top_p=0.95; c->top_k=50; }
    return 1;
}

int uxllama_model_exists(uxllama_handle h) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; return file_exists(c->model_path); }
int uxllama_prompt(uxllama_handle h, const char *prompt, char *out_buf, int out_bytes) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; char cmd[UXLLAMA_MAX_CMD]; if(!build_command_common(c,prompt,NULL,cmd,sizeof(cmd)))return 0; return run_capture(c,cmd,out_buf,out_bytes); }
int uxllama_prompt_file(uxllama_handle h, const char *prompt_file, char *out_buf, int out_bytes) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; char cmd[UXLLAMA_MAX_CMD]; if(!build_command_common(c,NULL,prompt_file,cmd,sizeof(cmd)))return 0; return run_capture(c,cmd,out_buf,out_bytes); }
int uxllama_last_error(uxllama_handle h, char *out_buf, int out_bytes) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; return copy_out(out_buf,out_bytes,c->last_error); }
int uxllama_last_command(uxllama_handle h, char *out_buf, int out_bytes) { uxllama_ctx*c=as_ctx(h); if(!c)return 0; return copy_out(out_buf,out_bytes,c->last_command); }
