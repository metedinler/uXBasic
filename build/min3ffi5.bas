MAIN
t0 = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
t1 = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
x = t1 - t0
PRINT x
END MAIN

