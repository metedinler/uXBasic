# uXBasic Programlayıcının Cep Kitabı — Cilt 6
## Yapay Zekaya uXBasic Öğretme, Eğitim Verisi Kurma, Model Seçimi ve Eksik Konuları Tamamlama

**Hazırlayan:** Zühtü Mete Dinler  
**Amaç:** uXBasic dilini bir yapay zekaya öğretmek için kitap, test, örnek çıktı, veri seti ve küçük model eğitim düzeni kurmak.  
**Durum:** Cilt 1–5 programcıya dili öğretmek için kullanılabilir. Cilt 6 ise dili makineye öğretmek için yazılmıştır.  
**Varsayım:** uXBasic derleyicisi, kütüphaneleri, CLI komutları, JS/WAT/WASM, çalışma zamanı servisleri, büyük sayı ailesi, test kapıları ve rapor üreticileri çalışıyor kabul edilir.

---

## 1. Kitap bitti mi?

Evet, insan için temel kitap **Cilt 1–5** ile ana gövde olarak bitmiş sayılır. Cilt 1 giriş, dosyalar, mimari, komut satırı ve ön-işleyiciyi anlatır. Cilt 2 komutları, tipleri, işleçleri, yerel fonksiyonları ve komut sınıflarını işler. Cilt 3 değişkenleri, veri yapılarını, nesne düzenini, kanca [derleyici akışına ek davranış bağlama noktası] (hook) ve sarmalayıcı [dış işi temiz çağrıya çeviren ara katman] (wrapper) düşüncesini öğretir. Cilt 4 kütüphane ve çalışma zamanı servislerini açar. Cilt 5 web, JavaScript, WAT/WASM, API, yapay zeka ve bilimsel analiz tarafını tamamlar.

Fakat kitap yalnız insan okuyucu için bitmiştir. uXBasic'i bir yapay zekaya öğretmek istiyorsak ayrıca şunlar gerekir: küçük ve düzenli bir öğretim veri seti, test programları, beklenen çıktılar, hata örnekleri, yanlış cevap düzeltmeleri, komut sınıflarına ayrılmış soru-cevaplar, derleyici raporları, CLI çıktı sözleşmeleri ve modelin cevabını ölçen denetleyici. İşte bu yüzden Cilt 6 gereklidir. Bu cilt, kitabın “makine öğretmeni” bölümüdür.

Genç programcı için bu bölümün asıl dersi şudur: Bir yapay zekaya dil öğretmek, ona yalnız kitap okutmak değildir. Ona kaynak kod, çıktı, hata, açıklama, dönüşüm ve test verilir. İnsan “IF koşul demektir” cümlesinden öğrenebilir; küçük model ise yüzlerce örnekte `IF`, `ELSEIF`, `ELSE`, `END IF`, beklenen çıktı ve hata durumunu birlikte görmelidir.

---

## 2. Kitapta olsa iyi olurdu dediğim ek konular

Aşağıdaki konular Cilt 1–5 içinde parçalar hâlinde geçti; fakat yapay zeka eğitimi hedeflenince ayrı bir defter gibi toplanmaları gerekir.

| No | Konu | Neden gerekli? | Kitaba nasıl eklenmeli? |
|---:|---|---|---|
| 1 | Eğitim veri seti düzeni | Modelin uXBasic'i öğrenmesi için örnekler standart biçimde tutulmalı. | `datasets/uxbasic_train.jsonl`, `datasets/uxbasic_eval.jsonl` şeması verilmeli. |
| 2 | Altın testler | Modelin ürettiği kodun doğru olup olmadığı ölçülmeli. | Her komut sınıfı için kaynak, beklenen stdout, beklenen hata, beklenen JSON raporu tutulmalı. |
| 3 | Hata kataloğu | Model yalnız doğru kod değil, yanlış kodu düzeltmeyi de öğrenmeli. | Sözdizimi, tip, dosya, runtime, backend, wasm, dll hata örnekleri yazılmalı. |
| 4 | Komut öğretim kartları | Her komut için kısa ders, doğru örnek, yanlış örnek, düzeltme gerekir. | `cards/IF.md`, `cards/OPEN.md`, `cards/CALL_DLL.md` gibi küçük kartlar kurulmalı. |
| 5 | Çıktı sözleşmesi defteri | CLI seçenekleri gerçek dosya üretmeli; model bunu bilmezse uydurma yol yazar. | `--tokens-json-out`, `--ast-json-out`, `--js-out`, `--wat-out` gibi komutlar eğitimde örneklenmeli. |
| 6 | RAG defteri | Modelin hafızasına tüm kitabı gömmek yerine gerektiğinde ilgili sayfa bulunmalı. | Kitap parçalanıp gömme [metni sayıya çevirme] (embedding) ile aranmalı. |
| 7 | İnce ayar [modeli örneklerle uyarlama] (fine-tuning) defteri | Modelin cevap üslubu ve kod kalıbı uXBasic'e göre şekillenmeli. | Küçük model, LoRA veya tam küçük eğitimle uXBasic cevabı vermeye alıştırılmalı. |
| 8 | Değerlendirme ölçütleri | “Güzel cevap verdi” yetmez; ölçmek gerekir. | Derleniyor mu, çıktı doğru mu, açıklama doğru mu, yasak uydurma var mı bakılmalı. |
| 9 | Veri üretici betikler | Elle binlerce örnek yazmak zor olur. | uXBasic testlerinden JSONL üreten Python araçları kurulmalı. |
| 10 | Yapay zeka güvenlik sınırı | Model DLL, dosya silme, API anahtarı gibi tehlikeli işler önerebilir. | Tehlikeli komutlarda güvenli uyarı ve örnek sınırı tanımlanmalı. |
| 11 | Öğretmen-öğrenci düzeni | Büyük model veri üretir, küçük model öğrenir. | ChatGPT gibi güçlü modelle açıklama ve test üretilir; küçük model yerelde çalışır. |
| 12 | Sürüm etiketi | uXBasic geliştiği için veri seti hangi sürüme ait bilmeli. | Her örnekte `uxb_version`, `src_snapshot`, `feature_family` alanları olmalı. |
| 13 | Dil üslubu | Kitap saf Türkçe, model de saf Türkçe cevap vermeli. | Eğitim verisine “Türkçe açıkla, İngilizce terimi açıklamalı yaz” kuralı eklenmeli. |
| 14 | Yasak uydurma listesi | Model olmayan komut veya kaldırılmış yazımı geri getirmemeli. | `IMPORT DLL`, `THREAT`, `PARALLEL`, `SIHIRLIMETOT` gibi yanlışları düzeltmeyi öğrenmeli. |
| 15 | Programcı çalışma yolu | Model kullanıcıya tek cevap değil, öğrenme yolu da vermeli. | “önce küçük örnek, sonra rapor, sonra test, sonra genişletme” yöntemi öğretilmeli. |

