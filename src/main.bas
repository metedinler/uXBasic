#include "parser/token_kinds.fbs"
#include "parser/lexer.fbs"
#include "parser/ast.fbs"
#include "parser/parser.fbs"
#include "runtime/timer.fbs"
#include "legacy/get_commands_port.fbs"

Sub PrintBanner()
    Print "uXbasic bootstrap (FreeBASIC)"
    Print "Phase: lexer/parser skeleton"
End Sub

Dim As String sourceText
sourceText = "PRINT 1 + 2 : IF a = 1 THEN b += 2 ELSE b =- 1 END IF"

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

Dim As String selected
Dim As Integer n
n = LegacyGetCommands(sourceText, 0, selected)
Print "Legacy split count:"; n
Print "Legacy part[0]:"; selected
Print "Timer(ms) sample:"; TimerNow("ms")

End 0