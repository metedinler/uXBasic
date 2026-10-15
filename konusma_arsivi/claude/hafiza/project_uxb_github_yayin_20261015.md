---
name: project_uxb_github_yayin_20261015
description: "2026-10-15 GitHub yayını: metedinler/uXBasic (herkese açık) deposuna yayin/20261015 dalı gönderildi; tasarım+tüm dokümantasyon+konuşma/hafıza arşivi dahil (gizli anahtarlar ayıklandı); main'e birleştirme Mete'de. Yöntem: Codex'e dokunmayan geçici indeks"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-15T11:16:57.972Z
---

**Karar (Mete, 2026-10-15):** tasarım belgeleri, tüm dokümantasyon, kütüphaneler ve konuşma/hafıza dosyaları (Claude, Codex, ChatGPT; dosya başına 100 MB sınırıyla) GitHub'a gitsin. Depo **herkese açıktır** (`private=False`), yazar `metedinler` (kimlik no 62749570).

**Ne gönderildi:** dal `yayin/20261015` (main'e doğrudan değil; birleştirmeyi Mete GitHub'da yapar: `https://github.com/metedinler/uXBasic/pull/new/yayin/20261015`). 10 commit, kimlik `metedinler <62749570+metedinler@users.noreply.github.com>`: A 07550bb içeriği yeniden damgalandı (eski commit gerçek Gmail taşıyordu, hiç yayınlanmamıştı) · B/C 137 izlenen dosyadaki çalışma ağacı değişiklikleri (Codex işi, anlık görüntü) · D 1 164 yeni test · E 301 araç dosyası (`tools\kitap` vb.; FreeBASIC/wabt/uxotcc hariç) · F yayın politikası (`.gitignore`: `ai_koordinasyon`, `docs/tasarim`, `spec` artık dışlanmıyor; `DESIGN-RIGHTS-RESERVED.md`: "okumak için yayında, lisans vermez") · G `docs` tamamı (1 909 dosya) · H `ai_koordinasyon`+`spec` · I kök belge dosyaları `docs/kok_notlari/` altında + `.claude` beceri/ajan tanımları · J `konusma_arsivi/` (89 dosya, 255 MB, en büyüğü 88,8 MB). **Dahil değil:** `tekdosyaklsoru`, `xtestx`, `tool_py`, `game`, `.gitnexus`, kök patch artıkları, Codex oturum günlükleri (651 MB), `auth.json`/`config.toml`, canlı transcript.

**Gizli anahtar sonucu (ÖNEMLİ):** konuşma arşivlerinde gerçek görünümlü anahtarlar vardı (Groq `gsk_…` ×25, `sk-…` ×14, `sk-ant-…` ×2, Bearer ×8; 8 dosya). Yayın kopyalarında `[GIZLI-SILINDI:<tür>]` ile değiştirildi (orijinaller yerel diskte olduğu gibi duruyor). **Mete'ye yenilenmesi önerildi** (anahtarlar konuşmalarda göründü). Kişisel Gmail adresi arşivlerde `[e-posta]` yapıldı; zaten `cli_help.fbs` ve `Programcinin Cep Kitabi.md` içinde iletişim olarak yayında. Gönderilen 4 076 metin blobunda kalan gizli değer 0 (`dal_tara`).

**Yöntem (tekrarlanabilir):** Codex'in çalışma dizinine/HEAD'ine/indeksine dokunmamak için `GIT_INDEX_FILE` geçici indeks + `hash-object -w --stdin-paths` + `update-index --index-info -z` + `commit-tree` + `update-ref`; `git add -A` yapılmadı. Yerel `main` hâlâ 07550bb'de (gerçek e-postalı commit): **main'i olduğu gibi push etme**; birleştirme sonrası `git fetch` ile yenile. Auth: Windows Credential Manager (GCM) sessizce çalışıyor, `git push --dry-run` ile denenir.

**Why:** Mete bu işi "tasarım ve dokümantasyon açık olsun" diye istedi; geri alınamaz ve herkese açık olduğu için tarama + kopya + yeniden damgalama yapıldı. **How to apply:** yeni yayında aynı tarama (gizli anahtar, kişisel veri) ve noreply kimliği; yayınlanan şeyi değiştirmek için yeni commit; push öncesi `--dry-run`. İlgili: [[project_uxb_temizlik_github_plani_20261014]], [[project-no-git-manual-zip-backups]].
