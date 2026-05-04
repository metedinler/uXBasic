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
        "ALIAS Tick = CALL ( DLL , ""kernel32.dll"" , ""GetTickCount"" , I32, STDCALL )" & Chr(10) & _
        "ALIAS TickAs AS CALL ( DLL , ""kernel32.dll"" , ""GetTickCount"" , I32, STDCALL )" & Chr(10) & _
        "ALIAS TickBare CALL ( DLL , ""kernel32.dll"" , ""GetTickCount"" , I32, STDCALL )" & Chr(10) & _
        "END MODULE" & Chr(10) & _
        "END NAMESPACE" & Chr(10) & _
        "MAIN" & Chr(10) & _
        "a = 33" & Chr(10) & _
        "CALL(Tick, a)" & Chr(10) & _
        "CALL(TickAs, a)" & Chr(10) & _
        "CALL(TickBare, a)" & Chr(10) & _
        "POKED 4320, a" & Chr(10) & _
        "END MAIN"

    Dim psScope As ParseState
    Dim errText As String
    If RTParseProgram(srcScope, psScope, errText) = 0 Then
        Print "FAIL call_dll_alias scope-parse | "; errText
        End 1
    End If

    If RTExecProgram(psScope, errText) = 0 Then
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

    Dim srcAliasStrptrBad As String
    srcAliasStrptrBad = _
        "MAIN" & Chr(10) & _
        "ALIAS ShowText = CALL ( DLL , ""user32.dll"" , ""MessageBoxA"" , STRPTR, CDECL )" & Chr(10) & _
        "x = 42" & Chr(10) & _
        "CALL(ShowText, x)" & Chr(10) & _
        "END MAIN"

    Dim execErr As String
    If RTExecExpectFail(srcAliasStrptrBad, "STRPTR requires string argument", execErr) = 0 Then
        Print "FAIL call_dll_alias strptr-marshalling | "; execErr
        End 1
    End If

    Dim srcAliasU64Bad As String
    srcAliasU64Bad = _
        "MAIN" & Chr(10) & _
        "ALIAS Counter = CALL ( DLL , ""kernel32.dll"" , ""GetTickCount"" , U64, CDECL )" & Chr(10) & _
        "n = -1" & Chr(10) & _
        "CALL(Counter, n)" & Chr(10) & _
        "END MAIN"

    If RTExecExpectFail(srcAliasU64Bad, "U64 argument cannot be negative", execErr) = 0 Then
        Print "FAIL call_dll_alias u64-marshalling | "; execErr
        End 1
    End If

    If ok = 0 Then End 1
    Print "PASS run_call_dll_alias_exec_ast"
    End 0
End Sub

Main
