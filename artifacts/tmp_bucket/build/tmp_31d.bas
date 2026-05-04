MAIN
t0 = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
t1 = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
delta = t1 - t0
PRINT "kernel32 Sleep delta(ms):"
PRINT delta
PRINT "kernel32 GetTickCount snapshot:"
PRINT t1
END MAIN
