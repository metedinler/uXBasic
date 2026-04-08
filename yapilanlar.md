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

## 2026-04-08 (EK-23 IMPORT Syntax + Sira 8 Komut Matrisi)

### Kod Degisikligi
- `IMPORT` parser syntax'i normalize edildi:
	- Yeni zorunlu format: `IMPORT(<LANG>, "file")`
	- Uygulama: `src/parser/parser/parser_stmt_decl.fbs`
- Manifest `IMPORT` test girdileri yeni syntax'a tasindi:
	- `tests/manifest.csv`
- Dil sozlesmesi guncellendi:
	- `spec/LANGUAGE_CONTRACT.md`

### Sira 8 Ilerleme (Komutlari Tek Tek Compiler'a Alma)
- Komut kapsama izleme matrisi acildi:
	- `tests/plan/command_compatibility_win11.csv`
- Kuyruk guncellendi:
	- `WORK_QUEUE.md` icine `Sira 8.A` (matris izleme) ve `Sira 8.B` (IMPORT normalizasyonu) eklendi.

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 24 / Fail 0`.

## 2026-04-08 (EK-24 Sira 8 File I/O Komut Dalgasi)

### Kod Degisikligi
- Parser I/O komut modulu eklendi:
	- `src/parser/parser/parser_stmt_io.fbs`
- Dispatch'e yeni komut dallari eklendi:
	- `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser orchestrator include listesi guncellendi:
	- `src/parser/parser.fbs`
- Lexer operator setine `#` eklendi (BASIC file-handle uyumu):
	- `src/parser/lexer/lexer_readers.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-OPEN-001`, `TST-CLOSE-001`, `TST-GET-001`, `TST-PUT-001`, `TST-SEEK-001`
