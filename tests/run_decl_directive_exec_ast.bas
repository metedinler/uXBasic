#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "INCLUDE ""dummy.bas""" & Chr(10) & _
        "IMPORT(C, ""native.c"")" & Chr(10) & _
        "INLINE(""asm"", ""blk"", ""proc"", """")" & Chr(10) & _
        "END INLINE" & Chr(10) & _
        "POKED 9430, 1"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL decl directive parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL decl directive exec | "; errText
        End 1
    End If

    If RTAssertEq(VMemPeekD(9430), 1, "directive statements keep runtime flow") = 0 Then End 1

    Print "PASS decl directive exec AST"
    End 0
End Sub

Main
