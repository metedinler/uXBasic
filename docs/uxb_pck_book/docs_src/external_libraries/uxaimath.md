# Dış Kütüphane Referansı: `uxaimath`

`uxaimath` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxaimath/uxaimath.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`
- **Veri doldurma ve okuma:** `ApplySigmoidPtr`, `ApplyTanhPtr`, `ApplyReLUPtr`, `ApplyLeakyReLUPtr`, `ApplyELUPtr`, `ApplyGELUPtr`, `ApplySwishPtr`, `SoftmaxPtr`, `SoftmaxInPlacePtr`
- **Hesaplama/analiz:** `Seed`, `Sigmoid`, `ReLU`, `LeakyReLU`, `ELU`, `GELU`, `Swish`, `Softplus`, `TensorSigmoid`, `TensorTanh`, `TensorReLU`, `TensorLeakyReLU` ve 23 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Seed` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Sigmoid` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ReLU` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `LeakyReLU` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ELU` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GELU` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `Swish` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Softplus` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `ApplySigmoidPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplyTanhPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ApplyReLUPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplyLeakyReLUPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplyELUPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ApplyGELUPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplySwishPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SoftmaxPtr` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `SoftmaxInPlacePtr` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `TensorSigmoid` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorTanh` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorReLU` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorLeakyReLU` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorGELU` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorSoftmax` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `MSE` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MAE` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Huber` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BinaryCrossEntropy` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `CategoricalCrossEntropy` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MSEGrad` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `BCEGrad` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `FillZeros` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillOnes` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillUniform` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillNormal` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `XavierUniform` | `SUB` | `-` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `HeUniform` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ClipValue` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ClipNorm` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `SGDUpdate` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MomentumUpdate` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DenseForward` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `DenseBatchForward` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ArgMax` | `FUNCTION` | `I64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `BinaryAccuracy` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Backend`

**İmza:** `FUNCTION Backend() AS STRING`

