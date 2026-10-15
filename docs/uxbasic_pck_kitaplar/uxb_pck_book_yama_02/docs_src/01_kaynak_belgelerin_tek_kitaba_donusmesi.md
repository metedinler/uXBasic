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
