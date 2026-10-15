# uXBasic Browser Target Master Plan

Bu paket mevcut MIR hattına dokunmadan üç yeni hedef ekler:

1. `--target js`
2. `--target wasm`
3. `--target browser-hybrid`

## Mimari

```text
uXBasic source
  -> AST
  -> Semantic
  -> MIR
  -> JS Transpiler
  -> Browser Runtime

uXBasic source
  -> AST
  -> Semantic
  -> MIR
  -> WASM WAT/Manifest
  -> JS WASM bridge
```

## Ayrım

JS hedefi browser API'lerini yönetir: Canvas, input, audio, AI, DOM ve host köprüleri.

WASM hedefi hesaplama çekirdeği içindir: integer arithmetic, float arithmetic, branch, loop, function call ve array compute işleri.

Hybrid hedef önce WAT/manifest üretir; sonra JS bundle üretir ve WASM export'larını JS runtime üzerinden çağırır.

## MVP kapsamı

JS: `PRINT`, assignment, arithmetic, `SCREEN`, `CLS`, `FILLRECT`, `RECT`, `LINE`, `TEXT`, `LOADSPRITE`, `DRAWSPRITE`, `KEYDOWN`, `AI`.

WASM: `FUNCTION Add(a AS I32,b AS I32) AS I32 RETURN a+b` türü basit hesaplama fonksiyonları.

## Kural

Mevcut x64 hattı bozulmayacak. Bu patch yalnızca yeni dosyalar ve `main.bas`/`main_program_entry.fbs` içinde hedef seçimi ekler.
