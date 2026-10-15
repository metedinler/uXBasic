---
name: openclaw-uxb-manager-2026-09-28
description: "OpenClaw 'uxb' manager (Kimi K2.7 Code, profile uxb) + guarded YamaMotoru patch pipeline + map-fill chain; where things live, safety limits, what failed"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-28T14:46:57.747Z
---

Built 2026-09-28 at Mete's request (Mete chose: guarded auto-apply, OpenClaw on Kimi, paid ≤100 req/day, free Gemini first).
Folder: `UXBc\UXB_CONTROL_CENTER_V1_1\UXB_CONTROL_CENTER_V1_1\openclaw_uxb\` — `OKU_BENI.md`, `uxb_ajan.py` (agent's single CLI:
durum/harita-*/sorunlar/sorun/ara/sss/yedek/danis/uygula/gunluk), `uxb_yama_danis.py` (asks gemini→kimi with FULL line-numbered
modules + kılavuz §10 rules, YamaMotoru dry-run, ≤3 fix rounds, never writes source), `uxb_yama_uygula.ps1` (guard: allowed dirs,
20-min co-edit ban, baseline build+suites BEFORE, apply, rebuild, rollback-last on NEW failures; log
`uxb\ai_koordinasyon\OPENCLAW_YAMA_GUNLUGU.md`), `uxb_openclaw.ps1` (loads keys from `%USERPROFILE%\.uxb\api_anahtarlari.env` into
process env only, runs `openclaw --profile uxb`), `uxb_oturum.ps1` (zip backup to `UXBc\yedekler` + agent turn), `uxb_harita_sonrasi.ps1`
(watcher: restart map fill daily, trigger OpenClaw when log says "tüm işler tamamlandı"), `calisma\AGENTS.md` (rules).

- OpenClaw 2026.2.21: global config `${ENV}` refs are mandatory at every start → adding moonshot provider to the MAIN profile broke
  OpenClaw; restored from `%TEMP%\openclaw_json_yedek_*.json`. Use isolated profile `uxb` (`~\.openclaw-uxb`). Moonshot model needs
  `reasoning:false` + `--thinking off` (else "Message ordering conflict"). Account Kimi models: kimi-k2.6, kimi-k2.7-code(+highspeed), kimi-k3.
- **Exec allowlist is NOT enforced in `--local` mode** (cmd ran despite tools.exec.security=allowlist) → agent has full shell; safety =
  AGENTS.md + single CLI + backups + guarded applier. Told Mete.
- YamaMotoru fixed to 4.0.1 (silent command-drop after `#B` block; unrecognized-command error; 17 tests). Manual:
  `tools\yama_v4\YAMA_MOTORU_V4_KILAVUZU.md/.txt`.
- Map filler `UxbRAG\...V4...\tools\uxb_harita_doldur.py --saglayici zincir` (UXB_ZINCIR gemini,kimi,chatgpt,claude), whole-module
  sending, folder bundles `ajan_paketi\gonderim\*.txt` (131 parts) with one-time upload (Gemini/Claude Files API). Gemini output quality
  verified excellent (exact line numbers). OpenAI key rejected 401 (2026-09-28). anthropic SDK not installed.
- End-to-end test: danis S-087 via Kimi → DRYRUN_TAMAM first round (uses existing `__uxb_rt_str_u64`).

**Why:** Mete wants the map filled by external AIs and OpenClaw to autonomously fix small issues with Gemini/Kimi answers.
**How to apply:** check `python uxb_ajan.py durum` and the patch log before touching files OpenClaw may have changed; OpenClaw
patches need SORUN_TAKIP follow-up by Claude/Codex. See [[claude-automation-setup-2026-09-27]].
