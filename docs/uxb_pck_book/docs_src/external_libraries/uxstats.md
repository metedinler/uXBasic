# Dış Kütüphane Referansı: `uxstats`

`uxstats` bölümü uXBasic’in istatistik, hipotez testi ve veri analizi için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxstats/uxstats.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxstats/uxstats.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXSTATS_Version`
- **Handle yaşam döngüsü:** `UXSTATS_VecCreate`, `UXSTATS_VecFree`
- **Veri doldurma ve okuma:** `UXSTATS_VecCount`, `UXSTATS_VecPush`, `UXSTATS_VecSet`, `UXSTATS_VecGet`, `UXSTATS_VariancePop`, `UXSTATS_StdDevPop`
- **Hesaplama/analiz:** `UXSTATS_VecCapacity`, `UXSTATS_Sum`, `UXSTATS_Mean`, `UXSTATS_Min`, `UXSTATS_Max`, `UXSTATS_Range`, `UXSTATS_VarianceSamp`, `UXSTATS_StdDevSamp`, `UXSTATS_Median`, `UXSTATS_Percentile`, `UXSTATS_CovarianceSamp`, `UXSTATS_Correlation` ve 5 işlev daha
- **Dışa aktarma ve temizlik:** `UXSTATS_VecClear`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXSTATS_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXSTATS_VecCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS_VecFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXSTATS_VecClear` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXSTATS_VecCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXSTATS_VecCapacity` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS_VecPush` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXSTATS_VecSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXSTATS_VecGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXSTATS_Sum` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Mean` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Min` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Max` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Range` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_VariancePop` | `FUNCTION` | `F64` | Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür. |
| `UXSTATS_VarianceSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_StdDevPop` | `FUNCTION` | `F64` | Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür. |
| `UXSTATS_StdDevSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Median` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Percentile` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_CovarianceSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Correlation` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RegressionSlope` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RegressionIntercept` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RegressionR2` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RawMeanF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_RawStdDevSampF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXSTATS_Version`

**İmza:** `FUNCTION UXSTATS_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXSTATS_VecCreate`

**İmza:** `FUNCTION UXSTATS_VecCreate(capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS U64
sonuc = UXSTATS_VecCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXSTATS_VecFree`

**İmza:** `FUNCTION UXSTATS_VecFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXSTATS_VecClear`

**İmza:** `FUNCTION UXSTATS_VecClear(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_clear`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecClear(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXSTATS_VecCount`

**İmza:** `FUNCTION UXSTATS_VecCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXSTATS_VecCapacity`

**İmza:** `FUNCTION UXSTATS_VecCapacity(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_capacity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecCapacity(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXSTATS_VecPush`

**İmza:** `FUNCTION UXSTATS_VecPush(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_push`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecPush(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXSTATS_VecSet`

**İmza:** `FUNCTION UXSTATS_VecSet(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecSet(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXSTATS_VecGet`

**İmza:** `FUNCTION UXSTATS_VecGet(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_VecGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `UXSTATS_Sum`

**İmza:** `FUNCTION UXSTATS_Sum(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_sum`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Sum(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `UXSTATS_Mean`

**İmza:** `FUNCTION UXSTATS_Mean(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_mean`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Mean(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `UXSTATS_Min`

**İmza:** `FUNCTION UXSTATS_Min(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_min`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Min(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `UXSTATS_Max`

**İmza:** `FUNCTION UXSTATS_Max(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_max`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Max(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `UXSTATS_Range`

**İmza:** `FUNCTION UXSTATS_Range(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_range`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Range(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `UXSTATS_VariancePop`

**İmza:** `FUNCTION UXSTATS_VariancePop(h AS U64) AS F64`

**Görev:** Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_variance_pop`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_VariancePop(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `UXSTATS_VarianceSamp`

**İmza:** `FUNCTION UXSTATS_VarianceSamp(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_variance_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_VarianceSamp(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `UXSTATS_StdDevPop`

**İmza:** `FUNCTION UXSTATS_StdDevPop(h AS U64) AS F64`

**Görev:** Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_stddev_pop`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_StdDevPop(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `UXSTATS_StdDevSamp`

**İmza:** `FUNCTION UXSTATS_StdDevSamp(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_stddev_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_StdDevSamp(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `UXSTATS_Median`

**İmza:** `FUNCTION UXSTATS_Median(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_median`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Median(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `UXSTATS_Percentile`

**İmza:** `FUNCTION UXSTATS_Percentile(h AS U64, p AS F64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `p`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_percentile`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Percentile(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `UXSTATS_CovarianceSamp`

**İmza:** `FUNCTION UXSTATS_CovarianceSamp(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_covariance_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_CovarianceSamp(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `UXSTATS_Correlation`

**İmza:** `FUNCTION UXSTATS_Correlation(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_correlation`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Correlation(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `UXSTATS_RegressionSlope`

**İmza:** `FUNCTION UXSTATS_RegressionSlope(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_regression_slope`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RegressionSlope(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `UXSTATS_RegressionIntercept`

**İmza:** `FUNCTION UXSTATS_RegressionIntercept(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_regression_intercept`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RegressionIntercept(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `UXSTATS_RegressionR2`

**İmza:** `FUNCTION UXSTATS_RegressionR2(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_regression_r2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RegressionR2(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `UXSTATS_RawMeanF64`

**İmza:** `FUNCTION UXSTATS_RawMeanF64(ptr AS U64, count AS I32) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ptr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_mean_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RawMeanF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `UXSTATS_RawStdDevSampF64`

**İmza:** `FUNCTION UXSTATS_RawStdDevSampF64(ptr AS U64, count AS I32) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ptr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_stddev_samp_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RawStdDevSampF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
