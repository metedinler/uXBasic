#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"

Private Function AssertEq(ByVal actualValue As Integer, ByVal expectedValue As Integer, ByRef msg As String) As Integer
    If actualValue <> expectedValue Then
        Print "FAIL "; msg; " expected="; expectedValue; " actual="; actualValue
        Return 0
    End If
    Return 1
End Function

Private Function RunProgramExpectOk(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = "parse | " & ps.lastError
        Return 0
    End If

    If ExecRunMemoryProgram(ps, errOut) = 0 Then
        errOut = "exec | " & errOut
        Return 0
    End If

    Return 1
End Function

Private Function RunProgramExpectExecFail(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = "parse | " & ps.lastError
        Return 0
    End If

    errOut = ""
    If ExecRunMemoryProgram(ps, errOut) <> 0 Then
        errOut = "expected exec failure"
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim srcOk As String
    srcOk = _
        "x = 4096" & Chr(10) & _
        "POKEB x, 66" & Chr(10) & _
        "a = 1" & Chr(10) & _
        "CALL VARPTR(a)" & Chr(10) & _
        "CALL PEEKB(x)" & Chr(10) & _
        "CALL SADD(""abc"")" & Chr(10) & _
        "CALL LPTR(label1)" & Chr(10) & _
        "CALL CODEPTR(proc1)" & Chr(10) & _
        "b = PEEKB(x)" & Chr(10) & _
        "POKED x + 4, b"

    Dim errText As String
    If RunProgramExpectOk(srcOk, errText) = 0 Then
        Print "FAIL call exec success path | "; errText
        End 1
    End If

    ok And= AssertEq(VMemPeekB(4096), 66, "call success memory byte")
    ok And= AssertEq(VMemPeekD(4100), 66, "call success captured value")

    Dim srcFail As String
    srcFail = "CALL UNKNOWN(1)"

    Dim failErr As String
    If RunProgramExpectExecFail(srcFail, failErr) = 0 Then
        Print "FAIL call exec fail path | "; failErr
        End 1
    End If

    If Instr(UCase(failErr), "UNSUPPORTED CALL UNKNOWN") = 0 Then
        Print "FAIL call exec fail path detail | "; failErr
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS call exec"
    End 0
End Sub

Main
