#include once "runtime/diagnostics.fbs"
#include once "runtime/hook_trace.fbs"
#include once "runtime/console_output.fbs"
#include "parser/token_kinds.fbs"
#include "parser/lexer.fbs"
#include "parser/ast.fbs"
#include "parser/ast_contract.fbs"
#include "parser/parser.fbs"
#include "semantic/hir.fbs"
#include "semantic/mir.fbs"
#include "semantic/semantic_pass.fbs"
#include "build/interop_manifest.fbs"
#include "codegen/x64/code_generator.fbs"
#include "codegen/x86/code_generator.fbs"
#include "build/main_runtime_include_bundle.fbs"
#include "codegen/x64/ffi_call_backend.fbs"
#include "codegen/x86/ffi_call_backend.fbs"
#include "codegen/x64/inline_backend.fbs"
#include "build/x64_build_pipeline.fbs"

Private Function HasArg(ByRef keyText As String) As Integer
    Dim keyLower As String
    keyLower = LCase(Trim(keyText))

    Dim i As Integer
    For i = 1 To 64
        Dim a As String
        a = Command(i)
        If a = "" Then Exit For

        Dim aLower As String
        aLower = LCase(Trim(a))
        If aLower = keyLower Then Return 1

        Dim eqPos As Integer
        eqPos = InStr(aLower, "=")
        If eqPos > 0 Then
            If Left(aLower, eqPos - 1) = keyLower Then Return 1
        End If
    Next i
    Return 0
End Function

Private Function GetArgValue(ByRef keyText As String, ByRef valueOut As String) As Integer
    Dim keyLower As String
    keyLower = LCase(Trim(keyText))

    Dim i As Integer
    For i = 1 To 64
        Dim a As String
        a = Command(i)
        If a = "" Then Exit For

        Dim aTrim As String
        aTrim = Trim(a)
        Dim aLower As String
        aLower = LCase(aTrim)

        If aLower = keyLower Then
            valueOut = Command(i + 1)
            Return IIf(valueOut <> "", 1, 0)
        End If

        Dim eqPos As Integer
        eqPos = InStr(aTrim, "=")
        If eqPos > 0 Then
            Dim leftKey As String
            leftKey = LCase(Trim(Left(aTrim, eqPos - 1)))
            If leftKey = keyLower Then
                valueOut = Mid(aTrim, eqPos + 1)
                Return IIf(valueOut <> "", 1, 0)
            End If
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
    If k = "--mir-verify-json-out" Then Return 1
    If k = "--mir-full-json-out" Then Return 1
    If k = "--ast-json-out" Then Return 1
    If k = "--ast-contract-json-out" Then Return 1
    If k = "--ast-contract-report-json-out" Then Return 1
    If k = "--hir-json-out" Then Return 1
    If k = "--build-x64-out" Then Return 1
    If k = "--interpreter-backend" Then Return 1
    If k = "--codegen-source" Then Return 1
    If k = "--artifact-report-json-out" Then Return 1
    If k = "--validate-all-report-json-out" Then Return 1
    If k = "--log-out" Then Return 1
    If k = "--debug-log-out" Then Return 1
    If k = "--session-live-json-out" Then Return 1
    If k = "--layer-timing-json-out" Then Return 1
    If k = "--console-mode" Then Return 1
    If k = "--program-output-out" Then Return 1
    If k = "--program-output-json-out" Then Return 1
    If k = "--final-screen-json-out" Then Return 1
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
    sourcePathOut = ""

    ' Explicit source key has highest priority.
    If GetArgValue("--source", sourcePathOut) <> 0 Then
        If Trim(sourcePathOut) <> "" Then Return 1
    End If
    If GetArgValue("-s", sourcePathOut) <> 0 Then
        If Trim(sourcePathOut) <> "" Then Return 1
    End If

    ' Prefer the first non-option token that resolves to an existing path.
    Dim firstCandidate As String
    firstCandidate = ""

    Dim i As Integer
    i = 1
    Do While i <= 64
        Dim a As String
        a = Command(i)
        If a = "" Then Exit Do

        If IsOptionLike(a) <> 0 Then
            If IsValueArgKey(a) <> 0 Then i += 1
        Else
            If firstCandidate = "" Then firstCandidate = a
            If Dir(a) <> "" Then
                sourcePathOut = a
                Return 1
            End If
        End If

        i += 1
    Loop

    If firstCandidate <> "" Then
        sourcePathOut = firstCandidate
        Return 1
    End If

    errText = "source file path not provided"
    Return 0
End Function

Private Function LocalizeErrorMessage(ByRef rawText As String) As String
    Dim localized As String
    localized = UxbYerellestirHata(rawText)

    If Trim(localized) = "" Then localized = "Isletim hatasi"
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
#include once "main_program_entry.fbs"
