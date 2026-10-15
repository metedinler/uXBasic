# uXBasic Programlayıcının Cep Kitabı

**Dosya adı:** `pck.md`  
**Amaç:** uXBasic öğrenmek, uXBasic ile program yazmak ve uXBasic derleyicisini geliştirmek isteyen genç programcıya cep kitabı vermek.  
**Kaynak gerçekliği:** Bu kitap, `uxb(30.05_3).zip` içindeki kaynak ağacı, lexer, parser, MIR, çalışma zamanı servis kataloğu, kütüphane kayıtları, VSCode belgeleri ve gate raporları taranarak hazırlandı.

Bu kitap eski kısa belgeler gibi yalnız liste değildir. Önce uXBasic’in ne olduğunu sade bir dille anlatır, sonra dilin komutlarını tabloya döker, sonra her tabloyu örneklerle öğretir, en sonunda da derleyici geliştiren kişiye çalışma yöntemi verir. İngilizce terim gerektiğinde Türkçe karşılık, köşeli parantez içinde açıklama ve parantez içinde İngilizcesi birlikte verilir.

## Kod gerçekliği notu

- ADIM22 tam katman beklenen çıktı kapısı: **PASS / missing_layer_output_count=0 / surface_coverage_count=287**. Bu, temel katman çıktılarının gerçek dosya olarak üretildiğini gösteren güçlü işarettir.

- ADIM30 on adım zinciri mevcut raporu: **FAIL / fail_count=37 / missing_output_count=72 / placeholder_count=0**. Bu kitap öğretici cep kitabıdır; ADIM30 gibi daha geniş zincirlerde kalan işler varsa, bunlar geliştirme işidir.

- Çalışma zamanı servislerinde `JSON`, `REGEX`, `HTTP`, `OS`, `LLAMA`, `LUA`, `PROLOG`, `SQLITE`, `BROWSER`, `WEBGPU`, `CURL`, `ONNX` gibi kapılar katalogda görünür. Bunların hepsi dil yüzeyinden çağrılabilir bir tasarıma bağlanır; fakat her biri için gerçek sarmalayıcı [var olan işi çevreleyen ince bağlantı katmanı] (wrapper) ve test yazılmalıdır.

## Bu kitap yedi çalışma oturumu olarak okunmalı

| Oturum | Konu |
| --- | --- |
| 1 | uXBasic nedir, nasıl düşünülür, ilk program nasıl yazılır? |
| 2 | Değişken, veri tipi, işlem, karar, döngü ve yordam temeli. |
| 3 | Dosya, bellek, veri yapısı, tablo ve bilimsel hesap mantığı. |
| 4 | Derleyici mimarisi: lexer, parser, AST, semantic, HIR, MIR, runtime, backend. |
| 5 | Tam komut, ön-işleyici, tip, işlemci ve yerel fonksiyon tabloları. |
| 6 | Dış kütüphane, DLL/API, C/CPP/ASM içe alma, ağ, REST, Flask, yerel yapay zeka. |
| 7 | uXBasic geliştiricisine tavsiyeler: kanca, sarmalayıcı, test kapısı, hata avı, üretim disiplini. |

# 1. uXBasic nedir?

uXBasic, BASIC dilinin sade okunurluğunu sistem programlama hedefleriyle birleştirmeye çalışan bir dildir. BASIC geleneğinde `PRINT`, `DIM`, `IF`, `FOR`, `SUB`, `FUNCTION` gibi kolay okunan komutlar vardır. uXBasic bu okunurluğu korurken dış kütüphane çağırma, DLL/API kullanma, C/C++/ASM dosyası içe alma, JavaScript üretme, WebAssembly metni üretme, x64 assembly üretme ve tarayıcıda çalışma gibi daha ileri hedeflere açılır.

Bir dili yalnız komut listesi zannetmek yanlıştır. Dil, yazdığın metni önce parçalara ayırır, sonra ağaca çevirir, sonra anlamını çözer, sonra ara dile indirir, sonra çalıştırır ya da başka hedefe kod üretir. uXBasic’in asıl değeri bu zinciri açık katmanlara ayırmasıdır. Bir genç programcı için en güzel taraf şudur: aynı programı önce yorumlayıcı [satırları veya ara temsili hemen çalıştıran katman] (interpreter) ile deneyebilir, sonra derleyici [programı başka makine diline veya hedef koda çeviren katman] (compiler) ile üretebilir.

uXBasic ile konsol programı, dosya işleyen araç, veri okuyan küçük analiz programı, Windows DLL kullanan sistem aracı, tarayıcıda çalışan küçük oyun, JavaScript çıktısı, WebAssembly metni, x64 assembly çıktısı ve ileride daha büyük bilimsel/istatistiksel yardımcılar yapılabilir. Ama her hedefin destek düzeyi aynı değildir. Bu yüzden programcı daima şu soruyu sorar: “Bu komut lexer tarafından tanınıyor mu, parser AST düğümü üretiyor mu, anlam katmanı kabul ediyor mu, MIR’e iniyor mu, hedef kod üreticisi bunu biliyor mu, runtime servisi var mı?”

İlk program çok basittir:

```uxbasic
PRINT "Merhaba uXBasic"
DIM yas AS I32
yas = 18
IF yas >= 18 THEN
    PRINT "Program yazmaya baslayabilirsin"
ELSE
    PRINT "Once temel alistirma yap"
END IF
```

Bu örnekte `PRINT` ekrana yazar, `DIM` değişken tanımlar, `AS I32` değişkenin 32 bit işaretli tam sayı olduğunu söyler, `IF` ise karar verir. Kodun güzel tarafı, okuyan kişinin programın amacını tahmin edebilmesidir.

# 2. uXBasic mimarisi: genç programcı için sade anlatım

| Türkçe terim | Açıklama | İngilizce |
| --- | --- | --- |
| Ön-işleyici | Kaynak kod derlenmeden önce makro, koşul ve dosya ekleme işlerini yapan katman | preprocessor |
| Sözcükleyici | Kaynak metni kelime, sayı, metin, işlemci ve satır sonu parçalarına ayıran katman | lexer |
| Ayrıştırıcı | Sözcükleri program ağacına çeviren katman | parser |
| Soyut sözdizim ağacı | Programın ağaç biçimli iç gösterimi | abstract syntax tree / AST |
| Anlam çözümleyici | Değişken, tip, kapsam ve geçerlilik kontrolü yapan katman | semantic analyzer |
| Yüksek ara gösterim | AST ile MIR arasında daha anlamlı ara kayıt | high intermediate representation / HIR |
| Orta ara gösterim | Hedeflerden bağımsız, komutlara yakın ara dil | middle intermediate representation / MIR |
| Doğrulayıcı | MIR veya katman çıktısında sözleşme bozulmuş mu diye bakan kapı | verifier |
| Çalışma zamanı | Program çalışırken PRINT, dosya, bellek, DLL gibi işleri yapan katman | runtime |
| Kod üretici | MIR veya AST bilgisinden JS, WAT, ASM gibi hedef çıktı üreten katman | code generator / backend |
| Kanca | Bir akışın belirli noktasına takılan izleme veya ek çalışma noktası | hook |
| Sarmalayıcı | Var olan işi daha düzgün arayüzle çağıran ince katman | wrapper |

uXBasic kaynak ağacında bu katmanlar ayrı klasörler ve dosyalarla görünür. `src/parser` sözcükleyici ve ayrıştırıcı tarafını, `src/semantic` anlam ve MIR indirme tarafını, `src/mir` MIR modelini, `src/runtime` çalışma zamanı servislerini, `src/codegen/js` JavaScript üretimini, `src/codegen/wasm` WebAssembly metin üretimini, `src/backend` hedef bağlama akışını, `src/cli` komut satırı yönlendirmesini taşır. Bu ayrım yalnız düzen için değildir; hata bulurken de hayat kurtarır.

Bir uXBasic programının yolculuğu şöyledir:

