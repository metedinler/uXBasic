# 18. Meta sistemi: derleyicinin iç sistemine bağlanmak

"Meta", programın **kendisi hakkındaki bilgi**dir: hangi işlev var, parametreleri ne, hangisi bir sınama, hangisi dışa açılacak. Bu bilgiyi kullanarak program ya da araçlar **yeni kod, belge, sınama, köprü üretebilir**.
uXBasic'in tasarımı bunun için üç ayrı katman koyar. Bu bölüm her katmanın **bugünkü gerçek durumunu** ve **tasarımını** ayrı ayrı anlatır.

> **Önce dürüst özet.** Katman 1 (ham `%%` önişlemci) bugün çalışır (Bölüm 17). Katman 2 ve 3 (`REM %%ATTR`, `REM %%MIR`) tasarım kararıdır ama **kaynak kodda hiç yoktur**: bugün bu satırlar yalnızca yorumdur ve yanlış yazılsalar bile hata vermezler (G-META-1).
> Derleyicinin iç bilgisine bugün **JSON raporları** üzerinden ulaşılır; bu bölümün sonundaki iki araç örneği bunu gerçek çalıştırmayla gösterir.

## 18.1 Üç katman

| Katman | Yazım | Ne yapar? | Ne zaman çalışır? | Durum |
|---|---|---|---|---|
| 1. Ham önişlemci | `%%DEFINE`, `%%FOREACH` … | Programın **kaynağını üretir/değiştirir** | Ayrıştırmadan önce | ✔ Çalışıyor (Bölüm 17) |
| 2. Öznitelik | `REM %%ATTR ad [bağımsız değişkenler]` | Oluşan programı **tanımlar** (sınama mı, dışa açık mı, kullanımdan kalkmış mı) | AST oluştuktan sonra, bir sonraki bildirime bağlanır | ◇ HEDEF; bugün yok sayılır |
| 3. MIR politikası | `REM %%MIR politika [değer]` | Ara kod/arka uç davranışını etkiler | MIR oluşurken | ◇ HEDEF; bugün yok sayılır |
| (4. MIR sonrası) | — | Manifest, köprü, belge, sınama listesi **üretir**; kaynağı geriye değiştirmez | Arka uçlardan sonra | ◐ Yalnız tarayıcı manifesti ve JSON raporları |

Tasarımın temel sınırı: **`REM %%` geçmişi değiştiremez.** Ham `%%` kaynağı üretir; `REM %%ATTR` oluşan programı tanımlar; MIR'den sonrası yalnız bilgi okur ve çıktı üretir. Böylece derleme döngüye girmez.

## 18.2 Tasarlanan derleme boru hattı

| Adım | Aşama | Ne yapar? | Bugün |
|---|---|---|---|
| 1 | `PreprocessRun` | Ham `%%` komutlarını işler | ✔ |
| 2 | `expandedSource` | Genişletilmiş kaynak oluşur (`--preprocessed-out`) | ✔ |
| 3 | `MetaScanExpandedSource` | Genişletilmiş kaynakta `REM %%` satırlarını toplar | ✖ yok |
| 4 | Sözcük çözümleyici + ayrıştırıcı | AST | ✔ |
| 5 | `MetaBindAST` | Toplanan kaydı doğru AST düğümüne (bir sonraki işlev/sınıf) bağlar | ✖ yok |
| 6 | Anlam çözümleme, tip, yerleşim | Gerçek tip ve sembol bilgisi | ✔ |
| 7 | MIR üretimi | Ara kod | ✔ |
| 8 | `MetaBindMIR` | Meta kayıtlarını MIR'e (`MIRModule.metaRecords`) indirger | ✖ yok |
| 9 | MIR eniyileme ve doğrulama | — | ✔ |
| 10 | Kanonik MIR köprüsü | Meta kayıtlarını kanonik MIR'e de kopyalar | ✖ yok |
| 11 | MIR yorumlayıcı / x64 / JS / WAT-WASM | Dört arka uç **aynı** `MIRModule` nesnesini okur | ✔ (metasız) |
| 12 | `MetaEmitArtifacts` | Manifest, köprü, belge, sınama listesi üretir | ◐ yalnız tarayıcı manifesti |

Önişlemci `REM %%` taramasından **önce** çalıştığı için, `%%FOREACH` ile çoğaltılmış bir `REM %%ATTR TEST` satırı kaynakta gerçekten iki satır olur ve iki ayrı işleve bağlanır. Ayrı bir yinelemeli meta-önişlemci gerekmez.

