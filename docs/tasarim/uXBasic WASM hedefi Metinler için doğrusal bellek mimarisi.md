 
# uXBasic WASM hedefi: Metinler için doğrusal bellek mimarisi

Benim önerim: uXBasic'in WASM hedefinde metinler, UTF-8 kodlamasıyla doğrusal bellekte saklanmalı; metin değişkenleri ise adres ve uzunluk bilgisi taşıyan bir yapı üzerinden yönetilmelidir.

Ancak bunu yalnızca `PRINT "Merhaba"` komutunu çalıştırmak için tasarlamamalıyız. uXBasic'in `STRING`, `MID$`, `LEFT$`, `RIGHT$`, `LEN`, metin birleştirme, diziler, sınıflar, DLL/API benzeri dış arayüzler ve bellek erişim komutları aynı altyapı üzerinde çalışabilmeli.

Daha önemlisi, uXBasic'in MIR merkezli mimarisini bozmamalıyız.

## 1. WASM'da metinler neden özel bellek yönetimi gerektirir?

WebAssembly'nin temel yürütme çekirdeği, BASIC'teki `STRING` türünü doğrudan tanımaz. Metinleri bellekte bayt dizileri şeklinde tutmak ve bunları yönetecek işlemleri oluşturmak derleyicinin sorumluluğudur.

WebAssembly'nin doğrusal belleği, bayt adresleri üzerinden erişilen ve gerektiğinde büyütülebilen bir bellek alanıdır. Geleneksel WASM32 hedefinde adresler 32 bitlik değerlerle temsil edilir.

Önerilen uXBasic bellek yerleşimi

Bu alanların belirli adreslere yerleştirilmesi tasarım kararıdır. WASM bunları zorunlu olarak bu sırada düzenlemez.

Örneğin:

```
DIM ad AS STRING
ad = "İskenderun"
PRINT ad
```

Derleyici metni UTF-8 baytlarına dönüştürerek belleğe yerleştirmeli, değişkene metnin nerede bulunduğunu ve kaç bayt tuttuğunu kaydetmelidir.

Temel işlem zinciri şöyle olacaktır:

uXBasic kaynak kodu

Lexer → Parser → AST → MIR

WASM metin işlemleri ve bellek yönetimi

WAT / WASMYerel metin işlemleri

JS köprüsüTarayıcı giriş/çıkışıBurada önemli olan, metin işlemlerini JavaScript'e bağımlı hâle getirmemektir. JavaScript, tarayıcı arayüzünde kullanılabilir; fakat aynı WASM modülü tarayıcı dışında da çalışabilmelidir.

Bu yaklaşım WebAssembly'nin temel bellek modeliyle uyumludur.

