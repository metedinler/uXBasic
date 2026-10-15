# 05 — ADIM3: Parser, Scope Başlangıcı ve Error Recovery

## Amaç

Parser tek hatada çökmeden kontrollü hata toparlama yapacak. Parser yüzeyi AST contract'a doğru veri verecek.

## Çözülecek sorunlar

```text
Parser error recovery yok veya zayıf.
ParseState namespace/module/main sayaçları var ama gerçek qualifier/scope stack zayıf.
Komut handler registry var ama surface lifecycle ile bağlantı eksik.
```

## Değiştirilecek/eklenecek modüller

```text
src/parser/parser/parser_error_recovery.fbs
src/parser/parser/parser_sync_sets.fbs
src/parser/parser/parser_scope_qualifier_stack.fbs
src/parser/parser/parser_stmt_registry_gate.fbs
src/parser/parser/parser_surface_bridge.fbs
```

## İş planı

```text
1. ParserError fonksiyonu hata kaydı + sync noktasına atlama yapacak.
2. Sync token seti: EOL, EOF, END, ELSE, ELSEIF, CASE, NEXT, LOOP, FUNCTION, SUB, CLASS, TYPE.
3. qualifierStack eklenecek; NAMESPACE/MODULE/CLASS/FUNCTION owner bilgisi AST node'a yazılacak.
4. Parser registry ile surface matrix eşlenecek.
5. Her parser handler için evidence_file üretilecek.
```

## Pozitif testler

```basic
PRINT "a"
IF x THEN
    PRINT x
END IF
FUNCTION f(a AS I32) AS I32
    RETURN a
END FUNCTION
```

## Negatif testler

```basic
IF x THEN
    PRINT x
' END IF eksik
PRINT "sonraki satir"
```

Beklenen: Parser sonraki statement'a toparlanacak, yüzlerce sahte hata üretmeyecek.

## Çıktı

```text
reports/control/current/parser_error_recovery.csv
reports/control/current/parser_registry_surface.csv
reports/control/current/parser_gate.json
reports/control/current/parser_gate.md
```
