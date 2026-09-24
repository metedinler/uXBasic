# uxb Switchboard Komut Matrisi

Script: `uxb/compiler/scripts/uxb_switchboard.ps1`

Amaç: Tek anahtarlama noktası ile interpreter, codegen, build, json export ve native toolchain akışlarını yönetmek.
Kanonik test kökü: `uxb/tests` (uyumluluk için `tests -> uxb/tests` junction korunur).

## Desteklenen Modlar

1. `matrix-all`
- Sıra: `json-all` -> `interp-ast` -> `interp-mir` -> `emit-x64` -> `build-x64`
- Katman çıktıları + interpreter + x64 üretim birlikte doğrulanır.

2. `json-all`
- AST/HIR/MIR JSON + run report üretir.

3. `interp-ast`
- `--execmem --interpreter-backend AST`

4. `interp-mir`
- `--execmem --interpreter-backend MIR`

5. `emit-x64`
- NASM metin çıktısı üretir.

6. `codegen-x64`
- x64 codegen akışını çalıştırır.

7. `build-x64`
- x64 build pipeline çalıştırır.

8. `interop`
- interop artifact üretir (FFI lane dahil).

9. `build-compiler-x64`
- compiler binary x64 derler (`build_64.bat`).

10. `build-compiler-x86`
- compiler binary x86 derler (`build_32.bat`).

11. `native-toolchain-auto`
- Kaynak uzantısına göre `fbc/gcc/g++/nasm` ile native derleme.

## Bilingual Hata Modeli

Çıktı özetinde hata alanı:
- `error.tr`: Türkçe birincil metin
- `error.en`: İngilizce ikincil metin
- `error.code`: metinden çıkarılabilen sayısal hata kodu (varsa)

Her koşu için:
- `run_summary.json` (koşu bazlı)
- `switchboard_summary.json` (toplu özet)
- `session.live.json` (VSCode panelleri için canlı özet)
