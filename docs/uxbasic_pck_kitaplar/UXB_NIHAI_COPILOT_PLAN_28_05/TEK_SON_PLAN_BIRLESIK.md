

<!-- FILE: docs/00_OKU_BENI_DIZIN.md -->


---

# UXB Nihai Copilot Planı — 28.05

Bu paket, önceki planları tek son plana indirir. Amaç Copilot'a tek dev metin değil, her biri ayrı uygulanabilir belge vermektir.

Kaynak kontrol notları:
- Adım0 surface lifecycle CSV paketi kontrol edildi.
- `surface_lifecycle_matrix.csv`: 268 surface.
- `surface_lifecycle_blockers.csv`: 222 blocker.
- `target_backend_blockers.csv`: 137 backend blocker.
- `fake_implemented_lifecycle.csv`: 91 sahte/erken IMPLEMENTED işareti.
- Strict gate durumu: `FAIL`.
- Route dağılımı: `{'AST_INTERPRETER': 50, 'MIR_TO_TARGET_BACKEND': 137, 'NATIVE_ONLY_WITH_TARGET_DIAGNOSTIC': 6, 'COMPILE_TIME_PREPROCESS': 46, 'RUNTIME_SERVICE': 21, 'DIRECT_NATIVE_AST_CODEGEN': 8}`.

Temel karar:
1. Temizlik silerek değil, inventory ve emekliye ayırma planıyla başlayacak.
2. Hiçbir katman “partial çalışıyor” diye kapatılmayacak.
3. Lexer surface öğesi bir yaşam döngüsü kaydına sahip olacak.
4. Her surface için lexer/parser/AST/semantic/HIR/MIR/interpreter/backend/runtime/test/doc karşılığı ya gerçek olacak ya da açık statüyle raporlanacak.
5. AST interpreter ve MIR interpreter ayrı modüler katmanlar olarak korunacak; biri diğerinin yerine geçmeyecek.
6. Minimal yol korunacak ama verified MIR'e kadar giden gerçek check yolu olacak.
7. Standard yol backend artifact üretim yolu olacak.
8. Full yol toolchain/release yolu olacak.

Klasör düzeni:
```text
docs/       Copilot'a verilecek ayrı belgeler
csv/        yeni nihai plan CSV'leri
reference_csv/ önceki detaylı CSV'lerin aynen kopyası
```

Önce `docs/01_COPILOT_ANA_KURALLAR.md`, sonra sırasıyla adım belgeleri verilecek.


---



<!-- FILE: docs/01_COPILOT_ANA_KURALLAR.md -->


---

# 01 — Copilot Ana Kurallar, Emirler ve Statüler

## Copilot'a ana emir

Bu proje uXBasic içindir. Yeni mimari icat etme. Var olan mimariyi kırmadan güçlendir.

## Mutlak yasaklar

```text
Dosya silme.
Klasör silme.
Eski dosyayı emekliye ayırmadan yok etme.
BROKEN'ı IMPLEMENTED yapma.
MISSING'i saklama.
Diagnostic-only sonucu başarı sayma.
Partial WAT/JS/WASM çıktısını PASS sayma.
Dış araç yoksa başarı deme; EXTERNAL_TOOL_MISSING raporla.
Eski çalışan route'u kırarak yeni route ekleme.
```

## Kullanılacak statüler

```text
IMPLEMENTED
NOT_APPLICABLE
COMPILE_TIME_ONLY
RUNTIME_CALL
NATIVE_ONLY
JS_ONLY
WASM_ONLY
WASM_UNSUPPORTED
BROWSER_ONLY
DIAGNOSTIC_ONLY
RESERVED
REMOVED
MISSING
BROKEN
```

Boş hücre yok. Her matrix hücresinde bu statülerden biri bulunacak.

## Hata sınıfları

```text
KOD_EKSIK
BAGLANTI_KOPUK
CLI_BAGLI_DEGIL
RAPOR_ESKI
GATE_GEVSEK
YANLIS_IMPLEMENTED
RUNTIME_SERVICE_EKSIK
BACKEND_EMIT_EKSIK
SOURCE_MAPPING_EKSIK
EXTERNAL_TOOL_MISSING
TEST_EKSIK
PARITY_FAIL
```

## Çalışma biçimi

Her adımda şu sıra zorunlu:

```text
1. Mevcut kodu tara.
2. Envanter/bağlantı raporu üret.
3. Yeni dosya eklenecekse önce include noktalarını belirle.
4. Mevcut route'u kırmadan bridge/gate ekle.
5. Pozitif test yaz.
6. Negatif test yaz.
7. Expected/actual CSV üret.
8. Gate JSON/MD üret.
9. Sonraki adıma geçmeden PASS/FAIL durumunu açık yaz.
```

