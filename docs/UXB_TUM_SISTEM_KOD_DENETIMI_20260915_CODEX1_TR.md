# uXBasic tüm sistem kod denetimi — Codex 1

Tarih: 2026-09-15  
Kimlik: Codex 1  
Kapsam: `UXBc_Clean/UXBc` altındaki derleyici, çalışma zamanları, motorlar, kütüphane kaynakları, araçlar, testler, editör uzantısı ve ortak koordinasyon kayıtları.

## Sonuç

uXBasic'in kaynak ağacında nesne yönelimli, işlevsel, yapısal, mantıksal, aktör/olay, çok iş parçacıklı ve sistem programlama hedeflerine ait gerçek izler bulunuyor. Bu dalgada OOP çekirdeğinin eksik kalan alıcı bağlama, upcast/interface, sanal dispatch, kurucu, yıkıcı ve miras alan çözümleme yolları kaynakta tamamlandı ve beş hedefte gerçek çalıştırmayla doğrulandı. BYREF alias ve compound assignment parity'si başka oturumların aktif sahipliğinde kaldığı için bu iki alan henüz kapanmış sayılmıyor.

Bu belge üç kanıt türünü ayırır: kaynak incelemesi, mevcut derleyici ile gerçek çalıştırma ve yeni kaynak düzeltmeleriyle üretilen izole derleyici. Eski `bin/uxb.exe` ile kaynak ağacı aynı revizyon değildir; birinin sonucu diğerinin sonucu gibi sunulmamıştır.

## Envanterin sınırı ve kapsamı

Salt-okunur otomatik envanterde 456.147 dosya, 82 üst seviye klasör grubu ve 1.444 aday kaynak dosyası bulundu. Aday kaynak taraması 808.746 satır içerir; bunun 554.687 satırı üretilmiş compiler C kodudur, elle yazılmış dil özelliği sayısı değildir. Bir erişim hatası `.pytest_cache` altında kaydedildi. ZIP/arşivler açılmadı; silme yapılmadı.

Tam klasör/dosya dökümü ve byte toplamları [ENVANTER_VE_OLCUM_EKLERI_CODEX1.md](../reports/system_audit_20260915/ENVANTER_VE_OLCUM_EKLERI_CODEX1.md), [workspace_files.csv](../reports/system_audit_20260915/workspace_files.csv) ve [workspace_summary.json](../reports/system_audit_20260915/workspace_summary.json) içindedir. Manifestte 47 kütüphane kaydı vardır. Her kütüphane için native kaynak, BASIC wrapper, public header ve dağıtım DLL durumu ek tablodadır. ABI aracı 1.715 çağrıyı 0 hata ve 0 uyuşmazlıkla taradı; bu, işlevlerin tüm motorlarda semantik olarak doğru olduğu anlamına gelmez.

## Paradigma izleri

İşlevsel yüzeyde `FUNCTION`, recursion, `BYVAL/BYREF`, `CODEPTR/FUNCTION_PTR`, `PIPE`, sorgu/filter/group ve dataframe türleri bulunuyor. Genel lambda/closure grameri ve lexical closure yakalama sözleşmesi kaynakta görünür bir özellik olarak tamamlanmış değil.

Yapısal ve sistem yüzeyinde `TYPE`, layout/offset/stride, pointer, `VARPTR`, `NATIVE`, `VIRTUAL`, `PEEK/POKE/MEMCOPY`, FFI ve C ABI mevcut. `STRUCT` ve `UNION` için ABI kayıtları vardır; bunlar BASIC sınıfı kimlikli nesneyle aynı model değildir. `ENUM` parser, semantic doğrulama ve AST runtime'da vardır; MIR/JS/x64 sabit yolu bu denetim sırasında düzeltilmiştir.

Mantıksal yüzeyde Boolean/Logic16 operatörleri, kısa devre, `TRY/CATCH`, koşullu ve yapısal akış vardır. Aktör/olay ve görev yüzeyinde `EVENT`, `PIPE`, `TRIGGER`, `TASKIN/TASKOUT`, `PARALEL`, slot yöneticisi, std/oneTBB/libuv backendleri bulunur. Typed görevlerin bir bölümü gerçek callback scheduling yerine slot çağrısına lower edilir; aktör mailbox, mesaj türü, kapanış ve hata sözleşmesi henüz tek bir tamamlanmış runtime olarak gösterilmemiştir.

## OOP kaynak haritası

- Lexer bağlamsal kuralları: `src/parser/lexer/lexer_keyword_table.fbs`.
- Sınıf/property/magic bildirimleri: `src/parser/parser/parser_stmt_decl_core.fbs`, `parser_stmt_decl_class_method.fbs`.
- `THIS`, `ME`, `SUPER`, static, mixin, decorator ve slot kontrolleri: `src/semantic/semantic_pass.fbs`, `src/type_binding/type_infer_expr.fbs`.
- Kurucu, yıkıcı, tahsis ve erişim: `src/runtime/exec/exec_class_layout_helpers.fbs`, `exec_call_dispatch_helpers.fbs`.
- Layout ve FFI: `src/semantic/layout/layout_type_table.fbs`.
- Canonical MIR dönüşümü: `src/semantic/semantic_to_canonical_mir_bridge.fbs`, `src/semantic/mir_lower_expr.fbs`.
- Native UXClazz üretimi: `tools/uxclazz/uxclazz.py`.
- Native object runtime: `runtime_ext/uxclz/src/uxclz.cpp` ve `libsx/uxclz/`.

`THIS/ME/SUPER` ayrımının sürümlü dil sözleşmesi [OOP hedef tasarım ve uygulama planında](OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md) saklanmıştır. Bu denetim, sözleşmenin temel receiver-owner, upcast, virtual dispatch ve lifetime maddelerini kaynak değişikliği ve gerçek beşli koşu ile eşleştirir; WASM özel probe'u ve çok seviyeli MIR base-constructor zinciri açık sınır olarak kalır.

## Gerçek OOP matrisi

Baseline ve komut ayrıntıları [probe_results.json](../reports/system_audit_20260915/probe_results.json), [target_results.json](../reports/system_audit_20260915/target_results.json) ve yeni izole koşu raporlarındadır.

| Vaka | AST | Canonical MIR | JS/Node | MIR-x64 | AST-x64 | Güncel kanıt |
|---|---:|---:|---:|---:|---:|---|
| `CLASS` alanı, `NEW`, kurucu ve matematik | 25 | 25 | 25 | 25 | 25 | `oop_final7_regression.../results.json` |
| `Animal`/`Dog` virtual `Speak` | 42 | 42 | 42 | 42 | 42 | Ortak slot hedefi beş motorda tüketildi |
| `Base` değişkenine `Child` ataması | 7 | 7 | 7 | 7 | 7 | Class/interface yönlü semantic upcast |
| `SUPER.X` üzerinden miras alanı | 9 | 9 | 9 | 9 | 9 | `super_field` gerçek beşli koşu |
| Türetilmiş→taban destructor zinciri | 200/100/1 | 200/100/1 | 200/100/1 | 200/100/1 | 200/100/1 | `object_lifetime` gerçek beşli koşu |
| `ENUM Mode.ON` | 1 | 1 | 1 | 1 | 1 | Ortak enum resolver ve `LOAD_CONST` rotası |

`THIS`, `ME` ve `SUPER` artık semantic türleme, MIR field owner çözümü, AST/MIR/JS/x64 çağrı çerçevesi ve x64 method frame'lerinde fiziksel alıcıya bağlanıyor. `SUPER` alan erişimi ve miras hiyerarşisi ayrıca gerçek testle ölçüldü. Kalan tasarım sınırı, canonical-MIR yorumlayıcısında çok seviyeli base-constructor zincirinin metadata üzerinden genel hale getirilmemiş olmasıdır; doğrudan constructor ve destructor zinciri doğrulanmıştır.

## Kesinleştirilen yazılım sorunları

### C1-OOP-01 — Canonical MIR sanal hedef tüketilemiyor — KAPATILDI

Kök neden iki parçalıydı: `__VT_SLOT__:` önekinin JS ve bridge denetimlerinde yanlış uzunlukla karşılaştırılması ve x64 MIR'de `MIR_OBJECT_NEW`'in genel host-call yoluna düşmesi. Uzunluk kontrolleri `Len(...)` ile ortaklaştırıldı; x64 yüzey dispatch'i `NEW` için özel nesne oluşturma yoluna alındı. `virtual_call` testi 42 sonucunu AST, canonical-MIR, JS/Node, MIR-x64 ve AST-x64'in beşinde verdi. Böylece ortak vtable slot/MethodId yolu bu probe kapsamında kapanmıştır.

### C1-OOP-02 — Upcast tür kuralı yok — KAPATILDI (probe kapsamı)

Step3 assignment gate class/interface hedeflerinde `SemCanAssignClassType` yönlü hiyerarşi kontrolünü kullanıyor. Interface layout'u pointer olarak kaydediliyor ve interface değişkenine class nesnesi atanabiliyor; ters yönlü geçersiz atama reddediliyor. `interface_upcast` testi beş motorda 7 verdi. Genel explicit downcast/reflection sözleşmesi ayrı bir dil özelliği olarak ayrıca tasarlanabilir.

### C1-OOP-03 — Receiver sahibi tür aşamasında kayboluyor — KAPATILDI (temel alıcı yolları)

`THIS/ME/SUPER` için özel tür çözümü, lexical class/base owner yürüyüşü ve miras alanı araması eklendi. AST, MIR, exec dispatch, JS ve x64 method frame'leri fiziksel alıcıyı bu üç ada bağlayabiliyor. `class_math` 25 ve `super_field` 9 sonuçlarını beş hedefin tamamında verdi. Çok seviyeli base-constructor zincirinin metadata üzerinden otomatik çağrılması MIR yorumlayıcısında hâlâ genel bir özellik değildir.

### C1-OOP-04 — UXClazz üretim adı çakışmaları

Önceden `USES Logger` ile `LoggerPart` alanı iki `GetLoggerPart/SetLoggerPart` üretebiliyor, `x` ve `X` aynı sembol sayılmıyordu ve bilinmeyen `DERIVE` sessizce yok sayılıyordu. `tools/uxclazz/uxclazz.py` artık case-insensitive sınıf/alan/trait/member çakışmalarını iki kaynak satırıyla reddediyor ve DERIVE whitelist dışındaysa hata veriyor. `tests/uxclazz_codex1/test_generated_names.py` 8/8 geçti.

### C1-PAR-01 — JS/WASM sanal hedef önek uzunluğu — JS KAPATILDI

JS helper'daki `Left(..., 11)` denetimi `Len("__VT_SLOT__:")` oldu ve `virtual_call` JS/Node'da 42 verdi. WASM'de aynı önek ailesinin tüm çağrı dalları için ayrı gerçek probe henüz eklenmedi; bu nedenle WASM parity'si açık doğrulama maddesi olarak kalıyor.

### C1-MIR-01 — ENUM sabiti storage değişkeni gibi lower ediliyordu

Önceki `mir_lower_expr.fbs` `FIELD_EXPR` fallback'i `LOAD_VAR "Mode.On"` üretiyor, MIR'da 0 ve JS'de `undefined` veriyordu. Ortak `src/parser/ast_enum_lookup.fbs` eklendi; semantic gate'in çözdüğü `ENUM_ITEM.op` değeri `LOAD_CONST` olarak MIR ve AST-x64 yollarına taşındı. Route coverage `LOAD_CONST` kabul ediyor. Yeni izole derleyiciyle `Mode.ON` beş hedefte 1 verdi.

### C1-FFI-01 — Lua yükleme işlemi atomik değildi

`uxlogic_lua_load` DLL'i `uxLua` globaline tüm semboller çözülmeden yazıyor, eksik sembolde erken dönüyor; sonraki çağrı sahte başarı döndürebiliyordu. Candidate handle, kilit, rollback ve fonksiyon pointer temizleme eklendi. Gerçek DLL testi: hatalı `kernel32.dll` yüklemesi 0+hata, eksik DLL 0+hata, gerçek `lua54.dll` 1, `answer=6*7` sonucu 42; 4/4 PASS.

### C1-MEM-01 — BYREF aynı değişkene verilen iki parametrede kopya-in/kopya-out — AÇIK

`Change(BYREF x, BYREF y)` çağrısında güncel final7 binary'si AST 11, canonical MIR 11, JS 2, MIR-x64 2, AST-x64 10 verdi. Bu, aynı değişkenin iki BYREF parametreye verilmesinde copy-in/copy-out ve gerçek alias semantiğinin motorlara göre ayrıştığını gösteriyor. BYREF dosyaları Claude 1/2'nin aktif sahipliğinde olduğundan bu oturumda değiştirilmedi; native/AST-direct uyumu kapanmadı.

### C1-MEM-02 — Struct compound assignment motor ayrışması — AÇIK

`pts(i).X += 5` için önceki ölçüm AST 15, canonical MIR 10, MIR-x64 10, AST-x64 15 idi. S-050 düz atama düzeltmesi compound yolu kapsamıyordu. Codex 2'nin aktif operator/compound alanına bırakıldı; bu oturumda dosya sahipliği nedeniyle değiştirilmedi ve parity kapanmış sayılmıyor.

### C1-EXEC-01 — Özyinelemeli yerel `DIM` tek ad alanı çakışması — KAPATILDI

Eski ExecState yolu çağrı snapshot'ı almasına rağmen `ExecFindVar` ile bütün değişkenleri tek ad alanında tarıyordu. Bu nedenle `FUNCTION Fact` içindeki her çağrıda `DIM result` dış çağrının değişkeniyle çakışıyordu. `ExecState` içine aktivasyon çerçevesi tabanları eklendi; iç çerçeve önce aranıyor, parametreler ve DIM yerelleri dış isimleri gölgeleyebiliyor, dönüşte snapshot geri yükleniyor. `recursive_local` testi beş hedefte 120 verdi.

### C1-COLL-01 — JS embedded collection host bağları — KAPATILDI (temel LIST/DICT/SET)

Ortak JS runtime'da `LIST_NEW`, `LISTADD`, `LISTGET` ve ilgili DICT/SET operasyonları host çağrısına bağlı olmadığı için `UXB_HOST_BINDING_MISSING: LIST_NEW` veriyordu. `runtime/js/common/ux_runtime_core.js` içine kararlı collection handle/op katmanı eklendi ve `js_runtime_embedded_generated.fbs` yeniden üretildi. `listget_numeric` JS/Node artık 25 veriyor.

### C1-COLL-02 — AST-x64 collection ABI eksikliği — AÇIK

Aynı `listget_numeric` testinde AST-x64 assembler `listadd` ve `listget` sembollerini bulamıyor. MIR-x64 native collection ABI'si mevcut olsa da AST-direct x64 emitter bu ABI'ye yönlenmiyor. Bu, altı motorun tek davranış sözleşmesine ulaşması için ayrı backend işi olarak kaydedildi.

### C1-ARRAY-01 — Dinamik DIM backend kısıtı — AÇIK

Native x64 MIR emitter hâlâ `DIM arr(n)` için compile-time literal sınır istiyor ve `got lower='0' upper='n'` hatası veriyor. REDIM/PRESERVE düzeltmesi bu ilk tahsis kısıtını çözmedi; heap tabanlı dynamic-array MIR yolu ve WASM karşılığı tamamlanmadan bu özellik tüm motorlarda parity kazanmış sayılmayacak.

### C1-ABI-01 — Eski FFI denetleyicisinin yanlış pozitifleri

Eski `uxb/tool_py/tools/library_tools/uxb_library_abi.py` 1.715 çağrıda 211 hata/14 uyuşmazlık bildirdi; current `uxb/tools/library_tools/uxb_library_abi.py` aynı çağrıda 0/0 verdi. Eski araç typedef/macro çözümlemediği için 225 satırı gerçek kütüphane hatası olarak saymak yanlıştır. Current araç varsayılan generated allowlist'i yenileyebildiğinden rapor koşusu özel çıktı yoluna alınmalıdır.