Bu konular, kitap gövdesini bozmaz; tam tersine uXBasic'i öğretilebilir bir dil yapar. Bir programlama dili yalnız komutlardan oluşmaz. Öğretim verisi, test disiplini ve hata düzeltme alışkanlığı yoksa yapay zeka o dili ezber gibi öğrenir, ama derleyici gibi düşünemez.

---

## 3. Yapay zekaya uXBasic öğretmenin üç yolu

uXBasic'i yapay zekaya öğretmek için üç ayrı yol vardır. Bunlar birbirinin düşmanı değildir; en iyi sistem üçü birlikte kullanır.

### 3.1. Bilgi getirme destekli cevaplama [ilgili belgeyi bulup cevaplama] (RAG)

Bu yöntemde modelin içine bütün uXBasic'i zorla sokmazsın. Kitabı, komut tablolarını, örnekleri, testleri ve hata raporlarını küçük parçalara bölersin. Kullanıcı soru sorunca önce ilgili parçalar bulunur, sonra model bu parçalarla cevap verir.

RAG avantajı şudur: Model küçük olsa bile güncel kitabı okuyormuş gibi cevap verebilir. uXBasic sürekli değiştiği için bu çok önemlidir. Bugün `PARALEL` doğru yazım, `PARALLEL` yanlışsa bunu belge tabanında hemen güncelleyebilirsin. Modeli baştan eğitmen gerekmez.

RAG zayıflığı şudur: Model sözdizimini tam içselleştirmemişse, bulduğu belgeye rağmen bazen yanlış kod yazabilir. Bu yüzden RAG yalnız başına yetmez; doğru kod üretimi için örnekli ince ayar da gerekir.

### 3.2. İnce ayar [örneklerle davranışı değiştirme] (fine-tuning)

Bu yöntemde modele örnek soru-cevaplar verirsin. “Kullanıcı IF komutunu sorduğunda böyle açıkla”, “kullanıcı kalite kontrol programı istediğinde böyle uXBasic kodu yaz”, “yanlış `THREAT` görürsen `THREAD` diye düzelt” gibi davranışlar öğretilir.

İnce ayarın avantajı, modelin üslubunu ve kalıbını düzeltmesidir. Model uXBasic cevaplarını daha düzenli verir. Kodu açıklarken önce amaç, sonra sözdizimi, sonra örnek, sonra hata kontrolü yazmayı öğrenir.

İnce ayarın zayıflığı, bütün bilgiyi kalıcı hafıza gibi güvenilir biçimde öğretmemesidir. Bu yüzden “kitaptaki tüm komutları unutmasın” diye yalnız fine-tuning yapmak doğru değildir. Fine-tuning davranışı öğretir; RAG güncel bilgiyi taşır.

### 3.3. Derle-çalıştır-denetle döngüsü

Bu üçüncü yol en değerlisidir. Model uXBasic kodu üretir. Sonra sistem bu kodu `uxb` ile derler, `stdout.txt`, `stderr.txt`, `ast.json`, `mir.json`, `program.js`, `program.wat` gibi çıktıları alır. Hata varsa modelden düzeltme istenir. Böylece model yalnız kitap bilgisiyle değil, gerçek derleyici cevabıyla da öğrenir.

Bu yöntem genç programcıya da aynıdır: yaz, çalıştır, hatayı oku, düzelt. Yapay zeka da bu döngüyle daha iyi olur.

---

## 4. İlk küçük model seçimi

Bu proje için iki basamaklı model seçimi uygundur.

| Aşama | Model | Neden? | Kullanım |
|---|---|---|---|
| Deney aşaması | `HuggingFaceTB/SmolLM2-135M-Instruct` | Çok küçük, yerel bilgisayarda deneme ve hızlı veri hattı kurma için uygun. | uXBasic soru-cevap, kısa kod açıklama, veri seti biçimini test etme. |
| Gerçek küçük asistan | `Qwen/Qwen3-0.6B` veya `Qwen/Qwen3-0.6B-Base` | Daha güçlü, çok dilli ve kod/akıl yürütme tarafı daha iyi. | uXBasic kod üretme, hata açıklama, belgeye dayalı cevap verme. |
| RAG gömme modeli | küçük embedding modeli veya OpenAI `text-embedding-3-small` | Kitap parçalarını aramak için gerekir. | `pck*.md`, testler, çıktı raporları içinde ilgili parçayı bulma. |

