# uXBasic Compiler — Derinlemesine Analiz ve Endüstriyel Yol Haritası

> Versiyon: 28 Mayıs 2026 | Kaynak: uxb_28_05_1_.zip (1011 dosya, ~12.6 MB)

---

## BÖLÜM 0 — Sistemin Gerçek Durumu (Özet)

Proje kayda değer bir olgunluk seviyesinde. Lexer, parser, AST, semantic pass,
HIR taslağı, MIR modeli + lowering, MIR verifier, AST + MIR interpreter, x64
NASM codegen (~5 143 satır), JS ve WASM/WAT backend'leri, runtime service
dispatcher ve VSCode extension mevcut. Surface registry 1 114 satır. Adım
planları (1–6) metodolojik.

**Ancak** bu katmanlar arasında birçok kritik bağlantı kopukluğu var; bazı
temel veri yapıları gerçek bir derleyicinin talep ettiği gereksinimleri
karşılamıyor; CLI henüz katman bazlı anahtarlanabilir bir araç değil. Aşağıda
her katmanın kusurları, hataya açık yönleri, ve düzeltme iskeletleri
verilmiştir.

---

## BÖLÜM 1 — Katman Katman Eleştiri

### 1.1 LEXER

#### Durum
Lexer çalışıyor. `lexer_core`, `lexer_keyword_table`, `lexer_readers`,
`lexer_preprocess`, `lexer_driver` dosyalarına bölünmüş. Keyword tablosu
`Select Case` zinciri ile işliyor.

#### Kritik Sorun — Token.kind bir String

```freebasic
' MEVCUT (src/parser/token_kinds.fbs)
Type Token
    kind As String   ' "KEYWORD", "IDENT", "OP", "EOF" ...
    lexeme As String
    ...
End Type
```

Tüm derleyici boyunca `tok.kind = "KEYWORD"`, `tok.kind = "EOF"` gibi
karşılaştırmalar yapılıyor. Her karşılaştırma bir string heap allocation veya
length check içerir. Büyük dosyalarda bu binlerce kez gerçekleşir.

**Düzeltme — Integer enum kullan:**

```freebasic
' ÖNERİ: src/parser/token_kinds.fbs
Enum TokKind
    TK_UNKNOWN = 0
    TK_EOF     = 1
    TK_EOL     = 2
    TK_KEYWORD = 3
    TK_IDENT   = 4
    TK_INT_LIT = 5
    TK_FLOAT_LIT = 6
    TK_STR_LIT = 7
    TK_OP      = 8
    TK_PUNCT   = 9
End Enum

Type Token
    kind       As TokKind   ' integer karşılaştırma — string yok
    lexeme     As String
    lineNo     As Integer
    colNo      As Integer
    sourceFile As String
    lexemeLength As Integer
End Type
```

`lexeme` alanı keyword'ler için bile tutuluyor; bu doğru. Ama `kind`
karşılaştırmaları integer olursa hem hızlanır hem de typo hatası ("KEYWROD")
imkansız hale gelir.

#### Sorun — Keyword tablosu `Select Case` zinciri, performanssız büyüme

197 keyword + daha fazlası Select Case'e eklendiğinde O(n) haline geliyor.

**Düzeltme — Compile-time hash map (FreeBasic ile):**

```freebasic
' src/parser/lexer/lexer_keyword_map.fbs
' Keyword -> TokKind eşlemesi için static hash tablosu

Private Const KW_BUCKET_COUNT = 256   ' 2^n seç

Type KwEntry
    word    As String
    tokKind As TokKind
End Type

Dim Shared gKwBuckets(KW_BUCKET_COUNT - 1, 7) As KwEntry
Dim Shared gKwBucketSizes(KW_BUCKET_COUNT - 1) As Integer
Dim Shared gKwTableReady As Integer

Private Function KwHash(ByRef w As String) As Integer
    Dim h As Integer = 5381
    Dim i As Integer
    For i = 1 To Len(w)
        h = ((h Shl 5) + h) Xor Asc(Mid(w, i, 1))
    Next i
    Return (h And &H7FFFFFFF) Mod KW_BUCKET_COUNT
End Function

Sub KwTableInit()
    If gKwTableReady Then Exit Sub
    ' Her keyword tek seferinde eklenir
    KwInsert "if",       TK_KEYWORD
    KwInsert "then",     TK_KEYWORD
    KwInsert "else",     TK_KEYWORD
    ' ... tümü
    gKwTableReady = 1
End Sub

Function KwLookup(ByRef word As String, ByRef kindOut As TokKind) As Integer
    Dim bucket As Integer = KwHash(LCase(word))
    Dim i As Integer
    For i = 0 To gKwBucketSizes(bucket) - 1
        If gKwBuckets(bucket, i).word = LCase(word) Then
            kindOut = gKwBuckets(bucket, i).tokKind
            Return 1
        End If
    Next i
    Return 0
End Function
```

#### Sorun — `ShouldTreatAsKeyword` bağlam kontrolü sınırlı

Sadece önceki token `"."` veya `DIM/REDIM/CONST` ise keyword muamelesi yapmıyor.
Ama `Function`, `Sub`, `Type`, `Class` sonrasında gelen isimler de keyword
olarak işlenmemeli.

```freebasic
' ÖNERİ: lexer_keyword_table.fbs içine ekle
' Bu liste genişletilmeli:
Select Case prevKw
Case "DIM", "REDIM", "CONST", "FUNCTION", "SUB", "DECLARE",
     "TYPE", "CLASS", "INTERFACE", "PROPERTY", "OPERATOR",
     "NAMESPACE", "MODULE", "METHOD", "MIXIN", "DECORATOR"
    Return 0   ' bu keyword'lerden sonra gelen isim, keyword değil
End Select
```

---

### 1.2 PARSER

#### Durum
60+ stmt ayrıştırıcısı `parser.fbs`'de declare edilmiş. `ParseState` iyi
tanımlanmış.

#### Kritik Sorun — Hata Kurtarma (Error Recovery) YOK

