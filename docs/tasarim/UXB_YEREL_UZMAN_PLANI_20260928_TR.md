# uXBasic yerel uzmanı ("kardeş") — plan (2026-09-28)

**Amaç:** Bulutta çalışan ajanların (Claude, Codex, Gemini, Kimi, OpenClaw) yanında, **Mete'nin bilgisayarında, çevrimdışı**
çalışan bir uXBasic uzmanı: uXBasic kaynak kodunu ve dil komutlarını bilen, test ve program yazmaya yardım eden, ileride
VS Code eklentisi olacak yerel akıllı asistan. İlke: uXBasic insanlar kadar **yapay zekâ için de** tasarlanan bir dil —
yerel uzman bu dilin ilk "yerli konuşanı".

**Donanım gerçeği:** i7-10610U, 16 GB RAM, ayrı ekran kartı yok → model işlemcide. Mete'nin seçimi: **qwen2.5-coder:3b**
(kurulu, 1.9 GB, hızlı). Gömme (embedding): **nomic-embed-text** (kurulu). Disk: 2026-09-28 temizlikten sonra ~4.3 GB boş.

## Aşama 1 — Bilgi tabanı (bulut ajanlarının ürettiğinden)
| Kaynak | Ne öğretir | Durum |
|---|---|---|
| Harita paketi (`UxbRAG\...\ajan_paketi`: rutinler.tsv, modül özetleri, SSS) | derleyici kaynağı: hangi rutin ne yapar, nerede | doluyor (Gemini/Kimi zinciri, ~4-5 gün) |
| `uxb\.claude\skills\uxb-harita\MIMARI.md`, `EGITIM.md` | derleme hattı, dört motor, dokunulacak dosyalar | hazır |
| **Dil kartı** (yeni): anahtar sözcükler (`src/parser/lexer/lexer_keyword_table.fbs`), yüzey kayıtları (`src/surface`), tipler, deyim örnekleri | uXBasic komutları ve doğru yazımı | yapılacak (≤10 bin token, her modele sığar) |
| `uxb\tests\**` (program + `expected/*.txt`) | DOĞRULANMIŞ örnek programlar ve çıktıları | hazır (~1100 kontrol) |
| `SORUN_TAKIP.md` | bilinen hatalar, motor farkları, "şunu yapma" | hazır |
| Yama Motoru kılavuzu | kod değişikliğini hangi biçimde önereceği | hazır |

## Aşama 2 — Arama (RAG)
V4 hattı yeniden kullanılır: soru sadeleştirme → planlayıcı → metin arama (ripgrep) + vektör arama (Chroma, nomic-embed) →
birleştirme → yerel model (Ollama qwen2.5-coder:3b). Parçalama: kaynakta **rutin başına** (harita satır aralıkları),
testlerde **program başına**, belgelerde **başlık başına**. 3B model küçük bağlamla iyi çalışır: en fazla 4-6 parça + dil kartı.

## Aşama 3 — Derleyici hakem (kalite döngüsü)
Yerel uzmanın yazdığı her uXBasic programı `uxb` ile AST, MIR ve native x64'te çalıştırılır
(`uxb\tools\claude\uxb_run3.ps1`); hata varsa tanı iletisi modele geri verilir, en fazla 3 tur düzeltme. Böylece:
- kullanıcıya yalnız **derlenen ve çalışan** kod önerilir;
- doğrulanan her soru/program çifti **eğitim verisi** olarak saklanır (Aşama 5).

## Aşama 4 — VS Code eklentisi
Ollama'nın yerel API'si + `uxb` komut satırı. İlk sürüm: "seçili kodu açıkla", "bu hatayı düzelt" (tanı → düzeltme),
"bu rutin için test yaz", "uXBasic ile şunu yaz". Hata tanıları için `uxb`'nin JSON çıktı seçenekleri kullanılır.

## Aşama 5 — Gerçek eğitim (ince ayar, sonra)
Aşama 3'ün doğrulanmış örnekleri + bulut modellerin ürettiği ve derleyicinin onayladığı binlerce soru/program → LoRA ince
ayar. Bu makinede yapılamaz (ekran kartı yok): kiralık bulut GPU / Colab. Çıkan model GGUF olarak Ollama'ya
`uxbasic-uzman` adıyla yüklenir. RAG sürer; ince ayar dili "doğal" yazmayı, RAG güncel kaynağı sağlar.

## "Yapay zekâ için dil" ilkeleri (dil tasarımına geri besleme)
1. Her kavram için tek kanonik yazım (eş anlamlı sözdizimi az).
2. Makinece okunur tanılar: hata kodu + satır/sütun + önerilen düzeltme (JSON).
3. Her motor aynı gözlenebilir sonucu verir (motor eşitliği — mevcut test disiplini).
4. Dil kartı ve örnek korpusu her sürümde otomatik yeniden üretilir.

## Sıra
1. Dil kartı + test korpusu dizini (haritayı beklemeden).
2. Derleyici hakem döngüsü (`uxb_run3.ps1` üstüne).
3. Harita dolunca RAG indeksini kur (Chroma) → yerel uzmanı dene.
4. VS Code eklentisi iskeleti.
5. Doğrulanmış veri birikince ince ayar kararı (Mete).
