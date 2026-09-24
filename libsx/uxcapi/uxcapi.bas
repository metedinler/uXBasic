' uXBasic C ABI runtime wrapper v2.
' STRUCT descriptors support natural C ABI by-value arguments and returns.
' UNION values use shared memory/pointer or a generated C adapter for by-value calls.
' All exported calls preserve CALL(DLL) ABI10-safe scalar shapes.

NAMESPACE uxcapi

CONST KIND_VOID = 0
CONST KIND_I8 = 1
CONST KIND_U8 = 2
CONST KIND_I16 = 3
CONST KIND_U16 = 4
CONST KIND_I32 = 5
CONST KIND_U32 = 6
CONST KIND_I64 = 7
CONST KIND_U64 = 8
CONST KIND_F32 = 9
CONST KIND_F64 = 10
CONST KIND_PTR = 11
CONST KIND_STRPTR = 12
CONST KIND_WSTRPTR = 13
CONST KIND_LONGDOUBLE = 14
CONST KIND_STRUCT = 15
CONST KIND_UNION = 16

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_version", I32, CDECL)
END FUNCTION

FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_last_error", STRPTR, CDECL)
END FUNCTION

SUB Shutdown()
    CALL(DLL, "uxcapi.dll", "uxcapi_shutdown", VOID, CDECL)
END SUB

FUNCTION SymbolAddress(dllName AS STRING, symbolName AS STRING) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_symbol_address", PTR, CDECL, "STRPTR,STRPTR", dllName, symbolName)
END FUNCTION

FUNCTION TypeStructNew() AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_struct_new", PTR, CDECL)
END FUNCTION

FUNCTION TypeUnionNew(sizeBytes AS U64, alignmentBytes AS U32) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_union_new", PTR, CDECL, "U64,U32", sizeBytes, U32(alignmentBytes))
END FUNCTION

