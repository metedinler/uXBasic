<!-- Bu dosya tools/docs/build_uxbasic_pck_book.py ile üretildi. Kaynak parçalar docs_src içindedir. -->

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

---

# Kaynak Belgelerin Tek Kitaba Dönüşme Mantığı

uXBasic kitabı, birbirinden kopuk notların yan yana dizilmesiyle oluşmaz. Böyle yapılırsa ortaya büyük görünen ama okuyucuya yön göstermeyen bir metin çıkar. Bir bölüm aynı komutu üç defa anlatır, başka bir bölüm aynı sözdizimini farklı kelimelerle tekrar eder, tablolar birbirine benzer cümlelerle dolar ve okuyucu “bu bilgi bana ne yaptırıyor?” sorusunun cevabını bulamaz. Bu yüzden bu kitapta eski PCK belgeleri ham malzeme kabul edilir; son kitap ise bu malzemenin temizlenmiş, sıralanmış, kaynak kod gerçekliğiyle uyumlu ve öğretici hâlidir.

Eski PCK belgeleri önemli bir birikim taşır. Bu belgelerde uXBasic’in komutları, anahtar kelimeleri, veri tipleri, ön-işleyici yapısı, kütüphaneleri, çalışma zamanı servisleri, web hedefleri, yapay zekâ eğitim planı ve derleyici mimarisi üzerine birçok doğru fikir bulunur. Fakat bu belgeler farklı zamanlarda, farklı kaynak sürümlerine göre ve farklı amaçlarla yazılmıştır. Bu yüzden son kitap hazırlanırken her paragraf yeniden tartılır: Bu bilgi hâlâ geçerli mi? Kaynak kodla uyumlu mu? Okuyucuya doğrudan bir şey öğretiyor mu? Kod örneğiyle gösterilebiliyor mu? Aynı bilgi başka yerde daha iyi anlatılmış mı?

Kitaba alınacak bilgi yalnızca anlamlı olduğu için alınmaz; kullanılabilir olduğu için alınır. Bir cümle doğru olabilir ama kullanıcıya bir komutun nasıl yazılacağını, neyle birlikte kullanılacağını veya hangi hatadan kaçınacağını göstermiyorsa kitapta merkezî yer tutmaz. uXBasic kitabında her bilgi, programcının elini güçlendirmelidir. Okuyucu bir tabloya baktığında yalnızca komut adını değil, o komutun görevini, sözdizimini, hangi komutlarla birleştiğini ve en küçük çalışan örneğini görebilmelidir.

Bu kitap hazırlanırken eski PCK belgeleri şu işleme girer:

```text
Eski PCK bölümü
    ↓
Başlıklarına ayrılır
    ↓
Tekrar eden parçaları ayıklanır
    ↓
12.06_1 kaynak yüzeyiyle karşılaştırılır
    ↓
Komut, fonksiyon, tip, operatör, preprocess veya backend ailesine bağlanır
    ↓
Örnek kodla desteklenir
    ↓
Tek kitap akışına yerleştirilir
```

Bu işlem, eski belgeleri değersizleştirmez. Tam tersine, onları işe yarar hâle getirir. Dağınık bilgi tek bir öğrenme yoluna bağlandığında kitap güçlenir. Okuyucu önce temel komutları, sonra ifadeleri, sonra karar yapılarını, sonra döngüleri, sonra fonksiyonları, sonra veri yapılarını, sonra dış bağlantıları ve en sonunda derleyici hedeflerini öğrenir. Böylece uXBasic bir komut yığını değil, bir düşünme sistemi olarak görünür.

Kitapta tekrarın yasak olması, aynı kavramın bir daha görünmeyeceği anlamına gelmez. Bir kavram farklı bağlamlarda yeniden görülebilir; fakat her gelişinde yeni bir iş yapmalıdır. `DIM` önce değişken tanımlarken anlatılır. Dizi bölümünde `DIM sicaklik(10) AS I32` biçiminde yeniden görünür. `TYPE` bölümünde `DIM p AS Nokta` olarak başka bir görev üstlenir. Fonksiyon bölümünde yerel değişken kurmak için kullanılır. Böylece aynı komut tekrar edilmez; büyütülür.

Bu kitabın tablo anlayışı da bu kurala bağlıdır. Tablolar doldurma alanı değildir. Her tablo satırı bir görev taşımalıdır. Bir anahtar kelime tablosunda her satırda en az dört bilgi bulunur: sözcüğün adı, yazım biçimi, gerçek görevi ve birlikte çalıştığı yapılar. Gerektiğinde beşinci sütun olarak kısa örnek eklenir. Böylece tablo yalnızca liste değil, hızlı öğrenme aracıdır.

| Sözcük | Syntax | Görev | Birlikte Kullanıldığı Yapılar |
|---|---|---|---|
| `DIM` | `DIM ad AS tip` | Bellekte isimli değişken, dizi veya nesne alanı açar; ad ile tipi birbirine bağlar. | `AS`, `CONST`, `REDIM`, `TYPE`, `CLASS` |
| `IF` | `IF koşul THEN ... END IF` | Koşulu değerlendirir; doğruysa ana kolu, yanlışsa `ELSEIF` veya `ELSE` kolunu çalıştırır. | `THEN`, `ELSEIF`, `ELSE`, `END IF`, karşılaştırma operatörleri |
| `FOR` | `FOR i = başlangıç TO bitiş STEP adım` | Sayısal sayaçla tekrar eden işlem kurar; `NEXT` satırında sayaç ilerletilir. | `TO`, `STEP`, `NEXT`, diziler, toplam alma |
| `FUNCTION` | `FUNCTION ad(...) AS tip ... END FUNCTION` | Girdi alıp değer döndüren adlandırılmış işlem bloğu kurar. | `RETURN`, `AS`, `BYVAL`, `BYREF`, iç içe çağrı |
| `IMPORT` | `IMPORT(C, "file.c")` | C, CPP veya ASM kaynak dosyasını derleme zamanı projeye ekler. DLL veya API çağırmaz. | `C`, `CPP`, `ASM`, build hattı |
| `CALL(DLL)` | `CALL(DLL, "lib", "fn", ...)` | Dış DLL fonksiyon çağrısı için runtime rotası kurar. | `DECLARE LIB ALIAS`, `BYVAL`, `CDECL`, `STDCALL` |

Eski PCK belgelerindeki iyi örnekler korunur, fakat örneğin amacı belirsizse geliştirilir. Kitapta örnek, komutun arkasından gelen süs değildir. Örnek, anlatının kanıtıdır. Her örnek bir fikir taşır, mümkünse beklenen çıktısıyla birlikte verilir ve bir sonraki örneğe köprü kurar.

Kitabın yazımında özellikle şu temizlik kuralları uygulanır:

```text
Aynı komut aynı görevle tekrar anlatılmaz.
Tablo satırları aynı cümle kalıbıyla doldurulmaz.
Syntax verilmeyen komut ana açıklama sayılmaz.
Kod örneği olmayan öneri eksik sayılır.
Beklenen çıktı verilebilen örnekte çıktı mutlaka yazılır.
Kaynak kodla uyumsuz eski karar kitaba ana bilgi olarak girmez.
Yanlış keywordler yalnız düzeltme notu olarak görünür.
IMPORT, CALL ve DECLARE birbirine karıştırılmaz.
AST, MIR, runtime ve backend aynı şeymiş gibi anlatılmaz.
```

Bu kurallar kitabın dilini sıkı tutar. Amaç metni kısaltmak değil, faydasız cümleyi silip yerine çalışan bilgi koymaktır. Bir paragraf uzun olabilir; fakat uzunluğu anlam taşımalıdır. Bir tablo büyük olabilir; fakat her satırı görev açıklamalıdır. Bir örnek birkaç satırdan oluşabilir; fakat sonunda okuyucuya yeni bir düşünme biçimi kazandırmalıdır.

---

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

---

# Kaynak Gerçekliği ve Kanıt Haritası

Bu kitap `12.06_1` çalışan kaynak baskısını esas alır. Kitapta bir özellik “çalışmıyor” diliyle anlatılmaz; özellik hangi katmanda yürüyorsa o katman yazılır. Bu yaklaşım hem dili sahiplenir hem de teknik dürüstlüğü korur. Bir komut AST yorumlayıcıda, başka bir komut MIR yorumlayıcıda, başka bir hedef JS/WAT/WASM veya x64 üretiminde anlam kazanabilir.

## Kaynak yüzeyi özeti

| Alan | Gözlenen sayı | Kaynak dosya |
|---|---:|---|
| Benzersiz lexer keyword / yüzey sözcüğü | 220 | `src/parser/lexer/lexer_keyword_table.fbs` |
| Statement dispatch girişi | 79 | `src/parser/parser/parser_stmt_registry.fbs` |
| AST node sabiti | 142 | `src/parser/ast_node_kinds.fbs` |
| Runtime service ID | 83 | `src/runtime/services/runtime_service_ids.fbs` |
| CLI seçenek adı | 167 | `src/cli/cli_registry_adim41.fbs` |
| Project pack | 30 | `xtestx/project_packs/_expected/project_pack_manifest.json` |

Bu tablo kitabın ana sınırını çizer. Kitaptaki anahtar kelime, komut, veri tipi, runtime servisi ve CLI anlatımı bu dosyalarla uyumlu tutulur. Eski PCK belgelerinde geçen ama bu kaynak baskısının kanonik kararlarıyla çelişen bilgi ana gövdeye alınmaz.

## Project pack sonucu

`xtestx/project_packs` hattı kitabın çalışan örnek omurgasıdır. Bu paketler yalnız test değil, aynı zamanda kitap için örnek deposudur. Her büyük bölümde mümkün olduğunca bu paketlerden bir örnek alınır, gerekirse büyütülür ve açıklanır.

| Pack | Faz | Görev | Yüzey etiketleri | Beklenen çıktı başlangıcı |
|---|---|---|---|---|
| `pack_01_core_numeric_flow` | `run` | Çekirdek sayısal akış: DIM, AS, atama, aritmetik, PRINT. | `core, numeric, dim, assignment, print` | `30, 35, 70, 55, ...` |
| `pack_02_operators_logic_bit` | `run` | Operatör önceliği ve bit düzeyi işleçler. | `operators, mod, and, or, xor, shl, shr` | `22, 34, 2, 4, ...` |
| `pack_03_strings_builtins` | `run` | Kanonik string fonksiyonları; $ suffix yok. | `strings, len, left, mid, right, lcase, trim, chr, asc` | `7, UXB, XBA, IC, ...` |
| `pack_04_arrays_index_lvalue` | `run` | Dizi indeksleme ve lvalue ataması. | `array, index, lvalue` | `3, 8, 16` |
| `pack_05_control_flow_if_for` | `run` | Kontrol akışı: FOR/NEXT, IF/ELSE, DO WHILE/LOOP. | `if, for, do, while, loop` | `15, BUYUK, 0, 1, ...` |
| `pack_06_functions_recursion_include` | `run` | Fonksiyon, RETURN ve rekürsiyon. | `function, return, recursion` | `15, 120` |
| `pack_07_type_record_structures` | `run` | TYPE kaydı ve alan erişimi. | `type, record, field` | `42, 18` |
| `pack_08_namespace_using_alias` | `run` | NAMESPACE, USING ve ALIAS çağrı çözümleme. | `namespace, using, alias, function` | `30, 15` |
| `pack_09_class_oop_magic` | `ast` | MAGIC HASH ve custom MAGIC parser/AST yüzeyi. Runtime doğal dispatch Fix-14 sonrası ayrıca test edilecek. | `class, magic, hash, custom-magic, operator-magic` | `` |
| `pack_10_file_io_channels` | `run` | # yalnız file I/O kanal numarasıdır; LINE INPUT ve $ yok. | `open, print-file, input-file, close, #-channel` | `101, 202, 303` |
| `pack_11_preprocessor_meta` | `run` | Temel preprocessor meta komutları. | `preprocessor, set, define, eval, if` | `META_ON, 20, UXB` |
| `pack_12_preprocessor_include_foreach` | `run` | INCLUDE .uxbh başlık kullanımı; foreach iddiası yok. | `include, uxbh, const, function` | `42, 12` |
| `pack_13_import_c_cpp_asm` | `ast` | IMPORT yalnız C/CPP/ASM derleme zamanı kaynak rotasıdır; DLL/API değildir. | `import, c, cpp, asm` | `` |
| `pack_14_ffi_winapi_routes` | `run` | CALL(DLL,...) route smoke; gerçek DLL yükleme değil. | `declare, lib, alias, call-dll, ffi-route` | `FFI14_01, FFI14_02, FFI14_03, FFI14_04, ...` |
| `pack_15_science_external_routes` | `ast` | CALL(API,...) parser/AST yüzeyi; runtime servis davranışı ayrı test edilecek. | `call-api, json, regex, library-route` | `` |
| `pack_16_big_extfp_canonical` | `run` | Büyük sayı ailesi yüzeyi. | `biginit, bigi, bigint, bigd, bigf, ball` | `12345, 23456, 12.50, 3.5, ...` |
| `pack_17_memory_ptr_intrinsics` | `ast` | Bellek intrinsics parser/AST yüzeyi; güvenli runtime davranışı Fix sonrası ayrı test. | `poke, peek, memory` | `` |
| `pack_18_event_thread_pipe_slot` | `ast` | EVENT/THREAD/PIPE/PARALEL bloklarında normal uXBasic gövde parse edilir; runtime dispatch ayrı. | `event, thread, pipe, paralel, slot, trigger` | `` |
| `pack_19_browser_wasm_webgpu_route` | `run` | WEB/BROWSER/JS hedefinde RUNTIME JS bloğu serbesttir; raw hedefsiz JS negatifte kalır. | `target-web, html-begin, js-begin-runtime, browser` | `WEB_ROUTE, WASM_READY` |
| `pack_20_module_main_using` | `ast` | MODULE ve MAIN parser/AST yüzeyi. | `module, main, using, function` | `` |
| `pack_21_input_line_file` | `run` | LINE INPUT ve $ yok; kanonik INPUT # kanal testi. | `input-file, print-file, #-channel` | `165` |
| `pack_22_error_try_catch_surface` | `ast` | TRY/CATCH/FINALLY parser yüzeyi. | `try, catch, finally` | `` |
| `pack_23_data_structures_list_dict_set` | `ast` | Veri yapısı tip adları yüzeyi; runtime koleksiyon API ayrı. | `array-type, list, dict, set` | `` |
| `pack_24_math_time_random_surface` | `run` | Deterministik matematik fonksiyonları; TIMER/RND exact stdout testine konmadı. | `abs, int, sgn, sqr` | `9, 12, -1, 0, ...` |
| `pack_25_nested_calls_expressions` | `run` | İç içe fonksiyon çağrıları ve ifade değerlendirme. | `nested-calls, function, expression` | `15, 21, 3` |
| `pack_26_negative_raw_js_gate` | `run` | TARGET WEB/BROWSER/JS olmadan raw JS fail-close kalmalıdır. | `negative, raw-js-gate` | `` |
| `pack_27_negative_include_cycle` | `preprocess` | INCLUDE döngüsü hata vermelidir. | `negative, include-cycle` | `` |
| `pack_28_negative_semantic_unknown_symbol` | `semantic` | Bilinmeyen sembol hata vermelidir. | `negative, semantic, unknown-symbol` | `` |
| `pack_29_negative_wrong_keywords` | `ast` | Yanlış keywordler reddedilir: THREAT, PARALLEL, SIHIRLIMETOT. | `negative, wrong-keyword, thread, paralel, magic` | `` |
| `pack_30_full_integration_project` | `run` | Çalışan katmanlardan kanonik entegrasyon smoke testi. | `full, integration, preprocessor, include, import, type, array, string, big, namespace, alias` | `900, 30, 103, 15, ...` |

## Kanıt seviyesinin kitap dili

Bu kitapta “şu özellik yok” dili kullanılmaz. Bunun yerine şu katman dili kullanılır:

| Katman | Kitaptaki anlamı |
|---|---|
| Preprocess | Kaynak kod derleyiciye gitmeden önce dönüştürülür, koşullu bloklar ve hedef dosyalar hazırlanır. |
| Lexer | Sözcükler token yüzeyinde tanınır. Keyword, operatör ve literal sınırları bu katmanda belirlenir. |
| Parser / AST | Kaynak sözdizimi AST düğümlerine dönüşür. Komutun kaynak anlamı burada taşınır. |
| Semantic | Tip, sembol, kapsam, çağrı ve hata kapıları denetlenir. |
| MIR | Kod üretimi ve hedefe indirme için daha düz ara temsil kurulur. |
| AST Interpreter | AST üzerinden doğrudan çalışma yoludur. |
| MIR Interpreter | MIR üzerinden çalışma yoludur. |
| Runtime | Dosya, bellek, DLL, API, string, matematik, web ve dış sistem çağrıları servisleştirilir. |
| JS / WAT / WASM / x64 | MIR destekli hedef üretim hatlarıdır. x64 üretim MIR seviyesindedir; AST’den destek alabilir. |

Bu dil, kitabı hem güvenli hem de sahiplenen bir teknik metin yapar. Özellik çalışır kabul edilir; ancak hangi yoldan çalıştığı açıkça yazılır.

---

# Komut Yazım Şablonu ve Tablo Yasası

uXBasic kitabında her komut aynı kalıpla ezberletilmez; fakat her komut aynı ciddiyetle açıklanır. Okuyucu bir komut sayfasına baktığında dört şeyi hemen görmelidir: komutun görevi, yazım biçimi, küçük örneği ve hangi yapılarla birlikte kullanıldığı.

Her komut için ana şablon şöyledir:

```text
Komut adı
Görev
Syntax
Parametreler
Temel örnek
Beklenen çıktı
Birlikte kullanıldığı komutlar
Gelişmiş örnek
Derleyici katmanı
İlgili test veya project pack
```

Bu şablon bir bürokrasi değildir. Şablon, kitabı tekrar eden boş cümlelerden korur. Bir komutun syntaxı yoksa okuyucu yazamaz. Örneği yoksa deneyemez. Beklenen çıktısı yoksa sonucu anlayamaz. Katmanı yoksa derleyicinin hangi yolundan geçtiğini göremez.

## Örnek komut sayfası: DIM

`DIM`, bellekte isimli değişken, dizi veya nesne alanı açar. `AS` ile birlikte kullanıldığında değişkenin tipi açıkça belirtilir. Bu sayede semantic katman değişkenin hangi tür değer taşıyacağını bilir; runtime veya backend tarafı da bu bilgiye göre alan ve işlem seçer.

Syntax:

```basic
DIM ad AS tip
DIM ad AS tip = ilkDeger
DIM ad(boyut) AS tip
```

Temel örnek:

```basic
DIM yas AS I32 = 20
PRINT yas
```

Beklenen çıktı:

```text
20
```

Dizi örneği:

```basic
DIM puan(3) AS I32
puan(1) = 10
puan(2) = 20
puan(3) = puan(1) + puan(2)
PRINT puan(3)
```

Beklenen çıktı:

```text
30
```

`DIM`, `AS`, `CONST`, `REDIM`, `TYPE`, `CLASS`, `ARRAY`, `LIST`, `DICT` ve `SET` ile aynı öğrenme ailesindedir. Bu komut anlatıldıktan sonra tipler, diziler ve kayıtlar daha kolay anlaşılır.

## Tablo yasası

Tablo satırları birbirinin kopyası gibi yazılmaz. Her satır komutun gerçek görevini açıklar.

Kötü tablo dili:

| Komut | Açıklama |
|---|---|
| `IF` | Koşul için kullanılır. |
| `FOR` | Döngü için kullanılır. |
| `FUNCTION` | Fonksiyon için kullanılır. |

Bu tablo doğru gibi görünür ama okuyucuya neredeyse hiçbir şey öğretmez.

İyi tablo dili:

| Komut | Syntax | Görev | Birlikte Kullanılır |
|---|---|---|---|
| `IF` | `IF koşul THEN ... END IF` | Koşulu değerlendirir ve program akışını doğru/yanlış kollarına ayırır. | `THEN`, `ELSEIF`, `ELSE`, `END IF` |
| `FOR` | `FOR i = ilk TO son STEP adım` | Sayısal sayaçla tekrarlı işlem kurar; `NEXT` satırında sayaç ilerler. | `TO`, `STEP`, `NEXT`, diziler |
| `FUNCTION` | `FUNCTION ad(...) AS tip ... END FUNCTION` | Parametre alıp değer döndüren adlandırılmış işlem bloğu kurar. | `RETURN`, `AS`, `BYVAL`, `BYREF` |

Bu ikinci tabloda her satır farklı bir bilgi verir. Kitap boyunca kullanılacak tablo dili budur.

---

# İlk Programlar ve Öğrenme Yolu

uXBasic öğrenmeye `PRINT` ile başlamak doğrudur; fakat `PRINT` yalnızca ekrana yazı basmak değildir. Bir dilin ilk komutu, kaynak koddan çıktı üretimine giden hattı gösterir. Programcı bir satır yazar, lexer bu satırı tokenlara ayırır, parser `PRINT_STMT` benzeri bir AST düğümü kurar, ifade çözülür ve runtime çıktı servisi değeri görünür hale getirir.

```basic
PRINT "uXBasic calisiyor"
```

Beklenen çıktı:

```text
uXBasic calisiyor
```

Bu ilk örnek bilinçli olarak küçüktür. Şimdi aynı yolu değişkenle genişletelim.

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
DIM c AS I32 = a + b
PRINT c
```

Beklenen çıktı:

```text
30
```

Bu kodda `DIM` bellek alanı açar, `AS` tipi bağlar, `I32` değerin 32 bit işaretli tam sayı olduğunu bildirir, `=` başlangıç değeri verir, `+` iki değeri toplar ve `PRINT` sonucu yazar. Tek bir küçük örnek içinde değişken, tip, atama, ifade ve çıktı birlikte görünür.

Project pack omurgasındaki ilk paket bu fikri biraz daha büyütür:

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
DIM c AS I32 = a + b
PRINT c
c = c + 5
PRINT c
c = c * 2
PRINT c
PRINT c - 15
PRINT (a + b) * 3
```

Beklenen çıktı:

```text
30
35
70
55
90
```

Bu örnek, değişkenin yalnız bir kez değer alan kutu olmadığını gösterir. `c` önce `a + b` değerini alır, sonra üstüne 5 eklenir, sonra ikiyle çarpılır. Programın akışı, değişkenin zaman içinde değişmesiyle izlenebilir hale gelir. Genç bir programcı için önemli fikir budur: program, satırların sırayla çalışması değil, değerlerin zaman içinde dönüşmesidir.

Bir sonraki adımda karar eklenir:

```basic
DIM sicaklik AS I32 = 24

IF sicaklik > 22 THEN
    PRINT "Havalandirma ac"
ELSE
    PRINT "Normal"
END IF
```

Beklenen çıktı:

```text
Havalandirma ac
```

Bu örnek yalnız bir `IF` göstermez. Ölçüm değeri alınır, eşik değeriyle karşılaştırılır ve program akışı iki kola ayrılır. `IF` burada gerçek bir kontrol düzeneğidir. İleride aynı fikir dizi, döngü ve fonksiyonla birleştiğinde küçük bir izleme sistemi kurulabilir.

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 24
sicaklik(3) = 21

DIM i AS I32
FOR i = 1 TO 3
    IF sicaklik(i) > 22 THEN
        PRINT "Yuksek"
    ELSE
        PRINT "Uygun"
    END IF
NEXT i
```

Beklenen çıktı:

```text
Uygun
Yuksek
Uygun
```

Bu programda `DIM`, dizi, indeks, `FOR`, `IF`, karşılaştırma ve `PRINT` aynı amaca bağlanır. Kitabın yöntemi budur: komutlar tek tek tanıtılır ama tek başına bırakılmaz. Her komut, kendinden önce öğrenilen komutlarla birleşerek daha akıllı bir programa dönüşür.

---

# Operatörler ve İfade Kurma

Operatör, değerleri birbirine bağlayan küçük ama güçlü bir araçtır. `a + b` yalnız iki sayının toplamı değildir; AST içinde ikili ifade düğümü, MIR içinde işlem adımı, backend tarafında hedefe uygun hesap komutu demektir. uXBasic’te operatörler yalnız aritmetik değildir. Mantık, bit işlemi, karşılaştırma, atama, pipe ve üçlü seçim de ifade kurma yüzeyine dahildir.

## Aritmetik operatörler

| Operatör | Görev | Örnek |
|---|---|---|
| `+` | Toplama veya metin birleştirme bağlamı kurar. | `a + b` |
| `-` | Çıkarma veya negatif değer üretir. | `a - b`, `-x` |
| `*` | Çarpma yapar. | `a * b` |
| `/` | Bölme yapar. | `a / b` |
| `\` | Tam sayı bölme ailesinde kullanılır. | `a \ b` |
| `MOD` | Bölümden kalanı verir. | `a MOD b` |
| `**` | Üs alma yüzeyidir. | `a ** b` |

Project pack örneği:

```basic
DIM x AS I32 = 12
DIM y AS I32 = 5
PRINT x + y * 2
PRINT (x + y) * 2
PRINT x MOD y
```

Beklenen çıktı:

```text
22
34
2
```

İlk satırda çarpma toplama işleminden önce yapılır. İkinci satırda parantez önceliği değiştirir. Bu yüzden iki satır aynı sayıları kullandığı halde farklı sonuç verir.

## Mantık ve bit operatörleri

| Operatör | Görev | Örnek |
|---|---|---|
| `AND` | Koşulda iki tarafın da doğru olmasını ister; bit düzeyinde ortak 1 bitleri bırakır. | `izin AND uygun` |
| `OR` | Koşulda en az bir tarafın doğru olmasını ister; bit düzeyinde açık bitleri birleştirir. | `a OR b` |
| `XOR` | Yalnız bir tarafta açık olan bitleri bırakır. | `a XOR b` |
| `NOT` | Koşulu veya bit desenini tersler. | `NOT hazir` |
| `SHL` | Bitleri sola kaydırır; çoğu sayısal bağlamda ikiyle çarpma etkisi verir. | `a SHL 1` |
| `SHR` | Bitleri sağa kaydırır; çoğu sayısal bağlamda ikiye bölme etkisi verir. | `a SHR 1` |
| `ROL` | Bitleri sola döndürme yüzeyidir. | `a ROL 1` |
| `ROR` | Bitleri sağa döndürme yüzeyidir. | `a ROR 1` |

Örnek:

```basic
DIM x AS I32 = 12
DIM y AS I32 = 5
PRINT x AND y
PRINT x OR y
PRINT x XOR y
PRINT x SHL 1
PRINT x SHR 2
```

Beklenen çıktı:

```text
4
13
9
24
3
```

Bu örnek, operatörlerin yalnız matematik işlemi değil, bit düzeyinde düşünme aracı olduğunu gösterir. Bir bayrak sistemi, izin maskesi veya düşük seviye protokol çözümü yazarken bu aile önem kazanır.

## Eşitlik ve atama ayrımı

uXBasic’te `=` bağlama göre yorumlanır. Sol tarafta değişken varsa atama, koşul bağlamında karşılaştırma görevi görebilir. `==` ise eşitlik karşılaştırması için kanonik ve açık yazımdır.

```basic
DIM a AS I32 = 10

IF a == 10 THEN
    PRINT "ESIT"
END IF
```

Bu kitapta özellikle genç programcıya güvenli alışkanlık kazandırmak için koşul örneklerinde `==` kullanımı tercih edilir. BASIC uyumluluğu gereken yerde `=` koşul karşılaştırması olarak ayrıca açıklanır.

---

# Akış Kontrolü

Program yalnız yukarıdan aşağıya akan satırlar dizisi değildir. Karar ve döngü yapıları programın düşünme biçimini kurar. `IF` bir koşula göre yol seçer, `SELECT CASE` bir değeri çok kola ayırır, `FOR` sayısal tekrar kurar, `DO WHILE` koşul sürdükçe çalışır, `TRY` hata yakalama yüzeyi açar.

## IF ailesi

```basic
DIM ph AS I32 = 7

IF ph < 6 THEN
    PRINT "Asidik"
ELSEIF ph > 8 THEN
    PRINT "Bazik"
ELSE
    PRINT "Uygun"
END IF
```

Beklenen çıktı:

```text
Uygun
```

`IF` koşulu değerlendirir. `ELSEIF` ikinci ve üçüncü ihtimalleri açar. `ELSE`, hiçbir koşul doğru değilse çalışacak son koldur. `END IF`, karar bloğunu kapatır.

## FOR ve dizi birlikte

```basic
DIM ph(3) AS I32
ph(1) = 7
ph(2) = 5
ph(3) = 9

DIM i AS I32

FOR i = 1 TO 3
    IF ph(i) < 6 THEN
        PRINT "Dusuk"
    ELSEIF ph(i) > 8 THEN
        PRINT "Yuksek"
    ELSE
        PRINT "Normal"
    END IF
NEXT i
```

Beklenen çıktı:

```text
Normal
Dusuk
Yuksek
```

Bu örnekte `FOR`, `IF` ve dizi birlikte çalışır. Kitapta akış kontrolü tek başına anlatılmaz; veriyle birleştiğinde gerçek program parçasına dönüşür.

## DO WHILE

```basic
DIM j AS I32 = 0
DO WHILE j < 3
    PRINT j
    j = j + 1
LOOP
```

Beklenen çıktı:

```text
0
1
2
```

`DO WHILE`, koşul doğru kaldığı sürece döner. Sayaç artırılmazsa döngü sonsuza girebilir. Bu yüzden döngü örneklerinde sayaç değişimi açıkça gösterilir.

## TRY, CATCH, FINALLY

```basic
TRY
    PRINT "TRY_BODY"
CATCH err
    PRINT "CATCH_BODY"
FINALLY
    PRINT "FINALLY_BODY"
