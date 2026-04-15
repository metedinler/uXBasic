#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "DIM x AS I32" & Chr(10) & _
        "x = 111" & Chr(10) & _
        "POKES 7000, ""AB""" & Chr(10) & _
        "MEMFILLW 7100, 4660, 2" & Chr(10) & _
        "MEMFILLD 7200, 305419896, 1" & Chr(10) & _
        "MEMCOPYW 7100, 7110, 2" & Chr(10) & _
        "MEMCOPYD 7200, 7210, 1" & Chr(10) & _
        "SETNEWOFFSET x, 7300" & Chr(10) & _
        "POKED VARPTR(x), 222" & Chr(10) & _
        "POKED 9480, PEEKD(7300)" & Chr(10) & _
        "POKED 9484, PEEKB(7000)" & Chr(10) & _
        "POKED 9488, PEEKB(7001)" & Chr(10) & _
        "POKED 9492, PEEKW(7110)" & Chr(10) & _
        "POKED 9496, PEEKD(7210)"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL memory-pointer parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL memory-pointer exec | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1
    ok And= RTAssertEq(VMemPeekD(9480), 222, "SETNEWOFFSET + VARPTR write")
    ok And= RTAssertEq(VMemPeekD(9484), 65, "POKES byte[0]")
    ok And= RTAssertEq(VMemPeekD(9488), 66, "POKES byte[1]")
    ok And= RTAssertEq(VMemPeekD(9492), 4660, "MEMCOPYW result")
    ok And= RTAssertEq(VMemPeekD(9496), 305419896, "MEMCOPYD result")

    If RTParseExpectFail("SETNEWOFFSET 1, 200", "first child must be IDENT", errText) = 0 Then
        Print "FAIL setnewoffset parse fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS memory pointer semantics"
    End 0
End Sub

Main