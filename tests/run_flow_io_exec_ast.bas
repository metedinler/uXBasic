#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim tmpPath As String
    tmpPath = "tests\\tmp_flow_input_exec.bin"
    Kill tmpPath

    Open tmpPath For Binary As #1
    Dim inA As Integer
    Dim inB As Integer
    inA = 287454020
    inB = -9
    Put #1, 1, inA
    Put #1, 5, inB
    Close #1

    Dim src As String
    src = _
        "x = 3" & Chr(10) & _
        "IF x = 3 THEN" & Chr(10) & _
        "POKED 6000, 11" & Chr(10) & _
        "ELSEIF x = 4 THEN" & Chr(10) & _
        "POKED 6000, 22" & Chr(10) & _
        "ELSE" & Chr(10) & _
        "POKED 6000, 33" & Chr(10) & _
        "END IF" & Chr(10) & _
        "SELECT CASE x" & Chr(10) & _
        "CASE 1, 2" & Chr(10) & _
        "POKED 6004, 21" & Chr(10) & _
        "CASE 3" & Chr(10) & _
        "POKED 6004, 31" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "POKED 6004, 99" & Chr(10) & _
        "END SELECT" & Chr(10) & _
        "PRINT x, x + 1" & Chr(10) & _
        "x = 4" & Chr(10) & _
        "IF x = 3 THEN" & Chr(10) & _
        "POKED 6016, 11" & Chr(10) & _
        "ELSEIF x = 4 THEN" & Chr(10) & _
        "POKED 6016, 44" & Chr(10) & _
        "ELSE" & Chr(10) & _
        "POKED 6016, 77" & Chr(10) & _
        "END IF" & Chr(10) & _
        "x = 8" & Chr(10) & _
        "SELECT CASE x" & Chr(10) & _
        "CASE 3" & Chr(10) & _
        "POKED 6020, 31" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "POKED 6020, 98" & Chr(10) & _
        "END SELECT" & Chr(10) & _
        "LOCATE 2, 5" & Chr(10) & _
        "COLOR 2, 0" & Chr(10) & _
        "CLS" & Chr(10) & _
        "POKED 6024, 1" & Chr(10) & _
        "OPEN ""tests\\tmp_flow_input_exec.bin"" FOR BINARY AS #1" & Chr(10) & _
        "INPUT #1, a" & Chr(10) & _
        "CLOSE #1" & Chr(10) & _
        "POKED 6008, a"

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

    ok And= RTAssertEq(VMemPeekD(6000), 11, "IF true branch")
    ok And= RTAssertEq(VMemPeekD(6004), 31, "SELECT exact case")
    ok And= RTAssertEq(VMemPeekD(6008), 287454020, "INPUT# first value")
    ok And= RTAssertEq(VMemPeekD(6016), 44, "IF ELSEIF branch")
    ok And= RTAssertEq(VMemPeekD(6020), 98, "SELECT CASE ELSE")
    ok And= RTAssertEq(VMemPeekD(6024), 1, "LOCATE/COLOR/CLS continuation")

    Kill tmpPath

    If ok = 0 Then End 1

    Print "PASS flow/io AST exec"
    End 0
End Sub

Main
