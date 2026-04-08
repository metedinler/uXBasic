# uXbasic

uXbasic, ubasic031 kod tabaninin Windows 11 odakli ve FreeBASIC temelli yeniden yapilandirilmis devamidir.

## Ilk Hedefler
- 32-bit kod uretim hattini korumak
- Eklenen yeni syntaxi (INLINE, operator genisletmesi, TIMER unit) parser seviyesinde oturtmak
- Eski davranisi kirilmadan test etmek

## Bu klasorde neler var
- `spec/LANGUAGE_CONTRACT.md`: normatif dil sozlesmesi (R2)
- `src/`: lexer/parser/codegen cekirdegi
- `tests/manifest.csv`: test kayit iskeleti
- `tests/run_manifest.bas`: ilk 10 `pending` test icin smoke harness
- `build.bat`: ilk derleme komutu
- `build_32.bat`: 32-bit derleme
- `build_64.bat`: 64-bit derleme
- `build_matrix.bat`: 32+64 birlikte dogrulama

## Hizli calistirma
- Derleme: `build.bat src\main.bas`
- Smoke test derleme: `build.bat tests\run_manifest.bas`
- Smoke test calistirma: `tests\run_manifest.exe`
- CMP interop test derleme: `build.bat tests\run_cmp_interop.bas`
- CMP interop test calistirma: `tests\run_cmp_interop.exe`
- 32-bit derleme: `build_32.bat src\main.bas`
- Win64 toolchain kurulum: `tools\setup_win64_toolchain.bat`
- 64-bit derleme: `build_64.bat src\main.bas`
- Matrix derleme: `build_matrix.bat src\main.bas`

## Interop Artefaktlari (Sira 16)
- `dist/cmp_interop/import_build_manifest.csv`
- `dist/cmp_interop/import_link_args.rsp`
- `dist/cmp_interop/import_link_plan_win11.txt`

## Mini release otomasyonu (Sira 13)
- Cikti esleme dosyasi: `release/ci_outputs.map`
- Checklist: `release/RELEASE_CHECKLIST.md`
- Paketleme: `tools/release_mini.bat v0.1.X-mini`
- Paketleme + yayin: `tools/release_mini.bat v0.1.X-mini --publish`

## Durum Ozeti
- Parser artik gercek AST node havuzu uretir.
- Token listesi kapasite bazli dinamik buyume modeli kullanir.

## Not
Bu proje strict syntax modunda sonek tip belirteclerini (`$`, `%`, `&`, `!`, `#`, `@`) kabul etmez.
`@` yalnizca operator olarak kullanilir.
