' Test: Preprocess Directives - %%IF, %%ENDIF (Basic infrastructure)

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
    
    ' Test 1: Basic %%IF...%%ENDIF
    src = _
        "%%IF 1" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL basic %%IF true"
        ok = 0
    End If
    
    ' Test 2: %%ELSE branch
    src = _
        "%%IF 0" & Chr(10) & _
        "DIM x AS INVALID" & Chr(10) & _
        "%%ELSE" & Chr(10) & _
        "DIM y AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%IF %%ELSE branch"
        ok = 0
    End If
    
    ' Test 3: Nested %%IF
    src = _
        "%%IF 1" & Chr(10) & _
        "%%IF 1" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL nested %%IF"
        ok = 0
    End If
    
    If ok = 1 Then
        Print "Preprocess %%IF/%%ELSE/%%ENDIF baseline PASS"
    Else
        Print "Preprocess test FAIL"
        End 1
    End If
    
    End 0
End Sub
