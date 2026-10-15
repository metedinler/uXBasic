Önce kaynak dosyaları paralel olarak inceleyip her birinden kitap yazımı için gerekli olan komut/fonksiyon/işleç/tip/sözdizimi ve örnek kod bloklarını çıkaracağım. Bu sayede yazdığım her satırı kaynakla doğrulayabilirim.
# Programcının Cep Kitabı — uXBasic Kullanma Kılavuzu

> **Kaynak gerçekliğine göre düzeltilmiş sürüm.** Bu metin, `01_src.txt` içindeki compiler modülleriyle karşılaştırılmıştır. Parserda görülen fakat runtime/backend tarafı tamamlanmamış özellikler açıkça işaretlenmiştir.

---

## BÖLÜM 1: ÖNSÖZ VE GİRİŞ

### 1.1 Önsöz

Bu kılavuz, uXBasic kaynak ağacında gerçekten görülen lexer, parser, AST, semantic, MIR, interpreter, runtime ve backend davranışlarını açıklamak için düzeltilmiştir. Bir özellik yalnızca anahtar sözcük listesinde bulunduğu için “tamamlanmış” sayılmaz; bu kitapta mümkün olduğunca parserdan çalıştırıcıya ve çıktı üreticisine kadar izlenebilen davranışlar anlatılır.

Kaynakta kanıtlanmayan tarihçe, kişi katkısı, lisans veya “nihai teknik otorite” iddiası gerçek bilgi gibi sunulmaz. Projenin hukuki lisansı için depodaki güncel `LICENSE` dosyası; sürüm ve mimari için de kullanılan kaynak paketi esas alınmalıdır.
### 1.2 Teşekkür

Bu kaynak paketinde belirli kişi ve projelere ait eksiksiz bir katkı veya köken kaydı bulunmadığından, önceki metindeki uzun tarihsel atıf listesi doğrulanmış proje bilgisi olarak kullanılamaz. Katkıda bulunanların adları, üçüncü taraf bileşenler ve lisans bildirimleri yalnızca repository geçmişi, `LICENSE`, `NOTICE`, bağımlılık manifestleri ve sürüm kontrol kayıtlarıyla doğrulanmalıdır.
### 1.3 Kitap Kimin İçin?

Bu kitap, 17–25 yaş aralığında, programcılığa yeni başlayan bir insanın uXBasic diliyle programlamayı öğrenebileceği şekilde yazıldı. Temel kavramlar kısa: bir ya da iki cümle ile ve birkaç satır kodla verilir. İleri tekniklerde ise her satır tek tek açıklanır; programın nasıl çalıştığı, sonucun nasıl üretildiği adım adım gösterilir.

Bu kitabı okurken bir kuralı benimse: her örneği önce gözünle tara, sonra kafanda çalıştır, sonra bir satırını değiştirip ne olacağını tahmin et. Programlama, sonunda yaptığın her tahminin bilgisayar tarafından doğrulandığı veya yalanlandığı bir deney alanıdır.

### 1.4 uXBasic Nedir?

uXBasic, BASIC benzeri bir kaynak dili için çok katmanlı bir derleyici ve yorumlama projesidir. İncelenen kaynakta lexer, parser, AST, semantic denetim, MIR üretimi, AST ve MIR interpreter yolları, x64 NASM üretimi ile MIR tabanlı JavaScript, WAT, WASM ve browser çıktıları bulunur.

Kaynakta x86 ile ilgili eski seçenek ve yüzey izleri bulunsa da aktif x86 backend emekliye ayrılmıştır. Bu nedenle güncel yerel hedef **x64** olarak anlatılır. Web hedefleri ise her komutu desteklemez: dosya sistemi, `SHELL`, DLL/API ve bazı native runtime işlemleri JS/WAT/WASM/BROWSER hedeflerinde fail-close ile reddedilebilir.

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

Bu program `MAIN`, `PRINT`, `DIM`, `INPUT` ve `IF` yüzeylerini kullanır. AST interpreter veya MIR interpreter ile çalıştırılabilir; native özellik kullanmadığı sürece x64, JS ve WAT/WASM yolları için de uygun bir başlangıç örneğidir.
### 1.5 Lisans ve Sorumluluk

İncelenen tek kaynak dosyası projenin kesin lisansını kanıtlamaz. Bu nedenle önceki “MIT lisanslıdır” cümlesi kaldırılmıştır. Kodun kullanılabileceği, değiştirilebileceği veya dağıtılabileceği koşullar için projenin güncel `LICENSE` ve üçüncü taraf bildirim dosyaları okunmalıdır.

Derleyici geliştirme aşamasındadır. Özellikle native DLL köprüleri, gerçek thread/paralel backend’i, PIPE backend’i, büyük sayı runtime’ı ve bazı web servisleri tamamlanmış kabul edilmemelidir. Gerçek cihaz, para, sağlık, güvenlik veya üretim hattı içeren uygulamalarda çıktılar bağımsız testlerle doğrulanmalıdır.
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

| Uzantı | Kaynak gerçekliğindeki kullanım |
| --- | --- |
| `.uxb` | Ana uXBasic kaynak dosyası. |
| `.uxbh`, `.uxmh` | Başlık, ortak tanım veya modül metni için kullanılan proje uzantıları. Kaynak içinde `INCLUDE` ile eklenebilir. |
| `.bas` | BASIC/FreeBasic uyumluluk veya test kaynağı. |
| `.c`, `.cpp`, `.asm` | `IMPORT(C, "...")`, `IMPORT(CPP, "...")`, `IMPORT(ASM, "...")` ile build planına eklenebilen dış kaynaklar. |
| `.json` | Token, AST, semantic, MIR, interpreter, doğrulama ve backend raporları. |
| `.js` | MIR tabanlı JavaScript çıktısı. |
| `.wat` | WebAssembly metin çıktısı. |
| `.wasm` | `wat2wasm` aracıyla WAT’tan üretilen ikili çıktı. |
| `.asm` | Aktif native hedef olan x64 için NASM çıktısı. |
| `.obj`, `.exe`, `.dll` | Harici assembler/linker veya runtime build zincirinin ürünleri. |

x86 ile ilgili eski dosya ve CLI izleri aktif hedef olarak değerlendirilmemelidir.
### 2.2 İlk Programı Çalıştırma

En küçük program:

```uxbasic
MAIN
    PRINT "Merhaba dunya"
END MAIN
```

AST interpreter ile:

```powershell
.\bin\uxb.exe run .\merhaba.uxb --interpreter-backend AST --out-root .\build --run-id merhaba_ast
```

MIR interpreter ile:

```powershell
.\bin\uxb.exe run .\merhaba.uxb --interpreter-backend MIR --out-root .\build --run-id merhaba_mir
```

`run` fiili `--execmem` yolunu açar. `--interpreter-backend` değeri `AST`, `MIR` veya `BOTH` olabilir. `BOTH`, iki yürütücüyü de çalıştırıp karşılaştırma raporu üretmek için kullanılır.
### 2.3 Komut Satırı ve Çıktı Sözleşmesi

Kanonik kullanımda uzun seçenekler tercih edilmelidir. Üç harfli fiiller ve aliaslar vardır, fakat kitapta hata ayıklamayı kolaylaştırmak için açık adlar kullanılır.

| Seçenek | Görev |
| --- | --- |
| `--execmem` | Interpreter çalıştırmasını açar. |
| `--interpreter-backend AST|MIR|BOTH` | Çalıştırıcıyı seçer. |
| `--emit-x64-nasm` | x64 NASM üretir. |
| `--x64-mode AST|MIR|BOTH` | x64 kod üretim kaynağını seçer. |
| `--emit-x64-nasm-out yol` | Tek x64 ASM çıktı yolunu verir. |
| `--build-x64` | Desteklenen x64 build zincirini çalıştırır. |
| `--build-x64-out yol` | x64 build klasörünü verir. |
| `--emit-js` / `--js-out yol` | MIR üzerinden JavaScript üretir. |
| `--emit-wat` / `--wat-out yol` | MIR üzerinden WAT üretir. |
| `--emit-wasm` / `--wasm-out yol` | WAT üretir ve `wat2wasm` ile WASM ister. |
| `--wat2wasm yol` | Kullanılacak `wat2wasm.exe` yolunu verir. |
| `--emit-browser` | JS + HTML + manifest browser paketi üretir. |
| `--html-out`, `--manifest-out` | Browser çıktı yollarını verir. |
| `--out-root yol` | Bütün build ürünlerinin kökünü belirler. |
| `--run-id ad` | Aynı kök içinde çalıştırma kimliği oluşturur. |
| `--help`, `--version` | Yardım ve sürüm bilgisi. |

Örnekler:

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend BOTH --out-root .\build --run-id yorumlama_karsilastir

.\bin\uxb.exe .\ornek.uxb --emit-x64-nasm --x64-mode BOTH --out-root .\build --run-id x64_karsilastir

.\bin\uxb.exe .\web.uxb --emit-js --js-out .\build\web\program.js --out-root .\build --run-id js_ornek

.\bin\uxb.exe .\web.uxb --emit-wat --wat-out .\build\web\program.wat --out-root .\build --run-id wat_ornek
```

Varsayılan çıktı sözleşmesi `<out-root>/<run-id>/` altında `json`, `asm`, `obj`, `exe`, `dll` ve `web` klasörlerini ayırır. Kullanıcı ayrıca tek tek `--ast-exec-result-json-out`, `--mir-exec-result-json-out` ve `--interpreter-compare-json-out` yollarını verebilir.
### 2.4 Mimari Katmanlar

| Katman | Kaynakta görülen görev |
| --- | --- |
| Preprocessor | `%%` direktiflerini, makroları, koşullu blokları ve web varlık bildirimlerini işler. |
| Lexer | Anahtar sözcük, sayı, string, işleç ve ayraç tokenlarını üretir. |
| Parser | Statement ve expression yapılarından AST oluşturur. |
| Semantic | Tip, kapsam, enum, layout, slot ve yüzey denetimleri yapar. |
| AST interpreter | AST düğümlerini doğrudan yürütür. |
| MIR lowering | AST’yi hedeflerden daha bağımsız MIR işlemlerine indirir. |
| MIR verifier/interpreter | MIR’i doğrular ve yürütür. |
| x64 backend | AST veya doğrulanmış MIR üzerinden NASM üretir. |
| Web backend | Doğrulanmış MIR üzerinden JS, WAT, WASM ve browser ürünleri üretir. |
| Runtime | Dosya, konsol, bellek, FFI ve dış servis köprülerini sağlar. |
| Gates/raporlar | Yüzey, opcode, çıktı ve backend kapsamını fail-close denetler. |

Web backend’lerinde AST fallback yasaktır. JS/WAT/WASM/BROWSER üretimi doğrulanmış MIR yolunu ister.
### 2.5 Çok Katmanlı İlk Örnek

Aşağıdaki örnek native-only komut kullanmadığı için AST/MIR interpreter, x64 ve web backendlerini karşılaştırmak için uygundur:

```uxbasic
MAIN
    DIM mesaj AS STRING
    DIM n AS I32

    mesaj = "Ayni kaynak, farkli dogrulanmis hedefler"
    n = 2 ** 5

    PRINT mesaj
    PRINT "sonuc="; n
