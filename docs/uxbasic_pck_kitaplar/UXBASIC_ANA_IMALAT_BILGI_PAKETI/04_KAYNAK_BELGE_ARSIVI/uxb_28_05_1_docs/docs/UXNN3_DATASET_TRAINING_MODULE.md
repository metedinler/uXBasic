# UXNN3 Dataset-Aware Training Module

`uxnn3` is the high-level dataset-aware training bridge in the uXBasic AI stack.
It does not introduce new uXBasic keywords. It is used through:

```basic
INCLUDE "libs/uxnn3/uxnn3.bas"
```

## Position in the AI stack

```text
uxmathcore  -> typed numeric buffers
uxmatrix    -> linear algebra
uxtensor    -> ND tensors
uxaimath    -> activation/loss/initializer primitives
uxnn        -> layer/network forward basics
uxnn2       -> MLP training core
uxdataset   -> dataset helpers
uxdataframe -> DuckDB dataframe/table bridge
uxnn3       -> dataset-aware training pipeline
```

## Features

- Dataset create/free
- CSV load/save
- X/Y pointer bridge
- shuffle
- train/test split
- standard scaler
- minmax scaler
- MLP model create/free
- add dense layer
- init weights
- SGD / Momentum
- dataset training
- MSE evaluation
- binary accuracy
- model save/load `.uxn3`

## Build

```bat
uxb\runtime_ext\uxnn3\fetch_uxnn3_deps_msys2.bat
uxb\runtime_ext\uxnn3\build_uxnn3_dll.bat
```

## Smoke test

```bat
uxb\compiler\scripts\run_uxnn3_smoke.bat
```

## Honest boundary

This module is a compact C MLP training engine. It does not yet wrap a heavy external ML framework.
For larger production inference/training, the later packages should be:

- `uxonnx` via ONNX Runtime
- `uxmlpack` via mlpack C++ if a stable C ABI wrapper is written
- `uxtorch` only through a separate process or C ABI adapter, not directly in the compiler
