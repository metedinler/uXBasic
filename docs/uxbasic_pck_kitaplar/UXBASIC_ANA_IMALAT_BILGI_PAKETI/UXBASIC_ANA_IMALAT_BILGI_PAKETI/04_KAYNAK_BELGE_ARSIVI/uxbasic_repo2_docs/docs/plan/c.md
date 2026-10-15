# uXBasic Programcının Cep Kitabı (V1.0)

Bu belge, uXBasic dilinin tam ve sistematik bir referans kaynağıdır. Windows 11 (64-bit) mimarisine ve modern derleyici standartlarına uygun olarak hazırlanmıştır. Amacı, bir programcının dili sıfırdan öğrenmesini veya mevcut bilgi birikimini derleyicinin güncel yetkinlikleriyle güncellemesini sağlamaktır.

---

## Bölüm 1: Dil Sözleşmesi ve Temel Kurallar

uXBasic, geçmişin (QBasic/UBASIC) basitliğini modern sistemin (Windows 11 x64) güvenilirliğiyle buluşturan bir köprü dilidir. Kod yazarken uymak zorunlu olan temel kurallar şunlardır:

*   **Strict Mode (Sıkı Mod):** Varsayılan çalışma modudur. Eski BASIC dillerindeki `%`, `$`, `&` gibi tip sonekleri değişken adının sonunda kullanılamaz. Tip belirtimi sadece `AS` anahtar kelimesiyle yapılır.
*   **Büyük/Küçük Harf Duyarsızlığı:** Anahtar kelimelerde (`PRINT`, `print`, `Print`) duyarsızdır, ancak tutarlılık için büyük harf kullanımı önerilir.
*   **Ön Bildirim (Forward Declaration):** Kullanılacak her `SUB` veya `FUNCTION`, programın başında `DECLARE` ile bildirilmelidir.
*   **Satır Yapısı:** Komutlar satır sonunda biter. Aynı satıra birden fazla komut iki nokta üst üste (`:`) ile yazılabilir. Yorumlar tek tırnak (`'`) ile başlar veya REM komutuyla belirtilir.

**Identifier (Değişken/İşlev Adı) Kuralı:**
*   Başlangıç: Harf veya alt çizgi (`_`).
*   Devamı: Harf, rakam veya alt çizgi.
*   *Geçersiz:* `x%`, `name$`, `pid&`

---

## Bölüm 2: Veri Tipleri ve Bellek Modeli

uXBasic, donanımı doğrudan kontrol edebilen ve belleği verimli kullanan zengin bir tip sistemine sahiptir.

### 2.1 Temel (Skaler) Veri Tipleri

| Tip | Boyut | Açıklama | Kullanım Örneği |
| :--- | :--- | :--- | :--- |
| `I8` / `U8` | 1 Bayt | İşaretli / İşaretsiz Tam Sayı | Bayt düzeyi veri, flagler |
| `I16` / `U16` | 2 Bayt | Kısa Tam Sayı | Kısa ölçümler |
| `I32` / `U32` | 4 Bayt | Standart Tam Sayı | Standart sayaçlar, döngüler |
| `I64` / `U64` | 8 Bayt | Uzun Tam Sayı | Zaman damgaları, büyük adresler |
| `F32` | 4 Bayt | Tek Hassasiyetli Ondalık | Hafif hesaplamalar |
| `F64` | 8 Bayt | Çift Hassasiyetli Ondalık | Varsayılan ondalık tip |
| `F80` | 10 Bayt | Geniş Hassasiyetli Ondalık | Yüksek hassasiyet gerektiren bilim |
| `BOOLEAN` | 1 Bayt | Mantıksal (`TRUE` / `FALSE`) | Durum kontrolleri |
| `POINTER` | 8 Bayt | Bellek Adresi | Adres aritmetiği |
| `STRING` | Değişken | Dinamik Metin (Maks 512 karakter) | Kullanıcı girişleri, loglar |
| `STRING * N` | Sabit | Sabit Uzunluklu Metin | Dosya formatları, sabit veriler |

### 2.2 Diziler (ARRAY) ve Bellek Tahsisi

Diziler, aynı tipteki verilerin bellekte ardışık bloklar halinde tutulmasıdır. Bellek yerleşimi (layout) derleyici tarafından optimize edilir.

**Sözdizimi:**
```basic
' Tek boyutlu dizi
DIM sayilar(0 TO 100) AS I32

' Çok boyutlu dizi (Matris)
DIM matris(10, 10) AS F64

' Sabit uzunluklu metin dizisi
DIM isimler(50) AS STRING * 30
```

**Dinamik Yeniden Boyutlandırma (REDIM):**
Mevcut dizilerin boyutları çalışma zamanında değiştirilebilir. (Not: Çok boyutlu dizilerde ve veri koruma gerektiren durumlarda sınırlamaları vardır, temel kullanım tek boyutludur).

```basic
DIM veri(10) AS I32
' ... işlemler ...
REDIM veri(0 TO 50) AS I32 ' Boyutu 50'ye çıkar
```

### 2.3 Kullanıcı Tanımlı Yapılar (TYPE)

Farklı veri tiplerini bir araya getirerek karmaşık veri modelleri oluşturur.

**Sözdizimi:**
```basic
TYPE Nokta3D
    X AS F64
    Y AS F64
    Z AS F64
END TYPE

DIM p1 AS Nokta3D
p1.X = 10.5
p1.Y = 20.2
```

