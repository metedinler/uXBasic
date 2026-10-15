# 3. Program yapısı ve dilin yazım kuralları

Bu bölüm, bir uXBasic dosyasının nasıl göründüğünü, satırların nasıl okunduğunu ve adların nasıl verildiğini anlatır.

## 3.1 Dosya türleri

| Uzantı | Ne için? | Not |
|---|---|---|
| `.uxb` | **Ana kaynak dosya** | `uxb` komutu bu uzantıyı bekler |
| `.bas` | FreeBASIC uyumlu kaynak | Kabul edilir |
| `.uxm` | Modül kaynağı | Kabul edilir (örn. sayısal WASM modülü) |
| `.uxmh` | Kütüphane başlığı | `INCLUDE "include/modules/uxmath.uxmh"` ile eklenir (Bölüm 16, 20); doğrudan çalıştırılamaz (`.uxmh baslik dosyasi dogrudan calistirilamaz; include edilmelidir`, çıkış 2). **Tasarım:** başlık yalnız bildirim içerir (`DECLARE`, tip, `CONST`, `ENUM`, `ALIAS`, `USING`, `NAMESPACE`, FFI imzası); yan etkili deyim `UXMH_HEADER_SIDE_EFFECT_NOT_ALLOWED` ile reddedilmelidir. **Bugün** başlığa yazılan `PRINT` hata vermeden çalışır (✖ SESSİZ, G-HEDEF-27); `--source-kind`, `--include-path` ve `--emit-header-surface-json-out` seçenekleri yoktur (çıkış 20) |
| `.bi`, `.h`, `.hx` | Başlık/yardımcı dosyalar | Yüzey kaydında tanınır; kaynak olarak doğrudan verilirse `.bi` "Desteklenmeyen kaynak dosya uzantisi" ile reddedilir |
| `.json` (`.ast.json`, `.mir.json`) | Derleyici raporları | `--ast-json-out`, `--mir-json-out` ile yazılır |
| `.js`, `.wat`, `.wasm`, `.html` | Üretilen hedef dosyaları | Bölüm 21 |

Başka bir uzantıyla çağırırsanız derleyici `Desteklenmeyen kaynak dosya uzantisi ... (.bas/.uxm/.uxb bekleniyor)` der ve çıkış kodu 2 ile durur.

## 3.2 Programın iskeleti

Bir uXBasic programı **yukarıdan aşağıya** çalışır. Dosyada yordam ve işlevler (`SUB`, `FUNCTION`) ile görev yapıları (`THREAD` …) **çağrıdan önce ya da sonra** tanımlanabilir.
İsteğe bağlı olarak giriş noktası `MAIN ... END MAIN` ile belirtilir:

| Biçim | Ne zaman? |
|---|---|
| **Üst düzey deyimler** doğrudan yazılır | Küçük programlar, denemeler |
| `MAIN ... END MAIN` | Okunaklı giriş noktası; yordam tanımları `MAIN`'in dışında, başında yazılır. **`MAIN` ayrılmış addır:** `SUB MAIN()` yazılamaz (`MAIN is reserved for the MAIN … END MAIN program-entry block and cannot name a SUB`) |
| `MODULE ... END MODULE` + `USING` | İşlevleri gruplamak (Bölüm 16) |
| `NAMESPACE ... END NAMESPACE` | Adları gruplamak (Bölüm 16) |

{{ORNEK:40_kv_baslangic/ilk_program_main|baslik=MAIN ile giriş noktası}}

{{ORNEK:41_kv_yapi/sub_tanimdan_once|baslik=Yordam tanımından önce çağırma}}

{{ORNEK:22_kurallar/ust_duzey_degisken|baslik=Dosyanın üstünde tanımlı değişken bütün yordamlardan görülür}}

## 3.3 Satır ve ayraç kuralları

| Kural | Açıklama | Örnek |
|---|---|---|
| Satır sonu deyim ayırıcıdır | Her deyim kendi satırına yazılır | |
| `:` ile aynı satıra birden çok deyim | | `DIM a AS I32: a = 3: PRINT a` |
| `_` ile satır devamı | İfade sonraki satırdan sürer | `1 + _` ↵ `2` |
| Girinti anlam taşımaz | Okunaklılık içindir; dört boşluk önerilir | |
| Büyük/küçük harf farkı yoktur | Anahtar sözcüklerde ve adlarda | `Print`, `PRINT`, `print` aynıdır |

