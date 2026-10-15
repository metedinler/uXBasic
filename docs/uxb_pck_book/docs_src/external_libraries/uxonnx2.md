# Dış Kütüphane Referansı: `uxonnx2`

`uxonnx2` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxonnx2/uxonnx2.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Init`, `Version`, `LastError`, `ProviderAvailable`
- **Handle yaşam döngüsü:** `SessionCreate`, `SessionCreateAdvanced`, `SessionFree`, `TensorCreate1D`, `TensorCreate2D`, `TensorCreate3D`, `TensorCreate4D`, `TensorFree`, `RunCreate`, `RunFree`, `ResultFree`
- **Veri doldurma ve okuma:** `InputCount`, `OutputCount`, `InputName`, `OutputName`, `InputDim`, `OutputDim`, `TensorDim`, `TensorCount`, `TensorDataPtr`, `TensorSetF64`, `TensorGetF64`, `TensorSetI64` ve 6 işlev daha
- **Hesaplama/analiz:** `InputDType`, `OutputDType`, `InputRank`, `OutputRank`, `TensorDType`, `TensorRank`, `RunExecute`, `ResultTensor`, `Run1`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Init` | `FUNCTION` | `I32` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `Version` | `FUNCTION` | `STRING` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ProviderAvailable` | `FUNCTION` | `I32` | Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder. |
| `SessionCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SessionCreateAdvanced` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SessionFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `InputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputName` | `FUNCTION` | `STRING` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `OutputName` | `FUNCTION` | `STRING` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `InputDType` | `FUNCTION` | `I32` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `OutputDType` | `FUNCTION` | `I32` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `InputRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorCreate1D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate2D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate3D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate4D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `TensorDType` | `FUNCTION` | `I32` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorSetF64` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `TensorSetI64` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGetI64` | `FUNCTION` | `I64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `TensorSetString` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGetString` | `FUNCTION` | `STRING` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `RunCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `RunFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `RunAddInput` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `RunAddOutput` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `RunExecute` | `FUNCTION` | `U64` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `ResultFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `ResultCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ResultTensor` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Run1` | `FUNCTION` | `U64` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Init`

**İmza:** `FUNCTION Init(runtimeDir AS STRING) AS I32`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `runtimeDir`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = Init("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Version`

**İmza:** `FUNCTION Version() AS STRING`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `LastError`

**İmza:** `FUNCTION LastError() AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = LastError()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `ProviderAvailable`

**İmza:** `FUNCTION ProviderAvailable(provider AS I32) AS I32`

**Görev:** Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder.

**Parametreler:**
- `provider`: `I32` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_provider_available`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = ProviderAvailable(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `SessionCreate`

**İmza:** `FUNCTION SessionCreate(modelPath AS STRING) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `modelPath`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = SessionCreate("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `SessionCreateAdvanced`

**İmza:** `FUNCTION SessionCreateAdvanced(modelPath AS STRING, provider AS I32, intraThreads AS I32, interThreads AS I32, graphOpt AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `modelPath`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `provider`: `I32` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `intraThreads`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `interThreads`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `graphOpt`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_create_advanced`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = SessionCreateAdvanced("demo", 1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `SessionFree`

**İmza:** `SUB SessionFree(s AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
SessionFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputCount`

**İmza:** `FUNCTION InputCount(s AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = InputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputCount`

**İmza:** `FUNCTION OutputCount(s AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = OutputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `InputName`

**İmza:** `FUNCTION InputName(s AS U64, idx AS I64) AS STRING`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = InputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `OutputName`

**İmza:** `FUNCTION OutputName(s AS U64, idx AS I64) AS STRING`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = OutputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `InputDType`

**İmza:** `FUNCTION InputDType(s AS U64, idx AS I64) AS I32`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = InputDType(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `OutputDType`

**İmza:** `FUNCTION OutputDType(s AS U64, idx AS I64) AS I32`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = OutputDType(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `InputRank`

**İmza:** `FUNCTION InputRank(s AS U64, idx AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = InputRank(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `OutputRank`

**İmza:** `FUNCTION OutputRank(s AS U64, idx AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = OutputRank(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `InputDim`

**İmza:** `FUNCTION InputDim(s AS U64, idx AS I64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = InputDim(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `OutputDim`

**İmza:** `FUNCTION OutputDim(s AS U64, idx AS I64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = OutputDim(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `TensorCreate1D`

**İmza:** `FUNCTION TensorCreate1D(dtype AS I32, n AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_1d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate1D(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `TensorCreate2D`

**İmza:** `FUNCTION TensorCreate2D(dtype AS I32, r AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `r`: `I64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_2d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate2D(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `TensorCreate3D`

**İmza:** `FUNCTION TensorCreate3D(dtype AS I32, a AS I64, b AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_3d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate3D(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `TensorCreate4D`

**İmza:** `FUNCTION TensorCreate4D(dtype AS I32, a AS I64, b AS I64, c AS I64, d AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_4d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate4D(1, 1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `TensorFree`

**İmza:** `SUB TensorFree(t AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `TensorDType`

**İmza:** `FUNCTION TensorDType(t AS U64) AS I32`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = TensorDType(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `TensorRank`

**İmza:** `FUNCTION TensorRank(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorRank(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `TensorDim`

**İmza:** `FUNCTION TensorDim(t AS U64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorDim(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `TensorCount`

**İmza:** `FUNCTION TensorCount(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `TensorDataPtr`

**İmza:** `FUNCTION TensorDataPtr(t AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `TensorSetF64`

**İmza:** `SUB TensorSetF64(t AS U64, idx AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_set_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorSetF64(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `TensorGetF64`

**İmza:** `FUNCTION TensorGetF64(t AS U64, idx AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS F64
sonuc = TensorGetF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `TensorSetI64`

**İmza:** `SUB TensorSetI64(t AS U64, idx AS I64, value AS I64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_set_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorSetI64(h, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `TensorGetI64`

**İmza:** `FUNCTION TensorGetI64(t AS U64, idx AS I64) AS I64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_get_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorGetI64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `TensorSetString`

**İmza:** `SUB TensorSetString(t AS U64, idx AS I64, value AS STRING)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `STRING` metin parametresi.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_set_string`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorSetString(h, 1, "demo")
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `TensorGetString`

**İmza:** `FUNCTION TensorGetString(t AS U64, idx AS I64) AS STRING`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_get_string`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = TensorGetString(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `RunCreate`

**İmza:** `FUNCTION RunCreate(s AS U64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = RunCreate(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `RunFree`

**İmza:** `SUB RunFree(r AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
RunFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `RunAddInput`

**İmza:** `FUNCTION RunAddInput(r AS U64, name AS STRING, t AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `name`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_add_input`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = RunAddInput(h, "demo", h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `RunAddOutput`

**İmza:** `FUNCTION RunAddOutput(r AS U64, name AS STRING) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `name`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_add_output`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = RunAddOutput(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `RunExecute`

**İmza:** `FUNCTION RunExecute(r AS U64) AS U64`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_execute`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = RunExecute(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `ResultFree`

**İmza:** `SUB ResultFree(res AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `res`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_result_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
ResultFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `ResultCount`

**İmza:** `FUNCTION ResultCount(res AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `res`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_result_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = ResultCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `ResultTensor`

**İmza:** `FUNCTION ResultTensor(res AS U64, idx AS I64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `res`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_result_tensor`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = ResultTensor(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `Run1`

**İmza:** `FUNCTION Run1(s AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `inputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run1`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = Run1(h, "demo", h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
