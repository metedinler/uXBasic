# uXBasic kümülatif kütüphane sistemi yaması

Bu paket önceki ana ABI10/kütüphane yaması ile 03.07.2026 build düzeltmesini tek ZIP içinde birleştirir.
Ayrı yamaları hangi sırayla uyguladığınızı bilmeniz gerekmez.

Uygulama:

1. ZIP'i doğrudan mevcut `uxb` klasörüne açın.
2. Dosyaların üzerine yazılmasına izin verin.
3. Toolchain denetimini çalıştırın.
4. Önce core build çalıştırın.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\resolve_uxb_toolchain.ps1 `
  -Root . -RequireCompiler -RequireNative

.\BUILD_UXB_LIBRARY_SYSTEM.bat
```

Core başarılı olduktan sonra:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.bat -Set all -StrictAll
```

Statik bindirme doğrulaması:

- source gate: 188/188 PASS
- wrapper-C ABI: 542 çağrı, 0 hata
- layout doctor: 87/87 PASS
