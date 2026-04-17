# uXBasic Operasyonel Eksiklik Matrisi

Tarih: 2026-04-13
Amac: Dil yuzeyini katman bazli olarak (dokuman -> parser -> semantik -> runtime -> test) izlemek ve kapatma sirasini netlestirmek.

Bu dosya kanonik operasyonel matristir. Durum takipleri yalnizca burada guncellenir.
Plan kaynagi: `plan.md`
Kapanan is kaynagi (append-only): `yapilanlar.md`

## 1) Durum Anahtari

- D: Dokuman durumu
- P: Parser durumu
- S: Semantik durumu
- R: Runtime durumu
- T: Test durumu

Degerler:

- OK: Calisiyor / dogrulandi
- KISMEN: Kismen var, sinirli veya uyumsuz
- YOK: Uygulama yok
- PLAN: Planlandi, henuz kodlanmadi

## 0) Durum Ozeti (2026-04-12, Siki Mod)

Siki mod kaniti:
- powershell -ExecutionPolicy Bypass -File tools/validate_module_quality_gate.ps1 -Strict -> PASS (0 warning, 0 error)
- powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild -> PASS (regresyon yok)

Siki modda acik kalan yapisal eksikler:
1. Siki modda yapisal warning kalmadi (strict gate PASS).

Bu turdaki modulerlestirme sonucu:
1. layout tek dosya modeli 3 fiziksel modula ayrildi:
  - src/semantic/layout/layout_type_table.fbs
  - src/semantic/layout/layout_path_resolution.fbs
  - src/semantic/layout/layout_intrinsic_validation.fbs
2. declaration parser tek dosya modeli 3 fiziksel modula ayrildi:
  - src/parser/parser/parser_stmt_decl_core.fbs
  - src/parser/parser/parser_stmt_decl_scope.fbs
  - src/parser/parser/parser_stmt_decl_proc.fbs
3. declaration dispatch registry baglanti noktasi ayrildi:
  - src/parser/parser/parser_stmt_decl_dispatch.fbs
4. Yapisal warning sayisi 12 -> 10 dusuruldu.

Matristeki acik urun eksikleri (D/P/S/R/T):
1. EXIT IF: KISMEN/OK/OK/OK/OK
2. FLOATING POINT: YOK/YOK/YOK/YOK/YOK
3. IMPORT(C/CPP/ASM, file): OK/OK/KISMEN/OK/OK
4. INLINE(...): OK/OK/KISMEN/OK/KISMEN
5. LIST/DICT/SET: KISMEN/OK/KISMEN/KISMEN/OK
6. CLASS derin semantigi/runtime: KISMEN seviyesinde
7. %% meta-komutlar: cekirdek lane (%%INCLUDE, %%DEFINE/%%UNDEF, %%IF/%%ELSE/%%ENDIF) P/T=OK; kalanlar YOK

Sikilastirma hedefi:
- Debt-cap toleransini asamali azaltip warningleri kademeli olarak zorunlu kapanis kalemine cevirmek.

## 2) Komut Matrisi (Statement)