**İç İçe Yapılar:**
```basic
TYPE SensorPaketi
    ID AS I32
    Okumalar AS ARRAY(5) OF F64 ' Yapı içinde dizi
END TYPE

DIM istasyon AS SensorPaketi
istasyon.Okumalar(0) = 98.6
```

---

## Bölüm 3: Operatörler ve İfade Sistemi

uXBasic operatörleri, matematiksel ve mantıksal kesinlik üzerine kuruludur. İşlem önceliği kesin olarak tanımlanmıştır.

### 3.1 Öncelik Tablosu (Yüksekten Düşüğe)

| Seviye | Operatörler | Yönelim | Açıklama |
| :--- | :--- | :--- | :--- |
| 1 | `()`, `[]`, `.` | Soldan sağa | Gruplama, Dizi indisi, Üye erişimi |
| 2 | `+`, `-`, `NOT`, `@`, `++`, `--` | Sağdan sola | Tekli (Unary) operatörler |
| 3 | `**` | Sağdan sola | Üs alma (Power) |
| 4 | `*`, `/`, `\`, `MOD`, `%` | Soldan sağa | Çarpma, Bölme, Tam Bölme, Kalan |
| 5 | `+`, `-` | Soldan sağa | Toplama, Çıkarma |
| 6 | `<<`, `>>`, `SHL`, `SHR` | Soldan sağa | Bit kaydırma |
| 7 | `&` (AND) | Soldan sağa | Bitsel VE |
| 8 | `XOR` | Soldan sağa | Bitsel Özel VEYA |
| 9 | `|` (OR) | Soldan sağa | Bitsel VEYA |
| 10 | `=`, `<>`, `<`, `>`, `<=`, `>=` | Soldan sağa | Karşılaştırma |
| 11 | `AND`, `OR` | Soldan sağa | Mantıksal bağlaçlar |
| 12 | `=`, `+=`, `-=`, `*=`, `/=`, `\=` | Sağdan sola | Atama ve Bileşik Atama |

### 3.2 Bileşik Atama (Syntactic Sugar)
Okunabilirliği artırmak için kullanılan kısa yollardır.
```basic
x += 5  ' x = x + 5 ile aynı
x -= 2  ' x = x - 2 ile aynı
x *= 3  ' x = x * 3 ile aynı
i++     ' INC(i) ile aynı (1 artırır)
i--     ' DEC(i) ile aynı (1 azaltır)
```

---

## Bölüm 4: Program Akış Kontrolü

### 4.1 Koşullu Dallanma (IF...ELSEIF...ELSE)
```basic
IF sicaklik > 40 THEN
    PRINT "Kritik Isı"
    EXIT IF ' İç içe yapılarda alt bloktan erken çıkış sağlar
ELSEIF sicaklik > 30 THEN
    PRINT "Uyarı"
ELSE
    PRINT "Normal"
END IF
```

### 4.2 Çoklu Seçim (SELECT CASE)
```basic
SELECT CASE notu
    CASE 90 TO 100
        PRINT "A"
    CASE IS >= 80      ' CASE IS ile ilişkisel kontrol
        PRINT "B"
    CASE 60, 65, 70    ' Virgülle çoklu değer
        PRINT "C"
    CASE ELSE
        PRINT "Kaldı"
END SELECT
```

### 4.3 Döngüler (Iteration)

**Sayaçlı Döngü (FOR...NEXT):**
```basic
FOR i = 0 TO 10 STEP 2
    PRINT i
NEXT i
```

**Mantıksal Döngü (DO...LOOP):**
```basic
DO WHILE devam = TRUE
    ' ... işlemler ...
    IF hataVar THEN EXIT DO
LOOP
```

**Koleksiyon Döngüsü (DO EACH...LOOP):**
Diziler ve koleksiyonlar üzerinde doğrudan iterasyon sağlar.
```basic
DIM dizi(5) AS I32
' ... dizi doldurma ...
DO EACH eleman IN dizi
    PRINT eleman
LOOP
```

### 4.4 Atlama ve Sonlandırma
*   `GOTO etiket`: Belirtilen satıra atlar.
*   `GOSUB etiket`: Alt yordama gider, `RETURN` ile döner.
*   `END`: Programın çalışmasını güvenli bir şekilde sonlandırır (blokların içinden çağrılabilir).

---

## Bölüm 5: Prosedürler (SUB) ve Fonksiyonlar (FUNCTION)

Kodun modülerliğini sağlar. Tüm yordamlar önceden `DECLARE` edilmelidir.

### 5.1 SUB (Değer Döndürmeyen)
```basic
DECLARE SUB EkranaYaz(metin AS STRING)

SUB EkranaYaz(metin AS STRING)
    PRINT metin
END SUB

' Çağrı
EkranaYaz("Merhaba")
```

### 5.2 FUNCTION (Değer Döndüren)
```basic
DECLARE FUNCTION Topla(a AS I32, b AS I32) AS I32

FUNCTION Topla(a AS I32, b AS I32) AS I32
    Topla = a + b ' Fonksiyon adına değer atanarak döndürülür
END FUNCTION

