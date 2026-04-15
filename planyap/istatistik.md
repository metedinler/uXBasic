Evet, çok daha profesyonel bir yapı kuralım. Excel ve SPSS'in güçlü yönlerini birleştiren, kategorik veri dönüşümü, çoklu sütunlar (DataFrame) ve eksik veri yönetimi ile tam teşekküllü bir istatistiksel veri motoru tasarlayalım.

## Profesyonel İstatistiksel Veri Motoru (DataFrame Tabanlı)

### 1. Mimari Genel Bakış

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATISTICAL DATA ENGINE                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                     DATAFRAME (Çoklu Sütun)                         │   │
│  │  ┌─────────┬─────────┬─────────┬─────────┬─────────┬─────────────┐ │   │
│  │  │  ID     │  CINS   │  YAS    │  GELIR  │  MEMNUN │  KATEGORI   │ │   │
│  │  │(Integer)│(Factor) │(Numeric)│(Numeric)│(Ordinal)│ (Nominal)   │ │   │
│  │  ├─────────┼─────────┼─────────┼─────────┼─────────┼─────────────┤ │   │
│  │  │    1    │   'E'   │   25    │  5000   │    3    │   'A'       │ │   │
│  │  │    2    │   'K'   │   30    │  7000   │    5    │   'B'       │ │   │
│  │  │    3    │   'E'   │  NULL   │  6000   │    4    │   'A'       │ │   │
│  │  │    4    │   'K'   │   35    │  NULL   │    2    │   NULL      │ │   │
│  │  └─────────┴─────────┴─────────┴─────────┴─────────┴─────────────┘ │   │
│  │         │         │         │         │         │                  │   │
│  │         ▼         ▼         ▼         ▼         ▼                  │   │
│  │    ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐         │   │
│  │    │Column  │ │Column  │ │Column  │ │Column  │ │Column  │         │   │
│  │    │(Int32) │ │(Factor)│ │(Float64│ │(Float64│ │(OrdFac)│         │   │
│  │    │        │ │        │ │ w/NA)  │ │ w/NA)  │ │        │         │   │
│  │    └────────┘ └────────┘ └────────┘ └────────┘ └────────┘         │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    COLUMN STORE (Veri Sütunları)                    │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐ │   │
│  │  │ RAW DATA    │  │ ENCODED     │  │ MISSING     │  │ METADATA   │ │   │
│  │  │ (Ham Veri)  │  │ (Kodlanmış) │  │ (Eksik)     │  │ (Meta)     │ │   │
│  │  │             │  │             │  │             │  │            │ │   │
│  │  │ • Numeric   │  │ • One-Hot   │  │ • Bitmask   │  │ • Levels   │ │   │
│  │  │ • String    │  │ • LabelEnc  │  │ • Sentinel  │  │ • Ordered  │ │   │
│  │  │ • DateTime  │  │ • TargetEnc │  │ • Imputed   │  │ • Contrast │ │   │
│  │  │ • Boolean   │  │ • Binary    │  │ • Flags     │  │ • Missing% │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              MISSING DATA & IMPUTATION ENGINE                         │   │
│  │                                                                     │   │
│  │  • Listwise Deletion    • Mean/Median Imputation    • Hot-Deck      │   │
│  │  • Pairwise Deletion    • Regression Imputation     • Cold-Deck     │   │
│  │  • Multiple Imputation  • KNN Imputation            • MICE          │   │
│  │  • Indicator Variables  • LOCF/FOCF                 • EM Algorithm  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2. Çekirdek Veri Yapıları (C/C++)

