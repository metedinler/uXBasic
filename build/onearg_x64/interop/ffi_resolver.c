/* uXBasic generated x64 FFI resolver */
#include <windows.h>
#include <stdint.h>

extern void* __uxb_ffi_symptr_1;

static void uxb_resolve_one(void** target, const char* dll_name, const char* symbol_name) {
    if (!target || *target) return;
    HMODULE h = LoadLibraryA(dll_name);
    if (!h) return;
    *target = (void*)GetProcAddress(h, symbol_name);
}

__declspec(dllexport) void __uxb_ffi_resolve_all(void) {
    uxb_resolve_one(&__uxb_ffi_symptr_1, "USER32.DLL", "GetSystemMetrics");
}
