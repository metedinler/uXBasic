# uxmatrix roadmap

## Current package

`uxmatrix` is the F64 dense matrix layer, backed by OpenBLAS/LAPACK when available.

## Next AI path

1. `uxtensor`: tensor shape/strides, ND arrays, batch operations.
2. `uxaimath`: activation/loss/initializer routines, using uxmatrix/uxtensor.
3. `uxai`: neuron/layer/network model.

## External library principle

Before implementing manually, prefer external C/C++/DLL libraries:

- OpenBLAS/LAPACK for dense linear algebra.
- SuiteSparse/UMFPACK for sparse matrix work.
- MPLAPACK/MPFR for high precision F80/F128/BIGF/BIGD/BALL matrix variants.
- ONNX Runtime later for model inference bridge.
