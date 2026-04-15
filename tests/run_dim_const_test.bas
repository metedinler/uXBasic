#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Print "Starting DIM/CONST test..."

    Dim src As String
    src = _
        "DIM x" & Chr(10) & _
        "DIM y, z" & Chr(10) & _
        "CONST PI = 3" & Chr(10) & _
        "CONST E = 2" & Chr(10) & _
        "x = PI + E" & Chr(10) & _
        "PRINT x"

    Print "Source code:"
    Print src
    Print ""

    Dim ps As ParseState
    Dim errText As String
    Print "Parsing..."
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "Parse failed: "; errText
        Exit Sub
    End If
    Print "Parse OK"

    Print "Executing..."
    If RTExecProgram(ps, errText) = 0 Then
        Print "Exec failed: "; errText
        Exit Sub
    End If
    Print "Exec OK"

    If RTParseExpectFail("CONST A =", "CONST:", errText) = 0 Then
        Print "FAIL CONST rhs fail-fast | "; errText
        End 1
    End If

    Print "Test passed: DIM and CONST statements executed"
End Sub