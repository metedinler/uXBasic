# UXB İptal, Reddedilen ve Yanlış Karar Defteri

Bu dosya, tekrar ortaya çıkıp sistemi bozmasın diye istenmeyen kararları tutar.

## Aktif dil yüzeyine alınmayacaklar

- `IMPORT DLL`, `IMPORT API`, `IMPORT LIB` aktif dil yüzeyi olmayacak.
- DLL/API çağrısı `DECLARE ... LIB ... ALIAS ...`, `CALL(DLL,...)`, `CALL(API,...)` ile yapılacak.
- Türkçe CLI seçenekleri aktif olmayacak: `--ayikla`, `--sessiz`, `--semantik`.
- `THREAT` doğru anahtar değildir; `THREAD` kullanılacak.
- `PARALLEL` doğru anahtar değildir; `PARALEL` kullanılacak.
- `SIHIRLIMETOT` doğru anahtar değildir; `MAGIC` kullanılacak.
- `ID_A`, `ID_B`, `NOT_A`, `NOT_B` resmi Logic16 yazımı değildir; `IDA`, `IDB`, `NOTA`, `NOTB` kullanılacak.
- Test runner eksik artifact üretmeyecek.
- Placeholder/dummy/TODO ile PASS yasaktır.
- Hook core davranışı değiştirmek için kullanılmayacak; izleme/genişletme için kullanılacak.

## Dikkat gerektiren kararlar

- `=` BASIC uyumu için koşul içinde karşılaştırma olmalıdır; yalnız `==` kullanmaya zorlamak doğru değildir.
- `^` anlamı net olmalıdır: XOR. Üs alma `**` ile yapılır.
- `&` bit AND olarak kalmalıdır; string concat ile çakışma yaratılmamalıdır veya concat için ayrı açık karar verilmelidir.
- `TRUE/FALSE` normal boolean literal olmalıdır.
