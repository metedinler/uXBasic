**uXBasic Tamamlanmış Çalıştırılabilir Anahtar Kelimeler ve Özellikler Dokümanı**

**Versiyon:** Tamamlanmış Referans (Tüm planlı, kısmi ve miras özellikler tamamlanmış kabul edilerek derlenmiştir)  
**Kapsam:** Belgelerdeki tüm komutlar, fonksiyonlar, operatörler, veri tipleri, veri yapıları ve ek gruplar sistematik olarak sınıflandırılmıştır.  
**Kurallar:** Her öğe aynı tablo stiliyle (Anahtar Kelime | Syntax Örneği | Açıklama) sunulmuştur. Komutlar gruplandırılmamıştır; her kategori kendi içinde düz ve tutarlı tablolarla listelenmiştir.

### uXBasic Derleyici Komut Satırı Argümanları (--flags)

- `--execmem` : AST tabanlı memory execution modunu aktif eder (sanal bellek VM ile kontrollü çalıştırma).  
- `--build-x64` : Tam x64 native codegen pipeline’ını çalıştırır (ASM → OBJ → EXE üretimi).  
- `--ast-json-out` : Parse edilen AST ağacını JSON olarak dosyaya yazar.  
- `--inventory-json-out` : Kullanılan tüm komut/fonksiyon/operator/tip envanterini JSON olarak çıkarır.  
- `--pipeline-json-out` : Derleme pipeline akış bilgilerini JSON olarak kaydeder.  
- `--mir-opcodes-json-out` : MIR opcode envanterini JSON olarak üretir.  
- `--interpreter-backend AST` : AST tabanlı interpreter’ı seçer (varsayılan).  
- `--interpreter-backend MIR` : MIR tabanlı interpreter’ı seçer.  
- `--codegen` : Sadece codegen aşamasını çalıştırır (tam build yapmaz).  

### 1. Program Yapısı ve Giriş Noktaları

| Anahtar Kelime / Yapı          | Syntax Örneği                                      | Açıklama |
|--------------------------------|----------------------------------------------------|----------|
| MAIN ... END MAIN             | MAIN ... END MAIN                                 | Program giriş noktası (x64 entry) |
| INCLUDE                       | INCLUDE "ortak.bas"                               | Kaynak dosya dahil etme |
| IMPORT                        | IMPORT(C, "native/helper.c")                      | Native artefakt ekleme (C/CPP/ASM) |
| %%INCLUDE                     | %%INCLUDE "dosya.inc"                             | Derleme zamanı include |
| %%IFC                         | %%IFC ... %%ENDCOMP                               | Derleme zamanı koşullu blok |
| %%IF                          | %%IF ... %%ELSE ... %%ENDIF                       | Derleme zamanı if |
| %%ELSE                        | %%ELSE ... %%ENDIF                                | Derleme zamanı else |
| %%ENDIF                       | %%ENDIF                                           | Koşullu blok sonu |
| %%ENDCOMP                     | %%ENDCOMP                                         | Derleme zamanı blok sonlandırma |
| %%ERRORENDCOMP                | %%ERRORENDCOMP                                    | Derleme zamanı hata ile sonlandırma |
| %%NOZEROVARS                  | %%NOZEROVARS                                      | Sıfırlanmamış değişken izni |
| %%SECSTACK                    | %%SECSTACK                                        | Stack güvenliği ayarı |
| %%PLATFORM                    | %%PLATFORM                                        | Platform kontrol direktifi |
| %%DESTOS                      | %%DESTOS                                          | Hedef işletim sistemi direktifi |

### 2. Komutlar (Statements)

