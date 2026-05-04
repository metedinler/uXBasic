# uXBasic src7 Compiler Feature Matrix

Bu belge `tools/feature_matrix.py` ile `src7` kaynak agacindan statik olarak uretilir. `Var`, kaynak kodunda o katmana ait dogrudan destek izi bulundugu anlamina gelir; davranissal dogrulama icin ayrica test kosmak gerekir.

| Özellik | Lexer | Parser | AST | Semantic | AST Exec | MIR | MIR Exec | x64 | Durum | Not |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| PRINT | Var | Var | Var | Var | Var | Var | Var | Var | Tam iz var | Temel cikti destegi var; string ayrintilari x64/runtime tarafinda ayrica test edilmeli. |
| INPUT | Var | Var | Var | Var | Var | Yok | Yok | Var | Kısmi | Konsol/file input parser/runtime izleri var; MIR destegi gorunmuyor. |
| DIM | Var | Var | Var | Var | Var | Var | Var | Var | Tam iz var | Degisken bildirimi tum ana katmanlarda iz birakiyor; object/array detaylari ayri. |
| CONST | Var | Var | Var | Var | Var | Var | Var | Yok | Kısmi | Parser/semantic/MIR izleri var; x64 statement case'i belirgin degil. |
| ASSIGN | OP | Var | Var | Var | Var | Var | Var | Var | Tam iz var | Atama temel katmanlarda var; field/index hedefleri kismi. |
| IF | Var | Var | Var | Var | Var | Var | Var | Var | Tam iz var | Kosul akisi tum ana katmanlarda mevcut. |
| SELECT CASE | Var | Var | Var | Var | Var | Var | Yok | Var | Kısmi | Parser/MIR/x64 izi var; MIR evaluator tarafinda ozel select izi zayif. |
| FOR | Var | Var | Var | Var | Var | Var | Yok | Var | Kısmi | Klasik FOR tum buyuk katmanlarda izli. |
| FOR EACH | Var | Var | Var | Var | Var | Var | Yok | Var | Kısmi | Yuzey var; koleksiyon baglama kismi kabul edilmeli. |
| DO/LOOP | Var | Var | Var | Var | Var | Var | Yok | Var | Kısmi | Dongu katmanlarda var. |
| GOTO | Var | Var | Var | Yok | Var | Yok | Yok | Var | Kısmi | AST/x64 izi var; MIR lowering izinde yok. |
| GOSUB/RETURN | Var | Var | Var | Var | Var | Yok | Yok | Var | Kısmi | Eski BASIC kontrol akisi x64/AST tarafinda var; MIR tarafi zayif. |
| SUB | Var | Var | Var | Var | Var | Yok | Yok | Var | Kısmi | Bildirim ve codegen izi var; MIR fonksiyon indirme sinirli. |
| FUNCTION | Var | Var | Var | Var | Var | Yok | Yok | Var | Kısmi | Bildirim ve codegen izi var; call/return tam davranis test edilmeli. |
| CALL | Var | Var | Var | Var | Var | Var | Var | Var | Tam iz var | User/builtin/FFI ayrimi daginik; dispatcher guclendirilmeli. |
| TYPE | Var | Var | Var | Var | Var | Yok | Yok | Yok | Kısmi | UDT yuzeyi var; layout/codegen detaylari kismi. |
| CLASS | Var | Var | Var | Var | Var | Yok | Yok | Yok | Kısmi | Class parser/semantic yuzeyi var; MIR/x64/object runtime yok veya cok zayif. |
| CLASS METHOD | Var | Var | Var | Var | Var | Yok | Yok | Yok | Kısmi | Method bildirimi var; inline body ve cagirma tam degil. |
| CONSTRUCTOR | Var | Var | Var | Yok | Yok | Yok | Yok | Yok | Yüzey var | Constructor bildirimi var; NEW ile yasam dongusu bagli degil. |
| DESTRUCTOR | Var | Var | Var | Yok | Yok | Yok | Yok | Yok | Yüzey var | Destructor bildirimi var; DELETE/finalize ile bagli degil. |
| INTERFACE | Var | Var | Var | Var | Var | Yok | Yok | Yok | Kısmi | Interface yuzeyi var; implements imza denetimi/runtime dispatch eksik. |
| NEW | Var | Var | Var | Var | Var | Var | Var | Var | Tam iz var | NEW expression taniniyor; class constructor baglantisi ayrica eksik. |
| DELETE | Var | Var | Var | Var | Var | Yok | Yok | Var | Kısmi | DELETE statement var; destructor/free semantigi tamam degil. |
| FIELD ACCESS | OP | Var | Var | Var | Var | Yok | Yok | Var | Kısmi | Nokta erisimi parse/codegen izli; semantic layout baglantisi kismi. |
| REDIM | Var | Var | Var | Var | Var | Var | Var | Var | Tam iz var | Dinamik dizi bildirimi var; tam bounds/runtime davranisi test edilmeli. |
| FILE IO | Var | Var | Var | Yok | Var | Yok | Yok | Var | Kısmi | File IO parser/runtime/x64 izli; MIR tarafi yok. |
| TRY/CATCH/THROW | Var | Var | Var | Var | Var | Var | Yok | Yok | Kısmi | Exception yuzeyi AST/MIR lowering tarafinda var; x64 destegi yok. |
| ASSERT | Var | Var | Var | Var | Var | Var | Yok | Yok | Kısmi | Assert parser/runtime/MIR izli; x64 yok. |
| INLINE ASM | Var | Var | Var | Yok | Yok | Yok | Yok | Var | Yüzey var | Parser ve x64 backend var; AST exec/MIR dogal olarak yok. |
| IMPORT | Var | Var | Var | Var | Yok | Yok | Yok | Var | Kısmi | Interop manifest/build tarafina yakin; semantic/runtime baglama kismi. |
| EVENT/THREAD/PIPE/SLOT | Var | Var | Var | Yok | Var | Yok | Yok | Yok | Yüzey var | Parser yuzeyi ve slot runtime var; MIR/x64 yok. |

