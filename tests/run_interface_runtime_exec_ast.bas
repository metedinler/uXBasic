#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "INTERFACE IAnimal" & Chr(10) & _
        "METHOD Speak()" & Chr(10) & _
        "END INTERFACE" & Chr(10) & _
        "CLASS Dog IMPLEMENTS IAnimal" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB DOG_SPEAK(self AS I32)" & Chr(10) & _
        "POKED 9872, 123" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM d AS Dog" & Chr(10) & _
        "CALL d.SPEAK()"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL interface runtime parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL interface runtime exec | "; errText
        End 1
    End If

    If RTAssertEq(VMemPeekD(9872), 123, "interface runtime dispatch") = 0 Then End 1

    Print "PASS interface runtime exec AST"
    End 0
End Sub

Main
