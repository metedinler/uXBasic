# ADIM28 — Derleme, Test ve Runtime DLL Hazırlık

Bu paket ADIM25-26-27 sonrasında çıkan FreeBASIC uyumsuz `Replace()` hatalarını kapatır ve derleme/test aşamasına geçiş için iki script ekler.

## 1. FreeBASIC `Replace()` düzeltmesi

Aşağıdaki dosyalarda `Replace()` kullanılmayacak; CSV kaçışı elle yapılacak:

- `src/semantic/ast_mir_coverage_gate_adim25.fbs`
- `src/codegen/js/js_mir_opcode_coverage_adim26.fbs`
- `src/codegen/wasm/wasm_mir_opcode_coverage_adim26.fbs`
- `src/cli/cli_backend_route_close_adim27.fbs`

## 2. Derleme/test scripti

`compiler/scripts/run_adim28_build_test_pipeline.ps1`

Yapar:
- `reports/control/current` içeriğini silmeden history altına taşır.
- Compiler derlemesini çalıştırır.
- Varsa ADIM25-26-27 close gate’i çalıştırır.
- Varsa ADIM22 full-layer expected suite’i çalıştırır.
- Tamir yapmaz.

## 3. Runtime DLL doctor

`compiler/scripts/run_adim28_runtime_dll_doctor.ps1`

Beklenen runtime DLL’ler:

- `uxb/dist/runtime_ext/uxb_fp80.dll`
- `uxb/dist/runtime_ext/uxb_fp128.dll`
- `uxb/dist/runtime_ext/uxb_bigfp.dll`

Önemli: Bu script sahte DLL üretmez. Kaynak varsa derler, kaynak yoksa `SOURCE_MISSING` raporlar.

Windows sistem DLL’leri (`KERNEL32.DLL`, `USER32.DLL`) derlenmez; işletim sisteminden gelir.

## Copilot kısa emir

Yeni mimari icat etme.
Ana dosyaları komple ezme.
Patch içindeki dört FreeBASIC dosyasını aynı repo yollarına kopyala.
Patch içindeki iki PowerShell scriptini `uxb/compiler/scripts` altına kopyala.
Önce `run_adim28_build_test_pipeline.ps1 -NoRepair` çalıştır.
Sonra `run_adim28_runtime_dll_doctor.ps1 -NoRepair` çalıştır.
Hata çıkarsa ilk 30 satırı raporla; tamirata girme.
