@echo off
setlocal

set ROOT=%~dp0
set SRC=%ROOT%src\uxstat.c
set INC=%ROOT%include
set OUT=%ROOT%uxstat.dll
set TESTSRC=%ROOT%tests\uxstat_smoke.c
set TESTEXE=%ROOT%tests\uxstat_smoke.exe
set CC=

where clang >nul 2>nul
if not errorlevel 1 set CC=clang

if "%CC%"=="" (
  where gcc >nul 2>nul
  if not errorlevel 1 set CC=gcc
)

if "%CC%"=="" (
  echo [UXSTAT] Uygun C derleyicisi bulunamadi. clang veya gcc PATH'e eklenmeli.
  exit /b 1
)

echo [UXSTAT] Derleyici: %CC%

echo [UXSTAT] DLL derleniyor...
%CC% -DUXSTAT_EXPORTS -shared -O2 -I"%INC%" "%SRC%" -o "%OUT%" -lm
if errorlevel 1 exit /b 1

echo [UXSTAT] Smoke test derleniyor...
%CC% -DUXSTAT_EXPORTS -O2 -I"%INC%" "%TESTSRC%" "%SRC%" -o "%TESTEXE%" -lm
if errorlevel 1 exit /b 1

echo [UXSTAT] Smoke test calistiriliyor...
"%TESTEXE%"
if errorlevel 1 exit /b 1

echo [UXSTAT] OK
exit /b 0
