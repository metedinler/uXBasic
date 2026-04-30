# NATIVE_X64_STATUS

Tarih: 2026-04-30
Odak: Hamle 5 x64 backend

## Tamamlananlar

- TYPE field load/store lane'i genislendi.
- Field target assignment lane'i helper bazli toparlandi.
- F32/F64 field load/store icin asm lane'i netlestirildi (`movss`/`movsd`).
- Dotted call expr tabanli field/index yoluna resolver destegi eklendi.
- F80 lane'i sessiz fallback yapmiyor; explicit diagnostic uretiyor.

## Kanit

- `tests/run_x64_type_field_codegen_h5.bas` -> PASS H5 x64 type field codegen
- `tests/run_x64_type_field_f80_diag.bas` -> PASS H5 F80 diagnostic
- `tests/run_x64_codegen_emit.bas` -> PASS x64 codegen emit
- `tests/basicCodeTests/46_matrix_float_array_stride.bas` -> PASS
- `tests/basicCodeTests/47_matrix_float_function_return.bas` -> PASS

## Acik Kirmizilar

- `tests/basicCodeTests/52_type_array_field.bas --build-x64`
  - exit=14
  - log: `x64-codegen: field resolve failed OFFSETOF invalid index syntax`
- `tests/basicCodeTests/53_type_f80_field_diagnostic.bas --build-x64`
  - exit=14
  - log: `x64-codegen: F80 field store is not implemented in x64 backend yet`

## Karar

x64 lane Hamle 5 sonunda `PARTIAL`.
Sebep: array-field indeks cozumlemesi ve F80 field store lane'i henuz tam implement degil.
