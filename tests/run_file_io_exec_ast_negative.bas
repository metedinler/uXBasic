#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "../src/runtime/file_io.fbs"

Private Function ContainsText(ByRef haystack As String, ByRef needle As String) As Integer
    Return Instr(UCase(haystack), UCase(needle)) > 0
End Function

Private Function RunExpectExecFail(ByRef src As String, ByRef expectedPrefix As String, ByVal expectedCode As Integer, ByRef labelText As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        Print "FAIL parse "; labelText; " | "; ps.lastError
        Return 0
    End If

    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) <> 0 Then
        Print "FAIL expected exec failure "; labelText
        Return 0
    End If

    Dim codeText As String
    codeText = "(" & LTrim(Str(expectedCode)) & ")"

    If ContainsText(execErr, expectedPrefix) = 0 Then
        Print "FAIL wrong prefix "; labelText; " | err="; execErr
        Return 0
    End If

    If ContainsText(execErr, codeText) = 0 Then
        Print "FAIL wrong code "; labelText; " expected="; codeText; " err="; execErr
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim tmpPath As String
    tmpPath = "tests\\tmp_file_io_exec_neg.bin"
    Kill tmpPath

    Open tmpPath For Output As #1
    Print #1, "seed"
    Close #1

    Dim srcOpen As String
    srcOpen = "OPEN ""tests\\__missing_file_io_exec__.bin"" FOR INPUT AS #31"
    ok And= RunExpectExecFail(srcOpen, "OPEN failed", UXB_FILE_ERR_NOT_FOUND, "OPEN missing")

    Dim srcGet As String
    srcGet = "v = 0" & Chr(10) & "GET #32, v"
    ok And= RunExpectExecFail(srcGet, "GET failed", UXB_FILE_ERR_CHANNEL_NOT_OPEN, "GET closed channel")

    Dim srcPut As String
    srcPut = "OPEN """ & tmpPath & """ FOR INPUT AS #33" & Chr(10) & _
             "PUT #33, 1, 4, 1"
    ok And= RunExpectExecFail(srcPut, "PUT failed", UXB_FILE_ERR_MODE_NOT_WRITABLE, "PUT input mode")

    Dim srcSeek As String
    srcSeek = "OPEN """ & tmpPath & """ FOR APPEND AS #34" & Chr(10) & _
              "SEEK #34, 1"
    ok And= RunExpectExecFail(srcSeek, "SEEK failed", UXB_FILE_ERR_SEEK_NOT_ALLOWED, "SEEK append mode")

    Kill tmpPath

    If ok = 0 Then End 1

    Print "PASS file io AST exec negative"
    End 0
End Sub

Main