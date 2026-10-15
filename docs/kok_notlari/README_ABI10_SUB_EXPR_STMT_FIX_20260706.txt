UXB_ABI10_SUB_EXPR_STMT_FIX_20260706_DIRECT_ROOT

Kok neden:
  tests/libraries/abi10/abi10_smoke.uxb icindeki ABI10_PointFree(point) satiri
  AST'de CALL_STMT degil, EXPR_STMT -> CALL_EXPR olarak geliyor. Runtime ExecRunTailStmt
  EXPR_STMT icin ExecEvalNode kullaniyordu. ExecEvalNode CALL_EXPR'i ifade kabul edip
  expectValue=1 ile ExecEvalCall'a indiriyor; SUB oldugu icin "call in expression requires FUNCTION"
  hatasi uretiliyordu.

Duzeltme:
  src/runtime/memory_exec.fbs / ExecRunTailStmt / EXPR_STMT kolunda, sol/ilk dugum CALL_EXPR ise
  ExecEvalCall(..., expectValue=0, ...) ile statement-level/no-return olarak calistirilir.

Uygulama:
  Expand-Archive -LiteralPath .\UXB_ABI10_SUB_EXPR_STMT_FIX_20260706_DIRECT_ROOT.zip -DestinationPath . -Force
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\compiler\scripts\build_uxb_main_64.ps1 -Root . -Force -SkipX86
  .\tests\libraries\abi10\build_abi10_test_dll.bat
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\compiler\scripts\run_library_abi10_smoke.ps1 -Root . -SkipBuild

Kontrol:
  Select-String -Path .\src\runtime\memory_exec.fbs -Pattern "ABI10_SUB_EXPR_STMT_FIX"
