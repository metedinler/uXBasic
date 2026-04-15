#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "x = 7" & Chr(10) & _
        "SELECT CASE x" & Chr(10) & _
        "CASE IS < 0" & Chr(10) & _
        "POKED 7500, 1" & Chr(10) & _
        "CASE IS >= 5" & Chr(10) & _
        "POKED 7500, 2" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "POKED 7500, 3" & Chr(10) & _
        "END SELECT" & Chr(10) & _
        "y = 12" & Chr(10) & _
        "SELECT CASE y" & Chr(10) & _
        "CASE 1, 2" & Chr(10) & _
        "POKED 7504, 10" & Chr(10) & _
        "CASE IS > 10" & Chr(10) & _
        "POKED 7504, 20" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "POKED 7504, 30" & Chr(10) & _
        "END SELECT" & Chr(10) & _
        "z = 2" & Chr(10) & _
        "SELECT CASE z" & Chr(10) & _
        "CASE IS >= 3, <= 2" & Chr(10) & _
        "POKED 7508, 40" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "POKED 7508, 50" & Chr(10) & _
        "END SELECT"

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
    ok And= RTAssertEq(VMemPeekD(7500), 2, "CASE IS relational branch")
    ok And= RTAssertEq(VMemPeekD(7504), 20, "CASE literal + CASE IS mixed")
    ok And= RTAssertEq(VMemPeekD(7508), 40, "CASE IS multi comparator list")

    If RTParseExpectFail("SELECT CASE 1" & Chr(10) & "CASE IS" & Chr(10) & "PRINT 1" & Chr(10) & "END SELECT", "CASE IS: relational operator expected", errText) = 0 Then
        Print "FAIL case-is missing operator parse fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("SELECT CASE 1" & Chr(10) & "CASE IS + 2" & Chr(10) & "PRINT 1" & Chr(10) & "END SELECT", "CASE IS: relational operator expected", errText) = 0 Then
        Print "FAIL case-is invalid operator parse fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("SELECT CASE CASE" & Chr(10) & "CASE 1" & Chr(10) & "PRINT 1" & Chr(10) & "END SELECT", "SELECT CASE: selector expression is required", errText) = 0 Then
        Print "FAIL select selector missing semantic fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("SELECT CASE 1" & Chr(10) & "CASE 1" & Chr(10) & "CASE ELSE" & Chr(10) & "PRINT 9" & Chr(10) & "END SELECT", "SELECT CASE: CASE block body cannot be empty", errText) = 0 Then
        Print "FAIL select case block empty body semantic fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("SELECT CASE 1" & Chr(10) & "CASE 1" & Chr(10) & "PRINT 1" & Chr(10) & "CASE ELSE" & Chr(10) & "END SELECT", "SELECT CASE: CASE ELSE body cannot be empty", errText) = 0 Then
        Print "FAIL select case else empty body semantic fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS case is AST exec"
    End 0
End Sub

Main
