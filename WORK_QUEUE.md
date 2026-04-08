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
- Durum: planlandi
- Gorev: INLINE modeline gecis ve `_` komutlarin kapatilmasi
- Sorumlu: Agent-Syntax
- Cikti: parser semantik kontrolu (sonraki commit)

## Sira 4 - Timer Genisletmesi
- Durum: planlandi
- Gorev: `TIMER(unit)` ve `TIMER(start,end,unit)` parser/runtime iskeleti
- Sorumlu: Agent-Runtime
- Cikti: parser + runtime taslagi (sonraki commit)

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
- Durum: planlandi
- Gorev: lokal toolchain setup scriptini CI adimlariyla birlestirmek
- Sorumlu: Agent-ReleaseInfra
- Cikti: CI matrix ve setup dokumani guncellemeleri
