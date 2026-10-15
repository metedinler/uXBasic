param(
    [string]$Root = ".",
    [string]$Source = "bin\book_layer_demo.uxb"
)

$ErrorActionPreference = "Stop"
$RootPath = (Resolve-Path $Root).Path
Set-Location $RootPath

$Out = Join-Path $RootPath "reports\book_layers\book_layer_demo"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $RootPath "bin") | Out-Null

$srcPath = Join-Path $RootPath $Source
if (-not (Test-Path $srcPath)) {
@'
%%SET MOD = "KITAP"
%%IF MOD == "KITAP"
PRINT "PREPROCESS_OK"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 20
DIM toplam AS I32

toplam = a + b

IF toplam >= 30 THEN
    PRINT "TOPLAM_OK"
ELSE
    PRINT "TOPLAM_HATA"
END IF

FUNCTION IkiKat(x AS I32) AS I32
    RETURN x * 2
END FUNCTION

PRINT IkiKat(toplam)
'@ | Set-Content -Encoding UTF8 $srcPath
}

$uxb = Join-Path $RootPath "bin\uxb.exe"
if (-not (Test-Path $uxb)) {
    Write-Host "UYARI: bin\uxb.exe bulunamadı. Önce .\build_64.bat çalıştırılmalı." -ForegroundColor Yellow
}

& $uxb $srcPath --pp A --preprocessed-out "$Out\01_preprocessed_A.uxb" --preprocess-result-json-out "$Out\01_preprocess_A.json"
& $uxb $srcPath --pp B --preprocessed-out "$Out\01_preprocessed_B.uxb" --preprocess-result-json-out "$Out\01_preprocess_B.json"
& $uxb $srcPath --pp A --debug-token-dump --tokens-json-out "$Out\02_tokens.json" --lexer-diagnostics-json-out "$Out\02_lexer_diag.json" --preprocessed-out "$Out\02_preprocessed.uxb"
& $uxb $srcPath --parse-only --ast-json-out "$Out\03_ast.json" --parser-diagnostics-json-out "$Out\03_parser_diag.json"
& $uxb $srcPath --ast-contract-check --ast-json-out "$Out\04_ast_contract_ast.json" --ast-contract-json-out "$Out\04_ast_contract.json" --ast-contract-matrix-out "$Out\04_ast_contract_matrix.json"
& $uxb $srcPath --execmem --interpreter-backend AST --stdout-out "$Out\05_ast_stdout.txt" --stderr-out "$Out\05_ast_stderr.txt" --run-report-json-out "$Out\05_ast_run_report.json"
& $uxb $srcPath --semantic --hir-json-out "$Out\06_hir.json" --hir-inventory-json-out "$Out\06_hir_inventory.json"
& $uxb $srcPath --mir-verify --mir-json-out "$Out\07_mir.json" --mir-full-json-out "$Out\07_mir_full.json" --mir-opcodes-json-out "$Out\07_mir_opcodes.json" --mir-surface-json-out "$Out\07_mir_surface.json" --mir-verify-json-out "$Out\07_mir_verify.json" --mir-opt-report-json-out "$Out\07_mir_opt_report.json"
& $uxb $srcPath --execmem --interpreter-backend MIR --mir-exec-result-json-out "$Out\08_mir_exec_result.json" --mir-live-json-out "$Out\08_mir_live.json" --mir-stdout-out "$Out\08_mir_stdout.txt" --mir-stderr-out "$Out\08_mir_stderr.txt" --mir-program-output-out "$Out\08_mir_program_output.txt" --run-report-json-out "$Out\08_mir_run_report.json"
& $uxb $srcPath --execmem --interpreter-backend BOTH --stdout-out "$Out\09_both_stdout.txt" --stderr-out "$Out\09_both_stderr.txt" --run-report-json-out "$Out\09_both_run_report.json"
& $uxb $srcPath --codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out "$Out\10_book_layer_demo_x64.asm" --backend-report-json-out "$Out\10_x64_backend_report.json"
& $uxb $srcPath --emit-js --js-out "$Out\12_program.js" --js-runtime-out "$Out\12_uxb_runtime.js" --backend-report-json-out "$Out\12_js_backend_report.json"
& $uxb $srcPath --emit-wat --wat-out "$Out\13_program.wat" --backend-report-json-out "$Out\13_wat_backend_report.json"
& $uxb $srcPath --emit-browser --html-out "$Out\15_index.html" --js-out "$Out\15_program.js" --js-runtime-out "$Out\15_uxb_runtime.js" --backend-report-json-out "$Out\15_browser_backend_report.json"

Write-Host "OK: katman çıktıları üretildi: $Out" -ForegroundColor Green
