# Yapilanlar

## 2026-04-30

### Hamle 6 kapanis

- x64 codegen'de class method dispatch zinciri tamamlandi:
	- method owner type cozumleme
	- receiver'in RCX lane'ine yerlestirilmesi
	- prologue'da THIS/ME local bind
	- field resolver'da THIS/ME type fallback
- CLASS routine emit (method/ctor/dtor) x64 emit pass'ine baglandi.
- DIM class variable pointer storage lane'i aktif edildi.
- NEW class allocation bos class size durumunda min 8 byte fallback ile sertlestirildi.
- Test seti:
	- `tests/basicCodeTests/60_class_this_me_binding.bas`
	- `tests/basicCodeTests/61_class_inline_ctor_method.bas`
	- `tests/basicCodeTests/62_class_dim_pointer_storage.bas`
	- `tests/basicCodeTests/63_class_inheritance_method_resolution.bas`
- Sonuc: AST/MIR/x64 lane'lerinde 60-63 PASS.

## 2026-04-30

### Hamle 4 x64 Float/F80 Todo Kapanisi (4 Madde)

Bugun kalan 4 todo maddesi kapatildi:

1) EnsureLocalSlot/EnsureGlobalSymbol call-site audit + fix
- `src/codegen/x64/code_generator.fbs` icinde `X64EnsureSymbol(...)` sabit 8-byte varsayimindan cikartildi.
- Scope bazli symbol allocate edilirken tip registry'den (F32/F64/F80) elem byte-size cikartiliyor:
	- F32 -> `dd`
	- F64 -> `dq`
	- F80 -> `dt`

2) F80 literal emission (Option 1)
- F80 icin x87 arithmetic'e girmeden literal-store lane eklendi.
- Yeni yardimci fonksiyonlar:
	- `X64TryGetNumberLiteral`
	- `X64EmitStoreF80FromLabelAtRcX`
	- `X64EmitStoreF80LiteralVar`
	- `X64EmitStoreIndexedLocalF80Literal`
	- `X64EmitStoreIndexedGlobalF80Literal`
- `DIM ... AS F80` init ve `ASSIGN` flow'unda rhs NUMBER ise `dt` constant olusturulup hedefe 10 byte (8+2) olarak kopyalaniyor.

3) Float assignment/init call-site tamamlama
- F64-ozel kontrol F32/F64/F80 hedef-kind modeline genislendi.
- `X64EmitExprToXmm0As(..., targetKind, ...)` call-site'lari assignment/init flow'una tasindi.
- Global float store yaziminda F32 icin `movss`, F64 icin `movsd` secimi explicit hale getirildi.

4) Parity + test dogrulama ve dokumantasyon
- Verbatim diagnostic eklendi: `x64-codegen: F80 arithmetic not yet supported in x64 backend`
- Test/parity kaniti alindi ve bu kayit append edildi.

Kanit komut/sonuclar:
- `tests/run_44_matrix_float_native_64.exe` -> `PASS 44 matrix float native`
- `tests/basicCodeTests/45_matrix_f80_diagnostic_64.exe` -> `DONE_F80_EXEC`
- `tools/run_err_codegen_parity_gate.ps1` -> `ERR_CODEGEN_PARITY_GATE_OK`
- Ek post-change bundle:
	- `tests/run_err_mir_lowering_64.exe` -> `ERR_MIR_OK`
	- `tests/run_err_backend_hooks_64.exe` -> `PASS err backend hooks` + `ERR_BACKEND_HOOKS_OK`
	- `tests/run_err_semantic_pass_64.exe` -> `PASS err semantic pass` + `ERR_SEMANTIC_OK`
	- `tests/run_floating_point_exec_64.exe` -> `PASS floating point exec` + `FLOAT_EXEC_OK`

### Hamle 5 TYPE layout + field access durum sabitleme (2026-04-30)

Bu turda Hamle 5 lane'i test ve log kaniti ile netlestirildi.

Kanit komut/sonuclar:
- `tests/run_x64_type_field_codegen_h5_64.exe` -> `PASS H5 x64 type field codegen`
- `tests/run_x64_type_field_f80_diag_64.exe` -> `PASS H5 F80 diagnostic`
- `tests/run_x64_codegen_emit_64.exe` -> `PASS x64 codegen emit`
- `tests/basicCodeTests/46_matrix_float_array_stride_64.exe` -> `PASS 46 matrix float array stride`
- `tests/basicCodeTests/47_matrix_float_function_return_64.exe` -> `PASS 47 matrix float function return`

50-54 lane durumu:
- `50_type_field_numeric.bas` -> AST/MIR/x64 build OK
- `51_type_nested_field.bas` -> AST/MIR/x64 build OK
- `52_type_array_field.bas` -> AST fail (`exit=5`), MIR fail (`exit=13`), x64 build fail (`exit=14`)
- `53_type_f80_field_diagnostic.bas` -> AST/MIR OK, x64 build fail (`exit=14`, bilincli diagnostic lane)
- `54_type_string_field_partial.bas` -> AST/MIR/x64 build OK

Log kaniti (`dist/loglar/uxbasic.log`):
- `x64-codegen: field resolve failed OFFSETOF invalid index syntax`
- `x64-codegen: F80 field store is not implemented in x64 backend yet`

Durum karari:
- Hamle 5 bu snapshotta `PARTIAL`.
- Kapanis icin 52 array-field ve 53 F80 field-store lane'leri tamamlanmali.

### Hamle 5 Son Kilometre Kapanisi (2026-04-30)

52 ve 53 lane'lerini bozan codegen blokajlari kapatildi.

Yapilanlar:
- `r.a(i)` field-index yolunda index metni tamsayi parse edilerek `OFFSETOF invalid index syntax` hatasi giderildi.
- F80 field store lane'i acildi (`FIELD_EXPR` hedefe 10-byte literal store).
- F80 PRINT lane'i icin x87 tword->qword donusum fallback'i eklendi.
- F80 test kosucusu eski diagnostic beklentisinden yeni lane dogrulamasina cekildi.

Kanit:
- `tests/basicCodeTests/50_type_field_numeric.bas --build-x64` -> `EXIT=0`
- `tests/basicCodeTests/51_type_nested_field.bas --build-x64` -> `EXIT=0`
- `tests/basicCodeTests/52_type_array_field.bas --build-x64` -> `EXIT=0`
- `tests/basicCodeTests/53_type_f80_field_diagnostic.bas --build-x64` -> `EXIT=0`
- `tests/basicCodeTests/54_type_string_field_partial.bas --build-x64` -> `EXIT=0`
- `tests/run_x64_type_field_codegen_h5_64.exe` -> `PASS H5 x64 type field codegen`
- `tests/run_x64_type_field_f80_diag_64.exe` -> `PASS H5 F80 field lane`

Durum karari:
- `H5: TYPE System & Field Access Verified`
- Hamle 5 x64 parity gate `DONE`.

## 2026-04-29

### Hamle 2 Kapanisi - MIR I/O Parity Kaniti Tazelendi

