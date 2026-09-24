param(
    [string]$Root = "",
    [string]$Gcc = ""
)
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
} else {
    $Root = (Resolve-Path $Root).Path
}

$logDir = Join-Path $Root "reports\libraries\logs"
$outDir = Join-Path $Root "build\libraries\tests\abi10"
$binDir = Join-Path $Root "bin"
$distBinDir = Join-Path $Root "dist\libraries\bin"
$distLibDir = Join-Path $Root "dist\libraries\lib"
New-Item -ItemType Directory -Force $logDir,$outDir,$binDir,$distBinDir,$distLibDir | Out-Null
$log = Join-Path $logDir "abi10_test_dll_gcc.log"

function Resolve-Tool([string[]]$Candidates) {
    foreach ($candidate in $Candidates) {
        if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
        if (Test-Path $candidate) { return (Resolve-Path $candidate).Path }
        $cmd = Get-Command $candidate -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return ""
}

$gccExe = Resolve-Tool @(
    $Gcc,
    $env:UXB_GCC,
    $env:GCC,
    "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe",
    "C:\msys64\ucrt64\bin\gcc.exe",
    "x86_64-w64-mingw32-gcc.exe",
    "gcc.exe"
)
if ([string]::IsNullOrWhiteSpace($gccExe)) {
    "ERROR: GCC not found. Set UXB_GCC or install mingw-w64-ucrt-x86_64-gcc." | Set-Content $log -Encoding UTF8
    throw "ABI10 GCC not found; log=$log"
}
$gccBin = Split-Path $gccExe -Parent
$env:PATH = (($gccBin, $env:PATH) -join ';')

$src = Join-Path $Root "tests\libraries\abi10\abi10_smoke_target.c"
$dll = Join-Path $outDir "uxb_abi10_test.dll"
$implib = Join-Path $outDir "libuxb_abi10_test.dll.a"
if (!(Test-Path $src)) { throw "ABI10 C source missing: $src" }
foreach ($p in @($dll,$implib,(Join-Path $binDir "uxb_abi10_test.dll"),(Join-Path $distBinDir "uxb_abi10_test.dll"))) {
    if (Test-Path $p) { Remove-Item -Force $p }
}

$gccArgs = @(
    "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
    "-shared",
    "-Wl,--out-implib,$implib",
    "-o", $dll,
    $src
)

@(
    "GCC=$gccExe",
    "ROOT=$Root",
    "SRC=$src",
    "DLL=$dll",
    "IMPLIB=$implib",
    "ARGS=$($gccArgs -join ' ')"
) | Set-Content $log -Encoding UTF8

& $gccExe @gccArgs 2>&1 | Tee-Object -FilePath $log -Append
$rc = $LASTEXITCODE
if ($rc -ne 0 -or !(Test-Path $dll)) {
    throw "ABI10 test DLL build failed rc=$rc log=$log"
}
Copy-Item -Force $dll (Join-Path $binDir "uxb_abi10_test.dll")
Copy-Item -Force $dll (Join-Path $distBinDir "uxb_abi10_test.dll")
if (Test-Path $implib) {
    Copy-Item -Force $implib (Join-Path $distLibDir "libuxb_abi10_test.dll.a")
}
"OK: $dll" | Tee-Object -FilePath $log -Append
exit 0
