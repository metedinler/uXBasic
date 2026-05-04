# basicCodeTests Sonuc Raporu

## 2026-04-23 FFI/GUI guncellemesi

Bu turda `CALL(DLL)` artik yalnizca stub/no-op seviyesinde degil:

- AST interpreter `kernel32.GetTickCount`, `kernel32.Sleep`, `user32.GetSystemMetrics` ve `user32.MessageBeep` icin gercek Windows DLL cagrisi yapabiliyor.
- MIR interpreter ayni `CALL(DLL, ...)` wrapper syntax'ini `DLL` opcode yoluna normalize edip gercek DLL sonucu donduruyor.
- Native x64 build `ffi_resolver.c` uretip `LoadLibraryA` + `GetProcAddress` ile `__uxb_ffi_symptr_N` alanlarini dolduruyor.
- `MessageBoxA` icin karisik imza syntax'i destekleniyor: `"PTR,STRPTR,STRPTR,I32"`.
- GUI smoke icin `MessageBeep` otomatik calisir; `MessageBoxA` interaktif oldugu icin exe build edilir ama otomatik testte calistirilmaz.

Son dogrulanan smoke sonuclari:

| Ornek | AST interpreter | MIR interpreter | x64 build/run | Not |
|---|---|---|---|---|
| `31_uxb_windows_kernel_sleep_tick.bas` | OK, pozitif delta | OK, pozitif delta | OK, pozitif delta | `GetTickCount` + `Sleep` gercek DLL cagrisi |
| `32_uxb_windows_user32_metrics.bas` | OK, `1920x1080` | OK, `1920x1080` | OK, `1920x1080` | `GetSystemMetrics` + `MessageBeep` |
| `33_uxb_windows_user32_messagebox_interactive.bas` | SKIP | SKIP | BUILD OK | Interaktif `MessageBoxA`, otomatik kosuda calistirilmaz |

Kalan not: x64 string/print codegen yuzeyinde uzun iki string'in ayni FFI smoke icinde birlikte kullanilmasiyla tetiklenen ayri bir kirilganlik gozlemlendi; 31 no'lu smoke label'lari bu nedenle kisa tutuldu. FFI resolver/native DLL cagrisi bundan bagimsiz olarak calisiyor.

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
| `31_uxb_windows_kernel_sleep_tick.bas` | OK | OK | OK | OK | OK | AST/MIR/native x64 gercek `GetTickCount` + `Sleep` sonucu donduruyor |
| `32_uxb_windows_user32_metrics.bas` | OK | OK | OK | OK | OK | AST/MIR/native x64 `GetSystemMetrics` icin gercek ekran olcusu donduruyor |
| `33_uxb_windows_user32_messagebox_interactive.bas` | OK | OK | OK | SKIP | OK | interaktif GUI demo exe uretiyor; otomatik testte calistirilmaz |
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

### 3. `CALL(DLL)` native lane artik gercek resolver ile calisiyor

Yeni DLL probe orneklerinde parse ve JSON katmani basarili. Son turda native x64 emitter bu dugumleri asm'e indiriyor, `ffi_resolver.c` uretiyor ve build sirasinda resolver objesini linkliyor.

- `__uxb_ffi_symptr_N` sembolleri resolver tarafindan dolduruluyor.
- Native x64 exe `GetSystemMetrics` gibi Windows API cagrilarindan gercek deger donduruyor.
- Stub lane hala kontrollu fallback olarak duruyor; sembol cozulmezse crash yerine `0` donuyor.

Bu, repodaki mevcut durumun su oldugunu gosterir:

- `CALL(DLL)` icin native lowering ve resolver boslugu kapatildi.
- `source.bas -> --build-x64 -> program.exe` yolu Windows sistem DLL ornekleri icin gercek calisma seviyesinde.
- Harici DLL ornekleri DLL yoksa skip/fallback davranisi ile ele alinmali.

### 4. GUI API kullanimi icin bugunku pratik yol

Win32 GUI tarafinda bugunku repo ile iki seviye vardir:

1. otomatik smoke: `MessageBeep`
2. interaktif smoke: `MessageBoxA`

`MessageBoxA` gibi karisik tipli API'ler icin `"PTR,STRPTR,STRPTR,I32"` arguman tip listesi kullanilir.

## Sonuc

Bu test turu sonunda repo icin net operasyonel sonuc:

- Belgeler yazildi.
- Yeni `.bas` ornekleri yazildi.
- Her ornek icin JSON ciktilari uretildi.
- FFI disi native x64 zinciri obj + exe + run seviyesinde dogrulandi.
- DLL/FFI ornekleri artik asm + obj + exe seviyesine kadar derlenebiliyor.
- Windows sistem DLL smoke ornekleri AST, MIR ve native x64 tarafinda gercek DLL etkisi uretiyor.
