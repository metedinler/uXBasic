#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/semantic/semantic_pass.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function RTSemanticExpectFail(ByRef src As String, ByRef expectedPart As String, ByRef errOut As String) As Integer
    Dim ps As ParseState
    If RTParseProgram(src, ps, errOut) = 0 Then Return 0

    Dim semErr As String
    If SemanticAnalyze(ps, semErr) <> 0 Then
        errOut = "expected semantic failure"
        Return 0
    End If

    errOut = semErr
    If InStr(UCase(errOut), UCase(expectedPart)) = 0 Then
        errOut = "unexpected semantic error text: " & errOut
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim src As String
    Dim ps As ParseState
    Dim errText As String
    Dim semErr As String
    Dim ok As Integer
    ok = 1

    src = _
        "CLASS Vec2" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "y AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB VEC2_CTOR(self AS I32, vx AS I32, vy AS I32)" & Chr(10) & _
        "POKED self + OFFSETOF(Vec2, ""x""), vx" & Chr(10) & _
        "POKED self + OFFSETOF(Vec2, ""y""), vy" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM p AS I32" & Chr(10) & _
        "p = NEW Vec2(41, 82)" & Chr(10) & _
        "POKED 9800, PEEKD(p + OFFSETOF(Vec2, ""x""))" & Chr(10) & _
        "POKED 9804, PEEKD(p + OFFSETOF(Vec2, ""y""))"

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse NEW baseline | "; errText
        End 1
    End If

    If SemanticAnalyze(ps, semErr) = 0 Then
        Print "FAIL semantic NEW baseline | "; semErr
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec NEW baseline | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(9800), 41, "NEW alloc + ctor writes x")
    ok And= RTAssertEq(VMemPeekD(9804), 82, "NEW alloc + ctor writes y")

    src = _
        "CLASS C" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB C_CTOR(self AS I32, v AS I32)" & Chr(10) & _
        "POKED self + OFFSETOF(C, ""x""), v" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM p AS C = NEW C(77)" & Chr(10) & _
        "POKED 9810, PEEKD(VARPTR(p) + OFFSETOF(C, ""x""))"

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse DIM class = NEW baseline | "; errText
        End 1
    End If

    If SemanticAnalyze(ps, semErr) = 0 Then
        Print "FAIL semantic DIM class = NEW baseline | "; semErr
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec DIM class = NEW baseline | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(9810), 77, "DIM class initializer NEW forwards ctor arg")

    src = _
        "CLASS C2" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB C2_CTOR(self AS I32, v AS I32)" & Chr(10) & _
        "POKED self + OFFSETOF(C2, ""x""), v" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM p AS C2" & Chr(10) & _
        "p = NEW C2(155)" & Chr(10) & _
        "POKED 9814, PEEKD(VARPTR(p) + OFFSETOF(C2, ""x""))"

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse class rebinding assignment | "; errText
        End 1
    End If

    If SemanticAnalyze(ps, semErr) = 0 Then
        Print "FAIL semantic class rebinding assignment | "; semErr
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec class rebinding assignment | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(9814), 155, "class var assignment rebinds address to NEW object")

    src = _
        "CLASS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "bx AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "CLASS Derived EXTENDS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "dy AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB DERIVED_CTOR(self AS I32, v1 AS I32, v2 AS I32)" & Chr(10) & _
        "POKED self + OFFSETOF(Base, ""bx""), v1" & Chr(10) & _
        "POKED self + OFFSETOF(Derived, ""dy""), v2" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "SUB DERIVED_DTOR(self AS I32)" & Chr(10) & _
        "POKED 9832, PEEKD(9832) + 1" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM b AS Base = NEW Derived(9, 10)" & Chr(10) & _
        "DIM o AS OBJECT = NEW Derived(30, 40)" & Chr(10) & _
        "POKED 9820, PEEKD(VARPTR(b) + OFFSETOF(Base, ""bx""))" & Chr(10) & _
        "POKED 9822, PEEKD(VARPTR(b) + OFFSETOF(Derived, ""dy""))" & Chr(10) & _
        "POKED 9824, PEEKD(o + OFFSETOF(Base, ""bx""))" & Chr(10) & _
        "DELETE o" & Chr(10) & _
        "DELETE b" & Chr(10) & _
        "POKED 9828, o" & Chr(10) & _
        "POKED 9830, b"

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse inheritance/object/delete flow | "; errText
        End 1
    End If

    If SemanticAnalyze(ps, semErr) = 0 Then
        Print "FAIL semantic inheritance/object/delete flow | "; semErr
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec inheritance/object/delete flow | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(9820), 9, "Base <- Derived initializer keeps base field")
    ok And= RTAssertEq(VMemPeekD(9822), 10, "Base <- Derived initializer keeps derived field")
    ok And= RTAssertEq(VMemPeekD(9824), 30, "OBJECT <- Derived initializer stores dynamic object")
    ok And= RTAssertEq(VMemPeekD(9828), 0, "DELETE OBJECT clears pointer")
    ok And= RTAssertEq(VMemPeekD(9830), 0, "DELETE Base clears pointer")
    ok And= RTAssertEq(VMemPeekD(9832), 2, "DELETE invokes dynamic destructor")

    If RTSemanticExpectFail("DIM p AS I32" & Chr(10) & "p = NEW UnknownType", "NEW target class not found", errText) = 0 Then
        Print "FAIL NEW unknown class semantic gate | "; errText
        End 1
    End If

    If RTSemanticExpectFail("CLASS C" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "CLASS D" & Chr(10) & "y AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "DIM p AS C = NEW D", "initializer type mismatch", errText) = 0 Then
        Print "FAIL DIM class initializer type mismatch semantic gate | "; errText
        End 1
    End If

    If RTSemanticExpectFail("CLASS Base" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "CLASS Other" & Chr(10) & "y AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "DIM p AS Base" & Chr(10) & "p = NEW Other", "class assignment type mismatch", errText) = 0 Then
        Print "FAIL class assignment mismatch semantic gate | "; errText
        End 1
    End If

    If RTSemanticExpectFail("DIM a AS I32" & Chr(10) & "DELETE a", "DELETE target must be class or OBJECT", errText) = 0 Then
        Print "FAIL DELETE non-class semantic gate | "; errText
        End 1
    End If

    If RTSemanticExpectFail("CLASS C" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "DIM p AS C = 1", "initializer must be NEW", errText) = 0 Then
        Print "FAIL DIM class initializer NEW-only semantic gate | "; errText
        End 1
    End If

    If RTExecExpectFail("CLASS C" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "SUB C_CTOR(self AS I32)" & Chr(10) & "END SUB" & Chr(10) & _
        "DIM p AS I32" & Chr(10) & "p = NEW C(1)", "arity mismatch C_CTOR", errText) = 0 Then
        Print "FAIL NEW ctor arity runtime gate | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS class NEW expr exec AST"
End Sub