END TRY
```

Bu aile hata yakalama yüzeyidir. `TRY` denenen bloğu, `CATCH` hata kolunu, `FINALLY` ise sonuçtan bağımsız kapanış işini taşır. Semantic ve runtime tarafında hata akışı için ayrı bir sözleşme oluşturur.

---

# Fonksiyonlar, Rekürsiyon ve İç İçe Çağrı

Fonksiyon, programın düşüncesini adlandırır. Aynı hesabı tekrar tekrar yazmak yerine bir kez tanımlar, sonra farklı değerlerle çağırırsın. uXBasic’te `FUNCTION` değer döndüren işlem bloğu, `SUB` değer döndürmeyen işlem bloğu, `RETURN` ise fonksiyondan çıkış ve sonuç verme yoludur.

## Temel fonksiyon

```basic
FUNCTION AddTwo(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

PRINT AddTwo(7, 8)
```

Beklenen çıktı:

```text
15
```

Bu örnekte `a` ve `b` parametredir. `AS I32`, hem parametrelerin hem de fonksiyon sonucunun tipini belirtir. Parser bu yapıyı fonksiyon AST düğümüne, semantic katman sembol tablosuna, MIR ise çağrılabilir işlem gövdesine indirir.

## Rekürsiyon

```basic
FUNCTION Fact(n AS I32) AS I32
    IF n <= 1 THEN
        RETURN 1
    END IF
    RETURN n * Fact(n - 1)
END FUNCTION

PRINT Fact(5)
```

Beklenen çıktı:

```text
120
```

Rekürsiyon, fonksiyonun kendisini çağırmasıdır. Bu yalnız gösterişli bir teknik değildir; ağaç, klasör, matematiksel seri ve böl-parçala çöz tarzı problemlerde güçlüdür. Rekürsiyonda durma koşulu zorunludur. Bu örnekte `n <= 1` durma koşuludur.

## İç içe çağrı

```basic
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

FUNCTION Mul(a AS I32, b AS I32) AS I32
    RETURN a * b
END FUNCTION

PRINT Add(Mul(2, 3), Add(4, 5))
PRINT Mul(Add(1, 2), Add(3, 4))
PRINT LEN(UCASE("abc"))
```

Beklenen çıktı:

```text
15
21
3
```

İç içe çağrı, derleyici için ciddi bir sınavdır. Önce içteki çağrılar hesaplanır, sonra sonuçlar dıştaki fonksiyona parametre olarak verilir. AST bu ilişkiyi ağaç olarak taşır; MIR bunu yürütülebilir sıraya indirir. Bu yüzden iç içe çağrı bölümü AST ve MIR anlatımına doğal bir köprü kurar.

---

# Veri Yapıları, TYPE, CLASS ve MAGIC

Tek değişken bir değer taşır. Dizi aynı türden birçok değeri tek ad altında toplar. `TYPE` birden çok alanı tek kayıt tipinde birleştirir. `CLASS` veriyle birlikte davranış da taşır. `MAGIC` ise sınıfın özel davranış sözleşmelerini tanımlar.

## Dizi

```basic
DIM arr(5) AS I32
arr(1) = 3
arr(2) = 5
arr(3) = arr(1) + arr(2)
arr(4) = arr(3) * 2
PRINT arr(1)
PRINT arr(3)
PRINT arr(4)
```

Beklenen çıktı:

```text
3
8
16
```

Dizi, ölçüm, puan, zaman serisi, sensör değeri ve tablo mantığı için temel yapıdır. İndekslenebilir olması onu döngülerle birlikte güçlü yapar.

## TYPE

```basic
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

DIM p AS Nokta
p.x = 12
p.y = 30
PRINT p.x + p.y
PRINT p.y - p.x
```

Beklenen çıktı:

```text
42
18
```

`TYPE`, veriyi anlamlı alanlara ayırır. `p.x` ve `p.y` iki ayrı değişken gibi değil, aynı kaydın iki alanı gibi düşünülür. Böylece programda dağınık değerler yerine anlamlı veri yapıları oluşur.

## CLASS ve MAGIC

```basic
CLASS Anahtar
    VALUE AS I32

    MAGIC HASH() AS I32
        RETURN VALUE + 100
    END MAGIC

    MAGIC CLONE() AS I32
        RETURN VALUE
    END MAGIC

    MAGIC ADD(other AS I32) AS I32
        RETURN VALUE + other
    END MAGIC
END CLASS
```

`CLASS`, veri ve davranışı aynı yapı altında toplar. `MAGIC`, sıradan metot değildir; sınıfın özel davranış sözleşmesini kurar. `HASH`, `CLONE`, `ADD` gibi adlar nesne yüzeyinin dil tarafından anlaşılabilecek davranış kapılarıdır. Bu bölümde `TYPE` ile `CLASS` ayrımı açık tutulur: `TYPE` veri taşır, `CLASS` veriyle birlikte davranış taşır.

## Koleksiyon tip yüzeyi

```basic
DIM a AS ARRAY
DIM l AS LIST
DIM d AS DICT
DIM s AS SET
PRINT "DATA_STRUCT_SURFACE"
```

`ARRAY`, `LIST`, `DICT` ve `SET` veri yapısı yüzeyini temsil eder. Kitapta bu tipler yalnız isim olarak değil, hangi düşünme biçimine karşılık geldikleriyle anlatılır: sıra, liste, anahtar-değer ve benzersiz küme.

---

# Namespace, Module, Include, Import ve Dış Çağrı Ayrımı

uXBasic büyüdükçe tek dosya program yetmez. Kod bölümlere ayrılır, isimler çakışmasın diye alanlara alınır, başlık dosyaları eklenir, dış kaynaklar build hattına bağlanır ve runtime sırasında DLL/API rotaları çağrılır. Bu bölümün ana görevi, birbirine benzeyen ama aynı olmayan yapıları ayırmaktır.

## Namespace, using ve alias

```basic
NAMESPACE NS08
    FUNCTION ADD(a AS I32, b AS I32) AS I32
        RETURN a + b
    END FUNCTION
END NAMESPACE

USING NS08
ALIAS TOPLA AS ADD
PRINT TOPLA(10, 20)
PRINT ADD(7, 8)
```

Beklenen çıktı:

```text
30
15
```

`NAMESPACE` isim alanı kurar. `USING`, o isim alanındaki adları görünür yapar. `ALIAS`, bir ada ikinci bir kullanım adı verir. Bu üç yapı büyük programda okunabilirliği ve isim denetimini güçlendirir.

## Module ve main

```basic
MODULE Mod20
    FUNCTION MADD(a AS I32, b AS I32) AS I32
        RETURN a + b
    END FUNCTION
END MODULE

USING Mod20
MAIN
    PRINT MADD(2, 3)
END MAIN
```

Beklenen çıktı:

```text
5
```

`MODULE`, ilgili fonksiyonları bir araya toplar. `MAIN`, programın ana giriş bloğunu belirginleştirir.

## Include

```basic
INCLUDE "xtestx/project_packs/pack_12_preprocessor_include_foreach/support/math.uxbh"
PRINT INC12(30)
PRINT PACK12_CONST
```

`INCLUDE`, uXBasic başlık veya kaynak parçasını projeye ekler. Bu yapı, ortak fonksiyon ve sabitleri ayrı dosyada tutmak için kullanılır.

## Import

```basic
IMPORT(C, "xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.c")
IMPORT(CPP, "xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.cpp")
IMPORT(ASM, "xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.asm")
PRINT "IMPORT_ROUTE"
```

`IMPORT`, yalnız derleme zamanı dış kaynak ekleme yoludur. `IMPORT(C, ...)`, `IMPORT(CPP, ...)` ve `IMPORT(ASM, ...)` geçerli yönlerdir. `IMPORT DLL`, `IMPORT API` veya `IMPORT LIB` kanonik kullanım değildir.

## DECLARE ve CALL(DLL)

```basic
DECLARE FUNCTION ux_route_14 LIB "uxmath.dll" ALIAS "ux_route_14" (BYVAL a AS I32, BYVAL b AS I32) AS I32
CALL(DLL, "uxmath.dll", "ux_route_14", 1, 2)
PRINT "FFI14_01"
```

`DECLARE ... LIB ... ALIAS ...`, dış fonksiyonun imzasını tanımlar. `CALL(DLL, ...)`, runtime sırasında DLL fonksiyon rotasını çağırır. Bu iki yapı `IMPORT` değildir; görevleri farklıdır.

## CALL(API)

```basic
CALL(API, "json", "noop", CDECL, 1)
CALL(API, "regex", "noop", CDECL, 2)
PRINT "API_ROUTE_SURFACE"
```

`CALL(API, ...)`, JSON, regex, web, dış servis veya benzer API rotaları için kullanılır. Kitapta `CALL(DLL)` ve `CALL(API)` aynı “dış dünya” ailesinde anlatılır; fakat DLL dosyası çağrısı ile API servis rotası birbirine karıştırılmaz.

---

# Preprocessor

Preprocessor, kaynak kod derleyiciye gitmeden önce çalışan üst düzenleyicidir. Kaynak dosyaya hedef, koşul, döngü, asset, manifest, HTML, JS, WAT ve güvenlik bilgisi ekleyebilir. Bu yüzden preprocessor yalnız birkaç `%%` komutu değil, uXBasic’in hedefe göre kaynak hazırlama dilidir.

## Değer tanımlama ve koşul

```basic
%%SET FLAG = 1
%%DEFINE BASE 10
%%EVAL DOUBLE_BASE = BASE * 2

%%IF FLAG == 1
PRINT "META_ON"
%%ENDIF

PRINT %%EVAL(DOUBLE_BASE)
```

Beklenen çıktı:

```text
META_ON
20
```

`%%SET` meta değişken kurar. `%%DEFINE` sabit tanımlar. `%%EVAL` meta ifadeyi hesaplar. `%%IF` kaynak kodun hangi bölümünün derleyiciye gideceğini belirler.

## Include ve foreach ailesi

Preprocessor, include ve döngü mantığıyla tekrarlı kaynak üretimi yapabilir. Bu özellik özellikle sabit tablo, tekrar eden wrapper, hedefe göre blok üretme ve küçük DSL kurguları için önemlidir.

## Web hedefi

```basic
%%TARGET WEB
%%OUTDIR "dist/pack19"
%%SET TITLE = "PACK19"

%%HTML_BEGIN "index.html" BODY
<h1>{{TITLE}}</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("PACK19");
%%JS_END

PRINT "WEB_ROUTE"
PRINT "WASM_READY"
```

Beklenen çıktı:

```text
WEB_ROUTE
WASM_READY
```

Bu örnek preprocessor’ın yalnız derleme içi makro olmadığını gösterir. `%%TARGET WEB`, hedefi web olarak belirler. `%%OUTDIR`, çıktı klasörünü seçer. `%%HTML_BEGIN` ve `%%JS_BEGIN`, hedef dosya içerikleri üretir. `PRINT` ise uXBasic kaynak akışında kalır.

## Preprocessor aileleri

| Aile | Komutlar | Görev |
|---|---|---|
| Değer | `%%SET`, `%%DEFINE`, `%%UNDEF`, `%%EVAL` | Meta değer kurar, siler ve hesaplar. |
| Koşul | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` | Kaynak bloklarını koşula göre açar veya kapatır. |
| Döngü | `%%FOR`, `%%FOREACH`, `%%REPEAT`, `%%ENDFOR` | Tekrarlı kaynak üretimi kurar. |
| Hedef | `%%TARGET`, `%%OUTDIR`, `%%PLATFORM`, `%%PROFILE` | Üretim hedefi ve çıktı alanını seçer. |
| Web | `%%HTML_BEGIN`, `%%HTML_END`, `%%CSS_BEGIN`, `%%JS_BEGIN`, `%%JS_END` | HTML, CSS ve JS artefact üretir. |
| WAT/WASM | `%%WAT_BEGIN`, `%%WAT_END`, `%%WAT_IMPORT`, `%%WAT_EXPORT` | WAT/WASM hedeflerine bağlanır. |
| Asset | `%%ASSET_ROOT`, `%%ASSET_FILE`, `%%ASSET_COPY`, `%%ASSET_IMAGE` | Dosya, görsel, ses ve veri varlıklarını yönetir. |
| Güvenlik | `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SAFE_PATHS` | Hedefsiz raw kod ve tehlikeli yol kullanımını kapıdan geçirir. |

Preprocessor komutları kitapta liste olarak kalmaz. Her aile hedef örneğiyle birlikte anlatılır.

---

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

---

# CLI, Build, Test ve Yan Araçlar

uXBasic kitabı yalnız dil sözdizimini anlatmaz; programcının dili nasıl doğrulayacağını da gösterir. Bir komutu öğrenmek kadar, onu test etmek ve raporunu okumak da önemlidir.

## Derleme

```powershell
.\build_64.bat
```

Bu komut uXBasic derleyicisini üretir. Başarılı sonuçta `bin\uxb.exe` oluşur.

## Project pack testleri

```powershell
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut 30 project pack paketini çalıştırır. Kitabın örnek omurgası bu test ailesine dayanır. Paketler yalnız PASS/FAIL sonucu üretmez; komutların birlikte kullanımını gösteren küçük programlar da sağlar.

## Expected testleri

```powershell
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Expected test hattı daha küçük sözleşme testlerini çalıştırır. Komut, lexer, parser, semantic ve runtime düzeyinde beklenen çıktılar bu ailede kontrol edilir.

## Derin analiz

```powershell
python uxb_derin_analiz.py
```

Derin analiz aracı kaynak yüzeyi, dosya haritası, kullanım ilişkisi ve rapor üretimi için kullanılır. Kitapta bu araç, geliştiriciye “hangi dosya hangi katmana hizmet ediyor?” sorusunu cevaplamak için anlatılır.

## JSON çıktı ailesi

CLI içinde AST, MIR, runtime ve rapor dosyalarını dışarı almak için çok sayıda seçenek bulunur. Kitapta özellikle şu seçenekler ayrı anlatılır:

```text
--ast-json-out
--hir-json-out
--mir-pipeline-json-out
--mir-opcodes-json-out
--artifact-report-json-out
--ast-exec-result-json-out
--ast-stdout-out
--ast-stderr-out
--codegen-source AST|MIR
--emit-x64-nasm
--build-x64
```

Bu seçenekler kitabın mimari bölümleriyle birlikte kullanılacaktır. Okuyucu yalnız komutu çalıştırmayacak; AST ve MIR çıktısını da görerek dilin iç yolculuğunu anlayacaktır.

---

# Cheat Sheetler ve Hızlı Başvuru

Bu bölüm kitabın sonunda yer alır. Ana kitap öğrenme sırasıyla yazılır; cheat sheetler ise hızlı bulma sırasıyla düzenlenir.

## Komut aileleri

| Aile | Komutlar |
|---|---|
| Değişken | `DIM`, `AS`, `CONST`, `REDIM`, `DEFINT`, `DEFLNG`, `DEFSTR`, `DEFEXT` |
| Akış | `IF`, `THEN`, `ELSEIF`, `ELSE`, `SELECT`, `CASE`, `END` |
| Döngü | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `UNTIL`, `WEND` |
| Fonksiyon | `FUNCTION`, `SUB`, `RETURN`, `DECLARE`, `CALL`, `BYVAL`, `BYREF` |
| Nesne | `TYPE`, `CLASS`, `INTERFACE`, `MAGIC`, `CONSTRUCTOR`, `DESTRUCTOR`, `NEW`, `DELETE` |
| Modül | `NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `MAIN` |
| Dosya | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE`, `GET`, `PUT`, `SEEK` |
| Dış bağlantı | `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)`, `IMPORT(C/CPP/ASM)` |

## Veri tipleri

| Tip | Görev |
|---|---|
| `I8`, `I16`, `I32`, `I64` | İşaretli tam sayı ailesi. |
| `U8`, `U16`, `U32`, `U64` | İşaretsiz tam sayı ailesi. |
| `F32`, `F64`, `F80`, `F128` | Kayan nokta ve geniş duyarlık ailesi. |
| `BIGI`, `BIGINT` | Büyük tam sayı ailesi. |
| `BIGD`, `BIGF`, `BALL` | Büyük/uzun duyarlıklı ondalık aile. |
| `BOOLEAN` | Mantıksal değer. |
| `STRING` | Metin. |
| `OBJECT` | Nesne. |
| `PTR`, `STRPTR` | İşaretçi ve metin işaretçisi yüzeyi. |
| `ARRAY`, `LIST`, `DICT`, `SET` | Koleksiyon tip yüzeyi. |

## Operatör aileleri

| Aile | Operatörler |
|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` |
| Mantık | `AND`, `OR`, `NOT`, `XOR` |
| Logic16 | `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| Kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `**=` |
| Pipe | `|>` |
| Üçlü | `?:` |

## Yanlış keyword düzeltmeleri

| Yanlış | Doğru | Not |
|---|---|---|
| `THREAT` | `THREAD` | İş parçacığı/yürütme işi yüzeyi. |
| `PARALLEL` | `PARALEL` | uXBasic kanonik keyword kararı. |
| `SIHIRLIMETOT` | `MAGIC` | Sınıf özel davranış sözleşmesi. |

## Kaynak gerçekliği kısa sayılar

| Alan | Sayı |
|---|---:|
| Lexer keyword/yüzey sözcüğü | 220 |
| Statement dispatch girişi | 79 |
| AST node sabiti | 142 |
| Runtime service ID | 83 |
| CLI seçenek adı | 167 |
| Project pack | 30 |

---

# Komut Fonksiyon Referansina Hazirlik

Bu bölüm sonraki yamalarda bütün komut ve fonksiyonları tek tek görev, syntax, parametre, örnek, beklenen çıktı ve katman bilgisiyle açacak referans alanıdır. İlk yamada tablo dili ve şablon kurulduğu için bu bölüm kontrollü biçimde büyütülecektir.

Bu bölüm kitapta boş bırakılmaz; sonraki genişletmelerde kaynak kod gerçekliğiyle uyumlu örnekler, tablolar ve test bağlantılarıyla doldurulur.

---

# Preprocessor Cheat Sheet Detaylari

Bu bölüm preprocessor ailelerinin kısa başvuru tablosunu büyütür. Her `%%` yönergesi hedef, sözdizimi, örnek ve güvenlik notuyla yazılacaktır.

Bu bölüm kitapta boş bırakılmaz; sonraki genişletmelerde kaynak kod gerçekliğiyle uyumlu örnekler, tablolar ve test bağlantılarıyla doldurulur.

---

# Operator Cheat Sheet Detaylari

Bu bölüm operatörlerin öncelik, bağlayıcılık, örnek ve AST/MIR karşılıklarını genişletir. Logic16 ailesi ayrıca tam tabloyla işlenecektir.

Bu bölüm kitapta boş bırakılmaz; sonraki genişletmelerde kaynak kod gerçekliğiyle uyumlu örnekler, tablolar ve test bağlantılarıyla doldurulur.

---

# Veri Tipi Ve Veri Yapisi Cheat Sheet Detaylari

Bu bölüm sayısal tipler, metin, nesne, pointer ve koleksiyon yüzeyini hızlı başvuru düzenine taşır.

Bu bölüm kitapta boş bırakılmaz; sonraki genişletmelerde kaynak kod gerçekliğiyle uyumlu örnekler, tablolar ve test bağlantılarıyla doldurulur.

---

# Backend Cli Cheat Sheet Detaylari

Bu bölüm JS, WAT/WASM, x64, AST interpreter, MIR interpreter ve CLI seçeneklerini tek bakışta bulunur hale getirir.

Bu bölüm kitapta boş bırakılmaz; sonraki genişletmelerde kaynak kod gerçekliğiyle uyumlu örnekler, tablolar ve test bağlantılarıyla doldurulur.

---

# Kitap Uretim Hatti Ve Kalite Kapisi

Bu bölüm `docs_src` parçalarının tek kitaba nasıl dönüştürüleceğini, tekrar ve boş cümle kapısının nasıl uygulanacağını ve yeni örneklerin project pack/test örneğiyle nasıl bağlanacağını tanımlar.

Bu bölüm kitapta boş bırakılmaz; sonraki genişletmelerde kaynak kod gerçekliğiyle uyumlu örnekler, tablolar ve test bağlantılarıyla doldurulur.

---

# Project Pack Omurga Tablosu

Project pack dosyaları kitabın çalışan örnek deposudur. Her bölümde en az bir pack örneği kullanılır. Aşağıdaki tablo hangi paketin hangi konuyu taşıdığını gösterir.

| Pack | Faz | Görev | Yüzey Etiketleri | Beklenen Çıktı Başlangıcı |
|---|---|---|---|---|
| `pack_01_core_numeric_flow` | `run` | Çekirdek sayısal akış: DIM, AS, atama, aritmetik, PRINT. | `core, numeric, dim, assignment, print` | `30, 35, 70, 55, ...` |
| `pack_02_operators_logic_bit` | `run` | Operatör önceliği ve bit düzeyi işleçler. | `operators, mod, and, or, xor, shl, shr` | `22, 34, 2, 4, ...` |
| `pack_03_strings_builtins` | `run` | Kanonik string fonksiyonları; $ suffix yok. | `strings, len, left, mid, right, lcase, trim, chr, asc` | `7, UXB, XBA, IC, ...` |
| `pack_04_arrays_index_lvalue` | `run` | Dizi indeksleme ve lvalue ataması. | `array, index, lvalue` | `3, 8, 16` |
| `pack_05_control_flow_if_for` | `run` | Kontrol akışı: FOR/NEXT, IF/ELSE, DO WHILE/LOOP. | `if, for, do, while, loop` | `15, BUYUK, 0, 1, ...` |
| `pack_06_functions_recursion_include` | `run` | Fonksiyon, RETURN ve rekürsiyon. | `function, return, recursion` | `15, 120` |
| `pack_07_type_record_structures` | `run` | TYPE kaydı ve alan erişimi. | `type, record, field` | `42, 18` |
| `pack_08_namespace_using_alias` | `run` | NAMESPACE, USING ve ALIAS çağrı çözümleme. | `namespace, using, alias, function` | `30, 15` |
| `pack_09_class_oop_magic` | `ast` | MAGIC HASH ve custom MAGIC parser/AST yüzeyi. Runtime doğal dispatch Fix-14 sonrası ayrıca test edilecek. | `class, magic, hash, custom-magic, operator-magic` | `` |
| `pack_10_file_io_channels` | `run` | # yalnız file I/O kanal numarasıdır; LINE INPUT ve $ yok. | `open, print-file, input-file, close, #-channel` | `101, 202, 303` |
| `pack_11_preprocessor_meta` | `run` | Temel preprocessor meta komutları. | `preprocessor, set, define, eval, if` | `META_ON, 20, UXB` |
| `pack_12_preprocessor_include_foreach` | `run` | INCLUDE .uxbh başlık kullanımı; foreach iddiası yok. | `include, uxbh, const, function` | `42, 12` |
| `pack_13_import_c_cpp_asm` | `ast` | IMPORT yalnız C/CPP/ASM derleme zamanı kaynak rotasıdır; DLL/API değildir. | `import, c, cpp, asm` | `` |
| `pack_14_ffi_winapi_routes` | `run` | CALL(DLL,...) route smoke; gerçek DLL yükleme değil. | `declare, lib, alias, call-dll, ffi-route` | `FFI14_01, FFI14_02, FFI14_03, FFI14_04, ...` |
| `pack_15_science_external_routes` | `ast` | CALL(API,...) parser/AST yüzeyi; runtime servis davranışı ayrı test edilecek. | `call-api, json, regex, library-route` | `` |
| `pack_16_big_extfp_canonical` | `run` | Büyük sayı ailesi yüzeyi. | `biginit, bigi, bigint, bigd, bigf, ball` | `12345, 23456, 12.50, 3.5, ...` |
| `pack_17_memory_ptr_intrinsics` | `ast` | Bellek intrinsics parser/AST yüzeyi; güvenli runtime davranışı Fix sonrası ayrı test. | `poke, peek, memory` | `` |
| `pack_18_event_thread_pipe_slot` | `ast` | EVENT/THREAD/PIPE/PARALEL bloklarında normal uXBasic gövde parse edilir; runtime dispatch ayrı. | `event, thread, pipe, paralel, slot, trigger` | `` |
| `pack_19_browser_wasm_webgpu_route` | `run` | WEB/BROWSER/JS hedefinde RUNTIME JS bloğu serbesttir; raw hedefsiz JS negatifte kalır. | `target-web, html-begin, js-begin-runtime, browser` | `WEB_ROUTE, WASM_READY` |
| `pack_20_module_main_using` | `ast` | MODULE ve MAIN parser/AST yüzeyi. | `module, main, using, function` | `` |
| `pack_21_input_line_file` | `run` | LINE INPUT ve $ yok; kanonik INPUT # kanal testi. | `input-file, print-file, #-channel` | `165` |
| `pack_22_error_try_catch_surface` | `ast` | TRY/CATCH/FINALLY parser yüzeyi. | `try, catch, finally` | `` |
| `pack_23_data_structures_list_dict_set` | `ast` | Veri yapısı tip adları yüzeyi; runtime koleksiyon API ayrı. | `array-type, list, dict, set` | `` |
| `pack_24_math_time_random_surface` | `run` | Deterministik matematik fonksiyonları; TIMER/RND exact stdout testine konmadı. | `abs, int, sgn, sqr` | `9, 12, -1, 0, ...` |
| `pack_25_nested_calls_expressions` | `run` | İç içe fonksiyon çağrıları ve ifade değerlendirme. | `nested-calls, function, expression` | `15, 21, 3` |
| `pack_26_negative_raw_js_gate` | `run` | TARGET WEB/BROWSER/JS olmadan raw JS fail-close kalmalıdır. | `negative, raw-js-gate` | `` |
| `pack_27_negative_include_cycle` | `preprocess` | INCLUDE döngüsü hata vermelidir. | `negative, include-cycle` | `` |
| `pack_28_negative_semantic_unknown_symbol` | `semantic` | Bilinmeyen sembol hata vermelidir. | `negative, semantic, unknown-symbol` | `` |
| `pack_29_negative_wrong_keywords` | `ast` | Yanlış keywordler reddedilir: THREAT, PARALLEL, SIHIRLIMETOT. | `negative, wrong-keyword, thread, paralel, magic` | `` |
| `pack_30_full_integration_project` | `run` | Çalışan katmanlardan kanonik entegrasyon smoke testi. | `full, integration, preprocessor, include, import, type, array, string, big, namespace, alias` | `900, 30, 103, 15, ...` |

---

# Temel Komut Referansı: Yazdırma, Değişken ve Giriş Çıkış

uXBasic öğrenirken ilk görülen komutlar basit görünür; fakat kitabın dili açısından en önemli komutlar bunlardır. Çünkü okuyucu ilk defa kaynak kodun neye dönüştüğünü, değişkenin nasıl ad aldığını, değerin nasıl saklandığını ve sonucun nasıl gözlemlendiğini burada öğrenir. `PRINT`, `DIM`, `AS`, `CONST`, `INPUT`, `CLS`, `COLOR`, `LOCATE`, `INKEY` ve `GETKEY` yalnız başlangıç komutları değildir; bütün daha büyük örneklerin taşıyıcı kolonlarıdır.

Bu bölümde her komut önce tek başına tanıtılır, sonra kendinden önce ve sonra gelen komutlarla birlikte kullanılır. Böylece okuyucu bir komutu ezberlemek yerine, o komutun program akışı içindeki yerini görür.

## PRINT

`PRINT`, bir ifadeyi görünür çıktı hâline getirir. Bu çıktı konsolda görülebilir, dosya kanalına yazılabilir veya hedefe göre runtime çıktı servisine bağlanabilir. Programcı açısından `PRINT`, sonucu görmenin en kısa yoludur. Derleyici açısından ise ifade çözümleme, tip dönüştürme ve çıktı rotasına bağlanma noktasıdır.

Syntax:

```basic
PRINT ifade
PRINT "metin"
PRINT degisken
PRINT #kanal, ifade
```

Temel örnek:

```basic
PRINT "uXBasic calisiyor"
```

Beklenen çıktı:

```text
uXBasic calisiyor
```

`PRINT` tek başına kullanıldığında yalnızca sabit metni gösterir. Bir değişkenle kullanıldığında programın iç durumunu dışarı çıkarır:

```basic
DIM puan AS I32 = 70
PRINT puan
```

Beklenen çıktı:

```text
70
```

Bir hesap ifadesiyle birlikte kullanıldığında `PRINT`, sonucu ayrıca değişkene almadan gözlemlemeyi sağlar:

```basic
DIM yem AS I32 = 120
DIM balik AS I32 = 40
PRINT yem / balik
```

Beklenen çıktı:

```text
3
```

Bu örnek, `DIM`, `AS`, bölme operatörü ve `PRINT` komutunu aynı anda çalıştırır. Kitap boyunca bir komutun en küçük örneği verildikten sonra, hemen böyle birleşik bir örneğe geçilir.

## DIM ve AS

`DIM`, bellekte isimli alan açar. `AS`, bu alanın tipini bağlar. Bu ikisi birlikte kullanıldığında derleyici değişkenin adını, türünü ve kapsamını bilir. Bu bilgi semantic denetim için gereklidir; MIR ve hedef kod üretimi de bu tip bilgisinden yararlanır.

Syntax:

```basic
DIM ad AS tip
DIM ad AS tip = ilkDeger
DIM ad(boyut) AS tip
```

Temel örnek:

```basic
DIM sayi AS I32 = 30
PRINT sayi
```

Beklenen çıktı:

```text
30
```

Dizi örneği:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

PRINT sicaklik(1)
PRINT sicaklik(2)
PRINT sicaklik(3)
```

Beklenen çıktı:

```text
18
21
19
```

Bu kod, üç ayrı değişken açmak yerine tek bir dizi adı altında üç ölçüm saklar. Daha sonra `FOR` döngüsü öğrenildiğinde aynı dizi tek tek yazdırılmak yerine döngüyle gezilir:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)
NEXT i

PRINT toplam
```

Beklenen çıktı:

```text
58
```

`DIM` böylece yalnız değişken tanımlama komutu değildir; dizi, kayıt, nesne, fonksiyon içi yerel değer ve hesap akışı kurmanın başlangıç noktasıdır.

## CONST

`CONST`, program boyunca değişmeyecek değeri adlandırır. Bu değer bir sınır, katsayı, ayar veya sabit mesaj olabilir. `CONST` kullanıldığında okuyucu ve derleyici bu adın normal değişken gibi değiştirilmemesi gerektiğini bilir.

Syntax:

```basic
CONST ad AS tip = deger
```

Örnek:

```basic
CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

IF okuma < LIMIT THEN
    PRINT "Guvenli"
ELSE
    PRINT "Limit asildi"
END IF
```

Beklenen çıktı:

```text
Guvenli
```

Bu örnekte `LIMIT` sıradan bir sayı olarak yazılabilirdi; fakat sabit adı programın niyetini açıklar. Genç programcı için önemli ders şudur: kod yalnız makineye değil, gelecekte o kodu okuyacak insana da yazılır.

## INPUT

`INPUT`, kullanıcıdan veya dosya kanalından değer alır. Konsol kullanımında programı dış dünyadan gelen veriyle buluşturur. Dosya kanalında `INPUT #` biçimiyle kullanıldığında okuma rotası dosyaya bağlanır.

Syntax:

```basic
INPUT degisken
INPUT #kanal, degisken
```

Konsol mantığı:

```basic
DIM yas AS I32
INPUT yas
PRINT yas
```

Dosya kanalı mantığı:

```basic
OPEN "veri.txt" FOR OUTPUT AS #1
PRINT #1, "77"
CLOSE #1

OPEN "veri.txt" FOR INPUT AS #2
DIM okuma AS I32
INPUT #2, okuma
CLOSE #2

PRINT okuma
```

Beklenen çıktı:

```text
77
```

Burada `#` işareti değişken eki değildir; dosya kanal numarasıdır. uXBasic sözleşmesinde `#` karakteri dosya giriş çıkış kanalını göstermek için kullanılır.

## CLS, COLOR ve LOCATE

`CLS`, ekranı temizler. `COLOR`, yazı ve arka plan rengini ayarlar. `LOCATE`, imleci belirli satır ve sütuna taşır. Bu komutlar doğrudan hesap üretmez; fakat konsol programında kullanıcıya düzenli çıktı göstermek için kullanılır.

Syntax:

```basic
CLS
COLOR onPlan, arkaPlan
LOCATE satir, sutun
```

Örnek:

```basic
CLS
COLOR 10, 0
LOCATE 2, 5
PRINT "uXBasic panel"
```

Bu örnek bir hesap algoritması değil, çıktı düzeni örneğidir. Kitapta böyle komutlar anlatılırken “ekranı güzelleştirir” gibi boş cümle kullanılmaz. Görev açık yazılır: `CLS` eski çıktıyı siler, `COLOR` yeni çıktının renk bilgisini ayarlar, `LOCATE` yazının başlayacağı konumu seçer.

## INKEY ve GETKEY

`INKEY` ve `GETKEY`, klavyeden karakter veya tuş bilgisi alma ailesindedir. Bu iki sözcük birlikte korunur. `INKEY` genellikle beklemeden okuma fikrine, `GETKEY` ise tuş alma fikrine bağlanır. Kitapta ikisi de klavye giriş yüzeyi olarak anlatılır.

Örnek kullanım fikri:

```basic
DIM tus AS STRING

tus = INKEY

IF tus <> "" THEN
    PRINT tus
END IF
```

Basit menü fikri:

```basic
PRINT "1 - Baslat"
PRINT "2 - Cikis"

DIM tus AS STRING
 tus = GETKEY

IF tus = "1" THEN
    PRINT "Basliyor"
ELSEIF tus = "2" THEN
    PRINT "Cikis"
ELSE
    PRINT "Bilinmeyen secim"
END IF
```

Bu örnek, klavye komutlarını `IF`, `ELSEIF`, `PRINT` ve `STRING` tipiyle birleştirir. Komutlar kitapta tek tek görünür; fakat program gerçek gücünü bu birleşimlerde kazanır.

## Temel komutların birlikte akışı

Aşağıdaki küçük program, bu bölümdeki komut ailesini tek bir akışta kullanır:

```basic
CLS
COLOR 10, 0

CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

LOCATE 2, 1
PRINT "Olcum sonucu"

IF okuma < LIMIT THEN
    PRINT "Guvenli"
ELSE
    PRINT "Limit asildi"
END IF
```

Beklenen çıktı:

```text
Olcum sonucu
Guvenli
```

Bu program küçük görünür; fakat bir kitabın ilk dersleri için yeterince zengindir. Sabit değer vardır, değişken vardır, koşul vardır, ekran düzeni vardır ve sonuç vardır. uXBasic kitabında temel komutlar bu şekilde öğretilir: önce tek başına, sonra birlikte, sonra küçük bir düşünce düzeni içinde.

---

# Operatör Referansı: İfade Kurma, Öncelik ve Logic16

Operatörler, programın düşünme biçimini kurar. Değişkenler değer taşır; operatörler bu değerler arasında ilişki kurar. `a + b` bir toplama ifadesidir, `sicaklik > 22` bir karar ifadesidir, `izin AND sicaklikUygun` iki şartı birleştirir, `maske SHL 1` bitleri sola kaydırır. Bu yüzden operatör bölümü yalnız işaret listesi değildir; ifade kurma dersidir.

uXBasic operatör sözleşmesinde büyük öncelik değeri daha sıkı bağlanır. Örneğin çarpma toplama işleminden önce gelir; üs alma sağdan bağlanır; atama ailesi en düşük önceliklerden birine sahiptir. `=` işareti bağlama duyarlıdır: sol taraf değişkense atama, koşul ifadesinde ise eşitlik karşılaştırması olarak yorumlanır. Kanonik eşitlik karşılaştırması için `==` yazımı da tanınır ve karşılaştırma anlamına bağlanır.

## Aritmetik operatörler

| Operatör | Görev | Örnek |
|---|---|---|
| `+` | İki sayıyı toplar veya uygun bağlamda metinleri birleştirme yüzeyine katılır. | `a + b` |
| `-` | Çıkarma yapar; tekli kullanımda sayının işaretini değiştirir. | `a - b`, `-a` |
| `*` | Çarpma yapar. | `a * b` |
| `/` | Bölme yapar. | `a / b` |
| `\` | Tam sayı bölme yüzeyi olarak kullanılır. | `a \ b` |
| `%`, `MOD` | Bölmeden kalanı üretir. | `a MOD b` |
| `**` | Üs alma operatörüdür; sağdan bağlanır. | `2 ** 3` |

Örnek:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a + b
PRINT a - b
PRINT a * b
PRINT a MOD b
```

Beklenen çıktı:

```text
17
7
60
2
```

Bu örnekte operatörler yalnız sonuç üretmez; aynı zamanda `PRINT` komutuna ifade verir. `PRINT a + b` satırında önce ifade çözülür, sonra sonuç yazdırılır.

## Karşılaştırma operatörleri

Karşılaştırma operatörleri karar yapılarının temelidir. `IF`, `WHILE`, `UNTIL`, `ASSERT` ve benzeri yapılar bu ifadelerin sonucuna göre akışı seçer.

| Operatör | Görev |
|---|---|
| `=`, `==` | İki değerin eşit olup olmadığını karşılaştırır. `==` açık karşılaştırma yazımıdır. |
| `<>`, `!=` | İki değerin farklı olup olmadığını karşılaştırır. |
| `<` | Sol değer sağ değerden küçük mü diye bakar. |
| `<=` | Sol değer sağ değerden küçük veya eşit mi diye bakar. |
| `>` | Sol değer sağ değerden büyük mü diye bakar. |
| `>=` | Sol değer sağ değerden büyük veya eşit mi diye bakar. |

Örnek:

```basic
DIM sicaklik AS I32 = 24

IF sicaklik > 22 THEN
    PRINT "Yuksek"
ELSE
    PRINT "Normal"
END IF
```

Beklenen çıktı:

```text
Yuksek
```

Burada `>` operatörü yalnız iki sayıyı kıyaslamaz; programın hangi kola gideceğini belirler.

## Mantıksal ve bit düzeyi operatörler

`AND`, `OR`, `NOT` ve `XOR` hem koşul ifadelerinde hem de bit düzeyi düşünmede önemlidir. Koşulda `AND`, iki şartın birlikte doğru olmasını ister. Bit düzeyinde ise iki sayının aynı konumdaki açık bitlerini sonuçta bırakır.

```basic
DIM izin AS I32 = 1
DIM sicaklikUygun AS I32 = 1

IF izin AND sicaklikUygun THEN
    PRINT "Sistem baslat"
ELSE
    PRINT "Bekle"
END IF
```

Beklenen çıktı:

```text
Sistem baslat
```

Bit işlemi örneği:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1
PRINT a SHR 1
```

Bu örnekte `AND`, `OR`, `XOR`, `SHL` ve `SHR` sayıları bit desenleri gibi ele alır. Genç programcı için bu bölüm önemlidir: bilgisayar sayıları yalnız onluk sistemde değil, bit düzeyinde de işler.

## Kaydırma ve döndürme

| Operatör | Görev |
|---|---|
| `SHL`, `<<` | Bitleri sola kaydırır; küçük sayılarda çoğu zaman ikiyle çarpma etkisi verir. |
| `SHR`, `>>` | Bitleri sağa kaydırır; küçük pozitif sayılarda ikiye bölme etkisi verir. |
| `ROL` | Bitleri sola döndürme yüzeyidir. |
| `ROR` | Bitleri sağa döndürme yüzeyidir. |

Örnek:

```basic
DIM x AS I32 = 8
PRINT x SHL 1
PRINT x SHR 1
```

Beklenen çıktı:

```text
16
4
```

## Logic16 ailesi

uXBasic operatör yüzeyinde klasik `AND`, `OR`, `NOT`, `XOR` ailesinin yanında Logic16 ailesi de yer alır. Bu aile, mantıksal ilişkiyi daha geniş bir doğruluk tablosu olarak düşünmek isteyen kullanıcı içindir.

| Operatör | Görev |
|---|---|
| `NAND` | `AND` sonucunun tersini üretir. |
| `NOR` | `OR` sonucunun tersini üretir. |
| `XNOR` | `XOR` sonucunun tersidir; iki değer aynıysa doğru kabul edilir. |
| `IMP` | Mantıksal gerektirme yüzeyidir. |
| `CIMP` | Ters yönlü gerektirme yüzeyidir. |
| `NIMP` | Gerektirmeme yüzeyidir. |
| `NCIMP` | Ters gerektirmeme yüzeyidir. |
| `IDA` | Birinci girdinin kimlik yüzeyidir. |
| `IDB` | İkinci girdinin kimlik yüzeyidir. |
| `NOTA` | Birinci girdinin tersini alır. |
| `NOTB` | İkinci girdinin tersini alır. |

Bu aile özellikle yapay zekâ, karar motoru, kural tablosu ve mantıksal devre düşüncesi için değerlidir. Kitapta Logic16, yalnız “ek operatörler” diye değil, programı doğruluk tablosu gibi düşünme tekniği olarak anlatılır.

Örnek karar fikri:

```basic
DIM a AS I32 = 1
DIM b AS I32 = 0

PRINT a NAND b
PRINT a NOR b
PRINT a XNOR b
```

## Pipe ve üçlü koşul

`|>` operatörü, bir değeri sonraki işlem zincirine aktarma fikrini temsil eder. Bu operatör kitapta akışlı düşünme bölümünde anlatılır. `?:` ise üçlü koşul ifadesi yüzeyidir; koşula göre iki değerden birini seçme fikrini taşır.

Syntax fikri:

```basic
sonuc = kosul ? dogruDeger : yanlisDeger
```

Bu yüzey, kısa karar ifadeleri için kullanılır. Büyük karar ağaçlarında `IF ... THEN ... ELSE ... END IF` daha okunaklıdır.

## Atama operatörleri

Atama operatörleri değeri değiştirir. Bu yüzden karşılaştırma operatörlerinden ayrıdır.

| Operatör | Anlamı |
|---|---|
| `=` | Sol taraftaki değişkene sağ taraftaki değeri atar. |
| `+=` | Değişkeni sağdaki değer kadar artırır. |
| `-=` | Değişkeni sağdaki değer kadar azaltır. |
| `*=` | Değişkeni sağdaki değerle çarpar. |
| `/=` | Değişkeni sağdaki değere böler. |
| `%=`, `\=` | Kalan veya tam bölme ailesi atamasına bağlanır. |
| `<<=`, `>>=` | Bit kaydırma sonucunu aynı değişkene yazar. |
| `**=` | Üs alma sonucunu aynı değişkene yazar. |

Örnek:

```basic
DIM toplam AS I32 = 10

toplam += 5
toplam *= 2

PRINT toplam
```

Beklenen çıktı:

```text
30
```

Bu örnek, `toplam = toplam + 5` ve `toplam = toplam * 2` biçimlerinin kısa yazımıdır.

## Operatör öncelik özeti

| Öncelik | Aile |
|---:|---|
| 150 | Alan erişimi, çağrı, indeks, postfix artırım/azaltım |
| 140 | Üs alma `**` |
| 130 | Tekli operatörler, `NOT`, işaret değiştirme |
| 120 | Çarpma, bölme, tam bölme, `MOD` |
| 110 | Toplama ve çıkarma |
| 100 | Kaydırma ve döndürme |
| 90 | Karşılaştırma |
| 80 | Bit `&` yüzeyi |
| 70 | `XOR` |
| 60 | Bit `|` yüzeyi |
| 50 | `AND`, `NAND`, `NIMP`, `NCIMP` |
| 45 | `XNOR` |
| 40 | `OR`, `NOR`, `IMP`, `CIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| 30 | Pipe `|>` |
| 20 | Üçlü koşul `?:` |
| 10 | Atama ailesi |

Bu tablo, ifade okurken hangi parçanın önce bağlanacağını gösterir. Fakat kitapta yalnız tabloya güvenilmez; her önemli operatör ailesi örnekle gösterilir.

---

# Preprocessor Referansı: Kaynağı Hedefe Hazırlama Dili

Preprocessor, uXBasic kaynak kodu parser katmanına ulaşmadan önce çalışan hazırlık katmanıdır. Bu katman sabit değerler kurabilir, koşullu bölümleri açıp kapatabilir, hedef platforma göre farklı kaynak parçaları seçebilir, HTML/JS/WAT blokları üretebilir, manifest bilgisi yazabilir ve asset dosyalarını hedef dizine bağlayabilir. Bu yüzden preprocessor yalnız “makro sistemi” değildir; kaynak kodun hedefe göre şekillendiği ilk kapıdır.

Kitapta preprocessor komutları tek tek listelenir; fakat asıl anlatım aileler üzerinden yürür. Çünkü `%%SET` tek başına anlamlıdır ama `%%IF` ile birleşince kaynak seçme gücü kazanır. `%%TARGET` tek başına hedef adını söyler ama `%%OUTDIR`, `%%HTML_BEGIN`, `%%JS_BEGIN` ve `%%ASSET_COPY` ile birleşince web projesi üretir.

## Değer ve sembol ailesi

| Komut | Görev |
|---|---|
| `%%SET` | Preprocess değişkenine değer atar. |
| `%%DEFINE` | Sembol veya kısa değer tanımlar. |
| `%%UNDEF` | Daha önce tanımlanmış sembolü kaldırır. |
| `%%EVAL` | Preprocess ifadesini hesaplayıp değer üretir. |

Temel örnek:

```basic
%%SET MOD = "DEBUG"
%%DEFINE LIMIT 100
%%EVAL IKI_LIMIT = LIMIT * 2

PRINT %%EVAL(IKI_LIMIT)
```

Beklenen çıktı fikri:

```text
200
```

Bu örnekte `LIMIT` sıradan runtime değişkeni değildir; kaynak derleyiciye gitmeden önce preprocessor tarafından değerlendirilir.

## Koşul ailesi

| Komut | Görev |
|---|---|
| `%%IF` | Preprocess koşulu doğruysa bölümü açar. |
| `%%IFC` | Tanımlı sembol veya koşul kontrolü için kullanılır. |
| `%%IFN` | Koşulun tersine göre bölüm seçer. |
| `%%ELIF` | Önceki koşul yanlışsa yeni koşul dener. |
| `%%ELSE` | Hiçbir koşul tutmazsa açılacak bölümü başlatır. |
| `%%ENDIF` | Koşul bloğunu kapatır. |

Örnek:

```basic
%%SET HEDEF = "KONSOL"

%%IF HEDEF == "KONSOL"
PRINT "Konsol hedefi"
%%ELSE
PRINT "Baska hedef"
%%ENDIF
```

Burada `IF` değil, `%%IF` kullanılır. `IF` runtime karar verir; `%%IF` kaynak kodu derleyiciye ulaşmadan önce seçer. Bu ayrım kitap boyunca korunur.

## Döngü ailesi

| Komut | Görev |
|---|---|
| `%%FOR` | Preprocess seviyesinde sayısal tekrar kurar. |
| `%%FOREACH` | Liste veya sembol kümesi üzerinde tekrar kurar. |
| `%%REPEAT` | Belirli sayıda kaynak tekrarı üretir. |
| `%%ENDFOR` | Preprocess döngüsünü kapatır. |
| `%%BREAK` | Preprocess döngüsünden çıkar. |
| `%%CONTINUE` | Sonraki preprocess tekrarına geçer. |

Örnek fikir:

```basic
%%FOREACH AD IN "A,B,C"
PRINT "{{AD}}"
%%ENDFOR
```

Bu yapı, üç ayrı `PRINT` satırını elle yazmak yerine kaynak üretme fikrini gösterir. Kitapta bu aile özellikle test, tablo üretme, benzer fonksiyon gövdeleri ve hedefe göre küçük varyasyonlar için önerilir.

## Hedef ve çıktı dizini ailesi

| Komut | Görev |
|---|---|
| `%%TARGET` | Üretim hedefini seçer: konsol, web, JS, WAT/WASM veya başka hedef ailesi. |
| `%%PLATFORM` | Platform bilgisini preprocess kararlarına taşır. |
| `%%DESTOS` | Hedef işletim sistemi bilgisini belirtir. |
| `%%PROFILE` | Build veya çıktı profilini seçer. |
| `%%OUTDIR` | Üretilecek dosyaların çıkış dizinini belirler. |

Örnek:

```basic
%%TARGET WEB
%%OUTDIR "dist/demo"

PRINT "WEB_ROUTE"
```

Bu örnek yalnız bir mesaj basmaz; kaynak dosyanın web hedefiyle ilişkilendirildiğini de belirtir.

## HTML, CSS ve JS blokları

| Komut | Görev |
|---|---|
| `%%HTML_BEGIN` / `%%HTML_END` | HTML çıktı bloğu açar ve kapatır. |
| `%%CSS_BEGIN` / `%%CSS_END` | CSS çıktı bloğu açar ve kapatır. |
| `%%JS_BEGIN` / `%%JS_END` | JS çıktı bloğu açar ve kapatır. |
| `%%JS_LINE` | Tek satırlık JS çıktı satırı üretir. |

Web örneği:

```basic
%%TARGET WEB
%%OUTDIR "dist/app"
%%SET TITLE = "uXBasic Web"

%%HTML_BEGIN "index.html" BODY
<h1>{{TITLE}}</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("uXBasic browser runtime");
%%JS_END

PRINT "WEB_ROUTE"
```

Bu örnekte HTML ve JS kodu doğrudan ana runtime komutlarıyla karıştırılmaz. Preprocessor, hedef dosyaları üretmek için ayrı bloklar açar. Böylece aynı kaynak dosyada hem uXBasic program akışı hem de web artefact üretimi bulunabilir.

## WAT ve WASM ailesi

| Komut | Görev |
|---|---|
| `%%WAT_BEGIN` / `%%WAT_END` | WAT çıktı bloğunu açar ve kapatır. |
| `%%WAT_FUNC_BEGIN` / `%%WAT_FUNC_END` | WAT fonksiyon bloğu kurar. |
| `%%WAT_IMPORT` | WASM tarafı import bildirimi üretir. |
| `%%WAT_EXPORT` | WASM export bildirimi üretir. |

WAT/WASM hedefleri kitapta MIR hattıyla birlikte anlatılır. Çünkü uXBasic’in hedef üretim fikrinde AST kaynak anlamını taşır, MIR ise hedefe inmeyi kolaylaştırır. Preprocessor bu hedef için gerekli raw veya yardımcı blokları hazırlayabilir.

## Asset ailesi

| Komut | Görev |
|---|---|
| `%%ASSET_ROOT` | Asset dosyalarının kök dizinini belirler. |
| `%%ASSET_FILE` | Tekil asset dosyasını tanımlar. |
| `%%ASSET_COPY` | Asset dosyasını çıktı dizinine kopyalama sözleşmesi kurar. |
| `%%ASSET_IMAGE` | Görsel asset bilgisini üretim hattına bildirir. |
| `%%ASSET_AUDIO` | Ses asset bilgisini üretim hattına bildirir. |

Örnek:

```basic
%%TARGET WEB
%%OUTDIR "dist/game"
%%ASSET_ROOT "assets"
%%ASSET_IMAGE "logo", "logo.png"
%%ASSET_COPY "logo.png"

PRINT "ASSET_ROUTE"
```

Bu örnek, oyun veya web programında kaynak dışı dosyaların nasıl düşünülmesi gerektiğini gösterir. Kod tek başına program değildir; görsel, ses, veri dosyası ve manifest de program paketinin parçasıdır.

## Güvenlik ve fail-close ailesi

| Komut | Görev |
|---|---|
| `%%ALLOW_RAW_JS` | Raw JS kullanımını hedefli ve bilinçli biçimde açar. |
| `%%ALLOW_RAW_WAT` | Raw WAT kullanımını hedefli biçimde açar. |
| `%%SAFE_PATHS` | Güvenli dosya yolları politikasını belirtir. |
| `%%REQUIRE_HOST_BINDING` | Host bağlamı gerektiren özellikleri açıkça ister. |

Bu ailede ana ilke şudur: hedefsiz raw kod serbest bırakılmaz. Kitapta güvenlik notu kuru bir uyarı olarak yazılmaz; nasıl kodlanacağı gösterilir.

Yanlış yaklaşım:

```basic
%%JS_BEGIN "program.js" RUNTIME
console.log("hedefsiz raw js");
%%JS_END
```

Doğru yaklaşım:

```basic
%%TARGET WEB
%%ALLOW_RAW_JS

%%JS_BEGIN "program.js" RUNTIME
console.log("hedefli raw js");
%%JS_END
```

## Manifest ve JSON ailesi

| Komut | Görev |
|---|---|
| `%%MANIFEST_SET` | Uygulama manifest değerini tanımlar. |
| `%%MANIFEST_REQUIRE` | Manifest içinde bulunması gereken alanı şart koşar. |
| `%%JSON_SET` | JSON değer alanı üretir. |
| `%%JSON_BEGIN` / `%%JSON_END` | JSON çıktı bloğu açar ve kapatır. |

Örnek:

```basic
%%MANIFEST_SET "name", "uxbasic-demo"
%%MANIFEST_SET "version", "1.0.0"
%%MANIFEST_REQUIRE "name"

PRINT "MANIFEST_READY"
```

Bu örnek, uygulama paketinin yalnız koddan oluşmadığını gösterir. Özellikle web, eklenti, modül ve dış araç paketlerinde manifest bilgisi üretim hattının parçasıdır.

## Preprocessor ve runtime IF farkı

Aşağıdaki iki yapı birbirine benzese de aynı işi yapmaz:

```basic
%%IF HEDEF == "WEB"
PRINT "WEB kaynakta acildi"
%%ENDIF
```

Bu karar derleme öncesi verilir.

```basic
IF hedef = "WEB" THEN
    PRINT "WEB runtime karar"
END IF
```

Bu karar program çalışırken verilir. Kitapta bu ayrım sürekli korunur. `%%IF` kaynak seçer, `IF` program akışını seçer.

---

# Project Pack Örnek Kütüphanesi

uXBasic kitabının örnekleri boşlukta yazılmaz. Ana örnek havuzu `xtestx/project_packs` dizinidir. Bu dizindeki her pack, dilin bir ailesini temsil eder. Kitapta komut anlatılırken önce bu packlerdeki çalışan örnekler aranır; gerekirse örnek geliştirilir ama kaynak sözdizimiyle uyum korunur.

Project pack sistemi kitabın güvenilirliğini artırır. Çünkü okuyucu yalnız anlatı görmez; o anlatının test ailesindeki karşılığını da görür. `pack_01` temel sayısal akışı, `pack_02` operatörleri, `pack_05` akış kontrolünü, `pack_25` iç içe fonksiyon çağrılarını, `pack_30` ise tam entegrasyon fikrini gösterir.

Aşağıdaki tablo, kitapta kullanılacak ana omurgayı gösterir.

| Pack | Kitapta Kullanıldığı Yer | Görev |
|---|---|---|
| `pack_01_core_numeric_flow` | İlk programlar, `DIM`, `AS`, atama, `PRINT` | Çekirdek sayısal akış kurar. |
| `pack_02_operators_logic_bit` | Operatör bölümü | Aritmetik, mantıksal ve bit düzeyi işlemleri gösterir. |
| `pack_03_strings_builtins` | String fonksiyonları | `LEN`, `MID`, `UCASE`, `LCASE`, `STR`, `VAL` gibi fonksiyon ailesini besler. |
| `pack_04_arrays_index_lvalue` | Dizi ve indeksleme | Dizi elemanına yazma, okuma ve lvalue davranışını gösterir. |
| `pack_05_control_flow_if_for` | `IF`, `FOR`, döngü ve karar | Koşul ve tekrar yapılarını birleştirir. |
| `pack_06_functions_recursion_include` | Fonksiyon, rekürsiyon, include | Fonksiyon çağrısı ve kendini çağırma mantığını gösterir. |
| `pack_07_type_record_structures` | `TYPE` ve kayıt | Alan erişimi ve kayıt tipi fikrini anlatır. |
| `pack_08_namespace_using_alias` | Namespace ve alias | İsim alanı, kısa ad ve kullanım rotasını gösterir. |
| `pack_09_class_oop_magic` | `CLASS`, `MAGIC`, OOP | Nesne yüzeyi ve özel davranış sözleşmesini gösterir. |
| `pack_10_file_io_channels` | Dosya işlemleri | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE` ailesini anlatır. |
| `pack_11_preprocessor_meta` | Preprocessor temel | Meta değişken, koşul ve çıktı fikrini besler. |
| `pack_12_preprocessor_include_foreach` | Include ve foreach | Preprocess döngüsü ve başlık ekleme fikrini gösterir. |
| `pack_13_import_c_cpp_asm` | `IMPORT(C/CPP/ASM)` | Derleme zamanı dış kaynak ekleme kararını gösterir. |
| `pack_14_ffi_winapi_routes` | FFI, DLL, WinAPI | `DECLARE LIB ALIAS` ve dış çağrı rotasını anlatır. |
| `pack_15_science_external_routes` | Bilimsel dış rota | JSON, regex, REST, hesap kütüphanesi gibi dış bağlantı fikrini besler. |
| `pack_16_big_extfp_canonical` | Büyük sayı | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `BIGINIT` ailesini gösterir. |
| `pack_17_memory_ptr_intrinsics` | Bellek ve pointer | `PEEK`, `POKE`, `PTR`, `SIZEOF` gibi düşük seviye yüzeyi gösterir. |
| `pack_18_event_thread_pipe_slot` | Modern akış | `EVENT`, `THREAD`, `PIPE`, `SLOT`, `PARALEL` ailesini gösterir. |
| `pack_19_browser_wasm_webgpu_route` | Web ve WASM | Browser, JS/WAT/WASM hedef rotasını gösterir. |
| `pack_20_module_main_using` | Module ve main | Modül, giriş noktası ve using mantığını gösterir. |
| `pack_21_input_line_file` | Dosya okuma | Satır ve dosya girdi ailesini gösterir. |
| `pack_22_error_try_catch_surface` | Hata yakalama | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` yüzeyini gösterir. |
| `pack_23_data_structures_list_dict_set` | Koleksiyonlar | `ARRAY`, `LIST`, `DICT`, `SET` veri yapısı yüzeyini gösterir. |
| `pack_24_math_time_random_surface` | Matematik ve zaman | `ABS`, `INT`, `SGN`, `SQR`, `RND`, `TIMER` ailesini gösterir. |
| `pack_25_nested_calls_expressions` | İç içe çağrı | Fonksiyon çağrılarının ifade ağacı içinde birleşmesini gösterir. |
| `pack_26_negative_raw_js_gate` | Güvenlik kapısı | Hedefsiz raw JS kullanımının kapatılmasını gösterir. |
| `pack_27_negative_include_cycle` | Include güvenliği | Döngüsel include durumunun yakalanmasını gösterir. |
| `pack_28_negative_semantic_unknown_symbol` | Semantic denetim | Bilinmeyen sembolün yakalanmasını gösterir. |
| `pack_29_negative_wrong_keywords` | Kanonik keyword | Yanlış keywordlerin reddedilmesini gösterir. |
| `pack_30_full_integration_project` | Tam entegrasyon | Birçok dil ailesini tek kaynakta birleştirir. |

Kitapta her örnek şu üç soruyu cevaplamalıdır:

```text
Bu örnek hangi komutu öğretiyor?
Bu örnek hangi önceki bilgiyi kullanıyor?
Bu örnek okuyucuyu hangi sonraki konuya hazırlıyor?
```

Örneğin `pack_01` yalnız `PRINT` örneği değildir. `DIM`, `AS`, atama, aritmetik ifade ve çıktı gözlemini aynı anda gösterir. Bu nedenle ilk bölümde kullanılır. `pack_25` ise fonksiyonlar bölümünün ileri kısmında kullanılır; çünkü iç içe çağrı, önce fonksiyon ve ifade mantığı öğrenilmeden verilirse okuyucuyu yorar.

Kitap örnekleri gerektiğinde testten daha açıklayıcı hâle getirilir. Fakat bu geliştirme kaynak sözleşmesini bozmaz. Testteki örnek kısa olabilir; kitapta aynı örnek açıklama değişkenleriyle genişletilebilir. Önemli olan syntaxın uXBasic kaynak gerçekliğiyle uyumlu kalmasıdır.

Örnek geliştirme ilkesi:

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
PRINT a + b
```

Bu test örneği kitapta şöyle büyütülebilir:

```basic
DIM yem AS I32 = 120
DIM balik AS I32 = 40
DIM oran AS I32

oran = yem / balik
PRINT oran
```

Beklenen çıktı:

```text
3
```

Burada komutlar değişmez; yalnız örnek okuyucunun zihninde daha canlı bir probleme bağlanır.

---

# Kaynak Yüzeyi ve Otomatik Ekler

uXBasic kitabı elle yazılmış paragraflardan oluşur; fakat kitabın referans ekleri yalnız elle tutulmamalıdır. Çünkü kaynak kod değiştikçe keyword listesi, statement dispatch yüzeyi, runtime servisleri, CLI seçenekleri ve project pack örnekleri de değişebilir. Bu nedenle kitap üretim hattında otomatik ek çıkarıcı bulunur.

Otomatik çıkarıcı şu dosyaları okur:

```text
src/parser/lexer/lexer_keyword_table.fbs
src/parser/parser/parser_stmt_registry.fbs
src/runtime/services/runtime_service_ids.fbs
src/cli/cli_registry_adim41.fbs
xtestx/project_packs/_expected/project_pack_manifest.json
```

Bu dosyalardan şu çıktılar üretilir:

```text
docs_build/book_source_surface.json
docs_build/generated/keyword_surface.md
docs_build/generated/statement_dispatch_surface.md
docs_build/generated/runtime_service_surface.md
docs_build/generated/cli_option_surface.md
docs_build/generated/project_pack_examples.md
```

Bu otomatik eklerin amacı ana kitabın yerini almak değildir. Ana kitap, komutları öğretici dille anlatır. Otomatik ekler ise kaynak yüzeyinin eksiksiz kontrolünü sağlar. Böylece kitapta `PRINT` komutu anlatılırken açıklama insan eliyle yazılır; fakat keyword listesi ve dispatch listesi kaynak koddan çekildiği için eksik kalmaz.

Kullanım:

```powershell
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --generated-dir docs_build\generated
python tools\docs\build_uxbasic_pck_book.py --root . --out docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md --include-generated
```

Bu iki komut birlikte çalıştığında önce kaynak yüzeyi çıkarılır, sonra kitap tek Markdown dosyasına derlenir.

Kitap üretim hattı şu ilkeye bağlıdır:

```text
Anlatım elle yazılır.
Referans yüzeyi kaynak koddan çekilir.
Örnek havuzu project packlerden beslenir.
Son kitap tek dosyada toplanır.
```

Bu ilke, kitabı hem okunabilir hem de güncellenebilir yapar.

---

# Lexer Keyword Cheat Sheet

Bu liste `src/parser/lexer/lexer_keyword_table.fbs` dosyasından çıkarılmıştır. Ana kitapta öğrenme sırası korunur; bu ek hızlı arama içindir.

`ABS`, `ABSTRACT`, `ALIAS`, `AND`, `ARRAY`, `AS`, `ASC`, `ASSERT`, `ATN`, `BALL`, `BIGD`, `BIGF`, `BOOLEAN`, `BYREF`, `BYVAL`, `CALL`, `CASE`, `CATCH`, `CDBL`, `CDECL`, `CHR`, `CIMP`, `CINT`, `CLASS`, `CLNG`, `CLOSE`, `CLS`, `CODEPTR`, `CODEVAR`, `COLOR`, `CONST`, `CONSTRUCTOR`, `COS`, `CSNG`, `DEC`, `DECLARE`, `DECORATOR`, `DEFBYT`, `DEFDBL`, `DEFEXT`, `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFSTR`, `DELETE`, `DESTRUCTOR`, `DICT`, `DIM`, `DO`, `EACH`, `ELSE`, `ELSEIF`, `END`, `ENUM`, `EOF`, `EQA`, `EQV`, `ERRPATH`, `ERRVAR`, `EVENT`, `EXIT`, `EXP`, `F128`, `F32`, `F64`, `F80`, `FALSE`, `FINAL`, `FINALLY`, `FIX`, `FOR`, `FRIEND`, `FUNCTION`, `GET`, `GETKEY`, `GOSUB`, `GOTO`, `I16`, `I32`, `I64`, `I8`, `IDA`, `IDB`, `IF`, `IFF`, `IMMUTABLE`, `IMP`, `IMPLEMENTS`, `IMPORT`, `IN`, `INC`, `INCLUDE`, `INKEY`, `INLINE`, `INPUT`, `INT`, `INTERFACE`, `IS`, `LCASE`, `LEN`, `LIST`, `LOCATE`, `LOF`, `LOG`, `LOOP`, `LPTR`, `LTRIM`, `MAGIC`, `MAIN`, `MEMCOPYB`, `MEMCOPYD`, `MEMCOPYW`, `MEMFILLB`, `MEMFILLD`, `MEMFILLW`, `METHOD`, `MID`, `MIXIN`, `MOD`, `MODULE`, `MUTABLE`, `NAMESPACE`, `NAND`, `NCIMP`, `NEW`, `NEXT`, `NIMP`, `NOR`, `NOT`, `NOTA`, `NOTB`, `NXOR`, `OBJECT`, `OFF`, `OFFSETOF`, `ON`, `ONE`, `OPEN`, `OPERATOR`, `OR`, `OUTPATH`, `OUTVAR`, `OVERRIDE`, `PARALEL`, `PEEKB`, `PEEKD`, `PEEKW`, `PIPE`, `POKE`, `POKEB`, `POKED`, `POKES`, `POKEW`, `PRINT`, `PRIVATE`, `PROPERTY`, `PROTECTED`, `PTR`, `PUBLIC`, `PUT`, `RANDOMIZE`, `READONLY`, `REDIM`, `RESTRICTED`, `RETURN`, `RND`, `ROL`, `ROR`, `RTRIM`, `RUNPATH`, `SADD`, `SEALED`, `SEEK`, `SELECT`, `SET`, `SETNEWOFFSET`, `SETSTRINGSIZE`, `SGN`, `SHELL`, `SHL`, `SHR`, `SIN`, `SIZEOF`, `SLOT`, `SPACE`, `SQR`, `SQRT`, `STATIC`, `STDCALL`, `STEP`, `STR`, `STRING`, `STRPTR`, `SUB`, `TAN`, `THEN`, `THREAD`, `THROW`, `TIMEOUT`, `TIMER`, `TO`, `TRIGGER`, `TRUE`, `TRY`, `TYPE`, `U16`, `U32`, `U64`, `U8`, `UCASE`, `UNTIL`, `USING`, `VAL`, `VARPTR`, `VIRTUAL`, `WEND`, `WHILE`, `XNOR`, `XOR`, `ZERO`

---

# Statement Dispatch Cheat Sheet

Bu liste `src/parser/parser/parser_stmt_registry.fbs` dosyasındaki dispatch girişlerinden çıkarılmıştır.

`ABSTRACT`, `ALIAS`, `ASSERT`, `CALL`, `CLASS`, `CLOSE`, `CLS`, `COLOR`, `CONST`, `DEC`, `DECLARE`, `DEFBYT`, `DEFDBL`, `DEFEXT`, `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFSTR`, `DELETE`, `DIM`, `DO`, `END`, `ENUM`, `EVENT`, `EXIT`, `FINAL`, `FOR`, `FUNCTION`, `GET`, `GOSUB`, `GOTO`, `IF`, `IMPORT`, `INC`, `INCLUDE`, `INLINE`, `INPUT`, `INPUTF`, `INTERFACE`, `LOCATE`, `MAIN`, `MEMCOPYB`, `MEMCOPYD`, `MEMCOPYW`, `MEMFILLB`, `MEMFILLD`, `MEMFILLW`, `MODULE`, `NAMESPACE`, `OFF`, `ON`, `OPEN`, `PARALEL`, `PIPE`, `POKE`, `POKEB`, `POKED`, `POKES`, `POKEW`, `PRINT`, `PUT`, `RANDOMIZE`, `REDIM`, `RETURN`, `SEALED`, `SEEK`, `SELECT`, `SETNEWOFFSET`, `SETSTRINGSIZE`, `SHELL`, `SLOT`, `SUB`, `THREAD`, `THROW`, `TRIGGER`, `TRY`, `TYPE`, `USING`, `WHILE`

---

# Runtime Service Cheat Sheet

Bu liste `src/runtime/services/runtime_service_ids.fbs` dosyasındaki runtime servis adlarından çıkarılmıştır.

`RT_API_CALL`, `RT_ARCHIVE_CALL`, `RT_AUDIO_CALL`, `RT_BROWSER_AUDIO`, `RT_BROWSER_CANVAS`, `RT_BROWSER_FETCH`, `RT_BROWSER_FILE`, `RT_BROWSER_INPUT`, `RT_CLS`, `RT_COLOR`, `RT_CRYPTO_CALL`, `RT_CURL_CALL`, `RT_DLL_CALL`, `RT_DLL_LOAD`, `RT_EXTFP_CALL`, `RT_FILE_CLOSE`, `RT_FILE_DELETE`, `RT_FILE_EOF`, `RT_FILE_LOF`, `RT_FILE_OPEN`, `RT_FILE_READ`, `RT_FILE_SEEK`, `RT_FILE_WRITE`, `RT_GETKEY`, `RT_GRAPHICS_CALL`, `RT_HOST_CALL`, `RT_HTTP_CALL`, `RT_IMAGE_CALL`, `RT_INKEY`, `RT_INLINE_NATIVE`, `RT_INPUT`, `RT_JSON_CALL`, `RT_LIBRARY_CALL`, `RT_LLAMA_CALL`, `RT_LOCATE`, `RT_LUA_CALL`, `RT_MATH_ABS`, `RT_MATH_ATN`, `RT_MATH_COS`, `RT_MATH_EXP`, `RT_MATH_FIX`, `RT_MATH_INT`, `RT_MATH_LOG`, `RT_MATH_SGN`, `RT_MATH_SIN`, `RT_MATH_SQRT`, `RT_MATH_TAN`, `RT_MEM_COPY`, `RT_MEM_FILL`, `RT_MEM_LOAD`, `RT_MEM_STORE`, `RT_ONNX_CALL`, `RT_OS_CALL`, `RT_PEEK`, `RT_POKE`, `RT_PRINT`, `RT_PROLOG_CALL`, `RT_RANDOMIZE`, `RT_REGEX_CALL`, `RT_RND`, `RT_SERVER_CALL`, `RT_SQLITE_CALL`, `RT_STRINGX_CALL`, `RT_STR_ASC`, `RT_STR_CHR`, `RT_STR_COMPARE`, `RT_STR_CONCAT`, `RT_STR_LEFT`, `RT_STR_LEN`, `RT_STR_LTRIM`, `RT_STR_MID`, `RT_STR_RIGHT`, `RT_STR_RTRIM`, `RT_STR_SPACE`, `RT_STR_STR`, `RT_STR_TO_LOWER`, `RT_STR_TO_UPPER`, `RT_STR_TRIM`, `RT_STR_VAL`, `RT_TIMER`, `RT_WASM_EXPORT_CALL`, `RT_WASM_IMPORT_CALL`, `RT_WEBGPU_CALL`

---

# CLI Option Cheat Sheet

Bu liste `src/cli/cli_registry_adim41.fbs` dosyasından çıkarılan seçenek adlarını içerir.

`--active-bind-plan-json-out`, `--active-bind-plan-txt-out`, `--adim25-26-27-close-gate`, `--adim25-27-close-gate`, `--all-diagnostics-json-out`, `--artifact-report-json-out`, `--artifact-root`, `--ast-contract-check`, `--ast-contract-json-out`, `--ast-contract-matrix-out`, `--ast-contract-report-json-out`, `--ast-exec-result-json-out`, `--ast-json-out`, `--ast-live-json-out`, `--ast-program-output-out`, `--ast-stderr-out`, `--ast-stdout-out`, `--ayikla`, `--backend-matrix-json-out`, `--backend-report-json-out`, `--browser-index-out`, `--build-x64`, `--build-x64-out`, `--canonical-mir-json-out`, `--codegen`, `--codegen-source`, `--console-mode`, `--debug`, `--debug-log-out`, `--debug-token-dump`, `--diag-format`, `--doc`, `--doc-json-out`, `--dump-ast`, `--dump-mir`, `--emit-browser`, `--emit-js`, `--emit-nasm`, `--emit-wasm`, `--emit-wat`, `--emit-x64-nasm`, `--emit-x64-nasm-out`, `--emit-x86`, `--enable-extfp-runtime`, `--enable-mir-x64`, `--error-language-file`, `--error-limit`, `--error-log-out`, `--error-summary-json-out`, `--error-to-terminal`, `--execmem`, `--extfp-diagnostics`, `--extfp-policy-json-out`, `--extfp-runtime-dir`, `--extfp-strict`, `--extract-src`, `--final-screen-json-out`, `--format-check`, `--help`, `--hir-inventory-json-out`, `--hir-json-out`, `--hook-trace`, `--html-out`, `--interop`, `--interpreter-backend`, `--interpreter-compare-json-out`, `--inventory-json-out`, `--ir-json-out`, `--js-out`, `--js-report-json-out`, `--js-runtime-out`, `--json-out`, `--language`, `--layer-timing-json-out`, `--layout-report-json-out`, `--lexer-diagnostics-json-out`, `--log-out`, `--manifest-out`, `--message-lang`, `--mir-exec-result-json-out`, `--mir-full-json-out`, `--mir-json-out`, `--mir-live-json-out`, `--mir-module-json-out`, `--mir-opcodes-json-out`, `--mir-opt-report-json-out`, `--mir-pipeline-json-out`, `--mir-program-output-out`, `--mir-stderr-out`, `--mir-stdout-out`, `--mir-surface-json-out`, `--mir-verify`, `--mir-verify-canonical-json-out`, `--mir-verify-json-out`, `--mir-verify-semantic-json-out`, `--mir-x64-required-opcode-gate-json-out`, `--original-source-out`, `--out-root`, `--parse-only`, `--parser-ast-json-out`, `--parser-diagnostics-json-out`, `--parser-json-out`, `--parser-surface-contract-json-out`, `--pipeline-json-out`, `--pp`, `--preprocess-result-json-out`, `--preprocessed-out`, `--preprocessor`, `--program-output-json-out`, `--program-output-out`, `--quiet`, `--release-gate`, `--release-json-out`, `--run-id`, `--run-manifest-json-out`, `--run-report-json-out`, `--runtime-route-matrix-json-out`, `--runtime-trace-json-out`, `--semantic`, `--semantic-diagnostics-json-out`, `--semantic-enums-json-out`, `--semantic-json-out`, `--semantic-layouts-json-out`, `--semantic-mir-json-out`, `--semantic-types-json-out`, `--semantik`, `--session-live-json-out`, `--sessiz`, `--source`, `--source-map`, `--source-map-json-out`, `--stderr-out`, `--stdout-out`, `--stop-after`, `--strict`, `--symbol-table-json-out`, `--target`, `--target-browser`, `--target-js`, `--target-wasm`, `--target-wat`, `--target-x86`, `--time-passes`, `--token-json-out`, `--tokens-json-out`, `--trace`, `--trace-json`, `--type-cast-report-json-out`, `--type-infer-report-csv-out`, `--type-table-json-out`, `--validate-all`, `--validate-all-fail-fast`, `--validate-all-report-json-out`, `--version`, `--vscode-diagnostics-json-out`, `--wasm-out`, `--wasm-report-json-out`, `--wasm-wat-out`, `--wat-out`, `--wat2wasm`, `--x64`, `--x64-ast-report-json-out`, `--x64-codegen-policy-json-out`, `--x64-mir-report-json-out`, `--x64-mode`, `--x64gen`, `--x64gen-out`

---

# Kaynak Keyword Grupları — 12.06_1

Bu tablo `lexer_keyword_table.fbs` yüzeyinden çıkarılmıştır. Ana kitapta görevler anlatılır; bu ek eksik kontrolü içindir.

Toplam benzersiz keyword: **220**

| Grup | Keywordler | Sayı |
|---:|---|---:|
| 1 | `IF`, `THEN`, `ELSE`, `ELSEIF`, `END`, `SELECT`, `CASE`, `IS` | 8 |
| 2 | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` | 5 |
| 3 | `EVENT`, `THREAD`, `PARALEL`, `PIPE`, `SLOT`, `ON`, `OFF`, `TRIGGER` | 8 |
| 4 | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `WEND`, `UNTIL`, `EXIT`, `EACH`, `IN` | 12 |
| 5 | `SUB`, `FUNCTION`, `DECLARE`, `RETURN`, `GOTO`, `GOSUB`, `CALL` | 7 |
| 6 | `TYPE`, `CLASS`, `INTERFACE`, `ENUM`, `IMPLEMENTS`, `METHOD`, `MAGIC`, `VIRTUAL`, `OVERRIDE`, `CONSTRUCTOR`, `DESTRUCTOR`, `NEW`, `DELETE`, `DIM`, `REDIM`, `AS`, `CONST`, `INCLUDE`, `IMPORT`, `ABSTRACT`, `FINAL`, `SEALED`, `STATIC`, `PROPERTY`, `OPERATOR`, `MIXIN`, `DECORATOR` | 27 |
| 7 | `PUBLIC`, `PRIVATE`, `PROTECTED`, `RESTRICTED`, `FRIEND`, `READONLY`, `MUTABLE`, `IMMUTABLE` | 8 |
| 8 | `MAIN`, `NAMESPACE`, `MODULE`, `USING`, `ALIAS` | 5 |
| 9 | `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT` | 7 |
| 10 | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK` | 7 |
| 11 | `CLS`, `COLOR`, `LOCATE` | 3 |
| 12 | `AND`, `OR`, `NOT`, `XOR`, `MOD`, `SHL`, `SHR`, `ROL`, `ROR`, `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` | 24 |
| 13 | `INLINE`, `SHELL`, `TIMEOUT`, `OUTVAR`, `ERRVAR`, `CODEVAR`, `RUNPATH`, `OUTPATH`, `ERRPATH` | 9 |
| 14 | `I8`, `U8`, `I16`, `U16`, `I32`, `U32`, `I64`, `U64`, `F32`, `F64`, `F80`, `F128`, `BIGF`, `BIGD`, `BALL`, `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`, `CDECL`, `STDCALL`, `TRUE`, `FALSE`, `ZERO`, `ONE` | 28 |
| 15 | `ARRAY`, `LIST`, `DICT`, `SET` | 4 |
| 16 | `SETSTRINGSIZE`, `TIMER`, `LOF`, `EOF`, `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`, `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`, `INKEY`, `GETKEY`, `VARPTR`, `SADD`, `LPTR`, `CODEPTR`, `SIZEOF`, `OFFSETOF` | 34 |
| 17 | `CINT`, `CLNG`, `CDBL`, `CSNG`, `FIX`, `SQR`, `RND`, `RANDOMIZE` | 8 |
| 18 | `PEEKB`, `PEEKW`, `PEEKD`, `POKE`, `POKEB`, `POKEW`, `POKED`, `POKES`, `MEMCOPYB`, `MEMCOPYW`, `MEMCOPYD`, `MEMFILLB`, `MEMFILLW`, `MEMFILLD`, `SETNEWOFFSET`, `INC`, `DEC` | 17 |
| 19 | `DIM`, `REDIM`, `CONST`, `FUNCTION`, `SUB`, `TYPE`, `CLASS`, `INTERFACE`, `ENUM`, `NAMESPACE`, `MODULE`, `ALIAS`, `USING`, `INCLUDE`, `PUBLIC`, `PRIVATE`, `PROTECTED`, `FRIEND`, `STATIC`, `ABSTRACT`, `FINAL`, `SEALED`, `PROPERTY`, `METHOD`, `OPERATOR` | 25 |
| 20 | `AS`, `BYVAL`, `BYREF`, `DECLARE` | 4 |

---

# 27. Derleyici Katmanlarından Sonuç Üreten Terminal Rehberi

uXBasic kitabı yalnızca komutların ne işe yaradığını anlatmaz; derleyicinin her katmanından nasıl çıktı alınacağını da gösterir. Çünkü modern bir dilde hata aramak, yalnızca programı çalıştırıp ekrana bakmak değildir. Kaynak dosyanın preprocess sonrası hâlini, token listesini, AST ağacını, HIR/MIR çıktısını, yorumlayıcı sonucunu ve hedef kod üretimini ayrı ayrı görmek gerekir. Bu bölüm, uXBasic kaynak dosyasını derleyici hattının her basamağından geçirip sonuç üreten terminal komutlarını verir.

Bu bölümdeki komutlar uXBasic kök klasöründe çalıştırılır. Örneklerde `.inook_layer_demo.uxb` adında küçük bir deneme dosyası oluşturulur ve bütün çıktılar `reportsook_layersook_layer_demo` altına yazılır. Böylece derleyici kaynaklarına dokunulmaz; yalnızca rapor, JSON, TXT, ASM, JS ve WAT gibi çıktı dosyaları üretilir.

## 27.1. Ortak hazırlık

Önce çıktı klasörleri hazırlanır ve deneme programı yazılır:

```powershell id="xpl3b1"
$Root = (Get-Location).Path
$Out  = Join-Path $Root "reports\book_layers\book_layer_demo"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Root "bin") | Out-Null

