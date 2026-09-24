@echo off
setlocal
cd /d "%~dp0..\..\.."
call uxb\tests\uxstats2\build_and_run_uxstats2_probe.bat
if errorlevel 1 exit /b 1
if exist build_compiler_64.bat (
  call build_compiler_64.bat
  if errorlevel 1 exit /b 1
  if exist uxb\compiler\wrappers\uxb_main_wrapper_64.exe (
    uxb\compiler\wrappers\uxb_main_wrapper_64.exe uxb\tests\uxstats2\uxstats2_include_smoke.bas --execmem --interpreter-backend AST --debug
  )
)
endlocal
