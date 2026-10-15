# uXBasic FIX10 - FULL FILE REPLACE

Yöntem: KOPYALA-EZ / FULL DOSYA DEĞİŞTİRME. Patch runner değildir.

Değiştirilen tam dosyalar:

- src/runtime/exec/exec_state_value_utils.fbs
- src/runtime/exec/exec_eval_text_helpers.fbs
- src/runtime/exec/exec_eval_support_helpers.fbs
- src/runtime/memory_exec.fbs

Hedeflenen kök sorunlar:

1. ExecTryResolveArrayAccess sınır kontrolü eksik olduğu için UCASE(...), TOPLA(...), GEN_ADD(...) gibi normal CALL_EXPR düğümleri runtime error 6 ile çöküyordu.
2. String built-in çağrılarında $ soneki normalize edilmiyordu.
3. Namespace USING/ALIAS çağrısında ADD kısa adı NS01_ADD routine kaydını bulamıyordu.
4. INCLUDE içeriği INCLUDE_STMT altında çocuk düğüm olarak geldiyse CONST_STMT çalışmıyordu; fonksiyon GEN_ADD çalışıyor ama GEN_HEADER_BASE 0 kalıyordu.
5. Nested INCLUDE aynı CONST'u tekrar getirdiğinde duplicate const runtime'ı kırmamalı; değer yenilenip devam edilmeli.
6. ExecEvalNode numeric yolu CONST tablosunu görmeli; fonksiyon argümanındaki GEN_HEADER_BASE 0 olmamalı.

Kullanım:

```powershell
python copy_over_fix10_full_files.py --root . --dry-run
python copy_over_fix10_full_files.py --root .
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only strings
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only namespace
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only include_import
```

Yedek uzantısı: `.bak_fix10`
