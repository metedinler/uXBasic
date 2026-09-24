' uXBasic Dataset Module
' Include with: INCLUDE "libs/uxdataset/uxdataset.bas"
' Backend: uxdataset.dll. New keywords are not required.
'
' Purpose:
'   CSV / array / batch-loader / normalization bridge for uxnn2 and future AI libs.

NAMESPACE uxdataset

CONST UXDATASET_DLL = "uxdataset.dll"

' Split constants
CONST SPLIT_TRAIN = 0
CONST SPLIT_TEST = 1

' Normalize constants
CONST NORM_STANDARD = 1
CONST NORM_MINMAX = 2

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_version", I32, CDECL)
END FUNCTION

FUNCTION Backend() AS STRING
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_backend", STRPTR, CDECL)
END FUNCTION

FUNCTION Create(rows AS I32, inputDim AS I32, targetDim AS I32) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_create", PTR, CDECL, "I32,I32,I32", rows, inputDim, targetDim)
END FUNCTION

SUB Free(ds AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_free", VOID, CDECL, "PTR", ds)
END SUB

FUNCTION Clone(ds AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_clone", PTR, CDECL, "PTR", ds)
END FUNCTION

FUNCTION LoadCSV(path AS STRING, inputDim AS I32, targetDim AS I32, hasHeader AS I32) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_load_csv", PTR, CDECL, "STRPTR,I32,I32,I32", path, inputDim, targetDim, hasHeader)
END FUNCTION

FUNCTION SaveCSV(ds AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_save_csv", I32, CDECL, "PTR,STRPTR", ds, path)
END FUNCTION

FUNCTION RowCount(ds AS U64) AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_row_count", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION InputDim(ds AS U64) AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_input_dim", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION TargetDim(ds AS U64) AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_target_dim", I32, CDECL, "PTR", ds)
END FUNCTION

FUNCTION XPtr(ds AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_x_ptr", PTR, CDECL, "PTR", ds)
END FUNCTION

FUNCTION YPtr(ds AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_y_ptr", PTR, CDECL, "PTR", ds)
END FUNCTION

FUNCTION GetX(ds AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_get_x", F64, CDECL, "PTR,I32,I32", ds, row, col)
END FUNCTION

SUB SetX(ds AS U64, row AS I32, col AS I32, value AS F64)
    CALL(DLL, "uxdataset.dll", "uxdataset_set_x", VOID, CDECL, "PTR,I32,I32,F64", ds, row, col, value)
END SUB

FUNCTION GetY(ds AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_get_y", F64, CDECL, "PTR,I32,I32", ds, row, col)
END FUNCTION

SUB SetY(ds AS U64, row AS I32, col AS I32, value AS F64)
    CALL(DLL, "uxdataset.dll", "uxdataset_set_y", VOID, CDECL, "PTR,I32,I32,F64", ds, row, col, value)
END SUB

SUB Shuffle(ds AS U64, seed AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_shuffle", VOID, CDECL, "PTR,U64", ds, seed)
END SUB

FUNCTION SplitTrain(ds AS U64, trainRatio AS F64, seed AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_split_train", PTR, CDECL, "PTR,F64,U64", ds, trainRatio, seed)
END FUNCTION

FUNCTION SplitTest(ds AS U64, trainRatio AS F64, seed AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_split_test", PTR, CDECL, "PTR,F64,U64", ds, trainRatio, seed)
END FUNCTION

FUNCTION ScalerFitStandard(ds AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_scaler_fit_standard", PTR, CDECL, "PTR", ds)
END FUNCTION

FUNCTION ScalerFitMinMax(ds AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_scaler_fit_minmax", PTR, CDECL, "PTR", ds)
END FUNCTION

SUB ScalerFree(sc AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_scaler_free", VOID, CDECL, "PTR", sc)
END SUB

SUB ScalerTransform(sc AS U64, ds AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_scaler_transform", VOID, CDECL, "PTR,PTR", sc, ds)
END SUB

SUB ScalerInverseTransform(sc AS U64, ds AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_scaler_inverse_transform", VOID, CDECL, "PTR,PTR", sc, ds)
END SUB

SUB FillMissingMean(ds AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_fill_missing_mean", VOID, CDECL, "PTR", ds)
END SUB

FUNCTION BatchCreate(ds AS U64, batchSize AS I32, shuffle AS I32, seed AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_create", PTR, CDECL, "PTR,I32,I32,U64", ds, batchSize, shuffle, seed)
END FUNCTION

SUB BatchFree(loader AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_batch_free", VOID, CDECL, "PTR", loader)
END SUB

SUB BatchReset(loader AS U64)
    CALL(DLL, "uxdataset.dll", "uxdataset_batch_reset", VOID, CDECL, "PTR", loader)
END SUB

FUNCTION BatchNext(loader AS U64) AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_next", I32, CDECL, "PTR", loader)
END FUNCTION

FUNCTION BatchRows(loader AS U64) AS I32
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_rows", I32, CDECL, "PTR", loader)
END FUNCTION

FUNCTION BatchXPtr(loader AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_x_ptr", PTR, CDECL, "PTR", loader)
END FUNCTION

FUNCTION BatchYPtr(loader AS U64) AS U64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_y_ptr", PTR, CDECL, "PTR", loader)
END FUNCTION

FUNCTION BatchGetX(loader AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_get_x", F64, CDECL, "PTR,I32,I32", loader, row, col)
END FUNCTION

FUNCTION BatchGetY(loader AS U64, row AS I32, col AS I32) AS F64
    RETURN CALL(DLL, "uxdataset.dll", "uxdataset_batch_get_y", F64, CDECL, "PTR,I32,I32", loader, row, col)
END FUNCTION

END NAMESPACE
