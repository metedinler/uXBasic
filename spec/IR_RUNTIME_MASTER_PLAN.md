# IR + Runtime Master Plan

Tarih: 2026-04-11
Amac: uXBasic dil yuzeyini operasyonel hale getirmek icin IR ve runtime katmanlarini fazli ve olculebilir bicimde tamamlamak.

## 1) Cekirdek Hedefler

1. Dokuman-parse-runtime farkini kapatmak.
2. AST uzerinden HIR ve MIR katmanlarini netlestirmek.
3. Runtime statement kapsamini temel BASIC akis ve I/O komutlariyla tamamlamak.
4. Sayisal modelde integer + floating point hesap semantigini resmi hale getirmek.
5. FFI tarafinda once IMPORT(C/CPP/ASM, file), sonra INLINE(C, text) ilerlemek.
6. Komut kavramini genis yorumlayip calistirilabilir tum ifadeleri kapsamak: statement + local function + operator + type/variable + data structure.

## 1.1) Paralel Dalga (Lane) Modeli

Her faz asagidaki lane'lerle paralel yurur:

1. L-STATEMENT: Akis/I-O/komut runtime
2. L-LOCALFUNC: Intrinsic + user-defined function call modeli
3. L-OPERATOR: Unary/binary operator runtime + precedence uyumu
4. L-TYPEVAR: Tip baglama, degisken modeli, promotion
5. L-DATASTRUCT: ARRAY/TYPE/CLASS/LIST/DICT/SET runtime modeli

Her lane hucresi matriste YOK/KISMEN/PLAN -> OK donusumuyle izlenir.

## 2) Katman Modeli

### 2.1 AST
- Kaynak sadakati ve parse agaci
- Source span, node kind, token baglantisi

### 2.2 HIR
- Scope, symbol table, type binding
- Komutlarin semantik denetimi
- Kontrol akis dugumleri: IF, SELECT, FOR, DO, CALL

### 2.3 MIR
- Basic block tabanli temsil
- Acik branch/call/load/store islemleri
- Backend bagimsiz, test edilebilir ara format

### 2.4 Runtime
- MIR veya AST tabanli evaluator (gecis doneminde AST eval surer)
- Statement execution contract
- Intrinsic execution contract

## 3) Fazli Uygulama Plani

### Faz R0 - Baseline Dondurma
Kapsam:
- Mevcut yesil test seti sabitlenir.
- Gap matrix referansi cikarilir.

Kabul:
- tools/run_faz_a_gate.ps1 PASS
- reports/uxbasic_operasyonel_eksiklik_matrisi.md olusturulmus ve dogrulanmis

### Faz R1 - Akis + Konsol I/O Runtime Tamamlama
Kapsam:
- IF_STMT runtime
- SELECT_STMT runtime
- SELECT CASE icin CASE IS iliskisel dal semantigi
- PRINT_STMT runtime
- INPUT_STMT ve INPUT_FILE_STMT runtime
- CLS/COLOR/LOCATE runtime minimum kontrat (terminal uyumlu)
- INKEY/GETKEY, LOF/EOF gibi temel runtime intrinsics (non-blocking/minimum)

Kabul:
- Yeni testler:
  - tests/run_flow_io_exec_ast.bas
  - tests/run_if_exec_ast.bas
  - tests/run_input_exec_ast.bas
  - tests/run_case_is_exec_ast.bas
- Faz A gate icine yeni kosucular eklenir

Durum Notu:
- CASE IS iliskisel dali parser+runtime+test kapsami ile D/P/S/R/T=OK seviyesine cekildi.
- LOCATE/COLOR/CLS minimum kontrati deterministic runtime-state testleri ile D/P/S/R/T=OK seviyesine cekildi.

  ### Faz R1.M - INKEY/GETKEY + LOF/EOF Mini Iterasyon (Kapanis)
  Amac:
  - Matriste INKEY/GETKEY ve LOF/EOF satirlarini R1 kapsaminda D/P/S/R/T = OK seviyesine kapatmak.

  Kod adimlari:
  1. src/runtime/memory_exec.fbs
    - INPUT deterministic kuyruk modeline paralel bir key-event kuyruk API'si ekle:
      - ExecDebugKeyQueueClear
      - ExecDebugKeyQueuePush
      - ExecDebugKeyQueuePop
    - INKEY(flags[, state]) ve GETKEY() cagri yollarini ortak non-blocking okuyucuda birlestir.
    - INKEY ikinci arguman verildiginde state bitmask yazimini deterministic yap.
  2. src/runtime/memory_exec.fbs
    - LOF/EOF icin handle/channel guard ve hata metni davranisini ortak helper ile normalize et.

  Test adimlari:
  1. tests/run_runtime_intrinsics.bas
    - INKEY/GETKEY icin key var/yok ve state yazimi senaryolari ekle.
    - LOF/EOF icin happy-path + closed-channel fail-fast assertionlari ekle.
  2. tools/run_faz_a_gate.ps1
    - run_runtime_intrinsics kosucusunun R1.M kanit kapisinda zorunlu oldugunu koru.

  Dokuman adimlari:
  1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
    - INKEY/GETKEY ve LOF/EOF satirlarini R1.M kapanis kriterine gore guncelle.
  2. yapilanlar.md
    - R1.M sonucu, test ID'leri ve gate kaniti append-only kaydet.

  Kanit komutlari:
  - cmd /c build_64.bat tests\run_runtime_intrinsics.bas
  - cmd /c tests\run_runtime_intrinsics_64.exe
  - powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

  Kapanis kriteri:
  1. INKEY/GETKEY satiri OK/OK/OK/OK/OK olmalidir.
  2. LOF/EOF satiri OK/OK/OK/OK/OK olmalidir.
  3. Faz A gate PASS olmadan matris satiri OK'a cekilmez.
  Durum:
  - Tamamlandi. INKEY/GETKEY deterministic key queue + state yazimi ve LOF/EOF happy-path + closed-channel fail-fast testleri PASS.

