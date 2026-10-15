# UXB ABI10 Semantic Rebuild Fix — 2026-07-05

Bu paket, ABI10 smoke zincirindeki iki ayrı hatayı tek yerde toplar:

1. `run_library_abi10_smoke.ps1` artık `uxb.exe` çağrısında kaynak dosyayı açıkça `--source` ile verir ve gerekirse `-s` fallback dener.
2. `CALL(DLL, ...)` / `CALL(API, ...)` içindeki `DLL`, `API`, dönüş tipi ve calling convention sözcükleri semantic/type katmanında değişken sanılmaz.
3. Önceki semantic yamasında FreeBASIC tarafından özel/builtin gibi yorumlanan `pos` yerel değişkenleri `childOrdinal` olarak değiştirildi. Bu, `Duplicated definition, pos` ve `Function result assignment outside of the function` hatasını kaldırır.

Değişen dosyalar:

- `compiler/scripts/run_library_abi10_smoke.ps1`
- `tests/libraries/abi10/build_abi10_test_dll.bat`
- `tests/libraries/abi10/build_abi10_test_dll.ps1`
- `src/semantic/semantic_step3_gate.fbs`
- `src/type_binding/type_infer_expr.fbs`

Uygulama:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
Expand-Archive -LiteralPath .\UXB_ABI10_SEMANTIC_REBUILD_FIX_20260705_DIRECT_ROOT.zip -DestinationPath . -Force
```

Sonra mutlaka x64 compiler yeniden derlenmelidir; aksi halde eski `bin/uxb.exe` eski semantic koduyla çalışır.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\build_uxb_main_64.ps1 `
  -Root . `
  -Force `
  -SkipX86
```

Ardından ABI10:

```powershell
$env:UXB_GCC = "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
$env:PATH = "C:\msys64\ucrt64\bin;$PWD\bin;$env:PATH"
.\tests\libraries\abi10\build_abi10_test_dll.bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\compiler\scripts\run_library_abi10_smoke.ps1 -Root . -SkipBuild
```