## Kabul kuralı

Bir adım sadece şu dört çıktı varsa tamamdır:

```text
reports/control/current/<step>_gate.json
reports/control/current/<step>_gate.md
reports/control/current/<step>_expected_actual.csv
reports/control/current/<step>_error_classification.csv
```

## Kanonik klasörler

```text
src/
tools/control/
reports/control/current/
reports/control/history/<run_id>/
docs/matrix/
compiler/scripts/
tests/
_retired/
```


---



<!-- FILE: docs/02_ADIM0_INVENTORY_SILMEDEN_TEMIZLIK.md -->


---

# 02 — ADIM0: Inventory Temelli Silmeden Temizlik

## Amaç

İlk iş kod yazmak değildir. İlk iş proje ağacını inventory belgesine göre sınıflandırmak ve hiçbir dosyayı silmeden temizlik planı çıkarmaktır.

## Copilot'a verilecek görev

```text
Inventory ağacını oku. Aktif kaynak, geçici dosya, derleme çıktısı, log, eski backup, tekrar dosya, dış araç, rapor ve belge sınıflarını ayır.
Hiçbir dosyayı silme.
Sadece reports/control/current altında CSV/JSON/MD rapor üret.
Taşıma yapılacaksa önce retirement_plan.csv üret; uygulama ayrı onay gerektirir.
```

## Girdi

```text
inventory_tree.txt
varsa inventory_files.csv
repo dosya ağacı
```

Not: `inventory_files.csv` sadece başlık içeriyorsa esas kaynak `inventory_tree.txt` olacak.

## Oluşturulacak araçlar

```text
tools/control/uxb_inventory_reader.py
tools/control/uxb_folder_classifier.py
tools/control/uxb_file_classifier.py
tools/control/uxb_retirement_plan.py
tools/control/uxb_retirement_apply_safe.py
tools/control/uxb_retirement_verify.py
```

## Emekli klasörleri

```text
_retired/tmp_imports/
_retired/step_tmp/
_retired/zip_work/
_retired/old_outputs/
_retired/old_logs/
_retired/duplicate_tests/
_retired/old_backups/
_retired/old_tools/
```

## Üretilecek raporlar

```text
reports/control/current/inventory_parsed.csv
reports/control/current/folder_classification.csv
reports/control/current/file_classification.csv
reports/control/current/retirement_plan.csv
reports/control/current/retirement_gate.json
reports/control/current/retirement_gate.md
```

## Sınıflar

```text
AKTIF
KANONIK
EMEKLI_ADAYI
EMEKLI
TEKRAR
GECICI
DERLEME_CIKTISI
DIS_ARAC
LOG
RAPOR
KAYNAK_KOD
TEST
BELGE
KUTUPHANE
KIRIK
```

## Pozitif test

```text
_step*_tmp klasörleri EMEKLI_ADAYI veya GECICI sınıfına düşmeli.
src altındaki .fbs/.bas dosyaları KAYNAK_KOD/AKTIF sınıfına düşmeli.
tools/FreeBASIC-1.10.1-win64 DIS_ARAC sınıfına düşmeli.
```

## Negatif test

```text
Hiçbir kaynak dosya retirement_apply_safe çalışmadan taşınmayacak.
main.bas kaynak olarak kalacak; main.exe derleme çıktısı sayılacak.
__dup1 dosyaları aktif test sayılmayacak.
```

## Tamamlanma ölçütü

```text
retirement_plan.csv var.
Raporlarda silme işlemi yok.
Her satır için sınıf var.
Taşıma planı ayrı onay olmadan uygulanmıyor.
```


---



<!-- FILE: docs/03_ADIM1_SURFACE_LIFECYCLE_CSV_KAPISI.md -->


---

# 03 — ADIM1: Surface Lifecycle CSV Kapısı

## Amaç

Lexer surface öğeleri tek tek yaşam döngüsü satırına bağlanacak. Her surface için hangi katmanda karşılığı olduğu, hangi katmanda olmadığı ve hangi hedefte neden bloklandığı açık görülecek.

## Mevcut CSV kontrol sonucu

Adım0 CSV paketi kontrol edildi:

```text
surface_count = 268
blocker_count = 222
target_backend_blocker_count = 137
fake_implemented_count = 91
strict_status = FAIL
```

Bu durumda gate bilinçli olarak FAIL durumunda. Bu kötü değil; saklanmayan gerçek durumdur.

## Copilot'a görev

