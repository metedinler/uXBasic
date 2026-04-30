# COMPILER_PARITY_MATRIX

Tarih: 2026-04-30
Kapsam: Hamle 5 kanit ozeti

## TYPE Field Access Parity

| Senaryo | Parser | Semantic/Layout | AST Runtime | MIR Runtime | x64 Native |
|---|---|---|---|---|---|
| Numeric field read/write | OK | OK | OK | OK | OK |
| Nested field | OK | OK | OK | OK | OK |
| Array element field (`a(i).x`) | OK | PARTIAL | FAIL | FAIL | OK |
| F80 field write | OK | OK (F80 canonical) | OK | OK | OK |
| String field basic | OK | OK | OK | OK | OK |

## Kanit Komutlari

- `./src/main_64.exe tests/basicCodeTests/50_type_field_numeric.bas --execmem`
- `./src/main_64.exe tests/basicCodeTests/50_type_field_numeric.bas --execmem --interpreter-backend MIR`
- `./src/main_64.exe tests/basicCodeTests/51_type_nested_field.bas --execmem`
- `./src/main_64.exe tests/basicCodeTests/51_type_nested_field.bas --execmem --interpreter-backend MIR`
- `./src/main_64.exe tests/basicCodeTests/54_type_string_field_partial.bas --execmem`
- `./src/main_64.exe tests/basicCodeTests/54_type_string_field_partial.bas --execmem --interpreter-backend MIR`
- `./src/main_64.exe tests/basicCodeTests/50_type_field_numeric.bas --build-x64`
- `./src/main_64.exe tests/basicCodeTests/51_type_nested_field.bas --build-x64`
- `./src/main_64.exe tests/basicCodeTests/52_type_array_field.bas --build-x64`
- `./src/main_64.exe tests/basicCodeTests/53_type_f80_field_diagnostic.bas --build-x64`
- `./src/main_64.exe tests/basicCodeTests/54_type_string_field_partial.bas --build-x64`

## Durum Notu

Hamle 5 x64 native parity gate bu turda kapandi.
52 ve 53 icin `EXIT=14` ureten iki kritik neden giderildi:
- OFFSETOF invalid index syntax
- F80 field store/load lane blokaji

Karar: H5: TYPE System & Field Access Verified.
