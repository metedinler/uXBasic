[CmdletBinding()]
param(
    [string]$Uxb = "",
    [string]$RunId = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$uxbRoot = (Resolve-Path (Join-Path $scriptDir "..\..")).Path

if ([string]::IsNullOrWhiteSpace($Uxb)) {
    $Uxb = Join-Path $uxbRoot "bin\uxb.exe"
}
$Uxb = (Resolve-Path $Uxb).Path

if ([string]::IsNullOrWhiteSpace($RunId)) {
    $RunId = Get-Date -Format "yyyyMMdd_HHmmss"
}
if ($RunId -notmatch "^[A-Za-z0-9_.-]+$") {
    throw "RunId yalniz harf, sayi, nokta, alt cizgi ve tire icerebilir."
}

$reportRoot = Join-Path $scriptDir "reports\book_runs\$RunId"
New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null
$results = [System.Collections.Generic.List[object]]::new()

function Add-Result {
    param(
        [string]$Id,
        [string]$Status,
        [int]$ExitCode,
        [long]$DurationMs,
        [string[]]$Errors,
        [string[]]$Artifacts
    )

    $results.Add([pscustomobject]@{
        id = $Id
        status = $Status
        exitCode = $ExitCode
        durationMs = $DurationMs
        errors = @($Errors)
        artifacts = @($Artifacts)
    })
}

function Invoke-ProcessCase {
    param(
        [string]$Id,
        [string]$Command,
        [string[]]$Arguments,
        [int]$ExpectedExitCode = 0,
        [string]$ExpectedText = "",
        [string]$ExpectedErrorText = "",
        [string[]]$Artifacts = @(),
        [string[]]$JsonArtifacts = @()
    )

    $stdoutPath = Join-Path $reportRoot "$Id.output.txt"
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $output = & $Command @Arguments 2>&1 | Out-String
    $exitCode = $LASTEXITCODE
    $timer.Stop()
    [System.IO.File]::WriteAllText($stdoutPath, $output)

    $errors = [System.Collections.Generic.List[string]]::new()
    if ($exitCode -ne $ExpectedExitCode) {
        $errors.Add("exit code: beklenen=$ExpectedExitCode gercek=$exitCode")
    }
    if ($ExpectedText -and $output -notmatch [regex]::Escape($ExpectedText)) {
        $errors.Add("beklenen cikti yok: $ExpectedText")
    }
    if ($ExpectedErrorText -and $output -notmatch [regex]::Escape($ExpectedErrorText)) {
        $errors.Add("beklenen tani yok: $ExpectedErrorText")
    }

    foreach ($artifact in $Artifacts) {
        if (-not (Test-Path -LiteralPath $artifact -PathType Leaf)) {
            $errors.Add("artifact yok: $artifact")
            continue
        }
        if ((Get-Item -LiteralPath $artifact).Length -le 0) {
            $errors.Add("artifact bos: $artifact")
        }
    }

    foreach ($jsonArtifact in $JsonArtifacts) {
        if (-not (Test-Path -LiteralPath $jsonArtifact -PathType Leaf)) {
            $errors.Add("JSON artifact yok: $jsonArtifact")
            continue
        }
        try {
            Get-Content -Raw -LiteralPath $jsonArtifact | ConvertFrom-Json | Out-Null
        } catch {
            $errors.Add("JSON ayrisamadi: $jsonArtifact - $($_.Exception.Message)")
        }
    }

    $allArtifacts = @($stdoutPath) + $Artifacts + $JsonArtifacts
    $status = if ($errors.Count -eq 0) { "pass" } else { "fail" }
    Add-Result -Id $Id -Status $status -ExitCode $exitCode `
        -DurationMs $timer.ElapsedMilliseconds -Errors $errors.ToArray() `
        -Artifacts $allArtifacts
}

function Invoke-UxbInterpreterCase {
    param(
        [string]$Id,
        [string]$Source,
        [string]$Backend,
        [string]$Marker
    )

    Invoke-ProcessCase -Id "${Id}_$($Backend.ToLowerInvariant())" `
        -Command $Uxb `
        -Arguments @("int", $Source, "--execmem", "--interpreter-backend", $Backend) `
        -ExpectedText $Marker
}

Push-Location $uxbRoot
try {
    $interpreterCases = @(
        @("cilt1_kargo", "docs/uxbasic_5_cilt/examples/cilt1/01_kargo_ucreti.uxb", "CILT1_KARGO_PASS"),
        @("cilt1_bit", "docs/uxbasic_5_cilt/examples/cilt1/02_paket_bayraklari.uxb", "CILT1_BIT_PASS"),
        @("cilt1_preprocessor", "docs/uxbasic_5_cilt/examples/cilt1/03_preprocessor_a.uxb", "CILT1_PREPROCESSOR_PASS"),
        @("cilt2_pipe", "docs/uxbasic_5_cilt/examples/cilt2/01_saf_fonksiyon_ve_pipe.uxb", "CILT2_SAF_PIPE_PASS"),
        @("cilt2_recursion", "docs/uxbasic_5_cilt/examples/cilt2/02_oz_yinelemeli_ebob.uxb", "CILT2_RECURSION_PASS"),
        @("cilt2_collection", "docs/uxbasic_5_cilt/examples/cilt2/03_cekirdek_koleksiyonlar.uxb", "CILT2_COLLECTION_PASS"),
        @("cilt2_oop", "docs/uxbasic_5_cilt/examples/cilt2/04_oop_gonderi_kurali.uxb", "CILT2_OOP_PASS"),
        @("cilt3_pipeline", "docs/uxbasic_5_cilt/examples/cilt3/01_pipeline_probe.uxb", "CILT3_PIPELINE_PASS"),
        @("cilt3_wasm_score_ast_mir", "docs/uxbasic_5_cilt/examples/cilt3/02_wasm_skoru.uxb", "CILT3_WASM_PASS"),
        @("kargo_stage1", "docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/01_model_ve_kural.uxb", "KARGO_ASAMA1_PASS"),
        @("kargo_stage2_oop", "docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/02_oop_ve_rekursiyon.uxb", "KARGO_ASAMA2_OOP_PASS"),
        @("kargo_stage2_recursion", "docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/02b_rekursif_kod_kontrolu.uxb", "KARGO_ASAMA2_RECURSION_PASS"),
        @("kargo_stage3", "docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/03_koleksiyon_ve_pipe.uxb", "KARGO_ASAMA3_PASS"),
        @("kargo_stage4", "docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/04_dosya_raporu.uxb", "KARGO_ASAMA4_PASS"),
        @("kargo_main", "docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/main.uxb", "KARGO_MERKEZI_PASS"),
        @("hibrit_core", "docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01_skor_cekirdegi.uxb", "HIBRIT_ASAMA1_PASS"),
        @("reg_collection_type", "docs/uxbasic_5_cilt/examples/regressions/01_collection_len_i32.uxb", "BOOK_REG_COLLECTION_PASS"),
        @("reg_magic_hash", "docs/uxbasic_5_cilt/examples/regressions/02_magic_hash_dispatch.uxb", "BOOK_REG_MAGIC_HASH_PASS"),
        @("reg_class_recursion", "docs/uxbasic_5_cilt/examples/regressions/03_class_recursion_coexist.uxb", "BOOK_REG_CLASS_RECURSION_PASS"),
        @("reg_file_string", "docs/uxbasic_5_cilt/examples/regressions/04_file_input_string_roundtrip.uxb", "BOOK_REG_FILE_STRING_PASS"),
        @("reg_collection_full", "docs/uxbasic_5_cilt/examples/regressions/05_collection_full_surface.uxb", "BOOK_REG_COLLECTION_FULL_PASS")
    )

    foreach ($case in $interpreterCases) {
        Invoke-UxbInterpreterCase -Id $case[0] -Source $case[1] -Backend "AST" -Marker $case[2]
        Invoke-UxbInterpreterCase -Id $case[0] -Source $case[1] -Backend "MIR" -Marker $case[2]
    }

    $semanticJson = Join-Path $reportRoot "pipeline.semantic.json"
    Invoke-ProcessCase -Id "semantic_json" -Command $Uxb `
        -Arguments @(
            "sem",
            "docs/uxbasic_5_cilt/examples/cilt3/01_pipeline_probe.uxb",
            "--semantic-json-out",
            $semanticJson
        ) `
        -JsonArtifacts @($semanticJson)

    foreach ($nativeCase in @(
        @("inline", "docs/uxbasic_5_cilt/examples/cilt4/01_inline_x64.uxb"),
        @("import", "docs/uxbasic_5_cilt/examples/cilt4/02_import_native.uxb"),
        @("ffi", "docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb")
    )) {
        $asmPath = Join-Path $reportRoot "$($nativeCase[0]).asm"
        Invoke-ProcessCase -Id "x64_$($nativeCase[0])" -Command $Uxb `
            -Arguments @(
                "x64",
                $nativeCase[1],
                "--emit-x64-nasm",
                "--emit-x64-nasm-out",
                $asmPath
            ) `
            -Artifacts @($asmPath)
    }

    $browserRoot = Join-Path $reportRoot "browser"
    New-Item -ItemType Directory -Force -Path $browserRoot | Out-Null
    $browserApp = Join-Path $browserRoot "app.js"
    $browserRuntime = Join-Path $browserRoot "ux_runtime.js"
    $browserHtml = Join-Path $browserRoot "index.html"
    $browserManifest = Join-Path $browserRoot "manifest.json"
    Invoke-ProcessCase -Id "browser_emit" -Command $Uxb `
        -Arguments @(
            "jsw",
            "docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb",
            "--target-browser",
            "--emit-browser",
            "--js-out", $browserApp,
            "--js-runtime-out", $browserRuntime,
            "--html-out", $browserHtml,
            "--manifest-out", $browserManifest
        ) `
        -Artifacts @($browserApp, $browserRuntime, $browserHtml) `
        -JsonArtifacts @($browserManifest)

    $node = (Get-Command node -ErrorAction Stop).Source
    Invoke-ProcessCase -Id "browser_runtime" -Command $node `
        -Arguments @(
            "docs/uxbasic_5_cilt/examples/projects/hibrit_pano/browser_verify.js",
            $browserApp
        ) `
        -ExpectedText "HIBRIT_BROWSER_PASS"

    $wasmRoot = Join-Path $reportRoot "wasm"
    New-Item -ItemType Directory -Force -Path $wasmRoot | Out-Null
    $watPath = Join-Path $wasmRoot "skor.wat"
    $wasmPath = Join-Path $wasmRoot "skor.wasm"
    Invoke-ProcessCase -Id "wasm_emit" -Command $Uxb `
        -Arguments @(
            "wat",
            "docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm",
            "--target-wasm",
            "--emit-wat",
            "--emit-wasm",
            "--wat-out", $watPath,
            "--wasm-out", $wasmPath,
            "--wat2wasm"
        ) `
        -Artifacts @($watPath, $wasmPath)

    Invoke-ProcessCase -Id "wasm_runtime" -Command $node `
        -Arguments @(
            "docs/uxbasic_5_cilt/examples/projects/hibrit_pano/wasm_verify.js",
            $wasmPath
        ) `
        -ExpectedText "HIBRIT_WASM_PASS"

    $negativeWat = Join-Path $reportRoot "negative_string.wat"
    Invoke-ProcessCase -Id "wat_string_fail_close" -Command $Uxb `
        -Arguments @(
            "wat",
            "docs/uxbasic_5_cilt/examples/cilt3/02_wasm_skoru.uxb",
            "--emit-wat",
            "--wat-out", $negativeWat
        ) `
        -ExpectedExitCode 23 `
        -ExpectedErrorText "WAT string linear-memory lowering is not implemented"

    if (Test-Path -LiteralPath $negativeWat) {
        Add-Result -Id "wat_string_no_artifact" -Status "fail" -ExitCode 0 `
            -DurationMs 0 -Errors @("Reddedilen string WAT derlemesi artifact birakti.") `
            -Artifacts @($negativeWat)
    } else {
        Add-Result -Id "wat_string_no_artifact" -Status "pass" -ExitCode 0 `
            -DurationMs 0 -Errors @() -Artifacts @()
    }
} finally {
    Pop-Location
}

$failed = @($results | Where-Object status -eq "fail")
$summary = [pscustomobject]@{
    schema = "uxbasic.book-tests.v1"
    runId = $RunId
    compiler = $Uxb
    generatedAt = (Get-Date).ToString("o")
    passed = @($results | Where-Object status -eq "pass").Count
    failed = $failed.Count
    results = $results
}

$reportPath = Join-Path $reportRoot "report.json"
$summary | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $reportPath
$summary | Select-Object runId, passed, failed | Format-List
Write-Host "Rapor: $reportPath"

if ($failed.Count -ne 0) {
    $failed | Select-Object id, exitCode, errors | Format-Table -AutoSize
    exit 1
}
exit 0
