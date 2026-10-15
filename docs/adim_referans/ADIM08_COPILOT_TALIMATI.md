# 08 — ADIM3 PARSER: Uygulama Talimatı

Bu adım plan dosyalarını değiştirmeden uygulanacak. Yeni Python aracı yazma. Mevcut araçlarla ölç, FreeBASIC kodlarını ekle.

## Eklenecek dosyalar

`patch_files/src/parser/parser/*.fbs` içindeki tüm dosyalar aynı yollarla `src/parser/parser/` altına kopyalanacak.

## Değiştirilecek dosyalar

### 1. `src/parser/parser.fbs`

`#include once "parser/parser_shared.fbs"` satırından hemen sonra şunları ekle:

```freebasic
#include once "parser/parser_adim08_error_recovery.fbs"
#include once "parser/parser_adim08_surface_routes.fbs"
#include once "parser/parser_adim08_operator_contract.fbs"
#include once "parser/parser_adim08_call_ffi_api.fbs"
#include once "parser/parser_adim08_json_export.fbs"
#include once "parser/parser_adim08_gate.fbs"
```

### 2. `src/parser/parser/parser_stmt_basic.fbs`

`ParseCallStmt` içinde her `CALL_STMT` döndürülmeden önce `UXBParserNormalizeCallInteropNode` çağrılacak.

İlk branch için:

```freebasic
If UXBParserNormalizeCallInteropNode(ps, canonicalStmtNode, firstTok) = 0 Then Return -1
```

İkinci branch için:

```freebasic
If UXBParserNormalizeCallInteropNode(ps, stmtNode, firstTok) = 0 Then Return -1
```

### 3. `src/parser/parser/parser_stmt_dispatch.fbs`

`ParseProgram` hata bloğunda eski hata ekleme ve recovery çağrıları yerine yeni fonksiyonlar kullanılacak:

```freebasic
UXBParserAppendError ps, errTok, "PARSER_STMT_FAIL", ps.lastError
UXBParserRecoverToNextStatement ps
```

Eski `ParserAppendParseError` ve `ParserRecoverToNextStatement` silinmeyecek; uyumluluk için kalabilir.

## Çalıştırılacak komutlar

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
.\compiler\scripts\run_adim08_parser_gate.ps1
```

## Beklenen çıktı

- `reports/control/current/adim3_gate.json`
- `reports/control/current/adim3_gate.md`
- `reports/control/current/adim3_positive_negative_tests.csv`
- Pozitif testlerde AST JSON üretimi
- Negatif testlerde crash yok, diagnostic var

## Bitme şartı

Adım 08, parser işi olan yüzeyler için en az bir AST node veya açık parser diagnostic ürettiğinde biter. `ADD_AST_CONTRACT` kalanlar 09. adımın konusudur; 08 içinde AST contract dosyaları değiştirilmez.
