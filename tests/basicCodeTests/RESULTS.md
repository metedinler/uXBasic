# basicCodeTests Sonuc Raporu

## Uretilen artefact yapisi

Her yeni ornek icin su ciktilar yazildi:

- `tests/basicCodeTests/out/<ornek>/ast.json`
- `tests/basicCodeTests/out/<ornek>/inventory.json`
- `tests/basicCodeTests/out/<ornek>/pipeline.json`
- `tests/basicCodeTests/out/<ornek>/parse_and_json.log`
- `tests/basicCodeTests/out/<ornek>/build_x64.log`
- `tests/basicCodeTests/out/<ornek>/exec_ast.log`

Native x64 build gecen orneklerde ek olarak:

- `tests/basicCodeTests/out/<ornek>/x64build/program.asm`
- `tests/basicCodeTests/out/<ornek>/x64build/obj/program.obj`
- `tests/basicCodeTests/out/<ornek>/x64build/obj/entry_shim.obj`
- `tests/basicCodeTests/out/<ornek>/x64build/program.exe`

## Ozet tablo

| Ornek | AST JSON | Inventory JSON | Pipeline JSON | Interpreter | x64 build | Not |
|---|---|---|---|---|---|---|
| `31_uxb_windows_kernel_sleep_tick.bas` | OK | OK | OK | FAIL | OK | `CALL(DLL)` asm lane'e iniyor ve exe uretiliyor; fakat native resolver olmadigi icin stub no-op ve `0` donuyor |
| `32_uxb_windows_user32_metrics.bas` | OK | OK | OK | FAIL | OK | `CALL(DLL)` user32 probe artik link oluyor; gercek API sonucu yerine resolver eksigi nedeniyle `0` beklenmeli |
| `33_uxb_windows_user32_messagebox_interactive.bas` | OK | OK | OK | SKIP | OK | interaktif GUI demo exe uretiyor; runtime davranisi bugun stub lane ile sinirli |
| `34_uxb_mpfr_probe.bas` | OK | OK | OK | FAIL | OK | MPFR probe derlenebilir; gercek DLL sembol cozumleme henuz yok |
| `35_uxb_arb_flint_probe.bas` | OK | OK | OK | FAIL | OK | Arb/FLINT probe derlenebilir; runtime no-op fallback calisir |
| `36_uxb_lua54_probe.bas` | OK | OK | OK | FAIL | OK | Lua probe derlenebilir; native FFI resolver eksik |
| `37_uxb_python_embed_probe.bas` | OK | OK | OK | FAIL | OK | Python embed probe derlenebilir; gercek cagri yerine kontrollu `0` dondurur |
| `38_uxb_swipl_probe.bas` | OK | OK | OK | FAIL | OK | SWI-Prolog probe derlenebilir; resolver tamamlanana kadar stub lane aktif |
| `39_uxb_fuzzy_prolog_template.bas` | OK | OK | OK | FAIL | OK | vendor DLL template derlenebilir; sembol baglama eksigi suruyor |
| `40_uxb_libcurl_probe.bas` | OK | OK | OK | FAIL | OK | libcurl probe derlenebilir; HTTP cagrisi gerceklesmez, stub sonuc doner |
| `41_uxb_winhttp_probe.bas` | OK | OK | OK | FAIL | OK | winhttp probe parse + asm + obj + exe zincirinden geciyor; resolver eksigi runtime'i sinirliyor |
| `42_uxb_native_console_codegen_smoke.bas` | OK | OK | OK | OK | OK | FFI disi native x64 smoke |
| `43_uxb_native_flow_math_codegen_smoke.bas` | OK | OK | OK | OK | OK | FFI disi native x64 flow smoke |

## Basarili native x64 exe kosulari

### `42_uxb_native_console_codegen_smoke.bas`

Exe:

- `tests/basicCodeTests/out/42_uxb_native_console_codegen_smoke/x64build/program.exe`

Objeler:

- `tests/basicCodeTests/out/42_uxb_native_console_codegen_smoke/x64build/obj/program.obj`
- `tests/basicCodeTests/out/42_uxb_native_console_codegen_smoke/x64build/obj/entry_shim.obj`

Interpreter cikisi:

```text
native console smoke
3
510524958
```

Native exe cikisi:

```text
native console smoke
3
510986468
```

### `43_uxb_native_flow_math_codegen_smoke.bas`

Exe:

- `tests/basicCodeTests/out/43_uxb_native_flow_math_codegen_smoke/x64build/program.exe`

Objeler:

- `tests/basicCodeTests/out/43_uxb_native_flow_math_codegen_smoke/x64build/obj/program.obj`
- `tests/basicCodeTests/out/43_uxb_native_flow_math_codegen_smoke/x64build/obj/entry_shim.obj`

Interpreter cikisi:

```text
sum>10
15
7
3
  
AAA
```

Native exe cikisi:

```text
sum>10
15
7
3
4
```

Not:

- Interpreter ile native x64 output birebir ayni degil.
- Bunun nedeni string helper ve print/codegen yuzeyinin henuz tam parity'ye sahip olmamasidir.

## Tespit edilen mimari gercekler

### 1. JSON lane calisiyor

Bu turda eklenen `--ast-json-out` ile birlikte yeni orneklerin tamaminda:

- AST JSON
- inventory JSON
- pipeline JSON

uretildi.

### 2. Native x64 lane FFI disinda calisiyor

`42` ve `43` no'lu FFI disi orneklerde:

- asm
- obj
- exe

uretildi ve exe'ler calisti.

### 3. `CALL(DLL)` native lane artik derleniyor, ama tam calismiyor

Yeni DLL probe orneklerinde parse ve JSON katmani basarili. Son turda native x64 emitter bu dugumleri asm'e indirmeye basladi ve exe zinciri artik kopmuyor. Ancak:

- compiler driver uzerinden `--execmem` kosulari nonzero dondu
- x64 native build artik asm + obj + exe uretiyor
- gercek `LoadLibrary` / `GetProcAddress` tabanli resolver henuz eklenmedigi icin stub lane sembol baglayamazsa kontrollu no-op yapip `0` donuyor

Bu, repodaki mevcut durumun su oldugunu gosterir:

- `CALL(DLL)` icin native lowering boslugu kapatildi
- `source.bas -> --build-x64 -> program.exe` yolu artik `CALL(DLL)` ornekleri icin de acik
- fakat bu yol bugun tam FFI invocation degil; "derlenebilir stub lane" seviyesinde

### 4. GUI API kullanimi icin bugunku pratik yol

Win32 GUI tarafinda bugunku repo ile iki seviye vardir:

1. parse/json/template seviyesi
2. gercek GUI runtime icin ek FFI marshalling ve resolver ihtiyaci

`MessageBoxA` gibi karisik tipli API'ler bugunku saf `CALL(DLL)` marshalling modeli icin darbogaz olusturur.

## Sonuc

Bu test turu sonunda repo icin net operasyonel sonuc:

- Belgeler yazildi.
- Yeni `.bas` ornekleri yazildi.
- Her ornek icin JSON ciktilari uretildi.
- FFI disi native x64 zinciri obj + exe + run seviyesinde dogrulandi.
- DLL/FFI ornekleri artik asm + obj + exe seviyesine kadar derlenebiliyor.
- DLL/FFI runtime davranisi ise halen gecis asamasinda; stub lane sayesinde derleme kirilmiyor ama resolver tamamlanana kadar gercek DLL etkisi beklenmemeli.
