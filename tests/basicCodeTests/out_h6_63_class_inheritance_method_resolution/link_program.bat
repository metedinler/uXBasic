@echo off
setlocal EnableExtensions
pushd "%~dp0\..\.."
if errorlevel 1 exit /b 1
call "%~dp0interop\toolchain.env.bat"
if errorlevel 1 exit /b 1
"%UXB_LINK_CMD%" @%~dp0program_link_args.rsp -o "%~dp0program.exe"
if errorlevel 1 (
  popd
  exit /b 1
)
echo [x64-build] link complete: %~dp0program.exe
popd
exit /b 0
