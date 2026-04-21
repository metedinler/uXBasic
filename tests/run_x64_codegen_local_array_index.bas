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
        "SUB Fill()" & Chr(10) & _
        "    DIM arr(0 TO 2) AS I32" & Chr(10) & _
        "    DIM i AS I32" & Chr(10) & _
        "    i = 1" & Chr(10) & _
        "    PRINT arr(i)" & Chr(10) & _
        "    RETURN" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "CALL Fill()"

    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer
    ok = 1

    ok And= AssertTrue(ParseText(src, ps, errText), "parse source: " & errText)

    Dim asmText As String
    errText = ""
    ok And= AssertTrue(X64CodegenEmitNasm(ps, asmText, errText), "x64 codegen emit: " & errText)

    ok And= AssertTrue(HasToken(asmText, "lea rcx, [rbp -"), "local array base address uses rbp-relative addressing")
    ok And= AssertTrue(HasToken(asmText, "add rcx, rbx"), "array index linearization offset add emitted")
    ok And= AssertTrue(HasToken(asmText, "mov rax, [rcx]"), "indexed local array load emitted")
    ok And= AssertTrue(HasToken(asmText, "jmp __uxb_ret_"), "RETURN uses shared epilog label")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_runtime_print"), "print call emitted")

    If ok = 0 Then End 1

    Print "PASS x64 codegen local array index"
    End 0
End Sub

Main
