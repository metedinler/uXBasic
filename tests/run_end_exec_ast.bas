#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "x = 0" & Chr(10) & _
        "FOR i = 1 TO 5" & Chr(10) & _
        "x = x + 1" & Chr(10) & _
        "IF i = 3 THEN" & Chr(10) & _
        "POKED 7000, i" & Chr(10) & _
        "END" & Chr(10) & _
        "END IF" & Chr(10) & _
        "NEXT i" & Chr(10) & _
        "POKED 7004, 1"

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
    ok And= RTAssertEq(VMemPeekD(7000), 3, "END reached inside FOR/IF")
    ok And= RTAssertEq(VMemPeekD(7004), 0, "END stops remaining top-level statements")

    Dim callSrc As String
    callSrc = _
        "SUB StopNow()" & Chr(10) & _
        "POKED 7012, 1" & Chr(10) & _
        "END" & Chr(10) & _
        "POKED 7016, 1" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "POKED 7008, 1" & Chr(10) & _
        "CALL StopNow()" & Chr(10) & _
        "POKED 7020, 1"

    If RTParseProgram(callSrc, ps, errText) = 0 Then
        Print "FAIL call parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL call exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7008), 1, "END call context executes pre-call statement")
    ok And= RTAssertEq(VMemPeekD(7012), 1, "END call context enters callee")
    ok And= RTAssertEq(VMemPeekD(7016), 0, "END call context skips remaining callee statements")
    ok And= RTAssertEq(VMemPeekD(7020), 0, "END call context stops caller continuation")

    Dim ifBlockSrc As String
    ifBlockSrc = _
        "IF 1 THEN" & Chr(10) & _
        "POKED 7024, 1" & Chr(10) & _
        "END" & Chr(10) & _
        "GOTO Missing" & Chr(10) & _
        "END IF" & Chr(10) & _
        "POKED 7028, 1"

    If RTParseProgram(ifBlockSrc, ps, errText) = 0 Then
        Print "FAIL if-block parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL if-block exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7024), 1, "END in IF keeps earlier side effect")
    ok And= RTAssertEq(VMemPeekD(7028), 0, "END in IF short-circuits later IF-body statements")

    Dim selectBlockSrc As String
    selectBlockSrc = _
        "SELECT CASE 1" & Chr(10) & _
        "CASE 1" & Chr(10) & _
        "POKED 7032, 1" & Chr(10) & _
        "END" & Chr(10) & _
        "GOTO Missing" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "POKED 7036, 1" & Chr(10) & _
        "END SELECT" & Chr(10) & _
        "POKED 7040, 1"

    If RTParseProgram(selectBlockSrc, ps, errText) = 0 Then
        Print "FAIL select-block parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL select-block exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7032), 1, "END in SELECT keeps matched-case side effect")
    ok And= RTAssertEq(VMemPeekD(7036), 0, "END in SELECT skips CASE ELSE branch")
    ok And= RTAssertEq(VMemPeekD(7040), 0, "END in SELECT stops remaining top-level statements")

    If RTParseExpectFail("END 1", "END: unexpected arguments", errText) = 0 Then
        Print "FAIL parse fail-fast END args | "; errText
        End 1
    End If

    If RTParseExpectFail("END IF", "END: unexpected arguments", errText) = 0 Then
        Print "FAIL parse fail-fast END IF outside IF block | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS end AST exec"
    End 0
End Sub

Main
