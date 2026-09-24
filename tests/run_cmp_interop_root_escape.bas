#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/build/interop_manifest.fbs"

Private Sub Main()
    Dim srcPath As String
    srcPath = "tests\fixtures\interop\escape_root.bas"

    Dim m As InteropManifest
    Dim errText As String

    If ResolveInteropManifestForSource(srcPath, m, errText) <> 0 Then
        Print "FAIL CMP-IMP-ROOT-ESCAPE-WIN11 | resolve should fail"
        End 1
    End If

    If InStr(UCase(errText), "ESCAPES ROOT") = 0 Then
        Print "FAIL CMP-IMP-ROOT-ESCAPE-WIN11 | wrong error | "; errText
        End 1
    End If

    Print "PASS CMP-IMP-ROOT-ESCAPE-WIN11"
    End 0
End Sub

Main()
