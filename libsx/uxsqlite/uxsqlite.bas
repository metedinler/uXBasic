NAMESPACE uxsqlite

CONST SQLITE_OK = 0
CONST SQLITE_ROW = 100
CONST SQLITE_DONE = 101

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Open(path AS STRING) AS U64
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_open", PTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION OpenMemory() AS U64
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_open_memory", PTR, CDECL)
END FUNCTION

SUB Close(db AS U64)
    CALL(DLL, "uxsqlite.dll", "uxsqlite_close", VOID, CDECL, "PTR", db)
END SUB

FUNCTION Exec(db AS U64, sql AS STRING) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_exec", I32, CDECL, "PTR,STRPTR", db, sql)
END FUNCTION

FUNCTION Prepare(db AS U64, sql AS STRING) AS U64
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_prepare", PTR, CDECL, "PTR,STRPTR", db, sql)
END FUNCTION

SUB Finalize(stmt AS U64)
    CALL(DLL, "uxsqlite.dll", "uxsqlite_stmt_finalize", VOID, CDECL, "PTR", stmt)
END SUB

FUNCTION BindI64(stmt AS U64, index1 AS I32, value AS I64) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_bind_i64", I32, CDECL, "PTR,I32,I64", stmt, index1, value)
END FUNCTION

FUNCTION BindF64(stmt AS U64, index1 AS I32, value AS F64) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_bind_f64", I32, CDECL, "PTR,I32,F64", stmt, index1, value)
END FUNCTION

FUNCTION BindText(stmt AS U64, index1 AS I32, value AS STRING) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_bind_text", I32, CDECL, "PTR,I32,STRPTR", stmt, index1, value)
END FUNCTION

FUNCTION Step(stmt AS U64) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_step", I32, CDECL, "PTR", stmt)
END FUNCTION

FUNCTION Reset(stmt AS U64) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_reset", I32, CDECL, "PTR", stmt)
END FUNCTION

FUNCTION ColumnCount(stmt AS U64) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_column_count", I32, CDECL, "PTR", stmt)
END FUNCTION

FUNCTION ColumnType(stmt AS U64, column0 AS I32) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_column_type", I32, CDECL, "PTR,I32", stmt, column0)
END FUNCTION

FUNCTION ColumnI64(stmt AS U64, column0 AS I32) AS I64
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_column_i64", I64, CDECL, "PTR,I32", stmt, column0)
END FUNCTION

FUNCTION ColumnF64(stmt AS U64, column0 AS I32) AS F64
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_column_f64", F64, CDECL, "PTR,I32", stmt, column0)
END FUNCTION

FUNCTION ColumnText(stmt AS U64, column0 AS I32) AS STRING
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_column_text", STRPTR, CDECL, "PTR,I32", stmt, column0)
END FUNCTION

FUNCTION LastInsertRowId(db AS U64) AS I64
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_last_insert_rowid", I64, CDECL, "PTR", db)
END FUNCTION

FUNCTION Changes(db AS U64) AS I32
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_changes", I32, CDECL, "PTR", db)
END FUNCTION

FUNCTION ErrorText(db AS U64) AS STRING
    RETURN CALL(DLL, "uxsqlite.dll", "uxsqlite_error", STRPTR, CDECL, "PTR", db)
END FUNCTION

END NAMESPACE
