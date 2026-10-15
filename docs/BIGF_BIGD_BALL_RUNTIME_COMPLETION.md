# BIGF / BIGD / BALL Runtime Completion

This package adds a real external runtime DLL for uXBasiC high precision handle-backed types.

## Runtime DLL

```text
uxb/dist/runtime_ext/uxb_bigfp.dll
```

## Implemented families

- `BIGF(precision_bits)` -> MPFR binary arbitrary precision handle.
- `BIGD(decimal_digits)` -> decimal-digit precision policy over MPFR. This is scientific decimal precision, not fixed-scale financial accounting decimal.
- `BALL(precision_bits)` -> midpoint-radius interval/ball runtime over MPFR.

## Exported prefixes

```text
uxb_bigf_*
uxb_bigd_*
uxb_ball_*
```

## Compiler policy

`extfp_type_policy.fbs` no longer marks BIGF/BIGD/BALL as policy-only. Runtime availability is checked by `extfp_runtime_status.fbs` through `uxb_bigfp.dll`.

## Smoke test

```bat
uxb\compiler\scripts\run_full_fp_runtime_smoke.bat
```

## Honest boundary

The DLL runtime is real. Full uXBasiC source-level arithmetic lowering for every BIGF/BIGD/BALL expression still depends on the compiler's existing type parser/MIR/codegen routes. Unsupported expression routes must emit diagnostics, not fake success.
