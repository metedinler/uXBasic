MAIN
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 1)
tick = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
PRINT tick
END MAIN

