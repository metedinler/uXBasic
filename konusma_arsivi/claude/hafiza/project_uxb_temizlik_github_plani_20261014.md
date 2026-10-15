---
name: project_uxb_temizlik_github_plani_20261014
description: "2026-10-14 envanter önerisi 2026-10-15'te Mete onayıyla UYGULANDI: reports DLL kopyaları + zip'li eski paketler silindi (≈35,5 GB, C: 3→38 GB); GitHub'a yayin/20261015 dalı gönderildi. Kök neden S-117 çözülmedi, yer yeniden dolar"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-15T11:16:45.100Z
---

**Durum (2026-10-15):** `uxb\ai_koordinasyon\DOSYA_ENVANTERI_VE_TEMIZLIK_ONERISI_20261014.md` önerisi Mete'nin 2026-10-15 cevabıyla ("hepsi önerdiğin gibi olsun, sadece zip dosyalarını silme; 'sor' olanlar kalsın; 'temizle' olanları kaldır; GitHub'a gönder; tasarım ve tüm dokümantasyon gitsin; konuşma/hafıza dosyaları 100 MB sınırına göre gitsin") **uygulandı**. Günlük: `ai_koordinasyon\TEMIZLIK_GUNLUGU_20261015.md`.

**Silinenler:** `uxb\reports` içindeki 21 663 DLL kopyası (33,01 GB; her biri SHA-256 ile özgünüyle aynı doğrulandı, silmeden hemen önce yeniden) + `UXBc\release_packages` (2 çıkarılmış klasör) ve `UXBc\dist\_stage`/`_verify` içinde bir zip'te boyut+CRC32 ile bulunan 11 870 dosya (2,52 GB). Zip'lere hiç dokunulmadı. C: boş 3,02 → 38,41 GB. **Yapılmayanlar:** zip/rar'lar, "sor" olanlar (`inventory_downloads`, `release_assets`, `Snapshoots`, FreeBASIC kopyası…), `.gitnexus` (Codex aracı), son 48 saatin 1 614 DLL'i (≈1,7 GB; 2 gün sonra aynı betikle), `reports` `.obj`/`.exe` (Kademe 2).

**Kök neden (yer yeniden dolar):** `src\build\x64_build_pipeline.fbs` `link.bat` üretimi her `bld --build-x64` çıktı klasörüne ≈6,5 MB DLL (FFI/kütüphane programlarına çok daha fazlasını) kopyalar; kapatan/paylaşan seçenek yok. Kayıt **S-117** (güncelleme notu eklendi), kitapta **G-ARAC-7**. Doğrula-ve-sil betikleri scratchpad'dedir (kalıcı değil); yöntem: özgünün hash'i → kopyanın hash'i → eşleşmezse dokunma → **silmeden hemen önce yeniden hash**; zip'li klasörler için boyut+CRC32 kapsama denetimi; zip'te olmayan dosya kalır.

**Kurallar (hâlâ geçerli):** `reports\` silmeleri için Mete'ye liste ile önceden sorulur (2026-09-20); Downloads kuralları belgesi (`DOWNLOADS_SILME_VE_RAG_KORUMA_KURALLARI.md`); dokunulmaz: `bin\*` (Codex çalışıyor), `tmp\codex_build_baseline`, `game\`, `dist\runtime_ext\deps` (uxonnx2 1.18.1 sabit), `UXBc\claude_arsiv`, kök zip/rar'lar, `tools\FreeBASIC`, `wabt`. GitHub gönderimi: bkz [[project_uxb_github_yayin_20261015]].

**Why:** disk 3,7 GB'a düşmüştü (S-117 olayı tekrar riski). **How to apply:** 2 gün sonra kalan 1 614 DLL ve gerekirse Kademe 2 için aynı doğrula-ve-sil yöntemi; yeni bir temizlikte Mete'ye önce tam liste. İlgili: [[feedback_build_folder_deletion_permission]], [[feedback_verify_before_destructive_action]], [[project-git-infrastructure-broken]].
