NAMESPACE uxhttp

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Open() AS U64
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_open", PTR, CDECL)
END FUNCTION

SUB Close(h AS U64)
    CALL(DLL, "uxhttp.dll", "uxhttp_close", VOID, CDECL, "PTR", h)
END SUB

FUNCTION SetUrl(h AS U64, url AS STRING) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_set_url", I32, CDECL, "PTR,STRPTR", h, url)
END FUNCTION

FUNCTION SetMethod(h AS U64, methodName AS STRING) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_set_method", I32, CDECL, "PTR,STRPTR", h, methodName)
END FUNCTION

FUNCTION AddHeader(h AS U64, header AS STRING) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_add_header", I32, CDECL, "PTR,STRPTR", h, header)
END FUNCTION

FUNCTION SetBody(h AS U64, body AS STRING) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_set_body", I32, CDECL, "PTR,STRPTR", h, body)
END FUNCTION

FUNCTION SetTimeout(h AS U64, timeoutMs AS I64) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_set_timeout_ms", I32, CDECL, "PTR,I64", h, timeoutMs)
END FUNCTION

FUNCTION FollowRedirects(h AS U64, enabled AS I32) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_set_follow_redirects", I32, CDECL, "PTR,I32", h, enabled)
END FUNCTION

FUNCTION Perform(h AS U64) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_perform", I32, CDECL, "PTR", h)
END FUNCTION

FUNCTION Status(h AS U64) AS I64
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_status", I64, CDECL, "PTR", h)
END FUNCTION

FUNCTION ResponseText(h AS U64) AS STRING
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_response_text", STRPTR, CDECL, "PTR", h)
END FUNCTION

FUNCTION ResponseSize(h AS U64) AS U64
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_response_size", U64, CDECL, "PTR", h)
END FUNCTION

FUNCTION SaveResponse(h AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_save_response", I32, CDECL, "PTR,STRPTR", h, path)
END FUNCTION

FUNCTION ErrorText(h AS U64) AS STRING
    RETURN CALL(DLL, "uxhttp.dll", "uxhttp_error", STRPTR, CDECL, "PTR", h)
END FUNCTION

END NAMESPACE
