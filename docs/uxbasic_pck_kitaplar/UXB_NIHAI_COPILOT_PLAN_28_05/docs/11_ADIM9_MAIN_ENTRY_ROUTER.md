# 11 — ADIM9: Tek Giriş, Üç Route — Minimal / Standard / Full

## Amaç

Birden fazla main/entry dosyasının yarattığı karar dağınıklığı kaldırılacak. Tek gerçek giriş `UXBCompilerMain(cli)` olacak. Üç route aynı frontend/semantic/HIR/MIR kalitesini paylaşacak.

## Kod gerçeği

```text
compiler/wrappers/uxb_main_wrapper.bas -> src/main.bas
src/main.bas -> include merkezi
src/main_program_entry.fbs -> mevcut ana akış
src/main_program_entry_part2.fbs -> backend/legacy devamı
```

## Yeni modüller

```text
src/main_entry/uxb_cli_model.fbs
src/main_entry/uxb_entry_router.fbs
src/main_entry/uxb_pipeline_common.fbs
src/main_entry/uxb_pipeline_minimal.fbs
src/main_entry/uxb_pipeline_standard.fbs
src/main_entry/uxb_pipeline_full.fbs
src/main_entry/uxb_legacy_cli_compat.fbs
```

## Route kararı

```text
MINIMAL  -> preprocess/lexer/parser/AST/semantic/HIR/MIR/gate, opsiyonel AST+MIR interpreter, toolchain yok
STANDARD -> verified MIR'den x64 ASM/JS/WAT artifact, hafif backend
FULL     -> toolchain + x64 OBJ/EXE + WASM binary + HTML/CSS/asset/release gate
```

## CLI örnekleri

```bat
uxb_main_64.exe test.bas --mode=min --check
uxb_main_64.exe test.bas --mode=min --run-both

uxb_main_64.exe test.bas --mode=std --emit-x64
uxb_main_64.exe test.bas --mode=std --emit-js
uxb_main_64.exe test.bas --mode=std --emit-wat

uxb_main_64.exe test.bas --mode=full --build-x64
uxb_main_64.exe test.bas --mode=full --emit-wasm
uxb_main_64.exe test.bas --mode=full --target-browser
```

## İş planı

```text
1. UXBCliModel oluştur.
2. Eski CLI seçeneklerini UXBCliModel'e çevir.
3. src/main.bas sonunda sadece UXBCompilerMain(cli) çağır.
4. UXBRunFrontendSemanticMir ortak çekirdek fonksiyonunu kur.
5. Minimal pipeline verified MIR'e kadar gitsin.
6. Standard pipeline backend pipeline çağır.
7. Full pipeline toolchain/release gate eklesin.
8. Eski main_program_entry_part2 doğrudan backend çağrılarını kapat; sadece compat/fallback bırak.
```

## Pozitif testler

```text
--mode=min --check backend çağırmaz ama MIR gate çalıştırır.
--mode=std --emit-wat WAT üretir.
--mode=full --emit-wasm wat2wasm ister.
```

## Negatif testler

```text
Bilinmeyen mode FAIL.
Backend isteyen route mirModuleReady=0 ise FAIL.
Minimal route x64 linker çağırırsa FAIL.
```

## Çıktı

```text
reports/control/current/entry_router_gate.json
reports/control/current/cli_route_matrix.csv
reports/control/current/main_entry_expected_actual.csv
```
