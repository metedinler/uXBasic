#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim errText As String

    Dim src As String
    src = _
        "MAIN" & Chr(10) & _
        "CALL(API, \"kernel32\", \"GetTickCount\", I32)" & Chr(10) & _
        "END MAIN"

    If RTExecExpectFail(src, "unsupported call API", errText) = 0 Then
        Print "FAIL call api unsupported guard | "; errText
        End 1
    End If

    Print "PASS call api unsupported exec AST"
    End 0
End Sub

Main