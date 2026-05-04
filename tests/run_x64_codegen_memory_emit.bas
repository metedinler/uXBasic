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
        "DIM x AS I32" & Chr(10) & _
        "x = 4096" & Chr(10) & _
        "POKEB x, 65" & Chr(10) & _
        "POKES x + 1, ""AB""" & Chr(10) & _
        "MEMCOPYB x, x + 16, 2" & Chr(10) & _
        "MEMCOPYW x, x + 24, 1" & Chr(10) & _
        "MEMCOPYD x, x + 32, 1" & Chr(10) & _
        "MEMFILLB x + 40, 7, 3" & Chr(10) & _
        "MEMFILLW x + 48, 4660, 2" & Chr(10) & _
        "MEMFILLD x + 56, 305419896, 1" & Chr(10) & _
        "SETNEWOFFSET x, 8192" & Chr(10) & _
        "a = PEEKB(x)"

    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer
    ok = 1

    ok And= AssertTrue(ParseText(src, ps, errText), "parse source: " & errText)

    Dim asmText As String
    errText = ""
    ok And= AssertTrue(X64CodegenEmitNasm(ps, asmText, errText), "x64 codegen emit: " & errText)

    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_pokeb"), "POKEB emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_pokes"), "POKES emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_copyb"), "MEMCOPYB emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_copyw"), "MEMCOPYW emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_copyd"), "MEMCOPYD emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_fillb"), "MEMFILLB emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_fillw"), "MEMFILLW emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_filld"), "MEMFILLD emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_set_new_offset"), "SETNEWOFFSET emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_mem_peekb"), "PEEKB emit")

    ok And= AssertTrue(HasToken(asmText, "__uxb_mem_pokes:"), "POKES helper")
    ok And= AssertTrue(HasToken(asmText, "__uxb_mem_copyb:"), "MEMCOPY helper")
    ok And= AssertTrue(HasToken(asmText, "__uxb_mem_fillb:"), "MEMFILL helper")
    ok And= AssertTrue(HasToken(asmText, "__uxb_set_new_offset:"), "SETNEWOFFSET helper")

    If ok = 0 Then End 1

    Print "PASS x64 codegen memory emit"
    End 0
End Sub

Main