## 18.3 `REM %%ATTR` (◇ HEDEF)

Tasarlanan ilk öznitelik kümesi küçüktür ve bilerek kısa tutulmuştur:

| Öznitelik | Anlamı | Ürettiği şey (tasarım) |
|---|---|---|
| `REM %%ATTR TEST` | Bu işlev bir sınamadır | Sınama listesi ve koşucu |
| `REM %%ATTR DEPRECATED "yeni ad"` | Kullanımdan kalkmış | Çağrılarda uyarı |
| `REM %%ATTR REFLECT` | Çalışma anı yansıma tablosuna girsin | Yalnız işaretli tipler için tablo (dosya şişmez) |
| `REM %%ATTR SERIALIZABLE` | Seri hâle getirilebilir | `ToJson` / `FromJson` üretimi |
| `REM %%ATTR EXPORT JS` / `EXPORT WASM` | Dışa açılsın | İşlev imzası MIR'den okunur, köprü dosyası üretilir |
| `REM %%ATTR ROUTE GET "/api/fish/{id}"` | HTTP yolu | Yönlendirme tablosu, istemci kodu |
| `REM %%ATTR AUTHOR "Mete"` | Belge bilgisi | Belge üretimi |

**Bugünkü gerçek:** bu satırlar derleyici tarafından **hiç okunmaz**. Aşağıdaki örnekte olmayan bir öznitelik adı ve olmayan bir MIR politikası yazıldı; derleme sorunsuz geçer. Bu, "hata sessiz geçmez" ilkesine aykırıdır ve Ek G'de ilk sırada izlenir (G-META-1):

{{ORNEK:23_tasarim/meta_rem_attr|baslik=REM %%ATTR bugün yalnızca yorumdur}}

> **Pratik sonuç:** bugün `REM %%ATTR` yazmanın bir faydası yoktur; kaynakta bir *belge notu* olarak kalır. Aynı niyeti taşımak için adlandırma kuralı kullanın (örn. sınama işlevlerini `Test_` ile başlatın) ve 18.6'daki gibi bir araçla okuyun.

## 18.4 `REM %%MIR` (◇ HEDEF)

`REM %%MIR` yalnız **gerçekten bir tüketicisi olan** MIR/arka uç politikaları içindir. Tasarım kararı şudur: tanınan ama uygulanmayan bir politika `META_MIR_POLICY_NOT_IMPLEMENTED` tanısıyla **durdurur**; yani `REM %%MIR INLINE` gibi bir komut, MIR'de satır içi açma gerçekten yazılmadan "çalışıyor" sayılmaz.
Bugünkü MIR eniyileyicisi yalnızca sabit katlama ve ölü blok temizliği yapar; satır içi açma yoktur.

## 18.5 Meta nasıl derleyicinin iç sistemine bağlanacak? (tasarım)

| Mekanizma | Açıklama |
|---|---|
| **Meta kayıt defteri** (`MetaRegistry`) | Her `REM %%` kaydı: tür, ad, bağımsız değişkenler, kaynak dosya/satır, bağlandığı AST düğümü ve MIR hedefi |
| **AST'ye yan tablo** | AST düğümüne büyük yapı gömülmez; kayıt defteri düğüm numarasını dışarıdan tutar |
| **MIR'e veri olarak** | Her öznitelik için sahte işlem kodu (`MIR_TEST` gibi) üretilmez; meta kayıtları `MIRModule` içinde **veri** olarak durur, bu yüzden x64, JS ve WASM aynısını görür |
| **Kütüphane tipi sözleşmesi** | Meta, tip sözleşmesindeki gerçek yerleşimi/alanları sorgular; tip `opaque` ise ya da hedef politikası `fail_closed` ise meta bunu **aşamaz** |
| **Eski B manifesti** | `EXPORT_BASIC`, `API_ENDPOINT` gibi mevcut anahtarlar yeniden icat edilmez; yeni öznitelikler aynı manifest anahtarlarını üretir |
| **Deterministik motor** | Meta motoru yalnız veri okur, metin işler, döngü/koşul çalıştırır, şablon açar, kaynak/dosya üretir. Rastgele işletim sistemi komutu çalıştırmaz (`%%PYTHON_EXEC` gibi bir yönerge **konmayacaktır**); çünkü tekrarlanabilirlik, güvenlik ve JS/WASM paketleme bozulur |
| **Hedeften bağımsız üretim** | Üretici uXBasic kaynağı verirse aynı kod x64, JS ve WASM'a gider |