```freebasic
' MEVCUT: ps.parseErrors dizisine ekleniyor, ama ardından ne olacağı belirsiz
```

Gerçek bir derleyicide ilk hatadan sonra parser senkronizasyon noktasına (stmt
sonu, `End If`, `End Sub` vs.) atlamalı ve hataları toplamaya devam etmelidir.
Aksi halde tek bir sözdizimi hatası yüzlerce sahte hata üretir ya da parse
yarıda durur.

**Düzeltme — Panik-mod kurtarma iskeleti:**

```freebasic
' src/parser/parser_shared.fbs'e ekle

' Eşitleme token seti: statement başlangıçları ve blok kapayıcıları
Private Function IsStatementSync(ByRef tok As Token) As Integer
    If tok.kind <> TK_KEYWORD Then Return 0
    Select Case UCase(tok.lexeme)
    Case "DIM", "IF", "FOR", "WHILE", "DO", "SELECT", "FUNCTION",
         "SUB", "TYPE", "CLASS", "END", "RETURN", "NEXT", "LOOP",
         "ELSEIF", "ELSE", "CASE", "EOF"
        Return 1
    End Select
    Return 0
End Function

' Parser bir hata bulduğunda çağır
Sub ParserSyncToStatement(ByRef ps As ParseState)
    Do
        Dim t As Token = CurrentToken(ps)
        If t.kind = TK_EOF Then Exit Do
        If IsStatementSync(t) Then Exit Do
        AdvanceToken ps
    Loop
End Sub

' Hata kaydetme + sync
Sub ParserError(ByRef ps As ParseState, ByRef msg As String)
    RecordParseError ps, msg
    If ps.parseErrorCount < 20 Then   ' İlk 20 hatayı topla
        ParserSyncToStatement ps
    End If
End Sub
```

#### Sorun — ParseState'de `namespaceDepth`, `moduleDepth`, `mainDepth` int sayaçları var ama scope stack yok

İç içe namespace/module/class içindeki isimler tam nitelikli (fully-qualified)
olarak resolve edilemiyor.

**Düzeltme — ParseState'e basit isim yığını ekle:**

```freebasic
' ParseState Type bloğuna ekle:
    qualifierStack(0 To 31) As String
    qualifierDepth As Integer
```

---

### 1.3 AST

#### Durum
İyi yapılandırılmış. `ASTNodeFamily`, `ASTNodeFlags` enum'ları var. `parent`,
`role`, `typeName`, `symbolName` alanları eklenmiş.

#### Sorun — `kind As String` ASTNode'da da var

```freebasic
' MEVCUT:
Type ASTNode
    kind As String   ' "DIM_STMT", "BINARY_EXPR", vb.
```

Bu da her semantic/codegen geçişinde string karşılaştırmasına dönüşüyor.

**Düzeltme — ASTNodeKind enum:**

```freebasic
' src/parser/ast_node_kinds.fbs — mevcut dosyaya ekle:
Enum ASTNodeKind
    AST_UNKNOWN        = 0
    AST_PROGRAM        = 1
    AST_DIM_STMT       = 2
    AST_ASSIGN_STMT    = 3
    AST_IF_STMT        = 4
    AST_FOR_STMT       = 5
    AST_WHILE_STMT     = 6
    AST_FUNCTION_DECL  = 7
    AST_SUB_DECL       = 8
    AST_CLASS_DECL     = 9
    AST_CALL_EXPR      = 10
    AST_BINARY_EXPR    = 11
    AST_UNARY_EXPR     = 12
    AST_IDENT_EXPR     = 13
    AST_INT_LIT        = 14
    AST_FLOAT_LIT      = 15
    AST_STRING_LIT     = 16
    AST_RETURN_STMT    = 17
    ' ... devam
    AST__COUNT
End Enum

' ASTNode'a ekle:
    nodeKind As ASTNodeKind   ' integer; kind string ile paralel tut ama
                               ' karşılaştırma için bunu kullan
```

Geçiş döneminde `kind` string'ini de koru; `nodeKind`'ı parser doldursun,
semantic pass sadece integer karşılaştırsın.

#### Sorun — `left/right` alanları eski binary-tree artefaktı

"Eski çağrılar bozulmasın" yorumuyla bırakılmış ama `firstChild/nextSibling`
zaten var. Bu iki set birbirini karıştıran bir zamanlı bomba.

**Düzeltme:** `left`/`right` alanlarını deprecated işaretle; bir adım planına
koy; tüm kullanımları `SemChildAt(ps, nodeIdx, 0)` ve `1` indexine taşı.

---

### 1.4 HIR — Duplike Sembol Tablosu Sorunu

#### Kritik Sorun — İki bağımsız sembol tablosu var

`src/semantic/hir.fbs`:
```freebasic
Type SymbolTable
    entries(0 to 255) As SymbolEntry   ' SABİT 256 LIMIT — overflow silently ignored
    count As Integer
End Type
Dim Shared gGlobalScope As SymbolTable
Dim Shared gScopeStack As ScopeStack
```

`src/symbols/symbol_table.fbs`:
```freebasic
Dim Shared gUXBStep3Symbols(Any) As UXBSymbolRecord
Dim Shared gUXBStep3SymbolCount As Integer
```

**Bunlar birbirinden habersiz iki ayrı sembol tablosu.** HIR'daki
`SymbolTableAdd` ile semantic pass'daki `UXBStep3SymbolAdd` birbirinin
sonuçlarını görmüyor. Semantic pass sonuçları MIR lowering'e aktarılıyor; HIR
tablosundaki bilgiler ise pipelina'nın dışında kalıyor.

**Düzeltme:**
1. `hir.fbs`'deki `SymbolTable`/`ScopeStack` tiplerini DEPRECATED yap.
2. Tüm HIR-seviye sembol işlemlerini `UXBStep3Symbol*` API'sine yönlendir.
3. `HIRInventory` tipi korunabilir (envanter listesi için kullanışlı) ama
   sembol çözümlemesi sadece tek kaynaktan yapılmalı.

---

