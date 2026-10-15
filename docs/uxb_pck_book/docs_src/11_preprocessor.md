# Preprocessor

Preprocessor, kaynak kod derleyiciye gitmeden önce çalışan üst düzenleyicidir. Kaynak dosyaya hedef, koşul, döngü, asset, manifest, HTML, JS, WAT ve güvenlik bilgisi ekleyebilir. Bu yüzden preprocessor yalnız birkaç `%%` komutu değil, uXBasic’in hedefe göre kaynak hazırlama dilidir.

## Değer tanımlama ve koşul

```basic
%%SET FLAG = 1
%%DEFINE BASE 10
%%EVAL DOUBLE_BASE = BASE * 2

%%IF FLAG == 1
PRINT "META_ON"
%%ENDIF

PRINT %%EVAL(DOUBLE_BASE)
```

Beklenen çıktı:

```text
META_ON
20
```

`%%SET` meta değişken kurar. `%%DEFINE` sabit tanımlar. `%%EVAL` meta ifadeyi hesaplar. `%%IF` kaynak kodun hangi bölümünün derleyiciye gideceğini belirler.

## Include ve foreach ailesi

Preprocessor, include ve döngü mantığıyla tekrarlı kaynak üretimi yapabilir. Bu özellik özellikle sabit tablo, tekrar eden wrapper, hedefe göre blok üretme ve küçük DSL kurguları için önemlidir.

## Web hedefi

```basic
%%TARGET WEB
%%OUTDIR "dist/pack19"
%%SET TITLE = "PACK19"

%%HTML_BEGIN "index.html" BODY
<h1>{{TITLE}}</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("PACK19");
%%JS_END

PRINT "WEB_ROUTE"
PRINT "WASM_READY"
```

Beklenen çıktı:

```text
WEB_ROUTE
WASM_READY
```

Bu örnek preprocessor’ın yalnız derleme içi makro olmadığını gösterir. `%%TARGET WEB`, hedefi web olarak belirler. `%%OUTDIR`, çıktı klasörünü seçer. `%%HTML_BEGIN` ve `%%JS_BEGIN`, hedef dosya içerikleri üretir. `PRINT` ise uXBasic kaynak akışında kalır.

## Preprocessor aileleri

| Aile | Komutlar | Görev |
|---|---|---|
| Değer | `%%SET`, `%%DEFINE`, `%%UNDEF`, `%%EVAL` | Meta değer kurar, siler ve hesaplar. |
| Koşul | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` | Kaynak bloklarını koşula göre açar veya kapatır. |
| Döngü | `%%FOR`, `%%FOREACH`, `%%REPEAT`, `%%ENDFOR` | Tekrarlı kaynak üretimi kurar. |
| Hedef | `%%TARGET`, `%%OUTDIR`, `%%PLATFORM`, `%%PROFILE` | Üretim hedefi ve çıktı alanını seçer. |
| Web | `%%HTML_BEGIN`, `%%HTML_END`, `%%CSS_BEGIN`, `%%JS_BEGIN`, `%%JS_END` | HTML, CSS ve JS artefact üretir. |
| WAT/WASM | `%%WAT_BEGIN`, `%%WAT_END`, `%%WAT_IMPORT`, `%%WAT_EXPORT` | WAT/WASM hedeflerine bağlanır. |
| Asset | `%%ASSET_ROOT`, `%%ASSET_FILE`, `%%ASSET_COPY`, `%%ASSET_IMAGE` | Dosya, görsel, ses ve veri varlıklarını yönetir. |
| Güvenlik | `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SAFE_PATHS` | Hedefsiz raw kod ve tehlikeli yol kullanımını kapıdan geçirir. |

Preprocessor komutları kitapta liste olarak kalmaz. Her aile hedef örneğiyle birlikte anlatılır.