```text
.uxb kaynak
  -> ön-işleyici: %%DEFINE, %%INCLUDE, %%IF gibi satırları çözer
  -> sözcükleyici: PRINT, "metin", 123, + gibi tokenlar üretir
  -> ayrıştırıcı: PRINT_STMT, IF_STMT, CALL_DLL_STMT gibi AST düğümleri üretir
  -> anlam katmanı: değişken var mı, tip uyuyor mu, kapsam doğru mu bakar
  -> HIR ve düzen: sınıf, kayıt, alan, bellek düzeni bilgilerini çıkarır
  -> MIR: LOAD_CONST, STORE_VAR, PRINT, CALL_DLL gibi ara işlemler üretir
  -> doğrulayıcı: eksik hedef, bozuk düğüm, kırık yol var mı denetler
  -> çalışma zamanı veya hedef üretici: AST/MIR yorumlar, JS/WAT/x64 üretir
```

Bu zinciri ezberlemek yerine günlük kontrol cümlesi olarak kullan: “Bir özellik ekledim, peki her katmanda izi var mı?” Sadece lexer’a kelime eklemek dil özelliği eklemek değildir. Parser AST üretmezse kelime ölüdür. MIR’e inmiyorsa hedefler görmez. Runtime servisi yoksa çalışırken patlar.

# 3. İlk programlama bilgileri

Program, bilgisayara verilen sıradır. Değişken, adı olan kutudur. Tip, kutuya hangi tür değer konacağını söyler. Deyim, yapılacak işi anlatan satırdır. İfade, değer üreten parçadır. `5 + 3` bir ifadedir; `PRINT 5 + 3` bir deyimdir.

```uxbasic
DIM fiyat AS F64
DIM adet AS I32
DIM toplam AS F64
fiyat = 12.5
adet = 4
toplam = fiyat * adet
PRINT "Toplam="; toplam
```

Burada `F64` kesirli sayılar için güvenli seçimdir. `I32` genel tam sayıdır. `PRINT` içinde noktalı virgül kullanmak, BASIC geleneğinde yan yana yazdırma niyeti verir. Virgül ise alanlı yazdırma niyeti taşır.

Karar vermek için `IF` kullanılır:

```uxbasic
DIM notu AS I32
notu = 72
IF notu >= 85 THEN
    PRINT "Pekiyi"
ELSEIF notu >= 60 THEN
    PRINT "Gecti"
ELSE
    PRINT "Kaldi"
END IF
```

Döngü, aynı işi tekrarlar. Sayaçlı tekrar için `FOR`, koşullu tekrar için `DO` kullanılır:

```uxbasic
DIM i AS I32
DIM toplam AS I32
toplam = 0
FOR i = 1 TO 10 STEP 1
    toplam += i
NEXT
PRINT "1 den 10 a toplam="; toplam
```

Yordam [adı olan tekrar kullanılabilir kod parçası] (subroutine) yazmak için `SUB`, değer döndüren yordam yazmak için `FUNCTION` kullanılır:

```uxbasic
FUNCTION Kare(x AS F64) AS F64
    RETURN x * x
END FUNCTION

SUB Baslik(yazi AS STRING)
    PRINT "==== "; yazi; " ===="
END SUB

Baslik("Deneme")
PRINT Kare(5)
```

# 4. Tam komut tablosu: parser dağıtımına göre gerçek yüzey

Aşağıdaki tablo, kaynakta `AddStatementDispatchEntry` ile gerçek ayrıştırıcı dağıtımına giren komutlardan hazırlanmıştır. Bu yüzden yalnız lexer’da görünen her sözcük değil, parser tarafından deyim olarak yakalanan komutlar esas alınmıştır.

| No | Komut | Görev | Sözde yazım |
| --- | --- | --- | --- |
| 1 | PRINT | Ekrana veya hedef çıktıya değer yazdırır. | PRINT ifade [, ifade] [; ifade] |
| 2 | INLINE | Dış dil gövdesi için ayrılmış yer açar. | INLINE ... END INLINE |
| 3 | CALL | Bir yordamı, kütüphane çağrısını veya dış çağrıyı çalıştırır. | CALL ad(arg1, arg2) veya CALL(DLL, "lib.dll", "symbol", I32, arg) |
| 4 | IF | Koşullu karar verir. | IF koşul THEN ... [ELSEIF koşul THEN ...] [ELSE ...] END IF |
| 5 | SELECT | Bir değer için çoklu karar yapısı kurar. | SELECT CASE ifade : CASE değer : ... : CASE ELSE : ... : END SELECT |
| 6 | FOR + EACH | Saymalı döngü kurar. | FOR i = 1 TO 10 [STEP 1] ... NEXT |
| 7 | DO + EACH | Koşullu genel döngü kurar. | DO [WHILE koşul] ... LOOP [UNTIL koşul] |
| 8 | GOTO | Etikete sıçrar. | GOTO etiket |
| 9 | GOSUB | Alt etikete gider ve geri dönmesi beklenen eski BASIC akışını temsil eder. | GOSUB etiket |
| 10 | RETURN | Fonksiyon veya alt akıştan döner. | RETURN [ifade] |
| 11 | EXIT | Döngüden veya bloktan çıkar. | EXIT [FOR\|DO\|SUB\|FUNCTION] |
| 12 | END | Blok veya program sonunu işaretler. | END [IF\|SELECT\|SUB\|FUNCTION\|TYPE\|CLASS\|MODULE\|NAMESPACE] |
| 13 | TRY | Hata yakalama bloğu başlatır. | TRY ... CATCH ad ... FINALLY ... END TRY |
| 14 | THROW | Hata fırlatır. | THROW ifade |
| 15 | ASSERT | Doğruluk denetimi yapar. | ASSERT koşul |
| 16 | DELETE | Nesne veya ayrılmış alanı bırakır. | DELETE nesne |
| 17 | DECLARE | Dış ya da ileride tanımlı yordam imzası bildirir. | DECLARE FUNCTION ad(args) AS tip |
| 18 | SUB | Değer döndürmeyen yordam tanımlar. | SUB ad(args) ... END SUB |
| 19 | FUNCTION | Değer döndüren yordam tanımlar. | FUNCTION ad(args) AS tip ... END FUNCTION |
| 20 | CONST | Sabit değer tanımlar. | CONST ad AS tip = değer |
| 21 | DIM | Değişken veya dizi tanımlar. | DIM ad AS tip / DIM dizi(1 TO n) AS tip |
| 22 | REDIM | Dizi boyutunu değiştirir. | REDIM dizi(1 TO yeni_boyut) AS tip |
| 23 | TYPE | Kayıt türü tanımlar. | TYPE Ad ... END TYPE |
| 24 | CLASS | Sınıf tanımlar. | CLASS Ad ... END CLASS |
| 25 | ABSTRACT + CLASS | Soyut sınıf bildirimiyle birlikte kullanılır. | ABSTRACT CLASS Ad ... END CLASS |
| 26 | FINAL + CLASS | Türetilmesini kapatacak sınıf bildirimiyle birlikte kullanılır. | FINAL CLASS Ad ... END CLASS |
| 27 | SEALED + CLASS | Kapalı sınıf bildirimiyle birlikte kullanılır. | SEALED CLASS Ad ... END CLASS |
| 28 | INTERFACE | Arayüz tanımlar. | INTERFACE Ad ... END INTERFACE |
| 29 | NAMESPACE | Ad alanı açar. | NAMESPACE ad ... END NAMESPACE |
| 30 | MODULE | Modül açar. | MODULE ad ... END MODULE |
| 31 | MAIN | Ana giriş bloğu tanımlar. | MAIN ... END MAIN |
| 32 | USING | Ad alanı veya modülü görünür kılar. | USING ad veya USING MODULE ad |
| 33 | ALIAS | Kısa ad tanımlar. | ALIAS kısa = uzun |
| 34 | DEFINT | Harf aralığı için varsayılan tam sayı tipi seçer. | DEFINT A-Z |
| 35 | DEFLNG | Varsayılan uzun tam sayı tipi seçer. | DEFLNG A-Z |
| 36 | DEFSNG | Varsayılan tek duyarlıklı sayı tipi seçer. | DEFSNG A-Z |
| 37 | DEFDBL | Varsayılan çift duyarlıklı sayı tipi seçer. | DEFDBL A-Z |
| 38 | DEFEXT | Geniş sayı tipi için varsayılan seçer. | DEFEXT A-Z |
| 39 | DEFSTR | Varsayılan metin tipi seçer. | DEFSTR A-Z |
| 40 | DEFBYT | Varsayılan bayt tipi seçer. | DEFBYT A-Z |
| 41 | SETSTRINGSIZE | Metin alanı boyutu için çalışma zamanı ayarı yapar. | SETSTRINGSIZE sayı |
| 42 | INCLUDE | uXBasic kaynak dosyası ekler. | INCLUDE "dosya.uxb" |
| 43 | IMPORT | C, CPP veya ASM dosyasını içe alma kaydı oluşturur. | IMPORT(C, "dosya.c") / IMPORT(CPP, "dosya.cpp") / IMPORT(ASM, "dosya.asm") |
| 44 | INPUT | Kullanıcıdan veya dosyadan veri okur. | INPUT değişken veya INPUT #dosya, değişken |
| 45 | INPUTF | Dosyadan biçimli giriş okur. | INPUTF #dosya, değişken |
| 46 | OPEN | Dosya açar. | OPEN "dosya" FOR INPUT\|OUTPUT\|APPEND\|BINARY AS #1 [LEN sayı] |
| 47 | CLOSE | Dosya kapatır. | CLOSE #1 |
| 48 | GET | Dosyadan veri alır. | GET #1, konum, değişken |
| 49 | PUT | Dosyaya veri yazar. | PUT #1, konum, değer |
| 50 | SEEK | Dosya konumunu değiştirir. | SEEK #1, konum |
| 51 | LOCATE | Ekran imlecini konumlandırır. | LOCATE satır, sütun |
| 52 | COLOR | Ekran rengini ayarlar. | COLOR ön, arka |
| 53 | CLS | Ekranı temizler. | CLS |
| 54 | INC | Değeri bir artırır. | INC değişken |
| 55 | DEC | Değeri bir azaltır. | DEC değişken |
| 56 | RANDOMIZE | Rastgele sayı üretecini başlatır. | RANDOMIZE [tohum] |
| 57 | POKEB | Belleğe bayt yazar. | POKEB adres, değer |
| 58 | POKEW | Belleğe sözcük yazar. | POKEW adres, değer |
| 59 | POKED | Belleğe çift sözcük yazar. | POKED adres, değer |
| 60 | POKE | Belleğe değer yazar. | POKE adres, değer |
| 61 | MEMCOPYB | Bayt tabanlı bellek kopyalar. | MEMCOPYB hedef, kaynak, adet |
| 62 | MEMFILLB | Belleği bayt ile doldurur. | MEMFILLB hedef, değer, adet |
| 63 | POKES | Belleğe metin yazar. | POKES adres, metin |
| 64 | MEMCOPYW | Sözcük tabanlı bellek kopyalar. | MEMCOPYW hedef, kaynak, adet |
| 65 | MEMCOPYD | Çift sözcük tabanlı bellek kopyalar. | MEMCOPYD hedef, kaynak, adet |
| 66 | MEMFILLW | Belleği sözcük ile doldurur. | MEMFILLW hedef, değer, adet |
| 67 | MEMFILLD | Belleği çift sözcük ile doldurur. | MEMFILLD hedef, değer, adet |
| 68 | SETNEWOFFSET | Yeni nesne/alan ayırma kaymasını ayarlar. | SETNEWOFFSET adres |
| 69 | EVENT | Olay tanımlar. | EVENT ad(args) |
| 70 | THREAD | İş parçacığı tanımlar. | THREAD ad ... END THREAD |
| 71 | PARALEL | Paralel çalışma ipucu tanımlar. | PARALEL ... END PARALEL |
| 72 | PIPE | Veri hattı tanımlar. | PIPE ad |
| 73 | SLOT | Olay yuvası tanımlar. | SLOT ad(args) ... END SLOT |
| 74 | ON | Yuvayı açar veya olay bağlar. | ON slot_ad |
| 75 | OFF | Yuvayı kapatır. | OFF slot_ad |
| 76 | TRIGGER | Olay tetikler. | TRIGGER olay_ad(args) |

