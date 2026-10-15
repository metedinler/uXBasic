# Dış Kütüphane Referansı: `uxstats2`

`uxstats2` bölümü uXBasic’in istatistik, hipotez testi ve veri analizi için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxstats/uxstats2.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXSTATS2_Version`
- **Handle yaşam döngüsü:** `UXSTATS2_VecCreate`, `UXSTATS2_VecFree`, `UXSTATS2_AnovaOneWayF`, `UXSTATS2_AnovaOneWayP`
- **Veri doldurma ve okuma:** `UXSTATS2_VecPush`, `UXSTATS2_VecSet`, `UXSTATS2_VecGet`, `UXSTATS2_VecCount`
- **Hesaplama/analiz:** `UXSTATS2_NormalCDF`, `UXSTATS2_NormalP2`, `UXSTATS2_TP2`, `UXSTATS2_ChiSquareP`, `UXSTATS2_FP`, `UXSTATS2_OneSampleTStat`, `UXSTATS2_OneSampleTP`, `UXSTATS2_WelchTStat`, `UXSTATS2_WelchTP`, `UXSTATS2_PooledTStat`, `UXSTATS2_PooledTP`, `UXSTATS2_PairedTStat` ve 35 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXSTATS2_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXSTATS2_VecCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS2_VecFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXSTATS2_VecPush` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXSTATS2_VecSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXSTATS2_VecGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXSTATS2_VecCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXSTATS2_NormalCDF` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXSTATS2_NormalP2` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXSTATS2_TP2` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquareP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_FP` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_OneSampleTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OneSampleTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_WelchTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_WelchTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PooledTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PooledTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PairedTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PairedTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OneSampleZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OneSampleZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoSampleZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoSampleZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OnePropZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OnePropZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoPropZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoPropZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_FVarianceStat` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS2_FVarianceP` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS2_ChiSquareGOFStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquareGOFP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquare2x2Stat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquare2x2P` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_AnovaOneWayF` | `FUNCTION` | `F64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS2_AnovaOneWayP` | `FUNCTION` | `F64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS2_PosthocBonferroniTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PosthocTukeyQ` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_PosthocScheffeF` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_CovarianceSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS2_Correlation` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionSlope` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionIntercept` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionR2` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionF` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionFP` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_VIFPair` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_DurbinWatson` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_BreuschGodfreyLM` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_BreuschGodfreyP` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_ADFStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ADFP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_AncovaBinaryF` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_AncovaBinaryP` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_HotellingT2_2D` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_HotellingP_2D` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXSTATS2_Version`

**İmza:** `FUNCTION UXSTATS2_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXSTATS2_VecCreate`

**İmza:** `FUNCTION UXSTATS2_VecCreate(capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS U64
sonuc = UXSTATS2_VecCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXSTATS2_VecFree`

**İmza:** `FUNCTION UXSTATS2_VecFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXSTATS2_VecPush`

