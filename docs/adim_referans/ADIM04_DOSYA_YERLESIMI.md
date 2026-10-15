# ADIM04 Dosya Yerleşimi

## Yeni dosyalar

```text
src/parser/ast_node_kind_id.fbs
src/parser/ast_child_accessors.fbs
src/parser/ast_contract_child_model.fbs
src/parser/ast_contract_gate_adim04.fbs
```

## Değiştirilecek dosyalar

### `src/parser/ast_contract.fbs`

En altta mevcut `#include once "ast_contract_validate.fbs"` satırının hemen altına ADIM04 include'ları eklenecek.

### `src/main_program_entry.fbs`

AST contract check alanında `AstContract_ValidateTree` çağrısı `UXBAstAdim04ValidateTree` ile değiştirilecek.

## Yeni test dosyaları

```text
tests/adim04/positive/adim04_binary_expr.bas
tests/adim04/positive/adim04_if_call.bas
tests/adim04/positive/adim04_class.bas
tests/adim04/negative_harness/adim04_ast_contract_negative_harness.bas
```

## Yeni script

```text
compiler/scripts/run_adim04_ast_contract_gate.ps1
```
