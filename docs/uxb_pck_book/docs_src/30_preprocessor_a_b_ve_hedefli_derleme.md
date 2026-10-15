# 30. Preprocessor A/B ve Hedefli Derleme

uXBasic preprocessor, kaynak kodun derleyiciye gitmeden önceki aklını temsil eder. Normal komutlar program çalışırken davranır; preprocessor yönergeleri ise kaynak dosya daha lexer katmanına gitmeden önce çalışır. Bu yüzden `%%IF` ile `IF` aynı şey değildir. `IF` runtime karar yapısıdır; `%%IF` kaynak seçme yapısıdır.

uXBasic içinde preprocessor hattı iki ana seçenekle kullanılır:

```text id="h80vm1"
--pp A
--pp B
```

A hattı ana preprocess yoludur. B hattı genişletilmiş blok, web, manifest, asset ve hedef odaklı kullanım için tasarlanan ayrı yoldur. Kaynak içinde `%%PP B` benzeri seçimler veya CLI üzerinden `--pp B` kullanımı, kitapta hedefli preprocess örnekleri için özellikle anlatılır.

## 30.1. Değer tanımlama

| Yönerge | Syntax | Görev |
|---|---|---|
| `%%SET` | `%%SET AD = değer` | Meta değişken tanımlar veya değer atar. |
| `%%DEFINE` | `%%DEFINE AD değer` | Preprocess sembolü veya sabiti tanımlar. |
| `%%UNDEF` | `%%UNDEF AD` | Önceden tanımlanmış sembolü kaldırır. |
| `%%EVAL` | `%%EVAL AD = ifade` | Meta ifadeyi hesaplayıp sonuç üretir. |

Örnek:

```basic id="rqxmuw"
%%SET MOD = "DEBUG"
%%DEFINE LIMIT 100
%%EVAL CIFT_LIMIT = LIMIT * 2

%%IF MOD == "DEBUG"
PRINT "DEBUG_ACIK"
%%ENDIF
```

Bu örnekte `MOD`, `LIMIT` ve `CIFT_LIMIT` runtime değişkeni değildir. Bunlar kaynak hazırlanırken kullanılır.

## 30.2. Koşullu kaynak seçme

| Yönerge | Görev |
|---|---|
| `%%IF` | Koşul doğruysa bloğu kaynakta bırakır. |
| `%%IFC` | Koşullu kontrol için ek yüzey sağlar. |
| `%%IFN` | Olumsuz koşul kontrolü kurar. |
| `%%ELIF` | Önceki koşul yanlışsa yeni koşul dener. |
| `%%ELSE` | Hiçbir koşul sağlanmazsa seçilecek bloktur. |
| `%%ENDIF` | Koşullu preprocess bloğunu kapatır. |

Örnek:

```basic id="zm2upl"
%%SET HEDEF = "TEST"

%%IF HEDEF == "TEST"
PRINT "TEST_SURUMU"
%%ELIF HEDEF == "WEB"
PRINT "WEB_SURUMU"
%%ELSE
PRINT "NORMAL_SURUM"
%%ENDIF
```

Bu yapı, tek kaynak dosyadan farklı hedefler üretmeye yarar. Kitapta “öneri” olarak bırakılmaz; doğrudan bu örnekle gösterilir.

## 30.3. Döngülü preprocess

Preprocessor döngüleri tekrar eden kaynak parçalarını üretmek için kullanılır. Bu aile özellikle tablo, manifest, test dosyası, tekrar eden sabit ve hedef çıktısı oluştururken işe yarar.

| Yönerge | Görev |
|---|---|
| `%%FOR` | Sayısal veya sembolik tekrar başlatır. |
| `%%FOREACH` | Liste üzerinde tekrar kurar. |
| `%%REPEAT` | Belirli sayıda tekrar üretir. |
| `%%ENDFOR` | Döngü bloğunu kapatır. |
| `%%BREAK` | Preprocess döngüsünü erken keser. |
| `%%CONTINUE` | Sonraki preprocess tekrarına geçer. |

Kullanım fikri:

```basic id="aujrz0"
%%FOR I = 1 TO 3
PRINT "SATIR"
%%ENDFOR
```

