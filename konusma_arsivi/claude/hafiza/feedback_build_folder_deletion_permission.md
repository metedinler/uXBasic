---
name: feedback_build_folder_deletion_permission
description: "Mete (2026-09-20): may delete build\\<date-time> run folders of PREVIOUS days when disk is needed (not today's); old reports/old build info may be deleted if useless BUT ask him first; everything else in build\\ is protected."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-20T18:40:33.834Z
---

Mete's explicit instruction (2026-09-20): "build klasorunu gerektiginde calisilan gun harici silebilirsin ... eski build bilgileri / eski rapor dosyalari gereksiz ise silinebilir. Bana sor, silmeden once."

**Rule:** (1) `build\MM_dd_yyyy_HH_mm_ss` run folders (one per `uxb` call) from days BEFORE the working day: deletable when disk is needed, no need to ask; report what was removed. (2) Do NOT touch the rest of `build\` (`manual\config\ffi_allowlist.txt` = FFI policy, `compiler`, `deps`, `libraries`, `patch_backup_*`, `recovery_backup_*`, `quarantine_*`, `release_stage`, loose dlls) — ask first. (3) Old report files (`reports\`, `test_results\`, old JSON reports, `.bak`): may be deleted if unnecessary, but ASK Mete first with a list (what, size, why useless).

**Why:** `build\` had 13k run folders / ~19 GB and C: dropped to 0.02 GB free (S-117); the repo has no git, so deletions are otherwise irreversible.

**How to apply:** identify run folders by the regex `^\d\d_\d\d_\d{4}_\d\d_\d\d_\d\d$` and date != today; use `--out-root <scratch>` for bulk experiments and delete the scratch afterwards. Recorded in ai_koordinasyon/KARAR_VE_GOREV_DEFTERI.md. See [[project_mir_perf_and_disk_incident]] and [[feedback_verify_before_destructive_action]].
