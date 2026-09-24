NAMESPACE uxarchive

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxarchive.dll", "uxarchive_version", STRPTR, CDECL)
END FUNCTION

FUNCTION EntryCount(path AS STRING) AS I64
    RETURN CALL(DLL, "uxarchive.dll", "uxarchive_count", I64, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION ExtractAll(path AS STRING, destination AS STRING) AS I64
    RETURN CALL(DLL, "uxarchive.dll", "uxarchive_extract_all", I64, CDECL, "STRPTR,STRPTR", path, destination)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxarchive.dll", "uxarchive_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
