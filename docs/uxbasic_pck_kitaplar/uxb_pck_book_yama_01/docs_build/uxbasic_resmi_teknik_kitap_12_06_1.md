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
