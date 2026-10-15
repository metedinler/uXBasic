# UXB Ana İmalat Karar Defteri

Bu dosya, uXBasic’in imalatında bilinmesi gereken ana kararları toparlar. Buradaki amaç kitap yazmak değil, derleyici üretiminde karar kaybını engellemektir.

## A. Dil kimliği

uXBasic, BASIC kökenli, sistem programlama hedefli, dış kütüphane çağırabilen, JS/WASM/x64/x86 çıktıları hedefleyen, runtime servis kataloğu ve full surface parity hedefi olan bir dildir. Temel felsefe: çekirdek komut sayısı kontrollü kalır; genişleme `CALL`, `DECLARE`, `DLL`, `API`, `NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `INCLUDE`, `IMPORT(C/CPP/ASM,...)` ve kütüphane runtime servisleriyle yapılır.

## B. Full Surface Parity kararı

Lexer yüzeyindeki her öğenin yaşam döngüsü zorunludur. Bu yaşam döngüsü şudur:

1. Lexer tanır.
2. Parser doğru node veya ifade üretir.
3. AST sözleşmesinde yeri vardır.
4. Semantic/type katmanı anlam ve tip kararını verir.
5. MIR gerekliyse opcode veya runtime call’a indirir.
6. AST interpreter ve/veya MIR interpreter davranışı bilir.
7. Runtime servis veya backend hedefi bunu uygular.
8. Hedef desteklemiyorsa açık diagnostic verir.
9. Test/gate bu davranışı doğrular.
10. PCK/LLM belgesi davranışı anlatır.

## C. Operatör kararları

- `=`: statement başında lvalue varsa atama; koşul/ifade içinde BASIC uyumlu eşitlik karşılaştırması.
- `==`: modern açık eşitlik karşılaştırması; lexer’da tek OP token olmalıdır.
- `**`: üs alma.
- `**=`: üs alarak atama.
- `^`: XOR / bit özel veya.
- `^=`: XOR ile atama.
- `&`: bit AND. String birleştirme için `&` kullanılacaksa ayrıca açık karar gerekir; x64 tarafında rastgele STR_CONCAT eşlemesi yapılmamalıdır.
- `|`: bit OR.
- `|>`: boru/pipeline işleci.
- `? :`: üçlü koşul.
- `OPERATOR`: sınıf içinde operatör davranışı tanımlama anahtar sözcüğüdür; hesap operatörü değildir.

## D. TRUE/FALSE ve Logic16

`TRUE` ve `FALSE` normal uXBasic kaynakta boolean literal olmalıdır.

Resmi Logic16 adları:

`FALSE, AND, NIMP, IDA, NCIMP, IDB, XOR, OR, NOR, XNOR, NOTB, CIMP, NOTA, IMP, NAND, TRUE`

Eş adlar:

- `ZERO -> FALSE`
- `ONE -> TRUE`
- `NXOR / EQV / EQA / IFF -> XNOR`

`ID_A`, `ID_B`, `NOT_A`, `NOT_B` kullanılmayacak; resmi kısa yazım `IDA`, `IDB`, `NOTA`, `NOTB` olacaktır.

## E. Kanonik anahtar kararları

- `THREAD` doğrudur; `THREAT` yanlıştır.
- `PARALEL` doğrudur; `PARALLEL` kullanılmayacak.
- `MAGIC` doğrudur; `SIHIRLIMETOT` kullanılmayacak.
- Sihirli yöntemler `<. ... .>` biçimiyle düşünülür ve yeni sihirli yöntem tanımı `MAGIC` ile yapılır.
- `INKEY` ve `GETKEY` ikisi de tek karakter alır; `INKEY` anlık/sürekli yoklama, `GETKEY` tuşa basılmasını bekleme davranışı taşımalıdır.

## F. IMPORT kararı

`IMPORT` yalnız derleme zamanı kaynak ekleme için kullanılacaktır:

- `IMPORT(C,"file.c")`
- `IMPORT(CPP,"file.cpp")`
- `IMPORT(ASM,"file.asm")`

`IMPORT DLL`, `IMPORT API`, `IMPORT LIB` aktif dil yüzeyi olmayacak. DLL/API çağrısı `DECLARE ... LIB ... ALIAS ...`, `CALL(DLL,...)`, `CALL(API,...)` üzerinden yürür.

## G. CLI kararları

Türkçe CLI seçenekleri aktif yüzeyde olmayacak:

- `--ayikla` yerine `--debug`
- `--sessiz` yerine `--quiet`
- `--semantik` yerine `--semantic`

Legacy olarak yakalanırsa açık hata ve öneri verilir. Public help ve kitapta aktif seçenek gibi sunulmaz.

## H. Test ve çıktı kararı

Her `*-out` çıktısı gerçek dosya üretmelidir. Boş, bozuk JSON veya placeholder olamaz. Test runner eksik çıktıyı uyduramaz.

## I. Kütüphane kararı

Kütüphaneler `src` içinde olmak zorunda değildir; fakat `src` içindeki runtime servis kataloğu, library route registry ve interop manifest gerçek kütüphane paketleriyle bağlanmalıdır. Her kütüphane için build log, DLL varlığı, header varlığı, smoke test, uXBasic örneği ve runtime report tutulmalıdır.

## J. LLM eğitimi kararı

LLM eğitimi için en değerli veri: `program.uxb + stdout + stderr + tokens.json + ast.json + mir.json + run_report.json` zinciridir. PCK kitapları RAG ve kütüphane hafızası için kullanılacak; derleyici çıktıları gerçek davranış verisi olacaktır.
