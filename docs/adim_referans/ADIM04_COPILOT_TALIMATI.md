# ADIM04 — AST Contract ve Hibrit Çocuk Modeli Copilot Talimatı

Bu adımın amacı parser sonrası AST gerçekliğini netleştirmektir.

Kesin kural:

```text
left/right = sadece BINARY ve UNARY expression shortcut
firstChild/nextSibling + role = genel kanonik çocuk sistemi
BLOCK / FUNCTION / CLASS / IF / CALL / OOP / statement node'ları left/right kullanmayacak
```

## Mevcut araç kuralı

Yeni Python aracı yazma. Mevcut AST contract araçları kullanılacak:

```text
tools/audit/uxb_ast_contract_collect_parser_nodes.py
tools/audit/uxb_ast_contract_collect_contract_nodes.py
tools/audit/uxb_ast_contract_collect_handlers.py
tools/audit/uxb_ast_contract_build_matrix.py
tools/audit/uxb_ast_contract_fake_status_scan.py
tools/audit/uxb_ast_contract_gate.py
compiler/scripts/run_step2_ast_contract_gate.bat
```

## Eklenecek FreeBASIC dosyaları

Aşağıdaki patch dosyalarını aynı repo yollarına kopyala:

```text
patch_files/src/parser/ast_node_kind_id.fbs        -> src/parser/ast_node_kind_id.fbs
patch_files/src/parser/ast_child_accessors.fbs    -> src/parser/ast_child_accessors.fbs
patch_files/src/parser/ast_contract_child_model.fbs -> src/parser/ast_contract_child_model.fbs
patch_files/src/parser/ast_contract_gate_adim04.fbs -> src/parser/ast_contract_gate_adim04.fbs
```

## `src/parser/ast_contract.fbs` include eklemesi

Dosyanın en sonunda mevcut satır vardır:

```freebasic
#include once "ast_contract_validate.fbs"
```

Bu satırın hemen altına şunları ekle:

```freebasic
#include once "ast_node_kind_id.fbs"
#include once "ast_child_accessors.fbs"
#include once "ast_contract_child_model.fbs"
#include once "ast_contract_gate_adim04.fbs"
```

## `src/main_program_entry.fbs` zorunlu gate değişikliği

Şu blokta:

```freebasic
If AstContract_ValidateTree(ps.ast, ps.rootNode, astContractErr) = 0 Then
```

bunu değiştir:

```freebasic
If UXBAstAdim04ValidateTree(ps.ast, ps.rootNode, astContractErr) = 0 Then
```

Bu değişiklikle eski AST contract korunur ama ADIM04 çocuk modeli gate'i de zorunlu hale gelir.

## Rapor üretimi

`--ast-contract-json-out` eski raporu yazmaya devam etsin. Adım04 özel raporları test scriptinden yazılacak:

```text
reports/control/current/ast_child_model_matrix.csv
reports/control/current/ast_contract_gate.json
reports/control/current/ast_contract_gate.md
```

## Beklenen sonuç

- BINARY node left/right kullanır ve iki operandı vardır.
- UNARY node left kullanır, right kullanmaz.
- BLOCK / IF / FUNCTION / CLASS / CALL node'ları firstChild/nextSibling + role kullanır.
- left/right yanlış kullanımı gate FAIL verir.
- Mevcut `compiler/scripts/run_step2_ast_contract_gate.bat` çalışmaya devam eder.
