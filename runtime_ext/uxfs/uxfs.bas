#include once "../fb_common/uxb_fb_common.bi"
#include once "win/winbase.bi"

type UXFS_ENUM
 h as HANDLE
 data as WIN32_FIND_DATAA
 firstReady as long
 pattern as string
 currentName as string
end type
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048

private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function

public function uxfs_version alias "uxfs_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function

public function uxfs_exists alias "uxfs_exists" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 return iif(GetFileAttributesA(p)<>INVALID_FILE_ATTRIBUTES,1,0)
end function
public function uxfs_file_exists alias "uxfs_file_exists" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 dim as dword a=GetFileAttributesA(p)
 return iif(a<>INVALID_FILE_ATTRIBUTES and (a and FILE_ATTRIBUTE_DIRECTORY)=0,1,0)
end function
public function uxfs_directory_exists alias "uxfs_directory_exists" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 dim as dword a=GetFileAttributesA(p)
 return iif(a<>INVALID_FILE_ATTRIBUTES and (a and FILE_ATTRIBUTE_DIRECTORY)<>0,1,0)
end function
public function uxfs_create_directory alias "uxfs_create_directory" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 if CreateDirectoryA(p,0)<>0 then return 1
 if GetLastError()=ERROR_ALREADY_EXISTS then return uxfs_directory_exists(p)
 g_error=uxb_safe_error_text(GetLastError()):return 0
end function
public function uxfs_create_directories alias "uxfs_create_directories" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 dim as string s=*p
 uxb_ensure_parent(s & "\\x")
 return uxfs_create_directory(p)
end function
public function uxfs_delete_file alias "uxfs_delete_file" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 if DeleteFileA(p)=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return 0
 end if
 return 1