| Komut | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| PRINT | OK | OK | OK | OK | OK | Runtime `,`/`;` ayrimi + 14-col zone-parity ve trailing newline suppress dogrulandi | R1 |
| INPUT | OK | OK | OK | OK | OK | INPUT parser/runtime semantigi + semantic pass dogrulamasi aktif (tests/run_input_exec_ast.bas; tests/run_w1_semantic_pass.bas) | R1 |
| IF / ELSEIF / ELSE / END IF | OK | OK | OK | OK | OK | IF/ELSEIF semantik kontrati semantic pass ile dogrulandi (tests/run_if_exec_ast.bas; tests/run_w1_semantic_pass.bas) | R1 |
| SELECT CASE / CASE / CASE ELSE / END SELECT | OK | OK | OK | OK | OK | SELECT CASE selector/case varlik semantigi semantic pass ile dogrulandi (tests/run_case_is_exec_ast.bas; tests/run_w1_semantic_pass.bas) | R1 |
| CASE IS | OK | OK | OK | OK | OK | CASE IS iliskisel parser/runtime modeli fail-fast parse kurallari ve test kosucusuyla dogrulandi | R1 |
| EXIT FOR | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| EXIT DO | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| EXIT IF | OK | OK | OK | OK | OK | EXIT IF parser/runtime + IF disi kullanim fail-fast dogrulandi (tests/run_exit_if_byval_parse_exec.bas) | R1 |
| FOR / NEXT | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| FOR EACH / NEXT | OK | OK | OK | OK | OK | Stride capraz dogrulandi | B2 tamam |
| DO / LOOP | OK | OK | OK | OK | OK | DO_WHILE/UNTIL, LOOP_WHILE/UNTIL var | B2 tamam |
| DO EACH / LOOP | OK | OK | OK | OK | OK | Destekli (parser/runtime kapsami aktif) | B2 tamam |
| GOTO | OK | OK | OK | OK | OK | Jump hedef cozumleme + missing-target fail-fast ve duplicate-label guard testleri ile semantik kapanis dogrulandi | R2 |
| GOSUB | OK | OK | OK | OK | OK | Call stack push/pop + missing-target fail-fast ile semantik kapanis dogrulandi | R2 |
| RETURN | OK | OK | OK | OK | OK | GOSUB icinde donus + dengesiz RETURN fail-fast ve jump-context guard testleri ile semantik kapanis dogrulandi | R2 |
| CALL | OK | OK | OK | OK | OK | Builtin + user-defined dispatch modeli ve arity fail-fast eklendi | R2 |
| END | OK | OK | OK | OK | OK | END_STMT semantigi (dongu/if/select + user-call context propagation) ve parse fail-fast (argumanli END) dedicated test/gate kaniti ile kapatildi | R2.M |
| TRY/CATCH/FINALLY/END TRY | OK | PLAN | PLAN | PLAN | PLAN | Structured exception handling lane acilacak. Catch tipi + finally garanti calisma sozlesmesi eklenecek. | ERR-1 |
| THROW | OK | PLAN | PLAN | PLAN | PLAN | Runtime kontrolu: THROW code[, message[, detail]]. Parser/semantic arity/type guard ve stack unwinding lane'i acik. | ERR-1 |
| ASSERT | OK | PLAN | PLAN | PLAN | PLAN | ASSERT expr[, message] fail-fast + test mode davranisi tanimlandi, kod uygulamasi acik. | ERR-2 |
| DECLARE SUB/FUNCTION | OK | OK | OK | OK | OK | Runtime resolver declare/def ile uyumlu; ileri signature semantigi acik | R2 |
| SUB / FUNCTION | OK | OK | OK | OK | OK | Parametre tekrar ve FUNCTION return-type semantik kontrati semantic pass ile zorunlu (tests/run_call_user_exec_ast.bas; tests/run_w1_semantic_pass.bas) | R2 |
| CONST | OK | OK | OK | OK | OK | CONST isim/RHS semantik kontrati semantic pass ile fail-fast (tests/run_dim_const_test.bas; tests/run_w1_semantic_pass.bas) | R3 |
| DIM | OK | OK | OK | OK | OK | DIM_DECL tabanli runtime semantigi (duplicate/bounds/fail-fast) dedicated test ile kapatildi | R3.N |
| REDIM | OK | OK | OK | OK | OK | REDIM_DECL runtime yolu tek/cok-boyut bounds + PRESERVE semantigi ile dogrulandi; fail-fast kapsami korunuyor (tests/run_dim_redim_exec_ast.bas) | R3.N |
| TYPE | OK | OK | OK | OK | OK | Runtime no-op + layout var | B2 tamam |
| CLASS | OK | OK | OK | OK | OK | CLASS parse/semantic/runtime mvp zinciri (storage/layout, ctor/dtor invoke, access/friend, dotted dispatch ve CALL_EXPR) test ve gate kosuculariyla dogrulandi. | R3 |
| DEFINT/DEFLNG/DEFSNG/DEFDBL/DEFEXT/DEFSTR/DEFBYT | OK | OK | OK | OK | OK | DEFTYPE range semantigi + runtime dispatch/fail-fast testleri dogrulandi (tests/run_deftype_setstringsize_exec.bas) | R3 |
| SETSTRINGSIZE | OK | OK | OK | OK | OK | SETSTRINGSIZE numeric semantik fail-fast + runtime update/fail-fast testleri dogrulandi (tests/run_deftype_setstringsize_exec.bas) | R3 |
| FLOATING POINT | OK | OK | OK | OK | OK | Floating point runtime/evaluator yolu testle dogrulandi (tests/run_floating_point_exec.bas; tools/run_faz_a_gate.ps1) | R4 |
| INCLUDE | OK | OK | OK | OK | OK | Runtime no-op directive yolunda dogrulandi (tests/run_decl_directive_exec_ast.bas; tests/run_cmp_interop.bas) | R3 |
| IMPORT(C/CPP/ASM, file) | OK | OK | OK | OK | OK | Directive semantigi ve interop manifest/plan senaryolari testle dogrulandi (tests/run_decl_directive_exec_ast.bas; tests/run_cmp_interop.bas) | FFI-1 |
| INLINE(...) ... END INLINE | OK | OK | OK | OK | OK | INLINE parser/runtime akisi ve x64 backend dogrulama kosucusu PASS (tests/run_decl_directive_exec_ast.bas; tests/run_inline_x64_backend.bas) | FFI-2 |
| OPEN | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| CLOSE | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| GET | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| PUT | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| SEEK | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| LOCATE | OK | OK | OK | OK | OK | Runtime mvp + deterministic debug state testi ile semantik kontrat dogrulandi | R1 |
| COLOR | OK | OK | OK | OK | OK | Runtime mvp + deterministic debug state testi ile semantik kontrat dogrulandi | R1 |
| CLS | OK | OK | OK | OK | OK | Runtime mvp + deterministic debug state testi ile semantik kontrat dogrulandi | R1 |
| INC | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| DEC | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| RANDOMIZE | OK | OK | OK | OK | OK | Runtime random seed + semantik/test kapsami R4.M kapanisiyla dogrulandi | R4 |
| POKEB/POKEW/POKED | OK | OK | OK | OK | OK | Width semantigi var | B2 tamam |
| POKES | OK | OK | OK | OK | OK | Guarded VM string-to-memory yazimi dogrulandi (tests/run_memory_pointer_semantics.bas; tests/run_runtime_intrinsics.bas) | R3 |
| MEMCOPYB/W/D | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| MEMFILLB/W/D | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| SETNEWOFFSET | OK | OK | OK | OK | OK | Guarded pointer offset rebinding dogrulandi (tests/run_memory_pointer_semantics.bas; tests/run_runtime_intrinsics.bas) | R3 |

## 3) Fonksiyon Matrisi (Intrinsic)

| Fonksiyon | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| SIZEOF | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| OFFSETOF | OK | OK | OK | OK | OK | Indexed path dahil | B2 tamam |
| PEEKB/PEEKW/PEEKD | OK | OK | OK | OK | OK | Width semantigi aktif | B2 tamam |
| VARPTR | OK | OK | OK | OK | OK | Mutable-identifier semantik fail-fast ve CALL/CALL_EXPR arg-contract dogrulamasi + pointer contract testleri dogrulandi | R2 |
| SADD | OK | OK | OK | OK | OK | CALL/CALL_EXPR arg-contract semantik dogrulamasi ve pointer contract test kapsami ile dogrulandi | R2 |
| LPTR | OK | OK | OK | OK | OK | CALL/CALL_EXPR arg-contract semantik dogrulamasi ve pointer contract test kapsami ile dogrulandi | R2 |
| CODEPTR | OK | OK | OK | OK | OK | CALL/CALL_EXPR arg-contract semantik dogrulamasi ve pointer contract test kapsami ile dogrulandi | R2 |
| LEN | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| ABS | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| INT | OK | OK | OK | OK | OK | Destekli (integer odakli) | R4 |
| SGN | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| VAL | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| ASC | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| CINT | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| CLNG | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| STR | OK | OK | OK | OK | OK | STR text-context runtime yolu (PRINT/POKES + nested LEN/VAL) dogrulandi | R4 |
| UCASE/LCASE | OK | OK | OK | OK | OK | Text-context runtime yolu (nested ASC/LEN + POKES/PRINT) dogrulandi | R4 |
| CHR | OK | OK | OK | OK | OK | Text-context runtime yolu (nested ASC + POKES) dogrulandi | R4 |
| LTRIM/RTRIM | OK | OK | OK | OK | OK | Text-context runtime yolu (nested ASC + POKES) dogrulandi | R4 |
| MID | OK | OK | OK | OK | OK | Text-context runtime yolu (ASC/MID + POKES slice) dogrulandi | R4 |
| SPACE/STRING | OK | OK | OK | OK | OK | Text-context runtime yolu (LEN/ASC + POKES) dogrulandi | R4 |
| SQR | OK | OK | OK | OK | OK | SQR runtime + deterministic assertion kapsami tamamlandi | R4 |
| SIN/COS/TAN/ATN | OK | OK | OK | OK | OK | Runtime intrinsic evaluation + deterministic test kapsami eklendi | R4 |
| EXP/LOG | OK | OK | OK | OK | OK | Runtime intrinsic evaluation + LOG domain fail-fast testi eklendi | R4 |
| CDBL/CSNG/FIX | OK | OK | OK | OK | OK | Runtime numeric cast/truncate modeli deterministic assertionlarla dogrulandi | R4 |
| RND | OK | OK | OK | OK | OK | Runtime deterministic-range modeli ve sinir assertion'lariyla dogrulandi | R4 |
| INKEY/GETKEY | OK | OK | OK | OK | OK | Deterministic key queue + INKEY state yazimi ve bos-kuyruk fallback dogrulandi | R1.M |
| TIMER | OK | OK | OK | OK | OK | 0/1/3 arg runtime modeli + deterministic assertion kapsami dogrulandi | R4 |
| LOF/EOF | OK | OK | OK | OK | OK | Happy-path + closed-channel fail-fast testleri ile dogrulandi | R1.M |

