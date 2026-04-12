# uXBasic Operasyonel Eksiklik Matrisi

Tarih: 2026-04-12
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
- powershell -ExecutionPolicy Bypass -File tools/validate_module_quality_gate.ps1 -Strict -> FAIL (10 warning, 0 error; strict mod warningleri fail sayar)
- powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild -StrictStructureGate -> FAIL (ayni nedenle)
- powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild -> PASS (regresyon yok)

Siki modda acik kalan yapisal eksikler:
1. src/runtime/memory_exec.fbs buyukluk borcu devam ediyor (dosya ve fonksiyon debt-cap uyarilari).
2. src/semantic/layout/layout_type_table.fbs icinde ResolveTypeLayout near-limit (semantic tarafinda tek fonksiyon yogunlugu kaldı).
3. src/parser/parser/parser_stmt_decl_core.fbs icinde ParseClassStmt near-limit.
4. src/parser/parser/parser_stmt_dispatch.fbs icinde ValidateUsingAliasSemanticsForScope near-limit.
5. src/main.bas include yogunlasmasi yuksek (include concentration ratio high).

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
1. EXIT IF: KISMEN/OK/KISMEN/OK/OK
2. FLOATING POINT: YOK/YOK/YOK/YOK/YOK
3. IMPORT(C/CPP/ASM, file): OK/OK/KISMEN/YOK/YOK
4. INLINE(...): OK/OK/KISMEN/YOK/KISMEN
5. LIST/DICT/SET: KISMEN/OK/KISMEN/YOK/YOK
6. CLASS derin semantigi/runtime: KISMEN seviyesinde
7. %% meta-komutlar: D=OK, P/S/T=YOK, R=N/A

Sikilastirma hedefi:
- Debt-cap toleransini asamali azaltip warningleri kademeli olarak zorunlu kapanis kalemine cevirmek.

## 2) Komut Matrisi (Statement)

