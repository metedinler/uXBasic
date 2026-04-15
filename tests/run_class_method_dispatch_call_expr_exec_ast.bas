#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"

Private Function HasAstKind(ByRef ps As ParseState, ByRef kindName As String) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = UCase(kindName) Then Return 1
    Next i
    Return 0
End Function

Private Function HasCallExprValue(ByRef ps As ParseState, ByRef callName As String) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "CALL_EXPR" Then
            If UCase(Trim(ps.ast.nodes(i).value)) = UCase(callName) Then Return 1
        End If
    Next i
    Return 0
End Function

Private Function ParseOk(ByRef src As String, ByRef psOut As ParseState, ByRef errOut As String) As Integer
    Dim lx As LexerState
    LexerInit lx, src

    ParserInit psOut, lx
    If ParseProgram(psOut) = 0 Then
        errOut = psOut.lastError
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim src As String
    src = _
        "CLASS Meter" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "value AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "FUNCTION METER_GET(self AS I32) AS I32" & Chr(10) & _
        "RETURN 12" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "DIM m AS Meter" & Chr(10) & _
        "CALL m.GET()" & Chr(10) & _
        "y = METER_GET(VARPTR(m))"

    Dim ps As ParseState
    Dim errText As String

    If ParseOk(src, ps, errText) = 0 Then
        Print "FAIL class call_expr parse | "; errText
        End 1
    End If

    If HasAstKind(ps, "CALL_STMT") = 0 Then
        Print "FAIL missing dotted CALL_STMT"
        End 1
    End If

    If HasCallExprValue(ps, "METER_GET") = 0 Then
        Print "FAIL missing direct CALL_EXPR name"
        End 1
    End If

    Print "PASS class method dispatch CALL_EXPR AST"
    End 0
End Sub

Main
