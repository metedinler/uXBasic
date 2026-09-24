[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$moduleRoot = Join-Path $Root "runtime_ext\uxjsruntime"
$lockPath = Join-Path $moduleRoot "quickjs.lock.json"
$lock = Get-Content -Raw -LiteralPath $lockPath | ConvertFrom-Json
$vendorRoot = Join-Path $moduleRoot "vendor"
$target = Join-Path $vendorRoot "quickjs"
$downloads = Join-Path $moduleRoot "downloads"
$archive = Join-Path $downloads ("quickjs-{0}.tar.xz" -f $lock.version)

if ((Test-Path (Join-Path $target "VERSION")) -and -not $Force) {
    $installedVersion = (Get-Content -Raw -LiteralPath (Join-Path $target "VERSION")).Trim()
    if ($installedVersion -eq $lock.version) {
        Write-Host "[PASS] QuickJS $installedVersion already installed: $target"
        exit 0
    }
}

New-Item -ItemType Directory -Force -Path $vendorRoot, $downloads | Out-Null
Write-Host "[DOWNLOAD] $($lock.sourceUrl)"
Invoke-WebRequest -Uri $lock.sourceUrl -OutFile $archive
$hash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
if ($hash -ne [string]$lock.sha256) {
    throw "QuickJS SHA256 mismatch. expected=$($lock.sha256) actual=$hash"
}
if ((Get-Item -LiteralPath $archive).Length -ne [int64]$lock.sizeBytes) {
    throw "QuickJS archive size mismatch"
}

$tar = (Get-Command tar.exe -ErrorAction SilentlyContinue).Source
if (-not $tar) {
    $candidate = "C:\msys64\usr\bin\tar.exe"
    if (Test-Path $candidate) { $tar = $candidate }
}
if (-not $tar) { throw "tar.exe not found. Windows 11 tar or MSYS2 tar is required." }

$temp = Join-Path $vendorRoot (".extract_{0}" -f ([guid]::NewGuid().ToString("N")))
New-Item -ItemType Directory -Force -Path $temp | Out-Null
try {
    & $tar -xf $archive -C $temp
    if ($LASTEXITCODE -ne 0) { throw "QuickJS extraction failed: exit=$LASTEXITCODE" }
    $sourceDir = Get-ChildItem -LiteralPath $temp -Directory | Select-Object -First 1
    if (-not $sourceDir) { throw "QuickJS archive did not contain a source directory" }
    $versionFile = Join-Path $sourceDir.FullName "VERSION"
    if (-not (Test-Path $versionFile)) { throw "QuickJS VERSION file missing" }
    $version = (Get-Content -Raw -LiteralPath $versionFile).Trim()
    if ($version -ne $lock.version) { throw "QuickJS version mismatch: $version" }
    foreach ($required in $lock.requiredFiles) {
        if (-not (Test-Path (Join-Path $sourceDir.FullName $required))) {
            throw "QuickJS required file missing: $required"
        }
    }
    if (Test-Path $target) { Remove-Item -Recurse -Force -LiteralPath $target }
    Move-Item -LiteralPath $sourceDir.FullName -Destination $target
} finally {
    if (Test-Path $temp) { Remove-Item -Recurse -Force -LiteralPath $temp }
}
Write-Host "[PASS] QuickJS installed: $target"
