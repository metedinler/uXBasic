#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function AssertNonZero(ByVal actualValue As Integer, ByRef msg As String) As Integer
    If actualValue = 0 Then
        Print "FAIL "; msg; " expected non-zero"
        Return 0
    End If
    Return 1
End Function

Private Sub Main()
    Dim src As String
    src = _
        "DIM l AS LIST" & Chr(10) & _
        "DIM d AS DICT" & Chr(10) & _
        "DIM s AS SET" & Chr(10) & _
        "POKED 9420, l" & Chr(10) & _
        "POKED 9424, d" & Chr(10) & _
        "POKED 9428, s"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL collection types parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL collection types exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= AssertNonZero(VMemPeekD(9420), "LIST handle created")
    ok And= AssertNonZero(VMemPeekD(9424), "DICT handle created")
    ok And= AssertNonZero(VMemPeekD(9428), "SET handle created")

    If ok = 0 Then End 1

    Print "PASS collection types exec"
    End 0
End Sub

Main
