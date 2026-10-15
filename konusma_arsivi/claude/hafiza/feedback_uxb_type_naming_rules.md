---
name: uxb-type-naming-rules
description: "uXBasic has NO LONG/INTEGER/DOUBLE type names and NO $ # % ! type suffixes; types are I8..U64/F32..F128; explicit conversion is I8(x)/U8(x)/I32(x)/F32(x)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-09-28T20:26:40.694Z
---

Mete 2026-09-28 (correcting me): "uxbasic de long integer double gibi adları kullanmıyoruz, veri tiplerinde $,#,% gibi son
ekler kullanmıyoruz. I8 8 bit integer, U8 8 bit işaretsiz, F32 32 bit floating point…" and "cast yok diyorsun, halbuki cast
fonksiyonlarını sen yazdın; daha önce de i8 tipi I8() ile I8'e çevirme şeklindeydi. Ayrıca normal BASIC tarzı komutlar da var."

- Type names: I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 F128 BIGF BIGD BALL BOOLEAN STRING PTR … (lexer_keyword_table.fbs).
- `LEFT$`, `CHR$`, `STR$`… are NOT uXBasic; the lexer rejecting them is correct. Names like LEFT$/LONG/INTEGER in
  surface/runtime tables are dead branches to clean up (S-177), not features to add.
- Explicit conversion = type-name function: `I8(1)`, `U8(200)`, `I16(-300)`, `U16(60000)`, `F32(1.5)` — verified on AST, MIR,
  native x64. Classic BASIC conversions (CINT CLNG CDBL CSNG FIX INT) also exist; canonical-vs-alias is decided in the
  language spec ([[uxb-dil-tanimi-20260928]]).
- I wrongly wrote "dilde dönüşüm yok" in S-176 before probing `I8(x)`; corrected the same night.

**Why:** Mete designed the type system deliberately; ChatGPT-era books and dead table entries mislead.
**How to apply:** never write LONG/INTEGER/DOUBLE/SINGLE/$-suffixed names in uXBasic examples or docs; before claiming a
feature is missing, probe the type-name/function form and grep tests/xtestx for prior usage.
