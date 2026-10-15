# S-146 — Görevler Arası Paylaşılan Veri: Tasarım Önerisi

Tarih: 2026-09-25 · Hazırlayan: Claude 1 · Durum: **D1–D6 KARARLANDI (Mete, 2026-09-25)** — Claude itirazları/ek
maddeleri belgenin sonunda (§8); İ1, İ2 ve İ3 için Mete onayı bekleniyor · S-030 Faz 2'nin ön koşulu

Bu belge, Mete'nin S-030 K3 kararını (SPAWN sınırında varsayılan izolasyon) somut derleyici kurallarına çevirir ve
ileride açılacak açık paylaşım modelini (`SHARED / ATOMIC / MUTEX / LOCK`) önerir. Kodda henüz hiçbir şey
uygulanmadı; aşağıdaki "Karar soruları" cevaplanınca Faz 2 ile birlikte uygulanır.

## 1. Bugünkü durum (2026-09-25)

- `SPAWN`, `TASK`, `TASK OF T`, `TASKGROUP` AST ve canonical-MIR'de **senkron** çalışıyor (Faz 1/1B, 108/108 test).
- Görev gövdesi bugün çağıranla aynı yığın çerçevesinde çalıştığı için global değişkenlere erişebiliyor. Faz 2'de
  gövde başka bir OS iş parçacığında çalışacağı için bu erişim **veri yarışı** (iki iş parçacığının aynı belleğe aynı
  anda yazması) üretir — sonuç rastgele bozulur.