Benim önerim şudur: **ilk eğitim deneyi SmolLM2-135M-Instruct ile yapılsın**, çünkü hata yapmak ucuz olur. Veri seti biçimi, eğitim betiği, değerlendirme betiği, prompt şablonu ve çıktı denetimi oturunca **Qwen3-0.6B** üzerine geçilir. Böylece önce küçük oyuncakla direksiyon öğrenilir, sonra daha güçlü arabaya geçilir.

### Neden doğrudan büyük model değil?

Büyük model daha güzel cevap verir ama eğitim masrafı, bellek ihtiyacı ve hata ayıklaması büyür. Senin amacın önce uXBasic öğretim sistemini kurmak. Bunun için modelin çok akıllı olması gerekmez; veri setinin doğru biçimde çalıştığını göstermesi gerekir.

### Neden yalnız RAG değil?

RAG ile model doğru sayfayı bulur ama uXBasic sözdizimini her zaman temiz kurmayabilir. `IF`, `END IF`, `TRY`, `CATCH`, `FINALLY`, `CALL(DLL)`, `IMPORT(C,...)`, `%%HTML_BEGIN` gibi kalıplar modelin parmak alışkanlığına dönüşmelidir. Bu parmak alışkanlığı için küçük ince ayar gerekir.

---

## 5. uXBasic öğretim veri seti nasıl olmalı?

Modeli eğitmek için düz kitap metni tek başına yeterli değildir. Öğretim veri seti örneklerden oluşmalıdır. Her örnekte soru, doğru cevap, varsa uXBasic kodu, beklenen çıktı, hata açıklaması ve sınıf etiketi bulunmalıdır.

### 5.1. Ana JSONL şeması

Her satır bir eğitim örneğidir. JSONL [her satırı ayrı JSON olan veri dosyası] biçimi kullanılabilir.

```json
{
  "id": "flow_if_0001",
  "uxb_version": "src30_05_5",
  "family": "akis",
  "task": "explain_and_code",
  "prompt": "uXBasic'te IF komutunu üretim kalite kontrol örneğiyle anlat.",
  "answer": "IF koşula göre program yolunu ayırır...",
  "code": "MAIN\n    DIM ph AS F64\n    ph = 7.2\n    IF ph < 6.5 THEN PRINT \"asit\" ELSE PRINT \"normal\" END IF\nEND MAIN",
  "expected_stdout": "normal",
  "expected_files": [],
  "negative_cases": []
}
```

Bu şema sade görünür ama güçlüdür. Model yalnız cevabı değil, kodun ne üretmesi gerektiğini de görür. Sonra değerlendirme sisteminde modelin ürettiği kod derlenip `expected_stdout` ile karşılaştırılır.

### 5.2. Chat biçimi

Konuşmalı model eğitilecekse veri aşağıdaki gibi hazırlanabilir.

```json
{"messages":[
  {"role":"system","content":"Sen uXBasic öğreten Türkçe bir programlama öğretmenisin. İngilizce terimleri Türkçe açıklamayla ver."},
  {"role":"user","content":"LIST, DICT ve SET farkını uXBasic örneğiyle anlat."},
  {"role":"assistant","content":"LIST sıralı liste, DICT anahtar/değer tablosu, SET tekrarsız kümedir...\n```uxbasic\nMAIN\n    DIM notlar AS LIST\n    DIM karar AS DICT\n    DIM kullanilan AS SET\n    ...\nEND MAIN\n```"}
]}
```

Chat biçimi modelin konuşma davranışını öğretir. Ama kod doğruluğunu ölçmek için ayrıca `code`, `expected_stdout`, `expected_error` alanları olan denetim veri seti tutulmalıdır.

---

## 6. Eğitim veri seti aileleri

uXBasic geniş bir dil olduğu için veri setini ailelere ayırmak gerekir. Her aile küçük dersler, orta örnekler ve büyük projeler içermelidir.

| Aile | Öğretilecekler | Örnek sayısı hedefi |
|---|---|---:|
| `intro` | uXBasic nedir, dosyalar, çıktılar, çalışma sırası | 100 |
| `cli` | uzun seçenekler, 3 harfli fiiller, çıktı sözleşmesi | 250 |
| `preprocessor` | `%%DEFINE`, `%%INCLUDE`, `%%HTML_BEGIN`, hedef seçimi | 300 |
| `flow` | `IF`, `SELECT`, `FOR`, `DO`, `TRY`, `RETURN` | 500 |
| `io` | `OPEN`, `INPUT`, `PRINT`, `GET`, `PUT`, `SEEK`, `CLOSE` | 300 |
| `types` | `I32`, `F64`, `BIGI`, `BIGD`, `BALL`, `STRING`, `PTR` | 300 |
| `collections` | `ARRAY`, `LIST`, `DICT`, `SET`, çok boyutlu diziler | 500 |
| `oop` | `TYPE`, `CLASS`, `METHOD`, `PROPERTY`, `INTERFACE`, `MAGIC` | 400 |
| `interop` | `DECLARE`, `CALL(DLL)`, `CALL(API)`, `IMPORT(C/CPP/ASM)` | 400 |
| `runtime_libs` | uxmath, uxstats, uxmatrix, uxdataframe, uxllama vb. | 700 |
| `web` | JS, HTML, manifest, browser, canvas, local storage | 400 |
| `wasm` | WAT, WASM, host call, export/import | 250 |
| `errors` | yanlış kodu düzeltme, hata mesajı yorumlama | 600 |
| `compiler_dev` | AST, MIR, hook, wrapper, gate, output contract | 500 |
| `science` | pH, kalite kontrol, Z/t/F/ANOVA, regresyon | 400 |

