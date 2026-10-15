# Dış Kütüphane Referansı: `uxmathcore`

`uxmathcore` bölümü uXBasic’in tipli buffer, ham bellek ve temel matematik çekirdeği için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxmathcore/uxmathcore.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXMC_Version`
- **Handle yaşam döngüsü:** `UXMC_BufferCreate`, `UXMC_BufferCreateCapacity`, `UXMC_BufferFree`, `UXMC_BufferClone`
- **Veri doldurma ve okuma:** `UXMC_BufferCount`, `UXMC_BufferDataPtr`, `UXMC_GetF64`, `UXMC_SetF64`, `UXMC_PushF64`, `UXMC_SetI64`, `UXMC_PushI64`, `UXMC_SetU64`, `UXMC_PushU64`, `UXMC_SetByte`, `UXMC_PushByte`, `UXMC_VecAddF64`
- **Hesaplama/analiz:** `UXMC_TYPE_I8`, `UXMC_TYPE_U8`, `UXMC_TYPE_I16`, `UXMC_TYPE_U16`, `UXMC_TYPE_I32`, `UXMC_TYPE_U32`, `UXMC_TYPE_I64`, `UXMC_TYPE_U64`, `UXMC_TYPE_F32`, `UXMC_TYPE_F64`, `UXMC_TypeSize`, `UXMC_BufferType` ve 21 işlev daha
- **Dışa aktarma ve temizlik:** `UXMC_BufferClear`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXMC_TYPE_I8` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U8` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_I16` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U16` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_I32` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U32` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_I64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_F32` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_F64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXMC_TypeSize` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXMC_BufferCreateCapacity` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXMC_BufferFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXMC_BufferType` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferCapacity` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferElemSize` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferByteSize` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferDataPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferClear` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXMC_BufferResize` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferReserve` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferFillZero` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferClone` | `FUNCTION` | `U64` | Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır. |
| `UXMC_BufferSlice` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferAppend` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferCast` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_GetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXMC_SetF64` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushF64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_FillF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_SetI64` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushI64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_SetU64` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushU64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_SetByte` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushByte` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_VecAddF64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_VecSubF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecMulF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecDivF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecScaleF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecAxpyF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecDotF64` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecL1NormF64` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecL2NormF64` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecNormalizeL2F64` | `FUNCTION` | `I32` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecMinF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXMC_VecMaxF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXMC_TYPE_I8`

**İmza:** `FUNCTION UXMC_TYPE_I8() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I8()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXMC_TYPE_U8`

**İmza:** `FUNCTION UXMC_TYPE_U8() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U8()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXMC_TYPE_I16`

**İmza:** `FUNCTION UXMC_TYPE_I16() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I16()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXMC_TYPE_U16`

**İmza:** `FUNCTION UXMC_TYPE_U16() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U16()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXMC_TYPE_I32`

**İmza:** `FUNCTION UXMC_TYPE_I32() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I32()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXMC_TYPE_U32`

**İmza:** `FUNCTION UXMC_TYPE_U32() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U32()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXMC_TYPE_I64`

**İmza:** `FUNCTION UXMC_TYPE_I64() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I64()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXMC_TYPE_U64`

**İmza:** `FUNCTION UXMC_TYPE_U64() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U64()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXMC_TYPE_F32`

**İmza:** `FUNCTION UXMC_TYPE_F32() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_F32()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `UXMC_TYPE_F64`

**İmza:** `FUNCTION UXMC_TYPE_F64() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_F64()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `UXMC_Version`

**İmza:** `FUNCTION UXMC_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `UXMC_TypeSize`

