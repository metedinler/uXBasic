# Programcinin El Kitabi

## 1) Amac ve Kapsam
Bu belge uXBasic icin tek dogru gelistirici referansidir.
Belge, su anki kodun gercek kapasitesini ve plandaki siradaki isleri ayri ayri belirtir.

Kaynak dogrulama noktasi:
- src altindaki gercek moduller
- tests/manifest.csv
- tests/plan/command_compatibility_win11.csv
- .plan.md ve WORK_QUEUE.md

## 2) Mevcut Derleyici Gercegi
uXBasic bugun su asamalari gercekten yapiyor:
1. Lexer ile token uretimi
2. Parser ile AST uretimi
3. Include/import icin interop manifest cikarma
4. Sinirli runtime: timer + memory VM
5. Opsiyonel memory komut yurutmeye ozel yol: --execmem

Onemli:
- Genel amacli tam runtime interpreter henuz yok.
- Tum komutlar parser seviyesinde taninmak ile runtime seviyesinde calismak ayni sey degil.

## 3) Dil Kurallari (Kod Gercegi ile)
- Yazim stili QB 7.1 yaklasimina yakindir.
- Acik bildirim esastir.
- Degisken/tanimlayici tip soneki kullanimi (x$, y%, z! vb.) hedef kural olarak kapali tutulur.
- Buna ragmen bazi legacy intrinsic adlar parserda alias olarak vardir:
  - GETKEY, INKEY$, MID$, STR$, UCASE$, LCASE$, CHR$, STRING$
- Eski inline adlari kapali:
  - _ASM, ASM_SUB, ASM_FUNCTION
- Guncel yol:
  - INLINE(...) ... END INLINE

## 4) Komut Durumu Ozeti
Asagidaki liste parser+test gercegine gore verilmistir.

### 4.1 Parser+AST Olarak Implement Edilen Statement Komutlari
- PRINT
- IF, SELECT, FOR, DO
- GOTO, GOSUB, RETURN, EXIT, END
- DECLARE, SUB, FUNCTION
- CONST, DIM, REDIM, TYPE
- DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFEXT, DEFSTR, DEFBYT
- SETSTRINGSIZE
- INCLUDE, IMPORT
- INPUT, OPEN, CLOSE, GET, PUT, SEEK
- LOCATE, COLOR, CLS
- INC, DEC
- POKEB, POKEW, POKED
- MEMCOPYB, MEMFILLB
- RANDOMIZE

### 4.2 Parser+Expr Validation Olarak Implement Edilen Intrinsic Fonksiyonlar
- LEN, MID, STR, VAL, ABS, INT, UCASE, LCASE, ASC, CHR, LTRIM, RTRIM, STRING, SPACE
- SGN, SQRT, SIN, COS, TAN, ATN, EXP, LOG
- INKEY, GETKEY, INKEY$
- MID$, STR$, UCASE$, LCASE$, CHR$, STRING$
- PEEKB, PEEKW, PEEKD
- CINT, CLNG, CDBL, CSNG, FIX, SQR, RND
- LOF, EOF, TIMER

### 4.3 Runtime Olarak Gercekten Calisan Alt Kume
- TIMER runtime:
  - TimerNow, TimerRange, birim donusumu
- Memory VM runtime:
  - VMemPeekB/W/D
  - VMemPokeB/W/D
  - VMemCopyB
  - VMemFillB
- AST tabanli memory execution:
  - ExecRunMemoryProgram
  - src/main.exe icinde --execmem modu ile cagrilabilir

### 4.4 Win11 Profilinden Cikarilanlar
- Port I/O komutlari bu profilde yok:
  - INP, INPB, INPW, INPD
  - OUT, OUTB, OUTW, OUTD

Not:
- INT, INT16, SETVECT gibi komutlar legacy/dusuk seviye kategori olarak belgede gecse de Win11 user-mode hedefte dogrudan runtime garantisi yoktur.

## 5) 8 Komutluk Numerik/Cast Dalgasi Durumu
Soru edilen dalga kodlandi ve testlere eklendi:
- CINT, CLNG, CDBL, CSNG, FIX, SQR, RND, RANDOMIZE

Katman durumu:
- CINT/CLNG/CDBL/CSNG/FIX/SQR: parser+expr-validation
- RND: parser+expr-validation (0 veya 1 arg)
- RANDOMIZE: parser+ast (opsiyonel seed expression)

