param(
    [string]$Root = ".",
    [string]$Backend = "AST"
)

$ErrorActionPreference = "Stop"
$RootPath = (Resolve-Path $Root).Path
Set-Location $RootPath
$uxb = Join-Path $RootPath "bin\uxb.exe"
$examples = Join-Path $RootPath "docs_examples\book_projects"
$outRoot = Join-Path $RootPath "reports\book_examples"
New-Item -ItemType Directory -Force -Path $outRoot | Out-Null

Get-ChildItem $examples -Filter *.uxb | Sort-Object Name | ForEach-Object {
    $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)
    $out = Join-Path $outRoot $name
    New-Item -ItemType Directory -Force -Path $out | Out-Null
    & $uxb $_.FullName --execmem --interpreter-backend $Backend --stdout-out "$out\stdout.txt" --stderr-out "$out\stderr.txt" --run-report-json-out "$out\run_report.json" --ast-json-out "$out\ast.json" --mir-json-out "$out\mir.json"
    Write-Host "OK: $($_.Name) -> $out" -ForegroundColor Green
}
