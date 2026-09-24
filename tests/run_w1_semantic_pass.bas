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
        ' INPUT target kind bozulsun.
        Dim inNode As Integer
        inNode = FindNodeByKind(ps, "INPUT_STMT")
        If inNode <> -1 Then
            Dim targetNode As Integer
            targetNode = ps.ast.nodes(inNode).firstChild
            If targetNode <> -1 Then ps.ast.nodes(targetNode).kind = "NUMBER"
        End If
    Case 2
        ' SELECT selector eksik gibi davran.
        Dim selNode As Integer
        selNode = FindNodeByKind(ps, "SELECT_STMT")
        If selNode <> -1 Then
            Dim firstCh As Integer
            firstCh = ps.ast.nodes(selNode).firstChild
            If firstCh <> -1 Then
                ps.ast.nodes(selNode).firstChild = ps.ast.nodes(firstCh).nextSibling
            End If
        End If
    Case 3
        ' FUNCTION return type kaybolsun.
        Dim fnNode As Integer
        fnNode = FindNodeByKind(ps, "FUNCTION_STMT")
        If fnNode <> -1 Then
            Dim ch As Integer
            ch = ps.ast.nodes(fnNode).firstChild
            Do While ch <> -1
                If UCase(ps.ast.nodes(ch).kind) = "RETURN_TYPE" Then
                    ps.ast.nodes(ch).kind = "NOP"
                    Exit Do
                End If
                ch = ps.ast.nodes(ch).nextSibling
            Loop
        End If
    Case 4
        ' CONST RHS eksik gibi davran.
        Dim cNode As Integer
        cNode = FindNodeByKind(ps, "CONST_DECL")
        If cNode <> -1 Then ps.ast.nodes(cNode).left = -1
    End Select

    If SemanticAnalyze(ps, errOut) <> 0 Then
        errOut = "semantic fail bekleniyordu"
        Return 0
    End If

    If InStr(UCase(errOut), UCase(expectedText)) = 0 Then
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim srcOk As String
    srcOk = _
        "CONST MAXV = 9" & Chr(10) & _
        "SUB S(a AS I32)" & Chr(10) & _
        "INPUT x" & Chr(10) & _
        "IF x > 0 THEN" & Chr(10) & _
        "SELECT CASE x" & Chr(10) & _
        "CASE 1" & Chr(10) & _
        "PRINT ""one""" & Chr(10) & _
        "CASE ELSE" & Chr(10) & _
        "PRINT ""other""" & Chr(10) & _
        "END SELECT" & Chr(10) & _
        "END IF" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "FUNCTION F(v AS I32) AS I32" & Chr(10) & _
        "F = v + MAXV" & Chr(10) & _
        "END FUNCTION"

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

    If ExpectSemanticFail("INPUT a", "INPUT", 1, errText) = 0 Then
        Print "FAIL semantic INPUT fail-fast | "; errText
        ok = 0
    End If

    If ExpectSemanticFail("SELECT CASE 1" & Chr(10) & "CASE 1" & Chr(10) & "PRINT 1" & Chr(10) & "END SELECT", "SELECT CASE", 2, errText) = 0 Then
        Print "FAIL semantic SELECT fail-fast | "; errText
        ok = 0
    End If

    If ExpectSemanticFail("FUNCTION G() AS I32" & Chr(10) & "G = 1" & Chr(10) & "END FUNCTION", "FUNCTION", 3, errText) = 0 Then
        Print "FAIL semantic FUNCTION fail-fast | "; errText
        ok = 0
    End If

    If ExpectSemanticFail("CONST A = 1", "CONST", 4, errText) = 0 Then
        Print "FAIL semantic CONST fail-fast | "; errText
        ok = 0
    End If

    If ok = 0 Then End 1

    Print "PASS w1 semantic pass"
    End 0
End Sub

Main
