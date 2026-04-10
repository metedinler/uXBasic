#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"

Private Function AssertEq(ByVal actualValue As Integer, ByVal expectedValue As Integer, ByRef msg As String) As Integer
    If actualValue <> expectedValue Then
        Print "FAIL "; msg; " expected="; expectedValue; " actual="; actualValue
        Return 0
    End If
    Return 1
End Function

Private Function ParseExpectFail(ByRef src As String, ByRef expectedPart As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) <> 0 Then
        errOut = "expected parse failure"
        Return 0
    End If

    errOut = ps.lastError
    If Instr(UCase(errOut), UCase(expectedPart)) = 0 Then
        errOut = "unexpected parse error text: " & errOut
        Return 0
    End If

    Return 1
End Function

Private Function ExecExpectFail(ByRef src As String, ByRef expectedPart As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = ps.lastError
        Return 0
    End If

    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) <> 0 Then
        errOut = "expected exec failure"
        Return 0
    End If

    errOut = execErr
    If Instr(UCase(errOut), UCase(expectedPart)) = 0 Then
        errOut = "unexpected exec error text: " & errOut
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim srcOk As String
    srcOk = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "hi AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Packet" & Chr(10) & _
        "pairs(0 TO 2) AS Pair" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "base = VARPTR(pkt)" & Chr(10) & _
        "p0 = base + OFFSETOF(Packet, ""pairs(0)"")" & Chr(10) & _
        "p1 = base + OFFSETOF(Packet, ""pairs(1)"")" & Chr(10) & _
        "p2 = base + OFFSETOF(Packet, ""pairs(2)"")" & Chr(10) & _
        "stride = SIZEOF(Pair)" & Chr(10) & _
        "sumStride = 0" & Chr(10) & _
        "POKEW p0 + OFFSETOF(Pair, ""lo""), 10" & Chr(10) & _
        "prev = p0" & Chr(10) & _
        "FOR EACH p, i IN p1, p2" & Chr(10) & _
        "sumStride = sumStride + (p - prev)" & Chr(10) & _
        "POKEW p + OFFSETOF(Pair, ""lo""), 11 + i" & Chr(10) & _
        "prev = p" & Chr(10) & _
        "NEXT" & Chr(10) & _
        "POKED 7000, stride" & Chr(10) & _
        "POKED 7004, sumStride" & Chr(10) & _
        "POKED 7008, PEEKW(p0 + OFFSETOF(Pair, ""lo""))" & Chr(10) & _
        "POKED 7012, PEEKW(p1 + OFFSETOF(Pair, ""lo""))" & Chr(10) & _
        "POKED 7016, PEEKW(p2 + OFFSETOF(Pair, ""lo""))"

    Dim st As LexerState
    LexerInit st, srcOk

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        Print "FAIL stride ok parse | "; ps.lastError
        End 1
    End If

    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) = 0 Then
        Print "FAIL stride ok exec | "; execErr
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= AssertEq(VMemPeekD(7000), 4, "stride bytes")
    ok And= AssertEq(VMemPeekD(7004), 8, "stride accumulation")
    ok And= AssertEq(VMemPeekD(7008), 10, "pairs(0).lo")
    ok And= AssertEq(VMemPeekD(7012), 11, "pairs(1).lo")
    ok And= AssertEq(VMemPeekD(7016), 12, "pairs(2).lo")
    If ok = 0 Then End 1

    Dim errText As String

    Dim srcFail1 As String
    srcFail1 = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Packet" & Chr(10) & _
        "pairs(0 TO 2) AS Pair" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Packet, ""pairs(3).lo"")"
    If ParseExpectFail(srcFail1, "INDEX OUT OF BOUNDS", errText) = 0 Then
        Print "FAIL stride parse fail-1 | "; errText
        End 1
    End If

    Dim srcFail2 As String
    srcFail2 = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Packet" & Chr(10) & _
        "pairs(0 TO 2) AS Pair" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Packet, ""pairs.lo"")"
    If ParseExpectFail(srcFail2, "ARRAY FIELD REQUIRES INDEX", errText) = 0 Then
        Print "FAIL stride parse fail-2 | "; errText
        End 1
    End If

    Dim srcFail3 As String
    srcFail3 = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Packet" & Chr(10) & _
        "pairs(0 TO 2) AS Pair" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = PEEKB(OFFSETOF(Packet, ""pairs(1).lo""))"
    If ParseExpectFail(srcFail3, "WIDTH MISMATCH", errText) = 0 Then
        Print "FAIL stride parse fail-3 | "; errText
        End 1
    End If

    Dim srcFailExec As String
    srcFailExec = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "hi AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "base = 1048572" & Chr(10) & _
        "stride = SIZEOF(Pair)" & Chr(10) & _
        "FOR EACH p IN base, base + stride" & Chr(10) & _
        "POKEW p + OFFSETOF(Pair, ""hi""), 1" & Chr(10) & _
        "NEXT"
    If ExecExpectFail(srcFailExec, "POKEW OUT OF RANGE", errText) = 0 Then
        Print "FAIL stride exec fail | "; errText
        End 1
    End If

    Print "PASS memory stride fail-fast"
    End 0
End Sub

Main
