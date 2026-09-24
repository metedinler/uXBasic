#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "../src/runtime/diagnostics.fbs"
#include once "../src/runtime/error_localization.fbs"

Private Function AssertTrue(ByVal conditionValue As Integer, ByRef msg As String) As Integer
    If conditionValue = 0 Then
        Print "FAIL "; msg
        Return 0
    End If
    Return 1
End Function

Private Function ContainsText(ByRef haystack As String, ByRef needle As String) As Integer
    Return Instr(UCase(haystack), UCase(needle)) > 0
End Function

Private Function ReadTextFile(ByRef filePath As String, ByRef textOut As String) As Integer
    Dim f As Integer
    f = FreeFile

    Open filePath For Input As #f
    If Err <> 0 Then Return 0

    textOut = ""
    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        textOut &= lineText
        If Not Eof(f) Then textOut &= Chr(10)
    Loop

    Close #f
    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim logPath As String
    Dim binPath As String
    logPath = "tests\\tmp_diag_contract.log"
    binPath = "tests\\tmp_diag_contract.bin"

    Kill logPath
    Kill binPath

    Open binPath For Binary As #1
    Dim seedValue As Integer
    seedValue = 0
    Put #1, 1, seedValue
    Close #1

    Dim src As String
    src = _
        "OPEN """ & binPath & """ FOR INPUT AS #3" & Chr(10) & _
        "PUT #3, 1, 4, 1"

    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st
    If ParseProgram(ps) = 0 Then
        Print "FAIL parse | "; ps.lastError
        End 1
    End If

    Dim execErr As String
    If ExecRunMemoryProgram(ps, execErr) <> 0 Then
        Print "FAIL expected runtime error"
        End 1
    End If

    Dim trErr As String
    trErr = UxbYerellestirHata(execErr)

    ok And= AssertTrue(ContainsText(trErr, "Dosya yazma hatasi"), "localized prefix")
    ok And= AssertTrue(ContainsText(trErr, "Yazma modu uygun degil"), "localized detail")
    ok And= AssertTrue(ContainsText(trErr, "7007"), "localized error code")

    DiagInitPath logPath
    DiagHata "Bellek yurutme basarisiz: " & trErr

    Dim logText As String
    ok And= AssertTrue(ReadTextFile(logPath, logText), "read log file")
    ok And= AssertTrue(ContainsText(logText, "HATA:"), "log severity")
    ok And= AssertTrue(ContainsText(logText, "Dosya yazma hatasi"), "log localized prefix")
    ok And= AssertTrue(ContainsText(logText, "Yazma modu uygun degil"), "log localized detail")
    ok And= AssertTrue(ContainsText(logText, "7007"), "log error code")
    ok And= AssertTrue(ContainsText(logText, "MODE NOT WRITABLE") = 0, "log has no raw english detail")

    Kill logPath
    Kill binPath

    If ok = 0 Then End 1

    Print "PASS diagnostics log"
    End 0
End Sub

Main