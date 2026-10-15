Önce kaynak dosyaları paralel olarak inceleyip her birinden kitap yazımı için gerekli olan komut/fonksiyon/işleç/tip/sözdizimi ve örnek kod bloklarını çıkaracağım. Bu sayede yazdığım her satırı kaynakla doğrulayabilirim.
# Programcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek

---

## BÖLÜM 1: ÖNSÖZ VE GİRİŞ

### 1.1 Önsöz

uXBasic, 30 yıllık bir mirası (UltraBasic/ubasic031) alıp Windows 11 x64 mimarisine taşıyan bir köprü projesidir. Bu kitap, derleyicinin nasıl çalıştığını, metni nasıl anladığını ve işlemciye nasıl talimat verdiğini anlatan nihai teknik otoritedir.

### 1.2 Teşekkür

Gabriel Fernandez ve Angelo Rosina'nın ve Adam Dunkels, Chuck Peddle & Bill Mensch, Steve Wozniak, Hans Bezemer (TheBeez), Tomasz "Tebe" Berezowski, Ullrich von Bassewitz, Richard Russell, David Given, Marcin Lewczuk, Jyrki Yli-Nokari, Csaba Fekete, Nicolaas v. d. Wetering, Paul Nicholls, David Simons, Lee Davison, Garry Kitchen, Peter Liepa & Chris Gray, Bob Yannes, Scott Adams, Kent Sullivan, Jim Butterfield, Robert Zimmerman & J. Reimer, Daniel S. Fandrich, Craig Bruce, Jim Lawless, Al Arduengo, Linus Åkerlund, Edward R. Rankin, Volker Sasse, Ron Cain & J. E. Hendrix, Don Harrison, Dennis Ritchie & Ken Thompson ve daha nicelerinin attığı fikirler ve temeller, bugünkü modernizasyonun yakıtıdır. Onların kısıtlı imkanlarla yazdığı ASM rutinleri, bugün uXBasic'in hız çekirdeğini oluşturmaktadır.

### 1.3 Kitap Kimin İçin?

Bu kitap, 17–25 yaş aralığında, programcılığa yeni başlayan bir insanın uXBasic diliyle programlamayı öğrenebileceği şekilde yazıldı. Temel kavramlar kısa: bir ya da iki cümle ile ve birkaç satır kodla verilir. İleri tekniklerde ise her satır tek tek açıklanır; programın nasıl çalıştığı, sonucun nasıl üretildiği adım adım gösterilir.

Bu kitabı okurken bir kuralı benimse: her örneği önce gözünle tara, sonra kafanda çalıştır, sonra bir satırını değiştirip ne olacağını tahmin et. Programlama, sonunda yaptığın her tahminin bilgisayar tarafından doğrulandığı veya yalanlandığı bir deney alanıdır.

### 1.4 uXBasic Nedir?

uXBasic (Universal eXtended BASIC), BASIC dilinin sade okunurluğunu sistem programlama hedefleriyle birleştiren bir derleyici ailesidir. Aynı kaynak dosyasından konsol programı, JavaScript, WebAssembly (WAT/WASM) ve x64/x86 assembly çıktısı üretir. DLL çağırır, C/C++/ASM dosyalarını derleme zincirine dahil eder, yerel ve bulut yapay zekâ servisleriyle konuşur.

Aşağıdaki küçük programın tamamı budur: beş komut, beş fikir.

```uxbasic
MAIN
    PRINT "Merhaba uXBasic"
    DIM yas AS I32
    INPUT yas
    IF yas >= 18 THEN
        PRINT "Kendi aracini yazmaya baslayabilirsin"
    ELSE
        PRINT "Once bol bol kucuk alistirma yap"
    END IF
END MAIN
```

Burada `MAIN` programın başlangıç yerini gösterir, `PRINT` ekrana yazar, `DIM` değişken ayırır, `INPUT` kullanıcıdan değer alır, `IF` karar verir. Beş komut birlikte küçük ama gerçek bir program kurar: kullanıcıdan veri alınır, veri saklanır, koşul hesaplanır ve sonuç ekrana bildirilir.

### 1.5 Lisans ve Sorumluluk

uXBasic kaynakları ve bu kitap MIT lisansı anlayışıyla hazırlanmıştır. MIT lisansı kısaca şudur: kodu kullanabilir, kopyalayabilir, değiştirebilir, yayımlayabilir, özel veya ticari projelerde kullanabilirsin; ancak lisans metnini korumalısın. Yazılım ve belge **olduğu gibi** sunulur. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, dış kütüphane hatası, API masrafı veya sistem hasarından belge yazarı sorumlu tutulamaz.

Gerçek cihaz, para, sağlık, resmi işlem, güvenlik veya üretim hattı içeren işlerde önce küçük test yap. Derleyici doğru çalışsa bile yanlış veri, yanlış hedef veya yanlış API anahtarı sonucu bozabilir. Genç programcının ilk meslek kuralı budur: **çalıştırmadan önce yedek al, dağıtmadan önce test et, hata olursa hangi dosyaya bakacağını bil.**

### 1.6 Kitabın Bölüm Düzeni

| Bölüm | Konu |
| --- | --- |
| 1 | Önsöz, giriş, lisans, bölüm düzeni |
| 2 | İlk programlar, dosya uzantıları, mimari katmanlar |
| 3 | Ön-işleyici (preprocessor) |
| 4 | Veri tipleri |
| 5 | Değişkenler ve veri yapıları |
| 6 | İşleçler (operators) |
| 7 | Komutlar — Akış ve karar |
| 8 | Komutlar — Girdi, çıktı, ekran ve dosya |
| 9 | Komutlar — Yordam, modül ve nesne |
| 10 | Komutlar — Bellek ve düşük seviye |
| 11 | Yerel (built-in) fonksiyonlar |
| 12 | İleri teknikler: olay, eşzamanlılık, hook, wrapper, FFI, DLL |
| 13 | İleri teknikler: tarayıcı, JS, WASM, yapay zekâ |
| 14 | Tam projeler — satır satır anlatım |

Her bölümde önce tablo hâlinde kısa tanım, sonra sınıf başlığı altında kullanım ve örnekler verilir. Temel kavramlar iki cümleyi geçmez; ileri teknikler ise satır satır açıklanır.

---

## BÖLÜM 2: İLK PROGRAMLAR, DOSYALAR VE MİMARİ

### 2.1 Dosya Uzantıları

uXBasic'te dosya uzantısı küçük görünür ama büyük projeyi düzenler. Ana programı `.uxb` içinde tutarsan kullanıcı nereden başlayacağını bilir. Başlık ve ortak tanımları `.uxbh` ya da `.uxmh` dosyasına ayırırsan beş farklı program aynı ayarı tekrar yazmaz.

| Uzantı | Anlamı ve kullanımı |
| --- | --- |
| `.uxb` | Ana program dosyasıdır. Doğrudan derlenir veya çalıştırılır. |
| `.uxbh` / `.uxmh` | Başlık ve ortak tanım dosyasıdır; `INCLUDE` veya ön-işleyici ile dahil edilir. |
| `.bas` | BASIC benzeri kaynak veya uyumluluk dosyasıdır. |
| `.c`, `.cpp`, `.asm` | `IMPORT(C,...)`, `IMPORT(CPP,...)`, `IMPORT(ASM,...)` ile derleme zamanında projeye bağlanan dış kaynaklardır. |
| `.json` | Token, AST, MIR, rapor, manifest, hata ve çıktı sözleşmesi dosyasıdır. |
| `.js` | Tarayıcı veya Node tarafında çalışacak JavaScript çıktısıdır. |
| `.wat` | WebAssembly metin biçimi çıktısıdır. |
| `.wasm` | Tarayıcıda veya host ortamında çalışabilecek ikili WebAssembly çıktısıdır. |
| `.asm` / `.nasm` | x64/x86 için derleyici tarafından üretilen assembly çıktısıdır. |

Altın kural: kaynak dosya elle yazılır, çıktı dosyası derleyici tarafından üretilir; ikisini aynı klasörde başıboş bırakma.

### 2.2 İlk Programı Çalıştırma

Bir uXBasic programı iki parçadan oluşur: ön-işleyici direktifleri (varsa) ve `MAIN ... END MAIN` bloğu. En küçük program şudur:

```uxbasic
MAIN
    PRINT "Merhaba dunya"
END MAIN
```

Çalıştırmak için komut satırına şunu yazarsın:

```powershell
uxb run merhaba.uxb
```

Çıktı:

```
Merhaba dunya
```

`MAIN` programın giriş noktasıdır. `END MAIN` programın bittiğini söyler. Aradaki her satır sırayla çalışır.

### 2.3 Komut Satırı ve Çıktı Sözleşmesi

Komut satırı, derleyiciyle konuştuğun yerdir. uXBasic derleyicisi (ADIM41 sürümü) iki çeşit komut biçimi kabul eder: uzun seçenekler (`--emit-js`) ve üç harfli kısa fiiller (`ejs`). Aşağıdaki tabloda en sık kullanılan seçenekler vardır.

| Uzun seçenek | Kısa fiil | Görev |
| --- | --- | --- |
| `--emit-js` | `ejs` | JavaScript üretimini açar. |
| `--js-out` | `jso` | JavaScript çıktı yolunu verir. |
| `--emit-wat` | `ewt` | WAT üretimini açar. |
| `--wat-out` | `wat` | WAT çıktı yolunu verir. |
| `--emit-wasm` | `ewm` | WASM üretimini açar. |
| `--wasm-out` | `wsm` | WASM çıktı yolunu verir. |
| `--html-out` | `htm` | HTML kabuk dosyasını üretir. |
| `--manifest-out` | `man` | Manifest dosyasını üretir. |
| `--ast-json-out` | `ajo` | AST raporunu üretir. |
| `--mir-json-out` | `mjo` | MIR raporunu üretir. |
| `--run-report-json-out` | `rrj` | Çalıştırma raporunu üretir. |
| `--stdout-out` | — | Programın standart çıktısını dosyaya yazar. |
| `--stderr-out` | — | Programın hata çıktısını dosyaya yazar. |
| `--version` | `ver` | Sürüm bilgisini gösterir. |
| `--help` | `hlp` | Yardımı gösterir. |

Mantığı şudur: `emit` üretimi açar, `out` yol söyler, `report` kanıt üretir, `trace` çalışma anını izler.

Örnek derleme zinciri:

```powershell
uxb ejs web.uxb --js-out dist/web/program.js --html-out dist/web/index.html
uxb wat hizli.uxb --wat-out dist/wasm/program.wat --manifest-out dist/manifest.json
uxb run rapor.uxb --stdout-out out/stdout.txt --stderr-out out/stderr.txt --run-report-json-out out/run.json
```

### 2.4 Mimari Katmanlar

Bir program metninin, çalışır makine koduna veya tarayıcı çıktısına dönüşmesi birkaç duraktan geçer. Bu durakları bilmek genç programcıya iki üstünlük kazandırır: hata nerede doğduğunu anlarsın ve dili geliştirmek istediğinde hangi klasöre bakacağını bilirsin.

| Katman | Görev |
| --- | --- |
| Ön-işleyici (preprocessor) | `%%` ile başlayan komutları, makroları, hedef dosya bloklarını işler. |
| Sözcükleyici (lexer) | Anahtar sözcükleri, metinleri, sayıları, işaretleri çıkarır. |
| Çözümleyici (parser) | Tokenları soyut sözdizimi ağacına (AST) çevirir. |
| Anlam katmanı (semantic) | Tip ve kapsam denetimi yapar. |
| Sembol tablosu (symbols) | Değişken, yordam, sınıf, sabit ve dış adları tutar. |
| MIR (orta ara gösterim) | Komutları hedeflerden bağımsız bir listeye indirir. |
| Çalışma zamanı (runtime) | Dosya, bellek, DLL, ekran, runtime servisleri. |
| Arka uç (backend) | JS, WAT, NASM, browser çıktısı üretir. |
| Test kapıları (gates) | Eksik, sahte veya bozuk çıktı var mı bakar. |

Bir hata gördüğünde önce hata türünü düşün:

- `LEX` veya ön-işleyici hatası metin ve makrodadır.
- `PARSER` hatası sözdizimindedir.
- `SEMANTIC` hatası tip veya isimdedir.
- `MIR` hatası ara işlem eksikliğidir.
- `BACKEND` veya `EMIT` hatası hedef çıktısıdır.
- `RUNTIME` hatası çalıştırma sırasında dosya, servis veya bellek çağrısıdır.

Bu ayrım aceleyle her yere yama yapmanı engeller.

### 2.5 Çok Katmanlı İlk Örnek

Aşağıdaki örnek aynı kaynağın hem konsola hem tarayıcıya gidebileceğini gösterir:

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<h1>uXBasic katman testi</h1>
%%HTML_END

MAIN
    DIM mesaj AS STRING
    mesaj = "Ayni kaynak hem konsola hem tarayiciya gider"
    PRINT mesaj
END MAIN
```

Çalıştırma:

```powershell
uxb ejs katman.uxb --js-out dist/web/program.js --html-out dist/web/index.html
```

Aç `dist/web/index.html` dosyasını tarayıcıda; konsol çıktısı hem ekranda hem HTML kabuğunda belirir.

### 2.6 Bölüm Özeti

uXBasic programı üç şeyi birlikte taşır: kaynak metin, derleme zinciri ve çıktı sözleşmesi. Kaynak metni sen yazarsın; derleme zincirini komut satırı seçenekleriyle yönetirsin; çıktı sözleşmesi rapor dosyalarıyla kanıtlanır. Bu üçlü birlikte düşünüldüğünde "program çalışmadı" cümlesi "hangi katmanda, hangi dosyada, hangi seçenekle" sorusuna dönüşür; bu da çözümün önünü açar.

---

## BÖLÜM 3: ÖN-İŞLEYİCİ (PREPROCESSOR)

### 3.1 Ön-işleyici Nedir?

Ön-işleyici, derleyicinin kaynak metne ilk dokunduğu katmandır. Görevi şudur: `%%` ile başlayan komutları okumak, makroları açmak, koşullu derlemeyi yapmak, hedef dosya bloklarını (HTML, JS, WAT, JSON, CSS, MD) toplamak ve varlık (asset) listesini hazırlamak. Ön-işleyicinin ürettiği metin daha sonra sözcükleyiciye verilir.

> Önemli not: uXBasic'te ön-işleyici komutları tek `#` değil, **çift `%%`** önekiyle başlar. Yani `#IF`, `#DEFINE`, `#INCLUDE` yoktur; `%%IF`, `%%DEFINE`, `%%INCLUDE` vardır.

### 3.2 Ön-işleyici Komut Aileleri

| Aile | Görev |
| --- | --- |
| Tanım, makro, hesaplama | `%%DEFINE`, `%%UNDEF`, `%%SET`, `%%MACRO`, `%%EVAL`, `%%ALIAS` |
| Koşullu derleme | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` |
| Tekrarlı meta üretim | `%%FOR`, `%%FOREACH`, `%%ENDFOR`, `%%REPEAT`, `%%BREAK`, `%%CONTINUE`, `%%NEXTMETA`, `%%UNTILMETA` |
| Hedef, çıktı, manifest, rapor | `%%TARGET`, `%%OUTDIR`, `%%PROFILE`, `%%MINIFY`, `%%MANIFEST_SET`, `%%MANIFEST_REQUIRE`, `%%SOURCE_MAP`, `%%DEPRECATED`, `%%EMITNOTE` |
| Web/JSON/Markdown çıktı blokları | `%%HTML_BEGIN`, `%%HTML_END`, `%%HTML_LINE`, `%%CSS_BEGIN`, `%%CSS_END`, `%%CSS_RULE`, `%%JSON_BEGIN`, `%%JSON_END`, `%%JS_BEGIN`, `%%JS_END`, `%%JS_LINE`, `%%MD_BEGIN`, `%%MD_END` |
| Varlık (asset) yönetimi | `%%ASSET_FILE`, `%%ASSET_IMAGE`, `%%ASSET_AUDIO`, `%%ASSET_COPY`, `%%ASSET_REQUIRE`, `%%ASSET_ROOT`, `%%EMBEDBASE64`, `%%EMBEDTEXT`, `%%HASHFILE`, `%%HTMLIMAGE`, `%%HTMLAUDIO`, `%%FINGERPRINT_ASSETS` |
| WAT/WASM köprüsü | `%%WAT_BEGIN`, `%%WAT_END`, `%%WAT_FUNC_BEGIN`, `%%WAT_FUNC_END`, `%%WAT_EXPORT`, `%%WAT_IMPORT`, `%%WASM_HOST_JS_BEGIN`, `%%WASM_HOST_JS_END` |
| Dosya, yol, güvenlik | `%%INCLUDE`, `%%CONFIG_FILE`, `%%COPY_DIR`, `%%PATH_ALIAS`, `%%LICENSEFILE`, `%%SAFE_PATHS`, `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SECSTACK`, `%%NOZEROVARS` |
| Hedef işletim sistemi | `%%PLATFORM`, `%%DESTOS` |
| Meta, hata, uyarı | `%%ASSERT`, `%%ASSERT_META`, `%%ERROR`, `%%WARNING`, `%%INFO`, `%%INFO_META`, `%%WARN_META`, `%%LOCK_META`, `%%SECTION`, `%%ENDSECTION` |
| Şablon, enjeksiyon, bağlama | `%%TEMPLATE_BEGIN`, `%%TEMPLATE_END`, `%%TEMPLATE_USE`, `%%INJECT_JS`, `%%INJECT_ASM`, `%%INLINE`, `%%LINK_DLL`, `%%LINK_WASM`, `%%NO_MANGLE`, `%%EXTENSION`, `%%EXPANDLIMIT`, `%%ENV` |

### 3.3 Temel Tanımlar: `%%DEFINE`, `%%UNDEF`, `%%SET`

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `%%DEFINE` | `%%DEFINE AD değer` | Derleme zamanında ad, değer veya kısa yol üretir. |
| `%%UNDEF` | `%%UNDEF AD` | Tanımı kaldırır. |
| `%%SET` | `%%SET AD = değer` | Hesaplanmış değer üretir. |
| `%%EVAL` | `%%EVAL ifade` | Derleme zamanında ifadeyi hesaplar. |
| `%%ALIAS` | `%%ALIAS uzun AS kısa` | Uzun ada kısa ad verir. |

Örnek:

```uxbasic
%%DEFINE SURUM "30.05_5"
%%DEFINE DEBUG 1
%%SET TOPLAM = 3 + 5
%%ALIAS YOL = "assets/"

MAIN
    PRINT "Surum="; SURUM
    PRINT "Toplam="; TOPLAM
END MAIN
```

`%%DEFINE` ile ad yerine konan değer, derleme öncesinde metne yerleştirilir. `%%SET` ise hesap yapar; sağ taraftaki ifade `%%EVAL` ile çözülür.

### 3.4 Koşullu Derleme: `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF`

| Komut | Görev |
| --- | --- |
| `%%IF koşul` | Koşul doğruysa bloğu derlemeye alır. |
| `%%IFC koşul` | Karakter dizisi koşulu için kullanılır. |
| `%%IFN sayısal_koşul` | Sayısal koşul yanlışsa bloğu alır. |
| `%%ELIF koşul` | Önceki koşul yanlışsa yeni koşul dener. |
| `%%ELSE` | Tüm koşullar yanlışsa bloğu alır. |
| `%%ENDIF` | Koşul bloğunu kapatır. |

> Not: `%%IFDEF` **yoktur**. Bir adın tanımlı olup olmadığını denetlemek için `%%IF DEFINED(AD)` biçimi kullanılır.

Örnek:

```uxbasic
%%DEFINE HEDEF "BROWSER"
%%IF HEDEF = "BROWSER"
    %%TARGET BROWSER
    %%OUTDIR "dist/web"
%%ELIF HEDEF = "WASM"
    %%TARGET WASM
    %%OUTDIR "dist/wasm"
%%ELSE
    %%TARGET X64
    %%OUTDIR "dist/x64"
%%ENDIF

MAIN
    PRINT "hedef derlemesi hazir"
END MAIN
```

Bu örnekte `HEDEF` sabitine göre derleme üç yoldan birine girer. Koşullu derleme, tek kaynaktan birden fazla hedef üretmenin temel aracıdır.

### 3.5 Hedef Seçimi: `%%TARGET`

| Değer | Anlamı |
| --- | --- |
| `JS` | JavaScript çıktısı üretir. |
| `WASM` | WebAssembly çıktısı üretir. |
| `BROWSER` | HTML + JS + manifest paketi üretir. |
| `X64` | x64 assembly çıktısı üretir. |
| `X86` | x86 assembly çıktısı üretir. |

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%MANIFEST_SET app "SahaRaporu"
%%ASSET_ROOT "assets"
```

`%%TARGET` seçildikten sonra o hedefe uygun diğer direktifler (HTML bloğu, varlık listesi, manifest bilgisi) sıralanır.

### 3.6 Makro: `%%MACRO`

Makro, derleme zamanında genişleyen küçük kod üretecidir.

```uxbasic
%%MACRO KARE(x) ((x) * (x))
%%MACRO YAZDIR(metin) PRINT metin

MAIN
    DIM a AS I32
    a = KARE(5)
    YAZDIR("a degeri")
    PRINT a
END MAIN
```

Makro gövdesinde parantez kullanmak iyi alışkanlıktır. `KARE(1+2)` çağrısı `((1+2) * (1+2))` biçiminde genişler; parantez olmadan `1+2 * 1+2` olarak yanlış sonuç doğardı.

### 3.7 HTML Çıktı Blokları

Tarayıcı hedefinde HTML kabuğu kaynak dosyanın içine gömülebilir.

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Saha Raporu</h1>
<p id="durum">yukleniyor</p>
%%HTML_END
%%JS_LINE "document.getElementById('durum').innerText='hazir'"

MAIN
    PRINT "Web hedefi hazir"
END MAIN
```

`%%HTML_BEGIN "dosya" BODY` ile `%%HTML_END` arasındaki her satır, hedef HTML dosyasının gövdesine yazılır. `%%JS_LINE` ise bir JavaScript satırını JS çıktısına ekler.

### 3.8 Varlık Yönetimi

Tarayıcı paketinde resim, ses, dosya gibi varlıkları manifeste eklemek için varlık direktifleri kullanılır.

```uxbasic
%%TARGET BROWSER
%%ASSET_ROOT "assets"
%%ASSET_IMAGE "logo.png" AS "logo"
%%ASSET_AUDIO "uyari.ogg" AS "alarm"
%%ASSET_FILE "veri.json" AS "olcumVerisi"
%%FINGERPRINT_ASSETS ON
```

| Komut | Görev |
| --- | --- |
| `%%ASSET_ROOT "yol"` | Varlık kök dizinini belirler. |
| `%%ASSET_IMAGE "kaynak" AS "id"` | Resmi pakete ekler. |
| `%%ASSET_AUDIO "kaynak" AS "id"` | Sesi pakete ekler. |
| `%%ASSET_FILE "kaynak"` | Genel dosyayı ekler. |
| `%%ASSET_COPY "kaynak" AS "hedef"` | Dosyayı hedef yola kopyalar. |
| `%%EMBEDBASE64 "dosya" AS AD` | Dosyayı base64 olarak gömer. |
| `%%EMBEDTEXT "dosya" AS AD` | Dosyayı metin olarak gömer. |
| `%%HASHFILE "dosya" AS AD` | Dosyanın özetini üretir. |
| `%%FINGERPRINT_ASSETS ON\|OFF` | Önbellek kırmayı açar/kapatır. |

### 3.9 WAT/WASM Köprüsü

WASM hedefinde dış fonksiyonları tanıtmak ve dışa açmak için WAT direktifleri kullanılır.

```uxbasic
%%TARGET WASM
%%ALLOW_RAW_WAT ON
%%WAT_IMPORT "ux" "print_i32" "(func $ux_print_i32 (param i32))"
%%WAT_EXPORT "MAIN"

MAIN
    PRINT 42
END MAIN
```

`%%WAT_IMPORT` ile tarayıcı tarafındaki bir JavaScript fonksiyonu WASM içinden çağrılabilir hâle gelir. `%%WAT_EXPORT` ise uXBasic'te tanımlı bir fonksiyonu dış dünyaya açar.

### 3.10 Tekrarlı Meta Üretim

```uxbasic
%%FOR ad = 1 TO 5
    %%DEFINE OLCUM_{{ad}} {{ad}} * 2
%%ENDFOR

MAIN
    PRINT OLCUM_1
    PRINT OLCUM_2
    PRINT OLCUM_3
END MAIN
```

Bu örnekte `%%FOR` döngüsü derleme zamanında beş ayrı `%%DEFINE` üretir. Çalışma zamanında `OLCUM_1`, `OLCUM_2` gibi adlar hazır değerlerdir.

### 3.11 Birlikte Kullanım Örneği — Tam Tarayıcı Paketi

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%ASSET_ROOT "assets"
%%MANIFEST_SET app "SahaRaporu"
%%MANIFEST_SET version "1.0"
%%ASSET_IMAGE "logo.png" AS "logo"
%%DEFINE DEBUG 1

%%HTML_BEGIN "index.html" BODY
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>SahaRaporu</title></head>
<body>
<h1 id="baslik">Yukleniyor</h1>
<canvas id="saha" width="640" height="360"></canvas>
<pre id="gunluk"></pre>
</body>
</html>
%%HTML_END

%%JS_LINE "const c=document.getElementById('saha').getContext('2d');"
%%JS_LINE "c.fillText('uXBasic JS ciktisi',20,30);"

MAIN
    PRINT "Web ve konsol cikti sozlesmesi hazir"
END MAIN
```

Çalıştırma:

```powershell
uxb ejs saha.uxb --js-out dist/web/program.js --html-out dist/web/index.html --manifest-out dist/web/manifest.json
```

Bu örneğin püf noktası şudur: aynı `.uxb` dosyası hem HTML kabuğunu, hem JavaScript satırlarını, hem varlık listesini, hem manifest bilgilerini, hem de ana programı taşır. Derleyici hepsini sırayla işler ve tarayıcıda açılabilir bir paket üretir.

### 3.12 Bölüm Özeti

Ön-işleyici, uXBasic'in derleme öncesi düşünen katmanıdır. Üç büyük iş yapar: (1) koşullu derleme ile tek kaynaktan çok hedef üretir, (2) makro ve tanımlarla derleme zamanı hesabı yapar, (3) HTML/JS/WAT/CSS/JSON bloklarını ve varlık listesini toplayarak çıktı paketinin iskeletini kurar. Genç programcı için ön-işleyici, "aynı kod niye farklı yerlerde farklı çalışıyor" sorusunun cevabıdır.

---

## BÖLÜM 4: VERİ TİPLERİ

### 4.1 Tip Seçimi Neden Önemlidir?

Tip seçimi, programın sessiz kaderidir. Küçük sayı için büyük tip seçersen bellek harcarsın; büyük sayı için küçük tip seçersen taşma yaşarsın. Bilimsel hesapta `F64` çoğu zaman yeterlidir; para, hassas ondalık ve çok basamaklı hesapta `BIGD`; geniş ikili hassasiyet ve matematiksel işlemde `BIGF`; dev tam sayıda `BIGI`/`BIGINT`; aralık veya belirsizlik mantığında `BALL` kullanılır.

uXBasic'te tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yaparsın.

### 4.2 Tam Sayı Ailesi

| Tip | Boyut | Aralık | Tipik kullanım |
| --- | --- | --- | --- |
| `I8` | 8 bit işaretli | -128 .. 127 | küçük durum kodu, fark |
| `U8` | 8 bit işaretsiz | 0 .. 255 | renk, bayt, küçük sayaç |
| `I16` | 16 bit işaretli | -32768 .. 32767 | sensör ham değeri |
| `U16` | 16 bit işaretsiz | 0 .. 65535 | port, indeks |
| `I32` | 32 bit işaretli | -2³¹ .. 2³¹-1 | günlük sayaç, döngü, adet |
| `U32` | 32 bit işaretsiz | 0 .. 2³²-1 | negatif olmayan sayaç, CRC |
| `I64` | 64 bit işaretli | -2⁶³ .. 2⁶³-1 | dosya boyu, büyük sayaç |
| `U64` | 64 bit işaretsiz | 0 .. 2⁶⁴-1 | çok büyük pozitif sayaç |
| `BYTE` | 1 bayt | 0 .. 255 | ham veri (U8 ile eş anlamlı) |

Küçük bir örnek:

```uxbasic
DIM adet AS I32
DIM boyut AS U64
DIM renk AS U8

adet = 30
boyut = 1099511627776
renk = 255

PRINT "adet="; adet
PRINT "boyut="; boyut
PRINT "renk="; renk
END
```

### 4.3 Kayan Noktalı (Ondalık) Sayı Ailesi

| Tip | Boyut | Kullanım | Püf noktası |
| --- | --- | --- | --- |
| `F32` | 32 bit (tek duyarlıklı) | grafik, hızlı yaklaşık hesap | bilimsel sonuçta dikkatli kullan |
| `F64` | 64 bit (çift duyarlıklı) | genel bilimsel hesap | ilk tercih çoğunlukla budur |
| `F80` | 80 bit (genişletilmiş) | hassas nümerik hesap | dış çalışma zamanı gerekir |
| `F128` | 128 bit | yüksek duyarlık | dış çalışma zamanı gerekir |

```uxbasic
DIM ph AS F64
DIM sicaklik AS F64
DIM yaklasik AS F32

ph = 7.35
sicaklik = 24.8
yaklasik = 3.14

PRINT "pH="; ph
PRINT "sicaklik="; sicaklik
```

Bilimsel ölçüm için kural: `F64` seç. Para veya doğruluğu kanıtlanması gereken hesap için `BIGD` seç. `F32` yalnızca belleğin sıkıştığı veya grafiğin hız istediği yerlerde kullanılır.

### 4.4 Büyük Sayı Ailesi

uXBasic, sınırsız büyüklükte tam sayı ve çok basamaklı ondalık sayılar için bir büyük sayı ailesi sunar.

| Tip | Anlamı | Tipik kullanım |
| --- | --- | --- |
| `BIGI` | Çok büyük tam sayı | kripto, kombinasyon, faktöriyel |
| `BIGINT` | `BIGI` ile eş anlamlı | aynı |
| `BIGD` | Çok basamaklı ondalık | para, tartım, hassas rapor |
| `BIGF` | Büyük/yüksek duyarlıklı kayan sayı | bilimsel model, matris |
| `BALL` | Aralık/güvenli yaklaşık sayı | hata payı, ölçüm belirsizliği |

Düşünme biçimi: `BIGI` ve `BIGINT` tam sayı ailesidir; küsurat taşımaz. `BIGD` insanın yazdığı ondalık basamağı korumaya yakındır; para ve hassas tartım için uygundur. `BIGF` bilimsel hesaplarda çok geniş duyarlık verir; matris, türev, model, simülasyon gibi işlerde kullanılır. `BALL`, tek sonuç yerine "sonuç bu aralıkta" demeyi sağlar; laboratuvar ölçümünde hata payını saklamak için çok değerlidir.

Örnek:

```uxbasic
DIM n AS BIGINT
DIM tartim AS BIGD
DIM modelSonucu AS BIGF
DIM phAraligi AS BALL

n = BIGINT("1000000000000000000000000000001")
tartim = BIGD("12.345678901234")
modelSonucu = BIGF("3.141592653589793238462643383279")
phAraligi = BALL("7.30", "7.38")

PRINT "Buyuk sayilar hazir"
```

Burada her değer bir metin olarak başlatılır; çünkü bu büyüklükteki sayılar standart değişken atamasıyla sığmaz.

### 4.5 Mantıksal, Metin, Adres ve Diğer Tipler

| Tip | Anlamı | Tipik kullanım |
| --- | --- | --- |
| `BOOLEAN` | doğru/yanlış | bayrak ve koşul |
| `STRING` | metin | ad, yol, JSON, rapor satırı |
| `OBJECT` | nesne başvurusu | sınıf örneği |
| `PTR` | ham adres / işaretçi | dış çağrı, DLL, runtime handle |
| `STRPTR` | metin adresi | dış çağrı, DLL |
| `ARRAY` | sabit veya yeniden boyutlanabilir dizi | liste hâlinde veri |
| `LIST` | sıralı, büyüyebilen liste | sayısı belli olmayan veri |
| `DICT` | anahtar/değer sözlüğü | kod → açıklama, ad → tip |
| `SET` | tekrarsız küme | benzersiz kimlik, benzersiz hata |

```uxbasic
DIM tamam AS BOOLEAN
DIM ad AS STRING
DIM p AS PTR
DIM olcumler AS ARRAY
DIM gorulen AS SET

tamam = TRUE
ad = "laboratuvar"
```

### 4.6 Varsayılan Tip Komutları (Eski BASIC Uyumu)

Eski BASIC alışkanlığından gelen bu komutlar, harfle başlayan değişkenlere varsayılan tip atar. Yeni kodda açık `DIM ad AS Tip` yazmak daha güvenlidir; ama eski kod taşırken veya hızlı prototipte işe yarar.

| Komut | Sözdizimi | Varsayılan tip |
| --- | --- | --- |
| `DEFBYT` | `DEFBYT A-Z` | `BYTE` |
| `DEFINT` | `DEFINT A-Z` | `I32` |
| `DEFLNG` | `DEFLNG A-Z` | `I64` |
| `DEFSNG` | `DEFSNG A-Z` | `F32` |
| `DEFDBL` | `DEFDBL A-Z` | `F64` |
| `DEFEXT` | `DEFEXT A-Z` | geniş ondalık |
| `DEFSTR` | `DEFSTR A-Z` | `STRING` |

Örnek:

```uxbasic
DEFINT A-Z
adet = 10
toplam = 0
FOR i = 1 TO adet
    toplam = toplam + i
NEXT i
PRINT toplam
```

Burada `adet`, `toplam`, `i` açık tip yazılmadığı için `DEFINT A-Z` kuralı gereği `I32` kabul edilir.

### 4.7 Tip Seçim Cep Defteri

| İş | En uygun yapı | Neden? |
| --- | --- | --- |
| 30 günlük tek ölçüm | `ARRAY` + `F64` | boyut belli, hızlı |
| Dosyadan belirsiz satır | `LIST` | büyüyebilir |
| Hata kodu açıklaması | `DICT` | anahtar/değer |
| Benzersiz tank adları | `SET` | tekrar engeller |
| Numune satırı | `TYPE` | alanları toplar |
| Tank davranışı | `CLASS` | hesap ve veri birlikte |
| DLL kaynağı | `PTR`/handle | dış dünya tanıtıcısı |
| Para | `BIGD` | ondalık basamak |
| Büyük tam sayı | `BIGINT` | taşma istemez |
| Ölçüm belirsizliği | `BALL` | aralık tutar |
| Tarayıcı varlık listesi | `DICT` + `LIST` | yol ve sıra birlikte |

Cilt boyunca unutmaman gereken tek cümle: **Tipi tahminle değil sınırla seç.** 0..255 ise `U8`, günlük sayı ise `I32`, ölçüm ise `F64`, para ise `BIGD`.

### 4.8 Tip Uyumluluğu ve Dönüşüm

uXBasic, tipler arasında otomatik dönüşüm yapar; ama bilinçli dönüşüm fonksiyonları daha güvenlidir. Dönüşüm fonksiyonları Bölüm 11'de ayrıntılı işlenecek; burada kısa bir ön izleme verelim.

| Fonksiyon | Görev |
| --- | --- |
| `CINT(x)` | Değeri `I32`'ye çevirir. |
| `CLNG(x)` | Değeri `I64`'e çevirir. |
| `CSNG(x)` | Değeri `F32`'ye çevirir. |
| `CDBL(x)` | Değeri `F64`'e çevirir. |
| `STR(sayı)` | Sayıyı metne çevirir. |
| `VAL(metin)` | Metni sayıya çevirir. |

```uxbasic
DIM ham AS STRING
DIM sayi AS F64

ham = "  42.50  "
sayi = VAL(LTRIM(RTRIM(ham)))
PRINT "sayi="; sayi
PRINT "karekok="; SQRT(sayi)
```

`LTRIM` metnin solundaki boşlukları, `RTRIM` sağındakini kırpar. `VAL` temizlenmiş metni sayıya çevirir. `SQRT` karekök alır. Üç fonksiyon zinciri tek satırda okunur.

### 4.9 Bölüm Özeti

Veri tipleri, değişkenin hangi değerleri tutacağını ve bellekte nasıl davranacağını söyler. uXBasic tam sayı, kayan noktalı, büyük sayı, mantıksal, metin, adres ve koleksiyon tiplerini bir arada sunar. Doğru tip seçimi üç şeyi belirler: bellek kullanımı, hesap doğruluğu ve hata mesajı kalitesi. Bir sonraki bölümde bu tipleri değişkenlere bağlayan `DIM`, `CONST`, `REDIM` komutlarını ve dizi/liste/sözlük/küme gibi veri yapılarını inceleyeceğiz.

---
# Programcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek (Devam)

---

## BÖLÜM 5: DEĞİŞKENLER VE VERİ YAPILARI

### 5.1 Değişken Nedir?

Değişken, programın bellekte ad verdiği kutudur. Aslında değişken dört şey taşır: **adı, tipi, kapsamı ve ömrü**. Ad, insanın okuduğu etikettir; tip, içine ne gireceğini söyler; kapsam, nereden görüleceğini belirler; ömür, ne zaman başlayıp ne zaman biteceğini anlatır.

| Kavram | uXBasic karşılığı | Ne zaman düşünülür? |
| --- | --- | --- |
| Ad | `tankNo`, `phDegeri`, `toplamAgirlik` | Kod okunur olsun istendiğinde |
| Tip | `I32`, `F64`, `STRING`, `BIGD`, `DICT` | Değerin sınırı ve hesap türü seçilirken |
| Kapsam | `MAIN`, `SUB`, `FUNCTION`, `MODULE`, `CLASS` | Değişkeni kim görebilecek sorusunda |
| Ömür | blok içi, program boyu, nesne boyu | Kaynak temizliği ve hata yakalamada |
| Başlangıç değeri | atama satırı | Yanlış rastgele değer oluşmasın diye |

### 5.2 Değişken Bildirimi: `DIM`

`DIM`, "dimension"ın kısaltmasıdır. BASIC geleneğinde boyut ayrımı yap anlamına gelir; uXBasic'te değişken, dizi veya nesne başvurusu ayırmak için kullanılır.

**Sözdizimi:**

```
DIM ad AS Tip
DIM dizi(boyut) AS Tip
DIM ad[(sınırlar)] AS Tip
```

**Örnek:**

```uxbasic
DIM tankNo AS I32
DIM phDegeri AS F64
DIM sonuc AS STRING

phDegeri = 7.35
sonuc = "normal"

PRINT "Tank="; tankNo; " pH="; phDegeri; " durum="; sonuc
```

`DIM` ile açılan değişken, açıkça değer atanana kadar varsayılan değerini taşır: sayısal tipler için `0`, mantıksal tip için `FALSE`, metin için boş dize.

