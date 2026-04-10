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
        "tag AS I8" & Chr(10) & _
        "pairs(0 TO 1) AS Pair" & Chr(10) & _
        "word AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "base = VARPTR(root)" & Chr(10) & _
        "POKEW base + OFFSETOF(Packet, ""pairs(1).hi""), 13398" & Chr(10) & _
        "POKED base + OFFSETOF(Packet, ""word""), 287454020" & Chr(10) & _
        "u = PEEKW(base + OFFSETOF(Packet, ""pairs(1).hi""))" & Chr(10) & _
        "v = PEEKD(base + OFFSETOF(Packet, ""word""))" & Chr(10) & _
        "x = 4096" & Chr(10) & _
        "POKEB x, 65" & Chr(10) & _
        "POKEW x + 2, 4660" & Chr(10) & _
        "POKED x + 8, 305419896" & Chr(10) & _
        "MEMFILLB x + 16, 7, 4" & Chr(10) & _
        "MEMCOPYB x, x + 32, 1" & Chr(10) & _
        "POKES x + 40, ""HI""" & Chr(10) & _
        "MEMFILLW x + 48, 4660, 2" & Chr(10) & _
        "MEMCOPYW x + 48, x + 56, 2" & Chr(10) & _
        "MEMFILLD x + 64, 305419896, 1" & Chr(10) & _
        "MEMCOPYD x + 64, x + 72, 1" & Chr(10) & _
        "a = PEEKB(x)" & Chr(10) & _
        "b = PEEKW(x + 2)" & Chr(10) & _
        "c = PEEKD(x + 8)" & Chr(10) & _
        "p = VARPTR(a)" & Chr(10) & _
        "s = SADD(""abc"")" & Chr(10) & _
        "l = LPTR(label1)" & Chr(10) & _
        "k = CODEPTR(proc1)" & Chr(10) & _
        "SETNEWOFFSET a, 8192" & Chr(10) & _
        "q = VARPTR(a)" & Chr(10) & _
        "POKED x + 80, q" & Chr(10) & _
        "r = (1 SHL 4) OR 1" & Chr(10) & _
        "POKED x + 84, r" & Chr(10) & _
        "m = 10 MOD 4" & Chr(10) & _
        "POKED x + 88, m" & Chr(10) & _
        "t = 1 ROL 3" & Chr(10) & _
        "POKED x + 92, t" & Chr(10) & _
        "POKEB x + 96, 1" & Chr(10) & _
        "POKEB x + 97, 2" & Chr(10) & _
        "POKEB x + 98, 3" & Chr(10) & _
        "MEMCOPYB x + 96, x + 97, 3" & Chr(10) & _
        "MEMFILLB x + 112, 255, 0" & Chr(10) & _
        "POKEW x + 116, u" & Chr(10) & _
        "POKED x + 120, v" & Chr(10) & _
        "INC a" & Chr(10) & _
        "DEC a"

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

    ok And= AssertEq(VMemPeekB(4096), 65, "POKEB/PEEKB")
    ok And= AssertEq(VMemPeekW(4098), 4660, "POKEW/PEEKW")
    ok And= AssertEq(VMemPeekD(4104), 305419896, "POKED/PEEKD")
    ok And= AssertEq(VMemPeekB(4112), 7, "MEMFILLB start")
    ok And= AssertEq(VMemPeekB(4115), 7, "MEMFILLB end")
    ok And= AssertEq(VMemPeekB(4128), 65, "MEMCOPYB")
    ok And= AssertEq(VMemPeekB(4136), Asc("H"), "POKES first")
    ok And= AssertEq(VMemPeekB(4137), Asc("I"), "POKES second")
    ok And= AssertEq(VMemPeekW(4144), 4660, "MEMFILLW")
    ok And= AssertEq(VMemPeekW(4152), 4660, "MEMCOPYW")
    ok And= AssertEq(VMemPeekD(4160), 305419896, "MEMFILLD")
    ok And= AssertEq(VMemPeekD(4168), 305419896, "MEMCOPYD")
    ok And= AssertEq(VMemPeekD(4176), 8192, "SETNEWOFFSET + VARPTR")
    ok And= AssertEq(VMemPeekD(4180), 17, "SHL/OR")
    ok And= AssertEq(VMemPeekD(4184), 2, "MOD")
    ok And= AssertEq(VMemPeekD(4188), 8, "ROL")
    ok And= AssertEq(VMemPeekB(4193), 1, "MEMCOPYB overlap byte0")
    ok And= AssertEq(VMemPeekB(4194), 2, "MEMCOPYB overlap byte1")
    ok And= AssertEq(VMemPeekB(4195), 3, "MEMCOPYB overlap byte2")
    ok And= AssertEq(VMemPeekW(4212), 13398, "VARPTR+OFFSETOF nested i16")
    ok And= AssertEq(VMemPeekD(4216), 287454020, "VARPTR+OFFSETOF nested i32")

    If ok = 0 Then End 1

    Print "PASS memory AST exec"
    End 0
End Sub

Main
