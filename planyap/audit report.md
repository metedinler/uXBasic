AUDIT REPORT: uXBasic Planning Gaps & Actionable Closures
Date: 17 Nisan 2026 | Thoroughness: Complete read-only analysis of 9 major planning documents

Update Note (18 Nisan 2026):
- ERR lane icin bu dokumandaki PLAN odakli satirlarin bir kismi guncelligini yitirmistir.
- Dogrulanmis checkpoint: planyap/uxbasic_dll_scope_codegen_master_plan.md (2026-04-18 checkpoint bolumu) ve reports/uxbasic_operasyonel_eksiklik_matrisi.md ERR/ERR-CG satirlari.
- Bu dosya tarihsel audit izi olarak korunur; operasyonel kararlar icin once guncel matrix/checkpoint esas alinmalidir.

1) ALL YOK/KISMEN/PLAN ITEMS (Not OK Status)
CRITICAL (P0) - Error Handling Core
Lane	D	P	S	R	T	Gap Severity
TRY/CATCH/FINALLY	OK	PLAN	PLAN	PLAN	PLAN	Parser skeleton missing
THROW	OK	PLAN	PLAN	PLAN	PLAN	Full parser+runtime gap
ASSERT	OK	PLAN	PLAN	PLAN	PLAN	Debug/release policy undefined
Source: reports/uxbasic_operasyonel_eksiklik_matrisi.md Section 2, rows 46-48; reports/MASTER_IC_SERT_INSAA_STANDARDI_2026-04-16.md Section 4.1

Impact: Blocks deterministic error propagation and codegen lane progression.

HIGH PRIORITY (P1) - FFI & OOP Extensions
Lane	D	P	S	R	T	Gap
Calling Convention (stdcall/cdecl)	OK	OK	OK	KISMEN	OK	Runtime no-op; real DLL calls unimplemented
x86 stdcall/cdecl cleanup	OK	OK	OK	KISMEN	KISMEN	Native host proof partial; SKIP/BLOCKED codes needed
uXStat DLL (first official)	OK	PLAN	PLAN	PLAN	PLAN	API contract + integration
EXIT IF	OK	OK	OK	OK	OK	Status contradictory (doc says KISMEN but matrix shows OK)
Source: reports/uxbasic_operasyonel_eksiklik_matrisi.md Section 12, rows 1-4; planyap/uxbasic_dll_scope_codegen_master_plan.md Section 6.3-6.5

Evidence Missing: x86 native lane deterministic criteria; uXStat API spec document

MEDIUM PRIORITY (P2) - OOP Completions
Feature	Status	Gap
PROTECTED/STATIC	KODDA-YOK	Keyword + scope semantics not implemented
PROPERTY (GET/SET)	KODDA-YOK	Auto-binding model undefined
SUPER	KODDA-YOK	Base method call protocol missing
NEW/DELETE	KODDA-YOK	Lifecycle outside DIM-based constructor model
INSTANCEOF	KODDA-YOK	Runtime type-id checking absent
ABSTRACT/FINAL/SEALED	KODDA-YOK	Enforcement guards missing
OPERATOR overload	KODDA-YOK	Resolver undefined
MIXIN/DECORATOR	KODDA-YOK	Composition model missing
THIS/ME semantic binding	KODDA-KISMEN	Parser works; semantic/runtime receiver binding deferred (see yapilanlar.md)
Source: reports/uxbasic_operasyonel_eksiklik_matrisi.md Section 11.1-11.4

Evidence Present: Parser baseline for EXTENDS, ctor/dtor, METHOD (yapilanlar shows completed test runs).

IN-PROGRESS (KISMEN) - Codegen & MIR Lanes
Lane	D	P	S	R	T	Gap
HIR formation	OK	KISMEN	KISMEN	N/A	KISMEN	Scope limited; needs expansion
MIR (CFG/basic block)	OK	KISMEN	KISMEN	KISMEN	KISMEN	Partial dispatch; no regression gate
MIR interpreter dispatch	OK	KISMEN	KISMEN	KISMEN	KISMEN	Statement parity test missing
x64 emitter (INLINE)	OK	OK	OK	KISMEN	KISMEN	Strategy present; emitter closure open
CALL [register]	OK	OK	OK	KISMEN	OK	Plan exists; runtime binding incomplete
Win64 ABI	OK	OK	OK	KISMEN	OK	Shadow space + alignment formula working
Regression parity gate	N/A	N/A	N/A	N/A	N/A	Not yet implemented
Source: reports/uxbasic_operasyonel_eksiklik_matrisi.md Section 13

Evidence: Partial codegen artifacts in dist/interop/ffi_call_x64_plan.csv (referenced but not yet generated at audit time).

PREPROCESS & SCOPE (Mostly Closed)
Feature	Status	Evidence
%%IFC	OK/OK/OK/N/A/OK	test: tests/run_percent_preprocess_ifc_exec.bas PASS (yapilanlar)
%%ENDCOMP/%%ERRORENDCOMP	OK/OK/OK/N/A/OK	test: tests/run_percent_preprocess_control_failfast.bas PASS (yapilanlar)
NAMESPACE/MODULE/MAIN	OK/OK/OK/N/A/OK	gate: tools/run_faz_a_gate.ps1 PASS
USING/ALIAS	OK/OK/OK/OK/OK	Scope+FFI integration tests PASS (yapilanlar)
Source: yapilanlar.md "2026-04-13" section; reports/uxbasic_operasyonel_eksiklik_matrisi.md Sections 8-9