### 1.5 SEMANTİK + SCOPE + SEMBOL TABLOSU

#### Sorun — Scope zinciri sadece current → global atluyor

```freebasic
' MEVCUT: symbol_table.fbs
Function UXBStep3SymbolFind(..., ByVal scopeId As Integer) As Integer
    Dim exactIdx As Integer = UXBStep3SymbolFindExact(nameText, kindText, scopeId)
    If exactIdx <> -1 Then Return exactIdx
    If scopeId <> 0 Then Return UXBStep3SymbolFindExact(nameText, kindText, 0)
    ' SORUN: Ara scope'lar atlanıyor. Sadece current + global bakıyor.
    Return -1
End Function
```

İç içe `Function` içindeki `Function`'da tanımlı değişkene erişim yanlış
çalışır. Örnek:

```vbnet
Function Outer()
    Dim x As Integer = 10
    Function Inner()
        Print x   ' x bulunamaz — sadece Inner scope + Global bakılır
    End Function
End Function
```

**Düzeltme — Tam lexical chain walk:**

```freebasic
Function UXBStep3SymbolFindLexical(ByVal nameText As String, ByVal kindText As String, ByVal startScopeId As Integer) As Integer
    Dim curScope As Integer = startScopeId
    Do While curScope >= 0
        Dim idx As Integer = UXBStep3SymbolFindExact(nameText, kindText, curScope)
        If idx <> -1 Then Return idx
        If curScope = 0 Then Exit Do   ' global'e ulaştık
        curScope = gUXBStep3Scopes(curScope).parentId
    Loop
    Return -1
End Function
```

Bu fonksiyon `UXBStep3SymbolFind`'ın yerini almalı.

#### Sorun — Sembol tablosu linear search, O(n)

```freebasic
For i = 0 To gUXBStep3SymbolCount - 1
    If UCase(gUXBStep3Symbols(i).name) = key Then ...
```

Büyük dosyalarda sembol başına O(n) arama vardır. Ortanın üzerinde bir
programda yüzlerce sembol = her resolve için yüzlerce karşılaştırma.

**Düzeltme — Basit açık adresleme hash map (probing):**

```freebasic
' src/symbols/symbol_hash.fbs

Private Const SYM_HT_SIZE = 4096    ' 2^n, yük faktörü < 0.75 tut

Type SymHashSlot
    key        As String   ' "SCOPEID::NAME::KIND"
    symbolIdx  As Integer  ' gUXBStep3Symbols içindeki index; -1 = boş
End Type

Dim Shared gSymHash(SYM_HT_SIZE - 1) As SymHashSlot
Dim Shared gSymHashCount As Integer

Private Function SymHashKey(ByVal nameU As String, ByVal kindU As String, ByVal scopeId As Integer) As String
    Return LTrim(Str(scopeId)) & "::" & nameU & "::" & kindU
End Function

Private Function SymHashOf(ByRef key As String) As Integer
    Dim h As UInteger = 2166136261
    Dim i As Integer
    For i = 1 To Len(key)
        h = (h Xor Asc(Mid(key, i, 1))) * 16777619
    Next i
    Return CInt(h Mod SYM_HT_SIZE)
End Function

Function SymHashLookup(ByRef key As String) As Integer
    Dim slot As Integer = SymHashOf(key)
    Dim probe As Integer
    For probe = 0 To SYM_HT_SIZE - 1
        Dim idx As Integer = (slot + probe) Mod SYM_HT_SIZE
        If gSymHash(idx).symbolIdx = -1 Then Return -1   ' boş slot = yok
        If gSymHash(idx).key = key Then Return gSymHash(idx).symbolIdx
    Next probe
    Return -1
End Function

Sub SymHashInsert(ByRef key As String, ByVal symbolIdx As Integer)
    If gSymHashCount > SYM_HT_SIZE * 3 / 4 Then
        ' yük faktörü aşıldı — rehash gerekir; şimdilik error bas
        Exit Sub
    End If
    Dim slot As Integer = SymHashOf(key)
    Dim probe As Integer
    For probe = 0 To SYM_HT_SIZE - 1
        Dim idx As Integer = (slot + probe) Mod SYM_HT_SIZE
        If gSymHash(idx).symbolIdx = -1 Then
            gSymHash(idx).key = key
            gSymHash(idx).symbolIdx = symbolIdx
            gSymHashCount += 1
            Exit For
        End If
    Next probe
End Sub
```

`UXBStep3SymbolAdd` içinde `SymHashInsert` çağır; `UXBStep3SymbolFindExact`
içinde `SymHashLookup` çağır.

---

### 1.6 MIR MODELİ

#### Sorun — `MIRIRInstruction.operands(0 To 15) As String`

Sabit 16 operand slotu. Operand sayısı tutulmak zorunda (`operandCount`). Ama
`MIRAppendInstruction` fonksiyonu:

```freebasic
Private Sub MIRAppendInstruction(ByRef module As MIRModule, ...,
    ByRef op0 As String = "", ByRef op1 As String = "", ...,
    ByRef op15 As String = "")
```

Bu 16 konumsal parametre ile çağrılan her yerden yanlış operand sırası hatası
yapılabilir; op5 yerine op6'ya koyan kod derlenir ama yanlış sonuç üretir.
Hata tespit edilmesi çok zor.

**Düzeltme — Operand builder deseni:**

```freebasic
' src/semantic/mir_instruction_builder.fbs

Type MIRInstrBuilder
    opcode      As String
    resultName  As String
    ops(0 To 15) As String
    opCount     As Integer
End Type

Sub MIRBuilderInit(ByRef b As MIRInstrBuilder, ByRef opcode As String, ByRef result As String = "")
    b.opcode     = opcode
    b.resultName = result
    b.opCount    = 0
End Sub

Sub MIRBuilderAddOp(ByRef b As MIRInstrBuilder, ByRef operand As String)
    If b.opCount > 15 Then Exit Sub   ' ya da hata
    b.ops(b.opCount) = operand
    b.opCount += 1
End Sub

Function MIRBuilderCommit(ByRef module As MIRModule, ByVal fnIdx As Integer, ByVal blockIdx As Integer, ByRef b As MIRInstrBuilder) As Integer
    ' builder'dan instruction oluştur ve ekle
    MIRAppendInstFromBuilder module, fnIdx, blockIdx, b
    Return 1
End Function
```

