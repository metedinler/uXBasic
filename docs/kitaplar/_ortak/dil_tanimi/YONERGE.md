# uXBasic Dil Tanımı — ekip yönergesi

Bu belge, **uXBasic Dil Tanımı**'nı (tek, kanonik belge: `docs/kitaplar/UXBASIC_DIL_TANIMI.md`) yazan herkes
için bağlayıcıdır: Claude ajanları, Codex, Kimi, Gemini. Mete'nin isteği (2026-09-28):

> Dilin tüm sözdizimi ve anlam özelliklerini belirleyen; her komutun, fonksiyonun, operatörün, veri tipinin,
> veri yapısının ve kütüphanenin tasarımına göre çalıştığı, bir önceki sürümle uyumlu yapıyı ortaya koyan,
> herkese yol gösteren tek geçerli belge. Uydurma yok, yer tutucu yok, çalışıyormuş gibi yapan hiçbir şey yok.

## 1. Kesin yasaklar

1. **Uydurma yok.** Bir sözdizimi ya da anlam iddiası ya kaynak koddan (`dosya:satır`), ya bir tasarım/karar
   belgesinden (yol + başlık), ya da gerçekten çalıştırılmış bir örnekten gelir. Kanıtı olmayan iddia yazılmaz;
   bilinmiyorsa "BİLİNMİYOR — şu dosyaya bakılmalı" yazılır.
2. **"Çalışıyor" demek için çalıştırmak şart.** Motor durumu yalnız `tools/kitap/ornek_dogrula.py` (ya da mevcut
   test koşucuları) çıktısından yazılır. Denenmemişse `DENENMEDİ`.
3. **Kaynak koda, testlere, `bin/`, `libsx/`, `game/`, `ai_koordinasyon/` dosyalarına dokunulmaz** (yalnız okuma).
   Yazma yalnız kendi alan klasörüne: `docs/kitaplar/_ortak/dil_tanimi/alanlar/<alan>/`.
4. Silme yok, git yok, süreç öldürme yok. Derleyiciyi proje kökünde çalıştırma (build\<tarih> klasörü açar):
   örnekleri **her zaman** `ornek_dogrula.py` ile koştur (geçici klasörde çalışır, 60 sn ve 2 MB sınırı var).
5. Sonsuz döngü yazan örnek yazma. Dosya yazan örnekler yalnız göreli adla (geçici çalışma klasörüne) yazar.
6. API anahtarı dosyasını (`%USERPROFILE%\.uxb\api_anahtarlari.env`) okuma.

## 2. Mete'nin kesin tasarım kuralları (bilinenler)

- Tip adları: `I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 F128 BOOLEAN STRING …` (lexer tablosuna bak).
  **`LONG`, `INTEGER`, `DOUBLE`, `SINGLE`, `BYTE` gibi adlar ve `$ # % ! &` tip son ekleri uXBasic'te YOKTUR.**
  (`LEFT$`, `CHR$` → `LEFT`, `CHR`.) Yüzey tablolarında görünen bu adlar ölü daldır, dilin parçası değildir.
- Açık tip dönüşümü tip adıyla fonksiyon biçimidir: `I8(x)`, `U8(x)`, `I32(x)`, `F32(x)` … (üç motorda çalışıyor).
  Klasik BASIC dönüşümleri (`CINT CLNG CDBL CSNG FIX INT`) de vardır; hangisinin kanonik, hangisinin eş anlamlı
  olduğu bu çalışmada belirlenecek.
- Büyük/küçük harf ayrımı yok; tip adları ve değişken adları aynı ad alanında (`CLASS K` varken `DIM k` hata).
- `TRUE = -1`, `FALSE = 0`. `^` XOR'dur, üs alma `**`'dır (çalıştırılarak doğrulandı).
- Motor mimarisi: lexer → parser (AST) → semantik/tip bağlama → **MIR** → {MIR yorumlayıcı, native x64 (MIR→NASM),
  JS, WASM/WAT}. AST yorumlayıcı ayrıca doğrudan AST'yi çalıştırır. Legacy AST-x64 eski yoldur. Bütün hedefler
  MIR'e bağlıdır; **aynı program her motorda aynı gözlenebilir davranışı vermek zorundadır** (motor eşitliği).
- Bellek mimarisi (S-036): NATIVE gerçek bellek birincil; VIRTUAL isteğe bağlı yapılandırılabilir bölge.
- Görev modeli (S-030/S-146 Model D): THREAD/TASK gerçek iş parçacığı; otomatik deyim kilidi, LOCK/ATOMIC/MUTEX.