## Kritik sonuç

`src7` icin ana sonuc: parser ve AST yuzeyi genis; semantic, AST interpreter, MIR, MIR evaluator ve x64 ayni kapsami tasimiyor. Bu yuzden yeni ozellik eklemeden once katman esitleme yapilmalidir.

## Kanıt izleri

### PRINT
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bprint\b|\bPRINT\b
- Parser: Var — parser/parser/parser_stmt_basic.fbs:Parse\w*PRINT\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*PRINT\w*Stmt
- AST: Var — parser/parser/parser_stmt_basic.fbs:"PRINT_STMT"
- Semantic: Var — semantic/mir.fbs:"PRINT_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_io_file.fbs:"PRINT_STMT"
- MIR: Var — semantic/mir.fbs:"PRINT_STMT"
- MIR Exec: Var — semantic/mir_evaluator.fbs:PRINT
- x64: Var — codegen/x64/code_generator.fbs:"PRINT_STMT"

### INPUT
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\binput\b|\bINPUT\b
- Parser: Var — parser/parser/parser_stmt_dispatch.fbs:"INPUT_STMT"; parser/parser/parser_stmt_io.fbs:Parse\w*INPUT\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*INPUT\w*Stmt
- AST: Var — parser/parser/parser_stmt_dispatch.fbs:"INPUT_STMT"; parser/parser/parser_stmt_io.fbs:"INPUT_STMT"
- Semantic: Var — semantic/semantic_pass.fbs:"INPUT_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_io_file.fbs:"INPUT_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"INPUT_FILE_STMT"

### DIM
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bdim\b|\bDIM\b
- Parser: Var — parser/parser/parser_stmt_decl_dim_redim.fbs:Parse\w*DIM\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*DIM\w*Stmt; parser/parser/parser_stmt_dispatch.fbs:"DIM_STMT"
- AST: Var — parser/parser/parser_stmt_decl_dim_redim.fbs:"DIM_STMT"; parser/parser/parser_stmt_dispatch.fbs:"DIM_STMT"
- Semantic: Var — semantic/hir.fbs:"DIM_STMT"; semantic/mir.fbs:"DIM_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"DIM_STMT"
- MIR: Var — semantic/mir.fbs:"DIM_STMT"; semantic/mir_model.fbs:MIR_OP_DIM
- MIR Exec: Var — semantic/mir_evaluator.fbs:DIM
- x64: Var — codegen/x64/code_generator.fbs:"DIM_STMT"