**İmza:** `FUNCTION UXSTATS2_VecPush(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_push`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecPush(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXSTATS2_VecSet`

**İmza:** `FUNCTION UXSTATS2_VecSet(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecSet(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXSTATS2_VecGet`

**İmza:** `FUNCTION UXSTATS2_VecGet(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_VecGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXSTATS2_VecCount`

**İmza:** `FUNCTION UXSTATS2_VecCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXSTATS2_NormalCDF`

**İmza:** `FUNCTION UXSTATS2_NormalCDF(z AS F64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `z`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_normal_cdf`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_NormalCDF(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXSTATS2_NormalP2`

**İmza:** `FUNCTION UXSTATS2_NormalP2(z AS F64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `z`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_normal_p2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_NormalP2(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `UXSTATS2_TP2`

**İmza:** `FUNCTION UXSTATS2_TP2(t AS F64, df AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `t`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `df`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_t_p2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TP2(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `UXSTATS2_ChiSquareP`

**İmza:** `FUNCTION UXSTATS2_ChiSquareP(stat AS F64, df AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `stat`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `df`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquareP(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `UXSTATS2_FP`

**İmza:** `FUNCTION UXSTATS2_FP(stat AS F64, df1 AS F64, df2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `stat`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `df1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `df2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_f_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_FP(1.0, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `UXSTATS2_OneSampleTStat`

**İmza:** `FUNCTION UXSTATS2_OneSampleTStat(x AS U64, mu0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleTStat(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `UXSTATS2_OneSampleTP`

**İmza:** `FUNCTION UXSTATS2_OneSampleTP(x AS U64, mu0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleTP(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `UXSTATS2_WelchTStat`

**İmza:** `FUNCTION UXSTATS2_WelchTStat(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_welch_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_WelchTStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `UXSTATS2_WelchTP`

**İmza:** `FUNCTION UXSTATS2_WelchTP(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_welch_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_WelchTP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `UXSTATS2_PooledTStat`

**İmza:** `FUNCTION UXSTATS2_PooledTStat(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_pooled_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PooledTStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `UXSTATS2_PooledTP`

**İmza:** `FUNCTION UXSTATS2_PooledTP(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_pooled_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PooledTP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `UXSTATS2_PairedTStat`

**İmza:** `FUNCTION UXSTATS2_PairedTStat(before AS U64, after AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `before`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `after`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_paired_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PairedTStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `UXSTATS2_PairedTP`

**İmza:** `FUNCTION UXSTATS2_PairedTP(before AS U64, after AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `before`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `after`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_paired_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PairedTP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `UXSTATS2_OneSampleZStat`

**İmza:** `FUNCTION UXSTATS2_OneSampleZStat(x AS U64, mu0 AS F64, sigma AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigma`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleZStat(h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `UXSTATS2_OneSampleZP`

**İmza:** `FUNCTION UXSTATS2_OneSampleZP(x AS U64, mu0 AS F64, sigma AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigma`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleZP(h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `UXSTATS2_TwoSampleZStat`

**İmza:** `FUNCTION UXSTATS2_TwoSampleZStat(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sigmaX`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigmaY`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_sample_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoSampleZStat(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `UXSTATS2_TwoSampleZP`

**İmza:** `FUNCTION UXSTATS2_TwoSampleZP(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sigmaX`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigmaY`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_sample_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoSampleZP(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `UXSTATS2_OnePropZStat`

**İmza:** `FUNCTION UXSTATS2_OnePropZStat(successes AS I32, n AS I32, p0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `successes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `p0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_prop_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OnePropZStat(1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `UXSTATS2_OnePropZP`

**İmza:** `FUNCTION UXSTATS2_OnePropZP(successes AS I32, n AS I32, p0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `successes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `p0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_prop_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OnePropZP(1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `UXSTATS2_TwoPropZStat`

**İmza:** `FUNCTION UXSTATS2_TwoPropZStat(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `s2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_prop_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoPropZStat(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `UXSTATS2_TwoPropZP`

**İmza:** `FUNCTION UXSTATS2_TwoPropZP(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `s2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_prop_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoPropZP(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `UXSTATS2_FVarianceStat`

**İmza:** `FUNCTION UXSTATS2_FVarianceStat(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_f_variance_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_FVarianceStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `UXSTATS2_FVarianceP`

**İmza:** `FUNCTION UXSTATS2_FVarianceP(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_f_variance_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_FVarianceP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `UXSTATS2_ChiSquareGOFStat`

**İmza:** `FUNCTION UXSTATS2_ChiSquareGOFStat(obs AS U64, exp AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `obs`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `exp`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_gof_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquareGOFStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `UXSTATS2_ChiSquareGOFP`

**İmza:** `FUNCTION UXSTATS2_ChiSquareGOFP(obs AS U64, exp AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `obs`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `exp`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_gof_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquareGOFP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `UXSTATS2_ChiSquare2x2Stat`

**İmza:** `FUNCTION UXSTATS2_ChiSquare2x2Stat(a AS F64, b AS F64, c AS F64, d AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `a`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `b`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `c`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `d`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_2x2_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquare2x2Stat(1.0, 1.0, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `UXSTATS2_ChiSquare2x2P`

**İmza:** `FUNCTION UXSTATS2_ChiSquare2x2P(a AS F64, b AS F64, c AS F64, d AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `a`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `b`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `c`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `d`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_2x2_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquare2x2P(1.0, 1.0, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `UXSTATS2_AnovaOneWayF`

**İmza:** `FUNCTION UXSTATS2_AnovaOneWayF(values AS U64, groups AS U64) AS F64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_anova_oneway_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AnovaOneWayF(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `UXSTATS2_AnovaOneWayP`

**İmza:** `FUNCTION UXSTATS2_AnovaOneWayP(values AS U64, groups AS U64) AS F64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_anova_oneway_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AnovaOneWayP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `UXSTATS2_PosthocBonferroniTP`

**İmza:** `FUNCTION UXSTATS2_PosthocBonferroniTP(values AS U64, groups AS U64, g1 AS F64, g2 AS F64, comparisons AS I32) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `comparisons`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_posthoc_bonferroni_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PosthocBonferroniTP(h, h, 1.0, 1.0, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `UXSTATS2_PosthocTukeyQ`

**İmza:** `FUNCTION UXSTATS2_PosthocTukeyQ(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_posthoc_tukey_q`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PosthocTukeyQ(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `UXSTATS2_PosthocScheffeF`

**İmza:** `FUNCTION UXSTATS2_PosthocScheffeF(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_posthoc_scheffe_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PosthocScheffeF(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `UXSTATS2_CovarianceSamp`

**İmza:** `FUNCTION UXSTATS2_CovarianceSamp(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_covariance_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_CovarianceSamp(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `UXSTATS2_Correlation`

**İmza:** `FUNCTION UXSTATS2_Correlation(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_correlation`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_Correlation(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `UXSTATS2_RegressionSlope`

**İmza:** `FUNCTION UXSTATS2_RegressionSlope(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_slope`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionSlope(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 43. `UXSTATS2_RegressionIntercept`

**İmza:** `FUNCTION UXSTATS2_RegressionIntercept(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_intercept`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionIntercept(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 44. `UXSTATS2_RegressionR2`

**İmza:** `FUNCTION UXSTATS2_RegressionR2(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_r2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionR2(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 45. `UXSTATS2_RegressionF`

**İmza:** `FUNCTION UXSTATS2_RegressionF(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionF(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 46. `UXSTATS2_RegressionFP`

**İmza:** `FUNCTION UXSTATS2_RegressionFP(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_f_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionFP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 47. `UXSTATS2_VIFPair`

**İmza:** `FUNCTION UXSTATS2_VIFPair(x AS U64, y AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vif_pair`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_VIFPair(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 48. `UXSTATS2_DurbinWatson`

**İmza:** `FUNCTION UXSTATS2_DurbinWatson(resid AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `resid`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_durbin_watson`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_DurbinWatson(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 49. `UXSTATS2_BreuschGodfreyLM`

**İmza:** `FUNCTION UXSTATS2_BreuschGodfreyLM(resid AS U64, lags AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `resid`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `lags`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_breusch_godfrey_lm`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_BreuschGodfreyLM(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 50. `UXSTATS2_BreuschGodfreyP`

**İmza:** `FUNCTION UXSTATS2_BreuschGodfreyP(resid AS U64, lags AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `resid`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `lags`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_breusch_godfrey_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_BreuschGodfreyP(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 51. `UXSTATS2_ADFStat`

**İmza:** `FUNCTION UXSTATS2_ADFStat(y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_adf_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ADFStat(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 52. `UXSTATS2_ADFP`

**İmza:** `FUNCTION UXSTATS2_ADFP(y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_adf_p_approx`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ADFP(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 53. `UXSTATS2_AncovaBinaryF`

**İmza:** `FUNCTION UXSTATS2_AncovaBinaryF(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `covar`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_ancova_binary_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AncovaBinaryF(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 54. `UXSTATS2_AncovaBinaryP`

**İmza:** `FUNCTION UXSTATS2_AncovaBinaryP(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `covar`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_ancova_binary_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AncovaBinaryP(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 55. `UXSTATS2_HotellingT2_2D`

**İmza:** `FUNCTION UXSTATS2_HotellingT2_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x1`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x2`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_hotelling_t2_2d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_HotellingT2_2D(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 56. `UXSTATS2_HotellingP_2D`

**İmza:** `FUNCTION UXSTATS2_HotellingP_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x1`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x2`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_hotelling_p_2d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_HotellingP_2D(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