Test referanslari:
- tests/manifest.csv icinde phase18 testleri
- tests/run_manifest.bas icinde CINT_OK..RANDOMIZE_OK etiketleri
- tests/plan/command_compatibility_win11.csv icinde matrix satirlari

## 6) DLL ve HTTP/API Durumu
Bu alanlar planli ama henuz kodlanmadi.

### DLL (Plan)
- DECLARE/USEDLL modeli korunacak
- Parametre donusum tablosu resmi hale getirilecek
- ANSI/UTF-16 stratejisi netlestirilecek

### HTTP/API (Plan)
- Secenek-1: WinHTTP tabanli yerel katman
- Secenek-2: libcurl tabanli katman

### Onerilen Sira
- Win11 odagi icin once WinHTTP MVP
- Sonra opsiyonel libcurl baglayicisi

### Planlanan Test Paketi
- TST-DLL-CALL-001
- TST-HTTP-GET-001
- TST-HTTP-POST-001
- TST-HTTP-TIMEOUT-001

## 7) Geriye Donuk Uyumluluk Kurali
- Eski komut davranisini bozan degisiklik yasak.
- Yeni komut/genisletme dalga bazli ve testle acilir.
- Parserda tanima ile runtime etkisi birbirine karistirilmaz.

## 8) Basari Kriteri Yaklasimi
Kod tabanina gore uygulanabilir kriter:
- Manifest smoke: Fail = 0
- CMP interop: PASS
- Yeni dalgada eklenen testlerin tamaminda green
- Derleme kapisi: src/main.bas ve ilgili test ikilileri green

## 9) Mimari: AST ve Guvenli Yurutme
Bu projede AST gercektir.
- ParseProgram ile AST uretimi zorunludur.
- ASTDump ile gorulebilir.

Guvenli yurutme yaklasimi:
- Tum dili dogrudan native calistirmak yerine once kontrollu alt-kume yurutucu acilir.
- Memory komutlari icin bu yapildi:
  - memory_vm.fbs ile sinirli sanal bellek alaninda calisir
  - memory_exec.fbs ile AST uzerinden kontrollu degerlendirme yapilir

## 10) EK-18 Modul, Tip, Degisken ve API Dokumu (Tam)
Bu bolum tum aktif moduller icin tip/veri yapisi ve disa acik API ozetidir.

### 10.1 src/main.bas
- Global degiskenler:
  - sourceText As String
  - sourcePath As String
  - st As LexerState
  - ps As ParseState
  - selected As String
  - n As Integer
- Ana akis:
  - source oku -> lexer -> parser -> AST dump -> interop emit -> opsiyonel --execmem

### 10.2 src/parser/token_kinds.fbs
- Type Token
  - kind, lexeme, lineNo, colNo
- Type TokenList
  - items(Any), count, capacity
- API
  - TokenListInit
  - TokenListPush
  - TokenListClear
  - TokenListAt

### 10.3 src/parser/ast.fbs
- Type ASTNode
  - kind, value, op
  - lineNo, colNo
  - left, right, firstChild, nextSibling
- Type ASTPool
  - nodes(Any), count, capacity
- API
  - ASTPoolInit
  - ASTNewNode
  - ASTAddChild
  - ASTDump

### 10.4 src/parser/lexer_core.fbs + lexer_driver/readers/keyword_table
- Type LexerState
  - sourceText
  - cursor, lineNo, colNo
  - tokens As TokenList
- API
  - LexerInit
  - karakter okuma/token uretim yardimcilari
  - keyword siniflandirma

### 10.5 src/parser/parser.fbs
- Type ParseState
  - lx As LexerState
  - cursorIndex
  - lastError
  - ast As ASTPool
  - rootNode
- Declare katmani
  - statement/expr parser fonksiyon bildirimleri

### 10.6 src/parser/parser_shared.fbs
- Ortak parser yardimcilari
  - token ilerleme
  - keyword/operator esleme
  - intrinsic arguman dogrulama
  - timer/file-info dogrulama

### 10.7 src/parser/parser_expr.fbs
- Expression parser
  - ParsePrimary, ParseUnary, ParsePower, ParseTerm, ParseAdd, ParseRelation
- CALL_EXPR uretimi ve intrinsic dogrulama cagrilari