## 3.1) R1.M Mini Iterasyon Plani (INKEY/GETKEY + LOF/EOF)

Degisecek dosyalar:
- src/runtime/memory_exec.fbs
- tests/run_runtime_intrinsics.bas
- spec/IR_RUNTIME_MASTER_PLAN.md
- reports/uxbasic_operasyonel_eksiklik_matrisi.md
- yapilanlar.md

Kanit komutlari:
- cmd /c build_64.bat tests\run_runtime_intrinsics.bas
- cmd /c tests\run_runtime_intrinsics_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. INKEY/GETKEY satiri D/P/S/R/T = OK/OK/OK/OK/OK.
2. LOF/EOF satiri D/P/S/R/T = OK/OK/OK/OK/OK.
3. run_runtime_intrinsics ve Faz A gate PASS olmadan satirlar OK'a cekilmez.

## 3.2) R2.M Mini Iterasyon Sonucu (END Satiri OK Kapanisi)

Kapsanan dosyalar:
- tests/run_end_exec_ast.bas
- spec/IR_RUNTIME_MASTER_PLAN.md
- reports/uxbasic_operasyonel_eksiklik_matrisi.md
- yapilanlar.md

Kanit komutlari:
- cmd /c build_64.bat tests\run_end_exec_ast.bas
- cmd /c tests\run_end_exec_ast_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. END satiri D/P/S/R/T = OK/OK/OK/OK/OK.
2. run_end_exec_ast ve Faz A gate PASS olmadan satir OK'a cekilmez.
3. END call-context propagation ve argumanli END parse fail-fast assertionlari PASS olmadan satir OK'a cekilmez.

## 3.3) R4.M Mini Iterasyon Plani (RANDOMIZE + Pointer Intrinsics Test Kapanisi)

Degisecek dosyalar:
- spec/IR_RUNTIME_MASTER_PLAN.md
- reports/uxbasic_operasyonel_eksiklik_matrisi.md
- tests/plan/command_compatibility_win11.csv

Kanit komutlari:
- cmd /c build_64.bat tests\run_runtime_intrinsics.bas
- cmd /c tests\run_runtime_intrinsics_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. RANDOMIZE satiri D/P/S/R/T = OK/OK/OK/OK/OK.
2. VARPTR/SADD/LPTR/CODEPTR satirlarinda T kolonu = OK.
3. run_runtime_intrinsics ve Faz A gate PASS olmadan satirlar OK'a cekilmez.

## 3.4) R3.N Mini Iterasyon Sonucu (DIM/REDIM MVP + Fail-Fast Tamamlandi)

Kapsanan dosyalar:
- src/runtime/memory_exec.fbs
- src/parser/parser/parser_stmt_decl.fbs
- tests/run_dim_redim_exec_ast.bas
- tools/run_faz_a_gate.ps1
- spec/IR_RUNTIME_MASTER_PLAN.md
- reports/uxbasic_operasyonel_eksiklik_matrisi.md
- tests/plan/command_compatibility_win11.csv

Sonuc ozeti:
1. `DIM` runtime yolu parser AST sozlesmesine (`DIM_DECL` + `DIM_BOUNDS` + `TYPE_REF`) hizalandi.
2. `REDIM` runtime yolu parser AST sozlesmesine (`REDIM_DECL` + `DIM_BOUNDS` + `TYPE_REF`) hizalandi ve `ExecRunStmt` icindeki cift `REDIM_STMT` dispatch cakisimi kapatildi.
3. `REDIM PRESERVE` icin parser seviyesinde acik fail-fast (`REDIM PRESERVE unsupported in R3.N`) eklendi.
4. Dedicated test kosucusu (`tests/run_dim_redim_exec_ast.bas`) gate'e baglandi.

Fail-fast kanitlari:
1. Duplicate `DIM` -> `DIM: duplicate variable`.
2. `lower > upper` -> `invalid array bounds`.
3. Byte tasmasi -> `array byte overflow`.
4. `REDIM` undeclared/scalar hedef -> `variable not declared` / `target is not array`.
5. `REDIM` type mismatch -> `type mismatch`.
6. `REDIM PRESERVE` -> parse fail-fast `unsupported in R3.N`.
7. Cok boyutlu DIM/REDIM -> explicit `only single-dimension arrays supported in R3.N`.

Kolon gecisleri:
1. `DIM`: S kolonu `KISMEN -> OK` cekildi; satir `OK/OK/OK/OK/OK` seviyesine geldi.
2. `REDIM`: S kolonu `KISMEN -> OK`, T kolonu `YOK -> OK` cekildi.
3. `REDIM` R kolonu kapsam disi ozellikler nedeniyle `KISMEN` olarak korundu.

Kanit komutlari:
- cmd /c build_64.bat tests\run_dim_redim_exec_ast.bas
- cmd /c tests\run_dim_redim_exec_ast_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanis kriteri:
1. `DIM` satiri D/P/S/R/T = `OK/OK/OK/OK/OK` seviyesine cekildi.
2. `REDIM` satiri D/P/S/R/T = `OK/OK/OK/KISMEN/OK` seviyesine cekildi.
3. run_dim_redim_exec_ast ve Faz A gate PASS olmadan satirlar hedef kolona cekilmez.

