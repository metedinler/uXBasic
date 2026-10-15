# Lexer ve Preprocessor Yüzey Şartnamesi

## Lexer yüzeyinde aktif olması gereken ana aileler

Aktif master V2 kaynaklardan çıkarılan keyword listesi `lexer_aktif_keyword_listesi_master_v2.csv` içindedir. Fakat CSV tek başına yeterli değildir; aşağıdaki kararlar esas alınır.

### Kontrol akışı
`IF THEN ELSE ELSEIF END SELECT CASE IS FOR TO STEP NEXT DO LOOP WHILE UNTIL EXIT EACH IN GOTO GOSUB TRY CATCH FINALLY THROW ASSERT`

### Prosedür ve çağrı
`SUB FUNCTION DECLARE RETURN CALL`

### OOP ve modül sistemi
`TYPE CLASS INTERFACE IMPLEMENTS METHOD MAGIC VIRTUAL OVERRIDE CONSTRUCTOR DESTRUCTOR NEW DELETE DIM REDIM AS CONST INCLUDE IMPORT ABSTRACT FINAL SEALED STATIC PROPERTY OPERATOR MIXIN DECORATOR PUBLIC PRIVATE PROTECTED RESTRICTED FRIEND READONLY MUTABLE IMMUTABLE MAIN NAMESPACE MODULE USING ALIAS`

### Event/concurrency/slot hattı
`EVENT THREAD PARALEL PIPE SLOT ON OFF TRIGGER`

Yanlışlar: `THREAT`, `PARALLEL`, `SIHIRLIMETOT`.

### I/O ve console
`PRINT INPUT OPEN CLOSE GET PUT SEEK CLS COLOR LOCATE LOF EOF INKEY GETKEY`

### Operator ve mantık
`AND OR NOT XOR MOD SHL SHR ROL ROR` ve sembolik operator ailesi.

### Tipler
`I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 F128 BIGF BIGD BALL BIGINT BOOLEAN STRING OBJECT PTR STRPTR BYREF BYVAL CDECL STDCALL ANY VARIANT VOID`

### Veri yapıları
`ARRAY LIST DICT SET`

### Builtin fonksiyonlar
`SETSTRINGSIZE TIMER LEN MID STR VAL ABS INT UCASE LCASE ASC CHR LTRIM RTRIM STRING SPACE SGN SQRT SQR SIN COS TAN ATN EXP LOG CINT CLNG CDBL CSNG FIX RND RANDOMIZE VARPTR SADD LPTR CODEPTR SIZEOF OFFSETOF TYPEOF BIGINIT`

### Bellek
`PEEKB PEEKW PEEKD POKE POKEB POKEW POKED POKES MEMCOPYB MEMCOPYW MEMCOPYD MEMFILLB MEMFILLW MEMFILLD SETNEWOFFSET INC DEC`

## Preprocessor yüzeyi

Preprocessor, kaynak dilin ön katmanıdır ve şu işleri yapmalıdır:

- `INCLUDE` dosya ekleme ve döngü tespiti.
- `IMPORT(C/CPP/ASM,...)` kaynak manifest üretimi.
- Meta define/condition/eval/assert.
- Asset ve browser/runtime hedefleri için güvenli kaynak üretimi.
- WAT/WASM import binding manifest.
- Raw JS/WebGPU/host bridge gate.

## Negatif yüzey testleri

Aşağıdakiler sessiz geçmemeli:

- Alias/include cycle.
- Bilinmeyen preprocessor directive.
- Gate olmadan raw JS.
- Asset path escape.
- WAT import binding eksikliği.
- Native DLL/API çağrısının JS/WASM hedefe kaçması.
- `THREAT`, `PARALLEL`, `SIHIRLIMETOT` kullanımı.