### 10.8 src/parser/parser_stmt_basic.fbs
- Statement parserlari
  - ParsePrintStmt
  - ParseInlineStmt
  - ParseIncStmt, ParseDecStmt
  - ParseRandomizeStmt
  - ParsePokebStmt, ParsePokewStmt, ParsePokedStmt
  - ParseMemcopybStmt, ParseMemfillbStmt

### 10.9 src/parser/parser_stmt_io.fbs
- ParseOpenStmt
- ParseInputStmt
- ParseCloseStmt
- ParseGetStmt
- ParsePutStmt
- ParseSeekStmt
- ParseLocateStmt
- ParseColorStmt
- ParseClsStmt

### 10.10 src/parser/parser_stmt_flow.fbs
- ParseIfStmt
- ParseSelectStmt
- ParseForStmt
- ParseDoStmt
- ParseGotoStmt
- ParseGosubStmt
- ParseReturnStmt
- ParseExitStmt
- ParseEndStmt

### 10.11 src/parser/parser_stmt_decl.fbs
- ParseDimBound
- ParseDimDeclarator
- ParseDimStmt
- ParseConstStmt
- ParseRedimStmt
- ParseTypeStmt
- ParseDefTypeStmt
- ParseSetStringSizeStmt
- ParseIncludeStmt
- ParseImportStmt
- ParseDeclareStmt
- ParseSubStmt
- ParseFunctionStmt

### 10.12 src/parser/parser_stmt_dispatch.fbs
- ParseSimpleStatement
- ParserInit
- ParseProgram
- Tum statement parserlarina merkez dispatch

### 10.13 src/build/interop_manifest.fbs
- Type InteropIncludeEntry
- Type InteropImportEntry
- Type InteropManifest
- Type InteropStringSet
- API
  - InteropManifestInit
  - ResolveInteropManifestForSource
  - EmitInteropArtifacts

### 10.14 src/runtime/timer.fbs
- API
  - TimerNormalizeUnit
  - TimerConvertSeconds
  - TimerNow
  - TimerRange

### 10.15 src/runtime/memory_vm.fbs
- Type VMemState
  - data(Any)
  - sizeBytes
  - textBase
  - textCols, textRows
  - active
- Global
  - g_vmem As VMemState
- API
  - VMemInit
  - VMemPeekB/W/D
  - VMemPokeB/W/D
  - VMemCopyB
  - VMemFillB
  - VMemBlitTextWindow

### 10.16 src/runtime/memory_exec.fbs
- Type ExecVar
  - nameText, value
- Type ExecState
  - vars(Any), count
- API
  - ExecRunMemoryProgram
- Davranis
  - AST statement/expr degerlendirme
  - assign/inc-dec/call_expr(memory) yurutme

### 10.17 src/legacy/get_commands_port.fbs
- API
  - LegacyGetCommands
- Amac
  - legacy satir parcalama davranisini korumak

## 11) Veri Yapilari ve Anahtar Kelime Durumu
Asagidaki veri yapisi anahtar kelimeleri lexer tarafinda taninmaktadir:
- ARRAY
- LIST
- DICT
- SET

Gercek durum:
- Bu kelimeler henuz parser+runtime semantigi tamamlanmis koleksiyon sistemi degildir.
- Bu alan planli gelisim maddesidir.

## 12) Dogru Okuma Rehberi
- Bir ozellik icin "implemented" denmesi icin test/matrix satiri olmalidir.
- Runtime etkisi iddia ediliyorsa o modulu src/runtime altinda bulunmali ve testle calismalidir.
- Belge ile kod celisirse kod + test gercegi ustundur; belge hemen guncellenir.

## 13) Kisa Yol Komutlari
- Ana derleme: build.bat src/main.bas
- Manifest smoke: build.bat tests/run_manifest.bas ve tests/run_manifest.exe
- CMP interop: build.bat tests/run_cmp_interop.bas ve tests/run_cmp_interop.exe
- Memory VM runtime testi: build.bat tests/run_memory_vm.bas ve tests/run_memory_vm.exe
- Memory AST exec testi: build.bat tests/run_memory_exec_ast.bas ve tests/run_memory_exec_ast.exe

Bu belge append-only disiplinini korur, ama icerik olarak kod gercegi disina cikmaz.