```text
Mevcut CSV'leri silme.
surface_lifecycle_matrix.csv şemasını koru.
Boş hücre bırakma.
IMPLEMENTED yazmak için evidence_file zorunlu kıl.
BROKEN veya MISSING varsa master gate PASS olamaz.
```

## Kullanılacak mevcut CSV'ler

```text
reference_csv/adim0_surface/surface_lifecycle_matrix.csv
reference_csv/adim0_surface/surface_lifecycle_blockers.csv
reference_csv/adim0_surface/target_backend_blockers.csv
reference_csv/adim0_surface/surface_test_plan.csv
reference_csv/adim0_surface/fake_implemented_lifecycle.csv
```

## Yeni üretilecek raporlar

```text
reports/control/current/surface_lifecycle_matrix.csv
reports/control/current/surface_lifecycle_summary.json
reports/control/current/surface_lifecycle_gate.md
reports/control/current/surface_expected_actual.csv
reports/control/current/surface_error_classification.csv
```

## CSV kolon kuralı

Ana matrix en az şu kolonları taşımalı:

```text
id
surface_name
surface_group
surface_kind
syntax
source_file
lifecycle_route
route_owner_layer
route_complete
hard_blocker_count
missing_layers
broken_layers
target_blockers
evidence_score
required_next_action
recommended_step
```

## Kabul kuralı

```text
Her lexer surface öğesi bir route sahibi olmalı.
Her surface için test planı satırı olmalı.
IMPLEMENTED ama blocker varsa fake_implemented_lifecycle.csv satırı oluşmalı.
```


---



<!-- FILE: docs/04_ADIM2_LEXER_PREPROCESSOR.md -->


---

# 04 — ADIM2: Lexer ve Preprocessor

## Amaç

Lexer surface genişliği korunacak. Token sistemi hızlı ve hataya kapalı hale getirilecek. Preprocessor meta komutları lexer yaşam döngüsüne açık şekilde bağlanacak.

## Çözülecek sorunlar

```text
Token.kind string karşılaştırması.
Keyword Select Case büyümesi.
ShouldTreatAsKeyword bağlam yetersizliği.
Meta komutların lexer/preprocessor route'u belirsiz.
```

## Oluşturulacak/değiştirilecek modüller

```text
src/parser/token_kinds.fbs
src/parser/lexer/lexer_keyword_map.fbs
src/parser/lexer/lexer_context_keyword_policy.fbs
src/parser/lexer/lexer_dump_tokens.fbs
src/parser/lexer/lexer_preprocessor_meta_table.fbs
tools/control/uxb_lexer_surface_audit.py
```

## İş planı

```text
1. Token.kind string alanını hemen silme; TokKind enum alanını paralel ekle.
2. Lexer tüm tokenlarda kindId/TokKind doldursun.
3. Parser geçiş dönemi boyunca string ve enum uyumluluğunu korusun.
4. Keyword lookup için hash tablo ekle.
5. ShouldTreatAsKeyword kuralına FUNCTION/SUB/TYPE/CLASS/NAMESPACE/MODULE/PROPERTY/OPERATOR sonrası isimleri ekle.
6. %% meta komutlarını COMPILE_TIME_PREPROCESS route'una bağla.
7. --dump-tokens JSON/CSV üret.
```

## Pozitif testler

```text
IF x THEN PRINT x
DIM IF AS I32  ' keyword bağlamında isim olarak kullanılacaksa policy açık olmalı
FUNCTION ABS()
END FUNCTION
%%IF PLATFORM = "WIN64"
%%ENDIF
```

## Negatif testler

```text
Bilinmeyen %% komut MISSING değil, META_UNKNOWN diagnostic üretmeli.
Yanlış kapanan %%IF/%%ENDIF preprocessor gate FAIL vermeli.
Token.kindId boş kalan token varsa lexer gate FAIL.
```

## Çıktı

```text
reports/control/current/lexer_token_dump.csv
reports/control/current/lexer_keyword_policy_report.csv
reports/control/current/lexer_gate.json
reports/control/current/lexer_gate.md
```


---



<!-- FILE: docs/05_ADIM3_PARSER_ERROR_RECOVERY_SCOPE.md -->


---

# 05 — ADIM3: Parser, Scope Başlangıcı ve Error Recovery

## Amaç

Parser tek hatada çökmeden kontrollü hata toparlama yapacak. Parser yüzeyi AST contract'a doğru veri verecek.

## Çözülecek sorunlar

```text
Parser error recovery yok veya zayıf.
ParseState namespace/module/main sayaçları var ama gerçek qualifier/scope stack zayıf.
Komut handler registry var ama surface lifecycle ile bağlantı eksik.
```

## Değiştirilecek/eklenecek modüller

