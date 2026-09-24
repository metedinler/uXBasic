#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim errText As String

    ExecSetFfiPolicyPath ""
    ExecSetFfiPolicyMode "REPORT_ONLY"

    Dim src As String
    src = _
        "MAIN" & Chr(10) & _
        "msg = ""uxbasic-x64-signature-smoke""" & Chr(10) & _
        "t0 = TIMER(""ms"")" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""Sleep"", U64, STDCALL, 30)" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""Sleep"", BYVAL, STDCALL, 30)" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""OutputDebugStringA"", STRPTR, STDCALL, msg)" & Chr(10) & _
        "CALL(DLL, ""msvcrt.dll"", ""sqrt"", F64, 9)" & Chr(10) & _
        "t1 = TIMER(""ms"")" & Chr(10) & _
        "delta = t1 - t0" & Chr(10) & _
        "POKED 5004, delta" & Chr(10) & _
        "END MAIN"

    Dim ps As ParseState
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL call_dll_x64_signature_runtime_smoke parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL call_dll_x64_signature_runtime_smoke exec | "; errText
        End 1
    End If

    Dim deltaMs As Integer
    deltaMs = VMemPeekD(5004)
    If deltaMs < 35 Then
        Print "FAIL call_dll_x64_signature_runtime_smoke delta<35 actual="; deltaMs
        End 1
    End If

    Print "PASS run_call_dll_x64_signature_runtime_smoke"
    End 0
End Sub

Main
