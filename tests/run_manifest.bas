#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"

Type ManifestRow
    testId As String
    feature As String
    phaseName As String
    sourceInput As String
    expected As String
    result As String
End Type

Private Sub PushField(fields() As String, ByRef count As Integer, ByRef value As String)
    If count = 0 Then
        ReDim fields(0)
    Else
        ReDim Preserve fields(count)
    End If
    fields(count) = value
    count += 1
End Sub

Private Function ParseCsvLine(ByRef lineText As String, fields() As String) As Integer
    Dim count As Integer
    Dim current As String
    Dim inQuotes As Integer
    Dim i As Integer

    count = 0
    current = ""
    inQuotes = 0

    For i = 1 To Len(lineText)
        Dim ch As String
        ch = Mid(lineText, i, 1)

        If ch = Chr(34) Then
            If inQuotes = 1 And i > 1 And Mid(lineText, i - 1, 1) = Chr(92) Then
                current &= ch
            ElseIf inQuotes = 1 And i < Len(lineText) And Mid(lineText, i + 1, 1) = Chr(34) Then
                current &= Chr(34)
                i += 1
            Else
                inQuotes = 1 - inQuotes
            End If
        ElseIf ch = "," And inQuotes = 0 Then
            PushField fields(), count, current
            current = ""
        Else
            current &= ch
        End If
    Next i

    PushField fields(), count, current
    Return count
End Function

Private Function HasToken(ByRef st As LexerState, ByRef kindName As String, ByRef lexemeText As String) As Integer
    Dim i As Integer
    For i = 0 To st.tokens.count - 1
        If UCase(st.tokens.items(i).kind) = UCase(kindName) Then
            If lexemeText = "" Then Return 1
            If st.tokens.items(i).lexeme = lexemeText Then Return 1
        End If
    Next i
    Return 0
End Function

Private Function HasAstKind(ByRef ps As ParseState, ByRef nodeKind As String) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = UCase(nodeKind) Then Return 1
    Next i
    Return 0
End Function

Private Function HasAstKindWithOp(ByRef ps As ParseState, ByRef nodeKind As String, ByRef opText As String) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = UCase(nodeKind) And ps.ast.nodes(i).op = opText Then Return 1
    Next i
    Return 0
End Function

Private Function HasCallExprValue(ByRef ps As ParseState, ByRef callName As String) As Integer
    Dim i As Integer
    For i = 0 To ps.ast.count - 1
        If UCase(ps.ast.nodes(i).kind) = "CALL_EXPR" And UCase(ps.ast.nodes(i).value) = UCase(callName) Then Return 1
    Next i
    Return 0
End Function

Private Function UnescapeBackslashQuote(ByRef textIn As String) As String
    Dim outText As String
    Dim i As Integer

    For i = 1 To Len(textIn)
        Dim ch As String
        ch = Mid(textIn, i, 1)

        If ch = Chr(92) And i < Len(textIn) And Mid(textIn, i + 1, 1) = Chr(34) Then
            outText &= Chr(34)
            i += 1
        Else
            outText &= ch
        End If
    Next i

    Return outText
End Function

