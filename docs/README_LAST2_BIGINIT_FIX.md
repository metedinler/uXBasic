# uXBasic last 2 project pack fix: BIGINIT AST text contract

Kalan iki hata ayni kokten geliyor:

- `pack_16_big_extfp_canonical`: `PRINT BIGINIT(...)` beklenen literal degeri yerine `0` basiyor.
- `pack_30_full_integration_project`: 6. satirda `PRINT BIGINIT(BIGI, "12345")` beklenen `12345` yerine `0` basiyor.

Degisen dosya:

```text
src/runtime/exec/exec_eval_text_helpers.fbs
```

Yama, `ExecTryEvalCallExprAsText` icine `BIGINIT` metin sozlesmesi ekler:

```basic
BIGINIT(kind, "literal"[, precision])  =>  "literal"
```

Bu, gercek BIGF/BIGD/BALL harici runtime aritmetigini bitirmez; sadece AST execmem smoke/integration sozlesmesinde `0` handle basma hatasini kaldirir.

## Uygulama

PowerShell'de uxb kokunden:

```powershell
Expand-Archive .\uxb_last2_biginit_fix.zip -DestinationPath .\_fix_last2_biginit -Force
.\_fix_last2_biginit\UYGULA_LAST2_BIGINIT_FIX.ps1 -Root .
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_16_big_extfp_canonical
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_30_full_integration_project
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```
