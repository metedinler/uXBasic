---
name: project_mir_perf_and_disk_incident
description: "2026-09-20: canonical-MIR interpreter was ~100x too slow (opcode registry rebuilt a 5 KB list per call), fixed with src/common/string_memo.fbs; C: dropped to 0.02 GB free (cause unproven; build\\ holds 19 GB) - time-box probes, watch free disk."
metadata: 
  node_type: memory
  type: project
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-20T17:22:38.218Z
---

`uxb run --interpreter-backend MIR` was unusable: ~25 ms per empty FOR iteration, `FOR 1..5000` = 118 s CPU, 2000 `PRINT`s = 326 s. Causes found by measuring (not guessing): `UXBMIRStep4OpcodeKnown` rebuilt/UCased/scanned a ~5 KB opcode list per call; trace enabled in the driver; variable/label lookup UCase(Trim()) on every name; each PRINT rebuilt the whole output-events JSON + `ReDim Preserve` one element at a time (O(n^2) time AND memory).

**Why it matters:** while probing I left a 2000-line MIR PRINT loop running; C: dropped to 0.02 GB free and the unified test runner failed with "Diskte yeterli yer yok". Killing the process / finishing the runs returned ~6 GB. Cause NOT proven (the page file is a fixed 12 GB, so not that). Known disk pressure: the `build` folder holds 19 GB of per-run folders (12k runs) and each native build copies ~53 MB of DLLs (libopenblas 42 MB) - logged as S-117, waiting for Mete's decision; nothing was deleted. Notebooks/sources were intact.

**How to apply:** (1) run experiments with a timeout / kill them; check `(Get-PSDrive C).Free` when something feels off. (2) Shared helper for pure string->string hot paths is `src/common/string_memo.fbs` (`UXBStringMemo`, `UXBStringMemoGet/Put`); MIR opcode/type registries use it (`...Uncached` are the raw versions). (3) Measure CPU time via `Process.TotalProcessorTime`, not wall time - other AI sessions load the machine. (4) Front-end is also slow (S-111: ~12 ms per statement in `sem`); sampling works with `C:\lazarus\mingw\x86_64-win64\bin\gdb.exe -p PID -batch -ex "thread 1" -ex "bt"`, but the release exe is stripped (needs a `-g` build). (5) In PowerShell double-quoted strings a backtick-b is a backspace: use here-strings for text containing `build\`. See [[uxb-fix-plan-decisions-2026-09]] and [[feedback_notebooks_status_closed_open]].
