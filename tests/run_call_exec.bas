#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "../src/runtime/diagnostics.fbs"

Private Function AssertEq(ByVal actualValue As Integer, ByVal expectedValue As Integer, ByRef msg As String) As Integer
    If actualValue <> expectedValue Then
        Print "FAIL "; msg; " expected="; expectedValue; " actual="; actualValue
        Return 0
    End If
    Return 1
End Function

Private Function RunProgramExpectOk(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = "parse | " & ps.lastError
        Return 0
    End If

    If ExecRunMemoryProgram(ps, errOut) = 0 Then
        errOut = "exec | " & errOut
        Return 0
    End If

    Return 1
End Function

Private Function RunProgramExpectExecFail(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = "parse | " & ps.lastError
        Return 0
    End If

    errOut = ""
    If ExecRunMemoryProgram(ps, errOut) <> 0 Then
        errOut = "expected exec failure"
        Return 0
    End If

    Return 1
End Function

Private Function ParseProgramExpectFailContains(ByRef src As String, ByRef errNeedle As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

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

Private Function ContainsText(ByRef haystack As String, ByRef needle As String) As Integer
    Return Instr(UCase(haystack), UCase(needle)) > 0
End Function

Private Function ReadTextFile(ByRef filePath As String, ByRef textOut As String) As Integer
    Dim f As Integer
    f = FreeFile

    Open filePath For Input As #f
    If Err <> 0 Then Return 0

    textOut = ""
    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        textOut &= lineText
        If Not Eof(f) Then textOut &= Chr(10)
    Loop

    Close #f
    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim defaultPolicyPath As String
    defaultPolicyPath = ""
    ExecSetFfiPolicyPath defaultPolicyPath
    ExecSetFfiPolicyMode "REPORT_ONLY"

    Dim srcOk As String
    srcOk = _
        "x = 4096" & Chr(10) & _
        "POKEB x, 66" & Chr(10) & _
        "a = 1" & Chr(10) & _
        "CALL VARPTR(a)" & Chr(10) & _
        "CALL PEEKB(x)" & Chr(10) & _
        "CALL SADD(""abc"")" & Chr(10) & _
        "CALL LPTR(label1)" & Chr(10) & _
        "CALL CODEPTR(proc1)" & Chr(10) & _
        "label1:" & Chr(10) & _
        "DECLARE SUB proc1()" & Chr(10) & _
        "b = PEEKB(x)" & Chr(10) & _
        "POKED x + 4, b"

    Dim errText As String
    If RunProgramExpectOk(srcOk, errText) = 0 Then
        Print "FAIL call exec success path | "; errText
        End 1
    End If

    ok And= AssertEq(VMemPeekB(4096), 66, "call success memory byte")
    ok And= AssertEq(VMemPeekD(4100), 66, "call success captured value")

    Dim srcFail As String
    srcFail = "CALL UNKNOWN(1)"

    Dim failErr As String
    If RunProgramExpectExecFail(srcFail, failErr) = 0 Then
        Print "FAIL call exec fail path | "; failErr
        End 1
    End If

    If Instr(UCase(failErr), "UNSUPPORTED CALL UNKNOWN") = 0 Then
        Print "FAIL call exec fail path detail | "; failErr
        End 1
    End If

    Dim srcDllParseBadSig As String
    srcDllParseBadSig = "CALL(DLL, ""user32.dll"", ""MessageBoxA"", TIMER, 1)"

    Dim parseErr As String
    If ParseProgramExpectFailContains(srcDllParseBadSig, "invalid signature token", parseErr) = 0 Then
        Print "FAIL call dll invalid-signature parse check | "; parseErr
        End 1
    End If

    Dim srcDllParseBadByref As String
    srcDllParseBadByref = "CALL(DLL, ""user32.dll"", ""MessageBoxA"", BYREF, 1)"

    If ParseProgramExpectFailContains(srcDllParseBadByref, "BYREF requires addressable target", parseErr) = 0 Then
        Print "FAIL call dll byref parse check | "; parseErr
        End 1
    End If

    Dim srcDllExprParseBadSig As String
    srcDllExprParseBadSig = "a = DLL(""user32.dll"", ""MessageBoxA"", TIMER, 1)"

    If ParseProgramExpectFailContains(srcDllExprParseBadSig, "invalid signature token", parseErr) = 0 Then
        Print "FAIL call dll expr invalid-signature parse check | "; parseErr
        End 1
    End If

    Dim srcPtrStmtParseBad As String
    srcPtrStmtParseBad = "CALL VARPTR(1)"

    If ParseProgramExpectFailContains(srcPtrStmtParseBad, "VARPTR expects an identifier argument", parseErr) = 0 Then
        Print "FAIL call pointer stmt parse check | "; parseErr
        End 1
    End If

    Dim logPath As String
    logPath = "tests\\tmp_call_dll_audit.log"
    Kill logPath
    DiagInitPath logPath

    Dim srcDllPolicy As String
    srcDllPolicy = _
        "a = 77" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, a)" & Chr(10) & _
        "POKED 4208, a"

    Dim dllErr As String
    If RunProgramExpectOk(srcDllPolicy, dllErr) = 0 Then
        Print "FAIL call dll report-only runtime | "; dllErr
        End 1
    End If

    ok And= AssertEq(VMemPeekD(4208), 77, "call dll report-only continuation")

    Dim logText As String
    If ReadTextFile(logPath, logText) = 0 Then
        Print "FAIL call dll audit log read"
        End 1
    End If

    If ContainsText(logText, "FFI CALL(DLL) EVENT=FFI_POLICY_DECISION") = 0 Then
        Print "FAIL call dll audit prefix | "; logText
        End 1
    End If

    If ContainsText(logText, "allow=0") = 0 Then
        Print "FAIL call dll audit deny decision | "; logText
        End 1
    End If

    If ContainsText(logText, "allow=1") = 0 Then
        Print "FAIL call dll audit allow decision | "; logText
        End 1
    End If

    If ContainsText(logText, "MODE=REPORT_ONLY") = 0 Then
        Print "FAIL call dll audit mode report-only | "; logText
        End 1
    End If

    Dim enforcePolicyPath As String
    enforcePolicyPath = "tests\\tmp_ffi_allowlist_enforce_ok.txt"
    Kill enforcePolicyPath

    Dim pfe As Integer
    pfe = FreeFile
    Open enforcePolicyPath For Output As #pfe
    Print #pfe, "# UXB_FFI_ALLOWLIST_V1"
    Print #pfe, "# dll|symbol|signature|sha256|signer"
    Print #pfe, "kernel32.dll|GetTickCount|I32|1111111111111111111111111111111111111111111111111111111111111111|CN=MICROSOFT WINDOWS"
    Close #pfe

    ExecSetFfiPolicyPath enforcePolicyPath

    ExecSetFfiPolicyMode "ENFORCE"

    Dim srcDllEnforceDeny As String
    srcDllEnforceDeny = _
        "a = 11" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)"

    Dim enforceErr As String
    If RunProgramExpectExecFail(srcDllEnforceDeny, enforceErr) = 0 Then
        Print "FAIL call dll enforce deny expected fail | "; enforceErr
        End 1
    End If

    If ContainsText(enforceErr, "DENIED BY POLICY") = 0 Then
        Print "FAIL call dll enforce deny text | "; enforceErr
        End 1
    End If

    If ContainsText(enforceErr, "9206") = 0 Then
        Print "FAIL call dll enforce deny code | "; enforceErr
        End 1
    End If

    Dim srcDllEnforceAllow As String
    srcDllEnforceAllow = _
        "a = 55" & Chr(10) & _
        "CALL(DLL, ""kernel32.dll"", ""GetTickCount"", I32, a)" & Chr(10) & _
        "POKED 4212, a"

    Dim enforceAllowErr As String
    If RunProgramExpectOk(srcDllEnforceAllow, enforceAllowErr) = 0 Then
        Print "FAIL call dll enforce allow | "; enforceAllowErr
        End 1
    End If

    ok And= AssertEq(VMemPeekD(4212), 55, "call dll enforce allow continuation")

    Dim logTextAfterEnforce As String
    If ReadTextFile(logPath, logTextAfterEnforce) = 0 Then
        Print "FAIL call dll enforce log read"
        End 1
    End If

    If ContainsText(logTextAfterEnforce, "MODE=ENFORCE") = 0 Then
        Print "FAIL call dll audit mode enforce | "; logTextAfterEnforce
        End 1
    End If

    Dim policyPath As String
    policyPath = "tests\\tmp_ffi_allowlist.txt"
    Kill policyPath

    Dim pf As Integer
    pf = FreeFile
    Open policyPath For Output As #pf
    Print #pf, "# UXB_FFI_ALLOWLIST_V1"
    Print #pf, "# dll|symbol|signature|sha256|signer"
    Print #pf, "evil.dll|BlockedProc|I32|AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA|CN=TEST"
    Close #pf

    ExecSetFfiPolicyPath policyPath

    Dim srcDllPolicyFileAllow As String
    srcDllPolicyFileAllow = _
        "a = 88" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)" & Chr(10) & _
        "POKED 4216, a"

    Dim policyFileErr As String
    If RunProgramExpectOk(srcDllPolicyFileAllow, policyFileErr) = 0 Then
        Print "FAIL call dll policy-file allow | "; policyFileErr
        End 1
    End If

    ok And= AssertEq(VMemPeekD(4216), 88, "call dll policy-file continuation")

    Dim logTextPolicyFile As String
    If ReadTextFile(logPath, logTextPolicyFile) = 0 Then
        Print "FAIL call dll policy-file log read"
        End 1
    End If

    If ContainsText(logTextPolicyFile, "PATH=" & UCase(policyPath)) = 0 Then
        Print "FAIL call dll policy-file path log | "; logTextPolicyFile
        End 1
    End If

    Dim noAttestPolicyPath As String
    noAttestPolicyPath = "tests\\tmp_ffi_allowlist_no_attest.txt"
    Kill noAttestPolicyPath

    Dim pna As Integer
    pna = FreeFile
    Open noAttestPolicyPath For Output As #pna
    Print #pna, "# UXB_FFI_ALLOWLIST_V1"
    Print #pna, "# dll|symbol|signature"
    Print #pna, "evil.dll|BlockedProc|I32"
    Close #pna

    ExecSetFfiPolicyPath noAttestPolicyPath

    Dim srcDllNoAttest As String
    srcDllNoAttest = _
        "a = 78" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)"

    Dim noAttestErr As String
    If RunProgramExpectExecFail(srcDllNoAttest, noAttestErr) = 0 Then
        Print "FAIL call dll no-attest expected fail | "; noAttestErr
        End 1
    End If

    If ContainsText(noAttestErr, "9210") = 0 Then
        Print "FAIL call dll no-attest code | "; noAttestErr
        End 1
    End If

    Kill noAttestPolicyPath
    ExecSetFfiPolicyPath policyPath

    Dim hashMismatchPolicyPath As String
    hashMismatchPolicyPath = "tests\\tmp_ffi_allowlist_hash_mismatch.txt"
    Kill hashMismatchPolicyPath

    Dim phm As Integer
    phm = FreeFile
    Open hashMismatchPolicyPath For Output As #phm
    Print #phm, "# UXB_FFI_ALLOWLIST_V1"
    Print #phm, "# dll|symbol|signature|sha256|signer"
    Print #phm, "evil.dll|BlockedProc|I32|BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB|CN=TEST"
    Close #phm

    ExecSetFfiPolicyPath hashMismatchPolicyPath

    Dim srcDllHashMismatch As String
    srcDllHashMismatch = _
        "a = 79" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)"

    Dim hashMismatchErr As String
    If RunProgramExpectExecFail(srcDllHashMismatch, hashMismatchErr) = 0 Then
        Print "FAIL call dll hash-mismatch expected fail | "; hashMismatchErr
        End 1
    End If

    If ContainsText(hashMismatchErr, "9211") = 0 Then
        Print "FAIL call dll hash-mismatch code | "; hashMismatchErr
        End 1
    End If

    Kill hashMismatchPolicyPath
    ExecSetFfiPolicyPath policyPath

    Dim signerMismatchPolicyPath As String
    signerMismatchPolicyPath = "tests\\tmp_ffi_allowlist_signer_mismatch.txt"
    Kill signerMismatchPolicyPath

    Dim psm As Integer
    psm = FreeFile
    Open signerMismatchPolicyPath For Output As #psm
    Print #psm, "# UXB_FFI_ALLOWLIST_V1"
    Print #psm, "# dll|symbol|signature|sha256|signer"
    Print #psm, "evil.dll|BlockedProc|I32|AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA|CN=OTHER"
    Close #psm

    ExecSetFfiPolicyPath signerMismatchPolicyPath

    Dim srcDllSignerMismatch As String
    srcDllSignerMismatch = _
        "a = 80" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)"

    Dim signerMismatchErr As String
    If RunProgramExpectExecFail(srcDllSignerMismatch, signerMismatchErr) = 0 Then
        Print "FAIL call dll signer-mismatch expected fail | "; signerMismatchErr
        End 1
    End If

    If ContainsText(signerMismatchErr, "9212") = 0 Then
        Print "FAIL call dll signer-mismatch code | "; signerMismatchErr
        End 1
    End If

    Kill signerMismatchPolicyPath
    ExecSetFfiPolicyPath policyPath

    Dim hashExtractPolicyPath As String
    hashExtractPolicyPath = "tests\\tmp_ffi_allowlist_hash_extract_fail.txt"
    Kill hashExtractPolicyPath

    Dim phe As Integer
    phe = FreeFile
    Open hashExtractPolicyPath For Output As #phe
    Print #phe, "# UXB_FFI_ALLOWLIST_V1"
    Print #phe, "# dll|symbol|signature|sha256|signer"
    Print #phe, "broken.dll|BlockedProc|I32|AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA|CN=TEST"
    Close #phe

    ExecSetFfiPolicyPath hashExtractPolicyPath

    Dim srcDllHashExtractFail As String
    srcDllHashExtractFail = _
        "a = 81" & Chr(10) & _
        "CALL(DLL, ""broken.dll"", ""BlockedProc"", I32, a)"

    Dim hashExtractErr As String
    If RunProgramExpectExecFail(srcDllHashExtractFail, hashExtractErr) = 0 Then
        Print "FAIL call dll hash-extract-fail expected fail | "; hashExtractErr
        End 1
    End If

    If ContainsText(hashExtractErr, "9213") = 0 Then
        Print "FAIL call dll hash-extract-fail code | "; hashExtractErr
        End 1
    End If

    Kill hashExtractPolicyPath
    ExecSetFfiPolicyPath policyPath

    Dim signerExtractPolicyPath As String
    signerExtractPolicyPath = "tests\\tmp_ffi_allowlist_signer_extract_fail.txt"
    Kill signerExtractPolicyPath

    Dim pse As Integer
    pse = FreeFile
    Open signerExtractPolicyPath For Output As #pse
    Print #pse, "# UXB_FFI_ALLOWLIST_V1"
    Print #pse, "# dll|symbol|signature|sha256|signer"
    Print #pse, "nosign.dll|BlockedProc|I32|0000000000000000000000000000000000000000000000000000000000000000|CN=TEST"
    Close #pse

    ExecSetFfiPolicyPath signerExtractPolicyPath

    Dim srcDllSignerExtractFail As String
    srcDllSignerExtractFail = _
        "a = 82" & Chr(10) & _
        "CALL(DLL, ""nosign.dll"", ""BlockedProc"", I32, a)"

    Dim signerExtractErr As String
    If RunProgramExpectExecFail(srcDllSignerExtractFail, signerExtractErr) = 0 Then
        Print "FAIL call dll signer-extract-fail expected fail | "; signerExtractErr
        End 1
    End If

    If ContainsText(signerExtractErr, "9214") = 0 Then
        Print "FAIL call dll signer-extract-fail code | "; signerExtractErr
        End 1
    End If

    Kill signerExtractPolicyPath
    ExecSetFfiPolicyPath policyPath

    Dim missingPolicyPath As String
    missingPolicyPath = "tests\\tmp_ffi_allowlist_missing.txt"
    Kill missingPolicyPath

    ExecSetFfiPolicyPath missingPolicyPath

    Dim srcDllPolicyMissing As String
    srcDllPolicyMissing = _
        "a = 98" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)"

    Dim missingPolicyErr As String
    If RunProgramExpectExecFail(srcDllPolicyMissing, missingPolicyErr) = 0 Then
        Print "FAIL call dll policy-file missing expected fail | "; missingPolicyErr
        End 1
    End If

    If ContainsText(missingPolicyErr, "9215") = 0 Then
        Print "FAIL call dll policy-file missing deny code | "; missingPolicyErr
        End 1
    End If

    ExecSetFfiPolicyPath policyPath

    Dim badHeaderPolicyPath As String
    badHeaderPolicyPath = "tests\\tmp_ffi_allowlist_no_header.txt"
    Kill badHeaderPolicyPath

    Dim pbh As Integer
    pbh = FreeFile
    Open badHeaderPolicyPath For Output As #pbh
    Print #pbh, "# dll|symbol|signature"
    Print #pbh, "evil.dll|BlockedProc|I32"
    Close #pbh

    ExecSetFfiPolicyPath badHeaderPolicyPath

    Dim srcDllPolicyBadHeader As String
    srcDllPolicyBadHeader = _
        "a = 99" & Chr(10) & _
        "CALL(DLL, ""evil.dll"", ""BlockedProc"", I32, a)"

    Dim badHeaderErr As String
    If RunProgramExpectExecFail(srcDllPolicyBadHeader, badHeaderErr) = 0 Then
        Print "FAIL call dll policy-file missing-header expected fail | "; badHeaderErr
        End 1
    End If

    If ContainsText(badHeaderErr, "9215") = 0 Then
        Print "FAIL call dll policy-file missing-header deny code | "; badHeaderErr
        End 1
    End If

    Dim logTextBadHeader As String
    If ReadTextFile(logPath, logTextBadHeader) = 0 Then
        Print "FAIL call dll policy-file missing-header log read"
        End 1
    End If

    If ContainsText(logTextBadHeader, "HEADER INVALID") = 0 Then
        Print "FAIL call dll policy-file missing-header log text | "; logTextBadHeader
        End 1
    End If

    Kill badHeaderPolicyPath
    ExecSetFfiPolicyPath policyPath

    Dim srcDllPathSegments As String
    srcDllPathSegments = _
        "a = 31" & Chr(10) & _
        "CALL(DLL, ""../evil.dll"", ""BlockedProc"", I32, a)"

    Dim segErr As String
    If RunProgramExpectExecFail(srcDllPathSegments, segErr) = 0 Then
        Print "FAIL call dll path-segments expected fail | "; segErr
        End 1
    End If

    If ContainsText(segErr, "9207") = 0 Then
        Print "FAIL call dll path-segments code | "; segErr
        End 1
    End If

    Dim srcDllAbsPath As String
    srcDllAbsPath = _
        "a = 32" & Chr(10) & _
        "CALL(DLL, ""C:/Windows/System32/kernel32.dll"", ""GetTickCount"", I32, a)"

    Dim absErr As String
    If RunProgramExpectExecFail(srcDllAbsPath, absErr) = 0 Then
        Print "FAIL call dll absolute-path expected fail | "; absErr
        End 1
    End If

    If ContainsText(absErr, "9208") = 0 Then
        Print "FAIL call dll absolute-path code | "; absErr
        End 1
    End If

    Dim srcDllInvalidChars As String
    srcDllInvalidChars = _
        "a = 33" & Chr(10) & _
        "CALL(DLL, ""evil|dll"", ""BlockedProc"", I32, a)"

    Dim charsErr As String
    If RunProgramExpectExecFail(srcDllInvalidChars, charsErr) = 0 Then
        Print "FAIL call dll invalid-chars expected fail | "; charsErr
        End 1
    End If

    If ContainsText(charsErr, "9209") = 0 Then
        Print "FAIL call dll invalid-chars code | "; charsErr
        End 1
    End If

    ExecSetFfiPolicyPath defaultPolicyPath
    Kill enforcePolicyPath
    Kill policyPath

    ExecSetFfiPolicyMode "REPORT_ONLY"

    Kill logPath

    If ok = 0 Then End 1

    Print "PASS call exec"
    End 0
End Sub

Main
