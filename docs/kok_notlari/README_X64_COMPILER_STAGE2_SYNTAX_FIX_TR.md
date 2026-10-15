# UXB x64 Compiler Stage-2 Syntax Fix (2026-07-05)

Bu yama yalnız `fbc64.exe` derlemesini kıran üç FreeBASIC sözdizimi sorununu düzeltir. Yeni özellik eklemez, DLL build zincirine dokunmaz, x86 üretimini geri açmaz.

## Düzeltilen dosyalar

- `src/runtime/exec/exec_stmt_io_file.fbs`
- `src/interpreter/mir/mir_interp.fbs`
- `src/codegen/x64/ffi_call_backend.fbs`

## Düzeltmeler

1. `exec_stmt_io_file.fbs`
   - `SaveTextFile(...)` bu derleme biriminde görünmediği için native SHELL `OUTPATH/ERRPATH` yazımı kırılıyordu.
   - Yerel `ExecShellSaveTextFile(...)` yardımcısı eklendi.
   - Native SHELL çıkış yazımı bu yardımcıya bağlandı.

2. `mir_interp.fbs`
   - `On Error Resume Next` FreeBASIC `-lang fb` derlemesinde kabul edilmedi.
   - Hata bloğu `On Error GoTo 0` ile kapatılıp güvenli dönüşe indirildi.

3. `ffi_call_backend.fbs`
   - `pos` adı FreeBASIC tarafında çakışma/yerleşik isim sorunu üretiyordu.
   - Yerel değişken `scanPos` olarak yeniden adlandırıldı.

## Uygulama

Bu ZIP doğrudan `uxb` köküne açılmalıdır:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
Expand-Archive -LiteralPath .\UXB_X64_COMPILER_STAGE2_SYNTAX_FIX_20260705_DIRECT_ROOT.zip -DestinationPath . -Force
```

## Test

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\build_uxb_main_64.ps1 `
  -Root . `
  -Force `
  -SkipX86
```

Hata varsa:

```powershell
Get-Content .\reports\libraries\logs\compiler_x64_fbc.log -Tail 100
```