2) EVIDENCE: PRESENT vs MISSING
Evidence PRESENT (High Confidence)
What	Where	Status
Parser baseline tests	tests/run_class_*.bas, tests/run_call_dll_*.bas, tests/run_percent_preprocess_*.bas	All PASS (yapilanlar)
Runtime tests	tests/run_*_exec_ast.bas suite	50+ executable tests, gate-integrated
Gate pipeline	tools/run_faz_a_gate.ps1	Runs 40+ build/test steps; currently PASS
Performance baseline	reports/runtime_perf_dispatch_preprocess_collections.csv	Benchmarks: 24-37ms avg; PASS
FFI x86 native proof	reports/ffi_conv3_native_lanes_report.md	native_cleanup: PASS, native_symptr_patch: PASS
Operasyonel matrix	reports/uxbasic_operasyonel_eksiklik_matrisi.md	100+ rows; updated 2026-04-16
yapilanlar append log	yapilanlar.md	Complete history 2026-04-12 to 2026-04-17
Evidence MISSING (Risk Areas)
What	Impact	Reason
ERR-1 parser grammar	Blocks error model	TRY/CATCH tokens + AST nodes not yet in lexer/parser
ERROR global object schema	Blocks semantic binding	Global error field list not formally specified
MIR parity test harness	Blocks codegen validation	Interpreter vs compiled dual-mode test missing
uXStat C++ stub	Blocks DLL integration	No extras/uxstat/include or src/ skeleton yet
x86 native determinism criteria	Blocks release gate	SKIP/BLOCKED reason codes not formalized
FLOATING POINT expression evaluator	Blocks numeric completeness	Promotion rules + precedence not enforced in runtime
Regression parity gate script	Blocks MIR closure	Test runner comparing interp vs compiled not created
3) TOP 5 ACTIONABLE CLOSURES (Can Code Now)
Closure #1: ERR-1 Parser/Semantic/Runtime MVP [HIGHEST ROI]
Effort: High | Impact: Blocks codegen+error handling; unblocks 3 matrix rows | Dependencies: None

What to code:

src/parser/lexer/lexer_keyword_table.fbs — Add TRY, CATCH, FINALLY, END TRY, THROW, ASSERT tokens
src/parser/parser/parser_stmt_flow.fbs — Add ParseTryStmt(), ParseThrowStmt(), ParseAssertStmt() handlers
src/semantic/semantic_stmt.fbs — Add TRY scope + CATCH variable binding + THROW arity/type guards (validate ERROR exists)
src/runtime/memory_exec.fbs — Add handler stack (catch scope tracking) + THROW air-gap jump + FINALLY guarantee execution
tests/run_err_try_throw_assert_exec.bas — Integrate with gate (already referenced in matrix notes as existing)
tools/run_faz_a_gate.ps1 — Add build/run steps for ERR tests
Matrix rows affected: TRY/CATCH/FINALLY, THROW, ASSERT (all 3 rows: PLAN → KISMEN/OK)

Evidence to consume:

reports/MASTER_IC_SERT_INSAA_STANDARDI_2026-04-16.md Section 7: P0.1 ERR-1 spec
planyap/uxbasic_dll_scope_codegen_master_plan.md Section 6.6: ERR mimari karar
Sibling tests for reference: tests/run_call_exec.bas, tests/run_if_exec_ast.bas
Gate validation: build_64.bat tests\run_err_try_throw_assert_exec.bas && tests\run_err_try_throw_assert_exec_64.exe && tools\run_faz_a_gate.ps1 -SkipBuild

Closure #2: OOP-P0 THIS/ME Semantic Binding (R3.O1) [MEDIUM ROI, FAST PAYOFF]
Effort: Medium | Impact: Extends parser baseline to semantic layer; foundation for method dispatch | Dependencies: Parser baseline done (see yapilanlar.md)

What to code:

src/semantic/semantic_stmt.fbs — In method scope, bind first implicit parameter self to THIS/ME identifier
src/runtime/runtime_method_dispatch.fbs — Method call receiver binding: set THIS/ME value to instance pointer
tests/run_class_this_me_semantic_pass.bas — Extend parser-baseline test with semantic validation + method-call receiver binding
Test: THIS in non-method scope → fail-fast
Test: THIS field access in method → runtime receiver bound correctly
Test: THIS.method() call → receiver propagates
tools/run_faz_a_gate.ps1 — Integrate new semantic pass test
Matrix rows affected: THIS/ME (parser=OK, semantic=KISMEN→OK, runtime=KISMEN→OK)

Evidence to consume:

yapilanlar.md "OOP-P0 Parser MVP — THIS/ME" section: Parser already recognizes THIS/ME
Test baseline: tests/run_class_this_me_binding_exec_ast.bas (parser-only; ready to extend)
Reference: METHOD dispatch tests tests/run_class_method_dispatch_exec_ast.bas (already PASS in matrix)
Gate validation: build_64.bat tests\run_class_this_me_semantic_pass.bas && tests\run_class_this_me_semantic_pass_64.exe && tools\run_faz_a_gate.ps1 -SkipBuild

Closure #3: FFI-CONV-3 Native Lane Determinism [QUICK WIN]
Effort: Low-Medium | Impact: Stabilizes x86 release gate; resolves native proof blockers | Dependencies: Helper scripts exist (tools/run_ffi_conv3_native_lanes.ps1)

What to code:

reports/ffi_conv3_native_lanes_report.md — Formalize SKIP/BLOCKED reason codes (e.g., x86_NOT_DETECTED, TIMEOUT_GRACE, HOST_PERMISSION_DENIED)
tools/run_ffi_conv3_native_lanes.ps1 — Add deterministic skip criteria check (detect x86 availability at start; skip gracefully if missing)
tests/probes/run_ffi_x86_native_cleanup_probe.bas — Ensure portable x86 detection (__FB_WIN32__ && NOT __FB_WIN64__)
Matrix reports/uxbasic_operasyonel_eksiklik_matrisi.md — Document x86 detection logic in FFI-CONV-3 note column
Matrix rows affected: x86 calling convention row (R/T: KISMEN→OK if graceful skip justified)

Evidence to consume:

reports/ffi_conv3_native_lanes_report.md: Already shows native_cleanup PASS and native_symptr_patch PASS
planyap/uxbasic_dll_scope_codegen_master_plan.md Section 6.5: FFI-CONV-3 MVP complete; stabilization needed
CI context: .github/workflows/win64-ci.yml (audit shows no x86 CI step; document design decision)
Gate validation: tools/run_ffi_conv3_native_lanes.ps1 && cat reports/ffi_conv3_native_lanes_report.md | grep -E '(PASS|SKIP|BLOCKED)'

