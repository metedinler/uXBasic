# 12 — ADIM10: Test, Rapor, Release Gate ve Kapatma Döngüsü

## Amaç

Her adım gerçek expected/actual testlerle kapanacak. Rapor üretmeyen adım tamamlanmış sayılmayacak.

## Test klasör düzeni

```text
tests/control/
tests/frontend/
tests/semantic/
tests/hir/
tests/mir/
tests/interpreter/
tests/backend_x64/
tests/backend_js/
tests/backend_wat_wasm/
tests/release/
tests/expected/
```

## Zorunlu rapor dosyaları

```text
reports/control/current/master_gate_summary.json
reports/control/current/master_gate_summary.md
reports/control/current/directory_snapshot.txt
reports/control/current/output_compare.csv
reports/control/current/error_classification.csv
reports/control/current/toolchain_report.json
```

## error_classification.csv kolonları

```text
error_id
error_class_tr
layer
file
symbol_or_surface
expected
actual
evidence_file
required_fix
owner
```

## Master gate kuralı

PASS olması için:

```text
1. Silmeden temizlik raporu var.
2. Surface matrix boş hücresiz.
3. BROKEN/MISSING saklanmıyor.
4. AST contract gate çalışıyor.
5. Symbol integrity gate çalışıyor.
6. HIR bridge gate çalışıyor.
7. MIR mandatory gate çalışıyor.
8. AST interpreter ve MIR interpreter parity raporu var.
9. Backend pipeline report var.
10. Dış araç raporu var.
11. Expected/actual karşılaştırması var.
```

## Copilot kapanış görevi

```text
Her uygulama turundan sonra sadece test sonuçlarını ve raporları üret.
Kod değiştirmeden önce rapor farkını göster.
```

## Pozitif testler

```text
hello_world
arithmetic
string_ops
variables
if_else
for_loop
while_loop
functions
classes
ffi_smoke
js_emit_smoke
wat_emit_smoke
```

## Negatif testler

```text
syntax_error_recovery
unknown_symbol
duplicate_symbol
bad_mir_operand
missing_typed_local
missing_wat2wasm
backend_without_verified_mir
```

## Çıktı

```text
reports/control/current/master_gate_summary.json
reports/control/current/master_gate_summary.md
reports/control/current/final_release_candidate_manifest.csv
```