- `SHARED`, `ATOMIC`, `MUTEX`, `LOCK` sözcüklerinin hiçbiri dilde kullanılmıyor (lexer'da yok); ad çakışması yok.
- Native çalışma zamanı ABI v1: `callback(slot, int girdi, int* çıktı)` — yalnız tamsayı taşıyor; Faz 2 için v2 gerekecek.

## 2. K3'ün derleyici kuralları (Faz 2'den ÖNCE semantik katmanda, tüm motorlarda aynı)

K3 metni: skaler BYVAL izinli; kopyası güvenli değer izinli; CONST okunabilir; değiştirilebilir global, BYREF,
CLASS/LIST/DICT ve PTR SPAWN sınırından geçemez; eski TRIGGER bundan etkilenmez.

Önerilen kesin kural kümesi (her biri tek, açık bir derleme hatası):

| # | Kural | Örnek hata |
|---|---|---|
| R1 | SPAWN argümanı yalnız skaler (I8..U64, F32/F64/F80, BOOLEAN), STRING (kopyalanır) ya da `copy_model=bitcopy` kütüphane değer tipi (örn. RATIONAL) olabilir | `SPAWN: CLASS/LIST/DICT/PTR arguman gorev sinirindan gecemez: lst` |
| R2 | THREAD/PARALEL parametre tipi de R1 ile sınırlı (BYREF zaten yasak) | `THREAD Worker: parametre tipi LIST gorev sinirindan gecemez` |
| R3 | `TASK OF T`'de T de R1 ile sınırlı (sonuç da sınırdan geçer) | `TASK OF LIST desteklenmiyor` |
| R4 | THREAD/PARALEL gövdesi modül düzeyi (global) **değiştirilebilir** değişkeni okuyamaz/yazamaz; CONST serbest | `THREAD Worker: global degisken 'toplam' gorevde kullanilamaz (S-146 SHARED modeli gelene kadar)` |
| R5 | R4 **geçişlidir**: görev gövdesinin çağırdığı SUB/FUNCTION'lar (ve onların çağırdıkları) da global değişken kullanamaz | `THREAD Worker -> Hesapla(): global 'sayac' kullaniyor` |
| R6 | Görev gövdesinde `INPUT` (klavye) yasak; `PRINT` serbest (tek PRINT atomik, K karar 9) | `THREAD Worker: INPUT gorev icinde kullanilamaz` |

R5 için derleyici her rutin için bir "global dokunuşu" özeti çıkarır (çağrı grafiği üzerinde sabit nokta). Bu, ayrıca
dilin geneline yarar: hangi rutinin yan etkisiz olduğu bilinir.

**Kapsam (K3: "eski TRIGGER semantiği etkilenmez"):** R2 ve R4–R6 yalnız programda **SPAWN hedefi olan**
THREAD/PARALEL gövdelerine uygulanır. Yalnız `TRIGGER` ile çağrılan THREAD/PARALEL bugünkü gibi (senkron, çağıranın
bağlamında) çalışmaya devam eder ve bu kurallardan etkilenmez. Aynı gövde hem TRIGGER hem SPAWN ile kullanılıyorsa
SPAWN kuralları geçerlidir.

## 3. Açık paylaşım modeli önerisi (K3'ün "SHARED/ATOMIC/MUTEX benzeri açık paylaşım" maddesi)

Hedef: güvenli varsayılan + sistem programlamaya kapı. Öneri, derleme zamanında denetlenebilen üç yapı:

### 3.1 `ATOMIC` tipler — kilitsiz sayaçlar/bayraklar
```basic
SHARED sayac AS ATOMIC I64
...
THREAD Worker(x AS I32) AS I32
    sayac.ADD(1)
    RETURN x
END THREAD
PRINT sayac.LOAD()
```
- Genişlikler: I32, I64, U32, U64, BOOLEAN.
- Üyeler (TASK üyeleriyle aynı nokta sözdizimi): `.LOAD()`, `.STORE(v)`, `.ADD(v)` (eski değeri döndürür), `.SUB(v)`,
  `.EXCHANGE(v)`, `.CAS(beklenen, yeni)` (BOOLEAN).
- ATOMIC değişkene düz atama/okuma (`sayac = 5`, `PRINT sayac`) derleme hatası — her erişim açık üye çağrısı.

### 3.2 `MUTEX` + `LOCK ... END LOCK` + `GUARDED BY` — kilitle korunan veri
```basic
SHARED kilit AS MUTEX
SHARED toplam AS I64 GUARDED BY kilit
...
LOCK kilit
    toplam = toplam + x
END LOCK
```
- `GUARDED BY m` ile bildirilen SHARED değişkene **yalnız** `LOCK m ... END LOCK` bloğu içinde erişilebilir; derleyici
  bunu statik olarak denetler (blok dışı erişim derleme hatası). Böylece "kilidi almayı unuttum" hatası hiç derlenmez.
- `LOCK` bloğundan her çıkışta (normal bitiş, `EXIT`, `RETURN`, THROW) kilit otomatik bırakılır.
- Aynı iş parçacığının aynı kilidi tekrar alması (öz-kilitlenme) çalışma zamanında açık hata verir (yeniden girişli değil).
- Birden fazla kilidi aynı anda almak için tek sözdizimi: `LOCK a, b ... END LOCK` — çalışma zamanı kilitleri sabit
  bir sırayla alır (adres sırası), iki görevin ters sırada kilit alıp birbirini beklemesi (deadlock) bu yolla önlenir.

### 3.3 CLASS/LIST/DICT: sahiplik aktarımı (`MOVE`)
```basic
DIM veriler AS LIST
...
DIM t AS TASK OF I64 = SPAWN Topla(MOVE veriler)   ' veriler burada NULL olur
```
- `MOVE x` sahipliği göreve devreder, çağıranın değişkeni NULL olur: aynı nesneye iki iş parçacığı dokunamaz.
- Sonuç yönü: `TASK OF LIST` gibi sonuçlar da taşınarak döner (JOIN'den sonra çağıran sahip olur).
- S-134 kütüphane tipi yaşam döngüsü (`MOVE_ONLY`) ile aynı sözlük; ayrı bir ikinci model kurulmaz.

### 3.4 PTR / paylaşılan native bellek
S-056 MemoryRef tamamlanana kadar ertelenir; sonra `SHARED bolge AS MEMORY(boyut)` benzeri açık bölge + ATOMIC/LOCK
erişim kuralıyla gelir.

## 4. Hedefler arası karşılık

| Yapı | Native x64 (Faz 2) | JS (Faz 3, Antigravity) | WASM (Faz 4) |
|---|---|---|---|
| İzolasyon R1–R6 | Derleyici | Derleyici (Worker zaten bellek paylaşmaz) | Derleyici |
| ATOMIC | CPU atomik komutları | `SharedArrayBuffer` + `Atomics` | wasm threads atomikleri |
| MUTEX/LOCK | OS kilidi | `Atomics.wait/notify` | wasm threads |
| MOVE | işaretçi devri | `postMessage` transfer / yapısal klon | tutamaç devri |

Tarayıcıda `SharedArrayBuffer` yalnız sayfa özel güvenlik başlıklarıyla (COOP/COEP) sunulursa vardır; yoksa ATOMIC/MUTEX
kullanan programlar için bir karar gerekir (Karar sorusu D5).

## 5. Faz 2 çalışma zamanı gereksinimleri (kayıt; bu belgenin kararlarıyla birlikte uygulanır)

- ABI v2: görev çalıştırma tablosu (TaskRun: id, durum, sonuç, hata, iptal bayrağı), genel değer taşıma (tamsayı,
  F64, STRING, library değer tipi), K4 worker havuzu (AUTO = mantıksal CPU, `--task-workers N`), bekleyen worker'ın
  kuyruktan iş çalıştırması (iç içe SPAWN kilitlenmesin).
- Native kodda bugün süreç-genel olan durumlar iş parçacığına özel olmalı: istisna/THROW durumu, geçici metin
  tamponları; PRINT tek bir kilit altında (K karar 9).
- K5 kapanış, K6 işbirlikçi iptal: derleyici görev rutinlerinde döngü geri dönüşlerine ve WAIT/JOIN/SPAWN noktalarına
  iptal denetimi yerleştirir.

## 6. Karar soruları (Mete)

- **D1 — R5 geçişli denetim:** Görevin çağırdığı rutinler de global kullanamasın mı? (Öneri: **evet**; yoksa
  `THREAD` içinden çağrılan tek bir yardımcı fonksiyon bütün güvenliği deler.)
- **D2 — Paylaşım modeli:** §3.1 ATOMIC + §3.2 MUTEX/LOCK/GUARDED BY birlikte mi? (Öneri: **evet**; GUARDED BY
  derleme zamanı denetimi en büyük güvenlik kazancı.) Alternatif: yalnız ATOMIC + LOCK (GUARDED BY'sız, kilit kullanımı
  programcıya kalır).
- **D3 — CLASS/LIST/DICT:** `MOVE` (sahiplik devri) mi, `CLONE` (derin kopya) mı, ikisi mi? (Öneri: **ikisi** —
  `MOVE` varsayılan önerilen yol, `CLONE` açık kopya.)
- **D4 — Kilit yeniden girişi:** Aynı görev aynı kilidi ikinci kez alırsa hata mı (öneri), bekleme mi (kendini
  kilitler), izin mi (yeniden girişli)?
- **D5 — JS/WASM'da SharedArrayBuffer yoksa:** ATOMIC/MUTEX kullanan program (a) açık hata ile reddedilsin mi (öneri),
  (b) tek iş parçacığında sıralı çalışsın mı?
- **D6 — Uygulama sırası:** R1–R6 izolasyon kuralları Faz 2'den önce AST/MIR'e eklensin mi (öneri: **evet** — bugün
  senkron çalışan ama Faz 2'de yarış üretecek programlar şimdiden reddedilir, davranış sonradan değişmez).

------------  C E V A P  ------------

Evet Mete abi. 25.09 ZIP’i, güncel `ai_koordinasyon` defterlerini, `docs/tasarim` uzlaştırma belgelerini, S-134 kütüphane tipi yaşam döngüsünü ve `planyap` içindeki eski planları birlikte kontrol ettim. Claude’un S-146 belgesindeki **D1-D6 sorularına artık karar verecek kadar veri var**.

Önce önemli güncelleme: S-146 belgesindeki başlangıç durumu doğru. `SPAWN/TASK/TASK OF T/TASKGROUP` artık AST ve kanonik MIR’de senkron referans olarak çalışıyor; native gerçek eşzamanlılık için ABI v2 gerekiyor ve `SHARED/ATOMIC/MUTEX/LOCK` henüz dil yüzeyinde uygulanmış değil.  Ayrıca S-146’nın R1-R6 izolasyon kurallarının yalnız `SPAWN` yoluna uygulanıp eski `TRIGGER` davranışını koruması da önceki kararlarımızla uyumlu. 

# D1-D6 için kararlarımız

| Soru                                                  | Karar                                                                                              |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **D1. Çağrılan yordamlar da global kullanamasın mı?** | **EVET. Geçişli denetim zorunlu.**                                                                 |
| **D2. ATOMIC + MUTEX/LOCK/GUARDED BY birlikte mi?**   | **ATOMIC + SHARED + MUTEX + LOCK birlikte olacak; zorunlu `GUARDED BY` modelini kabul etmiyorum.** |
| **D3. CLASS/LIST/DICT için MOVE mı, CLONE mı?**       | **İKİSİ DE.** Fakat aynı şey değiller ve aşamalı uygulanacaklar.                                   |
| **D4. Aynı TASK aynı kilidi ikinci kez alırsa?**      | **Açık çalışma zamanı hatası.** Varsayılan mutex yeniden girişli olmayacak.                        |
| **D5. JS/WASM paylaşılan bellek yeteneği yoksa?**     | **Açık hedef/yetenek hatası. Sessiz tek iş parçacığına düşüş YOK.**                                |
| **D6. R1-R6 Faz 2'den önce mi uygulanmalı?**          | **EVET.** Önce güvenli izolasyon, sonra gerçek native eşzamanlılık.                                |

Şimdi bunları ayrıntılı olarak kilitleyelim.

---

## D1: Geçişli görev güvenliği kesinlikle olacak

Claude’un önerdiği R5 doğru:

```basic
DIM toplam AS I64

SUB Yardimci()
    toplam += 1
END SUB

THREAD Worker()
    Yardimci()
END THREAD

t = SPAWN Worker()
```

Burada yalnız `Worker` gövdesine bakıp:

> global kullanmıyor

demek yanlış olur. `Yardimci()` üzerinden global duruma ulaşıyor.

Dolayısıyla her yordam için bir **etki özeti** çıkaracağız:

```text
READS_GLOBAL_MUTABLE
WRITES_GLOBAL_MUTABLE
USES_RAW_PTR
USES_SHARED
USES_ATOMIC
USES_UNSAFE_FFI
USES_INPUT
BLOCKS
SPAWNS
```

ve çağrı grafiğinde geçişli olarak yayacağız.

Özyineleme de sorun değil. Örneğin:

```basic
FUNCTION A(n AS I32) AS I32
    IF n == 0 THEN RETURN 0
    RETURN B(n - 1)
END FUNCTION

FUNCTION B(n AS I32) AS I32
    IF n == 0 THEN RETURN 0
    RETURN A(n - 1)
END FUNCTION
```

için çağrı grafiğinin özyinelemeli kümesi sabit noktaya kadar analiz edilir.

**Bilinmeyen dinamik çağrı veya FFI de güvenli varsayılmayacak.** Sağlayıcı sözleşmesi yoksa `SPAWN` güvenlik analizinde reddedilecek.

Burada bir incelik var: `CONST` bir **değer tipi** ise güvenlidir. Fakat:

```text
CONST pointer/reference → mutable nesne
```

olması onu derinlemesine immutable yapmaz. `CONST` veya `READONLY` tek başına “thread-safe” kanıtı değildir.

---

# D2: Claude’un `GUARDED BY` kısmını değiştirelim

Claude şunu öneriyor:

```basic
SHARED kilit AS MUTEX
SHARED toplam AS I64 GUARDED BY kilit

LOCK kilit
    toplam += 1
END LOCK
```



Ben bunun ana model olmasını istemiyorum. Çünkü önceki tasarımımız daha sade ve daha güçlü:

```basic
DIM SHARED toplam AS I64
```

dediğimiz anda `toplam`ın kendi çalışma zamanı kilidi vardır.

Kullanım:

```basic
LOCK toplam
    toplam += 1
END LOCK
```

Derleyici zaten bilir:

```text
toplam
    sharedId
    lockId
    generation
```

Dolayısıyla kilidi unutursan:

```basic
toplam += 1
```

`SPAWN` bağlamında **derleme hatası**.

### Neden daha iyi?

Çünkü şu ilişki hiçbir zaman belirsizleşmiyor:

```text
hangi mutex hangi veriyi koruyor?
```

Cevap:

> SHARED veri kendi kilidini taşır.

Bu, `GUARDED BY` eşleştirme tabloları kurmaktan daha basit.

### MUTEX yine gerekiyor

Ama başka amaçla:

```basic
DIM dllLock AS MUTEX

LOCK dllLock
    CALL(DLL, ...)
END LOCK
```

veya birkaç işlemi tek kritik bölge yapmak için.

Dolayısıyla nihai aile:

```basic
DIM SHARED durum AS SensorState
DIM ATOMIC sayac AS U64 = 0
DIM dllLock AS MUTEX
```

olacak.

**`ATOMIC` zaten paylaşılmış demektir.**

Şunu kullanmayalım:

```basic
DIM SHARED ATOMIC sayac AS I64
```

gereksiz iki kez aynı şeyi söylüyor.

---

# ATOMIC sözdizimi

Claude'un önerdiği açık üyeler faydalı:

```basic
sayac.LOAD()
sayac.STORE(10)
sayac.ADD(1)
sayac.SUB(1)
sayac.EXCHANGE(0)
sayac.CAS(10, 20)
```

Ama normal uXBasic kullanımını da koruyabiliriz:

```basic
x = sayac
sayac = 10
sayac += 1
```

Bunların anlamı:

```text
x = sayac      → ATOMIC_LOAD
sayac = 10     → ATOMIC_STORE
sayac += 1     → ATOMIC_ADD
```

olur.

Fakat:

```basic
sayac = sayac + 1
```

derleyici tarafından uyarı değil **hata** yapılabilir, çünkü bu:

```text
LOAD
hesapla
STORE
```

şeklinde iki ayrı atomik işlem olur ve kayıp güncelleme mümkündür.

İlk bellek sırası:

```text
SEQ_CST
```

yani sıralı tutarlılık olsun.

C++/native, JS `Atomics` ve WASM atomikleri için ortak anlam verir.

---

# D3: MOVE ve CLONE ikisi de olacak

Burada Claude’un önerisine katılıyorum, fakat önemli bir şartla.

25.09 kaynakta kütüphane tipi yaşam döngüsü zaten:

```text
storage_model
copy_model
clone_model
drop_model
```

alanlarını taşıyor ve lifecycle ailesinde:

```text
COPY
MOVE
CLONE
RETAIN
DROP
```

isimleri tanınıyor.

Ama S-134 belgesi çok açık: **`MOVE` lifecycle adı bugün metadata olarak var, fakat genel MOVE sözdizimi ve moved-from denetimi henüz uygulanmış değil.**

Dolayısıyla ikinci bir görev-özel sahiplik sistemi icat etmeyeceğiz.

### CLONE

```basic
DIM ikinci AS LIST
ikinci = CLONE(orijinal)
```

anlamı:

> bağımsız yeni nesne üret.

Kaynak değişmeden kalır.

Kütüphane tipi için descriptor:

```text
copy_model
clone_model
CLONE provider
```

kullanılır.

### MOVE

```basic
t = SPAWN Process(MOVE(veriler))
```

anlamı:

> veriler nesnesinin sahipliğini TASK'a devret.

Sonrasında:

```text
veriler = MOVED/NULL
```

olur.

Şu:

```basic
PRINT LISTLEN(veriler)
```

artık hata vermelidir.

Ama bu **S-030 Faz 2A'ya girmesin**.

Önce:

```text
R1-R6
scalar/value snapshot
native worker pool
```

çalışsın.

Sonra S-134 genel lifecycle lowering'iyle birlikte:

```text
MOVE
CLONE
RETAIN
DROP
```

gerçek sahiplik mekanizmasına bağlansın.

Bu, iki ayrı yaşam döngüsü sistemi kurmamızı engeller.

---

# Kütüphane tiplerinde ayrıca TASK sözleşmesi gerekiyor

Burada S-134 tek başına yetmez.

Örneğin:

```text
copy_model = retain
```

demek:

> ömrü uzatabilirim

demektir.

Şu anlama **gelmez**:

> iki TASK aynı payload'ı güvenli biçimde kullanabilir.

Bu yüzden library type descriptor genişlemeli:

```text
taskTransfer
threadSafety
sharedPolicy
```

Örneğin:

```text
taskTransfer:
    FORBID
    COPY
    MOVE
    RETAIN
    SHARE

threadSafety:
    NONE
    IMMUTABLE
    INTERNAL
    EXTERNAL_LOCK
    THREAD_AFFINE
```

`RATIONAL` gibi VALUE/BITCOPY tip:

```text
COPY
IMMUTABLE
```

olabilir.

GPU context:

```text
FORBID
THREAD_AFFINE
```

olabilir.

Mutable dataframe:

```text
SHARE
EXTERNAL_LOCK
```

olabilir.

Bu bizim birinci sınıf kütüphane tipi sistemiyle S-146'yı gerçek anlamda birleştiriyor.

---

# D4: Yeniden girişli mutex olmayacak

Karar:

```basic
LOCK m

    LOCK m
        ...
    END LOCK

END LOCK
```

şu hatayı verecek:

```text
SELF_DEADLOCK
```

Beklemeye bırakmayacağız. Çünkü o durumda program sonsuza kadar asılı kalır.

Otomatik yeniden girişe de izin vermeyeceğiz. Çünkü bu kilit kullanım hatalarını gizler.

İleride gerçekten ihtiyaç çıkarsa ayrı:

```text
RECURSIVE_MUTEX
```

tasarlanabilir. V1'in işi değil.

### Daha önemli ayrıntı

Kilit sahibi **OS thread kimliği değil TASK kimliği** olmalı:

```text
ownerTaskId
```

Çünkü worker havuzunda bir TASK çalışma zamanı tarafından yönetiliyor.

---

# Çoklu LOCK sırası

Claude belgesinde “adres sırasına göre” önerilmiş. 

Bunu değiştirelim.

Adres kullanmayalım.

JS ve WASM'da bunun anlamı bile aynı değil.

Her `SHARED/MUTEX` için:

```text
lockOrderId
```

olsun.

```basic
LOCK a, b, c
    ...
END LOCK
```

yapıldığında:

1. ifadeler soldan sağa yalnız bir kez değerlendirilir,
2. alias olan aynı kilitler tekilleştirilir,
3. `lockOrderId` sırasına dizilir,
4. kilitler alınır,
5. çıkışta ters sırada bırakılır.

Böylece platformdan bağımsız olur.

---

# LOCK transaction değildir

Bu da önemli bir düzeltme.

Şu kod:

```basic
LOCK hesap

    hesap.a = 100
    RiskliIslem()
    hesap.b = 200

END LOCK
```

`RiskliIslem()` hata verirse:

```text
hesap.a
```

eski değerine otomatik dönmez.

`LOCK`:

> karşılıklı dışlama sağlar.

Ama:

> rollback/transaction sağlamaz.

Bu ayrımı belgeye açık yazalım.

Transaction istersek sonra ayrı sistem.

---

# CANCEL ve LOCK ilişkisi

Kararımızı koruyalım:

```text
LOCK dışında → CANCEL uygulanabilir

LOCK içindeyken
    CANCEL requested olur
    ancak kritik bölüm yarıda kesilmez

END LOCK
    kilit bırakılır
    ardından cancellation uygulanır
```

Ayrıca:

```basic
LOCK x
    t.JOIN()
END LOCK
```

yasak.

Aynı şekilde:

```text
WAIT
JOIN
RESULT
TASKGROUP.JOIN
```

kilit altında bloklayan kullanım olarak reddedilsin.

Bu deadlock riskini ciddi biçimde azaltır.

---

# D5: SharedArrayBuffer yoksa açık hata

Cevap kesinlikle **(a)**.

Claude'un sorusundaki seçeneklerden:

> açık hata ile reddedilsin.



Şunu yapmayacağız:

```text
Gerçek parallel yok
↓
sessizce tek thread çalıştır
↓
program PASS
```

Bu bizim:

> sessiz semantik sapma yok

kuralımıza ters.

Ama bir ayrımı koruyalım:

### SPAWN her zaman shared memory gerektirmez

Şu:

```basic
t = SPAWN Worker(42)
```

JS Worker üzerinde mesaj aktarımıyla çalışabilir.

Fakat program:

```basic
DIM ATOMIC count AS I64
```

veya:

```basic
DIM SHARED data AS X
```

kullanıyorsa gerekli shared-memory capability yoksa:

```text
JS_BROWSER: ATOMIC requires SharedArrayBuffer capability
```

gibi açık hedef-adlı hata verilir.

WASM için de aynı:

```text
WASM: shared-memory/threads capability required
```

Bir HOST_PROVIDER gerçek eşdeğer semantiği sağlıyorsa elbette kullanılabilir.

---

# D6: R1-R6 şimdi uygulanmalı

Kesinlikle **evet**.

Bu belki en önemli karar.

Bugün AST/MIR senkron olduğu için:

```basic
THREAD Worker()
    globalX += 1
END THREAD

t = SPAWN Worker()
```

tesadüfen güvenli görünür.

Native Faz 2 geldiğinde yarışa dönüşür.

Şimdi kabul edip sonra semantiği değiştirmek kötü olur.

Dolayısıyla native gerçek async başlamadan önce:

```text
SPAWN boundary checker
+
transitive effect analysis
+
argument safety
```

AST/MIR semantik kapısına girmeli.

Eski:

```basic
TRIGGER THREAD Worker
```

bu kurallardan etkilenmez.

S-146 belgesi de bu ayrımı zaten doğru kurmuş. 

Aynı `THREAD` hem TRIGGER hem SPAWN hedefiyse:

```text
SPAWN-safe kuralları
```

uygulanır.

---

# Faz 2'nin yeni kesin bölünmesi

Bence artık sıra şu olmalı:

```text
S-146 KARARLARI
       ↓
R1-R6 semantic/effect analysis
       ↓
FAZ 2A
izole gerçek native async
       │
       ├─ ABI v2
       ├─ TaskRun
       ├─ worker pool
       ├─ TASK OF T
       ├─ CANCEL
       ├─ shutdown
       ├─ PRINT kilidi
       └─ stres testleri
       ↓
FAZ 2B
açık paylaşım
       │
       ├─ SHARED
       ├─ ATOMIC
       ├─ MUTEX
       ├─ LOCK
       ├─ MemoryRef shared region
       └─ library thread-safety contract
       ↓
SONRA
MOVE / CLONE / BYSHARED / PIN
```

Burada çok önemli fark var:

> **S-146 tasarım kararları Faz 2'nin ön koşulu, fakat tüm SHARED uygulamasının bitmesi Faz 2A'nın ön koşulu değil.**

Bu, güncel uzlaştırma belgesiyle de aynı yönde.

---

# `planyap` içindeki eski THREAD CREATE/JOIN fikri ne olacak?

`planyap/sonplan.md` içinde tarihsel olarak:

```text
THREAD CREATE
THREAD JOIN
```

önerileri var.

Bunları **yeniden canlandırmayalım**.

O eski plan, `SPAWN/TASK/TASKGROUP` ortaya çıkmadan önce yazılmış.

Bugünkü kanonik model:

```basic
t = SPAWN Worker(...)
t.JOIN()
```

olduğu için ikinci bir thread API'si yaratmanın faydası yok.

`planyap` burada tarihsel yol haritası, güncel dil sözleşmesi değil.

---

# Claude'un kütüphane tipi planındaki ek üç sorunun cevabı

25.09 `PLAN_BIRINCI_SINIF_KUTUPHANE_TIPI...` belgesinde Claude için ayrıca üç soru bırakılmış. Onları da bu kararlarla kapatabiliriz.

## 1. “S-146 D1-D6 hangileri kilitlendi?”

**Bu cevapla altısı da kilitlenebilir.**

Ama D2 şu değişiklikle:

```text
GUARDED BY zorunlu model değil.
SHARED kendi kilidini taşır.
```

D3 ise:

```text
MOVE + CLONE birlikte,
fakat S-134 lifecycle ile tek model olarak ve sonraki halka.
```

---

# 2. Native TASK ABI v2, S-134 ile nasıl birleşecek?

Kesinlikle ikinci bir “task value” tip sistemi kurmayalım.

ABI v2 genel bir **etiketli değer taşıyıcı** kullanmalı.

Kavramsal olarak:

```text
TaskValueV2
    builtinKind
    typeId
    flags

    payload
    payloadSize

    ownership
    providerId
```

SPAWN sınırında library type descriptor okunur.

### `copy_model=bitcopy`

```text
bağımsız VALUE kopya
```

### `copy_model=clone`

```text
CLONE provider çağrısı
```

### `copy_model=retain`

```text
RETAIN
↓
TaskRun sahipliği
↓
iş bitince DROP/RELEASE
```

### `copy_model=forbidden`

Normal SPAWN argümanı reddedilir.

Daha sonra explicit:

```basic
MOVE(x)
```

geldiğinde sahiplik transfer edilebilir.

Görev sonucu da **aynı ABI** üzerinden ters yönde taşınır.

`TASK OF T` burada çok işimize yarıyor:

```basic
DIM t AS TASK OF RATIONAL
```

çalışma zamanı kaydı hem:

```text
resultTypeId = RATIONAL
```

hem de payload yaşam döngüsünü bilir.

ERROR/CANCEL/shutdown yollarının hepsinde `DROP` **tam bir kez** çalışmalı.

İşte S-134 B3 ile native TASK ABI'nin kesiştiği yer tam burası.

---

# 3. JS/WASM'da TASK OF T provider yoksa ne olacak?

**Temiz hedef-adlı red.**

Senkron adaptöre sessizce düşülmeyecek.

Yani:

```basic
DIM t AS TASK OF MYTYPE
t = SPAWN Worker(...)
```

JS hedefinde gerekli Worker/library provider yoksa:

```text
JS: SPAWN result type MYTYPE has no task-transfer/provider implementation
```

WASM için:

```text
WASM: SPAWN result type MYTYPE has no provider
```

gibi hata.

Canonical MIR'in bugünkü **senkron referans uygulaması**, semantik doğrulama motorudur.

Şu anlama gelmez:

> gerçek async sağlayıcısı yoksa üretim hedefinde sessizce senkron çalıştır.

Bu ayrımı özellikle korumalıyız.

---

# Claude'a verilecek kısa karar metni

Bunu doğrudan koordinasyon defterine koyabilirsiniz:

> **S-146 Mete kararları:**
> **D1 EVET:** SPAWN hedefinin tüm geçişli çağrı grafiği görev güvenliği bakımından denetlenir. Özyineleme sabit nokta/SCC analiziyle çözülür; bilinmeyen FFI/dinamik etki fail-closed reddedilir.
> **D2 DEĞİŞTİRİLEREK EVET:** `SHARED + ATOMIC + MUTEX + LOCK` birlikte kabul edildi. `GUARDED BY` zorunlu çekirdek model değildir. Her `SHARED` nesne kendi `lockId`'sini taşır ve `LOCK sharedVar ... END LOCK` statik olarak doğrulanır. `MUTEX`, veri dışı kaynaklar ve açık çoklu kritik bölgeler içindir. `ATOMIC` zaten shared semantiğidir; kanonik bildirim `DIM ATOMIC x AS I64`.
> **D3 İKİSİ:** `CLONE` bağımsız kopya, `MOVE` sahiplik devridir. Ayrı TASK-özel lifecycle kurulmaz; S-134 `copy_model/clone_model/drop_model` ve provider mekanizmasına bağlanır. Faz 2A'da CLASS/LIST/DICT geçişi yasak kalır; MOVE/CLONE sonraki lifecycle halkasında açılır.
> **D4 HATA:** Varsayılan MUTEX yeniden girişli değildir. Aynı TASK aynı kilidi tekrar alırsa `SELF_DEADLOCK` hatası oluşur. Çoklu LOCK adres sırasıyla değil platform-bağımsız `lockOrderId` ile sıralanır.
> **D5 AÇIK RED:** JS/WASM gerekli shared-memory/atomic capability'ye sahip değilse ATOMIC/MUTEX/SHARED kullanan program sessizce tek-thread çalıştırılmaz; hedef-adlı capability/provider hatası verir.
> **D6 EVET:** R1-R6 izolasyon ve geçişli effect kuralları native Faz 2 başlamadan AST/MIR semantik kapısına eklenir. Yalnız SPAWN yolu etkilenir; eski TRIGGER semantiği korunur.
> **Uygulama sırası:** önce S-146 izolasyon analizi → Faz 2A gerçek native async → Faz 2B SHARED/ATOMIC/MUTEX/LOCK + MemoryRef → S-134 lifecycle ile MOVE/CLONE → BYSHARED/PIN. JOINALL ve gelişmiş paylaşım S-030 çekirdek native async kapanışını geciktirmez.

Bu haliyle Claude'un önerisinin **ana yönünü kabul ediyoruz**, fakat iki yerde ciddi düzeltme yapıyoruz: `GUARDED BY` yerine SHARED'ın kendi kilidi ve platform-adresi yerine `lockOrderId`. Ayrıca `MOVE`u aceleyle TASK sistemine gömmeyip mevcut birinci sınıf kütüphane tipi yaşam döngüsüyle birleştiriyoruz. Bu, 25.09 kaynak yapısına en az yeni özel durum ekleyen yol.

------------  §8 CLAUDE 1 DEĞERLENDİRMESİ VE İTİRAZLAR (2026-09-25)  ------------

## 8.1 Kabul

D1–D6'nın tamamını, Mete'nin değiştirdiği biçimleriyle kabul ediyorum ve karar defterine yazdım:

- D2 değişikliği (`GUARDED BY` yerine her SHARED verinin kendi `lockId`'si) benim önerimden daha iyi: "hangi kilit
  hangi veriyi koruyor" sorusu hiç ortaya çıkmıyor, ayrıca eşleşme tablosu yok. Kendi önerimi geri çekiyorum.
- Çoklu LOCK'ta adres sırası yerine `lockOrderId`: doğru; JS/WASM'da adresin anlamı yok. Geri çekiyorum.
- LOCK'un transaction olmadığı, LOCK içinde CANCEL'in bölüm sonuna ertelenmesi, LOCK içinde bloklayan
  WAIT/JOIN/RESULT/TASKGROUP.JOIN yasağı, kilit sahibinin OS iş parçacığı değil TASK kimliği olması: hepsi kabul.
- MOVE/CLONE'un S-134 yaşam döngüsüne bağlanması ve TASK'a özel ikinci sahiplik sistemi kurulmaması: kabul.
- Kütüphane tipi tanımına `taskTransfer / threadSafety / sharedPolicy` alanları: kabul. Bu alanlar Codex'in
  manifest/`library_type_contract` alanında; onunla SORULAR_CEVAPLAR.md üzerinden koordine edilecek.
- Faz 2A / 2B / sonrası bölünmesi ve eski `THREAD CREATE/JOIN` fikrinin canlandırılmaması: kabul.

Kendi belgemde bir düzeltme: §2 R1'de "copy_model=bitcopy kütüphane değer tipi SPAWN'dan geçebilir" demiştim. Mete'nin
kararına göre geçiş, tip tanımındaki `taskTransfer` alanına bağlı. Bu alan henüz olmadığı için **2A'da kütüphane
tipleri SPAWN sınırından geçemez** (argüman, `TASK OF T` sonucu ve görev gövdesindeki kullanım): açık tanı mesajıyla
reddedilir. Alanlar eklenince açılır. Bu, "sağlayıcı sözleşmesi yoksa fail-closed" kuralının doğrudan sonucu.

## 8.2 İtirazlar ve ek maddeler (Mete onayı bekleniyor)

**İ1 — SHARED veriye kilitsiz erişim yalnız "SPAWN bağlamında" değil, HER YERDE hata olmalı.**
Kararda "kilidi unutursan SPAWN bağlamında derleme hatası" yazıyor. Ana program da bir iş parçacığıdır ve görevlerle
aynı anda çalışır:
```basic
DIM SHARED toplam AS I64
t = SPAWN Worker()      ' Worker: LOCK toplam ... toplam += 1 ... END LOCK
toplam += 1             ' ana program, kilitsiz: Worker ile YARIŞ
```
Kilitsiz erişim yalnız görev gövdesinde yasak olursa bu satır derlenir ve toplam rastgele bozulur. Derleyici hangi
satırın görevlerle aynı anda çalıştığını statik olarak bilemez. **Önerim:** SHARED veriye `LOCK ... END LOCK` dışında
erişim, ana program dahil her yerde derleme hatası. Tek istisna `DIM SHARED` satırındaki ilk değer. Kural basit ve
istisnasız kalır. (Faz 2B'yi etkiler; 2A'yı değil.)

**İ2 — ATOMIC'te "kayıp güncelleme" kuralı genel olmalı, tek kalıba bağlı olmamalı.**
`sayac = sayac + 1` hatası doğru, ama aynı sorun `sayac = sayac * 2`, `sayac = 3 + sayac`, `sayac = F(sayac)` için de
var. **Önerim:**
- Sağ tarafında aynı ATOMIC'i okuyan her atama derleme hatası verir (tek kalıp değil).
- Bileşik atamalardan yalnız donanımın tek adımda yaptıkları atomiktir: `+=` → ADD, `-=` → SUB. `*=`, `/=`, `\=`, `MOD=`
  gibi tek adımda yapılamayanlar hata verir; programcı `.CAS()` döngüsünü açıkça yazar.
- ATOMIC değişken FOR sayacı olamaz ve BYREF geçirilemez. BYVAL geçiş `LOAD` sayılır.
- Bilgi: `PRINT sayac + sayac` iki ayrı LOAD yapar ve iki değer farklı olabilir. Bu hata değil ama kılavuza yazılmalı.

**İ3 — Yerleşik komutların görünmeyen ortak durumu (R4/R5'in DIM dışındaki globalleri).**
Kodda DIM ile bildirilmemiş ama süreç genelinde paylaşılan durumlar buldum. Bunlar da D1'in "bilinmeyen etki
fail-closed" kuralına giriyor:

| Etki | Yerleşik | 2A'da görev gövdesinde (geçişli) |
|---|---|---|
| Konsol durumu | `COLOR`, `LOCATE`, `CLS` | ret (PRINT serbest, K9 kilidi altında) |
| Dosya kanal tablosu | `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`, `PRINT #`, `INPUT #`, `FREEFILE`, `EOF`, `LOF` | ret |
| Rastgele sayı üreteci | `RANDOMIZE`, `RND` | ret |
| Kabuk ayarları | `SHELL` | ret |
| Ham bellek | `POKE/PEEK*`, `MEMCOPY/MEMFILL`, `VARPTR`, `SADD`, `CODEPTR`, `LPTR`, `PTR` yerel değişken | ret (USES_RAW_PTR) |
| Sınıf STATIC alanı | `CLASS ... STATIC alan` | ret (global sayılır) |
| Klavye | `INPUT`, `LINE INPUT` | ret (R6) |
| FFI | `CALL(DLL, …)`, `API`, kütüphane tipi ve manifest kütüphane çağrıları | ret (sağlayıcı sözleşmesi yok) |

**Önerim:** 2A'da bunların hepsini **uyguluyorum** (reddediyorum). Bir kısıtı sonradan gevşetmek hiçbir programı bozmaz;
tersini yapmak bozar. İleride açılabilecekler için ayrı kararlar gerekecek: görev başına RND üreteci (tohumu nereden
alacak?), görev başına dosya kanalları, konsol durumunun görev başına tutulması. Bu kararları şimdi istemiyorum.

**İ4 — Kilit altında bloklama yasağı da geçişli olmalı.**
`LOCK x ... Hesapla() ... END LOCK` bloğunda `Hesapla()` içeride `t.JOIN()` yapıyorsa deadlock riski aynıdır. Bu yüzden
kararlarda sayılan `BLOCKS` etkisi de çağrı grafiğinde yayılmalı: LOCK içinde BLOCKS etkili bir rutini çağırmak da hata
verir. (Faz 2B.)

**İ5 — TASK/TASKGROUP tutamaçları 2A'da görev sınırından geçmez.**
R1 zaten yalnız skaler ve STRING'e izin veriyor. Açık yazıyorum: bir görev başka bir görevin tutamacını argüman olarak
alıp JOIN edemez. Bekleme zincirleri ve kilitlenme analizi 2A'da yok. Gövde içinde yeni bir SPAWN açıp kendi
tutamacını beklemek serbest; iç içe SPAWN'ın kilitlenmemesini §5'teki "bekleyen worker kuyruktan iş çalıştırır"
kuralı sağlar.

## 8.3 Uygulama durumu

D6 gereği R1–R6 ve geçişli etki analizi şimdi, Faz 2A'dan önce AST/MIR semantik kapısına ekleniyor. Kapsam: yalnız
programdaki SPAWN hedefleri; TRIGGER etkilenmez. İ3 tablosundaki retler bu uygulamaya dahil. Sonuç ve testler
SORUN_TAKIP.md S-146'ya yazılacak.

**§8.3 güncelleme (2026-09-25):** İzolasyon halkası uygulandı: `src/semantic/semantic_task_isolation.fbs`, `tests/task_model` 188/188 (4 olumlu + 16 negatif yeni test). Ayrıntı: SORUN_TAKIP.md S-146.

**İ6 — Görev gövdesinde `END` (2026-09-25 ek madde, Mete onayı bekleniyor; fail-closed UYGULANDI).**
`END` tüm programı bitirir. Bir görev iş parçacığında çalışırsa diğer görevler ve ana program yarıda kesilir; K5'in
"normal kapanış görevleri bekler" kuralıyla çelişir. Önerim: görev gövdesinde (geçişli, çağrılan rutinler dahil) `END`
derleme hatası. Görev içinden programı bitirme ihtiyacı varsa görev bir hata/sonuç döndürür, ana program `END` eder.
Bu bulgu S-156'yı (rutin içindeki END'in MIR/native'de programı bitirmemesi) ortaya çıkardı; o hata ayrıca düzeltildi.

------------  §9 NİHAİ SÖZLEŞME — METE KARARI (2026-09-26)  ------------

§2'deki R1–R6 yasak kuralları, §8.2 İ1–İ5 ve "Faz 2A'da şimdilik yasak" yaklaşımı **İPTAL**. Nihai görev/eşzamanlılık
sözleşmesi tek seferde tanımlanır:

1. Normal global/modül/STATIC değişkenler THREAD/PARALEL/SPAWN içinde kullanılabilir; derleme hatası değildir.
2. Tek deyimlik ortak erişim otomatik senkronizedir (kullanıcı LOCK yazmaz). Derleyici deyimdeki ortak depoları bulur,
   `lockOrderId` sırasıyla kilitler, değerlendirir, bırakır. Ana program da görevlerle ortak depoya aynı kuralla erişir.
3. `LOCK ... END LOCK` yalnız birden çok deyimin birlikte bölünmez olması için. Transaction değildir.
4. `SHARED` globali paylaşılır yapmak için değil; yerel/yığın verisine görevler arası yaşam süresi (SharedHandle:
   depolama + generation + refcount + kilit) kazandırır. `BYSHARED` parametrede açık paylaşım semantiğidir.
5. `ATOMIC` zorunlu sözdizimi değil, performans depolama sınıfıdır. `x += 1`, `x = x + 1`, `x = F(x)` derleyicice
   RMW/CAS döngüsüne indirilir; `.LOAD/.STORE/.ADD/.EXCHANGE/.CAS` isteğe bağlı.
6. CLASS/LIST/DICT/SET/ARRAY/kütüphane tipleri görev sınırından geçer; `COPY/CLONE/MOVE/RETAIN/SHARE` yaşam döngüsü +
   `taskTransfer/threadSafety/sharedPolicy` tanımıyla çözülür. MOVE/CLONE bütün yaşam döngülü tiplerde ortaktır.
7. `BYREF` yasak değil; gerçek deponun ömrü görev süresini garanti etmiyorsa reddedilir. Global/STATIC/SHARED/sabitlenmiş
   MemoryRef BYREF geçebilir.
8. TASK/TASKGROUP tutamaçları görevler arasında geçer; bekleme çevrimi (A↔B) çalışma zamanında `TASK_WAIT_CYCLE` hatası.
9. RND görev başına PRNG; dosya tablosu iş parçacığı güvenli; konsol kendi kilidi (+ `LOCK CONSOLE`); SHELL görevden çağrılır.
10. PTR/PEEK/POKE/MEMCOPY görevlerde serbest; MemoryRef sahiplik/generation/ömür/paylaşım modeli; EXTERNAL ham işaretçi
    açık `UNSAFE` sorumluluğu.
11. FFI görevlerde serbest; `threadSafety/threadAffine/externalLock/provider` üst verisine göre yönlendirilir; bilinmeyen FFI
    için `DECLARE ... THREADSAFE | THREADAFFINE | GUARDED` gibi kullanıcı/manifest sözleşmesi.
12. `END`, SPAWN'dan ulaşılabilen görev zincirinde yasak (RETURN/THROW/sonuç kullanılır). — Tek kalan yasak.
13. `semantic_task_isolation.fbs` kaldırılmaz; yasak kapısından "görev etki + depo + ömür + senkronizasyon analizcisi"ne döner.
14. EVENT/PIPE/THREAD/PARALEL/SLOT/TRIGGER aynen korunur; SPAWN/TASK/TASKGROUP üstüne çalışma örneği katmanı ekler.
15. "İlk sürüm / şimdilik yasak / sonra açılır" türünden dil semantiği bırakılmaz.

**Claude'un teknik soruları (§9.1, Mete cevabı bekleniyor):** aşağıdaki kayıtta.

------------  §10 MODEL D — METE KESİN KARARI (2026-09-26, §9'u tamamlar ve önceliklidir)  ------------

Seçenekler A/B/C reddedildi; **Model D**: doğal BASIC yazımı + derleyici/çalışma zamanı ortak veriyi otomatik ve güvenli
yönetir + gerektiğinde açık gelişmiş araçlar + UNSAFE kaçış kapısı. `SHARED/ATOMIC/LOCK/UNSAFE` normal değişkeni
kullanmanın şartı DEĞİLDİR. Ek kesin maddeler (§9'a ek):

- **Garanti:** iki görev `toplam += x` yaparsa sonuç her motorda kesin (30); dil garantisidir, isteğe bağlı mod değildir.
- **Kilit ayrıntısı:** her depo kendi `StorageId/generation/lockOrderId/syncPolicy/owner` kaydını taşır; tek küresel
  mutex YOK. İlgisiz depolara erişen görevler gerçekten paralel çalışır.
- **Açık LOCK ile otomatik kilit birbirini tanır:** `LOCK hesap` içindeki `hesap.balance += 10` kilidi yeniden almaz
  (sahiplik tanınır). Kullanıcının aynı kilidi ikinci kez açıkça LOCK etmesi `SELF_DEADLOCK`.
- **MUTEX** yalnız dış kaynak/programcı tanımlı kritik bölge içindir (`DIM dllLock AS MUTEX : LOCK dllLock ... END LOCK`).
- **UNSAFE ... END UNSAFE** yalnız o bölgedeki belirli statik güvenceleri kaldırır (ham adres, sözleşmesiz FFI);
  görev modelini C'ye çevirmez. `--unsafe-tasks` varsa bir derleyici profili olur, dilin anlamını değiştirmez.
- **Motorlar arası:** AST/MIR/native/JS/WASM aynı gözlenebilir veri semantiği; yalnız görevler arası zamanlama/çıktı
  sırası garanti değildir (sıra gerekiyorsa JOIN).
- **Etki analizi** yasak listesi değil, kod üretim bilgisidir: READS/WRITES_GLOBAL, USES_SHARED/ATOMIC/RAW_MEMORY/FILE/
  CONSOLE/RANDOM/FFI, WAITS_TASK, SPAWNS, TERMINATES_PROCESS. Tek yasak: görev zincirinde END.

**Claude uygulama kuralı (§10.1, anlamı daraltmaz):** "Deyim tek güvenli işlem" garantisi, deyim içinde kullanıcı
FUNCTION çağrısı olsa da korunur ve kilitlenmeye (deadlock) yol açmaz: deyimdeki kullanıcı rutini çağrıları önce
hesaplanıp geçici değere alınır; deyimin kendi ortak depo okumaları/yazmaları ardından tek kilit kümesi altında yapılır.
Kilitler hiçbir zaman bir kullanıcı rutini çağrısı boyunca tutulmaz (açık LOCK bloğu hariç — orada programcı bölgeyi
kendisi açmıştır). Tek sonuç: çağrılan rutin aynı deyimin okuduğu globali değiştiriyorsa okuma çağrıdan SONRA yapılır.

**Uygulama sırası (Mete onayı 2026-09-26):** 1) global/STATIC otomatik senkronizasyon + LOCK + ATOMIC + MUTEX + UNSAFE
sözdizimi; 2) görev başına RND, iş parçacığı güvenli dosya tablosu, konsol kilidi + LOCK CONSOLE, SHELL; 3) TASK
tutamaçları görevler arası + bekleme çevrimi; 4) BYREF ömür + yerel SHARED + BYSHARED; 5) MOVE/CLONE + kütüphane tipi
görev tanımları (Codex ile); 6) FFI iş parçacığı üst verisi; 7) işaretçi/MemoryRef paylaşımı. Uygulanmamış adıma
dokunan program "henüz uygulanmadı (S-146 adım N)" tanısı alır; bu bir dil kuralı değildir, sessiz yanlış sonuç asla.

