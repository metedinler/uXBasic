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

Private Function ParseFailContains(ByRef src As String, ByRef errNeedle As String, ByRef errOut As String) As Integer
    Dim lx As LexerState
    LexerInit lx, src

    Dim ps As ParseState
    ParserInit ps, lx

    If ParseProgram(ps) <> 0 Then
        errOut = "expected parse failure"
        Return 0
    End If

    errOut = ps.lastError
    If Instr(UCase(errOut), UCase(errNeedle)) = 0 Then
        errOut = "unexpected parse error: " & errOut
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim errText As String

    Dim srcOk As String
    srcOk = _
        "NAMESPACE Core" & Chr(10) & _
        "CLASS Secret" & Chr(10) & _
        "RESTRICTED:" & Chr(10) & _
        "token AS I32" & Chr(10) & _
        "FRIEND Core.Auth, Core.Audit" & Chr(10) & _
        "PRIVATE" & Chr(10) & _
        "pin AS I32" & Chr(10) & _
        "FRIEND Core.Auth" & Chr(10) & _
        "PUBLIC:" & Chr(10) & _
        "id AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "END NAMESPACE"

    Dim ps As ParseState
    If ParseOk(srcOk, ps, errText) = 0 Then
        Print "FAIL parse positive | "; errText
        End 1
    End If

    If HasAstKind(ps, "CLASS_STMT") = 0 Then
        Print "FAIL missing CLASS_STMT"
        End 1
    End If

    If HasAstKind(ps, "CLASS_ACCESS") = 0 Then
        Print "FAIL missing CLASS_ACCESS"
        End 1
    End If

    If HasAstKind(ps, "CLASS_FRIEND_STMT") = 0 Or HasAstKind(ps, "FRIEND_ITEM") = 0 Then
        Print "FAIL missing FRIEND nodes"
        End 1
    End If

    Dim srcPublicFriend As String
    srcPublicFriend = _
        "CLASS C" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "FRIEND Core.Auth" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS"

    If ParseFailContains(srcPublicFriend, "PUBLIC access cannot declare friend", errText) = 0 Then
        Print "FAIL public-friend check | "; errText
        End 1
    End If

    Dim srcCrossNamespaceFriend As String
    srcCrossNamespaceFriend = _
        "NAMESPACE Core" & Chr(10) & _
        "CLASS C" & Chr(10) & _
        "RESTRICTED" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "FRIEND Other.Auth" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "END NAMESPACE"

    If ParseFailContains(srcCrossNamespaceFriend, "target must stay in same namespace", errText) = 0 Then
        Print "FAIL cross-namespace-friend check | "; errText
        End 1
    End If

    Dim srcFriendNoTarget As String
    srcFriendNoTarget = _
        "CLASS C" & Chr(10) & _
        "PRIVATE" & Chr(10) & _
        "FRIEND" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END CLASS"

    If ParseFailContains(srcFriendNoTarget, "qualified module name expected", errText) = 0 Then
        Print "FAIL friend-no-target check | "; errText
        End 1
    End If

    Print "PASS class access/friend parse"
    End 0
End Sub

Main
