' Test: Preprocess Meta Directives - %%PLATFORM, %%DESTOS, %%NOZEROVARS, %%SECSTACK

#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim src As String
    Dim ps As ParseState
    Dim errText As String
    Dim ok As Integer

    ok = 1

    Dim hostName As String
#Ifdef __FB_WIN32__
    hostName = "WINDOWS"
#ElseIf defined(__FB_WIN64__)
    hostName = "WINDOWS"
#ElseIf defined(__FB_LINUX__)
    hostName = "LINUX"
#ElseIf defined(__FB_DARWIN__)
    hostName = "MACOS"
#Else
    hostName = "UNKNOWN"
#EndIf

    src = _
        "%%PLATFORM " & hostName & Chr(10) & _
        "DIM x AS I32"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%PLATFORM host match"
        ok = 0
    End If

    src = _
        "%%PLATFORM __MISMATCH__" & Chr(10) & _
        "DIM x AS I32"
    If RTParseExpectFail(src, "%%PLATFORM mismatch", errText) = 0 Then
        Print "FAIL %%PLATFORM mismatch fail-fast | "; errText
        ok = 0
    End If

    src = _
        "%%NOZEROVARS ON" & Chr(10) & _
        "%%SECSTACK OFF" & Chr(10) & _
        "%%IFC NOZEROVARS, 1" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF" & Chr(10) & _
        "%%IFC SECSTACK, 0" & Chr(10) & _
        "DIM y AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%NOZEROVARS/%%SECSTACK macro flow"
        ok = 0
    End If

    src = _
        "%%DESTOS WINDOWS" & Chr(10) & _
        "%%IFC DESTOS, WINDOWS" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%DESTOS macro binding"
        ok = 0
    End If

    src = _
        "%%NOZEROVARS MAYBE" & Chr(10) & _
        "DIM x AS I32"
    If RTParseExpectFail(src, "%%NOZEROVARS expects ON/OFF/1/0", errText) = 0 Then
        Print "FAIL %%NOZEROVARS invalid value fail-fast | "; errText
        ok = 0
    End If

    src = _
        "%%SECSTACK MAYBE" & Chr(10) & _
        "DIM x AS I32"
    If RTParseExpectFail(src, "%%SECSTACK expects ON/OFF/1/0", errText) = 0 Then
        Print "FAIL %%SECSTACK invalid value fail-fast | "; errText
        ok = 0
    End If

    If ok = 1 Then
        Print "PASS preprocess meta directives"
        End 0
    Else
        Print "FAIL preprocess meta directives"
        End 1
    End If
End Sub

Main
