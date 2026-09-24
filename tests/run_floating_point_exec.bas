#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "a = CDBL(5)" & Chr(10) & _
        "b = CSNG(6)" & Chr(10) & _
        "c = FIX(3)" & Chr(10) & _
        "d = SQR(16)" & Chr(10) & _
        "e = SIN(0)" & Chr(10) & _
        "f = COS(0)" & Chr(10) & _
        "g = TAN(0)" & Chr(10) & _
        "h = EXP(1)" & Chr(10) & _
        "i = LOG(1)" & Chr(10) & _
        "POKED 9450, a" & Chr(10) & _
        "POKED 9454, b" & Chr(10) & _
        "POKED 9458, c" & Chr(10) & _
        "POKED 9462, d" & Chr(10) & _
        "POKED 9466, f" & Chr(10) & _
        "POKED 9470, h"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL floating parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL floating exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9450), 5, "CDBL")
    ok And= RTAssertEq(VMemPeekD(9454), 6, "CSNG")
    ok And= RTAssertEq(VMemPeekD(9458), 3, "FIX")
    ok And= RTAssertEq(VMemPeekD(9462), 4, "SQR")
    ok And= RTAssertEq(VMemPeekD(9466), 1, "COS(0)")
    ok And= RTAssertEq(VMemPeekD(9470), 3, "EXP(1)")

    If RTExecExpectFail("x = LOG(0)", "LOG domain error", errText) = 0 Then
        Print "FAIL floating LOG domain fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS floating point exec"
    End 0
End Sub

Main
