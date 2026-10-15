# uXBasic Profesyonel Kullanma Kılavuzu
## src1, INLINE Native Contract ve Uygulamalı Laboratuvar Baskısı - 23 Temmuz 2026

**Hedef okuyucu:** 16-25 yaş aralığında programlamaya ilk kez başlayan, ancak zamanla uXBasic ile orta ve ileri düzey uygulama, sistem programlama, veri analizi, yapay zeka ve derleyici araçları geliştirmek isteyen öğrenci.

**Ana hedef:** Okuyucunun yalnız komut ezberlemesi değil; bir uXBasic programının preprocessor, lexer, parser, AST, semantic, MIR, interpreter ve hedef backend katmanlarında nasıl ilerlediğini öğrenmesi.

---

# Kaynak Dayanağı ve Bu Baskının Sözleşmesi

Bu kılavuz aşağıdaki malzemelerin birleştirilmiş sürümüdür:

- `src1.zip`: güncel derleyici kaynak ağacı;
- `uxb(11.07)(1).zip`: PCK/teknik kitap, testler, standart kütüphaneler ve CLI belgeleri;
- önceki kaynak-gerçekliği düzeltilmiş kullanım kılavuzu;
- `Yapıştırılan metin(120).txt`: son hata düzeltmeleri, test kapıları, FFI, TRY/CATCH, kütüphaneler ve backend değişiklikleri;
- `INLINE_IMPLEMENTATION.md`: dört alanlı INLINE sözleşmesinin son hali;
- `UXB_SRC1_INLINE_CONTRACT_FULL_20260721.zip`: INLINE değişiklikleri uygulanmış kaynak ağacı.

Bu baskıda şu kararlar kesindir:

1. Yerel üretim hedefi Windows 11 x64'tür. x86 eski/kapalı hedef olarak yalnız tarihsel seçeneklerde görülebilir.
2. AST interpreter ve MIR interpreter, geliştirme ve karşılaştırmalı test yollarıdır.
3. x64 backend NASM/obj/link zinciriyle gerçek EXE üretir.
4. JavaScript, WAT, WASM ve browser hedefleri native-only komutları sessizce taklit etmez; uygun hedef kapısı uygular.
5. `AND`/`OR` eager bit/mantık işlemleridir; `ANDALSO`/`ORELSE` ve `&&`/`||` kısa devrelidir.
6. `U8(...)`, `I8(...)`, `U16(...)`, `I16(...)`, `U32(...)`, `I32(...)`, `U64(...)`, `I64(...)`, `F32(...)`, `F64(...)`, `BOOLEAN(...)` ve `PTR(...)` yerleşik açık tip dönüştürücüleridir.
7. `METHOD ... END METHOD`, `SUB ... END SUB`, `FUNCTION ... END FUNCTION` ve `MAGIC ... END MAGIC` birbirine karıştırılmaz.
8. Değişken adlarında `$` ve `%` son ekleri kullanılmaz. `#` yalnız `PRINT #` ve `INPUT #` dosya kanalı biçimlerinde özel anlam taşır.
9. `CALL(DLL,...)`, `CALL(API,...)` ve normal `CALL` farklı çağrı rotalarıdır; FFI10 en fazla on argümanlı açık ABI sözleşmesidir.
10. `EVENT`, `THREAD`, `PIPE`, `PARALEL`, `SLOT`, `ON`, `OFF` ve `TRIGGER` compiler/runtime DLL sisteminin parçasıdır.
11. INLINE dört alanlı başlığı korur: `(arch, language, kind, policy)`.

---

# Kitabı Nasıl Kullanmalısın?

İlk defa programlama öğreniyorsan önce Bölüm 1-9 arasını sırayla oku. Her örneği çalıştır, sonra tek bir satırını değiştir. Orta seviyeye geldiğinde TYPE, CLASS, dosya, koleksiyon, hata yönetimi ve modüler yapı bölümlerine geç. İleri seviyede FFI10, pointer/bellek, INLINE, event/thread/pipe, kütüphaneler, AST/MIR ve CLI raporlarını kullan.

| Seviye | Öğrenilecek alan | Üretilecek proje |
| --- | --- | --- |
| Başlangıç | Değişken, tip, PRINT, INPUT, IF, FOR | Hesap makinesi, not sistemi |
| Orta | Fonksiyon, dizi, TYPE, dosya, hata yönetimi | Stok ve ölçüm takip programı |
| İleri | CLASS, MAGIC, koleksiyon, FFI, SHELL | Modüler masaüstü/CLI aracı |
| Profesyonel | AST/MIR, x64, JS/WASM, INLINE, DLL, test kapıları | Derleyici eklentisi, veri bilimi ve yapay zeka sistemi |

---

# Bölüm 1 - İlk Program ve Derleyici Mimarisi

```uxbasic
MAIN
    PRINT "Merhaba uXBasic"

    DIM yas AS I32
    INPUT yas

    IF yas >= 18 THEN
        PRINT "Orta ve ileri seviye projelere gecebilirsin."
    ELSE
        PRINT "Kucuk programlarla basla ve her gun test yaz."
    END IF
END MAIN
```

Programın kaynak yolculuğu:

```text
Kaynak (.uxb/.bas)
  -> Preprocessor A/B
  -> Lexer (token)
  -> Parser (AST)
  -> Semantic ve tip bağlama
  -> HIR/MIR
  -> AST interpreter / MIR interpreter / x64 / JS / WAT-WASM / browser
```

## Dosya uzantıları

| Uzantı | Görev |
| --- | --- |
| .uxb | ana uXBasic programı |
| .bas | BASIC uyumlu kaynak ve test |
| .uxbh / .uxmh | başlık veya modül metni |
| .uxcli | toplu CLI komut dosyası |
| .c / .cpp / .asm / .s | IMPORT veya INLINE yan kaynakları |
| .asm | compiler tarafından üretilen x64 NASM |
| .js | JavaScript çıktısı |
| .wat / .wasm | WebAssembly metin/ikili çıktısı |
| .json / .csv | tanı, rapor, manifest ve test kanıtları |

## En önemli CLI fiilleri

| Fiil | Görev | Örnek |
| --- | --- | --- |
| lex | Lexer/token çıktısı | uxb lex kaynak.uxb --json-out token.json |
| par | yalnız parser/syntax | uxb par kaynak.uxb --json-out parser.json |
| ast | AST ve sözleşme | uxb ast kaynak.uxb --json-out ast.json |
| sem | semantic/tip bağlama | uxb sem kaynak.uxb --json-out sem.json |
| hir | HIR envanteri | uxb hir kaynak.uxb --json-out hir.json |
| mir | MIR üretim/doğrulama | uxb mir kaynak.uxb --json-out mir.json |
| int | interpreter çalıştırma | uxb int kaynak.uxb |
| x64 | x64 NASM üretimi | uxb x64 kaynak.uxb --emit-x64-nasm-out program.asm |
| jsw | JavaScript üretimi | uxb jsw kaynak.uxb --js-out program.js |
| wat | WAT/WASM metni | uxb wat kaynak.uxb --wat-out program.wat |
| bld | tam x64 build | uxb bld kaynak.uxb --build-x64-out build |
| run | programı yorumlayıcıda çalıştırır | uxb run kaynak.uxb |
| chk | toplu doğrulama | uxb chk kaynak.uxb --json-out validate.json |
| fmt | biçim kontrolü | uxb fmt kaynak.uxb |
| map | source map | uxb map kaynak.uxb --json-out map.json |
| doc | dokümantasyon çıktısı | uxb doc kaynak.uxb --json-out doc.json |
| rel | release gate | uxb rel kaynak.uxb --json-out release.json |
| hlp | yardım | uxb hlp |
| ver | sürüm | uxb ver |

---

# Bölüm 2 - Dilin Temel Yazım Kuralları

- Anahtar sözcükler büyük/küçük harfe duyarsızdır; kitapta okunabilirlik için büyük harf yazılır.
- Her ifade ayrı satırda yazılabilir. Bloklar açık kapanış sözcükleri kullanır.
- Yorum satırı tek tırnak (`'`) ile başlar.
- Atama `=` ile yapılır. Eşitlik karşılaştırması genel ifadede `==` veya karşılaştırma bağlamına göre `=` sözleşmesiyle ele alınır; yeni kodda açık `==` tercih edilir.
- Boolean doğru değeri `-1`, yanlış değeri `0`'dır.
- Değişken son ekleri `$`, `%` kullanılmaz; tip `AS` ile yazılır.

```uxbasic
DIM sayac AS I32
DIM oran AS F64
DIM ad AS STRING
DIM hazir AS BOOLEAN

sayac = 10
oran = F64(sayac) / 3.0
ad = "Mete"
hazir = TRUE
```

---

# Bölüm 3 - Veri Tipleri ve Açık Tip Dönüştürücüleri

## Çekirdek scalar tipler

| Tip | Anlam | Yaklaşık genişlik | Örnek |
| --- | --- | --- | --- |
| BOOLEAN | BASIC mantıksal değer: FALSE=0, TRUE=-1 | compiler mantık slotu | DIM ok AS BOOLEAN |
| I8 / U8 | işaretli/işaretsiz 8 bit tam sayı | 1 bayt | DIM b AS U8 |
| I16 / U16 | 16 bit tam sayı | 2 bayt | DIM s AS I16 |
| I32 / U32 | 32 bit tam sayı | 4 bayt | DIM n AS I32 |
| I64 / U64 | 64 bit tam sayı | 8 bayt | DIM big AS U64 |
| F32 | tek duyarlıklı kayan nokta | 4 bayt | DIM x AS F32 |
| F64 | çift duyarlıklı kayan nokta | 8 bayt | DIM x AS F64 |
| F80 / F128 | geniş duyarlıklı sayı; harici runtime politikasıyla | runtime/ABI bağımlı | DIM hp AS F80 |
| BIGI / BIGINT | çok büyük tam sayı | handle/runtime | BIGINIT("BIGI", "...") |
| BIGF / BIGD / BALL | yüksek duyarlık veya aralık sayısı | harici runtime | BIGINIT("BIGF", "3.14") |
| STRING | metin | runtime string | DIM s AS STRING |
| PTR / STRPTR | ham adres veya metin adresi | x64 üzerinde 8 bayt | DIM p AS PTR |
| OBJECT | genel nesne başvurusu | referans | DIM o AS OBJECT |

## Fonksiyon biçimli tip belirteçleri

Bu biçimler resmî dil özelliğidir:

```uxbasic
DIM b AS U8
DIM n AS I32
DIM x AS F64

b = U8(300)       ' alt 8 bit: 44
n = I32(x)
x = F64(n)
```

| Dönüştürücü | Temel görev |
| --- | --- |
| BOOLEAN(x) | 0 değerini FALSE, diğer değerleri TRUE (-1) yapar |
| I8(x) / U8(x) | 8 bit signed/unsigned dönüştürür |
| I16(x) / U16(x) | 16 bit signed/unsigned dönüştürür |
| I32(x) / U32(x) | 32 bit signed/unsigned dönüştürür |
| I64(x) / U64(x) | 64 bit signed/unsigned dönüştürür |
| F32(x) | tek duyarlığa dönüştürür |
| F64(x) | çift duyarlığa dönüştürür |
| PTR(x) | native pointer/adres değerine dönüştürür |

Açık dönüşüm ile normal sabit ataması farklıdır: `b = 128` hedef aralığına göre denetlenebilir; `b = U8(300)` programcının bilinçli bit daraltmasıdır.

---

# Bölüm 4 - Değişkenler, Diziler ve Koleksiyonlar

```uxbasic
DIM sicaklik AS F64
CONST DONMA_NOKTASI AS F64 = 0.0
DIM olcumler(9) AS F64
REDIM olcumler(99) AS F64
```

Koleksiyon tipleri:

- `ARRAY`: sabit veya yeniden boyutlandırılabilir indeksli dizi;
- `LIST`: sıralı, büyüyebilen liste;
- `DICT`: metin anahtarlı sözlük;
- `SET`: benzersiz öğeler kümesi;
- standart `uxcollections` kütüphanesi: list, stack, queue, dict, set ve tree handle'ları.

---

# Bölüm 5 - Operatörler

| Aile | Operatörler | Açıklama |
| --- | --- | --- |
| Aritmetik | + - * / \ MOD ** | toplama, çıkarma, çarpma, bölme, tamsayı bölme, kalan ve üs |
| Karşılaştırma | == <> != < <= > >= | sonuç TRUE (-1) veya FALSE (0) |
| Kısa devre | ANDALSO, ORELSE, &&, \|\| | sağ taraf yalnız gerekirse çalışır |
| Bit/mantık | AND, OR, XOR, ^, NOT, BNOT | eager bit düzeyi veya Boolean bit işlemleri; `^` XOR aliasıdır |
| Kaydırma | SHL, SHR, <<, >> | bitleri sola/sağa kaydırır |
| Döndürme | ROL, ROR | çıkan biti diğer uçtan geri sokar |
| Logic16 | NAND NOR XNOR NXOR EQV EQA IFF IMP CIMP NIMP NCIMP IDA IDB NOTA NOTB | tam genişlikli mantık/bit formülleri |
| Bileşik atama | += -= *= /= \= MOD= <<= >>= AND= OR= XOR= ROL= ROR= | işlemi aynı değişkene yazar |
| Artırma/azaltma | INC DEC ++ -- | değeri bir artırır veya azaltır |

`ROL=` ve `ROR=` örneği:

```uxbasic
DIM mask AS U8
mask = U8(129)       ' 10000001
mask ROL= 1          ' 00000011 -> 3
mask ROR= 1          ' 10000001 -> 129
```

---

# Bölüm 6 - Akış Kontrolü ve Hata Yönetimi

```uxbasic
IF puan >= 85 THEN
    PRINT "AA"
ELSEIF puan >= 70 THEN
    PRINT "BB"
ELSE
    PRINT "Daha fazla calis"
END IF
```

Döngüler: `FOR ... TO ... STEP ... NEXT`, `FOR EACH ... IN`, `WHILE ... WEND`, `DO ... LOOP`, `DO WHILE`, `DO UNTIL`, `EXIT`, `CONTINUE`.

## TRY/CATCH/FINALLY ve __ERR_* bağlamı

```uxbasic
TRY
    THROW 404
CATCH err
    PRINT __ERR_CODE
    PRINT __ERR_KIND
    PRINT __ERR_MESSAGE
FINALLY
    PRINT "Temizlik her durumda calisir"
END TRY
```

`__ERR_THROWN`, `__ERR_CODE`, `__ERR_LINE`, `__ERR_COL`, `__ERR_VALUE`, `__ERR_IS_STRING`, `__ERR_KIND`, `__ERR_MESSAGE`, `__ERR_ROUTINE`, `__ERR_VALUE_TYPE` ve `__ERR_VALUE_TEXT` yakalanan hatanın ayrıntılarını taşır. Bunlar aktif hata çerçevesine ait özel sistem alanlarıdır; kullanıcı değişkeni olarak yeniden bildirilmemelidir.

---

# Bölüm 7 - Yordamlar, Modüller ve Nesne Yönelimli Programlama

```uxbasic
FUNCTION Topla(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

SUB Yazdir(x AS I32)
    PRINT x
END SUB
```

Blok sözleşmeleri:

```text
METHOD ... END METHOD
SUB ... END SUB
FUNCTION ... END FUNCTION
MAGIC ... END MAGIC
```

```uxbasic
CLASS Sayac
    PRIVATE value AS I32

    CONSTRUCTOR(start AS I32)
        value = start
    END CONSTRUCTOR

    METHOD Artir()
        value += 1
    END METHOD

    METHOD Deger() AS I32
        RETURN value
    END METHOD

    MAGIC TOSTRING() AS STRING
        RETURN STR(value)
    END MAGIC
END CLASS
```

---

# Bölüm 8 - Dosya, Konsol ve SHELL

```uxbasic
OPEN "olcum.txt" FOR OUTPUT AS #1
PRINT #1, "pH=7.2"
CLOSE #1

OPEN "olcum.txt" FOR INPUT AS #1
DIM satir AS STRING
INPUT #1, satir
CLOSE #1
PRINT satir
```

`#` burada değişken son eki değil, dosya kanalı işaretidir.

SHELL örneği:

```uxbasic
DIM outText AS STRING
DIM errText AS STRING
DIM exitCode AS I32

SHELL "python --version" TIMEOUT 10 OUTVAR outText ERRVAR errText CODEVAR exitCode
PRINT outText
PRINT exitCode
```

Native-only dış süreç özellikleri JS/WASM hedefinde açıkça reddedilir.

---

# Bölüm 9 - Bellek, Pointer ve Düşük Seviye İşlemler

```uxbasic
DIM x AS I32
DIM p AS PTR

x = 123
p = VARPTR(x)
PRINT p
PRINT PEEKD(p)
POKED p, 456
ASSERT x = 456
```

Bellek komutları `PEEKB/PEEKW/PEEKD`, `POKE/POKEB/POKEW/POKED/POKES`, `MEMCOPYB/W/D`, `MEMFILLB/W/D`, `SETNEWOFFSET`, `SIZEOF`, `OFFSETOF`, `VARPTR`, `SADD`, `LPTR`, `CODEPTR` aileleridir. Yanlış adres programı çökertir veya belleği bozar; sınır kontrolü programcı sorumluluğundadır.

---

# Bölüm 10 - INCLUDE, IMPORT, DECLARE, CALL ve FFI10

- `INCLUDE "dosya.uxmh"`: uXBasic metnini kaynakta birleştirir.
- `IMPORT(C, "dosya.c")`, `IMPORT(CPP, "dosya.cpp")`, `IMPORT(ASM, "dosya.asm")`: dış kaynak dosyasını object/link planına alır.
- `DECLARE FUNCTION ... LIB ... ALIAS ...`: dış fonksiyon imzası bildirir.
- `CALL(...)`: normal yordam çağrısı.
- `CALL(DLL,...)`: dinamik DLL sembol çağrısı.
- `CALL(API,...)`: runtime API/servis çağrısı.

FFI10, dönüş tipi, çağrı kuralı ve en fazla on argümanın türünü açıkça taşır. Eksik DLL veya sembol sessiz sıfır döndürmemeli; x64 fail-close yolu hata mesajı ve sıfır olmayan dönüş kodu üretmelidir.

## Allowlist ve REPORT_ONLY

Allowlist, çağrılmasına izin verilen DLL/sembolleri tanımlar. `REPORT_ONLY` çağrıyı çalıştırmadan ABI planı üretmek için teşhis modudur. Üretim çalıştırmasında allowlist zorunluysa dosya eksikliği otomatik başarıya dönmemeli; açık yapılandırma hatası vermelidir.

---

# Bölüm 11 - EVENT, THREAD, PIPE, PARALEL, SLOT, ON, OFF, TRIGGER

```uxbasic
EVENT Alarm()
    PRINT "ALARM"
END EVENT

ON EVENT Alarm SLOT U8(1)
TRIGGER EVENT SLOT U8(1)
OFF EVENT SLOT U8(1)
```

`PIPE` girdili görev akışı kurar; `THREAD` ve `PARALEL` görev türlerini belirtir. Bu yüzeyler compiler içindeki görev tablosu ve dağıtımla gelen native runtime DLL'leriyle çalışır. Slot aralığı ve görev türü semantic aşamada denetlenir.

---

# Bölüm 12 - INLINE Native Contract

INLINE başlığı dört alanlıdır:

```uxbasic
INLINE (arch, language, kind, "policy")
    native body
END INLINE
```

Kanonik değerler:

- `arch`: `X64` (`AMD64`, `X86_64` alias);
- `language`: `NASM`, `MASM`, `GAS`, `C`, `CPP`;
- `kind`: `SUB`, `FUNCTION`, `PROC`.

Temel politika anahtarları:

```text
NAME, ABI, IN, OUT, RET, RESULT,
PRESERVE, CLOBBER, STACK, SHADOW, VISIBILITY,
CC, CXX, ASM, MASM, LINK ve *_PATH / *FLAGS alanları
```

```uxbasic
DIM a AS I32
DIM b AS I32
DIM result AS I32

a = 10
b = 32

INLINE (X64, NASM, FUNCTION, "NAME=FastAdd;ABI=WIN64;IN=a:I32,b:I32;RET=I32;RESULT=result;PRESERVE=AUTO;CLOBBER=RAX,FLAGS;STACK=16")
    mov rax, __UXB_a
    add rax, __UXB_b
END INLINE

ASSERT result = 42
```

INLINE statement konumunda çalışır. `FUNCTION` için `RET` ve `RESULT`, `SUB` için `RET=VOID`, `OUT` için BYREF yazım kuralları geçerlidir. İlk dört Win64 argümanı RCX/RDX/R8/R9 veya XMM0-XMM3 üzerinden bağlanır. `STRING` doğrudan native ABI parametresi olarak kullanılmaz; `STRPTR` ve açık uzunluk tercih edilir.

AST/MIR interpreter INLINE'ı noop saymaz; native unsupported/fail-close üretir. Gerçek yürütme x64 build/link hattındadır.

---

# Bölüm 13 - AST, MIR, x64, JavaScript ve WebAssembly

| Yol | Amaç |
| --- | --- |
| AST interpreter | kaynak anlamını hızlı çalıştırma ve hata ayıklama |
| MIR interpreter | lower edilmiş ara temsili doğrulama |
| x64 NASM | Windows 11 için native EXE üretme |
| JavaScript | Node/browser hedefi |
| WAT/WASM | WebAssembly metin ve ikili hedefi |
| Browser paketi | JS/HTML/manifest ve asset üretimi |

Native DLL, SHELL, ham pointer ve INLINE gibi yüzeyler web hedefinde aynı şekilde çalıştırılmaz; host import veya fail-close sözleşmesi gerekir.

---

# Bölüm 14 - Öğrenme Projeleri

1. Not ve puan sınıflandırıcı.
2. Su sıcaklığı/pH ölçüm takip sistemi.
3. Dosyaya yazan stok ve maliyet uygulaması.
4. TYPE ile kayıt, CLASS ile davranış ekleyen ölçüm sistemi.
5. LIST/DICT/SET kullanan veri yöneticisi.
6. TRY/CATCH kullanan güvenli dosya okuyucu.
7. kernel32.dll üzerinden FFI10 örneği.
8. EVENT/PIPE/SLOT tabanlı görev sistemi.
9. JS/WASM hedefli tarayıcı oyunu.
10. INLINE NASM/C/CPP ile hızlandırılmış hesaplama.

---

# Bölüm 15 - Temel Komut Referansı: Yazdırma, Değişken ve Giriş/Çıkış

uXBasic öğrenirken ilk görülen komutlar basit görünür; fakat kitabın dili açısından en önemli komutlar bunlardır. Çünkü okuyucu ilk defa kaynak kodun neye dönüştüğünü, değişkenin nasıl ad aldığını, değerin nasıl saklandığını ve sonucun nasıl gözlemlendiğini burada öğrenir. `PRINT`, `DIM`, `AS`, `CONST`, `INPUT`, `CLS`, `COLOR`, `LOCATE`, `INKEY` ve `GETKEY` yalnız başlangıç komutları değildir; bütün daha büyük örneklerin taşıyıcı kolonlarıdır.

Bu bölümde her komut önce tek başına tanıtılır, sonra kendinden önce ve sonra gelen komutlarla birlikte kullanılır. Böylece okuyucu bir komutu ezberlemek yerine, o komutun program akışı içindeki yerini görür.

## PRINT

`PRINT`, bir ifadeyi görünür çıktı hâline getirir. Bu çıktı konsolda görülebilir, dosya kanalına yazılabilir veya hedefe göre runtime çıktı servisine bağlanabilir. Programcı açısından `PRINT`, sonucu görmenin en kısa yoludur. Derleyici açısından ise ifade çözümleme, tip dönüştürme ve çıktı rotasına bağlanma noktasıdır.

Syntax:

```basic
PRINT ifade
PRINT "metin"
PRINT degisken
PRINT #kanal, ifade
```

Temel örnek:

```basic
PRINT "uXBasic calisiyor"
```

Beklenen çıktı:

```text
uXBasic calisiyor
```

`PRINT` tek başına kullanıldığında yalnızca sabit metni gösterir. Bir değişkenle kullanıldığında programın iç durumunu dışarı çıkarır:

```basic
DIM puan AS I32 = 70
PRINT puan
```

Beklenen çıktı:

```text
70
```

Bir hesap ifadesiyle birlikte kullanıldığında `PRINT`, sonucu ayrıca değişkene almadan gözlemlemeyi sağlar:

```basic
DIM yem AS I32 = 120
DIM balik AS I32 = 40
PRINT yem / balik
```

Beklenen çıktı:

```text
3
```

Bu örnek, `DIM`, `AS`, bölme operatörü ve `PRINT` komutunu aynı anda çalıştırır. Kitap boyunca bir komutun en küçük örneği verildikten sonra, hemen böyle birleşik bir örneğe geçilir.

## DIM ve AS

`DIM`, bellekte isimli alan açar. `AS`, bu alanın tipini bağlar. Bu ikisi birlikte kullanıldığında derleyici değişkenin adını, türünü ve kapsamını bilir. Bu bilgi semantic denetim için gereklidir; MIR ve hedef kod üretimi de bu tip bilgisinden yararlanır.

Syntax:

```basic
DIM ad AS tip
DIM ad AS tip = ilkDeger
DIM ad(boyut) AS tip
```

Temel örnek:

```basic
DIM sayi AS I32 = 30
PRINT sayi
```

Beklenen çıktı:

```text
30
```

Dizi örneği:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

PRINT sicaklik(1)
PRINT sicaklik(2)
PRINT sicaklik(3)
```

Beklenen çıktı:

```text
18
21
19
```

Bu kod, üç ayrı değişken açmak yerine tek bir dizi adı altında üç ölçüm saklar. Daha sonra `FOR` döngüsü öğrenildiğinde aynı dizi tek tek yazdırılmak yerine döngüyle gezilir:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)
NEXT i

PRINT toplam
```

Beklenen çıktı:

```text
58
```

`DIM` böylece yalnız değişken tanımlama komutu değildir; dizi, kayıt, nesne, fonksiyon içi yerel değer ve hesap akışı kurmanın başlangıç noktasıdır.

## CONST

`CONST`, program boyunca değişmeyecek değeri adlandırır. Bu değer bir sınır, katsayı, ayar veya sabit mesaj olabilir. `CONST` kullanıldığında okuyucu ve derleyici bu adın normal değişken gibi değiştirilmemesi gerektiğini bilir.

Syntax:

```basic
CONST ad AS tip = deger
```

Örnek:

```basic
CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

IF okuma < LIMIT THEN
    PRINT "Guvenli"
ELSE
    PRINT "Limit asildi"
END IF
```

Beklenen çıktı:

```text
Guvenli
```

Bu örnekte `LIMIT` sıradan bir sayı olarak yazılabilirdi; fakat sabit adı programın niyetini açıklar. Genç programcı için önemli ders şudur: kod yalnız makineye değil, gelecekte o kodu okuyacak insana da yazılır.

## INPUT

`INPUT`, kullanıcıdan veya dosya kanalından değer alır. Konsol kullanımında programı dış dünyadan gelen veriyle buluşturur. Dosya kanalında `INPUT #` biçimiyle kullanıldığında okuma rotası dosyaya bağlanır.

Syntax:

```basic
INPUT degisken
INPUT #kanal, degisken
```

Konsol mantığı:

```basic
DIM yas AS I32
INPUT yas
PRINT yas
```

Dosya kanalı mantığı:

```basic
OPEN "veri.txt" FOR OUTPUT AS #1
PRINT #1, "77"
CLOSE #1

OPEN "veri.txt" FOR INPUT AS #2
DIM okuma AS I32
INPUT #2, okuma
CLOSE #2

PRINT okuma
```

Beklenen çıktı:

```text
77
```

Burada `#` işareti değişken eki değildir; dosya kanal numarasıdır. uXBasic sözleşmesinde `#` karakteri dosya giriş çıkış kanalını göstermek için kullanılır.

## CLS, COLOR ve LOCATE

`CLS`, ekranı temizler. `COLOR`, yazı ve arka plan rengini ayarlar. `LOCATE`, imleci belirli satır ve sütuna taşır. Bu komutlar doğrudan hesap üretmez; fakat konsol programında kullanıcıya düzenli çıktı göstermek için kullanılır.

Syntax:

```basic
CLS
COLOR onPlan, arkaPlan
LOCATE satir, sutun
```

Örnek:

```basic
CLS
COLOR 10, 0
LOCATE 2, 5
PRINT "uXBasic panel"
```

Bu örnek bir hesap algoritması değil, çıktı düzeni örneğidir. Kitapta böyle komutlar anlatılırken “ekranı güzelleştirir” gibi boş cümle kullanılmaz. Görev açık yazılır: `CLS` eski çıktıyı siler, `COLOR` yeni çıktının renk bilgisini ayarlar, `LOCATE` yazının başlayacağı konumu seçer.

## INKEY ve GETKEY

`INKEY` ve `GETKEY`, klavyeden karakter veya tuş bilgisi alma ailesindedir. Bu iki sözcük birlikte korunur. `INKEY` genellikle beklemeden okuma fikrine, `GETKEY` ise tuş alma fikrine bağlanır. Kitapta ikisi de klavye giriş yüzeyi olarak anlatılır.

Örnek kullanım fikri:

```basic
DIM tus AS STRING

tus = INKEY

IF tus <> "" THEN
    PRINT tus
END IF
```

Basit menü fikri:

```basic
PRINT "1 - Baslat"
PRINT "2 - Cikis"

DIM tus AS STRING
 tus = GETKEY

IF tus = "1" THEN
    PRINT "Basliyor"
ELSEIF tus = "2" THEN
    PRINT "Cikis"
ELSE
    PRINT "Bilinmeyen secim"
END IF
```

Bu örnek, klavye komutlarını `IF`, `ELSEIF`, `PRINT` ve `STRING` tipiyle birleştirir. Komutlar kitapta tek tek görünür; fakat program gerçek gücünü bu birleşimlerde kazanır.

## Temel komutların birlikte akışı

Aşağıdaki küçük program, bu bölümdeki komut ailesini tek bir akışta kullanır:

```basic
CLS
COLOR 10, 0

CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

LOCATE 2, 1
PRINT "Olcum sonucu"

IF okuma < LIMIT THEN
    PRINT "Guvenli"
ELSE
    PRINT "Limit asildi"
END IF
```

Beklenen çıktı:

```text
Olcum sonucu
Guvenli
```

Bu program küçük görünür; fakat bir kitabın ilk dersleri için yeterince zengindir. Sabit değer vardır, değişken vardır, koşul vardır, ekran düzeni vardır ve sonuç vardır. uXBasic kitabında temel komutlar bu şekilde öğretilir: önce tek başına, sonra birlikte, sonra küçük bir düşünce düzeni içinde.

---

# Bölüm 16 - Operatör Referansı: İfade Kurma, Öncelik ve Logic16

Operatörler, programın düşünme biçimini kurar. Değişkenler değer taşır; operatörler bu değerler arasında ilişki kurar. `a + b` bir toplama ifadesidir, `sicaklik > 22` bir karar ifadesidir, `izin AND sicaklikUygun` iki şartı birleştirir, `maske SHL 1` bitleri sola kaydırır. Bu yüzden operatör bölümü yalnız işaret listesi değildir; ifade kurma dersidir.

uXBasic operatör sözleşmesinde büyük öncelik değeri daha sıkı bağlanır. Örneğin çarpma toplama işleminden önce gelir; üs alma sağdan bağlanır; atama ailesi en düşük önceliklerden birine sahiptir. `=` işareti bağlama duyarlıdır: sol taraf değişkense atama, koşul ifadesinde ise eşitlik karşılaştırması olarak yorumlanır. Kanonik eşitlik karşılaştırması için `==` yazımı da tanınır ve karşılaştırma anlamına bağlanır.

## Aritmetik operatörler

| Operatör | Görev | Örnek |
|---|---|---|
| `+` | İki sayıyı toplar veya uygun bağlamda metinleri birleştirme yüzeyine katılır. | `a + b` |
| `-` | Çıkarma yapar; tekli kullanımda sayının işaretini değiştirir. | `a - b`, `-a` |
| `*` | Çarpma yapar. | `a * b` |
| `/` | Bölme yapar. | `a / b` |
| `\` | Tam sayı bölme yüzeyi olarak kullanılır. | `a \ b` |
| `%`, `MOD` | Bölmeden kalanı üretir. | `a MOD b` |
| `**` | Üs alma operatörüdür; sağdan bağlanır. | `2 ** 3` |

Örnek:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a + b
PRINT a - b
PRINT a * b
PRINT a MOD b
```

Beklenen çıktı:

```text
17
7
60
2
```

Bu örnekte operatörler yalnız sonuç üretmez; aynı zamanda `PRINT` komutuna ifade verir. `PRINT a + b` satırında önce ifade çözülür, sonra sonuç yazdırılır.

## Karşılaştırma operatörleri

Karşılaştırma operatörleri karar yapılarının temelidir. `IF`, `WHILE`, `UNTIL`, `ASSERT` ve benzeri yapılar bu ifadelerin sonucuna göre akışı seçer.

| Operatör | Görev |
|---|---|
| `=`, `==` | İki değerin eşit olup olmadığını karşılaştırır. `==` açık karşılaştırma yazımıdır. |
| `<>`, `!=` | İki değerin farklı olup olmadığını karşılaştırır. |
| `<` | Sol değer sağ değerden küçük mü diye bakar. |
| `<=` | Sol değer sağ değerden küçük veya eşit mi diye bakar. |
| `>` | Sol değer sağ değerden büyük mü diye bakar. |
| `>=` | Sol değer sağ değerden büyük veya eşit mi diye bakar. |

Örnek:

```basic
DIM sicaklik AS I32 = 24

IF sicaklik > 22 THEN
    PRINT "Yuksek"
ELSE
    PRINT "Normal"
END IF
```

Beklenen çıktı:

```text
Yuksek
```

Burada `>` operatörü yalnız iki sayıyı kıyaslamaz; programın hangi kola gideceğini belirler.

## Mantıksal ve bit düzeyi operatörler

`AND`, `OR`, `NOT` ve `XOR` hem koşul ifadelerinde hem de bit düzeyi düşünmede önemlidir. Koşulda `AND`, iki şartın birlikte doğru olmasını ister. Bit düzeyinde ise iki sayının aynı konumdaki açık bitlerini sonuçta bırakır.

```basic
DIM izin AS I32 = 1
DIM sicaklikUygun AS I32 = 1

IF izin AND sicaklikUygun THEN
    PRINT "Sistem baslat"
ELSE
    PRINT "Bekle"
END IF
```

Beklenen çıktı:

```text
Sistem baslat
```

