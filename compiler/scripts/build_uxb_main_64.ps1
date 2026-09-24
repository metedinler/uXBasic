param(
    [string]$Root = '',
    [switch]$Force,
    [switch]$Release,
    [switch]$Debug,
    [switch]$SkipX86
)
$ErrorActionPreference='Stop'
if ($Release -and $Debug) { throw '-Release ve -Debug birlikte kullanilamaz.' }
$releaseMode = -not $Debug
# YAMA: host compiler build is x64-only by default. Set UXB_BUILD_X86=1 to opt in.
if ($env:UXB_BUILD_X86 -ne '1') { $SkipX86 = $true }
function Resolve-UxbRoot([string]$Start) {
    if ([string]::IsNullOrWhiteSpace($Start)) { $Start=$PSScriptRoot }
    $p=(Resolve-Path $Start).Path
    while ($true) {
        if ((Test-Path (Join-Path $p 'src\main.bas')) -and (Test-Path (Join-Path $p 'compiler'))) { return $p }
        if (Test-Path (Join-Path $p 'uxb\src\main.bas')) { return (Join-Path $p 'uxb') }
        $parent=Split-Path $p -Parent; if ($parent -eq $p) { throw "uXBasic root bulunamadi: $Start" }; $p=$parent
    }
}
function Get-PeMachine([string]$Path) {
    $bytes=[IO.File]::ReadAllBytes($Path); $pe=[BitConverter]::ToInt32($bytes,0x3c); $m=[BitConverter]::ToUInt16($bytes,$pe+4)
    if ($m -eq 0x8664) { return 'x64' }; if ($m -eq 0x014c) { return 'x86' }; return ('0x{0:X4}' -f $m)
}
function Invoke-FbcBuild([string]$Fbc,[string]$Source,[string]$Out,[string]$Expected,[string]$Log,[switch]$ReleaseMode) {
    $generator=if($Expected -eq 'x64'){'gas64'}else{'gas'}
    $args=@('-v','-lang','fb','-gen',$generator,'-w','all','-exx','-mt')
    if ($ReleaseMode) { $args += @('-O','2','-strip') } else { $args += '-g' }
    $args += @('-x',$Out,$Source)
    "FBC=$Fbc`r`nSOURCE=$Source`r`nOUTPUT=$Out`r`nARGS=$($args -join ' ')`r`n" | Set-Content $Log -Encoding UTF8
    $timer=[Diagnostics.Stopwatch]::StartNew()
    Write-Host "FBC_BUILD_START arch=$Expected generator=$generator source=$Source"
    Push-Location (Split-Path $Source -Parent)
    $savedErrorActionPreference=$ErrorActionPreference
    try {
        # fbc/gcc writes warnings to stderr. Capture the complete diagnostic and
        # decide from its exit code instead of aborting the still-running build.
        $ErrorActionPreference='Continue'
        $o=@(& $Fbc @args 2>&1)
        $rc=$LASTEXITCODE
    } finally {
        $ErrorActionPreference=$savedErrorActionPreference
        Pop-Location
    }
    $timer.Stop()
    "ELAPSED_SECONDS=$([Math]::Round($timer.Elapsed.TotalSeconds,3))`r`nEXIT_CODE=$rc" | Add-Content $Log -Encoding UTF8
    Write-Host "FBC_BUILD_END arch=$Expected exit=$rc elapsed_seconds=$([Math]::Round($timer.Elapsed.TotalSeconds,3))"
    if ($o.Count -gt 0) { $o | Tee-Object -FilePath $Log -Append | ForEach-Object { Write-Host $_ } }
    if ($rc -ne 0 -or !(Test-Path $Out)) { throw "FreeBASIC build failed expected=$Expected rc=$rc log=$Log" }
    $arch=Get-PeMachine $Out
    if ($arch -ne $Expected) { throw "Compiler host mimarisi yanlis: expected=$Expected actual=$arch file=$Out" }
}
$uxb=Resolve-UxbRoot $Root
$fb=Join-Path $uxb 'tools\FreeBASIC-1.10.1-win64'
$fbc64=Join-Path $fb 'fbc64.exe'; $fbc32=Join-Path $fb 'fbc32.exe'
if (!(Test-Path $fbc64)) { throw "fbc64.exe bulunamadi: $fbc64" }
if (!$SkipX86 -and !(Test-Path $fbc32)) { throw "fbc32.exe bulunamadi: $fbc32" }
$wrapper=Join-Path $uxb 'compiler\wrappers\uxb_main_wrapper.bas'; $main=Join-Path $uxb 'src\main.bas'; $source=if(Test-Path $wrapper){$wrapper}else{$main}
if (!(Test-Path $source)) { throw 'Compiler giris kaynagi bulunamadi' }
$build=Join-Path $uxb 'build\compiler'; $bin=Join-Path $uxb 'bin'; $logs=Join-Path $uxb 'reports\libraries\logs'
New-Item -ItemType Directory -Force $build,$bin,$logs | Out-Null
$env:PATH=((Join-Path $fb 'bin\win64'),(Join-Path $fb 'bin\win32'),'C:\msys64\ucrt64\bin',(Join-Path $uxb 'tools\wabt\bin'),$env:PATH) -join ';'
# Canonical x64 output is bin\uxb.exe; x86 is a host compatibility companion.
$x64temp=Join-Path $build 'uxb_x64.new.exe'; $x64=Join-Path $bin 'uxb.exe'
if (!$Force -and (Test-Path $x64)) {
    $sourceRoots=@(
        (Join-Path $uxb 'src'),
        (Join-Path $uxb 'compiler\wrappers')
    )
    $newestInput=Get-ChildItem -LiteralPath $sourceRoots -Recurse -File |
        Where-Object { $_.Extension -in @('.bas','.bi','.fbs') } |
        Sort-Object LastWriteTimeUtc -Descending |
        Select-Object -First 1
    $exeItem=Get-Item -LiteralPath $x64
    if ($newestInput -and $exeItem.LastWriteTimeUtc -ge $newestInput.LastWriteTimeUtc) {
        Write-Host "COMPILER_UP_TO_DATE output=$x64 newest_input=$($newestInput.FullName)"
        Write-Host 'COMPILER_ARCH=x64'
        exit 0
    }
}
Invoke-FbcBuild $fbc64 $source $x64temp 'x64' (Join-Path $logs 'compiler_x64_fbc.log') -ReleaseMode:$releaseMode
if (Test-Path $x64) { Copy-Item -Force $x64 (Join-Path $bin 'uxb.exe.pre_library_patch.bak') -ErrorAction SilentlyContinue }
# Several AI sessions share bin\uxb.exe. A RUNNING exe cannot be overwritten (Move-Item then fails with
# "Halen varolan bir dosya olusturulamaz") but it CAN be renamed, so the old image is moved aside and the
# new one takes its name; processes still running the old image are not affected.
try {
    Move-Item -Force $x64temp $x64 -ErrorAction Stop
} catch {
    $aside = "$x64.replaced_" + (Get-Date -Format 'yyyyMMdd_HHmmss')
    Move-Item -Force $x64 $aside -ErrorAction Stop
    Move-Item -Force $x64temp $x64 -ErrorAction Stop
    Write-Host "UYARI: bin\uxb.exe baska bir surec tarafindan kullaniliyordu; eski surum yan tarafa alindi: $aside"
}
# old aside copies (older than 6 hours and no longer in use) are removed
Get-ChildItem $bin -Filter 'uxb.exe.replaced_*' -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-6) } | ForEach-Object { try { [IO.File]::Delete($_.FullName) } catch {} }
Copy-Item -Force $x64 (Join-Path $bin 'uxb_x64.exe') -ErrorAction SilentlyContinue
Copy-Item -Force $x64 (Join-Path $uxb 'uxb.exe') -ErrorAction SilentlyContinue
if (!$SkipX86) {
    $x86temp=Join-Path $build 'uxb_x86.new.exe'; $x86=Join-Path $bin 'uxb_x86.exe'
    Invoke-FbcBuild $fbc32 $source $x86temp 'x86' (Join-Path $logs 'compiler_x86_fbc.log') -ReleaseMode:$releaseMode
    Move-Item -Force $x86temp $x86
}
Copy-Item -Force $x64 (Join-Path $uxb 'compiler\wrappers\uxb_main_wrapper_64.exe') -ErrorAction SilentlyContinue
if (!$SkipX86) { Copy-Item -Force (Join-Path $bin 'uxb_x86.exe') (Join-Path $uxb 'compiler\wrappers\uxb_main_wrapper_32.exe') -ErrorAction SilentlyContinue }
$summary=@{schema='uxb.compiler_hosts.v1';x64='bin/uxb.exe';x64_alias='bin/uxb_x64.exe';x86=if($SkipX86){''}else{'bin/uxb_x86.exe'};target_codegen='x64';generated_at=(Get-Date).ToString('o')}
$summary | ConvertTo-Json | Set-Content (Join-Path $build 'compiler_hosts.json') -Encoding UTF8
Write-Host "OK: x64 compiler=$x64"
if (!$SkipX86) { Write-Host "OK: x86 host=$(Join-Path $bin 'uxb_x86.exe')" }
Write-Host 'COMPILER_ARCH=x64'
exit 0