| Anahtar Kelime / Yapı                  | Syntax Örneği                                      | Açıklama |
|----------------------------------------|----------------------------------------------------|----------|
| PRINT                                 | PRINT expr; / PRINT "metin"                       | Konsol çıktısı |
| INPUT                                 | INPUT x                                           | Konsol girdisi |
| INPUT#                                | INPUT #1, var                                     | Dosya girdisi |
| IF ... THEN ... ELSEIF ... ELSE ... END IF | IF x > 10 THEN ... END IF                        | Koşullu dallanma |
| SELECT CASE ... CASE ... CASE ELSE ... END SELECT | SELECT CASE x ... END SELECT                     | Çoklu koşul |
| CASE IS                               | CASE IS > 10                                      | İlişkisel case |
| FOR ... TO ... [STEP ...] ... NEXT    | FOR i = 1 TO 10 ... NEXT                          | Sayısal döngü |
| FOR EACH ... NEXT                     | FOR EACH v, idx IN 10, 20, 30 ... NEXT           | Liste döngüsü |
| DO ... LOOP                           | DO WHILE x < 10 ... LOOP                          | Koşullu döngü |
| DO EACH ... LOOP                      | DO EACH v IN 4, 5, 6 ... LOOP                     | Item tabanlı döngü |
| GOTO                                  | GOTO label                                        | Etiket sıçrama |
| GOSUB                                 | GOSUB worker                                      | Alt rutin çağrısı |
| RETURN                                | RETURN                                            | Alt rutinden dönüş |
| EXIT FOR                              | EXIT FOR                                          | For döngüsünden erken çıkış |
| EXIT DO                               | EXIT DO                                           | Do döngüsünden erken çıkış |
| EXIT IF                               | EXIT IF                                           | If bloğundan erken çıkış |
| END                                   | END                                               | Program sonlandırma |
| TRY ... CATCH ... FINALLY ... END TRY | TRY ... CATCH ... END TRY                         | Hata yakalama |
| THROW                                 | THROW "hata"                                      | Özel hata fırlatma |
| ASSERT                                | ASSERT x > 0                                      | Debug assertion |
| CONST                                 | CONST PI2 = 6                                     | Sabit tanımlama |
| DIM                                   | DIM x AS I32 / DIM arr(0 TO 9) AS I32            | Değişken / dizi tanımı |
| REDIM                                 | REDIM arr(0 TO 19) AS I32                         | Dizi yeniden boyutlandırma |
| REDIM PRESERVE                        | REDIM PRESERVE arr(0 TO 29) AS I32                | Koruyarak yeniden boyutlandırma |
| TYPE ... END TYPE                     | TYPE Vec2 ... END TYPE                            | Kullanıcı tanımlı tip |
| CLASS ... END CLASS                   | CLASS Counter ... END CLASS                       | Sınıf tanımı |
| INTERFACE ... END INTERFACE           | INTERFACE ILog ... END INTERFACE                  | Arayüz tanımı |
| DECLARE SUB                           | DECLARE SUB Show()                                | Sub ön bildirim |
| DECLARE FUNCTION                      | DECLARE FUNCTION Topla(a AS I32) AS I32           | Function ön bildirim |
| SUB ... END SUB                       | SUB Worker ... END SUB                            | Alt program tanımı |
| FUNCTION ... END FUNCTION             | FUNCTION Topla ... END FUNCTION                   | Fonksiyon tanımı |
| DEFINT                                | DEFINT A-Z                                        | Varsayılan tip atama (integer) |
| DEFLNG                                | DEFLNG A-Z                                        | Varsayılan tip atama (long) |
| DEFSNG                                | DEFSNG A-Z                                        | Varsayılan tip atama (single) |
| DEFDBL                                | DEFDBL A-Z                                        | Varsayılan tip atama (double) |
| DEFEXT                                | DEFEXT A-Z                                        | Varsayılan tip atama (extended) |
| DEFSTR                                | DEFSTR S-T                                        | Varsayılan tip atama (string) |
| DEFBYT                                | DEFBYT B-Z                                        | Varsayılan tip atama (byte) |
| SETSTRINGSIZE                         | SETSTRINGSIZE 64                                  | String buffer boyutu ayarı |
| CLS                                   | CLS                                               | Ekran temizleme |
| COLOR                                 | COLOR 14, 1                                       | Renk ayarı |
| LOCATE                                | LOCATE 5, 10                                      | İmleç konumlandırma |
| INC                                   | INC x                                             | Değişken arttırma |
| DEC                                   | DEC y                                             | Değişken azaltma |
| POKE                                  | POKE addr, val                                    | Belleğe genel yazma |
| POKEB                                 | POKEB addr, val                                   | Byte yazma |
| POKEW                                 | POKEW addr, val                                   | Word yazma |
| POKED                                 | POKED addr, val                                   | Dword yazma |
| POKES                                 | POKES addr, "metin"                               | String yazma |
| MEMCOPYB                              | MEMCOPYB src, dst, n                              | Byte kopyalama |
| MEMCOPYW                              | MEMCOPYW src, dst, n                              | Word kopyalama |
| MEMCOPYD                              | MEMCOPYD src, dst, n                              | Dword kopyalama |
| MEMFILLB                              | MEMFILLB addr, val, n                             | Byte doldurma |
| MEMFILLW                              | MEMFILLW addr, val, n                             | Word doldurma |
| MEMFILLD                              | MEMFILLD addr, val, n                             | Dword doldurma |
| SETNEWOFFSET                          | SETNEWOFFSET var, newaddr                         | Offset yeniden bağlama |
| OPEN                                  | OPEN "dosya" FOR BINARY AS #1                     | Dosya açma |
| CLOSE                                 | CLOSE #1                                          | Dosya kapatma |
| GET                                   | GET #1, , var                                     | Dosya okuma |
| PUT                                   | PUT #1, , var                                     | Dosya yazma |
| SEEK                                  | SEEK #1, pos                                      | Dosya konumlandırma |
| LOF                                   | LOF(1)                                            | Dosya boyutu |
| EOF                                   | EOF(1)                                            | Dosya sonu kontrolü |
| INLINE(...) ... END INLINE            | INLINE("x64","nasm",...) ... END INLINE           | Native inline blok |
| EVENT ... END EVENT                   | EVENT EventAdi, 10 ... END EVENT                  | Event bloğu |
| THREAD ... END THREAD                 | THREAD Worker, 1 ... END THREAD                   | Thread bloğu |
| THREAT ... END THREAT                 | THREAT Worker, 1 ... END THREAT                   | Thread alias bloğu |
| PARALEL ... END PARALEL               | PARALEL Job, 2 ... END PARALEL                    | Paralel iş bloğu |
| PIPE ... END PIPE                     | PIPE Normalize, 3 ... END PIPE                    | Pipe bloğu |
| SLOT                                  | SLOT EVENT 32                                     | Slot deklarasyonu |
| ON EVENT                              | ON EVENT EventAdi                                 | Event/pipe/thread aktif etme |
| OFF EVENT                             | OFF EVENT EventAdi                                | Event/pipe/thread pasif etme |
| TRIGGER EVENT                         | TRIGGER EVENT EventAdi                            | Event tetikleme |
| CALL(DLL, ...)                        | CALL(DLL, "kernel32.dll", "Sleep", ...)          | Ham DLL çağrısı |
| CALL(API, ...)                        | CALL(API, "windows.user32.MessageBoxA", ...)      | Kayıtlı API çağrısı |

