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
    If ExecRunMemoryProgram(ps, errOut) = 0 Then Return 0
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
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, STDCALL, a)" & Chr(10) & _
        "END MAIN"

    Dim ps As ParseState
    Dim errText As String
    ok And= AssertTrue(ParseSource(src, ps, errText), "parse cleanup proof sample: " & errText)

    Dim backendErr As String
    ok And= AssertTrue(FfiX86BackendEmitArtifacts(ps, "dist\\interop", backendErr), "emit x86 artifacts: " & backendErr)

    ExecSetFfiPolicyPath ""
    ExecSetFfiPolicyMode "REPORT_ONLY"
    ExecSetFfiResolverMode "ENFORCE"
    ExecSetFfiResolverPath "dist\\interop\\ffi_call_x86_resolver.csv"

    Dim runErr As String
    ok And= AssertTrue(RunExecExpectOk(ps, runErr), "exec with resolver enforce: " & runErr)

    ok And= AssertTrue(ExecDebugGetFfiX86ResolvedCount() > 0, "resolved proc cache should not be empty")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrMapCount() > 0, "symptr map should not be empty")
    ok And= AssertTrue(ExecDebugGetFfiX86InvokeCount() >= 2, "invoke proof should execute both resolver calls")
    ok And= AssertTrue(ExecDebugGetFfiX86CallerCleanupBytes() >= 4, "cdecl caller cleanup bytes proof")
    ok And= AssertTrue(ExecDebugGetFfiX86CalleeCleanupBytes() >= 4, "stdcall callee cleanup bytes proof")
    ok And= AssertTrue(ExecDebugGetFfiX86LastInvokeStubId() > 0, "last invoke stub id should be tracked")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrWriteCount() >= 2, "symptr write-through should track both stubs")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrLabelByStubId(1) = "__uxb_ffi_x86_symptr_1", "stub1 symptr label mapping")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrLabelByStubId(2) = "__uxb_ffi_x86_symptr_2", "stub2 symptr label mapping")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrProcAddrByStubId(1) <> 0, "stub1 symptr proc address should be non-zero")
    ok And= AssertTrue(ExecDebugGetFfiX86SymptrProcAddrByStubId(2) <> 0, "stub2 symptr proc address should be non-zero")

    Dim cleanupErr As String
    ok And= AssertTrue(ExecX86FfiValidateCleanupContract(cleanupErr), "cleanup contract must validate: " & cleanupErr)

    If ok = 0 Then End 1
    Print "PASS ffi x86 resolver cleanup proof"
    End 0
End Sub

Main