Private Function EvaluateRow(ByRef row As ManifestRow, ByRef detail As String) As Integer
    Dim st As LexerState
    LexerInit st, row.sourceInput

    Dim ps As ParseState
    ParserInit ps, st

    Dim parseOk As Integer
    parseOk = ParseProgram(ps)

    Dim expectedUpper As String
    expectedUpper = UCase(row.expected)

    Dim resultOk As Integer
    resultOk = 0

    Select Case expectedUpper
    Case "PARSE_OK"
        resultOk = parseOk
        If parseOk = 0 Then detail = ps.lastError

    Case "PARSE_FAIL"
        resultOk = (parseOk = 0)
        If resultOk = 0 Then detail = "expected parse failure"

    Case "AST_POW"
        resultOk = parseOk And HasToken(st, "OP", "**")
        If resultOk = 0 Then detail = "missing ** operator token"

    Case "AST_PTR"
        resultOk = parseOk And HasToken(st, "OP", "@")
        If resultOk = 0 Then detail = "missing @ operator token"

    Case "AST_INC"
        resultOk = parseOk And HasToken(st, "OP", "++")
        If resultOk = 0 Then detail = "missing ++ operator token"

    Case "INLINE_OK"
        resultOk = parseOk And HasToken(st, "KEYWORD", "INLINE") And HasToken(st, "KEYWORD", "END")
        If resultOk = 0 Then detail = "missing INLINE/END token pattern"

    Case "UNIT_OK"
        resultOk = parseOk And HasToken(st, "KEYWORD", "TIMER") And HasToken(st, "STRING", "ms")
        If resultOk = 0 Then detail = "missing TIMER or unit literal"

    Case "AST_IF"
        resultOk = parseOk And HasAstKind(ps, "IF_STMT")
        If resultOk = 0 Then detail = "missing IF_STMT AST node"

    Case "AST_SELECT"
        resultOk = parseOk And HasAstKind(ps, "SELECT_STMT") And HasAstKind(ps, "CASE_BLOCK")
        If resultOk = 0 Then detail = "missing SELECT/CASE AST nodes"

    Case "AST_FOR"
        resultOk = parseOk And HasAstKind(ps, "FOR_STMT")
        If resultOk = 0 Then detail = "missing FOR_STMT AST node"

    Case "AST_LOOP"
        resultOk = parseOk And HasAstKind(ps, "DO_STMT")
        If resultOk = 0 Then detail = "missing DO_STMT AST node"

    Case "DIM_INIT_OK"
        resultOk = parseOk And HasAstKind(ps, "DIM_STMT") And HasAstKind(ps, "INIT_EXPR")
        If resultOk = 0 Then detail = "missing DIM_STMT/INIT_EXPR AST node"

    Case "INCLUDE_OK"
        resultOk = parseOk And HasAstKind(ps, "INCLUDE_STMT")
        If resultOk = 0 Then detail = "missing INCLUDE_STMT AST node"

    Case "IMPORT_OK"
        resultOk = parseOk And HasAstKind(ps, "IMPORT_STMT")
        If resultOk = 0 Then detail = "missing IMPORT_STMT AST node"

    Case "OPEN_OK"
        resultOk = parseOk And HasAstKind(ps, "OPEN_STMT")
        If resultOk = 0 Then detail = "missing OPEN_STMT AST node"

    Case "CLOSE_OK"
        resultOk = parseOk And HasAstKind(ps, "CLOSE_STMT")
        If resultOk = 0 Then detail = "missing CLOSE_STMT AST node"

    Case "GET_OK"
        resultOk = parseOk And HasAstKind(ps, "GET_STMT")
        If resultOk = 0 Then detail = "missing GET_STMT AST node"

    Case "PUT_OK"
        resultOk = parseOk And HasAstKind(ps, "PUT_STMT")
        If resultOk = 0 Then detail = "missing PUT_STMT AST node"

    Case "SEEK_OK"
        resultOk = parseOk And HasAstKind(ps, "SEEK_STMT")
        If resultOk = 0 Then detail = "missing SEEK_STMT AST node"

    Case "LOF_OK"
        resultOk = parseOk And HasCallExprValue(ps, "LOF")
        If resultOk = 0 Then detail = "missing LOF call expression"

    Case "EOF_OK"
        resultOk = parseOk And HasCallExprValue(ps, "EOF")
        If resultOk = 0 Then detail = "missing EOF call expression"

    Case "LOCATE_OK"
        resultOk = parseOk And HasAstKind(ps, "LOCATE_STMT")
        If resultOk = 0 Then detail = "missing LOCATE_STMT AST node"

    Case "COLOR_OK"
        resultOk = parseOk And HasAstKind(ps, "COLOR_STMT")
        If resultOk = 0 Then detail = "missing COLOR_STMT AST node"

    Case "CLS_OK"
        resultOk = parseOk And HasAstKind(ps, "CLS_STMT")
        If resultOk = 0 Then detail = "missing CLS_STMT AST node"

    Case "GOTO_OK"
        resultOk = parseOk And HasAstKind(ps, "GOTO_STMT")
        If resultOk = 0 Then detail = "missing GOTO_STMT AST node"

    Case "GOSUB_OK"
        resultOk = parseOk And HasAstKind(ps, "GOSUB_STMT")
        If resultOk = 0 Then detail = "missing GOSUB_STMT AST node"

    Case "RETURN_OK"
        resultOk = parseOk And HasAstKind(ps, "RETURN_STMT")
        If resultOk = 0 Then detail = "missing RETURN_STMT AST node"

    Case "EXIT_OK"
        resultOk = parseOk And HasAstKind(ps, "EXIT_STMT")
        If resultOk = 0 Then detail = "missing EXIT_STMT AST node"

    Case "DECLARE_OK"
        resultOk = parseOk And (HasAstKind(ps, "DECLARE_SUB_STMT") Or HasAstKind(ps, "DECLARE_FUNCTION_STMT"))
        If resultOk = 0 Then detail = "missing DECLARE_* AST node"

    Case "SUB_OK"
        resultOk = parseOk And HasAstKind(ps, "SUB_STMT")
        If resultOk = 0 Then detail = "missing SUB_STMT AST node"

    Case "FUNCTION_OK"
        resultOk = parseOk And HasAstKind(ps, "FUNCTION_STMT")
        If resultOk = 0 Then detail = "missing FUNCTION_STMT AST node"

    Case "CONST_OK"
        resultOk = parseOk And HasAstKind(ps, "CONST_STMT") And HasAstKind(ps, "CONST_DECL")
        If resultOk = 0 Then detail = "missing CONST_STMT/CONST_DECL AST node"

    Case "REDIM_OK"
        resultOk = parseOk And HasAstKind(ps, "REDIM_STMT")
        If resultOk = 0 Then detail = "missing REDIM_STMT AST node"

    Case "TYPE_OK"
        resultOk = parseOk And HasAstKind(ps, "TYPE_STMT") And HasAstKind(ps, "TYPE_FIELD")
        If resultOk = 0 Then detail = "missing TYPE_STMT/TYPE_FIELD AST node"

    Case "INPUT_OK"
        resultOk = parseOk And HasAstKind(ps, "INPUT_STMT")
        If resultOk = 0 Then detail = "missing INPUT_STMT AST node"

    Case "INPUT_FILE_OK"
        resultOk = parseOk And HasAstKind(ps, "INPUT_FILE_STMT")
        If resultOk = 0 Then detail = "missing INPUT_FILE_STMT AST node"

    Case "LEN_OK"
        resultOk = parseOk And HasCallExprValue(ps, "LEN")
        If resultOk = 0 Then detail = "missing LEN call expression"

    Case "MID_OK"
        resultOk = parseOk And HasCallExprValue(ps, "MID")
        If resultOk = 0 Then detail = "missing MID call expression"

    Case "STR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "STR")
        If resultOk = 0 Then detail = "missing STR call expression"

    Case "VAL_OK"
        resultOk = parseOk And HasCallExprValue(ps, "VAL")
        If resultOk = 0 Then detail = "missing VAL call expression"

    Case "ABS_OK"
        resultOk = parseOk And HasCallExprValue(ps, "ABS")
        If resultOk = 0 Then detail = "missing ABS call expression"

    Case "INT_OK"
        resultOk = parseOk And HasCallExprValue(ps, "INT")
        If resultOk = 0 Then detail = "missing INT call expression"

    Case "UCASE_OK"
        resultOk = parseOk And HasCallExprValue(ps, "UCASE")
        If resultOk = 0 Then detail = "missing UCASE call expression"

    Case "LCASE_OK"
        resultOk = parseOk And HasCallExprValue(ps, "LCASE")
        If resultOk = 0 Then detail = "missing LCASE call expression"

    Case "ASC_OK"
        resultOk = parseOk And HasCallExprValue(ps, "ASC")
        If resultOk = 0 Then detail = "missing ASC call expression"

    Case "CHR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "CHR")
        If resultOk = 0 Then detail = "missing CHR call expression"

    Case "LTRIM_OK"
        resultOk = parseOk And HasCallExprValue(ps, "LTRIM")
        If resultOk = 0 Then detail = "missing LTRIM call expression"

    Case "RTRIM_OK"
        resultOk = parseOk And HasCallExprValue(ps, "RTRIM")
        If resultOk = 0 Then detail = "missing RTRIM call expression"

    Case "STRING_OK"
        resultOk = parseOk And HasCallExprValue(ps, "STRING")
        If resultOk = 0 Then detail = "missing STRING call expression"

    Case "SPACE_OK"
        resultOk = parseOk And HasCallExprValue(ps, "SPACE")
        If resultOk = 0 Then detail = "missing SPACE call expression"

    Case "SGN_OK"
        resultOk = parseOk And HasCallExprValue(ps, "SGN")
        If resultOk = 0 Then detail = "missing SGN call expression"

    Case "SQRT_OK"
        resultOk = parseOk And HasCallExprValue(ps, "SQRT")
        If resultOk = 0 Then detail = "missing SQRT call expression"

    Case "SIN_OK"
        resultOk = parseOk And HasCallExprValue(ps, "SIN")
        If resultOk = 0 Then detail = "missing SIN call expression"

    Case "COS_OK"
        resultOk = parseOk And HasCallExprValue(ps, "COS")
        If resultOk = 0 Then detail = "missing COS call expression"

    Case "TAN_OK"
        resultOk = parseOk And HasCallExprValue(ps, "TAN")
        If resultOk = 0 Then detail = "missing TAN call expression"

    Case "ATN_OK"
        resultOk = parseOk And HasCallExprValue(ps, "ATN")
        If resultOk = 0 Then detail = "missing ATN call expression"

    Case "EXP_OK"
        resultOk = parseOk And HasCallExprValue(ps, "EXP")
        If resultOk = 0 Then detail = "missing EXP call expression"

    Case "LOG_OK"
        resultOk = parseOk And HasCallExprValue(ps, "LOG")
        If resultOk = 0 Then detail = "missing LOG call expression"

    Case "INKEY_OK"
        resultOk = parseOk And HasCallExprValue(ps, "INKEY")
        If resultOk = 0 Then detail = "missing INKEY call expression"

    Case "GETKEY_OK"
        resultOk = parseOk And HasCallExprValue(ps, "GETKEY")
        If resultOk = 0 Then detail = "missing GETKEY call expression"

    Case "INKEY_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "INKEY$")
        If resultOk = 0 Then detail = "missing INKEY$ call expression"

    Case "MID_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "MID$")
        If resultOk = 0 Then detail = "missing MID$ call expression"

    Case "STR_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "STR$")
        If resultOk = 0 Then detail = "missing STR$ call expression"

    Case "UCASE_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "UCASE$")
        If resultOk = 0 Then detail = "missing UCASE$ call expression"

    Case "LCASE_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "LCASE$")
        If resultOk = 0 Then detail = "missing LCASE$ call expression"

    Case "CHR_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "CHR$")
        If resultOk = 0 Then detail = "missing CHR$ call expression"

    Case "STRING_DOLLAR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "STRING$")
        If resultOk = 0 Then detail = "missing STRING$ call expression"

    Case "DEFTYPE_OK"
        resultOk = parseOk And HasAstKind(ps, "DEFTYPE_STMT")
        If resultOk = 0 Then detail = "missing DEFTYPE_STMT AST node"

    Case "SETSTRINGSIZE_OK"
        resultOk = parseOk And HasAstKind(ps, "SETSTRINGSIZE_STMT")
        If resultOk = 0 Then detail = "missing SETSTRINGSIZE_STMT AST node"

    Case "END_OK"
        resultOk = parseOk And HasAstKind(ps, "END_STMT")
        If resultOk = 0 Then detail = "missing END_STMT AST node"

    Case "INC_OK"
        resultOk = parseOk And HasAstKindWithOp(ps, "INCDEC_STMT", "++")
        If resultOk = 0 Then detail = "missing INCDEC_STMT ++ node"

    Case "DEC_OK"
        resultOk = parseOk And HasAstKindWithOp(ps, "INCDEC_STMT", "--")
        If resultOk = 0 Then detail = "missing INCDEC_STMT -- node"

    Case "POKEB_OK"
        resultOk = parseOk And HasAstKind(ps, "POKEB_STMT")
        If resultOk = 0 Then detail = "missing POKEB_STMT AST node"

    Case "POKEW_OK"
        resultOk = parseOk And HasAstKind(ps, "POKEW_STMT")
        If resultOk = 0 Then detail = "missing POKEW_STMT AST node"

    Case "POKED_OK"
        resultOk = parseOk And HasAstKind(ps, "POKED_STMT")
        If resultOk = 0 Then detail = "missing POKED_STMT AST node"

    Case "MEMCOPYB_OK"
        resultOk = parseOk And HasAstKind(ps, "MEMCOPYB_STMT")
        If resultOk = 0 Then detail = "missing MEMCOPYB_STMT AST node"

    Case "MEMFILLB_OK"
        resultOk = parseOk And HasAstKind(ps, "MEMFILLB_STMT")
        If resultOk = 0 Then detail = "missing MEMFILLB_STMT AST node"

    Case "PEEKB_OK"
        resultOk = parseOk And HasCallExprValue(ps, "PEEKB")
        If resultOk = 0 Then detail = "missing PEEKB call expression"

    Case "PEEKW_OK"
        resultOk = parseOk And HasCallExprValue(ps, "PEEKW")
        If resultOk = 0 Then detail = "missing PEEKW call expression"

    Case "PEEKD_OK"
        resultOk = parseOk And HasCallExprValue(ps, "PEEKD")
        If resultOk = 0 Then detail = "missing PEEKD call expression"

    Case "CINT_OK"
        resultOk = parseOk And HasCallExprValue(ps, "CINT")
        If resultOk = 0 Then detail = "missing CINT call expression"

    Case "CLNG_OK"
        resultOk = parseOk And HasCallExprValue(ps, "CLNG")
        If resultOk = 0 Then detail = "missing CLNG call expression"

    Case "CDBL_OK"
        resultOk = parseOk And HasCallExprValue(ps, "CDBL")
        If resultOk = 0 Then detail = "missing CDBL call expression"

    Case "CSNG_OK"
        resultOk = parseOk And HasCallExprValue(ps, "CSNG")
        If resultOk = 0 Then detail = "missing CSNG call expression"

    Case "FIX_OK"
        resultOk = parseOk And HasCallExprValue(ps, "FIX")
        If resultOk = 0 Then detail = "missing FIX call expression"

    Case "SQR_OK"
        resultOk = parseOk And HasCallExprValue(ps, "SQR")
        If resultOk = 0 Then detail = "missing SQR call expression"

    Case "RND_OK"
        resultOk = parseOk And HasCallExprValue(ps, "RND")
        If resultOk = 0 Then detail = "missing RND call expression"

    Case "RANDOMIZE_OK"
        resultOk = parseOk And HasAstKind(ps, "RANDOMIZE_STMT")
        If resultOk = 0 Then detail = "missing RANDOMIZE_STMT AST node"

    Case Else
        resultOk = parseOk
        If parseOk = 0 Then
            detail = "unknown expected tag + parse failed: " & ps.lastError
        Else
            detail = "unknown expected tag treated as parse_ok"
        End If
    End Select

    EvaluateRow = resultOk
