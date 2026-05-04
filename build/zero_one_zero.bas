MAIN
a = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
b = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
PRINT b
END MAIN