### Faz R2 - Cagri ve Kontrol Akisi Derinlestirme
Kapsam:
- SUB/FUNCTION call modeli
- CALL_STMT sadece builtin degil user symbol da destekler
- GOTO/GOSUB/RETURN runtime modeli
- END_STMT davranisi
- Yerel (user-defined) fonksiyonlar icin scope + activation record modeli

Kabul:
- Yeni testler:
  - tests/run_call_user_exec_ast.bas
  - tests/run_jump_exec_ast.bas
  - tests/run_end_exec_ast.bas
- Parse-semantic-runtime tutarlilik raporu

### Faz R2.M - END_STMT Satirini OK'a Cekme Mini Iterasyon (Tamamlandi)
Sonuc:
- Operasyonel matriste `END` satiri R2 kapsaminda D/P/S/R/T = OK/OK/OK/OK/OK seviyesine cekildi.

Kod kapsami:
1. tests/run_end_exec_ast.bas
  - END'in dongu/if icinden cagrildiginda top-level statement akisini sonlandirdigi deterministic olarak dogrulandi.
  - END'in user-call context icinde (callee icinde END) hem callee kalan adimlarini hem caller devamini durdurdugu dogrulandi.
  - IF/SELECT bloklari icinde END sinyali olustuktan sonra sonraki statement'larin sinyali ezmemesi icin short-circuit guard davranisi dogrulandi.
  - Argumanli END formlari icin parse fail-fast (`END 1`, top-level `END IF`) dogrulandi.

Dokuman kapsami:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - `END` satiri S kolonu dahil tam OK seviyesine cekildi.
2. yapilanlar.md
  - R2.M sonucu test/gate kanitlariyla append-only kaydedildi.

Kanit komutlari:
- cmd /c build_64.bat tests\run_end_exec_ast.bas
- cmd /c tests\run_end_exec_ast_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. `END` satiri OK/OK/OK/OK/OK olmalidir.
2. `run_end_exec_ast_64.exe` PASS olmadan satir OK'a cekilmez.
3. Faz A gate PASS olmadan satir OK'a cekilmez.

### Faz R2.N - GOTO/GOSUB/RETURN Semantik Kapanis Mini Iterasyon (Tamamlandi)
Sonuc:
- Operasyonel matriste `GOTO`, `GOSUB` ve `RETURN` satirlari R2 kapsaminda D/P/S/R/T = OK/OK/OK/OK/OK seviyesine cekildi.

Kod kapsami:
1. tests/run_jump_exec_ast.bas
  - Mevcut pozitif jump/call-stack senaryolari korundu.
  - `GOTO Missing` ve `GOSUB Missing` icin deterministic fail-fast assertionlari eklendi.
  - Duplicate top-level label fail-fast (`duplicate LABEL`) assertioni eklendi.
  - User-call context icinden jump transfer denemesi icin guard assertioni (`unsupported control transfer inside user call`) eklendi.
2. tests/run_return_exec_ast.bas
  - Dengesiz RETURN fail-fast kapsami korunarak R2.N kapanis kanitina dahil edildi.

Dokuman kapsami:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - `GOTO/GOSUB/RETURN` satirlarinda S kolonu `KISMEN -> OK` cekildi.
2. yapilanlar.md
  - R2.N sonucu test/gate kanitlariyla append-only kaydedildi.

Kanit komutlari:
- cmd /c build_64.bat tests\run_jump_exec_ast.bas
- cmd /c tests\run_jump_exec_ast_64.exe
- powershell -ExecutionPolicy Bypass -File tools\validate_test_naming.ps1
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. `GOTO`, `GOSUB`, `RETURN` satirlari OK/OK/OK/OK/OK olmalidir.
2. `run_jump_exec_ast_64.exe` ve `run_return_exec_ast_64.exe` PASS olmadan satirlar OK'a cekilmez.
3. Faz A gate PASS olmadan satirlar OK'a cekilmez.

### Faz R2.O - Dotted CALL_EXPR Parser/Runtime Mini Iterasyon (Tamamlandi)
Sonuc:
- Dotted method cagrilarinin expression baglaminda parser+runtime yolu aktive edildi (`obj.Method(...)`, `Class.Method(...)`).

Kod kapsami:
1. src/parser/parser/parser_expr.fbs
  - ParsePrimary yolu dotted call_expr token dizisini taniyacak sekilde guncellendi.
  - member-access call-disi form icin deterministic fail-fast mesaji eklendi.
2. tests/run_class_method_dispatch_call_expr_exec_ast.bas
  - CALL ve CALL_EXPR karmasi dispatch stress senaryolari eklendi.
3. tools/run_faz_a_gate.ps1
  - run_class_method_dispatch_call_expr_exec_ast_64 build/run adimlari gate'e eklendi.

Kanit komutlari:
- cmd /c build_64.bat tests\run_class_method_dispatch_call_expr_exec_ast.bas
- cmd /c tests\run_class_method_dispatch_call_expr_exec_ast_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. Dotted CALL_EXPR parser yolu parse fail olmadan calismalidir.
2. Yeni stress kosucusu PASS olmadan satir ilerlemesi yapilmaz.
3. Faz A gate PASS olmadan kapanis yapilmaz.

### Faz R3 - Veri Alani ve Tanim Komutlari
Kapsam:
- DIM/REDIM runtime model
- DEF* ve SETSTRINGSIZE runtime etkisi
- CLASS semantigi (TYPE tabanli mvp map)
- ARRAY runtime bounds/model

Kabul:

### Faz R3.M - DIM ve CONST Runtime Kapanışı (Tamamlandı)

Sonuç:
- Operasyonel matriste `DIM` ve `CONST` satırları R3 kapsamında R kolonu YOK'tan OK'ya çekildi.

