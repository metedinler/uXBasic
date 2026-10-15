# UXB S-505: karşılaştırmaya uygulanan tekli eksinin kanonik sonucu

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Uygulandı ve desteklenen hedeflerde doğrulandı

## Sorun

uXBasic Boolean karşılaştırmaları `TRUE = -1`, `FALSE = 0` üretir. Bu nedenle
`-(x > 1)` ifadesinin sonucu `1` olmalıdır. Tam `bld` yolunda semantik tip
bağlama, karşılaştırma sonucunu taşıyan `NEG` geçicisini yeniden `BOOL` olarak
işaretleyebiliyor; MIR-x64 de Boolean normalizasyonunu ikinci kez uygulayıp
`-1` üretebiliyordu.

## Düzeltme

`NEG` aritmetik bir işlemdir. MIR lowering'de karşılaştırma üstündeki tekli
eksi `I64` metadata'sı alır. Ek olarak MIR modülünün sonlandırma kapısında
`BOOL/BOOLEAN` işaretli `NEG` sonuçları `I64`'e normalize edilir. Böylece
semantik geçiş, optimizer, MIR yorumlayıcı, MIR-x64 ve canonical MIR aynı
sonuç türünü kullanır.

Kaynaklar: `src/semantic/mir.fbs`, `src/semantic/mir_lower_expr.fbs`,
`src/semantic/mir_tail.fbs`, `src/codegen/x64/mir_x64_codegen.fbs`.

## Kanıt

`tests/diagnostics/s505_unary_comparison.uxb` için AST, MIR, MIR-x64,
AST-x64 ve JS/Node çıktısı:

```text
1
1
1
1
```

`run_s505_unary_comparison_tests.ps1`: **7/7 PASS**.

- F64 içeren karma fixture WAT'ta mevcut S-150 float kapısını beklenen açık
  ret olarak doğrular.
- Integer-only `s505_unary_comparison_i32.uxb` WAT üretimi ve `wat2wasm`
  doğrulaması geçer.
- `bld --mir-full-json-out` içindeki bütün `NEG` geçicileri `I64`'tür.

`build_64.ps1 -Force` başarılıdır.

## Açık sınır

WAT/WASM F32/F64 lowering'i S-150 kapsamında hâlâ uygulanmış değildir. Bu
kayıt WAT float parity'si iddiası taşımaz; yalnız integer WAT artifact kapısını
ve bilinçli float reddini doğrular.