Bu satırlar runtime `FOR` döngüsü değildir. Preprocessor bu bloğu kaynakta çoğaltır. Runtime döngüyle arasındaki fark kitapta özellikle vurgulanmalıdır.

## 30.4. Hedef seçme

| Yönerge | Görev |
|---|---|
| `%%TARGET` | Üretim hedefini belirtir: konsol, web, browser, wasm gibi. |
| `%%PLATFORM` | Platform bilgisini kaynak seçiminde kullanır. |
| `%%DESTOS` | Hedef işletim sistemi bilgisini taşır. |
| `%%PROFILE` | Debug, release, test gibi profil mantığını kurar. |
| `%%OUTDIR` | Üretilen artefactların çıkış klasörünü belirler. |

Örnek:

```basic id="sq8hd1"
%%TARGET WEB
%%PROFILE "DEBUG"
%%OUTDIR "dist/debug_web"

PRINT "HEDEF_WEB"
```

Bu örnek kaynak kodun kendisini değiştirmeden hedef bilgisini değiştirir. CLI tarafında aynı fikir `--target`, `--out-root`, `--artifact-root`, `--emit-js`, `--emit-wat`, `--emit-browser` gibi seçeneklerle tamamlanır.

## 30.5. HTML, CSS ve JS blokları

Web hedefinde preprocessor yalnız koşul seçmez; dosya üreten bloklar da açabilir.

| Yönerge | Görev |
|---|---|
| `%%HTML_BEGIN` / `%%HTML_END` | HTML artefact bloğu üretir. |
| `%%CSS_BEGIN` / `%%CSS_END` | CSS artefact bloğu üretir. |
| `%%JS_BEGIN` / `%%JS_END` | JS artefact bloğu üretir. |
| `%%JS_LINE` | Tek satırlık JS üretim yüzeyi sağlar. |

Örnek:

```basic id="6r10fc"
%%TARGET WEB
%%OUTDIR "dist/web_panel"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Panel</h1>
<div id="app"></div>
%%HTML_END

%%CSS_BEGIN "style.css"
body { font-family: sans-serif; }
%%CSS_END

%%JS_BEGIN "program.js" RUNTIME
console.log("PANEL_BASLADI");
%%JS_END

PRINT "WEB_ARTEFACT_OK"
```

Burada `PRINT` hâlâ uXBasic komutudur; HTML/CSS/JS blokları ise preprocess/backend artefact üretimiyle ilgilidir.

## 30.6. WAT/WASM blokları

| Yönerge | Görev |
|---|---|
| `%%WAT_BEGIN` / `%%WAT_END` | WAT metin bloğu açar ve kapatır. |
| `%%WAT_FUNC_BEGIN` / `%%WAT_FUNC_END` | WAT fonksiyon bloğu üretir. |
| `%%WAT_IMPORT` | WAT/WASM dış import tanımlar. |
| `%%WAT_EXPORT` | WAT/WASM dış export tanımlar. |

WAT örneği:

```basic id="jc5g9i"
%%TARGET WASM
%%OUTDIR "dist/wasm_demo"

%%WAT_BEGIN "module.wat"
(module
  (func $answer (result i32)
    i32.const 42)
  (export "answer" (func $answer))
)
%%WAT_END

PRINT "WAT_ROUTE"
```

Bu örnek WAT yüzeyini gösterir. Kitapta WAT/WASM hedefleri anlatılırken MIR destekli backend üretimiyle bu raw hedef blokları birbirinden ayırt edilmelidir.

## 30.7. Asset ve manifest ailesi

| Yönerge | Görev |
|---|---|
| `%%ASSET_ROOT` | Varlık dosyalarının kök klasörünü belirler. |
| `%%ASSET_FILE` | Tek dosyayı artefact listesine ekler. |
| `%%ASSET_COPY` | Varlık dosyasını çıktı klasörüne kopyalama yüzeyi kurar. |
| `%%ASSET_IMAGE` | Görsel varlık bildirir. |
| `%%ASSET_AUDIO` | Ses varlığı bildirir. |
| `%%MANIFEST_SET` | Manifest alanı yazar. |
| `%%MANIFEST_REQUIRE` | Zorunlu manifest alanı ister. |
| `%%JSON_SET` | JSON alanı üretir. |
| `%%JSON_BEGIN` / `%%JSON_END` | JSON blok üretimi yapar. |

