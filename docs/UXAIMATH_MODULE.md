# UXAIMATH — AI Math Layer

`uxaimath` is the AI-specific math layer above `uxtensor` and `uxmatrix`.
It must not duplicate ordinary scalar BASIC math functions just to rename them.
It provides AI-oriented activations, losses, initializers, gradients, metrics and dense forward helpers.

## Build

```bat
uxb\runtime_ext\uxaimath\fetch_uxaimath_deps_msys2.bat
uxb\runtime_ext\uxaimath\build_uxaimath_dll.bat
```

Fallback build without OpenBLAS:

```bat
uxb\runtime_ext\uxaimath\build_uxaimath_fallback_dll.bat
```

## Smoke

```bat
uxb\compiler\scripts\run_uxaimath_smoke.bat
```

## Layer position

```text
uxmathcore -> uxtensor/uxmatrix -> uxaimath -> uxnn
```

Next package: `uxnn`, the neuron/layer/network handle system.
