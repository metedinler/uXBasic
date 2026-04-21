# uXBasic Programci ve Mimar Kitabi (PCK4)

Bu belge uXBasic dilinin mevcut parser/semantic/runtime gercegine gore hazirlanmis resmi teknik ozet ve yol haritasidir.

## 1. Dil Ozeti ve Soz Dizimi Tablolari

### 1.1 Makrolar ve Preprocess Direktifleri

| Grup | Sozdizimi | Aciklama |
|---|---|---|
| Deger tanimlama | %%DEFINE NAME [VALUE] | Compile-time makro tanimi. VALUE verilmezse 1 kabul edilir. |
| Fonksiyonel makro | %%MACRO NAME(P1,P2,...) BODY | Parametreli metin genisletme. |
| Makro silme | %%UNDEF NAME | Tanimli makroyu kaldirir. |
| Kosullu derleme | %%IF EXPR ... %%ELSE ... %%ENDIF | Kosul dogruysa ilgili bloku preprocess asamasinda birakir. |
| Metin kosulu | %%IFC LHS, RHS | Iki token metnini case-insensitive karsilastirir. |
| Platform guard | %%PLATFORM WINDOWS/LINUX/MACOS | Host platformla uyumsuzsa preprocess fail verir. |
| Hedef OS | %%DESTOS WINDOWS/LINUX/MACOS | Hedef platform metadata'si ayarlar. |
| Zero-var policy | %%NOZEROVARS ON/OFF | Sifir initialize davranisi icin compile-time isaret. |
| Stack policy | %%SECSTACK ON/OFF | Guvenli stack metadata'si icin compile-time isaret. |
| Include | %%INCLUDE "path" | Baska kaynak dosyayi preprocess asamasinda ekler. |
| Derlemeyi durdurma | %%ENDCOMP | Aktif blokta preprocess stop verir. |
| Hata ile durdurma | %%ERRORENDCOMP [mesaj] | Acik mesajla preprocess fail verir. |

### 1.2 Komutlar (Statements)

| Grup | Komutlar | Kisa Aciklama |
|---|---|---|
| Akis kontrolu | IF, ELSEIF, ELSE, END IF | Kosullu calisma |
| Secim | SELECT CASE, CASE, CASE ELSE, END SELECT | Coklu dal secimi |
| Dongu | FOR...NEXT, FOR EACH...NEXT, DO...LOOP, DO EACH...LOOP | Tekrar yapilari |
| Erken cikis | EXIT FOR, EXIT DO, EXIT IF, END, RETURN | Blogu veya akisi sonlandirma |
| Sube/etiket | GOTO, GOSUB | Etiket tabanli akis |
| Hata blogu | TRY, CATCH, FINALLY, THROW, ASSERT | Hata yakalama/yukselme |
| Degisken | DIM, REDIM, CONST | Veri tanimlama |
| Tip ve OOP | TYPE, CLASS, INTERFACE, METHOD, NEW, DELETE | Yapilar ve nesne modeli |
| Program organizasyonu | NAMESPACE, MODULE, MAIN, USING, ALIAS | Scope ve isim cozumleme |
| Dosya I/O | OPEN, CLOSE, GET, PUT, SEEK, INPUT, PRINT | Dosya ve konsol islemleri |
| Ekran | CLS, COLOR, LOCATE | Konsol goruntusu |
| Bellek | POKEB/W/D, POKE, MEMCOPYB/W/D, MEMFILLB/W/D, INC, DEC | Dusuk seviye bellek ve yardimci komutlar |
| Interop | IMPORT(C/CPP/ASM, "file"), INLINE(...), CALL(DLL, ...) | Dis kod ve DLL baglantisi |

### 1.3 Fonksiyonlar (Intrinsics)