### 3. Intrinsic Fonksiyonlar

| Anahtar Kelime / Yapı          | Syntax Örneği                                      | Açıklama |
|--------------------------------|----------------------------------------------------|----------|
| LEN                           | LEN("abc")                                        | String uzunluğu |
| MID                           | MID("ABCDE", 2, 2)                                | Alt string alma |
| STR                           | STR(42)                                           | Sayı → string |
| VAL                           | VAL("123")                                        | String → sayı |
| UCASE                         | UCASE("abc")                                      | Büyük harfe çevir |
| LCASE                         | LCASE("ABC")                                      | Küçük harfe çevir |
| LTRIM                         | LTRIM("   a")                                     | Soldan boşluk temizle |
| RTRIM                         | RTRIM("a   ")                                     | Sağdan boşluk temizle |
| ASC                           | ASC("A")                                          | Karakter kodu |
| CHR                           | CHR(65)                                           | Kod → karakter |
| SPACE                         | SPACE(5)                                          | Boşluk stringi |
| STRING                        | STRING(3, 65)                                     | Tekrar eden string |
| ABS                           | ABS(-7)                                           | Mutlak değer |
| SGN                           | SGN(-5)                                           | İşaret |
| INT                           | INT(3.9)                                          | Tamsayıya yuvarla |
| FIX                           | FIX(3.9)                                          | Kesirli kısmı at |
| CINT                          | CINT(3.2)                                         | Integer’a çevir |
| CLNG                          | CLNG(123456)                                      | Long’a çevir |
| CDBL                          | CDBL(3.14)                                        | Double’a çevir |
| CSNG                          | CSNG(3.14)                                        | Single’a çevir |
| SQR                           | SQR(16)                                           | Kare kök |
| SQRT                          | SQRT(16)                                          | Kare kök (alias) |
| SIN                           | SIN(0)                                            | Sinüs |
| COS                           | COS(0)                                            | Kosinüs |
| TAN                           | TAN(0)                                            | Tanjant |
| ATN                           | ATN(1)                                            | Arktanjant |
| EXP                           | EXP(1)                                            | e üzeri |
| LOG                           | LOG(1)                                            | Doğal logaritma |
| RND                           | RND(1)                                            | Rastgele sayı |
| RANDOMIZE                     | RANDOMIZE                                         | Rastgele tohum ayarla |
| PEEKB                         | PEEKB(100)                                        | Byte oku |
| PEEKW                         | PEEKW(200)                                        | Word oku |
| PEEKD                         | PEEKD(300)                                        | Dword oku |
| VARPTR                        | VARPTR(x)                                         | Değişken adresi |
| SADD                          | SADD(s$)                                          | String adresi |
| LPTR                          | LPTR(label)                                       | Label pointer |
| CODEPTR                       | CODEPTR(proc)                                     | Procedure adresi |
| TIMER                         | TIMER("ms") / TIMER(start, end, unit)            | Zaman ölçümü |
| INKEY                         | INKEY(flags)                                      | Tuş durumu oku |
| GETKEY                        | GETKEY()                                          | Tuş bekle ve oku |
| SIZEOF                        | SIZEOF(Vec2)                                      | Tip boyutu |
| OFFSETOF                      | OFFSETOF(Vec2, x)                                 | Alan ofseti |

