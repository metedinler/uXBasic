param(
  [string]$Version = "latest"
)
$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
$DepDir = Join-Path $Root "uxb\dist\runtime_ext\deps\uxonnx"
$ArchiveDir = Join-Path $DepDir "archive"
New-Item -ItemType Directory -Force -Path $DepDir, $ArchiveDir | Out-Null

if ($Version -eq "latest") {
  $release = Invoke-RestMethod "https://api.github.com/repos/microsoft/onnxruntime/releases/latest"
} else {
  $release = Invoke-RestMethod "https://api.github.com/repos/microsoft/onnxruntime/releases/tags/v$Version"
}
$asset = $release.assets | Where-Object { $_.name -match "onnxruntime-win-x64-.*\.zip$" -and $_.name -notmatch "gpu|training" } | Select-Object -First 1
if (-not $asset) { throw "Could not find onnxruntime-win-x64 CPU zip asset" }
$zipPath = Join-Path $ArchiveDir $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
$ExtractDir = Join-Path $ArchiveDir ([IO.Path]::GetFileNameWithoutExtension($asset.name))
if (Test-Path $ExtractDir) { Remove-Item -Recurse -Force $ExtractDir }
Expand-Archive -Path $zipPath -DestinationPath $ArchiveDir -Force
$pkgRoot = Get-ChildItem $ArchiveDir -Directory | Where-Object { $_.Name -like "onnxruntime-win-x64-*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $pkgRoot) { throw "Extracted package root not found" }
New-Item -ItemType Directory -Force -Path (Join-Path $DepDir "include"), (Join-Path $DepDir "lib") | Out-Null
Copy-Item (Join-Path $pkgRoot.FullName "include\*") (Join-Path $DepDir "include") -Recurse -Force
Copy-Item (Join-Path $pkgRoot.FullName "lib\*") (Join-Path $DepDir "lib") -Recurse -Force
Copy-Item (Join-Path $pkgRoot.FullName "lib\onnxruntime.dll") (Join-Path $DepDir "onnxruntime.dll") -Force
$registry = [ordered]@{
  schema_version = "uxonnx-dependency-registry-1"
  package = "uxonnx"
  dependency = "onnxruntime"
  source = "microsoft/onnxruntime GitHub release"
  release_tag = $release.tag_name
  asset = $asset.name
  asset_url = $asset.browser_download_url
  local_dir = $DepDir
  include = "uxb/dist/runtime_ext/deps/uxonnx/include"
  lib = "uxb/dist/runtime_ext/deps/uxonnx/lib"
  dll = "uxb/dist/runtime_ext/deps/uxonnx/onnxruntime.dll"
}
$registry | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 (Join-Path $DepDir "uxonnx_dependency_registry.json")
"package,dependency,release_tag,asset,asset_url,local_dll" | Set-Content -Encoding UTF8 (Join-Path $DepDir "uxonnx_dependency_registry.csv")
"uxonnx,onnxruntime,$($release.tag_name),$($asset.name),$($asset.browser_download_url),uxb/dist/runtime_ext/deps/uxonnx/onnxruntime.dll" | Add-Content -Encoding UTF8 (Join-Path $DepDir "uxonnx_dependency_registry.csv")
Write-Host "OK: ONNX Runtime dependency fetched to $DepDir"
