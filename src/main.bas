#include "parser/token_kinds.fbs"
#include "parser/lexer.fbs"
#include "parser/ast.fbs"
#include "parser/parser.fbs"
#include "build/interop_manifest.fbs"
#include "runtime/timer.fbs"
#include "runtime/diagnostics.fbs"
#include "runtime/memory_vm.fbs"
#include "runtime/memory_exec.fbs"
#include "legacy/get_commands_port.fbs"

Private Function HasArg(ByRef keyText As String) As Integer
    Dim i As Integer
    For i = 1 To 16
        Dim a As String
        a = Command(i)
        If a = "" Then Exit For
        If LCase(a) = LCase(keyText) Then Return 1
    Next i
    Return 0
End Function

Private Function YerellestirHata(ByRef rawText As String) As String
    Dim u As String
    u = UCase(rawText)

    If Instr(u, "UNSUPPORTED CALL") > 0 Then Return "Desteklenmeyen cagir" 
    If Instr(u, "ARG MISSING") > 0 Then Return "Eksik parametre"
    If Instr(u, "OUT OF RANGE") > 0 Then Return "Aralik disi erisim"
    If Instr(u, "DIVISION BY ZERO") > 0 Then Return "Sifira bolme hatasi"
    If Instr(u, "MODULO BY ZERO") > 0 Then Return "Sifira gore mod alma hatasi"
    If Instr(u, "OPEN FAILED") > 0 Then Return "Dosya acma hatasi"
    If Instr(u, "CLOSE FAILED") > 0 Then Return "Dosya kapatma hatasi"
    If Instr(u, "GET FAILED") > 0 Then Return "Dosya okuma hatasi"
    If Instr(u, "PUT FAILED") > 0 Then Return "Dosya yazma hatasi"
    If Instr(u, "SEEK FAILED") > 0 Then Return "Dosya konumlama hatasi"
    If Instr(u, "PARSE") > 0 Then Return "Sozdizimi cozumleme hatasi"
    If Instr(u, "INVALID") > 0 Then Return "Gecersiz deger"

    Return "Isletim hatasi"
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
        textOut &= lineText
        If Not Eof(f) Then textOut &= Chr(10)
    Loop

    Close #f
    Return 1
End Function

Dim As String sourceText
Dim As String sourcePath
Dim As Integer debugMode

DiagInit

debugMode = HasArg("--debug") Or HasArg("--ayikla")
DiagBilgi "uXBasic calistirildi"

sourcePath = Command(1)
If sourcePath <> "" Then
    If LoadTextFile(sourcePath, sourceText) = 0 Then
        DiagHata "Kaynak dosya okunamadi: " & sourcePath
        End 2
    End If
Else
    DiagHata "Kaynak dosya yolu verilmedi"
    End 2
End If

Dim As LexerState st
LexerInit st, sourceText

If debugMode Then
    DiagBilgi "Token sayisi: " & Str(st.tokens.count)
End If

Dim As ParseState ps
ParserInit ps, st

If ParseProgram(ps) = 0 Then
    DiagHata "Ayristirma basarisiz: " & YerellestirHata(ps.lastError)
    End 1
End If

If debugMode Then
    DiagBilgi "Ayristirma basarili. AST dugum sayisi: " & Str(ps.ast.count)
    ASTDump ps.ast, ps.rootNode
End If

If LCase(Command(2)) = "--execmem" Then
    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) = 0 Then
        DiagHata "Bellek yurutme basarisiz: " & YerellestirHata(execErr)
        End 5
    End If
    DiagBilgi "Bellek yurutme basarili"
End If

If sourcePath <> "" Then
    Dim manifest As InteropManifest
    Dim interopErr As String

    If ResolveInteropManifestForSource(sourcePath, manifest, interopErr) = 0 Then
        DiagHata "Baglanti cozumleme basarisiz: " & YerellestirHata(interopErr)
        End 3
    End If

    If EmitInteropArtifacts(manifest, "dist\interop", interopErr) = 0 Then
        DiagHata "Baglanti cikti yazimi basarisiz: " & YerellestirHata(interopErr)
        End 4
    End If

    If debugMode Then
        DiagBilgi "Interop include sayisi: " & Str(manifest.includeCount)
        DiagBilgi "Interop import sayisi: " & Str(manifest.importCount)
    End If
End If

Dim As String selected
Dim As Integer n
n = LegacyGetCommands(sourceText, 0, selected)
If debugMode Then
    DiagBilgi "Legacy ayrim sayisi: " & Str(n)
    DiagBilgi "Legacy parcasi[0]: " & selected
    DiagBilgi "Zaman(ornek ms): " & Str(TimerNow("ms"))
End If

End 0