### 4. Operatörler

| Anahtar Kelime / Yapı          | Syntax Örneği                                      | Açıklama |
|--------------------------------|----------------------------------------------------|----------|
| +                             | x = 10 + 3                                        | Toplama |
| -                             | x = 10 - 3                                        | Çıkarma |
| *                             | x = 10 * 3                                        | Çarpma |
| /                             | x = 10 / 2                                        | Bölme |
| MOD                           | x = 10 MOD 3                                      | Modül |
| **                            | x = 2 ** 3                                        | Üs alma |
| =                             | x = y                                             | Eşitlik / atama |
| <>                            | x <> y                                            | Eşit değil |
| <                             | x < y                                             | Küçük |
| <=                            | x <= y                                            | Küçük eşit |
| >                             | x > y                                             | Büyük |
| >=                            | x >= y                                            | Büyük eşit |
| AND                           | mask = 1 AND 3                                    | Mantıksal / bitwise AND |
| OR                            | mask = 1 OR 2                                     | Mantıksal / bitwise OR |
| XOR                           | mask = 1 XOR 3                                    | Bitwise XOR |
| NOT                           | x = NOT 5                                         | Mantıksal / bitwise NOT |
| SHL                           | a = 1 SHL 4                                       | Sol kaydırma |
| SHR                           | b = 8 SHR 1                                       | Sağ kaydırma |
| ROL                           | c = 1 ROL 3                                       | Sol döndürme |
| ROR                           | d = 8 ROR 1                                       | Sağ döndürme |
| <<                            | a = 1 << 4                                        | Sol kaydırma (operator) |
| >>                            | b = 8 >> 1                                        | Sağ kaydırma (operator) |
| +=                            | x += 5                                            | Bileşik toplama atama |
| -=                            | x -= 3                                            | Bileşik çıkarma atama |
| *=                            | x *= 2                                            | Bileşik çarpma atama |
| /=                            | x /= 2                                            | Bileşik bölme atama |
| @                             | p = @var                                          | Adres alma |
| \|                            | sonuc = 10 \| Normalize                           | Pipe operatörü |

### 5. Veri Tipleri

