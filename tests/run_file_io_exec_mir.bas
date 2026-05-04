#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/semantic/hir.fbs"
#include once "../src/semantic/mir.fbs"
#include once "helpers/mir_test_common.fbs"

Private Sub Main()
    Dim tmpMainPath As String
    Dim tmpRandomPath As String
    Dim tmpOutPath As String
    tmpMainPath = "tests\\tmp_file_io_exec_mir.bin"
    tmpRandomPath = "tests\\tmp_file_io_exec_mir_random.bin"
    tmpOutPath = "tests\\tmp_file_io_exec_mir_out.bin"

    Kill tmpMainPath
    Kill tmpRandomPath
    Kill tmpOutPath

    Dim src As String
    src = _
        "OPEN ""tests\\tmp_file_io_exec_mir.bin"" FOR BINARY AS #7" & Chr(10) & _
        "v = 287454020" & Chr(10) & _
        "PUT #7, 1, 4, v" & Chr(10) & _
        "SEEK #7, 1" & Chr(10) & _
        "v = 0" & Chr(10) & _
        "GET #7, 1, 4, v" & Chr(10) & _
        "OPEN ""tests\\tmp_file_io_exec_mir_random.bin"" FOR RANDOM AS #8 LEN = 2" & Chr(10) & _
        "w = 4660" & Chr(10) & _
        "PUT #8, 1, 2, w" & Chr(10) & _
        "w = 0" & Chr(10) & _
        "GET #8, 1, 2, w" & Chr(10) & _
        "CLOSE #8" & Chr(10) & _
        "CLOSE #7" & Chr(10) & _
        "OPEN ""tests\\tmp_file_io_exec_mir_out.bin"" FOR BINARY AS #9" & Chr(10) & _
        "PUT #9, 1, 4, v" & Chr(10) & _
        "PUT #9, 5, 2, w" & Chr(10) & _
        "CLOSE #9"

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

    Dim outV As Long
    Dim outW As UShort
    Open tmpOutPath For Binary As #1
    Get #1, 1, outV
    Get #1, 5, outW
    Close #1

    Dim ok As Integer
    ok = 1
    ok And= RTMIRAssertEq(outV, 287454020, "file open/put/get/seek flow")
    ok And= RTMIRAssertEq(outW, 4660, "file random len/bytes flow")

    Kill tmpMainPath
    Kill tmpRandomPath
    Kill tmpOutPath

    If ok = 0 Then End 1

    Print "PASS file io MIR exec"
    End 0
End Sub

Main