Bit işlemi örneği:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1
PRINT a SHR 1
```

Bu örnekte `AND`, `OR`, `XOR`, `SHL` ve `SHR` sayıları bit desenleri gibi ele alır. Genç programcı için bu bölüm önemlidir: bilgisayar sayıları yalnız onluk sistemde değil, bit düzeyinde de işler.

## Kaydırma ve döndürme

| Operatör | Görev |
|---|---|
| `SHL`, `<<` | Bitleri sola kaydırır; küçük sayılarda çoğu zaman ikiyle çarpma etkisi verir. |
| `SHR`, `>>` | Bitleri sağa kaydırır; küçük pozitif sayılarda ikiye bölme etkisi verir. |
| `ROL` | Bitleri sola döndürme yüzeyidir. |
| `ROR` | Bitleri sağa döndürme yüzeyidir. |

Örnek:

```basic
DIM x AS I32 = 8
PRINT x SHL 1
PRINT x SHR 1
```

Beklenen çıktı:

```text
16
4
```

## Logic16 ailesi

uXBasic operatör yüzeyinde klasik `AND`, `OR`, `NOT`, `XOR` ailesinin yanında Logic16 ailesi de yer alır. Bu aile, mantıksal ilişkiyi daha geniş bir doğruluk tablosu olarak düşünmek isteyen kullanıcı içindir.

| Operatör | Görev |
|---|---|
| `NAND` | `AND` sonucunun tersini üretir. |
| `NOR` | `OR` sonucunun tersini üretir. |
| `XNOR` | `XOR` sonucunun tersidir; iki değer aynıysa doğru kabul edilir. |
| `IMP` | Mantıksal gerektirme yüzeyidir. |
| `CIMP` | Ters yönlü gerektirme yüzeyidir. |
| `NIMP` | Gerektirmeme yüzeyidir. |
| `NCIMP` | Ters gerektirmeme yüzeyidir. |
| `IDA` | Birinci girdinin kimlik yüzeyidir. |
| `IDB` | İkinci girdinin kimlik yüzeyidir. |
| `NOTA` | Birinci girdinin tersini alır. |
| `NOTB` | İkinci girdinin tersini alır. |

Bu aile özellikle yapay zekâ, karar motoru, kural tablosu ve mantıksal devre düşüncesi için değerlidir. Kitapta Logic16, yalnız “ek operatörler” diye değil, programı doğruluk tablosu gibi düşünme tekniği olarak anlatılır.

Örnek karar fikri:

```basic
DIM a AS I32 = 1
DIM b AS I32 = 0

PRINT a NAND b
PRINT a NOR b
PRINT a XNOR b
```

## Pipe ve üçlü koşul

`|>` operatörü, bir değeri sonraki işlem zincirine aktarma fikrini temsil eder. Bu operatör kitapta akışlı düşünme bölümünde anlatılır. `?:` ise üçlü koşul ifadesi yüzeyidir; koşula göre iki değerden birini seçme fikrini taşır.

Syntax fikri:

```basic
sonuc = kosul ? dogruDeger : yanlisDeger
```

Bu yüzey, kısa karar ifadeleri için kullanılır. Büyük karar ağaçlarında `IF ... THEN ... ELSE ... END IF` daha okunaklıdır.

## Atama operatörleri

Atama operatörleri değeri değiştirir. Bu yüzden karşılaştırma operatörlerinden ayrıdır.

| Operatör | Anlamı |
|---|---|
| `=` | Sol taraftaki değişkene sağ taraftaki değeri atar. |
| `+=` | Değişkeni sağdaki değer kadar artırır. |
| `-=` | Değişkeni sağdaki değer kadar azaltır. |
| `*=` | Değişkeni sağdaki değerle çarpar. |
| `/=` | Değişkeni sağdaki değere böler. |
| `%=`, `\=` | Kalan veya tam bölme ailesi atamasına bağlanır. |
| `<<=`, `>>=` | Bit kaydırma sonucunu aynı değişkene yazar. |
| `**=` | Üs alma sonucunu aynı değişkene yazar. |
| `ROL=`, `ROR=` | Döndürme sonucunu aynı değişkene yazar. |

Örnek:

```basic
DIM toplam AS I32 = 10

toplam += 5
toplam *= 2

PRINT toplam
```

Beklenen çıktı:

```text
30
```

Bu örnek, `toplam = toplam + 5` ve `toplam = toplam * 2` biçimlerinin kısa yazımıdır.

## Operatör öncelik özeti

| Öncelik | Aile |
|---:|---|
| 150 | Alan erişimi, çağrı, indeks, postfix artırım/azaltım |
| 140 | Üs alma `**` |
| 130 | Tekli operatörler, `NOT`, işaret değiştirme |
| 120 | Çarpma, bölme, tam bölme, `MOD` |
| 110 | Toplama ve çıkarma |
| 100 | Kaydırma ve döndürme |
| 90 | Karşılaştırma |
| 80 | Bit `&` yüzeyi |
| 70 | `XOR` |
| 60 | Bit `|` yüzeyi |
| 50 | `AND`, `NAND`, `NIMP`, `NCIMP` |
| 45 | `XNOR` |
| 40 | `OR`, `NOR`, `IMP`, `CIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| 30 | Pipe `|>` |
| 20 | Üçlü koşul `?:` |
| 10 | Atama ailesi |

Bu tablo, ifade okurken hangi parçanın önce bağlanacağını gösterir. Fakat kitapta yalnız tabloya güvenilmez; her önemli operatör ailesi örnekle gösterilir.

---

# Bölüm 17 - Preprocessor Referansı: Kaynağı Hedefe Hazırlama Dili

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

---

# Bölüm 18 - Project Pack Örnek Kütüphanesi

uXBasic kitabının örnekleri boşlukta yazılmaz. Ana örnek havuzu `xtestx/project_packs` dizinidir. Bu dizindeki her pack, dilin bir ailesini temsil eder. Kitapta komut anlatılırken önce bu packlerdeki çalışan örnekler aranır; gerekirse örnek geliştirilir ama kaynak sözdizimiyle uyum korunur.

Project pack sistemi kitabın güvenilirliğini artırır. Çünkü okuyucu yalnız anlatı görmez; o anlatının test ailesindeki karşılığını da görür. `pack_01` temel sayısal akışı, `pack_02` operatörleri, `pack_05` akış kontrolünü, `pack_25` iç içe fonksiyon çağrılarını, `pack_30` ise tam entegrasyon fikrini gösterir.

Aşağıdaki tablo, kitapta kullanılacak ana omurgayı gösterir.

| Pack | Kitapta Kullanıldığı Yer | Görev |
|---|---|---|
| `pack_01_core_numeric_flow` | İlk programlar, `DIM`, `AS`, atama, `PRINT` | Çekirdek sayısal akış kurar. |
| `pack_02_operators_logic_bit` | Operatör bölümü | Aritmetik, mantıksal ve bit düzeyi işlemleri gösterir. |
| `pack_03_strings_builtins` | String fonksiyonları | `LEN`, `MID`, `UCASE`, `LCASE`, `STR`, `VAL` gibi fonksiyon ailesini besler. |
| `pack_04_arrays_index_lvalue` | Dizi ve indeksleme | Dizi elemanına yazma, okuma ve lvalue davranışını gösterir. |
| `pack_05_control_flow_if_for` | `IF`, `FOR`, döngü ve karar | Koşul ve tekrar yapılarını birleştirir. |
| `pack_06_functions_recursion_include` | Fonksiyon, rekürsiyon, include | Fonksiyon çağrısı ve kendini çağırma mantığını gösterir. |
| `pack_07_type_record_structures` | `TYPE` ve kayıt | Alan erişimi ve kayıt tipi fikrini anlatır. |
| `pack_08_namespace_using_alias` | Namespace ve alias | İsim alanı, kısa ad ve kullanım rotasını gösterir. |
| `pack_09_class_oop_magic` | `CLASS`, `MAGIC`, OOP | Nesne yüzeyi ve özel davranış sözleşmesini gösterir. |
| `pack_10_file_io_channels` | Dosya işlemleri | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE` ailesini anlatır. |
| `pack_11_preprocessor_meta` | Preprocessor temel | Meta değişken, koşul ve çıktı fikrini besler. |
| `pack_12_preprocessor_include_foreach` | Include ve foreach | Preprocess döngüsü ve başlık ekleme fikrini gösterir. |
| `pack_13_import_c_cpp_asm` | `IMPORT(C/CPP/ASM)` | Derleme zamanı dış kaynak ekleme kararını gösterir. |
| `pack_14_ffi_winapi_routes` | FFI, DLL, WinAPI | `DECLARE LIB ALIAS` ve dış çağrı rotasını anlatır. |
| `pack_15_science_external_routes` | Bilimsel dış rota | JSON, regex, REST, hesap kütüphanesi gibi dış bağlantı fikrini besler. |
| `pack_16_big_extfp_canonical` | Büyük sayı | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `BIGINIT` ailesini gösterir. |
| `pack_17_memory_ptr_intrinsics` | Bellek ve pointer | `PEEK`, `POKE`, `PTR`, `SIZEOF` gibi düşük seviye yüzeyi gösterir. |
| `pack_18_event_thread_pipe_slot` | Modern akış | `EVENT`, `THREAD`, `PIPE`, `SLOT`, `PARALEL` ailesini gösterir. |
| `pack_19_browser_wasm_webgpu_route` | Web ve WASM | Browser, JS/WAT/WASM hedef rotasını gösterir. |
| `pack_20_module_main_using` | Module ve main | Modül, giriş noktası ve using mantığını gösterir. |
| `pack_21_input_line_file` | Dosya okuma | Satır ve dosya girdi ailesini gösterir. |
| `pack_22_error_try_catch_surface` | Hata yakalama | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` yüzeyini gösterir. |
| `pack_23_data_structures_list_dict_set` | Koleksiyonlar | `ARRAY`, `LIST`, `DICT`, `SET` veri yapısı yüzeyini gösterir. |
| `pack_24_math_time_random_surface` | Matematik ve zaman | `ABS`, `INT`, `SGN`, `SQR`, `RND`, `TIMER` ailesini gösterir. |
| `pack_25_nested_calls_expressions` | İç içe çağrı | Fonksiyon çağrılarının ifade ağacı içinde birleşmesini gösterir. |
| `pack_26_negative_raw_js_gate` | Güvenlik kapısı | Hedefsiz raw JS kullanımının kapatılmasını gösterir. |
| `pack_27_negative_include_cycle` | Include güvenliği | Döngüsel include durumunun yakalanmasını gösterir. |
| `pack_28_negative_semantic_unknown_symbol` | Semantic denetim | Bilinmeyen sembolün yakalanmasını gösterir. |
| `pack_29_negative_wrong_keywords` | Kanonik keyword | Yanlış keywordlerin reddedilmesini gösterir. |
| `pack_30_full_integration_project` | Tam entegrasyon | Birçok dil ailesini tek kaynakta birleştirir. |

Kitapta her örnek şu üç soruyu cevaplamalıdır:

```text
Bu örnek hangi komutu öğretiyor?
Bu örnek hangi önceki bilgiyi kullanıyor?
Bu örnek okuyucuyu hangi sonraki konuya hazırlıyor?
```

Örneğin `pack_01` yalnız `PRINT` örneği değildir. `DIM`, `AS`, atama, aritmetik ifade ve çıktı gözlemini aynı anda gösterir. Bu nedenle ilk bölümde kullanılır. `pack_25` ise fonksiyonlar bölümünün ileri kısmında kullanılır; çünkü iç içe çağrı, önce fonksiyon ve ifade mantığı öğrenilmeden verilirse okuyucuyu yorar.

Kitap örnekleri gerektiğinde testten daha açıklayıcı hâle getirilir. Fakat bu geliştirme kaynak sözleşmesini bozmaz. Testteki örnek kısa olabilir; kitapta aynı örnek açıklama değişkenleriyle genişletilebilir. Önemli olan syntaxın uXBasic kaynak gerçekliğiyle uyumlu kalmasıdır.

Örnek geliştirme ilkesi:

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
PRINT a + b
```

Bu test örneği kitapta şöyle büyütülebilir:

```basic
DIM yem AS I32 = 120
DIM balik AS I32 = 40
DIM oran AS I32

oran = yem / balik
PRINT oran
```

Beklenen çıktı:

```text
3
```

Burada komutlar değişmez; yalnız örnek okuyucunun zihninde daha canlı bir probleme bağlanır.

---

# Bölüm 19 - Kaynak Yüzeyi ve Otomatik Ekler

uXBasic kitabı elle yazılmış paragraflardan oluşur; fakat kitabın referans ekleri yalnız elle tutulmamalıdır. Çünkü kaynak kod değiştikçe keyword listesi, statement dispatch yüzeyi, runtime servisleri, CLI seçenekleri ve project pack örnekleri de değişebilir. Bu nedenle kitap üretim hattında otomatik ek çıkarıcı bulunur.

Otomatik çıkarıcı şu dosyaları okur:

```text
src/parser/lexer/lexer_keyword_table.fbs
src/parser/parser/parser_stmt_registry.fbs
src/runtime/services/runtime_service_ids.fbs
src/cli/cli_registry_adim41.fbs
xtestx/project_packs/_expected/project_pack_manifest.json
```

Bu dosyalardan şu çıktılar üretilir:

```text
docs_build/book_source_surface.json
docs_build/generated/keyword_surface.md
docs_build/generated/statement_dispatch_surface.md
docs_build/generated/runtime_service_surface.md
docs_build/generated/cli_option_surface.md
docs_build/generated/project_pack_examples.md
```

Bu otomatik eklerin amacı ana kitabın yerini almak değildir. Ana kitap, komutları öğretici dille anlatır. Otomatik ekler ise kaynak yüzeyinin eksiksiz kontrolünü sağlar. Böylece kitapta `PRINT` komutu anlatılırken açıklama insan eliyle yazılır; fakat keyword listesi ve dispatch listesi kaynak koddan çekildiği için eksik kalmaz.

Kullanım:

```powershell
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --generated-dir docs_build\generated
python tools\docs\build_uxbasic_pck_book.py --root . --out docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md --include-generated
```

Bu iki komut birlikte çalıştığında önce kaynak yüzeyi çıkarılır, sonra kitap tek Markdown dosyasına derlenir.

Kitap üretim hattı şu ilkeye bağlıdır:

```text
Anlatım elle yazılır.
Referans yüzeyi kaynak koddan çekilir.
Örnek havuzu project packlerden beslenir.
Son kitap tek dosyada toplanır.
```

Bu ilke, kitabı hem okunabilir hem de güncellenebilir yapar.

---

## 19.1 Lexer Keyword Cheat Sheet

Bu liste `src/parser/lexer/lexer_keyword_table.fbs` dosyasından çıkarılmıştır. Ana kitapta öğrenme sırası korunur; bu ek hızlı arama içindir.

`ABS`, `ABSTRACT`, `ALIAS`, `AND`, `ARRAY`, `AS`, `ASC`, `ASSERT`, `ATN`, `BALL`, `BIGD`, `BIGF`, `BOOLEAN`, `BYREF`, `BYVAL`, `CALL`, `CASE`, `CATCH`, `CDBL`, `CDECL`, `CHR`, `CIMP`, `CINT`, `CLASS`, `CLNG`, `CLOSE`, `CLS`, `CODEPTR`, `CODEVAR`, `COLOR`, `CONST`, `CONSTRUCTOR`, `COS`, `CSNG`, `DEC`, `DECLARE`, `DECORATOR`, `DEFBYT`, `DEFDBL`, `DEFEXT`, `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFSTR`, `DELETE`, `DESTRUCTOR`, `DICT`, `DIM`, `DO`, `EACH`, `ELSE`, `ELSEIF`, `END`, `ENUM`, `EOF`, `EQA`, `EQV`, `ERRPATH`, `ERRVAR`, `EVENT`, `EXIT`, `EXP`, `F128`, `F32`, `F64`, `F80`, `FALSE`, `FINAL`, `FINALLY`, `FIX`, `FOR`, `FRIEND`, `FUNCTION`, `GET`, `GETKEY`, `GOSUB`, `GOTO`, `I16`, `I32`, `I64`, `I8`, `IDA`, `IDB`, `IF`, `IFF`, `IMMUTABLE`, `IMP`, `IMPLEMENTS`, `IMPORT`, `IN`, `INC`, `INCLUDE`, `INKEY`, `INLINE`, `INPUT`, `INT`, `INTERFACE`, `IS`, `LCASE`, `LEN`, `LIST`, `LOCATE`, `LOF`, `LOG`, `LOOP`, `LPTR`, `LTRIM`, `MAGIC`, `MAIN`, `MEMCOPYB`, `MEMCOPYD`, `MEMCOPYW`, `MEMFILLB`, `MEMFILLD`, `MEMFILLW`, `METHOD`, `MID`, `MIXIN`, `MOD`, `MODULE`, `MUTABLE`, `NAMESPACE`, `NAND`, `NCIMP`, `NEW`, `NEXT`, `NIMP`, `NOR`, `NOT`, `NOTA`, `NOTB`, `NXOR`, `OBJECT`, `OFF`, `OFFSETOF`, `ON`, `ONE`, `OPEN`, `OPERATOR`, `OR`, `OUTPATH`, `OUTVAR`, `OVERRIDE`, `PARALEL`, `PEEKB`, `PEEKD`, `PEEKW`, `PIPE`, `POKE`, `POKEB`, `POKED`, `POKES`, `POKEW`, `PRINT`, `PRIVATE`, `PROPERTY`, `PROTECTED`, `PTR`, `PUBLIC`, `PUT`, `RANDOMIZE`, `READONLY`, `REDIM`, `RESTRICTED`, `RETURN`, `RND`, `ROL`, `ROR`, `RTRIM`, `RUNPATH`, `SADD`, `SEALED`, `SEEK`, `SELECT`, `SET`, `SETNEWOFFSET`, `SETSTRINGSIZE`, `SGN`, `SHELL`, `SHL`, `SHR`, `SIN`, `SIZEOF`, `SLOT`, `SPACE`, `SQR`, `SQRT`, `STATIC`, `STDCALL`, `STEP`, `STR`, `STRING`, `STRPTR`, `SUB`, `TAN`, `THEN`, `THREAD`, `THROW`, `TIMEOUT`, `TIMER`, `TO`, `TRIGGER`, `TRUE`, `TRY`, `TYPE`, `U16`, `U32`, `U64`, `U8`, `UCASE`, `UNTIL`, `USING`, `VAL`, `VARPTR`, `VIRTUAL`, `WEND`, `WHILE`, `XNOR`, `XOR`, `ZERO`

---

## 19.2 Statement Dispatch Cheat Sheet

Bu liste `src/parser/parser/parser_stmt_registry.fbs` dosyasındaki dispatch girişlerinden çıkarılmıştır.

`ABSTRACT`, `ALIAS`, `ASSERT`, `CALL`, `CLASS`, `CLOSE`, `CLS`, `COLOR`, `CONST`, `DEC`, `DECLARE`, `DEFBYT`, `DEFDBL`, `DEFEXT`, `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFSTR`, `DELETE`, `DIM`, `DO`, `END`, `ENUM`, `EVENT`, `EXIT`, `FINAL`, `FOR`, `FUNCTION`, `GET`, `GOSUB`, `GOTO`, `IF`, `IMPORT`, `INC`, `INCLUDE`, `INLINE`, `INPUT`, `INPUTF`, `INTERFACE`, `LOCATE`, `MAIN`, `MEMCOPYB`, `MEMCOPYD`, `MEMCOPYW`, `MEMFILLB`, `MEMFILLD`, `MEMFILLW`, `MODULE`, `NAMESPACE`, `OFF`, `ON`, `OPEN`, `PARALEL`, `PIPE`, `POKE`, `POKEB`, `POKED`, `POKES`, `POKEW`, `PRINT`, `PUT`, `RANDOMIZE`, `REDIM`, `RETURN`, `SEALED`, `SEEK`, `SELECT`, `SETNEWOFFSET`, `SETSTRINGSIZE`, `SHELL`, `SLOT`, `SUB`, `THREAD`, `THROW`, `TRIGGER`, `TRY`, `TYPE`, `USING`, `WHILE`

---

## 19.3 Runtime Service Cheat Sheet

Bu liste `src/runtime/services/runtime_service_ids.fbs` dosyasındaki runtime servis adlarından çıkarılmıştır.

`RT_API_CALL`, `RT_ARCHIVE_CALL`, `RT_AUDIO_CALL`, `RT_BROWSER_AUDIO`, `RT_BROWSER_CANVAS`, `RT_BROWSER_FETCH`, `RT_BROWSER_FILE`, `RT_BROWSER_INPUT`, `RT_CLS`, `RT_COLOR`, `RT_CRYPTO_CALL`, `RT_CURL_CALL`, `RT_DLL_CALL`, `RT_DLL_LOAD`, `RT_EXTFP_CALL`, `RT_FILE_CLOSE`, `RT_FILE_DELETE`, `RT_FILE_EOF`, `RT_FILE_LOF`, `RT_FILE_OPEN`, `RT_FILE_READ`, `RT_FILE_SEEK`, `RT_FILE_WRITE`, `RT_GETKEY`, `RT_GRAPHICS_CALL`, `RT_HOST_CALL`, `RT_HTTP_CALL`, `RT_IMAGE_CALL`, `RT_INKEY`, `RT_INLINE_NATIVE`, `RT_INPUT`, `RT_JSON_CALL`, `RT_LIBRARY_CALL`, `RT_LLAMA_CALL`, `RT_LOCATE`, `RT_LUA_CALL`, `RT_MATH_ABS`, `RT_MATH_ATN`, `RT_MATH_COS`, `RT_MATH_EXP`, `RT_MATH_FIX`, `RT_MATH_INT`, `RT_MATH_LOG`, `RT_MATH_SGN`, `RT_MATH_SIN`, `RT_MATH_SQRT`, `RT_MATH_TAN`, `RT_MEM_COPY`, `RT_MEM_FILL`, `RT_MEM_LOAD`, `RT_MEM_STORE`, `RT_ONNX_CALL`, `RT_OS_CALL`, `RT_PEEK`, `RT_POKE`, `RT_PRINT`, `RT_PROLOG_CALL`, `RT_RANDOMIZE`, `RT_REGEX_CALL`, `RT_RND`, `RT_SERVER_CALL`, `RT_SQLITE_CALL`, `RT_STRINGX_CALL`, `RT_STR_ASC`, `RT_STR_CHR`, `RT_STR_COMPARE`, `RT_STR_CONCAT`, `RT_STR_LEFT`, `RT_STR_LEN`, `RT_STR_LTRIM`, `RT_STR_MID`, `RT_STR_RIGHT`, `RT_STR_RTRIM`, `RT_STR_SPACE`, `RT_STR_STR`, `RT_STR_TO_LOWER`, `RT_STR_TO_UPPER`, `RT_STR_TRIM`, `RT_STR_VAL`, `RT_TIMER`, `RT_WASM_EXPORT_CALL`, `RT_WASM_IMPORT_CALL`, `RT_WEBGPU_CALL`

---

## 19.4 CLI Option Cheat Sheet

Bu liste `src/cli/cli_registry_adim41.fbs` dosyasından çıkarılan seçenek adlarını içerir.

`--active-bind-plan-json-out`, `--active-bind-plan-txt-out`, `--adim25-26-27-close-gate`, `--adim25-27-close-gate`, `--all-diagnostics-json-out`, `--artifact-report-json-out`, `--artifact-root`, `--ast-contract-check`, `--ast-contract-json-out`, `--ast-contract-matrix-out`, `--ast-contract-report-json-out`, `--ast-exec-result-json-out`, `--ast-json-out`, `--ast-live-json-out`, `--ast-program-output-out`, `--ast-stderr-out`, `--ast-stdout-out`, `--ayikla`, `--backend-matrix-json-out`, `--backend-report-json-out`, `--browser-index-out`, `--build-x64`, `--build-x64-out`, `--canonical-mir-json-out`, `--codegen`, `--codegen-source`, `--console-mode`, `--debug`, `--debug-log-out`, `--debug-token-dump`, `--diag-format`, `--doc`, `--doc-json-out`, `--dump-ast`, `--dump-mir`, `--emit-browser`, `--emit-js`, `--emit-nasm`, `--emit-wasm`, `--emit-wat`, `--emit-x64-nasm`, `--emit-x64-nasm-out`, `--emit-x86`, `--enable-extfp-runtime`, `--enable-mir-x64`, `--error-language-file`, `--error-limit`, `--error-log-out`, `--error-summary-json-out`, `--error-to-terminal`, `--execmem`, `--extfp-diagnostics`, `--extfp-policy-json-out`, `--extfp-runtime-dir`, `--extfp-strict`, `--extract-src`, `--final-screen-json-out`, `--format-check`, `--help`, `--hir-inventory-json-out`, `--hir-json-out`, `--hook-trace`, `--html-out`, `--interop`, `--interpreter-backend`, `--interpreter-compare-json-out`, `--inventory-json-out`, `--ir-json-out`, `--js-out`, `--js-report-json-out`, `--js-runtime-out`, `--json-out`, `--language`, `--layer-timing-json-out`, `--layout-report-json-out`, `--lexer-diagnostics-json-out`, `--log-out`, `--manifest-out`, `--message-lang`, `--mir-exec-result-json-out`, `--mir-full-json-out`, `--mir-json-out`, `--mir-live-json-out`, `--mir-module-json-out`, `--mir-opcodes-json-out`, `--mir-opt-report-json-out`, `--mir-pipeline-json-out`, `--mir-program-output-out`, `--mir-stderr-out`, `--mir-stdout-out`, `--mir-surface-json-out`, `--mir-verify`, `--mir-verify-canonical-json-out`, `--mir-verify-json-out`, `--mir-verify-semantic-json-out`, `--mir-x64-required-opcode-gate-json-out`, `--original-source-out`, `--out-root`, `--parse-only`, `--parser-ast-json-out`, `--parser-diagnostics-json-out`, `--parser-json-out`, `--parser-surface-contract-json-out`, `--pipeline-json-out`, `--pp`, `--preprocess-result-json-out`, `--preprocessed-out`, `--preprocessor`, `--program-output-json-out`, `--program-output-out`, `--quiet`, `--release-gate`, `--release-json-out`, `--run-id`, `--run-manifest-json-out`, `--run-report-json-out`, `--runtime-route-matrix-json-out`, `--runtime-trace-json-out`, `--semantic`, `--semantic-diagnostics-json-out`, `--semantic-enums-json-out`, `--semantic-json-out`, `--semantic-layouts-json-out`, `--semantic-mir-json-out`, `--semantic-types-json-out`, `--semantik`, `--session-live-json-out`, `--sessiz`, `--source`, `--source-map`, `--source-map-json-out`, `--stderr-out`, `--stdout-out`, `--stop-after`, `--strict`, `--symbol-table-json-out`, `--target`, `--target-browser`, `--target-js`, `--target-wasm`, `--target-wat`, `--target-x86`, `--time-passes`, `--token-json-out`, `--tokens-json-out`, `--trace`, `--trace-json`, `--type-cast-report-json-out`, `--type-infer-report-csv-out`, `--type-table-json-out`, `--validate-all`, `--validate-all-fail-fast`, `--validate-all-report-json-out`, `--version`, `--vscode-diagnostics-json-out`, `--wasm-out`, `--wasm-report-json-out`, `--wasm-wat-out`, `--wat-out`, `--wat2wasm`, `--x64`, `--x64-ast-report-json-out`, `--x64-codegen-policy-json-out`, `--x64-mir-report-json-out`, `--x64-mode`, `--x64gen`, `--x64gen-out`

---

## 19.5 Kaynak Keyword Grupları — src1 + INLINE 21.07.2026

Bu tablo `lexer_keyword_table.fbs` yüzeyinden çıkarılmıştır. Ana kitapta görevler anlatılır; bu ek eksik kontrolü içindir.

Toplam benzersiz keyword: **220**

| Grup | Keywordler | Sayı |
|---:|---|---:|
| 1 | `IF`, `THEN`, `ELSE`, `ELSEIF`, `END`, `SELECT`, `CASE`, `IS` | 8 |
| 2 | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` | 5 |
| 3 | `EVENT`, `THREAD`, `PARALEL`, `PIPE`, `SLOT`, `ON`, `OFF`, `TRIGGER` | 8 |
| 4 | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `WEND`, `UNTIL`, `EXIT`, `EACH`, `IN` | 12 |
| 5 | `SUB`, `FUNCTION`, `DECLARE`, `RETURN`, `GOTO`, `GOSUB`, `CALL` | 7 |
| 6 | `TYPE`, `CLASS`, `INTERFACE`, `ENUM`, `IMPLEMENTS`, `METHOD`, `MAGIC`, `VIRTUAL`, `OVERRIDE`, `CONSTRUCTOR`, `DESTRUCTOR`, `NEW`, `DELETE`, `DIM`, `REDIM`, `AS`, `CONST`, `INCLUDE`, `IMPORT`, `ABSTRACT`, `FINAL`, `SEALED`, `STATIC`, `PROPERTY`, `OPERATOR`, `MIXIN`, `DECORATOR` | 27 |
| 7 | `PUBLIC`, `PRIVATE`, `PROTECTED`, `RESTRICTED`, `FRIEND`, `READONLY`, `MUTABLE`, `IMMUTABLE` | 8 |
| 8 | `MAIN`, `NAMESPACE`, `MODULE`, `USING`, `ALIAS` | 5 |
| 9 | `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT` | 7 |
| 10 | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK` | 7 |
| 11 | `CLS`, `COLOR`, `LOCATE` | 3 |
| 12 | `AND`, `OR`, `NOT`, `XOR`, `MOD`, `SHL`, `SHR`, `ROL`, `ROR`, `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` | 24 |
| 13 | `INLINE`, `SHELL`, `TIMEOUT`, `OUTVAR`, `ERRVAR`, `CODEVAR`, `RUNPATH`, `OUTPATH`, `ERRPATH` | 9 |
| 14 | `I8`, `U8`, `I16`, `U16`, `I32`, `U32`, `I64`, `U64`, `F32`, `F64`, `F80`, `F128`, `BIGF`, `BIGD`, `BALL`, `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`, `CDECL`, `STDCALL`, `TRUE`, `FALSE`, `ZERO`, `ONE` | 28 |
| 15 | `ARRAY`, `LIST`, `DICT`, `SET` | 4 |
| 16 | `SETSTRINGSIZE`, `TIMER`, `LOF`, `EOF`, `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`, `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`, `INKEY`, `GETKEY`, `VARPTR`, `SADD`, `LPTR`, `CODEPTR`, `SIZEOF`, `OFFSETOF` | 34 |
| 17 | `CINT`, `CLNG`, `CDBL`, `CSNG`, `FIX`, `SQR`, `RND`, `RANDOMIZE` | 8 |
| 18 | `PEEKB`, `PEEKW`, `PEEKD`, `POKE`, `POKEB`, `POKEW`, `POKED`, `POKES`, `MEMCOPYB`, `MEMCOPYW`, `MEMCOPYD`, `MEMFILLB`, `MEMFILLW`, `MEMFILLD`, `SETNEWOFFSET`, `INC`, `DEC` | 17 |
| 19 | `DIM`, `REDIM`, `CONST`, `FUNCTION`, `SUB`, `TYPE`, `CLASS`, `INTERFACE`, `ENUM`, `NAMESPACE`, `MODULE`, `ALIAS`, `USING`, `INCLUDE`, `PUBLIC`, `PRIVATE`, `PROTECTED`, `FRIEND`, `STATIC`, `ABSTRACT`, `FINAL`, `SEALED`, `PROPERTY`, `METHOD`, `OPERATOR` | 25 |
| 20 | `AS`, `BYVAL`, `BYREF`, `DECLARE` | 4 |

---

# Bölüm 20 - Derleyici Katmanlarından Sonuç Üreten Terminal Rehberi

uXBasic kitabı yalnızca komutların ne işe yaradığını anlatmaz; derleyicinin her katmanından nasıl çıktı alınacağını da gösterir. Çünkü modern bir dilde hata aramak, yalnızca programı çalıştırıp ekrana bakmak değildir. Kaynak dosyanın preprocess sonrası hâlini, token listesini, AST ağacını, HIR/MIR çıktısını, yorumlayıcı sonucunu ve hedef kod üretimini ayrı ayrı görmek gerekir. Bu bölüm, uXBasic kaynak dosyasını derleyici hattının her basamağından geçirip sonuç üreten terminal komutlarını verir.

Bu bölümdeki komutlar uXBasic kök klasöründe çalıştırılır. Örneklerde `.inook_layer_demo.uxb` adında küçük bir deneme dosyası oluşturulur ve bütün çıktılar `reportsook_layersook_layer_demo` altına yazılır. Böylece derleyici kaynaklarına dokunulmaz; yalnızca rapor, JSON, TXT, ASM, JS ve WAT gibi çıktı dosyaları üretilir.

## 27.1. Ortak hazırlık

Önce çıktı klasörleri hazırlanır ve deneme programı yazılır:

```powershell id="xpl3b1"
$Root = (Get-Location).Path
$Out  = Join-Path $Root "reports\book_layers\book_layer_demo"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Root "bin") | Out-Null

@'
%%SET MOD = "KITAP"
%%IF MOD == "KITAP"
PRINT "PREPROCESS_OK"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 20
DIM toplam AS I32

toplam = a + b

IF toplam >= 30 THEN
    PRINT "TOPLAM_OK"
ELSE
    PRINT "TOPLAM_HATA"
END IF

FUNCTION IkiKat(x AS I32) AS I32
    RETURN x * 2
END FUNCTION

PRINT IkiKat(toplam)
'@ | Set-Content -Encoding UTF8 .\bin\book_layer_demo.uxb
```

Bu program özellikle küçük tutulur. İçinde preprocess koşulu, değişken, atama, aritmetik ifade, `IF`, `FUNCTION`, `RETURN` ve `PRINT` bulunur. Böylece derleyicinin ön yüzü, AST, MIR ve yorumlayıcı hattı aynı dosya üzerinde görülebilir.

## 27.2. Derleyiciyi üretmek

Derleyici daha önce üretilmiş olsa bile kitap çalışmasında ilk kapı derlemedir:

```powershell id="fpg7uo"
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

Beklenen durum, `bin\uxb.exe` dosyasının oluşması ve derleme sonunda hata kalmamasıdır. Bu komut, kitapta anlatılan bütün terminal örneklerinin temelidir. Derleyici yoksa sonraki katmanlardan çıktı alınamaz.

## 27.3. Preprocessor A/B çıktısı almak

Preprocessor, kaynak dosya lexer katmanına gitmeden önce metni hazırlar. `%%SET`, `%%IF`, `%%TARGET`, `%%HTML_BEGIN`, `%%JS_BEGIN` gibi yönergeler bu aşamada anlam kazanır. uXBasic içinde A ve B preprocessor yolları vardır. A mevcut ana hat, B ise genişletilmiş blok ve hedef işleme hattı olarak düşünülür.

A hattı için:

```powershell id="zadv3c"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp A `
  --preprocessed-out "$Out\01_preprocessed_A.uxb" `
  --preprocess-result-json-out "$Out\01_preprocess_A.json"
```

B hattı için:

```powershell id="3bd3vl"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp B `
  --preprocessed-out "$Out\01_preprocessed_B.uxb" `
  --preprocess-result-json-out "$Out\01_preprocess_B.json"
```

Bu iki komutun ürettiği `preprocessed` dosyaları karşılaştırıldığında preprocess katmanının kaynak üzerindeki etkisi görülür. `PREPROCESS_OK` satırı koşul doğruysa kaynakta kalır; koşul kapalıysa çıkarılır. Bu sayede kitapta anlatılan `%%IF` ve `%%SET` yalnızca teorik kalmaz.

## 27.4. Lexer ve token çıktısı almak

Lexer, kaynak metni dilin tanıdığı küçük parçalara böler. `PRINT`, `DIM`, `AS`, `I32`, sayı, metin, operatör ve parantez artık metin değil token olur.

```powershell id="jmkep7"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp A `
  --debug-token-dump `
  --tokens-json-out "$Out\02_tokens.json" `
  --lexer-diagnostics-json-out "$Out\02_lexer_diag.json" `
  --preprocessed-out "$Out\02_preprocessed.uxb"
```

Bu çıktı özellikle anahtar kelime kitabı hazırlanırken değerlidir. Bir sözcük lexer tarafından keyword olarak tanınmıyorsa sonraki katmanlarda komut gibi davranamaz. Bu yüzden anahtar kelime cheat sheetleri hazırlanırken lexer yüzeyiyle karşılaştırma yapılır.

## 27.5. Parser ve AST çıktısı almak

Parser, token listesinden anlam ağacı kurar. `IF` artık düz metin değil, koşulu, doğru kolu ve yanlış kolu olan bir AST düğümüdür. `FUNCTION` gövdesi, parametreleri ve dönüş tipiyle birlikte AST içinde temsil edilir.

```powershell id="mver6y"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --parse-only `
  --ast-json-out "$Out\03_ast.json" `
  --parser-diagnostics-json-out "$Out\03_parser_diag.json"
```

