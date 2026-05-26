# Keyword Layer Matrix Policy

Bu dokuman keyword/layer matrisi icin mimari karar politikasini tanimlar.

## Amaç

- Lexer/parser yuzeyinin alt katmanlara esitlenmesini olculebilir hale getirmek.
- Legacy durumlar (`partial`, `missing`, `diagnostic_only`) ile gizli kalmis bosluklari karar statulerine cevirmek.
- JS/WASM/browser hedeflerini matriste gorunur ve gate-edilebilir yapmak.

## Canonical Karar Statuleri

Her keyword x katman hucrasi bu listeden bir statuye sahip olmalidir:

- `IMPLEMENTED`
- `COMPILE_TIME_ONLY`
- `RUNTIME_CALL`
- `NATIVE_ONLY`
- `JS_ONLY`
- `WASM_UNSUPPORTED`
- `DIAGNOSTIC_ONLY`
- `REMOVED_OR_RESERVED`

## Uretim Modeli

`uxb/tools/uxb_keyword_layer_matrix.py` iki tur status uretir:

- Gozlemsel status: kod taramasindan gelen legacy tespit (`implemented/partial/...`).
- Karar status: canonical karar statusu (`decision_*` kolonlari).

CSV cikti formati:

- Mevcut katman kolonlari legacy gozlemsel statuyu korur.
- Ek `decision_<layer>` kolonlari canonical statusu tasir.

## Gate

`uxb/tools/uxb_keyword_layer_decision_gate.py` su kosullari denetler:

- `decision_*` kolonlari mevcut olmali.
- Tum karar hucreleri canonical status listesinde olmali.
- JS/WASM/browser karar kolonlari mevcut olmali.

`uxb/compiler/scripts/run_keyword_layer_matrix.bat` matrix uretiminden sonra gate calistirir.
