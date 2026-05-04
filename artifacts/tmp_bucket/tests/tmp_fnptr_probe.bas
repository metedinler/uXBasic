Declare Function GetModuleHandleA Lib "kernel32" Alias "GetModuleHandleA" (ByVal lpModuleName As ZString Ptr) As Any Ptr
Declare Function GetProcAddress Lib "kernel32" Alias "GetProcAddress" (ByVal hModule As Any Ptr, ByVal lpProcName As ZString Ptr) As Any Ptr
Type FnNoArgCdecl As Function Cdecl () As Integer

Dim p As Any Ptr
p = GetProcAddress(GetModuleHandleA(StrPtr("kernel32.dll")), StrPtr("GetTickCount"))
Dim fn As FnNoArgCdecl
fn = p
Dim v As Integer
v = fn()
Print v
