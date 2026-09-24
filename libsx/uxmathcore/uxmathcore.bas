' uXBasic Math Core 1A - numeric container and typed buffer core
' INCLUDE "libs/uxmathcore/uxmathcore.bas"
' This module intentionally does NOT duplicate uXBasic scalar math functions
' such as SIN/COS/TAN/LOG/EXP/SQR/ABS/RND/TIMER.
' Matrix, polynomial, integral, ODE and AI activation layers belong to separate packages.

FUNCTION UXMC_TYPE_I8() AS I32
    RETURN 1
END FUNCTION
FUNCTION UXMC_TYPE_U8() AS I32
    RETURN 2
END FUNCTION
FUNCTION UXMC_TYPE_I16() AS I32
    RETURN 3
END FUNCTION
FUNCTION UXMC_TYPE_U16() AS I32
    RETURN 4
END FUNCTION
FUNCTION UXMC_TYPE_I32() AS I32
    RETURN 5
END FUNCTION
FUNCTION UXMC_TYPE_U32() AS I32
    RETURN 6
END FUNCTION
FUNCTION UXMC_TYPE_I64() AS I32
    RETURN 7
END FUNCTION
FUNCTION UXMC_TYPE_U64() AS I32
    RETURN 8
END FUNCTION
FUNCTION UXMC_TYPE_F32() AS I32
    RETURN 9
END FUNCTION
FUNCTION UXMC_TYPE_F64() AS I32
    RETURN 10
END FUNCTION

FUNCTION UXMC_Version() AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_version", I32, CDECL)
    RETURN r
END FUNCTION

FUNCTION UXMC_TypeSize(typeId AS I32) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_type_size", I32, CDECL, "I32", typeId)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferCreate(typeId AS I32, count AS I32) AS U64
    DIM h AS U64
    h = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_create", PTR, CDECL, "I32,I32", typeId, count)
    RETURN h
END FUNCTION

FUNCTION UXMC_BufferCreateCapacity(typeId AS I32, count AS I32, capacity AS I32) AS U64
    DIM h AS U64
    h = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_create_capacity", PTR, CDECL, "I32,I32,I32", typeId, count, capacity)
    RETURN h
END FUNCTION

FUNCTION UXMC_BufferFree(h AS U64) AS I32
    CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_free", VOID, CDECL, "PTR", h)
    RETURN 1
END FUNCTION

FUNCTION UXMC_BufferType(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_type", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferCount(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_count", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferCapacity(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_capacity", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferElemSize(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_elem_size", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferByteSize(h AS U64) AS I64
    DIM r AS I64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_byte_size", I64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferDataPtr(h AS U64) AS U64
    DIM p AS U64
    p = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_data_ptr", PTR, CDECL, "PTR", h)
    RETURN p
END FUNCTION

FUNCTION UXMC_BufferClear(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_clear", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferResize(h AS U64, count AS I32) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_resize", I32, CDECL, "PTR,I32", h, count)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferReserve(h AS U64, capacity AS I32) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_reserve", I32, CDECL, "PTR,I32", h, capacity)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferFillZero(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_fill_zero", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferClone(h AS U64) AS U64
    DIM r AS U64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_clone_handle", PTR, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferSlice(h AS U64, startIndex AS I32, count AS I32) AS U64
    DIM r AS U64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_slice_handle", PTR, CDECL, "PTR,I32,I32", h, startIndex, count)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferAppend(dst AS U64, src AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_append", I32, CDECL, "PTR,PTR", dst, src)
    RETURN r
END FUNCTION

FUNCTION UXMC_BufferCast(src AS U64, dstType AS I32) AS U64
    DIM r AS U64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_cast_handle", PTR, CDECL, "PTR,I32", src, dstType)
    RETURN r
END FUNCTION

FUNCTION UXMC_GetF64(h AS U64, index AS I32) AS F64
    ' Direct return helper is not used; value access is routed through uxmath compatibility style.
    DIM r AS F64
    r = CALL(DLL, "uxmathcore.dll", "uxmath_vec_get", F64, CDECL, "PTR,I32", h, index)
    RETURN r
END FUNCTION

FUNCTION UXMC_SetF64(h AS U64, index AS I32, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_set_f64", I32, CDECL, "PTR,I32,F64", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_PushF64(h AS U64, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_push_f64", I32, CDECL, "PTR,F64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_FillF64(h AS U64, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_fill_f64", I32, CDECL, "PTR,F64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_SetI64(h AS U64, index AS I32, value AS I64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_set_i64", I32, CDECL, "PTR,I32,I64", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_PushI64(h AS U64, value AS I64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_push_i64", I32, CDECL, "PTR,I64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_SetU64(h AS U64, index AS I32, value AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_set_u64", I32, CDECL, "PTR,I32,U64", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_PushU64(h AS U64, value AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_push_u64", I32, CDECL, "PTR,U64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_SetByte(h AS U64, index AS I32, value AS I32) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_set_byte", I32, CDECL, "PTR,I32,U32", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXMC_PushByte(h AS U64, value AS I32) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_buffer_push_byte", I32, CDECL, "PTR,U32", h, value)
    RETURN r
END FUNCTION

' --- Vectorized numeric primitives: not scalar SIN/COS/SQRT duplicates. ---
FUNCTION UXMC_VecAddF64(a AS U64, b AS U64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_add_f64", I32, CDECL, "PTR,PTR,PTR", a, b, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecSubF64(a AS U64, b AS U64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_sub_f64", I32, CDECL, "PTR,PTR,PTR", a, b, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecMulF64(a AS U64, b AS U64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_mul_f64", I32, CDECL, "PTR,PTR,PTR", a, b, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecDivF64(a AS U64, b AS U64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_div_f64", I32, CDECL, "PTR,PTR,PTR", a, b, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecScaleF64(a AS U64, scalar AS F64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_scale_f64", I32, CDECL, "PTR,F64,PTR", a, scalar, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecAxpyF64(alpha AS F64, x AS U64, y AS U64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_axpy_f64", I32, CDECL, "F64,PTR,PTR,PTR", alpha, x, y, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecDotF64(a AS U64, b AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_dot_f64_value", F64, CDECL, "PTR,PTR", a, b)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecL1NormF64(a AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_l1_norm_f64_value", F64, CDECL, "PTR", a)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecL2NormF64(a AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_l2_norm_f64_value", F64, CDECL, "PTR", a)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecNormalizeL2F64(a AS U64, outv AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_normalize_l2_f64", I32, CDECL, "PTR,PTR", a, outv)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecMinF64(a AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_min_f64_value", F64, CDECL, "PTR", a)
    RETURN r
END FUNCTION

FUNCTION UXMC_VecMaxF64(a AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxmathcore.dll", "uxmathcore_vec_max_f64_value", F64, CDECL, "PTR", a)
    RETURN r
END FUNCTION
