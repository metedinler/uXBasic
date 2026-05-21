Extern "C"
Function uxb_f80_size() As Integer Export
    Return SizeOf(Extended)
End Function
Sub uxb_f80_from_str(ByVal src As ZString Ptr, ByVal outp As Extended Ptr) Export
    If src = 0 Or outp = 0 Then Exit Sub
    *outp = Val(*src)
End Sub
Sub uxb_f80_to_str(ByVal a As Extended Ptr, ByVal outBuf As ZString Ptr, ByVal outBytes As Integer) Export
    If a = 0 Or outBuf = 0 Or outBytes <= 0 Then Exit Sub
    Dim As String s = Str(*a)
    If Len(s) >= outBytes Then s = Left(s, outBytes - 1)
    *outBuf = s
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
