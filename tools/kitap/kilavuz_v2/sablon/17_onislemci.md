# 17. Önişlemci: derlemeden önce kaynağı yazan dil

Bu bölüm, `%%` ile başlayan **önişlemci yönergelerini** anlatır. Derleyici programınızı okumadan önce bu satırları çalıştırır; geriye düz bir uXBasic metni kalır.
Yani önişlemci, **programı yazan program**dır: makro açar, koşula göre satır siler, aynı gövdeyi tipler üzerinde çoğaltır, dış dosyadan veri içeri alır.

> **Bu bölümdeki her durum çalıştırılarak bulunmuştur.** Kaynak koddaki 125 yönergenin her biri `bin\uxb_kilavuz_20261007.exe` ile sınanmış (2026-10-08), sonuç Ek C'ye ve Ek G'ye (G-ONISLEM-1 … 20) yazılmıştır; önişlemci çıktısı ayrıca `bin\uxb_kilavuz_20261014_0253.exe` ile 296 külliyat vakasında yeniden üretilmiştir: genişletilmiş kaynak her vakada aynıdır; yalnız 6 vakada çıkış kodu 0'dan 1'e döner, çünkü genişletilmiş kaynak parantezsiz çağrı içerir ve `lex` aşaması onu `UXB_CALL_PAREN_REQUIRED` ile reddeder (S-440, Ek K.5).
> Etiketler: ✔ çalışıyor · ◐ kısmi · ◌ kayıt (kabul edilir, çıktıyı değiştirmez) · ✖ eksik.

## 17.1 Önişlemci nerede çalışır?

```text
  .uxb kaynağı  →  ÖNİŞLEMCİ (%% satırları)  →  sözcük çözümleyici  →  ayrıştırıcı  →  AST → MIR → x64 / JS / WAT-WASM
                         ↑                                                                   
          bu bölümün konusu: burada metin yazılır, hedef henüz bilinmez
```

* Önişlemci **hedeften bağımsızdır**: aynı genişletilmiş metin AST, MIR, x64, JS ve WAT-WASM hattına gider. Bu bölümdeki örneklerin hepsi AST, MIR, x64 ve JS'te aynı çıktıyı verir
  (WASM'da yalnız metin yazdırmayan örnekler çalışır; sebep önişlemci değil, WASM'ın metin desteğinin olmamasıdır, Bölüm 21).
* Önişlemci **metin düzeyinde** çalışır; uXBasic'in tiplerini, işlevlerini bilmez. Ürettiği metin sonradan normal kurallara göre denetlenir.
  Bu yüzden önişlemcinin yaptığı hata, çoğu zaman bir sonraki aşamada başka bir iletiyle (örn. `unknown symbol`) görünür.
* Önişlemcinin ne ürettiğini görmek için:

```bash
uxb lex program.uxb --preprocessed-out genisletilmis.txt
```

`genisletilmis.txt` dosyasında hiçbir `%%` satırı kalmaz. Bir makro ya da döngü beklediğiniz gibi çalışmıyorsa **ilk bakılacak yer** burasıdır.

## 17.2 Genel kurallar

| Kural | Açıklama |
|---|---|
| Yönerge satırın başında yazılır | `%%DEFINE ...`; önünde boşluk olabilir. Satırın ortasında yönerge olmaz |
| Yönerge adı büyük/küçük harf duyarsızdır | `%%define`, `%%Define`, `%%DEFINE` aynıdır; makro adları da öyle |
| Yorum ve metin sabiti içinde etkisizdir | `REM %%DEFINE X 1`, `' %%DEFINE X 1` ve `"%%DEFINE X 1"` yönerge **değildir** |
| Yönerge **tek satırdır** | `_` ile satır devamı yönergede çalışmaz; satır sonuna `'` yorumu da yazmayın, yorum makro değerine girer (G-ONISLEM-20) |
| Makro yalnız **bütün sözcük** olarak değişir | `N` makrosu `NN` ya da `N1` içinde değişmez; metin sabitinin içinde de değişmez (`"merhaba AD"`) |
| Makrolar tek geçişte açılır | Makro değerinin ya da gövdesinin içindeki başka makro adı açılmaz (G-ONISLEM-9) |
| Her dosya kendi makro tablosuyla işlenir | `INCLUDE` ile katılan dosya katanın makrosunu görmez, tersi de geçerlidir (G-ONISLEM-19) |
| Üretilen `%%` satırı yeniden işlenir | `%%FOREACH` gövdesi `%%DEFINE`, `%%IF`, `%%INCLUDE` ya da iç içe döngü üretirse bunlar da çalışır |
| Bilinmeyen yönerge **hatadır** | `META_UNKNOWN_DIRECTIVE: AD` ile derleme durur; yanlış yazılan ad sessizce geçmez |