### 5.3 Sabitler: `CONST`

Sabit, program boyunca değişmeyecek değerler içindir. Sınır değerleri, katsayılar, dosya yolları ve test eşikleri `CONST` ile adlandırılır.

**Sözdizimi:**

```
CONST ad AS Tip = değer
```

**Örnek:**

```uxbasic
CONST PH_ALT AS F64 = 6.5
CONST PH_UST AS F64 = 8.5
CONST HEDEF_AS F64 = 100.0
CONST UYARI_YUZDE AS F64 = 3.0

DIM ph AS F64
INPUT ph

IF ph < PH_ALT OR ph > PH_UST THEN
    PRINT "pH sinir disi"
ELSE
    PRINT "pH uygun"
END IF
```

Sınır değerleri kodun içine saklanmamış, `CONST` ile adlandırılmıştır. Böylece yarın pH sınırı değişirse bütün programı aramazsın; yalnızca `CONST` satırını değiştirirsin.

### 5.4 Diziyi Yeniden Boyutlandırma: `REDIM`

Dizinin boyutunu çalışma sırasında değiştirmek için `REDIM` kullanılır. Kaç ölçüm geleceği başta bilinmiyorsa, okudukça büyüyen dizi kurarken işe yarar.

**Sözdizimi:**

```
REDIM dizi(yeniBoyut)
```

**Örnek — büyüyen ölçüm dizisi:**

```uxbasic
DIM olcum(10) AS F64
DIM kapasite AS I32
DIM adet AS I32

kapasite = 10
DO
    INPUT x
    IF x < 0 THEN EXIT DO
    adet = adet + 1
    IF adet > kapasite THEN
        kapasite = kapasite + 10
        REDIM olcum(kapasite)
    END IF
    olcum(adet) = x
LOOP

PRINT "adet="; adet; " kapasite="; kapasite
```

**İpucu:** Her ölçümde bir eleman büyütmek pahalı olabilir; kapasiteyi blok blok (10'ar, 100'er) artırmak daha hızlıdır. Yukarıdaki örnekte kapasite her doluşunda 10 eklenir; bu, sık `REDIM` çağrısını engeller.

### 5.5 Çok Boyutlu Diziler

uXBasic bir boyuttan beş boyuta kadar dizileri destekler. Bir boyut liste gibidir; iki boyut tablo; üç boyut küp; dört boyut deney planı; beş boyut büyük araştırma defteridir.

| Boyut | Benzetme | Örnek eksenler | Ne zaman kullanılır? |
| --- | --- | --- | --- |
| 1D | tek sütun | gün | sıcaklık listesi, not listesi |
| 2D | tablo | satır, sütun | numune × parametre |
| 3D | küp | tank, gün, parametre | saha izleme |
| 4D | deney defteri | grup, tank, gün, parametre | kontrol/uygulama deneyi |
| 5D | araştırma ambarı | yıl, bölge, tank, gün, parametre | uzun dönem veri |

**1 boyut:**

```uxbasic
DIM sicaklik(7) AS F64
FOR gun = 1 TO 7
    sicaklik(gun) = 21.0 + gun * 0.25
NEXT gun
PRINT "3. gun sicaklik="; sicaklik(3)
```

**2 boyut (numune × parametre):**

```uxbasic
DIM tablo(10, 3) AS F64
' sutun 1=pH, 2=oksijen, 3=sicaklik
FOR numune = 1 TO 10
    tablo(numune, 1) = 7.2 + RND() * 0.4
    tablo(numune, 2) = 6.0 + RND() * 1.5
    tablo(numune, 3) = 22.0 + RND() * 2.0
NEXT numune
PRINT "5. numune pH="; tablo(5, 1)
```

**3 boyut (tank × gün × parametre):**

```uxbasic
DIM saha(4, 7, 3) AS F64
FOR tank = 1 TO 4
    FOR gun = 1 TO 7
        saha(tank, gun, 1) = 7.3
        saha(tank, gun, 2) = 6.8
        saha(tank, gun, 3) = 22.5
    NEXT gun
NEXT tank
PRINT "tank 2 gun 4 pH="; saha(2, 4, 1)
```

**4 boyut (grup × tank × gün × parametre):**

```uxbasic
DIM deney(2, 4, 14, 3) AS F64
FOR grup = 1 TO 2
    FOR tank = 1 TO 4
        FOR gun = 1 TO 14
            deney(grup, tank, gun, 1) = 7.2 + grup * 0.05
            deney(grup, tank, gun, 2) = 6.5 + RND()
            deney(grup, tank, gun, 3) = 22.0 + RND()
        NEXT gun
    NEXT tank
NEXT grup
PRINT "grup 1 tank 2 gun 5 sicaklik="; deney(1, 2, 5, 3)
```

**5 boyut (yıl × lokasyon × tank × gün × parametre):**

```uxbasic
DIM izleme(3, 5, 8, 30, 4) AS F64
izleme(1, 2, 4, 15, 3) = 23.7
PRINT "secili sicaklik="; izleme(1, 2, 4, 15, 3)
```

> **İpucu:** Beş boyuta çıktıysan mutlaka her eksenin anlamını yorum olarak yaz. Yoksa iki hafta sonra sen bile unutursun.

### 5.6 Koleksiyonlar: `LIST`, `DICT`, `SET`

`ARRAY` hızlı ve düzenlidir; indeksle erişirsin. `LIST` büyüyebilir sıra tutar; ne kadar veri geleceği başta belli değilse güzeldir. `DICT` anahtar/değer tablosudur; yüz satırlık `IF kelime = ...` zincirini temizler. `SET` tekrarsız kümedir; "daha önce gördün mü" sorusuna hızlı cevap verir.

| Yapı | Soru | Cevap verdiği problem | Kısa kullanım |
| --- | --- | --- | --- |
| `ARRAY` | Kaç hücre var? | sabit boyutlu hızlı veri | `DIM a(100) AS F64` |
| `LIST` | Sıra önemli mi? | büyüyen ölçüm listesi | `CALL ux_list_push_f64(...)` |
| `DICT` | Anahtardan değere gitmek mi? | kod→açıklama, ad→tip | `CALL ux_dict_set_string(...)` |
| `SET` | Tekrarı engellemek mi? | benzersiz tank, benzersiz hata | `CALL ux_set_add(...)` |

### 5.7 Koleksiyonların Pratik Kullanımı

Koleksiyonlar runtime servislerine bağlıdır; `INCLUDE "modules/uxcollections.uxmh"` ile başlık dosyası eklenir, handle (tutamak) ile kullanılır.

**LIST örneği:**

```uxbasic
INCLUDE "modules/uxcollections.uxmh"
DIM phListe AS PTR
phListe = ux_list_new()
CALL ux_list_push_f64(phListe, 7.2)
CALL ux_list_push_f64(phListe, 7.4)
CALL ux_list_push_f64(phListe, 7.1)
PRINT ux_list_count(phListe)
CALL ux_list_free(phListe)
```

**DICT örneği:**

```uxbasic
INCLUDE "modules/uxcollections.uxmh"
DIM mesaj AS PTR
mesaj = ux_dict_new()
CALL ux_dict_set_string(mesaj, "OK", "Sorun yok")
CALL ux_dict_set_string(mesaj, "WARN", "Dikkat")
CALL ux_dict_set_string(mesaj, "FAIL", "Mudahale gerekli")
PRINT ux_dict_get_string(mesaj, "WARN")
CALL ux_dict_free(mesaj)
```

**SET örneği:**

```uxbasic
DIM gorulen AS PTR
gorulen = ux_set_new()
CALL ux_set_add(gorulen, "Tank-1")
CALL ux_set_add(gorulen, "Tank-1")    ' tekrar, yok sayilir
CALL ux_set_add(gorulen, "Tank-2")
PRINT ux_set_count(gorulen)            ' 2 yazar
CALL ux_set_free(gorulen)
```

### 5.8 IF Zincirini DICT'e Çevirme — Birlikte Kullanım Örneği

Uzun `IF` zinciri tasarım kokusudur. Aşağıdaki örnekte hata kodlarını ve anlamlarını bir sözlüğe koyuyoruz; program büyürken IF zinciri büyümüyor.

```uxbasic
INCLUDE "modules/uxcollections.uxmh"

MAIN
    DIM hataMesaj AS PTR
    DIM gorulenTank AS PTR
    DIM agirliklar AS PTR
    DIM i AS I32

    hataMesaj = ux_dict_new()
    gorulenTank = ux_set_new()
    agirliklar = ux_list_new()

    CALL ux_dict_set_string(hataMesaj, "E01", "dusuk oksijen")
    CALL ux_dict_set_string(hataMesaj, "E02", "yuksek sicaklik")
    CALL ux_dict_set_string(hataMesaj, "E03", "pH sinir disi")

    FOR i = 1 TO 20
        DIM tank AS STRING
        DIM kod AS STRING
        DIM agirlik AS F64
        tank = "T" + STR(1 + (i MOD 4))
        agirlik = 35.0 + RND() * 8.0
        IF i = 6 THEN
            kod = "E01"
        ELSEIF i = 13 THEN
            kod = "E03"
        ELSE
            kod = "OK"
        END IF

        CALL ux_set_add(gorulenTank, tank)
        CALL ux_list_push_f64(agirliklar, agirlik)

        IF kod <> "OK" THEN
            PRINT tank + " hata=" + ux_dict_get_string(hataMesaj, kod)
        END IF
    NEXT i

    PRINT "Benzersiz tank="; ux_set_count(gorulenTank)
    PRINT "Olcum adedi="; ux_list_count(agirliklar)

    CALL ux_list_free(agirliklar)
    CALL ux_set_free(gorulenTank)
    CALL ux_dict_free(hataMesaj)
END MAIN
```

> **Ders:** Tablo yalnız ekranda çizilen satır değildir; kararları veriye çevirmektir. Karar veriye çevrilirse program büyürken bozulmaz. Yeni hata kodu eklemek için `IF` zincirini kurcalamazsın; sözlüğe yeni satır eklersin.

### 5.9 Kayıt Tipi: `TYPE`

`TYPE`, veri alanlarını bir kayıt gibi toplar. `TYPE` bir form satırıdır; davranış taşımaz, yalnız düzen verir. Dosya satırı, ölçüm kaydı ve binary yapı için idealdir.

**Sözdizimi:**

```
TYPE Ad
    alan1 AS Tip
    alan2 AS Tip
    ...
END TYPE
```

**Örnek:**

```uxbasic
TYPE Numune
    id AS STRING
    ph AS F64
    oksijen AS F64
    sicaklik AS F64
END TYPE

DIM n AS Numune
n.id = "N-001"
n.ph = 7.4
n.oksijen = 6.8
n.sicaklik = 22.5
PRINT n.id; " "; n.ph
```

**TYPE ile binary dosya kaydı:**

```uxbasic
TYPE OlcumKaydi
    zaman AS F64
    ph AS F64
    sicaklik AS F64
END TYPE

DIM k AS OlcumKaydi
k.zaman = TIMER()
k.ph = 7.15
k.sicaklik = 24.3

OPEN "kayit.bin" FOR OUTPUT AS #1
PUT #1, 1, k
CLOSE #1

PRINT "kayit boyutu="; SIZEOF(OlcumKaydi)
```

`SIZEOF` fonksiyonu bir tipin bellekte kaç bayt yer kapladığını verir. Binary dosyaya `PUT` ile yazılan kayıt, `GET` ile geri okunabilir.

### 5.10 Tampon (Buffer), İşaretçi ve Handle

Tampon [geçici veri alanı] (buffer), veriyi kısa süreli taşımak için ayrılan alandır. Handle [kaynağı temsil eden sayı/adres] ise dosya, liste, sözlük, dış kütüphane nesnesi veya çalışma zamanı kaynağına verilen tutamaktır. İyi kural: **handle açıldıysa kapatılır; tampon ayrıldıysa sınırı bilinir.**

| Araç | Sözdizimi | Ne işe yarar? |
| --- | --- | --- |
| `SETSTRINGSIZE` | `SETSTRINGSIZE metin, uzunluk` | Metin tamponu hazırlar. |
| `VARPTR` | `VARPTR(değişken)` | Değişkenin bellek adresini verir. |
| `SADD` | `SADD(metin)` | Metin içeriğinin adresini verir. |
| `PEEKB/W/D` | `PEEKB(adres)` | Adresten bayt/sözcük/dword okur. |
| `POKEB/W/D` | `POKEB adres, değer` | Adrese bayt/sözcük/dword yazar. |
| `MEMFILLB/W/D` | `MEMFILLB hedef, değer, adet` | Belleği değerle doldurur. |
| `MEMCOPYB/W/D` | `MEMCOPYB hedef, kaynak, adet` | Bellek bloku kopyalar. |
| `INC/DEC` | `INC x` / `DEC x` | Sayaç veya değeri değiştirir. |

**Tampon oluşturma ve doldurma:**

```uxbasic
DIM tampon AS STRING
SETSTRINGSIZE tampon, 256
DIM adres AS PTR
adres = SADD(tampon)
MEMFILLB adres, 0, 256
POKES adres, "uXBasic tampon denemesi"
PRINT tampon
```

### 5.11 Bölüm Özeti

Değişkenler programın bellekte ad verdiği kutulardır; tipler o kutunun biçimini söyler. `DIM` ile değişken açılır, `CONST` ile sabit tanımlanır, `REDIM` ile dizi büyütülür. `ARRAY` sabit boyutlu, `LIST` büyüyen, `DICT` anahtarlı, `SET` tekrarsız koleksiyonlardır. `TYPE` kayıt düzeni için, `PTR` ve handle dış dünya için kullanılır. Unutma: yanlış tip sessiz hata üretir; yanlış dizi boyutu hesapları bozar; her yerde kullanılan çıplak `STRING` zamanla JSON, yol, hata ve raporun birbirine karışmasına yol açar.

---

## BÖLÜM 6: İŞLEÇLER (OPERATORS)

### 6.1 İşleç Nedir?

İşleç, bir veya iki değer arasında bir işlem yapan ve yeni bir değer üreten işarettir. uXBasic'te işleçler beş büyük aileye ayrılır: aritmetik, karşılaştırma, mantıksal, bit düzeyinde ve metin. Ayrıca adres işleçleri, atama işleçleri ve üçlü koşul ifadesi de vardır.

### 6.2 Aritmetik İşleçler

| İşleç | Sözdizimi | Açıklama | Örnek |
| --- | --- | --- | --- |
| `+` | `a + b` | Toplama | `toplam + olcum` |
| `-` | `a - b` | Çıkarma | `a - b` |
| `*` | `a * b` | Çarpma | `x * x` |
| `/` | `a / b` | Kayan nokta bölme | `toplam / adet` |
| `\` | `a \ b` | Tamsayı bölme | `17 \ 5` (sonuç 3) |
| `^` | `a ^ b` | Üs alma | `2 ^ 10` (sonuç 1024) |
| `MOD` | `a MOD b` | Bölme kalanı | `17 MOD 5` (sonuç 2) |

```uxbasic
DIM a AS I32
DIM b AS I32
a = 17
b = 5
PRINT "toplam="; a + b
PRINT "fark="; a - b
PRINT "carpim="; a * b
PRINT "bolme="; a / b
PRINT "tamsayi bolme="; a \ b
PRINT "kalan="; a MOD b
PRINT "us="; 2 ^ 10
```

`MOD` periyodik işlerde çok değerlidir. Ayrı sayaç tutmadan her N'inci ölçümü ayırmak, haftalık gün hesaplamak ve satır renklendirmek için kullanılır.

```uxbasic
FOR i = 1 TO 100
    IF i MOD 10 = 0 THEN PRINT "her 10. numune kontrol="; i
    IF i MOD 2 = 0 THEN PRINT "cift hat" ELSE PRINT "tek hat"
NEXT i
```

### 6.3 Karşılaştırma İşleçleri

Karşılaştırma işleçleri iki değeri karşılaştırır ve `TRUE` ya da `FALSE` döndürür.

| İşleç | Anlamı | Örnek |
| --- | --- | --- |
| `=` | Eşit (aynı zamanda atama) | `IF yas = 18 THEN` |
| `<>` | Eşit değil | `IF (bayrak AND 4) <> 0 THEN` |
| `<` | Küçük | `IF olcum < 0 THEN` |
| `>` | Büyük | `IF yas > 18 THEN` |
| `<=` | Küçük eşit | `IF notu <= 60 THEN` |
| `>=` | Büyük eşit | `IF yas >= 18 THEN` |

```uxbasic
DIM yas AS I32
INPUT yas
IF yas >= 18 THEN
    PRINT "Buyuk projelere baslayabilirsin"
ELSE
    PRINT "Once kucuk alistirmalarla temel kurmali"
END IF
```

> **Dikkat:** uXBasic'te `=` hem atama hem eşitlik için kullanılır. Atama bağlamında `x = 5` derken eşitlik bağlamında `IF x = 5 THEN` yazılır. Bağlamdan hangi anlamda olduğu anlaşılır.

### 6.4 Mantıksal İşleçler

Mantıksal işleçler birden çok koşulu birleştirir.

| İşleç | Sözdizimi | Açıklama | Örnek |
| --- | --- | --- | --- |
| `AND` | `a AND b` | İki koşul/bit birlikte doğruysa doğru verir. | `ph >= 6.5 AND ph <= 8.5` |
| `OR` | `a OR b` | Koşullardan biri doğruysa doğru verir. | `durum = "ACIL" OR stok = 0` |
| `NOT` | `NOT koşul` | Koşulu tersine çevirir. | `NOT bulundu` |
| `XOR` | `a XOR b` | Yalnız biri doğruysa doğru verir. | `a XOR b` |

```uxbasic
DIM ph AS F64
DIM sicaklik AS F64
INPUT ph
INPUT sicaklik

IF ph >= 6.5 AND ph <= 8.5 THEN
    PRINT "pH uygun"
END IF

IF sicaklik < 0 OR sicaklik > 50 THEN
    PRINT "Sicaklik sinir disi"
END IF

IF NOT (ph < 0) THEN
    PRINT "pH negatif degil"
END IF
```

### 6.5 Bit Düzeyinde İşleçler

Bit düzeyinde işleçler, sayıları bit bit işler. Bayrak, renk, izin ve donanım değerlerinde işe yarar.

| İşleç | Sözdizimi | Açıklama |
| --- | --- | --- |
| `AND` | `a AND b` | Bit düzeyinde VE (aynı `AND` işleci, sayısal bağlamda) |
| `OR` | `a OR b` | Bit düzeyinde VEYA |
| `XOR` | `a XOR b` | Bit düzeyinde özel VEYA |
| `SHL` | `a SHL b` | Bitleri sola kaydırır |
| `SHR` | `a SHR b` | Bitleri sağa kaydırır |
| `ROL` | `a ROL b` | Bitleri döndürerek sola kaydırır |
| `ROR` | `a ROR b` | Bitleri döndürerek sağa kaydırır |

`SHL` bitleri sola kaydırır; ikinin kuvvetleriyle çarpma ve bayrak üretmede kullanılır. `1 SHL 3` sonucu `8`'dir (binary `1000`). `SHR` bitleri sağa kaydırır; hızlı bölme ve bayrak ayıklamada kullanılır.

```uxbasic
DIM bayrak AS U32
bayrak = 0
bayrak = bayrak OR 1      ' 0. biti ac
bayrak = bayrak OR 4      ' 2. biti ac
IF (bayrak AND 4) <> 0 THEN PRINT "ucuncu bit acik"
PRINT "kalan="; 17 MOD 5
PRINT "kaydir="; 1 SHL 3
```

### 6.6 Bit Bayrağı Örneği — Çok Durumu Tek Sayıda Tutma

Bit bayrağı tek sayıda birçok doğru/yanlış bilgisi tutar. Sistem programlama ve hızlı durum takibi için zekice bir çözümdür.

```uxbasic
CONST BAYRAK_OK AS U32 = 1 SHL 0       ' 1
CONST BAYRAK_ALARM AS U32 = 1 SHL 1    ' 2
CONST BAYRAK_KAYIT AS U32 = 1 SHL 2    ' 4

DIM durum AS U32
DIM ph AS F64
DIM kayitAcik AS BOOLEAN

ph = 7.2
kayitAcik = TRUE

IF ph >= 6.5 AND ph <= 8.5 THEN
    durum = durum OR BAYRAK_OK
ELSE
    durum = durum OR BAYRAK_ALARM
END IF

IF kayitAcik THEN durum = durum OR BAYRAK_KAYIT

IF (durum AND BAYRAK_ALARM) <> 0 THEN PRINT "alarm var"
IF (durum AND BAYRAK_KAYIT) <> 0 THEN PRINT "kayit acik"
PRINT "durum sayisi="; durum
```

Bu örnekte tek bir `U32` değişkeni içinde üç ayrı durum (OK, ALARM, KAYIT) saklanır. Yeni durum eklemek için yeni bir `1 SHL n` sabiti tanımlamak yeter.

### 6.7 Metin İşleçleri

| İşleç | Sözdizimi | Açıklama | Örnek |
| --- | --- | --- | --- |
| `+` | `s1 + s2` | Metinleri birleştirir. | `"a=" + STR(x)` |

```uxbasic
DIM ad AS STRING
DIM deger AS F64
ad = "olcum"
deger = 7.42
PRINT ad + "=" + STR(deger) + " zaman=" + STR(TIMER())
```

`+` işleci hem sayılar için toplama hem metinler için birleştirme yapar; bağlamdan hangi anlamda olduğu anlaşılır. Sayıları metne bağlamak için `STR` ile çevirmek gerekir.

### 6.8 Atama İşleçleri

| İşleç | Örnek | Anlamı |
| --- | --- | --- |
| `=` | `x = 5` | Basit atama |
| `+=` | `toplam += i` | `toplam = toplam + i` |
| `-=` | `toplam -= i` | `toplam = toplam - i` |
| `*=` | `toplam *= 2` | `toplam = toplam * 2` |
| `/=` | `toplam /= adet` | `toplam = toplam / adet` |
| `\=` | `n \= 10` | `n = n \ 10` |
| `^=` | `x ^= 2` | `x = x ^ 2` |
| `&=` | `metin &= "ek"` | Metin birleştirme ataması |

```uxbasic
DIM toplam AS F64
DIM i AS I32
FOR i = 1 TO 100
    toplam += i
NEXT i
PRINT "1..100 toplami="; toplam
```

Bileşik atama işleçleri kodu kısaltır ama okunurluğu düşürmemeye dikkat et. `toplam += i` gayet açık; `toplam += (a + b) * c - d` gibi karmaşık ifadelerde parantez kullan.

### 6.9 Adres ve İşaretçi İşleçleri

| İşleç | Anlamı | Kullanım |
| --- | --- | --- |
| `@` | Adres alma | `%%PATH_ALIAS @ad = "yol"` örüntüsünde |
| `VARPTR(x)` | Değişkenin adresi | `adres = VARPTR(n)` |
| `SADD(s)` | Metnin adresi | `adres = SADD(metin)` |
| `PEEKB(adres)` | Adresten okuma | `deger = PEEKB(adres)` |
| `POKEB adres, deger` | Adrese yazma | `POKEB adres, 65` |

```uxbasic
DIM n AS I32
DIM adres AS PTR
n = 42
adres = VARPTR(n)
PRINT "n'nin adresindeki deger="; PEEKD(adres)
POKED adres, 100
PRINT "yeni n="; n
```

Adres işleçleri güçlü ama tehlikelidir. Yanlış adrese yazmak programı çökertebilir; bu yüzden yalnızca gerçekten gerekli olduğunda ve `TRY ... CATCH` koruması altında kullan.

### 6.10 İşleç Önceliği

İşlem önceliğini ezberlemek yerine parantez kullan. Derleyici yazarken de aynı kural geçerlidir: belirsizliği okuyucuya bırakma.

Klasik BASIC öncelik sırası (yüksekten düşüğe):

1. Parantez `()`
2. Üs `^`
3. Çarpma `*`, bölme `/`, tamsayı bölme `\`, kalan `MOD`
4. Toplama `+`, çıkarma `-`
5. Karşılaştırma `= <> < > <= >=`
6. Bit düzeyinde `NOT`
7. Bit düzeyinde `AND`
8. Bit düzeyinde `OR`, `XOR`
9. Mantıksal `NOT`
10. Mantıksal `AND`
11. Mantıksal `OR`

```uxbasic
' Ayni sonucu mu verir? Hayir.
PRINT 2 + 3 * 4       ' 14
PRINT (2 + 3) * 4     ' 20
PRINT 2 ^ 3 + 1       ' 9
PRINT 2 ^ (3 + 1)     ' 16
```

> **Kural:** Üç işleçten fazlası yan yana geldiyse parantez kullan. Okuyucu öncelik tablosunu ezbere bilmiyordur.

### 6.11 Üçlü Koşul İfadesi (Ternary)

uXBasic AST'si `TERNARY_EXPR` düğümünü destekler. Üçlü ifade, bir koşula göre iki değerden birini seçer.

```uxbasic
DIM yas AS I32
DIM durum AS STRING
INPUT yas
durum = IIF(yas >= 18, "yetiskin", "cocuk")
PRINT durum
```

`IIF(koşul, a, b)` koşul doğruysa `a`, yanlışsa `b` döndürür. Kısa kararlar için `IF ... THEN ... ELSE ... END IF` yazmaktan kurtarır; ama karmaşık koşullarda yine de açık `IF` bloğu daha okunurdur.

### 6.12 Birlikte Kullanım Örneği — Karmaşık Karar

```uxbasic
DIM ph AS F64
DIM sicaklik AS F64
DIM oksijen AS F64
DIM risk AS I32

ph = 7.2
sicaklik = 24.8
oksijen = 6.1

risk = 0
IF ph < 6.5 OR ph > 8.5 THEN risk += 30
IF sicaklik < 18 OR sicaklik > 28 THEN risk += 20
IF oksijen < 5.0 THEN risk += 40
IF risk = 0 THEN risk += 10

SELECT CASE risk
CASE IS >= 60
    PRINT "Yuksek risk: mudahale gerekli"
CASE IS >= 30
    PRINT "Orta risk: izleme siklastirilmali"
CASE ELSE
    PRINT "Dusuk risk: rutin izlem"
END SELECT
```

Bu örnekte `+=` bileşik atama, `OR` mantıksal işleç, `SELECT CASE IS >=` karşılaştırma ve `+` aritmetik işleç birlikte çalışır. Risk sayısı her koşulda artar; en sonda `SELECT CASE` karar verir.

### 6.13 Bölüm Özeti

İşleçler programın dilini kurar. Aritmetik hesap yapar, karşılaştırma karar verir, mantıksal koşulları birleştirir, bit düzeyinde bayrakları yönetir, metinleri birleştirir ve adresler üzerinden düşük seviye çalışır. Öncelik kuralı basittir: **belirsizlik varsa parantez kullan.** Bir sonraki bölümde bu işleçleri gerçek komutlarla birleştirip akış denetimine geçeceğiz.

---

## BÖLÜM 7: KOMUTLAR — AKIŞ VE KARAR

Akış komutları programın yolunu çizer. Bir program yalnız satır satır ilerlemez; bazen karar verir, bazen tekrar eder, bazen erken çıkar, bazen hatayı yakalayıp temizlenir.

### 7.1 Komut Sınıfları Hakkında Kısa Bilgi

uXBasic'te komutlar sınıflara ayrılır. Bu bölümde "Akış ve karar" sınıfındaki komutları inceleyeceğiz. Komut sınıfları şunlardır:

| Sınıf | İçerdiği komutlar |
| --- | --- |
| Akış ve karar | IF, THEN, ELSE, ELSEIF, END, SELECT, CASE, IS, FOR, TO, STEP, NEXT, DO, LOOP, WHILE, UNTIL, EXIT, EACH, IN, RETURN, GOTO, GOSUB, TRY, CATCH, FINALLY, THROW, ASSERT |
| Girdi, çıktı, ekran ve dosya | PRINT, INPUT, OPEN, CLOSE, GET, PUT, SEEK, CLS, COLOR, LOCATE |
| Yordam ve çağrı | SUB, FUNCTION, DECLARE, CALL, BYREF, BYVAL, CDECL, STDCALL |
| Modül ve kaynak | INCLUDE, IMPORT, MAIN, NAMESPACE, MODULE, USING, ALIAS, INLINE |
| Nesne ve tip bildirimi | TYPE, CLASS, INTERFACE, IMPLEMENTS, METHOD, CONSTRUCTOR, DESTRUCTOR, NEW, DELETE, vb. |
| Değişken ve bellek | DIM, REDIM, AS, CONST |
| Varsayılan tip | DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFEXT, DEFSTR, DEFBYT |
| İşleç | AND, OR, NOT, XOR, MOD, SHL, SHR, ROL, ROR |
| Tipler | I8..U64, F32..F128, BIGI..BALL, BOOLEAN, STRING, OBJECT, PTR, STRPTR, ARRAY, LIST, DICT, SET |
| Bellek ve düşük seviye | PEEKB, PEEKW, PEEKD, POKE, POKEB, POKEW, POKED, POKES, MEMCOPYB/W/D, MEMFILLB/W/D, SETNEWOFFSET, INC, DEC |
| Listeleme | ENUM |
| Olay ve eşzamanlılık | EVENT, THREAD, PARALEL, PIPE, SLOT, ON, OFF, TRIGGER |

### 7.2 IF, THEN, ELSE, ELSEIF, END IF — Koşul

**Sözdizimi:**

```
IF koşul THEN komutlar [ELSE komutlar] END IF
IF koşul THEN
    komutlar
[ELSEIF koşul THEN
    komutlar]
[ELSE
    komutlar]
END IF
```

**Tek satırlık kullanım:**

```uxbasic
IF sicaklik > 30 THEN PRINT "fan ac"
```

**Blok kullanım:**

```uxbasic
IF ph >= 6.5 AND ph <= 8.5 THEN
    PRINT "uygun"
ELSE
    PRINT "sinir disi"
END IF
```

**ELSEIF ile çoklu koşul:**

```uxbasic
DIM notu AS I32
INPUT notu
IF notu >= 85 THEN
    PRINT "AA"
ELSEIF notu >= 70 THEN
    PRINT "BB"
ELSEIF notu >= 60 THEN
    PRINT "CC"
ELSE
    PRINT "FF"
END IF
```

Çok seçenekli karar ağacı kurarken aralıkların çakışmamasına dikkat et. Yukarıdaki örnekte `85 ve üstü`, `70-84`, `60-69`, `0-59` aralıkları çakışmaz.

### 7.3 SELECT CASE — Çok Dallı Karar

`SELECT CASE`, tek bir değişkenin birçok olası değerine göre dallanır. `IF` zincirinden daha temizdir.

**Sözdizimi:**

```
SELECT CASE ifade
    CASE değer1
        komutlar
    CASE değer2
        komutlar
    CASE IS > değer3
        komutlar
    CASE ELSE
        komutlar
END SELECT
```

**Örnek — menü:**

```uxbasic
DIM secim AS I32
PRINT "1=Derle  2=Calistir  3=Cikis"
INPUT secim

SELECT CASE secim
CASE 1
    PRINT "Derleme basladi"
CASE 2
    PRINT "Calistirma basladi"
CASE 3
    PRINT "Cikis"
CASE ELSE
    PRINT "Bilinmeyen secim"
END SELECT
```

**CASE IS ile karşılaştırmalı seçenek:**

```uxbasic
DIM hatali AS I32
hatali = 5

SELECT CASE hatali
CASE 0
    PRINT "parti temiz"
CASE IS <= 3
    PRINT "parti kosullu kabul"
CASE ELSE
    PRINT "parti reddedildi"
END SELECT
```

`CASE IS > değer` biçimi yalnız eşitlik değil, büyüktür/küçüktür gibi sınır da yazmanı sağlar. `CASE ELSE` bilinmeyen durumu güvenli yakalar.

### 7.4 FOR ... TO ... STEP ... NEXT — Sayaçlı Döngü

Kaç tekrar yapılacağı belliyse `FOR` en temiz döngüdür. Dizi, veri satırı, test listesi ve gün sayımı için kullanılır.

**Sözdizimi:**

```
FOR sayac = ilk TO son [STEP adim]
    komutlar
NEXT [sayac]
```

**1'den 10'a kadar:**

```uxbasic
FOR i = 1 TO 10
    PRINT i
NEXT i
```

**İkişer ilerleyen:**

```uxbasic
FOR i = 1 TO 20 STEP 2
    PRINT i
NEXT i
```

**Geri sayan:**

```uxbasic
FOR i = 10 TO 0 STEP -1
    PRINT i
NEXT i
PRINT "ates!"
```

`STEP` negatif olursa sayaç azalır. Geri sayım, seyreltme ve geriye dönük tarama işlerinde kullanılır.

### 7.5 DO ... LOOP — Koşullu Döngü

Bitiş koşulu veriye bağlıysa `DO` döngüsü kullanılır. Kullanıcı çıkış yazana kadar, dosya bitene kadar veya kuyruk boşalana kadar döner.

**Sözdizimi:**

```
DO WHILE koşul
    komutlar
LOOP

DO
    komutlar
