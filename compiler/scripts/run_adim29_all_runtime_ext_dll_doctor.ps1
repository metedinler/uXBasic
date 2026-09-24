param(
    [switch]$NoRepair,
    [switch]$Build,
    [switch]$StrictAll
)

$ErrorActionPreference = "Stop"

function Find-RepoRoot {
    $p = Get-Location
    while ($p) {
        if ((Test-Path (Join-Path $p "uxb/src/main.bas")) -and (Test-Path (Join-Path $p "uxb/runtime_ext"))) {
            return $p
        }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { break }
        $p = $parent
    }
    throw "Repo root bulunamadi: uxb/src/main.bas + uxb/runtime_ext yok."
}

function CsvEscape([string]$s) {
    if ($null -eq $s) { $s = "" }
    $s = $s.Replace('"','""')
    return '"' + $s + '"'
}

$repo = Find-RepoRoot
Set-Location $repo

$current = "uxb/reports/control/current"
New-Item -ItemType Directory -Force $current | Out-Null

$outDir = "uxb/dist/runtime_ext"
New-Item -ItemType Directory -Force $outDir | Out-Null

$items = @(
    @{dll="uxb_fp80.dll";      family="F80";             source="uxb/runtime_ext/fp80/uxb_fp80_ld.c";              build="uxb/runtime_ext/fp80/build_fp80_dll.bat";                 fallback=""; tier="FP"; deps="gcc,quadmath"},
    @{dll="uxb_fp128.dll";     family="F128";            source="uxb/runtime_ext/fp128/uxb_fp128_quad.c";          build="uxb/runtime_ext/fp128/build_fp128_dll.bat";              fallback=""; tier="FP"; deps="gcc,quadmath"},
    @{dll="uxb_bigfp.dll";     family="BIGF_BIGD_BALL";  source="uxb/runtime_ext/bigfp/uxb_bigfp_mpfr.c";          build="uxb/runtime_ext/bigfp/build_bigfp_dll.bat";              fallback=""; tier="FP"; deps="gcc,mpfr,gmp"},

    @{dll="uxmathcore.dll";    family="MATHCORE";        source="uxb/runtime_ext/uxmathcore/uxmathcore.c";         build="uxb/runtime_ext/uxmathcore/build_uxmathcore_dll.bat";    fallback=""; tier="CORE"; deps="gcc,libm"},
    @{dll="uxmath.dll";        family="MATH";            source="uxb/runtime_ext/uxmath/uxmath.c";                 build="uxb/runtime_ext/uxmath/build_uxmath_dll.bat";            fallback=""; tier="CORE"; deps="gcc,libm"},
    @{dll="uxstats.dll";       family="STATS";           source="uxb/runtime_ext/uxstats/uxstats.c";               build="uxb/runtime_ext/uxstats/build_uxstats_dll.bat";          fallback=""; tier="CORE"; deps="gcc,libm"},
    @{dll="uxstats2.dll";      family="STATS2";          source="uxb/runtime_ext/uxstats2/uxstats2.c";             build="uxb/runtime_ext/uxstats2/build_uxstats2_dll.bat";        fallback=""; tier="CORE"; deps="gcc,libm"},
    @{dll="uxdataset.dll";     family="DATASET";         source="uxb/runtime_ext/uxdataset/uxdataset.c";           build="uxb/runtime_ext/uxdataset/build_uxdataset_dll.bat";      fallback=""; tier="CORE"; deps="gcc,libm"},

    @{dll="uxaimath.dll";      family="AIMATH";          source="uxb/runtime_ext/uxaimath/uxaimath.c";             build="uxb/runtime_ext/uxaimath/build_uxaimath_dll.bat";        fallback="uxb/runtime_ext/uxaimath/build_uxaimath_fallback_dll.bat"; tier="OPTIONAL"; deps="gcc,openblas"},
    @{dll="uxcollections.dll"; family="COLLECTIONS";     source="uxb/runtime_ext/uxcollections/uxcollections_glib.c"; build="uxb/runtime_ext/uxcollections/build_uxcollections_dll.bat"; fallback=""; tier="OPTIONAL"; deps="gcc,glib,pkgconf"},
    @{dll="uxdataframe.dll";   family="DATAFRAME";       source="uxb/runtime_ext/uxdataframe/uxdataframe_duckdb.c"; build="uxb/runtime_ext/uxdataframe/build_uxdataframe_dll.bat"; fallback=""; tier="OPTIONAL"; deps="gcc,duckdb"},
    @{dll="uxgraph.dll";       family="GRAPH";           source="uxb/runtime_ext/uxgraph/uxgraph_igraph.c";        build="uxb/runtime_ext/uxgraph/build_uxgraph_dll.bat";          fallback="uxb/runtime_ext/uxgraph/build_uxgraph_fallback_dll.bat"; tier="OPTIONAL"; deps="gcc,igraph,pkgconf"},
    @{dll="uxllama.dll";       family="LLAMA";           source="uxb/runtime_ext/uxllama/uxllama_cli_bridge.c";    build="uxb/runtime_ext/uxllama/build_uxllama_dll.bat";          fallback=""; tier="OPTIONAL_HEAVY"; deps="gcc,llama.cpp"},
    @{dll="uxmatrix.dll";      family="MATRIX";          source="uxb/runtime_ext/uxmatrix/uxmatrix_openblas.c";    build="uxb/runtime_ext/uxmatrix/build_uxmatrix_dll.bat";        fallback="uxb/runtime_ext/uxmatrix/build_uxmatrix_fallback_dll.bat"; tier="OPTIONAL"; deps="gcc,openblas,pkgconf"},
    @{dll="uxnn.dll";          family="NN";              source="uxb/runtime_ext/uxnn/uxnn.c";                     build="uxb/runtime_ext/uxnn/build_uxnn_dll.bat";                fallback="uxb/runtime_ext/uxnn/build_uxnn_fallback_dll.bat"; tier="OPTIONAL"; deps="gcc,openblas"},
    @{dll="uxnn2.dll";         family="NN2";             source="uxb/runtime_ext/uxnn2/uxnn2.c";                   build="uxb/runtime_ext/uxnn2/build_uxnn2_dll.bat";              fallback=""; tier="OPTIONAL"; deps="gcc,libm"},
    @{dll="uxnn3.dll";         family="NN3";             source="uxb/runtime_ext/uxnn3/uxnn3.c";                   build="uxb/runtime_ext/uxnn3/build_uxnn3_dll.bat";              fallback=""; tier="OPTIONAL"; deps="gcc,libm"},
    @{dll="uxonnx.dll";        family="ONNX";            source="uxb/runtime_ext/uxonnx/uxonnx.c";                 build="uxb/runtime_ext/uxonnx/build_uxonnx_dll.bat";            fallback=""; tier="OPTIONAL_HEAVY"; deps="gcc,onnxruntime"},
    @{dll="uxonnx2.dll";       family="ONNX2";           source="uxb/runtime_ext/uxonnx2/uxonnx2.c";               build="uxb/runtime_ext/uxonnx2/build_uxonnx2_dll.bat";          fallback=""; tier="OPTIONAL_HEAVY"; deps="gcc,onnxruntime"},
    @{dll="uxtensor.dll";      family="TENSOR";          source="uxb/runtime_ext/uxtensor/uxtensor.c";             build="uxb/runtime_ext/uxtensor/build_uxtensor_dll.bat";        fallback="uxb/runtime_ext/uxtensor/build_uxtensor_fallback_dll.bat"; tier="OPTIONAL"; deps="gcc,openblas"}
)

