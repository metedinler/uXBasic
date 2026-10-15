# uXBasic Komut, Fonksiyon, Operatör ve EVENT/THREAD/PIPE/SLOT/PARALEL/SHELL Analizi

## 1. İnceleme kapsamı

Bu rapor, tek parça `01_src.txt` içindeki **505 modül bloğunun** kaynak kodundan çıkarılmıştır. Benzersiz dosya adı sayısı **504** olup `mir.fbs` iki kez paketlenmiştir. Liste yalnız isim taraması değildir; lexer, statement registry, parser, semantic, AST interpreter, MIR lowering/evaluator ve native runtime köprüsü birlikte karşılaştırılmıştır.

## 2. En önemli sonuç

`EVENT`, `THREAD`, `PARALEL`, `PIPE`, `SLOT`, `ON`, `OFF`, `TRIGGER` ve `SHELL` lexer ve parser yüzeyinde gerçektir. EVENT/PIPE/THREAD/PARALEL için AST düğümleri ve MIR slot-lane çağrıları da vardır. Buna karşılık mevcut kodda **gerçek işletim sistemi thread'i, gerçek paralel görev planlayıcısı ve gerçek native pipe backend'i tamamlanmış değildir**. AST ve MIR interpreter çoğunlukla kayıtlı gövdeyi aynı işlem akışında senkron çalıştırmaktadır. `uxb_runtime.dll` için C ABI isimleri tanımlı ve loader mevcut olsa da FreeBASIC bridge fonksiyonları henüz function pointer üzerinden DLL'i çağırmamakta, çoğu yalnız `1` döndüren fallback/stub olarak kalmaktadır.

### Mevcut katman akışı

```text
uXBasic kaynak
  → Lexer
  → Parser / AST
  → Semantic SLOT tablosu
  → AST Interpreter veya MIR Lowering
  → MIR SLOT_DEF / SLOT_BIND / SLOT_ON / SLOT_OFF / TASK_TRIGGER
  → Şimdilik süreç-içi senkron yürütme
  → Hedeflenen fakat henüz tam bağlı olmayan uxb_runtime.dll
```

## 3. EVENT / THREAD / PARALEL / PIPE / SLOT / TRIGGER / SHELL syntax tablosu

| Grup | Komut | Kaynakta kabul edilen syntax | Biçim | Gerçek durum | Ana kaynak |
| --- | --- | --- | --- | --- | --- |
| Görev/olay | EVENT | EVENT Ad [, slot_id]<br>    gövde<br>END EVENT | Blok veya eski tek satırlı bildirim | AST ve MIR yürütücülerde eşzamanlı görev gövdesi; native DLL çağrısı henüz bağlı değil. | parser_stmt_event_pipe.fbs |
| Görev/olay | THREAD | THREAD Ad [, slot_id]<br>    gövde<br>END THREAD | Blok veya eski tek satırlı bildirim | Adı THREAD olsa da mevcut AST/MIR yolu gerçek OS thread başlatmıyor. | parser_stmt_event_pipe.fbs; exec_slot_manager.fbs |
| Görev/olay | PARALEL | PARALEL Ad [, slot_id]<br>    gövde<br>END PARALEL | Blok veya eski tek satırlı bildirim | Kaynakta doğru yazım PARALEL; PARALLEL yok. Gerçek paralel planlayıcı bağlı değil. | parser_stmt_event_pipe.fbs |
| Görev/olay | PIPE | PIPE Ad [girdi_adı [AS Tip]] [, slot_id]<br>    gövde<br>END PIPE | Blok veya eski tek satırlı bildirim | INPUT ve OUTPUT sahte/global değerleri üzerinden veri aktarımı var; native pipe backend stub. | parser_stmt_event_pipe.fbs |
| Görev/olay | SLOT tablosu | SLOT<br>    slotAdı slot_id ON\|OFF [EVENT\|PIPE\|THREAD\|PARALEL] hedef<br>END SLOT | Kanonik bağlama tablosu | slot_id sabit sayısal 0..255; aynı id tekrar edilirse son kayıt baskın. | parser_stmt_event_pipe.fbs; semantic_pass.fbs |
| Görev/olay | SLOT kapasitesi | SLOT EVENT\|PIPE\|THREAD\|PARALEL adet<br>SLOT tür <I8\|U8 adet> | Kapasite bildirimi | Runtime 0..256 aralığını doğruluyor. | parser_stmt_event_pipe.fbs |
| Görev/olay | SLOT eski kontrol | SLOT hedef ON\|OFF | Eski biçim | Parser bu biçimde türü koşulsuz THREAD olarak kaydediyor. | parser_stmt_event_pipe.fbs |
| Görev/olay | ON | ON EVENT\|PIPE\|THREAD\|PARALEL hedef [SLOT slot_id \| SLOT <I8\|U8 slot_id>] | Durum açma | SLOT son eki AST'ye giriyor; yürütme/MIR tarafında tam tüketilmediği izleniyor. | parser_stmt_event_pipe.fbs |
| Görev/olay | OFF | OFF EVENT\|PIPE\|THREAD\|PARALEL hedef [SLOT slot_id \| SLOT <I8\|U8 slot_id>] | Durum kapama | SLOT son eki AST'ye giriyor; yürütme/MIR tarafında tam tüketilmediği izleniyor. | parser_stmt_event_pipe.fbs |
| Görev/olay | TRIGGER | TRIGGER hedef[, veri ...]<br>TRIGGER EVENT\|PIPE\|THREAD\|PARALEL hedef[, veri ...] | Kısa ve açık tür biçimi | Parser çok argüman alıyor; mevcut AST/MIR yolunda yalnız ilk payload'ın kullanıldığı noktalar var. | parser_stmt_event_pipe.fbs; mir_lower_slot_lane.fbs |
| İşletim sistemi | SHELL | SHELL komut [TIMEOUT ms] [RUNPATH yol] [OUTPATH yol] [ERRPATH yol] [OUTVAR ad] [ERRVAR ad] [CODEVAR ad] | Komut çalıştırma | TIMEOUT < 0 beklemeden; TIMEOUT >= 0 bekleyerek çalıştırıyor fakat gerçek süre aşımı kesmesi yok. | parser_stmt_basic.fbs; exec_stmt_io_file.fbs |

