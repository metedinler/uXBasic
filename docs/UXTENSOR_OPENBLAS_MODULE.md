# UXTENSOR — uXBasic Tensor Module

`uxtensor` is the ND tensor layer on the path toward `uxaimath` and `uxai`.
It does not add new uXBasic keywords. It uses:

```basic
INCLUDE "libs/uxtensor/uxtensor.bas"
```

The wrapper calls `uxtensor.dll` through `CALL(DLL, ...)`.

## External dependency strategy

Primary backend:

- MSYS2 UCRT64 GCC
- OpenBLAS / CBLAS

Fallback backend:

- Plain C loops, no OpenBLAS

OpenBLAS provides optimized BLAS kernels and is used by `uxtensor` for `ddot`, `daxpy`, `dscal`, `dgemm`, and `dgemv` style operations. The fallback build is included so the module can still be tested when OpenBLAS is not available.

## Install / fetch dependencies

Open MSYS2 UCRT64 shell or run from Windows terminal:

```bat
uxb\runtime_ext\uxtensor\fetch_uxtensor_deps_msys2.bat
```

This installs/caches:

```text
mingw-w64-ucrt-x86_64-gcc
mingw-w64-ucrt-x86_64-openblas
pkgconf
```

It copies runtime DLLs into:

```text
uxb/dist/runtime_ext/deps/uxtensor
```

## Build

```bat
uxb\runtime_ext\uxtensor\build_uxtensor_dll.bat
```

Fallback:

```bat
uxb\runtime_ext\uxtensor\build_uxtensor_fallback_dll.bat
```

## Smoke test

```bat
uxb\compiler\scripts\run_uxtensor_smoke.bat
```

## Function families

- Tensor create/free/clone
- Shape/stride/size/dtype metadata
- Flat/2D/3D/4D F64 get/set
- Elementwise F64 add/sub/mul/div/scale
- Sum/mean/dot/norm2
- 2D matmul / matvec / transpose
- Raw BLAS bridge: ddot/daxpy/dscal/dgemm

## Honest boundary

This is a dense CPU F64 tensor layer. It is not yet an autograd engine. It does not yet wrap ggml, oneDNN, ONNX Runtime or CUDA. Those are candidates for later `uxai`/`uxnn` packages.