Tüm `MIRAppendInstruction` çağrıları zamanla bu API'ye taşınmalı.

#### Sorun — `MIRFunction.localVars(Any) As String` — sadece isim, tip yok

```freebasic
Type MIRFunction
    localVars(Any) As String   ' sadece değişken adları
```

Codegen tip bilgisine ihtiyaç duyar: bir yerel değişken `I32` mi, `F64` mı,
`String` mı bilmeden register allocation veya stack frame hesaplanamaz.

**Düzeltme:**

```freebasic
Type MIRLocalVar
    name     As String
    typeName As String   ' "I32", "F64", "STRING", "PTR" vb.
    isParam  As Integer
    paramIdx As Integer
End Type

Type MIRFunction
    localVars(Any) As MIRLocalVar
    localVarCount  As Integer
    ' ...
End Type
```

---

### 1.7 MIR VERİFİER

#### Kritik Sorun — Opt-in, zorunlu değil

```freebasic
' main_program_entry.fbs:
mirVerifyRequested = 0
If HasArg("--mir-verify") Then mirVerifyRequested = 1
```

MIR verifier yalnızca `--mir-verify` flag'i verildiğinde çalışıyor. Oysa gerçek
bir derleyicide IR doğrulaması **her backend çalıştırılmadan önce zorunlu** bir
kapı olmalıdır.

**Düzeltme:**

```freebasic
' MIR oluştuktan sonra — backend'den ÖNCE:
Dim verResult As UXBMIRVerifyResult
UXBMIRVerifyInit verResult
UXBMIRVerifyModule mirModule, verResult
If verResult.ok = 0 Then
    UxbError "MIR dogrulama basarisiz: " & verResult.errorsText
    End 1
End If
' Ancak buradan sonra backend çalışır
```

---

### 1.8 CODEGEN — x64 / JS / WASM

#### Sorun — HIR → MIR → Backend zinciri doğrudan bağlı değil

`backend_step6.fbs` doğru şekilde dispatch yapıyor:

```freebasic
Function UXBBackendEmitModuleStep6(ByRef moduleValue As MIRModule, ByRef ctx As UXBBackendContext, ...) As Integer
    Select Case tgt
    Case UXB_TARGET_X64:   Return UXBX64EmitModuleStep6(...)
    Case UXB_TARGET_JS:    Return UXBJsBackendEmitModule(...)
    Case UXB_TARGET_WASM:  Return UXBWasmBackendEmitModule(...)
    End Select
```

Ama `UXBBackendContext` nasıl dolduruluyor? `main_program_entry.fbs`'de
`x64EmitMode`, `codegenMode` gibi boolean'lar var ama bunlar `UXBBackendContext`
yapısına senkronize edilmeden backend fonksiyonları çağrılıyor mu? Bu bağlantı
hâlâ zincir dışında kalıyor.

**Düzeltme — Tek bağlayıcı fonksiyon:**

```freebasic
' src/backend/backend_pipeline.fbs

Function UXBBackendRunPipeline(ByRef mirModule As MIRModule, ByRef cliArgs As UXBCliArgs, ByRef result As UXBBackendResult) As Integer
    ' 1. MIR verify (ZORUNLU)
    Dim vr As UXBMIRVerifyResult
    UXBMIRVerifyModule mirModule, vr
    If vr.ok = 0 Then
        UXBBackendResultFail result, UXB_BACKEND_E_VERIFY_BLOCK, vr.errorsText
        Return 0
    End If

    ' 2. Context inşa et
    Dim ctx As UXBBackendContext
    UXBBackendContextFromCliArgs ctx, cliArgs

    ' 3. Hedef backend'e yönlendir
    Return UXBBackendEmitModuleStep6(mirModule, ctx, result)
End Function
```

`main_program_entry.fbs` sadece bu fonksiyonu çağırmalı.

#### Sorun — WASM için `wat2wasm` yoksa hata geç gelir

```freebasic
' wasm_codegen.fbs:
If Trim(ctx.wasmToolPath) <> "" And Trim(ctx.wasmOutPath) <> "" Then
    ' ...
Else
    result.status = UXB_BACKEND_STATUS_SKIPPED_EXTERNAL_TOOL
```

Kullanıcı uzun bir derleme sürecinden sonra "wat2wasm bulunamadı" hatası alır.

**Düzeltme — Başlangıçta araç kontrolü:**

```freebasic
' CLI başlangıcında (main_program_entry.fbs):
If HasArg("--target-wasm") Or HasArg("--emit-wasm") Then
    If Trim(wasmToolPath) = "" Then
        UxbError "WASM hedefi icin --wasm-tool-path belirtilmeli (wat2wasm yolu)"
        End 1
    End If
    If Not FileExists(wasmToolPath) Then
        UxbError "wat2wasm bulunamadi: " & wasmToolPath
        End 1
    End If
End If
```

---

### 1.9 HOOK SİSTEMİ — Tamamen Kapalı

```freebasic
' compiler/hooks/uxb_global_noop_hook.fbs:
Const UXB_HOOK_ENABLED As Integer = 0
Const UXB_HOOK_TRACE_ENABLED As Integer = 0
```

`UXB_HOOK_TRACE(MSG)` makrosu her çağrıda boş. Katmanlar arası izleme devre
dışı.

**Düzeltme — Compile-time açma/kapama ile gerçek hook:**

