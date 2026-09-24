#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "DEFINT A-Z" & Chr(10) & _
        "SETSTRINGSIZE 64" & Chr(10) & _
        "POKED 9440, 1"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL deftype/setstringsize parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL deftype/setstringsize exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9440), 1, "deftype/setstringsize program flow")
    ok And= RTAssertEq(ExecDebugGetStringSize(), 64, "SETSTRINGSIZE applied")

    If RTExecExpectFail("SETSTRINGSIZE -1", "Boyut pozitif", errText) = 0 Then
        Print "FAIL setstringsize negative fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS deftype/setstringsize exec"
    End 0
End Sub

Main
