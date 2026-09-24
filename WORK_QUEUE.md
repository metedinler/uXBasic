# uXbasic Work Queue (Plan-Aligned)

## Capraz Not (Plan Uyum)
- Kanonik kural plan.md dosyasindadir: Her teslim/yanit sonunda Son oneriler bolumu zorunludur.
- Bu bolumde, mevcut prompt istek durumu ve onceki promptlardan kalan eksikler birlikte raporlanir.

## Sira 1 - Parser Cekirdegi
- Durum: tamamlandi
- Gorev: lexer operator seti genisletmesi (`++`, `--`, `+=`, `-=`, `=+`, `=-`, `**`, `@`)
- Sorumlu: Agent-Lexer
- Cikti: `src/parser/lexer.fbs`

## Sira 2 - Legacy Davranis Portu
- Durum: tamamlandi
- Gorev: KEYWORD2.BAS `GetCommands` davranisini FreeBASIC'e tasima
- Sorumlu: Agent-Port
- Cikti: `src/legacy/get_commands_port.fbs`

## Sira 3 - Syntax Geçis Kurallari
- Durum: tamamlandi
- Gorev: INLINE modeline gecis ve `_` komutlarin kapatilmasi
- Sorumlu: Agent-Syntax
- Cikti: parser semantik kontrolu + manifest negatif testleri

## Sira 4 - Timer Genisletmesi
- Durum: tamamlandi
- Gorev: `TIMER(unit)` ve `TIMER(start,end,unit)` parser/runtime iskeleti
- Sorumlu: Agent-Runtime
- Cikti: parser TIMER imza dogrulama + `src/runtime/timer.fbs` + manifest testleri

## Sira 5 - Dogrulama
- Durum: tamamlandi
- Gorev: test manifestinden ilk 10 testi kosacak harness
- Sorumlu: Agent-QA
- Cikti: `tests/run_manifest.bas` (manifest tabanli smoke runner)

## Sira 6 - Gercek AST Uretimi
- Durum: tamamlandi
- Gorev: parseri gercek AST node havuzu uretecek sekilde calistirmak
- Sorumlu: Agent-Parser
- Cikti: `src/parser/ast.fbs`, `src/parser/parser.fbs`

## Sira 7 - Dinamik Token Yonetimi
- Durum: tamamlandi
- Gorev: token listesinde kapasite-bazli dinamik buyume modeli
- Sorumlu: Agent-LexerCore
- Cikti: `src/parser/token_kinds.fbs`

## Sira 8 - Windows 11 x64 Refaktor Hazirligi
- Durum: basladi
- Gorev: ABI farklari, build matrix ve test matrix tanimlarini kod tabanina dagitmak
- Sorumlu: Agent-Backend64
- Cikti: plan ekleri + build/test scriptleri + `tests/plan/command_compatibility_win11.csv`

## Sira 8.A - Komut Kapsama Matrisi (Win11)
- Durum: basladi
- Gorev: Komutlari tek tek compiler isleme durumuna gore izlemek ve dalga dalga kapatmak
- Sorumlu: Agent-Backend64
- Cikti: `tests/plan/command_compatibility_win11.csv`

## Sira 8.B - IMPORT Syntax Normalizasyonu
- Durum: tamamlandi
- Gorev: `IMPORT(<LANG>, "file")` formunu parsera zorunlu syntax olarak islemek
- Sorumlu: Agent-ParserCompat
- Cikti: `src/parser/parser/parser_stmt_decl.fbs`, `tests/manifest.csv`, `spec/LANGUAGE_CONTRACT.md`

## Sira 8.C - File I/O Komut Dalgasi (OPEN/CLOSE/GET/PUT/SEEK)
- Durum: tamamlandi
- Gorev: Dosya komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_io.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.D - I/O UI Fonksiyon/Komut Dalgasi (LOF/EOF/LOCATE/COLOR/CLS)
- Durum: tamamlandi
- Gorev: Dosya bilgi fonksiyonlari ve ekran komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_expr.fbs`
	- `src/parser/parser/parser_shared.fbs`
	- `src/parser/parser/parser_stmt_io.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.E - Flow Komut Dalgasi (GOTO/GOSUB/RETURN/EXIT)
