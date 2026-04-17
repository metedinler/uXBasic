#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "../src/codegen/x64/ffi_call_backend.fbs"

Private Function AssertTrue(ByVal condValue As Integer, ByRef msg As String) As Integer
    If condValue = 0 Then
        Print "FAIL "; msg
        Return 0
    End If
    Return 1
End Function

Private Function ParseSource(ByRef src As String, ByRef ps As ParseState, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    ParserInit ps, st
    If ParseProgram(ps) = 0 Then
        errOut = ps.lastError
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim src As String
    src = _
        "MAIN" & Chr(10) & _
        "a = 41" & Chr(10) & _
        "CALL(DLL, ""uxstat.dll"", ""uxstat_ping"", I32, CDECL, a)" & Chr(10) & _
        "END MAIN"

    Dim ps As ParseState
    Dim errText As String
    ok And= AssertTrue(ParseSource(src, ps, errText), "parse uxstat smoke sample: " & errText)

    Dim backendErr As String
    ok And= AssertTrue(FfiX64BackendEmitArtifacts(ps, "dist\\interop", backendErr), "emit x64 artifacts for uxstat smoke: " & backendErr)

    ExecSetFfiPolicyPath ""
    ExecSetFfiPolicyMode "REPORT_ONLY"
    ExecSetFfiResolverMode "ENFORCE"
    ExecSetFfiResolverPath "dist\\interop\\ffi_call_x64_resolver.csv"

    Dim runErr As String
    ok And= AssertTrue(ExecRunMemoryProgram(ps, runErr), "uxstat smoke exec should pass: " & runErr)
    ok And= AssertTrue(ExecDebugGetFfiX64InvokeCount() > 0, "uxstat smoke must invoke native symbol")
    ok And= AssertTrue(ExecDebugGetFfiX64LastInvokeStubId() > 0, "uxstat smoke should record invoked stub")
    ok And= AssertTrue(ExecDebugGetFfiX64SymptrProcAddrByStubId(ExecDebugGetFfiX64LastInvokeStubId()) <> 0, "uxstat smoke symptr must hold resolved proc")

    If ok = 0 Then End 1
    Print "PASS uxstat smoke exec ast"
    End 0
End Sub

Main
