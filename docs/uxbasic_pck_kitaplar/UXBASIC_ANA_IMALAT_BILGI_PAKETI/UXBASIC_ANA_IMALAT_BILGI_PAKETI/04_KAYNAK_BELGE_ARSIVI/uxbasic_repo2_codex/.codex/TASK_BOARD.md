# Hamle 8 Task Board

Date: 2026-05-02

## Active Owners

- Agent-A (Codex/Main): in progress
- Agent-B (Copilot/Parallel): pending ack

## Current Priority Queue

1. MIR dynamic receiver dispatch for class virtual/method calls
Status: IN_PROGRESS
Owner: Agent-A
Scope:
- src/semantic/mir.fbs
- src/semantic/mir_evaluator.fbs
- src/runtime/exec/exec_call_dispatch_helpers.fbs
Exit criteria:
- BASE <- NEW DOG virtual call parity AST=MIR=x64

2. x64 VARPTR/OFFSETOF/PEEKD native lane
Status: TODO
Owner: Agent-B
Scope:
- src/codegen/x64/code_generator.fbs
- semantic builtin mapping files
Exit criteria:
- coverage cells updated with probe outputs

3. INPUT native/MIR parity hardening
Status: TODO
Owner: Agent-B
Scope:
- src/runtime/exec input helpers
- src/semantic/mir* input lowering/eval
- src/codegen/x64 input emit
Exit criteria:
- prompt + numeric/string parity tests pass

4. EVENT/THREAD/PARALEL/PIPE/SLOT semantic+MIR+x64 MVP completion
Status: TODO
Owner: split after task 2 and 3

## Shared File Rule

Only task owner writes source files.
Both agents may propose text for COMPILER_COVERAGE.md, but only one writes per cycle.