| Kategori | Fonksiyonlar | Aciklama |
|---|---|---|
| Metin | LEN, MID, STR, VAL, UCASE, LCASE, LTRIM, RTRIM, SPACE, ASC, CHR | String donusum ve analiz |
| Matematik | ABS, INT, FIX, SQR, SIN, COS, TAN, ATN, EXP, LOG, SGN | Temel matematik |
| Donusum | CINT, CLNG, CDBL, CSNG | Tip donusumleri |
| Rastgele/Zaman | RND, RANDOMIZE, TIMER | Rastgelelik ve zaman |
| Dosya | LOF, EOF | Dosya boyutu/sonu |
| Bellek okuma | PEEKB, PEEKW, PEEKD | Adresten veri okuma |
| Klavye | INKEY, GETKEY | Giris olaylari |
| Pointer/meta | VARPTR, SADD, LPTR, CODEPTR, SIZEOF, OFFSETOF | Adres ve layout yardimcilari |

### 1.4 Operatorler

| Operator grubu | Operatorler | Aciklama |
|---|---|---|
| Aritmetik | +, -, *, /, \\, MOD, ** | Sayisal islemler |
| Bit kaydirma/rotasyon | <<, >>, SHL, SHR, ROL, ROR | Bit tabanli islemler |
| Karsilastirma | =, <>, <, >, <=, >= | Bool sonuc ureten karsilastirma |
| Mantiksal | AND, OR, XOR, NOT | Mantiksal/bitwise islemler |
| Atama | =, +=, -=, *=, /=, \\=, =+, =- | Atama varyantlari |
| Diger | @, ++, -- | Ozel unary/postfix kullanimi |

### 1.5 Veri Tipleri

| Tip | Aciklama |
|---|---|
| I8/U8 | 8-bit signed/unsigned integer |
| I16/U16 | 16-bit signed/unsigned integer |
| I32/U32 | 32-bit signed/unsigned integer |
| I64/U64 | 64-bit signed/unsigned integer |
| F32/F64/F80 | Floating point tipleri |
| BOOLEAN | Mantiksal tip |
| STRING | Metinsel tip |
| OBJECT | Dinamik class referans ust tipi |
| PTR/STRPTR/BYREF/BYVAL | Arguman ve pointer semantigi |

### 1.6 Veri Yapilari

| Yapi | Sozdizimi | Aciklama |
|---|---|---|
| Dizi | DIM a(0 TO n) AS I32 | Sabit/yeniden boyutlanan diziler |
| REDIM | REDIM [PRESERVE] a(0 TO m) AS I32 | Dizi kapasitesi degisimi |
| TYPE | TYPE T ... END TYPE | UDT (value-type) |
| CLASS | CLASS C ... END CLASS | OOP nesne yapisi |
| INTERFACE | INTERFACE I ... END INTERFACE | Davranis sozlesmesi |
| LIST/DICT/SET | DIM l AS LIST vb. | Runtime koleksiyon tipleri |

### 1.7 Degiskenler ve Scope

| Alan | Sozdizimi | Aciklama |
|---|---|---|
| Yerel degisken | DIM x AS I32 | Bulundugu blok/prosedur scope'unda |
| Global benzeri | MAIN/NAMESPACE seviyesinde DIM | Program omru boyunca erisim |
| Alias | ALIAS Tick = CALL(DLL,...) | Isim baglama ve proxy cagri |
| Module/Namespace | NAMESPACE N / MODULE M | Mantiksal isim alani ve modulerlik |

## 2. uXBasic Derleyici ve Runtime Mimarisi

### 2.1 Ust Seviye Pipeline

1. Kaynak dosya yukleme
2. Preprocess ve lexing
3. Parser ile AST olusturma
4. Semantic pass (tip/scope/kurallar)
5. Opsiyonel runtime AST interpreter (execmem)
6. Opsiyonel MIR lane
7. Opsiyonel interop/codegen lane (x64/x86)

### 2.2 Katmanlar

| Katman | Ana dizinler | Sorumluluk |
|---|---|---|
| Giris ve orkestrasyon | src/main.bas | CLI, mode secimi, pipeline yonetimi |
| Lexer + preprocess | src/parser/lexer, lexer_preprocess.fbs | Token uretimi, %% direktifleri |
| Parser | src/parser/parser, parser_stmt_* | AST kurma |
| Semantic | src/semantic | Tip baglama, layout, guardlar |
| Runtime AST | src/runtime/memory_exec.fbs + src/runtime/exec | Komut ve ifade calistirma |
| MIR | src/semantic/mir.fbs | Orta seviye temsil ve evaluator |
| Codegen | src/codegen/x64, src/codegen/x86 | NASM plani, ABI lane |
| FFI policy + signer | src/runtime/ffi_signer.fbs | DLL allowlist, hash/signer dogrulama |
| Interop manifest | src/build/interop_manifest.fbs | IMPORT/INLINE kaynak envanteri |

