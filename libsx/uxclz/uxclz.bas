' uxclz.dll wrapper: independent C++ OOP registry/runtime.
' This is a second system. It does not replace uXBasic CLASS/vtable.

NAMESPACE uxclz

CONST DLL_NAME = "uxclz.dll"
CONST ABI_VERSION = 65536

CONST TYPE_CLASS = 1
CONST TYPE_INTERFACE = 2
CONST TYPE_VALUE = 4
CONST TYPE_ENTITY = 8
CONST TYPE_COMPONENT = 16
CONST TYPE_ACTOR = 32
CONST TYPE_NATIVE = 64
CONST TYPE_ABSTRACT = 128

CONST VALUE_NULL = 0
CONST VALUE_I64 = 1
CONST VALUE_U64 = 2
CONST VALUE_F64 = 3
CONST VALUE_PTR = 4
CONST VALUE_BOOL = 5
CONST VALUE_STRPTR = 6
CONST VALUE_HANDLE = 7

FUNCTION Version() AS U32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_version", U32, CDECL)
END FUNCTION

FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxclz.dll", "uxclz_last_error", STRPTR, CDECL)
END FUNCTION

FUNCTION ResetRegistry() AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_reset_registry", I32, CDECL)
END FUNCTION

FUNCTION TypeRegister(name AS STRING, baseType AS U32, flags AS U32) AS U32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_type_register", U32, CDECL, "STRPTR,U32,U32", name, baseType, flags)
END FUNCTION

FUNCTION TypeAddInterface(typeId AS U32, interfaceId AS U32) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_type_add_interface", I32, CDECL, "U32,U32", typeId, interfaceId)
END FUNCTION

FUNCTION TypeName(typeId AS U32) AS STRING
    RETURN CALL(DLL, "uxclz.dll", "uxclz_type_name", STRPTR, CDECL, "U32", typeId)
END FUNCTION

FUNCTION TypeIsA(typeId AS U32, expectedType AS U32) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_type_is_a", I32, CDECL, "U32,U32", typeId, expectedType)
END FUNCTION

FUNCTION TypeHasInterface(typeId AS U32, interfaceId AS U32) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_type_has_interface", I32, CDECL, "U32,U32", typeId, interfaceId)
END FUNCTION

FUNCTION TypeMetadataJson(typeId AS U32) AS STRING
    RETURN CALL(DLL, "uxclz.dll", "uxclz_type_metadata_json", STRPTR, CDECL, "U32", typeId)
END FUNCTION

FUNCTION RegistryMetadataJson() AS STRING
    RETURN CALL(DLL, "uxclz.dll", "uxclz_registry_metadata_json", STRPTR, CDECL)
END FUNCTION

