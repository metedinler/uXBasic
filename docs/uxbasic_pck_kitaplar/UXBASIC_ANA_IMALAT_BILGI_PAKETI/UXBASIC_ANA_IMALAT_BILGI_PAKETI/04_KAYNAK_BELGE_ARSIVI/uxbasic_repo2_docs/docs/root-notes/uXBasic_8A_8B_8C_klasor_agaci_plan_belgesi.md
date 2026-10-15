# uXBasic Hamle 8A / 8B / 8C Plan Belgesi ve Yeni Klasör Ağacı Taslağı

**Tarih:** 2026-05-02  
**Amaç:** Önceki sohbet kayıtlarında dağınık halde geçen Hamle 8A, 8B, 8C ayrımını ve uXBasic için hedeflenen yeni klasör ağacı planını tek belgede toplamak.

---

## 1. Ana bağlam

`COMPILER_COVERAGE.md` içinde ana plan Hamle 1–24 olarak gidiyor. Biz bu büyük planın **Hamle 8** bölümündeyiz. Ancak Hamle 8 tek parça değil; çalışma sırasında üç alt faza ayrıldı:

```text
Hamle 8A = Hamle 1–7 kapanış borçları, coverage temizliği, gate/test doğrulama
Hamle 8B = inheritance / interface / vtable / operator overload genişletmesi
Hamle 8C = büyük dosya parçalama, klasör ağacı düzenleme, manifest ve include bundle temizliği
```

Bu ayrım özellikle önemlidir; çünkü 8A sırasında bazı işler bilerek yasaklandı:

```text
8A’da yeni inheritance/interface/vtable genişletmesi yok.
8A’da büyük dosya parçalama yok.
8A’da manifest güncellemesi yok.
8A’da yeni syntax icadı yok.
8A’da sessiz fallback yok; hata varsa açık diagnostic verilecek.
```

Bu yasaklanan işler yok sayılmadı; sadece **8B** ve **8C** fazlarına ertelendi.

---

## 2. Hamle 8A — Hamle 1–7 Kapanış Borçları ve Coverage Temizleme

### 2.1. 8A’nın adı

```text
Hamle 8A — Hamle 1–7 Kapanış Borçları ve Coverage Temizleme
```

### 2.2. 8A’nın ana hedefi

8A’nın işi yeni büyük özellik eklemek değil, önceki hamlelerden kalan şu borçları kapatmaktır:

```text
PARTIAL -> OK
MISSING -> OK veya açıkça DEFERRED
DOC-DRIFT -> kod gerçekliğine göre düzeltilmiş doküman
NOOP -> ya gerçek lane ya da açıkça 8B/8C devri
TODO -> kapatılmış veya testle belgelenmiş teknik borç
```

Özellikle şu alanlar 8A kapsamındadır:

```text
Parser / CLI / AST JSON güvenilirliği
Gate altyapısı
x64 class layout güvenliği
F32/F64/F80 diagnostic politikası
String / PRINT / INPUT / TIMER / RND / INKEY/GETKEY parity
Array / REDIM / indexed access parity
TYPE / CLASS field access edge-case testleri
AST runtime / MIR runtime / x64 build-run karşılaştırması
```

---

## 3. 8A Alt İşleri

### 3.1. 8A-1 — Parser / CLI / AST harness stabilizasyonu

#### Sorun

`#include` ile `%%INCLUDE` karıştırıldı. Bu çok tehlikelidir:

```text
#include  = FreeBASIC compiler preprocessor komutu
%%INCLUDE = uXBasic kullanıcı dili preprocessor komutu
```

FreeBASIC ile derlenen compiler kaynaklarında `#include` kalmalıdır. uXBasic kullanıcı programında `%%INCLUDE` kullanılmalıdır.

#### Yapılacaklar

```text
1. main.bas içinden PreprocessHashIncludes kaldırılacak.
2. sourceText = PreprocessHashIncludes(sourceText) satırı olmayacak.
3. #include -> %%INCLUDE otomatik dönüşümü tamamen yasaklanacak.
4. CLI, gerçek uXBasic kaynak dosyası ile FreeBASIC test harness dosyasını ayıracak.
5. --extract-src modu eklenecek veya doğrulanacak.
6. Harness dosyası doğrudan uXBasic source gibi parse edilmeyecek.
7. --ast-json-out parent klasörü yoksa oluşturulacak.
8. ASTWriteJson dönüşü ve astJsonErr görünür raporlanacak.
```

#### Beklenen komut örneği

```bat
build\uxbasic_cli.exe tests\basicCodeTests\80_h8a_operator_numeric_parity.bas --extract-src --ast-json-out tests\basicCodeTests\out_probe_80\ast.json
```

#### Çıkış kriteri

```text
ast.json dosyası gerçekten oluşacak.
JSON boş olmayacak.
Parser source/harness ayrımı açıkça raporlanacak.
Bu geçmeden runtime / vtable / operator işlerine dönülmeyecek.
```

---

### 3.2. 8A-2 — x64 class layout güvenliği

#### Sorun

`code_generator.fbs` içinde şu tür fallback çok tehlikelidir:

```bas
If classSize <= 0 Then classSize = 8
```

Bu, layout çözülememişken compiler’ı susturur. Sonuçta runtime memory corruption oluşabilir.

#### Doğru davranış

```bas
If classSize <= 0 Then
    errText = "x64-codegen: unresolved class layout: " & classTypeName
    Return 0
End If
```

#### Yapılacaklar

```text
1. codegen/x64/code_generator.fbs içinde classSize <= 0 fallback’leri aranacak.
2. Sessiz 8 byte varsayımı kaldırılacak.
3. Layout yoksa açık diagnostic üretilecek.
4. build alınacak.
5. class allocation testi çalıştırılacak.
6. AST/parser regression tekrar çalıştırılacak.
```

#### Çıkış kriteri

```text
classSize <= 0 Then classSize = 8 kalmayacak.
Layout çözülemeyen class sessizce compile edilmeyecek.
Hata kontrollü ve okunabilir dönecek.
```

---

### 3.3. 8A-2.5 — Merkezi çıktı / log sistemi

#### Neden gerekli?

8A sırasında tekrar tekrar “ne oldu?” sorunu yaşandı. Bunun nedeni bazı hataların stdout, bazı debugların parser içi log, bazı çıktılarının ayrı dosyada kalmasıydı.

#### Hedef

```text
Tek merkezli debug / diagnostic / log sistemi
```

#### Kural

```text
Normal bilgi -> ekrana + ana loga
--quiet varsa -> ekrana basma
--debug varsa -> ayrıntı debug loga
Token dump -> sadece --debug-token-dump ile dosyaya
ParserLog / ParserDiag -> UxbDebug merkezine bağlanacak
```

#### Çıkış kriteri

```text
AST JSON problemi, parse problemi, semantic problemi ve codegen problemi aynı rapor yapısında görülebilecek.
```

---

### 3.4. 8A-3 — `__vptr` anlamını tekleştirme

#### Mevcut sorun

Runtime/interpreter tarafında nesnenin başına class index yazılıyordu:

```bas
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)
```

x64 tarafında aynı alan gerçek vtable adresi gibi kullanılıyordu:

```asm
lea rdx, [rel CLASS_VTBL]
mov [rax], rdx
```

Bu mimari olarak yanlıştır. Aynı alan iki backend’de iki farklı kavram taşıyamaz.

#### Kesin karar

```text
__vptr = vtable referansı
```

Fiziksel temsil backend’e göre değişebilir:

```text
x64/native runtime:
    __vptr = gerçek vtable label adresi

interpreter/runtime:
    __vptr = runtime vtable handle
```

Önemli nokta: interpreter tarafında gerçek native pointer zorlanmayacak. Ama class index doğrudan `__vptr` gibi kullanılmayacak.

#### Güncellenecek dosyalar

```text
src/runtime/exec/exec_types.fbs
src/runtime/exec/exec_eval_support_helpers.fbs
src/runtime/exec/exec_class_layout_helpers.fbs
src/runtime/exec/exec_call_dispatch_helpers.fbs
```

#### Yapılacaklar

```text
1. ExecRuntime / ExecState içine vtableClassHandles() alanı eklenecek.
2. vtableNextHandle alanı eklenecek.
3. ExecBuildVTableMap her class’a benzersiz handle atayacak.
4. ExecConfigureClassStorage classIdx değil vtable handle yazacak.
5. ExecAllocClassInstance classIdx değil vtable handle yazacak.
6. Dispatch tarafı object[0] handle okuyarak runtime class çözmeyi deneyecek.
7. Receiver runtime class bulunursa dispatch receiverType buna göre güncellenecek.
8. x64 tarafındaki gerçek vtable pointer modeline bu aşamada dokunulmayacak.
```

#### Çıkış kriterleri

```text
VMemPokeD(objectBase, classIdx) kaynak src/** içinde kalmayacak.
DIM class object[0] vtable handle 0 olmayacak.
NEW class object[0] vtable handle 0 olmayacak.
Child instance Child vtable handle taşıyacak.
Interpreter method dispatch override durumunda runtime class’a göre çözülecek.
```

---

### 3.5. 8A-4 — x64 vtable label üretimini merkezileştirme

#### Mevcut sorun

x64 tarafında vtable label şu şekilde dağınık üretilebiliyordu:

```bas
vtblLabel = className & "_VTBL"
lea rdx, [rel " & classTypeName & "_VTBL]
lea rdx, [rel " & declTypeName & "_VTBL]
```

Bu tehlikelidir:

```text
class adı farklı casing ile gelirse label bozulur.
namespace / özel karakter varsa NASM label bozulur.
emit edilen label ile kullanılan label ayrışabilir.
```

#### Hedef

Tek merkez:

```bas
X64ClassVTableLabel(className)
```

#### Önerilen helper

```bas
Private Function X64SanitizeSymbolPart(ByRef rawText As String) As String
    ' Harf, rakam ve _ dışındaki karakterleri _ yap.
    ' İlk karakter rakamsa başa _ ekle.
End Function

Private Function X64ClassVTableLabel(ByRef classNameRaw As String) As String
    Return "__uxb_vtbl_" & X64SanitizeSymbolPart(X64Upper(Trim(classNameRaw)))
End Function
```

#### Yapılacaklar

```text
1. code_generator.fbs içine X64SanitizeSymbolPart helper’ı eklenecek.
2. X64ClassVTableLabel helper’ı eklenecek.
3. VTable emit tarafı bu helper’ı kullanacak.
4. NEW_EXPR allocation tarafı bu helper’ı kullanacak.
5. DIM class default allocation tarafı bu helper’ı kullanacak.
6. "_VTBL" ham string üretimi grep ile temizlenecek.
```

#### Çıkış kriteri

```text
className & "_VTBL" kalmayacak.
classTypeName & "_VTBL" kalmayacak.
declTypeName & "_VTBL" kalmayacak.
ASM içinde merkezi "__uxb_vtbl_CLASSNAME" label modeli olacak.
Undefined *_VTBL link hatası oluşmayacak.
```

---

### 3.6. 8A-5 — Numeric / float / string / array parity kapanışı

8A’nın ana test seti:

```text
tests/basicCodeTests/80_h8a_operator_numeric_parity.bas
tests/basicCodeTests/81_h8a_float_f64_native_parity.bas
tests/basicCodeTests/82_h8a_f80_diagnostic.bas
tests/basicCodeTests/83_h8a_string_builtin_native_parity.bas
tests/basicCodeTests/84_h8a_timer_rnd_inkey_smoke.bas
tests/basicCodeTests/85_h8a_redim_preserve_native_parity.bas
tests/basicCodeTests/86_h8a_array_type_class_indexed_parity.bas
tests/basicCodeTests/87_h8a_print_float_string_parity.bas
```

#### Her test için zorunlu katmanlar

```text
parse/json
semantic
AST runtime
MIR runtime
x64 build
x64 run
```

#### Başarı sayılmayacak durumlar

```text
SKIP başarı değildir.
MISSING başarı değildir.
RAN_EXIT_5 başarı değildir.
RAN_EXIT_10 başarı değildir.
Sessiz fallback başarı değildir.
```

---

### 3.7. 8A-6 — Gate altyapısı

#### Hedef

Tek komutla tüm katmanları denetlemek:

```text
AST
MIR
x64 build
x64 run
artifact outputs
diagnostics
```

#### Önerilen çıktı

```text
matrix.csv
matrix.md
artifact-report.json
system-health-report.json
```

#### Çıkış kriteri

```text
Her test için PASS/FAIL tek tabloda görünecek.
İlk gerçek hata loglardan izlenebilecek.
Yanlış compiler exe çağrısı gate’i komple FAIL yapamayacak; raporda açık görünecek.
```

---

### 3.8. 8A-7 — Dokümantasyon güncellemesi

Güncellenecek belgeler:

```text
COMPILER_COVERAGE.md
COMPILER_PARITY_MATRIX.md
MIR_STATUS.md
NATIVE_X64_STATUS.md
COMPILER_TODO.md
yapilanlar.md
```

#### 8A sonunda rapor şunları içerecek

```text
Tam kapananlar
Kısmi kalanlar
8B’ye devredenler
8C’ye devredenler
Test matrisi
Bilinen riskler
Sonraki iş emri
```

---

## 4. Hamle 8B — OOP / VTable / Interface / Operator Overload Genişletmesi

### 4.1. 8B’nin ana fikri

8A’da bilerek yasaklanan büyük OOP genişletmeleri 8B’de yapılacak.

```text
Hamle 8B = inheritance/interface/vtable/operator overload genişletme fazı
```

8B başlamadan önce 8A gate temiz olmalıdır.

---

### 4.2. 8B kapsamı

```text
1. Class -> method list oluşturma
2. Method -> slot index belirleme
3. Base class slotlarını koruma
4. Override aynı slotu alacak
5. Yeni method sona eklenecek
6. Interface method contract doğrulama
7. Runtime vtable dispatch tamamlanacak
8. MIR_CALL_VIRTUAL opcode gerçek model olacak
9. MIR_CALL_MAGIC opcode gerçek model olacak
10. __VT_SLOT__ string hack’i kaldırılacak
11. x64 indirect virtual call güvenli hale gelecek
12. Operator overload vtable tamamlanmadan açılmayacak
```

---

### 4.3. 8B semantic planı

#### Method table kuralları

```text
Base method slotları derived class’a aynen taşınır.
OVERRIDE edilen method base slotunu kullanır.
Yeni VIRTUAL method sona eklenir.
Non-virtual method slot almaz; direct call olur.
Constructor virtual olamaz.
Destructor ayrı lifecycle protokolüdür; normal vtable slotu gibi ele alınmaz.
Interface methodları ayrı interface dispatch tablosuna bağlanır.
```

#### Zorunlu semantic kontroller

```text
Base class var mı?
Inheritance cycle var mı?
Override edilen method gerçekten virtual mı?
Override signature birebir uyumlu mu?
Aynı class içinde duplicate method var mı?
Overload izinliyse signature farkı var mı?
Interface methodlarının tamamı implement edildi mi?
Magic method signature doğru mu?
```

---

### 4.4. 8B layout planı

Kurulacak tablolar:

```text
ClassLayoutTable
FieldOffsetTable
MethodSymbolTable
VTableLayoutTable
InterfaceDispatchTable
MagicMethodTable
```

Nesne layout genel modeli:

```text
offset 0: __vptr
offset 8: runtime/class metadata veya flags alanı gerekiyorsa
offset N: base fields
offset M: derived fields
alignment: max(field alignment, pointer alignment)
```

---

### 4.5. 8B MIR planı

String hack bırakılacak:

```text
Yanlış/Geçici:
CALL "__VT_SLOT__:Class:3"
```

Kalıcı model:

```text
MIR_NEW_OBJECT classId
MIR_CALL_METHOD receiver, methodId
MIR_CALL_VIRTUAL receiver, slotIndex, signatureId
MIR_CALL_MAGIC receiver, magicKind, args
MIR_GET_FIELD receiver, fieldId
MIR_SET_FIELD receiver, fieldId, value
MIR_INSTANCEOF receiver, classId
MIR_CAST_OBJECT receiver, targetClassId
MIR_DESTROY_OBJECT receiver
```

---

### 4.6. 8B runtime planı

Virtual call zinciri:

```text
receiver addr
-> object[0] __vptr
-> vtable handle / pointer
-> runtime class
-> slot
-> method target
-> signature check
-> ExecInvokeRoutineByIndex veya eşdeğer dispatch
```

Güvenlik kontrolleri:

```text
receiver null mu?
vtable null mu?
slot out-of-range mi?
slot entry null mu?
signature uyuyor mu?
return type uyuyor mu?
```

---

### 4.7. 8B x64 planı

Win64 ABI kuralı:

```text
RCX = this
RDX = arg1
R8  = arg2
R9  = arg3
stack = sonraki argümanlar
shadow space = 32 byte
stack alignment = 16 byte
```

Safe virtual call modeli:

```asm
test rcx, rcx
jz __uxb_raise_null_object

mov rax, [rcx + 0]
test rax, rax
jz __uxb_raise_null_vtable

mov r11, [rax + slot*8]
test r11, r11
jz __uxb_raise_null_vslot

call r11
```

Runtime hata rutinleri:

```text
__uxb_raise_null_object
__uxb_raise_null_vtable
__uxb_raise_null_vslot
__uxb_raise_vslot_oob
__uxb_raise_bad_signature
```

---

### 4.8. 8B operator overload planı

Operator overload, vtable tamamlanmadan açılmayacak.

Magic method tablosu:

```text
+        -> <add>
-        -> <sub>
*        -> <mul>
/        -> <div>
\        -> <idiv>
MOD      -> <mod>
**       -> <pow>
=        -> <eq>
<>       -> <ne>
<        -> <lt>
<=       -> <le>
>        -> <gt>
>=       -> <ge>
AND      -> <and>
OR       -> <or>
XOR      -> <xor>
NOT      -> <not>
[]       -> <index>
[]=      -> <setindex>
CALL     -> <call>
STRING   -> <str>
```

Resolution sırası:

```text
Primitive + primitive -> normal operator
Class + primitive -> lhs.<op>(rhs)
Primitive + class -> rhs.<rop>(lhs)
Class + class -> lhs.<op>(rhs)
Bulunamazsa semantic hata
```

Reverse magic methodlar:

```text
<radd>
<rsub>
<rmul>
<rdiv>
<req>
<rlt>
```

---

### 4.9. 8B test matrisi

```text
class_empty
class_field_i32
class_field_f64
class_inheritance_field_offset
class_method_direct_call
class_virtual_call_base_ref
class_override_signature_fail
class_constructor
class_destructor
class_magic_add
class_magic_str
class_null_virtual_call
virtual_base_call
virtual_derived_override
virtual_null_object
virtual_missing_slot
virtual_signature_mismatch_debug
virtual_return_i32
virtual_return_f64
virtual_with_two_args
interface_contract_ok
interface_missing_method_fail
```

---

## 5. Hamle 8C — Klasör Ağacı, Modülerleşme ve Manifest Temizliği

### 5.1. 8C’nin ana fikri

```text
Hamle 8C = code_generator / mir / memory_exec parçalama + manifest güncelleme
```

8C, büyük dosya düzenleme fazıdır. 8A ve 8B geçmeden yapılırsa hata ayıklama zorlaşır.

---

### 5.2. 8C’ye devredilecek işler

```text
1. code_generator.fbs parçalanacak.
2. mir.fbs parçalanacak.
3. mir_evaluator.fbs parçalanacak.
4. memory_exec.fbs parçalanacak.
5. semantic_pass.fbs daha küçük validator dosyalarına ayrılacak.
6. parser alt dosyaları daha tutarlı isimlendirilecek.
7. build/include bundle sistemi sadeleştirilecek.
8. manifest dosyaları güncellenecek.
9. docs/status dosyaları yeni klasör ağacına göre taşınacak.
10. Gate scriptleri tests/gates altına alınacak.
```

---

## 6. Yeni uXBasic Klasör Ağacı Planı

Aşağıdaki ağaç, mevcut `src17` yapısını koruyarak ama büyük dosya/parça sorununu çözecek şekilde tasarlanmıştır.

### 6.1. Hedef kök yapı

```text
uXBasic_repo/
├─ src/
│  ├─ app/
│  ├─ cli/
│  ├─ frontend/
│  ├─ semantic/
│  ├─ ir/
│  ├─ runtime/
│  ├─ codegen/
│  ├─ build/
│  └─ platform/
│
├─ tests/
│  ├─ basicCodeTests/
│  ├─ probes/
│  ├─ runtime/
│  ├─ mir/
│  ├─ x64/
│  ├─ gates/
│  └─ fixtures/
│
├─ tools/
├─ scripts/
├─ docs/
├─ reports/
├─ build/
├─ dist/
└─ release/
```

---

### 6.2. `src/app`

```text
src/app/
├─ main.bas
├─ app_bootstrap.fbs
├─ app_config.fbs
└─ app_version.fbs
```

Amaç:

```text
main.bas sadece orkestrasyon yapacak.
CLI parse, build, run, artifact üretimi ayrı modüllere devredilecek.
```

---

### 6.3. `src/cli`

```text
src/cli/
├─ cli_args.fbs
├─ cli_modes.fbs
├─ cli_output_paths.fbs
├─ cli_artifact_report.fbs
├─ cli_validate_all.fbs
└─ cli_diagnostics.fbs
```

Amaç:

```text
--ast-json-out
--hir-json-out
--mir-pipeline-json-out
--artifact-report-json-out
--codegen-source AST|MIR
--validate-all
--quiet
--debug
--debug-token-dump
```

gibi yollar main.bas içinden çıkarılacak.

---

### 6.4. `src/frontend`

```text
src/frontend/
├─ token/
│  ├─ token_kinds.fbs
│  └─ token_stream.fbs
│
├─ lexer/
│  ├─ lexer_core.fbs
│  ├─ lexer_driver.fbs
│  ├─ lexer_keyword_table.fbs
│  ├─ lexer_preprocess.fbs
│  └─ lexer_readers.fbs
│
├─ parser/
│  ├─ parser_core.fbs
│  ├─ parser_shared.fbs
│  ├─ parser_expr.fbs
│  ├─ parser_stmt_dispatch.fbs
│  ├─ parser_stmt_flow.fbs
│  ├─ parser_stmt_io.fbs
│  ├─ parser_stmt_memory.fbs
│  ├─ parser_stmt_decl/
│  │  ├─ parser_stmt_decl_core.fbs
│  │  ├─ parser_stmt_decl_dim_redim.fbs
│  │  ├─ parser_stmt_decl_proc.fbs
│  │  ├─ parser_stmt_decl_scope.fbs
│  │  └─ parser_stmt_decl_class_method.fbs
│  └─ parser_stmt_oop/
│     ├─ parser_stmt_class.fbs
│     ├─ parser_stmt_interface.fbs
│     └─ parser_stmt_method_flags.fbs
│
├─ ast/
│  ├─ ast_model.fbs
│  ├─ ast_builders.fbs
│  ├─ ast_roles.fbs
│  ├─ ast_json_writer.fbs
│  └─ ast_debug_dump.fbs
│
└─ preprocess/
   ├─ uxb_preprocess.fbs
   └─ include_resolver.fbs
```

Not:

```text
FreeBASIC #include ile uXBasic %%INCLUDE burada kesin ayrılacak.
```

---

### 6.5. `src/semantic`

```text
src/semantic/
├─ semantic_pass.fbs
├─ diagnostics/
│  ├─ semantic_errors.fbs
│  └─ semantic_report.fbs
│
├─ validators/
│  ├─ validate_main_program.fbs
│  ├─ validate_flow.fbs
│  ├─ validate_using_alias.fbs
│  ├─ validate_type_refs.fbs
│  ├─ validate_routines.fbs
│  ├─ validate_const_rhs.fbs
│  ├─ validate_io.fbs
│  ├─ validate_memory_intrinsics.fbs
│  └─ validate_oop.fbs
│
├─ type/
│  ├─ type_binding.fbs
│  ├─ type_normalize.fbs
│  ├─ type_compare.fbs
│  ├─ type_cast_rules.fbs
│  └─ type_numeric_rules.fbs
│
├─ layout/
│  ├─ layout_type_table.fbs
│  ├─ layout_path_common.fbs
│  ├─ layout_path_resolution.fbs
│  ├─ layout_path_and_intrinsic.fbs
│  ├─ layout_intrinsic_validation.fbs
│  └─ layout_shared_core.fbs
│
└─ oop/
   ├─ class_table.fbs
   ├─ method_table.fbs
   ├─ vtable_layout.fbs
   ├─ interface_table.fbs
   ├─ magic_method_table.fbs
   └─ override_rules.fbs
```

---

### 6.6. `src/ir`

```text
src/ir/
├─ hir/
│  ├─ hir_model.fbs
│  ├─ hir_builder.fbs
│  └─ hir_exporter_json.fbs
│
├─ mir/
│  ├─ mir_model.fbs
│  ├─ mir_builder.fbs
│  ├─ mir_lower_expr.fbs
│  ├─ mir_lower_stmt.fbs
│  ├─ mir_lower_oop.fbs
│  ├─ mir_lower_io.fbs
│  ├─ mir_lower_memory.fbs
│  ├─ mir_optimizer.fbs
│  ├─ mir_evaluator.fbs
│  ├─ mir_eval_expr.fbs
│  ├─ mir_eval_stmt.fbs
│  ├─ mir_eval_oop.fbs
│  └─ mir_eval_io.fbs
│
└─ exporters/
   ├─ mir_exporter_json.fbs
   ├─ mir_surface_json.fbs
   └─ mir_pipeline_report.fbs
```

Amaç:

```text
mir.fbs tek dev dosya olmaktan çıkacak.
mir_evaluator.fbs expression/statement/oop/io olarak ayrılacak.
```

---

### 6.7. `src/runtime`

```text
src/runtime/
├─ core/
│  ├─ exec_types.fbs
│  ├─ exec_state_value_utils.fbs
│  ├─ diagnostics.fbs
│  ├─ error_format.fbs
│  └─ error_localization.fbs
│
├─ memory/
│  ├─ memory_vm.fbs
│  ├─ memory_alloc.fbs
│  ├─ memory_peek_poke.fbs
│  └─ memory_copy_fill.fbs
│
├─ exec/
│  ├─ memory_exec.fbs
│  ├─ exec_stmt_flow.fbs
│  ├─ exec_stmt_io_file.fbs
│  ├─ exec_stmt_memory_core.fbs
│  ├─ exec_eval_builtin_categories.fbs
│  ├─ exec_eval_text_helpers.fbs
│  └─ exec_call_dispatch_helpers.fbs
│
├─ oop/
│  ├─ exec_class_layout_helpers.fbs
│  ├─ exec_vtable_runtime.fbs
│  ├─ exec_object_alloc.fbs
│  ├─ exec_method_dispatch.fbs
│  ├─ exec_constructor_destructor.fbs
│  └─ exec_interface_dispatch.fbs
│
├─ collections/
│  ├─ exec_collections.fbs
│  ├─ exec_list.fbs
│  ├─ exec_dict.fbs
│  └─ exec_set.fbs
│
├─ io/
│  ├─ file_io.fbs
│  ├─ console_io.fbs
│  └─ timer.fbs
│
├─ ffi/
│  ├─ exec_ffi_runtime.fbs
│  ├─ exec_ffi_x64_invoke_helpers.fbs
│  └─ ffi_signer.fbs
│
└─ slot/
   ├─ exec_slot_manager.fbs
   ├─ exec_event_runtime.fbs
   ├─ exec_thread_runtime.fbs
   └─ exec_pipe_runtime.fbs
```

---

### 6.8. `src/codegen`

```text
src/codegen/
├─ common/
│  ├─ cg_context.fbs
│  ├─ cg_symbols.fbs
│  ├─ cg_diagnostics.fbs
│  └─ cg_artifacts.fbs
│
├─ x64/
│  ├─ x64_context.fbs
│  ├─ x64_abi_win64.fbs
│  ├─ x64_symbols.fbs
│  ├─ x64_data_emit.fbs
│  ├─ x64_text_emit.fbs
│  ├─ x64_expr_emit.fbs
│  ├─ x64_stmt_emit.fbs
│  ├─ x64_assign_emit.fbs
│  ├─ x64_call_emit.fbs
│  ├─ x64_oop_emit.fbs
│  ├─ x64_vtable_emit.fbs
│  ├─ x64_memory_emit.fbs
│  ├─ x64_io_emit.fbs
│  ├─ x64_float_emit.fbs
│  ├─ x64_string_emit.fbs
│  ├─ x64_intrinsic_emit.fbs
│  ├─ var_mapping.fbs
│  ├─ ffi_call_backend.fbs
│  ├─ inline_backend.fbs
│  └─ code_generator.fbs
│
└─ x86/
   └─ ffi_call_backend.fbs
```

Not:

```text
code_generator.fbs ilk aşamada facade/orchestrator kalabilir.
Asıl emit fonksiyonları adım adım x64_* dosyalarına taşınır.
```

---

### 6.9. `src/build`

```text
src/build/
├─ manifest/
│  ├─ interop_manifest.fbs
│  ├─ include_manifest.fbs
│  └─ artifact_manifest.fbs
│
├─ bundles/
│  ├─ main_frontend_include_bundle.fbs
│  ├─ main_runtime_include_bundle.fbs
│  ├─ main_semantic_include_bundle.fbs
│  ├─ main_ir_include_bundle.fbs
│  └─ main_codegen_include_bundle.fbs
│
└─ pipelines/
   ├─ x64_build_pipeline.fbs
   ├─ nasm_pipeline.fbs
   ├─ gcc_pipeline.fbs
   └─ release_pipeline.fbs
```

---

### 6.10. `tests`

```text
tests/
├─ basicCodeTests/
│  ├─ 80_h8a_operator_numeric_parity.bas
│  ├─ 81_h8a_float_f64_native_parity.bas
│  ├─ 82_h8a_f80_diagnostic.bas
│  ├─ 83_h8a_string_builtin_native_parity.bas
│  ├─ 84_h8a_timer_rnd_inkey_smoke.bas
│  ├─ 85_h8a_redim_preserve_native_parity.bas
│  ├─ 86_h8a_array_type_class_indexed_parity.bas
│  └─ 87_h8a_print_float_string_parity.bas
│
├─ gates/
│  ├─ run_h8a_gate.ps1
│  ├─ run_h8b_gate.ps1
│  ├─ run_h8c_gate.ps1
│  └─ run_validate_all.ps1
│
├─ runtime/
│  ├─ run_input_exec_ast.bas
│  ├─ run_file_io_exec_ast.bas
│  ├─ run_class_ctor_dtor_exec_ast.bas
│  └─ run_class_inheritance_virtual_exec_ast.bas
│
├─ mir/
│  ├─ run_memory_exec_mir.bas
│  ├─ run_print_zone_exec_mir.bas
│  ├─ run_input_exec_mir.bas
│  └─ run_file_io_exec_mir.bas
│
├─ x64/
│  ├─ run_x64_codegen_emit.bas
│  ├─ run_x64_codegen_memory_emit.bas
│  ├─ run_x64_vtable_emit.bas
│  └─ run_x64_float_emit.bas
│
└─ fixtures/
   ├─ simple/
   ├─ oop/
   ├─ io/
   ├─ arrays/
   └─ numeric/
```

---

### 6.11. `docs`

```text
docs/
├─ architecture/
│  ├─ uxbasic_mimari.md
│  ├─ frontend_architecture.md
│  ├─ semantic_architecture.md
│  ├─ mir_architecture.md
│  ├─ runtime_architecture.md
│  └─ x64_codegen_architecture.md
│
├─ coverage/
│  ├─ COMPILER_COVERAGE.md
│  ├─ COMPILER_PARITY_MATRIX.md
│  ├─ MIR_STATUS.md
│  ├─ NATIVE_X64_STATUS.md
│  └─ COMPILER_TODO.md
│
├─ decisions/
│  ├─ ADR_0001_include_vs_uxb_include.md
│  ├─ ADR_0002_vptr_semantics.md
│  ├─ ADR_0003_class_layout_no_silent_fallback.md
│  ├─ ADR_0004_vtable_label_policy.md
│  └─ ADR_0005_gate_contract.md
│
└─ release/
   ├─ yapilanlar.md
   ├─ known_issues.md
   └─ release_checklist.md
```

---

### 6.12. `reports`

```text
reports/
├─ h8a/
│  ├─ matrix.csv
│  ├─ matrix.md
│  ├─ h8a_final_report.md
│  └─ artifact_report.json
│
├─ h8b/
│  ├─ matrix.csv
│  ├─ matrix.md
│  └─ h8b_final_report.md
│
├─ h8c/
│  ├─ refactor_map.md
│  ├─ include_manifest_report.md
│  └─ h8c_final_report.md
│
└─ latest/
   ├─ system_health_report.json
   └─ last_gate_summary.md
```

---

## 7. Mevcut `src17` yapısından yeni yapıya geçiş haritası

### 7.1. Mevcut -> hedef eşleştirme

| Mevcut dosya / klasör | Hedef yer |
|---|---|
| `src/main.bas` | `src/app/main.bas` |
| `src/parser/token_kinds.fbs` | `src/frontend/token/token_kinds.fbs` |
| `src/parser/lexer/*` | `src/frontend/lexer/*` |
| `src/parser/parser/*` | `src/frontend/parser/*` |
| `src/parser/ast.fbs` | `src/frontend/ast/ast_model.fbs` + yardımcı dosyalar |
| `src/semantic/type_binding.fbs` | `src/semantic/type/type_binding.fbs` |
| `src/semantic/layout/*` | `src/semantic/layout/*` |
| `src/semantic/semantic_pass.fbs` | `src/semantic/semantic_pass.fbs` + `validators/*` |
| `src/semantic/mir.fbs` | `src/ir/mir/mir_builder.fbs` + lower dosyaları |
| `src/semantic/mir_model.fbs` | `src/ir/mir/mir_model.fbs` |
| `src/semantic/mir_evaluator.fbs` | `src/ir/mir/mir_evaluator.fbs` + eval dosyaları |
| `src/semantic/mir_exporter_json.fbs` | `src/ir/exporters/mir_exporter_json.fbs` |
| `src/runtime/memory_exec.fbs` | `src/runtime/exec/memory_exec.fbs` + küçük exec modülleri |
| `src/runtime/memory_vm.fbs` | `src/runtime/memory/memory_vm.fbs` |
| `src/runtime/file_io.fbs` | `src/runtime/io/file_io.fbs` |
| `src/runtime/exec/exec_class_layout_helpers.fbs` | `src/runtime/oop/exec_class_layout_helpers.fbs` |
| `src/runtime/exec/exec_call_dispatch_helpers.fbs` | `src/runtime/oop/exec_method_dispatch.fbs` |
| `src/codegen/x64/code_generator.fbs` | `src/codegen/x64/code_generator.fbs` facade + x64 emit dosyaları |
| `src/codegen/x64/cg_context.fbs` | `src/codegen/common/cg_context.fbs` veya `src/codegen/x64/x64_context.fbs` |
| `src/build/*` | `src/build/manifest`, `src/build/bundles`, `src/build/pipelines` |