## 4) Operator Matrisi

| Operator Grubu | D | P | R | Not | Hedef Faz |
|---|---|---|---|---|---|
| Unary + - NOT | OK | OK | OK | Destekli | B2 tamam |
| Unary @ (adres alma) | OK | OK | OK | Runtime adres alma + pointer regression testleri aktif | R2 |
| Us alma ** | OK | OK | OK | Sagdan sola | B2 tamam |
| Carpma/Bolme/Tam bolme/Mod | OK | OK | OK | Runtime evaluator integer+float yolu ve domain fail-fast testleri aktif | R4 |
| Toplama/Cikarma | OK | OK | OK | Destekli | B2 tamam |
| Kaydirma/Dondurme (<< >> SHL SHR ROL ROR) | OK | OK | OK | Destekli | B2 tamam |
| Karsilastirma (= <> < > <= >=) | OK | OK | OK | Destekli | B2 tamam |
| AND/XOR/OR | OK | OK | OK | Destekli | B2 tamam |
| Atama (=, +=, -=, *=, /=, \\=, =+, =-) | OK | OK | OK | Runtime ASSIGN_STMT/INCDEC + compound atama yollari aktif ve gate kosuculari ile dogrulandi | R3 |

## 5) Veri Tipleri ve Veri Yapilari Matrisi

| Tip/Yapi | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| I8/U8/I16/U16/I32/U32/I64/U64 | OK | OK | OK | OK | OK | Core integer type ailesi parse/semantic/runtime yolu regression testi ile dogrulandi (tests/run_core_types_exec_ast.bas) | R4 |
| F32/F64/F80 | OK | OK | OK | OK | OK | Float evaluator/call zinciri ve domain fail-fast testleri dogrulandi (tests/run_floating_point_exec.bas) | R4 |
| BOOLEAN | OK | OK | OK | OK | OK | Karsilastirma/boolean non-zero semantigi regression testi ile dogrulandi (tests/run_core_types_exec_ast.bas) | R4 |
| STRING | OK | OK | OK | OK | OK | String intrinsic/runtime yolu (LEN/ASC vb.) regression testleri ile dogrulandi (tests/run_core_types_exec_ast.bas; tests/run_runtime_intrinsics.bas) | R4 |
| ARRAY | OK | OK | OK | OK | OK | DIM/REDIM(+PRESERVE) ve bounds fail-fast/runtime yolu testlerle dogrulandi (tests/run_dim_redim_exec_ast.bas; tests/run_core_types_exec_ast.bas) | R3 |
| TYPE | OK | OK | OK | OK | OK | Layout ve offset modeli var | B2 tamam |
| CLASS | OK | OK | OK | OK | OK | Class parse + access/friend semantik + instance storage/method dispatch + ctor/dtor invoke mvp kanitlari aktif (ilgili class exec_ast kosuculari). | R3 |
| LIST/DICT/SET | OK | OK | OK | OK | OK | Tip adi kabul + declaration/runtime koleksiyon operasyonlari dogrulandi (tests/run_collection_types_exec.bas; tests/run_collection_engine_exec.bas) | R5 |

## 6) Kritik Bosluklar (P0/P1/P2)

P0:

- R1 P0 kalemi kapanmistir.
- R4.M kapanisi ile RANDOMIZE satiri ve pointer intrinsic test kolonlari kapanmistir.

P1:

- DIM/REDIM runtime veri alani modeli
- NAMESPACE/MODULE/MAIN parse+semantic tasarimi ve END kapanis kurallari
- %% meta-komutlarin kalan preprocess katmani (%%DESTOS/%%PLATFORM/%%NOZEROVARS/%%SECSTACK)

## Güncelleme: 2026-04-11 - Runtime Execution Contract Implementation

DIM ve CONST komutlarının runtime durumu YOK'tan OK'ya çekildi. run_dim_const_test.bas testi başarılı geçti, exit code 0.

Kod kapsami:
- tests/run_dim_const_test.bas
  - DIM statement runtime modeli ve CONST compile-time + runtime etkileşimi doğrulandı.

Dokuman kapsami:
- reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - DIM satırı R kolonu YOK -> OK çekildi.
  - CONST satırı R kolonu YOK -> OK çekildi.

Kanit komutları:
- cmd /c build_64.bat tests\run_dim_const_test.bas
- cmd /c tests\run_dim_const_test_64.exe
- powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

Kapanış kriteri:
1. DIM satırı D/P/S/R/T = OK/OK/KISMEN/OK/KISMEN olmalı (R kolonu OK).
2. CONST satırı D/P/S/R/T = OK/OK/KISMEN/OK/KISMEN olmalı (R kolonu OK).
3. run_dim_const_test_64.exe PASS olmadan satırlar OK'a çekilmez.
4. Faz A gate PASS olmadan satırlar OK'a çekilmez.

- Float evaluator, promotion, oncelik/associativity testi
- LIST/DICT/SET runtime koleksiyonlar
- IMPORT toolchain orkestrasyonu
- String donen intrinsiclerin runtime deger modeli (typed value gecisi)

## 7) Bu Matrisin Kullanimi

Her sprint sonunda su satirlar guncellenir:

1. D/P/S/R/T hucreleri
2. Not kolonu
3. Hedef Faz kolonu (faz degistiyse)

Kaynak plan: spec/IR_RUNTIME_MASTER_PLAN.md

## 8) Program Yapisi Anahtar Kelime Matrisi

Not:

- `MAIN/NAMESPACE/MODULE/ALIAS` parser+semantic katmaninda yapi-meta direktifleridir.
- `%%` ile baslayan komutlar preprocess katmanidir.