| Anahtar Kelime / Yapı          | Syntax Örneği                                      | Açıklama |
|--------------------------------|----------------------------------------------------|----------|
| I8                            | DIM x AS I8                                       | 8-bit işaretli tam sayı |
| U8                            | DIM x AS U8                                       | 8-bit işaretsiz tam sayı |
| I16                           | DIM x AS I16                                      | 16-bit işaretli tam sayı |
| U16                           | DIM x AS U16                                      | 16-bit işaretsiz tam sayı |
| I32                           | DIM x AS I32                                      | 32-bit işaretli tam sayı |
| U32                           | DIM x AS U32                                      | 32-bit işaretsiz tam sayı |
| I64                           | DIM x AS I64                                      | 64-bit işaretli tam sayı |
| U64                           | DIM x AS U64                                      | 64-bit işaretsiz tam sayı |
| F32                           | DIM x AS F32                                      | Tek hassasiyetli float |
| F64                           | DIM x AS F64                                      | Çift hassasiyetli float |
| BOOLEAN                       | DIM ok AS BOOLEAN                                 | Mantıksal değer |
| STRING                        | DIM s AS STRING = "abc"                           | Dinamik string |
| POINTER                       | DIM p AS POINTER                                  | Genel pointer |
| PTR                           | DIM p AS PTR                                      | Pointer alias |

### 6. Veri Yapıları ve OOP Özellikleri

| Anahtar Kelime / Yapı                  | Syntax Örneği                                      | Açıklama |
|----------------------------------------|----------------------------------------------------|----------|
| TYPE ... END TYPE                     | TYPE Point x AS I32 y AS I32 END TYPE             | Alanlı yapı |
| LIST                                  | DIM l AS LIST                                     | Liste |
| DICT                                  | DIM d AS DICT                                     | Sözlük |
| SET                                   | DIM s AS SET                                      | Küme |
| ARRAY                                 | DIM arr AS ARRAY                                  | Genel dizi |
| CLASS ... END CLASS                   | CLASS Counter ... END CLASS                       | Sınıf tanımı |
| INTERFACE ... END INTERFACE           | INTERFACE ILog ... END INTERFACE                  | Arayüz tanımı |
| EXTENDS                               | CLASS Derived EXTENDS Base                        | Kalıtım |
| IMPLEMENTS                            | CLASS Impl IMPLEMENTS ILog                        | Arayüz uygulama |
| PUBLIC                                | PUBLIC                                            | Genel erişim |
| PRIVATE                               | PRIVATE                                           | Sınıf içi erişim |
| PROTECTED                             | PROTECTED                                         | Korumalı erişim |
| RESTRICTED                            | RESTRICTED                                        | Kısıtlı erişim |
| FRIEND                                | FRIEND                                            | Arkadaş erişim istisnası |
| METHOD                                | METHOD Increment                                  | Metod bildirimi |
| CONSTRUCTOR                           | CONSTRUCTOR                                       | Yapıcı metod |
| DESTRUCTOR                            | DESTRUCTOR                                        | Yıkıcı metod |
| THIS                                  | THIS.field                                        | Mevcut nesne referansı |
| ME                                    | ME.field                                          | THIS alias |
| OVERRIDE                              | OVERRIDE                                          | Üst sınıftan ezme |
| VIRTUAL                               | VIRTUAL                                           | Sanal metod |
| NEW                                   | NEW Counter                                       | Nesne oluşturma |
| DELETE                                | DELETE obj                                        | Nesne yok etme |
| NAMESPACE ... END NAMESPACE           | NAMESPACE Utils ... END NAMESPACE                 | İsim alanı |
| MODULE ... END MODULE                 | MODULE Modul ... END MODULE                       | Modül |
| USING                                 | USING Utils                                       | İsim alanı kullanımı |
| ALIAS                                 | ALIAS EskiAd YeniAd                               | Takma ad |

### 7. FFI, DLL ve API Çağrıları

| Anahtar Kelime / Yapı                  | Syntax Örneği                                      | Açıklama |
|----------------------------------------|----------------------------------------------------|----------|
| CALL(DLL, ...)                        | CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25) | Ham DLL çağrısı |
| CALL(API, ...)                        | CALL(API, "windows.user32.MessageBoxA", ...)      | Kayıtlı API çağrısı |
| STDCALL                               | ... STDCALL ...                                   | Stdcall konvansiyonu |
| CDECL                                 | ... CDECL ...                                     | Cdecl konvansiyonu |
| BYVAL                                 | BYVAL                                             | Değer ile geçirme |
| BYREF                                 | BYREF                                             | Referans ile geçirme |
| PTR                                   | PTR                                               | Pointer argüman tipi |
| STRPTR                                | STRPTR                                            | String pointer tipi |

**Bitti.**