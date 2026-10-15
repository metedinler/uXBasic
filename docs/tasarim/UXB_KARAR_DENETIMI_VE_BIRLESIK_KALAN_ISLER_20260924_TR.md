# uXBasic karar denetimi ve birlesik kalan isler

Tarih: 2026-09-24. Hazirlayan: Codex. Durum: kaynak ve kayit denetimi;
asagidaki yeni oneriler Mete onayi olmadan kesin dil karari degildir.

## 1. Kapsam ve kanit siniri

Bu belge yeni 24.09 kararlarini, 40 bolumluk eszamanli bellek tasarimini,
20/23.09 kutuphane tipi belgelerini, 15.09 OOP ve acik-is planlarini,
koordinasyon defterlerini ve ilgili canli kaynak yollarini karsilastirir.
Tum derleyicinin her satirinin incelendigi veya tum motorlarin yeniden
regresyondan gecirildigi iddia edilmez. Eszamanli ajanlar kaynak degistiriyor.

Kanit siniflari:

- **KOD:** bu incelemede kaynakta gorulen davranis/yapi.
- **TEST:** bu oturumun izole ikiliyle uretilmis sonuc dosyasi.
- **KAYIT:** baska oturumun deftere yazdigi sonuc; burada yeniden kosulmadi.
- **TASARIM:** hedef/karar; calisan uygulama kaniti degil.
- **ACIK:** kapanis kaniti yok, is veya karar bekliyor.

### Konusma ve belge kapsami

- ChatGPT `UXBasic Bellek Tasarimi` (6aa6feb9-47cc-83eb-8ab5-95e9dacfe74d)
  son konusma bolumleri dogrudan okundu. Yeni K1-K8 ve 40 bolumluk paylasim
  metni defterdeki kopyayla karsilastirildi. API sayfasinda `hasMore=true`:
  bu sohbetin tum eski mesajlari okunmus sayilmiyor.
- Uygulamanin erisilebilir gorev/sohbet listesinin ilk 50 kaydi ve sabitlenen
  kayitlari tarandi. Ilgili basliklar: `uXBasic Dil Yapisi`,
  `uXBasic Onislemci Karsilastirmasi`, `Dizi Bellek Tasarimi`,
  `uXBasic Sorun Analizi`, `uXBasic derleyici durumu`,
  `uXBasic Konumlandirmasi`, `GSL uXBasic Entegrasyonu`,
  `uXBasic Evren Tasarimi`. Baslik/envanter taramasi tam icerik okuma degildir.
- Yedi 20.09 kaynak metni `docs/tasarim/UXB_TASARIM_*_20260920_TR.md`
  altinda mevcut; bu denetimde karar ve konu bazli tarandi. Birlesik
  `UXB_BIRINCI_SINIF_KUTUPHANE_TIPI_TASARIM_PAKETI_20260920_TR.md` okundu.
- `UXB_20260923_SISTEM_TASARIM_KARARLARI_MEVCUT_DURUM_VE_IS_PLANI_TR.md`
  ana sistem/is planiyla karsilastirma yapildi.
- `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md`,
  `docs/UXB_ACIK_ISLER_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md`,
  `docs/UXB_TUM_SISTEM_KOD_DENETIMI_20260915_CODEX1_TR.md` okundu.
- Kitap/PCK/eski paket planlari arsivde indekslendi, tek tek tam denetlenmedi.
  Tum eski ChatGPT konusmalarinin eksiksiz incelendigi SOYLENEMEZ.
  Kalan tarihce isi: ilgili sohbetlerin eski sayfalarini cikarmak, her karari
  kaynak mesaji + tarih + yerine gecen karar + uygulama/test kaydina baglamak.

## 2. Gecerli yon ve yerine gecen kararlar

