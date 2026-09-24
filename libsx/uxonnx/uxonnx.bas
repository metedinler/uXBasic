' uxonnx.bas - uXBasic ONNX Runtime wrapper include file
' New keyword yok. INCLUDE + CALL(DLL) tabanlıdır.

NAMESPACE uxonnx

CONST UXONNX_DLL = "uxonnx.dll"

FUNCTION Init(runtimeDir AS STRING) AS I32
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_global_init", I32, CDECL, "STRPTR", runtimeDir)
END FUNCTION

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_runtime_version", STRPTR, CDECL)
END FUNCTION

FUNCTION LastError(session AS U64) AS STRING
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_last_error", STRPTR, CDECL, "PTR", session)
END FUNCTION

FUNCTION SessionCreate(modelPath AS STRING, intraThreads AS I32) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_session_create", PTR, CDECL, "STRPTR,I32", modelPath, intraThreads)
END FUNCTION

SUB SessionFree(session AS U64)
    CALL(DLL, "uxonnx.dll", "uxonnx_session_free", VOID, CDECL, "PTR", session)
END SUB

FUNCTION InputCount(session AS U64) AS I64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_input_count", I64, CDECL, "PTR", session)
END FUNCTION

FUNCTION OutputCount(session AS U64) AS I64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_output_count", I64, CDECL, "PTR", session)
END FUNCTION

FUNCTION InputName(session AS U64, index AS I64) AS STRING
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_input_name", STRPTR, CDECL, "PTR,I64", session, index)
END FUNCTION

FUNCTION OutputName(session AS U64, index AS I64) AS STRING
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_output_name", STRPTR, CDECL, "PTR,I64", session, index)
END FUNCTION

FUNCTION TensorCreate1D(n AS I64) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_create_1d_f32", PTR, CDECL, "I64", n)
END FUNCTION

FUNCTION TensorCreate2D(r AS I64, c AS I64) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_create_2d_f32", PTR, CDECL, "I64,I64", r, c)
END FUNCTION

FUNCTION TensorCreate3D(a AS I64, b AS I64, c AS I64) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_create_3d_f32", PTR, CDECL, "I64,I64,I64", a, b, c)
END FUNCTION

FUNCTION TensorCreate4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_create_4d_f32", PTR, CDECL, "I64,I64,I64,I64", a, b, c, d)
END FUNCTION

SUB TensorFree(t AS U64)
    CALL(DLL, "uxonnx.dll", "uxonnx_tensor_free", VOID, CDECL, "PTR", t)
END SUB

FUNCTION TensorCount(t AS U64) AS I64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_count", I64, CDECL, "PTR", t)
END FUNCTION

FUNCTION TensorRank(t AS U64) AS I64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_rank", I64, CDECL, "PTR", t)
END FUNCTION

FUNCTION TensorDim(t AS U64, axis AS I64) AS I64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_dim", I64, CDECL, "PTR,I64", t, axis)
END FUNCTION

FUNCTION TensorDataPtr(t AS U64) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_data_ptr", PTR, CDECL, "PTR", t)
END FUNCTION

SUB TensorSet(t AS U64, idx AS I64, value AS F64)
    CALL(DLL, "uxonnx.dll", "uxonnx_tensor_set_f32", VOID, CDECL, "PTR,I64,F64", t, idx, value)
END SUB

FUNCTION TensorGet(t AS U64, idx AS I64) AS F64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_tensor_get_f32", F64, CDECL, "PTR,I64", t, idx)
END FUNCTION

FUNCTION Run1(session AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64
    RETURN CALL(DLL, "uxonnx.dll", "uxonnx_run1_f32", PTR, CDECL, "PTR,STRPTR,PTR,STRPTR", session, inputName, inputTensor, outputName)
END FUNCTION

END NAMESPACE
