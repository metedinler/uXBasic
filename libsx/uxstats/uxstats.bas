' uXBasic Standard Statistics Module
' Include file extension is .bas because current uXBasic INCLUDE accepts .bas.
' Usage:
'   INCLUDE "include/modules/uxstats.uxmh"
'   v = UXSTATS_VecCreate(16)
'   UXSTATS_VecPush(v, 1.0)
'   PRINT UXSTATS_Mean(v)
'
' Design:
' - No new uXBasic keyword.
' - Uses existing CALL(DLL, ...), CDECL, signature strings.
' - Handles are stored as U64/PTR-compatible values.
' - DLL must be reachable as uxstats.dll, preferably in uxb/dist/runtime_ext or program cwd.

FUNCTION UXSTATS_Version() AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats.dll", "uxstats_version", I32, CDECL)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VecCreate(capacity AS I32) AS U64
    DIM h AS U64
    h = CALL(DLL, "uxstats.dll", "uxstats_vec_create", PTR, CDECL, "I32", capacity)
    RETURN h
END FUNCTION

FUNCTION UXSTATS_VecFree(h AS U64) AS I32
    CALL(DLL, "uxstats.dll", "uxstats_vec_free", VOID, CDECL, "PTR", h)
    RETURN 1
END FUNCTION

FUNCTION UXSTATS_VecClear(h AS U64) AS I32
    CALL(DLL, "uxstats.dll", "uxstats_vec_clear", VOID, CDECL, "PTR", h)
    RETURN 1
END FUNCTION

FUNCTION UXSTATS_VecCount(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_count", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VecCapacity(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_capacity", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VecPush(h AS U64, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_push", I32, CDECL, "PTR,F64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VecSet(h AS U64, index AS I32, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_set", I32, CDECL, "PTR,I32,F64", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VecGet(h AS U64, index AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_get", F64, CDECL, "PTR,I32", h, index)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Sum(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_sum", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Mean(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_mean", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Min(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_min", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Max(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_max", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Range(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_range", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VariancePop(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_variance_pop", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_VarianceSamp(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_variance_samp", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_StdDevPop(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_stddev_pop", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_StdDevSamp(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_stddev_samp", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Median(h AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_median", F64, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Percentile(h AS U64, p AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_percentile", F64, CDECL, "PTR,F64", h, p)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_CovarianceSamp(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_covariance_samp", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_Correlation(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_correlation", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_RegressionSlope(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_regression_slope", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_RegressionIntercept(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_regression_intercept", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_RegressionR2(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_vec_regression_r2", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

' Advanced raw-pointer API. Use only if VARPTR(array(0)) gives a real contiguous F64 address in your current backend.
FUNCTION UXSTATS_RawMeanF64(dataPtr AS U64, count AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_mean_f64", F64, CDECL, "PTR,I32", dataPtr, count)
    RETURN r
END FUNCTION

FUNCTION UXSTATS_RawStdDevSampF64(dataPtr AS U64, count AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats.dll", "uxstats_stddev_samp_f64", F64, CDECL, "PTR,I32", dataPtr, count)
    RETURN r
END FUNCTION