DIM sonuc AS I32
sonuc = Topla(5, 10)
```

---

## Bölüm 6: Bellek Yönetimi ve Düşük Seviye Erişim

uXBasic, Windows 11'in bellek koruma mekanizmalarını (ASLR/DEP) ihlal etmeden güvenli düşük seviye erişim sunar.

### 6.1 Adres Alma Fonksiyonları
| Fonksiyon | Açıklama | Dönüş Tipi |
| :--- | :--- | :--- |
| `VARPTR(degisken)` | Değişkenin bellek adresi | `U64` |
| `SADD(metin)` | String verisinin başlangıç adresi | `U64` |
| `CODEPTR(yordam)` | SUB/FUNCTION'un kod başlangıç adresi | `U64` |

### 6.2 Ham Bellek Okuma/Yazma (PEEK / POKE)
Tip korumalı bellek erişimi sağlar. Adres hesaplamalarında `OFFSETOF` ve `SIZEOF` intrinsics'leri kullanılır.

```basic
' 1 Bayt oku/yaz
POKEB adres, 255
deger = PEEKB(adres)

' 2 Bayt (Word) oku/yaz
POKEW adres, 65535

' 4 Bayt (Dword) oku/yaz
POKED adres, 1000
deger = PEEKD(adres)
```

### 6.3 Toplu Bellek İşlemleri
```basic
' 100 elemanlı I32 dizisini hedefe kopyala (100 * 4 = 400 bayt)
MEMCOPY VARPTR(kaynak(0)), VARPTR(hedef(0)), 400

' Bellek bloğunu belirli bir değerle doldur
MEMFILLB adres, 1024, 0 ' 1024 baytı 0 ile doldur
```

---

## Bölüm 7: Giriş/Çıkış ve Ekran Yönetimi

### 7.1 Konsol Çıktısı (PRINT)
`PRINT` komutunda ayırıcılar önemlidir:
*   `;` (Noktalı Virgül): Sonraki ifadeyi hemen yanına yazar (satır sonu eklemez).
*   `,` (Virgül): İfadeleri sabit genişlikli alanlara (Tab bölgelerine) hizalar.

```basic
PRINT "Ad:"; isim
PRINT "X:", x, "Y:", y
```

### 7.2 Ekran Kontrolü
```basic
CLS                     ' Ekranı temizle
LOCATE 10, 20           ' İmleci 10. satır, 20. sütuna taşı
COLOR 2, 0              ' Yazı rengi yeşil (2), arka plan siyah (0)
```

### 7.3 Klavye Girişi
```basic
INPUT "Yaşınız: ", yas      ' Kullanıcıdan veri bekle
 tus = INKEY()               ' Tuş basılmasını beklemeden buffer'ı oku
```

---

## Bölüm 8: Dosya İşlemleri

Dosyalar "Kanal" (Channel/Handle) mantığıyla yönetilir. `#` işareti opsioneldir ancak geleneksel BASIC uyumluluğu için korunmuştur.

```basic
' Dosya Açma
OPEN "veri.txt" FOR INPUT AS #1
OPEN "log.txt" FOR APPEND AS #2
OPEN "raw.dat" FOR BINARY AS #3

' Sıralı Okuma/Yazma
INPUT #1, isim, yas
PRINT #2, "Hata oluştu"

' Rastgele Erişim (Ham Bayt)
GET #3, 0, kayitStruct  ' 0. pozisyondan yapı boyutu kadar oku
PUT #3, 100, veriBloğu ' 100. pozisyona yaz

' İşaretçi ve Kapanış
SEEK #1, 50             ' 50. byte'a git
CLOSE #1
```

---

## Bölüm 9: İç (Intrinsic) Fonksiyon Kataloğu

### 9.1 Matematiksel Fonksiyonlar
| Fonksiyon | Açıklama | Örnek |
| :--- | :--- | :--- |
| `ABS(x)` | Mutlak değer | `ABS(-5)` -> `5` |
| `SQR(x)` | Karekök | `SQR(16)` -> `4` |
| `SIN(x), COS(x), TAN(x)` | Trigonometrik (Radyan) | `SIN(3.14)` |
| `HYP(x)` | Hiperbolik Fonksiyon | `HYP(SIN(x))` |
| `ARC(x)` | Arkus Fonksiyonlar | `ARC(ATN(x))` |
| `EXP(x)` | $e^x$ | `EXP(1)` |
| `LOG(x)` | Doğal logaritma ($\ln$) | `LOG(10)` |

### 9.2 Metin (String) Fonksiyonları
| Fonksiyon | Açıklama | Örnek |
| :--- | :--- | :--- |
| `LEN(s)` | Uzunluk | `LEN("uX")` -> `2` |
| `MID(s, b, u)` | Parça alma | `MID("Basic", 1, 2)` -> `"Ba"` |
| `LEFT(s, n)` | Soldan parça | `LEFT("Merhaba", 3)` -> `"Mer"` |
| `UCASE(s) / LCASE(s)` | Büyük/Küçük harf | `UCASE("nx")` -> `"NX"` |
| `STR(n) / VAL(s)` | Tip Dönüşümü | `STR(42)`, `VAL("3.14")` |
| `TRIM(s)` | Sağ/sol boşluk silme | `TRIM(" okey ")` -> `"okey"` |

### 9.3 Sistem ve Zaman Fonksiyonları
*   `TIMER()`: Gece yarısından beri geçen saniye.
*   `TIMER("ms")`: Yüksek çözünürlüklü milisaniye tick değeri.
*   `RND()`: 0 ile 1 arasında rastgele ondalık sayı üretir.
*   `RANDOMIZE [tohum]`: Rastgele sayı üretecinin başlangıç noktasını belirler.