### CONST
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bconst\b|\bCONST\b
- Parser: Var — parser/parser/parser_stmt_decl_dim_redim.fbs:Parse\w*CONST\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*CONST\w*Stmt; parser/parser/parser_stmt_dispatch.fbs:"CONST_STMT"
- AST: Var — parser/parser/parser_stmt_decl_dim_redim.fbs:"CONST_STMT"; parser/parser/parser_stmt_dispatch.fbs:"CONST_STMT"
- Semantic: Var — semantic/mir.fbs:"CONST_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"CONST_STMT"
- MIR: Var — semantic/mir.fbs:"CONST_STMT"; semantic/mir_model.fbs:MIR_OP_CONST
- MIR Exec: Var — semantic/mir_evaluator.fbs:CONST
- x64: Yok

### ASSIGN
- Lexer: OP
- Parser: Var — parser/parser/parser_stmt_registry.fbs:"ASSIGN_STMT"
- AST: Var — parser/parser/parser_stmt_registry.fbs:"ASSIGN_STMT"
- Semantic: Var — semantic/mir.fbs:"ASSIGN_STMT"; semantic/semantic_pass.fbs:"ASSIGN_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_memory_core.fbs:"ASSIGN_STMT"
- MIR: Var — semantic/mir.fbs:"ASSIGN_STMT"; semantic/mir_model.fbs:STORE_VAR
- MIR Exec: Var — semantic/mir_evaluator.fbs:STORE_VAR
- x64: Var — codegen/x64/code_generator.fbs:"ASSIGN_STMT"

### IF
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bif\b|\bIF\b
- Parser: Var — parser/parser/parser_stmt_dispatch.fbs:"IF_STMT"; parser/parser/parser_stmt_flow.fbs:Parse\w*IF\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*IF\w*Stmt
- AST: Var — parser/parser/parser_stmt_dispatch.fbs:"IF_STMT"; parser/parser/parser_stmt_flow.fbs:"IF_STMT"
- Semantic: Var — semantic/mir.fbs:"IF_STMT"; semantic/semantic_pass.fbs:"IF_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"IF_STMT"
- MIR: Var — semantic/mir.fbs:"IF_STMT"
- MIR Exec: Var — semantic/mir_evaluator.fbs:JZ
- x64: Var — codegen/x64/code_generator.fbs:"IF_STMT"

### SELECT CASE
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bselect\b|\bSELECT\b
- Parser: Var — parser/parser/parser_stmt_dispatch.fbs:"SELECT_STMT"; parser/parser/parser_stmt_flow.fbs:Parse\w*SELECT\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*SELECT\w*Stmt
- AST: Var — parser/parser/parser_stmt_dispatch.fbs:"SELECT_STMT"; parser/parser/parser_stmt_flow.fbs:"SELECT_STMT"
- Semantic: Var — semantic/mir.fbs:"SELECT_STMT"; semantic/semantic_pass.fbs:"SELECT_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"SELECT_STMT"
- MIR: Var — semantic/mir.fbs:"SELECT_STMT"
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"SELECT_STMT"

### FOR
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bfor\b|\bFOR\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:Parse\w*FOR\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*FOR\w*Stmt
- AST: Var — parser/parser/parser_stmt_flow.fbs:"FOR_STMT"
- Semantic: Var — semantic/mir.fbs:"FOR_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"FOR_STMT"
- MIR: Var — semantic/mir.fbs:"FOR_STMT"
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"FOR_STMT"

### FOR EACH
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\beach\b|\bEACH\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:Parse\w*FOR\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*FOR\w*Stmt
- AST: Var — parser/parser/parser_stmt_flow.fbs:"FOR_EACH_STMT"
- Semantic: Var — semantic/mir.fbs:"FOR_EACH_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"FOR_EACH_STMT"
- MIR: Var — semantic/mir.fbs:"FOR_EACH_STMT"
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"FOR_EACH_STMT"

### DO/LOOP
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bdo\b|\bDO\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:"DO_STMT"
- AST: Var — parser/parser/parser_stmt_flow.fbs:"DO_STMT"
- Semantic: Var — semantic/mir.fbs:"DO_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"DO_STMT"
- MIR: Var — semantic/mir.fbs:"DO_STMT"
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"DO_STMT"

### GOTO
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bgoto\b|\bGOTO\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:Parse\w*GOTO\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*GOTO\w*Stmt
- AST: Var — parser/parser/parser_stmt_flow.fbs:"GOTO_STMT"
- Semantic: Yok
- AST Exec: Var — runtime/memory_exec.fbs:"GOTO_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"GOTO_STMT"

### GOSUB/RETURN
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bgosub\b|\bGOSUB\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:"GOSUB_STMT"
- AST: Var — parser/parser/parser_stmt_flow.fbs:"GOSUB_STMT"
- Semantic: Var — semantic/semantic_pass.fbs:"RETURN_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"GOSUB_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"GOSUB_STMT"

