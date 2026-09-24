param(
    [Parameter(Mandatory = $true)] [string]$Source,
    [ValidateSet("AST", "HIR", "MIR", "ALL")] [string]$Layer = "ALL",
    [string]$OutDir = "dist/vscode_json",
    [ValidateSet("AST", "MIR")] [string]$InterpreterBackend = "AST",
    [ValidateSet("AST", "MIR")] [string]$CodegenSource = "AST",
    [string]$WorkspaceRoot = ""
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "workspace_root_helpers.ps1")

$root = Resolve-UxbWorkspaceRoot -HintPath $WorkspaceRoot
Set-Location $root

$compiler = Resolve-UxbCompilerExe -WorkspaceRoot $root -Arch "x64"
if (-not (Test-Path $compiler)) {
    $mainArg = Resolve-UxbCompilerMainArg -WorkspaceRoot $root
    cmd /c ("build_64.bat " + $mainArg) | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "compiler build failed" }
}

$sourcePath = Resolve-UxbPath -WorkspaceRoot $root -PathText $Source
if (-not (Test-Path $sourcePath)) {
    throw "source not found: $Source"
}

$outPath = $OutDir
if (-not [System.IO.Path]::IsPathRooted($outPath)) {
    $outPath = Join-Path $root $outPath
}
New-Item -ItemType Directory -Path $outPath -Force | Out-Null

$base = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
$astOut = Join-Path $outPath ("$base.ast.json")
$hirOut = Join-Path $outPath ("$base.hir.json")
$mirPipelineOut = Join-Path $outPath ("$base.mir_pipeline.json")
$mirSurfaceOut = Join-Path $outPath ("$base.mir_surface.json")
$reportOut = Join-Path $outPath ("$base.report.json")
$sessionOut = Join-Path $outPath ("$base.session.json")
$sessionLiveOut = Join-Path $outPath "session.live.json"

$args = @($sourcePath, "--interpreter-backend", $InterpreterBackend, "--codegen-source", $CodegenSource, "--artifact-report-json-out", $reportOut)

$sourceText = Get-Content -Path $sourcePath -Raw
$looksLikeHarness = $false
if ($sourceText -match "RTParseProgram\(") { $looksLikeHarness = $true }
if ($sourceText -match "RTExecProgram\(") { $looksLikeHarness = $true }
if ($sourceText -match "(?i)\bsrc\s*=") { $looksLikeHarness = $true }
if ($looksLikeHarness) {
    $args += "--extract-src"
}

switch ($Layer) {
    "AST" { $args += @("--ast-json-out", $astOut) }
    "HIR" { $args += @("--hir-json-out", $hirOut) }
    "MIR" { $args += @("--mir-pipeline-json-out", $mirPipelineOut, "--mir-opcodes-json-out", $mirSurfaceOut) }
    "ALL" {
        $args += @(
            "--ast-json-out", $astOut,
            "--hir-json-out", $hirOut,
            "--mir-pipeline-json-out", $mirPipelineOut,
            "--mir-opcodes-json-out", $mirSurfaceOut
        )
    }
}

& $compiler @args
if ($LASTEXITCODE -ne 0) {
    throw "compiler run failed: exit=$LASTEXITCODE"
}

function Read-JsonSafe {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    try {
        return (Get-Content -Path $Path -Raw | ConvertFrom-Json)
    } catch {
        try {
            $raw = Get-Content -Path $Path -Raw
            $fixed = $raw -replace "\\", "\\\\"
            return ($fixed | ConvertFrom-Json)
        } catch {
            return $null
        }
    }
}

$astJson = Read-JsonSafe -Path $astOut
$hirJson = Read-JsonSafe -Path $hirOut
$mirPipelineJson = Read-JsonSafe -Path $mirPipelineOut
$mirSurfaceJson = Read-JsonSafe -Path $mirSurfaceOut
$reportJson = Read-JsonSafe -Path $reportOut

$astNodeCount = $null
if ($astJson -and $astJson.PSObject.Properties.Name -contains "node_count") {
    $astNodeCount = [int]$astJson.node_count
}

$hirSummary = @{}
if ($hirJson) {
    $hirSummary = @{
        commands = @($hirJson.commands).Count
        functions = @($hirJson.functions).Count
        operators = @($hirJson.operators).Count
        types = @($hirJson.types).Count
        data_structures = @($hirJson.data_structures).Count
    }
}

$mirSummary = @{}
if ($mirPipelineJson -or $mirSurfaceJson) {
    $mirSummary = @{
        pipeline_stage_count = @($mirPipelineJson.pipeline).Count
        supported_opcode_count = @($mirSurfaceJson.mir_supported_opcodes).Count
    }
}

$session = [ordered]@{
    schema_version = "1.0"
    generated_at_utc = (Get-Date).ToUniversalTime().ToString("o")
    source = $sourcePath
    source_short = [System.IO.Path]::GetFileName($sourcePath)
    layer_request = $Layer
    modes = @{
        interpreter_backend = $InterpreterBackend
        codegen_source = $CodegenSource
    }
    stages = if ($reportJson) { $reportJson.stages } else { @{} }
    execution = if ($reportJson) { $reportJson.execution } else { @{} }
    routing = if ($reportJson) { $reportJson.routing } else { @{} }
    outputs = @{
        ast_json = if (Test-Path $astOut) { $astOut } else { $null }
        hir_json = if (Test-Path $hirOut) { $hirOut } else { $null }
        mir_pipeline_json = if (Test-Path $mirPipelineOut) { $mirPipelineOut } else { $null }
        mir_surface_json = if (Test-Path $mirSurfaceOut) { $mirSurfaceOut } else { $null }
        report_json = if (Test-Path $reportOut) { $reportOut } else { $null }
    }
    summaries = @{
        ast = @{
            node_count = $astNodeCount
        }
        hir = $hirSummary
        mir = $mirSummary
    }
    runtime_view = @{
        values = @()
        namespaces = @()
        subprograms = @()
        events = @()
        threads = @()
        pipes = @()
    }
}

$session | ConvertTo-Json -Depth 20 | Set-Content -Path $sessionOut
$session | ConvertTo-Json -Depth 20 | Set-Content -Path $sessionLiveOut

Write-Host "JSON export complete"
Write-Host "layer=$Layer"
Write-Host "out=$outPath"
Write-Host "session=$sessionOut"
Write-Host "session_live=$sessionLiveOut"
