# uXBasic Birleşik Önişlemci + REM Meta + MIR Sistemi

Kaynak temeli: `uxb(23.09)(1).zip` (23.09.2026 kaynak ağacı)

## 1. Kaynak koddan çıkan kesin sonuç

Mevcut A/B ayrımı artık gerçek mimariyi doğru anlatmıyor. `preprocess_selector.fbs` A'yı varsayılan, B'yi seçilebilir küme olarak tutuyor; ancak `preprocess_engine.fbs` içinde B aktif olduğunda önce yalnızca `UXBPreHandleWebManifestDirective()` deneniyor, ardından aynı ortak `Select Case` yine çalışıyor. Dolayısıyla B ayrı bir önişlemci değildir; gerçekte ortak komut kümesine eklenen web/manifest komutlarıdır.

Bunun doğrudan sonucu: `%%FOREACH`, `%%FOR`, `%%IF`, `%%DEFINE`, `%%SET` vb. B seçiliyken de çalışır. `%%FOREACH` ana tarayıcıda A/B kontrolünün dışında uygulanmıştır. Buna karşılık `BUNDLE_NAME`, `API_ENDPOINT`, `GEN_FILE`, `HOST_IMPORT` gibi komutlar A modunda yapay olarak `META_NEEDS_PP_B` ile engellenmektedir. Bu asimetri artık yarardan çok kafa karıştırmaktadır.

Ayrıca blok taramada ikinci bir tarihsel katman oluşmuştur. Genel `UXBPreTryScanKnownBlock()` yalnız B aktifken çağrılır; fakat aynı kaynakta JS/WAT/WASM_HOST_JS/HTML/CSS için ayrıca elle yazılmış blok tarayıcıları vardır. JSON/MD/TEMPLATE/SECTION/GEN_BLOCK genel tarayıcıya bağlıyken bazı diğer bloklar iki ayrı yoldan ele alınmaktadır. Bu yapı sadeleştirilmelidir.

`preprocess_parser.fbs` içindeki `UXBPreParseIsUnimplementedCanonicalDirective()` hâlâ `EMBEDBASE64`, `GEN_BLOCK`, `GEN_END` komutlarını uygulanmamış saymaktadır. Oysa 23.09 kaynakta `EMBEDBASE64` için gerçek işleyici, `GEN_BLOCK/GEN_END` için de blok tarayıcı desteği vardır. Bu liste güncel değildir.

## 2. Karar: A/B komut kümeleri kaldırılmalı, önişlemci tekleştirilmeli

Kanonik model:

```text
                    HAM .UXB KAYNAK
                          |
                  Birleşik %% önişlemci
                          |
      DEFINE / IF / FOREACH / TEMPLATE / ASSET / WEB / GEN / ...
                          |
                    expandedSource
```

Bütün mevcut `%%` komutları aynı komut uzayında çalışmalıdır. `%%PP A` ve `%%PP B` eski kaynak uyumluluğu için kabul edilmeli fakat komut kullanılabilirliğini değiştirmemelidir.

Geçiş davranışı:

```basic
%%PP A   ' kabul edilir; eski uyumluluk, işlevsel etkisi yok
%%PP B   ' kabul edilir; eski uyumluluk, işlevsel etkisi yok
```

Tanı:

```text
PREPROCESSOR_PP_DEPRECATED_NO_EFFECT
```

İlk geçiş sürümünde bu yalnız bilgi/uyarı olabilir; derlemeyi bozmaz.

`--pp A` / `--pp B` ve `--preprocessor A|B` CLI seçenekleri de aynı şekilde geçici uyumluluk taklidi olmalıdır. Yeni belgelerde kullanılmamalıdır.

## 3. Mevcut %% komutları korunur

Ham `%%` söz dizimi önişlemci dilidir ve parser/AST/MIR'den önce çalışır:

```basic
%%DEFINE N 4
%%IF N > 0
%%FOREACH T IN "I32,F64"
FUNCTION Max_{{T}}(a AS {{T}}, b AS {{T}}) AS {{T}}
    IF a > b THEN RETURN a
    RETURN b
END FUNCTION
%%ENDFOREACH
%%ENDIF
```

Ayrım kalkınca eski B komutu ile birlikte de doğal biçimde çalışır:

```basic
%%FOREACH API IN "fish,water,feed"
%%API_ENDPOINT {{API}} GET "/api/{{API}}"
%%ENDFOREACH
```

Mevcut `FOREACH` uygulaması genişletilen gövdede tekrar `%%` görürse içeriği yeniden kaynak akışına sokmaktadır. Bu nedenle iç içe/üretilmiş direktifler mevcut mimaride zaten işlenebilmektedir. A/B engeli kaldırıldığında former-B komutları için de aynı mekanizma çalışır.

## 4. REM %% meta komutları: önişlemcinin yerine değil, derleme modelinin üzerine

Yeni `REM %%` komutları ham kaynak önişlemci komutu değildir. En temiz ve en az müdahaleci sıra şudur:

```text
1. PreprocessRun()                -> ham %% komutlarını işler
2. expandedSource
3. MetaScanExpandedSource()      -> REM %% meta satırlarını toplar
4. Lexer / Parser                -> AST
5. MetaBindAST()                 -> meta kaydını AST hedefiyle eşler
6. Semantic / type / layout      -> gerçek tip ve sembol bilgisi
7. MIRBuildModuleFromAST()
8. MetaBindMIR()                 -> meta kayıtlarını MIR'e indirger
9. MIR optimize / verify
10. canonical MIR bridge
11. MIR interpreter / x64 / JS / WAT-WASM
12. MetaEmitArtifacts()          -> manifest, bridge, docs, test listesi vb.
```

Meta taramasının `PreprocessRun()` sonrasında yapılması özellikle önemlidir. Böylece `%%FOREACH`, `%%IF`, `%%INCLUDE` veya makrolarla üretilen `REM %%...` satırları önce doğal biçimde çoğalır ve sonrasında oluşmuş gerçek kaynak üzerinde meta kaydı haline gelir. Ayrı bir yinelemeli meta-önişlemci yazmaya gerek kalmaz.

Örnek:

```basic
%%FOREACH T IN "I32,F64"
REM %%ATTR TEST
FUNCTION Test_{{T}}() AS BOOLEAN
    RETURN 1
END FUNCTION
%%ENDFOREACH
```

Önişlemci iki fonksiyon ve iki `REM %%ATTR TEST` satırı üretir. Meta tarayıcı bunları genişletilmiş kaynakta görür ve her biri doğru fonksiyona bağlanır.

## 5. REM %% dilini küçük tut

İlk sürüm için iki ana komut ailesi yeterlidir:

```basic
REM %%ATTR <ad> [argümanlar]
REM %%MIR  <politika> [değer]
```

`ATTR`, programın ne olduğunu tanımlar. Örnekler:

```basic
REM %%ATTR TEST
REM %%ATTR DEPRECATED "YeniHesapla kullan"
REM %%ATTR REFLECT
REM %%ATTR SERIALIZABLE
REM %%ATTR EXPORT JS
REM %%ATTR EXPORT WASM
REM %%ATTR ROUTE GET "/api/fish/{id}"
REM %%ATTR AUTHOR "Mete"
```

`MIR`, gerçekten MIR/arka uç davranışını etkileyen kayıtlar içindir. Burada hayali komutlar yaratılmamalıdır. 23.09 kaynakta MIR optimizasyonu esas olarak constant-fold ve dead-block geçişlerinden oluşuyor; gerçek bir inliner yoktur. Bu nedenle `REM %%MIR INLINE` gibi bir komut, gerçek tüketicisi yazılmadan "çalışıyor" sayılmamalıdır. Tanınan ama uygulanmayan MIR politikası fail-closed tanı vermelidir:

```text
META_MIR_POLICY_NOT_IMPLEMENTED
```

İlk sürümde MIR politika altyapısı kurulup yalnız gerçekten tüketicisi bulunan politikalar açılmalıdır.

## 6. PreprocessResult ile MetaRegistry ayrılmalı

Mevcut `PreprocessResult` doğru yerde duruyor. Parser/AST/MIR'den bağımsız olması kaynakta özellikle belirtilmiş ve bu korunmalıdır.

Önerilen yeni veri modeli:

```freebasic
Enum UXBMetaDirectiveKind
    UXB_META_ATTR = 1
    UXB_META_MIR  = 2
End Enum

Enum UXBMetaTargetKind
    UXB_META_TARGET_NEXT_DECL = 1
    UXB_META_TARGET_NEXT_STMT = 2
    UXB_META_TARGET_MODULE    = 3
End Enum

Type UXBMetaDirective
    kind As Integer
    nameText As String
    argsText As String

    sourceFile As String
    sourceLine As Integer
    sourceColumn As Integer

    targetKind As Integer
    targetAstNode As Integer
    targetMirKind As Integer
    targetMirIndex As Integer

    statusText As String
End Type

Type UXBMetaRegistry
    items(Any) As UXBMetaDirective
    count As Integer
    diagnostics(Any) As String
    diagnosticCount As Integer
End Type
```

ASTNode'a büyük bir metadata yapısı gömmek gerekmez. AST zaten `sourceFile`, `lineNo`, `family`, `kind`, `symbolName`, `typeName` gibi bağlama için yeterli veriye sahiptir. `MetaRegistry`, AST düğüm numarasını dışarıdan tutabilir. Böylece parser sözleşmesi gereksiz yere şişmez.

## 7. MIR gerçek merkez olmalı, ama hangi MIR?

23.09 kaynakta pratik olarak iki MIR temsili vardır:

- `src/semantic/mir_model.fbs` içindeki `MIRModule/MIRFunction/MIRIRInstruction`: x64, JS ve WASM üreticilerinin doğrudan kullandığı semantik MIR.
- `src/mir/*` canonical kayıtları: doğrulama, JSON ve canonical MIR yorumlayıcı tarafında kullanılır; `semantic_to_canonical_mir_bridge.fbs` semantik MIR'i canonical MIR'e çevirir.

Bu nedenle metadata yalnız canonical MIR'e eklenirse x64/JS/WASM görmez. Yalnız canonical yapıyı değiştirmek yanlış olur.

En düşük riskli çözüm, meta kayıtlarını **ortak semantik `MIRModule` içine** koymak ve canonical köprüde kopyalamaktır:

```freebasic
Type MIRMetaRecord
    targetKind As Integer       ' MODULE / FUNCTION / INSTRUCTION / TYPE
    targetIndex As Integer
    keyText As String
    valueText As String
    sourceFile As String
    sourceLine As Integer
End Type

Type MIRModule
    ' mevcut alanlar korunur
    ...
    metaRecords(Any) As MIRMetaRecord
    metaCount As Integer
End Type
```

Her attribute için `MIR_TEST`, `MIR_AUTHOR`, `MIR_SERIALIZABLE` gibi sahte opcode üretmek yanlış olur. Metadata veri olarak kalmalıdır. Ancak bir meta komutu gerçekten çalışma zamanı davranışı gerektirirse normal MIR instruction/runtime çağrısı üretebilir.

## 8. Dört motor/arka uç açısından tek sözleşme

`MIRModule` meta kaydı eklendiğinde x64, JS ve WASM zaten aynı `MIRModule` nesnesini tükettiği için ortak gerçeklik elde edilir. Canonical bridge aynı kayıtları canonical rapor/yorumlayıcı tarafına taşır. AST yorumlayıcı varsa semantik eşdeğerliği sınamak için referans motor olarak kalabilir; backend'e özgü export/manifest bilgisini kendi başına yeniden yorumlamamalıdır.

Örnek:

```basic
REM %%ATTR TEST
REM %%ATTR EXPORT JS
REM %%ATTR EXPORT WASM
FUNCTION Calculate(x AS F64) AS F64
    RETURN x * x
END FUNCTION
```

MIR tarafı kavramsal olarak:

```text
FUNCTION Calculate(F64) -> F64
  META TEST = TRUE
  META EXPORT.JS = TRUE
  META EXPORT.WASM = TRUE
  ...instructions...
```

JS ve WASM bu kayıtları aynı yerden okur. İmza metni kullanıcıdan tekrar istenmez; semantic/MIR'deki gerçek parametre ve dönüş tiplerinden türetilir. Böylece mevcut `%%EXPORT_BASIC foo AS "..."` hâlâ geriye uyumluluk için kalır, fakat yeni meta biçiminde çift kaynaklı imza hatası önlenir.

## 9. Eski B manifest sistemi atılmamalı; tüketici olarak kullanılmalı