```text
src/parser/parser/parser_error_recovery.fbs
src/parser/parser/parser_sync_sets.fbs
src/parser/parser/parser_scope_qualifier_stack.fbs
src/parser/parser/parser_stmt_registry_gate.fbs
src/parser/parser/parser_surface_bridge.fbs
```

## İş planı

```text
1. ParserError fonksiyonu hata kaydı + sync noktasına atlama yapacak.
2. Sync token seti: EOL, EOF, END, ELSE, ELSEIF, CASE, NEXT, LOOP, FUNCTION, SUB, CLASS, TYPE.
3. qualifierStack eklenecek; NAMESPACE/MODULE/CLASS/FUNCTION owner bilgisi AST node'a yazılacak.
4. Parser registry ile surface matrix eşlenecek.
5. Her parser handler için evidence_file üretilecek.
```

## Pozitif testler

```basic
PRINT "a"
IF x THEN
    PRINT x
END IF
FUNCTION f(a AS I32) AS I32
    RETURN a
END FUNCTION
```

## Negatif testler

```basic
IF x THEN
    PRINT x
' END IF eksik
PRINT "sonraki satir"
```

Beklenen: Parser sonraki statement'a toparlanacak, yüzlerce sahte hata üretmeyecek.

## Çıktı

```text
reports/control/current/parser_error_recovery.csv
reports/control/current/parser_registry_surface.csv
reports/control/current/parser_gate.json
reports/control/current/parser_gate.md
```


---



<!-- FILE: docs/06_ADIM4_AST_CONTRACT_HIBRIT_COCUK.md -->


---

# 06 — ADIM4: AST Contract ve Hibrit Çocuk Modeli

## Amaç

AST'nin iki çocuk sistemi bilinçli hale getirilecek. left/right tamamen kaldırılmayacak; sadece expression shortcut olarak sınırlandırılacak.

## Temel karar

```text
firstChild/nextSibling = genel kanonik çocuk sistemi
left/right = sadece BINARY/UNARY expression shortcut
statement/block/OOP node'larında left/right kullanılmayacak
```

## Çözülecek sorunlar

```text
ASTNode.kind string karşılaştırması.
left/right ve firstChild/nextSibling modelinin sözleşmesiz karışması.
AST contract coverage boşlukları.
```

## Değiştirilecek/eklenecek modüller

```text
src/parser/ast_node_kinds.fbs
src/parser/ast_contract_child_model.fbs
src/parser/ast_contract_validate.fbs
src/parser/ast_child_accessors.fbs
tools/control/uxb_ast_contract_matrix.py
```

## İş planı

```text
1. ASTNode.kind string kalsın; nodeKind enum paralel eklensin.
2. Parser AST node üretirken nodeKind doldursun.
3. ASTChildAt, ASTRoleChild, ASTLeft, ASTRight helper'ları standartlaştırılsın.
4. Contract şunu doğrulasın:
   - BINARY: left/right zorunlu
   - UNARY: left zorunlu
   - BLOCK/FUNCTION/CLASS/IF/CALL: firstChild/role sistemi
5. AST contract gate parse sonrası zorunlu çalışsın.
```

## Pozitif testler

```basic
a = b + c
IF a THEN PRINT b ELSE PRINT c
CALL foo(1, 2, 3)
```

## Negatif testler

```text
BLOCK node left/right kullanırsa AST_CONTRACT_FAIL.
BINARY node left veya right eksikse AST_CONTRACT_FAIL.
CALL_EXPR args role yoksa warning/fail.
```

## Çıktı

```text
reports/control/current/ast_child_model_matrix.csv
reports/control/current/ast_contract_gate.json
reports/control/current/ast_contract_gate.md
```


---



<!-- FILE: docs/07_ADIM5_SYMBOL_SCOPE_HASH_HIR_BRIDGE.md -->


---

# 07 — ADIM5: Symbol, Scope, Hash ve HIR Bridge

## Amaç

Tek sembol otoritesi kurulacak. HIR kendi bağımsız sembol tablosunu compiler truth olarak kullanmayacak. AST → HIR → MIR arasında symbolIndex, scopeId, typeName taşınacak.

## Çözülecek sorunlar

```text
HIR içinde ayrı SymbolTable/ScopeStack var.
Step3 içinde ayrı gUXBStep3Symbols var.
UXBStep3SymbolFind current+global bakıyor, tam lexical chain yok.
Sembol araması O(n).
HIR güçlü bridge değil.
```

## Yeni modüller