```freebasic
' compiler/hooks/uxb_hook_impl.fbs

#ifdef UXB_ENABLE_HOOKS
    Const UXB_HOOK_ENABLED = 1
    Private Dim Shared gHookTraceFile As Integer
    Private Dim Shared gHookTraceReady As Integer

    Sub UxbHookOpen(ByRef outPath As String)
        gHookTraceFile = FreeFile
        Open outPath For Output As #gHookTraceFile
        gHookTraceReady = 1
    End Sub

    Sub UxbHookTrace(ByRef layer As String, ByRef event As String, ByRef data As String = "")
        If gHookTraceReady = 0 Then Exit Sub
        Print #gHookTraceFile, "{""layer"":""" & layer & """,""event"":""" & event & """,""data"":""" & data & """}"
    End Sub

    #macro UXB_HOOK_TRACE(LAYER, EVENT, DATA)
        UxbHookTrace LAYER, EVENT, DATA
    #endmacro
#else
    #macro UXB_HOOK_TRACE(LAYER, EVENT, DATA)
    #endmacro
#endif
```

`fbc -d UXB_ENABLE_HOOKS` ile derleme yapıldığında aktif olur; production
build'de sıfır maliyet.

---

### 1.10 JSON ÇIKTISI — Manual String Concat

Tüm JSON çıktıları `jsonText &= "..." & q & "..." & q` zincirleriyle yapılıyor.
Bu kaçış hatalarına ve şema bozulmalarına açık.

**Düzeltme — Minimal JSON builder:**

```freebasic
' src/common/json_builder.fbs

Type JsonBuilder
    buf    As String
    indent As Integer
    first  As Integer
End Type

Sub JsonBeginObject(ByRef b As JsonBuilder)
    b.buf &= "{" & Chr(10)
    b.indent += 2
    b.first = 1
End Sub

Sub JsonEndObject(ByRef b As JsonBuilder)
    b.indent -= 2
    b.buf &= Space(b.indent) & "}"
End Sub

Sub JsonStr(ByRef b As JsonBuilder, ByRef key As String, ByRef value As String)
    If b.first = 0 Then b.buf &= "," & Chr(10)
    b.first = 0
    b.buf &= Space(b.indent) & Chr(34) & key & Chr(34) & ": " & Chr(34) & JsonEsc(value) & Chr(34)
End Sub

Sub JsonBool(ByRef b As JsonBuilder, ByRef key As String, ByVal value As Integer)
    If b.first = 0 Then b.buf &= "," & Chr(10)
    b.first = 0
    b.buf &= Space(b.indent) & Chr(34) & key & Chr(34) & ": " & IIf(value, "true", "false")
End Sub

Function JsonEsc(ByRef s As String) As String
    ' " → \", \ → \\, CR/LF → \r \n, TAB → \t
    ' ... mevcut JsonEscape fonksiyonu buraya taşınır
End Function
```

---

## BÖLÜM 2 — CLI Tasarımı

### 2.1 Mevcut CLI'nin Sorunları

1. `HasArg` / `GetArgValue` her çağrıda 64 argümanı doğrusal tarıyor. 40+
   farklı flag için bu fonksiyonlar onlarca kez çağrılıyor.
2. `--help` yok.
3. `@yanıt-dosyası` (response file / options file) desteği yok.
4. Her katman için bireysel `--only-lex`, `--only-parse` vb. bayraklar mevcut
   değil. Katmanlar anahtarlanabilir değil.
5. 3 harfli komut zinciri yok.

### 2.2 CLI Ön-İşleme Katmanı (ArgPreparser)

```freebasic
' src/cli/cli_args.fbs

Type UXBCliArgs
    ' Genel
    sourceFile         As String
    helpRequested      As Integer
    versionRequested   As Integer
    quietMode          As Integer
    traceMode          As Integer
    debugMode          As Integer
    messageLang        As String

    ' Katman kontrolleri
    verb               As String   ' "lex", "par", "sem", "mir", "cod", "run", "bld"
    stopAfterLex       As Integer
    stopAfterParse     As Integer
    stopAfterSemantic  As Integer
    stopAfterMir       As Integer

    ' Çıkış dosyaları
    astJsonOut         As String
    hirJsonOut         As String
    mirJsonOut         As String
    mirVerifyJsonOut   As String
    x64Out             As String
    jsOut              As String
    watOut             As String
    wasmOut            As String
    runReportJsonOut   As String
    logOut             As String

    ' Backend hedef
    targetName         As String   ' "x64", "js", "wasm", "interp"
    buildExe           As Integer

    ' Özellikler
    mirVerify          As Integer
    hookTrace          As Integer
    extfpEnabled       As Integer

    ' @dosyadan okunan ham arg listesi
    rawArgs(0 To 255)  As String
    rawArgCount        As Integer
End Type

' CLI ön-işleme: tüm argümanları ONCE oku
Function UXBCliArgsParse(ByRef args As UXBCliArgs) As Integer
    UXBCliArgsInit args

    ' Önce @dosya argümanlarını genişlet
    Dim i As Integer
    For i = 1 To 128
        Dim a As String = Command(i)
        If a = "" Then Exit For
        If Left(a, 1) = "@" Then
            UXBCliExpandResponseFile Mid(a, 2), args
        Else
            UXBCliRawPush args, a
        End If
    Next i

    ' Şimdi tek geçişte parse et
    Return UXBCliArgsBuild(args)
End Function
```

### 2.3 3 Harfli Komut Zinciri

Biçim: `uxb_main_64.exe <VERB> <KAYNAK> [seçenekler]`

veya: `uxb_main_64.exe <KAYNAK> [seçenekler]` (geriye dönük uyumluluk)

| Verb | Açıklama | Duran adım |
|------|----------|------------|
| `lex` | Yalnızca lexer çalışır | Token listesi |
| `par` | Lexer + Parser | AST |
| `sem` | + Semantik + Type binding | HIR/semboller |
| `mir` | + MIR lowering + MIR verify | MIR modülü |
| `cod` | + Codegen (hedef = --target) | Çıktı dosyaları |
| `run` | + Interpreter execute | Program çıktısı |
| `bld` | Tam pipeline + linker/build | Çalıştırılabilir |
| `chk` | Sadece hata kontrolü, çıktı yok | Hata raporu |
| `fmt` | Kaynak formatla (AST → kaynak yeniden oluştur) | Formatlı kaynak |
| `doc` | Dokümantasyon çıktısı (symbol + tip tablosu) | JSON/MD |
| `dbg` | Debug modunda çalıştır (hook trace açık) | Trace JSON |
| `ver` | Derleyici sürümünü bas | — |
| `hlp` | Yardım ekranı | — |