Closure #4: FLOATING POINT Expression Evaluator Completion [HIGH PRECISION VALUE]
Effort: Medium | Impact: Closes numeric model completeness; unblocks R4 phase | Dependencies: Core float runtime exists (matrix shows OK for most float intrinsics)

What to code:

src/runtime/eval_expr_float.fbs — Implement missing:
Numeric type promotion chain (I32→F32→F64 when mixed operators present)
Operator precedence + associativity for ** (right-to-left), division (left-to-right)
Float domain guards (LOG domain, division-by-zero, underflow)
src/semantic/semantic_expr.fbs — Validate float coercion rules in semantic pass (catch type mismatches before runtime)
tests/run_floating_point_exec.bas — Extend with:
Mixed int/float expression tests (1 + 2.5 should promote)
Operator precedence tests (232 == 512, not 64)
Domain error tests (LOG(-1) fail-fast)
tools/run_faz_a_gate.ps1 — Ensure floating_point test steps marked as R4 gate components
Matrix rows affected: Operator precedence/promotion note column (currently sparse; clarify float semantics)

Evidence to consume:

tests/run_floating_point_exec.bas: Exists and PASS (yapilanlar references as gate artifact)
reports/uxbasic_operasyonel_eksiklik_matrisi.md Section 6: "float evaluator henuz acik" (float evaluator still open)
Reference operator tests: tests/run_core_types_exec_ast.bas
Gate validation: build_64.bat tests\run_floating_point_exec.bas && tests\run_floating_point_exec_64.exe && tools\run_faz_a_gate.ps1 -SkipBuild

Closure #5: uXStat DLL Minimal API Skeleton [FOUNDATION FOR FFI COMPLETION]
Effort: Medium-High | Impact: Unblocks first official DLL integration; validates CALL(DLL) end-to-end; foundation for phase 2 | Dependencies: CALL(DLL) policy + alias infrastructure done (matrix shows OK)

What to code:

Create scaffold directories:
extras/uxstat/include/uxstat_core.h — Minimal C ABI header (data structure definitions)
extras/uxstat/src/uxstat_memory.cpp — Alloc/free implementation
extras/uxstat/src/uxstat_vector.cpp — StatVector create/destroy/set/get
extras/uxstat/bas/uxstat.bas — uXBasic wrapper declarations:
DECLARE FUNCTION uxb_vec_create LIB "uxstat" CDECL AS I64 ()
DECLARE SUB uxb_vec_set LIB "uxstat" CDECL (handle AS I64, index AS I32, value AS F64)
DECLARE FUNCTION uxb_stat_mean LIB "uxstat" CDECL AS F64 (handle AS I64)
tests/run_uxstat_dll_integration_exec.bas — Test skeleton:
CALL(DLL) → uxb_vec_create
CALL(DLL) → uxb_stat_mean with real vector
Fail-fast: invalid handle
planyap/uxbasic_dll_scope_codegen_master_plan.md Section 3 (Phase C) — Update timeline + checklist
Build + gate integration (separate PR/task; defer full build)
Matrix rows affected: uXStat (PLAN→KISMEN) + FFI-SCOPE-2 (marshalling validation)

Evidence to consume:

planyap/uxbasic_dll_scope_codegen_master_plan.md Section 1, 3: DLL bootstrap requirements + kapsam
reports/uxbasic_operasyonel_eksiklik_matrisi.md Section 12 (DLL Matrix): Row 12 uXStat currently PLAN
Existing FFI tests: tests/run_call_dll_alias_exec_ast.bas (marshalling patterns already proven)
Gate validation: (deferred to phase 2) Build uxstat.dll; then build_64.bat tests\run_uxstat_dll_integration_exec.bas && tests\run_uxstat_dll_integration_exec_64.exe

SUMMARY TABLE: Planning Maturity by Phase
Phase	Status	Open Rows	Top Blocker	Recommendation
R1-R4	✅ MOSTLY OK	EXIT IF (doc clarify)	None	Document EXIT IF clarification
R5-R6	✅ PARSER OK	%% preprocess edge cases	Preprocess backlog minimal	Close preprocess backlog (low effort)
ERR	❌ PLAN	TRY/CATCH/THROW/ASSERT (12 cells)	ERROR model undefined	START: P0.1 ERR-1 immediately
FFI	⚠️ KISMEN	Calling conv runtime, uXStat, x86 native determinism	Native proof host-conditional	START: Closure #3 (stabilize native), then #5 (uXStat)
OOP	⚠️ MIXED	THIS/ME binding, PROTECTED/STATIC, SUPER, etc. (16 features KODDA-YOK)	THIS/ME semantic binding	START: Closure #2 (semantic binding foundation)
CG/MIR	❌ KISMEN	HIR/MIR dispatch, parity gate, codegen lanes (12+ rows)	MIR parity harness missing	Deferred; post-ERR-1 (requires error handling for debugging)
FINAL RECOMMENDATION
Immediate Sprint (Week 1):

Closure #1 (ERR-1 Parser/Semantic/Runtime) — 3-4 days — Unblocks error handling + codegen validation
Closure #3 (FFI-CONV-3 Native Determinism) — 1 day quick win — Stabilizes release gate
Week 2: 3. Closure #2 (THIS/ME Semantic Binding) — 2 days — Foundation for OOP method dispatch 4. Closure #5 (uXStat DLL Skeleton) — 2-3 days — Unblocks first official DLL integration

Week 3: 5. Closure #4 (FLOATING POINT Evaluator) — 1-2 days — Numeric model completeness

This sequence resolves 9 of 12 critical matrix gaps and unblocks codegen + OOP depth lanes within 2 weeks.

Explore: CG3 UXSTAT implementation map
Reviewed 2 files


# DENETİM RAPORU: uXBasic Planlama Boşlukları ve Aksiyonel Kapatmalar
**Tarih:** 17 Nisan 2026 | **Kapsam:** 9 ana planlama dokümanının tam analizi

## 1) TÜM YOK/KISMEN/PLAN DURUMLARI (Tamamlanmamış Kalemler)

