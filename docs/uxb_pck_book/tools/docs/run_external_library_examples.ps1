param(
    [string]$Root = ".",
    [ValidateSet("AST", "MIR")]
    [string]$Backend = "AST"
)
$ErrorActionPreference = "Stop"
$RootPath = Resolve-Path $Root
$uxb = Join-Path $RootPath "bin\uxb.exe"
$examples = Join-Path $RootPath "docs_examples\external_libraries"
$reportRoot = Join-Path $RootPath "reports\book_external_library_examples"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outDir = Join-Path $reportRoot $stamp
New-Item -ItemType Directory -Force $outDir | Out-Null
if (!(Test-Path $uxb)) { throw "uxb.exe bulunamadı: $uxb" }
if (!(Test-Path $examples)) { throw "örnek klasörü bulunamadı: $examples" }
$files = Get-ChildItem $examples -Recurse -Filter *.uxb | Sort-Object FullName
$csv = Join-Path $outDir "external_library_example_results.csv"
"file,backend,exit_code,log" | Set-Content -Encoding UTF8 $csv
foreach ($f in $files) {
    $rel = Resolve-Path -Relative $f.FullName
    $safe = ($rel -replace '[\\/:*?"<>|]', '_')
    $log = Join-Path $outDir ($safe + ".log")
    if ($Backend -eq "AST") {
        & $uxb $f.FullName --execmem --interpreter-backend AST 2>&1 | Tee-Object -FilePath $log | Out-Null
    } else {
        & $uxb $f.FullName --execmem --interpreter-backend MIR 2>&1 | Tee-Object -FilePath $log | Out-Null
    }
    $code = $LASTEXITCODE
    "`"$rel`",$Backend,$code,`"$log`"" | Add-Content -Encoding UTF8 $csv
}
Write-Host "OK: rapor yazıldı: $csv"
