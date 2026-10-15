param(
    [string]$Root = "."
)
$ErrorActionPreference = "Stop"
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootPath = Resolve-Path $Root

$items = @("docs_src", "docs_build", "tools")
foreach ($item in $items) {
    $src = Join-Path $Here $item
    $dst = Join-Path $RootPath $item
    if (Test-Path $src) {
        Copy-Item $src $dst -Recurse -Force
    }
}

python (Join-Path $RootPath "tools\docs\build_uxbasic_pck_book.py") --root $RootPath --out "docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md"
Write-Host "OK: PCK kitap yaması uygulandı." -ForegroundColor Green
Write-Host "Çıktı: docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md"
