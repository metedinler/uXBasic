' Auto-maintained uXBasic wrapper for uxuuid.dll
NAMESPACE uxuuid

CONST DLL_NAME = "uxuuid.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_version", STRPTR, CDECL)
END FUNCTION

FUNCTION NewUuid() AS STRING
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_new", STRPTR, CDECL)
END FUNCTION

FUNCTION Nil() AS STRING
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_nil", STRPTR, CDECL)
END FUNCTION

FUNCTION IsValid(uuid AS STRING) AS I32
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_is_valid", I32, CDECL, "STRPTR", uuid)
END FUNCTION

FUNCTION Normalize(uuid AS STRING) AS STRING
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_normalize", STRPTR, CDECL, "STRPTR", uuid)
END FUNCTION

FUNCTION Equal(a AS STRING,b AS STRING) AS I32
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_equal", I32, CDECL, "STRPTR,STRPTR", a,b)
END FUNCTION

FUNCTION IsNil(uuid AS STRING) AS I32
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_is_nil", I32, CDECL, "STRPTR", uuid)
END FUNCTION

FUNCTION WithoutBraces(uuid AS STRING) AS STRING
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_without_braces", STRPTR, CDECL, "STRPTR", uuid)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxuuid.dll", "uxuuid_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE