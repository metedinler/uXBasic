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

    Dim src As String
    src = _
        "NAMESPACE App" & Chr(10) & _
        "MODULE Net" & Chr(10) & _
        "END MODULE" & Chr(10) & _
        "END NAMESPACE" & Chr(10) & _
        "MAIN" & Chr(10) & _
        "a = 21" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, CDECL, a)" & Chr(10) & _
        "POKED 4300, a" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, STDCALL, a)" & Chr(10) & _
        "POKED 4304, a" & Chr(10) & _
        "END MAIN"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL call_dll_scope parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL call_dll_scope exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(4300), 21, "cdecl call continuation")
    ok And= RTAssertEq(VMemPeekD(4304), 21, "stdcall call continuation")

    If ok = 0 Then End 1
    Print "PASS run_call_dll_scope_exec_ast"
    End 0
End Sub

Main