```text
src/symbols/symbol_key.fbs
src/symbols/scope_table.fbs
src/symbols/symbol_index.fbs
src/symbols/symbol_resolver.fbs
src/symbols/symbol_integrity_gate.fbs
src/symbols/symbol_hir_mir_bridge.fbs

src/semantic/hir_scope_bridge.fbs
src/semantic/hir_symbol_bridge.fbs
src/semantic/hir_fact_table.fbs
src/semantic/hir_ast_bridge.fbs
src/semantic/hir_builder.fbs
src/semantic/hir_mir_bridge.fbs
src/semantic/hir_json_report.fbs
```

## İş planı

```text
1. gUXBStep3Symbols tek sembol deposu olarak kalacak.
2. gUXBScopes parentId destekli gerçek scope ağacı olacak.
3. gUXBSymHash exact lookup index'i olacak.
4. UXBSymbolResolveLexical current scope'tan parent zincirine yürüyecek.
5. symbol_integrity_gate semantic sonrası çalışacak.
6. hir.fbs içindeki eski SymbolTable/ScopeStack DEPRECATED yapılacak.
7. HIRFactTable AST node başına scope/symbol/type/layout/source fact üretecek.
8. MIR lowering öncesi HIRPrepareMirLowering çalışacak.
```

## Pozitif testler

```basic
DIM x AS I32
FUNCTION f(a AS I32) AS I32
    DIM x AS F64
    RETURN a
END FUNCTION
```

Beklenen:

```text
global x ile local x farklı symbolIndex.
a param sembolü function scope içinde.
HIR fact table symbolIndex/typeName taşır.
```

## Negatif testler

```basic
FUNCTION a()
    DIM t AS I32
END FUNCTION

FUNCTION b()
    RETURN t
END FUNCTION
```

Beklenen: `t` sembolü a scope'undan b scope'una sızmaz.

## Çıktı

```text
reports/control/current/symbol_integrity_gate.json
reports/control/current/hir_fact_table.json
reports/control/current/hir_bridge_gate.md
reports/control/current/symbol_expected_actual.csv
```


---



<!-- FILE: docs/08_ADIM6_MIR_BUILDER_TYPED_STORAGE_VERIFY.md -->


---

# 08 — ADIM6: MIR Modeli, Builder, Typed Storage ve Mandatory Gate

## Amaç

MIR instruction üretimi güvenli hale getirilecek. MIR local/param storage tip bilgisi taşıyacak. MIR verifier opt-in olmaktan çıkıp zorunlu gate olacak.

## Çözülecek sorunlar

```text
MIRAppendInstruction 16 konumsal operand alıyor.
Operand sırası hataları derleniyor ama yanlış çalışıyor.
MIRFunction.localVars sadece string.
x64 codegen I64/8 byte varsayımına düşüyor.
MIR verifier --mir-verify ile opt-in çalışıyor.
```

## Yeni modüller

```text
src/semantic/mir_operand_role.fbs
src/semantic/mir_opcode_signature.fbs
src/semantic/mir_instruction_builder.fbs
src/semantic/mir_emit_api.fbs
src/semantic/mir_builder_gate.fbs
src/semantic/mir_hir_operand_bridge.fbs

src/semantic/mir_var_info.fbs
src/semantic/mir_type_layout_bridge.fbs
src/semantic/mir_function_storage.fbs
src/semantic/mir_symbol_storage_bridge.fbs
src/semantic/mir_storage_gate.fbs

src/semantic/mir_verification_gate.fbs
src/semantic/mir_verification_gate_json.fbs
```

## İş planı

```text
1. MIRIRInstruction storage hemen yıkılmayacak; operands(0 To 15) kalacak.
2. MIRInstrBuilder üst üretim kapısı olacak.
3. MIROpcodeSignature opcode başına operand sayısı/rolü belirleyecek.
4. MIREmitLoadConst/LoadVar/StoreVar/Binary/Jump/CallRuntime gibi API'ler eklenecek.
5. Eski MIRAppendInstruction deprecated/raw kabul edilecek.
6. MIRFunction localVars/paramVars string listesi kalacak.
7. localInfo/paramInfo/globalInfo typed listeleri eklenecek.
8. MIRStorageGate typed info eksiklerini yakalayacak.
9. UXBMIRMandatoryGate şu sırayla çalışacak:
   - MIRBuilderGate
   - MIRStorageGate
   - UXBMIRVerifyModule
   - symbol/HIR/MIR consistency
10. --mir-verify sadece rapor isteme anlamına gelecek; verifier kapatılamaz.
```

## Pozitif testler

```basic
DIM a AS I32
DIM b AS I32
DIM c AS I32
c = a + b
```

Beklenen:

```text
ADD operandCount=2
c localInfo type I32
MIR gate OK
```

## Negatif testler

```text
ADD t, a
localVars=A ama localInfo yok
JMP olmayan label
CALL_DLL eksik ABI/signature
```