### C1-ASYNC-01 — Typed görev çağrıları gerçek scheduler değil

Native runtime std/TBB/libuv backendlerini içeriyor; fakat `mir_lower_slot_lane.fbs` typed `TRIGGER` için `MIR_OP_CALL` ile `__SLOTLANE_KIND_NAME` rotasına düşüyor. Callback imzası çoğunlukla int32 slot/input/output taşıyor. Bu, çok iş parçacıklı kütüphane altyapısının varlığını gösterir; dil seviyesinde mesaj garantili aktör sistemi kanıtı değildir.

## Anahtar kelime ve isim çatışması

`GET`, `SET`, `VIRTUAL` bağlamsal lexer kurallarıyla bazı yerlerde keyword, bazı yerlerde property/method/memory anlamında ele alınıyor. `INPUT/OUTPUT` görevi `TASKIN/TASKOUT` olarak ayrılmış ve eski görev aliası reddediliyor. `THIS`, `ME`, `SUPER` semantic'te özel receiver isimleri; global değişken gibi ele alınmamaları için sembol tanılarına girmiş durumda. `DECORATOR` ve `DERIVE` UXClazz girdisinde kullanılıyor; her ikisinin compiler core keyword olduğu varsayılmamalı. `SEALED/FINAL`, `STRUCT/UNION`, `ENUM`, `CLASS/CLAZZ` için sürümlü ve case-insensitive tek kayıt tablosu hâlâ gereklidir.

## Kütüphaneler ve sistem katmanları

47 manifest kütüphanesi native source → wrapper → public header → DLL dağıtım zinciriyle ek tabloda gösterildi. `uxclz` gerçek handle/refcount/type hierarchy/multimethod/metadata runtime'ı içeriyor; BASIC CLASS adresi ile C++ object adresi eşit varsayılmıyor. `uxlogic` Lua ve SWI-Prolog köprüleri, fuzzy fonksiyonlar ve süreç tabanlı Prolog çağrısı içeriyor. `uxcollections` AST/MIR tarafında geniş yüzeye sahip; native x64 için list/dict/set iterator ve ABI desteği her kullanımda aynı değildir. JS/WASM'de DLL otomatik var sayılmıyor; host capability gerekir.

Kütüphane varlığı, export kataloğu veya kaynak kapısı PASS sonucu semantik tamamlanma değildir. Özellikle `uxraylib/uxsdl3` dinlenme noktası, `uxterminal` dar yüzeyi ve callback/lifetime sınırları ortak sorun kaydında açık kalmıştır.

## Claude kayıtlarıyla uzlaştırma

`SORUN_TAKIP.md` 63 kayıt olarak ayrıştırıldı. S-001–S-018'in kapanışları önceki dört motor kanıtlarıyla kaydedilmiş; S-019, S-031, S-035, S-038, S-044, S-045, S-047, S-049, S-050 ve S-061 için sonraki oturum kapanışları dikkate alınmıştır. S-033'ün eski “ikinci operand ARRAY olmalı” özeti güncel source ile uyuşmuyor: lowering `TYPE_NAME=ARRAY`, `VAR=dizi adı`, byte-length sabitleri üretir; verifier tip uyumu ayrıca yeniden doğrulanmalıdır. S-058'in x64 FreeBASIC `UInteger=32 bit` gerekçesi yanlıştır; yerel ölçüm Integer/UInteger/Ptr=8 byte, Long=4 byte ve `CUInt(4294967297)=4294967297` verdi.

S-051 BYREF, S-057–S-060 bellek sözleşmeleri, S-064 native F64/STRING dizi elemanı ve S-063 VIRTUAL stack hizalaması gibi kayıtlar bu denetimde “eski başlık açık” diye otomatik kapatılmadı; sonraki kapanış kanıtı ayrıca belirtildi. Tam kayıt indeksi [tracked_issues_current.json](../reports/system_audit_20260915/tracked_issues_current.json) içindedir.

## Uygulama durumu

Tam plan P0–P10 belgesinde korunuyor. Bu turda gerçekten uygulanan ve doğrulananlar:

1. UXClazz case-insensitive generated-member collision/unknown-DERIVE rejection; 8 test PASS.
2. ENUM constant shared resolver; yeni izole compiler ile AST/MIR/JS/MIR-x64/AST-x64 `Mode.ON=1`.
3. `uxlogic_lua_load` transaction/rollback/lock; gerçek DLL 4/4 PASS.
4. OOP/plan kimliği, uygulama kapsamı ve kanıt kayıtları ortak koordinasyon dosyalarına işlendi.
5. 47 kütüphane, 82 klasör grubu, 63 issue kaydı ve motor matrisi denetlenebilir eklerde saklandı.
6. Parser surface gate'inde eksik olan `NATIVE`/`PEEKS` kayıtları tamamlandı; derleyici kapısı yeniden beşli OOP koşularıyla doğrulandı.
7. MIR `NEW` artık sınıf kurucusunu çağırıyor; JS ve x64 alıcı takma adları `THIS/ME/SUPER` ile eşitlendi.
8. Class/interface upcast, ortak sanal slot tüketimi, miras alanı (`SUPER.X`) ve derived→base destructor zinciri beş hedefte gerçek çıktıyla doğrulandı.
9. ExecState recursive-local frame düzeltmesi ve ortak JS collection runtime'ı kaynakta uygulandı; `recursive_local` 5/5, `listget_numeric` AST/MIR/JS/MIR-x64 4/5 PASS verdi.
10. Kaynak `%%ALIAS` ve runtime `ALIAS` temel yolları iki testte beş motor × 2 olarak 10/10 PASS verdi.

Tamamlanmayanlar: AST-x64 collection ABI; `DIM arr(n)` dynamic-array backend yolu; WASM sanal çağrı ve `$ELEME` için ayrı probe; MIR yorumlayıcısında metadata tabanlı çok seviyeli base-constructor zinciri; typed collection (`LIST OF I32`) metadata; trait/decorator lowering; gerçek actor mailbox/scheduler; compound struct assignment; native/AST-direct BYREF alias. Bu maddeler gerçek test geçmeden “tamamlandı” sayılmaz.

## Kanıt dosyaları

- [Tam OOP tasarım ve uygulama planı](OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md)
- [Codex 1 kimlik ve uygulama kaydı](../ai_koordinasyon/CODEX1_KIMLIK_VE_UYGULAMA_KAYDI_20260915.md)
- [Envanter ve ölçüm ekleri](../reports/system_audit_20260915/ENVANTER_VE_OLCUM_EKLERI_CODEX1.md)
- [UXClazz testleri](../tests/uxclazz_codex1/test_generated_names.py)
- [Lua DLL testi](../tests/libraries/uxlogic_codex1/test_load_recovery.py)
- [OOP izole koşucu](../tests/oop_codex1/run_matrix.py)
- [Lua sonucu](../reports/system_audit_20260915/uxlogic_fixed/results.json)
- [Son OOP beş hedef regresyonu](../reports/system_audit_20260915/oop_final7_regression_20260915_231607_439925/results.json)
- [Gemini belgesi hata envanteri](../reports/system_audit_20260915/GEMINI_BELGE_HATA_ENVENTERI_20260916_CODEX1.md)
- [Recursive/collection regresyonu](../reports/system_audit_20260915/collections_recursion_final9_20260916_000534_035069/results.json)
- [OOP + Gemini son regresyonu](../reports/system_audit_20260915/full_oop_gemini_final9_20260916_000808_078166/results.json)
- [Dynamic array backend probe'u](../reports/system_audit_20260915/dynamic_array_final9_20260916_001106_837324/results.json)
- [ALIAS beş motor probe'u](../reports/system_audit_20260915/alias_final9_20260916_001255_404875/results.json)
- [LISTGET assignment type probe'u](../reports/system_audit_20260915/listget_assign_final9_20260916_001419_924122/results.json)
- [Motor sorumluluk ve parity sözleşmesi](MOTOR_SORUMLULUK_VE_PARITE_SOZLESMESI_20260916_CODEX1.md)
- [OOP kaynak build günlüğü](../reports/system_audit_20260915/compiler_codex1_build_new2.txt)
