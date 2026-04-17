Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Set-Location "$PSScriptRoot/.."

$gccCandidates = @(
    "C:/Program Files/CodeBlocks/MinGW/bin/gcc.exe",
    "./tools/FreeBASIC-1.10.1-win64/gcc.exe",
    "./tools/FreeBASIC-1.10.1-win64/bin/win64/gcc.exe"
)

$gcc = $null
foreach ($candidate in $gccCandidates) {
    if (Test-Path $candidate) {
        $gcc = $candidate
        break
    }
}

if (-not $gcc) {
    throw "gcc not found (checked FreeBASIC bundle and CodeBlocks MinGW)"
}

Write-Output "UXSTAT_GCC=$gcc"

$uxstatSrc = "extras/uxstat/src/uxstat.c"
$uxstatDll = "uxstat.dll"

& $gcc -shared -O2 -s -o $uxstatDll $uxstatSrc
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

./tools/FreeBASIC-1.10.1-win64/fbc.exe -lang fb -arch x86_64 tests/run_uxstat_smoke_exec_ast.bas -x tests/run_uxstat_smoke_exec_ast_64.exe
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

./tests/run_uxstat_smoke_exec_ast_64.exe
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Output "UXSTAT_SMOKE_OK"
