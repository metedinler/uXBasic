#include once "../fb_common/uxb_fb_common.bi"
#include once "win/objbase.bi"
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048
private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function
private function guid_text(byref g as GUID) as string
 return lcase("{" & hex(g.Data1,8) & "-" & hex(g.Data2,4) & "-" & hex(g.Data3,4) & "-" & hex(g.Data4(0),2) & hex(g.Data4(1),2) & "-" & hex(g.Data4(2),2) & hex(g.Data4(3),2) & hex(g.Data4(4),2) & hex(g.Data4(5),2) & hex(g.Data4(6),2) & hex(g.Data4(7),2) & "}")
end function
public function uxuuid_version alias "uxuuid_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function
public function uxuuid_new alias "uxuuid_new" () as zstring ptr UXB_EXPORT
 dim as GUID g
 if CoCreateGuid(@g)<>S_OK then return put_text("")
 return put_text(guid_text(g))
end function
public function uxuuid_nil alias "uxuuid_nil" () as zstring ptr UXB_EXPORT
 return put_text("{00000000-0000-0000-0000-000000000000}")
end function
public function uxuuid_is_valid alias "uxuuid_is_valid" (byval textPtr as zstring ptr) as long UXB_EXPORT
 if textPtr=0 then return 0
 dim as GUID g
 dim as wstring*128 ws=*textPtr
 return iif(CLSIDFromString(@ws,@g)=S_OK,1,0)
end function
public function uxuuid_normalize alias "uxuuid_normalize" (byval textPtr as zstring ptr) as zstring ptr UXB_EXPORT
 if textPtr=0 then return put_text("")
 dim as GUID g
 dim as wstring*128 ws=*textPtr
 if CLSIDFromString(@ws,@g)<>S_OK then
  g_error="invalid uuid"
  return put_text("")
 end if
 return put_text(guid_text(g))
end function
public function uxuuid_equal alias "uxuuid_equal" (byval a as zstring ptr,byval b as zstring ptr) as long UXB_EXPORT
 dim as string x=*uxuuid_normalize(a)
 if len(x)=0 then return 0
 dim as string y=*uxuuid_normalize(b)
 return iif(x=y,1,0)
end function
public function uxuuid_is_nil alias "uxuuid_is_nil" (byval textPtr as zstring ptr) as long UXB_EXPORT
 dim as string n=*uxuuid_normalize(textPtr)
 return iif(n="{00000000-0000-0000-0000-000000000000}",1,0)
end function
public function uxuuid_without_braces alias "uxuuid_without_braces" (byval textPtr as zstring ptr) as zstring ptr UXB_EXPORT
 dim as string n=*uxuuid_normalize(textPtr)
 if len(n)=38 then n=mid(n,2,36)
 return put_text(n)
end function
public function uxuuid_error alias "uxuuid_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