```c
// ============================================================
// PROFESYONEL İSTATİSTİKSEL VERİ MOTORU
// Excel + SPSS + R DataFrame Birleşimi
// ============================================================

#include <stdint.h>
#include <stdbool.h>
#include <time.h>

// ============================================================
// 1. VERİ TİPLERİ HİYERARŞİSİ
// ============================================================

// Temel atomik veri tipleri (Excel hücre tipleri + SPSS)
typedef enum {
    // Sayısal tipler
    DT_INT8,           // 8-bit integer
    DT_INT16,          // 16-bit integer  
    DT_INT32,          // 32-bit integer (SPSS default)
    DT_INT64,          // 64-bit integer
    DT_FLOAT32,        // 32-bit float
    DT_FLOAT64,        // 64-bit double (Excel double)
    DT_DECIMAL,        // Fixed-point (para birimleri)
    
    // Kategorik tipler
    DT_NOMINAL,        // Sırasız kategori (Cinsiyet: E/K)
    DT_ORDINAL,        // Sıralı kategori (Memnuniyet: 1-5)
    DT_BINARY,         // İkili (0/1, Evet/Hayır)
    
    // Metinsel tipler
    DT_STRING,         // Değişken uzunluklu string
    DT_FIXED_STRING,   // Sabit uzunluk (SPSS style)
    DT_FACTOR,         // R-style factor (levels ile)
    
    // Zaman tipleri
    DT_DATE,           // Tarih (Excel serial date)
    DT_TIME,           // Saat
    DT_DATETIME,       // Tarih+Saat
    DT_TIMESPAN,       // Süre (TimeDelta)
    
    // Özel tipler
    DT_BOOLEAN,        // Mantıksal
    DT_CURRENCY,       // Para birimi (kültürel format)
    DT_PERCENTAGE,     // Yüzde (0.15 = %15)
    DT_COMPLEX,        // Karmaşık sayı
    DT_RAW_BINARY,     // Binary blob
    
    // Eksik/Missing
    DT_NA,             // Not Available (R-style)
    DT_NULL,           // Null pointer
    
    DT_COUNT           // Tip sayısı
} DataType;

// Veri tipi metadata
typedef struct {
    DataType type;
    const char* name;           // "INTEGER", "FLOAT", "FACTOR"
    size_t size;                // Byte boyutu
    bool isNumeric;             // Sayısal mı?
    bool isCategorical;           // Kategorik mi?
    bool supportsMissing;         // Eksik değer desteği?
    const char* formatString;     // Varsayılan format "%.2f"
} DataTypeInfo;

// ============================================================
// 2. EKSİK VERİ (MISSING DATA) YÖNETİMİ
// ============================================================

// Eksik veri stratejisi (SPSS + R + Stata yaklaşımı)
typedef enum {
    // Fiziksel temsil
    MISS_NA_FLOAT,          // IEEE 754 NaN (float için)
    MISS_NA_INTEGER,        // INT_MIN gibi sentinel (int için)
    MISS_BITMASK,           // Ayrı bit maskesi (en esnek)
    MISS_BYTEMASK,          // Byte düzeyinde maske (hızlı)
    MISS_RUNLENGTH,         // Run-length encoded (seyrek veri)
    
    // Mantıksal strateji
    MISS_USER_DEFINED,      // Kullanıcı tanımlı kod (-999, 9999)
    MISS_SYSTEM_MISSING,    // Sistem tanımlı (SPSS SYSMIS)
    MISS_RANGE,             // Aralık tabanlı (0-99 = missing)
    
    // İmputasyon durumu
    MISS_ORIGINAL,          // Orijinal eksik
    MISS_IMPUTED,           // Doldurulmuş (imputed)
    MISS_DERIVED            // Türetilmiş hesaplama
} MissingStrategy;

// Eksik veri yönetimi yapısı
typedef struct {
    MissingStrategy strategy;
    
    // Fiziksel depolama
    union {
        struct { double naValue; } floatSentinel;
        struct { int64_t naValue; } intSentinel;
        struct { 
            uint8_t* mask;           // Bit maskesi: 1 = missing
            size_t byteCount;
        } bitmask;
        struct {
            uint8_t* mask;           // Byte başına: 0=var, 1=missing, 2=imputed
            size_t count;
        } bytemask;
    } storage;
    
    // İstatistikler
    size_t totalMissing;            // Toplam eksik sayısı
    size_t totalImputed;            // Doldurulmuş sayı
    double missingPercent;          // Eksik yüzdesi
    
    // Desen analizi (MCAR/MAR/MNAR tespiti)
    struct {
        bool analyzed;
        double mcarScore;           // Missing Completely at Random
        char* patternVector;        // Eksiklik deseni (her satır için)
    } pattern;
    
} MissingDataManager;

// ============================================================
// 3. KATEGORİK VERİ KODLAMA (ENCODING) SİSTEMİ
// ============================================================

// Faktör seviyeleri (R-style factor)
typedef struct {
    char* label;                    // Görünen etiket "Erkek"
    int code;                       // Sayısal kod: 0, 1, 2...
    double* contrast;               // Kontrast kodlama (dummy, helmert)
    size_t frequency;               // Frekans
    bool isMissingLevel;            // Eksik kategori mi?
} FactorLevel;

// Kodlama stratejileri (ML ve istatistik için)
typedef enum {
    // Temel kodlama
    ENC_LABEL,              // 0, 1, 2, 3... (default)
    ENC_ONE_HOT,            // [1,0,0], [0,1,0]... (dummy)
    ENC_DUMMY,              // k-1 değişken (tam rank)
    ENC_BINARY,             // Binary kodlama (log2(k) değişken)
    
    // İstatistiksel kodlama
    ENC_HELMERT,            // Helmert kontrast
    ENC_SUM,                // Sum-to-zero kontrast
    ENC_POLYNOMIAL,         // Polinomial kontrast (ordinal için)
    ENC_ORTHOGONAL,         // Ortogonal polinomial
    
    // Gelişmiş kodlama
    ENC_TARGET_MEAN,        // Target encoding (mean y per category)
    ENC_WEIGHT_OF_EVIDENCE, // WOE (kredi skorlama)
    ENC_JAMES_STEIN,        // James-Stein shrinkage
    ENC_MESTIMATE,          // M-estimate smoothing
    ENC_LOO,                // Leave-one-out encoding
    
    // Özel
    ENC_FREQUENCY,          // Frekans kodlama
    ENC_RANK,               // Sıra kodlama
    ENC_HASH                // Hash encoding (yüksek kardinalite)
} EncodingType;

// Kategorik kolon yapısı
typedef struct {
    char* columnName;
    
    // Seviyeler
    FactorLevel* levels;
    size_t levelCount;
    size_t levelCapacity;
    
    // Kodlama
    EncodingType encoding;
    void* encodedData;              // Kodlanmış matris (one-hot için)
    
    // Özel özellikler
    bool isOrdered;                 // Ordinal mi?
    int* orderMap;                  // Sıralama haritası
    
    // Eksik kategori yönetimi
    bool hasMissingLevel;
    int missingLevelCode;
    
    // İstatistikler
    double entropy;
    double modeFrequency;
    
} CategoricalColumn;

// ============================================================
// 4. DATAFRAME - ÇOKLU SÜTUN YAPISI (Excel/SPSS/R)
// ============================================================

// Kolon tipleri (SPSS değişken tipleri)
typedef enum {
    COL_SCALE,              // Ölçekli (sayısal, sürekli)
    COL_NOMINAL,            // Nominal (kategorik, sırasız)
    COL_ORDINAL,            // Ordinal (sıralı kategorik)
    COL_STRING,             // Metinsel
    COL_DATE,               // Tarih
    COL_ID,                 // Tanımlayıcı (ID numarası)
    COL_BINARY,             // İkili (0/1)
    COL_IGNORE              // Analiz dışı
} ColumnRole;

// Kolon metadata (SPSS Variable View gibi)
typedef struct {
    // Temel
    char name[64];              // Değişken adı
    char label[256];            // Etiket (açıklama)
    ColumnRole role;
    DataType type;
    
    // Format (Excel hücre formatı gibi)
    char format[32];            // "F8.2", "DATE11", "DOLLAR12.2"
    int width;                  // Gösterim genişliği
    int decimals;               // Ondalık basamak
    
    // Değer etiketleri (SPSS Value Labels)
    struct {
        double value;
        char label[128];
    }* valueLabels;
    size_t valueLabelCount;
    
    // Eksik değer tanımları (SPSS Missing Values)
    struct {
        bool discrete[3];       // Ayrık değerler
        double discreteValues[3];
        bool range;             // Aralık mı?
        double rangeLow, rangeHigh;
    } missingDefinition;
    
    // Ölçek (Measurement level)
    enum {
        MEASURE_UNKNOWN,
        MEASURE_NOMINAL,
        MEASURE_ORDINAL,
        MEASURE_SCALE
    } measurementLevel;
    
    // Kolon özellikleri
    bool isComputed;            // Hesaplanmış değişken mi?
    char* computeExpression;      // Hesaplama formülü
    
} ColumnMetadata;

// DataFrame kolonu (sütun-tabanlı depolama)
typedef struct {
    ColumnMetadata meta;
    
    // Veri depolama (sütun-tabanlı - daha hızlı)
    union {
        int8_t* i8;
        int16_t* i16;
        int32_t* i32;
        int64_t* i64;
        float* f32;
        double* f64;
        char** strings;
        CategoricalColumn* categorical;
        time_t* dates;
    } data;
    
    size_t length;              // Satır sayısı
    
    // Eksik veri yönetimi
    MissingDataManager missing;
    
    // Önbelleklenmiş istatistikler (lazy)
    struct {
        bool valid;
        double min, max, mean, median, std;
        double* percentiles;    // 1%, 5%, 25%, 75%, 95%, 99%
        size_t uniqueCount;     // Benzersiz değer sayısı
    } stats;
    
} DataColumn;

// DataFrame (tam veri seti)
typedef struct {
    char* name;                     // Veri seti adı
    
    // Kolonlar
    DataColumn** columns;
    size_t colCount;
    size_t colCapacity;
    
    // Satır bilgisi
    size_t rowCount;
    
    // İndeks (satır etiketleri)
    char** rowNames;                // Opsiyonel satır adları
    DataColumn* rowIndex;           // Sayısal indeks kolonu
    
    // Metadata
    char* title;                    // Başlık
    char* description;              // Açıklama
    time_t created;
    time_t modified;
    
    // Bellek yönetimi
    size_t memoryUsed;
    bool isMemoryMapped;            // Diskten okuma?
    
    // Paralel işleme
    int chunkSize;                  // Paralel işlem parçası
    
} DataFrame;

// ============================================================
// 5. VERİ DÖNÜŞÜM VE İŞLEME MOTORU
// ============================================================

// Dönüşüm işlemleri (Excel Power Query + SPSS Transform)
typedef enum {
    // Temel dönüşümler
    TRANS_SCALE,            // Ölçeklendirme (z-score, min-max)
    TRANS_NORMALIZE,        // Normalizasyon
    TRANS_LOG,              // Logaritmik
    TRANS_EXP,              // Üstel
    TRANS_POWER,            // Güç dönüşümü (Box-Cox)
    TRANS_RANK,             // Sıralama dönüşümü
    
    // Kategorik dönüşümler
    TRANS_ENCODE,           // Kodlama (one-hot, label)
    TRANS_RECODE,           // Yeniden kodlama (SPSS RECODE)
    TRANS_DUMMIFY,          // Dummy değişken oluşturma
    TRANS_ORDINALIZE,       // Ordinal sıralama
    
    // Eksik veri işlemleri
    TRANS_IMPUTE_MEAN,
    TRANS_IMPUTE_MEDIAN,
    TRANS_IMPUTE_MODE,
    TRANS_IMPUTE_KNN,
    TRANS_IMPUTE_MICE,
    TRANS_INTERPOLATE,
    
    // Gruplama
    TRANS_GROUPBY,          // Gruplama
    TRANS_AGGREGATE,        // Toplulaştırma
    TRANS_PIVOT,            // Pivot (Excel)
    TRANS_MELT,             // Uzun formata çevir
    
    // Birleştirme
    TRANS_MERGE,            // SQL join
    TRANS_APPEND,           // Satır ekleme
    TRANS_CONCAT            // Kolon ekleme
    
} TransformationType;

// Dönüşüm pipeline'ı
typedef struct {
    TransformationType type;
    DataColumn* source;
    DataColumn* target;
    void* params;
    bool inPlace;               // Yerinde mi yapılsın?
} DataTransformation;

// ============================================================
// 6. BASIC DİLİ ENTEGRASYONU
// ============================================================

// BASIC için yeni veri tipleri
typedef enum {
    BASIC_VAR_SCALAR,       // Klasik A = 5
    BASIC_VAR_ARRAY,        // DIM A(100)
    BASIC_VAR_DATAFRAME,    // YENİ: DIM DF AS DATAFRAME
    BASIC_VAR_COLUMN,       // YENİ: DIM COL AS COLUMN
    BASIC_VAR_SERIES        // YENİ: DIM S AS SERIES
} BasicVarType;

// BASIC değişken değeri (union)
typedef struct {
    BasicVarType type;
    union {
        double scalar;
        struct { double* data; size_t size; } array;
        DataFrame* dataframe;
        DataColumn* column;
        struct { 
            DataColumn* col; 
            size_t start, end; 
        } series;  // Vektör görünümü
    } value;
    
    char name[32];
} BasicVariable;
```

