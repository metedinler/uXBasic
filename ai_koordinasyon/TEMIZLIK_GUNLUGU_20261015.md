# Temizlik günlüğü: 2026-10-15

**Yetki:** Mete, 2026-10-15 (sohbet): "hepsi önerdiğin gibi olsun, sadece zip dosyalarını silme. 'sor' olarak yazılan dosyalar kalsın. 'temizle' kararı olanları kaldır."
**Öneri belgesi:** `DOSYA_ENVANTERI_VE_TEMIZLIK_ONERISI_20261014.md` (öneriler ve gerekçeler orada).
**Yöntem:** her silmeden hemen önce içerik yeniden doğrulandı (Kademe 1: SHA-256, özgünüyle aynı mı; Kademe 3: boyut + CRC32, bir zip'in içinde var mı). Zip dosyalarına hiç dokunulmadı. Silinen dosya listeleri yerelde saklıdır (her satır: yol, boyut, özet); özet tablo: `TEMIZLIK_ADAY_OZETI_DLL_KOPYALARI_20261014.tsv`.

## Yürütülenler

| Kademe | Ne | Silinen | Boşalan | Güvence |
|---|---|---:|---:|---|
| 1 | `uxb\reports\**\*.dll` kopyaları (çalışma zamanı ve kütüphane DLL'leri) | 21 663 dosya | **33,01 GB** | Her dosya, `bin`/`native`/`runtime_ext`/`dist` altındaki özgünüyle SHA-256 düzeyinde aynıydı; 104 özgün dosya silmeden önce yeniden doğrulandı. Hata 0, uyuşmayan 0. |
| 3 | `UXBc\release_packages` içindeki iki çıkarılmış klasör (aynı paketin `…160659` ve `….verify` kopyaları) | 2 × 1 315 dosya | 0,54 GB | Her dosya zip'lerde boyut + CRC32 ile bulundu |
| 3 | `UXBc\dist\_stage` | 8 877 dosya | 1,79 GB | aynı |
| 3 | `UXBc\dist\_verify` | 363 dosya | 0,18 GB | aynı |
| 3 | boşalan klasörler | 1 703 klasör | — | yalnız boş olanlar |
| **Toplam** | | **33 533 dosya** | **≈ 35,5 GB** | C: boş yer **3,02 GB → 38,41 GB** |

## Yapılmayanlar ve nedenleri

| Öğe | Neden |
|---|---|
| Her türlü `.zip` (kökteki 4 yedek zip, `dist` ve `release_packages` zip'leri, `reports.zip`, `uxb_runtimes.zip`) | Mete: "zip dosyalarını silme" |
| `UXBc\uxb(06.06_…).zip` (4,1 GB), `UXBc(birinci gelistirme bitti).rar` (2,8 GB) | Zip/rar; ayrıca Mete'nin kilometre taşları |
| Son 48 saatte oluşan 1 614 DLL kopyası (≈ 1,7 GB, `compiler_consolidation\20261013_*` ve `20261014_*`) | Canlı koşu olabilir; Codex çalışıyor. İstenirse 2 gün sonra aynı betikle silinir |
| `reports` içindeki `.obj`/`.exe` (Kademe 2, 1,6 GB) | Önerim "gerekirse" idi; yer yeterli (38 GB boş) |
| `inventory_downloads`, `release_assets`, `Snapshoots`, `tools\FreeBASIC` kopyası, `tekdosyaklsoru`, `xtestx`, `tool_py`, `game`, `tmp\codex_build_baseline`, `bin\*` | "sor" ya da "dokunma" olarak işaretliydi |
| `.gitnexus` (100 MB) | "TEMİZLE adayı" idi ama Codex'in kod grafiği aracının canlı indeksi; kazanç küçük, risk var. Yalnız GitHub'a girmeyecek |
| `test_results`, `test_results_asm` (13 MB) | Codex'in aktif testleri buraya yazıyor; kazanç küçük |
| Zip'te bulunmayan 206 küçük dosya (`dist\_stage` 7, `dist\_verify` 199; 3,3 MB doğrulama koşusu çıktıları) | Downloads kuralı: zip'te olmayan dosya korunur |
| `release_packages` içindeki iç zip'ler (her klasörde 1 adet) | zip |

## Geri alma yolu

- Kademe 1: silinen DLL'ler `bin\` ya da `dist\runtime_ext\`, `dist\libraries\` altındaki özgünlerinin birebir kopyasıydı; gerekirse oradan kopyalanır.
- Kademe 3: silinen dosyalar aynı paketin zip'lerinden çıkarılabilir.

## Uyarı: yer yeniden dolar

Kök neden `S-117`dir (kitapta G-ARAC-7): her `uxb bld --build-x64` çıktı klasörüne yaklaşık 6,5 MB çalışma zamanı DLL'si, FFI kullanan programlara çok daha fazlasını kopyalar ve bunu kapatan bir seçenek yoktur. Yüzlerce programı ayrı klasörlere derleyen bir koşu `reports\` klasörünü yeniden şişirir. Düzeltilene dek ayda bir aynı doğrula-ve-sil betiğinin çalıştırılması önerilir.
