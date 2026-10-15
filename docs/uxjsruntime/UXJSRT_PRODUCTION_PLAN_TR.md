# UXJSRT son üretim genişletme planı

## Mimari

```text
uXBasic kaynak
    ↓
MIR → JavaScript emitter
    ↓
program.js + globalThis.uxb contract
    ↓
ux_runtime_quickjs.js
    ↓
__uxbNative
    ↓
uxjsrt.dll
    ↓
QuickJS 2026-06-04
```

## Sprint 1 — çekirdek (bu yamada)

- sürümlü QuickJS fetch ve hash doğrulama
- statik QuickJS bağlantılı `uxjsrt.dll`
- I32 runtime/context/result handle tabloları
- eval/eval_file
- JSON argümanlı çağrı
- Promise/job queue çağrısı
- JSON sonuç ve hata
- bellek, stack, süre limitleri
- `globalThis.uxb` common contract
- QuickJS provider
- geçici emitter uyumluluk köprüsü
- Python ve uXBasic smoke testleri

## Sprint 2 — modül yükleyici

- güvenli kök dizin
- relative ES module çözümü
- izin verilen uzantılar `.js`, `.mjs`, `.json`
- `..` kaçışının reddi
- modül cache
- import hata raporu

## Sprint 3 — native servis kayıt sistemi

Tek tek ve capability ile:

```text
uxb.system
uxb.file
uxb.path
uxb.process
uxb.net
uxb.storage
uxb.crypto
uxb.ai
```

Her servis ayrı adaptör olur. QuickJS doğrudan Windows API veya bütün uXBasic DLL'lerine sınırsız erişmez.

## Sprint 4 — emitter'ın doğrudan globalThis.uxb kullanması

`uxb.compat` kullanımları opcode grupları halinde kaldırılır. Eski alias yalnız uyumluluk profilinde kalır.

## Sprint 5 — dağıtım

```text
dist/runtime/uxjsrt.dll
dist/runtime/ux_runtime_core.js
dist/runtime/ux_runtime_quickjs.js
dist/licenses/QuickJS-MIT.txt
dist/manifest/uxjsrt_manifest.json
```

Manifest:

- UXJSRT API sürümü
- QuickJS sürümü ve hash
- etkin capability listesi
- güvenlik limitleri
- program giriş noktası

## Sprint 6 — üretim kapıları

- ASan/UBSan Linux geliştirme buildi
- Windows x64 release build
- 1000 create/free döngüsü
- stale handle negatif testleri
- exception/stack testleri
- sonsuz döngü time limit testi
- bellek limiti testi
- Promise rejection testi
- bilinmeyen host çağrısı fail-closed testi

## Sonraki hedef

WASM sonraki ayrı çalışmadır. Bu planda WASM kodu, Wasmtime, WABT veya `uxb.wasm` uygulaması eklenmez.
