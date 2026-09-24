#include once "../fb_common/uxb_fb_common.bi"
type UXLOG_HANDLE
 fileNo as integer
 path as string
 minLevel as long
 rotateBytes as UXB_U64
end type
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048
private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function

private function level_name(byval l as long) as string
 select case l
 case 0
  return "TRACE"
 case 1
  return "DEBUG"
 case 2
  return "INFO"
 case 3
  return "WARN"
 case 4
  return "ERROR"
 case 5
  return "FATAL"
 case else
  return "LOG"
 end select
end function

private function stamp() as string
 return date & " " & time
end function

private function path_size(byref p as string) as UXB_U64
 dim as integer f=freefile()
 if open(p for binary access read as #f)<>0 then return 0
 dim as UXB_U64 n=lof(f)
 close #f
 return n
end function

private sub rotate_if_needed(byval h as UXLOG_HANDLE ptr)
 if h=0 or h->rotateBytes=0 then exit sub
 close #h->fileNo
 if path_size(h->path)>=h->rotateBytes then
  dim as string bak=h->path & ".1"
  if len(dir(bak))>0 then kill bak
  name h->path as bak
 end if
 h->fileNo=freefile()
 open h->path for append as #h->fileNo
end sub
public function uxlog_version alias "uxlog_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function

public function uxlog_open alias "uxlog_open" (byval p as zstring ptr,byval minLevel as long,byval rotateBytes as UXB_U64) as UXB_U64 UXB_EXPORT
 if p=0 then return 0
 dim as UXLOG_HANDLE ptr h=new UXLOG_HANDLE
 h->path=*p
 h->minLevel=minLevel
 h->rotateBytes=rotateBytes
 uxb_ensure_parent(h->path)
 h->fileNo=freefile()
 if open(h->path for append as #h->fileNo)<>0 then
  g_error="cannot open log"
  delete h
  return 0
 end if
 return uxb_ptr_to_handle(h)
end function
public function uxlog_write alias "uxlog_write" (byval handle as UXB_U64,byval level as long,byval message as zstring ptr) as long UXB_EXPORT
 dim as UXLOG_HANDLE ptr h=cptr(UXLOG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 or message=0 then return 0
 if level<h->minLevel then return 1
 rotate_if_needed(h)
 print #h->fileNo,"[" & stamp() & "] [" & level_name(level) & "] " & *message
 return 1
end function
public function uxlog_trace alias "uxlog_trace" (byval h as UXB_U64,byval m as zstring ptr) as long UXB_EXPORT
 return uxlog_write(h,0,m)
end function
public function uxlog_debug alias "uxlog_debug" (byval h as UXB_U64,byval m as zstring ptr) as long UXB_EXPORT
 return uxlog_write(h,1,m)
end function
public function uxlog_info alias "uxlog_info" (byval h as UXB_U64,byval m as zstring ptr) as long UXB_EXPORT
 return uxlog_write(h,2,m)
end function
public function uxlog_warning alias "uxlog_warning" (byval h as UXB_U64,byval m as zstring ptr) as long UXB_EXPORT
 return uxlog_write(h,3,m)
end function
public function uxlog_error_write alias "uxlog_error_write" (byval h as UXB_U64,byval m as zstring ptr) as long UXB_EXPORT
 return uxlog_write(h,4,m)
end function
public function uxlog_fatal alias "uxlog_fatal" (byval h as UXB_U64,byval m as zstring ptr) as long UXB_EXPORT
 return uxlog_write(h,5,m)
end function
public function uxlog_set_level alias "uxlog_set_level" (byval handle as UXB_U64,byval level as long) as long UXB_EXPORT
 dim as UXLOG_HANDLE ptr h=cptr(UXLOG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return 0
 h->minLevel=level
 return 1
end function
public sub uxlog_flush alias "uxlog_flush" (byval handle as UXB_U64) UXB_EXPORT
 dim as UXLOG_HANDLE ptr h=cptr(UXLOG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then exit sub
 close #h->fileNo
 h->fileNo=freefile()
 open h->path for append as #h->fileNo
end sub
public sub uxlog_close alias "uxlog_close" (byval handle as UXB_U64) UXB_EXPORT
 dim as UXLOG_HANDLE ptr h=cptr(UXLOG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then exit sub
 close #h->fileNo
 delete h
end sub
public function uxlog_last_error alias "uxlog_last_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
