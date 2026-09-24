' Auto-maintained uXBasic wrapper for uxconfig.dll
NAMESPACE uxconfig

CONST DLL_NAME = "uxconfig.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Open(path AS STRING) AS U64
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_open", U64, CDECL, "STRPTR", path)
END FUNCTION

SUB Close(handle AS U64)
    CALL(DLL, "uxconfig.dll", "uxconfig_close", VOID, CDECL, "U64", handle)
END SUB

FUNCTION GetString(handle AS U64,section AS STRING,key AS STRING,defaultValue AS STRING) AS STRING
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_get_string", STRPTR, CDECL, "U64,STRPTR,STRPTR,STRPTR", handle, section, key, defaultValue)
END FUNCTION

FUNCTION GetI64(handle AS U64,section AS STRING,key AS STRING,defaultValue AS I64) AS I64
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_get_i64", I64, CDECL, "U64,STRPTR,STRPTR,I64", handle, section, key, defaultValue)
END FUNCTION

FUNCTION GetF64(handle AS U64,section AS STRING,key AS STRING,defaultValue AS F64) AS F64
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_get_f64", F64, CDECL, "U64,STRPTR,STRPTR,F64", handle, section, key, defaultValue)
END FUNCTION

FUNCTION GetBoolean(handle AS U64,section AS STRING,key AS STRING,defaultValue AS I32) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_get_bool", I32, CDECL, "U64,STRPTR,STRPTR,I32", handle, section, key, defaultValue)
END FUNCTION

FUNCTION SetString(handle AS U64,section AS STRING,key AS STRING,value AS STRING) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_set_string", I32, CDECL, "U64,STRPTR,STRPTR,STRPTR", handle, section, key, value)
END FUNCTION

FUNCTION SetI64(handle AS U64,section AS STRING,key AS STRING,value AS I64) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_set_i64", I32, CDECL, "U64,STRPTR,STRPTR,I64", handle, section, key, value)
END FUNCTION

FUNCTION SetF64(handle AS U64,section AS STRING,key AS STRING,value AS F64) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_set_f64", I32, CDECL, "U64,STRPTR,STRPTR,F64", handle, section, key, value)
END FUNCTION

FUNCTION SetBoolean(handle AS U64,section AS STRING,key AS STRING,value AS I32) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_set_bool", I32, CDECL, "U64,STRPTR,STRPTR,I32", handle, section, key, value)
END FUNCTION

FUNCTION DeleteKey(handle AS U64,section AS STRING,key AS STRING) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_delete_key", I32, CDECL, "U64,STRPTR,STRPTR", handle, section, key)
END FUNCTION

FUNCTION DeleteSection(handle AS U64,section AS STRING) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_delete_section", I32, CDECL, "U64,STRPTR", handle, section)
END FUNCTION

FUNCTION HasKey(handle AS U64,section AS STRING,key AS STRING) AS I32
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_has_key", I32, CDECL, "U64,STRPTR,STRPTR", handle, section, key)
END FUNCTION

FUNCTION Path(handle AS U64) AS STRING
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_path", STRPTR, CDECL, "U64", handle)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxconfig.dll", "uxconfig_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
