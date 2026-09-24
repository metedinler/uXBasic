param(
  [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
  [string]$Version = "latest"
)
$ErrorActionPreference = "Stop"
$depDir = Join-Path $RepoRoot "uxb\dist\runtime_ext\deps\uxdataframe"
$zipDir = Join-Path $depDir "downloads"
$binDir = Join-Path $depDir "bin"
$incDir = Join-Path $depDir "include"
New-Item -ItemType Directory -Force -Path $zipDir,$binDir,$incDir | Out-Null

$api = "https://api.github.com/repos/duckdb/duckdb/releases/latest"
if ($Version -ne "latest") { $api = "https://api.github.com/repos/duckdb/duckdb/releases/tags/$Version" }
Write-Host "Fetching DuckDB release metadata: $api"
$release = Invoke-RestMethod -Uri $api -Headers @{"User-Agent"="UXBc-uxdataframe-fetcher"}
$assets = $release.assets
$libAsset = $assets | Where-Object { $_.name -match "^libduckdb-windows-amd64\.zip$" } | Select-Object -First 1
if (-not $libAsset) {
  $libAsset = $assets | Where-Object { $_.name -match "^libduckdb.*windows.*amd64.*\.zip$" } | Select-Object -First 1
}
if (-not $libAsset) { throw "Could not find Windows AMD64 DuckDB library asset in release $($release.tag_name)." }
$zipPath = Join-Path $zipDir $libAsset.name
Write-Host "Downloading $($libAsset.browser_download_url)"
Invoke-WebRequest -Uri $libAsset.browser_download_url -OutFile $zipPath
$temp = Join-Path $zipDir "extract"
if (Test-Path $temp) { Remove-Item -Recurse -Force $temp }
New-Item -ItemType Directory -Force -Path $temp | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $temp -Force

$duckdbDll = Get-ChildItem -Path $temp -Recurse -Filter "duckdb.dll" | Select-Object -First 1
$duckdbH = Get-ChildItem -Path $temp -Recurse -Filter "duckdb.h" | Select-Object -First 1
if (-not $duckdbDll) { throw "duckdb.dll not found in downloaded asset." }
if (-not $duckdbH) { throw "duckdb.h not found in downloaded asset." }
Copy-Item $duckdbDll.FullName (Join-Path $binDir "duckdb.dll") -Force
Copy-Item $duckdbH.FullName (Join-Path $incDir "duckdb.h") -Force

$registry = [ordered]@{
  schema_version = "uxb-external-dependency-registry-1"
  package = "uxdataframe"
  backend = "DuckDB C API"
  release_tag = $release.tag_name
  asset = $libAsset.name
  source_url = $libAsset.browser_download_url
  local_bin = "uxb/dist/runtime_ext/deps/uxdataframe/bin/duckdb.dll"
  local_include = "uxb/dist/runtime_ext/deps/uxdataframe/include/duckdb.h"
  license = "MIT"
  fetched_at = (Get-Date).ToString("s")
}
$registry | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 (Join-Path $depDir "uxdataframe_dependency_registry.json")
@"
package,backend,release_tag,asset,source_url,local_path,license
uxdataframe,DuckDB C API,$($release.tag_name),$($libAsset.name),$($libAsset.browser_download_url),uxb/dist/runtime_ext/deps/uxdataframe/bin/duckdb.dll,MIT
"@ | Set-Content -Encoding UTF8 (Join-Path $depDir "uxdataframe_dependency_registry.csv")
Write-Host "OK: DuckDB dependency cached under $depDir"
