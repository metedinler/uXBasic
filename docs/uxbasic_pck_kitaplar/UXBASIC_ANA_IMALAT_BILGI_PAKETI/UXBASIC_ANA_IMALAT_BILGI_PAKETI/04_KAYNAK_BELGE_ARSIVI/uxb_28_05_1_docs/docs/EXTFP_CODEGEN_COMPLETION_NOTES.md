# F80/F128 external FP codegen completion notes

This patch changes the x64 AST codegen policy for F80/F128:

- F80/F128 arithmetic must not use x87 or SSE native arithmetic.
- Assignment from numeric literal lowers to `uxb_f80_from_str` / `uxb_f128_from_str`.
- Assignment from another F80/F128 variable/field/array element lowers to `uxb_f80_copy` / `uxb_f128_copy`.
- Binary `+ - * /` assignment lowers to `uxb_f80_add/sub/mul/div` or `uxb_f128_add/sub/mul/div`.
- `PRINT` lowers to `uxb_f80_to_str` / `uxb_f128_to_str`, then uses the existing runtime print routine.
- Local/global variables, arrays and TYPE fields are covered through address-based lowering.
- Function return and non-addressable expression paths still fail with explicit diagnostics.

Run:

```bat
uxb\compiler\scripts\run_extfp_codegen_smoke.bat
```

The audit tool rejects generated NASM that contains old x87 `fld/fstp` or SSE float arithmetic for F80/F128 tests.
