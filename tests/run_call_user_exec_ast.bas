#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "SUB StoreAt(addr AS I32, v AS I32)" & Chr(10) & _
        "POKED addr, v" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "FUNCTION Add1(x AS I32) AS I32" & Chr(10) & _
        "RETURN x + 1" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION DoubleViaName(v AS I32) AS I32" & Chr(10) & _
        "DoubleViaName = v * 2" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION Nest(v AS I32) AS I32" & Chr(10) & _
        "RETURN Add1(Add1(v))" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION Shadow(x AS I32) AS I32" & Chr(10) & _
        "x = x + 5" & Chr(10) & _
        "RETURN x" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "x = 3" & Chr(10) & _
        "CALL StoreAt(7400, 99)" & Chr(10) & _
        "a = Add1(41)" & Chr(10) & _
        "POKED 7404, a" & Chr(10) & _
        "b = DoubleViaName(6)" & Chr(10) & _
        "POKED 7408, b" & Chr(10) & _
        "c = Nest(5)" & Chr(10) & _
        "POKED 7412, c" & Chr(10) & _
        "d = Shadow(10)" & Chr(10) & _
        "POKED 7416, x" & Chr(10) & _
        "POKED 7420, d" & Chr(10) & _
        "CALL Add1(1)" & Chr(10) & _
        "END"

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
    ok And= RTAssertEq(VMemPeekD(7400), 99, "CALL SUB dispatch")
    ok And= RTAssertEq(VMemPeekD(7404), 42, "FUNCTION RETURN expression")
    ok And= RTAssertEq(VMemPeekD(7408), 12, "FUNCTION name-assignment fallback")
    ok And= RTAssertEq(VMemPeekD(7412), 7, "nested FUNCTION calls")
    ok And= RTAssertEq(VMemPeekD(7416), 3, "activation record isolates shadowed param")
    ok And= RTAssertEq(VMemPeekD(7420), 15, "function-local mutation returns value")

    If RTExecExpectFail("FUNCTION F(a AS I32) AS I32" & Chr(10) & "RETURN a" & Chr(10) & "END FUNCTION" & Chr(10) & "x = F()", "arity mismatch F expected=1 actual=0", errText) = 0 Then
        Print "FAIL user-call arity fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("SUB S(a AS I32)" & Chr(10) & "END SUB" & Chr(10) & "x = S(1)", "requires FUNCTION S", errText) = 0 Then
        Print "FAIL user-call expression requires function | "; errText
        End 1
    End If

    If RTExecExpectFail("CALL UNKNOWN(1)", "unsupported call UNKNOWN", errText) = 0 Then
        Print "FAIL user-call unknown fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("SUB Dup(a AS I32, a AS I32)" & Chr(10) & "END SUB", "duplicate parameter name", errText) = 0 Then
        Print "FAIL parser duplicate SUB parameter fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("FUNCTION MissingRet(x AS I32)" & Chr(10) & "RETURN x" & Chr(10) & "END FUNCTION", "RETURN TYPE", errText) = 0 Then
        Print "FAIL parser FUNCTION return-type fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS call user AST exec"
    End 0
End Sub

Main
