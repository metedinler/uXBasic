---
name: arsiv-konusma-eski-belge
description: Never delete Claude conversation files; archive readable copies in UXBc\claude_arsiv\konusmalar; move superseded Claude docs to claude_arsiv\eski_belgeler instead of deleting
metadata:
  node_type: memory
  type: feedback
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-28T15:44:33.994Z
---

Mete 2026-09-28: "claude konuşma dosyalarını kaldırma; konuşma dosyalarını ileride benim okumam için bir klasöre kaydet; bu
klasör senin belgelerinin eski olanlarını kaldırdığın bir yer olsun."
- Transcripts `%USERPROFILE%\.claude\projects\*\*.jsonl` are NEVER deleted (TEMP scratchpads are not transcripts).
- Readable archive: `UXBc\claude_arsiv\konusmalar\<yyyyMMdd>_<oturum8>.md` + raw copies in `ham\`, produced by
  `UXBc\claude_arsiv\konusma_arsivle.py` (watcher runs it daily).
- When a Claude-authored document is superseded, MOVE it to `UXBc\claude_arsiv\eski_belgeler\<yyyyMMdd>_<orig-name>` — don't delete.

**Why:** Mete wants to read past sessions later and keep a trail of old docs.
**How to apply:** before removing any doc/transcript-like file of mine, move it into eski_belgeler; see [[project-no-git-manual-zip-backups]].
