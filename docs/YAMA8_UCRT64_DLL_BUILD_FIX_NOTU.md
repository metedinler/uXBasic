# Yama 8 UCRT64 DLL build fix

Bu yama `native\uxb_runtime\build_runtime_dll.bat` dosyasını sade ASCII batch olarak yeniler.

Kök sebep:
- PowerShell'de `-Wl,--enable-auto-import` tırnaksız verilirse virgül ayrıştırma hatası üretir.
- Önceki BAT dosyasında Türkçe/karmaşık satırlar CMD tarafından komut gibi çalıştırılabiliyordu.
- UCRT64 başlıkları `C:\msys64\ucrt64` altında mevcutken komut `C:\msys64\mingw64` yolunu kullanıyordu.

Tek doğru UCRT64 kullanım:

```powershell
$env:UXB_MINGW_ROOT = "C:\msys64\ucrt64"
$env:PATH = "C:\msys64\ucrt64\bin;" + $env:PATH
.\native\uxb_runtime\build_runtime_dll.bat --libuv
.\native\uxb_runtime\build_runtime_dll.bat --tbb
.\native\uxb_runtime\build_runtime_dll.bat --libuv --tbb
```

PowerShell alternatifi:

```powershell
.\native\uxb_runtime\build_runtime_dll.ps1 -libuv
.\native\uxb_runtime\build_runtime_dll.ps1 -tbb
.\native\uxb_runtime\build_runtime_dll.ps1 -libuv -tbb
```
