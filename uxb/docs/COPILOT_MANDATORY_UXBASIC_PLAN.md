# uXBasiC Mandatory Development Plan

## Canonical source
- `uxb/src` kanonik compiler kaynagidir.
- Testler ideal olarak root `tests/` altinda tutulacaktir; gecis tamamlanana kadar mevcut `uxb/tests` korunur.

## JSON compatibility
Eski JSON secenekleri bozulmayacak:

- `--ast-json-out`
- `--hir-json-out`
- `--mir-pipeline-json-out`
- `--mir-opcodes-json-out`
- `--artifact-report-json-out`

Yeni zengin ciktilar ayri seceneklerle veya yeni anahtar bloklariyla gelecek:

- `--ast-full-json-out`
- `--hir-full-json-out`
- `--mir-module-json-out`
- `--mir-full-json-out`
- `--mir-verify-json-out`
- `--x64-codegen-policy-json-out`
- `--keyword-layer-matrix-json-out`
- `--program-output-json-out`
- `--session-live-json-out`
- `--layer-timing-json-out`

## Completed stages
- Parca 1: MIR module JSON exporter
- Parca 2: AST contract helperlari
- Parca 3: Hook/trace
- Parca 3.5: Console capture
- Parca 5: MIR verifier/full JSON/backend contract
- Parca 6: x64 AST/MIR emitter policy

## Missing stages
- Parca 4: Workspace/test/artifact ayrimi
- Parca 4.5: keyword layer coverage matrix
- Gercek MIR->x64 emitter
- Cikti standardizasyonu
- Floating point extension plani

## Strict rules
1. Eski calisan behavior kirilmayacak.
2. Yeni behavior feature flag ile gelecek.
3. Sahte MIR emitter yazilmayacak.
4. JSON gecerli JSON olacak.
5. Windows path backslash escape edilecek.
6. AST emitter korunacak.
7. MIR emitter ayri dosyada gelistirilecek.
8. F80/F128/BIGF/BIGD/BALL tipleri external FP policy ile yonetilecek.