- Runner expected etiketleri eklendi:
	- `OPEN_OK`, `CLOSE_OK`, `GET_OK`, `PUT_OK`, `SEEK_OK`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 29 / Fail 0`.
- Komut kapsama matrisi guncellendi:
	- `tests/plan/command_compatibility_win11.csv`

## 2026-04-08 (EK-25 Sira 16 Resolver/Link Faz-2B)

### Kod Degisikligi
- Parser-sonrasi include/import cozumleyici ve build baglayici modulu eklendi:
	- `src/build/interop_manifest.fbs`
- Ana calistiriciya kaynak-dosya parametresi ve interop emit akisi eklendi:
	- `src/main.bas`
- CMP harness testi eklendi:
	- `tests/run_cmp_interop.bas`
- Resolver/link fixture seti eklendi:
	- `tests/fixtures/interop/*`

### Plan/Matris Guncellemeleri
- `tests/plan/cmp_interop_win11.csv` eklendi.
- `tests/plan/command_compatibility_win11.csv` icinde INCLUDE/IMPORT satirlari `parser+resolver` ve `parser+build-manifest` katmanina cekildi.

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 29 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

### Uretilen Artefaktlar
- `dist/cmp_interop/import_build_manifest.csv`
- `dist/cmp_interop/import_link_args.rsp`
- `dist/cmp_interop/import_link_plan_win11.txt`

## 2026-04-08 (EK-26 Sira 8 I/O UI Komut Dalgasi)

### Kod Degisikligi
- Lexer keyword tablosuna `LOF`, `EOF` eklendi:
	- `src/parser/lexer/lexer_keyword_table.fbs`
- `LOF(n)`/`EOF(n)` icin tek arguman call dogrulamasi eklendi:
	- `src/parser/parser/parser_shared.fbs`
	- `src/parser/parser/parser_expr.fbs`
- Ekran komut parserlari eklendi:
	- `LOCATE`, `COLOR`, `CLS`
	- `src/parser/parser/parser_stmt_io.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-LOF-001`, `TST-EOF-001`, `TST-LOCATE-001`, `TST-COLOR-001`, `TST-CLS-001`
- Runner expected etiketleri eklendi:
	- `LOF_OK`, `EOF_OK`, `LOCATE_OK`, `COLOR_OK`, `CLS_OK`
- Smoke run limiti 80'e cekildi:
	- `tests/run_manifest.bas`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `LOF`, `EOF`, `LOCATE`, `COLOR`, `CLS`

## 2026-04-08 (EK-27 Sira 8 Flow Komut Dalgasi)

### Kod Degisikligi
- Flow komut parserlari eklendi:
	- `GOTO`, `GOSUB`, `RETURN`, `EXIT`
	- `src/parser/parser/parser_stmt_flow.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-GOTO-001`, `TST-GOSUB-001`, `TST-RETURN-001`, `TST-EXIT-001`, `TST-EXIT-FAIL-001`
- Runner expected etiketleri eklendi:
	- `GOTO_OK`, `GOSUB_OK`, `RETURN_OK`, `EXIT_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `GOTO`, `GOSUB`, `RETURN`, `EXIT`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 39 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-08 (EK-28 Sira 8 Procedure Komut Dalgasi)

### Kod Degisikligi
- Procedure parserlari eklendi:
	- `DECLARE`, `SUB`, `FUNCTION`
	- `src/parser/parser/parser_stmt_decl.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-DECLARE-SUB-001`, `TST-DECLARE-FUNC-001`, `TST-SUB-001`, `TST-FUNCTION-001`, `TST-DECLARE-FAIL-001`
- Runner expected etiketleri eklendi:
	- `DECLARE_OK`, `SUB_OK`, `FUNCTION_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `DECLARE`, `SUB`, `FUNCTION`
- `spec/LANGUAGE_CONTRACT.md` prosedur grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 44 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-08 (EK-29 Sira 8 Tanim Komut Dalgasi)

### Kod Degisikligi
- Tanim parserlari eklendi:
	- `CONST`, `REDIM`, `TYPE`
	- `src/parser/parser/parser_stmt_decl.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-CONST-001`, `TST-REDIM-001`, `TST-TYPE-001`, `TST-TYPE-FAIL-001`
- Runner expected etiketleri eklendi:
	- `CONST_OK`, `REDIM_OK`, `TYPE_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `CONST`, `REDIM`, `TYPE`
- `spec/LANGUAGE_CONTRACT.md` type/constant grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 48 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-08 (EK-30 Sira 8 Input Komut Dalgasi)

### Kod Degisikligi
- Input parserlari eklendi:
	- `INPUT`, `INPUT#`
	- `src/parser/parser/parser_stmt_io.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-INPUT-001`, `TST-INPUT-PROMPT-001`, `TST-INPUTF-001`, `TST-INPUTF-FAIL-001`
- Runner expected etiketleri eklendi:
	- `INPUT_OK`, `INPUT_FILE_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `INPUT`, `INPUT#`
- `spec/LANGUAGE_CONTRACT.md` input grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 52 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-31 Sira 8 Core Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keywordleri eklendi:
	- `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Call arguman dogrulama yardimcilari eklendi:
	- `src/parser/parser/parser_shared.fbs`
- Expression seviyesinde intrinsic call validation eklendi:
	- `src/parser/parser/parser_expr.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-LEN-001`, `TST-MID-001`, `TST-STR-001`, `TST-VAL-001`, `TST-ABS-001`, `TST-INT-001`, `TST-UCASE-001`, `TST-LCASE-001`, `TST-ASC-001`, `TST-CHR-001`, `TST-MID-FAIL-001`
- Runner expected etiketleri eklendi:
	- `LEN_OK`, `MID_OK`, `STR_OK`, `VAL_OK`, `ABS_OK`, `INT_OK`, `UCASE_OK`, `LCASE_OK`, `ASC_OK`, `CHR_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 63 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-32 Sira 8 Varsayilan Tip Komut Dalgasi)

### Kod Degisikligi
- Varsayilan tip keywordleri eklendi:
	- `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Varsayilan tip parserlari eklendi:
	- `ParseDefTypeStmt`, `ParseSetStringSizeStmt`
	- `src/parser/parser/parser_stmt_decl.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-DEFINT-001`, `TST-DEFLNG-001`, `TST-SETSTRINGSIZE-001`, `TST-SETSTRINGSIZE-FAIL-001`
- Runner expected etiketleri eklendi:
	- `DEFTYPE_OK`, `SETSTRINGSIZE_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`, `SETSTRINGSIZE`
- `spec/LANGUAGE_CONTRACT.md` varsayilan tip grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 67 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-33 Sira 8 Program Sonlandirma Komut Dalgasi)

### Kod Degisikligi
- END parseri eklendi:
	- `ParseEndStmt`
	- `src/parser/parser/parser_stmt_flow.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satiri eklendi:
	- `TST-END-001`
- Runner expected etiketi eklendi:
	- `END_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komut `implemented` oldu:
	- `END`
- `spec/LANGUAGE_CONTRACT.md` program sonlandirma basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 68 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-34 Sira 8 String/Trig Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keywordleri eklendi:
	- `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-LTRIM-001`, `TST-RTRIM-001`, `TST-STRING-001`, `TST-SPACE-001`, `TST-SGN-001`, `TST-SQRT-001`, `TST-SIN-001`, `TST-COS-001`, `TST-TAN-001`, `TST-STRING-FAIL-001`
- Runner expected etiketleri eklendi:
	- `LTRIM_OK`, `RTRIM_OK`, `STRING_OK`, `SPACE_OK`, `SGN_OK`, `SQRT_OK`, `SIN_OK`, `COS_OK`, `TAN_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 78 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-35 Sira 8 INKEY Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keyword eklendi:
	- `INKEY`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `INKEY(1..2)`, `INKEY_LEGACY(0)`
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-INKEY-001`, `TST-INKEY-002`, `TST-INKEY-FAIL-001`, `TST-INKEY-LEGACY-001`, `TST-INKEY-LEGACY-FAIL-001`
- Runner expected etiketleri eklendi:
	- `INKEY_OK`, `INKEY_LEGACY_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `INKEY`, `INKEY_LEGACY`

## 2026-04-09 (EK-36 Sira 8 Math Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keywordleri eklendi:
	- `ATN`, `EXP`, `LOG`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `ATN(1)`, `EXP(1)`, `LOG(1)`
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-ATN-001`, `TST-EXP-001`, `TST-LOG-001`, `TST-ATN-FAIL-001`
- Runner expected etiketleri eklendi:
	- `ATN_OK`, `EXP_OK`, `LOG_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `ATN`, `EXP`, `LOG`

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 87 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-37 Sira 8 DEF* Test Kapsami Tamamlama)

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-DEFSNG-001`, `TST-DEFDBL-001`, `TST-DEFEXT-001`, `TST-DEFSTR-001`, `TST-DEFBYT-001`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlarin `test_ref` alani gercek test id ile guncellendi:
	- `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 92 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`
