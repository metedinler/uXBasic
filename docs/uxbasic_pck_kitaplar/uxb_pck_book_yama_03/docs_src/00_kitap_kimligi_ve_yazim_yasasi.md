# uXBasic Resmî Teknik Kitabı
## 12.06_1 Çalışan Kaynak Baskısı

uXBasic, BASIC dilinin anlaşılır yazım biçimini modern derleyici mimarisiyle birleştiren çok hedefli bir programlama dilidir. Bu dilde amaç yalnızca birkaç komutu çalıştırmak değildir. Amaç; kaynak koddan başlayıp preprocess, lexer, parser, AST, semantic denetim, MIR, runtime servisleri ve hedef kod üretimine kadar uzanan tam bir programlama sistemi kurmaktır.

Bu kitap, uXBasic’in `12.06_1` çalışan kaynak baskısı temel alınarak hazırlanır. Bu baskıda derleme hattı çalışır durumdadır ve `xtestx project packs` testleri başarıyla tamamlanmıştır. Bu nedenle kitapta uXBasic’in dil yüzeyi çalışır kabul edilir. Ancak burada önemli bir ayrım vardır: her özellik aynı katmandan çalışmaz. Bazı özellikler doğrudan AST yorumlayıcı üzerinden yürür, bazıları MIR yorumlayıcıda anlam kazanır, bazıları preprocess aşamasında kaynak kodu dönüştürür, bazıları runtime servislerine bağlanır, bazıları da JS, WAT/WASM veya x64 kod üretim hattında kullanılır.

Bu ayrımı bilmek, uXBasic’i doğru anlamanın anahtarıdır. Çünkü uXBasic yalnızca bir komut listesi değildir. Bir komutun yazılış biçimi kadar, o komutun derleyicinin hangi katmanında temsil edildiği de önemlidir. Örneğin `IF` komutu kaynak kodda karar yapısıdır; parser onu AST düğümüne dönüştürür, semantic katman koşul ifadesini denetler, MIR katmanı dallanma yapısına indirir, yorumlayıcı veya hedef kod üreticisi de bu kararı çalıştırılabilir hale getirir.

Aynı şekilde `PRINT` yalnızca ekrana yazı basan basit bir komut gibi görünür. Fakat derleyici açısından `PRINT`, ifade çözümleme, tip dönüştürme, runtime çıktı servisi ve hedefe göre farklı üretim yolları taşıyan bir komuttur. AST yorumlayıcıda doğrudan çıktı üretirken, MIR hattında runtime çağrısına dönüşebilir; JS hedefinde `console` veya browser çıktısına, x64 hedefinde ise native runtime servis çağrısına bağlanabilir.

Bu kitapta her komut üç düzeyde anlatılır:

```text
1. Programcı bu komutu nasıl yazar?
2. Komut hangi işi yapar?
3. Derleyici ve runtime içinde hangi yoldan çalışır?
```

Bu yaklaşım kitabı sıradan bir komut kataloğundan ayırır. Okuyucu yalnızca `DIM x AS I32` yazmayı öğrenmez; aynı zamanda bu satırın değişken adı, tip bilgisi, kapsam, bellek alanı ve hedef üretim açısından ne anlama geldiğini de kavrar.

uXBasic’in hedef okuyucusu yalnızca hazır komut arayan kullanıcı değildir. Bu kitap, 17–25 yaş aralığında, biraz algoritma bilen, programlamaya meraklı, “bir dil nasıl çalışır?” sorusunu seven genç programcı için de yazılır. Bu yüzden anlatım sade Türkçe ile yapılır; fakat basitlik adına içerik boşaltılmaz. Her bölümde önce fikir verilir, sonra syntax yazılır, sonra çalışan örnek gösterilir, ardından aynı komutun başka komutlarla nasıl birleştiği açıklanır.

Bu kitapta gereksiz tekrar yapılmaz. Tablolarda her satır gerçek bir görev açıklar. “Bu komut özel işlem yapar” gibi kullanıcıya faydası olmayan cümleler kullanılmaz. Bir anahtar kelime varsa, onun görevi, yazım biçimi, birlikte çalıştığı yapılar ve örneği verilir. Bir öneri varsa, hemen altında kodla gösterilir. Bir backend anlatılıyorsa, AST, MIR, runtime ve hedef üretim ilişkisi açıkça belirtilir.

uXBasic’te kaynak kodun genel yolculuğu şöyledir:

```text
Kaynak dosya
    ↓
Preprocessor
    ↓
Lexer
    ↓
Parser
    ↓
AST
    ↓
Semantic denetim
    ↓
HIR / MIR
    ↓
AST Interpreter / MIR Interpreter / JS / WAT-WASM / x64
```

AST, kaynak kodun anlam ağacıdır. Parser kaynak kodu AST’ye çevirir. AST interpreter bu ağaç üzerinden doğrudan çalışabilir. MIR ise hedef üretim omurgasıdır. MIR interpreter MIR üzerinden çalışır. JS, WAT/WASM ve x64 üretim hattı MIR seviyesinden destek alır. x64 kod üretimi MIR seviyesindedir; gerektiğinde AST’den kaynak anlamı ve yüksek seviye bilgi alır.

Bu nedenle kitapta bir özellik anlatılırken “var mı yok mu?” sorusu yerine şu soru sorulur:

```text
Bu özellik hangi katmanda anlam kazanıyor?
```

Örneğin `IMPORT(C, "file.c")` bir DLL çağrısı değildir. Derleme zamanı C kaynağı ekleme yoludur. Buna karşılık `CALL(DLL, ...)` dış DLL fonksiyon rotasını kullanır. `DECLARE ... LIB ... ALIAS ...` ise dış fonksiyonun imzasını tanımlar. Bu üç yapı aynı aileye yakın görünse de görevleri farklıdır. Kitap boyunca bu ayrımlar açık tutulur.

Bu kitap sonunda okuyucu yalnızca uXBasic ile program yazmayı değil, aynı zamanda uXBasic’in nasıl düşündüğünü de öğrenmiş olur. Bir komutun syntaxını görür, örneğini çalıştırır, hangi test ailesinde geçtiğini takip eder, derleyici katmanındaki yerini öğrenir ve gerekirse kendi örneğini genişletebilir.

Bu yüzden bu belge bir not defteri değildir. Bu belge, uXBasic’in resmî teknik kitabıdır.
