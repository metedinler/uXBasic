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
    
    ' Test 1: Basic CONSTRUCTOR/DESTRUCTOR parsing
    src = _
        "CLASS Vec2" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "y AS I32" & Chr(10) & _
        "CONSTRUCTOR()" & Chr(10) & _
        "DESTRUCTOR()" & Chr(10) & _
        "END CLASS"
    
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse constructor/destructor baseline | "; errText
        End 1
    End If
    
    ' Test 2: CONSTRUCTOR/DESTRUCTOR runtime invocation via naming convention
    src = _
        "CLASS Vec2" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "y AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB VEC2_CTOR(self AS I32)" & Chr(10) & _
        "POKED self + OFFSETOF(Vec2, ""x""), 101" & Chr(10) & _
        "POKED self + OFFSETOF(Vec2, ""y""), 202" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM p AS Vec2" & Chr(10) & _
        "POKED 9700, PEEKD(VARPTR(p) + OFFSETOF(Vec2, ""x""))" & Chr(10) & _
        "POKED 9704, PEEKD(VARPTR(p) + OFFSETOF(Vec2, ""y""))"
    
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse ctor naming convention | "; errText
        End 1
    End If
    
    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec ctor naming convention | "; errText
        End 1
    End If
    
    ok And= RTAssertEq(VMemPeekD(9700), 101, "ctor sets x via naming convention")
    ok And= RTAssertEq(VMemPeekD(9704), 202, "ctor sets y via naming convention")
    
    ' Test 3: CONSTRUCTOR arity fail-fast
    If RTExecExpectFail("CLASS C" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "SUB VEC2_CTOR()" & Chr(10) & "END SUB" & Chr(10) & "DIM p AS C", "arity mismatch VEC2_CTOR", errText) = 0 Then
        Print "FAIL ctor arity fail-fast | "; errText
        End 1
    End If
    
    ' Test 4: CONSTRUCTOR signature fail-fast
    If RTExecExpectFail("CLASS C" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "SUB VEC2_CTOR(self AS F64)" & Chr(10) & "END SUB" & Chr(10) & "DIM p AS C", "signature mismatch", errText) = 0 Then
        Print "FAIL ctor signature fail-fast | "; errText
        End 1
    End If
    
    ' Test 5: DESTRUCTOR arity fail-fast
    If RTExecExpectFail("CLASS C" & Chr(10) & "x AS I32" & Chr(10) & "END CLASS" & Chr(10) & _
        "SUB VEC2_DTOR(self AS I32, extra)" & Chr(10) & "END SUB", "arity" & " " & "mismatch", errText) = 0 Then
        Print "FAIL dtor arity fail-fast | "; errText
        End 1
    End If
    
    If ok = 0 Then End 1
    
    Print "PASS class ctor/dtor exec AST"
End Sub