@'
%%SET MOD = "KITAP"
%%IF MOD == "KITAP"
PRINT "PREPROCESS_OK"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 20
DIM toplam AS I32

toplam = a + b

IF toplam >= 30 THEN
    PRINT "TOPLAM_OK"
ELSE
    PRINT "TOPLAM_HATA"
END IF

FUNCTION IkiKat(x AS I32) AS I32
    RETURN x * 2
END FUNCTION

PRINT IkiKat(toplam)
'@ | Set-Content -Encoding UTF8 .\bin\book_layer_demo.uxb
```

Bu program özellikle küçük tutulur. İçinde preprocess koşulu, değişken, atama, aritmetik ifade, `IF`, `FUNCTION`, `RETURN` ve `PRINT` bulunur. Böylece derleyicinin ön yüzü, AST, MIR ve yorumlayıcı hattı aynı dosya üzerinde görülebilir.

## 27.2. Derleyiciyi üretmek

Derleyici daha önce üretilmiş olsa bile kitap çalışmasında ilk kapı derlemedir:

```powershell id="fpg7uo"
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

Beklenen durum, `bin\uxb.exe` dosyasının oluşması ve derleme sonunda hata kalmamasıdır. Bu komut, kitapta anlatılan bütün terminal örneklerinin temelidir. Derleyici yoksa sonraki katmanlardan çıktı alınamaz.