### 3. BASIC Sözdizimi - Profesyonel Veri Yönetimi

```basic
' ============================================================
' PROFESYONEL BASIC - DATAFRAME & İSTATİSTİK
' ============================================================

' --- 1. DATAFRAME OLUŞTURMA (Excel/SPSS Tarzı) ---

' Boş DataFrame tanımlama
DIM HASTALAR AS DATAFRAME
CREATE HASTALAR COLUMNS 5 ROWS 100

' Kolon tanımlama (SPSS Variable View gibi)
DEFINE COLUMN HASTALAR.ID AS INTEGER LABEL "Hasta ID" FORMAT "F6.0"
DEFINE COLUMN HASTALAR.CINSIYET AS NOMINAL LABEL "Cinsiyet" VALUES "E"="Erkek", "K"="Kadın"
DEFINE COLUMN HASTALAR.YAS AS SCALE LABEL "Yaş (yıl)" FORMAT "F3.0" MISSING 999
DEFINE COLUMN HASTALAR.GELIR AS SCALE LABEL "Aylık Gelir (TL)" FORMAT "DOLLAR12.2"
DEFINE COLUMN HASTALAR.MEMNUN AS ORDINAL LABEL "Memnuniyet" VALUES 1="Çok Kötü", 5="Çok İyi"

' Veri yükleme
LOAD HASTALAR FROM "hastalar.csv" DELIMITER "," HEADER ON
' veya
LOAD HASTALAR FROM "hastalar.sav" FORMAT SPSS
' veya
LOAD HASTALAR FROM "hastalar.xlsx" SHEET "Sayfa1" RANGE A1:F101

' --- 2. ÇOKLU SÜTUN İŞLEMLERİ ---

' Tüm sayısal kolonları seçme
DIM SAYISAL_KOLONLAR AS COLUMN ARRAY
SAYISAL_KOLONLAR = SELECT COLUMNS FROM HASTALAR WHERE TYPE = NUMERIC

' Belirli kolonlarla yeni DataFrame
DIM ALT_SET AS DATAFRAME
ALT_SET = HASTALAR[CINSIYET, YAS, GELIR]

' Filtreleme (SPSS SELECT IF gibi)
DIM ERKEKLER AS DATAFRAME
ERKEKLER = FILTER HASTALAR WHERE CINSIYET = "E" AND YAS > 18

' Sıralama
SORT HASTALAR BY CINSIYET ASC, YAS DESC

' --- 3. KATEGORİK VERİ KODLAMA (Encoding) ---

' Otomatik label encoding (0, 1, 2...)
ENCODE HASTALAR.CINSIYET TO CINSIYET_KOD AS LABEL

' One-hot encoding (dummy değişkenler)
DUMMY HASTALAR.CINSIYET PREFIX "CINS_" RESULT CINS_E, CINS_K

' Ordinal encoding (sıralı)
ENCODE HASTALAR.MEMNUN TO MEMNUN_KOD AS ORDINAL

' Hedef kodlama (target encoding - ML için)
ENCODE HASTALAR.IL TO IL_TARGET AS TARGET_MEAN TARGET HASTALAR.SATIS

' --- 4. EKSİK VERİ YÖNETİMİ (Missing Data) ---

' Eksik veri analizi
PRINT MISSING PATTERN HASTALAR
' Çıktı: 
' ID: %0 | CINSIYET: %0 | YAS: %5.2 | GELIR: %12.3 | MEMNUN: %0

' Listwise deletion (tam satır silme)
DELETE ROWS FROM HASTALAR WHERE ANY MISSING

' Pairwise deletion (sadece analizde kullanılan kolonlar)
DIM ANALIZ_SET AS DATAFRAME
ANALIZ_SET = HASTALAR WITH PAIRWISE COMPLETE OBS

' İmputasyon (doldurma)
IMPUTE HASTALAR.YAS METHOD MEAN        ' Ortalama ile
IMPUTE HASTALAR.GELIR METHOD MEDIAN    ' Medyan ile
IMPUTE HASTALAR.YAS METHOD KNN K=5     ' K-en yakın komşu
IMPUTE HASTALAR.GELIR METHOD REGRESSION PREDICTORS [YAS, CINSIYET]

' Çoklu imputasyon (SPSS Multiple Imputation)
MULTIPLE IMPUTE HASTALAR M=5 METHOD FCS SAVE TO "imputed_data.sav"

' Eksik veri indikatörü oluşturma
CREATE COLUMN HASTALAR.YAS_MISSING AS BINARY = ISMISSING(HASTALAR.YAS)

' --- 5. VERİ DÖNÜŞÜM ---

' Normalizasyon/Z-score
TRANSFORM HASTALAR.YAS TO YAS_Z METHOD ZSCORE

' Min-Max ölçeklendirme (0-1)
TRANSFORM HASTALAR.GELIR TO GELIR_01 METHOD MINMAX RANGE [0, 1]

' Log dönüşümü (sağa çarpık veri için)
TRANSFORM HASTALAR.GELIR TO GELIR_LOG METHOD LOG BASE 10

' Box-Cox dönüşümü
TRANSFORM HASTALAR.GELIR TO GELIR_BC METHOD BOXCOX LAMBDA AUTO

' Bins/kategoriler (SPSS Visual Binning)
BIN HASTALAR.YAS TO YAS_GRUP METHOD EQUAL_WIDTH BINS 4 LABELS ["18-30", "31-45", "46-60", "60+"]

' --- 6. GRUPLAMA VE TOPLULAŞTIRMA ---

' GroupBy (SQL/R tarzı)
DIM OZET AS DATAFRAME
GROUP HASTALAR BY CINSIYET
    COMPUTE MEAN_YAS = MEAN(YAS)
    COMPUTE STD_GELIR = STD(GELIR)
    COMPUTE COUNT = N()
    COMPUTE MEDIAN_MEMNUN = MEDIAN(MEMNUN)
SAVE TO OZET

' Pivot tablo (Excel PivotTable)
PIVOT HASTALAR 
    ROWS CINSIYET 
    COLUMNS YAS_GRUP 
    VALUES GELIR AGGREGATE MEAN
    SAVE TO PIVOT_TABLO

' --- 7. İSTATİSTİKSEL FONKSİYONLAR (Çoklu Sütun) ---

' Temel istatistikler (tüm sayısal kolonlar için)
PRINT DESCRIPTIVES HASTALAR COLUMNS [YAS, GELIR]
' Çıktı:
' Değişken | N | Mean | Median | Std | Min | Max | Missing%
' ---------|---|---|------|--------|-----|-----|-----|----------
' YAŞ      |95 |34.2 | 32.0  | 12.5| 18  | 78  | 5.0%
' GELİR    |88 |5420| 5000  |2100 |1200 |15000| 12.0%

' Korelasyon matrisi
DIM KOR_MATRIS AS MATRIX
KOR_MATRIS = CORRELATION HASTALAR COLUMNS [YAS, GELIR, MEMNUN] METHOD PEARSON

' t-test (grup karşılaştırma)
TTEST HASTALAR.GELIR GROUPS HASTALAR.CINSIYET
' veya
TTEST HASTALAR.GELIR BY HASTALAR.CINSIYET

' ANOVA (çoklu grup)
ANOVA HASTALAR.GELIR BY HASTALAR.YAS_GRUP POSTHOC TUKEY

' Regresyon (çoklu değişken)
REGRESSION HASTALAR 
    DEPENDENT GELIR 
    INDEPENDENTS [YAS, CINSIYET_KOD, MEMNUN_KOD]
    METHOD ENTER
    SAVE MODEL TO "regresyon.model"

' --- 8. VERİ BİRLEŞTİRME (Merge/Join) ---

' SQL tarzı join
DIM DOKTORLAR AS DATAFRAME
LOAD DOKTORLAR FROM "doktorlar.csv"

DIM BIRLESIK AS DATAFRAME
MERGE HASTALAR WITH DOKTORLAR 
    ON HASTALAR.DOKTOR_ID = DOKTORLAR.ID 
    TYPE LEFT
    SAVE TO BIRLESIK

' Dikey birleştirme (satır ekleme)
APPEND HASTALAR WITH "yeni_hastalar.csv"

' --- 9. ARRAY OLUŞTURMA (Kolonlardan) ---

' DataFrame'den 2D array (matris)
DIM X AS ARRAY
X = ARRAY FROM HASTALAR COLUMNS [YAS, GELIR, MEMNUN_KOD]
' X şimdi Nx3 matris

' Belirli satırlar
DIM ALT_KUME AS ARRAY
ALT_KUME = ARRAY FROM HASTALAR ROWS 1 TO 50 COLUMNS [YAS, GELIR]

' Transpose
DIM XT AS ARRAY
XT = TRANSPOSE(X)

' --- 10. GELİŞMİŞ İŞLEMLER ---

' Çapraz doğrulama için veri bölme
SPLIT HASTALAR TO [EGITIM, TEST] RATIO 0.7 RANDOM_SEED 42

' Bootstrap örnekleme
BOOTSTRAP HASTALAR SAMPLES 1000 SIZE 100 TO BOOTSTRAP_SET

' Ağırlıklı analiz
WEIGHT HASTALAR BY HASTALAR.AGIRLIK
MEAN HASTALAR.GELIR WEIGHTED  ' Ağırlıklı ortalama

' String işlemler
COMPUTE HASTALAR.ISIM_UZUN = LEN(HASTALAR.ISIM)
COMPUTE HASTALAR.ISIM_BUYUK = UCASE(HASTALAR.ISIM)
```

