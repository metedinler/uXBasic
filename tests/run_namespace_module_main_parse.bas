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

Private Function CountAstKind(ByRef ps As ParseState, ByRef kindName As String) As Integer
    Dim i As Integer
    Dim n As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = UCase(kindName) Then n += 1
    Next i
    Return n
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
        "MODULE Net" & Chr(10) & _
        "USING Core.IO, Core.Math" & Chr(10) & _
        "ALIAS MsgBox = CALL ( DLL , ""user32.dll"" , ""MessageBoxA"" , I32 )" & Chr(10) & _
        "END MODULE" & Chr(10) & _
        "END NAMESPACE" & Chr(10) & _
        "MAIN" & Chr(10) & _
        "PRINT 1" & Chr(10) & _
        "END MAIN"

    Dim ps As ParseState
    If ParseOk(srcOk, ps, errText) = 0 Then
        Print "FAIL parse positive | "; errText
        End 1
    End If

    If HasAstKind(ps, "NAMESPACE_STMT") = 0 Then
        Print "FAIL missing NAMESPACE_STMT"
        End 1
    End If

    If HasAstKind(ps, "MODULE_STMT") = 0 Then
        Print "FAIL missing MODULE_STMT"
        End 1
    End If

    If HasAstKind(ps, "USING_STMT") = 0 Then
        Print "FAIL missing USING_STMT"
        End 1
    End If

    If HasAstKind(ps, "ALIAS_STMT") = 0 Or HasAstKind(ps, "ALIAS_TARGET") = 0 Then
        Print "FAIL missing ALIAS nodes"
        End 1
    End If

    If HasAstKind(ps, "MAIN_STMT") = 0 Then
        Print "FAIL missing MAIN_STMT"
        End 1
    End If

    If CountAstKind(ps, "MAIN_STMT") <> 1 Then
        Print "FAIL MAIN_STMT count"
        End 1
    End If

    Dim srcMainInNs As String
    srcMainInNs = _
        "NAMESPACE X" & Chr(10) & _
        "MAIN" & Chr(10) & _
        "END MAIN" & Chr(10) & _
        "END NAMESPACE"

    If ParseFailContains(srcMainInNs, "MAIN: only global scope", errText) = 0 Then
        Print "FAIL main-in-namespace check | "; errText
        End 1
    End If

    Dim srcMultiMain As String
    srcMultiMain = _
        "MAIN" & Chr(10) & _
        "END MAIN" & Chr(10) & _
        "MAIN" & Chr(10) & _
        "END MAIN"

    If ParseFailContains(srcMultiMain, "multiple MAIN", errText) = 0 Then
        Print "FAIL multiple-main check | "; errText
        End 1
    End If

    Dim srcTopLevelExec As String
    srcTopLevelExec = _
        "PRINT 1" & Chr(10) & _
        "MAIN" & Chr(10) & _
        "END MAIN"

    If ParseFailContains(srcTopLevelExec, "top-level executable statement", errText) = 0 Then
        Print "FAIL top-level executable check | "; errText
        End 1
    End If

    Dim srcMissingEndModule As String
    srcMissingEndModule = _
        "MODULE Net" & Chr(10) & _
        "PRINT 1"

    If ParseFailContains(srcMissingEndModule, "missing END MODULE", errText) = 0 Then
        Print "FAIL missing-end-module check | "; errText
        End 1
    End If

    Dim srcUsingDuplicate As String
    srcUsingDuplicate = _
        "USING Core.IO, Core.IO"

    If ParseFailContains(srcUsingDuplicate, "duplicate import path", errText) = 0 Then
        Print "FAIL using-duplicate check | "; errText
        End 1
    End If

    Dim srcUsingAmbiguous As String
    srcUsingAmbiguous = _
        "USING Core.IO, Net.IO"

    If ParseFailContains(srcUsingAmbiguous, "ambiguous symbol", errText) = 0 Then
        Print "FAIL using-ambiguous check | "; errText
        End 1
    End If

    Dim srcAliasDuplicate As String
    srcAliasDuplicate = _
        "ALIAS Foo = Bar" & Chr(10) & _
        "ALIAS Foo = Baz"

    If ParseFailContains(srcAliasDuplicate, "duplicate alias name", errText) = 0 Then
        Print "FAIL alias-duplicate check | "; errText
        End 1
    End If

    Dim srcAliasSelfCycle As String
    srcAliasSelfCycle = _
        "ALIAS Foo = Foo"

    If ParseFailContains(srcAliasSelfCycle, "cycle detected", errText) = 0 Then
        Print "FAIL alias-self-cycle check | "; errText
        End 1
    End If

    Dim srcAliasTwoNodeCycle As String
    srcAliasTwoNodeCycle = _
        "ALIAS A = B" & Chr(10) & _
        "ALIAS B = A"

    If ParseFailContains(srcAliasTwoNodeCycle, "cycle detected", errText) = 0 Then
        Print "FAIL alias-two-node-cycle check | "; errText
        End 1
    End If

    Dim srcAliasUsingConflict As String
    srcAliasUsingConflict = _
        "USING Core.IO" & Chr(10) & _
        "ALIAS IO = Core.Net"

    If ParseFailContains(srcAliasUsingConflict, "conflicts with USING", errText) = 0 Then
        Print "FAIL alias-using-conflict check | "; errText
        End 1
    End If

    Print "PASS namespace/module/main parse"
    End 0
End Sub

Main
