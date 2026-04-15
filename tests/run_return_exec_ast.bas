#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function ContainsText(ByRef haystack As String, ByRef needle As String) As Integer
    Return Instr(UCase(haystack), UCase(needle)) > 0
End Function

Private Sub Main()
    Dim src As String
    src = _
        "x = 0" & Chr(10) & _
        "FOR i = 1 TO 3" & Chr(10) & _
        "IF i = 2 THEN" & Chr(10) & _
        "RETURN" & Chr(10) & _
        "END IF" & Chr(10) & _
        "POKED 7200, i" & Chr(10) & _
        "NEXT i" & Chr(10) & _
        "POKED 7204, 1"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) <> 0 Then
        Print "FAIL exec | expected RETURN fail-fast"
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(7200), 1, "RETURN propagation keeps pre-return side effect")
    ok And= RTAssertEq(VMemPeekD(7204), 0, "RETURN fail-fast blocks later top-level statements")

    If ContainsText(errText, "RETURN used without GOSUB") = 0 Then
        Print "FAIL error text | "; errText
        End 1
    End If

    If RTExecExpectFail("RETURN 7", "RETURN used without GOSUB", errText) = 0 Then
        Print "FAIL return-value fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS return AST exec"
    End 0
End Sub

Main
