# UXB Dil Yüzeyi Toplu Özeti

Bu dosya tüm özellikleri tek tek uygulama kodu gibi tekrar üretmez; hangi yüzeylerin izlenmesi gerektiğini imalat listesi olarak tutar.

## Komut aileleri

- Akış: IF, THEN, ELSE, ELSEIF, SELECT, CASE, FOR, TO, STEP, NEXT, DO, LOOP, WHILE, WEND, UNTIL, EXIT, RETURN, GOTO, GOSUB.
- Hata: TRY, CATCH, FINALLY, THROW, ASSERT.
- Girdi/çıktı: PRINT, INPUT, OPEN, CLOSE, GET, PUT, SEEK, CLS, COLOR, LOCATE.
- Yordam/çağrı: SUB, FUNCTION, DECLARE, CALL, BYREF, BYVAL, CDECL, STDCALL, INLINE.
- Modül/kaynak: MAIN, INCLUDE, IMPORT, MODULE, NAMESPACE, USING, ALIAS.
- Nesne: TYPE, CLASS, INTERFACE, IMPLEMENTS, METHOD, PROPERTY, OPERATOR, CONSTRUCTOR, DESTRUCTOR, NEW, DELETE, VIRTUAL, OVERRIDE, ABSTRACT, FINAL, SEALED, STATIC, MIXIN, DECORATOR, PUBLIC, PRIVATE, PROTECTED, RESTRICTED, FRIEND, READONLY, MUTABLE, IMMUTABLE, MAGIC.
- Eşzamanlılık: EVENT, THREAD, PARALEL, PIPE, SLOT, ON, OFF, TRIGGER.
- Bellek: PEEKB, PEEKW, PEEKD, POKE, POKEB, POKEW, POKED, POKES, MEMCOPYB, MEMCOPYW, MEMCOPYD, MEMFILLB, MEMFILLW, MEMFILLD, SETNEWOFFSET, INC, DEC.

## Ön-işleyici yüzeyi

Preprocessor yüzeyi kaynak ziplerde ve PCK belgelerinde `%%` meta komutları, hedef seçimi, include, macro, alias, HTML/JS/WAT/CSS payload, FOREACH/ENDFOREACH rezervasyonu ve artifact üretimi olarak geçer. ADIM43 raporunda `%%FOREACH/%%ENDFOREACH gerçek block expansion motoru` ve `Raw JS/WAT/HTML/CSS payload capture` hâlâ manuel takip gerektiren işler olarak görülür.

## Veri tipleri

- Tam sayı: I8, U8, I16, U16, I32, U32, I64, U64.
- Ondalıklı: F32, F64, F80, F128.
- Büyük sayı: BIGI, BIGINT, BIGD, BIGF, BALL.
- Diğer: BOOLEAN, STRING, OBJECT, PTR, STRPTR.
- Çağrı: BYREF, BYVAL, CDECL, STDCALL.

## Veri yapıları

ARRAY, LIST, DICT, SET, TYPE, CLASS, OBJECT. ARRAY derleyici/layout/MIR açısından çekirdektir; LIST/DICT/SET runtime collection ve library davranışı ister.

## Yerel fonksiyonlar

SETSTRINGSIZE, TIMER, LOF, EOF, LEN, MID, STR, VAL, ABS, INT, UCASE, LCASE, ASC, CHR, LTRIM, RTRIM, SPACE, SGN, SQRT, SQR, SIN, COS, TAN, ATN, EXP, LOG, INKEY, GETKEY, VARPTR, SADD, LPTR, CODEPTR, SIZEOF, OFFSETOF, CINT, CLNG, CDBL, CSNG, FIX, RND, RANDOMIZE.

## Operatörler

Sembollü OP yüzeyi, kelime operatörleri ve Logic16 ayrı izlenmelidir. `==`, `**=`, `TRUE/FALSE`, Logic16 son karar paketleriyle kanonikleşmiştir ama kaynakta uygulanma durumu ayrıca gate ile doğrulanmalıdır.

## Kütüphane aileleri

uxcollections, uxmath, uxmathcore, uxstats, uxstats2, uxmatrix, uxtensor, uxdataframe, uxdataset, uxgraph, uxaimath, uxnn, uxnn2, uxnn3, uxonnx, uxonnx2, uxllama, fp80/fp128/bigfp runtime, JSON, regex, HTTP/curl, SQLite, OS, Lua, Prolog, browser, WebGPU, graphics, image, audio, archive, crypto, server, stringx.

## Hedefler

- Interpreter.
- AST/MIR debugging.
- JS transpiler.
- Browser runtime.
- WAT/WASM.
- x64 NASM.
- x86 hedef yüzeyi.
- DLL/API/FFI/native interop.
