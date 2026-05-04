Sub foo1(ByRef a() As String)
    ReDim a(0)
End Sub

Sub foo2(a() As String)
    ReDim a(0)
End Sub

Dim arr() As String
foo1(arr())
foo2(arr())
End
