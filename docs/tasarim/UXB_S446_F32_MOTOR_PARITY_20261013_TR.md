# S-446 — F32 motor parity halkası

**Durum:** YAPILDI-DOGRULANDI  
**Tarih:** 2026-10-13  
**Kapsam:** AST yorumlayıcı, canonical MIR yorumlayıcı, MIR-x64 ve JS/Node

## Sorun

`F32` değerleri saklama, aritmetik ve metin çıktısı sırasında motorlara göre
farklı davranıyordu. `F32` değişkenine `16777217` atanması tek duyarlıkta
`1.677722e+07` olmalıydı; JS ve AST bu saklama sınırını uygulamıyordu. JS
ayrıca F32 sonuçlarını F64 hassasiyetiyle yazdırıyor, MIR ve x64 karışık
`F32 * I32` ifadelerini gereksiz yere F64'e yükseltiyordu.

## Uygulanan sözleşme

- F32 yerel değişken saklama sınırında `Single` yuvarlaması uygulanır.
- MIR float aritmetiğinin sonucu `resultType` ile taşınır; F32 sonuçlar
  yorumlayıcıda yeniden F32'ye dönüştürülür.
- MIR-x64, açık F32 sonuç tipini karışık operandlar olsa bile korur.
- JS `LOAD_CONST`, `STORE_VAR` ve F32 aritmetik sonuçlarını `Math.fround`
  ile F32'ye indirir.
- JS `PRINT`, `PRINTLN` ve statik F32 `STR` için yedi anlamlı haneli ortak
  `ux.formatF32` kullanır. F64 biçimlendirmesi ayrı kalır.

## Değişen katmanlar

- `src/runtime/exec/exec_state_value_utils.fbs`
- `src/semantic/mir_lower_expr.fbs`
- `src/interpreter/mir/mir_interp_arith.fbs`
- `src/codegen/x64/mir_x64_codegen.fbs`
- `runtime/js/common/ux_runtime_core.js`
- `src/codegen/js/runtime/js_runtime_embedded_generated.fbs`
- `src/codegen/js/js_stmt_emit.fbs`
- `src/codegen/js/js_emitter.fbs`

## Doğrulama

`tests/diagnostics/run_s446_f32_tests.ps1` aynı programı dört gerçek yürütme
yolunda çalıştırır. AST, MIR, MIR-x64 EXE ve JS/Node sonuçlarının tamamı:

```text
1.677722e+07
1
0.1
1.25
```

Sonuç: **Toplam 4, PASS 4, FAIL 0.** `build_64.ps1 -Force` exit 0 verdi.

## Kapsam sınırı

Bu fixture WASM yürütmesini içermiyor. WASM F32/F64 doğrusal bellek ve
yazdırma parity'si ayrı kabul halkasıdır; S-446 sonucu WASM için kanıt olarak
kullanılmaz.
