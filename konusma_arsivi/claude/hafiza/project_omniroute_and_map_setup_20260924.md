---
name: omniroute-and-map-setup-2026-09-24
description: "OmniRoute (local AI router, port 20128) MCP wiring + UxbRAG map skill set up 2026-09-24; key via env var, status of purpose-fill run"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-24T20:45:50.471Z
---

- **OmniRoute 3.8.50** kurulu (npm global, `%APPDATA%\npm\node_modules\omniroute`), `http://localhost:20128`, MCP ucu `/api/mcp/stream` (110 araç: yönlendirme, RTK+Caveman sıkıştırma, hafıza, kullanım). Paket `.env`'inde `REQUIRE_API_KEY=false` olmasına rağmen `/v1/models` ve MCP **401** döndü → panelde anahtar zorunlu; anahtarı Mete panelden üretir.
- Proje kökünde `uxb/.mcp.json` yazıldı: `Authorization: Bearer ${OMNIROUTE_API_KEY}` — anahtar dosyada DEĞİL, Mete'nin kullanıcı ortam değişkeninde (Claude anahtarı görmez/girmez).
- Claude Code model trafiğini OmniRoute'tan geçirmek (`ANTHROPIC_BASE_URL`) YAPILMADI — Mete'nin ayrı kararı (gizlilik: tüm kod 3. taraf sağlayıcılara gidebilir; sıkıştırma istemi değiştirir).
- Harita: `uxb/.claude/skills/uxb-harita/SKILL.md` (UxbRAG V4 `ajan_paketi/rutinler.tsv` üzerinden sembol arama). 2026-09-24 23:37 yenilendi: 7268 rutin, amaçlı %8.
- Amaç doldurma 2026-09-24 ~23:40 başlatıldı: `uxb_purpose_fill.py --max-minutes 240`, BelowNormal öncelik, log `UxbRAG/.../logs/amac_uret_20260924.log`; bitince `uxb_ajan_paketi.py` ile paket yenilenmeli.
- 2026-09-24 akşamı C: 0 GB'a düştü (harita yazımı `No space left` ile kırıldı); Mete boşalttı (~4 GB). Yenilemeden önce boş disk kontrolü şart.

**Why:** Mete düşük token + OmniRoute kullanımı istedi; anahtar/ yönlendirme kararları onda.
**How to apply:** Yeni oturumda önce `OMNIROUTE_API_KEY` tanımlı mı ve MCP bağlı mı bak; sembol aramada [[uxb-map-tooling-evaluation-2026-09-19]] ve uxb-harita skill'ini kullan.
