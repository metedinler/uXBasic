@echo off
setlocal
cd /d "%~dp0..\..\.."

python uxb\tools\uxb_prior_step_gap_audit.py
python uxb\tools\uxb_test_matrix_linker.py
python uxb\tools\uxb_expected_runner.py --max-tests 40 %*
python uxb\tools\uxb_layer_gate.py
python uxb\tools\uxb_release_gate.py --max-tests 40 %*

echo.
echo Step 6 raporlari:
echo   uxb\dist\step6\release_gate.md
echo   uxb\dist\step6\layer_gate.md
echo   uxb\dist\step6\expected_runner.md
echo   uxb\dist\step6\prior_step_gap_audit.md
echo   uxb\dist\step6\copilot_step6_missing_work.md
endlocal
