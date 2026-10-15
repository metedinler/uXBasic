# UXB S-219: ROL/ROR Tür Genişliği ve İşaretlilik

## Kapsam

`ROL` ve `ROR`, sol operandın statik tamsayı tür genişliğinde döndürülür.
`U8/I8`, `U16/I16` ve `U32/I32` için bit halkası sırasıyla 8, 16 ve 32 bittir;
sonuç signed türlerde iki'nin tümleyeni olarak, unsigned türlerde işaretsiz
olarak gözlenir. Döndürme sayısı aynı genişlik maskesiyle normalize edilir.

## Kök neden

Kaynak yüzeyinde `ROL/ROR` tanımlı olsa da yürütme yolları aynı sözleşmeyi
tüketmiyordu. Varsayılan AST runtime eski 32-bit yardımcıya düşüyor ve maske
uygulamadan sonucu taşıyordu. Semantik MIR değerlendiricisi 64-bit döndürüyordu.
MIR-x64 yüzey dispatch'i typed emitter'a ulaşmadan ortak 64-bit yardımcıyı
çağırıyordu.

## Uygulama

- Semantik MIR evaluator, kanonik `resultType` ile genişlik maskeli ve signed
  dönüşümlü ortak döndürme yordamını kullanır.
- AST runtime, expression `typeName` damgasını döndürme yordamına geçirir;
  `ExecValue` sonucu sonradan bildirilen türle yeniden yorumlanır.
- MIR-x64 yüzey emitter'ı `AL/AX/EAX/RAX` seçimini `resultType` veya sol
  operand türünden yapar. `ROL=` ve `ROR=` bileşikleri de aynı kapıdan geçer.
- JS üretimi `BigInt.asUintN/asIntN`, WAT üretimi ise integer artifact kapısı
  üzerinden aynı genişlik kararını korur.

## Kabul kanıtı

Koşucu: `tests/diagnostics/run_s219_rotate_width_tests.ps1`

Beklenen örnekler: `U8 129 ROL 1 = 3`, `U8 129 ROR 1 = 192`,
`I8 -127 ROR 1 = -64`, `U16 32769 ROL 1 = 3`,
`U32 2147483649 ROR 1 = 3221225472`, `I32 -2147483647 ROR 1 = -1073741824`.

2026-10-14 ölçümü:

```text
AST       PASS
MIR       PASS
MIR-x64   PASS
AST-x64   PASS
JS        PASS
WAT/WASM  PASS (wat2wasm artifact validation)
Toplam: 6 PASS: 6 FAIL: 0
```

Eski Kılavuz V2 yoklama sonuçları tarihsel ölçüm olarak `SORUN_TAKIP.md` içinde
korunur; güncel kabul ölçütü bu altı yüzeyli koşucudur.
