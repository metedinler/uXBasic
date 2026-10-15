# Codex GPT Mini 4 çalışma emri — UXJSRT

## Tek hedef

```text
uxjsrt.dll + QuickJS + globalThis.uxb
```

WASM, Node, Duktape, npm, WebGPU ve yeni dil özellikleri bu iş emrinin dışındadır.

## Başlama ön koşulu

Mevcut çalışma ağacındaki kullanıcı/Codex değişikliklerini geri alma. Önce `git status --short` ile kaydet. Dış kütüphane yolunda I32 ve STRPTR dar testleri gerçek kaynak dosyasıyla PASS değilse UXJSRT entegrasyon testine geçme. Bu yama U64/PTR taşımadığı için mevcut `U64_PTR` tartışmasını büyütmez; ancak STRPTR dönüş yolu yine çalışmalıdır.

## Değişmez kararlar

1. QuickJS yeniden yazılmayacak; resmi QuickJS kaynakları DLL içine statik bağlanacak.
2. Kamu JS sözleşmesi yalnız `globalThis.uxb` olacaktır.
3. `globalThis.ux` yalnız geçici uyumluluk aliasıdır; yeni kod doğrudan ona bağlanmayacaktır.
4. DLL dış ABI'sinde ham `JSRuntime*`, `JSContext*`, `JSValue` veya Windows pointer'ı yayımlanmayacaktır.
5. Dış handle'lar I32 nesne kimliği olacaktır. Bu karar mevcut U64_PTR FFI sorunu ile UXJSRT çalışmasını birbirinden ayırır.
6. Desteklenmeyen host çağrısı fail-closed davranacaktır.
7. QuickJS sürümü `2026-06-04`, kaynak SHA-256 değeri kilitlidir.
8. Gereksiz tam compiler build yapılmayacaktır. Önce statik doğrulama, DLL build ve dar smoke çalışır.

## Uygulama sırası

### Aşama 0 — kaynak kapısı

```powershell
python tools/tests/verify_uxjsruntime_patch.py --root .
```

FAIL varsa kaynak değiştirme; raporu düzelt.

### Aşama 1 — bağımlılık

```powershell
runtime_ext/uxjsruntime/fetch_quickjs.ps1 -Root .
```

Doğrulanacaklar:

- URL yalnız resmi Bellard kaynağıdır.
- Sürüm `2026-06-04`.
- SHA-256 `b376e839b322978313d929fd20663b11ba58b75df5a46c126dd19ea2fa70ad2a`.
- Kaynak `runtime_ext/uxjsruntime/vendor/quickjs` altına açılır.

### Aşama 2 — DLL

```powershell
runtime_ext/uxjsruntime/build_uxjsrt.ps1 -Root . -SkipFetch
```

Beklenen:

```text
bin/uxjsrt.dll
runtime_ext/uxjsruntime/build/libuxjsrt.dll.a
```

### Aşama 3 — native smoke

```powershell
python tests/libraries/uxjsruntime/test_uxjsrt.py --root .
```

Zorunlu kanıtlar:

```text
UXJSRT_GLOBALTHIS_UXB_PASS
UXJSRT_NATIVE_SMOKE_PASS
provider = quickjs
sum = 30
```

### Aşama 4 — compiler runtime üretimi

Kaynak gerçekliği:

```text
runtime/js/common/ux_runtime_core.js
```

Üretilen dosya:

```text
src/codegen/js/runtime/js_runtime_embedded_generated.fbs
```

Değişiklikten sonra:

```powershell
python tools/js_runtime/generate_js_runtime_fbs.py --root .
python tools/tests/verify_uxjsruntime_patch.py --root .
```

Elle iki ayrı runtime kopyası düzenleme.

### Aşama 5 — uXBasic smoke

Önce yalnız UXJSRT testi:

```powershell
bin/uxb.exe ast tests/libraries/uxjsruntime/uxjsruntime_smoke.uxb
bin/uxb.exe mir tests/libraries/uxjsruntime/uxjsruntime_smoke.uxb
```

AST ve MIR aynı JSON sonucu üretmelidir.

### Aşama 6 — emitter göçü

İlk yama emitter'ı kırmamak için:

```javascript
const uxb = globalThis.uxb;
const ux = uxb.compat;
```

üretir. Sonraki dar yamalarda emitter çağrıları sırayla taşınır:

```text
ux.print       -> uxb.console.print
ux.println     -> uxb.console.println
ux.builtin     -> uxb.lang.builtin
ux.callHost    -> uxb.host.call
ux.array*      -> uxb.data.*
ux.object*     -> uxb.object.*
ux.screen/text -> uxb.canvas.*
```

Her taşıma ayrı testle yapılır. Tüm dosyada kör arama-değiştirme yapılmaz.

## Değiştirilmeyecek alanlar

- FFI çekirdeğinin başka sorunları
- WASM emitter
- WAT araçları
- x64 codegen
- uXPython
- kütüphane envanterinin tamamı
- browser runtime'ın geniş servisleri

## Tamamlandı ölçütü

Aşağıdakilerin tümü PASS olmadan üretim tamamlandı denmez:

1. Static verifier PASS.
2. QuickJS hash PASS.
3. PE32+ x64 `uxjsrt.dll` oluştu.
4. Beklenen exportlar mevcut.
5. Python ctypes smoke PASS.
6. uXBasic AST smoke PASS.
7. uXBasic MIR smoke PASS.
8. `globalThis.uxb.provider.name == "quickjs"`.
9. QuickJS provider `autoRun=false` ile programı yalnız yükler; `uxbMain` host tarafından bir kez çağrılır.
10. Promise-aware `uxbMain` sonucu JSON alınabiliyor.
11. Bellek, stack ve zaman limitlerinin negatif testleri PASS.