### SUB
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bsub\b|\bSUB\b
- Parser: Var — parser/parser/parser_stmt_decl_class_method.fbs:"PARAM_DECL"; parser/parser/parser_stmt_decl_core.fbs:"PARAM_DECL"; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*SUB\w*Stmt
- AST: Var — parser/parser/parser_stmt_decl_class_method.fbs:"PARAM_DECL"; parser/parser/parser_stmt_decl_core.fbs:"PARAM_DECL"; parser/parser/parser_stmt_decl_proc.fbs:"SUB_STMT"
- Semantic: Var — semantic/hir.fbs:"SUB_STMT"; semantic/semantic_pass.fbs:"SUB_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"SUB_STMT"; runtime/exec/exec_class_layout_helpers.fbs:"SUB_STMT"; runtime/exec/exec_eval_support_helpers.fbs:"SUB_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"SUB_STMT"

### FUNCTION
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bfunction\b|\bFUNCTION\b
- Parser: Var — parser/parser/parser_stmt_decl_class_method.fbs:"RETURN_TYPE"; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*FUNCTION\w*Stmt; parser/parser/parser_stmt_decl_proc.fbs:Parse\w*FUNCTION\w*Stmt
- AST: Var — parser/parser/parser_stmt_decl_class_method.fbs:"RETURN_TYPE"; parser/parser/parser_stmt_decl_proc.fbs:"FUNCTION_STMT"; parser/parser/parser_stmt_dispatch.fbs:"FUNCTION_STMT"
- Semantic: Var — semantic/hir.fbs:"FUNCTION_STMT"; semantic/semantic_pass.fbs:"FUNCTION_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"FUNCTION_STMT"; runtime/exec/exec_call_dispatch_helpers.fbs:"FUNCTION_STMT"; runtime/exec/exec_eval_support_helpers.fbs:"FUNCTION_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"FUNCTION_STMT"

### CALL
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bcall\b|\bCALL\b
- Parser: Var — parser/parser/parser_expr.fbs:"CALL_EXPR"; parser/parser/parser_stmt_basic.fbs:Parse\w*CALL\w*Stmt; parser/parser/parser_stmt_dispatch.fbs:"CALL_STMT"
- AST: Var — parser/parser/parser_expr.fbs:"CALL_EXPR"; parser/parser/parser_stmt_basic.fbs:"CALL_STMT"; parser/parser/parser_stmt_dispatch.fbs:"CALL_STMT"
- Semantic: Var — semantic/hir.fbs:"CALL_STMT"; semantic/mir.fbs:"CALL_STMT"; semantic/semantic_pass.fbs:"CALL_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"CALL_STMT"; runtime/exec/exec_eval_text_helpers.fbs:"CALL_EXPR"; runtime/exec/exec_state_value_utils.fbs:"CALL_EXPR"
- MIR: Var — semantic/mir.fbs:"CALL_STMT"
- MIR Exec: Var — semantic/mir_evaluator.fbs:CALL
- x64: Var — codegen/x64/code_generator.fbs:"CALL_STMT"; codegen/x64/ffi_call_backend.fbs:"CALL_STMT"

### TYPE
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\btype\b|\bTYPE\b
- Parser: Var — parser/parser/parser_stmt_decl_core.fbs:Parse\w*TYPE\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*TYPE\w*Stmt; parser/parser/parser_stmt_dispatch.fbs:"TYPE_STMT"
- AST: Var — parser/parser/parser_stmt_decl_core.fbs:"TYPE_STMT"; parser/parser/parser_stmt_dispatch.fbs:"TYPE_STMT"
- Semantic: Var — semantic/hir.fbs:"TYPE_STMT"; semantic/layout/layout_type_table.fbs:"TYPE_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"TYPE_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

### CLASS
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bclass\b|\bCLASS\b
- Parser: Var — parser/parser/parser_stmt_decl_class_method.fbs:"CLASS_STMT"; parser/parser/parser_stmt_decl_core.fbs:Parse\w*CLASS\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*CLASS\w*Stmt
- AST: Var — parser/parser/parser_stmt_decl_class_method.fbs:"CLASS_STMT"; parser/parser/parser_stmt_decl_core.fbs:"CLASS_STMT"; parser/parser/parser_stmt_dispatch.fbs:"CLASS_STMT"
- Semantic: Var — semantic/hir.fbs:"CLASS_STMT"; semantic/semantic_pass.fbs:"CLASS_STMT"; semantic/layout/layout_type_table.fbs:"CLASS_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"CLASS_STMT"; runtime/exec/exec_class_layout_helpers.fbs:"CLASS_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

