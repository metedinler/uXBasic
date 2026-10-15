# Copilot Step7B Görevi — Kütüphane Import Sistemi

Copilot, bu görevde compiler çekirdeğini değiştirmeden ekli kütüphane paketlerini UXBc sistemine bağlayacaksın.

## Önce çalıştır

```bat
uxb\compiler\scripts\audit_uxb_library_bundle.bat library_bundle_zips
```

Sonra oku:

```text
uxb\dist\libraries\library_import_report.md
uxb\dist\libraries\library_conflicts.csv
uxb\dist\libraries\library_registry.md
```

## Kurallar

1. `uxb/src` compiler çekirdeğine dokunma.
2. `libs/`, `uxb/runtime_ext/`, `uxb/tests/`, `uxb/docs/`, `uxb/compiler/scripts/` alanlarına import yapılır.
3. Çakışan dosya silinmez; emekliye alınır.
4. Aynı hash ise tekrar kopyalanmaz.
5. Her modül registry içine yazılır.
6. Her modül için `.uxmh` header üretilir.
7. Dış bağımlılık isteyen modüller için `TOOLCHAIN_OR_DEP_MISSING` raporlanır.
8. Sahte PASS yok.
9. Runtime DLL build scriptleri varsa `build_imported_library_runtimes.bat` ile denenir.
10. Smoke scriptleri varsa `run_imported_library_smokes.bat` ile denenir.
11. VSCode komut contract'a kütüphane komutları eklenir.
12. Gerçek debugger işi yok.

## Copilot'un dolduracağı yerler

- VSCode package.json içine şu komutları ekle:
  - `uxbasic.auditLibraries`
  - `uxbasic.importLibraries`
  - `uxbasic.buildLibraryRuntimes`
  - `uxbasic.runLibrarySmokes`

- `extension.js` içinde bu komutları terminalde çalıştır:
  - `uxb\compiler\scripts\audit_uxb_library_bundle.bat library_bundle_zips`
  - `uxb\compiler\scripts\import_uxb_library_bundle.bat library_bundle_zips`
  - `uxb\compiler\scripts\build_imported_library_runtimes.bat`
  - `uxb\compiler\scripts\run_imported_library_smokes.bat`

## Kabul şartları

1. Import dry-run çalışır.
2. Gerçek import çalışır.
3. Registry dosyaları oluşur.
4. `uxb/include/libs.uxmh` oluşur.
5. Runtime build denemeleri raporlanır.
6. Smoke test denemeleri raporlanır.
7. Çakışmalar raporlanır.
8. Kaynak çekirdek bozulmaz.
