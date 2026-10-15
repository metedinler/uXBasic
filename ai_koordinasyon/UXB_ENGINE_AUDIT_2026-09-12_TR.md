# uXBasic motor denetimi — 2026-09-12

## Sonuç

“Altı ayrı motor” ifadesi altı eşit, son kullanıcıya sunulan semantik çalışma
zamanı anlamına gelmiyor. Kaynak ve gerçek çalıştırma kanıtı şu ayrımı veriyor:

1. AST yorumlayıcı: gerçek CLI yürütme yolu.
2. Canonical-MIR yorumlayıcı: gerçek, ayrı CLI yürütme yolu.
3. MIR tabanlı x64: gerçek native assembly üretim ve build yolu (build şu an
   çıktı-dizini/CWD kusurlarıyla tamamlanamıyor).
4. AST-direct x64: gerçek, seçilebilir uyumluluk assembly üretim yolu; bazı
   yüzeylerde güvenli değil.
5. `src/semantic/mir_evaluator*.fbs`: derleyiciye dahil edilmiş semantic-MIR
   reference/test evaluator. Kaynak `src` ağacında `MIRRunModule` için yalnız
   tanım var; 19 çağrı iddiası eski kopya/rapor ağaçlarından geliyor. Küme
   derleniyor ve yardımcıları canlı olabilir, ancak son kullanıcı CLI motoru
   olduğu kanıtlanmış değil. Silme kararı verilmemeli.
6. `src/interpreter/interpreter_public_api.fbs`: AST ve MIR public wrapper/API
   sözleşmesi. Kaynak `src` ağacında wrapper başına yalnız tanım bulundu; ana
   CLI doğrudan bu wrapper'ları değil, AST için `ExecRunMemoryProgram` ve MIR
   için `UXBMIRInterpRunInstructions` çağırıyor. API/reference rolü var;
   bağımsız ürün motoru sayılmamalı.

JS, WAT, WASM ve browser ise 1–4'ün semantiğini yeniden tanımlayan motorlar
   değil, web backend/emitter ve host-runtime hedefleridir. JSON/CSV dosyaları da
   motor değildir; derleme, tanı ve kanıt çıktılarıdır.

## Gerçek yürütme matrisi

| Özellik / yol | AST yorumlayıcı | Canonical MIR yorumlayıcı | MIR-x64 emit | AST-x64 emit | JS/Node | WAT/WASM |
|---|---:|---:|---:|---:|---:|---:|
| Scalar/PRINT (`mir_x64_builtin_scalar.bas`) | PASS | PASS | PASS + NASM | PASS + NASM | emit PASS, Node **ABS host binding** hatası | stringli örnek fail-close |
| ANDALSO/ORELSE + `&&/||` | PASS | PASS | PASS + NASM | — | PASS + Node | emit PASS, `wat2wasm` WAT syntax FAIL |
| PEEK/POKE temel vektörü | PASS | PASS | **FAIL: unsupported width** | PASS + NASM | web surface yok/host yolu | native memory web dışı |
| LIST/DICT/SET gerçek işlemleri | PASS (`2,20,42,1`) | PASS (`2,20,42,1`) | **FAIL: LIST_NEW hedefi yok** | emit PASS ama `call listadd/listlen/...` unresolved | emit PASS, Node **LIST_NEW host binding** hatası | string literal nedeniyle fail-close |
| LIST `FOR EACH` / `DO EACH` + index | PASS (`0:10..2:30`) | **FAIL: LIST dizi sanılıyor** | aynı MIR build FAIL | aynı MIR build FAIL | aynı MIR build FAIL | doğrulanmadı |
| `REDIM PRESERVE` static I32 array | PASS (`22,27,27,33,44`) | **FAIL: array index cannot be written** | **FAIL: element type ARRAY** | emit + NASM; run kanıtı yok | ölçülmedi | doğrulanmadı |
| OOP yalın `NEW` + alan | PASS (`33`) | PASS (`33`) | emit + NASM | emit + NASM | PASS + Node (`33`) | doğrulanmadı |
| OOP kalıtım / virtual override | AST direct örnekte PASS (`42,7`); base-reference atama reddi | **FAIL: `__VT_SLOT__` hedefi yok**; base-reference atama reddi | emit var, run kanıtı yok | `END_STMT` desteklenmiyor | **FAIL: VIRTUAL_CALL slot değil** | doğrulanmadı |
| Tipli TASK/THREAD/PARALEL gövdeleri | PASS | PASS | emit PASS + NASM | emit PASS + NASM | Node **SLOT_DEF host binding** hatası | doğrulanmadı |
| Shell OUTVAR/CODEVAR | PASS | PASS | emit PASS + NASM (`uxb_shell_run`) | — | Node **SHELL_OUTVAR host binding** hatası | doğrulanmadı |
| Bilerek geçersiz tip ataması | semantic hata | `--execmem` semantic hata | semantic hata | semantic hata | — | — |

Önemli ayrım: `PASS` yazan x64 assembly raporu yalnız assembly üretildiğini
gösterir. AST-direct koleksiyon assembly'si NASM'de çözülemeyen semboller içerir;
bu nedenle emit PASS native çalıştırma kanıtı değildir. Native EXE build'leri
ise hem AST hem MIR için şu iki bağımsız kusurdan birinde durdu:

- `src/build/x64_build_pipeline.fbs:8-20,42+` parent dizinlerini recursive
  oluşturmadan `Open ... For Output` yapıyor; nested `--out-root` yolunda ilk
  dosya yazımı “file not found” ile duruyor.
- `X64BuildFindRuntimeImportLib` (`:133-137`) runtime import kütüphanesini
  yalnız çalışma dizinine göre arıyor. CWD workspace olduğunda repo içindeki
  `native/uxb_runtime/build/libuxb_runtime.dll.a` bulunamıyor.

## Kanıtlanan gerçek sorunlar

### S-020 — AST/MIR `BOTH` karşılaştırması yanlış negatif üretiyor

`src/interpreter/interpreter_execution_artifacts.fbs:62-99` ham string ve iç
metadata karşılaştırıyor. AST `stdout` CRLF, MIR LF üretiyor; AST sonuç türü
`AST_RUNTIME`, MIR `F64`; AST dönüşü `PASS`, MIR dönüşü `0`. Aynı gözlemlenebilir
program çıktısı için bile `interpreter_compare.json` şu alanları false yazıyor:
`stdout_match`, `program_output_match`, `result_type_match`,
`return_value_match`, `status=FAIL`. `both_memory_probe` ve `both_logic_probe`
ile tekrarlandı. Karşılaştırma, satır sonlarını normalize etmeli ve wrapper
metadata'sını semantik sonuçtan ayırmalıdır.

### S-021 — MIR memory width operandı yanlış biçimde lower ediliyor

`src/semantic/mir_lower_expr.fbs:35-39,940-946` ve
`src/semantic/mir_lower_stmt.fbs:471` genişliği literal olarak değil
`MIR_LOAD_CONST` temporary (`__t3`, `__t5`) olarak yazıyor. MIR interpreter
operand state'ten bunu çözebiliyor; `src/codegen/x64/mir_x64_runtime_emit_helpers.fbs:122-141`
ise `Val(operand)` ile literal bekliyor ve `MIR x64 memory store/load:
unsupported width` veriyor. Çözüm ya lowering'de width'i literal yapmak ya da
x64 emitter'a güvenli sabit-operand çözümleyici eklemek; interpreter sözleşmesi
bozulmamalı.

### S-022 — JS yerleşik çağrı köprüsü kullanılmıyor

`src/codegen/js/js_stmt_emit.fbs:145-152` içinde `UXBJsEmitRuntimeBuiltin`
ABS/SQR/LEN vb. için doğru gömülü runtime çağrısını tanımlıyor; kaynak taraması
bu fonksiyonun çağrılmadığını gösteriyor. `js_expr_emit.fbs:89` `MIR_CALL`ı
`CALL`a çeviriyor, `UXBJsEmitCall` varsayılanı `ux.callHost(...)` yayıyor.
Gerçek Node smoke `UXB host binding missing: ABS` verdi. Yerleşik adlar önce
gömülü `ux.builtin` tablosuna yönlendirilmeli; yalnız bilinmeyen çağrılar host'a
gitmeli. `CLNG`/`FIX` için gömülü semantik ayrıca ortak cast sözleşmesine
bağlanmalı.

### S-023 — WAT memory yardımcıları sentaks olarak geçersiz

`src/codegen/wasm/wat/wat_memory.fbs:8-50` load/store/fill yardımcılarında
eksik kapanış parantezleri ve yürütülebilir komuttan sonra local bildirimi var.
Sayısal, string içermeyen WAT çıktısı bile repo `tools/wabt/bin/wat2wasm.exe`
ile `unexpected token (, expected )` veriyor. Elle düzeltilmiş workspace kopyası
parse oldu; bu kaynak kusurunun doğrudan kanıtıdır. Bu nedenle şu an geçerli
WASM binary üretimi kanıtlanmış değildir.

### S-024 — `mir` verb'i semantic gate'i atlayabiliyor

`src/main_program_entry.fbs:776-782` `runSemanticPass` koşuluna
`mirVerifyRequested` dahil değil. `src/cli/cli_verb_dispatch.fbs:90` `mir`
yalnız `--mir-verify` ve `--codegen-source MIR` ekliyor. Sonuç olarak bilerek
geçersiz `I32` değişkene STRING ataması `uxb mir` ile exit 0, canonical verify
PASS ve `semantic=false` manifesti alırken `--execmem --interpreter-backend MIR`
semantic hata veriyor. `mir` verb'i ya semantic'i zorunlu kılmalı ya da rapor
adında açıkça “structural-only MIR” demelidir.

### S-025 — `x64-mode BOTH` textual assembly karşılaştırması anlamsız

`src/backend/compare/backend_output_compare.fbs:163-205` AST ve MIR assembly
metnini eşitlik için karşılaştırıyor. İki emitter farklı mimari/yardımcı düzeni
kullandığından scalar örnekte normalized uzunluklar yaklaşık 37.9K ve 5.2K;
rapor `status=FAIL`, ana CLI ise yalnız uyarı ile exit 0. Bu kapı assembly
eşitliği değil, iki çalıştırılmış EXE'nin gözlemlenebilir vektör eşitliğini
ölçmelidir.

### S-026 — WAT hedef adı/CLI normalizasyonu tutarsız

