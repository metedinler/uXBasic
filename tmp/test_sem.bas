Dim gSemVTable_processedKeys() As String
Dim gSemVTable_processedCount As Integer

Private Function SemVTableIsProcessed(ByRef cname As String) As Integer
    Dim i As Integer
    For i = 0 To gSemVTable_processedCount - 1
        If gSemVTable_processedKeys(i) = cname Then Return 1
    Next
    Return 0
End Function

Private Sub SemVTableMarkProcessed(ByRef cname As String)
    If gSemVTable_processedCount = 0 Then
        ReDim gSemVTable_processedKeys(0)
    Else
        ReDim Preserve gSemVTable_processedKeys(0 To gSemVTable_processedCount)
    End If
    gSemVTable_processedKeys(gSemVTable_processedCount) = cname
    gSemVTable_processedCount += 1
End Sub

Print SemVTableIsProcessed("A")
End
