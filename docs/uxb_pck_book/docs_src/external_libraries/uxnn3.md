# Dış Kütüphane Referansı: `uxnn3`

`uxnn3` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxnn3/uxnn3.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `LastError`, `Init`
- **Handle yaşam döngüsü:** `DatasetCreate`, `DatasetFree`, `LoadCSV`, `ModelCreate`, `ModelFree`, `Load`
- **Veri doldurma ve okuma:** `Rows`, `InputDim`, `OutputDim`, `XGet`, `YGet`, `XSet`, `YSet`, `XPtr`, `YPtr`, `AddDense`, `SetOptimizer`, `LayerCount` ve 2 işlev daha
- **Hesaplama/analiz:** `Shuffle`, `SplitTrain`, `SplitTest`, `Standardize`, `MinMax`, `PredictArgMax`, `EvalMSE`, `EvalBinaryAccuracy`
- **Dışa aktarma ve temizlik:** `SaveCSV`, `Save`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DatasetCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `DatasetFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `LoadCSV` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `SaveCSV` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `Rows` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `XGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `YGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `XSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `YSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `XPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `YPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Shuffle` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SplitTrain` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SplitTest` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Standardize` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MinMax` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `ModelCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `ModelFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `AddDense` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `Init` | `FUNCTION` | `I32` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `SetOptimizer` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `LayerCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ModelOutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `PredictArgMax` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `TrainDataset` | `FUNCTION` | `F64` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `EvalMSE` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `EvalBinaryAccuracy` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `Save` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `Load` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `LastError`

**İmza:** `FUNCTION LastError() AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS STRING
sonuc = LastError()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `DatasetCreate`

**İmza:** `FUNCTION DatasetCreate(rows AS I32, inputDim AS I32, outputDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `rows`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = DatasetCreate(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `DatasetFree`

**İmza:** `SUB DatasetFree(ds AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DatasetFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `LoadCSV`

**İmza:** `FUNCTION LoadCSV(path AS STRING, inputDim AS I32, outputDim AS I32, hasHeader AS I32) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `hasHeader`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_load_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = LoadCSV("demo", 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `SaveCSV`

**İmza:** `FUNCTION SaveCSV(ds AS U64, path AS STRING, includeHeader AS I32) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `includeHeader`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_save_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = SaveCSV(h, "demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `Rows`

**İmza:** `FUNCTION Rows(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Rows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputDim`

**İmza:** `FUNCTION InputDim(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = InputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputDim`

**İmza:** `FUNCTION OutputDim(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = OutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `XGet`

**İmza:** `FUNCTION XGet(ds AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_x_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = XGet(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `YGet`

**İmza:** `FUNCTION YGet(ds AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_y_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = YGet(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `XSet`

**İmza:** `FUNCTION XSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_x_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = XSet(h, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `YSet`

**İmza:** `FUNCTION YSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_y_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = YSet(h, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `XPtr`

**İmza:** `FUNCTION XPtr(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_x_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = XPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `YPtr`

**İmza:** `FUNCTION YPtr(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_y_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = YPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `Shuffle`

**İmza:** `FUNCTION Shuffle(ds AS U64, seed AS U32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `seed`: `U32` parametresi.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_shuffle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Shuffle(h, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `SplitTrain`

**İmza:** `FUNCTION SplitTrain(ds AS U64, ratio AS F64, seed AS U32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ratio`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `seed`: `U32` parametresi.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_split_train`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = SplitTrain(h, 1.0, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SplitTest`

**İmza:** `FUNCTION SplitTest(ds AS U64, ratio AS F64, seed AS U32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ratio`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `seed`: `U32` parametresi.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_split_test`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = SplitTest(h, 1.0, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `Standardize`

**İmza:** `FUNCTION Standardize(ds AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_standardize_fit_transform`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Standardize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `MinMax`

**İmza:** `FUNCTION MinMax(ds AS U64, a AS F64, b AS F64) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `a`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `b`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_minmax_fit_transform`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = MinMax(h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `ModelCreate`

**İmza:** `FUNCTION ModelCreate(inputDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = ModelCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `ModelFree`

**İmza:** `SUB ModelFree(model AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
ModelFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `AddDense`

**İmza:** `FUNCTION AddDense(model AS U64, outputDim AS I32, activation AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_add_dense`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = AddDense(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `Init`

**İmza:** `FUNCTION Init(model AS U64, seed AS U32, scale AS F64) AS I32`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `seed`: `U32` parametresi.
- `scale`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Init(h, 0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `SetOptimizer`

**İmza:** `FUNCTION SetOptimizer(model AS U64, opt AS I32, lr AS F64, momentum AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `opt`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `momentum`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_set_optimizer`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = SetOptimizer(h, 1, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `LayerCount`

**İmza:** `FUNCTION LayerCount(model AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_layer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = LayerCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `ModelOutputDim`

**İmza:** `FUNCTION ModelOutputDim(model AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = ModelOutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `PredictArgMax`

**İmza:** `FUNCTION PredictArgMax(model AS U64, ds AS U64, row AS I32) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_predict_argmax`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = PredictArgMax(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `TrainDataset`

**İmza:** `FUNCTION TrainDataset(model AS U64, ds AS U64, epochs AS I32, batchSize AS I32, shuffle AS I32, seed AS U32) AS F64`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `epochs`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `batchSize`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `shuffle`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `seed`: `U32` parametresi.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_train_dataset`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = TrainDataset(h, h, 1, 1, 1, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `EvalMSE`

**İmza:** `FUNCTION EvalMSE(model AS U64, ds AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_eval_mse`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = EvalMSE(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `EvalBinaryAccuracy`

**İmza:** `FUNCTION EvalBinaryAccuracy(model AS U64, ds AS U64, threshold AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `threshold`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_eval_binary_accuracy`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = EvalBinaryAccuracy(h, h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `Save`

**İmza:** `FUNCTION Save(model AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_save`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Save(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `Load`

**İmza:** `FUNCTION Load(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_load`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = Load("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
