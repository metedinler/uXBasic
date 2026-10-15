# uXBasic S-442 UNION Ortak Bellek ve Canonical MIR Halkasi

Tarih: 2026-10-13
Sorumlu: Codex
Durum: KISMEN-YAPILDI-DOGRULANDI

## Sorunun gercek sekli

`UNION` alanlarinin layout tablosunda ayni offseti paylasmasi zaten vardi.
AST calisma zamani bu layout'u gerçek kayit adresiyle kullandigi icin:

```basic
UNION U ABI C
    i AS I32
    b AS U8
END UNION

DIM u AS U
u.i = 258
PRINT u.b
```

AST sonucu `2` veriyordu. Ortak MIR ise eski yolda `U.I` ve `U.B` adli
bagimsiz pseudo-variable'lar uretiyordu. MIR yorumlayici ayri hucrelere
yaziyor, JS `vars["U.B"]` okuyordu; MIR-x64 emitter da bu bilinmeyen operand
adlarini native adrese ceviremiyordu. Bu, hedefler arasinda sessiz sonuc farki
ve x64'te derleme hatasi uretiyordu.

## Baglayici MIR sozlesmesi

UNION alan erisimi sinif nesnesi alani degildir. `MIR_FIELD_LOAD/STORE` heap
nesnesi semantigine sahip oldugu icin UNION'a zorla uygulanmadi. Yeni ortak
opkodlar:

```text
MIR_UNION_FIELD_LOAD(root, field, offset, width, type) -> result
MIR_UNION_FIELD_STORE(root, field, value, offset, width, type)
```

`root` kaydin gercek degiskenidir. `field` tanilama ve kaynak esleme icin
korunur. `offset`, `width` ve `type` layout/type binding katmaninda sabitlenir;
backend bu bilgiyi tekrar AST'den cikarmak zorunda degildir. MIR verifier,
canonical bridge ve sync pass bu iki opkodu normal memory read/write olarak
tanir.

## Lowering kurallari

- Duz atama `u.i = x`, UNION store'a iner.
- Bilesik atama once UNION load, sonra aritmetik, sonra UNION store uretir.
- `=-` gibi tekli donusum gereken yollar da store oncesi canonical aritmetik
  uretir.
- `INCDEC_EXPR` ve `INCDEC_STMT` once alani canonical load ile okur ve sonucu
  canonical store ile yazar. Gecici deger `STORE_VAR U.B` gibi pseudo-name'e
  donusturulmez.
- Desteklenmeyen layout/tip/genislik lowering asamasinda acik hata verir;
  backend'e bozuk pseudo-variable birakilmaz.

## Backend karsiliklari

### MIR yorumlayici

Her UNION kok degiskeni kendi 256 byte'lik kayit hucrelerini tasir. Alan okuma
ve yazma little-endian raw byte uzerinden yapilir; isaretli/isaretsiz dar
tamsayi ve F32/F64 byte yorumlama yardimcilari vardir. Hucre global tek bir
gecici degildir; iki UNION degiskeni birbirini ezmez.

### MIR-x64

Kok degiskenin adresi alinip alan genisligine gore byte/word/dword/qword
load-store uretilir. Bu yol sinif alani receiver ABI'sini kullanmaz; UNION
degerinin gercek storage hucrelerine erisir.

### JavaScript

`uxb.object` icinde kok adi basina bir `ArrayBuffer(256)` tutulur. `DataView`
little-endian erisimleri I8/I16/I32/U8/U16/U32, I64/U64 ve F32/F64 icin
uygulanir. Yeni generated kod `ux.unionFieldLoad/Store` uyumluluk koprusunu
kullanir; embedded runtime generator ile kaynak runtime'dan yenilenir.

### WAT/WASM

WASM emitter UNION koklerini modul basina 256 byte'lik ayrilmis linear-memory
hucrelerine baglar. Boylece alan islemi kok degiskeninin `i32` degeriyle degil,
gercek ortak bellekle yapilir. 1/2/4 byte integer alanlarda `load8/16/load`,
`store8/16/store` ve layout offset'i dogrudan WAT bellegine tasinir; imzali
alanlarda sign extension, isaretsiz alanlarda zero extension kullanilir.
VIRTUAL ve read-sequence scratch bolgeleriyle cakismamasi icin WAT modulu
20 sayfa bellek ayirir; UNION lane'i 768 kokle sinirlidir ve sinir asimi acik
ret verir. WAT, `wat2wasm` ile derlenebilirlik kanitindan gecmistir.

WASM tarafinda 8-byte ve F32/F64 alanlar icin i32 deger yerine fiziksel linear
memory hucreleri veya typed storage modeli gereklidir. Bu, sonraki WASM parity
isidir ve bu belgede kapanmis sayilmaz.

## Kanit

Kalici fixture: `tests/diagnostics/union_overlay.uxb`

```basic
u.i = 258
u.b += 1
u.b++
PRINT u.b
```

Beklenen ve gercek sonuc `4`:

| Yuzey | Kanit | Sonuc |
|---|---|---|
| AST interpreter | `run` | 4 |
| Canonical MIR interpreter | `run --interpreter-backend MIR` | 4 |
| MIR verifier | `MIR_UNION_FIELD_LOAD/STORE` | gecerli |
| MIR-x64 | uretilen EXE gercek calisma | 4 |
| JS | uretilen JS + Node | 4 |
| WAT/WASM | uretilen WAT + `wat2wasm` | gecerli |

`run_union_overlay_tests.ps1`: **6/6 PASS**.
Secili regresyon: `library_type_contract`, `iterators`, `routine_scope`,
`exceptions_cross`, `diagnostics`, `const_write` ve `union_overlay` toplam
**174/174, 7/7 paket PASS**.

## Acik takip

1. WASM UNION icin 8-byte ve F32/F64 typed storage.
2. UNION icinde dizi alanlari ve indexed field semantigi.
3. I64/F32/F64 capraz overlay icin AST, MIR, x64, JS ve WASM ortak fixture'i.

Bu acik maddeler tamamlanmadan genel UNION parity'si kapanmis sayilmaz; buna
karsin S-442'nin onceki sessiz `I32 -> U8` minimum yeniden uretimi artik tum
hedeflerde canonical MIR sozlesmesiyle calisir.