`preprocess_web_manifest_commands.fbs` ve `preprocess_manifest_schema.fbs` içinde var olan manifest sözleşmesi, browser çalışma zamanı ve artifact üreticileri tarafından zaten kullanılıyor. Yeni meta sistemi bunu ikinci kez icat etmemelidir.

`REM %%ATTR EXPORT JS` veya `REM %%ATTR ROUTE GET "/x"` MIR'de çözümlendikten sonra `MetaEmitArtifacts()` mevcut manifest anahtarlarını üretmelidir. Böylece `ux_basic_runtime.js`, browser artifact üreticisi, `ux_wasm_bridge.js` ve `ux_localhost_bridge.js` değişmeden veya çok küçük uyarlamalarla kullanılabilir.

Native EXE-browser köprüsünde ilk hedef yeni WebSocket altyapısı yazmak değil, mevcut `ux_localhost_bridge.js` HTTP localhost köprüsünü kullanmaktır. WASM için mevcut `ux_wasm_bridge.js` zaten doğru başlangıç noktasıdır. Akış/olay gerektiren kullanım ortaya çıkarsa WebSocket daha sonra eklenebilir.

## 10. Kütüphane sistemiyle birleşme

`src/semantic/library_type_contract.fbs` zaten kütüphane tipleri için layout, size, alignment, fields ve ayrıca `mirPolicy`, `jsPolicy`, `wasmPolicy`, `nativePolicy` alanlarını tutmaktadır. Meta sistemi ikinci bir kütüphane tip tanım sistemi üretmemelidir.

Örneğin:

```basic
REM %%ATTR SERIALIZABLE
DIM x AS RATIONAL
```

veya reflect edilen bir library type söz konusu olduğunda meta çözümleyici `UXBLibraryTypeContract` içindeki gerçek layout/fields sözleşmesini sorgular. Tip `opaque` ise veya hedef policy `fail_closed` ise meta komutu bunu zorla aşamaz. Hedef desteği yoksa derleme açık hata verir. Bu, mevcut kütüphane güvenlik/fail-closed sözleşmesiyle uyumludur.

## 11. A/B'yi kaldırmak için gerçek kod değişiklikleri

İlk yama semantik değişikliği ile dosya taşıma/rename işini aynı anda yapmamalıdır. `PreproesssorB` yazım hatalı klasör adı ilk yamada yerinde bırakılabilir; fonksiyonları artık "B" olarak düşünülmez. Testler geçtikten sonra `preprocessor/artifact/` gibi bir klasöre taşınabilir.

İlk yama için değişiklik sırası:

| Aşama | Kaynak değişikliği | Sonuç |
|---|---|---|
| 1 | `LexerProcessDirective()` içinde `UXBPreHandleWebManifestDirective()` çağrısını A/B koşulundan çıkar | Eski B komutları her zaman kullanılabilir |
| 2 | `META_NEEDS_PP_B` yolunu kaldır | Tek komut uzayı |
| 3 | `UXBPreTryScanKnownBlock()` çağrısını A/B'den bağımsız yap | Bütün bloklar aynı scanner'dan geçer |
| 4 | JS/WAT/HTML/CSS için yinelenen özel scanner'ları genel scanner'a taşırken mevcut RAW_JS/WAT güvenlik istisnalarını koru | Tek blok motoru |
| 5 | `%%PP A/B` ve CLI `--pp` seçeneklerini uyumluluk no-op yap | Eski kaynak kırılmaz |
| 6 | `UXBPreParseIsUnimplementedCanonicalDirective()` stale kaydını düzelt | EMBEDBASE64/GEN_BLOCK/GEN_END yanlış tanısı biter |
| 7 | `MetaScanExpandedSource()` ve `MetaRegistry` ekle | REM %% meta satırları toplanır |
| 8 | AST sonrası `MetaBindAST()` ekle | Meta doğru sembol/statement'a bağlanır |
| 9 | `MIRModule.metaRecords()` + `MetaBindMIR()` ekle | Ortak backend sözleşmesi oluşur |
| 10 | canonical bridge ve browser manifest üretimine meta kopyası ekle | MIR yorumlayıcı + x64 + JS + WASM aynı metayı görür |

## 12. Çok önemli sınır: REM %% geçmişi sihirli biçimde değiştiremez