### 2.3 FFI, INLINE, IMPORT ve Scope Birlikte Calisma

| Ozellik | Durum | Not |
|---|---|---|
| IMPORT(C/CPP/ASM) | Aktif | Interop manifest uretilir |
| INLINE(...) ... END INLINE | Aktif parser/runtime skip + codegen lane plani | ABI/preserve/stack metadata kabul edilir |
| CALL(DLL, ...) | Aktif | Runtime policy ve typed marshalling guardlari ile |
| CDECL/STDCALL tokenlari | Aktif | x64 lane'de uyumlu ABI metadata olarak ele alinir |
| NAMESPACE/MODULE/USING/ALIAS + DLL | Aktif | Scope ve alias cagrilari testlerle dogrulanmis |

### 2.4 Ornek: Namespace + Module + Alias + DLL

```basic
NAMESPACE CORE
MODULE IO
ALIAS Tick = CALL(DLL, "kernel32.dll", "GetTickCount", I32, STDCALL)
END MODULE
END NAMESPACE

MAIN
a = 77
CALL(Tick, a)
PRINT a
END MAIN
```

## 3. UXSTAT: Ilk Resmi uXBasic DLL (Istatistik Modulu)

Bu bolum planyap altindaki DLL planlari ve uxstat scope plani baz alinarak hazirlanmistir.

### 3.1 Hedef

- uXBasic icin ilk resmi DLL: uxstat.dll
- C ABI ile guvenli, deterministic, testlenebilir istatistik cekirdegi
- Dil cekirdigine 100+ komut gommek yerine CALL(DLL, ...) ile moduler entegrasyon

### 3.2 Kapsam (MVP)

| Alan | Kapsam |
|---|---|
| Veri yapisi | UxbStatVectorF64 (data + missing mask + uzunluk) |
| Bellek API | create/destroy/set/get/missing |
| Istatistik API | mean/var/std/sem/min/max |
| Runtime uyumu | CDECL ana yol, STDCALL wrapper yol |
| Interop | IMPORT(C, ...) ve CALL(DLL, ...) uyumlu semboller |

### 3.3 DLL Komut/Func Entegrasyon Modeli

| Katman | Kullanilan uXBasic komutlari | Aciklama |
|---|---|---|
| Build/interop | IMPORT(C, "extras/uxstat/src/uxstat.c") | Derleme/manifest uyumu |
| Native cagri | CALL(DLL, "uxstat.dll", "uxb_stat_mean_f64", F64, CDECL, ptr) | Runtime FFI cagrisi |
| Scope organizasyonu | NAMESPACE, MODULE, ALIAS | UXSTAT API'sini moduler expose etme |
| Inline yardimci | INLINE("x64", "nasm", ...) | Opsiyonel ABI/spill senaryolari |

### 3.4 UXSTAT API Ozeti

| Sembol | Aciklama |
|---|---|
| uxb_vec_create_f64 | F64 vektor olusturur |
| uxb_vec_destroy_f64 | Vektoru serbest birakir |
| uxb_vec_set_f64 / uxb_vec_get_f64 | Indeksli veri yaz/oku |
| uxb_vec_set_missing | Missing bayragi setler |
| uxb_stat_mean_f64 | Ortalama |
| uxb_stat_var_f64 | Varyans |
| uxb_stat_std_f64 | Standart sapma |
| uxb_stat_sem_f64 | Standard error of mean |
| uxb_stat_min_f64 / uxb_stat_max_f64 | Min/Max |
| ..._stdcall | Win32 wrapper sembolleri |

## 4. Uygulama Plani: UXSTAT-0 -> UXSTAT-1

### 4.1 Faz Plani