## Komut gruplarını kullanma teknikleri

### 4.1 Yazdırma, değişken, karar, döngü, yordam birlikte

```uxbasic
CONST LIMIT AS I32 = 5
DIM i AS I32
DIM kare AS I32

FUNCTION Hesapla(x AS I32) AS I32
    RETURN x * x
END FUNCTION

FOR i = 1 TO LIMIT
    kare = Hesapla(i)
    IF kare > 10 THEN
        PRINT "Buyuk kare: "; kare
    ELSE
        PRINT "Kucuk kare: "; kare
    END IF
NEXT
```

Bu örnekte beşten fazla komut birlikte çalışır: `CONST`, `DIM`, `FUNCTION`, `RETURN`, `FOR`, `IF`, `PRINT`, `NEXT`. Programın amacı sayıların karesini almak ve eşiğe göre yazdırmaktır. İpucu şudur: küçük fonksiyon yazmak aklı temizler. Döngünün içine uzun formül gömmek yerine `Hesapla` gibi ad koyarsan program okunur.

### 4.2 Dosya açma, yazma, konumlama, okuma

```uxbasic
DIM ad AS STRING
DIM satir AS STRING
ad = "rapor.txt"

OPEN ad FOR OUTPUT AS #1
PUT #1, 1, "uXBasic raporu"
CLOSE #1

OPEN ad FOR INPUT AS #1
GET #1, 1, satir
PRINT "Dosyadan gelen="; satir
CLOSE #1
```

Dosya işinde kural basittir: aç, işle, kapat. `OPEN` olmazsa dosya yolu yoktur. `PUT` yazmak, `GET` okumak içindir. `SEEK` ile konum değiştirilir. Hata yakalamayı güçlendirmek için dosya yolu, yetki, uzunluk ve son durum ayrıca raporlanmalıdır.

### 4.3 Bellek işleri: güçlü ama tehlikeli alan

```uxbasic
DIM adres AS U64
DIM deger AS U8
adres = 1024
deger = 65
POKEB adres, deger
PRINT "Bellege bayt yazildi"
```

Bellek komutları sistem programlama için önemlidir. Ama bellek komutu oyuncak değildir. Yanlış adrese yazmak programı bozabilir. Bu yüzden `POKEB`, `MEMCOPYB`, `MEMFILLB` gibi komutlarda önce hedef adresi, uzunluğu ve sınırı düşün. Derleyici yazarken buna “kapalı başarısızlık” [emin değilse çalışmayı durdurma] (fail closed) denir.

### 4.4 Olay, yuva, boru ve paralel düşünme

```uxbasic
EVENT TusBasildi(kod AS I32)

SLOT EkranaYaz(kod AS I32)
    PRINT "Tus kodu="; kod
END SLOT

ON EkranaYaz
TRIGGER TusBasildi(65)
OFF EkranaYaz
```

Kaynakta `EVENT`, `SLOT`, `ON`, `OFF`, `TRIGGER`, `PIPE`, `THREAD`, `PARALEL` yüzeyi vardır. Bu aile programı parçalara ayırmak için düşünülmelidir. Olay “bir şey oldu” demektir. Yuva “o şey olunca bu kod çalışsın” demektir. Boru “veri buradan oraya aksın” demektir. İş parçacığı [aynı program içinde ayrı çalışma kolu] (thread) ise eşzamanlılık işidir.

# 5. Ön-işleyici komutları

Ön-işleyici, program daha tokenlara ayrılmadan çalışır. Makro tanımlar, koşullu satır seçer, dosya ekler ve bazı blokları geçer. Bu katman özellikle çok hedefli program yazarken önemlidir. Aynı kaynak Windows için başka, tarayıcı için başka satır açabilir.

