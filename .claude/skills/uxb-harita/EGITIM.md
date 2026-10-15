# Haritayı kullanan ajan için eğitim (az token ile doğru yere varmak)

Bu belge, uXBasic kaynak haritasını kullanan bir yapay zekâ ajanının (Claude, ikinci Claude, Codex ya da başka bir
model) izlemesi gereken çalışma biçimini öğretir. Örnekler bu projede gerçekten yaşanmış işlerden alınmıştır.

## Altın kurallar
1. **Önce yön, sonra sembol, en son kaynak.** Sıra: `MIMARI.md` (hangi aşama/motor) → `rutinler.tsv` (hangi dosya:satır)
   → kaynağın YALNIZ o aralığı (`Read` + offset/limit, 40-120 satır). Büyük dosyayı baştan okuma
   (memory_exec.fbs ~5000, code_generator.fbs ~8000 satır).
2. **Amaç sütununa güven düzeyiyle bak:** `yorum` kaynaktaki yorumdur; `llm`/`gemini` model taslağıdır — karar vermeden
   kaynağı oku. Bir dosyada çalışmaya başlarken `ajan_paketi\sss_dizini.tsv`'den o dosyanın soru-cevap sayfasına bak
   (Gemini'nin o dosya için ürettiği "X nerede / nasıl" soruları); cevaptaki rutin adını rutinler.tsv'de doğrula. İmza, dosya, satır kesindir (harita güncelse; `kapsam.md` "değişen dosya: 0" olmalı).
3. **Satır kayar:** haritadaki satır bir öneridir; düzenlemeden önce Grep ile adı doğrula.
4. **Çağıranları harita bilmez:** "kim çağırıyor" için Grep `-w <Ad>` (src altında), `.bak*` dosyalarını sonuçtan ayıkla.
5. **Bir davranış dört motorda ayrı yerde yaşar** (MIMARI.md §2-§3). Bir motordaki düzeltme diğerlerinde de gerekebilir;
   doğrulama `uxb-3motor` ile.

## Soru → yol örnekleri
| Soru | Yol |
|---|---|
| "BYREF parametre nasıl bağlanıyor?" | MIMARI §2 → AST: `ExecInvokeRoutineByIndexOffset`, MIR: `UXBMIRInterpBindAlias`, native: BYREF yuvası `mir_x64_emit_helpers.fbs` → rutinler.tsv'de adları ara |
| "`a.b(i) = x` neden etkisiz?" | parser → `parser_stmt_registry.fbs` (`ParseExpressionStatement`): deyim başındaki atamanın ayrıştırılması |
| "Görevler arası otomatik kilit nerede eklenir?" | MIR geçişi `mir_sync_pass.fbs` (`MIRSyncPassModule`); küme `semantic_task_isolation.fbs` |
| "Native'de DLL çağrısı çöküyor" | `mir_x64_*` FFI üretimi + `native/uxb_runtime` (C++; haritada YOK → Grep) |
| "Legacy motor NASM hatası veriyor" | `code_generator.fbs` (`GenerateX64Code`, `X64CodegenAssembleOutput`) |
| "Yeni kütüphane fonksiyonu nerede?" | `libsx/<kütüphane>/*.bas` + `runtime_ext/<kütüphane>/*_adapter.c` + üretici `tools/library_tools/gen_*.py` |

## Sık yapılan hatalar (bu projede yaşandı)
- MIR adla çalışır: yerel ile global aynı adı taşır; gölgeleme motorun işidir (S-168).
- Yorumlayıcı "kopyala/geri yaz" ile native "adres" farklı sonuç verebilir (S-167) — motor eşitliğini hep dene.
- Test beklentisi elle yazılmış olabilir ve yanlış olabilir (raylib `1.875`): beklentiyi kaynak formülle doğrula.
- Kütüphane DLL'i kaynaktan eski olabilir (`GetProcAddress failed`): önce DLL tarihini kaynakla karşılaştır.
- Parametre adı ayrılmış sözcük olamaz (`SLOT`, `START`, `END`...).

## Yenileme ve doldurma
- Kaynak değişince: `uxb-harita` SKILL.md §4 (harita + paket yenileme, ~6 dk).
- Amaç sütunu, dosya özetleri ve soru-cevaplar dış bir yapay zekâ ile doldurulur (Gemini/ChatGPT/Claude/Kimi):
  `scripts\42_harita_doldur.bat` (V4 kökünde; ~220 istek amaç + ~420 istek özet/SSS; Gemini ücretsiz katmanında
  günlük 240 istekle ~3 gün; kaldığı yerden devam eder; anahtarlar `%USERPROFILE%\.uxb\api_anahtarlari.env`).
- Yerel (dışarı veri göndermeyen) alternatif: `python tools\uxb_purpose_fill.py --max-minutes 240`.