Kod kapsami:
1. tests/run_dim_const_test.bas
  - DIM statement runtime modeli ve CONST compile-time + runtime etkileşimi doğrulandı.

Dokuman kapsami:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - `DIM` satırı R kolonu YOK -> OK çekildi.
  - `CONST` satırı R kolonu YOK -> OK çekildi.
2. yapilanlar.md
  - R3.M sonucu test/gate kanıtlarıyla append-only kaydedildi.

Kanit komutları:
- cmd /c build_64.bat tests\run_dim_const_test.bas
- cmd /c tests\run_dim_const_test_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanış kriteri:
1. `DIM` satırı R kolonu OK olmalı.
2. `CONST` satırı R kolonu OK olmalı.
3. `run_dim_const_test_64.exe` PASS olmadan satırlar OK'a çekilmez.
4. Faz A gate PASS olmadan satırlar OK'a çekilmez.
- Yeni testler:
  - tests/run_dim_redim_exec_ast.bas
  - tests/run_class_runtime_exec_ast.bas
  - tests/run_class_method_dispatch_exec_ast.bas
  - tests/run_class_access_friend_parse.bas

### Faz R3.N - DIM/REDIM MVP + Fail-Fast Mini Iterasyon (Tamamlandi)
Sonuc:
- Operasyonel matriste `DIM` satiri S kolonu `KISMEN -> OK` cekilerek `OK/OK/OK/OK/OK` seviyesine getirildi.
- Operasyonel matriste `REDIM` satiri S ve T kolonlari `KISMEN/YOK -> OK` cekildi; R kolonu kapsam disi ozellikler nedeniyle `KISMEN` korundu.

MVP kapsami:
1. `DIM x AS I32` ve `DIM arr(0 TO n) AS I32` (tek boyut, numeric) parser+semantic+runtime yolu.
2. `REDIM arr(0 TO n) AS I32` (tek boyut, no-PRESERVE) runtime yeniden boyutlama yolu.
3. Runtime sinir denetimi: out-of-bounds erisimin deterministic fail-fast vermesi.

Kapsam disi (R3.N disinda):
1. `REDIM PRESERVE`.
2. Cok boyutlu stride optimizasyonu.
3. String/UDT dizi icin ozel tasima/yeniden ayirma semantigi.
4. Dynamic bounds ifadesi (runtime expression ile boyut hesaplama).

Fail-fast kurallari:
1. `DIM` ayni scope icinde duplicate isimde semantic hata vermelidir.
2. `DIM/REDIM` bounds ifadesinde `lower > upper` semantic hata vermelidir.
3. `DIM/REDIM` toplam byte hesaplamasinda tasma olursa runtime fail-fast vermelidir.
4. `REDIM` sadece daha once dizi olarak tanimlanmis sembolde calismalidir; aksi semantic hata.
5. `REDIM` boyut sayisi/eleman tipi mevcut tanimla uyusmuyorsa semantic hata.
6. `REDIM PRESERVE` goruldugunde acik "unsupported in R3.N" fail-fast hatasi.

Kolon hedefi (tek iterasyon):
1. `DIM` satiri: D/P/R/T korunur, `S -> OK`.
2. `REDIM` satiri: D/P korunur, `S -> OK`, `T -> OK`, `R` kapsam disi ozellikler nedeniyle `KISMEN` kalir.

Kod kapsami:
1. src/runtime/memory_exec.fbs
  - DIM/REDIM runtime evaluator parser AST deklarasyon modeliyle hizalandi (`DIM_DECL`/`REDIM_DECL`).
  - Tek-boyut array MVP fail-fast kurallari eklendi: duplicate DIM, invalid bounds, byte overflow, undeclared/scalar REDIM, type mismatch.
  - ExecRunStmt icindeki cift `REDIM_STMT` dispatch cakisimi kaldirildi.
2. src/parser/parser/parser_stmt_decl.fbs
  - `REDIM PRESERVE` icin explicit parse fail-fast (`REDIM PRESERVE unsupported in R3.N`) eklendi.
3. tests/run_dim_redim_exec_ast.bas
  - Happy-path + fail-fast assertionlari eklendi.
4. tools/run_faz_a_gate.ps1
  - `run_dim_redim_exec_ast_64` build/run adimlari gate'e eklendi.

Dokuman kapsami:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - R3.N sonucu satir gecisleri ve kanit notlari guncellendi.
2. tests/plan/command_compatibility_win11.csv
  - DIM/REDIM satirlari runtime+test referanslariyla guncellendi.

Kapanis kriteri:
1. `DIM` satirinda S kolonu OK'a cekildi.
2. `REDIM` satirinda S ve T kolonlari OK'a cekildi.
3. `run_dim_redim_exec_ast` PASS + Faz A gate PASS olmadan kolon gecisi yapilmaz.

### Faz R4 - Sayisal Model ve Float Cekirdegi
Kapsam:
- Integer + float promotion kurallari
- / operatoru floating bolme
- \\ operatoru integer bolme
- Float intrinsic runtime: SQRT, SIN, COS, TAN, ATN, EXP, LOG, CDBL, CSNG, FIX
- String/number intrinsic runtime: STR, UCASE, LCASE, MID, STRING, SPACE
- Operator ve typed-value gecisi: string donen intrinsicler icin deger modeli

Kabul:
- Yeni testler:
  - tests/run_numeric_model_exec_ast.bas
  - tests/run_float_intrinsics_exec_ast.bas
- Degerlendirme sirasi ve associativity test paketi

### Faz R4.M - RANDOMIZE + Pointer Intrinsics Mini Iterasyon (Kapanis)
Amac:
- Operasyonel matriste `RANDOMIZE` satirini D/P/S/R/T = OK seviyesine cekmek.
- `VARPTR/SADD/LPTR/CODEPTR` satirlarinda yalnizca T (test) kolonunu OK seviyesine cekmek.

