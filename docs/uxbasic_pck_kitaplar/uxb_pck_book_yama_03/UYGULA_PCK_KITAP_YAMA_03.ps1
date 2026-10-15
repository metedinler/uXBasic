param(
    [string]$Root = "."
)

$ErrorActionPreference = "Stop"
$PatchRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetRoot = (Resolve-Path $Root).Path

function Copy-Tree($rel) {
    $src = Join-Path $PatchRoot $rel
    $dst = Join-Path $TargetRoot $rel
    if (Test-Path $src) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
        Copy-Item $src $dst -Recurse -Force
    }
}

Copy-Tree "docs_src"
Copy-Tree "docs_examples"
Copy-Tree "tools\docs"

New-Item -ItemType Directory -Force -Path (Join-Path $TargetRoot "docs_build") | Out-Null

$extract = Join-Path $TargetRoot "tools\docs\extract_uxbasic_book_sources.py"
$build = Join-Path $TargetRoot "tools\docs\build_uxbasic_pck_book.py"

if (Test-Path $extract) {
    python $extract --root $TargetRoot --out (Join-Path $TargetRoot "docs_build\book_source_surface.json") --md-out (Join-Path $TargetRoot "docs_build\generated")
}

if (Test-Path $build) {
    python $build --root $TargetRoot --include-generated
}

Write-Host "OK: PCK kitap yaması 03 uygulandı." -ForegroundColor Green
Write-Host "Kitap: docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md" -ForegroundColor Green
Write-Host "Katman komutları: tools\docs\run_book_layer_outputs.ps1" -ForegroundColor Cyan
Write-Host "Proje örnekleri: docs_examples\book_projects" -ForegroundColor Cyan
