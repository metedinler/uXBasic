' UXGSL public uXBasic module.
' Backend: uxgsl.dll, a narrow C-ABI10 facade over GNU Scientific Library.
' Include with: INCLUDE "include/modules/uxgsl.uxmh"

' The raw layer keeps every GSL/CBlas export reachable through the existing
' ABI10 dynamic-call bridge. Use it for APIs with callbacks, structs, complex
' values, or an arity greater than the direct CALL(DLL) surface can represent.
INCLUDE "libsx/uxcapi/uxcapi.bas"

NAMESPACE uxgsl

CONST GSL_DLL = "libgsl-28.dll"
CONST GSL_CBLAS_DLL = "libgslcblas-0.dll"

FUNCTION ApiVersion() AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_api_version", I32, CDECL)
END FUNCTION

FUNCTION Available() AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_available", I32, CDECL)
END FUNCTION

FUNCTION GslVersion() AS STRING
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_gsl_version", STRPTR, CDECL)
END FUNCTION

FUNCTION SelfTest() AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_self_test", I32, CDECL)
END FUNCTION

FUNCTION LastStatus() AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_last_status", I32, CDECL)
END FUNCTION

FUNCTION LastGslStatus() AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_last_gsl_status", I32, CDECL)
END FUNCTION

FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_last_error", STRPTR, CDECL)
END FUNCTION

FUNCTION StatusText(status AS I32) AS STRING
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_status_text", STRPTR, CDECL, "I32", status)
END FUNCTION