### 4. İmplementasyon Detayları

```c
// ============================================================
// KRİTİK FONKSİYONLAR - PSEUDO CODE
// ============================================================

// DataFrame oluşturma
DataFrame* df_create(const char* name, size_t rows, size_t cols) {
    DataFrame* df = malloc(sizeof(DataFrame));
    df->name = strdup(name);
    df->rowCount = rows;
    df->columns = calloc(cols, sizeof(DataColumn*));
    df->colCount = 0;
    df->colCapacity = cols;
    return df;
}

// Kolon ekleme (tip güvenli)
DataColumn* df_add_column(DataFrame* df, const char* name, DataType type, ColumnRole role) {
    DataColumn* col = malloc(sizeof(DataColumn));
    strcpy(col->meta.name, name);
    col->meta.type = type;
    col->meta.role = role;
    col->length = df->rowCount;
    
    // Bellek ayırma (sütun-tabanlı)
    switch(type) {
        case DT_FLOAT64:
            col->data.f64 = calloc(df->rowCount, sizeof(double));
            col->missing.strategy = MISS_NA_FLOAT;
            break;
        case DT_INT32:
            col->data.i32 = calloc(df->rowCount, sizeof(int32_t));
            col->missing.strategy = MISS_NA_INTEGER;
            break;
        case DT_NOMINAL:
        case DT_ORDINAL:
            col->data.categorical = catcol_create(name);
            col->missing.strategy = MISS_BITMASK;
            break;
        // ... diğer tipler
    }
    
    // Eksik veri maskesi ayırma
    missing_init(&col->missing, df->rowCount);
    
    df->columns[df->colCount++] = col;
    return col;
}

// Kategorik kodlama
void catcol_encode(CategoricalColumn* cat, EncodingType enc, DataColumn* target) {
    switch(enc) {
        case ENC_LABEL:
            // 0, 1, 2... kodlama
            for(size_t i = 0; i < target->length; i++) {
                target->data.i32[i] = cat->data[i]->code;
            }
            break;
            
        case ENC_ONE_HOT:
            // k adet binary kolon oluştur
            for(size_t l = 0; l < cat->levelCount; l++) {
                DataColumn* dummy = df_add_column(df, cat->levels[l].label, DT_BINARY, COL_BINARY);
                for(size_t i = 0; i < target->length; i++) {
                    dummy->data.i8[i] = (cat->data[i]->code == l) ? 1 : 0;
                }
            }
            break;
            
        case ENC_TARGET_MEAN:
            // Her kategori için hedef değişken ortalaması
            // ML için yaygın kullanılan encoding
            break;
    }
}

// Eksik veri imputasyonu
void column_impute(DataColumn* col, ImputationMethod method, DataFrame* context) {
    size_t missing_count = col->missing.totalMissing;
    if(missing_count == 0) return;
    
    switch(method) {
        case IMPUTE_MEAN:
            double mean = column_compute_mean(col); // Sadece var olanlar
            for(size_t i = 0; i < col->length; i++) {
                if(missing_is_missing(col->missing, i)) {
                    col->data.f64[i] = mean;
                    missing_mark_imputed(&col->missing, i);
                }
            }
            break;
            
        case IMPUTE_KNN:
            // k-en yakın komşu ile doldurma
            knn_impute(col, context, 5);
            break;
            
        case IMPUTE_MICE:
            // Çoklu imputasyon zincirsel denklemler
            mice_impute(col, context, 5);
            break;
    }
}

// Veri çerçevesinden array oluşturma (BASIC ARRAY için)
double** df_to_array(DataFrame* df, const char** col_names, size_t col_count) {
    double** matrix = malloc(df->rowCount * sizeof(double*));
    for(size_t i = 0; i < df->rowCount; i++) {
        matrix[i] = malloc(col_count * sizeof(double));
        for(size_t j = 0; j < col_count; j++) {
            DataColumn* col = df_find_column(df, col_names[j]);
            matrix[i][j] = column_get_double(col, i);
        }
    }
    return matrix;
}
```

