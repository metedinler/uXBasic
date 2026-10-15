---
name: claude-automation-setup-2026-09-27
description: "Project Claude automation installed 2026-09-27 — hooks (delete/disk/coedit guards), permissions allowlist, skills (uxb-derle/3motor/regresyon/sorun-kaydi), agent motor-esitligi, MIMARI.md map; use these instead of ad-hoc scratchpad scripts"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-27T20:46:02.114Z
---

Mete asked (2026-09-27) to install all automation + map the codebase to save tokens. Installed in `uxb/`:
- `.claude/settings.json`: allow = `tools\claude\*.ps1` scripts, `tests\run_all_model_tests.ps1`, read-only cmdlets. Hooks: PreToolUse PowerShell → `guard_delete.ps1` (blocks permanent delete outside TEMP/scratchpad/build\<date>), `disk_guard.ps1` (<1 GB C: blocks build/test/map); Edit|Write pre/post → `coedit_guard.ps1` (warns once if file changed by someone else in last 20 min; state in `.claude/hooks/state/`). All unit-tested.
- Tools: `tools/claude/uxb_build.ps1 -Name claude1_<v>` (refuses main exe names / busy exe / concurrent fbc), `uxb_run3.ps1 -File -Uxb [-Legacy]`, `uxb_regression.ps1 -Uxb [-Only]` (reports → build\claude_reports\).
- Skills: uxb-harita (+ new `MIMARI.md` architecture map: pipeline, engine differences, feature checklist), uxb-derle, uxb-3motor, uxb-regresyon, sorun-kaydi. Agent: `.claude/agents/motor-esitligi.md` (read-only parity auditor).
- Symbol map refreshed 2026-09-27 22:22: 7512 routines, 18.5% with purpose.
- `.mcp.json` had a plaintext (invalid, 403) omniroute key → reverted to `${OMNIROUTE_API_KEY}`; Mete must set a fresh key in the env var.

- External-AI map filler (Mete explicitly approved sending source to these providers, 2026-09-27; auto-mode classifier blocked it until Mete changed the permission mode): `UxbRAG\...V4...\tools\uxb_harita_doldur.py --saglayici gemini|chatgpt|claude|kimi --is amac|modul|hepsi [--dry-run --max-istek --max-dakika]`, launcher `scripts\42_harita_doldur.bat`. Keys + per-provider model/RPM/RPD in `%USERPROFILE%\.uxb\api_anahtarlari.env` (outside project; Mete fills keys himself — Claude must never write keys). Claude path uses the official `anthropic` SDK (NOT installed yet: `python -m pip install anthropic`), default claude-opus-5 effort low + server-side fallbacks. Old Gemini-only files moved to `%TEMP%\uxb_eski_gemini_20260927`. Batched: ~219 requests for 6546 routine purposes + 419 (one per file: summary+role+SSS). Writes `amac_onbellek.jsonl` (source=gemini), `modul_ozet_onbellek.jsonl`, `sss_onbellek.jsonl`; `uxb_ajan_paketi.py` renders `[gemini]` labels, `> Rol:` lines, `sss/S*.md` + `sss_dizini.tsv`. Needs GEMINI_API_KEY (not set as of 2026-09-27). V5 "yama motoru" code is NOT on disk (docs only); YamaMotoru 4.0 + ChatGPT browser bridge live in `UXB_CONTROL_CENTER_V1_1`.

**Why:** a command sat 15 h waiting for approval (Remove-Item) and Mete ran it in parallel → two builds raced on the same exe. Token cost of re-orienting each session was high.
**How to apply:** read MIMARI.md first; build/test only via tools\claude scripts (allowlisted, no approval wait); avoid Remove-Item in commands (use Move-Item or let scripts clean TEMP). See [[omniroute-and-map-setup-2026-09-24]].
