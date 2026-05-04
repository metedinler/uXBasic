#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "Dim a(3) As F64" & Chr(10) & _
        "a(0) = 1.0" & Chr(10) & _
        "a(1) = 2.0" & Chr(10) & _
        "i = 3" & Chr(10) & _
        "a(2) = i + 0.5" & Chr(10) & _
        "a(3) = a(0) + a(1) * a(2)" & Chr(10) & _
        "POKED 9800, a(0)" & Chr(10) & _
        "POKED 9808, a(1)" & Chr(10) & _
        "POKED 9816, a(2)" & Chr(10) & _
        "POKED 9824, a(3)"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL matrix float parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL matrix float exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9800), 1, "a(0)")
    ok And= RTAssertEq(VMemPeekD(9808), 2, "a(1)")
    ok And= RTAssertEq(VMemPeekD(9816), 3.5, "a(2)")
    ok And= RTAssertEq(VMemPeekD(9824), 1 + 2 * 3.5, "a(3)")

    If ok = 0 Then End 1

    Print "PASS 44 matrix float native"
    End 0
End Sub

Main
