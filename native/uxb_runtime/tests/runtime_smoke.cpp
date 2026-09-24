#include "../uxb_runtime.h"
#include <cstdio>
static int UXB_RT_CDECL callback(int slot, int input, int* output, void*) {
    if (output) *output = input * 2 + slot;
    return 1;
}
int main() {
    if (!uxb_rt_init()) return 10;
    if (!uxb_task_register(3, UXB_RT_TASK_PIPE, "PipeTest")) return 11;
    if (!uxb_task_set_callback(3, callback, nullptr)) return 12;
    int out=0;
    if (!uxb_pipe_run(3, 21, &out)) return 13;
    std::printf("PIPE=%d BACKEND=", out);
    char backend[128]{}; uxb_rt_backend(backend,128); std::puts(backend);
    uxb_rt_shutdown();
    return out==45 ? 0 : 14;
}