Başlangıç için 1000 örnek yeterlidir. Ciddi bir asistan için 5000–10000 örnek daha iyi olur. Önemli olan sayının büyüklüğü değil, örneklerin temizliğidir. Aynı kötü örneği 100 kere vermek modeli bozar. Her örnek küçük ama doğru olmalıdır.

---

## 7. Örnek eğitim kartları

Aşağıdaki kartlar modelin ne öğrenmesi gerektiğini gösterir.

### Kart 1 — IF komutu

**Kullanıcı sorusu:** uXBasic'te IF ne işe yarar? Üretim kalite kontrol örneğiyle anlat.

**Beklenen cevap özeti:** IF koşula göre iki farklı yol seçer. Ölçüm sınırın dışındaysa uyarı, içindeyse kabul verir.

```uxbasic
MAIN
    DIM nem AS F64
    nem = 13.8
    IF nem < 12.0 THEN
        PRINT "urun fazla kuru"
    ELSEIF nem > 14.5 THEN
        PRINT "urun fazla nemli"
    ELSE
        PRINT "urun kabul"
    END IF
END MAIN
```

**Beklenen çıktı:**

```text
urun kabul
```

**Öğretilecek zekâ hilesi:** Bir kalite sınırı varsa sayıları kodun içine saçma. İleride `CONST ALT_NEM = 12.0` ve `CONST UST_NEM = 14.5` yap. Böylece üretim standardı değişince tek satır değişir.

### Kart 2 — DICT ile IF zincirini azaltma

**Kullanıcı sorusu:** Çok uzun IF zinciri yerine tablo nasıl kurarım?

```uxbasic
MAIN
    DIM mesaj AS DICT
    mesaj("OK") = "Islem basarili"
    mesaj("WARN") = "Kontrol gerekli"
    mesaj("FAIL") = "Islem durdu"

    DIM kod AS STRING
    kod = "WARN"

    IF kod IN mesaj THEN
        PRINT mesaj(kod)
    ELSE
        PRINT "bilinmeyen durum"
    END IF
END MAIN
```

**Beklenen çıktı:**

```text
Kontrol gerekli
```

**Öğretilecek zekâ hilesi:** Program büyüdükçe kararlar tabloya taşınır. IF karar vermek içindir; veri saklamak için DICT daha uygundur.

### Kart 3 — Parser çıktısı isteyen kullanıcı

**Kullanıcı sorusu:** Yazdığım `main.uxb` dosyasının parser çıktısını nasıl alırım?

```powershell
uxb pjo main.uxb --out out/parser.json
uxb pdj main.uxb --out out/parser_diagnostics.json
uxb ajo main.uxb --out out/ast.json
```

**Beklenen açıklama:** `pjo` çözümleyici JSON çıktısını, `pdj` çözümleyici hata/uyarı raporunu, `ajo` soyut söz ağacını verir. Bu üç çıktı birlikte okunursa sözdizimi hatasının nerede oluştuğu anlaşılır.

### Kart 4 — Yanlış yazımı düzeltme

**Kullanıcı kodu:**

```uxbasic
THREAT ArkaPlan
    PRINT "calis"
END THREAT
```

**Beklenen model cevabı:** Yeni uXBasic yazımında doğru anahtar `THREAD`tir. Eski metinlerde görülen `THREAT` yazımı düzeltilmelidir.

```uxbasic
THREAD ArkaPlan
    PRINT "calis"
END THREAD
```

### Kart 5 — Dış DLL çağrısı

**Kullanıcı sorusu:** Windows mesaj kutusu nasıl çağrılır?

```uxbasic
DECLARE FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" _
    (BYVAL hwnd AS PTR, BYVAL text AS STRING, BYVAL title AS STRING, BYVAL tip AS I32) AS I32 STDCALL

MAIN
    DIM sonuc AS I32
    sonuc = MessageBox(0, "uXBasic calisti", "Bilgi", 0)
    PRINT "donus="; sonuc
END MAIN
```

**Öğretilecek güvenlik notu:** DLL çağrısında parametre tipi yanlışsa program çökebilir. Model her DLL örneğinde `DECLARE`, çağrı düzeni, dönüş tipi ve hata kontrolü yazmalıdır.

---

## 8. Veri üretme hattı

uXBasic test programlarından eğitim verisi üretmek için bir klasör düzeni kurulmalıdır.

```text
uxb_ai_teacher/
  books/
    pck1.md
    pck2.md
    pck3.md
    pck4.md
    pck5.md
    pck6.md
  examples/
    flow/
    io/
    collections/
    oop/
    interop/
    web/
    wasm/
    errors/
  expected/
    stdout/
    stderr/
    json/
  datasets/
    uxbasic_train.jsonl
    uxbasic_eval.jsonl
    uxbasic_rag_chunks.jsonl
  scripts/
    build_dataset.py
    run_uxb_examples.py
    grade_model_answers.py
    make_rag_index.py
  models/
    smollm2_135m_lora/
    qwen3_0_6b_lora/
```

Bu düzenin amacı basittir: örnekler bir yerde, beklenen çıktılar bir yerde, eğitim verisi bir yerde, eğitim betikleri bir yerde durur. Dağınık klasör yapısı modeli de insanı da şaşırtır.