`src/backend/backend_web_cli_args.fbs` `--emit-wat` isteğini target
`wasm`a normalize ediyor; pipeline'daki WAT dalı CLI'da fiilen ayırt edilmiyor.
WAT/WASM raporları ve kullanıcı belgeleri tek bir açık hedef sözleşmesine
bağlanmalı.

### S-027 — web MIR “passed” alanı gerçek yürütme değil

`src/main_program_entry.fbs:1190-1192` `webCli.mirInterpreterPassed = 1` sabit
atanıyor. Web backend MIR gate'i ve emitter'ı çalıştırıyor, fakat MIR
interpreter'ı gerçekten yürüttüğünü kanıtlamıyor. Manifest alanı `passed` yerine
`verified/gated` olarak ayrılmalı veya gerçek MIR smoke eklenmeli.

### S-028 — preprocessor `--out-root` sözleşmesini ihlal ediyor

`src/preprocessor/preprocess_engine.fbs:114-115` varsayılan sonucu sabit
`build\\manual\\json\\frontend\\preprocess\\preprocess_result.json` yoluna
yazıyor; `--out-root` contract path'i dikkate alınmıyor. Bu semantik motor
değil, çıktı-izolasyonu ve paralel test güvenilirliği kusurudur. Ancak etkisi
artık yalnız native build ile sınırlı değildir: bu turda S-014'ün güncel
vektörü AST ve canonical-MIR için varsayılan yolda önce eksik
`build/.../runtime_route_matrix.json` diziniyle, `--out-root` verildiğinde ise
preprocessor'ın sabit `build/manual/...` diziniyle durdu. Yani S-028 çözülene
kadar taze interpreter, x64 ve release kabul koşuları güvenilir biçimde
başlatılamaz; tarihsel PASS kayıtları güncel ölçüm yerine geçmez. Yan etki
olarak FFI allowlist varsayılanı da sabit, CWD-bağımlı
`build/manual/config/ffi_allowlist.txt` yoludur. Denetim scratch alanında bu
dizin elle oluşturulunca S-014 AST'te işlevsel `etiket=` ve `42` değerini
üretti, fakat araya `REPORT_ONLY` FFI uyarıları girdi; canonical MIR aynı
vektörde temiz `etiket=42` verdi. Böylece S-014 semantiği AST/MIR için mevcut,
ama temiz ve tekrar üretilebilir test çıktısı hâlâ CWD'ye bağlıdır.

### S-029 — native ABI'de PARALLEL kalıntısı canlı

Canonical surface verifier üç hata raporluyor:
`src/runtime/native/(eski)uxb_runtime_abi.bar.fbs:73`,
`src/runtime/native/uxb_runtime_abi.fbs:30` ve
`src/runtime/native/uxb_runtime_loader.fbs:46`. Native DLL `uxb_parallel_run`
export ediyor; yani “PARALLEL tamamen kaldırıldı” iddiası native ABI için doğru
değil. Dil yüzeyinde yazımın `PARALEL` (tek L) olması ayrı bir tutarsızlıktır.

### S-030 — typed görevler gerçek asenkron/oneTBB yolu değil

`src/semantic/mir_lower_slot_lane.fbs` typed `TRIGGER_STMT`yi doğrudan
`__SLOTLANE_*` fonksiyon çağrısına indiriyor. `src/codegen/x64/mir_x64_task_shell.fbs`
ve `code_generator.fbs` içindeki native trigger/oneTBB ABI bu typed yoldan
geçilmiyor. AST/MIR ve NASM smoke PASS olsa da typed `PARALEL` senkron,
ordinary-call semantiğinde; gerçek thread/pipe/parallel davranışı değildir.
Untyped slot testleri ayrıca MIR'de `RT_LIBRARY_CALL`, x64'te slot binding ve
JS'de `SLOT_DEF` host binding hataları veriyor.

## PATCH-1…5 için güncel kabul durumu

Arşivdeki PATCH README'leri, kaynak dosya izleri ve eski test sonuçları **kabul
kanıtı değildir**. PATCH-4 ve PATCH-5 kendi metinlerinde Windows/FreeBasic,
NASM ve browser doğrulamasının çalıştırılmadığını açıkça söyler. Aşağıdaki
durum, bugünkü kaynak ve canlı smoke'lara dayanır.

| Paket | Bugünkü kanıt | Kabul kararı |
|---|---|---|
| PATCH-1/2 (OOP/MIR/ABI) | Basit normal fonksiyon çağrısı AST ve canonical MIR'de `25`; yalın sınıf alanı AST/MIR/JS'de `33` ve iki x64 emitter'da NASM'lenebilir assembly üretir. Kalıtım, constructor ve sanal çağrı rotaları ise kırık. | Kısmi; “tamamlandı” denemez. |
| PATCH-3 (memory ABI) | AST/MIR `PEEK/POKE` çalışır; MIR-x64 width temporary yüzünden kırılır (S-021). | Kısmi. |
| PATCH-4 (array/memory) | `SIZEOF(array)` AST/JS/MIR-x64 düzeyinde kısmen çalışır; canonical MIR'de yürütülemez. Array `MEMCOPYD` AST'de sessizce sıfır kopyalar, MIR/MIR-x64 kırılır. | Kısmi ve kritik regresyonlu. |
| PATCH-5 (iterator) | Statik array `EACH` AST, canonical MIR, iki x64 assembly emit ve JS/Node'da çalışır; fakat önerilen canonical iterator ABI canlı kaynakta yoktur. | Sadece dar static-array yolu kabul edilebilir. |