| No | Komut | Görev | Sözde yazım |
| --- | --- | --- | --- |
| 1 | DEFINE / SET | Makro adı ve değeri tanımlar. | %%DEFINE AD 1 / %%SET AD 1 |
| 2 | MACRO | Parametreli veya parametresiz makro tanımlar. | %%MACRO TOPLA(A,B) ((A)+(B)) |
| 3 | UNDEF | Makroyu kaldırır. | %%UNDEF AD |
| 4 | IF | Makro veya sayısal koşula göre satırları açar/kapatır. | %%IF DEBUG |
| 5 | IFC | İki makro/değer eşitse bloğu açar. | %%IFC PLATFORM, WINDOWS |
| 6 | ELSE | Koşulun ters bloğunu açar. | %%ELSE |
| 7 | ENDIF | Koşullu bloğu bitirir. | %%ENDIF |
| 8 | INCLUDE | Kaynağa başka dosya ekler; yol güvenliği uygulanır. | %%INCLUDE "ortak.uxb" |
| 9 | ENDCOMP | Derleme öncesi işlemeyi durdurur. | %%ENDCOMP |
| 10 | ERRORENDCOMP | Hata vererek durdurur. | %%ERRORENDCOMP mesaj |
| 11 | PLATFORM | Çalışılan platformu denetler. | %%PLATFORM WINDOWS |
| 12 | DESTOS | Hedef işletim sistemi makrosu belirler. | %%DESTOS WINDOWS |
| 13 | NOZEROVARS | Sıfırlama davranışı için aç/kapat ayarıdır. | %%NOZEROVARS ON |
| 14 | SECSTACK | Güvenli yığın ayarı için aç/kapat ayarıdır. | %%SECSTACK ON |
| 15 | JS_BEGIN / JS_END | Ön-işleyicide geçilen JavaScript gövdesi bloğunu işaretler. | %%JS_BEGIN ... %%JS_END |
| 16 | WAT_BEGIN / WAT_END | WebAssembly metin gövdesi bloğunu işaretler. | %%WAT_BEGIN ... %%WAT_END |
| 17 | HTML_BEGIN / HTML_END | HTML gövdesi bloğunu işaretler. | %%HTML_BEGIN ... %%HTML_END |
| 18 | CSS_BEGIN / CSS_END | CSS gövdesi bloğunu işaretler. | %%CSS_BEGIN ... %%CSS_END |

Örnek:

```uxbasic
%%DEFINE DEBUG 1
%%IF DEBUG
PRINT "Hata ayiklama acik"
%%ELSE
PRINT "Normal calisma"
%%ENDIF

%%MACRO KARE(X) ((X) * (X))
DIM a AS I32
a = KARE(7)
PRINT a
```

Makro, dikkatli kullanılmalıdır. Makro metin değiştirir; tip bilmez. Bu yüzden `KARE(X)` gövdesinde parantez kullanmak küçük ama zeki bir hiledir. `KARE(1+2)` yazılırsa `((1+2) * (1+2))` olur. Parantezsiz yazılsaydı işlem önceliği bozulabilirdi.

# 6. Veri tipleri

Tip seçimi programcının namusudur. Her şeyi `F64` yapmak kolay görünür ama belleği ve anlamı bozar. Her şeyi `I32` yapmak da kesirli hesabı yok eder. En iyi yol, verinin gerçek doğasına göre tip seçmektir.

| Tip | Anlam | Ne zaman kullanılır |
| --- | --- | --- |
| I8 | 8 bit işaretli tam sayı | küçük sayaç, bayt yorumu |
| U8 | 8 bit işaretsiz tam sayı | renk, bayt, maske |
| I16 | 16 bit işaretli tam sayı | eski sistem uyumu |
| U16 | 16 bit işaretsiz tam sayı | adres, renk, tablo |
| I32 | 32 bit işaretli tam sayı | genel tam sayı |
| U32 | 32 bit işaretsiz tam sayı | bit alanı, dosya uzunluğu |
| I64 | 64 bit işaretli tam sayı | büyük sayaç |
| U64 | 64 bit işaretsiz tam sayı | adres, büyük uzunluk |
| F32 | tek duyarlıklı kesirli sayı | hız gereken hesap |
| F64 | çift duyarlıklı kesirli sayı | bilimsel hesap |
| F80 | geniş kesirli sayı | dış çalışma zamanı DLL ile |
| F128 | çok geniş kesirli sayı | dış çalışma zamanı DLL ile |
| BIGF | büyük kesirli sayı | büyük sayı DLL ile |
| BIGD | büyük ondalık sayı | finans/bilim |
| BALL | büyük tümleşik aile | büyük sayı ailesi |
| BOOLEAN | doğru/yanlış | koşul |
| STRING | metin | dosya, ekran, ağ |
| OBJECT | nesne | sınıf örneği |
| PTR | işaretçi | dış çağrı ve bellek |
| STRPTR | metin işaretçisi | DLL/API metin aktarımı |
| BYTE | bayt | ham veri |
| BYREF | başvuru ile aktarım | değişkeni dış çağrıya adreslenebilir gönderme |
| BYVAL | değer ile aktarım | kopya gönderme |
| CDECL | C çağrı düzeni | DLL/API sözleşmesi |
| STDCALL | Windows çağrı düzeni | DLL/API sözleşmesi |

Örnek:

```uxbasic
DIM sayac AS I32
DIM uzunluk AS U64
DIM sicaklik AS F64
DIM ad AS STRING
DIM dogruMu AS BOOLEAN

sayac = 10
uzunluk = 2048
sicaklik = 24.75
ad = "deney-1"
dogruMu = sayac > 0
PRINT ad; " sicaklik="; sicaklik
```

İpucu: Dosya boyu, adres ve uzunluk gibi negatif olmaması gereken değerlerde `U64` iyi seçimdir. Bilimsel ölçümde `F64` kullan. Ekran ve dosya metninde `STRING` kullan. DLL/API çağırırken `PTR` ve `STRPTR` gibi işaretçi tiplerini ancak ne yaptığını biliyorsan kullan.

# 7. Veri yapıları

| No | Yapı | Görev | Sözde yazım |
| --- | --- | --- | --- |
| 1 | ARRAY | Sabit veya yeniden boyutlanabilir dizi. | DIM a(1 TO 10) AS F64 |
| 2 | LIST | Sıralı büyüyen liste fikri. | DIM l AS LIST |
| 3 | DICT | Anahtar-değer sözlüğü fikri. | DIM d AS DICT |
| 4 | SET | Tekil değer kümesi fikri. | DIM s AS SET |
| 5 | TYPE | Kendi kayıt tipini oluşturur. | TYPE Nokta : x AS F64 : y AS F64 : END TYPE |
| 6 | CLASS | Alan ve yöntemleri birlikte taşıyan nesne tanımlar. | CLASS Oyuncu ... END CLASS |

Kod gerçekliği açısından `ARRAY`, `LIST`, `DICT`, `SET` lexer yüzeyinde vardır; AST/MIR zincirinde her hedef için destek seviyesi ayrıca doğrulanmalıdır. Bu yüzden cep kuralı şudur: dizi temel örneklerde daha güvenli alandır; liste/sözlük/küme için önce ilgili test dosyasını ve MIR çıktısını kontrol et.

Kayıt örneği:

```uxbasic
TYPE Olcum
    zaman AS F64
    sicaklik AS F64
    ph AS F64
END TYPE

DIM o AS Olcum
o.zaman = TIMER()
o.sicaklik = 25.1
o.ph = 7.8
PRINT "pH="; o.ph
```

Sınıf örneği:

```uxbasic
CLASS Sayac
PRIVATE
    deger AS I32
PUBLIC
    CONSTRUCTOR()
        deger = 0
    END CONSTRUCTOR
    METHOD Artir()
        deger += 1
    END METHOD
    PROPERTY Deger AS I32
        GET
            RETURN deger
        END GET
    END PROPERTY
END CLASS
```

Sınıf, yalnız “havalı” olduğu için kullanılmaz. Aynı veriyi ve o veriye ait davranışı birlikte tutmak için kullanılır. `Sayac` sınıfı içinde değeri dışarıdan doğrudan oynatmak yerine `Artir` yöntemi kullanılır. Bu, büyük programlarda hatayı azaltır.

# 8. İşlemciler

| No | İşlemci | Görev |
| --- | --- | --- |
| 1 | = | Atama ya da eşitlik bağlamı |
| 2 | += -= *= /= \= %= | Bileşik atama |
| 3 | ++ -- | Bir artırma/azaltma |
| 4 | + - * / \ % ** | Aritmetik işlemler |
| 5 | < <= > >= <> != == | Karşılaştırma |
| 6 | AND OR NOT XOR | Mantıksal işlemler |
| 7 | & \| ^ ~ | Bit düzeyi işlemler |
| 8 | << >> <<= >>= | Bit kaydırma |
| 9 | ROL ROR SHL SHR | Döndürme/kaydırma anahtar sözleri |
| 10 | ( ) | Gruplama ve çağrı |
| 11 | [ ] | Dizinleme |
| 12 | , | Argüman/alan ayırma |
| 13 | : | Aynı satırda deyim ayırma |
| 14 | ; | PRINT yazımında bitiş davranışı |
| 15 | . | Üye veya ad alanı erişimi |
| 16 | @ # ? ! \|> | Lexer yüzeyinde ayrılmış özel işaretler |