| Faz | Hedef | Cikti |
|---|---|---|
| UXSTAT-0 | C ABI cekirdek + vector + temel istatistik | uxstat.c + uxstat.h + build iskeleti |
| UXSTAT-1 | CSV load/save + dataframe-lite | csv API ve test genislemesi |
| UXSTAT-2 | Factor/kategorik kodlama + missing stratejileri | categorical API + encode yol |
| UXSTAT-3 | Regresyon ve ileri test paketleri | linear model + quality gate |

### 4.2 Teknik Kurallar

- ABI: CDECL temel, STDCALL wrapper destekli
- Guvenlik: NULL kontrolu, indeks sinir kontrolu, deterministic error code
- Numerik: Welford tabanli varyans ve std
- Missing data: byte-mask (0: var, 1: missing)

### 4.3 uXBasic Tarafta Entegrasyon Ornegi

```basic
NAMESPACE UXSTAT
MODULE CORE
ALIAS VecCreate = CALL(DLL, "uxstat.dll", "uxb_vec_create_f64", I32, CDECL)
ALIAS VecSet = CALL(DLL, "uxstat.dll", "uxb_vec_set_f64", I32, CDECL)
ALIAS Mean = CALL(DLL, "uxstat.dll", "uxb_stat_mean_f64", F64, CDECL)
END MODULE
END NAMESPACE
```

## 5. Kapanis

PCK4 ile birlikte:

- Dil komutlari, operatorler, tipler ve preprocess direktifleri tablo formatinda tek yerde toplandi.
- Derleyici/runtime mimarisi katman katman belgelendi.
- INLINE + CALL(DLL) + MODULE/NAMESPACE birlikte kullanimi netlestirildi.
- UXSTAT ilk resmi DLL icin teknik kapsam, API ve faz plani tanimlandi.

## 6. Baslangictan Ileriye uXBasic Egitim Bolumu

Bu bolum, dili hic bilmeyen bir gelistiricinin sifirdan baslayip gercek bir proje cikarmasina yardim etmek icin yazilmistir.

### 6.1 Ilk Zihinsel Model

uXBasic ile calisirken 3 seviyeyi ayri dusunmek en saglikli yoldur:

1. Dil seviyesi (kod yazdiginiz yer):
	- IF, FOR, DIM, FUNCTION, CLASS, CALL(DLL) gibi ifadeler.
2. Derleyici seviyesi:
	- Lexer -> Parser -> Semantic -> Runtime/Codegen sureci.
3. Build/interop seviyesi:
	- IMPORT(C/CPP/ASM) kaynaklari icin hangi derleyicinin cagrilacagi.

Temel ilke: once dil dogrulugu, sonra semantic dogrulugu, en son platform/derleyici detaylari.

### 6.2 En Kucuk Program

```basic
MAIN
PRINT "Merhaba uXBasic"
END MAIN
```

Bu ornekte:
- `MAIN` giris noktasidir.
- `PRINT` runtime tarafinda konsola yazi basar.
- `END MAIN` blogu kapatir.

### 6.3 Degisken, Ifade, Kosul

```basic
MAIN
DIM a AS I32
DIM b AS I32
a = 10
b = 20

IF a < b THEN
	 PRINT "a daha kucuk"
ELSE
	 PRINT "a daha buyuk/esit"
END IF
END MAIN
```

Ogrenme notu:
- Tip belirtmek (`AS I32`) daha belirgin ve guvenlidir.
- Kosul satirlarinda karsilastirma operatorleri (`<`, `>`, `=`) kullanilir.

### 6.4 Dongu Mantigi

```basic
MAIN
DIM i AS I32
FOR i = 1 TO 5
	 PRINT i
NEXT
END MAIN
```

Burada:
- `FOR ... NEXT` sayac tabanli dongudur.
- `i` her adimda artar.

### 6.5 Fonksiyon Yazma Mantigi

```basic
FUNCTION Topla(BYVAL x AS I32, BYVAL y AS I32) AS I32
	 RETURN x + y
END FUNCTION

MAIN
DIM s AS I32
s = Topla(7, 8)
PRINT s
END MAIN
```

Not:
- `BYVAL` deger kopyasi.
- `BYREF` adres/reference davranisi.

### 6.6 Module ve Namespace ile Organizasyon

