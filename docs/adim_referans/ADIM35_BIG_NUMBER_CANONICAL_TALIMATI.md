# ADIM35 — BIGI/BIGINT + BIGINIT Kanonik Tamamlama

## Mutabakat

- Dil yüzeyi: `BIGI` ve `BIGINT`
- Internal canonical: `TYPE_BIGINT`
- JSON/type report: `BIGINT`
- `BIGINT` initializer olmayacak.
- Initializer builtin adı `BIGINIT` kalacak.
- `BIGF`, `BIGD`, `BALL`, `BIGI/BIGINT` ayrımı korunacak.

## Desteklenecek syntax

```basic
DIM A AS BIGF(256)
A = BIGINIT("BIGF", "1.2345", 256)

DIM B AS BIGD(80)
B = BIGINIT("BIGD", "123.45", 80)

DIM C AS BALL(256)
C = BIGINIT("BALL", "3.14", 256)

DIM D AS BIGI
D = BIGINIT("BIGI", "123456789123456789", 0)
```

Alternatif tür-ref biçimi:

```basic
A = BIGINIT(BIGF, "1.2345", 256)
B = BIGINIT(BIGD, "123.45", 80)
C = BIGINIT(BALL, "3.14", 256)
D = BIGINIT(BIGI, "123456789123456789", 0)
```

## Katman kuralları

1. `BIGI` kısa alias, `BIGINT` uzun alias.
2. `BIGI/BIGINT` parser type listesine eklenecek.
3. `BIGI/BIGINT` semantic/type/MIR/interpreter/JS/layout katmanlarında `TYPE_BIGINT` olarak normalize edilecek.
4. `BIGD` ve `BALL` artık `TYPE_BIGFLOAT`a düşmeyecek.
5. `BIGINIT` surface registry’de builtin/runtime builtin olarak görünecek.
6. Runtime tarafında sahte destek yok. DLL yoksa `REQUIRES_DLL`/`REQUIRES_BIGI_RUNTIME` diagnostic verilecek.
7. BIGI runtime ilk aşamada GMP `mpz_t` temelli `uxb_bigi_*` fonksiyonlarıyla tamamlanacak.
8. Ortak runtime köprüsü: `__uxb_rt_biginit(kind, value, precision)`.

## Uygulama sırası

1. `docs/ADIM35_BIG_NUMBER_FILE_PATCH_MAP.csv` haritasına göre dosyaları düzelt.
2. `runtime_ext/bigfp/uxb_bigfp.h` içine BIGI prototiplerini ekle.
3. `runtime_ext/bigfp/uxb_bigfp_mpfr.c` içine BIGI/GMP kodunu ve `__uxb_rt_biginit` wrapperını ekle.
4. Strict testleri `tests/adim35_big_number` altına ekle.
5. `run_adim35_big_number_suite.ps1` ile force rebuild + suite koş.
6. ADIM30 PASS tekrar korunmalı.
