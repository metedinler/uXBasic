# UXB S-459/S-460: karışık STRING ve sayısal operandlar

**Tarih:** 2026-10-14  
**Sahip:** Codex  
**Durum:** Uygulandı ve altı üretim/yürütme yüzeyinde doğrulandı

## Karar

uXBasic'te bir `STRING`/`WSTRING` operand ile sayısal operand aynı ikili
ifadede örtük olarak karıştırılamaz. Özellikle `+` işleci için metin
birleştirmesi yalnız iki metin operandı arasında geçerlidir. Sayıyı metne
çevirmek isteyen program açıkça `STR(...)`, metni sayıya çevirmek isteyen
program açıkça `VAL(...)` veya uygun sayısal dönüşümü kullanır.

Geçerli örnekler:

```basic
PRINT "a" + "b"
PRINT STR(2.5) + "a"
PRINT "a" + STR(2.5)
PRINT VAL("5") + 1
```

Geçersiz örnekler:

```basic
PRINT 2.5 + "a"
PRINT "a" + 2.5
PRINT 5 = "5"
PRINT "a" < 5
```

## Kök sorun

Önceki davranış motorlar arasında tanımsız biçimde bölünüyordu:

- AST ve JS bazı `STRING + sayı` ifadelerini metin birleştirmesine çeviriyordu.
- MIR metni sessizce yutabiliyordu.
- MIR-x64 ve eski AST-x64 sayı/pointer temsillerini karıştırabiliyor,
  yanlış değer veya erişim ihlali üretebiliyordu.
- WAT, aynı kaynak için ortak ve açıklayıcı bir type gate sunmuyordu.

Bu, backend'e bırakılabilecek bir biçimlendirme tercihi değildir. Tip bağlama
katmanı ifadeyi reddetmeden MIR veya hedef kodu üretmek, sessiz yanlış sonuç ve
x64 çökmesi üretirdi.

## Uygulama

`src/type_binding/type_infer_expr.fbs` içindeki ortak ikili ifade çıkarımı,
kütüphane tipi operatörü çözümlemesinden sonra şu kuralı uygular:

```text
(left is STRING and right is numeric)
or
(left is numeric and right is STRING)
    -> UXB_MIXED_STRING_NUMERIC
```

Bu kontrol bütün ikili işleçlere uygulanır; yalnız `+` için özel bir backend
kontrolü değildir. İki metin operandı ve iki sayısal operandın mevcut kuralları
korunur. Birinci sınıf kütüphane tipi operatörü zaten registry/provider
sözleşmesiyle çözülmüşse o çözüm önceliklidir; böylece kütüphane operatörleri
çekirdek `IF type = ...` yığınına dönmeden kendi sözleşmelerini sürdürebilir.

`src/common/error_system_adim45.fbs` ve
`src/main_output_contract_bridge.fbs` içinde canonical tanı kodu kaydedildi:

```text
UXB_MIXED_STRING_NUMERIC
```

Terminal bildirimi ve `all_diagnostics.json` aynı kodu taşır. Açıklayıcı ileti,
`STR` veya `VAL` ile açık dönüşüm yapılmasını söyler.

## Kabul kanıtı

Fixture'lar:

- `tests/diagnostics/s459_mixed_numeric_string_add_left.uxb`
- `tests/diagnostics/s459_mixed_numeric_string_add_right.uxb`
- `tests/diagnostics/s459_mixed_numeric_string_eq.uxb`
- `tests/diagnostics/s459_mixed_numeric_string_lt.uxb`
- `tests/diagnostics/s459_explicit_conversion.uxb`

Koşucu: `tests/diagnostics/run_s459_mixed_numeric_string_tests.ps1`

Negatif yüzey matrisi dört geçersiz kaynak × AST, MIR, MIR-x64, AST-x64, JS,
WAT'tır. Her biri `UXB_MIXED_STRING_NUMERIC` ile reddedilir. Pozitif açık
dönüşüm AST, MIR, MIR-x64, AST-x64 ve JS/Node'da çalıştırılır.

2026-10-14 sonucu:

```text
Toplam: 29 PASS: 29 FAIL: 0
```

`build_64.ps1 -Force` çıkış 0'dır. `par`, `ast` ve `mir` fiilleri yalnız ara
artifact üretir; tip bağlama/yürütme parity matrisine dahil edilmez. `run` AST
ve `run --interpreter-backend MIR` gerçek interpreter yüzeylerini, `x64`
seçenekleri iki native yolu, `jsw` ve `wat` hedef üretimini temsil eder.

## Kapsam sınırı

Bu karar örtük STRING-sayı dönüşümünü kapatır. FFI ABI dönüşümleri, pointer ile
metin pointer'ı ve birinci sınıf kütüphane tiplerinin kendi `MAGIC`/operator
sözleşmeleri ayrı type/provider kayıtlarıdır. WAT/WASM desteklenmeyen sayısal
özellikler için açık ret standardı ayrıca korunur.
