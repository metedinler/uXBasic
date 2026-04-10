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
        "x = LEN(""abc"")" & Chr(10) & _
        "y = ABS(-5)" & Chr(10) & _
        "z = SGN(-7)" & Chr(10) & _
        "u = INT(9)" & Chr(10) & _
        "v = VAL(""42"")" & Chr(10) & _
        "w = ASC(""A"")" & Chr(10) & _
        "p = CINT(7)" & Chr(10) & _
        "q = CLNG(8)" & Chr(10) & _
        "POKED 5000, x" & Chr(10) & _
        "POKED 5004, y" & Chr(10) & _
        "POKED 5008, z" & Chr(10) & _
        "POKED 5012, u" & Chr(10) & _
        "POKED 5016, v" & Chr(10) & _
        "POKED 5020, w" & Chr(10) & _
        "POKED 5024, p" & Chr(10) & _
        "POKED 5028, q"

    Dim errText As String
    If RunProgramExpectOk(srcOk, errText) = 0 Then
        Print "FAIL intrinsic runtime success path | "; errText
        End 1
    End If

    ok And= AssertEq(VMemPeekD(5000), 3, "LEN")
    ok And= AssertEq(VMemPeekD(5004), 5, "ABS")
    ok And= AssertEq(VMemPeekD(5008), &hFFFFFFFF, "SGN")
    ok And= AssertEq(VMemPeekD(5012), 9, "INT")
    ok And= AssertEq(VMemPeekD(5016), 42, "VAL")
    ok And= AssertEq(VMemPeekD(5020), 65, "ASC")
    ok And= AssertEq(VMemPeekD(5024), 7, "CINT")
    ok And= AssertEq(VMemPeekD(5028), 8, "CLNG")

    Dim srcFail As String
    srcFail = "CALL UNKNOWN2(1)"

    Dim failErr As String
    If RunProgramExpectExecFail(srcFail, failErr) = 0 Then
        Print "FAIL intrinsic runtime fail path | "; failErr
        End 1
    End If

    If Instr(UCase(failErr), "UNSUPPORTED CALL UNKNOWN2") = 0 Then
        Print "FAIL intrinsic runtime fail detail | "; failErr
        End 1
    End If

    If ok = 0 Then End 1

    Print "PASS runtime intrinsics"
    End 0
End Sub

Main
