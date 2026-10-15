# UXMATH Core Module — Prompt 1

Bu paket, gelecekteki `uxai` yapay zekâ eklentisinin alt matematik çekirdeğidir.
Yeni uXBasic keyword eklemez. Mevcut `.bas INCLUDE + CALL(DLL)` sarmalayıcı modelini kullanır.

## Dosyalar

```text
libs/uxmath/uxmath.bas
uxb/runtime_ext/uxmath/uxmath.c
uxb/runtime_ext/uxmath/uxmath.h
uxb/runtime_ext/uxmath/build_uxmath_dll.bat
uxb/tests/uxmath/uxmath_dll_probe.c
uxb/tests/uxmath/build_and_run_uxmath_probe.bat
uxb/tests/uxmath/uxmath_include_smoke.bas
uxb/compiler/scripts/run_uxmath_smoke.bat
```

## Sağlanan çekirdekler

- Vector handle sistemi
- Matrix handle sistemi
- Polinom değerlendirme
- Polinom türev katsayısı ve türev değeri
- Polinom integral katsayısı ve belirli integral
- Bisection / Newton kök bulma
- Simpson sayısal integrasyon
- Logistic ODE Euler ve RK4 çözümü
- Sigmoid, tanh, ReLU ve türev yardımcıları
- Softmax
- Matris toplama, çıkarma, çarpma, transpose
- Matris-vektör çarpımı

## Kullanım

```basic
INCLUDE "libs/uxmath/uxmath.bas"

p = UXMATH_VecCreate(4)
UXMATH_VecPush(p, 1.0)
UXMATH_VecPush(p, 2.0)
UXMATH_VecPush(p, 3.0)

PRINT UXMATH_PolyEval(p, 2.0)
PRINT UXMATH_PolyDerivativeEval(p, 2.0)
PRINT UXMATH_Sigmoid(0.0)

UXMATH_VecFree(p)
```

## Build / smoke

```bat
cd /d C:\Users\mete\Downloads\UXBc
uxb\compiler\scripts\run_uxmath_smoke.bat
```

## Dürüst sınır

Bu Prompt 1, sinir ağı eklentisinin kendisi değildir. Yalnızca onun altında çalışacak matematik çekirdeğini sağlar.
`uxai.dll` ve `libs/uxai/uxai.bas` Prompt 2’de gelecek.
