# UXNN2 Training / Optimizer Module

`uxnn2` is the second neural-network package for uXBasic. It focuses on training, optimizers, save/load and sample-array training.

## Scope

- trainable MLP network handle
- dense layers
- activations: linear, sigmoid, tanh, ReLU, leaky ReLU, softmax
- optimizers: SGD, momentum, Adam
- MSE loss
- sample training
- array training
- predict argmax
- save/load binary model format `.uxn2`

## Why pure C?

This module is still small enough that a reliable C core is better than forcing a heavy dependency. The DLL is built with MSYS2 UCRT64 GCC. Later packages can add ONNX Runtime / llama.cpp / oneDNN wrappers without changing the uXBasic language.

## Build

```bat
uxb\runtime_ext\uxnn2\fetch_uxnn2_deps_msys2.bat
uxb\compiler\scripts\run_uxnn2_smoke.bat
```
