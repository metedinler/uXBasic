# uXBasic Teknik El Kitabi
# PEK3.MD

Surum Tarihi: 9 Nisan 2026
Hedef Profil: Windows 11 x64
Belge Sinifi: Ana Referans Dokuman

---

## Icindekiler

1. Onsoz
2. Tesekkur
3. Belgenin Kapsami ve Sozlesmesi
4. Dogrulama Hiyerarsisi ve Celiski Cozum Protokolu
5. Dilin Temelleri (Kisa, Tekil, Normatif)
6. Parser-Semantik-Runtime Uyum Matrisi
7. Komut ve Fonksiyon Tablolari
8. Mimari Harita (Lexer-Parser-Semantik-Runtime-Build)
9. Modul Sorumluluklari ve Ana Veri Yapilari
10. Derleme ve Test Akisi
11. Bilimsel Elestiri: Sinirlar, Riskler, Yanlis Anlamaya Acik Alanlar
12. Sonuc ve Sonraki Adimlar

---

## 1. Onsoz

Bu belge, daginik anlatimlari tek bir teknik omurgada birlestirmek icin yazildi.

Amac yalnizca uzun metin uretmek degil; su uc ihtiyaci ayni anda karsilamaktir:
- Hiyerarsi: Okuyucu once neyin kural, neyin yorum, neyin plan oldugunu net gorecek.
- Dogrulama: Her iddia kod, test veya plan kaynagiyla izlenebilir olacak.
- Tutarlilik: Parser, semantik ve runtime aciklamalari birbiriyle celismeyecek.

Bu nedenle bu belge bir "metin toplami" degil, bir "teknik karar sistemi" olarak tasarlandi.

---

## 2. Tesekkur

Bu dokumanin sert ve net sekilde iyilesmesini zorlayan geri bildirim icin tesekkur ederim.

Teknik kaliteyi yukselten sey, ovgu degil dogru elestiridir. Bu belge, o elestiriyi uygulamaya ceviren bir sonuc urunudur.

---

## 3. Belgenin Kapsami ve Sozlesmesi

Bu belge su sorulari tek yerden cevaplar:
- Hangi komut parser tarafinda kesin destekli?
- Hangi kurallar semantik dogrulama seviyesinde aktif?
- Hangi davranis runtime tarafinda gercekten calisiyor?
- Hangi basliklar sadece plan asamasinda?

Durum etiketleri:
- IMPLEMENTED-PARSER: Sozdizimi kabul + AST uretimi aktif.
- IMPLEMENTED-SEMANTIC: Arity/tip/kural denetimi aktif.
- IMPLEMENTED-RUNTIME: Calisma zamani davranisi aktif.
- PARTIAL: Parsel olarak var, tam degil.
- PLANNED: Yol haritasinda, aktif degil.

---

## 4. Dogrulama Hiyerarsisi ve Celiski Cozum Protokolu

### 4.1 Kaynak Oncelik Sirasi (Yuksekten Dusege)

