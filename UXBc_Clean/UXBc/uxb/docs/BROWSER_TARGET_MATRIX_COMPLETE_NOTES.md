# uXBasic JS/WASM Matrix-Complete Browser Target Patch

Bu paket önceki JS/WASM MVP iskeletini dil yüzeyi ve anahtar kelime matrislerine göre genişletir.

## Neden önceki paket iskeletti?

Önceki paket backend kapısını açıyordu:
- `--target js`
- `--target wasm`
- `--target browser-hybrid`

Ama tam dil yüzeyi için üç eksik vardı:

1. **Dil yüzeyi kontratı yoktu.** Hangi keyword JS host'a, hangisi WASM compute'a inecek net tabloya bağlanmamıştı.
2. **uXBasic JSON çıktısını tüketen bağımsız araç zinciri yoktu.** Bu nedenle FreeBASIC içindeki emitter değişirse sistem kırılabilirdi.
3. **Browser sandbox gerçekliği ayrılmamıştı.** DLL/API, dosya, serial, bluetooth, AI, canvas gibi işler WASM'e değil JS host/bridge katmanına ait olmalıydı.

## Bu paket ne ekler?

- `runtime/browser/ux_surface_registry.js`: `language_surface_matrix.csv` üzerinden üretilmiş yüzey kayıt sistemi.
- `runtime/browser/ux_mir_executor.js`: uXBasic MIR JSON çıktısını tarayıcıda çalıştıran generic executor.
- `tools/uxb_json_to_js.py`: MIR JSON -> browser `game.js`.
- `tools/uxb_json_to_wasm.py`: MIR JSON -> WAT + `wasm_manifest.json`, varsa `wat2wasm` ile `.wasm`.
- `tools/uxb_browser_build.py`: compiler/MIR JSON -> browser klasörü tek komutta.
- `runtime/browser/ux_runtime.js`: console, canvas, input, string/math, collection, file, AI, FFI bridge diagnostic dahil geniş host runtime.
- `dist/browser/browser_target_gap_matrix.csv`: her surface item için JS/WASM hedef politikası.
- `compiler/scripts/run_browser_json_build.bat`: JSON'dan browser build.
- `compiler/scripts/run_browser_from_source.bat`: `.bas` kaynaktan MIR JSON alıp browser build.

## Dış araçlar

Tam sistem için en az iki dış araç desteklenir:

1. **WABT / wat2wasm**
   - WAT dosyasını gerçek `.wasm` binary'ye çevirir.
2. **Node.js**
   - Üretilen JS için syntax check / smoke doğrulama yapar.
3. **Binaryen / wasm-opt** opsiyonel
   - `.wasm` optimizasyonu için kullanılır.

Bu araçlar pakete gömülmez; PATH üzerinde bulunursa scriptler kullanır. Bulunmazsa rapor dosyasına açıkça yazılır.

## Doğru mimari ayrımı

| Alan | Hedef |
|---|---|
| Matematik, numeric loop, pure function | WASM |
| Canvas, sprite, input, audio | JS host runtime |
| AI / Gemini Nano / Prompt API | JS host runtime |
| Windows AI / DLL / API | localhost bridge / external host |
| File picker / IndexedDB | JS host runtime |
| Serial / Bluetooth | JS host runtime |
| OOP / CLASS / OBJECT | JS object runtime, WASM handle modeli ileri faz |
| F80/F128/BIGF/BIGD/BALL | external runtime / JS host / DLL bridge |

## Önemli gerçek

Browser içindeki WASM doğrudan Windows DLL çağıramaz. Bu güvenlik modelidir. DLL/API için doğru yol:

```text
Browser JS
  -> localhost bridge
  -> uXBasic EXE / Windows AI / DLL
```

Bu paket bunu `ux.callFfi()` içinde bridge olarak tasarlar.
