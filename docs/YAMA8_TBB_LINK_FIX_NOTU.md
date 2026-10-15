# Yama 8 TBB Link Fix

Durum:
- std backend: PASS
- libuv backend: PASS
- TBB backend: link hatasi verdi: cannot find -ltbb

Kok sebep:
MSYS2 UCRT64 tbb paketi import library olarak `libtbb12.dll.a` sagliyor. Bu nedenle g++ link argumani `-ltbb` degil, `-ltbb12` olmali.

Bu yama:
- `native/uxb_runtime/build_runtime_dll.bat` dosyasini sade ASCII batch olarak yazar.
- `--tbb` modunda once `libtbb12.dll.a` arar ve `-ltbb12` kullanir.
- Eski sistemler icin `libtbb.dll.a` varsa `-ltbb` fallback yapar.
- `run_yama7_libuv_backend_tests.bat` artik libuv build'i dogrudan dener.
- `run_yama8_tbb_backend_tests.bat` TBB build'i dogrudan dener.

PowerShell kullanim:
```
$env:UXB_MINGW_ROOT = "C:\msys64\ucrt64"
$env:PATH = "C:\msys64\ucrt64\bin;" + $env:PATH
.\native\uxb_runtime\build_runtime_dll.bat --libuv
.\native\uxb_runtime\build_runtime_dll.bat --tbb
.\native\uxb_runtime\build_runtime_dll.bat --libuv --tbb
```
