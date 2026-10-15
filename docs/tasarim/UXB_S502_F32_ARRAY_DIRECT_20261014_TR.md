# UXB S-502: F32 dizi elemaninin dogrudan kullanimi

## Karar

`F32` dizi elemani, `PRINT`, `STR` veya `F64(...)` baglaminda dogrudan
kullanildiginda scalar F32 ile ayni deger ve metin sozlesmesini korur.

## Kok neden

Eski AST-x64 ifade yolunda indeksli yukleme, F32 hucreyi XMM'e tasirken 32-bit
tek duyarlik degerini F64 ifade isteyen tuketiciye genisletmiyordu. Bit deseni
dogrudan cift duyarlik olarak yorumlandigi icin sessiz sifir veya denormal
sonuc uretiyordu.

## Uygulama

`src/codegen/x64/code_generator.fbs` indeksli CALL_EXPR yuklemesinde kaynak
eleman turu ile hedef XMM turu arasinda `cvtss2sd`/`cvtsd2ss` koprusu eklendi.

## Kanit

Fixture: `tests/diagnostics/s502_f32_array_direct.uxb`

`run_s502_f32_array_direct_tests.ps1` sonucu: **5/5 PASS**

| Yuzey | Sonuc |
|---|---|
| AST | PASS |
| Canonical MIR | PASS |
| MIR-x64 | PASS |
| AST-x64 | PASS |
| JS | PASS |

WAT/WASM F32 hesaplama yuzeyi mevcut S-150 kapisi nedeniyle bu kapanisin
calisan hedefi degildir.

