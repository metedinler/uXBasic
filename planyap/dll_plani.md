Anladım. uXBasic compiler yapısına ve syntax'ına uygun, **gerçekçi ve implemente edilebilir** bir istatistiksel veri yapısı tasarlayacağım. Önce mevcut dokümanları inceleyerek compiler'ın gerçek durumunu ve kabiliyetlerini anlamalıyım.

## 2026-04-16 Plan Senkronu (CALL Familyasi Karar Kilidi)

Bu planda bundan sonra asagidaki siralama uygulanir:

1. `CALL(DLL, ...)` lane'i mevcut policy + resolver + audit cizgisinde ilerler.
2. `ALIAS yeni = eski` parser/semantic acikligi korunur; runtime garantisi ALIAS hedefi `CALL(DLL, ...)` oldugunda verilir.
3. DECLARE kirilmasiz model korunur:
    - tek dosya ic cagri opsiyonel
    - cok modul ic cagri onerilir
    - FFI/API icin zorunluya yakin
4. DIM baslangic degeri hattinda `DIM ... AS TYPE [= expr]` mevcut davranis korunur; koleksiyon/array toplu literal initialization ayri backlog kalemidir.
5. `CALL(API, ...)` runtime uygulamasi en son madde olarak backlogda kalir.

### En Son Madde Olarak CALL(API, ...) (Future)

Bu lane ancak su kosullar tamamlaninca acilir:

- CALL(DLL) x86/x64 lane'lerinde build+run green gate
- allowlist + attestation + audit sozlesmesinin stabil kalmasi
- parser/semantic tarafinda mevcut call ailesi regressionsuz PASS

CALL(API, ...) kabul kriterleri (future):

- parser acceptance: `CALL(API, lib, symbol, sig, [conv], args...)`
- runtime policy gate: API lane de allowlist/attestation deny kodlarini kullanir
- API resolver: deterministic error text + fail-fast
- regression: mevcut `CALL(DLL, ...)` ve `CALL(alias)` testleri kirmadan PASS

Mevcut analizinize göre şu kritik noktalar var:

## uXBasic Mevcut Durum Analizi

### ✅ Mevcut Güçlü Yönler (Kullanılabilir):
- **Temel veri tipleri**: `I8/U8`, `I16/U16`, `I32/U32`, `I64/U64`, `F32`, `F64`, `F80`, `BOOLEAN`, `STRING`, `POINTER`, `ARRAY`, `TYPE`
- **Bellek operasyonları**: `PEEKB/W/D`, `POKEB/W/D`, `MEMCOPY`, `MEMFILL` (temel formlar)
- **INLINE**: C/ASM kodu gömme (parser implemente, backend pending)
- **IMPORT**: C/C++ kütüphanelerini ekleme
- **TYPE/ARRAY**: Kullanıcı tanımlı yapılar ve diziler

### ⚠️ Eksik/Pending Özellikler:
- **POINTER intrinsics**: `VARPTR`, `SADD`, `LPTR`, `CODEPTR` (planlanmış, implemente edilmemiş)
- **Gelişmiş bellek komutları**: `POKES`, `MEMCOPYW/D`, `MEMFILLW/D` (planlanmış)
- **Koleksiyonlar**: `LIST`, `DICT`, `SET` (parser'da keyword yok, runtime yok)
- **Mantıksal operatörler**: `AND`, `OR`, `XOR` infix (lexer var, parser semantic yok)

---

## uXBasic Uyumlu İstatistiksel Veri Yapısı Tasarımı

Mevcut altyapıyı **aşmadan**, sadece **var olan özellikleri kullanarak** tasarlıyorum:

### 1. Temel Veri Yapısı: `STATVECTOR` (TYPE ile)

```basic
' ============================================================
' STATISTICAL MODULE - uXBasic Uyumlu Tasarim
' Mevcut TYPE/ARRAY/POINTER sistemini kullanir
' ============================================================

' --- Temel Istatistiksel Vektor Yapisi ---
TYPE StatVector
    ' Veri pointer'i (dizinin baslangici)
    dataPtr AS POINTER      ' VARPTR implemente edilinceye kadar: U64 adres
    
    ' Metadata
    length AS I32           ' Eleman sayisi
    capacity AS I32         ' Ayrilmis kapasite
    elemSize AS I32         ' Eleman boyutu (4=F32, 8=F64)
    
    ' Eksik veri yonetimi (bitmask - 1 bit per element)
    missingMask AS POINTER  ' U64 adres -> U8 dizisi (bitmask)
    missingCount AS I32     ' Toplam eksik sayisi
    
    ' Tip bilgisi
    dataType AS I32         ' 0=F32, 1=F64, 2=I32 (enum yerine constant)
END TYPE

' --- Kategorik Degisken Yapisi (Factor/Enum) ---
TYPE StatFactor
    ' Kodlar (sayisal)
    codes AS POINTER        ' I32 dizisi (0, 1, 2, ...)
    length AS I32
    
    ' Seviyeler (etiketler)
    levelCount AS I32
    levelPtr AS POINTER     ' String dizisi (sabit uzunluklu stringler)
    
    ' Eksik veri
    missingMask AS POINTER
    missingCount AS I32
    
    ' Ordinal mi?
    isOrdinal AS BOOLEAN    ' TRUE=sirali, FALSE=nominal
END TYPE

' --- Istatistiksel DataFrame (Coklu Sutun) ---
TYPE StatColumn
    colName AS STRING * 32  ' Sutun adi (sabit uzunluk)
    colType AS I32          ' 0=Numeric, 1=Factor, 2=String, 3=Date
    role AS I32             ' 0=Independent, 1=Dependent, 2=Covariate
    
    ' Union: Ya numeric ya factor
    numData AS StatVector
    catData AS StatFactor
    
    ' Metadata
    hasMissing AS BOOLEAN
    isComputed AS BOOLEAN   ' Hesaplanmis sutun mu?
END TYPE

TYPE StatDataFrame
    name AS STRING * 64
    colCount AS I32
    rowCount AS I32
    
    ' Kolon dizisi (sabit maksimum veya dinamik)
    cols AS ARRAY(100) OF StatColumn    ' Maks 100 sutun (ornek)
    
    ' Satir etiketleri (opsiyonel)
    rowNames AS POINTER     ' String dizisi
    
    ' Genel metadata
    created AS U64          ' Timestamp
    modified AS U64
END TYPE
```

### 2. BASIC Syntax Entegrasyonu (Mevcut Parser Uyumlu)

```basic
' ============================================================
' BASIC SYNTAX - Mevcut Parser Kurallarina Uygun
' ============================================================

' --- 1. Vektor Olusturma (DIM + AS TYPE) ---
DIM yas AS StatVector
DIM gelir AS StatVector
DIM cinsiyet AS StatFactor

' --- 2. DataFrame Olusturma ---
DIM hastaVerisi AS StatDataFrame

' --- 3. Veri Yükleme (Mevcut I/O + Inline C) ---
' Yöntem A: C kütüphanesi ile (IMPORT kullanarak)
IMPORT(C, "statlib.c")    ' C'de yazilmis loader

INLINE(C, "load_csv", "func")
    ' C kodu: CSV okuma, parse, StatVector doldurma
    ' uXBasic bellek modeline uygun yazilmis
END INLINE

' Yöntem B: BASIC ile manuel (mevcut FILE I/O)
SUB LoadVectorFromFile(vec AS StatVector, filename AS STRING)
    OPEN filename FOR INPUT AS #1
    
    ' Kapasite tahmini
    DIM lineCount AS I32 = 0
    WHILE NOT EOF(1)
        INPUT #1, dummy$
        lineCount = lineCount + 1
    WEND
    SEEK #1, 0    ' Basina don (mevcut SEEK)
    
    ' Bellek ayir (INLINE C ile malloc wrapper)
    vec.length = lineCount
    vec.capacity = lineCount
    vec.elemSize = 8    ' F64
    ' dataPtr = AllocStatMemory(lineCount * 8)  ' C fonksiyonu
    
    DIM i AS I32 = 0
    DIM val AS F64
    WHILE NOT EOF(1) AND i < lineCount
        INPUT #1, val
        ' POKED kullanarak bellege yaz (mevcut POKED)
        ' POKED vec.dataPtr + (i * 8), val
        i = i + 1
    WEND
    
    CLOSE #1
END SUB

' --- 4. Istatistiksel Fonksiyonlar (SUB/FUNCTION) ---
' Mevcut FUNCTION syntax'ina tam uygun

FUNCTION StatMean(vec AS StatVector) AS F64
    ' Welford algoritmi - tek gecisli, numerik stabil
    DIM mean AS F64 = 0.0
    DIM n AS I32 = 0
    DIM i AS I32
    DIM x AS F64
    
    FOR i = 0 TO vec.length - 1
        ' Eksik mi kontrolu (bitmask)
        IF NOT IsMissing(vec.missingMask, i) THEN
            ' PEEKD ile deger oku (mevcut)
            ' x = PEEKD(vec.dataPtr + (i * vec.elemSize))
            n = n + 1
            mean = mean + (x - mean) / n    ' Welford
        END IF
    NEXT i
    
    StatMean = mean
END FUNCTION

FUNCTION StatStd(vec AS StatVector, sample AS BOOLEAN) AS F64
    ' Varyans hesabi (Welford)
    DIM mean AS F64 = 0.0
    DIM M2 AS F64 = 0.0
    DIM n AS I32 = 0
    DIM i AS I32
    DIM x AS F64
    DIM delta AS F64
    
    FOR i = 0 TO vec.length - 1
        IF NOT IsMissing(vec.missingMask, i) THEN
            ' x = PEEKD(vec.dataPtr + (i * vec.elemSize))
            n = n + 1
            delta = x - mean
            mean = mean + delta / n
            M2 = M2 + delta * (x - mean)
        END IF
    NEXT i
    
    IF sample THEN
        StatStd = SQR(M2 / (n - 1))    ' Sample std
    ELSE
        StatStd = SQR(M2 / n)          ' Population std
    END IF
END FUNCTION

' --- 5. Kategorik Kodlama (StatFactor) ---
SUB FactorEncode(fac AS StatFactor, rawStrings AS ARRAY() OF STRING)
    ' String -> Kod donusumu
    ' Mevcut STRING fonksiyonlari: LEN, UCASE, LCASE, ASC
    
    DIM i AS I32, j AS I32
    DIM found AS BOOLEAN
    DIM current AS STRING * 32
    
    FOR i = 0 TO fac.length - 1
        current = rawStrings(i)
        found = FALSE
        
        ' Mevcut seviyelerde ara
        FOR j = 0 TO fac.levelCount - 1
            ' String karsilastirma (mevcut = operator)
            IF current = GetLevelName(fac.levelPtr, j) THEN
                ' codes(i) = j
                found = TRUE
                EXIT FOR
            END IF
        NEXT j
        
        IF NOT found THEN
            ' Yeni seviye ekle
            ' AddLevel(fac, current)
            ' codes(i) = fac.levelCount - 1
        END IF
    NEXT i
END SUB

' --- 6. Regresyon (C Kütüphanesi ile) ---
' En profesyonel yontem: C'de yazilmis LAPACK/BLAS wrapper'i

IMPORT(C, "regression.c")   ' C kütüphanesi

DECLARE FUNCTION LinearRegression CDECL (x AS POINTER, y AS POINTER, _
                                         n AS I32, slope AS POINTER, _
                                         intercept AS POINTER) AS I32

SUB FitLinearModel(df AS StatDataFrame, xCol AS I32, yCol AS I32, _
                   model AS POINTER)
    DIM xVec AS StatVector
    DIM yVec AS StatVector
    
    xVec = df.cols(xCol).numData
    yVec = df.cols(yCol).numData
    
    ' C fonksiyonuna pointer gonder
    ' LinearRegression(xVec.dataPtr, yVec.dataPtr, ...)
END SUB
```

### 3. C Runtime Kütüphanesi (IMPORT ile)

```c
/* statcore.c - uXBasic IMPORT(C) ile kullanilir */
/* uXBasic bellek modeline uygun */

#include <stdint.h>
#include <stdlib.h>
#include <math.h>

/* uXBasic'ten cagrilacak fonksiyon imzalari */
/* CDECL calling convention (Windows x64) */

/* Bellek yonetimi - uXBasic heap'inden ayir */
void* __cdecl StatAlloc(uint64_t size) {
    return malloc(size);  /* Gecici: uXBasic allocator'e baglanacak */
}

void __cdecl StatFree(void* ptr) {
    free(ptr);
}

/* Temel istatistikler */
double __cdecl StatSum(double* data, int32_t len, uint8_t* missingMask) {
    double sum = 0.0;
    int32_t i;
    for (i = 0; i < len; i++) {
        /* Bitmask kontrolu: i. bit 0 ise valid */
        if ((missingMask[i / 8] & (1 << (i % 8))) == 0) {
            sum += data[i];
        }
    }
    return sum;
}

/* Welford algoritmi - numerik stabil ortalama/varyans */
void __cdecl StatMeanVar(double* data, int32_t len, uint8_t* missingMask,
                         double* outMean, double* outVar, int32_t* outN) {
    double mean = 0.0, M2 = 0.0;
    int32_t n = 0, i;
    double delta, x;
    
    for (i = 0; i < len; i++) {
        if ((missingMask[i / 8] & (1 << (i % 8))) == 0) {
            x = data[i];
            n++;
            delta = x - mean;
            mean += delta / n;
            M2 += delta * (x - mean);
        }
    }
    
    *outMean = mean;
    *outVar = (n > 1) ? M2 / (n - 1) : 0.0;
    *outN = n;
}

/* KNN imputasyon */
void __cdecl StatImputeKNN(double* data, int32_t len, uint8_t* missingMask,
                           int32_t k) {
    /* Eksik degerleri k-en yakin komsu ile doldur */
    /* ... implementasyon ... */
}

/* Regresyon - Normal Equations */
int __cdecl LinearRegression(double* x, double* y, int32_t n,
                             double* slope, double* intercept, double* r2) {
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;
    int32_t i, validN = 0;
    
    for (i = 0; i < n; i++) {
        sumX += x[i];
        sumY += y[i];
        sumXY += x[i] * y[i];
        sumX2 += x[i] * x[i];
        sumY2 += y[i] * y[i];
        validN++;
    }
    
    double denom = validN * sumX2 - sumX * sumX;
    if (fabs(denom) < 1e-10) return -1;  /* Singular */
    
    *slope = (validN * sumXY - sumX * sumY) / denom;
    *intercept = (sumY - *slope * sumX) / validN;
    
    /* R-kare */
    double ssTot = sumY2 - (sumY * sumY) / validN;
    double ssRes = 0;  /* Hesaplanacak */
    *r2 = 1.0 - (ssRes / ssTot);
    
    return 0;
}
```

### 4. Parser Uyumlu Fonksiyon İmzaları

```basic
' ============================================================
' INTRINSIC FONKSIYONLAR - Parser Validation Uyumlu
' 2.4.1 ve 2.4.2 arasina eklenecek
' ============================================================

' --- Mevcut 2.4.1'e eklenir ---
' Arguman (Tek parametre, istatistiksel donusum)
STAT_SUM(vec AS StatVector) AS F64           ' Toplam
STAT_MEAN(vec AS StatVector) AS F64          ' Ortalama
STAT_STD(vec AS StatVector) AS F64           ' Standart sapma (sample)
STAT_VAR(vec AS StatVector) AS F64           ' Varyans
STAT_MIN(vec AS StatVector) AS F64           ' Minimum
STAT_MAX(vec AS StatVector) AS F64           ' Maksimum
STAT_MEDIAN(vec AS StatVector) AS F64         ' Medyan
STAT_NVALID(vec AS StatVector) AS I32        ' Gecerli gozlem sayisi

' --- 2.4.2 Coklu Arguman ---
' MEAN(expr1, expr2, ...) - Asiri yuklenmis (overloaded)
' Mevcut: MEAN sayisal arguman alir
' Yeni: MEAN(vec AS StatVector) veya MEAN(df AS StatDataFrame, col AS I32)

' --- Kategorik ---
FACTOR_LEVELS(fac AS StatFactor) AS I32      ' Seviye sayisi
FACTOR_MODE(fac AS StatFactor) AS I32        ' En sik kod

' --- Eksik Veri ---
IS_MISSING(vec AS StatVector, idx AS I32) AS BOOLEAN
SET_MISSING(vec AS StatVector, idx AS I32)
CLEAR_MISSING(vec AS StatVector, idx AS I32)

' --- Veri Yonetimi ---
VEC_ALLOC(vec AS StatVector, n AS I32, elemSize AS I32)
VEC_FREE(vec AS StatVector)
VEC_GET(vec AS StatVector, idx AS I32) AS F64
VEC_SET(vec AS StatVector, idx AS I32, val AS F64)
```

### 5. Gercekci Implementasyon Yolu (Fazlar)

| Faz | İçerik | uXBasic Özellikleri | Süre |
|-----|--------|---------------------|------|
| **Faz 0** | Temel TYPE tanımları | Mevcut TYPE, ARRAY | 2-3 saat |
| **Faz 1** | Bellek yönetimi (C) | IMPORT(C), INLINE | 4-5 saat |
| **Faz 2** | Temel istatistikler (C) | IMPORT(C), FUNCTION | 3-4 saat |
| **Faz 3** | BASIC wrapper'lar | SUB/FUNCTION, AS TYPE | 2-3 saat |
| **Faz 4** | Eksik veri yönetimi | POINTER, PEEK/POKE | 3-4 saat |
| **Faz 5** | Kategorik değişkenler | STRING, ARRAY | 3-4 saat |
| **Faz 6** | Regresyon (C BLAS) | IMPORT(C) | 4-5 saat |

**Toplam: 20-25 saat** (tek kişi, mevcut uXBasic altyapısı ile)

---

## Özet: Neden Bu Tasarım Uygun?

| Kriter | Çözüm |
|--------|-------|
| **Parser uyumluluğu** | Sadece mevcut `TYPE`, `ARRAY`, `POINTER`, `SUB/FUNCTION` kullanır |
| **Bellek güvenliği** | `POINTER` + C runtime, Windows 11 ASLR/DEP uyumlu |
| **Eksik veri** | Bitmask ile uXBasic `POINTER` sisteminde yönetilir |
| **Kategorik veri** | `STRING * N` sabit uzunluk + `ARRAY` kodlar |
| **Performans** | Ağır hesaplamalar C'de (IMPORT), yönetim BASIC'te |
| **Gelecek genişletme** | `VARPTR` implemente olduğunda doğrudan değişken adresleme |

Bu tasarım, mevcut uXBasic sınırlamalarını **engel değil özellik** olarak kullanır. Örneğin `VARPTR` olmadığı için `POINTER` + manuel bellek yönetimi kullanılır, bu da daha fazla kontrol sağlar.

Anladım. Temel mimari kararı netleştirmemiz gerekiyor. uXBasic'in mevcut yapısını incelediğime göre iki farklı yaklaşım mümkün:

## Seçenek A: Dış Modül (External Library)

```
┌─────────────────────────────────────────┐
│         uXBasic Derleyici (FreeBASIC)    │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐   │
│  │ Lexer   │→ │ Parser  │→ │ Codegen │   │
│  │ .fbs    │  │ .fbs    │  │ x64     │   │
│  └─────────┘  └─────────┘  └─────────┘   │
└─────────────────────────────────────────┘
              ↓ IMPORT(C)
┌─────────────────────────────────────────┐
│  libstat.dll / libstat.a (C Derlenmiş)   │
│  • Temel istatistik fonksiyonları        │
│  • Bellek yönetimi                       │
│  • CSV okuma/yazma                       │
└─────────────────────────────────────────┘
```

**Avantajları:**
- Derleyiciye dokunmadan geliştirilebilir
- C performansı (BLAS/LAPACK bağlanabilir)
- Hata ayıklama kolaylığı

**Dezavantajları:**
- Kullanıcı `IMPORT(C, "statlib.c")` yazmalı
- Tip güvenliği runtime'da (C'de) sağlanır

