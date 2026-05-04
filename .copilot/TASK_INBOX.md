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

3. 8A-0 test80 gate stabilization
Owner: Agent-B
Priority: P0
Candidate files:
- tests/basicCodeTests/80_h8a_operator_numeric_parity.bas
Evidence required:
- self-build + AST JSON + semantic + AST/MIR/x64 gate rerun

## Hold

- EVENT/THREAD/PARALEL/PIPE/SLOT closure starts after #1 and #2.

Claimed in this cycle:
- tests/basicCodeTests/80_h8a_operator_numeric_parity.bas
