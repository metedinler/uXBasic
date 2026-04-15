#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "DIM a AS I32, b AS I32" & Chr(10) & _
        "DIM initX AS I32 = 9" & Chr(10) & _
        "DIM arr(0 TO 2) AS I32" & Chr(10) & _
        "REDIM arr(0 TO 4) AS I32" & Chr(10) & _
        "a = 11" & Chr(10) & _
        "POKED 7400, a" & Chr(10) & _
        "POKED 7404, initX"

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
    ok And= RTAssertEq(VMemPeekD(7400), 11, "DIM scalar assignment survives REDIM")
    ok And= RTAssertEq(VMemPeekD(7404), 9, "DIM initializer applied")

    If RTExecExpectFail("DIM x AS I32" & Chr(10) & "DIM x AS I32", "duplicate variable X", errText) = 0 Then
        Print "FAIL duplicate DIM fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("DIM arr(3 TO 1) AS I32", "invalid array bounds", errText) = 0 Then
        Print "FAIL DIM bounds fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("DIM grid(0 TO 1, 0 TO 1) AS I32", "only single-dimension arrays supported in R3.N", errText) = 0 Then
        Print "FAIL DIM multi-dim fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("REDIM arr(0 TO 2) AS I32", "variable not declared ARR", errText) = 0 Then
        Print "FAIL REDIM undeclared fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("DIM x AS I32" & Chr(10) & "REDIM x(0 TO 2) AS I32", "target is not array X", errText) = 0 Then
        Print "FAIL REDIM scalar fail-fast | "; errText
        End 1
    End If

    Dim srcRedimMulti As String
    srcRedimMulti = _
        "DIM arr(0 TO 2) AS I32" & Chr(10) & _
        "REDIM arr(0 TO 1, 0 TO 1) AS I32" & Chr(10) & _
        "POKED 7408, 1"

    Dim psRedimMulti As ParseState
    errText = ""
    If RTParseProgram(srcRedimMulti, psRedimMulti, errText) = 0 Then
        Print "FAIL REDIM multi-dim parse | "; errText
        End 1
    End If

    errText = ""
    If RTExecProgram(psRedimMulti, errText) = 0 Then
        Print "FAIL REDIM multi-dim exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7408), 1, "REDIM multi-dim executes")

    Dim srcRedimPreserve As String
    srcRedimPreserve = _
        "DIM arr(0 TO 2) AS I32" & Chr(10) & _
        "REDIM PRESERVE arr(0 TO 4) AS I32" & Chr(10) & _
        "POKED 7412, 1"

    Dim psRedimPreserve As ParseState
    errText = ""
    If RTParseProgram(srcRedimPreserve, psRedimPreserve, errText) = 0 Then
        Print "FAIL REDIM PRESERVE parse | "; errText
        End 1
    End If

    errText = ""
    If RTExecProgram(psRedimPreserve, errText) = 0 Then
        Print "FAIL REDIM PRESERVE exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7412), 1, "REDIM PRESERVE executes")

    If RTExecExpectFail("DIM arr(0 TO 2) AS I32" & Chr(10) & "REDIM arr(0 TO 1, 2 TO 1) AS I32", "invalid array bounds", errText) = 0 Then
        Print "FAIL REDIM multi-dim invalid bound fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("DIM arr(0 TO 2) AS I32" & Chr(10) & "REDIM arr(0 TO 2) AS F64", "type mismatch for ARR", errText) = 0 Then
        Print "FAIL REDIM type mismatch fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS dim/redim AST exec"
    End 0
End Sub

Main
