# UXB S-134 B4.2 Provider Capability Metadata Kapi Karari

Tarih: 2026-10-14
Sorumlu: Codex
Durum: Uygulandi ve dogrulandi

## Karar

Manifestte `capabilities` alani bos degilse bu alan hedef provider ABI'sinin
bir parcasi sayilir. MIR hedefinde `MIR_PROVIDER` capability'si zorunludur.
Provider registry'si de secilen hedef/provider icin bu capability'yi
tanimalidir. Capability acikca ilan edilmemisse eski metadata'siz manifestler
geriye uyumluluk nedeniyle engellenmez; ancak capability alani verildiginde
eksik iddia fail-closed reddedilir.

Bu halka `version` ve `dependencies` alanlarini parse etmeye devam eder; paket
cozumleme ve semver/dependency solver'i henuz bu kapinin parcasi degildir.

## Uygulama

`UXBLibraryTypeProviderSupportsCapability` hedefe gore registry capability
matrisi saglar:

- `MIR`: `MIR_PROVIDER`
- `JS`: `JS_PROVIDER` (gercek JS provider kaydi henuz yok)
- `WAT/WASM`: `LINEAR_MEMORY` veya `WASM_PROVIDER`
- `NATIVE`: `NATIVE_X64`

MIR hedef dogrulamasi, kullanilan tipin capability listesi dolu oldugunda
`MIR_PROVIDER` token'ini ve provider registry eslesmesini kontrol eder. Eksik
iddia su mevcut ortak hedef tanisiyla durur:

`UXB_LIBTYPE_PROVIDER_UNAVAILABLE: library type provider unavailable for MIR: RATIONAL (missing capability MIR_PROVIDER)`

Bu sayede `rational_external.library_type.json` gecer; ayni provider'i
kullanan fakat capability listesinden `MIR_PROVIDER` silinen negatif manifest
acikca reddedilir.

## Kanit

- `src/semantic/library_type_contract.fbs`: capability registry ve MIR hedef kapisi
- `tests/library_type_contract/rational_missing_mir_capability.library_type.json`: negatif manifest
- `tests/library_type_contract/rational_libtype_missing_mir_capability.uxb`: negatif MIR fiksturu
- `tests/library_type_contract/test_library_type_contract.bas`: capability birim kontrolleri
- `tests/library_type_contract/run_library_type_tests.ps1`: **45/45 PASS**
- `tests/diagnostics/run_s499_libtype_target_gate_tests.ps1`: **8/8 PASS**
- `tests/diagnostics/run_s500_libtype_diagnostic_consistency_tests.ps1`: **3/3 PASS**
- `build_64.ps1 -Force`: exit 0
- binary SHA256: `696A4FD2D010881CAF876AF30000F59EEAFB2245C1FE552B9A16BEC986AD5F61`

## Acik sinir

Capability token'lari artik MIR hedefinde kontrol ediliyor; fakat paket
`version`, `dependencies` ve target capability solver'i henuz gercek bir
paket graph'i cozmez. JS/WASM/native provider runtime'lari da bu halka ile
uygulanmis sayilmaz. B4.3 paket metadata resolver'i, B5 ise gercek hedef
provider/lifecycle parity'sidir.