## 3. Kanonik tasarımın belirlenme sırası

Bir öğenin "tek geçerli tasarımı" şu öncelikle belirlenir; üst sıradaki alttakini ezer:

1. **Mete'nin açık kararları:** `ai_koordinasyon/KARAR_VE_GOREV_DEFTERI.md`, `ai_koordinasyon/SORULAR_CEVAPLAR.md`,
   `ai_koordinasyon/SORUN_TAKIP.md` içindeki "Karar (Mete …)" satırları,
   `C:\Users\mete\.claude\projects\C--Users-mete-Downloads-BasicOyunSource-UXBc-Clean-UXBc-uxb\memory\uxb_fix_plan_decisions_2026_09.md`,
   `…\memory\uxb_memory_architecture_2026_09.md`, bu yönergenin 2. bölümü.
2. **Tasarım belgeleri:** `docs/tasarim/*.md` (özellikle `uXBasic_Hedeflenen_Sistem_ve_Kullanma_Kilavuzu_TR_2026-09-24 (1).md`,
   `uxbasic bellek tasarimi  ve coklu is modeli yeni gelistirmeler 24.09.26.md`, `UXB_KARAR_DENETIMI_…`,
   `UXB_KOD_TASARIM_UZLASTIRMA_DENETIMI_…`, `UXB_20260923_SISTEM_TASARIM_KARARLARI_…`), `ai_koordinasyon/DURUM.md`.
3. **Uyumluluk sözleşmesi (bir önceki sürüm):** `tests/` ve `xtestx/` altındaki, daha önce çalıştırılıp beklenen
   çıktısı kayıtlı programlar. Bir yazım bu programlarda kullanılıyor ve beklenen çıktısı varsa, o yazım dilin
   parçasıdır; şimdi çalışmıyorsa bu bir **gerilemedir** (belgeye "uyum hatası" olarak girer, dil ondan vazgeçmez).
4. **Mevcut uygulama:** parser (fiili dilbilgisi), semantik/tip kuralları, motorlar.
5. **Eski kitaplar** (PCK, Resmî Teknik Kitap vb. — çoğu ChatGPT yazımı, hatalı olabilir): yalnız ipucu.

Kaynaklar çelişirse öğe şu üç durumdan biriyle yazılır:
- **KARARLI** — 1. ya da 2. sırada açık hüküm var (kaynağı yazılır).
- **ÖNERİ** — açık hüküm yok; bu sıraya göre önerilen kanon + kısa gerekçe (Mete onaylayınca KARARLI olur).
- **KARAR GEREKİYOR** — kaynaklar birbirini tutmuyor ve öneri için yeterli dayanak yok; seçenekler + sonuçları.

**Varyantlar:** bir komutun birden çok yazımı varsa (ör. `CINT` ve `I32`, `DO WHILE`/`WHILE…WEND`, `PRINT` ayırıcıları)
her biri şu sınıflardan birine konur: `KANONİK` · `EŞ ANLAMLI (desteklenir)` · `ESKİ (uyarı verilmeli)` ·
`KALDIRILMALI (öneri)`. Amaç: kod tabanındaki gereksiz çokluğu görünür yapmak ve teke indirmek.

## 4. Araçlar

- Örnek doğrulayıcı (AST, MIR, native x64):
  `python tools/kitap/ornek_dogrula.py --kok docs/kitaplar/_ortak/dil_tanimi/alanlar/<alan>/ornekler --sonuc docs/kitaplar/_ortak/dil_tanimi/alanlar/<alan>/sonuc.json --is 1`
  Örnek dosya biçimi: başta `' KONU: …`, `' KOMUTLAR: …`, `' ACIKLAMA: …` ve beklenen çıktı satırları `'= …`.
  Beklenen çıktı, **tasarıma göre doğru** olan çıktıdır (motorun verdiği değil). Varsayılan derleyici
  `bin/uxb_openclaw_S087.exe`. Bir motor `HATA`/`FARKLI` verirse örneği "düzeltip geçirme" — kaydet.
  Tek bir hatalı satır bütün programı düşürür: her alt özelliği ayrı küçük örnekle dene.
- Yüzey envanterleri (kaynaktan otomatik): `docs/kitaplar/_ortak/dil_yuzeyi.json|md` (241 anahtar sözcük, 167
  yerleşik ad adayı, 660 iç ad; katman katman), `docs/kitaplar/_ortak/kutuphane_yuzeyi.json|md` (46 kütüphane,
  2422 fonksiyon/sub imzası).
