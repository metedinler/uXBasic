# ADIM29 — Tüm Runtime Extension DLL Doctor + Build Orchestrator

## Amaç

ADIM28 sadece FP runtime üçlüsünü doğruladı:

- `uxb_fp80.dll`
- `uxb_fp128.dll`
- `uxb_bigfp.dll`

Fakat `runtime_ext/` altında başka kütüphane DLL kaynakları ve build scriptleri de var:

- `uxmathcore.dll`
- `uxmath.dll`
- `uxstats.dll`
- `uxstats2.dll`
- `uxdataset.dll`
- `uxaimath.dll`
- `uxcollections.dll`
- `uxdataframe.dll`
- `uxgraph.dll`
- `uxllama.dll`
- `uxmatrix.dll`
- `uxnn.dll`
- `uxnn2.dll`
- `uxnn3.dll`
- `uxonnx.dll`
- `uxonnx2.dll`
- `uxtensor.dll`

Bu adımın görevi sahte DLL üretmek değildir. Var olan `runtime_ext/*/build_*.bat`
dosyalarını kullanarak bütün runtime DLL durumunu raporlamak ve istenirse derlemektir.

## Kesin kurallar

- Sahte DLL üretme.
- Kaynak yoksa `SOURCE_MISSING` yaz.
- Build script yoksa `BUILD_SCRIPT_MISSING` yaz.
- DLL varsa `DLL_EXISTS` yaz.
- DLL yoksa ve `-Build` verilmediyse sadece raporla.
- `-Build` verilirse mevcut build scriptini çağır.
- Fallback script varsa ana build başarısız olunca fallback denenebilir.
- Test runner içinde placeholder üretme.
- Compiler kaynak dosyalarına dokunma.

## Dosyalar

```text
compiler/scripts/run_adim29_all_runtime_ext_dll_doctor.ps1
compiler/scripts/build_all_runtime_ext_dlls.bat
```

## Kullanım

Sadece durum raporu:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File uxb\compiler\scripts\run_adim29_all_runtime_ext_dll_doctor.ps1 `
  -NoRepair
```

Derleme denemesi:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File uxb\compiler\scripts\run_adim29_all_runtime_ext_dll_doctor.ps1 `
  -Build
```

Tüm beklenen DLL eksikse gate fail istiyorsan:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File uxb\compiler\scripts\run_adim29_all_runtime_ext_dll_doctor.ps1 `
  -StrictAll
```

## Beklenen raporlar

```text
uxb/reports/control/current/adim29_runtime_ext_dll_matrix.csv
uxb/reports/control/current/adim29_runtime_ext_dll_gate.json
uxb/reports/control/current/adim29_runtime_ext_dll_gate.md
```

## Copilot kısa emir

```text
ADIM29 patchini uygula.
Compiler kaynak koduna dokunma.
Sadece iki scripti compiler/scripts altına kopyala.
Önce run_adim29_all_runtime_ext_dll_doctor.ps1 -NoRepair çalıştır.
Sonra istenirse -Build ile derleme dene.
Sahte DLL üretme.
Eksik dependency varsa dependency_missing olarak raporla.
```
