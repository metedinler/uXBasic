# Task Inbox (Copilot)

Date: 2026-05-02

## Assigned Now

1. x64 VARPTR/OFFSETOF/PEEKD native lane closure
Owner: Agent-B
Priority: P1
Candidate files:
- src/codegen/x64/code_generator.fbs
- semantic builtin mapping files
- tests/basicCodeTests/88_h8a_varptr_offsetof_peekd_native_parity.bas
- COMPILER_COVERAGE.md
Evidence required:
- command + output for probes and updated coverage row

Claimed in this cycle:
- tests/basicCodeTests/88_h8a_varptr_offsetof_peekd_native_parity.bas
- COMPILER_COVERAGE.md

2. INPUT parity hardening (native + MIR)
Owner: Agent-B
Priority: P1
Candidate files:
- runtime input helpers
- mir lowering/evaluator
- x64 input emit
Evidence required:
- prompt and value parity across AST/MIR/x64

## Hold

- EVENT/THREAD/PARALEL/PIPE/SLOT closure starts after #1 and #2.
