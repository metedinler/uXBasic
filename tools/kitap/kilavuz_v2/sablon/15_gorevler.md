# 15. Eşzamanlılık: olay, boru, iş parçacığı, paralel, slot ve görev

**Eşzamanlılık**, birden çok işin "aynı anda" ilerlemesidir. Bir web sunucusu aynı anda yüzlerce isteğe yanıt verir, bir oyun ses, fizik ve çizimi ayrı ayrı yürütür, bir veri işleme programı
büyük bir tabloyu parçalara bölüp çekirdeklere dağıtır. uXBasic bu işleri **dört yapı**, **bir bağlama tablosu**, **bir tetikleme komutu** ve **bir görev nesnesi** ile ifade eder.

## 15.1 Büyük resim

```
                       ┌─ EVENT     olay işleyicisi (sonuç döndürmez)
 klasik yapılar ───────┼─ PIPE      senkron dönüşüm hattı (sonuç döndürür)
 (tanım blokları)      ├─ THREAD    bağımsız iş parçacığı görevi
                       └─ PARALEL   birden çok görevi toplu yürüten grup görevi

 SLOT      ──  görevleri 0..255 numaralı bağlama noktalarına kaydeden tablo
 TRIGGER   ──  bir görevi çalıştırma komutu (eski, ateşle-unut biçimi)

 SPAWN     ──  THREAD/PARALEL'i görev olarak başlatır ve TASK tutamacı verir (yeni, izlenebilir biçim)
 TASK / TASKGROUP ── belirli bir çalıştırmanın tutamacı / tutamaç grubu
 LOCK / MUTEX / ATOMIC / UNSAFE ── ortak veriyi korumak için (Model D)
```

> **İlke:** Eski `EVENT / PIPE / THREAD / PARALEL / SLOT / TRIGGER` çekirdeği **korunur**. `SPAWN / TASK / TASKGROUP` bunun yerine geçmez, **üstüne çalışma örneği (TaskRun) yönetimini** ekler.

