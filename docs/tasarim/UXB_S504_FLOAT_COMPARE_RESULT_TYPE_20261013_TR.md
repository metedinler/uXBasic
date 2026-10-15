# UXB S-504: ondalık karşılaştırma sonucunun Boolean türü

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Uygulandı ve AST/MIR/native/JS kanıtıyla doğrulandı

## Sorun

Ondalık işlenenli bir karşılaştırma (`x >= 0`, `TIMER >= 0`) doğru olarak
`-1` veya `0` üretmesine rağmen MIR lowering, operandların duyarlığını sonuç
metadata'sına taşıyıp karşılaştırma geçicisini `F64` işaretliyordu. MIR-x64
karşılaştırma kodu tamsayı Boolean desenini bu F64 yuvasına yazdığı için TRUE
sonucu `NaN` olarak okunuyor, bir `I32` atamasında ise `0`'a dönüşüyordu.

## Düzeltme

`MIRLowerExprNode` içinde `EQ`, `NE`, `LT`, `LE`, `GT`, `GE` ve işaretsiz
karşılaştırmaların sonuç metadata'sı her zaman `BOOLEAN` olur. Ondalık tür
seçimi yalnız karşılaştırmanın operand yükleme ve kıyaslama domain'i için
kullanılır; sonuç türüne sızmaz.

Kaynak: `src/semantic/mir_lower_expr.fbs`.

## Kanıt

`tests/diagnostics/s504_f64_compare.uxb`:

```text
DIM x AS F64 = 2.5
PRINT x >= 0
DIM b AS I32
b = (x >= 0)
PRINT b
PRINT TIMER >= 0
```

`run_s504_f64_compare_tests.ps1` sonucu:

```text
Toplam: 4   PASS: 4   FAIL: 0
```

AST, canonical MIR, JS/Node ve MIR-x64 çıktısı `-1 | -1 | -1` ile eşleşti.
MIR full JSON'da karşılaştırma geçicilerinin türü `BOOLEAN` olarak görülüyor.
`build_64.ps1 -Force` exit 0 verdi.

S-446 F32 aritmetik saklama/parite kapsamı korunur; F32 karşılaştırması bu
fixture'ın aynı sonucu veren genişletilmiş takip testidir.