- Durum: tamamlandi
- Gorev: Legacy akis komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_flow.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.F - Procedure Komut Dalgasi (DECLARE/SUB/FUNCTION)
- Durum: tamamlandi
- Gorev: Prosedur bildirim ve blok komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_decl.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `spec/LANGUAGE_CONTRACT.md`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.G - Tanim Komut Dalgasi (CONST/REDIM/TYPE)
- Durum: tamamlandi
- Gorev: Sabit, yeniden boyutlandirma ve custom type komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_decl.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `spec/LANGUAGE_CONTRACT.md`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.H - Input Komut Dalgasi (INPUT/INPUT#)
- Durum: tamamlandi
- Gorev: Konsol ve dosya tabanli input komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_io.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `spec/LANGUAGE_CONTRACT.md`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.I - Core Intrinsic Fonksiyon Dalgasi
- Durum: tamamlandi
- Gorev: String ve matematik cekirdek fonksiyonlarini parser+expr-validation seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_shared.fbs`
	- `src/parser/parser/parser_expr.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.J - Varsayilan Tip Komut Dalgasi (DEF*/SETSTRINGSIZE)
- Durum: tamamlandi
- Gorev: Varsayilan tip ve string boyut komutlarini parser+AST seviyesinde tek tek compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_stmt_decl.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `spec/LANGUAGE_CONTRACT.md`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.K - Program Sonlandirma Komut Dalgasi (END)
- Durum: tamamlandi
- Gorev: Program sonlandirma komutunu parser+AST seviyesinde compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_flow.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/parser/parser.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `spec/LANGUAGE_CONTRACT.md`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.L - String/Trig Intrinsic Fonksiyon Dalgasi
- Durum: tamamlandi
- Gorev: Ek string ve trigonometrik intrinsic fonksiyonlari parser+expr-validation seviyesinde compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_shared.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 9 - Programci El Kitabi
- Durum: tamamlandi
- Gorev: tum planlanan komut/fonksiyon, kurallar ve syntax dokumani
- Sorumlu: Agent-Docs
- Cikti: `ProgramcininElKitabi.md`

## Sira 10 - Win64 Toolchain Tamamlama
- Durum: tamamlandi
- Gorev: win64 kutuphane iceren FreeBASIC toolchain'i yazilabilir proje klasorune entegre etmek
- Sorumlu: Agent-Toolchain
- Cikti: green `build_64.bat` + green `build_matrix.bat`

## Sira 11 - Kontrol Akisi AST Kapsami
- Durum: tamamlandi
- Gorev: IF/ELSE, SELECT/CASE, FOR/NEXT, DO/LOOP parser AST kapsami
- Sorumlu: Agent-ParserFlow
- Cikti: `src/parser/parser.fbs`, `tests/manifest.csv`, `tests/run_manifest.bas`

## Sira 12 - Win64 CI/Kurulum Sertlestirme
- Durum: tamamlandi
- Gorev: lokal toolchain setup scriptini CI adimlariyla birlestirmek
- Sorumlu: Agent-ReleaseInfra
- Cikti: `.github/workflows/win64-ci.yml` + matrix kapisi

## Sira 13 - Release Otomasyon Sertlestirme
- Durum: tamamlandi
- Gorev: mini release checklistini CI ciktilariyla senkron tutmak
- Sorumlu: Agent-ReleaseInfra
- Cikti: `release/ci_outputs.map`, `release/RELEASE_CHECKLIST.md`, `tools/release_mini.bat`

## Sira 14 - EK-19 Parser ve Manifest Fazi
- Durum: tamamlandi
- Gorev: `DIM init`, `INCLUDE`, `IMPORT (C/CPP/ASM)` parser grammar ve smoke test kapsami
- Sorumlu: Agent-ParserCompat
- Cikti: `src/parser/lexer.fbs`, `src/parser/parser.fbs`, `tests/manifest.csv`, `tests/run_manifest.bas`

## Sira 15 - EK-19 Resolver ve Build Entegrasyonu
- Durum: basladi
- Gorev: INCLUDE resolver + IMPORT build manifest/link entegrasyonu (Win11-x64)
- Sorumlu: Agent-BuildInterop
- Cikti: parser sonrasi dosya-cozumleyici + build baglayici katman + `CMP-*` uyumluluk artefaktlari

## Sira 15.A - EK-22 Moduler Parser/Lexer Refaktor (Faz-2A)
- Durum: tamamlandi
- Gorev: parser ve lexer monolitik yapisini konu bazli modullere ayirmak
- Sorumlu: Agent-ParserMod
- Cikti:
	- `src/parser/lexer.fbs` orchestrator + `src/parser/lexer/*`
	- `src/parser/parser.fbs` orchestrator + `src/parser/parser/*`

## Sira 15.B - EK-22 Parser Guvenlik Kapisi (Path Hijyen)
- Durum: tamamlandi
- Gorev: `INCLUDE`/`IMPORT` path girdilerinde unsafe karakter ve uzanti denetimi
- Sorumlu: Agent-SecureParse
- Cikti: `src/parser/parser/parser_stmt_decl.fbs`

## Sira 16 - EK-19 Resolver/Link Faz-2B
- Durum: tamamlandi
- Gorev: parser-sonrasi INCLUDE resolver ve IMPORT build manifest/link entegrasyonu
- Sorumlu: Agent-BuildInterop
- Cikti:
	- `src/build/interop_manifest.fbs`
	- `tests/run_cmp_interop.bas`
	- `tests/fixtures/interop/*`
	- `tests/plan/cmp_interop_win11.csv`
	- `dist/cmp_interop/import_build_manifest.csv` (testte uretilir)
	- `dist/cmp_interop/import_link_args.rsp` (testte uretilir)

## Sira 8.M - INKEY Intrinsic Fonksiyon Dalgasi
- Durum: tamamlandi
- Gorev: `INKEY`, `GETKEY` ve `INKEY$` imzalarini parser+expr-validation seviyesinde compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_shared.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.N - Math Intrinsic Fonksiyon Dalgasi (ATN/EXP/LOG)
- Durum: tamamlandi
- Gorev: `ATN`, `EXP`, `LOG` imzalarini parser+expr-validation seviyesinde compiler kapsamina almak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_shared.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.O - DEF* Test Kapsami Tamamlama
- Durum: tamamlandi
- Gorev: `DEFSNG/DEFDBL/DEFEXT/DEFSTR/DEFBYT` komutlari icin manifest testleri ve matrix test_ref alanlarini tamamlamak
- Sorumlu: Agent-Backend64
- Cikti:
	- `tests/manifest.csv`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.P - Suffix Intrinsic Uyumluluk Dalgasi (8 Komut)
- Durum: tamamlandi
- Gorev: Suffix uyumluluk komutlarini parser+expr-validation seviyesinde kapsama almak (`GETKEY`, `INKEY$`, `MID$`, `STR$`, `UCASE$`, `LCASE$`, `CHR$`, `STRING$`)
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/lexer/lexer_readers.fbs`
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/parser/parser_shared.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`
	- `spec/LANGUAGE_CONTRACT.md`

## Sira 8.Q - Pointer Intrinsic Ailesi (Win11 Guvenli Runtime)
- Durum: tamamlandi
- Gorev: `VARPTR`, `SADD`, `LPTR`, `CODEPTR` komut/fonksiyonlarinin Win11 user-mode guvenlik kurallariyla runtime tasarimini yapmak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_shared.fbs`
	- `src/runtime/memory_exec.fbs`
	- `spec/LANGUAGE_CONTRACT.md` (pointer semantik eki)
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.R - Inline x64 Backend Semantik Fazi
- Durum: tamamlandi
- Gorev: `INLINE(...) ... END INLINE` parser kabulunden sonra x64 ABI/register koruma ve cagri guvenligi semantigini backendde tamamlamak
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/codegen/x64/inline_backend.fbs`
	- `spec/LANGUAGE_CONTRACT.md` (inline x64 semantik eki)
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/run_inline_x64_backend.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.S - Genisletilmis Bellek Komutlari (POKES/MEMCOPY*/MEMFILL*)
- Durum: tamamlandi
- Gorev: `POKES`, `MEMCOPYW`, `MEMCOPYD`, `MEMFILLW`, `MEMFILLD`, `SETNEWOFFSET` komutlarini Win11 guvenlik modeliyle asamali aktiflestirmek
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/parser/parser/parser_stmt_basic.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
	- `src/runtime/memory_vm.fbs`
	- `src/runtime/memory_exec.fbs`
	- `tests/manifest.csv`, `tests/run_manifest.bas`
	- `tests/run_memory_vm.bas`, `tests/run_memory_exec_ast.bas`
	- `tests/plan/command_compatibility_win11.csv`

## Sira 8.T - Dosya I/O Ileri Semantik Standardizasyonu
- Durum: tamamlandi
- Gorev: `OPEN/GET/PUT/SEEK` komutlarinda record/binary mod semantigi, kanal sozlesmesi ve hata kodlarini Win11 profilinde standardize etmek
- Sorumlu: Agent-Backend64
- Cikti:
	- `src/runtime/file_io.fbs`
	- `src/runtime/memory_exec.fbs`
	- `spec/LANGUAGE_CONTRACT.md` (dosya semantik eki)
	- `tests/run_file_io_runtime.bas`
	- `tests/run_file_io_exec_ast.bas`
	- `tests/plan/command_compatibility_win11.csv`

## PSRT-OK Programi

Durum (2026-04-15): kismen tamamlandi. PSRT envanteri `reports/matrix_psrt_nonok_inventory.csv` icinde 0 satira indi; buna ragmen genel matriste R4/R5/R6 ve OOP-P0/P1/P2 kapsaminda acik satirlar devam ediyor.

Kural:
- D kolonu kapsam disi; tum tablolarda P/S/R/T kolonlari zorunlu OK.
- R=N/A olan satirlarda R muaf, P/S/T zorunlu OK.

Ilk 20 uygulanabilir gorev:

1. Gorev: W1 acik hucre envanterini dondur.
DoD: reports/uxbasic_operasyonel_eksiklik_matrisi.md icinde W1 kapsam satirlari etiketlenmis, degisim listesi yapilanlar.md'ye append edilmis.

2. Gorev: INPUT satirinda semantic acigini kapat.
DoD: INPUT satiri S=OK; dedicated test PASS; Faz A gate PASS.

3. Gorev: IF/ELSEIF/ELSE/END IF satirinda semantic acigini kapat.
DoD: ilgili satir S=OK; negatif/pozitif branch testleri PASS; Faz A gate PASS.

4. Gorev: SELECT CASE/CASE ELSE satirinda semantic acigini kapat.
DoD: ilgili satir S=OK; CASE branch testleri PASS; Faz A gate PASS.

5. Gorev: SUB/FUNCTION satirinda semantic kapanisi tamamla.
DoD: satir S=OK; scope + return contract testleri PASS; Faz A gate PASS.

6. Gorev: CONST satirinda semantic kapanisi tamamla.
DoD: satir S=OK; compile-time const contract testleri PASS; Faz A gate PASS.

7. Gorev: END IF/END SELECT/END SUB/END FUNCTION satirinda S/R/T aciklarini kapat.
DoD: satir S/R/T=OK; block-end fail-fast testleri PASS; Faz A gate PASS.

8. Gorev: %%IFC/%%ENDCOMP/%%ERRORENDCOMP satirlarinda semantic hucreleri OK'a cek.
DoD: bu satirlarda S=OK; preprocess dedicated testleri PASS; Faz A gate PASS.

9. Gorev: NAMESPACE/MODULE/MAIN satirlarinda parser+semantic kapanisi tamamla.
DoD: her satirda P/S/T=OK; block nesting ve duplicate fail-fast testleri PASS; gate PASS.

10. Gorev: USING/ALIAS satirlarinda parser+semantic kapanisi tamamla.
DoD: her satirda P/S/T=OK; conflict/cycle/ambiguous testleri PASS; gate PASS.

11. Gorev: %%DESTOS ve %%PLATFORM satirlarinda parser+semantic kapanisi tamamla.
DoD: her satirda P/S/T=OK; hedef secimi testleri PASS; gate PASS.

12. Gorev: %%NOZEROVARS ve %%SECSTACK satirlarinda parser+semantic kapanisi tamamla.
DoD: her satirda P/S/T=OK; bayrak davranis testleri PASS; gate PASS.

13. Gorev: REDIM runtime kapsam acigini (multi-dim + preserve) kapat.
DoD: REDIM satiri R=OK; run_dim_redim_exec_ast PASS; Faz A gate PASS.

14. Gorev: Operator runtime kapanisi (carpma/bolme/mod + compound assignment) tamamla.
DoD: operator tablosundaki ilgili R hucreleri OK; operator regression testleri PASS; gate PASS.

15. Gorev: Veri tipi cekirdegi (I* + BOOLEAN + STRING + ARRAY) icin S/R/T kapanisi tamamla.
DoD: ilgili satirlarda D haric hucre kalmaz; type/runtime regression PASS; gate PASS.

16. Gorev: CLASS statement ve veri tipi satirlarinda S/R kapanisini tamamla.
DoD: iki tabloda CLASS satirlari tam OK; class runtime test paketi PASS; gate PASS.

17. Gorev: OOP cekirdegi (METHOD, THIS/ME, ctor/dtor, inheritance, END CLASS) kapanisini tamamla.
DoD: ilgili OOP ve program yapisi satirlarinda P/S/R/T acigi kalmaz; oop regression PASS; gate PASS.

18. Gorev: CALL(DLL, ...) ve IMPORT satirlarinda FFI semantic/runtime kapanisini tamamla.
DoD: her iki satir tam OK; ENFORCE attestation testleri PASS; gate PASS.

19. Gorev: INLINE ve LIST/DICT/SET satirlarinda kalan aciklari kapat.
DoD: INLINE satiri S/T=OK, LIST/DICT/SET satiri S/R=OK; koleksiyon+inline testleri PASS; gate PASS.

20. Gorev: Floating-point ve OOP ileri satirlari (VTable/Interface) icin final kapanis.
DoD: FLOATING POINT + F32/F64/F80 + VTable/Polymorphism + Interface satirlarinda P/S/R/T=OK; strict gate PASS; final matrixte D haric acik hucre kalmaz.
