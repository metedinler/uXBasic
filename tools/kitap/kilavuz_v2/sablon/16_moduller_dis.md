# 16. Modüller, ad alanları ve dış dünya

Program büyüdükçe iki ihtiyaç doğar: kodu **bölümlere ayırmak** (modül, ad alanı, dosya) ve **başka yerde yazılmış kodu çağırmak** (C kütüphanesi, Windows API'si).
Bu bölüm ikisini de anlatır. Her tablo çalıştırılarak doğrulanmıştır; çalışmayanlar ayrıca ve açıkça yazılmıştır.

## 16.1 Kodu bölmenin yolları

| Araç | Ne yapar? | Ne zaman seçilir? | Kapsamı |
|---|---|---|---|
| `INCLUDE "x.uxb"` | Başka dosyayı **metin olarak** yerine yapıştırır (Bölüm 17.7) | Büyük programı dosyalara bölmek | Dosya düzeyi; **adlar ortak** kalır |
| `MODULE … END MODULE` | İşlev, yordam, değişken ve tipleri bir ad altında toplar | Bir işin kodunu bir arada tutmak | Üyelere `Modul.Uye` ile erişilir |
| `NAMESPACE … END NAMESPACE` | Ad alanı; değişken ve işlev gruplar, **iki kez açılırsa birleşir** | Aynı grubun parçalarını farklı yerlerde yazmak | Üyelere `Alan.Uye` ile erişilir |
| `USING ad` | Modülün/ad alanının üyelerini **kısa adla** kullanıma açar | Sık kullanılan bir modül | Dosyanın geri kalanı ya da içinde yazıldığı işlev |
| `ALIAS kisa = uzun` | Bir adı **metin olarak** başka ada çevirir (önişlemci aşamasında) | Uzun bir ad alanı adını kısaltmak | Bu satırdan sonrası |

Önemli ayrımlar:

* **`MODULE` ile `NAMESPACE` neredeyse aynı davranır.** Fark: `NAMESPACE` yalnız ad gruplar ve iki kez açılabilir; `MODULE` bir *birim* kavramıdır. Bugün ikisi de işlev, yordam ve değişken taşır.
* **`USING` yetki vermez, yalnız kısaltır.** Modülün değişkenlerine zaten `Modul.degisken` ile her yerden erişilir (gizlilik yoktur).
* **`ALIAS` bir dil bildirimi değil, metin değişimidir.** Önişlemci `ALIAS KA = Cok_Uzun_Ad` satırını siler ve sonraki `KA` sözcüklerini `Cok_Uzun_Ad` ile değiştirir. Bu yüzden `ALIAS` tipleri, işlevleri, ad alanlarını aynı şekilde kısaltır.
* **`%%ALIAS {a} AS {b}` ile `ALIAS a = b` ayrı yazımlardır**; ikisi de metin değiştirir, ama ilki önişlemci yönergesidir (Bölüm 17.4).

**`ALIAS` nerelerde var? (Mete'nin sorusu, 2026-10-15; altı yolda ölçüldü, `20261014_0253`)**

| Yazım | Katman | Sonuç |
|---|---|---|
| `ALIAS KA = Cok_Uzun_Bir_Ad_Alani` | dil (önişlemci aşamasında metin değişimi) | ✔ ad alanı, tip (`ALIAS Sayi = I32`) ve işlev (`ALIAS Plus = Topla`) için altı yolda çalışır |
| `%%ALIAS YAZ AS PRINT` | önişlemci yönergesi (meta katman 1) | ✔ anahtar sözcüğe ve `SUB` adına ikinci ad verir (altı yolda aynı; WASM yalnız `PRINT` metin kapısı yüzünden derlemez) |
| `%%ALIAS A AS B` ve `%%ALIAS B AS A` | önişlemci | ✔ döngü açık hatayla reddedilir (`PREPROCESSOR_ALIAS_CYCLE`, çıkış 2; altı yolda aynı) |
| `REM %%ALIAS KISA AS UZUN` | meta katman 2/3 (tasarım) | ✖ yorumdur: hatasız kabul edilir, hiçbir şey yapmaz (G-META-1) |
| `DECLARE … LIB "x.dll" ALIAS "ad"` | dış kaynak bildirimi | başka anlam: DLL'deki işlev adı (G-DIS-2) |

Yani meta sisteminin ilk katmanı önişlemci komutlarıdır (Bölüm 18.1) ve `%%ALIAS` o katmanın bir komutu olarak vardır; `REM %%…` ile yazılan öznitelik katmanlarında `ALIAS` yoktur, çünkü o katmanlar henüz yoktur.

## 16.2 `MODULE`

Modül, kendi **değişkenlerini** ve **işlevlerini** taşıyabilir. Modül değişkeni, modülün bütün işlevleri için ortaktır ve program boyunca değerini korur:

{{ORNEK:61_kv_modul/stok_moduller|baslik=Orta düzey: üç modülle stok programı}}

* Modülden **dışarı** `Depo.Say()` gibi nitelikli adla seslenilir; modül **içinden** aynı modülün üyeleri nitelensiz çağrılır (`Say()`), başka bir modülün üyeleri nitelenerek çağrılır (`Depo.Say()`).
* Modül değişkenine ilk değer yazılabilir (`DIM n AS I32 = 7`); dışarıdan `Sayac.adet = 5` ile değiştirilebilir. Gizlilik yoktur.
* Modül içinde `TYPE` tanımlanabilir ve `USING` ile kullanılır (`DIM p AS Nokta`).

## 16.3 `NAMESPACE`, `USING` ve `ALIAS`

{{ORNEK:61_kv_modul/ad_alani_birlesir|baslik=Ad alanı birleşir, ALIAS kısaltır, USING işlev içinde}}

| Soru | Cevap (ölçüldü) |
|---|---|
| Aynı `NAMESPACE` iki yerde açılırsa? | İçerikleri **birleşir**; ikinci açılışta birinci açılıştaki değişkenler kullanılabilir |
| `USING` işlev içinde yazılabilir mi? | Evet; etkisi o işlevle sınırlıdır |
| `USING` hangi sıra ile aranır? | İlk açılan önce. Çakışmada **hata yoktur**, ilk modül kazanır (G-MODUL-3) |

## 16.4 Modül ve ad alanı sınırları

Aşağıdakiler bu bölüm yazılırken **çalıştırılarak** bulunmuştur. Özellikle `CONST` sorunu üç motorda üç ayrı yanlış sonuç verir; modül içinde sabiti işlevden okumayın:

{{SINIRLAR:MODUL}}

## 16.5 Kütüphane başlığı: `INCLUDE "include/modules/….uxmh"`

Standart kütüphaneler `include/modules/` altında `.uxmh` başlıklarıdır; `INCLUDE` ile eklenir ve **kütüphane adıyla** çağrılır:

{{ORNEK:22_kurallar/kutuphane_include|baslik=Kütüphane başlığı ve ad alanı çağrısı}}

Hangi kütüphanenin ne işe yaradığı, nasıl çağrıldığı ve örnekleri Bölüm 20'dedir.

## 16.6 Dış dünyaya çağrı: `CALL(DLL, …)` ve `CALL(API, …)`

uXBasic, **C çağrı kuralına uyan** her DLL işlevini çağırabilir. Sözdizimi:

```basic
CALL(DLL, "dll_adi.dll", "islev", DÖNÜŞ_TİPİ, ÇAĞRI_KURALI, "ARG_TİPİ1,ARG_TİPİ2", arg1, arg2)
CALL(API, "kütüphane",    "islev", DÖNÜŞ_TİPİ)
```

| Parça | Değerler | Not |
|---|---|---|
| Dönüş tipi | `VOID`, `I32`, `U32`, `I64`, `U64`, `F64`, `PTR`, `STRPTR` | `F32` yoktur |
| Çağrı kuralı | `CDECL`, `STDCALL` | Win64'te tek ABI vardır; ikisi de aynı sonucu verir |
| Argüman tipleri | Virgülle ayrılmış **tek metin**; argüman sayısıyla birebir aynı olmalıdır | Uyuşmazlık **ayrıştırma hatasıdır** (`argument type-list count mismatch`) |
| Argümansız işlev | Tip listesi **hiç yazılmaz**: `CALL(DLL, "kernel32.dll", "GetCurrentProcessId", I32, STDCALL)` | Boş metin `""` yazmak AST ve MIR'de hata verir (G-DIS-5) |
| En çok argüman | 10 (11. argüman ayrıştırma hatasıdır: `exceed the ABI10 limit`) | — |
| Metin | `STRPTR`: metnin geçici bir **kopyasını** geçirir | C'nin tamponu değiştirmesi `STRING`'e dönmez (G-DIS-5) |
| Dizi | `PTR` + `VARPTR(dizi(0))` | Örnek: ortalama alan C işlevine `F64` dizisi geçirilir |
| DLL adı | Yalnız **dosya adı** (`mini.dll`); büyük/küçük harf ve `.dll` uzantısı serbesttir (`UCRTBASE`, `ucrtbase`) | `..`, `\` ve geçersiz karakter reddedilir; **mutlak yolu** yalnız AST reddeder, MIR ve x64 kabul eder (G-DIS-10): taşınabilir olmak için yolsuz yazın |
| İşlev adı | **Büyük/küçük harf duyarlıdır** (`abs` var, `ABS` yok: `GetProcAddress failed`) | DLL'in dışa aktardığı yazımla yazın |
| `F64` argüman | Ondalıklı sabit (`2.0`) ya da `F64` değişken verin | Tamsayı verilirse x64'te çöp sonuç çıkar (G-DIS-7) |

`CALL(DLL, …)` **kesin tiplidir**; yanlış argüman türü sessiz çevrilmez:

| Hata | İleti | Ne zaman? |
|---|---|---|
| Tip listesi ile argüman sayısı uyuşmaz | `CALL(DLL): argument type-list count mismatch expected=2 actual=1` | Ayrıştırma |
| Bilinmeyen tip simgesi | 20261007: AST `CALL(DLL) invalid argument type list token BILINMEZ`; MIR `signed integer argument is not numeric`; **x64: hata yok, çöp değer döner** (✖ SESSİZ, G-DIS-11). 20261013_1514 ve sonrası (S-445): üç yerel motorda da `UXB_FFI_ARGUMENT_TYPE_LIST: CALL(DLL): invalid argument type-list token: BILINMEZ` | 20261007: çalışma anı (x64'te hiç); sonrası: ayrıştırma |
| DLL yok | `LoadLibraryA failed or module cache is full` (kod 9218) | Çalışma anı |
| İşlev yok | `GetProcAddress failed` (kod 9219) | Çalışma anı |
| Yanlış tür (`2.5` → `I32`) | `CALL(DLL) I32 requires a 32-bit integer argument` | Çalışma anı |
| Mutlak yol / üst klasör | `library must not be absolute path (9208)` (yalnız AST) / `path segments not allowed (9207)` | Çalışma anı |

### Yorumlayıcı köprüsü ve `PTR` değerleri (ABI10 sözleşmesi)

AST ve MIR yorumlayıcıları `CALL(DLL, …)` çağrısını ortak bir köprüyle yürütür: `uxffi.dll` (libffi tabanlı; `libffi-8.dll` ile birlikte `uxb.exe`'nin klasöründe, yani `bin\` içinde bulunmalıdır). Böylece iki yorumlayıcı aynı çağrı kuralını kullanır ve 0–10 parametreli, karışık tipli (tamsayı, ondalık, işaretçi, metin) çağrıları destekler. x64 hedef çağrıyı köprüsüz, doğrudan üretir: Microsoft x64 kuralıyla ilk dört argüman `RCX`/`RDX`/`R8`/`R9` ya da `XMM0`–`XMM3` yazmaçlarına, 5.–10. argümanlar yığına sekizer baytlık yuvalarla yazılır; 32 baytlık gölge alan ayrılır ve çağrıdan önce yığın 16 bayta hizalanır. Ondalık argümanın ham 64 bitlik örüntüsü korunur.

İki yolun gözlenebilir farkı **`PTR` değeridir** (✖ **FARK, G-DIS-12**): DLL'den dönen işaretçi yorumlayıcılarda 31 bitlik etiketli bir **tutamaçtır**, x64'te gerçek adrestir. Tutamaç DLL'e geri verilince gerçek adrese çözülür, ama programda başka bir şey için kullanılamaz:

| `h = CALL(DLL, "uxstats.dll", "uxstats_vec_create", PTR, CDECL, "I32", 4)` sonrası | AST | MIR | x64 |
|---|---|---|---|
| `PRINT h` | `1073807361` | `1073807361` | `2978650682656` (her çalıştırmada başka) |
| `PEEKB(h)` | `NATIVE PEEKB out of range` | `memory load failed` | `0` (gerçek bellek) |
| `h` üzerinde toplama (`h + 32`) | ✖ `stale or invalid pointer handle token` (G-DIS-9) | ✖ aynı | ✔ |

`STRPTR` dönüşünde köprü C metnini yorumlayıcının kendi `STRING` değerine **kopyalar**; DLL'in geçici tamponu programa çıplak adres olarak sızmaz. `_free`, `_destroy` ya da `_release` ile biten bir işlev çağrılınca tüketilen tutamaç silinir (silinmiş tutamacı yeniden kullanmak: G-KUT-10). Sonuç: **`PTR` değerini yalnız DLL'e geri verin**; yazdırmayın, `PEEK`/`POKE` ile ya da toplama ile kullanmayın.

Sistem DLL'lerinden birkaç gerçek çağrı:

{{ORNEK:62_kv_dis/dll_sistem_islevleri|baslik=ucrtbase.dll ve kernel32 çağrıları}}

**Üst düzey: kendi C kütüphanenizi yazıp çağırmak.** C ile küçük bir DLL derlenir; uXBasic programı tamsayı, ondalık, metin ve dizi göstericisi geçirerek çağırır. Aynı program üç yerel motorda çalıştırılıp çıktılar karşılaştırılır:

{{ARAC:dis/kendi_dll|baslik=C kütüphanesi yazıp CALL(DLL) ile çağırmak}}

**`CALL(DLL)` ile `CALL(API)` farkı:**

| | `CALL(DLL, …)` | `CALL(API, …)` |
|---|---|---|
| Kullanım | Herhangi bir DLL'in herhangi bir işlevi, tip listesiyle | Sistem API'si; kütüphane adı `"kernel32"` ya da `"kernel32.dll"` yazılabilir |
| Argümanlar | Tip listesi + değerler | Dönüş tipinden sonra değerler doğrudan yazılır, tip listesi yoktur: `CALL(API, "kernel32", "Sleep", I32, 1)` |
| Denetim | İzin listesi (16.7), tip denetimi | Aynı politika |
| Yerel motorlar | AST, MIR, x64 ✔ | AST, MIR, x64 ✔ |
| JS / WASM | ✖ yürütme anı hatası / açık ret (G-JS-7) | Aynı |

## 16.7 İzin listesi (FFI politikası)

Her `CALL(DLL)` çağrısı bir **izin listesine** sorulur. Liste, `build/manual/config/ffi_allowlist.txt` dosyasıdır (yoksa yerleşik bir varsayılan kullanılır: `KERNEL32!GetTickCount`, `KERNEL32!Sleep`, `USER32!MessageBeep` …).

```text
UXB_FFI_ALLOWLIST_V1
# dll|işlev|imza[|çağrı_kuralı[|sha256|imzalayan]]
mini.dll|mini_topla|I32|CDECL
```

Liste dışı bir çağrıda AST şunu yazar (gerçek çıktı):

```text
WARN: FFI CALL(DLL) event=ffi_policy_decision mode=REPORT_ONLY decision=deny lib=MINI.DLL symbol=mini_topla sig=I32 conv=CDECL abi=WIN64-MSABI allow=0 deny_code=9206 phase=allowlist-lookup reason=deny-not-allowlisted
```

**Önemli:** kip bugün **yalnızca raporlamadır** (`REPORT_ONLY`): çağrı reddedilmez, uyarı yazılır ve çalışır. Zorlayıcı kipi (`ENFORCE`) seçmek için komut satırı ya da ortam değişkeni yoktur (G-DIS-3).
Yani izin listesi bir **güvenlik duvarı değil, bir denetim kaydıdır**. Hata kodları: 9201 yanlış argüman sayısı · 9202 kötü kütüphane · 9203 kötü sembol · 9204 kötü imza · 9205 BYREF hedefi · 9206 listede yok · 9207/9208/9209 DLL yolu kuralları · 9210–9214 sağlama/imza doğrulaması · 9215 liste okunamadı · 9218 DLL yüklenemedi · 9219 işlev bulunamadı.

## 16.8 Dış kaynak bildirimleri: `DECLARE … LIB`, `IMPORT`, `INLINE`

Bu üç yazım yüzeyde vardır ama bugün **çalışan bir sonuç vermez**. Doğru yol 16.6'daki `CALL(DLL, …)`'dir:

| Yazım | Ne olması istenir? | Bugünkü gerçek | Kayıt |
|---|---|---|---|
| `DECLARE FUNCTION f LIB "x.dll" ALIAS "f" (…) AS tip` | DLL işlevini kendi adıyla çağırmak (`f(2, 3)`) | Yalnız bildirimdir; ad doğrudan çağrılamaz | G-DIS-2 |
| `IMPORT(C, "x.c")`, `IMPORT(CPP, …)`, `IMPORT(ASM, …)` | C/C++/ASM kaynağını derleyip bağlamak | Yol doğrulanır; **derlenmez ve bağlanmaz** | G-DIS-1 |
| `INLINE("x64","nasm","sub","abi=win64;…")` … `END INLINE` | Satır içi assembly | İlke denetimi gerçek; ama hiçbir motorda çalışmaz | G-DIS-6 |
| `uxb bld … --interop` | İçe aktarma kipi | Çalışma anı hatasıyla çöker | G-DIS-4 |

{{SINIRLAR:DIS}}

## 16.9 Yardımcı araçlar: `uxbdll` ve `UXClazz`

İki küçük Python aracı derleyicinin **çekirdeğini değiştirmeden** onu genişletir. İkisi de `tools/` altındadır, derleyiciden önce ya da sonra çalışır ve ürettiği şey sıradan dosyalardır (uXBasic kaynağı, DLL).

| Araç | Girdi | Çıktı | Ne işe yarar? |
|---|---|---|---|
| `tools/uxbdll/uxbdll.py` | Derleyicinin x64 yapıtları (`program.asm`, `obj`, bağlama dosyası) + bir **dışa aktarım manifesti** (`*.uxdll.json`) | Win64 **DLL**, içe aktarma kitaplığı, `.def`, uXBasic **sarmalayıcısı** (`.bas`/`.uxmh`), denetim raporu | uXBasic kodunu başka programların çağırabileceği bir DLL ürününe çevirmek |
| `tools/uxclazz/uxclazz.py` | `.uxclz` dosyasındaki `CLAZZ VALUE/DATA/ENTITY/…` bildirimleri | Normal uXBasic `CLASS` kodu (kurucu, Get/Set, `Equals`, `MAGIC HASH/CLONE/TOSTRING`, `ToJson`) | Tekrar eden sınıf kodunu elle yazmamak (kaynak üretici) |

### `uxbdll`: uXBasic kodundan DLL

Akış üç adımdır: **(1)** derleyici modülü x64 yapıtlarına çevirir (`uxb bld modul.uxb --build-x64 --x64-mode MIR --build-x64-out klasör`; çıktı adı `.exe` ile bitmiyorsa klasör sayılır);
**(2)** manifest, hangi iç rutinlerin hangi **kararlı C adıyla** dışa açılacağını söyler (`{"public": "uxoop_counter_add", "internal": "UXOOP_COUNTER_ADD", "return": "I32", "args": […]}`); **(3)** `python tools/uxbdll/uxbdll.py --manifest m.json --force --run` DLL'i bağlar ve `objdump` ile dışa aktarımı denetler.
Sınıfın kendisi dışarıya açılmaz: dışarıya **düz köprü rutinleri** (`create`, `add`, `release`) açılır ve nesneyi yaratan DLL onu serbest bırakır. DLL yüklenince `main` çalışmaz; başlatma ve kapatma için `*_INIT` ve `*_SHUTDOWN` işlevlerini açıkça dışa verin.
Başka bir DLL'deki sınıftan kalıtım güvenli değildir; DLL sınırında arayüz/vekil, bileşim ve opak tutamaç kullanın.

{{ARAC:dis/uxbdll_ile_dll|baslik=uXBasic modülünü DLL yapıp nesnelerini uXBasic'ten kullanmak}}

### `UXClazz`: sınıf kodunu üretmek

`CLAZZ DATA Balik` gibi bildirimler derleyiciye **doğrudan verilmez** (`CLAZZ` anahtar sözcüğü derleyicide yoktur, G-HEDEF-2); araç onları önce `CLASS` koduna çevirir. Profiller: `VALUE`, `DATA`, `ENTITY` (kimlik ve sürüm alanını kendisi ekler), `COMPONENT` (`USES` bileşime çevrilir), `ACTOR` ve `NATIVE` (şimdilik yalnız metadata). `DERIVE` ile `EQ`, `HASH`, `CLONE`, `TOSTRING` ve `JSON` üretilir.

{{ARAC:dis/uxclazz_uretici|baslik=CLAZZ DATA bildiriminden çalışan sınıf üretmek}}

> **✖ AST gerilemesi (G-NESNE-29, S-523).** `DERIVE TOSTRING` ile üretilen sınıf `MAGIC TOSTRING` taşır; bu yüzden `20261013` (12:37) ve sonrasında AST yorumlayıcıda `f.GetBoy()` gibi sayısal bir metodun sonucunu bir değişkene yazmak `0` verir: yukarıdaki örnek AST'de `boy = 0`, `metin = 0`, `esit = 0` yazar ve motor karşılaştırması "HAYIR" der (MIR ve x64 doğrudur, `20261007`'de üç motor aynıydı). Örneğin altındaki durum satırında AST'nin `≠` görünmesinin nedeni budur. `DERIVE TOSTRING` kullanmayan sınıflar etkilenmez; AST'de yalnız sonucu doğrudan `PRINT` etmek çalışır.

{{SINIRLAR:ARAC}}

## 16.10 Dış dünya ile ilgili programlama kararları

* Windows ya da C kütüphanesi çağıracaksanız **`CALL(DLL, …)`** kullanın; `DECLARE … LIB` ve `IMPORT` bugün çalışmaz.
* Kendi C kodunuzu **önce `gcc -shared` ile DLL'e derleyin**, DLL'i programın çalıştığı klasöre koyun ve yalnız dosya adıyla çağırın.
* Argüman tip listesini her zaman çağrının yanına yazın ve sayıyı denetleyin; derleyici uyuşmazlığı reddeder, ama tip **türünü** (`I32` ↔ `F64`) siz seçersiniz.
* `F64` argümana ondalıklı sabit (`2.0`) ya da `F64` değişken verin; tamsayı x64'te sessizce yanlış sonuç üretir (G-DIS-7).
* Sonucu önce bir değişkene alın, sonra yazdırın; AST'nin izin listesi uyarısı çıktı satırının ortasına karışabilir.
* İzin listesi uyarılarını (`WARN: FFI …`) güvenlik denetimi olarak okuyun; bugün çağrıyı engellemezler.
* `CALL(DLL)` yalnız **yerel** motorlar içindir. JS ve WASM'a taşınacak programda dış çağrıyı bir arayüze ayırın (Bölüm 21, 22).
* Modül içinde `CONST` kullanıp işlevden okumayın; sabiti modülün dışında tanımlayın.
* İki modülde aynı adı verip ikisini birden `USING` ile açmayın; nitelikli çağrı (`A.F()`) yazın.
* DLL adını **yolsuz** yazın; mutlak yolu AST reddeder, MIR ve x64 kabul eder (G-DIS-10).
* uXBasic kodunu DLL yapacaksanız **`uxbdll`** kullanın: sınıfı değil `create/çağır/release` köprü rutinlerini dışa açın, nesneyi yaratan DLL'in onu serbest bırakmasını sağlayın ve `*_INIT`/`*_SHUTDOWN` işlevleri verin. Bugünkü derleyicide manifestte iç adları `uxb_fn_` önekiyle yazın ve `build_program` açık olsun (G-ARAC-1); hiç çağrılmayan `DELETE`'li rutinler için modüle başvuru satırları ekleyin (G-ARAC-4).
* `UXClazz` çıktısını derlemeden önce okuyun: `DERIVE JSON` kullanmayın ve setter parametre adlarını tekilleştirin (G-ARAC-2, G-NESNE-16).
