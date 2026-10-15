---
name: feedback_eski_astx64_dondurulmaz_20261014
description: "Mete 2026-10-14: eski AST-x64 DONDURULMAZ, tüm motorlar gibi aynı sonucu verecek şekilde düzeltilecek; 'açık ret' kalıcı çözüm değil, ara durum"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-14T14:21:18.383Z
---

Mete (2026-10-14, kendi sözleriyle): "eski ast x64'ü dondurmayacağım, tüm motorlar gibi bu motorda çalışacak."

**Why:** S-157-L'de 2026-09-26'dan beri açık duran "legacy dondurulup STRING programları açık redle mi karşılansın, yoksa düzeltilsin mi?" sorusunun cevabı budur: **düzeltilecek**. Altı yolun (AST, MIR, MIR-x64, eski AST-x64, JS, WASM) hepsi aynı programa aynı sonucu verecek; eski yol için ayrı, daha gevşek bir sözleşme yok.

**How to apply:**
- Eski AST-x64 kusurlarını (S-524…S-538, S-157-L, S-086, S-091) "kabul edilmiş sınır" diye kapatma, "açık ret var" diye yetinme; kayıtlar aynı program altı yolda aynı sonucu verene dek açık kalır.
- Kitapta ve raporlarda bu yolu "dondurulmuş" diye anlatma (Bölüm 1.3, 23.6 ve Ek K bu karara göre güncellendi; 23.6'da 2026-10-14 satırı var).
- Kabul ölçütü: `yoklama/vaka/iddia_eski_astx64.iddia.json` (15 vaka) ve `gerileme_sondalari.py` (S-528 dahil) altı yolda yeşil.
- Uygulamayı Codex yapar, değer düzeyinde altı yolda doğrulamayı ben (AGENTS.md). Düzeltme sırası önerisi: önce 20261013'ten beri gerileyenler (S-523, S-535, S-539, S-540, S-543), sonra sessiz yanlışlar, sonra çökmeler, sonra eşlik farkları ve ret iletisi kalitesi.
- Kayıtlar: `ai_koordinasyon\DURUM.md` ("2026-10-14 17:04 Claude — Mete kararı…"), `KARAR_VE_GOREV_DEFTERI.md` (2026-10-14).

İlgili: [[project_uxb_eski_astx64_bulgulari_20261014]], [[feedback_her_kusur_sorun_takibe]], [[project_uxb_kilavuz_v2_20261008]].
