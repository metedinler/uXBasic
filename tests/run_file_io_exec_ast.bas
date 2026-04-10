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
        "OPEN ""tests\\tmp_file_io_exec.bin"" FOR binary AS #7" & Chr(10) & _
        "v = 287454020" & Chr(10) & _
        "PUT #7, 1, 4, v" & Chr(10) & _
        "SEEK #7, 1" & Chr(10) & _
        "v = 0" & Chr(10) & _
        "GET #7, 1, 4, v" & Chr(10) & _
        "POKED x, v" & Chr(10) & _
        "CLOSE #7"

    Kill "tests\\tmp_file_io_exec.bin"

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
    ok And= AssertEq(VMemPeekD(4096), 287454020, "file open/put/get/seek flow")

    Kill "tests\\tmp_file_io_exec.bin"

    If ok = 0 Then End 1

    Print "PASS file io AST exec"
    End 0
End Sub

Main
