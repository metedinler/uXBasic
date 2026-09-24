#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "TRY" & Chr(10) & _
        "THROW 404" & Chr(10) & _
        "POKED 8100, 99" & Chr(10) & _
        "CATCH err" & Chr(10) & _
        "POKED 8100, 1" & Chr(10) & _
        "POKED 8104, err" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "POKED 8108, 1" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "ASSERT 1 = 1, ""assert-pass""" & Chr(10) & _
        "POKED 8112, 1" & Chr(10) & _
        "TRY" & Chr(10) & _
        "ASSERT 0, ""must fail""" & Chr(10) & _
        "POKED 8116, 99" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "POKED 8116, 1" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "POKED 8120, 1" & Chr(10) & _
        "END TRY"

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

    ok And= RTAssertEq(VMemPeekD(8100), 1, "THROW caught by CATCH")
    ok And= RTAssertEq(VMemPeekD(8104), 1, "CATCH variable is bound")
    ok And= RTAssertEq(VMemPeekD(8108), 1, "FINALLY runs after THROW")
    ok And= RTAssertEq(VMemPeekD(8112), 1, "Execution continues after handled TRY")
    ok And= RTAssertEq(VMemPeekD(8116), 1, "ASSERT failure handled by CATCH")
    ok And= RTAssertEq(VMemPeekD(8120), 1, "FINALLY runs after ASSERT failure")

    If RTParseExpectFail("TRY" & Chr(10) & "PRINT 1" & Chr(10) & "CATCH" & Chr(10) & "PRINT 2", "missing END TRY", errText) = 0 Then
        Print "FAIL parse fail-fast END TRY | "; errText
        End 1
    End If

    If RTExecExpectFail("THROW 7", "THROW 7", errText) = 0 Then
        Print "FAIL uncaught THROW runtime fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("ASSERT 0, ""boom""", "ASSERT failed", errText) = 0 Then
        Print "FAIL ASSERT runtime fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS err try/throw/assert exec"
    End 0
End Sub

Main
