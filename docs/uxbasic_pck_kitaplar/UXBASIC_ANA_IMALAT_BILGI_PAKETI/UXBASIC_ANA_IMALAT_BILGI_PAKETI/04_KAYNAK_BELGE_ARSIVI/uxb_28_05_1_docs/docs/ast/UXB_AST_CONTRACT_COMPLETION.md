# uXBasic Step2 AST Contract Completion

This document records the Step2 contract completion overlay built after the MIR V4 bridge.

The goal is not to claim that every downstream layer is fully implemented. The goal is to make every parser-produced AST node carry an explicit, non-empty, fail-closed contract decision for every downstream layer:

- semantic
- type binding
- layout
- AST interpreter
- MIR lowering
- MIR verify
- x64 AST
- x64 MIR
- JS
- WASM/WAT
- test
- documentation

A layer cell can be `IMPLEMENTED`, `NOT_APPLICABLE`, `COMPILE_TIME_ONLY`, `RUNTIME_CALL`, `NATIVE_ONLY`, or `WASM_UNSUPPORTED`. Empty cells and fake success are not allowed.

The FreeBASIC bridge files added by this completion are:

- `src/parser/ast_contract_layer_bindings.fbs`
- `src/semantic/ast_contract_step2_semantic_bridge.fbs`
- `src/semantic/type_binding_ast_contract_bridge.fbs`
- `src/semantic/layout_ast_contract_bridge.fbs`
- `src/runtime/exec/ast_contract_interpreter_bridge.fbs`

These files provide explicit contract functions. They do not replace the real Step3 semantic/type/layout implementation, the Step5 interpreter implementation, or the Step6 backends. They prevent Step2 from hiding missing layer decisions behind blank cells.