### S-031 — PATCH-5'in kanonik iterator ABI'si canlı kaynakta yok

Canlı `src` altında `MIR_ITER_CREATE`, `MIR_ITER_NEXT` ve `MIR_ITER_CLOSE`
sembollerinin hiçbiri bulunmadı. `src/common/iterator_contract.fbs` yalnız
kind sabitlerini ve `UXBIteratorKindKnown` doğrulamasını içeriyor;
`src/semantic/iterator_lowering.fbs` ise static array'i doğrudan
`MIR_ARRAY_LOAD` + karşılaştırma/jump dizisine indiriyor. Bu yüzden
`array_each_probe` bugün çalışsa da LIST/DICT/SET, dinamik array, STRING,
class/interface iterator sözleşmesi uygulanmış değildir. PATCH-5 paketi ayrıca
`js_stmt_emit.fbs` içinde üç kez yinelenmiş `ITER_CREATE/NEXT/CLOSE` dalları
içeriyor; paketi körlemesine overlay etmek doğru çözüm değildir.

### S-032 — Function-local array bağlama/atama yolu kırık

`FUNCTION` içinde `DIM a(1 TO 3) AS I32` sonra `RETURN a(1)` içeren kaynak
AST ve canonical MIR doğrulamasını geçiyor; fakat `mir-full-json` diziyi local
değil module-global `A`, `local_count=0` olarak kaydediyor. Aynı local diziye
`a(1)=10` ile yazma AST ve MIR semantic aşamasında `assign: left side is not
writable: CALL_EXPR` hatasıyla reddediliyor. Bu nedenle local array index
lower-bound davranışı henüz test edilebilir değildir. `x64_codegen_indexed_access.fbs`
local erişimde lower-bound çıkarımı yapmadığı için ayrıca bir statik adaydır;
önce bağlama/atama kusuru düzeltilip çalıştırılmış test yazılmalıdır.

### S-033 — `MIR_MEMORY_REF` opcode imzası ile lowering çelişiyor

`src/semantic/mir_opcode_signature.fbs:96-99`, `MIR_MEMORY_REF` ikinci
operandını `MIR_OPR_VAR` olarak tanımlar. Buna karşılık
`src/semantic/memory_ref_lowering.fbs:48` literal `ARRAY` ve dizi adını
üretir. Bu, PATCH-4'ün array memory-ref tasarımını doğrulayan bir yol değil;
verifier/consumer sözleşmesini kıran doğrudan bir uyumsuzluktur.

### S-034 — Step-4 özel MIR verifier kümesi derleniyor ama çağrılmıyor

`UXBMIRStep4VerifyTypes`, `TargetSupport`, `Operands`, `NoUnknown`, `Memory`,
`ControlFlow`, `Calls` ve `Blocks` sembollerinin her biri canlı `src` içinde
yalnız tanımında bulundu; `main_canonical_mir_include_bundle.fbs` ile
derleniyorlar, fakat orkestrasyon çağrısı yok. Sonuç olarak `--mir-verify`,
memory probe'un `MIR_MEMORY_STORE AUTO,__t1,__t2,__t3` ve
`MIR_MEMORY_LOAD AUTO,__t4,__t5` temporary width operandlarını PASS sayıyor.
`mir_verify_memory.fbs` ise `Val(operand)` ile literal width beklerdi. Bu
katman hemen bağlanmamalı: önce temporary-değer sözleşmesini destekleyecek
şekilde birleştirilmeli, sonra gerçekten gate'e bağlanmalıdır.

### S-035 — `REDIM PRESERVE` canonical MIR ve MIR-x64'te çalışmıyor

`tests/probes/runtime_mir_indexed_array_probe__dup1.bas` AST interpreter'da
beklenen `22,27,27,33,44` çıktısını verir. Canonical MIR `array index cannot
be written`, MIR-x64 ise `unsupported array element type ARRAY` ile durur.
AST-direct x64 assembly üretip NASM'den geçse de generic native build hattı
ayrıca bozuk olduğundan yürütme kanıtı değildir. Eski belgelerdeki “AST/MIR/
native tamam” kaydı güncel kabul olarak kullanılamaz.

### S-036 — `SIZEOF(array)` ve array `MEMCOPYD` rotalar arasında eşdeğer değil

`PRINT SIZEOF(a)` için AST interpreter `12`, JS/Node `12`, MIR-x64 sabit
assembly üretir; canonical MIR `MIR memory opcode not executable:
MIR_ARRAY_SIZEOF` der. AST-direct x64 ise `call SIZEOF` üretip NASM'de tanımsız
sembolle kalır. `MEMCOPYD source,target,3` AST'de hata vermeden `0,0,0`,
canonical MIR'de `MIR_MEMORY_REF` yürütülemez, MIR-x64'te `unsupported width`
verir; yalnız JS/Node `10,20,30` verir. Bu, sessiz yanlış sonuç içerdiğinden
PATCH-4 içindeki en yüksek öncelikli kabul engellerinden biridir.

### S-037 — OOP yüzeyi yalın alan erişimi dışında rota-eşdeğer değil

Yalın `CLASS BOX / DIM b AS BOX = NEW BOX() / b.X=33` smoke'u AST,
canonical MIR ve JS/Node'da `33` verir; AST-direct ve MIR-x64 assembly'leri de
NASM'den geçer. Bu, OOP temelinin bütünü değil, yalnız dar field/new yolunun
kanıtıdır. Buna karşılık:

- `B EXTENDS A` iken `DIM a AS A : a = NEW B`, AST/MIR/x64/JS semantic
  kapısında `assignment cannot convert B to A` ile reddedilir.
- `THIS.x * THIS.x + ME.y * ME.y` kullanan gerçek constructor/method örneği
  tüm rotalarda `numeric operands required` ile semantic aşamada kalır.
- `Dog.Speak()` ve `Cat.Speak()` doğrudan örneklerinde AST `42,7` verir;
  canonical MIR `MIR method target not found: __VT_SLOT__:DOG:0` ile kırılır.
  MIR-x64 assembly üretir, AST-direct x64 `END_STMT` desteklemez, JS ise
  `VIRTUAL_CALL target is not a vtable slot` ile durur.

Dolayısıyla PATCH-1/2 için tek bir “OOP destekleniyor” etiketi yanıltıcı olur.
Kabul matrisi en az field/new, constructor, base-reference assignment,
override/virtual, interface dispatch, delete/destructor sütunlarını ayrı
raporlamalıdır.

### S-038 — P3/P4 koleksiyon `EACH` yalnız AST yorumlayıcıda çalışıyor

Bu turdaki `LIST` vektörü `10,20,30` ile hem `FOR EACH v,i IN l` hem
`DO EACH w,j IN l` çalıştırır. AST interpreter sırasıyla
`0:10, 1:20, 2:30` iki kez üretir; yani Claude'un P3/P4 için söylediği
AST kapsamı bu dar çekirdekte doğrulandı. Aynı kaynak canonical MIR,
MIR-x64, AST-direct x64 ve JS pipeline'larında MIR üretiminde
`array declaration has no bounds: l` hatasıyla durur. Bu fail-close bir
sessiz yanlış sonuç değildir, fakat dört-motor dil sözleşmesi hâlâ ihlal
edilmektedir. S-019 native koleksiyon ABI'si başlamadan önce semantic/MIR
lowering'in `LIST`i array gibi ele alma hatası bağımsız olarak ele alınmalıdır.
Kök neden doğrudan izlenebildi: `iterator_lowering.fbs` her tek `IDENT` için
`UXBFindArrayMemoryInfo` çağırıyor; bu helper `DIM l AS LIST`i dizi olup
olmadığını ayırmadan buluyor ve `DIM_BOUNDS` arıyor. `LIST/DICT/SET` önceden
ayrıştırılıp collection iterator sözleşmesine yönlenmelidir; array discovery
helper'ı scalar collection bildirimleri için `found=0` dönmelidir.

### S-039 — Tarihsel “kapanış” belgeleri güncel kabul raporu olarak yanlış

Arşiv `COMPILER_TODO.md`, H6 OOP parity'sini kapalı ve
`tests/oop/class_constructor_method_runtime` için MIR sonucunu `25` yazar.
Canlı testin bugün AST, canonical MIR ve semantic aşamasında sonucu
`numeric operands required` hatasıdır. Aynı belgenin `native_class_ctor_probe`
için MIR=`7` iddiasına karşılık, güncel kaynak AST=`7`, JS/Node=`7`, canonical
MIR=`0` verir. Native EXE iddiasını yenileme denemesi de `--out-root` verilse
bile preprocessor'ın sabit `build/manual/...` yoluna yazmaya çalışmasıyla
durdu. Bu belgeler silinmeyecek; üstlerine/yanlarına açık “tarihsel snapshot,
güncel kabul değildir” işareti ve canlı acceptance manifest bağlantısı
eklenmelidir.

### S-040 — Tam-coverage aracı `--src` kapsamını korumuyor

`uxb_full_coverage_analyzer.py --src <uxb> --out <workspace>` canlı
denemede 60 saniyeden uzun süre çıktı üretmeden tüm büyük depo ağacını
taramaya yöneldi; kullanıcıya ait iki başlatılmış Python süreci bu nedenle
sonlandırıldı. Kök neden kaynakta açık: `find_project_root` verilen `src`in
üstündeki proje köküne çıkıyor, `iter_source_files(root.rglob("*"))` ise
`docs`, geniş test ağaçları ve PDSX gibi yan içerikleri dışlamıyor. Araç
“source klasörü de verilebilir” sözüne uymuyor. Ya açık include-root/layer
seçeneği eklenmeli ya da varsayılan skip listesine docs, arşiv, vendor ve büyük
test ağaçları alınmalıdır; aksi hâlde bu araç release/audit kapısı olamaz.

### S-041 — FFI denetleyicileri aynı sözleşmeyi denetlemiyor; eski mixed fallback derlenmeye devam ediyor

`tools/tests/verify_deep_fix_patch.py`, güncel kaynakta `29 PASS / 9 FAIL`
ile bitti. Bunun dokuzunun tamamı gerçek bir ABI-131 gerilemesi değildir:
betik ABI sürümünü ve eski hata metinlerini tam olarak `120` bekliyor. Aynı
çalışma ağacındaki ABI-131 odaklı güncel
`tools/tests/verify_ffi_contract_patch.py` ise 22/22 statik denetimi PASS
saydı; parser, semantic, AST/MIR bridge, x64 gate, opaque token ve STRPTR
snapshot sözleşmeleri bu kapıda tutarlı.

Fakat eski betiğin işaret ettiği bir bakım riski gerçektir.
`exec_ffi_runtime.fbs` içindeki el-yazısı `ExecX64DispatchMixedInvoke`
fallback bloğu hâlâ derlenmektedir. Bugün `ExecFfiBridge10Invoke`, `uxffi.dll`
yoksa/eskiyse/invoke export'u yoksa fail-close hata ile döndüğü için o bloğa
ulaşılmaz; bu nedenle mevcut davranışta token güvenliğini bypass ettiği
kanıtlanmadı. Yine de bridge'in `invokedOut=0` döndürmesine izin veren küçük
bir değişiklik bu yolu tekrar canlı yapabilir. Fallback, çağrı grafiği ve ABI10
runtime vektörü tamamlandıktan sonra silinmeli ya da derleme-zamanı
ulaşılmazlığı açık bir invariant/test ile korunmalıdır.

Native FFI token testinin önceden üretilmesi beklenen
`build/tests/ffi_contract/uxb_ffi_token_test.dll` bu checkout'ta yok. Bu
yüzden mevcut `test_uxffi_contract.py` gerçek DLL roundtrip'ine başlayamıyor.
Statik PASS, native runtime acceptance değildir; S-028 sonrası test DLL'si
yalnız denetim çıktısı altında üretilip AST, MIR ve x64 rotasında çalıştırılmalıdır.

### S-042 — JS runtime'ın “kaynak” ve emitter'a gömülü kopyası ayrışmış

`src/codegen/js/runtime/js_runtime_embedded_generated.fbs` üst bilgisinde
`runtime/js/common/ux_runtime_core.js`den üretildiğini söyler; iki dosyanın
tam satır denetimi bunu doğrulamadı. Core 404 satır, gömülü runtime 447
çalışma-zamanı satırı içeriyor; core'dan 29 satır eksik, gömülü tarafta 66
fazla satır var. Bu yalnız biçim farkı değildir:

- Gömülü sürüm lower-bound'lu `arrayNew/arrayResize` ve class/vtable/method
  yardımcılarını taşırken core sürümünde bunlar yoktur.
- Core sürümündeki `MIR_MEMORY_REF` için array-backed `load/store/fill`
  yolları gömülü sürümde yoktur.

Gerçek JS emitter `js_runtime_writer.fbs` üzerinden gömülü sürümü kullanır.
Bu nedenle core dosyasında yapılan Node/syntax ya da yüzey testi, üretilmiş
uXBasic JavaScript'inin sözleşmesini tek başına doğrulamaz.
`verify_uxjsruntime_patch.py` PASS olsa da yalnız varlık/sınırlı marker
denetimi yapar; bu sapmayı görmez. Tek kanonik kaynak seçilmeli, diğer kopya
deterministik olarak yeniden üretilmeli ve byte/semantic parity denetimi
release gate'e eklenmelidir.

### S-043 — Ortak sorun defterinin açık kalan işi ile güncel kabul kanıtı ayrılmalı

`ai_koordinasyon/SORUN_TAKIP.md` başlık envanteri yeniden okundu. S-001, 002,
005–007, 010–018 `YAPILDI-DOGRULANDI`; S-008 tasarıma göre sorun değildir.
Defterde gerçekten açık kalanlar şunlardır:

- S-003'ün derleyici geçişi kapanmış, fakat kitap/kılavuzlardaki eski
  `INPUT`/`OUTPUT` görev örnekleri için açık bir dokümantasyon turu var.
- S-004 motor mimarisi ve S-009 görev dağılımı hâlâ `KARAR-BEKLIYOR`.
  Kullanıcının dört ana yol için parity talebi bu raporda bağlayıcı kabul
  ölçütü olarak kullanılmıştır; bu, eski katmanların silinmesi/onların
  çağrılmadığı kararı değildir.
- S-019 yerleşik LIST/DICT/SET native desteği `PLAN-HAZIR-INCELEME-BEKLIYOR`.
  S-031/S-038 bu planın ön koşullarının henüz tamamlanmadığını çalıştırılmış
  kanıtla gösterir.

S-014 defterde tarihsel dört-yol PASS olarak kapanmış görünür. Bu turdaki ilk
AST/MIR denemesi S-028 yüzünden başlayamadı; denetim scratch alanında yanlış
sabit dizin elle hazırlanarak yapılan ikinci deneme AST'te işlevsel etiket+42
(FFI uyarılarıyla kirlenmiş), canonical MIR'de temiz `etiket=42` verdi. Böylece
iki yorumlayıcı için taze ama workaround-bağımlı kanıt vardır; iki native EXE
için tarihsel kanıt S-028 düzelmeden yenilenmiş sayılmaz. Aynı workaround ile
MIR-x64 ve AST-direct x64 assembly üretildi ve NASM object'e dönüştü; bunlar
yalnız `emit-only` kanıtıdır. Gelecek acceptance manifesti her sonuca
`tarihsel kanıt`, `taze çalıştırılmış`, `statik`, `emit-only` veya `bloklu`
durumu vermelidir.

## UXGSL için güncel, dar bağımsız tekrar doğrulama

`tests/libraries/uxgsl` içindeki güncel önceden derlenmiş üç smoke EXE, kendi
yanındaki DLL bağımlılıklarıyla 2026-09-12'de yeniden çalıştırıldı:
`UXGSL_BASIC_CALLBACK_SMOKE_PASS`, `UXGSL_BASIC_ROOT_BISECTION_SMOKE_PASS`
ve `UXGSL_COMPLEX_SMOKE_PASS` (üçü de exit `0`). Buna ek olarak mevcut
`bin/uxb.exe` ve 2026-09-10 tarihli `bin/uxgsl.dll` ile, S-028 scratch
workaround'ı altında kaynak `.uxb` dosyaları tekrar derlenip yürütüldü:

- AST: generated scalar-wrapper/error-status smoke PASS. FFI allowlist'in
  CWD-bağımlı varsayılanı yüzünden uyarılar yazdı, fakat sonuç doğruydu.
- Canonical MIR: sahiplik/boyut/alias denetimli matrix smoke PASS.
- Canonical MIR: ham `uxcapi` üzerinden GSL special function, `gsl_vector`
  allocate/set/get/free ve CBlas sembol smoke PASS.
- Canlı `bin/libgsl-28.dll` ve `bin/libgslcblas-0.dll` PE export kataloğu
  yeniden çıkarıldı: toplam 5.685 export, `GetProcAddress` ile eksik `0`.

Bu, callback/bisection/complex facade ile tipli scalar, matrix ve en az bir
ham ABI zincirinin çalışan ikiliyle uyumunu gösterir. Yine de DLL/host bu turda
yeniden derlenmedi, x64 EXE rotası S-028 yüzünden taze çalıştırılmadı ve 5.685
exportun her biri çağrılmadı. Dolayısıyla UXGSL için “güçlü, belgeli ve çok
katmanlı çalışma kanıtı var” denebilir; “her GSL türü ve çağrısı eksiksiz
kanıtlandı” denemez.

## Koleksiyon ve eski katman durumu

- AST ve canonical-MIR `LIST/DICT/SET` gerçek işlemleri çalışıyor.
- MIR-x64 emitter whitelist'te `LIST_NEW`, `LISTADD`, `DICTSET`, `SETADD` ve
  diğer çekirdekler yok; güvenli fail-close var.
- AST-direct x64 aynı yüzeyi sessizce `dq 0` ve tanımsız lower-case `call`
  sembollerine indiriyor; emit raporu PASS olsa da NASM/link aşaması geçmiyor.
- Claude'un S-019 planı bu boşluğu native `uxb_runtime` opaque-handle ABI ile
  kapatmayı öneriyor. Önerilen `0=invalid, slot+1=id` sentinel ABI açısından
  uygundur. `(kind,i64,f64)` yalnız numerik örnek için yeterlidir; STRING/ANY
  için pointer+length veya caller-owned output buffer ve status API gerekir.
- Fatal+exit yalnız iç invariant/UB koruması için kullanılmalı; kullanıcı
  kaynaklı handle/index/key/tür hataları status + tanı ile dönmelidir.
- Existing collection harness'ları (`tests/enum_tests/run_*collection*`) gerçek
  runtime kanıtı değildir: `--extract-src` ile eski `POKED`/eksik parantez
  sentaks hataları veriyor. `07_list_dict_set_surface.bas` ise yalnız
  deklarasyon + PRINT içeriyor; operasyonları sınamıyor.

## Eski/erişilmeyen kod adayları (silinmedi)

Kaynak `src` taramasında:

- `MIRRunModule` yalnız `src/semantic/mir_evaluator_tail_rest.fbs:526` tanımı.
- `UXBRunAstInterpreterPublic` yalnız `src/interpreter/interpreter_public_api.fbs:10`
  tanımı.
- `UXBRunMirInterpreterPublic` yalnız aynı API dosyasında :18 tanımı.
- `src/runtime/memory_exec.fbs:133,156,199` içindeki private
  `MIREvaluatorInit`, `MIRGenerateFromAST`, `MIRExecute` kümesi yalnız kendi
  tanımları/recursive çağrılarıyla görünür; eski küçük evaluator adaydır.

Bu sonuç “kesin sil” değildir. Include zinciri, test harness'ı, external API ve
release araçları ayrıştırılmadan dosya taşınmamalı/silinmemeli. Özellikle
`mir_evaluator*.fbs` PEEK/POKE için `gMirMemLow/gMirMemHigh` tarihsel yolunu
barındırıyor; canonical MIR ise `mir_interp_memory.fbs` + runtime memory service
yolunu kullanıyor. İki yol için regresyon matrisi tamamlanmadan eski yolun rolü
daraltılmamalı.

## RAG/araç bulguları

- Toolchain doctor: FreeBASIC 1.10.1, NASM, MSYS2 UCRT64 gcc/g++ ve extfp DLL'leri
  bulundu; genel toolchain `overall_ok=true`.
- Runtime toolchain doctor: PATH CodeBlocks g++ 14.2, MSYS2 UCRT64 g++ 16.1
  (uv/TBB başlıkları var), mingw64 g++ 16.1 (uv/TBB yok). Karışık include/lib
  kullanımı `quick_exit/timespec_get` türü hatalar doğurabilir; build resolver
  UCRT64'ü önce seçiyor.
- CLI registry: `used=146`, registry `171`.
- Runtime dummy report: 76 servis, 2 deterministic interpreter stub
  (`GETKEY`, `INKEY`), 4 fail-close browser servisi.
- Full-surface heuristic gate: 230 yüzeyden 11 fail; ANDALSO/ORELSE ve shell
  option sonuçlarının çoğu kaynak yapısı nedeniyle yanlış pozitif. PEEK için
  registry generic anahtar eksik, PEEKB/W/D kayıtları mevcut.
- Validation-required-tests gate eksikleri: `enum_to_x64_ast.bas`,
  `enum_to_mir_x64.bas`, `enum_to_js.bas`, `numeric_literals_bigint.bas`.
- RAG V1 layer check mevcut kaynakta LISTADD/MIR/CODEPTR'ı bulamadı; corpus ve
  config güncel değil. V4 taraması pratikte aşırı yavaş. Bu araçların PASS/FAIL'i
  tek başına kaynak gerçekliği kabul edilmemeli.

## Yapılacak iş sırası

1. **Kabul altyapısı önce:** S-028'i düzelt; bütün artifactler yalnız
   `--out-root` altında, eksik dizinleri oluşturarak yazılsın. Ardından runtime
   import-lib aramasını CWD'den bağımsız yap ve en basit programla AST/MIR
   gerçek EXE smoke'ları kur. Bugün native “PASS” geçmiş kayıtlarının yeniden
   ölçülmesini engelleyen ana kapı budur.
2. **MIR doğrulama sözleşmesi:** S-034'teki Step-4 kurallarını temporary
   operand gerçekliğiyle birleştir; sonra gate'e bağla. S-020 BOTH ve S-025
   x64 BOTH karşılaştırmasını metadata/assembly metni değil, normalize edilmiş
   çalıştırılmış davranış üzerinden kur.
3. **Array ve bellek çekirdeği:** S-021, S-032, S-033, S-035 ve S-036'yı tek
   sözleşmede ele al: local/global array scope, indexed store, lower bound,
   `REDIM PRESERVE`, `SIZEOF(array)`, `MEMCOPY*` ve memory-ref opcode imzası.
   Silent `MEMCOPYD=0,0,0` sonucu önce kapatılmalıdır.
4. **Iterator ve yerleşik koleksiyonlar:** S-031/S-038 ile array discovery ile
   collection discovery'yi ayır; kanonik iterator ABI'yi gerçekten tasarla ve
   uygula. Ancak sonra S-019 native C ABI'sine geç: STRING/ANY için açık
   buffer/length, status+tanı, insertion order, snapshot/JIT mutation ve dört
   ana yol vektörleri zorunlu olsun. Kullanıcı hatasında `fatal+exit` değil,
   kontrollü hata dönsün.
5. **OOP gerçekliği:** S-037'yi önce semantic type relation (`B AS A`),
   `THIS/ME` field typing ve constructor/method yolunda kapat; sonra MIR
   `__VT_SLOT__`, JS virtual dispatch ve x64/AST-direct parity. Field-only
   smoke'un OOP kabulü sayılması yasaklanmalı.
6. **Web gerçekliği:** JS builtin dispatch/cast, WAT helper sentaksı ve WAT
   hedef adını düzelt; sonra `wat2wasm` + validator + host runtime smoke
   olmadan web backend “PASS” demesin. S-042 ile JS core/gömülü-runtime
   kaynağını tekleştir; testin gerçek emitter'ın kullandığı runtime'ı
   çalıştırdığını kanıtla.
7. **Görev/slot:** typed/untyped TASKIN/TASKOUT, THREAD/PIPE/PARALEL için gerçek
   native/runtime ve JS/WASM host sözleşmesi; “typed smoke PASS” gerçek
   asynchrony kanıtı değildir.
8. **Belge/release kapısı:** S-039'u kapatacak güncel bir acceptance manifest
   üret; tarihsel planlara “snapshot” etiketi koy, sadece çalıştırılmış vektör
   sonucu olan satırları güncel destek matrisi yap. S-040 için denetim
   araçlarında açık kapsam filtresi zorunlu olsun; kontrolsüz repo taraması
   release kapısında kullanılmasın. S-041'de eski ABI-120 statik betiğini
   emekliye ayır veya ABI-131 sözleşmesine güncelle; native FFI fixture'ını
   geçici denetim çıktısında üretip gerçek runtime kapısına bağla.
9. **Eski katman kararı:** ancak yukarıdaki çağrı/build/test haritası ve
   PEEK/POKE iki-yol matrisi tamamlanınca `mir_evaluator`/public API için koru,
   daralt veya emekli etme kararı Mete'ye sunulmalı.

## Claude koordinasyon notu

Bu rapor, S-019 sorularına verilen Codex teknik yanıtını da içerir. Ortak
`ai_koordinasyon/SORULAR_CEVAPLAR.md` dosyasına doğrudan ekleme denemesi bu turda
çalışma ortamının yazma/otomatik onay sınırı nedeniyle reddedildi; kaynak ve
Claude CLAIM dosyaları değiştirilmedi. Claude uyandığında bu rapordaki S-019
cevaplarını ve S-020–S-030 kanıtlarını ortak günlüğe aktarmalıdır.