### 8.1. Örnekten JSONL üretme fikri

Her `.uxb` örneğinin başına küçük açıklama yazılabilir.

```uxbasic
' @id flow_if_quality_001
' @family flow
' @task explain_and_code
' @prompt 30 verilik kalite kontrolünde IF ve FOR kullan.
' @expected_stdout kalite raporu uretildi
MAIN
    PRINT "kalite raporu uretildi"
END MAIN
```

Python betiği bu açıklamaları okuyup JSONL satırı üretir. Böylece eğitim verisi kaynak koddan türetilir. Kaynak değişirse veri seti de yeniden üretilebilir.

### 8.2. Python veri üretici iskeleti

```python
from pathlib import Path
import json

ROOT = Path("uxb_ai_teacher")
EXAMPLES = ROOT / "examples"
DATASET = ROOT / "datasets" / "uxbasic_train.jsonl"


def parse_header(text: str) -> dict:
    meta = {}
    body = []
    for line in text.splitlines():
        if line.startswith("' @"):
            key, value = line[3:].split(" ", 1)
            meta[key.strip("@")] = value.strip()
        else:
            body.append(line)
    meta["code"] = "\n".join(body).strip()
    return meta


def make_answer(meta: dict) -> str:
    return (
        "Aşağıdaki uXBasic örneği " + meta.get("family", "genel") +
        " ailesini öğretir. Önce kodu oku, sonra beklenen çıktıyı karşılaştır.\n\n" +
        "```uxbasic\n" + meta["code"] + "\n```"
    )

rows = []
for path in EXAMPLES.rglob("*.uxb"):
    meta = parse_header(path.read_text(encoding="utf-8"))
    rows.append({
        "id": meta.get("id", path.stem),
        "family": meta.get("family", "general"),
        "task": meta.get("task", "explain_and_code"),
        "prompt": meta.get("prompt", "Bu uXBasic kodunu açıkla."),
        "answer": make_answer(meta),
        "code": meta["code"],
        "expected_stdout": meta.get("expected_stdout", ""),
        "uxb_version": "src30_05_5"
    })

DATASET.parent.mkdir(parents=True, exist_ok=True)
with DATASET.open("w", encoding="utf-8") as f:
    for row in rows:
        f.write(json.dumps(row, ensure_ascii=False) + "\n")

print("dataset rows:", len(rows))
```

Bu betik tam eğitim sistemi değildir; ama en önemli ilk taşı koyar. uXBasic örnekleri dağınık kalmaz, eğitim verisine çevrilir.

---

## 9. Model eğitimi için ilk yol: RAG + küçük model

Önce fine-tuning yapmadan basit bir öğretmen kurmak daha doğrudur. Bunun için kitap parçalanır, aranır, ilgili parçalar modele verilir.

### 9.1. Parçalama kuralı

Her başlık ayrı parça olabilir. Çok uzun tablo parçaları 1000–1500 kelimelik küçük bölümlere ayrılmalıdır. Her parçada şu alanlar olmalıdır:

```json
{
  "id": "pck2_flow_if",
  "source": "pck2.md",
  "title": "IF komutu",
  "family": "flow",
  "text": "IF koşula göre program yolunu ayırır...",
  "keywords": ["IF", "THEN", "ELSE", "END IF", "akış"]
}
```

### 9.2. RAG cevap şablonu

Model cevap verirken şu düzeni izlemelidir:

1. Kullanıcının isteğini bir cümleyle anla.
2. İlgili uXBasic komutlarını listele.
3. Sözdizimini ver.
4. En az bir çalışan örnek yaz.
5. Beklenen çıktıyı yaz.
6. Hata ve dikkat notunu ekle.
7. Gerekirse CLI ile nasıl test edileceğini ver.

Bu düzen modelin saçılmasını engeller.

---

## 10. Model eğitimi için ikinci yol: LoRA ile küçük ince ayar

LoRA [düşük rütbeli uyarlama; büyük modelin az sayıda ek parametreyle eğitilmesi] (LoRA), küçük donanımda en mantıklı yoldur. Tam modelin bütün ağırlıklarını değiştirmek yerine küçük uyarlama dosyası eğitilir. Bu dosya paylaşması, saklaması ve denemesi kolaydır.

### 10.1. İlk deney: SmolLM2-135M-Instruct

Bu model ilk deney için seçilir. Amaç dünyanın en iyi uXBasic asistanını yapmak değildir. Amaç veri seti, betik, eğitim döngüsü ve değerlendirme sistemini çalıştırmaktır.

Önerilen ilk ayar:

| Ayar | Değer |
|---|---|
| Model | `HuggingFaceTB/SmolLM2-135M-Instruct` |
| Eğitim yöntemi | LoRA / SFT [doğru cevap örnekleriyle öğretim] |
| Örnek sayısı | 1000 başlangıç, 5000 hedef |
| Epoch | 1–3 |
| Öğrenme oranı | küçük başla; örnek olarak `2e-4` denenebilir |
| Maksimum uzunluk | 1024 veya 2048 token |
| Değerlendirme | 100–300 sabit test örneği |
| Amaç | Türkçe uXBasic açıklama ve kısa doğru kod üretme |

### 10.2. İkinci aşama: Qwen3-0.6B

Veri hattı oturduktan sonra Qwen3-0.6B kullanılabilir. Bu model daha büyük olduğu için daha iyi açıklama ve kod üretme beklenir. Fakat eğitim daha ağırdır. Bu yüzden önce SmolLM2 ile prova yapılır.

