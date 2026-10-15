# uXBasic test komutları — ABI10 / runtime / release hattı

Bu liste kök klasör için hazırlanmıştır:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
```

## 0. Yama uygulama ve marker kontrolü

```powershell
Expand-Archive `
  -LiteralPath .\UXB_ABI10_MIR_MAIN_RECURSIVE_BODY_FIX_20260711_DIRECT_ROOT.zip `
  -DestinationPath . `
  -Force

Select-String `
  -Path .\src\semantic\mir_tail.fbs,.\Collect_UXB_Debug.ps1 `
  -Pattern "ABI10_MIR_MAIN_BODY_RECURSIVE_FIX|RebuildCompiler|abi10_mir_diagnostics_json"
```

## 1. Compiler build — elle sorulu/debug script ile

`bin\uxb.exe` varsa sorar:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\Collect_UXB_Debug.ps1 `
  -Root . `
  -RunBuildAndTests `
  -IncludeCBackendProbe
```

Sormadan build yapma:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\Collect_UXB_Debug.ps1 `
  -Root . `
  -RunBuildAndTests `
  -IncludeCBackendProbe `
  -RebuildCompiler No
```

Sormadan build yap:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\Collect_UXB_Debug.ps1 `
  -Root . `
  -RunBuildAndTests `
  -IncludeCBackendProbe `
  -RebuildCompiler Yes
```

Doğrudan build:

```powershell
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

## 2. Compiler mimari kontrolü

```powershell
C:\msys64\ucrt64\bin\objdump.exe -f .\bin\uxb.exe
```

Beklenen:

```text
file format pei-x86-64
architecture: i386:x86-64
```

## 3. ABI10 DLL build

```powershell
$env:UXB_GCC = "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
$env:PATH = "C:\msys64\ucrt64\bin;$PWD\bin;$env:PATH"

.\tests\libraries\abi10\build_abi10_test_dll.bat
```

Beklenen:

```text
OK: ...\build\libraries\tests\abi10\uxb_abi10_test.dll
```

## 4. ABI10 smoke — AST/MIR/x64/web sıralı kapı

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\run_library_abi10_smoke.ps1 `
  -Root . `
  -SkipBuild
```

Beklenen son hedef:

```text
PASS: AST interpreter, MIR interpreter, AST-x64 and web fail-close ABI10 tests
```

## 5. ABI10 manuel AST testi

```powershell
.\bin\uxb.exe `
  --source tests\libraries\abi10\abi10_smoke.uxb `
  --execmem `
  --interpreter-backend AST `
  --console-mode direct `
  --stdout-out .\reports\libraries\tests\abi10\manual_ast.stdout.txt `
  --stderr-out .\reports\libraries\tests\abi10\manual_ast.stderr.txt `
  --program-output-out .\reports\libraries\tests\abi10\manual_ast.program_output.txt `
  --ast-exec-result-json-out .\reports\libraries\tests\abi10\manual_ast.exec.json `
  --runtime-trace-json-out .\reports\libraries\tests\abi10\manual_ast.runtime_trace.json
```

Kontrol:

```powershell
bat .\reports\libraries\tests\abi10\manual_ast.stdout.txt
```

Beklenen:

```text
PASS_ABI10
```

## 6. ABI10 manuel MIR testi + JSON teşhis

```powershell
New-Item -ItemType Directory -Force .\reports\libraries\tests\abi10\manual_mir_diag | Out-Null

