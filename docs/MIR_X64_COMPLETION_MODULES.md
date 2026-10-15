# MIR x64 completion modules

This patch extends the native MIR x64 backend by adding focused modules instead of hiding missing work behind AST fallback.

Added modules:

- `mir_x64_arrays.fbs`: static integer array DIM/LOAD_INDEXED/STORE_INDEXED.
- `mir_x64_builtins.fbs`: scalar builtins ABS/SGN/INT/FIX/CINT/CLNG/LEN/ASC/VAL/TIMER/RND/GETKEY/INKEY.
- `mir_x64_fp64.fbs`: ordinary F64 MIR opcodes FADD/FSUB/FMUL/FDIV/FNEG.
- `mir_x64_field_synthetic.fbs`: synthetic field slot support for simple TYPE field MIR lowering.

Still intentionally diagnostic:

- dynamic REDIM requiring heap allocator semantics,
- real OOP object allocation/destruction beyond simple synthetic field slots,
- exception/concurrency/file runtime models when MIR lowering does not expose enough operands.

Rule: no silent AST fallback in `--codegen-source MIR --enable-mir-x64-experimental`.
