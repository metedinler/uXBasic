# uXBasic Release Pipeline 45 - Python Runner Toolkit

Bu paket PowerShell değil Python kullanır. `uxb` proje kökünden çalışır ve 45 modüler test kaynağı için üç ayrı ürün hattı çıkarır:

1. `01_json_log`: tokens/preprocess/AST/semantic/MIR/interpreter stdout/json/log
2. `02_x64`: x64 NASM/ASM/build klasörü/exe denemesi
3. `03_web`: WAT/WASM/JS/HTML/browser artifact klasörü

## Kurulum

Zip içeriğini `uxb` klasörüne açın. Sonra:

```powershell
cd C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb
python install_uxb_release_pipeline_45.py --root . --tests xtestx --clean --dry-run
python install_uxb_release_pipeline_45.py --root . --tests xtestx --clean
```

## Çalıştırma

```powershell
python xtestx\_runners\run_uxb_release_triple_pipeline.py --root . --tests xtestx --uxb .\bin\uxb.exe --lanes all
```

Sadece JSON/log hattı:

```powershell
python xtestx\_runners\run_uxb_release_triple_pipeline.py --root . --tests xtestx --uxb .\bin\uxb.exe --lanes json_log
```

Sadece bir test:

```powershell
python xtestx\_runners\run_uxb_release_triple_pipeline.py --root . --tests xtestx --uxb .\bin\uxb.exe --only tp_01
```

İlk HTML çıktısını açmak:

```powershell
python xtestx\_runners\run_uxb_release_triple_pipeline.py --root . --tests xtestx --uxb .\bin\uxb.exe --open-first-browser
```

## Çıktı yapısı

```text
reports\xtestx_release_pipeline_45\<timestamp>\<test_id>\
  01_json_log\
    tokens.json
    lexer_diagnostics.json
    preprocessed.uxb
    ast.json
    parser_diagnostics.json
    semantic_diagnostics.json
    symbols.json
    types.json
    mir.json
    program_stdout.txt
    program_output.json
    run_report.json
    stdout_raw.txt
    stderr_raw.txt
  02_x64\
    program.asm
    x64_build\
    x64_backend_report.json
    command.txt
    stdout_raw.txt
    stderr_raw.txt
  03_web\
    browser\program.js
    browser\program.wat
    browser\program.wasm
    browser\index.html
    browser\manifest.json
    web_backend_report.json
```

## Kanonik kararlar

Pozitif testlerde şu eski BASIC kalıpları yoktur:

```text
$ suffix yok
% suffix yok
! suffix yok
& suffix yok
PARALLEL yok; PARALEL var
THREAT yok; THREAD var
SIHIRLIMETOT yok; MAGIC var
MAGIC <.x.> yok; MAGIC HASH(...) var
```

`#` yalnız dosya kanalı bağlamında kullanılır: `PRINT #1`, `INPUT #1`.
# UxBasic_Full