{{ORNEK:41_kv_yapi/ayrac_ve_harf|baslik=Ayraç ve büyük/küçük harf}}

{{ORNEK:41_kv_yapi/satir_devam|baslik=Satır devamı}}

## 3.4 Yorumlar

| Yazım | Anlamı |
|---|---|
| `' açıklama` | Satırın kalanı yorumdur (satır başında ya da deyimden sonra) |
| `REM açıklama` | Aynı; klasik yazım |
| `/' ... '/` | **Yoktur**: blok yorum desteklenmez (✖ G-DIL-2). Her satırı `'` ile başlatın |

> `REM %%` ile başlayan satırlar yorum **değildir**; derleyiciye bilgi veren **meta komutlardır** (Bölüm 18). `REM %%ATTR TEST` gibi satırlar kaydedilir.

## 3.5 Sabitler (değişmez değerler)

| Tür | Yazım | Örnek |
|---|---|---|
| Ondalık tamsayı | rakamlar | `12345678901` (sığmıyorsa `I64`) |
| Onaltılık / sekizlik / ikilik | `&H`, `&O`, `&B` | `&HFF` = 255, `&O17` = 15, `&B1010` = 10 |
| Ondalıklı | nokta ve üslü gösterim | `2.5`, `1E3` = 1000, `2.5E-1` = 0.25 |
| Metin | çift tırnak | `"merhaba"`; tırnak için `""` yazılır |
| Mantıksal | `TRUE` (-1), `FALSE` (0) | |

{{ORNEK:41_kv_yapi/sayi_sabitleri|baslik=Sayı sabitleri}}

{{ORNEK:41_kv_yapi/metin_sabitleri|baslik=Metin sabitleri ve özel karakterler}}

> **Kaçış dizisi yoktur:** `"\t"` yazarsanız `\t` iki karakter olarak yazılır. Satır sonu için `CHR(10)`, sekme için `CHR(9)`, tırnak için `CHR(34)` ya da `""` kullanılır.
> **JS ve WASM notu (✖ G-JS-1, G-WASM-24):** `&H`, `&O`, `&B` sabiti **tek başına** (`PRINT &HFF`, `DIM a AS I32 = &HFF`, `POKEB &H20, 7`) JS'te `undefined` yazar ya da `NaN` adresle durur, WASM'da `wat2wasm`'ın ham hata iletisiyle derlenmez; **ifade içinde** (`&HFF + 1`) altı yolda doğru çalışır. Sabiti `&HFF + 0` biçiminde ifadeye katmak geçici çözümdür.
> **`0x1F` yazmayın (✖ SESSİZ, G-DIL-18):** `0x` öneki yoktur; `DIM a AS I32 = 0x1F` hata vermez ve `0`, çöp sayı ya da `undefined` yazar. Onaltılık için `&H1F` yazın; `$1F` ise sözcük çözümleyici hatasıdır.

## 3.6 Yazdırma: `PRINT`

`PRINT` ekrana yazar. Öğeler arasında iki ayraç vardır:

| Ayraç | Etkisi |
|---|---|
| `;` | Öğeleri **bitişik** yazar (`PRINT "a"; "b"` → `ab`) |
| `,` | Öğeleri **14 sütunluk bölgelere** hizalar |
| Sonda `;` | Satır sonunu **bastırır**; sonraki `PRINT` aynı satırdan devam eder |
| Yalın `PRINT` | Boş satır yazar |

{{ORNEK:41_kv_yapi/print_bicimleri|baslik=PRINT ayraçları}}

> `? ifade` kısayolu yüzey kaydında vardır ama çözümleyici bugün reddeder (✖ G-DIL-3). Her zaman `PRINT` yazın.

## 3.7 Adlar (tanıtıcılar)

* Ad, bir harf ya da alt çizgiyle başlar; harf, rakam ve alt çizgi içerir. **Yalnız ASCII harfler** kullanılır: `ş ğ ı ö ü ç` ve diğer Türkçe harfler adlarda **sözcük çözümleme hatası** verir
  (`sayı` değil `sayi`, `öğrenci` değil `ogrenci`). Metin içinde Türkçe karakter serbesttir.
* Rakamla başlayamaz (`1x` olmaz), nokta içeremez (`a.b` olmaz); uzunluk sınırı pratikte yoktur.
* Büyük/küçük harf fark etmez: `Toplam`, `TOPLAM`, `toplam` aynı adı gösterir.
* **Tip adları ve değişken adları aynı ad uzayındadır**: `CLASS Kutu` varken `DIM kutu AS I32` yazılamaz.
* Ayrılmış sözcük ad olarak kullanılamaz; derleyici açık bir ileti verir:

```
DIM: 'print' is a reserved uXBasic keyword and cannot be used as a variable name; choose another name
```

{{ORNEK:41_kv_yapi/ad_kurallari|baslik=Geçerli adlar}}

**Ad olarak kullanılamayanlardan bazıları** (hepsi sınanmıştır): `PRINT`, `INPUT`, `LOOP`, `END`, `LEN`, `STR`, `ASC`, `ABS`, `MOD`, `STRING`, `I32` (bütün tip adları), `TASK`, `LIST`, `TYPE`, `CLASS`,
`TRUE`, `TIMER`, `ON`, `SLOT`, `EACH`, `TO`, `STEP`, `GET`, `SET`. **Kullanılabilenler:** `LEFT`, `NAME`, `RESULT`, `VALUE`, `COUNT`, `BASE`, `DATA`. Tam liste Ek A'dadır.

> **Tuzak (G-DIL-9):** `LEFT` değişken adı olabilir, ama `FUNCTION Left(...)` tanımlarsanız AST yerleşik `LEFT`'i seçer (`LEFT expects 2 arguments`), MIR ve x64 sizin işlevinizi çağırır.
> Yerleşik işlev adlarıyla aynı adlı işlev **yazmayın**.

## 3.8 Orta düzey örnek: not ortalaması

`CONST`, dizi, `FUNCTION` içinde `SELECT CASE` aralığı, `FOR` ve `MAIN` bir arada:

{{ORNEK:41_kv_yapi/not_ortalamasi|baslik=Not ortalaması ve harf notu}}

## 3.9 Sık yapılan başlangıç hataları

| Hata | İleti | Çözüm |
|---|---|---|
| `FOR i = 1 TO 3` yazıp `i`'yi tanımlamamak | `unknown symbol: i` | `DIM i AS I32` ekleyin |
| `IF a = 1` yazıp `THEN` unutmak | `missing THEN` | `THEN` ekleyin |
| `END IF` / `NEXT` unutmak | `missing END IF` / `missing NEXT` | Bloğu kapatın |
| Türkçe harfli değişken adı | `Lexer diagnostic bridge hata buldu` | ASCII ad kullanın |
| Sınıfla aynı adlı değişken | `variable K conflicts with CLASS K` | Değişkeni yeniden adlandırın |
| Metin değişkenine ilk değer vermemek | AST'de `0` yazılır | `= ""` yazın |

## 3.10 Program yapısıyla ilgili programlama kararları

* Küçük deneme ve komut dosyalarını **üst düzey deyimlerle**, paylaşılacak ya da okunacak programı **`MAIN ... END MAIN`** ile yazın; yordamları `MAIN`'in dışına, başına koyun.
* Her deyimi **kendi satırına** yazın; `:` yalnız çok kısa ve birbirine bağlı deyimler için kullanın (`DIM i AS I32: i = 0`). Uzun ifadeleri `_` ile bölün; girintiyi dört boşluk yapın.
* **Blok yorum yoktur** (G-DIL-2): her yorum satırını `'` ile başlatın. `REM %%` ile başlayan satır yorum değil meta komuttur; yorum yazmak için kullanmayın.
* Adları **yalnız ASCII harfle** yazın (`ogrenci`, `sayi`); Türkçe karakterleri yalnız metin sabitlerinde kullanın.
* Ayrılmış sözcükleri (`PRINT`, `LEN`, `ON`, `U8`, `F64`, `TASK` …) ad olarak kullanmayın; derleyici bunu açık bir iletiyle bildirir. **Yerleşik işlevle aynı adlı işlev yazmayın** (G-DIL-9).
* Bir tip adıyla (`CLASS`, `TYPE`) aynı adlı değişken tanımlamayın: tip ve değişken adları aynı ad uzayındadır.
* **Metin değişkenine her zaman ilk değer verin** (`= ""`): AST'de ilk değersiz `STRING` `0` ile başlar (G-DIL-4).
* Kaçış dizisi yoktur; satır sonu için `CHR(10)`, sekme için `CHR(9)`, tırnak için `""` yazın.
* `?` kısayolu yerine **`PRINT`** yazın (G-DIL-3).
* JS'e gidecek programda `&H`, `&O`, `&B` sabitleri yerine **onluk sabit** kullanın (G-JS-1).
