#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"

Private Function AssertTrue(ByVal condValue As Integer, ByRef msg As String) As Integer
    If condValue = 0 Then
        Print "FAIL "; msg
        Return 0
    End If
    Return 1
End Function

Private Function AssertTok(ByRef lx As LexerState, ByVal idx As Integer, ByRef kindText As String, ByRef lexemeText As String, ByRef msg As String) As Integer
    Dim tk As Token
    tk = TokenListAt(lx.tokens, idx)

    If UCase(tk.kind) <> UCase(kindText) Then
        msg = "kind mismatch at " & LTrim(Str(idx)) & " got=" & tk.kind & " expected=" & kindText
        Return 0
    End If

    If tk.lexeme <> lexemeText Then
        msg = "lexeme mismatch at " & LTrim(Str(idx)) & " got=" & tk.lexeme & " expected=" & lexemeText
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1
    Dim msg As String

    Dim src1 As String
    src1 = "a = 1 _" & Chr(10) & " + 2" & Chr(10)

    Dim lx1 As LexerState
    LexerInit lx1, src1

    ok And= AssertTok(lx1, 0, "IDENT", "a", msg)
    ok And= AssertTok(lx1, 1, "OP", "=", msg)
    ok And= AssertTok(lx1, 2, "NUMBER", "1", msg)
    ok And= AssertTok(lx1, 3, "OP", "+", msg)
    ok And= AssertTok(lx1, 4, "NUMBER", "2", msg)
    ok And= AssertTok(lx1, 5, "EOL", "", msg)
    ok And= AssertTok(lx1, 6, "EOF", "", msg)

    Dim src2 As String
    src2 = "b = 3 _ ' line-continue comment" & Chr(10) & " + 4" & Chr(10)

    Dim lx2 As LexerState
    LexerInit lx2, src2

    ok And= AssertTok(lx2, 0, "IDENT", "b", msg)
    ok And= AssertTok(lx2, 1, "OP", "=", msg)
    ok And= AssertTok(lx2, 2, "NUMBER", "3", msg)
    ok And= AssertTok(lx2, 3, "OP", "+", msg)
    ok And= AssertTok(lx2, 4, "NUMBER", "4", msg)

    Dim src3 As String
    src3 = "x=1" & Chr(13) & Chr(10) & "y=2" & Chr(13) & Chr(10)

    Dim lx3 As LexerState
    LexerInit lx3, src3

    ok And= AssertTrue(lx3.tokens.count >= 7, "CRLF token count expected")

    Dim eofTok As Token
    eofTok = TokenListAt(lx3.tokens, lx3.tokens.count + 999)
    ok And= AssertTrue(UCase(eofTok.kind) = "EOF", "out-of-range token must be EOF")

    If ok = 0 Then
        Print "DETAIL "; msg
        End 1
    End If

    Print "PASS lexer stabilization"
    End 0
End Sub

Main