AST çıktısı, kitabın komut anlatımında “bu komut kaynakta nasıl görünür, derleyici içinde hangi yapıya dönüşür?” sorusuna cevap verir. Örneğin `PRINT IkiKat(toplam)` satırı parser açısından iç içe çağrı ve çıktı komutunun birleşimidir.

## 27.6. AST sözleşme ve AST yorumlayıcı hattı

AST yalnızca yazdırılacak bir JSON değildir; uXBasic’te AST yorumlayıcı doğrudan bu ağaç üzerinden çalışabilir. Bu yol özellikle kaynak anlamını hızlı denemek için kullanılır.

```powershell id="m7t6a0"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --ast-contract-check `
  --ast-json-out "$Out\04_ast_contract_ast.json" `
  --ast-contract-json-out "$Out\04_ast_contract.json" `
  --ast-contract-matrix-out "$Out\04_ast_contract_matrix.json"
```

AST yorumlayıcı ile çalıştırma:

```powershell id="wmwp1q"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend AST `
  --stdout-out "$Out\05_ast_stdout.txt" `
  --stderr-out "$Out\05_ast_stderr.txt" `
  --run-report-json-out "$Out\05_ast_run_report.json"
```

Beklenen program çıktısı:

```text id="o2nifv"
PREPROCESS_OK
TOPLAM_OK
60
```

Bu çıktı, kaynak kodun AST yolundan çalıştırıldığını gösterir. Kitapta `AST çalışır` demek yerine, bu komutla AST yorumlayıcı sonucu üretilir.

## 27.7. Semantic ve HIR çıktısı almak

Semantic katman isimleri, tipleri, kapsamı ve çağrıları anlamlandırır. `toplam = a + b` satırında `a`, `b` ve `toplam` değişkenlerinin tanımlı olup olmadığı; `IkiKat(toplam)` çağrısında parametre uyumu bu katmanda anlam kazanır.

```powershell id="nyixic"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --semantic `
  --hir-json-out "$Out\06_hir.json" `
  --hir-inventory-json-out "$Out\06_hir_inventory.json"
```

HIR çıktısı, AST ile MIR arasındaki yüksek seviyeli ara katmandır. Kitapta tip, scope, fonksiyon ve çağrı anlatılırken semantic/HIR hattı bu yüzden ayrıca gösterilir.

## 27.8. MIR üretmek ve doğrulamak

MIR, hedef üretim omurgasıdır. AST kaynak anlamını taşır; MIR ise bu anlamı backendlerin daha kolay kullanacağı ara forma indirir. MIR yorumlayıcı, JS/WAT/WASM ve x64 üretim hattı bu düzeyden destek alır.

```powershell id="un8sq1"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --mir-verify `
  --mir-json-out "$Out\07_mir.json" `
  --mir-full-json-out "$Out\07_mir_full.json" `
  --mir-opcodes-json-out "$Out\07_mir_opcodes.json" `
  --mir-surface-json-out "$Out\07_mir_surface.json" `
  --mir-verify-json-out "$Out\07_mir_verify.json" `
  --mir-opt-report-json-out "$Out\07_mir_opt_report.json"
```

MIR çıktısı incelendiğinde `PRINT`, aritmetik işlem, koşullu dallanma ve fonksiyon çağrısı gibi yapılar artık backendin kullanacağı daha düz bir temsil hâline gelir.

## 27.9. MIR yorumlayıcı ile çalıştırmak

AST yorumlayıcı kaynak anlam ağacını çalıştırırken, MIR yorumlayıcı ara temsil üzerinden çalışır. Aynı program iki yorumlayıcıda da aynı sonucu üretmelidir.

```powershell id="5h3v0v"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend MIR `
  --mir-exec-result-json-out "$Out\08_mir_exec_result.json" `
  --mir-live-json-out "$Out\08_mir_live.json" `
  --mir-stdout-out "$Out\08_mir_stdout.txt" `
  --mir-stderr-out "$Out\08_mir_stderr.txt" `
  --mir-program-output-out "$Out\08_mir_program_output.txt" `
  --run-report-json-out "$Out\08_mir_run_report.json"
```

Beklenen program çıktısı yine aynıdır:

```text id="fmncdu"
PREPROCESS_OK
TOPLAM_OK
60
```

Bu eşitlik önemlidir. AST ve MIR aynı kaynak anlamını farklı yürütme yollarından doğrular.

## 27.10. AST ve MIR birlikte çalıştırmak

Karşılaştırmalı denetim için iki yorumlayıcı aynı komutla birlikte istenebilir:

```powershell id="9xsl20"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend BOTH `
  --stdout-out "$Out\09_both_stdout.txt" `
  --stderr-out "$Out\09_both_stderr.txt" `
  --run-report-json-out "$Out\09_both_run_report.json"
```

Bu komut kitap örneklerinin kalite kapısı için kullanışlıdır. Aynı örnek AST ve MIR tarafında tutarlıysa belgeye alınması daha güvenli olur.

## 27.11. x64 NASM çıktısı üretmek

x64 kod üretimi MIR seviyesindedir; AST’den kaynak anlamı ve yüksek seviye bilgi desteği alabilir. Ama üretim hattının omurgası MIR’dir.

```powershell id="qjdske"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --codegen-source MIR `
  --x64-mode MIR `
  --emit-x64-nasm `
  --emit-x64-nasm-out "$Out\10_book_layer_demo_x64.asm" `
  --backend-report-json-out "$Out\10_x64_backend_report.json"
```

Bu komut native assembly artefact üretir. Burada amaç programı hemen EXE yapmak değil, MIR’den x64 üretim yolunu görünür kılmaktır.

## 27.12. x64 build hattı

x64 build hattı için çıktı klasörü verilir:

```powershell id="df6bup"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --codegen-source MIR `
  --x64-mode MIR `
  --build-x64 `
  --build-x64-out "$Out\x64_build" `
  --backend-report-json-out "$Out\11_x64_build_report.json"
```

Bu komut, sistemde gerekli assembler/linker zinciri varsa native üretime ilerler. Kitapta bu bölüm anlatılırken “x64 MIR’den yürür” cümlesi bu komutla somutlanır.

## 27.13. JS hedefi üretmek

JS üretimi de MIR destekli backend hattındadır. Program browser veya JS çalışma zamanı için dışarıya dosya olarak verilebilir.

```powershell id="bckgsh"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-js `
  --js-out "$Out\12_program.js" `
  --js-runtime-out "$Out\12_uxb_runtime.js" `
  --backend-report-json-out "$Out\12_js_backend_report.json"
```

Bu çıktı, klasik BASIC kodunun JS hedefinde nasıl temsil edilebileceğini gösterir. Hedef JS olduğunda raw JS blokları yalnız güvenli hedef bağlamında kullanılmalıdır.

## 27.14. WAT/WASM hedefi üretmek

WAT, WebAssembly’nin metin biçimidir. uXBasic WAT/WASM hedefinde MIR tabanlı üretim hattından yararlanır.

```powershell id="2v7n3m"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-wat `
  --wat-out "$Out\13_program.wat" `
  --backend-report-json-out "$Out\13_wat_backend_report.json"
```

WASM çıktısı için:

```powershell id="y09ysj"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-wasm `
  --wasm-out "$Out\14_program.wasm" `
  --backend-report-json-out "$Out\14_wasm_backend_report.json"
```

WAT/WASM örnekleri kitapta yalnız web teknolojisi diye değil, derleyicinin hedefe inme gücü olarak anlatılır.

## 27.15. Browser artefact üretmek

Browser hedefi HTML, JS runtime ve isteğe göre WASM dosyalarını birlikte düşünebilir.

```powershell id="hxz66u"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-browser `
  --html-out "$Out\15_index.html" `
  --js-out "$Out\15_program.js" `
  --js-runtime-out "$Out\15_uxb_runtime.js" `
  --backend-report-json-out "$Out\15_browser_backend_report.json"
```

Bu komut, uXBasic’in yalnız konsol dili değil, hedef üreten bir dil olduğunu gösterir.

## 27.16. Project pack doğrulaması

Kitapta anlatılan ana omurga `xtestx/project_packs` ile bağlanır. Bu paketler dil yüzeyinin birlikte çalışmasını gösterir.

```powershell id="kdcdt5"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Odaklı bir paket çalıştırmak için:

```powershell id="gnltwh"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_30_full_integration_project
```

Kitabın her yeni örneği bu disipline yaklaşmalıdır: kaynak dosya, beklenen çıktı, rapor klasörü ve gerekirse JSON artefact.

## 27.17. Kaynak yüzeyi ve otomatik kitap eklerini üretmek

Kitap eklerinde keyword, statement dispatch, runtime service ve CLI option yüzeyleri otomatik çıkarılır:

```powershell id="6qmdew"
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
```

Ardından tek kitap yeniden üretilir:

```powershell id="3hq2ai"
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Bu iki komut, belgenin kaynak kodla bağlantısını korur. Kitap yalnız elle yazılmış bir metin değildir; kaynak yüzeyinden beslenen bir teknik belgedir.

## 27.18. Katman çıktılarının anlamı

| Çıktı | Katman | Ne Gösterir? |
|---|---|---|
| `preprocessed.uxb` | Preprocessor | Derleyiciye girecek son kaynak metni |
| `tokens.json` | Lexer | Keyword, sayı, string, operatör ve sembol parçaları |
| `ast.json` | Parser / AST | Kaynak anlam ağacı |
| `hir.json` | Semantic / HIR | Tip, kapsam ve yüksek seviye temsil |
| `mir.json` | MIR | Backend ve MIR yorumlayıcı omurgası |
| `mir_opcodes.json` | MIR opcode | Ara temsil komut aileleri |
| `ast_stdout.txt` | AST interpreter | AST üzerinden çalışma sonucu |
| `mir_program_output.txt` | MIR interpreter | MIR üzerinden çalışma sonucu |
| `program.js` | JS backend | JS hedef çıktısı |
| `program.wat` | WAT backend | WebAssembly text çıktısı |
| `program.wasm` | WASM backend | Binary WebAssembly çıktısı |
| `book_layer_demo_x64.asm` | x64 backend | MIR tabanlı native assembly çıktısı |

Bu tablo, kitabın teknik doğruluk ilkesini özetler. uXBasic’te bir komut yalnız kaynak satırı değildir; derleyici hattında birden fazla artefact üretir. Resmî teknik kitap bu artefactların adını, yerini ve görevini açıkça göstermelidir.

---

# Bölüm 21 - On Ayrı Proje Programı: Komutları Birleştirerek Öğrenme

Komutları tek tek öğrenmek gereklidir; fakat gerçek programcılık, komutları birleştirmeyi öğrenince başlar. Bu bölümde uXBasic için on ayrı küçük proje programı verilir. Her proje bir komut ailesini öne çıkarır, fakat yalnız o aileye kapanmaz. Değişken, operatör, koşul, döngü, fonksiyon, veri yapısı, dosya, preprocessor, backend ve dış çağrı fikirleri birbiriyle bağlanır.

Bu projeler, eski PCK belgelerinde çoğu zaman yalnız öneri olarak geçen konuları kod örneğine dönüştürür. Örnekler `docs_examples\book_projects` altında ayrı `.uxb` dosyaları olarak da verilir. Böylece okuyucu kitapta gördüğü programı dosya olarak alıp deneyebilir, değiştirebilir ve kendi örneğine çevirebilir.

## Proje 1 — Tank sıcaklık izleyici

Bu proje `DIM`, `AS`, dizi, `FOR`, `IF`, karşılaştırma operatörleri ve `PRINT` komutlarını birlikte kullanır. Amaç üç tankın sıcaklığını gezmek, güvenli aralık dışına çıkan tankları bildirmek ve ortalama sıcaklığı hesaplamaktır.

```basic id="5tfk52"
' Proje 1: Tank sicaklik izleyici
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 24
sicaklik(3) = 21

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)

    IF sicaklik(i) < 19 THEN
        PRINT "TANK_DUSUK"
    ELSEIF sicaklik(i) > 23 THEN
        PRINT "TANK_YUKSEK"
    ELSE
        PRINT "TANK_NORMAL"
    END IF
NEXT i

PRINT toplam / 3
```

Beklenen düşünce şudur: dizi ölçümleri tutar, döngü bütün tankları gezer, `IF` sıcaklığı sınıflandırır, toplam değişkeni ortalamaya hazırlanır. Aynı program daha sonra `FUNCTION SicaklikDurumu(...)` biçimine genişletilebilir.

Bu projedeki ana yapılar:

| Yapı | Görev |
|---|---|
| `DIM sicaklik(3) AS I32` | Üç elemanlı sayısal ölçüm dizisi kurar. |
| `FOR i = 1 TO 3` | Tankları sırayla gezer. |
| `IF / ELSEIF / ELSE` | Ölçümü düşük, normal veya yüksek sınıfına ayırır. |
| `toplam = toplam + sicaklik(i)` | Döngü içinde birikimli toplam alır. |

## Proje 2 — Yem stok ve maliyet hesaplayıcı

Bu proje değişken, fonksiyon, `RETURN`, çarpma, bölme ve koşullu uyarı kullanır. Amaç günlük yem tüketimini ve kaç günlük stok kaldığını hesaplamaktır.

```basic id="nw9nt3"
' Proje 2: Yem stok ve maliyet hesaplayici
FUNCTION GunlukYem(balikSayisi AS I32, gram AS I32) AS I32
    RETURN balikSayisi * gram
END FUNCTION

FUNCTION KalanGun(stokGram AS I32, gunlukGram AS I32) AS I32
    IF gunlukGram <= 0 THEN
        RETURN 0
    END IF
    RETURN stokGram / gunlukGram
END FUNCTION

DIM balik AS I32 = 250
DIM kisiBasiYem AS I32 = 12
DIM stok AS I32 = 90000

DIM gunluk AS I32
gunluk = GunlukYem(balik, kisiBasiYem)

PRINT gunluk
PRINT KalanGun(stok, gunluk)

IF KalanGun(stok, gunluk) < 10 THEN
    PRINT "STOK_AZ"
ELSE
    PRINT "STOK_YETERLI"
END IF
```

Bu programda iki fonksiyon vardır. `GunlukYem` saf hesap fonksiyonudur. `KalanGun` ise korumalı hesap yapar; günlük tüketim sıfır veya negatifse bölme yapmadan `0` döndürür. Bu, genç programcıya güvenli fonksiyon yazmayı öğretir.

## Proje 3 — Su kalite puanlayıcı

Bu proje mantıksal operatörleri kullanır. `AND`, `OR` ve `NOT` yalnız teorik sözcükler değildir; program kararını biçimlendirir.

```basic id="32pwwf"
' Proje 3: Su kalite puanlayici
DIM ph AS I32 = 7
DIM oksijen AS I32 = 8
DIM sicaklik AS I32 = 21

DIM phUygun AS I32
DIM oksijenUygun AS I32
DIM sicaklikUygun AS I32

phUygun = (ph >= 6) AND (ph <= 8)
oksijenUygun = oksijen >= 6
sicaklikUygun = (sicaklik >= 18) AND (sicaklik <= 23)

IF phUygun AND oksijenUygun AND sicaklikUygun THEN
    PRINT "SU_KALITESI_IYI"
ELSE
    PRINT "SU_KALITESI_KONTROL"
END IF

IF NOT oksijenUygun THEN
    PRINT "HAVALANDIRMA_AC"
END IF
```

Burada her ölçüm ayrı bir mantıksal değişkene bağlanır. Böyle yazmak uzun gibi görünür ama hata ayıklamayı kolaylaştırır. Tek satırda dev bir koşul yazmak yerine, koşulun parçaları adlandırılır.

## Proje 4 — Ölçüm dosyası yazma ve okuma

Bu proje `OPEN`, `PRINT #`, `INPUT #` ve `CLOSE` komutlarını gösterir. Dosya işlemlerinde `#` kanal numarasını belirtir.

```basic id="8tl1o9"
' Proje 4: Olcum dosyasi yazma ve okuma
OPEN "olcumler.txt" FOR OUTPUT AS #1
PRINT #1, "18"
PRINT #1, "21"
PRINT #1, "20"
CLOSE #1

OPEN "olcumler.txt" FOR INPUT AS #2
DIM a AS I32
DIM b AS I32
DIM c AS I32

INPUT #2, a
INPUT #2, b
INPUT #2, c
CLOSE #2

PRINT a + b + c
```

Dosya kanal mantığı önemlidir. `PRINT` ekrana yazar; `PRINT #1` ise bir numaralı dosya kanalına yazar. Bu ayrım tabloda kısa görünür ama programda gerçek fark yaratır.

## Proje 5 — TYPE ile ölçüm kaydı

Bu proje `TYPE` kullanarak birden çok değeri tek kayıt altında toplar. `TYPE`, yalnız veri saklamaz; veriye anlamlı bir biçim verir.

```basic id="k96be9"
' Proje 5: TYPE ile olcum kaydi
TYPE Olcum
    tank AS I32
    sicaklik AS I32
    oksijen AS I32
END TYPE

DIM o AS Olcum
o.tank = 1
o.sicaklik = 22
o.oksijen = 7

PRINT o.tank
PRINT o.sicaklik + o.oksijen

IF o.oksijen < 6 THEN
    PRINT "OKSIJEN_DUSUK"
ELSE
    PRINT "OKSIJEN_NORMAL"
END IF
```

`TYPE` bölümü anlatılırken bu örnek kullanılmalıdır. Çünkü `o.tank`, `o.sicaklik`, `o.oksijen` yazımı alan erişimini açıkça gösterir. Dizi ölçüm tutar; `TYPE` ise bir ölçümün iç yapısını taşır.

## Proje 6 — NAMESPACE ve ALIAS ile modüler hesap

Bu proje isim alanı kurmayı ve kısa ad vermeyi gösterir. Büyük projelerde aynı adlı fonksiyonların çakışmasını önlemek için `NAMESPACE` kullanılır. `ALIAS` ise uzun veya dışarıdan gelen adı daha okunur hâle getirir.

```basic id="0ayozw"
' Proje 6: Namespace ve alias ile moduler hesap
NAMESPACE SuHesap
    FUNCTION Ortalama(a AS I32, b AS I32, c AS I32) AS I32
        RETURN (a + b + c) / 3
    END FUNCTION

    FUNCTION Risk(sicaklik AS I32) AS I32
        IF sicaklik > 23 THEN
            RETURN 1
        END IF
        RETURN 0
    END FUNCTION
END NAMESPACE

USING SuHesap
ALIAS ORT AS Ortalama

DIM sonuc AS I32
sonuc = ORT(18, 21, 24)
PRINT sonuc
PRINT Risk(sonuc)
```

Bu örnek, `NAMESPACE`, `USING`, `ALIAS`, `FUNCTION`, `RETURN` ve `IF` komutlarını aynı bağlamda kullanır. Okuyucu modüler düşünmeyi tek başına anlatılan bir kavram olarak değil, çalışan fonksiyon düzeni olarak görür.

## Proje 7 — Preprocessor ile hedef seçen program

Bu proje preprocess komutlarının normal komutlardan farkını gösterir. `%%SET` ve `%%IF` derleme öncesi çalışır; kaynak metnin hangi parçalarının derleyiciye gideceğine karar verir.

```basic id="259q4g"
' Proje 7: Preprocessor ile hedef secimi
%%SET HEDEF = "KONSOL"

%%IF HEDEF == "KONSOL"
PRINT "KONSOL_HEDEFI"
%%ELSE
PRINT "DIGER_HEDEF"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 5
PRINT a * b
```

Bu programda `%%IF` çalışma zamanı koşulu değildir. Program çalışırken karar vermez; derleyiciye gitmeden önce kaynak metni seçer. Buna karşılık alttaki `PRINT a * b` normal çalışma zamanı ifadesidir.

Web hedefi genişletmesi:

```basic id="7ioih2"
%%TARGET WEB
%%OUTDIR "dist/preprocess_demo"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Preprocessor Web Ciktisi</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("WEB_PREPROCESS_OK");
%%JS_END

PRINT "WEB_ROUTE"
```

## Proje 8 — Büyük sayı ve geniş duyarlık gösterimi

Bu proje `BIGINIT`, `BIGI`, `BIGINT`, `BIGD`, `BIGF` ve `BALL` ailesini gösterir. Amaç büyük sayı fikrini sözde bırakmamak, doğrudan kullanım biçimini yazmaktır.

```basic id="xwffg2"
' Proje 8: Buyuk sayi ve genis duyarlik
PRINT BIGINIT(BIGI, "12345")
PRINT BIGINIT(BIGINT, "23456")
PRINT BIGINIT(BIGD, "12.50")
PRINT BIGINIT(BIGF, "3.5")
PRINT BIGINIT(BALL, "7.1")
```

Bu örnek sayısal aileleri yüzeyden gösterir. Kitapta geniş duyarlık anlatılırken şu fark açık yazılır: `I32` gibi tipler makine sayısıdır; `BIGI`, `BIGD`, `BIGF` ve `BALL` ailesi daha geniş sayı sözleşmesi için kullanılır.

## Proje 9 — Event, Thread, Pipe ve Paralel yüzeyi

Bu proje olay, iş parçacığı, veri akışı ve paralel iş kavramlarını aynı sayfada gösterir. Bu aile, uXBasic’in klasik BASIC çizgisinden modern çalışma modeline geçtiği yerdir.

```basic id="flj1hh"
' Proje 9: Event, thread, pipe ve paralel yuzeyi
EVENT Tick
    PRINT "EVENT_TICK"
END EVENT

THREAD Worker
    DIM i AS I32 = 1
    PRINT i
END THREAD

PIPE DataPipe item AS I32
    PRINT item
END PIPE

PARALEL Grup
    PRINT "PARALEL_BODY"
END PARALEL

PRINT "ASYNC_SURFACE_OK"
```

Bu örnek özellikle doğru keyword kararlarını pekiştirir. Doğru yazım `THREAD`, `PARALEL` ve `MAGIC` biçimidir. `THREAD`, `PARALEL` ve `MAGIC` kitapta yalnız yanlış kullanım notu olarak geçmelidir.

## Proje 10 — Dış kaynak, DLL/API rotası ve güvenli imza

Bu proje `IMPORT`, `DECLARE LIB ALIAS` ve `CALL(DLL)` arasındaki farkı gösterir. Aynı aileye yakın görünseler de görevleri farklıdır.

```basic id="q8r4nb"
' Proje 10: Dis kaynak ve DLL/API rotasi
IMPORT(C, "native/math.c")
IMPORT(CPP, "native/engine.cpp")
IMPORT(ASM, "native/fast.asm")

DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" _
    (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

CALL(DLL, "kernel32.dll", "Beep", 800, 200)
CALL(API, "local", "healthcheck")

PRINT "DIS_CAGRI_ROTASI_OK"
```

Bu örnek üç ayrı kapıyı birbirinden ayırır. `IMPORT(C, ...)` derleme zamanı kaynak ekleme kapısıdır. `DECLARE FUNCTION ... LIB ... ALIAS ...` dış fonksiyonun imzasını bildirir. `CALL(DLL, ...)` çalışma zamanı DLL çağrı rotasını kurar. `CALL(API, ...)` ise API/servis rotasıdır. Kitapta bu ayrım kesin korunmalıdır.

## Projelerin birlikte öğrettiği ana harita

| Proje | Öne Çıkan Konu | Birleşen Yapılar |
|---|---|---|
| 1 | Dizi ve sıcaklık kontrolü | `DIM`, dizi, `FOR`, `IF`, karşılaştırma |
| 2 | Fonksiyonla hesap | `FUNCTION`, `RETURN`, bölme koruması |
| 3 | Mantıksal koşullar | `AND`, `OR`, `NOT`, adlandırılmış koşul |
| 4 | Dosya işlemleri | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE` |
| 5 | Kayıt tipi | `TYPE`, alan erişimi, koşul |
| 6 | Modüler yapı | `NAMESPACE`, `USING`, `ALIAS`, fonksiyon |
| 7 | Preprocessor | `%%SET`, `%%IF`, `%%TARGET`, web blokları |
| 8 | Büyük sayı | `BIGINIT`, `BIGI`, `BIGD`, `BIGF`, `BALL` |
| 9 | Modern çalışma yüzeyi | `EVENT`, `THREAD`, `PIPE`, `PARALEL` |
| 10 | Dış dünya | `IMPORT`, `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)` |

Bu on proje, kitabın komut referansını canlı hâle getirir. Okuyucu önce komutu tablodan görür, sonra projede görevini izler, sonra kendi programına taşır.

---

# Bölüm 22 - Tam Dil Referansı: Komut, Fonksiyon, Operatör, Veri Tipi ve Veri Yapısı

Bu bölüm hızlı başvuru için yazılmıştır; fakat kuru liste değildir. Her aile önce görevine göre açıklanır, sonra sözdizimi ve örnekle bağlanır. uXBasic kitabında referans bölümü, okuyucuyu örneksiz bırakmamalıdır.

## 29.1. Temel giriş, çıkış ve değişken ailesi

| Sözcük | Syntax | Görev | Kısa Örnek |
|---|---|---|---|
| `PRINT` | `PRINT ifade` | Ekrana veya hedef çıktıya değer yazar. `PRINT #` biçimi dosya kanalına yazar. | `PRINT "OK"` |
| `DIM` | `DIM ad AS tip` | Değişken, dizi veya nesne alanı açar. | `DIM x AS I32 = 10` |
| `AS` | `ad AS tip` | Değişkenin, parametrenin veya fonksiyon dönüşünün tipini bağlar. | `FUNCTION F() AS I32` |
| `CONST` | `CONST ad AS tip = değer` | Program boyunca değişmeyen sabit tanımlar. | `CONST LIMIT AS I32 = 100` |
| `REDIM` | `REDIM dizi(yeniBoyut)` | Dizi boyutunu yeniden kurar. | `REDIM veri(20)` |
| `LET` | `LET ad = ifade` | Atamayı açık biçimde yazar; modern kullanımda doğrudan `ad = ifade` de kullanılır. | `LET x = 5` |
| `INPUT` | `INPUT değişken` | Kullanıcıdan veya `INPUT #` ile dosyadan değer alır. | `INPUT yas` |

Temel örnek:

```basic id="6ur8u5"
CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

IF okuma < LIMIT THEN
    PRINT "GUVENLI"
ELSE
    PRINT "LIMIT_ASILDI"
END IF
```

## 29.2. Akış kontrol ailesi

| Sözcük | Syntax | Görev | Birlikte Kullanılır |
|---|---|---|---|
| `IF` | `IF koşul THEN ... END IF` | Koşula göre program akışını kola ayırır. | `THEN`, `ELSEIF`, `ELSE` |
| `ELSEIF` | `ELSEIF koşul THEN` | İlk koşul yanlışsa yeni koşul dener. | `IF`, `ELSE`, `END IF` |
| `ELSE` | `ELSE` | Önceki koşulların hiçbiri doğru değilse çalışır. | `IF`, `ELSEIF` |
| `SELECT` | `SELECT CASE ifade` | Tek ifadeyi birçok olası duruma göre ayırır. | `CASE`, `CASE ELSE` |
| `CASE` | `CASE değer` | `SELECT` içinde eşleşme kolu açar. | `SELECT CASE` |
| `FOR` | `FOR i = a TO b STEP s` | Sayaçla tekrar eden döngü kurar. | `TO`, `STEP`, `NEXT` |
| `NEXT` | `NEXT i` | `FOR` döngüsünü ilerletir. | `FOR` |
| `DO` | `DO ... LOOP` | Koşullu veya koşulsuz döngü bloğu açar. | `LOOP`, `WHILE`, `UNTIL` |
| `WHILE` | `WHILE koşul` | Koşul doğru oldukça çalışır. | `WEND`, `DO` |
| `UNTIL` | `LOOP UNTIL koşul` | Koşul doğru olana kadar döngüyü sürdürür. | `DO`, `LOOP` |
| `EXIT` | `EXIT FOR`, `EXIT DO` | İçinde bulunulan döngü veya bloktan çıkar. | `FOR`, `DO`, `FUNCTION` |

Akış kontrolü yalnız karar vermek değildir; veri işleme düzenini kurar:

```basic id="h8wyxe"
DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 5
    toplam = toplam + i
NEXT i

IF toplam == 15 THEN
    PRINT "TOPLAM_DOGRU"
END IF
```

## 29.3. Fonksiyon ve çağrı ailesi

| Sözcük | Syntax | Görev |
|---|---|---|
| `FUNCTION` | `FUNCTION ad(parametreler) AS tip` | Değer döndüren adlandırılmış işlem bloğu kurar. |
| `SUB` | `SUB ad(parametreler)` | Değer döndürmeyen işlem bloğu kurar. |
| `RETURN` | `RETURN ifade` | Fonksiyondan değer döndürür veya bloktan çıkar. |
| `DECLARE` | `DECLARE FUNCTION ...` | Dış veya önceden bildirilecek fonksiyon imzasını tanımlar. |
| `CALL` | `CALL ad(...)`, `CALL(DLL,...)`, `CALL(API,...)` | Yerel, DLL veya API çağrı rotasını kullanır. |
| `BYVAL` | `BYVAL x AS tip` | Parametreyi değer olarak geçirir. |
| `BYREF` | `BYREF x AS tip` | Parametreyi referans/adres etkisiyle geçirir. |
| `CDECL` | `CDECL` | C çağrı düzeni bilgisini belirtir. |
| `STDCALL` | `STDCALL` | Windows API çağrı düzeni bilgisini belirtir. |

İç içe çağrı örneği:

```basic id="5pwrp3"
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

FUNCTION Mul(a AS I32, b AS I32) AS I32
    RETURN a * b
END FUNCTION

PRINT Add(Mul(2, 3), Add(4, 5))
```

Bu örnekte önce içteki çağrılar çözülür, sonra dıştaki `Add` çağrısı çalışır. AST bu yapıyı ağaç olarak taşır; MIR ise çağrı sırasını hedefe uygun ara temsil hâline getirir.

## 29.4. Operatör ailesi

| Aile | Operatörler | Görev |
|---|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` | Sayısal hesap yapar. |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` | İki değeri karşılaştırır. |
| Mantık | `AND`, `OR`, `NOT`, `XOR` | Koşul veya bit düzeyinde mantıksal işlem yapar. |
| Kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` | Bitleri sola, sağa veya döndürerek taşır. |
| Logic16 | `NAND`, `NOR`, `XNOR`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` | Genişletilmiş mantık kapısı ailesidir. |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `\=`, `<<=`, `>>=`, `**=`, `ROL=`, `ROR=` | Değişkene yeni değer bağlar. |
| Pipe | `|>` | Bir işlemin sonucunu sonraki işleme aktarma yüzeyi kurar. |
| Üçlü | `?:` | Kısa koşullu ifade kurar. |

Karşılaştırma notu önemlidir. `=` bağlama göre atama veya koşul eşitliği olarak görülebilir. Daha açık karşılaştırma için `==` kullanmak güvenlidir.

```basic id="h93g0w"
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a + b
PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1

IF a >= b THEN
    PRINT "A_BUYUK"
END IF
```

## 29.5. Veri tipi ailesi

| Tip | Görev | Kullanım |
|---|---|---|
| `I8`, `I16`, `I32`, `I64` | İşaretli tam sayı ailesidir. | Sayaç, miktar, indis |
| `U8`, `U16`, `U32`, `U64` | İşaretsiz tam sayı ailesidir. | Bayt, maske, pozitif sayaç |
| `F32`, `F64`, `F80`, `F128` | Kayan nokta ailesidir. | Ölçüm, oran, bilimsel hesap |
| `BIGI`, `BIGINT` | Büyük tam sayı yüzeyidir. | Uzun tam sayı hesapları |
| `BIGD`, `BIGF`, `BALL` | Geniş duyarlık / büyük ondalık yüzeyidir. | Para, hassas ölçüm, uzun hesap |
| `BOOLEAN` | Doğru/yanlış değeri taşır. | Koşul, bayrak |
| `STRING` | Metin taşır. | Ad, mesaj, dosya satırı |
| `OBJECT` | Nesne yüzeyi taşır. | Sınıf, dış bağlama, genel nesne |
| `PTR`, `STRPTR` | Adres ve metin işaretçisi yüzeyidir. | Dış fonksiyon, bellek işlemleri |

Örnek:

```basic id="8sy6xp"
DIM sayac AS I32 = 10
DIM ad AS STRING = "uXBasic"
DIM aktif AS BOOLEAN = TRUE

PRINT ad
PRINT sayac
```

## 29.6. Veri yapısı ailesi

| Yapı | Syntax | Görev |
|---|---|---|
| Dizi | `DIM a(10) AS I32` | Aynı tipten çoklu değerleri indeksle saklar. |
| `TYPE` | `TYPE Ad ... END TYPE` | Alanlardan oluşan kayıt tipi tanımlar. |
| `CLASS` | `CLASS Ad ... END CLASS` | Veri ve davranışı birlikte taşıyan nesne tipi kurar. |
| `INTERFACE` | `INTERFACE Ad ... END INTERFACE` | Davranış sözleşmesi tanımlar. |
| `ARRAY` | `ARRAY OF tip` | Koleksiyon tip yüzeyi olarak dizi ailesini belirtir. |
| `LIST` | `LIST OF tip` | Sıralı büyüyebilir liste yüzeyi kurar. |
| `DICT` | `DICT OF anahtar, değer` | Anahtar-değer eşleme yüzeyi kurar. |
| `SET` | `SET OF tip` | Benzersiz eleman kümesi yüzeyi kurar. |
| `MODULE` | `MODULE Ad ... END MODULE` | Büyük kodu modül başlığı altında toplar. |
| `NAMESPACE` | `NAMESPACE Ad ... END NAMESPACE` | İsim çakışmasını önleyen kapsam alanı kurar. |

`TYPE` örneği:

```basic id="rsaf7e"
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

DIM p AS Nokta
p.x = 12
p.y = 30

PRINT p.x + p.y
```

`CLASS` ve `MAGIC` örneği:

```basic id="o8qk6n"
CLASS Anahtar
    VALUE AS I32

    MAGIC HASH() AS I32
        RETURN VALUE + 100
    END MAGIC

    MAGIC ADD(other AS I32) AS I32
        RETURN VALUE + other
    END MAGIC
END CLASS
```

Burada `MAGIC`, sınıf içinde özel davranış sözleşmesi açar. Bu bölümde `MAGIC` sıradan fonksiyon adı gibi değil, nesne davranış kapısı olarak anlatılır.

---

# Bölüm 23 - Preprocessor A/B ve Hedefli Derleme

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
%%JSON_SET version = "src1 + INLINE 21.07.2026"

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

---

# Bölüm 24 - Backend ve Artefact Üretim Rehberi

uXBasic’in güçlü tarafı yalnız kaynak kodu yorumlamak değildir. Aynı kaynak, hedefe göre farklı artefactlar üretebilir. Bu bölümde AST, MIR, runtime ve backend ilişkisi üzerinden JS, WAT/WASM ve x64 üretim hattı anlatılır.

Ana ilke değişmez:

```text id="og7vwe"
AST kaynak anlamını taşır.
MIR hedef üretim omurgasıdır.
AST interpreter AST üzerinden çalışır.
MIR interpreter MIR üzerinden çalışır.
JS, WAT/WASM ve x64 üretimi MIR seviyesinden destek alır.
x64 kod üretimi MIR seviyesindedir; AST kaynak anlamıyla yardımcı olur.
```

## 31.1. AST ve MIR farkını örnekle görmek

Kaynak kod:

```basic id="tz59ck"
DIM a AS I32 = 10
DIM b AS I32 = 20
PRINT a + b
```

AST bu kodu kaynak anlamına yakın taşır: değişken tanımı, atama, ifade ve `PRINT` düğümü vardır. MIR ise hedef üreticinin daha kolay kullanacağı ara işlemler üretir: değer yükleme, toplama, çıktı servisine gönderme gibi daha düz bir yapı oluşur.