| Yapi | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| NAMESPACE ... END NAMESPACE | OK | OK | OK | N/A | OK | Block parser/kapanis denetimi ve scope fail-fast dogrulandi (tests/run_namespace_module_main_parse.bas) | R6 |
| MODULE ... END MODULE | OK | OK | OK | N/A | OK | Block parser/kapanis denetimi ve missing END MODULE fail-fast dogrulandi (tests/run_namespace_module_main_parse.bas) | R6 |
| MAIN ... END MAIN | OK | OK | OK | N/A | OK | Tek MAIN ve global-scope kurallari fail-fast dogrulandi (tests/run_namespace_module_main_parse.bas) | R6 |
| USING | OK | OK | OK | N/A | OK | Duplicate/ambiguous USING semantik fail-fast dogrulandi (tests/run_namespace_module_main_parse.bas) | R6 |
| ALIAS yeni = eski | OK | OK | OK | N/A | OK | Duplicate/cycle/conflict ALIAS fail-fast dogrulandi (tests/run_namespace_module_main_parse.bas) | R6 |
| CALL(DLL, ...) | OK | OK | OK | OK | OK | Canonical CALL(DLL) parser+semantic+policy runtime (REPORT_ONLY/ENFORCE) ve allowlist/deny-code senaryolari test paketiyle dogrulandi (tests/run_call_exec.bas) | FFI-1 |
| END CLASS | OK | OK | OK | OK | OK | CLASS kapanis parse semantigi + class runtime mvp zinciri testlerle dogrulandi (tests/run_class_oop_transition_exec_ast.bas; tests/run_class_ctor_dtor_exec_ast.bas) | R3 |
| END IF / END SELECT / END SUB / END FUNCTION | OK | OK | OK | OK | OK | END blok semantigi ve runtime akisi dedicated test paketiyle dogrulandi (tests/run_end_exec_ast.bas; tests/run_w1_semantic_pass.bas) | R1-R2 |

## 9) Derleyici Meta-Komut Matrisi (%%)

| Meta Komut | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| %%INCLUDE | OK | OK | N/A | N/A | OK | Lexer preprocess katmaninda text-level include aktif; missing-file fallback ve inaktif dal skip davranisi testlendi (tests/run_percent_preprocess_exec.bas). Kanit komutu: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild (run_percent_preprocess_exec_64 zorunlu). | R6.M |
| %%DEFINE / %%UNDEF | OK | OK | N/A | N/A | OK | DEFINE ve UNDEF davranislari (aktif/inaktif dal, undef sonrasi dal secimi) dedicated testlerle dogrulandi (tests/run_percent_preprocess_exec.bas). Gate komutu: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild. | R6.M |
| %%DESTOS | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda DESTOS makro baglama/IFC secimi testle dogrulandi (tests/run_percent_preprocess_meta_exec.bas). | R6 |
| %%PLATFORM | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda host-platform tespiti ve mismatch fail-fast aktif. Kanit: tests/run_percent_preprocess_meta_exec.bas ve gate komutu tools/run_faz_a_gate.ps1 -SkipBuild. | R6 |
| %%IF / %%ELSE / %%ENDIF | OK | OK | N/A | N/A | OK | Lexer preprocess katmaninda kosullu dal secimi aktif; false-branch DEFINE izolasyonu ve duplicate ELSE negatif senaryosu testlendi (tests/run_percent_preprocess_exec.bas). Kanit komutu: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild (run_percent_preprocess_exec_64 zorunlu). | R6.M |
| %%IFC | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda sembol-karsilastirma dali aktif; true/false branch + malformed/inaktif dal davranisi dedicated testlerle dogrulandi (tests/run_percent_preprocess_ifc_exec.bas). Gate komutu: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild. | R6.N |
| %%ENDCOMP | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda early-stop kontrolu aktif; inaktif dal ignore ve parser-stop davranisi dedicated testle dogrulandi (tests/run_percent_preprocess_control_failfast.bas). Gate komutu: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild. | R6.N |
| %%ERRORENDCOMP | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda deterministic fail-fast aktif; mesajli/mesajsiz ve inaktif dal ignore davranisi dedicated testle dogrulandi (tests/run_percent_preprocess_control_failfast.bas). Gate komutu: powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild. | R6.N |
| %%NOZEROVARS | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda ON/OFF/1/0 parse + makro baglama testle dogrulandi (tests/run_percent_preprocess_meta_exec.bas). | R6 |
| %%SECSTACK | OK | OK | OK | N/A | OK | Lexer preprocess katmaninda ON/OFF/1/0 parse + makro baglama testle dogrulandi (tests/run_percent_preprocess_meta_exec.bas). | R6 |

## 10) CLASS OOP Ozellik Matrisi (Son Madde)

| OOP Ozelligi | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| CLASS / END CLASS taban blogu | OK | OK | OK | OK | OK | Class parse + instance layout/runtime mvp dogrulandi (tests/run_class_oop_transition_exec_ast.bas; tests/run_class_ctor_dtor_exec_ast.bas; tests/run_class_access_friend_parse.bas); Faz A gate'te class kosuculari aktif (tools/run_faz_a_gate.ps1) | R3 |
| PUBLIC/PRIVATE erisim bolgesi | OK | OK | OK | N/A | OK | CLASS icinde access-directive parser ve friend fail-fast semantik denetimi testle dogrulandi (tests/run_class_access_friend_parse.bas); runtime enforcement bu satirda N/A kapsamda tutuluyor | OOP-P0 |
| METHOD bildirimi | OK | OK | OK | OK | OK | METHOD bildirimi + dotted dispatch runtime ve THIS/ME semantic kontrati testlerle dogrulandi (tests/run_class_method_dispatch_exec_ast.bas; tests/run_class_method_dispatch_call_expr_exec_ast.bas; tests/run_this_me_semantic_pass.bas) | OOP-P0 |
| THIS/ME modeli | OK | OK | OK | OK | OK | Parser: THIS/ME keyword'leri method scope'unda taniniyor. Runtime: method-disi kullanim fail-fast aktif. Semantic: THIS/ME yalnizca method-baglaminda kabul ediliyor (tests/run_this_me_semantic_pass.bas). | OOP-P0 |
| Constructor/Destructor | OK | OK | OK | OK | OK | Ctor/dtor signature + invoke + program-scope dtor invoke regression testleri ile dogrulandi (tests/run_class_ctor_dtor_exec_ast.bas; tests/run_class_dtor_scope_exit_exec_ast.bas) | OOP-P1 |
| Inheritance | OK | OK | OK | OK | OK | EXTENDS parse + base layout + override/base fallback method dispatch regression testleri ile dogrulandi (tests/run_class_inheritance_virtual_exec_ast.bas) | OOP-P2 |
| VTable/Polymorphism | OK | OK | OK | OK | OK | OOP MVP polymorphism: derived->base method resolution zinciri ve override dispatch runtime yoluyla dogrulandi (tests/run_class_inheritance_virtual_exec_ast.bas) | OOP-P2 |
| Interface | OK | OK | OK | OK | OK | INTERFACE/IMPLEMENTS parse + semantic sozlesme denetimi + runtime no-op ve dispatch yolu testlerle dogrulandi (tests/run_interface_exec_ast.bas; tests/run_interface_runtime_exec_ast.bas) | OOP-P2 |

