#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "DIM a8 AS I8 = 1" & Chr(10) & _
        "DIM b8 AS U8 = 2" & Chr(10) & _
        "DIM a16 AS I16 = 3" & Chr(10) & _
        "DIM a32 AS I32 = 4" & Chr(10) & _
        "DIM a64 AS I64 = 5" & Chr(10) & _
        "DIM f AS F64 = 2.5" & Chr(10) & _
        "DIM ok AS BOOLEAN = 0" & Chr(10) & _
        "DIM s AS STRING = ""ab""" & Chr(10) & _
        "DIM arr(0 TO 2) AS I32" & Chr(10) & _
        "REDIM PRESERVE arr(0 TO 4) AS I32" & Chr(10) & _
        "x = a8 + b8 + a16 + a32 + a64" & Chr(10) & _
        "ok = (x > 0)" & Chr(10) & _
        "y = LEN(s) + ASC(""A"")" & Chr(10) & _
        "z = CINT(f * 2)" & Chr(10) & _
        "POKED 9840, x" & Chr(10) & _
        "POKED 9844, ok" & Chr(10) & _
        "POKED 9848, y" & Chr(10) & _
        "POKED 9852, z"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL core types parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL core types exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9840), 15, "integer type family arithmetic")
    ok And= RTAssertEq(IIf(VMemPeekD(9844) <> 0, 1, 0), 1, "boolean comparison result")
    ok And= RTAssertEq(VMemPeekD(9848), 66, "string intrinsic composition")
    ok And= RTAssertEq(VMemPeekD(9852), 4, "float expression coercion")

    If ok = 0 Then End 1

    Print "PASS core types exec AST"
    End 0
End Sub

Main