END MAIN
```

AST ve MIR sonuçlarını karşılaştır:

```powershell
.\bin\uxb.exe run .\katman.uxb --interpreter-backend BOTH --out-root .\build --run-id katman_exec
```

x64 AST ve MIR NASM üret:

```powershell
.\bin\uxb.exe .\katman.uxb --emit-x64-nasm --x64-mode BOTH --out-root .\build --run-id katman_x64
```

JS ve WAT üret:

```powershell
.\bin\uxb.exe .\katman.uxb --emit-js --js-out .\build\katman.js --out-root .\build --run-id katman_js
.\bin\uxb.exe .\katman.uxb --emit-wat --wat-out .\build\katman.wat --out-root .\build --run-id katman_wat
```

Aynı kaynağın bütün hedeflerde kabul edilmesi, bütün hedeflerde aynı runtime servislerinin mevcut olduğu anlamına gelmez. `SHELL`, DLL/API ve dosya işlemleri gibi native yüzeyler web hedefinde ayrıca denetlenir.
### 2.6 Bölüm Özeti

uXBasic programı üç şeyi birlikte taşır: kaynak metin, derleme zinciri ve çıktı sözleşmesi. Kaynak metni sen yazarsın; derleme zincirini komut satırı seçenekleriyle yönetirsin; çıktı sözleşmesi rapor dosyalarıyla kanıtlanır. Bu üçlü birlikte düşünüldüğünde "program çalışmadı" cümlesi "hangi katmanda, hangi dosyada, hangi seçenekle" sorusuna dönüşür; bu da çözümün önünü açar.

---

## BÖLÜM 3: ÖN-İŞLEYİCİ (PREPROCESSOR)

### 3.1 Ön-işleyici Nedir?

uXBasic preprocessor komutları `%%` ile başlar. Kaynakta tanım, koşul, makro, tekrar, hedef, manifest, asset, HTML/CSS/JSON/JS/MD, WAT/WASM host bloğu, güvenlik ve raporlama aileleri bulunur. Bir direktifin tanınması, her hedefte tam kod ürettiği anlamına gelmez; bazıları metadata veya fail-close kontrolü olarak çalışır.

### 3.2 Kaynakta Görülen Başlıca Aileler

| Aile | Başlıca direktifler |
| --- | --- |
| Tanım | `%%DEFINE`, `%%UNDEF`, `%%SET`, `%%EVAL`, `%%ALIAS`, `%%MACRO` |
| Koşul | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` |
| Tekrar | `%%FOR`, `%%FOREACH`, `%%ENDFOR`, `%%REPEAT`, `%%ENDREPEAT`, `%%BREAK`, `%%CONTINUE` |
| Hedef/çıktı | `%%TARGET`, `%%OUTDIR`, `%%PROFILE`, `%%MINIFY`, `%%SOURCE_MAP`, `%%EMITNOTE` |
| Manifest | `%%MANIFEST_SET`, `%%MANIFEST_REQUIRE`, `%%REQUIRE_HOST_BINDING` |
| Web blokları | `%%HTML_BEGIN/END`, `%%CSS_BEGIN/END`, `%%JSON_BEGIN/END`, `%%JS_BEGIN/END`, `%%MD_BEGIN/END` |
| Asset | `%%ASSET_ROOT`, `%%ASSET_FILE`, `%%ASSET_IMAGE`, `%%ASSET_AUDIO`, `%%ASSET_COPY`, `%%FINGERPRINT_ASSETS` |
| WAT/WASM | `%%WAT_BEGIN/END`, `%%WAT_FUNC_BEGIN/END`, `%%WAT_IMPORT`, `%%WAT_EXPORT`, `%%WASM_HOST_JS_BEGIN/END` |
| Güvenlik | `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SAFE_PATHS`, `%%SECSTACK`, `%%NOZEROVARS` |
| Bağlama | `%%INJECT_JS`, `%%INJECT_ASM`, `%%LINK_DLL`, `%%LINK_WASM`, `%%NO_MANGLE` |
| Tanı | `%%ASSERT`, `%%ERROR`, `%%WARNING`, `%%INFO`, `%%SECTION`, `%%ENDSECTION` |

### 3.3 Tanım ve Makro

```uxbasic
%%DEFINE SURUM "1.0"
%%SET TOPLAM = 3 + 5
%%ALIAS ESKI_AD AS YENI_AD
%%MACRO KARE(x) ((x) * (x))

MAIN
    DIM a AS I32
    a = KARE(5)
    PRINT "surum="; SURUM
    PRINT "toplam="; TOPLAM
    PRINT "kare="; a
END MAIN
```

Makro parametreleri parantezlenmelidir. Böylece `KARE(1 + 2)` ifadesi yanlış öncelikle genişlemez.

### 3.4 Koşullu Derleme

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
    PRINT "hedef secildi"
END MAIN
```

Aktif native hedef x64’tür. `%%TARGET X86` güncel üretim hedefi olarak kullanılmamalıdır.

### 3.5 Manifest ve Asset Sözdizimi

Önceki kılavuzdaki `AS "kimlik"` biçimi kaynak parserıyla uyuşmuyordu. Asset direktiflerinde güvenli biçim kaynak ve hedef yolunu virgülle vermektir:

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%ASSET_ROOT "assets"

%%MANIFEST_SET app = "SahaRaporu"
%%MANIFEST_SET version = "1.0"

%%ASSET_IMAGE "assets/logo.png", "logo.png"
%%ASSET_AUDIO "assets/uyari.ogg", "uyari.ogg"
%%ASSET_FILE "assets/veri.json", "veri.json"
%%FINGERPRINT_ASSETS ON
```

Buradaki ikinci değer sembolik nesne kimliği değil, hedef/paket yoludur.

### 3.6 HTML ve Kontrollü JavaScript

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%ALLOW_RAW_JS ON

%%HTML_BEGIN "index.html" BODY
<h1 id="baslik">uXBasic Saha Raporu</h1>
<pre id="gunluk"></pre>
%%HTML_END

%%JS_BEGIN
document.getElementById("gunluk").textContent = "hazir";
%%JS_END

MAIN
    PRINT "browser paketi hazir"
END MAIN
```

Ham JavaScript ve ham WAT blokları güvenlik kapılarıyla korunur. Kaynakta `%%ALLOW_RAW_JS` ve `%%ALLOW_RAW_WAT` bu amaçla bulunur.

### 3.7 WAT/WASM Host Bağlantısı

Önceki üç parçalı örnek yerine kaynakta kabul edilen açık içe aktarma biçimi kullanılmalıdır:

```uxbasic
%%TARGET WASM
%%ALLOW_RAW_WAT ON
%%REQUIRE_HOST_BINDING "env", "print_i32"
%%WAT_IMPORT "env", "print_i32", print_i32, "i32->void"
%%WAT_EXPORT "MAIN"

MAIN
    PRINT 42
END MAIN
```

`%%WAT_IMPORT`, modül adı, dış sembol, yerel ad ve imza bilgisini ayırır. WASM üretimi için yalnız WAT backend’i yetmez; ayrıca `wat2wasm` aracı bulunmalıdır.

### 3.8 Tekrarlı Meta Üretim

```uxbasic
%%FOR ad = 1 TO 3
    %%DEFINE OLCUM_{{ad}} {{ad}} * 2
%%ENDFOR

MAIN
    PRINT OLCUM_1
    PRINT OLCUM_2
    PRINT OLCUM_3
END MAIN
```

Bu döngü çalışma zamanında değil, preprocess aşamasında metin üretir.

### 3.9 Tam Tarayıcı Paketi

Aynı örnek konusu kaynak sözdizimine göre düzeltilmiştir:

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%ALLOW_RAW_JS ON
%%ASSET_ROOT "assets"
%%MANIFEST_SET app = "SahaRaporu"
%%MANIFEST_SET version = "1.0"
%%ASSET_IMAGE "assets/logo.png", "logo.png"

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

%%JS_BEGIN
const c = document.getElementById("saha").getContext("2d");
c.fillText("uXBasic JS ciktisi", 20, 30);
document.getElementById("baslik").textContent = "Hazir";
%%JS_END

MAIN
    PRINT "Web ve konsol cikti sozlesmesi hazir"
END MAIN
```

Üretim:

```powershell
.\bin\uxb.exe .\saha.uxb --emit-browser --js-out .\dist\web\program.js --html-out .\dist\web\index.html --manifest-out .\dist\web\manifest.json --out-root .\build --run-id saha_browser
```

### 3.10 Bölüm Özeti

Preprocessor derleme öncesi metni ve paket metadata’sını hazırlar. Hedef seçimi tek başına backend çalıştırmaz; gerçek JS/WAT/WASM/x64 üretimi CLI seçenekleri ve backend kapılarıyla yapılır.
## BÖLÜM 4: VERİ TİPLERİ

### 4.1 Tip Seçimi Neden Önemlidir?

Tip seçimi, programın sessiz kaderidir. Küçük sayı için büyük tip seçersen bellek harcarsın; büyük sayı için küçük tip seçersen taşma yaşarsın. Bilimsel hesapta `F64` çoğu zaman yeterlidir; para, hassas ondalık ve çok basamaklı hesapta `BIGD`; geniş ikili hassasiyet ve matematiksel işlemde `BIGF`; dev tam sayıda `BIGI`/`BIGINT`; aralık veya belirsizlik mantığında `BALL` kullanılır.

uXBasic'te tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yaparsın.

### 4.2 Tam Sayı Ailesi

| Tip | Yaklaşık genişlik | Tipik kullanım |
| --- | ---: | --- |
| `I8`, `U8` | 8 bit | küçük durum, bayt, slot kimliği |
| `I16`, `U16` | 16 bit | sensör ham değeri, küçük sayaç |
| `I32`, `U32` | 32 bit | genel sayaç ve indeks |
| `I64`, `U64` | 64 bit | büyük sayaç ve dosya boyutu |

Parserın kanonik yerleşik tipi `U8`’dir. Önceki tabloda geçen `BYTE`, bazı eski yüzey izlerine rağmen güvenli kanonik tip olarak doğrulanmadığından örneklerde `U8` kullanılır.

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

### 4.4 Büyük Sayı ve Geniş Hassasiyet Yüzeyi

Parser şu adları tanır:

| Kanonik tip | Kabul edilen bazı aliaslar | Durum |
| --- | --- | --- |
| `BIGINT` | `BIGI`, `BIGINTEGER` | Büyük tam sayı yüzeyi |
| `BIGD` | `BIGDECIMAL` | Büyük ondalık yüzeyi |
| `BIGF` | `BIGFLOAT` | Büyük kayan nokta yüzeyi |
| `BALL` | — | Aralık/ball sayı yüzeyi |
| `F80` | `EXTENDED`, `EXT` | Genişletilmiş kayan nokta |
| `F128` | `FLOAT128`, `QUAD` | 128 bit yüzey |

Hassasiyet bildirimi parserda şu biçimde kabul edilir:

```uxbasic
DIM modelSonucu AS BIGF(256)
DIM tartim AS BIGD(80)
DIM buyukTam AS BIGINT
DIM phAraligi AS BALL(128)
```

Ancak mevcut kaynakta arbitrary-precision ve extended floating-point işlemlerinin tamamı yerleşik, bağımsız ve üretim düzeyinde değildir. Bazı yollar external runtime payload/fallback üretir. Bu nedenle aşağıdaki atamalar sözdizimi örneğidir; gerçek hesap doğruluğu kullanılan `extfp` runtime’ıyla test edilmelidir:

```uxbasic
MAIN
    DIM buyukTam AS BIGINT
    DIM tartim AS BIGD(80)
    DIM modelSonucu AS BIGF(256)

    buyukTam = BIGINT("1000000000000000000000000000001")
    tartim = BIGD("12.345678901234")
    modelSonucu = BIGF("3.141592653589793238462643383279")

    PRINT "genis hassasiyet degerleri runtime dogrulamasi ister"
END MAIN
```
### 4.5 Mantıksal, Metin, Adres ve Koleksiyon Tipleri

| Tip | Anlamı |
| --- | --- |
| `BOOLEAN` | Doğru/yanlış değer |
| `STRING` | Metin |
| `OBJECT` | Genel nesne başvurusu |
| `PTR` | Ham adres veya dış handle |
| `ARRAY` | Dizi yüzeyi |
| `LIST` | Süreç içi liste handle’ı |
| `DICT` | Süreç içi anahtar/değer handle’ı |
| `SET` | Süreç içi benzersiz string kümesi |

`STRPTR` bir genel değişken tipi olarak değil, FFI imza belirteci olarak kullanılır. Değişken bildirirken `PTR`; dış çağrı imzasında gerektiğinde `STRPTR` yazılır.

```uxbasic
DIM tamam AS BOOLEAN
DIM ad AS STRING
DIM p AS PTR
DIM sayilar AS LIST
DIM kodlar AS DICT
DIM gorulen AS SET

tamam = TRUE
ad = "laboratuvar"

LISTADD(sayilar, 10)
DICTSET(kodlar, "OK", 1)
SETADD(gorulen, "Tank-1")
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

| Fonksiyon | Görev |
| --- | --- |
| `CINT(x)` | `I32` yönünde dönüşüm |
| `CLNG(x)` | `I64` yönünde dönüşüm |
| `CSNG(x)` | `F32` yönünde dönüşüm |
| `CDBL(x)` | `F64` yönünde dönüşüm |
| `STR(x)` | Metne dönüşüm |
| `VAL(metin)` | Metinden sayıya dönüşüm |

Karekök fonksiyonunun kaynakta kabul edilen adı `SQR`’dir. `SQRT` lexer yüzeyinde görünse bile parser tarafından açıkça reddedilir.

```uxbasic
DIM ham AS STRING
DIM sayi AS F64

ham = "  42.50  "
sayi = VAL(LTRIM(RTRIM(ham)))