**İmza:** `FUNCTION UXMC_TypeSize(typeId AS I32) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `typeId`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_type_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TypeSize(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `UXMC_BufferCreate`

**İmza:** `FUNCTION UXMC_BufferCreate(typeId AS I32, count AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `typeId`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferCreate(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `UXMC_BufferCreateCapacity`

**İmza:** `FUNCTION UXMC_BufferCreateCapacity(typeId AS I32, count AS I32, capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `typeId`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_create_capacity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferCreateCapacity(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `UXMC_BufferFree`

**İmza:** `FUNCTION UXMC_BufferFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `UXMC_BufferType`

**İmza:** `FUNCTION UXMC_BufferType(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_type`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferType(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `UXMC_BufferCount`

**İmza:** `FUNCTION UXMC_BufferCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `UXMC_BufferCapacity`

**İmza:** `FUNCTION UXMC_BufferCapacity(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_capacity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferCapacity(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `UXMC_BufferElemSize`

**İmza:** `FUNCTION UXMC_BufferElemSize(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_elem_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferElemSize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `UXMC_BufferByteSize`

**İmza:** `FUNCTION UXMC_BufferByteSize(h AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_byte_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I64
sonuc = UXMC_BufferByteSize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `UXMC_BufferDataPtr`

**İmza:** `FUNCTION UXMC_BufferDataPtr(h AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `UXMC_BufferClear`

**İmza:** `FUNCTION UXMC_BufferClear(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_clear`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferClear(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `UXMC_BufferResize`

**İmza:** `FUNCTION UXMC_BufferResize(h AS U64, count AS I32) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_resize`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferResize(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `UXMC_BufferReserve`

**İmza:** `FUNCTION UXMC_BufferReserve(h AS U64, capacity AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_reserve`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferReserve(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `UXMC_BufferFillZero`

**İmza:** `FUNCTION UXMC_BufferFillZero(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_fill_zero`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferFillZero(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `UXMC_BufferClone`

**İmza:** `FUNCTION UXMC_BufferClone(h AS U64) AS U64`

**Görev:** Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_clone_handle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferClone(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `UXMC_BufferSlice`

**İmza:** `FUNCTION UXMC_BufferSlice(h AS U64, startIndex AS I32, count AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `startIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_slice_handle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferSlice(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `UXMC_BufferAppend`

**İmza:** `FUNCTION UXMC_BufferAppend(dst AS U64, src AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dst`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `src`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_append`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferAppend(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `UXMC_BufferCast`

**İmza:** `FUNCTION UXMC_BufferCast(src AS U64, dstType AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `src`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `dstType`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_cast_handle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferCast(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `UXMC_GetF64`

**İmza:** `FUNCTION UXMC_GetF64(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_GetF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `UXMC_SetF64`

**İmza:** `FUNCTION UXMC_SetF64(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetF64(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `UXMC_PushF64`

**İmza:** `FUNCTION UXMC_PushF64(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushF64(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `UXMC_FillF64`

**İmza:** `FUNCTION UXMC_FillF64(h AS U64, value AS F64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_fill_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_FillF64(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `UXMC_SetI64`

**İmza:** `FUNCTION UXMC_SetI64(h AS U64, index AS I32, value AS I64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetI64(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `UXMC_PushI64`

**İmza:** `FUNCTION UXMC_PushI64(h AS U64, value AS I64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushI64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `UXMC_SetU64`

**İmza:** `FUNCTION UXMC_SetU64(h AS U64, index AS I32, value AS U64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_u64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetU64(h, 1, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `UXMC_PushU64`

**İmza:** `FUNCTION UXMC_PushU64(h AS U64, value AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_u64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushU64(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `UXMC_SetByte`

**İmza:** `FUNCTION UXMC_SetByte(h AS U64, index AS I32, value AS I32) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_byte`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetByte(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `UXMC_PushByte`

**İmza:** `FUNCTION UXMC_PushByte(h AS U64, value AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_byte`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushByte(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `UXMC_VecAddF64`

**İmza:** `FUNCTION UXMC_VecAddF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_add_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecAddF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `UXMC_VecSubF64`

**İmza:** `FUNCTION UXMC_VecSubF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_sub_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecSubF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `UXMC_VecMulF64`

**İmza:** `FUNCTION UXMC_VecMulF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_mul_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecMulF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 43. `UXMC_VecDivF64`

**İmza:** `FUNCTION UXMC_VecDivF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_div_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecDivF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 44. `UXMC_VecScaleF64`

**İmza:** `FUNCTION UXMC_VecScaleF64(a AS U64, scalar AS F64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `scalar`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_scale_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecScaleF64(h, 1.0, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 45. `UXMC_VecAxpyF64`

**İmza:** `FUNCTION UXMC_VecAxpyF64(alpha AS F64, x AS U64, y AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_axpy_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecAxpyF64(1.0, h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 46. `UXMC_VecDotF64`

**İmza:** `FUNCTION UXMC_VecDotF64(a AS U64, b AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_dot_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecDotF64(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 47. `UXMC_VecL1NormF64`

**İmza:** `FUNCTION UXMC_VecL1NormF64(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_l1_norm_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecL1NormF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 48. `UXMC_VecL2NormF64`

**İmza:** `FUNCTION UXMC_VecL2NormF64(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_l2_norm_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecL2NormF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 49. `UXMC_VecNormalizeL2F64`

**İmza:** `FUNCTION UXMC_VecNormalizeL2F64(a AS U64, outv AS U64) AS I32`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_normalize_l2_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecNormalizeL2F64(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 50. `UXMC_VecMinF64`

**İmza:** `FUNCTION UXMC_VecMinF64(a AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_min_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecMinF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 51. `UXMC_VecMaxF64`

**İmza:** `FUNCTION UXMC_VecMaxF64(a AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_max_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecMaxF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.
