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
        Print "FAIL H5-F80 | "; msg
        Return 0
    End If
    Return 1
End Function

Private Sub Main()
    Dim src As String
    src = _
        "TYPE Precise" & Chr(10) & _
        "    x AS F80" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "DIM p AS Precise" & Chr(10) & _
        "p.x = 1.25" & Chr(10) & _
        "PRINT p.x"

    Dim ps As ParseState
    Dim errText As String
    Dim asmText As String

    If AssertTrue(ParseText(src, ps, errText), "parse source: " & errText) = 0 Then End 1

    errText = ""
    If X64CodegenEmitNasm(ps, asmText, errText) = 0 Then
        Print "FAIL H5-F80 | codegen failed: " & errText
        End 1
    End If

    If AssertTrue(InStr(1, UCase(errText), UCase("not implemented")) = 0, "legacy not-implemented diagnostic should not appear: " & errText) = 0 Then End 1
    If AssertTrue(InStr(1, UCase(asmText), UCase("mov [rcx + 8], ax")) > 0, "missing F80 field store lane in asm") = 0 Then End 1
    If AssertTrue(InStr(1, UCase(asmText), UCase("fld tword [rax]")) > 0, "missing F80 field print conversion lane in asm") = 0 Then End 1

    Print "PASS H5 F80 field lane"
    End 0
End Sub

Main
