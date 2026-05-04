MAIN
t0 = TIMER("ms")
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
t1 = TIMER("ms")
delta = t1 - t0
PRINT delta
END MAIN

