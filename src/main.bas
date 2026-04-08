#include "parser/token_kinds.fbs"
#include "parser/lexer.fbs"
#include "parser/ast.fbs"
#include "parser/parser.fbs"
#include "build/interop_manifest.fbs"
#include "runtime/timer.fbs"
#include "runtime/memory_vm.fbs"
#include "legacy/get_commands_port.fbs"

Sub PrintBanner()
    Print "uXbasic bootstrap (FreeBASIC)"
    Print "Phase: lexer/parser skeleton"
End Sub

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

sourcePath = Command(1)
If sourcePath <> "" Then
    If LoadTextFile(sourcePath, sourceText) = 0 Then
        Print "Cannot read source file:"; sourcePath
        End 2
    End If
Else
    sourceText = "PRINT 1 + 2 : IF a = 1 THEN b += 2 ELSE b =- 1 END IF"
End If

PrintBanner()

Dim As LexerState st
LexerInit st, sourceText

Print "Token count:"; st.tokens.count
Dim As Integer i
For i = 0 To st.tokens.count - 1
    Print i; "|"; st.tokens.items(i).kind; "|"; st.tokens.items(i).lexeme
Next i

Dim As ParseState ps
ParserInit ps, st

If ParseProgram(ps) = 0 Then
    Print "Parse failed: "; ps.lastError
    End 1
End If

Print "Parse ok."
Print "AST nodes:"; ps.ast.count
ASTDump ps.ast, ps.rootNode

If sourcePath <> "" Then
    Dim manifest As InteropManifest
    Dim interopErr As String

    If ResolveInteropManifestForSource(sourcePath, manifest, interopErr) = 0 Then
        Print "Interop resolve failed:"; interopErr
        End 3
    End If

    If EmitInteropArtifacts(manifest, "dist\interop", interopErr) = 0 Then
        Print "Interop emit failed:"; interopErr
        End 4
    End If

    Print "Interop include count:"; manifest.includeCount
    Print "Interop import count:"; manifest.importCount
End If

Dim As String selected
Dim As Integer n
n = LegacyGetCommands(sourceText, 0, selected)
Print "Legacy split count:"; n
Print "Legacy part[0]:"; selected
Print "Timer(ms) sample:"; TimerNow("ms")

End 0