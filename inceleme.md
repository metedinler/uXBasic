# PCK2.MD Uyum Incelemesi (Kod + Dokumantasyon + Test Plani)

Tarih: 2026-04-21
Kapsam: PCK2.MD dosyasinin bastan sona okunmasi (1-4548), mevcut kod tabani (`src/*`), test manifest/plani (`tests/manifest.csv`, `tests/plan/command_compatibility_win11.csv`) ve ana dokumanlar (`PCK4.md`, `ProgramcininElKitabi.md`) ile karsilastirma.

## 1) Yurutme Ozeti

PCK2.MD dosyasi append-only sekilde buyutuldugu icin tek bir kaynak gercek degil; ayni komut icin bir yerde "implemented", baska bir yerde "planned" denebiliyor.

Ana sonuc:
- Cekirdek parser akis komutlari (IF/SELECT/FOR/DO/GOTO/GOSUB/RETURN/END), I/O (PRINT/INPUT/OPEN/CLOSE/GET/PUT/SEEK), INLINE modeli ve bircok intrinsic kodda mevcut.
- PCK2 icindeki "VARPTR/SADD/LPTR/CODEPTR + POKES/MEMCOPYW/MEMCOPYD/MEMFILLW/MEMFILLD/SETNEWOFFSET kodda yok" iddiasi guncel kod durumuyla uyusmuyor; bunlar parser+runtime+test izlerine sahip.
- Donanima yakin eski komutlar (INT16/SETVECT/CPUFLAGS/PUSH komut formu; INP/OUT ailesi) guncel parser/runtime cekirdeginde yok.
- PCK2'nin son bolumleri ciddi tekrar/duplikasyon iceriyor ve ayni konu farkli satirlarda celiskili anlatiliyor.

## 2) Metodoloji

Asagidaki kanit katmanlari birlikte kontrol edildi:
- Dokuman iddialari: `PCK2.MD`, `PCK4.md`, `ProgramcininElKitabi.md`
- Kod gercegi: `src/parser/*`, `src/runtime/*`
- Test/planning gercegi: `tests/manifest.csv`, `tests/plan/command_compatibility_win11.csv`, ilgili `tests/run_*.bas`

Durum etiketleri:
- IMPLEMENTED: parser ve/veya runtime/test kaniti var.
- PARTIAL: parser var ama runtime/semantik kapsami kisitli.
- MISSING: kodda dogrudan destek izi bulunmadi.
- DOC-DRIFT: ayni komut icin dokumanlar arasi uyumsuz/celiski var.

## 3) Kritik Bulgular (Yuksek Oncelik)

1. PCK2 icinde ayni konuda kendi kendine celisen ifade var (DOC-DRIFT).
- Ornek: VARPTR/SADD/LPTR/CODEPTR ve memory komutlari bir yerde "planned/yok", baska yerde detayli komut katalogunda "var".

2. PCK2'nin "kodda hic yok" dedigi bazi komutlar kodda var (yanlis negatif).
- VARPTR/SADD/LPTR/CODEPTR:
  - parser arity/arg kontrol: `src/parser/parser/parser_shared.fbs`
  - runtime eval: `src/runtime/exec/exec_eval_builtin_categories.fbs`
  - test plan manifest: `tests/manifest.csv` (phase19 satirlari), `tests/plan/command_compatibility_win11.csv`
- POKES/MEMCOPYW/MEMCOPYD/MEMFILLW/MEMFILLD/SETNEWOFFSET:
  - parser stmt registry ve parse: `src/parser/parser/parser_stmt_registry.fbs`, `src/parser/parser/parser_stmt_basic.fbs`, `src/parser/parser/parser_stmt_dispatch.fbs`
  - runtime exec: `src/runtime/exec/exec_stmt_memory_core.fbs`
  - testler: `tests/run_memory_exec_ast.bas`, `tests/run_memory_vm.bas`

3. PCK2 "operator semantigi yok" dedigi bazi operatorler parser/runtimeda var.
- Parser expression operator katmanlari: `src/parser/parser/parser_expr.fbs`
  - `AND/OR/XOR`, `MOD`, `SHL/SHR/ROL/ROR`, `<<`/`>>`
- Runtime operasyonlari: `src/runtime/memory_exec.fbs`