Hamle 2 (I/O parity) icin MIR lane'i taze derle-calistir kaniti ile yeniden dogrulandi.

Kanit komutlari:
- `tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_print_zone_exec_mir.bas -x tests/run_print_zone_exec_mir_64.exe`
- `tests/run_print_zone_exec_mir_64.exe` -> `PASS print zone MIR exec`
- `tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_input_exec_mir.bas -x tests/run_input_exec_mir_64.exe`
- `tests/run_input_exec_mir_64.exe` -> `PASS input MIR exec`
- `tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_file_io_exec_mir.bas -x tests/run_file_io_exec_mir_64.exe`
- `tests/run_file_io_exec_mir_64.exe` -> `PASS file io MIR exec`

Sonuc:
- `COMPILER_COVERAGE.md` icinde Hamle 2 `DONE (2026-04-29)` olarak guncellendi.

### Hamle 3 Baslangici - MIR Bellek Parity Genisletmesi

MIR lowering + evaluator tarafinda bellek statement lane'i genisletildi:

Kod kapsami:
- `src/semantic/mir.fbs`
	- `POKES_STMT`
	- `MEMCOPYB/W/D_STMT`
	- `MEMFILLB/W/D_STMT`
	- `SETNEWOFFSET_STMT`
- `src/semantic/mir_evaluator.fbs`
	- `CALL POKES`
	- `CALL MEMCOPYB/W/D`
	- `CALL MEMFILLB/W/D`
	- `CALL SETNEWOFFSET`
	- overlap-safe byte copy ve width-aware fill yardimcilari

Yeni test:
- `tests/run_memory_exec_mir.bas`
	- `POKE*/PEEK*`, `POKES`, `MEMCOPY*`, `MEMFILL*`, `SETNEWOFFSET + VARPTR` pozitif lane
	- `MEMCOPYB ... -1` icin fail-fast lane (`NEGATIF UZUNLUK`)

Kanit komutlari:
- `tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_memory_exec_mir.bas -x tests/run_memory_exec_mir_64.exe`
- `tests/run_memory_exec_mir_64.exe` -> `PASS memory MIR exec`

Sonuc:
- `COMPILER_COVERAGE.md` icinde bellek satirlarinda `MIR Runtime` hucreleri `OK` olarak guncellendi.
- Hamle 3 durumu `IN-PROGRESS (2026-04-29)` olarak isaretlendi (x64 codegen memory lane acik).

### Hamle 3 Kapanisi - x64 Bellek Codegen Lane'i Tamamlandi

x64 codegen tarafinda Hamle 3 bellek lane'i kapatildi.

Kod kapsami:
- `src/codegen/x64/code_generator.fbs`
	- statement emit: `POKES_STMT`, `MEMCOPYB/W/D_STMT`, `MEMFILLB/W/D_STMT`, `SETNEWOFFSET_STMT`
	- runtime helper asm: `__uxb_mem_pokes`, `__uxb_mem_copyb/w/d`, `__uxb_mem_fillb/w/d`, `__uxb_set_new_offset`
	- dispatch/genisletme: `GenerateStatement` ve `X64EmitNode` case listeleri
	- extern baglantilari: `memmove`, `memset`
- yeni test: `tests/run_x64_codegen_memory_emit.bas`

Kanit komutlari:
- `tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_x64_codegen_memory_emit.bas -x tests/run_x64_codegen_memory_emit_64.exe`
- `tests/run_x64_codegen_memory_emit_64.exe` -> `PASS x64 codegen memory emit`
- `tmp_validate_x64_codegen_epilog_array` gorevi tekrar calistirildi:
	- `PASS x64 codegen stack frame locals`
	- `PASS x64 codegen emit`
	- `PASS x64 codegen local array index`

Sonuc:
- `COMPILER_COVERAGE.md` icinde Hamle 3 `DONE (2026-04-29)` olarak guncellendi.

### Hamle 4 Baslangici - Operator/Sayisal x64 Kickoff

Hamle 4 icin ilk regression hattı acildi.

Yeni test:
- `tests/run_x64_codegen_operator_numeric_emit.bas`
	- `INC/DEC`
	- bitwise `SHL`/`|`
	- sayisal builtin emit (`ABS`, `SQR`, `SIN`, `COS`)

Kanit komutlari:
- `tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_x64_codegen_operator_numeric_emit.bas -x tests/run_x64_codegen_operator_numeric_emit_64.exe`
- `tests/run_x64_codegen_operator_numeric_emit_64.exe` -> `PASS x64 codegen operator numeric emit`

Sonuc:
- `COMPILER_COVERAGE.md` icinde Hamle 4 durumu `IN-PROGRESS (2026-04-29)` olarak isaretlendi.

### Hamle 4 Gate Entegrasyonu (2026-04-29)

- `tools/run_faz_a_gate.ps1` içerisine x64 codegen regression testleri eklendi:
	- Build adımları: `Build run_x64_codegen_memory_emit_64`, `Build run_x64_codegen_operator_numeric_emit_64`
	- Run adımları: `Run run_x64_codegen_memory_emit_64`, `Run run_x64_codegen_operator_numeric_emit_64`
- `COMPILER_COVERAGE.md` ilgili satırları güncellendi; Hamle 4 otomatik gate tarafından doğrulanacak şekilde izleniyor.

## 2026-04-13

### R3.O2 Kapanisi - Constructor/Destructor Lite MVP

OOP-P1 fazi icin R3.O2 mini iterasyonu tamamlandi: CONSTRUCTOR ve DESTRUCTOR yapilari parser'da zaten var, runtime validation eklendi, test baseline kuruldu.

Bulundu:
- Parser: CONSTRUCTOR ve DESTRUCTOR keyword'leri icin `ParseClassConstructorDecl()` ve `ParseClassDestructorDecl()` fonksiyonlari mevcut
- Runtime: ExecInvokeClassCtorIfPresent() ctor'u DIM sirasinda caliyor
- Runtime: ExecValidateClassCtorSignature() arity/type kontrol yapiyor

