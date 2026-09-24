' uXBasic AI Math Standard Module
' Include with: INCLUDE "libs/uxaimath/uxaimath.bas"
' Optional tensor bridge: include libs/uxtensor/uxtensor.bas first, then use Tensor* functions.
' Backend: uxaimath.dll, optionally linked with OpenBLAS.

NAMESPACE uxaimath

CONST UXAIMATH_DLL = "uxaimath.dll"

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_version", I32, CDECL)
END FUNCTION

FUNCTION Backend() AS STRING
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_backend", STRPTR, CDECL)
END FUNCTION

SUB Seed(seed AS U64)
    CALL(DLL, "uxaimath.dll", "uxaimath_seed", VOID, CDECL, "U64", seed)
END SUB

' ---- scalar activation helpers ----
FUNCTION Sigmoid(x AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_sigmoid", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION ReLU(x AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_relu", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION LeakyReLU(x AS F64, alpha AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_leaky_relu", F64, CDECL, "F64,F64", x, alpha)
END FUNCTION

FUNCTION ELU(x AS F64, alpha AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_elu", F64, CDECL, "F64,F64", x, alpha)
END FUNCTION

FUNCTION GELU(x AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_gelu", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION Swish(x AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_swish", F64, CDECL, "F64", x)
END FUNCTION

FUNCTION Softplus(x AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_softplus", F64, CDECL, "F64", x)
END FUNCTION

' ---- raw pointer vector/tensor memory functions ----
SUB ApplySigmoidPtr(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_sigmoid_inplace_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB ApplyTanhPtr(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_tanh_inplace_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB ApplyReLUPtr(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_relu_inplace_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB ApplyLeakyReLUPtr(dataPtr AS U64, n AS I64, alpha AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_leaky_relu_inplace_f64", VOID, CDECL, "PTR,I64,F64", dataPtr, n, alpha)
END SUB

SUB ApplyELUPtr(dataPtr AS U64, n AS I64, alpha AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_elu_inplace_f64", VOID, CDECL, "PTR,I64,F64", dataPtr, n, alpha)
END SUB

SUB ApplyGELUPtr(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_gelu_inplace_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB ApplySwishPtr(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_swish_inplace_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB SoftmaxPtr(inputPtr AS U64, outputPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_softmax_f64", VOID, CDECL, "PTR,PTR,I64", inputPtr, outputPtr, n)
END SUB

SUB SoftmaxInPlacePtr(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_softmax_inplace_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

' ---- optional uxtensor bridge; include uxtensor before this if used ----
SUB TensorSigmoid(t AS U64)
    CALL(DLL, "uxaimath.dll", "uxaimath_sigmoid_inplace_f64", VOID, CDECL, "PTR,I64", uxtensor.DataPtr(t), uxtensor.Size(t))
END SUB

SUB TensorTanh(t AS U64)
    CALL(DLL, "uxaimath.dll", "uxaimath_tanh_inplace_f64", VOID, CDECL, "PTR,I64", uxtensor.DataPtr(t), uxtensor.Size(t))
END SUB

SUB TensorReLU(t AS U64)
    CALL(DLL, "uxaimath.dll", "uxaimath_relu_inplace_f64", VOID, CDECL, "PTR,I64", uxtensor.DataPtr(t), uxtensor.Size(t))
END SUB

SUB TensorLeakyReLU(t AS U64, alpha AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_leaky_relu_inplace_f64", VOID, CDECL, "PTR,I64,F64", uxtensor.DataPtr(t), uxtensor.Size(t), alpha)
END SUB

SUB TensorGELU(t AS U64)
    CALL(DLL, "uxaimath.dll", "uxaimath_gelu_inplace_f64", VOID, CDECL, "PTR,I64", uxtensor.DataPtr(t), uxtensor.Size(t))
END SUB

SUB TensorSoftmax(src AS U64, dst AS U64)
    CALL(DLL, "uxaimath.dll", "uxaimath_softmax_f64", VOID, CDECL, "PTR,PTR,I64", uxtensor.DataPtr(src), uxtensor.DataPtr(dst), uxtensor.Size(src))
END SUB

' ---- loss functions ----
FUNCTION MSE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_mse_f64", F64, CDECL, "PTR,PTR,I64", yTruePtr, yPredPtr, n)
END FUNCTION

FUNCTION MAE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_mae_f64", F64, CDECL, "PTR,PTR,I64", yTruePtr, yPredPtr, n)
END FUNCTION

FUNCTION Huber(yTruePtr AS U64, yPredPtr AS U64, n AS I64, delta AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_huber_f64", F64, CDECL, "PTR,PTR,I64,F64", yTruePtr, yPredPtr, n, delta)
END FUNCTION

FUNCTION BinaryCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_bce_f64", F64, CDECL, "PTR,PTR,I64", yTruePtr, yPredPtr, n)
END FUNCTION

FUNCTION CategoricalCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_cce_f64", F64, CDECL, "PTR,PTR,I64", yTruePtr, yPredPtr, n)
END FUNCTION

SUB MSEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_mse_grad_f64", VOID, CDECL, "PTR,PTR,PTR,I64", yTruePtr, yPredPtr, outPtr, n)
END SUB

SUB BCEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_bce_grad_f64", VOID, CDECL, "PTR,PTR,PTR,I64", yTruePtr, yPredPtr, outPtr, n)
END SUB

' ---- initializers ----
SUB FillZeros(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_fill_zero_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB FillOnes(dataPtr AS U64, n AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_fill_one_f64", VOID, CDECL, "PTR,I64", dataPtr, n)
END SUB

SUB FillUniform(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_fill_uniform_f64", VOID, CDECL, "PTR,I64,F64,F64", dataPtr, n, lo, hi)
END SUB

SUB FillNormal(dataPtr AS U64, n AS I64, mean AS F64, stddev AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_fill_normal_f64", VOID, CDECL, "PTR,I64,F64,F64", dataPtr, n, mean, stddev)
END SUB

SUB XavierUniform(dataPtr AS U64, n AS I64, fanIn AS I64, fanOut AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_xavier_uniform_f64", VOID, CDECL, "PTR,I64,I64,I64", dataPtr, n, fanIn, fanOut)
END SUB

SUB HeUniform(dataPtr AS U64, n AS I64, fanIn AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_he_uniform_f64", VOID, CDECL, "PTR,I64,I64", dataPtr, n, fanIn)
END SUB

' ---- gradient / optimizer primitives ----
SUB ClipValue(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_clip_value_f64", VOID, CDECL, "PTR,I64,F64,F64", dataPtr, n, lo, hi)
END SUB

SUB ClipNorm(dataPtr AS U64, n AS I64, maxNorm AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_clip_norm_f64", VOID, CDECL, "PTR,I64,F64", dataPtr, n, maxNorm)
END SUB

SUB SGDUpdate(paramPtr AS U64, gradPtr AS U64, n AS I64, lr AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_sgd_update_f64", VOID, CDECL, "PTR,PTR,I64,F64", paramPtr, gradPtr, n, lr)
END SUB

SUB MomentumUpdate(paramPtr AS U64, gradPtr AS U64, velocityPtr AS U64, n AS I64, lr AS F64, momentum AS F64)
    CALL(DLL, "uxaimath.dll", "uxaimath_momentum_update_f64", VOID, CDECL, "PTR,PTR,PTR,I64,F64,F64", paramPtr, gradPtr, velocityPtr, n, lr, momentum)
END SUB

' ---- dense layer forward helpers ----
SUB DenseForward(inputPtr AS U64, weightPtr AS U64, biasPtr AS U64, outputPtr AS U64, inN AS I64, outN AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_dense_forward_f64", VOID, CDECL, "PTR,PTR,PTR,PTR,I64,I64", inputPtr, weightPtr, biasPtr, outputPtr, inN, outN)
END SUB

SUB DenseBatchForward(xPtr AS U64, weightPtr AS U64, biasPtr AS U64, yPtr AS U64, batch AS I64, inN AS I64, outN AS I64)
    CALL(DLL, "uxaimath.dll", "uxaimath_dense_batch_forward_f64", VOID, CDECL, "PTR,PTR,PTR,PTR,I64,I64,I64", xPtr, weightPtr, biasPtr, yPtr, batch, inN, outN)
END SUB

' ---- metrics ----
FUNCTION ArgMax(dataPtr AS U64, n AS I64) AS I64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_argmax_f64", I64, CDECL, "PTR,I64", dataPtr, n)
END FUNCTION

FUNCTION BinaryAccuracy(yTruePtr AS U64, yPredPtr AS U64, n AS I64, threshold AS F64) AS F64
    RETURN CALL(DLL, "uxaimath.dll", "uxaimath_binary_accuracy_f64", F64, CDECL, "PTR,PTR,I64,F64", yTruePtr, yPredPtr, n, threshold)
END FUNCTION

END NAMESPACE
