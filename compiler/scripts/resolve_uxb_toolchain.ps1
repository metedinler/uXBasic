param(
    [string]$Root = "",
    [switch]$RequireCompiler,
    [switch]$RequireNative,
    [switch]$RequireWabt
)
$ErrorActionPreference = "Stop"

function Resolve-UxbRoot([string]$Start) {
    if ([string]::IsNullOrWhiteSpace($Start)) { $Start = $PSScriptRoot }
    $p = (Resolve-Path $Start).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src")) -and (Test-Path (Join-Path $p "runtime_ext"))) { return $p }
        if ((Test-Path (Join-Path $p "uxb\src")) -and (Test-Path (Join-Path $p "uxb\runtime_ext"))) { return (Join-Path $p "uxb") }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root bulunamadi: $Start" }
        $p = $parent
    }
}

function First-ExistingFile([string[]]$Candidates) {
    foreach ($candidate in $Candidates) {
        if (-not [string]::IsNullOrWhiteSpace($candidate) -and (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    return ""
}

function Command-Path([string[]]$Names) {
    foreach ($name in $Names) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return ""
}

$uxbRoot = Resolve-UxbRoot $Root
$fbHome = Join-Path $uxbRoot "tools\FreeBASIC-1.10.1-win64"
$fbc = First-ExistingFile @(
    $env:UXB_FBC,
    (Join-Path $fbHome "fbc64.exe"),
    (Join-Path $fbHome "fbc.exe"),
    (Command-Path @("fbc64.exe","fbc64","fbc.exe","fbc"))
)
$gcc = First-ExistingFile @(
    $env:UXB_GCC,
    "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe",
    "C:\msys64\ucrt64\bin\gcc.exe",
    (Command-Path @("x86_64-w64-mingw32-gcc.exe","gcc.exe","gcc"))
)
$pkgConfig = First-ExistingFile @(
    $env:UXB_PKG_CONFIG,
    "C:\msys64\ucrt64\bin\pkg-config.exe",
    "C:\msys64\ucrt64\bin\pkgconf.exe",
    (Command-Path @("pkg-config.exe","pkgconf.exe","pkg-config","pkgconf"))
)
$pacman = First-ExistingFile @($env:UXB_PACMAN,"C:\msys64\usr\bin\pacman.exe")
$wat2wasm = First-ExistingFile @(
    $env:UXB_WAT2WASM,
    (Join-Path $uxbRoot "tools\wabt\bin\wat2wasm.exe"),
    (Command-Path @("wat2wasm.exe","wat2wasm"))
)
$python = Command-Path @("python.exe","python","py.exe","py")

$reportDir = Join-Path $uxbRoot "reports\libraries\toolchain"
New-Item -ItemType Directory -Force $reportDir | Out-Null
$checks = @(
    [pscustomobject]@{name="freebasic_x64"; path=$fbc; required=[bool]$RequireCompiler; ok=(-not [string]::IsNullOrWhiteSpace($fbc))},
    [pscustomobject]@{name="msys2_ucrt64_gcc"; path=$gcc; required=[bool]$RequireNative; ok=(-not [string]::IsNullOrWhiteSpace($gcc))},
    [pscustomobject]@{name="pkg_config"; path=$pkgConfig; required=$false; ok=(-not [string]::IsNullOrWhiteSpace($pkgConfig))},
    [pscustomobject]@{name="pacman"; path=$pacman; required=$false; ok=(-not [string]::IsNullOrWhiteSpace($pacman))},
    [pscustomobject]@{name="wat2wasm"; path=$wat2wasm; required=[bool]$RequireWabt; ok=(-not [string]::IsNullOrWhiteSpace($wat2wasm))},
    [pscustomobject]@{name="python"; path=$python; required=$true; ok=(-not [string]::IsNullOrWhiteSpace($python))}
)
$failures = @($checks | Where-Object { $_.required -and -not $_.ok })
$payload = [ordered]@{
    schema = "uxb.toolchain.discovery.v1"
    status = if ($failures.Count -eq 0) { "PASS" } else { "FAIL" }
    root = $uxbRoot
    freebasic = $fbc
    freebasic_bin_win64 = (Join-Path $fbHome "bin\win64")
    gcc = $gcc
    pkg_config = $pkgConfig
    pacman = $pacman
    wat2wasm = $wat2wasm
    python = $python
    checks = $checks
    generated_at = (Get-Date).ToString("o")
}
$payload | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $reportDir "toolchain.json") -Encoding UTF8
$checks | Export-Csv (Join-Path $reportDir "toolchain.csv") -NoTypeInformation -Encoding UTF8

Write-Host "TOOLCHAIN_STATUS=$($payload.status)"
Write-Host "UXB_FBC=$fbc"
Write-Host "UXB_GCC=$gcc"
Write-Host "UXB_PKG_CONFIG=$pkgConfig"
Write-Host "UXB_PACMAN=$pacman"
Write-Host "UXB_WAT2WASM=$wat2wasm"
if ($failures.Count -gt 0) {
    foreach ($failure in $failures) { Write-Error "Gerekli arac bulunamadi: $($failure.name)" }
    exit 31
}
exit 0
