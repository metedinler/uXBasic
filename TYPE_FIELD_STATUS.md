# TYPE_FIELD_STATUS

Tarih: 2026-04-30
Faz: Hamle 5 (TYPE layout ve field access)

## Ozet

Bu dosya Hamle 5 kapsamindaki TYPE field lane durumunu tek yerde verir.
Yeni parser syntax eklenmedi. Mevcut layout altyapisi korundu:
- BuildTypeLayoutTable
- ResolveTypeLayout
- TypeLayoutSizeOf
- TypeLayoutResolvePath
- TypeLayoutOffsetOf

## Katman Durumu

| Alan | Durum | Not |
|---|---|---|
| TYPE layout tablosu | OK | Mevcut semantic/layout altyapisi kullanildi |
| Numeric field read/write | OK | x64 lane smoke PASS |
| Nested field access | OK | AST/MIR/x64 build lane PASS |
| Array field access | PARTIAL | x64 build lane `OFFSETOF invalid index syntax` ile fail |
| F80 field write | PARTIAL | x64 lane bilincli fail-fast: `F80 field store is not implemented in x64 backend yet` |
| String field access | PARTIAL | Temel lane acik, kapsam genisletilecek |

## Hamle 5 Testleri (50-54)

| Test | AST | MIR | x64 Build |
|---|---|---|---|
| tests/basicCodeTests/50_type_field_numeric.bas | OK | OK | OK |
| tests/basicCodeTests/51_type_nested_field.bas | OK | OK | OK |
| tests/basicCodeTests/52_type_array_field.bas | FAIL (exit=5) | FAIL (exit=13) | FAIL (exit=14) |
| tests/basicCodeTests/53_type_f80_field_diagnostic.bas | OK | OK | FAIL (exit=14, beklenen diagnostic lane) |
| tests/basicCodeTests/54_type_string_field_partial.bas | OK | OK | OK |

## Ek Kanit

- PASS H5 x64 type field codegen (`tests/run_x64_type_field_codegen_h5.bas`)
- PASS H5 F80 diagnostic (`tests/run_x64_type_field_f80_diag.bas`)
- PASS x64 codegen emit (`tests/run_x64_codegen_emit.bas`)
- PASS 46 matrix float array stride
- PASS 47 matrix float function return

## Acik Is

1. `a(i).field` zincirinde OFFSETOF/index parser-codegen bagi tamamlanacak.
2. F80 field store lane'i fail-fast'ten cikartilip gercek emit'e alinacak ya da explicit backlog olarak tutulacak.
3. String field lane'i array/nested kombinasyonlariyla genisletilecek.
