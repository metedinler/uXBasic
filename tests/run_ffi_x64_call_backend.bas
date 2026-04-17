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

    Dim resolverCsv As String
    ok And= AssertTrue(FfiX64BackendEmitResolver(psGood, resolverCsv, backendErr), "ffi x64 emit resolver: " & backendErr)
    ok And= AssertTrue(InStr(1, resolverCsv, "stub_id,dll,symbol,signature,convention,arg_count,stack_args,reserve_bytes,abi,stack_align,shadow_space,symptr_label") > 0, "resolver header")
    ok And= AssertTrue(InStr(1, resolverCsv, "1,KERNEL32.DLL,GETTICKCOUNT,I32,CDECL,1,0,40,WIN64-MSABI,16,32,__uxb_ffi_symptr_1") > 0, "resolver stub1 mapping")
    ok And= AssertTrue(InStr(1, resolverCsv, "2,KERNEL32.DLL,GETTICKCOUNT,I32,STDCALL,1,0,40,WIN64-MSABI,16,32,__uxb_ffi_symptr_2") > 0, "resolver stub2 mapping")
    ok And= AssertTrue(InStr(1, resolverCsv, "3,KERNEL32.DLL,GETTICKCOUNT,I32,CDECL,5,1,56,WIN64-MSABI,16,32,__uxb_ffi_symptr_3") > 0, "resolver stack arg mapping")

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

    If ok = 0 Then End 1

    Print "PASS ffi x64 call backend"
    End 0
End Sub

Main
