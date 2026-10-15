# uxmatrix — OpenBLAS/LAPACK based matrix module for uXBasic

This package is on the path toward `uxaimath` and `uxai`. Neural networks, regression, PCA, decomposition and future tensor tools should use this module instead of re-implementing dense linear algebra in BASIC.

## Principle

No new uXBasic keyword is added.

```basic
INCLUDE "libs/uxmatrix/uxmatrix.bas"
```

The BASIC wrapper calls `uxmatrix.dll` through `CALL(DLL)`. The DLL uses OpenBLAS/CBLAS and, when available, LAPACKE routines.

## MSYS2 UCRT64 dependencies

Open the MSYS2 UCRT64 shell and run:

```bash
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-openblas pkgconf
```

## Build

```bat
uxb\runtime_ext\uxmatrix\build_uxmatrix_dll.bat
```

Fallback without OpenBLAS:

```bat
uxb\runtime_ext\uxmatrix\build_uxmatrix_fallback_dll.bat
```

Fallback supports basic matrix creation/add/sub/scale/mul/dot/norm/trace but not LAPACK decompositions.

## Smoke test

```bat
uxb\compiler\scripts\run_uxmatrix_smoke.bat
```

## Main functions

- Create/free/rows/cols/size/data pointer
- Get/set/fill/zero/eye/clone
- Add/sub/scale/mul/matvec/dot
- Norm L1/L2/Frobenius, trace
- Solve linear system, determinant, inverse
- Cholesky, QR, SVD, symmetric eigen
- Rank via SVD, condition number
- Raw BLAS bridge: ddot/daxpy/dgemm

## Boundary

- This package is F64 dense matrix first.
- F80/F128/BIGF/BIGD/BALL matrix variants should be separate future packages or wrappers over MPLAPACK/MPFR-backed libraries.
- Sparse matrices should be a separate `uxsparse` module.
- DataFrame should stay in `uxdataframe`; graph stays in `uxgraph`.
