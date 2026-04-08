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
- Durum: basladi
- Gorev: parseri gercek AST node havuzu uretecek sekilde calistirmak
- Sorumlu: Agent-Parser
- Cikti: `src/parser/ast.fbs`, `src/parser/parser.fbs`

## Sira 7 - Dinamik Token Yonetimi
- Durum: basladi
- Gorev: token listesinde kapasite-bazli dinamik buyume modeli
- Sorumlu: Agent-LexerCore
- Cikti: `src/parser/token_kinds.fbs`

## Sira 8 - Windows 11 x64 Refaktor Hazirligi
- Durum: planlandi
- Gorev: ABI farklari, build matrix ve test matrix tanimlarini kod tabanina dagitmak
- Sorumlu: Agent-Backend64
- Cikti: plan ekleri + build/test scriptleri
