[CmdletBinding()]
param([string]$Uxb = ".\bin\uxb.exe", [string]$TestRoot = ".\tests\array_bounds")
# S-101 LBOUND/UBOUND: her test AST, canonical-MIR, native x64 (bld), legacy AST-x64 ve JS (jsw + node) motorlarinda calistirilir;
# ciktilar expected/<ad>.txt ile birebir karsilastirilir. expected/<ad>.engines.txt: yalniz o motorlar ("AST MIR x64 AST-x64 JS").
# expected/<ad>.contains.txt: "MOTOR=alt dize" - o motorun sonucu birebir degil, bu dizeyi ICERMELI (net red iletileri).
# WASM/WAT: derleme zamani sinirli diziler sabite katlanir (wasm_model paketi); calisma zamani sinirli dizi net reddedilir.
$ErrorActionPreference = "Continue"
function Norm([string]$s) { (($s -replace "`r","") -split "`n" | Where-Object { $_ -notmatch '^INFO|^WARN|^\s*$' }) -join "`n" }
$node = (Get-Command node -ErrorAction SilentlyContinue).Source
$tmpRoot = Join-Path ([IO.Path]::GetTempPath()) ("uxb_bounds_" + [Guid]::NewGuid().ToString("N").Substring(0, 8))
New-Item -ItemType Directory -Force $tmpRoot | Out-Null
$pass = 0; $fail = 0
try {
  foreach ($f in Get-ChildItem $TestRoot -Filter *.uxb | Sort-Object Name) {
    $enginesFile = Join-Path $TestRoot "expected\$($f.BaseName).engines.txt"
    $only = if (Test-Path $enginesFile) { ((Get-Content $enginesFile -Raw).Trim() -split "\s+") } else { @("AST","MIR","x64","AST-x64","JS") }
    $containsFile = Join-Path $TestRoot "expected\$($f.BaseName).contains.txt"
    $contains = @{}
    if (Test-Path $containsFile) { foreach ($ln in (Get-Content $containsFile)) { if ($ln -match "^\s*([^=]+)=(.*)$") { $contains[$Matches[1].Trim()] = $Matches[2] } } }
    $expected = if (Test-Path (Join-Path $TestRoot "expected\$($f.BaseName).txt")) { "$(Get-Content (Join-Path $TestRoot "expected\$($f.BaseName).txt") -Raw)".Trim() -replace "`r","" } else { "" }
    $results = [ordered]@{}
    if ($only -contains "AST") { $results["AST"] = Norm ((& $Uxb run $f.FullName 2>&1) -join "`n") }
    if ($only -contains "MIR") { $results["MIR"] = Norm ((& $Uxb run $f.FullName --interpreter-backend MIR 2>&1) -join "`n") }
    foreach ($mode in @(@("x64", @()), @("AST-x64", @("--x64-mode","AST")))) {
      if ($only -notcontains $mode[0]) { continue }
      $o = (& $Uxb bld $f.FullName @($mode[1]) -o (Join-Path $tmpRoot "ab_$($f.BaseName)_$($mode[0]).exe") 2>&1) -join "`n"
      $m = [regex]::Match($o, "build tamamlandi: (.+)")
      $results[$mode[0]] = if ($m.Success) { Norm ((& $m.Groups[1].Value.Trim() 2>&1) -join "`n") } else { "BUILDFAIL: " + (Norm $o) }
    }
    if ($only -contains "JS") {
      if (-not $node) { $results["JS"] = "HATA: node bulunamadi" }
      else {
        $jd = Join-Path $tmpRoot ($f.BaseName + "_js")
        New-Item -ItemType Directory -Force $jd | Out-Null
        $jo = (& $Uxb jsw $f.FullName --js-out "$jd\p.js" 2>&1) -join "`n"
        $results["JS"] = if (Test-Path "$jd\p.js") { Norm ((& $node "$jd\p.js" 2>&1) -join "`n") } else { "BUILDFAIL: " + (Norm $jo) }
      }
    }
    foreach ($k in $results.Keys) {
      if ($contains.ContainsKey($k)) { $okCase = $results[$k].Contains($contains[$k]) } else { $okCase = ($results[$k] -eq $expected) }
      if ($okCase) { $pass++; Write-Host "  PASS $k/$($f.BaseName)" -ForegroundColor Green }
      else { $fail++; Write-Host "  FAIL $k/$($f.BaseName)`n    beklenen: $(if ($contains.ContainsKey($k)) { "icerir: " + $contains[$k] } else { $expected -replace "`n",' | ' })`n    gelen   : $($results[$k] -replace "`n",' | ')" -ForegroundColor Red }
    }
  }
} finally { if (Test-Path $tmpRoot) { try { [IO.Directory]::Delete($tmpRoot, $true) } catch {} } }
"==================== OZET ===================="
"Toplam: $($pass+$fail)   PASS: $pass   FAIL: $fail"
if ($fail -eq 0) { "Tum kontroller gecti." } else { exit 1 }
