@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist "uxb\tools\control\uxb_surface_test_generator.py" (
  python uxb\tools\control\uxb_surface_test_generator.py --root uxb --strict
  if errorlevel 1 exit /b %errorlevel%
) else (
  echo Missing uxb\tools\control\uxb_surface_test_generator.py
  exit /b 1
)

python uxb\tools\control\uxb_run_layer_tests.py --root uxb --strict
if errorlevel 1 exit /b %errorlevel%

python uxb\tools\control\uxb_expected_actual_compare.py --root uxb --strict
if errorlevel 1 exit /b %errorlevel%

endlocal
