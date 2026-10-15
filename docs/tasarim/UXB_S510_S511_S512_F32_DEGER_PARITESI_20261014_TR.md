# UXB S-510/S-511/S-512: F32 değer saklama, dönüşüm ve x64 parity

**Tarih:** 2026-10-14  
**Sahip:** Codex  
**Durum:** Uygulandı ve AST/MIR/MIR-x64/AST-x64/JS kanıtıyla doğrulandı

## Tasarım sözleşmesi

`F32`, yalnızca yazdırma biçimi değildir. Bir değer `F32` olarak bildirildiği,
`F32(...)` ile açıkça dönüştürüldüğü veya `F32` bir dizi elemanına/alanına
saklandığı anda IEEE-754 tek duyarlık değerine yuvarlanır. Sonraki aritmetik,
karşılaştırma, başka bir türe dönüşüm ve yazdırma bu yuvarlanmış değeri tüketir.

Bu sözleşme bütün üretim yollarında aynıdır:

```text
AST kaynak yürütme       -> F32 saklama sınırı
canonical MIR            -> F32 resultType ve saklama sınırı
MIR-x64                  -> F32 opcode/slot yükleme ve saklama
legacy AST-x64           -> MOVSS ile fiziksel F32 saklama
JS                      -> Math.fround / F32 formatı
WAT/WASM                -> desteklenmeyen karma kayan nokta için açık kapı
```

WAT/WASM mevcut ilk halkada F32 yürütmesini tamamlanmış saymaz; bu nedenle
karma kayan nokta programları sessizce yanlış üretmek yerine mevcut açık ret
sözleşmesine bağlıdır. Bu belge, beş gerçek çalıştırma yolunun değer parity'sini
kapatır; WAT/WASM için ayrıca yürütme halkası gerekir.

## Sorunların ortak kökü

Üç açık kayıt aynı ailede görünse de üç ayrı sınırdaki hatayı temsil ediyordu:

- **S-510:** MIR yorumlayıcısı `F32` değerini içteki `Double` alanında tam
  hassasiyetle bırakıyor, yalnız çıktı biçimlendirmesinde tek duyarlık gibi
  gösteriyordu. Bu yüzden `16777217 - 16777216` sonucu `1` kalıyordu.
- **S-511:** `F32(d)` açık dönüşümünün canonical MIR sonucu F32 metadata taşısa da
  `F32` türü çıkarıma katılmadığı için sonraki `+`, `-` veya `*` işlemi tamsayı
  opcode'una inebiliyordu. MIR-x64 bu sonucu F32 slotundan integer bit deseni
  gibi okuyordu.
- **S-512:** legacy AST-x64 `DIM` başlangıç yolunda ifade F32 olarak XMM’ye
  alındıktan sonra ortak saklama yardımcısı her zaman F64 genişliğiyle çağrılıyordu.
  `MOVSD`, F32 sonucunu yanlış fiziksel biçimde yazıyordu.

## Uygulama

### Ortak interpreter değeri

`src/interpreter/common/interp_value.fbs` içindeki `UXBInterpApplyDeclaredType`
F32 dalı artık önce kaynak sayısal değeri kurar, sonra `CSng` ile tek duyarlığa
yuvarlayıp aynı yuvarlanmış değeri `floatValue` alanına ve F32 tür etiketine
yazar. Böylece MIR ve AST aritmetiği aynı depolanmış değeri kullanır; yalnız
`PRINT` sırasında yuvarlama yapılmaz.

### MIR tür çıkarımı

`src/semantic/mir.fbs` içindeki `MIRInferExprFloatKind`, `F32(...)` dönüşümünü
`CSNG` ile aynı şekilde `MIR_UXF_F32` olarak tanır. Böylece örneğin:

```basic
DIM d AS F64 = 2.5
PRINT F32(d) + 1
```

canonical MIR'de `MIR_FADD`/F32 sonucu üretir; `MIR_SUB` veya integer bit işlemi
üretmez. Bu karar backend'e özel bir düzeltme değil, ortak MIR sözleşmesidir.

### Legacy AST-x64 başlatma sınırı

`src/codegen/x64/code_generator.fbs` içindeki `DIM` ilk değerleme yolu, XMM’ye
yüklenen ifadenin gerçek `initFloatKind` değerini `X64EmitStoreXmm0ToFloatVarAs`
çağrısına geçirir. F32 için `MOVSS`, F64 için `MOVSD` kullanılır. Böylece hem
sabit F32 literal hem de F64 değişkenden F32 başlangıç değeri fiziksel depolama
genişliğine uyar.

## Kabul fixture'ı

`tests/diagnostics/s510_mir_f32_rounding.uxb` şu sınırları aynı programda
ölçer:

```basic
DIM f AS F32 = 16777217
DIM d AS F64 = 16777217
DIM h AS F32 = d
PRINT f - 16777216
PRINT h - 16777216
PRINT F32(d) - 16777216
PRINT F64(f) = d
PRINT F64(h) - d
DIM a(0) AS F32
a(0) = 16777217
PRINT a(0) - 16777216
```

Beklenen canonical çıktı:

```text
0
0
0
0
-1
0
```

`tests/diagnostics/run_s510_mir_f32_rounding_tests.ps1` 2026-10-14
ölçümünde:

```text
AST       PASS
MIR       PASS
MIR-x64   PASS
AST-x64   PASS
JS        PASS
Toplam: 5 PASS: 5 FAIL: 0
```

Seçilmiş merkezi regresyon turu `s480_ast_regressions`,
`s502_f32_array_direct`, `s503_f32_storage`, `s505_unary_comparison`,
`s506_float_to_integer`, `s508_fix_type`, `s219_rotate_width` ve bu paket ile
**46/46 kontrol, 8/8 paket** sonucunu verdi. `build_64.ps1 -Force` çıkış 0'dır.

## Kapsam sınırı ve sonraki halka

S-510/S-511/S-512 kapanışı beş gerçek üretim/yürütme yolundaki F32 değer
parity'sidir. WAT/WASM tarafı için F32 runtime/artifact yürütmesi henüz bu
belgeyle kapanmış sayılmaz; hedef kapısı açık ve anlaşılır olmalıdır. Sonraki
iş, sorun listesinde kalan en yüksek öncelikli aktif kaydı seçip aynı ölçütle
AST, MIR, native x64, legacy AST-x64, JS ve WAT/WASM durumlarını ayrı ayrı
kanıtlamaktır.