FUNCTION BesselJ0(x AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_bessel_j0", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION BesselJ1(x AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_bessel_j1", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION BesselY0(x AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_bessel_y0", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION Gamma(x AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_gamma", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION LnGamma(x AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_lngamma", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION Erf(x AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_erf", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION GaussianPdf(x AS F64, sigma AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_gaussian_pdf", F64, CDECL, "F64,F64", x, sigma)
END FUNCTION

FUNCTION RngCreate(seed AS U64) AS U64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_rng_create", PTR, CDECL, "U64", seed)
END FUNCTION

SUB RngFree(handle AS U64)
    CALL(DLL, "uxgsl.dll", "uxgsl_rng_free", VOID, CDECL, "PTR", handle)
END SUB

FUNCTION RngUniform(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_rng_uniform", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION RngGaussian(handle AS U64, sigma AS F64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_rng_gaussian", F64, CDECL, "PTR,F64", handle, sigma)
END FUNCTION

FUNCTION VectorCreate(count AS I32) AS U64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_create", PTR, CDECL, "I32", count)
END FUNCTION

SUB VectorFree(handle AS U64)
    CALL(DLL, "uxgsl.dll", "uxgsl_vector_free", VOID, CDECL, "PTR", handle)
END SUB

FUNCTION VectorSize(handle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_size", I32, CDECL, "PTR", handle)
END FUNCTION

FUNCTION VectorSet(handle AS U64, index AS I32, value AS F64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_set", I32, CDECL, "PTR,I32,F64", handle, index, value)
END FUNCTION

FUNCTION VectorGet(handle AS U64, index AS I32) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_get", F64, CDECL, "PTR,I32", handle, index)
END FUNCTION

FUNCTION VectorMean(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_mean", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION VectorStandardDeviation(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_sd", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION VectorVariance(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_vector_variance", F64, CDECL, "PTR", handle)
END FUNCTION

' Double matrix handles own their GSL structure and backing buffer. All
' coordinates are zero-based; MatrixMultiply requires a distinct output.
FUNCTION MatrixCreate(rows AS I32, columns AS I32) AS U64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_create", PTR, CDECL, "I32,I32", rows, columns)
END FUNCTION

SUB MatrixFree(handle AS U64)
    CALL(DLL, "uxgsl.dll", "uxgsl_matrix_free", VOID, CDECL, "PTR", handle)
END SUB

FUNCTION MatrixRows(handle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_rows", I32, CDECL, "PTR", handle)
END FUNCTION

FUNCTION MatrixColumns(handle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_columns", I32, CDECL, "PTR", handle)
END FUNCTION

FUNCTION MatrixSet(handle AS U64, row AS I32, column AS I32, value AS F64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_set", I32, CDECL, "PTR,I32,I32,F64", handle, row, column, value)
END FUNCTION

FUNCTION MatrixGet(handle AS U64, row AS I32, column AS I32) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_get", F64, CDECL, "PTR,I32,I32", handle, row, column)
END FUNCTION

FUNCTION MatrixSetZero(handle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_set_zero", I32, CDECL, "PTR", handle)
END FUNCTION

FUNCTION MatrixSetIdentity(handle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_set_identity", I32, CDECL, "PTR", handle)
END FUNCTION

FUNCTION MatrixMultiply(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_matrix_multiply", I32, CDECL, "PTR,PTR,PTR", leftHandle, rightHandle, outputHandle)
END FUNCTION

' Numerical integration and root solvers use a live synchronous native C ABI
' callback, F64 callback(F64 x, PTR userData). Native x64 CODEPTR produces a
' compatible routine address; this is not an uxcapi event-queue callback.
FUNCTION IntegrationWorkspaceCreate(limit AS I32) AS U64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_integration_workspace_create", PTR, CDECL, "I32", limit)
END FUNCTION

SUB IntegrationWorkspaceFree(handle AS U64)
    CALL(DLL, "uxgsl.dll", "uxgsl_integration_workspace_free", VOID, CDECL, "PTR", handle)
END SUB

FUNCTION IntegrateQag(callbackAddress AS PTR, userData AS PTR, lower AS F64, upper AS F64, absoluteTolerance AS F64, relativeTolerance AS F64, limit AS I32, key AS I32, workspaceHandle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_integrate_qag", F64, CDECL, "PTR,PTR,F64,F64,F64,F64,I32,I32,PTR", callbackAddress, userData, lower, upper, absoluteTolerance, relativeTolerance, limit, key, workspaceHandle)
END FUNCTION

FUNCTION LastEstimatedError() AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_last_estimated_error", F64, CDECL)
END FUNCTION

' RootBisection keeps its callback for the solver lifetime. Do not free the
' solver, unload its code, or invalidate callbackAddress until it is freed.
FUNCTION RootBisectionCreate() AS U64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_create", PTR, CDECL)
END FUNCTION

SUB RootBisectionFree(handle AS U64)
    CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_free", VOID, CDECL, "PTR", handle)
END SUB

FUNCTION RootBisectionSet(handle AS U64, callbackAddress AS PTR, userData AS PTR, lower AS F64, upper AS F64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_set", I32, CDECL, "PTR,PTR,PTR,F64,F64", handle, callbackAddress, userData, lower, upper)
END FUNCTION

FUNCTION RootBisectionIterate(handle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_iterate", I32, CDECL, "PTR", handle)
END FUNCTION

FUNCTION RootBisectionRoot(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_root", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION RootBisectionLower(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_lower", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION RootBisectionUpper(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_upper", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION RootBisectionIntervalConverged(handle AS U64, absoluteTolerance AS F64, relativeTolerance AS F64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_root_bisection_interval_converged", I32, CDECL, "PTR,F64,F64", handle, absoluteTolerance, relativeTolerance)
END FUNCTION

' Complex values are opaque facade-owned handles. Result handles in binary
' operations must be distinct from both input handles.
FUNCTION ComplexCreate(real AS F64, imaginary AS F64) AS U64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_complex_create", PTR, CDECL, "F64,F64", real, imaginary)
END FUNCTION

SUB ComplexFree(handle AS U64)
    CALL(DLL, "uxgsl.dll", "uxgsl_complex_free", VOID, CDECL, "PTR", handle)
END SUB

FUNCTION ComplexReal(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_complex_real", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION ComplexImaginary(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_complex_imaginary", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION ComplexAbs(handle AS U64) AS F64
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_complex_abs", F64, CDECL, "PTR", handle)
END FUNCTION

FUNCTION ComplexAdd(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_complex_add", I32, CDECL, "PTR,PTR,PTR", leftHandle, rightHandle, outputHandle)
END FUNCTION

FUNCTION ComplexMultiply(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64) AS I32
    RETURN CALL(DLL, "uxgsl.dll", "uxgsl_complex_multiply", I32, CDECL, "PTR,PTR,PTR", leftHandle, rightHandle, outputHandle)
END FUNCTION

' ---- Complete raw GSL/CBlas ABI access ------------------------------------
' The generated gsl_exports.json catalog identifies every symbol in the exact
' installed DLL build. Argument and result kinds use uxcapi.KIND_* constants.

FUNCTION GslSymbol(symbolName AS STRING) AS U64
    RETURN uxcapi.SymbolAddress("libgsl-28.dll", symbolName)
END FUNCTION

FUNCTION CblasSymbol(symbolName AS STRING) AS U64
    RETURN uxcapi.SymbolAddress("libgslcblas-0.dll", symbolName)
END FUNCTION

FUNCTION GslCallNew(symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32) AS U64
    RETURN uxcapi.CallNew("libgsl-28.dll", symbolName, returnKind, isVariadic, fixedArgumentCount)
END FUNCTION

FUNCTION CblasCallNew(symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32) AS U64
    RETURN uxcapi.CallNew("libgslcblas-0.dll", symbolName, returnKind, isVariadic, fixedArgumentCount)
END FUNCTION

END NAMESPACE