4. Donanima yakin komutlarin bir bolumu dokumanda aktif gibi anlatiliyor, kodda yok.
- `INT16`, `SETVECT`, `CPUFLAGS` (komut), `PUSH` (komut) ve port I/O (`INP/OUT*`) icin parser/runtime izine rastlanmadi.
- Bu kisim PCK2 icinde de yer yer "miras/plan" diye geciyor; etiketleme standardi yok.

## 4) Komut/Syntax Uyum Matrisi (Ozet)

### 4.1 Dil cekirdegi (akis + I/O)

- IF/ELSEIF/ELSE/END IF -> IMPLEMENTED
  - Kanit: `src/parser/parser/parser_stmt_registry.fbs`, test satirlari `tests/manifest.csv`
- SELECT CASE/CASE/CASE ELSE/END SELECT -> IMPLEMENTED
  - Kanit: parser stmt registry + manifest ast-select satirlari
- FOR/NEXT, DO/LOOP, EXIT -> IMPLEMENTED
  - Kanit: parser stmt registry + runtime exit handling (`src/runtime/memory_exec.fbs`)
- GOTO/GOSUB/RETURN/END -> IMPLEMENTED
  - Kanit: parser stmt registry + runtime control-flow handling (`src/runtime/memory_exec.fbs`)
- PRINT/INPUT/OPEN/CLOSE/GET/PUT/SEEK -> IMPLEMENTED
  - Kanit: `src/parser/parser/parser_stmt_registry.fbs`, `src/parser/parser/parser_stmt_io.fbs`, manifest phase4/phase9
- LOF/EOF -> IMPLEMENTED (builtin eval)
  - Kanit: runtime builtin dispatch (`src/runtime/memory_exec.fbs`), manifest phase5

### 4.2 INLINE / legacy asm formlari

- INLINE(...) ... END INLINE -> IMPLEMENTED
  - Kanit: `src/parser/parser/parser_stmt_basic.fbs`, `tests/manifest.csv` inline testleri
- _ASM / ASM_SUB / ASM_FUNCTION -> DISABLED (tasarim geregi)
  - Kanit: `src/parser/parser/parser_shared.fbs`, parser hata metni: "legacy inline forms are disabled"
- PCK2'de bu legacy formlarin yer yer aktif gibi anlatilmasi -> DOC-DRIFT

### 4.3 Bellek intrinsic ve komutlari

- VARPTR/SADD/LPTR/CODEPTR -> IMPLEMENTED
- POKES/MEMCOPYW/MEMCOPYD/MEMFILLW/MEMFILLD/SETNEWOFFSET -> IMPLEMENTED
  - Kanitler yukarida kritik bulgu #2'de listelendi.
- PCK2 icinde bunlarin "kodda yok" denmesi -> DOC-DRIFT

### 4.4 Operator semantigi

- MOD, AND/OR/XOR, SHL/SHR/ROL/ROR, <<, >> -> IMPLEMENTED
  - Kanit: `src/parser/parser/parser_expr.fbs`, `src/runtime/memory_exec.fbs`
- PCK2'nin "lexer var, expression semantik yok" ifadesi -> guncel kodla uyusmuyor.

### 4.5 Veri yapilari (ARRAY/LIST/DICT/SET)

- Parser tip tanima: IMPLEMENTED
  - Kanit: `src/parser/parser/parser_shared.fbs`, `tests/manifest.csv` (DIM-LIST/DICT/SET)
- Runtime koleksiyon islemleri: PARTIAL-TO-IMPLEMENTED (runtime modulleri mevcut, kapsam test derinligi dosya bazli degisiyor)
  - Kanit: `src/runtime/exec/exec_collections.fbs`, `src/runtime/memory_exec.fbs`
- PCK2'de "parserda keyword bile yok" iddiasi -> guncel kodla uyusmuyor.

### 4.6 Donanima yakin/miras komutlar

- INP/INPB/INPW/INPD, OUT/OUTB/OUTW/OUTD -> MISSING (guncel cekirdek)
- INT16, SETVECT, CPUFLAGS (komut), PUSH (komut) -> MISSING (guncel cekirdek)
- Belge etkisi: Bunlar "miras/plan" etiketiyle ayrilmadiginda yanlis beklenti uretiyor.

## 5) PCK2 Icindeki Yapisal Sorunlar

