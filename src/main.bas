#include once "runtime/diagnostics.fbs"
#include "parser/token_kinds.fbs"
#include "parser/lexer.fbs"
#include "parser/ast.fbs"
#include "parser/parser.fbs"
#include "semantic/hir.fbs"
#include "semantic/mir.fbs"
#include "semantic/semantic_pass.fbs"
#include "build/interop_manifest.fbs"
#include "codegen/x64/code_generator.fbs"
#include "build/main_runtime_include_bundle.fbs"
#include "codegen/x64/ffi_call_backend.fbs"
#include "codegen/x86/ffi_call_backend.fbs"
#include "codegen/x64/inline_backend.fbs"
#include "build/x64_build_pipeline.fbs"

Private Function HasArg(ByRef keyText As String) As Integer
    Dim i As Integer
    For i = 1 To 64
        Dim a As String
        a = Command(i)
        If a = "" Then Exit For
        If LCase(a) = LCase(keyText) Then Return 1
    Next i
    Return 0
End Function

Private Function GetArgValue(ByRef keyText As String, ByRef valueOut As String) As Integer
    Dim i As Integer
    For i = 1 To 64
        Dim a As String
        a = Command(i)
        If a = "" Then Exit For
        If LCase(a) = LCase(keyText) Then
            valueOut = Command(i + 1)
            Return IIf(valueOut <> "", 1, 0)
        End If
    Next i
    valueOut = ""
    Return 0
End Function

Private Function IsValueArgKey(ByRef keyText As String) As Integer
    Dim k As String
    k = LCase(Trim(keyText))
    If k = "--emit-x64-nasm-out" Then Return 1
    If k = "--x64gen-out" Then Return 1
    If k = "--ir-json-out" Then Return 1
    If k = "--inventory-json-out" Then Return 1
    If k = "--pipeline-json-out" Then Return 1
    If k = "--mir-pipeline-json-out" Then Return 1
    If k = "--mir-opcodes-json-out" Then Return 1
    If k = "--mir-surface-json-out" Then Return 1
    If k = "--ast-json-out" Then Return 1
    If k = "--hir-json-out" Then Return 1
    If k = "--build-x64-out" Then Return 1
    If k = "--interpreter-backend" Then Return 1
    If k = "--codegen-source" Then Return 1
    If k = "--artifact-report-json-out" Then Return 1
    If k = "--validate-all-report-json-out" Then Return 1
    If k = "--source" Then Return 1
    If k = "-s" Then Return 1

    Return 0
End Function

Private Function IsOptionLike(ByRef argText As String) As Integer
    Dim t As String
    t = Trim(argText)
    If Len(t) >= 2 And Left(t, 2) = "--" Then Return 1
    If Len(t) >= 1 And Left(t, 1) = "-" Then Return 1
    Return 0
End Function

Private Function TryGetSourcePath(ByRef sourcePathOut As String, ByRef errText As String) As Integer
    Dim i As Integer
    i = 1
    Do While i <= 64
        Dim a As String
        a = Command(i)
        If a = "" Then Exit Do

        If IsOptionLike(a) <> 0 Then
            If IsValueArgKey(a) <> 0 Then i += 1
        Else
            sourcePathOut = a
            Return 1
        End If

        i += 1
    Loop

    errText = "source file path not provided"
    Return 0
End Function

Private Function LocalizeErrorMessage(ByRef rawText As String) As String
    Dim localized As String
    localized = UxbYerellestirHata(rawText)

    If localized = "Isletim hatasi" Then
        Return rawText
    End If

    Return localized & " | ham: " & rawText
End Function

Private Function LoadTextFile(ByRef filePath As String, ByRef textOut As String) As Integer
    Dim f As Integer
    f = FreeFile

    Open filePath For Input As #f
    If Err <> 0 Then Return 0

    textOut = ""
    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        textOut &= lineText & Chr(13) & Chr(10)
    Loop

    Close #f
    Return 1
End Function

Private Function SaveTextFile(ByRef filePath As String, ByRef textIn As String) As Integer
    Dim f As Integer
    f = FreeFile

    Open filePath For Output As #f
    If Err <> 0 Then Return 0

    Print #f, textIn;
    Close #f
    Return 1
End Function