Kucuk cekirdek + genisletilebilir tip sozlesmesi + canonical MIR ana yonu
tutarli. RATIONAL/COMPLEX/MATRIX icin ayri cekirdek tip dallari cogaltmak
yerine descriptor/operator/conversion/lifecycle/provider yetenekleri gerekir.
Bir referans provider'in RATIONAL algoritmasini bilmesi normaldir; genel tip
baglayicinin her matematik turunu ozel bilmesi hedef degildir.

24.09 K1-K8 kesin kararlari eski alternatiflere ustundur:

1. Kullanici tipi TASKGROUP; TASK_GROUP kaynak takma adi degil.
2. SPAWN izole; eski TRIGGER semantigi korunur.
3. AST senkron referans + MIR senkron referans; native gecici senkron TASK
   uygulamasi yapilmaz, dogrudan gercek worker havuzuna gecer.
4. JOINALL ileride LIST dondurur; S-147 bilincli ertelenmistir.
5. CANCEL isbirlikci; kapanis/hata gorunurlugu ve worker siniri zorunlu.
6. JS/WAT/WASM alani Antigravity'de; JS fail-fast ve SLOT_DEF onceliklidir.

Eski konusmadaki asenkron TRIGGER/TASKOUT onerisi bu kararlari gecersiz
kilmaz. TRIGGER = SPAWN+JOIN ifadesi yalniz bekleme/sonuc benzetmesi olabilir:
SPAWN'in yeni izolasyon kabul kurallari eski TRIGGER'a uygulanamaz.

Eski typed-pointer F80 ornegindeki 10 bayt artis da son stride karariyla
guncellenmelidir: payload 10, secilen depolama stride'i 16 ise tipli pointer
bir eleman icin 16 ilerler; raw PTR + 1 bir bayt ilerler. SIZEOF/layout/stride
ayrimi tek ABI tablosundan gelmeli, eski ornekten yeni kural turetilmemeli.

## 3. Onay icin tasarim duzeltmeleri

### D01 - Tutamac bit duzeni gercek ABI ile ters

Yeni metin high32=generation, low32=slot diyor ve uxclz ile uyumlu sayiyor.
`runtime_ext/uxclz/src/uxclz.cpp:410-418` bunun tersini kullaniyor:
high32=slot+1, low32=generation. Bu dogrudan kaynak uyusmazligidir.

Oneri: var olan ABI degismesin; dil tutamaci opak olsun. Ortak codec/adaptor
kullanilsin. Yeni TASK/SHARED runtime ABI'si acik surumlensin; tum eski
tutamaclar ayni bit duzenindeymis gibi yorumlanmasin. Generation tasmasi ve
slot tekrar kullanimi icin ABA politikasi da kabul testine eklensin.

### D02 - LOCK veri islemi/transaction degildir

Kilit kapsam sonunda birakilir ve CANCEL ertelenir; bu, THROW'dan once
yapilmis yazmalari geri almaz. Iki hesap aktariminin ikinci yazmasi hata
verirse ilk yazma kalabilir. "Kritik bolgenin atomik butunlugu" ifadesi bu
sinirla daraltilmali: karsilikli dislama var, otomatik rollback yok.

Oneri: v1 kilidi daima birakir, hatayi yayar, rollback vaat etmez. Algoritma
once hesapla/dogrula, sonra commit eder. Transaction veya poisoned-lock
semantigi ayri gelecek tasarimi olsun. Kilit icinde sonsuz dongu/FFI takilmasi
varken isbirlikci CANCEL icin sinirli surede kapanis garantisi verilemez.

### D03 - Bilinmeyen FFI'yi uyariyla gecirmek izolasyonu deliyor

Yeni metindeki "ilk etapta uyari, strict modda hata" yolu guvenli SPAWN
varsayilaniyla uyusmuyor. MUTEX altinda cagri yapmak da thread-affine DLL'i,
asenkron pointer saklayan fonksiyonu veya callback zincirini guvenli yapmaz.

Oneri: guvenli SPAWN'da bilinmeyen FFI/effect reddedilsin. Surumlu guvenilir
provider sozlesmesi; thread-affinity, callback/retention, blocking ve payload
guvenligi bilgisi gereksin. Eski senkron FFI davranisi degistirilmesin.