1. Duplikasyon cok yuksek.
- 2700+ satirdan sonra ayni bloklar tekrar tekrar kopyalanmis.
- Ayni paragraf/ek listesi birden fazla kez geciyor.

2. Normatif dil ile plan dili karisik.
- "Bu vardir" ve "planlandi" ayni bolumde, bazen ayni komut icin birlikte bulunuyor.

3. Eski-yeni soz dizimi bir arada ve etiketlenmemis.
- `INKEY$`, `MID$`, `STR$`, `_ASM` gibi legacy formlar yer yer aktifmis gibi yazilmis.
- Guncel parser politikasinda legacy inline formlari kapali.

## 6) Belge Bazli Uyum Durumu

- `PCK4.md`: Guncel mimari ve modern policy ile daha uyumlu.
- `tests/plan/command_compatibility_win11.csv`: Komut durum tablosu acisindan su an en tutarli kaynak.
- `tests/manifest.csv`: parser kapsami icin somut case listesi.
- `PCK2.MD`: tarihsel + plan + guncel metin karisik oldugu icin tek basina kaynak gercek olmaya uygun degil.
- `ProgramcininElKitabi.md`: PCK2 ile benzer sekilde karisik/miras unsurlar tasiyor.

## EK-01: Tablolu Kanit Ozeti (Append-Only)

Bu ek bolum, "yalnizca yok komutlar" degil, hem kodda olan hem kodda olmayan komut gruplarini birlikte ve tek tabloda gostermek icin eklendi.

### EK-01.1 Arastirma Kapsami (Tum Dosya + Kod Karsilastirma Kaniti)

| Kontrol Basligi | Sonuc | Kanit |
|---|---|---|
| PCK2.MD tam okuma | TAMAMLANDI | 1-4548 satir araligi okunup notlandi |
| Parser kod karsilastirmasi | TAMAMLANDI | `src/parser/*` altinda statement/expr/builtin tarandi |
| Runtime kod karsilastirmasi | TAMAMLANDI | `src/runtime/*` ve `src/runtime/exec/*` tarandi |
| Test kapsami karsilastirmasi | TAMAMLANDI | `tests/manifest.csv`, `tests/plan/command_compatibility_win11.csv`, ilgili `tests/run_*.bas` |
| Dokumanlar arasi drift kontrolu | TAMAMLANDI | `PCK2.MD`, `PCK4.md`, `ProgramcininElKitabi.md` caprazlandi |

### EK-01.2 Komut Gruplari Uyum Tablosu (Genis Ozet)

