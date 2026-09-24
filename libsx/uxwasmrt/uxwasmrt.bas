FUNCTION WasmRuntimeApiVersion() AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_version", I32, CDECL)
END FUNCTION

FUNCTION WasmProvider() AS STRING
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_provider", STRPTR, CDECL)
END FUNCTION

FUNCTION WasmRuntimeAvailable() AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_runtime_available", I32, CDECL)
END FUNCTION

FUNCTION WasmRuntimePath() AS STRING
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_runtime_path", STRPTR, CDECL)
END FUNCTION

FUNCTION WasmValidateFile(pathValue AS STRING) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_validate_file", I32, CDECL, "STRPTR", pathValue)
END FUNCTION

FUNCTION WasmOpenFile(pathValue AS STRING) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_open_file", I32, CDECL, "STRPTR", pathValue)
END FUNCTION

FUNCTION WasmClose(sessionHandle AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_close", I32, CDECL, "I32", sessionHandle)
END FUNCTION

FUNCTION WasmHasExport(sessionHandle AS I32, exportName AS STRING) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_has_export", I32, CDECL, "I32,STRPTR", sessionHandle, exportName)
END FUNCTION

FUNCTION WasmCallI32_0(sessionHandle AS I32, exportName AS STRING) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_call_i32_0", I32, CDECL, "I32,STRPTR", sessionHandle, exportName)
END FUNCTION

FUNCTION WasmCallI32_1(sessionHandle AS I32, exportName AS STRING, a0 AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_call_i32_1", I32, CDECL, "I32,STRPTR,I32", sessionHandle, exportName, a0)
END FUNCTION

FUNCTION WasmCallI32_2(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_call_i32_2", I32, CDECL, "I32,STRPTR,I32,I32", sessionHandle, exportName, a0, a1)
END FUNCTION

FUNCTION WasmCallI32_3(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32, a2 AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_call_i32_3", I32, CDECL, "I32,STRPTR,I32,I32,I32", sessionHandle, exportName, a0, a1, a2)
END FUNCTION

FUNCTION WasmCallI32_4(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32, a2 AS I32, a3 AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_call_i32_4", I32, CDECL, "I32,STRPTR,I32,I32,I32,I32", sessionHandle, exportName, a0, a1, a2, a3)
END FUNCTION

FUNCTION WasmLastOk(sessionHandle AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_last_ok", I32, CDECL, "I32", sessionHandle)
END FUNCTION

FUNCTION WasmLastErrorCode(sessionHandle AS I32) AS I32
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_last_error_code", I32, CDECL, "I32", sessionHandle)
END FUNCTION

FUNCTION WasmLastError(sessionHandle AS I32) AS STRING
    RETURN CALL(DLL, "uxwasmrt.dll", "uxwasm_last_error", STRPTR, CDECL, "I32", sessionHandle)
END FUNCTION