.\bin\uxb.exe `
  --source tests\libraries\abi10\abi10_smoke.uxb `
  --execmem `
  --interpreter-backend MIR `
  --mir-verify `
  --console-mode direct `
  --stdout-out .\reports\libraries\tests\abi10\manual_mir_diag\mir.stdout.txt `
  --stderr-out .\reports\libraries\tests\abi10\manual_mir_diag\mir.stderr.txt `
  --program-output-out .\reports\libraries\tests\abi10\manual_mir_diag\mir.program_output.txt `
  --ast-json-out .\reports\libraries\tests\abi10\manual_mir_diag\ast.json `
  --semantic-mir-json-out .\reports\libraries\tests\abi10\manual_mir_diag\semantic_mir.json `
  --canonical-mir-json-out .\reports\libraries\tests\abi10\manual_mir_diag\canonical_mir.json `
  --mir-verify-semantic-json-out .\reports\libraries\tests\abi10\manual_mir_diag\mir_verify_semantic.json `
  --mir-verify-canonical-json-out .\reports\libraries\tests\abi10\manual_mir_diag\mir_verify_canonical.json `
  --mir-exec-result-json-out .\reports\libraries\tests\abi10\manual_mir_diag\mir_exec_result.json `
  --runtime-trace-json-out .\reports\libraries\tests\abi10\manual_mir_diag\runtime_trace.json `
  --run-report-json-out .\reports\libraries\tests\abi10\manual_mir_diag\run_report.json
```

Kontrol:

```powershell
bat .\reports\libraries\tests\abi10\manual_mir_diag\mir.stdout.txt
bat .\reports\libraries\tests\abi10\manual_mir_diag\canonical_mir.json
```

Beklenen:

```text
PASS_ABI10
```

## 7. Kütüphane gate testleri

```powershell
python .\tools\library_tools\uxb_library_source_gate.py `
  --root . `
  --report-dir .\reports\control\current\lib_source_gate

python .\tools\library_tools\uxb_library_abi.py `
  --root . `
  --report-dir .\reports\control\current\lib_abi

python .\tools\library_tools\uxb_library_export_audit.py `
  --root . `
  --report-dir .\reports\control\current\lib_export `
  --require-x64

python .\tools\library_tools\uxb_library_layout_doctor.py --root .
```

Son logda beklenen/görülen:

```text
SOURCE_GATE status=PASS checks=227 fail=0
ABI calls=542 errors=0 mismatches=0 fixed=0 max_arity=8
DLL export audit status=PASS dlls=23 failures=0
Library layout status=PASS errors=0 checks=89
```

## 8. Runtime DLL davranış testleri

```powershell
.\run_yama6_runtime_abi_tests.bat
.\run_yama7_libuv_backend_tests.bat
.\run_yama8_tbb_backend_tests.bat
```

Beklenen:

```text
YAMA6_RUNTIME status=PASS
```

## 9. Interpreter runtime testleri

PowerShell için:

```powershell
$env:UXB_NATIVE_INTERP_CALLBACKS = "1"
.\run_yama6_interpreter_tests.bat
```

CMD için:

```cmd
set UXB_NATIVE_INTERP_CALLBACKS=1
run_yama6_interpreter_tests.bat
```

Bu hat başarısızsa rapor klasörleri ayrıca incelenmelidir.

## 10. Release triple pipeline

```powershell
python .\tool_py\tools\release_runners_py\run_uxb_release_triple_pipeline.py `
  --root . `
  --tests xtestx `
  --uxb .\bin\uxb.exe `
  --lanes all `
  --limit 20 `
  --timeout 120 `
  --wat2wasm .\tools\wabt\bin\wat2wasm.exe
```

Beklenen üretim hedefi:

```text
status=PASS
pass=20
fail=0
```

## 11. Debug paket toplama

Yeniden build sorulsun:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\Collect_UXB_Debug.ps1 `
  -Root . `
  -RunBuildAndTests `
  -IncludeCBackendProbe
```

Yeniden build kesin yapılmasın:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\Collect_UXB_Debug.ps1 `
  -Root . `
  -RunBuildAndTests `
  -IncludeCBackendProbe `
  -RebuildCompiler No
```

Tam kaynak snapshot da eklensin:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\Collect_UXB_Debug.ps1 `
  -Root . `
  -RunBuildAndTests `
  -IncludeCBackendProbe `
  -IncludeFullSrc `
  -RebuildCompiler No
```