end function
public function uxfs_remove_directory alias "uxfs_remove_directory" (byval p as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 if RemoveDirectoryA(p)=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return 0
 end if
 return 1
end function
public function uxfs_copy_file alias "uxfs_copy_file" (byval src as zstring ptr,byval dst as zstring ptr,byval overwrite as long) as long UXB_EXPORT
 if src=0 or dst=0 then return 0
 dim as string d=*dst:uxb_ensure_parent(d)
 if CopyFileA(src,dst,iif(overwrite<>0,FALSE,TRUE))=0 then g_error=uxb_safe_error_text(GetLastError()):return 0
 return 1
end function
public function uxfs_move alias "uxfs_move" (byval src as zstring ptr,byval dst as zstring ptr,byval overwrite as long) as long UXB_EXPORT
 if src=0 or dst=0 then return 0
 dim as dword flags=MOVEFILE_COPY_ALLOWED
 if overwrite<>0 then flags or= MOVEFILE_REPLACE_EXISTING
 if MoveFileExA(src,dst,flags)=0 then g_error=uxb_safe_error_text(GetLastError()):return 0
 return 1
end function
public function uxfs_file_size alias "uxfs_file_size" (byval p as zstring ptr) as UXB_I64 UXB_EXPORT
 if p=0 then return -1
 dim as WIN32_FILE_ATTRIBUTE_DATA d
 if GetFileAttributesExA(p,GetFileExInfoStandard,@d)=0 then g_error=uxb_safe_error_text(GetLastError()):return -1
 return (culngint(d.nFileSizeHigh) shl 32) or d.nFileSizeLow
end function
public function uxfs_get_attributes alias "uxfs_get_attributes" (byval p as zstring ptr) as ulong UXB_EXPORT
 if p=0 then return INVALID_FILE_ATTRIBUTES
 return GetFileAttributesA(p)
end function
public function uxfs_set_attributes alias "uxfs_set_attributes" (byval p as zstring ptr,byval attrs as ulong) as long UXB_EXPORT
 if p=0 then return 0
 if SetFileAttributesA(p,attrs)=0 then
  g_error=uxb_safe_error_text(GetLastError())
  return 0
 end if
 return 1
end function
public function uxfs_read_all_text alias "uxfs_read_all_text" (byval p as zstring ptr) as zstring ptr UXB_EXPORT
 if p=0 then return put_text("")
 dim as integer f=freefile(),rc=open(*p for binary access read as #f)
 if rc<>0 then g_error="cannot open file":return put_text("")
 dim as longint n=lof(f):dim as string s=space(n)
 if n>0 then get #f,,s
 close #f
 return put_text(s)
end function
public function uxfs_write_all_text alias "uxfs_write_all_text" (byval p as zstring ptr,byval text as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 dim as string path=*p,s=uxb_copy_z(text)
 uxb_ensure_parent(path)
 dim as integer f=freefile(),rc=open(path for binary access write as #f)
 if rc<>0 then g_error="cannot open file":return 0
 if len(s)>0 then put #f,,s
 close #f
 return 1
end function
public function uxfs_append_text alias "uxfs_append_text" (byval p as zstring ptr,byval text as zstring ptr) as long UXB_EXPORT
 if p=0 then return 0
 dim as string path=*p,s=uxb_copy_z(text)
 uxb_ensure_parent(path)
 dim as integer f=freefile(),rc=open(path for append as #f)
 if rc<>0 then g_error="cannot open file":return 0
 print #f,s;
 close #f
 return 1
end function
public function uxfs_enum_open alias "uxfs_enum_open" (byval pattern as zstring ptr) as UXB_U64 UXB_EXPORT
 if pattern=0 then return 0
 dim as UXFS_ENUM ptr e=callocate(sizeof(UXFS_ENUM))
 if e=0 then return 0
 e->pattern=*pattern
 e->h=FindFirstFileA(pattern,@e->data)
 if e->h=INVALID_HANDLE_VALUE then
  g_error=uxb_safe_error_text(GetLastError())
  deallocate(e)
  return 0
 end if
 e->firstReady=1
 return uxb_ptr_to_handle(e)
end function
public function uxfs_enum_next alias "uxfs_enum_next" (byval h as UXB_U64) as long UXB_EXPORT
 dim as UXFS_ENUM ptr e=cptr(UXFS_ENUM ptr,uxb_handle_to_ptr(h))
 if e=0 then return 0
 dim as long ok
 if e->firstReady<>0 then e->firstReady=0:ok=1 else ok=FindNextFileA(e->h,@e->data)
 while ok<>0 and (e->data.cFileName="." or e->data.cFileName="..")
  ok=FindNextFileA(e->h,@e->data)
 wend
 if ok=0 then return 0
 e->currentName=e->data.cFileName
 return 1
end function
public function uxfs_enum_name alias "uxfs_enum_name" (byval h as UXB_U64) as zstring ptr UXB_EXPORT
 dim as UXFS_ENUM ptr e=cptr(UXFS_ENUM ptr,uxb_handle_to_ptr(h))
 if e=0 then return put_text("")
 return put_text(e->currentName)
end function
public function uxfs_enum_is_directory alias "uxfs_enum_is_directory" (byval h as UXB_U64) as long UXB_EXPORT
 dim as UXFS_ENUM ptr e=cptr(UXFS_ENUM ptr,uxb_handle_to_ptr(h))
 if e=0 then return 0
 return iif((e->data.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0,1,0)
end function
public function uxfs_enum_size alias "uxfs_enum_size" (byval h as UXB_U64) as UXB_U64 UXB_EXPORT
 dim as UXFS_ENUM ptr e=cptr(UXFS_ENUM ptr,uxb_handle_to_ptr(h))
 if e=0 then return 0
 return (culngint(e->data.nFileSizeHigh) shl 32) or e->data.nFileSizeLow
end function
public sub uxfs_enum_close alias "uxfs_enum_close" (byval h as UXB_U64) UXB_EXPORT
 dim as UXFS_ENUM ptr e=cptr(UXFS_ENUM ptr,uxb_handle_to_ptr(h))
 if e=0 then exit sub
 if e->h<>INVALID_HANDLE_VALUE then FindClose(e->h)
 deallocate(e)
end sub
public function uxfs_error alias "uxfs_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