### D04 - RETAIN ile gorev paylasim izni ayni sey degil

RETAIN yalniz omru uzatir. Kayit tablosunun mutex'i payload metodunu korumaz.
uxclz invoke yolu kayit kilidini birakip payload'a girer; callback kodunun
guvenligi ayridir. CONST/READONLY referans da derin IMMUTABLE kaniti degil.

Oneri: mevcut copy_model/lifecycle ile taskTransfer/threadSafety ayri
alanlardir. Eksik task sozlesmesi varsayilan FORBID olsun. COPY bagimsiz
snapshot kaniti, RETAIN ise transitif immutable veya acik thread-safe payload
sozlesmesi istesin. Metotlardan disariya mutable alias kacisi denetlensin.
Mevcut S-134 B2 refcount'u tek-thread MIR denemesidir, thread-safe degildir.

### D05 - Raw PTR uzerinde tam stale garantisi verilemez

`src/common/memory_ref.fbs:54-86,104-130` adres+genislik denetliyor. Yeni
tahsis ayni adrese gelince onceki tombstone temizleniyor; pointer generation
tasimadigi icin eski pointer ile yeni adres ayirt edilemiyor.

Oneri: guclu guvence managed MemoryRef/SharedHandle icin region+generation+
offset ile verilsin. Raw PTR acik dusuk seviyeli, sinirli denetlenen yol olsun.
SHARED/ATOMIC VARPTR v1 reddi korunsun; PIN/BYSHARED sonraki fazdir.

### D06 - Worker helping, kilit ve gorev baglami

Worker beklerken baska gorev calistiriyorsa yalniz thread-local hata/heldLocks
alani yetmez. Ic ice gorevde TaskExecutionContext sakla/geri-yukle gerekir.
Kilit tutan worker rastgele cocuk isini inline calistirmamali. LOCK icinde
izin verilen SPAWN yalniz kuyruğa eklemeli; kuyruk baskisi nedeniyle child
calistirip/bloklayip JOIN yasagini dolanmamali.

Oneri: SHARED ve MUTEX icin tek lockOrderId alani; LOCK argumanlari bir kez
soldan saga degerlendirilsin. Ayni LOCK listesindeki alias tekrarlarini tek
kilide indir, zaten tutulan kilidi yeniden almak SELF_DEADLOCK olsun. Kismi
edinim hatasinda alinmis kilitler ters sirada birakilsin. Gizli runtime
kilitleri/PRINT ve callback'ler de lock-order analizine dahil edilsin.

### D07 - Atomik islemlerin siniri ve hedef yetenegi

`x=x+1` ayni ifadede reddedilebilir; gecici degisken/yardimci fonksiyonla
bolunmus load+store'un tumunu kanitlayarak yasaklamak genel olarak mumkun
degil. Veri yarisi olmamasi kayip guncelleme olmamasi anlamina gelmez.

Oneri: seq_cst LOAD/STORE ve gercek RMW garanti edilsin; ayri LOAD/STORE
transaction sayilmasin. ADD/SUB/EXCHANGE eski degeri, strong CAS BOOLEAN
dondursun (oneridir); BOOLEAN aritmetigi reddedilsin. Genislik/tasma kurali
normal sabit genislikli tamsayi sozlesmesiyle ayni olsun.