### KRİTİK (P0) - Çekirdek Hata Yönetimi
| Alan | D | P | S | R | T | Boşluk Şiddeti |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TRY/CATCH/FINALLY** | OK | PLAN | PLAN | PLAN | PLAN | Parser iskeleti eksik |
| **THROW** | OK | PLAN | PLAN | PLAN | PLAN | Parser + Runtime boşluğu |
| **ASSERT** | OK | PLAN | PLAN | PLAN | PLAN | Debug/Release politikası belirsiz |

**Kaynak:** reports/uxbasic_operasyonel_eksiklik_matrisi.md Bölüm 2, satır 46-48; reports/MASTER_IC_SERT_INSAA_STANDARDI_2026-04-16.md Bölüm 4.1

**Etki:** Deterministik hata yayılımını ve kod üretimi (codegen) ilerlemesini engelliyor.

### YÜKSEK ÖNCELİK (P1) - FFI ve OOP Uzantıları
| Alan | D | P | S | R | T | Boşluk |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Çağrı Kuralları (stdcall/cdecl)** | OK | OK | OK | KISMEN | OK | Runtime'da işlem yapmıyor; gerçek DLL çağrıları eksik |
| **x86 stdcall/cdecl Temizliği** | OK | OK | OK | KISMEN | KISMEN | Yerel ana makine kanıtı kısmi; SKIP/BLOCKED kodları lazım |
| **uXStat DLL (İlk Resmi DLL)** | OK | PLAN | PLAN | PLAN | PLAN | API sözleşmesi + entegrasyon |
| **EXIT IF** | OK | OK | OK | OK | OK | Durum çelişkili (doküman KISMEN diyor, matris OK gösteriyor) |

**Kaynak:** reports/uxbasic_operasyonel_eksiklik_matrisi.md Bölüm 12, satır 1-4; planyap/uxbasic_dll_scope_codegen_master_plan.md Bölüm 6.3-6.5

**Eksik Kanıtlar:** x86 yerel hat deterministik kriterleri; uXStat API spesifikasyon dokümanı.

### ORTA ÖNCELİK (P2) - OOP Tamamlamaları
| Özellik | Durum | Boşluk |
| :--- | :--- | :--- |
| **PROTECTED/STATIC** | KODDA-YOK | Anahtar kelime + kapsam (scope) semantiği uygulanmadı |
| **PROPERTY (GET/SET)** | KODDA-YOK | Otomatik bağlama modeli tanımlanmadı |
| **SUPER** | KODDA-YOK | Üst sınıf metod çağrı protokolü eksik |
| **NEW/DELETE** | KODDA-YOK | DIM tabanlı kurucu modelinin dışındaki yaşam döngüsü eksik |
| **INSTANCEOF** | KODDA-YOK | Çalışma zamanı tip-id kontrolü (RTTI) yok |
| **ABSTRACT/FINAL/SEALED** | KODDA-YOK | Zorlayıcı koruma mekanizmaları eksik |
| **OPERATOR Overload** | KODDA-YOK | Çözümleyici (resolver) tanımlanmadı |
| **MIXIN/DECORATOR** | KODDA-YOK | Kompozisyon modeli eksik |
| **THIS/ME Semantik Bağlama** | KODDA-KISMEN | Parser çalışıyor; semantik/runtime alıcı bağlaması ertelendi |

**Kaynak:** reports/uxbasic_operasyonel_eksiklik_matrisi.md Bölüm 11.1-11.4

