#include once "../fb_common/uxb_fb_common.bi"
type UXCONFIG_HANDLE
 path as string
end type
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048
private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function
public function uxconfig_version alias "uxconfig_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function
public function uxconfig_open alias "uxconfig_open" (byval p as zstring ptr) as UXB_U64 UXB_EXPORT
 if p=0 then return 0
 dim as UXCONFIG_HANDLE ptr h=new UXCONFIG_HANDLE
 h->path=*p
 uxb_ensure_parent(h->path)
 return uxb_ptr_to_handle(h)
end function
public sub uxconfig_close alias "uxconfig_close" (byval handle as UXB_U64) UXB_EXPORT
 dim as UXCONFIG_HANDLE ptr h=cptr(UXCONFIG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h<>0 then delete h
end sub
public function uxconfig_get_string alias "uxconfig_get_string" (byval handle as UXB_U64,byval section as zstring ptr,byval key as zstring ptr,byval defv as zstring ptr) as zstring ptr UXB_EXPORT
 dim as UXCONFIG_HANDLE ptr h=cptr(UXCONFIG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return put_text(uxb_copy_z(defv))
 dim as zstring ptr b=callocate(65536)
 if b=0 then return put_text(uxb_copy_z(defv))
 GetPrivateProfileStringA(section,key,defv,b,65535,strptr(h->path))
 dim as string s=*b
 deallocate(b)
 return put_text(s)
end function
public function uxconfig_get_i64 alias "uxconfig_get_i64" (byval handle as UXB_U64,byval section as zstring ptr,byval key as zstring ptr,byval defv as UXB_I64) as UXB_I64 UXB_EXPORT
 dim as string d=str(defv)
 dim as string s=*uxconfig_get_string(handle,section,key,strptr(d))
 return valint(s)
end function
public function uxconfig_get_f64 alias "uxconfig_get_f64" (byval handle as UXB_U64,byval section as zstring ptr,byval key as zstring ptr,byval defv as double) as double UXB_EXPORT
 dim as string d=str(defv)
 dim as string s=*uxconfig_get_string(handle,section,key,strptr(d))
 return val(s)
end function
public function uxconfig_get_bool alias "uxconfig_get_bool" (byval handle as UXB_U64,byval section as zstring ptr,byval key as zstring ptr,byval defv as long) as long UXB_EXPORT
 dim as string d=iif(defv<>0,"true","false"),s=lcase(trim(*uxconfig_get_string(handle,section,key,strptr(d))))
 return iif(s="1" or s="true" or s="yes" or s="on",1,0)
end function
public function uxconfig_set_string alias "uxconfig_set_string" (byval handle as UXB_U64,byval section as zstring ptr,byval key as zstring ptr,byval value as zstring ptr) as long UXB_EXPORT
 dim as UXCONFIG_HANDLE ptr h=cptr(UXCONFIG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return 0
 if WritePrivateProfileStringA(section,key,value,strptr(h->path))=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return 0
 end if
 return 1
end function
public function uxconfig_set_i64 alias "uxconfig_set_i64" (byval h as UXB_U64,byval s as zstring ptr,byval k as zstring ptr,byval v as UXB_I64) as long UXB_EXPORT
 dim as string t=str(v)
 return uxconfig_set_string(h,s,k,strptr(t))
end function
public function uxconfig_set_f64 alias "uxconfig_set_f64" (byval h as UXB_U64,byval s as zstring ptr,byval k as zstring ptr,byval v as double) as long UXB_EXPORT
 dim as string t=str(v)
 return uxconfig_set_string(h,s,k,strptr(t))
end function
public function uxconfig_set_bool alias "uxconfig_set_bool" (byval h as UXB_U64,byval s as zstring ptr,byval k as zstring ptr,byval v as long) as long UXB_EXPORT
 dim as string t=iif(v<>0,"true","false")
 return uxconfig_set_string(h,s,k,strptr(t))
end function
public function uxconfig_delete_key alias "uxconfig_delete_key" (byval h as UXB_U64,byval s as zstring ptr,byval k as zstring ptr) as long UXB_EXPORT
 return uxconfig_set_string(h,s,k,0)
end function
public function uxconfig_delete_section alias "uxconfig_delete_section" (byval handle as UXB_U64,byval section as zstring ptr) as long UXB_EXPORT
 dim as UXCONFIG_HANDLE ptr h=cptr(UXCONFIG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return 0
 return iif(WritePrivateProfileStringA(section,0,0,strptr(h->path))<>0,1,0)
end function
public function uxconfig_has_key alias "uxconfig_has_key" (byval h as UXB_U64,byval s as zstring ptr,byval k as zstring ptr) as long UXB_EXPORT
 dim as string marker="{UXB_MISSING_7D91}"
 dim as string v=*uxconfig_get_string(h,s,k,strptr(marker))
 return iif(v<>marker,1,0)
end function
public function uxconfig_path alias "uxconfig_path" (byval handle as UXB_U64) as zstring ptr UXB_EXPORT
 dim as UXCONFIG_HANDLE ptr h=cptr(UXCONFIG_HANDLE ptr,uxb_handle_to_ptr(handle))
 if h=0 then return put_text("")
 return put_text(h->path)
end function
public function uxconfig_error alias "uxconfig_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
