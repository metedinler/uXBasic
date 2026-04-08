# uXbasic Work Queue (Plan-Aligned)

## Sira 1 - Parser Cekirdegi
- Durum: tamamlandi
- Gorev: lexer operator seti genisletmesi (`++`, `--`, `+=`, `-=`, `=+`, `=-`, `**`, `@`)
- Sorumlu: Agent-Lexer
- Cikti: `src/parser/lexer.fbs`

## Sira 2 - Legacy Davranis Portu
- Durum: tamamlandi
- Gorev: KEYWORD2.BAS `GetCommands` davranisini FreeBASIC'e tasima
- Sorumlu: Agent-Port
- Cikti: `src/legacy/get_commands_port.fbs`

## Sira 3 - Syntax Geçis Kurallari
- Durum: tamamlandi
- Gorev: INLINE modeline gecis ve `_` komutlarin kapatilmasi
- Sorumlu: Agent-Syntax
- Cikti: parser semantik kontrolu + manifest negatif testleri

## Sira 4 - Timer Genisletmesi
- Durum: tamamlandi
- Gorev: `TIMER(unit)` ve `TIMER(start,end,unit)` parser/runtime iskeleti
- Sorumlu: Agent-Runtime
- Cikti: parser TIMER imza dogrulama + `src/runtime/timer.fbs` + manifest testleri

## Sira 5 - Dogrulama
- Durum: tamamlandi
- Gorev: test manifestinden ilk 10 testi kosacak harness
- Sorumlu: Agent-QA
- Cikti: `tests/run_manifest.bas` (manifest tabanli smoke runner)

## Sira 6 - Gercek AST Uretimi
- Durum: tamamlandi
- Gorev: parseri gercek AST node havuzu uretecek sekilde calistirmak
- Sorumlu: Agent-Parser
- Cikti: `src/parser/ast.fbs`, `src/parser/parser.fbs`

## Sira 7 - Dinamik Token Yonetimi
- Durum: tamamlandi
- Gorev: token listesinde kapasite-bazli dinamik buyume modeli
- Sorumlu: Agent-LexerCore
- Cikti: `src/parser/token_kinds.fbs`

## Sira 8 - Windows 11 x64 Refaktor Hazirligi
- Durum: basladi
- Gorev: ABI farklari, build matrix ve test matrix tanimlarini kod tabanina dagitmak
- Sorumlu: Agent-Backend64
- Cikti: plan ekleri + build/test scriptleri

## Sira 9 - Programci El Kitabi
- Durum: tamamlandi
- Gorev: tum planlanan komut/fonksiyon, kurallar ve syntax dokumani
- Sorumlu: Agent-Docs
- Cikti: `ProgramcininElKitabi.md`

## Sira 10 - Win64 Toolchain Tamamlama
- Durum: tamamlandi
- Gorev: win64 kutuphane iceren FreeBASIC toolchain'i yazilabilir proje klasorune entegre etmek
- Sorumlu: Agent-Toolchain
- Cikti: green `build_64.bat` + green `build_matrix.bat`

## Sira 11 - Kontrol Akisi AST Kapsami
- Durum: tamamlandi
- Gorev: IF/ELSE, SELECT/CASE, FOR/NEXT, DO/LOOP parser AST kapsami
- Sorumlu: Agent-ParserFlow
- Cikti: `src/parser/parser.fbs`, `tests/manifest.csv`, `tests/run_manifest.bas`

## Sira 12 - Win64 CI/Kurulum Sertlestirme
- Durum: tamamlandi
- Gorev: lokal toolchain setup scriptini CI adimlariyla birlestirmek
- Sorumlu: Agent-ReleaseInfra
- Cikti: `.github/workflows/win64-ci.yml` + matrix kapisi

## Sira 13 - Release Otomasyon Sertlestirme
- Durum: tamamlandi
- Gorev: mini release checklistini CI ciktilariyla senkron tutmak
- Sorumlu: Agent-ReleaseInfra
- Cikti: `release/ci_outputs.map`, `release/RELEASE_CHECKLIST.md`, `tools/release_mini.bat`

## Sira 14 - EK-19 Parser ve Manifest Fazi
- Durum: tamamlandi
- Gorev: `DIM init`, `INCLUDE`, `IMPORT (C/CPP/ASM)` parser grammar ve smoke test kapsami
- Sorumlu: Agent-ParserCompat
- Cikti: `src/parser/lexer.fbs`, `src/parser/parser.fbs`, `tests/manifest.csv`, `tests/run_manifest.bas`

## Sira 15 - EK-19 Resolver ve Build Entegrasyonu
- Durum: basladi
- Gorev: INCLUDE resolver + IMPORT build manifest/link entegrasyonu (Win11-x64)
- Sorumlu: Agent-BuildInterop
- Cikti: parser sonrasi dosya-cozumleyici + build baglayici katman + `CMP-*` uyumluluk artefaktlari

## Sira 15.A - EK-22 Moduler Parser/Lexer Refaktor (Faz-2A)
- Durum: tamamlandi
- Gorev: parser ve lexer monolitik yapisini konu bazli modullere ayirmak
- Sorumlu: Agent-ParserMod
- Cikti:
	- `src/parser/lexer.fbs` orchestrator + `src/parser/lexer/*`
	- `src/parser/parser.fbs` orchestrator + `src/parser/parser/*`

## Sira 15.B - EK-22 Parser Guvenlik Kapisi (Path Hijyen)
- Durum: tamamlandi
- Gorev: `INCLUDE`/`IMPORT` path girdilerinde unsafe karakter ve uzanti denetimi
- Sorumlu: Agent-SecureParse
- Cikti: `src/parser/parser/parser_stmt_decl.fbs`

## Sira 16 - EK-19 Resolver/Link Faz-2B
- Durum: basladi
- Gorev: parser-sonrasi INCLUDE resolver ve IMPORT build manifest/link entegrasyonu
- Sorumlu: Agent-BuildInterop
- Cikti: include-once resolver + build manifest baglayici + `CMP-*` uyumluluk artefaktlari