Önerilen ikinci ayar:

| Ayar | Değer |
|---|---|
| Model | `Qwen/Qwen3-0.6B` veya base sürüm |
| Eğitim yöntemi | LoRA / QLoRA |
| Örnek sayısı | 5000–20000 |
| Veri türü | soru-cevap + kod + beklenen çıktı + hata düzeltme |
| Ek destek | RAG kesinlikle açık olmalı |
| Amaç | uXBasic öğretmeni ve kod düzeltici asistan |

---

## 11. Python ile eğitim iskeleti

Aşağıdaki iskelet öğretim amaçlıdır. Donanımına göre paket sürümleri değişebilir. İlk hedef, eğitim veri setini okuyup modelin cevap üslubunu uXBasic'e yaklaştırmaktır.

```python
from datasets import load_dataset
from transformers import AutoTokenizer, AutoModelForCausalLM, TrainingArguments, Trainer, DataCollatorForLanguageModeling
from peft import LoraConfig, get_peft_model

MODEL_NAME = "HuggingFaceTB/SmolLM2-135M-Instruct"
DATA_PATH = "uxb_ai_teacher/datasets/uxbasic_train.jsonl"


def format_row(row):
    prompt = row["prompt"]
    answer = row["answer"]
    text = (
        "<|user|>\n" + prompt + "\n" +
        "<|assistant|>\n" + answer
    )
    return {"text": text}


dataset = load_dataset("json", data_files=DATA_PATH, split="train")
dataset = dataset.map(format_row)

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token


def tokenize(row):
    return tokenizer(row["text"], truncation=True, max_length=1024, padding="max_length")


tok = dataset.map(tokenize, remove_columns=dataset.column_names)
model = AutoModelForCausalLM.from_pretrained(MODEL_NAME)

lora = LoraConfig(
    r=8,
    lora_alpha=16,
    lora_dropout=0.05,
    target_modules=["q_proj", "v_proj"],
    task_type="CAUSAL_LM"
)
model = get_peft_model(model, lora)

args = TrainingArguments(
    output_dir="models/smollm2_135m_uxbasic_lora",
    per_device_train_batch_size=1,
    gradient_accumulation_steps=8,
    num_train_epochs=1,
    learning_rate=2e-4,
    logging_steps=10,
    save_steps=200,
    fp16=False
)

trainer = Trainer(
    model=model,
    args=args,
    train_dataset=tok,
    data_collator=DataCollatorForLanguageModeling(tokenizer=tokenizer, mlm=False)
)
trainer.train()
model.save_pretrained("models/smollm2_135m_uxbasic_lora")
tokenizer.save_pretrained("models/smollm2_135m_uxbasic_lora")
```

Bu iskelet doğrudan mucize beklemek için değildir. Önce 50 örnekle çalıştırılır, sonra 500, sonra 1000 örneğe çıkılır. Her aşamada modelin cevabı kontrol edilir. Model yanlış uXBasic yazıyorsa veri setine daha çok “yanlış → doğru” örneği eklenir.

---

## 12. Değerlendirme: model gerçekten uXBasic öğrendi mi?

Modelin uXBasic öğrendiğini anlamak için yalnız güzel açıklama yeterli değildir. Aşağıdaki ölçütler gerekir.

| Ölçüt | Nasıl ölçülür? | Başarı işareti |
|---|---|---|
| Sözdizimi doğruluğu | Modelin yazdığı kod `uxb --parse-only` ile denenir. | Parser hatası yok. |
| Tip doğruluğu | `--semantic-diagnostics-json-out` alınır. | Tip/kapsam hatası yok. |
| Çıktı doğruluğu | Program çalıştırılır, stdout beklenenle karşılaştırılır. | Aynı çıktı veya kabul edilebilir yakın sonuç. |
| CLI bilgisi | Modelden çıktı komutu istenir. | Doğru kısa fiil ve doğru `*-out` seçeneği verir. |
| Yasak uydurma | Yanlış komutlar aranır. | `IMPORT DLL`, `THREAT`, `PARALLEL`, `SIHIRLIMETOT` üretmez. |
| Açıklama kalitesi | İnsan denetimi veya rubrik. | Sözdizimi, görev, örnek, hata notu birlikte var. |
| Güvenlik | Dosya silme, DLL, API anahtarı soruları test edilir. | Uyarı ve güvenli örnek verir. |

### 12.1. Otomatik notlandırma fikri

```python
import subprocess
from pathlib import Path

TESTS = Path("uxb_ai_teacher/eval/generated")


def run_uxb(path: Path):
    out = path.with_suffix(".stdout.txt")
    err = path.with_suffix(".stderr.txt")
    cmd = [
        "uxb", "run", str(path),
        "--stdout-out", str(out),
        "--stderr-out", str(err),
        "--semantic-diagnostics-json-out", str(path.with_suffix(".semantic.json"))
    ]
    p = subprocess.run(cmd, text=True, capture_output=True)
    return p.returncode, out.read_text(encoding="utf-8", errors="ignore") if out.exists() else ""

passed = 0
failed = 0
for src in TESTS.glob("*.uxb"):
    code, stdout = run_uxb(src)
    if code == 0:
        passed += 1
    else:
        failed += 1
        print("FAIL", src, code)

print("passed", passed, "failed", failed)
```

Bu değerlendirme betiği, modelin cevaplarından çıkarılan uXBasic kodlarını gerçekten derleyiciye verir. Büyük ders şudur: Yapay zekayı övmek kolaydır; kodunu çalıştırmak gerçektir.

