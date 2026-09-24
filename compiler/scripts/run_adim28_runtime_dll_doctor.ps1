param([switch]$NoRepair)

$ErrorActionPreference = "Stop"
$repo = Get-Location
while ($repo -and !(Test-Path (Join-Path $repo "uxb/src/main.bas"))) {
  $parent = Split-Path $repo -Parent
  if ($parent -eq $repo) { break }
  $repo = $parent
}
if (!(Test-Path (Join-Path $repo "uxb/src/main.bas"))) {
  Write-Error "Repo root bulunamadi."
  exit 1
}
Set-Location $repo

$current = "uxb/reports/control/current"
New-Item -ItemType Directory -Force $current | Out-Null

$runtimeDir = "uxb/dist/runtime_ext"
New-Item -ItemType Directory -Force $runtimeDir | Out-Null

$rows = @()
$expected = @(
  @{ name="uxb_fp80.dll"; family="F80"; sourceHints=@("libs/runtime_ext/uxb_fp80_fb.bas","src/runtime/extfp/uxb_fp80_fb.bas","tools/runtime_ext/uxb_fp80_fb.bas") },
  @{ name="uxb_fp128.dll"; family="F128"; sourceHints=@("libs/runtime_ext/uxb_fp128_quad.c","src/runtime/extfp/uxb_fp128_quad.c","tools/runtime_ext/uxb_fp128_quad.c") },
  @{ name="uxb_bigfp.dll"; family="BIGF_BIGD_BALL"; sourceHints=@("libs/runtime_ext/uxb_bigfp.c","src/runtime/extfp/uxb_bigfp.c","tools/runtime_ext/uxb_bigfp.c") }
)

foreach ($e in $expected) {
  $dllPath = Join-Path $runtimeDir $e.name
  $srcPath = $null
  foreach ($h in $e.sourceHints) {
    if (Test-Path $h) { $srcPath = $h; break }
  }

  $status = "MISSING_DLL"
  $action = "SOURCE_MISSING"
  if (Test-Path $dllPath) {
    $status = "DLL_EXISTS"
    $action = "NO_BUILD_NEEDED"
  } elseif ($srcPath) {
    $status = "SOURCE_FOUND_DLL_MISSING"
    $action = "BUILD_REQUIRED"
    if ($srcPath.ToLower().EndsWith(".bas")) {
      $fbc = "tools/FreeBASIC-1.10.1-win64/fbc.exe"
      if (!(Test-Path $fbc)) { $fbc = "fbc.exe" }
      & $fbc -dll -x $dllPath $srcPath
      if ($LASTEXITCODE -eq 0 -and (Test-Path $dllPath)) { $status = "BUILT"; $action = "OK" } else { $status = "BUILD_FAIL"; $action = "CHECK_FBC_LOG" }
    } elseif ($srcPath.ToLower().EndsWith(".c")) {
      $gcc = "gcc"
      & $gcc -shared -O2 -o $dllPath $srcPath
      if ($LASTEXITCODE -eq 0 -and (Test-Path $dllPath)) { $status = "BUILT"; $action = "OK" } else { $status = "BUILD_FAIL"; $action = "CHECK_GCC_LOG" }
    }
  }

  $rows += [pscustomobject]@{
    dll = $e.name
    family = $e.family
    expected_path = $dllPath
    source = $(if ($srcPath) { $srcPath } else { "" })
    status = $status
    action = $action
  }
}

$csv = Join-Path $current "adim28_runtime_dll_matrix.csv"
$rows | Export-Csv -NoTypeInformation -Encoding UTF8 $csv

$failCount = ($rows | Where-Object { $_.status -notin @("DLL_EXISTS","BUILT") }).Count
$json = @"
{
  "step": "ADIM28_RUNTIME_DLL_DOCTOR",
  "ok": $((($failCount -eq 0)).ToString().ToLower()),
  "fail_count": $failCount,
  "matrix": "uxb/reports/control/current/adim28_runtime_dll_matrix.csv",
  "runtime_dir": "$runtimeDir",
  "note": "Bu script sahte DLL üretmez. Kaynak yoksa SOURCE_MISSING raporlar."
}
"@
$json | Set-Content -Encoding UTF8 (Join-Path $current "adim28_runtime_dll_gate.json")
if ($failCount -eq 0) { exit 0 } else { exit 1 }
