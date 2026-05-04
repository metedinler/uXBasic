/* uXBasic generated x64 FFI resolver */
#include <windows.h>
#include <stdint.h>

extern void* __uxb_ffi_symptr_1;
extern void* __uxb_ffi_symptr_2;
extern void* __uxb_ffi_symptr_3;

static void uxb_resolve_one(void** target, const char* dll_name, const char* symbol_name) {
    if (!target || *target) return;
    HMODULE h = LoadLibraryA(dll_name);
    if (!h) return;
    *target = (void*)GetProcAddress(h, symbol_name);
}

__declspec(dllexport) void __uxb_ffi_resolve_all(void) {
    uxb_resolve_one(&__uxb_ffi_symptr_1, "KERNEL32.DLL", "GetTickCount");
    uxb_resolve_one(&__uxb_ffi_symptr_2, "KERNEL32.DLL", "Sleep");
    uxb_resolve_one(&__uxb_ffi_symptr_3, "KERNEL32.DLL", "GetTickCount");
}
