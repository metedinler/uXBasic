# Dosya envanteri, temizlik önerisi ve GitHub planı

Tarih: 2026-10-14 (öneri), güncelleme 2026-10-15 · Hazırlayan: Claude · **Durum: ONAYLANDI ve UYGULANDI** (Mete, 2026-10-15: "hepsi önerdiğin gibi olsun, sadece zip dosyalarını silme; 'sor' olarak yazılanlar kalsın; 'temizle' kararı olanları kaldır; GitHub'a gönder; tasarım ve tüm dokümantasyon gitsin; konuşma ve hafıza dosyaları 100 MB sınırına göre gitsin"). **Ne yapıldığı: `TEMIZLIK_GUNLUGU_20261015.md` (temizlik) ve bu belgenin sonundaki "11. Uygulama sonucu" bölümü (GitHub).** Aşağıdaki metin 14 Ekim'deki öneriyi olduğu gibi korur.

Bu belge Mete'nin 2026-10-14 isteğine cevaptır: "yazdığın belgeler nerede, gereksiz build/release artıklarını kaldıralım, yer açalım, GitHub'a kaynak kod, belge ve kütüphaneleri gönderelim, uxb altındaki tüm klasörleri inceleyelim: nerede, ne zaman, gereksiz, eski."

Ölçümler 2026-10-14 saat 16:54 ile 17:31 arasında alındı (salt okunur tarama; SHA-256 doğrulaması 17:15–17:31). Boyutlar MB = 1 048 576 bayt. Bir klasörün "en eski" tarihi bazen 2023-05-15 görünür: bu, içine kopyalanan DLL'lerin özgün dosya tarihidir, klasörün yaşı değildir.

---

## 0. Bir bakışta

