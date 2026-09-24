FUNCTION PythonVersion() AS I32
    RETURN CALL(DLL, "uxpython.dll", "uxpython_version", I32, CDECL)
END FUNCTION

FUNCTION PythonFlagIsolated() AS I32
    RETURN 1
END FUNCTION

FUNCTION PythonFlagIgnoreEnvironment() AS I32
    RETURN 2
END FUNCTION

FUNCTION PythonFlagNoSite() AS I32
    RETURN 4
END FUNCTION

FUNCTION PythonOpen(pythonHome AS STRING, venvPath AS STRING, modulePath AS STRING, flags AS I32) AS U64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_open", U64, CDECL, "STRPTR,STRPTR,STRPTR,I32", pythonHome, venvPath, modulePath, flags)
END FUNCTION

FUNCTION PythonClose(session AS U64) AS I32
    RETURN CALL(DLL, "uxpython.dll", "uxpython_close", I32, CDECL, "U64", session)
END FUNCTION

FUNCTION PythonReady(session AS U64) AS I32
    RETURN CALL(DLL, "uxpython.dll", "uxpython_is_ready", I32, CDECL, "U64", session)
END FUNCTION

FUNCTION PythonAddPath(session AS U64, pathValue AS STRING) AS I32
    RETURN CALL(DLL, "uxpython.dll", "uxpython_add_path", I32, CDECL, "U64,STRPTR", session, pathValue)
END FUNCTION

FUNCTION PythonError(session AS U64) AS STRING
    RETURN CALL(DLL, "uxpython.dll", "uxpython_last_error", STRPTR, CDECL, "U64", session)
END FUNCTION

FUNCTION PythonRuntimeVersion(session AS U64) AS STRING
    RETURN CALL(DLL, "uxpython.dll", "uxpython_runtime_version", STRPTR, CDECL, "U64", session)
END FUNCTION

FUNCTION PythonImport(session AS U64, moduleName AS STRING) AS U64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_import", U64, CDECL, "U64,STRPTR", session, moduleName)
END FUNCTION

FUNCTION PythonGet(session AS U64, objectHandle AS U64, attributeName AS STRING) AS U64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_get_attr", U64, CDECL, "U64,U64,STRPTR", session, objectHandle, attributeName)
END FUNCTION

FUNCTION PythonCall(session AS U64, callableHandle AS U64, argsJson AS STRING, kwargsJson AS STRING) AS U64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_call_json", U64, CDECL, "U64,U64,STRPTR,STRPTR", session, callableHandle, argsJson, kwargsJson)
END FUNCTION

FUNCTION PythonCallModule(session AS U64, moduleName AS STRING, functionName AS STRING, argsJson AS STRING, kwargsJson AS STRING) AS U64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_call_module_json", U64, CDECL, "U64,STRPTR,STRPTR,STRPTR,STRPTR", session, moduleName, functionName, argsJson, kwargsJson)
END FUNCTION

FUNCTION PythonInt(session AS U64, objectHandle AS U64) AS I64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_to_i64", I64, CDECL, "U64,U64", session, objectHandle)
END FUNCTION

FUNCTION PythonFloat(session AS U64, objectHandle AS U64) AS F64
    RETURN CALL(DLL, "uxpython.dll", "uxpython_to_f64", F64, CDECL, "U64,U64", session, objectHandle)
END FUNCTION

FUNCTION PythonString(session AS U64, objectHandle AS U64) AS STRING
    RETURN CALL(DLL, "uxpython.dll", "uxpython_to_string", STRPTR, CDECL, "U64,U64", session, objectHandle)
END FUNCTION

FUNCTION PythonJson(session AS U64, objectHandle AS U64) AS STRING
    RETURN CALL(DLL, "uxpython.dll", "uxpython_to_json", STRPTR, CDECL, "U64,U64", session, objectHandle)
END FUNCTION

FUNCTION PythonRelease(session AS U64, objectHandle AS U64) AS I32
    RETURN CALL(DLL, "uxpython.dll", "uxpython_release", I32, CDECL, "U64,U64", session, objectHandle)
END FUNCTION

FUNCTION PythonShutdown() AS I32
    RETURN CALL(DLL, "uxpython.dll", "uxpython_shutdown", I32, CDECL)
END FUNCTION
