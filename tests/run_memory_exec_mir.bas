#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/semantic/hir.fbs"
#include once "../src/semantic/mir.fbs"
#include once "helpers/mir_test_common.fbs"

Private Function RunExpectMirFail(ByRef src As String, ByRef expectedPart As String, ByRef failMsg As String) As Integer
    Dim ps As ParseState
    Dim errText As String
    Dim mirResult As MIRValue

    If RTMIRParseProgram(src, ps, errText) = 0 Then
        failMsg = "parse failed unexpectedly: " & errText
        Return 0
    End If

    If RTMIRRunProgram(ps, errText, mirResult) <> 0 Then
        failMsg = "expected MIR runtime failure"
        Return 0
    End If

    If InStr(UCase(errText), UCase(expectedPart)) = 0 Then
        failMsg = "unexpected MIR error text: " & errText
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim tmpOutPath As String
    tmpOutPath = "tests\\tmp_memory_exec_mir_out.bin"
    Kill tmpOutPath

    Dim src As String
    src = _
        "POKEB 100, 65" & Chr(10) & _
        "POKEW 102, 4660" & Chr(10) & _
        "POKED 104, 305419896" & Chr(10) & _
        "a = PEEKB(100)" & Chr(10) & _
        "b = PEEKW(102)" & Chr(10) & _
        "c = PEEKD(104)" & Chr(10) & _
        "MEMFILLB 200, 122, 4" & Chr(10) & _
        "d = PEEKB(203)" & Chr(10) & _
        "MEMCOPYB 200, 210, 4" & Chr(10) & _
        "e = PEEKB(212)" & Chr(10) & _
        "MEMFILLW 300, 4660, 2" & Chr(10) & _
        "f = PEEKW(302)" & Chr(10) & _
        "MEMCOPYW 300, 310, 2" & Chr(10) & _
        "g = PEEKW(310)" & Chr(10) & _
        "MEMFILLD 400, 305419896, 1" & Chr(10) & _
        "h = PEEKD(400)" & Chr(10) & _
        "MEMCOPYD 400, 410, 1" & Chr(10) & _
        "i = PEEKD(410)" & Chr(10) & _
        "POKES 500, ""AB""" & Chr(10) & _
        "j = PEEKB(500)" & Chr(10) & _
        "k = PEEKB(501)" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "x = 111" & Chr(10) & _
        "SETNEWOFFSET x, 7300" & Chr(10) & _
        "POKED VARPTR(x), 222" & Chr(10) & _
        "l = PEEKD(7300)" & Chr(10) & _
        "OPEN ""tests\\tmp_memory_exec_mir_out.bin"" FOR BINARY AS #1" & Chr(10) & _
        "PUT #1, 1, 4, a" & Chr(10) & _
        "PUT #1, 5, 4, b" & Chr(10) & _
        "PUT #1, 9, 4, c" & Chr(10) & _
        "PUT #1, 13, 4, d" & Chr(10) & _
        "PUT #1, 17, 4, e" & Chr(10) & _
        "PUT #1, 21, 4, f" & Chr(10) & _
        "PUT #1, 25, 4, g" & Chr(10) & _
        "PUT #1, 29, 4, h" & Chr(10) & _
        "PUT #1, 33, 4, i" & Chr(10) & _
        "PUT #1, 37, 4, j" & Chr(10) & _
        "PUT #1, 41, 4, k" & Chr(10) & _
        "PUT #1, 45, 4, l" & Chr(10) & _
        "CLOSE #1"

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
    Dim outD As Long
    Dim outE As Long
    Dim outF As Long
    Dim outG As Long
    Dim outH As Long
    Dim outI As Long
    Dim outJ As Long
    Dim outK As Long
    Dim outL As Long

    Open tmpOutPath For Binary As #1
    Get #1, 1, outA
    Get #1, 5, outB
    Get #1, 9, outC
    Get #1, 13, outD
    Get #1, 17, outE
    Get #1, 21, outF
    Get #1, 25, outG
    Get #1, 29, outH
    Get #1, 33, outI
    Get #1, 37, outJ
    Get #1, 41, outK
    Get #1, 45, outL
    Close #1

    Dim ok As Integer
    ok = 1
    ok And= RTMIRAssertEq(outA, 65, "POKEB/PEEKB")
    ok And= RTMIRAssertEq(outB, 4660, "POKEW/PEEKW")
    ok And= RTMIRAssertEq(outC, 305419896, "POKED/PEEKD")
    ok And= RTMIRAssertEq(outD, 122, "MEMFILLB tail")
    ok And= RTMIRAssertEq(outE, 122, "MEMCOPYB lane")
    ok And= RTMIRAssertEq(outF, 4660, "MEMFILLW lane")
    ok And= RTMIRAssertEq(outG, 4660, "MEMCOPYW lane")
    ok And= RTMIRAssertEq(outH, 305419896, "MEMFILLD lane")
    ok And= RTMIRAssertEq(outI, 305419896, "MEMCOPYD lane")
    ok And= RTMIRAssertEq(outJ, Asc("A"), "POKES byte 0")
    ok And= RTMIRAssertEq(outK, Asc("B"), "POKES byte 1")
    ok And= RTMIRAssertEq(outL, 222, "SETNEWOFFSET + VARPTR mirror")

    Dim failMsg As String
    If RunExpectMirFail("MEMCOPYB 100, 110, -1", "NEGATIF UZUNLUK", failMsg) = 0 Then
        Print "FAIL mir-failfast | "; failMsg
        End 1
    End If

    Kill tmpOutPath

    If ok = 0 Then End 1

    Print "PASS memory MIR exec"
    End 0
End Sub

Main