Private Function JsonEscape(ByRef rawText As String) As String
    Dim outText As String
    outText = ""

    Dim i As Integer
    For i = 1 To Len(rawText)
        Dim ch As String
        ch = Mid(rawText, i, 1)
        Select Case ch
        Case "\\"
            outText &= "\\\\"
        Case Chr(34)
            outText &= "\\" & Chr(34)
        Case Chr(13)
            outText &= "\\r"
        Case Chr(10)
            outText &= "\\n"
        Case Chr(9)
            outText &= "\\t"
        Case Else
            outText &= ch
        End Select
    Next i

    Return outText
End Function

'' Helper: detect whether a given input file appears to be a test harness
Private Function IsHarnessSource(ByRef textIn As String) As Integer
    If Trim(textIn) = "" Then Return 0
    Dim up As String
    up = UCase(textIn)
    If InStr(up, "RTPARSEPROGRAM(") > 0 Then Return 1
    If InStr(up, "RTEXECPROGRAM(") > 0 Then Return 1
    If InStr(up, "RTPARSEPROGRAM ") > 0 Then Return 1
    If InStr(up, "RTEXECPROGRAM ") > 0 Then Return 1
    ' heuristic: many harnesses build a `src` string
    If InStr(up, "SRC =") > 0 Then Return 1
    Return 0
End Function

'' Helper: extract inner `src` string from a harness file. Returns 1 on success
Private Function ExtractInnerSource(ByRef harnessText As String, ByRef outText As String) As Integer
    outText = ""
    If Trim(harnessText) = "" Then Return 0

    Dim up As String
    up = UCase(harnessText)

    Dim posAssign As Integer
    posAssign = InStr(up, "SRC =")
    If posAssign = 0 Then posAssign = InStr(up, "SOURCE =")
    If posAssign = 0 Then Return 0

    ' find boundary: look for RTParseProgram after assignment and limit extraction to that range
    Dim posParse As Integer
    posParse = InStr(posAssign, up, "RTPARSEPROGRAM")
    Dim subText As String
    If posParse > 0 Then
        subText = Mid(harnessText, posAssign, posParse - posAssign)
    Else
        subText = Mid(harnessText, posAssign)
    End If

    Dim idx As Integer
    idx = 1
    Dim pieces() As String
    Dim pieceCount As Integer
    pieceCount = 0

    Do
        Dim q1 As Integer
        q1 = InStr(idx, subText, Chr(34))
        If q1 = 0 Then Exit Do
        Dim q2 As Integer
        q2 = InStr(q1 + 1, subText, Chr(34))
        If q2 = 0 Then Exit Do
        Dim frag As String
        frag = Mid(subText, q1 + 1, q2 - q1 - 1)
        pieceCount += 1
        ReDim Preserve pieces(pieceCount - 1)
        pieces(pieceCount - 1) = frag

        idx = q2 + 1
    Loop

    If pieceCount = 0 Then Return 0

    ' build output inserting newlines where the between-text suggests Chr(10) or vbCrLf
    Dim i As Integer
    For i = 0 To pieceCount - 1
        outText &= pieces(i)
        If i < pieceCount - 1 Then
            ' find in-between substring in the original subText
            Dim endPos As Integer
            Dim startPos As Integer
            ' compute approximate positions by searching for the piece
            startPos = InStr(1, subText, Chr(34) & pieces(i) & Chr(34))
            If startPos > 0 Then
                endPos = startPos + Len(pieces(i)) + 1
                Dim nextPos As Integer
                nextPos = InStr(endPos + 1, subText, Chr(34) & pieces(i + 1) & Chr(34))
                Dim between As String
                If nextPos > 0 Then
                    between = Mid(subText, endPos + 1, nextPos - endPos - 1)
                Else
                    between = Mid(subText, endPos + 1, 64)
                End If
                Dim ub As String
                ub = UCase(between)
                If InStr(ub, "CHR(10)") > 0 Or InStr(ub, "CHR(13)") > 0 Or InStr(ub, "VBCRLF") > 0 Or InStr(ub, "\n") > 0 Then
                    outText &= Chr(10)
                End If
            Else
                outText &= Chr(10)
            End If
        End If
    Next i

    Return 1
End Function