## 27.3. Preprocessor A/B çıktısı almak

Preprocessor, kaynak dosya lexer katmanına gitmeden önce metni hazırlar. `%%SET`, `%%IF`, `%%TARGET`, `%%HTML_BEGIN`, `%%JS_BEGIN` gibi yönergeler bu aşamada anlam kazanır. uXBasic içinde A ve B preprocessor yolları vardır. A mevcut ana hat, B ise genişletilmiş blok ve hedef işleme hattı olarak düşünülür.

A hattı için:

```powershell id="zadv3c"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp A `
  --preprocessed-out "$Out\01_preprocessed_A.uxb" `
  --preprocess-result-json-out "$Out\01_preprocess_A.json"
```

B hattı için:

```powershell id="3bd3vl"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp B `
  --preprocessed-out "$Out\01_preprocessed_B.uxb" `
  --preprocess-result-json-out "$Out\01_preprocess_B.json"
```

Bu iki komutun ürettiği `preprocessed` dosyaları karşılaştırıldığında preprocess katmanının kaynak üzerindeki etkisi görülür. `PREPROCESS_OK` satırı koşul doğruysa kaynakta kalır; koşul kapalıysa çıkarılır. Bu sayede kitapta anlatılan `%%IF` ve `%%SET` yalnızca teorik kalmaz.

## 27.4. Lexer ve token çıktısı almak

Lexer, kaynak metni dilin tanıdığı küçük parçalara böler. `PRINT`, `DIM`, `AS`, `I32`, sayı, metin, operatör ve parantez artık metin değil token olur.

```powershell id="jmkep7"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp A `
  --debug-token-dump `
  --tokens-json-out "$Out\02_tokens.json" `
  --lexer-diagnostics-json-out "$Out\02_lexer_diag.json" `
  --preprocessed-out "$Out\02_preprocessed.uxb"
```

Bu çıktı özellikle anahtar kelime kitabı hazırlanırken değerlidir. Bir sözcük lexer tarafından keyword olarak tanınmıyorsa sonraki katmanlarda komut gibi davranamaz. Bu yüzden anahtar kelime cheat sheetleri hazırlanırken lexer yüzeyiyle karşılaştırma yapılır.

## 27.5. Parser ve AST çıktısı almak

Parser, token listesinden anlam ağacı kurar. `IF` artık düz metin değil, koşulu, doğru kolu ve yanlış kolu olan bir AST düğümüdür. `FUNCTION` gövdesi, parametreleri ve dönüş tipiyle birlikte AST içinde temsil edilir.

```powershell id="mver6y"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --parse-only `
  --ast-json-out "$Out\03_ast.json" `
  --parser-diagnostics-json-out "$Out\03_parser_diag.json"
```

AST çıktısı, kitabın komut anlatımında “bu komut kaynakta nasıl görünür, derleyici içinde hangi yapıya dönüşür?” sorusuna cevap verir. Örneğin `PRINT IkiKat(toplam)` satırı parser açısından iç içe çağrı ve çıktı komutunun birleşimidir.

## 27.6. AST sözleşme ve AST yorumlayıcı hattı

AST yalnızca yazdırılacak bir JSON değildir; uXBasic’te AST yorumlayıcı doğrudan bu ağaç üzerinden çalışabilir. Bu yol özellikle kaynak anlamını hızlı denemek için kullanılır.

```powershell id="m7t6a0"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --ast-contract-check `
  --ast-json-out "$Out\04_ast_contract_ast.json" `
  --ast-contract-json-out "$Out\04_ast_contract.json" `
  --ast-contract-matrix-out "$Out\04_ast_contract_matrix.json"
```

AST yorumlayıcı ile çalıştırma:

```powershell id="wmwp1q"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend AST `
  --stdout-out "$Out\05_ast_stdout.txt" `
  --stderr-out "$Out\05_ast_stderr.txt" `
  --run-report-json-out "$Out\05_ast_run_report.json"
```

Beklenen program çıktısı:

```text id="o2nifv"
PREPROCESS_OK
TOPLAM_OK
60
```

Bu çıktı, kaynak kodun AST yolundan çalıştırıldığını gösterir. Kitapta `AST çalışır` demek yerine, bu komutla AST yorumlayıcı sonucu üretilir.

## 27.7. Semantic ve HIR çıktısı almak

Semantic katman isimleri, tipleri, kapsamı ve çağrıları anlamlandırır. `toplam = a + b` satırında `a`, `b` ve `toplam` değişkenlerinin tanımlı olup olmadığı; `IkiKat(toplam)` çağrısında parametre uyumu bu katmanda anlam kazanır.

```powershell id="nyixic"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --semantic `
  --hir-json-out "$Out\06_hir.json" `
  --hir-inventory-json-out "$Out\06_hir_inventory.json"
```

HIR çıktısı, AST ile MIR arasındaki yüksek seviyeli ara katmandır. Kitapta tip, scope, fonksiyon ve çağrı anlatılırken semantic/HIR hattı bu yüzden ayrıca gösterilir.

## 27.8. MIR üretmek ve doğrulamak

MIR, hedef üretim omurgasıdır. AST kaynak anlamını taşır; MIR ise bu anlamı backendlerin daha kolay kullanacağı ara forma indirir. MIR yorumlayıcı, JS/WAT/WASM ve x64 üretim hattı bu düzeyden destek alır.

```powershell id="un8sq1"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --mir-verify `
  --mir-json-out "$Out\07_mir.json" `
  --mir-full-json-out "$Out\07_mir_full.json" `
  --mir-opcodes-json-out "$Out\07_mir_opcodes.json" `
  --mir-surface-json-out "$Out\07_mir_surface.json" `
  --mir-verify-json-out "$Out\07_mir_verify.json" `
  --mir-opt-report-json-out "$Out\07_mir_opt_report.json"
```

MIR çıktısı incelendiğinde `PRINT`, aritmetik işlem, koşullu dallanma ve fonksiyon çağrısı gibi yapılar artık backendin kullanacağı daha düz bir temsil hâline gelir.

## 27.9. MIR yorumlayıcı ile çalıştırmak

AST yorumlayıcı kaynak anlam ağacını çalıştırırken, MIR yorumlayıcı ara temsil üzerinden çalışır. Aynı program iki yorumlayıcıda da aynı sonucu üretmelidir.

```powershell id="5h3v0v"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend MIR `
  --mir-exec-result-json-out "$Out\08_mir_exec_result.json" `
  --mir-live-json-out "$Out\08_mir_live.json" `
  --mir-stdout-out "$Out\08_mir_stdout.txt" `
  --mir-stderr-out "$Out\08_mir_stderr.txt" `
  --mir-program-output-out "$Out\08_mir_program_output.txt" `
  --run-report-json-out "$Out\08_mir_run_report.json"
```

Beklenen program çıktısı yine aynıdır:

```text id="fmncdu"
PREPROCESS_OK
TOPLAM_OK
60
```

Bu eşitlik önemlidir. AST ve MIR aynı kaynak anlamını farklı yürütme yollarından doğrular.

## 27.10. AST ve MIR birlikte çalıştırmak

Karşılaştırmalı denetim için iki yorumlayıcı aynı komutla birlikte istenebilir:

```powershell id="9xsl20"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend BOTH `
  --stdout-out "$Out\09_both_stdout.txt" `
  --stderr-out "$Out\09_both_stderr.txt" `
  --run-report-json-out "$Out\09_both_run_report.json"
```

Bu komut kitap örneklerinin kalite kapısı için kullanışlıdır. Aynı örnek AST ve MIR tarafında tutarlıysa belgeye alınması daha güvenli olur.

## 27.11. x64 NASM çıktısı üretmek

x64 kod üretimi MIR seviyesindedir; AST’den kaynak anlamı ve yüksek seviye bilgi desteği alabilir. Ama üretim hattının omurgası MIR’dir.

```powershell id="qjdske"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --codegen-source MIR `
  --x64-mode MIR `
  --emit-x64-nasm `
  --emit-x64-nasm-out "$Out\10_book_layer_demo_x64.asm" `
  --backend-report-json-out "$Out\10_x64_backend_report.json"
```

Bu komut native assembly artefact üretir. Burada amaç programı hemen EXE yapmak değil, MIR’den x64 üretim yolunu görünür kılmaktır.

## 27.12. x64 build hattı

x64 build hattı için çıktı klasörü verilir:

```powershell id="df6bup"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --codegen-source MIR `
  --x64-mode MIR `
  --build-x64 `
  --build-x64-out "$Out\x64_build" `
  --backend-report-json-out "$Out\11_x64_build_report.json"
```

Bu komut, sistemde gerekli assembler/linker zinciri varsa native üretime ilerler. Kitapta bu bölüm anlatılırken “x64 MIR’den yürür” cümlesi bu komutla somutlanır.

## 27.13. JS hedefi üretmek

JS üretimi de MIR destekli backend hattındadır. Program browser veya JS çalışma zamanı için dışarıya dosya olarak verilebilir.

```powershell id="bckgsh"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-js `
  --js-out "$Out\12_program.js" `
  --js-runtime-out "$Out\12_uxb_runtime.js" `
  --backend-report-json-out "$Out\12_js_backend_report.json"
```

Bu çıktı, klasik BASIC kodunun JS hedefinde nasıl temsil edilebileceğini gösterir. Hedef JS olduğunda raw JS blokları yalnız güvenli hedef bağlamında kullanılmalıdır.

## 27.14. WAT/WASM hedefi üretmek

WAT, WebAssembly’nin metin biçimidir. uXBasic WAT/WASM hedefinde MIR tabanlı üretim hattından yararlanır.

```powershell id="2v7n3m"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-wat `
  --wat-out "$Out\13_program.wat" `
  --backend-report-json-out "$Out\13_wat_backend_report.json"
```

WASM çıktısı için:

```powershell id="y09ysj"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-wasm `
  --wasm-out "$Out\14_program.wasm" `
  --backend-report-json-out "$Out\14_wasm_backend_report.json"
```

WAT/WASM örnekleri kitapta yalnız web teknolojisi diye değil, derleyicinin hedefe inme gücü olarak anlatılır.

## 27.15. Browser artefact üretmek

Browser hedefi HTML, JS runtime ve isteğe göre WASM dosyalarını birlikte düşünebilir.

```powershell id="hxz66u"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-browser `
  --html-out "$Out\15_index.html" `
  --js-out "$Out\15_program.js" `
  --js-runtime-out "$Out\15_uxb_runtime.js" `
  --backend-report-json-out "$Out\15_browser_backend_report.json"
```

Bu komut, uXBasic’in yalnız konsol dili değil, hedef üreten bir dil olduğunu gösterir.

## 27.16. Project pack doğrulaması

Kitapta anlatılan ana omurga `xtestx/project_packs` ile bağlanır. Bu paketler dil yüzeyinin birlikte çalışmasını gösterir.

```powershell id="kdcdt5"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Odaklı bir paket çalıştırmak için:

```powershell id="gnltwh"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_30_full_integration_project
```

Kitabın her yeni örneği bu disipline yaklaşmalıdır: kaynak dosya, beklenen çıktı, rapor klasörü ve gerekirse JSON artefact.

## 27.17. Kaynak yüzeyi ve otomatik kitap eklerini üretmek

Kitap eklerinde keyword, statement dispatch, runtime service ve CLI option yüzeyleri otomatik çıkarılır:

```powershell id="6qmdew"
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
```

Ardından tek kitap yeniden üretilir:

```powershell id="3hq2ai"
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Bu iki komut, belgenin kaynak kodla bağlantısını korur. Kitap yalnız elle yazılmış bir metin değildir; kaynak yüzeyinden beslenen bir teknik belgedir.

## 27.18. Katman çıktılarının anlamı

| Çıktı | Katman | Ne Gösterir? |
|---|---|---|
| `preprocessed.uxb` | Preprocessor | Derleyiciye girecek son kaynak metni |
| `tokens.json` | Lexer | Keyword, sayı, string, operatör ve sembol parçaları |
| `ast.json` | Parser / AST | Kaynak anlam ağacı |
| `hir.json` | Semantic / HIR | Tip, kapsam ve yüksek seviye temsil |
| `mir.json` | MIR | Backend ve MIR yorumlayıcı omurgası |
| `mir_opcodes.json` | MIR opcode | Ara temsil komut aileleri |
| `ast_stdout.txt` | AST interpreter | AST üzerinden çalışma sonucu |
| `mir_program_output.txt` | MIR interpreter | MIR üzerinden çalışma sonucu |
| `program.js` | JS backend | JS hedef çıktısı |
| `program.wat` | WAT backend | WebAssembly text çıktısı |
| `program.wasm` | WASM backend | Binary WebAssembly çıktısı |
| `book_layer_demo_x64.asm` | x64 backend | MIR tabanlı native assembly çıktısı |

Bu tablo, kitabın teknik doğruluk ilkesini özetler. uXBasic’te bir komut yalnız kaynak satırı değildir; derleyici hattında birden fazla artefact üretir. Resmî teknik kitap bu artefactların adını, yerini ve görevini açıkça göstermelidir.

---

# 28. On Ayrı Proje Programı: Komutları Birleştirerek Öğrenme

Komutları tek tek öğrenmek gereklidir; fakat gerçek programcılık, komutları birleştirmeyi öğrenince başlar. Bu bölümde uXBasic için on ayrı küçük proje programı verilir. Her proje bir komut ailesini öne çıkarır, fakat yalnız o aileye kapanmaz. Değişken, operatör, koşul, döngü, fonksiyon, veri yapısı, dosya, preprocessor, backend ve dış çağrı fikirleri birbiriyle bağlanır.

Bu projeler, eski PCK belgelerinde çoğu zaman yalnız öneri olarak geçen konuları kod örneğine dönüştürür. Örnekler `docs_examples\book_projects` altında ayrı `.uxb` dosyaları olarak da verilir. Böylece okuyucu kitapta gördüğü programı dosya olarak alıp deneyebilir, değiştirebilir ve kendi örneğine çevirebilir.

## Proje 1 — Tank sıcaklık izleyici

Bu proje `DIM`, `AS`, dizi, `FOR`, `IF`, karşılaştırma operatörleri ve `PRINT` komutlarını birlikte kullanır. Amaç üç tankın sıcaklığını gezmek, güvenli aralık dışına çıkan tankları bildirmek ve ortalama sıcaklığı hesaplamaktır.

```basic id="5tfk52"
' Proje 1: Tank sicaklik izleyici
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 24
sicaklik(3) = 21

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)

    IF sicaklik(i) < 19 THEN
        PRINT "TANK_DUSUK"
    ELSEIF sicaklik(i) > 23 THEN
        PRINT "TANK_YUKSEK"
    ELSE
        PRINT "TANK_NORMAL"
    END IF
NEXT i

PRINT toplam / 3
```

Beklenen düşünce şudur: dizi ölçümleri tutar, döngü bütün tankları gezer, `IF` sıcaklığı sınıflandırır, toplam değişkeni ortalamaya hazırlanır. Aynı program daha sonra `FUNCTION SicaklikDurumu(...)` biçimine genişletilebilir.

Bu projedeki ana yapılar:

| Yapı | Görev |
|---|---|
| `DIM sicaklik(3) AS I32` | Üç elemanlı sayısal ölçüm dizisi kurar. |
| `FOR i = 1 TO 3` | Tankları sırayla gezer. |
| `IF / ELSEIF / ELSE` | Ölçümü düşük, normal veya yüksek sınıfına ayırır. |
| `toplam = toplam + sicaklik(i)` | Döngü içinde birikimli toplam alır. |

## Proje 2 — Yem stok ve maliyet hesaplayıcı

Bu proje değişken, fonksiyon, `RETURN`, çarpma, bölme ve koşullu uyarı kullanır. Amaç günlük yem tüketimini ve kaç günlük stok kaldığını hesaplamaktır.

```basic id="nw9nt3"
' Proje 2: Yem stok ve maliyet hesaplayici
FUNCTION GunlukYem(balikSayisi AS I32, gram AS I32) AS I32
    RETURN balikSayisi * gram
END FUNCTION

FUNCTION KalanGun(stokGram AS I32, gunlukGram AS I32) AS I32
    IF gunlukGram <= 0 THEN
        RETURN 0
    END IF
    RETURN stokGram / gunlukGram
END FUNCTION

DIM balik AS I32 = 250
DIM kisiBasiYem AS I32 = 12
DIM stok AS I32 = 90000

DIM gunluk AS I32
gunluk = GunlukYem(balik, kisiBasiYem)

PRINT gunluk
PRINT KalanGun(stok, gunluk)

IF KalanGun(stok, gunluk) < 10 THEN
    PRINT "STOK_AZ"
ELSE
    PRINT "STOK_YETERLI"
END IF
```

Bu programda iki fonksiyon vardır. `GunlukYem` saf hesap fonksiyonudur. `KalanGun` ise korumalı hesap yapar; günlük tüketim sıfır veya negatifse bölme yapmadan `0` döndürür. Bu, genç programcıya güvenli fonksiyon yazmayı öğretir.

## Proje 3 — Su kalite puanlayıcı

Bu proje mantıksal operatörleri kullanır. `AND`, `OR` ve `NOT` yalnız teorik sözcükler değildir; program kararını biçimlendirir.

```basic id="32pwwf"
' Proje 3: Su kalite puanlayici
DIM ph AS I32 = 7
DIM oksijen AS I32 = 8
DIM sicaklik AS I32 = 21

DIM phUygun AS I32
DIM oksijenUygun AS I32
DIM sicaklikUygun AS I32

phUygun = (ph >= 6) AND (ph <= 8)
oksijenUygun = oksijen >= 6
sicaklikUygun = (sicaklik >= 18) AND (sicaklik <= 23)

IF phUygun AND oksijenUygun AND sicaklikUygun THEN
    PRINT "SU_KALITESI_IYI"
ELSE
    PRINT "SU_KALITESI_KONTROL"
END IF

IF NOT oksijenUygun THEN
    PRINT "HAVALANDIRMA_AC"
END IF
```

Burada her ölçüm ayrı bir mantıksal değişkene bağlanır. Böyle yazmak uzun gibi görünür ama hata ayıklamayı kolaylaştırır. Tek satırda dev bir koşul yazmak yerine, koşulun parçaları adlandırılır.

## Proje 4 — Ölçüm dosyası yazma ve okuma

Bu proje `OPEN`, `PRINT #`, `INPUT #` ve `CLOSE` komutlarını gösterir. Dosya işlemlerinde `#` kanal numarasını belirtir.

```basic id="8tl1o9"
' Proje 4: Olcum dosyasi yazma ve okuma
OPEN "olcumler.txt" FOR OUTPUT AS #1
PRINT #1, "18"
PRINT #1, "21"
PRINT #1, "20"
CLOSE #1

OPEN "olcumler.txt" FOR INPUT AS #2
DIM a AS I32
DIM b AS I32
DIM c AS I32

INPUT #2, a
INPUT #2, b
INPUT #2, c
CLOSE #2

PRINT a + b + c
```

Dosya kanal mantığı önemlidir. `PRINT` ekrana yazar; `PRINT #1` ise bir numaralı dosya kanalına yazar. Bu ayrım tabloda kısa görünür ama programda gerçek fark yaratır.

## Proje 5 — TYPE ile ölçüm kaydı

Bu proje `TYPE` kullanarak birden çok değeri tek kayıt altında toplar. `TYPE`, yalnız veri saklamaz; veriye anlamlı bir biçim verir.

```basic id="k96be9"
' Proje 5: TYPE ile olcum kaydi
TYPE Olcum
    tank AS I32
    sicaklik AS I32
    oksijen AS I32
END TYPE

DIM o AS Olcum
o.tank = 1
o.sicaklik = 22
o.oksijen = 7

PRINT o.tank
PRINT o.sicaklik + o.oksijen

IF o.oksijen < 6 THEN
    PRINT "OKSIJEN_DUSUK"
ELSE
    PRINT "OKSIJEN_NORMAL"
END IF
```

`TYPE` bölümü anlatılırken bu örnek kullanılmalıdır. Çünkü `o.tank`, `o.sicaklik`, `o.oksijen` yazımı alan erişimini açıkça gösterir. Dizi ölçüm tutar; `TYPE` ise bir ölçümün iç yapısını taşır.

## Proje 6 — NAMESPACE ve ALIAS ile modüler hesap

Bu proje isim alanı kurmayı ve kısa ad vermeyi gösterir. Büyük projelerde aynı adlı fonksiyonların çakışmasını önlemek için `NAMESPACE` kullanılır. `ALIAS` ise uzun veya dışarıdan gelen adı daha okunur hâle getirir.

```basic id="0ayozw"
' Proje 6: Namespace ve alias ile moduler hesap
NAMESPACE SuHesap
    FUNCTION Ortalama(a AS I32, b AS I32, c AS I32) AS I32
        RETURN (a + b + c) / 3
    END FUNCTION

    FUNCTION Risk(sicaklik AS I32) AS I32
        IF sicaklik > 23 THEN
            RETURN 1
        END IF
        RETURN 0
    END FUNCTION
END NAMESPACE

USING SuHesap
ALIAS ORT AS Ortalama

DIM sonuc AS I32
sonuc = ORT(18, 21, 24)
PRINT sonuc
PRINT Risk(sonuc)
```

Bu örnek, `NAMESPACE`, `USING`, `ALIAS`, `FUNCTION`, `RETURN` ve `IF` komutlarını aynı bağlamda kullanır. Okuyucu modüler düşünmeyi tek başına anlatılan bir kavram olarak değil, çalışan fonksiyon düzeni olarak görür.

## Proje 7 — Preprocessor ile hedef seçen program

Bu proje preprocess komutlarının normal komutlardan farkını gösterir. `%%SET` ve `%%IF` derleme öncesi çalışır; kaynak metnin hangi parçalarının derleyiciye gideceğine karar verir.

```basic id="259q4g"
' Proje 7: Preprocessor ile hedef secimi
%%SET HEDEF = "KONSOL"

%%IF HEDEF == "KONSOL"
PRINT "KONSOL_HEDEFI"
%%ELSE
PRINT "DIGER_HEDEF"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 5
PRINT a * b
```

Bu programda `%%IF` çalışma zamanı koşulu değildir. Program çalışırken karar vermez; derleyiciye gitmeden önce kaynak metni seçer. Buna karşılık alttaki `PRINT a * b` normal çalışma zamanı ifadesidir.

Web hedefi genişletmesi:

```basic id="7ioih2"
%%TARGET WEB
%%OUTDIR "dist/preprocess_demo"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Preprocessor Web Ciktisi</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("WEB_PREPROCESS_OK");
%%JS_END

PRINT "WEB_ROUTE"
```

## Proje 8 — Büyük sayı ve geniş duyarlık gösterimi

Bu proje `BIGINIT`, `BIGI`, `BIGINT`, `BIGD`, `BIGF` ve `BALL` ailesini gösterir. Amaç büyük sayı fikrini sözde bırakmamak, doğrudan kullanım biçimini yazmaktır.

```basic id="xwffg2"
' Proje 8: Buyuk sayi ve genis duyarlik
PRINT BIGINIT(BIGI, "12345")
PRINT BIGINIT(BIGINT, "23456")
PRINT BIGINIT(BIGD, "12.50")
PRINT BIGINIT(BIGF, "3.5")
PRINT BIGINIT(BALL, "7.1")
```

Bu örnek sayısal aileleri yüzeyden gösterir. Kitapta geniş duyarlık anlatılırken şu fark açık yazılır: `I32` gibi tipler makine sayısıdır; `BIGI`, `BIGD`, `BIGF` ve `BALL` ailesi daha geniş sayı sözleşmesi için kullanılır.

## Proje 9 — Event, Thread, Pipe ve Paralel yüzeyi

Bu proje olay, iş parçacığı, veri akışı ve paralel iş kavramlarını aynı sayfada gösterir. Bu aile, uXBasic’in klasik BASIC çizgisinden modern çalışma modeline geçtiği yerdir.

```basic id="flj1hh"
' Proje 9: Event, thread, pipe ve paralel yuzeyi
EVENT Tick
    PRINT "EVENT_TICK"
END EVENT

THREAD Worker
    DIM i AS I32 = 1
    PRINT i
END THREAD

PIPE DataPipe item AS I32
    PRINT item
END PIPE

PARALEL Grup
    PRINT "PARALEL_BODY"
END PARALEL

PRINT "ASYNC_SURFACE_OK"
```

Bu örnek özellikle doğru keyword kararlarını pekiştirir. Doğru yazım `THREAD`, `PARALEL` ve `MAGIC` biçimidir. `THREAT`, `PARALLEL` ve `SIHIRLIMETOT` kitapta yalnız yanlış kullanım notu olarak geçmelidir.

## Proje 10 — Dış kaynak, DLL/API rotası ve güvenli imza

Bu proje `IMPORT`, `DECLARE LIB ALIAS` ve `CALL(DLL)` arasındaki farkı gösterir. Aynı aileye yakın görünseler de görevleri farklıdır.

```basic id="q8r4nb"
' Proje 10: Dis kaynak ve DLL/API rotasi
IMPORT(C, "native/math.c")
IMPORT(CPP, "native/engine.cpp")
IMPORT(ASM, "native/fast.asm")

DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" _
    (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

CALL(DLL, "kernel32.dll", "Beep", 800, 200)
CALL(API, "local", "healthcheck")

PRINT "DIS_CAGRI_ROTASI_OK"
```

Bu örnek üç ayrı kapıyı birbirinden ayırır. `IMPORT(C, ...)` derleme zamanı kaynak ekleme kapısıdır. `DECLARE FUNCTION ... LIB ... ALIAS ...` dış fonksiyonun imzasını bildirir. `CALL(DLL, ...)` çalışma zamanı DLL çağrı rotasını kurar. `CALL(API, ...)` ise API/servis rotasıdır. Kitapta bu ayrım kesin korunmalıdır.

## Projelerin birlikte öğrettiği ana harita

| Proje | Öne Çıkan Konu | Birleşen Yapılar |
|---|---|---|
| 1 | Dizi ve sıcaklık kontrolü | `DIM`, dizi, `FOR`, `IF`, karşılaştırma |
| 2 | Fonksiyonla hesap | `FUNCTION`, `RETURN`, bölme koruması |
| 3 | Mantıksal koşullar | `AND`, `OR`, `NOT`, adlandırılmış koşul |
| 4 | Dosya işlemleri | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE` |
| 5 | Kayıt tipi | `TYPE`, alan erişimi, koşul |
| 6 | Modüler yapı | `NAMESPACE`, `USING`, `ALIAS`, fonksiyon |
| 7 | Preprocessor | `%%SET`, `%%IF`, `%%TARGET`, web blokları |
| 8 | Büyük sayı | `BIGINIT`, `BIGI`, `BIGD`, `BIGF`, `BALL` |
| 9 | Modern çalışma yüzeyi | `EVENT`, `THREAD`, `PIPE`, `PARALEL` |
| 10 | Dış dünya | `IMPORT`, `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)` |

Bu on proje, kitabın komut referansını canlı hâle getirir. Okuyucu önce komutu tablodan görür, sonra projede görevini izler, sonra kendi programına taşır.

---

# 29. Nihai Referans: Komut, Fonksiyon, Operatör, Veri Tipi ve Veri Yapısı

Bu bölüm hızlı başvuru için yazılmıştır; fakat kuru liste değildir. Her aile önce görevine göre açıklanır, sonra sözdizimi ve örnekle bağlanır. uXBasic kitabında referans bölümü, okuyucuyu örneksiz bırakmamalıdır.

## 29.1. Temel giriş, çıkış ve değişken ailesi

| Sözcük | Syntax | Görev | Kısa Örnek |
|---|---|---|---|
| `PRINT` | `PRINT ifade` | Ekrana veya hedef çıktıya değer yazar. `PRINT #` biçimi dosya kanalına yazar. | `PRINT "OK"` |
| `DIM` | `DIM ad AS tip` | Değişken, dizi veya nesne alanı açar. | `DIM x AS I32 = 10` |
| `AS` | `ad AS tip` | Değişkenin, parametrenin veya fonksiyon dönüşünün tipini bağlar. | `FUNCTION F() AS I32` |
| `CONST` | `CONST ad AS tip = değer` | Program boyunca değişmeyen sabit tanımlar. | `CONST LIMIT AS I32 = 100` |
| `REDIM` | `REDIM dizi(yeniBoyut)` | Dizi boyutunu yeniden kurar. | `REDIM veri(20)` |
| `LET` | `LET ad = ifade` | Atamayı açık biçimde yazar; modern kullanımda doğrudan `ad = ifade` de kullanılır. | `LET x = 5` |
| `INPUT` | `INPUT değişken` | Kullanıcıdan veya `INPUT #` ile dosyadan değer alır. | `INPUT yas` |

Temel örnek:

```basic id="6ur8u5"
CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

IF okuma < LIMIT THEN
    PRINT "GUVENLI"
ELSE
    PRINT "LIMIT_ASILDI"
END IF
```

## 29.2. Akış kontrol ailesi

| Sözcük | Syntax | Görev | Birlikte Kullanılır |
|---|---|---|---|
| `IF` | `IF koşul THEN ... END IF` | Koşula göre program akışını kola ayırır. | `THEN`, `ELSEIF`, `ELSE` |
| `ELSEIF` | `ELSEIF koşul THEN` | İlk koşul yanlışsa yeni koşul dener. | `IF`, `ELSE`, `END IF` |
| `ELSE` | `ELSE` | Önceki koşulların hiçbiri doğru değilse çalışır. | `IF`, `ELSEIF` |
| `SELECT` | `SELECT CASE ifade` | Tek ifadeyi birçok olası duruma göre ayırır. | `CASE`, `CASE ELSE` |
| `CASE` | `CASE değer` | `SELECT` içinde eşleşme kolu açar. | `SELECT CASE` |
| `FOR` | `FOR i = a TO b STEP s` | Sayaçla tekrar eden döngü kurar. | `TO`, `STEP`, `NEXT` |
| `NEXT` | `NEXT i` | `FOR` döngüsünü ilerletir. | `FOR` |
| `DO` | `DO ... LOOP` | Koşullu veya koşulsuz döngü bloğu açar. | `LOOP`, `WHILE`, `UNTIL` |
| `WHILE` | `WHILE koşul` | Koşul doğru oldukça çalışır. | `WEND`, `DO` |
| `UNTIL` | `LOOP UNTIL koşul` | Koşul doğru olana kadar döngüyü sürdürür. | `DO`, `LOOP` |
| `EXIT` | `EXIT FOR`, `EXIT DO` | İçinde bulunulan döngü veya bloktan çıkar. | `FOR`, `DO`, `FUNCTION` |

Akış kontrolü yalnız karar vermek değildir; veri işleme düzenini kurar:

```basic id="h8wyxe"
DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 5
    toplam = toplam + i
NEXT i

IF toplam == 15 THEN
    PRINT "TOPLAM_DOGRU"
END IF
```

## 29.3. Fonksiyon ve çağrı ailesi

| Sözcük | Syntax | Görev |
|---|---|---|
| `FUNCTION` | `FUNCTION ad(parametreler) AS tip` | Değer döndüren adlandırılmış işlem bloğu kurar. |
| `SUB` | `SUB ad(parametreler)` | Değer döndürmeyen işlem bloğu kurar. |
| `RETURN` | `RETURN ifade` | Fonksiyondan değer döndürür veya bloktan çıkar. |
| `DECLARE` | `DECLARE FUNCTION ...` | Dış veya önceden bildirilecek fonksiyon imzasını tanımlar. |
| `CALL` | `CALL ad(...)`, `CALL(DLL,...)`, `CALL(API,...)` | Yerel, DLL veya API çağrı rotasını kullanır. |
| `BYVAL` | `BYVAL x AS tip` | Parametreyi değer olarak geçirir. |
| `BYREF` | `BYREF x AS tip` | Parametreyi referans/adres etkisiyle geçirir. |
| `CDECL` | `CDECL` | C çağrı düzeni bilgisini belirtir. |
| `STDCALL` | `STDCALL` | Windows API çağrı düzeni bilgisini belirtir. |

İç içe çağrı örneği:

```basic id="5pwrp3"
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

FUNCTION Mul(a AS I32, b AS I32) AS I32
    RETURN a * b
END FUNCTION

PRINT Add(Mul(2, 3), Add(4, 5))
```

Bu örnekte önce içteki çağrılar çözülür, sonra dıştaki `Add` çağrısı çalışır. AST bu yapıyı ağaç olarak taşır; MIR ise çağrı sırasını hedefe uygun ara temsil hâline getirir.

## 29.4. Operatör ailesi

| Aile | Operatörler | Görev |
|---|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` | Sayısal hesap yapar. |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` | İki değeri karşılaştırır. |
| Mantık | `AND`, `OR`, `NOT`, `XOR` | Koşul veya bit düzeyinde mantıksal işlem yapar. |
| Kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` | Bitleri sola, sağa veya döndürerek taşır. |
| Logic16 | `NAND`, `NOR`, `XNOR`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` | Genişletilmiş mantık kapısı ailesidir. |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `**=` | Değişkene yeni değer bağlar. |
| Pipe | `|>` | Bir işlemin sonucunu sonraki işleme aktarma yüzeyi kurar. |
| Üçlü | `?:` | Kısa koşullu ifade kurar. |

Karşılaştırma notu önemlidir. `=` bağlama göre atama veya koşul eşitliği olarak görülebilir. Daha açık karşılaştırma için `==` kullanmak güvenlidir.

```basic id="h93g0w"
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a + b
PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1

IF a >= b THEN
    PRINT "A_BUYUK"
END IF
```

## 29.5. Veri tipi ailesi

| Tip | Görev | Kullanım |
|---|---|---|
| `I8`, `I16`, `I32`, `I64` | İşaretli tam sayı ailesidir. | Sayaç, miktar, indis |
| `U8`, `U16`, `U32`, `U64` | İşaretsiz tam sayı ailesidir. | Bayt, maske, pozitif sayaç |
| `F32`, `F64`, `F80`, `F128` | Kayan nokta ailesidir. | Ölçüm, oran, bilimsel hesap |
| `BIGI`, `BIGINT` | Büyük tam sayı yüzeyidir. | Uzun tam sayı hesapları |
| `BIGD`, `BIGF`, `BALL` | Geniş duyarlık / büyük ondalık yüzeyidir. | Para, hassas ölçüm, uzun hesap |
| `BOOLEAN` | Doğru/yanlış değeri taşır. | Koşul, bayrak |
| `STRING` | Metin taşır. | Ad, mesaj, dosya satırı |
| `OBJECT` | Nesne yüzeyi taşır. | Sınıf, dış bağlama, genel nesne |
| `PTR`, `STRPTR` | Adres ve metin işaretçisi yüzeyidir. | Dış fonksiyon, bellek işlemleri |

Örnek:

```basic id="8sy6xp"
DIM sayac AS I32 = 10
DIM ad AS STRING = "uXBasic"
DIM aktif AS BOOLEAN = TRUE

PRINT ad
PRINT sayac
```

## 29.6. Veri yapısı ailesi

| Yapı | Syntax | Görev |
|---|---|---|
| Dizi | `DIM a(10) AS I32` | Aynı tipten çoklu değerleri indeksle saklar. |
| `TYPE` | `TYPE Ad ... END TYPE` | Alanlardan oluşan kayıt tipi tanımlar. |
| `CLASS` | `CLASS Ad ... END CLASS` | Veri ve davranışı birlikte taşıyan nesne tipi kurar. |
| `INTERFACE` | `INTERFACE Ad ... END INTERFACE` | Davranış sözleşmesi tanımlar. |
| `ARRAY` | `ARRAY OF tip` | Koleksiyon tip yüzeyi olarak dizi ailesini belirtir. |
| `LIST` | `LIST OF tip` | Sıralı büyüyebilir liste yüzeyi kurar. |
| `DICT` | `DICT OF anahtar, değer` | Anahtar-değer eşleme yüzeyi kurar. |
| `SET` | `SET OF tip` | Benzersiz eleman kümesi yüzeyi kurar. |
| `MODULE` | `MODULE Ad ... END MODULE` | Büyük kodu modül başlığı altında toplar. |
| `NAMESPACE` | `NAMESPACE Ad ... END NAMESPACE` | İsim çakışmasını önleyen kapsam alanı kurar. |

`TYPE` örneği:

```basic id="rsaf7e"
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

DIM p AS Nokta
p.x = 12
p.y = 30

PRINT p.x + p.y
```

`CLASS` ve `MAGIC` örneği:

```basic id="o8qk6n"
CLASS Anahtar
    VALUE AS I32

    MAGIC HASH() AS I32
        RETURN VALUE + 100
    END MAGIC

    MAGIC ADD(other AS I32) AS I32
        RETURN VALUE + other
    END MAGIC
END CLASS
```

Burada `MAGIC`, sınıf içinde özel davranış sözleşmesi açar. Bu bölümde `MAGIC` sıradan fonksiyon adı gibi değil, nesne davranış kapısı olarak anlatılır.

---

# 30. Preprocessor A/B ve Hedefli Derleme

uXBasic preprocessor, kaynak kodun derleyiciye gitmeden önceki aklını temsil eder. Normal komutlar program çalışırken davranır; preprocessor yönergeleri ise kaynak dosya daha lexer katmanına gitmeden önce çalışır. Bu yüzden `%%IF` ile `IF` aynı şey değildir. `IF` runtime karar yapısıdır; `%%IF` kaynak seçme yapısıdır.

uXBasic içinde preprocessor hattı iki ana seçenekle kullanılır:

```text id="h80vm1"
--pp A
--pp B
```

A hattı ana preprocess yoludur. B hattı genişletilmiş blok, web, manifest, asset ve hedef odaklı kullanım için tasarlanan ayrı yoldur. Kaynak içinde `%%PP B` benzeri seçimler veya CLI üzerinden `--pp B` kullanımı, kitapta hedefli preprocess örnekleri için özellikle anlatılır.

## 30.1. Değer tanımlama

| Yönerge | Syntax | Görev |
|---|---|---|
| `%%SET` | `%%SET AD = değer` | Meta değişken tanımlar veya değer atar. |
| `%%DEFINE` | `%%DEFINE AD değer` | Preprocess sembolü veya sabiti tanımlar. |
| `%%UNDEF` | `%%UNDEF AD` | Önceden tanımlanmış sembolü kaldırır. |
| `%%EVAL` | `%%EVAL AD = ifade` | Meta ifadeyi hesaplayıp sonuç üretir. |

Örnek:

```basic id="rqxmuw"
%%SET MOD = "DEBUG"
%%DEFINE LIMIT 100
%%EVAL CIFT_LIMIT = LIMIT * 2

%%IF MOD == "DEBUG"
PRINT "DEBUG_ACIK"
%%ENDIF
```

Bu örnekte `MOD`, `LIMIT` ve `CIFT_LIMIT` runtime değişkeni değildir. Bunlar kaynak hazırlanırken kullanılır.

## 30.2. Koşullu kaynak seçme

| Yönerge | Görev |
|---|---|
| `%%IF` | Koşul doğruysa bloğu kaynakta bırakır. |
| `%%IFC` | Koşullu kontrol için ek yüzey sağlar. |
| `%%IFN` | Olumsuz koşul kontrolü kurar. |
| `%%ELIF` | Önceki koşul yanlışsa yeni koşul dener. |
| `%%ELSE` | Hiçbir koşul sağlanmazsa seçilecek bloktur. |
| `%%ENDIF` | Koşullu preprocess bloğunu kapatır. |

Örnek:

```basic id="zm2upl"
%%SET HEDEF = "TEST"

%%IF HEDEF == "TEST"
PRINT "TEST_SURUMU"
%%ELIF HEDEF == "WEB"
PRINT "WEB_SURUMU"
%%ELSE
PRINT "NORMAL_SURUM"
%%ENDIF
```

Bu yapı, tek kaynak dosyadan farklı hedefler üretmeye yarar. Kitapta “öneri” olarak bırakılmaz; doğrudan bu örnekle gösterilir.

## 30.3. Döngülü preprocess

Preprocessor döngüleri tekrar eden kaynak parçalarını üretmek için kullanılır. Bu aile özellikle tablo, manifest, test dosyası, tekrar eden sabit ve hedef çıktısı oluştururken işe yarar.

| Yönerge | Görev |
|---|---|
| `%%FOR` | Sayısal veya sembolik tekrar başlatır. |
| `%%FOREACH` | Liste üzerinde tekrar kurar. |
| `%%REPEAT` | Belirli sayıda tekrar üretir. |
| `%%ENDFOR` | Döngü bloğunu kapatır. |
| `%%BREAK` | Preprocess döngüsünü erken keser. |
| `%%CONTINUE` | Sonraki preprocess tekrarına geçer. |

Kullanım fikri:

```basic id="aujrz0"
%%FOR I = 1 TO 3
PRINT "SATIR"
%%ENDFOR
```

Bu satırlar runtime `FOR` döngüsü değildir. Preprocessor bu bloğu kaynakta çoğaltır. Runtime döngüyle arasındaki fark kitapta özellikle vurgulanmalıdır.

## 30.4. Hedef seçme

| Yönerge | Görev |
|---|---|
| `%%TARGET` | Üretim hedefini belirtir: konsol, web, browser, wasm gibi. |
| `%%PLATFORM` | Platform bilgisini kaynak seçiminde kullanır. |
| `%%DESTOS` | Hedef işletim sistemi bilgisini taşır. |
| `%%PROFILE` | Debug, release, test gibi profil mantığını kurar. |
| `%%OUTDIR` | Üretilen artefactların çıkış klasörünü belirler. |

Örnek:

```basic id="sq8hd1"
%%TARGET WEB
%%PROFILE "DEBUG"
%%OUTDIR "dist/debug_web"

PRINT "HEDEF_WEB"
```

Bu örnek kaynak kodun kendisini değiştirmeden hedef bilgisini değiştirir. CLI tarafında aynı fikir `--target`, `--out-root`, `--artifact-root`, `--emit-js`, `--emit-wat`, `--emit-browser` gibi seçeneklerle tamamlanır.

## 30.5. HTML, CSS ve JS blokları

Web hedefinde preprocessor yalnız koşul seçmez; dosya üreten bloklar da açabilir.

| Yönerge | Görev |
|---|---|
| `%%HTML_BEGIN` / `%%HTML_END` | HTML artefact bloğu üretir. |
| `%%CSS_BEGIN` / `%%CSS_END` | CSS artefact bloğu üretir. |
| `%%JS_BEGIN` / `%%JS_END` | JS artefact bloğu üretir. |
| `%%JS_LINE` | Tek satırlık JS üretim yüzeyi sağlar. |

Örnek:

```basic id="6r10fc"
%%TARGET WEB
%%OUTDIR "dist/web_panel"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Panel</h1>
<div id="app"></div>
%%HTML_END

%%CSS_BEGIN "style.css"
body { font-family: sans-serif; }
%%CSS_END

%%JS_BEGIN "program.js" RUNTIME
console.log("PANEL_BASLADI");
%%JS_END

PRINT "WEB_ARTEFACT_OK"
```

Burada `PRINT` hâlâ uXBasic komutudur; HTML/CSS/JS blokları ise preprocess/backend artefact üretimiyle ilgilidir.

## 30.6. WAT/WASM blokları

| Yönerge | Görev |
|---|---|
| `%%WAT_BEGIN` / `%%WAT_END` | WAT metin bloğu açar ve kapatır. |
| `%%WAT_FUNC_BEGIN` / `%%WAT_FUNC_END` | WAT fonksiyon bloğu üretir. |
| `%%WAT_IMPORT` | WAT/WASM dış import tanımlar. |
| `%%WAT_EXPORT` | WAT/WASM dış export tanımlar. |

WAT örneği:

```basic id="jc5g9i"
%%TARGET WASM
%%OUTDIR "dist/wasm_demo"

%%WAT_BEGIN "module.wat"
(module
  (func $answer (result i32)
    i32.const 42)
  (export "answer" (func $answer))
)
%%WAT_END

PRINT "WAT_ROUTE"
```

Bu örnek WAT yüzeyini gösterir. Kitapta WAT/WASM hedefleri anlatılırken MIR destekli backend üretimiyle bu raw hedef blokları birbirinden ayırt edilmelidir.

## 30.7. Asset ve manifest ailesi

| Yönerge | Görev |
|---|---|
| `%%ASSET_ROOT` | Varlık dosyalarının kök klasörünü belirler. |
| `%%ASSET_FILE` | Tek dosyayı artefact listesine ekler. |
| `%%ASSET_COPY` | Varlık dosyasını çıktı klasörüne kopyalama yüzeyi kurar. |
| `%%ASSET_IMAGE` | Görsel varlık bildirir. |
| `%%ASSET_AUDIO` | Ses varlığı bildirir. |
| `%%MANIFEST_SET` | Manifest alanı yazar. |
| `%%MANIFEST_REQUIRE` | Zorunlu manifest alanı ister. |
| `%%JSON_SET` | JSON alanı üretir. |
| `%%JSON_BEGIN` / `%%JSON_END` | JSON blok üretimi yapar. |

Örnek:

```basic id="mdcnr7"
%%TARGET WEB
%%OUTDIR "dist/assets_demo"
%%ASSET_ROOT "assets"
%%ASSET_IMAGE "logo.png"
%%MANIFEST_SET name = "uXBasicDemo"
%%JSON_SET version = "12.06_1"

PRINT "ASSET_MANIFEST_OK"
```

Bu aile özellikle browser, oyun, eğitim aracı veya küçük web paneli üretirken kullanılır.

## 30.8. Güvenlik ve kapı yönergeleri

Raw JS, raw WAT, include ve host binding gibi alanlar güçlüdür; bu yüzden güvenlik kapılarıyla birlikte düşünülür.

| Yönerge | Görev |
|---|---|
| `%%ALLOW_RAW_JS` | Raw JS bloklarının kullanılmasına izin kapısı açar. |
| `%%ALLOW_RAW_WAT` | Raw WAT bloklarının kullanılmasına izin kapısı açar. |
| `%%SAFE_PATHS` | Güvenli dosya yolu sınırlarını belirtir. |
| `%%REQUIRE_HOST_BINDING` | Host tarafında gerekli bağlamı şart koşar. |

Kural şudur: hedefsiz raw kod serbest bırakılmaz. Bu kitap, güçlü kapıları gizlemez; fakat her güçlü kapının hangi hedef ve izinle kullanılacağını açık yazar.

---

# 31. Backend ve Artefact Üretim Rehberi

uXBasic’in güçlü tarafı yalnız kaynak kodu yorumlamak değildir. Aynı kaynak, hedefe göre farklı artefactlar üretebilir. Bu bölümde AST, MIR, runtime ve backend ilişkisi üzerinden JS, WAT/WASM ve x64 üretim hattı anlatılır.

Ana ilke değişmez:

```text id="og7vwe"
AST kaynak anlamını taşır.
MIR hedef üretim omurgasıdır.
AST interpreter AST üzerinden çalışır.
MIR interpreter MIR üzerinden çalışır.
JS, WAT/WASM ve x64 üretimi MIR seviyesinden destek alır.
x64 kod üretimi MIR seviyesindedir; AST kaynak anlamıyla yardımcı olur.
```

## 31.1. AST ve MIR farkını örnekle görmek

Kaynak kod:

```basic id="tz59ck"
DIM a AS I32 = 10
DIM b AS I32 = 20
PRINT a + b
```

AST bu kodu kaynak anlamına yakın taşır: değişken tanımı, atama, ifade ve `PRINT` düğümü vardır. MIR ise hedef üreticinin daha kolay kullanacağı ara işlemler üretir: değer yükleme, toplama, çıktı servisine gönderme gibi daha düz bir yapı oluşur.

AST çıktısı almak:

```powershell id="mwj187"
.\bin\uxb.exe .\bin\demo.uxb --parse-only --ast-json-out reports\ast.json
```

MIR çıktısı almak:

```powershell id="3h6m94"
.\bin\uxb.exe .\bin\demo.uxb --mir-verify --mir-json-out reports\mir.json --mir-opcodes-json-out reports\mir_opcodes.json
```

Bu iki çıktı aynı programı farklı gözle gösterir. Kitapta derleyici mimarisi anlatılırken bu fark temel alınır.

## 31.2. AST interpreter ve MIR interpreter

AST yorumlayıcı doğrudan AST üzerinden yürür:

```powershell id="21bo9j"
.\bin\uxb.exe .\bin\demo.uxb --execmem --interpreter-backend AST --stdout-out reports\ast_stdout.txt
```

MIR yorumlayıcı MIR üzerinden yürür:

```powershell id="u63ngh"
.\bin\uxb.exe .\bin\demo.uxb --execmem --interpreter-backend MIR --mir-program-output-out reports\mir_output.txt
```

İkisi aynı çıktıyı üretmelidir. Fark, yürütme yolundadır.

## 31.3. JS hedefi

JS hedefi için:

```powershell id="w85572"
.\bin\uxb.exe .\bin\demo.uxb --emit-js --js-out dist\program.js --js-runtime-out dist\uxb_runtime.js
```

Bu komut JS dosyası üretir. JS hedefi anlatılırken iki ayrı yol karıştırılmaz: uXBasic komutlarının JS’e çevrilmesi ayrı, preprocess ile raw JS bloğu yazılması ayrıdır.

## 31.4. Browser hedefi

Browser hedefi HTML ve JS artefactlarını birlikte düşünebilir:

```powershell id="6ekqty"
.\bin\uxb.exe .\bin\demo.uxb --emit-browser --html-out dist\index.html --js-out dist\program.js --js-runtime-out dist\uxb_runtime.js
```

Preprocessor web bloklarıyla birlikte örnek:

```basic id="01qeps"
%%TARGET WEB
%%OUTDIR "dist/browser_demo"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Browser</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("BROWSER_OK");
%%JS_END

PRINT "WEB_ROUTE"
```

## 31.5. WAT/WASM hedefi

WAT üretmek:

```powershell id="ieha43"
.\bin\uxb.exe .\bin\demo.uxb --emit-wat --wat-out dist\program.wat
```

WASM üretmek:

```powershell id="3c9qzr"
.\bin\uxb.exe .\bin\demo.uxb --emit-wasm --wasm-out dist\program.wasm
```

WAT/WASM hedefi, uXBasic’in web ve taşınabilir çalışma hedeflerine uzanan yüzüdür. MIR bu hedeflere inme noktasında ana omurgadır.

## 31.6. x64 hedefi

x64 NASM üretmek:

```powershell id="4xe3wn"
.\bin\uxb.exe .\bin\demo.uxb --codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out dist\demo_x64.asm
```

x64 build denemesi:

```powershell id="q8ug04"
.\bin\uxb.exe .\bin\demo.uxb --codegen-source MIR --x64-mode MIR --build-x64 --build-x64-out dist\x64_build
```

Bu komutlar kitapta native hedef anlatılırken kullanılmalıdır. x64 üretiminde ana fikir, kaynak kodun önce MIR’e inmesi ve x64 üreticinin bu MIR bilgisinden assembly üretmesidir.

## 31.7. Artefact klasör düzeni

Kitap örneklerinde çıktıların dağılmaması için şu düzen önerilir:

```text id="lsm0r7"
reports/
  book_layers/
    demo_adı/
      frontend/
      ast/
      hir/
      mir/
      execution/
      backend/

dist/
  demo_adı/
    program.js
    program.wat
    program.wasm
    demo_x64.asm
    index.html
```

Bu düzen, kullanıcıya “çıktı nereye gitti?” sorusunun cevabını verir.

---

# 32. Test Disiplini ve Belge Kalite Kapısı

Resmî teknik kitap, kaynak koddan koparsa kısa sürede eskiyen bir metne dönüşür. Bu yüzden uXBasic kitabında her ana bölüm, mümkün olduğunda test, örnek veya derleyici artefactı ile desteklenir. Kitapta yazılan örneklerin amacı güzel görünmek değildir; kaynak gerçekliğiyle bağ kurmaktır.

## 32.1. Project pack ana kapısı

Ana kapı şudur:

```powershell id="11fbwg"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut, project pack örneklerinin genel durumunu verir. Kitabın omurgası bu paketlerden beslenir. Pack 30 tam entegrasyon örneği, dil yüzeylerinin birlikte nasıl kullanıldığını gösterdiği için özel değerdedir.

## 32.2. Odaklı test kapısı

Bir bölüm yazılırken ilgili pack ayrıca çalıştırılabilir:

```powershell id="wu9v13"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_16_big_extfp_canonical
```

Örneğin büyük sayı bölümü yazılıyorsa pack 16, tam entegrasyon bölümü yazılıyorsa pack 30 çalıştırılır.

## 32.3. Expected test kapısı

Expected testler, kaynak dosya ve beklenen çıktı ilişkisini denetler:

```powershell id="rsb8ak"
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut özellikle kitap örnekleri çoğaldığında önem kazanır. Her yeni örnek ileride expected test havuzuna bağlanabilir.

## 32.4. Belge örneklerini çalıştırma disiplini

Kitap örnekleri için önerilen düzen:

```text id="xo7en2"
docs_examples/
  book_projects/
    project_01_tank_sicaklik.uxb
    project_02_yem_stok.uxb
    ...
```

Örnek çalıştırma:

```powershell id="5r9upk"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb --execmem --interpreter-backend AST
```

MIR ile çalıştırma:

```powershell id="7ru5qq"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb --execmem --interpreter-backend MIR
```

JSON artefact almak:

```powershell id="li7vxj"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb `
  --ast-json-out reports\book_examples\project_01_ast.json `
  --mir-json-out reports\book_examples\project_01_mir.json `
  --run-report-json-out reports\book_examples\project_01_run.json
```

Bu komutlar, kitap örneklerini yalnız metin olmaktan çıkarır.

## 32.5. Kitap üretim kapısı

Kaynak yüzeyi çıkarılır:

```powershell id="3mtilw"
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
```

Tek kitap üretilir:

```powershell id="zcwjsu"
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Bu iki komut, belge üretimini tekrar edilebilir hâle getirir.

## 32.6. Belge kalite kuralları

Kitaba yeni bölüm eklenirken şu kapılar uygulanır:

| Kapı | Soru |
|---|---|
| Görev kapısı | Bu bölüm okuyucuya ne yaptırıyor? |
| Syntax kapısı | Komutun yazılış biçimi açık mı? |
| Örnek kapısı | Öneri kodla gösterildi mi? |
| Katman kapısı | AST, MIR, runtime veya backend ilişkisi doğru mu? |
| Tekrar kapısı | Aynı cümle başka bölümde aynı görevle tekrar ediyor mu? |
| Kaynak kapısı | Anahtar kelime ve CLI bilgisi 12.06_1 yüzeyiyle uyumlu mu? |

Bu kapılar kitabı canlı tutar. uXBasic büyüdükçe kitap da büyür; fakat tekrar ederek değil, yeni görev açıklayarak büyür.

---

# Dış Kütüphaneler Ana Bölümü

Bu bölüm uXBasic’in `libsx` dış kütüphane wrapper yüzeyini resmi kitap içine taşır. Amaç yalnız modül adlarını saymak değildir; her wrapper fonksiyonunun ne yaptığı, hangi parametreleri aldığı, ne döndürdüğü, hangi DLL veya native sembole bağlandığı ve program içinde nasıl kullanılacağı ayrı ayrı açıklanır.

Bu baskıda dış kütüphane belgeleri `18` wrapper dosyasından üretilmiştir. Toplam `552` fonksiyon/sub yüzeyi ayrıntılı olarak anlatılır. `uxllamax` placeholder gibi imzasız dosyalar da gelecek genişleme noktası olarak görünür tutulur.

Dış kütüphane zinciri genel olarak şöyledir:

```text
uXBasic kaynak kodu
    ↓
INCLUDE ile wrapper dosyası
    ↓
Wrapper fonksiyon/sub
    ↓
CALL(DLL, ...) runtime rotası
    ↓
ux*.dll / native runtime / dış motor
```

| Modül | Wrapper dosyası | Namespace | Fonksiyon sayısı | Ana görev |
|---|---|---|---:|---|
| `uxaimath` | `libsx/uxaimath/uxaimath.bas` | `uxaimath` | 46 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxcollections` | `libsx/uxcollections/uxcollections.bas` | `uxcollections` | 27 | liste, yığın, kuyruk, sözlük, set ve ağaç koleksiyonları |
| `uxdataframe` | `libsx/uxdataframe/uxdataframe.bas` | `uxdataframe` | 31 | DuckDB tabanlı tablo, SQL ve veri çerçevesi işlemleri |
| `uxdataset` | `libsx/uxdataset/uxdataset.bas` | `uxdataset` | 34 | eğitim veri kümesi, batch, ölçekleme ve CSV akışı |
| `uxgraph` | `libsx/uxgraph/uxgraph.bas` | `uxgraph` | 30 | graf, kenar, yol, bileşen ve ağ ölçümleri |
| `uxllama` | `libsx/uxllama/uxllama.bas` | `uxllama` | 17 | yerel LLM, prompt çalıştırma ve düşük bellek profili |
| `uxllamax_placeholder` | `libsx/uxllamax/UXLLAMAX_PLACEHOLDER.bas` | `-` | 0 | yerel LLM, prompt çalıştırma ve düşük bellek profili |
| `uxmath` | `libsx/uxmath/uxmath.bas` | `-` | 9 | vektör, sayısal yardımcı ve ham veri yüzeyi |
| `uxmathcore` | `libsx/uxmathcore/uxmathcore.bas` | `-` | 51 | tipli buffer, ham bellek ve temel matematik çekirdeği |
| `uxmatrix` | `libsx/uxmatrix/uxmatrix.bas` | `uxmatrix` | 34 | matris ve OpenBLAS destekli sayısal hesap |
| `uxnn` | `libsx/uxnn/uxnn.bas` | `uxnn` | 33 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxnn2` | `libsx/uxnn2/uxnn2.bas` | `uxnn2` | 23 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxnn3` | `libsx/uxnn3/uxnn3.bas` | `uxnn3` | 33 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxonnx` | `libsx/uxonnx/uxonnx.bas` | `uxonnx` | 21 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxonnx2` | `libsx/uxonnx2/uxonnx2.bas` | `uxonnx2` | 42 | yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları |
| `uxstats` | `libsx/uxstats/uxstats.bas` | `-` | 27 | istatistik, hipotez testi ve veri analizi |
| `uxstats2` | `libsx/uxstats/uxstats2.bas` | `-` | 56 | istatistik, hipotez testi ve veri analizi |
| `uxtensor` | `libsx/uxtensor/uxtensor.bas` | `uxtensor` | 38 | tensor, çok boyutlu dizi ve temel lineer cebir |

Her modülün kendi belgesi `docs_src/external_libraries/` altında bulunur. Her modül için ayrıca `docs_examples/external_libraries/` altında uzun REM açıklamalı kullanım örnekleri üretilir.

---

# Dış Kütüphane Referansı: `uxaimath`

`uxaimath` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxaimath/uxaimath.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`
- **Veri doldurma ve okuma:** `ApplySigmoidPtr`, `ApplyTanhPtr`, `ApplyReLUPtr`, `ApplyLeakyReLUPtr`, `ApplyELUPtr`, `ApplyGELUPtr`, `ApplySwishPtr`, `SoftmaxPtr`, `SoftmaxInPlacePtr`
- **Hesaplama/analiz:** `Seed`, `Sigmoid`, `ReLU`, `LeakyReLU`, `ELU`, `GELU`, `Swish`, `Softplus`, `TensorSigmoid`, `TensorTanh`, `TensorReLU`, `TensorLeakyReLU` ve 23 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Seed` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Sigmoid` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ReLU` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `LeakyReLU` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ELU` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GELU` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `Swish` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Softplus` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `ApplySigmoidPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplyTanhPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ApplyReLUPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplyLeakyReLUPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplyELUPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ApplyGELUPtr` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ApplySwishPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SoftmaxPtr` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `SoftmaxInPlacePtr` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `TensorSigmoid` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorTanh` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorReLU` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorLeakyReLU` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorGELU` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorSoftmax` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `MSE` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MAE` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Huber` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BinaryCrossEntropy` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `CategoricalCrossEntropy` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MSEGrad` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `BCEGrad` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `FillZeros` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillOnes` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillUniform` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillNormal` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `XavierUniform` | `SUB` | `-` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `HeUniform` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ClipValue` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ClipNorm` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `SGDUpdate` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MomentumUpdate` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DenseForward` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `DenseBatchForward` | `SUB` | `-` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `ArgMax` | `FUNCTION` | `I64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `BinaryAccuracy` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Backend`

**İmza:** `FUNCTION Backend() AS STRING`

**Görev:** Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS STRING
sonuc = Backend()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Seed`

