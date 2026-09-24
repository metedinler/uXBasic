#include once "../fb_common/uxb_fb_common.bi"
static shared g_text as zstring * 65536
static shared g_error as zstring * 2048
private function put_text(byref s as string) as zstring ptr
 g_text = left(s, 65535)
 return strptr(g_text)
end function

private function ft_to_i64(byref ft as FILETIME) as UXB_U64
 return (culngint(ft.dwHighDateTime) shl 32) or ft.dwLowDateTime
end function

private sub i64_to_ft(byval v as UXB_U64,byref ft as FILETIME)
 ft.dwLowDateTime=v and &hFFFFFFFF
 ft.dwHighDateTime=v shr 32
end sub

private function pad_left(byval numberValue as long, byval digitCount as long) as string
 dim as string resultText=ltrim(str(numberValue))
 do while len(resultText)<digitCount
  resultText="0" & resultText
 loop
 return resultText
end function

public function uxdatetime_version alias "uxdatetime_version" () as zstring ptr UXB_EXPORT
 return put_text("1.0.0")
end function
public function uxdatetime_unix_ms_utc alias "uxdatetime_unix_ms_utc" () as UXB_I64 UXB_EXPORT
 dim as FILETIME ft
 GetSystemTimeAsFileTime(@ft)
 return (ft_to_i64(ft)-116444736000000000ull)\10000ull
end function
public function uxdatetime_filetime_utc alias "uxdatetime_filetime_utc" () as UXB_U64 UXB_EXPORT
 dim as FILETIME ft
 GetSystemTimeAsFileTime(@ft)
 return ft_to_i64(ft)
end function
public function uxdatetime_monotonic_ticks alias "uxdatetime_monotonic_ticks" () as UXB_I64 UXB_EXPORT
 dim as LARGE_INTEGER q
 QueryPerformanceCounter(@q)
 return q.QuadPart
end function
public function uxdatetime_monotonic_frequency alias "uxdatetime_monotonic_frequency" () as UXB_I64 UXB_EXPORT
 dim as LARGE_INTEGER q
 QueryPerformanceFrequency(@q)
 return q.QuadPart
end function
public function uxdatetime_format_utc alias "uxdatetime_format_utc" (byval unixMs as UXB_I64) as zstring ptr UXB_EXPORT
 dim as UXB_U64 v=culngint(unixMs)*10000ull+116444736000000000ull
 dim as FILETIME ft
 dim as SYSTEMTIME st
 i64_to_ft(v,ft)
 if FileTimeToSystemTime(@ft,@st)=0 then return put_text("")
 return put_text(pad_left(st.wYear,4) & "-" & pad_left(st.wMonth,2) & "-" & pad_left(st.wDay,2) & "T" & pad_left(st.wHour,2) & ":" & pad_left(st.wMinute,2) & ":" & pad_left(st.wSecond,2) & "." & pad_left(st.wMilliseconds,3) & "Z")
end function
public function uxdatetime_format_local alias "uxdatetime_format_local" (byval unixMs as UXB_I64) as zstring ptr UXB_EXPORT
 dim as UXB_U64 v=culngint(unixMs)*10000ull+116444736000000000ull
 dim as FILETIME utcft,localft
 dim as SYSTEMTIME st
 i64_to_ft(v,utcft)
 FileTimeToLocalFileTime(@utcft,@localft)
 FileTimeToSystemTime(@localft,@st)
 return put_text(pad_left(st.wYear,4) & "-" & pad_left(st.wMonth,2) & "-" & pad_left(st.wDay,2) & " " & pad_left(st.wHour,2) & ":" & pad_left(st.wMinute,2) & ":" & pad_left(st.wSecond,2))
end function
public function uxdatetime_parse_utc alias "uxdatetime_parse_utc" (byval iso as zstring ptr) as UXB_I64 UXB_EXPORT
 if iso=0 then return -1
 dim as string isoText=*iso
 if len(isoText)<19 then return -1
 dim as SYSTEMTIME st
 st.wYear=valint(mid(isoText,1,4))
 st.wMonth=valint(mid(isoText,6,2))
 st.wDay=valint(mid(isoText,9,2))
 st.wHour=valint(mid(isoText,12,2))
 st.wMinute=valint(mid(isoText,15,2))
 st.wSecond=valint(mid(isoText,18,2))
 if len(isoText)>=23 then st.wMilliseconds=valint(mid(isoText,21,3))
 dim as FILETIME ft
 if SystemTimeToFileTime(@st,@ft)=0 then return -1
 return (ft_to_i64(ft)-116444736000000000ull)\10000ull
end function
public function uxdatetime_add_milliseconds alias "uxdatetime_add_milliseconds" (byval unixMs as UXB_I64,byval delta as UXB_I64) as UXB_I64 UXB_EXPORT
 return unixMs+delta
end function
public function uxdatetime_difference_ms alias "uxdatetime_difference_ms" (byval laterMs as UXB_I64,byval earlierMs as UXB_I64) as UXB_I64 UXB_EXPORT
 return laterMs-earlierMs
end function
public sub uxdatetime_sleep alias "uxdatetime_sleep" (byval ms as ulong) UXB_EXPORT
 Sleep(ms)
end sub
public function uxdatetime_error alias "uxdatetime_error" () as zstring ptr UXB_EXPORT
 return put_text(g_error)
end function
