' uXBasic uxllama CPU text-completion wrapper.
' Uses uxllama.dll -> llama-cli.exe bridge. No new keyword required.

NAMESPACE uxllama

CONST DLL_NAME = "uxllama.dll"
CONST PROFILE_TINY = 0
CONST PROFILE_LOW  = 1
CONST PROFILE_NORMAL = 2

FUNCTION Create() AS U64
    RETURN CALL(DLL, "uxllama.dll", "uxllama_create", PTR, CDECL)
END FUNCTION

SUB Free(h AS U64)
    CALL(DLL, "uxllama.dll", "uxllama_free", VOID, CDECL, "PTR", h)
END SUB

FUNCTION SetCliPath(h AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_cli_path", I32, CDECL, "PTR,STRPTR", h, path)
END FUNCTION

FUNCTION SetModelPath(h AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_model_path", I32, CDECL, "PTR,STRPTR", h, path)
END FUNCTION

FUNCTION SetThreads(h AS U64, n AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_threads", I32, CDECL, "PTR,I32", h, n)
END FUNCTION

FUNCTION SetContext(h AS U64, n AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_context", I32, CDECL, "PTR,I32", h, n)
END FUNCTION

FUNCTION SetPredict(h AS U64, n AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_predict", I32, CDECL, "PTR,I32", h, n)
END FUNCTION

FUNCTION SetTemperature(h AS U64, t AS F64) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_temperature", I32, CDECL, "PTR,F64", h, t)
END FUNCTION

FUNCTION SetTopP(h AS U64, p AS F64) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_top_p", I32, CDECL, "PTR,F64", h, p)
END FUNCTION

FUNCTION SetTopK(h AS U64, k AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_top_k", I32, CDECL, "PTR,I32", h, k)
END FUNCTION

FUNCTION SetSeed(h AS U64, seed AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_seed", I32, CDECL, "PTR,I32", h, seed)
END FUNCTION

FUNCTION LowMemoryProfile(h AS U64, profile AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_set_low_memory_profile", I32, CDECL, "PTR,I32", h, profile)
END FUNCTION

FUNCTION ModelExists(h AS U64) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_model_exists", I32, CDECL, "PTR", h)
END FUNCTION

FUNCTION Prompt(h AS U64, prompt AS STRING, outBuf AS U64, outBytes AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_prompt", I32, CDECL, "PTR,STRPTR,PTR,I32", h, prompt, outBuf, outBytes)
END FUNCTION

FUNCTION PromptFile(h AS U64, promptFile AS STRING, outBuf AS U64, outBytes AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_prompt_file", I32, CDECL, "PTR,STRPTR,PTR,I32", h, promptFile, outBuf, outBytes)
END FUNCTION

FUNCTION LastError(h AS U64, outBuf AS U64, outBytes AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_last_error", I32, CDECL, "PTR,PTR,I32", h, outBuf, outBytes)
END FUNCTION

FUNCTION LastCommand(h AS U64, outBuf AS U64, outBytes AS I32) AS I32
    RETURN CALL(DLL, "uxllama.dll", "uxllama_last_command", I32, CDECL, "PTR,PTR,I32", h, outBuf, outBytes)
END FUNCTION

END NAMESPACE
