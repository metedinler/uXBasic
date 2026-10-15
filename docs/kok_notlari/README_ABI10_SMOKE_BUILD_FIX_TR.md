# ABI10 Smoke DLL Build Fix

Bu yama yalnız ABI10 smoke test DLL derlemesini düzeltir. Core DLL build, libuv, oneTBB ve x64 compiler kaynaklarına dokunmaz.

Düzeltilen sorun:

- Eski `build_abi10_test_dll.bat` GCC yolunu sabit `C:\msys64\ucrt64\bin\gcc.exe` kabul ediyordu.
- Hata olduğunda ayrıntılı GCC logu üretmiyordu.
- `BUILD_UXB_LIBRARY_SYSTEM.bat` sonunda yalnız `ABI10 test DLL build failed` yazıyordu; kök sebep görünmüyordu.

Yeni davranış:

- Öncelik sırası: `-Gcc`, `UXB_GCC`, `GCC`, `x86_64-w64-mingw32-gcc.exe`, `gcc.exe`.
- Log dosyası: `reports\libraries\logs\abi10_test_dll_gcc.log`.
- DLL kopyaları: `bin\uxb_abi10_test.dll` ve `dist\libraries\bin\uxb_abi10_test.dll`.
- Import library: `dist\libraries\lib\libuxb_abi10_test.dll.a`.

Çalıştırma:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
.\tests\libraries\abi10\build_abi10_test_dll.bat
.\compiler\scripts\run_library_abi10_smoke.ps1 -Root . -SkipBuild
.\BUILD_UXB_LIBRARY_SYSTEM.bat
```
