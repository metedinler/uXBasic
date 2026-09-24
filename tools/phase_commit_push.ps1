param(
    [Parameter(Mandatory = $true)]
    [string]$Message,
    [switch]$SkipGate,
    [switch]$SkipPush
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not $SkipGate) {
    powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\run_faz_a_gate.ps1 -SkipBuild
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[HATA] Faz kapisi kirmizi. Commit/push durduruldu."
        exit $LASTEXITCODE
    }
}

git add -A
if ($LASTEXITCODE -ne 0) {
    Write-Host "[HATA] git add basarisiz."
    exit $LASTEXITCODE
}

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "[BILGI] Commitlenecek degisiklik yok."
    exit 0
}

git commit -m $Message
if ($LASTEXITCODE -ne 0) {
    Write-Host "[HATA] git commit basarisiz."
    exit $LASTEXITCODE
}

if ($SkipPush) {
    Write-Host "[UYARI] Push atlandi (--SkipPush)."
    exit 0
}

git push
if ($LASTEXITCODE -ne 0) {
    Write-Host "[HATA] git push basarisiz. Faz tamamlandi sayilmaz."
    exit $LASTEXITCODE
}

Write-Host "[BILGI] Faz commit+push tamamlandi."
exit 0
