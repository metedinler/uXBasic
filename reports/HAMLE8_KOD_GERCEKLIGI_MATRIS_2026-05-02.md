# uXBasic Hamle 8 Kod Gercekligi Matris Raporu (2026-05-02)

## 1) Kapsam ve Yontem

Bu rapor, `COMPILER_COVERAGE.md` planini kod-gercekligi ile caprazlayarak cikarildi. Kaynak olarak parser, semantic, AST runtime, MIR runtime ve x64 codegen dosyalari dogrudan okundu.

Durum etiketleri:

- `OK`: katman gercek implementasyona sahip
- `PARTIAL`: calisiyor ama tip/genislik/parity kisitli
- `NOOP`: bilerek no-op uygulanmis
- `MISSING`: katmanda dogrudan lane yok
- `DOC-DRIFT`: dokuman iddiasi ile kod gercekligi ayrisiyor

## 2) Kisa Kod Gercekligi Ozeti

1. Parser yuzeyi genis; statement registry aktif (`src/parser/parser/parser_stmt_registry.fbs`:103,146,170-174).
2. CLASS/METHOD zinciri AST+MIR+x64 tarafinda gercek yurutmeye bagli; MIR user call + vtable slot dispatch var (`src/semantic/mir_evaluator.fbs`:2037,2081,2089), x64 vtable dolayli call var (`src/codegen/x64/code_generator.fbs`:7146).
3. EVENT/THREAD/PARALEL/PIPE/SLOT satirlari MIR ve x64 tarafinda halen calistirma yerine no-op (`src/semantic/mir.fbs`:2038, `src/codegen/x64/code_generator.fbs`:5534).
4. `VARPTR/OFFSETOF/PEEKB/W/D` MIR ve x64 tarafinda var (`src/semantic/mir.fbs`:1091, `src/semantic/mir_evaluator.fbs`:1939, `src/codegen/x64/code_generator.fbs`:6840,6871,6910).
5. Native `INPUT` lane var ama i32 odakli (`src/codegen/x64/code_generator.fbs`:5343,1930,1933; `src/semantic/mir_evaluator.fbs`:1506).
6. LIST/DICT/SET AST runtime'da var, MIR/x64 lane yok (AST builtin listesi `src/runtime/memory_exec.fbs`:1530; MIR/x64 dosyalarinda `LISTLEN` case bulunmuyor).
7. Pipe operator kodda `|>` olarak uygulanmis (`src/parser/parser/parser_expr.fbs`:557,566). Coverage'daki `expr | fn` ifadesi artik `DOC-DRIFT`.
8. Lexer hala `threat`/`parallel` keywordlerini tanimliyor (`src/parser/lexer/lexer_keyword_table.fbs`:18) fakat dispatch canonical `THREAD/PARALEL` uzerinden.

## 3) Komut Matrisi (Statement Surface)

| Grup | Komutlar | Lexer/Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Not |
|---|---|---|---|---|---|---|---|
| Akis cekirdegi | `IF/ELSE/SELECT/FOR/DO/NEXT/GOTO/GOSUB/RETURN/EXIT/TRY/THROW/ASSERT` | OK | OK | OK | OK | PARTIAL | x64 tarafinda genel fallback/TODO noktalar devam ediyor (`code_generator.fbs`:4948,4980,5199) |
| Tanim cekirdegi | `CONST/DIM/REDIM/TYPE` | OK | OK | OK | OK | PARTIAL | array/type parity icin x64 genisletme ihtiyaci suruyor |
| OOP komutlari | `CLASS/INTERFACE/NEW/DELETE/METHOD/CONSTRUCTOR/DESTRUCTOR` | OK | OK | OK | OK | PARTIAL | core lane aktif; inheritance/interface dispatch parity eksikleri var |
| Scope/organizasyon | `NAMESPACE/MODULE/MAIN/USING/ALIAS` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | runtime'da bazi dugumler metadata/no-op (`memory_exec.fbs`:2058) |
| Prosedur/fonksiyon | `DECLARE/SUB/FUNCTION/CALL` | OK | PARTIAL | OK | OK | PARTIAL | signature/type parity tam degil |
| DEF/compat | `DEFINT/.../SETSTRINGSIZE` | OK | PARTIAL | OK | OK | PARTIAL | metadata agirliki suruyor |
| Konsol I/O | `PRINT/INPUT` | OK | OK | OK | PARTIAL | PARTIAL | INPUT lane i32 agirlikli (`mir_evaluator.fbs`:1506, `code_generator.fbs`:1930) |
| Dosya I/O | `OPEN/CLOSE/GET/PUT/SEEK/INPUT#` | OK | OK | OK | OK | PARTIAL | temel lane var; format ve tip varyantlari sinirli |
| Bellek | `POKE*/PEEK*/POKES/MEMCOPY*/MEMFILL*/SETNEWOFFSET/INC/DEC` | OK | PARTIAL | OK | OK | OK | statement emit lane dogrudan mevcut |
| Slot lane | `EVENT/THREAD/PARALEL/PIPE/SLOT/ON/OFF/TRIGGER` | OK | PARTIAL | PARTIAL | NOOP | NOOP | semantic guard + AST MVP; MIR/x64 no-op (`mir.fbs`:2038, `code_generator.fbs`:5534) |
| Interop | `IMPORT/INLINE` | OK | PARTIAL | N/A | N/A | PARTIAL | INLINE ana emit path'e tam dokulu degil |
| FFI | `CALL(DLL,...)`, `CALL(API,...)` | OK | PARTIAL | OK | PARTIAL | PARTIAL | AST tarafinda API->DLL core var (`exec_eval_builtin_categories.fbs`:242), MIR/x64 API lane yok |

