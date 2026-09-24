#include once "../fb_common/uxb_fb_common.bi"
#include once "win/winbase.bi"
#include once "win/winnt.bi"

static shared g_text as zstring * 65536
static shared g_error as zstring * 2048

extern "windows-ms"
    declare function IsUserAnAdmin lib "shell32" alias "IsUserAnAdmin" () as long
    declare function GetTickCount64 lib "kernel32" alias "GetTickCount64" () as ulongint
end extern

private function put_text(byref s as string) as zstring ptr
    g_text = left(s, 65535)
    return strptr(g_text)
end function

public function uxsystem_version alias "uxsystem_version" () as zstring ptr UXB_EXPORT
    return put_text("1.0.0")
end function

public function uxsystem_computer_name alias "uxsystem_computer_name" () as zstring ptr UXB_EXPORT
    dim as zstring*512 b
    dim as dword n=511
    if GetComputerNameA(@b,@n)=0 then g_error=uxb_safe_error_text(GetLastError()): return put_text("")
    return put_text(b)
end function

public function uxsystem_user_name alias "uxsystem_user_name" () as zstring ptr UXB_EXPORT
    dim as zstring*512 b
    dim as dword n=511
    if GetUserNameA(@b,@n)=0 then g_error=uxb_safe_error_text(GetLastError()): return put_text("")
    return put_text(b)
end function

public function uxsystem_windows_directory alias "uxsystem_windows_directory" () as zstring ptr UXB_EXPORT
    dim as zstring*32768 b
    dim as uint n=GetWindowsDirectoryA(@b,32767)
    if n=0 then g_error=uxb_safe_error_text(GetLastError()): return put_text("")
    return put_text(b)
end function

public function uxsystem_system_directory alias "uxsystem_system_directory" () as zstring ptr UXB_EXPORT
    dim as zstring*32768 b
    dim as uint n=GetSystemDirectoryA(@b,32767)
    if n=0 then g_error=uxb_safe_error_text(GetLastError()): return put_text("")
    return put_text(b)
end function

public function uxsystem_temp_directory alias "uxsystem_temp_directory" () as zstring ptr UXB_EXPORT
    dim as zstring*32768 b
    dim as zstring*8 tempKey = "TEMP"
    dim as zstring*8 tmpKey = "TMP"
    dim as dword n=GetEnvironmentVariableA(@tempKey,@b,32767)
    if n=0 then n=GetEnvironmentVariableA(@tmpKey,@b,32767)
    if n=0 then return put_text("C:\Windows\Temp")
    return put_text(b)
end function

public function uxsystem_current_directory alias "uxsystem_current_directory" () as zstring ptr UXB_EXPORT
    return put_text(curdir())
end function

public function uxsystem_set_current_directory alias "uxsystem_set_current_directory" (byval p as zstring ptr) as long UXB_EXPORT
    if p=0 then return 0
    if SetCurrentDirectoryA(p)=0 then g_error=uxb_safe_error_text(GetLastError()): return 0
    return 1
end function

public function uxsystem_executable_path alias "uxsystem_executable_path" () as zstring ptr UXB_EXPORT
    dim as zstring*32768 b
    dim as dword n=GetModuleFileNameA(0,@b,32767)
    if n=0 then g_error=uxb_safe_error_text(GetLastError()): return put_text("")
    return put_text(b)
end function

public function uxsystem_environment_get alias "uxsystem_environment_get" (byval keyName as zstring ptr) as zstring ptr UXB_EXPORT
    if keyName=0 then return put_text("")
    dim as dword n=GetEnvironmentVariableA(keyName,0,0)
    if n=0 then return put_text("")
    dim as zstring ptr b=callocate(n+1)
    if b=0 then g_error="out of memory":return put_text("")
    GetEnvironmentVariableA(keyName,b,n+1)
    dim as string s=*b
    deallocate(b)
    return put_text(s)
end function

public function uxsystem_environment_set alias "uxsystem_environment_set" (byval keyName as zstring ptr, byval valueText as zstring ptr) as long UXB_EXPORT
    if keyName=0 then return 0
    if SetEnvironmentVariableA(keyName,valueText)=0 then g_error=uxb_safe_error_text(GetLastError()):return 0
    return 1
end function

public function uxsystem_environment_delete alias "uxsystem_environment_delete" (byval keyName as zstring ptr) as long UXB_EXPORT
    if keyName=0 then return 0
    if SetEnvironmentVariableA(keyName,0)=0 then g_error=uxb_safe_error_text(GetLastError()):return 0
    return 1
end function

public function uxsystem_cpu_count alias "uxsystem_cpu_count" () as long UXB_EXPORT
    dim as SYSTEM_INFO si
    GetNativeSystemInfo(@si)
    return si.dwNumberOfProcessors
end function

public function uxsystem_architecture alias "uxsystem_architecture" () as long UXB_EXPORT
    dim as SYSTEM_INFO si
    GetNativeSystemInfo(@si)
    return si.wProcessorArchitecture
end function

public function uxsystem_memory_total alias "uxsystem_memory_total" () as UXB_U64 UXB_EXPORT
    dim as MEMORYSTATUSEX m
    m.dwLength=sizeof(m)
    if GlobalMemoryStatusEx(@m)=0 then g_error=uxb_safe_error_text(GetLastError()):return 0
    return m.ullTotalPhys
end function

public function uxsystem_memory_available alias "uxsystem_memory_available" () as UXB_U64 UXB_EXPORT
    dim as MEMORYSTATUSEX m
    m.dwLength=sizeof(m)
    if GlobalMemoryStatusEx(@m)=0 then g_error=uxb_safe_error_text(GetLastError()):return 0
    return m.ullAvailPhys
end function

public function uxsystem_memory_load_percent alias "uxsystem_memory_load_percent" () as long UXB_EXPORT
    dim as MEMORYSTATUSEX m
    m.dwLength=sizeof(m)
    if GlobalMemoryStatusEx(@m)=0 then return -1
    return m.dwMemoryLoad
end function

public function uxsystem_is_64bit alias "uxsystem_is_64bit" () as long UXB_EXPORT
    return iif(sizeof(any ptr)=8,1,0)
end function

public function uxsystem_is_admin alias "uxsystem_is_admin" () as long UXB_EXPORT
    return uxb_bool(IsUserAnAdmin())
end function

public function uxsystem_process_id alias "uxsystem_process_id" () as ulong UXB_EXPORT
    return GetCurrentProcessId()
end function

public function uxsystem_thread_id alias "uxsystem_thread_id" () as ulong UXB_EXPORT
    return GetCurrentThreadId()
end function

public function uxsystem_tick_count_ms alias "uxsystem_tick_count_ms" () as UXB_U64 UXB_EXPORT
    return GetTickCount64()
end function

public function uxsystem_screen_width alias "uxsystem_screen_width" () as long UXB_EXPORT
    return GetSystemMetrics(SM_CXSCREEN)
end function

public function uxsystem_screen_height alias "uxsystem_screen_height" () as long UXB_EXPORT
    return GetSystemMetrics(SM_CYSCREEN)
end function

public function uxsystem_error alias "uxsystem_error" () as zstring ptr UXB_EXPORT
    return put_text(g_error)
end function
