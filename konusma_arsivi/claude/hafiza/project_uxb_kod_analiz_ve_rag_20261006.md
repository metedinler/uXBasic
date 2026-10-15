---
name: uxb-kod-analiz-ve-rag-20261006
description: Deep code-analysis tool (uxb_kod_analiz.py), ek-amac filler, daily chain wired into the watcher, legacy-module root-cause fixes, and the gotchas hit on 2026-10-06
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-06T19:36:04.459Z
---

Mete (2026-10-06) wanted every function/method/class/struct/table documented with inputs, outputs, variables, types, relations and the SELECT CASE/IF decision tables, plus the RAG system running with the watcher. Built in `UxbRAG/UXB_HYBRID_RAG_V4_YORUMLU_JSON/tools/`:
- `uxb_kod_analiz.py` → `reports/uxb_kod_analiz/guncel/` (OZET.md first). 720 files/155k lines: 6,914 routines, 504 types (1 CLASS, 0 Extends), 925 decision tables, 11k call edges; C/C++ via ctags (7.9k functions) with `CALL(DLL)`→C link (1,856/2,382). Cross-checked: ctags 99.97%, Codex rutinler.tsv 99.96%.
- `uxb_ek_amac.py` fills type/global/table purposes via the shared provider client (cache `ajan_paketi/ek_amac_onbellek.jsonl`; 90/1,296 done). `uxb_gunluk_zincir.py` is what the watcher launches now (map refresh → fill → package → analysis → ek-amac → analysis). Plain-Turkish guide: `GUNCEL_DURUM_VE_SADE_KILAVUZ_20261006.md` (also the artifact link Mete already has).
- Legacy `tools/Moduller` bugs root-caused: `f"="*60 + "\n" f"..."` adjacent-literal concatenation happens before `*` (whole body repeated 60×) in Statik/Davranissal; CLI missing parameter; RAG missing `target_dir`.

**Gotchas (cost me hours):** (1) `uxb_map_system.py --out <scratch>` used to move `reports/uxb_map_system/latest_summary.json`, and `uxb_ajan_paketi.py` then rebuilt the agent package from the scratch (inventory-less) map — fixed 2026-10-06 (pointer only moves for outputs under `reports/`); still never use `--out` for experiments without checking the pointer. (2) PowerShell `Start-Process -ArgumentList` does not quote args with spaces. (3) ctags on Windows needs `--sort=no`. (4) Gemini free tier really allows ~25 requests/day/model (env says 240); Kimi self-cap 100/day was used up by the fill jobs. (5) Watcher: when fill prints "tüm işler tamamlandı" it runs `uxb_oturum.ps1` (OpenClaw/Kimi session, source backup first) and exits — Mete was warned this may fire the night of 2026-10-06.

**Why:** [[user-not-a-programmer]] wants plain-Turkish status and verified claims; [[feedback-frequent-status-updates]].
**How to apply:** use the analysis outputs instead of re-reading big files; re-verify numbers with `saglik.txt`; open items: RAG vectorization (~17k chunks, ~6.5 h from 22:30), ek-amac remainder (resumes with free quotas), fine-tune dataset not started, Prompt Bridge MVP unverified ([[groq-token-bridge-20260930]]).
