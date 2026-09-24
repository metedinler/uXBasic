[CmdletBinding()]
param(
 [string]$Root=(Resolve-Path (Join-Path $PSScriptRoot '..\..')),
 [switch]$SkipCompilerBuild,
 [switch]$SkipLibraryBuild,
 [switch]$SkipQuickJsBuild,
 [switch]$SkipNativeX64,
 [switch]$SkipFullRegression,
 [switch]$SkipPackage
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$Root=(Resolve-Path -LiteralPath $Root).Path
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$ReportDir=Join-Path $Root ('reports\final_ffi_quickjs_release\'+$stamp)
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
$env:PATH=(Join-Path $Root 'bin')+';C:\msys64\ucrt64\bin;'+$env:PATH
$stages=[ordered]@{}
function Invoke-Checked {
 param([string]$Name,[string]$FilePath,[string[]]$Arguments=@(),[int]$TimeoutSeconds=600,[string]$WorkingDirectory=$Root,[string]$Marker='')
 $log=Join-Path $ReportDir ($Name+'.log')
 $psi=[Diagnostics.ProcessStartInfo]::new(); $psi.FileName=$FilePath; $psi.WorkingDirectory=$WorkingDirectory; $psi.UseShellExecute=$false; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true; $psi.CreateNoWindow=$true
 if($null -ne $psi.PSObject.Properties['ArgumentList']){
  foreach($item in $Arguments){[void]$psi.ArgumentList.Add([string]$item)}
 } else {
  # Windows PowerShell 5.1 / .NET Framework has no ProcessStartInfo.ArgumentList.
  # Quote every token so spaces and empty arguments remain distinct.
  $quoted=@()
  foreach($item in $Arguments){
   $token=[string]$item
   $token=$token.Replace('"','\"')
   $quoted+=('"' + $token + '"')
  }
  $psi.Arguments=($quoted -join ' ')
 }
 $p=[Diagnostics.Process]::new();$p.StartInfo=$psi
 if(-not $p.Start()){throw "Cannot start $Name"}
 $outTask=$p.StandardOutput.ReadToEndAsync();$errTask=$p.StandardError.ReadToEndAsync()
 if(-not $p.WaitForExit($TimeoutSeconds*1000)){try{$p.Kill($true)}catch{};throw "TIMEOUT $Name"}
 $stdout=$outTask.GetAwaiter().GetResult();$stderr=$errTask.GetAwaiter().GetResult();($stdout+$(if($stderr){"`n--- STDERR ---`n"+$stderr}else{''})) | Set-Content -Encoding UTF8 $log
 if($p.ExitCode -ne 0){throw "$Name failed exit=$($p.ExitCode); see $log"}
 if($Marker -and (($stdout+"`n"+$stderr) -notmatch [regex]::Escape($Marker))){throw "$Name marker missing: $Marker"}
 $stages[$Name]=[ordered]@{status='PASS';exitCode=$p.ExitCode;log=$log;marker=$Marker}
 return ($stdout+"`n"+$stderr)
}
function Run-ScriptCandidate([string]$Name,[object[]]$Candidates,[int]$Timeout=900){
 foreach($c in $Candidates){$rel=[string]$c.path;$full=Join-Path $Root $rel;if(-not(Test-Path $full)){continue};$ext=[IO.Path]::GetExtension($full).ToLowerInvariant();$a=@();if($c.ContainsKey('args') -and $null -ne $c['args']){$a=@($c['args'])}
  if($ext -eq '.ps1'){ $pwsh=(Get-Command pwsh.exe -ErrorAction Stop).Source; Invoke-Checked $Name $pwsh (@('-NoProfile','-ExecutionPolicy','Bypass','-File',$full)+$a) $Timeout | Out-Null }
  elseif($ext -in @('.bat','.cmd')){ Invoke-Checked $Name 'cmd.exe' (@('/d','/s','/c',$full)+$a) $Timeout | Out-Null }
  else{throw "Unsupported script $full"};return }
 throw "No candidate found for $Name"
}
try {
 Invoke-Checked 'static_gate' 'python' @('tools\diagnostics\verify_final_ffi_quickjs_release.py','--root',$Root,'--json-out',(Join-Path $ReportDir 'static.json')) 180 $Root '"status": "PASS"' | Out-Null
 if(-not $SkipLibraryBuild){
  Run-ScriptCandidate 'build_uxffi' @(@{path='runtime_ext\uxffi\build_uxffi_dll.bat'}) 420
  Run-ScriptCandidate 'build_freebasic_a_group' @(@{path='compiler\scripts\build_freebasic_a_group.ps1';args=@('-Root',$Root)},@{path='compiler\scripts\build_freebasic_a_group.bat'}) 1200
 }
 if(-not $SkipQuickJsBuild){Run-ScriptCandidate 'build_uxjsruntime' @(@{path='compiler\scripts\build_uxjsruntime.ps1';args=@('-Root',$Root)},@{path='runtime_ext\uxjsruntime\build_uxjsrt.ps1';args=@('-Root',$Root,'-SkipFetch')},@{path='runtime_ext\uxjsruntime\build_uxjsrt.bat'}) 1200}
 if(-not $SkipCompilerBuild){Run-ScriptCandidate 'build_compiler' @(@{path='build_64.bat'},@{path='build_64.ps1'},@{path='compiler\scripts\build_64.bat'},@{path='compiler\scripts\build_64.ps1'}) 1800}
 Invoke-Checked 'native_uxconfig_roundtrip' 'python' @('tests\libraries\ffi_final\test_uxffi_uxconfig_roundtrip.py','--root',$Root) 300 $Root 'UXFFI_UXCONFIG_ROUNDTRIP_PASS' | Out-Null
 $pwsh=(Get-Command pwsh.exe -ErrorAction Stop).Source
 $contractArgs=@('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $Root 'tools\tests\run_ffi_contract_fix.ps1'),'-Root',$Root,'-Uxb',(Join-Path $Root 'bin\uxb.exe'),'-BuildUxffi')
 if(-not $SkipNativeX64){$contractArgs+='-RunX64'}
 Invoke-Checked 'ffi_contract_matrix' $pwsh $contractArgs 1200 $Root 'UXB_FFI_CONTRACT_FIX_PASS' | Out-Null
 $uxb=Join-Path $Root 'bin\uxb.exe';$source='tests\libraries\ffi_final\ffi_freebasic_roundtrip.uxb'
 foreach($backend in @('AST','MIR')){Invoke-Checked ('interpreter_'+$backend.ToLower()) $uxb @('int',$source,'--interpreter-backend',$backend) 300 $Root 'UXB_FFI_FREEBASIC_ROUNDTRIP_PASS'|Out-Null}
 if(-not $SkipNativeX64){foreach($backend in @('AST','MIR')){$exe=Join-Path $ReportDir ('roundtrip_'+$backend.ToLower()+'.exe');$a=@($source,'--build-x64','--codegen-source',$backend,'--build-x64-out',$exe);if($backend -eq 'MIR'){$a+=@('--x64-mode','MIR','--mir-verify')};Invoke-Checked ('build_x64_'+$backend.ToLower()) $uxb $a 600 $Root|Out-Null;Invoke-Checked ('run_x64_'+$backend.ToLower()) $exe @() 180 $Root 'UXB_FFI_FREEBASIC_ROUNDTRIP_PASS'|Out-Null}}
 if(Test-Path (Join-Path $Root 'tests\libraries\uxjsruntime\test_uxjsrt.py')){Invoke-Checked 'quickjs_native_smoke' 'python' @('tests\libraries\uxjsruntime\test_uxjsrt.py','--root',$Root) 420 $Root 'UXJSRT_NATIVE_SMOKE_PASS'|Out-Null}
 Invoke-Checked 'quickjs_generated_e2e' 'python' @('tests\libraries\uxjsruntime\test_generated_js_e2e.py','--root',$Root) 420 $Root 'UXJSRT_GENERATED_JS_E2E_PASS'|Out-Null
 if(-not $SkipFullRegression){
  $runner=Join-Path $Root 'xtestx\_runners\run_xtestx_expected_tests.py'
  if(Test-Path $runner){Invoke-Checked 'xtestx_expected_full' 'python' @($runner,'--root',$Root,'--tests',(Join-Path $Root 'xtestx'),'--uxb',$uxb) 7200 $Root|Out-Null}else{$stages['xtestx_expected_full']=@{status='SKIP';detail='runner not found'}}
  $surface=Join-Path $Root 'compiler\scripts\run_language_surface_full_matrix.bat'
  if(Test-Path $surface){Invoke-Checked 'language_surface_full_matrix' 'cmd.exe' @('/d','/s','/c',$surface) 3600 $Root|Out-Null}else{$stages['language_surface_full_matrix']=@{status='SKIP';detail='script not found'}}
 }
 $summaryPath=Join-Path $ReportDir 'summary.json'
 $summary=[ordered]@{schema='uxb.final-ffi-quickjs-release-gate.v1';status='PASS';generatedAt=(Get-Date).ToString('o');root=$Root;reportDir=$ReportDir;stages=$stages;package='NOT_RUN'}
 $summary|ConvertTo-Json -Depth 8|Set-Content -Encoding UTF8 $summaryPath
 if(-not $SkipPackage){$pack=Join-Path $Root 'tools\release\package_uxbasic_distribution_final.ps1';$txt=Invoke-Checked 'package_distribution' $pwsh @('-NoProfile','-ExecutionPolicy','Bypass','-File',$pack,'-Root',$Root,'-GateSummary',$summaryPath) 3600 $Root 'UXB_DISTRIBUTION_PACKAGE_PASS';$zipLine=($txt -split "`r?`n"|Where-Object{$_ -like 'RELEASE_ZIP=*'}|Select-Object -Last 1);if($zipLine){$summary.package=$zipLine.Substring(12)};$summary.stages=$stages;$summary|ConvertTo-Json -Depth 8|Set-Content -Encoding UTF8 $summaryPath}
 Write-Host 'UXB_FINAL_FFI_QUICKJS_RELEASE_GATE_PASS';Write-Host "SUMMARY=$summaryPath";if($summary.package -ne 'NOT_RUN'){Write-Host "RELEASE_ZIP=$($summary.package)"}
}
catch{
 $failure=[ordered]@{schema='uxb.final-ffi-quickjs-release-gate.v1';status='FAIL';generatedAt=(Get-Date).ToString('o');root=$Root;reportDir=$ReportDir;error=$_.Exception.Message;stages=$stages}
 $failure|ConvertTo-Json -Depth 8|Set-Content -Encoding UTF8 (Join-Path $ReportDir 'summary.json');Write-Error $_;Write-Host "FAILED_REPORT=$ReportDir";exit 1
}
