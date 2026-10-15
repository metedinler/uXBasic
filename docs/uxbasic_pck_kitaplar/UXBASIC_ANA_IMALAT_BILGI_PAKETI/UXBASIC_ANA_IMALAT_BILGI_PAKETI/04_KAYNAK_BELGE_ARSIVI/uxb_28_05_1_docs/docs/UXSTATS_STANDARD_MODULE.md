# uXBasic Standard Statistics Module — uxstats

Bu paket, uXBasic için yeni keyword eklemeden çalışan standart istatistik modülü örneğidir.

## Mimari

```text
INCLUDE "libs/uxstats/uxstats.bas"
        ↓
UXSTATS_* wrapper fonksiyonları
        ↓
CALL(DLL, "uxstats.dll", ...)
        ↓
uxb/runtime_ext/uxstats/uxstats.c
        ↓
standart C math.h + handle-backed vector runtime
```

## Eklenen dosyalar

```text
libs/uxstats/uxstats.bas
uxb/runtime_ext/uxstats/uxstats.c
uxb/runtime_ext/uxstats/uxstats.h
uxb/runtime_ext/uxstats/build_uxstats_dll.bat
uxb/tests/uxstats/uxstats_include_smoke.bas
uxb/tests/uxstats/uxstats_regression_smoke.bas
uxb/tests/uxstats/uxstats_dll_probe.c
uxb/tests/uxstats/build_and_run_uxstats_probe.bat
uxb/compiler/scripts/run_uxstats_smoke.bat
```

## Kurulum

Paketi `UXBc` köküne aç veya içindeki klasörleri mevcut `UXBc` köküne kopyala.

MSYS2 UCRT64 GCC gerekiyorsa:

```bash
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc
```

DLL build:

```bat
uxb\runtime_ext\uxstats\build_uxstats_dll.bat
```

Tam smoke:

```bat
uxb\compiler\scripts\run_uxstats_smoke.bat
```

## BASIC kullanımı

```basic
INCLUDE "libs/uxstats/uxstats.bas"

v = UXSTATS_VecCreate(16)
UXSTATS_VecPush(v, 1.0)
UXSTATS_VecPush(v, 2.0)
UXSTATS_VecPush(v, 3.0)

PRINT UXSTATS_Mean(v)
PRINT UXSTATS_StdDevSamp(v)
PRINT UXSTATS_Median(v)

UXSTATS_VecFree(v)
```

## Fonksiyonlar

### Vector yönetimi

```text
UXSTATS_VecCreate(capacity) AS U64
UXSTATS_VecFree(handle) AS I32
UXSTATS_VecClear(handle) AS I32
UXSTATS_VecCount(handle) AS I32
UXSTATS_VecCapacity(handle) AS I32
UXSTATS_VecPush(handle, value) AS I32
UXSTATS_VecSet(handle, index, value) AS I32
UXSTATS_VecGet(handle, index) AS F64
```

### Tek değişkenli istatistik

```text
UXSTATS_Sum
UXSTATS_Mean
UXSTATS_Min
UXSTATS_Max
UXSTATS_Range
UXSTATS_VariancePop
UXSTATS_VarianceSamp
UXSTATS_StdDevPop
UXSTATS_StdDevSamp
UXSTATS_Median
UXSTATS_Percentile
```

### İki değişkenli istatistik ve regresyon

```text
UXSTATS_CovarianceSamp
UXSTATS_Correlation
UXSTATS_RegressionSlope
UXSTATS_RegressionIntercept
UXSTATS_RegressionR2
```

## Neden handle-backed vector?

uXBasic array belleğinin her backendde dış DLL'e gerçek ve sürekli `double*` olarak verildiğinden emin değiliz. Bu yüzden ilk standart modül handle-backed C vector kullanır. Böylece DLL kendi RAM alanını yönetir, uXBasic sadece `U64/PTR` handle tutar.

## Raw pointer API

`UXSTATS_RawMeanF64(ptr, count)` ve `UXSTATS_RawStdDevSampF64(ptr, count)` eklendi. Bunları sadece `VARPTR(array(0))` backendinde gerçek contiguous F64 pointer verdiğini doğruladıktan sonra kullan.
