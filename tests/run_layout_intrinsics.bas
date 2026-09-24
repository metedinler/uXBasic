#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"

Private Function ParseExpectOk(ByRef src As String, ByRef errOut As String, ByRef psOut As ParseState) As Integer
    Dim st As LexerState
    LexerInit st, src

    ParserInit psOut, st
    If ParseProgram(psOut) = 0 Then
        errOut = psOut.lastError
        Return 0
    End If

    Return 1
End Function

Private Function ParseExpectFail(ByRef src As String, ByRef expectedPart As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) <> 0 Then
        errOut = "expected parse failure"
        Return 0
    End If

    errOut = ps.lastError
    If Instr(UCase(errOut), UCase(expectedPart)) = 0 Then
        errOut = "unexpected error text: " & errOut
        Return 0
    End If

    Return 1
End Function

Private Function HasCallExprValue(ByRef ps As ParseState, ByRef callName As String) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "CALL_EXPR" And UCase(ps.ast.nodes(i).value) = UCase(callName) Then Return 1
    Next i
    Return 0
End Function

Private Sub Main()
    Dim srcOk As String
    srcOk = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "y AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Player" & Chr(10) & _
        "pos AS Vec2" & Chr(10) & _
        "hp AS I16" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Bag" & Chr(10) & _
        "base AS I16" & Chr(10) & _
        "items(0 TO 1) AS Vec2" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = SIZEOF(I32)" & Chr(10) & _
        "b = SIZEOF(Vec2)" & Chr(10) & _
        "c = OFFSETOF(Vec2, ""x"")" & Chr(10) & _
        "d = OFFSETOF(Vec2, ""y"")" & Chr(10) & _
        "e = SIZEOF(Player)" & Chr(10) & _
        "f = OFFSETOF(Player, ""pos.y"")" & Chr(10) & _
        "g = OFFSETOF(Player, ""hp"")" & Chr(10) & _
        "h = SIZEOF(Bag)" & Chr(10) & _
        "i = OFFSETOF(Bag, ""items(0).x"")" & Chr(10) & _
        "j = OFFSETOF(Bag, ""items(1).y"")" & Chr(10) & _
        "k = OFFSETOF(Bag, ""base"")"

    Dim errText As String
    Dim okPs As ParseState
    If ParseExpectOk(srcOk, errText, okPs) = 0 Then
        Print "FAIL sizeof/offsetof ok parse | "; errText
        End 1
    End If

    If HasCallExprValue(okPs, "SIZEOF") = 0 Then
        Print "FAIL missing SIZEOF call expression"
        End 1
    End If

    If HasCallExprValue(okPs, "OFFSETOF") = 0 Then
        Print "FAIL missing OFFSETOF call expression"
        End 1
    End If

    Dim errLayout As String
    Dim szI32 As Integer
    Dim szVec2 As Integer
    Dim szPlayer As Integer
    Dim szBag As Integer
    Dim offVec2Y As Integer
    Dim offPosY As Integer
    Dim offHp As Integer
    Dim offBagItems0X As Integer
    Dim offBagItems1Y As Integer
    Dim offBagBase As Integer

    If TypeLayoutSizeOf(okPs, "I32", szI32, errLayout) = 0 Then
        Print "FAIL sizeof i32 resolve | "; errLayout
        End 1
    End If
    If szI32 <> 4 Then
        Print "FAIL sizeof i32 value | got="; szI32
        End 1
    End If

    If TypeLayoutSizeOf(okPs, "Vec2", szVec2, errLayout) = 0 Then
        Print "FAIL sizeof vec2 resolve | "; errLayout
        End 1
    End If
    If szVec2 <> 8 Then
        Print "FAIL sizeof vec2 value | got="; szVec2
        End 1
    End If

    If TypeLayoutSizeOf(okPs, "Player", szPlayer, errLayout) = 0 Then
        Print "FAIL sizeof player resolve | "; errLayout
        End 1
    End If
    If szPlayer <> 12 Then
        Print "FAIL sizeof player value | got="; szPlayer
        End 1
    End If

    If TypeLayoutSizeOf(okPs, "Bag", szBag, errLayout) = 0 Then
        Print "FAIL sizeof bag resolve | "; errLayout
        End 1
    End If
    If szBag <> 20 Then
        Print "FAIL sizeof bag value | got="; szBag
        End 1
    End If

    If TypeLayoutOffsetOf(okPs, "Vec2", "y", offVec2Y, errLayout) = 0 Then
        Print "FAIL offsetof vec2.y resolve | "; errLayout
        End 1
    End If
    If offVec2Y <> 4 Then
        Print "FAIL offsetof vec2.y value | got="; offVec2Y
        End 1
    End If

    If TypeLayoutOffsetOf(okPs, "Player", "pos.y", offPosY, errLayout) = 0 Then
        Print "FAIL offsetof player.pos.y resolve | "; errLayout
        End 1
    End If
    If offPosY <> 4 Then
        Print "FAIL offsetof player.pos.y value | got="; offPosY
        End 1
    End If

    If TypeLayoutOffsetOf(okPs, "Player", "hp", offHp, errLayout) = 0 Then
        Print "FAIL offsetof player.hp resolve | "; errLayout
        End 1
    End If
    If offHp <> 8 Then
        Print "FAIL offsetof player.hp value | got="; offHp
        End 1
    End If

    If TypeLayoutOffsetOf(okPs, "Bag", "items(0).x", offBagItems0X, errLayout) = 0 Then
        Print "FAIL offsetof bag.items(0).x resolve | "; errLayout
        End 1
    End If
    If offBagItems0X <> 4 Then
        Print "FAIL offsetof bag.items(0).x value | got="; offBagItems0X
        End 1
    End If

    If TypeLayoutOffsetOf(okPs, "Bag", "items(1).y", offBagItems1Y, errLayout) = 0 Then
        Print "FAIL offsetof bag.items(1).y resolve | "; errLayout
        End 1
    End If
    If offBagItems1Y <> 16 Then
        Print "FAIL offsetof bag.items(1).y value | got="; offBagItems1Y
        End 1
    End If

    If TypeLayoutOffsetOf(okPs, "Bag", "base", offBagBase, errLayout) = 0 Then
        Print "FAIL offsetof bag.base resolve | "; errLayout
        End 1
    End If
    If offBagBase <> 0 Then
        Print "FAIL offsetof bag.base value | got="; offBagBase
        End 1
    End If

    Dim srcFail1 As String
    srcFail1 = "x = SIZEOF(""I32"")"
    If ParseExpectFail(srcFail1, "SIZEOF EXPECTS A TYPE NAME", errText) = 0 Then
        Print "FAIL sizeof fail-1 | "; errText
        End 1
    End If

    Dim srcFail2 As String
    srcFail2 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "y = OFFSETOF(Vec2, x)"
    If ParseExpectFail(srcFail2, "OFFSETOF EXPECTS A STRING PATH", errText) = 0 Then
        Print "FAIL offsetof fail-2 | "; errText
        End 1
    End If

    Dim srcFail3 As String
    srcFail3 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "z = OFFSETOF(""Vec2"", ""x"")"
    If ParseExpectFail(srcFail3, "OFFSETOF EXPECTS A TYPE NAME", errText) = 0 Then
        Print "FAIL offsetof fail-3 | "; errText
        End 1
    End If

    Dim srcFail4 As String
    srcFail4 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "w = OFFSETOF(Vec2, """")"
    If ParseExpectFail(srcFail4, "OFFSETOF PATH CANNOT BE EMPTY", errText) = 0 Then
        Print "FAIL offsetof fail-4 | "; errText
        End 1
    End If

    Dim srcFail5 As String
    srcFail5 = "a = SIZEOF(NoSuchType)"
    If ParseExpectFail(srcFail5, "UNKNOWN TYPE", errText) = 0 Then
        Print "FAIL sizeof fail-5 | "; errText
        End 1
    End If

    Dim srcFail6 As String
    srcFail6 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Vec2, ""z"")"
    If ParseExpectFail(srcFail6, "OFFSETOF UNKNOWN FIELD", errText) = 0 Then
        Print "FAIL offsetof fail-6 | "; errText
        End 1
    End If

    Dim srcFail7 As String
    srcFail7 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Vec2, ""x.y"")"
    If ParseExpectFail(srcFail7, "OFFSETOF PATH ENTERS NON-AGGREGATE TYPE", errText) = 0 Then
        Print "FAIL offsetof fail-7 | "; errText
        End 1
    End If

    Dim srcFail8 As String
    srcFail8 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Bag" & Chr(10) & _
        "items(0 TO 1) AS Vec2" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Bag, ""items(2).x"")"
    If ParseExpectFail(srcFail8, "OFFSETOF INDEX OUT OF BOUNDS", errText) = 0 Then
        Print "FAIL offsetof fail-8 | "; errText
        End 1
    End If

    Dim srcFail9 As String
    srcFail9 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Bag" & Chr(10) & _
        "items(0 TO 1) AS Vec2" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Bag, ""items.x"")"
    If ParseExpectFail(srcFail9, "OFFSETOF ARRAY FIELD REQUIRES INDEX", errText) = 0 Then
        Print "FAIL offsetof fail-9 | "; errText
        End 1
    End If

    Dim srcFail10 As String
    srcFail10 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Bag" & Chr(10) & _
        "items(0 TO 1) AS Vec2" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Bag, ""items(0,1).x"")"
    If ParseExpectFail(srcFail10, "OFFSETOF INDEX COUNT MISMATCH", errText) = 0 Then
        If Instr(UCase(errText), "OFFSETOF INVALID INDEX SYNTAX") = 0 Then
            Print "FAIL offsetof fail-10 | "; errText
            End 1
        End If
    End If

    Dim srcFail11 As String
    srcFail11 = _
        "TYPE Vec2" & Chr(10) & _
        "x AS I32" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "TYPE Bag" & Chr(10) & _
        "items(0 TO 1) AS Vec2" & Chr(10) & _
        "END TYPE" & Chr(10) & _
        "a = OFFSETOF(Bag, ""items(,).x"")"
    If ParseExpectFail(srcFail11, "OFFSETOF INVALID INDEX SYNTAX", errText) = 0 Then
        Print "FAIL offsetof fail-11 | "; errText
        End 1
    End If

    Print "PASS layout intrinsics"
    End 0
End Sub

Main