| Grup | PCK2 Durumu (karisik ifade) | Kod Durumu | Test/Plan Durumu | Nihai Etiket |
|---|---|---|---|---|
| Akis komutlari (IF/SELECT/FOR/DO/EXIT/GOTO/GOSUB/RETURN/END) | Yer yer var, yer yer tekrarli | Parser + runtime mevcut | Manifest satirlari mevcut | IMPLEMENTED |
| Temel I/O (PRINT/INPUT) | Var | Parser + runtime mevcut | Manifest phase9 kapsami mevcut | IMPLEMENTED |
| Dosya I/O (OPEN/CLOSE/GET/PUT/SEEK/LOF/EOF) | Var | Parser + runtime mevcut | Manifest phase4/phase5 + compatibility plan mevcut | IMPLEMENTED |
| INLINE modern model | Var | `INLINE ... END INLINE` parserda mevcut | Inline testleri mevcut | IMPLEMENTED |
| Legacy inline formlari (`_ASM`, `ASM_SUB`, `ASM_FUNCTION`) | Bazi bolumlerde aktifmis gibi | Parser tarafinda bilerek kapali | Parse-fail testleri mevcut | LEGACY-DISABLED |
| Memory intrinsics (VARPTR/SADD/LPTR/CODEPTR) | Bazi kisimlarda "yok" denmis | Parser + runtime mevcut | Manifest phase19 + compatibility plan mevcut | IMPLEMENTED (DOC-DRIFT var) |
| Memory komutlari (POKES/MEMCOPYW/MEMCOPYD/MEMFILLW/MEMFILLD/SETNEWOFFSET) | Bazi kisimlarda "yok" denmis | Parser + runtime mevcut | Memory VM/AST testleri + plan mevcut | IMPLEMENTED (DOC-DRIFT var) |
| Operator semantigi (MOD, AND/OR/XOR, SHL/SHR/ROL/ROR, << >>) | Bazi kisimlarda "semantik yok" denmis | Expr parser + runtime operator handling mevcut | Test/plandaki kapsama uygun | IMPLEMENTED (DOC-DRIFT var) |
| Veri tipleri ARRAY/LIST/DICT/SET | Bazi kisimlarda "keyword yok" denmis | Parser type tanima + runtime koleksiyon modulleri mevcut | Manifest ve plan satirlari mevcut | PARTIAL-TO-IMPLEMENTED |
| Donanima yakin komutlar (INP/OUT ailesi, INT16, SETVECT, CPUFLAGS komut, PUSH komut) | Var/plan/miras karisik anlatim | Guncel parser/runtime cekirdekte iz bulunmadi | Plan/miras baglaminda geciyor | MISSING (Win11 user-mode icin legacy) |
| Derleme zamani komutlari (%%INCLUDE, %%PLATFORM, %%IF vb.) | Var | Parser preprocess modulleri mevcut | Manifest phase1 + compatibility plan mevcut | IMPLEMENTED |
| Yardimci komutlar (INC, DEC) | Var | Parser/runtime'da bulunmadi | Plan/miras baglaminda geciyor | MISSING |
| Ekran ve metin komut/fonksiyonlari (PRINT, CLS, COLOR, LOCATE, LEN, MID, UCASE vb.) | Var | Parser/runtime'da kismi mevcut | Manifest phase9 + compatibility plan mevcut | PARTIAL (bazilari IMPLEMENTED, bazilari MISSING) |
| Sayi ve zaman fonksiyonlari (ABS, SIN, TIMER vb.) | Var | Runtime builtin'da kismi mevcut | Manifest phase5 + compatibility plan mevcut | PARTIAL (bazilari IMPLEMENTED, TIMER MISSING) |
| DEF* komutlari (DEFINT, DEFLNG vb.) | Var | Parser/runtime'da bulunmadi | Plan/miras baglaminda geciyor | MISSING |
| OOP komutlari (TYPE/CLASS/INTERFACE/NEW/DELETE) | Var | Parser stmt registry + runtime mevcut | Manifest OOP satirlari mevcut | IMPLEMENTED |
| Veri ve bellek komutlari (DIM/REDIM/CONST/MEMCOPYD/MEMFILLB) | Var | Parser stmt registry + runtime mevcut | Manifest phase1/phase2 + compatibility plan mevcut | IMPLEMENTED |
| Interop komutlari (IMPORT/INLINE/CALL(DLL)) | Var | Parser stmt registry + runtime mevcut | Manifest phase20 + inline testleri mevcut | IMPLEMENTED |
| Metin fonksiyonlari (LEN/MID/UCASE/LCASE/VAL) | Var | Runtime builtin eval mevcut | Manifest phase5 + compatibility plan mevcut | IMPLEMENTED |
| Matematik fonksiyonlari (ABS/INT/SQR/SIN/LOG) | Var | Runtime builtin eval mevcut | Manifest phase5 + compatibility plan mevcut | IMPLEMENTED |
| Pointer/meta fonksiyonlari (VARPTR/SIZEOF/OFFSETOF) | Var | Runtime builtin eval mevcut | Manifest phase19 + compatibility plan mevcut | IMPLEMENTED |

### EK-01.3 "Sadece Bu Komutlar Yok" Yanlisini Duzelten Net Liste

Asagidaki liste, belgede gecen komutlardan guncel kodda **olanlarin** da acikca gorunmesi icin eklendi:

| Durum | Ornek Komutlar |
|---|---|
| Kodda var (parser+runtime/test) | IF, SELECT CASE, FOR, DO/LOOP, EXIT, GOTO, GOSUB, RETURN, END, PRINT, INPUT, OPEN, CLOSE, GET, PUT, SEEK, LOF, EOF, INLINE, INKEY, VARPTR, SADD, LPTR, CODEPTR, POKES, MEMCOPYW, MEMCOPYD, MEMFILLW, MEMFILLD, SETNEWOFFSET, DIM, REDIM, CONST, TYPE, CLASS, INTERFACE, NEW, DELETE, IMPORT, CALL(DLL), LEN, MID, UCASE, LCASE, VAL, ABS, INT, SQR, SIN, LOG, SIZEOF, OFFSETOF, %%INCLUDE, %%PLATFORM, %%IF |
| Kodda kapali (tasarim karari) | _ASM, ASM_SUB, ASM_FUNCTION |
| Kodda bulunmadi (legacy/plan) | INP, INPB, INPW, INPD, OUT, OUTB, OUTW, OUTD, INT16, SETVECT, CPUFLAGS (komut), PUSH (komut) |

