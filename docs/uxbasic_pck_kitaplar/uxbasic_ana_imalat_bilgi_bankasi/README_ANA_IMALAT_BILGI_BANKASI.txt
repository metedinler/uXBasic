# uXBasic Ana İmalat Bilgi Bankası

**Amaç:** Bu klasör, bugüne kadar oluşan uXBasic bilgilerini tek bir imalat belleği olarak toplar. Burada yeni kitap yazılmadı; PCK kitapları, operator/logic16 kararları, full-surface parity analizleri, kurtarma raporları ve kaynak zip manifestleri aynı pakette düzenlendi.

**Hazırlanma tarihi:** 2026-05-31 19:44:02

## 1. Ana hedef

uXBasic’in ana hedefi artık yalnız yeni komut eklemek değildir. Ana hedef **Full Surface Parity Compiler** olmaktır. Bunun Türkçe karşılığı şudur:

> Lexer yüzeyinde görünen her öğenin mimari içinde gerçek bir yaşam döngüsü olmalıdır.

Bir öğe lexer’da tanınıyorsa, o öğe parser, AST, semantic/type, MIR, interpreter, runtime/backend, test ve belge tarafında ya gerçek işlevle ya da hedefe özel açık “desteklenmez” tanısıyla karşılanmalıdır. Sessiz boşluk, sahte çıktı, placeholder ve dummy kabul edilmez.

## 2. Kaynak zipleri

| Kaynak | Dosya sayısı | Açılmış boyut | Zip boyutu | SHA256 kısa |
|---|---:|---:|---:|---|
| src(30.05_1) | 469 | 3,353,764 | 711,357 | `f11a74daf0299ed0...` |
| src(30.05_2) | 476 | 3,389,213 | 723,734 | `168a907dd72d64de...` |
| src(30.05_3) | 476 | 3,401,549 | 727,641 | `9a4c4cca288b9bb5...` |
| src(30.05_4) | 478 | 3,473,174 | 740,479 | `c64baef8a5f56231...` |
| src(30.05_5) | 482 | 3,541,903 | 750,839 | `a4dc2984c9171e02...` |
| src(31.05_1) | 485 | 3,714,197 | 768,020 | `47796309a97d9c3f...` |
| src(31.05_2) | 485 | 3,714,197 | 765,798 | `e42f9576947e9035...` |
| src | 485 | 3,714,197 | 765,798 | `f8ef7bb7b84ef45b...` |

Kaynaklar için ayrıntılı dosya-boyut matrisi `manifests/source_file_size_matrix.csv` içindedir. Sürüm farkları `manifests/source_version_delta.csv` içindedir.

## 3. Ana klasörler

- `pck_books/`: PCK kitaplarının eldeki son md/txt sürümleri.
- `patch_decisions/`: Operatör, BASIC eşitliği, TRUE/FALSE, Logic16 ve diğer yama paketleri.
- `analyses/`: Full surface parity, NO yorumları, ADIM36/ADIM45 hata zaman çizelgesi ve uygulama raporları.
- `manifests/`: Kaynak zip listeleri, dosya boyutları, karşılaştırma matrisleri ve SHA256 kayıtları.
- `docs/`: Bu pakette üretilen ana imalat karar dosyaları.
- `evidence_docs/`: Yama karar metinlerinden çıkarılmış birleşik kanıt metinleri.

## 4. Durum özeti

Mevcut bilgiye göre mimari güçlüdür: lexer/parser/AST/MIR/runtime/backend/CLI/test kapıları ayrılmıştır. Fakat kritik sorun, yüzeyin genişliğinin her katmanda aynı anlamla kapanmamış olmasıdır. Operatörler, `TRUE/FALSE`, Logic16, BASIC uyumlu `=` karşılaştırması, unary/ternary AST çocuk modeli, x64/JS/WASM emit eşliği ve kütüphane runtime doğrulaması ana kapanış işleridir.

## 5. En önemli kurallar

1. Lexer’da görünen her öğe mimaride yer bulacak.
2. Her komut her hedefte çalışmak zorunda değildir; ama her hedefte açık karar verecek.
3. Parser node üretmeden semantic çalışmayacak.
4. Semantic tip vermeden MIR inmeyecek.
5. MIR opcode registry olmadan backend emit yazmayacak.
6. Backend desteklemiyorsa fail-close verecek.
7. Test runner çıktı uydurmayacak.
8. Placeholder, dummy, TODO, artifact path reserved yasak.
9. PCK kitapları LLM eğitimi ve insan öğretimi için bilgi kaynağıdır; compiler gerçekliği ise kaynak ve testten gelir.

## 6. Kullanılacak ana dosyalar

- `docs/UXB_ANA_IMALAT_KARAR_DEFTERI.md`
- `docs/UXB_FULL_SURFACE_PARITY_YASAM_DONGUSU.md`
- `docs/UXB_DIL_YUZEYI_TOPLU_OZET.md`
- `docs/UXB_IPTAL_RED_KARARLAR.md`
- `docs/UXB_KURTARMA_REGRESYON_GUNLUGU.md`
- `docs/UXB_LLM_EGITIM_VERI_FABRIKASI_NOTU.md`

