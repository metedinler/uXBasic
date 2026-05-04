@echo off
setlocal EnableExtensions
pushd "%~dp0\..\.."
if errorlevel 1 exit /b 1
call "%~dp0interop\toolchain.env.bat"
if errorlevel 1 exit /b 1
if not exist "%~dp0obj" mkdir "%~dp0obj"
"%UXB_ASM_CMD%" -f win64 "%~dp0program.asm" -o "%~dp0obj\program.obj"
if errorlevel 1 (
  popd
  exit /b 1
)
"%UXB_ASM_CMD%" -f win64 "%~dp0entry_shim.asm" -o "%~dp0obj\entry_shim.obj"
if errorlevel 1 (
  popd
  exit /b 1
)
if exist "%~dp0interop\ffi_resolver.c" (
  "%UXB_CC_CMD%" -c "%~dp0interop\ffi_resolver.c" -o "%~dp0obj\ffi_resolver.obj"
  if errorlevel 1 (
    popd
    exit /b 1
  )
)
if exist "%~dp0obj\ffi_call_x64_stubs.obj" del /Q "%~dp0obj\ffi_call_x64_stubs.obj"
if exist "%~dp0interop\build_import.bat" (
  call "%~dp0interop\build_import.bat"
  if errorlevel 1 (
    popd
    exit /b 1
  )
)
popd
exit /b 0
