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

Private Function LoadTextFile(ByRef pathText As String, ByRef textOut As String) As Integer
    Dim f As Integer
    f = FreeFile

    Open pathText For Input As #f
    If Err <> 0 Then Return 0

    textOut = ""
    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        If textOut <> "" Then textOut &= Chr(10)
        textOut &= lineText
    Loop

    Close #f
    Return 1
End Function

Private Sub Main()
    Dim src As String
    src = _
        "TRY" & Chr(10) & _
        "THROW 7, ""boom"", ""d""" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "ASSERT 1" & Chr(10) & _
        "END TRY"

    Dim ps As ParseState
    Dim errText As String
    If ParseToState(src, ps, errText) = 0 Then
        Print "FAIL err artifacts parse | "; errText
        End 1
    End If

    If ErrBackendEmitArtifacts(ps, "dist\\interop", errText) = 0 Then
        Print "FAIL err artifacts emit | "; errText
        End 1
    End If

    Dim mirCsv As String
    Dim hookCsv As String
    Dim asmText As String

    If LoadTextFile("dist\\interop\\err_mir_plan.csv", mirCsv) = 0 Then
        Print "FAIL err artifacts missing err_mir_plan.csv"
        End 1
    End If

    If LoadTextFile("dist\\interop\\err_backend_hooks.csv", hookCsv) = 0 Then
        Print "FAIL err artifacts missing err_backend_hooks.csv"
        End 1
    End If

    If LoadTextFile("dist\\interop\\err_backend_stubs.asm", asmText) = 0 Then
        Print "FAIL err artifacts missing err_backend_stubs.asm"
        End 1
    End If

    If InStr(mirCsv, "THROW_STMT,THROW_EDGE,THROW_TO_HANDLER_SCAN") = 0 Then
        Print "FAIL err artifacts missing THROW handler edge"
        End 1
    End If

    If InStr(hookCsv, "THROW,THROW_EDGE,THROW_TO_UNHANDLED_TRAP,ERR_UNHANDLED_TRAP,TRAP_EXIT_STUB") = 0 Then
        Print "FAIL err artifacts missing unhandled trap hook"
        End 1
    End If

    If InStr(hookCsv, "THROW,THROW_MATERIALIZE,ERR_OBJECT,ERR_THROW_MATERIALIZE,BUILD_ERR_OBJECT_STUB") = 0 Then
        Print "FAIL err artifacts missing throw materialize hook"
        End 1
    End If

    If InStr(hookCsv, "ASSERT,ASSERT_POLICY,ASSERT_DEBUG_ACTIVE,ASSERT_POLICY,CHECK_ASSERT_POLICY_STUB") = 0 Then
        Print "FAIL err artifacts missing assert policy hook"
        End 1
    End If

    If InStr(hookCsv, ",REGISTER_HANDLER_REGION") = 0 Or InStr(hookCsv, "TRY,TRY_BEGIN,ERR_CATCH_") = 0 Then
        Print "FAIL err artifacts missing try region registration"
        End 1
    End If

    If InStr(hookCsv, ",UNREGISTER_HANDLER_REGION") = 0 Then
        Print "FAIL err artifacts missing try region unregister"
        End 1
    End If

    If InStr(hookCsv, "TRY,CATCH_LABEL,TRY_CATCH,ERR_CATCH_") = 0 Then
        Print "FAIL err artifacts missing catch hook row"
        End 1
    End If

    If InStr(hookCsv, "TRY,FINALLY_LABEL,TRY_FINALLY,ERR_FINALLY_") = 0 Then
        Print "FAIL err artifacts missing finally hook row"
        End 1
    End If

    If InStr(hookCsv, "ERR_TRY_EDGE_TRY_THROW_TO_CATCH_") = 0 Or InStr(hookCsv, ",JMP_TRAMPOLINE") = 0 Then
        Print "FAIL err artifacts missing throw-to-catch trampoline row"
        End 1
    End If

    If InStr(hookCsv, "ERR_TRY_EDGE_TRY_NORMAL_TO_FINALLY_") = 0 Then
        Print "FAIL err artifacts missing normal-to-finally trampoline row"
        End 1
    End If

    If InStr(hookCsv, "ERR_TRY_EDGE_FINALLY_TO_END_") = 0 Then
        Print "FAIL err artifacts missing finally-to-end trampoline row"
        End 1
    End If

    If InStr(hookCsv, "THROW,THROW_MATERIALIZE,ERR_ABI_LAYOUT,ERR_THROW_LAYOUT,DECLARE_ERR_ABI_LAYOUT") = 0 Then
        Print "FAIL err artifacts missing throw ABI layout row"
        End 1
    End If

    If InStr(hookCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_CODE,ERR_THROW_FIELD_CODE,STORE_ERR_CODE_PTR") = 0 Then
        Print "FAIL err artifacts missing throw code field row"
        End 1
    End If

    If InStr(hookCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_MESSAGE,ERR_THROW_FIELD_MESSAGE,STORE_ERR_MESSAGE_PTR") = 0 Then
        Print "FAIL err artifacts missing throw message field row"
        End 1
    End If

    If InStr(hookCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_DETAIL,ERR_THROW_FIELD_DETAIL,STORE_ERR_DETAIL_PTR") = 0 Then
        Print "FAIL err artifacts missing throw detail field row"
        End 1
    End If

    If InStr(asmText, "__uxb_err_handler_scan") = 0 Then
        Print "FAIL err artifacts missing handler scan symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_handler_count") = 0 Then
        Print "FAIL err artifacts missing handler count symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_handler_top") = 0 Then
        Print "FAIL err artifacts missing handler top symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_handler_capacity") = 0 Then
        Print "FAIL err artifacts missing handler capacity symbol"
        End 1
    End If

    If InStr(asmText, "mov rcx, qword [rel __uxb_err_handler_top]") = 0 Then
        Print "FAIL err artifacts missing handler top probe"
        End 1
    End If

    If InStr(asmText, "lea rdx, [rel __uxb_err_handler_table]") = 0 Then
        Print "FAIL err artifacts missing handler table base load"
        End 1
    End If

    If InStr(asmText, "__uxb_err_handler_index") = 0 Then
        Print "FAIL err artifacts missing handler index symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_assert_release_mode") = 0 Then
        Print "FAIL err artifacts missing assert release mode symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_throw_materialize") = 0 Then
        Print "FAIL err artifacts missing throw materialize symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_catch_") = 0 Then
        Print "FAIL err artifacts missing catch label symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_try_end_") = 0 Then
        Print "FAIL err artifacts missing try end unregister symbol"
        End 1
    End If

    If InStr(asmText, "__uxb_err_finally_") = 0 Then
        Print "FAIL err artifacts missing finally label symbol"
        End 1
    End If

    If InStr(asmText, "JMP_TRAMPOLINE") = 0 Then
        Print "FAIL err artifacts missing trampoline emit markers"
        End 1
    End If

    If InStr(asmText, "__uxb_err_obj_magic") = 0 Then
        Print "FAIL err artifacts missing throw object magic"
        End 1
    End If

    If InStr(asmText, "__uxb_err_obj_code_ptr") = 0 Then
        Print "FAIL err artifacts missing throw object code slot"
        End 1
    End If

    If InStr(asmText, "__uxb_err_obj_message_ptr") = 0 Then
        Print "FAIL err artifacts missing throw object message slot"
        End 1
    End If

    If InStr(asmText, "__uxb_err_obj_detail_ptr") = 0 Then
        Print "FAIL err artifacts missing throw object detail slot"
        End 1
    End If

    If InStr(asmText, "__uxb_err_pending_code_ptr") = 0 Then
        Print "FAIL err artifacts missing pending throw code slot"
        End 1
    End If

    If InStr(asmText, "__uxb_err_pending_message_ptr") = 0 Then
        Print "FAIL err artifacts missing pending throw message slot"
        End 1
    End If

    If InStr(asmText, "__uxb_err_pending_detail_ptr") = 0 Then
        Print "FAIL err artifacts missing pending throw detail slot"
        End 1
    End If

    If InStr(asmText, "__uxb_err_get_throw_object") = 0 Then
        Print "FAIL err artifacts missing throw object getter"
        End 1
    End If

    If InStr(asmText, "__uxb_err_get_throw_code_ptr") = 0 Then
        Print "FAIL err artifacts missing throw code getter"
        End 1
    End If

    If InStr(asmText, "__uxb_err_get_throw_message_ptr") = 0 Then
        Print "FAIL err artifacts missing throw message getter"
        End 1
    End If

    If InStr(asmText, "__uxb_err_get_throw_detail_ptr") = 0 Then
        Print "FAIL err artifacts missing throw detail getter"
        End 1
    End If

    If InStr(asmText, "__uxb_err_set_assert_release_mode") = 0 Then
        Print "FAIL err artifacts missing assert mode setter"
        End 1
    End If

    If InStr(asmText, "__uxb_err_get_assert_release_mode") = 0 Then
        Print "FAIL err artifacts missing assert mode getter"
        End 1
    End If

    If InStr(asmText, "ud2") = 0 Then
        Print "FAIL err artifacts missing trap stub"
        End 1
    End If

    Print "PASS err backend artifacts"
    End 0
End Sub

Main
