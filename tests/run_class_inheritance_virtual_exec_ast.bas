#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    
    ' Test 1: Basic inheritance parse (EXTENDS keyword)
    src = _
        "CLASS Animal" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "name AS I32" & Chr(10) & _
        "age AS I32" & Chr(10) & _
        "METHOD Speak()" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "CLASS Dog EXTENDS Animal" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "breed AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB ANIMAL_SPEAK(self AS I32)" & Chr(10) & _
        "POKED 9804, 77" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "SUB DOG_SPEAK(self AS I32)" & Chr(10) & _
        "POKED 9808, 99" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM d AS Dog" & Chr(10) & _
        "CALL d.SPEAK()" & Chr(10) & _
        "DIM a AS Animal" & Chr(10) & _
        "CALL a.SPEAK()" & Chr(10) & _
        "POKED 9800, 1"
    
    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL inheritance parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL inheritance exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9800), 1, "inheritance parse + exec baseline")
    ok And= RTAssertEq(VMemPeekD(9808), 99, "derived override dispatch")
    ok And= RTAssertEq(VMemPeekD(9804), 77, "base dispatch fallback")

    If ok = 0 Then
        Print "FAIL inheritance assertions"
        End 1
    End If

    ' Test 2: Parse fail-fast - EXTENDS keyword with unknown base
    If RTExecExpectFail("CLASS Sub EXTENDS Unknown" & Chr(10) & "PUBLIC" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS", "CLASS: base class", errText) = 0 Then
        Print "FAIL inheritance unknown base fail-fast | "; errText
        End 1
    End If

    Print "PASS class inheritance virtual"
End Sub