![](https://www.google.com/s2/favicons?domain=https://www.w3.org&sz=32)

W3C

+1

## 2. Metin değişkeninin bellekteki gösterimi

uXBasic için ilk aşamada şu tanımlayıcıyı öneriyorum:

|                                              |
|---------------------------------------------------|
|                                              |
| Tür                                              |
|                                              |
| Açıklama                                        |
| -                                                 |
|                                              |
| `ptr`                                             |
|                                              |
| `i32`                                             |
|                                              |
| Metnin baytlarının başlangıç adresi          |
| `byte_len`                                        |
|                                              |
| `i32`                                             |
|                                              |
| UTF-8 bayt sayısı                               |
| `capacity`                                        |
|                                              |
| `i32`                                             |
|                                              |
| Ayrılmış kullanılabilir bayt kapasitesi       |
| `flags`                                           |
|                                              |
| `i32`                                             |
|                                              |
| Sahiplik, değiştirilebilirlik, sabitlik bilgisi |

Toplam: 16 baytlık metin tanımlayıcısı.

Örnek: `s = "ÇİP"`

ptr

1024

byte_len

5

capacity

5

flags

Sabit

C3

Ç

87

↳

C4

İ

B0

↳

50

PUTF-8: 3 karakter, 5 bayt. Bellek adresleri örnektir.Bu dört alanın tercih edilmesinin nedenleri:

-

## `ptr` metnin bellek adresini verir.

## `byte_len` metin içindeki `0` baytından etkilenmeden uzunluğu belirler.

## `capacity` her eklemede yeniden bellek ayırmayı önlemeye yardımcı olur.

`flags` sabit metne yazılmasını ve ortak kullanılan belleğin yanlışlıkla serbest bırakılmasını önlemeye yönelik kuralları destekler.

Önemli ayrım: `flags` tek başına bellek güvenliğini sağlamaz. Metin kopyalama, sahiplik devri, serbest bırakma ve paylaşım kurallarını da belirlememiz gerekir.

Ayrıca 16 baytlık tanımlayıcı bir WebAssembly standardı değildir; bu, uXBasic için önerdiğim iç bellek düzenidir.

## 3. Bellek yönetimi nasıl çalışmalı?

Bana göre üç farklı metin ömrünü desteklemek gerekir.

|                                                  |
|-------------------------------------------------------|
|                                                  |
| Bellek davranışı                                   |
|                                                  |
| Örnek                                                |
| -                                                     |
|                                                  |
| Sabit                                                 |
|                                                  |
| Program boyunca korunur                               |
|                                                  |
| `"Merhaba"`                                           |
| Sahipli dinamik                                       |
|                                                  |
| Gerektiğinde büyütülür ve serbest bırakılır   |
|                                                  |
| `ad = ad + "!"`                                       |
| Geçici                                               |
|                                                  |
| İşlem bitince temizlenir veya sahipliği devredilir |
|                                                  |
| `LEFT$(ad, 3)`                                        |

Bütün metinleri doğrudan `memory.grow` ile büyütmek yanlış olur. Bu komut doğrusal belleğin tamamını 64 KiB sayfa birimleriyle büyütür, tek tek metinleri değil. Metin ayırma işlemleri, doğrusal bellek üzerinde çalışan ayrı bir bellek ayırıcıyla gerçekleştirilmelidir.

![](https://www.google.com/s2/favicons?domain=https://webassembly.org&sz=32)

WebAssembly

+1

Önerdiğim çalışma zamanı işlevleri:

|                           |
|--------------------------------|
|                           |
| Görev                         |
| -                              |
|                           |
| `UX_STR_ALLOC`                 |
|                           |
| Metin için bellek ayırma     |
| `UX_STR_RESERVE`               |
|                           |
| Kapasiteyi büyütme           |
| `UX_STR_ASSIGN`                |
|                           |
| Atama ve sahiplik yönetimi    |
| `UX_STR_CLONE`                 |
|                           |
| Bağımsız metin kopyası     |
| `UX_STR_APPEND`                |
|                           |
| Metne ekleme                   |
| `UX_STR_SLICE`                 |
|                           |
| Alt metin oluşturma           |
| `UX_STR_COMPARE`               |
|                           |
| Metinleri karşılaştırma    |
| `UX_STR_RELEASE`               |
|                           |
| Sahip olunan belleği bırakma |
| `UX_STR_UTF8_VALIDATE`         |
|                           |
| UTF-8 doğrulama               |

Bunlar ayrı ayrı WASM komutları değil, uXBasic çalışma zamanı işlevleri olacaktır.

Önemli karar: İlk uygulamada dinamik metinler için açık sahiplik ve gerektiğinde kopyalama kullanmayı öneriyorum. Her metni hemen referans sayacına bağlamaya gerek yok. Paylaşımlı metin desteğine ihtiyaç duyulduğunda referans sayacı veya kopyalama sırasında ayırma yöntemi eklenebilir.

Bir de metin tanımlayıcısının 16 bayt olması, her uXBasic `STRING` değişkeninin mutlaka bu 16 baytı doğrudan taşıması gerektiği anlamına gelmez. MIR düzeyinde metin tutamacı kullanılabilir; WASM çalışma zamanı tanımlayıcıyı kendi belleğinde tutabilir.

Bu, fonksiyon çağrılarında ve dizilerde taşıma maliyetini azaltabilir.

## 4. Türkçe karakterler ve LEN meselesi

Burada bir karar zorunlu: `LEN()` bayt mı, karakter mi sayacak?

Örnek:

```
DIM s AS STRING
s = "ÇİP"

PRINT LEN(s)
PRINT LEFT$(s, 1)
```

Önerdiğim dil davranışı:

```
LEN(s)       → 3
BYTELEN(s)   → 5
LEFT$(s, 1)  → Ç
```

Yani:

-

## `LEN` Unicode kod noktalarını sayar.

## `BYTELEN` gerçek UTF-8 bayt sayısını döndürür.

## `LEFT$`, `MID$` ve `RIGHT$` UTF-8 karakterlerinin ortasından kesme yapmaz.

Grafiksel olarak tek görünen birleşik karakterlerin sayımı ayrı bir meseledir. Örneğin `e` + birleşik aksan, iki Unicode kod noktası olabilir.

Burada dikkatli olmamız gerekiyor. uXBasic'in mevcut AST ve MIR motorlarında `LEN` bayt temelli çalışıyorsa, WASM için farklı sonuç üretmek kabul edilemez.

Bu nedenle yukarıdaki davranış önerdiğim ortak dil sözleşmesidir, mevcut uXBasic uygulamasının doğrulanmış davranışı değildir. Önce bütün motorların mevcut davranışı ölçülmeli, ardından tek bir ortak sözleşme uygulanmalıdır.

## 5. MIR katmanı nasıl genişletilmeli?

uXBasic'te asıl iş WASM kod üreticisine yüzlerce ayrı metin durumu eklemek olmamalı. MIR katmanı, metinlerin anlamını açık şekilde ifade etmelidir.

Örnek bir MIR işlem kümesi:

```
STR_CONST
STR_ASSIGN
STR_CONCAT
STR_LENGTH
STR_BYTELENGTH
STR_SUBSTRING
STR_COMPARE
STR_RELEASE
```

Burada her işlemin bellek sahipliği ve sonuç türü tanımlanmalıdır.

Örnek kaynak:

```
DIM a AS STRING
DIM b AS STRING

a = "Merhaba"
b = a + " Dünya"

PRINT b
```

Kavramsal MIR:

```
v1 = STR_CONST "Merhaba"
v2 = STR_CONST " Dünya"
v3 = STR_CONCAT v1, v2

STR_ASSIGN b, v3

PRINT_STRING b
```

`v3` geçici ve sahipli bir sonuçsa, `STR_ASSIGN` onun sahipliğini `b` değişkenine devredebilir. Bu durumda ayrıca serbest bırakılmamalıdır.

Böylece aynı MIR:

-

## AST yorumlayıcısında kendi metin altyapısını,

## MIR yorumlayıcısında ortak anlamsal kuralları,

## Native x64 hedefinde yerel çalışma zamanını,

WASM hedefinde doğrusal bellek işlevlerini

kullanabilir.

Benim özellikle karşı çıktığım çözüm, metin işlemlerini WASM kod üreticisinde JavaScript fonksiyonlarına yönlendirerek geçici olarak çalıştırmak olurdu. Böyle bir yaklaşım tarayıcıda iş görür, ama bağımsız WASM çalışma zamanları için ek bağımlılıklar doğurur.

## 6. WAT düzeyinde temel metin desteği

Aşağıdaki küçük örnek, bir metnin sabit veri alanında tutulmasını ve adresiyle uzunluğunun dışarıya verilmesini gösterir.

```

(module
  (memory (export "memory") 1)

  ;; UTF-8: "Merhaba"
  (data (i32.const 1024) "Merhaba")

  (func (export "text_ptr") (result i32)
    i32.const 1024
  )

  (func (export "text_len") (result i32)
    i32.const 7
  )
)
```

Bu örnek statik metin için doğrudur. Ancak dinamik bellek ayırma, metin birleştirme ve serbest bırakmayı henüz gerçekleştirmez.

Metnin dışarıda gösterilmesi için JavaScript tarafında şu köprü kullanılabilir:

```

const decoder = new TextDecoder("utf-8");

function readWasmString(memory, ptr, len) {
  const bytes = new Uint8Array(
    memory.buffer,
    ptr,
    len
  );

  return decoder.decode(bytes);
}

const text = readWasmString(
  instance.exports.memory,
  instance.exports.text_ptr(),
  instance.exports.text_len()
);

console.log(text);
```

Metinlerin JavaScript'ten WASM'a gönderilmesinde ise `TextEncoder` kullanılabilir.

![](https://www.google.com/s2/favicons?domain=https://developer.mozilla.org&sz=32)

MDN

+1

Dikkat edilmesi gereken iki nokta var:

1.


WASM belleği büyüdüğünde JavaScript tarafındaki eski bellek görünümleri geçersiz hâle gelebilir. Bu yüzden yeni bellek görünümü kullanılmalıdır.2.

JavaScript köprüsü bellek ayırmanın sahibi olmamalıdır. WASM'ın dışarıya açtığı ayırma işlevini kullanmalı ve metnin sahipliğini belirlenen sözleşmeye göre devretmelidir.

## 7. İleride Component Model desteği

uXBasic'i yalnızca tarayıcıya sınırlamamak için WebAssembly Component Model ile uyumlu bir dış arayüz tasarlamak mantıklı.

Component Model'in standart çağrı kuralları, metinleri doğrusal bellek üzerinden aktarmak için adres, uzunluk, kodlama ve bellek ayırma sözleşmeleri tanımlar. UTF-8 varsayılan kodlama seçeneklerinden biridir.

![](https://www.google.com/s2/favicons?domain=https://github.com&sz=32)

GitHub

Bu nedenle uXBasic'in iç metin tanımlayıcısı 16 bayt olsa bile, dışarıdaki standart arayüz için özel dönüştürme kullanmalıyız. İç tanımlayıcıyı doğrudan başka dillere zorla kabul ettirmek iyi bir mimari olmaz.

Bu ayrıca gelecekte farklı dillerle yazılmış WASM bileşenleriyle iletişimin yolunu açar.

## 8. uXBasic için kesinleştirilmesini önerdiğim kararlar

|                                                     |
|----------------------------------------------------------|
|                                                     |
| Önerilen karar                                          |
| -                                                        |
|                                                     |
| Bellek modeli                                            |
|                                                     |
| Tek WASM32 doğrusal bellekle başlangıç               |
| Metin kodlaması                                         |
|                                                     |
| UTF-8                                                    |
| İç temsil                                              |
|                                                     |
| Adres, bayt uzunluğu, kapasite, bayraklar               |
| Metin ömrü                                             |
|                                                     |
| Sabit, sahipli, geçici                                  |
| Bellek ayırma                                           |
|                                                     |
| WASM çalışma zamanı tarafından                      |
| Metin işlemleri                                         |
|                                                     |
| MIR tarafından tanımlanır                             |
| JS ilişkisi                                             |
|                                                     |
| Yalnızca dış ortam köprüsü                         |
| Unicode                                                  |
|                                                     |
| Bütün motorlarda aynı davranış                      |
| Sıfır sonlandırma                                     |
|                                                     |
| İçeride zorunlu değil, C arayüzünde gerektiğinde   |
| WASM64                                                   |
|                                                     |
| Sonraya bırakılabilir; adres genişliği soyutlanmalı |
| Bellek güvenliği                                       |
|                                                     |
| Sınır denetimi, sahiplik ve ömür denetimi            |

### Özellikle uXBasic'in PEEK, POKE ve VARPTR tasarımı açısından

Burada daha önce belirlediğimiz sanal bellek ile gerçek adres ayrımını WASM'a aynen taşımak doğru olmaz.

WASM doğrusal belleğindeki bir adres, işletim sistemindeki gerçek bir bellek adresi değildir. Örneğin `1024`, WASM bellek alanı içindeki bir bayt konumunu ifade eder.

Bu nedenle WASM hedefinde `VARPTR` tarafından döndürülen adresler ve `PEEK`/`POKE` işlemleri, uXBasic'in hedefe bağlı adres modeli içinde ele alınmalıdır.

Özellikle:

-

## WASM adresleri doğrudan yerel x64 işaretçilerine dönüştürülmemeli.

## `MEMCOPY` ve `MEMFILL` doğrusal bellek sınırlarına uymalı.

## Dinamik bir metnin iç adresi, metin yeniden ayrıldığında değişebilir.

Metin üzerinde `VARPTR` kullanılıyorsa, adresin ne kadar süre geçerli olduğu açıkça tanımlanmalı.

Bu son maddeyi atlamamız, metin desteği çalışıyor görünürken sonradan çok zor bulunan bellek hataları doğurabilir.

## 9. Uygulama sırası

1. Ortak metin sözleşmesini belirle


UTF-8, uzunluk, alt metin, karşılaştırma, sahiplik ve geçici sonuçların davranışını tanımla.

1. MIR metin işlemlerini tamamla


Var olan MIR işlemlerini yeniden kullan; yalnızca eksik anlamları ekle. Mevcut kod görülmeden yeni opcode zorunlu sayılmamalı.

1. WASM çalışma zamanı kütüphanesini oluştur


Bellek ayırma, kopyalama, birleştirme, karşılaştırma ve temizleme işlevlerini uygula.

1. WAT ve WASM üretimini bağla


MIR işlemlerini bu kütüphane çağrılarına çevir.

1. Motorlar arası karşılaştırma testleri yap


Türkçe karakterler, boş metin, birleşik Unicode karakterleri, uzun metinler, iç içe fonksiyonlar, başarısız bellek ayırma ve metin dizileri dahil.

## Sonuç

uXBasic için tercih edeceğim mimari:

MIR merkezli metin işlemleri + UTF-8 doğrusal bellek + açık bellek sahipliği + hedefe özel çalışma zamanı kütüphanesi.

Bu tasarımın en önemli avantajı, WASM'ın kendi başına metin işlemlerini gerçekleştirebilmesidir. JavaScript yalnızca dış dünya ile veri alışverişini sağlar.

Bir tasarım kararını da özellikle vurgulayayım: WASM hedefindeki metin desteği, uXBasic'in genel metin sisteminden ayrı bir ikinci dil oluşturmamalıdır. Aynı kaynak programın AST, MIR, x64 ve WASM hedeflerinde aynı sonucu vermesi temel kabul ölçütü olmalı.

Burada anlattıklarım kaynak kod üzerinde doğrulanmış bir uygulama durumu değil, mevcut mimari hedeflerine uygun teknik tasarım önerisidir. uXBasic'in gerçek MIR metin işlemleri ve mevcut bellek yöneticisi incelenmeden yeni bir çalışma zamanı kütüphanesi yazmaya başlamak, zaten var olan işleri ikinci kez yapmak olabilir. Derleyici projelerinde bu tür gereksiz tekrarlar şaşırtıcı derecede iyi gizleniyor.


 
