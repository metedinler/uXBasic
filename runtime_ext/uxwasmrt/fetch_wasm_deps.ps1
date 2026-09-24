[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [switch]$Force,
    [switch]$SkipWabt
)
$ErrorActionPreference = "Stop"
$moduleRoot = Join-Path $Root "runtime_ext\uxwasmrt"
$lock = Get-Content -Raw -LiteralPath (Join-Path $moduleRoot "wasm.lock.json") | ConvertFrom-Json
$vendor = Join-Path $moduleRoot "vendor"
$tools = Join-Path $Root "tools\wabt\bin"
$bin = Join-Path $Root "bin"
New-Item -ItemType Directory -Force -Path $vendor, $tools, $bin | Out-Null
$headers = @{
    "User-Agent" = "uXBasic-wasm-dependency-fetcher"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}
if ($env:GITHUB_TOKEN) { $headers["Authorization"] = "Bearer $($env:GITHUB_TOKEN)" }

function Get-PinnedAsset([string]$repo, [string]$tag, [string]$exactName, [string]$wildcard) {
    $uri = "https://api.github.com/repos/$repo/releases/tags/$tag"
    $release = Invoke-RestMethod -Headers $headers -Uri $uri
    $assets = @($release.assets)
    if ($exactName) { $asset = $assets | Where-Object { $_.name -eq $exactName } | Select-Object -First 1 }
    else { $asset = $assets | Where-Object { $_.name -like $wildcard } | Select-Object -First 1 }
    if (-not $asset) {
        $names = ($assets | ForEach-Object { $_.name }) -join "`n  "
        throw "Pinned asset not found for $repo $tag. Available:`n  $names"
    }
    if (-not $asset.digest -or $asset.digest -notmatch '^sha256:[0-9a-fA-F]{64}$') {
        throw "GitHub did not publish a SHA-256 digest for $($asset.name); refusing an unverified download."
    }
    return $asset
}

function Download-Verified($asset, [string]$destination) {
    if ((Test-Path $destination) -and -not $Force) {
        $actual=(Get-FileHash -Algorithm SHA256 -LiteralPath $destination).Hash.ToLowerInvariant()
        $expected=($asset.digest -replace '^sha256:','').ToLowerInvariant()
        if ($actual -eq $expected) { Write-Host "[CACHE PASS] $([IO.Path]::GetFileName($destination))"; return }
    }
    Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri $asset.browser_download_url -OutFile $destination
    $actual=(Get-FileHash -Algorithm SHA256 -LiteralPath $destination).Hash.ToLowerInvariant()
    $expected=($asset.digest -replace '^sha256:','').ToLowerInvariant()
    if ($actual -ne $expected) { Remove-Item $destination -Force; throw "SHA-256 mismatch for $($asset.name)" }
    Write-Host "[HASH PASS] $($asset.name) $actual"
}

$wa=$lock.wasmtime
$wasmtimeAsset=Get-PinnedAsset $wa.repository $wa.tag $wa.asset $null
$wasmtimeZip=Join-Path $vendor $wasmtimeAsset.name
Download-Verified $wasmtimeAsset $wasmtimeZip
$wasmtimeStage=Join-Path $vendor "wasmtime-stage"
if (Test-Path $wasmtimeStage) { Remove-Item -Recurse -Force $wasmtimeStage }
Expand-Archive -LiteralPath $wasmtimeZip -DestinationPath $wasmtimeStage -Force
$wasmtimeDll=Get-ChildItem -LiteralPath $wasmtimeStage -Recurse -File -Filter "wasmtime.dll" | Select-Object -First 1
if (-not $wasmtimeDll) { throw "wasmtime.dll not found in the pinned C API package" }
$wasmtimeHome=Join-Path $vendor "wasmtime"
New-Item -ItemType Directory -Force -Path $wasmtimeHome | Out-Null
Get-ChildItem -LiteralPath $wasmtimeDll.DirectoryName -File -Filter "*.dll" | ForEach-Object {
    Copy-Item -Force $_.FullName (Join-Path $wasmtimeHome $_.Name)
    Copy-Item -Force $_.FullName (Join-Path $bin $_.Name)
}
Copy-Item -Force $wasmtimeDll.FullName (Join-Path $wasmtimeHome "wasmtime.dll")
Copy-Item -Force $wasmtimeDll.FullName (Join-Path $bin "wasmtime.dll")
$wasmtimeLicense = Get-ChildItem -LiteralPath $wasmtimeStage -Recurse -File | Where-Object { $_.Name -match '^LICENSE(?:\..*)?$' } | Select-Object -First 1
if ($wasmtimeLicense) { Copy-Item -Force $wasmtimeLicense.FullName (Join-Path $bin 'LICENSE.wasmtime.txt') }
Write-Host "[WASMTIME PASS] $(Join-Path $bin 'wasmtime.dll')"

if (-not $SkipWabt) {
    $wb=$lock.wabt
    $wabtAsset=Get-PinnedAsset $wb.repository $wb.tag $null $wb.assetPattern
    $wabtArchive=Join-Path $vendor $wabtAsset.name
    Download-Verified $wabtAsset $wabtArchive
    $wabtStage=Join-Path $vendor "wabt-stage"
    if (Test-Path $wabtStage) { Remove-Item -Recurse -Force $wabtStage }
    New-Item -ItemType Directory -Force -Path $wabtStage | Out-Null
    if ($wabtArchive.ToLowerInvariant().EndsWith('.zip')) {
        Expand-Archive -LiteralPath $wabtArchive -DestinationPath $wabtStage -Force
    } else {
        tar -xf $wabtArchive -C $wabtStage
        if ($LASTEXITCODE -ne 0) { throw "WABT archive extraction failed" }
    }
    foreach($name in @('wat2wasm.exe','wasm-validate.exe','wasm2wat.exe','wasm-interp.exe','wasm-objdump.exe')) {
        $tool=Get-ChildItem -LiteralPath $wabtStage -Recurse -File -Filter $name | Select-Object -First 1
        if ($tool) { Copy-Item -Force $tool.FullName (Join-Path $tools $name) }
    }
    if (-not (Test-Path (Join-Path $tools 'wat2wasm.exe'))) { throw "wat2wasm.exe missing after WABT extraction" }
    if (-not (Test-Path (Join-Path $tools 'wasm-validate.exe'))) { throw "wasm-validate.exe missing after WABT extraction" }
    $wabtLicense = Get-ChildItem -LiteralPath $wabtStage -Recurse -File | Where-Object { $_.Name -match '^LICENSE(?:\..*)?$' } | Select-Object -First 1
    if ($wabtLicense) { Copy-Item -Force $wabtLicense.FullName (Join-Path $tools 'LICENSE.wabt.txt') }
    Write-Host "[WABT PASS] $tools"
}

$resolved=[ordered]@{
  schema='uxb.wasm.external.resolved.v1'; generatedUtc=(Get-Date).ToUniversalTime().ToString('o')
  wasmtime=[ordered]@{tag=$wa.tag; asset=$wasmtimeAsset.name; digest=$wasmtimeAsset.digest}
  wabt=if($SkipWabt){$null}else{[ordered]@{tag=$wb.tag; asset=$wabtAsset.name; digest=$wabtAsset.digest}}
}
$resolved | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 (Join-Path $moduleRoot 'wasm.lock.resolved.json')
Write-Host "UXB_WASM_EXTERNAL_DEPS_PASS"
