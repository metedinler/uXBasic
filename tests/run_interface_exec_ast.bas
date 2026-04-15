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
    Dim srcOk As String
    srcOk = _
        "INTERFACE IAnimal" & Chr(10) & _
        "METHOD Speak()" & Chr(10) & _
        "END INTERFACE" & Chr(10) & _
        "CLASS Dog IMPLEMENTS IAnimal" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB DOG_SPEAK(self AS I32)" & Chr(10) & _
        "END SUB"

    Dim ps As ParseState
    Dim errText As String

    If ParseToState(srcOk, ps, errText) = 0 Then
        Print "FAIL interface parse ok-src | "; errText
        End 1
    End If

    If SemanticAnalyze(ps, errText) = 0 Then
        Print "FAIL interface semantic ok-src | "; errText
        End 1
    End If

    Dim srcFailMissing As String
    srcFailMissing = _
        "INTERFACE IAnimal" & Chr(10) & _
        "METHOD Speak()" & Chr(10) & _
        "END INTERFACE" & Chr(10) & _
        "CLASS Cat IMPLEMENTS IAnimal" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS"

    Dim psFailMissing As ParseState
    If ParseToState(srcFailMissing, psFailMissing, errText) = 0 Then
        Print "FAIL interface parse missing-src | "; errText
        End 1
    End If

    If SemanticAnalyze(psFailMissing, errText) <> 0 Then
        Print "FAIL interface semantic fail-fast expected"
        End 1
    End If

    If InStr(UCase(errText), "INTERFACE METHOD NOT IMPLEMENTED") = 0 Then
        Print "FAIL interface semantic fail-fast message | "; errText
        End 1
    End If

    Dim srcFailUnknown As String
    srcFailUnknown = _
        "CLASS Bird IMPLEMENTS IUnknown" & Chr(10) & _
        "END CLASS"

    Dim psFailUnknown As ParseState
    If ParseToState(srcFailUnknown, psFailUnknown, errText) = 0 Then
        Print "FAIL interface parse unknown-src | "; errText
        End 1
    End If

    If SemanticAnalyze(psFailUnknown, errText) <> 0 Then
        Print "FAIL unknown interface fail-fast expected"
        End 1
    End If

    If InStr(UCase(errText), "IMPLEMENTS UNKNOWN INTERFACE") = 0 Then
        Print "FAIL unknown interface fail-fast message | "; errText
        End 1
    End If

    Print "PASS interface semantic AST"
    End 0
End Sub

Main
