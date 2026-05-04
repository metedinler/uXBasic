MAIN
a = 1
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 1)
b = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
c = a + b
PRINT c
END MAIN

