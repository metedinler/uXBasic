' uXBasic Tensor Standard Module
' Include with: INCLUDE "libs/uxtensor/uxtensor.bas"
' Backend: uxtensor.dll, optionally linked with OpenBLAS.

NAMESPACE uxtensor

CONST UXTENSOR_DLL = "uxtensor.dll"
CONST DTYPE_F64 = 1
CONST DTYPE_F32 = 2
CONST DTYPE_I64 = 3

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_version", I32, CDECL)
END FUNCTION

FUNCTION Backend() AS STRING
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_backend", STRPTR, CDECL)
END FUNCTION

FUNCTION Create1D(n AS I64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_create1d_f64", PTR, CDECL, "I64", n)
END FUNCTION

FUNCTION Create2D(rows AS I64, cols AS I64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_create2d_f64", PTR, CDECL, "I64,I64", rows, cols)
END FUNCTION

FUNCTION Create3D(a AS I64, b AS I64, c AS I64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_create3d_f64", PTR, CDECL, "I64,I64,I64", a, b, c)
END FUNCTION

FUNCTION Create4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_create4d_f64", PTR, CDECL, "I64,I64,I64,I64", a, b, c, d)
END FUNCTION

SUB Free(t AS U64)
    CALL(DLL, "uxtensor.dll", "uxtensor_free", VOID, CDECL, "PTR", t)
END SUB

FUNCTION Clone(t AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_clone", PTR, CDECL, "PTR", t)
END FUNCTION

FUNCTION SliceAxis0(t AS U64, start AS I64, count AS I64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_slice_axis0_copy", PTR, CDECL, "PTR,I64,I64", t, start, count)
END FUNCTION

FUNCTION DType(t AS U64) AS I32
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_dtype", I32, CDECL, "PTR", t)
END FUNCTION

FUNCTION NDim(t AS U64) AS I32
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_ndim", I32, CDECL, "PTR", t)
END FUNCTION

FUNCTION Dim(t AS U64, axis AS I32) AS I64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_dim", I64, CDECL, "PTR,I32", t, axis)
END FUNCTION

FUNCTION Stride(t AS U64, axis AS I32) AS I64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_stride", I64, CDECL, "PTR,I32", t, axis)
END FUNCTION

FUNCTION Size(t AS U64) AS I64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_size", I64, CDECL, "PTR", t)
END FUNCTION

FUNCTION ElemSize(t AS U64) AS I64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_elem_size", I64, CDECL, "PTR", t)
END FUNCTION

FUNCTION DataPtr(t AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_data_ptr", PTR, CDECL, "PTR", t)
END FUNCTION

SUB Fill(t AS U64, value AS F64)
    CALL(DLL, "uxtensor.dll", "uxtensor_fill_f64", I32, CDECL, "PTR,F64", t, value)
END SUB

SUB Zero(t AS U64)
    CALL(DLL, "uxtensor.dll", "uxtensor_zero", I32, CDECL, "PTR", t)
END SUB

FUNCTION GetFlat(t AS U64, index AS I64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_get_flat_f64", F64, CDECL, "PTR,I64", t, index)
END FUNCTION

SUB SetFlat(t AS U64, index AS I64, value AS F64)
    CALL(DLL, "uxtensor.dll", "uxtensor_set_flat_f64", I32, CDECL, "PTR,I64,F64", t, index, value)
END SUB

FUNCTION Get2D(t AS U64, r AS I64, c AS I64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_get2d_f64", F64, CDECL, "PTR,I64,I64", t, r, c)
END FUNCTION

SUB Set2D(t AS U64, r AS I64, c AS I64, value AS F64)
    CALL(DLL, "uxtensor.dll", "uxtensor_set2d_f64", I32, CDECL, "PTR,I64,I64,F64", t, r, c, value)
END SUB

FUNCTION Get3D(t AS U64, a AS I64, b AS I64, c AS I64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_get3d_f64", F64, CDECL, "PTR,I64,I64,I64", t, a, b, c)
END FUNCTION

SUB Set3D(t AS U64, a AS I64, b AS I64, c AS I64, value AS F64)
    CALL(DLL, "uxtensor.dll", "uxtensor_set3d_f64", I32, CDECL, "PTR,I64,I64,I64,F64", t, a, b, c, value)
END SUB

FUNCTION Get4D(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_get4d_f64", F64, CDECL, "PTR,I64,I64,I64,I64", t, a, b, c, d)
END FUNCTION

SUB Set4D(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64, value AS F64)
    CALL(DLL, "uxtensor.dll", "uxtensor_set4d_f64", I32, CDECL, "PTR,I64,I64,I64,I64,F64", t, a, b, c, d, value)
END SUB

FUNCTION Add(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_add_f64", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Subtract(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_sub_f64", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Multiply(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_mul_f64", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Divide(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_div_f64", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Scale(a AS U64, scalar AS F64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_scale_f64", PTR, CDECL, "PTR,F64", a, scalar)
END FUNCTION

FUNCTION Sum(a AS U64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_sum_f64", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION Mean(a AS U64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_mean_f64", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION Dot(a AS U64, b AS U64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_dot_f64", F64, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Norm2(a AS U64) AS F64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_norm2_f64", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION MatMul(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_matmul2d_f64", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION MatVec(a AS U64, x AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_matvec2d_f64", PTR, CDECL, "PTR,PTR", a, x)
END FUNCTION

FUNCTION Transpose2D(a AS U64) AS U64
    RETURN CALL(DLL, "uxtensor.dll", "uxtensor_transpose2d_f64", PTR, CDECL, "PTR", a)
END FUNCTION

END NAMESPACE
