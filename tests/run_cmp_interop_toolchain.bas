#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/build/interop_manifest.fbs"

Private Function LocalFileExistsPath(ByRef pathText As String) As Integer
    Return Dir(pathText) <> ""
End Function

Private Function FileContainsText(ByRef filePath As String, ByRef needle As String) As Integer
    If LocalFileExistsPath(filePath) = 0 Then Return 0

    Dim f As Integer
    f = FreeFile
    Open filePath For Input As #f
    If Err <> 0 Then Return 0

    Dim hit As Integer
    hit = 0

    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        If InStr(1, lineText, needle) > 0 Then
            hit = 1
            Exit Do
        End If
    Loop

    Close #f
    Return hit
End Function

Private Sub Main()
    Dim srcPath As String
    srcPath = "tests\fixtures\interop\root_toolchain.bas"

    Dim m As InteropManifest
    Dim errText As String

    If ResolveInteropManifestForSource(srcPath, m, errText) = 0 Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | resolve failed | "; errText
        End 1
    End If

    If UCase(m.toolchain.cc) <> "CLANG" Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | expected inline cc=clang got "; m.toolchain.cc
        End 1
    End If

    If UCase(m.toolchain.linker) <> "CLANG" Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | expected inline link=clang got "; m.toolchain.linker
        End 1
    End If

    If EmitInteropArtifacts(m, "dist\cmp_interop_toolchain", errText) = 0 Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | emit failed | "; errText
        End 1
    End If

    Dim envPath As String
    envPath = "dist\cmp_interop_toolchain\toolchain.env.bat"

    Dim buildBatPath As String
    buildBatPath = "dist\cmp_interop_toolchain\build_import.bat"

    Dim linkBatPath As String
    linkBatPath = "dist\cmp_interop_toolchain\link_command.bat"

    If LocalFileExistsPath(envPath) = 0 Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | missing toolchain.env.bat"
        End 1
    End If

    If FileContainsText(envPath, "set UXB_CC=clang") = 0 Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | env file missing UXB_CC=clang"
        End 1
    End If

    If FileContainsText(buildBatPath, "%UXB_CC_CMD% -c") = 0 Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | build script not using UXB_CC_CMD"
        End 1
    End If

    If FileContainsText(linkBatPath, "%UXB_LINK_CMD% @") = 0 Then
        Print "FAIL CMP-TOOLCHAIN-WIN11 | link script not using UXB_LINK_CMD"
        End 1
    End If

    Print "PASS CMP-TOOLCHAIN-WIN11"
    End 0
End Sub

Main()
