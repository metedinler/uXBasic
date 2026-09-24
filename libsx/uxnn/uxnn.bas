' uXBasic Neural Network Standard Module
' Include with: INCLUDE "libs/uxnn/uxnn.bas"
' Backend: uxnn.dll. Uses plain C fallback or OpenBLAS-backed kernels when built with OpenBLAS.
' This module intentionally adds no new uXBasic keywords.

NAMESPACE uxnn

CONST UXNN_DLL = "uxnn.dll"

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

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_version", I32, CDECL)
END FUNCTION

FUNCTION Backend() AS STRING
    RETURN CALL(DLL, "uxnn.dll", "uxnn_backend", STRPTR, CDECL)
END FUNCTION

SUB Seed(seed AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_seed", VOID, CDECL, "U64", seed)
END SUB

' ---------- neuron ----------
FUNCTION NeuronCreate(inputCount AS I32, activation AS I32) AS U64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_neuron_create", PTR, CDECL, "I32,I32", inputCount, activation)
END FUNCTION

SUB NeuronFree(n AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_neuron_free", VOID, CDECL, "PTR", n)
END SUB

SUB NeuronSetWeight(n AS U64, index AS I32, value AS F64)
    CALL(DLL, "uxnn.dll", "uxnn_neuron_set_weight", VOID, CDECL, "PTR,I32,F64", n, index, value)
END SUB

FUNCTION NeuronGetWeight(n AS U64, index AS I32) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_neuron_get_weight", F64, CDECL, "PTR,I32", n, index)
END FUNCTION

SUB NeuronSetBias(n AS U64, value AS F64)
    CALL(DLL, "uxnn.dll", "uxnn_neuron_set_bias", VOID, CDECL, "PTR,F64", n, value)
END SUB

FUNCTION NeuronGetBias(n AS U64) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_neuron_get_bias", F64, CDECL, "PTR", n)
END FUNCTION

FUNCTION NeuronForwardPtr(n AS U64, inputPtr AS U64) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_neuron_forward_ptr", F64, CDECL, "PTR,PTR", n, inputPtr)
END FUNCTION

' ---------- layer ----------
FUNCTION DenseLayerCreate(inputDim AS I32, outputDim AS I32, activation AS I32) AS U64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_layer_dense_create", PTR, CDECL, "I32,I32,I32", inputDim, outputDim, activation)
END FUNCTION

FUNCTION ActivationLayerCreate(size AS I32, activation AS I32) AS U64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_layer_activation_create", PTR, CDECL, "I32,I32", size, activation)
END FUNCTION

SUB LayerFree(layer AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_layer_free", VOID, CDECL, "PTR", layer)
END SUB

FUNCTION LayerInputDim(layer AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_layer_input_dim", I32, CDECL, "PTR", layer)
END FUNCTION

FUNCTION LayerOutputDim(layer AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_layer_output_dim", I32, CDECL, "PTR", layer)
END FUNCTION

SUB LayerSetWeight(layer AS U64, outIndex AS I32, inIndex AS I32, value AS F64)
    CALL(DLL, "uxnn.dll", "uxnn_layer_set_weight", VOID, CDECL, "PTR,I32,I32,F64", layer, outIndex, inIndex, value)
END SUB

FUNCTION LayerGetWeight(layer AS U64, outIndex AS I32, inIndex AS I32) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_layer_get_weight", F64, CDECL, "PTR,I32,I32", layer, outIndex, inIndex)
END FUNCTION

SUB LayerSetBias(layer AS U64, outIndex AS I32, value AS F64)
    CALL(DLL, "uxnn.dll", "uxnn_layer_set_bias", VOID, CDECL, "PTR,I32,F64", layer, outIndex, value)
END SUB

FUNCTION LayerGetBias(layer AS U64, outIndex AS I32) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_layer_get_bias", F64, CDECL, "PTR,I32", layer, outIndex)
END FUNCTION

SUB LayerInit(layer AS U64, initKind AS I32, scale AS F64)
    CALL(DLL, "uxnn.dll", "uxnn_layer_init", VOID, CDECL, "PTR,I32,F64", layer, initKind, scale)
END SUB

SUB LayerForwardPtr(layer AS U64, inputPtr AS U64, outputPtr AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_layer_forward_ptr", VOID, CDECL, "PTR,PTR,PTR", layer, inputPtr, outputPtr)
END SUB

' ---------- network ----------
FUNCTION NetworkCreate() AS U64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_create", PTR, CDECL)
END FUNCTION

SUB NetworkFree(net AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_network_free", VOID, CDECL, "PTR", net)
END SUB

FUNCTION NetworkAddLayer(net AS U64, layer AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_add_layer", I32, CDECL, "PTR,PTR", net, layer)
END FUNCTION

FUNCTION NetworkLayerCount(net AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_layer_count", I32, CDECL, "PTR", net)
END FUNCTION

FUNCTION NetworkInputDim(net AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_input_dim", I32, CDECL, "PTR", net)
END FUNCTION

FUNCTION NetworkOutputDim(net AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_output_dim", I32, CDECL, "PTR", net)
END FUNCTION

SUB NetworkForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_network_forward_ptr", VOID, CDECL, "PTR,PTR,PTR", net, inputPtr, outputPtr)
END SUB

FUNCTION NetworkPredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_predict_argmax_ptr", I32, CDECL, "PTR,PTR", net, inputPtr)
END FUNCTION

FUNCTION NetworkMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_mse_ptr", F64, CDECL, "PTR,PTR,PTR,I32,I32,I32", net, xPtr, yPtr, sampleCount, inputDim, outputDim)
END FUNCTION

FUNCTION NetworkTrainMSESGDPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32, epochs AS I32, lr AS F64) AS F64
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_train_mse_sgd_ptr", F64, CDECL, "PTR,PTR,PTR,I32,I32,I32,I32,F64", net, xPtr, yPtr, sampleCount, inputDim, outputDim, epochs, lr)
END FUNCTION

' ---------- optional uxtensor bridge ----------
SUB NetworkForwardTensor(net AS U64, inputTensor AS U64, outputTensor AS U64)
    CALL(DLL, "uxnn.dll", "uxnn_network_forward_ptr", VOID, CDECL, "PTR,PTR,PTR", net, uxtensor.DataPtr(inputTensor), uxtensor.DataPtr(outputTensor))
END SUB

FUNCTION NetworkPredictArgmaxTensor(net AS U64, inputTensor AS U64) AS I32
    RETURN CALL(DLL, "uxnn.dll", "uxnn_network_predict_argmax_ptr", I32, CDECL, "PTR,PTR", net, uxtensor.DataPtr(inputTensor))
END FUNCTION

END NAMESPACE
