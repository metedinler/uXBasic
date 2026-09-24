MAIN
rc = CALL(DLL, "user32.dll", "MessageBoxA", BYVAL, STDCALL, 0, 0, 0, 0)
PRINT "MessageBoxA return:"
PRINT rc
END MAIN