---

## 8. 8C geçiş kuralları

### 8.1. Büyük patlatma yasak

8C’de tüm dosyaları bir anda taşımak doğru değildir. Sıra şu olmalı:

```text
1. Yeni klasörleri oluştur.
2. Eski dosyalar yerinde kalsın.
3. Yeni dosyaları include bundle ile bağla.
4. Sadece bir modülü taşı.
5. Build al.
6. Gate çalıştır.
7. Dokümanı güncelle.
8. Sonra ikinci modüle geç.
```

### 8.2. Facade modeli

Büyük dosyalar önce facade kalabilir:

```text
code_generator.fbs -> x64_* dosyalarını include eden orchestrator
mir.fbs            -> mir_lower_* dosyalarını include eden orchestrator
memory_exec.fbs    -> exec_* dosyalarını include eden orchestrator
semantic_pass.fbs  -> validators/* dosyalarını include eden orchestrator
```

### 8.3. Commit kuralı

```text
Her taşıma commit’i tek kavram taşımalı.
Taşıma commit’inde davranış değişikliği yapılmamalı.
Davranış değişikliği ayrı commit olmalı.
PARTIAL/MISSING -> OK dönüşümü aynı committe dokümanda işlenmeli.
```

---

## 9. Fazlar arası kapı kuralları

### 9.1. 8A kapanmadan 8B’ye geçilmez

8A kapanış şartları:

```text
CLI AST JSON çalışıyor.
Harness/source ayrımı çalışıyor.
classSize fallback yok.
__vptr runtime handle modeli çalışıyor.
x64 vtable label merkezi.
80–87 testleri katmanlı matriste raporlu.
Docs güncel.
```

### 9.2. 8B kapanmadan 8C’ye geçilmez

8B kapanış şartları:

```text
Semantic method/vtable tablosu gerçek.
Override slot sistemi doğru.
Runtime vtable dispatch doğru.
MIR_CALL_VIRTUAL gerçek opcode.
MIR_CALL_MAGIC gerçek opcode.
Operator overload yalnızca vtable tamamlandıktan sonra açık.
x64 safe virtual call çalışıyor.
Interface contract en az semantic düzeyde güvenilir.
```

### 9.3. 8C kapanış şartları

```text
Yeni klasör ağacı aktif.
Eski dev dosyalar facade veya parçalanmış.
Include bundle / manifest güncel.
Build scriptleri yeni yapıya göre çalışıyor.
Gate scriptleri yeni tests/gates yapısında çalışıyor.
Docs yeni path’lere göre güncel.
```

---

## 10. Diğer ajana verilecek kısa iş emirleri

### 10.1. 8A için kısa iş emri

```text
8A içinde kal.
Yeni inheritance/interface/operator overload ekleme.
Önce gate’i düzelt.
--ast-json-out ve --extract-src akışını doğrula.
classSize <= 0 fallback kalmadığını doğrula.
__vptr runtime classIdx değil vtable handle yazıyor mu kontrol et.
x64 _VTBL string üretimi merkezi helper’a bağlı mı kontrol et.
80–87 testlerini parse/json, semantic, AST, MIR, x64 build/run olarak raporla.
SKIP/MISSING/RAN_EXIT başarı sayılmasın.
```

### 10.2. 8B için kısa iş emri

```text
8B’ye yalnız 8A gate temizse geç.
Önce semantic method table ve vtable slot sistemini kur.
Base slotları koru.
Override aynı slotu alsın.
Yeni virtual method sona eklensin.
Operator overload’u kapalı tut; vtable bitmeden açma.
MIR_CALL_VIRTUAL ve MIR_CALL_MAGIC gerçek opcode olsun.
__VT_SLOT__ string hack’ini kalıcı model sayma.
Runtime ve x64 virtual dispatch null/vtable/slot/signature guard içersin.
```

### 10.3. 8C için kısa iş emri

```text
8C yalnız 8A ve 8B testleri yeşilse başlasın.
Davranış değiştirmeden klasör ağacı düzenle.
Önce code_generator.fbs facade kalsın; emit fonksiyonlarını x64_* dosyalarına taşı.
Sonra mir.fbs lower/eval dosyalarına ayrılacak.
Sonra memory_exec.fbs runtime/exec/oop/io/memory olarak ayrılacak.
Her taşıma sonrası build + gate çalıştır.
Manifest ve include bundle güncelle.
```

---

## 11. Kısa sonuç

```text
8A = sistemi ayağa kaldırma, test/gate/coverage temizliği
8B = OOP dispatch ve operator overload genişletmesi
8C = modüler klasör ağacı ve manifest refactor
```

Şu an yapılacak en doğru davranış:

```text
1. src17 gerçekliğini esas al.
2. 8A’da kalan doğrulama açıklarını kapat.
3. 8A kapanış raporu çıkar.
4. Sonra 8B planını uygulamaya başla.
5. 8B bitmeden 8C refactor’a girme.
```
