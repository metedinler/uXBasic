# uXBasic kütüphane build düzeltmesi — 03.07.2026

Bu küçük yama, daha önce uygulanan ABI10/kütüphane yamasını değiştirmez. Yalnızca Windows build zincirindeki iki yapısal hatayı düzeltir:

1. Eski `build_uxb_main_64.bat`, `compiler\scripts` konumundan üç üst klasöre çıkarak yanlış proje kökünü kullanıyordu ve `cmd.exe` FreeBASIC başlamadan `The syntax of the command is incorrect` hatası veriyordu.
2. Birleşik build aracı x64 compiler'ı DLL'lerden önce üretmeye çalışıyordu.

## Yeni sıra

1. Proje içindeki FreeBASIC, MSYS2 GCC ve WABT yollarını bul.
2. Kaynak ve wrapper/C ABI kapılarını çalıştır.
3. Seçilen native DLL'leri üret.
4. DLL ve bağımlılıkları `dist\libraries` ile `bin\` içine yerleştir.
5. Export/x64 kontrolü yap.
6. `tools\FreeBASIC-1.10.1-win64\fbc64.exe` ile x64 `bin\uxb.exe` üret.
7. AST, MIR ve x64 ABI10 testlerini çalıştır.

## Uygulama

ZIP'i doğrudan mevcut `uxb` klasörüne açıp dosyaların üzerine yazdırın. Sonra önce çekirdek sistemi çalıştırın:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.bat
```

Bu başarılı olduktan sonra tüm isteğe bağlı kütüphaneleri deneyin:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.bat -Set all -StrictAll
```

## Araç yolları

Varsayılan olarak şu gerçek yollar tanınır:

- `tools\FreeBASIC-1.10.1-win64\fbc64.exe`
- `tools\FreeBASIC-1.10.1-win64\bin\win64`
- `C:\msys64\ucrt64\bin\gcc.exe`
- `C:\msys64\usr\bin\pacman.exe`
- `tools\wabt\bin\wat2wasm.exe`

Özel kurulumlarda `UXB_FBC`, `UXB_GCC`, `UXB_PKG_CONFIG`, `UXB_PACMAN` ve `UXB_WAT2WASM` ortam değişkenleri kullanılabilir.

## Raporlar

- `reports\libraries\toolchain\toolchain.json`
- `reports\libraries\logs\compiler_x64_build.log`
- `reports\libraries\logs\compiler_x64_fbc.log`
- `reports\libraries\library_build_summary.json`
