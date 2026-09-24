' uXBasic uxmath standard module.
' This public surface is backed by the coherent uxmath.dll handle model.
' uxmathcore remains available as a separate general-purpose buffer module.

FUNCTION UXMATH_Version() AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmath.dll", "uxmath_version", I32, CDECL)
    RETURN r
END FUNCTION

FUNCTION UXMATH_VecCreate(capacity AS I32) AS U64
    DIM h AS U64
    h = CALL(DLL, "uxmath.dll", "uxmath_vec_create", PTR, CDECL, "I32", capacity)
    RETURN h
END FUNCTION

FUNCTION UXMATH_VecFree(h AS U64) AS I32
    CALL(DLL, "uxmath.dll", "uxmath_vec_free", VOID, CDECL, "PTR", h)
    RETURN 1
END FUNCTION

FUNCTION UXMATH_VecPush(h AS U64, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmath.dll", "uxmath_vec_push", I32, CDECL, "PTR,F64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXMATH_VecSet(h AS U64, index AS I32, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmath.dll", "uxmath_vec_set", I32, CDECL, "PTR,I32,F64", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXMATH_VecGet(h AS U64, index AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxmath.dll", "uxmath_vec_get", F64, CDECL, "PTR,I32", h, index)
    RETURN r
END FUNCTION

FUNCTION UXMATH_VecCount(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmath.dll", "uxmath_vec_count", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMATH_VecClear(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxmath.dll", "uxmath_vec_clear", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

FUNCTION UXMATH_VecDataPtr(h AS U64) AS U64
    DIM p AS U64
    p = CALL(DLL, "uxmath.dll", "uxmath_vec_data_ptr", PTR, CDECL, "PTR", h)
    RETURN p
END FUNCTION

FUNCTION UXMATH_PolyEval(coeffs AS U64, x AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_eval", F64, CDECL, "PTR,F64", coeffs, x)
END FUNCTION

FUNCTION UXMATH_PolyDerivativeEval(coeffs AS U64, x AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_derivative_eval", F64, CDECL, "PTR,F64", coeffs, x)
END FUNCTION

FUNCTION UXMATH_PolyIntegralEval(coeffs AS U64, a AS F64, b AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_integral_eval", F64, CDECL, "PTR,F64,F64", coeffs, a, b)
END FUNCTION

FUNCTION UXMATH_PolyDerivativeCoeff(coeffs AS U64, outCoeffs AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_derivative_coeff", I32, CDECL, "PTR,PTR", coeffs, outCoeffs)
END FUNCTION

FUNCTION UXMATH_PolyIntegralCoeff(coeffs AS U64, outCoeffs AS U64, c0 AS F64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_integral_coeff", I32, CDECL, "PTR,PTR,F64", coeffs, outCoeffs, c0)
END FUNCTION

FUNCTION UXMATH_PolyBisection(coeffs AS U64, a AS F64, b AS F64, maxIter AS I32, tolerance AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_bisection", F64, CDECL, "PTR,F64,F64,I32,F64", coeffs, a, b, maxIter, tolerance)
END FUNCTION

FUNCTION UXMATH_PolyNewton(coeffs AS U64, x0 AS F64, maxIter AS I32, tolerance AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_poly_newton", F64, CDECL, "PTR,F64,I32,F64", coeffs, x0, maxIter, tolerance)
END FUNCTION

FUNCTION UXMATH_NumericDerivativePoly(coeffs AS U64, x AS F64, h AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_numeric_derivative_poly", F64, CDECL, "PTR,F64,F64", coeffs, x, h)
END FUNCTION

FUNCTION UXMATH_IntegratePolySimpson(coeffs AS U64, a AS F64, b AS F64, intervals AS I32) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_integrate_poly_simpson", F64, CDECL, "PTR,F64,F64,I32", coeffs, a, b, intervals)
END FUNCTION

FUNCTION UXMATH_ODE_RK4_Logistic(y0 AS F64, rate AS F64, capacity AS F64, t0 AS F64, t1 AS F64, steps AS I32) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_ode_rk4_logistic", F64, CDECL, "F64,F64,F64,F64,F64,I32", y0, rate, capacity, t0, t1, steps)
END FUNCTION

FUNCTION UXMATH_ODE_Euler_Logistic(y0 AS F64, rate AS F64, capacity AS F64, t0 AS F64, t1 AS F64, steps AS I32) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_ode_euler_logistic", F64, CDECL, "F64,F64,F64,F64,F64,I32", y0, rate, capacity, t0, t1, steps)
END FUNCTION

FUNCTION UXMATH_Sigmoid(x AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_sigmoid", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION UXMATH_DSigmoidFromOutput(y AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_dsigmoid_from_output", F64, CDECL, "F64", y)
END FUNCTION

FUNCTION UXMATH_ReLU(x AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_relu", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION UXMATH_DReLU(x AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_drelu", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION UXMATH_Tanh(x AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_tanh_act", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION UXMATH_DTanhFromOutput(y AS F64) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_dtanh_from_output", F64, CDECL, "F64", y)
END FUNCTION

FUNCTION UXMATH_VecSoftmax(src AS U64, dst AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_vec_softmax", I32, CDECL, "PTR,PTR", src, dst)
END FUNCTION

FUNCTION UXMATH_MatCreate(rows AS I32, cols AS I32) AS U64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_create", PTR, CDECL, "I32,I32", rows, cols)
END FUNCTION

FUNCTION UXMATH_MatFree(matrix AS U64) AS I32
    CALL(DLL, "uxmath.dll", "uxmath_mat_free", VOID, CDECL, "PTR", matrix)
    RETURN 1
END FUNCTION

FUNCTION UXMATH_MatRows(matrix AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_rows", I32, CDECL, "PTR", matrix)
END FUNCTION

FUNCTION UXMATH_MatCols(matrix AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_cols", I32, CDECL, "PTR", matrix)
END FUNCTION

FUNCTION UXMATH_MatSet(matrix AS U64, row AS I32, col AS I32, value AS F64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_set", I32, CDECL, "PTR,I32,I32,F64", matrix, row, col, value)
END FUNCTION

FUNCTION UXMATH_MatGet(matrix AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_get", F64, CDECL, "PTR,I32,I32", matrix, row, col)
END FUNCTION

FUNCTION UXMATH_MatFill(matrix AS U64, value AS F64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_fill", I32, CDECL, "PTR,F64", matrix, value)
END FUNCTION

FUNCTION UXMATH_MatRandomUniform(matrix AS U64, lo AS F64, hi AS F64, seed AS U32) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_random_uniform", I32, CDECL, "PTR,F64,F64,U32", matrix, lo, hi, seed)
END FUNCTION

FUNCTION UXMATH_MatAdd(a AS U64, b AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_add", I32, CDECL, "PTR,PTR,PTR", a, b, output)
END FUNCTION

FUNCTION UXMATH_MatSub(a AS U64, b AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_sub", I32, CDECL, "PTR,PTR,PTR", a, b, output)
END FUNCTION

FUNCTION UXMATH_MatMul(a AS U64, b AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_mul", I32, CDECL, "PTR,PTR,PTR", a, b, output)
END FUNCTION

FUNCTION UXMATH_MatTranspose(a AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_transpose", I32, CDECL, "PTR,PTR", a, output)
END FUNCTION

FUNCTION UXMATH_MatApplySigmoid(a AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_apply_sigmoid", I32, CDECL, "PTR,PTR", a, output)
END FUNCTION

FUNCTION UXMATH_MatApplyReLU(a AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_apply_relu", I32, CDECL, "PTR,PTR", a, output)
END FUNCTION

FUNCTION UXMATH_MatVecMul(matrix AS U64, vector AS U64, output AS U64) AS I32
    RETURN CALL(DLL, "uxmath.dll", "uxmath_mat_vec_mul", I32, CDECL, "PTR,PTR,PTR", matrix, vector, output)
END FUNCTION