$rows = New-Object System.Collections.Generic.List[object]
$failCount = 0
$requiredFailCount = 0
$buildAttempts = 0
$buildFailures = 0

foreach ($it in $items) {
    $expected = Join-Path $outDir $it.dll
    $status = ""
    $action = ""
    $buildExit = ""
    $usedScript = ""

    if (Test-Path $expected) {
        $status = "DLL_EXISTS"
        $action = "NO_BUILD_NEEDED"
    } elseif (!(Test-Path $it.source)) {
        $status = "SOURCE_MISSING"
        $action = "SOURCE_REQUIRED"
    } elseif (!(Test-Path $it.build)) {
        $status = "BUILD_SCRIPT_MISSING"
        $action = "BUILD_SCRIPT_REQUIRED"
    } elseif ($Build) {
        $buildAttempts++
        $usedScript = $it.build
        cmd /c $it.build | Out-File -FilePath (Join-Path $current ("adim29_build_" + $it.dll + ".log")) -Encoding utf8
        $buildExit = $LASTEXITCODE
        if ($buildExit -ne 0 -and $it.fallback -and (Test-Path $it.fallback)) {
            $usedScript = $it.fallback
            cmd /c $it.fallback | Out-File -FilePath (Join-Path $current ("adim29_build_" + $it.dll + "_fallback.log")) -Encoding utf8
            $buildExit = $LASTEXITCODE
        }
        if ((Test-Path $expected) -and $buildExit -eq 0) {
            $status = "BUILT"
            $action = "OK"
        } else {
            $status = "BUILD_FAILED"
            $action = "CHECK_LOG_AND_DEPS"
            $buildFailures++
        }
    } else {
        $status = "DLL_MISSING"
        $action = "RUN_WITH_BUILD_OR_BUILD_SCRIPT"
    }

    $isFail = 0
    if ($status -in @("SOURCE_MISSING","BUILD_SCRIPT_MISSING","BUILD_FAILED")) { $isFail = 1 }
    if ($StrictAll -and $status -eq "DLL_MISSING") { $isFail = 1 }
    if ($isFail) {
        $failCount++
        if ($it.tier -in @("FP","CORE")) { $requiredFailCount++ }
    }

    $rows.Add([pscustomobject]@{
        dll = $it.dll
        family = $it.family
        tier = $it.tier
        expected_path = $expected
        source = $it.source
        build_script = $it.build
        fallback_script = $it.fallback
        deps = $it.deps
        status = $status
        action = $action
        build_exit_code = "$buildExit"
        used_script = "$usedScript"
    })
}

