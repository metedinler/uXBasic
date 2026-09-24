' uXBasic Neural Network Training Module v2
' Include with: INCLUDE "libs/uxnn2/uxnn2.bas"
' Backend: uxnn2.dll. New keywords are not required.

NAMESPACE uxnn2

CONST UXNN2_DLL = "uxnn2.dll"

' Activation ids
CONST ACT_LINEAR = 0
CONST ACT_SIGMOID = 1
CONST ACT_TANH = 2
CONST ACT_RELU = 3
CONST ACT_LEAKY_RELU = 4
CONST ACT_SOFTMAX = 5

' Initializer ids
CONST INIT_ZEROS = 0
CONST INIT_UNIFORM = 1
CONST INIT_XAVIER = 2
CONST INIT_HE = 3

' Optimizer ids
CONST OPT_SGD = 0
CONST OPT_MOMENTUM = 1
CONST OPT_ADAM = 2

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_version", I32, CDECL)
END FUNCTION

FUNCTION Backend() AS STRING
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_backend", STRPTR, CDECL)
END FUNCTION

SUB Seed(seed AS U64)
    CALL(DLL, "uxnn2.dll", "uxnn2_seed", VOID, CDECL, "U64", seed)
END SUB

FUNCTION NetworkCreate(inputDim AS I32) AS U64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_network_create", PTR, CDECL, "I32", inputDim)
END FUNCTION

SUB NetworkFree(net AS U64)
    CALL(DLL, "uxnn2.dll", "uxnn2_network_free", VOID, CDECL, "PTR", net)
END SUB

FUNCTION AddDense(net AS U64, outputDim AS I32, activation AS I32) AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_network_add_dense", I32, CDECL, "PTR,I32,I32", net, outputDim, activation)
END FUNCTION

FUNCTION LayerCount(net AS U64) AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_network_layer_count", I32, CDECL, "PTR", net)
END FUNCTION

FUNCTION InputDim(net AS U64) AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_network_input_dim", I32, CDECL, "PTR", net)
END FUNCTION

FUNCTION OutputDim(net AS U64) AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_network_output_dim", I32, CDECL, "PTR", net)
END FUNCTION

SUB Init(net AS U64, initKind AS I32, scale AS F64)
    CALL(DLL, "uxnn2.dll", "uxnn2_network_init", VOID, CDECL, "PTR,I32,F64", net, initKind, scale)
END SUB

SUB SetOptimizer(net AS U64, optKind AS I32, learningRate AS F64)
    CALL(DLL, "uxnn2.dll", "uxnn2_set_optimizer", VOID, CDECL, "PTR,I32,F64", net, optKind, learningRate)
END SUB

SUB SetOptimizerParams(net AS U64, beta1 AS F64, beta2 AS F64, epsilon AS F64, weightDecay AS F64)
    CALL(DLL, "uxnn2.dll", "uxnn2_set_optimizer_params", VOID, CDECL, "PTR,F64,F64,F64,F64", net, beta1, beta2, epsilon, weightDecay)
END SUB

SUB ForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64)
    CALL(DLL, "uxnn2.dll", "uxnn2_forward_ptr", VOID, CDECL, "PTR,PTR,PTR", net, inputPtr, outputPtr)
END SUB

FUNCTION LossMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_loss_mse_ptr", F64, CDECL, "PTR,PTR,PTR", net, inputPtr, targetPtr)
END FUNCTION

FUNCTION TrainSampleMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_train_sample_mse_ptr", F64, CDECL, "PTR,PTR,PTR", net, inputPtr, targetPtr)
END FUNCTION

FUNCTION TrainArrayMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, epochs AS I32, shuffle AS I32) AS F64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_train_array_mse_ptr", F64, CDECL, "PTR,PTR,PTR,I32,I32,I32", net, xPtr, yPtr, sampleCount, epochs, shuffle)
END FUNCTION

FUNCTION PredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_predict_argmax_ptr", I32, CDECL, "PTR,PTR", net, inputPtr)
END FUNCTION

FUNCTION GetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32) AS F64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_get_weight", F64, CDECL, "PTR,I32,I32,I32", net, layerIndex, outIndex, inIndex)
END FUNCTION

SUB SetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32, value AS F64)
    CALL(DLL, "uxnn2.dll", "uxnn2_set_weight", VOID, CDECL, "PTR,I32,I32,I32,F64", net, layerIndex, outIndex, inIndex, value)
END SUB

FUNCTION GetBias(net AS U64, layerIndex AS I32, outIndex AS I32) AS F64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_get_bias", F64, CDECL, "PTR,I32,I32", net, layerIndex, outIndex)
END FUNCTION

SUB SetBias(net AS U64, layerIndex AS I32, outIndex AS I32, value AS F64)
    CALL(DLL, "uxnn2.dll", "uxnn2_set_bias", VOID, CDECL, "PTR,I32,I32,F64", net, layerIndex, outIndex, value)
END SUB

FUNCTION Save(net AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_save", I32, CDECL, "PTR,STRPTR", net, path)
END FUNCTION

FUNCTION Load(path AS STRING) AS U64
    RETURN CALL(DLL, "uxnn2.dll", "uxnn2_load", PTR, CDECL, "STRPTR", path)
END FUNCTION

END NAMESPACE