AST çıktısı almak:

```powershell id="mwj187"
.\bin\uxb.exe .\bin\demo.uxb --parse-only --ast-json-out reports\ast.json
```

MIR çıktısı almak:

```powershell id="3h6m94"
.\bin\uxb.exe .\bin\demo.uxb --mir-verify --mir-json-out reports\mir.json --mir-opcodes-json-out reports\mir_opcodes.json
```

Bu iki çıktı aynı programı farklı gözle gösterir. Kitapta derleyici mimarisi anlatılırken bu fark temel alınır.

## 31.2. AST interpreter ve MIR interpreter

AST yorumlayıcı doğrudan AST üzerinden yürür:

```powershell id="21bo9j"
.\bin\uxb.exe .\bin\demo.uxb --execmem --interpreter-backend AST --stdout-out reports\ast_stdout.txt
```

MIR yorumlayıcı MIR üzerinden yürür:

```powershell id="u63ngh"
.\bin\uxb.exe .\bin\demo.uxb --execmem --interpreter-backend MIR --mir-program-output-out reports\mir_output.txt
```

İkisi aynı çıktıyı üretmelidir. Fark, yürütme yolundadır.

## 31.3. JS hedefi

JS hedefi için:

```powershell id="w85572"
.\bin\uxb.exe .\bin\demo.uxb --emit-js --js-out dist\program.js --js-runtime-out dist\uxb_runtime.js
```

Bu komut JS dosyası üretir. JS hedefi anlatılırken iki ayrı yol karıştırılmaz: uXBasic komutlarının JS’e çevrilmesi ayrı, preprocess ile raw JS bloğu yazılması ayrıdır.

## 31.4. Browser hedefi

Browser hedefi HTML ve JS artefactlarını birlikte düşünebilir:

```powershell id="6ekqty"
.\bin\uxb.exe .\bin\demo.uxb --emit-browser --html-out dist\index.html --js-out dist\program.js --js-runtime-out dist\uxb_runtime.js
```

Preprocessor web bloklarıyla birlikte örnek:

```basic id="01qeps"
%%TARGET WEB
%%OUTDIR "dist/browser_demo"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Browser</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("BROWSER_OK");
%%JS_END

PRINT "WEB_ROUTE"
```

## 31.5. WAT/WASM hedefi

WAT üretmek:

```powershell id="ieha43"
.\bin\uxb.exe .\bin\demo.uxb --emit-wat --wat-out dist\program.wat
```

WASM üretmek:

```powershell id="3c9qzr"
.\bin\uxb.exe .\bin\demo.uxb --emit-wasm --wasm-out dist\program.wasm
```

WAT/WASM hedefi, uXBasic’in web ve taşınabilir çalışma hedeflerine uzanan yüzüdür. MIR bu hedeflere inme noktasında ana omurgadır.

## 31.6. x64 hedefi

x64 NASM üretmek:

```powershell id="4xe3wn"
.\bin\uxb.exe .\bin\demo.uxb --codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out dist\demo_x64.asm
```

x64 build denemesi:

```powershell id="q8ug04"
.\bin\uxb.exe .\bin\demo.uxb --codegen-source MIR --x64-mode MIR --build-x64 --build-x64-out dist\x64_build
```

Bu komutlar kitapta native hedef anlatılırken kullanılmalıdır. x64 üretiminde ana fikir, kaynak kodun önce MIR’e inmesi ve x64 üreticinin bu MIR bilgisinden assembly üretmesidir.

## 31.7. Artefact klasör düzeni

Kitap örneklerinde çıktıların dağılmaması için şu düzen önerilir:

```text id="lsm0r7"
reports/
  book_layers/
    demo_adı/
      frontend/
      ast/
      hir/
      mir/
      execution/
      backend/

dist/
  demo_adı/
    program.js
    program.wat
    program.wasm
    demo_x64.asm
    index.html
```

Bu düzen, kullanıcıya “çıktı nereye gitti?” sorusunun cevabını verir.

---

# Bölüm 25 - Test Disiplini ve Belge Kalite Kapısı

Resmî teknik kitap, kaynak koddan koparsa kısa sürede eskiyen bir metne dönüşür. Bu yüzden uXBasic kitabında her ana bölüm, mümkün olduğunda test, örnek veya derleyici artefactı ile desteklenir. Kitapta yazılan örneklerin amacı güzel görünmek değildir; kaynak gerçekliğiyle bağ kurmaktır.

## 32.1. Project pack ana kapısı

Ana kapı şudur:

```powershell id="11fbwg"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut, project pack örneklerinin genel durumunu verir. Kitabın omurgası bu paketlerden beslenir. Pack 30 tam entegrasyon örneği, dil yüzeylerinin birlikte nasıl kullanıldığını gösterdiği için özel değerdedir.

## 32.2. Odaklı test kapısı

Bir bölüm yazılırken ilgili pack ayrıca çalıştırılabilir:

```powershell id="wu9v13"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_16_big_extfp_canonical
```

Örneğin büyük sayı bölümü yazılıyorsa pack 16, tam entegrasyon bölümü yazılıyorsa pack 30 çalıştırılır.

## 32.3. Expected test kapısı

Expected testler, kaynak dosya ve beklenen çıktı ilişkisini denetler:

```powershell id="rsb8ak"
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut özellikle kitap örnekleri çoğaldığında önem kazanır. Her yeni örnek ileride expected test havuzuna bağlanabilir.

## 32.4. Belge örneklerini çalıştırma disiplini

Kitap örnekleri için önerilen düzen:

```text id="xo7en2"
docs_examples/
  book_projects/
    project_01_tank_sicaklik.uxb
    project_02_yem_stok.uxb
    ...
```

Örnek çalıştırma:

```powershell id="5r9upk"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb --execmem --interpreter-backend AST
```

MIR ile çalıştırma:

```powershell id="7ru5qq"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb --execmem --interpreter-backend MIR
```

JSON artefact almak:

```powershell id="li7vxj"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb `
  --ast-json-out reports\book_examples\project_01_ast.json `
  --mir-json-out reports\book_examples\project_01_mir.json `
  --run-report-json-out reports\book_examples\project_01_run.json
```

Bu komutlar, kitap örneklerini yalnız metin olmaktan çıkarır.

## 32.5. Kitap üretim kapısı

Kaynak yüzeyi çıkarılır:

```powershell id="3mtilw"
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
```

Tek kitap üretilir:

```powershell id="zcwjsu"
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Bu iki komut, belge üretimini tekrar edilebilir hâle getirir.

## 32.6. Belge kalite kuralları

Kitaba yeni bölüm eklenirken şu kapılar uygulanır:

| Kapı | Soru |
|---|---|
| Görev kapısı | Bu bölüm okuyucuya ne yaptırıyor? |
| Syntax kapısı | Komutun yazılış biçimi açık mı? |
| Örnek kapısı | Öneri kodla gösterildi mi? |
| Katman kapısı | AST, MIR, runtime veya backend ilişkisi doğru mu? |
| Tekrar kapısı | Aynı cümle başka bölümde aynı görevle tekrar ediyor mu? |
| Kaynak kapısı | Anahtar kelime ve CLI bilgisi src1 + INLINE 21.07.2026 yüzeyiyle uyumlu mu? |

Bu kapılar kitabı canlı tutar. uXBasic büyüdükçe kitap da büyür; fakat tekrar ederek değil, yeni görev açıklayarak büyür.

---

# Hızlı Başvuru — src1 + INLINE Native Contract

## Komut aileleri

| Aile | Sözcükler |
|---|---|
| Giriş/çıkış | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `PRINT #`, `INPUT #` |
| Değişken | `DIM`, `AS`, `CONST`, `LET`, `REDIM` |
| Karar | `IF`, `THEN`, `ELSEIF`, `ELSE`, `END IF`, `SELECT`, `CASE`, `CASE ELSE` |
| Döngü | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `UNTIL`, `WEND`, `EXIT` |
| Fonksiyon | `FUNCTION`, `SUB`, `RETURN`, `DECLARE`, `CALL`, `BYVAL`, `BYREF` |
| Tip/nesne | `TYPE`, `CLASS`, `INTERFACE`, `MAGIC`, `NEW`, `DELETE`, `THIS`, `ME` |
| Modül | `NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `INCLUDE`, `IMPORT` |
| Dış çağrı | `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)`, `CDECL`, `STDCALL` |
| Eşzamanlı yüzey | `EVENT`, `THREAD`, `PIPE`, `PARALEL`, `SLOT` |
| Hata | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` |

## Veri tipleri

| Aile | Tipler |
|---|---|
| İşaretli tam sayı | `I8`, `I16`, `I32`, `I64` |
| İşaretsiz tam sayı | `U8`, `U16`, `U32`, `U64` |
| Kayan nokta | `F32`, `F64`, `F80`, `F128` |
| Büyük sayı | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` |
| Genel | `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `STRPTR` |
| Koleksiyon | `ARRAY`, `LIST`, `DICT`, `SET` |

## Operatör aileleri

| Aile | Operatörler |
|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` |
| Mantık | `AND`, `OR`, `NOT`, `XOR` |
| Logic16 | `NAND`, `NOR`, `XNOR`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| Bit kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `\=`, `<<=`, `>>=`, `**=`, `ROL=`, `ROR=` |
| Akış | `|>`, `?:` |

## Preprocessor aileleri

| Aile | Yönergeler |
|---|---|
| Değer | `%%SET`, `%%DEFINE`, `%%UNDEF`, `%%EVAL` |
| Koşul | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` |
| Döngü | `%%FOR`, `%%FOREACH`, `%%REPEAT`, `%%ENDFOR`, `%%BREAK`, `%%CONTINUE` |
| Hedef | `%%TARGET`, `%%PLATFORM`, `%%DESTOS`, `%%PROFILE`, `%%OUTDIR` |
| Web | `%%HTML_BEGIN`, `%%HTML_END`, `%%CSS_BEGIN`, `%%CSS_END`, `%%JS_BEGIN`, `%%JS_END`, `%%JS_LINE` |
| WAT/WASM | `%%WAT_BEGIN`, `%%WAT_END`, `%%WAT_FUNC_BEGIN`, `%%WAT_FUNC_END`, `%%WAT_IMPORT`, `%%WAT_EXPORT` |
| Asset | `%%ASSET_ROOT`, `%%ASSET_FILE`, `%%ASSET_COPY`, `%%ASSET_IMAGE`, `%%ASSET_AUDIO` |
| Manifest/JSON | `%%MANIFEST_SET`, `%%MANIFEST_REQUIRE`, `%%JSON_SET`, `%%JSON_BEGIN`, `%%JSON_END` |
| Güvenlik | `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SAFE_PATHS`, `%%REQUIRE_HOST_BINDING` |

## Compiler katman komutları

| Katman | Terminal komutu çekirdeği |
|---|---|
| Preprocess | `--pp A --preprocessed-out out.uxb --preprocess-result-json-out out.json` |
| Lexer | `--debug-token-dump --tokens-json-out tokens.json` |
| Parser/AST | `--parse-only --ast-json-out ast.json` |
| AST contract | `--ast-contract-check --ast-contract-json-out ast_contract.json` |
| Semantic/HIR | `--semantic --hir-json-out hir.json` |
| MIR | `--mir-verify --mir-json-out mir.json --mir-opcodes-json-out mir_opcodes.json` |
| AST run | `--execmem --interpreter-backend AST` |
| MIR run | `--execmem --interpreter-backend MIR` |
| JS | `--emit-js --js-out program.js` |
| WAT | `--emit-wat --wat-out program.wat` |
| WASM | `--emit-wasm --wasm-out program.wasm` |
| x64 | `--codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out program.asm` |

## Kanonik yanlış/doğru tablosu

| Yanlış | Doğru |
|---|---|
| `THREAT` | `THREAD` |
| `PARALLEL` | `PARALEL` |
| `MAGIC ... END METHOD` | `MAGIC ... END MAGIC` |
| `IMPORT DLL` | `CALL(DLL)` veya `DECLARE ... LIB ... ALIAS ...` |
| `IMPORT API` | `CALL(API)` |
| Hedefsiz raw JS | `%%TARGET WEB` veya uygun güvenlik kapısı altında JS üretimi |

> **Referans ekleri hakkında:** Aşağıdaki tablolar, kaynakta kayıtlı yüzeyi eksiksiz başvuru amacıyla verir. Bir anahtar sözcüğün lexer tablosunda bulunması tek başına her hedefte aynı davranışı garanti etmez; hedef ve katman ayrımı Bölüm 13, Bölüm 20, Bölüm 24 ve Ek F içinde açıklanır.

# Ek A - Kaynakta Kayıtlı Anahtar Sözcükler