FUNCTION TypeAddField(typeHandle AS U64, fieldKind AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_add_field", I32, CDECL, "PTR,I32", typeHandle, fieldKind)
END FUNCTION

FUNCTION TypeAddStructField(typeHandle AS U64, fieldTypeHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_add_struct_field", I32, CDECL, "PTR,PTR", typeHandle, fieldTypeHandle)
END FUNCTION

FUNCTION TypeAddArrayField(typeHandle AS U64, elementKind AS I32, elementCount AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_add_array_field", I32, CDECL, "PTR,I32,U64", typeHandle, elementKind, elementCount)
END FUNCTION

FUNCTION TypeAddStructArrayField(typeHandle AS U64, fieldTypeHandle AS U64, elementCount AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_add_struct_array_field", I32, CDECL, "PTR,PTR,U64", typeHandle, fieldTypeHandle, elementCount)
END FUNCTION

FUNCTION TypeSetExpectedLayout(typeHandle AS U64, sizeBytes AS U64, alignmentBytes AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_set_expected_layout", I32, CDECL, "PTR,U64,U32", typeHandle, sizeBytes, U32(alignmentBytes))
END FUNCTION

FUNCTION TypeFinalize(typeHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_finalize", I32, CDECL, "PTR", typeHandle)
END FUNCTION

FUNCTION TypeKind(typeHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_kind", I32, CDECL, "PTR", typeHandle)
END FUNCTION

FUNCTION TypeSize(typeHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_size", U64, CDECL, "PTR", typeHandle)
END FUNCTION

FUNCTION TypeAlignment(typeHandle AS U64) AS U32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_type_alignment", U32, CDECL, "PTR", typeHandle)
END FUNCTION

SUB TypeFree(typeHandle AS U64)
    CALL(DLL, "uxcapi.dll", "uxcapi_type_free", VOID, CDECL, "PTR", typeHandle)
END SUB

FUNCTION CallNew(dllName AS STRING, symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_new", PTR, CDECL, "STRPTR,STRPTR,I32,I32,I32", dllName, symbolName, returnKind, isVariadic, fixedArgumentCount)
END FUNCTION

SUB CallFree(callHandle AS U64)
    CALL(DLL, "uxcapi.dll", "uxcapi_call_free", VOID, CDECL, "PTR", callHandle)
END SUB

FUNCTION CallClearArguments(callHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_clear_arguments", I32, CDECL, "PTR", callHandle)
END FUNCTION

FUNCTION CallSetReturnStruct(callHandle AS U64, typeHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_set_return_struct", I32, CDECL, "PTR,PTR", callHandle, typeHandle)
END FUNCTION

FUNCTION ArgI8(callHandle AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_i8", I32, CDECL, "PTR,I32", callHandle, value)
END FUNCTION
FUNCTION ArgU8(callHandle AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_u8", I32, CDECL, "PTR,U32", callHandle, value)
END FUNCTION
FUNCTION ArgI16(callHandle AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_i16", I32, CDECL, "PTR,I32", callHandle, value)
END FUNCTION
FUNCTION ArgU16(callHandle AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_u16", I32, CDECL, "PTR,U32", callHandle, value)
END FUNCTION
FUNCTION ArgI32(callHandle AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_i32", I32, CDECL, "PTR,I32", callHandle, value)
END FUNCTION
FUNCTION ArgU32(callHandle AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_u32", I32, CDECL, "PTR,U32", callHandle, value)
END FUNCTION
FUNCTION ArgI64(callHandle AS U64, value AS I64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_i64", I32, CDECL, "PTR,I64", callHandle, value)
END FUNCTION
FUNCTION ArgU64(callHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_u64", I32, CDECL, "PTR,U64", callHandle, value)
END FUNCTION
FUNCTION ArgF32(callHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_f32", I32, CDECL, "PTR,F64", callHandle, value)
END FUNCTION
FUNCTION ArgF64(callHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_f64", I32, CDECL, "PTR,F64", callHandle, value)
END FUNCTION
FUNCTION ArgStruct(callHandle AS U64, typeHandle AS U64, dataPointer AS U64, byteCount AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_struct", I32, CDECL, "PTR,PTR,PTR,U64", callHandle, typeHandle, dataPointer, byteCount)
END FUNCTION

FUNCTION ArgPtr(callHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_ptr", I32, CDECL, "PTR,PTR", callHandle, value)
END FUNCTION
FUNCTION ArgString(callHandle AS U64, value AS STRING) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_string", I32, CDECL, "PTR,STRPTR", callHandle, value)
END FUNCTION
FUNCTION ArgWString(callHandle AS U64, utf8Value AS STRING) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_wstring_utf8", I32, CDECL, "PTR,STRPTR", callHandle, utf8Value)
END FUNCTION
FUNCTION ArgLongDouble(callHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_arg_long_double_from_f64", I32, CDECL, "PTR,F64", callHandle, value)
END FUNCTION

FUNCTION CallAppendArgs(callHandle AS U64, argsHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_append_args", I32, CDECL, "PTR,PTR", callHandle, argsHandle)
END FUNCTION

FUNCTION Invoke(callHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_invoke", I32, CDECL, "PTR", callHandle)
END FUNCTION

FUNCTION ResultI32(callHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_i32", I32, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultU32(callHandle AS U64) AS U32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_u32", U32, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultI64(callHandle AS U64) AS I64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_i64", I64, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultU64(callHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_u64", U64, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultF64(callHandle AS U64) AS F64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_f64", F64, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultPtr(callHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_ptr", PTR, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultString(callHandle AS U64) AS STRING
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_string", STRPTR, CDECL, "PTR", callHandle)
END FUNCTION
FUNCTION ResultStructSize(callHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_struct_size", U64, CDECL, "PTR", callHandle)
END FUNCTION

FUNCTION ResultStructCopy(callHandle AS U64, targetPointer AS U64, targetCapacity AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_result_struct_copy", I32, CDECL, "PTR,PTR,U64", callHandle, targetPointer, targetCapacity)
END FUNCTION

FUNCTION CallError(callHandle AS U64) AS STRING
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_call_error", STRPTR, CDECL, "PTR", callHandle)
END FUNCTION

FUNCTION ArgsNew() AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_new", PTR, CDECL)
END FUNCTION
SUB ArgsFree(argsHandle AS U64)
    CALL(DLL, "uxcapi.dll", "uxcapi_args_free", VOID, CDECL, "PTR", argsHandle)
END SUB
FUNCTION ArgsClear(argsHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_clear", I32, CDECL, "PTR", argsHandle)
END FUNCTION
FUNCTION ArgsAddI8(argsHandle AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_i8", I32, CDECL, "PTR,I32", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddU8(argsHandle AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_u8", I32, CDECL, "PTR,U32", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddI16(argsHandle AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_i16", I32, CDECL, "PTR,I32", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddU16(argsHandle AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_u16", I32, CDECL, "PTR,U32", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddI32(argsHandle AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_i32", I32, CDECL, "PTR,I32", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddU32(argsHandle AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_u32", I32, CDECL, "PTR,U32", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddI64(argsHandle AS U64, value AS I64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_i64", I32, CDECL, "PTR,I64", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddU64(argsHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_u64", I32, CDECL, "PTR,U64", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddF32(argsHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_f32", I32, CDECL, "PTR,F64", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddF64(argsHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_f64", I32, CDECL, "PTR,F64", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddPtr(argsHandle AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_ptr", I32, CDECL, "PTR,PTR", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddString(argsHandle AS U64, value AS STRING) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_string", I32, CDECL, "PTR,STRPTR", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddWString(argsHandle AS U64, value AS STRING) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_wstring_utf8", I32, CDECL, "PTR,STRPTR", argsHandle, value)
END FUNCTION
FUNCTION ArgsAddLongDouble(argsHandle AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_long_double_from_f64", I32, CDECL, "PTR,F64", argsHandle, value)
END FUNCTION

FUNCTION ArgsAddStruct(argsHandle AS U64, typeHandle AS U64, dataPointer AS U64, byteCount AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_args_add_struct", I32, CDECL, "PTR,PTR,PTR,U64", argsHandle, typeHandle, dataPointer, byteCount)
END FUNCTION

FUNCTION MemoryAlloc(byteCount AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_alloc", PTR, CDECL, "U64", byteCount)
END FUNCTION
FUNCTION MemoryCalloc(itemCount AS U64, itemSize AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_calloc", PTR, CDECL, "U64,U64", itemCount, itemSize)
END FUNCTION
FUNCTION MemoryRealloc(memory AS U64, byteCount AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_realloc", PTR, CDECL, "PTR,U64", memory, byteCount)
END FUNCTION
SUB MemoryFree(memory AS U64)
    CALL(DLL, "uxcapi.dll", "uxcapi_memory_free", VOID, CDECL, "PTR", memory)
END SUB
FUNCTION MemoryZero(memory AS U64, byteCount AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_zero", I32, CDECL, "PTR,U64", memory, byteCount)
END FUNCTION
FUNCTION MemoryCopy(target AS U64, source AS U64, byteCount AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_copy", I32, CDECL, "PTR,PTR,U64", target, source, byteCount)
END FUNCTION

FUNCTION MemoryWriteI8(memory AS U64, offset AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_i8", I32, CDECL, "PTR,U64,I32", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteU8(memory AS U64, offset AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_u8", I32, CDECL, "PTR,U64,U32", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteI16(memory AS U64, offset AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_i16", I32, CDECL, "PTR,U64,I32", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteU16(memory AS U64, offset AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_u16", I32, CDECL, "PTR,U64,U32", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteI32(memory AS U64, offset AS U64, value AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_i32", I32, CDECL, "PTR,U64,I32", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteU32(memory AS U64, offset AS U64, value AS U32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_u32", I32, CDECL, "PTR,U64,U32", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteI64(memory AS U64, offset AS U64, value AS I64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_i64", I32, CDECL, "PTR,U64,I64", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteU64(memory AS U64, offset AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_u64", I32, CDECL, "PTR,U64,U64", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteF32(memory AS U64, offset AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_f32", I32, CDECL, "PTR,U64,F64", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteF64(memory AS U64, offset AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_f64", I32, CDECL, "PTR,U64,F64", memory, offset, value)
END FUNCTION
FUNCTION MemoryWritePtr(memory AS U64, offset AS U64, value AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_ptr", I32, CDECL, "PTR,U64,PTR", memory, offset, value)
END FUNCTION
FUNCTION MemoryWriteString(memory AS U64, offset AS U64, value AS STRING, capacity AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_write_string", I32, CDECL, "PTR,U64,STRPTR,U64", memory, offset, value, capacity)
END FUNCTION

FUNCTION MemoryReadI8(memory AS U64, offset AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_i8", I32, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadU8(memory AS U64, offset AS U64) AS U32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_u8", U32, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadI16(memory AS U64, offset AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_i16", I32, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadU16(memory AS U64, offset AS U64) AS U32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_u16", U32, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadI32(memory AS U64, offset AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_i32", I32, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadU32(memory AS U64, offset AS U64) AS U32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_u32", U32, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadI64(memory AS U64, offset AS U64) AS I64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_i64", I64, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadU64(memory AS U64, offset AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_u64", U64, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadF32(memory AS U64, offset AS U64) AS F64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_f32", F64, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadF64(memory AS U64, offset AS U64) AS F64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_f64", F64, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadPtr(memory AS U64, offset AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_ptr", PTR, CDECL, "PTR,U64", memory, offset)
END FUNCTION
FUNCTION MemoryReadString(memory AS U64, offset AS U64) AS STRING
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_memory_read_string", STRPTR, CDECL, "PTR,U64", memory, offset)
END FUNCTION

FUNCTION CallbackNew(returnKind AS I32, defaultU64 AS U64, defaultF64 AS F64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_callback_new", PTR, CDECL, "I32,U64,F64", returnKind, defaultU64, defaultF64)
END FUNCTION
FUNCTION CallbackAddArg(callbackHandle AS U64, argumentKind AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_callback_add_arg", I32, CDECL, "PTR,I32", callbackHandle, argumentKind)
END FUNCTION
FUNCTION CallbackBuild(callbackHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_callback_build", I32, CDECL, "PTR", callbackHandle)
END FUNCTION
FUNCTION CallbackPointer(callbackHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_callback_pointer", PTR, CDECL, "PTR", callbackHandle)
END FUNCTION
SUB CallbackFree(callbackHandle AS U64)
    CALL(DLL, "uxcapi.dll", "uxcapi_callback_free", VOID, CDECL, "PTR", callbackHandle)
END SUB
FUNCTION CallbackPending(callbackHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_callback_pending", U64, CDECL, "PTR", callbackHandle)
END FUNCTION
FUNCTION CallbackNext(callbackHandle AS U64) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_callback_next", PTR, CDECL, "PTR", callbackHandle)
END FUNCTION

SUB EventFree(eventHandle AS U64)
    CALL(DLL, "uxcapi.dll", "uxcapi_event_free", VOID, CDECL, "PTR", eventHandle)
END SUB
FUNCTION EventArgCount(eventHandle AS U64) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_event_arg_count", I32, CDECL, "PTR", eventHandle)
END FUNCTION
FUNCTION EventArgKind(eventHandle AS U64, index0 AS I32) AS I32
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_event_arg_kind", I32, CDECL, "PTR,I32", eventHandle, index0)
END FUNCTION
FUNCTION EventArgU64(eventHandle AS U64, index0 AS I32) AS U64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_event_arg_u64", U64, CDECL, "PTR,I32", eventHandle, index0)
END FUNCTION
FUNCTION EventArgF64(eventHandle AS U64, index0 AS I32) AS F64
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_event_arg_f64", F64, CDECL, "PTR,I32", eventHandle, index0)
END FUNCTION
FUNCTION EventArgString(eventHandle AS U64, index0 AS I32) AS STRING
    RETURN CALL(DLL, "uxcapi.dll", "uxcapi_event_arg_string", STRPTR, CDECL, "PTR,I32", eventHandle, index0)
END FUNCTION

END NAMESPACE