İşlem önceliğini ezberlemek yerine parantez kullan. Derleyici yazarken de aynı kural geçerlidir: belirsizliği okuyucuya bırakma.

```uxbasic
DIM a AS I32
DIM b AS I32
DIM c AS I32
a = 5
b = 2
c = (a + b) * 3
IF (c >= 20) AND (a <> b) THEN
    PRINT "Kosul saglandi"
END IF
```

Bit işlemleri sistem programlamada kullanılır. Örneğin bir bayt içinde bayrak saklayabilirsin:

```uxbasic
DIM bayrak AS U8
bayrak = 0
bayrak = bayrak OR 1      ' birinci ozelligi ac
bayrak = bayrak OR 4      ' ucuncu biti ac
IF (bayrak AND 4) <> 0 THEN
    PRINT "Ucuncu bit acik"
END IF
```

# 9. Yerel fonksiyonlar

| Fonksiyon | Görev | Örnek |
| --- | --- | --- |
| TIMER | Zaman değeri döndürür. | saniye = TIMER() |
| RND | Rastgele sayı döndürür. | x = RND() |
| RANDOMIZE | Rastgele üreteci başlatır. | RANDOMIZE 123 |
| LEN | Metin uzunluğu. | n = LEN(ad) |
| MID | Metinden parça. | p = MID(ad, 2, 3) |
| STR | Sayıyı metne çevirir. | s = STR(42) |
| VAL | Metni sayıya çevirir. | n = VAL("42") |
| ABS | Mutlak değer. | a = ABS(-5) |
| INT | Aşağı yuvarlama/tam kısım. | i = INT(3.9) |
| FIX | Sıfıra doğru tam kısım. | i = FIX(-3.9) |
| SGN | İşaret değeri. | s = SGN(x) |
| SQR / SQRT | Karekök. | k = SQRT(16) |
| SIN COS TAN ATN | Trigonometrik işler. | y = SIN(a) |
| EXP LOG | Üstel ve logaritma. | l = LOG(x) |
| UCASE LCASE | Büyük/küçük harf. | u = UCASE(ad) |
| LTRIM RTRIM | Sol/sağ boşluk kırpma. | t = LTRIM(s) |
| ASC CHR | Karakter kodu ve karakter üretme. | c = CHR(65) |
| SPACE STRING | Boşluk veya tekrar eden metin üretme. | s = SPACE(10) |
| INKEY GETKEY | Klavye okuma. | k = INKEY() |
| LOF EOF | Dosya uzunluğu/sonu. | bitti = EOF(#1) |
| PEEKB PEEKW PEEKD | Bellekten okuma. | v = PEEKB(adres) |
| VARPTR SADD LPTR CODEPTR | Adres/işaretçi alma. | p = VARPTR(x) |
| SIZEOF OFFSETOF | Boyut ve alan kayması. | n = SIZEOF(x) |
| CINT CLNG CSNG CDBL | Tip dönüşümü. | d = CDBL(x) |

Metin ve sayı fonksiyonlarını birlikte kullanma örneği:

```uxbasic
DIM ham AS STRING
DIM temiz AS STRING
DIM sayi AS F64
ham = "  42.50  "
temiz = LTRIM(RTRIM(ham))
sayi = VAL(temiz)
PRINT "Karekoku="; SQRT(sayi)
PRINT "Buyuk harf="; UCASE("uxbasic")
```

Bilimsel hesapta önce veriyi temizle, sonra sayıya çevir, sonra hesapla. Bu küçük sıra büyük hataları önler.

# 10. Çalışma zamanı servis kataloğu

Aşağıdaki tablo, kaynakta `UXBRuntimeServiceCatalogAdd` çağrılarıyla görünen çalışma zamanı servislerinden üretilmiştir. Servis, dil komutunun gerçek dünyada iş yaptırdığı kapıdır. Örneğin `PRINT` komutu sonuçta `RT_PRINT` ailesine, dosya işleri `RT_FILE_*` ailesine, dış çağrılar `RT_DLL_CALL` ve `RT_API_CALL` ailesine bağlanır.

| No | Servis | İmza | Hedefler |
| --- | --- | --- | --- |
| 1 | PRINT | VOID(ANY) | X64,JS,WASM,BROWSER |
| 2 | INPUT | STRING() | X64,JS,BROWSER |
| 3 | CLS | VOID() | X64,JS,WASM,BROWSER |
| 4 | COLOR | VOID(I32,I32) | X64,JS,BROWSER |
| 5 | LOCATE | VOID(I32,I32) | X64,JS,BROWSER |
| 6 | STR_LEN | I64(STRING) | X64,JS,WASM,BROWSER |
| 7 | STR_CONCAT | STRING(STRING,STRING) | X64,JS,WASM,BROWSER |
| 8 | STR_LEFT | STRING(STRING,I64) | X64,JS,WASM,BROWSER |
| 9 | STR_RIGHT | STRING(STRING,I64) | X64,JS,WASM,BROWSER |
| 10 | STR_MID | STRING(STRING,I64,I64) | X64,JS,WASM,BROWSER |
| 11 | STR_COMPARE | I64(STRING,STRING) | X64,JS,WASM,BROWSER |
| 12 | STR_TO_UPPER | STRING(STRING) | X64,JS,WASM,BROWSER |
| 13 | STR_TO_LOWER | STRING(STRING) | X64,JS,WASM,BROWSER |
| 14 | STR_TRIM | STRING(STRING) | X64,JS,WASM,BROWSER |
| 15 | STR_LTRIM | STRING(STRING) | X64,JS,WASM,BROWSER |
| 16 | STR_RTRIM | STRING(STRING) | X64,JS,WASM,BROWSER |
| 17 | STR_SPACE | STRING(I64) | X64,JS,WASM,BROWSER |
| 18 | STR_ASC | I64(STRING) | X64,JS,WASM,BROWSER |
| 19 | STR_CHR | STRING(I64) | X64,JS,WASM,BROWSER |
| 20 | STR_VAL | F64(STRING) | X64,JS,WASM,BROWSER |
| 21 | STR_STR | STRING(I64) | X64,JS,WASM,BROWSER |
| 22 | MATH_ABS | F64(F64) | X64,JS,WASM,BROWSER |
| 23 | MATH_SQRT | F64(F64) | X64,JS,WASM,BROWSER |
| 24 | MATH_SIN | F64(F64) | X64,JS,WASM,BROWSER |
| 25 | MATH_COS | F64(F64) | X64,JS,WASM,BROWSER |
| 26 | MATH_TAN | F64(F64) | X64,JS,WASM,BROWSER |
| 27 | MATH_ATN | F64(F64) | X64,JS,WASM,BROWSER |
| 28 | MATH_LOG | F64(F64) | X64,JS,WASM,BROWSER |
| 29 | MATH_EXP | F64(F64) | X64,JS,WASM,BROWSER |
| 30 | MATH_SGN | I64(F64) | X64,JS,WASM,BROWSER |
| 31 | MATH_FIX | F64(F64) | X64,JS,WASM,BROWSER |
| 32 | MATH_INT | F64(F64) | X64,JS,WASM,BROWSER |
| 33 | RANDOMIZE | VOID(I64) | X64,JS,WASM,BROWSER |
| 34 | RND | F64() | X64,JS,WASM,BROWSER |
| 35 | TIMER | F64() | X64,JS,WASM,BROWSER |
| 36 | PEEK | I64(I64) | X64,JS,WASM,BROWSER |
| 37 | POKE | VOID(I64,I64) | X64,JS,WASM,BROWSER |
| 38 | MEM_LOAD | I64(I64) | X64,JS,WASM,BROWSER |
| 39 | MEM_STORE | VOID(I64,I64) | X64,JS,WASM,BROWSER |
| 40 | MEM_COPY | VOID(I64,I64,I64) | X64,JS,WASM,BROWSER |
| 41 | MEM_FILL | VOID(I64,I64,I64) | X64,JS,WASM,BROWSER |
| 42 | FILE_OPEN | HANDLE(STRING,STRING) | X64 |
| 43 | FILE_CLOSE | VOID(HANDLE) | X64 |
| 44 | FILE_READ | STRING(HANDLE,I64) | X64 |
| 45 | FILE_WRITE | I64(HANDLE,STRING) | X64 |
| 46 | FILE_SEEK | I64(HANDLE,I64) | X64 |
| 47 | FILE_DELETE | I64(STRING) | X64 |
| 48 | FILE_EOF | I64(HANDLE) | X64 |
| 49 | FILE_LOF | I64(HANDLE) | X64 |
| 50 | DLL_LOAD | HANDLE(STRING) | X64 |
| 51 | DLL_CALL | ANY(STRING,STRING,ANY) | X64 |
| 52 | API_CALL | ANY(STRING,STRING,ANY) | X64 |
| 53 | INLINE_NATIVE | ANY(STRING) | X64 |
| 54 | LIBRARY_CALL | ANY(STRING,ANY) | X64,JS,WASM,BROWSER |
| 55 | JSON_CALL | ANY(STRING,ANY) | X64,JS,WASM,BROWSER |
| 56 | REGEX_CALL | ANY(STRING,STRING) | X64,JS,WASM,BROWSER |
| 57 | HTTP_CALL | ANY(STRING,ANY) | X64,JS,BROWSER |
| 58 | OS_CALL | ANY(STRING,ANY) | X64 |
| 59 | LLAMA_CALL | ANY(STRING,ANY) | X64 |
| 60 | LUA_CALL | ANY(STRING,ANY) | X64 |
| 61 | PROLOG_CALL | ANY(STRING,ANY) | X64 |
| 62 | SQLITE_CALL | ANY(STRING,ANY) | X64 |
| 63 | BROWSER_CANVAS | ANY(STRING,ANY) | JS,BROWSER |
| 64 | BROWSER_AUDIO | ANY(STRING,ANY) | JS,BROWSER |
| 65 | BROWSER_INPUT | ANY(STRING,ANY) | JS,BROWSER |
| 66 | BROWSER_FILE | ANY(STRING,ANY) | JS,BROWSER |
| 67 | BROWSER_FETCH | ANY(STRING,ANY) | JS,BROWSER |
| 68 | WEBGPU_CALL | ANY(STRING,ANY) | JS,BROWSER |
| 69 | WASM_IMPOCALL | ANY(STRING,ANY) | WASM,BROWSER |
| 70 | WASM_EXPOCALL | ANY(STRING,ANY) | WASM,BROWSER |
| 71 | HOST_CALL | ANY(STRING,ANY) | JS,WASM,BROWSER |
| 72 | EXTFP_CALL | ANY(STRING,ANY) | X64 |

Burada hedefler önemlidir. Bir servis `X64` yazıyorsa Windows yerel tarafta düşünülür. `JS` ve `BROWSER` yazıyorsa JavaScript/tarayıcı hedefinde çalışabilecek kapı vardır. `WASM` yazıyorsa WebAssembly tarafında sözleşme düşünülmüştür. Programcı komut yazarken hedefini baştan bilmelidir.

# 11. Kütüphane kayıtları

Kütüphane kayıt tablosunda modüller, çalışma zamanı uzantıları ve test aileleri görünür. Bu kayıtlar, uXBasic’in dış dünyaya nasıl büyüyeceğini gösterir.

| No | Modüller | Çalışma uzantısı | Test ailesi | Belge | Betik |
| --- | --- | --- | --- | --- | --- |
| 1 | uxaimath;uxtensor | uxaimath;uxtensor | uxaimath;uxtensor | 10 | 2 |
| 2 | uxcollections | uxcollections | uxcollections | 2 | 1 |
| 3 | uxdataframe | uxdataframe | uxdataframe | 5 | 1 |
| 4 | uxdataset | uxdataset | uxdataset | 5 | 1 |
| 5 | uxgraph | uxgraph | uxgraph | 3 | 1 |
| 6 | uxllama;uxllamax | uxllama | uxllama | 6 | 1 |
| 7 | uxmath | uxmath | uxmath | 3 | 1 |
| 8 | uxmath;uxmathcore | uxmathcore | uxmathcore | 2 | 1 |
| 9 | uxmatrix | uxmatrix | uxmatrix | 3 | 1 |
| 10 | uxnn2 | uxnn2 | uxnn2 | 4 | 1 |
| 11 | uxnn3 | uxnn3 | uxnn3 | 5 | 1 |
| 12 | uxaimath;uxnn;uxtensor | uxaimath;uxnn;uxtensor | uxaimath;uxnn;uxtensor | 15 | 3 |
| 13 | uxonnx2 | uxonnx2 | uxonnx2 | 5 | 1 |
| 14 | uxonnx | uxonnx | uxonnx | 5 | 1 |
| 15 | uxstats | uxstats2 | uxstats2 | 2 | 1 |
| 16 | uxstats | uxstats | uxstats | 2 | 1 |
| 17 | uxtensor | uxtensor | uxtensor | 5 | 1 |

Bu modül adlarını birer sözleşme gibi düşün. `uxstats` istatistik için, `uxllama` yerel yapay zeka için, `uxdataframe` tablo verisi için, `uxgraph` graf için, `uxonnx` model çalıştırmak için, `uxmatrix` matris için kapı adıdır. Bir modül adı tek başına mucize değildir. Önce DLL veya dış araç, sonra sarmalayıcı, sonra uXBasic alias, sonra test gerekir.

# 12. Komut satırı ve üretim hedefleri

| No | Seçenek | Görev |
| --- | --- | --- |
| 1 | --execmem --interpreter-backend AST | AST yorumlayıcıyla çalıştırır. |
| 2 | --execmem --interpreter-backend MIR | MIR yorumlayıcıyla çalıştırır. |
| 3 | --ast-json-out <yol> | AST JSON çıktısı üretir. |
| 4 | --hir-json-out <yol> | HIR JSON çıktısı üretir. |
| 5 | --mir-pipeline-json-out <yol> | MIR zincir raporu üretir. |
| 6 | --mir-opcodes-json-out <yol> | MIR işlem raporu üretir. |
| 7 | --artifact-report-json-out <yol> | Üretilen dosya raporu üretir. |
| 8 | --emit-x64-nasm --emit-x64-nasm-out <yol> | x64 NASM çıktısı üretir. |
| 9 | --codegen --codegen-source AST\|MIR | Kod üretimini AST veya MIR kaynağından seçer. |
| 10 | --build-x64 --build-x64-out <klasör> | x64 derleme akışını çalıştırır. |
| 11 | --interop | Dış bağlantı/kütüphane sözleşmelerini işler. |

Geliştirici için en önemli taktik şudur: aynı kaynak dosya için önce AST JSON, sonra HIR JSON, sonra MIR JSON, sonra hedef çıktı üret. Hata hangi katmanda çıkıyorsa orada dur. Derleyici geliştirmede rastgele düzeltme yapmak yerine katmanlı kanıt toplamak gerekir.

# 13. Dış kütüphane, DLL ve API kullanımı

Dış kütüphane çağırmak, programın kendi kodu dışında hazırlanmış işlevleri kullanmasıdır. Dinamik bağlantı kütüphanesi [Windows üzerinde çalışırken yüklenen ikili kütüphane] (DLL) çağırırken üç şey gerekir: kütüphane adı, sembol adı ve imza. İmza, gönderilen ve dönen tiplerin sözleşmesidir. Kaynakta `CALL(DLL, ...)` ve `CALL(API, ...)` yüzeyi vardır.

Genel sözde yazım:

```uxbasic
CALL(DLL, "KERNEL32.DLL", "GetTickCount", U64)
CALL(DLL, "USER32.DLL", "MessageBoxA", I32, STDCALL, 0, "Merhaba", "Baslik", 0)
```

Kod gerçekliği uyarısı: parser tarafında `CALL(DLL)` için en az kütüphane, sembol, imza ve argüman bekleyen doğrulama izleri vardır. İmza tokenları olarak `VOID`, `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`; çağrı düzeni olarak `CDECL`, `STDCALL` görülür. FFI imza ayrıştırıcı tarafında ayrıca `(I32,F64)->VOID` biçimli daha geniş imza metni desteği vardır. Geliştirici bu iki düzeyi tek sözleşmeye yaklaştırmalıdır.

DLL çağrısında üç altın kural vardır. Birincisi, mutlak yol verme; kütüphane adını güvenli tut. İkincisi, metin geçiriyorsan `STRPTR` mantığını bil. Üçüncüsü, `BYREF` kullanıyorsan gönderdiğin şey adreslenebilir değişken olmalı. Sabit ifadeye başvuru verilemez.

C, C++ ve ASM dosyası bağlama örneği:

```uxbasic
IMPORT(C, "native/hizli_hesap.c")
IMPORT(CPP, "native/matris.cpp")
IMPORT(ASM, "native/hizli_rutin.asm")

DECLARE FUNCTION HizliTopla(a AS I32, b AS I32) AS I32
PRINT HizliTopla(3, 4)
```

Burada `IMPORT` dosyayı projeye bildirir, `DECLARE FUNCTION` ise uXBasic tarafındaki imzayı bildirir. Derleyici zinciri gerçek bağlama yapacaksa build aşamasında C derleyici, C++ derleyici veya assembler çağırmalıdır. Kaynakta toolchain kapsamı olarak FreeBASIC, NASM, GCC ve G++ izleri görünür.

Ad alanı, modül, alias ve using örneği:

```uxbasic
NAMESPACE Matematik
    FUNCTION IkiKat(x AS I32) AS I32
        RETURN x * 2
    END FUNCTION
END NAMESPACE

USING Matematik
ALIAS IK = Matematik.IkiKat
PRINT IK(21)
```

Ad alanı [isim çakışmasını önleyen bölge] (namespace) büyük projede aynı adlı fonksiyonların kavga etmesini engeller. Modül [birlikte taşınan işlev grubu] (module) bir iş ailesini toparlar. Alias [kısa ad] uzun çağrıyı okunur kılar. Using [kullanıma açma] sık kullanılan ad alanını görünür yapar.

# 14. REST, curl, Flask, yerel yapay zeka ve uzak yapay zeka

Temsili durum: uXBasic çekirdeğinde her uzak servis için ayrı komut açmak yerine `HTTP`, `CURL`, `SERVER`, `LLAMA` gibi çalışma zamanı servisleri ve dış kütüphane sarmalayıcıları kullanılır. Bu daha temizdir. Dil şişmez; kütüphane büyür.

Yerel Flask API çağırma fikri:

```uxbasic
MODULE Ag
    DECLARE FUNCTION HttpPost(url AS STRING, body AS STRING) AS STRING
END MODULE

DIM cevap AS STRING
cevap = Ag.HttpPost("http://127.0.0.1:5000/tahmin", "{"x":42}")
PRINT cevap
```

Burada `HttpPost` gerçek uXBasic çekirdek komutu olmak zorunda değildir. Bir DLL, curl sarmalayıcısı, HTTP runtime servisi veya dış program köprüsü olabilir. Önemli olan uXBasic tarafında temiz imza tutmaktır: URL metin, gövde metin, cevap metin.

curl mantığı:

```uxbasic
MODULE Curl
    DECLARE FUNCTION PostJson(url AS STRING, json AS STRING) AS STRING
END MODULE

DIM sonuc AS STRING
sonuc = Curl.PostJson("http://127.0.0.1:8000/api", "{"soru":"merhaba"}")
PRINT sonuc
```

Yerel yapay zeka için `uxllama` ve `RT_LLAMA_CALL` aileleri düşünülür. Uzak yapay zeka için doğrudan özel ürün adıyla çekirdeğe komut eklemek yerine HTTP/REST kapısı kullanmak daha doğru olur. Böylece Google, başka bir bulut servisi veya kendi sunucun değişse bile uXBasic programı yalnız endpoint ve anahtar katmanını değiştirir.

Yerel model sarmalayıcı fikri:

```uxbasic
MODULE YerelZeka
    DECLARE FUNCTION Sor(model AS STRING, soru AS STRING) AS STRING
END MODULE

DIM yanit AS STRING
yanit = YerelZeka.Sor("yerel-model", "Bu veride aykiri deger var mi?")
PRINT yanit
```

İpucu: Yapay zeka çağrısını asla programın her satırına dağıtma. Bir `MODULE YerelZeka` aç, tüm çağrıları oradan geçir. Sonra hata kaydı, süre ölçümü, tekrar deneme ve anahtar saklama işlerini tek yerde çözersin.

# 15. Bilimsel veri, istatistik ve sahte değerlerle örnekler

Bilimsel program yazarken önce veri, sonra temizlik, sonra özet, sonra test gelir. Ortalama, varyans, standart sapma, z testi ve F testi gibi işlemler ezber formül değildir; verinin ne söylediğini ölçme yoludur.

Ortalama ve varyans örneği:

```uxbasic
DIM n AS I32
DIM i AS I32
DIM x(1 TO 5) AS F64
DIM toplam AS F64
DIM ort AS F64
DIM fark AS F64
DIM varyans AS F64

n = 5
x(1) = 10.2
x(2) = 11.1
x(3) = 9.8
x(4) = 10.9
x(5) = 10.5

toplam = 0
FOR i = 1 TO n
    toplam += x(i)
NEXT
ort = toplam / n

varyans = 0
FOR i = 1 TO n
    fark = x(i) - ort
    varyans += fark * fark
NEXT
varyans = varyans / (n - 1)
PRINT "Ortalama="; ort
PRINT "Varyans="; varyans
```

Z testi fikri: Bir örnek ortalaması bilinen toplum ortalamasından kaç standart hata uzakta?

```uxbasic
DIM ornekOrt AS F64
DIM toplumOrt AS F64
DIM sigma AS F64
DIM n AS F64
DIM z AS F64

ornekOrt = 10.50
toplumOrt = 10.00
sigma = 1.20
n = 25
z = (ornekOrt - toplumOrt) / (sigma / SQRT(n))
PRINT "Z degeri="; z
IF ABS(z) > 1.96 THEN
    PRINT "Yaklasik olarak %5 duzeyinde fark olabilir"
ELSE
    PRINT "Guclu fark gorunmuyor"
END IF
```

F testi fikri: İki grubun varyansları birbirinden çok farklı mı?

```uxbasic
DIM var1 AS F64
DIM var2 AS F64
DIM f AS F64
var1 = 2.40
var2 = 1.20
IF var1 >= var2 THEN
    f = var1 / var2
ELSE
    f = var2 / var1
END IF
PRINT "F orani="; f
IF f > 3.0 THEN
    PRINT "Varyanslar arasinda dikkat cekici fark olabilir"
ELSE
    PRINT "Varyans farki zayif gorunuyor"
END IF
```

Bu örneklerde kritik olan “p değeri hesabı” değil, akış mantığıdır. Gerçek istatistik modülü yazıldığında `uxstats` sarmalayıcısı F dağılımı, t dağılımı, z dağılımı, güven aralığı, ANOVA, korelasyon ve regresyon fonksiyonlarını taşımalıdır. Önce basit formülü elle yazmak programcıya ne yaptığını öğretir.

# 16. Tarayıcı, JavaScript, WebAssembly ve WebGPU hedefi

Tarayıcı hedefi, uXBasic programını web sayfasında çalıştırma fikridir. Kaynakta JavaScript üretici, tarayıcı bootstrap dosyaları, WebAssembly metin üretimi ve WebGPU servis adı görülür. Terimleri netleştirelim: JavaScript [tarayıcıların doğrudan çalıştırdığı dil] (JavaScript), WebAssembly [tarayıcıda düşük seviye ve hızlı ikili çalışma biçimi] (WebAssembly), WAT [WebAssembly metin biçimi] (WebAssembly Text), WebGPU [tarayıcıdan ekran kartına modern erişim] (WebGPU).

Tarayıcıya dönük örnek:

```uxbasic
PRINT "Tarayici konsoluna merhaba"
DIM x AS I32
x = 10
PRINT x * 2
```

Bu basit program JS çıktısına döndüğünde `program.js`, WAT çıktısına döndüğünde `program.wat`, tarayıcı kabuğuna döndüğünde `index.html` beklenir. ADIM22 raporunda bu dosyaların gerçek üretildiği görülmüştür. Ancak tarayıcıda gerçek çalışma için yol ayıracı, dosya yolu, wasm yükleme ve servis köprüleri ayrıca test edilmelidir.

# 17. Derleyici yazarken kullanılan zeki hileler

Bir derleyici projesinde en kötü alışkanlık “bir satır değiştirdim, oldu galiba” demektir. İyi alışkanlık “hangi katman kabul etti, hangi çıktı oluştu, hangi rapor temiz” demektir. uXBasic projesinin iyi tarafı kapı testleriyle düşünmesidir.

Bir özellik eklemek için cep sırası:

| Sıra | Kapı | Soru |
| --- | --- | --- |
| 1 | Anahtar kelime | Lexer kelimeyi tanıyor mu? |
| 2 | Parser | AST düğümü üretiliyor mu? |
| 3 | AST sözleşmesi | Düğümün çocuk rolleri ve alanları doğru mu? |
| 4 | Semantic/type | Değişken, kapsam, tip, sınıf ve hata mantığı doğru mu? |
| 5 | HIR/layout | Kayıt/sınıf/bellek düzeni gerekiyorsa çıkıyor mu? |
| 6 | MIR | Komut ara dile iniyor mu? |
| 7 | MIR doğrulama | Geçersiz etiket, eksik operand, bozuk tip yakalanıyor mu? |
| 8 | Runtime | Çalışma zamanı servisi var mı? |
| 9 | Backend | JS/WASM/x64 hedefleri destekliyor mu veya açıkça reddediyor mu? |
| 10 | Test | Pozitif ve negatif test var mı? |

Kanca [belirli akış noktasında kayıt alma veya ek davranış] (hook) doğru kullanılırsa izleme aracıdır; yanlış kullanılırsa mimariyi sakatlar. Kanca, çekirdek davranışı değiştirmemeli; olayı kaydetmeli veya dışarıya haber vermelidir. Sarmalayıcı [var olan kodu temiz arayüzle çağıran katman] (wrapper) ise kirli dış dünyayı temiz uXBasic imzasına çevirir. Örneğin curl karmaşık olabilir ama uXBasic tarafında `Curl.PostJson(url, body)` sade görünmelidir.

Çıktı sözleşmesi hilesi: Test runner eksik dosyayı uydurmamalıdır. Derleyici dosyayı üretmiyorsa test kalmalıdır. Eski placeholder yaklaşımı kolay PASS verir ama programcıyı kandırır. Gerçek kalite, “dosya gerçekten var mı, içeriği gerçek mi, JSON bozuk mu, hedef kod çalışıyor mu” sorularından geçer.

Kaynak eşleme [üretilen hatayı kaynak satıra bağlama] (source mapping) genç programcının dostudur. Hata “MIR kırıldı” demek yerine “şu dosya, şu satır, şu komut” demelidir. Büyük projede hata mesajı ne kadar iyi ise geliştirme o kadar hızlıdır.

# 18. Hata yakalama ve test disiplini

uXBasic programcısı hem kendi programını hem derleyiciyi test eder. Pozitif test “çalışması gereken çalışıyor mu?” sorusudur. Negatif test “hata vermesi gereken hata veriyor mu?” sorusudur. Sadece pozitif test yazmak yarım iştir.

uXBasic tarafında hata yakalama örneği:

```uxbasic
TRY
    OPEN "veri.txt" FOR INPUT AS #1
    PRINT "Dosya acildi"
CATCH hata
    PRINT "Dosya acilamadi"
FINALLY
    CLOSE #1
END TRY
```

Derleyici geliştirirken test sırası:

```powershell
rg -n "GENERATED_PLACEHOLDER|placeholder|ensure_declared_outputs" uxb/tools/control
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim25_26_27_close_gates.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim28_build_test_pipeline.ps1 -NoRepair
```

Bu komutlar programın dili değildir; geliştiricinin kontrol aracıdır. Ama cep kitabında bulunmalıdır çünkü uXBasic gibi çok katmanlı projede “ben çalıştı sanıyorum” yerine “kapı geçti” demek gerekir.

# 19. Örnek mini proje: veri dosyasından özet rapor

```uxbasic
%%DEFINE DEBUG 1

CONST N AS I32 = 5
DIM i AS I32
DIM x(1 TO N) AS F64
DIM toplam AS F64
DIM ort AS F64
DIM enbuyuk AS F64

x(1) = 12.1
x(2) = 11.8
x(3) = 12.5
x(4) = 10.9
x(5) = 12.0

toplam = 0
enbuyuk = x(1)
FOR i = 1 TO N
    toplam += x(i)
    IF x(i) > enbuyuk THEN
        enbuyuk = x(i)
    END IF
NEXT
ort = toplam / N

OPEN "ozet.txt" FOR OUTPUT AS #1
PUT #1, 1, "Ortalama=" + STR(ort)
CLOSE #1

PRINT "Ortalama="; ort
PRINT "En buyuk="; enbuyuk
%%IF DEBUG
PRINT "DEBUG: N="; N
%%ENDIF
```

Bu programda ön-işleyici, sabit, dizi, döngü, karar, dosya yazma, metne çevirme ve yazdırma birlikte kullanılır. Programın amacı basittir: beş ölçümü özetlemek ve rapor dosyasına yazmak. Küçük görünen bu yapı, gerçek bilimsel programların çekirdeğidir.

# 20. uXBasic geliştiricisine son tavsiyeler

Bir: Dil çekirdeğini gereksiz büyütme. Her yeni dış iş için yeni anahtar kelime açmak yerine `MODULE`, `NAMESPACE`, `ALIAS`, `USING`, `CALL`, `IMPORT`, `DECLARE` ve çalışma zamanı servislerini kullan. Böylece dil sade kalır, kütüphane büyür.

İki: Güvenliği her yere yayma; doğru yere koy. DLL yolu, include yolu, bellek sınırı, dış çağrı imzası ve çıktı sözleşmesi güvenlik için doğru noktalardır. Her satıra korku koyarsan dil programcıyı boğar. Hiç kontrol koymazsan sistem çöker.

Üç: OOP [nesne yönelimli programlama] (object-oriented programming) geniş olmalı ama tutarlı olmalı. `CLASS`, `INTERFACE`, `METHOD`, `PROPERTY`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE`, `ABSTRACT`, `FINAL`, `SEALED` gibi yüzeyler ancak semantic, layout, MIR ve backend tarafında gerçek karşılık bulursa değerlidir.

Dört: Floating point [kesirli sayı hesabı] (floating point) için çekirdek küçük kalabilir; `F80`, `F128`, `BIGF`, `BIGD`, `BALL` gibi ağır işler dış DLL ile taşınabilir. Bu doğru mimaridir çünkü büyük sayı işi özel ve ağırdır.

Beş: Her yeni servis için test klasöründe yalnız o aşamanın geniş testlerini tut. Eski testleri yeni pakete tekrar doldurma. Yeni komut için tek tek test ve en az iki birleşik kullanım testi yaz.

Altı: Genç programcıya en değerli bilgi şudur: Bir programı çalıştırmak başka, bir sistemi doğru çalıştırmak başkadır. uXBasic gibi bir projede gerçek başarı, komutun lexer’dan başlayıp hedef çıktıya kadar dürüstçe izlenebilmesidir.


---

## Cep özeti

- Önce küçük program yaz: `PRINT`, `DIM`, `IF`, `FOR`.
- Sonra fonksiyon yaz: `FUNCTION`, `SUB`, `RETURN`.
- Sonra dosya kullan: `OPEN`, `PUT`, `GET`, `CLOSE`.
- Sonra tipleri ciddiye al: `I32`, `U64`, `F64`, `STRING`, `PTR`.
- Sonra dış dünyaya çık: `DECLARE`, `IMPORT`, `CALL(DLL)`, `CALL(API)`.
- Sonra katmanı izle: AST, HIR, MIR, runtime, backend.
- Sonra test yaz: pozitif, negatif, çıktı sözleşmesi.


Bu cep kitabını okuyan biri uXBasic’i yalnız “BASIC benzeri komutlar” diye değil, katmanlı ve büyütülebilir bir sistem programlama aracı olarak görmelidir.