$csvPath = Join-Path $current "adim29_runtime_ext_dll_matrix.csv"
$headers = @("dll","family","tier","expected_path","source","build_script","fallback_script","deps","status","action","build_exit_code","used_script")
$outLines = New-Object System.Collections.Generic.List[string]
$outLines.Add(($headers | ForEach-Object { CsvEscape $_ }) -join ",")
foreach ($r in $rows) {
    $outLines.Add(($headers | ForEach-Object { CsvEscape ([string]$r.$_) }) -join ",")
}
$outLines | Set-Content -Encoding utf8 $csvPath

$ok = $true
if ($requiredFailCount -gt 0) { $ok = $false }
if ($StrictAll -and $failCount -gt 0) { $ok = $false }
if ($Build -and $buildFailures -gt 0) { $ok = $false }

$gate = [ordered]@{
    step = "ADIM29_ALL_RUNTIME_EXT_DLL_DOCTOR"
    ok = $ok
    fail_count = $failCount
    required_fail_count = $requiredFailCount
    build_attempts = $buildAttempts
    build_failures = $buildFailures
    matrix = "uxb/reports/control/current/adim29_runtime_ext_dll_matrix.csv"
    runtime_dir = "uxb/dist/runtime_ext"
    note = "Sahte DLL uretmez. -Build verilirse mevcut build scriptleri cagrilir. -StrictAll butun eksikleri fail sayar."
}
$gatePath = Join-Path $current "adim29_runtime_ext_dll_gate.json"
($gate | ConvertTo-Json -Depth 5) | Set-Content -Encoding utf8 $gatePath

$mdPath = Join-Path $current "adim29_runtime_ext_dll_gate.md"
if ($ok) {
    "# ADIM29 PASS`n" | Set-Content -Encoding utf8 $mdPath
} else {
    "# ADIM29 FAIL`n`nSee matrix: $csvPath`n" | Set-Content -Encoding utf8 $mdPath
}

Write-Host "ADIM29 matrix: $csvPath"
Write-Host "ADIM29 gate: $gatePath"
if ($ok) { exit 0 } else { exit 1 }
