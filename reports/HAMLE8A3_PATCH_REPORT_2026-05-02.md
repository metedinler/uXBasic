# HAMLE 8A-3 Patch Report (2026-05-02)

## Scope

- Runtime/interpreter `__vptr` meaning unified to runtime vtable handle semantics.
- x64 vtable label generation centralized.
- x64 virtual dispatch `classIdx -> __uxb_vtable_ptrs` fallback removed.

## Code Changes

- `src/runtime/exec/exec_class_layout_helpers.fbs`
  - `DIM` and `NEW` class allocation now require `ExecFindRuntimeVTableHandle(...)`.
  - Object header write path is single source: `[object+0..3] = vtable handle`, `[object+4..7] = 0`.
- `src/runtime/exec/exec_call_dispatch_helpers.fbs`
  - Method dispatch resolves receiver runtime class from object header handle via `ExecFindRuntimeVTableClassByHandle(...)`.
- `src/runtime/exec/exec_eval_support_helpers.fbs`
  - Removed accidental `ExecBuildVTableMap(...)` side effect from `ExecParseBoundRange(...)`.
  - Runtime vtable handle helpers remain in central helper file.
- `src/codegen/x64/cg_context.fbs`
  - Declared `X64ClassVTableLabel(...)`.
- `src/codegen/x64/code_generator.fbs`
  - Added `X64ClassVTableLabel(...)` helper.
  - Rewired vtable emit + object allocation sites to helper label.
  - Removed `__uxb_vtable_ptrs` data emission and lookup fallback.
  - Virtual call paths now use pointer-only vtable lane with null guards.
- `COMPILER_COVERAGE.md`
  - Added explicit row for `OOP runtime __vptr / vtable dispatch`.
  - Added `2026-05-02 Hamle 8A-3` note section.
  - Added `Hamle 8 Kalan 7 Adim Plani` section.

## Verification Snapshot

| Test | AST | MIR | x64 |
|---|---:|---:|---:|
| `tests/basicCodeTests/64_class_virtual_override_runtime.bas` | `1,1` | `1,1` | n/a |
| `tests/basicCodeTests/28_matrix_class_interface.bas` | n/a | n/a | `42` |
| custom probe `BASE<-DOG; obj=NEW DOG; obj.SPEAK()` | `22` | `11` | `22` |

## Residual Gap

- MIR dynamic receiver dispatch for `NEW`-allocated base references is still partial.
  - Evidence: custom probe returns `11` in MIR, while AST/x64 return `22`.