```basic
NAMESPACE APP
MODULE MATH
FUNCTION Kare(BYVAL x AS I32) AS I32
	 RETURN x * x
END FUNCTION
END MODULE
END NAMESPACE

MAIN
PRINT APP.MATH.Kare(9)
END MAIN
```

Bu yapi buyuk projelerde isim cakismalarini azaltir.

### 6.7 FFI Mantigi: IMPORT ve CALL(DLL)

Iki farkli kavram vardir:

1. `IMPORT(C/CPP/ASM, "dosya")`
	- Yerel native kaynak dosyalarin build planina dahil edilmesi.
2. `CALL(DLL, "kutuphane", "sembol", imza, [convention], argumanlar...)`
	- Runtime aninda dinamik kutuphaneden fonksiyon cagrisi.

### 6.8 INLINE Komutu: Nedir, Neden Vardir?

`INLINE(...) ... END INLINE`, derleyiciye "bu bolum native asm/abi politikasina gore ele alinacak" bilgisini verir.

Header yapisi (4 arguman):

```text
INLINE(arch, assembler, kind, policy)
```

Ornek:

```basic
INLINE("x64", "nasm", "proc", "ABI=WIN64;PRESERVE=RBX;STACK=16;SHADOW=32")
mov rax, rax
END INLINE
```

### 6.9 INLINE Policy ile Derleyici Secimi (Yeni Toolchain Sistemi)

uXBasic interop zincirinde artik C/CPP/ASM compile ve link komutlari policy ile yonlendirilebilir.

Desteklenen anahtarlar:

| Anahtar | Anlam |
|---|---|
| CC | C derleyici komutu (orn: gcc, clang) |
| CXX | C++ derleyici komutu (orn: g++, clang++) |
| ASM | Assembler komutu (orn: nasm) |
| LINK | Linker komutu (orn: gcc, clang) |
| CC_PATH | C derleyici dizini |
| CXX_PATH | C++ derleyici dizini |
| ASM_PATH | Assembler dizini |
| LINK_PATH | Linker dizini |

INLINE policy ornegi:

```basic
INLINE("x64", "nasm", "proc", "ABI=WIN64;PRESERVE=RBX;STACK=16;CC=clang;CXX=clang++;ASM=nasm;LINK=clang")
mov rax, rax
END INLINE
```

Oncelik sirasi (son kazanan):

1. Default profil
2. Ortam degiskenleri (`UXB_CC`, `UXB_CXX`, `UXB_ASM`, `UXB_LINK`, path varyantlari)
3. INLINE policy anahtarlari

Bu yapi sayesinde proje bazli veya dosya bazli toolchain secimi yapabilirsiniz.

### 6.10 Coklu Ornekler (INLINE + IMPORT + CALL)

#### Ornek A: Sadece IMPORT

```basic
IMPORT(C, "native/math.c")
IMPORT(CPP, "native/stats.cpp")
IMPORT(ASM, "native/entry.asm")

MAIN
PRINT "import plani uretildi"
END MAIN
```

#### Ornek B: INLINE policy ile toolchain sabitleme

```basic
INLINE("x64", "nasm", "proc", "ABI=WIN64;PRESERVE=RBX;STACK=16;CC=clang;CXX=clang++;ASM=nasm;LINK=clang")
mov rax, rax
END INLINE

IMPORT(C, "native/helper.c")
MAIN
PRINT "clang tabanli interop"
END MAIN
```

#### Ornek C: DLL cagrisi alias ile

```basic
NAMESPACE SYS
MODULE TIME
ALIAS Tick = CALL(DLL, "kernel32.dll", "GetTickCount", I32, STDCALL)
END MODULE
END NAMESPACE

MAIN
DIM t AS I32
CALL(Tick, t)
PRINT t
END MAIN
```

## 7. Append-Only Komut Referansi (Detayli)

Bu bolum append-only mantigiyla yazilmistir. Yani mevcut ust bolumleri bozmadan yeni aciklamalari buraya ekler.

### 7.1 Akis Komutlari