Örnek:

```basic id="mdcnr7"
%%TARGET WEB
%%OUTDIR "dist/assets_demo"
%%ASSET_ROOT "assets"
%%ASSET_IMAGE "logo.png"
%%MANIFEST_SET name = "uXBasicDemo"
%%JSON_SET version = "12.06_1"

PRINT "ASSET_MANIFEST_OK"
```

Bu aile özellikle browser, oyun, eğitim aracı veya küçük web paneli üretirken kullanılır.

## 30.8. Güvenlik ve kapı yönergeleri

Raw JS, raw WAT, include ve host binding gibi alanlar güçlüdür; bu yüzden güvenlik kapılarıyla birlikte düşünülür.

| Yönerge | Görev |
|---|---|
| `%%ALLOW_RAW_JS` | Raw JS bloklarının kullanılmasına izin kapısı açar. |
| `%%ALLOW_RAW_WAT` | Raw WAT bloklarının kullanılmasına izin kapısı açar. |
| `%%SAFE_PATHS` | Güvenli dosya yolu sınırlarını belirtir. |
| `%%REQUIRE_HOST_BINDING` | Host tarafında gerekli bağlamı şart koşar. |

Kural şudur: hedefsiz raw kod serbest bırakılmaz. Bu kitap, güçlü kapıları gizlemez; fakat her güçlü kapının hangi hedef ve izinle kullanılacağını açık yazar.

## 30.9. Hangi yönergeler gerçekten %%PP B ister?

Bu bölümdeki `%%TARGET`, `%%ASSET_*`, `%%HTML_BEGIN`/`%%CSS_BEGIN`/`%%JS_BEGIN`, `%%MANIFEST_SET`, `%%JSON_SET` gibi yönergeler A kümesinde (varsayılan, `%%PP` hiç yazılmadığında aktif olan küme) doğrudan çalışır — bunlar için `%%PP B` gerekmez.

Buna karşılık, uygulama paketleme/dağıtım manifestine özgü aşağıdaki yönergeler **yalnızca `%%PP B` aktifken** çalışır:

```text id="ppb_liste"
BUNDLE_NAME  BUNDLE_VERSION  BUNDLE_ID  AUTHOR  LICENSE  BUILD_ID
SANDBOX_ROOT BROWSER_ENTRY   SCRIPT_ENTRY  STYLE_ENTRY  DATA_JSON
CSP  SECURITY_NOTE  CAPABILITY  EXPORT_BASIC  API_ENDPOINT  ROUTE
REQUIRE_ASSET  HOST_IMPORT  GEN_FILE  FEATURE  TEST_EXPECT  DOC
```

Bunlardan birini dosyanın başına `%%PP B` yazmadan kullanırsanız, derleyici artık size doğrudan **"`%%ROUTE` yalnızca `%%PP B` kümesi aktifken çalışır; bu satırdan önce `%%PP B` ekleyin"** tarzında açık bir tanı verir (eskiden bunun yerine kafa karıştırıcı bir "bilinmeyen komut" hatası alınıyordu). Doğru kullanım:

```basic id="ppb_ornek"
%%PP B
%%BUNDLE_NAME "uXBasicDemo"
%%ROUTE "/api/ping" -> "PingHandler"

PRINT "MANIFEST_OK"
```

`%%PP A` / `%%PP B` kaynak içinde birden fazla kez yazılabilir ve her seferinde o noktadan sonrasını gerçekten etkiler — yani bir dosyanın bir bölümünde `%%PP B` ile manifest yönergeleri kullanıp, ardından `%%PP A` yazıp devam edebilirsiniz. İki küme kasıtlı olarak ayrı tutulur (birleştirilmez): A kümesi genel amaçlı kaynak/hedef seçimi, B kümesi paketleme/dağıtım manifestine özgü, birbirine karışmaması istenen bir yüzeydir.

Son olarak, `%%EMBEDBASE64`, `%%GEN_BLOCK` ve `%%GEN_END` kanonik komut listesinde kayıtlıdır ama şu an ne A ne de B kümesinde gerçek bir karşılığı yoktur — bunlar `%%PP B` ile de çalışmaz, derleyici bunun için ayrı bir "henüz uygulanmadı" mesajı verir.