PRINT "sayi="; sayi
PRINT "karekok="; SQR(sayi)
```
### 4.9 Bölüm Özeti

Veri tipleri, değişkenin hangi değerleri tutacağını ve bellekte nasıl davranacağını söyler. uXBasic tam sayı, kayan noktalı, büyük sayı, mantıksal, metin, adres ve koleksiyon tiplerini bir arada sunar. Doğru tip seçimi üç şeyi belirler: bellek kullanımı, hesap doğruluğu ve hata mesajı kalitesi. Bir sonraki bölümde bu tipleri değişkenlere bağlayan `DIM`, `CONST`, `REDIM` komutlarını ve dizi/liste/sözlük/küme gibi veri yapılarını inceleyeceğiz.

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

`LIST`, `DICT` ve `SET` parserda yerleşik tiplerdir. `DIM` ile bildirildiklerinde AST interpreter süreç içi bir koleksiyon handle’ı oluşturur. Önceki kılavuzdaki `ux_list_new`, `ux_dict_new`, `ux_set_new` ve `ux_*_free` yordamları bu kaynak paketinde yoktur.

| Yapı | Oluşturma | Temel fonksiyonlar |
| --- | --- | --- |
| `LIST` | `DIM liste AS LIST` | `LISTLEN`, `LISTGET`, `LISTSET`, `LISTADD`, `LISTREMOVE`, `LISTCLEAR` |
| `DICT` | `DIM sozluk AS DICT` | `DICTLEN`, `DICTHAS`, `DICTGET`, `DICTSET`, `DICTCLEAR` |
| `SET` | `DIM kume AS SET` | `SETLEN`, `SETHAS`, `SETADD`, `SETREMOVE`, `SETCLEAR` |

Mevcut AST evaluator’da `LISTGET` ve `DICTGET` sonuçlarının integer dönüşümüne indirgenen yolları vardır. Bu nedenle aşağıdaki temel örnekler sayısal değer kullanır.
### 5.7 Koleksiyonların Pratik Kullanımı

**LIST örneği:**

```uxbasic
MAIN
    DIM phYuzde AS LIST

    LISTADD(phYuzde, 720)
    LISTADD(phYuzde, 740)
    LISTADD(phYuzde, 710)

    PRINT "adet="; LISTLEN(phYuzde)
    PRINT "ilk="; LISTGET(phYuzde, 0)

    LISTSET(phYuzde, 1, 735)
    PRINT "duzeltilen="; LISTGET(phYuzde, 1)
END MAIN
```

**DICT örneği:**

```uxbasic
MAIN
    DIM hataKodu AS DICT

    DICTSET(hataKodu, "OK", 0)
    DICTSET(hataKodu, "WARN", 1)
    DICTSET(hataKodu, "FAIL", 2)

    PRINT "WARN kodu="; DICTGET(hataKodu, "WARN")
    PRINT "FAIL var mi="; DICTHAS(hataKodu, "FAIL")
END MAIN
```

**SET örneği:**

```uxbasic
MAIN
    DIM gorulen AS SET

    SETADD(gorulen, "Tank-1")
    SETADD(gorulen, "Tank-1")
    SETADD(gorulen, "Tank-2")

    PRINT "benzersiz adet="; SETLEN(gorulen)
    PRINT "Tank-2 var mi="; SETHAS(gorulen, "Tank-2")
END MAIN
```

Bu koleksiyonlar AST interpreter’da süreç içi handle olarak çalışır. x64, MIR ve web backend paritesi ayrıca test edilmelidir; yalnız parser kabulü bütün hedeflerde aynı davranışı garanti etmez.
### 5.8 IF Zincirini DICT'e Çevirme — Birlikte Kullanım Örneği

Aynı hata kodu örneği, kaynakta gerçekten bulunan koleksiyon fonksiyonlarıyla yazılmıştır:

```uxbasic
MAIN
    DIM hataSeviye AS DICT
    DIM gorulenTank AS SET
    DIM agirliklar AS LIST
    DIM i AS I32

    DICTSET(hataSeviye, "OK", 0)
    DICTSET(hataSeviye, "E01", 1)
    DICTSET(hataSeviye, "E02", 2)
    DICTSET(hataSeviye, "E03", 3)

    FOR i = 1 TO 20
        DIM tank AS STRING
        DIM kod AS STRING
        DIM agirlik10 AS I32

        tank = "T" + STR(1 + (i MOD 4))
        agirlik10 = 350 + CINT(RND() * 80)

        IF i = 6 THEN
            kod = "E01"
        ELSEIF i = 13 THEN
            kod = "E03"
        ELSE
            kod = "OK"
        END IF

        SETADD(gorulenTank, tank)
        LISTADD(agirliklar, agirlik10)

        IF kod <> "OK" THEN
            PRINT tank; " hata seviyesi="; DICTGET(hataSeviye, kod)
        END IF
    NEXT i

    PRINT "benzersiz tank="; SETLEN(gorulenTank)
    PRINT "olcum adedi="; LISTLEN(agirliklar)
END MAIN
```

Yeni bir hata kodu eklemek için sözlüğe yeni bir `DICTSET` satırı eklenir. Metin açıklaması gerektiğinde ayrı string tablosu, dizi veya host koleksiyon runtime’ı kullanılabilir; mevcut `DICTGET` evaluator yolu sayısal dönüşüme odaklıdır.
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

### 5.10 Tampon, İşaretçi ve Handle

`SETSTRINGSIZE` kaynak parserında iki argümanlı değişken komutu değildir. Kabul edilen biçim tek sayısal ifadedir:

```uxbasic
SETSTRINGSIZE 256
```

Bu komut varsayılan/string metadata ayarıdır; `SETSTRINGSIZE tampon, 256` biçiminde tek bir değişkenin belleğini ayırmaz. x64 kod üretiminde metadata-only olarak ele alınan yollar da vardır.

| Araç | Sözdizimi | Görev |
| --- | --- | --- |
| `SETSTRINGSIZE` | `SETSTRINGSIZE uzunluk` | Varsayılan string boyutu/metadata |
| `VARPTR` | `VARPTR(değişken)` | Değişken adresi |
| `SADD` | `SADD(metin)` | String içeriği adresi |
| `PEEKB/W/D` | `PEEKB(adres)` | 8/16/32 bit okuma |
| `POKEB/W/D` | `POKEB adres, değer` | 8/16/32 bit yazma |
| `MEMFILLB/W/D` | `MEMFILLB hedef, değer, adet` | Bellek doldurma |
| `MEMCOPYB/W/D` | `MEMCOPYB hedef, kaynak, adet` | Bellek kopyalama |

```uxbasic
MAIN
    SETSTRINGSIZE 256

    DIM tampon AS STRING
    DIM adres AS PTR

    tampon = "uXBasic tampon denemesi"
    adres = SADD(tampon)

    PRINT tampon
    PRINT "ilk bayt="; PEEKB(adres)
END MAIN
```

Ham belleğe yazma hedef backend ve runtime belleğine bağlıdır. Yanlış adres programı bozabilir.
### 5.11 Bölüm Özeti

Değişkenler programın bellekte ad verdiği kutulardır; tipler o kutunun biçimini söyler. `DIM` ile değişken açılır, `CONST` ile sabit tanımlanır, `REDIM` ile dizi büyütülür. `ARRAY` sabit boyutlu, `LIST` büyüyen, `DICT` anahtarlı, `SET` tekrarsız koleksiyonlardır. `TYPE` kayıt düzeni için, `PTR` ve handle dış dünya için kullanılır. Unutma: yanlış tip sessiz hata üretir; yanlış dizi boyutu hesapları bozar; her yerde kullanılan çıplak `STRING` zamanla JSON, yol, hata ve raporun birbirine karışmasına yol açar.

---

## BÖLÜM 6: İŞLEÇLER (OPERATORS)

### 6.1 İşleç Nedir?

İşleç, bir veya iki değer arasında bir işlem yapan ve yeni bir değer üreten işarettir. uXBasic'te işleçler beş büyük aileye ayrılır: aritmetik, karşılaştırma, mantıksal, bit düzeyinde ve metin. Ayrıca adres işleçleri, atama işleçleri ve üçlü koşul ifadesi de vardır.

### 6.2 Aritmetik İşleçler

| İşleç | Açıklama |
| --- | --- |
| `+`, `-`, `*`, `/` | Toplama, çıkarma, çarpma, bölme |
| `\` | Tamsayı bölme |
| `%`, `MOD` | Kalan |
| `**` | Üs alma |

Kaynak parserında `^` üs değildir; `XOR` olarak normalize edilir. Üs alma için `**` kullanılır.

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
PRINT "us="; 2 ** 10
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

Kaynak parserı mantıksal sözcük işleçleri yanında sembolik bit işleçlerini de ayırır:

| İşleç | Açıklama |
| --- | --- |
| `&` | Bit düzeyinde AND |
| `|` | Bit düzeyinde OR |
| `^`, `XOR` | Bit düzeyinde XOR |
| `~`, `NOT` | Tersleme |
| `<<`, `SHL` | Sola kaydırma |
| `>>`, `SHR` | Sağa kaydırma |
| `ROL`, `ROR` | Döndürmeli kaydırma |

```uxbasic
DIM bayrak AS U32

bayrak = 0
bayrak = bayrak | 1
bayrak = bayrak | 4

IF (bayrak & 4) <> 0 THEN
    PRINT "ucuncu bit acik"
END IF

PRINT "XOR="; 12 ^ 5
PRINT "kaydir="; 1 SHL 3
```

`AND` ve `OR` ayrıca mantıksal öncelik katmanlarında bulunur. Bit bayrağı örneklerinde niyeti açık etmek için `&` ve `|` kullanmak daha güvenlidir.
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

Expression sözleşmesinde şu bileşik işleçler görülür:

`+=`, `-=`, `*=`, `/=`, `\=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`, `**=`, `=+`, `=-`

Ancak statement atama rotaları ile expression sözleşmesi bütün biçimlerde tam eşleşmez. Kılavuzdaki güvenli temel örnekler `+=`, `-=`, `*=`, `/=`, `\=`, `%=` ile sınırlandırılır. `^=` üs ataması değildir; XOR atamasıdır. Üs için desteklenen expression işleci `**` olsa da `**=` her statement yolunda güvenilir kabul edilmemelidir.

```uxbasic
DIM toplam AS F64
DIM i AS I32

FOR i = 1 TO 100
    toplam += i
NEXT i

PRINT "1..100 toplami="; toplam
```
### 6.9 Adres ve İşaretçi Araçları

`@` parserda unary adres işleci olarak bulunur. Buna ek olarak `VARPTR`, `SADD`, `LPTR` ve `CODEPTR` özel çağrı biçimleridir.

```uxbasic
MAIN
    DIM n AS I32
    DIM adres AS PTR

    n = 42
    adres = VARPTR(n)

    PRINT "adres degeri="; PEEKD(adres)
    POKED adres, 100
    PRINT "yeni n="; n
END MAIN
```

Bu örnek native bellek modeline bağlıdır ve web hedefi için uygun değildir.
### 6.10 İşleç Önceliği

Kaynak parserındaki yaklaşık sıra yüksekten düşüğe şöyledir:

1. Üye/çağrı/postfix: `.`, `()`, `x++`, `x--`
2. Üs: `**` — sağ birleşimli
3. Unary: `++`, `--`, `+`, `-`, `@`, `!`, `~`, `NOT`
4. `*`, `/`, `\`, `%`, `MOD`
5. `+`, `-`
6. `<<`, `>>`, `SHL`, `SHR`, `ROL`, `ROR`
7. `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=`
8. Bit katmanları: `&`, `^`/`XOR`, `|`
9. Mantıksal `AND`, `XOR/XNOR`, `OR` aileleri
10. Pipeline: `|>`
11. Üçlü ifade: `?:`
12. Atama ailesi

```uxbasic
PRINT 2 + 3 * 4
PRINT (2 + 3) * 4
PRINT 2 ** 3 + 1
PRINT 2 ** (3 + 1)
```

Belirsiz ifadelerde parantez kullanılmalıdır.
### 6.11 Üçlü Koşul İfadesi

Kaynakta `TERNARY_EXPR` için gerçek sözdizimi `? :` biçimidir. `IIF(...)` yerleşik fonksiyon olarak doğrulanmamıştır.

```uxbasic
DIM yas AS I32
DIM durum AS STRING

INPUT yas
durum = yas >= 18 ? "yetiskin" : "cocuk"

PRINT durum
```

Karmaşık kararlar için açık `IF ... ELSE ... END IF` daha okunaklıdır.
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

Parserın kabul ettiği açık hedefler şunlardır:

| Sözdizimi | Görev |
| --- | --- |
| `EXIT FOR` | İçinde bulunulan `FOR` döngüsünden çıkar. |
| `EXIT DO` | İçinde bulunulan `DO` döngüsünden çıkar. |
| `EXIT IF` | Parser yüzeyinde kabul edilen IF hedefidir. |
| `EXIT` | Hedefsiz biçim statement sonuyla kabul edilir; davranışı yürütme bağlamına bağlıdır. |

`EXIT SUB`, `EXIT FUNCTION`, `EXIT WHILE` ve `EXIT SELECT` bu parserın açık hedef listesinde yoktur. Yordamdan çıkmak için `RETURN`; fonksiyondan çıkmak için `RETURN değer` kullanılır.

```uxbasic
DIM i AS I32
DIM hedef AS I32

hedef = 37

FOR i = 1 TO 100
    IF i = hedef THEN
        PRINT "bulundu="; i
        EXIT FOR
    END IF
NEXT i
```

```uxbasic
SUB OlcumEkle(BYREF toplam AS F64, BYREF adet AS I32, BYVAL deger AS F64)
    IF deger < 0 THEN RETURN
    toplam = toplam + deger
    adet = adet + 1
END SUB
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

Kaynak parserında iki farklı çağrı sözleşmesi vardır:

| Fonksiyon | Parser sözleşmesi |
| --- | --- |
| `GETKEY()` | Sıfır argüman |
| `INKEY(arg[, arg2])` | Bir veya iki argüman |

Bu nedenle önceki `INKEY()` örnekleri düzeltilmiştir:

```uxbasic
MAIN
    DIM tus AS I32

    PRINT "Bir tusa basin"
    tus = GETKEY()
    PRINT "kod="; tus
END MAIN
```

```uxbasic
MAIN
    DIM durum AS I32

    durum = INKEY(0)
    PRINT "INKEY sonucu="; durum
END MAIN
```

Runtime kataloglarında farklı arity izleri bulunduğundan `INKEY` davranışı hedef backendde ayrıca test edilmelidir. Taşınabilir başlangıç örneği olarak `GETKEY()` daha açıktır.
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
    IF deger < 0 THEN RETURN
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

Kaynak parserındaki sıra şöyledir:

```text
DECLARE SUB ad [CDECL|STDCALL] [LIB "dosya"] [ALIAS "sembol"] (parametreler)
DECLARE FUNCTION ad [CDECL|STDCALL] [LIB "dosya"] [ALIAS "sembol"] (parametreler) AS Tip
```

Örnek:

```uxbasic
DECLARE FUNCTION Beep STDCALL LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

MAIN
    DIM sonuc AS I32
    sonuc = Beep(800, 200)
    PRINT "Beep sonucu="; sonuc
END MAIN
```

C çağrı düzeni:

```uxbasic
DECLARE FUNCTION Cos CDECL LIB "msvcrt.dll" ALIAS "cos" (BYVAL x AS F64) AS F64

MAIN
    PRINT "cos(0)="; Cos(0)
END MAIN
```

Gerçek DLL çağrısı native runtime/FFI desteği gerektirir ve web hedefinde kullanılmaz.
### 9.5 CALL — Yordam ve Dış Çağrı

| Biçim | Kaynakta anlam |
| --- | --- |
| `CALL yordam(argümanlar)` | Tanımlı SUB/FUNCTION/METHOD çağrısı |
| `CALL(yordam[, argümanlar])` | Parantezli yordam çağrı biçimi |
| `CALL(DLL, "kitaplık", "sembol", İMZA[, CDECL|STDCALL], argümanlar...)` | Dinamik FFI |
| `CALL(API, "kitaplık", "sembol", İMZA, argümanlar...)` | DLL/API kısayolu; JSON/HTTP servisi değildir |

FFI imza belirteçleri arasında `VOID`, `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYREF` ve `BYVAL` bulunur.

```uxbasic
MAIN
    DIM sonuc AS I32

    sonuc = CALL(DLL, "kernel32.dll", "Beep", I32, STDCALL, 880, 150)
    PRINT "donus="; sonuc
END MAIN
```

`CALL(API, "json", "parse", ...)` gibi örnekler yanlıştır. JSON veya HTTP, varsa `JSON.PARSE(...)`, `HTTP(...)` gibi runtime servis yüzeyleri üzerinden ele alınır; mevcut kaynakta bunların çoğu host-binding/payload katmanıdır.
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

### 9.8 INLINE — Ham Native Blok

Parser `INLINE başlık ... END INLINE` bloğunu kabul eder ve ham başlık/gövdeyi AST’de saklar:

```uxbasic
INLINE C
int hizli_kare(int a) { return a * a; }
END INLINE
```

Ancak bu bloğun parse edilmesi, C kodunun otomatik olarak derlenip uXBasic fonksiyonu hâline geldiğini kanıtlamaz. Eski `_ASM`, `ASM_SUB` ve `ASM_FUNCTION` biçimleri açıkça reddedilir. Dış C/C++/ASM dosyaları için daha açık build yolu şudur:

```uxbasic
IMPORT(C, "native/hizli_kare.c")
```

Ardından dış sembol `DECLARE ... LIB ... ALIAS ...` veya projenin aktif bind planı üzerinden bağlanmalıdır. `INLINE` örnekleri native hedefe özgüdür.
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

### 9.18 İleri Teknik — Sınıf ile Tank Yönetimi

Aynı tank örneği, kaynakta bulunmayan `ux_dict_*` yordamları çıkarılarak iki nesne üzerinden gösterilmiştir:

```uxbasic
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
    DIM t1 AS Tank
    DIM t2 AS Tank

    t1 = NEW Tank()
    t2 = NEW Tank()

    t1.ad = "T1"
    t1.hacim = 1000
    t1.balikKg = 65
    t1.son.gun = 1
    t1.son.ph = 7.30
    t1.son.oksijen = 6.40

    t2.ad = "T2"
    t2.hacim = 1000
    t2.balikKg = 80
    t2.son.gun = 1
    t2.son.ph = 8.40
    t2.son.oksijen = 5.70

    OPEN "tank_nesne_raporu.csv" FOR OUTPUT AS #1
    PRINT #1, "tank;gun;pH;oksijen;risk"
    PRINT #1, t1.Csv()
    PRINT #1, t2.Csv()
    CLOSE #1

    DELETE t1
    DELETE t2

    PRINT "rapor yazildi"
END MAIN
```

Bu örnek sınıf, kayıt tipi, yöntem ve dosya çıktısı konusunu korur. Nesne koleksiyonlarının `DICTGET` ile güvenli biçimde geri alınması mevcut evaluator’da tam nesne dönüşü olarak doğrulanmadığından sözlük çıkarılmıştır.
### 9.19 İleri Teknik — DLL Sarmalayıcı

Aynı Windows uyarı sesi örneği, parserın gerçek `DECLARE` sırasıyla yazılmıştır:

```uxbasic
DECLARE FUNCTION Beep STDCALL LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

FUNCTION UyariSesi(seviye AS I32) AS I32
    IF seviye <= 0 THEN RETURN 0
    IF seviye = 1 THEN RETURN Beep(800, 120)
    IF seviye = 2 THEN RETURN Beep(1200, 180)
    RETURN Beep(1600, 250)
END FUNCTION

SUB HataBildir(metin AS STRING)
    PRINT "HATA: "; metin
    UyariSesi(2)
END SUB

MAIN
    HataBildir("ph sinir disi")
END MAIN
```

Burada DLL ayrıntısı `UyariSesi` içinde saklanır. Kod yalnız native x64/runtime hedefi içindir; JS/WAT/WASM/BROWSER üretiminde DLL yüzeyi fail-close ile reddedilebilir.
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

```text
MEMCOPYB hedef, kaynak, adet
MEMCOPYW hedef, kaynak, adet
MEMCOPYD hedef, kaynak, adet
```

String değişkenine özel iki argümanlı `SETSTRINGSIZE` yoktur. Sabit uzunluklu hedef metni `SPACE` ile oluşturarak örnek kurulabilir:

```uxbasic
MAIN
    SETSTRINGSIZE 64

    DIM kaynak AS STRING
    DIM hedef AS STRING

    kaynak = "deney satiri"
    hedef = SPACE(64)

    MEMCOPYB SADD(hedef), SADD(kaynak), LEN(kaynak)
    PRINT hedef
END MAIN
```

Bu örnek native bellek davranışına bağlıdır; JS/WAT/WASM hedefi için uygun değildir.
### 10.6 MEMFILL Ailesi — Blok Doldurma

```text
MEMFILLB hedef, değer, adet
MEMFILLW hedef, değer, adet
MEMFILLD hedef, değer, adet
```

```uxbasic
MAIN
    SETSTRINGSIZE 256

    DIM tampon AS STRING
    tampon = SPACE(256)

    MEMFILLB SADD(tampon), 0, 256
    POKES SADD(tampon), "uXBasic"
    PRINT tampon
END MAIN
```

`SETSTRINGSIZE 256` global/default metadata biçimidir. Gerçek ayrılmış string uzunluğu örnekte `SPACE(256)` ile oluşturulur.
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

### 10.10 Tampon Yönetimi

Kaynak parserında:

```uxbasic
SETSTRINGSIZE 512
```

kabul edilir. Şu biçim kabul edilmez:

```text
SETSTRINGSIZE tampon, 512
```

Güvenli örnek:

```uxbasic
MAIN
    SETSTRINGSIZE 512

    DIM tampon AS STRING
    tampon = SPACE(512)

    MEMFILLB SADD(tampon), 0, 512
    POKES SADD(tampon), "ilk veri"

    PRINT tampon
END MAIN
```

Kaynakta `BUFFER_CREATE` adlı doğrulanmış bir dil builtin’i bulunmadığından önceki metindeki bu iddia kaldırılmıştır. Ham buffer gerekiyorsa dış runtime veya açık FFI sözleşmesi kullanılmalıdır.
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

### 10.12 İleri Teknik — Bellek Kopyalama ve Metin İşleme

```uxbasic
MAIN
    SETSTRINGSIZE 64

    DIM kaynak AS STRING
    DIM hedef AS STRING

    kaynak = SPACE(64)
    hedef = SPACE(64)

    POKES SADD(kaynak), "deney satiri 001"
    MEMCOPYB SADD(hedef), SADD(kaynak), 17

    PRINT "kaynak: "; kaynak
    PRINT "hedef : "; hedef

    POKEB SADD(hedef), ASC("D")
    PRINT "degisen: "; hedef
END MAIN
```

1. `SETSTRINGSIZE 64` varsayılan string metadata’sını ayarlar.
2. `SPACE(64)` her iki string için gerçek uzunluk oluşturur.
3. `SADD` string veri adresini verir.
4. `MEMCOPYB` 17 baytı kopyalar.
5. `POKEB` ilk baytı değiştirir.

Bu program yalnız native bellek modeliyle test edilmelidir.
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

| Tehlike | Sonuç | Daha güvenli yaklaşım |
| --- | --- | --- |
| Yanlış adrese yazma | Program çökmesi/veri bozulması | Adresi `VARPTR` veya `SADD` ile gerçek değişkenden al |
| Sınırı aşma | Komşu belleğin bozulması | Gerçek string uzunluğunu `SPACE(n)` ile oluştur ve adetleri denetle |
| Hizalama hatası | Yanlış sonuç veya platform farkı | Emin değilsen `MEMCOPYB`/`MEMFILLB` kullan |
| Tür uyumsuz PEEK/POKE | Değerin yanlış yorumlanması | Boyutu veri tipiyle eşleştir |
| Web hedefinde native bellek | Backend gate hatası | Ham bellek kodunu x64/native modülde tut |

Kaynakta `BUFFER_CREATE`, `BUFFER_SET_F64`, `BUFFER_GET_F64` ve `BUFFER_FREE` adlı doğrulanmış yerleşik fonksiyonlar yoktur. Aynı iki değerlik örnek, gerçek değişken adresleriyle gösterilebilir:

```uxbasic
MAIN
    DIM a AS F64
    DIM b AS F64
    DIM pa AS PTR
    DIM pb AS PTR

    a = 3.14
    b = 2.71

    pa = VARPTR(a)
    pb = VARPTR(b)

    PRINT "a="; a
    PRINT "b="; b
    PRINT "a adresi="; pa
    PRINT "b adresi="; pb
END MAIN
```

Ham F64 okuma/yazma için mevcut PEEK/POKE ailesi yalnız B/W/D boyutlarını açıkça tanımlar. F64 buffer gerekiyorsa doğrulanmış bir runtime DLL fonksiyonu `DECLARE`/FFI ile bağlanmalı veya normal F64 dizisi kullanılmalıdır.
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
| `SQR` | `SQR(sayı)` | F64 | Karekök alır. |
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
PRINT SQR(16)       ' 4 (ayni anlami)
PRINT SQR(2)         ' 1.414
PRINT SQR(0)        ' 0
```

`SQR` ve `SQR` eş anlamlıdır; ikisi de karekök alır.

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
    tus = INKEY(0)
    IF LEN(tus) > 0 THEN
        PRINT "Tus: "; tus; " (kod="; ASC(tus); ")"
    END IF
LOOP UNTIL UCASE(tus) = "Q"
PRINT "Cikildi"
```

`INKEY(0)` tuşa basılmasa bile boş dize döndürür. Bu yüzden `LEN(tus) > 0` denetimi ile basılı tuş olup olmadığına bakılır.

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
PRINT "karekok="; SQR(sayi)
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
7. `PRINT "karekok="; SQR(sayi)` — `karekok= 6.519` yazar.
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

## BÖLÜM 12: İLERİ TEKNİKLER — EVENT, SLOT, PIPE, THREAD, PARALEL, SHELL VE FFI

### 12.1 Mimariyi Doğru Okumak

`EVENT`, `SLOT`, `PIPE`, `THREAD`, `PARALEL`, `ON`, `OFF` ve `TRIGGER` gerçek lexer/parser yüzeyleridir. Semantic slot tablosu, AST interpreter rotaları ve MIR işlemleri de vardır. Ancak mevcut kaynakta isim ile çalışma modeli aynı şey değildir:

- `THREAD` henüz gerçek işletim sistemi thread’i başlatmaz.
- `PARALEL` henüz oneTBB veya başka bir görev planlayıcısında eşzamanlı çalışmaz.
- `PIPE` süreç içi `INPUT`/`OUTPUT` aktarımı yapar; native queue/pipe backend’i tamamlanmış değildir.
- `uxb_runtime.dll` için loader ve ABI adları vardır fakat bridge wrapper’ları çözülen function pointer’larını henüz tam çağırmaz.
- AST ve MIR interpreter görev gövdelerini çoğunlukla senkron çalıştırır.

Mevcut akış:

```text
Kaynak
  → Parser / AST
  → Semantic SLOT tablosu
  → AST interpreter
       veya
    MIR SLOT_DEF / SLOT_BIND / SLOT_ON / SLOT_OFF / TASK_TRIGGER
  → süreç içi senkron görev yürütme
  → hedeflenen fakat tamamlanmamış native runtime DLL köprüsü
```

### 12.2 EVENT

Kanonik blok:

```uxbasic
EVENT SensorChanged
    PRINT "sensor olayi calisti"
END EVENT
```

İsteğe bağlı header/slot değeri:

```uxbasic
EVENT SensorChanged, 0
    PRINT "sensor olayi calisti"
END EVENT
```

Parser, uygun `END EVENT` bulamazsa eski tek satırlı bildirimi de kabul eden bir uyumluluk yolu taşır. Yeni kodda açık blok kullanılmalıdır.

### 12.3 THREAD

```uxbasic
THREAD Worker, 1
    PRINT "worker govdesi"
END THREAD
```

Bu sözdizimi kayıtlı bir görev gövdesi oluşturur. AST ve MIR interpreter’da `TRIGGER THREAD Worker` çağrısı gövdeyi çalıştırır; fakat mevcut uygulama bunu yeni OS thread’inde yürütmez.

### 12.4 PARALEL

Kaynakta doğru yazım `PARALEL`’dir:

```uxbasic
PARALEL Batch, 2
    PRINT "batch govdesi"
END PARALEL
```

`PARALLEL` biçimi kullanılmamalıdır. Bu blok ileride paralel scheduler backend’ine bağlanabilecek yüzeyi temsil eder; şimdiki interpreter davranışı senkrondur.

### 12.5 PIPE

```uxbasic
PIPE Normalize inputText AS STRING, 3
    OUTPUT = UCASE(INPUT)
END PIPE
```

PIPE gövdesinde giriş, süreç içi `INPUT`; sonuç ise `OUTPUT` üzerinden taşınır. Native pipe, kanal, queue veya process pipe garantisi yoktur.

Tetikleme:

```uxbasic
TRIGGER PIPE Normalize, "tank-1"
```

Parser birden fazla payload kabul eder; aşağı katmanların bazıları yalnız ilk payload’ı kullanır. Üretim kodunda şimdilik tek payload tercih edilmelidir.

### 12.6 SLOT Bağlama Tablosu

Kaynakla uyumlu kanonik biçim:

```uxbasic
SLOT
    SensorSlot 0 ON EVENT SensorChanged
    WorkerSlot 1 ON THREAD Worker
    BatchSlot 2 ON PARALEL Batch
    NormalizeSlot 3 ON PIPE Normalize
END SLOT
```

Slot kimliği semantic denetimde `0..255` aralığındadır. Aynı kimlik birden fazla kez kullanılırsa son kayıt baskın olabilir.

Kapasite bildirimi:

```uxbasic
SLOT EVENT 16
SLOT THREAD <U8 8>
SLOT PIPE 8
SLOT PARALEL 4
```

Eski `SLOT Worker ON` biçimi parserda hedef türünü koşulsuz `THREAD` olarak kaydeder. Yeni kodda türü açık SLOT tablosu kullanılmalıdır.

### 12.7 ON ve OFF

```uxbasic
ON EVENT SensorChanged
OFF EVENT SensorChanged

ON THREAD Worker SLOT 1
OFF THREAD Worker SLOT <U8 1>
```

Optional `SLOT` eki AST’ye yazılır. Mevcut lower/evaluator yollarında bu kimlik her yerde aynı biçimde tüketilmediğinden yalnız hedef açma/kapatma davranışına güvenmek, slot-id özel davranışını ayrıca test etmek gerekir.

### 12.8 TRIGGER

```uxbasic
TRIGGER SensorChanged
TRIGGER EVENT SensorChanged
TRIGGER THREAD Worker
TRIGGER PARALEL Batch
TRIGGER PIPE Normalize, "olcum"
```

Türsüz kısa biçim ve açık tür biçimi parserda vardır. Açık tür biçimi okunurluk ve hata ayıklama için daha güvenlidir.

### 12.9 Birlikte Kullanım — Sensör, PIPE, SLOT ve Görevler

Aynı sensör ağı örneği kaynak sözdizimine göre düzeltilmiştir:

```uxbasic
EVENT SensorChanged, 0
    PRINT "sensor olayi alindi"
END EVENT

PIPE Normalize rawText AS STRING, 1
    OUTPUT = UCASE(INPUT)
END PIPE

THREAD Logger, 2
    PRINT "logger gorevi calisti"
END THREAD

PARALEL AlarmGroup, 3
    PRINT "alarm grubu calisti"
END PARALEL

SLOT
    SensorSlot 0 ON EVENT SensorChanged
    NormalizeSlot 1 ON PIPE Normalize
    LoggerSlot 2 ON THREAD Logger
    AlarmSlot 3 ON PARALEL AlarmGroup
END SLOT

MAIN
    ON EVENT SensorChanged
    ON PIPE Normalize
    ON THREAD Logger
    ON PARALEL AlarmGroup

    TRIGGER EVENT SensorChanged
    TRIGGER PIPE Normalize, "ph=7.3"
    TRIGGER THREAD Logger
    TRIGGER PARALEL AlarmGroup

    OFF EVENT SensorChanged
END MAIN
```

Bu program olay/görev yüzeyini test eder. “Thread” ve “paralel” adları nedeniyle gerçek eşzamanlılık beklenmemelidir. AST ve MIR sonuçları `BOTH` modunda karşılaştırılmalıdır:

```powershell
.\bin\uxb.exe run .\sensor_ag.uxb --interpreter-backend BOTH --out-root .\build --run-id sensor_exec
```

### 12.10 SHELL

Gerçek parser sözleşmesi:

```text
SHELL komut
      [TIMEOUT ifade]
      [RUNPATH ifade]
      [OUTPATH ifade]
      [ERRPATH ifade]
      [OUTVAR değişken]
      [ERRVAR değişken]
      [CODEVAR değişken]
```

Tek satırlı güvenli örnek:

```uxbasic
MAIN
    DIM stdoutText AS STRING
    DIM stderrText AS STRING
    DIM exitCode AS I32

    SHELL "python tools/rapor.py" TIMEOUT 60000 RUNPATH "." OUTVAR stdoutText ERRVAR stderrText CODEVAR exitCode

    PRINT "exit="; exitCode
    PRINT stdoutText
    PRINT stderrText
END MAIN
```

`TIMEOUT 60000` gerçek 60 saniyelik process öldürme zaman aşımı değildir. Mevcut yürütücüde negatif değer nowait, sıfır veya pozitif değer beklemeli yolu seçer.

### 12.11 Hook ve İzleme

Compiler CLI’de çalışma izleri için şu seçenekler bulunur:

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend BOTH --hook-trace --session-live-json-out .\build\live.json --layer-timing-json-out .\build\timing.json
```

Bu izler EVENT/SLOT dil özelliğinden farklıdır. Derleyici katmanlarının başlangıç, bitiş, hata ve süre bilgilerini raporlar.

### 12.12 DECLARE ve DLL

```uxbasic
DECLARE FUNCTION Beep STDCALL LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

MAIN
    DIM rc AS I32
    rc = Beep(880, 150)
    PRINT "Beep rc="; rc
END MAIN
```

`DECLARE` dış sembolün adını ve çağrı düzenini önceden bildirir.

### 12.13 CALL(DLL, ...) ve CALL(API, ...)

Dinamik biçim zorunlu bir dönüş/imza belirteci içerir:

```uxbasic
MAIN
    DIM rc AS I32

    rc = CALL(DLL, "kernel32.dll", "Beep", I32, STDCALL, 880, 150)
    PRINT "rc="; rc
END MAIN
```

API kısayolu:

```uxbasic
MAIN
    DIM rc AS I32

    rc = CALL(API, "kernel32", "Beep", I32, 660, 120)
    PRINT "rc="; rc
END MAIN
```

`API` burada Windows/dinamik kütüphane çağrı yüzeyidir. JSON, HTTP veya yapay zekâ servisi değildir.

### 12.14 Runtime Servis Adları

Kaynakta `JSON`, `HTTP`, `CURL`, `FETCH`, `OS`, `LLAMA`, `LUA`, `PROLOG`, `SQLITE`, `CANVAS`, `AUDIO`, `WEBGPU` gibi servis adları görülür. Örneğin:

```uxbasic
DIM jsonCode AS I32
jsonCode = JSON.PARSE("{""ph"":7.3}")
```

Ancak mevcut runtime dispatcher bu servislerin önemli bir kısmında gerçek işi yapmak yerine external payload/event üretir. Dolayısıyla `JSON.PARSE`, `HTTP(...)` veya `LLAMA(...)` parse edilse bile gerçek host uygulaması bağlanmadan üretim servisi kabul edilmemelidir.

### 12.15 Ortak Wrapper Tasarımı

Native DLL ve harici program çağrılarını tek bir modülde toplamak daha güvenlidir:

```uxbasic
FUNCTION UyariSesi(seviye AS I32) AS I32
    DIM hz AS I32

    IF seviye <= 1 THEN
        hz = 800
    ELSEIF seviye = 2 THEN
        hz = 1200
    ELSE
        hz = 1600
    END IF

    RETURN CALL(DLL, "kernel32.dll", "Beep", I32, STDCALL, hz, 150)
END FUNCTION

FUNCTION PythonRaporu(scriptPath AS STRING) AS I32
    DIM rc AS I32
    SHELL "python " + scriptPath TIMEOUT 0 OUTPATH "python_stdout.txt" ERRPATH "python_stderr.txt" CODEVAR rc
    RETURN rc
END FUNCTION

MAIN
    PRINT "dll rc="; UyariSesi(2)
    PRINT "python rc="; PythonRaporu("tools/rapor.py")
END MAIN
```

Bu örnek native x64/runtime içindir. Web backend’i native-only surface gate nedeniyle reddedebilir.

### 12.16 INLINE ve IMPORT

```uxbasic
INLINE C
int hizli_kare(int x) { return x * x; }
END INLINE
```

Bu blok parserda ham metin olarak tutulur. Otomatik compile/link garantisi yoktur. Açık dış kaynak build’i için:

```uxbasic
IMPORT(C, "native/hizli_kare.c")
IMPORT(CPP, "native/model.cpp")
IMPORT(ASM, "native/hizli.asm")
```

`IMPORT`, DLL/API/LIB yükleme komutu değildir; derleme zamanı dış kaynak ekleme yüzeyidir.

### 12.17 Bölüm Özeti

Olay ve görev sistemi sözdizimi ile AST/MIR yüzeyi gerçektir; gerçek native concurrency backend’i henüz tamamlanmamıştır. DLL ve `SHELL` native hedefe aittir. Üretim öncesi AST–MIR karşılaştırması, x64 ASM incelemesi ve runtime DLL bağlama testi zorunludur.
## BÖLÜM 13: İLERİ TEKNİKLER — JS, WAT, WASM, BROWSER VE DIŞ YAPAY ZEKÂ

### 13.1 Web Hedefinin Gerçek Mimarisi

JS, WAT, WASM ve BROWSER üretimi doğrulanmış MIR üzerinden yapılır. CLI, web backend’i istendiğinde AST fallback’i reddeder. Bu nedenle web üretim hattı şöyledir:

```text
Kaynak → Lexer → Parser/AST → Semantic → MIR → MIR doğrulama
       → JS
       → WAT
       → wat2wasm ile WASM
       → JS + HTML + manifest ile browser paketi
```

Native-only yüzeyler web hedeflerinde fail-close ile durdurulabilir. `SHELL`, DLL/API, doğrudan dosya sistemi ve ham native bellek örnekleri browser programına taşınmamalıdır.

### 13.2 Web CLI Komutları

```powershell
# JavaScript
.\bin\uxb.exe .\web.uxb --emit-js --js-out .\build\web\program.js --out-root .\build --run-id web_js

# WAT
.\bin\uxb.exe .\web.uxb --emit-wat --wat-out .\build\web\program.wat --out-root .\build --run-id web_wat

# WASM
.\bin\uxb.exe .\web.uxb --emit-wasm --wat-out .\build\web\program.wat --wasm-out .\build\web\program.wasm --wat2wasm .\tools\wabt\bin\wat2wasm.exe --out-root .\build --run-id web_wasm

