---
name: s030-task-model-state-2026-09-25
description: "S-030 SPAWN/TASK state after 2026-09-25 — Faz 1B, S-149 TASK OF, S-146 isolation, Faz 2A native async done; open items and where things live"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-25T05:12:53.712Z
---

State at end of 2026-09-25 (Claude 1):
- **Done:** canonical MIR task calls (`MIR_CALL TASK_SPAWN/JOIN/...`, contract at top of `src/semantic/mir_lower_expr.fbs`), MIR interp provider `src/interpreter/mir/mir_interp_task.fbs`, S-149 `TASK OF T`, S-146 isolation `src/semantic/semantic_task_isolation.fbs` (runs after step3 gate), Faz 2A native real threads (`src/codegen/x64/mir_x64_task_v2.fbs` + `native/uxb_runtime/uxb_runtime_task_v2.cpp`), K5 unread-error check in AST/MIR/native, K9 PRINT line buffering (`uxb::console_write`), `--task-workers N`, 8 MB worker stacks, S-156 END-in-routine fix.
- **Tests:** `tests/task_model` (4 engines, `x64=run`, legacy AST-x64 permanent reject), `tests/task_native` (native only, workers 1/2/AUTO ×3), `tests/program_end`, `tests/native_runtime/task_v2` (C++ stress, DLL-less, compiles all runtime sources).
- **Mete decisions:** K1–K8 (2026-09-24), S-149 TASK OF, S-146 D1–D6 (2026-09-25, in `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md`). D2 changed by Mete: no GUARDED BY — each `DIM SHARED` carries its own lock; `DIM ATOMIC x AS I64`.
- **Waiting on Mete:** §8.2 objections İ1 (SHARED unlocked access error everywhere incl. main), İ2 (general ATOMIC lost-update rule), İ3 (builtin shared-state fail-closed list — already applied), İ4 (transitive BLOCKS under LOCK), İ5 (TASK handles don't cross boundary), İ6 (END in task body rejected — applied).
- **Open:** Faz 2B (SHARED/ATOMIC/MUTEX/LOCK), cancel inside helper-routine loops (native), JS Faz 3 (Antigravity), WASM Faz 4, JOINALL (S-147), library-type taskTransfer fields (Codex's manifest area, asked in SORULAR_CEVAPLAR).

**Why:** the task model spans parser/semantic/MIR/interp/codegen/runtime; next session must not re-derive where each piece lives.
**How to apply:** rebuilding `native/uxb_runtime` DLL overwrites shared `bin/uxb_runtime.dll` — never do it while a full regression is running (x64 tests link it); build compiler to a private exe name (`bin/uxb_claude1_*.exe`) when a regression uses the other one. See [[omniroute-and-map-setup-2026-09-24]].
