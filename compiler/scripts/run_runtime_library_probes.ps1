param(
    [string]$Root = "",
    [string]$OnnxModel = "",
    [string]$LlamaModel = "",
    [string]$LlamaCli = "",
    [switch]$SkipPython
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path "$PSScriptRoot\..\..").Path
} else {
    $Root = (Resolve-Path $Root).Path
}

if ([string]::IsNullOrWhiteSpace($OnnxModel)) {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        $candidate = & $python.Source -c "import pathlib,onnxruntime; print(pathlib.Path(onnxruntime.__file__).parent/'datasets'/'mul_1.onnx')" 2>$null
        if ($LASTEXITCODE -eq 0 -and $candidate -and (Test-Path $candidate)) {
            $OnnxModel = [string]$candidate
        }
    }
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportDir = Join-Path $Root "reports\libraries\tests\runtime_probes\$stamp"
New-Item -ItemType Directory -Force $reportDir | Out-Null

$cases = @(
    @{ name="fp_runtime"; script="tests\fp_runtime\build_and_run_fp_runtime_probe.bat"; marker="PASS_FP_RUNTIME"; args=@() },
    @{ name="bigfp_runtime"; script="tests\fp_runtime\build_and_run_bigfp_runtime_probe.bat"; marker="PASS_BIGFP_RUNTIME"; args=@() },
    @{ name="uxaimath"; script="tests\uxaimath\build_and_run_uxaimath_probe.bat"; marker="PASS_UXAIMATH"; args=@() },
    @{ name="uxcollections"; script="tests\uxcollections\build_and_run_uxcollections_probe.bat"; marker="PASS_UXCOLLECTIONS"; args=@() },
    @{ name="uxdataframe"; script="tests\uxdataframe\build_and_run_uxdataframe_probe.bat"; marker="PASS_UXDATAFRAME_DUCKDB"; args=@() },
    @{ name="uxdataset"; script="tests\uxdataset\build_and_run_uxdataset_probe.bat"; marker="PASS_UXDATASET"; args=@() },
    @{ name="uxgraph"; script="tests\uxgraph\build_and_run_uxgraph_probe.bat"; marker="PASS_UXGRAPH"; args=@() },
    @{ name="uxmath"; script="tests\uxmath\build_and_run_uxmath_probe.bat"; marker="PASS_UXMATH"; args=@() },
    @{ name="uxmathcore"; script="tests\uxmathcore\build_and_run_uxmathcore_probe.bat"; marker="PASS_UXMATHCORE"; args=@() },
    @{ name="uxmatrix"; script="tests\uxmatrix\build_and_run_uxmatrix_probe.bat"; marker="PASS_UXMATRIX"; args=@() },
    @{ name="uxnn"; script="tests\uxnn\build_and_run_uxnn_probe.bat"; marker="PASS_UXNN"; args=@() },
    @{ name="uxnn2"; script="tests\uxnn2\build_and_run_uxnn2_probe.bat"; marker="PASS_UXNN2"; args=@() },
    @{ name="uxnn3"; script="tests\uxnn3\build_and_run_uxnn3_probe.bat"; marker="PASS_UXNN3"; args=@() },
    @{ name="uxonnx"; script="tests\uxonnx\build_and_run_uxonnx_probe.bat"; marker="PASS_UXONNX"; args=@($OnnxModel); requiresModel=$true },
    @{ name="uxonnx2"; script="tests\uxonnx2\build_and_run_uxonnx2_probe.bat"; marker="PASS_UXONNX2"; args=@($OnnxModel); requiresModel=$true },
    @{ name="uxstats"; script="tests\uxstats\build_and_run_uxstats_probe.bat"; marker="PASS_UXSTATS"; args=@() },
    @{ name="uxstats2"; script="tests\uxstats2\build_and_run_uxstats2_probe.bat"; marker="PASS_UXSTATS2"; args=@() },
    @{ name="uxtensor"; script="tests\uxtensor\build_and_run_uxtensor_probe.bat"; marker="PASS_UXTENSOR"; args=@() }
)

if (!$SkipPython) {
    $cases += @{ name="uxpython"; script="run_uxpython_smoke.bat"; marker="PASS: Python bridge"; args=@() }
}

$cases += @{ name="uxjsruntime"; script="run_uxjsruntime_smoke.bat"; marker="UXJSRT_UXBASIC_SMOKE_PASS"; args=@() }

$llamaArgs = @()
$llamaMarker = "NO_MODEL_TEST_ONLY"
$llamaConditional = $true
if (![string]::IsNullOrWhiteSpace($LlamaModel)) {
    $llamaArgs += $LlamaModel
    if (![string]::IsNullOrWhiteSpace($LlamaCli)) { $llamaArgs += $LlamaCli }
    $llamaMarker = "OUT="
    $llamaConditional = $false
}
$cases += @{ name="uxllama"; script="tests\uxllama\build_and_run_uxllama_probe.bat"; marker=$llamaMarker; args=$llamaArgs; conditional=$llamaConditional }

$results = @()
foreach ($case in $cases) {
    $name = [string]$case.name
    $script = Join-Path $Root ([string]$case.script)
    $logPath = Join-Path $reportDir "$name.log"
    $started = Get-Date
    $status = "FAIL"
    $exitCode = -1
    $text = ""

    if (!(Test-Path $script)) {
        $text = "ERROR: probe script not found: $script"
    } elseif ($case.requiresModel -and ([string]::IsNullOrWhiteSpace($OnnxModel) -or !(Test-Path $OnnxModel))) {
        $text = "ERROR: ONNX model is required for inference validation"
    } else {
        $quotedArgs = @($case.args | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | ForEach-Object { '"' + ([string]$_).Replace('"','\"') + '"' })
        $command = 'call "' + $script + '"'
        if ($quotedArgs.Count -gt 0) { $command += ' ' + ($quotedArgs -join ' ') }
        $lines = & cmd.exe /d /c $command 2>&1
        $exitCode = $LASTEXITCODE
        $text = ($lines | Out-String)
        if ($exitCode -eq 0 -and $text.Contains([string]$case.marker)) {
            $status = if ($case.conditional) { "CONDITIONAL" } else { "PASS" }
        }
    }

    $text | Set-Content -Encoding UTF8 $logPath
    $results += [ordered]@{
        name = $name
        status = $status
        exit_code = $exitCode
        expected_marker = [string]$case.marker
        elapsed_seconds = [math]::Round(((Get-Date)-$started).TotalSeconds,3)
        log = $logPath
    }
    Write-Host "$name`: $status exit=$exitCode"
}

$failures = @($results | Where-Object status -eq "FAIL").Count
$conditional = @($results | Where-Object status -eq "CONDITIONAL").Count
$summaryStatus = if ($failures -gt 0) { "FAIL" } elseif ($conditional -gt 0) { "PASS_WITH_CONDITIONAL" } else { "PASS" }
$summary = [ordered]@{
    schema = "uxb.runtime_library_probes.v1"
    status = $summaryStatus
    generated_at = (Get-Date).ToString("o")
    root = $Root
    onnx_model = $OnnxModel
    llama_model = $LlamaModel
    totals = [ordered]@{ total=$results.Count; pass=@($results | Where-Object status -eq "PASS").Count; conditional=$conditional; fail=$failures }
    results = $results
}
$summaryPath = Join-Path $reportDir "runtime_library_probes.json"
$summary | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 $summaryPath
Write-Host "SUMMARY=$summaryStatus REPORT=$summaryPath"
exit $(if ($failures -eq 0) { 0 } else { 1 })
