param([string]$Root = "")
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($Root)) { $Root = (Resolve-Path "$PSScriptRoot\..\..").Path }
$powershellExe = (Get-Command powershell.exe -ErrorAction Stop).Source
& $powershellExe -NoProfile -ExecutionPolicy Bypass -File "$Root\compiler\scripts\resolve_uxb_toolchain.ps1" -Root $Root -RequireCompiler -RequireNative
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
$python = (Get-Command python -ErrorAction Stop).Source
& $python "$Root\tools\library_tools\uxb_library_abi.py" --root $Root --report-dir reports/libraries/abi
$abi = $LASTEXITCODE
& $python "$Root\tools\library_tools\uxb_library_layout_doctor.py" --root $Root
$layout = $LASTEXITCODE
& $python "$Root\tools\library_tools\uxb_library_export_audit.py" --root $Root --report-dir reports/libraries/exports --require-x64 --require-required
$exports = $LASTEXITCODE
$exe = Join-Path $Root "bin\uxb.exe"
if (!(Test-Path $exe)) { Write-Error "bin\uxb.exe yok"; exit 1 }
$bytes = [IO.File]::ReadAllBytes($exe)
$pe = [BitConverter]::ToInt32($bytes,0x3c)
$machine = [BitConverter]::ToUInt16($bytes,$pe+4)
$arch = if ($machine -eq 0x8664) { "x64" } elseif ($machine -eq 0x14c) { "x86" } else { "0x{0:X4}" -f $machine }
Write-Host "COMPILER_ARCH=$arch"
Write-Host "RUNTIME_DLL_DIR=$Root\bin"
Write-Host "DIST_DLL_DIR=$Root\dist\libraries\bin"
if ($abi -ne 0 -or $layout -ne 0 -or $exports -ne 0 -or $arch -ne "x64") { exit 1 }
exit 0