## 17.3 İki komut kümesi: A ve B

Bugünkü derleyicide yönergeler iki kümeye ayrılmıştır (G-ONISLEM-15):

| Küme | İçerik | Nasıl açılır? |
|---|---|---|
| **A** (varsayılan) | Makro, koşul, döngü, dosya katma, derleme denetimi, HTML/CSS/JS/WAT blokları, varlık kayıtları | Her zaman açıktır |
| **B** | Paket ve tarayıcı bildirimleri (`%%BUNDLE_NAME` …), `GEN_BLOCK`, ayrıca `JSON_BEGIN`, `MD_BEGIN`, `WAT_FUNC_BEGIN`, `TEMPLATE_BEGIN`, `SECTION` blokları | Dosyada `%%PP B` yazmak ya da komut satırında `--pp B` |

* B yönergesini `%%PP B` olmadan yazarsanız derleme `META_NEEDS_PP_B` ile durur (sessiz geçmez).
* `%%PP A` hiçbir şeyi değiştirmez; yalnızca açıklayıcıdır.
* B'de de A'nın bütün yönergeleri çalışır; B yalnız **ekleme** yapar.
* **◇ HEDEF (tasarım kararı):** A/B ayrımı kalkacak, bütün yönergeler tek komut uzayında çalışacak; `%%PP A/B` ve `--pp` eski kaynaklar bozulmasın diye kabul edilip etkisiz bırakılacak.
  Bu yüzden **yeni kaynak yazarken** `%%PP B`'yi yalnız gerçekten B yönergesi kullanıyorsanız yazın.

## 17.4 Tanımlar ve makrolar

Makro, bir adı başka bir metinle **yer değiştirme** işlemidir. Önişlemcinin en temel aracıdır.

| Yönerge | Ne yapar? | Ne zaman seçilir? |
|---|---|---|
| `%%DEFINE AD değer` | Makro tanımlar; değer yazılmazsa `1` olur | Sabit, bayrak, küçük metin parçası |
| `%%SET AD = değer` | `DEFINE` ile aynı etki, `=` ile yazılır | Ayar benzeri değerler (okunaklılık için) |
| `%%MACRO AD(p1, p2) gövde` | Parametreli makro | Kısa ifade kalıpları |
| `%%UNDEF AD` | Makroyu siler | Belirli bir noktadan sonra adı serbest bırakmak |
| `%%ALIAS {eski} AS {yeni}` | Bir sözcüğü başka sözcüğe eşler | Anahtar sözcüğe ikinci ad vermek; döngü yaratan eşleme hata verir |
| `%%EVAL AD = değer` | Sayı sabitini ya da makro değerini kopyalar (◐ hesap yapmaz, G-ONISLEM-10) | Bir makronun değerini yeni ada kopyalamak |
| `%%ENV "ORTAM" AS AD` | Ortam değişkenini makro yapar | Derleme makinesinin ayarını okumak |

Önemli ayrımlar:

* **Fonksiyon değil, metin:** makro çalışma anında çağrılan bir işlev değildir; kaynağa **harfi harfine** yerleşir. Bu yüzden işlem önceliği korunmaz:

{{ORNEK:60_kv_onislemci/makro_parantez_tuzagi|baslik=Parantezsiz makro işlem önceliğini bozar}}

* **`DEFINE` değeri ve tırnak:** değerin başındaki ve sonundaki çift tırnak atılır (G-ONISLEM-8). Metin sabiti istiyorsanız değeri parantez içine alın:

{{ORNEK:60_kv_onislemci/metin_makro|baslik=Metin değerli makro}}

* **Makro içinde makro yok (G-ONISLEM-9):** `%%DEFINE B A` yazıp `B`'yi kullanırsanız `A` olarak kalır. İhtiyacınız varsa değeri doğrudan yazın ya da `%%FOREACH` ile üretin.

{{ORNEK:60_kv_onislemci/define_makro_if|baslik=DEFINE, MACRO ve IF bir arada}}

## 17.5 Koşullu derleme

Koşul yönergeleri, seçilmeyen kolu **derleyiciye hiç göstermez**; yani o kolda yazılan kodun doğru olması bile gerekmez.

| Yönerge | Neyi karşılaştırır? | Bilinmesi gereken |
|---|---|---|
| `%%IF koşul` | Doğruluk ve **eşitlik** | Yalnız şunlar: `TRUE`, `FALSE`, sayı, makro adı (değeri 0 değilse doğru), `a == b`, `a != b`, `a <> b`, `a = b` |
| `%%IFN a işleç b` | **Sayıları** | `==`, `!=`, `<`, `<=`, `>`, `>=` ya da tek değer. Adı "değil" demek **değildir**; "sayısal if" demektir |
| `%%IFC a, b` | İki **metni** | Makroysa değerini alır, büyük/küçük harf farkı yoktur, virgül tam bir tane olmalıdır |
| `%%ELIF koşul` | Hem sayı hem metin | Sayılar `IFN` gibi, metinler `==`/`!=` ile karşılaştırılır |
| `%%ELSE`, `%%ENDIF` | — | Her `%%IF` bir `%%ENDIF` ile kapanmalıdır (eksikliği sessizce geçer, G-ONISLEM-3) |

**En büyük tuzak (G-ONISLEM-1):** `%%IF W >= 640` ya da `%%IF A AND B` ya da `%%IF NOT A` hata vermez; koşul **sessizce yanlış** sayılır.
`%%IF`'in bildiği biçimler yukarıda yazılanlardan ibarettir. Büyüktür/küçüktür için `%%IFN`, "ve" için iç içe `%%IF`, "değil" için `%%ELSE` kullanın.
`%%ASSERT_META` da aynı zayıf değerlendiriciyi kullandığından orada da yalnız eşitlik yazın.

{{ORNEK:60_kv_onislemci/ifn_ifc_elif|baslik=IFN, IFC ve ELIF}}

| Benzer ikili | Fark |
|---|---|
| `%%IF` ve `%%IFN` | `IF` eşitlik/doğruluk; `IFN` sayı karşılaştırması |
| `%%IFC` ve `%%IF a == b` | `IFC` her iki tarafı makro olarak çözer ve tam olarak bir virgül ister; `IF a == b` tek işleçle aynı işi görür |
| `%%IFN` ve `%%ELIF` | `ELIF` zincirin ortasında hem sayıyı hem metni sınar; `IFN` zinciri **başlatır** |

## 17.6 Döngüler ve kod üretimi

Döngüler, bir gövdeyi **metin olarak çoğaltır**. Çalışma anında hiçbir döngü kalmaz; sonuç, el ile uzun uzun yazılmış gibi görünür.

