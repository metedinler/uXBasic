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
        Print "FAIL H5 | "; msg
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
        "TYPE Point" & Chr(10) & _
        "    x AS F64" & Chr(10) & _
        "    y AS F64" & Chr(10) & _
        "    z AS F32" & Chr(10) & _
        "    i AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "DIM p AS Point" & Chr(10) & _
        "p.x = 1.5" & Chr(10) & _
        "p.y = 2.75" & Chr(10) & _
        "p.z = 3.25" & Chr(10) & _
        "p.i = 7" & Chr(10) & _
        "PRINT p.x + p.y" & Chr(10) & _
        "PRINT p.z" & Chr(10) & _
        "PRINT p.i"

    Dim ps As ParseState
    Dim errText As String
    Dim asmText As String
    Dim ok As Integer
    ok = 1

    ok And= AssertTrue(ParseText(src, ps, errText), "parse source: " & errText)
    ok And= AssertTrue(X64CodegenEmitNasm(ps, asmText, errText), "x64 codegen emit: " & errText)

    ok And= AssertTrue(HasToken(asmText, "movsd [rax], xmm0"), "F64 field store should use movsd")
    ok And= AssertTrue(HasToken(asmText, "movss [rax], xmm0"), "F32 field store should use movss")
    ok And= AssertTrue(HasToken(asmText, "movsd xmm0, [rax]"), "F64 field load should use movsd")
    ok And= AssertTrue(HasToken(asmText, "movss xmm0, [rax]"), "F32 field load should use movss")
    ok And= AssertTrue(HasToken(asmText, "movsxd rax, dword [rax]"), "I32 field load should use movsxd")
    ok And= AssertTrue(HasToken(asmText, "add rax, "), "field offset add should be emitted")

    If ok = 0 Then End 1

    Print "PASS H5 x64 type field codegen"
    End 0
End Sub

Main
