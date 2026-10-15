# uxtensor roadmap toward uxai

Current package:

- Dense CPU F64 tensors.
- Shape/stride metadata.
- Elementwise ops and reductions.
- OpenBLAS-backed matmul/matvec/dot.
- Dependency registry and local dependency cache scripts.

Next layers:

1. `uxaimath`: activation/loss/init functions over `uxtensor` handles.
2. `uxnn`: layer/network handles.
3. Optional `uxggml`: wrap ggml for CPU tensor graphs and inference-style operations.
4. Optional `uxonnx`: ONNX Runtime wrapper for model inference.

Rule: do not reimplement large external ecosystems unless a small wrapper is insufficient.