---

## Seçenek B: Derleyici İçine Gömülü (Intrinsic)

```
┌─────────────────────────────────────────┐
│         uXBasic Derleyici (FreeBASIC)    │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐   │
│  │ Lexer   │→ │ Parser  │→ │ Codegen │   │
│  │ +TOKEN  │  │ +STAT   │  │ +x64    │   │
│  │ _STAT   │  │ _NODE   │  │ _emit   │   │
│  └─────────┘  └─────────┘  └─────────┘   │
│         ↑ Yerleşik istatistik desteği    │
└─────────────────────────────────────────┘
```

**Avantajları:**
- `DIM x AS STATVECTOR` syntax'ı doğal
- Derleme zamanı tip kontrolü
- Daha iyi hata mesajları
- Tek paket (bağımlılık yok)

**Dezavantajları:**
- Derleyici kodu büyür (~%15-20)
- Geliştirme/test daha karmaşık
- Her istatistik fonksiyonu için parser değişikliği

---

## Seçenek C: Hibrit (Önerilen)

```
┌─────────────────────────────────────────┐
│         uXBasic Derleyici                │
│                                          │
│  PARSER: Minimal STAT token'ları         │
│  • DIM ... AS STATVECTOR (type flag)    │
│  • STAT_MEAN(x), STAT_STD(x)            │
│                                          │
│  CODEGEN: İki yol                        │
│  • Basit işlemler → INLINE x64          │
│  • Karmaşık işlemler → runtime call     │
│                                          │
│  RUNTIME: libuxstat.a (C, gömülü)       │
│  • Derleyici ile birlikte link edilir    │
│  • Kullanıcı görmeyebilir                │
└─────────────────────────────────────────┘
```

**Hibrit yaklaşım detayı:**

| Katman | Nerede | Ne Yapar |
|--------|--------|----------|
| **Syntax** | Parser | `STATVECTOR`, `STAT_MEAN()` tanır |
| **AST** | Parser | `StatVectorNode`, `StatFuncNode` oluşturur |
| **Semantic** | Type Resolver | Tip kontrolü, bellek hesaplama |
| **Codegen** | x64 Backend | Statik kod veya runtime çağrısı üretir |
| **Runtime** | C (gömülü) | Ağır algoritmalar (regresyon, ANOVA) |

---

## Karar Matrisi

| Kriter | A: Dış Modül | B: Tam Gömülü | C: Hibrit |
|--------|-------------|---------------|-----------|
| Geliştirme hızı | ⭐⭐⭐ | ⭐ | ⭐⭐ |
| Performans | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Kullanıcı deneyimi | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Bakım kolaylığı | ⭐⭐⭐ | ⭐ | ⭐⭐ |
| Derleyici boyutu | ⭐⭐⭐ | ⭐ | ⭐⭐ |
| Tip güvenliği | ⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

---

## Benim Önerim: Seçenek C (Hibrit) - Aşamalı

### Aşama 1: Runtime Öncelik (Hemen başlanabilir)

```basic
' Kullanıcı kodu - syntax mevcut BASIC ile
IMPORT(C, "uxstat.c")    ' Geçici olarak açık

DIM yas AS ARRAY(100) OF F64
' ... veri yükle ...

PRINT StatMean(yas, 100)  ' C fonksiyonu
```

**C tarafı (uxstat.c):**
```c
double __cdecl StatMean(double* data, int32_t n) {
    // Welford algoritmi
}
```

### Aşama 2: Parser Entegrasyonu (VARPTR implemente olduktan sonra)

```basic
' Yeni syntax - derleyici tanır
DIM yas AS STATVECTOR     ' Özel tip flag'i

' Derleyici otomatik:
' 1. Bellek ayırır (AllocStatVector)
' 2. Metadata tutar (length, missing mask)
' 3. C runtime'a pointer geçirir
PRINT MEAN(yas)           ' → StatMean(yas.dataPtr, yas.length)
```

### Aşama 3: Tam Entegrasyon (İstatistiksel modül tamamlandığında)

```basic
' SPSS/R benzeri tam deneyim
DIM df AS DATAFRAME
LOAD df FROM "data.csv"

REGRESSION df WITH y = x1 + x2 + x3
PRINT RESULTS.COEF
```

---

## Teknik Karar: Şimdi Ne Yapalım?

Mevcut uXBasic durumuna göre:

| Özellik | Durum | Etki |
|---------|-------|------|
| `VARPTR` | **PLANNED** | Pointer aritmetiği zor |
| `POINTER` | **Mevcut** | Bellek yönetimi mümkün |
| `IMPORT(C)` | **Mevcut** | C kütüphanesi bağlanabilir |
| `INLINE` | **Parser OK, Backend Pending** | Optimize edilmiş kod zor |

**Öneri:** Şu an için **Seçenek A (Dış Modül)** ile başlayın, `VARPTR` ve `INLINE` backend'i tamamlandığında **C'ye geçin**.

Bu size:
1. Hemen çalışan istatistik fonksiyonları
2. Derleyiciyi riske atmadan test etme imkanı
3. Gelecekte sorunsuz entegrasyon yolu

sunar.

Hangi yolu seçmek istiyorsunuz?

Anladım. C/C++ DLL olarak kullanmak en verimli ve gerçekçi yol. uXBasic'in mevcut `IMPORT(C)` altyapısı ile doğal entegrasyon sağlar.

## Mimari: uXBasic + C++ İstatistik DLL

```
┌─────────────────────────────────────────┐
│         uXBasic Derleyici               │
│    AST Evaluator (FreeBASIC)            │
│         ↓ IMPORT(C, "uxstat.dll")        │
│         ↓ CALL(DLL, ...) [FFI-1]         │
├─────────────────────────────────────────┤
│  uxstat.dll (C++17, derlenmiş)          │
│  • Sütun-tabanlı veri yapısı            │
│  • SIMD optimizasyonu (AVX2/AVX-512)    │
│  • Çoklu iş parçacığı (OpenMP)            │
│  • Bellek havuzu (pool allocator)         │
└─────────────────────────────────────────┘
```

---

## C++ DLL Tasarımı (uxstat.dll)

### 1. Temel Veri Yapıları (Columnar Storage)

```cpp
// uxstat.h - C ABI ile dışa açılan arayüz
#pragma once

#ifdef UXSTAT_EXPORTS
#define UXSTAT_API extern "C" __declspec(dllexport)
#else
#define UXSTAT_API extern "C" __declspec(dllimport)
#endif

#include <cstdint>
#include <cstddef>

// ============================================================================
// TEMEL TİPLER (uXBasic ile uyumlu)
// ============================================================================

using i8  = int8_t;   using u8  = uint8_t;
using i16 = int16_t;  using u16 = uint16_t;
using i32 = int32_t;  using u32 = uint32_t;
using i64 = int64_t;  using u64 = uint64_t;
using f32 = float;    using f64 = double;

// ============================================================================
// EKSİK VERİ YÖNETİMİ (Bitmask - R uyumlu)
// ============================================================================

enum class MissingType : i32 {
    NA_FLOAT = 0,      // IEEE 754 NaN (f64 için)
    NA_INT   = 1,      // INT_MIN sentinel (i32 için)
    BITMASK  = 2,      // Ayrı bit maskesi (en esnek)
    BYTEMASK = 3       // Byte düzeyinde
};

// ============================================================================
// SÜTUN YAPISI (Columnar - Apache Arrow tarzı)
// ============================================================================

struct StatColumn {
    char    name[64];           // Sütun adı
    i32     type;               // 0=i32, 1=i64, 2=f32, 3=f64, 4=factor
    i32     length;             // Eleman sayısı
    i32     missingCount;       // Eksik sayısı
    
    union {
        i32*  i32_data;
        i64*  i64_data;
        f32*  f32_data;
        f64*  f64_data;
        i32*  factor_codes;     // Kategorik kodlar
    } data;
    
    u8*     missingMask;        // Bitmask (1 bit = 1 eleman)
    void*   dictionary;         // Kategorik için seviyeler (FactorLevel*)
    
    // Metadata
    f64     cachedMean;         // Lazy evaluation
    f64     cachedStd;
    bool    statsValid;
};

struct StatDataFrame {
    char    name[128];
    i32     colCount;
    i32     rowCount;
    i32     capacity;
    StatColumn* columns;        // Sütun dizisi (sütun-tabanlı!)
    char**  rowNames;           // Opsiyonel satır etiketleri
};

// ============================================================================
// FAKTÖR (Kategorik Değişken)
// ============================================================================

struct FactorLevel {
    char    label[256];
    i32     code;
    u64     frequency;
};

// ============================================================================
// C ABI FONKSİYONLARI (uXBasic'ten çağrılır)
// ============================================================================

// --- Bellek Yönetimi ---
UXSTAT_API StatDataFrame* uxb_df_create(const char* name, i32 rows, i32 cols);
UXSTAT_API void           uxb_df_free(StatDataFrame* df);
UXSTAT_API StatColumn*    uxb_col_create(StatDataFrame* df, i32 idx, 
                                         const char* name, i32 type);
UXSTAT_API void*          uxb_alloc(i64 bytes);     // Hizalı bellek
UXSTAT_API void           uxb_free(void* ptr);

// --- Veri Yükleme ---
UXSTAT_API i32 uxb_load_csv(StatDataFrame* df, const char* filename, 
                            i32 hasHeader, i32 delimiter);
UXSTAT_API i32 uxb_load_spss(StatDataFrame* df, const char* filename);

// --- Temel İstatistikler (SIMD optimize) ---
UXSTAT_API f64 uxb_col_mean(const StatColumn* col);
UXSTAT_API f64 uxb_col_std(const StatColumn* col, i32 sample);  // 1=sample, 0=pop
UXSTAT_API f64 uxb_col_var(const StatColumn* col, i32 sample);
UXSTAT_API f64 uxb_col_min(const StatColumn* col);
UXSTAT_API f64 uxb_col_max(const StatColumn* col);
UXSTAT_API f64 uxb_col_median(const StatColumn* col);
UXSTAT_API i32 uxb_col_nvalid(const StatColumn* col);

// --- Çoklu Argüman (expr1, expr2, ...) ---
UXSTAT_API f64 uxb_vec_mean(i32 n, const StatColumn** cols);  // Concatenate mean
UXSTAT_API f64 uxb_vec_weighted_mean(i32 n, const StatColumn** cols, 
                                      const f64* weights);

// --- Eksik Veri ---
UXSTAT_API i32 uxb_impute_mean(StatColumn* col);
UXSTAT_API i32 uxb_impute_median(StatColumn* col);
UXSTAT_API i32 uxb_impute_knn(StatColumn* target, const StatDataFrame* df, 
                               i32 k, const i32* predictorCols, i32 nPred);

// --- Kategorik ---
UXSTAT_API i32 uxb_factor_encode(const char** strings, i32 n, 
                                  StatColumn* outCodes, FactorLevel** outLevels);
UXSTAT_API i32 uxb_factor_nlevels(const StatColumn* col);
UXSTAT_API const char* uxb_factor_label(const StatColumn* col, i32 code);

// --- Regresyon (BLAS/LAPACK veya Eigen) ---
UXSTAT_API i32 uxb_regression_ols(const StatDataFrame* df, 
                                   i32 yCol, 
                                   const i32* xCols, i32 nX,
                                   f64* outBeta,        // Katsayılar
                                   f64* outIntercept,   // Kesim
                                   f64* outR2,          // R-kare
                                   f64* outSe,          // Standart hatalar
                                   f64* outPvalues);    // p-değerleri

UXSTAT_API i32 uxb_regression_predict(const StatDataFrame* df,
                                       const f64* beta, i32 nBeta, f64 intercept,
                                       f64* outPredicted);

// --- ANOVA ---
UXSTAT_API i32 uxb_anova_oneway(const StatDataFrame* df, i32 factorCol, i32 valueCol,
                                 f64* outF, f64* outP, f64* outEtaSq);

// --- Korelasyon ---
UXSTAT_API f64 uxb_cor_pearson(const StatColumn* x, const StatColumn* y);
UXSTAT_API f64 uxb_cor_spearman(const StatColumn* x, const StatColumn* y);

// --- Hata Yönetimi ---
UXSTAT_API const char* uxb_last_error();
UXSTAT_API void        uxb_clear_error();

// --- Debug/İnceleme ---
UXSTAT_API void uxb_df_print(const StatDataFrame* df, i32 maxRows);
UXSTAT_API void uxb_col_summary(const StatColumn* col, char* outBuffer, i32 bufSize);
```

---

### 2. C++ Implementasyon (SIMD + OpenMP)