Private Function BuildRunReportJson( _
    ByRef sourcePath As String, _
    ByVal semanticRan As Integer, _
    ByVal mirBuilt As Integer, _
    ByRef interpreterBackend As String, _
    ByVal execMemMode As Integer, _
    ByVal interopMode As Integer, _
    ByVal x64EmitMode As Integer, _
    ByVal codegenMode As Integer, _
    ByVal x64BuildMode As Integer, _
    ByRef codegenSourceMode As String, _
    ByRef astJsonOutPath As String, _
    ByRef inventoryJsonOutPath As String, _
    ByRef pipelineJsonOutPath As String, _
    ByRef mirOpcodesJsonOutPath As String, _
    ByRef x64OutPath As String, _
    ByRef x64BuildOutPath As String _
) As String
    Dim jsonText As String
    Dim q As String
    q = Chr(34)
    Dim execModeText As String
    execModeText = "none"
    If execMemMode <> 0 Then execModeText = LCase(interpreterBackend)

    Dim codegenRoute As String
    codegenRoute = UCase(Trim(codegenSourceMode))
    If codegenRoute = "MIR" And (x64EmitMode <> 0 Or codegenMode <> 0 Or x64BuildMode <> 0) Then
        codegenRoute = "MIR_VERIFIED_AST_EMITTER"
    End If

    jsonText = "{" & Chr(10)
    jsonText &= "  " & q & "source" & q & ": " & q & JsonEscape(sourcePath) & q & "," & Chr(10)
    jsonText &= "  " & q & "stages" & q & ": {" & Chr(10)
    jsonText &= "    " & q & "parse" & q & ": true," & Chr(10)
    jsonText &= "    " & q & "semantic" & q & ": " & IIf(semanticRan <> 0, "true", "false") & "," & Chr(10)
    jsonText &= "    " & q & "mir_build_opt" & q & ": " & IIf(mirBuilt <> 0, "true", "false") & Chr(10)
    jsonText &= "  }," & Chr(10)
    jsonText &= "  " & q & "execution" & q & ": {" & Chr(10)
    jsonText &= "    " & q & "mode" & q & ": " & q & JsonEscape(execModeText) & q & "," & Chr(10)
    jsonText &= "    " & q & "interop" & q & ": " & IIf(interopMode <> 0, "true", "false") & "," & Chr(10)
    jsonText &= "    " & q & "x64_emit" & q & ": " & IIf(x64EmitMode <> 0, "true", "false") & "," & Chr(10)
    jsonText &= "    " & q & "x64_codegen" & q & ": " & IIf(codegenMode <> 0, "true", "false") & "," & Chr(10)
    jsonText &= "    " & q & "x64_build" & q & ": " & IIf(x64BuildMode <> 0, "true", "false") & Chr(10)
    jsonText &= "  }," & Chr(10)
    jsonText &= "  " & q & "routing" & q & ": {" & Chr(10)
    jsonText &= "    " & q & "codegen_source" & q & ": " & q & JsonEscape(codegenRoute) & q & Chr(10)
    jsonText &= "  }," & Chr(10)
    jsonText &= "  " & q & "outputs" & q & ": {" & Chr(10)
    jsonText &= "    " & q & "ast_json" & q & ": " & q & JsonEscape(astJsonOutPath) & q & "," & Chr(10)
    jsonText &= "    " & q & "hir_inventory_json" & q & ": " & q & JsonEscape(inventoryJsonOutPath) & q & "," & Chr(10)
    jsonText &= "    " & q & "mir_pipeline_json" & q & ": " & q & JsonEscape(pipelineJsonOutPath) & q & "," & Chr(10)
    jsonText &= "    " & q & "mir_surface_json" & q & ": " & q & JsonEscape(mirOpcodesJsonOutPath) & q & "," & Chr(10)
    jsonText &= "    " & q & "x64_nasm" & q & ": " & q & JsonEscape(x64OutPath) & q & "," & Chr(10)
    jsonText &= "    " & q & "x64_build_dir" & q & ": " & q & JsonEscape(x64BuildOutPath) & q & Chr(10)
    jsonText &= "  }" & Chr(10)
    jsonText &= "}" & Chr(10)

    Return jsonText
End Function