### EK-01.4 Son Not (Okunabilirlik)

Bu ekten sonra belge yorumu su sekilde okunmali:
1. "Yok" denilen komutlarin tumu yok degil; bir kismi kodda aktif.
2. Asil sorun teknik eksikten cok PCK2 icindeki tekrardan dogan durum celiskisi.
3. Uygulamada karar verirken birincil kaynak olarak kod + manifest + compatibility plan birlikte alinmali.


## 9. Parser-Uyumlu Standart Söz Dizimi Komutları ve Dahili Fonksiyonlar Durumu

Bu bölüm, PCK2.MD bölümünde listelenen parser-uyumlu standart söz dizimi komutlarını ve dahili fonksiyonları tablo halinde sunar, uXBasic kod tabanında varlığını parser, runtime ve test kanıtlarına dayanarak doğrular.

### 9.1 Akış Komutları

| Komut | Söz Dizimi | Kod Durumu | Notlar |
|---|---|---|---|
| IF | IF koşul THEN ... END IF | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: memory_exec.fbs |
| SELECT CASE | SELECT CASE ifade ... END SELECT | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Testler: manifest.csv |
| FOR | FOR değişken = başlangıç TO bitiş ... NEXT | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: exec döngüleri |
| DO | DO ... LOOP [UNTIL/WHILE] | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: exec döngüleri |
| GOTO | GOTO etiket | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: kontrol akışı |
| GOSUB | GOSUB etiket ... RETURN | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: kontrol akışı |
| RETURN | RETURN [ifade] | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: kontrol akışı |
| EXIT | EXIT [IF/FOR/DO/vb.] | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: exec_stmt_flow.fbs |
| END | END [MAIN/FUNCTION/vb.] | UYGULANMIŞ | Parser: parser_stmt_registry.fbs, Runtime: kontrol akışı |

### 9.2 Tanımlamalar

| Komut | Söz Dizimi | Kod Durumu | Notlar |
|---|---|---|---|
| CONST | CONST isim = değer | UYGULANMIŞ | Parser: parser_stmt_basic.fbs |
| DIM | DIM değişken AS tip | UYGULANMIŞ | Parser: parser_stmt_basic.fbs, Runtime: bellek yönetimi |
| REDIM | REDIM [PRESERVE] dizi(...) AS tip | UYGULANMIŞ | Parser: parser_stmt_basic.fbs, Runtime: dinamik diziler |
| TYPE | TYPE isim ... END TYPE | UYGULANMIŞ | Parser: parser_stmt_basic.fbs, Runtime: değer tipleri |
| DECLARE SUB/FUNCTION | DECLARE SUB isim(...) | UYGULANMIŞ | Parser: parser_stmt_basic.fbs |
| SUB/FUNCTION | SUB isim(...) ... END SUB | UYGULANMIŞ | Parser: parser_stmt_basic.fbs, Runtime: fonksiyon çağrıları |
| DEFINT vb. | DEFINT a-z | EKSİK | Eski tip tanımlamaları uygulanmamış |
| SETSTRINGSIZE | SETSTRINGSIZE boyut | EKSİK | Parser/runtime'da bulunamadı |
| INCLUDE | INCLUDE "dosya" | UYGULANMIŞ | Parser: preprocess direktifleri |
| IMPORT | IMPORT(C/CPP/ASM, "dosya") | UYGULANMIŞ | Parser: parser_stmt_basic.fbs, Build: interop manifest |

### 9.3 G/Ç Komutları

