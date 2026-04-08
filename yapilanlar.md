# Yapilanlar

## 2026-04-08

### Cok Ajanli Calisma Notlari
- Explore ajanindan gercek AST MVP tasarim ciktilari alindi.
- Explore ajanindan Windows 11 x64 assembler/refaktor fazlama ciktilari alindi.
- Bu ciktilar `.plan.md` ve `WORK_QUEUE.md` dosyalarina append-only yaklasimla yerlestirildi.

### Kod Tarafi
- Dinamik token kapasite yonetimi eklendi.
- Gercek AST node havuzu (`ASTPool`) eklendi.
- Parser, expression precedence ve statement tabanli AST uretir hale getirildi.
- Ana giris, AST dump verisi basacak sekilde guncellendi.

### Plan ve Kuyruk Guncellemeleri
- `.plan.md` icine EK-8 (Gercek AST + Dinamik Token) eklendi.
- `.plan.md` icine EK-9 (Windows 11 x64 assembler/refaktor onceligi) eklendi.
- `WORK_QUEUE.md` durumlari guncellendi; yeni sira 6-8 maddeleri acildi.

### Derleme ve Test
- `build.bat src\\main.bas` dogrulandi.
- `build.bat tests\\run_manifest.bas` dogrulandi.
- `tests\\run_manifest.exe` ile smoke test gecisi alindi.

## Commit Kaydi

### f130059
- Mesaj: feat: bootstrap uXbasic with dynamic token buffer, real AST parser, and Win11 x64 roadmap
- Dosyalar:
	- .gitignore
	- .plan.md
	- README.md
	- UBASIC031_RAPOR.md
	- WORK_QUEUE.md
	- build.bat
	- build_32.bat
	- build_64.bat
	- build_matrix.bat
	- spec/LANGUAGE_CONTRACT.md
	- src/legacy/get_commands_port.fbs
	- src/main.bas
	- src/parser/ast.fbs
	- src/parser/lexer.fbs
	- src/parser/parser.fbs
	- src/parser/token_kinds.fbs
	- tests/manifest.csv
	- tests/run_manifest.bas
	- yapilanlar.md

### 19da56a
- Mesaj: docs: add commit inventory to yapilanlar
- Dosyalar:
	- yapilanlar.md

### Release
- Tag: v0.1.0-mini
- Link: https://github.com/metedinler/uXBasic/releases/tag/v0.1.0-mini
- Eklenen artefaktlar:
	- uXbasic_main.exe
	- uXbasic_main_32.exe
	- uXbasic_manifest_smoke.exe
	- uXbasic-v0.1.0-mini-win32.zip
- Not: 64-bit derleme adimi ortamda `win64 gcc` eksikligi nedeniyle bloklandi; plan EK-9'a oncelikli madde olarak yerlestirildi.

## 2026-04-08 (Ek Calisma)

### Win64 GCC Kontrol Sonucu
- Sistemde GCC/MinGW bulundu (`x86_64-w64-mingw32-gcc` dahil).
- FreeBASIC kurulumunda yalnizca `lib/win32` oldugu dogrulandi; `lib/win64` yok.
- Program Files altinda yazma izni olmadigi icin global kurulum duzeyi dogrudan duzeltilemedi.
- Plan append-only olarak guncellendi: EK-10 (win64 toolchain gercek durum ve eylem plani).

### Dokumantasyon
- `ProgramcininElKitabi.md` olusturuldu.
- Dosyada: 5 paragraflik giris, 3 paragraflik 5000+ kelime tarihsel hikaye, tum planlanan komut/fonksiyon ve syntax/kurallar yer aldi.
- Plan append-only olarak guncellendi: EK-11 (cok ajanli dokumantasyon fazi).

### ed79991
- Mesaj: docs: add programmer handbook and append win64 toolchain multi-agent plan updates
- Dosyalar:
	- .plan.md
	- ProgramcininElKitabi.md
	- WORK_QUEUE.md
	- yapilanlar.md

## 2026-04-08 (Cok Ajanli Teknik Faz)

### Win64 Toolchain
- Proje-ici yazilabilir FreeBASIC win64 klasoru olusturuldu: `tools/FreeBASIC-1.10.1-win64`.
- Otomatik kurulum scripti eklendi: `tools/setup_win64_toolchain.bat`.
- `build_64.bat` lokal toolchain'e baglandi.
- `build_matrix.bat` dogrulandi: 32-bit + 64-bit green.

### Parser AST Kapsami
- `src/parser/parser.fbs` IF/ELSE/END IF, SELECT CASE/CASE ELSE/END SELECT, FOR/NEXT, DO/LOOP node uretir hale getirildi.
- `src/parser/lexer.fbs` icine FOR akisinda gerekli `TO`, `STEP` keywordleri eklendi.

### Manifest AST Dogrulama
- `tests/manifest.csv` icine kontrol-akis AST testleri eklendi.
- `tests/run_manifest.bas` AST node varlik kontrolleriyle genisletildi.
- Son test cikisi: Run 10, Pass 10, Fail 0.

### b8523e7
- Mesaj: feat: local win64 toolchain setup and control-flow AST parser coverage
- Dosyalar:
	- .gitignore
	- .plan.md
	- README.md
	- WORK_QUEUE.md
	- build_64.bat
	- src/main.bas
	- src/parser/lexer.fbs
	- src/parser/parser.fbs
	- tests/manifest.csv
	- tests/run_manifest.bas
	- tools/setup_win64_toolchain.bat
	- yapilanlar.md

## 2026-04-08 (CI Sertlestirme)

