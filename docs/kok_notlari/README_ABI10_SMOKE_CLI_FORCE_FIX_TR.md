# ABI10 Smoke CLI Force Fix

Bu yama, ABI10 smoke runner'ın `uxb.exe` çağrısında kaynak dosyasını kaybetmesi sorununu düzeltir.

Değişen dosyalar:

- `compiler/scripts/run_library_abi10_smoke.ps1`
- `tests/libraries/abi10/build_abi10_test_dll.bat`
- `tests/libraries/abi10/build_abi10_test_dll.ps1`

Ana düzeltmeler:

- `Run-Case` parametresi `$Args` değil `$BodyArgs`/`$CliArgs` mantığıyla çalışır.
- `uxb.exe` her zaman `--source tests\libraries\abi10\abi10_smoke.uxb` ile çağrılır.
- Eğer eski CLI yine kaynak yolu kaybederse `-s` ile bir kez daha dener.
- Her çağrı `reports\libraries\tests\abi10\abi10_invocations.log` içine yazılır.
- Process stdout/stderr ve compiler `--stdout-out/--stderr-out/--program-output-out` ayrı dosyalara alınır.
- ABI10 test DLL build betiği okunabilir ve bağımsız kalır.

Uygulama:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
Expand-Archive -LiteralPath .\UXB_ABI10_SMOKE_CLI_FORCE_FIX_20260705_DIRECT_ROOT.zip -DestinationPath . -Force
$env:UXB_GCC = "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
$env:PATH = "C:\msys64\ucrt64\bin;$PWD\bin;$env:PATH"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\compiler\scripts\run_library_abi10_smoke.ps1 -Root . -SkipBuild
```