Kod adimlari:
1. tests/run_runtime_intrinsics.bas
  - RANDOMIZE (seedli/seedsiz) runtime assertionlarinin deterministik kapsamini sabitle.
  - VARPTR/SADD/LPTR/CODEPTR icin ifade seviyesi smoke senaryolarini koru.
2. tests/plan/command_compatibility_win11.csv
  - RANDOMIZE ve pointer intrinsic satirlarindaki test-id baglarini referans kaynagi olarak sabitle.

Dokuman adimlari:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - RANDOMIZE satiri: D/P/S/R/T tum hucreleri OK.
  - VARPTR/SADD/LPTR/CODEPTR satirlari: T hucresi OK.
2. spec/IR_RUNTIME_MASTER_PLAN.md
  - R4.M mini iterasyonunun kapanis kriterlerini append-only sekilde kaydet.

Kanit komutlari:
- cmd /c build_64.bat tests\run_runtime_intrinsics.bas
- cmd /c tests\run_runtime_intrinsics_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. RANDOMIZE satiri OK/OK/OK/OK/OK olmalidir.
2. VARPTR/SADD/LPTR/CODEPTR satirlarinda T kolonu OK olmalidir.
3. run_runtime_intrinsics ve Faz A gate PASS olmadan matris satirlari OK'a cekilmez.

### Faz R5 - Koleksiyon Motoru
Kapsam:
- LIST/DICT/SET runtime mvp
- Temel api: add/get/set/remove/len

Kabul:
- tests/run_collections_exec_ast.bas PASS

### Faz FFI-1 - IMPORT First Wave + CALL(DLL) Policy Enforcement
Kapsam:
- IMPORT(C/CPP/ASM, file) resolver
- Dis toolchain compile + link orkestrasyonu
- ABI policy ve diagnostics
- CALL(DLL, ...) allowlist policy ENFORCE modunda fail-closed:
  - Policy file yukleme hatasi (dosya yok/acilamiyor/header gecersiz/entry yok) -> 9215 deny
  - Attestation gerekli/yok -> 9210 deny
  - Hash mismatch -> 9211 deny
  - Signer mismatch -> 9212 deny
  - Hash extraction fail -> 9213 deny
  - Signer extraction fail -> 9214 deny
  - Audit log: event=ffi_policy_decision

Kabul:
- C ve ASM importlu e2e senaryo PASS
- CALL(DLL) ENFORCE deny kodlari (9210..9215) test PASS
- C++ sadece extern C wrapper ile izinli

### Faz FFI-2 - INLINE Second Wave
Kapsam:
- INLINE(C, text) feature flag altinda
- Guvenlik, sandbox, deterministic build kurallari

Kabul:
- Flag kapali varsayilan
- Acik iken test + tanisal hata kapsami PASS

### Faz R6 - Program Yapisi + Meta-Komut Preprocess
Kapsam:
- NAMESPACE/MODULE/MAIN syntax ve END kapanis kurallari
- Scope kurallari: namespace/module gorunurlugu
- %% meta-komutlar icin preprocess katmani:
  - %%INCLUDE
  - %%DESTOS / %%PLATFORM
  - %%IF / %%ELSE / %%ENDIF
  - %%IFC
  - %%ENDCOMP / %%ERRORENDCOMP
  - %%NOZEROVARS / %%SECSTACK

Durum Notu (2026-04-13):
- Cekirdek preprocess lane aktif: %%INCLUDE ve %%IF/%%ELSE/%%ENDIF lexer preprocess katmaninda calisiyor.
- %%DEFINE/%%UNDEF kod yolu lexer preprocess katmaninda aktif ve dedicated test kapsaminda dogrulandi.
- Negatif kapsama genisletildi: missing %%INCLUDE fallback, inaktif branch include skip, duplicate %%ELSE davranisi.
- R6.N kapanisi ile %%IFC + %%ENDCOMP/%%ERRORENDCOMP preprocess yolunda aktif ve gate kanitli hale geldi.
- R6 kapsaminda acik kalanlar: %%DESTOS, %%PLATFORM, %%NOZEROVARS, %%SECSTACK.

Kabul:
- Yeni testler:
  - tests/run_percent_preprocess_exec.bas
  - tests/run_namespace_module_main_parse.bas
- Gate kosucusu: tools/run_faz_a_gate.ps1 icinde run_percent_preprocess_exec_64 zorunlu kosulur.
- Parse/semantic raporunda yapi kapanis uyumsuzluklari fail-fast yakalanir

### Faz R6.M - %% Preprocess Cekirdek Lane Negatif Kapsam Mini Iterasyon (Tamamlandi)
Sonuc:
- %%INCLUDE, %%DEFINE/%%UNDEF ve %%IF/%%ELSE/%%ENDIF icin mevcut implementasyon uzerine dusuk riskli negatif test kapsami eklendi.

Kod kapsami:
1. tests/run_percent_preprocess_exec.bas
  - missing %%INCLUDE fallback: parse/exec akisinin bozulmadigi ve sonraki satirlarin calistigi dogrulandi.
  - inaktif dalda %%INCLUDE skip: false branch icindeki include denemesinin etkisiz oldugu dogrulandi.
  - duplicate %%ELSE: yalnizca ilk ELSE dalinin aktif kaldigi dogrulandi.
  - %%UNDEF: aktif dalda tanimli makroyu temizleme ve inaktif dalda izolasyon davranisi dogrulandi.
  - nested %%IF/%%ELSE/%%ENDIF: kosul yigini tutarliligi dogrulandi.

Dokuman kapsami:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - %%INCLUDE, %%DEFINE/%%UNDEF ve %%IF/%%ELSE/%%ENDIF satirlari P/T=OK ve Not kolonu kanit referanslariyla guncellendi.

