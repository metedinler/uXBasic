param([string]$Root = ".")
$ErrorActionPreference = "Stop"
$RootPath = Resolve-Path $Root
$PatchPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "PCK Kitap Yama 04 uygulanıyor: $RootPath"

$items = @("docs_src", "docs_examples", "tools")
foreach ($item in $items) {
    $src = Join-Path $PatchPath $item
    if (Test-Path $src) {
        Copy-Item $src -Destination $RootPath -Recurse -Force
        Write-Host "OK: kopyalandı: $item"
    }
}

$gen = Join-Path $RootPath "tools\docs\generate_external_library_docs.py"
if (Test-Path $gen) {
    Write-Host "Dış kütüphane belgeleri hedef kaynaktan yeniden üretiliyor..."
    python $gen --root $RootPath --update-order
}

$builder = Join-Path $RootPath "tools\docs\build_uxbasic_pck_book.py"
if (Test-Path $builder) {
    python $builder --root $RootPath --out "docs_build/uxbasic_resmi_teknik_kitap_12_06_1.md" --include-generated
}

Write-Host "OK: Yama 04 tamamlandı. Ana kitap: docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md"
