#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/codegen/mir_err_lowering.fbs"

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

Private Sub Main()
    Dim src As String
    src = _
        "TRY" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "THROW 7" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "END TRY"

    Dim ps As ParseState
    Dim errText As String
    If ParseToState(src, ps, errText) = 0 Then
        Print "FAIL err mir parse | "; errText
        End 1
    End If

    Dim csvOut As String
    If MirErrLoweringEmitCsv(ps, csvOut, errText) = 0 Then
        Print "FAIL err mir lowering | "; errText
        End 1
    End If

    If Instr(csvOut, "TRY_STMT,TRY_BEGIN,") = 0 Then
        Print "FAIL mir-lowering: missing TRY_BEGIN row"
        End 1
    End If

    If Instr(csvOut, "TRY_STMT,TRY_EDGE,TRY_TO_BODY") = 0 Then
        Print "FAIL mir-lowering: missing TRY_TO_BODY edge"
        End 1
    End If

    If Instr(csvOut, "TRY_STMT,TRY_EDGE,TRY_THROW_TO_CATCH") = 0 Then
        Print "FAIL mir-lowering: missing TRY_THROW_TO_CATCH edge"
        End 1
    End If

    If Instr(csvOut, "CATCH_PART,CATCH_LABEL,TRY_CATCH") = 0 Then
        Print "FAIL mir-lowering: missing CATCH label"
        End 1
    End If

    If Instr(csvOut, "FINALLY_PART,FINALLY_LABEL,TRY_FINALLY") = 0 Then
        Print "FAIL mir-lowering: missing FINALLY label"
        End 1
    End If

    If Instr(csvOut, "TRY_STMT,TRY_EDGE,CATCH_TO_FINALLY") = 0 Then
        Print "FAIL mir-lowering: missing CATCH_TO_FINALLY edge"
        End 1
    End If

    If Instr(csvOut, "TRY_STMT,TRY_EDGE,FINALLY_TO_END") = 0 Then
        Print "FAIL mir-lowering: missing FINALLY_TO_END edge"
        End 1
    End If

    If InStr(csvOut, "THROW_STMT,THROW") = 0 Then
        Print "FAIL err mir missing THROW lowering"
        End 1
    End If

    If InStr(csvOut, "THROW_STMT,THROW_MATERIALIZE,ERR_OBJECT") = 0 Then
        Print "FAIL err mir missing THROW materialization"
        End 1
    End If

    If InStr(csvOut, "THROW_STMT,THROW_EDGE,THROW_TO_HANDLER_SCAN") = 0 Then
        Print "FAIL err mir missing THROW_TO_HANDLER_SCAN edge"
        End 1
    End If

    If InStr(csvOut, "THROW_STMT,THROW_EDGE,THROW_TO_UNHANDLED_TRAP") = 0 Then
        Print "FAIL err mir missing THROW_TO_UNHANDLED_TRAP edge"
        End 1
    End If

    If InStr(csvOut, "ASSERT_STMT,ASSERT") = 0 Then
        Print "FAIL err mir missing ASSERT lowering"
        End 1
    End If

    If InStr(csvOut, "ASSERT_STMT,ASSERT_POLICY,ASSERT_DEBUG_ACTIVE") = 0 Then
        Print "FAIL err mir missing ASSERT policy row"
        End 1
    End If

    If InStr(csvOut, "ASSERT_STMT,ASSERT_EDGE,ASSERT_PASS_CONTINUE") = 0 Then
        Print "FAIL err mir missing ASSERT_PASS_CONTINUE edge"
        End 1
    End If

    If InStr(csvOut, "ASSERT_STMT,ASSERT_EDGE,ASSERT_FAIL_TO_THROW") = 0 Then
        Print "FAIL err mir missing ASSERT_FAIL_TO_THROW edge"
        End 1
    End If

    Print "PASS err mir lowering"
    End 0
End Sub

Main
