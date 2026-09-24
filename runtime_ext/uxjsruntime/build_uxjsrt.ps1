[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [string]$Gcc = $env:UXB_GCC,
    [switch]$SkipFetch,
    [switch]$DebugBuild
)

$ErrorActionPreference = "Stop"
$moduleRoot = Join-Path $Root "runtime_ext\uxjsruntime"
$vendor = Join-Path $moduleRoot "vendor\quickjs"
$lock = Get-Content -Raw -LiteralPath (Join-Path $moduleRoot "quickjs.lock.json") | ConvertFrom-Json

function Invoke-NativeLogged {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$ArgumentList,
        [string]$Prefix = "",
        [string]$Suffix = ""
    )

    $stdoutFile = [IO.Path]::GetTempFileName()
    $stderrFile = [IO.Path]::GetTempFileName()
    try {
        $proc = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -NoNewWindow -Wait -PassThru -RedirectStandardOutput $stdoutFile -RedirectStandardError $stderrFile
        $stdout = if (Test-Path -LiteralPath $stdoutFile) { Get-Content -Raw -LiteralPath $stdoutFile } else { "" }
        $stderr = if (Test-Path -LiteralPath $stderrFile) { Get-Content -Raw -LiteralPath $stderrFile } else { "" }
        return [pscustomobject]@{
            Prefix = $Prefix
            Stdout = $stdout
            Stderr = $stderr
            Suffix = $Suffix
            ExitCode = $proc.ExitCode
        }
    } finally {
        Remove-Item -LiteralPath $stdoutFile, $stderrFile -Force -ErrorAction SilentlyContinue
    }
}

if (-not $SkipFetch -and -not (Test-Path (Join-Path $vendor "quickjs.c"))) {
    & (Join-Path $moduleRoot "fetch_quickjs.ps1") -Root $Root
    if ($LASTEXITCODE -ne 0) { throw "QuickJS fetch failed" }
}
if (-not (Test-Path (Join-Path $vendor "quickjs.c"))) { throw "QuickJS source missing. Run fetch_quickjs.ps1." }

if (-not $Gcc) {
    $candidates = @(
        "C:\msys64\ucrt64\bin\gcc.exe",
        "C:\msys64\mingw64\bin\gcc.exe"
    )
    foreach ($candidate in $candidates) { if (Test-Path $candidate) { $Gcc = $candidate; break } }
}
if (-not $Gcc) { $Gcc = (Get-Command gcc.exe -ErrorAction SilentlyContinue).Source }
if (-not $Gcc) { throw "x64 GCC not found. Set UXB_GCC or install MSYS2 UCRT64." }

$gccDir = Split-Path $Gcc -Parent
if ($gccDir) {
    $env:PATH = "$gccDir;$env:PATH"
}

$build = Join-Path $moduleRoot "build"
$obj = Join-Path $build "obj"
$bin = Join-Path $Root "bin"
New-Item -ItemType Directory -Force -Path $build, $obj, $bin | Out-Null

$opt = if ($DebugBuild) { "-O0" } else { "-O2" }
$common = @(
    "-std=gnu11", $opt, "-g", "-Wall", "-Wextra", "-Wno-unused-parameter",
    "-Wno-array-bounds", "-Wno-format-truncation", "-fwrapv",
    "-D_GNU_SOURCE", "-D__USE_MINGW_ANSI_STDIO", "-pthread",
    ('-DCONFIG_VERSION=\"{0}\"' -f $lock.version),
    ('-DUXJSRT_QUICKJS_VERSION=\"{0}\"' -f $lock.version),
    "-DUXJSRT_BUILD_DLL",
    ("-I{0}" -f $vendor), ("-I{0}" -f $moduleRoot)
)
$sources = @(
    (Join-Path $vendor "quickjs.c"),
    (Join-Path $vendor "dtoa.c"),
    (Join-Path $vendor "libregexp.c"),
    (Join-Path $vendor "libunicode.c"),
    (Join-Path $vendor "cutils.c"),
    (Join-Path $moduleRoot "uxjsrt.c")
)
$objects = @()
foreach ($source in $sources) {
    $name = [IO.Path]::GetFileNameWithoutExtension($source) + ".o"
    $object = Join-Path $obj $name
    $commandArgs = @($common + @("-c", $source, "-o", $object))
    Write-Host "[CC] $([IO.Path]::GetFileName($source))"
    $gccResult = Invoke-NativeLogged -FilePath $Gcc -ArgumentList $commandArgs
    if ($gccResult.Prefix) { Write-Host $gccResult.Prefix }
    if ($gccResult.Stdout) { $gccResult.Stdout }
    if ($gccResult.Stderr) { $gccResult.Stderr }
    if ($gccResult.Suffix) { Write-Host $gccResult.Suffix }
    if ($gccResult.ExitCode -ne 0) { throw "Compilation failed (exit=$($gccResult.ExitCode)): $source" }
    $objects += $object
}

$dll = Join-Path $build "uxjsrt.dll"
$importLib = Join-Path $build "libuxjsrt.dll.a"
$linkArgs = @(
    "-shared", "-o", $dll
) + $objects + @(
    (Join-Path $moduleRoot "uxjsrt.def"),
    "-static-libgcc", "-Wl,--no-undefined", ("-Wl,--out-implib,{0}" -f $importLib),
    "-Wl,-Bstatic", "-lwinpthread", "-Wl,-Bdynamic", "-lm"
)
Write-Host "[LINK] uxjsrt.dll"
$linkResult = Invoke-NativeLogged -FilePath $Gcc -ArgumentList $linkArgs
if ($linkResult.Prefix) { Write-Host $linkResult.Prefix }
if ($linkResult.Stdout) { $linkResult.Stdout }
if ($linkResult.Stderr) { $linkResult.Stderr }
if ($linkResult.Suffix) { Write-Host $linkResult.Suffix }
if ($linkResult.ExitCode -ne 0) { throw "uxjsrt.dll link failed (exit=$($linkResult.ExitCode))" }
Copy-Item -Force -LiteralPath $dll -Destination (Join-Path $bin "uxjsrt.dll")
Write-Host "[PASS] $(Join-Path $bin 'uxjsrt.dll')"
