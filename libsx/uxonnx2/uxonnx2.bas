' uxonnx2.bas - Advanced ONNX Runtime wrapper for uXBasic
' New keyword yok. INCLUDE + CALL(DLL) tabanlıdır.

NAMESPACE uxonnx2

CONST UXONNX2_DLL = "uxonnx2.dll"

CONST DTYPE_F32 = 1
CONST DTYPE_F64 = 2
CONST DTYPE_I64 = 3
CONST DTYPE_I32 = 4
CONST DTYPE_STRING = 5

CONST PROVIDER_CPU = 0
CONST PROVIDER_DIRECTML = 1
CONST PROVIDER_CUDA = 2
CONST PROVIDER_AUTO = 99

CONST GRAPH_DISABLE_ALL = 0
CONST GRAPH_BASIC = 1
CONST GRAPH_EXTENDED = 2
CONST GRAPH_ALL = 99

FUNCTION Init(runtimeDir AS STRING) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_init", I32, CDECL, "STRPTR", runtimeDir)
END FUNCTION

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_version", STRPTR, CDECL)
END FUNCTION

FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_last_error", STRPTR, CDECL)
END FUNCTION

FUNCTION ProviderAvailable(provider AS I32) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_provider_available", I32, CDECL, "I32", provider)
END FUNCTION

FUNCTION SessionCreate(modelPath AS STRING) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_create", PTR, CDECL, "STRPTR", modelPath)
END FUNCTION

FUNCTION SessionCreateAdvanced(modelPath AS STRING, provider AS I32, intraThreads AS I32, interThreads AS I32, graphOpt AS I32) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_create_advanced", PTR, CDECL, "STRPTR,I32,I32,I32,I32", modelPath, provider, intraThreads, interThreads, graphOpt)
END FUNCTION

SUB SessionFree(s AS U64)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_session_free", VOID, CDECL, "PTR", s)
END SUB

FUNCTION InputCount(s AS U64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_input_count", I64, CDECL, "PTR", s)
END FUNCTION

FUNCTION OutputCount(s AS U64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_output_count", I64, CDECL, "PTR", s)
END FUNCTION

FUNCTION InputName(s AS U64, idx AS I64) AS STRING
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_input_name", STRPTR, CDECL, "PTR,I64", s, idx)
END FUNCTION

FUNCTION OutputName(s AS U64, idx AS I64) AS STRING
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_output_name", STRPTR, CDECL, "PTR,I64", s, idx)
END FUNCTION

FUNCTION InputDType(s AS U64, idx AS I64) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_input_dtype", I32, CDECL, "PTR,I64", s, idx)
END FUNCTION

FUNCTION OutputDType(s AS U64, idx AS I64) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_output_dtype", I32, CDECL, "PTR,I64", s, idx)
END FUNCTION

FUNCTION InputRank(s AS U64, idx AS I64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_input_rank", I64, CDECL, "PTR,I64", s, idx)
END FUNCTION

FUNCTION OutputRank(s AS U64, idx AS I64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_output_rank", I64, CDECL, "PTR,I64", s, idx)
END FUNCTION

FUNCTION InputDim(s AS U64, idx AS I64, axis AS I64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_input_dim", I64, CDECL, "PTR,I64,I64", s, idx, axis)
END FUNCTION

FUNCTION OutputDim(s AS U64, idx AS I64, axis AS I64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_session_output_dim", I64, CDECL, "PTR,I64,I64", s, idx, axis)
END FUNCTION

FUNCTION TensorCreate1D(dtype AS I32, n AS I64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_create_1d", PTR, CDECL, "I32,I64", dtype, n)
END FUNCTION

FUNCTION TensorCreate2D(dtype AS I32, r AS I64, c AS I64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_create_2d", PTR, CDECL, "I32,I64,I64", dtype, r, c)
END FUNCTION

FUNCTION TensorCreate3D(dtype AS I32, a AS I64, b AS I64, c AS I64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_create_3d", PTR, CDECL, "I32,I64,I64,I64", dtype, a, b, c)
END FUNCTION

FUNCTION TensorCreate4D(dtype AS I32, a AS I64, b AS I64, c AS I64, d AS I64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_create_4d", PTR, CDECL, "I32,I64,I64,I64,I64", dtype, a, b, c, d)
END FUNCTION

SUB TensorFree(t AS U64)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_free", VOID, CDECL, "PTR", t)
END SUB

FUNCTION TensorDType(t AS U64) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_dtype", I32, CDECL, "PTR", t)
END FUNCTION

FUNCTION TensorRank(t AS U64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_rank", I64, CDECL, "PTR", t)
END FUNCTION

FUNCTION TensorDim(t AS U64, axis AS I64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_dim", I64, CDECL, "PTR,I64", t, axis)
END FUNCTION

FUNCTION TensorCount(t AS U64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_count", I64, CDECL, "PTR", t)
END FUNCTION

FUNCTION TensorDataPtr(t AS U64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_data_ptr", PTR, CDECL, "PTR", t)
END FUNCTION

SUB TensorSetF64(t AS U64, idx AS I64, value AS F64)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_set_f64", VOID, CDECL, "PTR,I64,F64", t, idx, value)
END SUB

FUNCTION TensorGetF64(t AS U64, idx AS I64) AS F64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_get_f64", F64, CDECL, "PTR,I64", t, idx)
END FUNCTION

SUB TensorSetI64(t AS U64, idx AS I64, value AS I64)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_set_i64", VOID, CDECL, "PTR,I64,I64", t, idx, value)
END SUB

FUNCTION TensorGetI64(t AS U64, idx AS I64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_get_i64", I64, CDECL, "PTR,I64", t, idx)
END FUNCTION

SUB TensorSetString(t AS U64, idx AS I64, value AS STRING)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_set_string", VOID, CDECL, "PTR,I64,STRPTR", t, idx, value)
END SUB

FUNCTION TensorGetString(t AS U64, idx AS I64) AS STRING
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_tensor_get_string", STRPTR, CDECL, "PTR,I64", t, idx)
END FUNCTION

FUNCTION RunCreate(s AS U64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_run_create", PTR, CDECL, "PTR", s)
END FUNCTION

SUB RunFree(r AS U64)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_run_free", VOID, CDECL, "PTR", r)
END SUB

FUNCTION RunAddInput(r AS U64, name AS STRING, t AS U64) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_run_add_input", I32, CDECL, "PTR,STRPTR,PTR", r, name, t)
END FUNCTION

FUNCTION RunAddOutput(r AS U64, name AS STRING) AS I32
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_run_add_output", I32, CDECL, "PTR,STRPTR", r, name)
END FUNCTION

FUNCTION RunExecute(r AS U64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_run_execute", PTR, CDECL, "PTR", r)
END FUNCTION

SUB ResultFree(res AS U64)
    CALL(DLL, "uxonnx2.dll", "uxonnx2_result_free", VOID, CDECL, "PTR", res)
END SUB

FUNCTION ResultCount(res AS U64) AS I64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_result_count", I64, CDECL, "PTR", res)
END FUNCTION

FUNCTION ResultTensor(res AS U64, idx AS I64) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_result_tensor", PTR, CDECL, "PTR,I64", res, idx)
END FUNCTION

FUNCTION Run1(s AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64
    RETURN CALL(DLL, "uxonnx2.dll", "uxonnx2_run1", PTR, CDECL, "PTR,STRPTR,PTR,STRPTR", s, inputName, inputTensor, outputName)
END FUNCTION

END NAMESPACE