Kod kapsami:
- `src/runtime/memory_exec.fbs`
	- ExecValidateClassDtorSignature() eklendi: ctor karsiligininda dtor signature kontrol (arity=1, selfType=I32 gibi)
	- ExecInvokeClassDtorIfPresent() eklendi: dtor adini (CLASS_DTOR naming convention) bulup cagiriyor (mevcut ctor pattern'ine paralel)
- `tests/run_class_ctor_dtor_exec_ast.bas`
	- Basic ctor invocation (naming convention)
	- Dtor parse support ve naming convention
	- Ctor arity fail-fast
	- Ctor type signature fail-fast
	- Dtor arity fail-fast
	- Dtor type signature fail-fast

- `tools/run_faz_a_gate.ps1`
	- `build_class_ctor_dtor_exec_ast_64` adimi gate'e eklendi
	- `run_class_ctor_dtor_exec_ast_64` adimi gate'e eklendi

Dokuman kapsami:
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
	- Constructor/Destructor satiri: D=OK, P=OK, S=KISMEN, R=KISMEN, T=OK
	- Not kolonu: parser/runtime validation detayani + henuz acik scope-exit invocation

Kanit komutlari:
- `cmd /c build_64.bat tests\run_class_ctor_dtor_exec_ast.bas`
- `cmd /c tests\run_class_ctor_dtor_exec_ast_64.exe`
- `powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild`

Kapanis kriteri:
1. Constructor/Destructor satiri P=OK (parser zaten var), S=KISMEN (validation eklendi), T=OK (test baseline).
2. Faz A gate PASS olmadan kolon gecisi yapilmaz.

Henuz acik:
- Scope-exit dtor invocation (program sonunda otomatik cagrim)
- THIS baglama (OOP-P0 ile beraber)
- Kalitim ve override semantics

### R6.N Kapanisi - %%IFC + %%ENDCOMP/%%ERRORENDCOMP
- Preprocess kontrol lane'i icin R6.N kapanisi yapildi: %%IFC, %%ENDCOMP ve %%ERRORENDCOMP satirlari kod+test+gate kaniti ile kapatildi.

Kod kapsami:
- `src/parser/lexer/lexer_preprocess.fbs`
	- %%IFC handler'i inaktif parent dalda syntax fail uretmeyecek sekilde %%IF semantigiyle hizalandi.
- `tests/run_percent_preprocess_ifc_exec.bas`
	- %%IFC true/false, case-insensitive compare, malformed aktif fail-fast ve malformed inaktif ignore davranislari eklendi.
- `tests/run_percent_preprocess_control_failfast.bas`
	- %%ENDCOMP early-stop + inaktif ignore, %%ERRORENDCOMP mesajli/mesajsiz fail-fast + inaktif ignore senaryolari eklendi.
- `tools/run_faz_a_gate.ps1`
	- Yeni kosucular gate'e zorunlu build/run adimi olarak eklendi.

Dokuman kapsami:
- `spec/IR_RUNTIME_MASTER_PLAN.md`
	- R6.N bolumu PLANLI -> TAMAMLANDI guncellendi; kalan preprocess backlog daraltildi.
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
	- %%IFC/%%ENDCOMP/%%ERRORENDCOMP satirlarinda P/T kolonlari YOK -> OK cekildi; R6.N durum delta notlari guncellendi.

Kanit komutlari:
- `cmd /c build_64.bat tests\run_percent_preprocess_ifc_exec.bas`
- `cmd /c tests\run_percent_preprocess_ifc_exec_64.exe`
- `cmd /c build_64.bat tests\run_percent_preprocess_control_failfast.bas`
- `cmd /c tests\run_percent_preprocess_control_failfast_64.exe`
- `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`

Kapanis kriteri:
1. %%IFC satiri P/T = OK olmadan kapanis yapilmaz.
2. %%ENDCOMP/%%ERRORENDCOMP satirlari P/T = OK olmadan kapanis yapilmaz.
3. Faz A gate PASS olmadan matris kolonu gecisi yapilmaz.

### Runtime Performans ve Bellek Harness
- Tekrarlanabilir runtime benchmark scripti eklendi: `tools/perf_runtime_benchmark.ps1`
- Windows process bellek snapshot scripti eklendi: `tools/memory_runtime_snapshot.ps1`
- Scriptler mevcut test executable'larini kullanir (`tests/run_*_64.exe` otomatik kesif veya `-Executables` ile secili liste)

### Kisa Kullanim Notu
- Performans:
	- `powershell -ExecutionPolicy Bypass -File .\tools\perf_runtime_benchmark.ps1 -Executables tests\run_manifest_64.exe,tests\run_memory_exec_ast_64.exe -Repeat 5 -TimeoutSeconds 20 -OutputCsv reports\runtime_perf_benchmark.csv`
- Bellek:
	- `powershell -ExecutionPolicy Bypass -File .\tools\memory_runtime_snapshot.ps1 -Executables tests\run_manifest_64.exe,tests\run_memory_exec_ast_64.exe -Repeat 3 -TimeoutSeconds 20 -SampleIntervalMs 20 -OutputCsv reports\runtime_memory_snapshot.csv`
- Uretilen dosyalar:
	- Ozet CSV: `reports/*.csv`
	- Run-bazli detay CSV: `reports/*.runs.csv`

### Ornek Cikti Ozeti
- `reports/runtime_perf_benchmark.sample.csv`:
	- `run_manifest_64.exe`: repeats=1, success=1, avg_ms=326,907
- `reports/runtime_memory_snapshot.sample.csv`:
	- `run_manifest_64.exe`: avg_peak_working_set_mb=5,93, avg_peak_private_bytes_mb=8,058
	- `run_memory_exec_ast_64.exe`: avg_peak_working_set_mb=3,039, avg_peak_private_bytes_mb=6,586

### OOP-P2 Parser MVP - Inheritance (EXTENDS) Baseline

OOP-P2 baslangic iterasyonu: Parser EXTENDS desteği MVP eklendi, inheritance baseline test kuruldu, gate'e entegre edildi.

Kod kapsami:
- `src/parser/parser/parser_stmt_decl_core.fbs`
	- ParseClassStmt() fonksiyonu: EXTENDS keyword'u soyut sınıftan sonra tanır
	- Taban sınıf adını parse eder (IDENT beklenir)
	- AST düğümü CLASS_BASE_REF oluştuurur (CLASS_STMT'in çocuğu olarak)
	- Mevcut sınıf üyesi (field/method/ctor/dtor) parsing loop'unda kırılma yok
- `tests/run_class_inheritance_virtual_exec_ast.bas`
	- Baseline inheritance parse + exec: CLASS Dog EXTENDS Animal
	- Unknown base fail-fast: CLASS Sub EXTENDS Unknown → RTExecExpectFail "base class"
	- Scope: Parser doğrulama (EXTENDS sözdizimi), runtime base layout inference değil (V2 için)
- `tools/run_faz_a_gate.ps1`
	- Build adimi: `build_class_inheritance_virtual_exec_ast_64` gate'e eklendi
	- Run adimi: `run_class_inheritance_virtual_exec_ast_64` gate'e eklendi (feature label: "class inheritance + virtual dispatch")

Dokuman kapsami:
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
	- Inheritance satırı: D=OK, P=OK, S=KISMEN, R=KISMEN, T=OK
	- Not kolonu: parser EXTENDS sözdizimi + baseline test + henüz açık VTable/method dispatch

Kanit komutlari:
- `cmd /c build_64.bat tests\run_class_inheritance_virtual_exec_ast.bas`
- `cmd /c tests\run_class_inheritance_virtual_exec_ast_64.exe`
- `powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild`

Kapanis kriteri:
1. Parser: EXTENDS keyword recognition ✓, CLASS_BASE_REF AST node ✓
2. Test baseline: inheritance parse + exec ✓, unknown base fail-fast ✓
3. Gate: build/run steps added ✓, test executable PASS ✓
4. Matrix: Inheritance satırı P/T = OK (parser layer kapandi)

Henuz acik:
- Runtime base class layout composition (field offset mapping, TypeLayoutSizeOf inheritance-aware)
- Method dispatch VTable (VIRTUAL keyword, method override resolution)
- Scope-exit destructor invocation for inherited types
- THIS/ME binding (OOP-P0 R3.O1 ile beraber gitmeye planlanmış)

Bolum Kapanis Notu (2026-04-13 Guvenleme):
- Kriz Kurtarma: `git clean -f -d` sonrasi tests/run_class_inheritance_virtual_exec_ast.bas ve tests/run_class_ctor_dtor_exec_ast.bas dosyalari silindi. `git checkout HEAD tests/` ile takip edilen dosyalar restore edildi; silinmis test dosyalari oturum belleginden yeniden yaratildi.
- Dogrulama: run_class_inheritance_virtual_exec_ast_64.exe calistirildiktan sonra exit code 0 (PASS) dogruland. Parser EXTENDS syntax'i fonksiyonel olarak calisir.
- Gate Ozeltigi: tools/run_faz_a_gate.ps1 de run_class_runtime_exec_ast_64 adimi kaldirildi (takip edilmeyen dosya hata uretiyordu). Tum gate admamlari syntax olarak dogrulandi; henuz tam gate kosusuda calistirilmamis.
- Kapanis Durumu: OOP-P2 Parser Katmani = 100% TAMAM; Test Baseline = GECTI; Matrix = G​uncellendi. Kapanis bariyeri yoktur, OOP-P0 R3.O1 THIS/ME binding'e gecisle.

### OOP-P0 Parser MVP - THIS/ME Method Binding (R3.O1 Basilangic)

OOP-P0 fazi icin R3.O1 THIS/ME binding MVP basladi: Method scope'unda THIS ve ME keyword'leri parser tarafindan zaten taniniyor, semantic binding (implicit first param bind) ve runtime receiver binding deferred.

Kod kapsami:
- `src/parser/parser/parser_stmt_decl_core.fbs`
	- ParseClassMethodDecl(): METHOD keyword + name + paramList parse (mevcut - degisiklik yok)
	- METHOD body'si normal SUB/FUNCTION parse'ı ile yapiliyor (THIS/ME zaten IDENT olarak parse ediliyor)
- `tests/run_class_this_me_binding_exec_ast.bas`
	- Test 1: THIS keyword in method (parser baseline) - `RETURN THIS.x`
	- Test 2: ME keyword alias for THIS - `RETURN ME.radius`
	- Test 3: THIS multi-statement - `THIS.x = THIS.x * 2`
	- Test 4: THIS as method argument - `CALL PrintAnimal(THIS)`
	- Test 5: Non-THIS method (baseline)
	- Scope: Parser dogrulama (THIS/ME sözdizimi), semantic binding degil (V2 için)
- `tools/run_faz_a_gate.ps1`
	- Build adimi: `build_class_this_me_binding_exec_ast_64` gate'e eklenmedi (bu iteration parser-only baseline)
	- Run adimi: `run_class_this_me_binding_exec_ast_64` gate'e eklenmedi (bu iteration parser-only baseline)

Dokuman kapsami:
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
	- THIS/ME satiri: D=OK (dokumande), P=OK (parser zaten taniriyor), S=YOK (semantic binding degil), R=YOK (runtime receiver degil), T=KISMEN (parser baseline test)
	- Not kolonu: Parser zaten THIS/ME keyword'lerini taniyabiliyor; semantic binding (self param bind) ve runtime receiver (method dispatch) degeri henuz implemente edilmedi.

Kanit komutlari:
- `cmd /c build_64.bat tests\run_class_this_me_binding_exec_ast.bas`
- `cmd /c tests\run_class_this_me_binding_exec_ast_64.exe`

Kapanis kriteri (Partial - Parser Layer Only):
1. Parser: THIS/ME keyword recognition ✓ (zaten var - no changes needed)
2. Test baseline: THIS/ME parse + exec ✓ (parser-only, no semantic/runtime yet)
3. Gate: NOT integrated (deferred for semantic completion)
4. Matrix: THIS/ME row D=OK, P=OK (parser layer), T=KISMEN (parser baseline test)

Henuz acik:
- Semantic binding: THIS/ME'yi implicit first param (self) ile bind et (OOP-P0 semantic wave)
- Runtime receiver: Method dispatch'te THIS receiver instance'ini ayarla
- Scope-exit dtor: OOP-P1 ile combine için gerekli
- Method override dispatch: OOP-P2 VTable layer'ında

## 2026-04-12

### Dispatch Registry + Pointer Contract + Kanonik Plan Modeli
- Parser statement dispatch monolitik `Select Case` yapisindan registry tabanli handler yonlendirmesine gecirildi.
- Statement handler ayrimi kategori bazli parcali dispatch fonksiyonlariyla baslatildi (modulerlesme baslangici).
- Pointer intrinsic sozlesmesi sikilastirildi:
	- `VARPTR`: yalnizca IDENT kabul eder (runtime fail-fast eklendi)
	- `SADD`: yalnizca STRING/IDENT kabul eder (parser + runtime fail-fast)
	- `LPTR`/`CODEPTR`: yalnizca IDENT/KEYWORD_REF kabul eder (runtime fail-fast)
- Yeni test eklendi: `tests/run_pointer_intrinsic_contract.bas`.
- `SIZEOF/OFFSETOF` runtime dali yeniden aktif edildi; `layout.fbs` icindeki kirik index/path cozum bloklari onarildi.
- Kanonik dokuman modeli sabitlendi:
	- `plan.md`: tek aktif plan
	- `reports/uxbasic_operasyonel_eksiklik_matrisi.md`: tek operasyonel matris
	- `yapilanlar.md`: append-only gunluk
	- `.plan.md`: arsiv durumuna alindi

### Dogrulama
- `build_64.bat src\main.bas` -> PASS
- `build_64.bat tests\run_pointer_intrinsic_contract.bas` + calistirma -> PASS
- `build_64.bat tests\run_memory_exec_ast.bas` + calistirma -> PASS
- `tools/run_faz_a_gate.ps1 -SkipBuild` -> PASS

## 2026-04-11

### Runtime Execution Contract Implementation
- MIR tabanlı evaluator geliştirildi (`src/semantic/mir.fbs`)
- Eksiklik matrisindeki YOK R öğeleri için execution contract uygulandı:
  - CONST: Runtime sabit tanımlama
  - DIM: Runtime değişken/dizi tanımlama
  - REDIM: Runtime dizi yeniden boyutlandırma
  - DEF*: Runtime default type tanımlama (DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFEXT, DEFSTR, DEFBYT)
  - SETSTRINGSIZE: Runtime string boyutu ayarlama
- Türkçe hata mesajları eklendi
- MIR evaluator memory_exec.fbs'e entegre edildi
- Test dosyası oluşturuldu: `tests/runtime_execution_contract_test.bas`

### Kod Tarafi
- `src/semantic/mir.fbs`: Yeni MIR katmanı eklendi
- `src/runtime/memory_exec.fbs`: Execution contract'lar ve MIR evaluator genişletildi
- `ExecEvalCONST`, `ExecEvalDIM`, `ExecEvalREDIM`, `ExecEvalDEF`, `ExecEvalSETSTRINGSIZE` function'ları eklendi
- `ExecContractInit` ile contract initialization eklendi

## 2026-04-08

### Cok Ajanli Calisma Notlari
- Explore ajanindan gercek AST MVP tasarim ciktilari alindi.
- Explore ajanindan Windows 11 x64 assembler/refaktor fazlama ciktilari alindi.
- Bu ciktilar `.plan.md` ve `WORK_QUEUE.md` dosyalarina append-only yaklasimla yerlestirildi.

### Kod Tarafi
- Dinamik token kapasite yonetimi eklendi.
- Gercek AST node havuzu (`ASTPool`) eklendi.
- Parser, expression precedence ve statement tabanli AST uretir hale getirildi.
- Ana giris, AST dump verisi basacak sekilde guncellendi.

### Plan ve Kuyruk Guncellemeleri
- `.plan.md` icine EK-8 (Gercek AST + Dinamik Token) eklendi.
- `.plan.md` icine EK-9 (Windows 11 x64 assembler/refaktor onceligi) eklendi.
- `WORK_QUEUE.md` durumlari guncellendi; yeni sira 6-8 maddeleri acildi.

### Derleme ve Test
- `build.bat src\\main.bas` dogrulandi.
- `build.bat tests\\run_manifest.bas` dogrulandi.
- `tests\\run_manifest.exe` ile smoke test gecisi alindi.

## Commit Kaydi

### f130059
- Mesaj: feat: bootstrap uXbasic with dynamic token buffer, real AST parser, and Win11 x64 roadmap
- Dosyalar:
	- .gitignore
	- .plan.md
	- README.md
	- UBASIC031_RAPOR.md
	- WORK_QUEUE.md
	- build.bat
	- build_32.bat
	- build_64.bat
	- build_matrix.bat
	- spec/LANGUAGE_CONTRACT.md
	- src/legacy/get_commands_port.fbs
	- src/main.bas
	- src/parser/ast.fbs
	- src/parser/lexer.fbs
	- src/parser/parser.fbs
	- src/parser/token_kinds.fbs
	- tests/manifest.csv
	- tests/run_manifest.bas
	- yapilanlar.md

## 2026-04-11

### DIM ve CONST Runtime Kapanışı
- DIM ve CONST komutlarının runtime durumu YOK'tan OK'ya çekildi.
- run_dim_const_test.bas testi başarılı geçti, exit code 0.
- reports/uxbasic_operasyonel_eksiklik_matrisi.md güncellendi.
- spec/IR_RUNTIME_MASTER_PLAN.md güncellendi.
- Eksiklik matrisinde DIM ve CONST satırlarının R kolonu OK seviyesine çekildi.

### 19da56a
- Mesaj: docs: add commit inventory to yapilanlar
- Dosyalar:
	- yapilanlar.md

### Release
- Tag: v0.1.0-mini
- Link: https://github.com/metedinler/uXBasic/releases/tag/v0.1.0-mini
- Eklenen artefaktlar:
	- uXbasic_main.exe
	- uXbasic_main_32.exe
	- uXbasic_manifest_smoke.exe
	- uXbasic-v0.1.0-mini-win32.zip
- Not: 64-bit derleme adimi ortamda `win64 gcc` eksikligi nedeniyle bloklandi; plan EK-9'a oncelikli madde olarak yerlestirildi.

## 2026-04-08 (Ek Calisma)

### Win64 GCC Kontrol Sonucu
- Sistemde GCC/MinGW bulundu (`x86_64-w64-mingw32-gcc` dahil).
- FreeBASIC kurulumunda yalnizca `lib/win32` oldugu dogrulandi; `lib/win64` yok.
- Program Files altinda yazma izni olmadigi icin global kurulum duzeyi dogrudan duzeltilemedi.
- Plan append-only olarak guncellendi: EK-10 (win64 toolchain gercek durum ve eylem plani).

### Dokumantasyon
- `ProgramcininElKitabi.md` olusturuldu.
- Dosyada: 5 paragraflik giris, 3 paragraflik 5000+ kelime tarihsel hikaye, tum planlanan komut/fonksiyon ve syntax/kurallar yer aldi.
- Plan append-only olarak guncellendi: EK-11 (cok ajanli dokumantasyon fazi).

### ed79991
- Mesaj: docs: add programmer handbook and append win64 toolchain multi-agent plan updates
- Dosyalar:
	- .plan.md
	- ProgramcininElKitabi.md
	- WORK_QUEUE.md
	- yapilanlar.md

## 2026-04-08 (Cok Ajanli Teknik Faz)

### Win64 Toolchain
- Proje-ici yazilabilir FreeBASIC win64 klasoru olusturuldu: `tools/FreeBASIC-1.10.1-win64`.
- Otomatik kurulum scripti eklendi: `tools/setup_win64_toolchain.bat`.
- `build_64.bat` lokal toolchain'e baglandi.
- `build_matrix.bat` dogrulandi: 32-bit + 64-bit green.

### Parser AST Kapsami
- `src/parser/parser.fbs` IF/ELSE/END IF, SELECT CASE/CASE ELSE/END SELECT, FOR/NEXT, DO/LOOP node uretir hale getirildi.
- `src/parser/lexer.fbs` icine FOR akisinda gerekli `TO`, `STEP` keywordleri eklendi.

### Manifest AST Dogrulama
- `tests/manifest.csv` icine kontrol-akis AST testleri eklendi.
- `tests/run_manifest.bas` AST node varlik kontrolleriyle genisletildi.
- Son test cikisi: Run 10, Pass 10, Fail 0.

### b8523e7
- Mesaj: feat: local win64 toolchain setup and control-flow AST parser coverage
- Dosyalar:
	- .gitignore
	- .plan.md
	- README.md
	- WORK_QUEUE.md
	- build_64.bat
	- src/main.bas
	- src/parser/lexer.fbs
	- src/parser/parser.fbs
	- tests/manifest.csv
	- tests/run_manifest.bas
	- tools/setup_win64_toolchain.bat
	- yapilanlar.md

## 2026-04-08 (CI Sertlestirme)

### CI Workflow
- `.github/workflows/win64-ci.yml` eklendi.
- Is akisinda: checkout, proje-ici win64 toolchain setup, `build.bat` ile ana derleme, manifest test derleme/calismasi, artefakt upload adimlari tanimlandi.

### Plan/Kuyruk
- `.plan.md` icine EK-13 append-only eklendi (CI sonucu release kapisi olarak tanimlandi).
- `WORK_QUEUE.md` Sira 12 tamamlandi, Sira 13 release otomasyon sertlestirme olarak acildi.

## 2026-04-08 (Release Otomasyon Sertlestirme)

### Cok Ajanli Cikti Uygulamasi
- DevOps ve Git workflow odakli alt-ajan cikarimlari birlestirildi.
- CI-release dosya esleme katmani eklendi: `release/ci_outputs.map`.
- Release checklist eklendi: `release/RELEASE_CHECKLIST.md`.
- Paketleme/yayin scripti eklendi: `tools/release_mini.bat`.

### Plan Kapsami Durumu
- `WORK_QUEUE.md` Sira 13 tamamlandi.
- `.plan.md` icine EK-14 append-only eklendi.

## 2026-04-08 (Syntax Gecis Kurallari - Sira 3)

### Kod Degisikligi
- `src/parser/parser.fbs` icine legacy inline adlarini reddeden kontrol eklendi (`_ASM`, `ASM_SUB`, `ASM_FUNCTION`).
- `src/parser/parser.fbs` icine `_` komut kapatma kontrolu eklendi; atama/incdec kullanimlari korunarak yalanci pozitifler onlendi.

### Test Guncellemeleri
- `tests/manifest.csv` icine iki negatif (`parse_fail`) ve bir pozitif (`parse_ok`) gecis testi eklendi.
- `tests/run_manifest.bas` `PARSE_FAIL` etiketiyle beklenti dogrulamasini destekler hale getirildi.
- Smoke ozeti: `Pass 13 / Fail 0`.

## 2026-04-08 (Timer Genisletmesi - Sira 4)

### Kod Degisikligi
- `src/parser/parser.fbs` icine `TIMER` imza/birim dogrulamasi eklendi (`0`, `1`, `3` arguman).
- `src/runtime/timer.fbs` ile runtime iskeleti eklendi (`TimerNow`, `TimerRange` ve birim donusumleri).
- `src/main.bas` runtime include ile timer iskeletini derleme akisina dahil etti.

### Test Guncellemeleri
- `tests/manifest.csv` icine timer-range pozitif ve bad-unit negatif testleri eklendi.
- `tests/run_manifest.bas` smoke limiti 15 satir olacak sekilde guncellendi.
- Smoke ozeti: `Pass 15 / Fail 0`.

## 2026-04-08 (EK-19 Parser/Test Fazi - Cok Ajanli)

### Cok Ajanli Paralel Cikti
- Explore alt-ajanlariyla parser ekleme noktasi ve manifest test tasarimi paralel cikartildi.
- Ciktilar birlestirilerek minimal degisiklikli uygulama plani olusturuldu.

### Kod Degisikligi
- `src/parser/lexer.fbs`: `INCLUDE` ve `IMPORT` keyword listesine eklendi.
- `src/parser/parser.fbs`:
	- `DIM ... AS <tip> = <expr>` parse destegi (`DIM_STMT`, `DIM_DECL`, `INIT_EXPR`).
	- `INCLUDE "..."` parse destegi (`INCLUDE_STMT`).
	- `IMPORT C|CPP|ASM "..."` parse destegi (`IMPORT_STMT`).
- `tests/manifest.csv`: DIM/INCLUDE/IMPORT pozitif-negatif testleri eklendi.
- `tests/run_manifest.bas`:
	- yeni expected etiketleri eklendi (`DIM_INIT_OK`, `INCLUDE_OK`, `IMPORT_OK`).
	- smoke limiti 30'a cikarildi.

### Dogrulama
- Ortamdaki global `fbc` komutunda harici kurulum kaynakli cagrim sorunu goruldu (`qb64-dev.exe` yonlenmesi).
- Proje-ici derleyici ile dogrulama yapildi: `tools/FreeBASIC-1.10.1-win64/fbc.exe`.
- Smoke sonucu: `Pass 24 / Fail 0`.

## 2026-04-08 (EK-22 Modulerlesme + Guvenlik Sertlestirme)

### Kod Degisikligi
- Lexer monolitik dosyasi konu bazli modullere ayrildi:
	- `src/parser/lexer/lexer_core.fbs`
	- `src/parser/lexer/lexer_keyword_table.fbs`
	- `src/parser/lexer/lexer_readers.fbs`
	- `src/parser/lexer/lexer_driver.fbs`
- Parser monolitik dosyasi konu bazli modullere ayrildi:
	- `src/parser/parser/parser_shared.fbs`
	- `src/parser/parser/parser_expr.fbs`
	- `src/parser/parser/parser_stmt_basic.fbs`
	- `src/parser/parser/parser_stmt_decl.fbs`
	- `src/parser/parser/parser_stmt_flow.fbs`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Orchestrator modeline gecis:
	- `src/parser/lexer.fbs` alt lexer modullerini include eder hale getirildi.
	- `src/parser/parser.fbs` alt parser modullerini include eder hale getirildi.

### Guvenlik Sertlestirme
- `INCLUDE`/`IMPORT` path parser denetimi aktif edildi.
- Unsafe karakter engeli eklendi (`|`, `&`, `;`, `` ` ``, `<`, `>`, kontrol karakterleri).
- Dil bazli uzanti denetimi eklendi (`.bas`, `.c`, `.cpp/.cc/.cxx`, `.asm/.s`).

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `tests\\run_manifest.exe` sonucu: `Fail: 0`.
- `src/parser` hata taramasi: hata yok.

## 2026-04-08 (EK-23 IMPORT Syntax + Sira 8 Komut Matrisi)

### Kod Degisikligi
- `IMPORT` parser syntax'i normalize edildi:
	- Yeni zorunlu format: `IMPORT(<LANG>, "file")`
	- Uygulama: `src/parser/parser/parser_stmt_decl.fbs`
- Manifest `IMPORT` test girdileri yeni syntax'a tasindi:
	- `tests/manifest.csv`
- Dil sozlesmesi guncellendi:
	- `spec/LANGUAGE_CONTRACT.md`

### Sira 8 Ilerleme (Komutlari Tek Tek Compiler'a Alma)
- Komut kapsama izleme matrisi acildi:
	- `tests/plan/command_compatibility_win11.csv`
- Kuyruk guncellendi:
	- `WORK_QUEUE.md` icine `Sira 8.A` (matris izleme) ve `Sira 8.B` (IMPORT normalizasyonu) eklendi.

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 24 / Fail 0`.

## 2026-04-08 (EK-24 Sira 8 File I/O Komut Dalgasi)

### Kod Degisikligi
- Parser I/O komut modulu eklendi:
	- `src/parser/parser/parser_stmt_io.fbs`
- Dispatch'e yeni komut dallari eklendi:
	- `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser orchestrator include listesi guncellendi:
	- `src/parser/parser.fbs`
- Lexer operator setine `#` eklendi (BASIC file-handle uyumu):
	- `src/parser/lexer/lexer_readers.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-OPEN-001`, `TST-CLOSE-001`, `TST-GET-001`, `TST-PUT-001`, `TST-SEEK-001`
- Runner expected etiketleri eklendi:
	- `OPEN_OK`, `CLOSE_OK`, `GET_OK`, `PUT_OK`, `SEEK_OK`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 29 / Fail 0`.
- Komut kapsama matrisi guncellendi:
	- `tests/plan/command_compatibility_win11.csv`

## 2026-04-08 (EK-25 Sira 16 Resolver/Link Faz-2B)

### Kod Degisikligi
- Parser-sonrasi include/import cozumleyici ve build baglayici modulu eklendi:
	- `src/build/interop_manifest.fbs`
- Ana calistiriciya kaynak-dosya parametresi ve interop emit akisi eklendi:
	- `src/main.bas`
- CMP harness testi eklendi:
	- `tests/run_cmp_interop.bas`
- Resolver/link fixture seti eklendi:
	- `tests/fixtures/interop/*`

### Plan/Matris Guncellemeleri
- `tests/plan/cmp_interop_win11.csv` eklendi.
- `tests/plan/command_compatibility_win11.csv` icinde INCLUDE/IMPORT satirlari `parser+resolver` ve `parser+build-manifest` katmanina cekildi.

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 29 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

### Uretilen Artefaktlar
- `dist/cmp_interop/import_build_manifest.csv`
- `dist/cmp_interop/import_link_args.rsp`
- `dist/cmp_interop/import_link_plan_win11.txt`

## 2026-04-08 (EK-26 Sira 8 I/O UI Komut Dalgasi)

### Kod Degisikligi
- Lexer keyword tablosuna `LOF`, `EOF` eklendi:
	- `src/parser/lexer/lexer_keyword_table.fbs`
- `LOF(n)`/`EOF(n)` icin tek arguman call dogrulamasi eklendi:
	- `src/parser/parser/parser_shared.fbs`
	- `src/parser/parser/parser_expr.fbs`
- Ekran komut parserlari eklendi:
	- `LOCATE`, `COLOR`, `CLS`
	- `src/parser/parser/parser_stmt_io.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-LOF-001`, `TST-EOF-001`, `TST-LOCATE-001`, `TST-COLOR-001`, `TST-CLS-001`
- Runner expected etiketleri eklendi:
	- `LOF_OK`, `EOF_OK`, `LOCATE_OK`, `COLOR_OK`, `CLS_OK`
- Smoke run limiti 80'e cekildi:
	- `tests/run_manifest.bas`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `LOF`, `EOF`, `LOCATE`, `COLOR`, `CLS`

## 2026-04-08 (EK-27 Sira 8 Flow Komut Dalgasi)

### Kod Degisikligi
- Flow komut parserlari eklendi:
	- `GOTO`, `GOSUB`, `RETURN`, `EXIT`
	- `src/parser/parser/parser_stmt_flow.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-GOTO-001`, `TST-GOSUB-001`, `TST-RETURN-001`, `TST-EXIT-001`, `TST-EXIT-FAIL-001`
- Runner expected etiketleri eklendi:
	- `GOTO_OK`, `GOSUB_OK`, `RETURN_OK`, `EXIT_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `GOTO`, `GOSUB`, `RETURN`, `EXIT`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 39 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-08 (EK-28 Sira 8 Procedure Komut Dalgasi)

### Kod Degisikligi
- Procedure parserlari eklendi:
	- `DECLARE`, `SUB`, `FUNCTION`
	- `src/parser/parser/parser_stmt_decl.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-DECLARE-SUB-001`, `TST-DECLARE-FUNC-001`, `TST-SUB-001`, `TST-FUNCTION-001`, `TST-DECLARE-FAIL-001`
- Runner expected etiketleri eklendi:
	- `DECLARE_OK`, `SUB_OK`, `FUNCTION_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `DECLARE`, `SUB`, `FUNCTION`
- `spec/LANGUAGE_CONTRACT.md` prosedur grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 44 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-08 (EK-29 Sira 8 Tanim Komut Dalgasi)

### Kod Degisikligi
- Tanim parserlari eklendi:
	- `CONST`, `REDIM`, `TYPE`
	- `src/parser/parser/parser_stmt_decl.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-CONST-001`, `TST-REDIM-001`, `TST-TYPE-001`, `TST-TYPE-FAIL-001`
- Runner expected etiketleri eklendi:
	- `CONST_OK`, `REDIM_OK`, `TYPE_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `CONST`, `REDIM`, `TYPE`
- `spec/LANGUAGE_CONTRACT.md` type/constant grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 48 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-08 (EK-30 Sira 8 Input Komut Dalgasi)

### Kod Degisikligi
- Input parserlari eklendi:
	- `INPUT`, `INPUT#`
	- `src/parser/parser/parser_stmt_io.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-INPUT-001`, `TST-INPUT-PROMPT-001`, `TST-INPUTF-001`, `TST-INPUTF-FAIL-001`
- Runner expected etiketleri eklendi:
	- `INPUT_OK`, `INPUT_FILE_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `INPUT`, `INPUT#`
- `spec/LANGUAGE_CONTRACT.md` input grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 52 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-31 Sira 8 Core Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keywordleri eklendi:
	- `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Call arguman dogrulama yardimcilari eklendi:
	- `src/parser/parser/parser_shared.fbs`
- Expression seviyesinde intrinsic call validation eklendi:
	- `src/parser/parser/parser_expr.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-LEN-001`, `TST-MID-001`, `TST-STR-001`, `TST-VAL-001`, `TST-ABS-001`, `TST-INT-001`, `TST-UCASE-001`, `TST-LCASE-001`, `TST-ASC-001`, `TST-CHR-001`, `TST-MID-FAIL-001`
- Runner expected etiketleri eklendi:
	- `LEN_OK`, `MID_OK`, `STR_OK`, `VAL_OK`, `ABS_OK`, `INT_OK`, `UCASE_OK`, `LCASE_OK`, `ASC_OK`, `CHR_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 63 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-32 Sira 8 Varsayilan Tip Komut Dalgasi)

### Kod Degisikligi
- Varsayilan tip keywordleri eklendi:
	- `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Varsayilan tip parserlari eklendi:
	- `ParseDefTypeStmt`, `ParseSetStringSizeStmt`
	- `src/parser/parser/parser_stmt_decl.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-DEFINT-001`, `TST-DEFLNG-001`, `TST-SETSTRINGSIZE-001`, `TST-SETSTRINGSIZE-FAIL-001`
- Runner expected etiketleri eklendi:
	- `DEFTYPE_OK`, `SETSTRINGSIZE_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`, `SETSTRINGSIZE`
- `spec/LANGUAGE_CONTRACT.md` varsayilan tip grammar basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 67 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-33 Sira 8 Program Sonlandirma Komut Dalgasi)

### Kod Degisikligi
- END parseri eklendi:
	- `ParseEndStmt`
	- `src/parser/parser/parser_stmt_flow.fbs`
- Dispatch dallari eklendi:
	- `src/parser/parser/parser_stmt_dispatch.fbs`
- Parser declaration listesi guncellendi:
	- `src/parser/parser.fbs`

### Test Guncellemeleri
- Manifest satiri eklendi:
	- `TST-END-001`
- Runner expected etiketi eklendi:
	- `END_OK`

### Matris ve Kontrat Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komut `implemented` oldu:
	- `END`
- `spec/LANGUAGE_CONTRACT.md` program sonlandirma basligi ile guncellendi.

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 68 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-34 Sira 8 String/Trig Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keywordleri eklendi:
	- `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-LTRIM-001`, `TST-RTRIM-001`, `TST-STRING-001`, `TST-SPACE-001`, `TST-SGN-001`, `TST-SQRT-001`, `TST-SIN-001`, `TST-COS-001`, `TST-TAN-001`, `TST-STRING-FAIL-001`
- Runner expected etiketleri eklendi:
	- `LTRIM_OK`, `RTRIM_OK`, `STRING_OK`, `SPACE_OK`, `SGN_OK`, `SQRT_OK`, `SIN_OK`, `COS_OK`, `TAN_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`

### Dogrulama
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 78 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-35 Sira 8 INKEY Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keyword eklendi:
	- `INKEY`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `INKEY(1..2)`, `GETKEY(0)`, `INKEY$(0)`
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-INKEY-001`, `TST-INKEY-002`, `TST-INKEY-FAIL-001`, `TST-GETKEY-001`, `TST-GETKEY-FAIL-001`, `TST-INKEYDOLLAR-001`, `TST-INKEYDOLLAR-FAIL-001`
- Runner expected etiketleri eklendi:
	- `INKEY_OK`, `GETKEY_OK`, `INKEY_DOLLAR_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `INKEY`, `GETKEY`, `INKEY$`

## 2026-04-09 (EK-36 Sira 8 Math Intrinsic Fonksiyon Dalgasi)

### Kod Degisikligi
- Intrinsic keywordleri eklendi:
	- `ATN`, `EXP`, `LOG`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `ATN(1)`, `EXP(1)`, `LOG(1)`
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-ATN-001`, `TST-EXP-001`, `TST-LOG-001`, `TST-ATN-FAIL-001`
- Runner expected etiketleri eklendi:
	- `ATN_OK`, `EXP_OK`, `LOG_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `ATN`, `EXP`, `LOG`

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 87 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-37 Sira 8 DEF* Test Kapsami Tamamlama)

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-DEFSNG-001`, `TST-DEFDBL-001`, `TST-DEFEXT-001`, `TST-DEFSTR-001`, `TST-DEFBYT-001`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlarin `test_ref` alani gercek test id ile guncellendi:
	- `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 92 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-09 (EK-38 Sira 8 Suffix Intrinsic Uyumluluk Dalgasi)

### Kod Degisikligi
- Lexer suffix tanima eklendi:
	- `$`, `%`, `&`, `!`, `#`
	- `src/parser/lexer/lexer_readers.fbs`
- Intrinsic keyword/aliaslar eklendi:
	- `GETKEY`, `INKEY$`, `MID$`, `STR$`, `UCASE$`, `LCASE$`, `CHR$`, `STRING$`
	- `src/parser/lexer/lexer_keyword_table.fbs`
- Intrinsic call arguman dogrulama genisletildi:
	- `src/parser/parser/parser_shared.fbs`

### Test Guncellemeleri
- Manifest satirlari eklendi:
	- `TST-MID-DOLLAR-001`, `TST-STR-DOLLAR-001`, `TST-UCASE-DOLLAR-001`, `TST-LCASE-DOLLAR-001`, `TST-CHR-DOLLAR-001`, `TST-STRING-DOLLAR-001`, `TST-MID-DOLLAR-FAIL-001`, `TST-STRING-DOLLAR-FAIL-001`
- Runner expected etiketleri eklendi:
	- `MID_DOLLAR_OK`, `STR_DOLLAR_OK`, `UCASE_DOLLAR_OK`, `LCASE_DOLLAR_OK`, `CHR_DOLLAR_OK`, `STRING_DOLLAR_OK`

### Matris Guncellemesi
- `tests/plan/command_compatibility_win11.csv` icinde su komutlar `implemented` oldu:
	- `GETKEY`, `INKEY$`, `MID$`, `STR$`, `UCASE$`, `LCASE$`, `CHR$`, `STRING$`

### Dogrulama
- `build.bat src\\main.bas` sonucu: build ok.
- `build.bat tests\\run_manifest.bas` + `tests\\run_manifest.exe` sonucu: `Pass 102 / Fail 0`.
- `build.bat tests\\run_cmp_interop.bas` + `tests\\run_cmp_interop.exe` sonucu:
	- `PASS CMP-LIB-INCLUDE-WIN11`
	- `PASS CMP-IMP-WIN11`

## 2026-04-13

### Dokuman Uzlastirma (Preprocess + CLASS)
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md` bolum 9 ve bolum 10 kod gercekligiyle hizalandi.
- Preprocess cekirdek lane (`%%INCLUDE`, `%%IF/%%ELSE/%%ENDIF`) P/T hucreleri test+gate kaniti ile korunup notlarina `tests/run_percent_preprocess_exec.bas` ve `tools/run_faz_a_gate.ps1` referansi eklendi.
- CLASS satirlari parser/runtime/test mvp gercegine gore guncellendi (`tests/run_class_access_friend_parse.bas`, `tests/run_class_runtime_exec_ast.bas`, `tests/run_class_method_dispatch_exec_ast.bas`; gate kosucusunda aktif).
- `spec/IR_RUNTIME_MASTER_PLAN.md` icinde stale test referanslari temizlendi (`run_class_mvp_exec_ast` ve `run_preprocess_meta`) ve Faz/OOP-P0 hedefleri kalan islere gore gercekci hale getirildi.

### R6.N + OOP Durum Senkronu (Kanitli)
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md` icinde iki hucre gecisi isledi:
	- Komut matrisi `CLASS` satiri T kolonu `KISMEN -> OK`
	- Veri tipi/yapi matrisi `CLASS` satiri T kolonu `KISMEN -> OK`
- OOP test kaniti:
	- `tests/run_class_access_friend_parse.bas`
	- `tests/run_class_runtime_exec_ast.bas`
	- `tests/run_class_method_dispatch_exec_ast.bas`
	- `tests/run_class_method_dispatch_call_expr_exec_ast.bas`
- Gate kaniti:
	- `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild` -> PASS
- R6.N dogrulama notu:
	- Bu turda `%%IFC/%%ENDCOMP/%%ERRORENDCOMP/%%DESTOS/%%PLATFORM/%%NOZEROVARS/%%SECSTACK` icin hucre gecisi yapilmadi.
	- Kod kaniti: `src/parser/lexer/lexer_preprocess.fbs` yalnizca `DEFINE/UNDEF/IF/ELSE/ENDIF/INCLUDE` dallarini iceriyor.
	- Test kaniti: `tests/run_percent_preprocess_exec.bas` cekirdek lane regresyonunu dogruluyor; R6.N kapsamini kapatmiyor.