### CI Workflow
- `.github/workflows/win64-ci.yml` eklendi.
- Is akisinda: checkout, proje-ici win64 toolchain setup, `build.bat` ile ana derleme, manifest test derleme/calismasi, artefakt upload adimlari tanimlandi.

### Plan/Kuyruk
- `.plan.md` icine EK-13 append-only eklendi (CI sonucu release kapisi olarak tanimlandi).
- `WORK_QUEUE.md` Sira 12 tamamlandi, Sira 13 release otomasyon sertlestirme olarak acildi.

## 2026-04-08 (Release Otomasyon Sertlestirme)

### Cok Ajanli Cikti Uygulamasi
- DevOps ve Git workflow odakli alt-ajan cikarimlari birlestirildi.
- CI-release dosya esleme katmani eklendi: `release/ci_outputs.map`.
- Release checklist eklendi: `release/RELEASE_CHECKLIST.md`.
- Paketleme/yayin scripti eklendi: `tools/release_mini.bat`.

### Plan Kapsami Durumu
- `WORK_QUEUE.md` Sira 13 tamamlandi.
- `.plan.md` icine EK-14 append-only eklendi.

## 2026-04-08 (Syntax Gecis Kurallari - Sira 3)

### Kod Degisikligi
- `src/parser/parser.fbs` icine legacy inline adlarini reddeden kontrol eklendi (`_ASM`, `ASM_SUB`, `ASM_FUNCTION`).
- `src/parser/parser.fbs` icine `_` komut kapatma kontrolu eklendi; atama/incdec kullanimlari korunarak yalanci pozitifler onlendi.

### Test Guncellemeleri
- `tests/manifest.csv` icine iki negatif (`parse_fail`) ve bir pozitif (`parse_ok`) gecis testi eklendi.
- `tests/run_manifest.bas` `PARSE_FAIL` etiketiyle beklenti dogrulamasini destekler hale getirildi.
- Smoke ozeti: `Pass 13 / Fail 0`.

## 2026-04-08 (Timer Genisletmesi - Sira 4)

### Kod Degisikligi
- `src/parser/parser.fbs` icine `TIMER` imza/birim dogrulamasi eklendi (`0`, `1`, `3` arguman).
- `src/runtime/timer.fbs` ile runtime iskeleti eklendi (`TimerNow`, `TimerRange` ve birim donusumleri).
- `src/main.bas` runtime include ile timer iskeletini derleme akisina dahil etti.

### Test Guncellemeleri
- `tests/manifest.csv` icine timer-range pozitif ve bad-unit negatif testleri eklendi.
- `tests/run_manifest.bas` smoke limiti 15 satir olacak sekilde guncellendi.
- Smoke ozeti: `Pass 15 / Fail 0`.

## 2026-04-08 (EK-19 Parser/Test Fazi - Cok Ajanli)

### Cok Ajanli Paralel Cikti
- Explore alt-ajanlariyla parser ekleme noktasi ve manifest test tasarimi paralel cikartildi.
- Ciktilar birlestirilerek minimal degisiklikli uygulama plani olusturuldu.

### Kod Degisikligi
- `src/parser/lexer.fbs`: `INCLUDE` ve `IMPORT` keyword listesine eklendi.
- `src/parser/parser.fbs`:
	- `DIM ... AS <tip> = <expr>` parse destegi (`DIM_STMT`, `DIM_DECL`, `INIT_EXPR`).
	- `INCLUDE "..."` parse destegi (`INCLUDE_STMT`).
	- `IMPORT C|CPP|ASM "..."` parse destegi (`IMPORT_STMT`).
- `tests/manifest.csv`: DIM/INCLUDE/IMPORT pozitif-negatif testleri eklendi.
- `tests/run_manifest.bas`:
	- yeni expected etiketleri eklendi (`DIM_INIT_OK`, `INCLUDE_OK`, `IMPORT_OK`).
	- smoke limiti 30'a cikarildi.

### Dogrulama
- Ortamdaki global `fbc` komutunda harici kurulum kaynakli cagrim sorunu goruldu (`qb64-dev.exe` yonlenmesi).
- Proje-ici derleyici ile dogrulama yapildi: `tools/FreeBASIC-1.10.1-win64/fbc.exe`.
- Smoke sonucu: `Pass 24 / Fail 0`.

## 2026-04-08 (EK-22 Modulerlesme + Guvenlik Sertlestirme)

### Kod Degisikligi
- Lexer monolitik dosyasi konu bazli modullere ayrildi:
	- `src/parser/lexer/lexer_core.fbs`
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/lexer/lexer_readers.fbs`
	- `src/parser/lexer/lexer_driver.fbs`
- Parser monolitik dosyasi konu bazli modullere ayrildi:
	- `src/parser/parser/parser_shared.fbs`
	- `src/parser/parser/parser_expr.fbs`
	- `src/parser/parser/parser_stmt_basic.fbs`
	- `src/parser/parser/parser_stmt_decl.fbs`
	- `src/parser/parser/parser_stmt_flow.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Orchestrator modeline gecis:
	- `src/parser/lexer.fbs` alt lexer modullerini include eder hale getirildi.
	- `src/parser/parser.fbs` alt parser modullerini include eder hale getirildi.

### Guvenlik Sertlestirme
- `INCLUDE`/`IMPORT` path parser denetimi aktif edildi.
- Unsafe karakter engeli eklendi (`|`, `&`, `;`, `` ` ``, `<`, `>`, kontrol karakterleri).
- Dil bazli uzanti denetimi eklendi (`.bas`, `.c`, `.cpp/.cc/.cxx`, `.asm/.s`).

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `tests\\run_manifest.exe` sonucu: `Fail: 0`.
- `src/parser` hata taramasi: hata yok.
