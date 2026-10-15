# EXTFP F80/F128 codegen patch summary

Applied intent:

- F80/F128 x64 codegen should use external DLL/runtime calls, not x87/SSE arithmetic.
- F80/F128 assignments use address-based lowering.
- F80/F128 PRINT uses `*_to_str` runtime call.
- Missing/non-addressable expression paths produce diagnostics.

Changed files:

- `uxb/src/codegen/x64/code_generator.fbs`
- `uxb/src/codegen/x64/stmt_emitters/x64_codegen_stmt_field_addr.fbs`
- `uxb/src/codegen/x64/helpers/x64_codegen_symbol_table_helpers.fbs`
- `uxb/tools/uxb_extfp_codegen_audit.py`
- `uxb/compiler/scripts/run_extfp_codegen_smoke.bat`
- `uxb/tests/fp_ext/f80_local_global_assignment_binary_print.bas`
- `uxb/tests/fp_ext/f80_array_field_assignment_binary_print.bas`
- `uxb/tests/fp_ext/f128_local_global_assignment_binary_print.bas`
- `uxb/tests/fp_ext/f128_array_field_assignment_binary_print.bas`

Run:

```bat
cd /d C:\Users\mete\Downloads\UXBc
uxb\compiler\scripts\run_extfp_codegen_smoke.bat
```

The smoke script emits NASM for local/global/array/field tests and rejects generated assembly if old x87 `fld/fstp` or SSE `addsd/subsd/mulsd/divsd/addss/subss/mulss/divss` arithmetic appears in extfp outputs.

Known honest limits:

- Function return of F80/F128 remains diagnostic; returning these by value is intentionally avoided.
- Non-addressable complex expressions must be assigned to variables first or expanded by further lowering.
- Full executable linking may still require import library/link pipeline work for `uxb_fp80.dll` and `uxb_fp128.dll`; NASM codegen lowering is guarded first.
