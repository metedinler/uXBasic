param(
    [string]$Root = "",
    [switch]$RemoveSourceProducts
)
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($Root)) { $Root = (Resolve-Path "$PSScriptRoot\..\..").Path }
$dirs = @(
    "build\libraries", "dist\libraries\bin", "dist\libraries\deps",
    "dist\libraries\lib", "dist\libraries\logs", "dist\libraries\manifests",
    "reports\libraries", "tests\libraries", "bin"
)
foreach ($rel in $dirs) { New-Item -ItemType Directory -Force (Join-Path $Root $rel) | Out-Null }
$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCommand) { $pythonCommand = Get-Command py -ErrorAction SilentlyContinue }
if (-not $pythonCommand) { throw "Python 3 bulunamadi" }
$python = $pythonCommand.Source
& $python "$Root\tools\library_tools\uxb_library_build.py" --root $Root --deploy-only
if ($LASTEXITCODE -ne 0) { throw "Existing DLL staging failed" }
if ($RemoveSourceProducts) {
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $retired = Join-Path $Root "_retired\library_source_products\$stamp"
    $patterns = @("*.dll","*.exe","*.obj","*.o","*.a","*.lib")
    foreach ($rel in @("src","libsx","include","runtime_ext")) {
        $folder = Join-Path $Root $rel
        if (!(Test-Path $folder)) { continue }
        foreach ($pattern in $patterns) {
            Get-ChildItem $folder -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
                $relative = $_.FullName.Substring($Root.Length).TrimStart('\')
                $target = Join-Path $retired $relative
                New-Item -ItemType Directory -Force (Split-Path $target -Parent) | Out-Null
                Move-Item $_.FullName $target -Force
            }
        }
    }
    Write-Host "SOURCE_PRODUCTS_RETIRED_TO=$retired"
}
& $python "$Root\tools\library_tools\uxb_library_layout_doctor.py" --root $Root
exit $LASTEXITCODE