1. Kod gercegi:
   - src/parser/lexer/*
   - src/parser/parser/*
   - src/runtime/*
   - src/build/interop_manifest.fbs
2. Test gercegi:
   - tests/manifest.csv
   - tests/run_manifest.bas
   - tests/plan/command_compatibility_win11.csv
   - tests/plan/cmp_interop_win11.csv
3. Dil sozlesmesi:
   - spec/LANGUAGE_CONTRACT.md
4. Is plani ve kuyruk:
   - WORK_QUEUE.md
5. Tarihsel anlatimlar:
   - ProgramcininElKitabi.md
   - ProgramcininElKitabi.standardized.md

### 4.2 Celiski Cozum Kurali

Eger iki kaynak celisirse su uygulanir:
- Kod + test, metin dokumandan ustundur.
- Semantik ve runtime iddiasi, test veya kodla gosterilemiyorsa "PLANNED" ya da "PARTIAL" etiketlenir.
- Ayni komut birden fazla satirda tekrar etmeyecek sekilde tek satira normalize edilir.

### 4.3 Bilimsel Duru

Bu belge su ilkelere baglidir:
- Durustluk: Bilinmeyeni biliyormus gibi yazmamak.
- Yanlislanabilirlik: Her iddianin kontrol edilebilir olmasi.
- Tekrarlanabilirlik: Baska bir gelistiricinin ayni sonuca ulasabilmesi.

---

## 5. Dilin Temelleri (Kisa, Tekil, Normatif)

### 5.1 Identifier Kurali

- Baslangic: harf veya _
- Devam: harf, rakam, _
- Sonekli tip adlari (x$, n%) strict profilde kabul edilmez.

### 5.2 Tip Kurali

- Acik tip bildirim modeli kullanilir: AS TYPE
- Builtin tip keyword seti: I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 BOOLEAN STRING ARRAY LIST DICT SET

### 5.3 Program Iskeleti

Normatif sira:
1. Baslik ve derleme direktifleri
2. INCLUDE / IMPORT
3. CONST
4. TYPE
5. DECLARE
6. Ana govde
7. SUB/FUNCTION bloklari

### 5.4 Inline Kurali

- Eski formlar (_ASM, ASM_SUB, ASM_FUNCTION) kapali.
- Yeni form: INLINE(...) ... END INLINE

### 5.5 Path ve Guvenlik Kurali

- INCLUDE yalniz .bas uzantisiyla kabul edilir.
- IMPORT yalniz C/CPP/ASM + uygun uzanti ile kabul edilir.
- Path root disina tasamaz.

---

## 6. Parser-Semantik-Runtime Uyum Matrisi

Bu bolumun amaci tek bakista ayrim yapmaktir.

| Katman | Ne Yapar | Ne Yapmaz |
| --- | --- | --- |
| Parser | Komutu tanir, syntax kontrol eder, AST uretir | Is kurali ve calisma davranisini tek basina garanti etmez |
| Semantik | Arity, tip, keyword kurali, path hijyeni gibi anlamsal denetimleri yapar | Programin tumunu calistirmaz |
| Runtime | Gercek calisma zamani etkisini olusturur | Parser kapsami olmayan komutu calistiramaz |

Ana tespit:
- Projede parser kapsami runtime kapsamini gecmistir.
- "Parse oluyor" ile "runtime tam calisiyor" ayni sey degildir.

---

## 7. Komut ve Fonksiyon Tablolari

Not:
- Bu tablolar tekrar etmeyecek sekilde tekillestirildi.
- GET/PUT gibi cok satirli eski anlatimlar tek satirda normalize edildi.
- Runtime kolonu acikca uc seviyeye ayrildi: Var / Sinirli / Yok-Planli.

### 7.1 Program ve Bildirim Komutlari

| Komut | Durum | Parser (Sozdizimi) | Semantik (Anlam) | Runtime (Calisma Zamani) | Ornek |
| --- | --- | --- | --- | --- | --- |
| PRINT | IMPLEMENTED-PARSER | PRINT expr [, ; expr] | Ifade listesi parse edilir | Yok-Planli (genel interpreter) | PRINT 1 + 2 |
| CONST | IMPLEMENTED-PARSER | CONST a = expr [, b = expr] | Ad + deger ifadesi zorunlu | Yok-Planli | CONST PI = 3 |
| DIM | IMPLEMENTED-PARSER | DIM name[(bounds)] AS TYPE [= expr] | TYPE tokeni dogrulanir | Yok-Planli | DIM x AS I32 = 0 |
| REDIM | IMPLEMENTED-PARSER | REDIM name(bounds) AS TYPE | Bounds + TYPE zorunlu | Yok-Planli | REDIM arr(0 TO 9) AS I32 |
| TYPE | IMPLEMENTED-PARSER | TYPE Name ... END TYPE | Alanlarda AS TYPE zorunlu, type kaydi tutulur | Yok-Planli | TYPE V : x AS I32 : END TYPE |
| DECLARE | IMPLEMENTED-PARSER | DECLARE SUB/FUNCTION ... | Imza + FUNCTION donus tipi denetlenir | Yok-Planli | DECLARE FUNCTION F() AS I32 |
| SUB | IMPLEMENTED-PARSER | SUB ... END SUB | Parametreler semantik olarak toplanir | Yok-Planli | SUB P(): PRINT 1: END SUB |
| FUNCTION | IMPLEMENTED-PARSER | FUNCTION ... AS TYPE ... END FUNCTION | Donus tipi zorunlu | Yok-Planli | FUNCTION F() AS I32: RETURN 1: END FUNCTION |
| DEFINT | IMPLEMENTED-PARSER | DEFINT rangeList | Range expr parse edilir | Yok-Planli | DEFINT A-Z |
| DEFLNG | IMPLEMENTED-PARSER | DEFLNG rangeList | Range expr parse edilir | Yok-Planli | DEFLNG I-N |
| DEFSNG | IMPLEMENTED-PARSER | DEFSNG rangeList | Range expr parse edilir | Yok-Planli | DEFSNG S-T |
| DEFDBL | IMPLEMENTED-PARSER | DEFDBL rangeList | Range expr parse edilir | Yok-Planli | DEFDBL D-F |
| DEFEXT | IMPLEMENTED-PARSER | DEFEXT rangeList | Range expr parse edilir | Yok-Planli | DEFEXT X-Z |
| DEFSTR | IMPLEMENTED-PARSER | DEFSTR rangeList | Range expr parse edilir | Yok-Planli | DEFSTR A-C |
| DEFBYT | IMPLEMENTED-PARSER | DEFBYT rangeList | Range expr parse edilir | Yok-Planli | DEFBYT B-D |
| SETSTRINGSIZE | IMPLEMENTED-PARSER | SETSTRINGSIZE expr | Expr zorunlu | Yok-Planli | SETSTRINGSIZE 256 |
| INCLUDE | IMPLEMENTED-PARSER | INCLUDE "file.bas" | Path hijyen + uzanti kontrolu | IMPLEMENTED-RUNTIME (resolver/build) | INCLUDE "lib.bas" |
| IMPORT | IMPLEMENTED-PARSER | IMPORT(LANG, "file") | LANG + uzanti + path kontrolu | IMPLEMENTED-RUNTIME (build artifact) | IMPORT(C, "mod.c") |
| INLINE | PARTIAL | INLINE(...) ... END INLINE | Legacy inline adlari reddedilir | PARTIAL (x64 backend planli) | INLINE("x64","n","sub","") ... END INLINE |

### 7.2 Kontrol Akisi Komutlari

| Komut | Durum | Parser (Sozdizimi) | Semantik (Anlam) | Runtime (Calisma Zamani) | Ornek |
| --- | --- | --- | --- | --- | --- |
| IF | IMPLEMENTED-PARSER | IF ... THEN ... [ELSEIF/ELSE] END IF | Blok kapanisi zorunlu | Yok-Planli | IF x>0 THEN PRINT x END IF |
| SELECT | IMPLEMENTED-PARSER | SELECT CASE ... CASE ... END SELECT | CASE/END SELECT tutarliligi | Yok-Planli | SELECT CASE m: CASE 1: PRINT 1: END SELECT |
| FOR | IMPLEMENTED-PARSER | FOR i = a TO b [STEP s] ... NEXT [i] | STEP yoksa 1 uretilir | Yok-Planli | FOR i=1 TO 3: PRINT i: NEXT |
| DO | IMPLEMENTED-PARSER | DO [WHILE/UNTIL] ... LOOP [WHILE/UNTIL] | Loop mod op alanina yazilir | Yok-Planli | DO WHILE x<3: x+=1: LOOP |
| GOTO | IMPLEMENTED-PARSER | GOTO labelOrNumber | Hedef token tip kontrolu | Yok-Planli | GOTO 100 |
| GOSUB | IMPLEMENTED-PARSER | GOSUB labelOrNumber | Hedef token tip kontrolu | Yok-Planli | GOSUB Worker |
| RETURN | IMPLEMENTED-PARSER | RETURN [expr] | Expr opsiyonel | Yok-Planli | RETURN 1 |
| EXIT | IMPLEMENTED-PARSER | EXIT [FOR|DO] | FOR/DO disi kullanim reddedilir | Yok-Planli | EXIT DO |
| END | IMPLEMENTED-PARSER | END | Arguman kabul etmez | Yok-Planli | END |

### 7.3 Dosya, Giris ve Ekran Komutlari

| Komut | Durum | Parser (Sozdizimi) | Semantik (Anlam) | Runtime (Calisma Zamani) | Ornek |
| --- | --- | --- | --- | --- | --- |
| OPEN | IMPLEMENTED-PARSER | OPEN file FOR mode AS [#]handle | FOR, AS, handle zorunlu | Yok-Planli | OPEN "a.txt" FOR INPUT AS #1 |
| CLOSE | IMPLEMENTED-PARSER | CLOSE [#]h[,#] | Bos veya coklu handle kabul | Yok-Planli | CLOSE #1 |
| GET | IMPLEMENTED-PARSER | GET [#]h, arg1 [,arg2 [,arg3]] | Handle sonrasi 1..3 arg zorunlu | Yok-Planli | GET #1, 10, 2, x |
| PUT | IMPLEMENTED-PARSER | PUT [#]h, arg1 [,arg2 [,arg3]] | Handle sonrasi 1..3 arg zorunlu | Yok-Planli | PUT #1, 10, 2, x |
| SEEK | IMPLEMENTED-PARSER | SEEK [#]h [,pos] | Pos opsiyonel | Yok-Planli | SEEK #1, 10 |
| INPUT | IMPLEMENTED-PARSER | INPUT target[,target] veya prompt + target | Prompt ve target ayrimi yapilir | Yok-Planli | INPUT "Ad?"; ad |
| INPUT# | IMPLEMENTED-PARSER | INPUT #h, target[,target] | Handle + virgul + target zorunlu | Yok-Planli | INPUT #1, x |
| LOF | IMPLEMENTED-SEMANTIC | LOF(expr) | Tam 1 arg | Yok-Planli | x = LOF(1) |
| EOF | IMPLEMENTED-SEMANTIC | EOF(expr) | Tam 1 arg | Yok-Planli | e = EOF(1) |
| LOCATE | IMPLEMENTED-PARSER | LOCATE row,col | 2 arg zorunlu | Yok-Planli | LOCATE 5,10 |
| COLOR | IMPLEMENTED-PARSER | COLOR fg,bg | 2 arg zorunlu | Yok-Planli | COLOR 2,0 |
| CLS | IMPLEMENTED-PARSER | CLS | Arguman kabul etmez | Yok-Planli | CLS |
| FILE_IO_ADVANCED | PLANNED | OPEN/GET/PUT/SEEK ileri modlar | Record/binary semantik standardizasyonu bekliyor | PLANNED | (plan) |

### 7.4 Bellek Komutlari

| Komut | Durum | Parser (Sozdizimi) | Semantik (Anlam) | Runtime (Calisma Zamani) | Ornek |
| --- | --- | --- | --- | --- | --- |
| POKEB | IMPLEMENTED-RUNTIME | POKEB addr,val | 2 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec+vm) | POKEB 4096,255 |
| POKEW | IMPLEMENTED-RUNTIME | POKEW addr,val | 2 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec+vm) | POKEW 4096,4660 |
| POKED | IMPLEMENTED-RUNTIME | POKED addr,val | 2 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec+vm) | POKED 4096,305419896 |
| POKE | IMPLEMENTED-RUNTIME | POKE addr,val | Legacy alias, POKED semantik map | IMPLEMENTED-RUNTIME (POKED yolu) | POKE 4096,10 |
| MEMCOPYB | IMPLEMENTED-RUNTIME | MEMCOPYB src,dst,n | 3 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec+vm) | MEMCOPYB 1000,2000,16 |
| MEMFILLB | IMPLEMENTED-RUNTIME | MEMFILLB addr,val,n | 3 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec+vm) | MEMFILLB 2000,7,64 |
| INC | IMPLEMENTED-RUNTIME | INC ident | ident zorunlu | IMPLEMENTED-RUNTIME (memory_exec) | INC sayac |
| DEC | IMPLEMENTED-RUNTIME | DEC ident | ident zorunlu | IMPLEMENTED-RUNTIME (memory_exec) | DEC sayac |
| PEEKB | IMPLEMENTED-RUNTIME | PEEKB(addr) | 1 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec eval) | x = PEEKB(4096) |
| PEEKW | IMPLEMENTED-RUNTIME | PEEKW(addr) | 1 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec eval) | x = PEEKW(4096) |
| PEEKD | IMPLEMENTED-RUNTIME | PEEKD(addr) | 1 arg zorunlu | IMPLEMENTED-RUNTIME (memory_exec eval) | x = PEEKD(4096) |
| POKES | PLANNED | POKES addr,text | Tasarim bekliyor | PLANNED | (plan) |
| MEMCOPYW | PLANNED | MEMCOPYW src,dst,n | Tasarim bekliyor | PLANNED | (plan) |
| MEMCOPYD | PLANNED | MEMCOPYD src,dst,n | Tasarim bekliyor | PLANNED | (plan) |
| MEMFILLW | PLANNED | MEMFILLW addr,val,n | Tasarim bekliyor | PLANNED | (plan) |
| MEMFILLD | PLANNED | MEMFILLD addr,val,n | Tasarim bekliyor | PLANNED | (plan) |
| SETNEWOFFSET | PLANNED | SETNEWOFFSET var,newaddr | Tasarim bekliyor | PLANNED | (plan) |

### 7.5 Intrinsic Fonksiyonlar (String, Math, Cast, Time)

Not:
- Asagidaki fonksiyonlar parserda CALL_EXPR olarak parse edilir.
- Semantikte arity kontrolu aktif.
- Runtime kolonu, mevcut repoda genel evaluator olmadigi icin "Yok-Planli" veya "Var" olarak ayrildi.

| Fonksiyon | Durum | Parser (Sozdizimi) | Semantik (Anlam) | Runtime (Calisma Zamani) | Ornek |
| --- | --- | --- | --- | --- | --- |
| LEN | IMPLEMENTED-SEMANTIC | LEN(expr) | Tam 1 arg | Yok-Planli | n = LEN("abc") |
| MID | IMPLEMENTED-SEMANTIC | MID(str,start[,len]) | 2..3 arg | Yok-Planli | s = MID("abcd",2,2) |
| STR | IMPLEMENTED-SEMANTIC | STR(expr) | Tam 1 arg | Yok-Planli | s = STR(10) |
| VAL | IMPLEMENTED-SEMANTIC | VAL(expr) | Tam 1 arg | Yok-Planli | x = VAL("10") |
| ABS | IMPLEMENTED-SEMANTIC | ABS(expr) | Tam 1 arg | Yok-Planli | x = ABS(-5) |
| INT | IMPLEMENTED-SEMANTIC | INT(expr) | Tam 1 arg | Yok-Planli | x = INT(3.7) |
| UCASE | IMPLEMENTED-SEMANTIC | UCASE(expr) | Tam 1 arg | Yok-Planli | s = UCASE("ab") |
| LCASE | IMPLEMENTED-SEMANTIC | LCASE(expr) | Tam 1 arg | Yok-Planli | s = LCASE("AB") |
| ASC | IMPLEMENTED-SEMANTIC | ASC(expr) | Tam 1 arg | Yok-Planli | x = ASC("A") |
| CHR | IMPLEMENTED-SEMANTIC | CHR(expr) | Tam 1 arg | Yok-Planli | s = CHR(65) |
| LTRIM | IMPLEMENTED-SEMANTIC | LTRIM(expr) | Tam 1 arg | Yok-Planli | s = LTRIM("  a") |
| RTRIM | IMPLEMENTED-SEMANTIC | RTRIM(expr) | Tam 1 arg | Yok-Planli | s = RTRIM("a  ") |
| STRING | IMPLEMENTED-SEMANTIC | STRING(count,char) | Tam 2 arg | Yok-Planli | s = STRING(3,"*") |
| SPACE | IMPLEMENTED-SEMANTIC | SPACE(expr) | Tam 1 arg | Yok-Planli | s = SPACE(3) |
| SGN | IMPLEMENTED-SEMANTIC | SGN(expr) | Tam 1 arg | Yok-Planli | x = SGN(-1) |
| SQRT | IMPLEMENTED-SEMANTIC | SQRT(expr) | Tam 1 arg | Yok-Planli | x = SQRT(9) |
| SIN | IMPLEMENTED-SEMANTIC | SIN(expr) | Tam 1 arg | Yok-Planli | x = SIN(0) |
| COS | IMPLEMENTED-SEMANTIC | COS(expr) | Tam 1 arg | Yok-Planli | x = COS(0) |
| TAN | IMPLEMENTED-SEMANTIC | TAN(expr) | Tam 1 arg | Yok-Planli | x = TAN(0) |
| ATN | IMPLEMENTED-SEMANTIC | ATN(expr) | Tam 1 arg | Yok-Planli | x = ATN(1) |
| EXP | IMPLEMENTED-SEMANTIC | EXP(expr) | Tam 1 arg | Yok-Planli | x = EXP(1) |
| LOG | IMPLEMENTED-SEMANTIC | LOG(expr) | Tam 1 arg | Yok-Planli | x = LOG(1) |
| INKEY | IMPLEMENTED-SEMANTIC | INKEY(flags[,state]) | 1..2 arg | Yok-Planli | k = INKEY(1) |
| GETKEY | IMPLEMENTED-SEMANTIC | GETKEY() | Tam 0 arg | Yok-Planli | k = GETKEY() |
| CINT | IMPLEMENTED-SEMANTIC | CINT(expr) | Tam 1 arg | Yok-Planli | x = CINT(1.7) |
| CLNG | IMPLEMENTED-SEMANTIC | CLNG(expr) | Tam 1 arg | Yok-Planli | x = CLNG(1.7) |
| CDBL | IMPLEMENTED-SEMANTIC | CDBL(expr) | Tam 1 arg | Yok-Planli | x = CDBL(1) |
| CSNG | IMPLEMENTED-SEMANTIC | CSNG(expr) | Tam 1 arg | Yok-Planli | x = CSNG(1) |
| FIX | IMPLEMENTED-SEMANTIC | FIX(expr) | Tam 1 arg | Yok-Planli | x = FIX(1.7) |
| SQR | IMPLEMENTED-SEMANTIC | SQR(expr) | Tam 1 arg | Yok-Planli | x = SQR(9) |
| RND | IMPLEMENTED-SEMANTIC | RND([expr]) | 0..1 arg | Yok-Planli | x = RND() |
| RANDOMIZE | IMPLEMENTED-PARSER | RANDOMIZE [seed] | Seed opsiyonel | Yok-Planli | RANDOMIZE 42 |
| TIMER | IMPLEMENTED-RUNTIME | TIMER() / TIMER(unit) / TIMER(a,b,unit) | Unit dogrulamasi aktif | IMPLEMENTED-RUNTIME (timer.fbs) | dt = TIMER("ms") |
| VARPTR | PLANNED | VARPTR(expr) | Guvenli pointer semantigi bekliyor | PLANNED | (plan) |
| SADD | PLANNED | SADD(expr) | String address semantigi bekliyor | PLANNED | (plan) |
| LPTR | PLANNED | LPTR(label) | Label pointer semantigi bekliyor | PLANNED | (plan) |
| CODEPTR | PLANNED | CODEPTR(proc) | Code pointer semantigi bekliyor | PLANNED | (plan) |

---

## 8. Mimari Harita (Lexer-Parser-Semantik-Runtime-Build)

### 8.1 Pipeline

1. Lexer
   - Giris: kaynak metin
   - Cikis: token listesi
2. Parser
   - Giris: token listesi
   - Cikis: AST
3. Semantik Dogrulama
   - Intrinsic arity
   - Type token dogrulama
   - Type reference dogrulama
4. Runtime (mevcut alt kume)
   - Timer runtime
   - Memory VM + memory AST executor
5. Build/Interop
   - INCLUDE recursive resolve
   - IMPORT compile/link plan artifact

### 8.2 Hata Uretim Noktalari

- Lexer: unknown token
- Parser: eksik keyword/op/kapanis bloklari
- Semantik: gecersiz arguman sayisi, gecersiz tip, unknown type
- Runtime: out-of-range bellek, unsupported node/op

---

## 9. Modul Sorumluluklari ve Ana Veri Yapilari

### 9.1 Ana Moduller

- src/parser/token_kinds.fbs
  - Token, TokenList
- src/parser/ast.fbs
  - ASTNode, ASTPool
- src/parser/lexer/*
  - Lexing adimlari
- src/parser/parser/*
  - Statement/expression parse + semantik yardimcilar
- src/runtime/timer.fbs
  - Timer donusumleri
- src/runtime/memory_vm.fbs
  - VMemState + bellek islemleri
- src/runtime/memory_exec.fbs
  - ExecState + sinirli AST yurutme
- src/build/interop_manifest.fbs
  - Include/import resolver + artifact emitter

### 9.2 Kritik Durum Degiskenleri

- ParseState.lastError
- ASTPool.nodes/count
- Global type registry (declared/referenced listeleri)
- VMemState.active/sizeBytes/textBase
- ExecState.vars/count

---

## 10. Derleme ve Test Akisi

### 10.1 Derleme

- build.bat src/main.bas
- build_32.bat src/main.bas
- build_64.bat src/main.bas
- build_matrix.bat src/main.bas

### 10.2 Parser Smoke

- build.bat tests/run_manifest.bas
- tests/run_manifest.exe

Mantik:
- tests/manifest.csv okunur
- expected etikete gore parse/ast kontrolu yapilir

### 10.3 Interop Smoke

- build.bat tests/run_cmp_interop.bas
- tests/run_cmp_interop.exe

Kontrol:
- include-once davranisi
- import sayisi
- dist altinda artifact olusumu

---

## 11. Bilimsel Elestiri: Sinirlar, Riskler, Yanlis Anlamaya Acik Alanlar

### 11.1 Acik Sinirlar

1. Genel amacli tam runtime interpreter bu repoda tamamlanmamis.
2. Bircok komut parserda var ama runtime davranisi plan asamasinda.
3. Bitwise keyword operator ailesi lexer seviyesinde gorunse de expression semantigi tam degil.

### 11.2 Teknik Riskler

1. Parser-runtime farkini okumayan ekip, "implemented" yorumunu asiri genisletebilir.
2. Legacy dokumanlardan gelen eski syntaxlar yeni strict profile karisabilir.
3. Planned pointer/memory komutlari guvenlik modeline bagli oldugu icin acele acilim risklidir.

### 11.3 Yapici Cozum Onerileri

1. Her yeni komut icin 3-asamali kabul:
   - parser testi
   - semantik testi
   - runtime testi
2. command_compatibility dosyasinda duplicate satir olmamali.
3. "parser-only" ve "runtime-ready" etiketleri CI raporuna ayrik yazilmali.

---

## 12. Sonuc ve Sonraki Adimlar

Bu PEK3.MD dokumani su tek cizgiye indirger:
- Neyin calistigi,
- Neyin sadece parse edildigi,
- Neyin plan oldugu,
tek bir ana referansta celiskisiz gorunur.

Kisa teknik sonuc:
1. Derleyici omurgasi (lexer+parser+AST) olgun.
2. Semantik denetim kritik komut/fonksiyonlarda aktif.
3. Runtime bugun timer + memory alt kumesinde gercek.
4. Sonraki buyuk adim parser kapsamini runtime kapsami ile esit hizaya getirmek.

Bu belge bundan sonra su amaca hizmet etmelidir:
- Kopyala-yapistir anlatim degil,
- Kanita dayali, tekil, dogrulanabilir teknik karar kaynagi.