Private Function BuildParseErrorReport(ByRef ps As ParseState, ByRef sourcePath As String) As String
    Dim reportText As String
    reportText = "uXBasic parse error report" & Chr(13) & Chr(10)
    reportText &= "source: " & sourcePath & Chr(13) & Chr(10)
    reportText &= "error_count: " & LTrim(Str(ps.parseErrorCount)) & Chr(13) & Chr(10)
    reportText &= String(72, "-") & Chr(13) & Chr(10)

    Dim i As Integer
    For i = 0 To ps.parseErrorCount - 1
        reportText &= LTrim(Str(i + 1)) & ". " & ps.parseErrors(i) & Chr(13) & Chr(10)
    Next i

    If Trim(ps.lastError) <> "" Then
        reportText &= String(72, "-") & Chr(13) & Chr(10)
        reportText &= "summary: " & ps.lastError & Chr(13) & Chr(10)
    End If

    Return reportText
End Function

'' ParserLog removed; parser files use ParserDiag -> UxbDebug

Dim As String sourceText
Dim As String sourcePath
Dim As Integer debugMode
Dim As Integer semanticMode
Dim As Integer execMemMode
Dim As Integer interopMode
Dim As Integer x64EmitMode
Dim As Integer codegenMode
Dim As Integer x64BuildMode
Dim As Integer runSemanticPass
Dim As String x64OutPath
Dim As String x64BuildOutPath
Dim As String inventoryJsonOutPath
Dim As String pipelineJsonOutPath
Dim As String mirOpcodesJsonOutPath
Dim As String astJsonOutPath
Dim As String interpreterBackend
Dim As String runReportJsonOutPath
Dim As String codegenSourceMode
Dim As Integer validateAllMode
Dim As String validateAllReportJsonOutPath

UxbInit

debugMode = HasArg("--debug") Or HasArg("--ayikla")
Dim As Integer quietMode
Dim As Integer traceMode
Dim As Integer debugTokenDumpMode
Dim As String logOutPath
Dim As String debugLogOutPath

quietMode = IIf(HasArg("--quiet") Or HasArg("--sessiz"), 1, 0)
traceMode = IIf(HasArg("--trace"), 1, 0)
debugTokenDumpMode = IIf(HasArg("--debug-token-dump"), 1, 0)

logOutPath = ""
debugLogOutPath = ""
GetArgValue("--log-out", logOutPath)
GetArgValue("--debug-log-out", debugLogOutPath)
semanticMode = HasArg("--semantic") Or HasArg("--semantik")
execMemMode = HasArg("--execmem")
interopMode = HasArg("--interop")
x64EmitMode = HasArg("--emit-x64-nasm") Or HasArg("--x64gen")
codegenMode = HasArg("--codegen") Or HasArg("--x64")
x64BuildMode = HasArg("--build-x64")
If codegenMode Then
    x64OutPath = "dist\uxb_output.asm"
Else
    x64OutPath = "dist\uxbasic_program.nasm"
End If

x64BuildOutPath = "dist\x64build"
If GetArgValue("--build-x64-out", x64BuildOutPath) = 0 Then
    x64BuildOutPath = "dist\x64build"
End If
If GetArgValue("--emit-x64-nasm-out", x64OutPath) = 0 Then
    If GetArgValue("--x64gen-out", x64OutPath) = 0 Then
        If codegenMode Then
            x64OutPath = "dist\uxb_output.asm"
        Else
            x64OutPath = "dist\uxbasic_program.nasm"
        End If
    End If
End If

inventoryJsonOutPath = ""
If GetArgValue("--ir-json-out", inventoryJsonOutPath) = 0 Then
    If GetArgValue("--inventory-json-out", inventoryJsonOutPath) = 0 Then
        If GetArgValue("--hir-json-out", inventoryJsonOutPath) = 0 Then
            inventoryJsonOutPath = ""
        End If
    End If
End If

pipelineJsonOutPath = ""
If GetArgValue("--pipeline-json-out", pipelineJsonOutPath) = 0 Then
    If GetArgValue("--mir-pipeline-json-out", pipelineJsonOutPath) = 0 Then pipelineJsonOutPath = ""
End If

