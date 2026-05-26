<#
.SYNOPSIS
  uXBasic Browser/WASM/WebGPU toolchain installer for Windows Terminal.

.DESCRIPTION
  Checks and installs/places the tools needed by the uXBasic browser target:
  - Node.js LTS + npm (via winget when missing)
  - WABT (wat2wasm, wasm-validate, wasm2wat) into tools/browser_toolchain/wabt
  - Binaryen (wasm-opt) into tools/browser_toolchain/binaryen
  - Optional local HTTP server helper and env script

  This script avoids admin-only global PATH edits. It creates:
    tools/env_browser_toolchain.ps1
  and writes a JSON report:
    dist/browser/toolchain_status.json

.PARAMETER UxbRoot
  uXBasic project root. Default: parent of this tools folder.

.PARAMETER InstallDir
  Local tool install directory. Default: <UxbRoot>/tools/browser_toolchain.

.PARAMETER NoInstallNode
  Do not install Node.js; only report whether node/npm exist.

.PARAMETER Force
  Re-download WABT/Binaryen even if executables already exist.

.PARAMETER SkipDownloads
  Only check existing tools; do not download/install anything.
#>
[CmdletBinding()]
param(
  [string]$UxbRoot = "",
  [string]$InstallDir = "",
  [switch]$NoInstallNode,
  [switch]$Force,
  [switch]$SkipDownloads
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-UxbRoot {
  param([string]$Given)
  if ($Given -and (Test-Path $Given)) { return (Resolve-Path $Given).Path }
  $scriptDir = Split-Path -Parent $PSCommandPath
  return (Resolve-Path (Join-Path $scriptDir "..")).Path
}

function Ensure-Dir([string]$p) {
  if (-not (Test-Path $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null }
}

function Get-CommandPath([string]$name) {
  $c = Get-Command $name -ErrorAction SilentlyContinue
  if ($null -eq $c) { return $null }
  return $c.Source
}

function Invoke-DownloadJson([string]$url) {
  $headers = @{ "User-Agent" = "uXBasic-browser-toolchain-installer" }
  return Invoke-RestMethod -Uri $url -Headers $headers -UseBasicParsing
}

function Download-File([string]$url, [string]$outPath) {
  Write-Host "[download] $url" -ForegroundColor Cyan
  $headers = @{ "User-Agent" = "uXBasic-browser-toolchain-installer" }
  Invoke-WebRequest -Uri $url -Headers $headers -OutFile $outPath -UseBasicParsing
}

function Find-ReleaseAssetUrl {
  param(
    [string]$Repo,
    [string[]]$NameRegexes
  )
  $rel = Invoke-DownloadJson "https://api.github.com/repos/$Repo/releases/latest"
  foreach ($rx in $NameRegexes) {
    foreach ($a in $rel.assets) {
      if ($a.name -match $rx) { return @{ url = $a.browser_download_url; name = $a.name; tag = $rel.tag_name } }
    }
  }
  throw "No matching release asset found for $Repo patterns: $($NameRegexes -join ', ')"
}

function Expand-ZipToCleanDir([string]$zipPath, [string]$dest) {
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Ensure-Dir $dest
  Expand-Archive -LiteralPath $zipPath -DestinationPath $dest -Force
}

function Find-ExeUnder([string]$base, [string]$exeName) {
  $found = Get-ChildItem -LiteralPath $base -Filter $exeName -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -eq $found) { return $null }
  return $found.FullName
}

function Install-NodeIfNeeded {
  param([switch]$Skip)
  $node = Get-CommandPath "node"
  $npm = Get-CommandPath "npm"
  if ($node -and $npm) { return @{ ok = $true; installed = $false; node = $node; npm = $npm; note = "existing" } }
  if ($Skip -or $NoInstallNode) { return @{ ok = $false; installed = $false; node = $node; npm = $npm; note = "missing; install skipped" } }
  $winget = Get-CommandPath "winget"
  if (-not $winget) { return @{ ok = $false; installed = $false; node = $node; npm = $npm; note = "winget missing" } }
  Write-Host "[install] Node.js LTS via winget OpenJS.NodeJS.LTS" -ForegroundColor Yellow
  & winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
  $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
  return @{ ok = [bool](Get-CommandPath "node"); installed = $true; node = (Get-CommandPath "node"); npm = (Get-CommandPath "npm"); note = "winget" }
}

function Install-Wabt {
  param([string]$BaseDir, [switch]$Skip, [switch]$ForceInstall)
  $dest = Join-Path $BaseDir "wabt"
  $wat2wasm = Find-ExeUnder $dest "wat2wasm.exe"
  $validate = Find-ExeUnder $dest "wasm-validate.exe"
  if ($wat2wasm -and $validate -and -not $ForceInstall) { return @{ ok = $true; installed = $false; wat2wasm = $wat2wasm; wasm_validate = $validate; note = "existing" } }
  if ($Skip) { return @{ ok = $false; installed = $false; wat2wasm = $wat2wasm; wasm_validate = $validate; note = "missing; download skipped" } }
  $asset = Find-ReleaseAssetUrl -Repo "WebAssembly/wabt" -NameRegexes @("windows.*x64.*\.zip$", "win.*x64.*\.zip$", "windows.*\.zip$")
  $tmp = Join-Path $BaseDir $asset.name
  Download-File $asset.url $tmp
  Expand-ZipToCleanDir $tmp $dest
  $wat2wasm = Find-ExeUnder $dest "wat2wasm.exe"
  $validate = Find-ExeUnder $dest "wasm-validate.exe"
  return @{ ok = [bool]$wat2wasm; installed = $true; wat2wasm = $wat2wasm; wasm_validate = $validate; tag = $asset.tag; note = $asset.name }
}

function Install-Binaryen {
  param([string]$BaseDir, [switch]$Skip, [switch]$ForceInstall)
  $dest = Join-Path $BaseDir "binaryen"
  $wasmopt = Find-ExeUnder $dest "wasm-opt.exe"
  if ($wasmopt -and -not $ForceInstall) { return @{ ok = $true; installed = $false; wasm_opt = $wasmopt; note = "existing" } }
  if ($Skip) { return @{ ok = $false; installed = $false; wasm_opt = $wasmopt; note = "missing; download skipped" } }
  $asset = Find-ReleaseAssetUrl -Repo "WebAssembly/binaryen" -NameRegexes @("x86_64-windows.*\.tar\.gz$", "x86_64-windows.*\.zip$", "windows.*x64.*\.zip$")
  $tmp = Join-Path $BaseDir $asset.name
  Download-File $asset.url $tmp
  if ($asset.name -match "\.zip$") {
    Expand-ZipToCleanDir $tmp $dest
  } else {
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Ensure-Dir $dest
    tar -xzf $tmp -C $dest
  }
  $wasmopt = Find-ExeUnder $dest "wasm-opt.exe"
  return @{ ok = [bool]$wasmopt; installed = $true; wasm_opt = $wasmopt; tag = $asset.tag; note = $asset.name }
}

$root = Resolve-UxbRoot $UxbRoot
if (-not $InstallDir) { $InstallDir = Join-Path $root "tools\browser_toolchain" }
Ensure-Dir $InstallDir
Ensure-Dir (Join-Path $root "dist\browser")

$report = [ordered]@{
  uxb_root = $root
  install_dir = (Resolve-Path $InstallDir).Path
  timestamp = (Get-Date).ToString("s")
  checks = [ordered]@{}
}

$report.checks.python = @{ ok = [bool](Get-CommandPath "python"); path = (Get-CommandPath "python") }
$report.checks.winget = @{ ok = [bool](Get-CommandPath "winget"); path = (Get-CommandPath "winget") }
$report.checks.node = Install-NodeIfNeeded -Skip:$SkipDownloads
$report.checks.wabt = Install-Wabt -BaseDir $InstallDir -Skip:$SkipDownloads -ForceInstall:$Force
$report.checks.binaryen = Install-Binaryen -BaseDir $InstallDir -Skip:$SkipDownloads -ForceInstall:$Force
$report.checks.chrome = @{ ok = [bool](Get-CommandPath "chrome"); path = (Get-CommandPath "chrome"); note = "WebGPU uses browser feature detection at runtime" }
$report.checks.edge = @{ ok = [bool](Get-CommandPath "msedge"); path = (Get-CommandPath "msedge"); note = "WebGPU uses browser feature detection at runtime" }

$envFile = Join-Path $root "tools\env_browser_toolchain.ps1"
$wabtBin = Split-Path -Parent $report.checks.wabt.wat2wasm
$binBin = Split-Path -Parent $report.checks.binaryen.wasm_opt
$lines = @()
$lines += '# Generated by install_browser_wasm_toolchain.ps1'
$lines += '$env:UXB_BROWSER_TOOLCHAIN = "' + $InstallDir.Replace('`','``').Replace('"','`"') + '"'
if ($wabtBin) { $lines += '$env:PATH = "' + $wabtBin.Replace('`','``').Replace('"','`"') + ';" + $env:PATH' }
if ($binBin) { $lines += '$env:PATH = "' + $binBin.Replace('`','``').Replace('"','`"') + ';" + $env:PATH' }
$lines += 'Write-Host "uXBasic browser toolchain PATH loaded."'
$lines | Set-Content -LiteralPath $envFile -Encoding UTF8
$report.env_file = $envFile

$reportPath = Join-Path $root "dist\browser\toolchain_status.json"
($report | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $reportPath -Encoding UTF8

Write-Host ""
Write-Host "uXBasic Browser/WASM toolchain report:" -ForegroundColor Green
Write-Host "  $reportPath"
Write-Host "Load env in new terminal with:" -ForegroundColor Green
Write-Host "  . `"$envFile`""

if (-not $report.checks.wabt.ok) { Write-Warning "WABT/wat2wasm missing. WAT will be generated but .wasm binary may not be built." }
if (-not $report.checks.node.ok) { Write-Warning "Node.js missing. JS syntax checks and local dev server may not run." }
