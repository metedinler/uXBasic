---
name: project-git-infrastructure-broken
description: "ÇÖZÜLDÜ (2026-10-14 doğrulandı): 2026-09-06'daki 'git bozuk' bulguları (111k satırlık .gitignore, 0 commit, uzak adres karışıklığı) artık geçerli değil. GEÇERLİ KALAN: dist\\runtime_ext\\deps ONNX kuralları (uxonnx2 1.18.1 dokunulmaz, uxonnx\\lib etkin kopya) ve build\\ klasörü bilerek tutulur."
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-14T14:36:02.407Z
---

**Durum 2026-10-14 (ölçüldü):** 2026-09-06'da yazdığım "git bozuk" tablosu bugün **geçerli değil**: `.gitignore` 69 satır (111 628 değildi artık), repoda geçmiş var
(son commit'ler `fd42dee`, `07550bb`), uzak depo tek: `origin https://github.com/metedinler/uXBasic.git` (eski `UxBasic_Full` / `uXBasic-Compiler-` ikilisi
kalktı). Yer tutucu kimlik yalnızca `git config`'te duruyor; `07550bb` gerçek e-postayla atıldı. Güncel git ayrıntıları ve gönderme koşulları:
[[project-no-git-manual-zip-backups]] ve `ai_koordinasyon\DOSYA_ENVANTERI_VE_TEMIZLIK_ONERISI_20261014.md` bölüm 7.

**Hâlâ geçerli olan: `dist/` içeriği (2026-09-06 araştırması).** `dist/` yalnız çıktı değildir; içinde `dist/runtime_ext/deps/` bir **derleme-zamanı bağımlılık önbelleğidir**
(uxonnx/uxonnx2 kütüphane modülleri için üçüncü taraf ONNX Runtime kopyaları). Kullanıcı bunun `dist/` dışında ayrı bir `bagimliliklar/` klasörüne taşınmasını
istemişti (karar 2026-09-06; derleme betiklerinin yolları güncellenmeden yapılmamalı; **yapılmadı**). `build/` klasörü bilerek olduğu gibi tutulur: kullanıcı derleme
çıktılarını burada inceler, artık değildir.

- `runtime_ext/uxonnx/fetch_uxonnx_deps.ps1` her çalıştığında GitHub'ın *en son* sürümünü indirir ve kendi `archive/` klasöründeki eskileri silmez (betik kusuru, küçük
  bir gelecek düzeltme adayı). `runtime_ext/uxonnx2/fetch_uxonnx2_deps.ps1` ise `uxonnx2` modülü için bilerek `1.18.1` sürümünü sabitler: **o kopya gereksiz değildir,
  hiçbir "ONNX kopyalarını temizle" turunda dokunulmaz.**
- 2026-09-06'da açık onayla gerçekten silinen iki gereksiz çıkarılmış kopya: `dist/runtime_ext/deps/uxonnx/archive/onnxruntime-win-x64-1.26.0/` ve `.../1.27.0/` (~800 MB;
  `dist/runtime_ext` 1,9 GB → 1,1 GB; bugün `uxb\dist\runtime_ext` ≈ 1,04 GB).
- Eski cevapsız soru kapandı: `dist/runtime_ext/deps/uxonnx/archive/onnxruntime-win-x64-1.27.0.zip` (74 MB) 2026-10-14'te **artık yok** (doğrulandı). Etkin kopya
  `dist/runtime_ext/deps/uxonnx/lib/` ve `uxonnx2/download/onnxruntime-win-x64-1.18.1/` **durmalı**.
- `dist/release/` iki tarihli (2026-07-29) tam yayın zip'i (~168–169 MB) içerir; bunlar gerçek dağıtım dosyalarıdır, atık değil.

**How to apply:** `dist\` temizliğini önerirken `runtime_ext\deps` kısmını **dokunulmaz** say; temizlik adaylarını `reports\`, eski paket/yayın artıkları ve zip yedeklerinden seç
(bkz [[project_uxb_temizlik_github_plani_20261014]]). Git işlemleri (commit, push, uzak depo, `git add -A`) dışa dönük işlemlerdir: önce Mete'ye sor.