mirOpcodesJsonOutPath = ""
If GetArgValue("--mir-opcodes-json-out", mirOpcodesJsonOutPath) = 0 Then
    If GetArgValue("--mir-surface-json-out", mirOpcodesJsonOutPath) = 0 Then mirOpcodesJsonOutPath = ""
End If

astJsonOutPath = ""
If GetArgValue("--ast-json-out", astJsonOutPath) = 0 Then astJsonOutPath = ""

runReportJsonOutPath = ""
If GetArgValue("--artifact-report-json-out", runReportJsonOutPath) = 0 Then
    runReportJsonOutPath = ""
End If

validateAllMode = HasArg("--validate-all")
validateAllReportJsonOutPath = "reports\system_health_report.json"
If GetArgValue("--validate-all-report-json-out", validateAllReportJsonOutPath) = 0 Then
    validateAllReportJsonOutPath = "reports\system_health_report.json"
End If

codegenSourceMode = "AST"
Dim codegenSourceArg As String
If GetArgValue("--codegen-source", codegenSourceArg) <> 0 Then
    codegenSourceMode = UCase(Trim(codegenSourceArg))
Else
    codegenSourceMode = "AST"
End If

If codegenSourceMode <> "AST" And codegenSourceMode <> "MIR" Then
    UxbError "Gecersiz codegen source modu: " & codegenSourceMode
    End 2
End If

interpreterBackend = "AST"
Dim backendArg As String
If GetArgValue("--interpreter-backend", backendArg) <> 0 Then
    interpreterBackend = UCase(Trim(backendArg))
End If

If interpreterBackend <> "AST" And interpreterBackend <> "MIR" Then
    UxbError "Gecersiz interpreter backend: " & interpreterBackend
    End 2
End If

UxbConfigure logOutPath, debugLogOutPath, quietMode, debugMode, traceMode, debugTokenDumpMode, ""
UxbInfo "uXBasic calistirildi"

If validateAllMode <> 0 Then
    Dim validateAllCmd As String
    validateAllCmd = "powershell -NoProfile -ExecutionPolicy Bypass -File " & Chr(34) & "tools\\run_validate_all_gate.ps1" & Chr(34)
    validateAllCmd &= " -OutJson " & Chr(34) & validateAllReportJsonOutPath & Chr(34)
    validateAllCmd &= " -SkipBuild"
    If HasArg("--validate-all-fail-fast") <> 0 Then validateAllCmd &= " -FailFast"

    Dim validateAllExit As Integer
    validateAllExit = Shell(validateAllCmd)
    If validateAllExit <> 0 Then
        UxbError "validate-all quality gate basarisiz (exit=" & LTrim(Str(validateAllExit)) & ")"
        UxbError "Sistem saglik raporu: " & validateAllReportJsonOutPath
        Dim validateAllEndCode As Integer
        validateAllEndCode = IIf(validateAllExit > 0, validateAllExit, 1)
        End validateAllEndCode
    End If

    UxbInfo "validate-all quality gate PASS"
    UxbInfo "Sistem saglik raporu: " & validateAllReportJsonOutPath
    End 0
End If

If execMemMode <> 0 And interopMode <> 0 Then
    UxbError LocalizeErrorMessage("execmem and interop modes cannot be combined")
    End 2
End If

Dim sourceArgErr As String
If TryGetSourcePath(sourcePath, sourceArgErr) = 0 Then
    UxbError LocalizeErrorMessage(sourceArgErr)
    End 2
End If

If LoadTextFile(sourcePath, sourceText) = 0 Then
    UxbError "Kaynak dosya okunamadi: " & sourcePath
    End 2
End If

'-- AST extraction / harness handling
Dim extractSrcMode As Integer
extractSrcMode = HasArg("--extract-src")

Dim x64BuildSourcePath As String
x64BuildSourcePath = sourcePath

If debugMode Then UxbDebug "astJsonOut=" & astJsonOutPath
If debugMode Then UxbDebug "sourcePath=" & sourcePath
If debugMode Then UxbDebug "extractSrcMode=" & Str(extractSrcMode)
If debugMode Then UxbDebug "source length=" & Str(Len(sourceText))

' If input looks like a test harness, require explicit --extract-src
If extractSrcMode = 0 Then
    If IsHarnessSource(sourceText) <> 0 Then
        UxbError "Girdi test harness gibi gorunuyor. --extract-src kullanarak ic kaynagi cikariniz"
        End 2
    End If
