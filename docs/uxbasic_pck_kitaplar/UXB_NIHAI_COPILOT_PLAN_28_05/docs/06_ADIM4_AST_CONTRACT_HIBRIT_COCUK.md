# 06 — ADIM4: AST Contract ve Hibrit Çocuk Modeli

## Amaç

AST'nin iki çocuk sistemi bilinçli hale getirilecek. left/right tamamen kaldırılmayacak; sadece expression shortcut olarak sınırlandırılacak.

## Temel karar

```text
firstChild/nextSibling = genel kanonik çocuk sistemi
left/right = sadece BINARY/UNARY expression shortcut
statement/block/OOP node'larında left/right kullanılmayacak
```

## Çözülecek sorunlar

```text
ASTNode.kind string karşılaştırması.
left/right ve firstChild/nextSibling modelinin sözleşmesiz karışması.
AST contract coverage boşlukları.
```

## Değiştirilecek/eklenecek modüller

```text
src/parser/ast_node_kinds.fbs
src/parser/ast_contract_child_model.fbs
src/parser/ast_contract_validate.fbs
src/parser/ast_child_accessors.fbs
tools/control/uxb_ast_contract_matrix.py
```

## İş planı

```text
1. ASTNode.kind string kalsın; nodeKind enum paralel eklensin.
2. Parser AST node üretirken nodeKind doldursun.
3. ASTChildAt, ASTRoleChild, ASTLeft, ASTRight helper'ları standartlaştırılsın.
4. Contract şunu doğrulasın:
   - BINARY: left/right zorunlu
   - UNARY: left zorunlu
   - BLOCK/FUNCTION/CLASS/IF/CALL: firstChild/role sistemi
5. AST contract gate parse sonrası zorunlu çalışsın.
```

## Pozitif testler

```basic
a = b + c
IF a THEN PRINT b ELSE PRINT c
CALL foo(1, 2, 3)
```

## Negatif testler

```text
BLOCK node left/right kullanırsa AST_CONTRACT_FAIL.
BINARY node left veya right eksikse AST_CONTRACT_FAIL.
CALL_EXPR args role yoksa warning/fail.
```

## Çıktı

```text
reports/control/current/ast_child_model_matrix.csv
reports/control/current/ast_contract_gate.json
reports/control/current/ast_contract_gate.md
```
