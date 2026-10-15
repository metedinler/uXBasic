# Dış Kütüphane Referansı: `uxmatrix`

`uxmatrix` bölümü uXBasic’in matris ve OpenBLAS destekli sayısal hesap için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxmatrix/uxmatrix.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `RuntimeVersion`
- **Handle yaşam döngüsü:** `Create`, `Free`, `Clone`
- **Veri doldurma ve okuma:** `Rows`, `Cols`, `DataPtr`, `Set`, `Get`, `Add`
- **Hesaplama/analiz:** `Size`, `Fill`, `Zero`, `Eye`, `Transpose`, `Sub`, `Scale`, `Mul`, `MatVec`, `Dot`, `NormL1`, `NormL2` ve 12 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `RuntimeVersion` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Create` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `Rows` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Cols` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Size` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `DataPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Set` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Get` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Fill` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Zero` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Eye` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Clone` | `FUNCTION` | `U64` | Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır. |
| `Transpose` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Add` | `FUNCTION` | `U64` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `Sub` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Scale` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Mul` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MatVec` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Dot` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NormL1` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NormL2` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NormFro` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Trace` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `PrintMatrix` | `FUNCTION` | `I32` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Det` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Solve` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Inverse` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Cholesky` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `QR` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SVD` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `EigenSymmetric` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `RankSVD` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Cond2` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `RuntimeVersion`

**İmza:** `FUNCTION RuntimeVersion() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_runtime_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = RuntimeVersion()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Create`

**İmza:** `FUNCTION Create(rows AS I32, cols AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `rows`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `cols`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Create(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Free`

**İmza:** `SUB Free(m AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `Rows`

**İmza:** `FUNCTION Rows(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Rows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `Cols`

**İmza:** `FUNCTION Cols(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_cols`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Cols(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `Size`

**İmza:** `FUNCTION Size(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Size(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `DataPtr`

**İmza:** `FUNCTION DataPtr(m AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = DataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `Set`

**İmza:** `FUNCTION Set(m AS U64, r AS I32, c AS I32, v AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `r`: `I32` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Set(h, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `Get`

**İmza:** `FUNCTION Get(m AS U64, r AS I32, c AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `r`: `I32` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Get(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Fill`

**İmza:** `FUNCTION Fill(m AS U64, v AS F64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_fill`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Fill(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `Zero`

**İmza:** `FUNCTION Zero(m AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_zero`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Zero(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `Eye`

**İmza:** `FUNCTION Eye(m AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_eye`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Eye(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `Clone`

**İmza:** `FUNCTION Clone(m AS U64) AS U64`

**Görev:** Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_clone`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Clone(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `Transpose`

**İmza:** `FUNCTION Transpose(a AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_transpose`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Transpose(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `Add`

**İmza:** `FUNCTION Add(a AS U64, b AS U64) AS U64`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_add`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Add(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `Sub`

**İmza:** `FUNCTION Sub(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_sub`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Sub(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `Scale`

**İmza:** `FUNCTION Scale(a AS U64, s AS F64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `s`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_scale`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Scale(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `Mul`

**İmza:** `FUNCTION Mul(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_mul`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Mul(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `MatVec`

**İmza:** `FUNCTION MatVec(a AS U64, x AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_matvec`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = MatVec(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `Dot`

**İmza:** `FUNCTION Dot(a AS U64, b AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_dot`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Dot(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `NormL1`

**İmza:** `FUNCTION NormL1(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_norm_l1`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = NormL1(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `NormL2`

**İmza:** `FUNCTION NormL2(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_norm_l2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = NormL2(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `NormFro`

**İmza:** `FUNCTION NormFro(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_norm_fro`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = NormFro(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `Trace`

**İmza:** `FUNCTION Trace(a AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_trace`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Trace(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `PrintMatrix`

**İmza:** `FUNCTION PrintMatrix(a AS U64) AS I32`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_print`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = PrintMatrix(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `Det`

**İmza:** `FUNCTION Det(a AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_det`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Det(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `Solve`

**İmza:** `FUNCTION Solve(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_solve_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Solve(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `Inverse`

**İmza:** `FUNCTION Inverse(a AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_inverse_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Inverse(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `Cholesky`

**İmza:** `FUNCTION Cholesky(a AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_cholesky_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Cholesky(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `QR`

**İmza:** `FUNCTION QR(a AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_qr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = QR(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `SVD`

**İmza:** `FUNCTION SVD(a AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_svd`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = SVD(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `EigenSymmetric`

**İmza:** `FUNCTION EigenSymmetric(a AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_eigen_symmetric`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = EigenSymmetric(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `RankSVD`

**İmza:** `FUNCTION RankSVD(a AS U64, tol AS F64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `tol`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_rank_svd`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = RankSVD(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `Cond2`

**İmza:** `FUNCTION Cond2(a AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_cond2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Cond2(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