**İskeleti:**

```freebasic
' src/cli/cli_verb_dispatch.fbs

Function UXBVerbDispatch(ByRef args As UXBCliArgs) As Integer
    Select Case LCase(Trim(args.verb))
    Case "lex":  Return UXBVerbLex(args)
    Case "par":  Return UXBVerbPar(args)
    Case "sem":  Return UXBVerbSem(args)
    Case "mir":  Return UXBVerbMir(args)
    Case "cod":  Return UXBVerbCod(args)
    Case "run":  Return UXBVerbRun(args)
    Case "bld":  Return UXBVerbBld(args)
    Case "chk":  Return UXBVerbChk(args)
    Case "fmt":  Return UXBVerbFmt(args)
    Case "doc":  Return UXBVerbDoc(args)
    Case "dbg":  Return UXBVerbDbg(args)
    Case "ver":  Print UXB_VERSION_STRING: Return 0
    Case "hlp":  Return UXBVerbHlp(args)
    Case Else
        ' Verb yok = eski mod: kaynak dosya doğrudan verilmiş
        Return UXBVerbDefault(args)
    End Select
End Function
```

### 2.4 Her Verb için JSON Çıktı Şeması

Her verb, `--json-out <dosya>` ile standart bir rapor yazar:

```json
{
  "verb": "mir",
  "source": "program.bas",
  "ok": true,
  "stages": {
    "lex":  { "ok": true, "token_count": 142 },
    "par":  { "ok": true, "ast_node_count": 87 },
    "sem":  { "ok": true, "symbol_count": 14 },
    "mir":  { "ok": true, "function_count": 3, "instruction_count": 56 },
    "verify": { "ok": true, "errors": 0, "warnings": 0 }
  },
  "errors": [],
  "outputs": {
    "ast_json":  "dist/program.ast.json",
    "mir_json":  "dist/program.mir.json"
  },
  "timing_ms": {
    "lex": 2,
    "par": 5,
    "sem": 12,
    "mir": 8
  }
}
```

### 2.5 @Yanıt Dosyası (Options File) Desteği

```freebasic
' src/cli/cli_response_file.fbs

Sub UXBCliExpandResponseFile(ByRef filePath As String, ByRef args As UXBCliArgs)
    Dim f As Integer = FreeFile
    Open filePath For Input As #f
    If Err <> 0 Then
        Print "Yanit dosyasi acilamadi: " & filePath
        Exit Sub
    End If
    Do While Not Eof(f)
        Dim lineText As String
        Line Input #f, lineText
        lineText = Trim(lineText)
        If lineText = "" Or Left(lineText, 1) = "#" Then Continue Do   ' boş + yorum
        UXBCliRawPush args, lineText
    Loop
    Close #f
End Sub
```

Kullanım: `uxb mir program.bas @build_flags.txt`

`build_flags.txt` içeriği:
```
--target x64
--mir-json-out dist/program.mir.json
--ast-json-out dist/program.ast.json
--quiet
```

### 2.6 Var Olan Komutlara Ek Öneriler

Diğer derleyicilerde olup uXBasic'te bulunmayan CLI komutları:

| Komut | Eşdeğeri | Açıklama |
|-------|----------|----------|
| `--dump-tokens` | clang `-dump-tokens` | Token listesini JSON/text yaz |
| `--dump-ast` | clang `-ast-dump` | AST'yi hiyerarşik metin olarak yaz |
| `--dump-ir` | LLVM `--print-ir` | MIR'i insan-okunabilir formatta yaz |
| `--dump-asm` | gcc `-S` | x64 NASM'ı bash'a yaz |
| `--target <ad>` | clang `--target` | x64 / js / wasm / interp tek bayrak |
| `--opt <0-3>` | gcc `-O0` `-O3` | Optimizasyon seviyesi |
| `--strict` | — | Tüm uyarıları hata say |
| `--no-stdlib` | gcc `-nostdlib` | Standart kütüphane dahil etme |
| `--emit-tokens` | — | Token JSON dosyası |
| `--emit-ast` | — | AST JSON dosyası |
| `--emit-hir` | — | HIR envanter JSON |
| `--emit-mir` | — | MIR JSON |
| `--emit-nasm` | — | x64 NASM dosyası |
| `--emit-wat` | — | WAT metin dosyası |
| `--emit-js` | — | JavaScript dosyası |
| `--time-passes` | LLVM `--time-passes` | Her adımın süresini bas |
| `--verify-only` | — | Sadece doğrula, üretme |
| `--print-symbol-table` | — | Sembol tablosunu JSON yaz |
| `--print-type-table` | — | Tip tablosunu JSON yaz |
| `--diag-format <text\|json\|vs>` | — | Hata formatı seç |
| `--error-limit <n>` | clang `-ferror-limit` | Maksimum hata sayısı |
| `--warn <ad>` / `--no-warn <ad>` | gcc `-W` | Belirli uyarı aç/kapat |

---

## BÖLÜM 3 — Katmanlar Arası Bağlantı Güçlendirme Planı

### 3.1 Lexer → Parser Köprüsü

Mevcut geçiş zaten doğrudan: `LexerInit` → `LexSource` → `TokenList`.
Eksik: tokenlar `kind As String` kullandığından parser çok fazla string
karşılaştırması yapıyor.

**Adım:** Token.kind → `TokKind` enum (Bölüm 1.1).

### 3.2 Parser → AST Sözleşmesi (ast_contract)

`ast_contract.fbs` mevcut. `--ast-contract-check` flag'i ile çalışıyor.

**Eksik:** Contract check her parse'dan sonra otomatik çalışmıyor; opt-in.

