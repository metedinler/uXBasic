#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function RunAndExpectPrintCol(ByRef src As String, ByVal expectedCol As Integer, ByRef msg As String) As Integer
    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse | "; msg; " | "; errText
        Return 0
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec | "; msg; " | "; errText
        Return 0
    End If

    Return RTAssertEq(ExecDebugGetPrintColumnPos(), expectedCol, msg)
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    ok And= RunAndExpectPrintCol("PRINT 1,", 14, "comma aligns to first zone stop")
    ok And= RunAndExpectPrintCol("PRINT ""12345678901234"",", 28, "exact-zone width advances to next zone")
    ok And= RunAndExpectPrintCol("PRINT 1;", 1, "semicolon suppresses newline and keeps column")
    ok And= RunAndExpectPrintCol("PRINT 1", 0, "plain print emits newline and resets column")
    ok And= RunAndExpectPrintCol("PRINT 12, 3;", 15, "comma zone + trailing semicolon mixed")

    If ok = 0 Then End 1

    Print "PASS print zone AST exec"
    End 0
End Sub

Main
