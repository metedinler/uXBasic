#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"

Private Function AssertEq(ByVal actualValue As Integer, ByVal expectedValue As Integer, ByRef msg As String) As Integer
    If actualValue <> expectedValue Then
        Print "FAIL "; msg; " expected="; expectedValue; " actual="; actualValue
        Return 0
    End If
    Return 1
End Function

Private Function RunProgramExpectOk(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = "parse | " & ps.lastError
        Return 0
    End If

    If ExecRunMemoryProgram(ps, errOut) = 0 Then
        errOut = "exec | " & errOut
        Return 0
    End If

    Return 1
End Function

Private Function RunProgramExpectExecFail(ByRef src As String, ByRef errOut As String) As Integer
    Dim st As LexerState
    LexerInit st, src

    Dim ps As ParseState
    ParserInit ps, st

    If ParseProgram(ps) = 0 Then
        errOut = "parse | " & ps.lastError
        Return 0
    End If

    errOut = ""
    If ExecRunMemoryProgram(ps, errOut) <> 0 Then
        errOut = "expected exec failure"
        Return 0
    End If

    Return 1
End Function

Private Sub Main()
    Dim ok As Integer
    ok = 1

    ExecDebugKeyQueueClear
    ExecDebugKeyQueuePush 65
    ExecDebugKeyQueuePush 66

    Dim srcOk As String
    srcOk = _
        "RANDOMIZE 123" & Chr(10) & _
        "x = LEN(""abc"")" & Chr(10) & _
        "y = ABS(-5)" & Chr(10) & _
        "z = SGN(-7)" & Chr(10) & _
        "u = INT(9)" & Chr(10) & _
        "v = VAL(""42"")" & Chr(10) & _
        "w = ASC(""A"")" & Chr(10) & _
        "p = CINT(7)" & Chr(10) & _
        "q = CLNG(8)" & Chr(10) & _
        "r = CDBL(9)" & Chr(10) & _
        "s = CSNG(10)" & Chr(10) & _
        "t = FIX(-11)" & Chr(10) & _
        "uu = SQR(81)" & Chr(10) & _
        "vv = TIMER(10, 15, ""ms"")" & Chr(10) & _
        "sv = VAL(STR(42))" & Chr(10) & _
        "sl = LEN(STR(-11))" & Chr(10) & _
        "ua = ASC(UCASE(""a""))" & Chr(10) & _
        "la = ASC(LCASE(""A""))" & Chr(10) & _
        "ca = ASC(CHR(90))" & Chr(10) & _
        "lta = ASC(LTRIM(""   z""))" & Chr(10) & _
        "rta = ASC(RTRIM(""z   ""))" & Chr(10) & _
        "mda = ASC(MID(""abcdef"", 4, 1))" & Chr(10) & _
        "spl = LEN(SPACE(5))" & Chr(10) & _
        "sta = ASC(STRING(3, 65))" & Chr(10) & _
        "sn0 = SIN(0)" & Chr(10) & _
        "sn2 = SIN(2)" & Chr(10) & _
        "cs0 = COS(0)" & Chr(10) & _
        "cs3 = COS(3)" & Chr(10) & _
        "tn0 = TAN(0)" & Chr(10) & _
        "tn1 = TAN(1)" & Chr(10) & _
        "an0 = ATN(0)" & Chr(10) & _
        "an1 = ATN(1)" & Chr(10) & _
        "ex0 = EXP(0)" & Chr(10) & _
        "ex1 = EXP(1)" & Chr(10) & _
        "ex2 = EXP(2)" & Chr(10) & _
        "lg1 = LOG(1)" & Chr(10) & _
        "lg3 = LOG(3)" & Chr(10) & _
        "rv = RND(1)" & Chr(10) & _
        "tm0 = TIMER()" & Chr(10) & _
        "tmu = TIMER(""ms"")" & Chr(10) & _
        "RANDOMIZE 1337" & Chr(10) & _
        "rr1 = RND(1)" & Chr(10) & _
        "rr2 = RND(1)" & Chr(10) & _
        "rr3 = RND(1)" & Chr(10) & _
        "RANDOMIZE 1337" & Chr(10) & _
        "rr1b = RND(1)" & Chr(10) & _
        "rr2b = RND(1)" & Chr(10) & _
        "rr3b = RND(1)" & Chr(10) & _
        "ax = 99" & Chr(10) & _
        "bx = 123" & Chr(10) & _
        "vp1 = VARPTR(ax)" & Chr(10) & _
        "vp2 = VARPTR(ax)" & Chr(10) & _
        "vpb = VARPTR(bx)" & Chr(10) & _
        "sa1 = SADD(""AB"")" & Chr(10) & _
        "sa2 = SADD(""AB"")" & Chr(10) & _
        "lp1 = LPTR(labelA)" & Chr(10) & _
        "lp2 = LPTR(labelA)" & Chr(10) & _
        "lpb = LPTR(labelB)" & Chr(10) & _
        "cp1 = CODEPTR(procA)" & Chr(10) & _
        "cp2 = CODEPTR(procA)" & Chr(10) & _
        "cpb = CODEPTR(procB)" & Chr(10) & _
        "PRINT STR(55)" & Chr(10) & _
        "POKES 7000, STR(1234)" & Chr(10) & _
        "POKES 7010, UCASE(""ab"")" & Chr(10) & _
        "POKES 7020, LCASE(""AB"")" & Chr(10) & _
        "POKES 7030, CHR(65)" & Chr(10) & _
        "POKES 7040, MID(""ABCDE"", 2, 3)" & Chr(10) & _
        "POKES 7050, LTRIM(""  q"")" & Chr(10) & _
        "POKES 7060, RTRIM(""q  "")" & Chr(10) & _
        "POKES 7070, SPACE(2)" & Chr(10) & _
        "POKES 7080, STRING(2, 66)" & Chr(10) & _
        "ww = @x" & Chr(10) & _
        "xx = INKEY(1, kstate)" & Chr(10) & _
        "yy = GETKEY()" & Chr(10) & _
        "yz = GETKEY()" & Chr(10) & _
        "OPEN ""tests\\tmp_runtime_intrinsics_io.bin"" FOR BINARY AS #1" & Chr(10) & _
        "PUT #1, 1, 305419896" & Chr(10) & _
        "ll = LOF(1)" & Chr(10) & _
        "CLOSE #1" & Chr(10) & _
        "OPEN ""tests\\tmp_runtime_intrinsics_io.bin"" FOR BINARY AS #2" & Chr(10) & _
        "ee = EOF(2)" & Chr(10) & _
        "CLOSE #2" & Chr(10) & _
        "POKED 5000, x" & Chr(10) & _
        "POKED 5004, y" & Chr(10) & _
        "POKED 5008, z" & Chr(10) & _
        "POKED 5012, u" & Chr(10) & _
        "POKED 5016, v" & Chr(10) & _
        "POKED 5020, w" & Chr(10) & _
        "POKED 5024, p" & Chr(10) & _
        "POKED 5028, q" & Chr(10) & _
        "POKED 5032, r" & Chr(10) & _
        "POKED 5036, s" & Chr(10) & _
        "POKED 5040, t" & Chr(10) & _
        "POKED 5044, uu" & Chr(10) & _
        "POKED 5048, vv" & Chr(10) & _
        "POKED 5052, ll" & Chr(10) & _
        "POKED 5056, xx" & Chr(10) & _
        "POKED 5060, yy" & Chr(10) & _
        "POKED 5068, sv" & Chr(10) & _
        "POKED 5072, sl" & Chr(10) & _
        "POKED 5076, ua" & Chr(10) & _
        "POKED 5080, la" & Chr(10) & _
        "POKED 5084, ca" & Chr(10) & _
        "POKED 5088, lta" & Chr(10) & _
        "POKED 5092, rta" & Chr(10) & _
        "POKED 5096, mda" & Chr(10) & _
        "POKED 5100, spl" & Chr(10) & _
        "POKED 5104, sta" & Chr(10) & _
        "POKED 5108, sn0" & Chr(10) & _
        "POKED 5112, sn2" & Chr(10) & _
        "POKED 5116, cs0" & Chr(10) & _
        "POKED 5120, cs3" & Chr(10) & _
        "POKED 5124, tn0" & Chr(10) & _
        "POKED 5128, tn1" & Chr(10) & _
        "POKED 5132, an0" & Chr(10) & _
        "POKED 5136, an1" & Chr(10) & _
        "POKED 5140, ex0" & Chr(10) & _
        "POKED 5144, ex1" & Chr(10) & _
        "POKED 5148, ex2" & Chr(10) & _
        "POKED 5152, lg1" & Chr(10) & _
        "POKED 5156, lg3" & Chr(10) & _
        "POKED 5160, rv" & Chr(10) & _
        "POKED 5164, tm0" & Chr(10) & _
        "POKED 5168, tmu" & Chr(10) & _
        "POKED 5172, kstate" & Chr(10) & _
        "POKED 5176, yz" & Chr(10) & _
        "POKED 5180, ee" & Chr(10) & _
        "POKED 5190, rr1" & Chr(10) & _
        "POKED 5194, rr2" & Chr(10) & _
        "POKED 5198, rr3" & Chr(10) & _
        "POKED 5202, rr1b" & Chr(10) & _
        "POKED 5206, rr2b" & Chr(10) & _
        "POKED 5210, rr3b" & Chr(10) & _
        "POKED 5220, vp1" & Chr(10) & _
        "POKED 5224, vp2" & Chr(10) & _
        "POKED 5228, vpb" & Chr(10) & _
        "POKED 5232, sa1" & Chr(10) & _
        "POKED 5236, sa2" & Chr(10) & _
        "POKED 5240, lp1" & Chr(10) & _
        "POKED 5244, lp2" & Chr(10) & _
        "POKED 5248, lpb" & Chr(10) & _
        "POKED 5252, cp1" & Chr(10) & _
        "POKED 5256, cp2" & Chr(10) & _
        "POKED 5260, cpb" & Chr(10) & _
        "labelA:" & Chr(10) & _
        "labelB:" & Chr(10) & _
        "DECLARE SUB procA()" & Chr(10) & _
        "DECLARE SUB procB()" & Chr(10) & _
        "POKED 5064, ww"

    Dim errText As String
    If RunProgramExpectOk(srcOk, errText) = 0 Then
        Print "FAIL intrinsic runtime success path | "; errText
        End 1
    End If

    ok And= AssertEq(VMemPeekD(5000), 3, "LEN")
    ok And= AssertEq(VMemPeekD(5004), 5, "ABS")
    ok And= AssertEq(VMemPeekD(5008), &hFFFFFFFF, "SGN")
    ok And= AssertEq(VMemPeekD(5012), 9, "INT")
    ok And= AssertEq(VMemPeekD(5016), 42, "VAL")
    ok And= AssertEq(VMemPeekD(5020), 65, "ASC")
    ok And= AssertEq(VMemPeekD(5024), 7, "CINT")
    ok And= AssertEq(VMemPeekD(5028), 8, "CLNG")
    ok And= AssertEq(VMemPeekD(5032), 9, "CDBL")
    ok And= AssertEq(VMemPeekD(5036), 10, "CSNG")
    ok And= AssertEq(VMemPeekD(5040), &hFFFFFFF5, "FIX")
    ok And= AssertEq(VMemPeekD(5044), 9, "SQR")
    ok And= AssertEq(VMemPeekD(5048), 5000, "TIMER delta ms")
    ok And= AssertEq(VMemPeekD(5052), 8, "LOF")
    ok And= AssertEq(VMemPeekD(5056), 65, "INKEY key queue pop")
    ok And= AssertEq(VMemPeekD(5060), 66, "GETKEY key queue pop")
    ok And= AssertEq(VMemPeekD(5064) > 0, -1, "address unary @")
    ok And= AssertEq(VMemPeekD(5068), 42, "VAL(STR())")
    ok And= AssertEq(VMemPeekD(5072), 3, "LEN(STR())")
    ok And= AssertEq(VMemPeekD(5076), 65, "ASC(UCASE())")
    ok And= AssertEq(VMemPeekD(5080), 97, "ASC(LCASE())")
    ok And= AssertEq(VMemPeekD(5084), 90, "ASC(CHR())")
    ok And= AssertEq(VMemPeekD(5088), 122, "ASC(LTRIM())")
    ok And= AssertEq(VMemPeekD(5092), 122, "ASC(RTRIM())")
    ok And= AssertEq(VMemPeekD(5096), 100, "ASC(MID())")
    ok And= AssertEq(VMemPeekD(5100), 5, "LEN(SPACE())")
    ok And= AssertEq(VMemPeekD(5104), 65, "ASC(STRING())")
    ok And= AssertEq(VMemPeekD(5108), 0, "SIN(0)")
    ok And= AssertEq(VMemPeekD(5112), 1, "SIN(2)")
    ok And= AssertEq(VMemPeekD(5116), 1, "COS(0)")
    ok And= AssertEq(VMemPeekD(5120), &hFFFFFFFF, "COS(3)")
    ok And= AssertEq(VMemPeekD(5124), 0, "TAN(0)")
    ok And= AssertEq(VMemPeekD(5128), 2, "TAN(1)")
    ok And= AssertEq(VMemPeekD(5132), 0, "ATN(0)")
    ok And= AssertEq(VMemPeekD(5136), 1, "ATN(1)")
    ok And= AssertEq(VMemPeekD(5140), 1, "EXP(0)")
    ok And= AssertEq(VMemPeekD(5144), 3, "EXP(1)")
    ok And= AssertEq(VMemPeekD(5148), 7, "EXP(2)")
    ok And= AssertEq(VMemPeekD(5152), 0, "LOG(1)")
    ok And= AssertEq(VMemPeekD(5156), 1, "LOG(3)")
    ok And= AssertEq(VMemPeekD(5160) >= 0, -1, "RND lower bound")
    ok And= AssertEq(VMemPeekD(5160) <= 2147483647, -1, "RND upper bound")
    ok And= AssertEq(VMemPeekD(5164) >= 0, -1, "TIMER() non-negative")
    ok And= AssertEq(VMemPeekD(5168) >= 0, -1, "TIMER(ms) non-negative")
    ok And= AssertEq(VMemPeekD(5172), 1, "INKEY state output")
    ok And= AssertEq(VMemPeekD(5176), 0, "GETKEY empty queue")
    ok And= AssertEq(VMemPeekD(5180), 0, "EOF open channel false")
    ok And= AssertEq(VMemPeekD(5190), VMemPeekD(5202), "RANDOMIZE reseed sequence #1")
    ok And= AssertEq(VMemPeekD(5194), VMemPeekD(5206), "RANDOMIZE reseed sequence #2")
    ok And= AssertEq(VMemPeekD(5198), VMemPeekD(5210), "RANDOMIZE reseed sequence #3")
    ok And= AssertEq(VMemPeekD(5220), VMemPeekD(5224), "VARPTR same variable stable")
    ok And= AssertEq(VMemPeekD(5220) <> VMemPeekD(5228), -1, "VARPTR different variable differs")
    ok And= AssertEq(VMemPeekD(5220) > 0, -1, "VARPTR non-zero")
    ok And= AssertEq(VMemPeekD(5232), VMemPeekD(5236), "SADD same literal stable")
    ok And= AssertEq((VMemPeekD(5232) And &hF0000000), &h20000000, "SADD pointer tag")
    ok And= AssertEq(VMemPeekD(5240), VMemPeekD(5244), "LPTR same label stable")
    ok And= AssertEq(VMemPeekD(5240) <> VMemPeekD(5248), -1, "LPTR different label differs")
    ok And= AssertEq((VMemPeekD(5240) And &hF0000000), &h30000000, "LPTR pointer tag")
    ok And= AssertEq(VMemPeekD(5252), VMemPeekD(5256), "CODEPTR same proc stable")
    ok And= AssertEq(VMemPeekD(5252) <> VMemPeekD(5260), -1, "CODEPTR different proc differs")
    ok And= AssertEq((VMemPeekD(5252) And &hF0000000), &h40000000, "CODEPTR pointer tag")
    ok And= AssertEq(VMemPeekB(7000), Asc("1"), "POKES STR byte0")
    ok And= AssertEq(VMemPeekB(7001), Asc("2"), "POKES STR byte1")
    ok And= AssertEq(VMemPeekB(7002), Asc("3"), "POKES STR byte2")
    ok And= AssertEq(VMemPeekB(7003), Asc("4"), "POKES STR byte3")
    ok And= AssertEq(VMemPeekB(7010), Asc("A"), "POKES UCASE byte0")
    ok And= AssertEq(VMemPeekB(7011), Asc("B"), "POKES UCASE byte1")
    ok And= AssertEq(VMemPeekB(7020), Asc("a"), "POKES LCASE byte0")
    ok And= AssertEq(VMemPeekB(7021), Asc("b"), "POKES LCASE byte1")
    ok And= AssertEq(VMemPeekB(7030), Asc("A"), "POKES CHR byte0")
    ok And= AssertEq(VMemPeekB(7040), Asc("B"), "POKES MID byte0")
    ok And= AssertEq(VMemPeekB(7041), Asc("C"), "POKES MID byte1")
    ok And= AssertEq(VMemPeekB(7042), Asc("D"), "POKES MID byte2")
    ok And= AssertEq(VMemPeekB(7050), Asc("q"), "POKES LTRIM byte0")
    ok And= AssertEq(VMemPeekB(7060), Asc("q"), "POKES RTRIM byte0")
    ok And= AssertEq(VMemPeekB(7070), 32, "POKES SPACE byte0")
    ok And= AssertEq(VMemPeekB(7071), 32, "POKES SPACE byte1")
    ok And= AssertEq(VMemPeekB(7080), Asc("B"), "POKES STRING byte0")
    ok And= AssertEq(VMemPeekB(7081), Asc("B"), "POKES STRING byte1")
    ok And= AssertEq(ExecDebugGetKeyQueueRemaining(), 0, "KEY queue drained")

    Kill "tests\\tmp_runtime_intrinsics_io.bin"

    Dim srcFail As String
    srcFail = "CALL UNKNOWN2(1)"

    Dim failErr As String
    If RunProgramExpectExecFail(srcFail, failErr) = 0 Then
        Print "FAIL intrinsic runtime fail path | "; failErr
        End 1
    End If

    If Instr(UCase(failErr), "UNSUPPORTED CALL UNKNOWN2") = 0 Then
        Print "FAIL intrinsic runtime fail detail | "; failErr
        End 1
    End If

    Dim srcLogFail As String
    srcLogFail = "x = LOG(0)"

    Dim logFailErr As String
    If RunProgramExpectExecFail(srcLogFail, logFailErr) = 0 Then
        Print "FAIL LOG domain fail path | "; logFailErr
        End 1
    End If

    If Instr(UCase(logFailErr), "LOG DOMAIN ERROR") = 0 Then
        Print "FAIL LOG domain fail detail | "; logFailErr
        End 1
    End If

    Dim srcLofFail As String
    srcLofFail = "x = LOF(1)"

    Dim lofFailErr As String
    If RunProgramExpectExecFail(srcLofFail, lofFailErr) = 0 Then
        Print "FAIL LOF closed-channel fail path | "; lofFailErr
        End 1
    End If

    If Instr(UCase(lofFailErr), "LOF CHANNEL NOT OPEN") = 0 Then
        Print "FAIL LOF closed-channel detail | "; lofFailErr
        End 1
    End If

    Dim srcEofFail As String
    srcEofFail = "x = EOF(1)"

    Dim eofFailErr As String
    If RunProgramExpectExecFail(srcEofFail, eofFailErr) = 0 Then
        Print "FAIL EOF closed-channel fail path | "; eofFailErr
        End 1
    End If

    If Instr(UCase(eofFailErr), "EOF CHANNEL NOT OPEN") = 0 Then
        Print "FAIL EOF closed-channel detail | "; eofFailErr
        End 1
    End If

    ExecDebugKeyQueueClear

    If ok = 0 Then End 1

    Print "PASS runtime intrinsics"
    End 0
End Sub

Main
