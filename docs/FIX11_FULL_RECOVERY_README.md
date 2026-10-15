# uXBasic FIX11 Full Recovery

## Yöntem

KOPYALA-EZ / FULL FILE REPLACE.

Bu paket patch runner değildir. Zip içindeki tam FreeBasic dosyaları hedef `src/` içine kopyalanır.

## Hedef kaynak

Bu paket `src(11.06_3).zip` içindeki son kaynak durumuna göre hazırlandı.

Mevcut durumda:
- Fix6 uygulanmış ve yararlı etki bırakmış görünüyor.
- Fix8 / Fix8b bazı runtime dosyalarına karışık ama derlenebilir ekler bırakmış.
- Fix9 logda dry-run kalmış görünüyor.
- Fix10 logda dry-run kalmış görünüyor; `ExecTryResolveArrayAccess` hâlâ eski hatalı satırı taşıyor.

## Değiştirilen tam dosyalar

- `src/runtime/exec/exec_state_value_utils.fbs`
- `src/runtime/memory_exec.fbs`

## Kök düzeltmeler

### 1. Runtime error 6

Eski kod:

```freebasic
If varIdx = -1 Or es.vars(varIdx).isArray = 0 Then Return 0
```

FreeBasic `Or` kısa devre yapmadığı için `varIdx = -1` iken `es.vars(-1)` okunuyordu.
Bu, `UCASE(...)`, `ADD(...)`, `GEN_ADD(...)` gibi normal fonksiyon çağrıları array erişimi mi diye kontrol edilirken runtime error 6 üretiyordu.

Yeni kod önce sınır kontrolü yapar:

```freebasic
If varIdx < 0 Or varIdx >= es.count Then Return 0
If es.vars(varIdx).isArray = 0 Then Return 0
```

### 2. Include const değeri 0 kalıyor

`GEN_ADD(2, GEN_HEADER_BASE)` çağrısında argüman değerlendirme `ExecEvalNode()` üzerinden gidiyor.
`ExecEvalNode()` IDENT için `ExecResolveThisMeIdentValue()` çağırıyor; bu fonksiyon const tablosuna bakmıyordu.
Bu yüzden `GEN_HEADER_BASE = 40` yerine 0 alınıyordu ve çıktı `42` yerine `2` oluyordu.

Yeni kod `ExecResolveThisMeIdentValue()` içine const tablosu kontrolü ekler.

## Uygulama

```powershell
python copy_over_fix11_full_recovery.py --root . --dry-run
python copy_over_fix11_full_recovery.py --root .
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

## Test

```powershell
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only strings
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only namespace
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only include_import
```