```cpp
// uxstat_core.cpp - Çekirdek implementasyon
#include "uxstat.h"
#include <immintrin.h>      // AVX2/AVX-512
#include <omp.h>
#include <cmath>
#include <algorithm>
#include <vector>
#include <string>
#include <cstring>

// ============================================================================
// BELLEK YÖNETİMİ (Hizalı, Pool Allocator)
// ============================================================================

static thread_local struct {
    std::vector<void*> pools;
    i64 totalAllocated = 0;
} g_memStats;

void* uxb_alloc(i64 bytes) {
    // 64-byte hizalı (AVX-512 için)
    void* ptr = _aligned_malloc(bytes, 64);
    if (ptr) g_memStats.totalAllocated += bytes;
    return ptr;
}

void uxb_free(void* ptr) {
    _aligned_free(ptr);
}

// ============================================================================
// EKSİK VERİ CHECK (Inline, hızlı)
// ============================================================================

inline bool isMissing(const StatColumn* col, i32 idx) {
    if (!col->missingMask) return false;
    return (col->missingMask[idx >> 3] & (1 << (idx & 7))) != 0;
}

inline void setMissing(StatColumn* col, i32 idx, bool missing) {
    if (!col->missingMask) return;
    u8& byte = col->missingMask[idx >> 3];
    u8 bit = 1 << (idx & 7);
    if (missing) byte |= bit;
    else byte &= ~bit;
}

// ============================================================================
// TEMEL İSTATİSTİKLER (Welford - Tek Geçiş, Numerik Stabil)
// ============================================================================

f64 uxb_col_mean(const StatColumn* col) {
    if (col->statsValid) return col->cachedMean;
    
    f64 mean = 0.0;
    i64 n = 0;
    
    // SIMD için f64 veri
    if (col->type == 3 && col->length >= 8) {
        // AVX2: 4'lü paralel toplama
        __m256d sum_vec = _mm256_setzero_pd();
        i32 simdEnd = (col->length / 4) * 4;
        
        #pragma omp parallel for reduction(+:mean) reduction(+:n) schedule(static)
        for (i32 i = 0; i < simdEnd; i += 4) {
            // Eksik kontrolü (simd öncesi scalar)
            bool anyValid = false;
            for (i32 j = 0; j < 4; j++) {
                if (!isMissing(col, i + j)) {
                    anyValid = true;
                    n++;
                    f64 x = col->data.f64_data[i + j];
                    mean += (x - mean) / n;  // Welford online
                }
            }
        }
        
        // Kalanlar
        for (i32 i = simdEnd; i < col->length; i++) {
            if (!isMissing(col, i)) {
                n++;
                f64 x = col->data.f64_data[i];
                mean += (x - mean) / n;
            }
        }
    } else {
        // Scalar fallback
        for (i32 i = 0; i < col->length; i++) {
            if (!isMissing(col, i)) {
                n++;
                f64 x = (col->type == 3) ? col->data.f64_data[i] 
                                           : (f64)col->data.i32_data[i];
                mean += (x - mean) / n;
            }
        }
    }
    
    const_cast<StatColumn*>(col)->cachedMean = mean;
    const_cast<StatColumn*>(col)->statsValid = (n > 0);
    return mean;
}

// Varyans (Welford M2)
f64 uxb_col_var(const StatColumn* col, i32 sample) {
    f64 mean = 0.0, M2 = 0.0;
    i64 n = 0;
    
    for (i32 i = 0; i < col->length; i++) {
        if (isMissing(col, i)) continue;
        
        f64 x = (col->type == 3) ? col->data.f64_data[i] 
                                  : (f64)col->data.i32_data[i];
        n++;
        f64 delta = x - mean;
        mean += delta / n;
        f64 delta2 = x - mean;
        M2 += delta * delta2;
    }
    
    if (n < 2) return 0.0;
    return sample ? (M2 / (n - 1)) : (M2 / n);
}

f64 uxb_col_std(const StatColumn* col, i32 sample) {
    return std::sqrt(uxb_col_var(col, sample));
}

// ============================================================================
// REGRESYON (Eigen veya BLAS kullan - örnek Eigen)
// ============================================================================

#ifdef USE_EIGEN
#include <Eigen/Dense>

i32 uxb_regression_ols(const StatDataFrame* df, i32 yCol,
                       const i32* xCols, i32 nX,
                       f64* outBeta, f64* outIntercept,
                       f64* outR2, f64* outSe, f64* outPvalues) {
    
    i32 n = df->rowCount;
    i32 p = nX;
    
    // X matrisi (n x (p+1)) - ilk sütun 1'ler (intercept)
    Eigen::MatrixXd X(n, p + 1);
    Eigen::VectorXd y(n);
    
    // Veri doldur
    for (i32 i = 0; i < n; i++) {
        X(i, 0) = 1.0;  // Intercept
        for (i32 j = 0; j < p; j++) {
            const StatColumn* col = &df->columns[xCols[j]];
            X(i, j + 1) = isMissing(col, i) ? 0.0 : 
                          (col->type == 3 ? col->data.f64_data[i] 
                                          : (f64)col->data.i32_data[i]);
        }
        const StatColumn* yc = &df->columns[yCol];
        y(i) = isMissing(yc, i) ? 0.0 : 
               (yc->type == 3 ? yc->data.f64_data[i] 
                              : (f64)yc->data.i32_data[i]);
    }
    
    // Normal Equations: (X'X)^-1 X'y
    Eigen::MatrixXd XtX = X.transpose() * X;
    Eigen::VectorXd beta = XtX.ldlt().solve(X.transpose() * y);
    
    // Sonuçları çıkar
    *outIntercept = beta(0);
    for (i32 j = 0; j < p; j++) outBeta[j] = beta(j + 1);
    
    // R-kare
    Eigen::VectorXd yhat = X * beta;
    f64 ssRes = (y - yhat).squaredNorm();
    f64 ymean = y.mean();
    f64 ssTot = (y.array() - ymean).square().sum();
    *outR2 = 1.0 - (ssRes / ssTot);
    
    // Standart hatalar (basit)
    f64 sigma2 = ssRes / (n - p - 1);
    Eigen::MatrixXd varCov = sigma2 * XtX.inverse();
    for (i32 j = 0; j <= p; j++) {
        outSe[j] = std::sqrt(varCov(j, j));
        // t-statistic ve p-value hesaplanabilir
    }
    
    return 0;  // Başarılı
}
#endif

// ============================================================================
// KNN İMPUTASYON (Ağır hesaplama - paralel)
// ============================================================================

i32 uxb_impute_knn(StatColumn* target, const StatDataFrame* df,
                   i32 k, const i32* predictorCols, i32 nPred) {
    
    #pragma omp parallel for schedule(dynamic)
    for (i32 i = 0; i < target->length; i++) {
        if (!isMissing(target, i)) continue;  // Sadece eksikleri doldur
        
        // k-en yakın komşuları bul
        std::vector<std::pair<f64, i32>> distances;  // (mesafe, index)
        
        for (i32 j = 0; j < target->length; j++) {
            if (i == j || isMissing(target, j)) continue;
            
            f64 dist = 0.0;
            for (i32 p = 0; p < nPred; p++) {
                const StatColumn* pred = &df->columns[predictorCols[p]];
                if (isMissing(pred, i) || isMissing(pred, j)) continue;
                
                f64 di = (pred->type == 3) ? pred->data.f64_data[i] 
                                           : (f64)pred->data.i32_data[i];
                f64 dj = (pred->type == 3) ? pred->data.f64_data[j] 
                                           : (f64)pred->data.i32_data[j];
                dist += (di - dj) * (di - dj);
            }
            distances.push_back({std::sqrt(dist), j});
        }
        
        // k en küçük mesafe
        std::partial_sort(distances.begin(), 
                          distances.begin() + std::min(k, (i32)distances.size()),
                          distances.end());
        
        // Ortalama ile doldur
        f64 sum = 0.0;
        i32 count = 0;
        for (i32 kidx = 0; kidx < std::min(k, (i32)distances.size()); kidx++) {
            i32 neighbor = distances[kidx].second;
            sum += target->data.f64_data[neighbor];
            count++;
        }
        
        if (count > 0) {
            target->data.f64_data[i] = sum / count;
            setMissing(target, i, false);
        }
    }
    
    target->statsValid = false;  // Cache invalidate
    return 0;
}
```

---

### 3. uXBasic Entegrasyonu

```basic
' ============================================================
' uxstat.bas - uXBasic Wrapper Modülü
' C++ DLL'ye kolay arayüz
' ============================================================

' --- DLL Yükleme (FFI-1 ile) ---
IMPORT(C, "uxstat.dll")

' --- Temel Fonksiyon Bildirimleri ---
DECLARE FUNCTION uxb_df_create CDECL (name AS STRING, rows AS I32, cols AS I32) AS POINTER
DECLARE SUB      uxb_df_free CDECL (df AS POINTER)
DECLARE FUNCTION uxb_col_create CDECL (df AS POINTER, idx AS I32, colName AS STRING, colType AS I32) AS POINTER

DECLARE FUNCTION uxb_load_csv CDECL (df AS POINTER, filename AS STRING, hasHeader AS I32, delimiter AS I32) AS I32

DECLARE FUNCTION uxb_col_mean CDECL (col AS POINTER) AS F64
DECLARE FUNCTION uxb_col_std CDECL (col AS POINTER, sample AS I32) AS F64
DECLARE FUNCTION uxb_col_min CDECL (col AS POINTER) AS F64
DECLARE FUNCTION uxb_col_max CDECL (col AS POINTER) AS F64

DECLARE FUNCTION uxb_regression_ols CDECL (df AS POINTER, yCol AS I32, xCols AS POINTER, nX AS I32, _
                                            beta AS POINTER, intercept AS POINTER, _
                                            r2 AS POINTER, se AS POINTER, pvalues AS POINTER) AS I32

DECLARE FUNCTION uxb_last_error CDECL () AS STRING

' --- Kullanıcı Dostu Wrapper'lar ---

TYPE StatVector
    handle AS POINTER      ' C tarafı StatColumn*
    name AS STRING * 64
    n AS I32
    missingCount AS I32
END TYPE

TYPE RegressionResult
    intercept AS F64
    rSquared AS F64
    ' Dizi boyutu dinamik - sabit maksimum veya POINTER
    beta AS ARRAY(10) OF F64    ' Maksimum 10 değişken (örnek)
    se AS ARRAY(10) OF F64
    pvalue AS ARRAY(10) OF F64
END TYPE

FUNCTION VectorMean(vec AS StatVector) AS F64
    IF vec.handle = 0 THEN
        PRINT "Hata: Boş vektör"
        RETURN 0.0
    END IF
    VectorMean = uxb_col_mean(vec.handle)
END FUNCTION

FUNCTION VectorStd(vec AS StatVector, sample AS BOOLEAN) AS F64
    VectorStd = uxb_col_std(vec.handle, IIF(sample, 1, 0))
END FUNCTION

SUB LoadDataFrame(dfPtr AS POINTER, filename AS STRING, hasHeader AS BOOLEAN)
    DIM result AS I32
    result = uxb_load_csv(dfPtr, filename, IIF(hasHeader, 1, 0), 44)  ' 44 = ','
    IF result <> 0 THEN
        PRINT "Yükleme hatası: " & uxb_last_error()
    END IF
END SUB

SUB RunRegression(dfPtr AS POINTER, yCol AS I32, xCols() AS I32, nX AS I32, result AS RegressionResult)
    DIM betaPtr AS POINTER : betaPtr = VARPTR(result.beta(0))
    DIM sePtr AS POINTER : sePtr = VARPTR(result.se(0))
    DIM pvalPtr AS POINTER : pvalPtr = VARPTR(result.pvalue(0))
    DIM interceptPtr AS POINTER : interceptPtr = VARPTR(result.intercept)
    DIM r2Ptr AS POINTER : r2Ptr = VARPTR(result.rSquared)
    
    DIM ret AS I32
    ret = uxb_regression_ols(dfPtr, yCol, VARPTR(xCols(0)), nX, _
                              betaPtr, interceptPtr, r2Ptr, sePtr, pvalPtr)
    
    IF ret <> 0 THEN
        PRINT "Regresyon hatası: " & uxb_last_error()
    END IF
END SUB

' --- Kolay Kullanım Örneği ---
SUB Demo()
    ' DataFrame oluştur
    DIM df AS POINTER
    df = uxb_df_create("Hastalar", 1000, 5)  ' 1000 satır, 5 sütun
    
    ' CSV yükle
    LoadDataFrame df, "data.csv", TRUE
    
    ' İlk sütunun ortalaması
    DIM col0 AS StatVector
    col0.handle = uxb_col_create(df, 0, "Yas", 3)  ' 3 = f64
    PRINT "Yaş ortalaması: " & STR(VectorMean(col0))
    
    ' Regresyon
    DIM xCols(2) AS I32
    xCols(0) = 1    ' 2. sütun
    xCols(1) = 2    ' 3. sütun
    
    DIM regResult AS RegressionResult
    RunRegression df, 4, xCols(), 2, regResult  ' 5. sütun = Y
    
    PRINT "R-kare: " & STR(regResult.rSquared)
    PRINT "Eğim 1: " & STR(regResult.beta(0))
    
    ' Temizlik
    uxb_df_free(df)
END SUB
```

---

### 4. Derleme ve Kurulum

```powershell
# build_uxstat.ps1 - Windows 11 x64 derleme scripti

# Gereksinimler: Visual Studio 2022, CMake, vcpkg (Eigen3 için opsiyonel)

# 1. Derleme dizini
mkdir build && cd build

# 2. CMake (Eigen3 ile)
cmake .. -DCMAKE_BUILD_TYPE=Release `
         -DCMAKE_TOOLCHAIN_FILE="$env:VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" `
         -DUSE_EIGEN=ON `
         -DUSE_OPENMP=ON

# 3. Derle
cmake --build . --config Release --parallel

# 4. DLL çıktısı: build/Release/uxstat.dll
#    Lib çıktısı: build/Release/uxstat.lib (link için)

