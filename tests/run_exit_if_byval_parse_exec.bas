#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function CountParamMode(ByRef ps As ParseState, ByRef modeText As String) As Integer
    Dim i As Integer
    Dim c As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "PARAM_DECL" Then
            If UCase(ps.ast.nodes(i).op) = UCase(modeText) Then c += 1
        End If
    Next i
    Return c
End Function

Private Sub Main()
    Dim errText As String

    Dim src As String
    src = _
        "x = 0" & Chr(10) & _
        "IF 1 THEN" & Chr(10) & _
        "x = 1" & Chr(10) & _
        "EXIT IF" & Chr(10) & _
        "x = 2" & Chr(10) & _
        "END IF" & Chr(10) & _
        "POKED 7700, x"

    Dim ps As ParseState
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse EXIT IF | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec EXIT IF | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(7700), 1, "EXIT IF exits current IF block")

    If RTExecExpectFail("EXIT IF", "EXIT IF used outside IF block", errText) = 0 Then
        Print "FAIL EXIT IF out-of-scope fail-fast | "; errText
        End 1
    End If

    If RTParseExpectFail("EXIT NOW", "EXIT: expected FOR, DO, IF", errText) = 0 Then
        Print "FAIL EXIT parser mode fail-fast | "; errText
        End 1
    End If

    Dim sigSrc As String
    sigSrc = "x = CALL(DLL, " & Chr(34) & "kernel32.dll" & Chr(34) & ", " & Chr(34) & "Sleep" & Chr(34) & ", BYVAL, 1)"
    If RTParseProgram(sigSrc, ps, errText) = 0 Then
        Print "FAIL CALL(DLL) BYVAL parse | "; errText
        End 1
    End If

    Dim declSrc As String
    declSrc = "DECLARE FUNCTION F(BYVAL x AS I32, BYREF y AS I32) AS I32"
    If RTParseProgram(declSrc, ps, errText) = 0 Then
        Print "FAIL BYVAL/BYREF param parse | "; errText
        End 1
    End If

    ok And= RTAssertEq(CountParamMode(ps, "BYVAL"), 1, "BYVAL parameter mode captured")
    ok And= RTAssertEq(CountParamMode(ps, "BYREF"), 1, "BYREF parameter mode captured")

    If ok = 0 Then End 1

    Print "PASS exit-if/byval parse-exec"
    End 0
End Sub

Main