Else
    Dim extracted As String
    If ExtractInnerSource(sourceText, extracted) = 0 Then
        UxbError "--extract-src: harness icinden src bulunamadi veya cikartilamadi"
        End 2
    End If
    sourceText = extracted
    If debugMode Then UxbDebug "extracted source length=" & Str(Len(sourceText))

    If x64BuildMode <> 0 Then
        Dim extractedBuildName As String
        extractedBuildName = "__uxb_extract_" & SafeBaseName(sourcePath) & ".bas"
        x64BuildSourcePath = PathDirName(sourcePath) & "\" & extractedBuildName
        If SaveTextFile(x64BuildSourcePath, sourceText) = 0 Then
            UxbError "Extracted build source yazilamadi: " & x64BuildSourcePath
            End 2
        End If
    End If
End If

Dim As LexerState st
LexerInit st, sourceText, sourcePath

    If debugMode Then
        UxbDebug "Token sayisi: " & Str(st.tokens.count)
        Dim As Integer ti
        Dim As String tokDump
        tokDump = ""
        For ti = 0 To st.tokens.count - 1
            Dim As Token tk
            tk = st.tokens.items(ti)
            Dim As String tokLine
            tokLine = "[TOK] idx=" & Str(ti) & " kind=" & tk.kind & " lexeme='" & tk.lexeme & "' ln=" & Str(tk.lineNo) & " col=" & Str(tk.colNo)
            tokDump &= tokLine & Chr(13) & Chr(10)
        Next ti
        If debugTokenDumpMode <> 0 Then
            If SaveTextFile("dist\\token_dump.txt", tokDump) <> 0 Then
                UxbInfo "Token dump yazildi: dist\\token_dump.txt"
                If debugMode Then UxbDebug "Token dump yazildi (debug): dist\\token_dump.txt"
            End If
        End If
    End If

Dim As ParseState ps
ParserInit ps, st
ps.parseDebug = debugMode

Dim parseOk As Integer
parseOk = ParseProgram(ps)
If debugMode Then UxbDebug "parse ok=" & Str(parseOk)

If parseOk = 0 Then
    If ps.parseErrorCount > 0 Then
        Dim parseReportPath As String
        parseReportPath = "dist\parse_errors.txt"

        Dim parseReportText As String
        parseReportText = BuildParseErrorReport(ps, sourcePath)

        If SaveTextFile(parseReportPath, parseReportText) <> 0 Then
            If debugMode Then UxbDebug "wrote parse report: " & parseReportPath
            UxbError "Ayristirma basarisiz: " & LocalizeErrorMessage(ps.lastError)
            UxbError "Detayli parse hatalari yazildi: " & parseReportPath
        Else
            UxbError "Ayristirma basarisiz: " & LocalizeErrorMessage(ps.lastError)
            UxbError "Detayli parse raporu yazilamadi: " & parseReportPath
        End If
        End 1
    End If

    UxbError "Ayristirma basarisiz: " & LocalizeErrorMessage(ps.lastError)
    End 1
End If

runSemanticPass = IIf(semanticMode <> 0 Or execMemMode <> 0 Or interopMode <> 0 Or x64EmitMode <> 0 Or codegenMode <> 0 Or x64BuildMode <> 0, 1, 0)

If Trim(inventoryJsonOutPath) <> "" Then runSemanticPass = 1
If interpreterBackend = "MIR" And execMemMode <> 0 Then runSemanticPass = 1

If runSemanticPass <> 0 Then
    Dim semanticErr As String
    If SemanticAnalyze(ps, semanticErr) = 0 Then
        UxbError "Anlamsal analiz basarisiz: " & LocalizeErrorMessage(semanticErr)
        End 1
    End If
End If

If debugMode Then
    UxbInfo "Ayristirma basarili. AST dugum sayisi: " & Str(ps.ast.count)
    'ASTDump ps.ast, ps.rootNode
End If

