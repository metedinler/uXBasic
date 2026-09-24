NAMESPACE uxregex

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxregex.dll", "uxregex_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Compile(pattern AS STRING, options AS U32) AS U64
    RETURN CALL(DLL, "uxregex.dll", "uxregex_compile", PTR, CDECL, "STRPTR,U32", pattern, options)
END FUNCTION

SUB Free(regex AS U64)
    CALL(DLL, "uxregex.dll", "uxregex_free", VOID, CDECL, "PTR", regex)
END SUB

FUNCTION Match(regex AS U64, subject AS STRING, startOffset AS U64, options AS U32) AS I32
    RETURN CALL(DLL, "uxregex.dll", "uxregex_match", I32, CDECL, "PTR,STRPTR,U64,U32", regex, subject, startOffset, options)
END FUNCTION

FUNCTION IsMatch(regex AS U64, subject AS STRING) AS I32
    RETURN CALL(DLL, "uxregex.dll", "uxregex_is_match", I32, CDECL, "PTR,STRPTR", regex, subject)
END FUNCTION

FUNCTION GroupCount(regex AS U64) AS I32
    RETURN CALL(DLL, "uxregex.dll", "uxregex_group_count", I32, CDECL, "PTR", regex)
END FUNCTION

FUNCTION GroupStart(regex AS U64, group AS I32) AS I64
    RETURN CALL(DLL, "uxregex.dll", "uxregex_group_start", I64, CDECL, "PTR,I32", regex, group)
END FUNCTION

FUNCTION GroupEnd(regex AS U64, group AS I32) AS I64
    RETURN CALL(DLL, "uxregex.dll", "uxregex_group_end", I64, CDECL, "PTR,I32", regex, group)
END FUNCTION

FUNCTION GroupText(regex AS U64, subject AS STRING, group AS I32) AS STRING
    RETURN CALL(DLL, "uxregex.dll", "uxregex_group_text", STRPTR, CDECL, "PTR,STRPTR,I32", regex, subject, group)
END FUNCTION

FUNCTION ErrorText(regex AS U64) AS STRING
    RETURN CALL(DLL, "uxregex.dll", "uxregex_error", STRPTR, CDECL, "PTR", regex)
END FUNCTION

END NAMESPACE
