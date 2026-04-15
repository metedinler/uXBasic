#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "x = 1" & Chr(10) & _
        "IF x = 1 THEN" & Chr(10) & _
        "POKED 7900, 11" & Chr(10) & _
        "ELSE" & Chr(10) & _
        "POKED 7900, 99" & Chr(10) & _
        "END IF" & Chr(10) & _
        "x = 2" & Chr(10) & _
        "IF x = 1 THEN" & Chr(10) & _
        "POKED 7904, 11" & Chr(10) & _
        "ELSEIF x = 2 THEN" & Chr(10) & _
        "POKED 7904, 22" & Chr(10) & _
        "ELSE" & Chr(10) & _
        "POKED 7904, 99" & Chr(10) & _
        "END IF" & Chr(10) & _
        "x = 9" & Chr(10) & _
        "IF x = 1 THEN" & Chr(10) & _
        "POKED 7908, 11" & Chr(10) & _
        "ELSEIF x = 2 THEN" & Chr(10) & _
        "POKED 7908, 22" & Chr(10) & _
        "ELSE" & Chr(10) & _
        "POKED 7908, 33" & Chr(10) & _
        "END IF" & Chr(10) & _
        "IF 0 THEN" & Chr(10) & _
        "POKED 7912, 1" & Chr(10) & _
        "ELSE" & Chr(10) & _
        "POKED 7912, 2" & Chr(10) & _
        "END IF"

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
    ok And= RTAssertEq(VMemPeekD(7900), 11, "IF true branch")
    ok And= RTAssertEq(VMemPeekD(7904), 22, "IF ELSEIF branch")
    ok And= RTAssertEq(VMemPeekD(7908), 33, "IF ELSE fallback branch")
    ok And= RTAssertEq(VMemPeekD(7912), 2, "IF false condition")

    If RTParseExpectFail("IF THEN THEN" & Chr(10) & "PRINT 1" & Chr(10) & "END IF", "IF: condition is required", errText) = 0 Then
        Print "FAIL if missing condition semantic fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("x = 0" & Chr(10) & "IF x THEN" & Chr(10) & "PRINT 1" & Chr(10) & "ELSEIF THEN THEN" & Chr(10) & "PRINT 2" & Chr(10) & "END IF", "ELSEIF: condition is required", errText) = 0 Then
        Print "FAIL elseif missing condition semantic fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS if AST exec"
    End 0
End Sub

Main
