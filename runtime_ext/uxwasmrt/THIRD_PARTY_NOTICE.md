# Third-party runtime notice

This adapter downloads and redistributes no third-party binary inside the patch ZIP itself.
The installation script obtains pinned official release assets and verifies their published SHA-256 digests.

## Wasmtime

- Project: Bytecode Alliance Wasmtime
- Pinned release: `v45.0.3`
- Package: Windows x86-64 C API
- License: Apache License 2.0

The fetch script copies the license supplied by the official release beside the distributed runtime as `bin/LICENSE.wasmtime.txt` when present.

## WABT

- Project: WebAssembly Binary Toolkit
- Pinned release: `1.0.41`
- Package: Windows x64 tools
- License: Apache License 2.0

The fetch script copies the license supplied by the official release into `tools/wabt/bin/LICENSE.wabt.txt` when present.