## 4) Fonksiyon Matrisi (Builtin ve Cagri Yuzeyi)

| Fonksiyon Grubu | Ornekler | Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Not |
|---|---|---|---|---|---|---|---|
| Sayisal scalar | `ABS/INT/FIX/SGN/VAL/CINT/CLNG/CDBL/CSNG` | OK | PARTIAL | OK | OK | PARTIAL | float/compound/parity bosluklari var |
| Matematik | `SQR/SIN/COS/TAN/ATN/EXP/LOG` | OK | PARTIAL | OK | OK | PARTIAL | x64 float lane kisitli; unsupported float op noktasi var (`code_generator.fbs`:608) |
| String | `LEN/STR/MID/UCASE/LCASE/LTRIM/RTRIM/SPACE/STRING/CHR` | OK | PARTIAL | OK | OK | PARTIAL | native parity tamam degil |
| Zaman/rastgele/tus | `TIMER/RND/INKEY/GETKEY` | OK | PARTIAL | OK | OK | PARTIAL | varyant paritesi acik |
| Dosya bilgi | `LOF/EOF` | OK | PARTIAL | OK | MISSING | PARTIAL | MIR evaluator'da `LOF/EOF` case yok |
| Layout/pointer | `SIZEOF/OFFSETOF/VARPTR/SADD/LPTR/CODEPTR/PEEKB/W/D` | OK | PARTIAL | OK | PARTIAL | PARTIAL | MIR/x64'te `VARPTR/OFFSETOF/PEEK*` var; `SADD/LPTR/CODEPTR` parity eksik |
| Koleksiyon builtins | `LISTLEN/.../DICTLEN/.../SETLEN/...` | OK | PARTIAL | OK | MISSING | MISSING | AST lane var (`memory_exec.fbs`:1530), MIR/x64 case yok |
| FFI | `CALL(DLL...)` | OK | PARTIAL | OK | PARTIAL | PARTIAL | DLL lane var; mixed arg ileri varyantlar kisitli |
| API | `CALL(API...)` | OK | PARTIAL | OK | MISSING | MISSING | AST'de var (`exec_eval_builtin_categories.fbs`:242), MIR/x64 yok |

## 5) Operator Matrisi

| Operator Grubu | Operatorler | Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Not |
|---|---|---|---|---|---|---|---|
| Aritmetik | `+ - * / \ MOD` | OK | OK | OK | OK | PARTIAL | x64 float parity eksikleri |
| Karsilastirma | `= <> < > <= >= == !=` | OK | OK | OK | OK | OK | temel lane mevcut |
| Mantiksal | `AND OR NOT && || !` | OK | OK | OK | OK | OK | short-circuit var |
| Bitwise | `& \| XOR ^ SHL SHR ROL ROR ~` | OK | PARTIAL | OK | OK | OK | semantic const-fold tarafinda kisimli |
| Bilesik atama | `+= -= *= /= \=` | OK | PARTIAL | OK | OK | PARTIAL | x64 float compound unsupported (`code_generator.fbs`:7484) |
| Inc/Dec | `++ --` (prefix/postfix, stmt/expr) | OK | PARTIAL | OK | OK | PARTIAL | x64 indexed lane DIM odakli |
| Ternary | `?:` | OK | PARTIAL | OK | OK | OK | tip birlestirme kurallari dar |
| Pipe | `|>` | OK | PARTIAL | OK | OK | OK | kodda pipe operator `|>`; `|` bitwise olarak ayri (`parser_expr.fbs`:474,557) |

## 6) Degisken/Depolama Matrisi

