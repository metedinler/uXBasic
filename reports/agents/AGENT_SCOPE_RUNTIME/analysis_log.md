# Analysis Log

## 2026-04-15 Delta
- Sorun: `exec: unsupported statement kind NAMESPACE_STMT`.
- Etki: FFI-SCOPE-1 runtime hucreleri KISMEN kalıyor.
- Cozum: `ExecRunStmt` icinde `NAMESPACE_STMT/MODULE_STMT/MAIN_STMT` icin child execution, `USING_STMT/ALIAS_STMT` icin no-op.

## 2026-04-15 Post-Update
- Runtime scope execution eklendi.
- Testler: run_call_dll_scope_exec_ast, run_call_dll_alias_exec_ast.

## 2026-04-15 Validation Cycle-2
- MAIN bloklari global-scope kuralina uyarlanarak test fixture duzeltildi.
- Kanit: run_call_dll_scope_exec_ast_64.exe ve run_call_dll_alias_exec_ast_64.exe cikis kodu 0.
