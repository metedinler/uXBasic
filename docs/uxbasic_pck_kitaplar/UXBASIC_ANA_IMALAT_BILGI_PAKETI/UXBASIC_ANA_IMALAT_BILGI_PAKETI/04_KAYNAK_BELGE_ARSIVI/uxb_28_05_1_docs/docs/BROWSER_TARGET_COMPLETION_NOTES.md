# uXBasic Browser JS/WASM Patch - Tamamlama Notları

Bu sürüm ilk paketteki entegrasyon eksiklerini kapatır.

## Kapatılan eksikler

1. WASM MVP artık FUNCTION parametrelerini `(param $x i32)` olarak üretir.
2. WASM emitter instruction result/local değişkenleri için `(local $t i32)` üretir.
3. ADD/SUB/MUL/DIV/MOD/EQ/NE/LT/LE/GT/GE sonuçları local.set ile saklanır.
4. `FUNCTION Add(a,b)` için hem özgün ad hem de büyük harf alias export edilir: `Add` ve `ADD`.
5. JS unknown CALL artık önce WASM export arar, bulamazsa `ux.callHost(...)` fallback kullanır.
6. `WebAssembly.instantiateStreaming` MIME yüzünden başarısız olursa arrayBuffer fallback kullanılır.
7. WASM manifest artık `.wat` adına göre varsayılan `.wasm` modül adını üretir.
8. `tools/browser_target_patch_audit.py` eklendi.

## Hâlâ MVP kapsamı dışında olanlar

- STRING belleği ve pointer+length ABI.
- CLASS/OBJECT/OOP modelinin WASM karşılığı.
- Gerçek structured control-flow WAT üretimi.
- F80/F128/BIGF/BIGD/BALL için WASM native yol.
- WebGPU backend.

Bu alanlar bilinçli olarak sonraki faza bırakıldı.