`REM %%` komutu AST/MIR oluştuktan sonra AST/MIR bilgisini okuyabilir ve manifest, belge, test listesi, serializer, bridge veya başka artifact üretebilir. Fakat MIR oluştuktan sonra kaynak geçmişine dönüp sınırsız biçimde program yapısını değiştirirse ikinci frontend geçişi gerekir ve döngüsel derleme riski doğar.

Bu nedenle ilk sistemde kesin sınır:

```text
ham %%      = programın kaynağını üretir/değiştirir
REM %%ATTR  = oluşan programı tanımlar
REM %%MIR   = MIR/backend politikasını verir
post-MIR    = bilgi okur ve artifact/manifest/glue üretir
```

AST/MIR bilgisinden yeni executable uXBasic kaynak üretip aynı derlemeye yeniden sokan kontrollü ikinci geçiş, ancak gerçek ihtiyaç ortaya çıkarsa ayrı özellik olarak eklenmelidir. İlk sürümde buna gerek yoktur.

## 13. Örnek birleşik kaynak

```basic
%%DEFINE APP_NAME "FishLab"
%%TARGET BROWSER
%%OUTDIR "dist"
%%BUNDLE_NAME {{APP_NAME}}

%%FOREACH T IN "I32,F64"
REM %%ATTR TEST
FUNCTION Test_{{T}}() AS BOOLEAN
    RETURN TRUE
END FUNCTION
%%ENDFOREACH

REM %%ATTR REFLECT
REM %%ATTR SERIALIZABLE
TYPE FishSample
    id AS I32
    weight AS F64
END TYPE

REM %%ATTR EXPORT JS
REM %%ATTR EXPORT WASM
FUNCTION Calculate(x AS F64) AS F64
    RETURN x * x
END FUNCTION

REM %%ATTR ROUTE GET "/api/fish/{id}"
FUNCTION GetFish(id AS I32) AS DICT
    DIM r AS DICT
    RETURN r
END FUNCTION

%%HTML_BEGIN "index.html" BODY
<div id="app"></div>
%%HTML_END

%%JS_BEGIN "app.js" RUNTIME
// hazır/elle yazılmış JS bölümü
%%JS_END
```

Burada A/B yoktur. `FOREACH` web/manifest komutlarıyla aynı sistemde çalışır. `REM %%` satırları önişlemci genişlemesinden sonra toplanır. Export/route imzaları semantic/MIR bilgisinden çözülür. HTML/JS blokları mevcut artifact sistemiyle devam eder.

## 14. Son mimari

```text
                              .UXB
                               |
                 +-------------+-------------+
                 |                           |
             ham %%                       REM %%
                 |                           |
        BİRLEŞİK PREPROCESSOR          Meta scanner
                 |                           |
         expandedSource --------------------+
                 |
               Lexer
                 |
              Parser
                 |
                AST <------ MetaBindAST
                 |
       Semantic / type / layout / library contracts
                 |
                MIR <------ MetaBindMIR
                 |
       +---------+----------+----------+
       |         |          |          |
   MIR yorum   x64         JS       WAT/WASM
       |         |          |          |
       +---------+----------+----------+
                 |
          MetaEmitArtifacts
                 |
     manifest / HTML / CSS / JS / bridge /
     reflection JSON / test manifest / docs
```

Bu yapı yeni bir dilin üstüne yeni bir dil kurmaz. Mevcut önişlemciyi korur, A/B tarihsel ayrımını kaldırır, REM yorum satırlarını güvenli bir meta taşıyıcı yapar ve uXBasic'in zaten merkezileştirmeye çalıştığı MIR sözleşmesini gerçekten ortak merkez haline getirir.

## 15. Uygulama kapıları

Yama tamamlandı sayılmadan şu testler geçmelidir: eski raw `%%` testleri değişmeden PASS; `%%PP A` ve `%%PP B` aynı çıktıyı üretmeli; `%%FOREACH` içinde eski-B komutları çalışmalı; bütün blok tipleri PP seçmeden taranmalı; `REM %%ATTR` FOREACH/INCLUDE sonrasında doğru AST düğümüne bağlanmalı; aynı meta kaydı semantic MIR ve canonical MIR raporlarında görülmeli; JS/WASM/x64 export kararları aynı kaynaktan gelmeli; library target policy `fail_closed` ise meta bunun üzerinden atlayamamalı; eski browser manifest ve localhost/WASM bridge testleri bozulmamalıdır.

