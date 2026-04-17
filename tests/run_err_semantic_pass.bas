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

Private Function FindNodeByKind(ByRef ps As ParseState, ByRef kindText As String) As Integer
    Dim i As Integer
    Dim target As String
    target = UCase(Trim(kindText))

    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = target Then Return i
    Next i

    Return -1
End Function

Private Function ExpectSemanticFail(ByRef src As String, ByRef expectedText As String, ByVal mutateCase As Integer, ByRef errOut As String) As Integer
    Dim ps As ParseState
    If ParseToState(src, ps, errOut) = 0 Then Return 0

    Select Case mutateCase
    Case 1
        ' TRY body yokmus gibi: body stmt'yi CATCH_PART yap.
        Dim tryNode As Integer
        tryNode = FindNodeByKind(ps, "TRY_STMT")
        If tryNode <> -1 Then
            Dim ch As Integer
            ch = ps.ast.nodes(tryNode).firstChild
            Do While ch <> -1
                Dim ck As String
                ck = UCase(ps.ast.nodes(ch).kind)
                If ck <> "CATCH_PART" And ck <> "FINALLY_PART" Then
                    ps.ast.nodes(ch).kind = "CATCH_PART"
                    Exit Do
                End If
                ch = ps.ast.nodes(ch).nextSibling
            Loop
        End If

    Case 2
        ' TRY icinde ikinci CATCH olustur: FINALLY'yi CATCH_PART yap.
        Dim tryNode2 As Integer
        tryNode2 = FindNodeByKind(ps, "TRY_STMT")
        If tryNode2 <> -1 Then
            Dim ch2 As Integer
            ch2 = ps.ast.nodes(tryNode2).firstChild
            Do While ch2 <> -1
                If UCase(ps.ast.nodes(ch2).kind) = "FINALLY_PART" Then
                    ps.ast.nodes(ch2).kind = "CATCH_PART"
                    Exit Do
                End If
                ch2 = ps.ast.nodes(ch2).nextSibling
            Loop
        End If

    Case 3
        ' ASSERT kosulu eksikmis gibi.
        Dim assertNode As Integer
        assertNode = FindNodeByKind(ps, "ASSERT_STMT")
        If assertNode <> -1 Then ps.ast.nodes(assertNode).firstChild = -1
    End Select

    If SemanticAnalyze(ps, errOut) <> 0 Then
        errOut = "semantic fail bekleniyordu"
        Return 0
    End If

    If InStr(UCase(errOut), UCase(expectedText)) = 0 Then Return 0
    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim srcOk As String
    srcOk = _
        "x = 0" & Chr(10) & _
        "TRY" & Chr(10) & _
        "x = x + 1" & Chr(10) & _
        "THROW 7" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "x = x + 2" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "ASSERT x > 0" & Chr(10) & _
        "END TRY"

    Dim psOk As ParseState
    Dim errText As String
    If ParseToState(srcOk, psOk, errText) = 0 Then
        Print "FAIL parse ok-src | "; errText
        End 1
    End If

    If SemanticAnalyze(psOk, errText) = 0 Then
        Print "FAIL semantic ok-src | "; errText
        End 1
    End If

    If ExpectSemanticFail(srcOk, "TRY govde ifadeleri CATCH/FINALLY oncesinde olmali", 1, errText) = 0 Then
        Print "FAIL semantic TRY body fail-fast | "; errText
        ok = 0
    End If

    If ExpectSemanticFail(srcOk, "birden fazla CATCH", 2, errText) = 0 Then
        Print "FAIL semantic TRY catch count fail-fast | "; errText
        ok = 0
    End If

    If ExpectSemanticFail("ASSERT 1", "ASSERT arguman sayisi gecersiz", 3, errText) = 0 Then
        Print "FAIL semantic ASSERT condition fail-fast | "; errText
        ok = 0
    End If

    If ExpectSemanticFail("THROW 1, 2, 3, 4", "THROW en fazla uc ifade alir", 0, errText) = 0 Then
        Print "FAIL semantic THROW arity fail-fast | "; errText
        ok = 0
    End If

    If ok = 0 Then End 1

    Print "PASS err semantic pass"
    End 0
End Sub

Main
