# ADIM17 / ADIM12 — CLI 3 Harf Komut Zinciri

Plan belgesi: `README/17_ADIM12_CLI_3_HARF_KOMUT_ZINCIRI.md`.

## Amaç

Eski CLI seçeneklerini koruyarak, derleyiciye tek geçişli profesyonel CLI katmanı eklemek:

- `@options.uxcli` response file desteği,
- 3 harfli verb zinciri,
- eski CLI flaglerine alias mapping,
- `--json-out`, `--stop-after`, `--target`, `--emit-*`, `--dump-*`, `--diag-format`, `--error-limit`, `--strict`, `--time-passes`,
- CLI route matrix,
- CLI JSON raporu.

## Değişmeyen kural

Yeni Python aracı yazma. Ana dosyaları komple ezme. `HasArg` ve `GetArgValue` silinmeyecek; yeni CLI onların önüne uyumluluk katmanı olarak bağlanacak. Derleme hatası çıkarsa tamirata girme; sadece raporla.

## Yeni dosyalar

```text
src/cli/cli_args.fbs
src/cli/cli_response_file.fbs
src/cli/cli_verb_dispatch.fbs
src/cli/cli_help.fbs
src/cli/cli_json_report.fbs
src/cli/cli_route_matrix.fbs
src/cli/cli_main_bridge.fbs
compiler/scripts/run_adim17_cli_gate.ps1
```

## `src/main.bas` merge

`main_program_entry.fbs` include edilmeden önce şunu ekle:

```freebasic
#include once "cli/cli_args.fbs"
#include once "cli/cli_response_file.fbs"
#include once "cli/cli_verb_dispatch.fbs"
#include once "cli/cli_help.fbs"
#include once "cli/cli_json_report.fbs"
#include once "cli/cli_route_matrix.fbs"
#include once "cli/cli_main_bridge.fbs"
```

`HasArg` fonksiyonunun en başına:

```freebasic
    If UXBCliBridgeReady() <> 0 Then
        If UXBCliCompatHasArg(keyText) <> 0 Then Return 1
    End If
```

`GetArgValue` fonksiyonunun en başına:

```freebasic
    If UXBCliBridgeReady() <> 0 Then
        If UXBCliCompatGetArgValue(keyText, valueOut) <> 0 Then Return 1
    End If
```

## `src/main_program_entry.fbs` merge

`UxbInit` satırından hemen sonra:

```freebasic
Dim As String cliErrText
If UXBCliInitFromCommandLine(cliErrText) = 0 Then
    UxbError cliErrText
    End 20
End If

If UXBCliIsHelpRequested() <> 0 Then
    UXBCliPrintHelp
    End 0
End If

If UXBCliIsVersionRequested() <> 0 Then
    UXBCliPrintVersion
    End 0
End If

If UXBCliWriteStartupReports(cliErrText) = 0 Then
    UxbError cliErrText
    End 20
End If
```

## 3 harfli verbler

```text
lex par ast sem hir mir int x64 x86 jsw wat bld run chk fmt map doc rel hlp ver
```

## Derleme/gate

```powershell
compiler/scripts/run_adim17_cli_gate.ps1 -NoRepair
```

`reports/control/current/adim12_gate.json` PASS olmadan başarı deme.
