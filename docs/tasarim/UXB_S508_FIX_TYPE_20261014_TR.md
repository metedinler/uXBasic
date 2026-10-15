# UXB S-508: FIX builtin statik turu

## Karar

`FIX(x)` sayisal girdiyi sifira dogru keser ve statik sonucu `I32`'dir.
Sonuc degiskene atanabilir, aritmetik ifadeye girebilir ve baska bir sayisal
donusumun girdisi olabilir.

## Kok neden

Runtime MIR ve native builtin uygulamalari mevcut olmasina ragmen `FIX`, ortak
`type_builtin_registry.fbs` kayitlarinda yoktu. Type inference bu durumda
`TYPE_OBJECT`'e dusuyor; assignment, arithmetic ve nested cast kullanimlari
reddediliyordu. Legacy AST-x64 call resolver da FIX donusunu tanimiyordu.

## Uygulama

- Ortak builtin registry `FIX -> TYPE_I32`, `NUMERIC:1`, `ALL` sozlesmesiyle
  guncellendi.
- Legacy x64 call resolver `FIX` donusunu `I32` olarak tanir.
- Legacy x64 XMM ifade yolu integer FIX sonucunu F32/F64 hedefe acik
  `cvtsi2ss` veya `cvtsi2sd` ile genisletir.

## Kanit

Fixture: `tests/diagnostics/s508_fix_type.uxb`

Fixture; I32, I64 ve F64 atamasini, aritmetigi, nested `I32(FIX(p))` ve
`I64(FIX(p))` kullanimini, pozitif ve negatif girdiyi kapsar.

`run_s508_fix_type_tests.ps1` sonucu: **5/5 PASS**

| Yuzey | Sonuc |
|---|---|
| AST | PASS |
| Canonical MIR | PASS |
| MIR-x64 | PASS |
| AST-x64 | PASS |
| JS | PASS |

