#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/codegen/x64/code_generator.fbs"

Private Function ParseText(ByRef src As String, ByRef ps As ParseState, ByRef errText As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    ParserInit ps, st
    If ParseProgram(ps) = 0 Then
        errText = ps.lastError
        Return 0
    End If

    Return 1
End Function

Private Function AssertTrue(ByVal condValue As Integer, ByRef msg As String) As Integer
    If condValue = 0 Then
        Print "FAIL "; msg
        Return 0
    End If
    Return 1
End Function

Private Function HasToken(ByRef textIn As String, ByRef tokenText As String) As Integer
    Return InStr(1, textIn, tokenText) > 0
End Function

Private Sub Main()
    Dim src As String
    src = _
        "x = 1" & Chr(10) & _
        "IF x = 1 THEN" & Chr(10) & _
        "PRINT x" & Chr(10) & _
        "END IF" & Chr(10) & _
        "PRINT x"

    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer
    ok = 1

    ok And= AssertTrue(ParseText(src, ps, errText), "parse source: " & errText)

    Dim asmText As String
    errText = ""
    ok And= AssertTrue(X64CodegenEmitNasm(ps, asmText, errText), "x64 codegen emit: " & errText)

    ok And= AssertTrue(HasToken(asmText, "global __uxb_main"), "main label emit")
    ok And= AssertTrue(HasToken(asmText, "cmp rax, rbx"), "comparison emit")
    ok And= AssertTrue(HasToken(asmText, "__uxb_if_end_"), "IF label emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_runtime_print"), "PRINT bridge emit")
    ok And= AssertTrue(HasToken(asmText, "mov [rel __uxb_var_global_x], rax"), "assignment store emit")

    If ok = 0 Then End 1

    Print "PASS x64 codegen emit"
    End 0
End Sub

Main