**Mevcut Kanıtlar:** EXTENDS, ctor/dtor, METHOD için parser temeli hazır (yapilanlar'da tamamlanmış testler mevcut).

### DEVAM EDEN (KISMEN) - Codegen ve MIR Kanalları
| Alan | D | P | S | R | T | Boşluk |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **HIR Oluşumu** | OK | KISMEN | KISMEN | N/A | KISMEN | Kapsam sınırlı; genişletilmeli |
| **MIR (CFG/Temel Blok)** | OK | KISMEN | KISMEN | KISMEN | KISMEN | Kısmi sevkiyat; regresyon kapısı yok |
| **MIR Interpreter Sevkiyatı** | OK | KISMEN | KISMEN | KISMEN | KISMEN | Deyim parite testi eksik |
| **x64 Emitter (INLINE)** | OK | OK | OK | KISMEN | KISMEN | Strateji mevcut; emitter kapatması açık |
| **CALL [register]** | OK | OK | OK | KISMEN | OK | Plan mevcut; çalışma zamanı bağlaması eksik |
| **Win64 ABI** | OK | OK | OK | KISMEN | OK | Gölge alan + hizalama formülü çalışıyor |
| **Regresyon Parite Kapısı** | N/A | N/A | N/A | N/A | N/A | Henüz uygulanmadı |

**Kaynak:** reports/uxbasic_operasyonel_eksiklik_matrisi.md Bölüm 13

**Kanıtlar:** dist/interop/ffi_call_x64_plan.csv içinde kısmi codegen eserleri (atıfta bulunulmuş ancak henüz üretilmemiş).

### ÖN İŞLEME VE KAPSAM (Büyük Oranda Kapalı)
| Özellik | Durum | Kanıt |
| :--- | :--- | :--- |
| **%%IFC** | OK/OK/OK/N/A/OK | test: tests/run_percent_preprocess_ifc_exec.bas GEÇTİ |
| **%%ENDCOMP/%%ERRORENDCOMP** | OK/OK/OK/N/A/OK | test: tests/run_percent_preprocess_control_failfast.bas GEÇTİ |
| **NAMESPACE/MODULE/MAIN** | OK/OK/OK/N/A/OK | kapı: tools/run_faz_a_gate.ps1 GEÇTİ |
| **USING/ALIAS** | OK/OK/OK/OK/OK | Kapsam+FFI entegrasyon testleri GEÇTİ |

**Kaynak:** yapilanlar.md "2026-04-13" bölümü; reports/uxbasic_operasyonel_eksiklik_matrisi.md Bölüm 8-9

---

## 2) KANITLAR: MEVCUT vs EKSİK

### Mevcut Kanıtlar (Yüksek Güven)
* **Parser Temel Testleri:** `tests/run_class_*.bas`, `tests/run_call_dll_*.bas`, `tests/run_percent_preprocess_*.bas` (Hepsi GEÇTİ).
* **Runtime Testleri:** `tests/run_*_exec_ast.bas` paketi; 50+ çalıştırılabilir test, kapı entegrasyonu tamam.
* **Gate Pipeline:** `tools/run_faz_a_gate.ps1` başarılı şekilde çalışıyor.
* **Performans Temeli:** `reports/runtime_perf_dispatch_preprocess_collections.csv` (Ortalama 24-37ms; GEÇTİ).
* **FFI x86 Yerel Kanıtı:** `reports/ffi_conv3_native_lanes_report.md` (native_cleanup: GEÇTİ, native_symptr_patch: GEÇTİ).

### Eksik Kanıtlar (Risk Alanları)
* **ERR-1 Parser Dilbilgisi:** `TRY/CATCH` tokenları ve AST düğümleri henüz lexer/parser seviyesinde yok.
* **ERROR Küresel Obje Şeması:** Küresel hata alanı listesi resmi olarak tanımlanmamış.
* **MIR Parite Test Düzeneği:** Yorumlayıcı vs Derlenmiş mod parite testi eksik.
* **uXStat C++ Taslağı:** `extras/uxstat/include` veya `src/` iskeleti henüz yok.
* **x86 Yerel Determinizm Kriterleri:** `SKIP/BLOCKED` durum kodları resmileştirilmemiş.
* **Floating Point İfade Değerlendirici:** Tip yükseltme kuralları ve öncelikleri çalışma zamanında zorunlu değil.

---

## 3) İLK 5 AKSİYONEL KAPATMA (Hemen Kodlanabilir)

### Kapatma #1: ERR-1 Parser/Semantik/Runtime MVP [En Yüksek Getiri]
**Efor:** Yüksek | **Etki:** Codegen ve hata yönetimini açar; 3 matris satırını çözer.

* **Kodlanacaklar:** Lexer'a `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` tokenlarını ekle; Parser'a `ParseTryStmt()` vb. işleyicileri yaz; Semantik katmana kapsam bağlamalarını ekle; Runtime'a hata yığını (handler stack) ve `THROW` atlama mekanizmasını kur.

### Kapatma #2: OOP-P0 THIS/ME Semantik Bağlama [Hızlı Kazanım]
**Efor:** Orta | **Etki:** Metod çağrıları için temel oluşturur.

* **Kodlanacaklar:** Metod kapsamında implicit "self" parametresini `THIS/ME` tanımlayıcısına bağla; Runtime'da metod alıcısını (receiver) bu adrese ata.

### Kapatma #3: FFI-CONV-3 Yerel Hat Determinizmi [Hızlı Galibiyet]
**Efor:** Düşük-Orta | **Etki:** x86 sürüm kapısını stabilize eder.

* **Kodlanacaklar:** `SKIP/BLOCKED` durum kodlarını dökümante et; `run_ffi_conv3_native_lanes.ps1` içine x86 algılama ve zarif atlama mantığını ekle.

### Kapatma #4: Floating Point (Ondalıklı Sayı) Hesaplayıcı Tamamlama
**Efor:** Orta | **Etki:** Sayısal modelin eksiksizliğini sağlar.

* **Kodlanacaklar:** `I32` -> `F32` -> `F64` tip yükseltme zincirini uygula; `**` (üs) ve bölme operatör önceliklerini netleştir; `LOG(-1)` gibi alan hatalarını koruma altına al.

### Kapatma #5: uXStat DLL Minimal API İskeleti [FFI Temeli]
**Efor:** Orta-Yüksek | **Etki:** İlk resmi DLL entegrasyonunu doğrular.

* **Kodlanacaklar:** `extras/uxstat/` altında minimal C ABI başlığı ve kaynak kodu iskeleti oluştur; uXBasic tarafında `DECLARE FUNCTION` sarmalayıcılarını yaz.

---

## ÖZET TABLO: Faz Bazlı Planlama Olgunluğu

| Faz | Durum | Açık Satırlar | Ana Engel | Öneri |
| :--- | :--- | :--- | :--- | :--- |
| **R1-R4** | ✅ ÇOĞU OK | EXIT IF (belge netliği) | Yok | EXIT IF açıklamasını dökümante et |
| **R5-R6** | ✅ PARSER OK | Ön işleme uç vakaları | Minimum iş yükü | Ön işleme birikmişini erit |
| **ERR** | ❌ PLAN | TRY/CATCH/THROW (12 hücre) | ERROR modeli belirsiz | **ACİL:** P0.1 ERR-1'e başla |
| **FFI** | ⚠️ KISMEN | Çağrı kuralları, uXStat | Yerel kanıt kısıtı | Kapatma #3 ve #5'i uygula |
| **OOP** | ⚠️ KARIŞIK | THIS bağlama, PROTECTED vb. | Semantik bağlama eksik | Kapatma #2'yi uygula |
| **CG/MIR** | ❌ KISMEN | HIR/MIR sevkiyatı | Parite düzeneği eksik | ERR-1 sonrası için ertele |

# AUDIT RAPORU: uXBasic FFI Semantik ve Çalışma Zamanı Altyapısı
**Tarih:** 17 Nisan 2026 | **Durum:** Derleme ve Çalışma Zamanı Analizi

## A) MEVCUT X64/X86 FFI SEMBOL ÇÖZÜMLEME BAĞLAMA KONUMLARI

### 1. x64 FFI Arka Yüzü (Tamamlandı)
* **Konum:** `src/codegen/x64/ffi_call_backend.fbs` (~250 satır)
* **FfiX64CallPlanEntry:** AST → Plan girişi eşlemesi.
* **FfiX64BackendEmitPlan():** Win64-MSABI plan CSV çıktısını üretir.
* **FfiX64BackendEmitNasmStubs():** Stub montaj (assembly) desenlerini oluşturur.
* **Üretilen Eserler:** `dist/interop/ffi_call_x64_plan.csv`, `ffi_call_x64_stubs.asm`.

### 2. x86 FFI Arka Yüzü (Tamamlandı)
* **Konum:** `src/codegen/x86/ffi_call_backend.fbs` (~350 satır)
* **FfiX86CallPlanEntry:** x86-32 spesifik (argüman yığın formülü = arg_count*4, shadow space yok).
* **FfiX86CleanupType():** CDECL → CALLER (Çağıran), STDCALL → CALLEE (Çağrılan) eşlemesi.
* **Üretilen Eserler:** `dist/interop/ffi_call_x86_plan.csv`, `ffi_call_x86_stubs.asm`, `ffi_call_x86_resolver.csv`.

### 3. Çalışma Zamanı Birlikte Çalışabilirlik (Interop) Manifest Yönetimi
* **Konum:** `src/build/interop_manifest.fbs` (~80 satır)
* **InteropManifest, InteropIncludeEntry, InteropImportEntry:** Derleme aşamasındaki yol takibi (Çalışma zamanı yürütmesi için DEĞİLDİR).

---

## B) ÇALIŞMA ZAMANI ÇAĞRI YÜRÜTME YOLU (Sembol Çözümleme Bağlama)

### 1. Üst Seviye Çağrı Dağıtımı (Dispatch)
* **Konum:** `src/runtime/memory_exec.fbs` (S1437-1470)
* **ExecEvalCall():** Ana çağrı yönlendiricisi; DLL yerleşik tespiti ve Alias (takma ad) çözümlemesini yönetir.

### 2. FFI Kategori İşleyicisi (Gerçek x86 Yürütmesi ile!)
* **Konum:** `src/runtime/exec/exec_eval_builtin_categories.fbs`
* **ExecEvalBuiltinFfiCategory():**
    * ✅ Politika/İzin listesi denetimi.
    * ✅ Denetim günlüğü (Audit logging).
    * ✅ **GERÇEK ÇÖZÜMLEME:** `ExecResolveX86InteropTarget()` çağrılır.
    * ✅ **YÜRÜTME:** `ExecTryInvokeResolvedX86I32()` çağrılır.

### 3. x86 Sembol Çözümleme Bağlama (Çekirdek Çalışma Zamanı)
* **Konum:** `src/runtime/exec/exec_eval_support_helpers.fbs` (S706-860)
* **ExecResolveX86InteropTarget():** İlk çağrıda `ffi_call_x86_resolver.csv` dosyasını yükler; `LoadLibraryA()` + `GetProcAddress()` bağlamasını yapar.
* **ExecTryInvokeResolvedX86I32():** Çağrı kuralına özgü fonksiyon pointer tipini seçer; CDECL/STDCALL varyantlarını (0-4 argüman) tetikler ve EAX'teki dönüş değerini yakalar.

### 4. FFI Politikası ve Zorlama
* **Konum:** `src/runtime/exec/exec_eval_support_helpers.fbs` (S283-605)
* **Görevi:** ENFORCE (Zorla) veya REPORT_ONLY (Sadece Raporla) modlarını yönetir; hash/imza doğrulama kapısı sağlar.

---

## C) INTEROP ESERLERİ ÇIKTI YAPISI
`dist/interop/` dizinindeki doğrulanmış eserler:

* **ffi_call_x64_plan.csv:** x64 için imza, kural, argüman sayısı ve shadow space verileri.
* **ffi_call_x64_stubs.asm:** `__uxb_ffi_symptr_N` üzerinden qword çağrıları.
* **ffi_call_x86_plan.csv:** x86 için yığın baytları ve temizleme tipi.
* **ffi_call_x86_resolver.csv:** Çalışma zamanı çözümleyicisi tarafından kullanılan stub_id, dll ve sembol eşlemeleri.

---

## D) ANA DERLEYİCİ GİRİŞ NOKTASI
* **Konum:** `src/main.bas` (S121-135)
* **İşlem:** Semantik geçişten sonra `--interop` bayrağı mevcutsa `FfiX64BackendEmitArtifacts` ve `FfiX86BackendEmitArtifacts` çağrılır.

---

## E) UXSTAT / EXTRAS MEVCUT DURUMU
**Durum:** Henüz Mevcut Değil

* `extras/uxstat/` dizini oluşturulmadı.
* **Planlanan Yapı:** `include/` (C ABI), `src/` (vektör/bellek işlemleri), `bas/` (uXBasic deklarasyonları).

---

## F) EKSİK OLANLAR - UYGULAMA BOŞLUKLARI

### 1. Sembol Çözümleme ve Çalışma Zamanı Kanıt Testi
* **x64 Çalışma Zamanı Yolu Eksik:** x64 çağrıları sadece plan/stub üretir, ancak x86'da olduğu gibi gerçek bir `Invoke` (tetikleme) mekanizması yoktur.
* **Genişletilmiş Dönüş Tipi Desteği:** Şu an sadece `I32` destekleniyor. `F64` (Ondalıklı), `I64` ve `PTR` sonuçları eksik. **Kritik:** uXStat istatistikleri için `F64` şarttır.
* **BYREF / OUT Parametreleri:** Semantik doğrulama var ancak bellek sınır kontrolü ve karmaşık tip yığın düzeni eksik.
* **Çoklu Argüman Desteği:** 5+ argüman için yığın düzeni hesaplaması henüz yapılmadı.

### 2. UXSTAT-0 Minimal C ABI ve uXBasic Duman Testi (Smoke Gate)
* **C++ Kaynak Kodları:** `uxstat_vector.cpp`, `uxstat_basic.cpp` (mean, std, var) sıfırdan yazılmalı.
* **Derleme Sistemi:** x86-32 DLL üretecek `CMakeLists.txt` eksik.
* **uXBasic Deklarasyonları:** `uxstat.bas` içinde `DECLARE FUNCTION` eşlemeleri yapılmalı.
* **Çalışma Zamanı Engeli:** x86 CDECL kuralında `F64` dönüş değerleri FPU ST(0) üzerinden alınır; mevcut `I32` işleyicisi burada çökecektir.

---

## G) ÖZET TABLO: MEVCUT vs EKSİK

| Bileşen | x64 Durumu | x86 Durumu | Eksik / Gereksinim |
| :--- | :--- | :--- | :--- |
| **Codegen: Plan CSV** | ✅ Tamam | ✅ Tamam | — |
| **Codegen: NASM Stubs** | ✅ Tamam | ✅ Tamam | — |
| **Runtime: Sembol Çözümleme** | ❌ Uygulanmadı | ✅ Tamam (I32) | x64 yolu, F64/I64 desteği |
| **Runtime: Yürütme (0-4 arg)** | ❌ Uygulanmadı | ✅ Tamam (I32) | x64 yolu, genişletilmiş argümanlar |
| **Temizlik Kontrat Doğrulaması** | ❌ Uygulanmadı | ✅ Tamam | x64 yolu |
| **UXSTAT: C++ Kaynak Kod** | — | ❌ Başlanmadı | MVP gereksinimi |
| **UXSTAT: uXBasic Modülü** | — | ❌ Başlanmadı | `uxstat.bas` |
| **UXSTAT: Duman Testi** | — | ❌ Başlanmadı | `tests/uxstat_smoke.bas` |

---

## H) KRİTİK DOSYA YOLLARI REFERANSI

| Amaç | Yol | Durum |
| :--- | :--- | :--- |
| **FFI x64 Kod Üretimi** | `src/codegen/x64/ffi_call_backend.fbs` | ✅ Tamam |
| **FFI x86 Kod Üretimi** | `src/codegen/x86/ffi_call_backend.fbs` | ✅ Tamam |
| **Runtime Çağrı Dağıtımı** | `src/runtime/memory_exec.fbs` | ✅ Çekirdek Hazır |
| **x86 Sembol Çözümleme** | `src/runtime/exec/exec_eval_support_helpers.fbs` | ✅ Tamam |
| **x86 Yerel Kanıt Testi** | `tests/probes/run_ffi_x86_native_cleanup_probe.bas` | ✅ GEÇTİ |
| **Ana Derleyici** | `src/main.bas` | ✅ Aktif |
| **UXSTAT Kök Dizini** | `extras/uxstat/` | ❌ Mevcut Değil |

> **⚠️ KRİTİK UYARI:** Mevcut x86 yerel temizlik testi (probes) GEÇTİ verse de, bu sadece yığın temizliğini doğrular. uXStat gibi `F64` (float) dönen fonksiyonlar, çalışma zamanında `ExecTryInvokeResolvedX86F64()` işleyicisi eklenene kadar sessizce hata verecek veya çökecektir.

1) Mevcut İlerleme
Parser Katmanı (P=OK)
CLASS, EXTENDS, ACCESS, METHOD: Fonksiyonel (src/parser/parser/parser_stmt_decl_core.fbs)
ParseClassStmt() - CLASS...END CLASS tam loop
ParseClassExtendsLiteral() - EXTENDS keyword parse
ParseClassMethodDecl() - METHOD deklarasyon + paramList
ParseClassConstructorDecl() - CONSTRUCTOR parse
ParseClassDestructorDecl() - DESTRUCTOR parse
Duplicate detection + access section routing mevcut
Runtime Katmanı (R=KISMEN)
Fonksiyonel:

ExecResolveMethodRoutineIndex() - obj.method() dispatch routing [exec_call_dispatch_helpers.fbs:61]
ExecInvokeClassCtorIfPresent() - CONSTRUCTOR auto-invoke on DIM [memory_exec.fbs:1560]
ExecValidateClassCtorSignature() - Arity/type validation [memory_exec.fbs:1522]
ExecInvokeClassDtorIfPresent() - DESTRUCTOR method exist check [memory_exec.fbs:1578]
ExecValidateClassDtorSignature() - Dtor arity/type validation [memory_exec.fbs:1546]
Method receiver (THIS) address propagation: prependReceiverOut=1, receiverAddrOut=instanceAddr [exec_call_dispatch_helpers.fbs:92-93]
Static Error Messages Var:

[memory_exec.fbs:1446] "exec: THIS/ME used outside method context" - Runtime fail-fast mevcut
[memory_exec.fbs:1466] Aynı error mesajı tekrar bulunuyor
Test Coverage (T=OK)
tests/run_class_ctor_dtor_exec_ast.bas - Ctor/dtor baseline ✓
tests/run_class_this_me_binding_exec_ast.bas - Parser baseline ✓+3 semantic test case placeholder
tests/run_class_dtor_scope_exit_exec_ast.bas - Scope-exit baseline ✓
tests/run_class_method_dispatch_exec_ast.bas - Dotted dispatch ✓
Gate integration: tools/run_faz_a_gate.ps1 lines 69-73: build step ekli, run step eksik
Floating-Point (Kontrol Tamamlandı)
Audit Raporu: "FLOATING POINT | OK | OK | OK | OK | OK"
Test: tests/run_floating_point_exec.bas - CDBL/CSNG/FIX/SQR/COS/EXP/LOG domain error ✓
Gate: gate_latest_skipbuild.log line 327-329: "[PASS] Run run_floating_point_exec_64"
Status: ✅ KAPANDI - Eksik yok
2) Net Eksikler
OOP THIS/ME Semantic Binding Eksiklikleri
Eksiklik	Katman	Etki	Doğrulama
THIS/ME context tracking yok	Semantic+Runtime	Method dışında THIS erişimi runtime'da detect edilemez	tests/run_class_this_me_binding_exec_ast.bas Test 3 placeholder - runtime execute hook eksik
Dtor scope-exit invoke hook yok	Runtime	Destructor asla çağrılmaz; kaynaklar cleanup edilmez	tests/run_class_dtor_scope_exit_exec_ast.bas parse OK, exec'de program-end hook eksik
Method context flag yok	Runtime	ExecInvokeRoutineByIndex parametreler: prependReceiver=1 mevcuttur ama caller-side method-context-tracking state eksik	
Semantic binding (implicit first param)	Semantic	THIS/ME'den receiver.self param mapping tanımlanmadı - parser layer'da IDENT olarak geçilir	
Access control enforcement	Runtime	PUBLIC/PRIVATE parse OK, runtime enforcement 0	
Inline METHOD body	Parser	METHOD body empty - deferred (workaround: external SUB naming convention)	
ilgili Dosyalar
src/runtime/memory_exec.fbs - Error message var, state tracking yok
src/runtime/exec/exec_call_dispatch_helpers.fbs - Receiver propagation var, context flag yok
Scope-exit hook: program end-of-execution noktası yokEXECUTE path'inde identifikab hook noktası istenir
3) Minimum Uygulanabilir Kapanış Adımları
Adım 1: Dtor Scope-Exit Invocation Hook (Kritik)
Hedef: tests/run_class_dtor_scope_exit_exec_ast.bas PASS