| Komut | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| PRINT | OK | OK | OK | OK | OK | Runtime `,`/`;` ayrimi + 14-col zone-parity ve trailing newline suppress dogrulandi | R1 |
| INPUT | OK | OK | KISMEN | OK | OK | INPUT konsol kuyruk-modu + INPUT# runtime deterministic test ile dogrulandi | R1 |
| IF / ELSEIF / ELSE / END IF | OK | OK | KISMEN | OK | OK | IF runtime + dedicated branch testi eklendi | R1 |
| SELECT CASE / CASE / CASE ELSE / END SELECT | OK | OK | KISMEN | OK | OK | SELECT runtime + CASE IS dalı dogrulandi | R1 |
| CASE IS | OK | OK | OK | OK | OK | CASE IS iliskisel parser/runtime modeli fail-fast parse kurallari ve test kosucusuyla dogrulandi | R1 |
| EXIT FOR | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| EXIT DO | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| EXIT IF | KISMEN | OK | KISMEN | OK | OK | Parse/runtime aktif; IF disinda kullanim runtime fail-fast ve dedicated test ile dogrulandi | R1 |
| FOR / NEXT | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| FOR EACH / NEXT | OK | OK | OK | OK | OK | Stride capraz dogrulandi | B2 tamam |
| DO / LOOP | OK | OK | OK | OK | OK | DO_WHILE/UNTIL, LOOP_WHILE/UNTIL var | B2 tamam |
| DO EACH / LOOP | KISMEN | OK | OK | OK | OK | Destekli | B2 tamam |
| GOTO | OK | OK | OK | OK | OK | Jump hedef cozumleme + missing-target fail-fast ve duplicate-label guard testleri ile semantik kapanis dogrulandi | R2 |
| GOSUB | OK | OK | OK | OK | OK | Call stack push/pop + missing-target fail-fast ile semantik kapanis dogrulandi | R2 |
| RETURN | OK | OK | OK | OK | OK | GOSUB icinde donus + dengesiz RETURN fail-fast ve jump-context guard testleri ile semantik kapanis dogrulandi | R2 |
| CALL | OK | OK | OK | OK | OK | Builtin + user-defined dispatch modeli ve arity fail-fast eklendi | R2 |
| END | OK | OK | OK | OK | OK | END_STMT semantigi (dongu/if/select + user-call context propagation) ve parse fail-fast (argumanli END) dedicated test/gate kaniti ile kapatildi | R2.M |
| DECLARE SUB/FUNCTION | OK | OK | OK | OK | OK | Runtime resolver declare/def ile uyumlu; ileri signature semantigi acik | R2 |
| SUB / FUNCTION | OK | OK | KISMEN | OK | OK | Runtime symbol map + activation-record benzeri lokal scope mvp eklendi | R2 |
| CONST | OK | OK | KISMEN | OK | OK | Compile-time odakli | R3 |
| DIM | OK | OK | OK | OK | OK | DIM_DECL tabanli runtime semantigi (duplicate/bounds/fail-fast) dedicated test ile kapatildi | R3.N |
| REDIM | OK | OK | OK | KISMEN | OK | REDIM_DECL runtime yolu (undeclared/scalar/type/bounds fail-fast) + PRESERVE parse fail-fast dogrulandi; cok boyut/PRESERVE runtime kapsam disi | R3.N |
| TYPE | OK | OK | OK | OK | OK | Runtime no-op + layout var | B2 tamam |
| CLASS | OK | OK | KISMEN | OK | KISMEN | Runtime no-op, class semantigi genisletilecek | R3 |
| DEFINT/DEFLNG/DEFSNG/DEFDBL/DEFEXT/DEFSTR/DEFBYT | OK | OK | KISMEN | OK | KISMEN | Runtime etkisi sinirli | R3 |
| SETSTRINGSIZE | OK | OK | KISMEN | OK | OK | Runtime etkisi tanimsiz | R3 |
| FLOATING POINT | YOK | YOK | YOK | YOK | YOK | Compiler floating point desteklemiyor | PLAN |
| INCLUDE | OK | OK | OK | N/A | KISMEN | Preprocess/parse katmani | R3 |
| IMPORT(C/CPP/ASM, file) | OK | OK | KISMEN | YOK | YOK | Toolchain/link orkestrasyonu eksik | FFI-1 |
| INLINE(...) ... END INLINE | OK | OK | KISMEN | YOK | KISMEN | Parser var, backend semantigi sinirli | FFI-2 |
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
| POKES | KISMEN | OK | KISMEN | OK | KISMEN | Runtime var, semantik kapsami genisletilecek | R3 |
| MEMCOPYB/W/D | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| MEMFILLB/W/D | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| SETNEWOFFSET | KISMEN | OK | KISMEN | OK | KISMEN | Runtime var, tip/guvenlik genisletilecek | R3 |

## 3) Fonksiyon Matrisi (Intrinsic)

| Fonksiyon | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| SIZEOF | OK | OK | OK | OK | OK | Destekli | B2 tamam |
| OFFSETOF | OK | OK | OK | OK | OK | Indexed path dahil | B2 tamam |
| PEEKB/PEEKW/PEEKD | OK | OK | OK | OK | OK | Width semantigi aktif | B2 tamam |
| VARPTR | KISMEN | OK | OK | OK | OK | Mutable-identifier semantik fail-fast ve CALL/CALL_EXPR arg-contract dogrulamasi eklendi; Faz A pointer contract testi gate'e baglandi | R2 |
| SADD | KISMEN | OK | OK | OK | OK | CALL/CALL_EXPR arg-contract semantik dogrulamasi ve pointer contract test kapsami ile dogrulandi | R2 |
| LPTR | KISMEN | OK | OK | OK | OK | CALL/CALL_EXPR arg-contract semantik dogrulamasi ve pointer contract test kapsami ile dogrulandi | R2 |
| CODEPTR | KISMEN | OK | OK | OK | OK | CALL/CALL_EXPR arg-contract semantik dogrulamasi ve pointer contract test kapsami ile dogrulandi | R2 |
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
| Unary @ (adres alma) | KISMEN | OK | OK | Runtime adres alma eklendi | R2 |
| Us alma ** | OK | OK | OK | Sagdan sola | B2 tamam |
| Carpma/Bolme/Tam bolme/Mod | OK | OK | KISMEN | Runtime su an integer agirlikli | R4 |
| Toplama/Cikarma | OK | OK | OK | Destekli | B2 tamam |
| Kaydirma/Dondurme (<< >> SHL SHR ROL ROR) | OK | OK | OK | Destekli | B2 tamam |
| Karsilastirma (= <> < > <= >=) | OK | OK | OK | Destekli | B2 tamam |
| AND/XOR/OR | OK | OK | OK | Destekli | B2 tamam |
| Atama (=, +=, -=, *=, /=, \\=, =+, =-) | OK | OK | KISMEN | Runtime ASSIGN_STMT ve INCDEC var, compound semantik sinirlari netlestirilecek | R3 |

