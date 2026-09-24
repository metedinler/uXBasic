#ifdef __FB_32BIT__
Declare Function LoadLibraryA Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As ZString Ptr) As Any Ptr
Declare Function GetProcAddress Lib "kernel32" Alias "GetProcAddress" (ByVal hModule As Any Ptr, ByVal lpProcName As ZString Ptr) As Any Ptr

Type FnStdcallU32Arg As Function Stdcall (ByVal arg0 As UInteger) As Integer
Type FnCdeclZStrPtrArg As Function Cdecl (ByVal s As ZString Ptr) As Integer

Private Function EspSnapshot() As UInteger
    Dim espValue As UInteger
    Asm
        mov eax, esp
        mov [espValue], eax
    End Asm
    Return espValue
End Function

Private Sub Main32()
    Dim hUser As Any Ptr
    Dim hMsvcrt As Any Ptr
    Dim pMessageBeep As Any Ptr
    Dim pAtoi As Any Ptr

    hUser = LoadLibraryA(StrPtr("user32.dll"))
    hMsvcrt = LoadLibraryA(StrPtr("msvcrt.dll"))
    If hUser = 0 Or hMsvcrt = 0 Then
        Print "FAIL native-cleanup: LoadLibrary"
        End 1
    End If

    pMessageBeep = GetProcAddress(hUser, StrPtr("MessageBeep"))
    pAtoi = GetProcAddress(hMsvcrt, StrPtr("atoi"))
    If pMessageBeep = 0 Or pAtoi = 0 Then
        Print "FAIL native-cleanup: GetProcAddress"
        End 1
    End If

    Dim fStd As FnStdcallU32Arg
    Dim fCdecl As FnCdeclZStrPtrArg
    fStd = pMessageBeep
    fCdecl = pAtoi

    Dim espBeforeStd As UInteger
    Dim espAfterStd As UInteger
    Dim espBeforeCdecl As UInteger
    Dim espAfterCdecl As UInteger

    espBeforeStd = EspSnapshot()
    Dim stdRet As Integer
    stdRet = fStd(&hFFFFFFFF)
    espAfterStd = EspSnapshot()

    Dim s As ZString * 8
    s = "1234"
    espBeforeCdecl = EspSnapshot()
    Dim cdeclRet As Integer
    cdeclRet = fCdecl(@s)
    espAfterCdecl = EspSnapshot()

    If espBeforeStd <> espAfterStd Then
        Print "FAIL native-cleanup: stdcall esp mismatch"
        End 1
    End If

    If espBeforeCdecl <> espAfterCdecl Then
        Print "FAIL native-cleanup: cdecl esp mismatch"
        End 1
    End If

    If cdeclRet <> 1234 Then
        Print "FAIL native-cleanup: cdecl return"
        End 1
    End If

    Print "PASS native x86 cleanup probe"
    End 0
End Sub

Main32
#else
Print "SKIP native x86 cleanup probe: requires __FB_32BIT__"
End 0
#endif