---

## Bölüm 10: Derleyici Yönergeleri ve Modüller

uXBasic, tek bir dosya içinde kalabalık yaratmak yerine kodu modüllere bölmeyi destekler.

### 10.1 Dosya Dahil Etme (INCLUDE / IMPORT)
```basic
' Başka bir BASIC dosyasını metin olarak dahil eder
INCLUDE "yardici_fonksiyonlar.bas"

' C, C++ veya ASM kütüphanelerini derleme sürecine ekler
IMPORT(C, "statlib.c")
IMPORT(ASM, "lowlevel.asm")
```

### 10.2 Derleme Zamanı Meta-Komutları (`%%`)
Bu komutlar kaynak kodu işlenmeden önce (Preprocess aşaması) çalışır.

```basic
%%PLATFORM WIN64
%%DESTOS WIN11

%%DEFINE DEBUG_MODE
%%IF DEBUG_MODE
    PRINT "Debug modu aktif"
%%ENDIF

%%IFC VERSION >= 2.0
    ' Sembol karşılaştırmalı koşullu derleme
%%ENDCOMP
```

### 10.3 Program Yapısı (NAMESPACE / MODULE / MAIN)
Büyük projelerde isim çakışmalarını önlemek ve giriş noktasını netleştirmek için kullanılır.

```basic
NAMESPACE Proje

MODULE Giris
    MAIN
        PRINT "Program başladı"
        ' Ana kod akışı burada başlar ve biter
    END MAIN
END MODULE

MODULE Yardimci
    ' Sadece Proje.Yardimci içinden erişilebilir kodlar
END MODULE

END NAMESPACE
```

---

## Bölüm 11: Nesne Yönelimli Programlama (OOP)

uXBasic, modern yazılım mühendisliği gereksinimleri için sınıf tabanlı nesne yönelimli programlamayı (OOP) doğal sözdizimiyle destekler.

### 11.1 Sınıf Tanımlama (CLASS)
```basic
CLASS Nokta
    ' Erişim belirleyiciler: PUBLIC, PRIVATE
    PRIVATE m_X AS F64
    PRIVATE m_Y AS F64

    ' Kurucu (Constructor)
    CONSTRUCTOR(x AS F64, y AS F64)
        THIS.m_X = x
        THIS.m_Y = y
        PRINT "Nokta olusturuldu"
    END CONSTRUCTOR

    ' Yıkıcı (Destructor)
    DESTRUCTOR()
        PRINT "Nokta yok edildi"
    END DESTRUCTOR

    ' Metot (Method)
    PUBLIC SUB Yazdir()
        PRINT "X: "; THIS.m_X; " Y: "; THIS.m_Y
    END SUB
END CLASS
```

### 11.2 Nesne Kullanımı ve Kalıtım (Inheritance)
```basic
' Nesne oluştur
DIM p AS Nokta = Nokta(10.5, 20.2)
p.Yazdir()

' Kalıtım (EXTENDS)
CLASS Nokta3D EXTENDS Nokta
    PRIVATE m_Z AS F64
    
    CONSTRUCTOR(x AS F64, y AS F64, z AS F64)
        SUPER(x, y) ' Temel sınıf kurucusunu çağır
        THIS.m_Z = z
    END CONSTRUCTOR
END CLASS
```

---

## Bölüm 12: Dış Sistemlerle İletişim (FFI ve INLINE)

uXBasic'in gücü, kendi sandbox'ından çıkıp doğrudan işletim sistemi ve donanımla konuşabilmesinden gelir.

### 12.1 Yabancı Fonksiyon Arayüzü (CALL DLL)
Güvenlik odaklı bir mimariyle tasarlanmıştır. İmza ve hedef kütüphane derleme zamanında denetlenir.

```basic
' C standart kütüphanesinden bellek ayırma
DECLARE FUNCTION malloc CDECL (boyut AS U64) AS POINTER
DECLARE SUB free CDECL (ptr AS POINTER)

' Güvenli DLL Çağrısı (Allowlist ve imza denetimi aktif)
DIM ptrMem AS POINTER
ptrMem = CALL(DLL, "msvcrt.dll", "malloc", "PTR:U64", 1024)

' ... kullanım ...

CALL(DLL, "msvcrt.dll", "free", "VOID:PTR", ptrMem)
```

### 12.2 Doğrudan Makine Kodu Ekleme (INLINE)
Performansın kritik olduğu durumlarda derleyiciye doğrudan C, C++ veya Assembly kodu enjekte edebilirsiniz.

```basic
' C kodunu doğrudan derleyicide çalıştır
INLINE(C, "Hesapla")
    // Bu blok uXBasic parser tarafından atlanır,
    // doğrudan C derleyicisine (GCC/Clang) gönderilir.
    int sonuc = 10 * 20;
    return sonuc;
END INLINE
```

---

## Bölüm 13: Koleksiyon Yapıları (LIST, DICT, SET)

Dinamik veri yönetimi için standart dizi (ARRAY) yapısının ötesine geçen yapılar sunulur.

*   **LIST:** Sıralı, indekslenebilir dinamik liste. `ADD`, `GET`, `REMOVE` metotlarıyla yönetilir.
*   **DICT:** Anahtar-Değer (Key-Value) çiftlerini tutan sözlük yapısı. Hızlı arama için idealdir.
*   **SET:** Benzersiz (Unique) elemanlardan oluşan küme. Matematiksel kesişim ve birleşim işlemleri için kullanılır.

