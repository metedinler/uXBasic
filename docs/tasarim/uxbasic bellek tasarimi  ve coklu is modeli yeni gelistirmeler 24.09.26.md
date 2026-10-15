


> **Yürürlük notu (2026-09-25):** Bu uzun belge düşünce deneylerini ve önceki
> alternatifleri de koruyan tasarım tarihçesidir. Bağlayıcı kullanıcı yüzeyi
> `ai_koordinasyon/KARAR_VE_GOREV_DEFTERI.md` içindeki K1-K8 kararlarıdır:
> `TASKGROUP` (alt çizgisiz), `SPAWN`, `.STATUS/.WAIT()/.RESULT/.JOIN()`,
> `.CANCEL()`, `.ERRORTEXT`; tipsiz `TASK` korunur ve `TASK OF T` güvenli statik
> sonuç yolu olarak ayrıca uygulanacaktır. Bu belgede geçen `WAIT t`,
> `TASKOUT(t)` veya “RESULT eklemeyelim” bölümleri bağlayıcı yeni sözleşme değil,
> tarihsel alternatiflerdir. Eski `TASKOUT` uyumluluk davranışı ancak K1-K8 ile
> çelişmediği yerde korunur.

Mete abi, S-030’daki mesele artık **“THREAD ve PARALEL gerçekten eşzamanlı çalışsın mı?”** değil. O kısmı zaten kararlaştırdık. Açık kalan konu, **başlatılan görevi programcının daha sonra nasıl yöneteceği ve sonucunu nasıl alacağı**.

## Sorun nereden çıkıyor?

Bugünkü tasarımda kabaca şöyle bir mantık vardı:

```basic
THREAD Worker(x AS I32)
    TASKOUT = x * 2
END THREAD
```

ve bir yerlerde:

```basic
TRIGGER THREAD Worker(10)
PRINT TASKOUT
```

gibi bir kullanım düşünülebiliyordu.

Bu sistem THREAD gerçekten eşzamanlı olmadığı sürece bir yere kadar idare eder. Çünkü `Worker()` çalışır, biter, `TASKOUT` dolar ve sonra program devam eder.

Ama THREAD'i gerçekten asenkron yaptığımız anda durum değişir.

Şöyle düşün:

```basic
TRIGGER THREAD Worker(10)
TRIGGER THREAD Worker(20)
TRIGGER THREAD Worker(30)
```

Üçü aynı anda çalışmaya başladı.

Sonra:

```basic
PRINT TASKOUT
```

dediğinde soru şu:

> **Hangi THREAD'in sonucu?**

10'un mu, 20'nin mi, 30'un mu?

Daha kötüsü:

```text
Worker(10) → TASKOUT = 20
Worker(20) → TASKOUT = 40
Worker(30) → TASKOUT = 60
```

üç iş parçacığı aynı ortak değişkene yazarsa sonuç tamamlanma zamanına bağlı olur.

Bugün:

```text
20
```

yarın:

```text
60
```

öbür çalıştırmada:

```text
40
```

çıkabilir.

İşte **global TASKOUT gerçek eşzamanlılıkla uyuşmuyor.**

---

# TASK handle neden gerekiyor?

Her başlatılan görevin kendi kimliği olmalı.

Örneğin kavramsal olarak:

```basic
DIM t AS TASK

t = START THREAD Worker(10)
```

`t`, çalışan görevin kendisini temsil eder.

Bunun içinde mantıksal olarak:

```text
Görev kimliği
Durum
Sonuç
Hata
İptal durumu
Hedef çalışma zamanı bilgisi
```

bulunur.

Yani:

```text
TASK #17
    state  = RUNNING
    result = henüz yok
    error  = yok
```

iş bittiğinde:

```text
TASK #17
    state  = COMPLETED
    result = 20
```

olur.

Böylece:

```basic
DIM a AS TASK
DIM b AS TASK

a = START THREAD Worker(10)
b = START THREAD Worker(20)
```

dediğimizde iki görevin sonucu birbirine karışmaz.

---

# WAIT, JOIN, RESULT, STATUS, CANCEL ne işe yarıyor?

Bunların **isimlerini henüz kilitlemedik**. Yani mesele tam olarak bu.

Anlamlarını ise büyük ölçüde biliyoruz:

| Kavram   | Görevi                                         |
| -------- | ---------------------------------------------- |
| `WAIT`   | Bir görev bitene kadar bekle                   |
| `JOIN`   | Görev veya görev grubunun tamamlanmasını bekle |
| `RESULT` | Görevin sonucunu al                            |
| `STATUS` | Çalışıyor mu, bitti mi, hata mı verdi öğren    |
| `CANCEL` | Görevin durdurulmasını iste                    |

Örneğin:

```basic
DIM t AS TASK

t = START THREAD Calculate(100)

WAIT t

PRINT RESULT(t)
```

kavramsal olarak oldukça açık.

Ama uXBasic'te gerçekten:

```basic
WAIT t
```

mi kullanacağız?

Yoksa:

```basic
t.Wait()
```

mi?

Veya:

```basic
TASK.WAIT(t)
```

mi?

Açık kalan **sözdizimi kararı** bu.

Semantik değil.

---

# `WAIT` ile `JOIN` arasındaki fark ne olabilir?

Tek görev:

```basic
DIM t AS TASK
t = START THREAD Worker(10)

WAIT t
```

Gayet doğal.

Ama `PARALEL` birden fazla görev üretebilir:

```basic
DIM g AS TASKGROUP

g = PARALEL
    Worker(10)
    Worker(20)
    Worker(30)
END PARALEL

JOIN g
```

Burada `JOIN`:

> “Bu grubun bütün görevleri bitsin.”

anlamına gelir.

Yani kabaca:

```text
WAIT → tek görev
JOIN → görev/grup
```

ayrımı yapılabilir.

Fakat istersek `WAIT` her ikisine de uygulanabilir ve `JOIN` hiç eklenmeyebilir. Dil yüzeyini gereksiz büyütmek için insanlığın zaten yeterince yöntemi var.

---

# THREAD ile PARALEL arasındaki fark da burada netleşiyor

Benim önerdiğim son model şu:

```text
THREAD
    bir bağımsız asenkron görev başlatır

PARALEL
    birden fazla işi eşzamanlı bir grup olarak yürütür
```

Örneğin:

```basic
DIM t AS TASK

t = START THREAD DownloadFile("a.dat")

PRINT "Ana program çalışmaya devam ediyor"

WAIT t
```

THREAD başlatıldığı anda ana program devam eder.

PARALEL ise:

```basic
PARALEL
    Analyze("a.csv")
    Analyze("b.csv")
    Analyze("c.csv")
END PARALEL
```

bir görev grubudur.

İstersen `END PARALEL` otomatik `JOIN` yapabiliriz.

Bu da ayrıca güzel bir dil kararı olabilir.

Yani:

```basic
PARALEL
    ...
END PARALEL
```

bloğu bitmeden dışarı çıkılmaz.

Ama:

```basic
THREAD
```

başlatılır ve bağımsız devam eder.

Bu durumda kullanım çok sade olur.

---

# EVENT ve PIPE neden bunlardan farklı?

Bunları da ayırmak önemli.

`EVENT`:

```basic
EVENT OnMessage(message AS STRING)
    PRINT message
END EVENT
```

bir olay işleyicisidir.

Olay geldiğinde çalışır.

`PIPE` ise:

```basic
PIPE Normalize(x AS F64) AS F64
    RETURN ...
END PIPE
```

girdi alır, işler, çıktı verir.

Bunların ikisini otomatik olarak thread haline getirmek istemiyoruz.

Dolayısıyla:

```text
EVENT
    çağrıldığı anda işlenir

PIPE
    çağrıldığı anda sonuç üretir

THREAD
    bağımsız/asenkron çalışır

PARALEL
    eşzamanlı görev grubu çalıştırır
```

ayrımı temiz.

---

# TASKOUT tamamen kaldırılacak mı?

Burada ince bir ayrım var.

**THREAD gövdesi içinde `TASKOUT` kalabilir.**

Örneğin:

```basic
THREAD Worker(x AS I32)
    TASKOUT = x * 2
END THREAD
```

Bu, fonksiyon içindeki `RETURN` gibi düşünülebilir.

Ama artık:

```text
TASKOUT = global tek sonuç değişkeni
```

olmayacak.

Görev çalışma zamanı bunu:

```text
TASK #17.result
```

alanına yazar.

Yani programcı:

```basic
PRINT RESULT(t)
```

dediğinde aslında o görevin kendi `TASKOUT` değeri okunur.

Bu mevcut dili fazla kırmadan geçiş yapmamızı sağlar.

---

# Aynı şey TASKIN için de geçerli

`TASKIN` de global ortak kutu gibi kullanılmamalı.

Her görevin kendi giriş bağlamı olmalı:

```text
TASK #17
    input[]
    output
```

Böylece:

```basic
THREAD Worker(a AS I32, b AS STRING)
```

çağrısında giriş değerleri görevin kendi bağlamına kopyalanır.

Bu özellikle JS Worker ve WASM worker modelinde çok işe yarar.

---

# Hata olduğunda ne olacak?

Bu da TASK kavramının gerekli olmasının başka nedeni.

Mesela:

```basic
THREAD Worker()
    ERROR "Dosya yok"
END THREAD
```

Ana thread o anda başka yerde çalışıyor olabilir.

Hata doğrudan havaya fırlatılamaz.

Görev:

```text
state = FAILED
error = "Dosya yok"
```

olarak işaretlenir.

Sonra:

```basic
WAIT t
```

veya:

```basic
RESULT(t)
```

çağrısında hata ana akışa taşınır.

Bu x64, JS Worker ve WASM worker için ortak davranış üretir.

---

# İptal de bu yüzden TASK üzerinden yapılmalı

Örneğin:

```basic
DIM t AS TASK

t = START THREAD LongCalculation()

...

CANCEL t
```

Bu:

> “Görevi zorla öldür.”

anlamına gelmemeli.

Daha güvenli model:

```text
cancelRequested = TRUE
```

olur.

Görev uygun güvenli noktada bunu görüp kapanır.

Çünkü bir iş parçacığını belleğin ortasında kesmek, veri yapılarının üzerinde elektrikli testere kullanmaya oldukça yakın bir yöntemdir.

---

# Peki benim şu anda önereceğim uXBasic sözdizimi ne?

Ben fazla yeni anahtar sözcük üretmemeyi tercih ederim.

`TASK` bir **birinci sınıf sistem tipi** olsun:

```basic
DIM t AS TASK

t = THREAD Worker(10)

t.Wait()

PRINT t.Result
PRINT t.Status

t.Cancel()
```

Fakat mevcut parser tasarımımıza daha kolay uyacak yol muhtemelen:

```basic
DIM t AS TASK

t = START THREAD Worker(10)

WAIT t

PRINT RESULT(t)
PRINT STATUS(t)

CANCEL t
```

olur.

İkinci biçim daha klasik BASIC karakterinde.

### Benim tercihim

```basic
DIM t AS TASK

t = THREAD Worker(10)

WAIT t

PRINT TASKRESULT(t)
PRINT TASKSTATUS(t)

CANCEL t
```

gibi bir yapı.

Burada ayrıca `START` anahtar sözcüğüne bile ihtiyaç kalmayabilir:

```basic
t = THREAD Worker(10)
```

zaten “başlat” anlamını açıkça taşıyor.

Ama bunu kaynak parserın mevcut THREAD sözdizimiyle karşılaştırmadan kilitlememek gerekir.

---

## S-030'un şu anki gerçek durumu

Bunu tek cümlede özetlersek:

> **Görevlerin nasıl çalışacağına karar verdik, fakat görev başlatıldıktan sonra programcının o görevi nasıl tutacağı, bekleyeceği, sonucunu okuyacağı, hatasını göreceği ve iptal edeceği sözdizimini henüz kesinleştirmedik.**

Yani S-030'un açık kalan kısmı **eşzamanlılık felsefesi değil, görev yönetim arayüzü**.

Ve bu arayüzü şimdi doğru kurarsak aynı `TASK` sözleşmesini:

```text
x64     → native thread/thread pool
JS      → Worker
WASM    → WASM thread veya host Worker
```

üzerinde kullanabiliriz.

Bence buradaki en önemli tasarım kararı da şu olmalı: **TASK gerçek bir uXBasic tipi olsun; TASKOUT ise global mekanizma olmaktan çıkarılıp her TASK'ın özel sonuç alanına dönüşsün.** Böylece mevcut EVENT/PIPE/THREAD/PARALEL tasarımını çöpe atmadan gerçek eşzamanlılığa geçebiliriz.


Evet, kesinlikle. Hatta 20.09 kaynağını yeniden bu gözle okuyunca önceki cevabımdaki **“TASK ekleyelim” fikrini doğrudan sözdizimine çevirmeden önce SLOT tasarımını merkeze almamız gerektiği** daha net görünüyor.

Çünkü uXBasic'te `SLOT`, sonradan eklenmiş sıradan bir yardımcı değil. `EVENT`, `PIPE`, `THREAD`, `PARALEL` ailesinin **bağlama ve yönlendirme omurgası** olarak tasarlanmış. Eski tasarım belgesi de bu dört yapının aynı `slot/lane` ailesinin farklı türleri olduğunu söylüyor. 

## Bugünkü SLOT aslında ne?

20.09 kaynağındaki gerçek yapı üç parçalı:

```text
TASK tanımı
    ↓
SLOT bağlaması
    ↓
TRIGGER
```

Örneğin:

```basic
THREAD SensorOku(...)
    ...
END THREAD

SLOT
    Isci 6 ON THREAD SensorOku
END SLOT

TRIGGER THREAD SensorOku
```

veya slot üzerinden çözümleme.

Kılavuzdaki kanonik SLOT tablosu da tam olarak:

```basic
SLOT
    Kaydet 5 ON EVENT VeriGeldi
    Isci   6 ON THREAD SensorOku
    Hat    7 OFF PIPE IkiKat
    Grup   8 ON PARALEL SahaIzleme
END SLOT
```

şeklinde. Slot numarası 0..255 ve kayıt hedef türünü, hedefi ve açık/kapalı durumunu taşıyor. 

20.09 kaynak kodunda `ExecSlotEntry` de tam olarak bunu doğruluyor. SLOT bugün esas olarak:

```text
kind
name
slotId
active
targetName
targetKind
targetNode
```

saklıyor.

**Sonuç saklamıyor.**

Bu ayrım çok önemli.

---

# Asıl eksik katmanı şimdi görüyoruz

Şu anda mimari:

```text
Görev TANIMI
     ↓
SLOT BAĞLAMA
     ↓
TRIGGER
     ↓
ÇALIŞTIRMA
```

ama bunun ardından:

```text
ÇALIŞTIRMA ÖRNEĞİ / invocation
```

diye ayrı bir kavram yok.

İşte gerçek eşzamanlılığa geçtiğimiz anda eksik olan şey bu.

Şöyle adlandıralım:

```text
TASKDEF   = tanımlanmış THREAD/PARALEL/EVENT/PIPE
SLOT      = statik bağlama/yönlendirme noktası
TASKRUN   = tek bir çalıştırma örneği
```

İsimler şimdilik kavramsal.

Bu ayrımı yaparsak her şey oturuyor.

---

# SLOT neden tek başına sonuç tutamaz?

İlk bakışta şöyle diyebiliriz:

```basic
TRIGGER THREAD Worker SLOT 6

PRINT SLOTRESULT(6)
```

Çok hoş görünüyor.

Fakat gerçek eşzamanlılıkta hemen patlıyor.

Aynı slotu üç kere çalıştıralım:

```basic
TRIGGER THREAD Worker, 10 SLOT 6
TRIGGER THREAD Worker, 20 SLOT 6
TRIGGER THREAD Worker, 30 SLOT 6
```

Üçü de:

```text
SLOT 6
```

üzerinden gidiyor.

Slotta tek:

```text
result
```

alanı varsa yine aynı soruna döneriz:

```text
hangi çağrının sonucu?
```

Dolayısıyla:

> **SLOT bir görev örneği değildir. SLOT bir bağlama/yönlendirme noktasıdır.**

Bu mevcut kodun yapısıyla da uyumlu.

---

# Şu an kaynakta neden yarış oluşuyor?

20.09 kaynakta `TASKIN` ve `TASKOUT` ortak görev bağlam isimleri.

Kaynakta bunlar açıkça:

```text
TASKIN
TASKOUT
```

olarak tanımlanmış.

Daha önemlisi `ExecSlotRunBlockBody()` bir RETURN alınca sonucu:

```text
TASKOUT
```

alanına yazıyor.

Native callback de çalışmaya başlamadan önce aynı `TASKOUT` hücresini temizliyor ve iş bitince oradan sonucu alıyor.

Yani bugün mantıksal olarak:

```text
TRIGGER A
    ↓
global TASKOUT

TRIGGER B
    ↓
aynı global TASKOUT
```

var.

Bu senkron kullanımda idare eder.

Gerçek `THREAD` geldiğinde etmez.

Temmuzdaki typed-task çalışmasında da aynı tehlike fark edilmiş: gerçek asenkron `THREAD/PARALEL` için sahiplik/ömür sözleşmesi gerektiği, eski ABI'nin tek dar payload taşıdığı ve global giriş/çıkış yarışından kaçınmak için typed görevlerin yerel çağrı çerçevesi kullandığı açıkça yazılmış. 

---

# O halde yeni modeli SLOT'un üzerine kurmalıyız

Bence doğru mimari şu:

```text
                 TASK TANIMI
           THREAD Worker(...)
                   │
                   ↓
              SLOT TABLOSU
       Isci 6 ON THREAD Worker
                   │
                   ↓
                TRIGGER
                   │
                   ↓
          ÇALIŞTIRMA ÖRNEĞİ
              TaskRun #153
             /     |      \
          input  result   state
```

Başka tetikleme:

```text
SLOT 6
  ↓
TaskRun #154
```

bir başkası:

```text
SLOT 6
  ↓
TaskRun #155
```

Aynı SLOT, üç ayrı çalıştırma.

Sonuçlar artık çarpışmaz:

```text
#153.result
#154.result
#155.result
```

İşte önceki söylediğim **TASK handle** aslında bu dinamik `TaskRun` nesnesinin tutamacı olmalı.

SLOT'un yerine geçmemeli.

---

# Böyle bakınca sözdizimi de değişiyor

Önceki:

```basic
t = START THREAD Worker(10)
```

önerim uXBasic'in mevcut SLOT/TRIGGER tasarımını biraz kenardan dolaşıyordu.

Bence bundan daha doğal olan:

```basic
DIM t AS TASK

t = TRIGGER THREAD Worker(10)
```

olabilir.

Veya slot kullanıyorsak:

```basic
t = TRIGGER SLOT 6, 10
```

Bu çok daha uXBasic'e özgü ve mevcut mimarinin devamı.

Burada:

```text
TRIGGER
```

artık yalnız statement değil, **sonuç olarak görev tutamacı döndürebilen bir ifade** de olur.

---

# Ama senkron kullanım bozulmamalı

Mevcut:

```basic
TRIGGER EVENT VeriGeldi, 42
```

çalışmaya devam etmeli.

Yani:

```basic
TRIGGER THREAD Worker, 10
```

sonucu kullanılmazsa görev başlatılır ve tutamaç atılır.

Ama:

```basic
DIM t AS TASK
t = TRIGGER THREAD Worker, 10
```

denirse tutamaç yakalanır.

Bu çok temiz.

C/C++'daki gereksiz tören alayına dönmeden iki kullanım da mümkün.

---

# SLOT adıyla tetikleme daha da güzel olabilir

Zaten slotlara ad veriyoruz:

```basic
SLOT
    Isci 6 ON THREAD Worker
    Hat  7 ON PIPE Normalize
END SLOT
```

O halde:

```basic
t = TRIGGER Isci, 10
```

mevcut kısa biçimin geliştirilmiş hali olabilir.

Çözümleme:

```text
Isci
 ↓
SLOT adı
 ↓
slot 6
 ↓
THREAD Worker
 ↓
TaskRun #153
```

Bu aslında ilk SLOT tasarımının ruhuna çok uygun.

Kullanıcının alttaki fiziksel görev adını bilmesi bile gerekmeyebilir.

---

# Burada üç kullanım seviyesi ortaya çıkıyor

### 1. Doğrudan görev

```basic
t = TRIGGER THREAD Worker, 10
```

### 2. Slot adı

```basic
t = TRIGGER Isci, 10
```

### 3. Slot numarası

```basic
t = TRIGGER SLOT 6, 10
```

Üçü de sonunda aynı şeye iner:

```text
TASK_SPAWN(slot/task descriptor, arguments)
        ↓
TaskRun handle
```

Bence bu çok iyi.

---

# PIPE burada farklı davranmalı

PIPE zaten sonuç üreten senkron kavram olarak tasarlanmış.

Typed-task çalışmasında da PIPE'ın adı, `OUTPUT` ve `RETURN` aynı sonuç hücresine bağlanmış ve “son atama kazanır” davranışı tanımlanmış. 

Dolayısıyla:

```basic
x = TRIGGER PIPE Normalize, 10
```

doğrudan:

```text
I32
```

döndürebilir.

TASK döndürmesi gerekmez.

Yani:

```text
EVENT      → normalde değer yok
PIPE       → doğrudan değer
THREAD     → TASK
PARALEL    → TASKGROUP veya TASK
```

olması daha doğal.

---

# SLOT bu tip bilgisini zaten taşıyor

Slot kaydı:

```text
targetKind = EVENT
targetKind = PIPE
targetKind = THREAD
targetKind = PARALEL
```

bildiği için:

```basic
x = TRIGGER Hat, 5
```

derleyici `Hat` slotunun `PIPE` olduğunu biliyorsa dönüş tipini PIPE bildiriminden çıkarabilir.

Aynı:

```basic
t = TRIGGER Isci, 5
```

için:

```text
TASK
```

çıkar.

Bu, SLOT'un yalnız çalışma zamanı dispatcher'ı olmaktan çıkıp **tip bağlama aşamasında da yararlı bir sembol** olmasını sağlar.

---

# PARALEL için SLOT daha da anlamlı

Örneğin:

```basic
PARALEL AnalyzeBatch(path AS STRING)
    ...
END PARALEL

SLOT
    Analiz 12 ON PARALEL AnalyzeBatch
END SLOT
```

ve:

```basic
DIM g AS TASKGROUP

g = TRIGGER Analiz, "data/"
```

diyebiliriz.

Burada `TASKGROUP` gerçekten gerekebilir.

Ama başka seçenek de var:

```text
TASK
```

hem tek görev hem grup temsil etsin.

İçinde:

```text
kind = SINGLE
```

veya:

```text
kind = GROUP
```

bulunsun.

Ben dili sade tutmak için **tek TASK tipi** fikrine daha yakınım.

---

# WAIT / RESULT de böylece SLOT'a değil TASK'a uygulanır

Çünkü SLOT statik yönlendirme noktası.

Dinamik sonuç ise çalıştırma örneğine ait.

Dolayısıyla:

```basic
DIM t1 AS TASK
DIM t2 AS TASK

t1 = TRIGGER Isci, 10
t2 = TRIGGER Isci, 20

WAIT t1
WAIT t2

PRINT RESULT(t1)
PRINT RESULT(t2)
```

doğru.

Şunun yanlış olması gerekir:

```basic
PRINT RESULT(Isci)
```

çünkü `Isci` bir SLOT'tur, hangi çalıştırmadan söz edildiği belli değildir.

---

# Ama SLOT için durum sorgusu yine olabilir

Statik slot durumu:

```basic
SLOTSTATUS(Isci)
```

şunları söyleyebilir:

```text
ON/OFF
bound/unbound
target
kind
activeRunCount
```

Task durumu:

```basic
TASKSTATUS(t)
```

ise:

```text
PENDING
RUNNING
COMPLETED
FAILED
CANCELLED
```

verir.

Bu ikisini karıştırmamak çok değerli.

---

# TASKIN/TASKOUT ne olacak?

Burada artık daha doğru bir çözüm çıkıyor.

`TASKIN` ve `TASKOUT` **global değişken olmaktan çıkmalı.**

Her `TaskRun` kendi bağlamına sahip olmalı:

```text
TaskRun #153
    TASKIN
    TASKOUT

TaskRun #154
    TASKIN
    TASKOUT
```

THREAD gövdesinde:

```basic
THREAD Worker(x AS I32)
    TASKOUT = x * 2
END THREAD
```

yazılabilir.

Fakat gerçek çalışma zamanı bunu:

```text
currentTask.result
```

olarak çözer.

Başka thread'in TASKOUT'una dokunmaz.

Bu, mevcut yüzeyi koruyup altyapıyı düzeltmenin en güzel yolu.

---

# Ve typed parametreler varken TASKIN artık yalnız uyumluluk alanı

Zaten Temmuz tasarımında:

```basic
THREAD Worker(x AS I32)
```

gibi gerçek parametreler eklenmiş.

Dolayısıyla:

```text
TASKIN
```

ilk argümana uyumluluk/kolaylık alias'ı olabilir.

Asıl modern kullanım:

```basic
THREAD Worker(x AS I32, y AS STRING)
```

olmalı.

TASKOUT ise THREAD/PARALEL için sonuç taşıyan yerel görev bağlamı olabilir.

PIPE'ta zaten daha doğal:

```basic
PIPE Normalize(x AS I32) AS I32
    RETURN ...
END PIPE
```

kullanılır.

---

# Bence şimdi S-030 kararını şöyle düzeltmeliyiz

Önceki:

> “TASK tipi ekle, WAIT/JOIN/RESULT yaz.”

kararı eksikmiş.

Daha doğru son karar:

> **Mevcut SLOT sistemi korunacak ve görev yönlendirme katmanı olmaya devam edecek. SLOT statik bağlama kaydıdır; çalıştırma ve sonuç saklama nesnesi değildir. Her `TRIGGER THREAD/PARALEL` çağrısı ayrı bir dinamik görev örneği oluşturacak ve gerektiğinde TASK tutamacı döndürecektir. Aynı SLOT üzerinden eşzamanlı birden fazla görev çalışabilir ve her görevin TASKIN/TASKOUT, durum, hata ve sonucu birbirinden bağımsız olacaktır.**

Ve sözdiziminin temel adayı:

```basic
DIM t AS TASK

t = TRIGGER THREAD Worker, 10
```

veya slot üzerinden:

```basic
t = TRIGGER Isci, 10
```

daha düşük düzey:

```basic
t = TRIGGER SLOT 6, 10
```

Sonra:

```basic
WAIT t
PRINT TASKRESULT(t)
PRINT TASKSTATUS(t)
CANCEL t
```

olabilir.

## Ben burada bir şeyi artık net kilitlerdim

**SLOT sonucunu tutmaz. TASK çalıştırma sonucunu tutar.**

Çünkü aynı SLOT'un:

```text
1 görev tanımı
1 yönlendirme kaydı
N eşzamanlı çalıştırma
```

üretmesi gerekir.

Bu ayrım yapılmazsa gerçek `PARALEL` geldiği gün SLOT tablosunu baştan sökmek zorunda kalırız.

Dolayısıyla evet, senin itirazın tam yerinde: **S-030 sözdizimini SLOT'u incelemeden belirlemek yanlış olurdu.** 20.09 kaynağına göre doğru model `TASK → SLOT → TRIGGER → TaskRun/result` değil, daha doğrusu **görev tanımı → SLOT bağlaması → TRIGGER → bağımsız TASK çalıştırma örneği** şeklinde kurulmalı. Bu hem mevcut tasarımı koruyor hem de x64, JS Worker ve WASM thread sağlayıcılarına temiz biçimde taşınıyor.


Mete abi, burada ben biraz fazla geniş söylemişim. **Eski SLOT sisteminin tamamında sorun yok.** Sorun yalnızca eski **kısa aç/kapat biçimlerinden birinde**.

Asıl SLOT tasarımımız gayet düzgün:

```basic
SLOT
    SensorSlot 1 ON EVENT SensorChanged
    PipeSlot   2 ON PIPE Normalize
    WorkerSlot 3 ON THREAD Worker
    GroupSlot  4 ON PARALEL Analyze
END SLOT
```

Burada her kayıt açıkça şunu söylüyor:

```text
slot adı
slot numarası
ON/OFF
görev türü
görev adı
```

Bu biçimde hiçbir belirsizlik yok. Kılavuzdaki kanonik SLOT tablosu da zaten bu yapıda. 

### Sorunlu olan eski kısa biçim

Kaynakta ayrıca şu kolaylık biçimi var:

```basic
SLOT Worker ON
SLOT Worker OFF
```

Sorun şu: parser bu biçimde **görev türünü arayıp bulmuyor**, doğrudan `THREAD` kabul ediyor. Eski inceleme bunu açıkça tespit etmiş. 

Yani:

```basic
EVENT Alarm
    ...
END EVENT

SLOT Alarm ON
```

yazarsan insan olarak şunu beklersin:

```text
Alarm isimli EVENT'i aç
```

ama eski kısa biçimin iç mantığı bunu:

```text
THREAD Alarm
```

gibi yorumlayabiliyor.

Aynı sorun:

```basic
PIPE Normalize
...
END PIPE

SLOT Normalize ON
```

veya:

```basic
PARALEL Workers
...
END PARALEL

SLOT Workers ON
```

için de geçerli.

## Dolayısıyla kaldırmak istediğim şey bu değildi

Şunları **koruyoruz**:

```basic
SLOT EVENT <U8 32>
SLOT PIPE <U8 16>
SLOT THREAD <U8 8>
SLOT PARALEL <U8 4>
```

Bunlar kapasite bildirimi.

Şunu da koruyoruz:

```basic
SLOT
    Ev  1 ON EVENT MyEvent
    Pi  2 ON PIPE MyPipe
    Th  3 ON THREAD MyThread
    Pa  4 ON PARALEL MyParallel
END SLOT
```

Bu zaten esas SLOT tablosu.

Ayrıca:

```basic
ON EVENT MyEvent
OFF EVENT MyEvent

ON THREAD MyThread
OFF THREAD MyThread
```

biçimleri de gayet açık.

### Asıl düzeltilmesi gereken

Eski:

```basic
SLOT Worker ON
```

biçimini tamamen atmak zorunda da değiliz.

Bence **daha iyi çözüm**, bunu düzeltip gerçek tür çözümlemesi yaptırmak.

Örneğin programda:

```basic
EVENT Alarm(...)
```

varsa:

```basic
SLOT Alarm ON
```

otomatik olarak EVENT'i bulsun.

Programda:

```basic
THREAD Worker(...)
```

varsa:

```basic
SLOT Worker ON
```

THREAD'i bulsun.

Yani:

```text
SLOT isim ON/OFF
        ↓
sembol tablosunda isim ara
        ↓
EVENT / PIPE / THREAD / PARALEL türünü belirle
        ↓
ilgili slotu aç/kapat
```

olmalı.

Bu durumda kısa biçimi kaldırmaya bile gerek kalmaz.

## Ama aynı isim birden fazla ailede varsa?

Mesela:

```basic
EVENT Worker(...)
END EVENT

THREAD Worker(...)
END THREAD
```

gibi bir şey kabul edilecekse:

```basic
SLOT Worker ON
```

belirsiz hale gelir.

O zaman derleyici açıkça:

```text
HATA: 'Worker' birden fazla görev ailesinde tanımlı.
Türü açıkça belirtin.
```

demeli.

Ve kullanıcı:

```basic
ON EVENT Worker
```

veya:

```basic
ON THREAD Worker
```

yazar.

Ben bunu daha doğru buluyorum.

---

## SLOT sözdizimini böyle kilitleyebiliriz

**1. Kapasite:**

```basic
SLOT EVENT <U8 32>
SLOT PIPE <U8 16>
SLOT THREAD <U8 16>
SLOT PARALEL <U8 8>
```

**2. Açık bağlama tablosu:**

```basic
SLOT
    EventSlot  1 ON EVENT MyEvent
    PipeSlot   2 ON PIPE MyPipe
    ThreadSlot 3 ON THREAD MyWorker
    GroupSlot  4 ON PARALEL MyGroup
END SLOT
```

**3. Görevi doğrudan aç/kapat:**

```basic
ON EVENT MyEvent
OFF EVENT MyEvent

ON PIPE MyPipe
OFF PIPE MyPipe

ON THREAD MyWorker
OFF THREAD MyWorker

ON PARALEL MyGroup
OFF PARALEL MyGroup
```

**4. Kısa biçim de yaşayabilir:**

```basic
SLOT MyWorker ON
SLOT MyWorker OFF
```

ama artık **THREAD varsaymayacak**, sembol tablosundan gerçek görev türünü bulacak.

Bu şekilde eski güzel SLOT fikrini atmıyoruz. Tam tersine **yarım kalmış kısa biçimi genel sisteme uygun hale getiriyoruz.**

Ve bu, az önce konuştuğumuz yeni yapıyla da tam örtüşüyor:

```text
EVENT / PIPE / THREAD / PARALEL
          ↓
        SLOT
          ↓
       TRIGGER
          ↓
   çalışma örneği
          ↓
      TASKOUT
```

Yani sorun SLOT fikrinde değildi. **Sorun yalnız `SLOT isim ON/OFF` kısayolunun eski parserda gizlice THREAD'e sabitlenmiş olmasıydı.** Bu düzeltildiğinde kısa biçimi de rahatça koruyabiliriz.


Evet. Burada önceki anlatımımda iki ayrı kavramı birbirine fazla yaklaştırmışım:

**`EVENT/PIPE/THREAD/PARALEL` birer görev değişkeni değil, adlandırılmış alt program türleridir.** Bu nedenle bunların bildiriminde `DIM` düşünmek yanlış. `DIM` ancak çalışan bir görevin **çalıştırma tutamacını** sonradan saklamak istersek anlamlı olur.

20.09 kaynağı da aslında bu yöne oldukça yaklaşmış. Dördü de SUB/FUNCTION gibi tipli parametre alabiliyor; ayrıca doğrudan adla çözümlenebiliyor, yani açık SLOT tablosu her çağrı için zorunlu değil.  

## 1. Önce kavramları kesin ayıralım

uXBasic'te bundan sonra dört ayrı şey olacak:

```text
1. DECLARE
   Görevin imzasını önceden bildirir.

2. EVENT / PIPE / THREAD / PARALEL
   Görevin gerçek kodunu tanımlar.

3. SLOT
   Tanımlanmış görevleri çalışma zamanı sistemine bağlar,
   açar/kapatır, kimlik ve yönlendirme sağlar.

4. TRIGGER
   Bir görevin belirli bir çalıştırmasını başlatır.
```

Buna beşinci olarak yalnız çalışma zamanında ortaya çıkan:

```text
5. TASK
   Başlatılmış tek bir THREAD/PARALEL çalıştırmasının tutamacıdır.
```

gelir.

Yani `TASK`, `THREAD Worker` ile aynı şey değildir.

---

# 2. `DECLARE` burada gerçekten doğru araç

Klasik BASIC mantığına da uyuyor.

Örneğin ileri bildirim:

```basic
DECLARE EVENT SensorChanged(sensorId AS I32, value AS F64)

DECLARE PIPE Normalize(value AS F64) AS F64

DECLARE THREAD Logger(message AS STRING)

DECLARE THREAD Calculate(x AS I32) AS I32

DECLARE PARALEL AnalyzeBatch(firstRow AS I32, rowCount AS I32)
```

Daha sonra gerçek tanımlar:

```basic
EVENT SensorChanged(sensorId AS I32, value AS F64)
    PRINT sensorId, value
END EVENT
```

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

```basic
THREAD Calculate(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

Bu çok daha temiz.

### `DECLARE` ne zaman gerekir?

Tanım daha önce geldiyse gerekmez:

```basic
THREAD Worker(x AS I32)
    ...
END THREAD

MAIN
    TRIGGER THREAD Worker(10)
END MAIN
```

Ama başka modülde veya dosyanın ilerleyen bölümündeyse:

```basic
DECLARE THREAD Worker(x AS I32)
```

kullanılır.

Ve `DECLARE` ile gerçek tanımın imzası bire bir uyuşmak zorunda olur.

---

# 3. Tek satırlık eski görev bildirimi artık kanonik olmasın

20.09 parserı bugün:

```basic
THREAD Worker
```

gibi gövdesiz tek satırlık biçimleri hâlâ kabul ediyor. Parser bunu tarihsel uyumluluk nedeniyle yapıyor.

Bence yeni kural:

```basic
DECLARE THREAD Worker(...)
```

ileri bildirimdir.

```basic
THREAD Worker(...)
    ...
END THREAD
```

tanımdır.

Şu eski biçim:

```basic
THREAD Worker
```

**eski uyumluluk biçimi** olarak kalabilir ama yeni kod için önerilmemeli.

Böylece “bu bir gövdesiz tanım mı, ileri bildirim mi?” saçmalığı da biter.

---

# 4. Dört yapı için kesin semantik

Senin tarifin üzerinden bunu kilitlemek bence doğru:

| Yapı      | Anlam                                                                             |
| --------- | --------------------------------------------------------------------------------- |
| `EVENT`   | Bir olayın gerçekleşmesini bekleyen ve gerçekleştiğinde çalışan olay alt programı |
| `PIPE`    | Girdi geldiğinde senkron çalışan ve sonuç üreten dönüşüm alt programı             |
| `THREAD`  | Ana programdan bağımsız çalışan asenkron iş parçacığı/görev                       |
| `PARALEL` | Birden fazla işi eşzamanlı yürütmek için kullanılan görev grubu                   |

Bunların **ortak tarafı**:

```text
adları var
parametreleri var
yerel değişkenleri var
normal uXBasic gövdeleri var
SLOT sistemine bağlanabilirler
TRIGGER ile çalıştırılırlar
```

Fakat çalışma davranışları farklı.

---

# 5. SLOT'un gerçek görevi

Bence şu ifadeyi kullanabiliriz:

> **SLOT, EVENT/PIPE/THREAD/PARALEL ailesinin çalışma zamanı bağlama, etkinleştirme ve yönlendirme sistemidir.**

Mevcut kanonik biçim zaten buna çok yakın:

```basic
SLOT
    SensorSlot    1 ON EVENT   SensorChanged
    NormalizeSlot 2 ON PIPE    Normalize
    WorkerSlot    3 ON THREAD  Calculate
    BatchSlot     4 ON PARALEL AnalyzeBatch
END SLOT
```

Bugünkü kaynak SLOT kaydında tür, ad, U8 kimliği, ON/OFF durumu ve hedef tutuluyor. 

Dolayısıyla:

```text
SLOT != görev
SLOT != görev sonucu
SLOT != thread handle

SLOT = görev yönlendirme/çalıştırma noktası
```

Bu ayrımı kesin tutalım.

---

# 6. Açık SLOT tablosu zorunlu mu?

**Hayır.**

Bu konuda mevcut 28.07 tasarımı güzel: görevler doğrudan adla da çözülebiliyor, SLOT tablosu zorunlu değil. 

Dolayısıyla:

```basic
TRIGGER THREAD Worker(10)
```

çalışabilir.

Derleyici bunu içeride örtük görev kaydı üzerinden yürütür.

Ama kullanıcı:

```basic
SLOT
    WorkerSlot 5 ON THREAD Worker
END SLOT
```

tanımlarsa şunları kazanır:

```text
sabit slot kimliği
ON/OFF kontrolü
alias/ad
kapasite
ileride scheduler/provider politikası
izleme
```

Yani explicit SLOT **yönetim katmanıdır**.

---

# 7. TRIGGER sözdizimini de temizleyelim

Bugünkü parser hem:

```basic
TRIGGER THREAD Worker, 10
```

hem kısa slot çözümleme biçimlerini destekliyor.

Yeni kanonik sözdiziminde parametreli alt program karakterini göstermek için parantezi tercih ederim:

```basic
TRIGGER EVENT SensorChanged(4, 27.5)

TRIGGER PIPE Normalize(82.0)

TRIGGER THREAD Worker(10)

TRIGGER PARALEL AnalyzeBatch(0, 1000)
```

Eski:

```basic
TRIGGER THREAD Worker, 10
```

uyumluluk için kalabilir.

---

# 8. Dönüş değerleri dört yapıda aynı olmamalı

Burası TASKOUT tasarımının özü.

### EVENT

Olay işleyicisidir.

```basic
EVENT TemperatureChanged(value AS F64)
    ...
END EVENT
```

**Sonuç döndürmez.**

Dolayısıyla:

```basic
TASKOUT = ...
```

EVENT içinde **derleme hatası** olmalı.

Çünkü olayı ateşleyen sistemin beklediği tek bir dönüş değeri kavramı yok.

---

# 9. PIPE doğrudan değer döndürür

Bu zaten kaynakta büyük ölçüde var.

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

Şunlar aynı sonuç hücresine bağlanabilir:

```basic
RETURN x
```

```basic
TASKOUT = x
```

ve mevcut uyumluluk için:

```basic
Normalize = x
```

20.09 typed-task tasarımında PIPE adı ve çıktı alanının tek sonuç hücresine bağlanması zaten yapılmıştı. 

Kanonik kullanım ise:

```basic
result = TRIGGER PIPE Normalize(82.0)
```

olmalı.

Burada TASK handle gereksiz.

PIPE çağrı bitmeden sonucu zaten üretir.

---

# 10. THREAD için TASKOUT anlamlı hale geliyor

Örneğin:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

Burada yeni kararımız:

> `TASKOUT`, global değişken değil, **o THREAD çalıştırmasının özel sonuç hücresidir.**

Yani iki çağrı:

```basic
Square(10)
Square(20)
```

için çalışma zamanı:

```text
Run #101
    TASKOUT = 100

Run #102
    TASKOUT = 400
```

oluşturur.

Birbirine dokunmazlar.

---

# 11. İşte DIM yalnız burada ortaya çıkıyor

Tanımı değil, **çalışan örneğin tutamacını** saklıyoruz:

```basic
DIM t1 AS TASK
DIM t2 AS TASK

t1 = TRIGGER THREAD Square(10)
t2 = TRIGGER THREAD Square(20)
```

Bu:

```basic
DIM Square AS TASK
```

gibi bir görev tanımı değildir.

Şuna daha çok benzer:

```basic
DIM fileHandle AS FILE_HANDLE
```

Dosyayı tanımlamıyoruz, açık dosyanın tutamacını saklıyoruz.

Dolayısıyla `DECLARE` ile `DIM` burada rakip değil:

```text
DECLARE THREAD Square(...)
       ↑
       kod sembolünün bildirimi

DIM t AS TASK
       ↑
       çalışma zamanı nesnesinin tutulacağı değişken
```

İkisi tamamen farklı.

---

# 12. TASK tutamacı zorunlu da değil

Sonucuyla ilgilenmiyorsan:

```basic
TRIGGER THREAD Logger("başladı")
```

yeter.

Görev bağımsız gider.

Yani kullanıcı her THREAD için:

```basic
DIM ...
```

yazmak zorunda değil.

Yalnız:

* beklemek,
* sonucunu almak,
* durumunu sormak,
* iptal etmek

istediğinde tutamacı saklar.

---

# 13. TASKOUT'u iki yüzlü ama tutarlı yapalım

Bence mevcut `TASKOUT` adını atmayalım.

### Görev içinde

```basic
TASKOUT = sonuc
```

şu anki çalıştırmanın çıkış hücresidir.

### Görev dışında

```basic
TASKOUT(t)
```

belirli çalıştırmanın sonucudur.

Örneğin:

```basic
DECLARE THREAD Square(x AS I32) AS I32

THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD

MAIN
    DIM a AS TASK
    DIM b AS TASK

    a = TRIGGER THREAD Square(10)
    b = TRIGGER THREAD Square(20)

    WAIT a
    WAIT b

    PRINT TASKOUT(a)
    PRINT TASKOUT(b)
END MAIN
```

Çıktı:

```text
100
400
```

Bu bence uXBasic'e çok yakışıyor.

---

# 14. `RETURN` ile TASKOUT ilişkisi

THREAD dönüş tipi varsa:

```basic
THREAD Square(x AS I32) AS I32
    RETURN x * x
END THREAD
```

ile:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

aynı sonuç hücresine yazmalı.

Fakat küçük fark:

```basic
TASKOUT = x
```

yalnız değer atar, gövde çalışmaya devam edebilir.

```basic
RETURN x
```

değeri atar **ve THREAD gövdesini bitirir.**

Bu FUNCTION davranışıyla uyumlu.

Çok kullanışlı olur.

---

# 15. THREAD dönüş tipi yoksa

```basic
THREAD Logger(message AS STRING)
    PRINT message
END THREAD
```

VOID görevdir.

Şu:

```basic
TASKOUT = 5
```

derleme hatası olmalı.

Eğer sonuç üretmek istiyorsa:

```basic
THREAD Logger(...) AS I32
```

bildirmeli.

Bu tip güvenliğini korur.

---

# 16. TASKOUT artık global isim değil

Şu an kaynakta:

```text
TASKIN
TASKOUT
```

ortak görev bağlam isimleri olarak tanımlı. Kaynak açıklaması bunların TRIGGER girdisini ve PIPE çıktısını taşımak için kullanıldığını söylüyor. 

Yeni yapıda içte şöyle düşünmeliyiz:

```text
TaskContext
    runId
    taskKind
    definitionId
    slotId

    arguments[]
    TASKIN

    resultType
    TASKOUT

    state
    error
```

Örneğin:

```text
TaskContext #51
    THREAD Square
    x = 10
    TASKOUT = 100

TaskContext #52
    THREAD Square
    x = 20
    TASKOUT = 400
```

**Her çalıştırmanın kendi TASKOUT'u var.**

Böylece gerçek thread geldiğinde yarış ortadan kalkar.

---

# 17. TASKIN ise artık ikincil uyumluluk yolu

Typed parametreler zaten var:

```basic
THREAD Worker(path AS STRING, retry AS I32)
```

Bu yüzden modern kod:

```basic
PRINT path
PRINT retry
```

kullanmalı.

`TASKIN` eski tek-girdi yaklaşımının kolaylık adı olarak kalabilir.

Ben bunu:

```text
TASKIN = ilk bağlı argümanın uyumluluk alias'ı
```

olarak bırakırdım.

Ama yeni kodun temel iletişim sistemi yapmazdım.

Çünkü çok argümanlı görevlerde zaten yetersiz.

---

# 18. PARALEL kısmında sonuçları özellikle ayırmalıyız

Burada önceki “tek TASKOUT” fikri yetmez.

Çünkü PARALEL:

> birden fazla işi aynı anda yürütür.

Dolayısıyla:

```text
PARALEL çalıştırması
    child #1 → sonuç A
    child #2 → sonuç B
    child #3 → sonuç C
```

olabilir.

Bu nedenle PARALEL trigger'ın döndürdüğü `TASK`, aslında **grup tutamacı** olabilir:

```basic
DIM g AS TASK

g = TRIGGER PARALEL Batch(...)
```

TASK nesnesinin içinde:

```text
kind = GROUP

children:
    child 0
    child 1
    child 2
```

tutulur.

Sonra:

```basic
WAIT g
```

bütün grubu bekler.

Ve ayrı sonuçlar:

```basic
PRINT TASKOUT(g, 0)
PRINT TASKOUT(g, 1)
PRINT TASKOUT(g, 2)
```

şeklinde alınabilir.

Bu tam olarak senin söylediğin **“sonuçların ayrı ayrı taşınması”** problemini çözer.

---

# 19. PARALEL'in kendisine tek TASKOUT vermeyelim

En azından ilk tasarımda.

Çünkü:

```basic
PARALEL Batch(...)
    ...
END PARALEL
```

içinde üç eşzamanlı iş varsa:

```basic
TASKOUT = ...
```

hangi işin sonucu?

Tekrar aynı eski probleme döneriz.

Bu yüzden:

> **PARALEL'in sonucu bir görev grubu olur. Tekil sonuçlar her alt çalıştırmanın TASKOUT hücresindedir.**

İleride istersek grup özeti için ayrı:

```text
GROUPRESULT
```

veya aggregate dönüş ekleyebiliriz.

Ama ilk modelde gerek yok.

---

# 20. EVENT de SLOT üzerinden bekler

Senin söylediğin önemli:

> EVENT çağrılan sıradan fonksiyon değil, olayı bekleyen alt programdır.

Tam olarak.

```basic
EVENT DoorOpened(doorId AS I32)
    PRINT doorId
END EVENT
```

tanımlanır.

Slot:

```basic
SLOT
    DoorEvent 5 ON EVENT DoorOpened
END SLOT
```

çalışma zamanında açıktır.

Gerçek dış olay oluştuğunda host/provider:

```text
Slot 5 event arrived
      ↓
EVENT DoorOpened
```

çalıştırır.

Programcı isterse elle test de eder:

```basic
TRIGGER EVENT DoorOpened(4)
```

Bu, gerçek olayı **yazılımdan üretmek** anlamına gelir.

EVENT normalde senkron işlenebilir.

---

# 21. PIPE da SLOT'a bağlanabilir ama çağrı semantiği fonksiyon gibidir

```basic
PIPE CelsiusToFahrenheit(c AS F64) AS F64
    RETURN c * 1.8 + 32
END PIPE
```

Slot:

```basic
SLOT
    TempConvert 8 ON PIPE CelsiusToFahrenheit
END SLOT
```

Doğrudan:

```basic
f = TRIGGER PIPE CelsiusToFahrenheit(25)
```

veya slot adıyla:

```basic
f = TRIGGER TempConvert(25)
```

olabilir.

Hatta mevcut `|>`:

```basic
f = 25 |> CelsiusToFahrenheit
```

aynı MIR işlemine indirilebilir.

Bu da çok güzel bir birleşme.

---

# 22. Slot adı ile çağrı da kanonik olabilir

Elimizde:

```basic
SLOT
    CalcSlot 3 ON THREAD Square
END SLOT
```

varsa:

```basic
t = TRIGGER CalcSlot(10)
```

yeterli olabilir.

Derleyici bilir:

```text
CalcSlot
    → slot 3
    → THREAD
    → Square
```

ve bunun `TASK` döndürdüğünü bilir.

Buna karşılık:

```basic
x = TRIGGER NormalizeSlot(10)
```

PIPE slotu ise `F64/I32/...` döndürür.

Bu, SLOT'u gerçekten bir **çalıştırma arayüzü** haline getiriyor.

---

# 23. Eski kısa SLOT biçimini kaldırmak mantıklı

Kaynakta:

```basic
SLOT Worker ON
```

biçiminin parser tarafından doğrudan `THREAD` kabul edildiğini biliyoruz. Bu zaten daha önce risk olarak tespit edilmişti. 

Bence artık:

```basic
SLOT Worker ON
```

**deprecated** olsun.

Kanonik kontrol:

```basic
ON THREAD Worker
OFF THREAD Worker

ON EVENT Tick
OFF EVENT Tick
```

veya açık SLOT tablosu:

```basic
SLOT
    WorkerSlot 3 ON THREAD Worker
END SLOT
```

olsun.

Tür belirsizliği kalmaz.

---

# 24. Bu durumda son sözdizimi sözleşmemiz

Bence şimdilik bunu kilitleyelim:

```basic
' İleri bildirim
DECLARE EVENT OnData(msg AS STRING)
DECLARE PIPE Normalize(x AS F64) AS F64
DECLARE THREAD Worker(x AS I32) AS I32
DECLARE PARALEL Batch(first AS I32, count AS I32)

' Tanım
EVENT OnData(msg AS STRING)
    PRINT msg
END EVENT

PIPE Normalize(x AS F64) AS F64
    RETURN x / 100.0
END PIPE

THREAD Worker(x AS I32) AS I32
    TASKOUT = x * x
END THREAD

PARALEL Batch(first AS I32, count AS I32)
    ...
END PARALEL

' Slot bağlama
SLOT
    DataSlot  1 ON EVENT   OnData
    NormSlot  2 ON PIPE    Normalize
    WorkSlot  3 ON THREAD  Worker
    BatchSlot 4 ON PARALEL Batch
END SLOT
```

Çalıştırma:

```basic
TRIGGER EVENT OnData("test")

value = TRIGGER PIPE Normalize(85.0)

DIM job AS TASK
job = TRIGGER THREAD Worker(12)

WAIT job
PRINT TASKOUT(job)

DIM group AS TASK
group = TRIGGER PARALEL Batch(0, 1000)

WAIT group
```

Ve gerekiyorsa:

```basic
PRINT TASKOUT(group, 0)
PRINT TASKOUT(group, 1)
```

---

## Son kararları kısa biçimde

**1. `DECLARE`**
`EVENT/PIPE/THREAD/PARALEL` için ileri bildirim mekanizması olacak.

**2. `DIM`**
Görev tanımlamak için kullanılmayacak. Yalnız çalışan `TASK` tutamacını saklamak gerekiyorsa kullanılacak.

**3. `SLOT`**
Dört görev ailesinin bağlama, etkinleştirme, kimlik ve çalışma zamanı yönlendirme sistemi olacak.

**4. `TRIGGER`**
Gerçek çalıştırmayı yaratacak.

**5. `TASKOUT`**
Global olmayacak. Her çalışma örneğinin özel sonuç hücresi olacak.

**6. EVENT**
Sonuç döndürmez.

**7. PIPE**
Senkron ve doğrudan tipli sonuç döndürür.

**8. THREAD**
Bağımsız/asenkron çalışır. İsteğe bağlı `AS Tip` sonucu vardır. Trigger edildiğinde TASK tutamacı üretir.

**9. PARALEL**
Görev grubu üretir. Alt görev sonuçları ayrı tutulur; tek ortak TASKOUT kullanılmaz.

Bu tasarım bence şimdi hem ilk SLOT fikrimize, hem 20.09'da oluşmuş typed-task altyapısına, hem de x64/JS/WASM eşitliği hedefimize uyuyor. En önemlisi de TASKOUT'u eski global hücre olmaktan çıkarıp gerçek eşzamanlılığa uygun hale getiriyor.


Evet. Burada önceki anlatımımda iki ayrı kavramı birbirine fazla yaklaştırmışım:

**`EVENT/PIPE/THREAD/PARALEL` birer görev değişkeni değil, adlandırılmış alt program türleridir.** Bu nedenle bunların bildiriminde `DIM` düşünmek yanlış. `DIM` ancak çalışan bir görevin **çalıştırma tutamacını** sonradan saklamak istersek anlamlı olur.

20.09 kaynağı da aslında bu yöne oldukça yaklaşmış. Dördü de SUB/FUNCTION gibi tipli parametre alabiliyor; ayrıca doğrudan adla çözümlenebiliyor, yani açık SLOT tablosu her çağrı için zorunlu değil.  

## 1. Önce kavramları kesin ayıralım

uXBasic'te bundan sonra dört ayrı şey olacak:

```text
1. DECLARE
   Görevin imzasını önceden bildirir.

2. EVENT / PIPE / THREAD / PARALEL
   Görevin gerçek kodunu tanımlar.

3. SLOT
   Tanımlanmış görevleri çalışma zamanı sistemine bağlar,
   açar/kapatır, kimlik ve yönlendirme sağlar.

4. TRIGGER
   Bir görevin belirli bir çalıştırmasını başlatır.
```

Buna beşinci olarak yalnız çalışma zamanında ortaya çıkan:

```text
5. TASK
   Başlatılmış tek bir THREAD/PARALEL çalıştırmasının tutamacıdır.
```

gelir.

Yani `TASK`, `THREAD Worker` ile aynı şey değildir.

---

# 2. `DECLARE` burada gerçekten doğru araç

Klasik BASIC mantığına da uyuyor.

Örneğin ileri bildirim:

```basic
DECLARE EVENT SensorChanged(sensorId AS I32, value AS F64)

DECLARE PIPE Normalize(value AS F64) AS F64

DECLARE THREAD Logger(message AS STRING)

DECLARE THREAD Calculate(x AS I32) AS I32

DECLARE PARALEL AnalyzeBatch(firstRow AS I32, rowCount AS I32)
```

Daha sonra gerçek tanımlar:

```basic
EVENT SensorChanged(sensorId AS I32, value AS F64)
    PRINT sensorId, value
END EVENT
```

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

```basic
THREAD Calculate(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

Bu çok daha temiz.

### `DECLARE` ne zaman gerekir?

Tanım daha önce geldiyse gerekmez:

```basic
THREAD Worker(x AS I32)
    ...
END THREAD

MAIN
    TRIGGER THREAD Worker(10)
END MAIN
```

Ama başka modülde veya dosyanın ilerleyen bölümündeyse:

```basic
DECLARE THREAD Worker(x AS I32)
```

kullanılır.

Ve `DECLARE` ile gerçek tanımın imzası bire bir uyuşmak zorunda olur.

---

# 3. Tek satırlık eski görev bildirimi artık kanonik olmasın

20.09 parserı bugün:

```basic
THREAD Worker
```

gibi gövdesiz tek satırlık biçimleri hâlâ kabul ediyor. Parser bunu tarihsel uyumluluk nedeniyle yapıyor.

Bence yeni kural:

```basic
DECLARE THREAD Worker(...)
```

ileri bildirimdir.

```basic
THREAD Worker(...)
    ...
END THREAD
```

tanımdır.

Şu eski biçim:

```basic
THREAD Worker
```

**eski uyumluluk biçimi** olarak kalabilir ama yeni kod için önerilmemeli.

Böylece “bu bir gövdesiz tanım mı, ileri bildirim mi?” saçmalığı da biter.

---

# 4. Dört yapı için kesin semantik

Senin tarifin üzerinden bunu kilitlemek bence doğru:

| Yapı      | Anlam                                                                             |
| --------- | --------------------------------------------------------------------------------- |
| `EVENT`   | Bir olayın gerçekleşmesini bekleyen ve gerçekleştiğinde çalışan olay alt programı |
| `PIPE`    | Girdi geldiğinde senkron çalışan ve sonuç üreten dönüşüm alt programı             |
| `THREAD`  | Ana programdan bağımsız çalışan asenkron iş parçacığı/görev                       |
| `PARALEL` | Birden fazla işi eşzamanlı yürütmek için kullanılan görev grubu                   |

Bunların **ortak tarafı**:

```text
adları var
parametreleri var
yerel değişkenleri var
normal uXBasic gövdeleri var
SLOT sistemine bağlanabilirler
TRIGGER ile çalıştırılırlar
```

Fakat çalışma davranışları farklı.

---

# 5. SLOT'un gerçek görevi

Bence şu ifadeyi kullanabiliriz:

> **SLOT, EVENT/PIPE/THREAD/PARALEL ailesinin çalışma zamanı bağlama, etkinleştirme ve yönlendirme sistemidir.**

Mevcut kanonik biçim zaten buna çok yakın:

```basic
SLOT
    SensorSlot    1 ON EVENT   SensorChanged
    NormalizeSlot 2 ON PIPE    Normalize
    WorkerSlot    3 ON THREAD  Calculate
    BatchSlot     4 ON PARALEL AnalyzeBatch
END SLOT
```

Bugünkü kaynak SLOT kaydında tür, ad, U8 kimliği, ON/OFF durumu ve hedef tutuluyor. 

Dolayısıyla:

```text
SLOT != görev
SLOT != görev sonucu
SLOT != thread handle

SLOT = görev yönlendirme/çalıştırma noktası
```

Bu ayrımı kesin tutalım.

---

# 6. Açık SLOT tablosu zorunlu mu?

**Hayır.**

Bu konuda mevcut 28.07 tasarımı güzel: görevler doğrudan adla da çözülebiliyor, SLOT tablosu zorunlu değil. 

Dolayısıyla:

```basic
TRIGGER THREAD Worker(10)
```

çalışabilir.

Derleyici bunu içeride örtük görev kaydı üzerinden yürütür.

Ama kullanıcı:

```basic
SLOT
    WorkerSlot 5 ON THREAD Worker
END SLOT
```

tanımlarsa şunları kazanır:

```text
sabit slot kimliği
ON/OFF kontrolü
alias/ad
kapasite
ileride scheduler/provider politikası
izleme
```

Yani explicit SLOT **yönetim katmanıdır**.

---

# 7. TRIGGER sözdizimini de temizleyelim

Bugünkü parser hem:

```basic
TRIGGER THREAD Worker, 10
```

hem kısa slot çözümleme biçimlerini destekliyor.

Yeni kanonik sözdiziminde parametreli alt program karakterini göstermek için parantezi tercih ederim:

```basic
TRIGGER EVENT SensorChanged(4, 27.5)

TRIGGER PIPE Normalize(82.0)

TRIGGER THREAD Worker(10)

TRIGGER PARALEL AnalyzeBatch(0, 1000)
```

Eski:

```basic
TRIGGER THREAD Worker, 10
```

uyumluluk için kalabilir.

---

# 8. Dönüş değerleri dört yapıda aynı olmamalı

Burası TASKOUT tasarımının özü.

### EVENT

Olay işleyicisidir.

```basic
EVENT TemperatureChanged(value AS F64)
    ...
END EVENT
```

**Sonuç döndürmez.**

Dolayısıyla:

```basic
TASKOUT = ...
```

EVENT içinde **derleme hatası** olmalı.

Çünkü olayı ateşleyen sistemin beklediği tek bir dönüş değeri kavramı yok.

---

# 9. PIPE doğrudan değer döndürür

Bu zaten kaynakta büyük ölçüde var.

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

Şunlar aynı sonuç hücresine bağlanabilir:

```basic
RETURN x
```

```basic
TASKOUT = x
```

ve mevcut uyumluluk için:

```basic
Normalize = x
```

20.09 typed-task tasarımında PIPE adı ve çıktı alanının tek sonuç hücresine bağlanması zaten yapılmıştı. 

Kanonik kullanım ise:

```basic
result = TRIGGER PIPE Normalize(82.0)
```

olmalı.

Burada TASK handle gereksiz.

PIPE çağrı bitmeden sonucu zaten üretir.

---

# 10. THREAD için TASKOUT anlamlı hale geliyor

Örneğin:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

Burada yeni kararımız:

> `TASKOUT`, global değişken değil, **o THREAD çalıştırmasının özel sonuç hücresidir.**

Yani iki çağrı:

```basic
Square(10)
Square(20)
```

için çalışma zamanı:

```text
Run #101
    TASKOUT = 100

Run #102
    TASKOUT = 400
```

oluşturur.

Birbirine dokunmazlar.

---

# 11. İşte DIM yalnız burada ortaya çıkıyor

Tanımı değil, **çalışan örneğin tutamacını** saklıyoruz:

```basic
DIM t1 AS TASK
DIM t2 AS TASK

t1 = TRIGGER THREAD Square(10)
t2 = TRIGGER THREAD Square(20)
```

Bu:

```basic
DIM Square AS TASK
```

gibi bir görev tanımı değildir.

Şuna daha çok benzer:

```basic
DIM fileHandle AS FILE_HANDLE
```

Dosyayı tanımlamıyoruz, açık dosyanın tutamacını saklıyoruz.

Dolayısıyla `DECLARE` ile `DIM` burada rakip değil:

```text
DECLARE THREAD Square(...)
       ↑
       kod sembolünün bildirimi

DIM t AS TASK
       ↑
       çalışma zamanı nesnesinin tutulacağı değişken
```

İkisi tamamen farklı.

---

# 12. TASK tutamacı zorunlu da değil

Sonucuyla ilgilenmiyorsan:

```basic
TRIGGER THREAD Logger("başladı")
```

yeter.

Görev bağımsız gider.

Yani kullanıcı her THREAD için:

```basic
DIM ...
```

yazmak zorunda değil.

Yalnız:

* beklemek,
* sonucunu almak,
* durumunu sormak,
* iptal etmek

istediğinde tutamacı saklar.

---

# 13. TASKOUT'u iki yüzlü ama tutarlı yapalım

Bence mevcut `TASKOUT` adını atmayalım.

### Görev içinde

```basic
TASKOUT = sonuc
```

şu anki çalıştırmanın çıkış hücresidir.

### Görev dışında

```basic
TASKOUT(t)
```

belirli çalıştırmanın sonucudur.

Örneğin:

```basic
DECLARE THREAD Square(x AS I32) AS I32

THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD

MAIN
    DIM a AS TASK
    DIM b AS TASK

    a = TRIGGER THREAD Square(10)
    b = TRIGGER THREAD Square(20)

    WAIT a
    WAIT b

    PRINT TASKOUT(a)
    PRINT TASKOUT(b)
END MAIN
```

Çıktı:

```text
100
400
```

Bu bence uXBasic'e çok yakışıyor.

---

# 14. `RETURN` ile TASKOUT ilişkisi

THREAD dönüş tipi varsa:

```basic
THREAD Square(x AS I32) AS I32
    RETURN x * x
END THREAD
```

ile:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

aynı sonuç hücresine yazmalı.

Fakat küçük fark:

```basic
TASKOUT = x
```

yalnız değer atar, gövde çalışmaya devam edebilir.

```basic
RETURN x
```

değeri atar **ve THREAD gövdesini bitirir.**

Bu FUNCTION davranışıyla uyumlu.

Çok kullanışlı olur.

---

# 15. THREAD dönüş tipi yoksa

```basic
THREAD Logger(message AS STRING)
    PRINT message
END THREAD
```

VOID görevdir.

Şu:

```basic
TASKOUT = 5
```

derleme hatası olmalı.

Eğer sonuç üretmek istiyorsa:

```basic
THREAD Logger(...) AS I32
```

bildirmeli.

Bu tip güvenliğini korur.

---

# 16. TASKOUT artık global isim değil

Şu an kaynakta:

```text
TASKIN
TASKOUT
```

ortak görev bağlam isimleri olarak tanımlı. Kaynak açıklaması bunların TRIGGER girdisini ve PIPE çıktısını taşımak için kullanıldığını söylüyor. 

Yeni yapıda içte şöyle düşünmeliyiz:

```text
TaskContext
    runId
    taskKind
    definitionId
    slotId

    arguments[]
    TASKIN

    resultType
    TASKOUT

    state
    error
```

Örneğin:

```text
TaskContext #51
    THREAD Square
    x = 10
    TASKOUT = 100

TaskContext #52
    THREAD Square
    x = 20
    TASKOUT = 400
```

**Her çalıştırmanın kendi TASKOUT'u var.**

Böylece gerçek thread geldiğinde yarış ortadan kalkar.

---

# 17. TASKIN ise artık ikincil uyumluluk yolu

Typed parametreler zaten var:

```basic
THREAD Worker(path AS STRING, retry AS I32)
```

Bu yüzden modern kod:

```basic
PRINT path
PRINT retry
```

kullanmalı.

`TASKIN` eski tek-girdi yaklaşımının kolaylık adı olarak kalabilir.

Ben bunu:

```text
TASKIN = ilk bağlı argümanın uyumluluk alias'ı
```

olarak bırakırdım.

Ama yeni kodun temel iletişim sistemi yapmazdım.

Çünkü çok argümanlı görevlerde zaten yetersiz.

---

# 18. PARALEL kısmında sonuçları özellikle ayırmalıyız

Burada önceki “tek TASKOUT” fikri yetmez.

Çünkü PARALEL:

> birden fazla işi aynı anda yürütür.

Dolayısıyla:

```text
PARALEL çalıştırması
    child #1 → sonuç A
    child #2 → sonuç B
    child #3 → sonuç C
```

olabilir.

Bu nedenle PARALEL trigger'ın döndürdüğü `TASK`, aslında **grup tutamacı** olabilir:

```basic
DIM g AS TASK

g = TRIGGER PARALEL Batch(...)
```

TASK nesnesinin içinde:

```text
kind = GROUP

children:
    child 0
    child 1
    child 2
```

tutulur.

Sonra:

```basic
WAIT g
```

bütün grubu bekler.

Ve ayrı sonuçlar:

```basic
PRINT TASKOUT(g, 0)
PRINT TASKOUT(g, 1)
PRINT TASKOUT(g, 2)
```

şeklinde alınabilir.

Bu tam olarak senin söylediğin **“sonuçların ayrı ayrı taşınması”** problemini çözer.

---

# 19. PARALEL'in kendisine tek TASKOUT vermeyelim

En azından ilk tasarımda.

Çünkü:

```basic
PARALEL Batch(...)
    ...
END PARALEL
```

içinde üç eşzamanlı iş varsa:

```basic
TASKOUT = ...
```

hangi işin sonucu?

Tekrar aynı eski probleme döneriz.

Bu yüzden:

> **PARALEL'in sonucu bir görev grubu olur. Tekil sonuçlar her alt çalıştırmanın TASKOUT hücresindedir.**

İleride istersek grup özeti için ayrı:

```text
GROUPRESULT
```

veya aggregate dönüş ekleyebiliriz.

Ama ilk modelde gerek yok.

---

# 20. EVENT de SLOT üzerinden bekler

Senin söylediğin önemli:

> EVENT çağrılan sıradan fonksiyon değil, olayı bekleyen alt programdır.

Tam olarak.

```basic
EVENT DoorOpened(doorId AS I32)
    PRINT doorId
END EVENT
```

tanımlanır.

Slot:

```basic
SLOT
    DoorEvent 5 ON EVENT DoorOpened
END SLOT
```

çalışma zamanında açıktır.

Gerçek dış olay oluştuğunda host/provider:

```text
Slot 5 event arrived
      ↓
EVENT DoorOpened
```

çalıştırır.

Programcı isterse elle test de eder:

```basic
TRIGGER EVENT DoorOpened(4)
```

Bu, gerçek olayı **yazılımdan üretmek** anlamına gelir.

EVENT normalde senkron işlenebilir.

---

# 21. PIPE da SLOT'a bağlanabilir ama çağrı semantiği fonksiyon gibidir

```basic
PIPE CelsiusToFahrenheit(c AS F64) AS F64
    RETURN c * 1.8 + 32
END PIPE
```

Slot:

```basic
SLOT
    TempConvert 8 ON PIPE CelsiusToFahrenheit
END SLOT
```

Doğrudan:

```basic
f = TRIGGER PIPE CelsiusToFahrenheit(25)
```

veya slot adıyla:

```basic
f = TRIGGER TempConvert(25)
```

olabilir.

Hatta mevcut `|>`:

```basic
f = 25 |> CelsiusToFahrenheit
```

aynı MIR işlemine indirilebilir.

Bu da çok güzel bir birleşme.

---

# 22. Slot adı ile çağrı da kanonik olabilir

Elimizde:

```basic
SLOT
    CalcSlot 3 ON THREAD Square
END SLOT
```

varsa:

```basic
t = TRIGGER CalcSlot(10)
```

yeterli olabilir.

Derleyici bilir:

```text
CalcSlot
    → slot 3
    → THREAD
    → Square
```

ve bunun `TASK` döndürdüğünü bilir.

Buna karşılık:

```basic
x = TRIGGER NormalizeSlot(10)
```

PIPE slotu ise `F64/I32/...` döndürür.

Bu, SLOT'u gerçekten bir **çalıştırma arayüzü** haline getiriyor.

---

# 23. Eski kısa SLOT biçimini kaldırmak mantıklı

Kaynakta:

```basic
SLOT Worker ON
```

biçiminin parser tarafından doğrudan `THREAD` kabul edildiğini biliyoruz. Bu zaten daha önce risk olarak tespit edilmişti. 

Bence artık:

```basic
SLOT Worker ON
```

**deprecated** olsun.

Kanonik kontrol:

```basic
ON THREAD Worker
OFF THREAD Worker

ON EVENT Tick
OFF EVENT Tick
```

veya açık SLOT tablosu:

```basic
SLOT
    WorkerSlot 3 ON THREAD Worker
END SLOT
```

olsun.

Tür belirsizliği kalmaz.

---

# 24. Bu durumda son sözdizimi sözleşmemiz

Bence şimdilik bunu kilitleyelim:

```basic
' İleri bildirim
DECLARE EVENT OnData(msg AS STRING)
DECLARE PIPE Normalize(x AS F64) AS F64
DECLARE THREAD Worker(x AS I32) AS I32
DECLARE PARALEL Batch(first AS I32, count AS I32)

' Tanım
EVENT OnData(msg AS STRING)
    PRINT msg
END EVENT

PIPE Normalize(x AS F64) AS F64
    RETURN x / 100.0
END PIPE

THREAD Worker(x AS I32) AS I32
    TASKOUT = x * x
END THREAD

PARALEL Batch(first AS I32, count AS I32)
    ...
END PARALEL

' Slot bağlama
SLOT
    DataSlot  1 ON EVENT   OnData
    NormSlot  2 ON PIPE    Normalize
    WorkSlot  3 ON THREAD  Worker
    BatchSlot 4 ON PARALEL Batch
END SLOT
```

Çalıştırma:

```basic
TRIGGER EVENT OnData("test")

value = TRIGGER PIPE Normalize(85.0)

DIM job AS TASK
job = TRIGGER THREAD Worker(12)

WAIT job
PRINT TASKOUT(job)

DIM group AS TASK
group = TRIGGER PARALEL Batch(0, 1000)

WAIT group
```

Ve gerekiyorsa:

```basic
PRINT TASKOUT(group, 0)
PRINT TASKOUT(group, 1)
```

---

## Son kararları kısa biçimde

**1. `DECLARE`**
`EVENT/PIPE/THREAD/PARALEL` için ileri bildirim mekanizması olacak.

**2. `DIM`**
Görev tanımlamak için kullanılmayacak. Yalnız çalışan `TASK` tutamacını saklamak gerekiyorsa kullanılacak.

**3. `SLOT`**
Dört görev ailesinin bağlama, etkinleştirme, kimlik ve çalışma zamanı yönlendirme sistemi olacak.

**4. `TRIGGER`**
Gerçek çalıştırmayı yaratacak.

**5. `TASKOUT`**
Global olmayacak. Her çalışma örneğinin özel sonuç hücresi olacak.

**6. EVENT**
Sonuç döndürmez.

**7. PIPE**
Senkron ve doğrudan tipli sonuç döndürür.

**8. THREAD**
Bağımsız/asenkron çalışır. İsteğe bağlı `AS Tip` sonucu vardır. Trigger edildiğinde TASK tutamacı üretir.

**9. PARALEL**
Görev grubu üretir. Alt görev sonuçları ayrı tutulur; tek ortak TASKOUT kullanılmaz.

Bu tasarım bence şimdi hem ilk SLOT fikrimize, hem 20.09'da oluşmuş typed-task altyapısına, hem de x64/JS/WASM eşitliği hedefimize uyuyor. En önemlisi de TASKOUT'u eski global hücre olmaktan çıkarıp gerçek eşzamanlılığa uygun hale getiriyor.


Evet, **`SLOT isim ON|OFF` kısa biçimini tamamen kaldıralım.** Zaten türü gizliyordu ve eski parserın `THREAD` varsayımı yüzünden de tuzaktı. SLOT tablosunun açık biçimi kalsın.

Asıl önemli nokta şu: daha önce konuştuğumuz `WAIT / CANCEL / STATUS / RESULT` gibi komutlar kaybolmadı. Onları şimdi **SLOT kontrolü ile çalışan görev kontrolünü birbirinden ayırarak** yerine oturtabiliriz.

## 1. SLOT için son sözdizimi

SLOT yalnız **bağlama ve etkinlik tablosu** olsun:

```basic
SLOT
    SensorSlot  1 ON  EVENT   SensorChanged
    PipeSlot    2 ON  PIPE    Normalize
    WorkerSlot  3 ON  THREAD  Worker
    BatchSlot   4 OFF PARALEL Batch
END SLOT
```

Kapasite biçimi de kalır:

```basic
SLOT EVENT <U8 32>
SLOT PIPE <U8 16>
SLOT THREAD <U8 16>
SLOT PARALEL <U8 8>
```

Ama bunlar kaldırılır:

```basic
SLOT Worker ON
SLOT Worker OFF
```

Böyle bir kısa biçim artık **yok**.

---

## 2. SLOT'u sonradan açıp kapatma

Burada mevcut açık sözdizimi yeterli:

```basic
ON EVENT SensorChanged
OFF EVENT SensorChanged

ON PIPE Normalize
OFF PIPE Normalize

ON THREAD Worker
OFF THREAD Worker

ON PARALEL Batch
OFF PARALEL Batch
```

Slot numarası özellikle belirtilmek isteniyorsa mevcut biçim korunabilir:

```basic
ON THREAD Worker SLOT 3
OFF THREAD Worker SLOT 3
```

Bunların anlamı:

```text
ON     → yeni tetiklemeleri kabul et
OFF    → yeni tetiklemeleri kabul etme
```

**Çalışmakta olan THREAD'i öldürmez.**

Bu ayrım çok önemli.

---

# 3. Çalışmakta olan görev için ayrı komutlar

Bir THREAD zaten başlatıldıysa artık SLOT değil, **TASK çalıştırma örneği** yönetilir.

Örneğin:

```basic
DIM t AS TASK

t = TRIGGER THREAD Worker(100)
```

Buradan sonra önerdiğimiz komut ailesi şuydu:

```text
WAIT
STATUS
CANCEL
KILL
PAUSE
RESUME
TASKOUT
```

Bunları şimdi kesin anlamlarıyla ayırabiliriz.

| Komut        | Anlam                                         |
| ------------ | --------------------------------------------- |
| `WAIT t`     | Görevin bitmesini bekle                       |
| `STATUS(t)`  | Görevin durumunu öğren                        |
| `TASKOUT(t)` | Sonucu al                                     |
| `CANCEL t`   | Göreve güvenli biçimde sonlanma isteği gönder |
| `KILL t`     | Görevi zorla sonlandır                        |
| `PAUSE t`    | Görevin yürütülmesini geçici durdur           |
| `RESUME t`   | Durdurulmuş görevi devam ettir                |

Burada **CANCEL ile KILL aynı şey değil.**

---

# 4. CANCEL ile KILL farkı

### CANCEL

Kibar yol:

```basic
CANCEL t
```

çalışma zamanı:

```text
cancelRequested = TRUE
```

yapar.

Görev uygun bir güvenli noktada kapanır.

Örneğin:

```basic
THREAD Worker(...) AS I32
    DO
        ...
    LOOP
END THREAD
```

çalışma zamanı döngüler, çağrılar veya belirlenmiş denetim noktalarında iptal isteğine bakabilir.

Bu yöntem:

* kaynakları kapatabilir,
* kilitleri bırakabilir,
* tamponları temizleyebilir,
* `FINALLY` çalıştırabilir.

Normal kullanım için **CANCEL tercih edilir.**

### KILL

```basic
KILL t
```

ise:

> **hemen zorla sonlandır.**

Bu tehlikelidir.

Görev:

* kilit tutuyor olabilir,
* dosya yazıyor olabilir,
* ortak belleği yarım bırakabilir.

O yüzden KILL gerçek anlamda acil sonlandırma olur.

---

# 5. Ama `KILL` zaten uXBasic'te dosya silmek için var

Burada küçük bir sözdizimi meselesi çıkıyor.

Klasik BASIC:

```basic
KILL "dosya.txt"
```

dosyayı siler.

Dolayısıyla:

```basic
KILL t
```

tip bilgisiyle ayrıştırılabilir ama bana göre gereksiz belirsizlik yaratır.

Daha temiz biçim:

```basic
KILL TASK t
```

veya:

```basic
TASK KILL t
```

olabilir.

Ben **fiil önce** biçimini uXBasic'e daha uygun buluyorum:

```basic
CANCEL TASK t
KILL TASK t
PAUSE TASK t
RESUME TASK t
```

Fakat `WAIT` için:

```basic
WAIT t
```

yeterince açık.

---

# 6. START gerekiyor mu?

Bence **gerekmiyor**.

Çünkü:

```basic
t = TRIGGER THREAD Worker(10)
```

zaten:

> Worker görevini çalıştır.

demek.

Ayrıca:

```basic
TRIGGER THREAD Worker(10)
```

sonuç/tutamaçla ilgilenmeden başlatır.

Dolayısıyla ayrıca:

```basic
START THREAD ...
```

eklemek yalnız aynı işi yapan ikinci bir fiil üretir.

`TRIGGER` zaten bu görev ailesinin ortak çalıştırma komutu.

Bu yüzden:

> **START eklemeyelim. TRIGGER çalıştırma fiili olarak kalsın.**

---

# 7. STOP da gerekmiyor

Aynı nedenle:

```basic
STOP TASK t
```

yerine iki farklı gerçek anlamımız zaten var:

```basic
CANCEL TASK t
```

güvenli bitir,

ve:

```basic
KILL TASK t
```

zorla bitir.

`STOP` eklersek “CANCEL mı, KILL mi?” diye yeni bir belirsizlik doğar.

Dolayısıyla **STOP TASK eklemeyelim.**

---

# 8. PAUSE / RESUME gerçekten gerekli mi?

Bence **evet ama ikinci aşama**.

Çünkü bir görev:

```basic
PAUSE TASK t
```

ile durdurulabilir ve:

```basic
RESUME TASK t
```

ile devam ettirilebilir.

Ama gerçek işletim sistemi thread'ini herhangi bir makine komutunun ortasında dondurmak tehlikeli.

Bu yüzden semantik:

> `PAUSE`, görevi ilk güvenli durma noktasında askıya alır.

olmalı.

Yani CANCEL gibi işbirlikçi.

Görev durumu:

```text
RUNNING
PAUSE_REQUESTED
PAUSED
RUNNING
```

olarak gider.

---

# 9. TASK durumları da kesinleşsin

`STATUS(t)` şu değerlerden birini döndürmeli:

```text
CREATED
QUEUED
RUNNING
PAUSED
COMPLETED
FAILED
CANCELLED
KILLED
```

İstersek bunları enum yapabiliriz:

```basic
IF STATUS(t) = TASK_RUNNING THEN
    ...
END IF
```

Burada string döndürmektense enum daha doğru.

---

# 10. WAIT ve JOIN

Burada fikrimi biraz sadeleştiriyorum.

Eğer **TASK hem tek görev hem PARALEL grubu temsil edebilecekse**, ayrıca `JOIN` komutuna gerek yok.

Tek görev:

```basic
WAIT t
```

Paralel grup:

```basic
WAIT g
```

Çalışma zamanı `g`nin grup olduğunu bilir ve bütün alt görevleri bekler.

Dolayısıyla:

> **JOIN eklemeyelim. WAIT tek bekleme komutu olsun.**

Dil yüzeyini gereksiz büyütmemiş oluruz.

---

# 11. RESULT yerine zaten TASKOUT var

Aynı mantıkla:

```basic
RESULT(t)
```

diye yeni yerleşik işlev eklemeye de gerek yok.

Bizim zaten özgün uXBasic kavramımız:

```basic
TASKOUT
```

var.

Bunu geliştirelim:

Görev içinde:

```basic
TASKOUT = sonuc
```

Görev dışında:

```basic
x = TASKOUT(t)
```

Paralel alt sonuç:

```basic
x = TASKOUT(g, 0)
y = TASKOUT(g, 1)
```

Dolayısıyla:

> **RESULT eklemeyelim. TASKOUT bu işi yapsın.**

Bu mevcut tasarımla çok daha uyumlu.

---

# 12. TASKIN de aynı şekilde genişleyebilir

Görevin içinde:

```basic
TASKIN
```

uyumluluk için ilk girdi olabilir.

Dışarıdan istenirse:

```basic
TASKIN(t, 0)
TASKIN(t, 1)
```

gibi tanılama amaçlı okunabilir.

Ama normal programlamada buna gerek yok çünkü artık tipli parametreler var:

```basic
THREAD Worker(path AS STRING, count AS I32)
```

Dolayısıyla `TASKIN` daha çok eski sistemle uyumluluk ve hata ayıklama aracı olarak kalır.

---

# 13. EVENT için görev kontrol komutları

EVENT kendi başına sürekli çalışan thread değildir.

Dolayısıyla:

```basic
ON EVENT SensorChanged
OFF EVENT SensorChanged
```

anlamlı.

Ama:

```basic
PAUSE TASK ...
KILL TASK ...
```

yalnız EVENT çalıştırması gerçekten asenkron bir TASK olarak başlatılmışsa anlamlı olur.

Normal EVENT davranışı:

```text
olay gelir
↓
handler çalışır
↓
handler biter
```

olduğu için tutamaç genellikle gerekmez.

---

# 14. PIPE daha da basit

PIPE:

```basic
x = TRIGGER PIPE Normalize(42)
```

sıralı çalışır ve değer döndürür.

Şunlara gerek yok:

```text
WAIT
CANCEL
PAUSE
KILL
```

çünkü çağrı bitmeden ifade zaten devam etmez.

PIPE bir **dönüşüm yordamıdır**, görev yöneticisi değil.

---

# 15. THREAD tam görev kontrol ailesini kullanır

```basic
DIM t AS TASK

t = TRIGGER THREAD Worker(100)

PRINT STATUS(t)

PAUSE TASK t
RESUME TASK t

CANCEL TASK t

WAIT t

IF STATUS(t) = TASK_COMPLETED THEN
    PRINT TASKOUT(t)
END IF
```

Gerekirse:

```basic
KILL TASK t
```

zorlayıcı son çare.

---

# 16. PARALEL aynı kontrol ailesini kullanır

```basic
DIM g AS TASK

g = TRIGGER PARALEL AnalyzeBatch(0, 10000)

PRINT STATUS(g)

WAIT g

PRINT TASKOUT(g, 0)
PRINT TASKOUT(g, 1)
PRINT TASKOUT(g, 2)
```

Grup içindeki tek görev özel olarak kontrol edilecekse ileride:

```basic
TASKCHILD(g, 1)
```

gibi bir işlev eklenebilir:

```basic
DIM c AS TASK
c = TASKCHILD(g, 1)

CANCEL TASK c
```

Ama bunu ilk sürüme sokmak şart değil.

---

# 17. SLOT OFF çalışmakta olan göreve ne yapar?

Bu da kesinleşmeli.

Örneğin:

```basic
OFF THREAD Worker
```

denildiğinde Worker'ın şu anda çalışan üç örneği varsa:

```text
Task #17 RUNNING
Task #18 RUNNING
Task #19 RUNNING
```

**bunlara dokunmamalı.**

Yalnız:

```text
bundan sonra yeni TRIGGER kabul etme
```

demeli.

Yani:

```text
OFF = kapıyı kapat
CANCEL = çalışan kişiye çıkmasını söyle
KILL = çalışan kişiyi zorla dışarı at
```

Bu üçü çok farklı.

Bu ayrım SLOT/TASK mimarisini temiz tutar.

---

# 18. Son komut ailesini böyle kilitleyelim

### Tanım ve bildirim

```basic
DECLARE EVENT ...
DECLARE PIPE ...
DECLARE THREAD ...
DECLARE PARALEL ...

EVENT ... END EVENT
PIPE ... END PIPE
THREAD ... END THREAD
PARALEL ... END PARALEL
```

### SLOT

```basic
SLOT EVENT <U8 n>
SLOT PIPE <U8 n>
SLOT THREAD <U8 n>
SLOT PARALEL <U8 n>

SLOT
    ad id ON|OFF tür hedef
END SLOT
```

**`SLOT isim ON|OFF` kaldırılıyor.**

### Etkinleştirme

```basic
ON EVENT name
OFF EVENT name

ON PIPE name
OFF PIPE name

ON THREAD name
OFF THREAD name

ON PARALEL name
OFF PARALEL name
```

### Çalıştırma

```basic
TRIGGER EVENT ...
TRIGGER PIPE ...
TRIGGER THREAD ...
TRIGGER PARALEL ...
```

### Çalışan TASK kontrolü

```basic
WAIT t

CANCEL TASK t
KILL TASK t

PAUSE TASK t
RESUME TASK t
```

### Bilgi ve sonuç

```basic
STATUS(t)
TASKOUT(t)
TASKOUT(group, index)
```

Bence burada daha önce önerdiğimiz **`START`, `STOP`, `JOIN`, `RESULT` artık gereksiz** hale geliyor. Çünkü mevcut uXBasic kelimeleri aynı anlamları daha düzgün taşıyor:

```text
START   → TRIGGER
STOP    → CANCEL veya KILL
JOIN    → WAIT
RESULT  → TASKOUT
```

Bu sadeleştirme iyi oldu. Yeni anahtar sözcük üretmek yerine **uXBasic'in zaten sahip olduğu SLOT, TRIGGER, TASKOUT yapısını gerçek eşzamanlılık semantiğine tamamlıyoruz.** Bu, başlangıçtaki tasarım fikrine de daha sadık.



Evet. Buradaki `t`yi özellikle netleştirelim, çünkü aksi halde `TASK`, `SLOT`, görev adı ve sonuç birbirine karışır.

## `t` nedir?

Şu kodda:

```basic
DIM t AS TASK

t = TRIGGER THREAD Worker(100)
```

`t`, **Worker adlı THREAD'in kendisi değildir**.

`t`, **Worker'ın bu özel çalıştırılmasının tutamacıdır**.

Yani:

```text
THREAD Worker      → görev tanımı
SLOT WorkerSlot    → görev bağlama/yönlendirme kaydı
TRIGGER Worker(100)→ yeni bir çalıştırma oluşturur
t                   → o çalıştırmanın tutamacı
TASKOUT(t)          → o çalıştırmanın sonucu
```

Bunu dosya örneğine benzetebiliriz:

```basic
DIM f AS FILE_HANDLE
```

`f`, dosyanın kendisi değildir. Açılmış dosyaya erişmek için kullanılan tutamaçtır.

Aynı şekilde:

```basic
DIM t AS TASK
```

`t`, çalışan göreve erişmek için kullanılan **görev tutamacıdır**.

---

## Aynı THREAD'in birden fazla çalıştırması olabilir

Mesela:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

Sonra:

```basic
DIM t1 AS TASK
DIM t2 AS TASK
DIM t3 AS TASK

t1 = TRIGGER THREAD Square(10)
t2 = TRIGGER THREAD Square(20)
t3 = TRIGGER THREAD Square(30)
```

Burada yalnız **bir tane** `Square` tanımı var.

Ama üç ayrı çalışma örneği var:

```text
Square
  │
  ├── TaskRun #101 → x=10
  ├── TaskRun #102 → x=20
  └── TaskRun #103 → x=30
```

Değişkenler:

```text
t1 → #101
t2 → #102
t3 → #103
```

tutar.

Sonra:

```basic
WAIT t1
WAIT t2
WAIT t3

PRINT TASKOUT(t1)
PRINT TASKOUT(t2)
PRINT TASKOUT(t3)
```

çıktısı:

```text
100
400
900
```

olur.

İşte ayrı sonuçların birbirine karışmamasını sağlayan temel mekanizma bu.

---

# `t` içinde ne var?

Kullanıcı açısından `TASK` **opak bir sistem tipi** olmalı. Yani programcı içerisindeki alanlara doğrudan müdahale etmez.

Ama çalışma zamanında mantıksal olarak şu bilgileri temsil eder:

```text
TASK
 ├─ runId
 ├─ definitionId
 ├─ slotId
 ├─ kind
 ├─ state
 ├─ arguments
 ├─ result / TASKOUT
 ├─ error
 ├─ cancelRequested
 └─ providerHandle
```

Örneğin:

```text
t:
    runId       = 101
    definition  = Worker
    slot        = 3
    kind        = THREAD
    state       = RUNNING
    result      = henüz yok
```

bittiğinde:

```text
t:
    runId       = 101
    state       = COMPLETED
    result      = 10000
```

olur.

Ama uXBasic programcısı:

```basic
PRINT t.runId
```

gibi iç yapıya erişmez.

Onun yerine:

```basic
STATUS(t)
TASKOUT(t)
WAIT t
CANCEL TASK t
```

kullanır.

---

# `t` bir sayı mı?

Kullanıcı açısından **hayır**.

İçeride x64 uygulaması bunu 64 bit kimlik veya adres benzeri bir değerle temsil edebilir.

WASM:

```text
i32/i64 görev kimliği
```

kullanabilir.

JavaScript:

```text
Task nesnesi/handle
```

kullanabilir.

Ama dil düzeyinde:

```basic
DIM t AS TASK
```

gerçek bir sistem tipidir.

Şunlara izin verilmemeli:

```basic
t = t + 1
t = t * 4
POKED t, 5
```

Çünkü TASK bir sayısal adres değildir.

Bu açıdan `PTR` ile de karıştırılmamalı.

---

# İlk `DIM` yapıldığında t'nin değeri ne?

Bence burada CLASS için verdiğimiz NULL kararına benzer davranmalıyız:

```basic
DIM t AS TASK
```

sonrasında:

```text
t = NULL TASK
```

olsun.

Henüz hiçbir görev çalıştırılmamıştır.

Sonra:

```basic
t = TRIGGER THREAD Worker(100)
```

ile geçerli hale gelir.

Dolayısıyla:

```basic
WAIT t
```

eğer `t` henüz boşsa:

```text
HATA: TASK tutamacı boş
```

vermeli.

Sessizce hiçbir şey yapmamalı.

---

# `t` ismi özel mi?

Hayır.

`t` sadece benim kısa örnek değişken adım.

İnsan daha anlamlı bir isim yazabilir:

```basic
DIM hesaplama AS TASK
DIM dosyaYukleme AS TASK
DIM sensorGorevi AS TASK
DIM analizGrubu AS TASK
```

Örneğin:

```basic
DIM hesaplama AS TASK

hesaplama = TRIGGER THREAD Calculate(500000)

WAIT hesaplama

PRINT TASKOUT(hesaplama)
```

Aslında belgelerde `t` yerine böyle adlar kullanmak daha öğretici olacak. Tek harf programcıların çok sevdiği ama altı ay sonra kendilerine bıraktıkları küçük mayınlardan biri.

---

# THREAD adı ile TASK değişkeni arasındaki fark

Şunu özellikle ayıralım:

```basic
THREAD Worker(x AS I32) AS I32
    ...
END THREAD
```

Buradaki:

```text
Worker
```

**statik görev tanımıdır.**

Program boyunca birdir.

Ama:

```basic
DIM job AS TASK
job = TRIGGER THREAD Worker(10)
```

buradaki:

```text
job
```

**dinamik çalışma örneğidir.**

Yeni `TRIGGER` yeni çalışma örneği yaratır:

```basic
DIM a AS TASK
DIM b AS TASK

a = TRIGGER THREAD Worker(10)
b = TRIGGER THREAD Worker(20)
```

```text
Worker definition
       │
       ├── run A
       └── run B
```

---

# SLOT ile TASK arasındaki fark

Bu da kesinleşsin.

Diyelim:

```basic
SLOT
    WorkerSlot 3 ON THREAD Worker
END SLOT
```

Burada:

```text
WorkerSlot
```

uzun ömürlü bir **bağlama noktasıdır**.

Ama:

```basic
DIM a AS TASK
DIM b AS TASK

a = TRIGGER WorkerSlot(10)
b = TRIGGER WorkerSlot(20)
```

iki ayrı çalışma üretir:

```text
SLOT WorkerSlot
       │
       ├── TASK a
       └── TASK b
```

Dolayısıyla:

> **SLOT birden fazla TASK üretebilir.**

Bu nedenle sonucu SLOT'ta tutmuyoruz.

---

# TASKOUT da artık daha net

Görev içinde:

```basic
THREAD Worker(x AS I32) AS I32
    TASKOUT = x * 2
END THREAD
```

buradaki `TASKOUT`:

> **şu anda çalışan TASK örneğinin sonuç hücresi**

demek.

Yani aynı anda:

```text
TASK #101 → TASKOUT = 20
TASK #102 → TASKOUT = 40
TASK #103 → TASKOUT = 60
```

olabilir.

Dışarıdan:

```basic
TASKOUT(t1)
TASKOUT(t2)
TASKOUT(t3)
```

ile ayrı ayrı erişilir.

Bu yüzden artık **global TASKOUT diye tek hücre yok**.

---

# `RETURN` ile ilişkisi

Şu ikisi aynı sonuç hücresine yazar:

```basic
THREAD Worker(x AS I32) AS I32
    TASKOUT = x * 2
END THREAD
```

ve:

```basic
THREAD Worker(x AS I32) AS I32
    RETURN x * 2
END THREAD
```

Ama fark:

```text
TASKOUT = değer
```

sonucu günceller ve yürütme devam edebilir.

```text
RETURN değer
```

sonucu yazar ve görevden çıkar.

Bu kural bence korunmalı.

---

# PARALEL'de t'nin anlamı

Burada `TASK` tipini özellikle geniş düşünüyoruz.

```basic
DIM grup AS TASK

grup = TRIGGER PARALEL Analyze(...)
```

Bu `TASK`:

```text
kind = GROUP
```

taşıyabilir.

Örneğin:

```text
grup
 ├── child 0 → TASKOUT = 12
 ├── child 1 → TASKOUT = 44
 └── child 2 → TASKOUT = 81
```

Sonra:

```basic
WAIT grup
```

bütün alt görevleri bekler.

Ve:

```basic
PRINT TASKOUT(grup, 0)
PRINT TASKOUT(grup, 1)
PRINT TASKOUT(grup, 2)
```

ayrı sonuçları verir.

Böylece ayrıca `TASKGROUP` diye ikinci bir tip açmak zorunda kalmayız.

---

# EVENT ve PIPE'ta t gerekiyor mu?

Normal kullanımda **hayır**.

### EVENT

```basic
TRIGGER EVENT Alarm(5)
```

olay işleyicisini çalıştırır.

Dönüş değeri yok.

### PIPE

```basic
x = TRIGGER PIPE Normalize(5.0)
```

zaten doğrudan senkron değer üretir.

### THREAD

```basic
t = TRIGGER THREAD Worker(5)
```

asenkron olduğu için TASK tutamacı anlamlıdır.

### PARALEL

```basic
g = TRIGGER PARALEL Batch(...)
```

eşzamanlı grup olduğu için yine TASK tutamacı anlamlıdır.

Böylece tablo çok net:

| Yapı            | `TRIGGER` sonucu |
| --------------- | ---------------- |
| `EVENT`         | VOID             |
| `PIPE ... AS T` | `T`              |
| `THREAD`        | `TASK`           |
| `PARALEL`       | `TASK`           |

---

# Son karar

Bunu tasarım defterine şu şekilde kilitlemek en doğrusu:

> **`TASK`, EVENT/PIPE/THREAD/PARALEL tanımının kendisi değildir. TASK, bir THREAD veya PARALEL tetiklemesi sonucunda oluşturulan belirli çalışma örneğine ait opak çalışma zamanı tutamacıdır. Aynı görev tanımı ve aynı SLOT, eşzamanlı olarak birden fazla TASK oluşturabilir. Her TASK kendi girişlerini, durumunu, hatasını ve TASKOUT sonucunu taşır. `DIM x AS TASK` yalnız bu tutamacı saklayacak değişkeni oluşturur; görev tanımlamaz veya başlatmaz. Başlatılmamış TASK değeri NULL'dır.**

Bu ayrımı yaptığımızda `DECLARE`, `SLOT`, `TRIGGER`, `TASK` ve `TASKOUT` beşlisi artık birbirinin ayağına basmıyor:

```text
DECLARE
   ↓
görev imzası

EVENT / PIPE / THREAD / PARALEL
   ↓
görev tanımı

SLOT
   ↓
bağlama / etkinleştirme

TRIGGER
   ↓
çalıştırma

TASK
   ↓
o çalıştırmanın tutamacı

TASKOUT(task)
   ↓
o çalıştırmanın sonucu
```

Bence artık görev sisteminin kavramsal iskeleti gerçekten temizleşti.


Evet. Buradaki `t`yi özellikle netleştirelim, çünkü aksi halde `TASK`, `SLOT`, görev adı ve sonuç birbirine karışır.

## `t` nedir?

Şu kodda:

```basic
DIM t AS TASK

t = TRIGGER THREAD Worker(100)
```

`t`, **Worker adlı THREAD'in kendisi değildir**.

`t`, **Worker'ın bu özel çalıştırılmasının tutamacıdır**.

Yani:

```text
THREAD Worker      → görev tanımı
SLOT WorkerSlot    → görev bağlama/yönlendirme kaydı
TRIGGER Worker(100)→ yeni bir çalıştırma oluşturur
t                   → o çalıştırmanın tutamacı
TASKOUT(t)          → o çalıştırmanın sonucu
```

Bunu dosya örneğine benzetebiliriz:

```basic
DIM f AS FILE_HANDLE
```

`f`, dosyanın kendisi değildir. Açılmış dosyaya erişmek için kullanılan tutamaçtır.

Aynı şekilde:

```basic
DIM t AS TASK
```

`t`, çalışan göreve erişmek için kullanılan **görev tutamacıdır**.

---

## Aynı THREAD'in birden fazla çalıştırması olabilir

Mesela:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

Sonra:

```basic
DIM t1 AS TASK
DIM t2 AS TASK
DIM t3 AS TASK

t1 = TRIGGER THREAD Square(10)
t2 = TRIGGER THREAD Square(20)
t3 = TRIGGER THREAD Square(30)
```

Burada yalnız **bir tane** `Square` tanımı var.

Ama üç ayrı çalışma örneği var:

```text
Square
  │
  ├── TaskRun #101 → x=10
  ├── TaskRun #102 → x=20
  └── TaskRun #103 → x=30
```

Değişkenler:

```text
t1 → #101
t2 → #102
t3 → #103
```

tutar.

Sonra:

```basic
WAIT t1
WAIT t2
WAIT t3

PRINT TASKOUT(t1)
PRINT TASKOUT(t2)
PRINT TASKOUT(t3)
```

çıktısı:

```text
100
400
900
```

olur.

İşte ayrı sonuçların birbirine karışmamasını sağlayan temel mekanizma bu.

---

# `t` içinde ne var?

Kullanıcı açısından `TASK` **opak bir sistem tipi** olmalı. Yani programcı içerisindeki alanlara doğrudan müdahale etmez.

Ama çalışma zamanında mantıksal olarak şu bilgileri temsil eder:

```text
TASK
 ├─ runId
 ├─ definitionId
 ├─ slotId
 ├─ kind
 ├─ state
 ├─ arguments
 ├─ result / TASKOUT
 ├─ error
 ├─ cancelRequested
 └─ providerHandle
```

Örneğin:

```text
t:
    runId       = 101
    definition  = Worker
    slot        = 3
    kind        = THREAD
    state       = RUNNING
    result      = henüz yok
```

bittiğinde:

```text
t:
    runId       = 101
    state       = COMPLETED
    result      = 10000
```

olur.

Ama uXBasic programcısı:

```basic
PRINT t.runId
```

gibi iç yapıya erişmez.

Onun yerine:

```basic
STATUS(t)
TASKOUT(t)
WAIT t
CANCEL TASK t
```

kullanır.

---

# `t` bir sayı mı?

Kullanıcı açısından **hayır**.

İçeride x64 uygulaması bunu 64 bit kimlik veya adres benzeri bir değerle temsil edebilir.

WASM:

```text
i32/i64 görev kimliği
```

kullanabilir.

JavaScript:

```text
Task nesnesi/handle
```

kullanabilir.

Ama dil düzeyinde:

```basic
DIM t AS TASK
```

gerçek bir sistem tipidir.

Şunlara izin verilmemeli:

```basic
t = t + 1
t = t * 4
POKED t, 5
```

Çünkü TASK bir sayısal adres değildir.

Bu açıdan `PTR` ile de karıştırılmamalı.

---

# İlk `DIM` yapıldığında t'nin değeri ne?

Bence burada CLASS için verdiğimiz NULL kararına benzer davranmalıyız:

```basic
DIM t AS TASK
```

sonrasında:

```text
t = NULL TASK
```

olsun.

Henüz hiçbir görev çalıştırılmamıştır.

Sonra:

```basic
t = TRIGGER THREAD Worker(100)
```

ile geçerli hale gelir.

Dolayısıyla:

```basic
WAIT t
```

eğer `t` henüz boşsa:

```text
HATA: TASK tutamacı boş
```

vermeli.

Sessizce hiçbir şey yapmamalı.

---

# `t` ismi özel mi?

Hayır.

`t` sadece benim kısa örnek değişken adım.

İnsan daha anlamlı bir isim yazabilir:

```basic
DIM hesaplama AS TASK
DIM dosyaYukleme AS TASK
DIM sensorGorevi AS TASK
DIM analizGrubu AS TASK
```

Örneğin:

```basic
DIM hesaplama AS TASK

hesaplama = TRIGGER THREAD Calculate(500000)

WAIT hesaplama

PRINT TASKOUT(hesaplama)
```

Aslında belgelerde `t` yerine böyle adlar kullanmak daha öğretici olacak. Tek harf programcıların çok sevdiği ama altı ay sonra kendilerine bıraktıkları küçük mayınlardan biri.

---

# THREAD adı ile TASK değişkeni arasındaki fark

Şunu özellikle ayıralım:

```basic
THREAD Worker(x AS I32) AS I32
    ...
END THREAD
```

Buradaki:

```text
Worker
```

**statik görev tanımıdır.**

Program boyunca birdir.

Ama:

```basic
DIM job AS TASK
job = TRIGGER THREAD Worker(10)
```

buradaki:

```text
job
```

**dinamik çalışma örneğidir.**

Yeni `TRIGGER` yeni çalışma örneği yaratır:

```basic
DIM a AS TASK
DIM b AS TASK

a = TRIGGER THREAD Worker(10)
b = TRIGGER THREAD Worker(20)
```

```text
Worker definition
       │
       ├── run A
       └── run B
```

---

# SLOT ile TASK arasındaki fark

Bu da kesinleşsin.

Diyelim:

```basic
SLOT
    WorkerSlot 3 ON THREAD Worker
END SLOT
```

Burada:

```text
WorkerSlot
```

uzun ömürlü bir **bağlama noktasıdır**.

Ama:

```basic
DIM a AS TASK
DIM b AS TASK

a = TRIGGER WorkerSlot(10)
b = TRIGGER WorkerSlot(20)
```

iki ayrı çalışma üretir:

```text
SLOT WorkerSlot
       │
       ├── TASK a
       └── TASK b
```

Dolayısıyla:

> **SLOT birden fazla TASK üretebilir.**

Bu nedenle sonucu SLOT'ta tutmuyoruz.

---

# TASKOUT da artık daha net

Görev içinde:

```basic
THREAD Worker(x AS I32) AS I32
    TASKOUT = x * 2
END THREAD
```

buradaki `TASKOUT`:

> **şu anda çalışan TASK örneğinin sonuç hücresi**

demek.

Yani aynı anda:

```text
TASK #101 → TASKOUT = 20
TASK #102 → TASKOUT = 40
TASK #103 → TASKOUT = 60
```

olabilir.

Dışarıdan:

```basic
TASKOUT(t1)
TASKOUT(t2)
TASKOUT(t3)
```

ile ayrı ayrı erişilir.

Bu yüzden artık **global TASKOUT diye tek hücre yok**.

---

# `RETURN` ile ilişkisi

Şu ikisi aynı sonuç hücresine yazar:

```basic
THREAD Worker(x AS I32) AS I32
    TASKOUT = x * 2
END THREAD
```

ve:

```basic
THREAD Worker(x AS I32) AS I32
    RETURN x * 2
END THREAD
```

Ama fark:

```text
TASKOUT = değer
```

sonucu günceller ve yürütme devam edebilir.

```text
RETURN değer
```

sonucu yazar ve görevden çıkar.

Bu kural bence korunmalı.

---

# PARALEL'de t'nin anlamı

Burada `TASK` tipini özellikle geniş düşünüyoruz.

```basic
DIM grup AS TASK

grup = TRIGGER PARALEL Analyze(...)
```

Bu `TASK`:

```text
kind = GROUP
```

taşıyabilir.

Örneğin:

```text
grup
 ├── child 0 → TASKOUT = 12
 ├── child 1 → TASKOUT = 44
 └── child 2 → TASKOUT = 81
```

Sonra:

```basic
WAIT grup
```

bütün alt görevleri bekler.

Ve:

```basic
PRINT TASKOUT(grup, 0)
PRINT TASKOUT(grup, 1)
PRINT TASKOUT(grup, 2)
```

ayrı sonuçları verir.

Böylece ayrıca `TASKGROUP` diye ikinci bir tip açmak zorunda kalmayız.

---

# EVENT ve PIPE'ta t gerekiyor mu?

Normal kullanımda **hayır**.

### EVENT

```basic
TRIGGER EVENT Alarm(5)
```

olay işleyicisini çalıştırır.

Dönüş değeri yok.

### PIPE

```basic
x = TRIGGER PIPE Normalize(5.0)
```

zaten doğrudan senkron değer üretir.

### THREAD

```basic
t = TRIGGER THREAD Worker(5)
```

asenkron olduğu için TASK tutamacı anlamlıdır.

### PARALEL

```basic
g = TRIGGER PARALEL Batch(...)
```

eşzamanlı grup olduğu için yine TASK tutamacı anlamlıdır.

Böylece tablo çok net:

| Yapı            | `TRIGGER` sonucu |
| --------------- | ---------------- |
| `EVENT`         | VOID             |
| `PIPE ... AS T` | `T`              |
| `THREAD`        | `TASK`           |
| `PARALEL`       | `TASK`           |

---

# Son karar

Bunu tasarım defterine şu şekilde kilitlemek en doğrusu:

> **`TASK`, EVENT/PIPE/THREAD/PARALEL tanımının kendisi değildir. TASK, bir THREAD veya PARALEL tetiklemesi sonucunda oluşturulan belirli çalışma örneğine ait opak çalışma zamanı tutamacıdır. Aynı görev tanımı ve aynı SLOT, eşzamanlı olarak birden fazla TASK oluşturabilir. Her TASK kendi girişlerini, durumunu, hatasını ve TASKOUT sonucunu taşır. `DIM x AS TASK` yalnız bu tutamacı saklayacak değişkeni oluşturur; görev tanımlamaz veya başlatmaz. Başlatılmamış TASK değeri NULL'dır.**

Bu ayrımı yaptığımızda `DECLARE`, `SLOT`, `TRIGGER`, `TASK` ve `TASKOUT` beşlisi artık birbirinin ayağına basmıyor:

```text
DECLARE
   ↓
görev imzası

EVENT / PIPE / THREAD / PARALEL
   ↓
görev tanımı

SLOT
   ↓
bağlama / etkinleştirme

TRIGGER
   ↓
çalıştırma

TASK
   ↓
o çalıştırmanın tutamacı

TASKOUT(task)
   ↓
o çalıştırmanın sonucu
```

Bence artık görev sisteminin kavramsal iskeleti gerçekten temizleşti.

Buradaki `100`, **THREAD’in kendisi değil**, `Worker` adlı THREAD’e gönderilen **parametre değeridir**.

Şöyle tanımlamıştık:

```basic
THREAD Worker(x AS I32) AS I32
    TASKOUT = x * 2
END THREAD
```

Burada `Worker` bir adet `I32` parametre bekliyor:

```text
x AS I32
```

Şunu yazınca:

```basic
t = TRIGGER THREAD Worker(100)
```

anlamı:

```text
Worker adlı THREAD'i başlat
x parametresine 100 ver
oluşan çalışma örneğinin TASK tutamacını t'ye koy
```

Yani çalışma sırasında:

```text
x = 100
```

olur.

Sonra gövde:

```basic
TASKOUT = x * 2
```

çalışır ve bu özel görev örneğinin sonucu:

```text
200
```

olur.

Dolayısıyla:

```basic
WAIT t
PRINT TASKOUT(t)
```

çıktısı:

```text
200
```

olur.

Kısaca:

```text
Worker      = görev adı
100         = Worker'a verilen argüman
t           = başlatılan Worker örneğinin TASK tutamacı
TASKOUT(t)  = o örneğin sonucu
```

Birden fazla parametre de olabilir:

```basic
THREAD Topla(a AS I32, b AS I32) AS I32
    TASKOUT = a + b
END THREAD
```

Çağrı:

```basic
DIM hesap AS TASK

hesap = TRIGGER THREAD Topla(20, 30)

WAIT hesap
PRINT TASKOUT(hesap)
```

Burada:

```text
20 → a
30 → b
```

ve sonuç `50`.

Yani `TRIGGER THREAD Worker(100)` sözdizimini, normal bir alt program çağrısındaki:

```basic
Worker(100)
```

gibi düşün. Tek fark, `THREAD` çağrısı **beklemeden ayrı çalışmaya başlıyor** ve sana sonucu değil, önce o çalışmanın `TASK` tutamacını veriyor.


Tam olarak **öyle yapmak zorunda değiliz**, hatta gerçek eşzamanlılık istiyorsak yalnızca `TASKOUT(0..255)` şeklinde tek bir dizi yapmak ileride bizi sınırlar.

Burada iki ayrı sayı var:

```text
SLOT kimliği : 0..255
TASK kimliği : çalışan her örnek için ayrı
```

Mesela:

```basic
SLOT
    WorkerSlot 5 ON THREAD Worker
END SLOT
```

ve ardından:

```basic
a = TRIGGER THREAD Worker(100)
b = TRIGGER THREAD Worker(200)
c = TRIGGER THREAD Worker(300)
```

üçü de **SLOT 5** üzerinden çalışabilir. Ama üç ayrı görevdir:

```text
SLOT 5
 ├─ TASK #101 → TASKOUT = 200
 ├─ TASK #102 → TASKOUT = 400
 └─ TASK #103 → TASKOUT = 600
```

Eğer yalnız:

```text
TASKOUT(5)
```

olsaydı, üç görev aynı hücreye yazardı. İnsanlığın eşzamanlılıkla başına açtığı klasik bela, şaşırtıcı biçimde burada da bizi bulurdu.

## Doğru iç yapı

Bence çalışma zamanında şöyle olmalı:

```text
SlotTable[256]
```

Bu mevcut 0..255 SLOT sistemimiz.

Her SLOT kaydı:

```text
SlotTable[5]
    kind       = THREAD
    target     = Worker
    enabled    = TRUE
    activeRuns = ...
```

tutar.

Ama sonuçlar ayrı bir görev tablosunda tutulur:

```text
TaskTable

TASK #101
    slotId  = 5
    state   = COMPLETED
    taskOut = 200

TASK #102
    slotId  = 5
    state   = RUNNING
    taskOut = ...

TASK #103
    slotId  = 5
    state   = COMPLETED
    taskOut = 600
```

Yani ilişki:

```text
256 SLOT
   │
   └── her SLOT → 0, 1 veya birçok TASK

her TASK
   └── kendi TASKOUT'u
```

olmalı.

### Kullanıcı açısından

```basic
DIM a AS TASK
DIM b AS TASK

a = TRIGGER THREAD Worker(100)
b = TRIGGER THREAD Worker(200)

WAIT a
WAIT b

PRINT TASKOUT(a)
PRINT TASKOUT(b)
```

Burada `a` ve `b`, `TaskTable` içindeki iki farklı çalışma örneğine işaret eder.

## 255 mi 256 mı?

Bir küçük düzeltme de burada:

U8:

```text
0..255
```

olduğu için toplam **256 SLOT** vardır.

Yani iç tablo düşünürsek:

```text
SlotTable[0..255]
```

256 elemanlıdır.

Ama **TASK sayısını 256 ile sınırlamayalım.**

TASK tablosu dinamik olsun:

```text
Task #1
Task #2
...
Task #10000
```

ve tamamlanıp artık kullanılmayan görev kayıtları geri dönüştürülebilsin.

### Güzel bir fiziksel model

```text
SlotTable[256]
      │
      ├── Slot 0
      ├── Slot 1
      ├── ...
      └── Slot 255
              │
              ├── TaskRun 401
              ├── TaskRun 402
              └── TaskRun 403
                       │
                       └── TASKOUT
```

Bence **son kararımız bu olmalı**:

> `TASKOUT`, 256 SLOT'a karşılık gelen global bir sonuç dizisi değildir. Her çalıştırılan TASK'ın kendi özel TASKOUT hücresi vardır. 0..255 sınırı SLOT kimliklerine aittir; TASK çalıştırma örnekleri dinamik olarak oluşturulur. Bir SLOT aynı anda birden fazla TASK çalıştırabilir.

İstersek iç uygulamada 256 elemanlı `SlotTable`ın her elemanı, o SLOT'a bağlı çalışan TASK'ların bir listesinin başlangıcını tutabilir. Böylece ilk tasarladığımız U8 tabanlı SLOT sistemi de aynen korunmuş olur.


Mete abi, burada kritik ayrım şu: **TASK sayısı ile işletim sistemi iş parçacığı sayısı aynı şey olmak zorunda değil.** Hatta uXBasic'te aynı şey yapmamak daha doğru.

Bir programın açabileceği **gerçek işletim sistemi iş parçacığı** sayısı sabit bir sayı değildir. Bellek, yığın boyutu, işletim sistemi kaynakları ve zamanlayıcı yükü belirler. Pratikte yüzlerce veya birkaç bin gerçek iş parçacığı mümkün olabilir; on binler seviyesinde ise maliyet ve zamanlama yükü ciddi biçimde artar. Buna karşılık hafif bir `TASK` yalnızca bir görev kaydıysa, bir program **on binlerce hatta yüz binlerce görev** taşıyabilir. Bunların aynı anda yalnızca örneğin 8, 16 veya 32 tanesi gerçek iş parçacıklarında çalışır.

uXBasic için bu yüzden şöyle bir ayrım öneriyorum:

```text
SLOT          0..255          → 256 sabit görev/olay bağlantı noktası
TASK          32-bit kimlik   → dinamik çalışma örnekleri
WORKER THREAD sınırlı havuz   → gerçek OS iş parçacıkları
```

Örneğin kullanıcı:

```basic
FOR i = 1 TO 10000
    görev(i) = TRIGGER THREAD Worker(i)
NEXT
```

yazabilir.

Bu, işletim sistemine 10.000 gerçek thread açmak anlamına gelmemeli. Çalışma zamanı şöyle yapar:

```text
10.000 TASK
       │
       ↓
   görev kuyruğu
       │
       ↓
┌──────────────────────┐
│ 16 gerçek worker     │
│ thread               │
└──────────────────────┘
       │
       ↓
 görevleri sırayla/eşzamanlı işler
```

Bu çok daha ölçeklenebilir.

## Neden 256 TASK az kalabilir?

Sıradan masaüstü programında çoğu zaman 256 görev fazlasıyla yeter. Ama uXBasic'i yalnız küçük masaüstü programı olarak tasarlamıyoruz.

Mesela veri bilimi:

```text
50.000 satırlık veri
100 parçaya bölündü
her parça için analiz görevi
```

veya ağ programı:

```text
2.000 bağlantı
her bağlantı için bir görev
```

veya yapay zekâ:

```text
10.000 belge
her belge için embedding/ön işleme görevi
```

gibi durumlarda 256 çalışma örneği yapay bir sınır olur.

**256 sınırı SLOT için mantıklı**, çünkü SLOT bir kayıt/yönlendirme tablosu.

Ama TASK:

> “şu anda veya geçmişte oluşturulmuş belirli bir çalışma örneği”

olduğu için dinamik olmalı.

---

## TASK kimliği için ne kullanalım?

Bence `U32` fazlasıyla yeter.

```text
0             = NULL TASK
1..4294967295 = task kimliği
```

Teorik olarak yaklaşık **4,29 milyar farklı kimlik** verir.

Bu, aynı anda 4 milyar TASK tutacağız demek değil. Kimlik havuzu geri dönüştürülebilir.

Örneğin:

```text
TASK #1
TASK #2
TASK #3
...
TASK #50000
```

tamamlanıp tutamaç artık kullanılmadığında kayıt serbest bırakılır.

İçeride indeks + nesil numarası kullanmak daha güvenli bile olabilir:

```text
TaskHandle:
    index
    generation
```

Böylece eski bir TASK tutamacının yanlışlıkla yeni görevi göstermesi engellenir.

---

## Gerçek OS thread sayısı ne olmalı?

Bunu doğrudan TASK sayısına bağlamayalım.

Varsayılan havuz örneğin:

```text
mantıksal CPU sayısı kadar
```

veya:

```text
min/max yapılandırılabilir
```

olabilir.

8 çekirdekli işlemcide:

```text
8 veya 16 worker thread
```

gayet mantıklı başlangıç olur.

Ama kullanıcı:

```basic
THREAD Worker(...)
```

yazdığında bunun “her çağrıda Windows'ta yeni thread yarat” anlamına gelmesi gerekmez.

Dil semantiği:

> **bağımsız/asenkron görev**

olsun.

Çalışma zamanı bunu thread havuzuyla gerçekleştirebilir.

Bu, JS için Worker havuzu ve WASM için worker/thread sağlayıcısıyla da uyumlu.

---

## PARALEL için daha da önemli

Mesela:

```basic
PARALEL Analyze(data)
    ...
END PARALEL
```

içeride 1000 alt görev üretebilir.

Ama fiziksel olarak:

```text
1000 TASK
16 worker thread
```

olabilir.

Yani:

$$
\text{TASK sayısı} \neq \text{gerçek thread sayısı}
$$

Bu ayrım tasarım açısından çok değerli.

---

## Benim uXBasic için kesin önerim

| Kavram                 |                              Sınır |
| ---------------------- | ---------------------------------: |
| SLOT                   |                    **256**, 0..255 |
| Aynı anda kayıtlı TASK |          dinamik, bellekle sınırlı |
| TASK kimliği           |                              `U32` |
| Gerçek worker thread   | işlemci/ayar tarafından belirlenir |
| PARALEL alt görevleri  |                            dinamik |
| TASKOUT                |                    her TASK'a ayrı |

Dolayısıyla **TASK'ı 255 veya 256 ile sınırlamak için bugün teknik bir nedenimiz yok.** 256 sınırı SLOT mimarisine çok yakışıyor, ama TASK çalışma örneklerine değil.

En önemli karar şu olabilir:

> **uXBasic THREAD, “bir OS thread aç” komutu değil; bağımsız asenkron görev tanımıdır. Gerçek OS thread sayısını çalışma zamanı zamanlayıcısı yönetir.**

Bu sayede ileride 10 görev de, 100.000 görev de aynı dil modeliyle çalışır.

Evet Mete abi. Kaynak kodu da kontrol edince tablo netleşti. Burada önemli bir düzeltme var: bizim yeni tasarımımızı **sıfırdan kurmuyoruz**. Çekirdekte bunun ciddi bir altyapısı zaten var. Eksik olan şey, mevcut 256 SLOT tabanlı çalışma zamanı ile **gerçek asenkron çalıştırma örneklerini** birbirinden ayırmak.

Aşağıdaki metni bu konunun **son tasarım sözleşmesi** olarak kabul edebiliriz.

# uXBasic EVENT / PIPE / THREAD / PARALEL / SLOT / TASK sistemi

## 1. Kaynak kodda bugün gerçekten ne var?

20.09 kaynağında çekirdek şu zinciri kullanıyor:

```text
uXBasic çekirdeği
       │
       ▼
src/runtime/native/uxb_runtime_bridge.fbs
       │
       ▼
uxb_runtime.dll
       │
       ├── libuv-1.dll
       │
       └── libtbb12.dll
```

Burada **`uxb_runtime.dll` çekirdeğin yerel çalışma zamanı köprüsü**. İki esas dış eşzamanlılık motoru ise:

```text
libuv-1.dll
libtbb12.dll   [oneTBB]
```

Kaynak `native/uxb_runtime/README.md` bunu açıkça tanımlıyor:

```text
auto:
EVENT / PIPE / THREAD → libuv
PARALEL               → oneTBB
```

ve bunlar bulunamazsa `std::thread` tabanlı yedek yol var.

Dolayısıyla daha önce konuştuğumuz:

> THREAD ve PARALEL için ayrıca yepyeni bir scheduler yazalım

fikrine ihtiyaç yok.

**Var olan çalışma zamanı genişletilecek.**

---

# 2. Fakat bugünkü çalışma zamanı henüz gerçekten asenkron değil

Bu önemli.

`libuv_backend.cpp` bugün:

```text
uv_queue_work(...)
uv_run(... UV_RUN_DEFAULT)
```

yapıyor ve iş bitene kadar dönmüyor.

`tbb_backend.cpp`:

```text
group.run(...)
group.wait()
```

yapıyor.

`std_backend.cpp`:

```text
std::thread worker(...)
worker.join()
```

yapıyor.

Yani üç yolun üçü de sonunda çağıranı bekletiyor.

Bu yüzden sorun defterindeki **S-030 tamamen doğru**:

> Altyapıda libuv ve oneTBB var, fakat THREAD/PARALEL'in bugünkü dil davranışı hâlâ gerçek asenkron çalışma değil.

Ayrıca tipli görevler bugün normal yordam çağrısına indiriliyor. Mevcut belgede de tipli `THREAD/PARALEL`in gerçek asenkron ABI yerine senkron yordam yolunu kullandığı açıkça kayıtlı. 

---

# 3. Bugünkü SLOT yapısı

Çalışma zamanındaki:

```cpp
std::array<TaskRecord, 256> tasks_;
```

doğrudan kaynakta var.

Yani:

```text
SLOT 0
SLOT 1
...
SLOT 255
```

toplam **256 fiziksel SLOT**.

`TaskRecord` bugün kabaca:

```text
defined
active
slot_id
task_type
name
callback
user_data
```

taşıyor.

Burada çok önemli eksik şu:

```text
runId yok
ayrı çalıştırma kaydı yok
çalıştırma durumu yok
çalıştırmaya özel TASKOUT yok
çocuk görev listesi yok
```

Eski tasarım belgelerinde de iki tablo düşünülmüş: görev tanımları ve `slot[256]` bağlama tablosu. 

Biz şimdi buna **üçüncü katmanı** ekliyoruz.

---

# 4. Son mimari üç tablo olacak

## A. Görev tanım tablosu

Derleme zamanı ve çalışma zamanı tanımı:

```text
TaskDefinitionTable
```

İçinde:

```text
EVENT
PIPE
THREAD
PARALEL
```

tanımları bulunur.

Örneğin:

```basic
THREAD Worker(x AS I32)
    ...
END THREAD
```

bir **görev tanımıdır**.

---

## B. SLOT tablosu

Sabit:

```text
SlotTable[0..255]
```

Görevi çalışma zamanı sistemine bağlar.

Örneğin:

```basic
SLOT
    WorkerSlot 7 ON THREAD Worker
END SLOT
```

anlamı:

```text
SLOT 7
adı       = WorkerSlot
türü      = THREAD
hedef     = Worker
durumu    = ON
```

SLOT **çalışan görev değildir**.

SLOT yalnız:

* bağlama,
* açma/kapatma,
* yönlendirme,
* çalışma zamanı motoruna kayıt,
* dış olay bağlantısı

işidir.

---

## C. Çalıştırma tablosu

Yeni eklenecek:

```text
TaskRunTable
```

Bu dinamik olacak.

Örneğin aynı Worker üç kere başlatılırsa:

```text
Worker definition
       │
       └── SLOT 7
              │
              ├── TaskRun #1001
              ├── TaskRun #1002
              └── TaskRun #1003
```

İşte bizim `TASK` dediğimiz şey **TaskRun kaydının tutamacıdır**.

---

# 5. 256 sınırı yalnız SLOT'a aittir

Kesin karar:

```text
SLOT = 0..255
       256 adet
```

Ama:

```text
TASK çalıştırmaları = dinamik
```

olacak.

Yani:

```basic
FOR i = 1 TO 10000
    ...
NEXT
```

10.000 görev oluşturabilir.

Bu:

> 10.000 gerçek işletim sistemi thread'i aç

demek değildir.

Şöyle çalışır:

```text
10.000 TASK
     │
     ▼
görev kuyruğu
     │
 ┌───┴────┐
libuv    oneTBB
worker   worker'ları
```

Fiziksel iş parçacığı sayısını çalışma zamanı yönetir.

---

# 6. TASK tam olarak nedir?

Yeni bir yerleşik sistem tipi:

```basic
TASK
```

olacak.

Örneğin:

```basic
DIM hesap AS TASK
```

yalnızca **bir görev tutamacı değişkeni** oluşturur.

Görev tanımlamaz.

Görev başlatmaz.

Başlangıç değeri:

```text
NULL TASK
```

olur.

Örneğin:

```basic
hesap = TRIGGER THREAD Worker, 100
```

sonrasında:

```text
hesap → TaskRun #1001
```

olur.

Buradaki `100`:

```text
Worker'a verilen argümandır.
```

---

# 7. TASK sayısal bir tip olmayacak

Programcı:

```basic
task = task + 1
POKED task, 123
```

yapamayacak.

`TASK`:

```text
opaque system handle
```

yani **opak sistem tutamacı** olacak.

İç uygulamada bunu güçlü biçimde:

```text
U64
```

ile taşıyabiliriz.

Örneğin:

```text
yüksek 32 bit → generation
düşük 32 bit  → table index
```

Bu sayede eski bir TASK tutamacının daha sonra başka bir göreve yanlışlıkla bağlanması engellenir.

---

# 8. Görev bildirimi için DIM değil DECLARE

Buradaki önceki karışıklık tamamen temizlendi.

Görev ileri bildirimi:

```basic
DECLARE EVENT VeriGeldi(sensor AS I32, value AS F64)

DECLARE PIPE Normalize(value AS F64) AS F64

DECLARE THREAD Worker(value AS I32)

DECLARE PARALEL AnalyzeBatch(first AS I32, count AS I32)
```

olacak.

`DECLARE`:

* görev yaratmaz,
* SLOT ayırmaz,
* thread açmaz,
* yalnız imzayı bildirir.

Bugünkü kaynakta `DECLARE` yalnız `SUB/FUNCTION` kabul ediyor. Dolayısıyla bunun parsera eklenmesi gerekiyor.

---

# 9. Gerçek görev tanımları

## EVENT

```basic
EVENT VeriGeldi(sensor AS I32, value AS F64)
    PRINT sensor, value
END EVENT
```

## PIPE

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

## THREAD

```basic
THREAD Worker(value AS I32)
    ...
END THREAD
```

## PARALEL

```basic
PARALEL Batch(first AS I32, count AS I32)
    ...
END PARALEL
```

Bugünkü kaynak bu dördünü zaten sıradan uXBasic yordam gövdeleri gibi ayrıştırıyor ve tipli parametreleri destekliyor. 

---

# 10. Parametre sözleşmesi

Dört aile de:

```basic
(a AS I32, b AS STRING, ...)
```

biçiminde tipli parametre alabilir.

Kesin kural:

```text
BYVAL = destekli
BYREF = şimdilik yasak
```

Mevcut kaynak zaten BYREF'i bilinçli olarak reddediyor, çünkü asenkron görevin elinde ömrü bitmiş bir referans kalabilir. 

Argümanlar:

1. soldan sağa,
2. tam bir kez,
3. `TRIGGER` sırasında

değerlendirilir.

Bu mevcut tek-değerlendirme kararımızla uyumludur.

---

# 11. TASKIN

`TASKIN` kalıyor.

Ama artık **global hücre olmayacak**.

Görev bağlamına ait olacak:

```text
TaskRun #1001
    TASKIN
```

Tipli görevlerde:

```basic
THREAD Worker(value AS I32, mode AS I32)
```

modern kullanım:

```basic
PRINT value
PRINT mode
```

olur.

`TASKIN` ise:

> ilk parametrenin görev bağlamındaki uyumluluk adı

olarak kalır.

Yani:

```text
TASKIN = value
```

İkinci, üçüncü parametre için `TASKIN(1)` gibi yeni bir sistem yaratmıyoruz. Parametre adları kullanılır.

---

# 12. TASKOUT artık global olmayacak

Bu en önemli karar.

Bugün kaynakta `TASKOUT` çalışma durumu içinde ortak bir sembol olarak taşınıyor. Gerçek paralellikte bu yarış oluşturur.

Yeni:

```text
TaskRun #1001 → taskOut
TaskRun #1002 → taskOut
TaskRun #1003 → taskOut
```

olacak.

Yani:

> **Her çalıştırmanın kendi TASKOUT'u vardır.**

---

# 13. EVENT sonucu

EVENT olay işleyicisidir.

```basic
EVENT Alarm(code AS I32)
    ...
END EVENT
```

sonuç üretmez.

Dolayısıyla EVENT içinde:

```basic
TASKOUT = 5
```

yasak.

```basic
RETURN 5
```

de yasak.

`RETURN` yalnız değersiz biçimde gövdeden erken çıkmak için kullanılabilir.

---

# 14. PIPE sonucu

PIPE her zaman senkrondur.

```basic
PIPE DoubleIt(x AS I32) AS I32
    TASKOUT = x * 2
END PIPE
```

veya:

```basic
PIPE DoubleIt(x AS I32) AS I32
    RETURN x * 2
END PIPE
```

aynı sonuç hücresini kullanır.

Fark:

```text
TASKOUT = x
```

sonucu yazar, yürütme devam edebilir.

```text
RETURN x
```

sonucu yazar ve PIPE'tan çıkar.

Mevcut kaynak zaten PIPE adı, `RETURN` ve görev sonuç alanını aynı sonuç semantiğine yaklaştırmış durumda. 

---

# 15. THREAD sonucu konusunda yeni son karar

Burada **20.09 kaynağından bilinçli olarak ileri gidiyoruz**.

20.09 parserı dönüş tipini yalnız PIPE için kabul ediyor.

Yeni tasarımda THREAD'in isteğe bağlı dönüş tipi olmalı:

```basic
THREAD Square(x AS I32) AS I32
    TASKOUT = x * x
END THREAD
```

veya:

```basic
THREAD Square(x AS I32) AS I32
    RETURN x * x
END THREAD
```

Bu şu nedenle gerekli:

```basic
hesap = TRIGGER THREAD Square, 10
```

asenkron döner.

Sonuç sonra:

```basic
TASKOUT(hesap)
```

ile alınır.

Dolayısıyla THREAD sonucunun tipinin derleme sırasında bilinmesi doğru olur.

Dönüş tipi yazılmazsa THREAD `VOID` kabul edilir ve:

```basic
TASKOUT = ...
RETURN değer
```

yasaktır.

Bu karar **28.07/20.09'daki “yalnız PIPE dönüş tipi alabilir” kuralını THREAD için genişletiyor.**

EVENT ve PARALEL hâlâ doğrudan skaler dönüş tipi almaz.

---

# 16. PARALEL ne demektir?

Kesin tanım:

> `PARALEL`, birden fazla asenkron görevi aynı grup altında eşzamanlı yürütür.

Örneğin:

```basic
PARALEL AnalizGrubu(n AS I32)
    TRIGGER THREAD AnalizA, n
    TRIGGER THREAD AnalizB, n
    TRIGGER THREAD AnalizC, n
END PARALEL
```

Burada üç THREAD aynı grup altında başlatılır.

PARALEL içindeki:

```basic
DIM
IF
FOR
hesaplamalar
```

koordinatör akışında sırayla yürütülür.

Ama:

```basic
TRIGGER THREAD
TRIGGER PARALEL
```

ile başlatılan işler grubun **çocuk görevleri** olur.

Böylece:

```basic
FOR i = 1 TO 1000
    TRIGGER THREAD Worker, i
NEXT
```

1000 çocuk TASK üretebilir.

---

# 17. PARALEL bitişi

`END PARALEL`, çocukları bekleyip çağıranı bloklamaz.

Şunu:

```basic
g = TRIGGER PARALEL AnalizGrubu, 100
```

yaptığımızda:

```text
g → parent GROUP TASK
```

hemen döner.

Grup tamamlanmış sayılır:

```text
bütün çocuk TASK'lar terminal duruma geldiğinde.
```

---

# 18. PARALEL sonuçları

Tek ortak:

```text
TASKOUT
```

olmayacak.

Örneğin:

```text
g
 ├─ child 0 → TASKOUT = 10
 ├─ child 1 → TASKOUT = 20
 └─ child 2 → TASKOUT = 30
```

Sonuçlar yaratılma sırasına göre numaralanır:

```text
0, 1, 2, ...
```

**Tamamlanma sırasına göre değil.**

Böylece deterministik davranır.

---

# 19. TASKOUT dışarıdan nasıl okunur?

Tek görev:

```basic
PRINT TASKOUT(hesap)
```

Grup:

```basic
PRINT TASKOUT(grup, 0)
PRINT TASKOUT(grup, 1)
PRINT TASKOUT(grup, 2)
```

`TASKOUT(task)` çalışma hâlindeyse **tamamlanmasını bekler**.

Sonra:

* tamamlandıysa sonucu verir,
* hata verdiyse görevin hatasını yükseltir,
* iptal edildiyse iptal hatası,
* öldürüldüyse öldürülme hatası

verir.

Bare:

```basic
PRINT TASKOUT
```

görev gövdesi dışında artık **yasaktır**.

Bu global TASKOUT dönemini bitirir.

---

# 20. TASKOUT'un dış dönüş tipi

`TASKOUT(task)` çalışma zamanı tarafından etiketli değer olarak taşınır.

Kullanıcı açısından dönüş:

```text
VARIANT
```

olabilir.

Örneğin:

```basic
DIM sonuc AS I32
sonuc = TASKOUT(hesap)
```

normal uXBasic atama/tip dönüşümü uygulanır.

Bu, THREAD'in:

* I32,
* F64,
* STRING,
* gelecekte RATIONAL,
* başka bir birinci sınıf tip

döndürmesine izin verir.

---

# 21. TASK çocuklarını inceleme

PARALEL için şu yerleşik işlevleri eklemek mantıklı:

```basic
TASKCOUNT(grup)
TASKCHILD(grup, index)
```

Örneğin:

```basic
FOR i = 0 TO TASKCOUNT(grup) - 1
    PRINT TASKOUT(grup, i)
NEXT
```

`TASKCHILD` özel çocuğun tutamacını verir:

```basic
DIM altGorev AS TASK

altGorev = TASKCHILD(grup, 2)
```

Sonra:

```basic
CANCEL TASK altGorev
```

yapılabilir.

---

# 22. SLOT sözdiziminin son hali

Kapasite biçimleri kalıyor:

```basic
SLOT EVENT <U8 32>
SLOT PIPE <U8 16>
SLOT THREAD <U8 32>
SLOT PARALEL <U8 16>
```

Fakat tüm SLOT kimlikleri tek ortak:

```text
0..255
```

alanındadır.

Aynı fiziksel ID iki farklı görev için kullanılamaz.

---

# 23. Kanonik SLOT tablosu

```basic
SLOT
    SensorSlot  1 ON EVENT   SensorChanged
    FilterSlot  2 ON PIPE    Normalize
    WorkerSlot  3 ON THREAD  Worker
    BatchSlot   4 ON PARALEL AnalyzeBatch
END SLOT
```

Yeni kodda **tür açıkça yazılmalı**.

Yani:

```basic
SensorSlot 1 ON SensorChanged
```

biçimini kanonik kabul etmeyelim.

İnsan okuyunca bile ne olduğu belliyse derleyicinin de fal bakmasına gerek yok.

---

# 24. SLOT çakışma kuralları

Yeni kesin kural:

```text
aynı slotId     → DERLEME HATASI
aynı slot alias → DERLEME HATASI
```

Bugünkü kaynakta aynı ID için “son gelen ezer” davranışı var.

Bunu değiştirmeliyiz.

Eşzamanlılık altyapısında:

> “son gelen sessizce önceki görevi ezdi”

mükemmel bir hata üretme fabrikası olur.

Aynı görev hedefi ise farklı SLOT'lara bağlanabilir.

---

# 25. `SLOT isim ON|OFF` kaldırılıyor

Kesin:

```basic
SLOT Worker ON
SLOT Worker OFF
```

artık yok.

Mevcut parser bunun türünü gizlice THREAD kabul ediyor. Kaynak incelemesinde de bu eski kısa biçimin THREAD'e sabitlendiği görülüyor. 

---

# 26. Açma ve kapama

Tercih edilen yeni biçim:

```basic
ON SLOT WorkerSlot
OFF SLOT WorkerSlot
```

Açık düşük seviye biçim:

```basic
ON THREAD Worker SLOT 3
OFF THREAD Worker SLOT 3
```

Eğer yalnız bir SLOT bağlıysa:

```basic
ON THREAD Worker
OFF THREAD Worker
```

da kabul edilebilir.

Birden fazla bağlama varsa SLOT belirtilmesi zorunlu olur.

---

# 27. OFF ne yapar?

Çok önemli:

```basic
OFF SLOT WorkerSlot
```

yalnızca:

> bu SLOT üzerinden **yeni görev başlatılmasını engeller**.

Çalışmakta olan TASK'lara dokunmaz.

Örneğin:

```text
Task #1001 RUNNING
Task #1002 RUNNING

OFF SLOT WorkerSlot
```

sonrasında #1001 ve #1002 devam eder.

Yeni trigger reddedilir.

---

# 28. TRIGGER'ın iki ayrı kullanım biçimi

## Doğrudan görev tanımı

```basic
TRIGGER THREAD Worker, 100
```

SLOT zorunlu değildir.

Bu yaklaşım mevcut typed-task tasarımında zaten vardır. 

## SLOT üzerinden

```basic
TRIGGER WorkerSlot, 100
```

Burada:

```text
WorkerSlot
    ↓
SLOT 3
    ↓
THREAD Worker
```

çözülür.

Bu biçim SLOT'un ON/OFF durumuna tabidir.

---

# 29. SLOT numarasıyla çağrı

Düşük seviye kullanım da olabilir:

```basic
TRIGGER SLOT 3, 100
```

Bu özellikle:

* dış sistem,
* cihaz sürücüsü,
* host API,
* otomatik oluşturulan kod

için kullanışlıdır.

Normal kullanıcı kodunda slot adı daha okunur.

---

# 30. TRIGGER statement ve expression olacak

Bugün `TRIGGER` yalnız statement hattında.

Yeni sistemde iki bağlamı olacak.

Sonucuyla ilgilenmiyorsan:

```basic
TRIGGER THREAD Logger, "başladı"
```

Sonucu/tutamacı istiyorsan:

```basic
DIM hesap AS TASK

hesap = TRIGGER THREAD Worker, 100
```

PIPE:

```basic
DIM x AS F64

x = TRIGGER PIPE Normalize, 82.5
```

PARALEL:

```basic
DIM grup AS TASK

grup = TRIGGER PARALEL Batch, 100
```

EVENT ise VOID olduğu için:

```basic
TRIGGER EVENT Alarm, 5
```

yalnız statement olabilir.

---

# 31. PIPE doğrudan da çağrılabilir

Bugünkü tipli görev tasarımında PIPE'ın doğrudan yordam gibi çağrılması zaten desteklenmiş durumda. 

Dolayısıyla:

```basic
x = Normalize(82.5)
```

geçerli.

Bu doğrudan çağrıdır.

```basic
x = TRIGGER FilterSlot, 82.5
```

ise SLOT üzerinden yönetilen çağrıdır.

İkisi aynı PIPE gövdesine iner.

---

# 32. EVENT çalışma modeli

EVENT:

> olay gelmesini bekleyen kayıtlı olay yordamıdır.

Ama blok kendi içinde sonsuz döngüyle “beklemez”.

Beklemeyi çalışma zamanı yapar.

```text
libuv event loop
      │
 olay gelir
      │
 SLOT çözülür
      │
 EVENT handler
```

Ayrıca yazılımdan:

```basic
TRIGGER EVENT VeriGeldi, 42
```

ile olay elle üretilebilir.

Dış DLL veya host da ABI üzerinden olayı tetikleyebilir.

---

# 33. Aynı EVENT'e birden fazla SLOT bağlanabilir

Örneğin:

```basic
SLOT
    LoggerSlot  1 ON EVENT VeriGeldi
    ScreenSlot  2 ON EVENT VeriGeldi
    StoreSlot   3 ON EVENT VeriGeldi
END SLOT
```

`TRIGGER EVENT VeriGeldi, 42`

bütün ON bağlamalarını çalıştırabilir.

Deterministik sıra:

```text
artan SLOT numarası
1 → 2 → 3
```

olsun.

Ama:

```basic
TRIGGER LoggerSlot, 42
```

yalnız o SLOT'u çalıştırır.

---

# 34. THREAD çalışma modeli

THREAD:

> ana programdan bağımsız asenkron görevdir.

```basic
DIM hesap AS TASK

hesap = TRIGGER THREAD Worker, 100

PRINT "Ana program devam ediyor"
```

`TRIGGER` işi kuyruğa koyduktan sonra hemen döner.

Worker çalışırken ana program devam eder.

Bu gerçek davranış için mevcut:

```text
libuv → uv_queue_work
```

kullanılacak.

Ama bugünkü gibi hemen ardından:

```text
uv_run(...tamamlanana kadar bekle...)
```

yapılmayacak.

libuv döngüsü çalışma zamanına ait, uzun ömürlü bir scheduler olacak.

---

# 35. PARALEL çalışma modeli

PARALEL:

> çok sayıda TASK'ı aynı grup altında yürütür.

oneTBB burada doğru motor.

Bugünkü:

```cpp
group.run(...)
group.wait()
```

tek callback için kullanılıyor.

Yeni yapıda:

```text
parent TaskRun
    │
    ├── tbb task 1
    ├── tbb task 2
    ├── tbb task 3
    └── ...
```

olacak.

Caller tarafındaki:

```basic
grup = TRIGGER PARALEL Batch, ...
```

`group.wait()` yapmayacak.

`WAIT TASK grup`

istendiğinde bekleme yapılacak.

---

# 36. TASK kontrol komutlarının son hali

Yeni görev yönetim ailesi:

```basic
WAIT TASK t

CANCEL TASK t
KILL TASK t

PAUSE TASK t
RESUME TASK t
```

Bunların yanında:

```basic
TASKSTATUS(t)
TASKOUT(t)
TASKERROR(t)
TASKCOUNT(t)
TASKCHILD(t, index)
```

yerleşik işlevleri olacak.

`START`, `STOP`, `JOIN`, `RESULT` eklemiyoruz.

Çünkü:

```text
START  → TRIGGER
STOP   → CANCEL/KILL
JOIN   → WAIT
RESULT → TASKOUT
```

zaten var.

---

# 37. WAIT

```basic
WAIT TASK t
```

görev terminal duruma gelene kadar bekler.

Grup TASK ise:

```basic
WAIT TASK grup
```

bütün çocukların tamamlanmasını bekler.

---

# 38. CANCEL

```basic
CANCEL TASK t
```

**işbirlikçi iptal** ister.

Görev güvenli noktada:

* döngü geri dönüşünde,
* görev çağrısında,
* bloklayan uXBasic işleminde,
* runtime denetim noktasında

iptali görür.

Normal:

* FINALLY,
* destructor,
* kaynak temizliği

çalışabilir.

---

# 39. KILL

`KILL` dosya silme komutu olarak zaten var.

Bu nedenle görev biçimi açık:

```basic
KILL TASK t
```

olacak.

Bu:

> en güçlü sonlandırma isteği

anlamına gelir.

Ama uXBasic **Windows `TerminateThread` gibi tehlikeli, belleği ortada bırakabilecek zorla thread öldürmeyi varsayılan yapmayacak**.

KILL ilk güvenli çalışma zamanı noktasında görevi keser.

CANCEL'den farkı:

```text
CANCEL → kullanıcı temizleme yoluna izin verir
KILL   → görev gövdesini mümkün olan ilk güvenli noktada sonlandırır
```

Çalışma zamanı kendi iç bütünlüğünü yine korur.

---

# 40. PAUSE / RESUME

```basic
PAUSE TASK t
RESUME TASK t
```

işbirlikçi olacaktır.

Gerçek OS thread'i keyfî makine komutunun ortasında dondurulmaz.

PAUSE:

```text
RUNNING
   ↓
PAUSE_REQUESTED
   ↓
PAUSED
```

RESUME:

```text
PAUSED
   ↓
RUNNING
```

Harici DLL çağrısında bekleyen bir görev, DLL çağrısı dönene kadar PAUSE'a cevap vermeyebilir.

Bu açıkça tanımlı davranış olacak.

---

# 41. TASK durumları

`TASKSTATUS(t)` şu enum değerlerinden birini verir:

```text
TASK_NULL
TASK_CREATED
TASK_QUEUED
TASK_RUNNING
TASK_PAUSE_REQUESTED
TASK_PAUSED
TASK_COMPLETED
TASK_FAILED
TASK_CANCELLED
TASK_KILLED
```

Grup için:

* çocuklar çalışıyorsa RUNNING,
* hepsi başarılıysa COMPLETED,
* en az biri başarısızsa FAILED,
* grup iptal edilmişse CANCELLED,
* zorla sonlandırılmışsa KILLED.

---

# 42. Hata sistemi

Görev hatası kendi TaskRun kaydında:

```text
errorCode
errorText
```

saklanır.

Okuma:

```basic
PRINT TASKERROR(t)
```

`TASKOUT(t)` başarısız göreve uygulanırsa hata tekrar yükseltilir.

Böylece:

```basic
TRY
    PRINT TASKOUT(t)
CATCH
    PRINT TASKERROR(t)
END TRY
```

kullanılabilir.

---

# 43. Ateşle ve unut

Şu:

```basic
TRIGGER THREAD Logger, "mesaj"
```

tutamaç saklamaz.

Görev yine TaskRunTable'a girer.

Tamamlanınca otomatik temizlenir.

Hata verirse kimse `TASKOUT` okumayacağı için hata:

```text
runtime diagnostics
```

kanalına yazılır.

Sessizce kaybolmaz.

---

# 44. TASK yaşam döngüsü

```basic
DIM a AS TASK
DIM b AS TASK

a = TRIGGER THREAD Worker, 10
b = a
```

`a` ve `b` aynı çalışma örneğini gösterir.

TASK runtime tarafından yönetilen referans tipi gibi davranır.

Kullanıcı:

```basic
FREE TASK
```

yazmak zorunda değildir.

Tutamaç üzerine yazıldığında veya scope bittiğinde çalışma zamanı referansı bırakır.

Görev bitmiş ve hiçbir kullanıcı/grup referansı kalmamışsa TaskRun kaydı geri dönüştürülür.

---

# 45. Program biterken ne olacak?

`END MAIN` veya normal program çıkışında:

1. yeni TRIGGER kabulü durur,
2. aktif görevler için CANCEL istenir,
3. çalışma zamanı güvenli kapanmayı bekler,
4. sonsuza takılan görev varsa yapılandırılmış kapanış politikası uygulanır,
5. libuv döngüsü kapanır,
6. oneTBB grupları kapatılır,
7. `uxb_runtime.dll` shutdown olur.

Bu yüzden fire-and-forget görev yüzünden süreç rastgele yarıda kesilmez.

---

# 46. İki dış DLL'in kesin görevi

## libuv-1.dll

Yeni v2 tasarımda temel sorumluluğu:

```text
EVENT olay döngüsü
THREAD çalışma kuyruğu
asenkron callback
I/O/event scheduling
```

olacak.

PIPE'ın gözlenebilir davranışı senkron kalacak. Gerekirse içeride libuv kullanılabilir ama çağıran sonuç gelmeden devam etmez.

## libtbb12.dll

Temel sorumluluğu:

```text
PARALEL görev grupları
iş paylaşımı
worker pool
çok çekirdekli yürütme
```

olacak.

`UXB_TBB_THREADS` mevcut yapılandırması korunabilir.

---

# 47. std yolu neden kalmalı?

İki DLL bulunmasa bile:

```text
std::thread / C++ runtime
```

yedek yol kalmalı.

Böylece:

> “libuv yok, THREAD artık çalışmıyor”

gibi bir dil semantiği oluşmaz.

Dış DLL'ler **optimizasyon/uygulama motorudur**, dil özelliğinin kendisi değildir.

---

# 48. ABI v1 neden yetmiyor?

Bugünkü native ABI:

```text
(slotId, int inputValue, int* outputValue)
```

taşıyor.

Yani esasen:

```text
I32 giriş
I32 çıkış
```

dünyası.

Bu yüzden tipli görevler native scheduler yolunu kullanamıyor ve normal yordam çağrısına düşüyor. Mevcut belge de bunu açıkça söylüyor. 

Gerçek tasarım için:

> **TASK ABI v2 zorunlu.**

---

# 49. ABI v2'nin taşıması gerekenler

En az:

```text
TaskHandle
TaskKind
SlotId
TaskDefinitionId

ArgumentCount
TypedArguments[]

ResultType
TypedResult

State
Error

ParentTask
ChildTasks[]

CancelRequested
KillRequested
PauseRequested
```

taşımalı.

I32'ye daraltma olmayacak.

---

# 50. Çalışma zamanı tabloları

Bugünkü:

```cpp
std::array<TaskRecord,256> tasks_;
```

ikiye ayrılmalı:

```text
SlotTable[256]

TaskRunTable[dynamically sized]
```

ve ayrıca görev tanım tablosu:

```text
TaskDefinitionTable
```

olmalı.

Özet:

```text
TaskDefinition
      │
      ▼
SlotRecord
      │
      ▼
TaskRun 1
TaskRun 2
TaskRun 3
...
```

---

# 51. TASKIN/TASKOUT fiziksel olarak nereye taşınacak?

Artık `ExecState` içindeki tek global isimlere değil:

```text
TaskExecutionContext
```

içine.

Örneğin:

```text
TaskExecutionContext #1001
    arguments[]
    TASKIN
    TASKOUT
    state
    error
```

Thread yerel depolama veya TaskRun'a bağlı context pointer kullanılabilir.

Bu da mevcut global yarışını ortadan kaldırır.

---

# 52. PARALEL çocuk yapısı

Örneğin:

```text
Task #5000 GROUP
 │
 ├─ Task #5001
 ├─ Task #5002
 └─ Task #5003
```

`WAIT TASK #5000`:

```text
5001
5002
5003
```

üçünü bekler.

`CANCEL TASK #5000` tüm bitmemiş çocuklara yayılır.

`PAUSE`, `RESUME`, `KILL` de grup üzerinde çocuklara yayılır.

---

# 53. Paylaşılan değişkenler

Gerçek eşzamanlılık geldiğinde şu tehlike gerçek olur:

```basic
DIM Shared x AS I32

THREAD A()
    x = x + 1
END THREAD

THREAD B()
    x = x + 1
END THREAD
```

Bunların eşzamanlı yazımı **veri yarışı**dır.

İlk TASK v2 uygulamasında:

> eşzamanlı, korumasız ortak yazımların sonucu tanımsız/garantisizdir.

Görev kontrol tablolarının kendisi mutex/atomiklerle korunacaktır.

Kullanıcı verisi için daha sonra MUTEX/ATOMIC ailesi ayrıca tasarlanmalıdır.

Bu konu artık ayrıca sorun defterine girmeli. Gerçek paralelliğe geçip kilit sistemini hiç konuşmamak, yangın tüpünü bina yandıktan sonra sipariş etmek olur.

---

# 54. JS ve WASM'a nasıl taşınacak?

Kanonik görev modeli hedefe bağımlı olmayacak:

```text
TASK_SPAWN
TASK_WAIT
TASK_CANCEL
TASK_KILL
TASK_PAUSE
TASK_RESUME
TASK_STATUS
TASK_RESULT
TASK_CHILD
```

MIR'de görünür olacak.

x64:

```text
uxb_runtime.dll
 → libuv / oneTBB
```

JS:

```text
Worker / Worker pool
```

WASM:

```text
WASM threads
veya host worker sağlayıcısı
```

Ama kaynak uXBasic değişmeyecek.

---

# 55. Son kullanıcı sözdiziminin tam örneği

```basic
DECLARE EVENT OlcumGeldi(sensor AS I32, value AS F64)
DECLARE PIPE Normalize(value AS F64) AS F64
DECLARE THREAD Hesapla(value AS I32) AS I32
DECLARE PARALEL TopluAnaliz(count AS I32)


EVENT OlcumGeldi(sensor AS I32, value AS F64)
    PRINT sensor, value
END EVENT


PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE


THREAD Hesapla(value AS I32) AS I32
    TASKOUT = value * value
END THREAD


PARALEL TopluAnaliz(count AS I32)
    DIM i AS I32

    FOR i = 1 TO count
        TRIGGER THREAD Hesapla, i
    NEXT i
END PARALEL


SLOT
    OlcumSlot   1 ON EVENT   OlcumGeldi
    NormSlot    2 ON PIPE    Normalize
    HesapSlot   3 ON THREAD  Hesapla
    AnalizSlot  4 ON PARALEL TopluAnaliz
END SLOT


MAIN
    DIM tekGorev AS TASK
    DIM grup AS TASK
    DIM sonuc AS I32
    DIM i AS I32

    TRIGGER EVENT OlcumGeldi, 4, 7.25

    PRINT TRIGGER PIPE Normalize, 85.0

    tekGorev = TRIGGER THREAD Hesapla, 12

    PRINT "Ana program devam ediyor"

    WAIT TASK tekGorev
    sonuc = TASKOUT(tekGorev)
    PRINT sonuc

    grup = TRIGGER PARALEL TopluAnaliz, 10

    WAIT TASK grup

    FOR i = 0 TO TASKCOUNT(grup) - 1
        PRINT TASKOUT(grup, i)
    NEXT i
END MAIN
```

---

# 56. Son sözleşme tablosu

| Yapı      | Görevi                  | Çalıştırma             | `TRIGGER` sonucu     | TASKOUT      |
| --------- | ----------------------- | ---------------------- | -------------------- | ------------ |
| `EVENT`   | olay işleyici           | olay geldiğinde        | VOID                 | yok          |
| `PIPE`    | senkron dönüşüm         | hemen                  | bildirilmiş tip      | çağrı-yerel  |
| `THREAD`  | bağımsız asenkron görev | libuv/worker           | `TASK`               | görev başına |
| `PARALEL` | eşzamanlı görev grubu   | oneTBB                 | `TASK` grup tutamacı | çocuk başına |
| `SLOT`    | bağlama/yönlendirme     | çalıştırmaz            | yok                  | yok          |
| `TASK`    | tek çalıştırma tutamacı | çalışma zamanı nesnesi | n/a                  | kendi sonucu |

## Ve yürürlükteki ana karar

```text
DECLARE  → imza
EVENT/PIPE/THREAD/PARALEL → tanım
SLOT     → bağlama ve ON/OFF
TRIGGER  → çalıştırma
TASK     → belirli çalıştırmanın tutamacı
TASKOUT  → belirli çalıştırmanın sonucu
```

Kaynak incelemesiyle birlikte en önemli sonuç şu: **mevcut libuv + oneTBB + `uxb_runtime.dll` altyapısını atmıyoruz. Tam tersine, S-030'un çözümü bu altyapıyı ABI v2, dinamik TaskRun tablosu ve görev-başına TASKIN/TASKOUT bağlamıyla tamamlamak.** Mevcut çekirdek doğru iskeleti kurmuş, fakat bugün SLOT ile “çalıştırma örneği” aynı kayıt içinde fazla iç içe. Asıl mimari düzeltme bu ikisini ayırmak.

Evet, burada ilginç bir damar var Mete abi. Verdiğin Python parçasının yaptığı şey aslında basitçe:

> **“Bir tanım/metaveri al, bundan uXBasic kaynak kodu üret.”**

Ve 20.09 uXBasic kaynaklarını kontrol edince gördüğüm şu: **önişlemci/metakomut sistemi bunun önemli bir kısmını zaten yapabilecek durumda.** Henüz Python’daki gibi “REST tanımını oku ve doğrudan FUNCTION üret” seviyesinde birleşmemiş. Fakat gerekli yapıtaşlarının çoğu mevcut.

## Kaynakta bugün neler gerçekten var?

20.09 önişlemcide `%%DEFINE`, `%%MACRO`, `%%SET`, `%%EVAL`, `%%FOR`, `%%FOREACH`, `%%REPEAT`, koşullar, hedef seçimi, şablon blokları ve dosya/artefakt üretimi var. Ayrıca web tarafında doğrudan `%%API_ENDPOINT`, `%%ROUTE`, `%%EXPORT_BASIC`, `%%HOST_IMPORT`, `%%GEN_FILE`, `%%GEN_BLOCK` gibi komutlar zaten tanımlı. 

Daha da önemlisi, önişlemci sonucu yalnız metin değil. Kaynakta `PreprocessResult` içinde doğrudan:

```text
expandedSource
blocks[]
assets[]
watImports[]
manifest[]
sourceMap[]
...
```

tutuluyor. Yani önişlemci zaten **kaynak üretimi + ek dosya üretimi + manifest üretimi** için mimari olarak hazırlanmış. 

`GEN_BLOCK` da gerçek bir blok türü. Kaynak tarayıcısı bunu `GEN ... GEN_END` şeklinde yakalayıp bir üretim bloğu olarak saklıyor. 

Bu yüzden verdiğin Python fikri uXBasic'e yabancı değil. Tam tersine mevcut metakomut sisteminin doğal devamı.

---

# Python kodunun yaptığı şeyi ayıralım

Verdiğin bölümde iki temel üretici var.

Birincisi REST işleyicisi üretiyor:

```python
FUNCTION HandleGETUsers(request AS DICT) AS DICT
...
END FUNCTION
```

İkincisi genel fonksiyon iskeleti üretiyor:

```python
FUNCTION isim(parametreler) AS dönüş_tipi
    DIM result AS ...
    ...
    RETURN result
END FUNCTION
```

Yani Python tarafında model kabaca:

```text
metadata
   ↓
generator
   ↓
uXBasic source text
   ↓
compiler
```

Ben bunu uXBasic'in içine taşırsam:

```text
%% meta komutlar
      ↓
Preprocessor
      ↓
Generated uXBasic source
      ↓
normal lexer/parser
      ↓
semantic
      ↓
MIR
      ↓
x64 / JS / WASM
```

olmalı.

Burada kritik nokta şu:

> **Üretilen kod özel bir “meta kod” olarak yaşamamalı. Normal uXBasic kaynak koduna dönüşmeli ve ardından normal derleyiciden geçmeli.**

Bu çok güçlü bir tasarım olur.

---

# Hatta bunun bir bölümü bugün bile yapılabilir

Mevcut `%%FOREACH` gerçekten kaynak metni çoğaltıyor.

Mesela düşünce deneyi olarak:

```basic
%%FOREACH METHOD IN GET,POST,DELETE
FUNCTION Handle{{METHOD}}Users(request AS DICT) AS DICT
    PRINT "{{METHOD}}"
END FUNCTION
%%ENDFOREACH
```

önişlemci bunu üç ayrı FUNCTION'a açabilir.

Kaynakta `%%FOREACH` gövdesi içindeki `{{degisken}}` ve `%%degisken` biçimleri gerçekten değiştiriliyor ve genişletilmiş kaynak içine yazılıyor.

Dolayısıyla mevcut motor zaten **basit kod üreticisi**.

Python'a tamamen mahkûm değiliz.

---

# Fonksiyon benzeri makrolar da var

Kaynakta parametreli `%%MACRO` sistemi de bulunuyor.

Kabaca şu düşünce mümkün:

```basic
%%MACRO MAKE_HANDLER(NAME, METHOD) ...
```

ve daha sonra:

```basic
MAKE_HANDLER(Users, GET)
MAKE_HANDLER(Users, POST)
```

gibi kaynak satırları çoğaltılabilir.

Fakat mevcut fonksiyon makroları satır tabanlı çalışıyor. Çok satırlı büyük kod üretimi için bunlara abanmak istemem.

Burada `GEN` ve şablon sistemi daha doğru yer.

---

# Verdiğin Python kodunda uXBasic açısından birkaç sorun var

Burası önemli, çünkü Python kodunu aynen uXBasic üreticisine çevirirsek bazı şeyler şimdiki dil yüzeyiyle uyuşmaz.

Örneğin:

```python
request["method"]
```

üretiyorsun.

Ama mevcut uXBasic DICT kullanımının doğrulanmış biçimi:

```basic
DICTGET(request, "method")
DICTSET(request, "method", value)
```

şeklinde. Kaynak örnekleri de `DIM ... AS DICT` + `DICTSET/DICTGET` kullanıyor. 

Dolayısıyla üretilecek kod şimdilik:

```basic
SELECT CASE DICTGET(request, "method")
```

olmalı.

Aynı şekilde Python tarafındaki:

```python
RETURN {"status": 200, "data": "Success"}
```

çıktısı uXBasic'te doğrulanmış bir DICT literal sözdizimi değil.

Bugünkü gerçek sözdizimine daha uygun olan:

```basic
DIM response AS DICT

DICTSET(response, "status", 200)
DICTSET(response, "data", "Success")

RETURN response
```

şeklinde üretmek.

Bu küçük ayrıntı önemli. Kod üretici “güzel görünen” uXBasic değil, **gerçek parserın kabul ettiği uXBasic** üretmeli.

---

# Bir başka Python tasarım kusuru

Şu:

```python
Handle{method}{endpoint.replace('/', '_').title()}
```

basit endpointlerde çalışır.

Ama:

```text
/users/{id}
/api/v1/fish-farms
```

gibi yollar geldiğinde:

```text
{}
-
:
```

gibi karakterler geçerli uXBasic tanımlayıcıları olmayabilir.

Bu yüzden ortak bir:

```text
SanitizeIdentifier()
```

yani **geçerli ad üretici** gerekiyor.

Örneğin:

```text
/users/{id}
→ Users_Id

/api/v1/fish-farms
→ ApiV1FishFarms
```

Bu iş Python'da da, uXBasic meta motorunda da tek merkezden yapılmalı.

---

# Bir de mantıksal fazlalık var

Python kodu her HTTP yöntemi için ayrı fonksiyon üretiyor:

```text
HandleGETUsers
HandlePOSTUsers
```

ama fonksiyonun içinde tekrar:

```basic
SELECT CASE request["method"]
    CASE "GET"
```

kontrolü yapıyor.

Bu iki farklı tasarımın aynı anda uygulanması.

Ya:

```text
tek endpoint dispatcher
```

yaparsın:

```basic
FUNCTION HandleUsers(request AS DICT) AS DICT
    SELECT CASE DICTGET(request, "method")
        CASE "GET"
        CASE "POST"
    END SELECT
END FUNCTION
```

ya da:

```text
method başına ayrı handler
```

üretirsin:

```basic
FUNCTION HandleGetUsers(...)
FUNCTION HandlePostUsers(...)
```

ve içeride method kontrolü gerekmez.

Ben ikinci yolu tercih ederim. Daha temiz, daha kolay tip bağlanır ve route tablosu doğrudan handler'a bağlanır.

---

# Mevcut `%%API_ENDPOINT` bunun başlangıcı zaten

Bugünkü metakomut:

```basic
%%API_ENDPOINT UsersGet GET "/users"
```

gibi bir API kaydı oluşturabiliyor.

Ama kaynakta yaptığı şey şu anda:

> **manifest'e endpoint bilgisi yazmak**

yani henüz FUNCTION üretmiyor.

Bu ayrım önemli.

Şu an:

```text
%%API_ENDPOINT
       ↓
manifest
```

var.

Bizim düşündüğümüz yeni sistem:

```text
%%API_ENDPOINT
       ↓
manifest
       ↓
REST generator
       ↓
generated uXBasic functions
```

olur.

İşte verdiğin Python'daki `MetaCommand` sınıfının uXBasic içindeki gerçek karşılığı burada ortaya çıkıyor.

---

# Bence yeni bir “meta üretici” katmanı kurabiliriz

Mevcut önişlemcinin üstüne şu mantığı ekleyebiliriz:

```text
Meta declaration
      ↓
Meta registry
      ↓
Generator
      ↓
generated source
      ↓
normal compiler
```

Örneğin:

```basic
%%API_ENDPOINT UsersGet GET "/users"
%%API_ENDPOINT UsersPost POST "/users"
%%GENERATE REST_HANDLERS
```

çıktısı:

```basic
FUNCTION HandleUsersGet(request AS DICT) AS DICT
    DIM response AS DICT

    DICTSET(response, "status", 200)
    DICTSET(response, "data", "Success")

    RETURN response
END FUNCTION


FUNCTION HandleUsersPost(request AS DICT) AS DICT
    DIM response AS DICT

    DICTSET(response, "status", 200)
    DICTSET(response, "data", "Success")

    RETURN response
END FUNCTION
```

olabilir.

Ama `%%GENERATE` diye yeni komut eklemek zorunda da değiliz.

Mevcut:

```text
GEN_FILE
GEN_BLOCK
TEMPLATE
API_ENDPOINT
ROUTE
EXPORT_BASIC
```

ailesini genişletebiliriz.

---

# Ben yeni sistemi `GEN_BLOCK` üzerinden büyütmeyi daha mantıklı buluyorum

Örneğin:

```basic
%%GEN_BLOCK SOURCE REST_HANDLERS
...
%%GEN_END
```

gibi bir biçim düşünülebilir.

Fakat mevcut kaynakta `GEN_BLOCK` şu anda **artefakt bloğu** olarak saklanıyor, doğrudan `expandedSource` içine geri sokulmuyor.

Bu yüzden burada iki seçenek var.

Birinci seçenek yeni komut:

```basic
%%GEN_SOURCE_BEGIN
...
%%GEN_SOURCE_END
```

İkinci ve bence daha güzel seçenek mevcut `GEN_BLOCK`a hedef eklemek:

```basic
%%GEN_BLOCK SOURCE
...
%%GEN_END
```

Bunun anlamı:

> Bu bloktan çıkan metni dosyaya değil, derlenmeye devam edecek uXBasic kaynağına ekle.

Bu, Python generator'ının yaptığı işe tam karşılık gelir.

---

# Daha güçlü biçim: şablonlu kod üretme

Örneğin:

```basic
%%GEN_BLOCK SOURCE
%%FOREACH METHOD IN GET,POST,PUT,DELETE

FUNCTION Handle{{METHOD}}Users(request AS DICT) AS DICT
    DIM response AS DICT

    DICTSET(response, "status", 200)
    DICTSET(response, "method", "{{METHOD}}")

    RETURN response
END FUNCTION

%%ENDFOREACH
%%GEN_END
```

Bunun sonucu doğrudan dört normal uXBasic fonksiyonu olur.

Bu çok güçlü.

Python script gerekmez.

---

# Asıl sıçrama meta verinin kendisini iterable yapmak olur

Şu anda `%%FOREACH` basit CSV liste üzerinde dönüyor.

Mesela:

```basic
%%FOREACH METHOD IN GET,POST,PUT
```

yapabiliyoruz.

Ama elimizde zaten:

```basic
%%API_ENDPOINT ...
```

kayıtları varsa daha güzel olan:

```basic
%%FOREACH API IN META.API_ENDPOINTS
```

gibi bir yapı.

Sonra:

```basic
{{API.NAME}}
{{API.METHOD}}
{{API.PATH}}
```

kullanılabilir.

Örneğin:

```basic
%%API_ENDPOINT GetFish GET "/fish"
%%API_ENDPOINT AddFish POST "/fish"

%%FOREACH API IN META.API_ENDPOINTS

FUNCTION Handle{{API.NAME}}(request AS DICT) AS DICT
    DIM response AS DICT
    DICTSET(response, "status", 200)
    RETURN response
END FUNCTION

%%ENDFOREACH
```

Bu artık **gerçek derleme zamanı metaprogramlama** olur.

Ve mevcut mimariye şaşırtıcı derecede doğal oturuyor.

---

# Böylece Python'daki `generate_function_code()` da doğrudan karşılık bulur

Mesela yeni meta sözdizimi:

```basic
%%FUNCTION_META CalculateArea RETURNS F64 PARAMS "width:F64,height:F64"
```

veya daha genel:

```basic
%%GEN_FUNCTION CalculateArea(width AS F64, height AS F64) AS F64
```

şuna dönüşür:

```basic
FUNCTION CalculateArea(width AS F64, height AS F64) AS F64
    DIM result AS F64

    RETURN result
END FUNCTION
```

Fakat burada dikkat: her şeyi yeni komut yaparsak 125 metakomut bir sabah uyanıp 400 olur. İnsanlık bürokrasiyi derleyiciye de taşıma konusunda ürkütücü derecede başarılı.

Bu yüzden ben **genel generator modeli** isterim.

Örneğin:

```basic
%%GENERATE FUNCTION ...
%%GENERATE REST ...
%%GENERATE CLASS ...
%%GENERATE SERIALIZER ...
```

tek üst komut, farklı üreticiler.

---

# Asıl büyük fırsat REST değil

Bu sistem kurulduğunda çok daha fazlasını yapabiliriz.

| Meta tanım               | Otomatik üretilebilecek uXBasic kodu         |
| ------------------------ | -------------------------------------------- |
| `%%API_ENDPOINT`         | REST handler, route tablosu, OpenAPI bilgisi |
| `TYPE`                   | JSON serialize/deserialize                   |
| `CLASS`                  | constructor, clone, hash, tostring           |
| `DERIVE`                 | EQ/HASH/CLONE/JSON kodu                      |
| DLL header/manifest      | CALL(DLL) wrapper                            |
| `HOST_IMPORT`            | JS/WASM host wrapper                         |
| `EXPORT_BASIC`           | export bridge                                |
| SQL tablo şeması         | CRUD yordamları                              |
| EVENT tanımları          | dispatcher/slot binding                      |
| THREAD/PARALEL           | task wrapper                                 |
| CLI metadata             | argument parser                              |
| TEST metadata            | otomatik test iskeletleri                    |
| kütüphane tipi manifesti | MAGIC operatör bağlantıları                  |

Bu özellikle bizim **birinci sınıf kütüphane tipi** tasarımına çok yakışıyor.

Mesela:

```basic
%%DERIVE JSON, EQ, HASH FOR FishRecord
```

gibi bir meta komut:

```basic
FUNCTION FishRecord_ToJson(...)
FUNCTION FishRecord_Equals(...)
FUNCTION FishRecord_Hash(...)
```

üretebilir.

Derleyici çekirdeğine her şeyi gömmek yerine kaynak kod üretilir.

Bu tam bizim uXBasic felsefesi.

---

# REST için daha ileri bir örnek

Mesela:

```basic
%%API_ENDPOINT FishList GET "/fish"
%%API_ENDPOINT FishCreate POST "/fish"
%%API_ENDPOINT FishGet GET "/fish/{id}"

%%GENERATE REST_HANDLERS
```

üretici:

```basic
FUNCTION HandleFishList(request AS DICT) AS DICT
    DIM response AS DICT

    ' TODO: kullanıcı mantığı

    DICTSET(response, "status", 501)
    RETURN response
END FUNCTION
```

gibi stub üretir.

Aynı metadata'dan ayrıca:

```text
routes.json
openapi.json
browser client JS
WASM host binding
test skeleton
```

üretilebilir.

Bir tanım, beş çıktı.

İşte meta sisteminin gerçekten değerli olduğu yer bu.

---

# Ancak kritik mimari kural koymalıyız

Ben Python gibi derleyici sırasında rastgele kod çalıştıran bir sistem istemem.

Yani:

```text
%%PYTHON_EXEC ...
```

gibi bir şey çekirdeğe sokmayalım.

Çünkü o zaman:

* build tekrarlanabilirliği bozulur,
* güvenlik bozulur,
* Windows/Linux farkları çıkar,
* kaynak dosya dış dünyaya bağlı hale gelir,
* JS/WASM paketleme zorlaşır.

Meta motoru **deterministik** olmalı.

Şunları yapabilir:

```text
metadata oku
string işle
döngü yap
koşul yap
template genişlet
kaynak üret
artefakt üret
manifest üret
```

ama rastgele işletim sistemi programı çalıştırmamalı.

---

# Python yine de nerede işe yarar?

Dış geliştirme aracında.

Örneğin:

```text
OpenAPI JSON
     ↓
Python generator
     ↓
%%API_ENDPOINT dosyası
     ↓
uXBasic compiler
```

olabilir.

Ama uzun vadede:

```text
OpenAPI JSON
     ↓
uXBasic meta importer
     ↓
Meta registry
     ↓
generated uXBasic
```

daha güzel.

Python başlangıçta prototip üreticisi olabilir.

---

# Mevcut meta sisteminde eksik gördüğüm asıl dört şey

Burada düşünce deneyinin gerçek sonucu bunlar:

1. **Meta kayıtları üzerinde yapılandırılmış dolaşım yok.**
   `%%FOREACH` liste dolaşıyor ama `API_ENDPOINTS`, `EXPORTS`, `TYPES`, `FIELDS` gibi derleyici metadata koleksiyonlarını dolaşamıyor.

2. **GEN_BLOCK doğrudan uXBasic kaynak enjeksiyonu yapmıyor.**
   Artefakt oluşturuyor. `SOURCE` hedefi eklenmeli.

3. **Derleyici sembol introspection'ı yok.**
   Meta motoru henüz “bana `TYPE Fish` alanlarını ver” diyemiyor.

4. **Generator kayıt sistemi yok.**
   `REST`, `SERIALIZER`, `FFI_WRAPPER`, `TEST`, `CLI`, `DERIVE` gibi generator isimleri ortak arayüzle çağrılamıyor.

Bunları eklediğimiz anda meta sistemi basit preprocessor olmaktan çıkıp **derleme zamanı kod üretim sistemi** haline gelir.

---

# Bence hedef mimari şöyle olmalı

```text
              uXBasic kaynak
                    │
                    ▼
           META TOPLAMA AŞAMASI
                    │
          ┌─────────┴─────────┐
          │                   │
      kullanıcı meta      sembol meta
      API_ENDPOINT        TYPE/CLASS/FUNCTION
      ROUTE               FIELD/METHOD
      HOST_IMPORT         EXPORT
          │                   │
          └─────────┬─────────┘
                    ▼
             GENERATOR REGISTRY
                    │
      ┌─────────────┼──────────────┐
      ▼             ▼              ▼
     REST        SERIALIZE        FFI
      │             │              │
      └─────────────┴──────────────┘
                    ▼
          GENERATED UXB SOURCE
                    │
                    ▼
              normal parser
                    │
                    ▼
                  MIR
          ┌────────┼────────┐
         x64       JS       WASM
```

Burada en güzel taraf şu:

**Generator çıktısının hedefe özel olması gerekmez.**

REST handler uXBasic olarak üretilirse aynı kod:

```text
x64
JS
WASM
```

hedeflerine gidebilir.

Bu, bizim son JS/WASM tasarım kararlarımızla da doğrudan uyumlu.

---

## Benim bu düşünce deneyinden çıkardığım karar

Verdiğin Python sınıfını uXBasic'e “Python gömelim” diye okumazdım.

Ben bunu şöyle okurum:

> **uXBasic'in mevcut meta komut sistemi, dış Python kod üreticilerinin yaptığı işleri kendi içinde tanımlı ve güvenli biçimde yapabilecek bir derleme zamanı kod üretim katmanına dönüştürülebilir.**

Ve bunun için yepyeni bir sistem yazmamıza gerek yok.

Zaten elimizde:

```text
%%DEFINE / %%MACRO
%%IF
%%FOR / %%FOREACH / %%REPEAT
%%EVAL
%%TEMPLATE
%%API_ENDPOINT
%%ROUTE
%%EXPORT_BASIC
%%HOST_IMPORT
%%GEN_FILE
%%GEN_BLOCK
manifest
expandedSource
sourceMap
```

var. 

Eksik olan şey bunları **“metadata → generator → uXBasic source”** zincirinde birbirine bağlamak.

Bence bu, uXBasic'te sıradan makro sisteminden çok daha değerli bir özellik olabilir. Özellikle `TYPE/CLASS + DERIVE + REST + JSON + FFI + JS/WASM` taraflarını tek bir mimaride birleştirir.


Evet. 23.09 kaynak durumu, önceki S-030 tasarımı ve son konuşmalarımızı birlikte düşününce K1-K8 için verilecek cevapları artık netleştirebiliriz.

## S-030 karar cevapları

| Karar                                                 | Cevap                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **K1. `TASKGROUP.JOINALL()` ne döndürecek?**          | **İleride `LIST` döndürecek, fakat şimdi uygulanmayacak.** Önce LIST içindeki farklı sonuç tiplerinin AST/MIR/native/JS/WASM'da ortak ve güvenli temsilinin kesinleşmesi gerekiyor. Şimdilik `g.JOIN()` + tek tek `t.RESULT` kullanılır. Genel “fonksiyon dizi döndürür” özelliği sırf JOINALL için açılmayacak.                                                                                                                                                                                                                                       |
| **K2. `TASKGROUP` mı `TASK_GROUP` mı?**               | **Kullanıcı dilinde `TASKGROUP` kesin ad.** Takma ad olmayacak. MIR iç isimleri `TASK_GROUP_CREATE`, `TASK_GROUP_ADD`, `TASK_GROUP_JOIN` olabilir.                                                                                                                                                                                                                                                                                                                                                                                                     |
| **K3. Görevler hangi verilere erişebilir?**           | **Varsayılan güvenli model.** SPAWN sınırından normal değerler `BYVAL` geçer; görev kendi parametrelerini, yerellerini ve sabitleri kullanır. Değiştirilebilir global veriye örtük erişim Faz 2'de yasaklanır. `BYREF` yasak kalır. CLASS/LIST/DICT/PTR gibi paylaşım veya yaşam süresi sorunu yaratabilecek değerler, açık sahiplik/paylaşım sözleşmesi gelene kadar SPAWN sınırından doğrudan geçirilmez. Daha sonra `SHARED`, `ATOMIC`, `MUTEX` benzeri açık paylaşım modeli tasarlanır. Eski `TRIGGER` davranışı bu kararla geriye dönük kırılmaz. |
| **K4. İş parçacığı havuzu?**                          | **Varsayılan fiziksel işçi sayısı mantıksal işlemci sayısına göre otomatik belirlenir.** `--task-workers N` ile değiştirilebilir. TASK sayısı iş parçacığı sayısından bağımsızdır. İç içe SPAWN serbesttir. Bir worker başka görevi beklerken mümkünse kuyruktaki başka işi çalıştırabilmelidir.                                                                                                                                                                                                                                                       |
| **K5. Program kapanırken aktif TASK varsa?**          | **Normal kapanışta program sahip olduğu görevlerin bitmesini bekler.** Hata nedeniyle kapanışta aktif görevlere iptal isteği gönderilir ve çalışma zamanı güvenli biçimde boşaltılır. Kullanıcının hiç okumadığı bir TASK `ERROR` durumunda bittiyse hata sessiz kaybolmaz; hata çıkışına yazılır ve program çıkış kodu başarısız olur. İleride gerçek “arka planda bırak ve unut” davranışı gerekirse ayrı `DETACH` semantiği tasarlanabilir.                                                                                                         |
| **K6. `CANCEL()` nasıl çalışacak?**                   | **İşbirlikçi iptal.** `t.CANCEL()` yalnız iptal isteğini işaretler. Döngü turları, WAIT/JOIN, SPAWN ve uygun çalışma zamanı çağrıları güvenli iptal noktalarıdır. İptal sonunda `t.STATUS = CANCELLED`, `t.ERRORTEXT = "CANCELLED"` olur. `t.RESULT` veya `t.JOIN()` kullanılırsa iptal hatası çağırana aktarılır. Tekrar CANCEL çağrısı zararsız olmalıdır.                                                                                                                                                                                           |
| **K7. Senkron referans uygulaması hangi motorlarda?** | **AST mevcut referans uygulama olarak kalır. MIR yorumlayıcısına aynı senkron semantik mutlaka eklenir. Native x64'e geçici senkron sürüm yazılmaz, doğrudan gerçek asenkron Faz 2 uygulanır. Legacy x64 SPAWN/TASK için açık “desteklenmiyor” hatası verir.**                                                                                                                                                                                                                                                                                         |
| **K8. JS tarafını kim yapacak?**                      | **JS S-030 Faz 3 Antigravity alanında kalmalı.** Aynı dosyalara eşzamanlı müdahale yapılmamalı. Önce karar ve görev `SORULAR_CEVAPLAR.md` / ilgili koordinasyon defterine bırakılır. Faz 3 başlamadan önce JS'nin bugünkü yanlış `ux.callMethod(...)` üretimi kaldırılıp SPAWN/TASK için açık “henüz desteklenmiyor” hatası vermesi sağlanır; `SLOT_DEF` eksikliği de Antigravity'nin JS işiyle birlikte çözülür.                                                                                                                                      |

### K3'ü biraz daha kesin yazalım

En kritik karar bu. Ben **(a)'yı aynen almıyorum**, çünkü “CLASS, LIST, DICT, PTR sonsuza kadar yasaktır” demek uXBasic'in sistem programlama tarafını gereksiz yere budar.

Karar şu olsun:

```text
SPAWN sınırında varsayılan:
    scalar BYVAL      → izinli
    immutable/copy-safe değer → izinli
    CONST             → okunabilir
    mutable global    → yasak
    BYREF             → yasak
    CLASS/LIST/DICT   → sahiplik/paylaşım modeli gelene kadar yasak
    PTR               → açık güvenli/paylaşılan bellek sözleşmesi gelene kadar yasak
```

Sonra ayrı çalışma kapsamında:

```text
SHARED
ATOMIC
MUTEX
LOCK
```

ve MemoryRef/S-056 ile:

```text
shared native memory
explicit pointer sharing
ownership/lifetime
```

tanımlanır.

Böylece varsayılan güvenli olur ama uXBasic'i oyuncak dile de çevirmeyiz.

---

## S-030'un bundan sonraki kesin sırası

Bence koordinasyon defterine şu sıra yazılmalı:

```text
S-030 FAZ 1 KAPANIŞ
    ↓
tests/task_model/
g(i).JOIN() genel alıcı çözümü
TASK/TASKGROUP yüzey matrisi
JS fail-fast
    ↓
S-030 FAZ 1B, KANONİK MIR
    TASK_SPAWN
    TASK_WAIT
    TASK_JOIN
    TASK_CANCEL
    TASK_STATUS
    TASK_RESULT
    TASK_ERROR
    TASK_GROUP_CREATE
    TASK_GROUP_ADD
    TASK_GROUP_JOIN
    ↓
AST ↔ MIR eşdeğerlik testleri
    ↓
S-030 FAZ 2 NATIVE x64
    ABI v2
    TaskRun tablosu
    gerçek worker havuzu
    result/error
    CANCEL
    shutdown
    PRINT kilidi
    stres testleri
    ↓
S-030 FAZ 3 JS
    Worker/worker pool
    ↓
S-030 FAZ 4 WASM
```

`JOINALL`, `BYREF`, `PAUSE`, `RESUME`, `KILL`, ortak değiştirilebilir bellek ve kilitleme mekanizmaları **S-030'un çekirdek kapanışını geciktirmemeli**. Bunlar ayrı genişletmeler olarak izlenmeli.

### Deftere doğrudan yazılabilecek cevap

> **K1:** `JOINALL()` ileride sonuçları `LIST` olarak döndürecektir; LIST'in heterojen/tipli sonuç sözleşmesi bütün hedeflerde kesinleşene kadar bilinçli olarak ertelenmiştir. Genel dizi dönüş özelliği bu iş için açılmayacaktır.
> **K2:** Kullanıcı dili tipi `TASKGROUP` olarak kesinleştirilmiştir. `TASK_GROUP_*` yalnız iç MIR adlandırmasında kullanılabilir.
> **K3:** SPAWN görevlerinde varsayılan izolasyon uygulanacaktır. Parametreler BYVAL'dır; yereller ve sabitler serbesttir. Mutable global erişim, BYREF ve paylaşım/ömür sözleşmesi olmayan CLASS/LIST/DICT/PTR değerleri Faz 2'de reddedilecektir. Açık paylaşılan veri modeli ayrı tasarlanacaktır. Eski TRIGGER semantiği bundan etkilenmeyecektir.
> **K4:** Native çalışma zamanı dinamik TASK sayısını sınırlı sayıda worker üzerinde yürütecektir. Varsayılan worker sayısı mantıksal CPU sayısına göre AUTO olacaktır; `--task-workers N` ile değiştirilebilecektir. İç içe SPAWN desteklenecektir.
> **K5:** Normal program kapanışı sahip olunan görevlerin tamamlanmasını bekleyecektir. Hatalı kapanışta kalan görevler iptal edilerek runtime güvenli kapatılacaktır. Okunmamış görev hataları sessizce kaybolmayacaktır.
> **K6:** `CANCEL()` işbirlikçi olacaktır. İptal döngülerde ve tanımlı güvenli noktalarda gözlenecek; son durum `CANCELLED`, hata metni `CANCELLED` olacaktır. `RESULT/JOIN` iptal hatasını çağırana aktaracaktır.
> **K7:** AST Faz 1 referans uygulaması olarak korunacaktır. Canonical MIR'e aynı senkron referans semantiği eklenecektir. Native x64 doğrudan gerçek asenkron Faz 2'ye geçecektir. Legacy x64 açık desteklenmiyor hatası verecektir.
> **K8:** JS Faz 3 Antigravity'nin sorumluluğunda yürütülecektir. Çakışmalı JS dosyalarına başka ajan eşzamanlı müdahale etmeyecektir. Faz 3 öncesi sessiz yanlış kod üretimi temiz desteklenmiyor hatasına dönüştürülecek, mevcut `SLOT_DEF` açığı aynı JS çalışma paketinde kapatılacaktır.

Bu cevap setiyle artık S-030 için **karar bekleyen gerçek tek büyük mimari konu paylaşılan veri ailesinin ayrıntılı tasarımıdır**. O da Faz 2'ye başlamadan önce ayrı bir küçük tasarım oturumunda `SHARED/ATOMIC/MUTEX + MemoryRef` ekseninde kilitlenmeli.

Mete abi, bunu artık S-030’un yan notu gibi değil, **uXBasic’in eşzamanlı bellek modeli** olarak tasarlamak gerekiyor. Çünkü gerçek `THREAD/PARALEL` geldiği anda mesele sadece “iş parçacığı açmak” olmuyor. Hangi veri kimin, kim değiştirebilir, işaretçi ne kadar yaşayabilir, kütüphane nesnesi başka göreve geçebilir mi, kilit altında hata olursa ne olur gibi neşeli insan icatları bir anda kapıya dayanıyor.

23.09 kaynağını bu açıdan tekrar kontrol ettim. Aşağıdaki tasarım mevcut kodu mümkün olduğunca koruyor ve S-030 Faz 2'nin önünü açıyor.

# 1. Önce mevcut kaynak gerçekliği

23.09 kaynakta yeni görev sistemi gerçekten şu seviyede:

```basic
t = SPAWN Worker(...)
t.STATUS
t.RESULT
t.ERRORTEXT
t.WAIT()
t.JOIN()
t.CANCEL()
```

ve `TASKGROUP` mevcut. `SPAWN` tarafında `BYREF` halen açıkça reddediliyor; dizi parametreleri de AST çalışma yolunda reddediliyor. Bu, önceki tipli görev tasarımındaki “asenkron sahiplik/ömür modeli kurulmadan BYREF yok” kararıyla uyumlu.

Fakat **uXBasic kullanıcı dilinde şu anda `SHARED`, `ATOMIC` veya `MUTEX` yok**. 23.09 `lexer_keyword_table.fbs` içinde `SPAWN`, `TASK`, `TASKGROUP`, `BYREF`, `PTR`, `LIST`, `DICT` vb. var; bu üç yeni kavram henüz dil yüzeyine eklenmemiş.

MemoryRef tarafı ise beklediğimizden ileride. `src/common/memory_ref.fbs` bugün uXBasic'e ait NATIVE bölgeleri:

```text
base
length
kind
owner
generation
state
```

ile izliyor, REDIM/ERASE sonrası eski işaretçiyi yakalamak için tombstone bırakıyor. Fakat şimdiki kayıt sistemi özellikle dizi backing storage'ına odaklı, 4096 kayıtla sınırlı ve hata metni `gUxbMemRefLastError` adlı **ortak global** değişkende tutuluyor. Gerçek eşzamanlılıkta bu global hata alanı yarış üretir.

JS/WASM tasarımımız zaten MemoryRef, ARRAY, CLASS, koleksiyonlar ve birinci sınıf kütüphane tiplerinin hedeflerden bağımsız sözleşmeyle taşınmasını öngörüyor. THREAD/PARALEL için de JS Worker ve WASM thread/host worker yolları planlanmış durumda. 

Bir başka önemli bulgu: `uxclz.dll` mevcut kaynakta nesne tutamaçlarını generation kontrollü olarak yönetiyor ve kayıt tablosunu `std::mutex` ile koruyor. Fakat nesne metoduna girerken mutex altında yalnız nesneyi bulup refcount artırıyor, sonra mutex'i bırakıp asıl payload metodunu çağırıyor. Dolayısıyla:

> **uxclz kayıt sistemi thread-safe olabilir, ama uxclz nesnesinin payload'ı otomatik olarak thread-safe değildir.**

Bu ayrım, kütüphane sınıf tipleri için çok önemli.

---

# 2. Ana kural: uXBasic varsayılan olarak veri paylaşmayacak

S-030 için temel bellek modeli şu olsun:

```text
Normal değişken
    ↓
TASK'a otomatik ortak edilmez.

BYVAL parametre
    ↓
Göreve özel snapshot/kopya.

SHARED
    ↓
Açıkça paylaşılan veri.

ATOMIC
    ↓
Atomik paylaşılan skaler.

MUTEX / LOCK
    ↓
Paylaşılan değiştirilebilir veriyi korur.
```

Yani kullanıcı şunu yazarsa:

```basic
DIM total AS I64

THREAD Worker()
    total = total + 1
END THREAD
```

ve `Worker` `SPAWN` ile çalıştırılacaksa derleyici:

```text
HATA: Worker, değiştirilebilir global 'total' değişkenine
eşzamanlı görevden erişiyor.
total değerini parametreyle geçir, ATOMIC yap veya SHARED olarak bildir.
```

demeli.

Bu varsayılanı özellikle seçiyorum. C/C++ tarzı “her şey paylaşılır, sonra üç hafta race condition kovala” modelini dilin varsayılanı yapmak için hiçbir sebebimiz yok.

---

# 3. Üç temel yeni dil öğesi

Kanonik sözdizimini şöyle belirleyelim.

### Normal paylaşılan veri

```basic
DIM SHARED durum AS SensorState
DIM SHARED buffer(999) AS F64
```

### Atomik veri

```basic
DIM ATOMIC sayac AS U64 = 0
DIM ATOMIC durdur AS BOOLEAN = FALSE
```

`ATOMIC`, zaten paylaşılan anlamına gelir. Şu biçim gereksiz ve hata olmalı:

```basic
DIM SHARED ATOMIC sayac AS I64
```

### Kilit nesnesi

```basic
DIM kilit AS MUTEX
```

`MUTEX`, **karşılıklı dışlama kilidi** sistem tipidir.

Bunların üçü aynı şey değil:

| Yapı     | Amaç                                                |
| -------- | --------------------------------------------------- |
| `SHARED` | Aynı verinin birden fazla TASK tarafından görülmesi |
| `ATOMIC` | Küçük skaler veriye yarışsız tek işlem erişimi      |
| `MUTEX`  | Bir kod/kaynak bölgesini aynı anda tek TASK'a açmak |

---

# 4. SHARED'ın en önemli özelliği: kendi kilidi olsun

Bence ayrı `GUARDED BY xyz` bürokrasisine girmeyelim.

Her:

```basic
DIM SHARED durum AS SensorState
```

değişkeninin çalışma zamanında kendisine ait **gizli bir mutex'i** olsun.

Böylece:

```basic
LOCK durum

    durum.temperature = 23.4
    durum.ph = 7.2

END LOCK
```

yeterli.

Bu modelin ciddi bir avantajı var:

> Hangi kilidin hangi değişkeni koruduğu belirsiz kalmıyor.

`durum` kendi verisini kendi kilidiyle koruyor.

---

# 5. SHARED veriye kilitsiz erişim yasak

Değiştirilebilir `SHARED` veri için:

```basic
PRINT durum.temperature
```

kilit dışında **derleme hatası** olmalı.

Doğrusu:

```basic
LOCK durum
    PRINT durum.temperature
END LOCK
```

Yazma da aynı:

```basic
LOCK durum
    durum.temperature = 24.1
END LOCK
```

Böylece uXBasic'in safe görev modelinde **data race oluşabilecek normal bir yol bırakmıyoruz**.

İleri düzey `UNSAFE` yolu daha sonra ayrıca tanımlanabilir. Çekirdek S-030 bunu gerektirmiyor.

---

# 6. Birden fazla SHARED veri tek işlemde kullanılabilir

Örneğin para aktarımı gibi:

```basic
LOCK hesapA, hesapB

    hesapA.balance -= miktar
    hesapB.balance += miktar

END LOCK
```

çalışma zamanı bunları kullanıcı yazdığı sırada körlemesine kilitlemesin.

İçeride:

```text
SharedId küçükten büyüğe sırala
↓
kilitleri sırayla al
↓
blok
↓
ters sırada bırak
```

olsun.

Böylece:

```basic
LOCK A, B
```

ile başka görevde:

```basic
LOCK B, A
```

yazılması klasik AB/BA deadlock'una dönüşmez.

Çalışma zamanı ikisini de aynı gerçek sıraya sokar.

---

# 7. İç içe kilitlerde de sıra zorunlu

Her `SHARED` veya `MUTEX` nesnesine bir:

```text
lockOrderId
```

verelim.

Bir TASK:

```text
id=20
```

kilidini tutarken:

```text
id=10
```

almaya çalışırsa beklemek yerine:

```text
LOCK_ORDER_VIOLATION
```

hatası versin.

Bu biraz katı ama çok değerlidir.

Programın sonsuza kadar donup kullanıcının “acaba nerede?” diye duvara bakması yerine açık hata alırız.

Aynı kilidi tekrar almak da ilk sürümde:

```text
SELF_DEADLOCK
```

olmalı.

Yani ilk sürüm mutex'leri **recursive olmayacak**.

---

# 8. LOCK blok yapısı olacak

Manuel:

```basic
LOCK m
...
UNLOCK m
```

istemiyorum.

Çünkü:

```basic
LOCK m
THROW "hata"
```

olunca insan `UNLOCK` yazmayı unutur. İnsanların en istikrarlı özelliklerinden biri temizlik kodunu unutmak.

Kanonik yapı:

```basic
LOCK m
    ...
END LOCK
```

olmalı.

Derleyici bunu:

```text
LOCK_ENTER
TRY
    ...
FINALLY
    LOCK_EXIT
END
```

mantığına indirmeli.

Dolayısıyla:

```basic
RETURN
THROW
EXIT FOR
EXIT DO
```

gibi yollar bloktan çıkarken kilidi bırakır.

`GOTO` ile LOCK içine veya dışına atlamak ise **derleme hatası** olmalı.

---

# 9. CANCEL ile LOCK ilişkisi

Bu çok önemli.

TASK kilit beklerken:

```basic
t.CANCEL()
```

gelirse bekleme iptal edilebilir.

Ama TASK kilidi aldıktan sonra:

```basic
LOCK durum

    durum.a = ...
    durum.b = ...

END LOCK
```

ortasında iptal edilmemeli.

Yoksa `a` güncellenmiş, `b` eski kalmış olabilir.

Dolayısıyla:

```text
LOCK dışında
    CANCEL işlenebilir

LOCK sırasında
    CANCEL pending kalır

END LOCK
    kilit bırakılır
    ardından CANCEL uygulanabilir
```

olsun.

Bu, kritik bölgenin atomik bütünlüğünü korur.

---

# 10. WAIT/JOIN kilit içindeyken yasak

Şunu:

```basic
LOCK durum
    t.JOIN()
END LOCK
```

ilk sürümde yasaklayalım.

Çünkü `t` görevindeki kod aynı `durum` kilidini bekliyorsa:

```text
ana görev kilidi tutuyor
↓
ana görev child bekliyor
↓
child aynı kilidi bekliyor
↓
sonsuz
```

olur.

Bu nedenle kilit altındayken:

```text
TASK.WAIT()
TASK.JOIN()
TASK.RESULT
TASKGROUP.JOIN()
```

engellensin.

`SPAWN` ise yapılabilir:

```basic
LOCK durum
    t = SPAWN Worker(...)
END LOCK
```

çünkü parent kilidi biraz sonra bırakacaktır.

---

# 11. ATOMIC ayrı bir sistem

Basit sayaç için:

```basic
DIM SHARED sayac AS I64
```

yazıp her seferinde kilit almak gereksiz.

Bunun için:

```basic
DIM ATOMIC sayac AS I64 = 0
```

olsun.

İlk sürümde desteklenen tipler:

| Tip                            | ATOMIC            |
| ------------------------------ | ----------------- |
| BOOLEAN                        | evet              |
| I8/U8                          | evet              |
| I16/U16                        | evet              |
| I32/U32                        | evet              |
| I64/U64                        | evet              |
| ENUM, uygun tamsayı tabanlıysa | evet              |
| F32/F64                        | ilk sürümde hayır |
| STRING                         | hayır             |
| PTR                            | ilk sürümde hayır |
| CLASS/LIST/DICT                | hayır             |

F32/F64 teorik olarak yapılabilir ama JS/WASM/native arasında düzgün tek sözleşme kurmak için şimdilik gereksiz yük.

---

# 12. ATOMIC bellek sırası

Kullanıcıya:

```text
RELAXED
ACQUIRE
RELEASE
SEQ_CST
```

gibi ayrıntıları ilk sürümde açmayalım.

Bütün atomik işlemler:

> **Sequentially Consistent, yani tek küresel tutarlı atomik sıra**

olsun.

Bunun büyük avantajı:

* C++ `std::atomic` destekler,
* JavaScript `Atomics` modeliyle uyumludur,
* WASM atomikleriyle iyi örtüşür.

İleri düzey bellek sıraları gelecekte eklenebilir.

---

# 13. ATOMIC kullanım şekli

Normal okuma:

```basic
DIM x AS I64

x = sayac
```

atomik LOAD anlamına gelsin.

Normal atama:

```basic
sayac = 100
```

atomik STORE olsun.

Bileşik işlemler:

```basic
sayac += 1
sayac -= 1
```

tek atomik read-modify-write işlemine indirilsin.

Ama:

```basic
sayac = sayac + 1
```

tehlikeli.

Bu iki ayrı atomik işlem olur:

```text
LOAD
ADD local
STORE
```

ve iki TASK birbirinin artışını kaybedebilir.

Ben bunun derleme zamanı reddedilmesini isterim:

```text
HATA: ATOMIC 'sayac' üzerinde read-modify-write
ifadesi atomik değildir; += veya ADD() kullanın.
```

İleri işlemler için pseudo-metotlar olabilir:

```basic
sayac.LOAD()
sayac.STORE(10)
sayac.ADD(1)
sayac.SUB(1)
sayac.EXCHANGE(0)
sayac.COMPAREEXCHANGE(10, 11)
```

`COMPAREEXCHANGE` BOOLEAN dönsün.

---

# 14. MUTEX nerede gerekli?

`SHARED` zaten kendi kilidine sahip olduğundan sıradan veri için ayrıca MUTEX gerekmiyor.

`MUTEX` şu tip durumlar için:

```basic
DIM dllLock AS MUTEX

LOCK dllLock
    CALL SomeUnsafeDll(...)
END LOCK
```

veya:

```basic
LOCK consoleTransaction
    PRINT ...
    PRINT ...
    PRINT ...
END LOCK
```

gibi **veri dışında bir kaynağı veya birden fazla işlemi** tek kritik bölge yapmak için kullanılır.

Ancak şu önemli:

```basic
LOCK dllLock
    sharedData.x = 10
END LOCK
```

tek başına `sharedData`ya erişim hakkı vermez.

`sharedData` için yine kendi kilidi gerekir.

Böylece farklı mutex'ler kullanarak yanlışlıkla aynı veriyi “koruduğunu sanma” problemi oluşmaz.

---

# 15. SPAWN parametrelerinin son modeli

Bugünkü kaynakta BYVAL snapshot var ve BYREF yasak. Bu doğru başlangıç.

Son model şöyle olsun:

| Parametre türü           | SPAWN                                       |
| ------------------------ | ------------------------------------------- |
| BOOLEAN / sayısal skaler | BYVAL kopya                                 |
| STRING                   | güvenli değer/snapshot                      |
| sabit boyutlu saf TYPE   | bütün alanları gönderilebilirse kopya       |
| TASK                     | tutamaç kopyası                             |
| TASKGROUP                | tutamaç kopyası                             |
| MUTEX                    | aynı mutex'e referans veren güvenli tutamaç |
| normal CLASS             | varsayılan yasak                            |
| LIST/DICT/SET            | varsayılan yasak                            |
| PTR                      | varsayılan yasak                            |
| dizi                     | ilk sürümde yasak                           |
| SHARED veri              | ileride açık shared-ref parametresi         |
| kütüphane tipi           | descriptor karar verir                      |

Burada “BYVAL” bir pointer/handle'ın kör kopyalanması anlamına gelmemeli.

---

# 16. Yeni `BYSHARED` parametre modu

MemoryRef ve paylaşılan runtime olgunlaşınca şu sözdizimini ekleyelim:

```basic
THREAD Process(BYSHARED buffer() AS F64)
```

Çağrı:

```basic
DIM SHARED samples(999) AS F64

t = SPAWN Process(samples)
```

Buradaki `BYSHARED`:

> aynı mantıksal SHARED nesneyi görev sınırından geçir

demek.

`BYREF` ile farkı:

```text
BYREF
    sıradan çağrı için lvalue alias
    caller ömrüne bağlı

BYSHARED
    runtime-managed SharedHandle
    refcount/pin ile ömrü garanti
    TASK sınırından geçebilir
```

Dolayısıyla **BYREF'i asenkron görev için kurtarmaya çalışmayalım**. `BYSHARED` daha temiz bir kavram olur.

---

# 17. Dizi paylaşımı

Örneğin:

```basic
DIM SHARED data(999999) AS F64
```

tek bir paylaşılan bölge olur.

TASK:

```basic
LOCK data

    data(100) = 3.14

END LOCK
```

kullanır.

Daha iyi paralellik için tüm milyon elemanlık diziyi tek kilitle korumak bazen pahalıdır.

Bu yüzden ileri aşamada **dilim kilidi** de tasarlanabilir:

```basic
LOCK data(1000 TO 1999)
    ...
END LOCK
```

ama Faz 2 için bütün dizi tek kilit yeterli.

Önce doğru, sonra akıllı. Bilgisayar mühendisliği tarihinin yarısı bunun tersini yapıp ardından konferans düzenlemekten oluşuyor.

---

# 18. REDIM ve SHARED dizi

SHARED dizi için:

```basic
REDIM data(...)
```

yalnız:

```basic
LOCK data
    REDIM data(...)
END LOCK
```

içinde yapılabilsin.

Mantıksal `SharedHandle` değişmez.

Ama:

```text
eski backing base address
        ↓
RELEASED MemoryRef
        ↓
yeni backing base
        ↓
aynı SharedHandle, yeni MemoryRef generation
```

olur.

Bu çok önemli.

TASK'lar ham adresi değil SharedHandle'ı taşıdığı için REDIM'den sonra da aynı mantıksal diziye ulaşabilir.

Ham eski `PTR` ise stale sayılır.

---

# 19. MemoryRef'i S-030 için büyütmemiz gerekiyor

Bugünkü MemoryRef mantığı doğru çekirdeğe sahip. Fakat gerçek eşzamanlılık için kayıt şöyle büyümeli:

```text
MemoryRegion
    baseAddress
    byteLength

    kind
    memoryClass
    origin

    ownerId
    sharedId

    generation
    state

    readable
    writable

    elementSize
    elementStride
    elementCount

    sharingMode

    lockId
    refCount
    pinCount
```

`sharingMode` örneğin:

```text
LOCAL
SHARED_LOCKED
SHARED_IMMUTABLE
ATOMIC
EXTERNAL
```

olabilir.

---

# 20. Bugünkü MemoryRef'te değiştirilmesi gereken iki kritik şey

Mevcut:

```text
UXB_MEMREF_MAX = 4096
```

uzun vadede gerçek concurrent runtime için gereksiz sabit sınır.

Dinamik bölge tablosuna geçmeli.

Daha önemlisi:

```text
gUxbMemRefLastError
```

global.

Bu mutlaka:

```text
TaskExecutionContext.memoryError
```

veya ev sahibi thread'in yerel hata alanına taşınmalı.

Aksi halde:

```text
TASK A → stale pointer hatası
TASK B → başka pointer işlemi
```

aynı global hata metnini birbirinin üzerinden ezer.

---

# 21. VARPTR/PTR için kesin kural

İlk güvenli sürümde:

```basic
VARPTR(sharedData)
VARPTR(atomicData)
```

reddedilsin.

Çünkü raw pointer çıkınca kilit, generation, sahiplik gibi bütün güzel güvenlik tasarımını tek satırda pencereden atmış oluruz.

İleride kontrollü bir:

```basic
PIN sharedData
    p = VARPTR(sharedData)
    CALL(DLL, ..., p)
END PIN
```

benzeri kapsamlı sabitleme modeli düşünülebilir.

`PIN` süresince:

* nesne kilitli,
* backing storage taşınamaz,
* REDIM yasak,
* pointer geçerli.

Ama bu **S-030 Faz 2'nin şartı değil**.

---

# 22. PEEK/POKE/MEMCOPY ile SHARED

Doğrudan isim üzerinden çalışan bellek komutları:

```basic
MEMCOPY ...
MEMFILL ...
```

bir SHARED bölgeyi hedefliyorsa o bölgenin kilidinin tutulduğunu kontrol etmeli.

Örneğin:

```basic
LOCK buffer
    MEMFILL buffer, 0, 4096
END LOCK
```

geçerli.

Kilitsiz:

```basic
MEMFILL buffer, 0, 4096
```

hata.

Raw EXTERNAL/NATIVE pointer için ise uXBasic'in garanti alanı dışında kalır.

Bu ayrım MemoryRef'in `origin` alanıyla doğal biçimde çözülebilir.

---

# 23. CLASS nesneleri

Normal:

```basic
DIM obj AS MyClass
```

TASK sınırından geçirilmez.

Paylaşılmak istenirse:

```basic
DIM SHARED obj AS MyClass
```

olur.

Metot:

```basic
LOCK obj
    obj.Update()
END LOCK
```

ile çağrılır.

Ancak sınıf gerçekten immutable ise dış kilit gerekmeyebilir.

Burada mevcut `READONLY`, `MUTABLE`, `IMMUTABLE` altyapısı işe yarıyor. 23.09 parserı bu alan bayraklarını zaten tanıyor ve mevcut MIR/runtime `READONLY/IMMUTABLE` alanlara atamayı reddediyor.

Concurrency açısından ise anlamlarını daha net ayırmalıyız:

```text
READONLY
    alan binding'i değiştirilemez
    fakat işaret ettiği nesne mutable olabilir

IMMUTABLE
    değer ve transitif içeriği değişmez

MUTABLE
    normal değiştirilebilir alan
```

Bugün kod `READONLY` ile `IMMUTABLE`ı büyük ölçüde aynı “yazılamaz alan” gibi kullanıyor. Eşzamanlılık geldiğinde **IMMUTABLE'a daha güçlü anlam vermeliyiz**.

---

# 24. Kütüphane sınıf tipleri burada nereye oturuyor?

Tam önce sorduğun konuya da burada bağlanıyoruz.

JS/WASM planımız birinci sınıf kütüphane tipini:

```text
Type descriptor
MAGIC / OPERATOR
lifecycle
ABI
provider
```

üzerinden taşımayı zaten hedefliyor. 

Bu descriptor'a artık eşzamanlılık özellikleri de eklenmeli:

```text
taskTransfer
threadSafety
clone
retain
release
sharedPolicy
```

Önerdiğim değerler:

| Alan             | Olası değer                                                       |
| ---------------- | ----------------------------------------------------------------- |
| `taskTransfer`   | `FORBID`, `COPY`, `RETAIN`, `SHARE`                               |
| `threadSafety`   | `NONE`, `IMMUTABLE`, `INTERNAL`, `EXTERNAL_LOCK`, `THREAD_AFFINE` |
| `clone`          | kopyalama callback'i                                              |
| `retain/release` | yaşam süresi callback'leri                                        |
| `sharedPolicy`   | ortak kullanım politikası                                         |

Örneğin `RATIONAL`:

```text
immutable value
COPY
```

olabilir.

Bir `DATAFRAME`:

```text
mutable
EXTERNAL_LOCK
```

olabilir.

GPU bağlamı:

```text
THREAD_AFFINE
```

olabilir.

---

# 25. uxclz.dll için özel not

Mevcut `uxclz` çok iyi bir başlangıç:

* U64 generation-safe handle,
* retain/release,
* stale handle kontrolü,
* registry mutex,
* `thread_local` hata bufferları

zaten var.

Ama `uxclz_invoke` metodun payload'ını çağırmadan önce registry mutex'ini bırakıyor.

Bu bence **doğru**, çünkü bütün nesne metodunu tek küresel kilit altında çalıştırmak felaket olurdu.

Fakat sonucu şu:

> Bir uxclz nesnesinin aynı anda iki TASK tarafından kullanılabilir olup olmadığı type descriptor ile ayrıca belirtilmek zorunda.

`uxclz` için yeni flags eklenebilir:

```text
UXCLZ_TYPE_IMMUTABLE
UXCLZ_TYPE_THREADSAFE
UXCLZ_TYPE_TASK_SENDABLE
UXCLZ_TYPE_THREAD_AFFINE
```

Mevcut:

```text
CLASS
INTERFACE
VALUE
ENTITY
COMPONENT
ACTOR
NATIVE
ABSTRACT
```

bayraklarının yanına oturur.

---

# 26. LIST / DICT / SET

Bunlar varsayılan olarak mutable handle türleri.

Dolayısıyla:

```basic
THREAD Worker(items AS LIST)
```

SPAWN altında ilk aşamada reddedilmeli.

Gelecekte:

```basic
DIM SHARED items AS LIST
```

desteklenebilir.

O zaman:

```basic
LOCK items
    LISTADD(items, 42)
END LOCK
```

çalışır.

Fakat JS/WASM'da bunu doğrudan JavaScript `Map` veya `Array` davranışına teslim etmeyelim. Zaten yüzey matrisimiz koleksiyonların kanonik uXBasic protokolüyle taşınmasını şart koşuyor. 

---

# 27. TASK ve TASKGROUP kendileri thread-safe olmalı

`TASK` zaten çalışma zamanı nesnesi.

Dolayısıyla:

```basic
THREAD Watcher(t AS TASK)
```

gibi kullanım ileride izinli olabilir.

TASK'ın:

```text
STATUS
RESULT
ERRORTEXT
CANCEL
WAIT/JOIN
```

alanları kendi iç eşzamanlılığını sağlayacak.

`TASKGROUP` da thread-safe olabilir ama önemli bir kural koyuyorum:

```text
OPEN
↓
ADD yapılabilir
↓
JOIN çağrıldı
↓
SEALED
↓
artık ADD yasak
```

Yani:

```basic
g.ADD(t1)
g.ADD(t2)

g.JOIN()

g.ADD(t3)    ' HATA
```

Bu, JOIN sırasında grup üyelerinin değişmesi karmaşasını ortadan kaldırır.

---

# 28. TASK başlangıç ve bitiş bellek garantileri

Bu da dil sözleşmesinin parçası olmalı.

`SPAWN`:

```text
parent'ın SPAWN öncesindeki
izinli paylaşılan yazıları
↓
child başlangıcında görünür
```

`JOIN`:

```text
child'ın tamamlanmadan önceki
izinli paylaşılan yazıları
↓
JOIN döndükten sonra parent'a görünür
```

`LOCK`:

```text
UNLOCK öncesi yazılar
↓
aynı lock'u sonra alan TASK tarafından görülür
```

`ATOMIC` ise seq-cst düzeninde görünür.

Böylece yalnız “kilit var” demiyoruz, **görünürlük sözleşmesi** de tanımlıyoruz.

---

# 29. Derleyici task-safe analizi yapmalı

THREAD/PARALEL gövdesi için yeni semantic analiz:

```text
task capture/effect analysis
```

olmalı.

Derleyici her SPAWN edilebilir routine için:

| Erişim                            | Karar             |
| --------------------------------- | ----------------- |
| yerel değişken                    | serbest           |
| BYVAL parametre                   | serbest           |
| CONST                             | serbest           |
| normal mutable global             | hata              |
| ATOMIC global                     | serbest           |
| SHARED global, doğru LOCK altında | serbest           |
| SHARED global, kilitsiz           | hata              |
| raw PTR global                    | hata              |
| thread-safe library type          | descriptor'a göre |
| thread-affine nesne               | hata              |

kontrolü yapmalı.

---

# 30. Yalnız doğrudan gövdeyi kontrol etmek yetmez

Örneğin:

```basic
SUB Helper()
    globalX += 1
END SUB

THREAD Worker()
    Helper()
END THREAD
```

Worker'ın kendi gövdesinde `globalX` görünmüyor.

Bu yüzden semantic analiz **çağrı zincirini** de incelemeli.

Her yordam için bir “etki özeti” üretilebilir:

```text
PURE
LOCAL_ONLY
READS_SHARED
WRITES_SHARED
USES_ATOMIC
USES_RAW_PTR
CALLS_UNSAFE_FFI
BLOCKS
SPAWNS
```

Sonra Worker'ın transitive etkisi çıkarılır.

Bu ileride optimizer için bile faydalı olur.

---

# 31. DLL/API çağrıları

Dış kütüphanenin thread-safe olup olmadığını derleyici kendiliğinden bilemez.

Bu nedenle library manifest/type descriptor:

```text
threadSafe = true/false
threadAffine = true/false
requiresExternalLock = true/false
```

taşımalı.

Bilinmeyen FFI fonksiyonu:

```text
TASK-safe olduğu varsayılmasın.
```

İlk geçişte warning olabilir, strict modda error.

Örneğin:

```basic
LOCK dllMutex
    CALL(DLL, ...)
END LOCK
```

ile kullanıcı açıkça serialize edebilir.

---

# 32. Gizli runtime global'leri de denetlenmeli

Sadece kullanıcı global değişkenleri yetmez.

Gerçek Faz 2 öncesinde şu tür runtime durumları envanterlenmeli:

```text
MemoryRef last error
RND/random state
ERR/error state
temporary string buffers
collection registries
object registries
file table
task tables
PRINT buffers
DLL error buffers
```

Her biri:

```text
TASK_LOCAL
THREAD_LOCAL
LOCKED_GLOBAL
IMMUTABLE
```

sınıflarından birine atanmalı.

Örneğin mevcut `uxclz` hata tamponlarını zaten `thread_local` yapmış. Bu güzel bir örnek.

---

# 33. Yeni çalışma zamanı kayıtları

Ben ortak runtime'da kabaca şu ayrımı isterim:

```text
SharedRecord
    generation
    typeId
    storageKind
    flags

    data
    byteLength
    stride

    lockId
    refCount
    pinCount

    memoryRegionId
```

```text
MutexRecord
    generation
    ownerTaskId
    lockOrderId
    state
    waiterQueue
```

```text
TaskExecutionContext
    taskId

    locals
    result
    error

    cancelRequested

    heldLocks[]
    pendingCancellation

    memoryError
```

Bu sonuncusu özellikle önemli. Task'a özel hata ve kilit durumu burada tutulur.

---

# 34. Tutamaçlar U64 generation-safe olsun

TASK'ta konuştuğumuz modelin aynısını:

```text
high 32 bit = generation
low 32 bit  = slot/index
```

SHARED ve MUTEX için de kullanabiliriz.

Yani:

```text
SharedHandle
MutexHandle
TaskHandle
ObjectHandle
```

aynı genel güvenli handle felsefesine sahip olur.

Bu, uxclz'in mevcut generation-safe modeline de uyuyor.

---

# 35. MIR sözleşmesi

S-030 TASK opcode'larının yanına paylaşılan veri işlemleri gelmeli.

| MIR işlemi          | Görevi                  |
| ------------------- | ----------------------- |
| `SHARED_CREATE`     | paylaşılan hücre/bölge  |
| `SHARED_LOAD`       | kilit doğrulamalı okuma |
| `SHARED_STORE`      | kilit doğrulamalı yazma |
| `SHARED_RETAIN`     | yaşam süresi artır      |
| `SHARED_RELEASE`    | yaşam süresi azalt      |
| `LOCK_ENTER`        | kilit/kilitleri al      |
| `LOCK_EXIT`         | bırak                   |
| `MUTEX_CREATE`      | açık mutex              |
| `ATOMIC_LOAD`       | atomik oku              |
| `ATOMIC_STORE`      | atomik yaz              |
| `ATOMIC_ADD/SUB`    | atomik RMW              |
| `ATOMIC_AND/OR/XOR` | bit atomik işlemleri    |
| `ATOMIC_EXCHANGE`   | değiştir                |
| `ATOMIC_CAS`        | compare-exchange        |

Bellek sırası ilk sürümde opcode parametresi olarak bile taşınabilir ama değer daima:

```text
SEQ_CST
```

olur.

İleride dili bozmadan genişletilebilir.

---

# 36. Native x64

Native Faz 2'de:

```text
ATOMIC
→ std::atomic / platform interlocked

SHARED lock
→ std::mutex

TASK scheduler
→ mevcut runtime + worker pool

PARALEL
→ oneTBB

THREAD / event işi
→ libuv/runtime worker hattı
```

şeklinde uygulanabilir.

Burada uXBasic kaynak semantiği bu DLL'lere bağlı olmamalı.

libuv/TBB yoksa başka provider aynı MIR sözleşmesini uygulayabilir.

---

# 37. JavaScript

JS'de sıradan Worker'lar normal nesne belleğini paylaşmaz.

Bu yüzden:

```text
ATOMIC fixed integers
→ SharedArrayBuffer + Atomics

SHARED fixed scalar/array/TYPE
→ SharedArrayBuffer + descriptor

LOCK
→ Atomics tabanlı mutex
```

olabilir.

STRING/CLASS/LIST/DICT/library object için doğrudan JavaScript object paylaşımı yapılmaz.

Bunlar ya:

```text
provider
message-based service
shared runtime representation
```

kullanır ya da açık desteklenmiyor hatası verir.

Sessiz kopyalama yapıp “shared”mış gibi davranmak yasak.

---

# 38. WASM

WASM threads varsa:

```text
shared linear memory
+
WASM atomic operations
```

aynı sözleşmeyi uygular.

Yoksa:

```text
HOST_PROVIDER_REQUIRED
```

gibi açık hata.

Gerçek paralellik yokken “çalışmış gibi” tek thread'e düşürmek S-030'un son hedefinde kabul edilmemeli.

---

# 39. Ne zaman özellik “taşınabilir” kabul edilecek?

Ben şu minimum ortak kümeyi isterim:

```text
I32/I64/U32/U64/BOOLEAN ATOMIC
SHARED scalar
SHARED fixed TYPE
SHARED array
MUTEX
LOCK
TASK-safe snapshot passing
```

bunlar x64 + JS Worker + WASM worker/shared-memory modellerinde aynı gözlenebilir semantiğe sahip olduğunda temel shared-data sistemi tamamlanmış sayılır.

CLASS/LIST/DICT/library type paylaşımı ikinci katman olabilir.

---

# 40. S-030 Faz 2'yi bloke etmeden uygulanacak sıra

Burada önemli bir pratik karar var.

Bütün SHARED sisteminin bitmesini bekleyip sonra gerçek THREAD yapmak gereksiz.

İşi iki aşamaya bölelim:

### S-030 Faz 2A: Güvenli izolasyon

Önce gerçek worker pool yapılır fakat:

```text
mutable global → yasak
BYREF → yasak
array → yasak
CLASS/LIST/DICT/PTR → yasak
```

Yalnız güvenli BYVAL veriler geçer.

Bu haliyle gerçek native concurrency güvenlidir.

### S-030 Faz 2B: Paylaşılan veri ailesi

Sonra:

```text
ATOMIC
SHARED
MUTEX
LOCK
MemoryRef integration
```

eklenir.

Bu ayrım bence çok önemli. Yoksa S-030'u başka devasa bir projeye bağlayıp yine aylarca “önce altyapı” diye dolaşırız.

---

# Son mimari

Bunu artık tek resimde şöyle görüyorum:

```text
                    uXBasic TASK MODELİ

               SPAWN Worker(args)
                       │
                       ▼
                    TASK
                       │
        ┌──────────────┴──────────────┐
        │                             │
   özel/private veri             paylaşılan veri
        │                             │
   BYVAL snapshot              ┌──────┴───────┐
   local variables             │              │
   task-local state          ATOMIC         SHARED
                               │              │
                         küçük skaler       nesne/bölge
                         tek işlem          açık LOCK
                               │              │
                               └──────┬───────┘
                                      ▼
                                  MemoryRef
                                      │
                      base/length/generation/origin
                      lifetime/share/lock metadata
                                      │
               ┌──────────────────────┼────────────────────┐
               ▼                      ▼                    ▼
             x64                     JS                   WASM
        std::atomic/mutex     SAB + Atomics       shared linear memory
```

Ve kütüphane tipi bunun dışında değil, aynı modele giriyor:

```text
Library Type Descriptor
        │
        ├─ COPY?
        ├─ SHARE?
        ├─ IMMUTABLE?
        ├─ THREADSAFE?
        ├─ THREAD_AFFINE?
        ├─ retain/release
        └─ clone
```

Bence **bu tasarımı S-030'un “paylaşılan veri sözleşmesi” olarak kilitlemek doğru olur**. En kritik kararlar da şunlar: normal görevler izole, `ATOMIC` küçük skalerler için, `SHARED` kendi kilidine sahip, `LOCK ... END LOCK` yapılandırılmış, BYREF asenkron görevlerde kullanılmıyor ve daha sonra açık `BYSHARED` geliyor, MemoryRef ise bütün bunların native bellek yaşam süresi omurgasına dönüşüyor.





Evet, **öz olarak doğru**, ama bir cümleyi daha kesinleştirirdim. 23.09 kaynağında `TRIGGER Hedef` kısa biçimi gerçekten AST düğümünün `value` alanına içsel olarak `"TASK"` yazıyor:

```freebasic
nodeIdx = MakeNodeFromToken(ps, "TRIGGER_STMT", "TASK", "TRIGGER", firstTok)
```

ve bu `"TASK"` burada **kullanıcı tipi olan `TASK` anlamına gelmiyor**. Anlamı:

> “TRIGGER türü henüz açıkça belirtilmedi; hedefin gerçek türünü sonraki semantik/çalışma zamanı çözümlemesi belirlesin.”

Bu davranış kaynakta açıkça var. `ParseTriggerStmt` kısa biçimi `TRIGGER Hedef[, veri...]` olarak açıklıyor ve yalnız `EVENT/PIPE/THREAD/PARALEL` açık türlerinden biri yazılmadığında `"TASK"` iç etiketi oluşturuyor.

Downstream de bunu tam bu anlamda kullanıyor. Runtime tarafında:

```freebasic
If triggerKind = "" Or triggerKind = "TASK" Then
    ...
End If
```

ile `"TASK"` özel “henüz genel/generic görev türü” işareti olarak ele alınıyor. Semantik kontrol de `"TASK"` değerini `EVENT/THREAD/PARALEL/PIPE` yanında geçerli bir **iç trigger-kind** olarak kabul ediyor.

Ama şu kısmı biraz düzeltelim:

> “Kullanıcı `TRIGGER TASK` yazmaz.”

**Dil tasarımı ve belgelenmiş sözdizimi açısından doğru.** Açık biçimler şunlar:

```basic
TRIGGER EVENT Hedef
TRIGGER PIPE Hedef
TRIGGER THREAD Hedef
TRIGGER PARALEL Hedef
```

ve kısa biçim:

```basic
TRIGGER Hedef
```

Fakat mevcut parser teknik olarak `TASK` artık bir `KEYWORD` olduğu için şu metni de tamamen ilk aşamada engellemiyor:

```basic
TRIGGER TASK
```

Bunu kısa biçimde hedef adı `TASK` gibi ayrıştırmaya girişebilir. Yani `"TRIGGER TASK"` için özel bir “bu kullanıcı sözdizimi yasaktır” parser kontrolü şu anda görmedim. Sonraki çözümleme büyük olasılıkla hedef bulamadığı için hata verir.

Bu yüzden deftere en doğru ifade şu olur:

> **Not (`TRIGGER` iç `TASK` etiketi):** Kullanıcı yüzeyinde `TRIGGER TASK ...` adlı ayrı bir sözdizimi yoktur. `TRIGGER Hedef[, ...]` kısa biçiminde parser, `TRIGGER_STMT.value` alanına içsel olarak `"TASK"` yazar. Bu değer “görev türü henüz açıkça belirtilmedi, hedef/SLOT çözümlemesinden belirlenecek” anlamındadır ve `TASK` kullanıcı veri tipiyle aynı kavram değildir. Açık kullanıcı biçimleri yalnız `TRIGGER EVENT`, `TRIGGER PIPE`, `TRIGGER THREAD`, `TRIGGER PARALEL` ve türsüz `TRIGGER Hedef` biçimleridir. Mevcut parserda literal `TRIGGER TASK` için ayrıca özel erken-yasak kontrolü yoktur; bunu dil yüzeyinin parçası kabul etmemek gerekir.

Kısacası: **çakışma kavramsal değil, yalnız aynı metin `"TASK"` iki farklı iç bağlamda kullanılıyor.** Yeni `TASK` tipini sırf bu yüzden yeniden adlandırmaya gerek yok.


Evet Mete abi, **uyuşuyor ve hatta son planımızdaki ayrımı daha da netleştiriyor.** Buradaki kritik nokta şu: aynı `"TASK"` yazısı kaynak içinde iki yerde görünse de **iki tamamen farklı katmana ait**.

Bizim yeni planımızda kullanıcı düzeyindeki görev modeli:

```basic
DIM t AS TASK
t = SPAWN Worker(100)

t.WAIT()
PRINT t.RESULT
```

Buradaki `TASK`, **bir çalışma örneğinin opak tutamacı**. Yani gerçek bir dil tipi.

Eski `TRIGGER` sistemindeki iç `"TASK"` ise:

```basic
TRIGGER Worker
```

yazıldığında parserın kendi içinde tuttuğu:

```text
triggerKind = "TASK"
```

işareti. Bunun anlamı sadece:

```text
EVENT mi?
PIPE mı?
THREAD mi?
PARALEL mi?

Henüz bilmiyorum.
SLOT/target çözümlemesinde belirle.
```

Dolayısıyla bizim mimarimizle ilişki şöyle:

```text
ESKİ / UYUMLULUK HATTI

TRIGGER Worker
      │
      ▼
internal kind = "TASK"
      │
      ▼
SLOT / target çözümleme
      │
      ├─ EVENT
      ├─ PIPE
      ├─ THREAD
      └─ PARALEL
```

Buna karşılık yeni sistem:

```text
YENİ ÇALIŞTIRMA MODELİ

SPAWN Worker(...)
      │
      ▼
yeni çalışma örneği
      │
      ▼
TASK handle
      │
      ├─ .STATUS
      ├─ .RESULT
      ├─ .WAIT()
      ├─ .JOIN()
      ├─ .CANCEL()
      └─ .ERRORTEXT
```

Bunlar birbirine karışmıyor.

## Hatta önceki kararlarımızdan birini doğruluyor

Biz özellikle:

```text
SLOT/TRIGGER sistemi korunacak
SPAWN/TASK sistemi yeni async model olacak
```

demiştik.

Bu iç `"TASK"` etiketi de eski `TRIGGER` sisteminin parçası olduğu için aynen kalabilir.

Yani bunu:

```text
TASK tipiyle çakışıyor, değiştirelim
```

diye kurcalamamız gerekmiyor.

Çünkü kullanıcı hiçbir zaman şunu yazmıyor:

```basic
TRIGGER TASK Worker
```

kanonik dil sözdizimi olarak.

Kullanıcı ya:

```basic
TRIGGER Worker
```

ya da:

```basic
TRIGGER THREAD Worker
```

yazıyor.

---

## Planımızdaki `TASK` tanımı değişmiyor

Bizim kesinleşen tanımımız hâlâ:

> `TASK`, `SPAWN` sonucunda oluşan belirli çalışma örneğinin tutamacıdır.

Örneğin:

```basic
THREAD Worker(x AS I32)
    ...
END THREAD

DIM a AS TASK
DIM b AS TASK

a = SPAWN Worker(10)
b = SPAWN Worker(20)
```

Burada:

```text
Worker = görev tanımı

a = Worker'ın bir çalışma örneği
b = Worker'ın başka çalışma örneği
```

Bu `TASK`, parserın `TRIGGER_STMT.value = "TASK"` iç etiketinden tamamen bağımsız.

---

## SLOT ile de uyumlu

Eski:

```basic
SLOT
    WorkerSlot 3 ON THREAD Worker
END SLOT

TRIGGER WorkerSlot
```

şu mantıkta devam eder:

```text
TRIGGER
   ↓
SLOT çöz
   ↓
hedef THREAD Worker
   ↓
eski trigger/runtime yolu
```

Yeni gerçek görev yolu:

```basic
t = SPAWN Worker(100)
```

ise:

```text
SPAWN
  ↓
TaskRun oluştur
  ↓
TASK tutamacı döndür
```

Dolayısıyla bizim şu ayrımımız aynen korunuyor:

| Kavram               | Anlam                         |
| -------------------- | ----------------------------- |
| `THREAD Worker`      | görev tanımı                  |
| `SLOT WorkerSlot`    | bağlama/yönlendirme           |
| `TRIGGER WorkerSlot` | eski/uyumlu tetikleme         |
| `SPAWN Worker(...)`  | yeni çalışma örneği oluşturma |
| `TASK`               | bu çalışma örneğinin tutamacı |
| `TASKGROUP`          | birden çok TASK grubu         |

---

## Sadece küçük bir temizlik yapalım

Tasarım açısından sorun yok ama kaynak okunabilirliği açısından ileride iç etiketi `"TASK"` yerine daha açık bir dahili ad yapmak iyi olabilir.

Mesela:

```text
"AUTO"
"UNRESOLVED"
"GENERIC"
"SLOT_RESOLVE"
```

gibi.

Örneğin:

```freebasic
nodeIdx = MakeNodeFromToken(
    ps,
    "TRIGGER_STMT",
    "SLOT_RESOLVE",
    "TRIGGER",
    firstTok
)
```

Böylece kaynak kodu okuyan biri:

```text
TRIGGER kind = TASK
```

görüp yeni `TASK` tipimizle ilişkilendirmez.

Ama bu **zorunlu mimari değişiklik değil**. Yalnız iç kod temizliği.

Ben hatta bunu S-030 kapsamına sokmazdım. Çünkü çalışan eski TRIGGER davranışına dokunup gereksiz regresyon riski yaratmanın hiçbir getirisi yok.

## Son karar

Planımıza şu notu eklemek yeterli:

> **`TASK` iki farklı bağlamda geçen aynı metindir ancak aynı kavram değildir. Kullanıcı dilindeki `TASK`, SPAWN tarafından oluşturulan çalışma örneği tutamacıdır. `TRIGGER_STMT` içindeki `"TASK"` ise yalnız parser/runtime tarafından kullanılan, hedef türünün SLOT çözümlemesine bırakıldığını belirten eski dahili etikettir. Kullanıcı yüzeyinde `TRIGGER TASK ...` adlı ayrı bir komut yoktur. Bu nedenle S-030 `SPAWN/TASK/TASKGROUP` tasarımıyla kavramsal veya sözdizimsel bir çakışma bulunmamaktadır.**

Yani **evet, mevcut planla tamamen uyumlu**. Hatta `TRIGGER` ile `SPAWN`ı ayrı tutmamızın nedenlerinden birini daha açık hale getiriyor.


Evet, **eski sistem ve yeni sistem birlikte yaşayacak**. Burada komple bir dönüşüm yapmıyoruz. Asıl yaptığımız şey, senin sevdiğin `EVENT / PIPE / THREAD / PARALEL / SLOT / TRIGGER` sistemini koruyup, onun yanına eksik olan **“çalışan görevin kendisini takip etme”** katmanını eklemek.

23.09 kaynak kodunu tekrar bu gözle inceledim. En temiz resim şu.

# 1. Eski sistemi atmıyoruz

uXBasic'in özgün görev sistemi:

```text
EVENT
PIPE
THREAD
PARALEL
SLOT
TRIGGER
```

**kalıyor.**

Yeni eklenen:

```text
SPAWN
TASK
TASKGROUP
```

bunların yerine geçmiyor.

Şöyle düşün:

```text
                    GÖREV TANIMLARI
             ┌────────┬────────┬─────────┐
             │        │        │         │
           EVENT     PIPE    THREAD   PARALEL
             │        │        │         │
             └────────┴───┬────┴─────────┘
                          │
                 eski yönetim sistemi
                          │
                    SLOT + TRIGGER
                          │
                          │
                 ─────────────────
                          │
                  yeni çalışma modeli
                          │
                       SPAWN
                          │
                        TASK
                          │
                     TASKGROUP
```

Yani yeni sistem, eskisinin üzerine **çalıştırma örneği ve görev denetimi** ekliyor.

---

# 2. Neden yeni TASK sistemi gerekti?

Eski sistemde:

```basic
TRIGGER THREAD Worker, 100
```

dediğinde:

> Worker'ı çalıştır

diyorsun.

Ama sonra:

> Hangi Worker?
> Bitti mi?
> Sonucu ne?
> Hata verdi mi?
> İptal edebilir miyim?

sorularına doğrudan cevap verecek bir nesne yoktu.

Yeni sistem bunu sağlıyor:

```basic
DIM t AS TASK

t = SPAWN Worker(100)

PRINT t.STATUS
t.WAIT()
PRINT t.RESULT
PRINT t.ERRORTEXT
```

Buradaki:

```text
Worker = görev tanımı
t      = Worker'ın belirli bir çalışma örneği
```

Bu yüzden `TASK`, eski sistemin yerine geçen bir şey değil. **Eski sistemde eksik olan çalışma örneği kavramı.**

---

# 3. İki sistemin gelecekte aynı çalışma zamanı motoruna inmesi daha doğru

Faz 2 native gerçek eşzamanlılık geldiğinde benim önerdiğim birleşme şu:

```text
TRIGGER THREAD Worker, 100
              │
              ▼
       çalışma zamanı scheduler
              │
              ▼
          TaskRun oluştur
              │
              └── kullanıcı tutamacı istemediği için
                  TASK handle dışarı verilmez
```

Yeni yol:

```text
t = SPAWN Worker(100)
              │
              ▼
       aynı scheduler
              │
              ▼
          TaskRun oluştur
              │
              ▼
             TASK t
```

Yani içeride aynı motoru kullanabilirler.

Fark kullanıcı açısından:

```text
TRIGGER = çalıştır
SPAWN   = çalıştır ve bana o çalışmanın tutamacını ver
```

Bu çok temiz bir birleşme.

---

# 4. EVENT nedir?

`EVENT`, olay yordamıdır.

23.09 kaynakta tipli parametreleri vardır:

```basic
EVENT SensorChanged(sensorId AS I32, value AS F64)
    PRINT sensorId, value
END EVENT
```

Çağrılabilir:

```basic
TRIGGER EVENT SensorChanged, 4, 27.5
```

EVENT için `SPAWN` kullanılmaz.

23.09 semantik kontrolü açıkça `SPAWN` hedefinin yalnız:

```text
THREAD
PARALEL
```

olmasına izin veriyor.

Dolayısıyla:

```basic
t = SPAWN SensorChanged(...)
```

hata.

Bu doğru. EVENT'in işi “arka planda hesap başlat” değil, **olay bildirimi/işleme**.

---

# 5. EVENT + SLOT ilişkisi

Örneğin:

```basic
SLOT
    SensorSlot 1 ON EVENT SensorChanged
END SLOT
```

SLOT burada EVENT'in çalışma zamanı bağlantısını tutar.

Eski sistemin güzel taraflarından biri zaten buydu:

> görev tanımı ile görev yönlendirmesini birbirinden ayırmak.

Bunu kesinlikle kaybetmemeliyiz.

---

# 6. PIPE nedir?

`PIPE`, değer alan ve sonuç üreten **senkron veri dönüşüm yordamı**.

Bugünkü parserda dört görev türü içinde dönüş tipi alabilen tek yapı hâlâ PIPE:

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

Doğrudan:

```basic
x = Normalize(82.0)
```

kullanılabilir.

Eski TRIGGER yolu da vardır:

```basic
TRIGGER PIPE Normalize, 82.0
```

Fakat değer gerektiğinde normal PIPE çağrısı daha doğal.

Mevcut tipli görev sözleşmesi, `EVENT/PIPE/THREAD/PARALEL` için normal tipli parametreleri destekliyor ve `BYREF`i asenkron yaşam süresi çözülmediği için reddediyor.

---

# 7. TASKIN / TASKOUT nereye oturuyor?

Burası önceki konuşmalarımızda biraz karışmıştı, şimdi kaynak çok güzel ayırmış.

Mevcut kaynakta:

```text
TASKIN
TASKOUT
```

eski:

```text
TRIGGER
EVENT
PIPE
native SLOT ABI
```

uyumluluk hattında kalıyor.

23.09 `exec_task_handle.fbs` içinde özellikle yorumla belirtilmiş:

> Yeni `TASK` tutamacı `TASKIN/TASKOUT` sözde-global alanlarını yeniden kullanmaz.

Yani yeni görev sonucu:

```basic
t.RESULT
```

Eski görev uyumluluk sonucu:

```text
TASKOUT
```

Bunlar ayrı.

Bu çok doğru.

Dolayısıyla daha önce düşündüğümüz:

```basic
TASKOUT(t)
```

artık eklenmeyecek.

Kanonik yeni kullanım:

```basic
t.RESULT
```

---

# 8. THREAD nedir?

`THREAD`, bağımsız çalıştırılabilecek görev tanımıdır.

```basic
THREAD Worker(x AS I32)
    PRINT x
END THREAD
```

Eski kullanım:

```basic
TRIGGER THREAD Worker, 100
```

kalıyor.

Yeni kullanım:

```basic
DIM t AS TASK
t = SPAWN Worker(100)
```

geliyor.

Aradaki temel fark:

```text
TRIGGER THREAD
    → görev çalıştırma talebi

SPAWN
    → görev çalıştırma talebi + TASK tutamacı
```

---

# 9. THREAD şu anda gerçekten paralel mi?

Hayır, S-030'un AST Faz 1'inde henüz değil.

Kaynağın kendisi bunu dürüstçe söylüyor:

```text
SPAWN
→ gövde hemen aynı çağrı zincirinde çalışıyor
→ sonra TASK DONE veya ERROR olarak dönüyor
```

Bu bilinçli referans uygulaması.

Yani bugün AST'de:

```basic
t = SPAWN Worker(100)
```

döndüğünde Worker zaten bitmiş.

Faz 2 native geldiğinde aynı kaynak:

```basic
t = SPAWN Worker(100)
```

gerçekten:

```text
PENDING
RUNNING
DONE
```

durumlarından geçecek.

Kullanıcı sözdizimi değişmeyecek.

---

# 10. THREAD dönüş tipi konusunda önemli düzeltme

Daha önce konuşmada:

```basic
THREAD Square(x AS I32) AS I32
```

fikrini tartışmıştık.

**23.09 mevcut kaynak bunu desteklemiyor.**

Parser hâlâ:

> dönüş tipi yalnız PIPE için geçerli

diyor.

Dolayısıyla bunu “kararlaştırılmış uygulanmış özellik” olarak yazmamalıyız.

Yeni TASK sisteminde:

```basic
t.RESULT
```

var, fakat `THREAD ... AS T` şeklindeki **tipli görev sonucu bildirimi hâlâ açık tasarım konusu**.

Bunu S-030'un çekirdek Faz 2 işine zorla sokmak yerine ayrıca çözmek daha mantıklı.

---

# 11. PARALEL nedir?

`PARALEL`, paralel çalışma amacı taşıyan görev tanımıdır:

```basic
PARALEL AnalyzeBatch(firstRow AS I32, count AS I32)
    ...
END PARALEL
```

Eski:

```basic
TRIGGER PARALEL AnalyzeBatch, 0, 1000
```

kalıyor.

Yeni:

```basic
DIM t AS TASK
t = SPAWN AnalyzeBatch(0, 1000)
```

oluyor.

Burada daha önceki bir fikrimizi de düzeltmemiz gerekiyor:

> `PARALEL` otomatik olarak `TASKGROUP` döndürmeyecek.

23.09 kaynakta:

```text
SPAWN THREAD   → TASK
SPAWN PARALEL  → TASK
```

ikisi de `TASK`.

`TASKGROUP` ayrı kavram.

Bu mevcut koda daha temiz oturuyor.

---

# 12. TASKGROUP ne?

Birden fazla TASK tutamacını bir arada yönetmek için:

```basic
DIM grup AS TASKGROUP
DIM a AS TASK
DIM b AS TASK

a = SPAWN Worker(10)
b = SPAWN Worker(20)

grup.ADD(a)
grup.ADD(b)

grup.JOIN()
```

Bugünkü AST uygulamasında:

```text
.ADD()
.JOIN()
```

çalışıyor.

`JOINALL()` kaynakta bilerek:

```text
henüz desteklenmiyor
```

hatası veriyor.

Bunu doğru buluyoruz.

Sonuç koleksiyonunun tipi bütün motorlarda belirlenmeden acele etmiyoruz.

---

# 13. TASK'ın bugünkü yüzeyi

23.09 kaynakta gerçek kullanıcı yüzeyi:

| İşlem              | Anlam                                                  |
| ------------------ | ------------------------------------------------------ |
| `t.STATUS`         | görev durumu                                           |
| `t.RESULT`         | sonuç                                                  |
| `t.ERRORTEXT`      | görev hata metni                                       |
| `t.WAIT()`         | tamamlanmasını bekle                                   |
| `t.JOIN()`         | tamamlanmasını bekle ve hata/sonuç sözleşmesini uygula |
| `t.CANCEL()`       | iptal                                                  |
| `TASKGROUP.ADD(t)` | gruba ekle                                             |
| `TASKGROUP.JOIN()` | gruptaki görevleri bekle                               |

Durumlar kaynakta:

```text
PENDING
RUNNING
DONE
ERROR
CANCELLED
```

olarak mevcut.

---

# 14. SLOT ne olacak?

**Kalacak.**

Hatta eski sistemin korunmasında SLOT en önemli yapılardan biri.

Kanonik biçim:

```basic
SLOT
    SensorSlot  1 ON EVENT   SensorChanged
    NormSlot    2 ON PIPE    Normalize
    WorkerSlot  3 ON THREAD  Worker
    BatchSlot   4 ON PARALEL AnalyzeBatch
END SLOT
```

SLOT:

> çalışan görevin kendisi değildir.

SLOT:

```text
isim
id
ON/OFF
hedef türü
hedef görev
```

bağlantısını tutar.

0..255:

```text
256 slot
```

modeli devam ediyor.

---

# 15. SLOT ile TASK birbirine karıştırılmamalı

Örneğin:

```text
SLOT #3 → Worker
```

bir bağlamadır.

Ama:

```text
Task #8101 → Worker'ın bir çalışması
Task #8102 → Worker'ın başka çalışması
Task #8103 → Worker'ın başka çalışması
```

olabilir.

Dolayısıyla:

```text
1 SLOT
→ N tane TASK çalıştırması
```

mümkün.

İşte neden TASK'ı 256 ile sınırlamamamız gerektiğinin cevabı da burada.

---

# 16. Eski kısa SLOT biçimi konusu

23.09 kaynak hâlâ:

```basic
SLOT Worker ON
SLOT Worker OFF
```

kısa biçimini içeriyor.

Ama kaynakta bunun türü sabit:

```text
THREAD
```

olarak yazılmış.

Biz daha önce bunu **kaldırmaya karar verdik**.

Bu, SLOT sistemini kaldırmak değildir.

Yalnız hatalı/ambiguous bir kısa yazımı kaldırıyoruz.

Şunlar kalıyor:

```basic
SLOT ... END SLOT
ON THREAD Worker
OFF THREAD Worker
ON EVENT ...
OFF EVENT ...
```

ve diğer açık biçimler.

---

# 17. TRIGGER ne olacak?

**Kesinlikle kalacak.**

Kullanıcı:

```basic
TRIGGER SensorChanged
TRIGGER EVENT SensorChanged, 4, 23.5
TRIGGER THREAD Worker, 100
TRIGGER PARALEL AnalyzeBatch, 0, 100
```

yazmaya devam edebilecek.

23.09 runtime'ın ilginç bir gelişimi de şu:

Tipli/çok argümanlı görevler artık SLOT olmadan da normal yordam çerçevesi üzerinden doğrudan çağrılabiliyor. SLOT varsa ON/OFF ve native yönlendirme metası olarak devreye girebiliyor. Eski dar ABI ise yalnız uygun eski vakalarda kullanılıyor. Bu, eski sistemi atmak yerine onu modern tipli görevlerle uyumlu hale getiren doğru yaklaşım. Eski tipli görev tasarımında da SLOT'un doğrudan çağrı için zorunlu olmadığı belirtilmişti.

---

# 18. `TRIGGER` içindeki `"TASK"` nedir?

Konuştuğumuz gibi:

```basic
TRIGGER Worker
```

kısa biçiminde parser içerde:

```text
triggerKind = "TASK"
```

yazıyor.

Bu:

```text
kullanıcı TASK tipi
```

değil.

Anlamı yalnız:

> Tür açıkça yazılmadı, EVENT/PIPE/THREAD/PARALEL türünü sonraki çözümlemede bul.

Dolayısıyla:

```basic
DIM t AS TASK
```

ile bunun hiçbir kavramsal çatışması yok.

---

# 19. Eski TRIGGER ile yeni SPAWN'ın nihai ilişkisi

Bence bunu resmi kural haline getirelim:

| Kullanım            | Amaç                                      |
| ------------------- | ----------------------------------------- |
| `TRIGGER EVENT X`   | olayı tetikle                             |
| `TRIGGER PIPE X`    | eski/uyumluluk görev hattı                |
| `TRIGGER THREAD X`  | görevi başlat, tutamaç istemiyorum        |
| `TRIGGER PARALEL X` | paralel işi başlat, tutamaç istemiyorum   |
| `SPAWN X(...)`      | THREAD/PARALEL başlat ve TASK tutamacı al |

Yani `SPAWN`, TRIGGER'ı öldürmüyor.

**TRIGGER yönlendirme ve olay dünyasının komutu, SPAWN görev yaşam döngüsünü takip etmek isteyen programcının komutu.**

---

# 20. `DECLARE EVENT/THREAD/...` ne durumda?

Burada da kaynak ile planı ayıralım.

Biz konuşmada şu tasarımı beğenmiştik:

```basic
DECLARE EVENT E(...)
DECLARE PIPE P(...) AS F64
DECLARE THREAD W(...)
DECLARE PARALEL G(...)
```

Mantıklı.

Ama **23.09 parser bunu henüz desteklemiyor**.

Mevcut `DECLARE` yalnız:

```text
DECLARE SUB
DECLARE FUNCTION
```

bekliyor.

Dolayısıyla `DECLARE EVENT/PIPE/THREAD/PARALEL` şu anda **tasarım önerisi**, kaynak gerçeği değil.

Bunu sonradan ekleyebiliriz.

---

# 21. Birinci sınıf kütüphane tipi sistemi

Bu çalışma artık sadece fikir değil. 23.09 ZIP'te gerçek çekirdek kod var:

```text
src/semantic/library_type_contract.fbs
src/semantic/library_type_manifest_io.fbs
src/interpreter/mir/mir_interp_library_type.fbs
manifests/library_types/...
```

Amaç:

> Yeni bir matematiksel veya bilimsel tipi her seferinde compiler primitive'i yapmamak.

Yani `RATIONAL`, `COMPLEX`, `POLYNOMIAL`, ileride başka tipler:

```text
lexer/parsera özel hardcode
```

yerine descriptor/manifest üzerinden geliyor.

Bu JS/WASM planımızda da açıkça “type descriptor + MAGIC/OPERATOR + lifecycle + ABI” modeli olarak tanımlanmıştı. 

---

# 22. Kütüphane tipi descriptor bugün neler taşıyor?

23.09 kaynakta `UXBLibraryTypeContract` yaklaşık olarak şunları taşıyor:

```text
typeName
packageName

layoutKind
sizeBytes
alignBytes
fields

operators
magic
conversions
lifecycle

storageModel
copyModel
cloneModel
dropModel

abiPolicy

mirPolicy
mirProvider

jsPolicy
jsProvider

wasmPolicy
wasmProvider

nativePolicy
nativeProvider

status
```

Bu çok önemli bir gelişme.

Yani tip yalnız:

```text
adı = RATIONAL
```

demiyor.

Aynı zamanda:

> nasıl saklanır, nasıl kopyalanır, nasıl silinir, hangi operatörleri var, MIR bunu nasıl çalıştırır, JS ne yapar, WASM ne yapar, native ne yapar

diyor.

---

# 23. RATIONAL bugün referans tip

23.09 kaynakta `RATIONAL` için gerçek referans contract var.

Operatörler:

```text
ADD
SUB
MUL
DIV

EQ
NE
LT
LE
GT
GE
CMP
```

MAGIC:

```text
TOSTRING
CLONE
HASH
```

Yaşam döngüsü:

```text
CONSTRUCT
NORMALIZE
COPY
CLONE
```

ve depolama:

```text
VALUE
BITCOPY
```

modelinde.

MIR yorumlayıcıda `RATIONAL_REFERENCE` sağlayıcısı da gerçek kodla mevcut ve toplama, çıkarma, çarpma, bölme ve karşılaştırmaları yapıyor.

Yani bu çalışma “ileride yapılacak” değil, **ilk gerçek örneğine ulaşmış durumda**.

---

# 24. Ama COMPLEX/POLYNOMIAL henüz aynı seviyede değil

Hedef sıramız:

```text
RATIONAL
   ↓
COMPLEX
   ↓
POLYNOMIAL
```

idi.

JS/WASM tasarım belgesi de bunu açık kabul dizisi olarak tutuyor. 

23.09 ZIP'te tam manifest/provider referansı gördüğüm tip `RATIONAL`.

Dolayısıyla:

```text
birinci sınıf library type mimarisi = var
RATIONAL reference = var
COMPLEX/POLYNOMIAL tam provider = henüz tamamlandı diyemem
```

şeklinde kaydetmeliyiz.

---

# 25. Kütüphane tipi neden çok önemli?

Bu sayede ileride:

```basic
DIM a AS RATIONAL
DIM b AS RATIONAL
DIM c AS RATIONAL

c = a + b
```

compiler:

```text
"+" gördüm
↓
RATIONAL descriptor'a bak
↓
ADD var mı?
↓
MIR/library provider çağır
```

yapabilir.

Yani:

```text
RATIONAL.ADD
COMPLEX.ADD
MATRIX.MUL
POLYNOMIAL.DIV
```

gibi her şeyi compiler'a gömmek zorunda kalmıyoruz.

Bu uXBasic'in bilimsel dil hedefi için büyük mesele.

---

# 26. MAGIC ile bağlantı

Birinci sınıf library type:

```text
operator
+
MAGIC
+
lifecycle
```

ile birleşiyor.

Örneğin descriptor:

```text
TOSTRING
HASH
CLONE
```

diyorsa compiler ortak MAGIC/operatör mekanizmasını kullanabilir.

Bu da native `CLASS` MAGIC sistemiyle aynı düşünsel modele oturuyor:

```text
çekirdek davranışı bilir
tip davranışın sağlayıcısını verir
```

---

# 27. uxclz.dll aynı şey mi?

Hayır.

Bu ayrım çok önemli.

`uxclz.dll`, ayrı C++ runtime nesne sistemi.

Dokümantasyon özellikle uXBasic'in kendi `CLASS/vtable` sistemini değiştirmediğini söylüyor. Generation-safe handle, reference counting, interface sorgusu, method registry ve multiple dispatch sağlayan ikinci bir dinamik nesne yoludur. 

Yani elimizde aslında üç ilgili ama farklı dünya var:

```text
uXBasic native CLASS
       │
       ├── compiler OOP sistemi
       │
       ▼
CLASS / INTERFACE / VIRTUAL / OVERRIDE / MAGIC


UXClazz
       │
       └── uXBasic CLASS kaynak kodu üreten üst katman


uxclz.dll
       │
       └── dinamik C++ object registry/runtime


First-class Library Type Contract
       │
       └── RATIONAL gibi kütüphane tiplerini
           gerçek dil tipi gibi tanıtan descriptor sistemi
```

Bunları birleştirip tek çorba yapmamak çok önemli.

---

# 28. uxclz bugün ne durumda?

Gerçek kaynakta ve belgede:

```text
U64 generation handle
retain/release
stale handle koruması
type registry
base type
interface/capability
method registry
multiple dispatch
metadata
```

var.

Handle yapısı:

```text
üst 32 bit = slot + 1
alt 32 bit = generation
```

ve slot yeniden kullanıldığında generation artırılıyor. Böylece eski handle'ın yanlış nesneye bağlanması engelleniyor. 

Type registry:

```text
id
name
base type
flags
interfaces
method table
```

tutuyor. 

Metot çağrısı sırasında registry mutex'i tutulmuyor, fakat nesne geçici retain ediliyor. 

Bu gerçek concurrency geldiğinde önemli olacak.

---

# 29. Kütüphane tiplerini TASK ile nasıl birleştireceğiz?

Bu bizim son konuşmamızdaki yeni bağlantı.

Library type descriptor'a ileride:

```text
taskTransfer
threadSafety
sharedPolicy
```

eklemeyi planladık.

Örneğin:

```text
RATIONAL
    immutable/value
    COPY
    task-safe
```

olabilir.

Ama örneğin:

```text
DATAFRAME
    mutable
    EXTERNAL_LOCK
```

olabilir.

GPU nesnesi:

```text
THREAD_AFFINE
```

olabilir.

Yani compiler:

```basic
t = SPAWN Worker(myObject)
```

gördüğünde artık yalnız tipe değil:

> Bu tip görev sınırından geçirilebilir mi?

sorusuna da cevap verebilecek.

Bu henüz 23.09 kaynakta yok, **yeni plan**.

---

# 30. SHARED / ATOMIC / MUTEX de yeni plan

Bunlar 23.09 dilinde henüz yok.

Gerçek Faz 2 concurrency için tasarladığımız:

```basic
DIM SHARED data AS MyType
DIM ATOMIC counter AS U64
DIM m AS MUTEX

LOCK data
    ...
END LOCK
```

sistemi gelecek aşama.

Temel ilke:

```text
normal veri = görevler arası otomatik paylaşılmaz
BYVAL      = snapshot
SHARED     = açık paylaşım
ATOMIC     = yarışsız küçük skaler
MUTEX      = açık kritik bölge
```

Bu MemoryRef ile birleşecek.

---

# 31. MemoryRef neden burada önemli?

JS/WASM tasarımımız zaten:

```text
PTR/MemoryRef
ARRAY
TYPE
CLASS
LIST/DICT/SET
```

için ortak runtime modelleri öngörüyor. 

Gerçek THREAD geldiğinde MemoryRef ayrıca:

```text
owner
generation
lifetime
shared state
```

taşımalı.

Böylece:

```text
REDIM sonrası eski pointer
silinmiş object
başka TASK'a geçen region
```

gibi şeyler kontrol edilebilir.

---

# 32. Meta sistemi de bu mimariye bağlanıyor

Bu konuşmada Python REST generator örneğinden çıktığımız başka bir yol vardı.

Mevcut:

```text
%%API_ENDPOINT
%%ROUTE
%%GEN_FILE
%%GEN_BLOCK
%%TEMPLATE
%%FOREACH
```

sistemi gelecekte:

```text
metadata
   ↓
generator
   ↓
normal uXBasic source
```

üretebilir.

Bu özellikle library type ve CLASS sistemiyle çok güzel birleşir.

Mesela:

```text
TYPE metadata
↓
DERIVE JSON
↓
otomatik serializer
```

veya:

```text
API_ENDPOINT
↓
REST handler
```

üretilebilir.

Bu da çekirdeği şişirmeden dil yeteneklerini artırır.

---

# 33. Şu anda tüm sistemi tek cümlede anlatırsam

uXBasic'te artık şu mimari oluşuyor:

```text
                     TANIM KATMANI
       EVENT   PIPE   THREAD   PARALEL
          │      │       │        │
          └──────┴───────┴────────┘
                         │
                 SLOT bağlama sistemi
                         │
                      TRIGGER
                    eski/uyumlu yol
                         │
                         │
      ───────────────────┼────────────────────
                         │
                       SPAWN
                         │
                       TASK
                         │
                    TASKGROUP
                  yeni görev yaşam döngüsü
                         │
                SHARED/ATOMIC/MUTEX
                    planlanan paylaşım
                         │
                     MemoryRef
                         │
             x64 / JS Worker / WASM
```

Yan tarafta:

```text
CLASS / INTERFACE / MAGIC
            │
            ├── native OOP
            │
            ├── UXClazz
            │
            └── uxclz.dll
```

ve:

```text
Library Type Contract
    │
    ├── layout
    ├── operators
    ├── MAGIC
    ├── lifecycle
    ├── ABI
    ├── MIR
    ├── JS
    ├── WASM
    └── native provider

          ↓
       RATIONAL
          ↓
       COMPLEX
          ↓
     POLYNOMIAL
```

---

# 34. En önemli sonuç

**Senin sevdiğin eski sistem yok olmuyor.**

Hatta ben artık bunu açık bir tasarım ilkesi yapardım:

> `EVENT / PIPE / THREAD / PARALEL / SLOT / TRIGGER`, uXBasic'in yüksek düzey görev, olay ve yönlendirme sistemidir. `SPAWN / TASK / TASKGROUP` bu sistemi değiştirmez; özellikle THREAD/PARALEL çalıştırmalarına bireysel çalışma örneği, durum, sonuç, hata, bekleme ve iptal denetimi ekler.

Dolayısıyla bu bir “eskiyi at, yenisini kur” işi değil.

Daha çok:

```text
eski tasarım
+
eksik çalışma örneği modeli
+
gerçek concurrency motoru
+
MemoryRef/shared data
+
birinci sınıf library types
+
JS/WASM parity
```

şeklinde **katman katman büyütme**.

Bence uXBasic için doğru yön tam olarak bu. Çünkü eski `SLOT/TRIGGER` fikri özgün ve kullanışlı. `SPAWN/TASK` onu banal bir thread API'siyle değiştirmiyor, tersine eski sistemi gerçek modern eşzamanlılıkla tamamlıyor.


Mete abi, belgeyi 23.09 kaynak ağacı ve bu konuşmalarda kilitlediğimiz hedef tasarımlar üzerinden hazırladım. Bu bir **mevcut eksiklerin listesi değil**, tasarımların tamamının gerçekleşmiş olduğu nihai uXBasic kullanım kılavuzu yaklaşımıdır.

Belgede şunları birlikte ele aldım: veri tipleri ve veri yapıları, operatörler, yerleşik fonksiyonlar, prosedürel ve özyinelemeli programlama, sınıf/arayüz/MAGIC/OPERATOR sistemi, `EVENT/PIPE/THREAD/PARALEL/SLOT/TRIGGER`, bunların yanında yaşayan `SPAWN/TASK/TASKGROUP`, `SHARED/ATOMIC/MUTEX/MemoryRef`, FFI ve DLL sistemi, önişlemci ve meta komutlar, kod üretimi, birinci sınıf kütüphane tipi sistemi, UXClazz/uxclz ayrımı, bilimsel ve AI kütüphaneleri, JS/WASM/x64 hedef modeli ve paradigmaların aynı program içinde iç içe kullanımı.

Özellikle eski görev sistemini kaldırmadım. Belgede nihai model açıkça:

```text
EVENT / PIPE / THREAD / PARALEL
          │
          ├── SLOT / TRIGGER
          │
          └── SPAWN / TASK / TASKGROUP
```

olarak korunuyor.

Ayrıca özyineleme, OOP, PIPE, EVENT, SLOT, TRIGGER, SPAWN, TASKGROUP ve paylaşılan veri modelini **aynı programda kullanan birleşik örnekler** de ekledim. İnsanlar özellikleri tek tek yapıp sonra birbirleriyle konuşmadıklarını keşfetmeyi seviyor; bu belgede özellikle o tuzağa düşmemeye çalıştım.

[**uXBasic Hedeflenen Sistem ve Kullanma Kılavuzu - Markdown**](sandbox:/mnt/data/uXBasic_Hedeflenen_Sistem_ve_Kullanma_Kilavuzu_TR_2026-09-24.md)

Belge şu anda **1581 satır** ve yaklaşık **32 KB**. Bu sürümü ana iskelet olarak kullanıp sonraki aşamada her komut ve kütüphane için ayrı ayrı **sözdizimi + parametreler + dönüş tipi + iç içe kullanım + hata koşulları + AST/MIR/native/JS/WASM davranışı** düzeyine genişletmek en doğru devam olur.


Mete abi, bunu **uXBasic’in hedeflenen güncel dil tasarımını** esas alarak hazırladım. Eski sistemi atmadım: özellikle `EVENT / SLOT / TRIGGER / PIPE / THREAD / PARALEL` çekirdeği korunuyor. Yeni görev/yürütme katmanı varsa bunun üstüne oturuyor. Ayrıca `PARALLEL` değil **`PARALEL`**, `$`/`%` tipi ekleri yerine açık veri tipleri, DLL tarafında `IMPORT DLL` değil `DECLARE ... LIB ... ALIAS` + `CALL(DLL/API)` yaklaşımını korudum.

Aşağıda her alanı **CEP ÖZETİ → MİMARİ PLAN → ZİHİN HARİTASI** biçiminde ayırıyorum. Görsel yok; yalnızca grafikleştirilmiş metin var.

---

# 1. uXBasic KOMUTLARI

## 1.1 CEP ÖZETİ

```text
┌──────────────────────────────────────────────────────────────┐
│                    uXBASIC KOMUTLARI                         │
├──────────────────────────────────────────────────────────────┤
│ PROGRAM AKIŞI                                                │
│ IF / THEN / ELSE / END IF                                    │
│ SELECT / CASE / END SELECT                                   │
│ FOR / NEXT                                                   │
│ FOR EACH / NEXT                                              │
│ DO / LOOP                                                    │
│ DO EACH / LOOP                                               │
│ WHILE / WEND                                                 │
│ GOTO / GOSUB / RETURN                                        │
│ TRY / CATCH / FINALLY                                        │
├──────────────────────────────────────────────────────────────┤
│ BİLDİRİM                                                     │
│ DIM / REDIM                                                  │
│ CONST                                                        │
│ SUB / FUNCTION                                               │
│ TYPE / STRUCT / UNION                                        │
│ CLASS / INTERFACE                                            │
│ ENUM                                                         │
├──────────────────────────────────────────────────────────────┤
│ NESNE SİSTEMİ                                                │
│ CLASS / EXTENDS / IMPLEMENTS / USES                          │
│ METHOD / PROPERTY                                            │
│ CONSTRUCTOR / DESTRUCTOR                                     │
│ NEW / DELETE                                                 │
│ THIS / ME                                                    │
│ MAGIC ... END MAGIC                                          │
├──────────────────────────────────────────────────────────────┤
│ GÖREV / OLAY / EŞZAMANLILIK                                  │
│ EVENT ... END EVENT                                          │
│ THREAD ... END THREAD                                        │
│ PARALEL ... END PARALEL                                      │
│ PIPE ... END PIPE                                            │
│ SLOT ... END SLOT                                            │
│ ON / OFF                                                     │
│ TRIGGER                                                      │
├──────────────────────────────────────────────────────────────┤
│ BELLEK                                                       │
│ VIRTUAL                                                      │
│ PEEK* / POKE*                                                │
│ MEMCOPY*                                                     │
│ MEMFILL                                                      │
│ VARPTR / ADDROF                                              │
│ CASTPTR                                                      │
├──────────────────────────────────────────────────────────────┤
│ DIŞ SİSTEMLER                                                │
│ DECLARE ... LIB ... ALIAS                                    │
│ CALL(DLL)                                                    │
│ CALL(API)                                                    │
│ IMPORT        → C / C++ / ASM kaynak                         │
│ INCLUDE                                                     │
│ NAMESPACE / USING / MODULE                                   │
│ SHELL                                                        │
├──────────────────────────────────────────────────────────────┤
│ GİRİŞ / ÇIKIŞ                                                │
│ PRINT                                                        │
│ INPUT                                                        │
│ OPEN / CLOSE                                                 │
│ READ / WRITE                                                 │
└──────────────────────────────────────────────────────────────┘
```

---

## 1.2 MİMARİ PLAN

```text
                        PROGRAM
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
      BİLDİRİMLER       YÜRÜTME          MODÜLLER
          │                │                │
          │                │                ├── INCLUDE
          │                │                ├── IMPORT
          │                │                ├── MODULE
          │                │                ├── NAMESPACE
          │                │                └── USING
          │                │
          │         ┌──────┴────────┐
          │         │               │
          ▼         ▼               ▼
      VERİLER     KLASİK          GÖREVSEL
                  AKIŞ             YÜRÜTME
          │         │               │
          │         │               ├── EVENT
          │         │               ├── THREAD
          │         │               ├── PARALEL
          │         │               ├── PIPE
          │         │               └── SLOT
          │         │
          │         ├── IF
          │         ├── SELECT
          │         ├── FOR
          │         ├── FOR EACH
          │         ├── DO
          │         └── DO EACH
          │
          ├── DIM
          ├── CONST
          ├── TYPE
          ├── STRUCT
          ├── CLASS
          └── INTERFACE
```

Görev sistemi özellikle şöyle düşünülüyor:

```text
EVENT / THREAD / PARALEL / PIPE
              │
              │ tanımlanır
              ▼
        ┌─────────────┐
        │ GÖREV TABLOSU│
        └──────┬──────┘
               │
          ON ... SLOT n
               │
               ▼
      ┌──────────────────┐
      │ SLOT TABLOSU     │
      │ 0 .......... 255 │
      └────────┬─────────┘
               │
            TRIGGER
               │
               ▼
          GÖREV ÇALIŞIR
               │
              OFF
               │
               ▼
       SLOT BAĞI KALDIRILIR
```

---

## 1.3 ZİHİN HARİTASI

```text
uXBASIC KOMUTLARI
│
├── Program
│   ├── DIM
│   ├── CONST
│   ├── SUB
│   ├── FUNCTION
│   └── RETURN
│
├── Karar
│   ├── IF
│   └── SELECT CASE
│
├── Döngü
│   ├── FOR
│   ├── FOR EACH
│   ├── WHILE
│   ├── DO
│   └── DO EACH
│
├── Nesne
│   ├── CLASS
│   ├── INTERFACE
│   ├── CONSTRUCTOR
│   ├── DESTRUCTOR
│   ├── PROPERTY
│   ├── NEW
│   ├── DELETE
│   └── MAGIC
│
├── Görev
│   ├── EVENT
│   ├── THREAD
│   ├── PARALEL
│   ├── PIPE
│   ├── SLOT
│   ├── ON
│   ├── OFF
│   └── TRIGGER
│
├── Bellek
│   ├── VIRTUAL
│   ├── PEEK
│   ├── POKE
│   ├── MEMCOPY
│   ├── MEMFILL
│   └── VARPTR
│
└── Dış dünya
    ├── DECLARE
    ├── CALL(DLL)
    ├── CALL(API)
    ├── IMPORT
    ├── INCLUDE
    └── SHELL
```

---

# 2. uXBasic İŞLEVLERİ

Burada **komut ile işlevi ayırıyorum**. `PRINT` bir komuttur; `ABS(x)` gibi değer döndüren yapı işlevdir. İnsanlar kırk yıldır bunları aynı listede yazıp sonra dil belgelerinde birbirlerini arıyorlar.

## 2.1 CEP ÖZETİ

```text
┌─────────────────────────────────────────────────────────────┐
│                   uXBASIC İŞLEVLERİ                         │
├──────────────────────┬──────────────────────────────────────┤
│ MATEMATİK            │ ABS, SGN, INT, FIX, ROUND           │
│                      │ SQR/SQRT, EXP, LOG                   │
│                      │ SIN, COS, TAN                        │
├──────────────────────┼──────────────────────────────────────┤
│ METİN                │ LEN                                  │
│                      │ LEFT / RIGHT / MID                   │
│                      │ UCASE / LCASE                        │
│                      │ TRIM                                 │
├──────────────────────┼──────────────────────────────────────┤
│ DÖNÜŞÜM              │ CINT / CLNG / CSNG / CDBL ...       │
│                      │ CAST                                 │
├──────────────────────┼──────────────────────────────────────┤
│ BELLEK               │ VARPTR                              │
│                      │ ADDROF                              │
│                      │ STRPTR / WSTRPTR                    │
│                      │ CASTPTR                             │
├──────────────────────┼──────────────────────────────────────┤
│ DİZİ / KOLEKSİYON    │ boyut / sınır / erişim işlevleri   │
├──────────────────────┼──────────────────────────────────────┤
│ NESNE                │ tür bilgisi / dönüşüm / MAGIC       │
├──────────────────────┼──────────────────────────────────────┤
│ SİSTEM               │ dış çağrı ve çalışma zamanı         │
│                      │ yardımcı işlevleri                  │
└──────────────────────┴──────────────────────────────────────┘
```

---

## 2.2 MİMARİ PLAN

```text
                  İŞLEV ÇAĞRISI
                       │
              ┌────────┴─────────┐
              │                  │
           YERLEŞİK          KULLANICI
              │                  │
      ┌───────┼───────┐       FUNCTION
      │       │       │           │
      ▼       ▼       ▼           ▼
   SAYISAL  METİN   BELLEK     PARAMETRELER
      │       │       │           │
      └───────┴───────┴─────┬─────┘
                             ▼
                         DÖNÜŞ TİPİ
                             │
                             ▼
                            DEĞER
```

Kullanıcı tanımlı işlev:

```text
FUNCTION Hesapla(x AS F64) AS F64
    RETURN x * x
END FUNCTION
```

Özyinelemeli kullanım:

```text
FUNCTION Faktoriyel(n AS I64) AS I64

    IF n <= 1 THEN
        RETURN 1
    END IF

    RETURN n * Faktoriyel(n - 1)

END FUNCTION
```

Yani özyineleme yalnız klasik işlevlerle sınırlı düşünülmüyor. Görev bloklarının da kendi çağrı/görev ilişkilerini kurabilmesi hedefleniyor.

---

# 3. uXBasic ÖNİŞLEMCİ VE META SİSTEMİ

Burası uXBasic'in sıradan BASIC çizgisinden iyice ayrıldığı katman.

## 3.1 CEP ÖZETİ

```text
┌──────────────────────────────────────────────────────────────┐
│                 uXBASIC %% META SİSTEMİ                     │
├──────────────────────────────────────────────────────────────┤
│ TANIMLAMA                                                    │
│ %%DEFINE                                                     │
│ %%SET                                                        │
│ %%MACRO                                                      │
├──────────────────────────────────────────────────────────────┤
│ KOŞUL                                                        │
│ %%IF                                                         │
│ %%ELIF                                                       │
│ %%ELSE                                                       │
│ %%ENDIF                                                      │
├──────────────────────────────────────────────────────────────┤
│ ÜRETİM / DÖNGÜ                                               │
│ %%FOR                                                        │
│ %%FOREACH                                                    │
│ %%REPEAT                                                     │
│ %%EVAL                                                       │
├──────────────────────────────────────────────────────────────┤
│ ADLANDIRMA                                                   │
│ %%ALIAS {eski} AS {yeni}                                    │
├──────────────────────────────────────────────────────────────┤
│ KOD ÜRETİMİ                                                  │
│ GEN                                                          │
│ TEMPLATE                                                     │
├──────────────────────────────────────────────────────────────┤
│ GÖMÜLÜ DİLLER                                                │
│ %%JS_BEGIN       ... %%JS_END                               │
│ %%WAT_BEGIN      ... %%WAT_END                              │
│ %%HTML_BEGIN     ... %%HTML_END                             │
│ %%JSON_BEGIN     ... %%JSON_END                             │
└──────────────────────────────────────────────────────────────┘
```

---

## 3.2 MİMARİ PLAN

```text
                 uXBasic kaynak dosyası
                         │
                         ▼
              ┌──────────────────┐
              │ %% ÖNİŞLEMCİ     │
              │                  │
              │ DEFINE           │
              │ SET              │
              │ IF               │
              │ FOREACH          │
              │ MACRO            │
              │ TEMPLATE         │
              └────────┬─────────┘
                       │
                       ▼
               ÜRETİLMİŞ KAYNAK
                       │
                       ▼
              ┌──────────────────┐
              │ SÖZCÜK ÇÖZÜMLEME│
              └────────┬─────────┘
                       ▼
              ┌──────────────────┐
              │ SÖZDİZİM AĞACI  │
              └────────┬─────────┘
                       ▼
              ┌──────────────────┐
              │ ARA TEMSİL      │
              └────────┬─────────┘
                       ▼
        ┌──────────────┼─────────────────┐
        ▼              ▼                 ▼
      x64             JS               WASM/WAT
```

---

## 3.3 META + ÖZNİTELİK SİSTEMİ

Burada önemli ayrım var:

```text
%%...              [....]
  │                   │
  │                   │
  ▼                   ▼
DERLEMEDEN         DİLİN SEMANTİK
ÖNCE ÇALIŞIR       BİLGİSİDİR
  │                   │
  │                   ├── [Test]
  │                   ├── [Deprecated]
  │                   ├── [Author]
  │                   ├── [GET]
  │                   └── [Serializable]
  │
  ├── %%DEFINE
  ├── %%IF
  ├── %%FOREACH
  └── %%GEN...
```

Yani:

```text
%%IF
```

ile

```text
[Test]
```

aynı şey değildir.

Birincisi **kaynağı üretir/değiştirir**.

İkincisi **program öğesine anlam bilgisi ekler**.

---

## 3.4 ZİHİN HARİTASI

```text
META
│
├── Değer
│   ├── DEFINE
│   ├── SET
│   └── EVAL
│
├── Karar
│   ├── IF
│   ├── ELIF
│   ├── ELSE
│   └── ENDIF
│
├── Tekrar
│   ├── FOR
│   ├── FOREACH
│   └── REPEAT
│
├── Kod üretme
│   ├── GEN
│   ├── TEMPLATE
│   └── MACRO
│
├── Adlandırma
│   └── ALIAS
│
├── Gömülü içerik
│   ├── JS
│   ├── WAT
│   ├── HTML
│   └── JSON
│
└── Öznitelikler
    ├── Test
    ├── Deprecated
    ├── Author
    ├── GET
    └── Serializable
```

---

# 4. uXBasic İŞLEÇLERİ

## 4.1 CEP ÖZETİ

```text
┌───────────────────────────────────────────────────────────┐
│                    uXBASIC İŞLEÇLERİ                      │
├─────────────────┬─────────────────────────────────────────┤
│ ATAMA           │ =                                       │
├─────────────────┼─────────────────────────────────────────┤
│ EŞİTLİK         │ ==                                      │
│ EŞİT DEĞİL      │ != / <>                                 │
├─────────────────┼─────────────────────────────────────────┤
│ KARŞILAŞTIRMA   │ <   <=   >   >=                        │
├─────────────────┼─────────────────────────────────────────┤
│ ARİTMETİK       │ +   -   *   /   MOD                    │
│                 │ **                                      │
├─────────────────┼─────────────────────────────────────────┤
│ BİT             │ AND / OR / XOR / NOT                   │
│                 │ NAND / NOR / XNOR                      │
├─────────────────┼─────────────────────────────────────────┤
│ MANTIK          │ AND / OR / NOT                         │
│                 │ IMP / CIMP / NIMP / NCIMP              │
├─────────────────┼─────────────────────────────────────────┤
│ İŞARETÇİ        │ PTR + tamsayı                           │
│                 │ PTR - tamsayı                           │
│                 │ PTR - PTR                              │
├─────────────────┼─────────────────────────────────────────┤
│ NESNE           │ MAGIC / OPERATOR aşırı yükleme         │
└─────────────────┴─────────────────────────────────────────┘
```

En önemli kararlardan biri:

```text
a = 10
│
└──── ATAMA


a == 10
│
└──── EŞİTLİK KARŞILAŞTIRMASI
```

Bu ayrım özellikle modern dillerle çalışırken oluşan o sonsuz `=` cehennemini azaltıyor.

---

## 4.2 ÜS VE XOR

```text
2 ** 8
   │
   └── ÜS
       = 256
```

```text
a XOR b
```

bit düzeyinde dışlayan VEYA'dır.

Dolayısıyla:

```text
^
```

işaretini bir yerde üs, başka yerde XOR yapıp programcıya küçük çaplı psikolojik deney uygulamamak daha doğru.

---

# 5. İŞARETÇİ ARİTMETİĞİ

uXBasic'te burada C benzeri ama **tip bilgili** yaklaşım hedefleniyor.

```text
p AS PTR<I32>

p + 1
```

anlamı:

```text
adres + 1 bayt       DEĞİL

adres + sizeof(I32)
     =
adres + 4 bayt
```

F64 için:

```text
p AS PTR<F64>

p + 1
       │
       └── +8 bayt
```

Harita:

```text
PTR<T>
  │
  ├── + n
  │     └── n × sizeof(T)
  │
  ├── - n
  │     └── n × sizeof(T)
  │
  └── ptr1 - ptr2
        └── eleman uzaklığı


PTR + PTR
    │
    └── ANLAMSIZ / HATA
```

---

# 6. uXBasic VERİ TİPLERİ

## 6.1 CEP ÖZETİ

```text
uXBASIC VERİ TİPLERİ
│
├── Tamsayı
│   ├── I8
│   ├── U8
│   ├── I16
│   ├── U16
│   ├── I32
│   ├── U32
│   ├── I64
│   └── U64
│
├── Gerçel
│   ├── F32
│   ├── F64
│   ├── F80
│   └── F128
│
├── Büyük sayılar
│   ├── BIGINT
│   ├── BIGF
│   ├── BIGD
│   ├── BIGFLOAT
│   ├── BIGDECIMAL
│   └── BALL
│
├── Mantıksal
│   └── BOOL
│
├── Karakter / metin
│   ├── CHAR
│   ├── STRING
│   └── WSTRING
│
├── Sistem
│   ├── PTR
│   ├── HANDLE
│   ├── STRPTR
│   └── WSTRPTR
│
├── Bileşik
│   ├── ARRAY
│   ├── TYPE
│   ├── STRUCT
│   ├── UNION
│   ├── CLASS
│   └── INTERFACE
│
└── Kütüphane sistem tipi
    ├── RATIONAL
    ├── COMPLEX
    ├── POLYNOMIAL
    └── ...
```

---

# 7. SAYISAL TİP HARİTASI

```text
                         SAYI
                           │
            ┌──────────────┴──────────────┐
            ▼                             ▼
         TAM SAYI                      GERÇEL
            │                             │
      ┌─────┴─────┐               ┌──────┼──────┐
      │           │               │      │      │
   İŞARETLİ    İŞARETSİZ         F32    F64   F80/F128
      │           │
   I8 I16      U8 U16
   I32 I64     U32 U64

                           │
                           ▼
                    YÜKSEK DUYARLIK
                           │
          ┌────────────────┼─────────────────┐
          ▼                ▼                 ▼
       BIGINT          BIGFLOAT         BIGDECIMAL
```

---

# 8. KÜTÜPHANE SİSTEM TİPLERİ

Burası uXBasic'in daha ilginç taraflarından biri.

Örneğin:

```text
DIM a AS RATIONAL
DIM z AS COMPLEX
DIM p AS POLYNOMIAL
```

Bunların yalnız:

```text
STRUCT
```

olarak taklit edilmesi hedeflenmiyor.

Bunun yerine:

```text
          BİRİNCİ SINIF KÜTÜPHANE TİPİ
                      │
          ┌───────────┼────────────┐
          ▼           ▼            ▼
       Bellek      İşleçler      Yaşam
       düzeni                     döngüsü
          │           │            │
          │           │            ├── oluştur
          │           │            ├── kopyala
          │           │            ├── klonla
          │           │            └── yok et
          │           │
          │           ├── +
          │           ├── -
          │           ├── *
          │           └── ==
          │
          ├─────────────────────────────────┐
          ▼                                 ▼
        MAGIC                         Tür dönüşümü
          │
          ├── GET
          ├── SET
          ├── CALL
          └── TOSTRING
```

Ve bunun altında:

```text
KÜTÜPHANE TİPİ
      │
      ├── AST bilgisi
      ├── ara temsil bilgisi
      ├── ABI sözleşmesi
      ├── x64 sağlayıcısı
      ├── JS sağlayıcısı
      └── WASM sağlayıcısı
```

Bu tasarım sayesinde:

```text
RATIONAL
COMPLEX
POLYNOMIAL
MATRIX
VECTOR
BIGINT
```

gibi şeyler dil çekirdeğini şişirmeden **dilin gerçek tipleri gibi** davranabilir.

---

# 9. uXBasic VERİ YAPILARI

## 9.1 CEP ÖZETİ

```text
┌────────────────────────────────────────────────────────────┐
│                 uXBASIC VERİ YAPILARI                     │
├────────────────────────────────────────────────────────────┤
│ SCALAR                                                     │
│   tek değer                                                │
│                                                            │
│ ARRAY                                                      │
│   aynı türden çok eleman                                   │
│                                                            │
│ TYPE                                                       │
│   kullanıcı tanımlı bileşik tip                            │
│                                                            │
│ STRUCT                                                     │
│   açık bellek düzenli yapı                                 │
│                                                            │
│ UNION                                                      │
│   aynı belleği paylaşan alanlar                            │
│                                                            │
│ CLASS                                                      │
│   veri + davranış + kalıtım                                │
│                                                            │
│ INTERFACE                                                  │
│   davranış sözleşmesi                                      │
│                                                            │
│ PTR<T>                                                     │
│   tip bilgili adres                                        │
│                                                            │
│ KÜTÜPHANE SİSTEM TİPİ                                     │
│   dış kütüphane tarafından genişletilebilir tip            │
└────────────────────────────────────────────────────────────┘
```

---

# 10. VERİ YAPISI MİMARİ PLANI

```text
                          VERİ
                            │
          ┌─────────────────┴─────────────────┐
          │                                   │
        BASİT                              BİLEŞİK
          │                                   │
    ┌─────┼──────┐             ┌──────────────┼────────────┐
    │     │      │             │              │            │
  sayı   bool   metin        ARRAY          STRUCT       CLASS
                                    │           │            │
                                    │           │            ├── METHOD
                                    │           │            ├── PROPERTY
                                    │           │            ├── MAGIC
                                    │           │            └── VIRTUAL
                                    │           │
                                    │           ├── PACK
                                    │           ├── ALIGN
                                    │           └── ABI
                                    │
                                    ▼
                               çok elemanlı
```

---

# 11. TYPE / STRUCT / UNION / CLASS AYRIMI

```text
TYPE
 │
 └── Genel kullanıcı tanımlı veri tipi


STRUCT
 │
 ├── Bellek düzeni önemlidir
 ├── ABI ile dış sistemlere aktarılabilir
 ├── PACK kullanılabilir
 └── ALIGN kullanılabilir


UNION
 │
 └── Alanlar aynı bellek bölgesini paylaşır


CLASS
 │
 ├── Veri
 ├── Metot
 ├── Özellik
 ├── Yapıcı
 ├── Yıkıcı
 ├── Kalıtım
 ├── Arayüz
 ├── Sanal metot
 └── MAGIC
```

---

# 12. NESNE YÖNELİMLİ SİSTEM

```text
CLASS
│
├── EXTENDS
│      │
│      └── başka sınıftan kalıtım
│
├── IMPLEMENTS
│      │
│      └── INTERFACE sözleşmesi
│
├── USES
│      │
│      └── trait / davranış bileşimi
│
├── CONSTRUCTOR
│
├── DESTRUCTOR
│
├── METHOD
│
├── PROPERTY
│
├── VIRTUAL
│
├── OVERRIDE
│
├── NEW
│
├── DELETE
│
├── THIS / ME
│
└── MAGIC
       │
       ├── <.init.>
       ├── GET
       ├── SET
       ├── CALL
       ├── TOSTRING
       ├── aritmetik
       ├── karşılaştırma
       └── bit işlemleri
```

Buna ayrıca türetilmiş davranış üretimi bağlanıyor:

```text
DERIVE
│
├── EQ
├── HASH
├── CLONE
├── TOSTRING
└── JSON
```

---

# 13. FOR EACH / DO EACH

İki yapı aynı şey olmamalı.

```text
FOR EACH
│
├── belirli bir koleksiyon üzerinde dolaş
├── her elemanı sırayla al
└── eleman-temelli yineleme
```

Örnek:

```text
FOR EACH balik IN baliklar

    PRINT balik.agirlik

NEXT
```

Buna karşılık:

```text
DO EACH
│
├── daha genel yinelenebilir kaynak
├── akış
├── boru
├── üretici
├── görev sonucu
└── kullanıcı tanımlı yineleyici
```

Kavramsal olarak:

```text
ARRAY ───────────────► FOR EACH

LIST  ───────────────► FOR EACH

ITERATOR ────────────► DO EACH

PIPE ────────────────► DO EACH

STREAM ──────────────► DO EACH

GENERATOR ───────────► DO EACH
```

Bu ayrım ileride veri bilimi ve akış işleme tarafında ciddi işe yarar.

---

# 14. BELLEK MODELİ

Bu da iki katmanlı kalıyor.

```text
                    BELLEK ERİŞİMİ
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
           VIRTUAL                  NATIVE
              │                       │
       güvenli ayrılmış         gerçek adres alanı
       sanal bellek                    │
              │                        │
              │                  işletim sistemi
              │                  / DLL / cihaz
              │                  / yerel bellek
              │
              └────────────┬───────────┘
                           ▼
                          AUTO
```

AUTO kararı:

```text
AUTO
│
├── sabit adres
│      └── VIRTUAL
│
├── PTR değişkeni
│      └── NATIVE
│
├── VARPTR(...)
│      └── NATIVE
│
├── ADDROF(...)
│      └── NATIVE
│
├── BYREF
│      └── NATIVE
│
└── EXTERNAL adres
       └── NATIVE
```

Ve önemli ayrım:

```text
EXTERNAL ≠ üçüncü bellek türü

EXTERNAL
    │
    └── dış kaynaktan alınmış NATIVE adres
```

---

# 15. BELLEK KOMUTLARI HARİTASI

```text
BELLEK
│
├── Adres alma
│   ├── VARPTR
│   ├── ADDROF
│   ├── STRPTR
│   └── WSTRPTR
│
├── Okuma
│   ├── PEEKB
│   ├── PEEKW
│   ├── PEEKD
│   └── ...
│
├── Yazma
│   ├── POKEB
│   ├── POKEW
│   ├── POKED
│   └── ...
│
├── Blok işlemleri
│   ├── MEMCOPY
│   ├── MEMCOPYB
│   └── MEMFILL
│
├── İşaretçi
│   ├── PTR<T>
│   └── CASTPTR
│
└── Çalışma alanı
    ├── VIRTUAL
    ├── NATIVE
    └── AUTO
```

`MEMCOPY` ailesinde kanonik yön:

```text
MEMCOPY hedef, kaynak, adet
        │       │       │
        │       │       └── kaç eleman/bayt
        │       └────────── nereden
        └────────────────── nereye
```

---

# 16. EVENT / THREAD / PARALEL / PIPE FARKI

Bunu tek bakışta görmek için:

```text
                YÜRÜTÜLEBİLİR BLOK
                       │
        ┌──────────────┼───────────────┐
        │              │               │
        ▼              ▼               ▼
      EVENT          THREAD         PARALEL
        │              │               │
        │              │               │
     olay/görev     bağımsız         paralel
     davranışı      yürütme          çalışma
        │
        └──────────────┬───────────────┘
                       │
                       ▼
                      SLOT
                       │
                     TRIGGER
```

`PIPE` biraz farklıdır:

```text
             GİRDİ
               │
               ▼
       ┌──────────────┐
       │     PIPE     │
       │              │
       │ dönüştür     │
       │ işle         │
       │ aktar        │
       └───────┬──────┘
               │
               ▼
             ÇIKTI
```

Ve:

```text
PIPE A
   │
   ▼
PIPE B
   │
   ▼
PIPE C
```

ile gerçek bir işlem hattı kurulabilir.

---

# 17. SLOT SİSTEMİ

```text
SLOT TABLOSU

┌──────┬─────────────────────┐
│  0   │ görev / boş         │
│  1   │ EVENT SensorRead    │
│  2   │ THREAD Logger       │
│  3   │ PIPE Filter         │
│  4   │ PARALEL Analyze     │
│ ...  │ ...                 │
│255   │ görev / boş         │
└──────┴─────────────────────┘
```

Yaşam döngüsü:

```text
Görev tanımı
     │
     ▼
ON görev SLOT 12
     │
     ▼
slot[12] = görev
     │
     ▼
TRIGGER 12
     │
     ▼
çalıştır
     │
     ▼
OFF SLOT 12
     │
     ▼
slot[12] = boş
```

---

# 18. DLL / API / KÜTÜPHANE MODELİ

Kanonik ayrım:

```text
                     DIŞ KOD
                        │
        ┌───────────────┼─────────────────┐
        ▼               ▼                 ▼
    KAYNAK KOD        DLL/API        uXBasic MODÜLÜ
        │               │                 │
     IMPORT          DECLARE             INCLUDE
        │           LIB / ALIAS          MODULE
        │               │              NAMESPACE
        │               │
    C / C++ / ASM    CALL(DLL)
                    CALL(API)
```

Yani:

```text
IMPORT some.dll
```

kanonik tasarım **değil**.

Bunun yerine mantık:

```text
DECLARE FUNCTION ...
    LIB "xxx.dll"
    ALIAS "GercekFonksiyonAdi"
```

ve ardından:

```text
CALL(DLL)
```

veya:

```text
CALL(API)
```

---

# 19. TAM uXBASIC ZİHİN HARİTASI

Şimdi hepsini tek dev metinsel haritada birleştirelim:

```text
                               uXBASIC
                                  │
 ┌────────────────────────────────┼─────────────────────────────────┐
 │                                │                                 │
 ▼                                ▼                                 ▼
DİL                             META                              ÇALIŞMA
 │                                │                                 │
 │                                │                                 │
 ├── Veri Tipleri                 ├── %%DEFINE                      ├── AST
 │   ├── I8..U64                  ├── %%SET                         ├── MIR
 │   ├── F32..F128                ├── %%IF                          ├── x64
 │   ├── BIGINT                   ├── %%FOREACH                     ├── JS
 │   ├── STRING                   ├── %%MACRO                       └── WASM
 │   ├── PTR                      ├── GEN
 │   └── Library Type             └── TEMPLATE
 │
 ├── Veri Yapıları
 │   ├── ARRAY
 │   ├── TYPE
 │   ├── STRUCT
 │   ├── UNION
 │   ├── CLASS
 │   └── INTERFACE
 │
 ├── Akış
 │   ├── IF
 │   ├── SELECT
 │   ├── FOR
 │   ├── FOR EACH
 │   ├── DO
 │   ├── DO EACH
 │   └── TRY
 │
 ├── OOP
 │   ├── CLASS
 │   ├── EXTENDS
 │   ├── IMPLEMENTS
 │   ├── USES
 │   ├── CONSTRUCTOR
 │   ├── DESTRUCTOR
 │   ├── VIRTUAL
 │   ├── OVERRIDE
 │   ├── MAGIC
 │   ├── NEW
 │   └── DELETE
 │
 ├── Görev Sistemi
 │   ├── EVENT
 │   ├── THREAD
 │   ├── PARALEL
 │   ├── PIPE
 │   ├── SLOT[0..255]
 │   ├── ON
 │   ├── OFF
 │   └── TRIGGER
 │
 ├── Bellek
 │   ├── VIRTUAL
 │   ├── NATIVE
 │   ├── AUTO
 │   ├── PEEK
 │   ├── POKE
 │   ├── MEMCOPY
 │   ├── MEMFILL
 │   ├── VARPTR
 │   └── CASTPTR
 │
 ├── Dış Sistem
 │   ├── DECLARE
 │   ├── LIB
 │   ├── ALIAS
 │   ├── CALL(DLL)
 │   ├── CALL(API)
 │   ├── IMPORT C/C++/ASM
 │   └── SHELL
 │
 └── İşleçler
     ├── =
     ├── ==
     ├── !=
     ├── + - * /
     ├── **
     ├── MOD
     ├── AND OR XOR NOT
     ├── NAND NOR XNOR
     ├── IMP
     ├── CIMP
     ├── NIMP
     └── NCIMP
```

# 20. EN ÜST DÜZEY uXBASIC MİMARİ PLANI

Son olarak bunu dilin tamamının mimari planına indirgersek:

```text
┌───────────────────────────────────────────────────────────────┐
│                       uXBASIC KAYNAĞI                         │
└───────────────────────────────┬───────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                 %% META / ÖNİŞLEMCİ                          │
│ DEFINE • IF • FOREACH • MACRO • GEN • TEMPLATE              │
└───────────────────────────────┬───────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                     SÖZCÜK ÇÖZÜMLEME                         │
└───────────────────────────────┬───────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                     SÖZDİZİM ÇÖZÜMLEME                       │
└───────────────────────────────┬───────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                  SOYUT SÖZDİZİM AĞACI                        │
│                                                               │
│ Veri • Akış • OOP • EVENT • PIPE • THREAD • SLOT • MAGIC    │
└───────────────────────────────┬───────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                      ANLAMSAL KATMAN                          │
│                                                               │
│ Tip sistemi                                                   │
│ kapsam                                                        │
│ sembol                                                        │
│ kütüphane tipi                                                │
│ öznitelikler                                                  │
│ ABI                                                           │
└───────────────────────────────┬───────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                     ARA TEMSİL                                │
│                                                               │
│ Normal program                                                │
│ Bellek                                                        │
│ OOP                                                           │
│ Görev sistemi                                                 │
│ DLL/API                                                       │
└───────────────────────────────┬───────────────────────────────┘
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
        ┌──────────┐       ┌──────────┐      ┌───────────┐
        │ x64 NASM │       │JavaScript│      │ WASM/WAT  │
        └─────┬────┘       └─────┬────┘      └─────┬─────┘
              │                  │                 │
              └──────────────────┼─────────────────┘
                                 ▼
┌───────────────────────────────────────────────────────────────┐
│                  uXBASIC ÇALIŞMA ZAMANI                      │
│                                                               │
│ Bellek • OOP • DLL • Görev • PIPE • THREAD • PARALEL        │
│ SLOT • TRIGGER • kütüphane sistem tipleri                    │
└───────────────────────────────────────────────────────────────┘
```

Bu, şu anda konuşmalarımızda oluşmuş **uXBasic'in en temiz “cep özeti + mimari plan + zihin haritası” görünümü**. Kritik nokta şu: uXBasic artık yalnızca klasik BASIC komutlarının genişletilmiş hali olarak görünmüyor. Tasarlanan sistemde **klasik yordamlı programlama + nesne yönelimli programlama + olay/görev modeli + veri akışı + sistem programlama + meta programlama + genişletilebilir kütüphane tipi sistemi** aynı dil yüzeyinde birleşiyor. Eski `EVENT/SLOT/TRIGGER` yapısının korunması da önemli, çünkü bunun yerine bambaşka bir görev dili getirip yıllardır oluşturduğumuz mimariyi çöpe atmak pek parlak bir insanlık hareketi olmazdı.


Evet. **20.09 tarihli güncel `uxb(20.09).zip` paketini açıp özellikle önişlemci, AST, anlamsal çözümleme ve MIR bağlantılarını yeniden inceledim.** Burada artık tasarımı soyut bırakmaya gerek yok. Mevcut kodun üzerine oturabilecek **kesin bir uXBasic Meta Sistemi** çıkarabiliriz.

En önemli kararını da doğru buluyorum:

> **Meta komutları normal uXBasic sözdiziminin içine yeni işaretler sokmak yerine `REM` satırlarında yaşasın.**

Bu, uXBasic açısından beklediğimden de uygun çıktı. Çünkü mevcut önişlemci zaten normal BASIC lexer'ından **önce** çalışıyor. Şu anda yalnızca satırın başındaki `%%` işaretini yakalıyor:

```freebasic
Function UXBPreLexIsDirectiveLine(...)
    trimmed = LTrim(lineText)

    If Left(trimmed, 2) <> "%%" Then
        ...
    End If
```

Dolayısıyla bunu genişletmek oldukça temiz.

---

# 1. Önce mevcut gerçek durum

20.09 paketinde önişlemci zaten bağımsız bir katman:

```text
src/preprocessor/
 ├─ preprocess_engine.fbs
 ├─ preprocess_lexer.fbs
 ├─ preprocess_parser.fbs
 ├─ preprocess_meta_model.fbs
 ├─ preprocess_meta_eval_adim34.fbs
 ├─ preprocess_selector.fbs
 └─ PreproesssorB/
      ├─ preprocess_block_scanner.fbs
      ├─ preprocess_manifest_schema.fbs
      ├─ preprocess_path_policy.fbs
      └─ preprocess_web_manifest_commands.fbs
```

Ve mevcut veri modeli:

```freebasic
Type PreprocessResult
    expandedSource As String

    blocks(...)
    assets(...)
    watImports(...)
    manifest(...)
    sourceMap(...)
    jsonEntries(...)
    locks(...)
    profiles(...)
    configFiles(...)
    diagnostics(...)

    allowRawJs As Integer
    allowRawWat As Integer
    safePaths As Integer
    requireHostBinding As Integer

    targetText As String
    outDir As String
    assetRoot As String
End Type
```

Bu çok önemli. Çünkü bizim tasarladığımız sistemin temeli zaten mevcut.

Ayrıca mevcut kaynakta açıkça:

```text
Preprocessor → expandedSource → BASIC Lexer
```

ayrımı korunmuş.

Ve `preprocess_meta_model.fbs` içinde özellikle şu yorum var:

```text
This file is intentionally independent from parser/AST/MIR.
%% commands are compile-time preprocessor commands
and must not leak to parser.
```

Bu mimari düşünce **korunmalı**.

---

# 2. Yeni temel söz dizimi

Ben artık çıplak:

```basic
%%DEFINE DEBUG 1
```

biçimini **eski/uyumluluk biçimi** yapardım.

Yeni uXBasic kaynaklarında kanonik biçim:

```basic
REM %%DEFINE DEBUG 1
```

olmalı.

Yani:

```basic
REM %%PP A
REM %%DEFINE DEBUG 1

REM %%IF DEBUG
    PRINT "Debug"
REM %%ENDIF
```

Normal BASIC açısından bunların hepsi yorumdur.

Ancak önişlemci açısından:

```text
REM %%DEFINE DEBUG 1
    ↓
DEFINE DEBUG 1
```

olur.

Bu müthiş bir avantaj sağlıyor:

* eski BASIC araçları dosyayı açabilir,
* başka derleyiciler satırı yorum sayar,
* sözdizimi renklendirici bozulmaz,
* normal parser meta komutlarını hiç görmez,
* önişlemci kapatılsa bile kaynak hâlâ BASIC olarak okunabilir,
* meta sistem dil sözdizimini kirletmez.

Bence bunu kesinleştirelim.

---

# 3. `REM %%` sadece önişlemci için

Ama `[Test]`, `[Serializable]` gibi özellikler farklı bir konu.

Onları da REM içinde tutacağız fakat ikinci bir biçim kullanacağız.

## Kanonik yapı

```basic
REM @[Test]
REM @[Author("Mete")]
REM @[Deprecated("YeniTopla kullan")]
FUNCTION EskiTopla(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION
```

Bu durumda iki ayrı REM meta dili oluyor:

```text
REM %%...       → derleme öncesi önişlemci komutu
REM @[ ... ]    → AST'ye bağlanacak özellik
```

Bu ayrım bence sistemin anahtarıdır.

---

# 4. Böylece üç farklı dünya birbirine karışmıyor

```text
REM %%DEFINE ...
     │
     └── kaynak üretme / önişlemci

REM @[Test]
     │
     └── AST meta bilgisi

PRINT ...
FUNCTION ...
CLASS ...
     │
     └── gerçek uXBasic programı
```

Çok temiz.

---

# 5. Nihai mimari

Ben artık sistemi şöyle kilitlerdim:

```text
                         .UXB KAYNAK
                              │
                ┌─────────────▼─────────────┐
                │   REM META TARAYICI       │
                │                           │
                │ REM %%...                 │
                │ REM @[...]                │
                └───────┬─────────┬─────────┘
                        │         │
                    %% komut     Attribute
                        │         kayıtları
                        ▼         │
             ┌─────────────────┐  │
             │ ÖNİŞLEMCİ A     │  │
             │                 │  │
             │ DEFINE          │  │
             │ IF              │  │
             │ FOREACH         │  │
             │ TEMPLATE        │  │
             │ GENERATE        │  │
             └────────┬────────┘  │
                      │           │
                      │           │
             ┌────────▼────────┐  │
             │ ÖNİŞLEMCİ B     │  │
             │                 │  │
             │ HTML            │  │
             │ CSS             │  │
             │ JS              │  │
             │ WAT/WASM        │  │
             │ HOST            │  │
             │ ASSET           │  │
             │ API             │  │
             │ BRIDGE          │  │
             └────────┬────────┘  │
                      │           │
                 expandedSource   │
                      │           │
                      ▼           │
                BASIC LEXER       │
                      │           │
                      ▼           │
                    PARSER        │
                      │           │
                      ▼           │
                     AST ◄────────┘
                      │
              META BAĞLAMA AŞAMASI
                      │
                      ▼
              META SYMBOL REGISTRY
                      │
        ┌─────────────┼──────────────┐
        │             │              │
        ▼             ▼              ▼
    SEMANTIC       DOC/TEST       CODEGEN META
        │
        ▼
       MIR
        │
  ┌─────┼────────┬─────────┐
  ▼     ▼        ▼         ▼
 x64    JS       WAT      WASM
```

Bu artık bizim esas mimarimiz olur.

---

# 6. A ve B'yi ortadan kaldırmıyoruz

Tam tersine **rollerini netleştiriyoruz**.

## Önişlemci A

A'nın işi:

> **uXBasic'in uXBasic üretmesi.**

Örneğin:

```basic
REM %%PP A

REM %%FOREACH T IN "I32,I64,F32,F64"

FUNCTION Max_{{T}}(a AS {{T}}, b AS {{T}}) AS {{T}}
    IF a > b THEN RETURN a
    RETURN b
END FUNCTION

REM %%ENDFOREACH
```

çıktısı:

```basic
FUNCTION Max_I32(...)
...
END FUNCTION

FUNCTION Max_I64(...)
...
END FUNCTION

FUNCTION Max_F32(...)
...
END FUNCTION

FUNCTION Max_F64(...)
...
END FUNCTION
```

A şunlarla ilgilenir:

* makro,
* koşullu kaynak,
* döngülü kaynak üretme,
* şablon,
* kod parçası üretme,
* uXBasic kodu oluşturma,
* derleme profili,
* hedefe göre kaynak değiştirme.

---

# 7. Önişlemci B

B'nin görevi farklı:

> **uXBasic programının çevresindeki uygulamayı üretmek.**

Yani:

```text
uXBasic
+
HTML
+
CSS
+
JavaScript
+
WAT
+
WASM
+
dosyalar
+
manifest
+
ana sistem bağlantıları
```

Örneğin:

```basic
REM %%PP B
REM %%TARGET BROWSER
REM %%OUTDIR "dist"

REM %%BUNDLE_NAME "BalikTakip"
REM %%BROWSER_ENTRY "index.html"
REM %%SCRIPT_ENTRY "app.js"
REM %%STYLE_ENTRY "style.css"
```

sonuçta:

```text
dist/
 ├─ index.html
 ├─ app.js
 ├─ style.css
 ├─ program.wasm
 ├─ manifest.json
 └─ assets/
```

üretebilir.

---

# 8. Fakat A ve B ortak motor kullanmalı

Bugünkü kaynakta A ve B biraz tarihsel olarak yan yana büyümüş.

Uzun vadede:

```text
A komut seti
B komut seti
```

olmalı ama **iki ayrı önişlemci motoru olmamalı**.

Doğru yapı:

```text
                   Meta Engine
                       │
             ┌─────────┴─────────┐
             │                   │
          A komutları          B komutları
             │                   │
          SOURCE               ARTIFACT
```

olmalı.

Yani:

```text
parser
expression evaluator
variables
conditions
templates
diagnostics
source map
security
path handling
```

ortak.

Sadece komut işleyicileri farklı.

---

# 9. Mevcut `%%PP A/B` de değişmeli

Bugünkü:

```basic
%%PP A
```

yeni biçimde:

```basic
REM %%PP A
```

olur.

Ama daha iyisi:

```basic
REM %%USE A
REM %%USE B
```

değil.

`PP A/B` mevcut sözleşmeyi koruyor ve yeterince açık.

Dolayısıyla:

```basic
REM %%PP A
```

ve:

```basic
REM %%PP B
```

korunmalı.

Hatta iki sistemi aynı dosyada kullanabilmek için:

```basic
REM %%PP A
...
REM %%PP B
...
REM %%PP A
...
```

mümkün olabilir.

Fakat burada **durum sızıntısı** oluşmaması için A/B yalnızca komut yetki kümesi seçmeli. Meta değişken havuzu ortak kalmalı.

---

# 10. Yeni meta model

Şimdi önemli kısma geldik.

Mevcut `PreprocessResult` **korunacak**.

Ama genişletilecek.

## 10.1 Kaynak öncesi veri

```freebasic
Type PreprocessResult
    expandedSource As String

    blocks(...)
    assets(...)
    watImports(...)
    manifest(...)
    ...

    attributes(...)       ' YENİ
    generatedFiles(...)   ' YENİ
    hostBindings(...)     ' YENİ
    exports(...)          ' YENİ
    imports(...)          ' YENİ
    routes(...)           ' YENİ
    endpoints(...)        ' YENİ
End Type
```

Fakat burada önemli bir ayrıntı:

`attributes()` sadece **ham attribute kayıtları** olacaktır.

AST sembol tablosuyla karışmayacaktır.

---

# 11. `MetaAttribute`

Şöyle yapardım:

```freebasic
Type MetaAttributeArg
    nameText As String
    valueText As String
    valueKind As Integer
End Type

Type MetaAttribute
    nameText As String

    args(0 To 15) As MetaAttributeArg
    argCount As Integer

    sourceFile As String
    sourceLine As Integer
    sourceColumn As Integer

    attachMode As Integer
    targetNode As Integer

    consumed As Integer
End Type
```

Örneğin:

```basic
REM @[Author("Mete")]
```

şöyle saklanır:

```text
nameText    = AUTHOR
arg[0]      = "Mete"
sourceLine  = 50
attachMode  = NEXT
targetNode  = -1
```

---

# 12. `MetaAttributeList`

AST düğümünün içine dev array gömmek yerine:

```freebasic
Type MetaAttributeList
    firstIndex As Integer
    count As Integer
End Type
```

ve merkezi havuz kullanmak daha mantıklı.

Çünkü AST zaten oldukça büyük.

---

# 13. ASTNode'a yalnızca iki alan ekleyelim

Mevcut `ASTNode`u inceledim. Şu anda zaten:

```freebasic
family
flags
typeName
symbolName
role
sourceFile
originalTokenKind
sourceOffset
sourceLength
lexemeSnippet
```

gibi güçlü alanları var.

Dolayısıyla dev değişiklik gerekmiyor.

Sadece:

```freebasic
metaFirst As Integer
metaCount As Integer
```

eklemek yeterli.

Yani:

```freebasic
Type ASTNode
    ...
    metaFirst As Integer
    metaCount As Integer
End Type
```

Bitti.

---

# 14. Attribute nasıl bağlanacak?

Örneğin:

```basic
REM @[Test]
REM @[Author("Mete")]
FUNCTION Hesapla(x AS I32) AS I32
```

Preprocessor şu kayıtları çıkarır:

```text
Test       line 10
Author     line 11
```

Parser FUNCTION'ı:

```text
line 12
```

olarak AST'ye koyar.

Yeni aşama:

```text
MetaBindAttributesToAst()
```

şunu yapar:

```text
10 TEST   ┐
11 AUTHOR ├──► FUNCTION Hesapla line 12
          ┘
```

Yani parser içine attribute grameri sokmamıza bile gerek yok.

Bu, bence çok daha iyi.

---

# 15. Bu katmanın adı

Dosya yapısı:

```text
src/meta/
```

olsun.

Altında:

```text
src/meta/
 ├─ meta_types.fbs
 ├─ meta_attribute.fbs
 ├─ meta_attribute_parser.fbs
 ├─ meta_attribute_binder.fbs
 ├─ meta_symbol_info.fbs
 ├─ meta_registry.fbs
 ├─ meta_reflection.fbs
 ├─ meta_codegen.fbs
 ├─ meta_json.fbs
 └─ meta_diagnostics.fbs
```

Bunu `preprocessor/` içine doldurmayalım.

Çünkü parser sonrası meta sistemi artık preprocessor değildir.

---

# 16. MetaSymbolInfo

İkinci büyük veri modeli:

```freebasic
Enum MetaSymbolKind
    META_SYMBOL_UNKNOWN = 0
    META_SYMBOL_MODULE
    META_SYMBOL_NAMESPACE
    META_SYMBOL_CLASS
    META_SYMBOL_INTERFACE
    META_SYMBOL_TYPE
    META_SYMBOL_FUNCTION
    META_SYMBOL_SUB
    META_SYMBOL_METHOD
    META_SYMBOL_PROPERTY
    META_SYMBOL_FIELD
    META_SYMBOL_PARAMETER
    META_SYMBOL_VARIABLE
End Enum
```

ve:

```freebasic
Type MetaSymbolInfo
    id As Integer

    nameText As String
    fullName As String

    kind As Integer
    typeName As String
    returnType As String

    astNode As Integer

    parentSymbol As Integer

    attributeFirst As Integer
    attributeCount As Integer

    fieldOffset As LongInt
    sizeBytes As LongInt
    alignment As Integer

    sourceFile As String
    sourceLine As Integer

    flags As ULongInt
End Type
```

Burada artık gerçek yansıma sistemi başlıyor.

---

# 17. Meta Registry

Program derlendikten sonra:

```text
MetaRegistry
```

şöyle görünür:

```text
CLASS User
 ├─ attribute Serializable
 ├─ field id : I32
 ├─ field name : STRING
 └─ method Save()

FUNCTION Topla
 ├─ return I32
 ├─ param a : I32
 ├─ param b : I32
 └─ attribute Test
```

Bu bilgi:

* derleme sırasında,
* JSON çıktısında,
* JS üretiminde,
* WASM export üretiminde,
* x64 metadata tablosunda

kullanılabilir.

---

# 18. İlk resmi attribute kümesi

Başlangıçta saçma sapan 90 attribute üretmeyelim. Onu birkaç hafta sonra insanlar yapar zaten.

İlk çekirdek küme:

| Attribute       | Görev                               |
| --------------- | ----------------------------------- |
| `Test`          | Test yöntemi                        |
| `Deprecated`    | Kullanımdan kaldırılmış sembol      |
| `Author`        | Belgelendirme meta bilgisi          |
| `Serializable`  | Serileştirme üretimi                |
| `Ignore`        | Meta üretimden çıkar                |
| `Export`        | Genel dışa aktarım                  |
| `DllExport`     | DLL dışa aktarımı                   |
| `JsExport`      | JavaScript'e aktarım                |
| `WasmExport`    | WASM dışa aktarımı                  |
| `ApiController` | API sınıfı                          |
| `GET`           | HTTP GET                            |
| `POST`          | HTTP POST                           |
| `PUT`           | HTTP PUT                            |
| `DELETE`        | HTTP DELETE                         |
| `Route`         | Yol tanımı                          |
| `Optimize`      | Derleme tercih bilgisi              |
| `Inline`        | Satır içi aday                      |
| `Reflect`       | Çalışma zamanı yansımasına dahil et |

Sözdizimi:

```basic
REM @[Test]
```

ve:

```basic
REM @[Deprecated("YeniFonksiyon kullan")]
```

ve:

```basic
REM @[Optimize("speed")]
```

---

# 19. Çoklu attribute

İki biçim desteklenebilir:

```basic
REM @[Test]
REM @[Author("Mete")]
```

ve kısa biçim:

```basic
REM @[Test, Author("Mete")]
```

Ama **kanonik biçim bir satır bir attribute** olsun.

Daha kolay:

* kaynak haritası,
* hata mesajı,
* IDE,
* formatter,
* diff.

---

# 20. Sınıf üzerinde kullanım

```basic
REM @[Serializable]
REM @[Reflect]
CLASS FishSample

    DIM id AS I32
    DIM species AS STRING
    DIM weight AS F64

END CLASS
```

Meta registry:

```text
FishSample
    Serializable
    Reflect

fields:
    id       I32
    species  STRING
    weight   F64
```

Bundan otomatik:

```text
ToJson
FromJson
metadata
JS schema
```

üretilebilir.

---

# 21. API sistemi

Örneğin:

```basic
REM @[ApiController("/api/fish")]
CLASS FishApi

    REM @[GET("/{id}")]
    FUNCTION GetFish(id AS I32) AS DICT
        ...
    END FUNCTION

    REM @[POST("/")]
    FUNCTION AddFish(data AS DICT) AS DICT
        ...
    END FUNCTION

END CLASS
```

Meta üretici bundan:

```text
/api/fish/{id} GET → FishApi.GetFish
/api/fish/      POST → FishApi.AddFish
```

çıkarır.

Ve B sistemi:

```text
routes.json
bridge.js
OpenAPI benzeri tanım
JS istemci kodu
sunucu dispatch tablosu
```

üretebilir.

---

# 22. Önişlemci B ile attribute sistemi burada birleşiyor

Bu kritik.

Attribute:

```basic
REM @[JsExport]
FUNCTION Calculate(x AS F64) AS F64
```

AST/meta registry tarafında semantik anlam taşır.

B ise bunu görür:

```text
JsExport
    ↓
host export generator
    ↓
bridge.js
```

Yani:

```text
Attribute
      ↓
AST
      ↓
Meta Registry
      ↓
Artifact Generator B
```

Bu tam aradığımız bağlantı.

---

# 23. Hazır HTML/JS/CSS dosyasını değiştirme

Senin özellikle istediğin özellik için resmi yapı:

```basic
REM %%PP B

REM %%SET TITLE = "PCR Kontrol"
REM %%SET HAS_GRAPH = 1

REM %%TEMPLATE_FILE "templates/index.html"
REM %%GEN_FILE "dist/index.html" HTML
```

Şablon:

```html
<title>{{TITLE}}</title>

{{#IF HAS_GRAPH}}
<script src="graph.js"></script>
{{#ENDIF}}
```

Burada ayrı bir `TEMPLATE_FILE` sistemine ihtiyaç var.

Mevcut sistemde `TEMPLATE`, `TEMPLATE_BEGIN`, `TEMPLATE_USE` var ama dosya tabanlı ürün üretimi için bu yapı açıkça genişletilmeli.

Ben eklerdim:

```text
TEMPLATE_FILE
TEMPLATE_OUT
TEMPLATE_PARAM
TEMPLATE_APPLY
```

Örneğin:

```basic
REM %%TEMPLATE_FILE WEBUI "templates/index.html"
REM %%TEMPLATE_PARAM WEBUI TITLE = "uXBasic"
REM %%TEMPLATE_PARAM WEBUI THEME = "dark"
REM %%TEMPLATE_APPLY WEBUI TO "dist/index.html"
```

---

# 24. Hazır dosyanın yalnız belirli bölgesini değiştirme

Daha güçlü biçim:

HTML:

```html
<!-- UXB:BEGIN MENU -->
...
<!-- UXB:END MENU -->
```

uXBasic:

```basic
REM %%PATCH_BLOCK "templates/index.html" "MENU"

REM %%HTML_BEGIN
<nav>...</nav>
REM %%HTML_END

REM %%PATCH_END
```

Böylece bütün HTML yeniden oluşturulmaz.

Sadece tanımlı bölge değişir.

Bu çok kullanışlı.

---

# 25. JS için aynı şey

Hazır JavaScript:

```javascript
// UXB:BEGIN IMPORTS
// UXB:END IMPORTS

// UXB:BEGIN ROUTES
// UXB:END ROUTES
```

uXBasic:

```basic
REM %%PATCH_BLOCK "app.js" "ROUTES"

REM %%JS_BEGIN
...
REM %%JS_END

REM %%PATCH_END
```

Derleyici yalnız o bölümü üretir.

Programcı gerisini istediği gibi yazabilir.

**Bence senin "programcıya esneklik" dediğin noktanın doğru uygulaması bu.**

---

# 26. EXE ↔ tarayıcı bağlantısı

Buraya yeni bir kavram gerekiyor:

```text
BRIDGE
```

Örneğin:

```basic
REM %%BRIDGE_BEGIN BrowserHost
REM %%BRIDGE_TRANSPORT WEBSOCKET
REM %%BRIDGE_HOST "127.0.0.1"
REM %%BRIDGE_PORT AUTO
REM %%BRIDGE_END
```

ve:

```basic
REM @[JsExport]
FUNCTION GetTemperature() AS F64
```

sonuçta:

```text
uXBasic EXE
    ↕
WebSocket
    ↕
generated bridge.js
    ↕
browser
```

oluşur.

---

# 27. WASM hedefinde aynı kaynak

Aynı:

```basic
REM @[JsExport]
FUNCTION GetTemperature() AS F64
```

WASM hedefinde:

```text
uXBasic
 ↓
MIR
 ↓
WASM export
 ↓
JS glue
 ↓
browser
```

olabilir.

Programcı köprünün iç ayrıntısını değiştirmez.

Bu çok önemli.

---

# 28. Yeni B komut ailesi

Ben şu komutları eklerdim:

### Köprü

```text
BRIDGE_BEGIN
BRIDGE_END
BRIDGE_TRANSPORT
BRIDGE_HOST
BRIDGE_PORT
BRIDGE_PROTOCOL
```

### Şablon

```text
TEMPLATE_FILE
TEMPLATE_PARAM
TEMPLATE_APPLY
```

### Dosya yama

```text
PATCH_FILE
PATCH_BLOCK
PATCH_APPEND
PATCH_PREPEND
PATCH_REPLACE
PATCH_END
```

### Veri

```text
DATA_EXPORT
DATA_IMPORT
DATA_FORMAT
DATA_SCHEMA
```

### Ürün

```text
GEN_FILE
GEN_BLOCK
GEN_END
BUNDLE_NAME
BROWSER_ENTRY
SCRIPT_ENTRY
STYLE_ENTRY
```

Mevcut olanları yeniden icat etmiyoruz.

Eksikleri tamamlıyoruz.

---

# 29. Veri köprüsü

Bir de resmi tür eşleme tablosu gerekir.

| uXBasic | JS           | WASM              |
| ------- | ------------ | ----------------- |
| I32     | number       | i32               |
| U32     | number       | i32               |
| I64     | bigint       | i64               |
| F32     | number       | f32               |
| F64     | number       | f64               |
| BOOLEAN | boolean      | i32               |
| STRING  | string       | ptr+len           |
| BYTE[]  | Uint8Array   | ptr+len           |
| ARRAY   | Array        | memory descriptor |
| DICT    | Object       | JSON/descriptor   |
| OBJECT  | object/proxy | handle            |

Bu sistem `HOST_IMPORT`, `EXPORT_BASIC`, `[JsExport]`, `[WasmExport]` gibi bütün özelliklerin ortak sözleşmesi olmalı.

---

# 30. `REM %%` lexer değişikliği

Mevcut fonksiyon çok küçük.

Bugün:

```freebasic
If Left(trimmed, 2) <> "%%" Then
    Return 0
End If
```

Yeni mantık:

```text
LTrim
 │
 ├─ %%...         → legacy meta
 │
 ├─ REM %%...     → canonical preprocessor
 │
 ├─ REM @[...]    → attribute
 │
 └─ diğer REM     → normal comment
```

Burada önemli kural:

```basic
REM bu normal açıklamadır
```

asla meta kabul edilmez.

Yalnız:

```basic
REM %%
```

ve:

```basic
REM @[
```

özel anlam taşır.

---

# 31. `'` yorumlarında meta komut olmasın

Şunu önermiyorum:

```basic
' %%DEFINE X 1
```

Tek kanonik biçim:

```basic
REM %%DEFINE X 1
```

olsun.

Neden?

Çünkü `'` zaten kaynak içinde çok rahat kullanılıyor.

`REM %%` ise görsel olarak da meta komut olduğunu belli ediyor.

Daha az belirsizlik.

---

# 32. `REM META` biçimini de kullanmayalım

Şöyle bir şey yapılabilir:

```basic
REM META DEFINE X 1
```

ama bunu önermiyorum.

`%%` mevcut uXBasic sisteminin dilidir.

Dolayısıyla:

```basic
REM %%DEFINE
```

eski sistemle doğal bir geçiş sağlar.

---

# 33. Eski `%%` biçimine ne olacak?

Kırmayalım.

Aşamalar:

### Aşama 1

İkisi de çalışır:

```basic
%%DEFINE X 1
REM %%DEFINE X 1
```

### Aşama 2

Araçlar yeni kaynak oluştururken:

```basic
REM %%...
```

yazar.

### Aşama 3

Eski biçim:

```text
LEGACY_PREPROCESSOR_SYNTAX
```

uyarısı verebilir.

Ama kaldırılması şart değil.

---

# 34. Reflection yani yansıma sistemi

Burada artık `TYPEOF` tek başına yeterli değil.

Yeni çalışma zamanı fonksiyonları düşünülebilir:

```basic
TYPEOF(x)
CLASSOF(x)

METATYPE("Fish")
METAFIELD("Fish", "weight")
METAMETHOD("Fish", "Save")

HASATTRIBUTE("Fish", "Serializable")
```

Ama hepsi çalışma zamanına taşınmamalı.

`REM @[Reflect]` ile seçelim:

```basic
REM @[Reflect]
CLASS Fish
...
END CLASS
```

Yalnız bu sınıf runtime reflection tablosuna girsin.

Böylece EXE gereksiz meta veriyle şişmez.

---

# 35. Derleme zamanı reflection

Daha da güçlü olanı:

```basic
REM %%FOREACH_FIELD Fish AS F
...
REM %%ENDFOREACH
```

olabilir.

Ama burada önemli mimari sorun var:

Önişlemci AST'den **önce** çalışıyor.

Dolayısıyla A'nın ilk geçişinde `Fish` alanlarını bilemez.

Bunun için meta sistem iki geçişli olmalı.

---

# 36. İki geçişli meta derleme

Bu bence nihai sistemin en önemli noktalarından biri:

```text
META PASS 0
REM %% komutları
       ↓
kaynak üretimi

LEXER/PARSER
       ↓
AST

META PASS 1
REM @[] bağlama
       ↓
Meta Registry

META PASS 2
AST bilgisine dayalı kod üretme
       ↓
yeniden üretilmiş kaynak / ürün

SEMANTIC → MIR
```

Bu sayede:

```basic
REM %%GENERATE_SERIALIZER Fish
```

gibi komutlar sınıf alanlarını gerçekten görebilir.

---

# 37. Bunun daha düzgün biçimi

Aslında:

```text
PRE-META
POST-META
```

şeklinde iki kavram kullanabiliriz.

### PRE

```basic
REM %%...
```

AST öncesi.

### POST

```basic
REM %%POST ...
```

AST sonrası.

Örneğin:

```basic
REM %%POST GENERATE_SERIALIZER Fish
```

Bu çok güçlü olur.

---

# 38. Fakat ilk sürümde `POST` şart değil

İlk sürümü gereksiz büyütmeyelim.

İlk meta sistemi:

1. `REM %%` desteği
2. `REM @[]` attribute desteği
3. AST bağlama
4. MetaRegistry
5. JSON dışa aktarım
6. `[Test]`
7. `[Deprecated]`
8. `[Serializable]`
9. `[Export]`
10. `[JsExport]`
11. `[WasmExport]`

ile çıkarılabilir.

Sonra AST sonrası meta üretim eklenir.

---

# 39. Mevcut koddaki bir hata da düzeltilmeli

20.09 kaynakta ilginç bir tarihsel tutarsızlık hâlâ var.

`preprocess_parser.fbs` içinde:

```freebasic
Function UXBPreParseIsUnimplementedCanonicalDirective(...)
...
Case "EMBEDBASE64", "GEN_BLOCK", "GEN_END"
```

hâlâ "uygulanmamış" olarak sınıflandırılıyor.

Ama aynı 20.09 kaynakta:

* `EMBEDBASE64` için gerçek işleyici var,
* `GEN_BLOCK` blok tarayıcıda var,
* `GEN_END` kapanış olarak var.

Yani bu liste artık yanlış.

Yeni meta çalışmasında **ilk temizlenecek yerlerden biri bu**.

Çünkü aksi halde derleyicinin kendi komut sözleşmesi kendisiyle çelişiyor. Küçük bir trajikomedi, ama kolay düzeltilebilir.

---

# 40. Kesin dosya mimarisi

Ben mevcut projeye şunu eklerdim:

```text
src/
│
├─ preprocessor/
│   ├─ preprocess_engine.fbs
│   ├─ preprocess_lexer.fbs
│   ├─ preprocess_parser.fbs
│   ├─ preprocess_meta_model.fbs
│   ├─ preprocess_selector.fbs
│   │
│   ├─ commands/
│   │   ├─ preprocess_commands_a.fbs
│   │   ├─ preprocess_commands_common.fbs
│   │   └─ preprocess_commands_b.fbs
│   │
│   └─ PreproesssorB/     ← zamanla buradan taşınır
│
├─ meta/
│   ├─ meta_types.fbs
│   ├─ meta_attribute_parser.fbs
│   ├─ meta_attribute_pool.fbs
│   ├─ meta_attribute_binder.fbs
│   ├─ meta_symbol_info.fbs
│   ├─ meta_registry.fbs
│   ├─ meta_reflection.fbs
│   ├─ meta_codegen.fbs
│   ├─ meta_json.fbs
│   └─ meta_diagnostics.fbs
│
├─ parser/
├─ semantic/
├─ mir/
└─ codegen/
```

Bir de mevcut klasör adı:

```text
PreproesssorB
```

yazım hatalı.

Uzun vadede:

```text
commands/b
```

veya:

```text
preprocessor/b
```

olması daha mantıklı.

Ama sırf estetik için şimdi rename yapıp include zincirini bozmayalım.

---

# 41. Kanonik örnek

Son sistemde bir uXBasic program şöyle görünebilir:

```basic
REM =====================================================
REM uXBasic Web + Native uygulama
REM =====================================================

REM %%PP A
REM %%DEFINE DEBUG 1
REM %%SET APP_NAME = "PCR Monitor"

REM %%PP B
REM %%TARGET WEB
REM %%OUTDIR "dist"
REM %%BUNDLE_NAME "{{APP_NAME}}"

REM %%TEMPLATE_FILE MAIN_HTML "templates/index.html"
REM %%TEMPLATE_PARAM MAIN_HTML TITLE = "{{APP_NAME}}"
REM %%TEMPLATE_APPLY MAIN_HTML TO "dist/index.html"

REM %%BRIDGE_BEGIN BrowserBridge
REM %%BRIDGE_TRANSPORT WEBSOCKET
REM %%BRIDGE_PORT AUTO
REM %%BRIDGE_END


REM @[Serializable]
REM @[Reflect]
TYPE TemperatureData
    value AS F64
    time AS I64
END TYPE


REM @[JsExport]
REM @[WasmExport]
FUNCTION ReadTemperature() AS F64
    RETURN 95.0
END FUNCTION


REM @[ApiController("/api")]
CLASS Api

    REM @[GET("/temperature")]
    FUNCTION Temperature() AS F64
        RETURN ReadTemperature()
    END FUNCTION

END CLASS


REM @[Test]
FUNCTION TestTemperature() AS BOOLEAN
    RETURN ReadTemperature() > 0
END FUNCTION
```

Tek kaynak.

Bundan teorik olarak:

```text
build/
├─ program.exe
├─ program.wasm
├─ program.wat
│
├─ web/
│   ├─ index.html
│   ├─ app.js
│   ├─ bridge.js
│   └─ style.css
│
├─ meta/
│   ├─ symbols.json
│   ├─ routes.json
│   ├─ exports.json
│   └─ manifest.json
│
└─ tests/
    └─ generated_test_manifest.json
```

çıkabilir.

İşte o noktada uXBasic artık sadece bir BASIC derleyicisi değil, **kendi kaynak kodunu ve çevresindeki uygulamayı tarif edebilen çok hedefli bir programlama sistemi** haline gelir.

## Kesin karar özeti

Bu tasarımda dört şeyi birbirine karıştırmıyoruz:

```text
REM %%...       = kaynak öncesi meta komut
REM @[...]      = AST özelliği
PreprocessResult = parser öncesi dünya
MetaRegistry     = parser sonrası dünya
```

Ve bunun üzerine:

```text
A = uXBasic kaynak üretimi
B = dış ürün/web/host üretimi
MetaRegistry = programın kendisini tanıması
Bridge = EXE / JS / Browser / WASM haberleşmesi
```

oturuyor.

**Bence bu, mevcut 20.09 uXBasic kaynak mimarisini yıkmadan ulaşabileceğimiz en temiz nihai tasarım.** Özellikle `REM %%` seçimi önemli: mevcut önişlemciyi çöpe atmıyoruz, yalnızca uXBasic kaynak dilinin içinde doğal ve güvenli bir meta katmana dönüştürüyoruz.


