' uxdataframe.bas - DuckDB-backed dataframe wrapper for uXBasic.
' Include with: INCLUDE "libs/uxdataframe/uxdataframe.bas"

NAMESPACE uxdataframe

CONST UXDATAFRAME_DLL = "uxdataframe.dll"

FUNCTION RuntimeVersion() AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_runtime_version", I32, CDECL)
END FUNCTION

FUNCTION DuckDBAvailable() AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_duckdb_available", I32, CDECL)
END FUNCTION

FUNCTION DuckDBVersion() AS STRING
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_duckdb_version", STRPTR, CDECL)
END FUNCTION

FUNCTION LastError(df AS U64) AS STRING
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_last_error", STRPTR, CDECL, "PTR", df)
END FUNCTION

FUNCTION OpenMemory() AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_open_memory", PTR, CDECL)
END FUNCTION

FUNCTION OpenDatabase(path AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_open_database", PTR, CDECL, "STRPTR", path)
END FUNCTION

SUB Free(df AS U64)
    CALL(DLL, "uxdataframe.dll", "uxdf_free", VOID, CDECL, "PTR", df)
END SUB

FUNCTION LoadCSV(path AS STRING, header AS I32) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_load_csv", PTR, CDECL, "STRPTR,I32", path, header)
END FUNCTION

FUNCTION LoadParquet(path AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_load_parquet", PTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION Exec(df AS U64, sql AS STRING) AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_exec", I32, CDECL, "PTR,STRPTR", df, sql)
END FUNCTION

FUNCTION Query(df AS U64, sql AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_query", PTR, CDECL, "PTR,STRPTR", df, sql)
END FUNCTION

FUNCTION RowCount(df AS U64) AS I64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_row_count", I64, CDECL, "PTR", df)
END FUNCTION

FUNCTION ColCount(df AS U64) AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_col_count", I32, CDECL, "PTR", df)
END FUNCTION

FUNCTION ColName(df AS U64, col AS I32) AS STRING
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_col_name", STRPTR, CDECL, "PTR,I32", df, col)
END FUNCTION

FUNCTION GetF64(df AS U64, row AS I64, col AS I32) AS F64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_get_f64", F64, CDECL, "PTR,I64,I32", df, row, col)
END FUNCTION

FUNCTION GetText(df AS U64, row AS I64, col AS I32) AS STRING
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_get_text", STRPTR, CDECL, "PTR,I64,I32", df, row, col)
END FUNCTION

FUNCTION Head(df AS U64, n AS I64) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_head", PTR, CDECL, "PTR,I64", df, n)
END FUNCTION

FUNCTION SelectCols(df AS U64, columns AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_select", PTR, CDECL, "PTR,STRPTR", df, columns)
END FUNCTION

FUNCTION Filter(df AS U64, whereSql AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_filter", PTR, CDECL, "PTR,STRPTR", df, whereSql)
END FUNCTION

FUNCTION OrderBy(df AS U64, orderSql AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_order_by", PTR, CDECL, "PTR,STRPTR", df, orderSql)
END FUNCTION

FUNCTION Describe(df AS U64) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_describe", PTR, CDECL, "PTR", df)
END FUNCTION

FUNCTION GroupMean(df AS U64, groupCol AS STRING, valueCol AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_group_mean", PTR, CDECL, "PTR,STRPTR,STRPTR", df, groupCol, valueCol)
END FUNCTION

FUNCTION JoinInner(leftDf AS U64, rightDf AS U64, leftKey AS STRING, rightKey AS STRING) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_join_inner", PTR, CDECL, "PTR,PTR,STRPTR,STRPTR", leftDf, rightDf, leftKey, rightKey)
END FUNCTION

FUNCTION ToCSV(df AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_to_csv", I32, CDECL, "PTR,STRPTR", df, path)
END FUNCTION

FUNCTION ToParquet(df AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_to_parquet", I32, CDECL, "PTR,STRPTR", df, path)
END FUNCTION

FUNCTION ToF64Matrix(df AS U64) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_to_f64_matrix", PTR, CDECL, "PTR", df)
END FUNCTION

SUB MatrixFree(m AS U64)
    CALL(DLL, "uxdataframe.dll", "uxdf_matrix_free", VOID, CDECL, "PTR", m)
END SUB

FUNCTION MatrixRows(m AS U64) AS I64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_matrix_rows", I64, CDECL, "PTR", m)
END FUNCTION

FUNCTION MatrixCols(m AS U64) AS I32
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_matrix_cols", I32, CDECL, "PTR", m)
END FUNCTION

FUNCTION MatrixDataPtr(m AS U64) AS U64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_matrix_data_ptr", PTR, CDECL, "PTR", m)
END FUNCTION

FUNCTION MatrixGet(m AS U64, row AS I64, col AS I32) AS F64
    RETURN CALL(DLL, "uxdataframe.dll", "uxdf_matrix_get", F64, CDECL, "PTR,I64,I32", m, row, col)
END FUNCTION

END NAMESPACE