LOOP UNTIL koşul
```

`DO WHILE` koşulu başta denetler; koşul yanlışsa döngü hiç çalışmaz. `LOOP UNTIL` koşulu sonda denetler; döngü en az bir kez çalışır.

**Dosya sonuna kadar okuma:**

```uxbasic
OPEN "olcum.csv" FOR INPUT AS #1
DIM satir AS STRING
DO WHILE EOF(#1) = 0
    INPUT #1, satir
    PRINT satir
LOOP
CLOSE #1
```

**Kullanıcı çıkış yazana kadar:**

```uxbasic
DIM cevap AS STRING
DO
    INPUT "Komut (Q=cikis): ", cevap
    PRINT "Islenen: "; cevap
LOOP UNTIL cevap = "Q"
```

### 7.6 WHILE ... WEND — Klasik Döngü

`WHILE ... WEND`, eski BASIC geleneğinin döngüsüdür. `DO WHILE ... LOOP` ile aynı görevi yapar.

```uxbasic
DIM pil AS I32
pil = 100
WHILE pil > 20
    pil = pil - 1
WEND
PRINT "Pil kritik seviyede"
```

Yeni kodda `DO WHILE ... LOOP` tercih edilir; ama eski kaynakları taşırken `WHILE ... WEND` görülebilir.

### 7.7 EXIT — Erken Çıkış

`EXIT`, içinde bulunulan döngüden veya yordamdan erken çıkmayı sağlar. Arama bittiğinde veya hata bulunduğunda gereksiz tekrarları keser.

| Komut | Görev |
| --- | --- |
| `EXIT FOR` | FOR döngüsünden çıkar |
| `EXIT DO` | DO döngüsünden çıkar |
| `EXIT FUNCTION` | Fonksiyondan çıkar |
| `EXIT SUB` | Alt yordamdan çıkar |

```uxbasic
DIM i AS I32
DIM hedef AS I32
hedef = 42

FOR i = 1 TO 1000
    IF i = hedef THEN
        PRINT "Bulundu: "; i
        EXIT FOR
    END IF
NEXT i
PRINT "Arama bitti"
```

### 7.8 FOR EACH ... IN — Koleksiyon Gezme

Koleksiyonları sayaçla uğraşmadan dolaşır. Liste ve sözlük anahtarlarında okunurluk sağlar.

```uxbasic
DIM isimler AS LIST OF STRING
LIST_ADD isimler, "Ali"
LIST_ADD isimler, "Ayse"
LIST_ADD isimler, "Veli"

FOR EACH ad IN isimler
    PRINT UCASE(ad)
NEXT ad
```

### 7.9 GOTO ve GOSUB — Eski BASIC Atlama

`GOTO`, belirtilen etikete doğrudan atlar. Eski BASIC uyumu ve kısa kurtarma dışında yeni kodda dikkatli kullanılmalıdır. `GOSUB`, etikete gider ve `RETURN` ile geri döner.

```uxbasic
DIM x AS I32
x = 5
IF x < 0 THEN GOTO Hata
PRINT "x pozitif"
GOTO Bitis

Hata:
PRINT "x negatif"

Bitis:
PRINT "Program bitti"
```

Yeni kodda `SUB`, `FUNCTION` ve `TRY/CATCH` daha temiz yapılar sunduğu için `GOTO`'ya nadiren ihtiyaç duyulur.

### 7.10 TRY, CATCH, FINALLY, THROW, ASSERT — Hata Yönetimi

Hata çıkabilecek işi güvenli bölgeye almak için `TRY ... CATCH ... FINALLY ... END TRY` kullanılır. `THROW` senin fırlattığın hatadır; `ASSERT` test sırasında koşul kilididir.

**Sözdizimi:**

```
TRY
    komutlar
CATCH hataAdi
    komutlar
[FINALLY
    komutlar]
END TRY
```

**Temel örnek:**

```uxbasic
TRY
    OPEN "veri.csv" FOR INPUT AS #1
CATCH e
    PRINT "dosya acilamadi: "; e
END TRY
```

**FINALLY ile temizlik:**

```uxbasic
TRY
    OPEN "veri.csv" FOR INPUT AS #1
    ' dosya islemleri
CATCH e
    PRINT "hata: "; e
FINALLY
    CLOSE #1
END TRY
```

`FINALLY` hata olsa da olmasa da en son çalışacak temizlik bölümüdür. Dosya kapatma, bağlantı bırakma ve geçici tampon temizleme burada yapılır.

**THROW ile kendi hatanı fırlatma:**

```uxbasic
DIM yas AS I32
INPUT yas
IF yas < 0 THEN THROW "yas negatif olamaz"
PRINT "yas="; yas
```

**ASSERT ile test koşulu:**

```uxbasic
DIM adet AS I32
adet = 30
ASSERT adet > 0
PRINT "adet gecerli"
```

`ASSERT` geliştirme sırasında beklenen koşulu kilitler. Koşul yanlışsa program durur ve hata verir.

### 7.11 İleri Teknik — Üretim Kalite Kontrolü (Satır Satır Anlatım)

Aşağıdaki program 30 ölçüm alır, hatalı sayısını sayar ve sonucu `SELECT CASE` ile yönetim kararına çevirir. Her satırı tek tek açıklayacağız.

```uxbasic
CONST ALT AS F64 = 98.5
CONST UST AS F64 = 101.5
DIM olcum(30) AS F64
DIM i AS I32
DIM hatali AS I32
DIM toplam AS F64

FOR i = 1 TO 30
    INPUT olcum(i)
    IF olcum(i) < ALT OR olcum(i) > UST THEN
        hatali = hatali + 1
        PRINT "uyari satir="; i; " deger="; olcum(i)
    ELSE
        toplam = toplam + olcum(i)
    END IF
NEXT i

SELECT CASE hatali
CASE 0
    PRINT "parti temiz"
CASE IS <= 3
    PRINT "parti kosullu kabul; ek kontrol gerekli"
CASE ELSE
    PRINT "parti reddedildi; makine ayari incelenecek"
END SELECT

IF hatali < 30 THEN PRINT "saglam ortalama="; toplam / (30-hatali)
```

**Satır satır açıklama:**

1. `CONST ALT AS F64 = 98.5` — Alt sınır sabitini tanımlar. Üretimde her ölçüm 98.5'ten küçükse hatalı sayılacak.
2. `CONST UST AS F64 = 101.5` — Üst sınır sabitini tanımlar. 101.5'ten büyük ölçüm hatalı sayılacak.
3. `DIM olcum(30) AS F64` — 30 elemanlı bir ölçüm dizisi açar. Her eleman çift duyarlıklı ondalık sayı taşır.
4. `DIM i AS I32` — Döngü sayacı için 32 bit tam sayı ayırır.
5. `DIM hatali AS I32` — Hatalı ölçüm sayısını tutacak sayaç. Başlangıç değeri `0`.
6. `DIM toplam AS F64` — Sağlam ölçümlerin toplamı. Ortalama hesabında kullanılacak.
7. `FOR i = 1 TO 30` — 1'den 30'a kadar sayan döngüyü başlatır.
8. `INPUT olcum(i)` — Kullanıcıdan veya dosyadan i'inci ölçümü okur ve diziye koyar.
9. `IF olcum(i) < ALT OR olcum(i) > UST THEN` — Ölçüm alt sınırın altında veya üst sınırın üstünde mı diye denetler. `OR` ile iki koşuldan biri bile doğruysa blok çalışır.
10. `hatali = hatali + 1` — Hatalı sayaçını bir artırır.
11. `PRINT "uyari satir="; i; " deger="; olcum(i)` — Hangi satırda hangi değerin hatalı olduğunu ekrana yazar. Bu satır operatörün mudahale etmesi için ipucu verir.
12. `ELSE` — Ölçüm sınırlar içindeyse bu blok çalışır.
13. `toplam = toplam + olcum(i)` — Sağlam ölçümü toplama ekler. Ortalama hesabı için gereklidir.
14. `END IF` — Koşul bloğunu kapatır.
15. `NEXT i` — Döngüyü bir sonraki `i` değerine geçirir.
16. `SELECT CASE hatali` — Hatalı sayısına göre karar vermeye başlar.
17. `CASE 0` — Hiç hata yoksa.
18. `PRINT "parti temiz"` — Parti temiz kabul edilir.
19. `CASE IS <= 3` — Hatalı sayısı 3 veya daha azsa.
20. `PRINT "parti kosullu kabul; ek kontrol gerekli"` — Parti şartlı kabul edilir.
21. `CASE ELSE` — Diğer tüm durumlar (4 ve üstü hatalı).
22. `PRINT "parti reddedildi; makine ayari incelenecek"` — Parti reddedilir.
23. `END SELECT` — SELECT bloğunu kapatır.
24. `IF hatali < 30 THEN` — Eğer tüm ölçümler hatalı değilse (bölme sıfıra düşmesin).
25. `PRINT "saglam ortalama="; toplam / (30-hatali)` — Sağlam ölçümlerin ortalamasını yazdırır.

**Programın çalışması — örnek senaryo:**

Girdi: 100.0, 100.5, 99.8, 102.0, 98.0, 100.2, ..., 99.5 (30 değer)
Varsayalım 2 değer sınır dışı (102.0 ve 98.0).

Çıktı:
```
uyari satir= 4 deger= 102
uyari satir= 5 deger= 98
parti kosullu kabul; ek kontrol gerekli
saglam ortalama= 100.1
```

> **Ders:** Hile şudur: kalite kararını yüzlerce `IF` yerine önce sayaçla özetliyoruz, sonra `SELECT CASE` ile yönetim kararına çeviriyoruz. Karar ile hesap ayrıdır; bu sayede karar kuralları değiştiğinde hesap bölümü dokunulmaz.

### 7.12 İleri Teknik — Menü, Dosya ve Hata Yakalama (Satır Satır Anlatım)

Bu örnek kullanıcıya seçenek sunar, derleyici komut satırı üretir ve hata yakalama ile güvenliği sağlar.

```uxbasic
DIM secim AS I32
DIM kaynak AS STRING

PRINT "1=AST  2=MIR  3=JS  4=Cikis"
INPUT secim
INPUT kaynak

TRY
    SELECT CASE secim
    CASE 1
        PRINT "uxb ast "; kaynak; " --ast-json-out out/ast.json"
    CASE 2
        PRINT "uxb mir "; kaynak; " --mir-full-json-out out/mir.json"
    CASE 3
        PRINT "uxb jsw "; kaynak; " --emit-js --js-out dist/program.js"
    CASE 4
        PRINT "cikis"
    CASE ELSE
        THROW "bilinmeyen secim"
    END SELECT
CATCH e
    PRINT "menu hatasi: "; e
FINALLY
    PRINT "oturum kapandi"
END TRY
```

**Satır satır açıklama:**

1. Kullanıcıya dört seçenekli bir menü gösterilir.
2. `INPUT secim` ile seçenek, `INPUT kaynak` ile dosya adı alınır.
3. `TRY` bloğu hata çıkabilecek bölgeyi açar.
4. `SELECT CASE secim` dört ana yola ayırır.
5. Her `CASE` kendi komut satırını üretir.
6. `CASE ELSE` bilinmeyen seçimi yakalar ve `THROW "bilinmeyen secim"` ile hata fırlatır.
7. `CATCH e` hatayı yakalar, ekrana yazar.
8. `FINALLY` her durumda "oturum kapandi" mesajını basar.

Bu örneğin püf noktası: hata fırlatma, yakalama ve temizlik tek bir blok içinde düzenli çalışır. Kullanıcı yanlış seçim yaparsa `THROW` ile hata görünür olur, `CATCH` bunu yakalar, `FINALLY` oturumun kapandığını bildirir.

### 7.13 İleri Teknik — Dosya Sonuna Kadar Okuma ve Erken Çıkış

```uxbasic
OPEN "olcum.csv" FOR INPUT AS #1
DIM satir AS STRING
DIM adet AS I32
DIM toplam AS F64
DIM deger AS F64

DO WHILE EOF(#1) = 0
    INPUT #1, satir
    IF LEN(satir) = 0 THEN EXIT DO
    deger = VAL(satir)
    IF deger < 0 THEN EXIT DO
    toplam = toplam + deger
    adet = adet + 1
LOOP
CLOSE #1

IF adet > 0 THEN
    PRINT "ortalama="; toplam / adet
ELSE
    PRINT "gecerli veri yok"
END IF
```

Bu örnekte döngü sayısı önceden bilinmez. `EOF` dosya sonunu, `DO WHILE` koşulu, `EXIT DO` erken çıkışı, `VAL` metin-sayı dönüşümü, `LEN` boş satır denetimi, `OPEN/CLOSE` dosya yaşam döngüsü birlikte çalışır.

### 7.14 Bölüm Özeti

Akış komutları programın yolunu çizer. `IF` karar verir, `SELECT CASE` dallandırır, `FOR` sayar, `DO` koşula bakar, `WHILE` klasik döngü kurar, `EXIT` erken çıkarır, `TRY/CATCH/FINALLY` hata yönetir, `THROW` hata fırlatır, `ASSERT` koşul kilitler. Akış sınıfının altın kuralı şudur: **her döngünün bir çıkış yolu, her kararın anlaşılır nedeni, her riskli işin hata planı olmalıdır.**

---

# Programcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek (Devam)

---

## BÖLÜM 8: KOMUTLAR — GİRDİ, ÇIKTI, EKRAN VE DOSYA

Girdi çıktı komutları programın dış dünya ile konuştuğu kapıdır. `PRINT` sonucu gösterir, `INPUT` veri alır, `OPEN` dosya açar, `CLOSE` kapatır, `GET` ve `PUT` ham veriyi taşır, `SEEK` dosya konumunu değiştirir. Bu sınıfın altın kuralı şudur: **açtığın her kaynağı kapat, yazdığın her dosyanın gerçekten oluştuğunu kontrol et.**

### 8.1 PRINT — Ekrana veya Dosyaya Yazma

**Sözdizimi:**

```
PRINT ifade [; ifade] ...
PRINT #dosya, ifade [; ifade] ...
```

`PRINT` ekrana ya da dosyaya metin veya sayı yazar. İfadeler arasındaki `;` işareti boşluk bırakmadan yan yana yazmayı sağlar; `,` işareti ise sekme duraklarına yaslar.

**Temel kullanım:**

```uxbasic
PRINT "Merhaba dunya"
PRINT "sonuc="; 42
PRINT "ad="; "Ali"; " yas="; 25
```

Çıktı:

```
Merhaba dunya
sonuc= 42
ad=Ali yas= 25
```

**Sayı ve metin birleştirme:**

```uxbasic
DIM ph AS F64
DIM sicaklik AS F64
ph = 7.42
sicaklik = 24.8
PRINT "pH=" + STR(ph) + " sicaklik=" + STR(sicaklik)
PRINT "pH="; ph; " sicaklik="; sicaklik
```

İki satır da benzer çıktı verir. `+` ile birleştirme yaparken `STR` ile sayıyı metne çevirmek gerekir; `;` ile yan yana yazarken çevrim otomatik olur.

**Dosyaya yazma:**

```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Gunluk rapor"
PRINT #1, "ortalama="; 7.32
PRINT #1, "hata adedi="; 2
CLOSE #1
PRINT "rapor yazildi"
```

### 8.2 INPUT — Kullanıcıdan veya Dosyadan Veri Okuma

**Sözdizimi:**

```
INPUT değişken
INPUT "istem", değişken
INPUT #dosya, değişken
```

`INPUT` kullanıcıdan klavye ile veya dosyadan veri okur. İstem (prompt) vermek için `"istem",` biçimi kullanılır.

**Klavyeden okuma:**

```uxbasic
DIM ad AS STRING
DIM yas AS I32
INPUT "Adiniz: ", ad
INPUT "Yasiniz: ", yas
PRINT "Merhaba "; ad; " yas "; yas
```

**Dosyadan okuma:**

```uxbasic
OPEN "veri.txt" FOR INPUT AS #1
DIM satir AS STRING
DO WHILE EOF(#1) = 0
    INPUT #1, satir
    PRINT satir
LOOP
CLOSE #1
```

`EOF(#1)` dosya sonuna gelinip gelinmediğini söyler. Dosya sonuna gelindiğinde `EOF` `1` (doğru) döner; aksi hâlde `0` (yanlış). `DO WHILE EOF(#1) = 0` "dosya sonu olmadığı sürece" demektir.

### 8.3 OPEN — Dosya Açma

**Sözdizimi:**

```
OPEN "yol" FOR INPUT|OUTPUT|APPEND AS #no
```

| Mod | Anlamı |
| --- | --- |
| `INPUT` | Okuma için açar. Dosya yoksa hata verir. |
| `OUTPUT` | Yazma için açar. Dosya varsa üzerine yazar. |
| `APPEND` | Ekleme için açar. Dosya sonuna yazar. |

**Örnek — üç mod karşılaştırması:**

```uxbasic
' OUTPUT: yeni dosya yazar
OPEN "gunluk.txt" FOR OUTPUT AS #1
PRINT #1, "ilk satir"
CLOSE #1

' APPEND: var olan dosyaya ekler
OPEN "gunluk.txt" FOR APPEND AS #1
PRINT #1, "ikinci satir"
CLOSE #1

' INPUT: dosyayi okur
OPEN "gunluk.txt" FOR INPUT AS #1
DIM satir AS STRING
DO WHILE EOF(#1) = 0
    INPUT #1, satir
    PRINT satir
LOOP
CLOSE #1
```

Çıktı:

```
ilk satir
ikinci satir
```

### 8.4 CLOSE — Dosya Kapatma

**Sözdizimi:**

```
CLOSE #no
CLOSE
```

`CLOSE #no` yalnız belirli bir dosyayı kapatır. `CLOSE` tek başına tüm açık dosyaları kapatır. Açılan her dosya mutlaka kapatılmalıdır; aksi hâlde veri kaybı veya dosya kilidi oluşabilir.

### 8.5 GET ve PUT — Ham Veri Okuma/Yazma

`GET` ve `PUT` ikili (binary) dosyalarda ham veri okuyup yazar. Metin değil, bellek düzeni taşır. Kayıt tipi (`TYPE`) ile birlikte kullanıldığında sabit uzunluklu kayıtlar dosyaya yazılabilir.

**Sözdizimi:**

```
GET #no, konum, değişken
PUT #no, konum, değişken
```

**Örnek — TYPE ile binary kayıt:**

```uxbasic
TYPE OlcumKaydi
    zaman AS F64
    ph AS F64
    sicaklik AS F64
END TYPE

DIM k AS OlcumKaydi
k.zaman = TIMER()
k.ph = 7.15
k.sicaklik = 24.3

OPEN "kayit.bin" FOR OUTPUT AS #1
PUT #1, 1, k
CLOSE #1

PRINT "kayit boyutu="; SIZEOF(OlcumKaydi); " bayt"

' Geri oku
OPEN "kayit.bin" FOR INPUT AS #1
GET #1, 1, k
CLOSE #1

PRINT "okunan: zaman="; k.zaman; " ph="; k.ph; " sicaklik="; k.sicaklik
```

`PUT #1, 1, k` kaydı dosyanın 1. konumuna yazar. `GET #1, 1, k` ise 1. konumdan okur. Konum, kayıt numarasıdır; her kayıt `SIZEOF(OlcumKaydi)` bayt yer kaplar.

### 8.6 SEEK — Dosya Konumunu Değiştirme

**Sözdizimi:**

```
SEEK #no, konum
```

`SEEK` dosyada okuma/yazma konumunu belirler. Büyük dosyalarda belirli bir kayda atlamak için kullanılır.

```uxbasic
TYPE Kayit
    id AS I32
    deger AS F64
END TYPE

DIM k AS Kayit
OPEN "kayitlar.bin" FOR OUTPUT AS #1
FOR i = 1 TO 100
    k.id = i
    k.deger = i * 1.5
    PUT #1, i, k
NEXT i
CLOSE #1

' 50. kayda atla
OPEN "kayitlar.bin" FOR INPUT AS #1
SEEK #1, 50
GET #1, 50, k
CLOSE #1
PRINT "50. kayit: id="; k.id; " deger="; k.deger
```

### 8.7 CLS, COLOR, LOCATE — Ekran Komutları

Konsol programında ekranı temizlemek, renk ayarlamak ve imleci konumlandırmak için bu üç komut kullanılır.

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `CLS` | `CLS` | Ekranı temizler. |
| `COLOR` | `COLOR ön[, arka]` | Yazı/arka plan rengini ayarlar. |
| `LOCATE` | `LOCATE satır, sütun` | İmleci konuma taşır. |

**Renk kodları:**

| Kod | Renk | Kod | Renk |
| --- | --- | --- | --- |
| 0 | Siyah | 8 | Gri |
| 1 | Lacivert | 9 | Açık mavi |
| 2 | Yeşil | 10 | Açık yeşil |
| 3 | Turkuaz | 11 | Açık turkuaz |
| 4 | Kırmızı | 12 | Açık kırmızı |
| 5 | Mor | 13 | Açık mor |
| 6 | Sarı | 14 | Açık sarı |
| 7 | Beyaz | 15 | Parlak beyaz |

**Örnek — durum paneli:**

```uxbasic
CLS
COLOR 15, 1
LOCATE 1, 1: PRINT "uXBasic saha paneli"
COLOR 10, 0
FOR i = 1 TO 5
    LOCATE i + 2, 3
    PRINT "sensor "; i; " aktif"
NEXT i
COLOR 7, 0
LOCATE 10, 1: PRINT "panel bitti"
```

Bu örnekte `CLS` ekranı temizler, `COLOR 15, 1` parlak beyaz yazıyı lacivert zemin üzerine koyar, `LOCATE 1, 1` imleci sol üst köşeye taşır. Daha sonra yeşil yazıya geçilip beş sensor satırı yazılır.

### 8.8 İleri Teknik — CSV Okuyup Kalite Raporu Yazma (Satır Satır Anlatım)

Aşağıdaki program bir CSV dosyasından ölçüm okur, her satırı sınır denetiminden geçirir ve sonucu başka bir dosyaya yazar.

```uxbasic
OPEN "kalite.csv" FOR INPUT AS #1
OPEN "sonuc.txt" FOR OUTPUT AS #2

DIM satir AS STRING
DIM deger AS F64
DIM sira AS I32

DO WHILE EOF(#1) = 0
    INPUT #1, satir
    sira = sira + 1
    deger = VAL(satir)
    IF deger < 98.5 OR deger > 101.5 THEN
        PRINT #2, "satir="; sira; ";hata="; deger
    ELSE
        PRINT #2, "satir="; sira; ";ok="; deger
    END IF
LOOP

CLOSE #1
CLOSE #2
PRINT "rapor yazildi"
```

**Satır satır açıklama:**

1. `OPEN "kalite.csv" FOR INPUT AS #1` — `kalite.csv` dosyasını okuma için açar, dosya numarası `#1` olarak verir.
2. `OPEN "sonuc.txt" FOR OUTPUT AS #2` — `sonuc.txt` dosyasını yazma için açar, dosya numarası `#2` olarak verir. Aynı anda iki dosya açık.
3. `DIM satir AS STRING` — Okunan satırı tutacak metin değişkeni.
4. `DIM deger AS F64` — Satırın sayıya çevrilmiş hâli.
5. `DIM sira AS I32` — Satır sayacı. Hangi satırda hata var diye raporlamak için.
6. `DO WHILE EOF(#1) = 0` — 1 numaralı dosyanın sonuna gelinmediği sürece döngüyü sürdür.
7. `INPUT #1, satir` — `#1` dosyasından bir satır oku, `satir` değişkenine koy.
8. `sira = sira + 1` — Satır sayacını bir artır.
9. `deger = VAL(satir)` — Metni sayıya çevir. `VAL("99.8")` sonucu `99.8`.
10. `IF deger < 98.5 OR deger > 101.5 THEN` — Ölçüm alt sınırın altında veya üst sınırın üstünde mı?
11. `PRINT #2, "satir="; sira; ";hata="; deger` — Hatalıysa `#2` dosyasına hata satırı yaz.
12. `ELSE` — Ölçüm sınırlar içindeyse.
13. `PRINT #2, "satir="; sira; ";ok="; deger` — `#2` dosyasına "ok" satırı yaz.
14. `END IF` — Koşul bloğunu kapat.
15. `LOOP` — Döngünün başına dön.
16. `CLOSE #1` — Okuma dosyasını kapat.
17. `CLOSE #2` — Yazma dosyasını kapat. Bu satır olmadan veriler diske yazılmayabilir.
18. `PRINT "rapor yazildi"` — Ekrana bilgilendirme mesajı yaz.

**Örnek çalışma:**

`kalite.csv` içeriği:
```
100.2
99.5
102.3
98.7
101.0
```

`sonuc.txt` içeriği:
```
satir= 1 ;ok= 100.2
satir= 2 ;ok= 99.5
satir= 3 ;hata= 102.3
satir= 4 ;ok= 98.7
satir= 5 ;ok= 101
```

> **Ders:** Dosya okuma/yazma örneği gerçek iş yapar: veri alır, sınıflandırır, başka dosyaya raporlar. `CLOSE` unutulursa dosya bozulma riski artar. Bu yüzden iyi alışkanlık: `OPEN` ile `CLOSE`'u aynı blok içinde düşün, hatta `TRY ... FINALLY` ile koru.

### 8.9 İleri Teknik — TRY/FINALLY ile Güvenli Dosya İşleme

```uxbasic
DIM satir AS STRING
DIM adet AS I32
DIM toplam AS F64

TRY
    OPEN "olcumler.txt" FOR INPUT AS #1
    OPEN "temiz_rapor.csv" FOR OUTPUT AS #2
    PRINT #2, "no;ham;deger;durum"

    DO WHILE EOF(#1) = 0
        INPUT #1, satir
        adet = adet + 1
        toplam = toplam + VAL(satir)
        PRINT #2, STR(adet) + ";" + satir + ";" + STR(VAL(satir)) + ";OK"
    LOOP

    IF adet > 0 THEN
        PRINT #2, "ortalama;;;" + STR(toplam / adet)
    END IF
CATCH e
    PRINT "Dosya isleme hatasi: "; e
FINALLY
    CLOSE #1
    CLOSE #2
END TRY
```

`FINALLY` bloğunda iki `CLOSE` çağrısı her durumda çalışır: hata olsa da olmasa da dosyalar kapatılır. Bu, dosya kilidi ve veri kaybı riskini azaltır.

### 8.10 INKEY ve GETKEY — Tuş Okuma

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `INKEY()` | `INKEY([bekleme])` | Beklemeden basılan tuşu okur. |
| `GETKEY()` | `GETKEY()` | Bir tuşa basılmasını bekler ve kodunu verir. |

```uxbasic
DIM tus AS STRING
PRINT "Cikis icin Q'ya bas"
DO
    tus = INKEY()
    IF LEN(tus) > 0 THEN PRINT "Tus: "; tus
LOOP UNTIL tus = "Q" OR tus = "q"
PRINT "Cikildi"
```

`INKEY` tuşa basılmasa bile hemen döner; bu yüzden döngü içinde sık sık denetlenir. `GETKEY` ise tuşa basılana kadar bekler.

### 8.11 Bölüm Özeti

Girdi çıktı komutları programın dış dünya ile konuştuğu kapıdır. `PRINT` yazar, `INPUT` okur, `OPEN` dosya açar, `CLOSE` kapatır, `GET/PUT` ham veriyi taşır, `SEEK` konum değiştirir, `CLS/COLOR/LOCATE` ekranı yönetir. İyi alışkanlık: **açtığın her dosyayı kapat, yazdığın her veriyi doğrula, hata çıkabilecek dosya işlerini `TRY/FINALLY` içine al.**

---

## BÖLÜM 9: KOMUTLAR — YORDAM, MODÜL VE NESNE

Bu bölümde programı parçalara ayıran en önemli araçları inceleyeceğiz: alt yordam (`SUB`), fonksiyon (`FUNCTION`), dış çağrı bildirimi (`DECLARE`), çağrı (`CALL`), modül (`MODULE`), ad alanı (`NAMESPACE`), kullanım (`USING`), kısaltma (`ALIAS`), sınıf (`CLASS`), kayıt (`TYPE`), arayüz (`INTERFACE`), miras (`IMPLEMENTS`), yöntem (`METHOD`), kurucu (`CONSTRUCTOR`), yıkıcı (`DESTRUCTOR`), nesne üretme (`NEW`) ve yok etme (`DELETE`).

### 9.1 SUB — Değer Döndürmeyen Alt Yordam

`SUB`, değer döndürmeyen tekrar kullanılabilir iş bloğudur. Başlık yazma, dosyaya kaydetme, ekran güncelleme gibi işler için uygundur.

**Sözdizimi:**

```
SUB Ad([parametreler])
    komutlar
END SUB
```

**Örnek:**

```uxbasic
SUB BaslikYaz()
    PRINT "===================="
    PRINT "   uXBasic Raporu   "
    PRINT "===================="
END SUB

SUB SelamVer(ad AS STRING)
    PRINT "Merhaba "; ad
END SUB

MAIN
    CALL BaslikYaz()
    CALL SelamVer("Ali")
    CALL SelamVer("Ayse")
END MAIN
```

`CALL` ile alt yordam çağrılır. Parametre parantezleri zorunlu değildir ama okunurluk için kullanılması önerilir.

### 9.2 FUNCTION — Değer Döndüren Fonksiyon

`FUNCTION`, hesap yapar ve sonuç döndürür. Ortalama, dönüştürme, doğrulama, metin temizleme gibi işlerde kullanılır.

**Sözdizimi:**

```
FUNCTION Ad([parametreler]) AS Tip
    komutlar
    RETURN değer
END FUNCTION
```

**Örnek:**

```uxbasic
FUNCTION Kare(x AS F64) AS F64
    RETURN x * x
END FUNCTION

FUNCTION Ortalama(a AS F64, b AS F64) AS F64
    RETURN (a + b) / 2.0
END FUNCTION

FUNCTION Etiketle(ph AS F64) AS STRING
    IF ph < 6.5 THEN
        RETURN "asidik"
    ELSEIF ph > 8.5 THEN
        RETURN "bazik"
    ELSE
        RETURN "normal"
    END IF
END FUNCTION

MAIN
    PRINT "Kare(5)="; Kare(5)
    PRINT "Ortalama(10,20)="; Ortalama(10, 20)
    PRINT "Etiket(7.2)="; Etiketle(7.2)
END MAIN
```

`RETURN` fonksiyondan sonuç döndürür ve fonksiyondan çıkar. Bir fonksiyon birden fazla `RETURN` içerebilir; ilk çalıştığında fonksiyon biter.

### 9.3 BYVAL ve BYREF — Parametre Aktarım Biçimleri

| Belirleyici | Görev |
| --- | --- |
| `BYVAL` | Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez. |
| `BYREF` | Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir. |

Varsayılan davranış `BYVAL`'dır. `BYREF` kullanırsan fonksiyon çağıran tarafın değişkenini değiştirebilir.

**BYVAL örneği:**

```uxbasic
SUB Degistir(BYVAL x AS I32)
    x = 100
    PRINT "fonksiyon icinde x="; x
END SUB

MAIN
    DIM a AS I32
    a = 5
    CALL Degistir(a)
    PRINT "fonksiyon sonrasi a="; a
END MAIN
```

Çıktı:
```
fonksiyon icinde x= 100
fonksiyon sonrasi a= 5
```

`a` fonksiyon içinde değişmedi; çünkü `BYVAL` kopya gönderdi.

**BYREF örneği:**

```uxbasic
SUB Artir(BYREF x AS I32)
    x = x + 1
END SUB

MAIN
    DIM a AS I32
    a = 5
    CALL Artir(a)
    PRINT "a="; a
END MAIN
```

Çıktı:
```
a= 6
```

`BYREF` sayesinde `a` fonksiyon içinde değişti.

**BYREF ile birden çok değer döndürme:**

```uxbasic
SUB OlcumEkle(BYREF toplam AS F64, BYREF adet AS I32, BYVAL deger AS F64)
    IF deger < 0 THEN EXIT SUB
    toplam = toplam + deger
    adet = adet + 1
END SUB

MAIN
    DIM t AS F64
    DIM n AS I32
    DIM i AS I32
    DIM x AS F64

    FOR i = 1 TO 5
        INPUT x
        CALL OlcumEkle(t, n, x)
    NEXT i

    IF n > 0 THEN PRINT "ortalama="; t / n
END MAIN
```

Bu örnekte `toplam` ve `adet` çağıran tarafta değişir. `BYVAL deger` ise güvenli kopyadır; yordam ölçüm değerini değiştirse bile asıl değişkene zarar vermez.

### 9.4 DECLARE — Dış Fonksiyon Bildirimi

`DECLARE`, dış kütüphane (DLL) veya API fonksiyonunun uXBasic tarafındaki imzasını bildirir.

**Sözdizimi:**

```
DECLARE [CDECL|STDCALL] FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (parametreler) AS Tip
```

| Belirleyici | Görev |
| --- | --- |
| `LIB "dll"` | Hangi dinamik kütüphaneden yükleneceğini söyler. |
| `ALIAS "ad"` | DLL içindeki gerçek fonksiyon adını verir. |
| `CDECL` | C çağrı düzenini belirtir. |
| `STDCALL` | Windows API çağrı düzenini belirtir. |

**Örnek — Windows Beep:**

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

MAIN
    Beep(800, 200)
    PRINT "ses calisti"
END MAIN
```

**C kütüphanesinden fonksiyon:**

```uxbasic
DECLARE CDECL FUNCTION Cos LIB "msvcrt.dll" ALIAS "cos" (BYVAL x AS F64) AS F64

MAIN
    PRINT "cos(0)="; Cos(0)
    PRINT "cos(3.14159)="; Cos(3.14159)
END MAIN
```

### 9.5 CALL — Yordam ve Dış Çağrı

**Sözdizimi:**

```
CALL Ad(argümanlar)
CALL(DLL, "dll", "fonksiyon", argümanlar)
CALL(API, "servis", "iş", argümanlar)
```

| Biçim | Görev |
| --- | --- |
| `CALL Ad(...)` | Tanımlı yordamı çağırır. |
| `CALL(DLL, ...)` | Dinamik DLL çağrısı yapar. |
| `CALL(API, ...)` | Çalışma zamanı API servisini çağırır. |

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

SUB UyariSesi(seviye AS I32)
    IF seviye = 1 THEN Beep(800, 120)
    IF seviye = 2 THEN Beep(1200, 180)
    IF seviye = 3 THEN Beep(1600, 250)
END SUB

MAIN
    CALL UyariSesi(2)
    PRINT "uyari verildi"
END MAIN
```

### 9.6 INCLUDE, IMPORT — Kaynak ve Dış Kod Ekleme

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `INCLUDE` | `INCLUDE "dosya.uxbh"` | Başka uXBasic başlık/destek dosyasını kaynak içine katar. |
| `IMPORT` | `IMPORT(C, "dosya.c")` | C/C++/ASM kaynak dosyasını derleme zamanında projeye bağlar. |

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxcollections.uxmh"
IMPORT(C, "native/hizli_toplam.c")

DECLARE FUNCTION HizliToplam(a AS I32, b AS I32) AS I32

MAIN
    PRINT HizliToplam(12, 30)
END MAIN
```

`INCLUDE` uXBasic başlık dosyasını metin olarak katar. `IMPORT(C, ...)` dış C kaynak dosyasını derleme zincirine bağlar; derleyici onu ayrı derler ve bağlar.

### 9.7 MODULE ve NAMESPACE — Ad Düzeni

Büyük proje tek dosyada büyütülmez. `NAMESPACE` ad çakışmasını önler. `MODULE` aynı işe ait yordamları toplar. `USING` uzun adları kullanıma açar. `ALIAS` uzun veya dış adları okunur hâle getirir.

**Sözdizimi:**

```
NAMESPACE Ad
    MODULE Ad
        ' yordamlar, sabitler
    END MODULE
END NAMESPACE

USING [MODULE | NAMESPACE] Ad
ALIAS Kisa = Uzun.Ad
```

**Örnek — istatistik modülü:**

```uxbasic
NAMESPACE Bilim
    MODULE Temel
        FUNCTION Ortalama(a AS F64, b AS F64) AS F64
            RETURN (a + b) / 2.0
        END FUNCTION

        FUNCTION Kare(x AS F64) AS F64
            RETURN x * x
        END FUNCTION
    END MODULE
END NAMESPACE

USING NAMESPACE Bilim
ALIAS ORT = Bilim.Temel.Ortalama

MAIN
    PRINT ORT(10, 20)
    PRINT Bilim.Temel.Kare(5)
END MAIN
```

`NAMESPACE Bilim` içinde `MODULE Temel` açıldı. `USING NAMESPACE Bilim` ile uzun yolu kısalttık. `ALIAS ORT = Bilim.Temel.Ortalama` ile fonksiyona kısa ad verdik.

### 9.8 INLINE — C/C++/ASM Gömme

`INLINE`, uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.

```uxbasic
INLINE C
    int hizli_kare(int a) { return a * a; }
END INLINE

DECLARE FUNCTION HizliKare(a AS I32) AS I32

MAIN
    PRINT HizliKare(7)
END MAIN
```

`INLINE` ile hedefe özel hızlı rutinler uXBasic kaynağında tutulabilir. Genel program `MODULE` ve fonksiyon çağrısıyla temiz kalır.

### 9.9 TYPE — Kayıt Tipi

`TYPE`, veri alanlarını bir kayıt gibi toplar. Bölüm 5'te görmüştük; burada yordam parametresi olarak kullanımına bakalım.

```uxbasic
TYPE SensorKaydi
    ph AS F64
    sicaklik AS F64
    durum AS STRING
END TYPE

SUB YazKayit(k AS SensorKaydi)
    PRINT "pH=" + STR(k.ph) + " sicaklik=" + STR(k.sicaklik) + " durum=" + k.durum
END SUB

FUNCTION Etiketle(ph AS F64) AS STRING
    IF ph < 6.5 THEN RETURN "asidik"
    IF ph > 8.5 THEN RETURN "bazik"
    RETURN "normal"
END FUNCTION

MAIN
    DIM k AS SensorKaydi
    k.ph = 7.42
    k.sicaklik = 24.8
    k.durum = Etiketle(k.ph)
    CALL YazKayit(k)
END MAIN
```

`TYPE` ile yapılan kayıt, `SUB` ve `FUNCTION`'a parametre olarak tek parça halinde geçirilebilir. Bu, çok sayıda ayrı parametre yerine tek bir kayıt göndermeyi sağlar.

### 9.10 CLASS — Sınıf Tanımı

`CLASS`, veri ve davranışı aynı nesne kalıbında toplar. `TYPE` bir form satırıdır; `CLASS` kendi işini yapabilen küçük makinedir.

**Sözdizimi:**

```
CLASS Ad
[PUBLIC|PRIVATE|PROTECTED]
    PROPERTY Ad AS Tip
    METHOD Ad(...) AS Tip
    CONSTRUCTOR(...)
    DESTRUCTOR()
END CLASS
```

**Örnek — Tank sınıfı:**

```uxbasic
CLASS Tank
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY hacimLitre AS F64
    PROPERTY balikKg AS F64

    METHOD Yogunluk() AS F64
        IF hacimLitre <= 0 THEN RETURN 0
        RETURN balikKg / hacimLitre
    END METHOD

    METHOD Durum() AS STRING
        IF Yogunluk() > 0.08 THEN RETURN "yogun"
        RETURN "normal"
    END METHOD
END CLASS

MAIN
    DIM t AS Tank
    t = NEW Tank()
    t.ad = "T1"
    t.hacimLitre = 1000
    t.balikKg = 72
    PRINT t.ad; " yogunluk="; t.Yogunluk(); " durum="; t.Durum()
    DELETE t
END MAIN
```

`NEW Tank()` ile yeni nesne oluşturulur. `t.ad = "T1"` ile özelliğe değer atanır. `t.Yogunluk()` ile yöntem çağrılır. `DELETE t` ile nesne bırakılır.

### 9.11 CONSTRUCTOR ve DESTRUCTOR

`CONSTRUCTOR` nesne oluşurken başlangıç değerlerini kurar. `DESTRUCTOR` nesne yok olurken kaynak temizler.

```uxbasic
CLASS Numune
PUBLIC
    PROPERTY kod AS STRING
    PROPERTY ph AS F64

    CONSTRUCTOR(k AS STRING, p AS F64)
        kod = k
        ph = p
    END CONSTRUCTOR

    DESTRUCTOR()
        PRINT "Numune "; kod; " serbest birakildi"
    END DESTRUCTOR

    METHOD UygunMu() AS BOOLEAN
        RETURN ph >= 6.5 AND ph <= 8.5
    END METHOD
END CLASS

MAIN
    DIM n AS Numune
    n = NEW Numune("N-001", 7.22)
    IF n.UygunMu() THEN
        PRINT n.kod; " uygun"
    ELSE
        PRINT n.kod; " alarm"
    END IF
    DELETE n
END MAIN
```

Çıktı:
```
N-001 uygun
Numune N-001 serbest birakildi
```

`NEW Numune("N-001", 7.22)` çağrısı `CONSTRUCTOR`'ı çalıştırır; `kod` ve `ph` başlangıç değerleri verilir. `DELETE n` çağrısı `DESTRUCTOR`'ı çalıştırır; temizlik mesajı yazılır.

### 9.12 INTERFACE ve IMPLEMENTS — Sözleşme

`INTERFACE`, bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar. `IMPLEMENTS`, sınıfın arayüz sözleşmesini üstlendiğini söyler.

```uxbasic
INTERFACE IRaporlayici
    METHOD RaporSatiri() AS STRING
END INTERFACE

CLASS TankRapor IMPLEMENTS IRaporlayici
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY ph AS F64

    CONSTRUCTOR(a AS STRING, p AS F64)
        ad = a
        ph = p
    END CONSTRUCTOR

    METHOD RaporSatiri() AS STRING
        RETURN ad + ";" + STR(ph)
    END METHOD

    METHOD Risk() AS STRING
        IF ph < 6.8 OR ph > 8.2 THEN RETURN "risk"
        RETURN "OK"
    END METHOD
END CLASS

MAIN
    DIM r AS TankRapor
    r = NEW TankRapor("T1", 7.2)
    PRINT r.RaporSatiri()
    PRINT "risk="; r.Risk()
    DELETE r
END MAIN
```

`IRaporlayici` arayüzü, her uygulayan sınıfın `RaporSatiri()` yöntemini sağlamasını zorunlu kılar. Bu sayede farklı sınıflar aynı arayüzü uyguladığında, çağıran taraf hangi sınıf olduğunu bilmek zorunda kalmaz; yalnızca arayüze bakar.

### 9.13 VIRTUAL ve OVERRIDE — Miras Davranışı

`VIRTUAL` ile işaretlenen yöntem, alt sınıfta `OVERRIDE` ile değiştirilebilir.

```uxbasic
CLASS Sekil
PUBLIC
    VIRTUAL METHOD Alan() AS F64
        RETURN 0
    END METHOD

    METHOD Tanit()
        PRINT "Sekil alani="; Alan()
    END METHOD
END CLASS

CLASS Dikdortgen IMPLEMENTS Sekil
PUBLIC
    PROPERTY genislik AS F64
    PROPERTY yukseklik AS F64

    CONSTRUCTOR(g AS F64, y AS F64)
        genislik = g
        yukseklik = y
    END CONSTRUCTOR

    OVERRIDE METHOD Alan() AS F64
        RETURN genislik * yukseklik
    END METHOD
END CLASS

MAIN
    DIM d AS Dikdortgen
    d = NEW Dikdortgen(5, 3)
    CALL d.Tanit()
    DELETE d
END MAIN
```

`Sekil` sınıfındaki `Tanit()` yöntemi `Alan()` çağırır. `Dikdortgen` `Alan()` yöntemini `OVERRIDE` ile değiştirir. `Tanit()` çağrıldığında artık `Dikdortgen.Alan()` çalışır; çünkü `Alan()` `VIRTUAL` işaretlenmişti.

### 9.14 Erişim Belirleyicileri: PUBLIC, PRIVATE, PROTECTED

| Belirleyici | Erişim |
| --- | --- |
| `PUBLIC` | Dışarıdan erişilebilir. |
| `PRIVATE` | Yalnız kendi sınıfı/modülü içinden. |
| `PROTECTED` | Kendi sınıfı ve alt sınıflar. |
| `FRIEND` | Belirli modül/sınıfa özel erişim. |
| `READONLY` | Dışarıdan değiştirilemeyen okuma alanı. |
| `IMMUTABLE` | Değişmez veri/nesne niyeti. |
| `MUTABLE` | Sabit bağlamda bile değişebilir alan. |

```uxbasic
CLASS Hesap
PRIVATE
    PROPERTY bakiye AS F64

PUBLIC
    CONSTRUCTOR(ilkBakiye AS F64)
        bakiye = ilkBakiye
    END CONSTRUCTOR

    METHOD BakiyeSor() AS F64
        RETURN bakiye
    END METHOD

    METHOD Yatir(miktar AS F64)
        IF miktar > 0 THEN bakiye = bakiye + miktar
    END METHOD

    METHOD Cek(miktar AS F64) AS BOOLEAN
        IF miktar > 0 AND miktar <= bakiye THEN
            bakiye = bakiye - miktar
            RETURN TRUE
        END IF
        RETURN FALSE
    END METHOD
END CLASS

MAIN
    DIM h AS Hesap
    h = NEW Hesap(100)
    CALL h.Yatir(50)
    IF h.Cek(30) THEN PRINT "30 cekildi"
    PRINT "Bakiye="; h.BakiyeSor()
    DELETE h
END MAIN
```

`bakiye` `PRIVATE` olduğu için dışarıdan doğrudan erişilemez. `h.bakiye = 1000` yazamazsın. Yalnızca `Yatir` ve `Cek` yöntemleriyle değiştirilebilir. Bu, hesabın tutarlılığını korur.

### 9.15 STATIC — Sınıfa Ait Ortak Alan

`STATIC` ile işaretlenen alan veya yöntem sınıfa aittir; her nesnede ayrı kopya tutulmaz.

```uxbasic
CLASS Sayac
PUBLIC
    STATIC PROPERTY toplamNesne AS I32

    CONSTRUCTOR()
        toplamNesne = toplamNesne + 1
    END CONSTRUCTOR

    STATIC METHOD KacNesne() AS I32
        RETURN toplamNesne
    END METHOD
END CLASS

MAIN
    DIM a AS Sayac
    DIM b AS Sayac
    DIM c AS Sayac
    a = NEW Sayac()
    b = NEW Sayac()
    c = NEW Sayac()
    PRINT "Toplam nesne="; Sayac.KacNesne()
    DELETE a
    DELETE b
    DELETE c
END MAIN
```

`toplamNesne` tüm `Sayac` örnekleri için ortaktır. Her `NEW Sayac()` çağrısında bir artar. `Sayac.KacNesne()` static yöntem olduğu için nesne üzerinden değil, sınıf adı üzerinden çağrılır.

### 9.16 MAGIC — Sihirli Yöntemler

`MAGIC`, nesnenin özel davranışlarını tanımlar. Örneğin `toString` nesnenin metne çevrilme davranışını belirler.

```uxbasic
CLASS Numune
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY ph AS F64

    CONSTRUCTOR(a AS STRING, p AS F64)
        ad = a
        ph = p
    END CONSTRUCTOR

    MAGIC <.toString.>() AS STRING
        RETURN ad + " (pH=" + STR(ph) + ")"
    END MAGIC
END CLASS

MAIN
    DIM n AS Numune
    n = NEW Numune("N-001", 7.22)
    PRINT n
    DELETE n
END MAIN
```

`PRINT n` çağrısı `MAGIC <.toString.>()` yöntemini çalıştırır ve `N-001 (pH=7.22)` çıktısını üretir.

### 9.17 ENUM — Adlandırılmış Sabitler

`ENUM`, adlandırılmış sabitler grubu oluşturur.

```uxbasic
ENUM Durum
    BEKLE
    CALIS
    DURDUR
    HATA
END ENUM

MAIN
    DIM d AS Durum
    d = CALIS
    SELECT CASE d
    CASE BEKLE
        PRINT "beklemede"
    CASE CALIS
        PRINT "calisiyor"
    CASE DURDUR
        PRINT "durduruldu"
    CASE HATA
        PRINT "hata"
    END SELECT
END MAIN
```

`ENUM` sayısal değerlere ad verir. Varsayılan olarak `BEKLE=0`, `CALIS=1`, `DURDUR=2`, `HATA=3`. Bu sayede programda `0`, `1`, `2` yerine anlamlı adlar kullanılır.

### 9.18 İleri Teknik — Sınıf ile Tank Yönetimi (Satır Satır Anlatım)

Aşağıdaki program `TYPE`, `CLASS`, `DICT` ve dosya raporunu bir araya getirir.

```uxbasic
INCLUDE "modules/uxcollections.uxmh"

TYPE GunlukOlcum
    gun AS I32
    ph AS F64
    oksijen AS F64
    yemKg AS F64
END TYPE

CLASS Tank
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY hacim AS F64
    PROPERTY balikKg AS F64
    PROPERTY son AS GunlukOlcum

    METHOD Yogunluk() AS F64
        IF hacim <= 0 THEN RETURN 0
        RETURN balikKg / hacim
    END METHOD

    METHOD Risk() AS STRING
        IF son.oksijen < 6.0 THEN RETURN "oksijen"
        IF son.ph < 6.8 OR son.ph > 8.2 THEN RETURN "pH"
        IF Yogunluk() > 0.09 THEN RETURN "yogunluk"
        RETURN "OK"
    END METHOD

    METHOD Csv() AS STRING
        RETURN ad + ";" + STR(son.gun) + ";" + STR(son.ph) + ";" + STR(son.oksijen) + ";" + Risk()
    END METHOD
END CLASS

MAIN
    DIM tanklar AS PTR
    DIM i AS I32
    tanklar = ux_dict_new()

    FOR i = 1 TO 4
        DIM t AS Tank
        t = NEW Tank()
        t.ad = "T" + STR(i)
        t.hacim = 1000
        t.balikKg = 60 + i * 5
        t.son.gun = 1
        t.son.ph = 7.0 + RND() * 0.8
        t.son.oksijen = 5.5 + RND() * 1.5
        CALL ux_dict_set_object(tanklar, t.ad, t)
    NEXT i

    OPEN "tank_nesne_raporu.csv" FOR OUTPUT AS #1
    PRINT #1, "tank;gun;pH;oksijen;risk"
    FOR i = 1 TO 4
        DIM ad AS STRING
        DIM t AS Tank
        ad = "T" + STR(i)
        t = ux_dict_get_object(tanklar, ad)
        PRINT #1, t.Csv()
        DELETE t
    NEXT i
    CLOSE #1

    CALL ux_dict_free(tanklar)
    PRINT "rapor yazildi"
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxcollections.uxmh"` — Koleksiyon kütüphanesini dahil eder. `ux_dict_*` fonksiyonlarını kullanabilmek için gerekli.
2. `TYPE GunlukOlcum` — Bir tankın günlük ölçümünü tanımlar: gün, pH, oksijen, yem miktarı. Bu bir kayıt tipidir; davranış taşımaz.
3. `CLASS Tank` — Tank nesnesini tanımlar. Veri (ad, hacim, balikKg, son) ve davranış (Yogunluk, Risk, Csv) birlikte.
4. `PROPERTY son AS GunlukOlcum` — Tankın son ölçümü `GunlukOlcum` tipinde bir kayıt. Böylece `t.son.ph` gibi noktalı erişim mümkün.
5. `METHOD Yogunluk() AS F64` — Tanktaki balık yoğunluğunu hesaplar. `balikKg / hacim`.
6. `METHOD Risk() AS STRING` — Önce oksijen, sonra pH, sonra yoğunluk riskini denetler. İlk bulunan risk döner; hepsi iyiyse "OK".
7. `METHOD Csv() AS STRING` — Tankın CSV satırını üretir. Bu yöntem rapor yazmayı kolaylaştırır.
8. `DIM tanklar AS PTR` — Tank sözlüğü için handle. `ux_dict_new()` ile oluşturulacak.
9. `tanklar = ux_dict_new()` — Yeni bir sözlük oluştur. Tank adı → tank nesnesi eşlemesi tutacak.
10. `FOR i = 1 TO 4` — Dört tank oluşturma döngüsü.
11. `DIM t AS Tank` — Tank nesnesi değişkeni.
12. `t = NEW Tank()` — Yeni tank nesnesi oluştur. `CONSTRUCTOR` çağrılır (biz tanımlamadık, derleyici varsayılan kurucu kullanır).
13. `t.ad = "T" + STR(i)` — Tank adı "T1", "T2", "T3", "T4".
14. `t.hacim = 1000` — Tüm tanklar 1000 litre.
15. `t.balikKg = 60 + i * 5` — Tank 1: 65 kg, Tank 2: 70 kg, vb. Yoğunluk farklı olacak.
16. `t.son.gun = 1` — Ölçüm günü 1.
17. `t.son.ph = 7.0 + RND() * 0.8` — pH 7.0 ile 7.8 arasında rastgele.
18. `t.son.oksijen = 5.5 + RND() * 1.5` — Oksijen 5.5 ile 7.0 mg/L arasında rastgele.
19. `CALL ux_dict_set_object(tanklar, t.ad, t)` — Tankı sözlüğe ekle. Anahtar tank adı, değer tank nesnesi.
20. `OPEN "tank_nesne_raporu.csv" FOR OUTPUT AS #1` — Rapor dosyasını yazma için aç.
21. `PRINT #1, "tank;gun;pH;oksijen;risk"` — CSV başlık satırı.
22. `FOR i = 1 TO 4` — Rapor yazma döngüsü.
23. `ad = "T" + STR(i)` — Tank adını oluştur.
24. `t = ux_dict_get_object(tanklar, ad)` — Sözlükten tank nesnesini al.
25. `PRINT #1, t.Csv()` — Tankın CSV satırını yaz. `Csv()` yöntemi tüm biçimlendirmeyi yapar.
26. `DELETE t` — Tank nesnesini bırak. Bellek temizliği.
27. `CLOSE #1` — Dosyayı kapat.
28. `CALL ux_dict_free(tanklar)` — Sözlük handle'ını bırak.
29. `PRINT "rapor yazildi"` — Ekrana bilgilendirme.

**Örnek çıktı (`tank_nesne_raporu.csv`):**

```
tank;gun;pH;oksijen;risk
T1;1;7.42;6.1;OK
T2;1;7.18;5.8;oksijen
T3;1;7.71;6.4;OK
T4;1;7.05;5.6;oksijen
```

> **Ders:** Ana programı ince tut. Ana program veri üretir ve raporu çağırır; risk hesabı sınıfın içinde durur. Yarın risk hesabı değişirse ana program bozulmaz. Sınıf, "tank nedir?" sorusunun cevabıdır; ana program ise "bu tanklarla ne yapıyoruz?" sorusunun cevabıdır.

### 9.19 İleri Teknik — DLL Sarmalayıcı (Satır Satır Anlatım)

Aşağıdaki örnek Windows DLL çağrısını güvenli bir uXBasic fonksiyonuna sarmalar.

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

FUNCTION UyariSesi(seviye AS I32) AS I32
    IF seviye <= 0 THEN RETURN 0
    IF seviye = 1 THEN RETURN Beep(800, 120)
    IF seviye = 2 THEN RETURN Beep(1200, 180)
    RETURN Beep(1600, 250)
END FUNCTION

SUB HataBildir(metin AS STRING)
    PRINT "HATA: "; metin
    CALL UyariSesi(2)
END SUB

MAIN
    CALL HataBildir("ph sinir disi")
END MAIN
```

**Satır satır açıklama:**

1. `DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" ...` — Windows `kernel32.dll` içindeki `Beep` fonksiyonunun imzasını bildirir. `BYVAL hz` ve `BYVAL ms` parametreleri değerle geçirilir.
2. `FUNCTION UyariSesi(seviye AS I32) AS I32` — Seviyeye göre farklı ses üreten sarmalayıcı fonksiyon.
3. `IF seviye <= 0 THEN RETURN 0` — Geçersiz seviyede sessizce çık.
4. `IF seviye = 1 THEN RETURN Beep(800, 120)` — Düşük seviye: 800 Hz, 120 ms.
5. `IF seviye = 2 THEN RETURN Beep(1200, 180)` — Orta seviye: 1200 Hz, 180 ms.
6. `RETURN Beep(1600, 250)` — Yüksek seviye (varsayılan): 1600 Hz, 250 ms.
7. `SUB HataBildir(metin AS STRING)` — Hata mesajı yazdırıp ses çalan alt yordam.
8. `PRINT "HATA: "; metin` — Hatayı ekrana yaz.
9. `CALL UyariSesi(2)` — Orta seviye uyarı sesi çal.
10. `CALL HataBildir("ph sinir disi")` — Ana programda hata bildir.

> **Ders:** Hile şudur: programın her yerine doğrudan DLL çağrısı yazmıyoruz. Önce `DECLARE`, sonra uXBasic fonksiyonu, sonra programın kalanına temiz `HataBildir` çağrısı veriyoruz. Dış dünyanın karmaşası tek bir modülde saklanır; ana program temiz kalır.

### 9.20 İleri Teknik — Modül, Ad Alanı ve Kısaltma (Satır Satır Anlatım)

Bu örnek kütüphane yüzeyini nasıl temiz kuracağını gösterir.

```uxbasic
INCLUDE "modules/uxstats.uxmh"
IMPORT(C, "native/hizli_filtre.c")

NAMESPACE Lab
    MODULE Kalite
        CONST ALT AS F64 = 6.5
        CONST UST AS F64 = 8.5

        FUNCTION Uygun(ph AS F64) AS BOOLEAN
            RETURN ph >= ALT AND ph <= UST
        END FUNCTION

        FUNCTION Etiket(ph AS F64) AS STRING
            IF Uygun(ph) THEN RETURN "OK"
            IF ph < ALT THEN RETURN "asit"
            RETURN "baz"
        END FUNCTION
    END MODULE
END NAMESPACE

USING MODULE Lab.Kalite
ALIAS PHOK = Lab.Kalite.Uygun

MAIN
    DIM ph AS F64
    INPUT ph
    IF PHOK(ph) THEN
        PRINT "uygun"
    ELSE
        PRINT "alarm: "; Lab.Kalite.Etiket(ph)
    END IF
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxstats.uxmh"` — İstatistik kütüphanesini ekle.
2. `IMPORT(C, "native/hizli_filtre.c")` — Hızlı filtre C kodunu derleme zincirine bağla.
3. `NAMESPACE Lab` — Laboratuvar ad alanını aç. Farklı projelerde "Lab" adı çakışmaz.
4. `MODULE Kalite` — Kalite iş ailesini topla. Sabitler ve fonksiyonlar burada.
5. `CONST ALT AS F64 = 6.5` — Alt pH sınırı.
6. `CONST UST AS F64 = 8.5` — Üst pH sınırı.
7. `FUNCTION Uygun(ph AS F64) AS BOOLEAN` — pH sınırlar içinde mi?
8. `FUNCTION Etiket(ph AS F64) AS STRING` — pH için etiket üret.
9. `USING MODULE Lab.Kalite` — Modülü kısa kullanıma aç. `Lab.Kalite.Uygun` yerine `Uygun` yazılabilir.
10. `ALIAS PHOK = Lab.Kalite.Uygun` — Fonksiyona kısa ad ver. Artık `PHOK(ph)` yazılabilir.
11. `IF PHOK(ph) THEN` — Kısa adla çağır.
12. `Lab.Kalite.Etiket(ph)` — Tam adla çağır. İki biçim de çalışır.

> **Ders:** Çekirdeğe yeni komut eklemeden kütüphane yüzeyi kuruluyor. `ALIAS` okunurluk sağlar, `NAMESPACE` çakışmayı önler, `IMPORT` C hızını projeye katar.

### 9.21 Bölüm Özeti

Yordam, modül ve nesne komutları programı büyütmenin yoludur. `SUB` ve `FUNCTION` tekrar eden işleri adlandırır; `DECLARE` ve `CALL` dış dünya ile konuşur; `INCLUDE` ve `IMPORT` kaynak dosyasına dış dünya katar; `NAMESPACE`, `MODULE`, `USING`, `ALIAS` ad düzeni kurar; `TYPE` kayıt, `CLASS` nesne, `INTERFACE` sözleşme, `IMPLEMENTS` uygulama, `VIRTUAL/OVERRIDE` miras davranışı, `CONSTRUCTOR/DESTRUCTOR` yaşam döngüsü, `PUBLIC/PRIVATE/PROTECTED` erişim, `STATIC` sınıfa ait ortak, `MAGIC` özel davranış, `ENUM` adlandırılmış sabitler sağlar. İyi tasarımın özü: **veri dağınık durursa program dağılır; veri ve davranış aynı kavramın etrafında toplanırsa kod büyürken anlaşılır kalır.**

---
# Programcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek (Devam)

---

## BÖLÜM 10: KOMUTLAR — BELLEK VE DÜŞÜK SEVİYE

Bellek komutları programın işlemcinin diline en yakın olduğu yerdir. `PEEK` ve `POKE` ailesi adresten okur ve adrese yazar. `MEMCOPY` ve `MEMFILL` blok kopyalama ve doldurma yapar. `INC` ve `DEC` sayaçları hızlı artırıp azaltır. Bu komutlar güçlü ama tehlikelidir; yanlış adrese yazmak programı çökertebilir. Bu yüzden bu bölümün altın kuralı şudur: **adresi bilmediğin yere yazma; tamponun sınırını bilmeden doldurma.**

### 10.1 Neden Düşük Seviye?

uXBasic, BASIC rahatlığını sistem programlama gücüyle birleştirir. Çoğu iş için `DIM`, `STRING`, `LIST`, `DICT` yeterlidir. Ama bazen şunlar gerekir:

- **Dış kütüphane ile konuşmak:** DLL'ler ham bellek adresi ister.
- **İkili dosya işleme:** Resim, ses, video dosyaları bayt bayt okunmalı.
- **Hızlı tampon:** Büyük veriyi parça parça taşımak için blok kopyalama.
- **Donanım benzetimi:** Sensör veya mikrodenetleyici taklidi için bayrak ve bit işleme.

Bu işlerde `PEEK`, `POKE`, `MEMCOPY`, `MEMFILL` devreye girer.

### 10.2 PEEK Ailesi — Adresten Okuma

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `PEEKB(adres)` | `deger = PEEKB(adres)` | Adresten 1 bayt (8 bit) okur. |
| `PEEKW(adres)` | `deger = PEEKW(adres)` | Adresten 2 bayt (16 bit sözcük) okur. |
| `PEEKD(adres)` | `deger = PEEKD(adres)` | Adresten 4 bayt (32 bit dword) okur. |

B harvest `B` = Byte, `W` = Word (sözcük, 16 bit), `D` = DWord (çift sözcük, 32 bit).

```uxbasic
DIM adres AS U64
DIM bayt AS U8
DIM sozcuk AS U16
DIM dword AS U32

adres = 1024
bayt = PEEKB(adres)
sozcuk = PEEKW(adres)
dword = PEEKD(adres)

PRINT "1 bayt="; bayt
PRINT "2 bayt="; sozcuk
PRINT "4 bayt="; dword
```

### 10.3 POKE Ailesi — Adrese Yazma

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `POKE adres, deger` | `POKE adres, deger` | Adrese genel değer yazar. |
| `POKEB adres, deger` | `POKEB adres, deger` | Adrese 1 bayt yazar. |
| `POKEW adres, deger` | `POKEW adres, deger` | Adrese 16 bit sözcük yazar. |
| `POKED adres, deger` | `POKED adres, deger` | Adrese 32 bit dword yazar. |
| `POKES adres, metin` | `POKES adres, metin` | Adrese metin yazar. |

```uxbasic
DIM adres AS U64
adres = 1024

POKEB adres, 65            ' 65 = 'A' ASCII kodu
PRINT CHR(PEEKB(adres))    ' A yazar

POKEW adres, 1234
PRINT PEEKW(adres)         ' 1234 yazar

POKED adres, 1000000
PRINT PEEKD(adres)         ' 1000000 yazar

POKES adres, "merhaba"
PRINT "metin yazildi"
```

`POKEB` ile yazılan 65, ASCII tablosunda 'A' harfidir. `CHR(65)` çağrısı 'A' üretir. Böylece bayt ve karakter arasında köprü kurulur.

### 10.4 Adres Alma: VARPTR, SADD, LPTR, CODEPTR

Bir değişkenin bellekte nerede olduğunu bulmak için adres alma fonksiyonları kullanılır.

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `VARPTR(degisken)` | `adres = VARPTR(x)` | Değişkenin bellek adresini verir. |
| `SADD(metin)` | `adres = SADD(s)` | Metin içeriğinin adresini verir. |
| `LPTR(etiket)` | `adres = LPTR(etiket)` | Etiketin adresini verir. |
| `CODEPTR(yordam)` | `adres = CODEPTR(Sub)` | Yordamın kod adresini verir. |

```uxbasic
DIM n AS I32
DIM adres AS PTR

n = 42
adres = VARPTR(n)
PRINT "n'nin adresindeki deger="; PEEKD(adres)

POKED adres, 100
PRINT "yeni n="; n
```

Bu örnekte `n`'in adresi alınır, `PEEKD` ile değeri okunur (42), sonra `POKED` ile yeni değer (100) yazılır. `n` artık 100'dür; çünkü `POKED` doğrudan belleğe yazdı.

### 10.5 MEMCOPY Ailesi — Blok Kopyalama

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `MEMCOPYB hedef, kaynak, adet` | `MEMCOPYB h, k, n` | Bayt bayt blok kopyalar. |
| `MEMCOPYW hedef, kaynak, adet` | `MEMCOPYW h, k, n` | Sözcük sözcük kopyalar. |
| `MEMCOPYD hedef, kaynak, adet` | `MEMCOPYD h, k, n` | Dword dword kopyalar. |

`MEMCOPYB` yavaş ama en güvenli; her bayt tek tek kopyalanır. `MEMCOPYW` iki kat, `MEMCOPYD` dört kat daha hızlıdır; ama hizalama uyumu ister.

```uxbasic
DIM kaynak AS STRING
DIM hedef AS STRING
SETSTRINGSIZE kaynak, 64
SETSTRINGSIZE hedef, 64

POKES SADD(kaynak), "deney satiri"
MEMCOPYB SADD(hedef), SADD(kaynak), LEN(kaynak)
PRINT hedef
```

Bu örnekte `kaynak` metninin içeriği `hedef` metnine bayt bayt kopyalanır. `SADD` her iki metnin de içeriğinin başlangıç adresini verir.

### 10.6 MEMFILL Ailesi — Blok Doldurma

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `MEMFILLB hedef, deger, adet` | `MEMFILLB h, d, n` | Belleği bayt değeriyle doldurur. |
| `MEMFILLW hedef, deger, adet` | `MEMFILLW h, d, n` | Belleği sözcük değeriyle doldurur. |
| `MEMFILLD hedef, deger, adet` | `MEMFILLD h, d, n` | Belleği dword değeriyle doldurur. |

```uxbasic
DIM tampon AS STRING
SETSTRINGSIZE tampon, 256
MEMFILLB SADD(tampon), 0, 256          ' tumunu sifirla
POKES SADD(tampon), "uXBasic"
PRINT tampon
```

`MEMFILLB` ile tamponun tamamı sıfırlanır (önceki içerik silinir). Sonra `POKES` ile yeni metin yazılır. Bu, çöp veriyi temizlemenin standart yolu.

### 10.7 INC ve DEC — Hızlı Artırma/Azaltma

| Komut | Sözdizimi | Görev |
| --- | --- | --- |
| `INC degisken` | `INC x` | Değişkeni 1 artırır. |
| `INC degisken, adim` | `INC x, 5` | Değişkeni adim kadar artırır. |
| `DEC degisken` | `DEC x` | Değişkeni 1 azaltır. |
| `DEC degisken, adim` | `DEC x, 5` | Değişkeni adim kadar azaltır. |

```uxbasic
DIM sayac AS I32
sayac = 0
INC sayac          ' sayac = 1
INC sayac          ' sayac = 2
INC sayac, 10      ' sayac = 12
DEC sayac          ' sayac = 11
DEC sayac, 5       ' sayac = 6
PRINT "sonuc="; sayac
```

`INC` ve `DEC` sadece sayaç için değil, adresteki değeri değiştirmek için de kullanılabilir.

```uxbasic
DIM adres AS U64
adres = 1024
POKEB adres, 10
INC PEEKB(adres)    ' adresteki deger 11 olur
PRINT PEEKB(adres)
```

### 10.8 SETNEWOFFSET — Yeni Ofset Kurma

`SETNEWOFFSET`, bellek ayırma veya erişim ofsetini yeniden kurar. Düşük seviye bellek yönetiminde kullanılır.

```uxbasic
DIM adres AS U64
adres = 1024
SETNEWOFFSET adres
PRINT "yeni ofset kuruldu"
```

Bu komut genellikle dış kütüphane ile çalışırken veya özelleştirilmiş bellek bölgelerini yönetirken kullanılır.

### 10.9 SIZEOF ve OFFSETOF — Tip Bilgisi

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `SIZEOF(Tip\|degisken)` | `n = SIZEOF(OlcumKaydi)` | Tipin veya değişkenin bayt boyutunu verir. |
| `OFFSETOF(Tip, alan)` | `n = OFFSETOF(Tip, "alan")` | Tip içindeki alanın ofsetini verir. |

```uxbasic
TYPE Kayit
    id AS I32         ' 4 bayt, ofset 0
    deger AS F64      ' 8 bayt, ofset 8
    ad AS STRING      ' degisken, ofset 16
END TYPE

PRINT "Kayit boyutu="; SIZEOF(Kayit)
PRINT "id ofseti="; OFFSETOF(Kayit, "id")
PRINT "deger ofseti="; OFFSETOF(Kayit, "deger")
```

`SIZEOF` bir kaydın bellekte kaç bayt yer kapladığını verir; binary dosya işlemede kritiktir. `OFFSETOF` ise bir alanın kayıt içindeki başlangıç konumunu verir; dış C yapısıyla konuşurken önemlidir.

### 10.10 Tampon (Buffer) Yönetimi

Tampon, büyük veriyi parça parça taşımak için kullanılan geçici bellek bölgesidir. uXBasic'te tampon genellikle `STRING` üzerine `SETSTRINGSIZE` ile kurulur veya `BUFFER_CREATE` ile ayrılır.

**STRING tamponu:**

```uxbasic
DIM tampon AS STRING
SETSTRINGSIZE tampon, 512      ' 512 baytlik tampon
MEMFILLB SADD(tampon), 0, 512  ' sifirla
POKES SADD(tampon), "ilk veri"
PRINT tampon
```

**BUFFER ile tampon:**

```uxbasic
DIM buf AS I32
DIM i AS I32
DIM deger AS F64
DIM toplam AS F64

buf = BUFFER_CREATE(30, F64)
FOR i = 0 TO 29
    deger = 72.0 + (i MOD 9) * 1.7
    BUFFER_SET_F64 buf, i, deger
NEXT i

FOR i = 0 TO 29
    deger = BUFFER_GET_F64(buf, i)
    toplam = toplam + deger
NEXT i

PRINT "Tampon ortalamasi="; toplam / 30
BUFFER_FILL_F64 buf, 0.0
BUFFER_FREE buf
```

Bu örnekte 30 elemanlı `F64` tamponu açılır, doldurulur, okunur ve en son serbest bırakılır. `BUFFER_FREE` unutulursa bellek sızıntısı olur.

### 10.11 İleri Teknik — Tampon Checksum (Satır Satır Anlatım)

Aşağıdaki program 256 baytlık bir tamponu doldurur ve checksum (sağlama toplamı) hesaplar.

```uxbasic
CONST N AS I32 = 256
DIM tampon(N) AS U8
DIM i AS I32
DIM toplam AS U32

FOR i = 1 TO N
    tampon(i) = i MOD 256
NEXT i

FOR i = 1 TO N
    toplam = toplam + tampon(i)
NEXT i

PRINT "tampon checksum="; toplam

IF toplam = 0 THEN THROW "tampon bos gorunuyor"
PRINT "tampon hazir"
```

**Satır satır açıklama:**

1. `CONST N AS I32 = 256` — Tampon boyutunu sabitle. 256 bayt seçtik.
2. `DIM tampon(N) AS U8` — 256 elemanlı işaretsiz 8 bit tam sayı dizisi aç. Her eleman 0–255 arasında değer taşır.
3. `DIM i AS I32` — Döngü sayacı.
4. `DIM toplam AS U32` — Checksum toplamı. İşaretsiz 32 bit; 256 × 255 = 65280 sığar.
5. `FOR i = 1 TO N` — Tamponu doldurma döngüsü.
6. `tampon(i) = i MOD 256` — i'inci elemanı `i MOD 256` yap. 1, 2, 3, ..., 255, 0, 1, 2, ... döngüsü oluşur.
7. `NEXT i` — Döngüyü sürdür.
8. `FOR i = 1 TO N` — İkinci döngü: checksum hesabı.
9. `toplam = toplam + tampon(i)` — Her elemanı toplama ekle.
10. `NEXT i` — Döngüyü sürdür.
11. `PRINT "tampon checksum="; toplam` — Sonucu yazdır. 1+2+...+255+0+1 = 32640 olmalı.
12. `IF toplam = 0 THEN THROW "tampon bos gorunuyor"` — Eğer toplam sıfırsa tampon boş demektir; hata fırlat.
13. `PRINT "tampon hazir"` — Tamponun kullanıma hazır olduğunu bildir.

**Hesap:** 1 + 2 + 3 + ... + 255 + 0 + 1 = (255 × 256 / 2) + 0 + 1 = 32640 + 0 + 1 = 32641

Çıktı:
```
tampon checksum= 32641
tampon hazir
```

> **Ders:** Tampon, büyük veriyi parça parça taşımak için kullanılır. Burada dizi bir tampon gibi davranır; önce doldurulur, sonra ikinci döngüyle denetlenir. Checksum, verinin bütünlüğünü kanıtlayan en basit yöntemdir.

### 10.12 İleri Teknik — Bellek Kopyalama ve Metin İşleme (Satır Satır Anlatım)

Bu örnek metin tamponu üzerinde `MEMFILLB`, `POKES` ve `MEMCOPYB` işlemlerini bir arada gösterir.

```uxbasic
DIM kaynak AS STRING
DIM hedef AS STRING
SETSTRINGSIZE kaynak, 64
SETSTRINGSIZE hedef, 64

MEMFILLB SADD(kaynak), 0, 64
MEMFILLB SADD(hedef), 0, 64

POKES SADD(kaynak), "deney satiri 001"
PRINT "kaynak: "; kaynak

MEMCOPYB SADD(hedef), SADD(kaynak), 64
PRINT "hedef:  "; hedef

MEMFILLB SADD(hedef) + 14, ASC("-"), 3
PRINT "hedef (degistirildi): "; hedef
```

**Satır satır açıklama:**

1. `DIM kaynak AS STRING` — Kaynak metin değişkeni.
2. `DIM hedef AS STRING` — Hedef metin değişkeni.
3. `SETSTRINGSIZE kaynak, 64` — Kaynak için 64 baytlık yer ayır.
4. `SETSTRINGSIZE hedef, 64` — Hedef için 64 baytlık yer ayır.
5. `MEMFILLB SADD(kaynak), 0, 64` — Kaynak tamponunu sıfırla. Önceki çöp veriyi sil.
6. `MEMFILLB SADD(hedef), 0, 64` — Hedef tamponunu sıfırla.
7. `POKES SADD(kaynak), "deney satiri 001"` — Kaynak tamponuna metin yaz. Metin 17 bayt; kalan 47 bayt sıfır kalır.
8. `PRINT "kaynak: "; kaynak` — Kaynağı yazdır: `deney satiri 001`.
9. `MEMCOPYB SADD(hedef), SADD(kaynak), 64` — Kaynağın tüm 64 baytını hedefe kopyala.
10. `PRINT "hedef:  "; hedef` — Hedefi yazdır: `deney satiri 001`.
11. `MEMFILLB SADD(hedef) + 14, ASC("-"), 3` — Hedefin 14. baytından itibaren 3 bayt '-' karakteri yaz. 14. bayt "001"nin başıdır; bu nedenle "001" "---" olur.
12. `PRINT "hedef (degistirildi): "; hedef` — Hedefi yazdır: `deney satiri ---`.

**Çıktı:**

```
kaynak: deney satiri 001
hedef:  deney satiri 001
hedef (degistirildi): deney satiri ---
```

> **Ders:** `SADD` ile alınan adrese `+ n` eklemek, metnin n'inci baytına gitmektir. Bu, metnin ortasına müdahale etmenin en hızlı yoludur. Ama dizin sınırını aşmamaya dikkat et; yoksa başka veriyi bozarsın.

### 10.13 İleri Teknik — Adres Üzerinden Dizi İşleme (Satır Satır Anlatım)

Bu örnek `VARPTR` ile bir değişkenin adresini alıp, `PEEKD` ve `POKED` ile değerini değiştirir.

```uxbasic
DIM n AS I32
DIM adres AS PTR

n = 42
PRINT "baslangic n="; n

adres = VARPTR(n)
PRINT "adres="; adres
PRINT "adresteki deger="; PEEKD(adres)

POKED adres, 100
PRINT "POKED sonrasi n="; n

INC n
PRINT "INC sonrasi n="; n

DEC n, 5
PRINT "DEC -5 sonrasi n="; n
```

**Satır satır açıklama:**

1. `DIM n AS I32` — 32 bit tam sayı değişkeni aç. Bellekte 4 bayt yer kaplar.
2. `DIM adres AS PTR` — Adres tutacak işaretçi değişkeni.
3. `n = 42` — Değişkene değer ata.
4. `PRINT "baslangic n="; n` — `baslangic n= 42` yazar.
5. `adres = VARPTR(n)` — `n`'in bellek adresini al, `adres`'e koy.
6. `PRINT "adres="; adres` — Adresin sayısal değerini yaz. Bu büyük bir sayıdır (örneğin `140734782534648`).
7. `PRINT "adresteki deger="; PEEKD(adres)` — Adresten 4 bayt oku: 42.
8. `POKED adres, 100` — Adrese 100 yaz. `n` artık 100.
9. `PRINT "POKED sonrasi n="; n` — `POKED sonrasi n= 100` yazar.
10. `INC n` — `n`'yi 1 artır: 101.
11. `PRINT "INC sonrasi n="; n` — `INC sonrasi n= 101` yazar.
12. `DEC n, 5` — `n`'yi 5 azalt: 96.
13. `PRINT "DEC -5 sonrasi n="; n` — `DEC -5 sonrasi n= 96` yazar.

**Çıktı:**

```
baslangic n= 42
adres= 140734782534648
adresteki deger= 42
POKED sonrasi n= 100
INC sonrasi n= 101
DEC -5 sonrasi n= 96
```

> **Ders:** Değişkenin adı, bellekteki adresin etiketidir. `POKED` ile adrese yazdığın değer, değişken üzerinden de görünür. Bu, uXBasic'in C diline en yakın olduğu yerdir; ama yanlış kullanılırsa program çöker. Bu yüzden `TRY ... CATCH` koruması altında kullan.

### 10.14 İleri Teknik — Bit Bayrağı ile Çok Durum Takibi (Satır Satır Anlatım)

Bu örnek tek `U32` değişkeninde birden fazla doğru/yanlış bilgisini nasıl saklayacağımızı gösterir.

```uxbasic
CONST BAYRAK_OK AS U32 = 1 SHL 0       ' 1
CONST BAYRAK_ALARM AS U32 = 1 SHL 1    ' 2
CONST BAYRAK_KAYIT AS U32 = 1 SHL 2    ' 4
CONST BAYRAK_DB AS U32 = 1 SHL 3       ' 8

DIM durum AS U32
DIM ph AS F64
DIM sicaklik AS F64
DIM oksijen AS F64
DIM kayitAcik AS BOOLEAN
DIM dbBagli AS BOOLEAN

ph = 7.2
sicaklik = 24.8
oksijen = 6.5
kayitAcik = TRUE
dbBagli = TRUE

durum = 0
IF ph >= 6.5 AND ph <= 8.5 THEN
    durum = durum OR BAYRAK_OK
ELSE
    durum = durum OR BAYRAK_ALARM
END IF

IF sicaklik < 18 OR sicaklik > 28 THEN durum = durum OR BAYRAK_ALARM
IF oksijen < 5.0 THEN durum = durum OR BAYRAK_ALARM
IF kayitAcik THEN durum = durum OR BAYRAK_KAYIT
IF dbBagli THEN durum = durum OR BAYRAK_DB

PRINT "durum kelimesi="; durum
IF (durum AND BAYRAK_OK) <> 0 THEN PRINT "+ pH uygun"
IF (durum AND BAYRAK_ALARM) <> 0 THEN PRINT "! alarm var"
IF (durum AND BAYRAK_KAYIT) <> 0 THEN PRINT "+ kayit acik"
IF (durum AND BAYRAK_DB) <> 0 THEN PRINT "+ veritabani bagli"
```

**Satır satır açıklama:**

1. `BAYRAK_OK = 1 SHL 0` — 1 sayısının bitlerini 0 sola kaydır: hâlâ 1 (binary `0001`).
2. `BAYRAK_ALARM = 1 SHL 1` — 1 sayısını 1 sola kaydır: 2 (binary `0010`).
3. `BAYRAK_KAYIT = 1 SHL 2` — 1 sayısını 2 sola kaydır: 4 (binary `0100`).
4. `BAYRAK_DB = 1 SHL 3` — 1 sayısını 3 sola kaydır: 8 (binary `1000`).
5. Her bayrak farklı bir bit konumundadır; çakışmazlar.
6. `durum = 0` — Başlangıçta durum kelimesi sıfır.
7. `durum = durum OR BAYRAK_OK` — 0. biti aç. `durum` artık `0001` (1).
8. `durum = durum OR BAYRAK_KAYIT` — 2. biti aç. `durum` artık `0101` (5).
9. `durum = durum OR BAYRAK_DB` — 3. biti aç. `durum` artık `1101` (13).
10. `(durum AND BAYRAK_OK) <> 0` — 0. bit açık mı? Evet (13 AND 1 = 1).
11. `(durum AND BAYRAK_ALARM) <> 0` — 1. bit açık mı? Hayır (13 AND 2 = 0).
12. `(durum AND BAYRAK_KAYIT) <> 0` — 2. bit açık mı? Evet (13 AND 4 = 4).
13. `(durum AND BAYRAK_DB) <> 0` — 3. bit açık mı? Evet (13 AND 8 = 8).

**Çıktı:**

```
durum kelimesi= 13
+ pH uygun
+ kayit acik
+ veritabani bagli
```

> **Ders:** Bit bayrağı tek sayıda birçok doğru/yanlış bilgisi tutar. Sistem programlama ve hızlı durum takibi için zekice bir çözümdür. Çok uzun `IF` zinciri yerine bazen bit bayrağı kullanmak daha akıllıdır.

### 10.15 Bellek Güvenliği — İpuçları ve Tuzaklar

Düşük seviye bellek komutları güçlü ama tehlikelidir. İşte dikkat edilmesi gerekenler:

| Tehlike | Sonuç | Çözüm |
| --- | --- | --- |
| Yanlış adrese yazma | Program çöker | Adresi `VARPTR` ile al; sabit sayı kullanma |
| Tampon sınırını aşma | Başka veri bozulur | `SETSTRINGSIZE` ile sınır koy |
| Kapatılmamış handle | Bellek sızıntısı | Her açılışta `CLOSE`/`FREE` yaz |
| Hizalanmamış erişim | Yavaşlık veya hata | `MEMCOPYB` yerine `MEMCOPYD`yi yalnız hizalı veride kullan |
| İşaretçi tipi uyumsuzluğu | Yanlış değer okuma | `PEEK` tipini veri tipiyle eşle |

**Güvenli bellek erişimi örneği:**

```uxbasic
TRY
    DIM buf AS I32
    buf = BUFFER_CREATE(100, F64)
    IF buf = 0 THEN THROW "tampon ayiramadim"

    BUFFER_SET_F64 buf, 0, 3.14
    BUFFER_SET_F64 buf, 1, 2.71
    PRINT "0. deger="; BUFFER_GET_F64(buf, 0)
    PRINT "1. deger="; BUFFER_GET_F64(buf, 1)

    BUFFER_FREE buf
CATCH e
    PRINT "bellek hatasi: "; e
END TRY
```

`TRY ... CATCH` ile bellek işlemi korunur. `BUFFER_CREATE` başarısız olursa (handle 0 dönerse) hata fırlatılır; çünkü 0 handle'ına yazmak çökme yapar.

### 10.16 Bölüm Özeti

Bellek ve düşük seviye komutlar, programın işlemciye en yakın olduğu yerdir. `PEEK` ailesi adresten okur, `POKE` ailesi adrese yazar, `MEMCOPY` blok kopyalar, `MEMFILL` blok doldurur, `INC/DEC` sayaçları hızlı değiştirir. Adres bilgisi `VARPTR`, `SADD`, `LPTR`, `CODEPTR` ile alınır. Tip bilgisi `SIZEOF` ve `OFFSETOF` ile sorgulanır. Bu komutlar güçlü ama tehlikelidir; yanlış adres çökmeye, aşırı doldurma veri kaybına, kapatılmamış handle bellek sızıntısına yol açar. Altın kural: **adresi bilmediğin yere yazma; tamponun sınırını bilmeden doldurma; açtığın her kaynağı kapat.**

---

## BÖLÜM 11: YEREL (BUILT-IN) FONKSİYONLAR

Yerel fonksiyonlar, uXBasic'in derleyiciye gömülü olarak sunduğu hazır işlevlerdir. Kütüphane `INCLUDE` etmeden çağrılabilir. Bu bölümde tüm yerel fonksiyonları ailelerine göre gruplandırarak inceleyeceğiz: matematik, metin, tip dönüşümü, girdi/çıktı, bellek, zaman.

### 11.1 Matematik Fonksiyonları

Matematik fonksiyonları temel aritmetik, trigonometri ve logaritma işlemleri için kullanılır.

| Fonksiyon | Sözdizimi | Dönüş | Açıklama |
| --- | --- | --- | --- |
| `ABS` | `ABS(sayı)` | F64 | Mutlak değer alır. |
| `INT` | `INT(sayı)` | F64 | Ondalıklı sayının tam kısmını alır (aşağı yuvarlar). |
| `FIX` | `INT(sayı)` | F64 | Sayının tamsayı kısmını alır (sıfıra doğru). |
| `SGN` | `SGN(sayı)` | I32 | Sayının işaretini verir (-1, 0, +1). |
| `SQR` | `SQR(sayı)` | F64 | Karekök alır (BASIC uyumlu ad). |
| `SQRT` | `SQRT(sayı)` | F64 | Karekök alır. |
| `SIN` | `SIN(radyan)` | F64 | Radyanın sinüsünü verir. |
| `COS` | `COS(radyan)` | F64 | Radyanın kosinüsünü verir. |
| `TAN` | `TAN(radyan)` | F64 | Radyanın tanjantını verir. |
| `ATN` | `ATN(sayı)` | F64 | Ark tanjant (radyan) verir. |
| `LOG` | `LOG(sayı)` | F64 | Doğal logaritma hesaplar. |
| `EXP` | `EXP(sayı)` | F64 | e üzeri sayıyı verir. |
| `RND` | `RND([tohum])` | F64 | 0 ile 1 arasında rastgele sayı üretir. |
| `RANDOMIZE` | `RANDOMIZE [tohum]` | — | Rastgele üretecin tohumunu kurar. |

**Mutlak değer ve işaret:**

```uxbasic
PRINT ABS(-5)        ' 5
PRINT ABS(5)         ' 5
PRINT ABS(-3.14)     ' 3.14
PRINT SGN(-5)        ' -1
PRINT SGN(0)         ' 0
PRINT SGN(5)         ' 1
```

**Yuvarlama:**

```uxbasic
PRINT INT(3.7)       ' 3 (asagi yuvarlar)
PRINT INT(-3.7)      ' -4 (asagi yuvarlar, negatif yonde)
PRINT FIX(3.7)       ' 3 (sifira dogru)
PRINT FIX(-3.7)      ' -3 (sifira dogru)
```

`INT` ve `FIX` negatif sayılarda farklı davranır. `INT(-3.7)` = `-4` (daha negatif); `FIX(-3.7)` = `-3` (sıfıra doğru).

**Trigonometri:**

```uxbasic
CONST PI AS F64 = 3.14159265358979
PRINT SIN(0)                 ' 0
PRINT SIN(PI / 2)            ' 1
PRINT COS(0)                 ' 1
PRINT COS(PI)                ' -1
PRINT TAN(0)                 ' 0
PRINT ATN(1)                 ' 0.785 (PI/4)
```

Trigonometrik fonksiyonlar radyan ister. Dereceyi radyana çevirmek için `radyan = derece * PI / 180` formülü kullanılır.

```uxbasic
CONST PI AS F64 = 3.14159265358979
FUNCTION DereceRadyan(d AS F64) AS F64
    RETURN d * PI / 180.0
END FUNCTION

PRINT SIN(DereceRadyan(30))   ' 0.5
PRINT COS(DereceRadyan(60))   ' 0.5
```

**Logaritma ve üstel:**

```uxbasic
PRINT EXP(0)         ' 1 (e^0)
PRINT EXP(1)         ' 2.718 (e)
PRINT LOG(1)         ' 0 (ln(1))
PRINT LOG(EXP(1))    ' 1 (ln(e))
PRINT LOG(100) / LOG(10)  ' 2 (log10(100))
```

`LOG` doğal logaritmadır (ln). 10 tabanında logaritma için `LOG(x) / LOG(10)` formülü kullanılır.

**Karekök:**

```uxbasic
PRINT SQR(16)        ' 4
PRINT SQRT(16)       ' 4 (ayni anlami)
PRINT SQR(2)         ' 1.414
PRINT SQRT(0)        ' 0
```

`SQR` ve `SQRT` eş anlamlıdır; ikisi de karekök alır.

**Rastgele sayı:**

```uxbasic
RANDOMIZE TIMER()
PRINT RND()                   ' 0..1 arasi
PRINT 1 + INT(RND() * 6)      ' 1..6 arasi zar
PRINT 100 + INT(RND() * 50)   ' 100..150 arasi
```

`RANDOMIZE` ile tohumlanmazsan her çalıştırmada aynı rastgele diziyi alırsın. `TIMER()` ile tohumlamak, her çalıştırmada farklı dizi üretir.

### 11.2 Metin Fonksiyonları

Metin fonksiyonları metinleri ölçer, parçalar, dönüştürür ve inceler.

| Fonksiyon | Sözdizimi | Dönüş | Açıklama |
| --- | --- | --- | --- |
| `LEN` | `LEN(metin)` | I64 | Metnin uzunluğunu verir. |
| `MID` | `MID(metin, başla[, uzunluk])` | STRING | Metnin içinden parça alır. |
| `LTRIM` | `LTRIM(metin)` | STRING | Soldaki boşlukları kırpar. |
| `RTRIM` | `RTRIM(metin)` | STRING | Sağdaki boşlukları kırpar. |
| `UCASE` | `UCASE(metin)` | STRING | Metni büyük harfe çevirir. |
| `LCASE` | `LCASE(metin)` | STRING | Metni küçük harfe çevirir. |
| `ASC` | `ASC(karakter)` | I64 | Karakterin ASCII kodunu verir. |
| `CHR` | `CHR(kod)` | STRING | ASCII koddan karakter üretir. |
| `STR` | `STR(sayı)` | STRING | Sayıyı metne çevirir. |
| `VAL` | `VAL(metin)` | F64 | Metni sayıya çevirir. |
| `SPACE` | `SPACE(adet)` | STRING | Belirli sayıda boşluk üretir. |
| `STRING` | `STRING(adet, karakter)` | STRING | Belirli karakterden adet kadar üretir. |

**Uzunluk ve parça alma:**

```uxbasic
DIM s AS STRING
s = "uXBasic programlama"
PRINT LEN(s)                  ' 19
PRINT MID(s, 1, 7)            ' uXBasic
PRINT MID(s, 9, 12)           ' programlama
PRINT MID(s, 9)               ' programlama (sonuna kadar)
```

`MID(metin, başla, uzunluk)` — `başla` 1'den başlar (0'dan değil). `uzunluk` verilmezse metnin sonuna kadar alır.

**Boşluk temizleme:**

```uxbasic
DIM s AS STRING
s = "   merhaba   "
PRINT "[" + s + "]"                    ' [   merhaba   ]
PRINT "[" + LTRIM(s) + "]"             ' [merhaba   ]
PRINT "[" + RTRIM(s) + "]"             ' [   merhaba]
PRINT "[" + LTRIM(RTRIM(s)) + "]"      ' [merhaba]
```

`LTRIM` sol boşlukları, `RTRIM` sağ boşlukları kırpar. İkisini birden kullanmak metnin iki yanını da temizler.

**Harf büyütme ve küçültme:**

```uxbasic
PRINT UCASE("merhaba")    ' MERHABA
PRINT LCASE("MERHABA")    ' merhaba
```

Türkçe karakterler dikkatli işlenmelidir; bazı durumlarda `I`/`i` dönüşümü dil ayarına bağlıdır.

**ASCII ve karakter:**

```uxbasic
PRINT ASC("A")           ' 65
PRINT ASC("a")           ' 97
PRINT ASC("0")           ' 48
PRINT CHR(65)            ' A
PRINT CHR(97)            ' a
PRINT CHR(48)            ' 0
PRINT CHR(13) + CHR(10)  ' satir basi + yeni satir (CRLF)
```

`ASC` ile karakterin sayısal kodunu, `CHR` ile sayısal koddan karakteri üretirsin. Bu, dış dünyadan gelen bayt verisini metne çevirmenin temelidir.

**Sayı-metin dönüşümü:**

```uxbasic
PRINT STR(42)            ' "42"
PRINT STR(3.14)          ' "3.14"
PRINT STR(-7)            ' "-7"

PRINT VAL("42")          ' 42
PRINT VAL("3.14")        ' 3.14
PRINT VAL("-7")          ' -7
PRINT VAL("12abc")       ' 12 (ilk rakam seti)
PRINT VAL("abc")         ' 0 (ceviremedi)
```

`VAL` metnin başındaki sayıyı okur; sayıya çevrilemeyen kısmı yok sayar. Tamamen sayısal olmayan metin `0` döndürür.

**Boşluk ve tekrar:**

```uxbasic
PRINT "[" + SPACE(5) + "]"              ' [     ]
PRINT "[" + STRING(5, "-") + "]"        ' [-----]
PRINT "[" + STRING(3, "*") + "]"        ' [***]
```

`SPACE(n)` n adet boşluk, `STRING(n, karakter)` n adet aynı karakter üretir.

### 11.3 Tip Dönüşüm Fonksiyonları

Tip dönüşüm fonksiyonları bir değeri belirli bir tipe güvenli şekilde çevirir.

| Fonksiyon | Sözdizimi | Dönüş | Açıklama |
| --- | --- | --- | --- |
| `CINT` | `CINT(değer)` | I32 | Değeri 32 bit tam sayıya çevirir. |
| `CLNG` | `CLNG(değer)` | I64 | Değeri 64 bit tam sayıya çevirir. |
| `CSNG` | `CSNG(değer)` | F32 | Değeri tek duyarlıklı kayana çevirir. |
| `CDBL` | `CDBL(değer)` | F64 | Değeri çift duyarlıklı kayana çevirir. |

```uxbasic
DIM x AS F64
x = 3.7
PRINT CINT(x)        ' 4 (yuvarlar)
PRINT CLNG(x)        ' 4
PRINT CSNG(x)        ' 3.7 (F32)
PRINT CDBL(x)        ' 3.7 (F64)

PRINT CINT(7.2)      ' 7
PRINT CINT(7.5)      ' 8 (yuvarlar)
PRINT CINT(7.8)      ' 8
```

`CINT` en yakın tam sayıya yuvarlar. `INT` her zaman aşağı yuvarlar; bu fark unutulmamalı.

### 11.4 Girdi/Çıktı Fonksiyonları

| Fonksiyon | Sözdizimi | Dönüş | Açıklama |
| --- | --- | --- | --- |
| `INKEY` | `INKEY([bekleme])` | STRING | Beklemeden basılan tuşu okur. |
| `GETKEY` | `GETKEY()` | I32 | Bir tuşa basılmasını bekler ve kodunu verir. |
| `EOF` | `EOF(#n)` | I64 | Dosya sonuna gelinip gelinmediğini söyler. |
| `LOF` | `LOF(#n)` | I64 | Açık dosyanın uzunluğunu bayt olarak verir. |

**INKEY ile tuş yakalama:**

```uxbasic
DIM tus AS STRING
PRINT "Cikmak icin Q'ya bas"
DO
    tus = INKEY()
    IF LEN(tus) > 0 THEN
        PRINT "Tus: "; tus; " (kod="; ASC(tus); ")"
    END IF
LOOP UNTIL UCASE(tus) = "Q"
PRINT "Cikildi"
```

`INKEY()` tuşa basılmasa bile boş dize döndürür. Bu yüzden `LEN(tus) > 0` denetimi ile basılı tuş olup olmadığına bakılır.

**GETKEY ile tuş bekleme:**

```uxbasic
PRINT "Bir tusa bas..."
DIM kod AS I32
kod = GETKEY()
PRINT "Tus kodu="; kod
PRINT "Karakter="; CHR(kod)
```

`GETKEY()` tuşa basılana kadar bekler. Bu, menü seçimi gibi durumlar için uygundur.

**EOF ile dosya sonu:**

```uxbasic
OPEN "veri.txt" FOR INPUT AS #1
DO WHILE EOF(#1) = 0
    INPUT #1, satir
    PRINT satir
LOOP
CLOSE #1
```

`EOF(#1)` dosya sonunda `1`, değilse `0` döndürür. `DO WHILE EOF(#1) = 0` ile dosya boyunca döngü kurulur.

**LOF ile dosya boyutu:**

```uxbasic
OPEN "veri.bin" FOR INPUT AS #1
PRINT "dosya boyutu="; LOF(#1); " bayt"
CLOSE #1
```

`LOF(#n)` dosyanın bayt cinsinden uzunluğunu verir. İkili dosyalarda boyut kontrolü için kullanışlıdır.

### 11.5 Bellek Fonksiyonları

Bellek fonksiyonları Bölüm 10'da komut olarak işlendi; burada fonksiyon biçiminde özetliyoruz.

| Fonksiyon | Sözdizimi | Dönüş | Açıklama |
| --- | --- | --- | --- |
| `PEEKB/W/D` | `PEEKB(adres)` | I64 | Adresten bayt/sözcük/dword okur. |
| `VARPTR` | `VARPTR(degisken)` | PTR | Değişkenin bellek adresini verir. |
| `SADD` | `SADD(metin)` | STRPTR | Metnin bellek adresini verir. |
| `LPTR` | `LPTR(etiket)` | PTR | Etiketin adresini verir. |
| `CODEPTR` | `CODEPTR(yordam)` | PTR | Yordamın kod adresini verir. |
| `SIZEOF` | `SIZEOF(Tip\|degisken)` | I64 | Tipin bayt boyutunu verir. |
| `OFFSETOF` | `OFFSETOF(Tip, alan)` | I64 | Kayıt içinde alanın ofsetini verir. |

```uxbasic
DIM x AS I32
DIM d AS F64
DIM s AS STRING

x = 42
d = 3.14
s = "merhaba"

PRINT "x adresi="; VARPTR(x)
PRINT "d adresi="; VARPTR(d)
PRINT "s adresi="; SADD(s)

PRINT "I32 boyutu="; SIZEOF(I32)        ' 4
PRINT "F64 boyutu="; SIZEOF(F64)        ' 8
PRINT "STRING boyutu="; SIZEOF(s)
```

### 11.6 Zaman Fonksiyonları

| Fonksiyon | Sözdizimi | Dönüş | Açıklama |
| --- | --- | --- | --- |
| `TIMER` | `TIMER()` | F64 | Geçen zamanı saniye türünden verir. |

```uxbasic
DIM basla AS F64
DIM bitti As F64

basla = TIMER()
' ... uzun islem ...
DIM i AS I32
DIM toplam AS I64
FOR i = 1 TO 1000000
    toplam = toplam + i
NEXT i

bitti = TIMER()
PRINT "Gecen sure="; bitti - basla; " saniye"
PRINT "Toplam="; toplam
```

`TIMER()` ile süre ölçmek, programın hangi bölümünün yavaş olduğunu bulmanın en basit yoludur. Bir işlem öncesi ve sonrası `TIMER()` alıp farkı hesaplarsın.

### 11.7 İleri Teknik — Fonksiyon Zinciri ile Metin Temizleme (Satır Satır Anlatım)

Aşağıdaki örnek bir metni temizler ve sayıya çevirir.

```uxbasic
DIM ham AS STRING
DIM temiz AS STRING
DIM sayi AS F64

ham = "  42.50  "
temiz = LTRIM(RTRIM(ham))
PRINT "[" + ham + "]"
PRINT "[" + temiz + "]"

sayi = VAL(temiz)
PRINT "sayi="; sayi
PRINT "karekok="; SQRT(sayi)
PRINT "buyuk harf="; UCASE("uxbasic")
PRINT "saat="; TIMER()
```

**Satır satır açıklama:**

1. `ham = "  42.50  "` — İçinde boşluk olan bir metin değişkeni.
2. `temiz = LTRIM(RTRIM(ham))` — Önce `RTRIM` sağ boşlukları kırpar: `"  42.50"`. Sonra `LTRIM` sol boşlukları kırpar: `"42.50"`. İç içe fonksiyon çağrısı en içten dışa doğru çalışır.
3. `PRINT "[" + ham + "]"` — `[  42.50  ]` yazar.
4. `PRINT "[" + temiz + "]"` — `[42.50]` yazar.
5. `sayi = VAL(temiz)` — Temiz metni sayıya çevir: `42.50`.
6. `PRINT "sayi="; sayi` — `sayi= 42.5` yazar.
7. `PRINT "karekok="; SQRT(sayi)` — `karekok= 6.519` yazar.
8. `PRINT "buyuk harf="; UCASE("uxbasic")` — `buyuk harf= USBASIC` yazar.
9. `PRINT "saat="; TIMER()` — Şu anki zamanı yazar.

**Çıktı:**

```
[  42.50  ]
[42.50]
sayi= 42.5
karekok= 6.5192024025
buyuk harf= USBASIC
saat= 123456.789
```

> **Ders:** Fonksiyonları iç içe çağırmak, küçük işleri tek satırda birleştirmenin yoludur. Önce en içteki çalışır, sonucu dıştaki alır. `LTRIM(RTRIM(x))` örüntüsü iki yan boşluk temizliği için standarttır.

### 11.8 İleri Teknik — RND ile Simülasyon (Satır Satır Anlatım)

Bu örnek rastgele sayılarla bir kalite simülasyonu yapar.

```uxbasic
CONST ALT AS F64 = 98.5
CONST UST AS F64 = 101.5
CONST ADET AS I32 = 30

DIM olcum(30) AS F64
DIM i AS I32
DIM hatali AS I32
DIM toplam AS F64
DIM ortalama AS F64

RANDOMIZE TIMER()

FOR i = 1 TO ADET
    olcum(i) = 98.0 + RND() * 5.0
    IF olcum(i) < ALT OR olcum(i) > UST THEN
        hatali = hatali + 1
        PRINT "uyari: "; i; ". olcum = "; olcum(i)
    ELSE
        toplam = toplam + olcum(i)
    END IF
NEXT i

IF ADET - hatali > 0 THEN
    ortalama = toplam / (ADET - hatali)
    PRINT "saglam ortalama="; ortalama
END IF
PRINT "hatali adet="; hatali
PRINT "hatali orani=%"; (hatali * 100) / ADET
```

**Satır satır açıklama:**

1. `CONST ALT AS F64 = 98.5` — Alt sınır.
2. `CONST UST AS F64 = 101.5` — Üst sınır.
3. `CONST ADET AS I32 = 30` — Ölçüm adedi.
4. `DIM olcum(30) AS F64` — 30 elemanlı ölçüm dizisi.
5. `DIM i AS I32`, `DIM hatali AS I32`, `DIM toplam AS F64`, `DIM ortalama As F64` — Diğer değişkenler.
6. `RANDOMIZE TIMER()` — Rastgele üreteci tohumla. `TIMER()` ile her çalıştırmada farklı tohum.
7. `FOR i = 1 TO ADET` — 30 kez döngü.
8. `olcum(i) = 98.0 + RND() * 5.0` — `RND()` 0–1 arasında; 5 ile çarp 0–5 arası; 98 ekle 98–103 arası değer üret.
9. `IF olcum(i) < ALT OR olcum(i) > UST THEN` — Sınır dışı mı?
10. `hatali = hatali + 1` — Hatalı sayaçını artır.
11. `PRINT "uyari: "; i; ". olcum = "; olcum(i)` — Uyarı yaz.
12. `ELSE` — Sınırlar içindeyse.
13. `toplam = toplam + olcum(i)` — Toplama ekle.
14. `NEXT i` — Döngüyü sürdür.
15. `IF ADET - hatali > 0 THEN` — Eğer en az bir saglam ölçüm varsa.
16. `ortalama = toplam / (ADET - hatali)` — Saglam ölçümlerin ortalaması.
17. `PRINT "saglam ortalama="; ortalama` — Ortalamayı yaz.
18. `PRINT "hatali adet="; hatali` — Hatalı sayısını yaz.
19. `PRINT "hatali orani=%"; (hatali * 100) / ADET` — Yüzdeyi yaz.

**Örnek çıktı:**

```
uyari:  3 . olcum =  98.2
uyari:  17 . olcum =  101.8
saglam ortalama= 100.123
hatali adet= 2
hatali orani=% 6.6666666667
```

> **Ders:** `RND()` ile simülasyon, gerçek veri olmadan programı test etmenin en hızlı yoludur. Bir algoritma yazdığında, ona rastgele veri besleyip nasıl davrandığını görmek, gerçek veri geldiğinde hazır olmanı sağlar.

### 11.9 İleri Teknik — Süre Ölçümü (Satır Satır Anlatım)

Bu örnek farklı bir fonksiyonun ne kadar sürdüğünü ölçer.

```uxbasic
DIM basla As F64
DIM bitti As F64
DIM i As I32
DIM n As I64
DIM toplam As I64

basla = TIMER()

n = 1000000
toplam = 0
FOR i = 1 TO n
    toplam = toplam + i
NEXT i

bitti = TIMER()
PRINT "n="; n
PRINT "toplam="; toplam
PRINT "gecen sure="; bitti - basla; " saniye"
PRINT "hiz="; n / (bitti - basla); " islem/saniye"
```

**Satır satır açıklama:**

1. `basla = TIMER()` — İşlem öncesi zamanı al.
2. `n = 1000000` — Bir milyon döngü.
3. `toplam = 0` — Toplamı sıfırla.
4. `FOR i = 1 TO n` — Bir milyon kez döngü.
5. `toplam = toplam + i` — Her seferinde topla.
6. `NEXT i` — Döngüyü sürdür.
7. `bitti = TIMER()` — İşlem sonrası zamanı al.
8. `PRINT "n="; n` — n'i yaz.
9. `PRINT "toplam="; toplam` — Toplamı yaz: 500000500000.
10. `PRINT "gecen sure="; bitti - basla; " saniye"` — Fark: geçen süre.
11. `PRINT "hiz="; n / (bitti - basla); " islem/saniye"` — Saniyedeki işlem sayısı.

**Örnek çıktı:**

```
n= 1000000
toplam= 500000500000
gecen sure= 0.012 saniye
hiz= 83333333 islem/saniye
```

> **Ders:** `TIMER()` ile süre ölçmek, programın hangi bölümünün yavaş olduğunu bulmanın en basit yoludur. İki farklı algoritmayı karşılaştırmak için her ikisini de çalıştırıp süreleri ölçersin.

### 11.10 İleri Teknik — ASC/CHR ile Şifreleme (Satır Satır Anlatım)

Bu örnek basit bir karakter kaydırma şifrelemesi (Caesar cipher) yapar.

```uxbasic
FUNCTION Sifrele(metin AS STRING, kaydir AS I32) AS STRING
    DIM sonuc AS STRING
    DIM i AS I32
    DIM kod AS I32
    sonuc = ""
    FOR i = 1 TO LEN(metin)
        kod = ASC(MID(metin, i, 1))
        IF kod >= 65 AND kod <= 90 THEN
            kod = 65 + ((kod - 65 + kaydir) MOD 26)
        ELSEIF kod >= 97 AND kod <= 122 THEN
            kod = 97 + ((kod - 97 + kaydir) MOD 26)
        END IF
        sonuc = sonuc + CHR(kod)
    NEXT i
    RETURN sonuc
END FUNCTION

MAIN
    DIM orijinal AS STRING
    DIM sifreli AS STRING
    DIM cozulmus AS STRING

    orijinal = "Merhaba uXBasic"
    sifreli = Sifrele(orijinal, 3)
    cozulmus = Sifrele(sifreli, -3)

    PRINT "orijinal: "; orijinal
    PRINT "sifreli:  "; sifreli
    PRINT "cozulmus: "; cozulmus
END MAIN
```

**Satır satır açıklama:**

1. `FUNCTION Sifrele(metin AS STRING, kaydir AS I32) AS STRING` — Şifreleme fonksiyonu. Metni ve kaydırma miktarını alır.
2. `DIM sonuc AS STRING` — Sonuç metni.
3. `DIM i AS I32` — Döngü sayacı.
4. `DIM kod AS I32` — Karakterin ASCII kodu.
5. `sonuc = ""` — Sonucu boşalt.
6. `FOR i = 1 TO LEN(metin)` — Metnin her karakteri için döngü.
7. `kod = ASC(MID(metin, i, 1))` — i'inci karakterin ASCII kodunu al. `MID(metin, i, 1)` tek karakter döndürür.
8. `IF kod >= 65 AND kod <= 90 THEN` — Büyük harf mi (A–Z)?
9. `kod = 65 + ((kod - 65 + kaydir) MOD 26)` — Harfi 0–25 arasına getir, kaydır, mod 26 al, 65 ekle. Örn: `A (65)` + 3 = `D (68)`.
10. `ELSEIF kod >= 97 AND kod <= 122 THEN` — Küçük harf mi (a–z)?
11. `kod = 97 + ((kod - 97 + kaydir) MOD 26)` — Aynı işlem küçük harfler için.
12. `END IF` — Koşul bitimi.
13. `sonuc = sonuc + CHR(kod)` — Yeni karakteri sonuca ekle.
14. `NEXT i` — Döngüyü sürdür.
15. `RETURN sonuc` — Şifreli metni döndür.
16. `orijinal = "Merhaba uXBasic"` — Şifrelenecek metin.
17. `sifreli = Sifrele(orijinal, 3)` — 3 kaydırarak şifrele.
18. `cozulmus = Sifrele(sifreli, -3)` — -3 kaydırarak çöz (geri al).

**Çıktı:**

```
orijinal: Merhaba uXBasic
sifreli:  Phukded xZCdvlf
cozulmus: Merhaba uXBasic
```

> **Ders:** `ASC` ve `CHR` ile karakterin sayısal değerine inip işlem yapmak, metin işlemenin derin katmanıdır. Aynı mantıkla UTF-8 kod çözme, hex dönüşüm, base64 gibi işler yapılır. Bu örnek aynı zamanda `MID`, `LEN`, `FOR` ve fonksiyonların birlikte nasıl çalıştığını gösterir.

### 11.11 Bölüm Özeti

Yerel fonksiyonlar, uXBasic'in derleyiciye gömülü hazır işlevleridir. Matematik fonksiyonları hesap yapar (`ABS`, `INT`, `SGN`, `SQR`, `SIN`, `COS`, `LOG`, `EXP`, `RND`); metin fonksiyonları metinleri ölçer ve parçalar (`LEN`, `MID`, `LTRIM`, `RTRIM`, `UCASE`, `LCASE`, `ASC`, `CHR`, `STR`, `VAL`); tip dönüşüm fonksiyonları güvenli tip çevrimi sağlar (`CINT`, `CLNG`, `CSNG`, `CDBL`); I/O fonksiyonları tuş ve dosya sonunu denetler (`INKEY`, `GETKEY`, `EOF`, `LOF`); bellek fonksiyonları adrese iner (`PEEK`, `VARPTR`, `SADD`, `SIZEOF`, `OFFSETOF`); zaman fonksiyonu süre ölçer (`TIMER`). Bu fonksiyonları iç içe çağırmak, küçük işleri tek satırda birleştirmenin yoludur.

---

# Programcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek (Devam)

---

## BÖLÜM 12: İLERİ TEKNİKLER — OLAY, EŞZAMANLILIK, HOOK, WRAPPER, FFI, DLL

Bu bölümde programın katmanları arasındaki köprüleri inceleyeceğiz: olay sistemi (`EVENT`, `SLOT`, `TRIGGER`), veri boruları (`PIPE`), iş parçacıkları (`THREAD`, `PARALEL`), bağlama (`ON`/`OFF`), kanca [derleyici akışına zarar vermeden ek davranış takma noktası] (hook), sarmalayıcı [karmaşık dış çağrıyı temiz uXBasic çağrısına çeviren katman] (wrapper) ve dış dünya çağrısı (`DECLARE`, `CALL(DLL,...)`, `CALL(API,...)`, `IMPORT`).

### 12.1 Olay Sistemi Nedir?

Olay [bir şey oldu bilgisi] (event), programın "şu oldu" haberini veren mekanizmasıdır. Bir düğmeye basıldı, bir sensör veri gönderdi, bir dosya geldi, bir zaman doldu — bunların hepsi olaydır. Olay sistemi üç parçadan oluşur:

| Parça | Komut | Görev |
| --- | --- | --- |
| Olay bildirimi | `EVENT` | Olayın adını ve anlamını verir. |
| Tepki yuvası | `SLOT` | Olay geldiğinde çalışacak cevabı taşır. |
| Tetikleme | `TRIGGER` | Olayı elle veya otomatik çalıştırır. |

Olay sisteminin altın kuralı: **aynı değişkeni birçok işin rastgele değiştirmesine izin verme; veriyi boruyla taşı, olayı açık adla tetikle, tepkiyi yuva içinde topla.**

### 12.2 EVENT — Olay Bildirimi

**Sözdizimi:**

```
EVENT OlayAdi
```

`EVENT` ile olayın adı bildirilir. Daha sonra bu ad `SLOT` ve `TRIGGER` ile kullanılır.

```uxbasic
EVENT VeriGeldi
EVENT ButonTiklandi
EVENT ZamanDoldu
```

Üç olay bildirimi: sensör verisi geldi, buton tıklandı, zaman doldu. Bu adlar artık programın her yerinde kullanılabilir.

### 12.3 SLOT ve ON — Olaya Tepki

**Sözdizimi:**

```
SLOT Ad ON OlayAdi
    komutlar
END SLOT
```

`SLOT`, bir olay geldiğinde çalışacak kod yuvasını tanımlar. `ON` ile hangi olaya bağlandığını söyler.

```uxbasic
EVENT VeriGeldi

SLOT EkranaYaz ON VeriGeldi
    DIM v AS F64
    INPUT v
    PRINT "Yeni olcum="; v
    OPEN "olcum.log" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";" + STR(v)
    CLOSE #1
END SLOT
```

Bu yuva `VeriGeldi` olayı tetiklendiğinde çalışır. Önce bir değer okur (gerçek sensörden veya dosyadan), sonra ekrana yazar, sonra günlük dosyasına ekler.

### 12.4 TRIGGER — Olayı Tetikleme

**Sözdizimi:**

```
TRIGGER OlayAdi[, veri]
```

`TRIGGER` ile olay elle tetiklenir. Testte sensör varmış gibi davranmak için çok iyidir.

```uxbasic
EVENT VeriGeldi

SLOT EkranaYaz ON VeriGeldi
    PRINT "Veri geldi olayi islendi"
END SLOT

MAIN
    TRIGGER VeriGeldi
    TRIGGER VeriGeldi
    TRIGGER VeriGeldi
END MAIN
```

Üç kez `TRIGGER VeriGeldi` çağrıldığında yuva üç kez çalışır ve "Veri geldi olayi islendi" üç kez yazılır.

### 12.5 ON ve OFF — Bağlama ve Kapatma

`ON` ile olay ile tepki bağlanır (genellikle `SLOT` tanımında). `OFF` ile olay dinleme veya bağlı tepki kapatılır.

```uxbasic
EVENT VeriGeldi

SLOT EkranaYaz ON VeriGeldi
    PRINT "Veri geldi"
END SLOT

MAIN
    TRIGGER VeriGeldi       ' yuva calisir
    OFF VeriGeldi           ' olay dinlemeyi kapat
    TRIGGER VeriGeldi       ' yuva calismaz
END MAIN
```

`OFF VeriGeldi` çağrısından sonra olay tetiklense bile yuva çalışmaz. Bu, geçici durdurma, güvenli kapanış ve testte işe yarar.

### 12.6 PIPE — Veri Boru Hattı

`PIPE`, iki iş arasında veri taşıyan borudur. Paylaşılan değişken karmaşası yerine düzenli akış sağlar.

**Sözdizimi:**

```
PIPE Ad AS Tip
```

```uxbasic
PIPE HamOlcum AS F64
PIPE TemizOlcum AS F64
PIPE SonucMetni AS STRING
```

Üç boru: ham ölçüm, temiz ölçüm, sonuç metni. Veri bu borulardan akar; her aşamada bir işlem yapılır ve sonraki boruya geçilir.

### 12.7 THREAD — İş Parçacığı

`THREAD`, uzun işi ana akışı durdurmadan yapar. Dosya okuma, ağ bekleme ve hesaplama için uygundur.

**Sözdizimi:**

```
THREAD IsAdi
    komutlar
END THREAD
```

```uxbasic
THREAD ArkaPlan
    PRINT "uzun is basladi"
    DIM i AS I32
    FOR i = 1 TO 1000000
        ' uzun islem
    NEXT i
    PRINT "uzun is bitti"
END THREAD
```

`THREAD` bloğu içindeki iş arka planda çalışır; ana program akışı durmaz.

### 12.8 PARALEL — Bağımsız İşleri Gruplama

`PARALEL`, bağımsız işleri aynı aile altında planlar. Birbirine veri bağı olmayan hesaplar burada hız kazanır.

**Sözdizimi:**

```
PARALEL GrupAdi
    CALL Is1()
    CALL Is2()
    CALL Is3()
END PARALEL
```

```uxbasic
PARALEL SahaIzleme
    CALL SensorOku()
    CALL EkraniGuncelle()
    CALL LogYaz()
END PARALEL
```

Üç iş paralel yürütülür. Birbirini beklemeyen bağımsız işler için kullanılır.

### 12.9 İleri Teknik — Sensör, Boru, Yuva, İş Parçacığı (Satır Satır Anlatım)

Aşağıdaki örnek olay, boru, yuva ve iş parçacığını bir araya getirir.

```uxbasic
EVENT VeriGeldi
PIPE OlcumHatti AS F64

SLOT DosyayaYaz ON VeriGeldi
    DIM deger AS F64
    INPUT deger
    OPEN "saha.log" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";" + STR(deger)
    CLOSE #1
    IF deger < 6.5 OR deger > 8.5 THEN
        PRINT "ph alarm="; deger
    END IF
END SLOT

THREAD SensorOku
    DIM i AS I32
    FOR i = 1 TO 5
        TRIGGER VeriGeldi
    NEXT i
END THREAD

PARALEL SahaIzleme
    CALL SensorOku()
    PRINT "ana ekran donmedi"
END PARALEL
```

**Satır satır açıklama:**

1. `EVENT VeriGeldi` — `VeriGeldi` olayını bildir. Sensörden veri geldiğinde bu olay tetiklenecek.
2. `PIPE OlcumHatti AS F64` — `OlcumHatti` adında `F64` tipinde boru tanımla. Ölçüm değerleri bu borudan akacak.
3. `SLOT DosyayaYaz ON VeriGeldi` — `VeriGeldi` olayına `DosyayaYaz` yuvasını bağla. Olay tetiklendiğinde bu blok çalışır.
4. `DIM deger AS F64` — Ölçüm değerini tutacak yerel değişken.
5. `INPUT deger` — Sensörden (veya kullanıcıdan) değer oku. Gerçek sistemde bu, donanımdan veya ağdan gelir.
6. `OPEN "saha.log" FOR APPEND AS #1` — Günlük dosyasını ekleme modunda aç.
7. `PRINT #1, STR(TIMER()) + ";" + STR(deger)` — Zaman ve değeri noktalı virgülle ayırarak yaz. CSV formatı.
8. `CLOSE #1` — Dosyayı kapat.
9. `IF deger < 6.5 OR deger > 8.5 THEN` — pH sınır dışı mı?
10. `PRINT "ph alarm="; deger` — Alarm mesajı yaz.
11. `END IF` — Koşul bitimi.
12. `END SLOT` — Yuva bitimi.
13. `THREAD SensorOku` — Sensör okuma işini arka plana al.
14. `DIM i AS I32` — Döngü sayacı.
15. `FOR i = 1 TO 5` — 5 kez döngü.
16. `TRIGGER VeriGeldi` — `VeriGeldi` olayını tetikle. Her tetikleme yuvayı çalıştırır.
17. `NEXT i` — Döngüyü sürdür.
18. `END THREAD` — İş parçacığı bitimi.
19. `PARALEL SahaIzleme` — `SahaIzleme` paralel grubunu aç.
20. `CALL SensorOku()` — Sensör okuma işini çağır.
21. `PRINT "ana ekran donmedi"` — Ana akışın hâlâ çalıştığını göster.
22. `END PARALEL` — Paralel grup bitimi.

> **Ders:** Büyük fikir: sensör verisini doğrudan her yerden değişkene yazdırmıyoruz. Olay adı, tepki yuvası ve arka plan işi belirgin. Bu, GUI ve tarayıcıda da aynı mantıkla büyür.

### 12.10 Kanca (Hook) — Derleyici İz Bırakma

Kanca, derleyici veya çalışma zamanı akışında "bu noktada haber ver" demektir. uXBasic'te kanca ayrı bir anahtar sözcük değil, tasarım desenidir. `MODULE` içinde iz/toplama amacıyla yazılan `SUB`'larla gerçekleştirilir.

**Örnek — debug hook modülü:**

```uxbasic
MODULE DebugHook
    SUB KatmanGirdi(ad AS STRING, dosya AS STRING, satir AS I32)
        OPEN "hook_trace.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";ENTER;" + ad + ";" + dosya + ";" + STR(satir)
        CLOSE #1
    END SUB

    SUB KatmanCikti(ad AS STRING, durum AS STRING)
        OPEN "hook_trace.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";LEAVE;" + ad + ";" + durum
        CLOSE #1
    END SUB
END MODULE

SUB IslemYap()
    CALL DebugHook.KatmanGirdi("IslemYap", "main.uxb", 10)
    ' ... islem ...
    CALL DebugHook.KatmanCikti("IslemYap", "OK")
END SUB

MAIN
    CALL IslemYap()
END MAIN
```

Kanca modülü her giriş ve çıkışta log yazar. Bu, programın hangi aşamalardan geçtiğini izlemek için kullanılır. Derleyici geliştiricisinin en önemli aracıdır.

### 12.11 Sarmalayıcı (Wrapper) — Dış Çağrıyı Sadeleştirme

Sarmalayıcı, dış dünyanın karmaşasını uXBasic tarafında temiz fonksiyon hâline getirir. Bir DLL fonksiyonu on parametre istiyorsa, kullanıcının her yerde bunu yazması yerine bir `MODULE` içine `MesajGoster` fonksiyonu koyarsın.

**Örnek — Windows ses sarmalayıcısı:**

```uxbasic
NAMESPACE Win
    MODULE Ses
        DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

        FUNCTION Bip(hz AS I32, ms AS I32) AS BOOLEAN
            IF hz < 37 OR hz > 32767 THEN RETURN FALSE
            IF ms <= 0 THEN RETURN FALSE
            DIM r AS I32
            r = Beep(hz, ms)
            RETURN r <> 0
        END FUNCTION
    END MODULE
END NAMESPACE

MAIN
    IF Win.Ses.Bip(750, 250) THEN
        PRINT "ses verildi"
    ELSE
        PRINT "ses verilemedi"
    END IF
END MAIN
```

Bu sarmalayıcı kullanıcıyı Windows API ayrıntısından korur. `Beep` sınırları kontrol edilir. Hata sessizce geçmez; `BOOLEAN` sonuç döner. İyi wrapper dış çağrıyı güzelleştirir.

### 12.12 FFI — Dış Kaynak Bağlama

uXBasic, dış kaynak dosyalarını derleme zincirine bağlamanın üç yolunu sunar:

| Araç | Sözdizimi | Görev |
| --- | --- | --- |
| `INCLUDE` | `INCLUDE "dosya.uxbh"` | uXBasic başlık dosyasını ekler. |
| `IMPORT` | `IMPORT(C, "dosya.c")` | C/C++/ASM dosyasını derleme zincirine alır. |
| `DECLARE` | `DECLARE FUNCTION Ad LIB "dll" ALIAS "ad" (...) AS Tip` | DLL/API fonksiyon imzasını bildirir. |

**Örnek — C kaynak bağlama:**

```uxbasic
IMPORT(C, "native/hizli_toplam.c")
IMPORT(CPP, "native/model.cpp")
IMPORT(ASM, "native/memfast.asm")

DECLARE FUNCTION HizliToplam(a AS I32, b AS I32) AS I32

MAIN
    PRINT HizliToplam(12, 30)
END MAIN
```

`IMPORT(C, ...)` ile C kaynak dosyası derlenir ve bağlanır. `DECLARE` ile fonksiyon imzası uXBasic tarafında bildirilir. Sonra `HizliToplam(12, 30)` uXBasic içinde çağrılabilir.

### 12.13 CALL(DLL,...) ve CALL(API,...) — Dinamik Çağrı

`DECLARE` ile bildirilen fonksiyonlar doğrudan adlarıyla çağrılır. Ayrıca iki dinamik çağrı biçimi daha vardır:

| Biçim | Sözdizimi | Görev |
| --- | --- | --- |
| `CALL(DLL, ...)` | `CALL(DLL, "dll", "fonksiyon", argümanlar)` | Dinamik DLL çağrısı. |
| `CALL(API, ...)` | `CALL(API, "servis", "iş", argümanlar)` | Çalışma zamanı API servisi. |

**CALL(DLL,...) örneği:**

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

FUNCTION UyariSesi(hz AS I32, ms AS I32) AS BOOLEAN
    IF hz < 37 THEN RETURN FALSE
    DIM sonuc AS I32
    sonuc = CALL(DLL, "kernel32.dll", "Beep", hz, ms)
    IF sonuc = 0 THEN RETURN FALSE ELSE RETURN TRUE
END FUNCTION

MAIN
    IF UyariSesi(880, 150) THEN
        PRINT "ses verildi"
    ELSE
        PRINT "ses hatasi"
    END IF
END MAIN
```

### 12.14 CALL(API,...) — Çalışma Zamanı Servisleri

`CALL(API, "servis", "iş", ...)` ile uXBasic'in çalışma zamanı servisleri çağrılır. Bu servisler arasında JSON, HTTP, OS, browser, Llama, Lua, Prolog, SQLite, crypto, archive bulunur.

| Servis adı | Görev |
| --- | --- |
| `"json"` | JSON ayrıştırma ve sorgulama. |
| `"http"` | HTTP GET/POST istekleri. |
| `"curl"` | curl tabanlı güvenli ağ çağrısı. |
| `"os"` | İşletim sistemi bilgisi. |
| `"sqlite"` | SQLite veritabanı. |
| `"browser"` | Tarayıcı canvas, audio, DOM, fetch. |
| `"webgpu"` | GPU üzerinde hesap. |
| `"image"` | Görüntü yükleme/işleme. |
| `"archive"` | Zip oluşturma/açma. |
| `"crypto"` | Hash, HMAC, şifreleme. |
| `"llama"` | Yerel Llama modeli. |
| `"lua"` | Lua betik çalıştırma. |
| `"prolog"` | Prolog mantık sorgusu. |
| `"onnx"` | ONNX model çıkarımı. |

**JSON servisi örneği:**

```uxbasic
DIM ham AS STRING
DIM json AS PTR
DIM sicaklik AS F64

ham = "{""sicaklik"": 24.5, ""ph"": 7.2}"
json = CALL(API, "json", "parse", ham)
sicaklik = CALL(API, "json", "get_f64", json, "sicaklik")
PRINT "sicaklik="; sicaklik
CALL(API, "json", "free", json)
```

**HTTP servisi örneği:**

```uxbasic
DIM cevap AS STRING
cevap = CALL(API, "http", "get", "http://localhost:5000/olcum")
PRINT "cevap="; MID(cevap, 1, 80)
```

### 12.15 İleri Teknik — REST, DLL ve Log için Ortak Wrapper (Satır Satır Anlatım)

Aşağıdaki örnek dış dünyayı sarmalayıcıya kapatan kütüphane iskeletini gösterir.

```uxbasic
INCLUDE "modules/uxhttp.uxmh"
INCLUDE "modules/uxjson.uxmh"

NAMESPACE Sistem
    MODULE Log
        SUB Yaz(seviye AS STRING, mesaj AS STRING)
            OPEN "sistem.log" FOR APPEND AS #1
            PRINT #1, STR(TIMER()) + ";" + seviye + ";" + mesaj
            CLOSE #1
        END SUB
    END MODULE

    MODULE Ag
        FUNCTION Getir(url AS STRING) AS STRING
            TRY
                DIM cevap AS STRING
                cevap = ux_http_get(url)
                CALL Sistem.Log.Yaz("INFO", "GET basarili: " + url)
                RETURN cevap
            CATCH e
                CALL Sistem.Log.Yaz("ERROR", "GET hata: " + url)
                RETURN ""
            END TRY
        END FUNCTION
    END MODULE
END NAMESPACE

MAIN
    DIM ham AS STRING
    ham = Sistem.Ag.Getir("http://localhost:5000/status")
    IF LEN(ham) = 0 THEN
        PRINT "sunucu yok"
    ELSE
        PRINT "cevap="; MID(ham, 1, 80)
    END IF
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxhttp.uxmh"` — HTTP kütüphanesini ekle.
2. `INCLUDE "modules/uxjson.uxmh"` — JSON kütüphanesini ekle.
3. `NAMESPACE Sistem` — `Sistem` ad alanını aç. Sistemle ilgili her şey burada.
4. `MODULE Log` — Günlük yazma modülü.
5. `SUB Yaz(seviye AS STRING, mesaj AS STRING)` — `Yaz` alt yordamı. Seviye (INFO, ERROR, WARN) ve mesaj alır.
6. `OPEN "sistem.log" FOR APPEND AS #1` — Günlük dosyasını ekleme modunda aç.
7. `PRINT #1, STR(TIMER()) + ";" + seviye + ";" + mesaj` — Zaman, seviye ve mesajı CSV formatında yaz.
8. `CLOSE #1` — Dosyayı kapat.
9. `MODULE Ag` — Ağ modülü.
10. `FUNCTION Getir(url AS STRING) AS STRING` — `Getir` fonksiyonu. URL alır, cevap döndürür.
11. `TRY` — Hata çıkabilecek bölgeyi aç.
12. `DIM cevap AS STRING` — Cevap metni.
13. `cevap = ux_http_get(url)` — HTTP GET isteği yap.
14. `CALL Sistem.Log.Yaz("INFO", "GET basarili: " + url)` — Başarıyı günlüğe yaz.
15. `RETURN cevap` — Cevabı döndür.
16. `CATCH e` — Hata yakalandıysa.
17. `CALL Sistem.Log.Yaz("ERROR", "GET hata: " + url)` — Hata günlüğü yaz.
18. `RETURN ""` — Boş cevap döndür.
19. `END TRY` — Hata bölgesini kapat.
20. `ham = Sistem.Ag.Getir("http://localhost:5000/status")` — Sunucudan durum çek.
21. `IF LEN(ham) = 0 THEN` — Cevap boş mu?
22. `PRINT "sunucu yok"` — Sunucu yoksa haber ver.
23. `ELSE` — Cevap varsa.
24. `PRINT "cevap="; MID(ham, 1, 80)` — İlk 80 karakteri yaz.

> **Ders:** Dış dünya ile konuşma tek satıra indirilmiştir: `Sistem.Ag.Getir`. Ana program HTTP ayrıntısını bilmez. Hata loglanır. Dış çağrı yapılan yerde değil, sarmalayıcı içinde güvenli hâle getirilir. Bu, gerçek projelerin temel taşıdır.

### 12.16 İleri Teknik — Derleyici Katman İzleme (Satır Satır Anlatım)

Bu örnek derleyici katmanlarını olay sistemiyle izler.

```uxbasic
EVENT KatmanBasladi
EVENT KatmanBitti

SLOT KatmanLog ON KatmanBasladi
    DIM ad AS STRING
    INPUT ad
    OPEN "build_trace.csv" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";BEGIN;" + ad
    CLOSE #1
END SLOT

SLOT KatmanSon ON KatmanBitti
    DIM ad AS STRING
    INPUT ad
    OPEN "build_trace.csv" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";END;" + ad
    CLOSE #1
END SLOT

SUB KatmanCalistir(ad AS STRING)
    TRIGGER KatmanBasladi, ad
    PRINT "calisiyor: "; ad
    TRIGGER KatmanBitti, ad
END SUB

MAIN
    CALL KatmanCalistir("preprocessor")
    CALL KatmanCalistir("lexer")
    CALL KatmanCalistir("parser")
    CALL KatmanCalistir("semantic")
    CALL KatmanCalistir("mir")
    CALL KatmanCalistir("js-backend")
END MAIN
```

**Satır satır açıklama:**

1. `EVENT KatmanBasladi` — Bir katman başladığında bu olay tetiklenecek.
2. `EVENT KatmanBitti` — Bir katman bittiğinde bu olay tetiklenecek.
3. `SLOT KatmanLog ON KatmanBasladi` — `KatmanBasladi` olayına `KatmanLog` yuvasını bağla.
4. `DIM ad AS STRING` — Katman adı için yerel değişken.
5. `INPUT ad` — Tetiklemeden gelen veriyi oku (katman adı).
6. `OPEN "build_trace.csv" FOR APPEND AS #1` — İz dosyasını ekleme modunda aç.
7. `PRINT #1, STR(TIMER()) + ";BEGIN;" + ad` — Zaman ve katman adını yaz.
8. `CLOSE #1` — Dosyayı kapat.
9. `END SLOT` — Yuva bitimi.
10. `SLOT KatmanSon ON KatmanBitti` — `KatmanBitti` olayına `KatmanSon` yuvasını bağla. Benzer şekilde END yazar.
11. `SUB KatmanCalistir(ad AS STRING)` — Bir katmanı simüle eden alt yordam.
12. `TRIGGER KatmanBasladi, ad` — Başlama olayını tetikle, katman adını veri olarak gönder.
13. `PRINT "calisiyor: "; ad` — Ekrana bilgi yaz.
14. `TRIGGER KatmanBitti, ad` — Bitme olayını tetikle.
15. `MAIN` bloğunda altı katman sırayla çağrılır.

**Örnek çıktı (`build_trace.csv`):**

```
123456.100;BEGIN;preprocessor
123456.150;END;preprocessor
123456.155;BEGIN;lexer
123456.180;END;lexer
123456.185;BEGIN;parser
123456.230;END;parser
...
```

> **Ders:** Derleyici de olay sistemi gibi izlenebilir. Genç programcı kendi derleyicisini yazarken önce katman isimlerini loglamalıdır; sonra ölçüm, hata ve çıktı dosyası eklemelidir. Bu, hata ayıklamanın temelidir.

### 12.17 İleri Teknik — Inline C ile Hızlı Rutin (Satır Satır Anlatım)

```uxbasic
INLINE C
    int hizli_kare(int a) {
        return a * a;
    }
    int hizli_toplam(int n) {
        int t = 0;
        for (int i = 1; i <= n; i++) t += i;
        return t;
    }
END INLINE

DECLARE FUNCTION HizliKare(a AS I32) AS I32
DECLARE FUNCTION HizliToplam(n AS I32) AS I32

MAIN
    PRINT "5'in karesi="; HizliKare(5)
    PRINT "1..100 toplami="; HizliToplam(100)
END MAIN
```

**Satır satır açıklama:**

1. `INLINE C` — C kodu bloğu başlat.
2. `int hizli_kare(int a) { return a * a; }` — C'de kare fonksiyonu.
3. `int hizli_toplam(int n) { ... }` — C'de 1'den n'ye kadar toplam.
4. `END INLINE` — C bloğunu kapat.
5. `DECLARE FUNCTION HizliKare(a AS I32) AS I32` — uXBasic tarafında C fonksiyonunun imzasını bildir.
6. `DECLARE FUNCTION HizliToplam(n AS I32) AS I32` — İkinci fonksiyonun imzasını bildir.
7. `PRINT "5'in karesi="; HizliKare(5)` — `HizliKare(5)` çağrısı C koduna gider, `25` döner.
8. `PRINT "1..100 toplami="; HizliToplam(100)` — `HizliToplam(100)` çağrısı `5050` döndürür.

> **Ders:** `INLINE` ile hedefe özel hızlı rutinler uXBasic kaynağında tutulabilir. Genel program `MODULE` ve fonksiyon çağırısıyla temiz kalır. Hızın gerçekten kritik olduğu yerlerde uXBasic ile C arasında köprü kurmanın en hızlı yolu budur.

### 12.18 İleri Teknik — BYREF ile Çok Değerli Yordam (Satır Satır Anlatım)

Bu örnek `BYREF` parametrelerle bir yordamın birden fazla değer döndürmesini gösterir.

```uxbasic
SUB Istatistik(BYREF toplam AS F64, BYREF adet AS I32, BYREF min AS F64, BYREF max AS F64, BYVAL dizi AS PTR, BYREF n AS I32)
    DIM i AS I32
    DIM v AS F64
    toplam = 0
    adet = 0
    min = 1e30
    max = -1e30
    FOR i = 1 TO n
        v = dizi(i)
        toplam = toplam + v
        adet = adet + 1
        IF v < min THEN min = v
        IF v > max THEN max = v
    NEXT i
END SUB

MAIN
    DIM olcum(10) AS F64
    DIM i AS I32
    FOR i = 1 TO 10
        olcum(i) = 7.0 + RND() * 1.5
    NEXT i

    DIM t AS F64
    DIM n AS I32
    DIM mn AS F64
    DIM mx AS F64
    n = 10
    CALL Istatistik(t, n, mn, mx, olcum, n)

    PRINT "toplam="; t
    PRINT "adet="; n
    PRINT "min="; mn
    PRINT "max="; mx
    PRINT "ortalama="; t / n
END MAIN
```

**Satır satır açıklama:**

1. `SUB Istatistik(...)` — Beş parametreli alt yordam. Dört tanesi `BYREF`, biri `BYVAL`.
2. `BYREF toplam AS F64` — Toplamı çağıran tarafta değiştirilecek.
3. `BYREF adet AS I32` — Adedi çağıran tarafta değiştirilecek.
4. `BYREF min AS F64` — Minimumu çağıran tarafta değiştirilecek.
5. `BYREF max AS F64` — Maksimumu çağıran tarafta değiştirilecek.
6. `BYVAL dizi AS PTR` — Dizi kopya olarak değil, işaretçi olarak gönderilir.
7. `BYREF n AS I32` — Dizi boyutu.
8. `DIM i AS I32`, `DIM v AS F64` — Yerel değişkenler.
9. `toplam = 0` — Toplamı sıfırla.
10. `adet = 0` — Adedi sıfırla.
11. `min = 1e30` — Minimuma çok büyük bir başlangıç değeri ver.
12. `max = -1e30` — Maksimuma çok küçük bir başlangıç değeri ver.
13. `FOR i = 1 TO n` — Diziyi dolaş.
14. `v = dizi(i)` — i'inci elemanı oku.
15. `toplam = toplam + v` — Toplama ekle.
16. `adet = adet + 1` — Adedi artır.
17. `IF v < min THEN min = v` — Yeni minimum bulundu mu?
18. `IF v > max THEN max = v` — Yeni maksimum bulundu mu?
19. `NEXT i` — Döngüyü sürdür.
20. `MAIN`'de dizi 10 elemanla rastgele doldurulur.
21. `CALL Istatistik(t, n, mn, mx, olcum, n)` — Tek çağrıyla dört değer döner: `t`, `n` (zaten 10), `mn`, `mx`.
22. Sonuçlar ekrana yazılır.

**Örnek çıktı:**

```
toplam= 77.234
adet= 10
min= 7.012
max= 8.487
ortalama= 7.7234
```

> **Ders:** `BYREF` ile bir yordam birden çok değer döndürebilir. Bu, fonksiyonun tek değer döndürme kısıtlamasını aşmanın yoludur. Ama dikkat: `BYREF` ile geçirilen değişkenler yordam içinde değiştirilebilir; bu yüzden parametrelerin hangi yönle aktığını açıkça belirtmek iyidir.

### 12.19 Bölüm Özeti

Bu bölümde programın katmanları arasındaki köprüleri inceledik. Olay sistemi (`EVENT`, `SLOT`, `TRIGGER`, `ON`/`OFF`) ile "şu oldu" haberini taşıdık; boru (`PIPE`) ile veriyi düzenli akışla taşıdık; iş parçacığı (`THREAD`) ile uzun işi arka plana aldık; paralel grup (`PARALEL`) ile bağımsız işleri birlikte planladık. Kanca (hook) ile derleyici katmanlarına iz bıraktık; sarmalayıcı (wrapper) ile dış dünyanın karmaşasını temiz fonksiyonlara çevirdik. FFI (`IMPORT`, `DECLARE`, `CALL(DLL,...)`, `CALL(API,...)`) ile C/C++/ASM ve DLL dünyasına açıldık. İleri tekniklerin özü: **ana işi bozma, yalnız ölç ve bildir; dış ayrıntıyı tek yerde sakla; aç-kullan-yaz-kapat düzenini koru.**

---

## BÖLÜM 13: İLERİ TEKNİKLER — TARAYICI, JS, WASM, YAPAY ZEKÂ

Bu bölümde uXBasic programını dış dünyaya çıkaracağız: tarayıcı hedefi (`%%TARGET BROWSER`), JavaScript çıktısı (`--emit-js`), WebAssembly (`--emit-wat`, `--emit-wasm`), REST/HTTP ve yapay zekâ (Llama, ChatGPT, Gemini).

### 13.1 Web Hedefi Nedir?

Web hedefi, uXBasic kaynak dosyasının tarayıcıda çalışan bir çıktıya dönüştürülmesidir. Bu hedefte birkaç dosya birlikte oluşur:

| Dosya | Görevi |
| --- | --- |
| `program.js` | uXBasic kaynak kodunun JavaScript çıktısı. |
| `program.wat` | WASM için okunur metin çıktısı. |
| `program.wasm` | Tarayıcıda çalışan ikili WebAssembly çıktısı. |
| `index.html` | Tarayıcı kabuğu. |
| `manifest.json` | Hangi dosyalar üretildiğini bildirir. |
| `program_output.json` | Program çıktısının yapılandırılmış biçimi. |

### 13.2 Web CLI Komutları

| Uzun seçenek | Kısa fiil | Görev |
| --- | --- | --- |
| `--emit-js` | `ejs` | JavaScript üretimini açar. |
| `--js-out` | `jso` | JavaScript çıktı yolunu verir. |
| `--emit-wat` | `ewt` | WAT üretimini açar. |
| `--wat-out` | `wat` | WAT çıktı yolunu verir. |
| `--emit-wasm` | `ewm` | WASM üretimini açar. |
| `--wasm-out` | `wsm` | WASM çıktı yolunu verir. |
| `--html-out` | `htm` | HTML kabuk dosyasını üretir. |
| `--manifest-out` | `man` | Manifest dosyasını üretir. |

Mantığı şudur: `emit` üretimi açar, `out` yol söyler, `report` kanıt üretir, `trace` çalışma anını izler.

### 13.3 İlk Tarayıcı Programı

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Web Hedefi</h1>
<p id="durum">yukleniyor</p>
%%HTML_END
%%JS_LINE "document.getElementById('durum').innerText='hazir'"

MAIN
    PRINT "Tarayici programi basladi"
END MAIN
```

**Çalıştırma:**

```powershell
uxb ejs web.uxb --js-out dist/web/program.js --html-out dist/web/index.html
```

Bu komut iki dosya üretir: `program.js` (JavaScript çıktı) ve `index.html` (tarayıcı kabuğu). HTML dosyasını tarayıcıda açtığında uXBasic programın tarayıcıda çalışır.

### 13.4 Tarayıcı DOM ve Canvas Fonksiyonları

Tarayıcı hedefinde HTML öğeleriyle konuşmak için `uxbrowser_*` fonksiyonları kullanılır.

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `uxbrowser_canvas_init` | `CALL uxbrowser_canvas_init(id, gen, yuk)` | Tuval hazırlar. |
| `uxbrowser_canvas_clear` | `CALL uxbrowser_canvas_clear(renk)` | Tuvali temizler. |
| `uxbrowser_canvas_text` | `CALL uxbrowser_canvas_text(x, y, metin)` | Tuvale yazı yazar. |
| `uxbrowser_canvas_rect` | `CALL uxbrowser_canvas_rect(x, y, w, h)` | Dikdörtgen çizer. |
| `uxbrowser_canvas_line` | `CALL uxbrowser_canvas_line(x1, y1, x2, y2)` | Çizgi çizer. |
| `uxbrowser_dom_set_text` | `CALL uxbrowser_dom_set_text(id, metin)` | HTML öğesinin metnini değiştirir. |
| `uxbrowser_local_set` | `CALL uxbrowser_local_set(anahtar, deger)` | Tarayıcı yerel belleğine kaydeder. |
| `uxbrowser_local_get` | `deger = uxbrowser_local_get(anahtar)` | Tarayıcı yerel belleğinden okur. |
| `uxbrowser_audio_beep` | `CALL uxbrowser_audio_beep(frekans, ms)` | Kısa ses üretir. |

### 13.5 İleri Teknik — Tarayıcıda Canlı Tank İzleme (Satır Satır Anlatım)

Aşağıdaki örnek olay, boru, yuva, iş parçacığı ve tarayıcı canvas'ını birleştirir.

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "tank.html" BODY
<canvas id="ekran" width="900" height="500"></canvas>
<pre id="gunluk"></pre>
%%HTML_END

INCLUDE "modules/uxbrowser.uxmh"

EVENT OlcumGeldi
PIPE PhHatti AS F64

SLOT PanelGuncelle ON OlcumGeldi
    DIM ph AS F64
    DIM renk AS STRING
    ph = CALL PhHatti.Read()

    IF ph < 6.8 THEN
        renk = "#ffdddd"
    ELSEIF ph > 7.6 THEN
        renk = "#ddddff"
    ELSE
        renk = "#ddffdd"
    END IF

    CALL uxbrowser_canvas_clear(renk)
    CALL uxbrowser_canvas_text(30, 40, "Tank pH: " + STR(ph))
    CALL uxbrowser_canvas_rect(30, 120, CINT(ph * 80), 40)
    CALL uxbrowser_dom_set_text("gunluk", "Son olcum: " + STR(ph) + " zaman=" + STR(TIMER()))
    CALL uxbrowser_local_set("son_ph", STR(ph))
END SLOT

THREAD SensorBenzetimi
    DIM i AS I32
    DIM ph AS F64
    FOR i = 1 TO 20
        ph = 6.7 + RND() * 1.1
        CALL PhHatti.Write(ph)
        TRIGGER OlcumGeldi
    NEXT i
END THREAD

MAIN
    RANDOMIZE TIMER()
    CALL uxbrowser_canvas_init("ekran", 900, 500)
    CALL SensorBenzetimi()
END MAIN
```

**Satır satır açıklama:**

1. `%%TARGET BROWSER` — Hedefi tarayıcı olarak seç.
2. `%%HTML_BEGIN "tank.html" BODY` — `tank.html` dosyasının gövdesini başlat.
3. `<canvas id="ekran" width="900" height="500"></canvas>` — 900×500 piksel tuval.
4. `<pre id="gunluk"></pre>` — Günlük metni için HTML öğesi.
5. `%%HTML_END` — HTML bloğunu kapat.
6. `INCLUDE "modules/uxbrowser.uxmh"` — Tarayıcı kütüphanesini ekle.
7. `EVENT OlcumGeldi` — Ölçüm olayını bildir.
8. `PIPE PhHatti AS F64` — pH değerlerini taşıyacak boru.
9. `SLOT PanelGuncelle ON OlcumGeldi` — Ölçüm geldiğinde paneli güncelle.
10. `ph = CALL PhHatti.Read()` — Borudan değeri oku.
11. `IF ph < 6.8 THEN renk = "#ffdddd"` — pH düşükse kırmızımsı zemin.
12. `ELSEIF ph > 7.6 THEN renk = "#ddddff"` — pH yüksekse mavimsi zemin.
13. `ELSE renk = "#ddffdd"` — Normalde yeşilimsi zemin.
14. `CALL uxbrowser_canvas_clear(renk)` — Tuvaili bu renkle temizle.
15. `CALL uxbrowser_canvas_text(30, 40, "Tank pH: " + STR(ph))` — Koordinata yazı yaz.
16. `CALL uxbrowser_canvas_rect(30, 120, CINT(ph * 80), 40)` — pH değerine göre dikdörtgen çiz (bar grafik).
17. `CALL uxbrowser_dom_set_text("gunluk", ...)` — `gunluk` HTML öğesini güncelle.
18. `CALL uxbrowser_local_set("son_ph", STR(ph))` — Tarayıcı yerel belleğine son pH'ı kaydet.
19. `THREAD SensorBenzetimi` — Sensör benzetime işini arka plana al.
20. `FOR i = 1 TO 20` — 20 ölçüm üret.
21. `ph = 6.7 + RND() * 1.1` — 6.7–7.8 arası rastgele pH.
22. `CALL PhHatti.Write(ph)` — Değeri boruya yaz.
23. `TRIGGER OlcumGeldi` — Olayı tetikle; yuva çalışır.
24. `MAIN`'de tuval başlatılır ve sensör benzetime başlatılır.

> **Ders:** Ölçüm doğrudan ekrana yazılmaz; önce boruya girer, sonra olay tetiklenir, sonra yuva günceller. Bu mimari, gerçek zamanlı sistemlerin temelidir.

### 13.6 WASM Hedefi — Hızlı Çekirdek

WASM hedefi, uXBasic'in hızlı ve taşınabilir çekirdek üretme yoludur. Tarayıcıdaki JavaScript tarafı ekrana, DOM'a, dosyaya ve yapay zekaya daha kolay ulaşır; WASM tarafı ise hesapta güçlüdür. Kural: **çizim, düğme, ağ ve dosya işini JS köprüsüne bırak; yoğun matris, istatistik, sinir ağı veya simülasyon hesabını WASM çekirdeğine taşı.**

### 13.7 WAT/WASM Komut ve Fonksiyonları

| Öğe | Sözdizimi | Görev |
| --- | --- | --- |
| `--emit-wat` | `uxb ewt kaynak.uxb --out program.wat` | WAT üretimini açar. |
| `--wat-out` | `uxb wat kaynak.uxb --out program.wat` | WAT dosya yolunu verir. |
| `--emit-wasm` | `uxb ewm kaynak.uxb --out program.wasm` | WASM üretimini açar. |
| `--wasm-out` | `uxb wsm kaynak.uxb --out program.wasm` | WASM dosya yolunu verir. |
| `--wat2wasm` | `uxb w2w program.wat --out program.wasm` | WAT'ı WASM'a çevirir. |
| `ux_wasm_load` | `wasm = CALL ux_wasm_load("program.wasm")` | WASM modülünü yükler. |
| `ux_wasm_call` | `sonuc = CALL ux_wasm_call(wasm, "Fonk", arglar)` | WASM fonksiyonunu çağırır. |

### 13.8 İleri Teknik — WASM Çekirdek ile Risk Hesabı (Satır Satır Anlatım)

```uxbasic
%%TARGET WASM

FUNCTION Fcr(yemKg AS F64, artisKg AS F64) AS F64
    IF artisKg <= 0 THEN RETURN -1
    RETURN yemKg / artisKg
END FUNCTION

FUNCTION RiskPuani(fcr AS F64, olumOrani AS F64, phSapma AS F64) AS F64
    DIM puan AS F64
    puan = 0
    IF fcr > 1.40 THEN puan = puan + 30
    IF olumOrani > 2.0 THEN puan = puan + 35
    IF ABS(phSapma) > 0.4 THEN puan = puan + 25
    IF fcr < 0 THEN puan = 100
    RETURN puan
END FUNCTION

MAIN
    DIM f AS F64
    DIM risk AS F64
    f = Fcr(1350.0, 980.0)
    risk = RiskPuani(f, 1.8, 0.22)
    PRINT "FCR=" + STR(f)
    PRINT "Risk=" + STR(risk)
END MAIN
```

**Çalıştırma zinciri:**

```powershell
uxb ewt fcr.uxb --wat-out dist/wasm/fcr.wat --mir-verify-json-out out/mir_verify.json
uxb w2w dist/wasm/fcr.wat --out dist/wasm/fcr.wasm
uxb htm fcr.uxb --html-out dist/web/fcr.html --manifest-out dist/web/manifest.json
```

**Satır satır açıklama:**

1. `%%TARGET WASM` — Hedefi WASM olarak seç.
2. `FUNCTION Fcr(yemKg AS F64, artisKg AS F64) AS F64` — Yem dönüşüm oranı (FCR) hesabı. yemKg / artisKg.
3. `IF artisKg <= 0 THEN RETURN -1` — Sıfıra bölme hatasını önle.
4. `RETURN yemKg / artisKg` — FCR döndür.
5. `FUNCTION RiskPuani(fcr AS F64, olumOrani AS F64, phSapma AS F64) AS F64` — Risk puanı hesabı. Üç parametre alır.
6. `DIM puan AS F64` — Puan sayacı.
7. `puan = 0` — Başlangıçta puan sıfır.
8. `IF fcr > 1.40 THEN puan = puan + 30` — FCR yüksekse 30 puan ekle.
9. `IF olumOrani > 2.0 THEN puan = puan + 35` — Ölüm oranı yüksekse 35 puan ekle.
10. `IF ABS(phSapma) > 0.4 THEN puan = puan + 25` — pH sapması büyükse 25 puan ekle.
11. `IF fcr < 0 THEN puan = 100` — FCR negatifse (hata) direkt 100 puan.
12. `RETURN puan` — Toplam puanı döndür.
13. `MAIN`'de hesap yapılır ve sonuç yazılır.

> **Ders:** Hesap çekirdeği WASM'a uygundur çünkü girişler sayısal, sonuçlar sayısaldır. Aynı hesabın grafiği ve kullanıcı arayüzü tarayıcı JS tarafında yapılır.

### 13.9 JSON, HTTP ve REST Köprüsü

Dış dünya ile konuşurken JSON ve HTTP standart araçlardır.

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `uxhttp_get` | `cevap = uxhttp_get(url)` | HTTP GET isteği yapar. |
| `uxhttp_post_json` | `cevap = uxhttp_post_json(url, json)` | JSON gövdeli POST isteği yapar. |
| `uxjson_parse` | `doc = uxjson_parse(metin)` | JSON metnini belgeye çevirir. |
| `uxjson_get` | `deger = uxjson_get(doc, yol)` | JSON içinden alan okur. |
| `uxjson_stringify` | `metin = uxjson_stringify(doc)` | JSON belgeyi metne çevirir. |
| `uxcurl_exec` | `cevap = uxcurl_exec(komut)` | curl tabanlı güvenli sarmalayıcı. |

### 13.10 İleri Teknik — Flask Kalite Servisi İstemcisi (Satır Satır Anlatım)

```uxbasic
INCLUDE "modules/uxhttp.uxmh"
INCLUDE "modules/uxjson.uxmh"
INCLUDE "modules/uxstats.uxmh"

FUNCTION VeriJsonYap() AS STRING
    DIM j AS STRING
    DIM i AS I32
    j = "{\"hat\":\"A1\",\"olcum\":["
    FOR i = 1 TO 30
        DIM deger AS F64
        deger = 98.0 + RND() * 5.0
        j = j + STR(deger)
        IF i < 30 THEN j = j + ","
    NEXT i
    j = j + "]}"
    RETURN j
END FUNCTION

MAIN
    RANDOMIZE TIMER()
    DIM istek AS STRING
    DIM cevap AS STRING
    DIM doc AS PTR
    DIM risk AS STRING
    DIM ort AS F64

    istek = VeriJsonYap()
    cevap = CALL uxhttp_post_json("http://127.0.0.1:5050/kalite", istek)

    IF LEN(cevap) = 0 THEN
        PRINT "Sunucu cevap vermedi"
        END
    END IF

    doc = CALL uxjson_parse(cevap)
    ort = VAL(CALL uxjson_get(doc, "$.ortalama"))
    risk = CALL uxjson_get(doc, "$.risk")

    PRINT "Flask kalite servisi sonucu"
    PRINT "Ortalama=" + STR(ort)
    PRINT "Risk=" + risk

    IF risk = "YUKSEK" THEN
        PRINT "Uretim hatti durdurulup kalibrasyon kontrolu yapilmali."
    ELSE
        PRINT "Hat izlenmeye devam edebilir."
    END IF
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxhttp.uxmh"` — HTTP kütüphanesi.
2. `INCLUDE "modules/uxjson.uxmh"` — JSON kütüphanesi.
3. `INCLUDE "modules/uxstats.uxmh"` — İstatistik kütüphanesi.
4. `FUNCTION VeriJsonYap() AS STRING` — JSON isteği üreten fonksiyon.
5. `j = "{\"hat\":\"A1\",\"olcum\":["` — JSON başlangıcı. `\"` çift tırnak kaçışıdır.
6. `FOR i = 1 TO 30` — 30 ölçüm üret.
7. `deger = 98.0 + RND() * 5.0` — 98–103 arası rastgele ölçüm.
8. `j = j + STR(deger)` — Değeri JSON'a ekle.
9. `IF i < 30 THEN j = j + ","` — Son eleman hariç virgül koy.
10. `j = j + "]}"` — JSON'ı kapat.
11. `RETURN j` — JSON dizesini döndür.
12. `istek = VeriJsonYap()` — İsteği üret.
13. `cevap = CALL uxhttp_post_json("http://127.0.0.1:5050/kalite", istek)` — POST isteği yap.
14. `IF LEN(cevap) = 0 THEN` — Cevap boş mu?
15. `doc = CALL uxjson_parse(cevap)` — Cevap JSON'ını ayrıştır.
16. `ort = VAL(CALL uxjson_get(doc, "$.ortalama"))` — `$.ortalama` yolundan değeri al, sayıya çevir.
17. `risk = CALL uxjson_get(doc, "$.risk")` — `$.risk` yolundan risk seviyesini al.
18. `IF risk = "YUKSEK" THEN` — Yüksek riskse.
19. `PRINT "Uretim hatti durdurulup kalibrasyon kontrolu yapilmali."` — Müdahale öner.

> **Ders:** API yanıtını programın geri kalanına ham metin olarak taşımak yerine `risk`, `ortalama`, `uyarı` gibi anlamlı değişkenlere ayır. Bu, kodun okunurluğunu artırır ve hata olasılığını azaltır.

### 13.11 Yerel Yapay Zekâ — Llama

`uxllama` kütüphanesi ile yerel Llama modeli çalıştırılır. Ağır çağrıdır; her soru için model açıp kapatma. Modeli program başında aç, soruları gönder, program sonunda kapat.

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `uxllama_open` | `model = uxllama_open("model.gguf")` | GGUF modelini açar. |
| `uxllama_prompt` | `cevap = uxllama_prompt(model, soru)` | Modele soru gönderir. |
| `uxllama_prompt_json` | `json = uxllama_prompt_json(model, soru, sema)` | JSON yanıt ister. |
| `uxllama_set_param` | `uxllama_set_param(model, ad, deger)` | Sıcaklık vb. ayarlar. |
| `uxllama_close` | `uxllama_close(model)` | Modeli kapatır. |

### 13.12 İleri Teknik — Llama ile Laboratuvar Yorumu (Satır Satır Anlatım)

```uxbasic
INCLUDE "modules/uxllama.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM ph(1 TO 12) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM minv AS F64
    DIM maxv AS F64
    DIM model AS PTR
    DIM prompt AS STRING
    DIM yorum AS STRING

    ph(1)=7.12: ph(2)=7.18: ph(3)=7.31: ph(4)=7.44
    ph(5)=7.02: ph(6)=6.88: ph(7)=7.20: ph(8)=7.29
    ph(9)=7.33: ph(10)=7.09: ph(11)=7.15: ph(12)=7.50

    minv = ph(1)
    maxv = ph(1)
    FOR i = 1 TO 12
        toplam = toplam + ph(i)
        IF ph(i) < minv THEN minv = ph(i)
        IF ph(i) > maxv THEN maxv = ph(i)
    NEXT i
    ort = toplam / 12

    model = CALL uxllama_open("models/lab_assistant.gguf")
    IF model = 0 THEN
        PRINT "Model acilamadi; yalniz sayisal rapor yaziliyor."
        PRINT "Ortalama=" + STR(ort) + " Min=" + STR(minv) + " Max=" + STR(maxv)
        END
    END IF

    prompt = "Bir su urunleri laboratuvarinda pH ortalamasi " + STR(ort)
    prompt = prompt + ", minimum " + STR(minv) + ", maksimum " + STR(maxv)
    prompt = prompt + ". Kisa risk yorumu ve 3 pratik oneri yaz."

    yorum = CALL uxllama_prompt(model, prompt)
    PRINT "Sayisal ozet: ort=" + STR(ort) + " min=" + STR(minv) + " max=" + STR(maxv)
    PRINT "Yapay zeka yorumu:"
    PRINT yorum

    CALL uxllama_close(model)
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxllama.uxmh"` — Llama kütüphanesi.
2. `INCLUDE "modules/uxstats.uxmh"` — İstatistik kütüphanesi.
3. `DIM ph(1 TO 12) AS F64` — 12 pH ölçümü için dizi.
4. `ph(1)=7.12: ph(2)=7.18: ...` — Ölçümleri ata. `:` ile aynı satırda birden çok atama.
5. `minv = ph(1)`, `maxv = ph(1)` — İlk değeri başlangıç kabul et.
6. `FOR i = 1 TO 12` — Diziyi dolaş.
7. `toplam = toplam + ph(i)` — Toplama ekle.
8. `IF ph(i) < minv THEN minv = ph(i)` — Minimumu güncelle.
9. `IF ph(i) > maxv THEN maxv = ph(i)` — Maksimumu güncelle.
10. `ort = toplam / 12` — Ortalamayı hesapla.
11. `model = CALL uxllama_open("models/lab_assistant.gguf")` — Yerel Llama modelini aç. `.gguf` model dosyası.
12. `IF model = 0 THEN` — Model açılamadıysa.
13. `PRINT "Model acilamadi..."` — Sayısal raporu yaz ve çık.
14. `prompt = "Bir su urunleri laboratuvarinda pH ortalamasi " + STR(ort)` — Promptu oluştur.
15. `prompt = prompt + ", minimum " + STR(minv) + ", maksimum " + STR(maxv)` — Promptu genişlet.
16. `prompt = prompt + ". Kisa risk yorumu ve 3 pratik oneri yaz."` — İstek ekle.
17. `yorum = CALL uxllama_prompt(model, prompt)` — Modele sor, cevabı al.
18. `PRINT "Sayisal ozet: ..."` — Sayısal sonuçları yaz.
19. `PRINT yorum` — Yapay zekânın yorumunu yaz.
20. `CALL uxllama_close(model)` — Modeli kapat.

> **Ders:** Yapay zekâ hesabı yapmaz; hesabı uXBasic yapar. Yapay zekâ yorumu yapar. Kesin sayısal hesap makine mantığıyla yapılır; açıklama, özet, rapor dili ve öneri yapay zekaya bırakılabilir.

### 13.13 Bulut Yapay Zekâ — ChatGPT (OpenAI)

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `uxai_openai_set_key_from_env` | `CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")` | API anahtarını ortam değişkeninden alır. |
| `uxai_openai_response` | `cevap = uxai_openai_response(model, girdi)` | Tek yanıt üretir. |
| `uxai_openai_response_json` | `json = uxai_openai_response_json(model, girdi, sema)` | JSON yanıt ister. |
| `uxai_openai_cost_guard` | `CALL uxai_openai_cost_guard(token, deneme)` | Maliyet ve tekrar sınırı koyar. |
| `uxai_openai_save_log` | `CALL uxai_openai_save_log(yol)` | İstek/yanıt özetini günlüğe yazar. |

> **Güvenlik kuralı:** API anahtarını hiçbir zaman kaynak dosyasına düz yazma. Ortam değişkeni veya güvenli yerel köprü kullan.

### 13.14 İleri Teknik — ChatGPT ile Kalite Raporu (Satır Satır Anlatım)

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxai.uxmh"
INCLUDE "modules/uxjson.uxmh"

MAIN
    DIM olcum(1 TO 30) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM sapma AS F64
    DIM limitAlt AS F64
    DIM limitUst AS F64
    DIM hata AS I32
    DIM prompt AS STRING
    DIM cevap AS STRING

    limitAlt = 96.0
    limitUst = 104.0
    RANDOMIZE 2026

    FOR i = 1 TO 30
        olcum(i) = 98.0 + RND() * 8.0
        toplam = toplam + olcum(i)
        IF olcum(i) < limitAlt OR olcum(i) > limitUst THEN hata = hata + 1
    NEXT i
    ort = toplam / 30

    sapma = 0
    FOR i = 1 TO 30
        sapma = sapma + (olcum(i)-ort) * (olcum(i)-ort)
    NEXT i
    sapma = SQRT(sapma / 29)

    prompt = "30 uretim olcumu icin ortalama=" + STR(ort)
    prompt = prompt + ", standart sapma=" + STR(sapma)
    prompt = prompt + ", limit disi adet=" + STR(hata)
    prompt = prompt + ". Kisa, teknik ve uygulanabilir kalite raporu yaz."

    CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")
    CALL uxai_openai_cost_guard(1200, 1)
    cevap = CALL uxai_openai_response("OPENAI_MODEL", prompt)

    OPEN "kalite_ai_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "uXBasic sayisal ozet"
    PRINT #1, "Ortalama=" + STR(ort)
    PRINT #1, "StdSapma=" + STR(sapma)
    PRINT #1, "Limit disi=" + STR(hata)
    PRINT #1, "Yapay zeka yorumu:"
    PRINT #1, cevap
    CLOSE #1

    PRINT "Rapor yazildi: kalite_ai_raporu.txt"
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE` ile üç kütüphane eklenir.
2. `DIM olcum(1 TO 30) AS F64` — 30 ölçüm dizisi.
3. `limitAlt = 96.0`, `limitUst = 104.0` — Sınırlar.
4. `RANDOMIZE 2026` — Sabit tohum; her çalıştırmada aynı rastgele dizi.
5. `FOR i = 1 TO 30` — Ölçümleri üret.
6. `olcum(i) = 98.0 + RND() * 8.0` — 98–106 arası rastgele.
7. `toplam = toplam + olcum(i)` — Toplama ekle.
8. `IF olcum(i) < limitAlt OR olcum(i) > limitUst THEN hata = hata + 1` — Sınır dışı say.
9. `ort = toplam / 30` — Ortalama.
10. `sapma = 0` — Standart sapma için kareler toplamı.
11. `FOR i = 1 TO 30` — İkinci döngü: sapma hesabı.
12. `sapma = sapma + (olcum(i)-ort) * (olcum(i)-ort)` — Kare farkı ekle.
13. `sapma = SQRT(sapma / 29)` — Örnek standart sapması (n-1 ile böl).
14. `prompt = ...` — Yapay zekâya gönderilecek istek metni.
15. `CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")` — Anahtarı ortam değişkeninden al.
16. `CALL uxai_openai_cost_guard(1200, 1)` — En fazla 1200 token, 1 deneme.
17. `cevap = CALL uxai_openai_response("OPENAI_MODEL", prompt)` — Modele sor.
18. `OPEN "kalite_ai_raporu.txt" FOR OUTPUT AS #1` — Rapor dosyasını aç.
19. `PRINT #1, ...` — Sayısal özeti ve yapay zekâ yorumunu yaz.
20. `CLOSE #1` — Dosyayı kapat.

> **Ders:** Ölçüm üretimi, ortalama, standart sapma ve hata sayımı uXBasic tarafındadır. Yapay zekâ yalnız rapor dilini güçlendirir. Yapay zekadan "hesapla" değil, "hesapladığım sonucu anlaşılır rapora çevir" istenir.

### 13.15 Bulut Yapay Zekâ — Gemini (Google)

| Fonksiyon | Sözdizimi | Görev |
| --- | --- | --- |
| `uxai_gemini_set_key_from_env` | `CALL uxai_gemini_set_key_from_env("GEMINI_API_KEY")` | API anahtarını alır. |
| `uxai_gemini_generate` | `cevap = uxai_gemini_generate(model, girdi)` | Yanıt üretir. |
| `uxai_gemini_json` | `json = uxai_gemini_json(model, girdi, sema)` | JSON yanıt ister. |
| `uxai_gemini_interaction` | `id = uxai_gemini_interaction(model, girdi)` | Çok adımlı etkileşim başlatır. |
| `uxai_gemini_continue` | `cevap = uxai_gemini_continue(id, girdi)` | Etkileşimden devam eder. |

### 13.16 İleri Teknik — Gemini ile Sınıflandırma (Satır Satır Anlatım)

```uxbasic
INCLUDE "modules/uxai.uxmh"
INCLUDE "modules/uxjson.uxmh"

MAIN
    DIM veri AS STRING
    DIM sema AS STRING
    DIM cevap AS STRING
    DIM doc AS PTR
    DIM risk AS STRING
    DIM neden AS STRING

    veri = "TankA pH=7.1 DO=8.2 Sicaklik=19.4; "
    veri = veri + "TankB pH=6.5 DO=5.1 Sicaklik=23.0; "
    veri = veri + "TankC pH=7.3 DO=7.8 Sicaklik=20.2"

    sema = "{risk:string, neden:string, acil_oneri:string}"

    CALL uxai_gemini_set_key_from_env("GEMINI_API_KEY")
    cevap = CALL uxai_gemini_json("GEMINI_MODEL", "Bu su kalitesi ozetini siniflandir: " + veri, sema)

    doc = CALL uxjson_parse(cevap)
    risk = CALL uxjson_get(doc, "$.risk")
    neden = CALL uxjson_get(doc, "$.neden")

    PRINT "Gemini risk=" + risk
    PRINT "Neden=" + neden

    IF risk = "YUKSEK" THEN
        PRINT "Acil kontrol: oksijen ve sicaklik."
    ELSE
        PRINT "Rutin izleme yeterli."
    END IF
END MAIN
```

**Satır satır açıklama:**

1. `veri = "TankA pH=7.1 DO=8.2 Sicaklik=19.4; ..."` — Üç tankın su kalitesi özeti.
2. `sema = "{risk:string, neden:string, acil_oneri:string}"` — JSON şeması. Yapay zekâ bu şemada cevap verecek.
3. `CALL uxai_gemini_set_key_from_env("GEMINI_API_KEY")` — Anahtarı al.
4. `cevap = CALL uxai_gemini_json("GEMINI_MODEL", ...)` — Şemaya uygun JSON iste.
5. `doc = CALL uxjson_parse(cevap)` — Cevap JSON'ını ayrıştır.
6. `risk = CALL uxjson_get(doc, "$.risk")` — `risk` alanını al.
7. `neden = CALL uxjson_get(doc, "$.neden")` — `neden` alanını al.
8. `IF risk = "YUKSEK" THEN` — Yüksek riskse acil kontrol öner.

> **Ders:** Serbest metin insan için iyidir, JSON program için iyidir. Yapay zekâdan JSON biçiminde cevap istemek, sonucu programın geri kalanına kolayca bağlamanın yoludur.

### 13.17 İleri Teknik — Birleşik Proje: Tarayıcı + İstatistik + Yapay Zekâ (Satır Satır Anlatım)

Bu örnek tüm ileri teknikleri bir araya getirir: tarayıcı canvas, istatistik hesabı, yapay zekâ yorumu ve dosya raporu.

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<canvas id="ekran" width="960" height="540"></canvas>
<pre id="rapor"></pre>
%%HTML_END

INCLUDE "modules/uxbrowser.uxmh"
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxai.uxmh"

FUNCTION KaliteRisk(ort AS F64, sd AS F64, hata AS I32) AS STRING
    IF hata > 3 THEN RETURN "YUKSEK"
    IF ABS(ort - 100.0) > 2.0 THEN RETURN "ORTA"
    IF sd > 3.5 THEN RETURN "ORTA"
    RETURN "DUSUK"
END FUNCTION

MAIN
    DIM v AS PTR
    DIM i AS I32
    DIM deger AS F64
    DIM ort AS F64
    DIM sd AS F64
    DIM hata AS I32
    DIM risk AS STRING
    DIM prompt AS STRING
    DIM yorum AS STRING

    RANDOMIZE TIMER()
    v = CALL uxstats_vec_create()

    FOR i = 1 TO 30
        deger = 96.0 + RND() * 9.0
        CALL uxstats_vec_push(v, deger)
        IF deger < 96.0 OR deger > 104.0 THEN hata = hata + 1
    NEXT i

    ort = CALL uxstats_vec_mean(v)
    sd = CALL uxstats_vec_stddev(v)
    risk = KaliteRisk(ort, sd, hata)

    CALL uxbrowser_canvas_init("ekran", 960, 540)
    CALL uxbrowser_canvas_clear("#ffffff")
    CALL uxbrowser_canvas_text(30, 40, "uXBasic Akilli Kalite Paneli")
    CALL uxbrowser_canvas_text(30, 80, "Ortalama=" + STR(ort))
    CALL uxbrowser_canvas_text(30, 110, "StdSapma=" + STR(sd))
    CALL uxbrowser_canvas_text(30, 140, "Risk=" + risk)

    prompt = "30 uretim olcumu: ortalama=" + STR(ort)
    prompt = prompt + ", standart sapma=" + STR(sd)
    prompt = prompt + ", limit disi=" + STR(hata)
    prompt = prompt + ", risk=" + risk + ". Kisa teknik yorum ve 3 oneri ver."

    CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")
    yorum = CALL uxai_openai_response("OPENAI_MODEL", prompt)
    IF LEN(yorum) = 0 THEN yorum = "Yapay zeka yaniti alinamadi; sayisal rapor gecerlidir."

    CALL uxbrowser_dom_set_text("rapor", yorum)

    OPEN "son_kalite_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "Ortalama=" + STR(ort)
    PRINT #1, "StdSapma=" + STR(sd)
    PRINT #1, "LimitDisi=" + STR(hata)
    PRINT #1, "Risk=" + risk
    PRINT #1, yorum
    CLOSE #1

    CALL uxstats_vec_free(v)
END MAIN
```

**Satır satır açıklama:**

1. `%%TARGET BROWSER` — Tarayıcı hedefi.
2. `%%HTML_BEGIN ... %%HTML_END` — HTML kabuğunu tanımla: canvas ve rapor bölgesi.
3. `INCLUDE` ile tarayıcı, istatistik ve yapay zekâ kütüphanelerini ekle.
4. `FUNCTION KaliteRisk(ort, sd, hata) AS STRING` — Risk seviyesini hesapla.
5. `IF hata > 3 THEN RETURN "YUKSEK"` — 3'ten fazla hata varsa yüksek risk.
6. `IF ABS(ort - 100.0) > 2.0 THEN RETURN "ORTA"` — Ortalama hedeften uzaksa orta risk.
7. `IF sd > 3.5 THEN RETURN "ORTA"` — Değişkenlik yüksekse orta risk.
8. `RETURN "DUSUK"` — Hiçbiri değilse düşük risk.
9. `v = CALL uxstats_vec_create()` — İstatistik vektörü oluştur.
10. `FOR i = 1 TO 30` — 30 ölçüm üret ve vektöre ekle.
11. `ort = CALL uxstats_vec_mean(v)` — Ortalama hesapla.
12. `sd = CALL uxstats_vec_stddev(v)` — Standart sapma hesapla.
13. `risk = KaliteRisk(ort, sd, hata)` — Risk seviyesini belirle.
14. `CALL uxbrowser_canvas_init("ekran", 960, 540)` — Tuvali başlat.
15. `CALL uxbrowser_canvas_clear("#ffffff")` — Beyaz zemin.
16. `CALL uxbrowser_canvas_text(...)` — Sonuçları tuvale yaz.
17. `prompt = ...` — Yapay zekâ için prompt hazırla.
18. `CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")` — Anahtarı al.
19. `yorum = CALL uxai_openai_response("OPENAI_MODEL", prompt)` — Yorum al.
20. `CALL uxbrowser_dom_set_text("rapor", yorum)` — Yorumu HTML'e yaz.
21. `OPEN "son_kalite_raporu.txt" FOR OUTPUT AS #1` — Dosya raporu aç.
22. `PRINT #1, ...` — Tüm sonuçları yaz.
23. `CLOSE #1` — Dosyayı kapat.
24. `CALL uxstats_vec_free(v)` — Vektörü serbest bırak.

> **Ders:** Veri önce istatistik vektörüne girer, sonra sayısal değerler hesaplanır, sonra risk fonksiyonu karar verir, sonra tarayıcı paneli güncellenir, sonra yapay zekâ rapor dili üretir, son olarak rapor dosyaya yazılır. Bir programı büyütmenin doğru yolu satır eklemek değil, **sorumluluk ayırmaktır.**

### 13.18 Bölüm Özeti

Bu bölümde programı dış dünyaya çıkardık. Tarayıcı hedefi (`%%TARGET BROWSER`, `%%HTML_BEGIN`, `--emit-js`) ile uXBasic programını HTML+JS paketine dönüştürdük; `uxbrowser_*` fonksiyonları ile canvas, DOM ve ses'i yönettik. WASM hedefi (`%%TARGET WASM`, `--emit-wat`, `--emit-wasm`) ile hızlı hesap çekirdeği ürettik. JSON/HTTP köprüsü ile REST servisleriyle konuştuk. Yerel Llama, bulut ChatGPT ve Gemini ile yapay zekâ entegrasyonu kurduk. İleri tekniklerin özü: **hedefi işe göre seç — hesap WASM'a, arayüz JS'e, karar uXBasic'e, açıklama yapay zekâya, kanıt dosyaya.**

---

# Programcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek (Devam)

---

## BÖLÜM 14: TAM PROJELER — SATIR SATIR ANLATICI

Bu son bölümde kitap boyunca öğrenilen tüm kavramları bir araya getiren tam projeleri satır satır inceleyeceğiz. Her proje gerçek bir sorunu çözer; her satır nedeni ile açıklanır. Bu bölümün amacı, genç programcıya "büyük program nasıl yazılır" sorusunun cevabını göstermektir.

### 14.1 Proje 1 — Kapsamlı Üretim Kalite Kontrol Sistemi

Bu proje 30 ölçüm alır, sapma yüzdesini hesaplar, üretim kararını verir ve CSV raporu üretir. Bölüm 7.11'deki örneğin genişletilmiş, fonksiyonlara ayrılmış, dosya çıktılı ve hata korumalı hâlidir.

```uxbasic
' uretim_kalite.uxb — Kapsamli uretim kalite kontrol sistemi
CONST HEDEF AS F64 = 100.0
CONST UYARI_YUZDE AS F64 = 3.0
CONST RED_YUZDE AS F64 = 7.0
CONST ADET AS I32 = 30

FUNCTION SapmaYuzde(deger AS F64, hedef AS F64) AS F64
    IF hedef = 0 THEN RETURN 0
    RETURN ABS(deger - hedef) * 100.0 / hedef
END FUNCTION

FUNCTION DurumBelirle(sapma AS F64) AS STRING
    SELECT CASE sapma
    CASE IS > RED_YUZDE
        RETURN "RED"
    CASE IS > UYARI_YUZDE
        RETURN "UYARI"
    CASE ELSE
        RETURN "OK"
    END SELECT
END FUNCTION

MAIN
    DIM kalite(30) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ortalama AS F64
    DIM uyari AS I32
    DIM red AS I32
    DIM durum AS STRING

    RANDOMIZE 42
    FOR i = 1 TO ADET
        kalite(i) = 98.0 + RND() * 6.0
        IF i = 7 THEN kalite(i) = 90.0
        IF i = 23 THEN kalite(i) = 109.5
    NEXT i

    TRY
        OPEN "kalite_raporu.csv" FOR OUTPUT AS #1
        PRINT #1, "no;deger;sapma%;durum"

        FOR i = 1 TO ADET
            DIM sapma AS F64
            sapma = SapmaYuzde(kalite(i), HEDEF)
            durum = DurumBelirle(sapma)
            IF durum = "UYARI" THEN uyari = uyari + 1
            IF durum = "RED" THEN red = red + 1
            toplam = toplam + kalite(i)
            PRINT #1, STR(i) + ";" + STR(kalite(i)) + ";" + STR(sapma) + ";" + durum
        NEXT i

        ortalama = toplam / ADET
        PRINT #1, "ortalama;" + STR(ortalama)
        PRINT #1, "uyari;" + STR(uyari)
        PRINT #1, "red;" + STR(red)
        CLOSE #1

        ASSERT ortalama > 0
        IF red > 0 THEN
            PRINT "Uretimde kritik hata var"
        ELSEIF uyari > 0 THEN
            PRINT "Uretimde uyari seviyesinde sapma var"
        ELSE
            PRINT "Uretim kabul edilebilir"
        END IF
        PRINT "Rapor: kalite_raporu.csv"
    CATCH e
        PRINT "Dosya hatasi: "; e
    END TRY
END MAIN
```

**Satır satır açıklama:**

1. `' uretim_kalite.uxb — ...` — Yorum satırı. `'` ile başlayan satırlar derleyici tarafından yok sayılır; insanlar içindir.
2. `CONST HEDEF AS F64 = 100.0` — Hedef üretim değeri. Tüm ölçümler bu değere göre değerlendirilir.
3. `CONST UYARI_YUZDE AS F64 = 3.0` — Uyarı eşiği. Sapma %3'ü aşarsa "UYARI".
4. `CONST RED_YUZDE AS F64 = 7.0` — Red eşiği. Sapma %7'yi aşarsa "RED".
5. `CONST ADET AS I32 = 30` — Ölçüm adedi.
6. `FUNCTION SapmaYuzde(deger AS F64, hedef AS F64) AS F64` — Sapma yüzdesini hesaplayan fonksiyon. İki parametre alır, F64 döndürür.
7. `IF hedef = 0 THEN RETURN 0` — Sıfıra bölme hatasını önle. Hedef sıfırsa sapma tanımsızdır; sıfır döndür.
8. `RETURN ABS(deger - hedef) * 100.0 / hedef` — Sapma yüzdesi formülü: |deger - hedef| / hedef × 100.
9. `FUNCTION DurumBelirle(sapma AS F64) AS STRING` — Sapmaya göre durum etiketi üreten fonksiyon.
10. `SELECT CASE sapma` — Sapma değerine göre dallan.
11. `CASE IS > RED_YUZDE` — Sapma %7'den büyükse.
12. `RETURN "RED"` — "RED" döndür.
13. `CASE IS > UYARI_YUZDE` — Sapma %3'ten büyükse (ama %7'den değil).
14. `RETURN "UYARI"` — "UYARI" döndür.
15. `CASE ELSE` — Diğer durumlar (sapma %3'ten küçükse).
16. `RETURN "OK"` — "OK" döndür.
17. `END SELECT` — SELECT bloğunu kapat.
18. `DIM kalite(30) AS F64` — 30 elemanlı ölçüm dizisi.
19. `DIM i AS I32` — Döngü sayacı.
20. `DIM toplam AS F64` — Toplam (ortalama için).
21. `DIM ortalama AS F64` — Hesaplanacak ortalama.
22. `DIM uyari AS I32`, `DIM red AS I32` — Uyarı ve red sayaçları.
23. `DIM durum AS STRING` — Her ölçüm için durum etiketi.
24. `RANDOMIZE 42` — Rastgele üreteci sabit tohumla kur. Her çalıştırmada aynı dizi üretilir; test tekrarlanabilir.
25. `FOR i = 1 TO ADET` — 30 ölçüm üret.
26. `kalite(i) = 98.0 + RND() * 6.0` — 98–104 arası rastgele ölçüm.
27. `IF i = 7 THEN kalite(i) = 90.0` — 7. ölçümü bilerek boz. Sapma %10 → RED.
28. `IF i = 23 THEN kalite(i) = 109.5` — 23. ölçümü bilerek boz. Sapma %9.5 → RED.
29. `TRY` — Hata çıkabilecek bölgeyi aç. Dosya işlemleri hata verebilir.
30. `OPEN "kalite_raporu.csv" FOR OUTPUT AS #1` — CSV rapor dosyasını yazma için aç.
31. `PRINT #1, "no;deger;sapma%;durum"` — CSV başlık satırı.
32. `FOR i = 1 TO ADET` — Her ölçüm için rapor satırı üret.
33. `DIM sapma AS F64` — Bu ölçümün sapması (döngü içinde yerel).
34. `sapma = SapmaYuzde(kalite(i), HEDEF)` — Sapmayı hesapla.
35. `durum = DurumBelirle(sapma)` — Durum etiketini belirle.
36. `IF durum = "UYARI" THEN uyari = uyari + 1` — Uyarı sayacını artır.
37. `IF durum = "RED" THEN red = red + 1` — Red sayacını artır.
38. `toplam = toplam + kalite(i)` — Toplama ekle (ortalama için).
39. `PRINT #1, STR(i) + ";" + STR(kalite(i)) + ";" + STR(sapma) + ";" + durum` — CSV satırı yaz.
40. `NEXT i` — Döngüyü sürdür.
41. `ortalama = toplam / ADET` — Ortalamayı hesapla.
42. `PRINT #1, "ortalama;" + STR(ortalama)` — Ortalamayı CSV'ye ekle.
43. `PRINT #1, "uyari;" + STR(uyari)` — Uyarı adedini ekle.
44. `PRINT #1, "red;" + STR(red)` — Red adedini ekle.
45. `CLOSE #1` — Dosyayı kapat.
46. `ASSERT ortalama > 0` — Ortalama pozitif olmalı; değilse program durur.
47. `IF red > 0 THEN` — Red varsa.
48. `PRINT "Uretimde kritik hata var"` — Kritik hata mesajı.
49. `ELSEIF uyari > 0 THEN` — Red yok ama uyarı varsa.
50. `PRINT "Uretimde uyari seviyesinde sapma var"` — Uyarı mesajı.
51. `ELSE` — Hiç sorun yoksa.
52. `PRINT "Uretim kabul edilebilir"` — Kabul mesajı.
53. `END IF` — Koşul bitimi.
54. `PRINT "Rapor: kalite_raporu.csv"` — Rapor yolunu bildir.
55. `CATCH e` — Hata yakalandıysa.
56. `PRINT "Dosya hatasi: "; e` — Hata mesajını yaz.
57. `END TRY` — Hata bölgesini kapat.

**Örnek çıktı (`kalite_raporu.csv`):**

```
no;deger;sapma%;durum
1;101.234;1.234;OK
2;99.871;0.129;OK
3;102.456;2.456;OK
4;98.123;1.877;OK
5;100.567;0.567;OK
6;103.234;3.234;UYARI
7;90;10;RED
...
23;109.5;9.5;RED
...
ortalama;100.823
uyari;4
red;2
```

**Ekranda:**

```
Uretimde kritik hata var
Rapor: kalite_raporu.csv
```

> **Ders:** Sınır değerleri kodun içine saklanmamış, `CONST` ile adlandırılmıştır. Böylece yarın kalite sınırı değişirse bütün programı aramazsın. `SapmaYuzde` fonksiyonu tek işi yapar; hem raporda hem ekranda kullanılabilir. Hata yönetimi `TRY/CATCH` ile korunmuştur; dosya açılamazsa program çökmez.

### 14.2 Proje 2 — Çok Modüllü Tarayıcı Paneli

Bu proje beş modüllü bir mimari kurar: config, data, analysis, ui ve ana program. Her modül ayrı bir dosyada durur; ana program sadece orkestrasyon yapar.

**Dosya düzeni:**

```
app.uxb              ana program
include/config.uxbh  sabitler ve ön-işleyici ayarları
modules/data.uxb     CSV/DF okuma
modules/analysis.uxb istatistik ve matris hesabı
modules/ui.uxb       terminal veya browser çıktısı
```

**`include/config.uxbh`:**

```uxbasic
' config.uxbh — Ortak sabitler
CONST APP_NAME AS STRING = "SahaRaporu"
CONST VERSION AS STRING = "1.0"
CONST ALT_PH AS F64 = 6.5
CONST UST_PH AS F64 = 8.5
CONST ALT_OKSIJEN AS F64 = 5.0
CONST UST_SICAKLIK AS F64 = 28.0
```

**`modules/data.uxb`:**

```uxbasic
' data.uxb — Veri yukleme modulu
SUB LoadCsv(BYREF olcumler AS PTR, yol AS STRING)
    DIM satir AS STRING
    DIM deger AS F64
    olcumler = ux_list_new()
    TRY
        OPEN yol FOR INPUT AS #1
        DO WHILE EOF(#1) = 0
            INPUT #1, satir
            deger = VAL(satir)
            CALL ux_list_push_f64(olcumler, deger)
        LOOP
        CLOSE #1
    CATCH e
        PRINT "Veri yukleme hatasi: "; e
    END TRY
END SUB
```

**`modules/analysis.uxb`:**

```uxbasic
' analysis.uxb — Istatistik modulu
FUNCTION Ortalama(olcumler AS PTR) AS F64
    DIM n AS I32
    DIM toplam AS F64
    DIM i AS I32
    n = ux_list_count(olcumler)
    IF n = 0 THEN RETURN 0
    FOR i = 1 TO n
        toplam = toplam + ux_list_get_f64(olcumler, i)
    NEXT i
    RETURN toplam / n
END FUNCTION

FUNCTION StdSapma(olcumler AS PTR) AS F64
    DIM n AS I32
    DIM ort AS F64
    DIM kareler AS F64
    DIM i AS I32
    DIM v AS F64
    n = ux_list_count(olcumler)
    IF n < 2 THEN RETURN 0
    ort = Ortalama(olcumler)
    FOR i = 1 TO n
        v = ux_list_get_f64(olcumler, i)
        kareler = kareler + (v - ort) * (v - ort)
    NEXT i
    RETURN SQRT(kareler / (n - 1))
END FUNCTION
```

**`modules/ui.uxb`:**

```uxbasic
' ui.uxb — Cikti modulu
SUB ShowReport(ort AS F64, sd AS F64, n AS I32)
    CLS
    COLOR 15, 1
    LOCATE 1, 1: PRINT APP_NAME + " v" + VERSION
    COLOR 10, 0
    LOCATE 3, 1: PRINT "Olcum adedi="; n
    LOCATE 4, 1: PRINT "Ortalama="; ort
    LOCATE 5, 1: PRINT "Standart sapma="; sd
    COLOR 7, 0
    LOCATE 7, 1
    IF sd > 1.0 THEN
        PRINT "Yorum: Degiskenlik yuksek"
    ELSE
        PRINT "Yorum: Degiskenlik dusuk"
    END IF
END SUB
```

**`app.uxb`:**

```uxbasic
' app.uxb — Ana program
%%TARGET X64
INCLUDE "include/config.uxbh"
INCLUDE "modules/data.uxb"
INCLUDE "modules/analysis.uxb"
INCLUDE "modules/ui.uxb"

MAIN
    DIM olcumler AS PTR
    DIM ort AS F64
    DIM sd AS F64
    DIM n AS I32

    CALL LoadCsv(olcumler, "olcum.csv")
    n = ux_list_count(olcumler)
    IF n = 0 THEN
        PRINT "Veri yok"
        END
    END IF

    ort = Ortalama(olcumler)
    sd = StdSapma(olcumler)
    CALL ShowReport(ort, sd, n)

    CALL ux_list_free(olcumler)
END MAIN
```

**Satır satır açıklama (app.uxb):**

1. `%%TARGET X64` — Hedef: x64 assembly. Konsol programı için uygun.
2. `INCLUDE "include/config.uxbh"` — Ortak sabitleri ekle. `APP_NAME`, `ALT_PH` vb. hazır gelir.
3. `INCLUDE "modules/data.uxb"` — Veri yükleme modülünü ekle. `LoadCsv` çağrılabilir.
4. `INCLUDE "modules/analysis.uxb"` — İstatistik modülünü ekle. `Ortalama`, `StdSapma` çağrılabilir.
5. `INCLUDE "modules/ui.uxb"` — Arayüz modülünü ekle. `ShowReport` çağrılabilir.
6. `DIM olcumler AS PTR` — Veri listesi için handle.
7. `DIM ort AS F64`, `DIM sd AS F64`, `DIM n AS I32` — Sonuç değişkenleri.
8. `CALL LoadCsv(olcumler, "olcum.csv")` — CSV dosyasını oku, listeye yükle. `olcumler` `BYREF` olduğu için çağıran tarafta değişir.
9. `n = ux_list_count(olcumler)` — Kaç ölçüm yüklendi?
10. `IF n = 0 THEN` — Veri yoksa.
11. `PRINT "Veri yok"` — Bilgi ver.
12. `END` — Programı bitir.
13. `ort = Ortalama(olcumler)` — Ortalamayı hesapla.
14. `sd = StdSapma(olcumler)` — Standart sapmayı hesapla.
15. `CALL ShowReport(ort, sd, n)` — Ekrana rapor çiz.
16. `CALL ux_list_free(olcumler)` — Liste handle'ını bırak. Bellek temizliği.

> **Ders:** Bu düzen genç programcıya üç şey kazandırır: hata nerede anlaşılır, dosyalar büyüyünce korkutmaz, aynı modül başka projede tekrar kullanılır. İyi mimari budur: ana akış roman gibi okunur, ayrıntı modüllerde durur.

### 14.3 Proje 3 — Derleyici Katman İzleyici

Bu proje derleyicinin katmanlarını olay sistemiyle izler ve CSV iz dosyası üretir. Her katmanın başlama ve bitme zamanını kaydeder; süre hesabı yapar.

```uxbasic
' derleyici_iz.uxb — Derleyici katman izleyici
EVENT KatmanBasladi
EVENT KatmanBitti

PIPE KatmanAdi AS STRING
PIPE BaslamaZamani AS F64

DIM gecmisKatman AS STRING

SLOT KatmanLogBasla ON KatmanBasladi
    DIM ad AS STRING
    DIM zaman As F64
    INPUT ad
    zaman = TIMER()
    OPEN "build_trace.csv" FOR APPEND AS #1
    PRINT #1, STR(zaman) + ";BEGIN;" + ad
    CLOSE #1
    gecmisKatman = ad
END SLOT

SLOT KatmanLogBitir ON KatmanBitti
    DIM ad AS STRING
    DIM zaman As F64
    INPUT ad
    zaman = TIMER()
    OPEN "build_trace.csv" FOR APPEND AS #1
    PRINT #1, STR(zaman) + ";END;" + ad
    CLOSE #1
END SLOT

SUB KatmanCalistir(ad AS STRING)
    TRIGGER KatmanBasladi, ad
    PRINT "calisiyor: "; ad
    DIM i AS I32
    DIM toplam AS I64
    FOR i = 1 TO 100000
        toplam = toplam + i
    NEXT i
    TRIGGER KatmanBitti, ad
END SUB

MAIN
    OPEN "build_trace.csv" FOR OUTPUT AS #1
    PRINT #1, "zaman;yol;katman"
    CLOSE #1

    CALL KatmanCalistir("preprocessor")
    CALL KatmanCalistir("lexer")
    CALL KatmanCalistir("parser")
    CALL KatmanCalistir("semantic")
    CALL KatmanCalistir("mir")
    CALL KatmanCalistir("codegen")
    CALL KatmanCalistir("backend")

    PRINT "Derleme izi: build_trace.csv"
END MAIN
```

**Satır satır açıklama:**

1. `EVENT KatmanBasladi` — Katman başlama olayı.
2. `EVENT KatmanBitti` — Katman bitme olayı.
3. `PIPE KatmanAdi AS STRING` — Katman adını taşıyacak boru.
4. `PIPE BaslamaZamani AS F64` — Başlama zamanını taşıyacak boru.
5. `DIM gecmisKatman AS STRING` — Önceki katmanın adını tutacak (süre hesabı için).
6. `SLOT KatmanLogBasla ON KatmanBasladi` — Başlama olayına yuva bağla.
7. `DIM ad AS STRING` — Tetiklemeden gelen katman adı.
8. `INPUT ad` — Veriyi oku.
9. `zaman = TIMER()` — Şu anki zamanı al.
10. `OPEN "build_trace.csv" FOR APPEND AS #1` — İz dosyasını ekleme modunda aç.
11. `PRINT #1, STR(zaman) + ";BEGIN;" + ad` — Zaman, BEGIN, katman adı yaz.
12. `CLOSE #1` — Dosyayı kapat.
13. `gecmisKatman = ad` — Bu katmanı geçmişe kaydet.
14. `SLOT KatmanLogBitir ON KatmanBitti` — Bitme olayına yuva bağla.
15. `zaman = TIMER()` — Bitme zamanını al.
16. `PRINT #1, STR(zaman) + ";END;" + ad` — Zaman, END, katman adı yaz.
17. `SUB KatmanCalistir(ad AS STRING)` — Bir katmanı simüle eden alt yordam.
18. `TRIGGER KatmanBasladi, ad` — Başlama olayını tetikle, adı gönder.
19. `PRINT "calisiyor: "; ad` — Ekrana bilgi yaz.
20. `FOR i = 1 TO 100000` — Yapay iş yükü: 100 bin iterasyon.
21. `toplam = toplam + i` — Boş iş.
22. `TRIGGER KatmanBitti, ad` — Bitme olayını tetikle.
23. `MAIN`'de dosyayı sıfırla (OUTPUT modunda aç, başlık yaz, kapat).
24. Yedi katmanı sırayla çağır.
25. İz dosyasının yolunu bildir.

**Örnek çıktı (`build_trace.csv`):**

```
zaman;yol;katman
123456.100;BEGIN;preprocessor
123456.150;END;preprocessor
123456.155;BEGIN;lexer
123456.180;END;lexer
123456.185;BEGIN;parser
123456.230;END;parser
123456.235;BEGIN;semantic
123456.290;END;semantic
123456.295;BEGIN;mir
123456.340;END;mir
123456.345;BEGIN;codegen
123456.400;END;codegen
123456.405;BEGIN;backend
123456.460;END;backend
```

> **Ders:** Derleyici de olay sistemi gibi izlenebilir. Genç programcı kendi derleyicisini yazarken önce katman isimlerini loglamalıdır; sonra ölçüm, hata ve çıktı dosyası eklemelidir. Bu, performans darboğazlarını bulmanın temelidir.

### 14.4 Proje 4 — Bilimsel Deney Veri Analizi

Bu proje iki gruplu bir bilimsel deneyi simüle eder: kontrol grubu ve uygulama grubu. Her grupta 15 ölçüm vardır. F-testi ve t-testi ile gruplar karşılaştırılır.

```uxbasic
' deney_analiz.uxb — Bilimsel deney veri analizi
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM yemA AS PTR
    DIM yemB AS PTR
    DIM i AS I32
    DIM a AS F64
    DIM b AS F64
    DIM f AS F64
    DIM t AS F64
    DIM varA AS F64
    DIM varB AS F64
    DIM yorum AS STRING

    RANDOMIZE TIMER()
    yemA = CALL uxstats_vec_create()
    yemB = CALL uxstats_vec_create()

    FOR i = 1 TO 15
        CALL uxstats_vec_push(yemA, 1.20 + RND() * 0.20)
        CALL uxstats_vec_push(yemB, 1.28 + RND() * 0.35)
    NEXT i

    a = CALL uxstats_vec_mean(yemA)
    b = CALL uxstats_vec_mean(yemB)
    varA = CALL uxstats_vec_var(yemA)
    varB = CALL uxstats_vec_var(yemB)
    f = CALL uxstats2_f_variance(varA, 15, varB, 15)
    t = CALL uxstats2_t_independent(yemA, yemB)

    PRINT "=== Deney Analizi ==="
    PRINT "Yem A ort=" + STR(a) + " varyans=" + STR(varA)
    PRINT "Yem B ort=" + STR(b) + " varyans=" + STR(varB)
    PRINT "F testi=" + STR(f)
    PRINT "T testi=" + STR(t)

    IF f > 2.5 THEN
        yorum = "Yem gruplarinin degiskenligi farkli olabilir; once varyans farkini raporla."
    ELSEIF ABS(t) > 2.05 THEN
        yorum = "Ortalama farki dikkat cekici; biyolojik ve ekonomik anlamini incele."
    ELSE
        yorum = "Belirgin fark gorunmuyor; daha cok tekrar gerekebilir."
    END IF
    PRINT "Yorum: " + yorum

    OPEN "deney_sonuc.txt" FOR OUTPUT AS #1
    PRINT #1, "Deney Analizi Raporu"
    PRINT #1, "Yem A: ort=" + STR(a) + " varyans=" + STR(varA)
    PRINT #1, "Yem B: ort=" + STR(b) + " varyans=" + STR(varB)
    PRINT #1, "F=" + STR(f) + " T=" + STR(t)
    PRINT #1, "Yorum: " + yorum
    CLOSE #1

    CALL uxstats_vec_free(yemA)
    CALL uxstats_vec_free(yemB)
    PRINT "Rapor: deney_sonuc.txt"
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxstats.uxmh"` — Temel istatistik kütüphanesi.
2. `INCLUDE "modules/uxstats2.uxmh"` — İleri istatistik (F-testi, t-testi).
3. `DIM yemA AS PTR`, `DIM yemB AS PTR` — İki grup için vektör handle'ları.
4. `DIM a AS F64`, `DIM b AS F64` — Grup ortalamaları.
5. `DIM f AS F64`, `DIM t AS F64` — F ve t test istatistikleri.
6. `DIM varA AS F64`, `DIM varB AS F64` — Grup varyansları.
7. `DIM yorum AS STRING` — Sonuç yorumu.
8. `RANDOMIZE TIMER()` — Tohumla, her çalıştırmada farklı veri.
9. `yemA = CALL uxstats_vec_create()` — A grubu için vektör aç.
10. `yemB = CALL uxstats_vec_create()` — B grubu için vektör aç.
11. `FOR i = 1 TO 15` — Her gruba 15 ölçüm ekle.
12. `CALL uxstats_vec_push(yemA, 1.20 + RND() * 0.20)` — A grubuna 1.20–1.40 arası değer.
13. `CALL uxstats_vec_push(yemB, 1.28 + RND() * 0.35)` — B grubuna 1.28–1.63 arası değer. B'nin varyansı daha yüksek.
14. `a = CALL uxstats_vec_mean(yemA)` — A ortalaması.
15. `b = CALL uxstats_vec_mean(yemB)` — B ortalaması.
16. `varA = CALL uxstats_vec_var(yemA)` — A varyansı.
17. `varB = CALL uxstats_vec_var(yemB)` — B varyansı.
18. `f = CALL uxstats2_f_variance(varA, 15, varB, 15)` — F-testi: iki varyansı karşılaştır.
19. `t = CALL uxstats2_t_independent(yemA, yemB)` — t-testi: iki grup ortalamasını karşılaştır.
20. `IF f > 2.5 THEN` — F değeri yüksekse varyanslar farklı.
21. `yorum = "Yem gruplarinin degiskenligi farkli olabilir; ..."` — Önce varyans farkını raporla.
22. `ELSEIF ABS(t) > 2.05 THEN` — t değeri 2.05'ten büyükse ortalama farkı anlamlı.
23. `yorum = "Ortalama farki dikkat cekici; ..."` — Biyolojik anlamı incele.
24. `ELSE` — Hiçbiri değilse.
25. `yorum = "Belirgin fark gorunmuyor; ..."` — Daha çok tekrar gerekli.
26. Dosyaya rapor yaz.
27. Vektörleri serbest bırak.

> **Ders:** Önce değişkenlik çok farklı mı diye bakarsın; sonra ortalama farkını yorumlarsın. İstatistik tek sayı değildir, karar zinciridir. F ve t testi birlikte düşünülmelidir; tek başına yeterli değildir.

### 14.5 Proje 5 — Sembol Tablosu Uygulaması

Bu proje bir derleyicinin sembol tablosunu uXBasic ile kurar. Her değişkenin adını, tipini ve bildirim sırasını tutar; tekrar bildirimi yakalar.

```uxbasic
' sembol_tablosu.uxb — Derleyici sembol tablosu
INCLUDE "modules/uxcollections.uxmh"

SUB SembolEkle(adlar AS PTR, tipler AS PTR, siralama AS PTR, ad AS STRING, tip AS STRING)
    IF ux_set_contains(adlar, ad) THEN
        PRINT "TEKRAR: "; ad; " zaten tanimli"
        EXIT SUB
    END IF
    CALL ux_set_add(adlar, ad)
    CALL ux_dict_set_string(tipler, ad, tip)
    CALL ux_list_push_string(siralama, ad)
    PRINT "EKLENDI: "; ad; " : "; tip
END SUB

FUNCTION SembolSorgula(tipler AS PTR, ad AS STRING) AS STRING
    DIM tip AS STRING
    tip = ux_dict_get_string(tipler, ad)
    IF LEN(tip) = 0 THEN RETURN "TANIMSIZ"
    RETURN tip
END FUNCTION

MAIN
    DIM adlar AS PTR
    DIM tipler AS PTR
    DIM siralama AS PTR
    DIM i AS I32

    adlar = ux_set_new()
    tipler = ux_dict_new()
    siralama = ux_list_new()

    CALL SembolEkle(adlar, tipler, siralama, "ph", "F64")
    CALL SembolEkle(adlar, tipler, siralama, "tankNo", "I32")
    CALL SembolEkle(adlar, tipler, siralama, "aciklama", "STRING")
    CALL SembolEkle(adlar, tipler, siralama, "durum", "BOOLEAN")
    CALL SembolEkle(adlar, tipler, siralama, "ph", "STRING")

    PRINT ""
    PRINT "=== Sembol Tablosu ==="
    OPEN "symbol_table.csv" FOR OUTPUT AS #1
    PRINT #1, "ad;tip"
    FOR i = 1 TO ux_list_count(siralama)
        DIM ad AS STRING
        ad = ux_list_get_string(siralama, i)
        PRINT #1, ad + ";" + ux_dict_get_string(tipler, ad)
        PRINT ad; " -> "; SembolSorgula(tipler, ad)
    NEXT i
    CLOSE #1

    PRINT ""
    PRINT "Bilinmeyen sorgu: fiyat -> "; SembolSorgula(tipler, "fiyat")

    CALL ux_list_free(siralama)
    CALL ux_dict_free(tipler)
    CALL ux_set_free(adlar)
    PRINT "Sembol tablosu: symbol_table.csv"
END MAIN
```

**Satır satır açıklama:**

1. `INCLUDE "modules/uxcollections.uxmh"` — Koleksiyon kütüphanesi.
2. `SUB SembolEkle(...)` — Sembol ekleme alt yordamı. Beş parametre alır.
3. `IF ux_set_contains(adlar, ad) THEN` — Bu ad daha önce eklendi mi? `SET` tekrar denetler.
4. `PRINT "TEKRAR: "; ad; " zaten tanimli"` — Tekrar bildirimi uyar.
5. `EXIT SUB` — Eklemeden çık.
6. `CALL ux_set_add(adlar, ad)` — Adı kümeye ekle.
7. `CALL ux_dict_set_string(tipler, ad, tip)` — Tip bilgisini sözlüğe ekle.
8. `CALL ux_list_push_string(siralama, ad)` — Bildirim sırasına ekle.
9. `PRINT "EKLENDI: "; ad; " : "; tip` — Başarı mesajı.
10. `FUNCTION SembolSorgula(...)` — Adı verilen sembolün tipini sorgula.
11. `tip = ux_dict_get_string(tipler, ad)` — Sözlükten tipi al.
12. `IF LEN(tip) = 0 THEN RETURN "TANIMSIZ"` — Boşsa tanımsız.
13. `RETURN tip` — Tipi döndür.
14. `MAIN`'de üç veri yapısı aç: `SET` (tekrar denetimi), `DICT` (ad→tip), `LIST` (sıra).
15. Beş sembol ekle. Beşincisi "ph" tekrarı; `SET` bunu yakalar.
16. `OPEN "symbol_table.csv" FOR OUTPUT AS #1` — Rapor dosyasını aç.
17. `FOR i = 1 TO ux_list_count(siralama)` — Bildirim sırasına göre dolaş.
18. `ad = ux_list_get_string(siralama, i)` — i'inci sembolün adını al.
19. `PRINT #1, ad + ";" + ux_dict_get_string(tipler, ad)` — CSV satırı yaz.
20. `PRINT ad; " -> "; SembolSorgula(tipler, ad)` — Ekrana da yaz.
21. `PRINT "Bilinmeyen sorgu: fiyat -> "; SembolSorgula(tipler, "fiyat")` — Tanımsız sembol sorgula.
22. Üç veri yapısını da serbest bırak.

**Örnek çıktı:**

```
EKLENDI: ph : F64
EKLENDI: tankNo : I32
EKLENDI: aciklama : STRING
EKLENDI: durum : BOOLEAN
TEKRAR: ph zaten tanimli

=== Sembol Tablosu ===
ph -> F64
tankNo -> I32
aciklama -> STRING
durum -> BOOLEAN

Bilinmeyen sorgu: fiyat -> TANIMSIZ
Sembol tablosu: symbol_table.csv
```

> **Ders:** Derleyici zekâsının temelini gösterir. Bir değişkeni yalnız metin olarak görmek yetmez; adı, tipi ve sırası ayrı ayrı tutulur. Aynı adın tekrarını `SET` yakalar. Tip bilgisini `DICT` verir. Bildirim sırasını `LIST` saklar. Üç veri yapısı birlikte derleyicinin kalbini oluşturur.

### 14.6 Proje 6 — Tarayıcı + İstatistik + Yapay Zekâ Birleşik Paneli

Bu proje Bölüm 13.17'deki birleşik örneğin modüllere ayrılmış, hata korumalı ve dosya raporlu hâlidir.

```uxbasic
' akilli_panel.uxb — Birlesik tarayici paneli
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<canvas id="ekran" width="960" height="540"></canvas>
<pre id="rapor"></pre>
%%HTML_END

INCLUDE "modules/uxbrowser.uxmh"
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxai.uxmh"

FUNCTION KaliteRisk(ort AS F64, sd AS F64, hata AS I32) AS STRING
    IF hata > 3 THEN RETURN "YUKSEK"
    IF ABS(ort - 100.0) > 2.0 THEN RETURN "ORTA"
    IF sd > 3.5 THEN RETURN "ORTA"
    RETURN "DUSUK"
END FUNCTION

SUB VeriUret(BYREF v AS PTR, BYREF hata AS I32)
    DIM i AS I32
    DIM deger AS F64
    v = CALL uxstats_vec_create()
    FOR i = 1 TO 30
        deger = 96.0 + RND() * 9.0
        CALL uxstats_vec_push(v, deger)
        IF deger < 96.0 OR deger > 104.0 THEN hata = hata + 1
    NEXT i
END SUB

SUB PanelCiz(ort AS F64, sd AS F64, hata AS I32, risk AS STRING)
    CALL uxbrowser_canvas_init("ekran", 960, 540)
    CALL uxbrowser_canvas_clear("#ffffff")
    CALL uxbrowser_canvas_text(30, 40, "uXBasic Akilli Kalite Paneli")
    CALL uxbrowser_canvas_text(30, 80, "Ortalama=" + STR(ort))
    CALL uxbrowser_canvas_text(30, 110, "StdSapma=" + STR(sd))
    CALL uxbrowser_canvas_text(30, 140, "Hata adedi=" + STR(hata))
    CALL uxbrowser_canvas_text(30, 170, "Risk=" + risk)
END SUB

MAIN
    DIM v AS PTR
    DIM hata AS I32
    DIM ort AS F64
    DIM sd AS F64
    DIM risk AS STRING
    DIM prompt AS STRING
    DIM yorum AS STRING

    RANDOMIZE TIMER()
    CALL VeriUret(v, hata)

    ort = CALL uxstats_vec_mean(v)
    sd = CALL uxstats_vec_stddev(v)
    risk = KaliteRisk(ort, sd, hata)

    CALL PanelCiz(ort, sd, hata, risk)

    prompt = "30 uretim olcumu: ortalama=" + STR(ort)
    prompt = prompt + ", standart sapma=" + STR(sd)
    prompt = prompt + ", limit disi=" + STR(hata)
    prompt = prompt + ", risk=" + risk + ". Kisa teknik yorum ve 3 oneri ver."

    TRY
        CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")
        yorum = CALL uxai_openai_response("OPENAI_MODEL", prompt)
        IF LEN(yorum) = 0 THEN yorum = "Yapay zeka yaniti alinamadi; sayisal rapor gecerlidir."
    CATCH e
        yorum = "Yapay zeka hatasi: " + e
    END TRY

    CALL uxbrowser_dom_set_text("rapor", yorum)

    OPEN "son_kalite_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "Ortalama=" + STR(ort)
    PRINT #1, "StdSapma=" + STR(sd)
    PRINT #1, "LimitDisi=" + STR(hata)
    PRINT #1, "Risk=" + risk
    PRINT #1, yorum
    CLOSE #1

    CALL uxstats_vec_free(v)
END MAIN
```

**Satır satır açıklama:**

1. `%%TARGET BROWSER` — Tarayıcı hedefi.
2. `%%HTML_BEGIN ... %%HTML_END` — HTML kabuğu: canvas + rapor bölgesi.
3. `INCLUDE` ile tarayıcı, istatistik ve yapay zekâ kütüphaneleri.
4. `FUNCTION KaliteRisk(...)` — Risk seviyesi belirleme (Bölüm 13.17 ile aynı).
5. `SUB VeriUret(BYREF v AS PTR, BYREF hata AS I32)` — Veri üretme alt yordamı. Vektör ve hata sayacını `BYREF` ile döndürür.
6. `v = CALL uxstats_vec_create()` — Yeni vektör aç.
7. `FOR i = 1 TO 30` — 30 ölçüm üret.
8. `deger = 96.0 + RND() * 9.0` — 96–105 arası rastgele.
9. `CALL uxstats_vec_push(v, deger)` — Vektöre ekle.
10. `IF deger < 96.0 OR deger > 104.0 THEN hata = hata + 1` — Sınır dışı say.
11. `SUB PanelCiz(...)` — Tarayıcı panelini çizme alt yordamı.
12. `CALL uxbrowser_canvas_init("ekran", 960, 540)` — Tuvali başlat.
13. `CALL uxbrowser_canvas_clear("#ffffff")` — Beyaz zemin.
14. `CALL uxbrowser_canvas_text(...)` — Sonuçları tuvale yaz.
15. `MAIN`'de veri üret, hesapla, paneli çiz.
16. `prompt = ...` — Yapay zekâ için prompt hazırla.
17. `TRY` — Yapay zekâ çağrısı hata verebilir; koru.
18. `CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")` — Anahtarı al.
19. `yorum = CALL uxai_openai_response("OPENAI_MODEL", prompt)` — Yorum al.
20. `IF LEN(yorum) = 0 THEN yorum = ...` — Boş cevaba karşı yedek metin.
21. `CATCH e` — Hata yakala.
22. `yorum = "Yapay zeka hatasi: " + e` — Hata mesajını yoruma koy.
23. `CALL uxbrowser_dom_set_text("rapor", yorum)` — Yorumu HTML'e yaz.
24. Dosyaya rapor yaz.
25. Vektörü serbest bırak.

> **Ders:** Veri önce istatistik vektörüne girer, sonra sayısal değerler hesaplanır, sonra risk fonksiyonu karar verir, sonra tarayıcı paneli güncellenir, sonra yapay zekâ rapor dili üretir, son olarak rapor dosyaya yazılır. Bir programı büyütmenin doğru yolu satır eklemek değil, **sorumluluk ayırmaktır.** Her alt yordam tek iş yapar; ana program orkestrasyon yapar.

### 14.7 Proje 7 — Tampon ile Büyük Veri İşleme

Bu proje büyük bir veriyi tamponla parça parça işler. Bellek sızıntısını önlemek için `TRY/FINALLY` kullanır.

```uxbasic
' tampon_islem.uxb — Buyuk veriyi tamponla isle
CONST TAMBOYUT AS I32 = 512
CONST TOPLAM_KAYIT AS I32 = 1000

FUNCTION Temizle(s AS STRING) AS STRING
    RETURN RTRIM(LTRIM(s))
END FUNCTION

FUNCTION SayiyaCevir(s AS STRING) AS F64
    IF LEN(Temizle(s)) = 0 THEN THROW "bos sayi"
    RETURN VAL(s)
END FUNCTION

MAIN
    DIM tampon AS STRING
    DIM satir AS STRING
    DIM deger AS F64
    DIM adet AS I32
    DIM toplam AS F64
    DIM i AS I32

    SETSTRINGSIZE tampon, TAMBOYUT

    TRY
        OPEN "olcumler.txt" FOR INPUT AS #1
        OPEN "temiz_rapor.csv" FOR OUTPUT AS #2
        PRINT #2, "no;ham;deger;durum"

        DO WHILE EOF(#1) = 0
            INPUT #1, satir
            MEMFILLB SADD(tampon), 0, TAMBOYUT
            POKES SADD(tampon), Temizle(satir)
            TRY
                deger = SayiyaCevir(tampon)
                adet = adet + 1
                toplam = toplam + deger
                PRINT #2, STR(adet) + ";" + satir + ";" + STR(deger) + ";OK"
            CATCH e2
                PRINT #2, STR(adet + 1) + ";" + satir + ";0;HATA"
            END TRY
        LOOP

        IF adet > 0 THEN
            PRINT #2, "ortalama;;;" + STR(toplam / adet)
        END IF
    CATCH e
        PRINT "Dosya isleme hatasi: "; e
    FINALLY
        CLOSE #1
        CLOSE #2
    END TRY

    PRINT "Islenen: "; adet; " kayit"
    PRINT "Toplam: "; toplam
    IF adet > 0 THEN PRINT "Ortalama: "; toplam / adet
END MAIN
```

**Satır satır açıklama:**

1. `CONST TAMBOYUT AS I32 = 512` — Tampon boyutu: 512 bayt.
2. `CONST TOPLAM_KAYIT AS I32 = 1000` — Beklenen kayıt sayısı (bilgi için).
3. `FUNCTION Temizle(s AS STRING) AS STRING` — Metni iki yandan boşluk temizle.
4. `RETURN RTRIM(LTRIM(s))` — Önce sol, sonra sağ boşlukları kırpar.
5. `FUNCTION SayiyaCevir(s AS STRING) AS F64` — Metni sayıya çevir.
6. `IF LEN(Temizle(s)) = 0 THEN THROW "bos sayi"` — Boşsa hata fırlat.
7. `RETURN VAL(s)` — Değeri döndür.
8. `DIM tampon AS STRING` — Tampon metni.
9. `SETSTRINGSIZE tampon, TAMBOYUT` — Tampona 512 bayt yer ayır.
10. `TRY` — Dış hata bölgesi.
11. `OPEN "olcumler.txt" FOR INPUT AS #1` — Giriş dosyası.
12. `OPEN "temiz_rapor.csv" FOR OUTPUT AS #2` — Çıkış dosyası.
13. `PRINT #2, "no;ham;deger;durum"` — CSV başlık.
14. `DO WHILE EOF(#1) = 0` — Dosya sonuna kadar.
15. `INPUT #1, satir` — Satır oku.
16. `MEMFILLB SADD(tampon), 0, TAMBOYUT` — Tamponu sıfırla. Önceki veriyi sil.
17. `POKES SADD(tampon), Temizle(satir))` — Temizlenmiş satırı tampona yaz.
18. `TRY` — İç hata bölgesi. Tek satırın hatası tüm programı durdurmasın.
19. `deger = SayiyaCevir(tampon)` — Tampondan sayıya çevir.
20. `adet = adet + 1` — Başarılı kayıt sayısını artır.
21. `toplam = toplam + deger` — Toplama ekle.
22. `PRINT #2, ...; OK` — Başarılı satır yaz.
23. `CATCH e2` — Tek satır hatası.
24. `PRINT #2, ...; HATA` — Hatalı satırı "HATA" durumuyla yaz.
25. `END TRY` — İç bölge bitimi.
26. `LOOP` — Dış döngüye devam.
27. `IF adet > 0 THEN` — En az bir başarılı kayıt varsa.
28. `PRINT #2, "ortalama;;;" + STR(toplam / adet)` — Ortalamayı yaz.
29. `CATCH e` — Dış hata (dosya açılamaması vb.).
30. `PRINT "Dosya isleme hatasi: "; e` — Hata mesajı.
31. `FINALLY` — Her durumda çalışacak temizlik.
32. `CLOSE #1` — Giriş dosyasını kapat.
33. `CLOSE #2` — Çıkış dosyasını kapat.
34. `END TRY` — Dış bölge bitimi.

> **Ders:** İç içe `TRY` blokları: dış bölge dosya seviyesinde korur, iç bölge tek satır seviyesinde korur. Böylece bir hatalı satır tüm programı durdurmaz; "HATA" olarak işaretlenir ve devam edilir. `FINALLY` her durumda dosyaları kapatır; bellek sızıntısı olmaz.

### 14.8 Proje 8 — Olay Sistemi ile Sensör Ağı

Bu proje birden çok sensörü olay sistemiyle yönetir. Her sensör kendi iş parçacığında çalışır; ölçüm geldiğinde olay tetiklenir.

```uxbasic
' sensoragi.uxb — Olay sistemiyle sensor agi
EVENT PhGeldi
EVENT SicaklikGeldi
EVENT OksijenGeldi

PIPE PhHatti AS F64
PIPE SicaklikHatti AS F64
PIPE OksijenHatti AS F64

DIM alarmSayisi AS I32

SLOT PhIsle ON PhGeldi
    DIM ph AS F64
    INPUT ph
    PRINT "pH="; ph
    IF ph < 6.5 OR ph > 8.5 THEN
        alarmSayisi = alarmSayisi + 1
        OPEN "alarm.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";pH;" + STR(ph)
        CLOSE #1
    END IF
END SLOT

SLOT SicaklikIsle ON SicaklikGeldi
    DIM s AS F64
    INPUT s
    PRINT "Sicaklik="; s
    IF s > 28 THEN
        alarmSayisi = alarmSayisi + 1
        OPEN "alarm.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";SICAKLIK;" + STR(s)
        CLOSE #1
    END IF
END SLOT

SLOT OksijenIsle ON OksijenGeldi
    DIM o AS F64
    INPUT o
    PRINT "Oksijen="; o
    IF o < 5.0 THEN
        alarmSayisi = alarmSayisi + 1
        OPEN "alarm.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";OKSIJEN;" + STR(o)
        CLOSE #1
    END IF
END SLOT

THREAD PhSensor
    DIM i AS I32
    FOR i = 1 TO 10
        TRIGGER PhGeldi, 7.0 + RND() * 1.5
    NEXT i
END THREAD

THREAD SicaklikSensor
    DIM i AS I32
    FOR i = 1 TO 10
        TRIGGER SicaklikGeldi, 22.0 + RND() * 8.0
    NEXT i
END THREAD

THREAD OksijenSensor
    DIM i AS I32
    FOR i = 1 TO 10
        TRIGGER OksijenGeldi, 5.0 + RND() * 3.0
    NEXT i
END THREAD

MAIN
    RANDOMIZE TIMER()
    OPEN "alarm.log" FOR OUTPUT AS #1
    CLOSE #1

    PARALEL SensorAgi
        CALL PhSensor()
        CALL SicaklikSensor()
        CALL OksijenSensor()
    END PARALEL

    PRINT "Toplam alarm="; alarmSayisi
    PRINT "Alarm kaydi: alarm.log"
END MAIN
```

**Satır satır açıklama:**

1. Üç olay bildirimi: `PhGeldi`, `SicaklikGeldi`, `OksijenGeldi`.
2. Üç boru: her sensör için ayrı veri hattı.
3. `DIM alarmSayisi AS I32` — Global alarm sayacı.
4. `SLOT PhIsle ON PhGeldi` — pH olayına yuva bağla.
5. `INPUT ph` — Borudan değeri oku.
6. `IF ph < 6.5 OR ph > 8.5 THEN` — Sınır dışı mı?
7. `alarmSayisi = alarmSayisi + 1` — Alarm say.
8. `OPEN "alarm.log" FOR APPEND AS #1` — Alarm günlüğüne ekle.
9. `PRINT #1, ...` — Zaman, tür, değer yaz.
10. `CLOSE #1` — Dosyayı kapat.
11. Benzer yuvalar sıcaklık ve oksijen için.
12. `THREAD PhSensor` — pH sensörü benzetime iş parçacığı.
13. `FOR i = 1 TO 10` — 10 ölçüm üret.
14. `TRIGGER PhGeldi, 7.0 + RND() * 1.5` — Olayı tetikle, veriyi gönder.
15. Üç sensörün üç iş parçacığı.
16. `PARALEL SensorAgi` — Üç sensörü paralel çalıştır.
17. `PRINT "Toplam alarm="; alarmSayisi` — Toplam alarm sayısını yaz.

> **Ders:** Üç sensör bağımsız çalışır; her biri kendi iş parçacığında. Ölçüm geldiğinde olay tetiklenir; ilgili yuva çalışır. Alarm sayacı tüm yuvalar tarafından ortak kullanılır. Bu, gerçek zamanlı sistemlerin temelidir.

### 14.9 Proje 9 — Sınıf Hiyerarşisi ile Çok Tür Ölçüm

Bu proje `CLASS`, `INTERFACE`, `VIRTUAL/OVERRIDE` ile bir ölçüm hiyerarşisi kurar.

```uxbasic
' olcum_hiyerarsi.uxb — Sinif hiyerarsisi
INTERFACE IOlcum
    METHOD Deger() AS F64
    METHOD Birim() AS STRING
    METHOD GecerliMi() AS BOOLEAN
END INTERFACE

CLASS PhOlcum IMPLEMENTS IOlcum
PRIVATE
    PROPERTY deger_ AS F64
PUBLIC
    CONSTRUCTOR(d AS F64)
        deger_ = d
    END CONSTRUCTOR

    METHOD Deger() AS F64
        RETURN deger_
    END METHOD

    METHOD Birim() AS STRING
        RETURN "pH"
    END METHOD

    METHOD GecerliMi() AS BOOLEAN
        RETURN deger_ >= 0 AND deger_ <= 14
    END METHOD
END CLASS

CLASS SicaklikOlcum IMPLEMENTS IOlcum
PRIVATE
    PROPERTY deger_ AS F64
PUBLIC
    CONSTRUCTOR(d AS F64)
        deger_ = d
    END CONSTRUCTOR

    METHOD Deger() AS F64
        RETURN deger_
    END METHOD

    METHOD Birim() AS STRING
        RETURN "C"
    END METHOD

    METHOD GecerliMi() AS BOOLEAN
        RETURN deger_ >= -50 AND deger_ <= 100
    END METHOD
END CLASS

SUB RaporYaz(o AS IOlcum)
    PRINT "Deger="; o.Deger(); " "; o.Birim()
    IF o.GecerliMi() THEN
        PRINT "  Durum: GECERLI"
    ELSE
        PRINT "  Durum: GECERSIZ"
    END IF
END SUB

MAIN
    DIM ph1 AS PhOlcum
    DIM ph2 AS PhOlcum
    DIM s1 AS SicaklikOlcum
    DIM s2 As SicaklikOlcum

    ph1 = NEW PhOlcum(7.2)
    ph2 = NEW PhOlcum(15.0)
    s1 = NEW SicaklikOlcum(24.5)
    s2 = NEW SicaklikOlcum(120.0)

    CALL RaporYaz(ph1)
    CALL RaporYaz(ph2)
    CALL RaporYaz(s1)
    CALL RaporYaz(s2)

    DELETE ph1
    DELETE ph2
    DELETE s1
    DELETE s2
END MAIN
```

**Satır satır açıklama:**

1. `INTERFACE IOlcum` — Ölçüm arayüzü. Üç yöntem sözleşmesi: `Deger`, `Birim`, `GecerliMi`.
2. `CLASS PhOlcum IMPLEMENTS IOlcum` — pH ölçümü sınıfı, arayüzü uygular.
3. `PRIVATE PROPERTY deger_ AS F64` — Özel alan. Sondaki `_` özel alan geleneğidir.
4. `CONSTRUCTOR(d AS F64)` — Kurucu. Değeri alır.
5. `deger_ = d` — Değeri özel alana koy.
6. `METHOD Deger() AS F64` — Değeri döndür.
7. `METHOD Birim() AS STRING` — Birim "pH".
8. `METHOD GecerliMi() AS BOOLEAN` — pH 0–14 aralığında mı?
9. `CLASS SicaklikOlcum IMPLEMENTS IOlcum` — Sıcaklık ölçümü sınıfı.
10. Benzer yapı, farklı birim ("C") ve aralık (-50..100).
11. `SUB RaporYaz(o AS IOlcum)` — Rapor yazma alt yordamı. Parametre `IOlcum` tipinde; herhangi bir ölçüm sınıfı geçebilir.
12. `PRINT "Deger="; o.Deger(); " "; o.Birim()` — Değer ve birim yaz.
13. `IF o.GecerliMi() THEN` — Geçerlilik denetimi.
14. `MAIN`'de dört ölçüm oluştur: iki pH (biri geçersiz), iki sıcaklık (biri geçersiz).
15. `CALL RaporYaz(ph1)` — Rapor yaz. Arayüz sayesinde sınıf tipi önemli değil.
16. Dört nesneyi de sil.

**Örnek çıktı:**

```
Deger= 7.2 pH
  Durum: GECERLI
Deger= 15 pH
  Durum: GECERSIZ
Deger= 24.5 C
  Durum: GECERLI
Deger= 120 C
  Durum: GECERSIZ
```

> **Ders:** Arayüz (`INTERFACE`) ile "her ölçüm şunları yapabilir" sözleşmesi konur. Farklı sınıflar aynı arayüzü farklı şekilde uygular. `RaporYaz` alt yordamı hangi sınıfın geldiğini bilmez; yalnızca arayüze bakar. Bu, çok biçimliliğin (polymorphism) temelidir.

### 14.10 Öğütler — Kitabın Son Sözü

Bu kitap boyunca uXBasic dilinin tüm yüzeyini gezdik: ön-işleyici, veri tipleri, değişkenler, veri yapıları, işleçler, akış komutları, girdi/çıktı, yordam, modül, nesne, bellek, fonksiyonlar, olay sistemi, hook, wrapper, FFI, DLL, tarayıcı, JS, WASM ve yapay zekâ. Her bölümde önce tablo hâlinde kısa tanım, sonra sınıf başlığı altında kullanım ve örnekler verdik. İleri tekniklerde her satırı tek tek açıkladık.

Genç programcı için beş kuralı tekrar hatırlatalım:

1. **Değişken adını gerçek hayattaki nesneye göre koy.** `phDegeri`, `tankNo`, `hataKodu` — bu adlar üç ay sonra da anlaşılır. `x`, `y`, `tmp` — üç gün sonra sen bile unutursun.

2. **Tipi tahminle değil sınırla seç.** 0..255 ise `U8`, günlük sayı ise `I32`, ölçüm ise `F64`, para ise `BIGD`. Yanlış tip sessiz hata üretir.

3. **Diziye geçtiğinde eksenleri yorumla.** `grup, tank, gün, parametre` yazmadan çok boyutlu dizi kullanma. Beş boyuta çıktıysan her eksenin anlamını yorum olarak yaz.

4. **`DICT` ile tablo kurmayı öğren.** Uzun `IF` zincirinin çoğu sözlükle temizlenir. Karar veriye çevrilirse program büyürken bozulmaz.

5. **Dış dünyayı sarmalayıcıya kapat.** `DECLARE`, `CALL`, `TRY`, `LOG`, `FREE` düzenini tek yerde tut. Ana program dış dünyanın karmaşasını bilmesin.

uXBasic öğrenirken hedefin yalnız komut yazmak olmasın. Hedefin, bir fikri önce metne, sonra komuta, sonra ara gösterime, sonra çalışır çıktıya dönüştürmeyi öğrenmek olsun. Bir dosyayı okuyan, ölçümü kontrol eden, tablo kuran, hata yakalayan, tarayıcıda çalışan ve dış kütüphaneyle konuşan program yazabiliyorsan artık yalnız dil öğrenmiyorsun; **sistem kurmayı öğreniyorsun.**

---

## KAPANIŞ

uXBasic, 30 yıllık bir mirası (UltraBasic/ubasic031) alıp Windows 11 x64 mimarisine taşıyan bir köprü projesidir. Bu kitap, derleyicinin nasıl çalıştığını, metni nasıl anladığını ve işlemciye nasıl talimat verdiğini anlatan nihai teknik otoritedir.

Gabriel Fernandez ve Angelo Rosina'nın ve Adam Dunkels, Chuck Peddle & Bill Mensch, Steve Wozniak, Hans Bezemer (TheBeez), Tomasz "Tebe" Berezowski, Ullrich von Bassewitz, Richard Russell, David Given, Marcin Lewczuk, Jyrki Yli-Nokari, Csaba Fekete, Nicolaas v. d. Wetering, Paul Nicholls, David Simons, Lee Davison, Garry Kitchen, Peter Liepa & Chris Gray, Bob Yannes, Scott Adams, Kent Sullivan, Jim Butterfield, Robert Zimmerman & J. Reimer, Daniel S. Fandrich, Craig Bruce, Jim Lawless, Al Arduengo, Linus Åkerlund, Edward R. Rankin, Volker Sasse, Ron Cain & J. E. Hendrix, Don Harrison, Dennis Ritchie & Ken Thompson ve daha nicelerinin attığı fikirler ve temeller, bugünkü modernizasyonun yakıtıdır. Onların kısıtlı imkanlarla yazdığı ASM rutinleri, bugün uXBasic'in hız çekirdeğini oluşturmaktadır.

uXBasic'in güzel yanı, BASIC rahatlığını korurken seni derleyici geliştiricisi gibi düşünmeye zorlamasıdır. Kütüphane başlığı, çalışma zamanı servisi, dış DLL, JS/WASM host köprüsü, JSON raporu ve test kapısı aynı büyük sistemin parçalarıdır. Bu kitap, bu parçaların nasıl bir araya geldiğini anlattı.

Programcılığa yeni başlayan bir gence son söz: **önce çalışan küçük program yaz, sonra programı büyüt, sonra test et, sonra dış dünyaya aç.** Büyük sistemi tek hamlede kurmaya çalışan kişi çoğu zaman kendi kodunun altında kalır. Küçük başla, sağlam temel at, sonra büyü. uXBasic bu büyüme yolunda sana eşlik eder.

---

**Kitap tamamlandı.** Programlayıcının Cep Kitabı — uXBasic ile Programlamayı Öğrenmek, 14 bölümde uXBasic dilinin tüm yüzeyini, temel kavramlardan ileri tekniklere kadar, tablolar, örnekler ve satır satır anlatımlarla kapsadı. Kitap boyunca öğrenilenler:

- **Bölüm 1–2:** Önsöz, giriş, lisans, dosya uzantıları, mimari katmanlar, ilk programlar
- **Bölüm 3:** Ön-işleyici (`%%TARGET`, `%%DEFINE`, `%%MACRO`, `%%HTML_BEGIN`, `%%WAT_IMPORT`, vb.)
- **Bölüm 4:** Veri tipleri (tam sayı, kayan noktalı, büyük sayı, mantıksal, metin, adres, koleksiyon)
- **Bölüm 5:** Değişkenler ve veri yapıları (`DIM`, `CONST`, `REDIM`, `ARRAY`, `LIST`, `DICT`, `SET`, `TYPE`, çok boyutlu diziler, tampon)
- **Bölüm 6:** İşleçler (aritmetik, karşılaştırma, mantıksal, bit düzeyinde, metin, adres, atama, öncelik, üçlü)
- **Bölüm 7:** Akış ve karar komutları (`IF`, `SELECT`, `FOR`, `DO`, `WHILE`, `EXIT`, `TRY/CATCH/FINALLY/THROW/ASSERT`, vb.)
- **Bölüm 8:** Girdi, çıktı, ekran ve dosya komutları (`PRINT`, `INPUT`, `OPEN`, `CLOSE`, `GET/PUT`, `SEEK`, `CLS/COLOR/LOCATE`)
- **Bölüm 9:** Yordam, modül ve nesne (`SUB`, `FUNCTION`, `DECLARE`, `CALL`, `BYREF/BYVAL`, `TYPE`, `CLASS`, `METHOD`, `CONSTRUCTOR/DESTRUCTOR`, `INTERFACE/IMPLEMENTS`, `VIRTUAL/OVERRIDE`, erişim belirleyiciler, `STATIC`, `MAGIC`, `ENUM`)
- **Bölüm 10:** Bellek ve düşük seviye (`PEEK/POKE` ailesi, `MEMCOPY/MEMFILL`, `INC/DEC`, `VARPTR/SADD`, `SIZEOF/OFFSETOF`, tampon, bit bayrağı)
- **Bölüm 11:** Yerel fonksiyonlar (matematik, metin, tip dönüşümü, I/O, bellek, zaman)
- **Bölüm 12:** Olay, eşzamanlılık, hook, wrapper, FFI, DLL (`EVENT/SLOT/TRIGGER`, `PIPE`, `THREAD/PARALEL`, `ON/OFF`, kanca ve sarmalayıcı desenleri, `IMPORT`, `CALL(DLL,...)`, `CALL(API,...)`)
- **Bölüm 13:** Tarayıcı, JS, WASM, yapay zekâ (`%%TARGET BROWSER/WASM`, `uxbrowser_*`, `uxhttp/uxjson`, `uxllama`, `uxai_openai_*`, `uxai_gemini_*`)
- **Bölüm 14:** Tam projeler — satır satır anlatımla (kalite kontrol, çok modüllü panel, derleyici izleyici, bilimsel deney, sembol tablosu, birleşik panel, tampon işleme, sensör ağı, sınıf hiyerarşisi)

Kitabın amacı, genç programcıya yalnız komut öğretmek değil; bir programcının nasıl düşündüğünü, nasıl tasarladığını ve nasıl büyüttüğünü öğretmektir. uXBasic bu yolculukta hem başlangıç noktası hem de varış noktasıdır.