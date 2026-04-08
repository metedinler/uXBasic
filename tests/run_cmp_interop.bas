#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/build/interop_manifest.fbs"

Private Function LocalFileExistsPath(ByRef pathText As String) As Integer
    Return Dir(pathText) <> ""
End Function

Private Function CsvContainsToken(ByRef csvPath As String, ByRef tokenText As String) As Integer
    If LocalFileExistsPath(csvPath) = 0 Then Return 0

    Dim f As Integer
    f = FreeFile
    Open csvPath For Input As #f
    If Err <> 0 Then Return 0

    Dim hit As Integer
    hit = 0

    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        If InStr(1, lineText, tokenText) > 0 Then
            hit = 1
            Exit Do
        End If
    Loop

    Close #f
    Return hit
End Function

Private Sub Main()
    Dim srcPath As String
    srcPath = "tests\fixtures\interop\root.bas"

    Dim m As InteropManifest
    Dim errText As String

    If ResolveInteropManifestForSource(srcPath, m, errText) = 0 Then
        Print "FAIL CMP-LIB-INCLUDE-WIN11 | resolve failed | "; errText
        End 1
    End If

    If m.includeCount <> 2 Then
        Print "FAIL CMP-LIB-INCLUDE-WIN11 | include-once expected 2 got"; m.includeCount
        End 1
    End If

    If m.importCount <> 3 Then
        Print "FAIL CMP-IMP-WIN11 | import expected 3 got"; m.importCount
        End 1
    End If

    If EmitInteropArtifacts(m, "dist\cmp_interop", errText) = 0 Then
        Print "FAIL CMP-IMP-WIN11 | emit failed | "; errText
        End 1
    End If

    Dim manifestPath As String
    manifestPath = "dist\cmp_interop\import_build_manifest.csv"

    Dim rspPath As String
    rspPath = "dist\cmp_interop\import_link_args.rsp"

    If LocalFileExistsPath(manifestPath) = 0 Then
        Print "FAIL CMP-IMP-WIN11 | missing import_build_manifest.csv"
        End 1
    End If

    If LocalFileExistsPath(rspPath) = 0 Then
        Print "FAIL CMP-IMP-WIN11 | missing import_link_args.rsp"
        End 1
    End If

    If CsvContainsToken(manifestPath, "IMPORT") = 0 Then
        Print "FAIL CMP-IMP-WIN11 | no IMPORT rows in manifest"
        End 1
    End If

    If CsvContainsToken(manifestPath, "INCLUDE") = 0 Then
        Print "FAIL CMP-LIB-INCLUDE-WIN11 | no INCLUDE rows in manifest"
        End 1
    End If

    Print "PASS CMP-LIB-INCLUDE-WIN11"
    Print "PASS CMP-IMP-WIN11"
    End 0
End Sub

Main()
