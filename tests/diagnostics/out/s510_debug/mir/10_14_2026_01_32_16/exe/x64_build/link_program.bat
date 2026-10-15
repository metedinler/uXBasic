@echo off
setlocal EnableExtensions
pushd "%~dp0\..\.."
if errorlevel 1 exit /b 1
call "%~dp0interop\toolchain.env.bat"
if errorlevel 1 exit /b 1
"%UXB_LINK_CMD%" @"%~dp0program_link_args.rsp" -o "%~dp0program.exe"
if errorlevel 1 (
  popd
  exit /b 1
)
if exist "native\uxb_runtime\build\uxb_runtime.dll" copy /Y "native\uxb_runtime\build\uxb_runtime.dll" "%~dp0uxb_runtime.dll" >nul
if not exist "%~dp0uxb_runtime.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\uxb_runtime.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\uxb_runtime.dll" "%~dp0uxb_runtime.dll" >nul
if not exist "%~dp0uxb_runtime.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\uxb_runtime.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\uxb_runtime.dll" "%~dp0uxb_runtime.dll" >nul
if not exist "%~dp0libwinpthread-1.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libwinpthread-1.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libwinpthread-1.dll" "%~dp0libwinpthread-1.dll" >nul
if not exist "%~dp0libwinpthread-1.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libwinpthread-1.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libwinpthread-1.dll" "%~dp0libwinpthread-1.dll" >nul
if not exist "%~dp0libuv-1.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libuv-1.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libuv-1.dll" "%~dp0libuv-1.dll" >nul
if not exist "%~dp0libuv-1.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libuv-1.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libuv-1.dll" "%~dp0libuv-1.dll" >nul
if not exist "%~dp0libtbb12.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libtbb12.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libtbb12.dll" "%~dp0libtbb12.dll" >nul
if not exist "%~dp0libtbb12.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libtbb12.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libtbb12.dll" "%~dp0libtbb12.dll" >nul
if not exist "%~dp0libgcc_s_seh-1.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libgcc_s_seh-1.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libgcc_s_seh-1.dll" "%~dp0libgcc_s_seh-1.dll" >nul
if not exist "%~dp0libgcc_s_seh-1.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libgcc_s_seh-1.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libgcc_s_seh-1.dll" "%~dp0libgcc_s_seh-1.dll" >nul
if not exist "%~dp0libstdc++-6.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libstdc++-6.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\native\uxb_runtime\build\libstdc++-6.dll" "%~dp0libstdc++-6.dll" >nul
if not exist "%~dp0libstdc++-6.dll" if exist "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libstdc++-6.dll" copy /Y "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\bin\libstdc++-6.dll" "%~dp0libstdc++-6.dll" >nul
if not exist "%~dp0uxb_runtime.dll" (
  echo [x64-build] missing uxb_runtime.dll
  popd
  exit /b 1
)
echo [x64-build] link complete: %~dp0program.exe
popd
exit /b 0
