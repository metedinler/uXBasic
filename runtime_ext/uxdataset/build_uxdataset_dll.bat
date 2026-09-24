@echo off
setlocal EnableExtensions EnableDelayedExpansion
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
if defined UXB_GCC (
  set "GCC=%UXB_GCC%"
) else if exist "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe" (
  set "GCC=C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
) else (
  set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
)
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "SRC=%UXB_ROOT%\runtime_ext\uxdataset\uxdataset.c"
set "OUTDIR=%UXB_ROOT%\dist\libraries\bin"
set "LEGACY=%UXB_ROOT%\dist\runtime_ext"
set "LIBDIR=%UXB_ROOT%\dist\libraries\lib"
set "LOGDIR=%UXB_ROOT%\reports\libraries\logs"
set "OUTDLL=%OUTDIR%\uxdataset.dll"
set "IMPLIB=%LIBDIR%\libuxdataset.dll.a"
for %%D in ("%OUTDIR%" "%LEGACY%" "%LIBDIR%" "%LOGDIR%" "%UXB_ROOT%\bin") do if not exist "%%~D" mkdir "%%~D"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc bulunamadi: %GCC%
  exit /b 2
)
if not exist "%SRC%" (
  echo ERROR: Kaynak bulunamadi: %SRC%
  exit /b 3
)
echo GCC=%GCC%>"%LOGDIR%\uxdataset_gcc.log"
echo SRC=%SRC%>>"%LOGDIR%\uxdataset_gcc.log"
echo OUT=%OUTDLL%>>"%LOGDIR%\uxdataset_gcc.log"
"%GCC%" -std=c11 -O2 -Wall -Wextra -shared -static-libgcc  -Wl,--enable-auto-import -Wl,--out-implib,"%IMPLIB%" -o "%OUTDLL%" "%SRC%" -lm >>"%LOGDIR%\uxdataset_gcc.log" 2>&1
if errorlevel 1 (
  type "%LOGDIR%\uxdataset_gcc.log"
  echo ERROR: uxdataset.dll build failed.
  exit /b 1
)
copy /y "%OUTDLL%" "%LEGACY%\uxdataset.dll" >nul
copy /y "%OUTDLL%" "%UXB_ROOT%\bin\uxdataset.dll" >nul
echo OK: %OUTDLL%
exit /b 0