## 10.1) Kisa Ileri Plan (2026-04-13)

Mini iterasyon A (R3.O1) - THIS/ME baglam mvp:
1. Kapsam: METHOD cagrilarinda receiver baglaminin THIS/ME sembollerine baglanmasi.
2. Kanit hedefi: tests/run_class_method_dispatch_exec_ast.bas + yeni negatif test (THIS/ME class-disi kullanim fail-fast).
3. Kapanis: METHOD/THIS satirlarinda P ve S kolonlarinda kontrollu gecis.

Mini iterasyon B (R3.O2) - ctor/dtor lite:
1. Kapsam: ctor/dtor bildirimi + instance olusum/serbest birakim minimum kontrati.
2. Kanit hedefi: yeni tests/run_class_ctor_dtor_exec_ast.bas.
3. Kapanis: Constructor/Destructor satirinda en az P/S/T kolonlarinin YOK->KISMEN gecisi.

Mini iterasyon C (R6.N1) - %%IFC ve preprocess kalanlari:
1. Kapsam: %%IFC parser/preprocess yolu + %%ENDCOMP/%%ERRORENDCOMP fail-fast cekirdegi.
2. Kanit hedefi: tests/run_percent_preprocess_ifc_exec.bas + tests/run_percent_preprocess_control_failfast.bas ve gate entegrasyonu (tools/run_faz_a_gate.ps1).
3. Kapanis: %%IFC/%%ENDCOMP/%%ERRORENDCOMP satirlarinda P/T kolonlari OK'a cekildi; kalan komutlar %%DESTOS/%%PLATFORM/%%NOZEROVARS/%%SECSTACK olarak ayristirildi.

## 10.2) Performans ve Bellek Degerlendirmesi (2026-04-13)

Kapsam komutlari:
1. powershell -ExecutionPolicy Bypass -File tools/perf_runtime_benchmark.ps1 -Executables tests/run_call_user_exec_ast_64.exe,tests/run_class_method_dispatch_exec_ast_64.exe,tests/run_class_method_dispatch_call_expr_exec_ast_64.exe,tests/run_percent_preprocess_exec_64.exe,tests/run_collection_engine_exec_64.exe -Repeat 3 -TimeoutSeconds 30 -OutputCsv reports/runtime_perf_dispatch_preprocess_collections.csv
2. powershell -ExecutionPolicy Bypass -File tools/runtime_memory_benchmark.ps1 -Executables tests/run_call_user_exec_ast_64.exe,tests/run_class_method_dispatch_exec_ast_64.exe,tests/run_class_method_dispatch_call_expr_exec_ast_64.exe,tests/run_percent_preprocess_exec_64.exe,tests/run_collection_engine_exec_64.exe -Repeat 3 -TimeoutSeconds 30 -OutputCsv reports/runtime_memory_dispatch_preprocess_collections.csv

Ozet:
1. Perf: Tum kosularda 3/3 PASS, timeout/fail yok.
2. En dusuk ortalama sure: run_percent_preprocess_exec_64.exe ~24.581 ms.
3. En yuksek ortalama sure: run_call_user_exec_ast_64.exe ~37.629 ms.
4. Bellek: peak working set araligi yaklasik 5.3-5.7 MB.
5. Bellek: peak private memory araligi yaklasik 8.95-10.22 MB.

## 10.3) 2026-04-13 Durum Delta (R6.N + OOP)

Cell transition kayitlari:
1. Komut matrisi `CLASS` satiri T kolonu: `KISMEN -> OK`.
  - Kanit testleri: `tests/run_class_access_friend_parse.bas`, `tests/run_class_oop_transition_exec_ast.bas`, `tests/run_class_ctor_dtor_exec_ast.bas`, `tests/run_class_method_dispatch_exec_ast.bas`, `tests/run_class_method_dispatch_call_expr_exec_ast.bas`
  - Kanit gate komutu: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`
2. Veri tipi/yapi matrisi `CLASS` satiri T kolonu: `KISMEN -> OK`.
  - Kanit testleri: `tests/run_class_access_friend_parse.bas`, `tests/run_class_oop_transition_exec_ast.bas`, `tests/run_class_ctor_dtor_exec_ast.bas`, `tests/run_class_method_dispatch_exec_ast.bas`, `tests/run_class_method_dispatch_call_expr_exec_ast.bas`
  - Kanit gate komutu: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`

R6.N durumu:
1. R6.N hucrelerinde %%IFC/%%ENDCOMP/%%ERRORENDCOMP icin P/T kolon gecisi yapildi (YOK -> OK).
2. Kod kaniti: `src/parser/lexer/lexer_preprocess.fbs` icinde `IFC/ENDCOMP/ERRORENDCOMP` handler'lari aktif; %%IFC inaktif-parent semantigi %%IF ile hizalandi.
3. Test/gate kaniti: `tests/run_percent_preprocess_ifc_exec.bas`, `tests/run_percent_preprocess_control_failfast.bas` ve `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`.

## 11) OOP ve Scope Anahtar Kelime Kod Gerceklik Matrisi (Duzeltilmis)

Durum etiketleri:

- KODDA-OK: Parser/semantic/runtime/test zincirinde kanitli
- KODDA-KISMEN: Parser var, semantic/runtime kapsami sinirli
- KODDA-YOK: Kodda uygulanmamis
- PLAN: Yol haritasinda, henuz kodlanmamis

### 11.1 Sinif Tanim ve Uye Anahtarlari (Kod Gerceklik)

| Anahtar | Durum | Gerekce |
|---|---|---|
| CLASS / END CLASS | KODDA-OK | Parse + semantic + runtime + test zinciri aktif (bkz. Bolum 10 CLASS satirlari) |
| FIELD | KODDA-OK | CLASS_FIELD AST ve layout/runtime depolama yolu aktif |
| METHOD | KODDA-OK | METHOD parse + dispatch + call_expr test kaniti aktif |
| PUBLIC / PRIVATE | KODDA-OK | Access metadata ve semantic fail-fast denetimi aktif |
| PROTECTED | KODDA-YOK | Keyword davranisi ve access semantigi tanimli degil |
| STATIC | KODDA-YOK | Class-level static storage semantigi yok |
| PROPERTY | KODDA-YOK | GET/SET property modeli yok |
| CONSTRUCTOR / DESTRUCTOR | KODDA-OK | Ctor/dtor parse-signature + invoke testleri aktif |
| READONLY / MUTABLE / IMMUTABLE | KODDA-YOK | Atama kilitleme semantigi yok |
| FRIEND / RESTRICTED | KODDA-KISMEN | Parser+semantic (same-namespace/fail-fast) var; runtime erisim zorlamasi sinirli |

