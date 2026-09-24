@echo off
setlocal
cd /d "%~dp0..\..\.."
set "DEPDIR=uxb\dist\runtime_ext\deps\uxllama"
if not exist "%DEPDIR%" mkdir "%DEPDIR%"
for %%F in ("%DEPDIR%\llama.cpp\build\bin\llama-cli.exe" "%DEPDIR%\llama.cpp\build\bin\Release\llama-cli.exe" "%DEPDIR%\llama.cpp\build\bin\llama-cli") do (
  if exist %%~F copy /Y %%~F "%DEPDIR%\llama-cli.exe" >nul
)
for %%F in (libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll) do (
  if exist "C:\msys64\ucrt64\bin\%%F" copy /Y "C:\msys64\ucrt64\bin\%%F" "%DEPDIR%\%%F" >nul
)
python uxb\runtime_ext\uxllama\uxllama_dependency_registry.py
endlocal
