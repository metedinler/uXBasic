# UXB ABI10 x64 INCLUDE resolver fix 20260712

Kök sebep:
- ABI10 test kaynağı `INCLUDE "tests/libraries/abi10/abi10_wrapper.bas"` kullanıyor.
- x64 interop resolver bu path'i her zaman kaynak dosyanın dizinine göre çözüyor.
- Bu yüzden `tests/libraries/abi10/tests/libraries/abi10/abi10_wrapper.bas` oluşuyor ve x64 build başlamadan düşüyor.

Düzeltme:
- `src/build/interop_manifest.fbs` içindeki `ResolveStmtPath` artık önce source-relative path'i,
  sonra project-root-relative path'i dener.
- `..` ile kaçış kontrolü korunur.
- Absolute pathlerde eski davranış korunur.

Etkilenen dosya:
- src/build/interop_manifest.fbs
