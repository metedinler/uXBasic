#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/codegen/x64/code_generator.fbs"

Private Function ReadTextFile(ByRef filePath As String, ByRef textOut As String) As Integer
    Dim f As Integer
    f = FreeFile

    Open filePath For Input As #f
    If Err <> 0 Then Return 0

    textOut = ""
    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        textOut &= lineText
        If Not Eof(f) Then textOut &= Chr(10)
    Loop

    Close #f
    Return 1
End Function

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

Private Function HasAnyToken(ByRef textIn As String, ByRef tokenA As String, ByRef tokenB As String) As Integer
    Return HasToken(textIn, tokenA) Or HasToken(textIn, tokenB)
End Function

Private Sub Main()
    Dim fixturePath As String
    fixturePath = "tests\\fixtures\\codegen\\stack_frame_locals.bas"

    Dim src As String
    Dim ok As Integer
    ok = 1

    ok And= AssertTrue(ReadTextFile(fixturePath, src), "read fixture: " & fixturePath)

    Dim ps As ParseState
    Dim errText As String
    ok And= AssertTrue(ParseText(src, ps, errText), "parse fixture: " & errText)

    Dim asmText As String
    errText = ""
    ok And= AssertTrue(X64CodegenEmitNasm(ps, asmText, errText), "x64 codegen emit: " & errText)

    ok And= AssertTrue(HasToken(asmText, "global __uxb_main"), "main label emit")
    ok And= AssertTrue(HasToken(asmText, "push rbp"), "stack frame prologue push rbp")
    ok And= AssertTrue(HasToken(asmText, "mov rbp, rsp"), "stack frame prologue mov rbp,rsp")
    ok And= AssertTrue(HasToken(asmText, "sub rsp,"), "call shadow-space/local stack reservation")
    ok And= AssertTrue(HasAnyToken(asmText, "leave", "mov rsp, rbp"), "stack frame epilogue")

    ok And= AssertTrue(HasToken(asmText, "[rbp - 8], rcx"), "param register spill rcx")
    ok And= AssertTrue(HasToken(asmText, "[rbp - 16], rdx"), "param register spill rdx")

    ok And= AssertTrue(HasToken(asmText, "[rbp - 24]"), "local stack slot addressing")
    ok And= AssertTrue(HasToken(asmText, "[rbp -"), "local storage rbp-relative pattern")

    ok And= AssertTrue(HasToken(asmText, "__uxb_var_global_"), "global variable symbol reference")
    ok And= AssertTrue(HasToken(asmText, "jmp __uxb_ret_"), "RETURN branches to shared routine epilog")

    If ok = 0 Then End 1

    Print "PASS x64 codegen stack frame locals"
    End 0
End Sub

Main
