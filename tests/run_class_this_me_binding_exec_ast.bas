#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer
    ok = 1

    ' Test 1: METHOD declaration parse + THIS/ME runtime binding via dotted dispatch
    src = _
        "CLASS Box" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "value AS I32" & Chr(10) & _
        "METHOD SetByThis()" & Chr(10) & _
        "METHOD SetByMe()" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB BOX_SETBYTHIS(self AS I32)" & Chr(10) & _
        "POKED THIS + OFFSETOF(Box, ""value""), 111" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "SUB BOX_SETBYME(self AS I32)" & Chr(10) & _
        "POKED ME + OFFSETOF(Box, ""value""), 222" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM b AS Box" & Chr(10) & _
        "CALL b.SetByThis()" & Chr(10) & _
        "POKED 9860, PEEKD(VARPTR(b) + OFFSETOF(Box, ""value""))" & Chr(10) & _
        "CALL b.SetByMe()" & Chr(10) & _
        "POKED 9864, PEEKD(VARPTR(b) + OFFSETOF(Box, ""value""))"

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL THIS/ME method parse baseline | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL THIS/ME method exec baseline | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(9860), 111, "THIS bound to receiver in method dispatch")
    ok And= RTAssertEq(VMemPeekD(9864), 222, "ME alias bound to receiver in method dispatch")

    ' Test 2: Inline METHOD body is intentionally fail-fast in baseline
    src = _
        "CLASS InlineBody" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "METHOD GetX() AS I32" & Chr(10) & _
        "RETURN 1" & Chr(10) & _
        "END METHOD" & Chr(10) & _
        "END CLASS"

    If RTParseExpectFail(src, "inline METHOD body is not supported", errText) = 0 Then
        Print "FAIL inline METHOD fail-fast baseline | "; errText
        End 1
    End If

    ' Test 3: THIS/ME outside method context must fail fast at runtime
    src = _
        "POKED THIS, 1" & Chr(10) & _
        "POKED ME, 2"

    If RTExecExpectFail(src, "THIS/ME used outside method context", errText) = 0 Then
        Print "FAIL THIS/ME outside method fail-fast baseline | "; errText
        End 1
    End If

    If ok = 1 Then
        Print "OOP-P0 R3.O1 THIS/ME baseline PASS"
    Else
        Print "OOP-P0 R3.O1 TEST FAIL"
        End 1
    End If

    End 0
End Sub

Main