```freebasic
' Düzeltme: ParseProgram sonrasına ekle
If UXBRunAstContractCheck(ps, astContractResult) = 0 Then
    UxbError "AST contract hatasi: " & astContractResult.errorText
    End 1
End If
```

### 3.3 Semantic → MIR Lowering Köprüsü

`semantic_pass.fbs` çalışır ve sembol/tip bilgisini doldurur. Ardından
`mir_lowering.fbs` devreye girer.

**Sorun:** `semantic_pass.fbs` global `Shared` değişkenler kullanıyor. MIR
lowering da `Shared` değişkenler kullanıyor. Bunların sırası çakışabilir.

**Düzeltme — Geçiş nesnesi:**

```freebasic
' src/semantic/semantic_mir_bridge.fbs

Type SemanticMirBridge
    symbolTable   As UXBSymbolTableSnapshot   ' sembol tablosunun anlık görüntüsü
    typeTable     As UXBTypeTableSnapshot
    scopeTree     As UXBScopeTreeSnapshot
    layoutResult  As UXBLayoutResult
End Type

Function UXBSemanticSnapshotForMir(ByRef bridge As SemanticMirBridge) As Integer
    ' Global Shared'den veri kopyala → bridge yapısına
    Return UXBBuildSemanticBridge(bridge)
End Function
```

MIR lowering `ParseState` yerine hem `ParseState` hem `SemanticMirBridge`'i
almalı.

### 3.4 MIR → Codegen Köprüsü

`backend_step6.fbs` doğru şekilde tasarlanmış. Eksik olan bağlantı:
`UXBBackendContext` nasıl doluyor? (Bölüm 1.8'deki `UXBBackendRunPipeline`
iskeletiyle kapanır.)

---

## BÖLÜM 4 — Gerçek Çalışan Bir Derleyici İçin Zorunluluklar

Şu an için eksik olan veya tamamlanması gereken 10 kritik öğe:

### 4.1 ZORUNLU: String karşılaştırmadan integer enum'a geçiş

Token.kind ve ASTNode.nodeKind. Bu yapılmadan her katman yavaşlamaya ve typo
hatalarına açık kalır.

### 4.2 ZORUNLU: Tek kaynaklı sembol tablosu

HIR'daki `SymbolTable` kaldırılmalı veya `UXBStep3Symbol*` API'sine
yönlendirilmeli. İki ayrı tablo derleyicinin doğruluğunu bozar.

### 4.3 ZORUNLU: Tam lexical scope chain çözümlemesi

`UXBStep3SymbolFindLexical` (Bölüm 1.5). Olmadan iç içe fonksiyon değişkenleri
bulunamaz.

### 4.4 ZORUNLU: MIR verify zorunlu kapı

Backend'den önce otomatik çalışmalı. Opt-in değil.

### 4.5 ZORUNLU: Parser hata kurtarma

En az bir sync-to-statement mekanizması. Olmadan tek hata yüzlerce sahte hata
üretir.

### 4.6 ZORUNLU: MIRLocalVar tipli yerel değişken kaydı

`MIRFunction.localVars(Any) As String` → `MIRLocalVar` (Bölüm 1.6). Olmadan
x64 stack frame ve register allocation çalışmaz.

### 4.7 GEREKLİ: CLI ön-işleme ve 3-harfli verb zinciri

`UXBCliArgsParse` + `UXBVerbDispatch` (Bölüm 2). Olmadan araç kullanılamaz
hale gelir.

### 4.8 GEREKLİ: Optimizasyon geçişleri (en az 2 adet)

Gerçek bir derleyici sayılmak için en az şunlar gerekli:
- **Constant folding**: `2 + 3` → `5` MIR seviyesinde
- **Dead code elimination**: ulaşılamayan blokların MIR'dan kaldırılması

```freebasic
' src/semantic/mir_opt_pass.fbs — iskelet

Function UXBMirOptConstFold(ByRef fn As MIRFunction) As Integer
    Dim changed As Integer = 0
    Dim bi As Integer
    For bi = 0 To fn.blockCount - 1
        Dim ii As Integer
        For ii = 0 To fn.blocks(bi).instructionCount - 1
            Dim ins As MIRIRInstruction = fn.blocks(bi).instructions(ii)
            If ins.opcode = "ADD" Then
                If UXBMirIsLiteral(ins.operands(0)) And UXBMirIsLiteral(ins.operands(1)) Then
                    Dim v As LongInt = CLngInt(ins.operands(0)) + CLngInt(ins.operands(1))
                    fn.blocks(bi).instructions(ii).opcode  = "LOAD_INT"
                    fn.blocks(bi).instructions(ii).operands(0) = LTrim(Str(v))
                    fn.blocks(bi).instructions(ii).operandCount = 1
                    changed = 1
                End If
            End If
        Next ii
    Next bi
    Return changed
End Function
```

### 4.9 GEREKLİ: Hata mesajı standardizasyonu

Mevcut hata mesajları bazı yerlerde TR bazı yerlerde EN/TR, bazı yerlerde ham
string. Standart bir format:

```
hata[E001]: satir 42, sutun 7: 'myVar' tanimlanmamis degisken
            --> kaynak.bas:42:7
             |
          42 | Print myVar + 1
             |       ^^^^^^
```

Bu format için `UXBDiagnostic` tipi ve renderer gerekli.

### 4.10 GEREKLİ: Temel test koşum altyapısı

Derleyicinin gerçekten çalıştığını kanıtlamak için en az 20-30 test dosyası:

```
tests/
  basic/
    hello_world.bas          → "Merhaba Dunya"
    arithmetic.bas           → 2+3=5, 10*4=40
    string_ops.bas           → LCase, UCase, Mid
    variables.bas            → Dim, atama, yazdır
    if_else.bas              → dallanma
    for_loop.bas             → sayaç döngü
    while_loop.bas           → koşullu döngü
    functions.bas            → parametre + return
    recursion.bas            → faktöriyel
    classes.bas              → Type/Class + metot
  expected/
    hello_world.expected.txt
    arithmetic.expected.txt
    ...
```

