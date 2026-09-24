' Auto-maintained uXBasic wrapper for uxdatetime.dll
NAMESPACE uxdatetime

CONST DLL_NAME = "uxdatetime.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_version", STRPTR, CDECL)
END FUNCTION

FUNCTION UnixMillisecondsUtc() AS I64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_unix_ms_utc", I64, CDECL)
END FUNCTION

FUNCTION FileTimeUtc() AS U64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_filetime_utc", U64, CDECL)
END FUNCTION

FUNCTION MonotonicTicks() AS I64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_monotonic_ticks", I64, CDECL)
END FUNCTION

FUNCTION MonotonicFrequency() AS I64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_monotonic_frequency", I64, CDECL)
END FUNCTION

FUNCTION FormatUtc(unixMilliseconds AS I64) AS STRING
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_format_utc", STRPTR, CDECL, "I64", unixMilliseconds)
END FUNCTION

FUNCTION FormatLocal(unixMilliseconds AS I64) AS STRING
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_format_local", STRPTR, CDECL, "I64", unixMilliseconds)
END FUNCTION

FUNCTION ParseUtc(iso8601 AS STRING) AS I64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_parse_utc", I64, CDECL, "STRPTR", iso8601)
END FUNCTION

FUNCTION AddMilliseconds(unixMilliseconds AS I64,delta AS I64) AS I64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_add_milliseconds", I64, CDECL, "I64,I64", unixMilliseconds,delta)
END FUNCTION

FUNCTION DifferenceMilliseconds(laterMilliseconds AS I64,earlierMilliseconds AS I64) AS I64
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_difference_ms", I64, CDECL, "I64,I64", laterMilliseconds,earlierMilliseconds)
END FUNCTION

SUB SleepMilliseconds(milliseconds AS U32)
    CALL(DLL, "uxdatetime.dll", "uxdatetime_sleep", VOID, CDECL, "U32", milliseconds)
END SUB

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxdatetime.dll", "uxdatetime_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE