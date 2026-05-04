@echo off
setlocal EnableExtensions
pushd "%~dp0\..\..\.."
if errorlevel 1 exit /b 1
call "%~dp0toolchain.env.bat"
if errorlevel 1 exit /b 1
if not exist "%~dp0import_link_args.rsp" (
  echo [interop] missing response file: %~dp0import_link_args.rsp
  popd
  exit /b 1
)
"%UXB_LINK_CMD%" @"%~dp0import_link_args.rsp" -o "%~dp0interop_program.exe"
if errorlevel 1 (
  popd
  exit /b 1
)
echo [interop] link complete: %~dp0interop_program.exe
popd
exit /b 0
