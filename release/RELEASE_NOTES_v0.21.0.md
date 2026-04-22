# uXBasic Compiler v0.21.0

Bu release, `uXBasic-Compiler-` deposunu ilk anlamli dagitim deposu haline getiren paketleme turudur.

## One cikanlar

- baslangic ve sponsor odakli yeni README / rehber belgeleri
- `uxbasic_mimari.md` mimari dokumani
- `PCK5.md` komut, fonksiyon ve syntax dokumani
- `tests/basicCodeTests/` altinda Windows, DLL, API ve native x64 ornekleri
- `tests/basicCodeTests/out/` altinda AST JSON, pipeline JSON ve build artefact'lari
- `bin/uXBasic.exe` ile dogrudan denenebilir compiler binary

## Dogrulanan calisma durumu

- Windows uzerinde compiler calisiyor
- FFI disi native x64 console ornekleri exe uretip kosuyor
- `CALL(DLL)` iceren ornekler artik asm / obj / exe zincirinden geciyor
- fakat gercek DLL resolver tamamlanmadigi icin FFI runtime sonucu bugun stub lane ile sinirli

## Baslangic noktasi

Ilk deneme icin:

- `tests/basicCodeTests/42_uxb_native_console_codegen_smoke.bas`
- `tests/basicCodeTests/43_uxb_native_flow_math_codegen_smoke.bas`

FFI durumunu gormek icin:

- `tests/basicCodeTests/31_uxb_windows_kernel_sleep_tick.bas`
- `tests/basicCodeTests/32_uxb_windows_user32_metrics.bas`
