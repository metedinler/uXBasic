param([string]$Root = "")
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path "$PSScriptRoot\..\..").Path
} else {
    $Root = (Resolve-Path $Root).Path
}
& "$PSScriptRoot\build_uxpython_dll.bat"
exit $LASTEXITCODE