### 11.2 OOP Iliski ve Cagri Anahtarlari (Kod Gerceklik)

| Anahtar | Durum | Gerekce |
|---|---|---|
| THIS | KODDA-OK | Method baglaminda semantic+runtime baglama, method-disi fail-fast var |
| SUPER | KODDA-YOK | SUPER cagrisi parser/runtime modeli yok | (bu keyword su an gerekli mi ust hiyearsideki veriyi isaret etmesi gerekmiyormu?)
| NEW / DELETE | KODDA-YOK | Acik NEW/DELETE token-semantigi yok; DIM tabanli yasam dongusu var | yasam dongusunu dim baslatiyorsa da constructor/destructor invoke'u tetikliyor, bu yuzden NEW/DELETE keyword'lerine simdilik gerek yok gibi duruyor??degilmi?
 INSTANCEOF | KODDA-YOK | Type-id tabanli runtime sorgu yok |
| EXTENDS | KODDA-OK | Parse + inheritance dispatch regression testleri aktif |
| IMPLEMENTS / INTERFACE | KODDA-OK | Parse + semantic sozlesme + runtime no-op/dispatch modeli aktif |
| OVERRIDE | KODDA-KISMEN | Keyword tanimi var; kesin signature override enforcement sinirli |
| VIRTUAL | KODDA-KISMEN | Keyword tanimi var; tam vtable semantigi aciklanmis ama sinirli |
| ABSTRACT | KODDA-YOK | Abstract class/uye instantiate engeli yok |
| FINAL / SEALED | KODDA-YOK | Inheritance kapatma semantigi yok |
| OPERATOR (overload) | KODDA-YOK | Overload resolver yok |
| MIXIN | KODDA-YOK | Mixin kompozisyon semantigi yok |
| DECORATOR | KODDA-YOK | Decorator modeli yok |
| <SihirliMetot> | KODDA-YOK | Auto-bind magic method sozlesmesi yok | buna ihtiyac var bence

### 11.3 Namespace ve Modul Anahtarlari (Kod Gerceklik)

| Anahtar | Durum | Gerekce |
|---|---|---|
| NAMESPACE / END NAMESPACE | KODDA-OK | Parser+semantic scope kontrolu ve fail-fast testleri aktif |
| USING | KODDA-OK | Duplicate/ambiguous/import semantigi fail-fast aktif |
| MODULE / END MODULE | KODDA-OK | Parser+semantic blok kapanis kontrolu aktif |
| MAIN / END MAIN | KODDA-OK | Tek MAIN ve global-scope kurallari aktif |
| ALIAS | KODDA-OK | duplicate/cycle/conflict semantigi fail-fast aktif |

### 11.4 Erisim Belirleyici Cakisma-Onleme Durumu

| Model | Durum | Gerekce |
|---|---|---|
| PRIVATE (module/class ici) | KODDA-OK | Compile-time access metadata ve semantic kontrol aktif |
| PRIVATE + FRIEND (secili module istisnasi) | KODDA-KISMEN | FRIEND list parse+semantic var; runtime erisim zorlamasi sinirli |
| RESTRICTED (namespace+project siniri) | KODDA-KISMEN | RESTRICTED parse+semantic var; proje-genel import/include siniri tam degil |
| PUBLIC | KODDA-OK | Varsayilan disa acik uye modeli + metadata aktif |

## 12) DLL Cekirdek Entegrasyon Matrisi (Istatistik ve Genel FFI Temeli)

Bu bolum istatistik fonksiyon isimlerinden bagimsiz olarak CALL(DLL)/IMPORT ve scope sisteminin dogru calismasini izler.

| Bilesen | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| CALL(DLL, lib, symbol, signature, ...) | OK | OK | OK | OK | OK | Temel FFI cagrisi ve policy kodlari (9201..9215) aktif | FFI-CORE |
| Calling convention: stdcall/cdecl secimi | OK | OK | OK | KISMEN | OK | Parser+runtime token destegi aktif (CDECL/STDCALL). Win64 policy lane'de cdecl/stdcall uyumlu eslestirme + ABI audit alani eklendi (tests/run_call_exec.bas, tests/run_call_dll_scope_exec_ast.bas, tests/run_call_dll_alias_exec_ast.bas). Runtime dis cagrida halen policy/no-op modunda oldugu icin R=KISMEN korunur. | FFI-CONV-1 |
| DLL path policy (absolute/segments/invalid chars) | OK | OK | OK | OK | OK | Runtime fail-fast kodlari aktif | FFI-CORE |
| Signature/arity/byref contract | OK | OK | OK | OK | OK | runtime exec_eval_builtin_categories kaniti mevcut | FFI-CORE |
| NAMESPACE+MODULE+MAIN ile DLL cagrisi | OK | OK | OK | OK | OK | Scope parse+exec kaniti PASS (tests/run_call_dll_scope_exec_ast.bas). MAIN global-scope kuralina uygun senaryo ile dogrulandi. | FFI-SCOPE-1 |
| USING/ALIAS ile DLL cagrisi isim cozumleme | OK | OK | OK | OK | OK | Runtime alias dispatch aktif: `CALL(aliasName, ...)` -> ALIAS target `CALL(DLL,...)` cozumleme + policy/marshalling cekirdegine yonlendirme. Kanit: tests/run_call_dll_alias_exec_ast.bas. | FFI-SCOPE-1 |
| Strongly-typed marshalling (STRING/PTR/NUM) | OK | OK | OK | OK | OK | Runtime marshalling dogrulama aktif (I32/U64/F64/PTR/STRPTR/BYREF/BYVAL). Kanit: tests/run_call_dll_alias_exec_ast.bas (STRPTR/U64 negatif), tests/run_call_exec.bas, tests/run_call_dll_scope_exec_ast.bas. | FFI-SCOPE-2 |
| Win64 ABI uyumu (shadow space + alignment) | OK | OK | OK | OK | OK | x64 FFI codegen backend CALL(DLL) dugumlerinden plan+stub uretiyor: reserve hesaplamasi (40 + stackArg*8 + odd pad), register (RCX/RDX/R8/R9) ve stack arg slotlari ([rsp+32+]) emit ediliyor. Kanit: tests/run_ffi_x64_call_backend.bas, tests/tmp_ffi_conv2_codegen_smoke.uxb + `--interop` ile `dist/interop/ffi_call_x64_plan.csv` ve `dist/interop/ffi_call_x64_stubs.asm`. | FFI-CONV-2 |
| x86 stdcall/cdecl ayristirma | OK | KISMEN | KISMEN | KISMEN | KISMEN | x86 lane guclendirildi: plan+stub + resolver artifact (`dist/interop/ffi_call_x86_resolver.csv`) uretiliyor; runtime resolver enforce/report + symbol binding cache/symptr map aktif (`ExecDebugGetFfiX86ResolvedCount`, `ExecDebugGetFfiX86SymptrMapCount`). Invoke-proof yolu I32 imza icin 0..4 arg pointer call'a genisletildi ve cleanup byte sayaçlari eklendi (`ExecDebugGetFfiX86InvokeCount`, `ExecDebugGetFfiX86CallerCleanupBytes`, `ExecDebugGetFfiX86CalleeCleanupBytes`). Symptr write-through gozlemlenebilirligi artirildi (`ExecDebugGetFfiX86SymptrWriteCount`, `ExecDebugGetFfiX86SymptrLabelByStubId`, `ExecDebugGetFfiX86SymptrProcAddrByStubId`). Native lane probe seti eklendi (`tests/probes/run_ffi_x86_native_cleanup_probe.bas`, `tests/probes/run_ffi_x86_native_symptr_patch_probe.bas`) ve otomasyon raporu uretildi (`reports/ffi_conv3_native_lanes_report.md`); mevcut hostta 32-bit assembler (`bin/win32/as.exe`) eksik oldugu icin proses-duzeyi kanit BLOCKED. Cleanup contract gate'i aktif (`ExecX86FfiValidateCleanupContract`). Kanit: `tests/run_ffi_x86_call_backend.bas`, `tests/run_ffi_x86_resolver_exec_ast.bas`, `tests/run_ffi_x86_resolver_cleanup_proof.bas`, `tests/run_call_exec.bas`. | FFI-CONV-3 |
| Ilk resmi DLL: uXStat | OK | PLAN | PLAN | PLAN | PLAN | Ayrik planda is paketleri tanimlandi | UXSTAT-0 |

