# Runtime, Bellek, Büyük Sayı ve Backend Yolları

uXBasic’in komutları yalnız parser yüzeyinde kalmaz. Dosya, bellek, DLL, API, string, matematik, web, wasm ve x64 gibi hedefler runtime ve backend katmanlarıyla anlam kazanır. Bu bölüm, komutun çalıştığı katmanı açıkça gösterir.

## Dosya kanalı

```basic
OPEN "pack10_io.txt" FOR OUTPUT AS #1
PRINT #1, "101"
PRINT #1, "202"
CLOSE #1

OPEN "pack10_io.txt" FOR INPUT AS #2
DIM a AS I32
DIM b AS I32
INPUT #2, a
INPUT #2, b
CLOSE #2

PRINT a
PRINT b
PRINT a + b
```

Beklenen çıktı:

```text
101
202
303
```

`#` işareti dosya kanalını gösterir. `PRINT #1` ekrana değil, açık dosya kanalına yazar. `INPUT #2` açık dosya kanalından okur.

## Bellek yüzeyi

```basic
DIM addr AS I32 = 1024
POKE addr, 7
POKEB addr, 8
POKEW addr, 9
POKED addr, 10
PRINT PEEKB(addr)
PRINT PEEKW(addr)
PRINT PEEKD(addr)
```

Beklenen çıktı:

```text
8
9
10
```

Bellek komutları sistem programlama yüzeyidir. `POKE`, `POKEB`, `POKEW`, `POKED` yazma ailesini; `PEEKB`, `PEEKW`, `PEEKD` okuma ailesini temsil eder. Bu komutlar kitapta oyuncak örneklerle değil, bellek modeli ve runtime servisiyle birlikte anlatılır.

## Büyük sayı

```basic
PRINT BIGINIT(BIGI, "12345")
PRINT BIGINIT(BIGINT, "23456")
PRINT BIGINIT(BIGD, "12.50")
PRINT BIGINIT(BIGF, "3.5")
PRINT BIGINIT(BALL, "7.1")
```

Beklenen çıktı:

```text
12345
23456
12.50
3.5
7.1
```

`BIGI`, `BIGINT`, `BIGD`, `BIGF` ve `BALL` ailesi geniş duyarlık ve büyük sayı yüzeyidir. Kitapta bu aile yalnız “büyük sayı” diye geçmez; bilimsel hesap, para hassasiyeti, uzun ondalık ve kontrollü çıktı ihtiyacıyla açıklanır.

## Event, thread, pipe ve paralel

```basic
EVENT Tick
    PRINT "EVENT_BODY"
END EVENT

THREAD Worker
    DIM i AS I32
    i = 1
    PRINT i
END THREAD

PIPE DataPipe item AS I32
    PRINT item
END PIPE

PARALEL Grup
    PRINT "PARALEL_BODY"
END PARALEL
```

Doğru keywordler `THREAD`, `PARALEL` ve `MAGIC` biçimindedir. `THREAT`, `PARALLEL` ve `SIHIRLIMETOT` eski/yanlış biçimlerdir ve kitapta yalnız düzeltme notu olarak görünür.

## AST, MIR ve backend

AST kaynak anlamını taşır. MIR hedef üretim omurgasıdır. AST interpreter AST üzerinden çalışır. MIR interpreter MIR üzerinden çalışır. JS, WAT/WASM ve x64 hedefleri MIR seviyesinden destek alır. x64 kod üretimi MIR seviyesindedir; gerektiğinde AST’den kaynak anlamı ve yüksek seviye bilgi alabilir.

```text
Kaynak → Preprocessor → Lexer → Parser → AST → Semantic → MIR → Backend
```

Bu kural kitap boyunca korunur. Backend anlatımı “hepsi AST’den çalışır” gibi yanlış bir düzleştirmeye düşmez.