| Komut | Sozdizimi | Neyi Cozer | Mini Ornek |
|---|---|---|---|
| IF | IF kosul THEN ... END IF | Kosula gore dal secer | IF x>0 THEN PRINT x END IF |
| SELECT CASE | SELECT CASE e ... END SELECT | Coklu kosul dallanmasi | CASE 1, CASE 2 vb. |
| FOR | FOR i=a TO b ... NEXT | Sayac tabanli dongu | FOR i=1 TO 10 |
| DO LOOP | DO ... LOOP | Serbest dongu | DO: i+=1: LOOP UNTIL i=10 |
| EXIT IF | EXIT IF kosul | Blogu erken terk etme | EXIT IF i > n |
| RETURN | RETURN expr | Fonksiyondan cikis | RETURN x+y |

### 7.2 Veri ve Bellek Komutlari

| Komut | Sozdizimi | Aciklama |
|---|---|---|
| DIM | DIM a AS I32 | Degisken/dizi tanimlar |
| REDIM | REDIM [PRESERVE] arr(...) AS T | Dizi boyutunu degistirir |
| CONST | CONST PI = 3.14 | Sabit deger tanimi |
| MEMCOPYD | MEMCOPYD dst, src, n | Dword blok kopyalama |
| MEMFILLB | MEMFILLB dst, val, n | Bellek bolgesini doldurma |

### 7.3 OOP Komutlari

| Komut | Sozdizimi | Aciklama |
|---|---|---|
| TYPE | TYPE T ... END TYPE | Value-type tanimi |
| CLASS | CLASS C ... END CLASS | Nesne sinifi tanimi |
| INTERFACE | INTERFACE I ... END INTERFACE | Davranis sozlesmesi |
| NEW | NEW C(...) | Nesne olusturma |
| DELETE | DELETE obj | Nesne serbest birakma |

### 7.4 Interop Komutlari

| Komut | Sozdizimi | Aciklama |
|---|---|---|
| IMPORT | IMPORT(C/CPP/ASM, "file") | Yerel native dosyayi build planina ekler |
| INLINE | INLINE(a,b,c,policy) ... END INLINE | Native/ABI ve toolchain policy aktarir |
| CALL(DLL) | CALL(DLL,"lib","sym",sig,[conv],...) | Runtime dinamik kutuphane cagrisi |

### 7.5 Komutlar Icin Baslangic Hata Rehberi

| Belirti | Olası Neden | Cozum |
|---|---|---|
| Parse hatasi | Parantez/END blogu eksik | Blog kapatmalarini kontrol et |
| IMPORT fail | Path veya extension uyumsuz | Dil-path uyumunu duzelt |
| INLINE fail | Policy zorunlu alan eksik | ABI/PRESERVE/STACK alanlarini ekle |
| Link fail | Yanlis linker/secim | INLINE policy veya UXB_* env ile duzelt |

## 8. Append-Only Fonksiyon Referansi (Detayli)

### 8.1 Metin Fonksiyonlari

| Fonksiyon | Amac | Ornek |
|---|---|---|
| LEN(s) | Uzunluk | LEN("abc") -> 3 |
| MID(s,p,n) | Alt metin | MID("Merhaba",2,3) -> "erb" |
| UCASE(s) | Buyuk harf | UCASE("abc") -> "ABC" |
| LCASE(s) | Kucuk harf | LCASE("ABC") -> "abc" |
| VAL(s) | String->sayi | VAL("42") -> 42 |

### 8.2 Matematik Fonksiyonlari

| Fonksiyon | Amac | Ornek |
|---|---|---|
| ABS(x) | Mutlak deger | ABS(-7) -> 7 |
| INT(x) | Asagi yuvarlama | INT(4.8) -> 4 |
| SQR(x) | Kok alma | SQR(9) -> 3 |
| SIN(x) | Sinus | SIN(0) -> 0 |
| LOG(x) | Logaritma | LOG(10) |

### 8.3 Pointer/Meta Fonksiyonlari

| Fonksiyon | Amac | Ornek |
|---|---|---|
| VARPTR(x) | Adres alma | p = VARPTR(a) |
| SIZEOF(T) | Tip boyutu | SIZEOF(I32) |
| OFFSETOF(T,f) | Alan offseti | OFFSETOF(MyType, id) |