## 5) Veri Tipleri ve Veri Yapilari Matrisi

| Tip/Yapi | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| I8/U8/I16/U16/I32/U32/I64/U64 | OK | OK | KISMEN | KISMEN | KISMEN | Runtime evaluator integer agirlikli | R4 |
| F32/F64/F80 | OK | OK | KISMEN | YOK | YOK | Float evaluator ve promotion eksik | R4 |
| BOOLEAN | OK | OK | KISMEN | KISMEN | KISMEN | Karsilastirma sonucu -1/0 modeli var | R4 |
| STRING | OK | OK | KISMEN | KISMEN | KISMEN | String runtime operator/fn kapsami eksik | R4 |
| ARRAY | OK | OK | OK | KISMEN | KISMEN | Layout stride var, genel runtime dizi modeli eksik | R3 |
| TYPE | OK | OK | OK | OK | OK | Layout ve offset modeli var | B2 tamam |
| CLASS | OK | OK | KISMEN | KISMEN | KISMEN | No-op disinda class semantik/planning asamasi | R3 |
| LIST/DICT/SET | KISMEN | OK | KISMEN | YOK | YOK | Tip adi kabul var, runtime koleksiyon motoru yok | R5 |

## 6) Kritik Bosluklar (P0/P1/P2)

P0:

- R1 P0 kalemi kapanmistir.
- R4.M kapanisi ile RANDOMIZE satiri ve pointer intrinsic test kolonlari kapanmistir.

P1:

- DIM/REDIM runtime veri alani modeli
- NAMESPACE/MODULE/MAIN parse+semantic tasarimi ve END kapanis kurallari
- %% meta-komutlarin preprocess katmani

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
| NAMESPACE ... END NAMESPACE | KISMEN | KISMEN | KISMEN | N/A | KISMEN | Block parser ve kapanis denetimi eklendi; ileri scope kurallari acik | R6 |
| MODULE ... END MODULE | KISMEN | KISMEN | KISMEN | N/A | KISMEN | Block parser ve kapanis denetimi eklendi; import baglama semantigi acik | R6 |
| MAIN ... END MAIN | KISMEN | KISMEN | KISMEN | N/A | KISMEN | MAIN block parse + tek giris/ust-duzey executable semantik denetimi eklendi | R6 |
| USING | KISMEN | KISMEN | KISMEN | N/A | KISMEN | Duplicate ve ambiguous tail fail-fast semantik denetimi eklendi; scope/genis import kurallari acik | R6 |
| ALIAS yeni = eski | KISMEN | KISMEN | KISMEN | N/A | KISMEN | Duplicate/cycle/conflict fail-fast semantik denetimi eklendi; imza/policy denetimi acik | R6 |
| CALL(DLL, ...) | KISMEN | KISMEN | KISMEN | KISMEN | KISMEN | Canonical CALL(DLL, ...) parser+semantic fail-fast, mode-aware allowlist policy (`REPORT_ONLY`/`ENFORCE`) ve audit runtime mvp eklendi; allowlist dosya-kaynagi (`dist/config/ffi_allowlist.txt`) strict `UXB_FFI_ALLOWLIST_V1` header ile aktif, DLL canonicalization (path-segments/absolute-path/invalid-char) fail-fast calisiyor, policy satiri hash/signer alanlarini parse eder ve ENFORCE modunda attestation metadata zorunlu tutar; hash/signer mismatch deny kodlari ayristirildi (`9211`/`9212`), extraction-failure deny kodlari eklendi (`9213`/`9214`), policy-load fail-closed deny kodu eklendi (`9215`) ve policy audit logu `event=ffi_policy_decision` alanlariyla yapilandirildi, gercek signer/hash extraction ve marshaling/ABI bridge acik | FFI-1 |
| END CLASS | OK | OK | KISMEN | KISMEN | KISMEN | Class parse kapanisi var, OOP runtime kapsami sinirli | R3 |
| END IF / END SELECT / END SUB / END FUNCTION | OK | OK | KISMEN | KISMEN | KISMEN | Bazilarinda runtime kapsami acik | R1-R2 |