**Görev:** Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS STRING
sonuc = Backend()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Seed`

**İmza:** `SUB Seed(seed AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_seed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
Seed(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `Sigmoid`

**İmza:** `FUNCTION Sigmoid(x AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sigmoid`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Sigmoid(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `ReLU`

**İmza:** `FUNCTION ReLU(x AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_relu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = ReLU(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `LeakyReLU`

**İmza:** `FUNCTION LeakyReLU(x AS F64, alpha AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_leaky_relu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = LeakyReLU(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `ELU`

**İmza:** `FUNCTION ELU(x AS F64, alpha AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_elu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = ELU(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `GELU`

**İmza:** `FUNCTION GELU(x AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_gelu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = GELU(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `Swish`

**İmza:** `FUNCTION Swish(x AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_swish`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Swish(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Softplus`

**İmza:** `FUNCTION Softplus(x AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softplus`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Softplus(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `ApplySigmoidPtr`

**İmza:** `SUB ApplySigmoidPtr(dataPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sigmoid_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplySigmoidPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `ApplyTanhPtr`

**İmza:** `SUB ApplyTanhPtr(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_tanh_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyTanhPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ApplyReLUPtr`

**İmza:** `SUB ApplyReLUPtr(dataPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyReLUPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `ApplyLeakyReLUPtr`

**İmza:** `SUB ApplyLeakyReLUPtr(dataPtr AS U64, n AS I64, alpha AS F64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_leaky_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyLeakyReLUPtr(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `ApplyELUPtr`

**İmza:** `SUB ApplyELUPtr(dataPtr AS U64, n AS I64, alpha AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_elu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyELUPtr(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `ApplyGELUPtr`

**İmza:** `SUB ApplyGELUPtr(dataPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_gelu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyGELUPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `ApplySwishPtr`

**İmza:** `SUB ApplySwishPtr(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_swish_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplySwishPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SoftmaxPtr`

**İmza:** `SUB SoftmaxPtr(inputPtr AS U64, outputPtr AS U64, n AS I64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softmax_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
SoftmaxPtr(h, h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `SoftmaxInPlacePtr`

**İmza:** `SUB SoftmaxInPlacePtr(dataPtr AS U64, n AS I64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softmax_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
SoftmaxInPlacePtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `TensorSigmoid`

**İmza:** `SUB TensorSigmoid(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sigmoid_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorSigmoid(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `TensorTanh`

**İmza:** `SUB TensorTanh(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_tanh_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorTanh(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `TensorReLU`

**İmza:** `SUB TensorReLU(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorReLU(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `TensorLeakyReLU`

**İmza:** `SUB TensorLeakyReLU(t AS U64, alpha AS F64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_leaky_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorLeakyReLU(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `TensorGELU`

**İmza:** `SUB TensorGELU(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_gelu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorGELU(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `TensorSoftmax`

**İmza:** `SUB TensorSoftmax(src AS U64, dst AS U64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `src`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `dst`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softmax_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorSoftmax(h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `MSE`

**İmza:** `FUNCTION MSE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_mse_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = MSE(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `MAE`

**İmza:** `FUNCTION MAE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_mae_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = MAE(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `Huber`

**İmza:** `FUNCTION Huber(yTruePtr AS U64, yPredPtr AS U64, n AS I64, delta AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `delta`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_huber_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Huber(h, h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `BinaryCrossEntropy`

**İmza:** `FUNCTION BinaryCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_bce_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = BinaryCrossEntropy(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `CategoricalCrossEntropy`

**İmza:** `FUNCTION CategoricalCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_cce_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = CategoricalCrossEntropy(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `MSEGrad`

**İmza:** `SUB MSEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_mse_grad_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
MSEGrad(h, h, h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `BCEGrad`

**İmza:** `SUB BCEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_bce_grad_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
BCEGrad(h, h, h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `FillZeros`

**İmza:** `SUB FillZeros(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_zero_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillZeros(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `FillOnes`

**İmza:** `SUB FillOnes(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_one_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillOnes(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `FillUniform`

**İmza:** `SUB FillUniform(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lo`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `hi`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_uniform_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillUniform(h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `FillNormal`

**İmza:** `SUB FillNormal(dataPtr AS U64, n AS I64, mean AS F64, stddev AS F64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `mean`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `stddev`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_normal_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillNormal(h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `XavierUniform`

**İmza:** `SUB XavierUniform(dataPtr AS U64, n AS I64, fanIn AS I64, fanOut AS I64)`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `fanIn`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `fanOut`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_xavier_uniform_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
XavierUniform(h, 1, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `HeUniform`

**İmza:** `SUB HeUniform(dataPtr AS U64, n AS I64, fanIn AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `fanIn`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_he_uniform_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
HeUniform(h, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `ClipValue`

**İmza:** `SUB ClipValue(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lo`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `hi`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_clip_value_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ClipValue(h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `ClipNorm`

**İmza:** `SUB ClipNorm(dataPtr AS U64, n AS I64, maxNorm AS F64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `maxNorm`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_clip_norm_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ClipNorm(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `SGDUpdate`

**İmza:** `SUB SGDUpdate(paramPtr AS U64, gradPtr AS U64, n AS I64, lr AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `paramPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `gradPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sgd_update_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
SGDUpdate(h, h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `MomentumUpdate`

**İmza:** `SUB MomentumUpdate(paramPtr AS U64, gradPtr AS U64, velocityPtr AS U64, n AS I64, lr AS F64, momentum AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `paramPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `gradPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `velocityPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `momentum`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_momentum_update_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
MomentumUpdate(h, h, h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 43. `DenseForward`

**İmza:** `SUB DenseForward(inputPtr AS U64, weightPtr AS U64, biasPtr AS U64, outputPtr AS U64, inN AS I64, outN AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `weightPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `biasPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_dense_forward_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DenseForward(h, h, h, h, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 44. `DenseBatchForward`

**İmza:** `SUB DenseBatchForward(xPtr AS U64, weightPtr AS U64, biasPtr AS U64, yPtr AS U64, batch AS I64, inN AS I64, outN AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `xPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `weightPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `biasPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `batch`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_dense_batch_forward_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DenseBatchForward(h, h, h, h, 1, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 45. `ArgMax`

**İmza:** `FUNCTION ArgMax(dataPtr AS U64, n AS I64) AS I64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_argmax_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS I64
sonuc = ArgMax(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 46. `BinaryAccuracy`

**İmza:** `FUNCTION BinaryAccuracy(yTruePtr AS U64, yPredPtr AS U64, n AS I64, threshold AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `threshold`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_binary_accuracy_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = BinaryAccuracy(h, h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
