[CmdletBinding()]
param([string]$Uxb = ".\bin\uxb.exe", [string]$TestRoot = ".\tests\libraries\uxraylib")
# uxraylib (raylib/raygui koprusu, CPU-tarafi Image API'si) duman testleri: her program dort motorda (AST, canonical-MIR, native x64, legacy AST-x64)
# calistirilir. Beklenen: programin son PRINT'i olan "<AD>_PASS" satiri. CODEPTR kullanan (geri cagirma) testlerde
# yorumlayicilar (AST/MIR) gercek kod adresi veremez -> NET "requires native x64" hatasi beklenir (S-076); native ve legacy PASS verir.
# Onkosul: bin\uxraylib.dll (+ libraylib.dll, glfw3.dll); runtime_ext\uxraylib\build_wrappers.bat uretir; derleme bagimliliklari PE import tablosundan bulup cikti klasorune kopyalar. Testler PENCERE ACMAZ.
$ErrorActionPreference = "Continue"
function Norm([string]$s) { (($s -replace "`r","") -split "`n" | Where-Object { $_ -notmatch '^INFO|^WARN|^\s*$' }) -join "`n" }
$pass = 0; $fail = 0
foreach ($f in Get-ChildItem $TestRoot -Filter *.uxb | Sort-Object Name) {
  $src = Get-Content $f.FullName -Raw
  $m = [regex]::Match($src, 'PRINT\s+"([A-Z0-9_]+_PASS)"')
  if (-not $m.Success) { continue }
  $expected = $m.Groups[1].Value
  $needsNative = $src -match 'CODEPTR'
  $results = [ordered]@{}
  $results["AST"] = Norm ((& $Uxb run $f.FullName 2>&1) -join "`n")
  $results["MIR"] = Norm ((& $Uxb run $f.FullName --interpreter-backend MIR 2>&1) -join "`n")
  foreach ($mode in @(@("x64", @()), @("AST-x64", @("--x64-mode","AST")))) {
    $o = (& $Uxb bld $f.FullName @($mode[1]) -o "out\ray_$($mode[0]).exe" 2>&1) -join "`n"
    $bm = [regex]::Match($o, "build tamamlandi: (.+)")
    $results[$mode[0]] = if ($bm.Success) { Norm ((& $bm.Groups[1].Value.Trim() 2>&1) -join "`n") } else { "BUILDFAIL: " + (Norm $o) }
  }
  foreach ($k in $results.Keys) {
    $interp = ($k -eq "AST" -or $k -eq "MIR")
    if ($needsNative -and $interp) { $ok = $results[$k].Contains("requires native x64"); $want = "icerir: requires native x64" }
    else { $ok = ($results[$k] -eq $expected); $want = $expected }
    if ($ok) { $pass++; Write-Host "  PASS $k/$($f.BaseName)" -ForegroundColor Green }
    else { $fail++; Write-Host "  FAIL $k/$($f.BaseName)`n    beklenen: $want`n    gelen   : $($results[$k] -replace "`n",' | ')" -ForegroundColor Red }
  }
}
"==================== OZET ===================="
"Toplam: $($pass+$fail)   PASS: $pass   FAIL: $fail"
if ($fail -eq 0) { "Tum kontroller gecti." } else { exit 1 }