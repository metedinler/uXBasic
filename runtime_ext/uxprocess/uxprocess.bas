#include once "../fb_common/uxb_fb_common.bi"
#include once "win/shellapi.bi"
type UXPROCESS_HANDLE
 processHandle as HANDLE
 threadHandle as HANDLE
 processId as dword
 exitCode as dword
end type
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048
private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function

public function uxprocess_version alias "uxprocess_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function

public function uxprocess_start alias "uxprocess_start" (byval commandText as zstring ptr,byval workDir as zstring ptr,byval hiddenFlag as long) as UXB_U64 UXB_EXPORT
 if commandText=0 then return 0
 dim as STARTUPINFOA si
 dim as PROCESS_INFORMATION pi
 si.cb=sizeof(si)
 if hiddenFlag<>0 then
  si.dwFlags=STARTF_USESHOWWINDOW
  si.wShowWindow=SW_HIDE
 end if
 dim as string cmd=*commandText
 dim as zstring ptr mutable=callocate(len(cmd)+2)
 *mutable=cmd
 dim as long ok=CreateProcessA(0,mutable,0,0,FALSE,CREATE_UNICODE_ENVIRONMENT,0,workDir,@si,@pi)
 deallocate(mutable)
 if ok=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return 0
 end if
 dim as UXPROCESS_HANDLE ptr h=callocate(sizeof(UXPROCESS_HANDLE))
 if h=0 then
  CloseHandle(pi.hThread)
  CloseHandle(pi.hProcess)
  return 0
 end if
 h->processHandle=pi.hProcess
 h->threadHandle=pi.hThread
 h->processId=pi.dwProcessId
 h->exitCode=STILL_ACTIVE
 return uxb_ptr_to_handle(h)
end function
public function uxprocess_wait alias "uxprocess_wait" (byval handle as UXB_U64,byval timeoutMs as ulong) as long UXB_EXPORT
 dim as UXPROCESS_HANDLE ptr h=cptr(UXPROCESS_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return -1
 dim as dword r=WaitForSingleObject(h->processHandle,timeoutMs)
 if r=WAIT_OBJECT_0 then
  GetExitCodeProcess(h->processHandle,@h->exitCode)
  return 1
 end if
 if r=WAIT_TIMEOUT then return 0
 g_error=uxb_safe_error_text(GetLastError())
 return -1
end function
public function uxprocess_is_running alias "uxprocess_is_running" (byval handle as UXB_U64) as long UXB_EXPORT
 dim as UXPROCESS_HANDLE ptr h=cptr(UXPROCESS_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return 0
 dim as dword c
 if GetExitCodeProcess(h->processHandle,@c)=0 then return 0
 h->exitCode=c
 return iif(c=STILL_ACTIVE,1,0)
end function
public function uxprocess_exit_code alias "uxprocess_exit_code" (byval handle as UXB_U64) as long UXB_EXPORT
 dim as UXPROCESS_HANDLE ptr h=cptr(UXPROCESS_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return -1
 GetExitCodeProcess(h->processHandle,@h->exitCode)
 return h->exitCode
end function
public function uxprocess_id alias "uxprocess_id" (byval handle as UXB_U64) as ulong UXB_EXPORT
 dim as UXPROCESS_HANDLE ptr h=cptr(UXPROCESS_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return 0
 return h->processId
end function
public function uxprocess_kill alias "uxprocess_kill" (byval handle as UXB_U64,byval code as ulong) as long UXB_EXPORT
 dim as UXPROCESS_HANDLE ptr h=cptr(UXPROCESS_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return 0
 if TerminateProcess(h->processHandle,code)=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return 0
 end if
 return 1
end function
public sub uxprocess_close alias "uxprocess_close" (byval handle as UXB_U64) UXB_EXPORT
 dim as UXPROCESS_HANDLE ptr h=cptr(UXPROCESS_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then exit sub
 if h->threadHandle<>0 then CloseHandle(h->threadHandle)
 if h->processHandle<>0 then CloseHandle(h->processHandle)
 deallocate(h)
end sub
public function uxprocess_shell_open alias "uxprocess_shell_open" (byval target as zstring ptr,byval params as zstring ptr,byval workDir as zstring ptr,byval showCmd as long) as long UXB_EXPORT
 if target=0 then return 0
 dim as HINSTANCE r=ShellExecuteA(0,"open",target,params,workDir,showCmd)
 return iif(culngint(r)>32,1,0)
end function
public function uxprocess_run_wait alias "uxprocess_run_wait" (byval commandText as zstring ptr,byval workDir as zstring ptr,byval hiddenFlag as long,byval timeoutMs as ulong) as long UXB_EXPORT
 dim as UXB_U64 h=uxprocess_start(commandText,workDir,hiddenFlag)
 if h=0 then return -1
 dim as long w=uxprocess_wait(h,timeoutMs)
 dim as long c=-1
 if w=1 then c=uxprocess_exit_code(h)
 uxprocess_close(h)
 return c
end function
public function uxprocess_current_id alias "uxprocess_current_id" () as ulong UXB_EXPORT
 return GetCurrentProcessId()
end function

public function uxprocess_error alias "uxprocess_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
