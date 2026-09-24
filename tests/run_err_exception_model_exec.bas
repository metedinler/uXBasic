#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    src = _
        "TRY" & Chr(10) & _
        "THROW 404" & Chr(10) & _
        "CATCH err" & Chr(10) & _
        "POKED 8200, err" & Chr(10) & _
        "POKED 8204, __ERR_CODE" & Chr(10) & _
        "POKED 8208, __ERR_VALUE" & Chr(10) & _
        "POKED 8212, __ERR_IS_STRING" & Chr(10) & _
        "POKED 8216, LEN(__ERR_KIND)" & Chr(10) & _
        "POKED 8220, LEN(__ERR_MESSAGE)" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "TRY" & Chr(10) & _
        "THROW ""boom""" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "POKED 8224, __ERR_CODE" & Chr(10) & _
        "POKED 8228, __ERR_IS_STRING" & Chr(10) & _
        "POKED 8232, LEN(__ERR_VALUE_TEXT)" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "TRY" & Chr(10) & _
        "ASSERT 0, ""must fail""" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "POKED 8236, __ERR_CODE" & Chr(10) & _
        "POKED 8240, LEN(__ERR_MESSAGE)" & Chr(10) & _
        "END TRY"

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

    ok And= RTAssertEq(VMemPeekD(8200), 1, "catch variable compatibility")
    ok And= RTAssertEq(VMemPeekD(8204), 404, "throw integer code")
    ok And= RTAssertEq(VMemPeekD(8208), 404, "throw integer payload")
    ok And= RTAssertEq(VMemPeekD(8212), 0, "integer throw is not string")
    ok And= RTAssertEq(VMemPeekD(8224), 1001, "string throw default code")
    ok And= RTAssertEq(VMemPeekD(8228), 1, "string throw marker")
    ok And= RTAssertEq(VMemPeekD(8236), 1002, "assert exception code")

    If VMemPeekD(8216) <= 0 Then
        Print "FAIL __ERR_KIND should be non-empty"
        ok = 0
    End If

    If VMemPeekD(8220) <= 0 Then
        Print "FAIL __ERR_MESSAGE should be non-empty for THROW"
        ok = 0
    End If

    If VMemPeekD(8232) <= 0 Then
        Print "FAIL __ERR_VALUE_TEXT should be non-empty for string THROW"
        ok = 0
    End If

    If VMemPeekD(8240) <= 0 Then
        Print "FAIL __ERR_MESSAGE should be non-empty for ASSERT"
        ok = 0
    End If

    If RTExecExpectFail("THROW 12", "THROW 12", errText) = 0 Then
        Print "FAIL uncaught THROW rich message | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS err exception model exec"
    End 0
End Sub

Main
