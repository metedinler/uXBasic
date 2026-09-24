' Auto-maintained uXBasic wrapper for uxlog.dll
NAMESPACE uxlog

CONST DLL_NAME = "uxlog.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxlog.dll", "uxlog_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Open(path AS STRING,minLevel AS I32,rotateBytes AS U64) AS U64
    RETURN CALL(DLL, "uxlog.dll", "uxlog_open", U64, CDECL, "STRPTR,I32,U64", path, minLevel, rotateBytes)
END FUNCTION

FUNCTION Write(handle AS U64,level AS I32,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_write", I32, CDECL, "U64,I32,STRPTR", handle, level, message)
END FUNCTION

FUNCTION Trace(handle AS U64,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_trace", I32, CDECL, "U64,STRPTR", handle, message)
END FUNCTION

FUNCTION Debug(handle AS U64,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_debug", I32, CDECL, "U64,STRPTR", handle, message)
END FUNCTION

FUNCTION Info(handle AS U64,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_info", I32, CDECL, "U64,STRPTR", handle, message)
END FUNCTION

FUNCTION Warning(handle AS U64,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_warning", I32, CDECL, "U64,STRPTR", handle, message)
END FUNCTION

FUNCTION Error(handle AS U64,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_error_write", I32, CDECL, "U64,STRPTR", handle, message)
END FUNCTION

FUNCTION Fatal(handle AS U64,message AS STRING) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_fatal", I32, CDECL, "U64,STRPTR", handle, message)
END FUNCTION

FUNCTION SetLevel(handle AS U64,level AS I32) AS I32
    RETURN CALL(DLL, "uxlog.dll", "uxlog_set_level", I32, CDECL, "U64,I32", handle, level)
END FUNCTION

SUB Flush(handle AS U64)
    CALL(DLL, "uxlog.dll", "uxlog_flush", VOID, CDECL, "U64", handle)
END SUB

SUB Close(handle AS U64)
    CALL(DLL, "uxlog.dll", "uxlog_close", VOID, CDECL, "U64", handle)
END SUB

FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxlog.dll", "uxlog_last_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
