@echo off
setlocal
cd /d "%~dp0..\..\.."
set "BASH=C:\msys64\usr\bin\bash.exe"
set "DEPDIR=uxb\dist\runtime_ext\deps\uxllama"
if not exist "%BASH%" (
  echo ERROR: MSYS2 bash not found.
  exit /b 2
)
if not exist "%DEPDIR%" mkdir "%DEPDIR%"
"%BASH%" -lc "cd /c/Users/%USERNAME% 2>/dev/null; true"
"%BASH%" -lc "cd '$(cygpath -u '%CD%')/%DEPDIR%' && if [ ! -d llama.cpp ]; then git clone --depth 1 https://github.com/ggml-org/llama.cpp.git; fi && cd llama.cpp && cmake -B build -G Ninja -DGGML_NATIVE=OFF -DGGML_OPENMP=OFF -DGGML_BLAS=OFF -DGGML_CUDA=OFF -DGGML_VULKAN=OFF -DLLAMA_BUILD_SERVER=OFF && cmake --build build --config Release"
if errorlevel 1 exit /b 1
call uxb\runtime_ext\uxllama\copy_uxllama_runtime_deps.bat
endlocal
