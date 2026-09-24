' uXBasiC F80 runtime DLL.
' Backend: FreeBASIC Extended.
' ABI rule: values are passed by pointer; results written to out pointer.

Extern "C"

Function uxb_f80_size() As Integer Export
    Return SizeOf(Extended)
End Function

Function uxb_f80_storage_size() As Integer Export
    ' uXBasiC compiler side uses 16-byte storage slot for alignment.
    Return 16
End Function

Sub uxb_f80_zero(ByVal outp As Extended Ptr) Export
    If outp = 0 Then Exit Sub
    *outp = 0
End Sub

Sub uxb_f80_from_str(ByVal src As ZString Ptr, ByVal outp As Extended Ptr) Export
    If src = 0 Or outp = 0 Then Exit Sub
    *outp = Val(*src)
End Sub

Sub uxb_f80_to_str(ByVal a As Extended Ptr, ByVal outBuf As ZString Ptr, ByVal outBytes As Integer) Export
    If a = 0 Or outBuf = 0 Or outBytes <= 0 Then Exit Sub

    Dim As String s
    s = Str(*a)

    If Len(s) >= outBytes Then
        s = Left(s, outBytes - 1)
    End If

    *outBuf = s
End Sub

Sub uxb_f80_copy(ByVal src As Extended Ptr, ByVal outp As Extended Ptr) Export
    If src = 0 Or outp = 0 Then Exit Sub
    *outp = *src
End Sub

Sub uxb_f80_add(ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr) Export
    If a = 0 Or b = 0 Or outp = 0 Then Exit Sub
    *outp = *a + *b
End Sub

Sub uxb_f80_sub(ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr) Export
    If a = 0 Or b = 0 Or outp = 0 Then Exit Sub
    *outp = *a - *b
End Sub

Sub uxb_f80_mul(ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr) Export
    If a = 0 Or b = 0 Or outp = 0 Then Exit Sub
    *outp = *a * *b
End Sub

Sub uxb_f80_div(ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr) Export
    If a = 0 Or b = 0 Or outp = 0 Then Exit Sub
    *outp = *a / *b
End Sub

Function uxb_f80_cmp(ByVal a As Extended Ptr, ByVal b As Extended Ptr) As Integer Export
    If a = 0 Or b = 0 Then Return 0
    If *a < *b Then Return -1
    If *a > *b Then Return 1
    Return 0
End Function

End Extern