## 9) Derleyici Meta-Komut Matrisi (%%)

| Meta Komut | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| %%INCLUDE | OK | YOK | YOK | N/A | YOK | El kitaplarinda ana kaynak, parser/runtime kodunda iz yok | R6 |
| %%DESTOS | OK | YOK | YOK | N/A | YOK | Derleme hedef yonetimi olarak belgeli, kod-gercekligi yok | R6 |
| %%PLATFORM | OK | YOK | YOK | N/A | YOK | Derleme hedef yonetimi olarak belgeli, kod-gercekligi yok | R6 |
| %%IF / %%ELSE / %%ENDIF | OK | YOK | YOK | N/A | YOK | Preprocess kosullu derleme katmani henuz yok | R6 |
| %%IFC | OK | YOK | YOK | N/A | YOK | Sembol kosullu derleme katmani yok | R6 |
| %%ENDCOMP | OK | YOK | YOK | N/A | YOK | Derleyici-kontrol komutu henuz yok | R6 |
| %%ERRORENDCOMP | OK | YOK | YOK | N/A | YOK | Derleyici-kontrol komutu henuz yok | R6 |
| %%NOZEROVARS | OK | YOK | YOK | N/A | YOK | Derleyici davranis bayragi henuz yok | R6 |
| %%SECSTACK | OK | YOK | YOK | N/A | YOK | Derleyici davranis bayragi henuz yok | R6 |

## 10) CLASS OOP Ozellik Matrisi (Son Madde)

| OOP Ozelligi | D | P | S | R | T | Not | Hedef Faz |
|---|---|---|---|---|---|---|---|
| CLASS / END CLASS taban blogu | OK | OK | KISMEN | KISMEN | KISMEN | Alan tabanli class parse var | R3 |
| PUBLIC/PRIVATE erisim bolgesi | OK | KISMEN | KISMEN | N/A | KISMEN | CLASS icinde access-directive parser ve fail-fast semantik denetimi eklendi; runtime erisim denetimi acik | OOP-P0 |
| METHOD bildirimi | OK | YOK | YOK | N/A | YOK | Dokumanda var, parser/runtime method modeli yok | OOP-P0 |
| THIS/ME modeli | KISMEN | YOK | YOK | YOK | YOK | Sozlesme netlestirilecek | OOP-P0 |
| Constructor/Destructor | KISMEN | YOK | YOK | YOK | YOK | Acik yasam dongusu politikasi gerekli | OOP-P1 |
| Inheritance | KISMEN | YOK | YOK | YOK | YOK | Tekli kalitim mvp sonradan | OOP-P1 |
| VTable/Polymorphism | KISMEN | YOK | YOK | YOK | YOK | Belgede hedef var, kod-gercekligi yok | OOP-P2 |
| Interface | KISMEN | YOK | YOK | YOK | YOK | Sozlesme denetimi henuz yok | OOP-P2 |

## 11) OOP Anahtar Kelime Hizli Imal Edilebilirlik (PDSX Uyum Haritasi)

Durum etiketleri:

- IMAL-SIMDI: Mevcut mimariyi bozmadan 1-2 sprintte eklenebilir
- IMAL-SIRADAKI: Once altyapi gerekir, sonra eklenir
- IMAL-SONRA: Yuksek etkili, ileri fazda
- CAKISMA: Dil sozlesmesi karari olmadan kilitlenir

### 11.1 Sinif Tanim ve Uye Anahtarlari

