' Auto-maintained uXBasic wrapper for uxprocess.dll
NAMESPACE uxprocess

CONST DLL_NAME = "uxprocess.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Start(command AS STRING,cwd AS STRING,hidden AS I32) AS U64
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_start", U64, CDECL, "STRPTR,STRPTR,I32", command, cwd, hidden)
END FUNCTION

FUNCTION Wait(handle AS U64,timeoutMs AS U32) AS I32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_wait", I32, CDECL, "U64,U32", handle, timeoutMs)
END FUNCTION

FUNCTION IsRunning(handle AS U64) AS I32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_is_running", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION ExitCode(handle AS U64) AS I32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_exit_code", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION ProcessId(handle AS U64) AS U32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_id", U32, CDECL, "U64", handle)
END FUNCTION

FUNCTION Kill(handle AS U64,exitCode AS U32) AS I32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_kill", I32, CDECL, "U64,U32", handle, exitCode)
END FUNCTION

SUB Close(handle AS U64)
    CALL(DLL, "uxprocess.dll", "uxprocess_close", VOID, CDECL, "U64", handle)
END SUB

FUNCTION ShellOpen(target AS STRING,parameters AS STRING,cwd AS STRING,showCommand AS I32) AS I32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_shell_open", I32, CDECL, "STRPTR,STRPTR,STRPTR,I32", target,parameters,cwd,showCommand)
END FUNCTION

FUNCTION RunWait(command AS STRING,cwd AS STRING,hidden AS I32,timeoutMs AS U32) AS I32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_run_wait", I32, CDECL, "STRPTR,STRPTR,I32,U32", command,cwd,hidden,timeoutMs)
END FUNCTION

FUNCTION CurrentProcessId() AS U32
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_current_id", U32, CDECL)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxprocess.dll", "uxprocess_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
