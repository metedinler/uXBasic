# UXLLAMA CPU Text Completion Module

`uxllama` is the low-resource first layer of local LLM support for uXBasic.

Scope:
- CPU-only text completion
- GGUF model through `llama-cli.exe`
- CLI bridge DLL: `uxllama.dll`
- No streaming
- No embeddings
- No state save/load
- No GPU provider logic

Those advanced features belong to `uxllamax`, not this package.

## Why CLI bridge first?

The llama.cpp C API changes frequently. The CLI bridge avoids fragile link-time API coupling and lets uXBasic work with a built `llama-cli.exe`. It is slower than a direct C API bridge but much safer for the first portable version.

## Low-resource policy

Use:
- small GGUF models: 0.5B, 1B, 1.5B, 2B
- Q2_K / Q4_0 / Q4_K_M quantization
- context 512 or 1024
- n_predict 64-128
- threads 1-2

## Build dependencies

MSYS2 UCRT64:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja git
```

## Build wrapper DLL

```bat
uxb\runtime_ext\uxllama\build_uxllama_dll.bat
```

## Build llama.cpp CPU CLI

```bat
uxb\runtime_ext\uxllama\fetch_uxllama_deps_msys2.bat
uxb\runtime_ext\uxllama\build_llama_cpp_cpu.bat
```

## Smoke test

```bat
uxb\compiler\scripts\run_uxllama_smoke.bat
```

With a real model:

```bat
uxb\compiler\scripts\run_uxllama_smoke.bat models\tiny-model.gguf
```