**İmza:** `SUB Seed(seed AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_seed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
Seed(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `Sigmoid`

**İmza:** `FUNCTION Sigmoid(x AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sigmoid`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Sigmoid(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `ReLU`

**İmza:** `FUNCTION ReLU(x AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_relu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = ReLU(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `LeakyReLU`

**İmza:** `FUNCTION LeakyReLU(x AS F64, alpha AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_leaky_relu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = LeakyReLU(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `ELU`

**İmza:** `FUNCTION ELU(x AS F64, alpha AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_elu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = ELU(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `GELU`

**İmza:** `FUNCTION GELU(x AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_gelu`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = GELU(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `Swish`

**İmza:** `FUNCTION Swish(x AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_swish`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Swish(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Softplus`

**İmza:** `FUNCTION Softplus(x AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softplus`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Softplus(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `ApplySigmoidPtr`

**İmza:** `SUB ApplySigmoidPtr(dataPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sigmoid_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplySigmoidPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `ApplyTanhPtr`

**İmza:** `SUB ApplyTanhPtr(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_tanh_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyTanhPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ApplyReLUPtr`

**İmza:** `SUB ApplyReLUPtr(dataPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyReLUPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `ApplyLeakyReLUPtr`

**İmza:** `SUB ApplyLeakyReLUPtr(dataPtr AS U64, n AS I64, alpha AS F64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_leaky_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyLeakyReLUPtr(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `ApplyELUPtr`

**İmza:** `SUB ApplyELUPtr(dataPtr AS U64, n AS I64, alpha AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_elu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyELUPtr(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `ApplyGELUPtr`

**İmza:** `SUB ApplyGELUPtr(dataPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_gelu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplyGELUPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `ApplySwishPtr`

**İmza:** `SUB ApplySwishPtr(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_swish_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ApplySwishPtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SoftmaxPtr`

**İmza:** `SUB SoftmaxPtr(inputPtr AS U64, outputPtr AS U64, n AS I64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softmax_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
SoftmaxPtr(h, h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `SoftmaxInPlacePtr`

**İmza:** `SUB SoftmaxInPlacePtr(dataPtr AS U64, n AS I64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softmax_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
SoftmaxInPlacePtr(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `TensorSigmoid`

**İmza:** `SUB TensorSigmoid(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sigmoid_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorSigmoid(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `TensorTanh`

**İmza:** `SUB TensorTanh(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_tanh_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorTanh(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `TensorReLU`

**İmza:** `SUB TensorReLU(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorReLU(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `TensorLeakyReLU`

**İmza:** `SUB TensorLeakyReLU(t AS U64, alpha AS F64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_leaky_relu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorLeakyReLU(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `TensorGELU`

**İmza:** `SUB TensorGELU(t AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_gelu_inplace_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorGELU(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `TensorSoftmax`

**İmza:** `SUB TensorSoftmax(src AS U64, dst AS U64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `src`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `dst`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_softmax_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
TensorSoftmax(h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `MSE`

**İmza:** `FUNCTION MSE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_mse_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = MSE(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `MAE`

**İmza:** `FUNCTION MAE(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_mae_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = MAE(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `Huber`

**İmza:** `FUNCTION Huber(yTruePtr AS U64, yPredPtr AS U64, n AS I64, delta AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `delta`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_huber_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = Huber(h, h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `BinaryCrossEntropy`

**İmza:** `FUNCTION BinaryCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_bce_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = BinaryCrossEntropy(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `CategoricalCrossEntropy`

**İmza:** `FUNCTION CategoricalCrossEntropy(yTruePtr AS U64, yPredPtr AS U64, n AS I64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_cce_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = CategoricalCrossEntropy(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `MSEGrad`

**İmza:** `SUB MSEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_mse_grad_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
MSEGrad(h, h, h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `BCEGrad`

**İmza:** `SUB BCEGrad(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_bce_grad_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
BCEGrad(h, h, h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `FillZeros`

**İmza:** `SUB FillZeros(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_zero_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillZeros(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `FillOnes`

**İmza:** `SUB FillOnes(dataPtr AS U64, n AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_one_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillOnes(h, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `FillUniform`

**İmza:** `SUB FillUniform(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lo`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `hi`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_uniform_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillUniform(h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `FillNormal`

**İmza:** `SUB FillNormal(dataPtr AS U64, n AS I64, mean AS F64, stddev AS F64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `mean`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `stddev`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_fill_normal_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
FillNormal(h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `XavierUniform`

**İmza:** `SUB XavierUniform(dataPtr AS U64, n AS I64, fanIn AS I64, fanOut AS I64)`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `fanIn`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `fanOut`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_xavier_uniform_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
XavierUniform(h, 1, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `HeUniform`

**İmza:** `SUB HeUniform(dataPtr AS U64, n AS I64, fanIn AS I64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `fanIn`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_he_uniform_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
HeUniform(h, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `ClipValue`

**İmza:** `SUB ClipValue(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lo`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `hi`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_clip_value_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ClipValue(h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `ClipNorm`

**İmza:** `SUB ClipNorm(dataPtr AS U64, n AS I64, maxNorm AS F64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `maxNorm`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_clip_norm_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
ClipNorm(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `SGDUpdate`

**İmza:** `SUB SGDUpdate(paramPtr AS U64, gradPtr AS U64, n AS I64, lr AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `paramPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `gradPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_sgd_update_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
SGDUpdate(h, h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `MomentumUpdate`

**İmza:** `SUB MomentumUpdate(paramPtr AS U64, gradPtr AS U64, velocityPtr AS U64, n AS I64, lr AS F64, momentum AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `paramPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `gradPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `velocityPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `momentum`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_momentum_update_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
MomentumUpdate(h, h, h, 1, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 43. `DenseForward`

**İmza:** `SUB DenseForward(inputPtr AS U64, weightPtr AS U64, biasPtr AS U64, outputPtr AS U64, inN AS I64, outN AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `weightPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `biasPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_dense_forward_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DenseForward(h, h, h, h, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 44. `DenseBatchForward`

**İmza:** `SUB DenseBatchForward(xPtr AS U64, weightPtr AS U64, biasPtr AS U64, yPtr AS U64, batch AS I64, inN AS I64, outN AS I64)`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `xPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `weightPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `biasPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `batch`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outN`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_dense_batch_forward_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DenseBatchForward(h, h, h, h, 1, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 45. `ArgMax`

**İmza:** `FUNCTION ArgMax(dataPtr AS U64, n AS I64) AS I64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `dataPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_argmax_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS I64
sonuc = ArgMax(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 46. `BinaryAccuracy`

**İmza:** `FUNCTION BinaryAccuracy(yTruePtr AS U64, yPredPtr AS U64, n AS I64, threshold AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `yTruePtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPredPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `threshold`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXAIMATH_DLL`, yerel sembol `uxaimath_binary_accuracy_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxaimath/uxaimath.bas"
USING uxaimath
DIM sonuc AS F64
sonuc = BinaryAccuracy(h, h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxaimath/uxaimath_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxcollections`

`uxcollections` bölümü uXBasic’in liste, yığın, kuyruk, sözlük, set ve ağaç koleksiyonları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxcollections/uxcollections.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`
- **Handle yaşam döngüsü:** `ListNew`, `ListFree`, `StackNew`, `StackFree`, `QueueNew`, `QueueFree`, `DictNew`, `DictFree`, `SetNew`, `SetFree`, `TreeNew`, `TreeFree`
- **Veri doldurma ve okuma:** `ListCount`, `ListPushF64`, `ListGetF64`, `StackPushF64`, `StackPopF64`, `QueuePushF64`, `QueuePopF64`, `DictSetF64`, `DictGetF64`, `SetAdd`, `SetContains`, `TreeSetF64` ve 1 işlev daha
- **Hesaplama/analiz:** `DictHas`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `ListNew` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `ListFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `ListCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ListPushF64` | `SUB` | `-` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `ListGetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `StackNew` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `StackFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `StackPushF64` | `SUB` | `-` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `StackPopF64` | `FUNCTION` | `F64` | Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür. |
| `QueueNew` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `QueueFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `QueuePushF64` | `SUB` | `-` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `QueuePopF64` | `FUNCTION` | `F64` | Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür. |
| `DictNew` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `DictFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `DictSetF64` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `DictGetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `DictHas` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SetNew` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SetFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `SetAdd` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetContains` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TreeNew` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TreeFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `TreeSetF64` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TreeGetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxcollections_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `ListNew`

**İmza:** `FUNCTION ListNew() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_list_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS U64
sonuc = ListNew()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `ListFree`

**İmza:** `SUB ListFree(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_list_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
ListFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `ListCount`

**İmza:** `FUNCTION ListCount(h AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_list_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS I64
sonuc = ListCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `ListPushF64`

**İmza:** `SUB ListPushF64(h AS U64, x AS F64)`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_list_push_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
ListPushF64(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `ListGetF64`

**İmza:** `FUNCTION ListGetF64(h AS U64, idx AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_list_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS F64
sonuc = ListGetF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `StackNew`

**İmza:** `FUNCTION StackNew() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_stack_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS U64
sonuc = StackNew()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `StackFree`

**İmza:** `SUB StackFree(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_stack_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
StackFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `StackPushF64`

**İmza:** `SUB StackPushF64(h AS U64, x AS F64)`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_stack_push_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
StackPushF64(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `StackPopF64`

**İmza:** `FUNCTION StackPopF64(h AS U64) AS F64`

**Görev:** Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_stack_pop_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS F64
sonuc = StackPopF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `QueueNew`

**İmza:** `FUNCTION QueueNew() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_queue_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS U64
sonuc = QueueNew()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `QueueFree`

**İmza:** `SUB QueueFree(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_queue_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
QueueFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `QueuePushF64`

**İmza:** `SUB QueuePushF64(h AS U64, x AS F64)`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_queue_push_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
QueuePushF64(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `QueuePopF64`

**İmza:** `FUNCTION QueuePopF64(h AS U64) AS F64`

**Görev:** Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_queue_pop_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS F64
sonuc = QueuePopF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `DictNew`

**İmza:** `FUNCTION DictNew() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_dict_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS U64
sonuc = DictNew()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `DictFree`

**İmza:** `SUB DictFree(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_dict_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DictFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `DictSetF64`

**İmza:** `SUB DictSetF64(h AS U64, key AS STRING, x AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_dict_set_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DictSetF64(h, "demo", 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `DictGetF64`

**İmza:** `FUNCTION DictGetF64(h AS U64, key AS STRING) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_dict_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS F64
sonuc = DictGetF64(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `DictHas`

**İmza:** `FUNCTION DictHas(h AS U64, key AS STRING) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_dict_has`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS I32
sonuc = DictHas(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `SetNew`

**İmza:** `FUNCTION SetNew() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_set_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS U64
sonuc = SetNew()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `SetFree`

**İmza:** `SUB SetFree(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_set_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
SetFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `SetAdd`

**İmza:** `SUB SetAdd(h AS U64, key AS STRING)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_set_add`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
SetAdd(h, "demo")
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `SetContains`

**İmza:** `FUNCTION SetContains(h AS U64, key AS STRING) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_set_contains`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS I32
sonuc = SetContains(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `TreeNew`

**İmza:** `FUNCTION TreeNew() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_tree_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS U64
sonuc = TreeNew()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `TreeFree`

**İmza:** `SUB TreeFree(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_tree_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
TreeFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `TreeSetF64`

**İmza:** `SUB TreeSetF64(h AS U64, key AS STRING, x AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `x`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_tree_set_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
TreeSetF64(h, "demo", 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `TreeGetF64`

**İmza:** `FUNCTION TreeGetF64(h AS U64, key AS STRING) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `key`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXCOLLECTIONS_DLL`, yerel sembol `uxc_tree_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxcollections/uxcollections.bas"
USING uxcollections
DIM sonuc AS F64
sonuc = TreeGetF64(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxcollections/uxcollections_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxcollections/uxcollections_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxcollections/uxcollections_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxcollections/uxcollections_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxcollections/uxcollections_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxdataframe`

`uxdataframe` bölümü uXBasic’in DuckDB tabanlı tablo, SQL ve veri çerçevesi işlemleri için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxdataframe/uxdataframe.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `RuntimeVersion`, `DuckDBAvailable`, `DuckDBVersion`, `LastError`
- **Handle yaşam döngüsü:** `OpenMemory`, `OpenDatabase`, `Free`, `LoadCSV`, `LoadParquet`, `MatrixFree`
- **Veri doldurma ve okuma:** `RowCount`, `ColCount`, `ColName`, `GetF64`, `GetText`, `SelectCols`, `MatrixRows`, `MatrixCols`, `MatrixDataPtr`, `MatrixGet`
- **Hesaplama/analiz:** `Exec`, `Query`, `Head`, `Filter`, `OrderBy`, `Describe`, `GroupMean`, `JoinInner`, `ToParquet`, `ToF64Matrix`
- **Dışa aktarma ve temizlik:** `ToCSV`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `RuntimeVersion` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `DuckDBAvailable` | `FUNCTION` | `I32` | Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder. |
| `DuckDBVersion` | `FUNCTION` | `STRING` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `OpenMemory` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `OpenDatabase` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `LoadCSV` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `LoadParquet` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `Exec` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Query` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `RowCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ColCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ColName` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `GetText` | `FUNCTION` | `STRING` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Head` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SelectCols` | `FUNCTION` | `U64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Filter` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `OrderBy` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Describe` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GroupMean` | `FUNCTION` | `U64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `JoinInner` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ToCSV` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `ToParquet` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `ToF64Matrix` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `MatrixFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `MatrixRows` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `MatrixCols` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `MatrixDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `MatrixGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `RuntimeVersion`

**İmza:** `FUNCTION RuntimeVersion() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_runtime_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = RuntimeVersion()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `DuckDBAvailable`

**İmza:** `FUNCTION DuckDBAvailable() AS I32`

**Görev:** Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_duckdb_available`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = DuckDBAvailable()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `DuckDBVersion`

**İmza:** `FUNCTION DuckDBVersion() AS STRING`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_duckdb_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = DuckDBVersion()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `LastError`

**İmza:** `FUNCTION LastError(df AS U64) AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = LastError(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `OpenMemory`

**İmza:** `FUNCTION OpenMemory() AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_open_memory`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = OpenMemory()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `OpenDatabase`

**İmza:** `FUNCTION OpenDatabase(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_open_database`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = OpenDatabase("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `Free`

**İmza:** `SUB Free(df AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `LoadCSV`

**İmza:** `FUNCTION LoadCSV(path AS STRING, header AS I32) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `header`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_load_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = LoadCSV("demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `LoadParquet`

**İmza:** `FUNCTION LoadParquet(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_load_parquet`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = LoadParquet("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Exec`

**İmza:** `FUNCTION Exec(df AS U64, sql AS STRING) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_exec`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = Exec(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `Query`

**İmza:** `FUNCTION Query(df AS U64, sql AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_query`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Query(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `RowCount`

**İmza:** `FUNCTION RowCount(df AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_row_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I64
sonuc = RowCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ColCount`

**İmza:** `FUNCTION ColCount(df AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_col_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = ColCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `ColName`

**İmza:** `FUNCTION ColName(df AS U64, col AS I32) AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_col_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = ColName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `GetF64`

**İmza:** `FUNCTION GetF64(df AS U64, row AS I64, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS F64
sonuc = GetF64(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `GetText`

**İmza:** `FUNCTION GetText(df AS U64, row AS I64, col AS I32) AS STRING`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_get_text`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS STRING
sonuc = GetText(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `Head`

**İmza:** `FUNCTION Head(df AS U64, n AS I64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_head`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Head(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SelectCols`

**İmza:** `FUNCTION SelectCols(df AS U64, columns AS STRING) AS U64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `columns`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_select`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = SelectCols(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `Filter`

**İmza:** `FUNCTION Filter(df AS U64, whereSql AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `whereSql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_filter`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Filter(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `OrderBy`

**İmza:** `FUNCTION OrderBy(df AS U64, orderSql AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `orderSql`: `STRING` sorgu/metin ifadesi. Dış motor bu metni yorumlar; bu yüzden tırnak ve kaçış kuralları dikkatli yazılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_order_by`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = OrderBy(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `Describe`

**İmza:** `FUNCTION Describe(df AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_describe`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = Describe(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `GroupMean`

**İmza:** `FUNCTION GroupMean(df AS U64, groupCol AS STRING, valueCol AS STRING) AS U64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groupCol`: `STRING` metin parametresi.
- `valueCol`: `STRING` metin parametresi.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_group_mean`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = GroupMean(h, "demo", "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `JoinInner`

**İmza:** `FUNCTION JoinInner(leftDf AS U64, rightDf AS U64, leftKey AS STRING, rightKey AS STRING) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `leftDf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `rightDf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `leftKey`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `rightKey`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_join_inner`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = JoinInner(h, h, "demo", "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `ToCSV`

**İmza:** `FUNCTION ToCSV(df AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_to_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = ToCSV(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `ToParquet`

**İmza:** `FUNCTION ToParquet(df AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_to_parquet`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = ToParquet(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `ToF64Matrix`

**İmza:** `FUNCTION ToF64Matrix(df AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `df`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_to_f64_matrix`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = ToF64Matrix(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `MatrixFree`

**İmza:** `SUB MatrixFree(m AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
MatrixFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `MatrixRows`

**İmza:** `FUNCTION MatrixRows(m AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I64
sonuc = MatrixRows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `MatrixCols`

**İmza:** `FUNCTION MatrixCols(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_cols`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS I32
sonuc = MatrixCols(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `MatrixDataPtr`

**İmza:** `FUNCTION MatrixDataPtr(m AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS U64
sonuc = MatrixDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `MatrixGet`

**İmza:** `FUNCTION MatrixGet(m AS U64, row AS I64, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATAFRAME_DLL`, yerel sembol `uxdf_matrix_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataframe/uxdataframe.bas"
USING uxdataframe
DIM sonuc AS F64
sonuc = MatrixGet(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxdataframe/uxdataframe_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxdataset`

`uxdataset` bölümü uXBasic’in eğitim veri kümesi, batch, ölçekleme ve CSV akışı için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxdataset/uxdataset.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`
- **Handle yaşam döngüsü:** `Create`, `Free`, `Clone`, `LoadCSV`, `ScalerFree`, `BatchCreate`, `BatchFree`
- **Veri doldurma ve okuma:** `RowCount`, `InputDim`, `TargetDim`, `XPtr`, `YPtr`, `GetX`, `SetX`, `GetY`, `SetY`, `ScalerInverseTransform`, `BatchReset`, `BatchRows` ve 4 işlev daha
- **Hesaplama/analiz:** `Shuffle`, `SplitTrain`, `SplitTest`, `ScalerFitStandard`, `ScalerFitMinMax`, `ScalerTransform`, `FillMissingMean`, `BatchNext`
- **Dışa aktarma ve temizlik:** `SaveCSV`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Create` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `Clone` | `FUNCTION` | `U64` | Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır. |
| `LoadCSV` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `SaveCSV` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `RowCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TargetDim` | `FUNCTION` | `I32` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `XPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `YPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GetX` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetX` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GetY` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetY` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Shuffle` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SplitTrain` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SplitTest` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ScalerFitStandard` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ScalerFitMinMax` | `FUNCTION` | `U64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `ScalerFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `ScalerTransform` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ScalerInverseTransform` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `FillMissingMean` | `SUB` | `-` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `BatchCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `BatchFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `BatchReset` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BatchNext` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BatchRows` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `BatchXPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BatchYPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BatchGetX` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `BatchGetY` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Backend`

**İmza:** `FUNCTION Backend() AS STRING`

**Görev:** Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS STRING
sonuc = Backend()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Create`

**İmza:** `FUNCTION Create(rows AS I32, inputDim AS I32, targetDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `rows`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `targetDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = Create(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `Free`

**İmza:** `SUB Free(ds AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `Clone`

**İmza:** `FUNCTION Clone(ds AS U64) AS U64`

**Görev:** Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_clone`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = Clone(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `LoadCSV`

**İmza:** `FUNCTION LoadCSV(path AS STRING, inputDim AS I32, targetDim AS I32, hasHeader AS I32) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `targetDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `hasHeader`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_load_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = LoadCSV("demo", 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `SaveCSV`

**İmza:** `FUNCTION SaveCSV(ds AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_save_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = SaveCSV(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `RowCount`

**İmza:** `FUNCTION RowCount(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_row_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = RowCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `InputDim`

**İmza:** `FUNCTION InputDim(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = InputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `TargetDim`

**İmza:** `FUNCTION TargetDim(ds AS U64) AS I32`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_target_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = TargetDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `XPtr`

**İmza:** `FUNCTION XPtr(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_x_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = XPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `YPtr`

**İmza:** `FUNCTION YPtr(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_y_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = YPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `GetX`

**İmza:** `FUNCTION GetX(ds AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_get_x`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS F64
sonuc = GetX(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `SetX`

**İmza:** `SUB SetX(ds AS U64, row AS I32, col AS I32, value AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_set_x`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
SetX(h, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `GetY`

**İmza:** `FUNCTION GetY(ds AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_get_y`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS F64
sonuc = GetY(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `SetY`

**İmza:** `SUB SetY(ds AS U64, row AS I32, col AS I32, value AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_set_y`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
SetY(h, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `Shuffle`

**İmza:** `SUB Shuffle(ds AS U64, seed AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_shuffle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
Shuffle(h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SplitTrain`

**İmza:** `FUNCTION SplitTrain(ds AS U64, trainRatio AS F64, seed AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `trainRatio`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_split_train`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = SplitTrain(h, 1.0, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `SplitTest`

**İmza:** `FUNCTION SplitTest(ds AS U64, trainRatio AS F64, seed AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `trainRatio`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_split_test`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = SplitTest(h, 1.0, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `ScalerFitStandard`

**İmza:** `FUNCTION ScalerFitStandard(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_scaler_fit_standard`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = ScalerFitStandard(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `ScalerFitMinMax`

**İmza:** `FUNCTION ScalerFitMinMax(ds AS U64) AS U64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_scaler_fit_minmax`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = ScalerFitMinMax(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `ScalerFree`

**İmza:** `SUB ScalerFree(sc AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `sc`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_scaler_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
ScalerFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `ScalerTransform`

**İmza:** `SUB ScalerTransform(sc AS U64, ds AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `sc`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_scaler_transform`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
ScalerTransform(h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `ScalerInverseTransform`

**İmza:** `SUB ScalerInverseTransform(sc AS U64, ds AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `sc`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_scaler_inverse_transform`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
ScalerInverseTransform(h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `FillMissingMean`

**İmza:** `SUB FillMissingMean(ds AS U64)`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_fill_missing_mean`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
FillMissingMean(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `BatchCreate`

**İmza:** `FUNCTION BatchCreate(ds AS U64, batchSize AS I32, shuffle AS I32, seed AS U64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `batchSize`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `shuffle`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = BatchCreate(h, 1, 1, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `BatchFree`

**İmza:** `SUB BatchFree(loader AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
BatchFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `BatchReset`

**İmza:** `SUB BatchReset(loader AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_reset`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
BatchReset(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `BatchNext`

**İmza:** `FUNCTION BatchNext(loader AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_next`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = BatchNext(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `BatchRows`

**İmza:** `FUNCTION BatchRows(loader AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS I32
sonuc = BatchRows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `BatchXPtr`

**İmza:** `FUNCTION BatchXPtr(loader AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_x_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = BatchXPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `BatchYPtr`

**İmza:** `FUNCTION BatchYPtr(loader AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_y_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS U64
sonuc = BatchYPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `BatchGetX`

**İmza:** `FUNCTION BatchGetX(loader AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_get_x`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS F64
sonuc = BatchGetX(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `BatchGetY`

**İmza:** `FUNCTION BatchGetY(loader AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `loader`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXDATASET_DLL`, yerel sembol `uxdataset_batch_get_y`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxdataset/uxdataset.bas"
USING uxdataset
DIM sonuc AS F64
sonuc = BatchGetY(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxdataset/uxdataset_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxdataset/uxdataset_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxdataset/uxdataset_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxdataset/uxdataset_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxdataset/uxdataset_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxgraph`

`uxgraph` bölümü uXBasic’in graf, kenar, yol, bileşen ve ağ ölçümleri için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxgraph/uxgraph.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `PathExists`
- **Handle yaşam döngüsü:** `Create`, `Free`, `VecFree`
- **Veri doldurma ve okuma:** `AddVertex`, `AddVertices`, `AddEdge`, `VCount`, `ECount`, `TriangleCount`, `VecCount`, `VecGet`
- **Hesaplama/analiz:** `IsDirected`, `HasEdge`, `Degree`, `InDegree`, `OutDegree`, `Density`, `SelfLoops`, `Components`, `IsConnected`, `ShortestDistance`, `Transitivity`, `DegreeVector` ve 5 işlev daha
- **Dışa aktarma ve temizlik:** `WriteEdgeListCSV`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Create` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `AddVertex` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `AddVertices` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `AddEdge` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `VCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ECount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `IsDirected` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `HasEdge` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Degree` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `InDegree` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `OutDegree` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Density` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SelfLoops` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Components` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `IsConnected` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ShortestDistance` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `PathExists` | `FUNCTION` | `I32` | Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder. |
| `TriangleCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Transitivity` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DegreeVector` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `BFSDistances` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `VecCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `VecGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `VecFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `WriteEdgeListCSV` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `ReadEdgeListCSV` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `MakePath` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MakeCycle` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MakeComplete` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Create`

**İmza:** `FUNCTION Create(vertices AS I32, directed AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `vertices`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `directed`: `I32` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = Create(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Free`

**İmza:** `SUB Free(g AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `AddVertex`

**İmza:** `FUNCTION AddVertex(g AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_add_vertex`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = AddVertex(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `AddVertices`

**İmza:** `FUNCTION AddVertices(g AS U64, count AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_add_vertices`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = AddVertices(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `AddEdge`

**İmza:** `FUNCTION AddEdge(g AS U64, fromV AS I32, toV AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `fromV`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `toV`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_add_edge`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = AddEdge(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `VCount`

**İmza:** `FUNCTION VCount(g AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_vcount`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = VCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `ECount`

**İmza:** `FUNCTION ECount(g AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_ecount`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = ECount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `IsDirected`

**İmza:** `FUNCTION IsDirected(g AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_is_directed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = IsDirected(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `HasEdge`

**İmza:** `FUNCTION HasEdge(g AS U64, fromV AS I32, toV AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `fromV`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `toV`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_has_edge`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = HasEdge(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Degree`

**İmza:** `FUNCTION Degree(g AS U64, v AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `v`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_degree`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = Degree(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `InDegree`

**İmza:** `FUNCTION InDegree(g AS U64, v AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `v`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_in_degree`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = InDegree(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `OutDegree`

**İmza:** `FUNCTION OutDegree(g AS U64, v AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `v`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_out_degree`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = OutDegree(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `Density`

**İmza:** `FUNCTION Density(g AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_density`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS F64
sonuc = Density(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `SelfLoops`

**İmza:** `FUNCTION SelfLoops(g AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_self_loops`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = SelfLoops(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `Components`

**İmza:** `FUNCTION Components(g AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_components_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = Components(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `IsConnected`

**İmza:** `FUNCTION IsConnected(g AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_is_connected`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = IsConnected(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `ShortestDistance`

**İmza:** `FUNCTION ShortestDistance(g AS U64, source AS I32, target AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `source`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `target`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_shortest_distance`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = ShortestDistance(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `PathExists`

**İmza:** `FUNCTION PathExists(g AS U64, source AS I32, target AS I32) AS I32`

**Görev:** Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `source`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `target`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_path_exists`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = PathExists(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `TriangleCount`

**İmza:** `FUNCTION TriangleCount(g AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_triangle_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = TriangleCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `Transitivity`

**İmza:** `FUNCTION Transitivity(g AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_transitivity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS F64
sonuc = Transitivity(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `DegreeVector`

**İmza:** `FUNCTION DegreeVector(g AS U64, mode AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mode`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_degree_vector`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = DegreeVector(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `BFSDistances`

**İmza:** `FUNCTION BFSDistances(g AS U64, source AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `source`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_bfs_distances`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = BFSDistances(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `VecCount`

**İmza:** `FUNCTION VecCount(v AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `v`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_vec_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = VecCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `VecGet`

**İmza:** `FUNCTION VecGet(v AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `v`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS F64
sonuc = VecGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `VecFree`

**İmza:** `SUB VecFree(v AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `v`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_vec_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
VecFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `WriteEdgeListCSV`

**İmza:** `FUNCTION WriteEdgeListCSV(g AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `g`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_write_edgelist_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS I32
sonuc = WriteEdgeListCSV(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `ReadEdgeListCSV`

**İmza:** `FUNCTION ReadEdgeListCSV(path AS STRING, directed AS I32) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `directed`: `I32` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_read_edgelist_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = ReadEdgeListCSV("demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `MakePath`

**İmza:** `FUNCTION MakePath(vertices AS I32, directed AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `vertices`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `directed`: `I32` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_make_path`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = MakePath(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `MakeCycle`

**İmza:** `FUNCTION MakeCycle(vertices AS I32, directed AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `vertices`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `directed`: `I32` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_make_cycle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = MakeCycle(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `MakeComplete`

**İmza:** `FUNCTION MakeComplete(vertices AS I32, directed AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `vertices`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `directed`: `I32` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXGRAPH_DLL`, yerel sembol `uxgraph_make_complete`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxgraph/uxgraph.bas"
USING uxgraph
DIM sonuc AS U64
sonuc = MakeComplete(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxgraph/uxgraph_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxgraph/uxgraph_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxgraph/uxgraph_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxgraph/uxgraph_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxgraph/uxgraph_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxllama`

`uxllama` bölümü uXBasic’in yerel LLM, prompt çalıştırma ve düşük bellek profili için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxllama/uxllama.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `ModelExists`, `LastError`, `LastCommand`
- **Handle yaşam döngüsü:** `Create`, `Free`
- **Veri doldurma ve okuma:** `SetCliPath`, `SetModelPath`, `SetThreads`, `SetContext`, `SetPredict`, `SetTemperature`, `SetTopP`, `SetTopK`, `SetSeed`
- **Hesaplama/analiz:** `LowMemoryProfile`, `Prompt`, `PromptFile`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Create` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `SetCliPath` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetModelPath` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetThreads` | `FUNCTION` | `I32` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `SetContext` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetPredict` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetTemperature` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetTopP` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetTopK` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetSeed` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `LowMemoryProfile` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ModelExists` | `FUNCTION` | `I32` | Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder. |
| `Prompt` | `FUNCTION` | `I32` | Yerel dil modeli çağrısının prompt, örnekleme, bellek ve çalışma ayarlarını düzenler. |
| `PromptFile` | `FUNCTION` | `I32` | Yerel dil modeli çağrısının prompt, örnekleme, bellek ve çalışma ayarlarını düzenler. |
| `LastError` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `LastCommand` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Create`

**İmza:** `FUNCTION Create() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS U64
sonuc = Create()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Free`

**İmza:** `SUB Free(h AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `SetCliPath`

**İmza:** `FUNCTION SetCliPath(h AS U64, path AS STRING) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_cli_path`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetCliPath(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `SetModelPath`

**İmza:** `FUNCTION SetModelPath(h AS U64, path AS STRING) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_model_path`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetModelPath(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `SetThreads`

**İmza:** `FUNCTION SetThreads(h AS U64, n AS I32) AS I32`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_threads`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetThreads(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `SetContext`

**İmza:** `FUNCTION SetContext(h AS U64, n AS I32) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_context`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetContext(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `SetPredict`

**İmza:** `FUNCTION SetPredict(h AS U64, n AS I32) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_predict`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetPredict(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `SetTemperature`

**İmza:** `FUNCTION SetTemperature(h AS U64, t AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `t`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_temperature`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetTemperature(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `SetTopP`

**İmza:** `FUNCTION SetTopP(h AS U64, p AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `p`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_top_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetTopP(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `SetTopK`

**İmza:** `FUNCTION SetTopK(h AS U64, k AS I32) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `k`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_top_k`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetTopK(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `SetSeed`

**İmza:** `FUNCTION SetSeed(h AS U64, seed AS I32) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `seed`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_seed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = SetSeed(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `LowMemoryProfile`

**İmza:** `FUNCTION LowMemoryProfile(h AS U64, profile AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `profile`: `I32` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_set_low_memory_profile`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = LowMemoryProfile(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ModelExists`

**İmza:** `FUNCTION ModelExists(h AS U64) AS I32`

**Görev:** Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_model_exists`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = ModelExists(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `Prompt`

**İmza:** `FUNCTION Prompt(h AS U64, prompt AS STRING, outBuf AS U64, outBytes AS I32) AS I32`

**Görev:** Yerel dil modeli çağrısının prompt, örnekleme, bellek ve çalışma ayarlarını düzenler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `prompt`: `STRING` metin parametresi.
- `outBuf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outBytes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_prompt`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = Prompt(h, "demo", h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `PromptFile`

**İmza:** `FUNCTION PromptFile(h AS U64, promptFile AS STRING, outBuf AS U64, outBytes AS I32) AS I32`

**Görev:** Yerel dil modeli çağrısının prompt, örnekleme, bellek ve çalışma ayarlarını düzenler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `promptFile`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `outBuf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outBytes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_prompt_file`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = PromptFile(h, "demo", h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `LastError`

**İmza:** `FUNCTION LastError(h AS U64, outBuf AS U64, outBytes AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outBuf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outBytes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = LastError(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `LastCommand`

**İmza:** `FUNCTION LastCommand(h AS U64, outBuf AS U64, outBytes AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outBuf`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outBytes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `DLL_NAME`, yerel sembol `uxllama_last_command`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxllama/uxllama.bas"
USING uxllama
DIM sonuc AS I32
sonuc = LastCommand(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxllama/uxllama_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxllama/uxllama_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxllama/uxllama_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxllama/uxllama_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxllama/uxllama_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxllamax_placeholder`

`uxllamax_placeholder` bölümü uXBasic’in yerel LLM, prompt çalıştırma ve düşük bellek profili için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxllamax/UXLLAMAX_PLACEHOLDER.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxllamax/UXLLAMAX_PLACEHOLDER.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri


## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|

## Fonksiyonların ayrıntılı anlatımı

Bu wrapper dosyası placeholder durumundadır; bu baskıda dış fonksiyon imzası taşımamaktadır. Kitapta yer almasının nedeni modül adının registry içinde geleceğe dönük ayrılmış olmasıdır.
## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxllamax_placeholder/uxllamax_placeholder_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxllamax_placeholder/uxllamax_placeholder_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxllamax_placeholder/uxllamax_placeholder_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxllamax_placeholder/uxllamax_placeholder_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxllamax_placeholder/uxllamax_placeholder_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxmath`

`uxmath` bölümü uXBasic’in vektör, sayısal yardımcı ve ham veri yüzeyi için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxmath/uxmath.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxmath/uxmath.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXMATH_Version`
- **Handle yaşam döngüsü:** `UXMATH_VecCreate`, `UXMATH_VecFree`
- **Veri doldurma ve okuma:** `UXMATH_VecPush`, `UXMATH_VecSet`, `UXMATH_VecGet`, `UXMATH_VecCount`, `UXMATH_VecDataPtr`
- **Hesaplama/analiz:** `UXMATH_VecClear`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXMATH_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXMATH_VecCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXMATH_VecFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXMATH_VecPush` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMATH_VecSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMATH_VecGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXMATH_VecCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMATH_VecClear` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXMATH_VecDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXMATH_Version`

**İmza:** `FUNCTION UXMATH_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS I32
sonuc = UXMATH_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXMATH_VecCreate`

**İmza:** `FUNCTION UXMATH_VecCreate(capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS U64
sonuc = UXMATH_VecCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXMATH_VecFree`

**İmza:** `FUNCTION UXMATH_VecFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS I32
sonuc = UXMATH_VecFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXMATH_VecPush`

**İmza:** `FUNCTION UXMATH_VecPush(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_push`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS I32
sonuc = UXMATH_VecPush(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXMATH_VecSet`

**İmza:** `FUNCTION UXMATH_VecSet(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS I32
sonuc = UXMATH_VecSet(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXMATH_VecGet`

**İmza:** `FUNCTION UXMATH_VecGet(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS F64
sonuc = UXMATH_VecGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXMATH_VecCount`

**İmza:** `FUNCTION UXMATH_VecCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS I32
sonuc = UXMATH_VecCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXMATH_VecClear`

**İmza:** `FUNCTION UXMATH_VecClear(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_clear`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS I32
sonuc = UXMATH_VecClear(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXMATH_VecDataPtr`

**İmza:** `FUNCTION UXMATH_VecDataPtr(h AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmath/uxmath.bas"
DIM sonuc AS U64
sonuc = UXMATH_VecDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxmath/uxmath_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxmath/uxmath_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxmath/uxmath_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxmath/uxmath_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxmath/uxmath_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxmathcore`

`uxmathcore` bölümü uXBasic’in tipli buffer, ham bellek ve temel matematik çekirdeği için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxmathcore/uxmathcore.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXMC_Version`
- **Handle yaşam döngüsü:** `UXMC_BufferCreate`, `UXMC_BufferCreateCapacity`, `UXMC_BufferFree`, `UXMC_BufferClone`
- **Veri doldurma ve okuma:** `UXMC_BufferCount`, `UXMC_BufferDataPtr`, `UXMC_GetF64`, `UXMC_SetF64`, `UXMC_PushF64`, `UXMC_SetI64`, `UXMC_PushI64`, `UXMC_SetU64`, `UXMC_PushU64`, `UXMC_SetByte`, `UXMC_PushByte`, `UXMC_VecAddF64`
- **Hesaplama/analiz:** `UXMC_TYPE_I8`, `UXMC_TYPE_U8`, `UXMC_TYPE_I16`, `UXMC_TYPE_U16`, `UXMC_TYPE_I32`, `UXMC_TYPE_U32`, `UXMC_TYPE_I64`, `UXMC_TYPE_U64`, `UXMC_TYPE_F32`, `UXMC_TYPE_F64`, `UXMC_TypeSize`, `UXMC_BufferType` ve 21 işlev daha
- **Dışa aktarma ve temizlik:** `UXMC_BufferClear`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXMC_TYPE_I8` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U8` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_I16` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U16` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_I32` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U32` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_I64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_U64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_F32` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_TYPE_F64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXMC_TypeSize` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXMC_BufferCreateCapacity` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXMC_BufferFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXMC_BufferType` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferCapacity` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferElemSize` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferByteSize` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferDataPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferClear` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXMC_BufferResize` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXMC_BufferReserve` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferFillZero` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferClone` | `FUNCTION` | `U64` | Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır. |
| `UXMC_BufferSlice` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferAppend` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_BufferCast` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_GetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXMC_SetF64` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushF64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_FillF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_SetI64` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushI64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_SetU64` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushU64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_SetByte` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXMC_PushByte` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_VecAddF64` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXMC_VecSubF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecMulF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecDivF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecScaleF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecAxpyF64` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXMC_VecDotF64` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecL1NormF64` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecL2NormF64` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecNormalizeL2F64` | `FUNCTION` | `I32` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXMC_VecMinF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXMC_VecMaxF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXMC_TYPE_I8`

**İmza:** `FUNCTION UXMC_TYPE_I8() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I8()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXMC_TYPE_U8`

**İmza:** `FUNCTION UXMC_TYPE_U8() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U8()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXMC_TYPE_I16`

**İmza:** `FUNCTION UXMC_TYPE_I16() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I16()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXMC_TYPE_U16`

**İmza:** `FUNCTION UXMC_TYPE_U16() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U16()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXMC_TYPE_I32`

**İmza:** `FUNCTION UXMC_TYPE_I32() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I32()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXMC_TYPE_U32`

**İmza:** `FUNCTION UXMC_TYPE_U32() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U32()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXMC_TYPE_I64`

**İmza:** `FUNCTION UXMC_TYPE_I64() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_I64()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXMC_TYPE_U64`

**İmza:** `FUNCTION UXMC_TYPE_U64() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_U64()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXMC_TYPE_F32`

**İmza:** `FUNCTION UXMC_TYPE_F32() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_F32()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `UXMC_TYPE_F64`

**İmza:** `FUNCTION UXMC_TYPE_F64() AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TYPE_F64()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `UXMC_Version`

**İmza:** `FUNCTION UXMC_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `UXMC_TypeSize`

**İmza:** `FUNCTION UXMC_TypeSize(typeId AS I32) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `typeId`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_type_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_TypeSize(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `UXMC_BufferCreate`

**İmza:** `FUNCTION UXMC_BufferCreate(typeId AS I32, count AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `typeId`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferCreate(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `UXMC_BufferCreateCapacity`

**İmza:** `FUNCTION UXMC_BufferCreateCapacity(typeId AS I32, count AS I32, capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `typeId`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_create_capacity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferCreateCapacity(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `UXMC_BufferFree`

**İmza:** `FUNCTION UXMC_BufferFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `UXMC_BufferType`

**İmza:** `FUNCTION UXMC_BufferType(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_type`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferType(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `UXMC_BufferCount`

**İmza:** `FUNCTION UXMC_BufferCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `UXMC_BufferCapacity`

**İmza:** `FUNCTION UXMC_BufferCapacity(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_capacity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferCapacity(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `UXMC_BufferElemSize`

**İmza:** `FUNCTION UXMC_BufferElemSize(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_elem_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferElemSize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `UXMC_BufferByteSize`

**İmza:** `FUNCTION UXMC_BufferByteSize(h AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_byte_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I64
sonuc = UXMC_BufferByteSize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `UXMC_BufferDataPtr`

**İmza:** `FUNCTION UXMC_BufferDataPtr(h AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `UXMC_BufferClear`

**İmza:** `FUNCTION UXMC_BufferClear(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_clear`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferClear(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `UXMC_BufferResize`

**İmza:** `FUNCTION UXMC_BufferResize(h AS U64, count AS I32) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_resize`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferResize(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `UXMC_BufferReserve`

**İmza:** `FUNCTION UXMC_BufferReserve(h AS U64, capacity AS I32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_reserve`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferReserve(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `UXMC_BufferFillZero`

**İmza:** `FUNCTION UXMC_BufferFillZero(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_fill_zero`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferFillZero(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `UXMC_BufferClone`

**İmza:** `FUNCTION UXMC_BufferClone(h AS U64) AS U64`

**Görev:** Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_clone_handle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferClone(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `UXMC_BufferSlice`

**İmza:** `FUNCTION UXMC_BufferSlice(h AS U64, startIndex AS I32, count AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `startIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_slice_handle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferSlice(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `UXMC_BufferAppend`

**İmza:** `FUNCTION UXMC_BufferAppend(dst AS U64, src AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `dst`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `src`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_append`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_BufferAppend(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `UXMC_BufferCast`

**İmza:** `FUNCTION UXMC_BufferCast(src AS U64, dstType AS I32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `src`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `dstType`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_cast_handle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS U64
sonuc = UXMC_BufferCast(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `UXMC_GetF64`

**İmza:** `FUNCTION UXMC_GetF64(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmath_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_GetF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `UXMC_SetF64`

**İmza:** `FUNCTION UXMC_SetF64(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetF64(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `UXMC_PushF64`

**İmza:** `FUNCTION UXMC_PushF64(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushF64(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `UXMC_FillF64`

**İmza:** `FUNCTION UXMC_FillF64(h AS U64, value AS F64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_fill_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_FillF64(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `UXMC_SetI64`

**İmza:** `FUNCTION UXMC_SetI64(h AS U64, index AS I32, value AS I64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetI64(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `UXMC_PushI64`

**İmza:** `FUNCTION UXMC_PushI64(h AS U64, value AS I64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushI64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `UXMC_SetU64`

**İmza:** `FUNCTION UXMC_SetU64(h AS U64, index AS I32, value AS U64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_u64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetU64(h, 1, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `UXMC_PushU64`

**İmza:** `FUNCTION UXMC_PushU64(h AS U64, value AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_u64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushU64(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `UXMC_SetByte`

**İmza:** `FUNCTION UXMC_SetByte(h AS U64, index AS I32, value AS I32) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_set_byte`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_SetByte(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `UXMC_PushByte`

**İmza:** `FUNCTION UXMC_PushByte(h AS U64, value AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_buffer_push_byte`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_PushByte(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `UXMC_VecAddF64`

**İmza:** `FUNCTION UXMC_VecAddF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_add_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecAddF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `UXMC_VecSubF64`

**İmza:** `FUNCTION UXMC_VecSubF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_sub_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecSubF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `UXMC_VecMulF64`

**İmza:** `FUNCTION UXMC_VecMulF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_mul_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecMulF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 43. `UXMC_VecDivF64`

**İmza:** `FUNCTION UXMC_VecDivF64(a AS U64, b AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_div_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecDivF64(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 44. `UXMC_VecScaleF64`

**İmza:** `FUNCTION UXMC_VecScaleF64(a AS U64, scalar AS F64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `scalar`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_scale_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecScaleF64(h, 1.0, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 45. `UXMC_VecAxpyF64`

**İmza:** `FUNCTION UXMC_VecAxpyF64(alpha AS F64, x AS U64, y AS U64, outv AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `alpha`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_axpy_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecAxpyF64(1.0, h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 46. `UXMC_VecDotF64`

**İmza:** `FUNCTION UXMC_VecDotF64(a AS U64, b AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_dot_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecDotF64(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 47. `UXMC_VecL1NormF64`

**İmza:** `FUNCTION UXMC_VecL1NormF64(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_l1_norm_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecL1NormF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 48. `UXMC_VecL2NormF64`

**İmza:** `FUNCTION UXMC_VecL2NormF64(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_l2_norm_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecL2NormF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 49. `UXMC_VecNormalizeL2F64`

**İmza:** `FUNCTION UXMC_VecNormalizeL2F64(a AS U64, outv AS U64) AS I32`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outv`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_normalize_l2_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS I32
sonuc = UXMC_VecNormalizeL2F64(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 50. `UXMC_VecMinF64`

**İmza:** `FUNCTION UXMC_VecMinF64(a AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_min_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecMinF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 51. `UXMC_VecMaxF64`

**İmza:** `FUNCTION UXMC_VecMaxF64(a AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxmathcore.dll`, yerel sembol `uxmathcore_vec_max_f64_value`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmathcore/uxmathcore.bas"
DIM sonuc AS F64
sonuc = UXMC_VecMaxF64(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxmathcore/uxmathcore_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxmatrix`

`uxmatrix` bölümü uXBasic’in matris ve OpenBLAS destekli sayısal hesap için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxmatrix/uxmatrix.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `RuntimeVersion`
- **Handle yaşam döngüsü:** `Create`, `Free`, `Clone`
- **Veri doldurma ve okuma:** `Rows`, `Cols`, `DataPtr`, `Set`, `Get`, `Add`
- **Hesaplama/analiz:** `Size`, `Fill`, `Zero`, `Eye`, `Transpose`, `Sub`, `Scale`, `Mul`, `MatVec`, `Dot`, `NormL1`, `NormL2` ve 12 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `RuntimeVersion` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Create` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `Rows` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Cols` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Size` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `DataPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Set` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Get` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Fill` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Zero` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Eye` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Clone` | `FUNCTION` | `U64` | Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır. |
| `Transpose` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Add` | `FUNCTION` | `U64` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `Sub` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Scale` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Mul` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MatVec` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Dot` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NormL1` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NormL2` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NormFro` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Trace` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `PrintMatrix` | `FUNCTION` | `I32` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Det` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Solve` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Inverse` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Cholesky` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `QR` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SVD` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `EigenSymmetric` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `RankSVD` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Cond2` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `RuntimeVersion`

**İmza:** `FUNCTION RuntimeVersion() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_runtime_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = RuntimeVersion()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Create`

**İmza:** `FUNCTION Create(rows AS I32, cols AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `rows`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `cols`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Create(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Free`

**İmza:** `SUB Free(m AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `Rows`

**İmza:** `FUNCTION Rows(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Rows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `Cols`

**İmza:** `FUNCTION Cols(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_cols`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Cols(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `Size`

**İmza:** `FUNCTION Size(m AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Size(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `DataPtr`

**İmza:** `FUNCTION DataPtr(m AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = DataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `Set`

**İmza:** `FUNCTION Set(m AS U64, r AS I32, c AS I32, v AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `r`: `I32` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Set(h, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `Get`

**İmza:** `FUNCTION Get(m AS U64, r AS I32, c AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `r`: `I32` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Get(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Fill`

**İmza:** `FUNCTION Fill(m AS U64, v AS F64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_fill`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Fill(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `Zero`

**İmza:** `FUNCTION Zero(m AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_zero`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Zero(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `Eye`

**İmza:** `FUNCTION Eye(m AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_eye`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = Eye(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `Clone`

**İmza:** `FUNCTION Clone(m AS U64) AS U64`

**Görev:** Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır.

**Parametreler:**
- `m`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_clone`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Clone(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `Transpose`

**İmza:** `FUNCTION Transpose(a AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_transpose`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Transpose(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `Add`

**İmza:** `FUNCTION Add(a AS U64, b AS U64) AS U64`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_add`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Add(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `Sub`

**İmza:** `FUNCTION Sub(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_sub`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Sub(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `Scale`

**İmza:** `FUNCTION Scale(a AS U64, s AS F64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `s`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_scale`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Scale(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `Mul`

**İmza:** `FUNCTION Mul(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_mul`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Mul(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `MatVec`

**İmza:** `FUNCTION MatVec(a AS U64, x AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_matvec`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = MatVec(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `Dot`

**İmza:** `FUNCTION Dot(a AS U64, b AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_dot`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Dot(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `NormL1`

**İmza:** `FUNCTION NormL1(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_norm_l1`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = NormL1(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `NormL2`

**İmza:** `FUNCTION NormL2(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_norm_l2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = NormL2(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `NormFro`

**İmza:** `FUNCTION NormFro(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_norm_fro`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = NormFro(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `Trace`

**İmza:** `FUNCTION Trace(a AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_trace`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Trace(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `PrintMatrix`

**İmza:** `FUNCTION PrintMatrix(a AS U64) AS I32`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_print`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = PrintMatrix(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `Det`

**İmza:** `FUNCTION Det(a AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_det`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Det(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `Solve`

**İmza:** `FUNCTION Solve(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_solve_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Solve(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `Inverse`

**İmza:** `FUNCTION Inverse(a AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_inverse_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Inverse(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `Cholesky`

**İmza:** `FUNCTION Cholesky(a AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_cholesky_new`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS U64
sonuc = Cholesky(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `QR`

**İmza:** `FUNCTION QR(a AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_qr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = QR(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `SVD`

**İmza:** `FUNCTION SVD(a AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_svd`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = SVD(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `EigenSymmetric`

**İmza:** `FUNCTION EigenSymmetric(a AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_eigen_symmetric`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = EigenSymmetric(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `RankSVD`

**İmza:** `FUNCTION RankSVD(a AS U64, tol AS F64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `tol`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_rank_svd`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS I32
sonuc = RankSVD(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `Cond2`

**İmza:** `FUNCTION Cond2(a AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXMATRIX_DLL`, yerel sembol `uxmatrix_cond2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
USING uxmatrix
DIM sonuc AS F64
sonuc = Cond2(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxmatrix/uxmatrix_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxnn`

`uxnn` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxnn/uxnn.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`, `LayerInit`
- **Handle yaşam döngüsü:** `NeuronCreate`, `NeuronFree`, `DenseLayerCreate`, `ActivationLayerCreate`, `LayerFree`, `NetworkCreate`, `NetworkFree`
- **Veri doldurma ve okuma:** `NeuronSetWeight`, `NeuronGetWeight`, `NeuronSetBias`, `NeuronGetBias`, `NeuronForwardPtr`, `LayerInputDim`, `LayerOutputDim`, `LayerSetWeight`, `LayerGetWeight`, `LayerSetBias`, `LayerGetBias`, `LayerForwardPtr` ve 8 işlev daha
- **Hesaplama/analiz:** `Seed`, `NetworkForwardTensor`, `NetworkPredictArgmaxTensor`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Seed` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NeuronCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `NeuronFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `NeuronSetWeight` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `NeuronGetWeight` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `NeuronSetBias` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `NeuronGetBias` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `NeuronForwardPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DenseLayerCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `ActivationLayerCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `LayerFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `LayerInputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `LayerOutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `LayerSetWeight` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `LayerGetWeight` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `LayerSetBias` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `LayerGetBias` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `LayerInit` | `SUB` | `-` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `LayerForwardPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NetworkCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `NetworkFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `NetworkAddLayer` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `NetworkLayerCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `NetworkInputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `NetworkOutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `NetworkForwardPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NetworkPredictArgmaxPtr` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `NetworkMSEPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NetworkTrainMSESGDPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NetworkForwardTensor` | `SUB` | `-` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `NetworkPredictArgmaxTensor` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Backend`

**İmza:** `FUNCTION Backend() AS STRING`

**Görev:** Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS STRING
sonuc = Backend()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Seed`

**İmza:** `SUB Seed(seed AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_seed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
Seed(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `NeuronCreate`

**İmza:** `FUNCTION NeuronCreate(inputCount AS I32, activation AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `inputCount`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS U64
sonuc = NeuronCreate(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `NeuronFree`

**İmza:** `SUB NeuronFree(n AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `n`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
NeuronFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `NeuronSetWeight`

**İmza:** `SUB NeuronSetWeight(n AS U64, index AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `n`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_set_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
NeuronSetWeight(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `NeuronGetWeight`

**İmza:** `FUNCTION NeuronGetWeight(n AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `n`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_get_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = NeuronGetWeight(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `NeuronSetBias`

**İmza:** `SUB NeuronSetBias(n AS U64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `n`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_set_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
NeuronSetBias(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `NeuronGetBias`

**İmza:** `FUNCTION NeuronGetBias(n AS U64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `n`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_get_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = NeuronGetBias(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `NeuronForwardPtr`

**İmza:** `FUNCTION NeuronForwardPtr(n AS U64, inputPtr AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `n`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_neuron_forward_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = NeuronForwardPtr(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `DenseLayerCreate`

**İmza:** `FUNCTION DenseLayerCreate(inputDim AS I32, outputDim AS I32, activation AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_dense_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS U64
sonuc = DenseLayerCreate(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `ActivationLayerCreate`

**İmza:** `FUNCTION ActivationLayerCreate(dim AS I32, activation AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_activation_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS U64
sonuc = ActivationLayerCreate(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `LayerFree`

**İmza:** `SUB LayerFree(layer AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
LayerFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `LayerInputDim`

**İmza:** `FUNCTION LayerInputDim(layer AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = LayerInputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `LayerOutputDim`

**İmza:** `FUNCTION LayerOutputDim(layer AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = LayerOutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `LayerSetWeight`

**İmza:** `SUB LayerSetWeight(layer AS U64, outIndex AS I32, inIndex AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `inIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_set_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
LayerSetWeight(h, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `LayerGetWeight`

**İmza:** `FUNCTION LayerGetWeight(layer AS U64, outIndex AS I32, inIndex AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `inIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_get_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = LayerGetWeight(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `LayerSetBias`

**İmza:** `SUB LayerSetBias(layer AS U64, outIndex AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_set_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
LayerSetBias(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `LayerGetBias`

**İmza:** `FUNCTION LayerGetBias(layer AS U64, outIndex AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_get_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = LayerGetBias(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `LayerInit`

**İmza:** `SUB LayerInit(layer AS U64, initKind AS I32, scale AS F64)`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `initKind`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `scale`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
LayerInit(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `LayerForwardPtr`

**İmza:** `SUB LayerForwardPtr(layer AS U64, inputPtr AS U64, outputPtr AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_layer_forward_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
LayerForwardPtr(h, h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `NetworkCreate`

**İmza:** `FUNCTION NetworkCreate() AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS U64
sonuc = NetworkCreate()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `NetworkFree`

**İmza:** `SUB NetworkFree(net AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
NetworkFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `NetworkAddLayer`

**İmza:** `FUNCTION NetworkAddLayer(net AS U64, layer AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layer`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_add_layer`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = NetworkAddLayer(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `NetworkLayerCount`

**İmza:** `FUNCTION NetworkLayerCount(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_layer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = NetworkLayerCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `NetworkInputDim`

**İmza:** `FUNCTION NetworkInputDim(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = NetworkInputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `NetworkOutputDim`

**İmza:** `FUNCTION NetworkOutputDim(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = NetworkOutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `NetworkForwardPtr`

**İmza:** `SUB NetworkForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_forward_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
NetworkForwardPtr(h, h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `NetworkPredictArgmaxPtr`

**İmza:** `FUNCTION NetworkPredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_predict_argmax_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = NetworkPredictArgmaxPtr(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `NetworkMSEPtr`

**İmza:** `FUNCTION NetworkMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `xPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sampleCount`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = NetworkMSEPtr(h, h, h, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `NetworkTrainMSESGDPtr`

**İmza:** `FUNCTION NetworkTrainMSESGDPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32, epochs AS I32, lr AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `xPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sampleCount`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `epochs`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_train_mse_sgd_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS F64
sonuc = NetworkTrainMSESGDPtr(h, h, h, 1, 1, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `NetworkForwardTensor`

**İmza:** `SUB NetworkForwardTensor(net AS U64, inputTensor AS U64, outputTensor AS U64)`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_forward_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
NetworkForwardTensor(h, h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `NetworkPredictArgmaxTensor`

**İmza:** `FUNCTION NetworkPredictArgmaxTensor(net AS U64, inputTensor AS U64) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN_DLL`, yerel sembol `uxnn_network_predict_argmax_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn/uxnn.bas"
USING uxnn
DIM sonuc AS I32
sonuc = NetworkPredictArgmaxTensor(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxnn/uxnn_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxnn/uxnn_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxnn/uxnn_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxnn/uxnn_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxnn/uxnn_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxnn2`

`uxnn2` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxnn2/uxnn2.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`, `Init`
- **Handle yaşam döngüsü:** `NetworkCreate`, `NetworkFree`, `Load`
- **Veri doldurma ve okuma:** `AddDense`, `LayerCount`, `InputDim`, `OutputDim`, `SetOptimizer`, `SetOptimizerParams`, `ForwardPtr`, `LossMSEPtr`, `TrainSampleMSEPtr`, `TrainArrayMSEPtr`, `PredictArgmaxPtr`, `GetWeight` ve 3 işlev daha
- **Hesaplama/analiz:** `Seed`
- **Dışa aktarma ve temizlik:** `Save`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Seed` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NetworkCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `NetworkFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `AddDense` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `LayerCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Init` | `SUB` | `-` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `SetOptimizer` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `SetOptimizerParams` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `ForwardPtr` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `LossMSEPtr` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `TrainSampleMSEPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `TrainArrayMSEPtr` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `PredictArgmaxPtr` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `GetWeight` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetWeight` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `GetBias` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetBias` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Save` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `Load` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Backend`

**İmza:** `FUNCTION Backend() AS STRING`

**Görev:** Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS STRING
sonuc = Backend()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Seed`

**İmza:** `SUB Seed(seed AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `seed`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_seed`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
Seed(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `NetworkCreate`

**İmza:** `FUNCTION NetworkCreate(inputDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS U64
sonuc = NetworkCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `NetworkFree`

**İmza:** `SUB NetworkFree(net AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
NetworkFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `AddDense`

**İmza:** `FUNCTION AddDense(net AS U64, outputDim AS I32, activation AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_add_dense`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = AddDense(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `LayerCount`

**İmza:** `FUNCTION LayerCount(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_layer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = LayerCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputDim`

**İmza:** `FUNCTION InputDim(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = InputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputDim`

**İmza:** `FUNCTION OutputDim(net AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = OutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `Init`

**İmza:** `SUB Init(net AS U64, initKind AS I32, scale AS F64)`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `initKind`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `scale`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_network_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
Init(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `SetOptimizer`

**İmza:** `SUB SetOptimizer(net AS U64, optKind AS I32, learningRate AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `optKind`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `learningRate`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_optimizer`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetOptimizer(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `SetOptimizerParams`

**İmza:** `SUB SetOptimizerParams(net AS U64, beta1 AS F64, beta2 AS F64, epsilon AS F64, weightDecay AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `beta1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `beta2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `epsilon`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `weightDecay`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_optimizer_params`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetOptimizerParams(h, 1.0, 1.0, 1.0, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `ForwardPtr`

**İmza:** `SUB ForwardPtr(net AS U64, inputPtr AS U64, outputPtr AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_forward_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
ForwardPtr(h, h, h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `LossMSEPtr`

**İmza:** `FUNCTION LossMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `targetPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_loss_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = LossMSEPtr(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `TrainSampleMSEPtr`

**İmza:** `FUNCTION TrainSampleMSEPtr(net AS U64, inputPtr AS U64, targetPtr AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `targetPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_train_sample_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = TrainSampleMSEPtr(h, h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `TrainArrayMSEPtr`

**İmza:** `FUNCTION TrainArrayMSEPtr(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, epochs AS I32, shuffle AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `xPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `yPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sampleCount`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `epochs`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `shuffle`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_train_array_mse_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = TrainArrayMSEPtr(h, h, h, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `PredictArgmaxPtr`

**İmza:** `FUNCTION PredictArgmaxPtr(net AS U64, inputPtr AS U64) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputPtr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_predict_argmax_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = PredictArgmaxPtr(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `GetWeight`

**İmza:** `FUNCTION GetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `inIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_get_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = GetWeight(h, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `SetWeight`

**İmza:** `SUB SetWeight(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `inIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_weight`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetWeight(h, 1, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `GetBias`

**İmza:** `FUNCTION GetBias(net AS U64, layerIndex AS I32, outIndex AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_get_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS F64
sonuc = GetBias(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `SetBias`

**İmza:** `SUB SetBias(net AS U64, layerIndex AS I32, outIndex AS I32, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `layerIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `outIndex`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_set_bias`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
SetBias(h, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `Save`

**İmza:** `FUNCTION Save(net AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `net`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_save`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS I32
sonuc = Save(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `Load`

**İmza:** `FUNCTION Load(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN2_DLL`, yerel sembol `uxnn2_load`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn2/uxnn2.bas"
USING uxnn2
DIM sonuc AS U64
sonuc = Load("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxnn2/uxnn2_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxnn3`

`uxnn3` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxnn3/uxnn3.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `LastError`, `Init`
- **Handle yaşam döngüsü:** `DatasetCreate`, `DatasetFree`, `LoadCSV`, `ModelCreate`, `ModelFree`, `Load`
- **Veri doldurma ve okuma:** `Rows`, `InputDim`, `OutputDim`, `XGet`, `YGet`, `XSet`, `YSet`, `XPtr`, `YPtr`, `AddDense`, `SetOptimizer`, `LayerCount` ve 2 işlev daha
- **Hesaplama/analiz:** `Shuffle`, `SplitTrain`, `SplitTest`, `Standardize`, `MinMax`, `PredictArgMax`, `EvalMSE`, `EvalBinaryAccuracy`
- **Dışa aktarma ve temizlik:** `SaveCSV`, `Save`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DatasetCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `DatasetFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `LoadCSV` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |
| `SaveCSV` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `Rows` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `XGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `YGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `XSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `YSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `XPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `YPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Shuffle` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SplitTrain` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SplitTest` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Standardize` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `MinMax` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `ModelCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `ModelFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `AddDense` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `Init` | `FUNCTION` | `I32` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `SetOptimizer` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `LayerCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ModelOutputDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `PredictArgMax` | `FUNCTION` | `I32` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `TrainDataset` | `FUNCTION` | `F64` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `EvalMSE` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `EvalBinaryAccuracy` | `FUNCTION` | `F64` | Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür. |
| `Save` | `FUNCTION` | `I32` | Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir. |
| `Load` | `FUNCTION` | `U64` | Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `LastError`

**İmza:** `FUNCTION LastError() AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS STRING
sonuc = LastError()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `DatasetCreate`

**İmza:** `FUNCTION DatasetCreate(rows AS I32, inputDim AS I32, outputDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `rows`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = DatasetCreate(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `DatasetFree`

**İmza:** `SUB DatasetFree(ds AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DatasetFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `LoadCSV`

**İmza:** `FUNCTION LoadCSV(path AS STRING, inputDim AS I32, outputDim AS I32, hasHeader AS I32) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `hasHeader`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_load_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = LoadCSV("demo", 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `SaveCSV`

**İmza:** `FUNCTION SaveCSV(ds AS U64, path AS STRING, includeHeader AS I32) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `includeHeader`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_save_csv`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = SaveCSV(h, "demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `Rows`

**İmza:** `FUNCTION Rows(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_rows`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Rows(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputDim`

**İmza:** `FUNCTION InputDim(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = InputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputDim`

**İmza:** `FUNCTION OutputDim(ds AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = OutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `XGet`

**İmza:** `FUNCTION XGet(ds AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_x_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = XGet(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `YGet`

**İmza:** `FUNCTION YGet(ds AS U64, row AS I32, col AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_y_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = YGet(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `XSet`

**İmza:** `FUNCTION XSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_x_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = XSet(h, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `YSet`

**İmza:** `FUNCTION YSet(ds AS U64, row AS I32, col AS I32, v AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `col`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `v`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_y_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = YSet(h, 1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `XPtr`

**İmza:** `FUNCTION XPtr(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_x_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = XPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `YPtr`

**İmza:** `FUNCTION YPtr(ds AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_y_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = YPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `Shuffle`

**İmza:** `FUNCTION Shuffle(ds AS U64, seed AS U32) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `seed`: `U32` parametresi.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_shuffle`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Shuffle(h, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `SplitTrain`

**İmza:** `FUNCTION SplitTrain(ds AS U64, ratio AS F64, seed AS U32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ratio`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `seed`: `U32` parametresi.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_split_train`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = SplitTrain(h, 1.0, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `SplitTest`

**İmza:** `FUNCTION SplitTest(ds AS U64, ratio AS F64, seed AS U32) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ratio`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `seed`: `U32` parametresi.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_split_test`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = SplitTest(h, 1.0, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `Standardize`

**İmza:** `FUNCTION Standardize(ds AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_standardize_fit_transform`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Standardize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `MinMax`

**İmza:** `FUNCTION MinMax(ds AS U64, a AS F64, b AS F64) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `a`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `b`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_dataset_minmax_fit_transform`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = MinMax(h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `ModelCreate`

**İmza:** `FUNCTION ModelCreate(inputDim AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `inputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = ModelCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `ModelFree`

**İmza:** `SUB ModelFree(model AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
ModelFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `AddDense`

**İmza:** `FUNCTION AddDense(model AS U64, outputDim AS I32, activation AS I32) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputDim`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `activation`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_add_dense`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = AddDense(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `Init`

**İmza:** `FUNCTION Init(model AS U64, seed AS U32, scale AS F64) AS I32`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `seed`: `U32` parametresi.
- `scale`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Init(h, 0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `SetOptimizer`

**İmza:** `FUNCTION SetOptimizer(model AS U64, opt AS I32, lr AS F64, momentum AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `opt`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `lr`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `momentum`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_set_optimizer`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = SetOptimizer(h, 1, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `LayerCount`

**İmza:** `FUNCTION LayerCount(model AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_layer_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = LayerCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `ModelOutputDim`

**İmza:** `FUNCTION ModelOutputDim(model AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = ModelOutputDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `PredictArgMax`

**İmza:** `FUNCTION PredictArgMax(model AS U64, ds AS U64, row AS I32) AS I32`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `row`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_predict_argmax`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = PredictArgMax(h, h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `TrainDataset`

**İmza:** `FUNCTION TrainDataset(model AS U64, ds AS U64, epochs AS I32, batchSize AS I32, shuffle AS I32, seed AS U32) AS F64`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `epochs`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `batchSize`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `shuffle`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `seed`: `U32` parametresi.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_train_dataset`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = TrainDataset(h, h, 1, 1, 1, 0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `EvalMSE`

**İmza:** `FUNCTION EvalMSE(model AS U64, ds AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_eval_mse`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = EvalMSE(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `EvalBinaryAccuracy`

**İmza:** `FUNCTION EvalBinaryAccuracy(model AS U64, ds AS U64, threshold AS F64) AS F64`

**Görev:** Yapay zekâ ve sinir ağı hesaplamalarında aktivasyon, kayıp, gradyan veya katman işlemi yürütür.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `ds`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `threshold`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_eval_binary_accuracy`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS F64
sonuc = EvalBinaryAccuracy(h, h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `Save`

**İmza:** `FUNCTION Save(model AS U64, path AS STRING) AS I32`

**Görev:** Hesaplanan veya dönüştürülen veriyi dış dosyaya yazar; rapor, edge list, CSV veya Parquet çıktısı üretir.

**Parametreler:**
- `model`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_save`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS I32
sonuc = Save(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `Load`

**İmza:** `FUNCTION Load(path AS STRING) AS U64`

**Görev:** Dosyadan veya dış kaynaktan veri/oturum açar; CSV, Parquet, model veya veritabanı gibi girdiler bu kapıdan gelir.

**Parametreler:**
- `path`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXNN3_DLL`, yerel sembol `uxnn3_model_load`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxnn3/uxnn3.bas"
USING uxnn3
DIM sonuc AS U64
sonuc = Load("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxnn3/uxnn3_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxonnx`

`uxonnx` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxonnx/uxonnx.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Init`, `Version`, `LastError`
- **Handle yaşam döngüsü:** `SessionCreate`, `SessionFree`, `TensorCreate1D`, `TensorCreate2D`, `TensorCreate3D`, `TensorCreate4D`, `TensorFree`
- **Veri doldurma ve okuma:** `InputCount`, `OutputCount`, `InputName`, `OutputName`, `TensorCount`, `TensorDim`, `TensorDataPtr`, `TensorSet`, `TensorGet`
- **Hesaplama/analiz:** `TensorRank`, `Run1`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Init` | `FUNCTION` | `I32` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `Version` | `FUNCTION` | `STRING` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `SessionCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SessionFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `InputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputName` | `FUNCTION` | `STRING` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `OutputName` | `FUNCTION` | `STRING` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `TensorCreate1D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate2D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate3D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate4D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `TensorCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorSet` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Run1` | `FUNCTION` | `U64` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Init`

**İmza:** `FUNCTION Init(runtimeDir AS STRING) AS I32`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `runtimeDir`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_global_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I32
sonuc = Init("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Version`

**İmza:** `FUNCTION Version() AS STRING`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_runtime_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `LastError`

**İmza:** `FUNCTION LastError(session AS U64) AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = LastError(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `SessionCreate`

**İmza:** `FUNCTION SessionCreate(modelPath AS STRING, intraThreads AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `modelPath`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `intraThreads`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_session_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = SessionCreate("demo", 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `SessionFree`

**İmza:** `SUB SessionFree(session AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_session_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
SessionFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `InputCount`

**İmza:** `FUNCTION InputCount(session AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_input_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = InputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `OutputCount`

**İmza:** `FUNCTION OutputCount(session AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_output_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = OutputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputName`

**İmza:** `FUNCTION InputName(session AS U64, index AS I64) AS STRING`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_input_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = InputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputName`

**İmza:** `FUNCTION OutputName(session AS U64, index AS I64) AS STRING`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_output_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS STRING
sonuc = OutputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `TensorCreate1D`

**İmza:** `FUNCTION TensorCreate1D(n AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_1d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate1D(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `TensorCreate2D`

**İmza:** `FUNCTION TensorCreate2D(r AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `r`: `I64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_2d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate2D(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `TensorCreate3D`

**İmza:** `FUNCTION TensorCreate3D(a AS I64, b AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_3d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate3D(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `TensorCreate4D`

**İmza:** `FUNCTION TensorCreate4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_create_4d_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorCreate4D(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `TensorFree`

**İmza:** `SUB TensorFree(t AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
TensorFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `TensorCount`

**İmza:** `FUNCTION TensorCount(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = TensorCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `TensorRank`

**İmza:** `FUNCTION TensorRank(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = TensorRank(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `TensorDim`

**İmza:** `FUNCTION TensorDim(t AS U64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS I64
sonuc = TensorDim(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `TensorDataPtr`

**İmza:** `FUNCTION TensorDataPtr(t AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = TensorDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `TensorSet`

**İmza:** `SUB TensorSet(t AS U64, idx AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_set_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
TensorSet(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `TensorGet`

**İmza:** `FUNCTION TensorGet(t AS U64, idx AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_tensor_get_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS F64
sonuc = TensorGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `Run1`

**İmza:** `FUNCTION Run1(session AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `session`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `inputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX_DLL`, yerel sembol `uxonnx_run1_f32`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx/uxonnx.bas"
USING uxonnx
DIM sonuc AS U64
sonuc = Run1(h, "demo", h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxonnx/uxonnx_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxonnx2`

`uxonnx2` bölümü uXBasic’in yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxonnx2/uxonnx2.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Init`, `Version`, `LastError`, `ProviderAvailable`
- **Handle yaşam döngüsü:** `SessionCreate`, `SessionCreateAdvanced`, `SessionFree`, `TensorCreate1D`, `TensorCreate2D`, `TensorCreate3D`, `TensorCreate4D`, `TensorFree`, `RunCreate`, `RunFree`, `ResultFree`
- **Veri doldurma ve okuma:** `InputCount`, `OutputCount`, `InputName`, `OutputName`, `InputDim`, `OutputDim`, `TensorDim`, `TensorCount`, `TensorDataPtr`, `TensorSetF64`, `TensorGetF64`, `TensorSetI64` ve 6 işlev daha
- **Hesaplama/analiz:** `InputDType`, `OutputDType`, `InputRank`, `OutputRank`, `TensorDType`, `TensorRank`, `RunExecute`, `ResultTensor`, `Run1`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Init` | `FUNCTION` | `I32` | Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır. |
| `Version` | `FUNCTION` | `STRING` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `LastError` | `FUNCTION` | `STRING` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `ProviderAvailable` | `FUNCTION` | `I32` | Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder. |
| `SessionCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SessionCreateAdvanced` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `SessionFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `InputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputName` | `FUNCTION` | `STRING` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `OutputName` | `FUNCTION` | `STRING` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `InputDType` | `FUNCTION` | `I32` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `OutputDType` | `FUNCTION` | `I32` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `InputRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `InputDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `OutputDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorCreate1D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate2D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate3D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorCreate4D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `TensorFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `TensorDType` | `FUNCTION` | `I32` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorRank` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `TensorDataPtr` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `TensorSetF64` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGetF64` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `TensorSetI64` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGetI64` | `FUNCTION` | `I64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `TensorSetString` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `TensorGetString` | `FUNCTION` | `STRING` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `RunCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `RunFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `RunAddInput` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `RunAddOutput` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `RunExecute` | `FUNCTION` | `U64` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |
| `ResultFree` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `ResultCount` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ResultTensor` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Run1` | `FUNCTION` | `U64` | Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Init`

**İmza:** `FUNCTION Init(runtimeDir AS STRING) AS I32`

**Görev:** Dış runtime klasörünü veya sağlayıcı ortamını başlatır; oturum/hesaplama açılmadan önce çağrılır.

**Parametreler:**
- `runtimeDir`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_init`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = Init("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Version`

**İmza:** `FUNCTION Version() AS STRING`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `LastError`

**İmza:** `FUNCTION LastError() AS STRING`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_last_error`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = LastError()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `ProviderAvailable`

**İmza:** `FUNCTION ProviderAvailable(provider AS I32) AS I32`

**Görev:** Gerekli sağlayıcı, model, DLL veya dış bileşenin erişilebilir olup olmadığını kontrol eder.

**Parametreler:**
- `provider`: `I32` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_provider_available`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = ProviderAvailable(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `SessionCreate`

**İmza:** `FUNCTION SessionCreate(modelPath AS STRING) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `modelPath`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = SessionCreate("demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `SessionCreateAdvanced`

**İmza:** `FUNCTION SessionCreateAdvanced(modelPath AS STRING, provider AS I32, intraThreads AS I32, interThreads AS I32, graphOpt AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `modelPath`: `STRING` dosya veya klasör yolu. Yolun çalışma klasörüne göre mi mutlak mı verildiği örnekte açık tutulmalıdır.
- `provider`: `I32` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `intraThreads`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `interThreads`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `graphOpt`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_create_advanced`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = SessionCreateAdvanced("demo", 1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `SessionFree`

**İmza:** `SUB SessionFree(s AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
SessionFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `InputCount`

**İmza:** `FUNCTION InputCount(s AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = InputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `OutputCount`

**İmza:** `FUNCTION OutputCount(s AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = OutputCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `InputName`

**İmza:** `FUNCTION InputName(s AS U64, idx AS I64) AS STRING`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = InputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `OutputName`

**İmza:** `FUNCTION OutputName(s AS U64, idx AS I64) AS STRING`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_name`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = OutputName(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `InputDType`

**İmza:** `FUNCTION InputDType(s AS U64, idx AS I64) AS I32`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = InputDType(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `OutputDType`

**İmza:** `FUNCTION OutputDType(s AS U64, idx AS I64) AS I32`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = OutputDType(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `InputRank`

**İmza:** `FUNCTION InputRank(s AS U64, idx AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = InputRank(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `OutputRank`

**İmza:** `FUNCTION OutputRank(s AS U64, idx AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = OutputRank(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `InputDim`

**İmza:** `FUNCTION InputDim(s AS U64, idx AS I64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_input_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = InputDim(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `OutputDim`

**İmza:** `FUNCTION OutputDim(s AS U64, idx AS I64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_session_output_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = OutputDim(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `TensorCreate1D`

**İmza:** `FUNCTION TensorCreate1D(dtype AS I32, n AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_1d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate1D(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `TensorCreate2D`

**İmza:** `FUNCTION TensorCreate2D(dtype AS I32, r AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `r`: `I64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_2d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate2D(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `TensorCreate3D`

**İmza:** `FUNCTION TensorCreate3D(dtype AS I32, a AS I64, b AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_3d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate3D(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `TensorCreate4D`

**İmza:** `FUNCTION TensorCreate4D(dtype AS I32, a AS I64, b AS I64, c AS I64, d AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `dtype`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_create_4d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorCreate4D(1, 1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `TensorFree`

**İmza:** `SUB TensorFree(t AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `TensorDType`

**İmza:** `FUNCTION TensorDType(t AS U64) AS I32`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = TensorDType(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `TensorRank`

**İmza:** `FUNCTION TensorRank(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_rank`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorRank(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `TensorDim`

**İmza:** `FUNCTION TensorDim(t AS U64, axis AS I64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `axis`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorDim(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `TensorCount`

**İmza:** `FUNCTION TensorCount(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `TensorDataPtr`

**İmza:** `FUNCTION TensorDataPtr(t AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = TensorDataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `TensorSetF64`

**İmza:** `SUB TensorSetF64(t AS U64, idx AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_set_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorSetF64(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `TensorGetF64`

**İmza:** `FUNCTION TensorGetF64(t AS U64, idx AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_get_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS F64
sonuc = TensorGetF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `TensorSetI64`

**İmza:** `SUB TensorSetI64(t AS U64, idx AS I64, value AS I64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_set_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorSetI64(h, 1, 1)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `TensorGetI64`

**İmza:** `FUNCTION TensorGetI64(t AS U64, idx AS I64) AS I64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_get_i64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = TensorGetI64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `TensorSetString`

**İmza:** `SUB TensorSetString(t AS U64, idx AS I64, value AS STRING)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `STRING` metin parametresi.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_set_string`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
TensorSetString(h, 1, "demo")
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `TensorGetString`

**İmza:** `FUNCTION TensorGetString(t AS U64, idx AS I64) AS STRING`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_tensor_get_string`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS STRING
sonuc = TensorGetString(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `RunCreate`

**İmza:** `FUNCTION RunCreate(s AS U64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = RunCreate(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `RunFree`

**İmza:** `SUB RunFree(r AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
RunFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `RunAddInput`

**İmza:** `FUNCTION RunAddInput(r AS U64, name AS STRING, t AS U64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `name`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_add_input`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = RunAddInput(h, "demo", h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `RunAddOutput`

**İmza:** `FUNCTION RunAddOutput(r AS U64, name AS STRING) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `name`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_add_output`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I32
sonuc = RunAddOutput(h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `RunExecute`

**İmza:** `FUNCTION RunExecute(r AS U64) AS U64`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `r`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run_execute`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = RunExecute(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `ResultFree`

**İmza:** `SUB ResultFree(res AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `res`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_result_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
ResultFree(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `ResultCount`

**İmza:** `FUNCTION ResultCount(res AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `res`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_result_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS I64
sonuc = ResultCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `ResultTensor`

**İmza:** `FUNCTION ResultTensor(res AS U64, idx AS I64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `res`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `idx`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_result_tensor`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = ResultTensor(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `Run1`

**İmza:** `FUNCTION Run1(s AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING) AS U64`

**Görev:** Model oturumu, giriş/çıkış tanımı veya inference çalıştırma adımında kullanılır.

**Parametreler:**
- `s`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `inputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.
- `inputTensor`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `outputName`: `STRING` ad/anahtar/seçici metin veya kodu. Sözlük, kolon, giriş-çıkış veya sağlayıcı seçimi için kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXONNX2_DLL`, yerel sembol `uxonnx2_run1`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxonnx2/uxonnx2.bas"
USING uxonnx2
DIM sonuc AS U64
sonuc = Run1(h, "demo", h, "demo")
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxonnx2/uxonnx2_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxstats`

`uxstats` bölümü uXBasic’in istatistik, hipotez testi ve veri analizi için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxstats/uxstats.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxstats/uxstats.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXSTATS_Version`
- **Handle yaşam döngüsü:** `UXSTATS_VecCreate`, `UXSTATS_VecFree`
- **Veri doldurma ve okuma:** `UXSTATS_VecCount`, `UXSTATS_VecPush`, `UXSTATS_VecSet`, `UXSTATS_VecGet`, `UXSTATS_VariancePop`, `UXSTATS_StdDevPop`
- **Hesaplama/analiz:** `UXSTATS_VecCapacity`, `UXSTATS_Sum`, `UXSTATS_Mean`, `UXSTATS_Min`, `UXSTATS_Max`, `UXSTATS_Range`, `UXSTATS_VarianceSamp`, `UXSTATS_StdDevSamp`, `UXSTATS_Median`, `UXSTATS_Percentile`, `UXSTATS_CovarianceSamp`, `UXSTATS_Correlation` ve 5 işlev daha
- **Dışa aktarma ve temizlik:** `UXSTATS_VecClear`

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXSTATS_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXSTATS_VecCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS_VecFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXSTATS_VecClear` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXSTATS_VecCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXSTATS_VecCapacity` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS_VecPush` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXSTATS_VecSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXSTATS_VecGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXSTATS_Sum` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Mean` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Min` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Max` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Range` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_VariancePop` | `FUNCTION` | `F64` | Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür. |
| `UXSTATS_VarianceSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_StdDevPop` | `FUNCTION` | `F64` | Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür. |
| `UXSTATS_StdDevSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Median` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Percentile` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_CovarianceSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_Correlation` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RegressionSlope` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RegressionIntercept` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RegressionR2` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS_RawMeanF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS_RawStdDevSampF64` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXSTATS_Version`

**İmza:** `FUNCTION UXSTATS_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXSTATS_VecCreate`

**İmza:** `FUNCTION UXSTATS_VecCreate(capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS U64
sonuc = UXSTATS_VecCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXSTATS_VecFree`

**İmza:** `FUNCTION UXSTATS_VecFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXSTATS_VecClear`

**İmza:** `FUNCTION UXSTATS_VecClear(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_clear`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecClear(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXSTATS_VecCount`

**İmza:** `FUNCTION UXSTATS_VecCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXSTATS_VecCapacity`

**İmza:** `FUNCTION UXSTATS_VecCapacity(h AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_capacity`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecCapacity(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXSTATS_VecPush`

**İmza:** `FUNCTION UXSTATS_VecPush(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_push`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecPush(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXSTATS_VecSet`

**İmza:** `FUNCTION UXSTATS_VecSet(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS I32
sonuc = UXSTATS_VecSet(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXSTATS_VecGet`

**İmza:** `FUNCTION UXSTATS_VecGet(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_VecGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `UXSTATS_Sum`

**İmza:** `FUNCTION UXSTATS_Sum(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_sum`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Sum(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `UXSTATS_Mean`

**İmza:** `FUNCTION UXSTATS_Mean(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_mean`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Mean(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `UXSTATS_Min`

**İmza:** `FUNCTION UXSTATS_Min(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_min`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Min(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `UXSTATS_Max`

**İmza:** `FUNCTION UXSTATS_Max(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_max`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Max(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `UXSTATS_Range`

**İmza:** `FUNCTION UXSTATS_Range(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_range`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Range(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `UXSTATS_VariancePop`

**İmza:** `FUNCTION UXSTATS_VariancePop(h AS U64) AS F64`

**Görev:** Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_variance_pop`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_VariancePop(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `UXSTATS_VarianceSamp`

**İmza:** `FUNCTION UXSTATS_VarianceSamp(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_variance_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_VarianceSamp(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `UXSTATS_StdDevPop`

**İmza:** `FUNCTION UXSTATS_StdDevPop(h AS U64) AS F64`

**Görev:** Stack veya queue gibi yapılardan sıradaki değeri çıkarır ve döndürür.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_stddev_pop`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_StdDevPop(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `UXSTATS_StdDevSamp`

**İmza:** `FUNCTION UXSTATS_StdDevSamp(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_stddev_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_StdDevSamp(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `UXSTATS_Median`

**İmza:** `FUNCTION UXSTATS_Median(h AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_median`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Median(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `UXSTATS_Percentile`

**İmza:** `FUNCTION UXSTATS_Percentile(h AS U64, p AS F64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `p`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_percentile`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Percentile(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `UXSTATS_CovarianceSamp`

**İmza:** `FUNCTION UXSTATS_CovarianceSamp(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_covariance_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_CovarianceSamp(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `UXSTATS_Correlation`

**İmza:** `FUNCTION UXSTATS_Correlation(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_correlation`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_Correlation(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `UXSTATS_RegressionSlope`

**İmza:** `FUNCTION UXSTATS_RegressionSlope(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_regression_slope`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RegressionSlope(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `UXSTATS_RegressionIntercept`

**İmza:** `FUNCTION UXSTATS_RegressionIntercept(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_regression_intercept`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RegressionIntercept(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `UXSTATS_RegressionR2`

**İmza:** `FUNCTION UXSTATS_RegressionR2(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_vec_regression_r2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RegressionR2(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `UXSTATS_RawMeanF64`

**İmza:** `FUNCTION UXSTATS_RawMeanF64(ptr AS U64, count AS I32) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ptr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_mean_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RawMeanF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `UXSTATS_RawStdDevSampF64`

**İmza:** `FUNCTION UXSTATS_RawStdDevSampF64(ptr AS U64, count AS I32) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `ptr`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `count`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats.dll`, yerel sembol `uxstats_stddev_samp_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats.bas"
DIM sonuc AS F64
sonuc = UXSTATS_RawStdDevSampF64(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxstats/uxstats_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxstats2`

`uxstats2` bölümü uXBasic’in istatistik, hipotez testi ve veri analizi için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxstats/uxstats2.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `UXSTATS2_Version`
- **Handle yaşam döngüsü:** `UXSTATS2_VecCreate`, `UXSTATS2_VecFree`, `UXSTATS2_AnovaOneWayF`, `UXSTATS2_AnovaOneWayP`
- **Veri doldurma ve okuma:** `UXSTATS2_VecPush`, `UXSTATS2_VecSet`, `UXSTATS2_VecGet`, `UXSTATS2_VecCount`
- **Hesaplama/analiz:** `UXSTATS2_NormalCDF`, `UXSTATS2_NormalP2`, `UXSTATS2_TP2`, `UXSTATS2_ChiSquareP`, `UXSTATS2_FP`, `UXSTATS2_OneSampleTStat`, `UXSTATS2_OneSampleTP`, `UXSTATS2_WelchTStat`, `UXSTATS2_WelchTP`, `UXSTATS2_PooledTStat`, `UXSTATS2_PooledTP`, `UXSTATS2_PairedTStat` ve 35 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `UXSTATS2_Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `UXSTATS2_VecCreate` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS2_VecFree` | `FUNCTION` | `I32` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `UXSTATS2_VecPush` | `FUNCTION` | `I32` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `UXSTATS2_VecSet` | `FUNCTION` | `I32` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `UXSTATS2_VecGet` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `UXSTATS2_VecCount` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `UXSTATS2_NormalCDF` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXSTATS2_NormalP2` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `UXSTATS2_TP2` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquareP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_FP` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_OneSampleTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OneSampleTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_WelchTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_WelchTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PooledTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PooledTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PairedTStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PairedTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OneSampleZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OneSampleZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoSampleZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoSampleZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OnePropZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_OnePropZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoPropZStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_TwoPropZP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_FVarianceStat` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS2_FVarianceP` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS2_ChiSquareGOFStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquareGOFP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquare2x2Stat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ChiSquare2x2P` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_AnovaOneWayF` | `FUNCTION` | `F64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS2_AnovaOneWayP` | `FUNCTION` | `F64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `UXSTATS2_PosthocBonferroniTP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_PosthocTukeyQ` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_PosthocScheffeF` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_CovarianceSamp` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `UXSTATS2_Correlation` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionSlope` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionIntercept` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionR2` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionF` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_RegressionFP` | `FUNCTION` | `F64` | İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar. |
| `UXSTATS2_VIFPair` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_DurbinWatson` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_BreuschGodfreyLM` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_BreuschGodfreyP` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_ADFStat` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_ADFP` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_AncovaBinaryF` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_AncovaBinaryP` | `FUNCTION` | `F64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `UXSTATS2_HotellingT2_2D` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |
| `UXSTATS2_HotellingP_2D` | `FUNCTION` | `F64` | İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `UXSTATS2_Version`

**İmza:** `FUNCTION UXSTATS2_Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `UXSTATS2_VecCreate`

**İmza:** `FUNCTION UXSTATS2_VecCreate(capacity AS I32) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `capacity`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_create`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS U64
sonuc = UXSTATS2_VecCreate(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `UXSTATS2_VecFree`

**İmza:** `FUNCTION UXSTATS2_VecFree(h AS U64) AS I32`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecFree(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `UXSTATS2_VecPush`

**İmza:** `FUNCTION UXSTATS2_VecPush(h AS U64, value AS F64) AS I32`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_push`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecPush(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `UXSTATS2_VecSet`

**İmza:** `FUNCTION UXSTATS2_VecSet(h AS U64, index AS I32, value AS F64) AS I32`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_set`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecSet(h, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `UXSTATS2_VecGet`

**İmza:** `FUNCTION UXSTATS2_VecGet(h AS U64, index AS I32) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_get`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_VecGet(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `UXSTATS2_VecCount`

**İmza:** `FUNCTION UXSTATS2_VecCount(h AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `h`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vec_count`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS I32
sonuc = UXSTATS2_VecCount(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `UXSTATS2_NormalCDF`

**İmza:** `FUNCTION UXSTATS2_NormalCDF(z AS F64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `z`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_normal_cdf`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_NormalCDF(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `UXSTATS2_NormalP2`

**İmza:** `FUNCTION UXSTATS2_NormalP2(z AS F64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `z`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_normal_p2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_NormalP2(1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `UXSTATS2_TP2`

**İmza:** `FUNCTION UXSTATS2_TP2(t AS F64, df AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `t`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `df`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_t_p2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TP2(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `UXSTATS2_ChiSquareP`

**İmza:** `FUNCTION UXSTATS2_ChiSquareP(stat AS F64, df AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `stat`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `df`: `F64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquareP(1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `UXSTATS2_FP`

**İmza:** `FUNCTION UXSTATS2_FP(stat AS F64, df1 AS F64, df2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `stat`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `df1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `df2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_f_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_FP(1.0, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `UXSTATS2_OneSampleTStat`

**İmza:** `FUNCTION UXSTATS2_OneSampleTStat(x AS U64, mu0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleTStat(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `UXSTATS2_OneSampleTP`

**İmza:** `FUNCTION UXSTATS2_OneSampleTP(x AS U64, mu0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleTP(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `UXSTATS2_WelchTStat`

**İmza:** `FUNCTION UXSTATS2_WelchTStat(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_welch_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_WelchTStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `UXSTATS2_WelchTP`

**İmza:** `FUNCTION UXSTATS2_WelchTP(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_welch_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_WelchTP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `UXSTATS2_PooledTStat`

**İmza:** `FUNCTION UXSTATS2_PooledTStat(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_pooled_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PooledTStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `UXSTATS2_PooledTP`

**İmza:** `FUNCTION UXSTATS2_PooledTP(x AS U64, y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_pooled_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PooledTP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `UXSTATS2_PairedTStat`

**İmza:** `FUNCTION UXSTATS2_PairedTStat(before AS U64, after AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `before`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `after`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_paired_t_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PairedTStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `UXSTATS2_PairedTP`

**İmza:** `FUNCTION UXSTATS2_PairedTP(before AS U64, after AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `before`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `after`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_paired_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PairedTP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `UXSTATS2_OneSampleZStat`

**İmza:** `FUNCTION UXSTATS2_OneSampleZStat(x AS U64, mu0 AS F64, sigma AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigma`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleZStat(h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `UXSTATS2_OneSampleZP`

**İmza:** `FUNCTION UXSTATS2_OneSampleZP(x AS U64, mu0 AS F64, sigma AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `mu0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigma`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_sample_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OneSampleZP(h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `UXSTATS2_TwoSampleZStat`

**İmza:** `FUNCTION UXSTATS2_TwoSampleZStat(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sigmaX`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigmaY`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_sample_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoSampleZStat(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `UXSTATS2_TwoSampleZP`

**İmza:** `FUNCTION UXSTATS2_TwoSampleZP(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `sigmaX`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `sigmaY`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_sample_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoSampleZP(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `UXSTATS2_OnePropZStat`

**İmza:** `FUNCTION UXSTATS2_OnePropZStat(successes AS I32, n AS I32, p0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `successes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `p0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_prop_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OnePropZStat(1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `UXSTATS2_OnePropZP`

**İmza:** `FUNCTION UXSTATS2_OnePropZP(successes AS I32, n AS I32, p0 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `successes`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `p0`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_one_prop_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_OnePropZP(1, 1, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `UXSTATS2_TwoPropZStat`

**İmza:** `FUNCTION UXSTATS2_TwoPropZStat(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `s2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_prop_z_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoPropZStat(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `UXSTATS2_TwoPropZP`

**İmza:** `FUNCTION UXSTATS2_TwoPropZP(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `s1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n1`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `s2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `n2`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_two_prop_z_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_TwoPropZP(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `UXSTATS2_FVarianceStat`

**İmza:** `FUNCTION UXSTATS2_FVarianceStat(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_f_variance_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_FVarianceStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `UXSTATS2_FVarianceP`

**İmza:** `FUNCTION UXSTATS2_FVarianceP(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_f_variance_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_FVarianceP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `UXSTATS2_ChiSquareGOFStat`

**İmza:** `FUNCTION UXSTATS2_ChiSquareGOFStat(obs AS U64, exp AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `obs`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `exp`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_gof_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquareGOFStat(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `UXSTATS2_ChiSquareGOFP`

**İmza:** `FUNCTION UXSTATS2_ChiSquareGOFP(obs AS U64, exp AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `obs`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `exp`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_gof_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquareGOFP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `UXSTATS2_ChiSquare2x2Stat`

**İmza:** `FUNCTION UXSTATS2_ChiSquare2x2Stat(a AS F64, b AS F64, c AS F64, d AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `a`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `b`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `c`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `d`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_2x2_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquare2x2Stat(1.0, 1.0, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `UXSTATS2_ChiSquare2x2P`

**İmza:** `FUNCTION UXSTATS2_ChiSquare2x2P(a AS F64, b AS F64, c AS F64, d AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `a`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `b`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `c`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `d`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_chisq_2x2_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ChiSquare2x2P(1.0, 1.0, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `UXSTATS2_AnovaOneWayF`

**İmza:** `FUNCTION UXSTATS2_AnovaOneWayF(values AS U64, groups AS U64) AS F64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_anova_oneway_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AnovaOneWayF(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `UXSTATS2_AnovaOneWayP`

**İmza:** `FUNCTION UXSTATS2_AnovaOneWayP(values AS U64, groups AS U64) AS F64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_anova_oneway_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AnovaOneWayP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `UXSTATS2_PosthocBonferroniTP`

**İmza:** `FUNCTION UXSTATS2_PosthocBonferroniTP(values AS U64, groups AS U64, g1 AS F64, g2 AS F64, comparisons AS I32) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `comparisons`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_posthoc_bonferroni_t_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PosthocBonferroniTP(h, h, 1.0, 1.0, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `UXSTATS2_PosthocTukeyQ`

**İmza:** `FUNCTION UXSTATS2_PosthocTukeyQ(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_posthoc_tukey_q`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PosthocTukeyQ(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 39. `UXSTATS2_PosthocScheffeF`

**İmza:** `FUNCTION UXSTATS2_PosthocScheffeF(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `values`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_posthoc_scheffe_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_PosthocScheffeF(h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 40. `UXSTATS2_CovarianceSamp`

**İmza:** `FUNCTION UXSTATS2_CovarianceSamp(x AS U64, y AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_covariance_samp`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_CovarianceSamp(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 41. `UXSTATS2_Correlation`

**İmza:** `FUNCTION UXSTATS2_Correlation(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_correlation`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_Correlation(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 42. `UXSTATS2_RegressionSlope`

**İmza:** `FUNCTION UXSTATS2_RegressionSlope(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_slope`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionSlope(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 43. `UXSTATS2_RegressionIntercept`

**İmza:** `FUNCTION UXSTATS2_RegressionIntercept(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_intercept`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionIntercept(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 44. `UXSTATS2_RegressionR2`

**İmza:** `FUNCTION UXSTATS2_RegressionR2(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_r2`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionR2(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 45. `UXSTATS2_RegressionF`

**İmza:** `FUNCTION UXSTATS2_RegressionF(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionF(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 46. `UXSTATS2_RegressionFP`

**İmza:** `FUNCTION UXSTATS2_RegressionFP(x AS U64, y AS U64) AS F64`

**Görev:** İki değişken arasındaki ilişkiyi veya doğrusal model parametrelerini hesaplar.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_regression_f_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_RegressionFP(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 47. `UXSTATS2_VIFPair`

**İmza:** `FUNCTION UXSTATS2_VIFPair(x AS U64, y AS U64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_vif_pair`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_VIFPair(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 48. `UXSTATS2_DurbinWatson`

**İmza:** `FUNCTION UXSTATS2_DurbinWatson(resid AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `resid`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_durbin_watson`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_DurbinWatson(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 49. `UXSTATS2_BreuschGodfreyLM`

**İmza:** `FUNCTION UXSTATS2_BreuschGodfreyLM(resid AS U64, lags AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `resid`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `lags`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_breusch_godfrey_lm`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_BreuschGodfreyLM(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 50. `UXSTATS2_BreuschGodfreyP`

**İmza:** `FUNCTION UXSTATS2_BreuschGodfreyP(resid AS U64, lags AS I32) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `resid`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `lags`: `I32` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_breusch_godfrey_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_BreuschGodfreyP(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 51. `UXSTATS2_ADFStat`

**İmza:** `FUNCTION UXSTATS2_ADFStat(y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_adf_stat`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ADFStat(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 52. `UXSTATS2_ADFP`

**İmza:** `FUNCTION UXSTATS2_ADFP(y AS U64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_adf_p_approx`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_ADFP(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 53. `UXSTATS2_AncovaBinaryF`

**İmza:** `FUNCTION UXSTATS2_AncovaBinaryF(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `covar`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_ancova_binary_f`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AncovaBinaryF(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 54. `UXSTATS2_AncovaBinaryP`

**İmza:** `FUNCTION UXSTATS2_AncovaBinaryP(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `y`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `covar`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_ancova_binary_p`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_AncovaBinaryP(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 55. `UXSTATS2_HotellingT2_2D`

**İmza:** `FUNCTION UXSTATS2_HotellingT2_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x1`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x2`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_hotelling_t2_2d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_HotellingT2_2D(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 56. `UXSTATS2_HotellingP_2D`

**İmza:** `FUNCTION UXSTATS2_HotellingP_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64`

**Görev:** İstatistiksel hipotez testi, model tanısı veya ileri analiz sonucu üretir.

**Parametreler:**
- `x1`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x2`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `groups`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `g1`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.
- `g2`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `uxstats2.dll`, yerel sembol `uxstats2_hotelling_p_2d`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxstats/uxstats2.bas"
DIM sonuc AS F64
sonuc = UXSTATS2_HotellingP_2D(h, h, h, 1.0, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxstats2/uxstats2_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Referansı: `uxtensor`

`uxtensor` bölümü uXBasic’in tensor, çok boyutlu dizi ve temel lineer cebir için hazırladığı dış kütüphane wrapper yüzeyini açıklar. Bu belge doğrudan `libsx/uxtensor/uxtensor.bas` dosyasındaki imzalardan üretilmiştir. Her fonksiyon ayrı anlatılır; amaç, parametre, dönüş türü, dış DLL rotası ve kullanım biçimi birlikte verilir.

> Not: Bu bölümdeki özellikler çalışır kabul edilen dış kütüphane yüzeyidir. Çağrı yolu çoğunlukla `INCLUDE` + wrapper fonksiyonu + `CALL(DLL, ...)` zinciriyle yürür. DLL dosyasının çalışma klasöründe veya runtime extension arama yolunda bulunması gerekir.

## Kullanım başlangıcı

```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
PRINT "DIS_KUTUPHANE_BASLADI"
```

## Fonksiyon aileleri

- **Kurulum ve sürüm denetimi:** `Version`, `Backend`
- **Handle yaşam döngüsü:** `Create1D`, `Create2D`, `Create3D`, `Create4D`, `Free`, `Clone`
- **Veri doldurma ve okuma:** `NDim`, `Dim`, `DataPtr`, `GetFlat`, `SetFlat`, `Get2D`, `Set2D`, `Get3D`, `Set3D`, `Get4D`, `Set4D`, `Add`
- **Hesaplama/analiz:** `SliceAxis0`, `DType`, `Stride`, `Size`, `ElemSize`, `Fill`, `Zero`, `Subtract`, `Multiply`, `Divide`, `Scale`, `Sum` ve 6 işlev daha

## Hızlı fonksiyon tablosu

| Fonksiyon | Tür | Dönüş | Kısa görev |
|---|---|---|---|
| `Version` | `FUNCTION` | `I32` | Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır. |
| `Backend` | `FUNCTION` | `STRING` | Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar. |
| `Create1D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Create2D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Create3D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Create4D` | `FUNCTION` | `U64` | Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir. |
| `Free` | `SUB` | `-` | Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır. |
| `Clone` | `FUNCTION` | `U64` | Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır. |
| `SliceAxis0` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `DType` | `FUNCTION` | `I32` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `NDim` | `FUNCTION` | `I32` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Dim` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `Stride` | `FUNCTION` | `I64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Size` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `ElemSize` | `FUNCTION` | `I64` | Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir. |
| `DataPtr` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Fill` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Zero` | `SUB` | `-` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `GetFlat` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `SetFlat` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Get2D` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Set2D` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Get3D` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Set3D` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Get4D` | `FUNCTION` | `F64` | Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur. |
| `Set4D` | `SUB` | `-` | Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır. |
| `Add` | `FUNCTION` | `U64` | Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler. |
| `Subtract` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Multiply` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Divide` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Scale` | `FUNCTION` | `U64` | Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir. |
| `Sum` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `Mean` | `FUNCTION` | `F64` | Sayısal vektör veya tablo üzerinde özet istatistik üretir. |
| `Dot` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Norm2` | `FUNCTION` | `F64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `MatMul` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `MatVec` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |
| `Transpose2D` | `FUNCTION` | `U64` | Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır. |

## Fonksiyonların ayrıntılı anlatımı

### 1. `Version`

**İmza:** `FUNCTION Version() AS I32`

**Görev:** Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür; kurulum denetiminde ilk çağrıdır.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_version`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I32
sonuc = Version()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 2. `Backend`

**İmza:** `FUNCTION Backend() AS STRING`

**Görev:** Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir; CPU/OpenBLAS/DuckDB/ONNX gibi seçimleri görünür kılar.

**Parametreler:** Parametre almaz; çoğunlukla sürüm, backend, yeni handle veya global durum bilgisini döndürür.

**Dönen değer:** Metin döndürür; sürüm, hata, kolon adı, sağlayıcı adı veya tanımlayıcı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_backend`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS STRING
sonuc = Backend()
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 3. `Create1D`

**İmza:** `FUNCTION Create1D(n AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `n`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_create1d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Create1D(1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 4. `Create2D`

**İmza:** `FUNCTION Create2D(rows AS I64, cols AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `rows`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `cols`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_create2d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Create2D(1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 5. `Create3D`

**İmza:** `FUNCTION Create3D(a AS I64, b AS I64, c AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_create3d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Create3D(1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 6. `Create4D`

**İmza:** `FUNCTION Create4D(a AS I64, b AS I64, c AS I64, d AS I64) AS U64`

**Görev:** Yeni handle/nesne/tampon/oturum oluşturur; dönen U64 değeri sonraki çağrıların merkezidir.

**Parametreler:**
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_create4d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Create4D(1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 7. `Free`

**İmza:** `SUB Free(t AS U64)`

**Görev:** Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler; bellek sızıntısını önleyen kapanış adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_free`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
Free(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 8. `Clone`

**İmza:** `FUNCTION Clone(t AS U64) AS U64`

**Görev:** Var olan veri yapısını kopyalar; orijinal veri bozulmadan yeni akış denemek için kullanılır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_clone`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Clone(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 9. `SliceAxis0`

**İmza:** `FUNCTION SliceAxis0(t AS U64, start AS I64, count AS I64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `start`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `count`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_slice_axis0_copy`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = SliceAxis0(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 10. `DType`

**İmza:** `FUNCTION DType(t AS U64) AS I32`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_dtype`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I32
sonuc = DType(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 11. `NDim`

**İmza:** `FUNCTION NDim(t AS U64) AS I32`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 32 bit işaretli tam sayı döndürür; çoğunlukla durum, sayım veya başarı kodudur.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_ndim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I32
sonuc = NDim(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 12. `Dim`

**İmza:** `FUNCTION Dim(t AS U64, axis AS I32) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `axis`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_dim`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I64
sonuc = Dim(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 13. `Stride`

**İmza:** `FUNCTION Stride(t AS U64, axis AS I32) AS I64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `axis`: `I32` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_stride`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I64
sonuc = Stride(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 14. `Size`

**İmza:** `FUNCTION Size(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I64
sonuc = Size(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 15. `ElemSize`

**İmza:** `FUNCTION ElemSize(t AS U64) AS I64`

**Görev:** Verinin boyutunu, satır/sütun sayısını, eksen uzunluğunu veya eleman sayısını bildirir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** 64 bit işaretli tam sayı döndürür; büyük sayaç, satır sayısı veya boyut bilgisidir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_elem_size`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS I64
sonuc = ElemSize(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 16. `DataPtr`

**İmza:** `FUNCTION DataPtr(t AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_data_ptr`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = DataPtr(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 17. `Fill`

**İmza:** `SUB Fill(t AS U64, value AS F64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_fill_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
Fill(h, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 18. `Zero`

**İmza:** `SUB Zero(t AS U64)`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_zero`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
Zero(h)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 19. `GetFlat`

**İmza:** `FUNCTION GetFlat(t AS U64, index AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_get_flat_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = GetFlat(h, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 20. `SetFlat`

**İmza:** `SUB SetFlat(t AS U64, index AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `index`: `I64` boyut/sayaç/indeks değeri. Sınır dışı değer verilirse dış kütüphane tarafında hata veya boş sonuç oluşabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_set_flat_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
SetFlat(h, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 21. `Get2D`

**İmza:** `FUNCTION Get2D(t AS U64, r AS I64, c AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `r`: `I64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_get2d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Get2D(h, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 22. `Set2D`

**İmza:** `SUB Set2D(t AS U64, r AS I64, c AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `r`: `I64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_set2d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
Set2D(h, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 23. `Get3D`

**İmza:** `FUNCTION Get3D(t AS U64, a AS I64, b AS I64, c AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_get3d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Get3D(h, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 24. `Set3D`

**İmza:** `SUB Set3D(t AS U64, a AS I64, b AS I64, c AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_set3d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
Set3D(h, 1, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 25. `Get4D`

**İmza:** `FUNCTION Get4D(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64) AS F64`

**Görev:** Handle içinden değer, hücre, metin, tensor elemanı veya istatistik sonucunu okur.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_get4d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Get4D(h, 1, 1, 1, 1)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 26. `Set4D`

**İmza:** `SUB Set4D(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64, value AS F64)`

**Görev:** Var olan handle içine değer, seçenek, parametre veya hücre yazar; yapılandırma ve veri doldurma adımıdır.

**Parametreler:**
- `t`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `a`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `b`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `c`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `d`: `I64` tam sayı parametre. Sayaç, mod, sınıf etiketi, thread sayısı veya seçenek kodu olabilir.
- `value`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** `SUB` olduğu için doğrudan değer döndürmez; etkisini verilen handle, dış runtime veya bellek bölgesi üzerinde bırakır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_set4d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
Set4D(h, 1, 1, 1, 1, 1.0)
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 27. `Add`

**İmza:** `FUNCTION Add(a AS U64, b AS U64) AS U64`

**Görev:** Koleksiyona, grafa, listeye, sete veya çalışma nesnesine yeni değer/kenar/girdi ekler.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_add_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Add(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 28. `Subtract`

**İmza:** `FUNCTION Subtract(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_sub_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Subtract(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 29. `Multiply`

**İmza:** `FUNCTION Multiply(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_mul_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Multiply(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 30. `Divide`

**İmza:** `FUNCTION Divide(a AS U64, b AS U64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_div_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Divide(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 31. `Scale`

**İmza:** `FUNCTION Scale(a AS U64, scalar AS F64) AS U64`

**Görev:** Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür; görevi imza, parametre adları ve bağlı DLL rotasıyla birlikte değerlendirilir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `scalar`: `F64` ondalık parametre. Ölçüm, katsayı, eşik, öğrenme oranı veya istatistik değeri olarak kullanılır.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_scale_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Scale(h, 1.0)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 32. `Sum`

**İmza:** `FUNCTION Sum(a AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_sum_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Sum(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 33. `Mean`

**İmza:** `FUNCTION Mean(a AS U64) AS F64`

**Görev:** Sayısal vektör veya tablo üzerinde özet istatistik üretir.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_mean_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Mean(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 34. `Dot`

**İmza:** `FUNCTION Dot(a AS U64, b AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_dot_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Dot(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 35. `Norm2`

**İmza:** `FUNCTION Norm2(a AS U64) AS F64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Çift duyarlıklı ondalık sonuç döndürür; istatistik, ölçüm, skor veya model çıktısı olabilir.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_norm2_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS F64
sonuc = Norm2(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 36. `MatMul`

**İmza:** `FUNCTION MatMul(a AS U64, b AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `b`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_matmul2d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = MatMul(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 37. `MatVec`

**İmza:** `FUNCTION MatVec(a AS U64, x AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.
- `x`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_matvec2d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = MatVec(h, h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

### 38. `Transpose2D`

**İmza:** `FUNCTION Transpose2D(a AS U64) AS U64`

**Görev:** Tensor/matris boyutu, elemanı veya lineer cebir işlemi üzerinde çalışır.

**Parametreler:**
- `a`: `U64` handle/pointer değeri. Bu değer genellikle bir `Create`, `Open`, `Load` veya `SessionCreate` çağrısından gelir.

**Dönen değer:** Handle, pointer veya runtime nesne adresi döndürür; iş bittiğinde ilgili Free fonksiyonu çağrılır.

**Dış rota:** DLL/servis ifadesi `UXTENSOR_DLL`, yerel sembol `uxtensor_transpose2d_f64`.

**Kullanım iskeleti:**
```basic
INCLUDE "libsx/uxtensor/uxtensor.bas"
USING uxtensor
DIM sonuc AS U64
sonuc = Transpose2D(h)
PRINT sonuc
```

**Dikkat:** Handle döndüren çağrılarda kapanış fonksiyonu aranmalıdır. Pointer alan çağrılarda `U64` değerinin gerçekten geçerli bellek adresi olduğundan emin olunmalıdır. Dosya yolu alan çağrılarda çıktı klasörü önceden hazırlanmalıdır.

## Uzun kullanım senaryoları

### Senaryo 1: kurulum, sürüm ve çalışma yolu denetimi

Bu senaryo `docs_examples/external_libraries/uxtensor/uxtensor_ornek_01.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 2: handle oluşturma, veri doldurma ve okuma

Bu senaryo `docs_examples/external_libraries/uxtensor/uxtensor_ornek_02.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 3: ölçüm/hesaplama/analiz akışı

Bu senaryo `docs_examples/external_libraries/uxtensor/uxtensor_ornek_03.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 4: dosya, çıktı veya rapor üretimi

Bu senaryo `docs_examples/external_libraries/uxtensor/uxtensor_ornek_04.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

### Senaryo 5: hata kontrolü, temizlik ve başka modülle birleşme

Bu senaryo `docs_examples/external_libraries/uxtensor/uxtensor_ornek_05.uxb` dosyasında uzun REM açıklamalarıyla ayrı program olarak verilmiştir. Kitap içindeki amaç, modülün yalnız fonksiyon listesi değil, küçük proje parçası olarak nasıl düşünülmesi gerektiğini göstermektir.

---

# Dış Kütüphane Terminal Rehberi

Dış kütüphaneler yalnız belgede okunmaz; build, smoke test, AST/MIR çalıştırma ve runtime DLL denetimiyle kontrol edilir. Bu bölümde komutlar Windows PowerShell üzerinden verilir.

## Runtime extension DLL dosyalarını derleme

```powershell
.\compiler\scripts\build_all_runtime_ext_dlls.bat
.\compiler\scripts\build_imported_library_runtimes.bat
```

## Dış kütüphane smoke testleri

```powershell
.\compiler\scripts\run_uxaimath_smoke.bat
.\compiler\scripts\run_uxcollections_smoke.bat
.\compiler\scripts\run_uxdataframe_smoke.bat
.\compiler\scripts\run_uxdataset_smoke.bat
.\compiler\scripts\run_uxgraph_smoke.bat
.\compiler\scripts\run_uxllama_smoke.bat
.\compiler\scripts\run_uxllamax_placeholder_smoke.bat
.\compiler\scripts\run_uxmath_smoke.bat
.\compiler\scripts\run_uxmathcore_smoke.bat
.\compiler\scripts\run_uxmatrix_smoke.bat
.\compiler\scripts\run_uxnn_smoke.bat
.\compiler\scripts\run_uxnn2_smoke.bat
.\compiler\scripts\run_uxnn3_smoke.bat
.\compiler\scripts\run_uxonnx_smoke.bat
.\compiler\scripts\run_uxonnx2_smoke.bat
.\compiler\scripts\run_uxstats_smoke.bat
.\compiler\scripts\run_uxstats2_smoke.bat
.\compiler\scripts\run_uxtensor_smoke.bat
```

## Kitap örneklerini AST ve MIR yorumlayıcı ile çalıştırma

```powershell
.\tools\docs\run_external_library_examples.ps1 -Root . -Backend AST
.\tools\docs\run_external_library_examples.ps1 -Root . -Backend MIR
```

## Compiler katman çıktılarıyla dış kütüphane örneği üretme

Aşağıdaki komutlar tek bir `.uxb` örneğinin preprocess, AST, MIR ve artefact JSON çıktısını aynı klasöre alır. CLI anahtarları kaynak baskıya göre değişebileceği için kitapta bu komutlar pratik şablon olarak verilir.

```powershell
$SRC = "docs_examples\external_libraries\uxstats\uxstats_ornek_01.uxb"
$OUT = "reports\book_external_layers\uxstats_ornek_01"
New-Item -ItemType Directory -Force $OUT | Out-Null
.\bin\uxb.exe $SRC --execmem --interpreter-backend AST --ast-json-out "$OUT\ast.json" 2>&1 | Tee-Object "$OUT\ast_run.log"
.\bin\uxb.exe $SRC --execmem --interpreter-backend MIR --mir-pipeline-json-out "$OUT\mir_pipeline.json" --mir-opcodes-json-out "$OUT\mir_opcodes.json" 2>&1 | Tee-Object "$OUT\mir_run.log"
.\bin\uxb.exe $SRC --artifact-report-json-out "$OUT\artifact_report.json" 2>&1 | Tee-Object "$OUT\artifact.log"
```

## Registry ve wrapper yüzeyi raporu

```powershell
python .\tools\docs\generate_external_library_docs.py --root . --update-order
python .\tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

---

# Dış Kütüphane Örnekleri ve Kalite Kapısı

Dış kütüphane örnekleri uzun REM açıklamalarıyla yazılır. Bunun nedeni satır sayısı doldurmak değildir. Dış kütüphane çağrısında yeni başlayan programcı yalnız fonksiyon adını değil, handle yaşam döngüsünü, pointer tehlikesini, dosya yolunu, DLL arama düzenini, AST/MIR/backend ayrımını ve temizlik adımını da görmelidir.

Her modül için beş örnek üretilir:

1. Kurulum, sürüm ve çalışma yolu denetimi.
2. Handle oluşturma, veri doldurma ve okuma.
3. Ölçüm, hesaplama veya analiz akışı.
4. Dosya, çıktı veya rapor üretimi.
5. Hata kontrolü, temizlik ve başka modülle birleşme.

Bu örnekler `docs_examples/external_libraries` altında ayrı `.uxb` dosyalarıdır. Amaçları, her modülü küçük bir proje gibi anlatmaktır. Örnekler çalışma ortamında DLL bulunmadığında runtime hatası verebilir; bu durumda syntax ve katman çıktısı yine belge için değerlidir, DLL tamamlandığında aynı örnekler gerçek çağrıya dönüşür.

| Modül | Örnek klasörü | Örnek sayısı |
|---|---|---:|
| `uxaimath` | `docs_examples/external_libraries/uxaimath` | 5 |
| `uxcollections` | `docs_examples/external_libraries/uxcollections` | 5 |
| `uxdataframe` | `docs_examples/external_libraries/uxdataframe` | 5 |
| `uxdataset` | `docs_examples/external_libraries/uxdataset` | 5 |
| `uxgraph` | `docs_examples/external_libraries/uxgraph` | 5 |
| `uxllama` | `docs_examples/external_libraries/uxllama` | 5 |
| `uxllamax_placeholder` | `docs_examples/external_libraries/uxllamax_placeholder` | 5 |
| `uxmath` | `docs_examples/external_libraries/uxmath` | 5 |
| `uxmathcore` | `docs_examples/external_libraries/uxmathcore` | 5 |
| `uxmatrix` | `docs_examples/external_libraries/uxmatrix` | 5 |
| `uxnn` | `docs_examples/external_libraries/uxnn` | 5 |
| `uxnn2` | `docs_examples/external_libraries/uxnn2` | 5 |
| `uxnn3` | `docs_examples/external_libraries/uxnn3` | 5 |
| `uxonnx` | `docs_examples/external_libraries/uxonnx` | 5 |
| `uxonnx2` | `docs_examples/external_libraries/uxonnx2` | 5 |
| `uxstats` | `docs_examples/external_libraries/uxstats` | 5 |
| `uxstats2` | `docs_examples/external_libraries/uxstats2` | 5 |
| `uxtensor` | `docs_examples/external_libraries/uxtensor` | 5 |

---

# Nihai Hızlı Başvuru — 12.06_1

## Komut aileleri

| Aile | Sözcükler |
|---|---|
| Giriş/çıkış | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `PRINT #`, `INPUT #` |
| Değişken | `DIM`, `AS`, `CONST`, `LET`, `REDIM` |
| Karar | `IF`, `THEN`, `ELSEIF`, `ELSE`, `END IF`, `SELECT`, `CASE`, `CASE ELSE` |
| Döngü | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `UNTIL`, `WEND`, `EXIT` |
| Fonksiyon | `FUNCTION`, `SUB`, `RETURN`, `DECLARE`, `CALL`, `BYVAL`, `BYREF` |
| Tip/nesne | `TYPE`, `CLASS`, `INTERFACE`, `MAGIC`, `NEW`, `DELETE`, `THIS`, `ME` |
| Modül | `NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `INCLUDE`, `IMPORT` |
| Dış çağrı | `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)`, `CDECL`, `STDCALL` |
| Eşzamanlı yüzey | `EVENT`, `THREAD`, `PIPE`, `PARALEL`, `SLOT` |
| Hata | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` |

## Veri tipleri

| Aile | Tipler |
|---|---|
| İşaretli tam sayı | `I8`, `I16`, `I32`, `I64` |
| İşaretsiz tam sayı | `U8`, `U16`, `U32`, `U64` |
| Kayan nokta | `F32`, `F64`, `F80`, `F128` |
| Büyük sayı | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` |
| Genel | `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `STRPTR` |
| Koleksiyon | `ARRAY`, `LIST`, `DICT`, `SET` |

## Operatör aileleri

| Aile | Operatörler |
|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` |
| Mantık | `AND`, `OR`, `NOT`, `XOR` |
| Logic16 | `NAND`, `NOR`, `XNOR`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| Bit kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `**=` |
| Akış | `|>`, `?:` |

## Preprocessor aileleri

| Aile | Yönergeler |
|---|---|
| Değer | `%%SET`, `%%DEFINE`, `%%UNDEF`, `%%EVAL` |
| Koşul | `%%IF`, `%%IFC`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF` |
| Döngü | `%%FOR`, `%%FOREACH`, `%%REPEAT`, `%%ENDFOR`, `%%BREAK`, `%%CONTINUE` |
| Hedef | `%%TARGET`, `%%PLATFORM`, `%%DESTOS`, `%%PROFILE`, `%%OUTDIR` |
| Web | `%%HTML_BEGIN`, `%%HTML_END`, `%%CSS_BEGIN`, `%%CSS_END`, `%%JS_BEGIN`, `%%JS_END`, `%%JS_LINE` |
| WAT/WASM | `%%WAT_BEGIN`, `%%WAT_END`, `%%WAT_FUNC_BEGIN`, `%%WAT_FUNC_END`, `%%WAT_IMPORT`, `%%WAT_EXPORT` |
| Asset | `%%ASSET_ROOT`, `%%ASSET_FILE`, `%%ASSET_COPY`, `%%ASSET_IMAGE`, `%%ASSET_AUDIO` |
| Manifest/JSON | `%%MANIFEST_SET`, `%%MANIFEST_REQUIRE`, `%%JSON_SET`, `%%JSON_BEGIN`, `%%JSON_END` |
| Güvenlik | `%%ALLOW_RAW_JS`, `%%ALLOW_RAW_WAT`, `%%SAFE_PATHS`, `%%REQUIRE_HOST_BINDING` |

## Compiler katman komutları

| Katman | Terminal komutu çekirdeği |
|---|---|
| Preprocess | `--pp A --preprocessed-out out.uxb --preprocess-result-json-out out.json` |
| Lexer | `--debug-token-dump --tokens-json-out tokens.json` |
| Parser/AST | `--parse-only --ast-json-out ast.json` |
| AST contract | `--ast-contract-check --ast-contract-json-out ast_contract.json` |
| Semantic/HIR | `--semantic --hir-json-out hir.json` |
| MIR | `--mir-verify --mir-json-out mir.json --mir-opcodes-json-out mir_opcodes.json` |
| AST run | `--execmem --interpreter-backend AST` |
| MIR run | `--execmem --interpreter-backend MIR` |
| JS | `--emit-js --js-out program.js` |
| WAT | `--emit-wat --wat-out program.wat` |
| WASM | `--emit-wasm --wasm-out program.wasm` |
| x64 | `--codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out program.asm` |

## Kanonik yanlış/doğru tablosu

| Yanlış | Doğru |
|---|---|
| `THREAT` | `THREAD` |
| `PARALLEL` | `PARALEL` |
| `SIHIRLIMETOT` | `MAGIC` |
| `IMPORT DLL` | `CALL(DLL)` veya `DECLARE ... LIB ... ALIAS ...` |
| `IMPORT API` | `CALL(API)` |
| Hedefsiz raw JS | `%%TARGET WEB` veya uygun güvenlik kapısı altında JS üretimi |
