FUNCTION JsRuntimeApiVersion() AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_version", I32, CDECL)
END FUNCTION

FUNCTION JsContractVersion() AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_contract_version", I32, CDECL)
END FUNCTION

FUNCTION JsQuickJsVersion() AS STRING
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_quickjs_version", STRPTR, CDECL)
END FUNCTION

FUNCTION JsEvalScriptFlag() AS I32
    RETURN 0
END FUNCTION

FUNCTION JsEvalModuleFlag() AS I32
    RETURN 1
END FUNCTION

FUNCTION JsEvalDrainJobsFlag() AS I32
    RETURN 2
END FUNCTION

FUNCTION JsRuntimeCreate() AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_runtime_create", I32, CDECL)
END FUNCTION

FUNCTION JsRuntimeFree(runtimeHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_runtime_free", I32, CDECL, "I32", runtimeHandle)
END FUNCTION

FUNCTION JsRuntimeMemoryLimitMb(runtimeHandle AS I32, megabytes AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_runtime_set_memory_limit_mb", I32, CDECL, "I32,I32", runtimeHandle, megabytes)
END FUNCTION

FUNCTION JsRuntimeStackLimitKb(runtimeHandle AS I32, kilobytes AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_runtime_set_stack_limit_kb", I32, CDECL, "I32,I32", runtimeHandle, kilobytes)
END FUNCTION

FUNCTION JsRuntimeTimeLimitMs(runtimeHandle AS I32, milliseconds AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_runtime_set_time_limit_ms", I32, CDECL, "I32,I32", runtimeHandle, milliseconds)
END FUNCTION

FUNCTION JsRuntimeCollectGarbage(runtimeHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_runtime_collect_garbage", I32, CDECL, "I32", runtimeHandle)
END FUNCTION

FUNCTION JsContextCreate(runtimeHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_context_create", I32, CDECL, "I32", runtimeHandle)
END FUNCTION

FUNCTION JsContextFree(contextHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_context_free", I32, CDECL, "I32", contextHandle)
END FUNCTION

FUNCTION JsInstallNativeHost(contextHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_install_native_host", I32, CDECL, "I32", contextHandle)
END FUNCTION

FUNCTION JsBootstrapUxb(contextHandle AS I32, corePath AS STRING, providerPath AS STRING) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_bootstrap_uxb", I32, CDECL, "I32,STRPTR,STRPTR", contextHandle, corePath, providerPath)
END FUNCTION

FUNCTION JsEval(contextHandle AS I32, sourceText AS STRING, filename AS STRING, flags AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_eval", I32, CDECL, "I32,STRPTR,STRPTR,I32", contextHandle, sourceText, filename, flags)
END FUNCTION

FUNCTION JsEvalFile(contextHandle AS I32, pathValue AS STRING, flags AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_eval_file", I32, CDECL, "I32,STRPTR,I32", contextHandle, pathValue, flags)
END FUNCTION

FUNCTION JsPumpJobs(runtimeHandle AS I32, maxJobs AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_execute_pending_jobs", I32, CDECL, "I32,I32", runtimeHandle, maxJobs)
END FUNCTION

FUNCTION JsCall(contextHandle AS I32, functionName AS STRING, argumentsJson AS STRING) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_call_json", I32, CDECL, "I32,STRPTR,STRPTR", contextHandle, functionName, argumentsJson)
END FUNCTION

FUNCTION JsCallAwait(contextHandle AS I32, functionName AS STRING, argumentsJson AS STRING, maxJobs AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_call_json_await", I32, CDECL, "I32,STRPTR,STRPTR,I32", contextHandle, functionName, argumentsJson, maxJobs)
END FUNCTION

FUNCTION JsResultJson(contextHandle AS I32, resultHandle AS I32) AS STRING
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_result_json", STRPTR, CDECL, "I32,I32", contextHandle, resultHandle)
END FUNCTION

FUNCTION JsResultFree(contextHandle AS I32, resultHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_result_free", I32, CDECL, "I32,I32", contextHandle, resultHandle)
END FUNCTION

FUNCTION JsLastError(contextHandle AS I32) AS STRING
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_last_error", STRPTR, CDECL, "I32", contextHandle)
END FUNCTION

FUNCTION JsClearError(contextHandle AS I32) AS I32
    RETURN CALL(DLL, "uxjsrt.dll", "uxjs_context_clear_error", I32, CDECL, "I32", contextHandle)
END FUNCTION