Kanit komutlari:
- cmd /c build_64.bat tests\run_percent_preprocess_exec.bas
- cmd /c tests\run_percent_preprocess_exec_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. run_percent_preprocess_exec PASS olmadan preprocess cekirdek lane satirlari P/T=OK'a cekilmez.
2. R6 acik kalemleri (%%DESTOS/%%PLATFORM/%%NOZEROVARS/%%SECSTACK) tamamlanmadan lane tam OK kabul edilmez.

### Faz R6.P - Preprocess Perf/Bellek Gozlem Mini Iterasyonu (Tamamlandi)
Sonuc:
- Dispatch, preprocess ve collection cluster kosuculari icin runtime perf/bellek baseline olculdu; timeout/fail gozlenmedi.

Kapsam komutlari:
- powershell -ExecutionPolicy Bypass -File tools/perf_runtime_benchmark.ps1 -Executables tests/run_call_user_exec_ast_64.exe,tests/run_class_method_dispatch_exec_ast_64.exe,tests/run_class_method_dispatch_call_expr_exec_ast_64.exe,tests/run_percent_preprocess_exec_64.exe,tests/run_collection_engine_exec_64.exe -Repeat 3 -TimeoutSeconds 30 -OutputCsv reports/runtime_perf_dispatch_preprocess_collections.csv
- powershell -ExecutionPolicy Bypass -File tools/runtime_memory_benchmark.ps1 -Executables tests/run_call_user_exec_ast_64.exe,tests/run_class_method_dispatch_exec_ast_64.exe,tests/run_class_method_dispatch_call_expr_exec_ast_64.exe,tests/run_percent_preprocess_exec_64.exe,tests/run_collection_engine_exec_64.exe -Repeat 3 -TimeoutSeconds 30 -OutputCsv reports/runtime_memory_dispatch_preprocess_collections.csv

Ozet:
1. Perf raporu: reports/runtime_perf_dispatch_preprocess_collections.csv
2. Bellek raporu: reports/runtime_memory_dispatch_preprocess_collections.csv
3. Tum kosucular 3/3 PASS, timeout/fail yok.

### Faz R6.N - %%IFC ve Derleyici Kontrol Komutlari Mini Iterasyon (Tamamlandi)
Amac:
- R6 acik kalan preprocess komutlarini fail-fast + temel davranis seviyesine cekmek.

Sonuc:
- Operasyonel matrisde %%IFC, %%ENDCOMP ve %%ERRORENDCOMP satirlari P/T kolonlarinda OK seviyesine cekildi.
- Lexer preprocess katmaninda bu direktiflerin handler yolu aktif oldugu kod+test+gate kaniti ile dogrulandi.

Kapsam:
1. %%IFC: sembol-karsilastirma tabanli kosullu dal secimi (preprocess).
2. %%ENDCOMP / %%ERRORENDCOMP: derleme sonlandirma komutlari icin deterministic fail-fast cekirdegi.

Kod kapsami:
1. src/parser/lexer/lexer_preprocess.fbs
  - %%IFC handler yolunda inaktif parent dal semantigi %%IF ile hizalandi; inaktif dalda malformed %%IFC satiri fail uretmeden stack akisini korur.
2. tests/run_percent_preprocess_ifc_exec.bas
  - %%IFC true/false branch, case-insensitive compare, aktif dal malformed fail-fast ve inaktif dal malformed ignore davranislari eklendi.
3. tests/run_percent_preprocess_control_failfast.bas
  - %%ENDCOMP early-stop, inaktif %%ENDCOMP ignore, %%ERRORENDCOMP mesajli/mesajsiz fail-fast ve inaktif %%ERRORENDCOMP ignore davranislari eklendi.
4. tools/run_faz_a_gate.ps1
  - run_percent_preprocess_ifc_exec_64 ve run_percent_preprocess_control_failfast_64 build/run adimlari gate'e zorunlu eklendi.

Dokuman kapsami:
1. reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - %%IFC / %%ENDCOMP / %%ERRORENDCOMP satirlari kod+test+gate kaniti ile P/T=OK seviyesine cekildi.
2. yapilanlar.md
  - R6.N kapanisi append-only kaydedildi.

Kanit hedefi:
- Yeni testler: tests/run_percent_preprocess_ifc_exec.bas, tests/run_percent_preprocess_control_failfast.bas
- Gate entegrasyonu: tools/run_faz_a_gate.ps1 icinde yeni kosucularin zorunlu calismasi.

Kapanis kriteri:
1. %%IFC satirinda P/T kolonlari OK olmalidir.
2. %%ENDCOMP/%%ERRORENDCOMP satirlarinda P/T kolonlari OK olmalidir.
3. Faz A gate PASS olmadan kolon gecisi yapilmaz.

## 4) Sayisal Model: Oncelik ve Birliktelik (Resmi)

Bu bolum parser ve runtime uyumlulugu icin normatif kabul edilir.

Oncelik yuksekten dusuge:

1. Parantez ve cagrilar: ()
2. Unary: +, -, NOT, @
3. Us alma: **
4. Carpma grubu: *, /, \\, MOD, %
5. Toplama grubu: +, -
6. Kaydirma/dondurme: <<, >>, SHL, SHR, ROL, ROR
7. Karsilastirma: =, <>, <, <=, >, >=
8. AND
9. XOR
10. OR

Birliktelik:

- Unary: sagdan sola
- **: sagdan sola
- Diger ikili operatorler: soldan saga

## 5) Float ve Promotion Kurallari

1. I* + I* islemi integer kalir (overflow kurali semantikte denetlenir).
2. I* ile F* birlikteyse sonuc en az F64 olur.
3. / daima floating bolme verir (en az F64).
4. \\ daima integer bolme verir.
5. MOD integer operatordur.
6. Karsilastirma sonucu mantiksal temsil: true = -1, false = 0 (mevcut runtime ile uyumlu).
7. Constant fold islemleri HIR seviyesinde ayni kurallara baglidir.