## 13) Codegen ve MIR Izleme Matrisi

| Bilesen | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| HIR olusumu (typed AST bridge) | OK | KISMEN | KISMEN | N/A | KISMEN | semantic/hir.fbs var, kapsami genisletilecek | CG-1 |
| MIR olusumu (CFG/basic block) | OK | KISMEN | KISMEN | KISMEN | KISMEN | semantic/mir.fbs ve memory_exec MIR notlari var, tam degil | CG-1 |
| MIR interpreter dispatch | OK | KISMEN | KISMEN | KISMEN | KISMEN | runtime memory_exec ve exec alt modullerine parcali dagilim | CG-2 |
| x64 emitter passthrough INLINE | OK | OK | OK | KISMEN | KISMEN | INLINE parse/runtime var, emitter kapsam kapanisi acik | CG-2 |
| CALL [register] / stack arg passing | OK | OK | OK | KISMEN | OK | x64 FFI stub emitter `call qword [rel __uxb_ffi_symptr_N]` + RCX/RDX/R8/R9 ve `[rsp+32+]` stack slot yazimini uretiyor. Resolver lane metadata cikisi (`dist/interop/ffi_call_x64_resolver.csv`) eklendi; runtime dis cagrida halen policy/no-op modunda oldugu icin R=KISMEN korunur. Kanit: `tests/run_ffi_x64_call_backend.bas`. | CG-3 |
| Win64 ABI (shadow space + alignment) | OK | OK | OK | KISMEN | OK | Reserve formulu `40 + stackArg*8 + odd pad` ile call-oncesi 16-byte hizalama ve 32-byte shadow space korunuyor; test ve smoke interop kaniti mevcut. | CG-3 |
| Regression gate (interp vs compiled parity) | OK | KISMEN | KISMEN | KISMEN | KISMEN | Cift-mod parity test paketi acik | CG-QA |
| TRY/CATCH unwinding emit (label table + finally trampoline) | OK | PLAN | PLAN | PLAN | PLAN | MIR exception edge ve x64/x86 backend unwind plan cikisi henuz acik. | ERR-CG-1 |
| THROW emit (error object materialization + jump to handler) | OK | PLAN | PLAN | PLAN | PLAN | THROW statement icin MIR lowering ve handler dispatch emitter lane'i acik. | ERR-CG-2 |
| ASSERT emit (debug/release policy) | OK | PLAN | PLAN | PLAN | PLAN | ASSERT'in release mod no-op veya guarded-trap stratejisi netlestirilecek. | ERR-CG-3 |

## 14) Anahtar Kelime -> Sistem Codegen Takip Matrisi

Bu bolum, tum uXBasic anahtar kelimelerinin parser/semantic/runtime/codegen izini tek tabloda takip etmek icin acilmistir.

| Grup | Anahtar Kelimeler | Parser | Semantic | Runtime/Interp | Codegen | Not |
|---|---|---|---|---|---|---|
| Akis | IF, SELECT CASE, FOR, DO, EXIT, RETURN, GOTO/GOSUB | OK | OK | OK | KISMEN | CFG ve branch lowering ilerliyor |
| Deklarasyon | DIM, REDIM, CONST, TYPE, CLASS, SUB/FUNCTION | OK | OK | OK | PLAN | UDT/class kod uretim lane'i acik |
| I/O | PRINT, INPUT, OPEN/CLOSE/GET/PUT/SEEK | OK | OK | OK | PLAN | Ilk hedef parity, sonra native I/O call lowering |
| Bellek | PEEK*/POKE*/MEMCOPY*/MEMFILL* | OK | OK | OK | PLAN | Safety guard korunarak backend emit tasarlanacak |
| FFI | CALL(DLL), IMPORT, INLINE | OK | OK | KISMEN | KISMEN | x64 lane KISMEN/OK, x86 lane baslatildi |
| Hata Yonetimi | TRY/CATCH/FINALLY, THROW, ASSERT, ERROR objesi | PLAN | PLAN | PLAN | PLAN | Bu turde plan ve dokuman acildi |

Codegen kolon anahtari:
- OK: Uretim + test kapanmis
- KISMEN: Artefakt/stub veya sinirli yol var
- PLAN: Tasarim var, kod yok
