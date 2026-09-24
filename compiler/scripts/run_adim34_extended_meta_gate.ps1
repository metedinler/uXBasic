param([switch]$NoRepair)
$ErrorActionPreference = "Stop"

function Find-UxbRoot {
    $p = (Get-Location).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src")) -and (Test-Path (Join-Path $p "compiler"))) { return $p }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root not found" }
        $p = $parent
    }
}

$root = Find-UxbRoot
Set-Location $root
$current = "reports/control/current"
New-Item -ItemType Directory -Force -Path $current | Out-Null

$gatePath = Join-Path $current "adim34_extended_meta_gate.json"
$matrixOut = Join-Path $current "adim34_meta_command_matrix.csv"
$compileLog = Join-Path $current "adim34_extended_meta_compile.log"

$required = @(
  "src/preprocessor/preprocess_meta_model.fbs",
  "src/preprocessor/preprocess_meta_eval_adim34.fbs",
  "src/parser/lexer/lexer_preprocess.fbs"
)
$missing = @()
foreach ($r in $required) { if (-not (Test-Path $r)) { $missing += $r } }

$cmds = @(
"IFN","ELIF","PROFILE","CONFIG_FILE","PATH_ALIAS","LOCK_META","DUMP_META","SOURCE_MAP","EMITNOTE","ENV","DEPRECATED","TEMPLATE_BEGIN","TEMPLATE_END","TEMPLATE_USE","MINIFY","FINGERPRINT_ASSETS","HASHFILE","COPY_DIR","EMBEDTEXT","EMBEDBASE64","LICENSEFILE","HTMLIMAGE","HTMLAUDIO","CSS_RULE","CSS_IMPORT","MD_SAFE","MD_CSS","BREAK","CONTINUE","INFOMETA"
)

$rows = @()
foreach ($c in $cmds) {
    $found = $false
    if (Test-Path "src/parser/lexer/lexer_preprocess.fbs") {
        $hit = Select-String -Path "src/parser/lexer/lexer_preprocess.fbs" -Pattern "`"$c`"" -SimpleMatch -ErrorAction SilentlyContinue
        if ($hit) { $found = $true }
    }
    $rows += [pscustomobject]@{ command="%%$c"; found_in_lexer_preprocess=$found }
}
$rows | Export-Csv -NoTypeInformation -Encoding UTF8 $matrixOut

# Build if available, force wrapper rebuild if supported.
$env:UXB_FORCE_REBUILD = "1"
$buildExit = 0
if (Test-Path "compiler/scripts/build_uxb_main_64.bat") {
    & cmd /c "compiler\scripts\build_uxb_main_64.bat" *> $compileLog
    $buildExit = $LASTEXITCODE
} elseif (Test-Path "build_64.bat") {
    & cmd /c "build_64.bat" *> $compileLog
    $buildExit = $LASTEXITCODE
} else {
    "No build script found; command presence check only." | Set-Content -Encoding UTF8 $compileLog
}

$ok = ($missing.Count -eq 0 -and $buildExit -eq 0)
$obj = [ordered]@{
    step = "ADIM34_EXTENDED_META_COMMANDS"
    ok = $ok
    build_exit_code = $buildExit
    missing = $missing
    matrix = "reports/control/current/adim34_meta_command_matrix.csv"
    compile_log = "reports/control/current/adim34_extended_meta_compile.log"
}
$obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 $gatePath
if ($ok) { exit 0 } else { exit 1 }