| Konu | Durum |
|---|---|
| Disk | **C: 3,70 GB boş** (472 GB dolu). E: sürücüsü 2,4 GB boş; yani büyük dosyaları oraya taşıyarak yer açamayız. |
| `uxb` klasörü | 44,45 GB. Bunun **40,3 GB'ı `uxb\reports`**. |
| `reports` içinde ne var | 38,3 GB ikili dosya (**36,5 GB'ı 23 589 adet `.dll`**, 0,9 GB `.exe`, 0,7 GB `.obj`, 0,27 GB zip) ve yalnız **2,0 GB okunabilir kanıt** (json, log, csv, txt, `.uxb`, `.asm`). |
| Neden bu kadar büyük | Her `uxb bld --build-x64` çağrısı çıktı klasörüne çalışma DLL'lerini kopyalıyor ve test koşuları binlerce ayrı klasör açıyor: yalnız 119 farklı (ad, boyut) çifti var, 23 589 kopya var. |
| Sonuç | Okunabilir hiçbir kanıtı kaybetmeden **34,72 GB** kazanılabilir: **23 277 DLL kopyasının** özgünüyle birebir aynı olduğu SHA-256 ile doğrulandı (bölüm 6, Kademe 1; salt okunur deneme, hiçbir şey silinmedi). Tek klasör silmek gerekmez. **Bu yer kendiliğinden yeniden dolar**: kök neden `S-117` (her derleme çıktı klasörüne DLL kopyalar) çözülmedi. |
| GitHub | Uzak depo `metedinler/uXBasic`; `main` yerelde 1 commit önde (gönderilmemiş); 137 izlenen dosya değişmiş; 15 427 yeni dosya `.gitignore` dışında kalıyor. **`git add -A` yapılmamalı** (içine üçüncü taraf FreeBASIC derleyicisinin 3 253 dosyası girerdi). Ayrıntı bölüm 7. |
| Beklenen kararlar | Bölüm 8'de 8 madde. Bu kararlar gelmeden silme ve gönderme yapılmaz. |

---

## 1. Yazdığım belgeler nerede?

Yollar `C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\` köküne göredir.

### 1.1 Önce bunları oku

| Sıra | Belge | Yol | Boyut | Ne işe yarar |
|---|---|---|---|---|
| 1 | **Hedeflenen Sistem ve Kullanma Kılavuzu V2** | `docs\tasarim\uXBasic_Hedeflenen_Sistem_ve_Kullanma_Kilavuzu_V2_TR.md` | 1 091 KB (16 168 satır) | Ana kitap. 197 örnek, hepsi gerçek derleyicide sınandı. **Elle düzenlenmez**; `uret.py` ile üretilir (bölüm 1.2). |
| 2 | Kitap üretim raporu | `docs\tasarim\kilavuz_v2_uretim_raporu.json` | küçük | Son üretimin sayıları (bölüm, satır, örnek, geçen motor). |
| 3 | **Sorun takip defteri** | `ai_koordinasyon\SORUN_TAKIP.md` | 1 111 KB | Bulunan her kusur ayrı `S-nnn` kaydı. Bu turda eklenenler **S-524 … S-543**. |
| 4 | Kılavuz sorun dizini | `ai_koordinasyon\KILAVUZ_V2_SORUN_DIZINI.md` | 50 KB | Kitaptaki her sınır (G-… kodu) ile sorun kaydı (S-…) eşlemesi. Sorun takibin okunur özeti. |
| 5 | Durum defteri | `ai_koordinasyon\DURUM.md` | 238 KB | Kim ne zaman ne yaptı. Son girdi: "2026-10-14 17:35 Claude — Dosya envanteri, disk temizliği ve GitHub planı" (öncesi: 17:04 Mete kararı, eski AST-x64 dondurulmayacak). |
| 6 | Karar ve görev defteri | `ai_koordinasyon\KARAR_VE_GOREV_DEFTERI.md` | 104 KB | Mete'nin kararları. Son girdi: eski AST-x64 dondurulmaz (2026-10-14). |
| 7 | Eski AST-x64 ham bulguları | `ai_koordinasyon\CLAUDE_ESKI_ASTX64_BULGULAR_20261014.md` | 12 KB | 282 örneğin eski AST-x64 yolundaki ölçümü; işlendi (kayıtlar S-524…S-538). |
| 8 | Sorular ve cevaplar | `ai_koordinasyon\SORULAR_CEVAPLAR.md` | 218 KB | Mete'ye sorulan ve cevaplanan kararlar. |

### 1.2 Kitabı üreten kaynaklar (kitabı değiştirmek için bunlar düzenlenir)

| Ne | Yol | Not |
|---|---|---|
| Bölüm şablonları (26 dosya) | `tools\kitap\kilavuz_v2\sablon\*.md` | Kitabın metni burada yazılır. Ek K (ölçüm tabloları) `90_ekler.md` içinde, betikle yeniden yazılır. |
| Sınır kataloğu (341 kayıt) | `tools\kitap\kilavuz_v2\veri\sinirlar.txt` | Her kusur 5 alanlı bir satır. `sorun_eslemesi.txt` G-… kodunu S-… numarasına bağlar. |
| Üretici | `tools\kitap\kilavuz_v2\uret.py` | `python tools\kitap\kilavuz_v2\uret.py --sert` kitabı yeniden üretir. |
| Kayıt işleyici | `tools\kitap\kilavuz_v2\sorun_takibe_isle.py` | Kataloğu SORUN_TAKIP'a yazar. |
| Tablo denetimi | `tools\kitap\kilavuz_v2\tablo_denetle.py` | Kitaptaki tabloların bozuk satırını arar (şu an 0). |
| Ölçüm araçları | `tools\kitap\kilavuz_v2\yoklama\` | `vaka_kos.py` (altı yol), `gerileme_sondalari.py` (35 değer sondası), `iddia_*.json` vakaları, `yol_matrisi.py`, `cli_secenek_tarama.py`. |

### 1.3 Ölçüm kanıtları (ham veri)

| Ne | Yol |
|---|---|
| Örnek sonuçları (altı yol, çeşitli tarihler) | `docs\kitaplar\_ortak\ornek_sonuclari_*.json` (en yenisi `..._web_20261014_0253.json`) |
| Eski AST-x64 ölçümleri | `docs\kitaplar\_ortak\ornek_sonuclari_astx64_20261014_0253.json`, `..._astx64_20261007_secili.json` |
| Komut satırı seçenek taraması | `docs\kitaplar\_ortak\cli_tarama_raporu_20261014_0253.json` (902 KB) |
| Dil ve kütüphane yüzeyi | `docs\kitaplar\_ortak\dil_yuzeyi.*`, `kutuphane_yuzeyi.*`, `yuzey_kayit.json` |
| Dil Tanımı (tek kanonik belge) | `docs\kitaplar\UXBASIC_DIL_TANIMI.md` (179 KB, 2026-09-28) |
| Programlama Kuralları | `docs\kitaplar\UXBASIC_PROGRAMLAMA_KURALLARI.md` (35 KB, 2026-10-07) |

### 1.4 Benim hafıza notlarım ve konuşma arşivim

| Ne | Yol |
|---|---|
| Hafıza dizini ve notları (35 not dosyası + `MEMORY.md` dizini) | `C:\Users\mete\.claude\projects\C--Users-mete-Downloads-BasicOyunSource-UXBc-Clean-UXBc-uxb\memory\MEMORY.md` |
| Kitap çalışmasının hafıza notu | `...\memory\project_uxb_kilavuz_v2_20261008.md` (en üstte "2026-10-14 EK, öğleden sonra") |
| Eski AST-x64 bulguları hafıza notu | `...\memory\project_uxb_eski_astx64_bulgulari_20261014.md` |
| Okunabilir konuşma dökümleri (asla silinmez) | `UXBc\claude_arsiv\konusmalar\` (üst klasör: `C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\claude_arsiv\`) |

### 1.5 Benim yazmadığım ama sık lazım olacak belgeler

`docs\tasarim\` içinde 57 dosya var. Bunların 32'si `UXB_S…` ile başlayan S-numaralı **tasarım ve uygulama notları**; ilk 8 satırında yazar geçenlerin çoğu Codex (17 Codex, 2 Claude, 13'ünde yazar belirtilmemiş). Kalan 25 dosyanın arasında benim iki dosyam (kitap ve üretim raporu) ile genel tasarım belgeleri var. Bu klasörün tamamı `.gitignore` ile özeldir (bölüm 7).

---

## 2. Disk durumu

| Sürücü | Boş | Kullanılan |
|---|---|---|
| C: | **3,70 GB** | 472,2 GB |
| E: | 2,4 GB | 11,9 GB |

C: neredeyse dolu: bir derleme ya da test koşusu ortasında yer biterse sessiz bozulma olabilir (S-117 olayı: 0,02 GB boş kalmıştı). Eşik olarak en az 20 GB boş yer öneririm.

---

## 3. `uxb` altındaki her klasör: ne, nerede, ne zaman, karar

Karar etiketleri: **TUT** (çalışmak için gerekli) · **YAYINLA** (GitHub'a kaynak olarak gider) · **TEMİZLE** (yeniden üretilebilir; onayınla silinebilir) · **SOR** (ne olduğundan emin değilim ya da senin kararındır) · **DOKUNMA** (başka bir ajanın aktif alanı ya da gerekli araç).

| Klasör | MB | Dosya | En eski → en yeni | Ne işe yarar | Karar |
|---|---:|---:|---|---|---|
| `reports` | 40 331 | 178 920 | 2026-05 → 2026-10-14 | Test ve denetim çıktıları. 38,3 GB ikili, 2,0 GB okunabilir kanıt. `reports\context_index` (36 MB) belge arama dizinidir; **TUT**. | **TEMİZLE** (Kademe 1–2, bölüm 6) |
| `dist` | 1 306 | 625 | → 2026-10-14 | Paketleme çıktıları ve **derleme-zamanı bağımlılık önbelleği**: `runtime_ext` 1 038 MB (içinde `deps\` ONNX Runtime kopyaları; `uxonnx2` için sabitlenmiş 1.18.1 ve `uxonnx\lib` etkin kopyası gereklidir), `libraries` 169 MB (kütüphane DLL'leri; `deps` 128 MB üçüncü taraf), `uxb_runtimes.zip` 95 MB. `.gitignore` ile dışarıda. | **DOKUNMA** (`runtime_ext\deps` ve `libraries\deps` kütüphane derlemesi için gerekli). Yalnız `uxb_runtimes.zip` Kademe 3 adayı. |
| `bin` | 1 182 | 241 | → 2026-10-14 | 86 adet `uxb*.exe` kopyası (889 MB; en çok 2026-10-07: 37 adet, 426 MB) ve çalışma DLL'leri (292 MB: openblas, duckdb, wasmtime, onnxruntime). Kitap ve kayıtlar bu exe'lere ada göre atıf yapıyor (ör. `uxb_kilavuz_20261007.exe` 310 kez). | **DOKUNMA** (Codex çalışıyor, bir `uxb` süreci açık). Sonra tek tek gözden geçirilir. |
| *(kök dosyaları)* | 830 | 314 | → 2026-10-14 | 4 yedek zip (801 MB), `uxb.exe`, eski raporlar. Bölüm 4. | **SOR** |
| `tools` | 352 | 5 349 | 2023-12-25 → 2026-10-14 | `FreeBASIC-1.10.1-win64` (294 MB, **derleyiciyi derleyen araç**), `wabt` (27 MB, WAT→WASM çevirici), `uxotcc_final_release` (29 MB), `kitap` (1,3 MB, benim kitap araçlarım), `library_tools`, `pdsx`, `audit`, `maintenance`. | **TUT**. `kitap`, `maintenance`, `library_tools` YAYINLA; FreeBASIC ve wabt **YAYINLAMA** (üçüncü taraf). |
| `release_assets` | 272 | 114 | → 2026-09-24 | 24 Eylül Windows x64 yayın paketleri. `.gitignore` ile dışarıda (yalnız README ve manifest izleniyor). | **TEMİZLE** (Kademe 3, SOR) |
| `runtime_ext` | 204 | 588 | 2025-02 → 2026-09-24 | Çalışma zamanı eklentilerinin kaynağı (551 dosya izleniyor). | **TUT + YAYINLA** |
| `game` | 175 | 336 | 2024-02 → 2026-09-06 | Oyun örnekleri. Başka ajanlarla ortak alan. | **DOKUNMA** (sormadan değiştirilmez) |
| `tests` | 147 | 3 592 | → 2026-10-14 | Test paketleri (908 izleniyor, 1 165 yeni dosya var). | **TUT + YAYINLA** |
| `tmp` | 137 | 3 609 | 2026-05-11 → 2026-10-14 | Geçici dosyalar. `tmp\codex_build_baseline` (117 MB) Codex'in karşılaştırma tabanı. | **DOKUNMA** |
| `tekdosyaklsoru` | 111 | 5 715 | 2026-10-06 → 10-07 | "Tek dosya, köprü, eğitim" denemesi: kod analiz dosyaları ve eğitim verisi (`train.jsonl` 24 MB + 9 MB). | **SOR** (yayınlanmasın; sonra arşivlenir) |
| `.gitnexus` | 100 | 3 | 2026-10-07 | Kod grafiği indeksi (`lbug` dosyası 99,9 MB). Yeniden üretilebilir. GitHub'ın tek dosya sınırı 100 MB'dır; **git'e girmemeli**. | `.gitignore`'a ekle; **TEMİZLE** adayı |
| `Snapshoots` | 87 | 39 | 2026-05-30 → 06-09 | Haziran başı anlık görüntüler. | **TEMİZLE** (Kademe 3, SOR) |
| `.git` | 67 | 55 | 2026-06-14 → 09-28 | Sürüm geçmişi. | **TUT** |
| `compiler` | 57 | 160 | → 2026-10-14 | Derleme betikleri (`build_uxb_main_64.ps1` vb.). | **TUT + YAYINLA** |
| `build` | 50 | 13 492 | 2026-10-13 → 10-14 | `uxb` çağrılarının çalışma klasörleri (389 adet, küçük). | **TUT** (küçük; önceki günlerinin silinmesi için Mete'nin 2026-09-20 izni var) |
| `docs` | 35 | 1 930 | 2026-05-17 → 10-14 | Belgeler. Bölüm 4. | **SOR** (alt klasörlere göre) |
| `native` | 23 | 40 | 2026-05-11 → 10-07 | Çalışma zamanı DLL'sinin C++ kaynağı. | **TUT + YAYINLA** |
| `test_results`, `test_results_asm` | 10 + 3 | 1 040 + 1 135 | 2026-05 → 10-14 | Eski test çıktıları (`.gitignore` ile dışarıda). | **TEMİZLE** (küçük) |
| `src` | 7,8 | 588 | → 2026-10-14 | **Derleyici kaynağı** (581 dosya izleniyor). | **TUT + YAYINLA** |
| `tool_py` | 7,3 | 283 | 2026-05-25 → 09-20 | Eski Python yardımcıları (içinde 5 MB'lık wabt arşivi var). | **SOR** |
| `.patch_backup` | 3,4 | 122 | → 2026-09-11 | Yama yedekleri (`.gitignore` ile dışarıda). | **TUT** |
| `manifests` | 3,0 | 30 | → 2026-09-24 | Kütüphane sistemi manifestleri. | **TUT + YAYINLA** |
| `xtestx` | 2,8 | 1 452 | 2026-05-25 → 07-25 | Eski test deneme klasörü. | **SOR** |
| `ai_koordinasyon` | 1,8 | 32 | 2026-09-07 → 10-14 | Koordinasyon defterleri. Özel (`.gitignore` ile dışarıda). | **TUT** |
| `uXBasic_PATCH1…5_*`, `uXBasic_OOP_*`, `UXB_TYPED_TASK_ROUTINES_REAL_20260728`, `uxotcc_dual_target`, `UXB_010_UXPYTHON_SYSTEM`, `uxb` (iç içe), `Yeni klasör` | ≈ 6 | ≈ 370 | 2026-06 → 08 | Uygulanmış eski yama paketleri ve iç içe kopyalar. | **ARŞİVLE** (silme; `claude_arsiv\eski_belgeler` kuralına benzer biçimde taşı) |
| `libsx` | 0,4 | 83 | → 2026-10-07 | **Kütüphane kaynakları**: 47 kütüphane (`uxsdl3`, `uxraylib`, `uxgsl`, `uxhttp`, `uxjson`, `uxsqlite`, …). Tamamı izleniyor. | **TUT + YAYINLA** |
| `include` | 0,0 | 93 | → 2026-09-24 | Başlık dosyaları (93 izleniyor). | **TUT + YAYINLA** |
| `.claude` | 0,2 | 15 | 2026-09-27 → 10-14 | Beceri ve ajan tanımları (`uxb-harita`, `motor-esitligi`, `sorun-kaydi`). | **TUT** |
| Diğer küçükler: `planyap`, `out`, `vscode-extension`, `uxr_runner_package`, `runtime`, `extras`, `spec`, `snippets`, `distribution`, `.github`, `examples`, `libs`, `ide`, `release`, `.vscode`, `patches`, `i18n`, `frontend`, `logs`, `products`; boş: `_retired`, `backend`, `backups`, `emirler`, `history`, `scripts` | < 1 | — | — | Küçük destek klasörleri. | **TUT**; boş olanlar sorun değil |

---

## 4. Kök dosyaları ve eski belgeler

### 4.1 `uxb` kökündeki büyük dosyalar

| Dosya | MB | Tarih | Not |
|---|---:|---|---|
| `uxb(13.10).zip` | 340 | 2026-10-13 | Kaynak yedek zip'i. **Özel belgelerin (`ai_koordinasyon`, `docs\tasarim`) GitHub'da kopyası yoktur; bu zip'ler tek yedek olabilir.** Zip içeriği klasörle karşılaştırılmadan silinmez (Downloads kuralları belgesi, bölüm 4). |
| `uxb(25.09).zip` | 254 | 2026-09-25 | Aynı. |
| `uxb(06.10_00).zip` | 112 | 2026-10-06 | Aynı. |
| `uxb(23.09).zip` | 95 | 2026-09-23 | Aynı. |
| `uxb.exe` | 11,8 | 2026-10-14 | Güncel derleyici. **DOKUNMA.** |
| `uxb_main_wrapper_64.exe` | 7,9 | 2026-06-15 | Eski sarmalayıcı. SOR. |

### 4.2 Eski ve yerini başkası almış olabilecek belgeler (hiçbiri silinmez; "SOR")

Mete'nin 2026-09-28 kuralı: Claude'un yazdığı eskimiş belge silinmez, `UXBc\claude_arsiv\eski_belgeler\<tarih>_<ad>` altına taşınır.

| Belge | Yol | Boyut / tarih | Neden aday |
|---|---|---|---|
| Profesyonel Kullanma Kılavuzu (iki sürüm) | `uXBasic_Profesyonel_Kullanma_Kilavuzu_20260722.md`, `..._Genislestirilmis_20260723.md` (uxb kökü) | 0,2 + 0,3 MB, 2026-07-22/23 | V2 kitabı bunların yerini alıyor olabilir (Mete onaylarsa taşınır). |
| Uyumsuzluk Raporu I ve II | `uXBasic Uyumsuzluk Raporu.pdf`, `... II.pdf` (uxb kökü) | 0,4 + 0,5 MB, 2026-09-06 | Eylül başı raporlar; içerikleri SORUN_TAKIP'a işlendi mi bilmiyorum. |
| `uxb dusunce.txt`, `dosya_listesi.txt` | uxb kökü | 1,0 + 0,9 MB, 2026-07-02 / 06-14 | Eski düşünce notu ve dosya listesi çıktısı. |
| `docs\uxbasic_pck_kitaplar` | `docs\` | 14,9 MB, 803 dosya, 2026-05-17 → 06-15 | İç içe belge arşivi (`UXBASIC_ANA_IMALAT_BILGI_PAKETI\UXBASIC_ANA_IMALAT_BILGI_PAKETI\04_KAYNAK_BELGE_ARSIVI\…`). Kopya içeriyor. |
| `docs\uxbasic kitap` | `docs\` | 5,3 MB, 52 dosya, 2026-05-30 → 07-28 | Eski kitap taslakları. |
| `docs\uxb_pck_book` | `docs\` | 3,3 MB, 182 dosya, 2026-06-11 → 09-15 | Eski kitap paketi. |
| `docs\uxbasic_5_cilt` | `docs\` | 0,5 MB, 190 dosya, 2026-07-25 | Beş ciltlik eski kitap parçaları. |
| `docs\adim_referans`, `adim41_cli_contract`, `adim42_source_driven`, `matrix`, `ast`, `docs\docs` | `docs\` | < 1 MB her biri, 2026-05-26 → 07-27 | Eski adım belgeleri; tarihçe için **KEEP-REFERENCE**. |
| `ai_koordinasyon` eski notları | `ai_koordinasyon\` | 2026-09-07 → 09-29, yaklaşık 20 küçük dosya | `CODEX_CLAUDE_PAYLASIM_*`, `S0xx_*`, `MEMORY_VIRTUAL_*`, `UXB_ENGINE_AUDIT_2026-09-12_TR.md`… Tarihçe; **KEEP-REFERENCE**. |

Güncel ve canlı olanlar: `docs\kitaplar` (5,9 MB, 2026-09-28 → 10-14) ve `docs\tasarim` (1,8 MB, 2026-09-20 → 10-14).

---

## 5. `UXBc` kökü (uxb'nin bir üstü)

Toplam 59,89 GB; `uxb` bunun 45,5 GB'ı.

| Klasör / dosya | MB | Ne | Karar |
|---|---:|---|---|
| `uxb(06.06_1_gelistirme bitti).zip` | 4 086 | 2026-06-06 kilometre taşı yedeği | **SENİN KARARIN.** Silmem. |
| `UXBc(birinci gelistirme bitti).rar` | 2 815 | 2026-06-01 kilometre taşı yedeği | **SENİN KARARIN.** Silmem. |
| `UXBc.zip`, `mete_prompt_bridge_mvp.zip` | 67 + 67 | 2026-07-26 yedekleri | SOR |
| `dist` | 2 503 | Temmuz yayın hazırlığı: `_stage` 1 837 MB, `_verify` 186 MB, 6 adet `uxbasic_win64_*.zip` (472 MB) | **TEMİZLE** (Kademe 3, SOR) |
| `UxbRAG` | 1 947 | Kaynak haritası ve RAG verisi | **TUT** |
| `inventory_downloads` | 847 | Downloads envanter çıktıları (2026-09-06/07; `analysis_stage1` 230 MB…) | **SOR** (Downloads silme kuralları belgesine bağlı kanıt) |
| `release_packages` | 816 | `UXBASIC_ABI10_QUICKJS_WASMTIME_PCK_20260727_160659` klasörü ve `….verify` klasörü (ikisi de 278,2 MB, 1 316 dosya) + zip'ler | **TEMİZLE** (Kademe 3, SOR). Boyut ve dosya sayısı aynı; içerik karşılaştırılmadı. |
| `claude_arsiv` | 684 | Benim konuşma arşivim | **TUT** (asla silinmez) |
| `yedekler` | 487 | 2026-10-07 yedekleri | **TUT** |
| `.venv` | 365 | Python sanal ortamı (harita ve RAG araçları) | **TUT** |
| `tools` | 302 | `FreeBASIC-1.10.1-win64` (294 MB) — **`uxb\tools` içindekiyle dosya sayısı (4 608) ve toplam bayt (308 730 895) birebir aynı** | **SOR**: kopya; içerik karşılaştırılıp biri kaldırılabilir (294 MB). |
| `yama_kum` | 279 | 3 zaman damgalı yama çalışma klasörü (2026-10-07; 83–101 MB) | **SOR** |
| `reports` | 200 | `uxb_map_system` (harita sistemi çıktısı, 2026-09-27 → 10-07) | **TUT** |
| `mete_prompt_bridge_mvp`, `indirici` | 177 + 0,1 | Bu oturumun ek çalışma dizinleri | **DOKUNMA** |
| `UXBCcc` ve `UXB_CONTROL_CENTER_V1_1`, `UXBCCC_*` | 119 + 7 | Temmuz "kontrol merkezi" projeleri | **SOR** |
| `github_publish\uXBasiC_Compiler` | 21 | Temmuz'daki ilk yayın hazırlığının kopyası | **SOR** (ARŞİVLE) |
| Diğer küçükler (`build`, `tests`, `emirler`, `editpad eklentisi`, `gitrepouploader-main`, …) | < 8 | — | TUT |

---

## 6. Temizlik önerisi (kademeli)

**İlke:** Mete'nin kuralları geçerlidir: `reports\` silmeleri için "ne, kaç MB, neden gereksiz" listesiyle önceden sorulur (2026-09-20); Downloads kuralları belgesi: onaydan sonra bile işlem günlüğü tutulur, önce geri alınabilir yöntem tercih edilir, zip silmeden önce içerik klasörle karşılaştırılır. Aynı sürücüde "karantinaya taşımak" yer açmaz; bu yüzden Kademe 1'de geri alma yolu, **silinen her dosyanın özgününün başka klasörde durması**dır (SHA-256 ile doğrulanır).

### Kademe 1 — kayıpsız: `reports` içindeki çalışma DLL kopyaları

| Alan | Değer |
|---|---|
| Ne silinir | `uxb\reports\**\*.dll` dosyalarından, içeriği (SHA-256) `bin`, `native`, `runtime_ext` ya da `dist` altındaki bir özgünle **birebir aynı** olanlar. |
| Ön eleme (ad + boyut) | 23 278 dosya, 34,73 GB. Özgünler `bin`, `native`, `runtime_ext`, `dist` altında aranır; **bu klasörlerin hiçbirine dokunulmaz** (`dist\runtime_ext\deps` dahil), yalnız `reports` içindeki kopyalar silinir. |
| SHA-256 doğrulaması (960 sn, salt okunur) | **23 277 dosya, 34,72 GB özgünüyle bayt bayt aynı** (silinebilir kopya). 1 dosya aynı ad ve boyutta ama **içeriği farklı** çıktı: `remediation_20261007\runtime_variants\auto\uxb_runtime.dll`. |
| Silinmeyenler | 312 dosya, yaklaşık 0,9 GB: 311 DLL'in (ad, boyut) çifti kalıcı klasörlerde yok (farklı derleme varyantları; örn. `remediation_20261007\runtime_variants\{std,libuv,tbb}\uxb_runtime.dll`, `consolidation_20261006_packaged_library_backup\uxraylib.dll`) ve 1 dosyanın içeriği özgününden farklı. **Hiçbirine dokunulmaz.** |
| Okunabilir kanıt | Hiç silinmez: json, log, csv, txt, `.uxb`, `.asm`, `.md` olduğu gibi kalır (≈ 2 GB). |
| Neden güvenli | `tests`, `tools` ve `compiler` altındaki `.ps1`/`.py` betiklerinde `compiler_consolidation` ya da `remediation_2026` adını taşıyan yalnız iki dosya var: biri yeni bir zaman damgalı klasör **yazar** (`run_consolidation_tests.ps1:12`), öteki o betiği çağırır (`run_all_model_tests.ps1`). Eski koşu klasörlerini girdi olarak okuyan betik bulunmadı. `ai_koordinasyon` ve `docs\tasarim` içinde bu klasörlere ad vererek atıf yapan yalnız iki eski belge var: biri `compiler_consolidation\20261007_104043_1494\` klasörüne, öteki `20261006_150927_6406\` içindeki `language.json` ve `matrices.json` dosyalarına. Json dosyaları silinmez. |
| Bedeli | Silinen DLL'ler yüzünden o koşu klasörlerindeki programlar **yerinde yeniden çalıştırılamaz**; gerekirse DLL'ler özgün klasörden geri kopyalanır, ya da test yeni derleyiciyle baştan koşulur. |
| Kazanç | 34,72 GB → C: boş yer 3,70 GB'tan yaklaşık **38,4 GB**'a çıkar. En büyük kalemler: `libopenblas.dll` 7,2 GB (175 kopya), `duckdb.dll` 6,0 GB, `wasmtime.dll` 3,5 GB, `uxb_runtime.dll` 3,2 GB (1 008 kopya), `libstdc++-6.dll` 3,0 GB, `onnxruntime.dll` 2,5 GB. Özet tablo (104 farklı içerik, kopya sayısı, özgün yol): `ai_koordinasyon\TEMIZLIK_ADAY_OZETI_DLL_KOPYALARI_20261014.tsv`. |

> **Önemli: bu temizlik geçicidir.** Kök neden `S-117`dir: her `bld --build-x64` çıktı klasörüne yaklaşık 6,5 MB, FFI/kütüphane kullanan programlara çok daha fazla DLL kopyalar ve kopyalamayı kapatan ya da setleri paylaşan bir seçenek yoktur (kitapta G-ARAC-7, Bölüm 2.5). Düzeltilmedikçe bir sonraki toplu koşu `reports\` klasörünü yeniden doldurur. Önerim: (a) toplu koşucular `--out-root` klasörünü koşu sonunda silsin (`run_all_model_tests.ps1` zaten yapıyor; `reports\` altına yazan koşular yapmıyor görünüyor, çünkü DLL'ler duruyor), (b) uzun vadede `S-117` önerisi 1: DLL'leri tek paylaşımlı klasörden yüklemek. Bu bulgu `S-117`ye güncelleme notu olarak yazıldı.

### Kademe 2 — yeniden üretilebilir test ikilileri ve eski reports.zip

| Ne | Boyut | Not |
|---|---:|---|
| `reports\**\*.obj` (1 308 dosya) | 668 MB | Ara derleme çıktıları. Tamamen yeniden üretilir. |
| `reports\**\*.exe` (1 216 dosya, 157 farklı) | 927 MB | Test programlarının çıktıları. Özgünleri başka yerde **yok**; yeniden üretmek test koşusu gerektirir. Kanıt `.json/.log` içinde kalır. |
| `reports\reports.zip` | 265 MB | 2026-10-06 tarihli; adı `reports` yedeği gibi görünüyor, **içeriğine bakılmadı**. Silinmeden önce içeriği klasörle karşılaştırılmalı. |

Kazanç yaklaşık 1,9 GB. Kademe 1 yeterliyse Kademe 2'ye gerek yoktur.

### Kademe 3 — eski yayın ve paketleme artıkları (yaklaşık 5,5 GB; her biri ayrı onay)

| Ne | MB | Gerekçe |
|---|---:|---|
| `UXBc\dist\_stage` + `_verify` + zip'ler | 2 503 | Temmuz yayın hazırlığı; yeniden yapılabilir. |
| `UXBc\release_packages` | 816 | Temmuz paketleri; klasör ile `.verify` kopyasının boyutu ve dosya sayısı aynı (içerik karşılaştırılacak). |
| `UXBc\inventory_downloads` | 847 | Eylül envanter çıktıları (silme kurallarının kanıtı olabilir; **önce sor**). |
| `UXBc\tools\FreeBASIC-1.10.1-win64` | 294 | `uxb\tools` içindeki kopyayla bayt sayısı aynı; içerik karşılaştırıldıktan sonra. |
| `uxb\release_assets` | 272 | 24 Eylül paketleri; GitHub Release'te de var mı kontrol et. |
| `uxb\Snapshoots` | 87 | Haziran anlık görüntüleri. |
| `uxb\.gitnexus` | 100 | Yeniden üretilen indeks. |
| `uxb\dist\uxb_runtimes.zip` | 95 | Haziran paketi. |
| `uxb` kökündeki 3 eski zip (`25.09`, `06.10_00`, `23.09`) | 461 | **Yalnız** `13.10` zip'inin içinde `ai_koordinasyon` ve `docs\tasarim` bulunduğu doğrulandıktan sonra. |

### Kademe 4 — **dokunmam** (senin kararın ya da gerekli)

`UXBc\uxb(06.06_1_gelistirme bitti).zip` (4,1 GB), `UXBc(birinci gelistirme bitti).rar` (2,8 GB), `claude_arsiv`, `yedekler`, `.venv`, `UxbRAG`, `game`, `tmp\codex_build_baseline`, `bin\*` (Codex çalışırken), `tools\FreeBASIC` ve `wabt` (derleme için gerekli).

### Silme yöntemi (onay gelirse)

1. Önce `ai_koordinasyon\TEMIZLIK_GUNLUGU_<tarih>.md` açılır; her adım için önce/sonra boş yer yazılır.
2. Kademe 1 tek betikle, **her dosya silinmeden hemen önce yeniden SHA-256 ile özgünüyle karşılaştırılarak** yapılır; uyuşmayan dosyaya dokunulmaz. Silinen dosyaların listesi (yol, boyut, hash, özgün yolu) günlüğe yazılır.
3. Çalışan süreç kontrolü: o sırada `reports\` altında bir test koşusu yazıyorsa o klasör atlanır (bugünün zaman damgalı klasörleri atlanır).
4. Silmeden sonra: `tests\run_all_model_tests.ps1` yerine hızlı bir kontrol (bir örnek derleme ve çalıştırma) ile derleyicinin sağlam olduğu doğrulanır.

---

## 7. GitHub planı

### 7.1 Mevcut durum (ölçüldü)

| Konu | Değer |
|---|---|
| Uzak depo | `https://github.com/metedinler/uXBasic.git` |
| Dal | `main`, uzağa göre **1 commit önde** (`07550bb` "Task model, sync pass, BYREF aliasing and routine scope fixes"; 2026-09-28'de Mete'nin "çalışma ağacını commit'le" isteğiyle atıldı, 411 dosya; **gönderilmemiş**) |
| Yazar kimliği | `07550bb` commit'inin yazarı **gerçek ad ve Gmail adresiyle** atılmış. Daha önce yayınlanan üç commit yer tutucu kimlikle (`Adınız <email@adresiniz.com>`) atılmış. Şu an `git config` yine yer tutucu. |
| İzlenen dosya | 2 538 (tests 908, src 581, runtime_ext 551, compiler 156, include 93, libsx 83, manifests 30, native 28, tools 22, …) |
| Değişmiş izlenen dosya | 137 (src 121, tests 9, native 4, compiler 1, libsx 1, runtime 1) |
| `.gitignore` dışında yeni dosya | **15 427** (tekdosyaklsoru 5 714, tools 3 926, docs 1 852, xtestx 1 448, tests 1 165, game 289, tool_py 271, kök dosyaları 258, …) |
| Yayın sınırı (önceki karar) | `.gitignore` şunları dışarıda tutar: `/ai_koordinasyon/`, `/docs/tasarim/`, `/spec/`, `/reports/`, `/dist/`, `/bin/`, `/build/`, `/tmp/`, `/release_assets/`, `*.exe`, `*.dll`, `*.zip`… `DESIGN-RIGHTS-RESERVED.md`: "tasarım belgeleri bilerek bu açık kaynak yayında yer almaz." |
| Gizli anahtar taraması | Değişen ve yeni metin dosyalarında (≤ 3 MB) 3 eşleşme; **hepsi** `window.uxLocalBridgeToken = "change-this-token"` yer tutucusu. Gerçek anahtar bulunmadı. (İzlenen 2 538 dosya zaten yayında; ikili dosyalar taranmadı.) |
| 25 MB üstü dosya | `.gitnexus\lbug` (99,9 MB; GitHub sınırı 100 MB) — **hariç tutulmalı**. |

### 7.2 Kütüphaneler ne anlama geliyor

| Parça | Yer | Durum |
|---|---|---|
| Kütüphane **kaynakları** (47 kütüphane) | `libsx\` (83 dosya) | Zaten izleniyor; yalnız `uxsdl3\uxsdl3.bas` değişmiş. |
| Başlıklar, eklentiler, manifestler | `include\`, `runtime_ext\`, `manifests\`, `native\` | Zaten izleniyor. |
| Kütüphane **ikilileri** (DLL) | `dist\libraries\bin` (24 MB), `deps` (128 MB üçüncü taraf: SDL3, raylib, GSL, onnx…) | `.gitignore` ile dışarıda. DLL'leri depoya koymak yerine **GitHub Release dosyası** olarak yüklemeyi öneririm (yüklü bir Windows sürümü zaten var: commit `fd42dee`). Üçüncü taraf lisanslarının uygunluğu ayrıca kontrol edilmeli. |

### 7.3 Neden `git add -A` yapılmaz

Yeni 15 427 dosyanın çoğu yayına uygun değil:

| Yeni dosya grubu | Sayı | Öneri |
|---|---:|---|
| `tools\FreeBASIC-1.10.1-win64` | 3 253 | **Yayınlama** (üçüncü taraf derleyici, kendi lisansı) |
| `tools\wabt`, `tools\uxotcc_final_release` | 77 + 274 | Yayınlama (üçüncü taraf / eski sürüm) |
| `tekdosyaklsoru` | 5 714 | Yayınlama (deneme; eğitim verisi) |
| `docs\uxbasic_pck_kitaplar`, `uxbasic_5_cilt`, `uxb_pck_book`, `uxbasic kitap` | 792 + 190 + 182 + 51 | Yayınlama (eski arşiv kopyaları) |
| `docs\kitaplar` | 326 | Karar gerekir (Dil Tanımı, Programlama Kuralları ve ölçümler) |
| `tools\kitap` | 225 | Karar gerekir (kitabı üreten araçlar; kitap özel olduğu için araçlar da özel kalabilir) |
| `tests\*` (yeni paketler) | 1 165 | **Yayınla** (diagnostics, task_model, adim36_full_surface, library_surface_gaps…) |
| `xtestx`, `tool_py`, `game`, kök dosyaları (258) | 1 448 + 271 + 289 + 258 | Tek tek bakılmalı |

Bu yüzden gönderme **açık yol listesiyle** (`git add -u` ile izlenenlerin değişiklikleri + seçilmiş yeni klasörler) yapılır.

### 7.4 Önerilen sıra (onay gelirse)

1. **Ön koşul:** Mete gerçek ad ve e-posta (ya da GitHub'ın `ID+kullanici@users.noreply.github.com` adresi) bildirir. `07550bb` zaten gerçek e-postayı taşıyor; göndermek onu herkese açık geçmişe yazar. Noreply istenirse bu tek commit göndermeden önce düzeltilir (henüz yayınlanmadığı için güvenli).
2. Yeni bir dalda çalışılır (örn. `bakim/20261014`); `main`'e doğrudan itilmez. GitHub'da gözden geçirdikten sonra birleştirilir.
3. `.gitnexus/` ve `tekdosyaklsoru/` `.gitignore`'a eklenir.
4. Commit'ler mantıksal gruplara bölünür: (a) `src`+`native` düzeltmeleri, (b) `tests`, (c) `libsx`/`runtime_ext`, (d) seçilen belgeler.
5. Göndermeden önce: yeni dosyalarda ikinci gizli anahtar taraması; en büyük 20 dosya listelenir; dal `git push` ile gönderilir (zorla itme yok).
6. İsteğe bağlı: DLL paketleri GitHub Release olarak yüklenir.

---

## 8. Mete'nin vermesi gereken kararlar

Bu kararlar gelene kadar hiçbir dosya silinmez, hiçbir şey GitHub'a gönderilmez.

| # | Soru | Önerim |
|---|---|---|
| 1 | **Kademe 1'i (DLL kopyaları, 34,72 GB, SHA-256 doğrulamalı) onaylıyor musun?** | Evet. Okunabilir hiçbir kanıt kaybolmaz. |
| 2 | Kademe 2'yi (`.obj`, `.exe`, `reports.zip`; ≈ 1,9 GB) şimdi mi, gerekirse mi? | Gerekirse. |
| 3 | Kademe 3'te hangi satırlar silinebilir? (her satır için evet/hayır) | `UXBc\release_packages` ve `UXBc\dist` için evet; `inventory_downloads` ve `release_assets` için önce sen bak. |
| 4 | `UXBc` kökündeki 4,1 GB zip ve 2,8 GB rar: kalsın mı, silinsin mi? | Kalsın (senin kilometre taşların). |
| 5 | Tasarım belgeleri (V2 kitabı, SORUN_TAKIP, `docs\tasarim`) GitHub'da **yayınlanacak mı**? | Hayır, mevcut karar (`DESIGN-RIGHTS-RESERVED.md`) korunsun. Yayınlamak istersen yalnız V2 kitabını ayrı bir karar olarak. |
| 6 | Git kimliği: gerçek ad ve e-posta mı, GitHub noreply adresi mi? | Noreply. |
| 7 | Gönderme yolu: yeni dal + GitHub'da gözden geçirme mi, doğrudan `main` mi? | Yeni dal. |
| 8 | Kütüphane ikilileri (DLL) GitHub Release dosyası olarak yüklensin mi? | Evet, ama önce üçüncü taraf lisans kontrolü. |

---

## 9. Hata düzeltme kuyruğunun büyüklüğü (kitap kataloğu)

Kitabın sınır kataloğu (`tools\kitap\kilavuz_v2\veri\sinirlar.txt`) **341 kayıt** içerir; 340'ı ayrı bir `SORUN_TAKIP.md` kaydıdır (S-205 … S-543), biri (G-ARAC-7, DLL kopyalama maliyeti) mevcut `S-117`ye bağlıdır. Ölçüm referansı: `uxb_kilavuz_20261014_0253.exe`.

| Tür | Adet | Ne demek | Önerilen sıra |
|---|---:|---|---|
| (gerileme) | 5 | Dün çalışan bir şey bugün bozuk: S-523, S-535, S-539, S-540 (AST), S-543 (MIR) | **1.** |
| `SESSİZ` | 155 | Derleyici hata vermez, ama yanlış ya da boş sonuç üretir; en tehlikeli tür | **2.** |
| `ÇÖKME` | 9 | Program ya da derleyici çöker | **3.** |
| `FARK` | 55 | İki motor aynı programa farklı sonuç verir | **4.** |
| `EKSİK` | 58 | Olması gereken davranış ya da özellik yok | 5. |
| `AÇIK` | 61 | Motor görünür bir hata iletisiyle reddeder ya da düşer (dürüst, ama 2026-10-14 kararıyla bu da eşlik açığıdır) | 5. |
| `YAVAŞ` | 3 | Çalışır ama kabul edilemez yavaştır | 6. |

Eski AST-x64 kusurları (S-524 … S-538, S-157-L, S-086, S-091) bu kuyruğun içindedir; Mete'nin 2026-10-14 kararıyla "dondurulmuş" değil, düzeltilecektir. Her düzeltme altı yolda (AST, MIR, MIR-x64, eski AST-x64, JS, WASM) değer düzeyinde doğrulanır ve kitap yeniden üretilir (ölç → düzelt → yeniden üret). Kitabın bu hâli **0253 derlemesinin fotoğrafıdır**; düzeltmeler geldikçe yeniden ölçülmelidir.

---

## 10. Ek: bu belgenin dayandığı ölçümler

- Boyut dökümü: `boyut_derin.py` (alt klasör boyutu, dosya sayısı, en eski/en yeni tarih), 2026-10-14 16:54–17:31.
- `reports` uzantı dağılımı: `reports_uzanti.py` — 178 920 dosya; `.dll` 36 476 MB (23 589 dosya, 119 farklı ad+boyut), `.json` 1 635 MB, `.exe` 927 MB, `.obj` 668 MB, `.zip` 266 MB, `.asm` 104 MB, `.csv` 89 MB.
- DLL kopya doğrulaması: `kopya_dll_dogrula.py` (SHA-256; özgünler `bin`, `native`, `runtime_ext`, `dist` altında aranır). Sonuç: 23 278 aday (ad+boyut eşleşmesi) → 23 277 bayt bayt aynı, 1 farklı; toplam süre 960 sn. Okunur özet: `ai_koordinasyon\TEMIZLIK_ADAY_OZETI_DLL_KOPYALARI_20261014.tsv`.
- Git durumu: `git_tara.py` (izlenen, değişen, izlenmeyen; gizli anahtar deseni taraması).
- Belgelerdeki atıflar: `ai_koordinasyon` ve `docs\tasarim` içinde `reports\…_runs` ve `compiler_consolidation\<zaman>` adına yalnız iki eski belge atıf yapıyor.
- Hiçbir ölçüm dosya değiştirmedi.

---

## 11. Uygulama sonucu (2026-10-15)

Yazım saati: 2026-10-15 14:50. Yukarıdaki bölümler 14 Ekim'deki öneriyi olduğu gibi korur; bu bölüm Mete'nin kararlarını ve yapılanı yazar. Temizliğin ayrıntısı `TEMIZLIK_GUNLUGU_20261015.md`'dedir.

### 11.1 Bölüm 8'deki sekiz sorunun cevabı

| # | Soru | Mete'nin cevabı (2026-10-15) | Ne yapıldı |
|---|---|---|---|
| 1 | Kademe 1 (DLL kopyaları) | "hepsi önerdiğin gibi" | **Yapıldı:** 21 663 dosya, 33,01 GB |
| 2 | Kademe 2 (`.obj`, `.exe`, `reports.zip`) | "gerekirse" önerisi kabul; zip silinmez | **Yapılmadı** (C: 38 GB boş; yer gerekirse `.obj`/`.exe` için aynı yöntem) |
| 3 | Kademe 3 satırları | "temizle" olanlar kalkar, "sor" olanlar kalır, zip silinmez | **Yapıldı:** `release_packages` içindeki iki çıkarılmış klasör, `dist\_stage`, `dist\_verify` (2,52 GB; zip'te boyut + CRC32 ile bulunanlar). `inventory_downloads` ve `release_assets` **kaldı** |
| 4 | Kökteki 4,1 GB zip ve 2,8 GB rar | kalsın | Dokunulmadı |
| 5 | Tasarım belgeleri GitHub'da yayınlansın mı | **Karar değişti:** "tasarım ve tüm dokümantasyon gitsin" | **Yayınlandı** (`docs/tasarim`, `ai_koordinasyon`, `spec`; yalnız okumak için, lisans vermez) |
| 6 | Git kimliği | noreply önerisi kabul | Tüm yayın commit'leri `metedinler <62749570+metedinler@users.noreply.github.com>` |
| 7 | Gönderme yolu | yeni dal önerisi kabul | `yayin/20261015` (main'e doğrudan itilmedi) |
| 8 | DLL paketleri GitHub Release olsun mu | "önce üçüncü taraf lisans kontrolü" önerisi kabul | **Yapılmadı:** lisans kontrolü bekliyor; hiçbir DLL gönderilmedi |

Ek istek: Claude, Codex ve ChatGPT konuşma ve hafıza dosyaları da gitsin (dosya başına 100 MB sınırı). **Yapıldı** (`konusma_arsivi/`).

### 11.2 Gönderilen dal

| Konu | Değer |
|---|---|
| Depo | `https://github.com/metedinler/uXBasic` (herkese açık) |
| Dal | `yayin/20261015` |
| Uç | `79391cd8c2cb262682cbc40affb2426f9aeacc2a` (bu bölümü içeren sonraki belge commit'i dışında) |
| Taban | `origin/main` = `fd42dee`; dal 10 commit önde, 0 geride |
| Birleştirme bağlantısı | `https://github.com/metedinler/uXBasic/pull/new/yayin/20261015` |
| Boyut | `main`'e göre 4 095 dosya (1 561 765 satır eklendi, 1 960 silindi); GitHub'a göre depo 65,8 MB; en büyük dosya 88,8 MB (sınır 100 MB; GitHub 50 MB üstü iki dosya için uyarı verdi) |
| Yasak uzantı | `.exe`, `.dll`, `.obj`, `.zip`, `.rar`, `.7z`, `.pdb`, `.lbug` vb.: 0 dosya |

| Harf | Commit | İçerik | Dosya |
|---|---|---|---:|
| A | `d3105ad` | `07550bb`'nin içeriği, noreply kimliğiyle yeniden damgalandı (özgün tarih 2026-09-28; yayınlanmamış gerçek e-postalı commit böylece yayına girmedi) | 412 |
| B | `a712953` | Kaynak ve yerel çalışma zamanı: çalışma ağacındaki değişiklikler (`src`, `native`, `runtime`, `compiler`, `libsx` …) | 128 |
| C | `01d3094` | Mevcut test paketlerindeki değişiklikler | 9 |
| D | `03e7226` | Yeni test paketleri | 1 164 |
| E | `2ed5400` | Araçlar: kitap üreticisi ve yoklamalar, bakım, kütüphane araçları (üçüncü taraf FreeBASIC, wabt, uxotcc hariç) | 301 |
| F | `54030db` | Yayın politikası: `.gitignore`, `DESIGN-RIGHTS-RESERVED.md` | 2 |
| G | `a1f69fa` | `docs` altındaki tüm belgeler (tasarım notları, kitaplar, ölçüm kanıtları) | 1 909 |
| H | `fa80100` | `ai_koordinasyon` (sorun takip, karar defteri, durum) ve `spec` | 42 |
| I | `96c0aab` | Kök dizindeki belge dosyaları (`docs/kok_notlari/`) ve beceri/ajan tanımları (`.claude`) | 91 |
| J | `79391cd` | `konusma_arsivi/`: Claude konuşmaları ve ham kayıtları (82), Codex hafıza notları (7), ChatGPT sayfası (1), `OKU_BENI.md` | 91 |

**Gönderilmeyenler:** `tekdosyaklsoru`, `xtestx`, `tool_py`, `game`, `.gitnexus` (indeks 99,9 MB), `tools\FreeBASIC-1.10.1-win64`, `tools\wabt`, `tools\uxotcc_final_release`, kök patch artıkları, Codex oturum günlükleri (≈ 651 MB, tüm projeleri kapsar), `auth.json`, `config.toml`, canlı oturum kayıtları ve her türlü DLL/zip/rar/exe.

### 11.3 Gizli anahtar olayı

- İlk gönderme **GitHub itibar koruması (GH013) tarafından reddedildi:** Claude konuşma kaydında (`konusma_arsivi/claude/konusmalar/ham/…jsonl`) bir Google hizmet anahtarı (`AQ.` ile başlayan yeni biçim) bulunuyordu. Benim tarayıcım bu biçimi tanımıyordu. Hiçbir şey yayınlanmadı.
- Çözüm: tarayıcı desenleri genişletildi (Google `AQ.`, ortam değişkeni atamaları `…_KEY=`/`…_TOKEN=`, URL'deki `?key=`, bağlantı dizesindeki parola, `Basic` ve Bearer yetkisi, hizmet belirteçleri); örtüşen eşleşmeler tekilleştirildi; sınama birimi (bulunması ve bulunmaması gereken örneklerle) 0 hata verdi; arşiv **özgünlerden baştan** üretildi (8 dosyada 58 gizli değer `[GIZLI-SILINDI:<tür>]` yapıldı, 102 kişisel e-posta yeri `[e-posta]` yapıldı); dalın eklenen ve değişen 4 094 dosyasının **4 079 metin dosyası** (ikili dosya yok sayıldı) ile `origin/main`'in tüm metin dosyaları yeniden tarandı: dalda 0 gizli değer; `origin/main`'de tek eşleşme yanlış alarmdır (`tests/run_class_ctor_dtor_exec_ast.bas` içindeki "Basic CONSTRUCTOR/DESTRUCTOR parsing" yorumu). Sonra gönderme başarılı oldu.
- **E-posta adresleri (2026-10-15 14:50 taraması):** yazarın kişisel Gmail adresi dalda 30 belgede geçiyor ve **iletişim bilgisi olarak zaten yayındaydı** (`src/cli/cli_help.fbs`, `compiler/wrappers/uxb_main_wrapper.c`, `Programcinin Cep Kitabi.md`); yeni yerler `docs/uxbasic kitap` ve `docs/uxbasic_pck_kitaplar` altındaki eski kitap kopyalarıdır. Konuşma arşivlerinde bu adres maskelenmiştir. Üçüncü kişi adresi tek yerde var: konuşma kaydına yapıştırılmış `tree-sitter-freebasic` (MIT lisanslı) paketinin kendi başlık yorumundaki yazar satırı.
- Değerler: Gemini ortam değişkeni, Groq (`gsk_…`), `sk-…`, `sk-ant-…` ve Bearer belirteçleri. **Yerel orijinal konuşma kayıtları değişmedi**; gerçek görünümlü anahtarlar orada duruyor. Anahtarlar yayınlanmadı, ama konuşmalarda göründükleri için **yenilenmeleri önerilir**.
- Ders: yayın öncesi tarama, bilinen anahtar biçimlerinin kapsadığı kadarını yakalar; GitHub'ın itibar koruması ikinci güvenlik ağıdır. Bu depo herkese açık olduğundan yayınlanan şey geri alınamaz sayılmalıdır (önbelleğe ve dizine girebilir).

### 11.4 Yerel depo durumu ve sonraki adım

- Codex'in `HEAD`'i (`main` = `07550bb`), gerçek indeksi ve 137 değişikliği olan çalışma ağacı **değiştirilmedi**; dal, geçici bir indeks ve doğrudan nesne yazımıyla kuruldu (`git add -A` çalıştırılmadı). Yerel `.gitignore` de değişmedi; yeni dışlama kuralları dal `main`'e birleştirilince gelir.
- Yerel `main`, gerçek e-posta taşıyan `07550bb`'yi içerir. **Olduğu gibi `git push` edilmemelidir.** Yayın yolu `yayin/20261015` dalıdır.
- Mete'nin yapacağı: GitHub'da dalı gözden geçirip `main`'e birleştirmek (bağlantı yukarıda). Birleştirmeden sonra yerel çalışma ağacına almak için önce Codex'in yerel değişikliklerinin commit'lenmesi gerekir (aynı dosyalar iki yerde değişmiş olur); bu, Codex ile birlikte verilecek ayrı bir karardır.
- Gönderilen içeriği değiştirmek için yeni commit eklenir (dalın geçmişi yeniden yazılmaz). Bu belgenin ve kitabın bu bölümle ilgili güncellemeleri aynı dala küçük bir belge commit'iyle eklenir.
