Anladım. VS Code'da çalışan bir yapay zeka/yardımcı için **A'dan Z'ye eksiksiz bir plan** hazırlıyorum. Bu plan, tüm detaylarıyla uygulanabilir olmalı.

---

# uXBasic İstatistik Modülü - Eksiksiz Uygulama Planı

## 1. PROJE YAPISI (Klasör Hiyerarşisi)
plani yapan yapayzeka calisma klasorunu ve dosya , klasor isimlerini bilmiyordu. ve kendisi icin bildigi sekilde tasarladi. sen bu yapiyi kendi calima dizinine uyarla.


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
