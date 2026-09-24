param([switch]$NoRepair)
$ErrorActionPreference = 'Continue'
function Find-UxbRoot {
    $p=(Get-Location).Path
    while($true){
        if((Test-Path (Join-Path $p 'src\main.bas')) -and (Test-Path (Join-Path $p 'compiler\scripts'))){ return $p }
        $parent=Split-Path $p -Parent
        if($parent -eq $p){ throw 'uXBasic root not found' }
        $p=$parent
    }
}
$root=Find-UxbRoot
Set-Location $root
$current='reports/control/current'
New-Item -ItemType Directory -Force -Path $current | Out-Null
$log=Join-Path $current 'adim31b_canonical_check.log'
$cmd='compiler/scripts/run_adim30_10step_chain_suite.ps1'
if(!(Test-Path $cmd)){ throw "Missing $cmd" }
powershell -NoProfile -ExecutionPolicy Bypass -File $cmd -NoRepair *> $log
$exit=$LASTEXITCODE
$result=[ordered]@{
  step='ADIM31B_CANONICAL_SYNTAX_LAYER_CHECK';
  adim30_exit_code=$exit;
  gate='reports/control/current/adim30_10step_gate.json';
  result_csv='reports/control/current/adim30_10step_results.csv';
  canonical_import='IMPORT(C/CPP/ASM) only; no IMPORT DLL/API/LIB';
  placeholder_scan='not_run'
}
try{
  $rg=Get-Command rg -ErrorAction SilentlyContinue
  if($rg){
    & rg -n 'GENERATED_PLACEHOLDER|uxb-placeholder-artifact-1|placeholder artifact' reports/control/current 2>$null | Out-Null
    $result.placeholder_scan = if($LASTEXITCODE -eq 0){'FOUND'}else{'CLEAN'}
  }
}catch{ $result.placeholder_scan='ERROR' }
$result | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $current 'adim31b_canonical_check.json')
exit $exit
