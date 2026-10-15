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

python (Join-Path $RootPath "tools\docs\extract_uxbasic_book_sources.py") --root $RootPath --out "docs_build\book_source_surface.json" --generated-dir "docs_build\generated"
python (Join-Path $RootPath "tools\docs\build_uxbasic_pck_book.py") --root $RootPath --out "docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md" --include-generated
Write-Host "OK: PCK kitap yaması 02 uygulandı." -ForegroundColor Green
Write-Host "Çıktı: docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md"
Write-Host "Otomatik ekler: docs_build\generated\"
