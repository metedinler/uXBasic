#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim tmpPath As String
    tmpPath = "tests\\tmp_input_exec.bin"
    Kill tmpPath

    Open tmpPath For Binary As #1
    Dim inA As Integer
    inA = 287454020
    Put #1, 1, inA
    Close #1

    ExecDebugInputQueueClear
    ExecDebugInputQueuePush "41"
    ExecDebugInputQueuePush "7"

    Dim src As String
    src = _
        "INPUT ""A?""; a" & Chr(10) & _
        "INPUT b" & Chr(10) & _
        "POKED 7800, a" & Chr(10) & _
        "POKED 7804, b" & Chr(10) & _
        "OPEN ""tests/tmp_input_exec.bin"" FOR BINARY AS #1" & Chr(10) & _
        "INPUT #1, c" & Chr(10) & _
        "CLOSE #1" & Chr(10) & _
        "POKED 7808, c"

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
    ok And= RTAssertEq(VMemPeekD(7800), 41, "INPUT queue first value")
    ok And= RTAssertEq(VMemPeekD(7804), 7, "INPUT queue second value")
    ok And= RTAssertEq(VMemPeekD(7808), 287454020, "INPUT# file first value")
    ok And= RTAssertEq(ExecDebugGetInputQueueRemaining(), 0, "INPUT queue drained")

    Dim negErr As String
    If RTParseExpectFail("INPUT ""A?""; 5", "INPUT: targets must be IDENT", negErr) = 0 Then
        Print "FAIL parse-neg INPUT target kind | "; negErr
        ok = 0
    End If

    If RTParseExpectFail("INPUT #1, 9", "INPUT#: targets must be IDENT", negErr) = 0 Then
        Print "FAIL parse-neg INPUT# target kind | "; negErr
        ok = 0
    End If

    ExecDebugInputQueueClear
    Kill tmpPath

    If ok = 0 Then End 1

    Print "PASS input AST exec"
    End 0
End Sub

Main