# Browser paketi
.\bin\uxb.exe .\web.uxb --emit-browser --js-out .\build\web\program.js --html-out .\build\web\index.html --manifest-out .\build\web\manifest.json --out-root .\build --run-id web_browser
```

`--emit-wat` yalnız metin WAT üretmek için `wat2wasm` istemez. `--emit-wasm` ikili çıktı istediği için dönüştürücü aracın bulunmasını gerektirir.

### 13.3 İlk Web-Uyumlu Program

```uxbasic
MAIN
    DIM ph AS F64
    DIM risk AS STRING

    ph = 7.30
    risk = ph >= 6.5 AND ph <= 8.5 ? "normal" : "uyari"

    PRINT "pH="; ph
    PRINT "durum="; risk
END MAIN
```

Bu program yalnız temel hesap ve `PRINT` kullandığı için AST/MIR, x64 ve web hedeflerini karşılaştırmada uygundur.

### 13.4 Browser Kabuk ve Canvas

Browser kabuğu preprocessor ile hazırlanabilir:

```uxbasic
%%TARGET BROWSER
%%ALLOW_RAW_JS ON
%%MANIFEST_SET app = "TankPaneli"

%%HTML_BEGIN "index.html" BODY
<h1>Tank Izleme</h1>
<canvas id="grafik" width="640" height="240"></canvas>
<pre id="durum"></pre>
%%HTML_END

%%JS_BEGIN
const c = document.getElementById("grafik").getContext("2d");
c.fillText("Tank-1 pH: 7.30", 20, 30);
document.getElementById("durum").textContent = "normal";
%%JS_END

MAIN
    PRINT "Tank paneli MIR/JS yolu icin hazir"
END MAIN
```

Ham JS bloğunun kullanılabilmesi için güvenlik izni açıkça verilir.

### 13.5 Tarayıcıda Canlı Tank İzleme Örneği

Aynı tank izleme konusu, native dosya/DLL çağrısı içermeden hazırlanmıştır:

```uxbasic
%%TARGET BROWSER
%%ALLOW_RAW_JS ON
%%MANIFEST_SET app = "CanliTank"

%%HTML_BEGIN "index.html" BODY
<h1>Canli Tank Izleme</h1>
<div id="tank"></div>
<canvas id="grafik" width="640" height="240"></canvas>
%%HTML_END

%%JS_BEGIN
const veriler = [7.20, 7.30, 7.25, 7.40, 7.35];
const ctx = document.getElementById("grafik").getContext("2d");
ctx.beginPath();
veriler.forEach((v, i) => {
  const x = 30 + i * 100;
  const y = 200 - (v - 6.5) * 100;
  if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
});
ctx.stroke();
document.getElementById("tank").textContent = "Son pH: " + veriler[veriler.length - 1];
%%JS_END

MAIN
    DIM sonPh AS F64
    sonPh = 7.35
    PRINT "son pH="; sonPh
END MAIN
```

### 13.6 WAT/WASM Risk Çekirdeği

WAT import/export metadata’sı:

```uxbasic
%%TARGET WASM
%%ALLOW_RAW_WAT ON
%%REQUIRE_HOST_BINDING "env", "print_i32"
%%WAT_IMPORT "env", "print_i32", print_i32, "i32->void"
%%WAT_EXPORT "RiskPuani"

FUNCTION RiskPuani(ph100 AS I32, oksijen100 AS I32) AS I32
    DIM risk AS I32

    IF ph100 < 650 OR ph100 > 850 THEN risk += 30
    IF oksijen100 < 500 THEN risk += 40

    RETURN risk
END FUNCTION

MAIN
    PRINT RiskPuani(730, 610)
END MAIN
```

WASM host binding’in gerçekten sağlanması browser/host JavaScript sorumluluğudur. `%%WAT_IMPORT` yalnız sözleşmeyi tanımlar.

### 13.7 JSON ve HTTP Yüzeyi

Kaynakta generic runtime servis adları vardır:

```uxbasic
MAIN
    DIM jsonDurum AS I32
    jsonDurum = JSON.PARSE("{""ph"":7.3}")
    PRINT "json runtime sonucu="; jsonDurum
END MAIN
```

Bu örnek yüzey ve dispatch testidir. Mevcut runtime’ın gerçek JSON nesnesi veya HTTP yanıtı üretmesi host implementasyonuna bağlıdır. Üretim REST istemcisi için güvenli yaklaşım, native x64 programından ayrı bir yardımcı EXE/Python programı çağırmak veya gerçek runtime DLL backend’ini tamamlamaktır.

### 13.8 Flask Kalite Servisi İstemcisi

Aynı REST örneği, tamamlanmamış `CALL(API, "http",...)` yerine dış yardımcıyla yazılmıştır:

```uxbasic
MAIN
    DIM rc AS I32

    SHELL "python tools/flask_client.py --ph 7.30 --oxygen 6.10" TIMEOUT 0 OUTPATH "build/flask_stdout.json" ERRPATH "build/flask_stderr.txt" CODEVAR rc

    PRINT "istemci exit="; rc
    PRINT "yanit build/flask_stdout.json dosyasina yazildi"
END MAIN
```

Bu native x64/interpreter örneğidir; browser backend’i için JavaScript `fetch` veya host binding kullanılmalıdır. `TIMEOUT 0` gerçek bir süre aşımı değildir.

### 13.9 Yerel Yapay Zekâ — Llama/Ollama

Kaynakta `LLAMA` runtime servis adı bulunur fakat gerçek model çalıştırma implementasyonu tamamlanmış sayılmaz. Yerel modeli güvenilir biçimde bağlamak için yardımcı program kullanılabilir:

```uxbasic
MAIN
    DIM rc AS I32

    SHELL "python tools/ollama_client.py --model qwen2.5-coder:1.5b --prompt-file rapor.txt" TIMEOUT 0 OUTPATH "build/ollama_cevap.txt" ERRPATH "build/ollama_hata.txt" CODEVAR rc

    PRINT "ollama helper exit="; rc
END MAIN
```

Model adı, endpoint ve veri biçimi yardımcı programda yönetilir. API anahtarı gerekiyorsa kaynak koda yazılmaz.

### 13.10 Llama ile Laboratuvar Yorumu

```uxbasic
MAIN
    DIM ph AS F64
    DIM oksijen AS F64
    DIM rc AS I32

    ph = 7.32
    oksijen = 6.18

    OPEN "build/lab_prompt.txt" FOR OUTPUT AS #1
    PRINT #1, "pH=" + STR(ph) + ", oksijen=" + STR(oksijen)
    PRINT #1, "Bu degerleri su urunleri yetistiriciligi acisindan yorumla."
    CLOSE #1

    SHELL "python tools/ollama_client.py --prompt-file build/lab_prompt.txt" TIMEOUT 0 OUTPATH "build/lab_yorum.txt" ERRPATH "build/lab_yorum.err" CODEVAR rc

    PRINT "yorum exit="; rc
END MAIN
```

Bu örnek dosya ve `SHELL` kullandığı için web hedefinde değil, native x64/AST/MIR runtime testinde kullanılmalıdır.

### 13.11 Bulut Yapay Zekâ — OpenAI

Kaynakta doğrudan, tamamlanmış bir `CHATGPT(...)` builtin’i doğrulanmamıştır. Aynı kalite raporu konusu harici yardımcıyla yürütülür:

```uxbasic
MAIN
    DIM rc AS I32

    SHELL "python tools/openai_report.py --input kalite_raporu.csv" TIMEOUT 0 OUTPATH "build/openai_rapor.txt" ERRPATH "build/openai_hata.txt" CODEVAR rc

    PRINT "OpenAI helper exit="; rc
END MAIN
```

API anahtarı environment variable veya güvenli secrets yöneticisinden alınmalıdır. uXBasic kaynağına anahtar yazılmaz.

### 13.12 Bulut Yapay Zekâ — Gemini

```uxbasic
MAIN
    DIM rc AS I32

    SHELL "python tools/gemini_classify.py --input numuneler.csv" TIMEOUT 0 OUTPATH "build/gemini_sonuc.json" ERRPATH "build/gemini_hata.txt" CODEVAR rc

    PRINT "Gemini helper exit="; rc
END MAIN
```

Bu örnekte de gerçek ağ ve kimlik doğrulama yardımcı uygulamanın sorumluluğundadır.

### 13.13 Birleşik Proje: Browser + İstatistik + Yapay Zekâ

Üretim mimarisi iki parçaya ayrılmalıdır:

```text
uXBasic/MIR → JS/WAT/WASM browser paneli
native x64 uXBasic → dosya/SHELL/runtime helper → yapay zekâ servisi
```

Browser paketi doğrudan native `SHELL` çağırmaz. Native program analiz dosyasını üretir; browser bu dosyayı web sunucusu veya host binding üzerinden okur.

**Native analiz programı:**

```uxbasic
MAIN
    DIM ortalama AS F64
    DIM rc AS I32

    ortalama = (7.20 + 7.30 + 7.40) / 3

    OPEN "build/ozet.txt" FOR OUTPUT AS #1
    PRINT #1, "ortalama pH=" + STR(ortalama)
    CLOSE #1

    SHELL "python tools/ollama_client.py --prompt-file build/ozet.txt" TIMEOUT 0 OUTPATH "build/ai_ozet.txt" ERRPATH "build/ai_ozet.err" CODEVAR rc

    PRINT "analiz exit="; rc
END MAIN
```

**Browser paneli:**

```uxbasic
%%TARGET BROWSER
%%ALLOW_RAW_JS ON

%%HTML_BEGIN "index.html" BODY
<h1>Deney Ozeti</h1>
<pre id="sonuc">sunucudan veri bekleniyor</pre>
%%HTML_END

%%JS_BEGIN
fetch("ai_ozet.txt")
  .then(r => r.text())
  .then(t => document.getElementById("sonuc").textContent = t)
  .catch(e => document.getElementById("sonuc").textContent = String(e));
%%JS_END

MAIN
    PRINT "browser paneli hazir"
END MAIN
```

### 13.14 Bölüm Özeti

Web backend’leri MIR tabanlıdır. WASM ikili üretimi harici `wat2wasm` aracını ister. Runtime servis adları ile gerçek servis implementasyonu birbirinden ayrılmalıdır. Yapay zekâ ve REST örnekleri, mevcut kaynak gerçekliğinde host helper veya tamamlanmış runtime DLL gerektirir.
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

Bu proje aynı çok modüllü fikri korur, fakat kaynakta bulunmayan `ux_list_*`, `uxstats_*` ve `uxbrowser_*` yordamlarını kullanmaz.

**Dosya düzeni:**

```text
app.uxb
include/config.uxbh
modules/analysis.uxb
```

**`include/config.uxbh`:**

```uxbasic
CONST APP_NAME AS STRING = "SahaRaporu"
CONST VERSION AS STRING = "1.0"
CONST ALT_PH AS F64 = 6.5
CONST UST_PH AS F64 = 8.5
```

**`modules/analysis.uxb`:**

```uxbasic
FUNCTION Ortalama5(a AS F64, b AS F64, c AS F64, d AS F64, e AS F64) AS F64
    RETURN (a + b + c + d + e) / 5
END FUNCTION

FUNCTION Risk(ort AS F64) AS STRING
    IF ort < ALT_PH OR ort > UST_PH THEN RETURN "UYARI"
    RETURN "NORMAL"
END FUNCTION
```

**`app.uxb`:**

```uxbasic
%%TARGET BROWSER
%%ALLOW_RAW_JS ON
%%MANIFEST_SET app = "SahaRaporu"

%%HTML_BEGIN "index.html" BODY
<h1 id="baslik">Saha Raporu</h1>
<pre id="rapor"></pre>
%%HTML_END

%%JS_BEGIN
document.getElementById("rapor").textContent =
  "pH verileri: 7.20, 7.30, 7.40, 7.35, 7.25";
%%JS_END

INCLUDE "include/config.uxbh"
INCLUDE "modules/analysis.uxb"

MAIN
    DIM ort AS F64
    DIM durum AS STRING

    ort = Ortalama5(7.20, 7.30, 7.40, 7.35, 7.25)
    durum = Risk(ort)

    PRINT APP_NAME + " v" + VERSION
    PRINT "ortalama="; ort
    PRINT "durum="; durum
END MAIN
```

Üretim:

```powershell
.\bin\uxb.exe .\app.uxb --emit-browser --js-out .\dist\web\program.js --html-out .\dist\web\index.html --manifest-out .\dist\web\manifest.json --out-root .\build --run-id panel
```

Browser programında native dosya okuma veya DLL/SHELL kullanılmaz.
### 14.3 Proje 3 — Derleyici Katman İzleyici

Derleyicinin gerçek katman izini dil içindeki sahte EVENT/SLOT programıyla üretmek yerine compiler’ın kendi trace seçenekleri kullanılmalıdır.

**İzlenecek program:**

```uxbasic
MAIN
    DIM toplam AS I64
    DIM i AS I32

    FOR i = 1 TO 100000
        toplam = toplam + i
    NEXT i

    PRINT toplam
