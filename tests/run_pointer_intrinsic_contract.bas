#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim errText As String
    Dim ps As ParseState

    Dim src As String
    src = _
        "a = 11" & Chr(10) & _
        "p1 = VARPTR(a)" & Chr(10) & _
        "p2 = SADD(""abc"")" & Chr(10) & _
        "p3 = LPTR(labelOk)" & Chr(10) & _
        "p4 = CODEPTR(procOk)" & Chr(10) & _
        "DECLARE SUB procOk()" & Chr(10) & _
        "GOTO done" & Chr(10) & _
        "labelOk:" & Chr(10) & _
        "a = 12" & Chr(10) & _
        "done:" & Chr(10) & _
        "POKED 8100, p1" & Chr(10) & _
        "POKED 8104, p2" & Chr(10) & _
        "POKED 8108, p3" & Chr(10) & _
        "POKED 8112, p4"

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse pointer success path | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec pointer success path | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(8100) > 0, -1, "VARPTR returns non-zero address")
    ok And= RTAssertEq((VMemPeekD(8104) And &hF0000000), &h20000000, "SADD pointer tag")
    ok And= RTAssertEq((VMemPeekD(8108) And &hF0000000), &h30000000, "LPTR pointer tag")
    ok And= RTAssertEq((VMemPeekD(8112) And &hF0000000), &h40000000, "CODEPTR pointer tag")

    If RTParseExpectFail("x = VARPTR(1)", "VARPTR expects an identifier argument", errText) = 0 Then
        Print "FAIL parse VARPTR contract | "; errText
        End 1
    End If

    If RTParseExpectFail("x = SADD(1)", "SADD expects a string literal or identifier argument", errText) = 0 Then
        Print "FAIL parse SADD contract | "; errText
        End 1
    End If

    If RTParseExpectFail("x = LPTR(1)", "LPTR expects an identifier argument", errText) = 0 Then
        Print "FAIL parse LPTR contract | "; errText
        End 1
    End If

    If RTParseExpectFail("x = CODEPTR(1)", "CODEPTR expects an identifier argument", errText) = 0 Then
        Print "FAIL parse CODEPTR contract | "; errText
        End 1
    End If

    If RTParseExpectFail("CONST c = 1" & Chr(10) & "x = VARPTR(c)", "VARPTR expects a mutable variable identifier", errText) = 0 Then
        Print "FAIL parse VARPTR mutable contract | "; errText
        End 1
    End If

    If RTParseExpectFail("CALL VARPTR(1)", "VARPTR expects an identifier argument", errText) = 0 Then
        Print "FAIL parse CALL VARPTR contract | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS pointer intrinsic contract"
    End 0
End Sub

Main
