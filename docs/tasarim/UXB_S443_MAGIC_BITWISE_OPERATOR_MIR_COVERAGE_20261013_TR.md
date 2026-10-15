# uXBasic S-443 MAGIC bitwise operator ve AST-MIR coverage duzeltmesi

Tarih: 2026-10-13
Sorumlu: Codex
Durum: YAPILDI-DOGRULANDI

## Sorunun gercek sekli

`MAGIC AND`, `MAGIC OR` ve `MAGIC XOR` sinif kancalari parser ve semantic
katmanlarinda taniniyor. Overloaded bir binary ifade primitive `AND/OR/XOR`
opkoduna degil, alici sinifin MAGIC rutinine giden canonical `CALL` olarak
lower ediliyor. ADIM25 coverage tablosu ise `BINARY` icin yalniz primitive
binary opkodlari bekledigi icin native derlemeyi erken kesiyordu.

## Uygulanan karar

`src/semantic/ast_mir_route_table_adim25.fbs` icinde `BINARY` beklenen MIR
ailesine `CALL` eklendi. Overloaded islecler canonical olarak su rotaya iner:

```text
a AND b  -> CALL Type_MAGIC_AND(a,b)
a OR b   -> CALL Type_MAGIC_OR(a,b)
a XOR b  -> CALL Type_MAGIC_XOR(a,b)
```

Primitive binary ifadeler icin mevcut `AND/OR/XOR/...` delilleri korunur.

## Kabul testi

`tests/diagnostics/s443_magic_bitwise.uxb` primitive `AND/OR/XOR` kancalarini,
`tests/diagnostics/s443_magic_object_and.uxb` object-return `MAGIC AND` yolunu
test eder. `run_s443_magic_tests.ps1` iki fixture'i AST, canonical MIR,
gercek MIR-x64 EXE ve JS + Node yuzeylerinde calistirir: **8/8 PASS**.

WASM testi eklenmedi; mevcut WASM object/call kapasitesi bu fixture'larin
kapsami degildir ve sessiz basari iddiasi kurulmamaktadir.

## Kalan MAGIC yuzeyi

`MAGIC CALL`, `MAGIC GET` ve `MAGIC SET` ayri acik islerdir. S-443'un
AND/OR/XOR dispatch ve coverage eksigi kapanmistir.