| Anahtar | Durum | Gerekce |
|---|---|---|
| CLASS / END CLASS | IMAL-SIMDI | Parse var, semantic/runtime genisletme gerekiyor |
| FIELD | IMAL-SIMDI | Mevcut CLASS_FIELD ile dogal uyumlu |
| METHOD | IMAL-SIMDI | SUB/FUNCTION baglama modeliyle eklenebilir |
| PUBLIC / PRIVATE | IMAL-SIMDI | Erisim denetimi compile-time metadata olarak eklenebilir |
| PROTECTED | IMAL-SIRADAKI | Inheritance semantigi bagimlisi |
| STATIC | IMAL-SIRADAKI | Class-level symbol tablosu gerekir |
| PROPERTY | IMAL-SIRADAKI | GET/SET semantigi ve typed value gerekir |
| CONSTRUCTOR / DESTRUCTOR | IMAL-SIRADAKI | NEW/DELETE yasam dongusu bagimlisi |
| READONLY / MUTABLE / IMMUTABLE | IMAL-SIRADAKI | Atama denetimi ve semantik kurallar gerekli |
| FRIEND / RESTRICTED | IMAL-SIRADAKI | CLASS icinde parser+same-namespace fail-fast semantik mvp eklendi; tam modul/runtime erisim modeli acik |

### 11.2 OOP Iliski ve Cagri Anahtarlari

| Anahtar | Durum | Gerekce |
|---|---|---|
| THIS | IMAL-SIRADAKI | Method activation record bagimlisi |
| SUPER | IMAL-SIRADAKI | Inheritance bagimlisi |
| NEW / DELETE | IMAL-SIRADAKI | Nesne yasam dongusu runtime modeli gerekli |
| INSTANCEOF | IMAL-SIRADAKI | Type id / inheritance tablosu gerekli |
| EXTENDS | IMAL-SIRADAKI | Tekli kalitim mvp ile acilabilir |
| IMPLEMENTS / INTERFACE | IMAL-SIRADAKI | Sozlesme denetimi katmani gerekli |
| OVERRIDE | IMAL-SIRADAKI | Method signature denetimi bagimlisi |
| VIRTUAL | IMAL-SONRA | VTable ve dispatch gerektirir |
| ABSTRACT | IMAL-SIRADAKI | Compile-time instantiate engeli kolay |
| FINAL / SEALED | IMAL-SIRADAKI | Inheritance denetimi ustunden kolay |
| OPERATOR (overload) | IMAL-SONRA | Expr resolver + overload dispatch gerekir |
| MIXIN | IMAL-SONRA | Coklu kompozisyon karmasikligi yuksek |
| DECORATOR | IMAL-SONRA | BASIC cekirdegi icin dogal degil |
| <SihirliMetot> | IMAL-SONRA | Runtime auto-bind sozlesmesi gerekir |

### 11.3 Namespace ve Modul Anahtarlari

| Anahtar | Durum | Gerekce |
|---|---|---|
| NAMESPACE / END NAMESPACE | IMAL-SIRADAKI | Symbol scope katmani ile acilabilir |
| USING | IMAL-SIRADAKI | Name resolution import kurali gerekir |
| MODULE / END MODULE | IMAL-SIRADAKI | Namespace ile iliski karari gerekir |
| MAIN / END MAIN | IMAL-SIRADAKI | Tek giris noktasi + legacy ust-duzey uyumluluk gerekir |
| ALIAS | IMAL-SIRADAKI | Compile-time esleme + imza uyumluluk denetimi gerekir |

### 11.4 Erisim Belirleyici Cakisma-Onleme Onerisi

| Model | Durum | Gerekce |
|---|---|---|
| PRIVATE (module/class ici) | IMAL-SIMDI | Mevcut semantic katmana dusuk riskle eklenebilir |
| PRIVATE + FRIEND (secili module istisnasi) | IMAL-SIRADAKI | Friend-list denetimi gerekir |
| RESTRICTED (namespace+project siniri) | IMAL-SIRADAKI | Import/include graph siniri net tanim ister |
| PUBLIC | IMAL-SIMDI | Symbol export metadata ile kolay |

