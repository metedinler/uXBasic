#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "x = 0" & Chr(10) & _
        "POKED 7300, 1" & Chr(10) & _
        "GOTO SkipA" & Chr(10) & _
        "POKED 7300, 9" & Chr(10) & _
        "SkipA:" & Chr(10) & _
        "GOSUB Worker" & Chr(10) & _
        "POKED 7304, x" & Chr(10) & _
        "GOSUB First" & Chr(10) & _
        "POKED 7308, x" & Chr(10) & _
        "END" & Chr(10) & _
        "Worker:" & Chr(10) & _
        "x = x + 5" & Chr(10) & _
        "RETURN" & Chr(10) & _
        "First:" & Chr(10) & _
        "x = 10" & Chr(10) & _
        "GOSUB Second" & Chr(10) & _
        "x = x + 1" & Chr(10) & _
        "RETURN" & Chr(10) & _
        "Second:" & Chr(10) & _
        "x = x + 5" & Chr(10) & _
        "RETURN"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(7300), 1, "GOTO skips intermediate statement")
    ok And= RTAssertEq(VMemPeekD(7304), 5, "GOSUB/RETURN basic call")
    ok And= RTAssertEq(VMemPeekD(7308), 16, "nested GOSUB/RETURN stack")

    If RTExecExpectFail("GOTO Missing", "GOTO target not found MISSING", errText) = 0 Then
        Print "FAIL goto missing target fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("GOSUB Missing", "GOSUB target not found MISSING", errText) = 0 Then
        Print "FAIL gosub missing target fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("L1:" & Chr(10) & "L1:", "duplicate LABEL L1", errText) = 0 Then
        Print "FAIL duplicate label fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("SUB JumpOut()" & Chr(10) & "GOTO X" & Chr(10) & "END SUB" & Chr(10) & "CALL JumpOut()" & Chr(10) & "X:", "unsupported control transfer inside user call", errText) = 0 Then
        Print "FAIL user-call jump transfer guard | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS jump AST exec"
    End 0
End Sub

Main
