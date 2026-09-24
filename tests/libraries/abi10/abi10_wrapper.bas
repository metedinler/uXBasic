FUNCTION ABI10_Version() AS I32
    RETURN CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_version", I32, CDECL)
END FUNCTION

FUNCTION ABI10_Text() AS STRING
    RETURN CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_text", STRPTR, CDECL)
END FUNCTION

FUNCTION ABI10_Sum10(a0 AS I32, a1 AS I32, a2 AS I32, a3 AS I32, a4 AS I32, a5 AS I32, a6 AS I32, a7 AS I32, a8 AS I32, a9 AS I32) AS I32
    RETURN CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_sum10", I32, CDECL, "I32,I32,I32,I32,I32,I32,I32,I32,I32,I32", a0,a1,a2,a3,a4,a5,a6,a7,a8,a9)
END FUNCTION

FUNCTION ABI10_Mix8(a AS F64, b AS I32, c AS F64, d AS I32, e AS F64, f AS I32, g AS F64, h AS I32) AS F64
    RETURN CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_mix8", F64, CDECL, "F64,I32,F64,I32,F64,I32,F64,I32", a,b,c,d,e,f,g,h)
END FUNCTION

FUNCTION ABI10_PointCreate(x AS F64, y AS F64) AS U64
    RETURN CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_point_create", PTR, CDECL, "F64,F64", x,y)
END FUNCTION

FUNCTION ABI10_PointSum(h AS U64) AS F64
    RETURN CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_point_sum", F64, CDECL, "PTR", h)
END FUNCTION

SUB ABI10_PointFree(h AS U64)
    CALL(DLL, "uxb_abi10_test.dll", "uxb_abi10_point_free", VOID, CDECL, "PTR", h)
END SUB