### 8.4 Fonksiyon Secim Stratejisi (Yeni Baslayanlar Icin)

1. Once basit intrinsics kullanin.
2. Sonra tip donusumlerini netlestirin (`CINT`, `CLNG`, `CDBL`).
3. En son pointer/meta alanina gecin.

## 9. Compilerin Tam Mimari Yapisi ve Artifact Haritasi

Bu bolum, derleyicinin ic yapisini ve urettigi dosyalari operasyonel olarak aciklar.

### 9.1 Ana Pipeline Ayrintisi

1. Kaynak yukleme:
	- Giris dosyasi `src/main.bas` uzerinden alinir.
2. Lexer/preprocess:
	- Token stream olusur, preprocess direktifleri cozulur.
3. Parser:
	- AST node agaci olusur.
4. Semantic:
	- Tip/scope/layout validasyonlari yapilir.
5. Runtime lane:
	- `--execmem` ile AST/MIR interpreter yurutulur.
6. Interop lane:
	- IMPORT/INLINE kaynaklari cozulur, manifest+script uretimi olur.
7. Codegen lane:
	- x64/x86 cagrisi ve asm planlari uretilir.

### 9.2 Katman Bazli Sorumluluk Cizelgesi

| Katman | Girdi | Cikti | Kritik Dosyalar |
|---|---|---|---|
| Lexer | ham kaynak metin | token listesi | src/parser/lexer/* |
| Parser | token listesi | AST | src/parser/parser/* |
| Semantic | AST | anoteli AST/semantic durum | src/semantic/* |
| Runtime | semantic state | calisma sonucu | src/runtime/* |
| Interop | INCLUDE/IMPORT/INLINE | manifest + bat + rsp + makefile | src/build/interop_manifest.fbs |
| Codegen | AST/semantic | asm/ffi artifactlari | src/codegen/x64/*, src/codegen/x86/* |

### 9.3 Interop Artifact Dosyalari (Detay)

Interop modunda tipik artifact seti:

| Artifact | Aciklama |
|---|---|
| import_build_manifest.csv | Include/import ve compile/link satirlari |
| import_link_args.rsp | Link asamasina verilecek object listesi |
| import_link_plan_win11.txt | Derleme/link adimlarinin okunabilir plani |
| build_import.bat | C/CPP/ASM import compile scripti |
| link_command.bat | Link scripti |
| toolchain.env.bat | Derleyici/linker secim ve path profil dosyasi |
| makefile | Imports/link/clean hedefleri |

### 9.4 Toolchain Artifact Modeli

`toolchain.env.bat` icinde su degiskenler yazilir:

- `UXB_CC`, `UXB_CXX`, `UXB_ASM`, `UXB_LINK`
- `UXB_CC_PATH`, `UXB_CXX_PATH`, `UXB_ASM_PATH`, `UXB_LINK_PATH`
- `UXB_CC_CMD`, `UXB_CXX_CMD`, `UXB_ASM_CMD`, `UXB_LINK_CMD`

Bu model sayesinde:

1. Ayni proje icinde farkli makinelerde ayni scriptler calisabilir.
2. `INLINE` policy ile local override uygulanabilir.
3. CI/CD ortaminda `UXB_*` env tanimlariyla profile disaridan mudahale edilir.

### 9.5 Dist Klasoru Uretim Felsefesi

uXBasic'te dist ciktilari, "ne derlendigi" kadar "nasil derlendigi" bilgisini de saklar.

Bu nedenle CSV/plan/bat/makefile artifactlari audit ve tekrar-uretim acisindan kritik kabul edilir.

### 9.6 Mimariyi Okuma Rehberi (Yeni Ekip Uyesi Icin)

Bir gelistirici sisteme ilk girdiginde su sirayla ilerlemelidir:

1. `src/main.bas` ile mode secim akislarini oku.
2. `src/build/interop_manifest.fbs` ile import/inline artifact hattini oku.
3. `src/parser/parser/*` ve `src/semantic/*` ile dil kurallarini takip et.
4. Son adimda runtime/codegen dizinlerine gir.

Bu siralama en az baglam kaybiyla en hizli ogrenme yoludur.