### CLASS METHOD
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bmethod\b|\bMETHOD\b
- Parser: Var — parser/parser/parser_stmt_decl_class_method.fbs:"CLASS_METHOD_DECL"; parser/parser/parser_stmt_decl_core.fbs:Parse\w*CLASS\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*CLASS\w*Stmt
- AST: Var — parser/parser/parser_stmt_decl_class_method.fbs:"CLASS_METHOD_DECL"; parser/parser/parser_stmt_decl_core.fbs:"CLASS_METHOD_DECL"
- Semantic: Var — semantic/semantic_pass.fbs:"CLASS_METHOD_DECL"
- AST Exec: Var — runtime/exec/exec_call_dispatch_helpers.fbs:"CLASS_METHOD_DECL"
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

### CONSTRUCTOR
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bconstructor\b|\bCONSTRUCTOR\b
- Parser: Var — parser/parser/parser_stmt_decl_core.fbs:"CLASS_CONSTRUCTOR_DECL"
- AST: Var — parser/parser/parser_stmt_decl_core.fbs:"CLASS_CONSTRUCTOR_DECL"
- Semantic: Yok
- AST Exec: Yok
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

### DESTRUCTOR
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bdestructor\b|\bDESTRUCTOR\b
- Parser: Var — parser/parser/parser_stmt_decl_core.fbs:"CLASS_DESTRUCTOR_DECL"
- AST: Var — parser/parser/parser_stmt_decl_core.fbs:"CLASS_DESTRUCTOR_DECL"
- Semantic: Yok
- AST Exec: Yok
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

### INTERFACE
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\binterface\b|\bINTERFACE\b
- Parser: Var — parser/parser/parser_stmt_decl_core.fbs:Parse\w*INTERFACE\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*INTERFACE\w*Stmt
- AST: Var — parser/parser/parser_stmt_decl_core.fbs:"INTERFACE_STMT"
- Semantic: Var — semantic/hir.fbs:"INTERFACE_STMT"; semantic/semantic_pass.fbs:"INTERFACE_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"INTERFACE_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

### NEW
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bnew\b|\bNEW\b
- Parser: Var — parser/parser/parser_expr.fbs:"NEW_EXPR"; parser/parser/parser_stmt_basic.fbs:Parse\w*NEW\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*NEW\w*Stmt
- AST: Var — parser/parser/parser_expr.fbs:"NEW_EXPR"
- Semantic: Var — semantic/mir.fbs:"NEW_EXPR"; semantic/semantic_pass.fbs:"NEW_EXPR"
- AST Exec: Var — runtime/memory_exec.fbs:"NEW_EXPR"; runtime/exec/exec_stmt_memory_core.fbs:"NEW_EXPR"
- MIR: Var — semantic/mir.fbs:MIR_OP_NEW; semantic/mir_model.fbs:MIR_OP_NEW
- MIR Exec: Var — semantic/mir_evaluator.fbs:NEW
- x64: Var — codegen/x64/code_generator.fbs:"NEW_EXPR"

### DELETE
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bdelete\b|\bDELETE\b
- Parser: Var — parser/parser/parser_stmt_basic.fbs:Parse\w*DELETE\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*DELETE\w*Stmt
- AST: Var — parser/parser/parser_stmt_basic.fbs:"DELETE_STMT"
- Semantic: Var — semantic/semantic_pass.fbs:"DELETE_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_memory_core.fbs:"DELETE_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"DELETE_STMT"

### FIELD ACCESS
- Lexer: OP
- Parser: Var — parser/parser/parser_expr.fbs:"FIELD_EXPR"; parser/parser/parser_stmt_registry.fbs:"FIELD_EXPR"
- AST: Var — parser/parser/parser_expr.fbs:"FIELD_EXPR"; parser/parser/parser_stmt_registry.fbs:"FIELD_EXPR"
- Semantic: Var — semantic/mir.fbs:"FIELD_EXPR"
- AST Exec: Var — runtime/memory_exec.fbs:"FIELD_EXPR"; runtime/exec/exec_stmt_memory_core.fbs:"FIELD_EXPR"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"FIELD_EXPR"

