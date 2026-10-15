# Dış Kütüphane Referansı: `uxnn2`

`uxnn2` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxnn2/uxnn2.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`, `Init`
- **Handle yaşam döngüsü:** `NetworkCreate`, `NetworkFree`, `Load`
- **Veri doldurma ve okuma:** `AddDense`, `LayerCount`, `InputDim`, `OutputDim`, `SetOptimizer`, `SetOptimizerParams`, `ForwardPtr`, `LossMSEPtr`, `TrainSampleMSEPtr`, `TrainArrayMSEPtr`, `PredictArgmaxPtr`, `GetWeight` ve 3 işlev daha
- **Hesaplama/analiz:** `Seed`
- **Dışa aktarma ve temizlik:** `Save`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Seed` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NetworkCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `NetworkFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `AddDense` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `LayerCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Init` | `SUB` | `-` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `SetOptimizer` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetOptimizerParams` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `ForwardPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `LossMSEPtr` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `TrainSampleMSEPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `TrainArrayMSEPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `PredictArgmaxPtr` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `GetWeight` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetWeight` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `GetBias` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetBias` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Save` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `Load` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
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

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
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

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_seed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
Seed(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `NetworkCreate`

**İmza:** `FUNCTION NetworkCreate(inputDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS U64
sonuc = NetworkCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `NetworkFree`

**İmza:** `SUB NetworkFree(net AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
NetworkFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `AddDense`

**İmza:** `FUNCTION AddDense(net AS U64, outputDim AS I32, activation AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_add_dense`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = AddDense(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `LayerCount`

**İmza:** `FUNCTION LayerCount(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_layer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = LayerCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputDim`

**İmza:** `FUNCTION InputDim(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = InputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputDim`

**İmza:** `FUNCTION OutputDim(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = OutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Init`

**İmza:** `SUB Init(net AS U64, initKind AS I32, scale AS F64)`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `initKind`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `scale`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
Init(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `SetOptimizer`

**İmza:** `SUB SetOptimizer(net AS U64, optKind AS I32, learningRate AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `optKind`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `learningRate`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_optimizer`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetOptimizer(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `SetOptimizerParams`

**İmza:** `SUB SetOptimizerParams(net AS U64, beta1 AS F64, beta2 AS F64, epsilon AS F64, weightDecay AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `beta1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `beta2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `epsilon`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `weightDecay`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_optimizer_params`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetOptimizerParams(h, 1.0, 1.0, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ForwardPtr`

**İmza:** `SUB ForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_forward_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
ForwardPtr(h, h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `LossMSEPtr`

**İmza:** `FUNCTION LossMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `targetPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_loss_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = LossMSEPtr(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `TrainSampleMSEPtr`

**İmza:** `FUNCTION TrainSampleMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `targetPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_train_sample_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = TrainSampleMSEPtr(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `TrainArrayMSEPtr`

**İmza:** `FUNCTION TrainArrayMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, epochs AS I32, shuffle AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `xPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sampleCount`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `epochs`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `shuffle`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_train_array_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = TrainArrayMSEPtr(h, h, h, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `PredictArgmaxPtr`

**İmza:** `FUNCTION PredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_predict_argmax_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = PredictArgmaxPtr(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `GetWeight`

**İmza:** `FUNCTION GetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `inIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_get_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = GetWeight(h, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `SetWeight`

**İmza:** `SUB SetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `inIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetWeight(h, 1, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `GetBias`

**İmza:** `FUNCTION GetBias(net AS U64, layerIndex AS I32, outIndex AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_get_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = GetBias(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `SetBias`

**İmza:** `SUB SetBias(net AS U64, layerIndex AS I32, outIndex AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetBias(h, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `Save`

**İmza:** `FUNCTION Save(net AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_save`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = Save(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `Load`

**İmza:** `FUNCTION Load(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_load`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS U64
sonuc = Load("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
