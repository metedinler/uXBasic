# Dış Kütüphane Referansı: `uxdataframe`

`uxdataframe` bölümü uXBasic’in DuckDB tabanlı tablo, SQL ve veri çerçevesi işlemleri için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxdataframe/uxdataframe.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `RuntimeVersion`, `DuckDBAvailable`, `DuckDBVersion`, `LastError`
- **Handle yaşam döngüsü:** `OpenMemory`, `OpenDatabase`, `Free`, `LoadCSV`, `LoadParquet`, `MatrixFree`
- **Veri doldurma ve okuma:** `RowCount`, `ColCount`, `ColName`, `GetF64`, `GetText`, `SelectCols`, `MatrixRows`, `MatrixCols`, `MatrixDataPtr`, `MatrixGet`
- **Hesaplama/analiz:** `Exec`, `Query`, `Head`, `Filter`, `OrderBy`, `Describe`, `GroupMean`, `JoinInner`, `ToParquet`, `ToF64Matrix`
- **Dışa aktarma ve temizlik:** `ToCSV`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `RuntimeVersion` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `DuckDBAvailable` | `FUNCTION` | `I32` | Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder. |
| `DuckDBVersion` | `FUNCTION` | `STRING` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `OpenMemory` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `OpenDatabase` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `LoadCSV` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `LoadParquet` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `Exec` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Query` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `RowCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ColCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ColName` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `GetText` | `FUNCTION` | `STRING` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Head` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SelectCols` | `FUNCTION` | `U64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Filter` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `OrderBy` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Describe` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GroupMean` | `FUNCTION` | `U64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `JoinInner` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ToCSV` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `ToParquet` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `ToF64Matrix` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `MatrixFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `MatrixRows` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `MatrixCols` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `MatrixDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `MatrixGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `RuntimeVersion`

**İmza:** `FUNCTION RuntimeVersion() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_runtime_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = RuntimeVersion()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `DuckDBAvailable`

**İmza:** `FUNCTION DuckDBAvailable() AS I32`

**Görev:** Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_duckdb_available`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = DuckDBAvailable()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `DuckDBVersion`

**İmza:** `FUNCTION DuckDBVersion() AS STRING`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_duckdb_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = DuckDBVersion()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `LastError`

**İmza:** `FUNCTION LastError(df AS U64) AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = LastError(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `OpenMemory`

**İmza:** `FUNCTION OpenMemory() AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_open_memory`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = OpenMemory()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `OpenDatabase`

**İmza:** `FUNCTION OpenDatabase(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_open_database`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = OpenDatabase("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `Free`

**İmza:** `SUB Free(df AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `LoadCSV`

**İmza:** `FUNCTION LoadCSV(path AS STRING, header AS I32) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `header`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_load_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = LoadCSV("demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `LoadParquet`

**İmza:** `FUNCTION LoadParquet(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_load_parquet`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = LoadParquet("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Exec`

**İmza:** `FUNCTION Exec(df AS U64, sql AS STRING) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_exec`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = Exec(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `Query`

**İmza:** `FUNCTION Query(df AS U64, sql AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_query`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Query(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `RowCount`

**İmza:** `FUNCTION RowCount(df AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_row_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I64
sonuc = RowCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ColCount`

**İmza:** `FUNCTION ColCount(df AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_col_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = ColCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `ColName`

**İmza:** `FUNCTION ColName(df AS U64, col AS I32) AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_col_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = ColName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `GetF64`

**İmza:** `FUNCTION GetF64(df AS U64, row AS I64, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS F64
sonuc = GetF64(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `GetText`

**İmza:** `FUNCTION GetText(df AS U64, row AS I64, col AS I32) AS STRING`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_get_text`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = GetText(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `Head`

**İmza:** `FUNCTION Head(df AS U64, n AS I64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_head`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Head(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SelectCols`

**İmza:** `FUNCTION SelectCols(df AS U64, columns AS STRING) AS U64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `columns`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_select`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = SelectCols(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `Filter`

**İmza:** `FUNCTION Filter(df AS U64, whereSql AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `whereSql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_filter`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Filter(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `OrderBy`

**İmza:** `FUNCTION OrderBy(df AS U64, orderSql AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `orderSql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_order_by`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = OrderBy(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `Describe`

**İmza:** `FUNCTION Describe(df AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_describe`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Describe(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `GroupMean`

**İmza:** `FUNCTION GroupMean(df AS U64, groupCol AS STRING, valueCol AS STRING) AS U64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groupCol`: `STRING` metin parametresi.
- `valueCol`: `STRING` metin parametresi.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_group_mean`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = GroupMean(h, "demo", "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `JoinInner`

**İmza:** `FUNCTION JoinInner(leftDf AS U64, rightDf AS U64, leftKey AS STRING, rightKey AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `leftDf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `rightDf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `leftKey`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `rightKey`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_join_inner`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = JoinInner(h, h, "demo", "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `ToCSV`

**İmza:** `FUNCTION ToCSV(df AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_to_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = ToCSV(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `ToParquet`

**İmza:** `FUNCTION ToParquet(df AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_to_parquet`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = ToParquet(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `ToF64Matrix`

**İmza:** `FUNCTION ToF64Matrix(df AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_to_f64_matrix`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = ToF64Matrix(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `MatrixFree`

**İmza:** `SUB MatrixFree(m AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
MatrixFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `MatrixRows`

**İmza:** `FUNCTION MatrixRows(m AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I64
sonuc = MatrixRows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `MatrixCols`

**İmza:** `FUNCTION MatrixCols(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_cols`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = MatrixCols(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `MatrixDataPtr`

**İmza:** `FUNCTION MatrixDataPtr(m AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = MatrixDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `MatrixGet`

**İmza:** `FUNCTION MatrixGet(m AS U64, row AS I64, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS F64
sonuc = MatrixGet(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
