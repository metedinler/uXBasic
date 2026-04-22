MAIN
t0 = TIMER("ms")
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
t1 = TIMER("ms")
delta = t1 - t0
tick = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
PRINT "kernel32 Sleep delta(ms):"
PRINT delta
PRINT "kernel32 GetTickCount snapshot:"
PRINT tick
END MAIN

