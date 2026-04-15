#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"

Private Function ParseOk(ByRef src As String, ByRef errOut As String) As Integer
    Dim lx As LexerState
    LexerInit lx, src

    Dim ps As ParseState
    ParserInit ps, lx
    If ParseProgram(ps) = 0 Then
        errOut = ps.lastError
        Return 0
    End If

    Return 1
End Function

Private Function ParseFailContains(ByRef src As String, ByRef expectedPart As String, ByRef errOut As String) As Integer
    Dim lx As LexerState
    LexerInit lx, src

    Dim ps As ParseState
    ParserInit ps, lx
    If ParseProgram(ps) <> 0 Then
        errOut = "expected parse failure"
        Return 0
    End If

    errOut = ps.lastError
    If Instr(UCase(errOut), UCase(expectedPart)) = 0 Then
        errOut = "unexpected parse error: " & errOut
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim errText As String

    Dim srcOk As String
    srcOk = _
        "CLASS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "id AS I32" & Chr(10) & _
        "END CLASS"

    If ParseOk(srcOk, errText) = 0 Then
        Print "FAIL oop transition parse | "; errText
        End 1
    End If

    Dim srcFail As String
    srcFail = _
        "CLASS C" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "FRIEND Core.Auth" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS"

    If ParseFailContains(srcFail, "PUBLIC access cannot declare friend", errText) = 0 Then
        Print "FAIL oop transition fail-fast | "; errText
        End 1
    End If

    Print "PASS class oop transition AST"
    End 0
End Sub

Main
