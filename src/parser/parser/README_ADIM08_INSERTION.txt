Adim08 dosyalari src/parser/parser/ klasorune eklenecek.

src/parser/parser.fbs icinde parser_shared include satirindan hemen sonra su include'lari ekle:

#include once "parser/parser_adim08_error_recovery.fbs"
#include once "parser/parser_adim08_surface_routes.fbs"
#include once "parser/parser_adim08_operator_contract.fbs"
#include once "parser/parser_adim08_call_ffi_api.fbs"
#include once "parser/parser_adim08_json_export.fbs"
#include once "parser/parser_adim08_gate.fbs"

src/parser/parser/parser_stmt_basic.fbs icindeki ParseCallStmt fonksiyonunda her CALL_STMT return edilmeden once:

If UXBParserNormalizeCallInteropNode(ps, canonicalStmtNode, firstTok) = 0 Then Return -1

ve ikinci branch icin:

If UXBParserNormalizeCallInteropNode(ps, stmtNode, firstTok) = 0 Then Return -1

satirlari eklenecek.

src/parser/parser/parser_stmt_dispatch.fbs icindeki ParseProgram hata blokunda:
ParserAppendParseError + ParserRecoverToNextStatement yerine UXBParserAppendError + UXBParserRecoverToNextStatement kullanilacak.
Mevcut private fonksiyonlar silinmeyecek; uyumluluk icin kalabilir.
