# UXMATHCORE 1A — corrected math core

## Purpose

`uxmathcore` is a low-level numeric data container and vector primitive layer for uXBasic extension packages.

It intentionally avoids duplicating uXBasic scalar math functions. It is not the matrix package, polynomial package, numerical-analysis package, or AI package.

## Core ideas

- typed numeric buffers for I8/U8/I16/U16/I32/U32/I64/U64/F32/F64;
- handle-based storage compatible with uXBasic `U64/PTR` style;
- generic get/set/push/fill/resize/clone/slice/cast operations;
- vectorized F64 primitives useful for later matrix/AI packages;
- old `libs/uxmath/uxmath.bas` kept only as compatibility vector core.

## Removed from uxmath boundary

- polynomial functions -> `uxpoly`
- numerical integral/ODE/root solvers -> `uxnum`
- matrix functions -> `uxmatrix`
- activation/loss/initializer functions -> `uxaimath`
- neural network layer/network builder -> `uxai`

## Files

```text
libs/uxmathcore/uxmathcore.bas
libs/uxmath/uxmath.bas
uxb/runtime_ext/uxmathcore/uxmathcore.c
uxb/runtime_ext/uxmathcore/uxmathcore.h
uxb/runtime_ext/uxmathcore/build_uxmathcore_dll.bat
uxb/tests/uxmathcore/*
uxb/compiler/scripts/run_uxmathcore_smoke.bat
```
