%%INCLUDE "../../src/parser/token_kinds.fbs"
%%INCLUDE "../../src/parser/lexer.fbs"
%%INCLUDE "../../src/parser/parser.fbs"
%%INCLUDE "../../src/runtime/memory_vm.fbs"
%%INCLUDE "../../src/runtime/memory_exec.fbs"
%%INCLUDE "../helpers/runtime_test_common.fbs"

' Test 80: Operator numeric parity (int, F32, F64)
' Ensures simple arithmetic and mixed-type ops parse/run across backends.

Private Sub Main()
    Dim src As String
    src = _
        "Dim i As Integer" & Chr(10) & _
        "Dim f32 As F32" & Chr(10) & _
        "Dim f64 As F64" & Chr(10) & _
        "i = 3" & Chr(10) & _
        "f32 = 1.5" & Chr(10) & _
        "f64 = 2.25" & Chr(10) & _
        "i = i + 2" & Chr(10) & _
        "f32 = f32 * 2" & Chr(10) & _
        "f64 = f64 + 0.75" & Chr(10) & _
        "PRINT i, f32, f64"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL 80 parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL 80 exec | "; errText
        End 1
    End If

    Print "DONE_80_AST"
    End 0
End Sub

Main
