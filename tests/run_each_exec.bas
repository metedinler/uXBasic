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

Private Sub Main()
    Dim src As String
    src = _
        "TYPE Pair" & Chr(10) & _
        "lo AS I16" & Chr(10) & _
        "hi AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Packet" & Chr(10) & _
        "tag AS I16" & Chr(10) & _
        "pairs(0 TO 2) AS Pair" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = 1" & Chr(10) & _
        "c = 3" & Chr(10) & _
        "sumFor = 0" & Chr(10) & _
        "FOR EACH v, idx IN a, a + 1, c" & Chr(10) & _
        "a = a + 10" & Chr(10) & _
        "sumFor = sumFor + v + idx" & Chr(10) & _
        "NEXT" & Chr(10) & _
        "POKED 6000, sumFor" & Chr(10) & _
        "POKED 6004, a" & Chr(10) & _
        "sumDo = 0" & Chr(10) & _
        "a = 1" & Chr(10) & _
        "DO EACH w IN a, a + 1, a + 2" & Chr(10) & _
        "sumDo = sumDo + w" & Chr(10) & _
        "a = a + 10" & Chr(10) & _
        "LOOP" & Chr(10) & _
        "POKED 6008, sumDo" & Chr(10) & _
        "POKED 6012, a" & Chr(10) & _
        "x = 0" & Chr(10) & _
        "FOR EACH t IN 5, 6, 7" & Chr(10) & _
        "x = x + t" & Chr(10) & _
        "EXIT FOR" & Chr(10) & _
        "NEXT" & Chr(10) & _
        "POKED 6016, x" & Chr(10) & _
        "y = 0" & Chr(10) & _
        "DO EACH u IN 5, 6, 7" & Chr(10) & _
        "y = y + u" & Chr(10) & _
        "EXIT DO" & Chr(10) & _
        "LOOP" & Chr(10) & _
        "POKED 6020, y" & Chr(10) & _
        "base = VARPTR(pkt)" & Chr(10) & _
        "p0 = base + OFFSETOF(Packet, ""pairs(0)"")" & Chr(10) & _
        "p1 = base + OFFSETOF(Packet, ""pairs(1)"")" & Chr(10) & _
        "p2 = base + OFFSETOF(Packet, ""pairs(2)"")" & Chr(10) & _
        "stride = SIZEOF(Pair)" & Chr(10) & _
        "sumStride = 0" & Chr(10) & _
        "POKEW p0 + OFFSETOF(Pair, ""hi""), 100" & Chr(10) & _
        "prev = p0" & Chr(10) & _
        "FOR EACH p, i IN p1, p2" & Chr(10) & _
        "sumStride = sumStride + (p - prev)" & Chr(10) & _
        "POKEW p + OFFSETOF(Pair, ""hi""), 101 + i" & Chr(10) & _
        "prev = p" & Chr(10) & _
        "NEXT" & Chr(10) & _
        "q0 = PEEKW(p0 + OFFSETOF(Pair, ""hi""))" & Chr(10) & _
        "q1 = PEEKW(p1 + OFFSETOF(Pair, ""hi""))" & Chr(10) & _
        "q2 = PEEKW(p2 + OFFSETOF(Pair, ""hi""))" & Chr(10) & _
        "POKED 6024, stride" & Chr(10) & _
        "POKED 6028, sumStride" & Chr(10) & _
        "POKED 6032, q0" & Chr(10) & _
        "POKED 6036, q1" & Chr(10) & _
        "POKED 6040, q2"

    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        Print "FAIL parse | "; ps.lastError
        End 1
    End If

    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) = 0 Then
        Print "FAIL exec | "; execErr
        End 1
    End If

    Dim ok As Integer
    ok = 1

    ok And= AssertEq(VMemPeekD(6000), 9, "FOR EACH snapshot + index")
    ok And= AssertEq(VMemPeekD(6004), 31, "FOR EACH source mutation isolation")
    ok And= AssertEq(VMemPeekD(6008), 36, "DO EACH live evaluation")
    ok And= AssertEq(VMemPeekD(6012), 31, "DO EACH source mutation impact")
    ok And= AssertEq(VMemPeekD(6016), 5, "EXIT FOR in FOR EACH")
    ok And= AssertEq(VMemPeekD(6020), 5, "EXIT DO in DO EACH")
    ok And= AssertEq(VMemPeekD(6024), 4, "Pair stride bytes")
    ok And= AssertEq(VMemPeekD(6028), 8, "FOR EACH pointer stride accumulation")
    ok And= AssertEq(VMemPeekD(6032), 100, "pairs(0).hi write")
    ok And= AssertEq(VMemPeekD(6036), 101, "pairs(1).hi write")
    ok And= AssertEq(VMemPeekD(6040), 102, "pairs(2).hi write")

    If ok = 0 Then End 1

    Print "PASS each exec"
    End 0
End Sub

Main
