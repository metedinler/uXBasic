#if defined(__FB_WIN32__) AndAlso Not defined(__FB_WIN64__)
Dim Shared __uxb_ffi_x86_symptr_1 As Any Ptr
Dim Shared gSymptrWriteCount As Integer

Function TargetMul2 Cdecl(ByVal v As Integer) As Integer
    Return v * 2
End Function

Function TargetAdd7 Cdecl(ByVal v As Integer) As Integer
    Return v + 7
End Function

Function StubCallBySymptrCdecl(ByVal v As Integer) As Integer
    Dim retValue As Integer
    Asm
        mov eax, [v]
        push eax
        call dword ptr [__uxb_ffi_x86_symptr_1]
        add esp, 4
        mov [retValue], eax
    End Asm
    Return retValue
End Function

Private Sub SymptrPatch(ByVal p As Any Ptr)
    __uxb_ffi_x86_symptr_1 = p
    gSymptrWriteCount += 1
End Sub

Private Sub Main32()
    Dim ok As Integer
    ok = 1

    SymptrPatch(ProcPtr(TargetMul2))
    Dim r1 As Integer
    r1 = StubCallBySymptrCdecl(10)

    SymptrPatch(ProcPtr(TargetAdd7))
    Dim r2 As Integer
    r2 = StubCallBySymptrCdecl(10)

    If r1 <> 20 Then
        Print "FAIL native-symptr: first target"
        ok = 0
    End If

    If r2 <> 17 Then
        Print "FAIL native-symptr: patched target"
        ok = 0
    End If

    If gSymptrWriteCount < 2 Then
        Print "FAIL native-symptr: write count"
        ok = 0
    End If

    If ok = 0 Then End 1

    Print "PASS native x86 symptr patch probe"
    End 0
End Sub

Main32
#else
Print "SKIP native x86 symptr patch probe: requires win32 target"
End 0
#endif