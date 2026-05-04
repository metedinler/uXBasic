Dim arr() As String
Dim cnt As Integer

Sub test(ByVal cname As String)
    Dim i As Integer
    For i = 0 To cnt - 1
        If arr(i) = cname Then Print "found": Return
    Next
End Sub

Print "ok"
End