| Yönerge | Biçim | Değişken | Sınır |
|---|---|---|---|
| `%%FOR` … `%%ENDFOR` | `%%FOR K = 1 TO 10 [STEP 2]` | `{{K}}` | En çok 100 000 tur; adım 0 olamaz |
| `%%FOREACH` … `%%ENDFOREACH` | `%%FOREACH AD IN (a, b, c)` | `{{AD}}` | Liste parantezli ve virgüllüdür (G-ONISLEM-11) |
| `%%REPEAT n` … `%%ENDREPEAT` | `%%REPEAT 5` | `{{INDEX}}` (1'den) | En çok 100 000 |
| `%%BREAK` / `%%CONTINUE` | Gövdede tek başına satırda | — | Döngü dışında hata verir |

* **Döngü değişkenini her zaman `{{AD}}` ile yazın (G-ONISLEM-2).** `%%K` biçimi de çalışır, ama değişken adı bir yönergenin başıyla çakışırsa (örn. `I` → `%%IF`) o yönergeyi bozar.
* İç içe döngü ve döngünün içinde `%%IF`, `%%DEFINE`, `%%MACRO`, `%%INCLUDE` yazılabilir; üretilen satırlar yeniden işlenir.
* Büyük döngüler çok yavaştır (G-ONISLEM-12): 2 000 tur yaklaşık 2 saniye sürer. Büyük tabloları çalışma anında doldurun.
* `%%NEXTMETA` ve `%%UNTILMETA` tanınan ama işlevi olmayan adlardır; kullanmayın.

{{ORNEK:60_kv_onislemci/for_repeat_uret|baslik=FOR, REPEAT ve iç içe FOREACH}}

**Orta düzey kullanım: tablo üretmek.** uXBasic'te dizi ilk değer listesi yoktur (Bölüm 10). Önişlemci, her eleman için bir atama satırı yazarak aynı işi görür:

{{ORNEK:60_kv_onislemci/tablo_uret_for|baslik=Derleme anında kareler tablosu}}

**Orta düzey kullanım: tip başına işlev üretmek.** uXBasic'te aşırı yükleme yoktur (G-YORDAM-1) ve genel (şablon) işlev de yoktur. `%%FOREACH`, aynı gövdeyi her tip için yeniden yazarak şablon etkisi verir:

{{ORNEK:60_kv_onislemci/foreach_tip_uret|baslik=Her tip için ayrı Buyuk işlevi}}

**Üst düzey kullanım: komut tablosu.** Tek bir listeden hem işlevlerin çağrıldığı `SELECT CASE` hem de kullanıcıya gösterilen komut adları üretilir; yeni komut eklemek için listeye ad eklemek yeter:

{{ORNEK:60_kv_onislemci/uretilen_komut_tablosu|baslik=Üretilen dağıtım tablosu}}

## 17.7 Dosya katma ve dış veri

| Yönerge | Katar / okur | Yol nereye göre? |
|---|---|---|
| `INCLUDE "x.uxb"` (düz) | Başka bir kaynak dosyasını yerine yapıştırır | Katan dosyanın klasörü, bulunamazsa üst klasörler |
| `%%INCLUDE "x.uxbh"` | Başlık dosyasını (`.uxbh`, `.uxmh`) yapıştırır | Aynı |
| `%%CONFIG_FILE "yol"` | `ANAHTAR=DEĞER` satırlarını makro yapar | **Çalışma klasörü** |
| `%%EMBEDTEXT "yol" AS AD` | Dosyanın metnini makro yapar | **Çalışma klasörü** |
| `%%EMBEDBASE64 "yol" AS AD` | Dosyayı base64 metni olarak makro yapar | **Çalışma klasörü** |
| `%%HASHFILE "yol" AS AD` | Dosyanın FNV-1a sağlama değerini (onaltılık) makro yapar | **Çalışma klasörü** |
| `%%ENV "ORTAM" AS AD` | Ortam değişkenini makro yapar | — |

* `INCLUDE` **bir kez** katar: aynı dosyayı ikinci kez katarsanız atlanır. Dosyalar birbirini katarsa `LEX_INCLUDE_CYCLE` hatası verilir. `..` ve mutlak yollar `LEX_UNSAFE_INCLUDE_PATH` ile reddedilir.
* `%%INCLUDE` `.uxb`/`.bas` dosyası almaz; verirseniz (ya da dosya yoksa) ileti `LEX_INCLUDE_UNSUPPORTED_SOURCE` olur ve nedeni anlatmaz. Başlıklar için `%%INCLUDE "x.uxbh"`, kaynak için düz `INCLUDE "x.uxb"` yazın (G-ONISLEM-13).
* **Yol tutarsızlığı (G-ONISLEM-13):** `INCLUDE` kaynağa göre, `CONFIG_FILE`/`EMBEDTEXT`/`EMBEDBASE64`/`HASHFILE` çalışma klasörüne göre çözülür. Dış veri okuyan programı **proje kökünden** derleyin.
* `%%CONFIG_FILE` dosya yoksa derlemeyi **durdurmaz** (G-ONISLEM-4). Ardından `%%IFN anahtar >= 1` ile gelip gelmediğini sınayın ve gelmediyse `%%ERRORENDCOMP` ile durdurun.
* `%%PATH_ALIAS` takma yolu kaydeder ama `INCLUDE` bunu kullanmaz (G-ONISLEM-6).

{{ORNEK:60_kv_onislemci/include_baslik|baslik=INCLUDE: aynı dosyayı iki kez katmak}}

{{ORNEK:60_kv_onislemci/hashfile_embed_config|baslik=CONFIG_FILE ve EMBEDTEXT ile dış değer}}

## 17.8 Derleme anı denetimleri

| Yönerge | Davranış |
|---|---|
| `%%ASSERT_META koşul, "ileti"` | Koşul yanlışsa derleme `PREPROCESSOR_ASSERT_META_FAILED` ile durur (koşul `%%IF` kuralları ile değerlendirilir) |
| `%%PLATFORM WINDOWS` | Derleyicinin çalıştığı işletim sistemi uyuşmazsa hata verir; `PLATFORM` makrosunu kurar |
| `%%ENDCOMP` | Bu satırdan sonrasını derlemeye hiç almaz |
| `%%ERRORENDCOMP "ileti"` | Derlemeyi hata ile durdurur |
| `%%LOCK_META AD` | Makroyu kilitler; ihlal yalnız tanı listesine yazılır, derleme sürer (G-ONISLEM-5) |
| `%%WARN_META`, `%%INFOMETA` | İleti önişlemci tanı listesine yazılır; terminalde görünmez (G-ONISLEM-17) |
| `%%PROFILE ad`, `%%DESTOS ad` | `PROFILE` ve `DESTOS` makrolarını kurar |
| `%%NOZEROVARS`, `%%SECSTACK` | Yalnız makro kurar; derleyici davranışını değiştirdiği gözlenmedi (G-ONISLEM-17) |
| `%%DUMP_META "dosya.json"` | Önişlemci sonuç özetini dosyaya yazar |

{{ORNEK:60_kv_onislemci/kosul_assert_endcomp|baslik=ASSERT_META, PLATFORM ve ENDCOMP}}

## 17.9 Web, paket ve varlık yönergeleri

Bu yönergeler tarayıcı çıktısı (`uxb jsw --emit-browser`) için hazırlanmıştır. **Gerçek durum**, "kabul edilen" ile "çıktıyı değiştiren" ayrımıyla şöyledir:

| Grup | Çalışan | Yalnız kaydedilen |
|---|---|---|
| HTML/CSS/JS blokları | `HTML_BEGIN`, `CSS_BEGIN`, `JS_BEGIN`, `WASM_HOST_JS_BEGIN`, `HTML_LINE`, `CSS_LINE`, `JS_LINE`, `CSS_RULE`, `CSS_IMPORT`, `HTMLIMAGE`, `HTMLAUDIO`: satırlar tarayıcı kabuğuna (`--html-out` dosyasına) yazılır | `WAT_BEGIN`, `JSON_SET`, `WAT_EXPORT`, `EMITNOTE` (G-ONISLEM-17) |
| Üretilen dosya | `GEN_BLOCK` … `GEN_END` (B): blok içeriği verilen yola yazılır, aynı dosyaya düşen bloklar sırayla birleşir | `GEN_FILE` |
| Varlık | `REQUIRE_ASSET` (B): tarayıcı manifestindeki `preprocess_assets` listesine yazılır | `ASSET_*`, `COPY_DIR`, `LICENSEFILE`, `MANIFEST_*`, `MINIFY`, `FINGERPRINT_ASSETS`, `OUTDIR`, `ASSET_ROOT` (G-ONISLEM-6, G-ONISLEM-18) |
| Paket ve tarayıcı bildirimi (B) | `SANDBOX_ROOT` vb. **yol güvenliğini** denetler; `EXPORT_BASIC`, `HOST_IMPORT` söz dizimini denetler | `BUNDLE_*`, `AUTHOR`, `CSP`, `CAPABILITY`, `ROUTE`, `API_ENDPOINT`, `FEATURE` … hiçbir çıktıya yazılmaz (G-ONISLEM-14) |
| Güvenlik kapıları | `ALLOW_RAW_JS`, `ALLOW_RAW_WAT`, `SAFE_PATHS`, `REQUIRE_HOST_BINDING`: ham JS/WAT ve yol kaçışı kapalı gelir | — |

Güvenlik kuralları sessiz geçmez:

| İstek | Sonuç |
|---|---|
| `%%JS_BEGIN` bloğu, izin vermeden | `RAW_JS_PAYLOAD_NOT_ALLOWED_FOR_TARGET` |
| `%%TARGET WEB` + `%%JS_BEGIN "x.js" RUNTIME` | İzinli (kontrollü çalışma zamanı bloğu) |
| `%%ASSET_COPY "../x.txt", "x.txt"` | `%%ASSET_* path escape blocked by SAFE_PATHS` (kapatmak için `%%SAFE_PATHS OFF`). Kaynak ve hedef **virgülle** ayrılır; boşlukla yazılırsa (`"a" "b"`) iki yol tek kaynak gibi okunur ve hata verilmez (G-ONISLEM-7) |
| `%%WAT_IMPORT "env", "bilinmeyen", ...` | `WAT_IMPORT_BINDING_MISSING` (kapatmak için `%%REQUIRE_HOST_BINDING OFF`) |
| `%%SANDBOX_ROOT "../disari"` (B) | `PREPROCESSOR_B_DIRECTIVE_FAILED` |
| `%%EMBEDTEXT "../disari.txt" AS X` | `EMBEDTEXT source path is unsafe` |

Blok gövdesindeki `{{AD}}` makroları **açılmaz** (G-ONISLEM-16); `%%SET TITLE = "Demo"` yazıp bloğa `{{TITLE}}` koyarsanız çıktıda `{{TITLE}}` aynen kalır.
Tarayıcı kabuğu üretmenin tam kullanımı Bölüm 21'dedir.

## 17.10 Yönergeler birbirini besler

Önişlemcinin gücü, yönergelerin **çıktısını birbirine girdi** yapmaktan gelir. Aşağıdakiler hepsi çalıştırılarak doğrulanmıştır:

| Önce çalışan | Sonra kullanan | Ne elde edilir? |
|---|---|---|
| `%%FOREACH` | `%%DEFINE` | Döngünün son değeri makro olarak kalır |
| `%%FOREACH` | `%%MACRO KATLA{{N}}(X) …` | Makro **adı** üretilir (`KATLA2`, `KATLA3`) |
| `%%FOREACH` | `%%INCLUDE "gov{{N}}.uxbh"` | Dosya adı döngüyle üretilir |
| `%%FOREACH` | `%%IFN {{N}} >= 3` | Döngü değerine göre satır seçilir |
| `%%FOR` | `%%FOREACH` (ve tersi) | İç içe üretim |
| `%%CONFIG_FILE` | `%%IFN SURUM >= 3` | Ayar dosyası derlenen kodu belirler |
| `%%EMBEDTEXT` | kaynak kodu | Dosya içeriği doğrudan koda girer |
| `%%ENV` | kaynak kodu | Derleme makinesinin değeri koda girer |
| `%%HASHFILE` | `%%IFC` | Dosyanın değişip değişmediği derleme anında sınanır |
| `%%INCLUDE` | `%%DEFINE` | ✖ makro dosya sınırını aşmaz (G-ONISLEM-19) |
| `%%DEFINE` | `%%DEFINE` / `%%MACRO` | ✖ makro içinde makro açılmaz (G-ONISLEM-9) |

Önişlemci ayrıca **dilin bütün ögelerini** üretebilir; çünkü ürettiği şey düz kaynak metnidir: `FUNCTION`, `SUB`, `TYPE`, `CLASS`, `THREAD`, `EVENT`, `SELECT CASE` kolları, dizi atamaları, `CONST` satırları. Bölüm 22'de bunun daha büyük örnekleri vardır
(örneğin `%%FOREACH` ile üretilen `THREAD`'ler, ana programda `SPAWN` ile başlatılır).

### Tasarımda olup bugün olmayan yönergeler (◇ HEDEF)

Tasarım belgelerinde geçen ama kaynağın 125 yönergelik kanonik listesinde **bulunmayan** yönergeler vardır. Bunlardan biri yazılırsa önişlemci **kapalı başarısızlıkla** durur (`META_UNKNOWN_DIRECTIVE: ADI`, çıkış 2); yani sessiz yanlış yoktur, ama özellik de yoktur:

| Yönerge ailesi | Tasarımdaki amacı | Kayıt |
|---|---|---|
| `%%DERIVE JSON, EQ, HASH FOR T`, `%%GENERATE REST_HANDLERS`, `%%GENERATE_SERIALIZER`, `%%GEN_SOURCE_BEGIN/END`, `%%GEN_FUNCTION`, `%%FUNCTION_META`, `%%FOREACH_FIELD` | Üretici (generator) kayıt defteri: kayıttan işleyici, serileştirici, eşitlik, özet işlevleri üretmek; tip alanları üzerinde dolaşmak | G-HEDEF-15 |
| `%%GEN_BLOCK SOURCE` (üretileni **derlenen kaynağa** eklemek) | Bugün `%%GEN_BLOCK` yalnız dosyaya yazar | G-HEDEF-15 |
| `%%BRIDGE_BEGIN/HOST/PORT/TRANSPORT/PROTOCOL/END` | Yerel EXE ↔ tarayıcı köprüsünü bildirmek | G-HEDEF-16 |
| `%%PATCH_BLOCK/PATCH_END/PATCH_FILE/PATCH_REPLACE/PATCH_PREPEND/PATCH_APPEND` | Üretilen dosyalara kontrollü yama | G-HEDEF-16 |
| `%%USE`, `%%POST`, `%%TEMPLATE_APPLY`, `%%TEMPLATE_PARAM`, `%%TEMPLATE_FILE`, `%%DATA_SCHEMA/IMPORT/EXPORT/FORMAT` | Şablon uygulama, sonradan işleme ve veri şeması | G-HEDEF-16 |
| `%%PYTHON_EXEC` | **Hiç konmayacaktır**: rastgele işletim sistemi komutu, tekrarlanabilirliği ve JS/WASM paketlemeyi bozar | — |

`%%PP A` / `%%PP B` ayrımının kaldırılması da tasarımdır (S-136): tüm yönergeler tek komut uzayında çalışacak, `%%PP A|B` ve `--pp` yalnız eski kaynak uyumluluğu için kabul edilip `PREPROCESSOR_PP_DEPRECATED_NO_EFFECT` bilgisi verecek (G-ONISLEM-15).

## 17.11 Önişlemci ile ilgili programlama kararları

* Seçilmeyen kola ihtiyaç yoksa çalışma anında `IF` yazmayın; `%%IF` ile **derleme anında** eleyin (kod küçülür, hata kolu hiç derlenmez).
* Büyüktür/küçüktür gereken her yerde `%%IFN` kullanın; `%%IF`'te yalnız eşitlik yazın.
* Makro gövdesini ve parametrelerini **parantez içine alın**: `%%MACRO KARE(X) ((X) * (X))`.
* Döngü değişkenini `{{AD}}` ile yazın; yönerge adlarıyla çakışmayan, uzun ve açık adlar seçin.
* Dış veri okuyorsanız `%%CONFIG_FILE` sonrasında beklenen anahtarın geldiğini **kendiniz sınayın**.
* Aynı kodu birden çok tip için yazmak gerekiyorsa elle kopyalamayın; `%%FOREACH` ile üretin.
* Yönerge satırına yorum yazmayın; yorumu ayrı satıra koyun.
* Üretilen metni gözle denetlemek için `--preprocessed-out` kullanın.
* A/B ayrımına güvenmeyin: yalnız B yönergesi kullanıyorsanız dosyanın başına `%%PP B` yazın.
