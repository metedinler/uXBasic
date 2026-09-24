#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "DIM l AS LIST" & Chr(10) & _
        "CALL LISTADD(l, 10)" & Chr(10) & _
        "CALL LISTADD(l, 20)" & Chr(10) & _
        "POKED 9400, LISTLEN(l)" & Chr(10) & _
        "POKED 9404, LISTGET(l, 1)" & Chr(10) & _
        "DIM d AS DICT" & Chr(10) & _
        "CALL DICTSET(d, ""A"", 42)" & Chr(10) & _
        "POKED 9408, DICTGET(d, ""A"")" & Chr(10) & _
        "DIM s AS SET" & Chr(10) & _
        "CALL SETADD(s, ""X"")" & Chr(10) & _
        "POKED 9412, SETLEN(s)"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL collection engine parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL collection engine exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9400), 2, "LISTLEN after two adds")
    ok And= RTAssertEq(VMemPeekD(9404), 20, "LISTGET index 1")
    ok And= RTAssertEq(VMemPeekD(9408), 42, "DICTGET existing key")
    ok And= RTAssertEq(VMemPeekD(9412), 1, "SETLEN after one add")

    If RTExecExpectFail("DIM d AS DICT" & Chr(10) & "x = DICTGET(d, ""MISSING"")", "DICT key not found", errText) = 0 Then
        Print "FAIL collection engine fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS collection engine exec"
    End 0
End Sub

Main
