@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
set "MSYS_BIN=C:\msys64\ucrt64\bin"
set "OPENBLAS=%MSYS_BIN%\libopenblas.dll"

if not exist "%OPENBLAS%" (
  echo INFO: libopenblas.dll not present; built-in fallback has no external dependency.
  exit /b 0
)

for %%F in (libopenblas.dll libgcc_s_seh-1.dll libgfortran-5.dll libgomp-1.dll libquadmath-0.dll libwinpthread-1.dll) do (
  if not exist "%MSYS_BIN%\%%F" (
    echo ERROR: required OpenBLAS runtime dependency missing: %%F
    exit /b 1
  )
  for %%D in ("%UXB_ROOT%\dist\libraries\deps" "%UXB_ROOT%\dist\runtime_ext" "%UXB_ROOT%\bin") do (
    if not exist "%%~D" mkdir "%%~D"
    copy /y "%MSYS_BIN%\%%F" "%%~D\%%F" >nul || exit /b 1
  )
)

echo OK: OpenBLAS runtime dependency closure deployed beside uxmatrix outputs.
exit /b 0
