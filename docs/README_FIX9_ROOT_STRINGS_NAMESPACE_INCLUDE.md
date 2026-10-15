# uXBasic FIX-9 Root Patch

## Yontem

**Otomatik patch. Kopyala-ez degildir.**

Bu paket kaynak dosyalari komple degistirmez; hedeflenen FreeBasic bolumlerini arayip yamalar.
Yedek uzantisi: `.bak_fix9`

## Hedeflenen kok sorunlar

1. STRING hedef degiskene `UCASE/LEFT/MID/RIGHT/STR/CHR` gibi metin donduren CALL_EXPR atandiginda numeric yola dusup `0` olmasi.
2. `NAMESPACE ... FUNCTION ... END NAMESPACE`, `USING`, `ALIAS` sonrasi routine map'in direct child disindaki fonksiyonlari kacirmasi.
3. `INCLUDE "xtestx/.../common_math.uxbh"` gibi root-relative include yollarinin kaynak dosya alt klasorunden bulunamamasi.
4. Include edilmis `CONST` adlarinin semantic/type infer asamasinda farkli AST alanlarina dusmesi halinde `unknown symbol` uretmesi.

## Uygulama

Proje kokunde:

```powershell
python apply_uxb_fix9_root_strings_namespace_include.py --root . --dry-run --patch-runner
python apply_uxb_fix9_root_strings_namespace_include.py --root . --patch-runner
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

## Odak testler

```powershell
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only strings
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only namespace
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only include_import
```

## Not

`--patch-runner` opsiyoneldir. Runner kalibini bulamazsa kaynak yamalarini etkilemez; testleri yine `--uxb .\bin\uxb.exe` ile calistirabilirsiniz.
