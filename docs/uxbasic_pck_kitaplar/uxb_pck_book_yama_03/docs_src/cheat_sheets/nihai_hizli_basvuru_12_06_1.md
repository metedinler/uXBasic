# Nihai Hızlı Başvuru — 12.06_1

## Komut aileleri

| Aile | Sözcükler |
|---|---|
| Giriş/çıkış | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `PRINT #`, `INPUT #` |
| Değişken | `DIM`, `AS`, `CONST`, `LET`, `REDIM` |
| Karar | `IF`, `THEN`, `ELSEIF`, `ELSE`, `END IF`, `SELECT`, `CASE`, `CASE ELSE` |
| Döngü | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `UNTIL`, `WEND`, `EXIT` |
| Fonksiyon | `FUNCTION`, `SUB`, `RETURN`, `DECLARE`, `CALL`, `BYVAL`, `BYREF` |
| Tip/nesne | `TYPE`, `CLASS`, `INTERFACE`, `MAGIC`, `NEW`, `DELETE`, `THIS`, `ME` |
| Modül | `NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `INCLUDE`, `IMPORT` |
| Dış çağrı | `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)`, `CDECL`, `STDCALL` |
| Eşzamanlı yüzey | `EVENT`, `THREAD`, `PIPE`, `PARALEL`, `SLOT` |
| Hata | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` |

## Veri tipleri

| Aile | Tipler |
|---|---|
| İşaretli tam sayı | `I8`, `I16`, `I32`, `I64` |
| İşaretsiz tam sayı | `U8`, `U16`, `U32`, `U64` |
| Kayan nokta | `F32`, `F64`, `F80`, `F128` |
| Büyük sayı | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` |
| Genel | `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `STRPTR` |
| Koleksiyon | `ARRAY`, `LIST`, `DICT`, `SET` |

## Operatör aileleri

| Aile | Operatörler |
|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` |
| Mantık | `AND`, `OR`, `NOT`, `XOR` |
| Logic16 | `NAND`, `NOR`, `XNOR`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| Bit kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `**=` |
| Akış | `|>`, `?:` |

## Preprocessor aileleri

| Aile | Yönergeler |
|---|---|
| Değer | `%%SET`, `%%DEFINE`, `%%UNDEF`, `%%EVAL` |
| Koşul | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` |
| Döngü | `%%FOR`, `%%FOREACH`, `%%REPEAT`, `%%ENDFOR`, `%%BREAK`, `%%CONTINUE` |
| Hedef | `%%TARGET`, `%%PLATFORM`, `%%DESTOS`, `%%PROFILE`, `%%OUTDIR` |
| Web | `%%HTML_BEGIN`, `%%HTML_END`, `%%CSS_BEGIN`, `%%CSS_END`, `%%JS_BEGIN`, `%%JS_END`, `%%JS_LINE` |
| WAT/WASM | `%%WAT_BEGIN`, `%%WAT_END`, `%%WAT_FUNC_BEGIN`, `%%WAT_FUNC_END`, `%%WAT_IMPORT`, `%%WAT_EXPORT` |
| Asset | `%%ASSET_ROOT`, `%%ASSET_FILE`, `%%ASSET_COPY`, `%%ASSET_IMAGE`, `%%ASSET_AUDIO` |
| Manifest/JSON | `%%MANIFEST_SET`, `%%MANIFEST_REQUIRE`, `%%JSON_SET`, `%%JSON_BEGIN`, `%%JSON_END` |
| Güvenlik | `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SAFE_PATHS`, `%%REQUIRE_HOST_BINDING` |

## Compiler katman komutları

| Katman | Terminal komutu çekirdeği |
|---|---|
| Preprocess | `--pp A --preprocessed-out out.uxb --preprocess-result-json-out out.json` |
| Lexer | `--debug-token-dump --tokens-json-out tokens.json` |
| Parser/AST | `--parse-only --ast-json-out ast.json` |
| AST contract | `--ast-contract-check --ast-contract-json-out ast_contract.json` |
| Semantic/HIR | `--semantic --hir-json-out hir.json` |
| MIR | `--mir-verify --mir-json-out mir.json --mir-opcodes-json-out mir_opcodes.json` |
| AST run | `--execmem --interpreter-backend AST` |
| MIR run | `--execmem --interpreter-backend MIR` |
| JS | `--emit-js --js-out program.js` |
| WAT | `--emit-wat --wat-out program.wat` |
| WASM | `--emit-wasm --wasm-out program.wasm` |
| x64 | `--codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out program.asm` |

## Kanonik yanlış/doğru tablosu

| Yanlış | Doğru |
|---|---|
| `THREAT` | `THREAD` |
| `PARALLEL` | `PARALEL` |
| `SIHIRLIMETOT` | `MAGIC` |
| `IMPORT DLL` | `CALL(DLL)` veya `DECLARE ... LIB ... ALIAS ...` |
| `IMPORT API` | `CALL(API)` |
| Hedefsiz raw JS | `%%TARGET WEB` veya uygun güvenlik kapısı altında JS üretimi |
