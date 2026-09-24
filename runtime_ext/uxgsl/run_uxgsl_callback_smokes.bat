@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "MSYSBIN=C:\msys64\ucrt64\bin"
set "PATH=%MSYSBIN%;%PATH%"

call uxb\runtime_ext\uxgsl\build_uxgsl_dll.bat
if errorlevel 1 exit /b 1

cd /d uxb
set "UXB=bin\uxb.exe"
set "TESTDIR=tests\libraries\uxgsl"
set "BUILDDIR=build"

rem The generic x64 builder may retain an existing app-local DLL.  Always
rem stage the freshly built facade beside these executable smoke artifacts.
copy /Y bin\uxgsl.dll "%TESTDIR%\uxgsl.dll" >nul || exit /b 2
copy /Y bin\libgsl-28.dll "%TESTDIR%\libgsl-28.dll" >nul || exit /b 2
copy /Y bin\libgslcblas-0.dll "%TESTDIR%\libgslcblas-0.dll" >nul || exit /b 2

"%UXB%" bld "%TESTDIR%\uxgsl_basic_callback_smoke.uxb" --build-x64 --build-x64-out "%TESTDIR%\uxgsl_basic_callback_smoke.exe" || exit /b 3
"%TESTDIR%\uxgsl_basic_callback_smoke.exe" || exit /b 4
"%UXB%" bld "%TESTDIR%\uxgsl_basic_root_bisection_smoke.uxb" --build-x64 --build-x64-out "%TESTDIR%\uxgsl_basic_root_bisection_smoke.exe" || exit /b 5
"%TESTDIR%\uxgsl_basic_root_bisection_smoke.exe" || exit /b 6

"%GCC%" -std=c11 -O2 -I. tests\libraries\uxgsl\uxgsl_matrix_native_smoke.c -Ldist\runtime_ext -luxgsl -o "%BUILDDIR%\uxgsl_matrix_native_smoke.exe" || exit /b 7
copy /Y dist\runtime_ext\uxgsl.dll "%BUILDDIR%\uxgsl.dll" >nul || exit /b 8
copy /Y "%MSYSBIN%\libgsl-28.dll" "%BUILDDIR%\libgsl-28.dll" >nul || exit /b 8
copy /Y "%MSYSBIN%\libgslcblas-0.dll" "%BUILDDIR%\libgslcblas-0.dll" >nul || exit /b 8
copy /Y "%MSYSBIN%\libgcc_s_seh-1.dll" "%BUILDDIR%\libgcc_s_seh-1.dll" >nul || exit /b 8
copy /Y "%MSYSBIN%\libwinpthread-1.dll" "%BUILDDIR%\libwinpthread-1.dll" >nul || exit /b 8
"%BUILDDIR%\uxgsl_matrix_native_smoke.exe" || exit /b 9

echo UXGSL_CALLBACK_SMOKES_PASS
exit /b 0
