# Dış Kütüphaneler Ana Bölümü

## Güncel ABI10 ve güvenlik sözleşmesi

Güncel Windows x64 dış çağrı sözleşmesi `uxffi` API 131 ve en çok 10 argümandır. Desteklenen dönüş tipleri `VOID, I32, U32, I64, U64, F64, PTR, STRPTR`; argüman tipleri `I32, U32, I64, U64, F64, PTR, STRPTR`; çağrı düzenleri `CDECL` ve `STDCALL` biçimindedir. Pointer sonuçları ham adres olarak değil generation kontrollü opaque token olarak taşınır. `STRPTR` sonucu çağrı kilidi açıkken dinamik bir uXBasic metnine kopyalanır.

Önerilen açık tipli biçim:

```basic
sonuc = CALL(DLL, "kutuphane.dll", "fonksiyon", I32, CDECL, "I32,STRPTR", sayi, metin)
```

Strict politika, allowlist kaydının DLL adı, sembol, dönüş tipi, çağrı düzeni, SHA-256 ve Authenticode imza konusu ile eşleşmesini ister. Report-only politika kararı kaydeder fakat geçerli bir DLL yükleme veya ABI hatasını görmezden gelmez.

Bu bölüm uXBasic’in `libsx` dış kütüphane wrapper yüzeyini resmi kitap içine taşır. Amaç yalnız modül adlarını saymak değildir; her wrapper fonksiyonunun ne yaptığı, hangi parametreleri aldığı, ne döndürdüğü, hangi DLL veya native sembole bağlandığı ve program içinde nasıl kullanılacağı ayrı ayrı açıklanır.

Bu baskıda dış kütüphane belgeleri `18` wrapper dosyasından üretilmiştir. Toplam `552` fonksiyon/sub yüzeyi ayrıntılı olarak anlatılır. `uxllamax` placeholder gibi imzasız dosyalar da gelecek genişleme noktası olarak görünür tutulur.

Dış kütüphane zinciri genel olarak şöyledir:

```text
uXBasic kaynak kodu
    ↓
INCLUDE ile wrapper dosyası
    ↓
Wrapper fonksiyon/sub
    ↓
CALL(DLL, ...) runtime rotası
    ↓
ux*.dll / native runtime / dış motor
```

| Modül | Wrapper dosyası | Namespace | Fonksiyon sayısı | Ana görev |
|---|---|---|---:|---|
| `uxaimath` | `libsx/uxaimath/uxaimath.bas` | `uxaimath` | 46 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxcollections` | `libsx/uxcollections/uxcollections.bas` | `uxcollections` | 27 | liste, yığın, kuyruk, sözlük, set ve ağaç koleksiyonları |
| `uxdataframe` | `libsx/uxdataframe/uxdataframe.bas` | `uxdataframe` | 31 | DuckDB tabanlı tablo, SQL ve veri çerçevesi işlemleri |
| `uxdataset` | `libsx/uxdataset/uxdataset.bas` | `uxdataset` | 34 | eğitim veri kümesi, batch, ölçekleme ve CSV akışı |
| `uxgraph` | `libsx/uxgraph/uxgraph.bas` | `uxgraph` | 30 | graf, kenar, yol, bileşen ve ağ ölçümleri |
| `uxllama` | `libsx/uxllama/uxllama.bas` | `uxllama` | 17 | yerel LLM, prompt çalıştırma ve düşük bellek profili |
| `uxllamax_placeholder` | `libsx/uxllamax/UXLLAMAX_PLACEHOLDER.bas` | `-` | 0 | yerel LLM, prompt çalıştırma ve düşük bellek profili |
| `uxmath` | `libsx/uxmath/uxmath.bas` | `-` | 9 | vektör, sayısal yardımcı ve ham veri yüzeyi |
| `uxmathcore` | `libsx/uxmathcore/uxmathcore.bas` | `-` | 51 | tipli buffer, ham bellek ve temel matematik çekirdeği |
| `uxmatrix` | `libsx/uxmatrix/uxmatrix.bas` | `uxmatrix` | 34 | matris ve OpenBLAS destekli sayısal hesap |
| `uxnn` | `libsx/uxnn/uxnn.bas` | `uxnn` | 33 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxnn2` | `libsx/uxnn2/uxnn2.bas` | `uxnn2` | 23 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxnn3` | `libsx/uxnn3/uxnn3.bas` | `uxnn3` | 33 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxonnx` | `libsx/uxonnx/uxonnx.bas` | `uxonnx` | 21 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxonnx2` | `libsx/uxonnx2/uxonnx2.bas` | `uxonnx2` | 42 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxstats` | `libsx/uxstats/uxstats.bas` | `-` | 27 | istatistik, hipotez testi ve veri analizi |
| `uxstats2` | `libsx/uxstats/uxstats2.bas` | `-` | 56 | istatistik, hipotez testi ve veri analizi |
| `uxtensor` | `libsx/uxtensor/uxtensor.bas` | `uxtensor` | 38 | tensor, çok boyutlu dizi ve temel lineer cebir |

Her modülün kendi belgesi `docs_src/external_libraries/` altında bulunur. Her modül için ayrıca `docs_examples/external_libraries/` altında uzun REM açıklamalı kullanım örnekleri üretilir.