# 5. Test
ctest -C Release --output-on-failure
```

**CMakeLists.txt (özet):**
```cmake
cmake_minimum_required(VERSION 3.20)
project(uxstat VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# SIMD optimizasyonu
if(MSVC)
    add_compile_options(/arch:AVX2 /openmp /O2 /fp:precise)
else()
    add_compile_options(-mavx2 -fopenmp -O3 -ffast-math)
endif()

# Kaynaklar
add_library(uxstat SHARED 
    uxstat_core.cpp
    uxstat_io.cpp
    uxstat_regression.cpp
    uxstat_missing.cpp
)

target_compile_definitions(uxstat PRIVATE UXSTAT_EXPORTS)

# Eigen3 (opsiyonel ama önerilir)
find_package(Eigen3 CONFIG)
if(Eigen3_FOUND)
    target_link_libraries(uxstat PRIVATE Eigen3::Eigen)
    target_compile_definitions(uxstat PRIVATE USE_EIGEN)
endif()

# OpenMP
find_package(OpenMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(uxstat PRIVATE OpenMP::OpenMP_CXX)
endif()
```

---

## Karşılaştırma: C++ DLL vs Alternatifler

| Özellik | C++ DLL | C DLL | Rust DLL | Fortran DLL |
|---------|---------|-------|----------|-------------|
| **Performans** | 🟢🟢🟢 SIMD+OpenMP | 🟢🟢 Manuel SIMD zor | 🟢🟢🟢 SIMD var | 🟢🟢🟢 BLAS yerleşik |
| **uXBasic FFI** | 🟢 C ABI uyumlu | 🟢 Doğal uyum | 🟢 C ABI | 🟢 C ABI |
| **Bellek yönetimi** | 🟢 RAII + havuz | 🟡 Manuel | 🟢 Ownership | 🟡 Manuel |
| **Geliştirme hızı** | 🟡 Orta | 🟡 Orta | 🟡 Orta (öğrenme eğrisi) | 🟢 Hızlı (istatistik) |
| **Ekosistem** | 🟢🟢 Eigen, MKL, OpenCV | 🟢 Geniş | 🟢🟢 nalgebra, ndarray | 🟢🟢 LAPACK, BLAS |
| **Derleme** | 🟢 MSVC desteği | 🟢 Basit | 🟡 rustc + bindgen | 🟢 Intel/MSVC |

**Öneri:** C++17 (Eigen3 + OpenMP) veya **Intel oneMKL** ile Fortran karışımı. uXBasic Windows 11 x64 hedefinde MSVC toolchain ile sorunsuz çalışır.

Hangi yönde ilerlemek istersiniz? C++17 Eigen3 ile başlayıp, ileride BLAS/LAPACK eklemek en dengeli yol gibi görünüyor.
Evet, **tam olarak makine dili** - ama kritik ayrıntı: **x64 (64-bit) makine dili**, çünkü uXBasic Windows 11 x64 hedefinde tasarlanmış.

## Derleme Zinciri: Kaynak → Makine Dili

```
┌─────────────────────────────────────────┐
│ 1. KAYNAK KOD (İnsan okur)              │
│    uxstat.cpp (C++17)                   │
│    double uxb_col_mean(...) { ... }     │
└─────────────────────────────────────────┘
              ↓ MSVC 2022 Derleyici
┌─────────────────────────────────────────┐
│ 2. ARA KOD (Assembly - Opsiyonel)       │
│    uxstat.asm (text format)             │
│    vmovupd  ymm0, [rcx]                 │
│    vaddpd   ymm1, ymm0, ymm2            │
│    ...                                  │
└─────────────────────────────────────────┘
              ↓ Assembler (ML64)
┌─────────────────────────────────────────┐
│ 3. NESNE KODU (Makine dili - Binary)      │
│    uxstat.obj                           │
│    0000: C5 FD 10 01  (vmovupd)         │
│    0004: C5 F5 58 D0  (vaddpd)           │
│    ...                                  │
└─────────────────────────────────────────┘
              ↓ Linker (LINK)
┌─────────────────────────────────────────┐
│ 4. DLL (Bağlanmış Makine Kodu)            │
│    uxstat.dll  ←── BU DOSYA KULLANILIR  │
│                                          │
│    İçinde:                               │
│    • x64 makine kodu (C5 FD 10 01...)   │
│    • Export tablosu (fonksiyon adresleri)│
│    • Bellek yönetimi rutinleri           │
└─────────────────────────────────────────┘
```

---

## x64 Makine Kodu Örneği (Gerçek)

```cpp
// C++ Kaynak
double add(double a, double b) {
    return a + b;
}
```

```asm
; x64 Assembly (ML64)
add PROC
    movsd   xmm0, rcx       ; 1. parametre (RCX'de double)
    addsd   xmm0, xmm1      ; 2. parametre (RDX'de double) ile topla
    ret                     ; Sonuç XMM0'da döner
add ENDP
```

```hex
; Makine Kodu (Binary - DLL içinde)
F2 0F 10 C1     ; movsd xmm0, xmm1
F2 0F 58 C0     ; addsd xmm0, xmm0
C3              ; ret
```

---

## uXBasic + DLL Çalışma Anı

```
┌─────────────────────────────────────────┐
│ Windows 11 x64 İşletim Sistemi          │
│                                          │
│ uXBasic.exe (FreeBASIC)                 │
│ ├── Lexer/Parser (FB kodu)              │
│ ├── AST Evaluator (FB kodu)             │
│ └── IMPORT("uxstat.dll")                │
│     ↓ LoadLibrary("uxstat.dll")          │
│                                          │
│ uxstat.dll (Yüklenmiş Bellek Bölgesi)   │
│ ├── [0x7FFE0000] C5 FD 10 01 ...        │
│ │              ↑ AVX2 makine kodu       │
│ ├── [0x7FFE1000] 48 89 4C 24 ...        │
│ │              ↑ x64 genel kod          │
│ └── Export: uxb_col_mean @ 0x7FFE2000   │
│                                          │
│ Çağrı: CALL [0x7FFE2000]                 │
│         ↓                               │
│ İşlemci doğrudan bu adresleri çalıştırır │
└─────────────────────────────────────────┘
```

---

## x86 (32-bit) vs x64 (64-bit) Farkı

| Özellik | x86 (32-bit) | x64 (64-bit) - uXBasic |
|---------|-------------|----------------------|
| **Register** | EAX, EBX, ECX (32-bit) | **RAX, RBX, RCX, RDX (64-bit)** |
| **Parametre geçişi** | Stack | **RCX, RDX, R8, R9 (register)** |
| **Bellek** | 4GB sınır | **16EB teorik (pratik 128TB+)** |
| **SIMD** | SSE2 (128-bit) | **AVX2/AVX-512 (256/512-bit)** |
| **uXBasic hedefi** | ❌ Desteklenmiyor | ✅ **Varsayılan ve tek hedef** |

---

## Önemli: DLL Bellek Yönetimi

```
DLL Yüklenince:
┌─────────────────────────────────────────┐
│ Process Sanal Bellek Alanı              │
│                                          │
│ [0x00007FF...] uxstat.dll .text         │
│                (Makine kodu - Execute)   │
│ [0x00007FF...] uxstat.dll .data         │
│                (Global değişkenler)      │
│ [0x00007FF...] Heap (malloc)            │
│                (Dinamik veri yapıları)   │
│                                          │
│ uXBasic'ten gelen pointer'lar           │
│ buraya işaret eder                      │
└─────────────────────────────────────────┘
```

---

## Özet

| Soru | Cevap |
|------|-------|
| DLL derlenmiş mi? | ✅ **Evet**, tamamen derlenmiş |
| İçinde ne var? | **x64 makine kodu** (binary) |
| İnsan okuyabilir mi? | ❌ Hayır, sadece işlemci anlar |
| Disassembly edilebilir mi? | ✅ Evet (debugging için) |
| uXBasic hangi hedef? | **Win11 x64** (x86 desteklenmiyor) |

DLL, uXBasic'in **"gövdesi dışında ama aynı bedende"** çalışan, **doğrudan işlemci komutları** içeren bir modüldür.

Anladım. Dağıtım stratejisi ve mimari bütünlük açısından netleştirelim:

## Dağıtım Senaryoları

### Seçenek A: İstatistik DLL'si Ayrı (Önerilen)

```
┌─────────────────────────────────────────┐
│         uXBasic Dağıtım Paketi           │
│                                          │
│  📦 uXBasic Core (Zorunlu)              │
│  ├── uXBasic.exe (Derleyici/Interpreter)  │
│  ├── uxbrun.dll (Runtime - I/O, bellek)   │
│  └── Temel Fonksiyonlar (ABS, LEN, SQR)  │
│                                          │
│  📦 uXBasic Statistics (Opsiyonel)        │
│  ├── uxstat.dll (İstatistik Motoru)      │
│  ├── uxstat.bas (BASIC Wrapper)          │
│  └── Doküman + Örnekler                  │
│                                          │
│  Kullanıcı:                              │
│  IMPORT(C, "uxstat.dll")  ← Manuel      │
│  veya                                     │
│  INCLUDE "uxstat.bas"     ← Kolay yol    │
└─────────────────────────────────────────┘
```

**Avantajları:**
- Core hafif kalır (temel kullanıcılar için)
- İstatistik isteyen ayrı indirir
- Versiyon bağımsız güncellenebilir
- Başka diller de kullanabilir (R, Python, C#)

---

### Seçenek B: Her Şey Core'da (Monolitik)

```
┌─────────────────────────────────────────┐
│         uXBasic Tek Paket               │
│                                          │
│  📦 uXBasic.exe (Büyük)                 │
│  ├── Lexer/Parser/AST                    │
│  ├── Runtime (I/O, Bellek, Timer)       │
│  ├── Temel Fonksiyonlar                  │
│  ├── İSTATİSTİKSEL FONKSİYONLAR          │
│  │   ├── MEAN, STD, VAR (built-in)       │
│  │   ├── REGRESSION (built-in)          │
│  │   └── ANOVA, TTEST (built-in)         │
│  └── Veri Yapıları (built-in)            │
│      ├── STATVECTOR                      │
│      ├── STATFACTOR                      │
│      └── DATAFRAME                       │
└─────────────────────────────────────────┘
```

**Dezavantajları:**
- Core şişer (MB başına)
- İstatistik hatası = tüm derleyici riski
- Güncelleme tüm paket
- Başka dil kullanamaz

---

## Önerilen Hibrit Mimari (En İyi İkisi)

```
┌─────────────────────────────────────────┐
│         uXBasic Core v2.0                │
│                                          │
│  📦 Zorunlu (Hafif ~2MB)                │
│  ├── Derleyici (Lexer/Parser/Codegen)    │
│  ├── Runtime (I/O, Bellek, Timer)        │
│  └── Temel Fonksiyonlar (50+ intrinsic)  │
│      ABS, SIN, COS, LEN, VAL, STR...     │
│                                          │
│  📦 Standard Library (Opsiyonel ~1MB)    │
│  ├── String işlemleri (gelişmiş)         │
│  ├── Dosya/CSV parser                    │
│  └── Math extensions                     │
│                                          │
│  📦 Professional Pack (Opsiyonel ~5MB)   │
│  ├── uxstat.dll ← BURADA                 │
│  │   ├── Tüm 131 istatistik fonksiyonu   │
│  │   ├── Veri yapıları (columnar)         │
│  │   ├── SIMD optimizasyonu               │
│  │   └── BLAS/LAPACK entegrasyonu         │
│  ├── uxstat.bas (wrapper)                │
│  └── Örnek veri setleri + Kitapçık       │
└─────────────────────────────────────────┘
```

---

## Fonksiyon Dağılımı Matrisi

| Fonksiyon Kategorisi | Yer | Neden |
|---------------------|-----|-------|
| **ABS, SQR, SIN, COS** | **Core** | Temel matematik, herkes kullanır |
| **LEN, STR, VAL** | **Core** | String manipülasyonu, temel dil |
| **MEAN, STD basit** | **Core** | Temel aggregation (dizi üzerinde) |
| **REGRESSION, ANOVA** | **uxstat.dll** | Ağır hesaplama, profesyonel kullanım |
| **TTEST, CHISQUARE** | **uxstat.dll** | İstatistiksel testler, uzman alanı |
| **DataFrame, Factor** | **uxstat.dll** | Karmaşık veri yapısı, bellek yönetimi |
| **KNN Imputation** | **uxstat.dll** | Makine öğrenimi, ağır algoritma |
| **SIMD/AVX kodu** | **uxstat.dll** | Platform spesifik optimizasyon |

---

## Senin Baştaki 131 Fonksiyon için Öneri

### Core'a Eklenecek (Basit, Sık Kullanılan ~20 fonksiyon):

```basic
' Core intrinsic - her zaman var
FUNCTION MEAN(arr() AS F64, n AS I32) AS F64     ' Basit dizi ortalaması
FUNCTION STD(arr() AS F64, n AS I32) AS F64      ' Basit standart sapma
FUNCTION MIN(arr() AS F64, n AS I32) AS F64      ' Dizi minimum
FUNCTION MAX(arr() AS F64, n AS I32) AS F64      ' Dizi maksimum
FUNCTION SUM(arr() AS F64, n AS I32) AS F64      ' Toplam
FUNCTION NVALID(arr() AS F64, n AS I32) AS I32   ' Geçerli eleman sayısı
```

### uxstat.dll'de Olacak (Gelişmiş ~111 fonksiyon):

```basic
' uxstat.dll - IMPORT gerektirir
' 15 Temel İstatistik (weighted, median, mode, IQR...)
' 5 Normallik Testi (Shapiro, Anderson...)
' 8 T-Test çeşidi
' 10 ANOVA çeşidi
' 7 Chi-Square
' 12 Korelasyon
' 20 Regresyon (ridge, lasso, elastic net...)
' 15 Non-parametrik
' 8 Güven Aralığı
' 7 Güç Analizi
' 10 Dağılım Testi
' 6 Outlier Detection
' 8 Diğer (bootstrap, cross-validation...)
```

---

## Veri Yapısı Dağılımı

| Yapı | Yer | Açıklama |
|------|-----|----------|
| `ARRAY` | **Core** | Temel dizi, zaten var |
| `TYPE` | **Core** | Kullanıcı tanımlı yapı, zaten var |
| `STATVECTOR` | **uxstat.dll** | Columnar + eksik veri + metadata |
| `STATFACTOR` | **uxstat.dll** | Kategorik + seviyeler + encoding |
| `STATCOLUMN` | **uxstat.dll** | Çoklu tip (numeric/factor) |
| `STATDATAFRAME` | **uxstat.dll** | Çoklu sütun, CSV/SPSS entegrasyonu |

---

## Özet Tavsiye

```
┌─────────────────────────────────────────┐
│  DAĞITIM STRATEJİSİ                     │
│                                          │
│  Core (Zorunlu):                         │
│  • Temel dil + Basit matematik            │
│  • ~2MB, hızlı indirme                    │
│                                          │
│  uxstat.dll (Opsiyonel):                 │
│  • 131 istatistik fonksiyonu              │
│  • Profesyonel veri yapıları               │
│  • ~5MB, ayrı indirme/kurulum             │
│  • Başka dillerle paylaşılabilir          │
│                                          │
│  Kullanıcı deneyimi:                     │
│  "İstatistik yapmak için uxstat'ı         │
│   indirin ve IMPORT(C, "uxstat.dll")      │
│   yazın"                                  │
└─────────────────────────────────────────┘
```

Bu strateji ile:
- **Hafif kullanıcı** (oyun, embedded): Sadece core
- **Veri analisti**: Core + uxstat
- **Araştırmacı**: Core + uxstat + dokümanlar

Hangi yolda ilerleyelim? Ayrı DLL (önerilen) mi, yoksa monolitik mi?
Evet, harika bir strateji! İstatistiksel DataFrame'i DLL içine koymak ve Python'un CPython API'sini kullanmak mümkün. İşte detaylı mimari:

## Hibrit DLL Mimarisi: C++ + CPython

```
┌─────────────────────────────────────────┐
│         uXBasic Dağıtım Paketi          │
│                                          │
│  📦 uXBasic Core (FreeBASIC)             │
│  ├── Derleyici + Temel Runtime           │
│  └── IMPORT(C) + CALL(DLL) desteği       │
│                                          │
│  📦 uxstat.dll (C++17 + CPython)         │
│  │                                        │
│  │  Katman 1: C++ Çekirdek (Hızlı)        │
│  │  ├── Columnar DataFrame (Apache Arrow) │
│  │  ├── SIMD İstatistik (AVX2/512)        │
│  │  ├── Bellek Havuzu (Pool Allocator)    │
│  │  └── Zero-Copy CPython Bridge          │
│  │                                        │
│  │  Katman 2: CPython Entegrasyonu         │
│  │  ├── Python GIL Yönetimi                │
│  │  ├── PyObject ↔ C++ Dönüşümü           │
│  │  ├── NumPy Array Borrowing              │
│  │  ├── pandas.DataFrame Zero-Copy         │
│  │  └── SciPy/StatsModels Wrapper          │
│  │                                        │
│  │  Katman 3: uXBasic Arayüzü              │
│  │  ├── C ABI Export Fonksiyonları        │
│  │  └── StatVector/DataFrame Handles       │
│                                          │
│  📦 Python Runtime (Opsiyonel)            │
│  └── python311.dll (CPython)              │
│                                          │
└─────────────────────────────────────────┘
```

---

## CPython ile C++ DLL Entegrasyonu

### 1. CPython API Kullanımı (C++)

```cpp
// uxstat_python.h - CPython Entegrasyon Katmanı

#pragma once

#include <Python.h>
#include <numpy/arrayobject.h>
#include <pandas/pandas.h>  // pybind11 veya C API

#include "uxstat_core.h"

// CPython GIL Yöneticisi (RAII)
class PythonGIL {
    PyGILState_STATE state;
public:
    PythonGIL() { state = PyGILState_Ensure(); }
    ~PythonGIL() { PyGILState_Release(state); }
};

// Zero-Copy NumPy Array → C++ Column
class NumPyBridge {
public:
    // NumPy array'den C++ StatColumn'a zero-copy borrow
    static StatColumn* FromNumPy(PyObject* numpyArray) {
        if (!PyArray_Check(numpyArray)) return nullptr;
        
        PyArrayObject* arr = (PyArrayObject*)numpyArray;
        
        StatColumn* col = new StatColumn();
        col->type = PyArray_TYPE(arr) == NPY_FLOAT64 ? 3 : 2;
        col->length = (i32)PyArray_SIZE(arr);
        col->data.f64_data = (f64*)PyArray_DATA(arr);  // Zero-copy!
        col->missingMask = nullptr;  // NumPy NaN handling
        
        // NumPy array lifetime management
        Py_INCREF(numpyArray);  // Hold reference
        col->_pythonRef = numpyArray;  // Store for later release
        
        return col;
    }
    
    // C++ StatColumn → NumPy array (zero-copy where possible)
    static PyObject* ToNumPy(const StatColumn* col) {
        npy_intp dims[1] = { col->length };
        
        int typenum = (col->type == 3) ? NPY_FLOAT64 : NPY_FLOAT32;
        PyObject* arr = PyArray_SimpleNewFromData(
            1, dims, typenum, col->data.f64_data
        );
        
        // C++ tarafı belleği yönetiyorsa, capsule ekle
        if (col->_ownedByCpp) {
            PyArray_SetBaseObject((PyArrayObject*)arr, 
                PyCapsule_New(col, "uxstat", nullptr));
        }
        
        return arr;
    }
};

// pandas DataFrame Bridge
class PandasBridge {
public:
    // pandas.DataFrame → C++ StatDataFrame (zero-copy columns)
    static StatDataFrame* FromDataFrame(PyObject* pandasDF) {
        PythonGIL gil;  // GIL acquire
        
        StatDataFrame* df = new StatDataFrame();
        
        // columns = df.columns.tolist()
        PyObject* columns = PyObject_GetAttrString(pandasDF, "columns");
        PyObject* colList = PyObject_CallMethod(columns, "tolist", nullptr);
        
        // Her sütun için
        Py_ssize_t nCols = PyList_Size(colList);
        df->colCount = (i32)nCols;
        df->columns = new StatColumn[nCols];
        
        for (Py_ssize_t i = 0; i < nCols; i++) {
            PyObject* colName = PyList_GetItem(colList, i);
            PyObject* colData = PyObject_GetItem(pandasDF, colName);
            
            // Sütun verisini NumPy olarak al
            PyObject* numpyCol = PyObject_CallMethod(colData, "to_numpy", nullptr);
            
            df->columns[i] = *NumPyBridge::FromNumPy(numpyCol);
            strncpy(df->columns[i].name, 
                   PyUnicode_AsUTF8(colName), 63);
            
            Py_DECREF(numpyCol);
            Py_DECREF(colData);
        }
        
        Py_DECREF(colList);
        Py_DECREF(columns);
        
        return df;
    }
    
    // C++ StatDataFrame → pandas.DataFrame
    static PyObject* ToDataFrame(const StatDataFrame* df) {
        PythonGIL gil;
        
        // import pandas as pd
        PyObject* pandas = PyImport_ImportModule("pandas");
        PyObject* pd_dict = PyModule_GetDict(pandas);
        PyObject* DataFrame = PyDict_GetItemString(pd_dict, "DataFrame");
        
        // dict = {}
        PyObject* dataDict = PyDict_New();
        
        for (i32 i = 0; i < df->colCount; i++) {
            PyObject* colArr = NumPyBridge::ToNumPy(&df->columns[i]);
            PyObject* name = PyUnicode_FromString(df->columns[i].name);
            
            PyDict_SetItem(dataDict, name, colArr);
            
            Py_DECREF(colArr);
            Py_DECREF(name);
        }
        
        // pd.DataFrame(data)
        PyObject* dfObj = PyObject_CallFunctionObjArgs(DataFrame, dataDict, nullptr);
        
        Py_DECREF(dataDict);
        Py_DECREF(pandas);
        
        return dfObj;
    }
};
```

---

### 2. Python İstatistik Kütüphanelerini Kullanma

```cpp
// uxstat_scipy.cpp - SciPy/StatsModels Wrapper

#include "uxstat_python.h"

// SciPy.stats kullanarak normallik testi
extern "C" UXSTAT_API i32 uxb_py_shapiro(const StatColumn* col, 
                                          f64* outW, f64* outP) {
    PythonGIL gil;
    
    // NumPy array oluştur
    PyObject* npData = NumPyBridge::ToNumPy(col);
    
    // from scipy import stats
    PyObject* scipy = PyImport_ImportModule("scipy.stats");
    PyObject* shapiro = PyObject_GetAttrString(scipy, "shapiro");
    
    // stats.shapiro(data)
    PyObject* result = PyObject_CallFunctionObjArgs(shapiro, npData, nullptr);
    
    // Sonuçları çıkar (tuple: (W, p-value))
    *outW = PyFloat_AsDouble(PyTuple_GetItem(result, 0));
    *outP = PyFloat_AsDouble(PyTuple_GetItem(result, 1));
    
    Py_DECREF(result);
    Py_DECREF(shapiro);
    Py_DECREF(scipy);
    Py_DECREF(npData);
    
    return 0;
}

// StatsModels OLS regresyon
extern "C" UXSTAT_API i32 uxb_py_regression_ols(
    const StatDataFrame* df,
    i32 yCol,
    const i32* xCols, i32 nX,
    f64* outBeta,
    f64* outPvalues,
    f64* outR2,
    f64* outAIC
) {
    PythonGIL gil;
    
    // pandas DataFrame oluştur
    PyObject* pandasDF = PandasBridge::ToDataFrame(df);
    
    // import statsmodels.api as sm
    PyObject* sm = PyImport_ImportModule("statsmodels.api");
    
    // Formula: y ~ x1 + x2 + ...
    char formula[256];
    snprintf(formula, sizeof(formula), "%s ~ ", df->columns[yCol].name);
    for (i32 i = 0; i < nX; i++) {
        if (i > 0) strcat(formula, " + ");
        strcat(formula, df->columns[xCols[i]].name);
    }
    
    // smf.ols(formula, data=df).fit()
    PyObject* ols = PyObject_CallMethod(sm, "ols", "sO", formula, pandasDF);
    PyObject* fit = PyObject_CallMethod(ols, "fit", nullptr);
    
    // Sonuçlar
    PyObject* params = PyObject_GetAttrString(fit, "params");
    PyObject* pvalues = PyObject_GetAttrString(fit, "pvalues");
    PyObject* rsquared = PyObject_GetAttrString(fit, "rsquared");
    PyObject* aic = PyObject_GetAttrString(fit, "aic");
    
    // Array'lere dönüştür
    for (i32 i = 0; i <= nX; i++) {  // +1 for intercept
        PyObject* key = PyLong_FromLong(i);
        outBeta[i] = PyFloat_AsDouble(PyObject_GetItem(params, key));
        outPvalues[i] = PyFloat_AsDouble(PyObject_GetItem(pvalues, key));
        Py_DECREF(key);
    }
    
    *outR2 = PyFloat_AsDouble(rsquared);
    *outAIC = PyFloat_AsDouble(aic);
    
    // Cleanup
    Py_DECREF(params); Py_DECREF(pvalues);
    Py_DECREF(rsquared); Py_DECREF(aic);
    Py_DECREF(fit); Py_DECREF(ols);
    Py_DECREF(pandasDF); Py_DECREF(sm);
    
    return 0;
}

// scikit-learn KNN imputasyon
extern "C" UXSTAT_API i32 uxb_py_impute_knn(
    StatDataFrame* df,
    i32 targetCol,
    const i32* predictorCols, i32 nPred,
    i32 k
) {
    PythonGIL gil;
    
    PyObject* pandasDF = PandasBridge::ToDataFrame(df);
    
    // from sklearn.impute import KNNImputer
    PyObject* sklearn = PyImport_ImportModule("sklearn.impute");
    PyObject* KNNImputer = PyObject_GetAttrString(sklearn, "KNNImputer");
    
    // KNNImputer(n_neighbors=k)
    PyObject* imputer = PyObject_CallFunction(KNNImputer, "i", k);
    
    // fit_transform
    PyObject* result = PyObject_CallMethod(imputer, "fit_transform", "O", pandasDF);
    
    // Sonuçları geri yaz (zero-copy mümkünse)
    // ...
    
    Py_DECREF(result);
    Py_DECREF(imputer);
    Py_DECREF(KNNImputer);
    Py_DECREF(sklearn);
    Py_DECREF(pandasDF);
    
    return 0;
}
```

---

### 3. uXBasic Arayüzü (C ABI)

```cpp
// uxstat_uxbasic.cpp - uXBasic için C ABI wrapper

extern "C" {
    // Python runtime init/shutdown
    UXSTAT_API i32 uxb_py_initialize(const char* pythonHome);
    UXSTAT_API void uxb_py_finalize();
    
    // DataFrame yönetimi
    UXSTAT_API StatDataFrame* uxb_df_from_csv(const char* filename);
    UXSTAT_API StatDataFrame* uxb_df_from_pandas(const char* pickleFile);
    
    // Hibrit: C++ hızlı, Python zengin
    UXSTAT_API f64 uxb_mean(const StatColumn* col);  // C++ SIMD
    UXSTAT_API i32 uxb_shapiro(const StatColumn* col, f64* w, f64* p);  // Python SciPy
    
    // Gelişmiş regresyon
    UXSTAT_API i32 uxb_regression(
        const StatDataFrame* df,
        const char* formula,  // "y ~ x1 + x2 + x3"
        f64* coef,
        f64* se,
        f64* pval,
        i32* usePython  // 0=C++ only, 1=Python fallback
    );
}
```

---

### 4. uXBasic Kullanımı

```basic
' ============================================================
' uXBasic + Python İstatistik Kütüphaneleri
' ============================================================

' --- Python Runtime Başlat ---
IMPORT(C, "uxstat.dll")

DECLARE FUNCTION uxb_py_initialize CDECL (pythonHome AS STRING) AS I32
DECLARE FUNCTION uxb_py_finalize CDECL () AS VOID

' Python'u başlat (kurulu Python dizini)
uxb_py_initialize("C:\Python311")

' --- DataFrame Oluştur ---
TYPE StatDataFrame
    handle AS POINTER
    nRow AS I32
    nCol AS I32
END TYPE

DECLARE FUNCTION uxb_df_from_csv CDECL (filename AS STRING) AS POINTER

DIM df AS StatDataFrame
df.handle = uxb_df_from_csv("C:\data\hastalar.csv")
df.nRow = 1000
df.nCol = 5

' --- Hibrit İstatistik ---
DECLARE FUNCTION uxb_mean CDECL (colHandle AS POINTER) AS F64
DECLARE FUNCTION uxb_shapiro CDECL (colHandle AS POINTER, w AS POINTER, p AS POINTER) AS I32

' Sütun handle'ı al
DIM yasCol AS POINTER  ' C++ tarafından yönetilen

' Hızlı C++ hesaplama
PRINT "Ortalama yaş: " & STR(uxb_mean(yasCol))

' Python SciPy kullanarak normallik testi
DIM w AS F64, p AS F64
uxb_shapiro yasCol, VARPTR(w), VARPTR(p)
PRINT "Shapiro-Wilk p-değeri: " & STR(p)

' --- StatsModels Regresyon ---
DECLARE FUNCTION uxb_py_regression_ols CDECL (dfHandle AS POINTER, _
    yColIdx AS I32, xCols AS POINTER, nX AS I32, _
    beta AS POINTER, pval AS POINTER, r2 AS POINTER, aic AS POINTER) AS I32

DIM xCols(2) AS I32
xCols(0) = 1  ' Cinsiyet
xCols(1) = 2  ' Gelir

DIM beta(3) AS F64   ' Intercept + 2 değişken
DIM pval(3) AS F64
DIM r2 AS F64, aic AS F64

uxb_py_regression_ols df.handle, 4, VARPTR(xCols(0)), 2, _
    VARPTR(beta(0)), VARPTR(pval(0)), VARPTR(r2), VARPTR(aic)

PRINT "R-kare: " & STR(r2)
PRINT "Gelir katsayısı: " & STR(beta(2)) & " (p=" & STR(pval(2)) & ")"

' --- Temizlik ---
uxb_py_finalize()
```

---

## Derleme ve Dağıtım

```powershell
# build_uxstat_hybrid.ps1

# 1. C++ Çekirdek (SIMD, Columnar)
cl.exe /c /O2 /arch:AVX2 /openmp uxstat_core.cpp

# 2. CPython Entegrasyonu
# Python geliştirme headers gereklidir
cl.exe /c /O2 /I"C:\Python311\include" uxstat_python.cpp
cl.exe /c /O2 /I"C:\Python311\include" uxstat_scipy.cpp

# 3. NumPy entegrasyonu
cl.exe /c /O2 /I"C:\Python311\Lib\site-packages\numpy\core\include" uxstat_numpy.cpp

# 4. Link
link.exe /DLL /OUT:uxstat.dll ^
    uxstat_core.obj uxstat_python.obj uxstat_scipy.obj uxstat_numpy.obj ^
    /LIBPATH:"C:\Python311\libs" python311.lib

# 5. Dağıtım paketi
# 📦 uxstat.dll (Ana kütüphane)
# 📦 uxstat_python311.dll (Python runtime bağımlılığı - opsiyonel)
# 📦 README: "Python entegrasyonu için Python 3.11+ kurulu olmalı"
```

---

## Mimari Karşılaştırma

| Özellik | Saf C++ DLL | C++ + CPython Hibrit |
|---------|------------|---------------------|
| **Hız** | 🟢🟢🟢 En hızlı | 🟢🟢 C++ çekirdek hızlı, Python overhead var |
| **Fonksiyon zenginliği** | 🟡 Sınırlı (kendi kodun) | 🟢🟢🟢 SciPy, StatsModels, sklearn |
| **Bakım** | 🟡 Her algoritmayı sen yaz | 🟢 Python ekosistemi bakar |
| **Dağıtım boyutu** | 🟢 Küçük (~2MB) | 🟡 Orta (~5MB + Python gereksinimi) |
| **Kurulum** | 🟢 Tek DLL | 🟡 Python runtime gerekli |
| **Güncelleme** | Manuel | Python paketleri otomatik |
| **uXBasic entegrasyonu** | 🟢🟢 C ABI, sorunsuz | 🟢🟢 Aynı C ABI |

---

## Önerilen Strateji: "İki DLL"

```
┌─────────────────────────────────────────┐
│         Dağıtım Paketi                  │
│                                          │
│  📦 uxstat_core.dll (Zorunlu)            │
│  ├── C++17 Columnar DataFrame            │
│  ├── SIMD İstatistik (131 fonksiyon)     │
│  ├── Bellek yönetimi                     │
│  └── Zero-copy Python bridge hazır       │
│  (~3MB, tek başına çalışır)              │
│                                          │
│  📦 uxstat_python.dll (Opsiyonel)         │
│  ├── CPython API entegrasyonu            │
│  ├── SciPy/StatsModels wrapper           │
│  ├── sklearn bridge                      │
│  └── pandas zero-copy                    │
│  (~2MB, Python kuruluysa çalışır)        │
│                                          │
│  Kullanıcı:                              │
│  • Sadece core: IMPORT(C, "uxstat_core") │
│  • Python zengin: IMPORT(C, "uxstat_python") 
│    (otomatik core'u da yükler)           │
└─────────────────────────────────────────┘
```

Bu yapı ile:
- **Hafif kullanıcı**: Sadece C++ core, hızlı, bağımsız
- **Gelişmiş kullanıcı**: Python eklentisi, tüm ekosistem
- **Gelecek**: Rust, Julia, R entegrasyonları aynı mimariyle eklenebilir

Hangi yönde ilerleyelim? Saf C++ mı, hibrit mi, yoksa iki DLL mi?

Anladım. Dokümanları inceledim. Önceki planım ile bu yeni dokümanlar **büyük ölçüde aynı yönde** ama bazı **kritik farklar** var. İşte karşılaştırma ve detaylı açıklama:

---

## Karşılaştırma: Önceki Plan vs Yeni Dokümanlar

| Konu | Önceki Planım | Yeni Dokümanlar | Durum |
|------|---------------|-----------------|-------|
| **MODULE içinde FFI** | ✅ Önerdim | ✅ **Zorunlu** karar | Aynı |
| **%%INCLUDE alias** | ✅ Önerdim | ✅ **Kesin** kural | Aynı |
| **CALL(DLL) policy** | ✅ Önerdim | ✅ **Normatif** kural | Aynı |
| **IMPORT(PY)** | Runtime/embed önerdim | **Build-time tool** önerisi | Farklı |
| **Signature DSL** | Önerdim, detaylı | Daha **kesin BNF** | Gelişmiş |
| **STRING encoding** | Belirtmemiştim | **UTF-8 norm** önerisi | Yeni |
| **%%FEATURE flag** | Yok | **Yeni öneri** | Eklenti |

---

## Temel ve Detaylı Açıklamalar (Türkçe + Teknik Terimler)

### 1. **MODULE** ... **END MODULE** (Konteyner / Konteynır)

| Türkçe | İngilizce/Kısaltma | Açıklama |
|--------|-------------------|----------|
| **Amaç** | Purpose | FFI/Interop işlemlerini **tek çatı altında** toplamak |
| **Zorunluluk** | Mandatory | `IMPORT`, `CALL(DLL)`, `ALIAS` **sadece** MODULE içinde |
| **Güvenlik** | Security Container | Policy kontrolü, audit log, build manifest burada merkezi |
| **Kapsam** | Scope | MODULE dışı FFI kullanımı → **semantik hata** (derleme hatası) |

**Örnek:**
```basic
MODULE IstatistikMotoru
  IMPORT(C, "uxstat.c")
  CALL(DLL, "uxstat.dll", "uxb_col_mean", ...)
END MODULE
```

---

### 2. **FFI** (Foreign Function Interface / Dış Fonksiyon Arayüzü)

| Türkçe | İngilizce/Kısaltma | Açıklama |
|--------|-------------------|----------|
| **Amaç** | Purpose | uXBasic'ten **C/C++/ASM/Python** kodu çağırmak |
| **Risk** | Risk Level | **Yüksek** (güvenlik, bellek, stabilite) |
| **Kontrol** | Policy Enforcement | Allowlist (izin listesi) zorunlu |
| **Modlar** | Modes | `REPORT_ONLY` (logla) / `ENFORCE` (engelle) |

---

### 3. **CALL(DLL, ...)** (DLL Çağrısı)

| Bileşen | Türkçe | Teknik Terim |
|---------|--------|--------------|
| `"kütüphane"` | DLL adı | Library Name |
| `"sembol"` | Fonksiyon adı | Symbol/Entry Point |
| `imza` | Parametre/dönüş tipi | **Signature DSL** |
| `argümanlar` | Gönderilen değerler | Arguments |

**Signature DSL (Domain Specific Language / Özel Alan Dili):**

```
"U64()"           → Dönüş: U64, Parametre: yok
"I32(I32,I32)"    → Dönüş: I32, Parametre: 2×I32
"F64(PTR)"        → Dönüş: F64, Parametre: pointer
"VOID(STRPTR)"    → Dönüş: yok, Parametre: string pointer
```

**Tip Kodları:**
| Kod | Türkçe | İngilizce | Boyut |
|-----|--------|-----------|-------|
| `I32` | 32-bit işaretli tam sayı | Signed 32-bit Integer | 4 byte |
| `U32` | 32-bit işaretsiz tam sayı | Unsigned 32-bit Integer | 4 byte |
| `I64` | 64-bit işaretli tam sayı | Signed 64-bit Integer | 8 byte |
| `U64` | 64-bit işaretsiz tam sayı | Unsigned 64-bit Integer | 8 byte |
| `F64` | 64-bit kayan nokta | Double Precision Float | 8 byte |
| `PTR` | Bellek adresi | Pointer | 8 byte (x64) |
| `STRPTR` | String adresi | String Pointer | 8 byte |
| `WSTRPTR` | Geniş karakter string | Wide String Pointer | 8 byte |
| `BYREF` | Referans ile aktarım | Pass by Reference | - |

---

### 4. **IMPORT(LANG, "dosya")** (Dış Kaynak Ekleme)

| Dil | Türkçe Açıklama | Build Aşaması |
|-----|-----------------|---------------|
| `C` | C kaynak kodu | Derle + Link |
| `CPP` | C++ kaynak kodu | Derle + Link (extern "C" zorunlu) |
| `ASM` | Assembly kodu | Derle + Link |
| `PY` | **Python build-time aracı** | Çalıştır, çıktı üret |

**Önemli Fark:** `IMPORT(PY)` için iki mod vardı:
- **Önceki planım:** Runtime embed (EXE yanında Python çalıştır)
- **Yeni doküman:** **Build-time tool** (derleme sırasında çalışır, `.c`/`.bas` üretir)

**Build-time tool önerisi daha uygun** çünkü:
- Tek başına EXE hedefi korunur
- Python runtime dağıtımı gerekmez
- Güvenlik/determinizm daha kolay

---

### 5. **ALIAS** (Takma Ad / Eşleme)

| Türkçe | İngilizce | Kural |
|--------|-----------|-------|
| **Amaç** | Purpose | Uzun adları kısaltmak, tekrarı azaltmak |
| **Zincir** | Chain | Max **4 adım** |
| **Döngü** | Cycle | **Yasak** (hata) |
| **FFI alias** | FFI Target | Sadece **allowlist'te kayıtlı** hedeflere |

**Örnek:**
```basic
ALIAS OrtalamaHesapla = CALL(DLL, "uxstat.dll", "uxb_col_mean", "F64(PTR,I32)")
' Kullanım:
sonuc = OrtalamaHesapla(veriPtr, 100)
```

---

### 6. **Policy / İzin Listesi** (Güvenlik Kuralları)

| Durum | Kod | Türkçe Açıklama |
|-------|-----|-----------------|
| İzin verildi | - | `allow` loglanır |
| Attestation eksik | 9210 | Doğrulama bilgisi yok |
| Hash uyuşmazlığı | 9211 | Dosya değişmiş |
| İmza uyuşmazlığı | 9212 | Güvenilir değil |
| Hash çıkarılamadı | 9213 | Teknik hata |
| İmza çıkarılamadı | 9214 | Teknik hata |
| Policy dosyası bozuk | 9215 | Fail-closed (güvenli mod) |

---

### 7. **NAMESPACE** ... **END NAMESPACE** (İsim Alanı)

| Türkçe | İngilizce | Açıklama |
|--------|-----------|----------|
| **Amaç** | Purpose | Büyük projelerde **isim çakışmasını** önlemek |
| **Zaman** | Time | Sadece **derleme zamanı** (runtime etkisi yok) |
| **İçinde olamaz** | Cannot Contain | `MAIN` bloğu NAMESPACE içinde **yasak** |
| **Çözümleme** | Resolution | `NamespaceName.Sembol` şeklinde erişim |

---

### 8. **MAIN** ... **END MAIN** (Giriş Noktası)

| Türkçe | İngilizce | Kural |
|--------|-----------|-------|
| **Tek olmalı** | Single Entry | Programda **en fazla 1** adet |
| **Soft keyword** | Soft Keyword | `SUB Main()` gibi isimleri **kırmaz** |
| **Üst düzey kod** | Top-level Code | MAIN varsa, dışarıda çalıştırılabilir kod **yasak** |

---

### 9. **Preprocess / Ön İşlemci** (`%%` komutları)

| Komut | Türkçe | Açıklama |
|-------|--------|----------|
| `%%INCLUDE` | Dosya dahil et | `INCLUDE` ile **aynı** (alias) |
| `%%IF/%%ELSE/%%ENDIF` | Koşullu derleme | Derleme zamanı koşulu |
| `%%PLATFORM` | Hedef platform | `win11_x64` gibi |
| `%%FEATURE` | Özellik bayrağı | `ON/OFF` ile riskli özellikleri aç/kapat |
| `%%FFI_POLICY` | FFI politikası | `REPORT_ONLY` veya `ENFORCE` |

---

### 10. **STRING Encoding / Karakter Kodlaması**

| Öneri | Kodlama | Açıklama |
|-------|---------|----------|
| **uXBasic içinde** | UTF-8 | Determinizm, tooling kolaylığı |
| `STRPTR` | UTF-8 `char*` | C API'ye gönderim |
| `WSTRPTR` | UTF-16LE `wchar_t*` | Windows "W" API'leri için |

---

## Özet Tablo: Tüm Kavramlar

| Türkçe | İngilizce/Kısaltma | Kısa Açıklama |
|--------|-------------------|---------------|
| **Modül** | MODULE | FFI işlemlerinin konteyneri |
| **İsim alanı** | NAMESPACE | Derleme zamanı isim çözümleme |
| **Giriş noktası** | MAIN | Program başlangıcı |
| **Dış fonksiyon çağrısı** | CALL(DLL) | DLL'deki kodu çalıştırma |
| **Dış kaynak ekleme** | IMPORT | C/ASM/PY dosyasını build'e ekle |
| **Takma ad** | ALIAS | Uzun adı kısaltma |
| **İmza dili** | Signature DSL | Parametre/dönüş tipi tanımı |
| **İzin listesi** | Allowlist/Policy | Güvenli DLL çağrısı kontrolü |
| **Ön işlemci** | Preprocess | Derlemeden önce metin işleme |
| **Sütun-tabanlı veri** | Columnar Storage | Veriyi sütun sütun saklama |
| **Sıfır kopya** | Zero-Copy | Bellek kopyalamadan erişim |

---

## Sonuç: Hangi Yol?

| Senaryo | Öneri |
|---------|-------|
| **Hemen başla** | C++ `uxstat.dll` (saf C++, Python'sız) |
| **Python kütüphaneleri şart** | `IMPORT(PY)` **build-time tool** modunda |
| **En temiz, en hızlı** | C++17 + Eigen3/BLAS, zero-copy NumPy bridge sonradan |

Yeni dokümanlar **MODULE zorunluluğu**, **build-time Python**, ve **UTF-8 encoding** konularında daha kesin. Bu kurallara uyarak ilerlemek en sağlamı.

Hangi yolda ilerleyelim?
Anladım. Teknik terimlerden arındırılmış, sade ve net bir özet:

---

## Baştan Beri Konuşulanların Özeti

### 1. Ne Yapmak İstiyoruz?

uXBasic'e **istatistik özellikleri** eklemek istiyorsun. Yani kullanıcılar:
- Veri dosyalarını okusun (CSV, Excel)
- Ortalama, standart sapma hesaplasın
- Regresyon, ANOVA gibi testler yapsın
- Eksik verileri doldursun
- Kategorik verileri sayılara çevirsin

### 2. Neden Dışarıda Bir Çözüm?

uXBasic'in kendi içinde bu kadar karmaşık hesaplamalar yapması **zor**. Neden?
- İstatistik algoritmaları çok sayıda ve karmaşık
- Hızlı çalışması için özel işlemci komutları gerek (SIMD)
- Başka kütüphaneleri kullanmak ekonomik (tekerleği yeniden icat etme)

**Çözüm:** Hazır kütüphaneleri uXBasic'e bağlayacağız.

---

### 3. Bağlama Yöntemleri (Nasıl?)

| Yöntem | Açıklama | Avantaj | Dezavantaj |
|--------|----------|---------|------------|
| **DLL** | Ayrı bir dosya, çalışırken yüklenir | Hafif, güncellenebilir | Bağımsız dosya yönetimi |
| **Gömülü** | Derleyicinin içine katılır | Tek paket | Derleyici şişer, hata riski yüksek |

**Karar:** DLL olarak yapacağız. Ama **güvenli** şekilde.

---

### 4. Güvenlik Nasıl Sağlanacak?

DLL çağırma riskli (virüs, çökme). Çözüm:

```
MODULE Istatistik  ← Sadece burada DLL kullanılabilir
  CALL(DLL, "uxstat.dll", ...)
END MODULE
```

Dışarıda kullanım **yasak**. Ayrıca:
- İzin listesi (hangi DLL, hangi fonksiyon)
- Log tutma (ne çağrıldı, ne zaman)
- Hata kodları (bir şey yanlış giderse neden)

---

### 5. Python Konusu

İlk başta "Python'u gömelim mi?" dedik. Ama iki seçenek var:

| Seçenek | Ne Zaman Çalışır | Sonuç |
|---------|------------------|-------|
| **Runtime** | Program çalışırken | EXE yanında Python gerekir, dağıtım zor |
| **Build-time** | Derleme sırasında | Python sadece senin makinanda, kullanıcıya yansımaz |

**Karar:** Build-time kullanacağız. Python scriptleri derleme sırasında çalışır, C/BASIC kodu üretir.

---

### 6. Veri Yapısı Nasıl Olacak?

Excel/SPSS gibi **tablo** yapısı:
- Satırlar = gözlemler (hasta 1, hasta 2...)
- Sütunlar = değişkenler (yaş, cinsiyet, tansiyon...)

**Teknik detay:** Veriyi satır satır değil, **sütun sütun** saklayacağız. Neden?
- Hızlı hesaplama (yaş sütununun ortalaması = ardışık bellek okuma)
- Eksik veri yönetimi kolay
- İşlemci özel komutlarıyla optimize

---

### 7. Son Durum: Hangi Yol?

| Senaryo | Yol | Neden |
|---------|-----|-------|
| **Hemen başla** | Saf C++ DLL | Python karmaşası yok, kontrol sende |
| **Python şart** | Build-time tool | Kullanıcı hissetmez, sen geliştirirken kullanırsın |
| **En iyi** | C++17 + hazır matematik kütüphaneleri | En hızlı, en temiz, endüstri standardı |

---

## Önerim: Üç Aşamalı Plan

### Aşama 1: Temel DLL (Hemen başla)
- C++ ile basit istatistik fonksiyonları
- Ortalama, standart sapma, minimum, maksimum
- CSV okuma
- uXBasic'ten çağrılabilir

### Aşama 2: Gelişmiş Özellikler
- Regresyon, ANOVA
- Eksik veri doldurma
- Kategorik değişkenler

### Aşama 3: İsteğe Bağlı Python
- Sadece senin geliştirme ortamında
- Karmaşık algoritmalar için Python scriptleri
- Build-time çalışır, kullanıcıya yansımaz

---

## Net Kararınız Nedir?

1. **Hemen başla** mı istiyorsun? → C++ DLL, temel fonksiyonlar
2. **Python kullanmak şart** mı? → Build-time tool modu
3. **En hızlı/en profesyonel** mi? → C++17 + Eigen/BLAS kütüphaneleri

Hangi öncelik sizin için daha önemli?
Anladım. Haklısınız. 6. adımdaki kararları tekrar sorgulamak yerine, **neden bu kararları aldığımızı** ve **bundan sonra ne yapacağımızı** netleştirelim.

---

## Kararları Neden Aldık? (Gerekçeler)

| Karar | Neden? | Amaç |
|-------|--------|------|
| **DLL olarak yapmak** | uXBasic derleyicisini bozmak istemiyoruz | İstatistik kodu ayrı, bağımsız gelişir |
| **MODULE içinde FFI** | Güvenlik | DLL çağrıları kontrollü, loglanabilir |
| **Build-time Python** | Kullanıcıya Python yükletmek istemiyoruz | Sadece geliştirici (sen) kullanır, kullanıcı hissetmez |
| **Sütun-tabanlı veri** | Hız | Excel/SPSS/R gibi profesyonel araçlar böyle yapıyor |
| **C++17** | Performans ve kontrol | Python'dan hızlı, C'den daha kolay yazılır |

**Temel motivasyon:** uXBasic'i **büyütmeden**, **yavaşlatmadan**, **risk almadan** istatistik özelliği eklemek.

---

## Bundan Sonra Ne Yapacağız? (Somut Adımlar)

### Adım 1: C++ DLL İskeleti (Bugün başlanabilir)

**Dosyalar:**
```
uxstat/
├── uxstat.h          (Arayüz tanımları)
├── uxstat_core.cpp   (Temel fonksiyonlar)
├── uxstat_io.cpp     (CSV okuma/yazma)
└── CMakeLists.txt    (Derleme scripti)
```

**İçindekiler:**
- Veri yapısı: Basit sütun dizisi
- 5 temel fonksiyon: ortalama, standart sapma, min, max, sayı
- CSV okuma: Virgülle ayrılmış dosyadan veri alma

### Adım 2: uXBasic Bağlantısı

**Dosya:** `uxstat.bas` (wrapper)

```basic
MODULE Istatistik
  IMPORT(C, "uxstat.cpp")  ' veya derlenmiş .obj
  
  ' C fonksiyonlarını BASIC'e uyarla
  FUNCTION Ortalama(dizi() AS F64, n AS I32) AS F64
    ' C fonksiyonunu çağır
  END FUNCTION
END MODULE
```

### Adım 3: Test ve Kullanım

```basic
INCLUDE "uxstat.bas"

DIM yas(100) AS F64
' ... veri yükle ...

PRINT Ortalama(yas(), 100)
```

---

## Python Konusu Netleşmesi

| Durum | Açıklama |
|-------|----------|
| **Şimdi** | Python **yok**. Saf C++ ile başla. |
| **İleride** | Karmaşık algoritma lazımsa (örn: makine öğrenmesi), **o zaman** `IMPORT(PY)` build-time eklenir. |
| **Neden ertelendi?** | Başlangıçta basit tutmak, karmaşıklığı sonraya bırakmak. |

---

## Özet: Yol Haritası

```
BUGÜN ───────► HAFTALAR İÇİNDE ───────► AYLAR İÇİNDE
     │              │                    │
     ▼              ▼                    ▼
 C++ DLL      Gelişmiş fonksiyonlar    Python (gerekirse)
 iskeleti     (regresyon, ANOVA)        build-time olarak
     │              │                    │
     └──────────────┴────────────────────┘
                    │
                    ▼
            Kullanıcı deneyimi:
            "INCLUDE istatistik.bas"
            "DIM veri AS DATAFRAME"
            "PRINT Regresyon(veri)"
```

---

## Tek Soru Kaldı

**Şimdi başlamak için hazır mısınız?**

Evet derseniz:
1. C++ DLL iskeletini yazayım
2. İlk 5 fonksiyonu (ortalama, standart sapma, vb.) ekleyeyim
3. uXBasic wrapper'ını hazırlayayım

Başlayalım mı?
Anladım. VS Code'da çalışan bir yapay zeka/yardımcı için **A'dan Z'ye eksiksiz bir plan** hazırlıyorum. Bu plan, tüm detaylarıyla uygulanabilir olmalı.

---

# uXBasic İstatistik Modülü - Eksiksiz Uygulama Planı

## 1. PROJE YAPISI (Klasör Hiyerarşisi)

```
uxbasic-stat/
├── docs/                          # Dokümantasyon
│   ├── api-reference.md           # Fonksiyon referansı
│   ├── architecture.md            # Mimari açıklama
│   └── examples/                  # Kullanım örnekleri
│       ├── basic-stats.bas
│       ├── regression.bas
│       └── dataframe-demo.bas
│
├── src/                           # Kaynak kodlar
│   ├── cpp/                       # C++ DLL kaynağı
│   │   ├── include/
│   │   │   ├── uxstat.h           # Ana başlık
│   │   │   ├── uxstat_core.h      # Temel yapılar
│   │   │   ├── uxstat_math.h      # Matematik fonksiyonları
│   │   │   ├── uxstat_io.h        # Giriş/çıkış
│   │   │   └── uxstat_advanced.h  # Gelişmiş istatistik
│   │   │
│   │   ├── core/
│   │   │   ├── uxstat_memory.cpp  # Bellek yönetimi
│   │   │   ├── uxstat_vector.cpp  # Vektör işlemleri
│   │   │   ├── uxstat_dataframe.cpp # DataFrame yapısı
│   │   │   └── uxstat_missing.cpp # Eksik veri yönetimi
│   │   │
│   │   ├── math/
│   │   │   ├── uxstat_basic.cpp   # Temel istatistik
│   │   │   ├── uxstat_regression.cpp # Regresyon
│   │   │   ├── uxstat_tests.cpp   # Hipotez testleri
│   │   │   └── uxstat_dist.cpp    # Dağılım fonksiyonları
│   │   │
│   │   ├── io/
│   │   │   ├── uxstat_csv.cpp     # CSV okuma/yazma
│   │   │   ├── uxstat_json.cpp    # JSON desteği (opsiyonel)
│   │   │   └── uxstat_spss.cpp    # SPSS .sav (opsiyonel)
│   │   │
│   │   ├── bridge/
│   │   │   └── uxstat_uxbasic.cpp # uXBasic C ABI arayüzü
│   │   │
│   │   └── CMakeLists.txt         # CMake yapı dosyası
│   │
│   └── bas/                       # BASIC wrapper ve örnekler
│       ├── uxstat.bas             # Ana modül dosyası
│       ├── uxstat_types.bas       # Tip tanımları
│       ├── uxstat_basic.bas       # Temel fonksiyonlar
│       ├── uxstat_advanced.bas    # Gelişmiş fonksiyonlar
│       └── uxstat_examples.bas    # Kullanım örnekleri
│
├── tests/                         # Test dosyaları
│   ├── cpp/                       # C++ unit testleri
│   ├── bas/                       # BASIC test programları
│   └── data/                      # Test verileri
│       ├── sample.csv
│       ├── sample_small.csv
│       └── sample_large.csv
│
├── build/                         # Derleme çıktıları (gitignore)
│   ├── Debug/
│   └── Release/
│
├── tools/                         # Yardımcı araçlar
│   ├── generate_bas_wrappers.py   # BASIC wrapper üreteci
│   └── validate_dll.py            # DLL doğrulama
│
├── LICENSE                        # Lisans
├── README.md                      # Proje açıklaması
└── build.ps1                      # Windows derleme scripti
```

---

## 2. C++ DLL DETAYLI TASARIMI

### 2.1 Temel Veri Yapıları (uxstat_core.h)

```cpp
// ============================================================================
// UXSTAT CORE - Temel Veri Yapıları
// Windows 11 x64, C++17
// ============================================================================

#pragma once

#ifdef UXSTAT_EXPORTS
#define UXSTAT_API extern "C" __declspec(dllexport)
#else
#define UXSTAT_API extern "C" __declspec(dllimport)
#endif

#include <cstdint>
#include <cstddef>

// ============================================================================
// TEMEL TİPLER (uXBasic ile uyumlu)
// ============================================================================

using i8  = int8_t;    using u8  = uint8_t;
using i16 = int16_t;   using u16 = uint16_t;
using i32 = int32_t;   using u32 = uint32_t;
using i64 = int64_t;   using u64 = uint64_t;
using f32 = float;     using f64 = double;

// ============================================================================
// EKSİK VERİ YÖNETİMİ
// ============================================================================

enum class MissingType : i32 {
    NONE     = 0,   // Eksik veri yok
    NAN_F64  = 1,   // IEEE 754 NaN (f64 için)
    SENTINEL = 2,   // Özel değer (-9999 gibi)
    BITMASK  = 3    // Bit maskesi (en esnek)
};

// ============================================================================
// STATISTİKSEL VEKTÖR (Tek değişken - sütun)
// ============================================================================

struct StatVector {
    // Metadata
    char    name[64];           // Değişken adı
    i32     type;               // 0=i32, 1=i64, 2=f32, 3=f64
    i32     length;             // Eleman sayısı
    i32     capacity;           // Ayrılmış kapasite
    
    // Veri
    union {
        i32*  i32_data;
        i64*  i64_data;
        f32*  f32_data;
        f64*  f64_data;
    } data;
    
    // Eksik veri
    MissingType missingType;
    u8*         missingMask;    // BITMASK kullanıldığında
    i32         missingCount;
    f64         sentinelValue;  // SENTINEL kullanıldığında
    
    // Önbellek (lazy evaluation)
    f64     cachedMean;
    f64     cachedStd;
    f64     cachedMin;
    f64     cachedMax;
    bool    cacheValid;
};

// ============================================================================
// KATEGORİK DEĞİŞKEN (Faktör)
// ============================================================================

struct FactorLevel {
    char    label[256];         // Etiket ("Erkek", "Kadın")
    i32     code;               // Sayısal kod (0, 1, 2...)
    u64     frequency;          // Frekans
};

struct StatFactor {
    char        name[64];
    i32         length;
    i32*        codes;          // Her gözlem için kod
    i32         levelCount;
    FactorLevel* levels;        // Seviye tanımları
    bool        isOrdered;      // Sıralı mı? (ordinal)
    
    // Eksik veri
    u8*         missingMask;
    i32         missingCount;
};

// ============================================================================
// DATAFRAME (Çoklu sütun)
// ============================================================================

enum class ColumnType : i32 {
    NUMERIC = 0,    // Sayısal (i32, i64, f32, f64)
    FACTOR  = 1,    // Kategorik
    STRING  = 2,    // Metin (sabit uzunluk)
    DATE    = 3     // Tarih (Unix timestamp)
};

struct StatColumn {
    char        name[64];
    ColumnType  type;
    i32         index;          // Sütun indeksi
    
    // Union: Ya sayısal ya kategorik
    union {
        StatVector  vector;
        StatFactor  factor;
    } data;
    
    // Metadata
    char        label[256];     // Açıklama
    char        format[32];       // Gösterim formatı
};

struct StatDataFrame {
    char        name[128];
    i32         rowCount;
    i32         colCount;
    i32         capacity;
    StatColumn* columns;
    
    // Satır etiketleri (opsiyonel)
    char**      rowNames;
    
    // Genel metadata
    char        sourceFile[256];  // Kaynak dosya
    char        created[32];      // Oluşturma zamanı
    char        modified[32];     // Son değişiklik
};
```

### 2.2 C ABI Fonksiyonları (uxstat.h - uXBasic'e açılan arayüz)

```cpp
// ============================================================================
// UXBASIC C ABI - uXBasic'ten Çağrılabilir Fonksiyonlar
// ============================================================================

// ============================================================================
// BELLEK YÖNETİMİ
// ============================================================================

UXSTAT_API void*  uxb_alloc(i64 bytes);           // Hizalı bellek ayır
UXSTAT_API void   uxb_free(void* ptr);             // Bellek serbest bırak
UXSTAT_API void   uxb_memcpy(void* dst, const void* src, i64 bytes);
UXSTAT_API void   uxb_memset(void* dst, i32 value, i64 bytes);

// ============================================================================
// STATVECTOR YÖNETİMİ
// ============================================================================

UXSTAT_API StatVector*  uxb_vec_create(const char* name, i32 type, i32 capacity);
UXSTAT_API void         uxb_vec_destroy(StatVector* vec);
UXSTAT_API i32          uxb_vec_resize(StatVector* vec, i32 newSize);
UXSTAT_API i32          uxb_vec_set(StatVector* vec, i32 index, f64 value);
UXSTAT_API f64          uxb_vec_get(const StatVector* vec, i32 index);
UXSTAT_API i32          uxb_vec_set_missing(StatVector* vec, i32 index, bool missing);
UXSTAT_API bool         uxb_vec_is_missing(const StatVector* vec, i32 index);

// ============================================================================
// TEMEL İSTATİSTİKLER (131 fonksiyondan ilk 15)
// ============================================================================

// 1-15: Temel İstatistikler
UXSTAT_API f64  uxb_stat_mean(const StatVector* vec);
UXSTAT_API f64  uxb_stat_median(const StatVector* vec);
UXSTAT_API f64  uxb_stat_mode(const StatVector* vec);           // En sık değer
UXSTAT_API f64  uxb_stat_std(const StatVector* vec, i32 sample); // 1=örnek, 0=populasyon
UXSTAT_API f64  uxb_stat_var(const StatVector* vec, i32 sample);
UXSTAT_API f64  uxb_stat_range(const StatVector* vec);          // max - min
UXSTAT_API f64  uxb_stat_iqr(const StatVector* vec);            // Interquartile range
UXSTAT_API f64  uxb_stat_min(const StatVector* vec);
UXSTAT_API f64  uxb_stat_max(const StatVector* vec);
UXSTAT_API f64  uxb_stat_sum(const StatVector* vec);
UXSTAT_API i32  uxb_stat_n(const StatVector* vec);              // Toplam gözlem
UXSTAT_API i32  uxb_stat_nvalid(const StatVector* vec);          // Eksik olmayan
UXSTAT_API f64  uxb_stat_skewness(const StatVector* vec);       // Çarpıklık
UXSTAT_API f64  uxb_stat_kurtosis(const StatVector* vec);        // Basıklık
UXSTAT_API f64  uxb_stat_cv(const StatVector* vec);              // Varyasyon katsayısı

// Çoklu argüman desteği (expr1, expr2, ...)
UXSTAT_API f64  uxb_stat_mean_multi(i32 n, const StatVector** vecs);
UXSTAT_API f64  uxb_stat_pooled_std(i32 n, const StatVector** vecs);

// ============================================================================
// EKSİK VERİ YÖNETİMİ
// ============================================================================

UXSTAT_API i32  uxb_missing_list(const StatVector* vec, i32* outIndices, i32 maxCount);
UXSTAT_API f64  uxb_missing_percent(const StatVector* vec);
UXSTAT_API i32  uxb_impute_mean(StatVector* vec);
UXSTAT_API i32  uxb_impute_median(StatVector* vec);
UXSTAT_API i32  uxb_impute_mode(StatVector* vec);
UXSTAT_API i32  uxb_impute_constant(StatVector* vec, f64 value);
UXSTAT_API i32  uxb_impute_forward(StatVector* vec);  // LOCF
UXSTAT_API i32  uxb_impute_backward(StatVector* vec); // NOCB

// ============================================================================
// DATAFRAME YÖNETİMİ
// ============================================================================

UXSTAT_API StatDataFrame* uxb_df_create(const char* name, i32 rows, i32 cols);
UXSTAT_API void           uxb_df_destroy(StatDataFrame* df);
UXSTAT_API StatColumn*    uxb_df_add_col(StatDataFrame* df, i32 index, 
                                          const char* name, i32 type);
UXSTAT_API StatVector*    uxb_df_get_vec(StatDataFrame* df, i32 colIndex);
UXSTAT_API i32            uxb_df_get_row(const StatDataFrame* df, i32 rowIndex,
                                          f64* outValues, i32 maxCols);
UXSTAT_API i32            uxb_df_set_row(StatDataFrame* df, i32 rowIndex,
                                          const f64* values, i32 nValues);

// ============================================================================
// DOSYA G/Ç
// ============================================================================

UXSTAT_API i32  uxb_load_csv(StatDataFrame* df, const char* filename,
                               i32 hasHeader, char delimiter);
UXSTAT_API i32  uxb_save_csv(const StatDataFrame* df, const char* filename,
                               i32 writeHeader, char delimiter);
UXSTAT_API i32  uxb_load_spss(StatDataFrame* df, const char* filename);  // Opsiyonel

// ============================================================================
// KATEGORİK DEĞİŞKENLER
// ============================================================================

UXSTAT_API StatFactor*  uxb_factor_create(const char* name, i32 length);
UXSTAT_API void         uxb_factor_destroy(StatFactor* fac);
UXSTAT_API i32          uxb_factor_encode(StatFactor* fac, 
                                          const char** labels, i32 nLabels);
UXSTAT_API i32          uxb_factor_nlevels(const StatFactor* fac);
UXSTAT_API const char*  uxb_factor_label(const StatFactor* fac, i32 code);
UXSTAT_API i32          uxb_factor_recode(StatFactor* fac, 
                                           const i32* oldCodes, 
                                           const i32* newCodes, i32 nCodes);

// ============================================================================
// KORELASYON VE REGRESYON
// ============================================================================

UXSTAT_API f64  uxb_cor_pearson(const StatVector* x, const StatVector* y);
UXSTAT_API f64  uxb_cor_spearman(const StatVector* x, const StatVector* y);
UXSTAT_API f64  uxb_cor_kendall(const StatVector* x, const StatVector* y);

// Basit lineer regresyon: y = a + bx
UXSTAT_API i32  uxb_regress_simple(const StatVector* x, const StatVector* y,
                                    f64* outA, f64* outB, 
                                    f64* outR2, f64* outSeA, f64* outSeB);

// Çoklu regresyon (en fazla 10 değişken - MVP sınırı)
UXSTAT_API i32  uxb_regress_ols(const StatDataFrame* df,
                                  i32 yCol, const i32* xCols, i32 nX,
                                  f64* outBeta, f64* outIntercept,
                                  f64* outR2, f64* outAdjR2,
                                  f64* outSe, f64* outT, f64* outP);

// ============================================================================
// HİPOTEZ TESTLERİ
// ============================================================================

// T-testler
UXSTAT_API i32  uxb_ttest_one_sample(const StatVector* sample, f64 mu0,
                                      f64* outT, f64* outP, f64* outCiLower, f64* outCiUpper);
UXSTAT_API i32  uxb_ttest_independent(const StatVector* group1, const StatVector* group2,
                                       f64* outT, f64* outP);
UXSTAT_API i32  uxb_ttest_paired(const StatVector* before, const StatVector* after,
                                  f64* outT, f64* outP);

// ANOVA
UXSTAT_API i32  uxb_anova_one_way(const StatDataFrame* df, i32 factorCol, i32 valueCol,
                                   f64* outF, f64* outP, f64* outEtaSq);

// Chi-square
UXSTAT_API i32  uxb_chisquare_test(const StatFactor* observed, const StatFactor* expected,
                                    f64* outChi2, f64* outP, i32* outDf);

// ============================================================================
// HATA YÖNETİMİ
// ============================================================================

UXSTAT_API const char*  uxb_last_error();
UXSTAT_API void           uxb_clear_error();
UXSTAT_API i32            uxb_get_last_error_code();
```

---

## 3. BASIC WRAPPER TASARIMI

### 3.1 Tip Tanımları (uxstat_types.bas)

```basic
' ============================================================================
' UXSTAT TİP TANIMLARI - uXBasic İstatistik Modülü
' ============================================================================

' Vektör handle'ı (C tarafı pointer)
TYPE StatVectorHandle
    ptr AS POINTER      ' C tarafı StatVector*
    name AS STRING * 64
    length AS I32
    type AS I32         ' 0=i32, 1=i64, 2=f32, 3=f64
END TYPE

' Faktör handle'ı
TYPE StatFactorHandle
    ptr AS POINTER
    name AS STRING * 64
    nLevels AS I32
END TYPE

' DataFrame handle'ı
TYPE StatDataFrameHandle
    ptr AS POINTER
    name AS STRING * 128
    nRow AS I32
    nCol AS I32
END TYPE

' Regresyon sonuçları
TYPE RegressionResult
    success AS BOOLEAN
    intercept AS F64
    rSquared AS F64
    adjRSquared AS F64
    ' Dizi boyutu dinamik - sabit maksimum
    beta AS ARRAY(10) OF F64
    stdError AS ARRAY(10) OF F64
    tValue AS ARRAY(10) OF F64
    pValue AS ARRAY(10) OF F64
    errorMsg AS STRING * 256
END TYPE

' T-test sonuçları
TYPE TTestResult
    success AS BOOLEAN
    tStatistic AS F64
    pValue AS F64
    ciLower AS F64      ' Güven aralığı alt sınır
    ciUpper AS F64      ' Güven aralığı üst sınır
    df AS I32           ' Serbestlik derecesi
END TYPE

' ANOVA sonuçları
TYPE ANOVAResult
    success AS BOOLEAN
    fStatistic AS F64
    pValue AS F64
    etaSquared AS F64   ' Etki büyüklüğü
    dfBetween AS I32
    dfWithin AS I32
END TYPE
```

### 3.2 Ana Modül (uxstat.bas)

```basic
' ============================================================================
' UXSTAT - uXBasic İstatistik Modülü
' 
' Kullanım:
'   INCLUDE "uxstat.bas"
'   
'   DIM veri AS StatVectorHandle
'   VecCreate veri, "Yaş", 3, 100   ' 3=f64, 100 kapasite
'   ' ... veri yükle ...
'   PRINT VecMean(veri)
' ============================================================================

MODULE UxStatModule
    ' DLL yükleme ve fonksiyon bildirimleri
    IMPORT(C, "uxstat.dll")
    
    ' ------------------------------------------------------------------------
    ' C FONKSİYON BİLDİRİMLERİ
    ' ------------------------------------------------------------------------
    
    ' Bellek
    DECLARE FUNCTION uxb_alloc CDECL (bytes AS I64) AS POINTER
    DECLARE SUB      uxb_free CDECL (ptr AS POINTER)
    
    ' Vektör yönetimi
    DECLARE FUNCTION uxb_vec_create CDECL (name AS STRING, type AS I32, _
                                           capacity AS I32) AS POINTER
    DECLARE SUB      uxb_vec_destroy CDECL (vec AS POINTER)
    DECLARE FUNCTION uxb_vec_set CDECL (vec AS POINTER, idx AS I32, _
                                        val AS F64) AS I32
    DECLARE FUNCTION uxb_vec_get CDECL (vec AS POINTER, idx AS I32) AS F64
    
    ' Temel istatistikler
    DECLARE FUNCTION uxb_stat_mean CDECL (vec AS POINTER) AS F64
    DECLARE FUNCTION uxb_stat_median CDECL (vec AS POINTER) AS F64
    DECLARE FUNCTION uxb_stat_std CDECL (vec AS POINTER, sample AS I32) AS F64
    DECLARE FUNCTION uxb_stat_var CDECL (vec AS POINTER, sample AS I32) AS F64
    DECLARE FUNCTION uxb_stat_min CDECL (vec AS POINTER) AS F64
    DECLARE FUNCTION uxb_stat_max CDECL (vec AS POINTER) AS F64
    DECLARE FUNCTION uxb_stat_sum CDECL (vec AS POINTER) AS F64
    DECLARE FUNCTION uxb_stat_nvalid CDECL (vec AS POINTER) AS I32
    
    ' Eksik veri
    DECLARE FUNCTION uxb_impute_mean CDECL (vec AS POINTER) AS I32
    DECLARE FUNCTION uxb_impute_median CDECL (vec AS POINTER) AS I32
    
    ' DataFrame
    DECLARE FUNCTION uxb_df_create CDECL (name AS STRING, rows AS I32, _
                                          cols AS I32) AS POINTER
    DECLARE SUB      uxb_df_destroy CDECL (df AS POINTER)
    DECLARE FUNCTION uxb_load_csv CDECL (df AS POINTER, filename AS STRING, _
                                         hasHeader AS I32, delimiter AS I32) AS I32
    
    ' Korelasyon ve regresyon
    DECLARE FUNCTION uxb_cor_pearson CDECL (x AS POINTER, y AS POINTER) AS F64
    DECLARE FUNCTION uxb_regress_simple CDECL (x AS POINTER, y AS POINTER, _
                                               a AS POINTER, b AS POINTER, _
                                               r2 AS POINTER, seA AS POINTER, _
                                               seB AS POINTER) AS I32
    
    ' Hata yönetimi
    DECLARE FUNCTION uxb_last_error CDECL () AS STRING
    
END MODULE

' ------------------------------------------------------------------------
' KULLANICI DOSTU WRAPPER FONKSİYONLARI
' ------------------------------------------------------------------------

' Vektör oluşturma
SUB VecCreate(BYREF vec AS StatVectorHandle, name AS STRING, type AS I32, capacity AS I32)
    vec.ptr = uxb_vec_create(name, type, capacity)
    vec.name = name
    vec.type = type
    vec.length = 0
END SUB

SUB VecDestroy(BYREF vec AS StatVectorHandle)
    IF vec.ptr <> 0 THEN
        CALL CDECL uxb_vec_destroy(vec.ptr)
        vec.ptr = 0
    END IF
END SUB

FUNCTION VecSet(BYREF vec AS StatVectorHandle, idx AS I32, val AS F64) AS I32
    VecSet = uxb_vec_set(vec.ptr, idx, val)
    IF idx >= vec.length THEN vec.length = idx + 1
END FUNCTION

FUNCTION VecGet(BYREF vec AS StatVectorHandle, idx AS I32) AS F64
    VecGet = uxb_vec_get(vec.ptr, idx)
END FUNCTION

' Temel istatistikler
FUNCTION VecMean(BYREF vec AS StatVectorHandle) AS F64
    VecMean = uxb_stat_mean(vec.ptr)
END FUNCTION

FUNCTION VecMedian(BYREF vec AS StatVectorHandle) AS F64
    VecMedian = uxb_stat_median(vec.ptr)
END FUNCTION

FUNCTION VecStd(BYREF vec AS StatVectorHandle, sample AS BOOLEAN) AS F64
    VecStd = uxb_stat_std(vec.ptr, IIF(sample, 1, 0))
END FUNCTION

FUNCTION VecVar(BYREF vec AS StatVectorHandle, sample AS BOOLEAN) AS F64
    VecVar = uxb_stat_var(vec.ptr, IIF(sample, 1, 0))
END FUNCTION

FUNCTION VecMin(BYREF vec AS StatVectorHandle) AS F64
    VecMin = uxb_stat_min(vec.ptr)
END FUNCTION

FUNCTION VecMax(BYREF vec AS StatVectorHandle) AS F64
    VecMax = uxb_stat_max(vec.ptr)
END FUNCTION

FUNCTION VecSum(BYREF vec AS StatVectorHandle) AS F64
    VecSum = uxb_stat_sum(vec.ptr)
END FUNCTION

FUNCTION VecNValid(BYREF vec AS StatVectorHandle) AS I32
    VecNValid = uxb_stat_nvalid(vec.ptr)
END FUNCTION

' Eksik veri doldurma
SUB VecImputeMean(BYREF vec AS StatVectorHandle)
    CALL CDECL uxb_impute_mean(vec.ptr)
END SUB

SUB VecImputeMedian(BYREF vec AS StatVectorHandle)
    CALL CDECL uxb_impute_median(vec.ptr)
END SUB

' DataFrame
SUB DfCreate(BYREF df AS StatDataFrameHandle, name AS STRING, rows AS I32, cols AS I32)
    df.ptr = uxb_df_create(name, rows, cols)
    df.name = name
    df.nRow = rows
    df.nCol = cols
END SUB

SUB DfDestroy(BYREF df AS StatDataFrameHandle)
    IF df.ptr <> 0 THEN
        CALL CDECL uxb_df_destroy(df.ptr)
        df.ptr = 0
    END IF
END SUB

FUNCTION DfLoadCsv(BYREF df AS StatDataFrameHandle, filename AS STRING, _
                   hasHeader AS BOOLEAN, delimiter AS STRING) AS I32
    DIM delimCode AS I32
    delimCode = ASC(delimiter)  ' Virgül = 44, Noktalı virgül = 59, Tab = 9
    DfLoadCsv = uxb_load_csv(df.ptr, filename, IIF(hasHeader, 1, 0), delimCode)
END FUNCTION

' Korelasyon
FUNCTION CorPearson(BYREF x AS StatVectorHandle, BYREF y AS StatVectorHandle) AS F64
    CorPearson = uxb_cor_pearson(x.ptr, y.ptr)
END FUNCTION

' Basit regresyon
SUB RegressSimple(BYREF x AS StatVectorHandle, BYREF y AS StatVectorHandle, _
                  BYREF result AS RegressionResult)
    DIM a AS F64, b AS F64, r2 AS F64, seA AS F64, seB AS F64
    DIM ret AS I32
    
    ret = uxb_regress_simple(x.ptr, y.ptr, VARPTR(a), VARPTR(b), _
                              VARPTR(r2), VARPTR(seA), VARPTR(seB))
    
    result.success = (ret = 0)
    result.intercept = a
    result.beta(0) = b
    result.rSquared = r2
    result.stdError(0) = seB
    
    IF ret <> 0 THEN
        result.errorMsg = uxb_last_error()
    END IF
END SUB

' Hata mesajı
FUNCTION StatLastError() AS STRING
    StatLastError = uxb_last_error()
END FUNCTION
```

---

## 4. DERLEME VE KURULUM

### 4.1 CMakeLists.txt (C++ DLL için)

```cmake
cmake_minimum_required(VERSION 3.20)
project(uxstat VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Windows 11 x64 hedefi
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR AMD64)

# MSVC optimizasyonları
if(MSVC)
    add_compile_options(/arch:AVX2 /openmp /O2 /fp:precise /W4)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
else()
    add_compile_options(-mavx2 -fopenmp -O3 -ffast-math -Wall -Wextra)
endif()

# Kaynak dosyalar
set(UXSTAT_SOURCES
    src/core/uxstat_memory.cpp
    src/core/uxstat_vector.cpp
    src/core/uxstat_dataframe.cpp
    src/core/uxstat_missing.cpp
    src/math/uxstat_basic.cpp
    src/math/uxstat_regression.cpp
    src/math/uxstat_tests.cpp
    src/io/uxstat_csv.cpp
    src/bridge/uxstat_uxbasic.cpp
)

# DLL oluştur
add_library(uxstat SHARED ${UXSTAT_SOURCES})

target_include_directories(uxstat PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/include
)

# Export tanımları
target_compile_definitions(uxstat PRIVATE UXSTAT_EXPORTS)

# OpenMP
find_package(OpenMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(uxstat PUBLIC OpenMP::OpenMP_CXX)
endif()

# Install
install(TARGETS uxstat
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(FILES src/include/uxstat.h DESTINATION include)
```

### 4.2 PowerShell Derleme Scripti (build.ps1)

```powershell
# uXBasic İstatistik Modülü Derleme Scripti
# Gereksinimler: Visual Studio 2022, CMake 3.20+

param(
    [ValidateSet("Debug", "Release")]
    [string]$Config = "Release",
    
    [switch]$Clean,
    [switch]$Install,
    [string]$InstallPath = "C:\uXBasic\lib"
)

$ErrorActionPreference = "Stop"

Write-Host "uXBasic İstatistik Modülü Derleyici" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Temizleme
if ($Clean -and (Test-Path "build")) {
    Write-Host "Build dizini temizleniyor..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "build"
}

# Build dizini
New-Item -ItemType Directory -Force -Path "build" | Out-Null
Set-Location "build"

# CMake yapılandırma
Write-Host "CMake yapılandırması..." -ForegroundColor Green
cmake .. -G "Visual Studio 17 2022" -A x64 `
    -DCMAKE_BUILD_TYPE=$Config `
    -DCMAKE_INSTALL_PREFIX=$InstallPath

# Derleme
Write-Host "Derleme ($Config)..." -ForegroundColor Green
cmake --build . --config $Config --parallel

# Test
Write-Host "Testler çalıştırılıyor..." -ForegroundColor Green
ctest -C $Config --output-on-failure

# Kurulum
if ($Install) {
    Write-Host "Kurulum: $InstallPath" -ForegroundColor Green
    cmake --install . --config $Config
}

Write-Host "`nTamamlandı!" -ForegroundColor Cyan
Write-Host "DLL konumu: build/$Config/uxstat.dll" -ForegroundColor White

Set-Location ..
```

---

## 5. KULLANIM ÖRNEKLERİ

### 5.1 Temel İstatistik (basic-stats.bas)

```basic
' ============================================================================
' TEMEL İSTATİSTİK ÖRNEĞİ
' ============================================================================

INCLUDE "uxstat.bas"

MAIN
    ' Vektör oluştur
    DIM yas AS StatVectorHandle
    VecCreate yas, "Yaş", 3, 100   ' 3 = f64, 100 kapasite
    
    ' Veri ekle
    VecSet yas, 0, 25.0
    VecSet yas, 1, 30.0
    VecSet yas, 2, 35.0
    VecSet yas, 3, 40.0
    VecSet yas, 4, 28.0
    yas.length = 5
    
    ' İstatistikler
    PRINT "Yaş Dağılımı:"
    PRINT "  Ortalama: " & STR(VecMean(yas))
    PRINT "  Medyan:   " & STR(VecMedian(yas))
    PRINT "  Std Sapma:" & STR(VecStd(yas, TRUE))   ' TRUE = örnek
    PRINT "  Minimum:  " & STR(VecMin(yas))
    PRINT "  Maksimum: " & STR(VecMax(yas))
    PRINT "  Toplam:   " & STR(VecSum(yas))
    PRINT "  Geçerli N:" & STR(VecNValid(yas))
    
    ' Temizlik
    VecDestroy yas
END MAIN
```

### 5.2 CSV Yükleme ve Regresyon (regression.bas)

```basic
' ============================================================================
' CSV YÜKLEME VE REGRESYON
' ============================================================================

INCLUDE "uxstat.bas"

MAIN
    ' DataFrame oluştur
    DIM veri AS StatDataFrameHandle
    DfCreate veri, "HastaVerisi", 1000, 3   ' 1000 satır, 3 sütun
    
    ' CSV yükle
    DIM result AS I32
    result = DfLoadCsv(veri, "C:\data\hastalar.csv", TRUE, ",")
    
    IF result <> 0 THEN
        PRINT "Yükleme hatası: " & StatLastError()
        END
    END IF
    
    PRINT "Yüklenen: " & STR(veri.nRow) & " satır, " & STR(veri.nCol) & " sütun"
    
    ' Sütunları al (varsayım: 0=yaş, 1=tansiyon, 2=kolesterol)
    DIM yas AS StatVectorHandle
    DIM tansiyon AS StatVectorHandle
    
    ' DataFrame'den sütun çıkarma (ileri seviye)
    ' Not: Bu örnekte basitleştirilmiş
    
    ' Korelasyon
    ' DIM r AS F64
    ' r = CorPearson(yas, tansiyon)
    ' PRINT "Yaş-Tansiyon korelasyonu: " & STR(r)
    
    ' Regresyon
    ' DIM reg AS RegressionResult
    ' RegressSimple yas, tansiyon, reg
    
    ' IF reg.success THEN
    '     PRINT "Regresyon: Tansiyon = " & STR(reg.intercept) & " + " & _
    '           STR(reg.beta(0)) & " * Yaş"
    '     PRINT "R-kare: " & STR(reg.rSquared)
    ' ELSE
    '     PRINT "Regresyon hatası: " & reg.errorMsg
    ' END IF
    
    DfDestroy veri
END MAIN
```

---

## 6. GELİŞTİRME AŞAMALARI (VS Code için)

| Aşama | Süre | Çıktı | Test |
|-------|------|-------|------|
| **1. İskelet** | 2 saat | CMake projesi, boş DLL derleniyor | `uxstat.dll` var mı? |
| **2. Bellek** | 2 saat | `uxb_alloc/free`, temel test | Bellek sızıntı testi |
| **3. Vektör** | 3 saat | `uxb_vec_create/destroy/set/get` | 100 eleman ekle/oku |
| **4. İstatistik** | 4 saat | Mean, median, std, min, max | Bilinen veri setiyle karşılaştır |
| **5. Eksik veri** | 3 saat | Bitmask, impute fonksiyonları | Eksik verili test |
| **6. CSV** | 3 saat | `uxb_load_csv` | Gerçek CSV dosyası |
| **7. BASIC wrapper** | 3 saat | `uxstat.bas` | BASIC'ten çağrı testi |
| **8. Regresyon** | 4 saat | Basit OLS | R/Python sonuçlarıyla karşılaştır |
| **9. Dokümantasyon** | 2 saat | README, API doc | - |
| **10. Entegrasyon** | 2 saat | uXBasic ile tam test | Son kullanıcı senaryosu |

**Toplam: 28 saat** (4-5 gün, günde 6 saat)

---

## 7. VS CODE YAPILANDIRMASI

### .vscode/tasks.json (Derleme görevleri)

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build DLL (Release)",
            "type": "shell",
            "command": "powershell",
            "args": ["-File", "build.ps1", "-Config", "Release"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": ["$msCompile"]
        },
        {
            "label": "Build DLL (Debug)",
            "type": "shell",
            "command": "powershell",
            "args": ["-File", "build.ps1", "-Config", "Debug"],
            "group": "build"
        },
        {
            "label": "Test",
            "type": "shell",
            "command": "ctest",
            "args": ["-C", "Release", "--output-on-failure"],
            "options": {
                "cwd": "${workspaceFolder}/build"
            }
        }
    ]
}
```

### .vscode/launch.json (Hata ayıklama)

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug DLL",
            "type": "cppvsdbg",
            "request": "launch",
            "program": "${workspaceFolder}/build/Debug/uxstat.dll",
            "symbolSearchPath": "${workspaceFolder}/build/Debug",
            "sourceFileMap": {
                "${workspaceFolder}": "${workspaceFolder}"
            }
        }
    ]
}
```

---

Bu plan, VS Code'da çalışan bir yardımcı için **tüm detayları** içeriyor. Her adım somut, dosya isimleri net, kod örnekleri hazır.

Başlamak için hazır mısınız? İlk adım olarak **CMakeLists.txt ve boş iskelet** mi oluşturalım, yoksa **doğrudan vektör implementasyonu** mu başlayalım?