@echo off
setlocal EnableExtensions
pushd "%~dp0\..\..\.."
if errorlevel 1 exit /b 1
call "%~dp0toolchain.env.bat"
if errorlevel 1 exit /b 1
if not exist "%~dp0import_objs" mkdir "%~dp0import_objs"
echo [interop] toolchain source: host-fallback:codeblocks
echo [interop] cc=%UXB_CC_CMD% cxx=%UXB_CXX_CMD% asm=%UXB_ASM_CMD% link=%UXB_LINK_CMD%
echo [interop] compiling imports...
echo [interop] import compile complete.
popd
exit /b 0
