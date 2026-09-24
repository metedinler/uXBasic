[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [string]$Gcc = $env:UXB_GCC,
    [switch]$SkipFetch
)
$ErrorActionPreference = "Stop"
$Root = (Resolve-Path $Root).Path
$moduleRoot = Join-Path $Root "runtime_ext\uxwasmrt"
$bin = Join-Path $Root "bin"

if (-not $SkipFetch -and -not (Test-Path (Join-Path $bin 'wasmtime.dll'))) {
    & (Join-Path $moduleRoot 'fetch_wasm_deps.ps1') -Root $Root
}
if (-not $Gcc) {
    foreach ($candidate in @('C:\msys64\ucrt64\bin\gcc.exe','C:\msys64\mingw64\bin\gcc.exe')) {
        if (Test-Path $candidate) { $Gcc = $candidate; break }
    }
}
if (-not $Gcc) {
    $gccCommand = Get-Command gcc.exe -ErrorAction SilentlyContinue
    if ($gccCommand) { $Gcc = $gccCommand.Source }
}
if (-not $Gcc) { throw 'x64 GCC not found. Set UXB_GCC.' }

$gccDir = Split-Path $Gcc -Parent
$env:PATH = "$gccDir;$env:PATH"
$objdump = Join-Path $gccDir 'objdump.exe'
$wasmtimeDll = Join-Path $bin 'wasmtime.dll'
if (-not (Test-Path $wasmtimeDll)) { throw "wasmtime.dll missing: $wasmtimeDll" }

if (Test-Path $objdump) {
    $wasmtimeFormat = & $objdump -f $wasmtimeDll 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $wasmtimeFormat -notmatch 'pei-x86-64') {
        throw 'Pinned wasmtime.dll is not PE32+ x64'
    }
    $wasmtimeExports = & $objdump -p $wasmtimeDll 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect wasmtime.dll exports' }
    foreach ($symbol in @(
        'wasm_engine_new','wasm_store_new','wasm_module_validate','wasm_module_new',
        'wasm_module_imports','wasm_func_new_with_env','wasm_instance_new',
        'wasm_instance_exports','wasm_func_call','wasm_trap_message'
    )) {
        if ($wasmtimeExports -notmatch [regex]::Escape($symbol)) {
            throw "Pinned wasmtime.dll lacks required standard C API export: $symbol"
        }
    }
}

$build = Join-Path $moduleRoot 'build'
New-Item -ItemType Directory -Force -Path $build,$bin | Out-Null
$dll = Join-Path $build 'uxwasmrt.dll'
$implib = Join-Path $build 'libuxwasmrt.dll.a'
$arguments = @(
    '-std=gnu11','-O2','-g','-Wall','-Wextra','-Werror','-DUXWASMRT_BUILD_DLL',
    "-I$moduleRoot",'-shared','-o',$dll,(Join-Path $moduleRoot 'uxwasmrt.c'),
    (Join-Path $moduleRoot 'uxwasmrt.def'),'-static-libgcc','-Wl,--no-undefined',
    "-Wl,--out-implib,$implib",'-lm'
)
$stdout = Join-Path $build 'build.stdout.log'
$stderr = Join-Path $build 'build.stderr.log'
$global:LASTEXITCODE = 0
& $Gcc @arguments 1> $stdout 2> $stderr
$exitCode = $LASTEXITCODE
if (Test-Path $stdout) { Get-Content $stdout }
if (Test-Path $stderr) { Get-Content $stderr }
if ($exitCode -ne 0) { throw "uxwasmrt.dll build failed exit=$exitCode" }
Copy-Item -Force $dll (Join-Path $bin 'uxwasmrt.dll')

if (Test-Path $objdump) {
    $format = & $objdump -f (Join-Path $bin 'uxwasmrt.dll') 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $format -notmatch 'pei-x86-64') { throw 'uxwasmrt.dll is not PE32+ x64' }
    $exports = & $objdump -p (Join-Path $bin 'uxwasmrt.dll') 2>&1 | Out-String
    foreach ($symbol in @(
        'uxwasm_version','uxwasm_runtime_available','uxwasm_open_file',
        'uxwasm_call_i32_0','uxwasm_call_i32_1','uxwasm_call_i32_2',
        'uxwasm_call_i32_3','uxwasm_call_i32_4','uxwasm_last_error','uxwasm_shutdown'
    )) {
        if ($exports -notmatch [regex]::Escape($symbol)) { throw "Missing uxwasmrt export: $symbol" }
    }
}
Write-Host "UXWASMRT_DLL=$(Join-Path $bin 'uxwasmrt.dll')"
Write-Host 'UXWASMRT_BUILD_PASS'
