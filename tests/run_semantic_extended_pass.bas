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

Private Function FindNodeByKindValue(ByRef ps As ParseState, ByRef kindText As String, ByRef valueText As String) As Integer
    Dim i As Integer
    Dim k As String
    Dim v As String
    k = UCase(Trim(kindText))
    v = UCase(Trim(valueText))

    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = k And UCase(Trim(ps.ast.nodes(i).value)) = v Then
            Return i
        End If
    Next i

    Return -1
End Function

Private Function FindNodeByKind(ByRef ps As ParseState, ByRef kindText As String) As Integer
    Dim i As Integer
    Dim k As String
    k = UCase(Trim(kindText))

    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = k Then Return i
    Next i

    Return -1
End Function

Private Function ExpectSemanticFail(ByRef src As String, ByRef expectedNeedle As String, ByRef errText As String) As Integer
    Dim ps As ParseState
    If ParseToState(src, ps, errText) = 0 Then Return 0

    If SemanticAnalyze(ps, errText) <> 0 Then
        errText = "semantic fail bekleniyordu"
        Return 0
    End If

    If InStr(UCase(errText), UCase(expectedNeedle)) = 0 Then Return 0
    Return 1
End Function

Private Sub Main()
    Dim errText As String

    Dim srcOverloadOk As String
    srcOverloadOk = _
        "SUB FOO(a AS I32)" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "SUB FOO(a AS I32, b AS I32)" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "CALL FOO(1)" & Chr(10) & _
        "CALL FOO(1, 2)"

    Dim psOverloadOk As ParseState
    If ParseToState(srcOverloadOk, psOverloadOk, errText) = 0 Then
        Print "FAIL parse overload ok | "; errText
        End 1
    End If

    If SemanticAnalyze(psOverloadOk, errText) = 0 Then
        Print "FAIL semantic overload ok | "; errText
        End 1
    End If

    Dim srcOverloadFail As String
    srcOverloadFail = _
        "SUB BAR(a AS I32)" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "CALL BAR()"

    If ExpectSemanticFail(srcOverloadFail, "OVERLOAD", errText) = 0 Then
        Print "FAIL semantic overload mismatch | "; errText
        End 1
    End If

    Dim srcFold As String
    srcFold = "CONST A = 1 + 2 * 3"

    Dim psFold As ParseState
    If ParseToState(srcFold, psFold, errText) = 0 Then
        Print "FAIL parse fold | "; errText
        End 1
    End If

    If SemanticAnalyze(psFold, errText) = 0 Then
        Print "FAIL semantic fold | "; errText
        End 1
    End If

    Dim constNode As Integer
    constNode = FindNodeByKind(psFold, "CONST_DECL")
    If constNode = -1 Then
        Print "FAIL fold: CONST_DECL not found"
        End 1
    End If

    Dim rhsNode As Integer
    rhsNode = psFold.ast.nodes(constNode).left
    If rhsNode = -1 Then
        Print "FAIL fold: const RHS missing"
        End 1
    End If

    If UCase(psFold.ast.nodes(rhsNode).kind) <> "NUMBER" Then
        Print "FAIL fold: RHS not folded to NUMBER"
        End 1
    End If

    If Val(psFold.ast.nodes(rhsNode).value) <> 7 Then
        Print "FAIL fold: RHS value expected 7 got "; psFold.ast.nodes(rhsNode).value
        End 1
    End If

    Dim srcReachFail As String
    srcReachFail = _
        "FUNCTION G() AS I32" & Chr(10) & _
        "RETURN 1" & Chr(10) & _
        "PRINT 2" & Chr(10) & _
        "END FUNCTION"

    If ExpectSemanticFail(srcReachFail, "UNREACHABLE", errText) = 0 Then
        Print "FAIL semantic reachability | "; errText
        End 1
    End If

    Dim srcGeneric As String
    srcGeneric = _
        "SUB GEN(x AS I32)" & Chr(10) & _
        "END SUB" & Chr(10) & _
        "CALL GEN(1)"

    Dim psGeneric As ParseState
    If ParseToState(srcGeneric, psGeneric, errText) = 0 Then
        Print "FAIL parse generic setup | "; errText
        End 1
    End If

    Dim genSub As Integer
    genSub = FindNodeByKindValue(psGeneric, "SUB_STMT", "GEN")
    Dim genCall As Integer
    genCall = FindNodeByKindValue(psGeneric, "CALL_STMT", "GEN")
    If genSub = -1 Or genCall = -1 Then
        Print "FAIL generic setup nodes missing"
        End 1
    End If

    Dim genParam As Integer
    genParam = ASTNewNode(psGeneric.ast, "GENERIC_PARAM", "T", "", 0, 0)
    ASTAddChild psGeneric.ast, genSub, genParam

    Dim genArg As Integer
    genArg = ASTNewNode(psGeneric.ast, "GENERIC_ARG", "I32", "", 0, 0)
    ASTAddChild psGeneric.ast, genCall, genArg

    If SemanticAnalyze(psGeneric, errText) = 0 Then
        Print "FAIL semantic generic equal arity | "; errText
        End 1
    End If

    Dim genArg2 As Integer
    genArg2 = ASTNewNode(psGeneric.ast, "GENERIC_ARG", "U32", "", 0, 0)
    ASTAddChild psGeneric.ast, genCall, genArg2

    If SemanticAnalyze(psGeneric, errText) <> 0 Then
        Print "FAIL semantic generic mismatch expected"
        End 1
    End If

    If InStr(UCase(errText), "OVERLOAD") = 0 Then
        Print "FAIL semantic generic mismatch message | "; errText
        End 1
    End If

    Print "PASS semantic extended pass"
    End 0
End Sub

Main
