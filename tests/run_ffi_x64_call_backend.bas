#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/codegen/x64/ffi_call_backend.fbs"

Private Function ParseText(ByRef src As String, ByRef ps As ParseState, ByRef errText As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    ParserInit ps, st
    If ParseProgram(ps) = 0 Then
        errText = ps.lastError
        Return 0
    End If

    Return 1
End Function

Private Function AssertTrue(ByVal condValue As Integer, ByRef msg As String) As Integer
    If condValue = 0 Then
        Print "FAIL "; msg
        Return 0
    End If
    Return 1
End Function

Private Function ChildAt(ByRef ps As ParseState, ByVal nodeIdx As Integer, ByVal childPos As Integer) As Integer
    If nodeIdx < 0 Or nodeIdx >= ps.ast.count Then Return -1

    Dim ch As Integer
    Dim i As Integer
    ch = ps.ast.nodes(nodeIdx).firstChild
    Do While ch <> -1
        If i = childPos Then Return ch
        i += 1
        ch = ps.ast.nodes(ch).nextSibling
    Loop

    Return -1
End Function

Private Function FirstCallDllNode(ByRef ps As ParseState) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "CALL_STMT" Or UCase(ps.ast.nodes(i).kind) = "CALL_EXPR" Then
            If UCase(Trim(ps.ast.nodes(i).value)) = "DLL" Then Return i
        End If
    Next i
    Return -1
End Function

Private Function FirstCallDllNodeWithConvention(ByRef ps As ParseState) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "CALL_STMT" Or UCase(ps.ast.nodes(i).kind) = "CALL_EXPR" Then
            If UCase(Trim(ps.ast.nodes(i).value)) = "DLL" Then
                Dim convNode As Integer
                convNode = ChildAt(ps, i, 3)
                If convNode <> -1 Then
                    If UCase(ps.ast.nodes(convNode).kind) = "KEYWORD_REF" Then
                        If UCase(Trim(ps.ast.nodes(convNode).value)) = "CDECL" Or UCase(Trim(ps.ast.nodes(convNode).value)) = "STDCALL" Then
                            Return i
                        End If
                    End If
                End If
            End If
        End If
    Next i

    Return -1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim srcGood As String
    srcGood = _
        "MAIN" & Chr(10) & _
        "a = 1" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, a)" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, STDCALL, a)" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, a, 2, 3, 4, 5)" & Chr(10) & _
        "END MAIN"

    Dim psGood As ParseState
    Dim parseErr As String
    ok And= AssertTrue(ParseText(srcGood, psGood, parseErr), "parse good ffi sample: " & parseErr)

    Dim backendErr As String
    ok And= AssertTrue(FfiX64BackendValidate(psGood, backendErr), "ffi x64 validate: " & backendErr)

    Dim planCsv As String
    ok And= AssertTrue(FfiX64BackendEmitPlan(psGood, planCsv, backendErr), "ffi x64 emit plan: " & backendErr)
    ok And= AssertTrue(InStr(1, planCsv, "arg_count,stack_args,reserve_bytes,abi,stack_align,shadow_space") > 0, "plan header")
    ok And= AssertTrue(InStr(1, planCsv, "WIN64-MSABI,16,32") > 0, "plan abi/stack/shadow")
    ok And= AssertTrue(InStr(1, planCsv, ",CDECL,1,0,40,WIN64-MSABI,16,32") > 0, "plan default cdecl")
    ok And= AssertTrue(InStr(1, planCsv, ",STDCALL,1,0,40,WIN64-MSABI,16,32") > 0, "plan stdcall")
    ok And= AssertTrue(InStr(1, planCsv, ",CDECL,5,1,56,WIN64-MSABI,16,32") > 0, "plan stack-arg reserve")

    Dim asmText As String
    ok And= AssertTrue(FfiX64BackendEmitNasmStubs(psGood, asmText, backendErr), "ffi x64 emit asm: " & backendErr)
    ok And= AssertTrue(InStr(1, asmText, "sub rsp, 40") > 0, "asm stack reserve")
    ok And= AssertTrue(InStr(1, asmText, "add rsp, 40") > 0, "asm stack restore")
    ok And= AssertTrue(InStr(1, asmText, "call qword [rel __uxb_ffi_symptr_1]") > 0, "asm indirect call")
    ok And= AssertTrue(InStr(1, asmText, "sub rsp, 56") > 0, "asm stack reserve with stack-arg")
    ok And= AssertTrue(InStr(1, asmText, "mov qword [rsp+32], rax") > 0, "asm stack arg store")

    Dim srcNoDll As String
    srcNoDll = _
        "MAIN" & Chr(10) & _
        "PRINT 1" & Chr(10) & _
        "END MAIN"

    Dim psNoDll As ParseState
    parseErr = ""
    ok And= AssertTrue(ParseText(srcNoDll, psNoDll, parseErr), "parse no-dll sample: " & parseErr)

    backendErr = ""
    ok And= AssertTrue(FfiX64BackendValidate(psNoDll, backendErr) = 0, "ffi x64 must reject no CALL(DLL)")

    Dim psMut As ParseState
    parseErr = ""
    ok And= AssertTrue(ParseText(srcGood, psMut, parseErr), "parse mutate ffi sample: " & parseErr)
    Dim callNode As Integer
    callNode = FirstCallDllNodeWithConvention(psMut)
    ok And= AssertTrue(callNode <> -1, "mutate sample has CALL(DLL) with convention")
    If callNode <> -1 Then
        Dim convNode As Integer
        convNode = ChildAt(psMut, callNode, 3)
        ok And= AssertTrue(convNode <> -1, "mutate sample has convention slot")
        If convNode <> -1 Then
            psMut.ast.nodes(convNode).kind = "KEYWORD_REF"
            psMut.ast.nodes(convNode).value = "TIMER"
            backendErr = ""
            ok And= AssertTrue(FfiX64BackendValidate(psMut, backendErr) = 0, "ffi x64 backend invalid convention reject")
        End If
    End If

    If ok = 0 Then End 1

    Print "PASS ffi x64 call backend"
    End 0
End Sub

Main
