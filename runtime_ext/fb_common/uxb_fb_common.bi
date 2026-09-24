#ifndef __UXB_FB_COMMON_BI__
#define __UXB_FB_COMMON_BI__
#include once "windows.bi"
#include once "crt/string.bi"

#macro UXB_EXPORT
    Export
#endmacro

type UXB_I64 as longint
type UXB_U64 as ulongint

declare function uxb_bool(byval v as long) as long
function uxb_bool(byval v as long) as long
    if v = 0 then return 0
    return 1
end function

public function uxfb_runtime_ready alias "uxfb_runtime_ready" () as long UXB_EXPORT
    return 1
end function

function uxb_ptr_to_handle(byval p as any ptr) as UXB_U64
    return culngint(p)
end function

function uxb_handle_to_ptr(byval h as UXB_U64) as any ptr
    return cptr(any ptr, h)
end function

function uxb_copy_z(byval p as zstring ptr) as string
    if p = 0 then return ""
    return *p
end function

function uxb_safe_error_text(byval code as dword) as string
    dim as zstring ptr msg = 0
    dim as dword flags = FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS
    dim as dword n = FormatMessageA(flags, 0, code, 0, cast(zstring ptr, @msg), 0, 0)
    if n = 0 or msg = 0 then return "Windows error " & str(code)
    dim as string result = trim(*msg, any !" \t\r\n")
    LocalFree(msg)
    return result
end function

function uxb_parent_dir(byref path as string) as string
    dim as integer i
    for i = len(path) to 1 step -1
        if mid(path, i, 1) = "\\" or mid(path, i, 1) = "/" then
            if i = 1 then return left(path, 1)
            return left(path, i - 1)
        end if
    next
    return ""
end function

function uxb_ensure_parent(byref path as string) as long
    dim as string p = uxb_parent_dir(path)
    if len(p) = 0 then return 1
    dim as string accum = ""
    dim as integer i, startPos = 1
    if len(p) >= 2 and mid(p,2,1) = ":" then
        accum = left(p,2) & "\\"
        startPos = 4
    elseif left(p,2) = "\\\\" then
        return 1
    end if
    for i = startPos to len(p)+1
        if i > len(p) or mid(p,i,1) = "\\" or mid(p,i,1) = "/" then
            dim as string part = mid(p,startPos,i-startPos)
            if len(part) > 0 then
                if len(accum)>0 and right(accum,1)<>"\\" then accum &= "\\"
                accum &= part
                if GetFileAttributesA(strptr(accum)) = INVALID_FILE_ATTRIBUTES then CreateDirectoryA(strptr(accum),0)
            end if
            startPos=i+1
        end if
    next
    return 1
end function
#endif
