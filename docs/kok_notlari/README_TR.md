# UXB Final Ecosystem Hardening — 2026-07-29

Bu paket `uxb(29.07_1).zip` üzerine doğrudan uygulanır ve önceki VS Code
Workbench/QuickJS/WASM geliştirmelerini de içerir.

## Ana düzeltmeler

- `--set all` bütün 45 kanonik kütüphaneyi seçer.
- C full-API ve FreeBASIC A-grubu ana manifest/build sistemine alındı.
- 1115 wrapper çağrısının ABI taraması: 0 hata, 0 uyumsuzluk.
- 45 opaque handle imzası PTR yerine U64 yapıldı.
- `uxmh` C header guard hataları giderildi.
- GNU objdump export envanteri düzeltildi.
- `uxlogic` Lua/Prolog yolları taşınabilir yapıldı; Prolog CreateProcess kullanır.
- Kaynakta gömülü Gemini/OpenRouter/Groq anahtarları kaldırıldı.
- `src/main.c`, hash manifestiyle `build/generated/freebasic_c` altına arşivlenir.
- Root build girişleri, Ecosystem Doctor ve test kapıları eklendi.
- VS Code Toolchain Doctor ekosistem denetimini de çalıştırır.

## Uygulama

```powershell
Expand-Archive .\UXB_FINAL_ECOSYSTEM_HARDENING_20260729_PATCH.zip `
  .\UXB_FINAL_ECOSYSTEM_HARDENING_20260729_PATCH -Force

pwsh .\UXB_FINAL_ECOSYSTEM_HARDENING_20260729_PATCH\APPLY_PATCH.ps1 `
  -Root .
```

Compiler'ı da yeniden üretmek için:

```powershell
pwsh .\UXB_FINAL_ECOSYSTEM_HARDENING_20260729_PATCH\APPLY_PATCH.ps1 `
  -Root . -BuildCompiler
```

Eklentiyi yerel kurmak için `-InstallExtension` ekleyin.

## Sonraki Windows doğrulaması

```powershell
.\RUN_UXB_ECOSYSTEM_DOCTOR.bat --strict-source
.\build_64.bat
.\build_libraries.bat -Set core -FetchDeps -StrictRuntime
.\build_libraries.bat -Set all -FetchDeps -StrictAll -StrictRuntime
```

Eski kaynak dosyalarında bulunmuş API anahtarları ilgili sağlayıcı panellerinden
iptal edilip yenilenmelidir. Yama anahtarları kaynak koddan kaldırır ancak daha
önce oluşturulan ZIP, yedek ve geçmiş kopyalarını değiştiremez.
