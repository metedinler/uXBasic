#include once "../fb_common/uxb_fb_common.bi"
#include once "win/shlwapi.bi"
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048
private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function

private function slashnorm(byref s as string) as string
 dim as string r=s
 for i as integer=1 to len(r)
  if mid(r,i,1)="/" then mid(r,i,1)="\\"
 next
 return r
end function

public function uxpath_version alias "uxpath_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function

public function uxpath_join alias "uxpath_join" (byval a as zstring ptr,byval b as zstring ptr) as zstring ptr UXB_EXPORT
 dim as string x=uxb_copy_z(a), y=uxb_copy_z(b)
 if len(x)=0 then return put_text(slashnorm(y))
 if len(y)=0 then return put_text(slashnorm(x))
 if right(x,1)<>"\\" and right(x,1)<>"/" then x &= "\\"
 do while left(y,1)="\\" or left(y,1)="/"
  y=mid(y,2)
 loop
 return put_text(slashnorm(x & y))
end function
public function uxpath_full alias "uxpath_full" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 if p=0 then return put_text("")
 dim as zstring*32768 b
 dim as dword n=GetFullPathNameA(p,32767,@b,0)
 if n=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return put_text("")
 end if
 return put_text(b)
end function

public function uxpath_normalize alias "uxpath_normalize" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 return uxpath_full(p)
end function

public function uxpath_is_absolute alias "uxpath_is_absolute" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 dim as string s=*p
 if len(s)>=3 and mid(s,2,1)=":" and (mid(s,3,1)="\\" or mid(s,3,1)="/") then return 1
 if left(s,2)="\\\\" then return 1
 return 0
end function
public function uxpath_filename alias "uxpath_filename" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 if p=0 then return put_text("")
 dim as string s=slashnorm(*p)
 for i as integer=len(s) to 1 step -1
  if mid(s,i,1)="\\" then return put_text(mid(s,i+1))
 next
 return put_text(s)
end function
public function uxpath_directory alias "uxpath_directory" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 if p=0 then return put_text("")
 return put_text(uxb_parent_dir(slashnorm(*p)))
end function
public function uxpath_extension alias "uxpath_extension" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 dim as string f=*uxpath_filename(p)
 for i as integer=len(f) to 1 step -1
  if mid(f,i,1)="." then return put_text(mid(f,i))
 next
 return put_text("")
end function
public function uxpath_stem alias "uxpath_stem" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 dim as string f=*uxpath_filename(p)
 for i as integer=len(f) to 1 step -1
  if mid(f,i,1)="." then return put_text(left(f,i-1))
 next
 return put_text(f)
end function
public function uxpath_change_extension alias "uxpath_change_extension" (byval p as zstring ptr,byval ext as zstring ptr) as zstring ptr UXB_EXPORT
 dim as string s=uxb_copy_z(p), e=uxb_copy_z(ext), d=*uxpath_directory(p), st=*uxpath_stem(p)
 if len(e)>0 and left(e,1)<>"." then e="." & e
 if len(d)=0 then return put_text(st & e)
 return put_text(d & "\\" & st & e)
end function
public function uxpath_has_extension alias "uxpath_has_extension" (byval p as zstring ptr,byval ext as zstring ptr) as long UXB_EXPORT
 dim as string a=lcase(*uxpath_extension(p)),b=lcase(uxb_copy_z(ext))
 if len(b)>0 and left(b,1)<>"." then b="." & b
 return iif(a=b,1,0)
end function
public function uxpath_combine3 alias "uxpath_combine3" (byval a as zstring ptr,byval b as zstring ptr,byval c as zstring ptr) as zstring ptr UXB_EXPORT
 dim as string t=*uxpath_join(a,b)
 return uxpath_join(strptr(t),c)
end function
public function uxpath_is_inside alias "uxpath_is_inside" (byval rootp as zstring ptr,byval childp as zstring ptr) as long UXB_EXPORT
 dim as string r=lcase(*uxpath_full(rootp)), c=lcase(*uxpath_full(childp))
 if len(r)=0 or len(c)=0 then return 0
 if right(r,1)<>"\\" then r &= "\\"
 return iif(left(c,len(r))=r,1,0)
end function
public function uxpath_error alias "uxpath_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
