MAIN
r = CALL(DLL, "user32.dll", "GetSystemMetrics", I32, STDCALL, 0)
PRINT r
END MAIN