| Komut | Söz Dizimi | Kod Durumu | Notlar |
|---|---|---|---|
| PRINT | PRINT ifade [, ifade...] | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: exec G/Ç |
| INPUT | INPUT değişken [, değişken...] | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: exec G/Ç |
| OPEN | OPEN dosya FOR mod AS #tutamak | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: dosya işlemleri |
| CLOSE | CLOSE #tutamak | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: dosya işlemleri |
| GET | GET #tutamak, pozisyon, değişken | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: dosya işlemleri |
| PUT | PUT #tutamak, pozisyon, değişken | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: dosya işlemleri |
| SEEK | SEEK #tutamak, pozisyon | UYGULANMIŞ | Parser: parser_stmt_io.fbs, Runtime: dosya işlemleri |
| LOCATE | LOCATE satır, sütun | EKSİK | Parser/runtime'da bulunamadı |
| COLOR | COLOR önplan, arkaplan | EKSİK | Parser/runtime'da bulunamadı |
| CLS | CLS | EKSİK | Parser/runtime'da bulunamadı |

### 9.4 Bellek Komutları

| Komut | Söz Dizimi | Kod Durumu | Notlar |
|---|---|---|---|
| INC | INC değişken | EKSİK | Parser/runtime'da bulunamadı |
| DEC | DEC değişken | EKSİK | Parser/runtime'da bulunamadı |
| RANDOMIZE | RANDOMIZE [tohum] | EKSİK | Parser/runtime'da bulunamadı |
| POKEB/W/D | POKEB adres, değer | UYGULANMIŞ | Parser: parser_stmt_memory.fbs, Runtime: exec bellek |
| MEMCOPYB | MEMCOPYB hedef, kaynak, sayı | UYGULANMIŞ | Parser: parser_stmt_memory.fbs, Runtime: exec bellek |
| MEMFILLB | MEMFILLB hedef, değer, sayı | UYGULANMIŞ | Parser: parser_stmt_memory.fbs, Runtime: exec bellek |
| INLINE | INLINE(...) ... END INLINE | UYGULANMIŞ | Parser: parser_stmt_basic.fbs, Runtime: interop |

### 9.5 Dahili Fonksiyonlar

