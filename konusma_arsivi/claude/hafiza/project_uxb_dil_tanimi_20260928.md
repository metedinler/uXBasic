---
name: uxb-dil-tanimi-20260928
description: "The single canonical uXBasic language spec effort (Mete 2026-09-28) — goal, file layout, tools, team (Claude workflow + Codex CLI + Kimi/Gemini API), quotas, status"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-28T20:26:53.254Z
---

Mete 2026-09-28: the real goal of the "books" is ONE definitive document defining uXBasic — every command, function,
operator, data type, data structure, library working per its design, backward compatible with the previous version; must
also collapse redundant command variants. Honest, verified, no placeholders. Mete bought extra capacity and wants Codex,
Kimi and Gemini used as a team ("harcadığım paranın hakkını istiyorum"). He also said he cannot see whether the map/RAG
system runs or where to click — give him visible status, not claims.

Layout (all under `uxb/`):
- Guide for every agent/model: `docs/kitaplar/_ortak/dil_tanimi/YONERGE.md` (bans, Mete's type rules, source-priority order:
  Mete decisions > docs/tasarim > tests/xtestx compatibility corpus > current code > old books; KARARLI/ÖNERİ/KARAR GEREKİYOR;
  variant classes KANONİK/EŞ ANLAMLI/ESKİ/KALDIRILMALI; chapter template; ogeler.json schema).
- Per-area output: `docs/kitaplar/_ortak/dil_tanimi/alanlar/<kod>/{bolum.md, ogeler.json, ornekler/, sonuc.json, denetim.md, codex/}`
  — 17 areas 01_sozcuk … 16_derleyici_motorlar (15a/b/c = libraries).
- Final single doc: `docs/kitaplar/UXBASIC_DIL_TANIMI.md`, built by `tools/kitap/dil_tanimi_birlestir.py` (Ek A conformance,
  Ek B decisions, Ek C bugs, Ek D library signature catalogue, Ek E coverage gaps vs lexer/yüzey; exit 3 = coverage gap).
- Tools: `tools/kitap/yuzey_tara.py` (surface from source: 241 keywords, 167 builtin candidates, 46 libs/2422 funcs),
  `tools/kitap/ornek_dogrula.py` (AST/MIR/x64 runner, `'=` expected lines, temp cwd, 60 s + 2 MB caps, --kok/--sonuc per agent),
  `tools/kitap/dis_danis.py` (Kimi/Gemini/ChatGPT reviewer via uxb_harita_doldur client; tested OK with gemini2).
- Workflow run `wf_c0788282-e2e` launched 2026-09-28 ~23:00: per area write → Codex CLI audit (`codex exec --sandbox read-only`).

Team facts (2026-09-28): Codex CLI 0.148 at `%LOCALAPPDATA%\Programs\OpenAI\Codex\bin\codex.exe` works non-interactively
(~90 s small query). No gemini/kimi CLI installed; Kimi/Gemini only via API keys. Quotas: Kimi self-limit 100/day (Mete's
choice — don't raise without asking), Gemini free ~40/day per model (gemini2 = gemini-3.5-flash separate quota), OpenAI key
returns 401 (invalid), Anthropic API "credit balance too low" (subscription ≠ API credits). Map-fill chain stopped 19:38 that
day; watcher not running; modül-özet/SSS not started.

**Why:** Mete is frustrated by repeated "it works" claims that fail on his own test programs; this doc is the contract.
**How to apply:** continue from these files; never mark something working without an ornek_dogrula/test run; bring new
bugs into SORUN_TAKIP (S-171…S-190 came from this effort); see [[uxb-type-naming-rules]], [[feedback-no-placeholders-ever]].
