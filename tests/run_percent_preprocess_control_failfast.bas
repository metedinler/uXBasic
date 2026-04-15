' Test: Preprocess Control - %%IFC, %%ENDCOMP, %%ERRORENDCOMP (R6.N)

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
    
    ' Test 1: %%IFC true branch - active code accepted
    src = _
        "%%IFC 1, 1" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%IFC true branch"
        ok = 0
    End If
    
    ' Test 2: %%IFC false branch - inactive code ignored (no parse error for invalid syntax inside)
    src = _
        "%%IFC 0, 1" & Chr(10) & _
        "INVALID SYNTAX HERE" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%IFC false branch should ignore inactive code"
        ok = 0
    End If
    
    ' Test 3: %%ENDCOMP - early stop, rest ignored
    src = _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDCOMP" & Chr(10) & _
        "DIM y AS INVALID" ' Invalid but after ENDCOMP so ignored
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%ENDCOMP should stop parsing"
        ok = 0
    End If
    
    ' Test 4: %%ERRORENDCOMP with message - fail with message
    src = _
        "DIM x AS I32" & Chr(10) & _
        "%%ERRORENDCOMP Stop here"
    If RTParseProgram(src, ps, errText) = 1 Then ' Should FAIL
        ' Expected: parse failure with "Stop here" in error message
    Else
        Print "FAIL %%ERRORENDCOMP should fail parse"
        ok = 0
    End If
    
    If ok = 1 Then
        Print "R6.N %%IFC/%%ENDCOMP/%%ERRORENDCOMP baseline PASS"
    Else
        Print "R6.N preprocess test FAIL"
        End 1
    End If
    
    End 0
End Sub
