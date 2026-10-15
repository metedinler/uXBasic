# UXDATAFRAME — DuckDB-backed DataFrame module

`uxdataframe` is the table/dataframe layer in the uXBasic AI/data path.
It does not add new uXBasic keywords. It exposes a `.bas` include wrapper over
`uxdataframe.dll`, and the DLL dynamically loads `duckdb.dll`.

## Dependency strategy

Primary backend: DuckDB C API.

DuckDB is used as an embedded analytical SQL engine. CSV/Parquet loading,
filtering, projection, grouping, joining and export are delegated to DuckDB.
The wrapper only manages handles and simple function calls.

## Files

```text
libs/uxdataframe/uxdataframe.bas
uxb/runtime_ext/uxdataframe/uxdataframe_duckdb.c
uxb/runtime_ext/uxdataframe/uxdataframe.h
uxb/runtime_ext/uxdataframe/fetch_uxdataframe_duckdb_deps.ps1
uxb/runtime_ext/uxdataframe/build_uxdataframe_dll.bat
uxb/tests/uxdataframe/
```

## Install dependencies

```bat
powershell -ExecutionPolicy Bypass -File uxb\runtime_ext\uxdataframe\fetch_uxdataframe_duckdb_deps.ps1
```

This caches:

```text
uxb/dist/runtime_ext/deps/uxdataframe/bin/duckdb.dll
uxb/dist/runtime_ext/deps/uxdataframe/include/duckdb.h
uxb/dist/runtime_ext/deps/uxdataframe/uxdataframe_dependency_registry.json
uxb/dist/runtime_ext/deps/uxdataframe/uxdataframe_dependency_registry.csv
```

## Build and test

```bat
uxb\compiler\scripts\run_uxdataframe_smoke.bat
```

## uXBasic example

```basic
INCLUDE "libs/uxdataframe/uxdataframe.bas"

df = uxdataframe.LoadCSV("data.csv", 1)
PRINT uxdataframe.RowCount(df)
PRINT uxdataframe.ColCount(df)

small = uxdataframe.Filter(df, "species = 'setosa'")
summary = uxdataframe.Describe(df)

m = uxdataframe.ToF64Matrix(uxdataframe.SelectCols(df, "x,y,z"))
ptr = uxdataframe.MatrixDataPtr(m)

uxdataframe.MatrixFree(m)
uxdataframe.Free(summary)
uxdataframe.Free(small)
uxdataframe.Free(df)
```

## Roadmap

- Arrow C data interface bridge
- zero-copy handoff to `uxtensor`
- categorical encoding helpers
- missing value policy helpers
- direct `uxdataset` conversion