FUNCTION MethodRegister(typeId AS U32, methodId AS U32, name AS STRING, functionPointer AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_method_register", I32, CDECL, "U32,U32,STRPTR,PTR", typeId, methodId, name, functionPointer)
END FUNCTION

FUNCTION ObjectWrap(typeId AS U32, payload AS U64, destructorPointer AS U64) AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_wrap", U64, CDECL, "U32,PTR,PTR", typeId, payload, destructorPointer)
END FUNCTION

FUNCTION ObjectRetain(handle AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_retain", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION ObjectRelease(handle AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_release", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION ObjectIsValid(handle AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_is_valid", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION ObjectType(handle AS U64) AS U32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_type", U32, CDECL, "U64", handle)
END FUNCTION

FUNCTION ObjectPayload(handle AS U64) AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_payload", PTR, CDECL, "U64", handle)
END FUNCTION

FUNCTION ObjectQueryInterface(handle AS U64, interfaceId AS U32) AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_object_query_interface", U64, CDECL, "U64,U32", handle, interfaceId)
END FUNCTION

FUNCTION ArgsNew() AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_new", U64, CDECL)
END FUNCTION

SUB ArgsFree(argsHandle AS U64)
    CALL(DLL, "uxclz.dll", "uxclz_args_free", VOID, CDECL, "U64", argsHandle)
END SUB

SUB ArgsClear(argsHandle AS U64)
    CALL(DLL, "uxclz.dll", "uxclz_args_clear", VOID, CDECL, "U64", argsHandle)
END SUB

FUNCTION ArgsCount(argsHandle AS U64) AS U32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_count", U32, CDECL, "U64", argsHandle)
END FUNCTION

FUNCTION ArgsPushI64(argsHandle AS U64, value AS I64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_i64", I32, CDECL, "U64,I64", argsHandle, value)
END FUNCTION

FUNCTION ArgsPushU64(argsHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_u64", I32, CDECL, "U64,U64", argsHandle, value)
END FUNCTION

FUNCTION ArgsPushF64(argsHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_f64", I32, CDECL, "U64,F64", argsHandle, value)
END FUNCTION

FUNCTION ArgsPushPtr(argsHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_ptr", I32, CDECL, "U64,PTR", argsHandle, value)
END FUNCTION

FUNCTION ArgsPushBool(argsHandle AS U64, value AS BOOLEAN) AS I32
    DIM nativeValue AS I32
    nativeValue = 0
    IF value THEN nativeValue = 1
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_bool", I32, CDECL, "U64,I32", argsHandle, nativeValue)
END FUNCTION

FUNCTION ArgsPushString(argsHandle AS U64, value AS STRING) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_strptr", I32, CDECL, "U64,STRPTR", argsHandle, value)
END FUNCTION

FUNCTION ArgsPushHandle(argsHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_args_push_handle", I32, CDECL, "U64,U64", argsHandle, value)
END FUNCTION

FUNCTION ResultNew() AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_new", U64, CDECL)
END FUNCTION

SUB ResultFree(resultHandle AS U64)
    CALL(DLL, "uxclz.dll", "uxclz_result_free", VOID, CDECL, "U64", resultHandle)
END SUB

SUB ResultClear(resultHandle AS U64)
    CALL(DLL, "uxclz.dll", "uxclz_result_clear", VOID, CDECL, "U64", resultHandle)
END SUB

FUNCTION ResultKind(resultHandle AS U64) AS U32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_kind", U32, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION ResultI64(resultHandle AS U64) AS I64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_i64", I64, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION ResultU64(resultHandle AS U64) AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_u64", U64, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION ResultF64(resultHandle AS U64) AS F64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_f64", F64, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION ResultPtr(resultHandle AS U64) AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_ptr", PTR, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION ResultBool(resultHandle AS U64) AS BOOLEAN
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_bool", I32, CDECL, "U64", resultHandle) <> 0
END FUNCTION

FUNCTION ResultString(resultHandle AS U64) AS STRING
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_strptr", STRPTR, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION ResultHandle(resultHandle AS U64) AS U64
    RETURN CALL(DLL, "uxclz.dll", "uxclz_result_handle", U64, CDECL, "U64", resultHandle)
END FUNCTION

FUNCTION InvokeArgs(objectHandle AS U64, methodId AS U32, argsHandle AS U64, resultHandle AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_invoke_args", I32, CDECL, "U64,U32,U64,U64", objectHandle, methodId, argsHandle, resultHandle)
END FUNCTION

FUNCTION MultimethodRegister(methodId AS U32, leftType AS U32, rightType AS U32, name AS STRING, functionPointer AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_multimethod_register", I32, CDECL, "U32,U32,U32,STRPTR,PTR", methodId, leftType, rightType, name, functionPointer)
END FUNCTION

FUNCTION MultimethodInvokeArgs(methodId AS U32, leftHandle AS U64, rightHandle AS U64, argsHandle AS U64, resultHandle AS U64) AS I32
    RETURN CALL(DLL, "uxclz.dll", "uxclz_multimethod_invoke_args", I32, CDECL, "U32,U64,U64,U64,U64", methodId, leftHandle, rightHandle, argsHandle, resultHandle)
END FUNCTION

END NAMESPACE