------------  §11 MODEL D — 1. ADIM UYGULAMA NOTU (Claude 1, 2026-09-26)  ------------

**Durum:** 1. adım (otomatik senkron + LOCK + ATOMIC + MUTEX + UNSAFE) AST, MIR yorumlayıcısı ve native x64'te
uygulandı ve sınandı (`tests/task_sync` 18 program × 4 motor = 72/72; `tests/task_model` 192/192). Legacy AST-x64
bu yapıları açık tanıyla reddeder ("legacy AST-x64: LOCK ... END LOCK desteklenmiyor ...").

**1. Otomatik senkron (dil garantisi).** Analizci (`semantic_task_isolation.fbs`) SPAWN hedeflerinin geçişli
dokunduğu globalleri bulur ("senkron kümesi"; kilit sırası = global bildirim sırası = lockOrderId). MIR'de ayrı bir
geçiş (`mir_sync_pass.fbs`) her deyimin aynı bloktaki buyruklarını `SYNC_ENTER "id,id" "AD,AD"` / `SYNC_LEAVE` ile
sarar. Kilit hiçbir zaman kullanıcı rutini çağrısı, görev işlemi, bekleyen giriş ya da dallanma boyunca tutulmaz.
§10.1: deyimdeki kullanıcı çağrıları (araya yan etkili buyruk girmiyorsa) kilitten önceye alınır. Kilit dışına taşınan
STRING okuması kopyalanır (`STR_SNAPSHOT`). Senkron kümesi boşsa (SPAWN yok) hiçbir şey eklenmez: sıfır maliyet.
8 görev × 10000 `toplam += 1` → her motorda, 1/2/AUTO/8 işçiyle her denemede tam 80000.