## 6) Test Stratejisi

Her yeni ozellik icin asgari:

1. Parse pozitif + parse negatif
2. Semantik pozitif + semantik negatif
3. Runtime pozitif + runtime negatif
4. Hata metni anahtar dogrulamasi

CI kurali:

- Yeni fazdan gelen test kosucusu tools/run_faz_a_gate.ps1 ve win64-ci icine eklenmeden faz kapatilamaz.

## 7) Riskler ve Onlemler

Risk:
- Dokuman parserdan hizli ilerlerse gercek disi kapsam olusur.
Onlem:
- Gap matrix tek dogruluk kaynagi olarak guncellenir.

Risk:
- Float model parca parca eklenirse sessiz davranis farki olur.
Onlem:
- Faz R4 oncesi numeric policy sabitlenir, sonra kodlama baslar.

Risk:
- C++ import dogrudan mangled sembole baglanir.
Onlem:
- extern C wrapper zorunlulugu.

## 8) Sonraki Uygulama Sirasi

1. R1 lane stabilizasyonu: PRINT separator zone-parity tamamlandi
2. R1.M mini iterasyon tamamlandi: INKEY/GETKEY + LOF/EOF satirlari OK
3. R2 lane: tam jump/call stack + SUB/FUNCTION local function model mvp tamamlandi; `END` satiri icin R2.M mini iterasyon kapanisi planlandi
4. R4 lane + R4.M mini iterasyon: float/promotion + typed-value genisleme tamamlandi; RANDOMIZE satiri tam OK'a cekildi, VARPTR/SADD/LPTR/CODEPTR icin test kolonu OK'a cekildi
5. FFI-1 lane: IMPORT pipeline
6. R6 lane: namespace/module/main + kalan %% preprocess komutlari (%%INCLUDE/%%DEFINE/%%UNDEF/%%IF/%%ELSE/%%ENDIF + %%IFC + %%ENDCOMP/%%ERRORENDCOMP aktif; acik kalemler: %%DESTOS/%%PLATFORM/%%NOZEROVARS/%%SECSTACK)

## 9) Otonom Paralel Ilerleme Protokolu

Bu plan, kullanici tekrar talep etmeden otomatik ilerleme modunda uygulanir:

1. Her turde en az 2 lane paralel ilerletilir.
2. Her tur sonunda yalnizca durum raporu verilir (genis tartisma degil).
3. Her kod adimi test + gate + matris guncellemesi ile kapanir.
4. Riskli degisimlerde lane ayrimi korunur, tek seferde buyuk kirici refactor yapilmaz.

## 10) Son Madde: CLASS OOP Ozellik Paketi

Bu bolum kullanici talebine gore son madde olarak eklenmistir.

Durum Notu (2026-04-13):
- CLASS lane'i parser/runtime/testte KISMEN seviyesinde aktif: tests/run_class_access_friend_parse.bas, tests/run_class_runtime_exec_ast.bas, tests/run_class_method_dispatch_exec_ast.bas, tests/run_class_method_dispatch_call_expr_exec_ast.bas.
- Class storage/layout ve access/friend parse semantigi mvp kapsaminda kanitli; method dispatch yolu da mevcut ancak METHOD keyword bildirimi + THIS/ME + ctor/dtor tamamlanmadigi icin lane tam OK degildir.
- Bu kosucular Faz A gate'te zorunlu calisiyor (tools/run_faz_a_gate.ps1; komut: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild).
- Dokuman matrisi gecisi (2026-04-13): OOP ilerlemesi yalnizca test kolonuna yansitildi; `reports/uxbasic_operasyonel_eksiklik_matrisi.md` icinde `CLASS` satirlarinda T kolonu `KISMEN -> OK` cekildi, S/R kolonlari `KISMEN` korundu.

OOP-P0:

1. KISMEN: PUBLIC/PRIVATE/RESTRICTED erisim parser + friend fail-fast semantigi aktif.
2. KISMEN: class instance storage/layout runtime mvp aktif.
3. KISMEN: class method dispatch mvp aktif; METHOD keyword bildirimi ve THIS/ME semantics henuz yok.

OOP-P1:

1. Constructor/Destructor acik yasam dongusu politikasi
2. Tekli inheritance mvp (base->derived layout kurali)

OOP-P2:

1. VTable ve polimorfik dispatch
2. Interface sozlesme denetimi

Kabul Kriterleri:

1. OOP-P0 satirinin OK kapanisi icin METHOD keyword bildirimi + THIS/ME + runtime erisim denetimi tamamlanmis olmalidir.
2. Her OOP adimi icin parse+semantic+runtime+negative test zorunludur.
3. Eski kodlarla feature-flag kapali modda regresyon sifir olmalidir.

## 11) OOP Anahtarlarinin Erken Faz Dagilimi (Hizli Tartisma Sonucu)

Bu bolum, OOP paketini planin sonuna birakmadan onceki fazlara dagitir.

Sprint OOP-1 (R2 ile paralel):

1. CLASS_FIELD + FIELD sozdizimi birlestirme
2. METHOD bildirimi (SUB/FUNCTION baglama)
3. PUBLIC/PRIVATE metadata + compile-time erisim denetimi

Sprint OOP-2 (R3 ile paralel):

1. CONSTRUCTOR/DESTRUCTOR bildirim ve cagri kurali
2. NEW/DELETE runtime lite
3. THIS temel baglam modeli

### Faz R3.O - CLASS MVP Stabilizasyon Mini Iterasyonlari (Planli)

R3.O1 - METHOD baglami + THIS/ME:
1. METHOD bildirimi ile SUB/FUNCTION baglama semantigini netlestir.
2. Dotted dispatch cagrilarinda receiver baglamini THIS/ME sembollerine aktar.
3. Test hedefi: tests/run_class_method_dispatch_exec_ast.bas + yeni tests/run_class_this_me_failfast.bas.