Gerekli Değişiklikler:

src/runtime/memory_exec.fbs - Program execution end noktasında dtor invoke loop eklemek

ExecState'e destructor invocation tracking eklemek (allocated class instances registry)
Program bitişinde: ExecInvokeClassDtorIfPresent() tüm instances için LIFO order
src/runtime/memory_exec.fbs - Error message kontekst: ExecState'e isInMethodContext flag eklemek

Test Doğrulama:

cmd /c build_64.bat tests\run_class_dtor_scope_exit_exec_ast.bas
cmd /c tests\run_class_dtor_scope_exit_exec_ast_64.exe  # Expected: "PASS class dtor scope-exit exec"
Adım 2: THIS/ME Runtime Verification (Semantic)
Hedef: tests/run_class_this_me_binding_exec_ast.bas Test 3 fail-fast runtime

Gerekli Değişiklikler:

src/runtime/memory_exec.fbs - ExecState method-context tracking:

Type ekleme: methodContextActive As Integer, receiverInstanceAddr As Integer
src/runtime/exec/exec_call_dispatch_helpers.fbs - ExecInvokeRoutineByIndex'e:

Method invoke öncesi: es.methodContextActive = 1, es.receiverInstanceAddr = receiverAddr
Return sonrası: es.methodContextActive = 0
src/runtime/memory_exec.fbs - ExecEvalNode / IDENT case'inde THIS/ME check:

If methodContextActive = 0 && (varName = "THIS" Or varName = "ME") Then → fail-fast
Test Doğrulama:

cmd /c build_64.bat tests\run_class_this_me_binding_exec_ast.bas
cmd /c tests\run_class_this_me_binding_exec_ast_64.exe  # Test 3 должен fail-fast
Adım 3: Ctor/Dtor Signature Validation (Runtime Finalize)
Hedef: Memory safety - arity/type mismatch early fail-fast

Durum: Validation fonksiyonları zaten mevcut

[memory_exec.fbs:1522] ExecValidateClassCtorSignature()
[memory_exec.fbs:1546] ExecValidateClassDtorSignature()
Eksik: Dtor invoke'da validation call eksik

[memory_exec.fbs:1578] ExecInvokeClassDtorIfPresent() - Validation inline
Gerekli Kod:

' memory_exec.fbs ~1578
If ExecValidateClassDtorSignature(ps, routineIdx, classUpper, errText) = 0 Then Return 0
Test: Mevcut testler pass → yeni adım entegrasyon

4) Bağımlılıklar
Adım 1 (Dtor Hook) → Adım 2 (THIS context) → Adım 3 (Sig Validation)
                                    ↓
                            Gate PR validation
Bağımlılık	Konum	Durum
Program end-of-execution hook	src/runtime/memory_exec.fbs (ExecProgram / main loop exit)	🔴 Eksik
ExecState method-context struct members	Type ExecState [memory_exec.fbs:61]	🔴 Eksik
Class instance tracking registry	ExecState'e fields eklemek	🔴 Eksik
Validation call in Dtor path	ExecInvokeClassDtorIfPresent [memory_exec.fbs:1578]	🟡 Partial
Gate test mapping	tools/run_faz_a_gate.ps1	🟡 Build OK, Run eksik
5) Doğrulama Komutları
Immediate Validation (mevcut kod):
# Gate - minimal mode (constructor/destructor/method dispatch)
powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

# Manual class tests
cmd /c build_64.bat tests\run_class_ctor_dtor_exec_ast.bas
cmd /c tests\run_class_ctor_dtor_exec_ast_64.exe

cmd /c build_64.bat tests\run_class_this_me_binding_exec_ast.bas
cmd /c tests\run_class_this_me_binding_exec_ast_64.exe
Post-Implementation (Adımlar 1-3 kapandıktan sonra):
# Dtor Scope-Exit
cmd /c build_64.bat tests\run_class_dtor_scope_exit_exec_ast.bas
cmd /c tests\run_class_dtor_scope_exit_exec_ast_64.exe

# THIS/ME context fail-fast
cmd /c build_64.bat tests\run_class_this_me_binding_exec_ast.bas
cmd /c tests\run_class_this_me_binding_exec_ast_64.exe

# Full gate (regresyon check)
powershell -ExecutionPolicy Bypass -File tools\run_faz_a_gate.ps1 -SkipBuild

# Matrix update verification
Get-Content reports\uxbasic_operasyonel_eksiklik_matrisi.md | Select-String "CLASS|THIS|DESTRUCTOR"
Özet Bulguları
Rapor Öğesi	Durum
Floating-Point	✅ Kapandi (audit OK, gate PASS)
OOP Core	🟡 İlerleme mevcuttur (P=OK, R=Kısmen)
THIS/ME Binding	🔴 Semantic layer eksik
Dtor Lifecycle	🔴 Scope-exit hook eksik (test existe)
Test Infrastructure	✅ Tüm test dosyaları mevcut
Gate Entegrasyon	🟡 Build OK, Run mapping eksik
Beklenen takvim: 3 adım (~2-3 saatlik kod) gate PASS için sufficient


## NİHAİ TAVSİYE
**Hemen Başlanacak Sprint (1. Hafta):**
1. Kapatma #1 (Hata Yönetimi MVP) — 3-4 gün.
2. Kapatma #3 (FFI Determinizmi) — 1 gün (Hızlı galibiyet).

**2. Hafta:**
3. Kapatma #2 (THIS/ME Bağlaması) — 2 gün.
4. Kapatma #5 (uXStat İskeleti) — 2-3 gün.

**3. Hafta:**
5. Kapatma #4 (Floating Point Hesaplayıcı) — 1-2 gün.

Bu sıralama, 12 kritik matris boşluğunun 9'unu çözecek ve 2 hafta içinde codegen ve OOP derinlik kanallarını açacaktır.