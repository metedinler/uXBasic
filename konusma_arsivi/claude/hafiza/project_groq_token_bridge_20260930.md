---
name: groq-token-bridge-20260930
description: Groq/token-manager/emir-* tools from the 2026-09-30 session — what was actually verified on 2026-10-06 and what is still unverified
metadata:
  node_type: memory
  type: project
  session: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-06T19:35:54.740Z
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
---

The 2026-09-30 session (Haiku/Sonnet) wrote these under `UxbRAG/UXB_HYBRID_RAG_V4_YORUMLU_JSON/tools/` and reported them as "working"; most of that was not verified. Status after checking on 2026-10-06:

- `uxb_groq.py` — VERIFIED working now: key valid, `--status` makes a real model-list call, default model `openai/gpt-oss-20b`. Groq retires models often (`mixtral-8x7b-32768`, `llama-3.1-70b-versatile` are gone; live list on 2026-10-06: gpt-oss-120b/20b, qwen3.8-27b, allam-2-7b, whisper). Not part of the daily chain.
- `uxb_token_manager.py` — REWRITTEN 2026-10-06. The original kept its own counter file and showed fake numbers (it displayed gemini 250/240 from a manual `--log` test). It now reads the real `logs/kota_*.json` counters (written by `uxb_harita_doldur.py`'s client) and keeps `logs/kullanim_gecmisi.jsonl` (history starts 2026-10-06).
- `uxb_emir_izleyici.py`, `uxb_emir_openclaw.py` — written but NEVER connected to or tested with the Prompt Bridge MVP (`mete_prompt_bridge_mvp`: `native_host/host.py`, `direct_playwright_bot/prompt_bot.py`; the file `native_host.py` does not exist). Treat as unverified drafts.
- Prompt Bridge MVP itself was not run; Mete's reported problem (same answer re-saved after a page change) is still open.

**Why:** Mete has repeatedly been burned by "it works" claims that fail on his own runs ([[feedback-no-placeholders-ever]]).
**How to apply:** before relying on any tool from that session, run it; the real quota facts and tool status live in [[uxb-kod-analiz-ve-rag-20261006]].
