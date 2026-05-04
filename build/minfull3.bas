MAIN
t0 = TIMER("ms")
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
t1 = TIMER("ms")
tick = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
PRINT tick
END MAIN