Beklenen: Gate FAIL; backend çalışmaz.

## Çıktı

```text
reports/control/current/mir_builder_gate.json
reports/control/current/mir_storage_gate.json
reports/control/current/mir_verify_gate.json
reports/control/current/mir_expected_actual.csv
```


---



<!-- FILE: docs/09_ADIM7_INTERPRETER_RUNTIME_PARITY.md -->


---

# 09 — ADIM7: AST Interpreter, MIR Interpreter, Runtime ve Parity

## Amaç

AST interpreter ve MIR interpreter ayrı modüler katmanlar olarak korunacak. Biri diğerinin yerine geçmeyecek. İkisi de CLI ile açılıp kapanabilir olacak ve aynı programda aynı beklenen sonucu vermelidir.

## Temel karar

```text
AST interpreter = source/AST davranışını hızlı kontrol eder.
MIR interpreter = MIR lowering ve opcode davranışını kontrol eder.
İkisi de gereklidir.
```

## Çözülecek sorunlar

```text
Interpreter yolları gate'e tam bağlı değil.
AST ve MIR interpreter sonuçları beklenen/gerçekleşen karşılaştırmasına düzenli girmiyor.
Runtime service route'ları surface lifecycle ile yeterince bağlı değil.
```

## Yeni/değiştirilecek modüller

```text
src/interpreter/common/interpreter_result.fbs
src/interpreter/common/interpreter_parity_gate.fbs
src/interpreter/ast/ast_interpreter_entry.fbs
src/interpreter/mir/mir_interpreter_entry.fbs
src/runtime/services/runtime_service_gate.fbs
tools/control/uxb_interpreter_parity_runner.py
```

## İş planı

```text
1. AST interpreter route'u açıkça cli.runAst ile kontrol edilecek.
2. MIR interpreter route'u cli.runMir ile kontrol edilecek.
3. Minimal mode --run-ast, --run-mir, --run-both destekleyecek.
4. MIR interpreter başlamadan önce MIR mandatory gate geçecek.
5. AST interpreter başlamadan önce AST contract ve semantic gate geçecek.
6. run-both durumunda expected_actual_interpreter.csv üretilecek.
7. Runtime service çağrıları surface_lifecycle_matrix içinde RUNTIME_SERVICE route'una bağlanacak.
```

## Pozitif testler

```basic
PRINT 2 + 3
DIM s AS STRING
s = "mete"
PRINT s
```

Beklenen: AST ve MIR interpreter aynı çıktı.

## Negatif testler

```text
AST interpreter OK, MIR interpreter farklı çıktı verirse PARITY_FAIL.
MIR gate FAIL iken MIR interpreter başlamaz.
Runtime service handler yoksa RUNTIME_SERVICE_EKSIK.
```

## Çıktı

```text
reports/control/current/interpreter_parity.csv
reports/control/current/runtime_service_gate.json
reports/control/current/interpreter_gate.md
```


---



<!-- FILE: docs/10_ADIM8_BACKEND_PIPELINE_WABT.md -->


---

# 10 — ADIM8: Backend Pipeline, x64, JS, WAT, WASM ve WABT

## Amaç

HIR → MIR → Backend zinciri tek backend pipeline ile bağlanacak. `backend_step6.fbs` dispatch kapısı korunacak ama doğrudan main içinden dağınık çağrılmayacak.

## Çözülecek sorunlar

```text
UXBBackendContext merkezi doldurulmuyor.
main_program_entry içinde x64EmitMode/codegenMode/x64BuildMode dağınık.
JS/WASM backend verified MIR almadan çalışabilir.
WAT üretimi ile WASM binary üretimi ayrılmıyor.
wat2wasm tools altında yoksa durum saklanıyor.
```

## Yeni modüller

```text
src/backend/backend_cli_args.fbs
src/backend/backend_toolchain.fbs
src/backend/backend_context_builder.fbs
src/backend/backend_pipeline_gate.fbs
src/backend/backend_pipeline.fbs
src/backend/backend_pipeline_report.fbs
src/backend/backend_x64_build_bridge.fbs
src/backend/backend_wasm_tool_bridge.fbs

tools/scripts/install_wabt.ps1
tools/scripts/check_wabt.ps1
tools/toolchain_manifest.json
```

## İş planı

