#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim ok As Integer
    ok = 1

    ExecSetFfiPolicyPath ""
    ExecSetFfiPolicyMode "REPORT_ONLY"

    Dim srcScope As String
    srcScope = _
        "NAMESPACE Core" & Chr(10) & _
        "MODULE Net" & Chr(10) & _
        "USING Core.IO" & Chr(10) & _
        "ALIAS MsgBox = CALL ( DLL , ""user32.dll"" , ""MessageBoxA"" , I32, CDECL )" & Chr(10) & _
        "END MODULE" & Chr(10) & _
        "END NAMESPACE"

    Dim psScope As ParseState
    Dim errText As String
    If RTParseProgram(srcScope, psScope, errText) = 0 Then
        Print "FAIL call_dll_alias scope-parse | "; errText
        End 1
    End If

    Dim srcExec As String
    srcExec = _
        "a = 33" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, STDCALL, a)" & Chr(10) & _
        "POKED 4320, a"

    Dim ps As ParseState
    If RTParseProgram(srcExec, ps, errText) = 0 Then
        Print "FAIL call_dll_alias exec-parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL call_dll_alias exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(4320), 33, "alias scope call continuation")

    Dim srcBadConv As String
    srcBadConv = "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, TIMER, 1)"

    Dim parseErr As String
    If RTParseExpectFail(srcBadConv, "invalid calling convention token", parseErr) = 0 Then
        Print "FAIL call_dll_alias invalid-conv parse | "; parseErr
        End 1
    End If

    If ok = 0 Then End 1
    Print "PASS run_call_dll_alias_exec_ast"
    End 0
End Sub

Main