Test koşucusu:
```
uxb run tests/basic/hello_world.bas --json-out dist/result.json
python tools/compare_expected.py dist/result.json tests/expected/hello_world.expected.txt
```

---

## BÖLÜM 5 — Adım Adım Uygulama Planı

Öncelik sırasına göre; her adım bir sonrakinin ön koşulu:

### ADIM A — Temel Veri Yapıları (1-2 hafta)

1. `Token.kind` → `TokKind` enum
2. `ASTNode.nodeKind` → `ASTNodeKind` enum (string korunur, paralel kullanım)
3. `UXBStep3SymbolFind` → `UXBStep3SymbolFindLexical` (tam scope zinciri)
4. Sembol hash tablosu (`SymHashLookup` / `SymHashInsert`)
5. `HIR SymbolTable` deprecate → `UXBStep3Symbol*`'a yönlendir
6. `MIRLocalVar` tipi (isim + tip)

Test: Mevcut smoke testleri bozulmamalı.

### ADIM B — CLI Altyapısı (3-5 gün)

1. `UXBCliArgsParse` — tek geçişli argüman parser
2. `UXBVerbDispatch` — `lex/par/sem/mir/cod/run/bld/chk/hlp/ver`
3. `@yanıt_dosyası` desteği
4. Her verb için JSON rapor şeması
5. `--help` çıktısı

Test: `uxb hlp`, `uxb lex tests/hello.bas --emit-tokens`, `uxb run tests/hello.bas`.

### ADIM C — Zorunlu Kapılar (1 hafta)

1. MIR verify → backend'den önce otomatik
2. AST contract check → parse'dan sonra otomatik
3. Sembol tablosu integrity check → semantic pass sonrası
4. WASM tool path kontrolü → başlangıçta

Test: Kasıtlı MIR hatası içeren dosya → backend çalışmamalı, anlamlı hata.

### ADIM D — Hata Kurtarma (1 hafta)

1. `ParserSyncToStatement` + `ParserError`
2. Semantic pass çoklu hata toplama (tek hata'da dur değil)
3. Hata limiti (`--error-limit`)
4. Standart hata formatı (satır/sütun göstergesi)

Test: 5 sözdizimi hatası olan dosya → 5 hatanın tamamı raporlanmalı.

### ADIM E — Optimizasyon Geçişleri (1 hafta)

1. Constant folding (ADD, SUB, MUL, DIV, CONCAT literal operandlar)
2. Dead block elimination (ulaşılamayan basic block'lar)
3. Simple strength reduction (`x * 2` → `x + x`)
4. `--opt 0` / `--opt 1` / `--opt 2` seviyeleri

Test: `2 + 3` → üretilen NASM'da `5` sabit olmalı, `2 + 3` ADD instruction'ı olmamalı.

### ADIM F — Test Koşum Altyapısı (birkaç gün)

1. `tests/` dizini + 20 temel test dosyası
2. `tests/expected/` beklenen çıktılar
3. `tools/run_test_suite.bat` (tüm testleri çalıştır, karşılaştır)
4. Test raporu JSON

Test: `run_test_suite.bat` → 20/20 geçmeli.

---

## BÖLÜM 6 — Hedef ve Ulaşılabilirlik

### uXBasic'in "gerçek derleyici" sayılabilmesi için minimum çıta:

| Kriter | Mevcut | Gerekli |
|--------|--------|---------|
| Hello World derler ve çalışır | ✓ (interpreter) | ✓ native de olmalı |
| Tam sayı aritmetik | ✓ | ✓ |
| String işlemleri | ✓ | ✓ |
| If/Else/ElseIf | ✓ | ✓ |
| For/While/Do döngüsü | ✓ | ✓ |
| Fonksiyon + recursion | ✓ (kısmi) | ✓ |
| Type/Class + metot çağrısı | kısmi | ✓ |
| Anlamlı hata mesajları | kısmi | ✓ |
| x64 native EXE üretimi | kısmi | ✓ |
| MIR verify zorunlu | ✗ | ✓ |
| Scope chain doğru | ✗ | ✓ |
| Test suite ≥ 20 test | ~ | ✓ |

### Şu an en yakın ulaşılabilir hedef:

**"Interpreter seviyesinde çalışan, x64 NASM yayımlayabilen, anlamlı hata mesajı veren, CLI'si katman bazlı anahtarlanabilir bir derleyici"**

Bu hedefe ulaşmak için Adım A + B + C kesinlikle zorunlu. D + E olmadan da
iddia edilebilir bir "çalışan compiler" sayılır; ancak D olmadan tek hatalı
dosyada kullanılamaz hale gelir.

---

## EK — Hangi Başka Derleyicilerde Var, Bizde Yok

| Özellik | GCC/Clang | Rust | uXBasic |
|---------|-----------|------|---------|
| Enum token kind | ✓ | ✓ | ✗ |
| Hash-tabanlı sembol lookup | ✓ | ✓ | ✗ |
| Lexical scope chain | ✓ | ✓ | ✗ |
| Mandatory IR verify | ✓ (LLVM) | ✓ | ✗ |
| Parser error recovery | ✓ | ✓ | ✗ |
| @response file | ✓ | ✓ | ✗ |
| --dump-tokens / --dump-ast | ✓ | ✓ | kısmi |
| Constant folding | ✓ | ✓ | ✗ |
| Dead code elimination | ✓ | ✓ | ✗ |
| Standart hata formatı | ✓ | ✓ | ✗ |
| Test suite entegrasyonu | ✓ | ✓ | ~ |
| --time-passes | ✓ (LLVM) | ✓ | ✗ |
| --error-limit | ✓ | ✓ | ✗ |
| Optimizasyon seviyeleri (-O0 -O3) | ✓ | ✓ | ✗ |
| Early tool check (wat2wasm vb.) | ✓ | ✓ | ✗ |

---

*Bu doküman uxb_28_05_1_.zip kaynak kodunun tam incelemesine dayanmaktadır.*
*Her iskelet kodu mevcut FreeBasic (.fbs) sözdizimi ile uyumludur.*
