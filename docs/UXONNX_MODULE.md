# UXONNX — ONNX Runtime wrapper for uXBasic

`uxonnx` lets uXBasic load ONNX models and run inference through `onnxruntime.dll`.

## Design

- No new uXBasic keyword.
- `INCLUDE "libs/uxonnx/uxonnx.bas"` wrapper.
- C DLL wrapper: `uxonnx.dll`.
- External runtime: `onnxruntime.dll`.
- Runtime DLL is loaded dynamically with `LoadLibrary/GetProcAddress`.

## Dependency download

```bat
uxb\runtime_ext\uxonnx\fetch_uxonnx_deps.bat
```

This downloads the Windows x64 CPU release asset from Microsoft ONNX Runtime GitHub releases and writes:

```text
uxb/dist/runtime_ext/deps/uxonnx/onnxruntime.dll
uxb/dist/runtime_ext/deps/uxonnx/include/onnxruntime_c_api.h
uxb/dist/runtime_ext/deps/uxonnx/uxonnx_dependency_registry.json
uxb/dist/runtime_ext/deps/uxonnx/uxonnx_dependency_registry.csv
```

## Build and smoke test

```bat
uxb\compiler\scripts\run_uxonnx_smoke.bat
```

To test a real ONNX model with the C probe:

```bat
uxb\tests\uxonnx\build_and_run_uxonnx_probe.bat path\to\model.onnx
```

## Minimal uXBasic usage

```basic
INCLUDE "libs/uxonnx/uxonnx.bas"

ok = uxonnx.Init("uxb\\dist\\runtime_ext\\deps\\uxonnx")
s = uxonnx.SessionCreate("model.onnx", 1)
PRINT uxonnx.InputName(s, 0)
PRINT uxonnx.OutputName(s, 0)

x = uxonnx.TensorCreate2D(1, 4)
uxonnx.TensorSet(x, 0, 1.0)
out = uxonnx.Run1(s, uxonnx.InputName(s, 0), x, uxonnx.OutputName(s, 0))
PRINT uxonnx.TensorCount(out)

uxonnx.TensorFree(out)
uxonnx.TensorFree(x)
uxonnx.SessionFree(s)
```

## Scope

Current scope:

- CPU ONNX Runtime
- F32 tensors
- 1 input / 1 output inference helper
- input/output count and names
- tensor handle system

Future:

- multiple inputs/outputs
- I64 tensors
- string tensors
- DirectML/CUDA execution providers
- ONNX model metadata and dynamic shape helpers
