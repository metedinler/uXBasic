NAMESPACE uxlogic
FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_version", I32, CDECL)
END FUNCTION
FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_last_error", STRPTR, CDECL)
END FUNCTION
FUNCTION LastText() AS STRING
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_last_text", STRPTR, CDECL)
END FUNCTION
FUNCTION LuaLoad(dllPath AS STRING) AS I32
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_lua_load", I32, CDECL, "STRPTR", dllPath)
END FUNCTION
FUNCTION LuaNew() AS U64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_lua_new", U64, CDECL)
END FUNCTION
SUB LuaClose(state AS U64)
    CALL(DLL, "uxlogic.dll", "uxlogic_lua_close", VOID, CDECL, "U64", state)
END SUB
FUNCTION LuaDoString(state AS U64, code AS STRING) AS I32
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_lua_do_string", I32, CDECL, "U64,STRPTR", state, code)
END FUNCTION
FUNCTION LuaDoFile(state AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_lua_do_file", I32, CDECL, "U64,STRPTR", state, path)
END FUNCTION
FUNCTION LuaGetNumber(state AS U64, name AS STRING) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_lua_get_number", F64, CDECL, "U64,STRPTR", state, name)
END FUNCTION
FUNCTION LuaGetString(state AS U64, name AS STRING) AS STRING
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_lua_get_string", STRPTR, CDECL, "U64,STRPTR", state, name)
END FUNCTION
SUB LuaSetNumber(state AS U64, name AS STRING, value AS F64)
    CALL(DLL, "uxlogic.dll", "uxlogic_lua_set_number", VOID, CDECL, "U64,STRPTR,F64", state, name, value)
END SUB
FUNCTION PrologQuery(scriptPath AS STRING, goal AS STRING) AS I32
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_prolog_query", I32, CDECL, "STRPTR,STRPTR", scriptPath, goal)
END FUNCTION
FUNCTION PrologQueryWith(swiplPath AS STRING, scriptPath AS STRING, goal AS STRING) AS I32
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_prolog_query_ex", I32, CDECL, "STRPTR,STRPTR,STRPTR", swiplPath, scriptPath, goal)
END FUNCTION
FUNCTION Triangle(x AS F64, a AS F64, b AS F64, c AS F64) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_fuzzy_triangle", F64, CDECL, "F64,F64,F64,F64", x, a, b, c)
END FUNCTION
FUNCTION Trapezoid(x AS F64, a AS F64, b AS F64, c AS F64, d AS F64) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_fuzzy_trapezoid", F64, CDECL, "F64,F64,F64,F64,F64", x, a, b, c, d)
END FUNCTION
FUNCTION FuzzyAnd(a AS F64, b AS F64) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_fuzzy_and", F64, CDECL, "F64,F64", a, b)
END FUNCTION
FUNCTION FuzzyOr(a AS F64, b AS F64) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_fuzzy_or", F64, CDECL, "F64,F64", a, b)
END FUNCTION
FUNCTION FuzzyNot(value AS F64) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_fuzzy_not", F64, CDECL, "F64", value)
END FUNCTION
FUNCTION Weighted(value1 AS F64, weight1 AS F64, value2 AS F64, weight2 AS F64) AS F64
    RETURN CALL(DLL, "uxlogic.dll", "uxlogic_fuzzy_weighted", F64, CDECL, "F64,F64,F64,F64", value1, weight1, value2, weight2)
END FUNCTION
END NAMESPACE
