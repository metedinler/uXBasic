param(
    [string]$Root = "",
    [string]$Version = "1.0.41"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path "$PSScriptRoot\..\..").Path
} else {
    $Root = (Resolve-Path $Root).Path
}

$assetName = "wabt-$Version-windows-x64.tar.gz"
$baseUrl = "https://github.com/WebAssembly/wabt/releases/download/$Version"
$cacheDir = Join-Path $Root "build\deps\wabt\$Version"
$archivePath = Join-Path $cacheDir $assetName
$checksumPath = "$archivePath.sha256"
$extractDir = Join-Path $cacheDir "extracted"
$installDir = Join-Path $Root "tools\wabt\bin"

New-Item -ItemType Directory -Force $cacheDir,$extractDir,$installDir | Out-Null

Invoke-WebRequest -Uri "$baseUrl/$assetName" -OutFile $archivePath
Invoke-WebRequest -Uri "$baseUrl/$assetName.sha256" -OutFile $checksumPath

$expectedHash = ((Get-Content $checksumPath -Raw).Trim() -split '\s+')[0].ToUpperInvariant()
$actualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash.ToUpperInvariant()
if ($expectedHash -ne $actualHash) {
    throw "WABT SHA256 mismatch: expected=$expectedHash actual=$actualHash"
}

& tar.exe -xzf $archivePath -C $extractDir
if ($LASTEXITCODE -ne 0) { throw "WABT archive extraction failed: exit=$LASTEXITCODE" }

$wat2wasm = Get-ChildItem $extractDir -Filter wat2wasm.exe -File -Recurse | Select-Object -First 1
if (-not $wat2wasm) { throw "wat2wasm.exe not found in $assetName" }

Copy-Item -Path (Join-Path $wat2wasm.Directory.FullName "*") -Destination $installDir -Recurse -Force

@{
    schema = "uxb.toolchain.wabt.v1"
    status = "PASS"
    version = $Version
    source = "$baseUrl/$assetName"
    sha256 = $actualHash
    wat2wasm = (Join-Path $installDir "wat2wasm.exe")
    installed_at = (Get-Date).ToString("o")
} | ConvertTo-Json | Set-Content (Join-Path $installDir "install_manifest.json") -Encoding UTF8

& (Join-Path $installDir "wat2wasm.exe") --version
if ($LASTEXITCODE -ne 0) { throw "installed wat2wasm self-check failed" }

Write-Host "PASS: WABT $Version installed at $installDir"
