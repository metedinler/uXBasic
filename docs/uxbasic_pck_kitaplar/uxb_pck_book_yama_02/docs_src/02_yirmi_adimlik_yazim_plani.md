# 20 Adımlık Kitap Yazım Planı

Bu kitap yirmi adımda yazılır. Her adım bir belge parçası üretir, fakat parçalar birbirinden kopuk değildir. İlk adımlar kitabın yasasını ve kaynak gerçekliğini kurar; orta adımlar dilin komutlarını öğretir; son adımlar backend, yan araçlar, cheat sheet ve kalite kapısını tamamlar.

## 1. Kitap kimliği ve yazım yasası

Kitabın adı, dayandığı kaynak baskısı, okuyucu kitlesi, yazım dili ve tekrar yasağı belirlenir. Bu adımda kitabın “resmî teknik kitap” olduğu yazılır. Dil yüzeyi çalışır kabul edilir; fakat her özelliğin hangi katmandan yürüdüğü açıklanır.

## 2. PCK belgelerini tek kitaba dönüştürme mantığı

Eski PCK belgeleri ham malzeme olarak ayrılır. Tekrar eden cümleler silinir, görev açıklaması olmayan tablo satırları yeniden yazılır, her komut syntax ve örnekle bağlanır.

## 3. Kaynak gerçekliği ve kanıt haritası

`12.06_1` kaynak baskısından lexer keyword listesi, statement registry, AST node listesi, runtime servisleri, CLI seçenekleri, project pack manifesti ve surface coverage tablosu çıkarılır. Kitap, bu kaynak gerçekliğine dayanır.

## 4. İlk programlar ve öğrenme yolu

`PRINT`, `DIM`, `AS`, atama, basit aritmetik ve ilk `IF` örnekleri yazılır. Ama örnekler çocuk oyuncağı gibi bırakılmaz; küçük algoritmalara bağlanır.

## 5. Değişkenler, tipler ve bellekte düşünme

`DIM`, `AS`, `CONST`, `REDIM`, `DEFINT`, `DEFLNG`, `DEFSTR`, `DEFEXT` ailesi anlatılır. Tipler yalnız isim olarak değil, değer taşıma göreviyle açıklanır.

## 6. Operatörler ve ifade kurma

Aritmetik, karşılaştırma, mantık, bit işlemleri, Logic16, atama, pipe ve üçlü koşul operatörleri anlatılır. Öncelik ve parantez örnekle gösterilir.

## 7. Akış kontrolü

`IF`, `ELSEIF`, `ELSE`, `SELECT CASE`, `FOR`, `DO`, `WHILE`, `UNTIL`, `EXIT`, `TRY`, `CATCH`, `FINALLY`, `ASSERT` akıcı biçimde öğretilir.

## 8. Fonksiyonlar, alt programlar ve iç içe çağrı

`FUNCTION`, `SUB`, `RETURN`, `DECLARE`, `BYVAL`, `BYREF`, `CALL` ve rekürsiyon anlatılır. İç içe çağrıların AST ve MIR açısından ne anlama geldiği gösterilir.

## 9. Diziler ve veri yapıları

Dizi, `ARRAY`, `LIST`, `DICT`, `SET` ve indekslenebilir değer mantığı anlatılır. Ölçüm, toplam, arama ve tablo gezme örnekleri verilir.

## 10. TYPE, CLASS, INTERFACE ve MAGIC

`TYPE` veri taşır, `CLASS` veri ve davranış taşır, `INTERFACE` davranış sözleşmesi kurar, `MAGIC` özel nesne davranışı tanımlar. Bu bölüm uXBasic’in modern yüzünü gösterir.

## 11. Namespace, module, include, import ve alias

`NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `INCLUDE`, `IMPORT(C/CPP/ASM)` birlikte öğretilir. `IMPORT` ile `CALL(DLL)` kesin biçimde ayrılır.

## 12. Preprocessor

`%%SET`, `%%DEFINE`, `%%IF`, `%%ELIF`, `%%FOREACH`, `%%TARGET`, `%%HTML_BEGIN`, `%%JS_BEGIN`, `%%WAT_BEGIN`, `%%ASSET_FILE`, `%%MANIFEST_SET` aileleri ayrı bir mini dil gibi anlatılır.

## 13. Dosya, kanal ve giriş/çıkış

`OPEN`, `PRINT #`, `INPUT #`, `CLOSE`, `GET`, `PUT`, `SEEK`, `EOF`, `LOF` ve dosya kanalı mantığı örneklerle gösterilir.

## 14. Runtime servisleri, bellek ve dış dünya

`PEEK`, `POKE`, `MEMCOPY`, `MEMFILL`, `VARPTR`, `SADD`, `CALL(DLL)`, `CALL(API)`, `JSON`, `REGEX`, `HTTP`, `OS`, `LLAMA`, `SQLITE` ve runtime servis katalogları anlatılır.

## 15. Büyük sayı ve geniş duyarlık

`BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `BIGINIT`, `F80`, `F128` ailesi bilimsel ve hassas hesap örnekleriyle anlatılır.

## 16. Event, thread, pipe, paralel ve slot

`EVENT`, `THREAD`, `PIPE`, `PARALEL`, `SLOT`, `ON`, `OFF`, `TRIGGER` ailesi olay ve iş düzeni olarak anlatılır. Doğru keyword kararları burada açıkça yer alır.

## 17. AST, MIR, JS, WAT/WASM ve x64 backend

AST kaynak anlamını, MIR hedef üretim omurgasını taşır. AST interpreter, MIR interpreter, JS, WAT/WASM ve x64 arasındaki ilişki doğru biçimde anlatılır.

## 18. CLI, build ve test sistemi

`build_64.bat`, `run_xtestx_project_packs.py`, expected test runnerları, JSON çıktı seçenekleri ve rapor klasörleri anlatılır.

## 19. Cheat sheet ve hızlı başvuru ekleri

Komutlar, fonksiyonlar, operatörler, veri tipleri, preprocess komutları, CLI seçenekleri, backend hedefleri ve yanlış keyword düzeltmeleri kısa tablolara ayrılır.

## 20. Kitap üretim hattı ve kalite kapısı

`docs_src` içindeki parçalar tek kitap dosyasına birleştirilir. Üretilen kitap tekrar, boş cümle, syntax eksikliği, örnek eksikliği ve kaynak uyumsuzluğu açısından kontrol edilir.
