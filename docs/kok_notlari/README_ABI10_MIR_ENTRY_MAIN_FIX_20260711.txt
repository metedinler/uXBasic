# UXB ABI10 MIR entry/source-gate/build64 fix — 20260711

Bu paket önceki ABI10 yamalarının üstüne uygulanır.

Düzeltilenler:

1. `src/interpreter/mir/mir_interp.fbs`
   - Canonical MIR artık düz bir instruction listesi olduğu için helper `FUNCTION/SUB`
     gövdeleri `MAIN` öncesinde bulunabiliyor.
   - Eski akış instruction 0'dan başlayıp ilk helper routine içinde `RETURN` görünce
     programı başarıyla bitiriyordu; bu yüzden MIR exit=0 olmasına rağmen
     `PRINT "PASS_ABI10"` hiç çalışmıyordu.
   - Yeni akış `MAIN` / `__MAIN` / `_MAIN` / `PROGRAM_MAIN` label'ını bulur,
     yürütmeyi entry label sonrasından başlatır ve sonraki `MIR_FUNCTION_LABEL`
     noktasında top-level akışı durdurur.

2. `tools/library_tools/uxb_library_source_gate.py`
   `tool_py/tools/library_tools/uxb_library_source_gate.py`
   - Önceki yama doğru olarak `UXB_MIRFFI_MAX_ARGS As Long = 10` yaptı.
   - Source gate hâlâ eski `As Integer` anchor'ını aradığı için tek FAIL veriyordu.
   - Anchor `As Long` gerçekliğine güncellendi.

3. `build_64.bat`
   - `%~dp0` trailing backslash ile quote sınırında PowerShell'e bozuk `-Root`
     gönderebiliyor ve `Resolve-Path : Yolda geçersiz karakterler var` hatası üretiyordu.
   - Root `%~dp0.` üzerinden normalize edilir.

Beklenen yeni durum:
- ABI10 MIR artık exit=0 + `PASS_ABI10` üretmeli.
- Smoke script MIR'den sonra `x64_ast_build` aşamasına geçmeli.
- Source gate eski `UXB_MIRFFI_MAX_ARGS As Integer = 10` anchor hatasını vermemeli.
- `.\build_64.bat` doğrudan çalışmalı.

