---
name: feedback-verify-before-destructive-action
description: "Before any deletion/destructive change, fully investigate root cause and blast radius, present findings, and ask one final explicit confirmation — this user has been burned by AI assistants skipping that step before."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T18:00:53.921Z
---

When approving cleanup of duplicate ONNX Runtime dependency copies in `dist/runtime_ext/deps/` (2026-09-06), the user's exact words: "çok önemli ... tara, program tara, sonradan sürpriz çıkmasın 'ben bunu bilmiyordum, sen dememiştin' demeyesin. Claude eskiden böyle şeyleri çok yapardın, tüm dikkatini buna ver ... silme kararı için bana son olarak sor." (very important — scan the library, scan the program, so there's no surprise later where you say 'I didn't know, you hadn't told me.' Claude, you used to do this kind of thing a lot before — give this your full attention ... ask me one final time before the deletion decision.)

**Why:** this reads as a direct reference to a bad past experience — an AI assistant (implied: an earlier Claude session) deleting or changing something destructive without first verifying it was actually safe, causing a nasty surprise. This user does not trust "looks redundant" as sufficient grounds for deletion.

**How to apply, every time a destructive action is on the table (delete, overwrite, force anything) — not just for this ONNX case:**
1. Before proposing removal of anything that "looks like a duplicate," trace *why* it exists (check the actual scripts/build logic that created it) rather than assuming from file/folder naming alone. In the ONNX case this mattered a lot: two modules (`uxonnx`, `uxonnx2`) turned out to depend on *different, both-legitimate* versions of the same library — a naive "keep newest, delete the rest" pass would have broken `uxonnx2`.
2. Present the investigation findings clearly (what's genuinely redundant vs. what only looks redundant) before asking for a go-ahead.
3. Even after getting a general go-ahead earlier in a conversation, ask once more, specifically and narrowly scoped, immediately before running the actual destructive command — do not chain multiple deletions off one earlier blanket approval.
4. If something new/unscoped turns up mid-task (e.g. a leftover `.zip` of the same redundant dependency, found only after already deleting the extracted folders), stop and ask about that separately rather than silently including it under the original approval.
5. This user has separately established a strict "no deletion, only move/archive" default (see [[uxb-fix-plan-decisions-2026-09]], [[project-no-git-manual-zip-backups]]) precisely because there's no working git safety net yet. Actual deletion (not just archiving) is the exception, granted only per-item, only after the investigation above, and only with an explicit final yes for that specific item.