| Yapı | Görevi | Ne zaman çalışır? | Sonuç | Çalışma biçimi |
|---|---|---|---|---|
| `EVENT` | Olay işleyici | `TRIGGER EVENT` ile (olay gelince) | Yok (`VOID`) | Olay döngüsü |
| `PIPE` | Dönüşüm hattı | `TRIGGER PIPE` ile, çağıran **bekler** | Dönüş değeri (`AS tip`) | Senkron |
| `THREAD` | Bağımsız iş | `TRIGGER THREAD` ya da `SPAWN` ile | İsteğe bağlı (`AS tip`) | Asenkron (native'de gerçek paralel) |
| `PARALEL` | Toplu/paralel iş | `TRIGGER PARALEL` ya da `SPAWN` ile | İsteğe bağlı (`AS tip`) | Asenkron grup |
| `SLOT` | Bağlama/yönlendirme tablosu | Çalıştırmaz | — | 256 bağlama noktası |
| `TASK` | Bir çalıştırmanın tutamacı | — | `.RESULT` | Opak tutamaç |

## 15.2 Tanım blokları

Dört yapı da **tipli parametre** alır ve kendi `END` sözcüğüyle kapanır. `PIPE`, `THREAD` ve `PARALEL` sonuç tipini `AS tip` ile bildirebilir; `EVENT` sonuç döndüremez
(`return type is only valid for PIPE, THREAD and PARALEL`).

```basic
EVENT OlcumGeldi(sensor AS I32, deger AS F64)
    PRINT sensor; ":"; deger
END EVENT

PIPE Normalize(deger AS F64) AS F64
    RETURN deger / 100.0
END PIPE

THREAD Hesapla(n AS I32) AS I32
    RETURN n * n
END THREAD

PARALEL Toplu(bas AS I32, say AS I32) AS I32
    RETURN bas + say
END PARALEL
```

* Parametreler **değerle** (`BYVAL`) geçer. Bir görev sınırından `BYREF` geçirilemez (görev bittikten sonra yaşamayan bir başvuru kalabilir).
* `RETURN değer` sonucu verir. Sonuç tipi bildirilmiş bir `THREAD` içinde değersiz `RETURN` yazılamaz (`RETURN bir deger dondurmeli`).
* Eski kısa `PIPE` yazımı (`PIPE Donustur deger AS I32 ... END PIPE`, parantezsiz) ve gövdede ilk parametrenin eski adları `INPUT` / `TASKIN` **⌛ ESKİ** uyumluluktur.
* Görev gövdesinde `END` (programı bitirme) **yasaktır**; görev `RETURN` ya da `THROW` ile biter.

### Hangisini yazmalı?

| Durum | Yapı |
|---|---|
| "Bir şey olunca şunu yap" (tepki) | `EVENT` |
| "Bu değeri dönüştür ve sonucu hemen ver" | `PIPE` |
| "Bunu arka planda çalıştır, sonra sonucunu al" | `THREAD` + `SPAWN` |
| "Bu işi parçalara böl, hepsi birlikte ilerlesin" | `PARALEL` + `SPAWN` / çok `THREAD` + `TASKGROUP` |
| "Hangi görevin hangi numarada bağlı olduğunu tablolamak" | `SLOT` |

## 15.3 Görevleri sisteme tanıtmak: `DECLARE` ve tanımdan önce kullanım

**Tasarım kararı (24.09):** `THREAD`, `PARALEL`, `PIPE` ve `EVENT` yapıları, tanımlanmadan önce **`DECLARE` ile imza olarak bildirilebilir**. `DECLARE` yalnız imzayı bildirir; görev **yaratmaz**,
SLOT ayırmaz, iş parçacığı açmaz.

```basic
' ◇ HEDEF: bugün "DECLARE: expected SUB or FUNCTION" ile reddedilir
DECLARE EVENT   OlcumGeldi(sensor AS I32, deger AS F64)
DECLARE PIPE    Normalize(deger AS F64) AS F64
DECLARE THREAD  Hesapla(n AS I32) AS I32
DECLARE PARALEL Toplu(bas AS I32, say AS I32) AS I32
```

| Konu | Bugünkü durum |
|---|---|
| `DECLARE THREAD/EVENT/PIPE/PARALEL` | ◇ HEDEF: çözümleyici açıkça reddeder (`DECLARE: expected SUB or FUNCTION near KEYWORD('THREAD')`) |
| `DECLARE FUNCTION` / `DECLARE SUB` | ✔ (Bölüm 8.5) |
| Görevi **tanımdan önce** kullanmak (`SPAWN Kare(6)` satırı `THREAD Kare` tanımından önce) | ✔ AST, MIR, x64: DECLARE yazmadan da çalışır, çünkü derleyici görev adlarını önceden toplar |

> **Aynı kural `SUB` ve `FUNCTION` için de istenmiştir** (Mete, 2026-10-15): ileri kullanımdan önce `DECLARE`. Görev yapılarının `DECLARE` biçimi G-HEDEF-5, `SUB`/`FUNCTION` için denetimin eksikliği G-YORDAM-9 olarak kayıtlıdır (Bölüm 8.5). Ölçüm (`20261014_0253`): `THREAD` ve `PARALEL` tanımdan önce `SPAWN` ile, `EVENT` ve `PIPE` tanımdan önce `TRIGGER` ile AST, MIR ve x64'te `DECLARE`siz çalışır (`25`, `5`, `7`, `8`); `DECLARE THREAD`, `EVENT`, `PIPE`, `PARALEL` ve `SLOT` altı yolda ayrıştırma hatasıyla reddedilir; `TRIGGER` ile SLOT adı (`TRIGGER Kaydet, 4`) altı yolda `TRIGGER hedefi bulunamadi` ile reddedilir.

## 15.4 Nerede yazılır? İç içe ve özyinelemeli kullanım

Görev yapıları **dosyanın her yerinde** tanımlanabilir ve birbirinin içinde kullanılabilir.

| Soru | Cevap | Kanıt |
|---|---|---|
| `MAIN` dışında tanımlanabilir mi? | Evet | `53_kv_gorev/main_ici_ve_disi` |
| `MAIN` içinde tanımlanabilir mi? | Evet | aynı örnek |
| Tanımdan önce `SPAWN` edilebilir mi? | Evet | Bölüm 15.3 |
| Bir görev başka görev başlatabilir mi? | Evet (iç içe `SPAWN`) | `uc_katman` |
| Bir görev kendini başlatabilir mi (özyineleme)? | Evet | `paralel_fibonacci` |
| `PARALEL` gövdesi `THREAD` başlatabilir mi? | Evet (`TRIGGER THREAD` ya da `SPAWN`) | `uc_katman` |
| `EVENT` gövdesinden `THREAD`/`PIPE` tetiklenebilir mi? | Evet | `olay_zinciri` |
| `THREAD` gövdesinden `EVENT` tetiklenebilir mi? | Evet | (sınama) |
| `SLOT` ve `TASK` bildirimleri birlikte kullanılabilir mi? | Evet; SLOT yönlendirir, TASK çalıştırmayı izler | Bölüm 15.5, 15.6 |

{{ORNEK:53_kv_gorev/main_ici_ve_disi|baslik=MAIN içinde ve dışında tanımlı görevler}}

{{ORNEK:53_kv_gorev/uc_katman|baslik=İç içe üç aile: THREAD → PARALEL → THREAD}}

{{ORNEK:53_kv_gorev/paralel_fibonacci|baslik=Üst düzey: özyinelemeli görev ağacı}}

{{ORNEK:53_kv_gorev/olay_zinciri|baslik=EVENT → PIPE → THREAD: yapılar birbirinin çıktısını kullanır}}

> **Özyineleme uyarısı:** Her özyinelemeli `SPAWN` yeni bir görev kaydı açar. Binlerce küçük görev yerine örnekteki gibi bir **eşik** (`IF n < 12 THEN` sıradan işlev) kullanın.
> Native çalışma zamanı, bir görev başka bir görevi beklerken (`JOIN`) kuyruktaki işi çalıştırarak kilitlenmeyi önler.

## 15.5 `SLOT` tablosu ve `TRIGGER`

**`SLOT` çalışan görev değildir.** 0-255 arası **256 sabit bağlama noktasıdır**: her satır bir ad, bir numara, bir durum (`ON`/`OFF`) ve bir hedef görev taşır.

```basic
SLOT
    Kaydet 5 ON  EVENT   VeriGeldi
    Isci   6 ON  THREAD  SensorOku
    Hat    7 OFF PIPE    Donustur
    Grup   8 ON  PARALEL SahaIzleme
END SLOT
```

| Kural | Durum |
|---|---|
| Satır biçimi `Ad No ON/OFF TÜR Hedef`, tür **açıkça** yazılır | ✔ |
| Numaralar 0-255 arasındadır | ✔ |
| Aynı hedef birden çok SLOT'a bağlanabilir | ✔ |
| **Aynı numara iki kez** kullanılamaz (tasarım: derleme hatası) | ✖ SINIR (G-GOREV-4): bugün **sessizce kabul edilir** |
| Başlangıç durumu `OFF` ise tetikleme çalışmaz | ✖ SINIR (G-GOREV-5): AST uygular, MIR ve x64 yok sayar |

### `TRIGGER`

| Yazım | Anlamı | Durum |
|---|---|---|
| `TRIGGER Hedef` / `TRIGGER Hedef, arg1, arg2` | Görevi **görev adıyla** çalıştırır | ✔ |
| `TRIGGER THREAD Hedef, arg` (tür açık) | Aynısı, türü belirterek | ✔ |
| `TRIGGER PIPE Hedef, arg` sonra `TASKOUT` | `PIPE` çalışır, sonuç `TASKOUT` içinde (`OBJECT`; sayıya `CINT(TASKOUT)`) | ✔ |
| `TRIGGER SlotAdı, arg` | SLOT adıyla çalıştırma | ✖ ◇ HEDEF (`TRIGGER hedefi bulunamadi`) |
| `TRIGGER SLOT 3, arg` | Numarayla çalıştırma | ✖ ◇ HEDEF |
| `ON SLOT ad` / `OFF SLOT ad` | Çalışma anında bağlamayı aç/kapat | ✖ ◇ HEDEF |
| `t = TRIGGER THREAD Hedef, arg` | TASK tutamacı döndürme | ✖ ◇ HEDEF (yerine `SPAWN` kullanılır) |
| `x = TRIGGER PIPE Hedef, arg` | Sonucu ifade olarak alma | ✖ ◇ HEDEF |

Bir `EVENT`'e birden çok `SLOT` bağlandığında tasarım, `TRIGGER EVENT` ile **bütün** `ON` bağlamalarının artan numara sırasıyla çalışmasını öngörür; bugün işleyici **bir kez** çalışır (✖ G-GOREV-11).

{{ORNEK:03_olay/event_slot_trigger|baslik=EVENT + SLOT + TRIGGER}}

{{ORNEK:03_olay/event_parametre|baslik=Parametreli EVENT}}

{{ORNEK:03_olay/pipe|baslik=PIPE ve TASKOUT}}

{{ORNEK:03_olay/thread_trigger|baslik=THREAD + TRIGGER}}

## 15.6 `SPAWN`, `TASK` ve `TASKGROUP`

`SPAWN Ad(argümanlar)`, bir `THREAD` ya da `PARALEL` görevini **başlatır** ve o çalıştırmanın tutamacını (`TASK`) verir. `TASK` bir **sayı ya da işaretçi değildir**; opak bir tutamaçtır (`t = t + 1` yasak).
Aynı tutamacı iki değişkene atamak aynı çalıştırmayı paylaşır; `FREE` gerekmez.

| Tanım | Anlamı |
|---|---|
| `DIM t AS TASK` | Sonucu tipsiz (`OBJECT`) tutamaç |
| `DIM t AS TASK OF I32` | Sonucu `I32` olan tutamaç. Hedef görev `AS I32` ile **tipli** olmalıdır |
| `DIM ts(4) AS TASK OF I32` | Tutamaç dizisi; her eleman `ts(i).JOIN()` ile kullanılır |
| `DIM g AS TASKGROUP` | Tutamaç grubu |

| Üye | Ne yapar? |
|---|---|
| `t.WAIT()` | Görev bitene kadar bekler; değer döndürmez |
| `t.JOIN()` | Bekler ve **sonucu** verir; görev hata verdiyse hatayı yükseltir |
| `t.RESULT` | Sonuç (görev bittiyse) |
| `t.STATUS` | Durum metni: `PENDING`, `RUNNING`, `DONE`, `ERROR`, `CANCELLED` |
| `t.ERRORTEXT` | Hata metni (fırlatmadan okur; hata yoksa boş) |
| `t.CANCEL()` | İşbirlikçi iptal isteği (bitmiş görevde zararsızdır, tekrarı da zararsızdır) |
| `g.ADD(t)` / `g.ADD(SPAWN ...)` | Gruba görev ekler |
| `g.JOIN()` | Bütün üyeleri bekler; ilk hatalı üyenin hatasını (ekleme sırasıyla) yükseltir |
| `g.JOINALL()` | ◇ HEDEF: sonuçları `LIST` olarak döndürecek; bugün açık tanı verir |

* **Başlatılmamış `TASK`** `NULL`'dur; `.JOIN()` açık hata verir.
* **Tutamaç görev argümanı olabilir:** `THREAD Tuket(t AS TASK OF I64)` içinde `t.JOIN()` yazılabilir. Birbirini bekleyen iki görev `TASK_WAIT_CYCLE` ile **açıkça reddedilir** (kilitlenme yerine).
* **Okunmayan hata sessiz kaybolmaz:** hiç okunmayan hatalı görev, program sonunda hata çıkışına yazılır ve çıkış kodu başarısız olur.
* `TASK OF LIST`, `TASK OF TASK`, `LIST`/`DICT`/`PTR`/`CLASS` değerlerinin görev sınırından geçmesi **henüz uygulanmamıştır** ve açık tanıyla reddedilir.

{{ORNEK:04_gorev/spawn_join|baslik=SPAWN, TASK OF ve JOIN}}

{{ORNEK:53_kv_gorev/paralel_asal_sayim|baslik=Orta düzey: işi dört göreve bölüp sonuçları toplamak}}

{{ORNEK:53_kv_gorev/gorev_hatasi|baslik=Görevde atılan hatayı izlemek}}

> **Not (G-GOREV-9):** `ERRORTEXT` metninin tam biçimi motora göre değişir (AST satır ve rutin bilgisi ekler). Bu yüzden içerik aranır (`INSTR(..., "patladi")`), tam eşitlik beklenmez.

## 15.7 Ortak veri: Model D

Görevler aynı genel değişkenlere dokunabilir. Bu tehlikeli olabilir; uXBasic'in kararı (**Model D**, 26.09.2026): **normal global / modül / `STATIC` değişkenler görevlerde kullanılabilir** ve
**tek deyimlik ortak erişim otomatik senkronizedir**. Yani kullanıcı `LOCK` yazmaz:

{{ORNEK:53_kv_gorev/otomatik_senkron_yuz|baslik=Yüz görev aynı değişkene yazar: sonuç her zaman 5050}}

Birden çok **deyimin** birlikte bölünmez olması gerekiyorsa `LOCK` kullanılır:

| Yapı | Ne için? |
|---|---|
| `LOCK a, b` ... `END LOCK` | Birden çok deyimi (ve birden çok değişkeni) bölünmez yapar. Kilitler sabit sırayla alınır, ters sırayla bırakılır. **Transaction değildir**: hata olursa yapılan yazmalar geri alınmaz |
| `DIM m AS MUTEX` + `LOCK m` | Dış kaynak ya da programcının tanımladığı kritik bölge için ayrı bir kilit |
| `DIM ATOMIC x AS I64` | Kilitsiz bölünmez sayaç: `.ADD .SUB .LOAD .STORE .EXCHANGE .CAS` |
| `UNSAFE` ... `END UNSAFE` | Ham adres ve sözleşmesiz dış çağrı güvencelerini o bölgede kaldırır |

{{ORNEK:53_kv_gorev/banka_transfer|baslik=Orta düzey: LOCK a, b ile iki hesabı birlikte güncellemek}}

{{ORNEK:53_kv_gorev/atomik_ailesi|baslik=ATOMIC işlemleri}}

{{ORNEK:53_kv_gorev/atomik_dort_gorev|baslik=Dört görev, tek atomik sayaç}}

{{ORNEK:20_esz/mutex|baslik=MUTEX ile üç deyimlik oku-değiştir-yaz}}

### Derleme zamanında yakalanan hatalar

| Tanı | Ne zaman? |
|---|---|
| `SELF_DEADLOCK` | Aynı kilidi ikinci kez, içte `LOCK` etmek |
| `LOCK_DEADLOCK` | Bir kilidi tutarken, o veriye dokunan görevi `JOIN` ile beklemek |
| `TASK_WAIT_CYCLE` | İki görevin birbirini beklemesi (çalışma anında, her motorda aynı iletiyle) |
| `henuz uygulanmadi: S-146 adim N` | Yerel `SHARED`, `BYSHARED`, `CLASS`/`LIST`/`DICT`/`PTR` paylaşımı gibi tasarlanmış ama yazılmamış özellikler |
| `LOCK`'tan çıkış | `RETURN`, `EXIT FOR`, `GOTO` ve `THROW` ile çıkılsa da kilit **bırakılır** |

## 15.8 Çalışma zamanı

* **Yorumlayıcılar** (AST, MIR) görevi `SPAWN` anında hemen çalıştırır (senkron referans). **Görevler arası çıktı sırası dil garantisi değildir**; sıra gerekiyorsa `JOIN` kullanın.
* **Native x64** görevleri gerçekten ayrı iş parçacıklarında çalıştırır. Bir **işçi havuzu** kullanır: varsayılan işçi sayısı mantıksal CPU sayısıdır; `--task-workers N` (1..1024) ya da `UXB_TASK_WORKERS` ortam değişkeni ile değiştirilir (ortam değişkeni önceliklidir). Her işçinin yığını 8 MB'dır.
* Görev sayısı iş parçacığı sayısından bağımsızdır: 10 000 `SPAWN` 10 000 işletim sistemi iş parçacığı demek değildir.
* Bir `PRINT` deyimi **atomiktir**: iki görevin satırları iç içe geçmez.
* Normal kapanış, sahip olunan görevlerin bitmesini **bekler**; hatalı kapanışta kalan görevlere iptal isteği gider.
* Eski AST-x64 görev yapılarını bugün **açıkça reddeder** (ara durum: hedef altı yolun aynı davranışı vermesidir; ret eşlik kapanışı sayılmaz).
* Dosya kanalları görevlerde iş parçacığı güvenlidir.

## 15.9 Hedefler

| Hedef | Durum |
|---|---|
| AST, MIR, x64 | ✔ |
| JS | ✖ (G-GOREV-6) Hiçbir görev yapısı çalışmaz: `UXB host binding missing: SLOT_DEF / TASK_SPAWN / ATOMIC_* / LOCK_ENTER / MUTEX_NEW / SYNC_ENTER`. Bunlar **yürütme anı hatasıdır**; tasarım, derlemede açık ret ve sonra `Worker` havuzudur (S-030 Faz 3) |
| WASM | ◌ (G-GOREV-7) Açık ret (metin ve görev altyapısı yok); tasarım: WASM iş parçacığı ya da konak işçileri (Faz 4) |

## 15.10 Karşılaştırma tabloları

| İkili | Fark |
|---|---|
| `EVENT` ve `THREAD` | `EVENT` olaya **tepki** verir ve sonuç döndürmez; `THREAD` bağımsız iş yapar ve sonuç döndürebilir |
| `THREAD` ve `PARALEL` | `THREAD` tek iş; `PARALEL` birden çok görevi toplu yürüten **grup** görevi |
| `PIPE` ve `THREAD` | `PIPE` çağıranı **bekletir** (senkron); `THREAD` beklemez |
| `PIPE` ve `\|>` | `PIPE` görev bloğu; `\|>` ifade işleci |
| `SLOT` ve `TASK` | `SLOT` 256 sabit **bağlama noktası**; `TASK` her çalıştırmanın **tutamacı** |
| `TRIGGER` ve `SPAWN` | `TRIGGER` ateşle-unut/yönlendir (eski); `SPAWN` TASK tutamacı ve sonuç verir (yeni) |
| `WAIT` ve `JOIN` | `WAIT` yalnız bekler; `JOIN` bekler ve **sonucu** verir (hata varsa yükseltir) |
| `CANCEL` | İşbirlikçi: görev döngü dönüşü gibi güvenli noktada isteği görür; bitmiş göreve zararsızdır |
| `LOCK` ve `MUTEX` | `LOCK` bir bloğu korur; `MUTEX` korunacak kaynağın kendisidir (`LOCK m`) |
| `LOCK a` ve `ATOMIC` | `LOCK` çok deyimli bölge; `ATOMIC` tek işlemlik, kilitsiz sayaç |
| Otomatik senkron ve `LOCK` | Tek deyimde `toplam += x` kendiliğinden güvenli; birden çok deyim için `LOCK` |
| `TASK` ve `TASKGROUP` | Tek çalıştırma / çalıştırmalar grubu (`g.JOIN()` hepsini bekler) |

## 15.11 Tasarımda olup bugün olmayanlar (◇ HEDEF)

24.09 tasarım taslağındaki bazı yazımlar, `SPAWN` / `.JOIN()` modeli kabul edilince **geri çekildi** ya da henüz uygulanmadı. Bunları yazmayın:

| Tasarım yazımı | Yerine bugün |
|---|---|
| `WAIT TASK t` | `t.WAIT()` |
| `TASKOUT(t)` | `t.RESULT` / `t.JOIN()` |
| `TASKSTATUS(t)` | `t.STATUS` |
| `TASKERROR(t)` | `t.ERRORTEXT` |
| `TASKCOUNT(g)`, `TASKCHILD(g, i)` | Yok (grup üyelerini kendiniz tutun) |
| `CANCEL TASK t` | `t.CANCEL()` |
| `KILL TASK t`, `PAUSE TASK t`, `RESUME TASK t` | ◇ HEDEF (işbirlikçi sonlandırma/duraklatma); yok: `KILL TASK t` "unknown symbol: kill" (G-HEDEF-7) |
| `TASKGROUP.JOINALL()` → `LIST` | ◇ HEDEF; bugün `g.JOIN()` + tek tek `t.RESULT` (G-HEDEF-7, S-147) |
| Yerel `SHARED`, `BYSHARED` | ◇ HEDEF (`henuz uygulanmadi: S-146`, G-HEDEF-8) |
| `DECLARE THREAD ...` | ◇ HEDEF (Bölüm 15.3, G-HEDEF-5) |
| `TRIGGER SlotAdı`, `TRIGGER SLOT 3`, `ON SLOT` / `OFF SLOT`, `t = TRIGGER THREAD …` | ◇ HEDEF (Bölüm 15.5, G-HEDEF-6) |

### Model D'nin henüz uygulanmayan adımları (S-146)

Model D (Bölüm 15.7) yedi adımda uygulanır. 1–3. adımlar çalışır; kalanlara dokunan program **sessiz yanlış sonuç yerine** "henuz uygulanmadi: S-146 adim N" tanısıyla durur. Aşağıdaki her satır gerçek derleyicide denenmiştir:

| Adım | Tasarım | Bugünkü gerçek | Kayıt |
|---|---|---|---|
| 4 | `DIM SHARED` (genel ve yerel), `BYSHARED` parametre, `PIN`, `THREAD` içinde `BYREF`, paylaşılan globalin `BYREF` ya da bütün dizi olarak verilmesi | `DIM SHARED x AS I32` "DIM: AS expected near IDENT('x')" · `THREAD W(BYREF x AS I32)` "THREAD BYREF parametre desteklenmiyor" · `BYSHARED` imzada ayrıştırılamaz | G-HEDEF-8 |
| 5 | `LIST`/`DICT`/`SET`/dizi/`CLASS`/kütüphane tipinin görev sınırından geçişi (`COPY/CLONE/MOVE/RETAIN/SHARE`), `CLONE(x)`, `MOVE(x)`, `taskTransfer/threadSafety/sharedPolicy` | `SPAWN W(l)` "1. arguman tipi LIST gorev sinirindan gecemiyor — henuz uygulanmadi: S-146 adim 5" · `TASK OF LIST` aynı tanı · paylaşılan `CLASS` globali ve sınıf `STATIC` alanı aynı tanı · `CLONE`/`MOVE` "unsupported call" | G-HEDEF-9, G-GOREV-12 |
| 6 | Dış (FFI) işlevler için iş parçacığı üst verisi: `DECLARE … THREADSAFE \| THREADAFFINE \| GUARDED` | `THREADSAFE` "unknown symbol: threadsafe" | G-HEDEF-10 |
| 7 | `PTR`/MemoryRef paylaşımı (sahiplik, kuşak, ömür) | `PTR` değişkeni görevde "henuz uygulanmadi: S-146 adim 7"; ham adres için `UNSAFE … END UNSAFE` | G-HEDEF-11 |

Bugün **çalışanlar** (denendi, AST + MIR + x64): genel `TYPE` değişkeni üzerinde `LOCK` ve görevden yazma, yerel `MUTEX` ile `LOCK`, `UNSAFE … END UNSAFE`, `LOCK CONSOLE`, `ATOMIC` ile doğal yazım (`c += 1`, `c = c + 1`, `x = c + 1`, `c = 7`), `SLOT` tablosu ve `TRIGGER THREAD`.

JS'te Worker havuzu, WASM'da iş parçacığı ya da konak işçileri, `SharedArrayBuffer`/`Atomics` yeteneği yoksa **açık hata** (sessiz tek iş parçacığına düşüş yok) ve tarayıcı ana iş parçacığında bloklayan `Atomics.wait` yerine async devam tasarımın gereğidir; bugün hiçbir görev yapısı JS ve WASM'da çalışmaz (G-GOREV-6, G-GOREV-7, G-HEDEF-12).

## 15.12 Bilinen sınırlar

| Kayıt | Açıklama |
|---|---|
| ✖ G-GOREV-1 | `PIPE` doğrudan işlev gibi çağrılırsa (`PRINT Ikile(3)`) yalnız AST çalışır; MIR `RT_LIBRARY_CALL`, x64 `CALL target ... is neither a known runtime call` verir. `TRIGGER PIPE` kullanın |
| ✖ G-GOREV-2 | `PIPE` kendini çağıramaz (`numeric operands required`); `THREAD` doğrudan çağrılamaz (`call in expression requires FUNCTION`) |
| ✖ G-GOREV-3 | Bir `THREAD` içinde `TASKOUT = ...` yazıp dışarıda `PRINT TASKOUT` okumak motorlara göre hata / `taskout` metni / çöp sayı verir; sonucu `RETURN` ile verin |
| ✖ G-GOREV-4 | Aynı SLOT numarası iki kez sessizce kabul edilir |
| ✖ G-GOREV-5 | `SLOT ... OFF` durumunu yalnız AST uygular |
| ✖ G-GOREV-8 | Görev hatası `JOIN`'de MIR ve x64'te **ölümcül** (program durur), AST'de `TRY` ile yakalanır |
| ✖ G-GOREV-10 | `TASK OF I32` tutamacıyla aritmetik (`a + 1`) derleme hatası vermez ve tutamaç sayısını kullanır |
| ✖ G-GOREV-11 | Bir `EVENT`'e bağlı birden çok SLOT için işleyici bir kez çalışır |
| ◌ G-GOREV-12 | Kütüphane tipi görev sınırından geçemez: `THREAD … AS RATIONAL` ve `TASK OF RATIONAL` "henuz uygulanmadi: S-146 adim 5 (taskTransfer/threadSafety)" ile reddedilir. Kesri iki `I64` olarak döndürüp görev dışında `RATIONAL` kurun (Bölüm 22.7) |

## 15.13 Eşzamanlılıkla ilgili programlama kararları

* **Yapıyı işe göre seçin** (15.2): tepki → `EVENT`; değeri dönüştürüp hemen sonucu almak → `PIPE`; arka plan işi → `THREAD` + `SPAWN`; işi parçalara bölmek → `PARALEL` ya da çok `THREAD` + `TASKGROUP`; bağlama tablosu → `SLOT`.
* **Yeni kodda `SPAWN` + `TASK` kullanın**: izlenebilir ve sonuç verir. `TRIGGER` yalnız `EVENT` ve `PIPE` için ya da eski ateşle-unut işler için kalsın.
* **Sonucu `RETURN` ile verin**, `TASKOUT` değişkenine yazıp dışarıdan okumayın (G-GOREV-3). `PIPE`'ı işlev gibi çağırmayın, `TRIGGER PIPE` + `TASKOUT` kullanın (G-GOREV-1); `PIPE` kendini çağıramaz, `THREAD` doğrudan çağrılamaz (G-GOREV-2).
* Tutamacı tipli tanımlayın (`DIM t AS TASK OF I32`) ve **tutamaçla aritmetik yapmayın** (G-GOREV-10). Hata verebilecek görevde önce `t.WAIT()`, sonra `t.STATUS` / `t.ERRORTEXT` ile bakın: `JOIN` hatayı yükseltir ve MIR ile x64'te programı durdurur (G-GOREV-8). Hatayı okumazsanız program sonunda hata çıkışı yazılır, çıkış kodu başarısız olur.
* **Görevler arası çıktı sırasına güvenmeyin**: yorumlayıcılar görevi hemen çalıştırır, native x64 gerçekten paralel çalıştırır. Sıra gerekiyorsa `JOIN` kullanın.
* **Ortak veride en dar aracı seçin** (15.7): tek deyimlik erişim otomatik senkron; birden çok deyim → `LOCK a, b`; sayaç → `ATOMIC`; dış kaynak ya da kendi kritik bölgeniz → `MUTEX`. Bir kilidi tutarken, o veriye dokunan görevi `JOIN` ile beklemeyin (`LOCK_DEADLOCK`) ve içte aynı kilidi tekrar almayın (`SELF_DEADLOCK`).
* Özyinelemeli görevde **eşik koyun** (`IF n < 12 THEN` sıradan işlev): her `SPAWN` yeni bir görev kaydı açar. İşçi sayısı `--task-workers N` ya da `UXB_TASK_WORKERS` ile ayarlanır.
* Görev parametreleri değerle geçer (`BYREF` yoktur); görev gövdesinde `END` yazmayın, `RETURN` ya da `THROW` ile bitirin. `LIST`, `DICT`, `PTR`, `CLASS` değerlerini görev sınırından geçirmeyin; sayı ve metinle çalışın.
* Görevleri `DECLARE` ile bildirmeniz gerekmez (`DECLARE THREAD …` henüz yoktur, 15.3): derleyici görev adlarını önceden toplar, tanımdan önce `SPAWN` edebilirsiniz.
* `SLOT` numarasını bir kez kullanın (G-GOREV-4) ve `OFF` başlangıç durumuna güvenmeyin (G-GOREV-5). Bir `EVENT`'e birden çok SLOT bağlayıp hepsinin çalışmasını beklemeyin (G-GOREV-11); her işleyiciyi ayrı `TRIGGER` ile çalıştırın.
* `ERRORTEXT` metnini tam eşitlikle sınamayın, içeriğini arayın (`INSTR`, G-GOREV-9).
* **Eşzamanlı programı JS ya da WASM hedefine derlemeyin**: görev yapıları orada çalışmaz (G-GOREV-6, G-GOREV-7). Eşzamanlı işi x64'te çalıştırın.