If Trim(astJsonOutPath) <> "" Then
    Dim astJsonErr As String
    Dim astJsonParent As String
    astJsonParent = PathDirName(astJsonOutPath)
    If astJsonParent <> "." Then
        If Dir(astJsonParent) = "" Then
            Dim mkCmd As String
            mkCmd = "cmd /c mkdir " & Chr(34) & astJsonParent & Chr(34)
            Shell mkCmd
        End If
    End If
    Dim astWriteOk As Integer
    astWriteOk = ASTWriteJson(ps.ast, ps.rootNode, astJsonOutPath, astJsonErr)
    If debugMode Then UxbDebug "ASTWriteJson result=" & Str(astWriteOk)
    If debugMode Then UxbDebug "astJsonErr=" & astJsonErr
    If astWriteOk = 0 Then
        UxbError "AST JSON cikti yazimi basarisiz: " & LocalizeErrorMessage(astJsonErr)
        End 14
    Else
        If debugMode Then UxbInfo "AST JSON yazildi: " & astJsonOutPath
    End If
End If

If Trim(inventoryJsonOutPath) <> "" Then
    Dim hirInv As HIRInventory
    Dim jsonErr As String

    HIRCollectInventory ps, hirInv
    If HIRWriteInventoryJson(hirInv, inventoryJsonOutPath, jsonErr) = 0 Then
        UxbError "IR/MIR/HIR envanter JSON cikti yazimi basarisiz: " & LocalizeErrorMessage(jsonErr)
        End 8
    End If

    If debugMode Then
        UxbInfo "IR/MIR/HIR envanter JSON yazildi: " & inventoryJsonOutPath
    End If
End If

If Trim(mirOpcodesJsonOutPath) <> "" Then
    Dim mirOpsErr As String
    If MIRWriteOpcodeSurfaceJson(mirOpcodesJsonOutPath, mirOpsErr) = 0 Then
        UxbError "MIR opcode JSON cikti yazimi basarisiz: " & LocalizeErrorMessage(mirOpsErr)
        End 9
    End If
End If

If Trim(pipelineJsonOutPath) <> "" Then
    Dim pipelineErr As String
    If MIRWritePipelineFlowJson(pipelineJsonOutPath, pipelineErr) = 0 Then
        UxbError "Pipeline JSON cikti yazimi basarisiz: " & LocalizeErrorMessage(pipelineErr)
        End 10
    End If
End If

Dim needMirModule As Integer
Dim mirModuleReady As Integer
needMirModule = 0
mirModuleReady = 0

If execMemMode <> 0 And interpreterBackend = "MIR" Then needMirModule = 1
If codegenSourceMode = "MIR" And (x64EmitMode <> 0 Or codegenMode <> 0 Or x64BuildMode <> 0) Then needMirModule = 1

Dim mirModule As MIRModule
If needMirModule <> 0 Then
    Dim mirBuildErr As String
    Dim mirOptErr As String

    If MIRBuildModuleFromAST(ps, mirModule, mirBuildErr) = 0 Then
        UxbError "MIR build basarisiz: " & LocalizeErrorMessage(mirBuildErr)
        End 11
    End If

    If MIROptimizeModule(mirModule, mirOptErr) = 0 Then
        UxbError "MIR optimize basarisiz: " & LocalizeErrorMessage(mirOptErr)
        End 12
    End If

    mirModuleReady = 1
End If

If execMemMode Then
    If interpreterBackend = "MIR" Then
        Dim mirRunErr As String
        Dim mirResult As MIRValue

        If mirModuleReady = 0 Then
            UxbError "MIR backend secili ama MIR module hazirlanamadi"
            End 11
        End If

        If MIRRunModule(mirModule, mirResult, mirRunErr) = 0 Then
            UxbError "MIR interpreter basarisiz: " & LocalizeErrorMessage(mirRunErr)
            End 13
        End If

        If debugMode Then
            UxbInfo "MIR backend calisti; result type=" & mirResult.valueType
        End If
    Else
        Dim execErr As String
        If ExecRunMemoryProgram(ps, execErr) = 0 Then
            UxbError "Bellek yurutme basarisiz: " & LocalizeErrorMessage(execErr)
            End 5
        End If
    End If
    UxbInfo "Bellek yurutme basarili"
End If