**2. `LOCK a, b ... END LOCK`.** Hedefler: program geneli değişken ya da MUTEX değişkeni. Tekilleştirilir, artan
lockOrderId sırasıyla alınır, ters sırada bırakılır (`LOCK b, a` da kilitlenmez). Otomatik deyim kilidi açık LOCK'un
sahipliğini tanır. Bırakma yolları: normal bitiş, RETURN, EXIT FOR/DO/IF, bölüm dışına GOTO; istisnada TRY'nin
CATCH/FINALLY girişi (`LOCK_MARK` / `LOCK_RELEASE_TO`); yakalanmayan istisnada görev bitince çalışma zamanı görevin
tüm kilitlerini bırakır; program sonunda ana programın kilitleri bırakılır. Derleme zamanı tanıları: bulunamayan hedef;
sözcüksel iç içe aynı kilit (SELF_DEADLOCK); `LOCK CONSOLE` (adım 2); MUTEX olmayan yerel hedef (adım 4).

**3. Kilitlenme tanıları (olumcul, TRY yakalamaz, görev hatası olarak tutulmaz; üç motorda aynı metin).**
`SELF_DEADLOCK: 'X' bu gorev tarafindan zaten LOCK ile tutuluyor ...` (çağrı üzerinden ikinci açık LOCK);
`LOCK_DEADLOCK: 'X' kilidini tutan gorev, bu gorevin bitmesini bekliyor ...` (LOCK içinde o kilide dokunan görevi
JOIN/WAIT). Native: bekleme grafiği (görev → kilit sahibi, görev → beklenen görev) çevrimi. Kilit sahibi **görevdir**
(iş parçacığı değil). Bekleyen iş parçacığı kilit tutarken ya da sistemde açık LOCK varken kuyruktan görev çalıştırmaz;
bütün işçiler beklerken kuyrukta iş kalırsa telafi işçisi açılır.

