---
name: project-s146-model-d-state-20260926
description: "S-146 Model D step 1 done (auto-sync/LOCK/ATOMIC/MUTEX/UNSAFE) — where code/tests live, design rules, open S-160/161/162"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-26T19:15:46.293Z
---

Mete chose Model D on 2026-09-26: natural BASIC globals in tasks, auto-synchronized as a language guarantee; only ban = END in task chain; unimplemented steps get "henuz uygulanmadi: S-146 adim N". Step order 1..7 in doc §10; step 1 done 2026-09-26, doc §11 records it.

**Code map:** analyzer `src/semantic/semantic_task_isolation.fbs` (sync set, lockOrderId = global decl order, LOCK/ATOMIC validation; runs for every program, `UXBTaskEnsureSyncAnalysis` caches); MIR passes `mir_sync_pass.fbs` (SYNC_ENTER/LEAVE per statement, call hoisting §10.1, STR_SNAPSHOT, ATOMIC lock-free fast path) and `mir_exc_pass.fbs` (S-160), LOCK lowering `mir_lower_lock.fbs`; interpreters `mir_interp_task.fbs` / `exec_task_handle.fbs` (lock table, deferred SPAWN while LOCK held, fatal SELF/LOCK_DEADLOCK); native runtime `native/uxb_runtime/uxb_runtime_sync.cpp` (per-store locks, owner = task, wait graph) + task_v2 hooks; codegen `mir_x64_task_v2.fbs`.

**Why:** Mete rejected "şimdilik yasak" restrictions; engines must give identical data semantics.

**How to apply:** new instruction field `stmtSeq`/`tryTargetPlus1` drive the passes; run passes sync→exc order. Rebuild DLL only when no regression is running (native build takes import lib + DLL from `native/uxb_runtime/build`). Tests: `tests/task_sync` (run_task_sync_tests.ps1), `tests/task_model` migrated. Open: S-160 (in progress: exception crosses routines; interp done, native needs DLL rebuild + test), S-161 (eval order decision for Mete), S-162 (NAMESPACE vars broken). See [[project_s030_task_model_state_20260925]].
