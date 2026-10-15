# 04 — ADIM2: Lexer ve Preprocessor

## Amaç

Lexer surface genişliği korunacak. Token sistemi hızlı ve hataya kapalı hale getirilecek. Preprocessor meta komutları lexer yaşam döngüsüne açık şekilde bağlanacak.

## Çözülecek sorunlar

```text
Token.kind string karşılaştırması.
Keyword Select Case büyümesi.
ShouldTreatAsKeyword bağlam yetersizliği.
Meta komutların lexer/preprocessor route'u belirsiz.
```

## Oluşturulacak/değiştirilecek modüller

```text
src/parser/token_kinds.fbs
src/parser/lexer/lexer_keyword_map.fbs
src/parser/lexer/lexer_context_keyword_policy.fbs
src/parser/lexer/lexer_dump_tokens.fbs
src/parser/lexer/lexer_preprocessor_meta_table.fbs
tools/control/uxb_lexer_surface_audit.py
```

## İş planı

```text
1. Token.kind string alanını hemen silme; TokKind enum alanını paralel ekle.
2. Lexer tüm tokenlarda kindId/TokKind doldursun.
3. Parser geçiş dönemi boyunca string ve enum uyumluluğunu korusun.
4. Keyword lookup için hash tablo ekle.
5. ShouldTreatAsKeyword kuralına FUNCTION/SUB/TYPE/CLASS/NAMESPACE/MODULE/PROPERTY/OPERATOR sonrası isimleri ekle.
6. %% meta komutlarını COMPILE_TIME_PREPROCESS route'una bağla.
7. --dump-tokens JSON/CSV üret.
```

## Pozitif testler

```text
IF x THEN PRINT x
DIM IF AS I32  ' keyword bağlamında isim olarak kullanılacaksa policy açık olmalı
FUNCTION ABS()
END FUNCTION
%%IF PLATFORM = "WIN64"
%%ENDIF
```

## Negatif testler

```text
Bilinmeyen %% komut MISSING değil, META_UNKNOWN diagnostic üretmeli.
Yanlış kapanan %%IF/%%ENDIF preprocessor gate FAIL vermeli.
Token.kindId boş kalan token varsa lexer gate FAIL.
```

## Çıktı

```text
reports/control/current/lexer_token_dump.csv
reports/control/current/lexer_keyword_policy_report.csv
reports/control/current/lexer_gate.json
reports/control/current/lexer_gate.md
```