R3.O2 - Constructor/Destructor lite:
1. CONSTRUCTOR/DESTRUCTOR parse ve semantik kurallarini (tek ctor, opsiyonel dtor) tanimla.
2. Instance olusumunda ctor, omur sonlandirmada dtor cagrisi icin minimum runtime kontrati ekle.
3. Test hedefi: yeni tests/run_class_ctor_dtor_exec_ast.bas.

R3.O3 - OOP satir gecis politikasi:
1. METHOD ve THIS/ME satirlari, dedicated test + Faz A gate kaniti olmadan OK'a cekilmez.
2. Constructor/Destructor satiri, en az bir pozitif + bir negatif senaryo PASS olmadan YOK'tan KISMEN'e cekilmez.

Sprint OOP-3 (R3-R4 arasi):

1. EXTENDS tekli kalitim mvp
2. ABSTRACT/FINAL/SEALED denetimi
3. PROTECTED ve OVERRIDE signature denetimi

Sprint OOP-4 (R4-R5 arasi):

1. INTERFACE/IMPLEMENTS sozlesme denetimi
2. SUPER cagri semantigi
3. INSTANCEOF runtime kontrolu

Sprint OOP-5 (R5+):

1. VIRTUAL + vtable dispatch
2. OPERATOR overload
3. MIXIN/DECORATOR/sihirli metotlar

Not:

- NAMESPACE/MODULE/MAIN ve %% preprocess altyapisi OOP erisim semantigini etkiledigi icin R6 ile paralel yurur.

## 12) R6 Semantik Onerisi (Normatif Kisa Surum)

Bu bolum, R6 uygulamasi icin baglayici semantik taslagi tanimlar.

### 12.1 MAIN ... END MAIN Giris Kurallari

Normatif kurallar:

1. Programda en fazla bir adet etkin giris noktasi OLMALIDIR.
2. Etkin giris noktasi su sirayla secilmelidir:
  - Acik `MAIN ... END MAIN` blogu varsa bu blog giristir.
  - Acik `MAIN` blogu yoksa legacy ust-duzey statement akisi giris kabul edilir.
3. Acik `MAIN` blogu varken ust-duzeyde executable statement bulunmasi semantik hatadir.
4. `MAIN` anahtar kelimesi soft-keyword olarak ele alinmalidir; `SUB Main()` gibi mevcut adlandirmalari kirici bicimde rezerve ETMEMELIDIR.
5. `MAIN` blogu sadece global program kapsaminda tanimlanabilir; `NAMESPACE` veya `MODULE` icinde tanimlanamaz.

Kenar durumlar:

1. Birden fazla `MAIN ... END MAIN` tanimi: fail-fast semantic hata.
2. Bos `MAIN` blogu: gecerlidir, exit code `0`.
3. `END` komutu `MAIN` icinde programi sonlandirir; `END MAIN` normal blok kapanisidir.

### 12.2 NAMESPACE, USING, MODULE Iliskisi

Normatif kurallar:

1. `NAMESPACE` isim cozumleme kapsami saglar; fiziksel dosya birimi degildir.
2. `MODULE` fiziksel/lojik birimdir; bir `MODULE` en fazla bir `NAMESPACE` icinde bulunabilir.
3. `USING X` mevcut scope'a ad kopyalamaz, sadece gecici isim cozumleme adimi ekler.
4. Cakisan adlar icin cozumleme onceligi su olmalidir:
  - local scope
  - aktif module scope
  - USING ile eklenen scope'lar (yazim sirasina gore)
  - global scope
5. `USING` nedeniyle olusan coklu aday durumlari "ambiguous symbol" hatasi vermelidir.

Kenar durumlar:

1. `END MODULE` / `END NAMESPACE` kapanis uyusmazligi: parse fail-fast.
2. `USING` ile ayni sembol birden cok kaynaktan gorunuyorsa yalnizca nitelikli ad (qualified name) kabul edilir.

Legacy INCLUDE/IMPORT uyumluluk notu:

1. `INCLUDE` mevcut davranisla uyumlu kalir: parse oncesi/erken asamada include-once cozumlenir ve dahil edilen icerik bulundugu noktaya yerlestirilmis gibi davranir.
2. `IMPORT(C/CPP/ASM, file)` isim alani acmaz; yalnizca build manifest/link artefakti uretim akisina bilgi tasir.
3. Eski include/import dosya sirasi semantigi korunur; R6 kurallari bu sirayi degistirmez.

Yapi-meta notu:

1. `MAIN/NAMESPACE/MODULE/ALIAS` preprocess (`%%`) komutu DEGILDIR; parser+semantic katmaninda islenen yapi-meta direktifleridir.
2. `%%` ile baslayan komutlar ise preprocess katmaninda calisir ve AST oncesi donusum yapar.

Dis kod baglanti semantigi (IMPORT + MODULE):

1. `IMPORT(C/CPP/ASM, file)` derleme baglamina dis artefakt ekler; tek basina isim alani acmaz.
2. Dis kaynaklardan gelen semboller, aktif `MODULE` altinda toplanir ve tercihen bir `NAMESPACE` icinde disariya verilir.
3. Acik `MAIN` kullanilan programlarda dis kod baglanti bildirimleri `MODULE ... END MODULE` icinde tutulmasi ONERILIR.
4. `INCLUDE` ve `%%INCLUDE` ile alinan BASIC kodu text-level dahil edilir; otomatik yeni namespace acmaz.

### 12.3 RESTRICTED ve FRIEND Catisma Onleme Modeli

Normatif kurallar:

1. `RESTRICTED`: Erisim, tanimlandigi `NAMESPACE` ile sinirlidir.
2. `FRIEND`: Sadece ayni `NAMESPACE` icindeki belirli module'lere acik istisna listesi tanimlar.
3. `PUBLIC/PRIVATE/RESTRICTED` gorunurluk belirtecinden yalnizca biri kullanilabilir.
4. `FRIEND` tek basina gorunurluk belirteci degildir; `PRIVATE` veya `RESTRICTED` ile birlikte "ek izin" olarak kullanilir.
5. `PUBLIC + FRIEND` kombinasyonu gecersizdir (anlamsal tekrar).
6. `RESTRICTED`, yalnizca ayni proje derleme birimindeki (aynı root graph) ayni namespace uyelerine aciktir; dis import graph otomatik kapsama girmez.
7. `INCLUDE/%%INCLUDE` ile gelen kod, cagirildigi module kimligini devralir; bu nedenle erisim kapsamini genisletmez.

Kenar durumlar:

1. `FRIEND` listesinde farkli namespace module'u: semantic hata.
2. Ayni hedef birden cok kez listelenirse tekil kabul edilir, uyari verilir.
3. `USING` bildirimi `RESTRICTED/FRIEND` sinirlarini genisletemez.

Onerilen cakismasiz erisim hiyerarsisi:

1. `PRIVATE` (module/class ici)
2. `PRIVATE + FRIEND` (secili module istisnasi)
3. `RESTRICTED` (namespace+project siniri)
4. `RESTRICTED + FRIEND` (daraltilmis/ozel istisna)
5. `PUBLIC` (evrensel)

### 12.4 ALIAS Komutu: Komut/Fonksiyon/Blok/FFI

Normatif kurallar:

1. `ALIAS` compile-time cozumlenen bir ad esleme mekanizmasidir; runtime dynamic dispatch degildir.
2. Asagidaki hedef turleri desteklenmelidir:
  - command
  - function
  - block
  - ffi target
3. Alias zinciri en fazla 4 adim olabilir.
4. Alias dongusu (A->B->A) fail-fast semantic hata olmalidir.
5. Function ve ffi aliaslarinda imza uyumlulugu zorunludur.
6. FFI alias hedefi yalnizca allowlist policy'de kayitli export kaydina baglanabilir; alias ile serbest DLL/sembol uretilemez.

Kenar durumlar:

1. Alias adinin mevcut keyword/semantic token ile cakismasi: hata.
2. Block alias yalnizca tanimli blok ciftlerine (acilis+kapanis) eslenebilir; tek tarafli esleme gecersizdir.
3. Hedef bulunamazsa parse degil semantic asamada hata uretmelidir.

Ornek kullanim modeli (normatif niyet):

1. Uzun nitelikli adlari tek adla sabitlemek icin `ALIAS yeni = eski`.
2. `CALL(DLL, ...)` tanimlarini dogrudan her yerde tekrar etmek yerine once policy+alias ile kayitlayip kodda kisa adla cagirmak.
3. Aliaslar namespace icinde tutulur; baska namespace'e gecis ancak nitelikli ad veya `USING` ile olur.

### 12.5 CALL(DLL, ...) Runtime ve Imza Modeli

Normatif kurallar:

1. Canonical cagri formu korunur:
  - `CALL(DLL, "kutuphane", "sembol", imza, arg1, ...)`
2. Win11 x64 profilinde varsayilan ABI `win64` kabul edilir.
3. Imza tanimlayici asgari su tipleri icermelidir:
  - `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYREF`
4. Runtime, cagridan once su dogrulamalari YAPMALIDIR:
  - arg count ve tip uyumu
  - byref hedefinin adreslenebilir olmasi
  - string ownership/omur kurali
  - allowlist izin kontrolu
  - dll path canonicalization + guvenli yukleme siniri
  - dosya hash ve signer dogrulamasi (policy enforce modunda)
5. `CALL(DLL, ...)` basarisizliginda deterministik hata kodu + audit log satiri zorunludur.

Kenar durumlar:

1. DLL yuklenemedi / sembol bulunamadi: ayri hata kodlari.
2. Imza gecersiz ama arguman sayisi dogru: imza-hatasi oncelikli raporlanir.
3. `BYREF` icin literal verilmesi: semantic hata (runtime'a birakilmaz).
4. Pointer parametreleri varsayilan kapali olabilir; yalnizca policy ile acilan exportlarda etkinlesir.

### 12.6 Gecis (Migration) Stratejisi - Kirilimsiz

1. Asama-1 (Uyumluluk modu varsayilan):
  - Legacy ust-duzey akis + mevcut `INCLUDE/IMPORT` davranisi degismeden calisir.
  - `MAIN/NAMESPACE/MODULE/USING/ALIAS/CALL(DLL)` yalnizca feature-flag acikken etkinlesir.
2. Asama-2 (Cift-yol dogrulama):
  - Ayni test seti legacy ve yeni modda kosulur.
  - Cikti/hata kodu farklari raporlanir, otomatik kirici gecis yapilmaz.
3. Asama-3 (Yonlendirmeli gecis):
  - Acik `MAIN` olmayan ama legacy executable iceren dosyalara bilgi seviyesinde migration uyarisi verilir.
  - Auto-fix onerisi: executable govdeyi `MAIN ... END MAIN` icine tasima.
4. Asama-4 (Sikilastirma):
  - Yeni projelerde acik `MAIN` tercih edilen mod olur.
  - Legacy mod sadece bayrakla acilir; include/import semantigi korunmaya devam eder.

Ek gecis notu:

1. `ALIAS` ve `CALL(DLL, ...)` once report-only policy modunda acilir, deny nedenleri loglanir.
2. Guvenlik regressyonu yoksa enforce moduna gecilir.

Kabul kriteri (R6 semantik kapisi):

1. Parse+semantic+runtime negatif testleri her 5 baslik icin zorunlu.
2. Legacy include/import regresyonu sifir olmalidir.
3. Alias cycle, ambiguous using, friend-disi erisim ve invalid ffi signature testleri fail-fast yakalanmalidir.
