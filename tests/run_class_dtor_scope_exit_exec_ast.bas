#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "CLASS C" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB C_DTOR(self AS I32)" & Chr(10) & _
        "POKED 9820, 444" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM c AS C" & Chr(10) & _
        "POKED 9816, 1"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL dtor scope parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL dtor scope exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9816), 1, "program body executed")
    ok And= RTAssertEq(VMemPeekD(9820), 444, "program-scope dtor invoked")

    If ok = 0 Then End 1

    Print "PASS class dtor scope-exit exec"
    End 0
End Sub

Main