---

## 13. uXBasic örnekleriyle öğretim takvimi

Eğitim bir kerelik iş değildir. Ders ders ilerlemelidir.

| Hafta | İçerik | Veri hedefi | Değerlendirme |
|---:|---|---:|---|
| 1 | `PRINT`, `DIM`, `INPUT`, `IF`, `FOR` | 200 örnek | 50 parse testi |
| 2 | Dosya, hata yakalama, metin fonksiyonları | 300 örnek | 100 run testi |
| 3 | LIST, DICT, SET, ARRAY, çok boyutlu diziler | 400 örnek | 100 çıktı testi |
| 4 | CLASS, TYPE, MODULE, NAMESPACE, ALIAS | 400 örnek | 100 semantic testi |
| 5 | DECLARE, CALL(DLL), IMPORT(C/CPP/ASM) | 300 örnek | güvenli dış çağrı testi |
| 6 | JS, HTML, WAT, WASM, manifest | 400 örnek | artifact testleri |
| 7 | uxstats, uxmatrix, uxdataframe, uxllama | 500 örnek | kütüphane smoke testleri |
| 8 | hata düzeltme ve derleyici geliştirici cevapları | 600 örnek | negatif testler |

Bu takvim sonunda model en azından uXBasic hakkında düzenli konuşan, küçük kod yazan ve hata açıklayan bir yardımcı olur. Daha sonra veri kalitesi artırılır.

---

## 14. Modelin öğrenmesi gereken cevap üslubu

uXBasic asistanı cevap verirken şu üslubu kullanmalıdır:

1. Önce kullanıcının istediği işi sade Türkçeyle açıklar.
2. Gerekirse İngilizce terimi Türkçe açıklamayla verir.
3. Sözdizimini gösterir.
4. Küçük örnek değil, anlamlı iş yapan örnek yazar.
5. Beklenen çıktıyı belirtir.
6. Hata veya güvenlik notu verir.
7. CLI ile nasıl test edileceğini gösterir.
8. Varsa daha temiz yöntem önerir.

### Örnek model cevabı kalıbı

```text
Bu iş için DICT kullanmak doğru olur, çünkü kararlar anahtar/değer tablosuna taşınır.
Sözdizimi: karar("ANAHTAR") = "değer"
Aşağıdaki örnek 30 üretim ölçümünü kalite sınıfına ayırır...
```

Modelin kaçınması gerekenler:

- Olmayan komut uydurma.
- Kaldırılmış yazımı yeni özellik gibi gösterme.
- Kod verip nasıl çalıştığını açıklamama.
- `TODO`, `placeholder`, `dummy` gibi sahte çıktı üretme.
- DLL/API örneğinde parametre ve güvenlik notu vermeme.
- Türkçe soruya gereksiz İngilizce cevap verme.

---

## 15. uXBasic modeline öğretilecek büyük örnek: kalite kontrol öğretmeni

Bu örnek eğitim verisine hem kod hem açıklama hem beklenen çıktı olarak konabilir.

```uxbasic
MAIN
    CONST ALT AS F64 = 9.5
    CONST UST AS F64 = 10.5
    DIM olcum(30) AS F64
    DIM i AS I32
    DIM kabul AS I32
    DIM dusuk AS I32
    DIM yuksek AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM karar AS DICT

    karar("DUSUK") = "hammadde eksik veya dozaj dusuk"
    karar("YUKSEK") = "dozaj fazla veya sensor sapmasi var"
    karar("KABUL") = "uretim sinir icinde"

    FOR i = 1 TO 30
        olcum(i) = 9.2 + RND() * 1.8
        toplam = toplam + olcum(i)
        IF olcum(i) < ALT THEN
            dusuk = dusuk + 1
        ELSEIF olcum(i) > UST THEN
            yuksek = yuksek + 1
        ELSE
            kabul = kabul + 1
        END IF
    NEXT i

    ort = toplam / 30
    PRINT "ortalama="; ort
    PRINT "kabul="; kabul
    PRINT "dusuk="; dusuk
    PRINT "yuksek="; yuksek

    IF dusuk > yuksek AND dusuk > 3 THEN
        PRINT karar("DUSUK")
    ELSEIF yuksek > dusuk AND yuksek > 3 THEN
        PRINT karar("YUKSEK")
    ELSE
        PRINT karar("KABUL")
    END IF
END MAIN
```

Bu örnek model için değerlidir çünkü birçok kavramı birlikte öğretir: `CONST` sınırları sabitler, `DIM` veri alanı açar, `FOR` ölçümleri dolaşır, `IF/ELSEIF/ELSE` sınıflandırır, `DICT` yorum tablosu kurar, `RND` sahte ölçüm üretir, `PRINT` rapor verir. İnsan da model de bu örnekten şunu öğrenir: İyi program sayıyı yalnız hesaplamaz, sonucu yorumlar.

---

## 16. uXBasic modeline öğretilecek büyük örnek: derleyici katman raporu

```uxbasic
MAIN
    DIM kaynak AS STRING
    kaynak = "examples/kalite.uxb"

    PRINT "Kaynak:"; kaynak
    PRINT "1. tokens.json uret"
    PRINT "2. ast.json uret"
    PRINT "3. semantic diagnostics uret"
    PRINT "4. mir_full.json uret"
    PRINT "5. js/wat hedeflerini denetle"

    CALL(API, "uxb.cli", "run", "tjs", kaynak, "--out", "out/tokens.json")
    CALL(API, "uxb.cli", "run", "ajo", kaynak, "--out", "out/ast.json")
    CALL(API, "uxb.cli", "run", "sdj", kaynak, "--out", "out/semantic.json")
    CALL(API, "uxb.cli", "run", "mfj", kaynak, "--out", "out/mir_full.json")
    CALL(API, "uxb.cli", "run", "jso", kaynak, "--out", "dist/program.js")

    PRINT "Rapor zinciri tamamlandi"
END MAIN
```

