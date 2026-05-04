MAIN
a = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
b = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
PRINT b
END MAIN
