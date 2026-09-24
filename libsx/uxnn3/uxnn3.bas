' uXBasic uxnn3 dataset-aware neural training wrapper
' Usage: INCLUDE "libs/uxnn3/uxnn3.bas"

NAMESPACE uxnn3

CONST UXNN3_DLL = "uxnn3.dll"

CONST ACT_LINEAR = 0
CONST ACT_SIGMOID = 1
CONST ACT_TANH = 2
CONST ACT_RELU = 3
CONST ACT_LEAKY_RELU = 4

CONST OPT_SGD = 1
CONST OPT_MOMENTUM = 2

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_version", I32, CDECL)
END FUNCTION

FUNCTION LastError() AS STRING
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_last_error", STRPTR, CDECL)
END FUNCTION

FUNCTION DatasetCreate(rows AS I32, inputDim AS I32, outputDim AS I32) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_create", PTR, CDECL, "I32,I32,I32", rows, inputDim, outputDim)
END FUNCTION

SUB DatasetFree(ds AS U64)
    CALL(DLL, "uxnn3.dll", "uxnn3_dataset_free", VOID, CDECL, "PTR", ds)
END SUB

FUNCTION LoadCSV(path AS STRING, inputDim AS I32, outputDim AS I32, hasHeader AS I32) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_load_csv", PTR, CDECL, "STRPTR,I32,I32,I32", path, inputDim, outputDim, hasHeader)
END FUNCTION

FUNCTION SaveCSV(ds AS U64, path AS STRING, includeHeader AS I32) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_save_csv", I32, CDECL, "PTR,STRPTR,I32", ds, path, includeHeader)
END FUNCTION

FUNCTION Rows(ds AS U64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_rows", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION InputDim(ds AS U64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_input_dim", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION OutputDim(ds AS U64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_output_dim", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION XGet(ds AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_x_get", F64, CDECL, "PTR,I32,I32", ds, row, col)
END FUNCTION

FUNCTION YGet(ds AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_y_get", F64, CDECL, "PTR,I32,I32", ds, row, col)
END FUNCTION

FUNCTION XSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_x_set", I32, CDECL, "PTR,I32,I32,F64", ds, row, col, v)
END FUNCTION

FUNCTION YSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_y_set", I32, CDECL, "PTR,I32,I32,F64", ds, row, col, v)
END FUNCTION

FUNCTION XPtr(ds AS U64) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_x_ptr", PTR, CDECL, "PTR", ds)
END FUNCTION

FUNCTION YPtr(ds AS U64) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_y_ptr", PTR, CDECL, "PTR", ds)
END FUNCTION

FUNCTION Shuffle(ds AS U64, seed AS U32) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_shuffle", I32, CDECL, "PTR,U32", ds, seed)
END FUNCTION

FUNCTION SplitTrain(ds AS U64, ratio AS F64, seed AS U32) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_split_train", PTR, CDECL, "PTR,F64,U32", ds, ratio, seed)
END FUNCTION

FUNCTION SplitTest(ds AS U64, ratio AS F64, seed AS U32) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_split_test", PTR, CDECL, "PTR,F64,U32", ds, ratio, seed)
END FUNCTION

FUNCTION Standardize(ds AS U64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_standardize_fit_transform", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION MinMax(ds AS U64, a AS F64, b AS F64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_dataset_minmax_fit_transform", I32, CDECL, "PTR,F64,F64", ds, a, b)
END FUNCTION

FUNCTION ModelCreate(inputDim AS I32) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_create", PTR, CDECL, "I32", inputDim)
END FUNCTION

SUB ModelFree(model AS U64)
    CALL(DLL, "uxnn3.dll", "uxnn3_model_free", VOID, CDECL, "PTR", model)
END SUB

FUNCTION AddDense(model AS U64, outputDim AS I32, activation AS I32) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_add_dense", I32, CDECL, "PTR,I32,I32", model, outputDim, activation)
END FUNCTION

FUNCTION Init(model AS U64, seed AS U32, scale AS F64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_init", I32, CDECL, "PTR,U32,F64", model, seed, scale)
END FUNCTION

FUNCTION SetOptimizer(model AS U64, opt AS I32, lr AS F64, momentum AS F64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_set_optimizer", I32, CDECL, "PTR,I32,F64,F64", model, opt, lr, momentum)
END FUNCTION

FUNCTION LayerCount(model AS U64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_layer_count", I32, CDECL, "PTR", model)
END FUNCTION

FUNCTION ModelOutputDim(model AS U64) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_output_dim", I32, CDECL, "PTR", model)
END FUNCTION

FUNCTION PredictArgMax(model AS U64, ds AS U64, row AS I32) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_predict_argmax", I32, CDECL, "PTR,PTR,I32", model, ds, row)
END FUNCTION

FUNCTION TrainDataset(model AS U64, ds AS U64, epochs AS I32, batchSize AS I32, shuffle AS I32, seed AS U32) AS F64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_train_dataset", F64, CDECL, "PTR,PTR,I32,I32,I32,U32", model, ds, epochs, batchSize, shuffle, seed)
END FUNCTION

FUNCTION EvalMSE(model AS U64, ds AS U64) AS F64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_eval_mse", F64, CDECL, "PTR,PTR", model, ds)
END FUNCTION

FUNCTION EvalBinaryAccuracy(model AS U64, ds AS U64, threshold AS F64) AS F64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_eval_binary_accuracy", F64, CDECL, "PTR,PTR,F64", model, ds, threshold)
END FUNCTION

FUNCTION Save(model AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_save", I32, CDECL, "PTR,STRPTR", model, path)
END FUNCTION

FUNCTION Load(path AS STRING) AS U64
    RETURN CALL(DLL, "uxnn3.dll", "uxnn3_model_load", PTR, CDECL, "STRPTR", path)
END FUNCTION

END NAMESPACE
