#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/codegen/mir_err_lowering.fbs"
#include once "../src/codegen/err_backend_hooks.fbs"

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
        "THROW 7, ""boom"", ""d""" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "END TRY"

    Dim ps As ParseState
    Dim errText As String
    If ParseToState(src, ps, errText) = 0 Then
        Print "FAIL err backend parse | "; errText
        End 1
    End If

    Dim mirCsv As String
    If MirErrLoweringEmitCsv(ps, mirCsv, errText) = 0 Then
        Print "FAIL err backend mir | "; errText
        End 1
    End If

    Dim backendCsv As String
    If ErrBackendEmitStubCsv(mirCsv, backendCsv, errText) = 0 Then
        Print "FAIL err backend emit | "; errText
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_EDGE,THROW_TO_HANDLER_SCAN,ERR_HANDLER_SCAN,JMP_HANDLER_SCAN_PLACEHOLDER") = 0 Then
        Print "FAIL err backend missing handler scan hook"
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_EDGE,THROW_TO_UNHANDLED_TRAP,ERR_UNHANDLED_TRAP,TRAP_EXIT_STUB") = 0 Then
        Print "FAIL err backend missing unhandled trap hook"
        End 1
    End If

    If InStr(backendCsv, "ASSERT,ASSERT_EDGE,ASSERT_FAIL_TO_THROW,ASSERT_FAIL,JMP_THROW_PATH") = 0 Then
        Print "FAIL err backend missing assert fail hook"
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_MATERIALIZE,ERR_OBJECT,ERR_THROW_MATERIALIZE,BUILD_ERR_OBJECT_STUB") = 0 Then
        Print "FAIL err backend missing throw materialization hook"
        End 1
    End If

    If InStr(backendCsv, "ASSERT,ASSERT_POLICY,ASSERT_DEBUG_ACTIVE,ASSERT_POLICY,CHECK_ASSERT_POLICY_STUB") = 0 Then
        Print "FAIL err backend missing assert policy hook"
        End 1
    End If

    If InStr(backendCsv, ",REGISTER_HANDLER_REGION") = 0 Or InStr(backendCsv, "TRY,TRY_BEGIN,ERR_CATCH_") = 0 Then
        Print "FAIL err backend missing try region registration"
        End 1
    End If

    If InStr(backendCsv, ",UNREGISTER_HANDLER_REGION") = 0 Then
        Print "FAIL err backend missing try region unregister"
        End 1
    End If

    If InStr(backendCsv, "TRY,CATCH_LABEL,TRY_CATCH,ERR_CATCH_") = 0 Then
        Print "FAIL err backend missing catch label hook"
        End 1
    End If

    If InStr(backendCsv, "TRY,FINALLY_LABEL,TRY_FINALLY,ERR_FINALLY_") = 0 Then
        Print "FAIL err backend missing finally label hook"
        End 1
    End If

    If InStr(backendCsv, "ERR_TRY_EDGE_TRY_THROW_TO_CATCH_") = 0 Or InStr(backendCsv, ",JMP_TRAMPOLINE") = 0 Then
        Print "FAIL err backend missing throw-to-catch trampoline edge"
        End 1
    End If

    If InStr(backendCsv, "ERR_TRY_EDGE_TRY_NORMAL_TO_FINALLY_") = 0 Then
        Print "FAIL err backend missing normal-to-finally trampoline edge"
        End 1
    End If

    If InStr(backendCsv, "ERR_TRY_EDGE_FINALLY_TO_END_") = 0 Then
        Print "FAIL err backend missing finally-to-end trampoline edge"
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_MATERIALIZE,ERR_ABI_LAYOUT,ERR_THROW_LAYOUT,DECLARE_ERR_ABI_LAYOUT") = 0 Then
        Print "FAIL err backend missing throw ABI layout row"
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_CODE,ERR_THROW_FIELD_CODE,STORE_ERR_CODE_PTR") = 0 Then
        Print "FAIL err backend missing throw code field row"
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_MESSAGE,ERR_THROW_FIELD_MESSAGE,STORE_ERR_MESSAGE_PTR") = 0 Then
        Print "FAIL err backend missing throw message field row"
        End 1
    End If

    If InStr(backendCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_DETAIL,ERR_THROW_FIELD_DETAIL,STORE_ERR_DETAIL_PTR") = 0 Then
        Print "FAIL err backend missing throw detail field row"
        End 1
    End If

    Print "PASS err backend hooks"
    End 0
End Sub

Main
