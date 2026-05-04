#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/semantic/hir.fbs"
#include once "../src/semantic/mir.fbs"
#include once "helpers/mir_test_common.fbs"

Private Sub Main()
    Dim tmpInputPath As String
    Dim tmpOutPath As String
    tmpInputPath = "tests\\tmp_input_exec_mir_src.bin"
    tmpOutPath = "tests\\tmp_input_exec_mir_out.bin"

    Kill tmpInputPath
    Kill tmpOutPath

    Open tmpInputPath For Binary As #1
    Dim inA As Long
    inA = 287454020
    Put #1, 1, inA
    Close #1

    MIRDebugInputQueueClear
    MIRDebugInputQueuePush "41"
    MIRDebugInputQueuePush "7"

    Dim src As String
    src = _
        "INPUT ""A?""; a" & Chr(10) & _
        "INPUT b" & Chr(10) & _
        "OPEN ""tests\\tmp_input_exec_mir_src.bin"" FOR BINARY AS #1" & Chr(10) & _
        "INPUT #1, c" & Chr(10) & _
        "CLOSE #1" & Chr(10) & _
        "OPEN ""tests\\tmp_input_exec_mir_out.bin"" FOR BINARY AS #2" & Chr(10) & _
        "PUT #2, 1, 4, a" & Chr(10) & _
        "PUT #2, 5, 4, b" & Chr(10) & _
        "PUT #2, 9, 4, c" & Chr(10) & _
        "CLOSE #2"

    Dim ps As ParseState
    Dim errText As String
    Dim mirResult As MIRValue
    If RTMIRParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse | "; errText
        End 1
    End If

    If RTMIRRunProgram(ps, errText, mirResult) = 0 Then
        Print "FAIL mir-run | "; errText
        End 1
    End If

    Dim outA As Long
    Dim outB As Long
    Dim outC As Long
    Open tmpOutPath For Binary As #2
    Get #2, 1, outA
    Get #2, 5, outB
    Get #2, 9, outC
    Close #2

    Dim ok As Integer
    ok = 1
    ok And= RTMIRAssertEq(outA, 41, "INPUT queue first value")
    ok And= RTMIRAssertEq(outB, 7, "INPUT queue second value")
    ok And= RTMIRAssertEq(outC, 287454020, "INPUT# file first value")
    ok And= RTMIRAssertEq(MIRDebugGetInputQueueRemaining(), 0, "INPUT queue drained")

    MIRDebugInputQueueClear
    Kill tmpInputPath
    Kill tmpOutPath

    If ok = 0 Then End 1

    Print "PASS input MIR exec"
    End 0
End Sub

Main