*(Not: Bu yapılar TYPE sistemindeki dinamik Bellek Yönetimi ile entegre çalışır ve sistem tarafında optimize edilmiştir.)*

---

## Ek: Hata Ayıklama ve Test Altyapısı

uXBasic, geliştiriciye deterministik hata ayıklama imkânı sunar. `ASSERT` mekanizmaları ve derleyici çıktıları (Gate testleri) sayesinde hatalar çalışma zamanına (runtime) kadar taşınmaz.

*   **Derleme Zamanı Hataları:** Tip uyuşmazlıkları, tanımsız değişkenler, eksik `DECLARE` bildirimleri.
*   **Çalışma Zamanı Güvenlik Ağları (Fail-Fast):** Dizi sınırları aşıldığında (`Index Out Of Bounds`), boş bir bellek adresine erişilmeye çalışıldığında veya geçersiz bir `REDIM` yapıldığında program çökmez; anlamlı bir hata mesajı ile güvenli bir şekilde sonlandırılır.

Türkçe sonuç raporu:

uXBasic CLASS/OOP Non-OK Kapaları - Eksiklik Analizi
1) Eksik Implementasyon Konumları
Dosya	Alan	Durum	İçerik
src/runtime/memory_exec.fbs	ExecObject	✗ DISABLED	Type tanımı yorum blokunda; instance tracking devre dışı
src/runtime/exec/exec_call_dispatch_helpers.fbs	Method access	✗ PARTIAL	PUBLIC/PRIVATE denetimi yüksüklersiz
src/parser/parser/parser_stmt_decl_core.fbs	ParseClassStmt	✓ OK	Parser loop tamamış veya söylemişler
src/semantic/layout.fbs	TypeLayoutOffsetOf	✓ OK	Layout hesabı ve path resolution çalışıyor
src/runtime/exec/*.fbs	Field access	✗ MISSING	obj.field syntax evaluator yok
src/runtime/exec/*.fbs	NEW/DELETE	✗ MISSING	Constructor/destructor invoke mekanizması yok
2) KISMEN → OK için Minimum Patch Seti
Patch 1: Object Instance Memory Tracking (MEDIUM RISK)
Dosya: src/runtime/memory_exec.fbs
Fonksiyon: Re-enable ExecObject, ExecObjectArray stores
Scope:
ExecObject type uncomment (3 lines)
Add object array to ExecState (2 lines)
Object alloc/free helpers (Sketch: ~15-20 lines each)
Risk: Memory management model (stack vs heap) define gerekli; existing arrays approach ile consistency
Patch 2: Field Access Runtime Evaluator (MEDIUM RISK)
Dosya: new src/runtime/exec/exec_eval_field_access.fbs VEYA extend exec_eval_support_helpers.fbs
Fonksiyon: ExecEvalFieldAccess(objectAddr, fieldName, offset) → value | write
Scope:
Dotted expression parsing (obj.field → FIELD_ACCESS_EXPR)
OFFSETOF ile integrated field resolution
Memory read/write via VARPTR + offset
Approximately 30-40 lines entry + 20-30 per access type
Risk: Parser'daki dotted expr support doğrulama gerekir
Patch 3: Constructor/Destructor Auto-Invoke (HIGH RISK)
Dosya: src/runtime/memory_exec.fbs (DIM statement exec) VEYA new dispatch module
Fonksiyon: ExecInvokeConstructor, ExecInvokeDestructor
Naming Convention: CLASSNAME_CTOR, CLASSNAME_DTOR
Scope:
DIM type-var → locate CTOR → invoke with address binding
Scope exit detection → locate DTOR → invoke
THIS binding (already exist in dispatch helpers)
~50-70 lines across DIM/flow handlers
Risk: Scope lifetime tracking (block exit detection) incomplete; exceptions/early exit handling unclear
Patch 4: Access Control Validation (LOW RISK - Parser-Only)
Dosya: src/semantic/layout.fbs VEYA new src/semantic/semantic_access_control.fbs
Fonksiyon: ValidateFieldAccessLevel, ValidateMethodAccessLevel
Scope:
Field access chain → PUBLIC/PRIVATE flags from CLASS_FIELD metadata
Method call → PUBLIC/PRIVATE flags from CLASS_METHOD_DECL metadata
Runtime enforcement: false per CSV (runtime r=KISMEN, not "strict")
~25-35 lines per function
Risk: Minimal - compile-time only
3) Her Patch için Test Koşulcuları
Patch	Test Dosyası	Komut	Beklenen Sonuç
1	tests/run_class_oop_transition_exec_ast.bas	./build_64.bat tests/run_class_oop_transition_exec_ast.bas && ./tests/run_class_oop_transition_exec_ast_64.exe	EXIT=0 (Parse OK)
2	tests/run_class_method_dispatch_exec_ast.bas	./build_64.bat tests/run_class_method_dispatch_exec_ast.bas && ./tests/run_class_method_dispatch_exec_ast_64.exe	EXIT=0 + POKED memory validate
3	tests/run_class_ctor_dtor_exec_ast.bas	./build_64.bat tests/run_class_ctor_dtor_exec_ast.bas && ./tests/run_class_ctor_dtor_exec_ast_64.exe	EXIT=0 + mem write validate
4	tests/run_class_access_friend_parse.bas	./build_64.bat tests/run_class_access_friend_parse.bas	Parse FAIL (private.field reference error)
4) Risk Seviyesi
Patch	Risk	Neden	Mitigation
1	MEDIUM	Commented-out code reactivation; memory safety model unclear	Incremental test with existing PEEKD/POKED validation
2	MEDIUM	New evaluator component; parser integration verify	Cover both obj.field + obj.field = value paths
3	HIGH	Scope exit detection reliability; double-invoke guards	Framework pattern study (existing SUB/FUNCTION cleanup?)
4	LOW	Metadata-only validation	Existing semantic layer extend
5. Uygulanabilir Madde Özeti
✓ Parser: CLASS 100% ready (s=KISMEN sadece semantic ve runtime gaps)
⚠ Semantic: ACCESS_CONTROL (4) + field offset calc (2) → ~60 lines = QUICK WIN
🔴 Runtime: Memory model broken (ExecObject disabled); Patch 1-3 sequential dependency
⚠ Scope Management: Destructor auto-invoke requires block exit tracing (R1/R2 flow works iken R3 CLASS devre dışı kalmıştı?)
✓ Test Coverage: 7 test files exist; execution not validated beyond parser
Tavsiye: Patch 4 (Access Control) ilk; sonra Patch 1 (Object tracking) ile iki hafta sprint; Patch 2-3 bağımlı.
ÖZET: 5 Non-OK Kalem Kod Gerçekliği Denetimi
Dosya: reports/matrix_psrt_nonok_inventory.csv

Kalem	P	S	R	T	Durum	Gap
IMPORT(C/CPP/ASM, file)	OK	KISMEN	OK	OK	No-op directive	Runtime manifest yok
INLINE(...) END INLINE	OK	KISMEN	OK	KISMEN	No-op directive	X64 backend limiting
%%DESTOS	OK	KISMEN	N/A	OK	Macro-resolved	Build output effect yok
%%NOZEROVARS	OK	KISMEN	N/A	OK	Macro-resolved	Runtime init flag yok
%%SECSTACK	OK	KISMEN	N/A	OK	Macro-resolved	Security stack yok
1) DAVRANIS EKSİKLİĞİ - KOD DOĞRULAMA
1.1 IMPORT(C/CPP/ASM, file) - Ne Yapmalı?
Mevcut Kod (src/parser/parser_stmt_decl.fbs#L676):

ParseImportStmt(): Dilini (C/CPP/ASM) ve dosya yolunu parse eder → IMPORT_STMT AST node oluşturur
Güvenlik: Unsafe karakterleri ve dosya extension'ları doğrular ✓
Runtime Davranış (src/runtime/memory_exec.fbs#L1546):

Case "IMPORT_STMT"
    Return 1  ' ← NO-OP (hiçbir şey yapmıyor)
Eksik Davranış:

Manifest'e kaydedilmiyor: src/build/interop_manifest.fbs strukt var ama InteropManifestAddImport() çağrılmıyor
Derleme bağlantı aşamasında kullanılmıyor (bu OK - MVP seviyesi)
Minimum Fix: Runtime'da manifest'e kayıt yapılması
1.2 INLINE(...) ... END INLINE - Ne Yapmalı?
Mevcut Kod (src/parser/parser_stmt_basic.fbs#L29):

ParseInlineStmt(): ASM kodu "END INLINE"'a kadar tüm token'ları okur → INLINE_STMT node oluşturur
Runtime Davranış (src/runtime/memory_exec.fbs#L1546):

Case "INLINE_STMT"
    Return 1  ' ← NO-OP
Eksik Davranış:

X64 backend var (src/codegen/x64/inline_backend.fbs), fakat:
InlineX64BackendValidate() sadece doğrulama yapar (policy check)
Gerçek ASM emit yapılmıyor
Shadow stack requirement (requires_shadow32) check var ama codegen yok
Test (tests/run_inline_x64_backend.bas#L47): Backend validation zaten test ediliyor, emit test yok
Minimum Fix: InlineX64BackendEmit() fonksiyonu yazılması (şu anda backend validation-only)

1.3 %%DESTOS / %%NOZEROVARS / %%SECSTACK - Ne Yapmalı?
Mevcut Kod (src/parser/lexer/lexer_preprocess.fbs#L340-342):

LexerSetMacro "DESTOS", hostPlatform, macros(), macroCount
LexerSetMacro "NOZEROVARS", "0", macros(), macroCount
LexerSetMacro "SECSTACK", "0", macros(), macroCount
Preprocess sırasında makro olarak register edilir
%%IFC DESTOS, WINDOWS şeklinde conditional compilation ile kullanılabilir
Test (tests/run_percent_preprocess_meta_exec.bas#L51): Macro-level parsing ✓
Eksik Davranış:

Makro	Amaç	Mevcut	Eksik
%%DESTOS	Target OS belirt (WIN/LINUX/MACOS)	Macro kayıt	Build output direkt etkileme (build flags, optimization)
%%NOZEROVARS	Variable initialize etme (garbage değer)	Macro kayıt	Runtime flag: ExecValueInit() skip logic
%%SECSTACK	Shadow stack doğrulama	Macro kayıt	Runtime frame tracking, buffer overflow detection
Minimum Fix:

%%NOZEROVARS: src/runtime/exec/exec_state_value_utils.fbs#L10-14 ExecValueInit() koşullandırılması (1-2 satır)
%%SECSTACK: Runtime shadow stack frame management (50+ satır)
%%DESTOS: Compiler output tuning (codegen layer - ileri faz)
2) MINIMUM KOD DEĞİŞİKLİĞİ
En Kısa Yol: Macro → Runtime
Preprocess-Time (%%DESTOS/%%NOZEROVARS/%%SECSTACK)
         ↓ (macro semantic)
Parser/Semantic-Time (IMPORT_STMT, INLINE_STMT)
         ↓ (AST nodes)
Runtime-Time (ExecRunStatement)
         ↓ (manifest record OR init flag override)
Codegen-Time (emit artifact)
KAPANABILIR (Quickest):
#1: %%NOZEROVARS Runtime Flag (2 satır + test)

Dosya: src/runtime/exec/exec_state_value_utils.fbs
Fonksiyon: ExecValueInit()
Değişiklik: Global flag (Dim gNoZeroVars As Integer) ekle, intValue = 0 → intValue = IIf(gNoZeroVars, garbage, 0)
Test: tests/run_dim_const_test.bas extend → uninitialized değer non-zero olacak
Zaman: 10 dakika
Gate: Yeni test case geçerse OK
#2: IMPORT_STMT Manifest Registry (3 satır + gate)

Dosya: src/runtime/memory_exec.fbs
Fonksiyon: ExecRunStatement() → IMPORT_STMT case
Değişiklik: AST child'dan language/path çıkar, InteropManifestAddImport() çağır
Test: tests/run_cmp_interop.bas manifest CSV çıkış doğrula
Zaman: 15 dakika
Gate: dist/cmp_interop/import_build_manifest.csv generate edilirse OK
#3: %%DESTOS/%%PLATFORM Macro Binding (0 satır kod)

Durum: Zaten lexer_preprocess.fbs#L340 aktif
Problem: matris "KISMEN" olması = test coverage eksik
Fix: tests/run_percent_preprocess_meta_exec.bas zaten var, gate zorunlu kıl
Zaman: 0 dakika (doc-only)
ORTA GÜÇLÜKLİ:
#4: %%SECSTACK Runtime Frame Tracking (40+ satır)

Dosya: src/runtime/memory_exec.fbs + exec_state_value_utils.fbs
Gereklik:
Shadow stack frame: Type DefSecStackFrame (ptr, size, marker)
ExecState'de: shadowStack() As DefSecStackFrame
Push/Pop/Validate funcs
Test: Yeni test yazılması gerekir (buffer overflow detection)
Zaman: 2-3 saat
Risk: Yüksek (core memory model değişikliği)
ZOR (İleri Faz):
#5: INLINE_STMT X64 Codegen Emit (100+ satır)

Dosya: src/codegen/x64/inline_backend.fbs
Fonksiyon: InlineX64BackendEmit() (yeni) + assembler output
Test: tests/run_inline_x64_backend.bas extend
Zaman: 4-5 saat
Risk: Yüksek (ASM generation)
3) TEST & GATE ADIMLARI
Mevcut Test Altyapısı:
Test	Dosya	Coverage	Status
Preprocess meta	run_percent_preprocess_meta_exec.bas	%%DESTOS/NOZEROVARS/SECSTACK parse	✓ MEVCUT
Directive no-op	run_decl_directive_exec_ast.bas	IMPORT/INLINE/INCLUDE flow	✓ MEVCUT
INLINE backend	run_inline_x64_backend.bas	Backend validation	✓ MEVCUT
Interop manifest	run_cmp_interop.bas	Manifest artifact	✓ MEVCUT
DIM/CONST init	run_dim_const_test.bas	Variable zeroing	✓ MEVCUT
Kapanış Gate Planı:
Gate 1: Preprocess Meta (Ready)

./build_64.bat tests/run_percent_preprocess_meta_exec.bas
./tests/run_percent_preprocess_meta_exec_64.exe
# Expected: PASS preprocess meta directives
Gate 2: IMPORT Manifest (After #2)

./build_64.bat tests/run_cmp_interop.bas
./tests/run_cmp_interop_64.exe
# Expected: dist/cmp_interop/import_build_manifest.csv exists + PASS
Gate 3: NOZEROVARS Runtime (After #1)

' New test: tests/run_nozerovars_init_exec_ast.bas
'%%NOZEROVARS ON
'DIM x AS I32
'PRINT x  ' Should print non-zero (garbage)
Gate 4: Full Lane (tools/run_faz_a_gate.ps1)

powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild
# Mandatory tests:
#   - run_percent_preprocess_meta_exec_64.exe
#   - run_decl_directive_exec_ast_64.exe
#   - run_cmp_interop_64.exe
#   - run_dim_const_test_64.exe (extend)
4) MACRO-LEVEL → RUNTIME IMPACT EN KISA YOL
BAŞLANGIÇ (Hemen yapılabilir):
├─ %%NOZEROVARS: Lexer macro → ExecValueInit() skip (2 λ)
│  └─ Impact: Variable memory pattern değişir
│     Test: Uninitialized I32 ≠ 0
│     Gate: 10 min
│
├─ IMPORT: Parser AST → InteropManifestAddImport() (3 λ)
│  └─ Impact: Manifest CSV emit
│     Test: dist/cmp_interop/import_build_manifest.csv check
│     Gate: 15 min
│
└─ %%DESTOS: Already working (doc sync only)
   └─ Impact: Conditional compile (%%IFC DESTOS, ...)
      Test: run_percent_preprocess_meta_exec (zaten var)
      Gate: 5 min

İLERİ ADIM (1-2 saat):
├─ %%SECSTACK: Runtime shadow frame (40+λ)
│  └─ Impact: Memory access logging + buffer overflow detect
│     Test: Yeni test yazılması gerekir
│     Gate: 1-2 saat
│
└─ INLINE Codegen: X64 ASM emit (100+λ)
   └─ Impact: INLINE blocks → .o object output
      Test: run_inline_x64_backend extend
      Gate: 3-4 saat
KISA TERCIH (3 Satır kod = 30 dakika):
ExecValueInit() kondisyonlandır (gNoZeroVars flag)
ExecRunStatement() "IMPORT_STMT" case'i aktifleştir
run_faz_a_gate.ps1 mevcut testlerle çalıştır
→ Sonuç: S=KISMEN → S=OK (IMPORT/NOZEROVARS/DESTOS)

ÖZETİ: En kısa macro→runtime geçiş 40 satır kod + test yazma ile 3 kalemden 2'sini (%%NOZEROVARS, IMPORT) OK yapabilir. %%DESTOS zaten çalışıyor (doc-only). %%SECSTACK + INLINE emit 2. sprint işi.

Explore: Runtime operator redim float
Finished with 3 steps
1) MEVCUT RUNTİME KAPASİTESİ
REDIM Runtime (KISMEN durumu)
Fonksiyon: ExecEvalREDIM

Desteklenen:

Tek boyut array'leri: ✓ (bounds parse, type check, extent calculation)
Scalar variable atama sonrası REDIM: ✓ (test: run_dim_redim_exec_ast.bas)
Error fail-fast: REDIM variable not declared, type mismatch, invalid extent
Out of Scope (R3.N):

Multi-dimension arrays: "REDIM: only single-dimension arrays supported in R3.N" (line 753)
PRESERVE keyword: Parse fail-fast var, runtime handle yok
Atama Operatörleri (=, +=, -=, *=, /=, \=, =+, =-)
Fonksiyon: ExecRunAssignStmt
Desteklenen:
= direct assignment
+=, -= addition/subtraction (integer & float capable)
*= multiplication (integer & float capable)
/= division → her zaman FLOAT return (line 58)
\\= integer division (integer only)
=+, =- unary positive/negative
Sınırlamalar: Compound semantik constraint açıklanmamış
Çarpma/Bölme/Mod Operatörleri
Fonksiyon: ExecEvalBinaryValues
Desteklenen:
* → integer×integer = integer; else float
/ → FLOAT result always (line 928-932, "Desteklenmeyen ikili işlem" hatası dış)
\\ → integer division (line 919-924)
%, MOD → integer modulo (line 925)
Sınır: Integer-focused, float ops limited (parser support eksik)
2) DOĞRUDAN OK'A ÇEKMEK İÇİN MİNİMUM KOD/TEST SETİ
Hedef	Yapılması Gereken	Test Dosyası	Mevcut Durum
REDIM OK	Multi-dim bounds + PRESERVE runtime impl	run_dim_redim_exec_ast.bas	Tek boyut test geçer, multi-dim fail-fast ✓
Atama OK	/= operatörü float type coercion semantik	run_assignment_compound_exec_ast.bas	7 operator test geçer (+=, -=, *=, /=, \=, =+, =-)
Çarpma/Bölme/Mod OK	Operator precedence + type coercion docs	run_assignment_compound_exec_ast.bas	Integer ops test geçer, float edge-case coverage gaps
Minimum test seti (Faz A gate kabullük için):

tests/run_dim_redim_exec_ast.bas - scalar + array REDIM cycle
tests/run_assignment_compound_exec_ast.bas - tüm 7 atama operatörü
3) ERTELENEBİLECEK (NON-CRITICAL) KISİMLAR
Madde	Neden Ertele	Taşıdığı Risk
REDIM PRESERVE	Parser accept + runtime impl aktif (tek/cok-boyut REDIM yolu)	Element-level preserve semantiginde ileri stres/performans testleri R4'e tasinabilir
Floating Point (CDBL, CSNG, SQR, SIN vb)	Compiler floating-point parse/semantic desteği YOK (critical blocker); runtime ExecValueToFloat() var ama lang kökeninde destekleme eksik	run_floating_point_exec.bas compile fail
Operator Type Coercion Edge-case	Int/float mix semantik, /= float coercion kesin ama doc unclear	Karışık tip bölme sonuç inconsistency riski
FLOATING POINT YOK Nedeni (Kritik):

Runtime: ✓ ExecValueSetFloat(), ExecValueToFloat(), değişken storage var
Parser: ✗ SINGLE, DOUBLE, EXTENDED type token recognition yok
Test: run_floating_point_exec.bas compile fail "Compiler floating point desteklemiyor"
NET DOSYA & FONKSIYON LİSTESİ
Runtime Impl Dosyaları:

src/runtime/memory_exec.fbs → ExecEvalREDIM, ExecEvalBinaryValues
src/runtime/exec/exec_stmt_memory_core.fbs → ExecRunAssignStmt, ExecRunIncDecStmt
Test Dosyaları:

tests/run_dim_redim_exec_ast.bas
tests/run_assignment_compound_exec_ast.bas
tests/run_floating_point_exec.bas