**4. MUTEX.** `DIM m AS MUTEX` her bildirimde yeni kilit kimliği alır; `LOCK m ... END LOCK` dış kaynak / çok deyimli
kritik bölge içindir.

**5. ATOMIC.** `DIM ATOMIC x AS T` (T: I8..U64, BOOLEAN, F32, F64). Metotlar: `LOAD()`, `STORE(v)` (yazılan
değeri döndürür), `ADD(n)` / `SUB(n)` (**yeni** değeri döndürür), `EXCHANGE(v)` (**eski** değeri döndürür),
`CAS(beklenen, yeni)` (eşitse yazar; TRUE = -1 / FALSE = 0, karşılaştırma sonucu gibi). Native: gerçek CPU atomikleri
(`lock xadd`, `xchg`, `lock cmpxchg`; dar tiplerde bellek hep normal kalsın diye CAS döngüsü), bellek sırası SEQ_CST.
Kilitsiz hızlı yol: görevlerle paylaşılan ATOMIC tamsayı/BOOLEAN globalin programdaki TÜM yazımları atomik biçimdeyse
(metot, `x = x ± c`, x'i okumayan ifadeyle yazım) hiç kilitlenmez; tek bir karmaşık yazım (`x = x * 2 + 5`) ya da o
değişkene açık LOCK varsa değişkenin tüm erişimleri deyim kilidine geçer (karışık erişimde kayıp güncelleme olmaz).

**6. UNSAFE ... END UNSAFE.** Yalnız o bölgede ham bellek / sözleşmesiz FFI etkisini görev denetiminden çıkarır ve
paylaşılan global için VARPTR'a izin verir; otomatik senkron bölge içinde de geçerlidir.

**7. Yorumlayıcılarda zamanlama.** AST ve MIR yorumlayıcıları görevi SPAWN anında çalıştırır; açık LOCK tutulurken
yapılan SPAWN ertelenir (kilit sayısı sıfıra inince, JOIN/WAIT/RESULT/TASKGROUP.JOIN'de ya da program sonunda
çalışır). Bu, native zamanlamasının geçerli bir örneğidir; görevler arası çıktı sırası dil garantisi değildir.

**8. Henüz uygulanmamış adıma dokunan program** "henuz uygulanmadi: S-146 adim N" tanısı alır: TASK/TASKGROUP
tipli paylaşılan global ve TASK/MUTEX argümanı (adım 3), paylaşılan globalin BYREF'e ya da bütün dizi olarak çağrıya
verilmesi ve LOCK'ta yerel hedef (adım 4), CLASS nesnesi / sınıf STATIC alanı / iş parçacığı sözleşmesi olmayan
kütüphane tipi globali ve CLASS/LIST argümanları, TASK OF LIST (adım 5), UNSAFE dışında PTR / VARPTR(paylaşılan
global) (adım 7), RND/dosya/konsol/INPUT/SHELL görevde (adım 2). LIST/DICT/SET globalleri serbesttir (çalışma zamanı
koleksiyon tablosu kilitli + deyim kilidi).

**Bu çalışmada bulunan, önceden var olan hatalar:** S-160 (THROW rutin sınırını geçmiyordu — düzeltiliyor), S-161
(ifadede global okuma ile o globali değiştiren çağrının sırası AST'de farklı — karar bekliyor), S-162 (NAMESPACE
değişkenleri AST/native'de çalışmıyor).

------------  §12 MODEL D — 2. ADIM UYGULAMA NOTU (Claude 1, 2026-09-26)  ------------

**Durum:** 2. adım (görev başına RND, iş parçacığı güvenli dosya tablosu, konsol kilidi + `LOCK CONSOLE`, SHELL)
uygulandı. Görevde RND/RANDOMIZE, OPEN/PRINT #/INPUT #/CLOSE, PRINT/INPUT/CLS/COLOR/LOCATE ve SHELL artık serbest
(eski "henuz uygulanmadi: S-146 adim 2" tanısı kalktı). Testler: `tests/task_sync` (92/92), `tests/task_model` iso_task_*.

- **RND (S-163 ile birlikte):** tek ortak üreteç (xoshiro256**, SplitMix64 tohumlama) AST, MIR ve native'de birebir aynı;
  `RND` [0,1) F64; `RND(0)` son değer; `RND(x<0)` x ile yeniden tohum; `RANDOMIZE n` / `RANDOMIZE` (zaman). Her görev
  SPAWN anında atasının sıradaki 64 bitlik değeriyle tohumlanır → aynı program her motorda aynı sayıları üretir.
- **Dosya tablosu:** native tablo kilitli; `PRINT #` satırı iş parçacığına özel tamponda birleşip dosyaya tek kilitle
  yazılır (görevlerin satırları karışmaz). Aynı kanal numarasını iki görevin aynı anda kullanması programcının
  sorumluluğudur (kanal bir kaynaktır; gerekirse MUTEX).
- **Konsol:** PRINT satırı zaten bölünmez (K9). `LOCK CONSOLE ... END LOCK` birden çok konsol deyimini bölünmez yapar;
  program LOCK CONSOLE kullanıyorsa ve görev içeriyorsa tüm konsol deyimleri (PRINT, INPUT, CLS, COLOR, LOCATE...)
  otomatik olarak konsol kilidine girer (kimlik: tüm globallerden sonra). Kullanmıyorsa ek maliyet yok. LOCK CONSOLE
  tutarken konsola yazan görevi JOIN etmek LOCK_DEADLOCK; iç içe LOCK CONSOLE SELF_DEADLOCK.
- **Kilit alımı (1. adıma düzeltme):** bir deyimin ya da LOCK satırının kilitlerinden biri doluysa o çağrıda alınanlar
  bırakılır, dolu olan beklenir, baştan denenir ("ya hepsi ya hiçbiri"). Böylece `LOCK y` içinde `x`'e dokunan görev
  ile tek deyimde `x` ve `y`'ye dokunan görev kilitlenmez; kilitlenme tanısı yalnız programcının tutarsız sırayla iç
  içe açık LOCK kullandığı gerçek durumda verilir.

------------  §13 MODEL D — 3. ADIM UYGULAMA NOTU (Claude 1, 2026-09-26)  ------------

TASK/TASKGROUP/MUTEX tutamaçları görevler arasında geçer: SPAWN argümanı ve parametresi olabilir (`THREAD Tuket(t AS
TASK OF I64)`), paylaşılan global olabilir (erişim otomatik kilitli; değer bir kimliktir, çalışma zamanı tabloları iş
parçacığı güvenlidir). Sonuç tipi kuralı değişmedi (`TASK OF TASK` S-149 gereği reddedilir).
Bekleme çevrimi (A, B'yi; B, A'yı JOIN/WAIT/RESULT ile bekler; görev kendi tutamacını bekler) her motorda ölümcül
`TASK_WAIT_CYCLE: gorevler birbirini bekliyor (A.JOIN <-> B.JOIN)` tanısıdır: native'de bekleme grafiği (görev → beklenen
görev / kilit sahibi) çevrimi; yorumlayıcılarda beklenen görev hâlâ RUNNING ise (tek iş parçacığında bu, çağrı
yığınında bekleyen bir atadır). Test: `tests/task_sync/neg_task_wait_cycle` (MUTEX ile her motorda belirlenimci).
