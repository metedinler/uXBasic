#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/codegen/x64/inline_backend.fbs"

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

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim srcGood As String
    srcGood = _
        "INLINE(""x64"",""nasm"",""sub"",""abi=win64;preserve=rbx,rsi,rdi,r12,r13,r14,r15;stack=16;shadow=32"")" & Chr(10) & _
        "mov rax, 1" & Chr(10) & _
        "call helper" & Chr(10) & _
        "END INLINE"

    Dim psGood As ParseState
    Dim parseErr As String
    ok And= AssertTrue(ParseText(srcGood, psGood, parseErr), "parse good inline: " & parseErr)

    Dim backendErr As String
    ok And= AssertTrue(InlineX64BackendValidate(psGood, backendErr), "x64 backend validate good inline: " & backendErr)

    Dim planCsv As String
    ok And= AssertTrue(InlineX64BackendEmitPlan(psGood, planCsv, backendErr), "x64 backend emit plan: " & backendErr)
    ok And= AssertTrue(InStr(1, planCsv, "requires_shadow32") > 0, "plan csv header")
    ok And= AssertTrue(InStr(1, planCsv, "yes") > 0, "plan csv shadow marker")

    Dim srcBad As String
    srcBad = _
        "INLINE(""x64"",""nasm"",""sub"",""abi=win64;preserve=rbx,rsi,rdi,r12,r13,r14,r15;stack=16"")" & Chr(10) & _
        "call helper" & Chr(10) & _
        "END INLINE"

    Dim psBad As ParseState
    parseErr = ""
    ok And= AssertTrue(ParseText(srcBad, psBad, parseErr), "parse bad inline sample: " & parseErr)

    backendErr = ""
    ok And= AssertTrue(InlineX64BackendValidate(psBad, backendErr) = 0, "x64 backend must reject missing shadow")

    If ok = 0 Then End 1

    Print "PASS inline x64 backend"
    End 0
End Sub

Main
