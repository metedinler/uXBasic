[CmdletBinding()]
param([string]$Uxb = ".\bin\uxb.exe", [string]$TestRoot = ".\tests\wasm_model")
# WASM/WAT ve JS davranis testleri (S-102: WASM/JS ciktisini GERCEKTEN calistiran guvenilir kosucu).
# Her program: AST yorumlayici (dil referansi), WASM (uxb wat --emit-wasm -> wat2wasm -> node run_wasm.js) ve JS (uxb jsw -> node p.js) ile
# calistirilir; ikisi de expected/<ad>.txt ile birebir eslesmeli. run_wasm.js ve ux_wasm_runtime.js her derlemede
# derleyici tarafindan TAZE uretilir (dist\wasm\ altindaki eski kopyalar kullanilmaz).
$ErrorActionPreference = "Continue"
function Norm([string]$s) { (($s -replace "`r","") -split "`n" | Where-Object { $_ -notmatch '^INFO|^WARN|^\s*$' }) -join "`n" }
$w2w = (Resolve-Path ".\tools\wabt\bin\wat2wasm.exe" -ErrorAction SilentlyContinue).Path
$node = (Get-Command node -ErrorAction SilentlyContinue).Source
if (-not $w2w -or -not $node) { "HATA: wat2wasm veya node bulunamadi (wat2wasm=$w2w node=$node)"; "Toplam: 0   PASS: 0   FAIL: 1"; exit 1 }
$tmpRoot = Join-Path ([IO.Path]::GetTempPath()) ("uxb_wasm_" + [Guid]::NewGuid().ToString("N").Substring(0, 8))
New-Item -ItemType Directory -Force $tmpRoot | Out-Null
$pass = 0; $fail = 0
try {
  foreach ($f in Get-ChildItem $TestRoot -Filter *.uxb | Sort-Object Name) {
    $expected = Norm (Get-Content (Join-Path $TestRoot "expected\$($f.BaseName).txt") -Raw)
    # expected\<ad>.contains.txt: "MOTOR=alt dize" -- o motorun sonucu birebir degil, bu dizeyi ICERMELI (net red iletileri)
    $contains = @{}
    $cf = Join-Path $TestRoot "expected\$($f.BaseName).contains.txt"
    if (Test-Path $cf) { foreach ($ln in (Get-Content $cf)) { if ($ln -match "^\s*([^=]+)=(.*)$") { $contains[$Matches[1].Trim()] = $Matches[2] } } }
    $results = [ordered]@{}
    $results["AST"] = Norm ((& $Uxb run $f.FullName 2>&1) -join "`n")
    $wd = Join-Path $tmpRoot $f.BaseName
    New-Item -ItemType Directory -Force $wd | Out-Null
    $o = (& $Uxb wat $f.FullName --emit-wasm --wasm-out "$wd\p.wasm" --wat-out "$wd\p.wat" "--wat2wasm=$w2w" 2>&1) -join "`n"
    if (Test-Path "$wd\p.wasm") { $results["WASM"] = Norm ((& $node "$wd\run_wasm.js" 2>&1) -join "`n") }
    else { $results["WASM"] = "BUILDFAIL: " + (Norm $o) }
    # JS hedefi (uxb jsw --js-out; ux_runtime.js yanina taze uretilir) ayni programla, ayni beklentiyle
    $jd = Join-Path $tmpRoot ($f.BaseName + "_js")
    New-Item -ItemType Directory -Force $jd | Out-Null
    $jo = (& $Uxb jsw $f.FullName --js-out "$jd\p.js" 2>&1) -join "`n"
    if (Test-Path "$jd\p.js") { $results["JS"] = Norm ((& $node "$jd\p.js" 2>&1) -join "`n") }
    else { $results["JS"] = "BUILDFAIL: " + (Norm $jo) }
    foreach ($k in $results.Keys) {
      if ($contains.ContainsKey($k)) { $okCase = $results[$k].Contains($contains[$k]) } else { $okCase = ($results[$k] -eq $expected) }
      if ($okCase) { $pass++; Write-Host "  PASS $k/$($f.BaseName)" -ForegroundColor Green }
      else { $fail++; Write-Host "  FAIL $k/$($f.BaseName)`n    beklenen: $($expected -replace "`n",' | ')`n    gelen   : $($results[$k] -replace "`n",' | ')" -ForegroundColor Red }
    }
  }
} finally { if (Test-Path $tmpRoot) { try { [IO.Directory]::Delete($tmpRoot, $true) } catch {} } }
"==================== OZET ===================="
"Toplam: $($pass+$fail)   PASS: $pass   FAIL: $fail"
if ($fail -eq 0) { "Tum kontroller gecti." } else { exit 1 }