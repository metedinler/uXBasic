#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "../src/codegen/mir_err_lowering.fbs"
#include once "../src/codegen/err_backend_hooks.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function CountOccurrencesCI(ByRef haystack As String, ByRef needle As String) As Integer
    If needle = "" Then Return 0

    Dim upHay As String
    Dim upNeedle As String
    upHay = UCase(haystack)
    upNeedle = UCase(needle)

    Dim posCursor As Integer
    posCursor = 1

    Dim foundCount As Integer
    Do
        Dim p As Integer
        p = InStr(posCursor, upHay, upNeedle)
        If p = 0 Then Exit Do
        foundCount += 1
        posCursor = p + Len(upNeedle)
    Loop

    Return foundCount
End Function

Private Function AssertContains(ByRef textIn As String, ByRef needle As String, ByRef failText As String) As Integer
    If InStr(UCase(textIn), UCase(needle)) > 0 Then Return 1
    failText = needle
    Return 0
End Function

Private Sub Main()
    Dim src As String
    src = _
        "x = 0" & Chr(10) & _
        "TRY" & Chr(10) & _
        "x = x + 1" & Chr(10) & _
        "THROW 77, ""boom"", ""det""" & Chr(10) & _
        "CATCH" & Chr(10) & _
        "x = x + 10" & Chr(10) & _
        "FINALLY" & Chr(10) & _
        "x = x + 100" & Chr(10) & _
        "END TRY" & Chr(10) & _
        "POKED 7190, x"

    Dim ps As ParseState
    Dim errText As String

    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL err parity parse | "; errText
        End 1
    End If

    ExecSetAssertReleaseMode 0
    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL err parity exec | "; errText
        End 1
    End If

    If RTAssertEq(VMemPeekD(7190), 111, "ERR runtime parity value") = 0 Then End 1

    Dim mirCsv As String
    If MirErrLoweringEmitCsv(ps, mirCsv, errText) = 0 Then
        Print "FAIL err parity mir | "; errText
        End 1
    End If

    Dim hookCsv As String
    If ErrBackendEmitStubCsv(mirCsv, hookCsv, errText) = 0 Then
        Print "FAIL err parity hook csv | "; errText
        End 1
    End If

    Dim asmText As String
    If ErrBackendEmitStubAsm(hookCsv, asmText, errText) = 0 Then
        Print "FAIL err parity asm | "; errText
        End 1
    End If

    Dim tryBeginCount As Integer
    Dim tryEndCount As Integer
    Dim regCount As Integer
    Dim unregCount As Integer
    tryBeginCount = CountOccurrencesCI(mirCsv, ",TRY_STMT,TRY_BEGIN,")
    tryEndCount = CountOccurrencesCI(mirCsv, ",TRY_STMT,TRY_END,")
    regCount = CountOccurrencesCI(hookCsv, ",REGISTER_HANDLER_REGION")
    unregCount = CountOccurrencesCI(hookCsv, ",UNREGISTER_HANDLER_REGION")

    If tryBeginCount <> regCount Then
        Print "FAIL err parity register count mismatch | mir="; tryBeginCount; " hook="; regCount
        End 1
    End If

    If tryEndCount <> unregCount Then
        Print "FAIL err parity unregister count mismatch | mir="; tryEndCount; " hook="; unregCount
        End 1
    End If

    Dim missingNeedle As String
    If AssertContains(hookCsv, "ERR_TRY_EDGE_TRY_THROW_TO_CATCH_", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing | "; missingNeedle
        End 1
    End If

    If AssertContains(hookCsv, "ERR_TRY_EDGE_TRY_NORMAL_TO_FINALLY_", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing | "; missingNeedle
        End 1
    End If

    If AssertContains(hookCsv, "ERR_TRY_EDGE_FINALLY_TO_END_", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing | "; missingNeedle
        End 1
    End If

    If AssertContains(hookCsv, "THROW,THROW_MATERIALIZE,ERR_ABI_LAYOUT,ERR_THROW_LAYOUT,DECLARE_ERR_ABI_LAYOUT", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing throw layout row"
        End 1
    End If

    If AssertContains(hookCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_CODE,ERR_THROW_FIELD_CODE,STORE_ERR_CODE_PTR", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing throw code row"
        End 1
    End If

    If AssertContains(hookCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_MESSAGE,ERR_THROW_FIELD_MESSAGE,STORE_ERR_MESSAGE_PTR", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing throw message row"
        End 1
    End If

    If AssertContains(hookCsv, "THROW,THROW_MATERIALIZE,ERR_FIELD_DETAIL,ERR_THROW_FIELD_DETAIL,STORE_ERR_DETAIL_PTR", missingNeedle) = 0 Then
        Print "FAIL err parity hook missing throw detail row"
        End 1
    End If

    If AssertContains(asmText, "__uxb_err_pending_code_ptr", missingNeedle) = 0 Then
        Print "FAIL err parity asm missing pending code slot"
        End 1
    End If

    If AssertContains(asmText, "__uxb_err_pending_message_ptr", missingNeedle) = 0 Then
        Print "FAIL err parity asm missing pending message slot"
        End 1
    End If

    If AssertContains(asmText, "__uxb_err_pending_detail_ptr", missingNeedle) = 0 Then
        Print "FAIL err parity asm missing pending detail slot"
        End 1
    End If

    If AssertContains(asmText, "__uxb_err_get_throw_code_ptr", missingNeedle) = 0 Then
        Print "FAIL err parity asm missing throw code getter"
        End 1
    End If

    If AssertContains(asmText, "__uxb_err_get_throw_message_ptr", missingNeedle) = 0 Then
        Print "FAIL err parity asm missing throw message getter"
        End 1
    End If

    If AssertContains(asmText, "__uxb_err_get_throw_detail_ptr", missingNeedle) = 0 Then
        Print "FAIL err parity asm missing throw detail getter"
        End 1
    End If

    Print "PASS err codegen parity gate"
    End 0
End Sub

Main
