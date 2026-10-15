# Preprocessor Referansı: Kaynağı Hedefe Hazırlama Dili

Preprocessor, uXBasic kaynak kodu parser katmanına ulaşmadan önce çalışan hazırlık katmanıdır. Bu katman sabit değerler kurabilir, koşullu bölümleri açıp kapatabilir, hedef platforma göre farklı kaynak parçaları seçebilir, HTML/JS/WAT blokları üretebilir, manifest bilgisi yazabilir ve asset dosyalarını hedef dizine bağlayabilir. Bu yüzden preprocessor yalnız “makro sistemi” değildir; kaynak kodun hedefe göre şekillendiği ilk kapıdır.

Kitapta preprocessor komutları tek tek listelenir; fakat asıl anlatım aileler üzerinden yürür. Çünkü `%%SET` tek başına anlamlıdır ama `%%IF` ile birleşince kaynak seçme gücü kazanır. `%%TARGET` tek başına hedef adını söyler ama `%%OUTDIR`, `%%HTML_BEGIN`, `%%JS_BEGIN` ve `%%ASSET_COPY` ile birleşince web projesi üretir.

## Değer ve sembol ailesi

| Komut | Görev |
|---|---|
| `%%SET` | Preprocess değişkenine değer atar. |
| `%%DEFINE` | Sembol veya kısa değer tanımlar. |
| `%%UNDEF` | Daha önce tanımlanmış sembolü kaldırır. |
| `%%EVAL` | Preprocess ifadesini hesaplayıp değer üretir. |

Temel örnek:

```basic
%%SET MOD = "DEBUG"
%%DEFINE LIMIT 100
%%EVAL IKI_LIMIT = LIMIT * 2

PRINT %%EVAL(IKI_LIMIT)
```

Beklenen çıktı fikri:

```text
200
```

Bu örnekte `LIMIT` sıradan runtime değişkeni değildir; kaynak derleyiciye gitmeden önce preprocessor tarafından değerlendirilir.

## Koşul ailesi

| Komut | Görev |
|---|---|
| `%%IF` | Preprocess koşulu doğruysa bölümü açar. |
| `%%IFC` | Tanımlı sembol veya koşul kontrolü için kullanılır. |
| `%%IFN` | Koşulun tersine göre bölüm seçer. |
| `%%ELIF` | Önceki koşul yanlışsa yeni koşul dener. |
| `%%ELSE` | Hiçbir koşul tutmazsa açılacak bölümü başlatır. |
| `%%ENDIF` | Koşul bloğunu kapatır. |

Örnek:

```basic
%%SET HEDEF = "KONSOL"

%%IF HEDEF == "KONSOL"
PRINT "Konsol hedefi"
%%ELSE
PRINT "Baska hedef"
%%ENDIF
```

Burada `IF` değil, `%%IF` kullanılır. `IF` runtime karar verir; `%%IF` kaynak kodu derleyiciye ulaşmadan önce seçer. Bu ayrım kitap boyunca korunur.

## Döngü ailesi

| Komut | Görev |
|---|---|
| `%%FOR` | Preprocess seviyesinde sayısal tekrar kurar. |
| `%%FOREACH` | Liste veya sembol kümesi üzerinde tekrar kurar. |
| `%%REPEAT` | Belirli sayıda kaynak tekrarı üretir. |
| `%%ENDFOR` | Preprocess döngüsünü kapatır. |
| `%%BREAK` | Preprocess döngüsünden çıkar. |
| `%%CONTINUE` | Sonraki preprocess tekrarına geçer. |

Örnek fikir:

```basic
%%FOREACH AD IN "A,B,C"
PRINT "{{AD}}"
%%ENDFOR
```

Bu yapı, üç ayrı `PRINT` satırını elle yazmak yerine kaynak üretme fikrini gösterir. Kitapta bu aile özellikle test, tablo üretme, benzer fonksiyon gövdeleri ve hedefe göre küçük varyasyonlar için önerilir.

## Hedef ve çıktı dizini ailesi

| Komut | Görev |
|---|---|
| `%%TARGET` | Üretim hedefini seçer: konsol, web, JS, WAT/WASM veya başka hedef ailesi. |
| `%%PLATFORM` | Platform bilgisini preprocess kararlarına taşır. |
| `%%DESTOS` | Hedef işletim sistemi bilgisini belirtir. |
| `%%PROFILE` | Build veya çıktı profilini seçer. |
| `%%OUTDIR` | Üretilecek dosyaların çıkış dizinini belirler. |

Örnek:

```basic
%%TARGET WEB
%%OUTDIR "dist/demo"

PRINT "WEB_ROUTE"
```

Bu örnek yalnız bir mesaj basmaz; kaynak dosyanın web hedefiyle ilişkilendirildiğini de belirtir.

## HTML, CSS ve JS blokları

| Komut | Görev |
|---|---|
| `%%HTML_BEGIN` / `%%HTML_END` | HTML çıktı bloğu açar ve kapatır. |
| `%%CSS_BEGIN` / `%%CSS_END` | CSS çıktı bloğu açar ve kapatır. |
| `%%JS_BEGIN` / `%%JS_END` | JS çıktı bloğu açar ve kapatır. |
| `%%JS_LINE` | Tek satırlık JS çıktı satırı üretir. |

