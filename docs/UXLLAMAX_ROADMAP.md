# UXLLAMAX Roadmap

`uxllamax` is separate from `uxllama` to prevent library trash.

`uxllama`:
- CPU only
- text completion only
- llama-cli bridge
- low-resource settings

`uxllamax` later:
- direct llama.cpp C/C++ API bridge
- streaming callbacks
- embeddings
- state save/load
- KV cache control
- batched prompt
- grammar constrained decoding
- LoRA adapter loading
- chat template helper
- CUDA/Vulkan/SYCL/Metal provider switches where available
- local server bridge
- token-level callbacks
- sampling presets
- model metadata inspection
