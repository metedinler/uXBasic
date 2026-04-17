#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer
    ok = 1

    ExecSetAssertReleaseMode 1
    If ExecGetAssertReleaseMode() <> 1 Then
        Print "FAIL err assert mode set release"
        End 1
    End If

    Dim srcAssertRelease As String
    srcAssertRelease = _
        "x = 7" & Chr(10) & _
        "ASSERT 0, 42" & Chr(10) & _
        "POKED 7103, x"

    If RTParseProgram(srcAssertRelease, ps, errText) = 0 Then
        Print "FAIL err assert release parse | "; errText
        End 1
    End If

    ExecSetAssertReleaseMode 1
    If ExecGetAssertReleaseMode() <> 1 Then
        Print "FAIL err assert mode before release exec"
        End 1
    End If

    If ExecRunMemoryProgram(ps, errText) = 0 Then
        Print "FAIL err assert release exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7103), 7, "ASSERT release mode no-op")
    ExecSetAssertReleaseMode 0

    Dim srcHandled As String
    srcHandled = _
        "x = 0" & Chr(10) & _
        "TRY" & Chr(10) & _
        "x = x + 1" & Chr(10) & _
        "THROW 7" & Chr(10) & _
        "x = 99" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "x = x + 10" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "x = x + 100" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "POKED 7100, x"

    If RTParseProgram(srcHandled, ps, errText) = 0 Then
        Print "FAIL err try parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL err try exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7100), 111, "TRY+CATCH+FINALLY path")

    Dim srcNestedRethrow As String
    srcNestedRethrow = _
        "x = 1" & Chr(10) & _
        "TRY" & Chr(10) & _
        "TRY" & Chr(10) & _
        "THROW 100" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "THROW 200, ""inner-rethrow""" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "x = x + 1000" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "x = x + 10" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "x = x + 100" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "POKED 7102, x"

    If RTParseProgram(srcNestedRethrow, ps, errText) = 0 Then
        Print "FAIL err nested parse | "; errText
        End 1
    End If

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL err nested exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7102), 1111, "nested TRY rethrow unwind")

    Dim srcParseFail As String
    srcParseFail = _
        "TRY" & Chr(10) & _
        "x = 1"

    If RTParseExpectFail(srcParseFail, "missing END TRY", errText) = 0 Then
        Print "FAIL err try parse fail-fast | "; errText
        End 1
    End If

    If RTExecExpectFail("THROW 9", "unhandled THROW", errText) = 0 Then
        Print "FAIL err throw unhandled | "; errText
        End 1
    End If

    If RTExecExpectFail("THROW 42, ""boom"", ""detail-x""", "code=42", errText) = 0 Then
        Print "FAIL err throw code contract | "; errText
        End 1
    End If

    If InStr(UCase(errText), UCase("message=boom")) = 0 Then
        Print "FAIL err throw message contract | "; errText
        End 1
    End If

    If InStr(UCase(errText), UCase("detail=detail-x")) = 0 Then
        Print "FAIL err throw detail contract | "; errText
        End 1
    End If

    ExecSetAssertReleaseMode 0
    If ExecGetAssertReleaseMode() <> 0 Then
        Print "FAIL err assert mode set debug"
        End 1
    End If
    If RTExecExpectFail("ASSERT 0, 42", "ASSERT failed", errText) = 0 Then
        Print "FAIL err assert fail-fast | "; errText
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS err try/throw/assert AST exec"
    End 0
End Sub

Main
