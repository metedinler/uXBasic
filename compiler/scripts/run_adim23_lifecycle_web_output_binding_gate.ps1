param([switch]$NoRepair)
$ErrorActionPreference = "Continue"

function Resolve-RepoRoot {
  param([string]$StartDir)
  $cur = Resolve-Path $StartDir
  while ($true) {
    $uxbMain = Join-Path $cur "uxb\\src\\main.bas"
    $buildBat = Join-Path $cur "build_64.bat"
    if ((Test-Path $uxbMain) -and (Test-Path $buildBat)) {
      return $cur
    }
    $parent = Split-Path $cur -Parent
    if ($parent -eq $cur -or [string]::IsNullOrWhiteSpace($parent)) {
      throw "Repo root bulunamadi (uxb/src/main.bas + build_64.bat). Start=$StartDir"
    }
    $cur = $parent
  }
}

$Root = Resolve-RepoRoot $PSScriptRoot
Set-Location $Root
$Current = "uxb/reports/control/current"
$History = "uxb/reports/control/history"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Force $History | Out-Null
if (Test-Path $Current) {
  $items = Get-ChildItem $Current -Force -ErrorAction SilentlyContinue
  if ($items) {
    $target = Join-Path $History "adim23_$Stamp"
    New-Item -ItemType Directory -Force $target | Out-Null
    Move-Item "$Current\*" $target -Force
  }
}
New-Item -ItemType Directory -Force $Current | Out-Null

$gate = [ordered]@{ step="ADIM23"; ok=$false; build_exit_code=$null; notes=@(); missing=@() }

$required = @(
  "uxb/src/backend/backend_web_cli_args.fbs",
  "uxb/src/backend/backend_web_context_builder.fbs",
  "uxb/src/backend/backend_native_surface_scan.fbs",
  "uxb/src/backend/backend_web_pipeline.fbs",
  "uxb/src/main_output_contract_bridge.fbs"
)
foreach($f in $required){ if(!(Test-Path $f)){ $gate.missing += $f } }

if(Test-Path "build_64.bat"){
  cmd /c build_64.bat *> "$Current/adim23_compile.log"
  $gate.build_exit_code = $LASTEXITCODE
}else{
  $gate.notes += "build_64.bat bulunamadi; compile atlandi"
}

if($gate.missing.Count -eq 0 -and ($gate.build_exit_code -eq 0 -or $gate.build_exit_code -eq $null)){
  $gate.ok = $true
}

($gate | ConvertTo-Json -Depth 5) | Set-Content -Encoding UTF8 "$Current/adim23_lifecycle_web_output_binding_gate.json"
$gateText = if($gate.ok){ "# ADIM23 PASS" } else { "# ADIM23 FAIL" }
$gateText | Set-Content -Encoding UTF8 "$Current/adim23_lifecycle_web_output_binding_gate.md"
if(!$gate.ok){ exit 1 }
exit 0
