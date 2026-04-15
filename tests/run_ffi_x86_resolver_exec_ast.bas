#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "../src/codegen/x86/ffi_call_backend.fbs"

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

Private Function RunExecExpectOk(ByRef ps As ParseState, ByRef errOut As String) As Integer
    errOut = ""
    If ExecRunMemoryProgram(ps, errOut) = 0 Then
        Return 0
    End If
    Return 1
End Function

Private Function RunExecExpectFail(ByRef ps As ParseState, ByRef errOut As String) As Integer
    errOut = ""
    If ExecRunMemoryProgram(ps, errOut) <> 0 Then
        errOut = "expected exec failure"
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
        "a = 1" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, CDECL, a)" & Chr(10) & _
        "END MAIN"

    Dim ps As ParseState
    Dim errText As String

    ok And= AssertTrue(ParseSource(src, ps, errText), "parse ffi x86 resolver sample: " & errText)

    Dim backendErr As String
    ok And= AssertTrue(FfiX86BackendEmitArtifacts(ps, "dist\\interop", backendErr), "emit x86 artifacts: " & backendErr)

    ExecSetFfiPolicyPath ""
    ExecSetFfiPolicyMode "REPORT_ONLY"

    ExecSetFfiResolverMode "ENFORCE"
    ExecSetFfiResolverPath "dist\\interop\\ffi_call_x86_resolver.csv"

    Dim runErr As String
    ok And= AssertTrue(RunExecExpectOk(ps, runErr), "resolver enforce success path: " & runErr)
    ok And= AssertTrue(ExecDebugGetFfiX86ResolvedCount() > 0, "resolver must cache at least one bound symbol")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrMapCount() > 0, "resolver should populate symptr map")
    ok And= AssertTrue(ExecDebugGetFfiX86InvokeCount() > 0, "resolver invoke proof should execute")
    ok And= AssertTrue(ExecDebugGetFfiX86CallerCleanupBytes() >= 4, "cdecl caller cleanup proof should accumulate bytes")
    ok And= AssertTrue(ExecDebugGetFfiX86LastInvokeStubId() > 0, "resolver invoke should record stub id")

    ExecSetFfiResolverPath "dist\\interop\\missing_x86_resolver.csv"
    ok And= AssertTrue(RunExecExpectFail(ps, runErr), "resolver enforce missing file must fail")
    ok And= AssertTrue(InStr(1, runErr, "9216") > 0, "resolver missing code 9216")

    ExecSetFfiResolverMode "REPORT_ONLY"
    ok And= AssertTrue(RunExecExpectOk(ps, runErr), "resolver report-only missing file should continue: " & runErr)

    If ok = 0 Then End 1

    Print "PASS ffi x86 resolver exec ast"
    End 0
End Sub

Main
