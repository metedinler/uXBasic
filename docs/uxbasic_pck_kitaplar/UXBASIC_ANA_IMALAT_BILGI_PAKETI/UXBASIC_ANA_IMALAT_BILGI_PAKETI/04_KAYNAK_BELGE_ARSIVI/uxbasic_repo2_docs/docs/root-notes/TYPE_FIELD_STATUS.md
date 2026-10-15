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
| Array field access | OK | `r.a(i)` lane'i x64 build tarafinda duzeltildi |
| F80 field write | OK | Literal-store lane x64 backendde aktif |
| String field access | OK | Hamle 5 kapsamindaki basic lane geciyor |

## Hamle 5 Testleri (50-54)

| Test | AST | MIR | x64 Build |
|---|---|---|---|
| tests/basicCodeTests/50_type_field_numeric.bas | OK | OK | OK |
| tests/basicCodeTests/51_type_nested_field.bas | OK | OK | OK |
| tests/basicCodeTests/52_type_array_field.bas | FAIL (exit=5) | FAIL (exit=13) | OK |
| tests/basicCodeTests/53_type_f80_field_diagnostic.bas | OK | OK | OK |
| tests/basicCodeTests/54_type_string_field_partial.bas | OK | OK | OK |

## Ek Kanit

- PASS H5 x64 type field codegen (`tests/run_x64_type_field_codegen_h5.bas`)
- PASS H5 F80 field lane (`tests/run_x64_type_field_f80_diag.bas`)
- PASS x64 codegen emit (`tests/run_x64_codegen_emit.bas`)
- PASS 46 matrix float array stride
- PASS 47 matrix float function return

## Acik Is

1. Hamle 5 x64 parity gate tamamlandi.
2. Sonraki adimda AST/MIR lane'leri icin 52 testindeki interpreter tarafi ayrica ele alinacak.