```text
1. UXBBackendCliArgs main CLI'dan üretilecek.
2. UXBBackendContextFromCliArgs context'i tek yerde dolduracak.
3. UXBBackendRunPipeline:
   - MIR mandatory gate kontrolü
   - target gate
   - toolchain gate
   - UXBBackendEmitModuleStep6 dispatch
   - artifact/report üretimi
4. x64/js/wat/wasm backend doğrudan main'den çağrılmayacak.
5. JS/WASM için codegenSourceMode=MIR zorunlu.
6. --emit-wat WAT üretir, wat2wasm zorunlu değildir.
7. --emit-wasm WAT + wat2wasm ile .wasm üretir; wat2wasm yoksa FAIL.
8. WABT tools/wabt/bin/wat2wasm.exe yoluna kurulacak.
```

## Toolchain düzeni

```text
tools/
  FreeBASIC-1.10.1-win64/
  wabt/
    bin/
      wat2wasm.exe
      wasm2wat.exe
      wasm-validate.exe
```

## Pozitif testler

```bat
uxb_main_64.exe tests/hello.bas --mode=std --emit-x64
uxb_main_64.exe tests/hello.bas --mode=std --emit-js
uxb_main_64.exe tests/hello.bas --mode=std --emit-wat
uxb_main_64.exe tests/hello.bas --mode=full --emit-wasm
```

## Negatif testler

```bat
uxb_main_64.exe tests/hello.bas --emit-js --codegen-source AST
uxb_main_64.exe tests/hello.bas --emit-wasm
```

Beklenen:
- JS AST fallback FAIL.
- wat2wasm yoksa emit-wasm FAIL, emit-wat PASS.

## Çıktı

```text
reports/control/current/backend_pipeline.json
reports/control/current/toolchain_gate.json
reports/control/current/backend_expected_actual.csv
reports/control/current/wabt_check.md
```


---



<!-- FILE: docs/11_ADIM9_MAIN_ENTRY_ROUTER.md -->


---

# 11 — ADIM9: Tek Giriş, Üç Route — Minimal / Standard / Full

## Amaç

Birden fazla main/entry dosyasının yarattığı karar dağınıklığı kaldırılacak. Tek gerçek giriş `UXBCompilerMain(cli)` olacak. Üç route aynı frontend/semantic/HIR/MIR kalitesini paylaşacak.

## Kod gerçeği

```text
compiler/wrappers/uxb_main_wrapper.bas -> src/main.bas
src/main.bas -> include merkezi
src/main_program_entry.fbs -> mevcut ana akış
src/main_program_entry_part2.fbs -> backend/legacy devamı
```

## Yeni modüller

```text
src/main_entry/uxb_cli_model.fbs
src/main_entry/uxb_entry_router.fbs
src/main_entry/uxb_pipeline_common.fbs
src/main_entry/uxb_pipeline_minimal.fbs
src/main_entry/uxb_pipeline_standard.fbs
src/main_entry/uxb_pipeline_full.fbs
src/main_entry/uxb_legacy_cli_compat.fbs
```

## Route kararı

```text
MINIMAL  -> preprocess/lexer/parser/AST/semantic/HIR/MIR/gate, opsiyonel AST+MIR interpreter, toolchain yok
STANDARD -> verified MIR'den x64 ASM/JS/WAT artifact, hafif backend
FULL     -> toolchain + x64 OBJ/EXE + WASM binary + HTML/CSS/asset/release gate
```

## CLI örnekleri

```bat
uxb_main_64.exe test.bas --mode=min --check
uxb_main_64.exe test.bas --mode=min --run-both

uxb_main_64.exe test.bas --mode=std --emit-x64
uxb_main_64.exe test.bas --mode=std --emit-js
uxb_main_64.exe test.bas --mode=std --emit-wat

uxb_main_64.exe test.bas --mode=full --build-x64
uxb_main_64.exe test.bas --mode=full --emit-wasm
uxb_main_64.exe test.bas --mode=full --target-browser
```

## İş planı

```text
1. UXBCliModel oluştur.
2. Eski CLI seçeneklerini UXBCliModel'e çevir.
3. src/main.bas sonunda sadece UXBCompilerMain(cli) çağır.
4. UXBRunFrontendSemanticMir ortak çekirdek fonksiyonunu kur.
5. Minimal pipeline verified MIR'e kadar gitsin.
6. Standard pipeline backend pipeline çağır.
7. Full pipeline toolchain/release gate eklesin.
8. Eski main_program_entry_part2 doğrudan backend çağrılarını kapat; sadece compat/fallback bırak.
```

## Pozitif testler

```text
--mode=min --check backend çağırmaz ama MIR gate çalıştırır.
--mode=std --emit-wat WAT üretir.
--mode=full --emit-wasm wat2wasm ister.
```

## Negatif testler

```text
Bilinmeyen mode FAIL.
Backend isteyen route mirModuleReady=0 ise FAIL.
Minimal route x64 linker çağırırsa FAIL.
```