| Sözcük | Aile | Görev |
| --- | --- | --- |
| IF | Koşul ve seçim | koşullu dallanma başlatır |
| THEN | Koşul ve seçim | IF koşulundan sonraki kolu açar |
| ELSE | Koşul ve seçim | alternatif kolu açar |
| ELSEIF | Koşul ve seçim | ek koşullu kol açar |
| END | Koşul ve seçim | blok kapatıcılarının ilk sözcüğüdür |
| SELECT | Koşul ve seçim | çok dallı seçim başlatır |
| CASE | Koşul ve seçim | SELECT içindeki seçeneği tanımlar |
| IS | Koşul ve seçim | CASE karşılaştırma biçimini açar |
| TRY | Hata yönetimi | korunan hata bloğunu başlatır |
| CATCH | Hata yönetimi | fırlatılan hatayı yakalar |
| FINALLY | Hata yönetimi | her durumda çalışacak son bloğu açar |
| THROW | Hata yönetimi | hata/değer fırlatır |
| ASSERT | Hata yönetimi | koşul yanlışsa hata üretir |
| EVENT | Olay ve görev sistemi | olay görevini tanımlar |
| THREAD | Olay ve görev sistemi | thread görevi tanımlar |
| PARALEL | Olay ve görev sistemi | paralel görev yüzeyini tanımlar |
| PIPE | Olay ve görev sistemi | girdi alan görev/boru tanımlar |
| SLOT | Olay ve görev sistemi | görev kimliği/yuvası belirtir |
| ON | Olay ve görev sistemi | görevi etkinleştirip kaydeder |
| OFF | Olay ve görev sistemi | görevi devre dışı bırakır |
| TRIGGER | Olay ve görev sistemi | kayıtlı görevi tetikler |
| FOR | Döngüler | döngüler ailesindeki `FOR` dil yüzeyidir |
| TO | Döngüler | döngüler ailesindeki `TO` dil yüzeyidir |
| STEP | Döngüler | döngüler ailesindeki `STEP` dil yüzeyidir |
| NEXT | Döngüler | döngüler ailesindeki `NEXT` dil yüzeyidir |
| DO | Döngüler | döngüler ailesindeki `DO` dil yüzeyidir |
| LOOP | Döngüler | döngüler ailesindeki `LOOP` dil yüzeyidir |
| WHILE | Döngüler | döngüler ailesindeki `WHILE` dil yüzeyidir |
| WEND | Döngüler | döngüler ailesindeki `WEND` dil yüzeyidir |
| UNTIL | Döngüler | döngüler ailesindeki `UNTIL` dil yüzeyidir |
| EXIT | Döngüler | döngüler ailesindeki `EXIT` dil yüzeyidir |
| EACH | Döngüler | döngüler ailesindeki `EACH` dil yüzeyidir |
| IN | Döngüler | döngüler ailesindeki `IN` dil yüzeyidir |
| SUB | Yordam ve çağrı | değer döndürmeyen yordam bildirir |
| FUNCTION | Yordam ve çağrı | değer döndüren yordam bildirir |
| DECLARE | Yordam ve çağrı | dış/ilerideki imzayı bildirir |
| RETURN | Yordam ve çağrı | yordamdan çıkar ve gerekirse değer döndürür |
| GOTO | Yordam ve çağrı | yordam ve çağrı ailesindeki `GOTO` dil yüzeyidir |
| GOSUB | Yordam ve çağrı | yordam ve çağrı ailesindeki `GOSUB` dil yüzeyidir |
| CALL | Yordam ve çağrı | yordam, DLL veya API çağrısı yapar |
| TYPE | Tip/nesne bildirimi | alanlardan oluşan kayıt tipi bildirir |
| CLASS | Tip/nesne bildirimi | veri ve metot içeren sınıf bildirir |
| INTERFACE | Tip/nesne bildirimi | uygulanacak davranış sözleşmesi bildirir |
| ENUM | Tip/nesne bildirimi | adlandırılmış sabitler kümesi bildirir |
| IMPLEMENTS | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `IMPLEMENTS` dil yüzeyidir |
| METHOD | Tip/nesne bildirimi | sınıf metodu bildirir |
| MAGIC | Tip/nesne bildirimi | özel nesne davranışı bildirir |
| VIRTUAL | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `VIRTUAL` dil yüzeyidir |
| OVERRIDE | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `OVERRIDE` dil yüzeyidir |
| CONSTRUCTOR | Tip/nesne bildirimi | kurucu bildirir |
| DESTRUCTOR | Tip/nesne bildirimi | yıkıcı bildirir |
| NEW | Tip/nesne bildirimi | nesne oluşturur |
| DELETE | Tip/nesne bildirimi | nesneyi/başvuruyu serbest bırakır |
| DIM | Tip/nesne bildirimi | değişken, dizi veya nesne başvurusu bildirir |
| REDIM | Tip/nesne bildirimi | diziyi yeniden boyutlandırır |
| AS | Tip/nesne bildirimi | tip belirtir |
| CONST | Tip/nesne bildirimi | sabit bildirir |
| INCLUDE | Tip/nesne bildirimi | uXBasic başlık/kaynak metnini ekler |
| IMPORT | Tip/nesne bildirimi | C/CPP/ASM kaynağını build planına alır |
| ABSTRACT | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `ABSTRACT` dil yüzeyidir |
| FINAL | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `FINAL` dil yüzeyidir |
| SEALED | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `SEALED` dil yüzeyidir |
| STATIC | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `STATIC` dil yüzeyidir |
| PROPERTY | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `PROPERTY` dil yüzeyidir |
| OPERATOR | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `OPERATOR` dil yüzeyidir |
| MIXIN | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `MIXIN` dil yüzeyidir |
| DECORATOR | Tip/nesne bildirimi | tip/nesne bildirimi ailesindeki `DECORATOR` dil yüzeyidir |
| PUBLIC | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `PUBLIC` dil yüzeyidir |
| PRIVATE | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `PRIVATE` dil yüzeyidir |
| PROTECTED | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `PROTECTED` dil yüzeyidir |
| RESTRICTED | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `RESTRICTED` dil yüzeyidir |
| FRIEND | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `FRIEND` dil yüzeyidir |
| READONLY | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `READONLY` dil yüzeyidir |
| MUTABLE | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `MUTABLE` dil yüzeyidir |
| IMMUTABLE | Erişim ve niteleyiciler | erişim ve niteleyiciler ailesindeki `IMMUTABLE` dil yüzeyidir |
| MAIN | Program/modül yapısı | program giriş bloğunu başlatır |
| NAMESPACE | Program/modül yapısı | ad alanı açar |
| MODULE | Program/modül yapısı | modül açar |
| USING | Program/modül yapısı | ad alanını görünür yapar |
| ALIAS | Program/modül yapısı | kısa ad tanımlar |
| DEFINT | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFINT` dil yüzeyidir |
| DEFLNG | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFLNG` dil yüzeyidir |
| DEFSNG | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFSNG` dil yüzeyidir |
| DEFDBL | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFDBL` dil yüzeyidir |
| DEFEXT | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFEXT` dil yüzeyidir |
| DEFSTR | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFSTR` dil yüzeyidir |
| DEFBYT | Varsayılan tip direktifleri | varsayılan tip direktifleri ailesindeki `DEFBYT` dil yüzeyidir |
| PRINT | Konsol ve dosya G/Ç | ekrana veya PRINT # ile dosyaya yazar |
| INPUT | Konsol ve dosya G/Ç | kullanıcıdan veya INPUT # ile dosyadan okur |
| OPEN | Konsol ve dosya G/Ç | dosya kanalı açar |
| CLOSE | Konsol ve dosya G/Ç | kanalı kapatır |
| GET | Konsol ve dosya G/Ç | ikili/veri okuma işlemi yapar |
| PUT | Konsol ve dosya G/Ç | ikili/veri yazma işlemi yapar |
| SEEK | Konsol ve dosya G/Ç | dosya konumunu değiştirir |
| CLS | Ekran komutları | ekran komutları ailesindeki `CLS` dil yüzeyidir |
| COLOR | Ekran komutları | ekran komutları ailesindeki `COLOR` dil yüzeyidir |
| LOCATE | Ekran komutları | ekran komutları ailesindeki `LOCATE` dil yüzeyidir |
| AND | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `AND` dil yüzeyidir |
| OR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `OR` dil yüzeyidir |
| ANDALSO | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `ANDALSO` dil yüzeyidir |
| ORELSE | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `ORELSE` dil yüzeyidir |
| NOT | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NOT` dil yüzeyidir |
| XOR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `XOR` dil yüzeyidir |
| MOD | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `MOD` dil yüzeyidir |
| SHL | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `SHL` dil yüzeyidir |
| SHR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `SHR` dil yüzeyidir |
| ROL | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `ROL` dil yüzeyidir |
| ROR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `ROR` dil yüzeyidir |
| NAND | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NAND` dil yüzeyidir |
| NOR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NOR` dil yüzeyidir |
| XNOR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `XNOR` dil yüzeyidir |
| NXOR | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NXOR` dil yüzeyidir |
| EQV | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `EQV` dil yüzeyidir |
| EQA | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `EQA` dil yüzeyidir |
| IFF | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `IFF` dil yüzeyidir |
| IMP | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `IMP` dil yüzeyidir |
| CIMP | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `CIMP` dil yüzeyidir |
| NIMP | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NIMP` dil yüzeyidir |
| NCIMP | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NCIMP` dil yüzeyidir |
| IDA | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `IDA` dil yüzeyidir |
| IDB | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `IDB` dil yüzeyidir |
| NOTA | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NOTA` dil yüzeyidir |
| NOTB | Mantık ve bit operatörleri | mantık ve bit operatörleri ailesindeki `NOTB` dil yüzeyidir |
| INLINE | INLINE ve SHELL ekleri | native NASM/MASM/GAS/C/CPP bloğu tanımlar |
| SHELL | INLINE ve SHELL ekleri | dış süreç çalıştırır |
| TIMEOUT | INLINE ve SHELL ekleri | SHELL zaman sınırı belirtir |
| OUTVAR | INLINE ve SHELL ekleri | SHELL stdout hedef değişkenini belirtir |
| ERRVAR | INLINE ve SHELL ekleri | SHELL stderr hedef değişkenini belirtir |
| CODEVAR | INLINE ve SHELL ekleri | SHELL çıkış kodu değişkenini belirtir |
| RUNPATH | INLINE ve SHELL ekleri | inline ve shell ekleri ailesindeki `RUNPATH` dil yüzeyidir |
| OUTPATH | INLINE ve SHELL ekleri | inline ve shell ekleri ailesindeki `OUTPATH` dil yüzeyidir |
| ERRPATH | INLINE ve SHELL ekleri | inline ve shell ekleri ailesindeki `ERRPATH` dil yüzeyidir |
| I8 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `I8` dil yüzeyidir |
| U8 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `U8` dil yüzeyidir |
| I16 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `I16` dil yüzeyidir |
| U16 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `U16` dil yüzeyidir |
| I32 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `I32` dil yüzeyidir |
| U32 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `U32` dil yüzeyidir |
| I64 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `I64` dil yüzeyidir |
| U64 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `U64` dil yüzeyidir |
| F32 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `F32` dil yüzeyidir |
| F64 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `F64` dil yüzeyidir |
| F80 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `F80` dil yüzeyidir |
| F128 | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `F128` dil yüzeyidir |
| BIGF | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `BIGF` dil yüzeyidir |
| BIGD | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `BIGD` dil yüzeyidir |
| BALL | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `BALL` dil yüzeyidir |
| BOOLEAN | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `BOOLEAN` dil yüzeyidir |
| STRING | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `STRING` dil yüzeyidir |
| OBJECT | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `OBJECT` dil yüzeyidir |
| PTR | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `PTR` dil yüzeyidir |
| STRPTR | Veri tipleri ve ABI | veri tipleri ve abi ailesindeki `STRPTR` dil yüzeyidir |
| BYREF | Veri tipleri ve ABI | parametreyi başvuruyla geçirir |
| BYVAL | Veri tipleri ve ABI | parametreyi değerle geçirir |
| CDECL | Veri tipleri ve ABI | C çağrı kuralını seçer |
| STDCALL | Veri tipleri ve ABI | stdcall çağrı kuralını seçer |
| TRUE | Veri tipleri ve ABI | BASIC doğru değeri -1 |
| FALSE | Veri tipleri ve ABI | yanlış değeri 0 |
| ZERO | Veri tipleri ve ABI | FALSE eş adı |
| ONE | Veri tipleri ve ABI | TRUE eş adı |
| ARRAY | Koleksiyonlar | koleksiyonlar ailesindeki `ARRAY` dil yüzeyidir |
| LIST | Koleksiyonlar | koleksiyonlar ailesindeki `LIST` dil yüzeyidir |
| DICT | Koleksiyonlar | koleksiyonlar ailesindeki `DICT` dil yüzeyidir |
| SET | Koleksiyonlar | koleksiyonlar ailesindeki `SET` dil yüzeyidir |
| SETSTRINGSIZE | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SETSTRINGSIZE` dil yüzeyidir |
| TIMER | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `TIMER` dil yüzeyidir |
| LOF | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `LOF` dil yüzeyidir |
| EOF | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `EOF` dil yüzeyidir |
| LEN | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `LEN` dil yüzeyidir |
| MID | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `MID` dil yüzeyidir |
| STR | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `STR` dil yüzeyidir |
| VAL | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `VAL` dil yüzeyidir |
| ABS | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `ABS` dil yüzeyidir |
| INT | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `INT` dil yüzeyidir |
| UCASE | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `UCASE` dil yüzeyidir |
| LCASE | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `LCASE` dil yüzeyidir |
| ASC | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `ASC` dil yüzeyidir |
| CHR | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `CHR` dil yüzeyidir |
| LTRIM | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `LTRIM` dil yüzeyidir |
| RTRIM | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `RTRIM` dil yüzeyidir |
| STRING | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `STRING` dil yüzeyidir |
| SPACE | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SPACE` dil yüzeyidir |
| SGN | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SGN` dil yüzeyidir |
| SQRT | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SQRT` dil yüzeyidir |
| SIN | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SIN` dil yüzeyidir |
| COS | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `COS` dil yüzeyidir |
| TAN | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `TAN` dil yüzeyidir |
| ATN | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `ATN` dil yüzeyidir |
| EXP | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `EXP` dil yüzeyidir |
| LOG | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `LOG` dil yüzeyidir |
| INKEY | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `INKEY` dil yüzeyidir |
| GETKEY | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `GETKEY` dil yüzeyidir |
| VARPTR | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `VARPTR` dil yüzeyidir |
| SADD | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SADD` dil yüzeyidir |
| LPTR | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `LPTR` dil yüzeyidir |
| CODEPTR | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `CODEPTR` dil yüzeyidir |
| SIZEOF | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `SIZEOF` dil yüzeyidir |
| OFFSETOF | Yerleşik fonksiyonlar | yerleşik fonksiyonlar ailesindeki `OFFSETOF` dil yüzeyidir |
| CINT | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `CINT` dil yüzeyidir |
| CLNG | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `CLNG` dil yüzeyidir |
| CDBL | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `CDBL` dil yüzeyidir |
| CSNG | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `CSNG` dil yüzeyidir |
| FIX | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `FIX` dil yüzeyidir |
| SQR | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `SQR` dil yüzeyidir |
| RND | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `RND` dil yüzeyidir |
| RANDOMIZE | Sayısal dönüşümler | sayısal dönüşümler ailesindeki `RANDOMIZE` dil yüzeyidir |
| PEEKB | Bellek işlemleri | bellek işlemleri ailesindeki `PEEKB` dil yüzeyidir |
| PEEKW | Bellek işlemleri | bellek işlemleri ailesindeki `PEEKW` dil yüzeyidir |
| PEEKD | Bellek işlemleri | bellek işlemleri ailesindeki `PEEKD` dil yüzeyidir |
| POKE | Bellek işlemleri | bellek işlemleri ailesindeki `POKE` dil yüzeyidir |
| POKEB | Bellek işlemleri | bellek işlemleri ailesindeki `POKEB` dil yüzeyidir |
| POKEW | Bellek işlemleri | bellek işlemleri ailesindeki `POKEW` dil yüzeyidir |
| POKED | Bellek işlemleri | bellek işlemleri ailesindeki `POKED` dil yüzeyidir |
| POKES | Bellek işlemleri | bellek işlemleri ailesindeki `POKES` dil yüzeyidir |
| MEMCOPYB | Bellek işlemleri | bellek işlemleri ailesindeki `MEMCOPYB` dil yüzeyidir |
| MEMCOPYW | Bellek işlemleri | bellek işlemleri ailesindeki `MEMCOPYW` dil yüzeyidir |
| MEMCOPYD | Bellek işlemleri | bellek işlemleri ailesindeki `MEMCOPYD` dil yüzeyidir |
| MEMFILLB | Bellek işlemleri | bellek işlemleri ailesindeki `MEMFILLB` dil yüzeyidir |
| MEMFILLW | Bellek işlemleri | bellek işlemleri ailesindeki `MEMFILLW` dil yüzeyidir |
| MEMFILLD | Bellek işlemleri | bellek işlemleri ailesindeki `MEMFILLD` dil yüzeyidir |
| SETNEWOFFSET | Bellek işlemleri | bellek işlemleri ailesindeki `SETNEWOFFSET` dil yüzeyidir |
| INC | Bellek işlemleri | bellek işlemleri ailesindeki `INC` dil yüzeyidir |
| DEC | Bellek işlemleri | bellek işlemleri ailesindeki `DEC` dil yüzeyidir |
| DIM | Dil yüzeyi | değişken, dizi veya nesne başvurusu bildirir |
| REDIM | Dil yüzeyi | diziyi yeniden boyutlandırır |
| CONST | Dil yüzeyi | sabit bildirir |
| FUNCTION | Dil yüzeyi | değer döndüren yordam bildirir |
| SUB | Dil yüzeyi | değer döndürmeyen yordam bildirir |
| TYPE | Dil yüzeyi | alanlardan oluşan kayıt tipi bildirir |
| CLASS | Dil yüzeyi | veri ve metot içeren sınıf bildirir |
| INTERFACE | Dil yüzeyi | uygulanacak davranış sözleşmesi bildirir |
| ENUM | Dil yüzeyi | adlandırılmış sabitler kümesi bildirir |
| NAMESPACE | Dil yüzeyi | ad alanı açar |
| MODULE | Dil yüzeyi | modül açar |
| ALIAS | Dil yüzeyi | kısa ad tanımlar |
| USING | Dil yüzeyi | ad alanını görünür yapar |
| INCLUDE | Dil yüzeyi | uXBasic başlık/kaynak metnini ekler |
| PUBLIC | Dil yüzeyi | dil yüzeyi ailesindeki `PUBLIC` dil yüzeyidir |
| PRIVATE | Dil yüzeyi | dil yüzeyi ailesindeki `PRIVATE` dil yüzeyidir |
| PROTECTED | Dil yüzeyi | dil yüzeyi ailesindeki `PROTECTED` dil yüzeyidir |
| FRIEND | Dil yüzeyi | dil yüzeyi ailesindeki `FRIEND` dil yüzeyidir |
| STATIC | Dil yüzeyi | dil yüzeyi ailesindeki `STATIC` dil yüzeyidir |
| ABSTRACT | Dil yüzeyi | dil yüzeyi ailesindeki `ABSTRACT` dil yüzeyidir |
| FINAL | Dil yüzeyi | dil yüzeyi ailesindeki `FINAL` dil yüzeyidir |
| SEALED | Dil yüzeyi | dil yüzeyi ailesindeki `SEALED` dil yüzeyidir |
| PROPERTY | Dil yüzeyi | dil yüzeyi ailesindeki `PROPERTY` dil yüzeyidir |
| METHOD | Dil yüzeyi | sınıf metodu bildirir |
| OPERATOR | Dil yüzeyi | dil yüzeyi ailesindeki `OPERATOR` dil yüzeyidir |
| AS | Dil yüzeyi | tip belirtir |
| BYVAL | Dil yüzeyi | parametreyi değerle geçirir |
| BYREF | Dil yüzeyi | parametreyi başvuruyla geçirir |
| DECLARE | Dil yüzeyi | dış/ilerideki imzayı bildirir |

# Ek B - Yerleşik Fonksiyonlar

| Fonksiyon | Görev | Genel syntax |
| --- | --- | --- |
| ABS | mutlak değer | ABS(...) |
| SQR | karekök (klasik ad) | SQR(...) |
| SQRT | karekök | SQRT(...) |
| SIN | sinüs | SIN(...) |
| COS | kosinüs | COS(...) |
| TAN | tanjant | TAN(...) |
| ATN | arktanjant | ATN(...) |
| LOG | doğal logaritma | LOG(...) |
| EXP | üstel fonksiyon | EXP(...) |
| FIX | kesir kısmını sıfıra doğru atar | FIX(...) |
| INT | aşağı yuvarlar | INT(...) |
| SGN | işaret döndürür | SGN(...) |
| RND | rastgele sayı üretir | RND(...) |
| RANDOMIZE | rastgele sayı üretecini tohumlar | RANDOMIZE [tohum] |
| TIMER | zaman sayacı döndürür | TIMER(...) |
| CINT | I32 dönüşümü | CINT(...) |
| CLNG | uzun tamsayı dönüşümü | CLNG(...) |
| CSNG | F32 dönüşümü | CSNG(...) |
| CDBL | F64 dönüşümü | CDBL(...) |
| LEN | metin uzunluğu | LEN(...) |
| LEFT | soldan parça | LEFT(...) |
| RIGHT | sağdan parça | RIGHT(...) |
| MID | ortadan parça | MID(...) |
| INSTR | alt metin konumu | INSTR(...) |
| ASC | karakter kodu | ASC(...) |
| CHR | koddan karakter | CHR(...) |
| VAL | metni sayıya çevirir | VAL(...) |
| STR | sayıyı metne çevirir | STR(...) |
| LCASE | küçük harf | LCASE(...) |
| UCASE | büyük harf | UCASE(...) |
| LTRIM | sol boşlukları siler | LTRIM(...) |
| RTRIM | sağ boşlukları siler | RTRIM(...) |
| TRIM | iki uç boşluklarını siler | TRIM(...) |
| SPACE | boşluk metni üretir | SPACE(...) |
| HEX | onaltılık metin | HEX(...) |
| OCT | sekizlik metin | OCT(...) |
| BIN | ikilik metin | BIN(...) |
| INKEY | tuşu beklemeden okur | INKEY(...) |
| GETKEY | tuş girdisi okur | GETKEY(...) |
| VARPTR | değişken adresi | VARPTR(...) |
| SADD | string veri adresi | SADD(...) |
| LPTR | düşük seviye işaretçi | LPTR(...) |
| CODEPTR | kod/yordam adresi | CODEPTR(...) |
| SIZEOF | tip/değer boyutu | SIZEOF(...) |
| OFFSETOF | alanın tip içindeki ofseti | OFFSETOF(...) |
| LOF | dosya uzunluğu | LOF(...) |
| EOF | dosya sonu kontrolü | EOF(...) |
| BIGINIT | büyük sayı runtime değeri oluşturur | BIGINIT(...) |
| LISTLEN | liste uzunluğu | LISTLEN(...) |
| LISTGET | liste öğesi okur | LISTGET(...) |
| LISTSET | liste öğesi yazar | LISTSET(...) |
| LISTADD | listeye ekler | LISTADD(...) |
| LISTREMOVE | listeden siler | LISTREMOVE(...) |
| LISTCLEAR | listeyi temizler | LISTCLEAR(...) |
| DICTLEN | sözlük boyutu | DICTLEN(...) |
| DICTHAS | anahtar var mı | DICTHAS(...) |
| DICTGET | sözlük değeri okur | DICTGET(...) |
| DICTSET | sözlük değeri yazar | DICTSET(...) |
| DICTCLEAR | sözlüğü temizler | DICTCLEAR(...) |
| SETLEN | küme boyutu | SETLEN(...) |
| SETHAS | kümede var mı | SETHAS(...) |
| SETADD | kümeye ekler | SETADD(...) |
| SETREMOVE | kümeden siler | SETREMOVE(...) |
| SETCLEAR | kümeyi temizler | SETCLEAR(...) |

# Ek C - Preprocessor A/B Tam Yönerge Dizini

| Yönerge | Aile | Görev | Genel syntax |
| --- | --- | --- | --- |
| %%PP | Motor seçimi | A veya B preprocessor motorunu seçer | %%PP ... |
| %%DEFINE | Makro ve koşul | makro/değer tanımlar | %%DEFINE ... |
| %%MACRO | Makro ve koşul | makro tanımlar | %%MACRO ... |
| %%UNDEF | Makro ve koşul | tanımı kaldırır | %%UNDEF ... |
| %%IF | Makro ve koşul | meta koşul başlatır | %%IF ... |
| %%IFN | Makro ve koşul | sayısal/negatif meta koşul kurar | %%IFN ... |
| %%IFC | Makro ve koşul | iki metni karşılaştırır | %%IFC ... |
| %%ELIF | Makro ve koşul | ek meta koşul kolu | %%ELIF ... |
| %%ELSE | Makro ve koşul | alternatif meta kolu | %%ELSE ... |
| %%ENDIF | Makro ve koşul | meta koşulu kapatır | %%ENDIF ... |
| %%INCLUDE | Dosya/ayar/değer | başka dosyayı preprocess aşamasında ekler | %%INCLUDE ... |
| %%ALIAS | Dosya/ayar/değer | metin/makro eşlemesi tanımlar | %%ALIAS ... |
| %%SET | Dosya/ayar/değer | meta değer ayarlar | %%SET ... |
| %%EVAL | Dosya/ayar/değer | basit derleme zamanı değeri hesaplar | %%EVAL ... |
| %%PROFILE | Dosya/ayar/değer | `PROFILE` adlı derleme zamanı/meta işlemini yürütür | %%PROFILE ... |
| %%CONFIG_FILE | Dosya/ayar/değer | `CONFIG_FILE` adlı derleme zamanı/meta işlemini yürütür | %%CONFIG_FILE ... |
| %%PATH_ALIAS | Dosya/ayar/değer | yol takma adı tanımlar | %%PATH_ALIAS ... |
| %%LOCK_META | Metadata ve tanı | `LOCK_META` adlı derleme zamanı/meta işlemini yürütür | %%LOCK_META ... |
| %%DUMP_META | Metadata ve tanı | `DUMP_META` adlı derleme zamanı/meta işlemini yürütür | %%DUMP_META ... |
| %%SOURCE_MAP | Metadata ve tanı | `SOURCE_MAP` adlı derleme zamanı/meta işlemini yürütür | %%SOURCE_MAP ... |
| %%EMITNOTE | Metadata ve tanı | `EMITNOTE` adlı derleme zamanı/meta işlemini yürütür | %%EMITNOTE ... |
| %%ENV | Metadata ve tanı | ortam değişkenini meta ada bağlar | %%ENV ... |
| %%DEPRECATED | Metadata ve tanı | `DEPRECATED` adlı derleme zamanı/meta işlemini yürütür | %%DEPRECATED ... |
| %%TEMPLATE | Şablon | `TEMPLATE` adlı derleme zamanı/meta işlemini yürütür | %%TEMPLATE ... |
| %%TEMPLATE_BEGIN | Şablon | `TEMPLATE_BEGIN` adlı derleme zamanı/meta işlemini yürütür | %%TEMPLATE_BEGIN ... |
| %%TEMPLATE_END | Şablon | `TEMPLATE_END` adlı derleme zamanı/meta işlemini yürütür | %%TEMPLATE_END ... |
| %%TEMPLATE_USE | Şablon | `TEMPLATE_USE` adlı derleme zamanı/meta işlemini yürütür | %%TEMPLATE_USE ... |
| %%MINIFY | Paket/asset optimizasyonu | `MINIFY` adlı derleme zamanı/meta işlemini yürütür | %%MINIFY ... |
| %%FINGERPRINT_ASSETS | Paket/asset optimizasyonu | `FINGERPRINT_ASSETS` adlı derleme zamanı/meta işlemini yürütür | %%FINGERPRINT_ASSETS ... |
| %%HASHFILE | Paket/asset optimizasyonu | dosya hashini meta değere alır | %%HASHFILE ... |
| %%COPY_DIR | Paket/asset optimizasyonu | `COPY_DIR` adlı derleme zamanı/meta işlemini yürütür | %%COPY_DIR ... |
| %%EMBEDTEXT | Gömme ve lisans | dosyayı metin olarak gömer | %%EMBEDTEXT ... |
| %%EMBEDBASE64 | Gömme ve lisans | dosyayı base64 olarak gömer | %%EMBEDBASE64 ... |
| %%LICENSEFILE | Gömme ve lisans | `LICENSEFILE` adlı derleme zamanı/meta işlemini yürütür | %%LICENSEFILE ... |
| %%HTMLIMAGE | Gömme ve lisans | `HTMLIMAGE` adlı derleme zamanı/meta işlemini yürütür | %%HTMLIMAGE ... |
| %%HTMLAUDIO | Gömme ve lisans | `HTMLAUDIO` adlı derleme zamanı/meta işlemini yürütür | %%HTMLAUDIO ... |
| %%CSS_RULE | CSS/Markdown ve akış | `CSS_RULE` adlı derleme zamanı/meta işlemini yürütür | %%CSS_RULE ... |
| %%CSS_IMPORT | CSS/Markdown ve akış | `CSS_IMPORT` adlı derleme zamanı/meta işlemini yürütür | %%CSS_IMPORT ... |
| %%MD_SAFE | CSS/Markdown ve akış | `MD_SAFE` adlı derleme zamanı/meta işlemini yürütür | %%MD_SAFE ... |
| %%MD_CSS | CSS/Markdown ve akış | `MD_CSS` adlı derleme zamanı/meta işlemini yürütür | %%MD_CSS ... |
| %%BREAK | CSS/Markdown ve akış | meta döngüyü keser | %%BREAK ... |
| %%CONTINUE | CSS/Markdown ve akış | meta döngüde sonraki adıma geçer | %%CONTINUE ... |
| %%INFOMETA | CSS/Markdown ve akış | bilgi mesajı üretir | %%INFOMETA ... |
| %%ALLOW_RAW_JS | Güvenlik kapıları | ham JavaScript bloklarına izin verir | %%ALLOW_RAW_JS ... |
| %%ALLOW_RAW_WAT | Güvenlik kapıları | ham WAT bloklarına izin verir | %%ALLOW_RAW_WAT ... |
| %%SAFE_PATHS | Güvenlik kapıları | güvenli yol kapısını açar/kapatır | %%SAFE_PATHS ... |
| %%REQUIRE_HOST_BINDING | Güvenlik kapıları | host binding zorunluluğu koyar | %%REQUIRE_HOST_BINDING ... |
| %%ASSERT_META | Güvenlik kapıları | meta koşulu zorunlu kılar | %%ASSERT_META ... |
| %%WARN_META | Güvenlik kapıları | uyarı üretir | %%WARN_META ... |
| %%TARGET | Hedef ve asset | hedef türünü seçer | %%TARGET ... |
| %%OUTDIR | Hedef ve asset | çıktı dizinini ayarlar | %%OUTDIR ... |
| %%ASSET_ROOT | Hedef ve asset | asset kökünü ayarlar | %%ASSET_ROOT ... |
| %%EXPANDLIMIT | Hedef ve asset | `EXPANDLIMIT` adlı derleme zamanı/meta işlemini yürütür | %%EXPANDLIMIT ... |
| %%ASSET_COPY | Hedef ve asset | `ASSET_COPY` adlı derleme zamanı/meta işlemini yürütür | %%ASSET_COPY ... |
| %%ASSET_FILE | Hedef ve asset | `ASSET_FILE` adlı derleme zamanı/meta işlemini yürütür | %%ASSET_FILE ... |
| %%ASSET_IMAGE | Hedef ve asset | `ASSET_IMAGE` adlı derleme zamanı/meta işlemini yürütür | %%ASSET_IMAGE ... |
| %%ASSET_AUDIO | Hedef ve asset | `ASSET_AUDIO` adlı derleme zamanı/meta işlemini yürütür | %%ASSET_AUDIO ... |
| %%ASSET_REQUIRE | Hedef ve asset | `ASSET_REQUIRE` adlı derleme zamanı/meta işlemini yürütür | %%ASSET_REQUIRE ... |
| %%MANIFEST_SET | Manifest/Web/WAT satırları | manifest alanı yazar | %%MANIFEST_SET ... |
| %%MANIFEST_REQUIRE | Manifest/Web/WAT satırları | manifest alanını zorunlu kılar | %%MANIFEST_REQUIRE ... |
| %%WAT_IMPORT | Manifest/Web/WAT satırları | WAT import sözleşmesi ekler | %%WAT_IMPORT ... |
| %%WAT_EXPORT | Manifest/Web/WAT satırları | WAT export sözleşmesi ekler | %%WAT_EXPORT ... |
| %%JS_LINE | Manifest/Web/WAT satırları | `JS_LINE` adlı derleme zamanı/meta işlemini yürütür | %%JS_LINE ... |
| %%HTML_LINE | Manifest/Web/WAT satırları | `HTML_LINE` adlı derleme zamanı/meta işlemini yürütür | %%HTML_LINE ... |
| %%CSS_LINE | Manifest/Web/WAT satırları | `CSS_LINE` adlı derleme zamanı/meta işlemini yürütür | %%CSS_LINE ... |
| %%JSON_SET | Manifest/Web/WAT satırları | `JSON_SET` adlı derleme zamanı/meta işlemini yürütür | %%JSON_SET ... |
| %%SECTION | Blok başlangıç/sonları | `SECTION` adlı derleme zamanı/meta işlemini yürütür | %%SECTION ... |
| %%ENDSECTION | Blok başlangıç/sonları | `ENDSECTION` adlı derleme zamanı/meta işlemini yürütür | %%ENDSECTION ... |
| %%JS_BEGIN | Blok başlangıç/sonları | ham JS bloğu başlatır | %%JS_BEGIN ... |
| %%JS_END | Blok başlangıç/sonları | ham JS bloğunu kapatır | %%JS_END ... |
| %%WAT_BEGIN | Blok başlangıç/sonları | WAT bloğu başlatır | %%WAT_BEGIN ... |
| %%WAT_END | Blok başlangıç/sonları | WAT bloğunu kapatır | %%WAT_END ... |
| %%WAT_FUNC_BEGIN | Blok başlangıç/sonları | `WAT_FUNC_BEGIN` adlı derleme zamanı/meta işlemini yürütür | %%WAT_FUNC_BEGIN ... |
| %%WAT_FUNC_END | Blok başlangıç/sonları | `WAT_FUNC_END` adlı derleme zamanı/meta işlemini yürütür | %%WAT_FUNC_END ... |
| %%WASM_HOST_JS_BEGIN | WASM/HTML/CSS blokları | `WASM_HOST_JS_BEGIN` adlı derleme zamanı/meta işlemini yürütür | %%WASM_HOST_JS_BEGIN ... |
| %%WASM_HOST_JS_END | WASM/HTML/CSS blokları | `WASM_HOST_JS_END` adlı derleme zamanı/meta işlemini yürütür | %%WASM_HOST_JS_END ... |
| %%HTML_BEGIN | WASM/HTML/CSS blokları | HTML bloğu başlatır | %%HTML_BEGIN ... |
| %%HTML_END | WASM/HTML/CSS blokları | HTML bloğunu kapatır | %%HTML_END ... |
| %%CSS_BEGIN | WASM/HTML/CSS blokları | CSS bloğu başlatır | %%CSS_BEGIN ... |
| %%CSS_END | WASM/HTML/CSS blokları | CSS bloğunu kapatır | %%CSS_END ... |
| %%JSON_BEGIN | JSON/Markdown blokları | JSON bloğu başlatır | %%JSON_BEGIN ... |
| %%JSON_END | JSON/Markdown blokları | JSON bloğunu kapatır | %%JSON_END ... |
| %%JSON_ARRAY_BEGIN | JSON/Markdown blokları | `JSON_ARRAY_BEGIN` adlı derleme zamanı/meta işlemini yürütür | %%JSON_ARRAY_BEGIN ... |
| %%JSON_ARRAY_END | JSON/Markdown blokları | `JSON_ARRAY_END` adlı derleme zamanı/meta işlemini yürütür | %%JSON_ARRAY_END ... |
| %%MD_BEGIN | JSON/Markdown blokları | Markdown bloğu başlatır | %%MD_BEGIN ... |
| %%MD_END | JSON/Markdown blokları | Markdown bloğunu kapatır | %%MD_END ... |
| %%FOR | Meta döngüleri | meta sayaç döngüsü başlatır | %%FOR ... |
| %%FOREACH | Meta döngüleri | meta koleksiyon döngüsü başlatır | %%FOREACH ... |
| %%ENDFOR | Meta döngüleri | `ENDFOR` adlı derleme zamanı/meta işlemini yürütür | %%ENDFOR ... |
| %%ENDFOREACH | Meta döngüleri | `ENDFOREACH` adlı derleme zamanı/meta işlemini yürütür | %%ENDFOREACH ... |
| %%NEXTMETA | Meta döngüleri | `NEXTMETA` adlı derleme zamanı/meta işlemini yürütür | %%NEXTMETA ... |
| %%REPEAT | Meta döngüleri | meta tekrar bloğu başlatır | %%REPEAT ... |
| %%ENDREPEAT | Meta döngüleri | `ENDREPEAT` adlı derleme zamanı/meta işlemini yürütür | %%ENDREPEAT ... |
| %%UNTILMETA | Meta döngüleri | `UNTILMETA` adlı derleme zamanı/meta işlemini yürütür | %%UNTILMETA ... |
| %%PLATFORM | Platform/derleme güvenliği | host platformunu doğrular | %%PLATFORM ... |
| %%DESTOS | Platform/derleme güvenliği | hedef işletim sistemi metası ayarlar | %%DESTOS ... |
| %%NOZEROVARS | Platform/derleme güvenliği | otomatik sıfırlama politikasını ayarlar | %%NOZEROVARS ... |
| %%SECSTACK | Platform/derleme güvenliği | güvenli stack politikasını ayarlar | %%SECSTACK ... |
| %%ENDCOMP | Platform/derleme güvenliği | derlemeyi kontrollü sonlandırır | %%ENDCOMP ... |
| %%ERRORENDCOMP | Platform/derleme güvenliği | hata mesajıyla derlemeyi sonlandırır | %%ERRORENDCOMP ... |
| %%BUNDLE_NAME | Paket kimliği | `BUNDLE_NAME` adlı derleme zamanı/meta işlemini yürütür | %%BUNDLE_NAME ... |
| %%BUNDLE_VERSION | Paket kimliği | `BUNDLE_VERSION` adlı derleme zamanı/meta işlemini yürütür | %%BUNDLE_VERSION ... |
| %%BUNDLE_ID | Paket kimliği | `BUNDLE_ID` adlı derleme zamanı/meta işlemini yürütür | %%BUNDLE_ID ... |
| %%AUTHOR | Paket kimliği | `AUTHOR` adlı derleme zamanı/meta işlemini yürütür | %%AUTHOR ... |
| %%LICENSE | Paket kimliği | `LICENSE` adlı derleme zamanı/meta işlemini yürütür | %%LICENSE ... |
| %%BUILD_ID | Paket kimliği | `BUILD_ID` adlı derleme zamanı/meta işlemini yürütür | %%BUILD_ID ... |
| %%SANDBOX_ROOT | Browser güvenlik metası | `SANDBOX_ROOT` adlı derleme zamanı/meta işlemini yürütür | %%SANDBOX_ROOT ... |
| %%BROWSER_ENTRY | Browser güvenlik metası | `BROWSER_ENTRY` adlı derleme zamanı/meta işlemini yürütür | %%BROWSER_ENTRY ... |
| %%SCRIPT_ENTRY | Browser güvenlik metası | `SCRIPT_ENTRY` adlı derleme zamanı/meta işlemini yürütür | %%SCRIPT_ENTRY ... |
| %%STYLE_ENTRY | Browser güvenlik metası | `STYLE_ENTRY` adlı derleme zamanı/meta işlemini yürütür | %%STYLE_ENTRY ... |
| %%DATA_JSON | Browser güvenlik metası | `DATA_JSON` adlı derleme zamanı/meta işlemini yürütür | %%DATA_JSON ... |
| %%CSP | Browser güvenlik metası | `CSP` adlı derleme zamanı/meta işlemini yürütür | %%CSP ... |
| %%SECURITY_NOTE | Browser güvenlik metası | `SECURITY_NOTE` adlı derleme zamanı/meta işlemini yürütür | %%SECURITY_NOTE ... |
| %%CAPABILITY | Uygulama/host üretim metası | `CAPABILITY` adlı derleme zamanı/meta işlemini yürütür | %%CAPABILITY ... |
| %%EXPORT_BASIC | Uygulama/host üretim metası | `EXPORT_BASIC` adlı derleme zamanı/meta işlemini yürütür | %%EXPORT_BASIC ... |
| %%API_ENDPOINT | Uygulama/host üretim metası | `API_ENDPOINT` adlı derleme zamanı/meta işlemini yürütür | %%API_ENDPOINT ... |
| %%ROUTE | Uygulama/host üretim metası | `ROUTE` adlı derleme zamanı/meta işlemini yürütür | %%ROUTE ... |
| %%REQUIRE_ASSET | Uygulama/host üretim metası | `REQUIRE_ASSET` adlı derleme zamanı/meta işlemini yürütür | %%REQUIRE_ASSET ... |
| %%HOST_IMPORT | Uygulama/host üretim metası | `HOST_IMPORT` adlı derleme zamanı/meta işlemini yürütür | %%HOST_IMPORT ... |
| %%GEN_FILE | Uygulama/host üretim metası | `GEN_FILE` adlı derleme zamanı/meta işlemini yürütür | %%GEN_FILE ... |
| %%FEATURE | Uygulama/host üretim metası | `FEATURE` adlı derleme zamanı/meta işlemini yürütür | %%FEATURE ... |
| %%TEST_EXPECT | Uygulama/host üretim metası | `TEST_EXPECT` adlı derleme zamanı/meta işlemini yürütür | %%TEST_EXPECT ... |
| %%DOC | Uygulama/host üretim metası | `DOC` adlı derleme zamanı/meta işlemini yürütür | %%DOC ... |
| %%GEN_BLOCK | Uygulama/host üretim metası | `GEN_BLOCK` adlı derleme zamanı/meta işlemini yürütür | %%GEN_BLOCK ... |
| %%GEN_END | Uygulama/host üretim metası | `GEN_END` adlı derleme zamanı/meta işlemini yürütür | %%GEN_END ... |

# Ek D - CLI Uzun Seçenek Dizini

167 civarında uzun seçenek vardır. Başlangıçta fiilleri kullan; ayrıntılı rapor ve build otomasyonunda uzun seçeneklere geç.

| Seçenek | Aile | Görev |
| --- | --- | --- |
| --active-bind-plan-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --active-bind-plan-txt-out | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --adim25-26-27-close-gate | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --adim25-27-close-gate | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --all-diagnostics-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --artifact-report-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --artifact-root | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-contract-check | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-contract-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-contract-matrix-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-contract-report-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-exec-result-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-live-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-program-output-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-stderr-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ast-stdout-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ayikla | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --backend-matrix-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --backend-report-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --browser-index-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --build-x64 | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --build-x64-out | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --canonical-mir-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --codegen | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --codegen-source | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --console-mode | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --debug | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --debug-log-out | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --debug-token-dump | Lexer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --diag-format | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --doc | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --doc-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --dump-ast | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --dump-mir | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-browser | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-js | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-nasm | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-wasm | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-wat | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-x64-nasm | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-x64-nasm-out | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --emit-x86 | Eski x86 izi | Kaynakta kayıtlıdır; güncel dağıtımda aktif hedef değildir |
| --enable-extfp-runtime | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --enable-mir-x64 | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --error-language-file | Genel | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --error-limit | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --error-log-out | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --error-summary-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --error-to-terminal | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --execmem | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --extfp-diagnostics | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --extfp-policy-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --extfp-runtime-dir | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --extfp-strict | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --extract-src | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --final-screen-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --format-check | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --help | Genel | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --hir-inventory-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --hir-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --hook-trace | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --html-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --interop | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --interpreter-backend | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --interpreter-compare-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --inventory-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --ir-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --js-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --js-report-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --js-runtime-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --language | Genel | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --layer-timing-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --layout-report-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --lexer-diagnostics-json-out | Lexer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --log-out | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --manifest-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --message-lang | Genel | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-exec-result-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-full-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-live-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-module-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-opcodes-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-opt-report-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-pipeline-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-program-output-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-stderr-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-stdout-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-surface-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-verify | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-verify-canonical-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-verify-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-verify-semantic-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --mir-x64-required-opcode-gate-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --original-source-out | Preprocessor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --out-root | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --parse-only | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --parser-ast-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --parser-diagnostics-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --parser-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --parser-surface-contract-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --pipeline-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --pp | Preprocessor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --preprocess-result-json-out | Preprocessor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --preprocessed-out | Preprocessor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --preprocessor | Preprocessor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --program-output-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --program-output-out | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --quiet | Genel | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --release-gate | Doğrulama | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --release-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --run-id | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --run-manifest-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --run-report-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --runtime-route-matrix-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --runtime-trace-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic-diagnostics-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic-enums-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic-layouts-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic-mir-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantic-types-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --semantik | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --session-live-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --sessiz | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --source | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --source-map | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --source-map-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --stderr-out | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --stdout-out | Çalıştırma | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --stop-after | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --strict | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --symbol-table-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --target | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --target-browser | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --target-js | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --target-wasm | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --target-wat | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --target-x86 | Eski x86 izi | Kaynakta kayıtlıdır; güncel dağıtımda aktif hedef değildir |
| --time-passes | Diğer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --token-json-out | Lexer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --tokens-json-out | Lexer | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --trace | Tanı/Rapor | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --trace-json | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --type-cast-report-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --type-infer-report-csv-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --type-table-json-out | Semantic/HIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --validate-all | Doğrulama | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --validate-all-fail-fast | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --validate-all-report-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --version | Genel | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --vscode-diagnostics-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --wasm-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --wasm-report-json-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --wasm-wat-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --wat-out | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --wat2wasm | Web hedefleri | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64 | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64-ast-report-json-out | Parser/AST | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64-codegen-policy-json-out | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64-mir-report-json-out | MIR | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64-mode | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64gen | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |
| --x64gen-out | x64/Build | Kaynakta kayıtlı uzun CLI seçeneği; ilgili bölümdeki fiil veya çıktı sözleşmesiyle kullanılır |

# Ek E - Standart Kütüphaneler ve Tam İmza Dizini


## uxaimath

Aktivasyonlar, kayıp fonksiyonları, başlatıcılar ve yapay zeka matematiği. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| Backend | FUNCTION Backend() AS STRING | etkin backend adını döndürür |
| Seed | SUB Seed(seed AS U64) | `seed` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Sigmoid | FUNCTION Sigmoid(x AS F64) AS F64 | sigmoid aktivasyonunu hesaplar |
| ReLU | FUNCTION ReLU(x AS F64) AS F64 | ReLU aktivasyonunu hesaplar |
| LeakyReLU | FUNCTION LeakyReLU(x AS F64, alpha AS F64) AS F64 | Leaky ReLU aktivasyonunu hesaplar |
| ELU | FUNCTION ELU(x AS F64, alpha AS F64) AS F64 | ELU aktivasyonunu hesaplar |
| GELU | FUNCTION GELU(x AS F64) AS F64 | GELU aktivasyonunu hesaplar |
| Swish | FUNCTION Swish(x AS F64) AS F64 | Swish aktivasyonunu hesaplar |
| Softplus | FUNCTION Softplus(x AS F64) AS F64 | Softplus aktivasyonunu hesaplar |
| ApplySigmoidPtr | SUB ApplySigmoidPtr(dataPtr AS U64, n AS I64) | ham veri adresi/işaretçisi döndürür |
| ApplyTanhPtr | SUB ApplyTanhPtr(dataPtr AS U64, n AS I64) | ham veri adresi/işaretçisi döndürür |
| ApplyReLUPtr | SUB ApplyReLUPtr(dataPtr AS U64, n AS I64) | ham veri adresi/işaretçisi döndürür |
| ApplyLeakyReLUPtr | SUB ApplyLeakyReLUPtr(dataPtr AS U64, n AS I64, alpha AS F64) | ham veri adresi/işaretçisi döndürür |
| ApplyELUPtr | SUB ApplyELUPtr(dataPtr AS U64, n AS I64, alpha AS F64) | ham veri adresi/işaretçisi döndürür |
| ApplyGELUPtr | SUB ApplyGELUPtr(dataPtr AS U64, n AS I64) | ham veri adresi/işaretçisi döndürür |
| ApplySwishPtr | SUB ApplySwishPtr(dataPtr AS U64, n AS I64) | ham veri adresi/işaretçisi döndürür |
| SoftmaxPtr | SUB SoftmaxPtr(inputPtr AS U64, outputPtr AS U64, n AS I64) | en büyük değeri döndürür |
| SoftmaxInPlacePtr | SUB SoftmaxInPlacePtr(dataPtr AS U64, n AS I64) | en büyük değeri döndürür |
| TensorSigmoid | SUB TensorSigmoid(t AS U64) | tensor işlemi gerçekleştirir |
| TensorTanh | SUB TensorTanh(t AS U64) | tensor işlemi gerçekleştirir |
| TensorReLU | SUB TensorReLU(t AS U64) | tensor işlemi gerçekleştirir |
| TensorLeakyReLU | SUB TensorLeakyReLU(t AS U64, alpha AS F64) | tensor işlemi gerçekleştirir |
| TensorGELU | SUB TensorGELU(t AS U64) | tensor işlemi gerçekleştirir |
| TensorSoftmax | SUB TensorSoftmax(src AS U64, dst AS U64) | en büyük değeri döndürür |
| MSE | FUNCTION MSE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64 | ortalama kare hatayı hesaplar |
| MAE | FUNCTION MAE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64 | ortalama mutlak hatayı hesaplar |
| Huber | FUNCTION Huber(yTruePtr AS U64, yPredPtr AS U64, n AS I64, delta AS F64) AS F64 | Huber kaybını hesaplar |
| BinaryCrossEntropy | FUNCTION BinaryCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64 | ikili çapraz entropi kaybını hesaplar |
| CategoricalCrossEntropy | FUNCTION CategoricalCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64 | kategorik çapraz entropi kaybını hesaplar |
| MSEGrad | SUB MSEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64) | `msegrad` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| BCEGrad | SUB BCEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64) | `bcegrad` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| FillZeros | SUB FillZeros(dataPtr AS U64, n AS I64) | değerlerle doldurur |
| FillOnes | SUB FillOnes(dataPtr AS U64, n AS I64) | değerlerle doldurur |
| FillUniform | SUB FillUniform(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64) | değerlerle doldurur |
| FillNormal | SUB FillNormal(dataPtr AS U64, n AS I64, mean AS F64, stddev AS F64) | değerlerle doldurur |
| XavierUniform | SUB XavierUniform(dataPtr AS U64, n AS I64, fanIn AS I64, fanOut AS I64) | oturum/model çalıştırması yapar |
| HeUniform | SUB HeUniform(dataPtr AS U64, n AS I64, fanIn AS I64) | `he uniform` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ClipValue | SUB ClipValue(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64) | `clip value` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ClipNorm | SUB ClipNorm(dataPtr AS U64, n AS I64, maxNorm AS F64) | norm hesaplar |
| SGDUpdate | SUB SGDUpdate(paramPtr AS U64, gradPtr AS U64, n AS I64, lr AS F64) | parametre güncellemesi yapar |
| MomentumUpdate | SUB MomentumUpdate(paramPtr AS U64, gradPtr AS U64, velocityPtr AS U64, n AS I64, lr AS F64, momentum AS F64) | parametre güncellemesi yapar |
| DenseForward | SUB DenseForward(inputPtr AS U64, weightPtr AS U64, biasPtr AS U64, outputPtr AS U64, inN AS I64, outN AS I64) | ileri yayılım yapar |
| DenseBatchForward | SUB DenseBatchForward(xPtr AS U64, weightPtr AS U64, biasPtr AS U64, yPtr AS U64, batch AS I64, inN AS I64, outN AS I64) | ileri yayılım yapar |
| ArgMax | FUNCTION ArgMax(dataPtr AS U64, n AS I64) AS I64 | en büyük değerin indeksini döndürür |
| BinaryAccuracy | FUNCTION BinaryAccuracy(yTruePtr AS U64, yPredPtr AS U64, n AS I64, threshold AS F64) AS F64 | ikili sınıflandırma doğruluğunu hesaplar |

## uxcollections

List, stack, queue, dict, set ve tree koleksiyonları. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| ListNew | FUNCTION ListNew() AS U64 | yeni bir nesne/handle oluşturur |
| ListFree | SUB ListFree(h AS U64) | ayrılmış kaynağı serbest bırakır |
| ListCount | FUNCTION ListCount(h AS U64) AS I64 | öğe veya satır sayısını döndürür |
| ListPushF64 | SUB ListPushF64(h AS U64, x AS F64) | koleksiyona öğe ekler |
| ListGetF64 | FUNCTION ListGetF64(h AS U64, idx AS I64) AS F64 | belirtilen değeri okur |
| StackNew | FUNCTION StackNew() AS U64 | yeni bir nesne/handle oluşturur |
| StackFree | SUB StackFree(h AS U64) | ayrılmış kaynağı serbest bırakır |
| StackPushF64 | SUB StackPushF64(h AS U64, x AS F64) | koleksiyona öğe ekler |
| StackPopF64 | FUNCTION StackPopF64(h AS U64) AS F64 | koleksiyondan öğe çıkarıp döndürür |
| QueueNew | FUNCTION QueueNew() AS U64 | yeni bir nesne/handle oluşturur |
| QueueFree | SUB QueueFree(h AS U64) | ayrılmış kaynağı serbest bırakır |
| QueuePushF64 | SUB QueuePushF64(h AS U64, x AS F64) | koleksiyona öğe ekler |
| QueuePopF64 | FUNCTION QueuePopF64(h AS U64) AS F64 | koleksiyondan öğe çıkarıp döndürür |
| DictNew | FUNCTION DictNew() AS U64 | yeni bir nesne/handle oluşturur |
| DictFree | SUB DictFree(h AS U64) | ayrılmış kaynağı serbest bırakır |
| DictSetF64 | SUB DictSetF64(h AS U64, key AS STRING, x AS F64) | belirtilen değeri yazar |
| DictGetF64 | FUNCTION DictGetF64(h AS U64, key AS STRING) AS F64 | belirtilen değeri okur |
| DictHas | FUNCTION DictHas(h AS U64, key AS STRING) AS I32 | varlık kontrolü yapar |
| SetNew | FUNCTION SetNew() AS U64 | yeni bir nesne/handle oluşturur |
| SetFree | SUB SetFree(h AS U64) | ayrılmış kaynağı serbest bırakır |
| SetAdd | SUB SetAdd(h AS U64, key AS STRING) | belirtilen değeri yazar |
| SetContains | FUNCTION SetContains(h AS U64, key AS STRING) AS I32 | belirtilen değeri yazar |
| TreeNew | FUNCTION TreeNew() AS U64 | yeni bir nesne/handle oluşturur |
| TreeFree | SUB TreeFree(h AS U64) | ayrılmış kaynağı serbest bırakır |
| TreeSetF64 | SUB TreeSetF64(h AS U64, key AS STRING, x AS F64) | belirtilen değeri yazar |
| TreeGetF64 | FUNCTION TreeGetF64(h AS U64, key AS STRING) AS F64 | belirtilen değeri okur |

## uxdataframe

Duckdb tabanlı tablo, sql, csv/parquet ve matris aktarımı. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| RuntimeVersion | FUNCTION RuntimeVersion() AS I32 | çalışma zamanı sürümünü döndürür |
| DuckDBAvailable | FUNCTION DuckDBAvailable() AS I32 | kullanılabilirlik durumunu döndürür |
| DuckDBVersion | FUNCTION DuckDBVersion() AS STRING | sürüm bilgisini döndürür |
| LastError | FUNCTION LastError(df AS U64) AS STRING | son hata metnini döndürür |
| OpenMemory | FUNCTION OpenMemory() AS U64 | bir kaynak veya oturum açar |
| OpenDatabase | FUNCTION OpenDatabase(path AS STRING) AS U64 | bir kaynak veya oturum açar |
| Free | SUB Free(df AS U64) | ayrılmış kaynağı serbest bırakır |
| LoadCSV | FUNCTION LoadCSV(path AS STRING, header AS I32) AS U64 | veriyi veya modeli yükler |
| LoadParquet | FUNCTION LoadParquet(path AS STRING) AS U64 | veriyi veya modeli yükler |
| Exec | FUNCTION Exec(df AS U64, sql AS STRING) AS I32 | komut veya sorgu yürütür |
| Query | FUNCTION Query(df AS U64, sql AS STRING) AS U64 | sorgu çalıştırıp sonuç döndürür |
| RowCount | FUNCTION RowCount(df AS U64) AS I64 | öğe veya satır sayısını döndürür |
| ColCount | FUNCTION ColCount(df AS U64) AS I32 | öğe veya satır sayısını döndürür |
| ColName | FUNCTION ColName(df AS U64, col AS I32) AS STRING | sütunla ilgili değeri döndürür |
| GetF64 | FUNCTION GetF64(df AS U64, row AS I64, col AS I32) AS F64 | belirtilen değeri okur |
| GetText | FUNCTION GetText(df AS U64, row AS I64, col AS I32) AS STRING | belirtilen değeri okur |
| Head | FUNCTION Head(df AS U64, n AS I64) AS U64 | `head` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| SelectCols | FUNCTION SelectCols(df AS U64, columns AS STRING) AS U64 | sütun sayısı/bilgisi döndürür |
| Filter | FUNCTION Filter(df AS U64, whereSql AS STRING) AS U64 | koşula göre filtreler |
| OrderBy | FUNCTION OrderBy(df AS U64, orderSql AS STRING) AS U64 | `order by` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Describe | FUNCTION Describe(df AS U64) AS U64 | `describe` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| GroupMean | FUNCTION GroupMean(df AS U64, groupCol AS STRING, valueCol AS STRING) AS U64 | ortalama hesaplar |
| JoinInner | FUNCTION JoinInner(leftDf AS U64, rightDf AS U64, leftKey AS STRING, rightKey AS STRING) AS U64 | `join inner` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ToCSV | FUNCTION ToCSV(df AS U64, path AS STRING) AS I32 | `to csv` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ToParquet | FUNCTION ToParquet(df AS U64, path AS STRING) AS I32 | `to parquet` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ToF64Matrix | FUNCTION ToF64Matrix(df AS U64) AS U64 | matris işlemi gerçekleştirir |
| MatrixFree | SUB MatrixFree(m AS U64) | ayrılmış kaynağı serbest bırakır |
| MatrixRows | FUNCTION MatrixRows(m AS U64) AS I64 | satır sayısı/bilgisi döndürür |
| MatrixCols | FUNCTION MatrixCols(m AS U64) AS I32 | sütun sayısı/bilgisi döndürür |
| MatrixDataPtr | FUNCTION MatrixDataPtr(m AS U64) AS U64 | matris işlemi gerçekleştirir |
| MatrixGet | FUNCTION MatrixGet(m AS U64, row AS I64, col AS I32) AS F64 | belirtilen değeri okur |

## uxdataset

Makine öğrenmesi veri seti, split, scaler, eksik veri ve batch loader. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| Backend | FUNCTION Backend() AS STRING | etkin backend adını döndürür |
| Create | FUNCTION Create(rows AS I32, inputDim AS I32, targetDim AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| Free | SUB Free(ds AS U64) | ayrılmış kaynağı serbest bırakır |
| Clone | FUNCTION Clone(ds AS U64) AS U64 | nesnenin kopyasını oluşturur |
| LoadCSV | FUNCTION LoadCSV(path AS STRING, inputDim AS I32, targetDim AS I32, hasHeader AS I32) AS U64 | veriyi veya modeli yükler |
| SaveCSV | FUNCTION SaveCSV(ds AS U64, path AS STRING) AS I32 | veriyi veya modeli kaydeder |
| RowCount | FUNCTION RowCount(ds AS U64) AS I32 | öğe veya satır sayısını döndürür |
| InputDim | FUNCTION InputDim(ds AS U64) AS I32 | boyut bilgisini döndürür |
| TargetDim | FUNCTION TargetDim(ds AS U64) AS I32 | belirtilen değeri okur |
| XPtr | FUNCTION XPtr(ds AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| YPtr | FUNCTION YPtr(ds AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| GetX | FUNCTION GetX(ds AS U64, row AS I32, col AS I32) AS F64 | belirtilen değeri okur |
| SetX | SUB SetX(ds AS U64, row AS I32, col AS I32, value AS F64) | belirtilen değeri yazar |
| GetY | FUNCTION GetY(ds AS U64, row AS I32, col AS I32) AS F64 | belirtilen değeri okur |
| SetY | SUB SetY(ds AS U64, row AS I32, col AS I32, value AS F64) | belirtilen değeri yazar |
| Shuffle | SUB Shuffle(ds AS U64, seed AS U64) | veriyi karıştırır |
| SplitTrain | FUNCTION SplitTrain(ds AS U64, trainRatio AS F64, seed AS U64) AS U64 | veriyi bölümlere ayırır |
| SplitTest | FUNCTION SplitTest(ds AS U64, trainRatio AS F64, seed AS U64) AS U64 | veriyi bölümlere ayırır |
| ScalerFitStandard | FUNCTION ScalerFitStandard(ds AS U64) AS U64 | ölçekleme işlemi yapar |
| ScalerFitMinMax | FUNCTION ScalerFitMinMax(ds AS U64) AS U64 | en küçük değeri döndürür |
| ScalerFree | SUB ScalerFree(sc AS U64) | ayrılmış kaynağı serbest bırakır |
| ScalerTransform | SUB ScalerTransform(sc AS U64, ds AS U64) | ölçekleme işlemi yapar |
| ScalerInverseTransform | SUB ScalerInverseTransform(sc AS U64, ds AS U64) | belirtilen değeri yazar |
| FillMissingMean | SUB FillMissingMean(ds AS U64) | değerlerle doldurur |
| BatchCreate | FUNCTION BatchCreate(ds AS U64, batchSize AS I32, shuffle AS I32, seed AS U64) AS U64 | yeni bir nesne/handle oluşturur |
| BatchFree | SUB BatchFree(loader AS U64) | ayrılmış kaynağı serbest bırakır |
| BatchReset | SUB BatchReset(loader AS U64) | belirtilen değeri yazar |
| BatchNext | FUNCTION BatchNext(loader AS U64) AS I32 | `batch next` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| BatchRows | FUNCTION BatchRows(loader AS U64) AS I32 | satır sayısı/bilgisi döndürür |
| BatchXPtr | FUNCTION BatchXPtr(loader AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| BatchYPtr | FUNCTION BatchYPtr(loader AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| BatchGetX | FUNCTION BatchGetX(loader AS U64, row AS I32, col AS I32) AS F64 | belirtilen değeri okur |
| BatchGetY | FUNCTION BatchGetY(loader AS U64, row AS I32, col AS I32) AS F64 | belirtilen değeri okur |

## uxgraph

Graf oluşturma, derece, bağlantı, yol ve ağ ölçüleri. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Create | FUNCTION Create(vertices AS I32, directed AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| Free | SUB Free(g AS U64) | ayrılmış kaynağı serbest bırakır |
| AddVertex | FUNCTION AddVertex(g AS U64) AS I32 | öğe/kenar/değer ekler |
| AddVertices | FUNCTION AddVertices(g AS U64, count AS I32) AS I32 | öğe/kenar/değer ekler |
| AddEdge | FUNCTION AddEdge(g AS U64, fromV AS I32, toV AS I32) AS I32 | öğe/kenar/değer ekler |
| VCount | FUNCTION VCount(g AS U64) AS I32 | öğe veya satır sayısını döndürür |
| ECount | FUNCTION ECount(g AS U64) AS I32 | öğe veya satır sayısını döndürür |
| IsDirected | FUNCTION IsDirected(g AS U64) AS I32 | `is directed` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| HasEdge | FUNCTION HasEdge(g AS U64, fromV AS I32, toV AS I32) AS I32 | varlık kontrolü yapar |
| Degree | FUNCTION Degree(g AS U64, v AS I32) AS I32 | derece bilgisini hesaplar |
| InDegree | FUNCTION InDegree(g AS U64, v AS I32) AS I32 | derece bilgisini hesaplar |
| OutDegree | FUNCTION OutDegree(g AS U64, v AS I32) AS I32 | derece bilgisini hesaplar |
| Density | FUNCTION Density(g AS U64) AS F64 | yoğunluk ölçüsünü hesaplar |
| SelfLoops | FUNCTION SelfLoops(g AS U64) AS I32 | `self loops` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Components | FUNCTION Components(g AS U64) AS I32 | bileşen bilgisini hesaplar |
| IsConnected | FUNCTION IsConnected(g AS U64) AS I32 | bağlantı durumunu hesaplar |
| ShortestDistance | FUNCTION ShortestDistance(g AS U64, source AS I32, target AS I32) AS I32 | uzaklık hesaplar |
| PathExists | FUNCTION PathExists(g AS U64, source AS I32, target AS I32) AS I32 | varlık kontrolü yapar |
| TriangleCount | FUNCTION TriangleCount(g AS U64) AS I32 | öğe veya satır sayısını döndürür |
| Transitivity | FUNCTION Transitivity(g AS U64) AS F64 | `transitivity` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| DegreeVector | FUNCTION DegreeVector(g AS U64, mode AS I32) AS U64 | derece bilgisini hesaplar |
| BFSDistances | FUNCTION BFSDistances(g AS U64, source AS I32) AS U64 | uzaklık hesaplar |
| VecCount | FUNCTION VecCount(v AS U64) AS I32 | öğe veya satır sayısını döndürür |
| VecGet | FUNCTION VecGet(v AS U64, index AS I32) AS F64 | belirtilen değeri okur |
| VecFree | SUB VecFree(v AS U64) | ayrılmış kaynağı serbest bırakır |
| WriteEdgeListCSV | FUNCTION WriteEdgeListCSV(g AS U64, path AS STRING) AS I32 | `write edge list csv` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ReadEdgeListCSV | FUNCTION ReadEdgeListCSV(path AS STRING, directed AS I32) AS U64 | `read edge list csv` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| MakePath | FUNCTION MakePath(vertices AS I32, directed AS I32) AS U64 | yol/erişim işlemi gerçekleştirir |
| MakeCycle | FUNCTION MakeCycle(vertices AS I32, directed AS I32) AS U64 | `make cycle` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| MakeComplete | FUNCTION MakeComplete(vertices AS I32, directed AS I32) AS U64 | `make complete` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |

## uxllama

Yerel llm cpu/cli abi sarmalayıcısı. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Create | FUNCTION Create() AS U64 | yeni bir nesne/handle oluşturur |
| Free | SUB Free(h AS U64) | ayrılmış kaynağı serbest bırakır |
| SetCliPath | FUNCTION SetCliPath(h AS U64, path AS STRING) AS I32 | belirtilen değeri yazar |
| SetModelPath | FUNCTION SetModelPath(h AS U64, path AS STRING) AS I32 | belirtilen değeri yazar |
| SetThreads | FUNCTION SetThreads(h AS U64, n AS I32) AS I32 | belirtilen değeri yazar |
| SetContext | FUNCTION SetContext(h AS U64, n AS I32) AS I32 | belirtilen değeri yazar |
| SetPredict | FUNCTION SetPredict(h AS U64, n AS I32) AS I32 | belirtilen değeri yazar |
| SetTemperature | FUNCTION SetTemperature(h AS U64, t AS F64) AS I32 | belirtilen değeri yazar |
| SetTopP | FUNCTION SetTopP(h AS U64, p AS F64) AS I32 | belirtilen değeri yazar |
| SetTopK | FUNCTION SetTopK(h AS U64, k AS I32) AS I32 | belirtilen değeri yazar |
| SetSeed | FUNCTION SetSeed(h AS U64, seed AS I32) AS I32 | belirtilen değeri yazar |
| LowMemoryProfile | FUNCTION LowMemoryProfile(h AS U64, profile AS I32) AS I32 | `low memory profile` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| ModelExists | FUNCTION ModelExists(h AS U64) AS I32 | varlık kontrolü yapar |
| Prompt | FUNCTION Prompt(h AS U64, prompt AS STRING, outBuf AS U64, outBytes AS I32) AS I32 | `prompt` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| PromptFile | FUNCTION PromptFile(h AS U64, promptFile AS STRING, outBuf AS U64, outBytes AS I32) AS I32 | `prompt file` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| LastError | FUNCTION LastError(h AS U64, outBuf AS U64, outBytes AS I32) AS I32 | son hata metnini döndürür |
| LastCommand | FUNCTION LastCommand(h AS U64, outBuf AS U64, outBytes AS I32) AS I32 | `last command` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |

## uxllamax

Uxllama gerçek abi yüzeyini geniş ad alanında sunan sarmalayıcı; bağımsız embedding/streaming abi’si varmış gibi kabul edilmez. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

Bu pakette bağımsız fonksiyon gövdesi bulunmayan veya başka gerçek ABI modülünü INCLUDE eden sarmalayıcıdır.

## uxmath

Temel dış matematik sarmalayıcıları. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| UXMATH_Version | FUNCTION UXMATH_Version() AS I32 | sürüm bilgisini döndürür |
| UXMATH_VecCreate | FUNCTION UXMATH_VecCreate(capacity AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| UXMATH_VecFree | FUNCTION UXMATH_VecFree(h AS U64) AS I32 | ayrılmış kaynağı serbest bırakır |
| UXMATH_VecPush | FUNCTION UXMATH_VecPush(h AS U64, value AS F64) AS I32 | koleksiyona öğe ekler |
| UXMATH_VecSet | FUNCTION UXMATH_VecSet(h AS U64, index AS I32, value AS F64) AS I32 | belirtilen değeri yazar |
| UXMATH_VecGet | FUNCTION UXMATH_VecGet(h AS U64, index AS I32) AS F64 | belirtilen değeri okur |
| UXMATH_VecCount | FUNCTION UXMATH_VecCount(h AS U64) AS I32 | öğe veya satır sayısını döndürür |
| UXMATH_VecClear | FUNCTION UXMATH_VecClear(h AS U64) AS I32 | içeriği temizler |
| UXMATH_VecDataPtr | FUNCTION UXMATH_VecDataPtr(h AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |

## uxmathcore

Vektör, matris ve temel sayısal çekirdek. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| UXMC_TYPE_I8 | FUNCTION UXMC_TYPE_I8() AS I32 | `type i8` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_U8 | FUNCTION UXMC_TYPE_U8() AS I32 | `type u8` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_I16 | FUNCTION UXMC_TYPE_I16() AS I32 | `type i16` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_U16 | FUNCTION UXMC_TYPE_U16() AS I32 | `type u16` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_I32 | FUNCTION UXMC_TYPE_I32() AS I32 | `type i32` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_U32 | FUNCTION UXMC_TYPE_U32() AS I32 | `type u32` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_I64 | FUNCTION UXMC_TYPE_I64() AS I32 | `type i64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_U64 | FUNCTION UXMC_TYPE_U64() AS I32 | `type u64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_F32 | FUNCTION UXMC_TYPE_F32() AS I32 | `type f32` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_TYPE_F64 | FUNCTION UXMC_TYPE_F64() AS I32 | `type f64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_Version | FUNCTION UXMC_Version() AS I32 | sürüm bilgisini döndürür |
| UXMC_TypeSize | FUNCTION UXMC_TypeSize(typeId AS I32) AS I32 | boyut bilgisini döndürür |
| UXMC_BufferCreate | FUNCTION UXMC_BufferCreate(typeId AS I32, count AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| UXMC_BufferCreateCapacity | FUNCTION UXMC_BufferCreateCapacity(typeId AS I32, count AS I32, capacity AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| UXMC_BufferFree | FUNCTION UXMC_BufferFree(h AS U64) AS I32 | ayrılmış kaynağı serbest bırakır |
| UXMC_BufferType | FUNCTION UXMC_BufferType(h AS U64) AS I32 | `buffer type` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_BufferCount | FUNCTION UXMC_BufferCount(h AS U64) AS I32 | öğe veya satır sayısını döndürür |
| UXMC_BufferCapacity | FUNCTION UXMC_BufferCapacity(h AS U64) AS I32 | `buffer capacity` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_BufferElemSize | FUNCTION UXMC_BufferElemSize(h AS U64) AS I32 | boyut bilgisini döndürür |
| UXMC_BufferByteSize | FUNCTION UXMC_BufferByteSize(h AS U64) AS I64 | boyut bilgisini döndürür |
| UXMC_BufferDataPtr | FUNCTION UXMC_BufferDataPtr(h AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| UXMC_BufferClear | FUNCTION UXMC_BufferClear(h AS U64) AS I32 | içeriği temizler |
| UXMC_BufferResize | FUNCTION UXMC_BufferResize(h AS U64, count AS I32) AS I32 | boyut bilgisini döndürür |
| UXMC_BufferReserve | FUNCTION UXMC_BufferReserve(h AS U64, capacity AS I32) AS I32 | `buffer reserve` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_BufferFillZero | FUNCTION UXMC_BufferFillZero(h AS U64) AS I32 | değerlerle doldurur |
| UXMC_BufferClone | FUNCTION UXMC_BufferClone(h AS U64) AS U64 | nesnenin kopyasını oluşturur |
| UXMC_BufferSlice | FUNCTION UXMC_BufferSlice(h AS U64, startIndex AS I32, count AS I32) AS U64 | `buffer slice` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_BufferAppend | FUNCTION UXMC_BufferAppend(dst AS U64, src AS U64) AS I32 | `buffer append` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_BufferCast | FUNCTION UXMC_BufferCast(src AS U64, dstType AS I32) AS U64 | `buffer cast` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_GetF64 | FUNCTION UXMC_GetF64(h AS U64, index AS I32) AS F64 | belirtilen değeri okur |
| UXMC_SetF64 | FUNCTION UXMC_SetF64(h AS U64, index AS I32, value AS F64) AS I32 | belirtilen değeri yazar |
| UXMC_PushF64 | FUNCTION UXMC_PushF64(h AS U64, value AS F64) AS I32 | koleksiyona öğe ekler |
| UXMC_FillF64 | FUNCTION UXMC_FillF64(h AS U64, value AS F64) AS I32 | değerlerle doldurur |
| UXMC_SetI64 | FUNCTION UXMC_SetI64(h AS U64, index AS I32, value AS I64) AS I32 | belirtilen değeri yazar |
| UXMC_PushI64 | FUNCTION UXMC_PushI64(h AS U64, value AS I64) AS I32 | koleksiyona öğe ekler |
| UXMC_SetU64 | FUNCTION UXMC_SetU64(h AS U64, index AS I32, value AS U64) AS I32 | belirtilen değeri yazar |
| UXMC_PushU64 | FUNCTION UXMC_PushU64(h AS U64, value AS U64) AS I32 | koleksiyona öğe ekler |
| UXMC_SetByte | FUNCTION UXMC_SetByte(h AS U64, index AS I32, value AS I32) AS I32 | belirtilen değeri yazar |
| UXMC_PushByte | FUNCTION UXMC_PushByte(h AS U64, value AS I32) AS I32 | koleksiyona öğe ekler |
| UXMC_VecAddF64 | FUNCTION UXMC_VecAddF64(a AS U64, b AS U64, outv AS U64) AS I32 | öğe/kenar/değer ekler |
| UXMC_VecSubF64 | FUNCTION UXMC_VecSubF64(a AS U64, b AS U64, outv AS U64) AS I32 | `vec sub f64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_VecMulF64 | FUNCTION UXMC_VecMulF64(a AS U64, b AS U64, outv AS U64) AS I32 | `vec mul f64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_VecDivF64 | FUNCTION UXMC_VecDivF64(a AS U64, b AS U64, outv AS U64) AS I32 | `vec div f64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_VecScaleF64 | FUNCTION UXMC_VecScaleF64(a AS U64, scalar AS F64, outv AS U64) AS I32 | ölçekleme işlemi yapar |
| UXMC_VecAxpyF64 | FUNCTION UXMC_VecAxpyF64(alpha AS F64, x AS U64, y AS U64, outv AS U64) AS I32 | `vec axpy f64` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXMC_VecDotF64 | FUNCTION UXMC_VecDotF64(a AS U64, b AS U64) AS F64 | skaler çarpım hesaplar |
| UXMC_VecL1NormF64 | FUNCTION UXMC_VecL1NormF64(a AS U64) AS F64 | norm hesaplar |
| UXMC_VecL2NormF64 | FUNCTION UXMC_VecL2NormF64(a AS U64) AS F64 | norm hesaplar |
| UXMC_VecNormalizeL2F64 | FUNCTION UXMC_VecNormalizeL2F64(a AS U64, outv AS U64) AS I32 | norm hesaplar |
| UXMC_VecMinF64 | FUNCTION UXMC_VecMinF64(a AS U64) AS F64 | en küçük değeri döndürür |
| UXMC_VecMaxF64 | FUNCTION UXMC_VecMaxF64(a AS U64) AS F64 | en büyük değeri döndürür |

## uxmatrix

Matris oluşturma, erişim, cebir ve dönüşümler. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| RuntimeVersion | FUNCTION RuntimeVersion() AS I32 | çalışma zamanı sürümünü döndürür |
| Create | FUNCTION Create(rows AS I32, cols AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| Free | SUB Free(m AS U64) | ayrılmış kaynağı serbest bırakır |
| Rows | FUNCTION Rows(m AS U64) AS I32 | satır sayısı/bilgisi döndürür |
| Cols | FUNCTION Cols(m AS U64) AS I32 | sütun sayısı/bilgisi döndürür |
| Size | FUNCTION Size(m AS U64) AS I32 | boyut bilgisini döndürür |
| DataPtr | FUNCTION DataPtr(m AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| Set | FUNCTION Set(m AS U64, r AS I32, c AS I32, v AS F64) AS I32 | belirtilen değeri yazar |
| Get | FUNCTION Get(m AS U64, r AS I32, c AS I32) AS F64 | belirtilen değeri okur |
| Fill | FUNCTION Fill(m AS U64, v AS F64) AS I32 | değerlerle doldurur |
| Zero | FUNCTION Zero(m AS U64) AS I32 | değerleri sıfırlar |
| Eye | FUNCTION Eye(m AS U64) AS I32 | `eye` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Clone | FUNCTION Clone(m AS U64) AS U64 | nesnenin kopyasını oluşturur |
| Transpose | FUNCTION Transpose(a AS U64) AS U64 | transpoz üretir |
| Add | FUNCTION Add(a AS U64, b AS U64) AS U64 | öğe/kenar/değer ekler |
| Sub | FUNCTION Sub(a AS U64, b AS U64) AS U64 | `sub` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Scale | FUNCTION Scale(a AS U64, s AS F64) AS U64 | ölçekleme işlemi yapar |
| Mul | FUNCTION Mul(a AS U64, b AS U64) AS U64 | `mul` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| MatVec | FUNCTION MatVec(a AS U64, x AS U64) AS U64 | `mat vec` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Dot | FUNCTION Dot(a AS U64, b AS U64) AS F64 | skaler çarpım hesaplar |
| NormL1 | FUNCTION NormL1(a AS U64) AS F64 | norm hesaplar |
| NormL2 | FUNCTION NormL2(a AS U64) AS F64 | norm hesaplar |
| NormFro | FUNCTION NormFro(a AS U64) AS F64 | norm hesaplar |
| Trace | FUNCTION Trace(a AS U64) AS F64 | `trace` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| PrintMatrix | FUNCTION PrintMatrix(a AS U64) AS I32 | matris işlemi gerçekleştirir |
| Det | FUNCTION Det(a AS U64) AS F64 | `det` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Solve | FUNCTION Solve(a AS U64, b AS U64) AS U64 | `solve` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Inverse | FUNCTION Inverse(a AS U64) AS U64 | `inverse` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Cholesky | FUNCTION Cholesky(a AS U64) AS U64 | `cholesky` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| QR | FUNCTION QR(a AS U64, qOutPtr AS U64, rOutPtr AS U64) AS I32 | `qr` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| SVD | FUNCTION SVD(a AS U64, uOutPtr AS U64, sOutPtr AS U64, vtOutPtr AS U64) AS I32 | `svd` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| EigenSymmetric | FUNCTION EigenSymmetric(a AS U64, valuesOutPtr AS U64, vectorsOutPtr AS U64) AS I32 | `eigen symmetric` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| RankSVD | FUNCTION RankSVD(a AS U64, tol AS F64) AS I32 | `rank svd` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Cond2 | FUNCTION Cond2(a AS U64) AS F64 | `cond2` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |

## uxnn

Temel sinir ağı katman/model/öğrenme yüzeyi. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| Backend | FUNCTION Backend() AS STRING | etkin backend adını döndürür |
| Seed | SUB Seed(seed AS U64) | `seed` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| NeuronCreate | FUNCTION NeuronCreate(inputCount AS I32, activation AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| NeuronFree | SUB NeuronFree(n AS U64) | ayrılmış kaynağı serbest bırakır |
| NeuronSetWeight | SUB NeuronSetWeight(n AS U64, index AS I32, value AS F64) | belirtilen değeri yazar |
| NeuronGetWeight | FUNCTION NeuronGetWeight(n AS U64, index AS I32) AS F64 | belirtilen değeri okur |
| NeuronSetBias | SUB NeuronSetBias(n AS U64, value AS F64) | belirtilen değeri yazar |
| NeuronGetBias | FUNCTION NeuronGetBias(n AS U64) AS F64 | belirtilen değeri okur |
| NeuronForwardPtr | FUNCTION NeuronForwardPtr(n AS U64, inputPtr AS U64) AS F64 | ileri yayılım yapar |
| DenseLayerCreate | FUNCTION DenseLayerCreate(inputDim AS I32, outputDim AS I32, activation AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| ActivationLayerCreate | FUNCTION ActivationLayerCreate(dim AS I32, activation AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| LayerFree | SUB LayerFree(layer AS U64) | ayrılmış kaynağı serbest bırakır |
| LayerInputDim | FUNCTION LayerInputDim(layer AS U64) AS I32 | boyut bilgisini döndürür |
| LayerOutputDim | FUNCTION LayerOutputDim(layer AS U64) AS I32 | boyut bilgisini döndürür |
| LayerSetWeight | SUB LayerSetWeight(layer AS U64, outIndex AS I32, inIndex AS I32, value AS F64) | belirtilen değeri yazar |
| LayerGetWeight | FUNCTION LayerGetWeight(layer AS U64, outIndex AS I32, inIndex AS I32) AS F64 | belirtilen değeri okur |
| LayerSetBias | SUB LayerSetBias(layer AS U64, outIndex AS I32, value AS F64) | belirtilen değeri yazar |
| LayerGetBias | FUNCTION LayerGetBias(layer AS U64, outIndex AS I32) AS F64 | belirtilen değeri okur |
| LayerInit | SUB LayerInit(layer AS U64, initKind AS I32, scale AS F64) | `layer init` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| LayerForwardPtr | SUB LayerForwardPtr(layer AS U64, inputPtr AS U64, outputPtr AS U64) | ileri yayılım yapar |
| NetworkCreate | FUNCTION NetworkCreate() AS U64 | yeni bir nesne/handle oluşturur |
| NetworkFree | SUB NetworkFree(net AS U64) | ayrılmış kaynağı serbest bırakır |
| NetworkAddLayer | FUNCTION NetworkAddLayer(net AS U64, layer AS U64) AS I32 | öğe/kenar/değer ekler |
| NetworkLayerCount | FUNCTION NetworkLayerCount(net AS U64) AS I32 | öğe veya satır sayısını döndürür |
| NetworkInputDim | FUNCTION NetworkInputDim(net AS U64) AS I32 | boyut bilgisini döndürür |
| NetworkOutputDim | FUNCTION NetworkOutputDim(net AS U64) AS I32 | boyut bilgisini döndürür |
| NetworkForwardPtr | SUB NetworkForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64) | ileri yayılım yapar |
| NetworkPredictArgmaxPtr | FUNCTION NetworkPredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32 | en büyük değeri döndürür |
| NetworkMSEPtr | FUNCTION NetworkMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32) AS F64 | ham veri adresi/işaretçisi döndürür |
| NetworkTrainMSESGDPtr | FUNCTION NetworkTrainMSESGDPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32, epochs AS I32, lr AS F64) AS F64 | model eğitimi yapar |
| NetworkForwardTensor | SUB NetworkForwardTensor(net AS U64, inputTensor AS U64, outputTensor AS U64) | ileri yayılım yapar |
| NetworkPredictArgmaxTensor | FUNCTION NetworkPredictArgmaxTensor(net AS U64, inputTensor AS U64) AS I32 | en büyük değeri döndürür |

## uxnn2

Ikinci nesil sinir ağı sarmalayıcıları. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| Backend | FUNCTION Backend() AS STRING | etkin backend adını döndürür |
| Seed | SUB Seed(seed AS U64) | `seed` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| NetworkCreate | FUNCTION NetworkCreate(inputDim AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| NetworkFree | SUB NetworkFree(net AS U64) | ayrılmış kaynağı serbest bırakır |
| AddDense | FUNCTION AddDense(net AS U64, outputDim AS I32, activation AS I32) AS I32 | öğe/kenar/değer ekler |
| LayerCount | FUNCTION LayerCount(net AS U64) AS I32 | öğe veya satır sayısını döndürür |
| InputDim | FUNCTION InputDim(net AS U64) AS I32 | boyut bilgisini döndürür |
| OutputDim | FUNCTION OutputDim(net AS U64) AS I32 | boyut bilgisini döndürür |
| Init | SUB Init(net AS U64, initKind AS I32, scale AS F64) | `init` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| SetOptimizer | SUB SetOptimizer(net AS U64, optKind AS I32, learningRate AS F64) | belirtilen değeri yazar |
| SetOptimizerParams | SUB SetOptimizerParams(net AS U64, beta1 AS F64, beta2 AS F64, epsilon AS F64, weightDecay AS F64) | belirtilen değeri yazar |
| ForwardPtr | SUB ForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64) | ileri yayılım yapar |
| LossMSEPtr | FUNCTION LossMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64 | ham veri adresi/işaretçisi döndürür |
| TrainSampleMSEPtr | FUNCTION TrainSampleMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64 | model eğitimi yapar |
| TrainArrayMSEPtr | FUNCTION TrainArrayMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, epochs AS I32, shuffle AS I32) AS F64 | model eğitimi yapar |
| PredictArgmaxPtr | FUNCTION PredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32 | en büyük değeri döndürür |
| GetWeight | FUNCTION GetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32) AS F64 | belirtilen değeri okur |
| SetWeight | SUB SetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32, value AS F64) | belirtilen değeri yazar |
| GetBias | FUNCTION GetBias(net AS U64, layerIndex AS I32, outIndex AS I32) AS F64 | belirtilen değeri okur |
| SetBias | SUB SetBias(net AS U64, layerIndex AS I32, outIndex AS I32, value AS F64) | belirtilen değeri yazar |
| Save | FUNCTION Save(net AS U64, path AS STRING) AS I32 | veriyi veya modeli kaydeder |
| Load | FUNCTION Load(path AS STRING) AS U64 | veriyi veya modeli yükler |

## uxnn3

Üçüncü nesil model/optimizer/eğitim yüzeyi. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| LastError | FUNCTION LastError() AS STRING | son hata metnini döndürür |
| DatasetCreate | FUNCTION DatasetCreate(rows AS I32, inputDim AS I32, outputDim AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| DatasetFree | SUB DatasetFree(ds AS U64) | ayrılmış kaynağı serbest bırakır |
| LoadCSV | FUNCTION LoadCSV(path AS STRING, inputDim AS I32, outputDim AS I32, hasHeader AS I32) AS U64 | veriyi veya modeli yükler |
| SaveCSV | FUNCTION SaveCSV(ds AS U64, path AS STRING, includeHeader AS I32) AS I32 | veriyi veya modeli kaydeder |
| Rows | FUNCTION Rows(ds AS U64) AS I32 | satır sayısı/bilgisi döndürür |
| InputDim | FUNCTION InputDim(ds AS U64) AS I32 | boyut bilgisini döndürür |
| OutputDim | FUNCTION OutputDim(ds AS U64) AS I32 | boyut bilgisini döndürür |
| XGet | FUNCTION XGet(ds AS U64, row AS I32, col AS I32) AS F64 | belirtilen değeri okur |
| YGet | FUNCTION YGet(ds AS U64, row AS I32, col AS I32) AS F64 | belirtilen değeri okur |
| XSet | FUNCTION XSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32 | belirtilen değeri yazar |
| YSet | FUNCTION YSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32 | belirtilen değeri yazar |
| XPtr | FUNCTION XPtr(ds AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| YPtr | FUNCTION YPtr(ds AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| Shuffle | FUNCTION Shuffle(ds AS U64, seed AS U32) AS I32 | veriyi karıştırır |
| SplitTrain | FUNCTION SplitTrain(ds AS U64, ratio AS F64, seed AS U32) AS U64 | veriyi bölümlere ayırır |
| SplitTest | FUNCTION SplitTest(ds AS U64, ratio AS F64, seed AS U32) AS U64 | veriyi bölümlere ayırır |
| Standardize | FUNCTION Standardize(ds AS U64) AS I32 | `standardize` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| MinMax | FUNCTION MinMax(ds AS U64, a AS F64, b AS F64) AS I32 | en küçük değeri döndürür |
| ModelCreate | FUNCTION ModelCreate(inputDim AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| ModelFree | SUB ModelFree(model AS U64) | ayrılmış kaynağı serbest bırakır |
| AddDense | FUNCTION AddDense(model AS U64, outputDim AS I32, activation AS I32) AS I32 | öğe/kenar/değer ekler |
| Init | FUNCTION Init(model AS U64, seed AS U32, scale AS F64) AS I32 | `init` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| SetOptimizer | FUNCTION SetOptimizer(model AS U64, opt AS I32, lr AS F64, momentum AS F64) AS I32 | belirtilen değeri yazar |
| LayerCount | FUNCTION LayerCount(model AS U64) AS I32 | öğe veya satır sayısını döndürür |
| ModelOutputDim | FUNCTION ModelOutputDim(model AS U64) AS I32 | modelle ilgili işlemi gerçekleştirir |
| PredictArgMax | FUNCTION PredictArgMax(model AS U64, ds AS U64, row AS I32) AS I32 | en büyük değeri döndürür |
| TrainDataset | FUNCTION TrainDataset(model AS U64, ds AS U64, epochs AS I32, batchSize AS I32, shuffle AS I32, seed AS U32) AS F64 | belirtilen değeri yazar |
| EvalMSE | FUNCTION EvalMSE(model AS U64, ds AS U64) AS F64 | `eval mse` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| EvalBinaryAccuracy | FUNCTION EvalBinaryAccuracy(model AS U64, ds AS U64, threshold AS F64) AS F64 | doğruluk metriğini hesaplar |
| Save | FUNCTION Save(model AS U64, path AS STRING) AS I32 | veriyi veya modeli kaydeder |
| Load | FUNCTION Load(path AS STRING) AS U64 | veriyi veya modeli yükler |

## uxonnx

Onnx runtime temel oturum ve tensor sarmalayıcısı. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Init | FUNCTION Init(runtimeDir AS STRING) AS I32 | `init` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Version | FUNCTION Version() AS STRING | kütüphane sürümünü döndürür |
| LastError | FUNCTION LastError(session AS U64) AS STRING | son hata metnini döndürür |
| SessionCreate | FUNCTION SessionCreate(modelPath AS STRING, intraThreads AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| SessionFree | SUB SessionFree(session AS U64) | ayrılmış kaynağı serbest bırakır |
| InputCount | FUNCTION InputCount(session AS U64) AS I64 | öğe veya satır sayısını döndürür |
| OutputCount | FUNCTION OutputCount(session AS U64) AS I64 | öğe veya satır sayısını döndürür |
| InputName | FUNCTION InputName(session AS U64, index AS I64) AS STRING | ad bilgisini döndürür |
| OutputName | FUNCTION OutputName(session AS U64, index AS I64) AS STRING | ad bilgisini döndürür |
| TensorCreate1D | FUNCTION TensorCreate1D(n AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorCreate2D | FUNCTION TensorCreate2D(r AS I64, c AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorCreate3D | FUNCTION TensorCreate3D(a AS I64, b AS I64, c AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorCreate4D | FUNCTION TensorCreate4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorFree | SUB TensorFree(t AS U64) | ayrılmış kaynağı serbest bırakır |
| TensorCount | FUNCTION TensorCount(t AS U64) AS I64 | öğe veya satır sayısını döndürür |
| TensorRank | FUNCTION TensorRank(t AS U64) AS I64 | tensor işlemi gerçekleştirir |
| TensorDim | FUNCTION TensorDim(t AS U64, axis AS I64) AS I64 | tensor işlemi gerçekleştirir |
| TensorDataPtr | FUNCTION TensorDataPtr(t AS U64) AS U64 | tensor işlemi gerçekleştirir |
| TensorSet | SUB TensorSet(t AS U64, idx AS I64, value AS F64) | belirtilen değeri yazar |
| TensorGet | FUNCTION TensorGet(t AS U64, idx AS I64) AS F64 | belirtilen değeri okur |
| Run1 | FUNCTION Run1(session AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64 | oturum/model çalıştırması yapar |

## uxonnx2

Geniş onnx oturum, tensor, run ve sonuç api’si. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Init | FUNCTION Init(runtimeDir AS STRING) AS I32 | `init` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Version | FUNCTION Version() AS STRING | kütüphane sürümünü döndürür |
| LastError | FUNCTION LastError() AS STRING | son hata metnini döndürür |
| ProviderAvailable | FUNCTION ProviderAvailable(provider AS I32) AS I32 | kullanılabilirlik durumunu döndürür |
| SessionCreate | FUNCTION SessionCreate(modelPath AS STRING) AS U64 | yeni bir nesne/handle oluşturur |
| SessionCreateAdvanced | FUNCTION SessionCreateAdvanced(modelPath AS STRING, provider AS I32, intraThreads AS I32, interThreads AS I32, graphOpt AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| SessionFree | SUB SessionFree(s AS U64) | ayrılmış kaynağı serbest bırakır |
| InputCount | FUNCTION InputCount(s AS U64) AS I64 | öğe veya satır sayısını döndürür |
| OutputCount | FUNCTION OutputCount(s AS U64) AS I64 | öğe veya satır sayısını döndürür |
| InputName | FUNCTION InputName(s AS U64, idx AS I64) AS STRING | ad bilgisini döndürür |
| OutputName | FUNCTION OutputName(s AS U64, idx AS I64) AS STRING | ad bilgisini döndürür |
| InputDType | FUNCTION InputDType(s AS U64, idx AS I64) AS I32 | veri tipi bilgisini döndürür |
| OutputDType | FUNCTION OutputDType(s AS U64, idx AS I64) AS I32 | veri tipi bilgisini döndürür |
| InputRank | FUNCTION InputRank(s AS U64, idx AS I64) AS I64 | `input rank` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| OutputRank | FUNCTION OutputRank(s AS U64, idx AS I64) AS I64 | `output rank` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| InputDim | FUNCTION InputDim(s AS U64, idx AS I64, axis AS I64) AS I64 | boyut bilgisini döndürür |
| OutputDim | FUNCTION OutputDim(s AS U64, idx AS I64, axis AS I64) AS I64 | boyut bilgisini döndürür |
| TensorCreate1D | FUNCTION TensorCreate1D(dtype AS I32, n AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorCreate2D | FUNCTION TensorCreate2D(dtype AS I32, r AS I64, c AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorCreate3D | FUNCTION TensorCreate3D(dtype AS I32, a AS I64, b AS I64, c AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorCreate4D | FUNCTION TensorCreate4D(dtype AS I32, a AS I64, b AS I64, c AS I64, d AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| TensorFree | SUB TensorFree(t AS U64) | ayrılmış kaynağı serbest bırakır |
| TensorDType | FUNCTION TensorDType(t AS U64) AS I32 | tensor işlemi gerçekleştirir |
| TensorRank | FUNCTION TensorRank(t AS U64) AS I64 | tensor işlemi gerçekleştirir |
| TensorDim | FUNCTION TensorDim(t AS U64, axis AS I64) AS I64 | tensor işlemi gerçekleştirir |
| TensorCount | FUNCTION TensorCount(t AS U64) AS I64 | öğe veya satır sayısını döndürür |
| TensorDataPtr | FUNCTION TensorDataPtr(t AS U64) AS U64 | tensor işlemi gerçekleştirir |
| TensorSetF64 | SUB TensorSetF64(t AS U64, idx AS I64, value AS F64) | belirtilen değeri yazar |
| TensorGetF64 | FUNCTION TensorGetF64(t AS U64, idx AS I64) AS F64 | belirtilen değeri okur |
| TensorSetI64 | SUB TensorSetI64(t AS U64, idx AS I64, value AS I64) | belirtilen değeri yazar |
| TensorGetI64 | FUNCTION TensorGetI64(t AS U64, idx AS I64) AS I64 | belirtilen değeri okur |
| TensorSetString | SUB TensorSetString(t AS U64, idx AS I64, value AS STRING) | belirtilen değeri yazar |
| TensorGetString | FUNCTION TensorGetString(t AS U64, idx AS I64) AS STRING | belirtilen değeri okur |
| RunCreate | FUNCTION RunCreate(s AS U64) AS U64 | yeni bir nesne/handle oluşturur |
| RunFree | SUB RunFree(r AS U64) | ayrılmış kaynağı serbest bırakır |
| RunAddInput | FUNCTION RunAddInput(r AS U64, name AS STRING, t AS U64) AS I32 | öğe/kenar/değer ekler |
| RunAddOutput | FUNCTION RunAddOutput(r AS U64, name AS STRING) AS I32 | öğe/kenar/değer ekler |
| RunExecute | FUNCTION RunExecute(r AS U64) AS U64 | komut veya sorgu yürütür |
| ResultFree | SUB ResultFree(res AS U64) | ayrılmış kaynağı serbest bırakır |
| ResultCount | FUNCTION ResultCount(res AS U64) AS I64 | öğe veya satır sayısını döndürür |
| ResultTensor | FUNCTION ResultTensor(res AS U64, idx AS I64) AS U64 | tensor işlemi gerçekleştirir |
| Run1 | FUNCTION Run1(s AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64 | oturum/model çalıştırması yapar |

## uxstats

Tanımlayıcı istatistik, korelasyon, regresyon ve testler. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| UXSTATS_Version | FUNCTION UXSTATS_Version() AS I32 | sürüm bilgisini döndürür |
| UXSTATS_VecCreate | FUNCTION UXSTATS_VecCreate(capacity AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| UXSTATS_VecFree | FUNCTION UXSTATS_VecFree(h AS U64) AS I32 | ayrılmış kaynağı serbest bırakır |
| UXSTATS_VecClear | FUNCTION UXSTATS_VecClear(h AS U64) AS I32 | içeriği temizler |
| UXSTATS_VecCount | FUNCTION UXSTATS_VecCount(h AS U64) AS I32 | öğe veya satır sayısını döndürür |
| UXSTATS_VecCapacity | FUNCTION UXSTATS_VecCapacity(h AS U64) AS I32 | `vec capacity` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS_VecPush | FUNCTION UXSTATS_VecPush(h AS U64, value AS F64) AS I32 | koleksiyona öğe ekler |
| UXSTATS_VecSet | FUNCTION UXSTATS_VecSet(h AS U64, index AS I32, value AS F64) AS I32 | belirtilen değeri yazar |
| UXSTATS_VecGet | FUNCTION UXSTATS_VecGet(h AS U64, index AS I32) AS F64 | belirtilen değeri okur |
| UXSTATS_Sum | FUNCTION UXSTATS_Sum(h AS U64) AS F64 | toplam hesaplar |
| UXSTATS_Mean | FUNCTION UXSTATS_Mean(h AS U64) AS F64 | ortalama hesaplar |
| UXSTATS_Min | FUNCTION UXSTATS_Min(h AS U64) AS F64 | en küçük değeri döndürür |
| UXSTATS_Max | FUNCTION UXSTATS_Max(h AS U64) AS F64 | en büyük değeri döndürür |
| UXSTATS_Range | FUNCTION UXSTATS_Range(h AS U64) AS F64 | `range` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS_VariancePop | FUNCTION UXSTATS_VariancePop(h AS U64) AS F64 | koleksiyondan öğe çıkarıp döndürür |
| UXSTATS_VarianceSamp | FUNCTION UXSTATS_VarianceSamp(h AS U64) AS F64 | varyans hesaplar |
| UXSTATS_StdDevPop | FUNCTION UXSTATS_StdDevPop(h AS U64) AS F64 | koleksiyondan öğe çıkarıp döndürür |
| UXSTATS_StdDevSamp | FUNCTION UXSTATS_StdDevSamp(h AS U64) AS F64 | standart sapma hesaplar |
| UXSTATS_Median | FUNCTION UXSTATS_Median(h AS U64) AS F64 | medyan hesaplar |
| UXSTATS_Percentile | FUNCTION UXSTATS_Percentile(h AS U64, p AS F64) AS F64 | yüzdelik değeri hesaplar |
| UXSTATS_CovarianceSamp | FUNCTION UXSTATS_CovarianceSamp(x AS U64, y AS U64) AS F64 | varyans hesaplar |
| UXSTATS_Correlation | FUNCTION UXSTATS_Correlation(x AS U64, y AS U64) AS F64 | korelasyon hesaplar |
| UXSTATS_RegressionSlope | FUNCTION UXSTATS_RegressionSlope(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS_RegressionIntercept | FUNCTION UXSTATS_RegressionIntercept(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS_RegressionR2 | FUNCTION UXSTATS_RegressionR2(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS_RawMeanF64 | FUNCTION UXSTATS_RawMeanF64(ptr AS U64, count AS I32) AS F64 | ortalama hesaplar |
| UXSTATS_RawStdDevSampF64 | FUNCTION UXSTATS_RawStdDevSampF64(ptr AS U64, count AS I32) AS F64 | standart sapma hesaplar |
| UXSTATS2_Version | FUNCTION UXSTATS2_Version() AS I32 | sürüm bilgisini döndürür |
| UXSTATS2_VecCreate | FUNCTION UXSTATS2_VecCreate(capacity AS I32) AS U64 | yeni bir nesne/handle oluşturur |
| UXSTATS2_VecFree | FUNCTION UXSTATS2_VecFree(h AS U64) AS I32 | ayrılmış kaynağı serbest bırakır |
| UXSTATS2_VecPush | FUNCTION UXSTATS2_VecPush(h AS U64, value AS F64) AS I32 | koleksiyona öğe ekler |
| UXSTATS2_VecSet | FUNCTION UXSTATS2_VecSet(h AS U64, index AS I32, value AS F64) AS I32 | belirtilen değeri yazar |
| UXSTATS2_VecGet | FUNCTION UXSTATS2_VecGet(h AS U64, index AS I32) AS F64 | belirtilen değeri okur |
| UXSTATS2_VecCount | FUNCTION UXSTATS2_VecCount(h AS U64) AS I32 | öğe veya satır sayısını döndürür |
| UXSTATS2_NormalCDF | FUNCTION UXSTATS2_NormalCDF(z AS F64) AS F64 | norm hesaplar |
| UXSTATS2_NormalP2 | FUNCTION UXSTATS2_NormalP2(z AS F64) AS F64 | norm hesaplar |
| UXSTATS2_TP2 | FUNCTION UXSTATS2_TP2(t AS F64, df AS F64) AS F64 | `tp2` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_ChiSquareP | FUNCTION UXSTATS2_ChiSquareP(stat AS F64, df AS F64) AS F64 | `chi square p` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_FP | FUNCTION UXSTATS2_FP(stat AS F64, df1 AS F64, df2 AS F64) AS F64 | `fp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_OneSampleTStat | FUNCTION UXSTATS2_OneSampleTStat(x AS U64, mu0 AS F64) AS F64 | `one sample tstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_OneSampleTP | FUNCTION UXSTATS2_OneSampleTP(x AS U64, mu0 AS F64) AS F64 | `one sample tp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_WelchTStat | FUNCTION UXSTATS2_WelchTStat(x AS U64, y AS U64) AS F64 | `welch tstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_WelchTP | FUNCTION UXSTATS2_WelchTP(x AS U64, y AS U64) AS F64 | `welch tp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_PooledTStat | FUNCTION UXSTATS2_PooledTStat(x AS U64, y AS U64) AS F64 | `pooled tstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_PooledTP | FUNCTION UXSTATS2_PooledTP(x AS U64, y AS U64) AS F64 | `pooled tp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_PairedTStat | FUNCTION UXSTATS2_PairedTStat(before AS U64, after AS U64) AS F64 | `paired tstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_PairedTP | FUNCTION UXSTATS2_PairedTP(before AS U64, after AS U64) AS F64 | `paired tp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_OneSampleZStat | FUNCTION UXSTATS2_OneSampleZStat(x AS U64, mu0 AS F64, sigma AS F64) AS F64 | `one sample zstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_OneSampleZP | FUNCTION UXSTATS2_OneSampleZP(x AS U64, mu0 AS F64, sigma AS F64) AS F64 | `one sample zp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_TwoSampleZStat | FUNCTION UXSTATS2_TwoSampleZStat(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64 | `two sample zstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_TwoSampleZP | FUNCTION UXSTATS2_TwoSampleZP(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64 | `two sample zp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_OnePropZStat | FUNCTION UXSTATS2_OnePropZStat(successes AS I32, n AS I32, p0 AS F64) AS F64 | `one prop zstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_OnePropZP | FUNCTION UXSTATS2_OnePropZP(successes AS I32, n AS I32, p0 AS F64) AS F64 | `one prop zp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_TwoPropZStat | FUNCTION UXSTATS2_TwoPropZStat(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64 | `two prop zstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_TwoPropZP | FUNCTION UXSTATS2_TwoPropZP(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64 | `two prop zp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_FVarianceStat | FUNCTION UXSTATS2_FVarianceStat(x AS U64, y AS U64) AS F64 | varyans hesaplar |
| UXSTATS2_FVarianceP | FUNCTION UXSTATS2_FVarianceP(x AS U64, y AS U64) AS F64 | varyans hesaplar |
| UXSTATS2_ChiSquareGOFStat | FUNCTION UXSTATS2_ChiSquareGOFStat(obs AS U64, exp AS U64) AS F64 | `chi square gofstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_ChiSquareGOFP | FUNCTION UXSTATS2_ChiSquareGOFP(obs AS U64, exp AS U64) AS F64 | `chi square gofp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_ChiSquare2x2Stat | FUNCTION UXSTATS2_ChiSquare2x2Stat(a AS F64, b AS F64, c AS F64, d AS F64) AS F64 | `chi square2x2 stat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_ChiSquare2x2P | FUNCTION UXSTATS2_ChiSquare2x2P(a AS F64, b AS F64, c AS F64, d AS F64) AS F64 | `chi square2x2 p` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_AnovaOneWayF | FUNCTION UXSTATS2_AnovaOneWayF(values AS U64, groups AS U64) AS F64 | yeni bir nesne/handle oluşturur |
| UXSTATS2_AnovaOneWayP | FUNCTION UXSTATS2_AnovaOneWayP(values AS U64, groups AS U64) AS F64 | yeni bir nesne/handle oluşturur |
| UXSTATS2_PosthocBonferroniTP | FUNCTION UXSTATS2_PosthocBonferroniTP(values AS U64, groups AS U64, g1 AS F64, g2 AS F64, comparisons AS I32) AS F64 | `posthoc bonferroni tp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_PosthocTukeyQ | FUNCTION UXSTATS2_PosthocTukeyQ(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64 | `posthoc tukey q` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_PosthocScheffeF | FUNCTION UXSTATS2_PosthocScheffeF(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64 | `posthoc scheffe f` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_CovarianceSamp | FUNCTION UXSTATS2_CovarianceSamp(x AS U64, y AS U64) AS F64 | varyans hesaplar |
| UXSTATS2_Correlation | FUNCTION UXSTATS2_Correlation(x AS U64, y AS U64) AS F64 | korelasyon hesaplar |
| UXSTATS2_RegressionSlope | FUNCTION UXSTATS2_RegressionSlope(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS2_RegressionIntercept | FUNCTION UXSTATS2_RegressionIntercept(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS2_RegressionR2 | FUNCTION UXSTATS2_RegressionR2(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS2_RegressionF | FUNCTION UXSTATS2_RegressionF(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS2_RegressionFP | FUNCTION UXSTATS2_RegressionFP(x AS U64, y AS U64) AS F64 | regresyon istatistiği hesaplar |
| UXSTATS2_VIFPair | FUNCTION UXSTATS2_VIFPair(x AS U64, y AS U64) AS F64 | `vifpair` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_DurbinWatson | FUNCTION UXSTATS2_DurbinWatson(resid AS U64) AS F64 | `durbin watson` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_BreuschGodfreyLM | FUNCTION UXSTATS2_BreuschGodfreyLM(resid AS U64, lags AS I32) AS F64 | `breusch godfrey lm` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_BreuschGodfreyP | FUNCTION UXSTATS2_BreuschGodfreyP(resid AS U64, lags AS I32) AS F64 | `breusch godfrey p` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_ADFStat | FUNCTION UXSTATS2_ADFStat(y AS U64) AS F64 | `adfstat` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_ADFP | FUNCTION UXSTATS2_ADFP(y AS U64) AS F64 | `adfp` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_AncovaBinaryF | FUNCTION UXSTATS2_AncovaBinaryF(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64 | `ancova binary f` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_AncovaBinaryP | FUNCTION UXSTATS2_AncovaBinaryP(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64 | `ancova binary p` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_HotellingT2_2D | FUNCTION UXSTATS2_HotellingT2_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64 | `hotelling t2 2 d` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| UXSTATS2_HotellingP_2D | FUNCTION UXSTATS2_HotellingP_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64 | `hotelling p 2 d` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |

## uxtensor

1d-4d tensor, erişim, cebir ve matris işlemleri. Fonksiyonlar çoğunlukla `U64` handle kullanır; oluşturulan handle uygun `Free`/`Destroy` yordamıyla kapatılmalıdır.

| Ad | Kaynak imzası | Görev |
| --- | --- | --- |
| Version | FUNCTION Version() AS I32 | kütüphane sürümünü döndürür |
| Backend | FUNCTION Backend() AS STRING | etkin backend adını döndürür |
| Create1D | FUNCTION Create1D(n AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| Create2D | FUNCTION Create2D(rows AS I64, cols AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| Create3D | FUNCTION Create3D(a AS I64, b AS I64, c AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| Create4D | FUNCTION Create4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64 | yeni bir nesne/handle oluşturur |
| Free | SUB Free(t AS U64) | ayrılmış kaynağı serbest bırakır |
| Clone | FUNCTION Clone(t AS U64) AS U64 | nesnenin kopyasını oluşturur |
| SliceAxis0 | FUNCTION SliceAxis0(t AS U64, start AS I64, count AS I64) AS U64 | `slice axis0` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| DType | FUNCTION DType(t AS U64) AS I32 | veri tipi bilgisini döndürür |
| NDim | FUNCTION NDim(t AS U64) AS I32 | boyut bilgisini döndürür |
| Dim | FUNCTION Dim(t AS U64, axis AS I32) AS I64 | boyut bilgisini döndürür |
| Stride | FUNCTION Stride(t AS U64, axis AS I32) AS I64 | `stride` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Size | FUNCTION Size(t AS U64) AS I64 | boyut bilgisini döndürür |
| ElemSize | FUNCTION ElemSize(t AS U64) AS I64 | boyut bilgisini döndürür |
| DataPtr | FUNCTION DataPtr(t AS U64) AS U64 | ham veri adresi/işaretçisi döndürür |
| Fill | SUB Fill(t AS U64, value AS F64) | değerlerle doldurur |
| Zero | SUB Zero(t AS U64) | değerleri sıfırlar |
| GetFlat | FUNCTION GetFlat(t AS U64, index AS I64) AS F64 | belirtilen değeri okur |
| SetFlat | SUB SetFlat(t AS U64, index AS I64, value AS F64) | belirtilen değeri yazar |
| Get2D | FUNCTION Get2D(t AS U64, r AS I64, c AS I64) AS F64 | belirtilen değeri okur |
| Set2D | SUB Set2D(t AS U64, r AS I64, c AS I64, value AS F64) | belirtilen değeri yazar |
| Get3D | FUNCTION Get3D(t AS U64, a AS I64, b AS I64, c AS I64) AS F64 | belirtilen değeri okur |
| Set3D | SUB Set3D(t AS U64, a AS I64, b AS I64, c AS I64, value AS F64) | belirtilen değeri yazar |
| Get4D | FUNCTION Get4D(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64) AS F64 | belirtilen değeri okur |
| Set4D | SUB Set4D(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64, value AS F64) | belirtilen değeri yazar |
| Add | FUNCTION Add(a AS U64, b AS U64) AS U64 | öğe/kenar/değer ekler |
| Subtract | FUNCTION Subtract(a AS U64, b AS U64) AS U64 | `subtract` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Multiply | FUNCTION Multiply(a AS U64, b AS U64) AS U64 | `multiply` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Divide | FUNCTION Divide(a AS U64, b AS U64) AS U64 | `divide` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Scale | FUNCTION Scale(a AS U64, scalar AS F64) AS U64 | ölçekleme işlemi yapar |
| Sum | FUNCTION Sum(a AS U64) AS F64 | toplam hesaplar |
| Mean | FUNCTION Mean(a AS U64) AS F64 | ortalama hesaplar |
| Dot | FUNCTION Dot(a AS U64, b AS U64) AS F64 | skaler çarpım hesaplar |
| Norm2 | FUNCTION Norm2(a AS U64) AS F64 | norm hesaplar |
| MatMul | FUNCTION MatMul(a AS U64, b AS U64) AS U64 | matris çarpımı yapar |
| MatVec | FUNCTION MatVec(a AS U64, x AS U64) AS U64 | `mat vec` adlı kaynak işlemini, imzada belirtilen parametre ve dönüş tipleriyle gerçekleştirir |
| Transpose2D | FUNCTION Transpose2D(a AS U64) AS U64 | transpoz üretir |


# Ek F - Hızlı Hedef ve Güvenlik Tablosu

| Özellik | AST | MIR | x64 | JS/WASM |
| --- | --- | --- | --- | --- |
| Temel aritmetik/IF/FOR/FUNCTION | Çalışır | Çalışır | Çalışır | Çalışır |
| Dosya G/Ç | Çalışır | hedefe göre | Native runtime | Browser host/gate |
| CALL(DLL/API) | FFI runtime | FFI runtime | gerçek DLL/API | native-only reddi/host import |
| SHELL | native çalıştırıcı | native çalıştırıcı | gerçek süreç | reddedilir |
| PEEK/POKE | kontrollü runtime | hedefe göre | gerçek adres | reddedilir/lineer bellek ayrı |
| INLINE | fail-close | fail-close | gerçek emit/object/link | reddedilir |
| EVENT/THREAD/PIPE/PARALEL | görev runtime | görev runtime | native DLL/runtime | host desteği gerektirir |

# Ek G - Profesyonel Test Disiplini

Bir özelliği yalnız parser kabul ettiği için çalışır sayma. Dağıtımdan önce şu kanıtları iste:

1. Pozitif kaynak parser/semantic PASS.
2. Negatif kaynak doğru fazda FAIL.
3. AST interpreter beklenen stdout ve rc üretir.
4. MIR interpreter aynı sonucu üretir.
5. x64 ASM derleyicinin kendisi tarafından üretilir.
6. NASM/object/link başarıyla tamamlanır.
7. EXE beklenen stdout ve dönüş kodunu üretir.
8. JS/WASM native-only özelliği doğru reddeder veya gerçek host binding kullanır.
9. DLL dosyası, exportlar, bağımlılıklar ve FFI10 imzası doğrulanır.
10. Test koşucusu fallback/placeholder artefact üretmez.

# Son Söz

uXBasic’i profesyonel düzeyde kullanmak, yalnızca `PRINT` ve `IF` bilmek değildir. Tipleri, bit işlemlerini, dosya ve belleği, nesneleri, FFI sözleşmesini, görev sistemini, build araçlarını ve compiler katmanlarını birlikte anlamaktır. En iyi çalışma yöntemi şudur: küçük program yaz, AST ve MIR çıktısını incele, x64 veya web hedefini üret, pozitif ve negatif test ekle, sonra projeyi büyüt.


---

**Baskı notu:** Bu belge 22 Temmuz 2026 tarihinde `src1`, önceki PCK belgeleri, son düzeltme günlüğü ve INLINE native contract temel alınarak üretilmiştir.

---

# Cilt II — Uygulamalı, Profesyonel ve Ekstrem uXBasic Laboratuvarları

Bu cilt, ilk kitabın yoğun başvuru tablolarını değiştirmez. Amacı, o tablolardaki yüzeyi gerçek problem çözme akışlarına dönüştürmektir. Burada her örnek beş soruya cevap verir:

1. **Hangi sorun çözülüyor?**
2. **uXBasic’in hangi katmanı veya kütüphanesi kullanılıyor?**
3. **Veri ve kontrol akışı nasıl ilerliyor?**
4. **Hata olduğunda nereden teşhis edilir?**
5. **Program nasıl test edilip dağıtılır?**

Tam örnek dosyaları `uXBasic_Uygulamali_Laboratuvar_Ornekleri_20260723.zip` içindedir. Kitaptaki kod parçaları eğitim amacıyla kısaltılabilir; ZIP içindeki dosya tam sürümdür.

## Güvenlik ve etik sınır

Bu ciltteki ekran gözlem örneği yalnızca kendi geliştirdiğin veya açıkça test izni bulunan uygulamada kullanılmalıdır. Üçüncü taraf oyunda hile, süreç belleği okuma/yazma, DLL enjeksiyonu, anti-cheat atlatma ya da gizli kullanıcı girdisi üretme öğretilmez. Ekran örneği, kendi browser oyunundaki renkli test nesnelerini bulup QA raporu üretir.


# Bölüm 26 — Profesyonel Problem Çözme Modeli

Profesyonel programcı yalnız doğru kod yazmaz; yanlış sonucu **hangi katmanın** ürettiğini de bulur. uXBasic’te bir sorun aşağıdaki katmanlardan birinde doğabilir:

```text
Kaynak → Preprocessor → Lexer → Parser/AST → Semantic → MIR → Interpreter/Backend → Runtime/DLL → İşletim sistemi
```

## 26.1 Belirtiyi katmana bağlama

| Belirti | İlk bakılacak yer | Kanıt |
|---|---|---|
| Yönerge çıktı dosyası üretmiyor | Preprocessor A/B | preprocessed source, meta JSON |
| Komut tanınmıyor | Lexer/parser | token ve parser JSON |
| Tip uyuşmazlığı | Semantic | diagnostic code, inferred type |
| AST çalışıyor MIR farklı sonuç veriyor | MIR lowering/evaluator | AST–MIR stdout karşılaştırması |
| ASM var EXE yok | NASM/link | object, linker stderr |
| EXE açılıyor ama DLL çağrısı işlemiyor | FFI resolver/allowlist/runtime | invocation log, return code |
| Browser açılıyor ama oyun hareket etmiyor | JS/WASM/REST köprüsü | DevTools, `/health`, action/state zaman damgaları |

## 26.2 Minimum yeniden üretim

Büyük projedeki hatayı doğrudan düzeltmeye çalışma. Önce tek özelliği ölçen küçük dosya üret:

```uxbasic
MAIN
    DIM x AS U8
    x = U8(300)
    ASSERT x == 44
    PRINT "REPRO_PASS"
END MAIN
```

Bu dosya lex, par, sem, AST interpreter, MIR interpreter ve x64 üzerinde ayrı ayrı çalıştırılır. Böylece hata "programda" değil, belirli katmanda gösterilir.

## 26.3 Pozitif, negatif ve çapraz hedef testi

- Pozitif test beklenen girdinin kabulünü ve doğru çıktıyı ölçer.
- Negatif test yanlış girdinin açık hata vermesini ölçer.
- Çapraz hedef testi AST, MIR, x64, JS ve WASM sonuçlarını karşılaştırır.
- Native-only özellik JS/WASM’de reddediliyorsa bu **başarılı negatif testtir**.

## 26.4 Hata enjekte ederek dayanıklılık ölçme

Bir REST oyunu yalnız normal koşulda değil şu durumlarda da test edilmelidir:

- Flask sunucusu kapalı;
- cURL zaman aşımında;
- gelen durum eski;
- action değeri bilinmeyen metin;
- WASM yüklenemiyor;
- native EXE kapanıyor;
- DLL veya allowlist eksik;
- çıktı klasörü yazılamıyor.

Profesyonel çözüm, her arızayı aynı `0` değeriyle gizlemek değil; ayrı hata kodu, log ve geri kazanım davranışı üretmektir.


# Bölüm 27 — Veri Tipleri, Operatörler ve Bellek İçin Ekstrem Laboratuvarlar

## 27.1 Açık tip dönüşümü ve bit daraltma

`U8(300)` bilinçli wrapping dönüşümüdür. Normal `U8` atamasıyla aynı şey değildir. Test programı bütün ana tipleri, Boolean normalizasyonunu ve yalnız kendi değişkeninin adresinde PEEK/POKE kullanımını ölçer.

```uxbasic
' Veri tipleri, açık dönüşüm ve güvenli kendi-bellek testi
DIM byteValue AS U8
DIM signedByte AS I8
DIM wordValue AS U16
DIM integerValue AS I32
DIM realValue AS F64
DIM truthValue AS BOOLEAN
DIM rawValue AS I32
DIM rawPtr AS PTR

MAIN
    byteValue = U8(300)
    signedByte = I8(255)
    wordValue = U16(65537)
    integerValue = I32(12.9)
    realValue = F64(integerValue) / 5.0
    truthValue = BOOLEAN(realValue)

    ASSERT byteValue == 44
    ASSERT signedByte == -1
    ASSERT wordValue == 1
    ASSERT integerValue == 12
    ASSERT truthValue == TRUE

    ' PEEK/POKE yalnız kendi değişkenimizin adresinde kullanılır.
    rawValue = &H12345678
    rawPtr = VARPTR(rawValue)
    ASSERT PEEK(rawPtr) == &H12345678
    POKE rawPtr, &H01020304
    ASSERT rawValue == &H01020304

    PRINT "TYPE_EXTREME_PASS"
END MAIN

```

### Çalışma mantığı

- `U8(300)` alt 8 biti korur ve `44` üretir.
- `I8(255)` aynı bit desenini signed yorumlayıp `-1` üretir.
- `BOOLEAN(x)` sıfır dışı değeri `TRUE=-1` biçimine getirir.
- `VARPTR(rawValue)` yalnız programın kendi değişkenine ait güvenli adresi verir.
- `PEEK/POKE` yanlış veya yaşamı sona ermiş adreslerde kullanılmamalıdır.

## 27.2 Kısa devre, bit işlemi ve döndürme

```uxbasic
DIM touchCount AS I32

FUNCTION Touch() AS BOOLEAN
    touchCount += 1
    RETURN TRUE
END FUNCTION

MAIN
    DIM a AS U8
    DIM b AS U8
    DIM mask AS U8
    DIM q AS I32

    touchCount = 0
    IF FALSE ANDALSO Touch() THEN
        PRINT "UNREACHABLE"
    END IF
    ASSERT touchCount == 0

    IF TRUE ORELSE Touch() THEN
        ASSERT touchCount == 0
    END IF

    a = U8(&B10101010)
    b = U8(&B11001100)
    ASSERT (a AND b) == U8(&B10001000)
    ASSERT (a OR b) == U8(&B11101110)
    ASSERT (a XOR b) == U8(&B01100110)

    mask = U8(129)
    mask ROL= 1
    ASSERT mask == 3
    mask ROR= 1
    ASSERT mask == 129

    q = 25
    q += 5
    q *= 2
    q \= 3
    ASSERT q == 20

    ASSERT (5 ** 3) == 125
    ASSERT (17 MOD 5) == 2
    ASSERT (16 SHR 2) == 4
    ASSERT (1 SHL 7) == 128

    PRINT "OPERATORS_EXTREME_PASS"
END MAIN

```

Burada `ANDALSO` ve `ORELSE`, sağ tarafın çağrılıp çağrılmadığını `touchCount` ile kanıtlar. `AND/OR/XOR` ise eager bit işlemidir. `ROL` ve `ROR` bitleri kaybetmez; uçtan çıkan biti diğer uca taşır.

## 27.3 Hangi operatör hangi sorunda seçilir?

| Sorun | Doğru araç | Yanlış seçim riski |
|---|---|---|
| Sıfıra bölme koruması | `den <> 0 ANDALSO num/den > 2` | `AND` sağ tarafı da çalıştırabilir |
| Flag birleştirme | `flags OR MASK` | `ORELSE` Boolean sonuç üretir |
| Hash/şifre bit karıştırma | `ROL`, `ROR`, `XOR` | `SHL/SHR` bit kaybeder |
| Paket alanı çıkarma | `AND`, `SHR` | normal bölme signed davranış yaratabilir |
| Eşik seçme | `IF`, üçlü/pipe yüzeyi | bit operatörü anlamı bozabilir |

## 27.4 TYPE, CLASS, MAGIC ve hata bağlamı

```uxbasic
TYPE Measurement
    name AS STRING
    value AS F64
    quality AS I32
END TYPE

CLASS RunningAverage
    PRIVATE total AS F64
    PRIVATE count AS I32

    METHOD Add(value AS F64)
        total = total + value
        count = count + 1
    END METHOD

    FUNCTION Mean() AS F64
        IF count == 0 THEN RETURN 0.0
        RETURN total / F64(count)
    END FUNCTION

    MAGIC TOSTRING() AS STRING
        RETURN "RunningAverage(count=" + STR(count) + ")"
    END MAGIC
END CLASS

MAIN
    DIM m AS Measurement
    DIM avg AS RunningAverage

    m.name = "pH"
    m.value = 7.25
    m.quality = 100

    avg = NEW RunningAverage()
    avg.Add(m.value)
    avg.Add(7.15)

    TRY
        ASSERT avg.Mean() > 7.0, "ortalama beklenen aralikta degil"
        PRINT avg.Mean()
    CATCH err
        PRINT __ERR_KIND
        PRINT __ERR_CODE
        PRINT __ERR_MESSAGE
        PRINT __ERR_LINE
    FINALLY
        PRINT "ERROR_FRAME_CLOSED"
    END TRY

    DELETE avg
    PRINT "STRUCTURE_ERROR_PASS"
END MAIN

```

Bu program üç soyutlama seviyesini birleştirir:

- `TYPE`, yalnız veri kaydıdır.
- `CLASS`, durum ve davranışı aynı nesnede tutar.
- `MAGIC TOSTRING`, nesnenin metin temsilini özelleştirir.
- `TRY/CATCH/FINALLY`, normal sonuçtan farklı bir hata akışı oluşturur.
- `__ERR_*` alanları yalnız aktif hata çerçevesinin teşhis bilgisidir.


# Bölüm 28 — Preprocessor ile Kaynak Üreten Profesyonel Programlama

Preprocessor yalnız sabit değiştirme aracı değildir. Hedef, asset, web dosyası, WAT modülü, manifest, profil ve test üretimi için ayrı bir küçük derleme dilidir.

## 28.1 Profil tabanlı kaynak

```uxbasic
%%PP B
%%SET BUILD_PROFILE = "DEBUG"
%%SET GAME_TITLE = "uXBasic Hybrid Lab"
%%DEFINE MAX_ENEMIES 16
%%EVAL DOUBLE_ENEMIES = MAX_ENEMIES * 2
%%ASSERT_META DOUBLE_ENEMIES >= 32
%%TARGET WEB
%%OUTDIR "dist/preprocessor_lab"
%%ALLOW_RAW_JS
%%ALLOW_RAW_WAT
%%MANIFEST_SET "name", "uxbasic-preprocessor-lab"
%%MANIFEST_SET "version", "2.0.0"
%%MANIFEST_REQUIRE "name"

%%IF BUILD_PROFILE == "DEBUG"
CONST TRACE_ENABLED AS BOOLEAN = TRUE
%%ELSE
CONST TRACE_ENABLED AS BOOLEAN = FALSE
%%ENDIF

%%HTML_BEGIN "index.html" BODY
<!doctype html>
<html><body><h1>{{GAME_TITLE}}</h1><script src="program.js"></script></body></html>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("preprocessor profile ready");
%%JS_END

%%WAT_BEGIN "math.wat"
(module
  (func (export "add") (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.add))
%%WAT_END

MAIN
    IF TRACE_ENABLED THEN PRINT "DEBUG_PROFILE"
    PRINT "MAX_ENEMIES=" + STR(MAX_ENEMIES)
    PRINT "PREPROCESSOR_PASS"
END MAIN

```

### Akış

1. `%%PP B` motoru seçer.
2. `%%SET`, profil ve başlık değerlerini kurar.
3. `%%DEFINE` sabit sembol oluşturur.
4. `%%EVAL` derleme zamanı hesabı yapar.
5. `%%ASSERT_META`, yanlış yapılandırmayı parser’a ulaşmadan durdurur.
6. `%%TARGET/%%OUTDIR`, artefact yönünü belirler.
7. HTML, JS ve WAT blokları ayrı dosyalara yazılır.
8. Normal uXBasic `MAIN` bölümü kendi hedef akışını sürdürür.

## 28.2 Normal, profesyonel ve ekstrem kullanım

### Normal

```uxbasic
%%DEFINE DEBUG 1
%%IF DEBUG
PRINT "debug"
%%ENDIF
```

### Profesyonel

```uxbasic
%%SET PROFILE = "RELEASE"
%%IF PROFILE == "RELEASE"
%%MINIFY ON
%%FINGERPRINT_ASSETS ON
%%SECSTACK ON
%%ENDIF
```

### Ekstrem: test üretimi

```uxbasic
%%FOREACH WIDTH IN "8,16,32,64"
%%EMITNOTE "integer-width={{WIDTH}}"
%%ENDFOREACH
```

Bu desenle benzer testlerin elle kopyalanması azaltılır. Ancak üretilen kaynak sayısı `%%EXPANDLIMIT` ile sınırlandırılmalıdır; sınırsız meta döngüsü build süresini ve rapor boyutunu büyütür.

## 28.3 Güvenli raw blok kuralı

Raw JS veya WAT için hedef ve izin birlikte belirtilir:

```uxbasic
%%TARGET WEB
%%ALLOW_RAW_JS
%%ALLOW_RAW_WAT
%%SAFE_PATHS ON
```

Hedefsiz raw kodun kabul edilmesi, web/native sınırını belirsizleştirir. Üretim profilinde `%%ASSERT_META` ile bu kapılar zorunlu tutulmalıdır.

## 28.4 Asset ve manifest zekâsı

Bir oyunun kodu kadar asset sürümü de önemlidir. `%%HASHFILE` ve `%%FINGERPRINT_ASSETS`, cache’de eski resim/JS tutulmasını önlemek için kullanılabilir. `%%MANIFEST_REQUIRE`, uygulama adı, sürüm ve köprü adresi eksik olduğunda build’i keser.


# Bölüm 29 — Standart Kütüphaneleri Gerçek Projede Kullanma

Kütüphane kullanımında en önemli desen şudur:

```text
Version/Backend → Create/Open/Load → Veri doldur → İşlem → Sonuç denetle → Free/Destroy
```

Handle çoğunlukla `U64` değeridir. Handle’ı normal sayı gibi değiştirmek, yanlış kütüphaneye vermek veya Free çağrısından sonra kullanmak hatadır.

| Kütüphane | Ana amaç | Kaynaktaki FUNCTION/SUB sayısı | Tipik akış |
|---|---|---:|---|
| `uxcollections` | Liste, stack, queue, dict, set ve tree | 27 | ListNew → veri ekle/oku → ListFree; aynı kalıp diğer koleksiyonlarda |
| `uxdataframe` | DuckDB tabanlı tablo, CSV, Parquet ve SQL | 31 | LoadCSV/OpenMemory → Filter/Query/GroupMean → ToCSV → Free |
| `uxdataset` | ML veri seti, split, scaler ve batch loader | 34 | Load/Create → eksik veri → split → scale → batch → Free |
| `uxgraph` | Graf, yol, bileşen ve derece analizi | 30 | Create/Read → AddEdge → analiz → VecFree → Free |
| `uxstats` | Tanımlayıcı istatistik, korelasyon ve regresyon | 83 | VecCreate → VecPush → ölçümler → VecFree |
| `uxmatrix` | Matris oluşturma ve lineer cebir | 34 | Create/Set → MatMul/Transpose/solve → Free |
| `uxtensor` | 1D–4D tensor, eleman işlemleri ve matmul | 38 | Create → Set/Fill → hesap → Free |
| `uxaimath` | Aktivasyonlar, kayıp fonksiyonları ve optimizasyon yardımcıları | 46 | veri pointer/tensor → aktivasyon/kayıp → güncelleme |
| `uxnn` | Nöron, katman ve ağ çalıştırma | 33 | NetworkCreate → layer ekle → forward/train → NetworkFree |
| `uxnn2` | Model/dataset odaklı eğitim yüzeyi | 23 | DatasetCreate/Load → ModelCreate → AddDense → Train → Save/Free |
| `uxnn3` | Dataset training ve daha yüksek seviye eğitim | 33 | dataset → model → optimizer → train/eval → save |
| `uxonnx` | ONNX Runtime temel inference | 21 | Init → SessionCreate → TensorCreate → Run1 → Free |
| `uxonnx2` | Gelişmiş provider, run builder ve çoklu output | 42 | Init → SessionCreateAdvanced → RunCreate/Execute → Free |
| `uxllama` | Yerel llama.cpp CLI/model köprüsü | 17 | Create → yollar/ayarlar → Prompt → LastError → Free |
| `uxmath` | F64 vektör handle yüzeyi | 9 | VecCreate → Push/Set/Get → DataPtr → Free |
| `uxmathcore` | Tipli native buffer ve düşük seviye sayısal bellek | 51 | TypeId → BufferCreate → DataPtr/ops → BufferFree |

## 29.1 Ortak kütüphane kapısı

Her program şu soruları cevaplamalıdır:

1. DLL gerçekten var mı?
2. `Version()` beklenen değeri veriyor mu?
3. `Backend()` hangi motoru bildiriyor?
4. Create/Open/Load başarısızsa `LastError` ne diyor?
5. Her handle tam bir kez kapatılıyor mu?
6. AST/MIR yalnız çağrı sözleşmesini mi, yoksa DLL’yi gerçekten mi çalıştırıyor?
7. JS/WASM hedefinde native çağrı doğru biçimde reddediliyor mu?

## 29.2 uxcollections: veri yapısını probleme göre seçme

- Liste: sıra korunur, indeksle okunur.
- Stack: son giren ilk çıkar; undo, parser ve DFS için uygundur.
- Queue: ilk giren ilk çıkar; iş kuyruğu, event ve BFS için uygundur.
- Dict: anahtar–değer yapılandırması ve cache.
- Set: benzersizlik ve hızlı üyelik testi.
- Tree: hiyerarşik anahtar düzeni.

```uxbasic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections

MAIN
    DIM listH AS U64
    DIM stackH AS U64
    DIM queueH AS U64
    DIM dictH AS U64
    DIM setH AS U64
    DIM treeH AS U64

    ASSERT Version() > 0

    listH = ListNew()
    ASSERT listH <> 0
    ListPushF64(listH, 10.5)
    ListPushF64(listH, 20.5)
    ASSERT ListCount(listH) == 2
    ASSERT ListGetF64(listH, 1) == 20.5

    stackH = StackNew()
    StackPushF64(stackH, 1.0)
    StackPushF64(stackH, 2.0)
    ASSERT StackPopF64(stackH) == 2.0

    queueH = QueueNew()
    QueuePushF64(queueH, 7.0)
    QueuePushF64(queueH, 8.0)
    ASSERT QueuePopF64(queueH) == 7.0

    dictH = DictNew()
    DictSetF64(dictH, "temperature", 18.75)
    ASSERT DictHas(dictH, "temperature") <> 0
    ASSERT DictGetF64(dictH, "temperature") == 18.75

    setH = SetNew()
    SetAdd(setH, "critical")
    ASSERT SetContains(setH, "critical") <> 0

    treeH = TreeNew()
    TreeSetF64(treeH, "tank/1/ph", 7.2)
    ASSERT TreeGetF64(treeH, "tank/1/ph") == 7.2

    TreeFree(treeH)
    SetFree(setH)
    DictFree(dictH)
    QueueFree(queueH)
    StackFree(stackH)
    ListFree(listH)

    PRINT "COLLECTIONS_WORKBENCH_PASS"
END MAIN

```

### Problem çözme örnekleri

- Undo sistemi: her değişiklik öncesi eski değer stack’e konur.
- Thread iş dağıtımı: işler queue’ya, tamamlanan kimlikler set’e yazılır.
- Oyun ayarları: ses, çözünürlük ve zorluk dict içinde tutulur.
- Sahne grafiği: `world/room/object` anahtarları tree yapısına yazılır.

## 29.3 uxstats ve uxstats2: ölçümden karara

```uxbasic
INCLUDE "libsx/uxstats/uxstats.bas"

MAIN
    DIM values AS U64
    DIM meanValue AS F64
    DIM stdValue AS F64
    DIM z AS F64

    ASSERT UXSTATS_Version() > 0
    values = UXSTATS_VecCreate(16)
    ASSERT values <> 0

    UXSTATS_VecPush(values, 7.10)
    UXSTATS_VecPush(values, 7.20)
    UXSTATS_VecPush(values, 7.15)
    UXSTATS_VecPush(values, 7.18)
    UXSTATS_VecPush(values, 8.20) ' kasitli aykiri deger

    meanValue = UXSTATS_Mean(values)
    stdValue = UXSTATS_StdDevSamp(values)
    z = (8.20 - meanValue) / stdValue

    PRINT "MEAN=" + STR(meanValue)
    PRINT "STD=" + STR(stdValue)
    PRINT "OUTLIER_Z=" + STR(z)
    ASSERT UXSTATS_VecCount(values) == 5

    UXSTATS_VecFree(values)
    PRINT "STATISTICS_QC_PASS"
END MAIN

```

Normal kullanım ortalama ve standart sapmadır. Profesyonel kullanım korelasyon, regresyon ve güven aralıklarını kapsar. Ekstrem kullanımda `uxstats2` ile Welch t-testi, ANOVA, ki-kare ve post-hoc analizleri otomatik kalite kapısına bağlanabilir.

Önemli hata: p-değerini tek başına karar kabul etmek. Etki büyüklüğü, örnek sayısı, veri kalitesi ve çoklu karşılaştırma düzeltmesi birlikte yorumlanmalıdır.

## 29.4 uxdataframe: CSV’den SQL tabanlı karar hattına

```uxbasic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe

MAIN
    DIM df AS U64
    DIM filtered AS U64
    DIM summary AS U64
    DIM rc AS I32

    ASSERT RuntimeVersion() > 0
    ASSERT DuckDBAvailable() <> 0

    df = LoadCSV("data/measurements.csv", 1)
    IF df == 0 THEN
        PRINT LastError(df)
        THROW "CSV acilamadi"
    END IF

    filtered = Filter(df, "ph BETWEEN 6.8 AND 7.8 AND oxygen >= 6.0")
    summary = GroupMean(filtered, "tank", "temperature")
    rc = ToCSV(summary, "out/tank_temperature_mean.csv")
    ASSERT rc <> 0

    PRINT "ROWS=" + STR(RowCount(filtered))

    Free(summary)
    Free(filtered)
    Free(df)
    PRINT "DATAFRAME_PIPELINE_PASS"
END MAIN

```

Akış:

```text
CSV → DataFrame handle → filtre → group mean → CSV/Parquet çıktı → Free
```

- `Filter` ve `OrderBy` kullanıcı girdisini doğrudan SQL’e ekliyorsa güvenilmeyen girdiler temizlenmelidir.
- Her ara DataFrame ayrı handle olabilir; yalnız ana tabloyu kapatmak yetmez.
- `ToF64Matrix` sonucunun kendi `MatrixFree` yordamı vardır.

## 29.5 uxdataset: veri sızıntısını önleyen eğitim hattı

```uxbasic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset

MAIN
    DIM ds AS U64
    DIM trainDs AS U64
    DIM testDs AS U64
    DIM scaler AS U64
    DIM loader AS U64
    DIM batchCount AS I32

    ASSERT Version() > 0
    ds = LoadCSV("data/training.csv", 4, 1, 1)
    ASSERT ds <> 0

    FillMissingMean(ds)
    trainDs = SplitTrain(ds, 0.80, U64(2026))
    testDs = SplitTest(ds, 0.80, U64(2026))

    scaler = ScalerFitStandard(trainDs)
    ScalerTransform(scaler, trainDs)
    ScalerTransform(scaler, testDs)

    loader = BatchCreate(trainDs, 16, 1, U64(2026))
    batchCount = 0
    WHILE BatchNext(loader) <> 0
        batchCount += 1
        PRINT "BATCH_ROWS=" + STR(BatchRows(loader))
    WEND

    ASSERT batchCount > 0

    BatchFree(loader)
    ScalerFree(scaler)
    Free(testDs)
    Free(trainDs)
    Free(ds)
    PRINT "DATASET_BATCH_PASS"
END MAIN

```

Profesyonel sıra önemlidir:

1. Veri setini yükle.
2. Eksik değer politikasını uygula.
3. Train/test ayır.
4. Scaler’ı **yalnız train** üzerinde fit et.
5. Aynı scaler ile train ve test’i dönüştür.
6. Batch loader oluştur.
7. Eğitim sonunda loader, scaler ve bütün split handle’larını kapat.

Scaler’ı bütün veri üzerinde fit etmek test bilgisini eğitime sızdırır.

## 29.6 uxgraph: yol bulma ve bağımlılık analizi

```uxbasic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph

MAIN
    DIM g AS U64
    DIM distances AS U64
    DIM i AS I32

    g = Create(6, 0)
    ASSERT g <> 0

    AddEdge(g, 0, 1)
    AddEdge(g, 1, 2)
    AddEdge(g, 2, 3)
    AddEdge(g, 3, 4)
    AddEdge(g, 4, 5)
    AddEdge(g, 0, 5)

    ASSERT PathExists(g, 0, 3) <> 0
    ASSERT ShortestDistance(g, 0, 3) == 3
    PRINT "DENSITY=" + STR(Density(g))

    distances = BFSDistances(g, 0)
    FOR i = 0 TO VecCount(distances) - 1
        PRINT "D[" + STR(i) + "]=" + STR(VecGet(distances, i))
    NEXT

    VecFree(distances)
    Free(g)
    PRINT "GRAPH_ROUTE_PASS"
END MAIN

```

Kullanım alanları:

- şehir/yol;
- modül bağımlılık grafiği;
- sosyal ağ;
- görev öncelik ağı;
- oyun sahne geçişleri;
- servisler arası çağrı haritası.

`BFSDistances` yeni bir vektör handle döndürür ve `VecFree` ile kapatılır. Grafik ve sonuç vektörünün yaşam döngüleri ayrıdır.

## 29.7 uxtensor ve uxmatrix: şekil sözleşmesi

```uxbasic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor

MAIN
    DIM a AS U64
    DIM b AS U64
    DIM c AS U64
    DIM t AS U64

    ASSERT Version() > 0
    a = Create2D(2, 3)
    b = Create2D(3, 2)

    Set2D(a, 0, 0, 1.0)
    Set2D(a, 0, 1, 2.0)
    Set2D(a, 0, 2, 3.0)
    Set2D(a, 1, 0, 4.0)
    Set2D(a, 1, 1, 5.0)
    Set2D(a, 1, 2, 6.0)

    Set2D(b, 0, 0, 7.0)
    Set2D(b, 0, 1, 8.0)
    Set2D(b, 1, 0, 9.0)
    Set2D(b, 1, 1, 10.0)
    Set2D(b, 2, 0, 11.0)
    Set2D(b, 2, 1, 12.0)

    c = MatMul(a, b)
    ASSERT Get2D(c, 0, 0) == 58.0
    ASSERT Get2D(c, 1, 1) == 154.0

    t = Transpose2D(c)
    PRINT "SUM=" + STR(Sum(t))
    PRINT "NORM=" + STR(Norm2(t))

    Free(t)
    Free(c)
    Free(b)
    Free(a)
    PRINT "TENSOR_MATRIX_PASS"
END MAIN

```

Matmul hatalarının çoğu değer değil **shape** hatasıdır. `A(m×n)` ile `B(n×p)` çarpılır. Her işlemden önce `Dim`, `NDim`, `Rows`, `Cols` ve `Size` değerleri assert edilmelidir.

Ekstrem kullanımda pointer tabanlı fonksiyonlar hız sağlar; ancak buffer tipi, eleman boyutu, hizalama ve yaşam süresi yanlışsa süreç çökebilir. Önce handle API’siyle doğrula, sonra pointer yoluna geç.

## 29.8 uxaimath, uxnn ve eğitim aileleri

`uxaimath` aktivasyon, kayıp, gradient ve optimizer yardımcıları sağlar. `uxnn` düşük/orta seviyeli ağ; `uxnn2/uxnn3` dataset ve eğitim akışına daha yakın yüzeyler sağlar.

Profesyonel kontrol listesi:

- seed sabit mi?
- giriş ve çıkış boyutları eşleşiyor mu?
- aktivasyon kodu geçerli mi?
- loss NaN/Infinity oldu mu?
- gradient normu sınırlandı mı?
- train/test ayrımı doğru mu?
- model kaydetme ve yeniden yükleme sonucu aynı mı?

## 29.9 uxonnx ve uxonnx2

Temel inference akışı:

```text
Init runtime → SessionCreate → input/output adlarını sor → TensorCreate → veri yaz → Run → sonucu oku → bütün handle’ları Free
```

Modeldeki input adı varsayılmamalıdır; `InputName` ve `OutputName` ile okunmalıdır. Provider seçimi `uxonnx2` üzerinde açıkça denetlenmelidir. CPU dışında provider istenip bulunamazsa sessiz CPU fallback yerine log üretilmelidir.

## 29.10 uxllama

`uxllama` yerel model/CLI köprüsüdür. Akış:

```text
Create → SetCliPath → SetModelPath → thread/context/predict ayarları → ModelExists → Prompt → LastError/LastCommand → Free
```

Çıktı tamponu pointer ve kapasiteyle verilir. Tampon boyutu, sonlandırıcı bayt ve UTF-8 dönüşümü ayrı test edilmelidir. Model ve CLI bulunmadan yalnız wrapper çağrısının parse edilmesi gerçek inference kanıtı değildir.


# Bölüm 30 — cURL, REST ve Flask ile uXBasic Haberleşmesi

uXBasic’in native programı HTTP işini iki şekilde yapabilir:

1. `SHELL` ile `curl.exe` çağırmak;
2. ayrı bir HTTP DLL/wrapper kullanmak.

Bu cilt taşınabilir ve gözlenebilir olduğu için cURL yolunu kullanır.

## 30.1 Flask köprüsünün görevi

Flask, browser ile native EXE arasında ortak posta kutusu gibi davranır. Browser JSON yollarını, uXBasic ise ayrıştırması kolay metin yolunu kullanır.

Temel endpoint’ler:

| Endpoint | Yön | Görev |
|---|---|---|
| `GET /health` | herkes → bridge | servis canlı mı |
| `POST /api/state` | browser → bridge | oyun durumunu JSON gönderir |
| `GET /api/native/state.txt` | EXE ← bridge | pipe ayrımlı sade durum |
| `POST /api/native/action.txt` | EXE → bridge | `UP/DOWN/LEFT/RIGHT/NONE` |
| `GET /api/action` | browser ← bridge | son native kararı JSON alır |

## 30.2 uXBasic cURL istemcisi

```uxbasic
DIM body AS STRING
DIM errors AS STRING
DIM rc AS I32
DIM value AS I32

MAIN
    SHELL "curl.exe -s http://127.0.0.1:8766/health" TIMEOUT 5 OUTVAR body ERRVAR errors CODEVAR rc
    ASSERT rc == 0
    PRINT body

    SHELL "curl.exe -s -X POST --data 42 http://127.0.0.1:8766/api/value.txt" TIMEOUT 5 OUTVAR body ERRVAR errors CODEVAR rc
    ASSERT rc == 0
    ASSERT body == "OK"

    SHELL "curl.exe -s http://127.0.0.1:8766/api/value.txt" TIMEOUT 5 OUTVAR body ERRVAR errors CODEVAR rc
    ASSERT rc == 0
    value = I32(VAL(body))
    ASSERT value == 42

    PRINT "CURL_REST_PASS"
END MAIN

```

`OUTVAR`, HTTP gövdesini; `ERRVAR`, cURL tanısını; `CODEVAR`, süreç çıkış kodunu taşır. HTTP 404 ile cURL süreç kodu her zaman aynı değildir; üretim kodunda `--fail-with-body` kullanmak faydalıdır.

## 30.3 Dayanıklı istemci deseni

```text
istek → timeout → rc kontrol → body biçim kontrolü → parse → yaş/zaman damgası kontrolü → karar
```

Retry yapılacaksa sonsuz döngü kurma. Örneğin 3 deneme ve artan bekleme kullan:

```text
100 ms → 250 ms → 500 ms → circuit open
```

## 30.4 Güvenlik

- Bridge yalnız `127.0.0.1` üzerinde dinler.
- Gelen action allowlist ile doğrulanır.
- Browser’dan gelen sayılar tipe çevrilmeden önce sınırlandırılır.
- Komut satırına kullanıcı metni doğrudan birleştirilmez.
- Üretim ortamında token veya session kimliği kullanılabilir.


# Bölüm 31 — Browser + JavaScript + WAT/WASM + x64 EXE İki Yönlü Oyun

## 31.1 Mimari

```text
Kullanıcı
  ↓ klavye
HTML Canvas Oyunu
  ↔ JavaScript durum ve çizim
  ↔ WAT/WASM hızlı clamp/mesafe fonksiyonları
  ↔ HTTP/JSON
Flask localhost köprüsü
  ↔ sade metin/cURL
uXBasic x64 Yapay Zekâ EXE
```

Bu mimaride tek bir bileşen her işi yapmaz:

- Browser kullanıcı etkileşimi ve çizimden sorumludur.
- WASM küçük, deterministik ve sık hesaplanan fonksiyonları yapar.
- x64 EXE yüksek seviyeli karar üretir.
- Flask taraflar arasında durum/action sözleşmesini taşır.
- JavaScript orkestrasyon yapar; oyunun bütün zekâsını tek başına üstlenmez.

## 31.2 Otorite modeli

Dağıtık oyunda aynı değişkeni iki tarafın yazması çatışma yaratır. Bu örnekte:

| Veri | Yetkili taraf |
|---|---|
| Oyuncu konumu | browser |
| Düşman yön kararı | x64 EXE |
| Düşman konumunun uygulanması | browser |
| Clamp ve Manhattan mesafesi | WASM |
| Son durum/action saklama | Flask |

## 31.3 Native AI

Native ajan, Flask’tan pipe ayrımlı durum alır. Düşmanın oyuncuya yatay mı dikey mi yaklaşacağına karar verir ve action gönderir. Tam kod örnek paketindedir.

Önemli nokta: EXE browser’ın belleğine veya sürecine dokunmaz. İki program açık REST sözleşmesiyle haberleşir.

## 31.4 WASM rolü

WAT modülü iki fonksiyon export eder:

```wat
(func (export "clamp_i32") ...)
(func (export "manhattan_i32") ...)
```

WASM yüklenemezse JS eşdeğer fallback kullanır ve ekranda `wasm:false` bilgisi görünür. Bu, sistemin sessizce farklı davranmasını önler.

## 31.5 JavaScript oyun döngüsü

Her frame’de çizim yapılır; REST alışverişi ise yaklaşık 80 ms’de bir yürür. HTTP’yi her animasyon frame’inde çağırmak gereksiz yük ve gecikme oluşturur.

```text
requestAnimationFrame: 60 Hz çizim
REST exchange: yaklaşık 12.5 Hz durum/karar
Native AI: yaklaşık 16 Hz polling
```

## 31.6 Çalıştırma

```powershell
python -m pip install flask
wat2wasm .\wasm\game_math.wat -o .\web\game_math.wasm
python .\bridge\flask_game_bridge.py
```

Başka terminalde native AI derlenir ve çalıştırılır:

```powershell
.\bin\uxb.exe bld .\native\native_enemy_ai.uxb --build-x64-out .\build\native_ai
.\build\native_ai\program.exe
```

Tarayıcı:

```text
http://127.0.0.1:8765/
```

## 31.7 Sorun giderme

| Belirti | Muhtemel neden | Test |
|---|---|---|
| Sayfa açılmıyor | Flask çalışmıyor | `/health` |
| Oyuncu hareket ediyor düşman duruyor | native EXE/action yok | `/api/action` |
| EXE state alamıyor | cURL/yol/port | `curl /api/native/state.txt` |
| WASM false | `.wasm` yok veya MIME yanlış | DevTools Network |
| Düşman sıçrıyor | birden çok action uygulama veya stale state | tick/timestamp logu |
| CPU yüksek | polling çok sık | interval artır |

## 31.8 Akıllı geliştirmeler

- REST yerine WebSocket ile düşük gecikme;
- action’a `tick` ekleyerek eski kararları reddetme;
- ring buffer ile son 128 durum;
- x64 tarafında uxonnx ile model inference;
- browser tarafında WASM fizik;
- replay dosyası ve deterministik seed;
- iki EXE ajanı için conflict resolver;
- native ajan yoksa browser heuristiği.


# Bölüm 32 — Preprocessor ile HTML, JS ve WAT Oyun Paketi Üretmek

Aynı uXBasic kaynağı, normal program kodunun yanında web artefact’larını da üretebilir.

```uxbasic
%%PP B
%%TARGET WEB
%%OUTDIR "dist/hybrid_arena"
%%ALLOW_RAW_JS
%%ALLOW_RAW_WAT
%%SAFE_PATHS ON
%%REQUIRE_HOST_BINDING
%%BUNDLE_NAME "uxbasic-hybrid-arena"
%%BUNDLE_VERSION "1.0.0"
%%MANIFEST_SET "bridge", "http://127.0.0.1:8765"
%%MANIFEST_REQUIRE "bridge"

%%HTML_BEGIN "index.html" BODY
<!doctype html><html><body><canvas id="game" width="640" height="360"></canvas><script type="module" src="game.js"></script></body></html>
%%HTML_END

%%JS_BEGIN "game.js" RUNTIME
console.log("Bu kısa bundle örneğidir; tam oyun examples/04_hybrid_browser_game/web/game.js içindedir.");
%%JS_END

%%WAT_BEGIN "game_math.wat"
(module (func (export "add") (param i32 i32) (result i32) local.get 0 local.get 1 i32.add))
%%WAT_END

MAIN
    PRINT "HYBRID_GAME_ARTIFACTS_READY"
END MAIN

```

Bu kısa bundle, tam oyunun nasıl paketlenebileceğini gösterir. Büyük projede raw HTML/JS/WAT dosyalarını ayrı tutmak bakım açısından daha kolaydır; preprocessor ise manifest, hedef, asset ve küçük host bağlama kodlarını üretmek için kullanılır.

## 32.1 Ne zaman tek dosya?

- eğitim demosu;
- küçük test fixture;
- tek dosyalık reproducer;
- build sisteminin artefact üretimini sınama.

## 32.2 Ne zaman ayrı dosya?

- yüzlerce satır JS;
- birden fazla WASM modülü;
- asset ve localization;
- ekip çalışması;
- browser testleri ve lint.

## 32.3 Akıllı hibrit yaklaşım

uXBasic preprocessor:

- dosya yollarını ve manifesti üretir;
- build profilini seçer;
- güvenlik kapılarını doğrular;
- küçük host binding kodunu gömer.

Ayrı JS/WAT dosyaları:

- lint ve IDE desteği alır;
- bağımsız test edilir;
- browser cache ve source map kullanır.


# Bölüm 33 — Kendi Oyun Ekranında Güvenli Gözlem ve QA

Kullanıcı "ekrandaki nesne gerçekten çizildi mi?" sorusunu yalnız oyun içi state ile değil, ekran görüntüsüyle de sınamak isteyebilir. `own_game_screen_probe.py` şu işlemleri yapar:

1. Kullanıcının verdiği dikdörtgeni yakalar.
2. Yeşil oyuncu ve kırmızı düşman için renk maskesi oluşturur.
3. En büyük konturun merkezini bulur.
4. JSON satırı olarak raporlar.

Bu araç **müdahale etmez**, yalnız gözler ve ölçer.

```powershell
python .\own_game_screen_probe.py --bbox 100,100,900,700 --count 100
```

## 33.1 QA senaryoları

- Oyuncu ok tuşuna basınca merkez koordinatı değişiyor mu?
- Düşman native action geldiğinde oyuncuya yaklaşıyor mu?
- Coin toplandığında yeni konumda sarı nesne çiziliyor mu?
- Browser ölçeklendiğinde tespit toleransı korunuyor mu?
- FPS düştüğünde state ile ekran arasında gecikme büyüyor mu?

## 33.2 Neden doğrudan ekran otomasyonu değil?

Ekrana gizli tuş göndermek veya başka oyun üzerinde avantaj oluşturmak güvenli eğitim sınırını aşar. Doğru profesyonel yaklaşım, kendi oyununun test API’sini ve açık QA modunu oluşturmaktır. Gerekirse test modunda browser’ın kendi `KeyboardEvent` veya Playwright otomasyonu kullanılabilir; bu mod üretim oyunundan ayrı tutulur.


# Bölüm 34 — İleri Hata Ayıklama: REST, WASM, FFI ve Kütüphane

## 34.1 Zaman damgası ve stale state

Her state ve action’a `tick` veya `updated_at` eklenmelidir. Browser `tick=100` durumundayken `tick=80` için üretilmiş action’ı uygulamamalıdır.

## 34.2 FFI çağrısı gerçek mi?

Kontrol listesi:

- allowlist var;
- resolver kaydı var;
- DLL x64;
- export mevcut;
- argüman tip listesi doğru;
- return tipi doğru;
- invocation log’da çağrı var;
- beklenen yan etki veya sonuç var;
- eksik DLL negatif testi 0 dışı kodla kapanıyor.

`REPORT_ONLY`, yalnız rapor modudur; runtime başarı kanıtı değildir.

## 34.3 Handle sızıntısı

Her `Create/Open/Load/Query/Clone/Run` için eşleşen `Free/Close/Destroy` aranır. Hata yolunda da Free çalışmalıdır. Gerekirse:

```uxbasic
TRY
    handle = Create()
    ' islemler
FINALLY
    IF handle <> 0 THEN Free(handle)
END TRY
```

## 34.4 WASM import/export uyuşmazlığı

- JS export adını yanlış yazmış olabilir.
- WAT function signature farklı olabilir.
- `.wasm` yerine `.wat` servis edilmiş olabilir.
- MIME `application/wasm` değildir.
- raw WAT güvenlik kapısı kapalıdır.

## 34.5 x64 ve JS sayısal farkları

`U64/I64`, JavaScript `Number` sınırını aşabilir. JS tarafında BigInt sözleşmesi gerekir. F32 işlemleri `Math.fround` ile sınanmalıdır. NaN, Infinity ve signed zero için çapraz hedef testleri yazılmalıdır.


# Bölüm 35 — Performans, Ölçüm ve Zekâ

## 35.1 Önce ölç

Bir işlemi INLINE, DLL veya WASM’e taşımadan önce üç süre ölçülür:

- çağrı sabit maliyeti;
- veri kopyalama maliyeti;
- gerçek hesaplama maliyeti.

Küçük iki sayıyı toplamak için REST kullanmak anlamsızdır. Büyük tensor inference, fizik veya binlerce ajan kararı için native/WASM anlamlı olabilir.

## 35.2 Batch ve backpressure

Browser her frame state gönderirse bridge kuyruğu büyüyebilir. Çözüm:

- en son state’i tut, eski state’leri at;
- action için son karar modeli;
- sabit polling aralığı;
- queue uzunluğu metriği;
- timeout ve circuit breaker.

## 35.3 Akıl katmanlarını ayır

Örnek oyunda:

- refleks: WASM clamp/mesafe;
- taktik: x64 heuristik veya ONNX model;
- orkestrasyon: JS;
- veri taşıma: Flask;
- kalıcı analiz: DataFrame/Stats.

Bu ayrım, bir bileşeni değiştirdiğinde bütün sistemi yeniden yazmamanı sağlar.


# Bölüm 36 — Uygulamalı Test ve Dağıtım Kapıları

## 36.1 Statik yardımcı testler

Örnek paketindeki `run_static_checks.py`:

- Python dosyalarını `ast.parse` ile denetler;
- JavaScript dosyalarını `node --check` ile denetler.

Bu test uXBasic derlemesinin yerine geçmez; yalnız yan dosyalardaki erken syntax hatalarını bulur.

## 36.2 uXBasic kaynak matrisi

Her `.uxb` örneği en az şu kapılardan geçmelidir:

```powershell
.\bin\uxb.exe par source.uxb --json-out reports\parser.json
.\bin\uxb.exe sem source.uxb --json-out reports\semantic.json
.\bin\uxb.exe int source.uxb --x64-mode=AST
.\bin\uxb.exe int source.uxb --x64-mode=MIR
.\bin\uxb.exe bld source.uxb --build-x64-out build\case
```

Native DLL kullanan kütüphane örneklerinde AST/MIR parse başarısı yeterli değildir; x64 EXE ve gerçek DLL sonucu ölçülür.

## 36.3 Hybrid oyun kapısı

- Flask `/health` 200;
- WAT → WASM dönüşümü;
- browser console temiz;
- WASM export fonksiyonları çağrılıyor;
- browser state endpoint’i güncelleniyor;
- native EXE action gönderiyor;
- action browser’da uygulanıyor;
- bridge kapatıldığında oyun kontrollü fallback gösteriyor;
- native EXE kapatıldığında browser donmuyor.

## 36.4 Release klasörü

```text
release/
  web/
    index.html
    game.js
    style.css
    game_math.wasm
  bridge/
    flask_game_bridge.py
  native/
    native_enemy_ai.exe
    gerekli DLL dosyalari
  config/
    ffi_allowlist.csv
    manifest.json
  docs/
    README.md
```


# Ek H — Kütüphane Kullanımında 40 Profesyonel Kural

1. Sürüm çağrısını ilk smoke test yap.
2. Backend adını logla.
3. Sıfır handle’ı kullanma.
4. Handle’ı başka kütüphaneye verme.
5. Her oluşturma için kapanış yordamı bul.
6. Ara sonuç handle’larını da kapat.
7. Pointer ile handle’ı karıştırma.
8. Veri pointerı alındıktan sonra buffer’ı resize etme.
9. İndeks sınırını çağrıdan önce assert et.
10. Shape’i hesaplamadan matmul yapma.
11. String tampon kapasitesini açık tut.
12. UTF-8 sonlandırıcıyı test et.
13. LastError’ı başarısız çağrıdan hemen sonra oku.
14. Başka çağrı LastError’ı ezebilir.
15. Model input/output adını varsayma.
16. Provider fallback’ini logla.
17. Scaler’ı test verisi üzerinde fit etme.
18. Seed’i rapora yaz.
19. Batch sırasını deterministik test et.
20. NaN ve Infinity kapısı ekle.
21. Gradient normunu gözle.
22. SQL metnine güvenilmeyen girdiyi ekleme.
23. CSV kolon tiplerini doğrula.
24. Parquet bağımlılıklarını release paketine koy.
25. DLL bitliğini doğrula.
26. Export listesini denetle.
27. ABI10 argüman sayısını ve tiplerini doğrula.
28. REPORT_ONLY sonucunu runtime PASS sayma.
29. JS/WASM native-only reddini test et.
30. Hata yolunda FINALLY ile Free yap.
31. Uzun çalışan sistemde handle sayacı tut.
32. Kütüphane sürümünü model/veri sürümüyle kaydet.
33. Performans karşılaştırmasını aynı veriyle yap.
34. Warm-up çağrılarını ölçümden ayır.
35. F64/F32 hassasiyet farkını belgele.
36. U64’ü JS Number’a körlemesine çevirme.
37. Thread-safe olduğu kanıtlanmayan handle’ı paylaşma.
38. Callback yaşam süresini açık tut.
39. Kullanılmayan DLL’yi release’e koyma.
40. Her kütüphane için pozitif ve eksik-DLL negatif testi tut.

# Ek I — Örnek Paket Dosya Haritası

```text
01_language_labs/      Tip, operatör, OOP, hata, preprocessor, INLINE
02_libraries/          Koleksiyon, stats, dataframe, dataset, graph, tensor
03_rest/               Flask, stdlib sunucu, cURL uXBasic istemcisi
04_hybrid_browser_game Browser + JS + WAT/WASM + x64 EXE + Flask
05_screen_qa/          Yalnız kendi oyunun için ekran gözlem testi
06_test_runners/       Python/JS statik kapı
```

# Genişletilmiş Baskının Son Sözü

uXBasic’in gücü yalnız çok sayıda komut barındırmasında değildir. Asıl güç, aynı problemde BASIC okunabilirliğini; native x64, DLL, C/C++ INLINE, REST, browser, JavaScript, WAT/WASM, veri bilimi ve yapay zekâ katmanlarıyla kontrollü biçimde birleştirebilmesidir.

Profesyonel kullanıcı her özelliği aynı projeye doldurmaz. Problemi katmanlara böler, her katmanın sözleşmesini yazar, pozitif ve negatif testini kurar, sonra gerçek artefact ve çalışma sonucu üzerinden karar verir.

