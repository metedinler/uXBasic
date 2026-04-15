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
        "CLASS Player" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "hp AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "SUB PLAYER_PING(self AS I32)" & Chr(10) & _
        "POKED self + OFFSETOF(Player, ""hp""), 77" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "DIM p AS Player" & Chr(10) & _
        "CALL p.PING()"

    Dim ps As ParseState
    Dim errText As String

    If ParseOk(src, ps, errText) = 0 Then
        Print "FAIL class dispatch parse | "; errText
        End 1
    End If

    If HasAstKind(ps, "CLASS_STMT") = 0 Or HasAstKind(ps, "CALL_STMT") = 0 Then
        Print "FAIL class dispatch AST shape"
        End 1
    End If

    Print "PASS class method dispatch AST"
    End 0
End Sub

Main