If interopMode Then
    Dim manifest As InteropManifest
    Dim interopErr As String

    If ResolveInteropManifestForSource(sourcePath, manifest, interopErr) = 0 Then
        UxbError "Baglanti cozumleme basarisiz: " & LocalizeErrorMessage(interopErr)
        End 3
    End If

    If EmitInteropArtifacts(manifest, "dist\interop", interopErr) = 0 Then
        UxbError "Baglanti cikti yazimi basarisiz: " & LocalizeErrorMessage(interopErr)
        End 4
    End If

    If FfiX64BackendEmitArtifacts(ps, "dist\interop", interopErr) = 0 Then
        UxbError "FFI x64 codegen cikti yazimi basarisiz: " & LocalizeErrorMessage(interopErr)
        End 4
    End If

    If FfiX86BackendEmitArtifacts(ps, "dist\interop", interopErr) = 0 Then
        UxbError "FFI x86 codegen cikti yazimi basarisiz: " & LocalizeErrorMessage(interopErr)
        End 4
    End If

    If debugMode Then
        UxbInfo "Interop include sayisi: " & Str(manifest.includeCount)
        UxbInfo "Interop import sayisi: " & Str(manifest.importCount)
    End If
End If

If x64EmitMode Then
    Dim asmText As String
    Dim codegenErr As String

    ' Route emit-only NASM generation through the same direct path used by
    ' --codegen so emit/build stay on one proven code path.
    If codegenSourceMode = "MIR" Then
        UxbInfo "Codegen route: MIR verified -> AST emitter"
    End If
    If GenerateX64Code(ps, asmText, codegenErr) = 0 Then
        UxbError "x64 NASM codegen basarisiz: " & LocalizeErrorMessage(codegenErr)
        End 6
    End If

    If SaveTextFile(x64OutPath, asmText) = 0 Then
        UxbError "x64 NASM cikti dosyasi yazilamadi: " & x64OutPath
        End 7
    End If

    If debugMode Then
        UxbInfo "x64 NASM cikti yazildi: " & x64OutPath
    End If
End If

If codegenMode Then
    Dim codegenAsmText As String
    Dim codegenAsmErr As String

    If codegenSourceMode = "MIR" Then
        UxbInfo "Codegen route: MIR verified -> AST emitter"
    End If
    If GenerateX64Code(ps, codegenAsmText, codegenAsmErr) = 0 Then
        UxbError "x64 codegen basarisiz: " & LocalizeErrorMessage(codegenAsmErr)
        End 6
    End If

    If SaveTextFile("dist\\uxb_output.asm", codegenAsmText) = 0 Then
        UxbError "x64 codegen cikti dosyasi yazilamadi: dist\\uxb_output.asm"
        End 7
    End If

    UxbInfo "x64 codegen cikti yazildi: dist\\uxb_output.asm"
End If

If x64BuildMode Then
    Dim x64BuildErr As String
    If codegenSourceMode = "MIR" Then
        UxbInfo "Build route: MIR verified -> AST emitter -> x64 pipeline"
    End If
    If X64BuildRunArtifacts(ps, x64BuildSourcePath, x64BuildOutPath, x64BuildErr) = 0 Then
        UxbError "x64 build basarisiz: " & LocalizeErrorMessage(x64BuildErr)
        End 14
    End If

    UxbInfo "x64 build tamamlandi: " & x64BuildOutPath & "\program.exe"
End If

Dim As String selected
Dim As Integer n
n = LegacyGetCommands(sourceText, 0, selected)
If debugMode Then
    UxbInfo "Legacy ayrim sayisi: " & Str(n)
    UxbInfo "Legacy parcasi[0]: " & selected
End If

If Trim(runReportJsonOutPath) <> "" Then
    Dim runReportJson As String
    runReportJson = BuildRunReportJson( _
        sourcePath, _
        runSemanticPass, _
        mirModuleReady, _
        interpreterBackend, _
        execMemMode, _
        interopMode, _
        x64EmitMode, _
        codegenMode, _
        x64BuildMode, _
        codegenSourceMode, _
        astJsonOutPath, _
        inventoryJsonOutPath, _
        pipelineJsonOutPath, _
        mirOpcodesJsonOutPath, _
        x64OutPath, _
        x64BuildOutPath _
    )

    If SaveTextFile(runReportJsonOutPath, runReportJson) = 0 Then
        UxbError "Calisma raporu JSON yazilamadi: " & runReportJsonOutPath
        End 15
    End If
End If

End 0
