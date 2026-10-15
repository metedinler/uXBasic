# UXNN Neural Network Module

`uxnn` is the first neural-network layer on top of the previous `uxmathcore`, `uxtensor`, `uxmatrix`, and `uxaimath` packages.

It adds no uXBasic keywords. It is used through:

```basic
INCLUDE "libs/uxnn/uxnn.bas"
```

## Core concepts

- Neuron handle
- Dense layer handle
- Activation layer handle
- Network handle
- Plug-in layer builder: create a layer, initialize it, add it to a network
- Forward pass through the full network
- Basic MSE + SGD training for dense chains

## Dependency policy

Main build uses MSYS2 UCRT64 GCC + OpenBLAS. Fallback build uses pure C loops.

## Limitations

This is not yet a full deep-learning framework. It is the first usable neural-network runtime for uXBasic:

- dense feed-forward networks
- basic activations
- MSE SGD training
- pointer/tensor bridge

Next packages can add convolution, recurrent layers, dataset loaders, ONNX inference, and GPU/accelerator bridges.
