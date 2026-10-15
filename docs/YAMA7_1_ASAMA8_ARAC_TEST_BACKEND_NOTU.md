# Yama 7.1 / Aşama 8 hazırlık notu

Bu paket yeni dil özelliği eklemez. Amaç:

1. Bozuk/karışık runner çağrılarını düzeltmek.
2. tests klasöründeki .uxb/.uxbh/.bas dosyaları için genel kaynak test runner kurmak.
3. Aşama 8 oneTBB backend dosyalarını opsiyonel şekilde eklemek.
4. libuv ve oneTBB DLL derleme yollarını bağımlılık kuruluysa çalışacak, kurulu değilse normal build'i bozmayacak hale getirmek.

## Değişen / eklenen dosyalar

- uxr_calistir.bat
- run_uxb_mir.bat
- run_all_source_tests.bat
- tools/tests/uxb_discover_and_run_all_sources.py
- native/uxb_runtime/uxb_runtime.cpp
- native/uxb_runtime/build_runtime_dll.bat
- native/uxb_runtime/backends/tbb_backend.h
- native/uxb_runtime/backends/tbb_backend.cpp
- native/uxb_runtime/DEPENDENCIES_TR.md
- tools/tests/check_yama7_libuv_backend.py
- tools/tests/check_yama8_tbb_backend.py
- run_yama8_tbb_backend_tests.bat

## Ana kabul komutları

```powershell
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
.\run_all_yama_tests.bat .\bin\uxb.exe
.\run_yama6_runtime_abi_tests.bat
.\run_yama7_libuv_backend_tests.bat
.\run_yama8_tbb_backend_tests.bat
.\run_all_source_tests.bat --quick
```

## Tüm kaynak testleri

```powershell
.\run_all_source_tests.bat --paths tests,examples --mode safe
```

## libuv gerçek derleme

```powershell
set UXB_TRY_LIBUV=1
.\run_yama7_libuv_backend_tests.bat
set UXB_TRY_LIBUV=
```

## oneTBB gerçek derleme

```powershell
set UXB_TRY_TBB=1
.\run_yama8_tbb_backend_tests.bat
set UXB_TRY_TBB=
```

## Ek araç runnerları

```powershell
.\run_adim36_full_surface_tests.bat --max-tests 20
.\run_uxbrarp.bat
```

`run_adim36_full_surface_tests.bat` eski wrapper yoluna değil güncel `bin\uxb.exe` dosyasına gider.
`run_uxbrarp.bat` varsa `tools\tools\uxbrarp.py`, yoksa `tools\uxbrarp.py` arar.
