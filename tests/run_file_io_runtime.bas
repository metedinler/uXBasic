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

    Dim tmpPathRandom As String
    tmpPathRandom = "tests\\tmp_file_io_runtime_random.bin"
    Kill tmpPathRandom

    ok And= AssertTrue(UxbFileOpen(io, 10, tmpPathRandom, "rand", 2), "open random alias with len")
    ok And= AssertTrue(UxbFilePutI32(io, 10, 1, 0, &h1234), "put random default-bytes")

    Dim randomReadBack As Integer
    randomReadBack = 0
    ok And= AssertTrue(UxbFileGetI32(io, 10, 1, 0, randomReadBack), "get random default-bytes")
    ok And= AssertEq((randomReadBack And &hFFFF), &h1234, "random len=2 default transfer")

    randomReadBack = 0
    ok And= AssertEq(UxbFileGetI32(io, 10, 1, 4, randomReadBack), 0, "random bytes mismatch rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_INVALID_ARGUMENT, "random bytes mismatch error code")

    ok And= AssertTrue(UxbFileClose(io, 10), "close random")

    ' Negative edge set: mode transitions, seek guards, eof, and channel reuse.
    Dim tmpPathEdge As String
    tmpPathEdge = "tests\\tmp_file_io_runtime_edge.bin"
    Kill tmpPathEdge

    Open tmpPathEdge For Output As #1
    Close #1

    ok And= AssertTrue(UxbFileOpen(io, 11, tmpPathEdge, "binary"), "open edge binary")

    ok And= AssertEq(UxbFileOpen(io, 11, tmpPathEdge, "binary"), 0, "open already-open channel rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_CHANNEL_ALREADY_OPEN, "already-open channel error code")

    ok And= AssertEq(UxbFileSeek(io, 11, 0, currentPosition), 0, "seek zero rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_SEEK_OUT_OF_RANGE, "seek out-of-range error code")

    ok And= AssertTrue(UxbFileClose(io, 11), "close edge binary")

    ok And= AssertTrue(UxbFileOpen(io, 12, tmpPathEdge, "append"), "open append mode")
    ok And= AssertEq(UxbFileSeek(io, 12, 1, currentPosition), 0, "seek append rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_SEEK_NOT_ALLOWED, "seek not allowed error code")
    ok And= AssertTrue(UxbFileClose(io, 12), "close append")

    ok And= AssertTrue(UxbFileOpen(io, 13, tmpPathEdge, "output"), "open output mode")
    Dim outputRead As Integer
    outputRead = 0
    ok And= AssertEq(UxbFileGetI32(io, 13, 1, 4, outputRead), 0, "read denied on output")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_MODE_NOT_READABLE, "output read error code")
    ok And= AssertTrue(UxbFileClose(io, 13), "close output")

    ok And= AssertEq(UxbFileOpen(io, 0, tmpPathEdge, "binary"), 0, "open invalid channel rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_BAD_CHANNEL, "invalid channel error code")

    ok And= AssertEq(UxbFileOpen(io, 14, "tests\\__missing_file_runtime__.bin", "input"), 0, "open missing input rejected")
    ok And= AssertEq(UxbFileGetLastError(io), UXB_FILE_ERR_NOT_FOUND, "missing file error code")

    Kill tmpPath
    Kill tmpPathRandom
    Kill tmpPathEdge

    If ok = 0 Then End 1

    Print "PASS file io runtime"
    End 0
End Sub

Main