### 3.1 Önerilen kanonik kullanım

```basic
EVENT Tick
    PRINT "tick"
END EVENT

THREAD Worker, 0
    ' Şu an gerçek OS thread değil; kayıtlı görev gövdesidir.
    PRINT "worker"
END THREAD

PIPE Normalize inputText AS STRING, 1
    OUTPUT = UCASE(INPUT)
END PIPE

PARALEL Batch, 2
    TRIGGER Worker
END PARALEL

SLOT
    TickSlot 0 ON EVENT Tick
    WorkerSlot 1 ON THREAD Worker
    NormalizeSlot 2 ON PIPE Normalize
END SLOT

TRIGGER Tick
TRIGGER PIPE Normalize, "abc"
```

### 3.2 SHELL kanonik kullanım

```basic
DIM outText AS STRING
DIM errText AS STRING
DIM exitCode AS I32

SHELL "python build.py" TIMEOUT 60000 RUNPATH "tools" OUTVAR outText ERRVAR errText CODEVAR exitCode
```

> Kaynak gerçekliği notu: `TIMEOUT 60000` gerçek 60 saniyelik process timeout'u uygulamaz; yalnız beklemeli yolu seçer.

## 4. Tüm doğrudan statement/komut rotaları ve syntax

| Kategori | Komut | Syntax | Katman durumu | Not | Kaynak |
| --- | --- | --- | --- | --- | --- |
| Temel | PRINT | PRINT [#handle,] [ifade [{","\|";"} ifade ...]] | Parser + AST/MIR/çalıştırıcı | Dosya kanalı ve konsol biçimi var. | parser_stmt_basic.fbs |
| Temel | INLINE | INLINE başlık ... END INLINE | Parser var; ham başlık/gövde saklanıyor | Eski _ASM/ASM_SUB/ASM_FUNCTION biçimleri reddediliyor. | parser_stmt_basic.fbs |
| Temel | CALL | CALL yordam(arg, ...) \| CALL(yordam[, arg, ...]) | Parser + kullanıcı yordamı + FFI yolları | Dotted ad en az bir üye seviyesinde kabul ediliyor. | parser_stmt_basic.fbs |
| Temel | SHELL | SHELL komut_ifadesi [TIMEOUT ifade] [RUNPATH ifade] [OUTPATH ifade] [ERRPATH ifade] [OUTVAR değişken] [ERRVAR değişken] [CODEVAR değişken] | AST çalıştırıcı var; native ABI köprüsü eksik | TIMEOUT süreyi kesmiyor; yalnız beklemeli/beklemesiz yolu seçiyor. | parser_stmt_basic.fbs; exec_stmt_io_file.fbs |
| Akış | IF | IF koşul THEN deyim \| IF koşul THEN ... [ELSEIF koşul THEN ...]* [ELSE ...] END IF | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | SELECT CASE | SELECT CASE ifade ... CASE değer[, ...] \| CASE IS karşılaştırma değer \| CASE ELSE ... END SELECT | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | FOR | FOR değişken = başlangıç TO bitiş [STEP adım] ... NEXT [değişken] | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | FOR EACH | FOR EACH öğe[, indis] IN kaynak[, kaynak2 ...] ... NEXT | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | WHILE | WHILE koşul ... WEND | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | DO | DO [WHILE\|UNTIL koşul] ... LOOP [WHILE\|UNTIL koşul] | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | DO EACH | DO EACH öğe IN kaynak[, ...] ... LOOP | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | GOTO | GOTO etiket | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | GOSUB | GOSUB etiket | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | RETURN | RETURN [ifade] | Parser + yürütme |  | parser_stmt_flow.fbs |
| Akış | EXIT | EXIT [FOR\|DO\|IF] | Parser + yürütme | Desteklenen hedefler parser ile sınırlı. | parser_stmt_flow.fbs |
| Akış | END | END | Parser + yürütme |  | parser_stmt_flow.fbs |
| Hata | TRY | TRY ... [CATCH [ad] ...]* [FINALLY ...] END TRY | Parser + yürütme | En az CATCH veya FINALLY bekleniyor. | parser_stmt_flow.fbs |
| Hata | THROW | THROW ifade | Parser + yürütme |  | parser_stmt_flow.fbs |
| Hata | ASSERT | ASSERT koşul[, ileti] | Parser + yürütme |  | parser_stmt_flow.fbs |
| Bellek/Nesne | DELETE | DELETE ifade | Parser; backend/runtime rotaları var |  | parser_stmt_basic.fbs |
| Bildirim | DIM | DIM ad[(alt_sınır TO üst_sınır \| üst_sınır[, ...])] AS Tip [= başlangıç] [, ...] | Parser + semantic | BIGF/BIGD/BALL tiplerinde hassasiyet parantezi kabul ediliyor. | parser_stmt_decl_dim_redim.fbs |
| Bildirim | REDIM | REDIM [PRESERVE] ad[(sınırlar)] AS Tip [, ...] | Parser + semantic |  | parser_stmt_decl_dim_redim.fbs |
| Bildirim | CONST | CONST ad [AS Tip] = ifade [, ...] | Parser + semantic |  | parser_stmt_decl_core.fbs |
| Bildirim | DECLARE SUB | DECLARE SUB ad [CDECL\|STDCALL] [LIB "dosya"] [ALIAS "sembol"] (parametreler) | Parser + FFI metadata |  | parser_stmt_decl_proc.fbs |
| Bildirim | DECLARE FUNCTION | DECLARE FUNCTION ad [CDECL\|STDCALL] [LIB "dosya"] [ALIAS "sembol"] (parametreler) AS Tip | Parser + FFI metadata |  | parser_stmt_decl_proc.fbs |
| Bildirim | SUB | SUB ad(parametreler) ... END SUB | Parser + kullanıcı yordamı |  | parser_stmt_decl_proc.fbs |
| Bildirim | FUNCTION | FUNCTION ad(parametreler) AS Tip ... END FUNCTION | Parser + kullanıcı yordamı |  | parser_stmt_decl_proc.fbs |
| Bildirim | TYPE | TYPE Ad ... alan[(sınırlar)] AS Tip ... END TYPE | Parser + semantic/layout |  | parser_stmt_decl_core.fbs |
| Bildirim | ENUM | ENUM Ad [AS Tip] ... öğe [= ifade] ... END ENUM | Parser + semantic |  | parser_stmt_decl_core.fbs |
| OOP | CLASS | CLASS Ad [EXTENDS Taban] [IMPLEMENTS Arayüz[, ...]] ... END CLASS | Parser + semantic/AST | ABSTRACT CLASS, FINAL CLASS ve SEALED CLASS önekleri de rotalanıyor. | parser_stmt_decl_class.fbs |
| OOP | INTERFACE | INTERFACE Ad ... METHOD ad(parametreler) [AS Tip] ... END INTERFACE | Parser + semantic |  | parser_stmt_decl_class.fbs |
| OOP | CONSTRUCTOR | CONSTRUCTOR(parametreler) ... END CONSTRUCTOR | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | DESTRUCTOR | DESTRUCTOR [SınıfAdı]() ... END DESTRUCTOR | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | PROPERTY | PROPERTY ad AS Tip [GET] [SET] \| PROPERTY ... GET ... END GET ... SET ... END SET | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | OPERATOR | OPERATOR işleç(parametreler) [AS Tip] ... END OPERATOR | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | METHOD/MAGIC | [VIRTUAL\|OVERRIDE\|STATIC] [MAGIC] METHOD ad(parametreler) [AS Tip] ... END METHOD\|MAGIC | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | FRIEND | FRIEND nitelikli.ad[, ...] | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | MIXIN | MIXIN Sınıf[, ...] | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| OOP | DECORATOR | DECORATOR Ad[(argümanlar)] | Sınıf gövdesi parserı |  | parser_stmt_decl_class.fbs |
| Kapsam | NAMESPACE | NAMESPACE nitelikli.ad ... END NAMESPACE | Parser |  | parser_stmt_decl_scope.fbs |
| Kapsam | MODULE | MODULE nitelikli.ad ... END MODULE | Parser |  | parser_stmt_decl_scope.fbs |
| Kapsam | MAIN | MAIN ... END MAIN | Parser | Global düzey için tasarlanmış. | parser_stmt_decl_scope.fbs |
| Kapsam | USING | USING nitelikli.ad[, ...] | Parser |  | parser_stmt_decl_scope.fbs |
| Kapsam | ALIAS | ALIAS ad = hedef \| ALIAS ad AS hedef | Parser |  | parser_stmt_decl_scope.fbs |
| Önişlem | INCLUDE | INCLUDE "yol" | Parser + preprocessor hattı |  | parser_stmt_decl_core.fbs |
| Önişlem | IMPORT | IMPORT(C\|CPP\|ASM, "yol") | Parser + build/bind planı | DLL/API/LIB için değil; kaynak ekleme biçimi. | parser_stmt_decl_core.fbs |
| Varsayılan tip | DEFINT/DEFLNG/DEFSNG/DEFDBL/DEFEXT/DEFSTR/DEFBYT | DEFxxx ifade[, ifade ...] | Parser |  | parser_stmt_decl_core.fbs |
| String | SETSTRINGSIZE | SETSTRINGSIZE ifade | Parser + runtime rotası |  | parser_stmt_decl_core.fbs |
| Dosya/Girdi | INPUT | INPUT hedef \| INPUT "istem"; hedef[, ...] \| INPUT #handle, hedef[, ...] | Parser + yürütme |  | parser_stmt_io.fbs |
| Dosya/Girdi | INPUTF | INPUTF [#]handle, hedef[, ...] | Statement registry var | Lexer keyword tablosunda bulunmadığından erişilebilirliği şüpheli. | parser_stmt_registry.fbs; lexer_keyword_table.fbs |
| Dosya | OPEN | OPEN dosya_ifadesi FOR kip AS [#]handle [LEN = ifade] | Parser + yürütme | Kip sözcüğü parserda sıkı enum ile doğrulanmıyor. | parser_stmt_io.fbs |
| Dosya | CLOSE | CLOSE [[#]handle[, ...]] | Parser + yürütme |  | parser_stmt_io.fbs |
| Dosya | GET | GET [#]handle, hedef \| GET [#]handle, konum, hedef \| GET [#]handle, konum, uzunluk, hedef | Parser + yürütme |  | parser_stmt_io.fbs |
| Dosya | PUT | PUT [#]handle, kaynak \| PUT [#]handle, konum, kaynak \| PUT [#]handle, konum, uzunluk, kaynak | Parser + yürütme |  | parser_stmt_io.fbs |
| Dosya | SEEK | SEEK [#]handle[, konum] | Parser + yürütme |  | parser_stmt_io.fbs |
| Konsol | LOCATE | LOCATE satır, sütun | Parser + yürütme |  | parser_stmt_io.fbs |
| Konsol | COLOR | COLOR önplan, arkaplan | Parser + yürütme |  | parser_stmt_io.fbs |
| Konsol | CLS | CLS | Parser + yürütme |  | parser_stmt_io.fbs |
| Sayaç | INC | INC değişken | Parser + yürütme |  | parser_stmt_basic.fbs |
| Sayaç | DEC | DEC değişken | Parser + yürütme |  | parser_stmt_basic.fbs |
| Rastgele | RANDOMIZE | RANDOMIZE [tohum] | Parser + yürütme |  | parser_stmt_basic.fbs |
| Bellek | POKE/POKEB/POKEW/POKED | POKE[B\|W\|D] adres, değer | Parser + yürütme/MIR | POKE genel biçimi POKED rotasına indirgeniyor. | parser_stmt_basic.fbs |
| Bellek | POKES | POKES adres, metin | Parser + yürütme/MIR |  | parser_stmt_basic.fbs |
| Bellek | MEMCOPYB/W/D | MEMCOPYB\|MEMCOPYW\|MEMCOPYD hedef, kaynak, adet | Parser + yürütme/MIR |  | parser_stmt_basic.fbs |
| Bellek | MEMFILLB/W/D | MEMFILLB\|MEMFILLW\|MEMFILLD hedef, değer, adet | Parser + yürütme/MIR |  | parser_stmt_basic.fbs |
| Bellek | SETNEWOFFSET | SETNEWOFFSET değişken [,] yeni_adres | Parser + yürütme/MIR | Virgül parserda isteğe bağlı. | parser_stmt_basic.fbs |

## 5. Fonksiyonlar ve çağrı yüzeyleri

| Kategori | Fonksiyon | Syntax | Argüman | Not | Kaynak |
| --- | --- | --- | --- | --- | --- |
| Sayısal | ABS | ABS(x) | 1 | Mutlak değer | parser_shared.fbs; exec_eval_builtin_categories.fbs |
| Sayısal | INT | INT(x) | 1 | Tamsayı dönüşümü/aşağı yuvarlama yürütücü semantiğine bağlı | parser_shared.fbs |
| Sayısal | SGN | SGN(x) | 1 | İşaret | parser_shared.fbs |
| Sayısal | VAL | VAL(metin) | 1 | Metinden sayıya | parser_shared.fbs |
| Sayısal | CINT/CLNG/CDBL/CSNG/FIX | CINT(x) vb. | 1 | Sayısal dönüşümler | parser_shared.fbs |
| Matematik | SQR | SQR(x) | 1 | Karekök; kaynak parserın kabul ettiği ad | parser_shared.fbs |
| Matematik | SQRT | SQRT(x) | — | Lexer yüzeyinde var fakat parser açıkça reddediyor: SQR kullanın. | lexer_keyword_table.fbs; parser_shared.fbs |
| Matematik | SIN/COS/TAN/ATN/EXP/LOG | SIN(x) vb. | 1 | Temel matematik | parser_shared.fbs |
| Rastgele | RND | RND() \| RND(x) | 0..1 | Rastgele sayı | parser_shared.fbs |
| Zaman | TIMER | TIMER() \| TIMER("ns\|us\|ms\|s\|min\|h\|day\|year") \| TIMER(başlangıç, bitiş, "birim") | 0,1,3 | Birim string literal olmalı. | parser_shared.fbs |
| Metin | LEN | LEN(x) | 1 | Uzunluk | parser_shared.fbs |
| Metin | STR | STR(x) | 1 | Metne dönüştürme | parser_shared.fbs |
| Metin | UCASE/LCASE | UCASE(metin) \| LCASE(metin) | 1 | Büyük/küçük harf | parser_shared.fbs |
| Metin | LTRIM/RTRIM | LTRIM(metin) \| RTRIM(metin) | 1 | Kırpma | parser_shared.fbs |
| Metin | TRIM | TRIM(metin) | Yürütücüde | Parser özel arity kontrolü yapmıyor; generic call olarak geçiyor. | memory_exec.fbs |
| Metin | LEFT/RIGHT | LEFT(metin, adet) \| RIGHT(metin, adet) | Yürütücüde | Lexer keyword olmak zorunda değil; generic CALL_EXPR ile çalışabilir. | memory_exec.fbs |
| Metin | MID | MID(metin, başlangıç[, uzunluk]) | 2..3 | Alt metin | parser_shared.fbs |
| Metin | INSTR | INSTR(metin, aranan) [ve yürütücünün kabul ettiği varyantlar] | Yürütücüde | Parser özel arity kontrolü yapmıyor. | exec_eval_builtin_categories.fbs |
| Metin | ASC/CHR | ASC(metin) \| CHR(kod) | 1 | Karakter kodu dönüşümleri | parser_shared.fbs |
| Metin | SPACE | SPACE(adet) | 1 | Boşluk üretir | parser_shared.fbs |
| Metin | STRING | STRING(adet, karakter) | 2 | Tekrarlı karakter/metin | parser_shared.fbs |
| Dosya | LOF | LOF(handle) | 1 | Dosya uzunluğu | parser_shared.fbs |
| Dosya | EOF | EOF(handle) | 1 | Dosya sonu | parser_shared.fbs |
| Klavye | GETKEY | GETKEY() | 0 | Tuş alımı | parser_shared.fbs |
| Klavye | INKEY | INKEY(arg[, arg2]) | 1..2 | Kaynakta sıfır argümanlı INKEY kabul edilmiyor. | parser_shared.fbs |
| Bellek | PEEKB/PEEKW/PEEKD | PEEKB(adres) vb. | 1 | 8/16/32 bit okuma | parser_shared.fbs |
| İşaretçi | VARPTR | VARPTR(değişken) | 1 ident | Değişken adresi | parser_shared.fbs |
| İşaretçi | SADD | SADD(string_literal\|değişken) | 1 | String adresi | parser_shared.fbs |
| İşaretçi | LPTR/CODEPTR | LPTR(etiket) \| CODEPTR(etiket) | 1 ident | Etiket/kod işaretçisi | parser_shared.fbs |
| Yerleşim | SIZEOF | SIZEOF(TipAdı) | 1 tip | Tip boyutu | parser_shared.fbs |
| Yerleşim | OFFSETOF | OFFSETOF(TipAdı, "alan.yolu") | 2 | Alan ofseti | parser_shared.fbs |
| Yerleşim | INSTANCEOF | INSTANCEOF(nesne, TipAdı) | Yürütücüde | Parser özel doğrulaması yok. | exec_eval_builtin_categories.fbs |
| Koleksiyon | LISTLEN | LISTLEN(handle) | 1 | Liste uzunluğu | exec_eval_builtin_categories.fbs |
| Koleksiyon | LISTGET | LISTGET(handle, indis) | 2 | Öğe getirir | exec_eval_builtin_categories.fbs |
| Koleksiyon | LISTSET | LISTSET(handle, indis, değer) | 3 | Öğe değiştirir | exec_eval_builtin_categories.fbs |
| Koleksiyon | LISTADD | LISTADD(handle, değer) | 2 | Öğe ekler | exec_eval_builtin_categories.fbs |
| Koleksiyon | LISTREMOVE | LISTREMOVE(handle, indis) | 2 | Öğe siler | exec_eval_builtin_categories.fbs |
| Koleksiyon | LISTCLEAR | LISTCLEAR(handle) | 1 | Listeyi temizler | exec_eval_builtin_categories.fbs |
| Koleksiyon | DICTLEN | DICTLEN(handle) | 1 | Sözlük uzunluğu | exec_eval_builtin_categories.fbs |
| Koleksiyon | DICTHAS | DICTHAS(handle, anahtar) | 2 | Anahtar var mı | exec_eval_builtin_categories.fbs |
| Koleksiyon | DICTGET | DICTGET(handle, anahtar) | 2 | Değer getirir | exec_eval_builtin_categories.fbs |
| Koleksiyon | DICTSET | DICTSET(handle, anahtar, değer) | 3 | Değer yazar | exec_eval_builtin_categories.fbs |
| Koleksiyon | DICTCLEAR | DICTCLEAR(handle) | 1 | Sözlüğü temizler | exec_eval_builtin_categories.fbs |
| Koleksiyon | SETLEN | SETLEN(handle) | 1 | Küme uzunluğu | exec_eval_builtin_categories.fbs |
| Koleksiyon | SETHAS | SETHAS(handle, anahtar) | 2 | Üyelik testi | exec_eval_builtin_categories.fbs |
| Koleksiyon | SETADD | SETADD(handle, anahtar) | 2 | Üye ekler | exec_eval_builtin_categories.fbs |
| Koleksiyon | SETREMOVE | SETREMOVE(handle, anahtar) | 2 | Üye siler | exec_eval_builtin_categories.fbs |
| Koleksiyon | SETCLEAR | SETCLEAR(handle) | 1 | Kümeyi temizler | exec_eval_builtin_categories.fbs |
| Büyük sayı | BIGINIT/BIGF/BIGD/BALL/BIGI/BIGINT/EXTFP/FP80/FP128 | AD(argümanlar) | Değişken | Mevcut numeric yürütme yolu smoke/fallback düzeyinde; gerçek arbitrary-precision native runtime tamamlanmamış. | memory_exec.fbs |
| FFI | DLL | DLL("kitaplık", "sembol", İMZA[, CDECL\|STDCALL], argümanlar...) | en az 3 temel | Doğrudan FFI çağrı yüzeyi. | exec_eval_builtin_categories.fbs |
| FFI | API | API("kitaplık", "sembol", İMZA, argümanlar...) | en az 3 | Uzantı yoksa .dll ekleniyor. | exec_eval_builtin_categories.fbs |
| FFI | CALL(DLL/API,...) | CALL(DLL, "kitaplık", "sembol", İMZA[, çağrı_kuralı], argümanlar...) | en az 4 | CALL ifadesinin FFI marker biçimi. | exec_eval_builtin_categories.fbs |
| Kullanıcı | Yordam çağrısı | ad(argümanlar...) \| nesne.metot(argümanlar...) | Değişken | Tanımlı FUNCTION/SUB/METHOD veya generic runtime servis rotası. | parser_expr.fbs; memory_exec.fbs |

### 5.1 Generic noktalı runtime çağrıları

Expression parser, adı özel olarak listelenmemiş çağrıları da `CALL_EXPR` olarak kabul eder. Bu nedenle `JSON.PARSE(...)`, `HTTP.GET(...)`, `OS.SYSTEM(...)` gibi noktalı çağrılar parse edilebilir; ancak parse edilmesi çalışacağı anlamına gelmez. Surface/runtime tablolarında görülen başlıca namespace adları şunlardır:

`JSON, REGEX, HTTP, OS, STRINGX, LLAMA, LUA, PROLOG, SQLITE, CURL, CRYPTO, ARCHIVE, IMAGE, AUDIO, MATH, GRAPHICS, SERVER, ONNX, WEBGPU, BROWSER, CANVAS`

Bunların her biri için gerçek runtime servis implementasyonu ayrı doğrulanmalıdır; bu rapor onları yalnız generic çağrı yüzeyi olarak kaydeder.

## 6. Operatörler ve gerçek parser önceliği

| Katman | Operatörler | Syntax | Yaklaşık öncelik | Birleşme | Not |
| --- | --- | --- | --- | --- | --- |
| Postfix/üye | . | a.b \| a.b(args) | 150 | Sol | Alan/metot zinciri |
| Postfix | ++ -- | x++ \| x-- | 150 | Sol | Postfix artır/azalt |
| Üs | ** | a ** b | 140 | Sağ | ^ üs değildir; XOR'a normalize edilir |
| Unary | ++ -- + - @ ! ~ NOT | ++x, -x, !x, ~x, NOT x | 130 | Sağ | ! -> LNOT; ~ ve NOT -> NOT |
| Çarpım | * / \ % MOD | a * b vb. | 120 | Sol |  |
| Toplama | + - | a + b \| a - b | 110 | Sol |  |
| Kaydırma | << >> SHL SHR ROL ROR | a SHL n vb. | 100 | Sol |  |
| İlişki | = == <> != < <= > >= | a == b | 90 | Sol | == -> =, != -> <> |
| Bit | & | a & b | 80 | Sol | Bit düzeyi AND |
| Bit | ^ \| XOR | a ^ b | 79 | Sol | Bu katmanda XOR |
| Bit | \| | a \| b | 78 | Sol | Bit düzeyi OR |
| Mantık | AND && NAND NIMP NCIMP | a AND b | 70 | Sol | && -> AND |
| Mantık | XOR XNOR NXOR EQV EQA IFF | a XNOR b | 60 | Sol | NXOR/EQV/EQA/IFF -> XNOR |
| Mantık | OR \|\| NOR IMP CIMP IDA IDB NOTA NOTB | a OR b | 50 | Sol | \|\| -> OR |
| Boru | \|> | değer \|> işlem | 40 | Sol | PIPE deyiminden ayrı expression operatörü |
| Üçlü | ?: | koşul ? doğru : yanlış | 30 | Sağ |  |
| Atama | += -= *= /= \= %= &= \|= ^= <<= >>= **= =+ =- | hedef += değer | 20 | Sağ | Expression parserda; statement atama rotalarıyla tam eşleşmiyor |
| Atama | = | değişken = değer | deyim | Sağ | İfade içinde ilişki/eşitlik olarak da kullanılıyor; bağlama göre anlam |
| Yapısal | ( ) , : # | çağrı, grup, ayırıcı, kanal | — | — | Operatör tablosundan ayrı düşünülmeli |

### Kritik operatör notları

- `^` üs alma değildir; parser bunu `XOR` olarak normalize eder. Üs alma `**` ile yapılır.
- `==` AST içinde `=` biçimine, `!=` ise `<>` biçimine normalize edilir.
- `=` hem statement ataması hem ilişki/eşitlik yüzeyinde görülür; anlamı parser bağlamına bağlıdır.
- `|>` expression pipeline operatörüdür; `PIPE ... END PIPE` görev bloğundan farklıdır.
- `NXOR`, `EQV`, `EQA`, `IFF` aynı kanonik `XNOR` işlemine indirgenir.
- `ZERO` ve `ONE`, operator sözleşmesinde `FALSE` ve `TRUE` aliası olarak tanımlanmıştır.

## 7. Veri tipleri

| Sınıf | Tipler | Not |
| --- | --- | --- |
| Tamsayı | I8, U8, I16, U16, I32, U32, I64, U64 | Yerleşik |
| Kayan nokta | F32, F64, F80, F128 | F80 için EXTENDED/EXT; F128 için FLOAT128/QUAD aliasları canonicalize ediliyor. |
| Büyük sayı | BIGF, BIGD, BALL, BIGINT | BIGI/BIGINTEGER aliasları; hassasiyet biçimi BIGF(256) vb. parserda kabul ediliyor. |
| Mantık | BOOLEAN | TRUE/FALSE |
| Metin | STRING |  |
| Nesne | OBJECT |  |
| İşaretçi | PTR | POINTER/PTR(...) bazı semantic kontrollerde kabul ediliyor. |
| Koleksiyon | ARRAY, LIST, DICT, SET | Runtime içi koleksiyon handle işlevleri mevcut. |
| Kullanıcı tipi | TYPE/CLASS/ENUM/INTERFACE adları | Bildirilen adlar type validation tablosuna kaydediliyor. |

## 8. Doğrudan statement registry: 79 rota

| # | Rota | Özet syntax |
| ---: | --- | --- |
| 1 | `PRINT` | PRINT [#handle,] ifade [{","\|";"} ifade ...] |
| 2 | `INLINE` | INLINE başlık ... END INLINE |
| 3 | `CALL` | CALL yordam(arg, ...) \| CALL(yordam[, arg, ...]) |
| 4 | `SHELL` | SHELL komut [TIMEOUT ms] [RUNPATH yol] [OUTPATH yol] [ERRPATH yol] [OUTVAR ad] [ERRVAR ad] [CODEVAR ad] |
| 5 | `IF` | IF koşul THEN ... [ELSEIF ...]* [ELSE ...] END IF |
| 6 | `SELECT` | SELECT CASE ifade ... CASE ... END SELECT |
| 7 | `FOR` | FOR değişken = başlangıç TO bitiş [STEP adım] ... NEXT \| FOR EACH ... NEXT |
| 8 | `WHILE` | WHILE koşul ... WEND |
| 9 | `DO` | DO [WHILE\|UNTIL koşul] ... LOOP [WHILE\|UNTIL koşul] \| DO EACH ... LOOP |
| 10 | `GOTO` | GOTO etiket |
| 11 | `GOSUB` | GOSUB etiket |
| 12 | `RETURN` | RETURN [ifade] |
| 13 | `EXIT` | EXIT [FOR\|DO\|IF] |
| 14 | `END` | END |
| 15 | `TRY` | TRY ... [CATCH [ad] ...]* [FINALLY ...] END TRY |
| 16 | `THROW` | THROW ifade |
| 17 | `ASSERT` | ASSERT koşul[, ileti] |
| 18 | `DELETE` | DELETE ifade |
| 19 | `DECLARE` | DECLARE SUB\|FUNCTION ad [CDECL\|STDCALL] [LIB "dosya"] [ALIAS "sembol"] (...) [AS Tip] |
| 20 | `SUB` | SUB ad(parametreler) ... END SUB |
| 21 | `FUNCTION` | FUNCTION ad(parametreler) AS Tip ... END FUNCTION |
| 22 | `CONST` | CONST ad [AS Tip] = ifade [, ...] |
| 23 | `DIM` | DIM ad[(sınırlar)] AS Tip [= başlangıç] [, ...] |
| 24 | `REDIM` | REDIM [PRESERVE] ad[(sınırlar)] AS Tip [, ...] |
| 25 | `TYPE` | TYPE Ad ... END TYPE |
| 26 | `CLASS` | CLASS Ad [EXTENDS ...] [IMPLEMENTS ...] ... END CLASS |
| 27 | `ABSTRACT` | ABSTRACT CLASS Ad ... END CLASS |
| 28 | `FINAL` | FINAL CLASS Ad ... END CLASS |
| 29 | `SEALED` | SEALED CLASS Ad ... END CLASS |
| 30 | `INTERFACE` | INTERFACE Ad ... END INTERFACE |
| 31 | `ENUM` | ENUM Ad [AS Tip] ... END ENUM |
| 32 | `NAMESPACE` | NAMESPACE ad ... END NAMESPACE |
| 33 | `MODULE` | MODULE ad ... END MODULE |
| 34 | `MAIN` | MAIN ... END MAIN |
| 35 | `USING` | USING nitelikli.ad[, ...] |
| 36 | `ALIAS` | ALIAS ad = hedef \| ALIAS ad AS hedef |
| 37 | `DEFINT` | DEFINT ifade[, ...] |
| 38 | `DEFLNG` | DEFLNG ifade[, ...] |
| 39 | `DEFSNG` | DEFSNG ifade[, ...] |
| 40 | `DEFDBL` | DEFDBL ifade[, ...] |
| 41 | `DEFEXT` | DEFEXT ifade[, ...] |
| 42 | `DEFSTR` | DEFSTR ifade[, ...] |
| 43 | `DEFBYT` | DEFBYT ifade[, ...] |
| 44 | `SETSTRINGSIZE` | SETSTRINGSIZE ifade |
| 45 | `INCLUDE` | INCLUDE "yol" |
| 46 | `IMPORT` | IMPORT(C\|CPP\|ASM, "yol") |
| 47 | `INPUT` | INPUT hedef \| INPUT "istem"; hedef[, ...] \| INPUT #handle, hedef[, ...] |
| 48 | `INPUTF` | INPUTF [#]handle, hedef[, ...] |
| 49 | `OPEN` | OPEN dosya FOR kip AS [#]handle [LEN = ifade] |
| 50 | `CLOSE` | CLOSE [[#]handle[, ...]] |
| 51 | `GET` | GET [#]handle, [konum, [uzunluk,]] hedef |
| 52 | `PUT` | PUT [#]handle, [konum, [uzunluk,]] kaynak |
| 53 | `SEEK` | SEEK [#]handle[, konum] |
| 54 | `LOCATE` | LOCATE satır, sütun |
| 55 | `COLOR` | COLOR önplan, arkaplan |
| 56 | `CLS` | CLS |
| 57 | `INC` | INC değişken |
| 58 | `DEC` | DEC değişken |
| 59 | `RANDOMIZE` | RANDOMIZE [tohum] |
| 60 | `POKEB` | POKEB adres, değer |
| 61 | `POKEW` | POKEW adres, değer |
| 62 | `POKED` | POKED adres, değer |
| 63 | `POKE` | POKE adres, değer |
| 64 | `MEMCOPYB` | MEMCOPYB hedef, kaynak, adet |
| 65 | `MEMFILLB` | MEMFILLB hedef, değer, adet |
| 66 | `POKES` | POKES adres, metin |
| 67 | `MEMCOPYW` | MEMCOPYW hedef, kaynak, adet |
| 68 | `MEMCOPYD` | MEMCOPYD hedef, kaynak, adet |
| 69 | `MEMFILLW` | MEMFILLW hedef, değer, adet |
| 70 | `MEMFILLD` | MEMFILLD hedef, değer, adet |
| 71 | `SETNEWOFFSET` | SETNEWOFFSET değişken [,] yeni_adres |
| 72 | `EVENT` | EVENT Ad [, slot_id] ... END EVENT |
| 73 | `THREAD` | THREAD Ad [, slot_id] ... END THREAD |
| 74 | `PARALEL` | PARALEL Ad [, slot_id] ... END PARALEL |
| 75 | `PIPE` | PIPE Ad [girdi [AS Tip]] [, slot_id] ... END PIPE |
| 76 | `SLOT` | SLOT ... END SLOT \| SLOT tür adet \| SLOT hedef ON\|OFF |
| 77 | `ON` | ON EVENT\|PIPE\|THREAD\|PARALEL hedef [SLOT slot_id] |
| 78 | `OFF` | OFF EVENT\|PIPE\|THREAD\|PARALEL hedef [SLOT slot_id] |
| 79 | `TRIGGER` | TRIGGER [EVENT\|PIPE\|THREAD\|PARALEL] hedef[, veri ...] |

## 9. Lexer yüzeyi

Lexer tablosunda **221 kayıt ve 220 benzersiz anahtar sözcük** vardır. Tekrar eden kayıt `STRING` sözcüğüdür. Statement registry ise **79 doğrudan statement rotası** tanımlar. Lexer anahtar sözcüğü olmak, komutun bütün backendlerde çalıştığı anlamına gelmez.

### Benzersiz lexer anahtar sözcükleri

`IF, THEN, ELSE, ELSEIF, END, SELECT, CASE, IS, TRY, CATCH, FINALLY, THROW`

`ASSERT, EVENT, THREAD, PARALEL, PIPE, SLOT, ON, OFF, TRIGGER, FOR, TO, STEP`

`NEXT, DO, LOOP, WHILE, WEND, UNTIL, EXIT, EACH, IN, SUB, FUNCTION, DECLARE`

`RETURN, GOTO, GOSUB, CALL, TYPE, CLASS, INTERFACE, ENUM, IMPLEMENTS, METHOD, MAGIC, VIRTUAL`

`OVERRIDE, CONSTRUCTOR, DESTRUCTOR, NEW, DELETE, DIM, REDIM, AS, CONST, INCLUDE, IMPORT, ABSTRACT`

`FINAL, SEALED, STATIC, PROPERTY, OPERATOR, MIXIN, DECORATOR, PUBLIC, PRIVATE, PROTECTED, RESTRICTED, FRIEND`

`READONLY, MUTABLE, IMMUTABLE, MAIN, NAMESPACE, MODULE, USING, ALIAS, DEFINT, DEFLNG, DEFSNG, DEFDBL`

`DEFEXT, DEFSTR, DEFBYT, PRINT, INPUT, OPEN, CLOSE, GET, PUT, SEEK, CLS, COLOR`

`LOCATE, AND, OR, NOT, XOR, MOD, SHL, SHR, ROL, ROR, NAND, NOR`

`XNOR, NXOR, EQV, EQA, IFF, IMP, CIMP, NIMP, NCIMP, IDA, IDB, NOTA`

`NOTB, INLINE, SHELL, TIMEOUT, OUTVAR, ERRVAR, CODEVAR, RUNPATH, OUTPATH, ERRPATH, I8, U8`

`I16, U16, I32, U32, I64, U64, F32, F64, F80, F128, BIGF, BIGD`

`BALL, BOOLEAN, STRING, OBJECT, PTR, STRPTR, BYREF, BYVAL, CDECL, STDCALL, TRUE, FALSE`

`ZERO, ONE, ARRAY, LIST, DICT, SET, SETSTRINGSIZE, TIMER, LOF, EOF, LEN, MID`

`STR, VAL, ABS, INT, UCASE, LCASE, ASC, CHR, LTRIM, RTRIM, SPACE, SGN`

`SQRT, SIN, COS, TAN, ATN, EXP, LOG, INKEY, GETKEY, VARPTR, SADD, LPTR`

`CODEPTR, SIZEOF, OFFSETOF, CINT, CLNG, CDBL, CSNG, FIX, SQR, RND, RANDOMIZE, PEEKB`

`PEEKW, PEEKD, POKE, POKEB, POKEW, POKED, POKES, MEMCOPYB, MEMCOPYW, MEMCOPYD, MEMFILLB, MEMFILLW`

`MEMFILLD, SETNEWOFFSET, INC, DEC`

## 10. Kaynaktan bulunan eksik ve çelişkiler

| Önem | Sorun | Kanıt/etki |
| --- | --- | --- |
| KRİTİK | THREAD ve PARALEL gerçek eşzamanlılık sağlamıyor | AST ve MIR yürütücüler görev gövdesini aynı akış içinde senkron çağırıyor; uxb_thread_start ve uxb_parallel_run köprüleri yalnız başarı döndüren stub. |
| KRİTİK | Native runtime ABI bağlı değil | uxb_runtime_loader sembolleri çözüyor; bridge açıklaması function-pointer invocation'ın sonraki adım olduğunu söylüyor. |
| KRİTİK | ABI başarı kodu çelişkisi | ABI üst açıklaması 1=başarı derken UXB_RT_OK sabiti 0; bridge fonksiyonları çoğunlukla 1 döndürüyor. |
| YÜKSEK | PIPE native backend stub | uxb_pipe_run boş çıktı üretip başarı dönüyor; gerçek pipe/queue/kanal yok. |
| YÜKSEK | TRIGGER çoklu payload kaybı | Parser birden fazla argümanı kabul ediyor; AST/MIR yollarında yalnız ilk payload'ın kullanıldığı rotalar var. |
| YÜKSEK | ON/OFF SLOT son eki yarım bağlı | Parser slot id düğümünü üretiyor; çalıştırıcı/MIR kontrol rotaları bu ikinci çocuğu düzenli biçimde tüketmiyor. |
| YÜKSEK | SHELL TIMEOUT gerçek timeout değil | Negatif değer nowait; sıfır/pozitif değer normal Shell çağrısı. Süre dolunca process sonlandırma veya timeout hata kodu yok. |
| ORTA | SLOT hedef ON/OFF eski biçimi THREAD'e sabitlenmiş | SLOT Worker ON parserı typeName değerini daima THREAD yapıyor. |
| ORTA | SQRT kayıtlı fakat kullanılamıyor | Lexer/surface içinde SQRT var; parser bilinçli olarak reddedip SQR istiyor. |
| ORTA | INPUTF registry/lexer uyumsuzluğu | Statement registry INPUTF içeriyor fakat lexer keyword listesinde görünmüyor; statement dispatch'e ulaşması güvenilir değil. |
| ORTA | Operator sözleşmesi ile parser farklı | **= operator contract/expression parserda var; identifier statement extended assignment rotasında eksik. |
| ORTA | Dizi [] yüzeyi şüpheli | Surface registry [] öğelerini tanıyor; expression parserın postfix kısmında [] indeksleme yolu görünmüyor. |
| DÜŞÜK | Yüzey kayıtlarında tekrarlar | PARALEL, THREAD, MAGIC gibi bazı kayıtlar generated surface listelerinde yineleniyor; mir.fbs paket içinde iki kez bulunuyor. |

## 11. Uygulama durumu matrisi

| Yüzey | Lexer | Parser | Semantic | AST interpreter | MIR lowering | MIR evaluator | Native runtime |
| --- | --- | --- | --- | --- | --- | --- | --- |
| EVENT | Var | Var | Var | Senkron | Var | Senkron | ABI adı var; bridge stub |
| THREAD | Var | Var | Var | Senkron görev | Var | Senkron görev | uxb_thread_start stub |
| PARALEL | Var | Var | Var | Senkron görev | Var | Senkron görev | uxb_parallel_run stub |
| PIPE | Var | Var | Var | INPUT/OUTPUT ile süreç içi | Var | Süreç içi | uxb_pipe_run boş çıktı stub |
| SLOT | Var | Var | 0..255 doğrulaması | 256 kayıtlı tablo | SLOT_DEF/BIND/CAP | MIR tablo | Bind ABI adı var; bridge stub |
| ON/OFF | Var | Var | Var | Var | SLOT_ON/OFF | Var | ABI adı var; bridge stub |
| TRIGGER | Var | Var | Hedef doğrulaması | Gövdeyi çağırır | TASK_TRIGGER | Gövdeyi çağırır | ABI adı var; bridge stub |
| SHELL | Var | Var | Sınırlı | FreeBASIC Shell | SHELL runtime çağrısı | Kısmi | uxb_shell_run fallback; capture/timeout ABI bağlı değil |

## 12. Sonuç

Dil yüzeyi geniş ve parser tarafında hedef komutların tamamı mevcuttur. Fakat `THREAD`, `PARALEL` ve `PIPE` için isimlerin varlığı gerçek eşzamanlılık/kanal altyapısının tamamlandığını göstermemektedir. Üretim seviyesine geçişte birinci öncelik `uxb_runtime_bridge.fbs` içindeki wrapper'ları loader tarafından çözülen gerçek C ABI function pointer'larına bağlamak; ikinci öncelik başarı kodu sözleşmesini tekleştirmek; üçüncü öncelik TRIGGER payload, ON/OFF SLOT id ve SHELL timeout semantiğini AST–MIR–native katmanlarında aynılaştırmaktır.