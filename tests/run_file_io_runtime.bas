#include once "../src/runtime/file_io.fbs"

Private Function AssertEq(ByVal actualValue As Integer, ByVal expectedValue As Integer, ByRef msg As String) As Integer
    If actualValue <> expectedValue Then
        Print "FAIL "; msg; " expected="; expectedValue; " actual="; actualValue
        Return 0
    End If
    Return 1
End Function

Private Function AssertTrue(ByVal conditionValue As Integer, ByRef msg As String) As Integer
    If conditionValue = 0 Then
        Print "FAIL "; msg
        Return 0
    End If
    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    Dim io As UxbFileRuntime
    UxbFileInit io

    Dim modeText As String
    Dim modeId As Integer
    ok And= AssertTrue(UxbFileNormalizeMode("bin", modeText, modeId), "mode normalize bin")
    ok And= AssertEq(modeId, UXB_FILE_MODE_BINARY, "mode normalize id")

    Dim tmpPath As String
    tmpPath = "tests\\tmp_file_io_runtime.bin"
    Kill tmpPath

    ok And= AssertTrue(UxbFileOpen(io, 9, tmpPath, "binary"), "open binary lower-case")
    ok And= AssertTrue(UxbFilePutI32(io, 9, 1, 4, &h11223344), "put i32")

    Dim currentPosition As LongInt
    ok And= AssertTrue(UxbFileSeek(io, 9, 1, currentPosition), "seek set")

    Dim readBack As Integer
    readBack = 0
    ok And= AssertTrue(UxbFileGetI32(io, 9, 1, 4, readBack), "get i32")
    ok And= AssertEq(readBack, &h11223344, "roundtrip value")

    ok And= AssertTrue(UxbFileClose(io, 9), "close binary")

    ok And= AssertTrue(UxbFileOpen(io, 9, tmpPath, "INPUT"), "open input mode")
    ok And= AssertEq(UxbFilePutI32(io, 9, 1, 4, 1), 0, "put denied on input")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_MODE_NOT_WRITABLE, "input write error code")
    ok And= AssertTrue(UxbFileClose(io, 9), "close input")

    ok And= AssertEq(UxbFileOpen(io, 9, tmpPath, "NOPE"), 0, "invalid mode rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_INVALID_MODE, "invalid mode error code")

    Dim afterCloseRead As Integer
    ok And= AssertEq(UxbFileGetI32(io, 9, 1, 4, afterCloseRead), 0, "get on closed channel rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_CHANNEL_NOT_OPEN, "closed channel error code")

    Kill tmpPath

    If ok = 0 Then End 1

    Print "PASS file io runtime"
    End 0
End Sub

Main