| Baslik | Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Not |
|---|---|---|---|---|---|---|
| Scalar `DIM/CONST` | OK | OK | OK | OK | OK | temel lane stabil |
| Array `DIM/REDIM` + indexed load/store | OK | PARTIAL | OK | OK | PARTIAL | x64'te kapsamli parity henuz acik |
| TYPE/CLASS field path | OK | OK | OK | OK | PARTIAL | nested/array field lane var, edge parity acik |
| `NEW/DELETE` yasam dongusu | OK | OK | OK | OK | PARTIAL | x64 lane var ama parity tam degil |
| `THIS/ME` binding | OK | OK | OK | OK | OK | semantic/runtime/codegen receiver bagli |
| Default type directives (`DEF*`) | OK | PARTIAL | OK | OK | PARTIAL | metadata agirlikli |
| Alias/scope metadata | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | runtime no-op agirlikli alanlar var |

## 7) Veri Tipi ve Veri Yapisi Matrisi

| Tip/Yapi | Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Not |
|---|---|---|---|---|---|---|
| `I8..U64` | OK | OK | OK | OK | OK | integer lane temel olarak var |
| `F32/F64` | OK | OK | PARTIAL | PARTIAL | PARTIAL | backend parity dar |
| `F80` | OK | OK | PARTIAL | MISSING | MISSING | MIR explicit desteklemiyor (`mir.fbs`:1048 civari F80 check), x64 float unsupported noktalari var (`code_generator.fbs`:608) |
| `BOOLEAN` | OK | OK | OK | OK | PARTIAL | temsil/parity detaylari acik |
| `STRING` | OK | OK | OK | PARTIAL | PARTIAL | print/input/string parity acik |
| `OBJECT/CLASS/INTERFACE` referans | OK | OK | OK | OK | PARTIAL | interface runtime dispatch sinirli |
| `ARRAY` | OK | OK | OK | OK | PARTIAL | native edge-case parity acik |
| `LIST/DICT/SET` | OK | PARTIAL | OK | MISSING | MISSING | AST koleksiyon motoru var, MIR/x64 lane yok |
| `PTR/STRPTR` pointer yuzeyi | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | kismi intrinsic lane |

Not: `exec_types.fbs` icindeki "Array and object support removed for simplicity" yorumu (`src/runtime/exec/exec_types.fbs`:6), ayni dosyadaki `ExecArray/ExecObject/ExecCollection` tipleriyle (`:24,:31,:38`) uyumsuz; bu bir `DOC-DRIFT`.

## 8) OOP Sistemi Detay Matrisi

| OOP Parca | Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Durum |
|---|---|---|---|---|---|---|
| CLASS/INTERFACE declaration | OK | OK | OK | OK | OK | temel declaration lane var |
| `EXTENDS` / `IMPLEMENTS` | OK | OK | PARTIAL | PARTIAL | PARTIAL | compile-time contract var, runtime parity dar |
| `VIRTUAL` / `OVERRIDE` contract | OK | OK | PARTIAL | PARTIAL | PARTIAL | semantic dogrulama aktif (`semantic_pass.fbs`:815-831) |
| Method call receiver route | OK | OK | OK | OK | OK | MIR route + x64 receiver lane aktif |
| `THIS/ME` | OK | OK | OK | OK | OK | AST+MIR+x64 receiver bagli |
| `NEW -> CTOR` | OK | OK | OK | OK | OK | MIR `MIR_OP_NEW` ctor invoke (`mir_evaluator.fbs`:482+), x64 ctor call lane (`code_generator.fbs`:4464+) |
| `DELETE -> DTOR` | OK | OK | OK | OK | OK | MIR delete lowering (`mir.fbs`:2171+), x64 delete emit (`code_generator.fbs`:5988+) |
| VTable slot map | PARTIAL | OK | PARTIAL | OK | OK | MIR vtable map build (`mir.fbs`:3160+), x64 indirect slot call (`code_generator.fbs`:7146) |
| Interface typed dynamic dispatch | OK | PARTIAL | PARTIAL | PARTIAL | MISSING/PARTIAL | x64 class-instance zorunlulugu var (`code_generator.fbs`:6967) |

## 9) Hamle 8 Sonrasi Net Aciklar

1. EVENT/THREAD/PARALEL/PIPE/SLOT satirlari icin MIR/x64 no-op yerine gercek runtime lane.
2. LIST/DICT/SET builtins icin MIR evaluator + x64 builtin/runtime lane.
3. `CALL(API,...)` icin MIR ve x64 lane.
4. `INPUT` icin integer-disi tip paritesi (string/float dahil).
5. Interface typed dispatch parity (MIR+x64).
6. x64 TODO/unsupported noktalari kapatma (`unsupported binary op`, `expression kind`, `unsupported statement`).
7. Lexer alias kalintilarini temizleme (`threat/parallel`) veya bilincli compat modu olarak belgeye acik etiketleme.

---

Bu rapor, Hamle-8 durumunu dokuman iddiasindan degil, kod satiri gercekliginden cikarmak icin hazirlandi. Sonraki guncellemede ayni tablo test runner ciktilariyla birlikte otomatik uretilebilir.
