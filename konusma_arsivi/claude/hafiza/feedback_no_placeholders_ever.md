---
name: feedback-no-placeholders-ever
description: "Standing hard rule — no placeholder/TODO/stub/fake code ever, under any name; see the full picture before deciding a fix; scan for obvious bugs while coding and report them for later review rather than silently leaving them."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T20:30:47.199Z
---

While fixing the uXBasic build (2026-09-06), Claude created an empty placeholder stub for a missing-but-referenced file (`src/runtime/browser/runtime_browser_hook.fbs`) just to unblock a compile. The user's reaction, verbatim: "kod tam eksiksiz ve tam çalışır, görevini mutlaka yapan, beklenildiği ve tasarlandığı gibi hareket eden, herhangi bir ad altında placeholder, todo, yapılacak, dump, boş vs olmayacak, sahte kod kısa yol olmayacak" (code must be complete and fully working, definitely doing its job, behaving as designed — under no name will there be a placeholder, TODO, to-do, dump, empty thing, etc.; no fake code, no shortcuts). Also: "asla kodu tam ve tümünü genel ve özelde resmin tamamını görmeden karar verme" (never decide without seeing the complete picture of the whole code, both general and specific).

**Why:** this echoes [[feedback-verify-before-destructive-action]] and [[feedback-do-once-near-perfect]] — the user has been burned before by AI-written shortcuts that looked done but weren't, and wants every fix to be the real, root-cause, complete fix, not a patch that merely silences a symptom (a compile error, a missing function) without actually restoring/implementing the real intended behavior.

**How to apply, always, no exceptions:**
1. Never write an empty/stub function, file, or class "just to unblock a build or test" and leave it that way. If something is genuinely missing (a deleted/never-migrated file, an unimplemented function a patch was supposed to add), the job is to find the real original content (check sibling patch bundles, staging folders, backups) or actually implement the real behavior — not paper over it.
2. Before deciding how to fix something, read enough of the surrounding system (callers, related bundles, the feature's own design docs) to see the true, whole picture — both the general architecture and the specific local code — rather than acting on a first guess.
3. While doing any coding task, actively scan for other obvious/clear bugs encountered along the way and list them for the user to review later — don't silently fix-and-forget, and don't silently ignore them either.
4. If a genuinely temporary stopgap is unavoidable mid-investigation, say so explicitly to the user and treat it as an open item to finish — never present it as done. See [[uxb-fix-plan-decisions-2026-09]] for the current open item of this kind (the `runtime_browser_hook.fbs` stub, which needs its real content recovered/rewritten, not left empty) and [[uxb-clean-build-effort]] for the broader from-scratch-build repair project this came out of.
