#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Function AssertTextEq(ByRef actualText As String, ByRef expectedText As String, ByRef msg As String) As Integer
    If actualText <> expectedText Then
        Print "FAIL "; msg; " expected='"; expectedText; "' actual='"; actualText; "'"
        Return 0
    End If
    Return 1
End Function

Private Function LoadPrintItemOps(ByRef ps As ParseState, ByVal printOrdinal As Integer, ops() As String, ByRef opCount As Integer, ByRef errOut As String) As Integer
    Dim targetPrintNode As Integer
    targetPrintNode = -1

    Dim foundCount As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "PRINT_STMT" Then
            If foundCount = printOrdinal Then
                targetPrintNode = i
                Exit For
            End If
            foundCount += 1
        End If
    Next i

    If targetPrintNode = -1 Then
        errOut = "print statement not found"
        Return 0
    End If

    opCount = 0
    Dim childNode As Integer
    childNode = ps.ast.nodes(targetPrintNode).firstChild

    Do While childNode <> -1
        Dim itemNode As ASTNode
        itemNode = ps.ast.nodes(childNode)

        If UCase(itemNode.kind) <> "PRINT_ITEM" Then
            errOut = "unexpected PRINT child kind: " & itemNode.kind
            Return 0
        End If

        If itemNode.left = -1 Then
            errOut = "PRINT_ITEM expression missing"
            Return 0
        End If

        If opCount = 0 Then
            ReDim ops(0)
        Else
            ReDim Preserve ops(opCount)
        End If
        ops(opCount) = itemNode.op
        opCount += 1

        childNode = ps.ast.nodes(childNode).nextSibling
    Loop

    Return 1
End Function

Private Sub Main()
    Dim src As String
    src = _
        "PRINT 1, 2; 3" & Chr(10) & _
        "PRINT 4;" & Chr(10) & _
        "PRINT 5," & Chr(10) & _
        "POKED 7100, 1"

    Dim ps As ParseState
    Dim errText As String
    If RTParseProgram(src, ps, errText) = 0 Then
        Print "FAIL parse | "; errText
        End 1
    End If

    Dim ok As Integer
    ok = 1

    Dim ops(Any) As String
    Dim opCount As Integer

    If LoadPrintItemOps(ps, 0, ops(), opCount, errText) = 0 Then
        Print "FAIL print(0) | "; errText
        End 1
    End If
    ok And= RTAssertEq(opCount, 3, "PRINT 1 child count")
    ok And= AssertTextEq(ops(0), ",", "PRINT 1 item 1 sep")
    ok And= AssertTextEq(ops(1), ";", "PRINT 1 item 2 sep")
    ok And= AssertTextEq(ops(2), "", "PRINT 1 item 3 sep")

    If LoadPrintItemOps(ps, 1, ops(), opCount, errText) = 0 Then
        Print "FAIL print(1) | "; errText
        End 1
    End If
    ok And= RTAssertEq(opCount, 1, "PRINT 2 child count")
    ok And= AssertTextEq(ops(0), ";", "PRINT 2 trailing sep")

    If LoadPrintItemOps(ps, 2, ops(), opCount, errText) = 0 Then
        Print "FAIL print(2) | "; errText
        End 1
    End If
    ok And= RTAssertEq(opCount, 1, "PRINT 3 child count")
    ok And= AssertTextEq(ops(0), ",", "PRINT 3 trailing sep")

    If RTExecProgram(ps, errText) = 0 Then
        Print "FAIL exec | "; errText
        End 1
    End If

    ok And= RTAssertEq(VMemPeekD(7100), 1, "PRINT continuation after trailing separators")

    If ok = 0 Then End 1

    Print "PASS print exec AST"
    End 0
End Sub

Main