| Fonksiyon | Söz Dizimi | Kod Durumu | Notlar |
|---|---|---|---|
| LEN | LEN(dizgi) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| STR | STR(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| VAL | VAL(dizgi) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| ABS | ABS(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| INT | INT(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| UCASE | UCASE(dizgi) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| LCASE | LCASE(dizgi) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| ASC | ASC(dizgi) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| CHR | CHR(kod) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| LTRIM | LTRIM(dizgi) | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |
| RTRIM | RTRIM(dizgi) | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |
| SPACE | SPACE(sayı) | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |
| SGN | SGN(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| SQRT | SQRT(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| SIN | SIN(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| COS | COS(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| TAN | TAN(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| ATN | ATN(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| EXP | EXP(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| LOG | LOG(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| CINT | CINT(ifade) | UYGULANMIŞ | Runtime: tip dönüşümleri |
| CLNG | CLNG(ifade) | UYGULANMIŞ | Runtime: tip dönüşümleri |
| CDBL | CDBL(ifade) | UYGULANMIŞ | Runtime: tip dönüşümleri |
| CSNG | CSNG(ifade) | UYGULANMIŞ | Runtime: tip dönüşümleri |
| FIX | FIX(sayı) | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |
| SQR | SQR(sayı) | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| LOF | LOF(#tutamak) | UYGULANMIŞ | Runtime: dosya işlemleri |
| EOF | EOF(#tutamak) | UYGULANMIŞ | Runtime: dosya işlemleri |
| PEEKB | PEEKB(adres) | UYGULANMIŞ | Runtime: bellek erişimi |
| PEEKW | PEEKW(adres) | UYGULANMIŞ | Runtime: bellek erişimi |
| PEEKD | PEEKD(adres) | UYGULANMIŞ | Runtime: bellek erişimi |
| MID | MID(dizgi, başlangıç, uzunluk) | UYGULANMIŞ | Runtime: dizgi işlemleri |
| STRING | STRING(sayı, karakter) | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |
| RND | RND() | UYGULANMIŞ | Runtime: exec_eval_builtin_categories.fbs |
| INKEY | INKEY() | UYGULANMIŞ | Runtime: giriş işlemleri |
| GETKEY | GETKEY() | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |
| TIMER | TIMER() | EKSİK | Runtime dahili fonksiyonlarında bulunamadı |

### 9.6 Özet

- **Uygulanmış**: Akış, G/Ç, bellek ve çoğu dahili fonksiyonların çoğunluğu kod tabanında mevcut.
- **Eksik**: Bazı eski veya az kullanılan komutlar (LOCATE, COLOR, CLS, INC, DEC vb.) uygulanmamış.
- **Doğrulama Kaynakları**: Parser dosyaları (src/parser/), runtime dosyaları (src/runtime/), test manifestleri (tests/manifest.csv) ve uyumluluk planları (tests/plan/command_compatibility_win11.csv).
- **Notlar**: Durum, inceleme.md analizi ve doğrudan kod incelemesi ile çapraz doğrulanmış.

## EK-02: FOR EACH / DO EACH Denetimi ve Ayrik Durum Tablolari (Append-Only)

Tarih: 2026-04-22

### EK-02.1 FOR EACH ve DO EACH kodda var mi?

Sonuc: **Evet, her iki komut da IMPLEMENTED**.

Kanit ozeti:
- Parser dispatch: `FOR + EACH` ve `DO + EACH` kayitlari mevcut.
- Parser parse fonksiyonlari: `ParseForEachStmt`, `ParseDoEachStmt` mevcut.
- Runtime yurutme: `ExecRunForEachStmt`, `ExecRunDoEachStmt` mevcut.
- Semantik/MIR: `FOR_EACH_STMT` ve `DO_EACH_STMT` lowering mevcut.
- Test: `tests/run_each_exec.bas` icinde her iki komut icin dogrudan calisma ve assert senaryolari mevcut.

Degerlendirme (tasarim niyeti):
- Bu komutlar **yalnizca OOP nesne iterasyonu** icin sinirli degil.
- Mevcut soz dizimi `IN expr, expr, ...` seklinde genel ifade listesi uzerinden iterasyon yapiyor.
- OOP baglaminda pointer/offset senaryolariyla kullanilabiliyor; ancak zorunlu bir "object enumerator protocol" bagimliligi gorunmuyor.

### EK-02.2 UYGULANMIS (IMPLEMENTED) Komut/Fonksiyon Tablosu

| Kategori | Komut/Fonksiyonlar |
|---|---|
| Akis | IF, SELECT CASE, FOR, DO, GOTO, GOSUB, RETURN, EXIT, END, FOR EACH, DO EACH |
| Tanimlama | CONST, DIM, REDIM, TYPE, DECLARE SUB/FUNCTION, SUB/FUNCTION, INCLUDE, IMPORT |
| G/Ç | PRINT, INPUT, OPEN, CLOSE, GET, PUT, SEEK |
| Bellek/Interop | POKEB, POKEW, POKED, POKE, MEMCOPYB, MEMFILLB, INLINE |
| Dahili fonksiyonlar | LEN, STR, VAL, ABS, INT, UCASE, LCASE, ASC, CHR, SGN, SQRT, SIN, COS, TAN, ATN, EXP, LOG, CINT, CLNG, CDBL, CSNG, SQR, LOF, EOF, PEEKB, PEEKW, PEEKD, MID, RND, INKEY |

### EK-02.3 KISMEN (PARTIAL) Komut/Fonksiyon Tablosu

| Kategori | Komut/Fonksiyonlar | Not |
|---|---|---|
| Ekran/metin grubu | PRINT, CLS, COLOR, LOCATE, LEN, MID, UCASE vb. | Grup bazinda karisik: PRINT/LEN/MID/UCASE var; CLS/COLOR/LOCATE eksik |
| Sayi/zaman grubu | ABS, SIN, TIMER vb. | Grup bazinda karisik: ABS/SIN var; TIMER eksik |

### EK-02.4 EKSIK (MISSING) Komut/Fonksiyon Tablosu

| Kategori | Komut/Fonksiyonlar |
|---|---|
| Tanimlama | DEFINT/DEFLNG/DEFSNG/DEFDBL/DEFEXT/DEFSTR/DEFBYT, SETSTRINGSIZE |
| G/Ç / ekran | LOCATE, COLOR, CLS |
| Bellek/yardimci | INC, DEC, RANDOMIZE |
| Dahili fonksiyonlar | LTRIM, RTRIM, SPACE, FIX, STRING, GETKEY, TIMER |

### EK-02.5 Dogrulama Kaynaklari (FOR EACH / DO EACH odak)

- `src/parser/parser/parser_stmt_registry.fbs`
- `src/parser/parser/parser_stmt_flow.fbs`
- `src/runtime/exec/exec_stmt_flow.fbs`
- `src/semantic/mir.fbs`
- `tests/run_each_exec.bas`