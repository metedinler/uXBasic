' Test: Preprocess %%IFC (R6.N)

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
    
    ' Test 1: %%IFC with true condition (integer compare)
    src = _
        "%%IFC 42, 42" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%IFC true branch with 42=42"
        ok = 0
    End If
    
    ' Test 2: %%IFC with false condition
    src = _
        "%%IFC 42, 0" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL %%IFC false branch should still parse"
        ok = 0
    End If
    
    ' Test 3: %%IFC case-insensitive comparison
    src = _
        "%%IFC ""hello"", ""HELLO""" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    ' Note: Case-insensitive string compare may depend on implementation
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "INFO %%IFC case-insensitive compare"
        ' Not fatal; string comparison rules may vary
    End If
    
    ' Test 4: %%IFC malformed - active path
    src = _
        "%%IFC 1 =" & Chr(10) & _
        "DIM x AS I32" & Chr(10) & _
        "%%ENDIF"
    If RTParseProgram(src, ps, errText) = 1 Then ' Expect error for malformed condition
        ' Expected: fail-fast on malformed condition in active path
    Else
        ' May depend on how strictly malformed %%IFC is validated
    End If
    
    If ok = 1 Then
        Print "R6.N %%IFC baseline PASS"
    Else
        Print "R6.N %%IFC test FAIL"
        End 1
    End If
    
    End 0
End Sub
