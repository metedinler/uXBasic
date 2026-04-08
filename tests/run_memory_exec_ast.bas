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
        "x = 4096" & Chr(10) & _
        "POKEB x, 65" & Chr(10) & _
        "POKEW x + 2, 4660" & Chr(10) & _
        "POKED x + 8, 305419896" & Chr(10) & _
        "MEMFILLB x + 16, 7, 4" & Chr(10) & _
        "MEMCOPYB x, x + 32, 1" & Chr(10) & _
        "a = PEEKB(x)" & Chr(10) & _
        "b = PEEKW(x + 2)" & Chr(10) & _
        "c = PEEKD(x + 8)" & Chr(10) & _
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

    If ok = 0 Then End 1

    Print "PASS memory AST exec"
    End 0
End Sub

Main
