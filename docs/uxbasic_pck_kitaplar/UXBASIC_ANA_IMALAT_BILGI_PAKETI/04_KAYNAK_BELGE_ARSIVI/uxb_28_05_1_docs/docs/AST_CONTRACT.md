# uXBasiC AST Sözleşmesi — Stage 2

Bu belge, `parser/ast.fbs` üzerinde davranış değiştirmeden çalışan `parser/ast_contract.fbs` katmanının amacını ve kullanım kuralını tanımlar.

## Amaç

uXBasiC içinde AST iki tarihsel modeli birlikte taşıyor:

```text
left / right              -> eski expression ağacı
firstChild / nextSibling  -> blok, liste, parametre, statement çocukları
parent / role             -> yeni sözleşme ve semantik metadata
```

Bu ikili yapı şu anda çalışır durumdadır; fakat semantic, MIR, interpreter ve codegen katmanları doğrudan alanlara farklı şekillerde erişirse zamanla davranış ayrışır. Stage 2'nin amacı budur: **AST alanlarını silmeden, tek tip ve güvenli gezinme API'si vermek.**

## Temel kural

Yeni kodlarda mümkün olduğunca doğrudan şunlar kullanılmamalı:

```freebasic
ps.ast.nodes(n).firstChild
ps.ast.nodes(n).nextSibling
ps.ast.nodes(n).left
ps.ast.nodes(n).right
ps.ast.nodes(n).role
```

Bunun yerine şu yardımcılar kullanılmalı:

```freebasic
UXBAstIsValidIndex(ps.ast, n)
UXBAstIsExpression(ps.ast, n)
UXBAstIsStatement(ps.ast, n)
UXBAstChildCount(ps.ast, n)
UXBAstChildAt(ps.ast, n, 0)
UXBAstFirstChildByRoleCI(ps.ast, n, "BODY")
UXBAstBinaryLeft(ps.ast, n)
UXBAstBinaryRight(ps.ast, n)
UXBAstValidateContract(ps.ast, ps.rootNode, errText)
UXBAstWriteContractReportJson(ps.ast, ps.rootNode, outPath, errText)
```

## Sözleşme

1. `left/right` expression odaklı kenarlardır.
2. `firstChild/nextSibling` blok, liste, parametre ve statement kenarlarıdır.
3. Her çocuk kenarında child node'un `parent` alanı owner node'u göstermelidir.
4. `role` parser davranışı değildir; semantic/MIR/codegen için metadata'dır.
5. `role` boş olabilir; backend kodu boş role alanına dayanarak çökmez.
6. Expression node için `left/right` önceliklidir; rol tabanlı child sadece geçiş/alternatif yoldur.
7. Statement/block node için child-list önceliklidir.
8. `AST_NULL = -1` tek boş node değeridir.

## Yeni CLI önerisi

Patch uygulanırsa iki yeni seçenek eklenir:

```bat
--ast-contract-json-out dist\ast_contract.json
--ast-contract-check
```

Örnek:

```bat
build\uxb_main_64.exe tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas --ast-contract-json-out dist\ast_contract.json --ast-contract-check --debug
```

`--ast-contract-check` başarısız olursa derleme 17 koduyla durur.

## Neden bu hamle önemli?

MIR exporter, MIR interpreter, x64 emitter ve ileride kurulacak backendler aynı AST okuma sözleşmesini kullanmazsa her katmanda farklı gerçek oluşur. Bu katman ilerideki büyük değişiklikleri küçük ve güvenli yapabilmek için konmuştur.