END MAIN
```

**AST ve MIR katmanlarını birlikte çalıştırma:**

```powershell
.\bin\uxb.exe run .\derleyici_iz.uxb --interpreter-backend BOTH --hook-trace --session-live-json-out .\build\trace\session_live.json --layer-timing-json-out .\build\trace\layer_timing.json --out-root .\build --run-id compiler_trace
```

Başlıca ürünler:

```text
build/compiler_trace/json/live/session_live.json
build/compiler_trace/json/live/layer_timing.json
build/compiler_trace/json/execution/ast_exec_result.json
build/compiler_trace/json/execution/mir_exec_result.json
build/compiler_trace/json/execution/interpreter_compare.json
build/compiler_trace/json/runtime/runtime_route_matrix.json
```

Bu proje gerçek compiler hook/trace altyapısını kullanır. EVENT/SLOT sistemi kullanıcı programı içindeki görevler içindir; compiler katman izleme sistemiyle aynı yapı değildir.
### 14.4 Proje 4 — Bilimsel Deney Veri Analizi

Aynı iki yem grubunu karşılaştırma konusu, kaynakta bulunmayan `uxstats_*` modülleri çıkarılarak temel diziler ve matematik fonksiyonlarıyla yazılmıştır.

```uxbasic
CONST N AS I32 = 15

MAIN
    DIM yemA(15) AS F64
    DIM yemB(15) AS F64
    DIM i AS I32

    DIM toplamA AS F64
    DIM toplamB AS F64
    DIM ortA AS F64
    DIM ortB AS F64
    DIM kareA AS F64
    DIM kareB AS F64
    DIM varA AS F64
    DIM varB AS F64
    DIM sdA AS F64
    DIM sdB AS F64
    DIM fark AS F64

    RANDOMIZE 42

    FOR i = 1 TO N
        yemA(i) = 1.20 + RND() * 0.20
        yemB(i) = 1.28 + RND() * 0.35

        toplamA += yemA(i)
        toplamB += yemB(i)
    NEXT i

    ortA = toplamA / N
    ortB = toplamB / N

    FOR i = 1 TO N
        kareA += (yemA(i) - ortA) * (yemA(i) - ortA)
        kareB += (yemB(i) - ortB) * (yemB(i) - ortB)
    NEXT i

    varA = kareA / (N - 1)
    varB = kareB / (N - 1)
    sdA = SQR(varA)
    sdB = SQR(varB)
    fark = ortB - ortA

    OPEN "deney_analizi.csv" FOR OUTPUT AS #1
    PRINT #1, "grup;n;ortalama;varyans;std_sapma"
    PRINT #1, "A;" + STR(N) + ";" + STR(ortA) + ";" + STR(varA) + ";" + STR(sdA)
    PRINT #1, "B;" + STR(N) + ";" + STR(ortB) + ";" + STR(varB) + ";" + STR(sdB)
    PRINT #1, "ortalama_farki;;" + STR(fark)
    CLOSE #1

    PRINT "A ortalama="; ortA; " sd="; sdA
    PRINT "B ortalama="; ortB; " sd="; sdB
    PRINT "fark="; fark
END MAIN
```

Bu program ortalama, örnek varyansı ve standart sapmayı doğrudan hesaplar. Bağımsız örneklem t-testi ve F dağılımı p-değeri kaynakta doğrulanmış builtin olarak bulunmadığından sonuç uydurulmaz. Böyle testler dış R/Python programı veya gerçekten bağlı bir istatistik DLL’iyle yapılmalıdır.
### 14.5 Proje 5 — Sembol Tablosu Uygulaması

Bu proje yerleşik `SET`, `DICT` ve `LIST` fonksiyonlarını kullanır. `DICTGET` mevcut evaluator’da sayısal dönüşüme odaklandığı için tipler kodla temsil edilir.

```uxbasic
SUB SembolEkle(adlar AS SET, tipler AS DICT, siralama AS LIST, ad AS STRING, tipKodu AS I32, sembolId AS I32)
    IF SETHAS(adlar, ad) THEN
        PRINT "TEKRAR: "; ad; " zaten tanimli"
        RETURN
    END IF

    SETADD(adlar, ad)
    DICTSET(tipler, ad, tipKodu)
    LISTADD(siralama, sembolId)

    PRINT "EKLENDI: "; ad; " tipKodu="; tipKodu
END SUB

FUNCTION SembolSorgula(tipler AS DICT, ad AS STRING) AS I32
    IF DICTHAS(tipler, ad) = 0 THEN RETURN -1
    RETURN DICTGET(tipler, ad)
END FUNCTION

MAIN
    DIM adlar AS SET
    DIM tipler AS DICT
    DIM siralama AS LIST
    DIM i AS I32

    SembolEkle(adlar, tipler, siralama, "ph", 1, 100)
    SembolEkle(adlar, tipler, siralama, "tankNo", 2, 101)
    SembolEkle(adlar, tipler, siralama, "aciklama", 3, 102)
    SembolEkle(adlar, tipler, siralama, "durum", 4, 103)
    SembolEkle(adlar, tipler, siralama, "ph", 3, 104)

    OPEN "symbol_table.csv" FOR OUTPUT AS #1
    PRINT #1, "ad;tip_kodu"
    PRINT #1, "ph;" + STR(SembolSorgula(tipler, "ph"))
    PRINT #1, "tankNo;" + STR(SembolSorgula(tipler, "tankNo"))
    PRINT #1, "aciklama;" + STR(SembolSorgula(tipler, "aciklama"))
    PRINT #1, "durum;" + STR(SembolSorgula(tipler, "durum"))
    CLOSE #1

    PRINT "bildirim sirasi adedi="; LISTLEN(siralama)
    FOR i = 0 TO LISTLEN(siralama) - 1
        PRINT "sembol id="; LISTGET(siralama, i)
    NEXT i

    PRINT "bilinmeyen fiyat="; SembolSorgula(tipler, "fiyat")
END MAIN
```

Tip kodu tablosu örneğin `1=F64`, `2=I32`, `3=STRING`, `4=BOOLEAN` olarak yorumlanabilir.
### 14.6 Proje 6 — Tarayıcı + İstatistik + Yapay Zekâ Birleşik Paneli

Bu proje iki ayrı hedefe bölünür. Native analiz ve yapay zekâ helper’ı x64/runtime tarafında; gösterim ise MIR/JS browser tarafında çalışır.

**Native analiz (`analiz.uxb`):**

```uxbasic
FUNCTION Ortalama5(a AS F64, b AS F64, c AS F64, d AS F64, e AS F64) AS F64
    RETURN (a + b + c + d + e) / 5
END FUNCTION

MAIN
    DIM ort AS F64
    DIM risk AS STRING
    DIM rc AS I32

    ort = Ortalama5(98.2, 101.0, 99.3, 104.2, 97.8)
    risk = ABS(ort - 100.0) > 2.0 ? "ORTA" : "DUSUK"

    OPEN "build/panel_ozet.txt" FOR OUTPUT AS #1
    PRINT #1, "ortalama=" + STR(ort)
    PRINT #1, "risk=" + risk
    CLOSE #1

    SHELL "python tools/ollama_client.py --prompt-file build/panel_ozet.txt" TIMEOUT 0 OUTPATH "build/panel_ai.txt" ERRPATH "build/panel_ai.err" CODEVAR rc

    PRINT "helper exit="; rc
END MAIN
```

**Browser paneli (`panel.uxb`):**

```uxbasic
%%TARGET BROWSER
%%ALLOW_RAW_JS ON

%%HTML_BEGIN "index.html" BODY
<h1>Akilli Kalite Paneli</h1>
<pre id="rapor">veri bekleniyor</pre>
%%HTML_END

%%JS_BEGIN
Promise.all([
  fetch("panel_ozet.txt").then(r => r.text()),
  fetch("panel_ai.txt").then(r => r.text())
]).then(([ozet, ai]) => {
  document.getElementById("rapor").textContent = ozet + "\n\nAI:\n" + ai;
}).catch(e => {
  document.getElementById("rapor").textContent = String(e);
});
%%JS_END

MAIN
    PRINT "browser paneli hazir"
END MAIN
```

Bu ayrım native-only `SHELL` komutunun web backend’ine sızmasını önler.
### 14.7 Proje 7 — Tampon ile Büyük Veri İşleme

Aynı dosya temizleme örneği, gerçek `SETSTRINGSIZE` sözleşmesine göre düzeltilmiştir:

```uxbasic
CONST TAMBOYUT AS I32 = 512

FUNCTION Temizle(s AS STRING) AS STRING
    RETURN RTRIM(LTRIM(s))
END FUNCTION

FUNCTION SayiyaCevir(s AS STRING) AS F64
    IF LEN(Temizle(s)) = 0 THEN THROW "bos sayi"
    RETURN VAL(s)
END FUNCTION

MAIN
    SETSTRINGSIZE TAMBOYUT

    DIM tampon AS STRING
    DIM satir AS STRING
    DIM deger AS F64
    DIM adet AS I32
    DIM toplam AS F64

    tampon = SPACE(TAMBOYUT)

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

        IF adet > 0 THEN PRINT #2, "ortalama;;;" + STR(toplam / adet)
    CATCH e
        PRINT "Dosya isleme hatasi: "; e
    FINALLY
        CLOSE #1
        CLOSE #2
    END TRY

    PRINT "islenen="; adet
    IF adet > 0 THEN PRINT "ortalama="; toplam / adet
END MAIN
```

`SPACE(TAMBOYUT)` gerçek string uzunluğunu oluşturur; `SETSTRINGSIZE TAMBOYUT` global/default metadata ayarıdır.
### 14.8 Proje 8 — Olay Sistemi ile Sensör Ağı

Aynı sensör ağı, kanonik PIPE ve SLOT tablosuyla yazılmıştır. PIPE payload’ı `INPUT` üzerinden taşınır.

```uxbasic
DIM alarmSayisi AS I32

PIPE PhIsle ph AS F64, 0
    PRINT "pH="; INPUT
    IF INPUT < 6.5 OR INPUT > 8.5 THEN
        alarmSayisi += 1
    END IF
    OUTPUT = INPUT
END PIPE

PIPE SicaklikIsle sicaklik AS F64, 1
    PRINT "sicaklik="; INPUT
    IF INPUT > 28 THEN
        alarmSayisi += 1
    END IF
    OUTPUT = INPUT
END PIPE

PIPE OksijenIsle oksijen AS F64, 2
    PRINT "oksijen="; INPUT
    IF INPUT < 5.0 THEN
        alarmSayisi += 1
    END IF
    OUTPUT = INPUT
END PIPE

THREAD PhSensor, 3
    DIM i AS I32
    FOR i = 1 TO 10
        TRIGGER PIPE PhIsle, 7.0 + RND() * 1.5
    NEXT i
END THREAD

THREAD SicaklikSensor, 4
    DIM i AS I32
    FOR i = 1 TO 10
        TRIGGER PIPE SicaklikIsle, 22.0 + RND() * 8.0
    NEXT i
END THREAD

THREAD OksijenSensor, 5
    DIM i AS I32
    FOR i = 1 TO 10
        TRIGGER PIPE OksijenIsle, 5.0 + RND() * 3.0
    NEXT i
END THREAD

PARALEL SensorAgi, 6
    TRIGGER THREAD PhSensor
    TRIGGER THREAD SicaklikSensor
    TRIGGER THREAD OksijenSensor
END PARALEL

SLOT
    PhPipe 0 ON PIPE PhIsle
    SicaklikPipe 1 ON PIPE SicaklikIsle
    OksijenPipe 2 ON PIPE OksijenIsle
    PhTask 3 ON THREAD PhSensor
    SicaklikTask 4 ON THREAD SicaklikSensor
    OksijenTask 5 ON THREAD OksijenSensor
    AgTask 6 ON PARALEL SensorAgi
END SLOT

MAIN
    RANDOMIZE TIMER()

    TRIGGER PARALEL SensorAgi

    PRINT "toplam alarm="; alarmSayisi