### 5. Bellek ve Performans Optimizasyonu

```c
// ============================================================
// PERFORMANS OPTİMİZASYONLARI
// ============================================================

// 1. Sütun-tabanlı depolama (Columnar Storage)
//    - Cache-friendly (sıralı erişim)
//    - SIMD optimizasyonu mümkün
//    - Sıkıştırma verimli

// 2. Chunked processing (büyük veri setleri için)
#define CHUNK_SIZE 8192
void process_large_column(DataColumn* col) {
    for(size_t offset = 0; offset < col->length; offset += CHUNK_SIZE) {
        size_t chunk = min(CHUNK_SIZE, col->length - offset);
        process_chunk(&col->data.f64[offset], chunk);
    }
}

// 3. Sıkıştırma (kategorik kolonlar için)
typedef struct {
    uint32_t* codes;        // Kodlar (sıkıştırılmış)
    FactorLevel* levels;    // Sözlük
    size_t unique_count;    // Benzersiz değer sayısı
} CompressedCategorical;

// 4. Bellek havuzu (frequent allocations)
typedef struct {
    void* pool;
    size_t used;
    size_t capacity;
} MemoryPool;

// 5. Paralel işleme (OpenMP)
#ifdef _OPENMP
void parallel_mean(DataColumn* col) {
    double sum = 0;
    #pragma omp parallel for reduction(+:sum)
    for(size_t i = 0; i < col->length; i++) {
        if(!missing_is_missing(col->missing, i)) {
            sum += col->data.f64[i];
        }
    }
    col->stats.mean = sum / (col->length - col->missing.totalMissing);
}
#endif
```

Bu yapı ile BASIC derleyiciniz:

1. **Excel benzeri**: Kolonlar, satırlar, hücre formatları
2. **SPSS benzeri**: Değişken tipleri, eksik veri yönetimi, etiketler
3. **R/Python benzeri**: DataFrame işlemleri, kodlama, dönüşümler
4. **SQL benzeri**: Filtreleme, gruplama, birleştirme

Hangi bölümü daha detaylı incelememi istersiniz? Örneğin:
- KNN/MICE imputasyon algoritmaları
- Paralel işleme stratejileri
- BASIC parser entegrasyonu
- Dosya formatları (CSV, SPSS .sav, Excel .xlsx) okuma/yazma