- Daha önce doğrulanmış örnekler: `docs/kitaplar/_ortak/ornekler/**` ve sonuçları `docs/kitaplar/_ortak/ornek_sonuclari.json`
  (98 örnek, 77'si üç motorda geçiyor; kalanlar SORUN_TAKIP S-171…S-190).
- Kaynak haritası (rutin amaçları, modül dizini): `.claude/skills/uxb-harita/SKILL.md`, `MIMARI.md`;
  `..\UxbRAG\UXB_HYBRID_RAG_V4_YORUMLU_JSON\ajan_paketi\rutinler.tsv` ve `modul_dizini.tsv`.
- Lexer anahtar sözcükleri: `src/parser/lexer/lexer_keyword_table.fbs` (`IsKeyword`, gruplu `Case` satırları).
- Test koşucuları: `tests/run_all_model_tests.ps1` ve `tests/<paket>/run_*.ps1`; beklenen çıktılar `tests/<paket>/expected/`.

## 5. Alan klasörü ve çıktılar

`docs/kitaplar/_ortak/dil_tanimi/alanlar/<alan>/`:
- `bolum.md` — belgenin bu bölümü, **son okurun okuyacağı biçimde** (aşağıdaki şablon).
- `ogeler.json` — bölümdeki her öğe için bir kayıt (şema aşağıda). Kapsam ve uygunluk ekleri bundan üretilir.
- `ornekler/*.uxb` ve `sonuc.json` — bu bölüm için çalıştırılan örnekler.
- `denetim.md` — bağımsız denetimin (Codex) bulguları ve her birine verilen karar (kabul/red + kanıt).

`ogeler.json` şeması (dizi):
```json
{"ad": "SELECT CASE", "tur": "deyim|anahtar|yerlesik|operator|tip|yapi|onislemci|kutuphane|cli",
 "kanonik": "tek satırlık kanonik sözdizimi",
 "varyantlar": [{"yazim": "…", "sinif": "KANONİK|EŞ ANLAMLI|ESKİ|KALDIRILMALI"}],
 "karar": "KARARLI|ÖNERİ|KARAR GEREKİYOR", "karar_kaynagi": "yol#başlık ya da gerekçe",
 "kod": ["src/…fbs:123"], "testler": ["tests/…uxb"],
 "durum": {"AST": "GECTI|FARKLI|HATA|DENENMEDI", "MIR": "…", "x64": "…"},
 "ornek": "alanlar/<alan>/ornekler/<ad>.uxb", "sorunlar": ["S-172"],
 "yeni_sorun": "SORUN_TAKIP'te olmayan yeni bulgu ise tek cümle, yoksa boş"}
```

## 6. Bölüm şablonu (`bolum.md`)

Türkçe, tam imla (ç ğ ı ö ş ü İ). Kod adları özgün biçimde. Okur: dili kullanacak programcı **ve** derleyiciyi
geliştirecek mühendis. Her öğe için:

````markdown
### ÖĞE ADI
**Kanonik sözdizimi**
```uxb
…dilbilgisi biçimi; isteğe bağlı kısımlar [köşeli], tekrar {süslü}…
```
**Anlam.** Ne yapar, hangi tipleri alır/verir, sınır durumları, hata durumları.
**Kurallar.** Kısıtlar (ör. THROW'dan sonra aynı blokta satır olamaz).
**Varyantlar.** tablo: yazım · sınıf · not.
**Karar.** KARARLI (kaynak) | ÖNERİ (gerekçe) | KARAR GEREKİYOR (seçenekler).
**Örnek.** çalıştırılmış örnek + beklenen çıktı.
**Motor durumu.** AST ✓/✗ · MIR ✓/✗ · x64 ✓/✗ — örnek dosyası; bozuksa S-xxx.
**Kaynak.** parser/semantik/motor `dosya:satır` listesi.
````
Aynı kalıptaki çok sayıda küçük öğe (ör. matematik fonksiyonları) tabloyla verilebilir; tablo satırı da aynı
bilgileri taşır (imza, anlam, karar, motor durumu, örnek).

Bölümün başında: kapsam, okunan kaynakların listesi. Sonunda: "Bu bölümde bulunan uyum hataları" tablosu ve
"Mete'nin kararını bekleyen konular" listesi.