## Çıktı

```text
reports/control/current/entry_router_gate.json
reports/control/current/cli_route_matrix.csv
reports/control/current/main_entry_expected_actual.csv
```


---



<!-- FILE: docs/12_ADIM10_TEST_RAPOR_RELEASE_GATE.md -->


---

# 12 — ADIM10: Test, Rapor, Release Gate ve Kapatma Döngüsü

## Amaç

Her adım gerçek expected/actual testlerle kapanacak. Rapor üretmeyen adım tamamlanmış sayılmayacak.

## Test klasör düzeni

```text
tests/control/
tests/frontend/
tests/semantic/
tests/hir/
tests/mir/
tests/interpreter/
tests/backend_x64/
tests/backend_js/
tests/backend_wat_wasm/
tests/release/
tests/expected/
```

## Zorunlu rapor dosyaları

```text
reports/control/current/master_gate_summary.json
reports/control/current/master_gate_summary.md
reports/control/current/directory_snapshot.txt
reports/control/current/output_compare.csv
reports/control/current/error_classification.csv
reports/control/current/toolchain_report.json
```

## error_classification.csv kolonları

```text
error_id
error_class_tr
layer
file
symbol_or_surface
expected
actual
evidence_file
required_fix
owner
```

## Master gate kuralı

PASS olması için:

```text
1. Silmeden temizlik raporu var.
2. Surface matrix boş hücresiz.
3. BROKEN/MISSING saklanmıyor.
4. AST contract gate çalışıyor.
5. Symbol integrity gate çalışıyor.
6. HIR bridge gate çalışıyor.
7. MIR mandatory gate çalışıyor.
8. AST interpreter ve MIR interpreter parity raporu var.
9. Backend pipeline report var.
10. Dış araç raporu var.
11. Expected/actual karşılaştırması var.
```

## Copilot kapanış görevi

```text
Her uygulama turundan sonra sadece test sonuçlarını ve raporları üret.
Kod değiştirmeden önce rapor farkını göster.
```

## Pozitif testler

```text
hello_world
arithmetic
string_ops
variables
if_else
for_loop
while_loop
functions
classes
ffi_smoke
js_emit_smoke
wat_emit_smoke
```

## Negatif testler

```text
syntax_error_recovery
unknown_symbol
duplicate_symbol
bad_mir_operand
missing_typed_local
missing_wat2wasm
backend_without_verified_mir
```

## Çıktı

```text
reports/control/current/master_gate_summary.json
reports/control/current/master_gate_summary.md
reports/control/current/final_release_candidate_manifest.csv
```


---



<!-- FILE: docs/13_COPILOT_UYGULAMA_SIRASI.md -->


---

# 13 — Copilot'a Verilecek Uygulama Sırası

Aşağıdaki sırayı bozma. Her belge ayrı verilecek.

```text
1. 01_COPILOT_ANA_KURALLAR.md
2. 02_ADIM0_INVENTORY_SILMEDEN_TEMIZLIK.md
3. 03_ADIM1_SURFACE_LIFECYCLE_CSV_KAPISI.md
4. 04_ADIM2_LEXER_PREPROCESSOR.md
5. 05_ADIM3_PARSER_ERROR_RECOVERY_SCOPE.md
6. 06_ADIM4_AST_CONTRACT_HIBRIT_COCUK.md
7. 07_ADIM5_SYMBOL_SCOPE_HASH_HIR_BRIDGE.md
8. 08_ADIM6_MIR_BUILDER_TYPED_STORAGE_VERIFY.md
9. 09_ADIM7_INTERPRETER_RUNTIME_PARITY.md
10. 10_ADIM8_BACKEND_PIPELINE_WABT.md
11. 11_ADIM9_MAIN_ENTRY_ROUTER.md
12. 12_ADIM10_TEST_RAPOR_RELEASE_GATE.md
```

## Her Copilot konuşmasına eklenecek kısa emir

```text
Sadece bu adımı uygula.
Önce repo durumunu ve ilgili dosyaları tara.
Hiçbir dosya silme.
Kod değişikliği yapmadan önce hangi dosyaları değiştireceğini yaz.
Her değişiklikten sonra pozitif/negatif test ve expected/actual rapor üret.
BROKEN/MISSING saklama.
IMPLEMENTED demek için gerçek handler/emitter/runtime/test/evidence gerekir.
```

## Her adım sonrası benden istenecek paket

```text
1. Son zip
2. reports/control/current/<step>_gate.json
3. reports/control/current/<step>_gate.md
4. reports/control/current/<step>_expected_actual.csv
5. reports/control/current/error_classification.csv
6. directory_snapshot.txt
```