End Function

Private Function RowFromFields(fields() As String, ByVal fieldCount As Integer, ByRef row As ManifestRow) As Integer
    If fieldCount < 6 Then Return 0

    row.testId = fields(0)
    row.feature = fields(1)
    row.phaseName = fields(2)
    row.sourceInput = UnescapeBackslashQuote(fields(3))
    row.expected = fields(4)
    row.result = fields(5)
    Return 1
End Function

Private Sub Main()
    Dim manifestPath As String
    manifestPath = "tests/manifest.csv"

    Dim f As Integer
    f = FreeFile
    Open manifestPath For Input As #f

    If Err <> 0 Then
        Print "Cannot open manifest:"; manifestPath
        End 2
    End If

    Dim lineText As String
    Dim lineNo As Integer
    Dim runCount As Integer
    Dim passCount As Integer
    Dim failCount As Integer

    Do While Not Eof(f)
        Line Input #f, lineText
        lineNo += 1

        If lineNo = 1 Then Continue Do
        If Trim(lineText) = "" Then Continue Do

        Dim fields(Any) As String
        Dim fieldCount As Integer
        fieldCount = ParseCsvLine(lineText, fields())

        Dim row As ManifestRow
        If RowFromFields(fields(), fieldCount, row) = 0 Then
            Print "SKIP line"; lineNo; "invalid csv field count:"; fieldCount
            Continue Do
        End If

        If UCase(Trim(row.result)) <> "PENDING" Then Continue Do
        If runCount >= 180 Then Exit Do

        runCount += 1
        Dim detail As String
        Dim ok As Integer
        ok = EvaluateRow(row, detail)

        If ok Then
            passCount += 1
            Print "PASS "; row.testId; " | "; row.feature
        Else
            failCount += 1
            Print "FAIL "; row.testId; " | "; row.feature; " | "; detail
        End If
    Loop

    Close #f

    Print ""
    Print "Manifest smoke summary"
    Print "Run :"; runCount
    Print "Pass:"; passCount
    Print "Fail:"; failCount

    If failCount > 0 Then
        End 1
    End If

    End 0
End Sub

Main