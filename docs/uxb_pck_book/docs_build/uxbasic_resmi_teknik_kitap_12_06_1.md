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
