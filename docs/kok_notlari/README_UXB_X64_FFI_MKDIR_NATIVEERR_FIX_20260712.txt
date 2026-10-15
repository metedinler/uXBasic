# UXB X64 FFI MkDir + NativeCommandError Fix 20260712

Bu yama iki kök sorunu kapatır:

1. `FfiX64BackendEmitArtifacts` mevcut `interop` klasörüne tekrar `MkDir` yapıyordu.
   FreeBASIC bu durumda süreci `errText` üretemeden kesebiliyor; sonuçta `program.asm`
   ve interop manifest oluşuyor ama `ffi_call_x64_plan.csv`, `ffi_resolver.c`,
   `build_all.bat` oluşmadan x64 build yarım kalıyordu.

2. `run_library_abi10_smoke.ps1` `$ErrorActionPreference=Stop` altında native
   `uxb.exe` çağrısındaki stderr/non-zero durumu `NativeCommandError` olarak
   scripti kesiyordu. Artık x64 build çağrısı LASTEXITCODE ve artifact loglarını
   kaydedecek şekilde sarmalandı.
