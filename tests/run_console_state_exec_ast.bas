#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "LOCATE 3, 7" & Chr(10) & _
        "COLOR 2, 0" & Chr(10) & _
        "CLS" & Chr(10) & _
        "LOCATE 4, 9" & Chr(10) & _
        "COLOR 15, 1" & Chr(10) & _
        "POKED 7600, 1"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(7600), 1, "console statements keep execution flow")
    ok And= RTAssertEq(ExecDebugGetLocateRow(), 4, "LOCATE tracks last row")
    ok And= RTAssertEq(ExecDebugGetLocateCol(), 9, "LOCATE tracks last col")
    ok And= RTAssertEq(ExecDebugGetColorFg(), 15, "COLOR tracks last fg")
    ok And= RTAssertEq(ExecDebugGetColorBg(), 1, "COLOR tracks last bg")
    ok And= RTAssertEq(ExecDebugGetClsCount(), 1, "CLS call count")

    If ok = 0 Then End 1

    Print "PASS console state AST exec"
    End 0
End Sub

Main
