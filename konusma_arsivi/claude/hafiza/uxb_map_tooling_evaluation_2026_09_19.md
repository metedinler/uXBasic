---
name: uxb-map-tooling-evaluation-2026-09-19
description: "Measured verdicts on tree-sitter-freebasic, ctags, Codex map inventory and RAG embedding speed for the UXBc low-token map effort"
metadata: 
  node_type: memory
  type: project
  originSessionId: daa670ab-909d-468d-8c52-0749d291c88a
  modified: 2026-09-19T04:52:20.387Z
---

2026-09-19 ölçümleri (UxbRAG V4 altında, gerçek `uxb/src|include|libsx|runtime_ext|compiler` kaynaklarıyla):

- **tree-sitter-freebasic (Ra77a3l3-jar, 6 KB oyuncak gramer) kullanılamaz**: 200/200 dosyada hata, baytların %90'ı ERROR. TYPE/DECLARE/#include/SELECT CASE/dizi/üye erişimi yok. Hazır `tree-sitter-language-pack`'te de FreeBASIC yok. Derlenmiş kopya `UxbRAG/.../tools/uxb_map/` içinde (freebasic.dll + .venv), silinmedi.
- **Universal ctags 6.1.0 `Basic` ayrıştırıcısı** (C:\Program Files\CodeBlocks\MinGW\bin) FreeBASIC'i okuyor; `--langmap=Basic:+.fbs`. Codex'in `uxb_map_system.py` envanteriyle (dosya,isim) bazında ~%96-98 örtüşüyor (6032 ortak). Bağımsız doğrulayıcı olarak kullanılabilir, omurga değil (Codex koleksiyoncusu parametre/dönüş/TYPE alanı/yorum da çıkarıyor).
- **Asıl eksik: "amaç" alanı** — 6403 fonksiyon/sub/metotun yalnızca %4.5'inde `purpose` dolu (girdi %90, çıktı %97 dolu). Amaç bir parser'la çıkmaz; LLM ile, devam ettirilebilir (checkpoint'li) toplu iş gerekir.
- **RAG vektörleştirme darboğazı**: core profil 2444 dosya = 39.092 chunk; `nomic-embed-text` ~1 chunk/sn (≈11 saat), `all-minilm` ~12.6 chunk/sn (≈52 dk). `uxb/compiler/wrappers/uxb_main_wrapper.c` (23 MB üretilmiş C) tek başına 16.491 chunk üretiyor; `docs` 13.700 chunk.
- `index/symbol_index_core.json` 80 MB (eski: 270 MB): kaba büyük-harf-kelime indeksi, gerçek sembol tablosu değil; gerçek sorgu için Codex'in `reports/uxb_map_system/<tarih>/symbol_inventory.json` + `tools/uxb_map_lookup.py` kullanılmalı.

## Kurulan sistem (2026-09-19, UxbRAG/UXB_HYBRID_RAG_V4_YORUMLU_JSON altında)
- `tools/uxb_purpose_fill.py`: yerel `qwen2.5-coder:3b` ile rutin başına 1 Türkçe cümle; append-only `ajan_paketi/amac_onbellek.jsonl`, anahtar = sha1(dosya|ad|gövde) (kaldığı yerden devam). Makine CPU-only (i7-10610U, 15.6 GB, GPU yok): ~10-18 sn/rutin, ~5.8k rutin ≈ 20+ saat. 3B model kısaltmaları uyduruyor ("MIR = Mirrored/Middleware…"), süzgeç yalnız önek/2. cümle/parantezli açılımı atıyor; çıktı `[llm]` = DOĞRULANMAMIŞ etiketiyle sunulur.
- `tools/uxb_ajan_paketi.py` -> `ajan_paketi/` (OKU_BENI.md, kapsam.md, rutinler.tsv, modul_dizini.tsv, moduller/M*.md, tipler/T*.md). Yenileme: `scripts/41_ajan_paketi_yenile.bat`; amaç üretimi: `scripts/40_amac_uret.bat`. Ajanlara `uxb/ai_koordinasyon/DURUM.md` kaydıyla duyuruldu (ayrıca CLAUDE.md/AGENTS.md OLUŞTURULMADI — ajanlar protokol+DURUM.md üzerinden yönleniyor).
- Codex'in `uxb_map_system.py` toplayıcı hatası düzeltildi: tek satırlık `Type X As Y` (250 adet) kapsayıcıyı açık bırakıyordu → 114 sahte METHOD + sahte FIELD (dim/…) kayıtları; artık 0.
- `config.core.json`: `chroma_source_roots` (yalnız docs + ai_koordinasyon = 14.085 chunk ≈ 3.9 sa nomic) ve `uxb_main_wrapper.c` hariç; rg hâlâ tüm source_roots'ta. Vektörleme HENÜZ ÇALIŞTIRILMADI (`scripts/31_core_indexle.bat`).
- Dil yüzeyi envanteri (`surface_inventory.json`) gürültülü (preprocessor 7/73 gerçek): pakete konmadı; gerçek lexer tablolarından ayrıca çıkarılmalı (açık iş).
- Kaynaklar sürekli değişiyor (başka oturum/Codex): harita eskirse kapsam.md uyarır.

**Why:** Kullanıcı aynı envanter işini defalarca yarım bıraktığından, hangi aracın gerçekten işe yaradığını ölçümle bilmek gerekiyor; tekrar tree-sitter/regex denemesi yapılmasın.
**How to apply:** Harita/indeks önerirken bu sayılara dayan; "amaç/görev" doldurmak için LLM'li resumable pipeline öner, yeni parser yazmayı önerme.