Bu örnek doğrudan gerçek CLI köprü mantığını öğretir. Model, uXBasic'in yalnız kod yazan bir dil olmadığını, aynı zamanda kendi derleme katmanlarını raporlayan bir sistem olduğunu görür. Yapay zekaya bu örnek verilirse kullanıcı “AST nasıl alırım?” dediğinde yalnız tanım yapmaz, doğru komut zincirini önerir.

---

## 17. uXBasic modeline öğretilecek hata düzeltme örnekleri

### Yanlış 1: blok kapatmayı unutmak

```uxbasic
IF yas > 18 THEN
    PRINT "tamam"
```

Doğru cevap:

```uxbasic
IF yas > 18 THEN
    PRINT "tamam"
END IF
```

Açıklama: `IF` çok satırlı açıldıysa `END IF` ile kapanmalıdır.

### Yanlış 2: uzun IF zinciriyle veri saklamak

```uxbasic
IF kod = "A" THEN PRINT "alfa"
IF kod = "B" THEN PRINT "beta"
IF kod = "C" THEN PRINT "gamma"
```

Daha temiz cevap:

```uxbasic
DIM adlar AS DICT
adlar("A") = "alfa"
adlar("B") = "beta"
adlar("C") = "gamma"
IF kod IN adlar THEN PRINT adlar(kod) ELSE PRINT "bilinmeyen" END IF
```

Açıklama: IF karar vermek içindir; sözlük veri tablosu tutmak içindir.

### Yanlış 3: dış DLL çağrısında imza belirtmemek

```uxbasic
CALL(DLL, "user32.dll", "MessageBoxA", "Merhaba")
```

Daha güvenli cevap:

```uxbasic
DECLARE FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" _
    (BYVAL hwnd AS PTR, BYVAL text AS STRING, BYVAL title AS STRING, BYVAL tip AS I32) AS I32 STDCALL
CALL MessageBox(0, "Merhaba", "uXBasic", 0)
```

Açıklama: Dış çağrıda parametre ve dönüş tipi belli olmalıdır.

---

## 18. OpenAI veya bulut modeli kullanılırsa

Bulut model kullanılırsa iki yol vardır:

1. RAG: Kitap ve testleri gömme [metni sayısal vektöre çevirme] (embedding) ile aratıp modele bağlam olarak ver.
2. SFT: Örnek soru-cevapları supervised fine-tuning [doğru cevap örnekleriyle ince ayar] biçiminde eğit.

Bulut modelin avantajı güçlü cevap vermesidir. Dezavantajı maliyet, veri gizliliği ve bağımlılıktır. uXBasic gibi gelişen bir dilde benim önerim önce yerel küçük model + RAG, sonra gerekirse bulut modelle veri üretme ve değerlendirme yapmaktır.

---

## 19. Son karar: hangi modelle başlayalım?

Bu projenin ilk yapay zekası için kararım şudur:

```text
İlk deney modeli: HuggingFaceTB/SmolLM2-135M-Instruct
İlk ciddi küçük model: Qwen/Qwen3-0.6B
Öğretim yöntemi: RAG + LoRA/SFT + derle-çalıştır-denetle döngüsü
Veri dili: Türkçe açıklama + uXBasic kod + beklenen çıktı
Başlangıç veri hedefi: 1000 temiz örnek
İlk değerlendirme: 100 sabit uXBasic test programı
```

SmolLM2-135M ile başlayınca sistem hızlı kurulur. Model kötü cevap verirse suç modele değil, veri setine bakılır. Veri seti temizlenince Qwen3-0.6B’ye geçilir. Qwen3-0.6B asıl uXBasic yardımcı modeli olabilir. En iyi sonuç ise şudur: küçük model uXBasic kodu üretir, RAG doğru kitap parçasını getirir, derleyici kodu test eder, hata varsa model düzeltir.

---

## 20. Cilt 6 sonunda yapılacak işler

1. `uxb_ai_teacher` klasörü oluştur.
2. Cilt 1–6 dosyalarını `books/` altına koy.
3. Her komut sınıfı için 20 küçük örnek yaz.
4. Her kütüphane için 10 kullanım örneği yaz.
5. Her CLI çıktı seçeneği için en az 1 örnek komut yaz.
6. Her örneğe beklenen stdout/stderr/json dosyası bağla.
7. `build_dataset.py` ile JSONL üret.
8. İlk 100 örnekle SmolLM2-135M üzerinde LoRA dene.
9. Modelin ürettiği kodları `uxb` ile derle ve puanla.
10. Yanlışları yeni eğitim örneğine çevir.
11. 1000 örneğe çık.
12. RAG dizini kur.
13. Qwen3-0.6B denemesine geç.
14. uXBasic asistanının cevap üslubunu sabitle.
15. Sonra VSCode eklentisine veya yerel yardımcı programa bağla.

Bu cilt, kitabın sonu değil; uXBasic'i öğreten ikinci bir sistemin başlangıcıdır. İnsan için yazılan kitap artık makineye öğretilecek dersliğe dönüştürülebilir.
