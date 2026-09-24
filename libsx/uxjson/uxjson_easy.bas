NAMESPACE uxjson

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxjson.dll", "uxjson_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Parse(text AS STRING) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_parse", PTR, CDECL, "STRPTR", text)
END FUNCTION

SUB Free(doc AS U64)
    CALL(DLL, "uxjson.dll", "uxjson_free", VOID, CDECL, "PTR", doc)
END SUB

FUNCTION Root(doc AS U64) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_root", PTR, CDECL, "PTR", doc)
END FUNCTION

FUNCTION PointerGet(doc AS U64, pointer AS STRING) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_pointer_get", PTR, CDECL, "PTR,STRPTR", doc, pointer)
END FUNCTION

FUNCTION ObjectGet(value AS U64, key AS STRING) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_object_get", PTR, CDECL, "PTR,STRPTR", value, key)
END FUNCTION

FUNCTION ArrayGet(value AS U64, index0 AS U64) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_array_get", PTR, CDECL, "PTR,U64", value, index0)
END FUNCTION

FUNCTION ArraySize(value AS U64) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_array_size", U64, CDECL, "PTR", value)
END FUNCTION

FUNCTION ValueType(value AS U64) AS I32
    RETURN CALL(DLL, "uxjson.dll", "uxjson_type", I32, CDECL, "PTR", value)
END FUNCTION

FUNCTION GetString(value AS U64) AS STRING
    RETURN CALL(DLL, "uxjson.dll", "uxjson_get_string", STRPTR, CDECL, "PTR", value)
END FUNCTION

FUNCTION GetI64(value AS U64) AS I64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_get_i64", I64, CDECL, "PTR", value)
END FUNCTION

FUNCTION GetU64(value AS U64) AS U64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_get_u64", U64, CDECL, "PTR", value)
END FUNCTION

FUNCTION GetF64(value AS U64) AS F64
    RETURN CALL(DLL, "uxjson.dll", "uxjson_get_f64", F64, CDECL, "PTR", value)
END FUNCTION

FUNCTION GetBoolean(value AS U64) AS I32
    RETURN CALL(DLL, "uxjson.dll", "uxjson_get_bool", I32, CDECL, "PTR", value)
END FUNCTION

FUNCTION Write(doc AS U64, pretty AS I32) AS STRING
    RETURN CALL(DLL, "uxjson.dll", "uxjson_write", STRPTR, CDECL, "PTR,I32", doc, pretty)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxjson.dll", "uxjson_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