JS Worker olmasi paylasimli bellek yetenegi demek degildir. Tarayici ana
is parcaciginda bloklayan Atomics.wait yoluna guvenilemez; program Worker'da
calismali veya acik async devam/adaptor kullanmali. Host yetenegi yoksa temiz
red gerekir. Kaynak: [ECMAScript Atomics.wait](https://tc39.es/ecma262/multipage/structured-data.html#sec-atomics.wait).

### D08 - Sonuc tipi ve grup kapanisi

Yeni Claude kaydi S-149: TASK.RESULT/JOIN TYPE_OBJECT oldugundan I32 hedefe
acik cast gerekiyor. Bu tip sisteminin eksigi; rastgele ortuk donusum eklemek
kutuphane tipleri ve heterojen LIST icin yeni belirsizlik yaratir.

Karar ve uygulama: TASK OF T tipli yol + mevcut tipsiz TASK birlikte kaldi.
Tipli yolda SPAWN hedefi T ile dogrulaniyor; tipsiz TASK sonucu OBJECT olarak
kalip acik cast gerektiriyor. VOID sonucu, NULL tutamac, TASK OF T erasure ve
farkli T'ler arasi atama kurallari parser/semantic/MIR kabul vektorleriyle
testlendi. S-149 canonical MIR senkron referans halkasi da uygulandi; gercek
native asenkron, JS Worker ve WASM gorev yurutmesi ayri hedef halkalaridir.

JOINALL'in LIST karari tekrar acilmiyor. Sonuclari eklenme sirasi belirler;
grup JOIN baslarken atomik olarak SEALED olur. Oneri: hata olsa da tum uyeler
drain edilir, sonra eklenme sirasindaki ilk hata aktarilir. ERRORTEXT okumak
hatayi "gozlenmis" sayiyor mu, WAIT hata yayilimi ve tekrarlanan JOIN
ayrica kesinlesmeli. Mevcut karar WAIT/JOIN/RESULT hata yayilimini ister.

### D09 - Keyword, OOP ve surum gecisi

15.09 OOP belgesinin baglamsal keyword onerisi ile 24.09 S-128 genel keyword
yasagi ayni kural degil. Son acik Mete karari S-128 uygulanmali; eski onerinin
uzerine karar geldigi isaretlenmeli. Yerlesik pseudo-metotlar/MAGIC hook'lar
ve DLL sembol STRING'leri kullanici bildirim adi yasagiyla karistirilmamali.

THIS=direct, ME=virtual, SUPER=lexical yeni hedef semantigi; mevcut alici
adlarinin calismasi bu ayrimin tamamlandigi anlamina gelmez. Davranis
degistiren OOP paketine dil surumu/migration ve her motor kabul vektoru gerekir.

## 4. Sistemlerin birlesik durumu

Asagidaki tablo ozellik ailelerini kapsar, her komutun tam parity matrisi degildir.

| Sistem | Uygulanmis/kanit | Kalan is veya sinir |
|---|---|---|
| Sayilar, PRINT, STR | S-074 ve cesitli genislik duzeltmeleri KAYIT | S-078 exact constant folding; S-085 JS/WASM I64-U64; S-086/087 legacy/format; S-142b shortest round-trip |
| F80 | payload/stride tasarimi, kismi destek KAYIT | S-091 legacy link; S-092 gercek buffer storage ve hedef politikasi |
| FFI/C ABI | negatif arguman, native STR ve kutuphane yollarinda duzeltmeler KAYIT | S-145 bos STRING != NULL; S-144 expression icinde iki FFI cagrisi/stack hizasi; task effects |
| Bellek | NATIVE/VIRTUAL temel rotalar ve dizi MemoryRef KAYIT/KOD | S-094 scalar/TYPE/CLASS/STRING/FFI omur kaydi; sabit tablo siniri; task context; rights/origin/stride |
| Pointer/6502 | raw byte aritmetik ve bellek komutlari var KAYIT | S-113 gercek tipli pointer ve stride; adresleme orneklerini mevcut komutlara esle; ayri 6502 opcode ailesi zorunlu degil |
| Diziler | REDIM/BYREF alaninda parca kapanislar, bounds paketi KAYIT | S-096/101/103: bos DIM d(), runtime boyut native, cokboyut, TYPE stride, callee REDIM semantigi |
| Iterasyon | S-107 STRING kod noktasi, scalar deger listesi, iterable virgullu red KAYIT | S-135 genel ITER_CREATE/NEXT/CLOSE, MAGIC ITER, CHAIN/ZIP, hata/erken cikis cleanup |
| OOP temel | NEW/null, sanal cagri, upcast, field/destructor/receiver duzeltmeleri KAYIT | S-132 CSNG hala TYPE_F64 KOD; ctor coklu zincir, METHOD/receiver hedef ayrimi ve genis parity |
| OOP ileri | 15.09 hedef plani TASARIM | generics, trait/decorator, immutable transitif, property single-eval, weak/cycle politikasi, version/migration |
| Koleksiyonlar | LIST/DICT/SET temel islemler bazi hedeflerde KAYIT | tipli metadata/unbox, ownership, legacy eksikleri, heterojen LIST ve S-147 |
| Kutuphane tipi parser | erken manifest tipi bildirimi TEST 16/16 | standalone mir komutunun kayit yukleme yolu; namespace/registry tum girisler |
| Kutuphane tipi operator | RATIONAL arithmetic/comparison MIR provider KAYIT/TEST | paket/provider registry, surum/bagimlilik, tum hedef providerlari; adi ozel cekirdek dallari cogaltma |
| Lifecycle | B1 model dogrulamasi; B2 mevcut kabul paketi 30/30 | Genel CLONE/RETAIN/DROP lowering'i; field/BYREF/escape omru; tum hedef provider parity'si; task guvenligi ayri |
| Matematik tipleri | RATIONAL referans parcasi | S-115 COMPLEX/POLYNOMIAL/MATRIX/TENSOR paketleri ancak genel sozlesme kabulunden sonra |
| TASK | AST + canonical MIR senkron referans, `tests/task_model` 108/108 | S-030 native gercek async, JS/WASM, shutdown/cancel/stres; S-146/S-147; typed-result target parity |
| SHARED/ATOMIC/LOCK | 40 bolumluk TASARIM; taskTransfer/threadSafety sozlesmesi kaynakta yok | S-146 semantik/effect analizi, canonical MIR/runtime, lock/cancel/alias/lifetime; 2A izolasyon once |
| JS | cesitli OOP/array/runtime yollar KAYIT | Antigravity: TASK fail-fast+SLOT_DEF, library ownership provider, exact64, Worker/host yetenegi |
| WAT/WASM | bounds/SIZEOF ve secili model testleri KAYIT | S-122 BYREF, S-123 GOSUB gercek destek; OOP virtual/genis parity; library provider, threads/host |
| Native x64 | canonical MIR tabanli ana hedef | library managed ABI, typed pointer, array genisligi, task async ve parity |
| Legacy AST-x64 | korunan uyumluluk hedefi | F80/link, koleksiyon/bounds/CONST/FFI eksikleri; desteklenmeyen ozellikte acik tani |
| MODULE/NAMESPACE/CONST | S-139/140/141 parsiyel duzeltmeler KAYIT | ayni adli farkli namespace CONST MIR flatten; legacy STRING/F64/namespaced CONST |
| META/DERIVE/uretim | araclar ve eski oneriler | S-136 deterministic generator registry, kaynak haritasi, cache/hash/sandbox ve surumlu descriptor |
| Kontrol akisi | cok sayida ortak test KAYIT | S-083 tek-satir IF ELSE; S-118 recursion sinirlari/host stack; effect/transitive callgraph |
| Performans | olcum/yerel iyilestirme kayitlari | S-090 AST, S-111 semantic; dogruluk kapanmadan hiz sonucunu esitlik sayma |
| Harici kutuphaneler | GSL32 ve SDL3 secili kapsam kapanisi KAYIT | raylib Models3D/Shaders; GSL genisletme; SDL3 GPU/Vulkan/camera vb secilmeyen API'ler ayri |
| Test/dagitim | ortak model kosucusu mevcut | CLI flags kosucu arizasi; binary/DLL beraber dagitim; oracle/version/hash; S-117 silme onaysiz yapilmaz |

S-148 ve S-149 bu denetim sirasinda Claude tarafindan eklendi; eski bir
numara audit icin tekrar kullanilmadi. S-148'in DIM ilk deger tipi denetimini
atlamasi genel semantik hatasidir, yeni dil karari gerektirmez. Diger
motorlardaki kapsam henuz ayri olculmemistir.

## 5. Benim iki halkamin gercek durumu

Halka 1: RATIONAL disi manifest tip adini parser'a erken tanitma. Izole rapor
`reports/library_type_contract/ring1_results.json`: 16/16. Genel CLI tum
girislere yayilma (ozellikle standalone mir) kapandi sayilmaz.

Halka 2: descriptor tabanli managed payload, CLONE/RETAIN/DROP ve MIR
aktarimi. Guncel taze ikili raporu `reports/library_type_contract/results.json`:
30/30. Compiler SHA256: `FF4ECFAB6633308E83CE882EFF3A06232B732D1532A2DF625ADC1A6A32208852`.

Bu kosuda `b=a` icin aktif MIR lowering yolu `mir_lower_stmt_core_split.fbs`
uzerinden managed COPY cagrisina baglandi; value bagimsizligi ve clone-limit
vektoru gecti. `library_owned_error` oracle metni `division by zero` ile
uyumlulasti. `managed_target_WASM` testi mevcut `wat --emit-wasm` CLI yoluna
tasindi ve WAT asamasindaki kontrollu provider reddini dogru sinifliyor.

Bu 30/30 sonuc mevcut B2 kabul paketi icindir; genel S-134 kapanisi degildir.
Alan/BYREF/escape omru, genel CLONE/RETAIN/DROP lowering'i ve gercek
native/JS/WASM provider parity'si halen ayri kapanis kanitlari ister.

## 6. Kayit tutarsizliklari ve kapanis disiplini

- S-118 iki farkli konu icin kullanilmis: recursion ve surface kaydi.
  Tarihce silinmesin; konulu alias/capraz baglanti ile ayristirilsin.
- S-112 birden fazla ilerleme basligina sahip; tek ozet durumu ve alt halka
  listesi gerekir. Ilk basligin durumunu tek basina gercek sayma.
- S-030 eski "tamamlandi/dort motor" metni yeni Faz1 kismi kaydiyla
  duzeltilmis. Eski metin tarihcedir, yeni K7 gecerli.
- S-128 karar-bekliyor etiketi 24.09 keyword karariyla eskimistir;
  uygulama/onay bekleme birbirinden ayrilmali.
- S-132 DURUM basliginda kapandi grubunda, ayni kaydin aciklamasinda ayri
  acik. `src/type_binding/type_builtin_registry.fbs:54` CSNG=TYPE_F64;
  bu acik kapanmis sayilmamali.
- S-074 PRINT ve GSL secili S-075 kapanislarini eski acik listeden tekrar
  acma. GSL extension ve raylib Models/Shaders farkli kapsamlardir.
- S-144'te secili FFI duzeltmeleri var, expression/stack kalanlari var.
  Tek TAMAMLANDI etiketi alt isleri gizlememeli.
- SDL3 kaydi 319 export/334 wrapper, secili 8x4 headless kanit bildiriyor;
  eski 39 fonksiyon envanteriyle raporlanmamali. Tum SDL3 API tamamlandi
  sonucu da cikarilmamali.
- Son baska-ajan genis regresyon kaydi 626/630; dort library_type_contract
  dususu mevcut WIP ile ilgili. Bu sayi burada yeniden uretilmis degildir.
- Yuzey matrisinde MISSING=0 veya emit basarisi calisma/parity kaniti degil.

Kapanis formati: karar/scope + motor + source/binary hash + test komutu +
beklenen ve gercek sonuc + bilinen dislamalar. Beklenen redler ayri sayilsin.

## 7. Uygulama sirasi ve sahipler

1. **Karar uzlastirma:** D01-D09 onerileri Mete'ye sunulur. K1-K8 tekrar
   oylatilmadan korunur. Tarihce taramasinin kalan sayfalari ayri is olarak izlenir.
2. **Codex dogruluk halkasi:** S-148 DIM initializer denetimi ve S-134 B2
   mevcut kabul paketi tamamlandi; `library_type_contract` 30/30. Genel
   CLONE/RETAIN/DROP lowering, alan/BYREF/escape omru ve provider parity'si
   acik kaldi.
3. **Claude TASK referans:** S-030 Faz1B canonical MIR ve S-149 `TASK OF T`
   parser/semantic/MIR halkasi 108/108 ile dogrulandi. Native/JS/WASM gercek
   yurutme, S-146 ve S-147 ayri kabul adimlaridir.
4. **Kutuphane tipi cekirdek sozlesmesi:** tek registry/paket surumu/provider
   policy, field/param/return/array/BYREF omur ve hata cleanup. Native/JS/WASM
   hedefleri ayni kabul vektorleriyle, desteklenmiyorsa acik red.
5. **S-146 tasarimini kilitle, Faz2A izolasyon:** transitive effects, guvenli
   arguman, task context, worker havuzu, cancel/shutdown/stres. SHARED'in tum
   uygulamasini veya JOINALL'i bu paketin on kosulu yapma.
6. **Faz2B acik paylasim:** ortak lock kimligi, seq_cst atomic, managed shared
   handle/generation/omur, array REDIM, payload politikasi. Sonra BYSHARED/PIN.
7. **Antigravity:** erken JS fail-fast/SLOT_DEF paralel yurur; library provider
   ve JS Worker/WASM host yetenegi sozlesme sabitlendikce gelir. WAT uretimi,
   WASM dogrulama ve gercek calistirma ayri kabul adimlaridir.
8. **Ortak genisletmeler:** S-113 typed pointer; S-135 iterator CHAIN/ZIP;
   OOP surumlu hedef paketleri; typed collections/S-147; S-136 generator;
   sonra COMPLEX/POLYNOMIAL/MATRIX gibi paketlerle genisletme yeterliligi testi.
9. **Surum kapisi:** sabit kapsam matrisi, pozitif/negatif/omur/stres/parity,
   uretilebilir artifact, dokuman/ornek migration, tum acik dislamalar.

Her is icin yeni bir prompt zorunlu degildir; ayni onayli kapsam icinde
araliksiz devam edilebilir. "Her sey mukemmel" ve acik uclu kutuphane/OOP
evreni icin guvenilir en az prompt sayisi verilemez. Olculebilir hedef,
yukaridaki paketlerin kabul kosullaridir; kapsam ve hedef sayisi kilitlenmeden
kesin sayi vermek plan degil tahmin olur. Bu belge genel bitis vaadi vermez.

## 8. Hemen karar verilebilecek kisa paket

Onerilen onay paketi:

1. S-146 yonu kabul; D01-D07 guvenlik/ABI aciklamalariyla duzeltilsin.
2. TASK OF T + tipsiz TASK birlikte kabul (S-149); ortuk OBJECT->T yok.
3. Grup JOIN tum uyeleri drain etsin; ilk hata eklenme sirasiyla gelsin.
   ERRORTEXT hatayi gozlenmis saysin mi, ayri acik secim olarak kalsin.
4. Native once izole gercek async (2A), sonra SHARED/ATOMIC (2B);
   JOINALL/PIN/BYSHARED cekirdek kapanisini geciktirmesin.
5. OOP davranis degisiklikleri ayri surumlu paket; bug duzeltmeleri beklemesin.

S-148, value-copy hatasi, test kosucu hatalari ve mevcut K1-K8 uygulamasi
icin tekrar tasarim onayi gerekmiyor; yalniz dosya sahipligi koordinasyonu var.
S-149 `TASK OF T` karari kabul edildi ve canonical MIR senkron referans
108/108 ile kanitlandi; gerçek native/JS/WASM target parity için ayrı uygulama
kanıtı gerekir.
