# UXDATASET module

`uxdataset` is the AI data preparation layer between CSV/raw arrays and `uxnn2` training.

It does not implement dataframe analytics. That belongs to a later `uxdataframe` package, likely via DuckDB/Arrow.

## Functions

- Dataset create/free/clone
- Numeric CSV load/save
- X/Y pointer bridge for `uxnn2_train_array_mse_ptr`
- Shuffle
- Train/test split
- Missing-value mean fill
- Standard scaler
- MinMax scaler
- Batch loader

## Dependency policy

This package uses standard C only. No heavy external dependency is needed. The registry is still provided so the programmer handbook can track it.

## Test

```bat
uxb\compiler\scripts\run_uxdataset_smoke.bat
```
