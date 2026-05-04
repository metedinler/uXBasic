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
        "x = 10" & Chr(10) & _
        "INC x" & Chr(10) & _
        "DEC x" & Chr(10) & _
        "y = ABS(-5)" & Chr(10) & _
        "z = SQR(9)" & Chr(10) & _
        "w = SIN(0) + COS(0)" & Chr(10) & _
        "m = (x SHL 1) | 3" & Chr(10) & _
        "a = x XOR y" & Chr(10) & _
        "b = x & y" & Chr(10) & _
        "c = x AND y" & Chr(10) & _
        "d = x MOD y" & Chr(10) & _
        "e = x * y" & Chr(10) & _
        "f = x / y" & Chr(10) & _
        "g = x ROL 1" & Chr(10) & _
        "h = x ROR 1" & Chr(10) & _
        "k = x SHR 1" & Chr(10) & _
        "l = x SHL 2"

    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer
    ok = 1

    ok And= AssertTrue(ParseText(src, ps, errText), "parse source: " & errText)

    Dim asmText As String
    errText = ""
    ok And= AssertTrue(X64CodegenEmitNasm(ps, asmText, errText), "x64 codegen emit: " & errText)

    ok And= AssertTrue(HasToken(asmText, "call __uxb_builtin_abs"), "ABS emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_builtin_sqr"), "SQR emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_builtin_sin"), "SIN emit")
    ok And= AssertTrue(HasToken(asmText, "call __uxb_builtin_cos"), "COS emit")
    ok And= AssertTrue(HasToken(asmText, "add rax, 1"), "INC emit")
    ok And= AssertTrue(HasToken(asmText, "sub rax, 1"), "DEC emit")
    ok And= AssertTrue(HasToken(asmText, "shl rax, cl"), "SHL emit")
    ok And= AssertTrue(HasToken(asmText, "or rax, rbx"), "OR emit")
    ok And= AssertTrue(HasToken(asmText, "xor rax, rbx"), "XOR emit")
    ok And= AssertTrue(HasToken(asmText, "and rax, rbx"), "AND(bitwise) emit")
    ok And= AssertTrue(HasToken(asmText, "neg rax"), "AND/OR logical emit uses neg")
    ok And= AssertTrue(HasToken(asmText, "idiv rbx"), "DIV emit")
    ok And= AssertTrue(HasToken(asmText, "mov rax, rdx"), "MOD emit")
    ok And= AssertTrue(HasToken(asmText, "imul rax, rbx"), "MUL emit")
    ok And= AssertTrue(HasToken(asmText, "rol rax, cl"), "ROL emit")
    ok And= AssertTrue(HasToken(asmText, "ror rax, cl"), "ROR emit")
    ok And= AssertTrue(HasToken(asmText, "sar rax, cl"), "SHR emit")

    If ok = 0 Then End 1

    Print "PASS x64 codegen operator numeric emit"
    End 0
End Sub

Main
