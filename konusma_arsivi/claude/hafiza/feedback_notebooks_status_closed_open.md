---
name: feedback_notebooks_status_closed_open
description: "User (2026-09-20) demands that every finding be written to the ai_koordinasyon notebooks WITH its status (closed / partial / open / decision) - important, do it continuously and at the end; never stop between items."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-29T18:03:32.955Z
---

Write what was done AND whether each problem met along the way is CLOSED or still OPEN into the notebooks (`ai_koordinasyon/SORUN_TAKIP.md`, `DURUM.md`) — the user called this important (2026-09-20: "defterlere ne yaptığını yaz, karşılaştığın sorunların kapanıp kapanmadığını yazman gerekir bu önemli, ai_koordinasyon dizininde işine devam et, bitirince yaz"). Also: "işlemler bitince durma, listeden iş seç ve yapmaya devam et" — never stop when a step finishes; pick the next item from the list and continue.

**Why:** the user is not a programmer and follows progress only through the notebooks; a finding without an explicit status is invisible.

**How to apply:** after every finished item update the S-xxx entry (status word + how verified + what remains), append a DURUM.md line, and keep the per-session summary file `ai_koordinasyon/CLAUDE1_20260920_ISLER_VE_SORUN_DURUMU_TR.md` (table: closed / open / decisions) current; open decisions are listed for Mete, never silently decided. See [[uxb-fix-plan-decisions-2026-09]] for the running technical log.

**Reaffirmed 2026-09-29:** after finishing one problem, pick a new OPEN one from `ai_koordinasyon/SORUN_TAKIP.md` myself and do what's needed — do not stop to ask which one. Use the `sorun-kaydi` skill to log/update entries. Prefer unclaimed items (check `DURUM.md`/`SORULAR_CEVAPLAR.md` for no active CLAIM) to avoid collision with concurrent agents (Codex, another Claude session, and an automated OpenClaw/Kimi patch agent are all active on this repo as of late Sep 2026).
