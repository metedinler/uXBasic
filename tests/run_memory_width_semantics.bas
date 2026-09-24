#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"

Private Function ParseExpectOk(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st
    If ParseProgram(ps) = 0 Then
        errOut = ps.lastError
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
        errOut = "unexpected error text: " & errOut
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
        "tag AS I8" & Chr(10) & _
        "pairs(0 TO 1) AS Pair" & Chr(10) & _
        "word AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = PEEKW(OFFSETOF(Packet, ""pairs(0).lo""))" & Chr(10) & _
        "b = PEEKW(OFFSETOF(Packet, ""pairs(1).hi""))" & Chr(10) & _
        "POKEW OFFSETOF(Packet, ""pairs(1).lo""), 5" & Chr(10) & _
        "c = PEEKD(OFFSETOF(Packet, ""word""))" & Chr(10) & _
        "POKED OFFSETOF(Packet, ""word""), 9"

    Dim errText As String
    If ParseExpectOk(srcOk, errText) = 0 Then
        Print "FAIL mem-width ok parse | "; errText
        End 1
    End If

    Dim srcFail1 As String
    srcFail1 = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = PEEKB(OFFSETOF(Pair, ""lo""))"
    If ParseExpectFail(srcFail1, "WIDTH MISMATCH", errText) = 0 Then
        Print "FAIL mem-width fail-1 | "; errText
        End 1
    End If

    Dim srcFail2 As String
    srcFail2 = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = PEEKD(OFFSETOF(Pair, ""lo""))"
    If ParseExpectFail(srcFail2, "WIDTH MISMATCH", errText) = 0 Then
        Print "FAIL mem-width fail-2 | "; errText
        End 1
    End If

    Dim srcFail3 As String
    srcFail3 = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "POKED OFFSETOF(Pair, ""lo""), 1"
    If ParseExpectFail(srcFail3, "WIDTH MISMATCH", errText) = 0 Then
        Print "FAIL mem-width fail-3 | "; errText
        End 1
    End If

    Dim srcFail4 As String
    srcFail4 = _
        "TYPE Packet" & Chr(10) & _
        "word AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "POKEW OFFSETOF(Packet, ""word""), 1"
    If ParseExpectFail(srcFail4, "WIDTH MISMATCH", errText) = 0 Then
        Print "FAIL mem-width fail-4 | "; errText
        End 1
    End If

    Print "PASS memory width semantics"
    End 0
End Sub

Main
