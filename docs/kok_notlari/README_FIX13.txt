uXBasic FIX-13 — browser_wasm kalan 6 test

Yöntem: KOPYALA-EZ / FULL FILE REPLACE
Patch runner değildir.

Değişen dosya:
  src/preprocessor/preprocess_engine.fbs

Yedek uzantısı:
  .bak_fix13

Uygulama:
  python copy_over_fix13_browser_wasm.py --root . --dry-run
  python copy_over_fix13_browser_wasm.py --root .
  .\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log

Test:
  python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only browser_wasm
  python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only negative
  python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
