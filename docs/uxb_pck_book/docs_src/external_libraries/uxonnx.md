# Dış Kütüphane Referansı: `uxonnx`

`uxonnx` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxonnx/uxonnx.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Init`, `Version`, `LastError`
- **Handle yaşam döngüsü:** `SessionCreate`, `SessionFree`, `TensorCreate1D`, `TensorCreate2D`, `TensorCreate3D`, `TensorCreate4D`, `TensorFree`
- **Veri doldurma ve okuma:** `InputCount`, `OutputCount`, `InputName`, `OutputName`, `TensorCount`, `TensorDim`, `TensorDataPtr`, `TensorSet`, `TensorGet`
- **Hesaplama/analiz:** `TensorRank`, `Run1`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Init` | `FUNCTION` | `I32` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `Version` | `FUNCTION` | `STRING` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SessionCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SessionFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `InputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputName` | `FUNCTION` | `STRING` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `OutputName` | `FUNCTION` | `STRING` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `TensorCreate1D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate2D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate3D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate4D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `TensorCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorSet` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Run1` | `FUNCTION` | `U64` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Init`

**İmza:** `FUNCTION Init(runtimeDir AS STRING) AS I32`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `runtimeDir`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_global_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
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

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_runtime_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `LastError`

**İmza:** `FUNCTION LastError(session AS U64) AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = LastError(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `SessionCreate`

**İmza:** `FUNCTION SessionCreate(modelPath AS STRING, intraThreads AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `modelPath`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `intraThreads`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_session_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = SessionCreate("demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `SessionFree`

**İmza:** `SUB SessionFree(session AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_session_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
SessionFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `InputCount`

**İmza:** `FUNCTION InputCount(session AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_input_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = InputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `OutputCount`

**İmza:** `FUNCTION OutputCount(session AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_output_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = OutputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputName`

**İmza:** `FUNCTION InputName(session AS U64, index AS I64) AS STRING`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_input_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = InputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputName`

**İmza:** `FUNCTION OutputName(session AS U64, index AS I64) AS STRING`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_output_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = OutputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `TensorCreate1D`

**İmza:** `FUNCTION TensorCreate1D(n AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_1d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate1D(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `TensorCreate2D`

**İmza:** `FUNCTION TensorCreate2D(r AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `r`: `I64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_2d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate2D(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `TensorCreate3D`

**İmza:** `FUNCTION TensorCreate3D(a AS I64, b AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_3d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate3D(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `TensorCreate4D`

**İmza:** `FUNCTION TensorCreate4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_4d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate4D(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `TensorFree`

**İmza:** `SUB TensorFree(t AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
TensorFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `TensorCount`

**İmza:** `FUNCTION TensorCount(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = TensorCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `TensorRank`

**İmza:** `FUNCTION TensorRank(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = TensorRank(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `TensorDim`

**İmza:** `FUNCTION TensorDim(t AS U64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = TensorDim(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `TensorDataPtr`

**İmza:** `FUNCTION TensorDataPtr(t AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `TensorSet`

**İmza:** `SUB TensorSet(t AS U64, idx AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_set_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
TensorSet(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `TensorGet`

**İmza:** `FUNCTION TensorGet(t AS U64, idx AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_get_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS F64
sonuc = TensorGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `Run1`

**İmza:** `FUNCTION Run1(session AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `inputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_run1_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = Run1(h, "demo", h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
