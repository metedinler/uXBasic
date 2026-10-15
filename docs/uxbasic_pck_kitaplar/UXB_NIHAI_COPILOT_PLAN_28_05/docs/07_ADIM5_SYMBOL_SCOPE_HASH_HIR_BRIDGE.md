# 07 — ADIM5: Symbol, Scope, Hash ve HIR Bridge

## Amaç

Tek sembol otoritesi kurulacak. HIR kendi bağımsız sembol tablosunu compiler truth olarak kullanmayacak. AST → HIR → MIR arasında symbolIndex, scopeId, typeName taşınacak.

## Çözülecek sorunlar

```text
HIR içinde ayrı SymbolTable/ScopeStack var.
Step3 içinde ayrı gUXBStep3Symbols var.
UXBStep3SymbolFind current+global bakıyor, tam lexical chain yok.
Sembol araması O(n).
HIR güçlü bridge değil.
```

## Yeni modüller

```text
src/symbols/symbol_key.fbs
src/symbols/scope_table.fbs
src/symbols/symbol_index.fbs
src/symbols/symbol_resolver.fbs
src/symbols/symbol_integrity_gate.fbs
src/symbols/symbol_hir_mir_bridge.fbs

src/semantic/hir_scope_bridge.fbs
src/semantic/hir_symbol_bridge.fbs
src/semantic/hir_fact_table.fbs
src/semantic/hir_ast_bridge.fbs
src/semantic/hir_builder.fbs
src/semantic/hir_mir_bridge.fbs
src/semantic/hir_json_report.fbs
```

## İş planı

```text
1. gUXBStep3Symbols tek sembol deposu olarak kalacak.
2. gUXBScopes parentId destekli gerçek scope ağacı olacak.
3. gUXBSymHash exact lookup index'i olacak.
4. UXBSymbolResolveLexical current scope'tan parent zincirine yürüyecek.
5. symbol_integrity_gate semantic sonrası çalışacak.
6. hir.fbs içindeki eski SymbolTable/ScopeStack DEPRECATED yapılacak.
7. HIRFactTable AST node başına scope/symbol/type/layout/source fact üretecek.
8. MIR lowering öncesi HIRPrepareMirLowering çalışacak.
```

## Pozitif testler

```basic
DIM x AS I32
FUNCTION f(a AS I32) AS I32
    DIM x AS F64
    RETURN a
END FUNCTION
```

Beklenen:

```text
global x ile local x farklı symbolIndex.
a param sembolü function scope içinde.
HIR fact table symbolIndex/typeName taşır.
```

## Negatif testler

```basic
FUNCTION a()
    DIM t AS I32
END FUNCTION

FUNCTION b()
    RETURN t
END FUNCTION
```

Beklenen: `t` sembolü a scope'undan b scope'una sızmaz.

## Çıktı

```text
reports/control/current/symbol_integrity_gate.json
reports/control/current/hir_fact_table.json
reports/control/current/hir_bridge_gate.md
reports/control/current/symbol_expected_actual.csv
```
