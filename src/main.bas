#include "build/main_frontend_include_bundle.fbs"
#include "build/main_runtime_include_bundle.fbs"
#include "codegen/x64/ffi_call_backend.fbs"
#include "codegen/x86/ffi_call_backend.fbs"

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

Dim As String sourceText
Dim As String sourcePath
Dim As Integer debugMode
Dim As Integer semanticMode
Dim As Integer execMemMode
Dim As Integer interopMode
Dim As Integer x64EmitMode
Dim As Integer codegenMode
Dim As Integer runSemanticPass
Dim As String x64OutPath
Dim As String inventoryJsonOutPath

DiagInit

debugMode = HasArg("--debug") Or HasArg("--ayikla")
semanticMode = HasArg("--semantic") Or HasArg("--semantik")
execMemMode = HasArg("--execmem")
interopMode = HasArg("--interop")
x64EmitMode = HasArg("--emit-x64-nasm") Or HasArg("--x64gen")
codegenMode = HasArg("--codegen") Or HasArg("--x64")
If codegenMode Then
    x64OutPath = "dist\uxb_output.asm"
Else
    x64OutPath = "dist\uxbasic_program.nasm"
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
        inventoryJsonOutPath = ""
    End If
End If
DiagBilgi "uXBasic calistirildi"

If execMemMode <> 0 And interopMode <> 0 Then
    DiagHata LocalizeErrorMessage("execmem and interop modes cannot be combined")
    End 2
End If

Dim sourceArgErr As String
If TryGetSourcePath(sourcePath, sourceArgErr) = 0 Then
    DiagHata LocalizeErrorMessage(sourceArgErr)
    End 2
End If

If LoadTextFile(sourcePath, sourceText) = 0 Then
    DiagHata "Kaynak dosya okunamadi: " & sourcePath
    End 2
End If

Dim As LexerState st
LexerInit st, sourceText, sourcePath

If debugMode Then
    DiagBilgi "Token sayisi: " & Str(st.tokens.count)
End If

Dim As ParseState ps
ParserInit ps, st

If ParseProgram(ps) = 0 Then
    DiagHata "Ayristirma basarisiz: " & LocalizeErrorMessage(ps.lastError)
    End 1
End If

runSemanticPass = IIf(semanticMode <> 0 Or execMemMode <> 0 Or interopMode <> 0 Or x64EmitMode <> 0 Or codegenMode <> 0, 1, 0)

If Trim(inventoryJsonOutPath) <> "" Then runSemanticPass = 1

If runSemanticPass <> 0 Then
    Dim semanticErr As String
    If SemanticAnalyze(ps, semanticErr) = 0 Then
        DiagHata "Anlamsal analiz basarisiz: " & LocalizeErrorMessage(semanticErr)
        End 1
    End If
End If

If debugMode Then
    DiagBilgi "Ayristirma basarili. AST dugum sayisi: " & Str(ps.ast.count)
    'ASTDump ps.ast, ps.rootNode
End If

If Trim(inventoryJsonOutPath) <> "" Then
    Dim hirInv As HIRInventory
    Dim jsonErr As String

    HIRCollectInventory ps, hirInv
    If HIRWriteInventoryJson(hirInv, inventoryJsonOutPath, jsonErr) = 0 Then
        DiagHata "IR/MIR/HIR envanter JSON cikti yazimi basarisiz: " & LocalizeErrorMessage(jsonErr)
        End 8
    End If

    If debugMode Then
        DiagBilgi "IR/MIR/HIR envanter JSON yazildi: " & inventoryJsonOutPath
    End If
End If

If execMemMode Then
    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) = 0 Then
        DiagHata "Bellek yurutme basarisiz: " & LocalizeErrorMessage(execErr)
        End 5
    End If
    DiagBilgi "Bellek yurutme basarili"
End If

If interopMode Then
    Dim manifest As InteropManifest
    Dim interopErr As String

    If ResolveInteropManifestForSource(sourcePath, manifest, interopErr) = 0 Then
        DiagHata "Baglanti cozumleme basarisiz: " & LocalizeErrorMessage(interopErr)
        End 3
    End If

    If EmitInteropArtifacts(manifest, "dist\interop", interopErr) = 0 Then
        DiagHata "Baglanti cikti yazimi basarisiz: " & LocalizeErrorMessage(interopErr)
        End 4
    End If

    If FfiX64BackendEmitArtifacts(ps, "dist\interop", interopErr) = 0 Then
        DiagHata "FFI x64 codegen cikti yazimi basarisiz: " & LocalizeErrorMessage(interopErr)
        End 4
    End If

    If FfiX86BackendEmitArtifacts(ps, "dist\interop", interopErr) = 0 Then
        DiagHata "FFI x86 codegen cikti yazimi basarisiz: " & LocalizeErrorMessage(interopErr)
        End 4
    End If

    If debugMode Then
        DiagBilgi "Interop include sayisi: " & Str(manifest.includeCount)
        DiagBilgi "Interop import sayisi: " & Str(manifest.importCount)
    End If
End If

If x64EmitMode Then
    Dim asmText As String
    Dim codegenErr As String

    If X64CodegenEmitNasm(ps, asmText, codegenErr) = 0 Then
        DiagHata "x64 NASM codegen basarisiz: " & LocalizeErrorMessage(codegenErr)
        End 6
    End If

    If SaveTextFile(x64OutPath, asmText) = 0 Then
        DiagHata "x64 NASM cikti dosyasi yazilamadi: " & x64OutPath
        End 7
    End If

    If debugMode Then
        DiagBilgi "x64 NASM cikti yazildi: " & x64OutPath
    End If
End If

If codegenMode Then
    Dim codegenAsmText As String
    Dim codegenAsmErr As String

    If GenerateX64Code(ps, codegenAsmText, codegenAsmErr) = 0 Then
        DiagHata "x64 codegen basarisiz: " & LocalizeErrorMessage(codegenAsmErr)
        End 6
    End If

    If SaveTextFile("dist\uxb_output.asm", codegenAsmText) = 0 Then
        DiagHata "x64 codegen cikti dosyasi yazilamadi: dist\uxb_output.asm"
        End 7
    End If

    DiagBilgi "x64 codegen cikti yazildi: dist\uxb_output.asm"
End If

Dim As String selected
Dim As Integer n
n = LegacyGetCommands(sourceText, 0, selected)
If debugMode Then
    DiagBilgi "Legacy ayrim sayisi: " & Str(n)
    DiagBilgi "Legacy parcasi[0]: " & selected
End If

End 0