END MAIN
```

Bu proje sözdizimi ve süreç içi görev hattını gösterir. `THREAD` ve `PARALEL` gövdeleri mevcut AST/MIR interpreter’da senkron çalışır; gerçek paralel sensör okuması için native runtime backend’i tamamlanmalıdır.
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

Bu kılavuzun düzeltilmiş hâlinde ana kural şudur: **isim veya parser kaydı, tamamlanmış çalışma davranışı değildir.**

- Temel programlama: `DIM`, `CONST`, `IF`, `SELECT`, `FOR`, `DO`, `FUNCTION`, `SUB`, dosya ve bellek yüzeyleri.
- Koleksiyonlar: kaynakta bulunan `LISTADD/LISTGET`, `DICTSET/DICTGET`, `SETADD/SETHAS` ailesi.
- Native bağlantı: `DECLARE`, `CALL(DLL,...)`, `CALL(API,...)`, `SHELL`, `IMPORT`.
- Olay/görev: `EVENT`, `PIPE`, `THREAD`, `PARALEL`, `SLOT`, `ON`, `OFF`, `TRIGGER`; fakat gerçek concurrency backend’i henüz tamamlanmamıştır.
- Web: doğrulanmış MIR üzerinden `--emit-js`, `--emit-wat`, `--emit-wasm`, `--emit-browser`.
- Yapay zekâ ve ağ: gerçek host helper veya tamamlanmış runtime DLL gerekir; yalnız servis adının parse edilmesine güvenilmez.
- Doğrulama: AST ve MIR interpreter sonuçları, x64 AST/MIR ASM çıktıları ve web backend raporları birlikte incelenir.

Bir özellik için şu soruları sırayla sor:

1. Lexer tanıyor mu?
2. Parser AST düğümü üretiyor mu?
3. Semantic doğruluyor mu?
4. AST interpreter gerçekten sonuç üretiyor mu?
5. MIR lowering ve verifier aynı davranışı taşıyor mu?
6. x64 veya web backend’i gerçek çıktı üretiyor mu?
7. Runtime çağrısı stub mı, host binding mi, gerçek implementasyon mu?
8. Test sonucu ve rapor dosyası var mı?

Bu sekiz soruya cevap verilmeden özellik “tamamlandı” kabul edilmemelidir.
## BÖLÜM 15: DERLEYİCİYİ ÇALIŞTIRMA, SONUÇLARI KARŞILAŞTIRMA VE ÇIKTI ÜRETME

### 15.1 Ortak Test Programı

Aşağıdaki program bütün temel yollar için kullanılabilir:

```uxbasic
FUNCTION Kare(x AS I32) AS I32
    RETURN x ** 2
END FUNCTION

MAIN
    DIM i AS I32
    DIM toplam AS I32

    FOR i = 1 TO 5
        toplam += Kare(i)
    NEXT i

    PRINT "toplam="; toplam
END MAIN
```

Beklenen program çıktısı:

```text
toplam=55
```

Bu örnek native-only servis kullanmaz; AST interpreter, MIR interpreter, x64, JS ve WAT/WASM yollarında karşılaştırmaya uygundur.

### 15.2 AST Interpreter Sonucu

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend AST --out-root .\build --run-id ast_run
```

Başlıca çıktılar:

```text
build/ast_run/json/execution/ast_exec_result.json
build/ast_run/json/execution/ast_stdout.txt
build/ast_run/json/execution/ast_stderr.txt
build/ast_run/json/execution/ast_program_output.txt
build/ast_run/json/live/ast_interpreter_live.json
build/ast_run/json/execution/runtime_trace.json
```

`ast_exec_result.json` içinde backend adı, durum, stdout, stderr, program çıktısı, sonuç tipi ve hata alanları bulunur. Başarı için `status` alanı `PASS` olmalıdır.

### 15.3 MIR Interpreter Sonucu

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend MIR --out-root .\build --run-id mir_run
```

Başlıca çıktılar:

```text
build/mir_run/json/execution/mir_exec_result.json
build/mir_run/json/execution/mir_stdout.txt
build/mir_run/json/execution/mir_stderr.txt
build/mir_run/json/execution/mir_program_output.txt
build/mir_run/json/live/mir_interpreter_live.json
build/mir_run/json/execution/runtime_trace.json
```

MIR yolu semantic ve MIR doğrulama kapılarından geçer. MIR üretilemez veya verifier başarısız olursa interpreter başlamadan fail-close olur.

### 15.4 AST ve MIR Karşılaştırması

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend BOTH --out-root .\build --run-id both_run
```

Ek çıktı:

```text
build/both_run/json/execution/interpreter_compare.json
```

Bu rapor AST ve MIR durumlarını, stdout metinlerini, sonuç türlerini ve dönüş değerlerini karşılaştırır. `BOTH` modu iki yolun da başarılı olmasını ister. Çıktı farklıysa rapor farkı görünür hâle getirir.

İstenirse yollar açıkça verilebilir:

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend BOTH `
  --ast-exec-result-json-out .\reports\ast.json `
  --mir-exec-result-json-out .\reports\mir.json `
  --interpreter-compare-json-out .\reports\compare.json
```

### 15.5 x64 NASM — AST Kaynağı

```powershell
.\bin\uxb.exe .\ornek.uxb --emit-x64-nasm --x64-mode AST --emit-x64-nasm-out .\build\ornek_ast.asm --out-root .\build --run-id x64_ast
```

Beklenen ürünler:

```text
build/ornek_ast.asm
build/x64_ast/json/backend/x64_ast/report.json
```

AST backend’i doğrudan AST’den NASM üretir.

### 15.6 x64 NASM — MIR Kaynağı

```powershell
.\bin\uxb.exe .\ornek.uxb --emit-x64-nasm --x64-mode MIR --emit-x64-nasm-out .\build\ornek_mir.asm --out-root .\build --run-id x64_mir
```

Beklenen ürünler:

```text
build/ornek_mir.asm
build/x64_mir/json/backend/x64_mir/report.json
```

Bu yol doğrulanmış MIR’i `MIRX64EmitModule` üzerinden NASM’e indirir.

### 15.7 x64 AST ve MIR Birlikte

```powershell
.\bin\uxb.exe .\ornek.uxb --emit-x64-nasm --x64-mode BOTH --out-root .\build --run-id x64_both
```

Çıktılar:

```text
build/x64_both/asm/x64_ast/output.asm
build/x64_both/asm/x64_mir/output.asm
build/x64_both/json/backend/x64_ast/report.json
build/x64_both/json/backend/x64_mir/report.json
build/x64_both/json/backend/x64_compare/report.json
```

Karşılaştırma raporu iki ASM dosyasının bire bir aynı olup olmadığını bildirir. Fark olması her zaman yanlış sonuç anlamına gelmez; fakat backend parity incelemesi gerektirir.

### 15.8 x64 EXE Üretimi

AST build yolu:

```powershell
.\bin\uxb.exe .\ornek.uxb --build-x64 --x64-mode AST --build-x64-out .\build\ornek_exe --out-root .\build --run-id exe_ast
```

Başarı hâlinde:

```text
build/ornek_exe/program.asm
build/ornek_exe/obj/program.obj
build/ornek_exe/program.exe
build/ornek_exe/build_program.bat
build/ornek_exe/program_link_args.rsp
build/exe_ast/json/backend/x64/exe_artifact_manifest.json
```

MIR build hakkında önemli sınır:

```powershell
.\bin\uxb.exe .\ornek.uxb --build-x64 --x64-mode MIR --out-root .\build --run-id exe_mir
```

Mevcut kaynak bu durumda MIR ASM üretir fakat dış build scriptinin AST yönelimli olduğunu bildirir:

```text
MIR_BUILD_EXTERNAL_SCRIPT_REQUIRED
```

Dolayısıyla MIR NASM dosyasının NASM ve linker ile kullanıcı tarafından ayrıca derlenmesi gerekir. Compiler bu rotada hazır `program.exe` ürettiğini iddia etmez.

Örnek harici zincir:

```powershell
nasm -f win64 .\build\exe_mir\asm\x64_mir\output.asm -o .\build\exe_mir\obj\program.obj
fbc .\build\exe_mir\obj\program.obj -x .\build\exe_mir\exe\program.exe
```

Gerçek linker parametreleri programın runtime sembollerine göre değişebilir; üretilen manifest ve response dosyaları kontrol edilmelidir.

### 15.9 JavaScript Üretimi

```powershell
.\bin\uxb.exe .\ornek.uxb --emit-js --js-out .\build\web\ornek.js --out-root .\build --run-id js_run
```

Başlıca çıktılar:

```text
build/web/ornek.js
build/js_run/web/js/uxb_runtime.js
build/js_run/json/backend/js/report.json
build/js_run/json/backend/backend_matrix.json
```

JS backend doğrulanmış MIR ister. Native-only surface tespit edilirse çıktı üretimi durdurulur.

### 15.10 WAT Üretimi

```powershell
.\bin\uxb.exe .\ornek.uxb --emit-wat --wat-out .\build\web\ornek.wat --out-root .\build --run-id wat_run
```

Başlıca çıktılar:

```text
build/web/ornek.wat
build/wat_run/json/backend/wasm/report.json
```

WAT metin çıktısı için `wat2wasm` zorunlu değildir.

### 15.11 WASM Üretimi

```powershell
.\bin\uxb.exe .\ornek.uxb --emit-wasm --wat-out .\build\web\ornek.wat --wasm-out .\build\web\ornek.wasm --wat2wasm .\tools\wabt\bin\wat2wasm.exe --out-root .\build --run-id wasm_run
```

Başlıca çıktılar:

```text
build/web/ornek.wat
build/web/ornek.wasm
build/wasm_run/json/backend/wasm/report.json
```

`wat2wasm.exe` bulunamaz veya WAT geçersiz olursa ikili WASM üretimi başarısız olur.

### 15.12 Browser Paketi

```powershell
.\bin\uxb.exe .\web.uxb --emit-browser `
  --js-out .\build\browser\program.js `
  --html-out .\build\browser\index.html `
  --manifest-out .\build\browser\manifest.json `
  --out-root .\build `
  --run-id browser_run
```

Başlıca ürünler:

```text
build/browser/program.js
build/browser/index.html
build/browser/manifest.json
build/browser_run/json/backend/js/report.json
build/browser_run/json/backend/wasm/report.json
build/browser_run/json/backend/backend_matrix.json
```

Browser rotası kaynak direktiflerine göre JS, HTML, manifest ve gerekirse WAT/WASM ürünlerini bir araya getirir.

### 15.13 Tek Komutla Kanıt Paketi

Bir programın interpreter, x64 ve web yolları ayrı çalıştırmalarda kanıtlanmalıdır:

```powershell
.\bin\uxb.exe run .\ornek.uxb --interpreter-backend BOTH --out-root .\build --run-id proof_exec

.\bin\uxb.exe .\ornek.uxb --emit-x64-nasm --x64-mode BOTH --out-root .\build --run-id proof_x64

.\bin\uxb.exe .\ornek.uxb --emit-js --emit-wat --js-out .\build\proof\program.js --wat-out .\build\proof\program.wat --out-root .\build --run-id proof_web
```

Kontrol sırası:

1. `interpreter_compare.json` — AST ve MIR program sonucu aynı mı?
2. `x64_compare/report.json` — AST ve MIR ASM rotaları ne kadar uyumlu?
3. `backend_matrix.json` — Hangi backend gerçekten üretildi?
4. JS/WAT dosyaları boş mu, raporları PASS mi?
5. Native-only yüzey web gate’inde doğru biçimde reddediliyor mu?
6. EXE çalıştırıldığında interpreter ile aynı stdout elde ediliyor mu?

### 15.14 Sonuçların Yorumlanması

Bir dosyanın oluşması tek başına başarı değildir. Aşağıdaki kanıtların birlikte bulunması gerekir:

| Kanıt | Beklenti |
| --- | --- |
| Parser/semantic raporu | Hata sayısı sıfır veya açıklanmış |
| MIR verifier | PASS |
| AST interpreter | PASS ve beklenen stdout |
| MIR interpreter | PASS ve AST ile uyumlu stdout |
| x64 raporu | ASM üretildi, zorunlu opcode gate geçti |
| JS/WAT/WASM raporu | MIR tabanlı backend PASS |
| Runtime route matrix | Kullanılan servis için gerçek rota |
| EXE manifesti | ASM, OBJ, EXE ve build script yolları doğru |
| Çalıştırma testi | Program sonucu interpreter sonucu ile uyumlu |

Bu yaklaşım derleyicinin “dosya üretti” seviyesinden “aynı programı farklı katmanlarda tutarlı çalıştırdı” seviyesine geçmesini sağlar.

---

## KAPANIŞ

Bu sürümde kılavuz, verilen compiler kaynağına göre düzeltilmiştir. Özellikle şu ayrımlar korunmuştur:

- Aktif native hedef x64’tür; x86 emekliye ayrılmıştır.
- `**` üs, `^` XOR işlemidir.
- Karekök `SQR` ile yazılır.
- Üçlü ifade `koşul ? doğru : yanlış` biçimindedir.
- Koleksiyonlar `LISTADD`, `DICTSET`, `SETADD` ailesiyle kullanılır.
- `SETSTRINGSIZE` tek argümanlı global/default metadata komutudur.
- FFI çağrılarında dönüş/imza belirteci zorunludur.
- EVENT/PIPE/THREAD/PARALEL/SLOT yüzeyi vardır; gerçek concurrency runtime’ı tamamlanmış değildir.
- JS/WAT/WASM/BROWSER üretimi doğrulanmış MIR ister.
- Yapay zekâ ve HTTP servisleri gerçek host helper veya tamamlanmış runtime backend’i gerektirir.
- Bir özelliğin doğruluğu AST, MIR, x64 ve gerekiyorsa web çıktıları birlikte incelenerek değerlendirilir.

Kılavuzdaki komutların gelecekte değişmesi mümkündür. Yeni kaynak sürümünde lexer, parser, semantic, MIR, runtime ve backend katmanları yeniden karşılaştırılmalıdır.