Web örneği:

```basic
%%TARGET WEB
%%OUTDIR "dist/app"
%%SET TITLE = "uXBasic Web"

%%HTML_BEGIN "index.html" BODY
<h1>{{TITLE}}</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("uXBasic browser runtime");
%%JS_END

PRINT "WEB_ROUTE"
```

Bu örnekte HTML ve JS kodu doğrudan ana runtime komutlarıyla karıştırılmaz. Preprocessor, hedef dosyaları üretmek için ayrı bloklar açar. Böylece aynı kaynak dosyada hem uXBasic program akışı hem de web artefact üretimi bulunabilir.

## WAT ve WASM ailesi

| Komut | Görev |
|---|---|
| `%%WAT_BEGIN` / `%%WAT_END` | WAT çıktı bloğunu açar ve kapatır. |
| `%%WAT_FUNC_BEGIN` / `%%WAT_FUNC_END` | WAT fonksiyon bloğu kurar. |
| `%%WAT_IMPORT` | WASM tarafı import bildirimi üretir. |
| `%%WAT_EXPORT` | WASM export bildirimi üretir. |

WAT/WASM hedefleri kitapta MIR hattıyla birlikte anlatılır. Çünkü uXBasic’in hedef üretim fikrinde AST kaynak anlamını taşır, MIR ise hedefe inmeyi kolaylaştırır. Preprocessor bu hedef için gerekli raw veya yardımcı blokları hazırlayabilir.

## Asset ailesi

| Komut | Görev |
|---|---|
| `%%ASSET_ROOT` | Asset dosyalarının kök dizinini belirler. |
| `%%ASSET_FILE` | Tekil asset dosyasını tanımlar. |
| `%%ASSET_COPY` | Asset dosyasını çıktı dizinine kopyalama sözleşmesi kurar. |
| `%%ASSET_IMAGE` | Görsel asset bilgisini üretim hattına bildirir. |
| `%%ASSET_AUDIO` | Ses asset bilgisini üretim hattına bildirir. |

Örnek:

```basic
%%TARGET WEB
%%OUTDIR "dist/game"
%%ASSET_ROOT "assets"
%%ASSET_IMAGE "logo", "logo.png"
%%ASSET_COPY "logo.png"

PRINT "ASSET_ROUTE"
```

Bu örnek, oyun veya web programında kaynak dışı dosyaların nasıl düşünülmesi gerektiğini gösterir. Kod tek başına program değildir; görsel, ses, veri dosyası ve manifest de program paketinin parçasıdır.

## Güvenlik ve fail-close ailesi

| Komut | Görev |
|---|---|
| `%%ALLOW_RAW_JS` | Raw JS kullanımını hedefli ve bilinçli biçimde açar. |
| `%%ALLOW_RAW_WAT` | Raw WAT kullanımını hedefli biçimde açar. |
| `%%SAFE_PATHS` | Güvenli dosya yolları politikasını belirtir. |
| `%%REQUIRE_HOST_BINDING` | Host bağlamı gerektiren özellikleri açıkça ister. |

Bu ailede ana ilke şudur: hedefsiz raw kod serbest bırakılmaz. Kitapta güvenlik notu kuru bir uyarı olarak yazılmaz; nasıl kodlanacağı gösterilir.

Yanlış yaklaşım:

```basic
%%JS_BEGIN "program.js" RUNTIME
console.log("hedefsiz raw js");
%%JS_END
```

Doğru yaklaşım:

```basic
%%TARGET WEB
%%ALLOW_RAW_JS

%%JS_BEGIN "program.js" RUNTIME
console.log("hedefli raw js");
%%JS_END
```

## Manifest ve JSON ailesi

| Komut | Görev |
|---|---|
| `%%MANIFEST_SET` | Uygulama manifest değerini tanımlar. |
| `%%MANIFEST_REQUIRE` | Manifest içinde bulunması gereken alanı şart koşar. |
| `%%JSON_SET` | JSON değer alanı üretir. |
| `%%JSON_BEGIN` / `%%JSON_END` | JSON çıktı bloğu açar ve kapatır. |

Örnek:

```basic
%%MANIFEST_SET "name", "uxbasic-demo"
%%MANIFEST_SET "version", "1.0.0"
%%MANIFEST_REQUIRE "name"

PRINT "MANIFEST_READY"
```

Bu örnek, uygulama paketinin yalnız koddan oluşmadığını gösterir. Özellikle web, eklenti, modül ve dış araç paketlerinde manifest bilgisi üretim hattının parçasıdır.

## Preprocessor ve runtime IF farkı

Aşağıdaki iki yapı birbirine benzese de aynı işi yapmaz:

```basic
%%IF HEDEF == "WEB"
PRINT "WEB kaynakta acildi"
%%ENDIF
```

Bu karar derleme öncesi verilir.

```basic
IF hedef = "WEB" THEN
    PRINT "WEB runtime karar"
END IF
```

Bu karar program çalışırken verilir. Kitapta bu ayrım sürekli korunur. `%%IF` kaynak seçer, `IF` program akışını seçer.
