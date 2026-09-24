#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/semantic/semantic_pass.fbs"

Private Function ParseToState(ByRef src As String, ByRef ps As ParseState, ByRef errText As String) As Integer
    Dim lx As LexerState
    LexerInit lx, src
    ParserInit ps, lx
    If ParseProgram(ps) = 0 Then
        errText = ps.lastError
        Return 0
    End If
    Return 1
End Function

Private Sub Main()
    Dim errText As String

    Dim srcOk As String
    srcOk = _
        "CLASS Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB VEC2_MOVE(THIS AS I32)" & Chr(10) & _
        "DIM a AS I32" & Chr(10) & _
        "a = THIS" & Chr(10) & _
        "END SUB"

    Dim psOk As ParseState
    If ParseToState(srcOk, psOk, errText) = 0 Then
        Print "FAIL parse this/me ok-src | "; errText
        End 1
    End If

    If SemanticAnalyze(psOk, errText) = 0 Then
        Print "FAIL semantic this/me ok-src | "; errText
        End 1
    End If

    Dim srcFailThis As String
    srcFailThis = _
        "SUB S()" & Chr(10) & _
        "DIM a AS I32" & Chr(10) & _
        "a = THIS" & Chr(10) & _
        "END SUB"

    Dim psFailThis As ParseState
    If ParseToState(srcFailThis, psFailThis, errText) = 0 Then
        Print "FAIL parse this fail-src | "; errText
        End 1
    End If

    If SemanticAnalyze(psFailThis, errText) <> 0 Then
        Print "FAIL this semantic fail-fast expected"
        End 1
    End If

    If InStr(UCase(errText), "THIS/ME") = 0 Then
        Print "FAIL this semantic fail-fast message | "; errText
        End 1
    End If

    Dim srcFailMe As String
    srcFailMe = _
        "DIM a AS I32" & Chr(10) & _
        "a = ME"

    Dim psFailMe As ParseState
    If ParseToState(srcFailMe, psFailMe, errText) = 0 Then
        Print "FAIL parse me fail-src | "; errText
        End 1
    End If

    If SemanticAnalyze(psFailMe, errText) <> 0 Then
        Print "FAIL me semantic fail-fast expected"
        End 1
    End If

    If InStr(UCase(errText), "THIS/ME") = 0 Then
        Print "FAIL me semantic fail-fast message | "; errText
        End 1
    End If

    Print "PASS this/me semantic pass"
    End 0
End Sub

Main
