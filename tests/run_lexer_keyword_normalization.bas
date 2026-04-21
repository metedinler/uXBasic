#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"

Private Function AssertToken(ByRef st As LexerState, ByVal idx As Integer, ByRef kindText As String, ByRef lexemeText As String, ByRef errOut As String) As Integer
    If idx < 0 Or idx >= st.tokens.count Then
        errOut = "token index out of range"
        Return 0
    End If

    Dim tk As Token
    tk = st.tokens.items(idx)

    If UCase(tk.kind) <> UCase(kindText) Then
        errOut = "kind mismatch at token " & LTrim(Str(idx)) & ": got=" & tk.kind & " expected=" & kindText
        Return 0
    End If

    If tk.lexeme <> lexemeText Then
        errOut = "lexeme mismatch at token " & LTrim(Str(idx)) & ": got=" & tk.lexeme & " expected=" & lexemeText
        Return 0
    End If

    Return 1
End Function

Private Function ParseExpectOk(ByRef src As String, ByRef errOut As String) As Integer
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

Private Sub Main()
    Dim errText As String

    Dim src1 As String
    src1 = "iF Foo tHeN" & Chr(10)

    Dim lx1 As LexerState
    LexerInit lx1, src1

    If AssertToken(lx1, 0, "KEYWORD", "IF", errText) = 0 Then
        Print "FAIL mixed-case keyword IF | "; errText
        End 1
    End If

    If AssertToken(lx1, 1, "IDENT", "foo", errText) = 0 Then
        Print "FAIL ident canonical lower | "; errText
        End 1
    End If

    If AssertToken(lx1, 2, "KEYWORD", "THEN", errText) = 0 Then
        Print "FAIL mixed-case keyword THEN | "; errText
        End 1
    End If

    Dim src2 As String
    src2 = "Alpha BETA_2 pRiNt printX" & Chr(10)

    Dim lx2 As LexerState
    LexerInit lx2, src2

    If AssertToken(lx2, 0, "IDENT", "alpha", errText) = 0 Then
        Print "FAIL ident alpha canonical lower | "; errText
        End 1
    End If

    If AssertToken(lx2, 1, "IDENT", "beta_2", errText) = 0 Then
        Print "FAIL ident beta_2 canonical lower | "; errText
        End 1
    End If

    If AssertToken(lx2, 2, "KEYWORD", "PRINT", errText) = 0 Then
        Print "FAIL PRINT keyword classification | "; errText
        End 1
    End If

    If AssertToken(lx2, 3, "IDENT", "printx", errText) = 0 Then
        Print "FAIL printx identifier classification | "; errText
        End 1
    End If

    Dim src3 As String
    src3 = "obj.then()" & Chr(10)

    If ParseExpectOk(src3, errText) = 0 Then
        Print "FAIL dotted keyword-like method parse | "; errText
        End 1
    End If

    Print "OK lexer keyword normalization"
End Sub

Main