### REDIM
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bredim\b|\bREDIM\b
- Parser: Var — parser/parser/parser_stmt_decl_dim_redim.fbs:Parse\w*REDIM\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*REDIM\w*Stmt; parser/parser/parser_stmt_dispatch.fbs:"REDIM_STMT"
- AST: Var — parser/parser/parser_stmt_decl_dim_redim.fbs:"REDIM_STMT"; parser/parser/parser_stmt_dispatch.fbs:"REDIM_STMT"
- Semantic: Var — semantic/hir.fbs:"REDIM_STMT"; semantic/mir.fbs:"REDIM_STMT"
- AST Exec: Var — runtime/memory_exec.fbs:"REDIM_STMT"
- MIR: Var — semantic/mir.fbs:"REDIM_STMT"; semantic/mir_model.fbs:MIR_OP_REDIM
- MIR Exec: Var — semantic/mir_evaluator.fbs:REDIM
- x64: Var — codegen/x64/code_generator.fbs:"REDIM_STMT"

### FILE IO
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bopen\b|\bOPEN\b
- Parser: Var — parser/parser/parser_stmt_io.fbs:Parse\w*FILE\w*Stmt
- AST: Var — parser/parser/parser_stmt_io.fbs:"OPEN_STMT"
- Semantic: Yok
- AST Exec: Var — runtime/exec/exec_stmt_io_file.fbs:"OPEN_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/code_generator.fbs:"OPEN_STMT"

### TRY/CATCH/THROW
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\btry\b|\bTRY\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:"TRY_STMT"
- AST: Var — parser/parser/parser_stmt_flow.fbs:"TRY_STMT"
- Semantic: Var — semantic/mir.fbs:"TRY_STMT"; semantic/semantic_pass.fbs:"THROW_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"TRY_STMT"
- MIR: Var — semantic/mir.fbs:"TRY_STMT"
- MIR Exec: Yok
- x64: Yok

### ASSERT
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bassert\b|\bASSERT\b
- Parser: Var — parser/parser/parser_stmt_flow.fbs:Parse\w*ASSERT\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*ASSERT\w*Stmt
- AST: Var — parser/parser/parser_stmt_flow.fbs:"ASSERT_STMT"
- Semantic: Var — semantic/mir.fbs:"ASSERT_STMT"
- AST Exec: Var — runtime/exec/exec_stmt_flow.fbs:"ASSERT_STMT"
- MIR: Var — semantic/mir.fbs:"ASSERT_STMT"
- MIR Exec: Yok
- x64: Yok

### INLINE ASM
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\binline\b|\bINLINE\b
- Parser: Var — parser/parser/parser_stmt_basic.fbs:Parse\w*INLINE\w*Stmt; parser/parser/parser_stmt_registry.fbs:Parse\w*INLINE\w*Stmt
- AST: Var — parser/parser/parser_stmt_basic.fbs:"INLINE_STMT"
- Semantic: Yok
- AST Exec: Yok
- MIR: Yok
- MIR Exec: Yok
- x64: Var — codegen/x64/inline_backend.fbs:INLINE; build/x64_build_pipeline.fbs:INLINE

### IMPORT
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bimport\b|\bIMPORT\b
- Parser: Var — parser/parser/parser_stmt_decl_core.fbs:Parse\w*IMPORT\w*Stmt; parser/parser/parser_stmt_decl_dispatch.fbs:Parse\w*IMPORT\w*Stmt; parser/parser/parser_stmt_dispatch.fbs:"IMPORT_STMT"
- AST: Var — parser/parser/parser_stmt_decl_core.fbs:"IMPORT_STMT"; parser/parser/parser_stmt_dispatch.fbs:"IMPORT_STMT"
- Semantic: Var — semantic/semantic_pass.fbs:"IMPORT_STMT"
- AST Exec: Yok
- MIR: Yok
- MIR Exec: Yok
- x64: Var — build/x64_build_pipeline.fbs:interop

### EVENT/THREAD/PIPE/SLOT
- Lexer: Var — parser/lexer/lexer_keyword_table.fbs:\bevent\b|\bEVENT\b
- Parser: Var — parser/parser/parser_stmt_event_pipe.fbs:"SLOT_STMT"
- AST: Var — parser/parser/parser_stmt_event_pipe.fbs:"SLOT_STMT"
- Semantic: Yok
- AST Exec: Var — runtime/exec/exec_slot_manager.fbs:"SLOT_STMT"
- MIR: Yok
- MIR Exec: Yok
- x64: Yok