Tasarımın "derleme zamanı kod üretim sistemi" olması için eksik gördüğü **dört parça**:

| Eksik | Anlamı |
|---|---|
| Meta kayıtları üzerinde dolaşma | `%%FOREACH API IN META.API_ENDPOINTS` gibi, derleyicinin kendi kayıt listelerini gezmek |
| `GEN_BLOCK` ile **kaynak** enjeksiyonu | `%%GEN_BLOCK SOURCE` … `%%GEN_END`: bloğun metni dosyaya değil, derlenmeye devam eden kaynağa eklenir (bugün yalnız dosyaya yazılır) |
| Sembol yansıması | "Bana `TYPE Fish`'in alanlarını ver" diyebilmek (`%%FOREACH_FIELD`); bunun için önişlemci AST'den sonra da çalışmalı (PRE/POST meta) |
| Üretici kayıt defteri | `%%GENERATE REST`, `SERIALIZER`, `CLASS`, `FUNCTION`, `DERIVE JSON, EQ, HASH FOR T` gibi tek üst komutla çağrılan üreticiler |

Bir tanımdan beş çıktı üretmek, tasarımın amacıdır: örneğin `%%API_ENDPOINT` kayıtlarından işleyici iskeletleri, yönlendirme tablosu, OpenAPI benzeri belge, tarayıcı istemci kodu ve sınama iskeleti.

## 18.6 Bugün çalışan bağlantı yolları

Meta kayıt defteri olmasa da derleyicinin iç bilgisine **bugün** şu yollarla ulaşılır:

| Veri | Seçenek | İçerik | Not |
|---|---|---|---|
| Belirteçler | `--tokens-json-out` | Dizi; her belirtecin `kind`, `rawLexeme`, `canonicalLexeme`, `lineNo`, `colNo`, `offset`, `length` alanları | ✔ |
| **AST** | `--ast-json-out` | `node_count` ve `root`; her düğümde `kind`, `value`, `op`, `type`, `line`, `column`, `parent`, `children`, `contract_status` ve hedef başına **`target_support`** (`semantic`, `mir`, `x64_mir`, `js`, `wasm` … için `IMPLEMENTED`, `WASM_UNSUPPORTED` …) | ✔ en zengin kaynak |
| MIR | `--mir-json-out` | `functions`, `globals`, `global_types`. `--semantic` gerekmez; düz `mir` fiili parametreli işlevde düşer (G-CLI-1) | ✔ |
| Kanonik MIR | `--canonical-mir-json-out` | `instructions` dizisi, `verify_status`, işlev/blok/komut sayıları, tanılar | ✔ |
| Sembol/tip özeti | `--symbol-table-json-out`, `--type-table-json-out` | **Her boyuttaki programda yalnız sayılar** (düğüm, komut, işlev, işleç, tip, veri yapısı); ad ve tip yok (✖ G-CLI-10). Adlar için `--out-root` altındaki `logs\adim5_type_table.csv` | ◐ |
| Önişlemci | `--preprocess-result-json-out`, `%%DUMP_META` | Sayılar (`blockCount`, `assetCount`, `lockCount`, `diagnosticCount` …) ve listeler (`blocks`, `assets`, `locks`, `diagnostics` …) | ◐ |
| Tip çıkarımı | `--type-infer-report-csv-out` | CSV: `name,return_type,arg_policy,target_policy,source`; yerleşik işlevlerin tip tablosu | ✔ (Ek B'nin kaynağı) |
| Tanılar | `--diag-format json` | `code`, `severity`, `layer`, `message`, `source` (dosya, satır, sütun), `details`. **Art arda JSON nesneleri**, tek belge değil (✖ G-CLI-18); kod ve katman ileti sözcüklerinden tahmin edilir (✖ G-HATA-10) | ◐ |
| Çalışma zamanı yol matrisi | `--runtime-route-matrix-json-out` | Gerçek bir matris: 76 çalışma zamanı hizmeti × `x64_status`, `js_status`, `wasm_status`, `browser_status`, `gate_status` | ✔ |
| Arka uç sonucu | `--backend-matrix-json-out`, `--backend-report-json-out` | **Tek çalıştırmanın** sonucu: `target`, `status`, `code`, `emitted_path`, `error`. Yüzey × hedef matrisi **değildir** (✖ G-CLI-17) | ◐ |
| AST sözleşme çizelgesi | `--ast-contract-matrix-out` | CSV (JSON değil): düğüm, model, durum, tanı | ✔ |
| Tarayıcı manifesti | `--manifest-out` (`--emit-browser` ile) | `html`, `js`, `wat`, `wasm`, `preprocess_blocks`, `preprocess_assets`. `--emit-browser` olmadan dosya **yazılmaz**, uyarı da çıkmaz (✖ G-CLI-16) | ◐ |

İki **gerçek** kullanım:

**Orta düzey: kaynaktan API belgesi çıkarmak.** Derleyici `ast.json` dosyasını yazar; küçük bir betik bu dosyayı okuyup işlev, yordam ve sınıf imzalarını listeler. Kaynak metni betik kendisi ayrıştırmaz:

{{ARAC:meta/ast_api_belgesi|baslik=AST JSON'undan işlev ve sınıf belgesi}}

**Üst düzey: sınama işlevlerini bulup koşucu üretmek.** `REM %%ATTR TEST` henüz yokken aynı niyeti adlandırma kuralıyla gerçekleştirmek: AST'den `Test_` ile başlayan `BOOLEAN` işlevleri bulunur, her biri için bir çağrı yazılır, ortaya çıkan program MIR yorumlayıcısıyla çalıştırılır. Elle sınama listesi tutmak gerekmez:

{{ARAC:meta/test_kosucu_uret|baslik=Sınama koşucusu üretmek (meta üretim)}}

Bu iki örnek, tasarımın "ham %% → AST → kayıt defteri → üretici → yeniden derleme" zincirinin **dışarıdan** çalışan karşılığıdır. Tasarım da zaten dış aracı ara çözüm olarak öngörür; uzun vadede aynı iş derleyici içinde yapılacaktır.

## 18.7 Önişlemciyle kod üretimi (bugün çalışan "meta")

Bugün gerçek derleme zamanı kod üretimi `%%FOREACH`, `%%FOR`, `%%MACRO`, `%%IF` ve `%%INCLUDE` ile yapılır (Bölüm 17.6). Bu üretimin tasarım hedefiyle karşılaştırması:

| İhtiyaç | Bugün | Tasarım hedefi |
|---|---|---|
| Aynı gövdeyi birkaç tip için üretmek | ✔ `%%FOREACH T IN (I32, I64, F64)` | Aynı |
| Listeden işlev ve dağıtım üretmek | ✔ `uretilen_komut_tablosu` örneği | Aynı |
| Tip alanlarını gezip serileştirici üretmek | ✖ | `%%DERIVE JSON FOR T`, `%%FOREACH_FIELD` |
| API uç noktalarından işleyici üretmek | ✖ (uç noktalar kaydedilir ama dolaşılamaz) | `%%FOREACH API IN META.API_ENDPOINTS` |
| Üretilen metni **kaynağa** eklemek | ✔ yalnız `%%FOREACH` gövdesinde | `%%GEN_BLOCK SOURCE` |
| Üretilen metni **dosyaya** yazmak | ✔ `%%GEN_BLOCK` (B) | Aynı |
| Şablon dosyasından HTML üretmek | ✖ (`TEMPLATE_*` yalnız kayıt) | `TEMPLATE_FILE`, `TEMPLATE_PARAM`, `TEMPLATE_APPLY` |
| Eski kaynak `%%DEFINE` yerine `REM %%DEFINE` | ✖ (yorum olur) | Tasarım: yeni araçlar `REM %%…` yazar, eski biçim kırılmaz |

## 18.8 Meta ile ilgili programlama kararları

* Bugün `REM %%ATTR` yazmayın; hiçbir şey yapmaz ve yanlış yazımı da yakalanmaz. Niyeti **adlandırma kuralıyla** (`Test_…`) ve dış araçla taşıyın.
* Üretilmiş kodu elle düzenlemeyin; üretimin kaynağını (`%%FOREACH` listesini) düzenleyin ve `--preprocessed-out` ile sonucu görün.
* Derleyici iç bilgisi gerekiyorsa kaynağı kendi ayrıştırıcınızla çözmeyin; `--ast-json-out` ve `--mir-json-out` raporlarını okuyun.
* Meta üretiminde rastgelelik, saat, ağ ve işletim sistemi komutu kullanmayın: üretim **deterministik** olmalıdır (aynı kaynak, aynı çıktı).
* Üretimin hedefe bağlı olmasından kaçının: üretici uXBasic kaynağı üretirse aynı kod x64, JS ve WASM'a gidebilir.
