' uXBasic uxmatrix standard module
' Include wrapper over uxmatrix.dll.
' No new keyword: INCLUDE + NAMESPACE + CALL(DLL) only.

NAMESPACE uxmatrix

CONST UXMATRIX_DLL = "uxmatrix.dll"

FUNCTION RuntimeVersion() AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_runtime_version", I32, CDECL)
END FUNCTION

FUNCTION Create(rows AS I32, cols AS I32) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_create", PTR, CDECL, "I32,I32", rows, cols)
END FUNCTION

SUB Free(m AS U64)
    CALL(DLL, "uxmatrix.dll", "uxmatrix_free", VOID, CDECL, "PTR", m)
END SUB

FUNCTION Rows(m AS U64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_rows", I32, CDECL, "PTR", m)
END FUNCTION

FUNCTION Cols(m AS U64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_cols", I32, CDECL, "PTR", m)
END FUNCTION

FUNCTION Size(m AS U64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_size", I32, CDECL, "PTR", m)
END FUNCTION

FUNCTION DataPtr(m AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_data_ptr", PTR, CDECL, "PTR", m)
END FUNCTION

FUNCTION Set(m AS U64, r AS I32, c AS I32, v AS F64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_set", I32, CDECL, "PTR,I32,I32,F64", m, r, c, v)
END FUNCTION

FUNCTION Get(m AS U64, r AS I32, c AS I32) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_get", F64, CDECL, "PTR,I32,I32", m, r, c)
END FUNCTION

FUNCTION Fill(m AS U64, v AS F64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_fill", I32, CDECL, "PTR,F64", m, v)
END FUNCTION

FUNCTION Zero(m AS U64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_zero", I32, CDECL, "PTR", m)
END FUNCTION

FUNCTION Eye(m AS U64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_eye", I32, CDECL, "PTR", m)
END FUNCTION

FUNCTION Clone(m AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_clone", PTR, CDECL, "PTR", m)
END FUNCTION

FUNCTION Transpose(a AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_transpose", PTR, CDECL, "PTR", a)
END FUNCTION

FUNCTION Add(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_add", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Sub(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_sub", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Scale(a AS U64, s AS F64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_scale", PTR, CDECL, "PTR,F64", a, s)
END FUNCTION

FUNCTION Mul(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_mul", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION MatVec(a AS U64, x AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_matvec", PTR, CDECL, "PTR,PTR", a, x)
END FUNCTION

FUNCTION Dot(a AS U64, b AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_dot", F64, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION NormL1(a AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_norm_l1", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION NormL2(a AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_norm_l2", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION NormFro(a AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_norm_fro", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION Trace(a AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_trace", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION PrintMatrix(a AS U64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_print", I32, CDECL, "PTR", a)
END FUNCTION

FUNCTION Det(a AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_det", F64, CDECL, "PTR", a)
END FUNCTION

FUNCTION Solve(a AS U64, b AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_solve_new", PTR, CDECL, "PTR,PTR", a, b)
END FUNCTION

FUNCTION Inverse(a AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_inverse_new", PTR, CDECL, "PTR", a)
END FUNCTION

FUNCTION Cholesky(a AS U64) AS U64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_cholesky_new", PTR, CDECL, "PTR", a)
END FUNCTION

FUNCTION QR(a AS U64, qOutPtr AS U64, rOutPtr AS U64) AS I32
    ' qOutPtr ve rOutPtr: U64 handle degiskenlerinin VARPTR adresleri.
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_qr", I32, CDECL, "PTR,PTR,PTR", a, qOutPtr, rOutPtr)
END FUNCTION

FUNCTION SVD(a AS U64, uOutPtr AS U64, sOutPtr AS U64, vtOutPtr AS U64) AS I32
    ' Cikti handle degiskenleri VARPTR ile gecirilir.
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_svd", I32, CDECL, "PTR,PTR,PTR,PTR", a, uOutPtr, sOutPtr, vtOutPtr)
END FUNCTION

FUNCTION EigenSymmetric(a AS U64, valuesOutPtr AS U64, vectorsOutPtr AS U64) AS I32
    ' Cikti handle degiskenleri VARPTR ile gecirilir.
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_eigen_symmetric", I32, CDECL, "PTR,PTR,PTR", a, valuesOutPtr, vectorsOutPtr)
END FUNCTION

FUNCTION RankSVD(a AS U64, tol AS F64) AS I32
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_rank_svd", I32, CDECL, "PTR,F64", a, tol)
END FUNCTION

FUNCTION Cond2(a AS U64) AS F64
    RETURN CALL(DLL, "uxmatrix.dll", "uxmatrix_cond2", F64, CDECL, "PTR", a)
END FUNCTION

END NAMESPACE
