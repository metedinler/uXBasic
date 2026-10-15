# uXBasic `src17` Mimari İnceleme ve Eksiklik Raporu

**Tarih:** 2026-05-02  
**İncelenen paketler:** `src10`, `src11`, `src13`, `src15`, `src16`, `src17`  
**Ana odak:** `src17` kaynak gerçekliği, önceki bağlamdaki 8A/8A-3/8A-4 beklentileriyle karşılaştırma.

---

## 1. Kısa hüküm

`src17`, `src16`ya göre küçülmüş görünse de bu bir kod kaybı değildir. `src16` içinde bulunan yaklaşık 5.3 MB boyutlu `src/main.c` ara çıktısı `src17`de yoktur. Gerçek `.bas/.fbs/.bi` kaynakları bakımından `src17` büyümüştür. Bu nedenle güncel çalışma tabanı olarak `src17` kullanılabilir.

Ancak `src17` “tam kapanmış” değildir. Özellikle Hamle 8A’nın temizlik/coverage borçları devam etmektedir. `8A-3` ve `8A-4` tarafında önemli düzeltmeler yapılmış görünmektedir; fakat inheritance/virtual dispatch, `NEW` expression parse, AST JSON/harness ayrımı, x64 parity, koleksiyonların MIR/x64 karşılığı ve bazı unsupported/TODO noktaları hâlâ açıktır.

---

## 2. Sürüm karşılaştırma özeti

| Sürüm | Toplam dosya | Kaynak dosya | Kaynak byte | Kaynak satır | Not |
|---|---:|---:|---:|---:|---|
| src10 | 79 | 76 | 1,427,500 | 39,898 | Eski taban |
| src11 | 79 | 76 | 1,476,209 | 41,025 | MIR/OOP/runtime büyümesi |
| src13 | 79 | 76 | 1,489,934 | 41,371 | 8A öncesi OOP/vtable denemeleri |
| src15 | 79 | 76 | 1,490,711 | 41,390 | Küçük parser/runtime ekleri |
| src16 | 80 | 76 | 1,494,208 | 41,489 | `main.c` yüzünden zip şişmiş |
| src17 | 79 | 76 | 1,504,160 | 41,710 | En güncel ve temiz paket |

`src16 -> src17` gerçek kaynak değişimi: `main.c` kaldırılmış, ama `.fbs/.bas/.bi` kaynakları artmıştır.

Öne çıkan `src16 -> src17` değişen dosyalar:

| Dosya | Değişim |
|---|---:|
| `semantic/mir_evaluator.fbs` | +3635 byte |
| `codegen/x64/code_generator.fbs` | +2980 byte |
| `runtime/exec/exec_eval_support_helpers.fbs` | +2567 byte |
| `runtime/exec/exec_call_dispatch_helpers.fbs` | +558 byte |
| `runtime/memory_exec.fbs` | +233 byte |
| `runtime/exec/exec_types.fbs` | +73 byte |
| `codegen/x64/cg_context.fbs` | +70 byte |
| `runtime/exec/exec_class_layout_helpers.fbs` | -164 byte |

---

## 3. `src17` mimari yapısı

### 3.1 Üst akış

`src17` mimarisi şu ana hatta ilerliyor:

```text
main.bas
  -> lexer / preprocess
  -> parser
  -> AST
  -> semantic_pass
  -> HIR/MIR üretimi
  -> AST runtime veya MIR runtime / execmem
  -> x64 codegen
  -> x64 build pipeline
```

### 3.2 Ana dosya katmanları

| Katman | Ana dosyalar | Durum |
|---|---|---|
| CLI / giriş | `main.bas` | `--extract-src`, harness ayrımı ve AST JSON hattı eklenmiş; yine de AST JSON regresyonu ayrıca doğrulanmalı |
| Lexer | `parser/lexer*.fbs` | Geniş keyword/token yüzeyi var; bazı alias/compat kalıntıları duruyor |
| Parser | `parser/parser*.fbs` | Dil yüzeyi geniş; statement registry aktif; `NEW` expression tarafında parse hatası raporlanmış |
| AST | `parser/ast.fbs` | Çekirdek AST var; JSON export hattı hassas |
| Semantic | `semantic/semantic_pass.fbs`, `type_binding.fbs`, layout dosyaları | OOP, override, layout tarafı büyümüş; signature/type parity tam değil |
| MIR | `semantic/mir.fbs`, `mir_model.fbs` | Çok sayıda opcode/lowering var; bazı alanlarda string-hack ve unsupported noktalar duruyor |
| MIR evaluator | `semantic/mir_evaluator.fbs` | Runtime class resolve/vtable dispatch eklenmiş; bazı builtins/laneler eksik |
| AST runtime | `runtime/memory_exec.fbs`, `runtime/exec/*` | Çalışan geniş interpreter katmanı; koleksiyonlar AST/exec tarafında var |
| x64 codegen | `codegen/x64/code_generator.fbs`, `cg_context.fbs` | En büyük dosya; class allocation/vtable label düzeltmeleri var; native parity hâlâ kısmi |
| Build pipeline | `build/*`, `codegen/x64/ffi_call_backend.fbs` | FFI ve x64 build hattı var; test standardizasyonu eksik |

### 3.3 En büyük dosyalar

| Dosya | Satır | Yorum |
|---|---:|---|
| `codegen/x64/code_generator.fbs` | 7890 | Aşırı büyümüş; 8C’de parçalanmalı |
| `semantic/mir.fbs` | 3401 | MIR lowering yoğun; unsupported noktalar var |
| `semantic/mir_evaluator.fbs` | 2773 | MIR runtime büyüyor; vtable/runtime class çözümü ekli |
| `runtime/memory_exec.fbs` | 2278 | AST runtime ana yükü taşıyor |
| `runtime/exec/exec_ffi_runtime.fbs` | 1738 | FFI runtime |
| `semantic/semantic_pass.fbs` | 1579 | Semantic/OOP kontrolleri |

---

## 4. Bağlamdaki kritik hatalar `src17`de giderilmiş mi?

### 4.1 `#include -> %%INCLUDE` karışıklığı

**Beklenen:** FreeBASIC kaynaklarında `#include`, uXBasic kullanıcı kaynaklarında `%%INCLUDE` kalmalıydı. Otomatik dönüşüm kaldırılmalıydı.

**src17 durumu:** `PreprocessHashIncludes` bulunmadı. `main.bas` başında FreeBASIC `#include` kullanılıyor. Bu hata giderilmiş görünüyor.

**Hüküm:** OK.

---

### 4.2 AST JSON / harness ayrımı

**Beklenen:** Test harness dosyaları doğrudan uXBasic kaynak gibi parse edilmemeli. `--extract-src` ile iç `src` string’i çıkarılmalı.

**src17 durumu:** `main.bas` içinde `--extract-src`, `IsHarnessSource`, `ExtractInnerSource`, debug çıktıları ve harness tespiti var. Bu iyi bir düzeltme.

**Kalan risk:** Önceki bağlamda AST/parser regression hâlâ geçmiyor olabilir. Bu dosya düzeyinde düzeltilmiş görünse de test kanıtı olmadan OK yazılmamalı.

**Hüküm:** PARTIAL/TEST GEREKİR.

---

### 4.3 `classSize <= 0 Then classSize = 8` tehlikeli fallback’i

**Beklenen:** Bu fallback kaldırılmalı, class layout yoksa hata verilmeli.

**src17 durumu:** `classSize = 8` kalmadı. `code_generator.fbs` içinde `classSize <= 0` durumunda artık hata dönülüyor:

```text
x64-codegen: unresolved class layout
```

Runtime class allocation tarafında da `classSize <= 0` hata dönüyor.

**Hüküm:** OK.

---

### 4.4 `__vptr` anlamı: classIdx mi, vtable handle mı?

**Beklenen:** Interpreter/runtime tarafı `objectBase` başına class index yazmamalı; runtime vtable handle yazmalı.

**src17 durumu:**

- `vtableClassHandles()` ve `vtableNextHandle` eklenmiş.
- `ExecBuildVTableMap` başında handle sistemi resetleniyor.
- Handle başlangıcı `&h1000`, her class için +8 ilerliyor.
- `ExecConfigureClassStorage` ve `ExecAllocClassInstance` içinde `VMemPokeD(objectBase, CInt(vtblHandle))` kullanılıyor.
- `VMemPokeD(objectBase, classIdx)` kaynakta yok.

**Kalan risk:** `ExecResolveRuntimeClassByObjectAddr` içinde geriye uyum için “hval classIdx gibi görünüyorsa” fallback hâlâ var. Bu eski nesneler için tolerans olabilir; ama uzun vadede strict mode ile kaldırılmalı.

**Hüküm:** 8A-3 ana hedefi büyük ölçüde OK; fallback nedeniyle PARTIAL/compat notu bırakılmalı.

---

### 4.5 Receiver runtime class çözümü

**Beklenen:** Method dispatch sırasında receiver adresinden object header okunmalı, vtable handle ile runtime class çözülmeli.

**src17 durumu:** `exec_call_dispatch_helpers.fbs` içinde receiver adresinden `VMemPeekD` ile header okunuyor, `ExecFindRuntimeVTableClassByHandle` ile runtime class çözülüyor ve `receiverType` bununla güncelleniyor.

**Kalan risk:** Bu çözüm AST runtime call path için iyi; MIR/x64 tarafında tüm virtual callsite’ların aynı güvenceye sahip olduğu testle ispatlanmalı.

**Hüküm:** PARTIAL/PASS.

---

### 4.6 x64 vtable label merkezi helper

**Beklenen:** `className & "_VTBL"`, `declTypeName & "_VTBL"`, `classTypeName & "_VTBL"` gibi elle string üretimi kalmamalı.

**src17 durumu:**

- `X64ClassVTableLabel` var.
- Emit tarafında `vtblLabel = X64ClassVTableLabel(className)` kullanılıyor.
- `NEW_EXPR` ve `DIM class default allocation` içinde `X64ClassVTableLabel(...)` kullanılıyor.
- `_VTBL` aramasında eski `CLASS_VTBL` üretimi görünmüyor; sadece `__uxb_vtbl_` helper ve null-vtable label isimleri var.

**Hüküm:** 8A-4 OK.

---

### 4.7 x64 virtual call null kontrolleri

**Beklenen:** receiver null, vtable null, slot null kontrolleri olmalı.

**src17 durumu:** `code_generator.fbs` virtual call hattında:

```asm
test rcx, rcx
jz vcall_null_obj
mov rax, [rcx]
test rax, rax
jz vcall_null_vtbl
mov r11, [rax + slot*8]
test r11, r11
jz vcall_null_slot
call r11
```

**Kalan risk:** Slot sınır kontrolü ve signature guard görünmüyor. Debug/diagnostic kalitesi artırılmalı.

**Hüküm:** PARTIAL/PASS.

---

### 4.8 `__VT_SLOT__` string hack’i

**Beklenen:** Uzun vadede gerçek `MIR_CALL_VIRTUAL receiver, slot, signature` opcode’una dönülmeliydi.

**src17 durumu:** `__VT_SLOT__:` hâlâ `semantic/mir.fbs` ve `semantic/mir_evaluator.fbs` içinde var.

**Hüküm:** MISSING/DEBT. Bu 8A’da belki tolere edilebilir; ama 8B öncesi teknik borç olarak işaretlenmeli.

---

### 4.9 Operator overload

**Beklenen:** 8A kapsamı temizlikse operator overload genişletmesi 8B’ye bırakılmalı veya flag arkasına alınmalıydı.

**src17 durumu:** Static grep düzeyinde kesin operator overload kapanışı doğrulanmadı; codegen içinde hâlâ TODO/unsupported expression noktaları var. Magic method/operator overload tam kapanmış sayılmamalı.

**Hüküm:** 8B’ye devreden alan.

---

## 5. Açık büyük eksiklikler

### 5.1 Test kanıtı eksikliği

Bağlamdaki rapora göre hızlı testlerde:

```text
class ctor testi: PASS
inheritance virtual testi: FAIL / duplicate routine
class new expression testi: FAIL / parse hatası
```

Bu iki fail kapanmadan OOP sistemi OK sayılamaz.

### 5.2 Inheritance / duplicate routine hatası

`CLASS Base` + `CLASS Child EXTENDS Base` zincirinde duplicate routine hatası raporlanmış. Bu genellikle şu sorunlardan biridir:

```text
base method ile child override aynı global routine registry’ye çakılıyor
class namespace ayrımı eksik
override ile duplicate ayrımı eksik
method signature key sadece isimden oluşuyor
ownerClass + methodName + signature kullanılmıyor
```

**Durum:** Kritik açık.

### 5.3 `NEW` expression parse hatası

`NEW` statement/default allocation çalışıyor olabilir; fakat `x = NEW A()` veya `DIM x AS NEW A()` gibi expression biçimleri parser’da hâlâ sorunlu olabilir.

**Durum:** Kritik açık.

### 5.4 AST JSON hattı kesin geçiş kanıtı yok

`--extract-src` eklenmiş olsa da test runner ile şu komutların kesin geçtiği gösterilmeli:

```text
uxbasic_cli.exe gerçek_kaynak.uxb --ast-json-out out/ast.json
uxbasic_cli.exe harness.bas --extract-src --ast-json-out out/ast.json
```

**Durum:** Test bekliyor.

### 5.5 Unsupported/TODO kalıntıları

`src17` içinde hâlâ şu kalıntılar var:

```text
TODO: unsupported binary op
TODO: expression kind
TODO: emit node kind
mir: unsupported binary op
mir: unsupported expr kind
exec: unsupported statement kind
x64-codegen: unsupported statement in GenerateStatement
x64-codegen: unsupported assignment operator
metadata-only for x64 emit
slot lane native noop
```

Bunlar Hamle 8A’nın “coverage temizleme” amacına göre hâlâ açıktır.

### 5.6 EVENT/THREAD/PARALEL/PIPE/SLOT lane

Parser/semantic yüzeyi var; fakat MIR/x64 tarafında gerçek çalışma yerine no-op veya metadata-only davranış sürüyor.

**Durum:** 8A’da OK yazılamaz; 8B/sonrası iş.

### 5.7 LIST/DICT/SET parity

AST/runtime tarafında koleksiyon builtinleri var. Ancak MIR/x64 lane tam değil. Bu nedenle koleksiyonlar gerçek native parity kapsamında kapalı değildir.

**Durum:** PARTIAL.

### 5.8 CALL(API) lane

AST/exec builtin tarafında `CALL(API)` var. MIR/x64 tarafında eşdeğer lane eksik görünüyor.

**Durum:** PARTIAL/MISSING.

### 5.9 INPUT parity

INPUT native lane büyük ölçüde I32 odaklı. String/float ve tip varyantları tam kapanmış görünmüyor.

**Durum:** PARTIAL.

### 5.10 F80

F80 token/type yüzeyi var; ancak MIR tarafında `F80 arithmetic not supported` diagnostic üretiyor. Bu doğru bir davranış olabilir, ama F80 destekleniyor diye işaretlenmemeli.

**Durum:** Diagnostic varsa OK sayılabilir; hesaplama desteği MISSING.

### 5.11 x64 parity açıkları

x64 codegen büyümüş ve çok şey destekliyor; ancak hâlâ:

```text
unsupported binary op
unsupported assignment operator
unsupported statement
metadata-only node
float compound eksikleri
array/type/class indexed edge-case açıkları
```

var.

**Durum:** PARTIAL.

---

## 6. Hamle 8A açısından durum

Hamle 8A’nın doğru tanımı:

```text
Hamle 8A — Hamle 1–7 Kapanış Borçları ve Coverage Temizleme
```

Bu tanıma göre `src17`:

| Alt iş | Durum | Not |
|---|---|---|
| `#include` / `%%INCLUDE` ayrımı | OK | PreprocessHashIncludes yok |
| Harness/source ayrımı | PARTIAL | Kod var, test kanıtı gerekir |
| `classSize=8` fallback kaldırma | OK | Hata dönüyor |
| `__vptr` handle tekleştirme | PARTIAL/PASS | Ana düzeltme var, compat fallback duruyor |
| x64 vtable label merkezi helper | OK | Eski `_VTBL` üretimi yok |
| x64 virtual call null guard | PARTIAL/PASS | Null guard var; slot/signature guard eksik |
| TODO/unsupported temizliği | FAIL/PARTIAL | Birçok kalıntı var |
| Test matrisi geçişi | UNKNOWN/FAIL | Bağlamda inheritance ve NEW parse fail var |
| Doküman/coverage güncelleme | UNKNOWN | Test geçmeden OK yazılmamalı |

---

## 7. Mimari risk sınıflandırması

### A. Kırıcı hatalar

1. `NEW` expression parse hatası.
2. Inheritance/virtual dispatch duplicate routine hatası.
3. AST JSON/harness regression kesin doğrulanmamış.
4. x64 unsupported statement/expression fallbackleri.

### B. Derin mimari borçlar

1. `__VT_SLOT__` string hack’i gerçek MIR opcode değil.
2. `code_generator.fbs` aşırı büyük ve 8C’de parçalanmalı.
3. Semantic method key sistemi muhtemelen owner/signature tabanlı değil.
4. Interface typed dynamic dispatch tam değil.
5. LIST/DICT/SET sadece AST/exec düzeyinde güçlü, MIR/x64 eşit değil.

### C. Belgeleme / coverage drift

1. F80 yüzeyde var ama hesaplama yok.
2. EVENT/THREAD/PARALEL/PIPE/SLOT parser’da var ama runtime/native no-op.
3. API/DLL yüzeyleri eşit seviyede değil.
4. Bazı yorumlar gerçek kodla uyumsuz olabilir.

---

## 8. Önceliklendirilmiş yapılacaklar

### Öncelik 1 — Test kapısı

Aşağıdaki testler geçmeden coverage’da OK yazılmamalı:

```text
parse/json
semantic
AST runtime
MIR runtime
x64 emit
x64 build
x64 run
çıktı karşılaştırma
```

### Öncelik 2 — OOP kırıkları

1. Duplicate routine root cause bulunacak.
2. Method key sistemi `ownerClass + methodName + signature` haline getirilecek.
3. Override ile duplicate ayrılacak.
4. `NEW` expression parser düzeltilecek.
5. Base reference → derived override testi geçirilecek.

### Öncelik 3 — 8A TODO/unsupported temizliği

Şunlar tek tek kapatılacak veya bilinçli diagnostic’e çevrilecek:

```text
unsupported binary op
unsupported expr kind
unsupported statement
unsupported assignment operator
metadata-only for x64 emit
native noop slot lane
```

### Öncelik 4 — MIR model temizliği

`__VT_SLOT__` string encoding geçici olarak çalışsa bile 8B’ye geçerken gerçek opcode yapılmalı:

```text
MIR_CALL_VIRTUAL receiver, slotIndex, signatureId
MIR_CALL_MAGIC receiver, magicKind, args
```

### Öncelik 5 — 8C hazırlığı

`code_generator.fbs`, `mir.fbs`, `mir_evaluator.fbs`, `memory_exec.fbs` modülerleşmeye hazırlanmalı. Ancak 8A bitmeden büyük parçalama yapılmamalı.

---

## 9. Son hüküm

`src17`, `src13/src16` çizgisine göre belirgin şekilde daha doğru ve temizdir. Özellikle şu eski büyük problemler düzelmiş görünmektedir:

```text
# include / %%INCLUDE karışıklığı
classSize=8 tehlikeli fallback’i
interpreter classIdx header yazımı
x64 vtable label dağınıklığı
x64 virtual call null kontrol eksikliği
```

Fakat `src17` hâlâ Hamle 8A kapanışı değildir. En ciddi kalanlar:

```text
inheritance duplicate routine FAIL
NEW expression parse FAIL
AST JSON/harness test kanıtı eksik
TODO/unsupported kalıntıları
MIR/x64 parity açıkları
LIST/DICT/SET MIR/x64 eksikliği
CALL(API) MIR/x64 eksikliği
INPUT string/float parity eksikliği
__VT_SLOT__ string hack teknik borcu
```

Bu nedenle güvenli karar:

```text
src17 = güncel çalışma tabanı
8A-3 = büyük ölçüde uygulanmış
8A-4 = uygulanmış
8A = henüz kapanmadı
8B’ye geçmek için önce duplicate routine + NEW parse + test gate düzelmeli
```
