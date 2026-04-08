#include once "../src/runtime/memory_vm.fbs"

Private Function AssertEq(ByVal actualValue As Integer, ByVal expectedValue As Integer, ByRef msg As String) As Integer
    If actualValue <> expectedValue Then
        Print "FAIL "; msg; " expected="; expectedValue; " actual="; actualValue
        Return 0
    End If
    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    VMemInit 1048576, &hB8000, 80, 25

    ok And= AssertEq(VMemPokeB(&h100, 42), 1, "POKEB status")
    ok And= AssertEq(VMemPeekB(&h100), 42, "PEEKB value")

    ok And= AssertEq(VMemPokeW(&h120, &h1234), 1, "POKEW status")
    ok And= AssertEq(VMemPeekW(&h120), &h1234, "PEEKW value")

    ok And= AssertEq(VMemPokeD(&h140, &h78563412), 1, "POKED status")
    ok And= AssertEq(VMemPeekD(&h140), &h78563412, "PEEKD value")

    ok And= AssertEq(VMemFillB(&h200, &h7A, 8), 1, "MEMFILLB status")
    ok And= AssertEq(VMemPeekB(&h205), &h7A, "MEMFILLB verify")

    ok And= AssertEq(VMemPokeB(&h300, &h41), 1, "COPY src write")
    ok And= AssertEq(VMemCopyB(&h300, &h310, 1), 1, "MEMCOPYB status")
    ok And= AssertEq(VMemPeekB(&h310), &h41, "MEMCOPYB verify")

    ok And= AssertEq(VMemPokeB(&hB8000, Asc("A")), 1, "Text char write")
    ok And= AssertEq(VMemPokeB(&hB8001, &h1E), 1, "Text attr write")
    ok And= AssertEq(VMemPeekB(&hB8000), Asc("A"), "Text char read")

    If ok = 0 Then
        End 1
    End If

    Print "PASS memory runtime"
    End 0
End Sub

Main
