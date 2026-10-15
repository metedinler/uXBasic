# 21. Hedefler: x64, JS, WAT/WASM ve tarayıcı

Bir uXBasic programı tek kaynak dosyadır; derleyici onu beş ayrı yolla çalıştırabilir: iki yorumlayıcı (**AST**, **MIR**), yerel kod (**x64**), JavaScript (**JS**) ve WebAssembly (**WAT/WASM**). Tarayıcı ayrı bir motor değildir; JS ve WASM çıktısının çalıştığı yerdir.
Bu bölüm her hedefin ne ürettiğini, nasıl çalıştırıldığını, hangi dil özelliklerini taşıdığını ve hangilerini **açıkça reddettiğini** anlatır. Ana ilke Bölüm 1'dekidir: bir hedef ya aynı sonucu verir ya da net bir hatayla reddeder; sessizce yanlış çıktı vermemelidir. Bu ilkenin bugünkü durumu burada ölçülerle verilir.

> **Dürüst özet.**
> * **AST, MIR ve x64** dil yüzeyinin neredeyse tamamında aynı sonucu verir; farklar kütüphane çağrılarında ve hızdadır (Bölüm 20).
> * **JS** dilin büyük bölümünü taşır ama `THROW`, `INTERFACE` ve 64 bit tamsayılar gibi yerlerde **sessizce yanlış** sonuç üretir (G-JS-2 … G-JS-8). Dosya, `SHELL` ve DLL çağrıları yürütme anında düşer. `GOTO` ve `GOSUB` `20261014_0253`'ten beri çalışır (7.6).
> * **WASM** bugün yalnız **tamsayı** programları için çalışır; metin, ondalık sayı ve nesne alanları desteklenmez ya da yanlış çalışır.
> * Her ikisi de bir yorumlayıcının yerini **tutmaz**: üretim programı için x64'ü, tarayıcıda gösterim için JS'i, küçük bir tamsayı hesabı için WASM'ı seçin.

## 21.1 Hedefler bir bakışta

| Hedef | Komut | Ne üretir? | Nasıl çalışır? | En iyi olduğu yer |
|---|---|---|---|---|
| **AST yorumlayıcı** | `uxb run k.uxb` | — (doğrudan çalıştırır) | Sözdizimi ağacını yürütür | Referans davranış; küçük denemeler |
| **MIR yorumlayıcı** | `uxb run k.uxb --interpreter-backend MIR` | — | Ara dili (MIR) yürütür | Derleyici hatası ayıklama; kütüphane çağrıları AST'den hızlı |
| **x64 yerel kod** | `uxb bld k.uxb --build-x64 --build-x64-out cikti\k.exe` | `.exe` | MIR → NASM → bağlayıcı | Üretim; hız; kütüphaneler |
| **JavaScript** | `uxb jsw k.uxb --js-out k.js` | `.js` | `node k.js` ya da tarayıcı | Tarayıcıda çalışan program |
| **Tarayıcı sayfası** | `uxb jsw k.uxb --emit-browser --html-out k.html --js-out k.js` | `.html` + `ux_runtime.js` + `.js` | Tarayıcıda açılır | Gösterim, öğretim |
| **WAT metni** | `uxb wat k.uxb --emit-wat --wat-out k.wat` | `.wat` | İnsan okuyabilir WebAssembly | İnceleme |
| **WASM ikilisi** | `uxb wat k.uxb --emit-wasm --wasm-out k.wasm --wat-out k.wat --wat2wasm=tools\wabt\bin\wat2wasm.exe` | `.wasm` + `run_wasm.js` + `ux_wasm_runtime.js` | `node run_wasm.js` ya da tarayıcı | Küçük, taşınabilir tamsayı hesapları |

Aynı programın bütün hedeflerde çalıştığını tek komutla sınamak için aşağıdaki araç kullanılır. Program yalnız tamsayı yazdırır, çünkü WASM'ın ortak paydası budur.

{{ARAC:hedefler/bes_motor_ayni_program|baslik=Aynı program, beş motor|anlat=evet}}

## 21.2 Eşlik: hangi hedef ne kadarını yapar?

Bu kılavuzdaki her örnek, hedefler için ayrı ayrı çalıştırılmıştır. Toplam şudur: {{ESLIK_TOPLAM}}
Grup grup tablo Bölüm 1.3'tedir. Düşük JS ve WASM sayıları iki nedenden gelir: **(1)** hedef özelliği açıkça reddeder (kütüphane çağrıları, dosya G/Ç, görevler), **(2)** hedef özelliği sessizce yanlış çalıştırır (aşağıdaki listeler). İkincisi daha ciddidir ve her satırın karşısında bir `G-` kaydı vardır.

### Özelliğe göre hedef tablosu

| Özellik | AST | MIR | x64 | JS | WASM |
|---|---|---|---|---|---|
| Tamsayı, döngü (`FOR`, `DO WHILE`), `IF`, özyineleme | ✔ | ✔ | ✔ | ✔ | ✔ |
| `PRINT` ile tamsayı | ✔ | ✔ | ✔ | ✔ | ✔ |
| Metin (`STRING`) yazdırma | ✔ | ✔ | ✔ | ✔ | ✖ açık ret (G-WASM-8) |
| Ondalıklı sayı (`F32`, `F64`) | ✔ | ✔ | ✔ | ✔ | ✖ açık ret (G-WASM-7) |
| 64 bit tamsayı (`I64`, `U64`) | ✔ | ✔ | ✔ | ⚠ `Number`'a düşer, 2^53'ten büyük değerler bozulur (G-JS-4) | ✖ 32 bite sığmayan sabit geçersiz WAT üretir (G-WASM-9) |
| `PRINT a, b` (virgül bölgesi) | ✔ | ✔ | ✔ | ✖ yürütme anında hata (G-JS-8) | ⚠ iki ayrı satır (G-WASM-2) |
| `&H`, `&O`, `&B` sabitleri | ✔ | ✔ | ✔ | ⚠ `undefined` (G-JS-1) | ⚠ geçersiz WAT (G-WASM-9) |
| `HEX`, `OCT`, `BIN` | ✔ | ✔ | ✔ | ✔ | ⚠ boş ya da `0` (G-WASM-4) |
| `TRY` / `THROW` (yordamdan fırlatma) | ✔ | ✔ | ✔ | ⚠ yakalanmaz (G-JS-2) | — |
| `CLASS`, `NEW` | ✔ | ✔ | ✔ | ✔ | ⚠ alanlar `0` okunur (G-WASM-1) |
| `INTERFACE` çağrısı | ✔ | ✔ | ✔ | ⚠ `nan` (G-JS-3) | — |
| `MAGIC` ile `+`, `AND`, `OR`, `XOR` işleci | ✔ | ✔ | ✔ | ✔ (`20261013` ve sonrası; öncesinde `AND`/`OR`/`XOR` açık ret) | ⚠ `0` (G-WASM-6) |
| `DICT`, `SET` | ✔ | ✔ | ✔ | ⚠ `TRUE` yerine `1` (G-JS-5) | ⚠ boş (G-WASM-3) |
| `ATOMIC` | ✔ | ✔ | ✔ | — | ⚠ boş ya da `0` (G-WASM-5) |
| Görevler (`SPAWN`, `TASK`, `THREAD`) | ✔ | ✔ | ✔ | ✖ örnek grubu `53_kv_gorev`: 0/10 | ✖ aynı grupta 0/10 |
| `GOTO` (ileri ve geri), `GOSUB` … `RETURN` | ⚠ `GOSUB` döngü içinde yanlış (G-AKIS-4) | ✔ | ✔ | ✔ (`20261014_0253`'ten; öncesinde sonsuz döngü ya da yürütme anı hatası, G-JS-9) | ✔ metinsiz programda (`20261014_0253`'ten; öncesinde açık ret ya da geçersiz WAT, S-123) |
| Dosya G/Ç, `SHELL … OUTVAR`, `RANDOMIZE`, `STATIC` yerel | ✔ | ✔ | ✔ | ✖ yürütme anında "host binding missing" (G-JS-7) | — |
| Kütüphane çağrısı (`CALL(DLL, …)`) | ✔ (yavaş) | ✔ | ✔ | ✖ açık ret | ✖ açık ret |
| `CODEPTR(Fonksiyon)` | ✖ açık ret (G-DIS-8) | ✖ açık ret | ✔ | ✖ yürütme anında hata ("pointer values are not available on the JavaScript target") | ✖ geçersiz WAT (G-WASM-9) |
| DLL'den dönen işaretçiye ofset eklemek | ✖ jeton hatası (G-DIS-9) | ✖ jeton hatası | ✔ | — | — |
| `VARPTR`, `PTR` bayt aritmetiği | ✔ | ✔ | ✔ | ✖ açık ret (G-JS-10) | — |

(— = sınanmadı ya da yok. ⚠ = **sessiz yanlış sonuç**; ✖ = açık ret ya da yürütme anı hatası.)

## 21.3 x64 hedefi: yerel kod

x64 hedefi MIR'den NASM üretir ve FreeBASIC bağlayıcısıyla bir `.exe` oluşturur (Bölüm 2). Sonuç, Windows'ta çalışan, sıradan bir programdır.

**Dağıtım gereksinimleri (ölçüldü).** x64 EXE **bağımsız değildir** (✖ G-HEDEF-22): en küçük program bile (`PRINT 42`, 64 KB) yanında `uxb_runtime.dll` ve beş bağımlı DLL'i (`libwinpthread-1.dll`, `libgcc_s_seh-1.dll`, `libstdc++-6.dll`, `libuv-1.dll`, `libtbb12.dll`; toplam yaklaşık 6,8 MB) ister. `uxb bld` bu altı dosyayı EXE'nin klasörüne kendisi kopyalar (Bölüm 2.5); EXE'yi taşırken hepsini birlikte taşıyın. Beşi yetmez (sistem klasörleri `PATH`'teyken denendi): biri bile eksikse program başlamaz ve uXBasic'in iletisi yoktur, yalnız işletim sisteminin yükleyici hatası görünür (çıkış kodu −1073741515, yani `0xC0000135`). Kütüphane kullanan bir program (`uxjson`, 90 KB) buna ek olarak **kullandığı kütüphanenin DLL'ini** ister; o DLL eksikse program başlarken uXBasic'in açık bir hatasıyla durur:

```text
uXBasic x64 FFI resolve failed: LoadLibraryA dll=uxjson.dll symbol=uxjson_version
```

(çıkış kodu 127). Program bütün DLL sembollerini **başlangıçta** çözer; bu yüzden hiç çağrılmayan bir kütüphane işlevi bile eksikse program hiç başlamaz (G-KUT-2).

**Hız.** x64, yorumlayıcılardan kıyaslanamayacak kadar hızlıdır: basit bir `FOR` döngüsü AST'de yaklaşık 0,1 ms/tur, MIR'de yaklaşık 1 ms/tur, x64'te pratikte sıfırdır (G-HIZ-1). Bu yüzden zaman ölçüm ya da büyük döngü gerektiren her program x64 olarak derlenmelidir.

**Yalnız x64'te olanlar.** `CODEPTR` (uXBasic işlevini C kütüphanesine geri çağrı olarak verme, Bölüm 20), DLL işaretçisine ofset ekleme (G-DIS-9) ve DLL'lerin çalışması bu hedeftedir.

## 21.4 JS hedefi ve tarayıcı

`uxb jsw` MIR'den JavaScript üretir. Üretilen dosya, kendi içinde çalışma zamanını da taşır (`globalThis.uxb`), `node` ile ya da tarayıcıda çalışır.

### Üretilen JS nasıl çalışır?

| Konu | Ne olur? |
|---|---|
| Giriş noktası | `MAIN` bir **asenkron** işlevdir (`async`); dosya yüklenince kendiliğinden başlar ve bir **Promise** döndürür |
| Otomatik başlatma | `uxb.autoRun = false` (dosya yüklenmeden önce) yazılırsa program başlamaz; `globalThis.uxbMain()` ile siz başlatır ve Promise'i beklersiniz |
| Çıktı | `PRINT` satırları `uxb.console.println` ile `console.log`'a gider |
| Çıktıyı yönlendirmek | `uxb.console.setSink({ writeLine: … })` (dosya yüklenmeden önce) çıktıyı sizin işlevinize verir; sink varken konsola yazılmaz |
| Kullanıcı işlevleri | `uxb.exports` altında büyük harfli adla durur (`MAIN`, `FAKT`); işlevler de asenkrondur: çağrı bir Promise döndürür (`FAKT(5)` bekleyince `120`) |
| Ana bilgisayar çağrıları | `uxb.host.call(ad, bağımsız_değişkenler)` çalışma zamanında vardır (21.6) |
| Sayı biçimi | Çalışma zamanı sayıları uXBasic'in kurallarına göre yazar: `nan`, `inf`, `-inf`, en çok 16 anlamlı basamak, `1e+20` gibi iki basamaklı üs |

{{ARAC:hedefler/js_cikti_baglama|baslik=Tarayıcı çıktısını sayfaya ya da başka bir yere bağlamak|anlat=evet}}

### Tarayıcıda açmak

`uxb jsw … --emit-browser` üç dosya üretir; üçü aynı klasörde durmalıdır:

| Dosya | İçerik |
|---|---|
| `k.html` | Başlık, boş bir `<pre id="uxb-console">` ve iki `<script>` satırı |
| `ux_runtime.js` | Çalışma zamanı (`globalThis.uxb`) |
| `k.js` | Programın kendisi |

JS sayfasını doğrudan dosya olarak da açabilirsiniz; ama WASM dosyasını `fetch` ile yüklemek çoğu tarayıcıda `file://` altında engellenir, bu yüzden yerel bir sunucu kullanın: klasörde `python -m http.server 8765` çalıştırıp `http://127.0.0.1:8765/k.html` adresine gidin (bu kılavuzdaki sayfalar da böyle açılarak denenmiştir).
Dikkat: üretilen HTML'deki `<pre id="uxb-console">` **boş kalır**; PRINT satırları yalnız geliştirici konsoluna (`F12`) gider (G-JS-11). Çıktıyı sayfada görmek için aşağıdaki sayfa, çalışma zamanından sonra ve programdan önce bir sink bağlar. Bu sayfa **2026-10-10'da yerleşik bir tarayıcıda** (yerel sunucudan) açılarak denenmiştir: sayfada 8 satırın hepsi göründü, konsolda hata yoktu.

```html
<!doctype html>
<html><head><meta charset="utf-8">
<title>uXBasic: çıktı sayfaya yazılır</title>
</head>
<body>
<h1>Kareler</h1>
<pre id="uxb-console"></pre>
<script src="ux_runtime.js"></script>
<script>
  // uXBasic PRINT çıktısını konsol yerine sayfadaki <pre> öğesine yönlendirir
  uxb.console.setSink({
    writeLine: function (satir) {
      document.getElementById("uxb-console").textContent += satir + "\n";
    }
  });
</script>
<script src="kare.js"></script>
</body></html>
```

Bu sayfanın programı `tools\kitap\kilavuz_v2\web_ornekleri\kare.uxb` dosyasındadır; sayfanın kendisi aynı klasördeki `kare_sayfa.html`'dir. Sink kalıbı yukarıdaki araç örneğinde otomatik olarak da sınanır.

### Bilinen JS sınırları

{{SINIRLAR:JS}}

## 21.5 WAT/WASM hedefi

`uxb wat` önce WAT (WebAssembly metni) üretir; `--emit-wasm` ile `wat2wasm` aracı bu metni `.wasm` ikilisine çevirir (Bölüm 2). Üretilen klasörde iki yardımcı dosya da bulunur: `ux_wasm_runtime.js` ve `run_wasm.js`.

| Konu | Ne olur? |
|---|---|
| Dışa aktarımlar | `MAIN` (programın kendisi), her `FUNCTION` **büyük harfli adla** (`FAKT`), ayrıca `memory` |
| İçe aktarımlar | Dört tane, hepsi `ux` modülünden: `host_call4`, `host_call16`, `print_i32`, `print_f64`. Kullanılmasalar bile her modülde bulunur |
| Sayı yazdırma | `print_i32` içe aktarmasıyla; çalışma zamanı sayıyı yazar, satır sonunu ayrı bir çağrıyla bildirir |
| Ana bilgisayar çağrıları | `host_call4(id, …)`: 1 yazdır, 1000 satır sonu, 3 zaman, 4 rastgele, 10–17 matematik, 80–84 diziler; `host_call16`: 90–95 sınıf ve nesne işlemleri |
| Çalıştırma | `node run_wasm.js` ya da `WebAssembly.instantiate(bayt, globalThis.uxbWasmImports)` ardından `MAIN()` |
| Desteklenmeyenler | Ondalık sayı (G-WASM-7), metin (G-WASM-8), skaler `BYREF` (G-WASM-12), 8 baytlık `Q` bellek erişimi (G-WASM-14) ve `PTR`/`I64`/`U64`/`F32`/`F64` dönüşümleri (G-WASM-15) derlemede açıkça reddedilir |
| **Sessiz yanlışlar** | Ama `/`, `**`, `NOT`, karşılaştırma değeri, `SGN` ve geniş tipler **reddedilmeden yanlış** çalışır (G-WASM-16 … G-WASM-20); aşağıdaki "WASM'da yazmayın" tablosuna bakın |
| Sanal bellek | Varsayılan ve **en çok** 1 MiB; daha büyük `VIRTUAL boyut` derlemede reddedilir. Sınır dışı erişim ham `unreachable` tuzağıyla durur (G-WASM-13) |

{{ARAC:hedefler/wasm_cikti_baglama|baslik=WASM modülünü ana bilgisayar içe aktarmalarıyla çalıştırmak ve çıktıyı yakalamak|anlat=evet}}

### WASM'ı tarayıcıda çalıştırmak

Aşağıdaki sayfa, tamsayı yazdıran bir programın WASM çıktısını (`kare_tam.wasm`) tarayıcıda çalıştırır. Çalışma zamanı `process` bulamadığı için sayıyı `globalThis.ux.print`, satır sonunu `globalThis.ux.println` ile bildirir; sayfa bu ikisini tanımlayarak çıktıyı `<pre>` içine yazar (G-WASM-11). **2026-10-10'da yerleşik bir tarayıcıda** denenmiştir: yedi satır (`1 4 9 16 25 55 720`) göründü, konsolda hata yoktu.

```html
<!doctype html>
<html><head><meta charset="utf-8">
<title>uXBasic WASM: kareler</title>
</head>
<body>
<h1>WASM kareler</h1>
<pre id="cikti"></pre>
<script src="ux_wasm_runtime.js"></script>
<script>
  var satir = "";
  globalThis.ux = {
    print: function (metin) { satir += metin; },
    println: function () {
      document.getElementById("cikti").textContent += satir + "\n";
      satir = "";
    }
  };
  fetch("kare_tam.wasm")
    .then(function (r) { return r.arrayBuffer(); })
    .then(function (b) { return WebAssembly.instantiate(b, globalThis.uxbWasmImports); })
    .then(function (sonuc) {
      globalThis.uxbWasmInstance = sonuc.instance;
      sonuc.instance.exports.MAIN();
    })
    .catch(function (hata) { document.getElementById("cikti").textContent = "HATA: " + hata; });
</script>
</body></html>
```

(Dosyalar: `web_ornekleri\kare_tam.uxb` ve `kare_wasm.html`. `.wasm` ve `ux_wasm_runtime.js` yukarıdaki `uxb wat` komutuyla üretilir.)

### Elle WAT yazmak ve uXBasic'ten çalıştırmak

uXBasic'in kendi WASM'ı `ux` içe aktarmalarını gerektirdiğinden `uxwasmrt` kütüphanesiyle (Bölüm 20) yüklenemez (G-WASM-10). Ama içe aktarması olmayan, elle yazılmış bir WAT modülü `uxwasmrt` ile uXBasic programından çağrılabilir; bu, bir uXBasic programına WASM ile eklenti yazmanın bugünkü yoludur (Bölüm 20'deki `wat_el_yazisi_uxwasmrt` örneği).

### WASM'da yazmayın, yerine şunu yazın

WASM modülü her değeri bugün `i32` olarak işler; aşağıdaki yazımlar derleyici tarafından **reddedilmez** ama yanlış sonuç verir. Her satır bu kılavuzun hazırlığında beş motorda denenmiş bir ifadeden çıkarılmıştır (`a = 7`, `b = 2` tamsayı değişkenleri):

| Yazmayın | WASM'da ne olur? (diğer motorlar) | Yerine yazın |
|---|---|---|
| `a / b` (değişkenler) | Boş satır ve `0` (`3.5`) | `a \ b` (tamsayı bölme) |
| `a ** b` | Boş satır ve `0` (`49`) | Çarpma döngüsü |
| `INT(a / b)`, `I32(a / b)`, `CINT(a / b)` | Boş ya da `0` (`3`, `3`, `4`) | `a \ b` |
| `NOT a`, `~a` (değer olarak) | `0` (`-8`); `NOT 0` → `1` (`-1`) | `a XOR -1`; koşulda `NOT` kullanılabilir |
| `PRINT a > b`, `(a > b) + 5` | `1` ve `6` (`-1` ve `4`) | Karşılaştırma sonucunu yazdırmayın; `IF` içinde kullanın |
| `SGN(x)` | Boş satır ve `0` (`-1`, `0`, `1`) | `IFF(x > 0, 1, IFF(x < 0, -1, 0))` |
| `F128`, `BIG*` değişkenleri | `i32` gibi işlenir | Bu tipleri WASM'da kullanmayın |
| Tanımsız ya da gerçeklenmemiş işlev çağrısı | Hata yok, boş satır ve `0` | Her yerleşik işlevi WASM'da önce sınayın |

Bu tablonun amacı çözüm göstermek değil, sessiz hataya karşı uyarmaktır: asıl çözüm, derleyicinin bunları açık ret ya da doğru sonuçla işlemesidir ve ilgili kayıtlar Ek G'dedir.

### Bilinen WASM sınırları

{{SINIRLAR:WASM}}

## 21.6 Native ↔ JS ↔ WASM köprüsü: bugün olan ve hedeflenen

uXBasic'in uzun vadeli hedefi, yerel (native) programlarla tarayıcı/JS/WASM tarafının çift yönlü konuşabilmesidir. Aşağıda bugün **çalışan** parçalar ile **hedef** olanlar ayrılmıştır.

| Yön | Durum | Nasıl? |
|---|---|---|
| uXBasic (native) → JavaScript işlevi | **[ÇALIŞIYOR]** | `uxjsruntime` ile QuickJS'te JS yüklenir, işlev JSON bağımsız değişkenlerle çağrılır (Bölüm 20, `js_kural_motoru`) |
| JavaScript → uXBasic ana bilgisayarı | **[ÇALIŞIYOR]** | QuickJS içinde `uxb.host.call("UXB_RUNTIME_INFO", [])` ana bilgisayar işlevini çağırır; `uxjsruntime` resmî duman testi bunu sınar |
| uXBasic (native) → WASM işlevi | **[KISMİ]** | `uxwasmrt` ile yalnız içe aktarması olmayan, elle yazılmış modüller (G-WASM-10) |
| uXBasic (native) → Python | **[ÇALIŞIYOR]** | `uxpython` (Bölüm 20) |
| Tarayıcı → uXBasic programı (WASM/JS) | **[ÇALIŞIYOR, SINIRLI]** | WASM: dışa aktarılan işlev doğrudan çağrılır (`instance.exports.FAKT(5)` → `120`, yalnız tamsayı). JS: `uxb.exports.FAKT(5)` bir Promise döndürür, beklenince `120` verir |
| Tarayıcı ↔ yerel `.exe` çift yönlü iletişim | **[HEDEF]** | Bugün hazır bir köprü yoktur; ortak bir dil üzerinden (JSON, HTTP) kurulabilir: tarayıcı sayfası `fetch` ile bir yerel uXBasic HTTP hizmetine bağlanır (Bölüm 20 `uxhttp` örneği istemci tarafını gösterir) |
| Ortak host sözleşmesi (adlandırılmış çağrılar, olaylar) | **[HEDEF]** | `uxb.host.call(ad, bağımsız değişkenler)` çekirdeği vardır; hedef, yerel ve JS tarafının aynı çağrı tablosunu paylaşmasıdır |

## 21.7 Çalışan komutlar listesi

Aşağıdaki komutların hepsi bu kılavuzun yazımında çalıştırılmış ve çıktısı doğrulanmıştır.

| Amaç | Komut |
|---|---|
| AST'de çalıştır | `uxb run k.uxb` |
| MIR'de çalıştır | `uxb run k.uxb --interpreter-backend MIR` |
| x64 `.exe` üret | `uxb bld k.uxb --build-x64 --build-x64-out cikti\k.exe` |
| JS üret, çalıştır | `uxb jsw k.uxb --js-out k.js` ardından `node k.js` |
| Tarayıcı sayfası üret | `uxb jsw k.uxb --emit-browser --html-out k.html --js-out k.js` |
| WAT üret | `uxb wat k.uxb --emit-wat --wat-out k.wat` |
| WASM üret, çalıştır | `uxb wat k.uxb --emit-wasm --wasm-out k.wasm --wat-out k.wat --wat2wasm=tools\wabt\bin\wat2wasm.exe` ardından `node run_wasm.js` (`run_wasm.js` en son derlenen `--wasm-out` dosyasının adını okur; `--wasm-out` verilmezse hiç `.wasm` yazılmaz: ✖ G-CLI-33) |
| Elle WAT'ı WASM'a çevir | `tools\wabt\bin\wat2wasm.exe modul.wat -o modul.wasm` |
| Yerel sunucudan tarayıcıda aç | klasörde `python -m http.server 8765`, sonra `http://127.0.0.1:8765/k.html` |

## 21.8 Hedef seçme rehberi

| İstediğiniz | Seçin | Neden |
|---|---|---|
| Hız, büyük döngü, kütüphane çağrısı | **x64** | Yorumlayıcılar basit bir döngüde tur başına 0,1 ms (AST) ve 1 ms (MIR) harcar, x64 pratikte hiç; JS ve WASM kütüphane çağrısını reddeder (G-HIZ-1) |
| Tarayıcıda çalışan, etkileşimli program | **JS** | Metin, ondalık ve nesneler çalışır; G-JS kayıtlarını bilerek yazın |
| Çok küçük, taşınabilir bir hesap (tamsayı) | **WASM** | Boyut çok küçük (bu bölümdeki örnek 1,1 KB), tarayıcıda ve node'da çalışır; metin ve ondalık yok |
| Bir davranışın doğrusunu öğrenmek | **AST**, sonra MIR | Referans yorumlayıcılar; fark çıkarsa MIR/x64'ü sorgulayın |
| Hata ayıklama (derleyici içi) | **MIR** | Ara dil çıktısı (`--mir-json-out`) ve yorumlayıcı |
| Başka bir programa eklenti | **uxwasmrt** + elle WAT, ya da **uxjsruntime** | Kontrollü, kum havuzlu çalıştırma (Bölüm 20) |

## 21.9 Tasarlanan hedef sözleşmesi (◇ HEDEF)

Bu bölümün başındaki tablolar **bugünkü** durumu gösterir. Tasarım belgeleri (18.09 yüzey matrisi, 24.09 hedef kılavuzu) ise hedefi şöyle koyar:

### Teslim sınıfları ve kapanış kuralı

Dilin **her** yüzey öğesi (anahtar sözcük, işleç, yerleşik işlev, önişlemci yönergesi, tip, kütüphane) her hedefte aşağıdaki altı yoldan **tam birine** bağlanır:

| Teslim sınıfı | Anlamı |
|---|---|
| `DIRECT` | Hedef dilin ya da komut kümesinin doğrudan karşılığı |
| `PORTABLE_RUNTIME` | Hedefe taşınabilir ortak çalışma zamanı (uXBasic'in kendisiyle yazılmış sağlayıcı) |
| `TARGET_RUNTIME` | Hedefin kendi çalışma zamanı kütüphanesi (JS ya da WASM çalışma zamanı dosyası) |
| `HOST_PROVIDER` | Konak hizmeti: Node, tarayıcı, WASI, işletim sistemi |
| `EMULATED` | Başka yapılarla taklit edilen karşılık |
| `COMPILE_TIME` | Derleme zamanında çözülür, çalışma kodu üretmez (önişlemci, meta) |

**Kapanış kuralı:** üretim yapısında `MISSING` (karşılık yok), `SILENT_SKIP` (sessizce atlama) ve sahte `HOST_FALLBACK=PASS` yasaktır; karşılığı olmayan öğe derlemeyi **açık hatayla** durdurur. Makine çıktıları
(`surface_backend_matrix.json`, `builtin_backend_matrix.json`, `type_backend_matrix.json`, `library_target_matrix.json`, `design_semantics_matrix.json`) üretilir ve resmî JS/WASM yapısında zorunlu bir hücre boşsa yapı başarısız olur.
Bugün bu makine denetimi yoktur: `uxb mtx` diye bir fiil kayıtlı değildir (bilinmeyen fiil sessizce hiçbir şey yapmaz, ✖ G-CLI-32), matris elle yazılmış 35 öğeden ibarettir; kaynak temelli envanter aracı 2896 kayıt çıkarır ama hücrelerini ölçmez (G-HEDEF-17, S-153, S-170).

Daha eski bir politika (`docs/KEYWORD_LAYER_MATRIX_POLICY.md`, 2026-05-29) anahtar sözcük × katman matrisinin her hücresi için sekiz **karar durumu** tanımlar: `IMPLEMENTED`, `COMPILE_TIME_ONLY`, `RUNTIME_CALL`, `NATIVE_ONLY`, `JS_ONLY`, `WASM_UNSUPPORTED`, `DIAGNOSTIC_ONLY`, `REMOVED_OR_RESERVED`. Kod taramasından gelen gözlemsel durum ile karar durumu ayrı sütunlarda tutulur; bir kapı bütün hücrelerin bu listeden olmasını ve JS / WASM / tarayıcı karar sütunlarının bulunmasını ister. Yukarıdaki teslim sınıfları bu durumların hedef başına ayrıntılı hâlidir; matrisi üreten ve denetleyen araçlar bugün kaynak ağacında yoktur (✖ G-ARAC-5).

### Tasarlanan fiziksel temsiller

| Yapı | x64 | JavaScript | WASM | Bugün |
|---|---|---|---|---|
| `I32`, `F64` | yerel | `Number` | `i32`, `f64` | ✔ (WASM'da `F64` yok, G-WASM-7) |
| `I64`, `U64` | yerel | `BigInt` | `i64` | JS `Number`'a düşer (G-JS-4); WASM 32 bit sığmazsa geçersiz WAT (G-WASM-9) |
| `F80`, `F128`, `BIG*` | yerel / çalışma zamanı sağlayıcısı | çalışma zamanı nesnesi | doğrusal bellekte çalışma zamanı | yalnız AST'de kısmen (G-TIP-9) |
| `CLASS` | nesne + vtable | çalışma zamanı sınıfı | yerleşim + tip/vtable kimliği | JS'te metotla alan yazma ✖ (G-JS-13); WASM'da alanlar `0` (G-WASM-1) |
| `THREAD` / `PARALEL` | işçi çalışma zamanı | Worker havuzu | WASM iş parçacığı / konak işçisi | JS ve WASM'da yok (G-GOREV-6, G-GOREV-7, G-HEDEF-12) |
| `ATOMIC` | yerel atomik | `SharedArrayBuffer` + `Atomics` | WASM atomikleri | JS yok, WASM boş çıktı (G-WASM-5) |
| `PTR` / MemoryRef | yerel / MemoryRef | `DataView` / MemoryRef | doğrusal bellekte ofset | `VARPTR` JS'te açık ret (G-JS-10) |
| `DLL` / `API` | yerel ABI | konak sağlayıcısı | `import` / sağlayıcı | JS'te yürütme anı ret (G-JS-7) |
| Web meta | yapıt üretimi | doğal hedef | JS/WASM paketi | Tarayıcı manifesti kısmen; çoğu bildirim yalnız kaydedilir (G-ONISLEM-14) |
| `STRING` | UTF-8 bayt | çalışma zamanı metin sarmalayıcısı | doğrusal bellekte tanımlayıcı | WASM metin yok (G-WASM-8) |

### Tasarımın 35 kanonik tipi

| Aile | Tipler | Bugün kullanılabilir mi? |
|---|---|---|
| Kontrol | `VOID`, `BOOLEAN` | `BOOLEAN` ✔ |
| Tamsayı | `I8`, `U8`, `I16`, `U16`, `I32`, `U32`, `I64`, `U64`, `BIGINT` | ✔ (`BIGINT` G-TIP-1) |
| Kayan nokta | `F32`, `F64`, `F80`, `F128` | `F32`, `F64` ✔; `F80`, `F128` kısmen (G-TIP-9) |
| Geniş sayı | `BIGF`, `BIGD`, `BALL` | AST (G-TIP-9) |
| Metin | `STRING`, `WSTRING` | `STRING` ✔; `WSTRING` ✖ (G-TIP-8) |
| İşaretçi | `PTR`, `STRPTR`, `WSTRPTR` | `PTR` ✔; `STRPTR` yalnız `CALL(DLL)` argüman tipi; `WSTRPTR` ✖ |
| Genel | `ARRAY`, `OBJECT`, `VARIANT`, `ANY` | `ARRAY` ✔; `VARIANT`, `ANY` ✖ (G-TIP-8) |
| Kullanıcı | `TYPE`/`STRUCT`/`UNION`, `CLASS`, `INTERFACE` | ✔ |
| Çağrı ve tutamaç | `FUNCTION_PTR`, `DLL_HANDLE`, `FILE_HANDLE` | ✖ (G-TIP-8) |
| Hedef özel | `JS_OBJECT`, `WASM_EXTERNREF` | ✖ (G-TIP-8) |

### WASM'da metin ve bellek: tasarım önerisi (◇ HEDEF)

`docs/tasarim/uXBasic WASM hedefi Metinler için doğrusal bellek mimarisi.md` (2026-10-13), WASM hedefinde metnin **WASM'ın kendi doğrusal belleğinde** tutulmasını önerir. Belgenin kendisi bunun doğrulanmış bir uygulama durumu değil **tasarım önerisi** olduğunu ve kesin karardan önce bütün motorların bugünkü davranışının ölçülmesi gerektiğini yazar; bu yüzden aşağıdakiler kesinleşmiş bir sözleşme değil ◇ HEDEF'tir (G-HEDEF-23, G-HEDEF-24). Belgenin örneği: `s = "ÇİP"` üç karakterdir ve UTF-8'de beş bayttır (`C3 87`, `C4 B0`, `50`).

| Konu | Öneri | Bugün |
|---|---|---|
| Kodlama | UTF-8 | AST, MIR, x64: UTF-8 bayt dizisi; JS: JavaScript metni; WASM: **metin yok** (G-WASM-8) |
| İç gösterim | 16 baytlık tanımlayıcı: `ptr`, `byte_len`, `capacity`, `flags` (dörder bayt, `i32`). Bu düzen WASM standardı değil uXBasic'in iç düzenidir ve dışarıya doğrudan açılmaz | Yok |
| Metin ömrü | Üç tür: **sabit** (`"Merhaba"`), **sahipli dinamik** (`ad = ad + "!"`), **geçici** (`LEFT(ad, 3)`). Sahiplik açıktır, gerektiğinde kopyalanır; ilk uygulamada başvuru sayacı yoktur | Yok |
| Bellek ayırma | `memory.grow` bütün belleği 64 KiB sayfalarla büyütür, tek tek metinleri değil; metinler için doğrusal bellek üstünde ayrı bir ayırıcı gerekir | Yok. `VIRTUAL` bellek WASM'da en çok 1 MiB'dir (21.5) |
| Çalışma zamanı işlevleri | `UX_STR_ALLOC`, `UX_STR_RESERVE`, `UX_STR_ASSIGN`, `UX_STR_CLONE`, `UX_STR_APPEND`, `UX_STR_SLICE`, `UX_STR_COMPARE`, `UX_STR_RELEASE`, `UX_STR_UTF8_VALIDATE` (WASM komutları değil, uXBasic çalışma zamanı işlevleri) | Yok |
| MIR işlemleri | `STR_CONST`, `STR_ASSIGN`, `STR_CONCAT`, `STR_LENGTH`, `STR_BYTELENGTH`, `STR_SUBSTRING`, `STR_COMPARE`, `STR_RELEASE`; belge, var olan işlemlerin yeniden kullanılmasını ve yalnız eksik anlamların eklenmesini ister | Karşılığı büyük ölçüde var: `MIR_STR_NEW`, `MIR_STR_ASSIGN`, `MIR_STR_CONCAT`, `MIR_STR_LEN`, `MIR_STR_LEFT`, `MIR_STR_RIGHT`, `MIR_STR_MID`, `MIR_STR_COMPARE` (`src/mir/mir_opcode.fbs`). `BYTELENGTH` ve `RELEASE` yok; WASM üretici bu işlemleri indirgemez |
| JS'in rolü | Yalnız dış ortam köprüsü (`TextDecoder` / `TextEncoder`); metin işlemleri JS'e yönlendirilmez, aynı modül tarayıcı dışında da çalışır | Bugünkü WASM çalışma zamanı `ux_wasm_runtime.js`'e bağlıdır (21.5) |
| `LEN` ve kardeşleri | `LEN` Unicode kod noktası sayar, yeni **`BYTELEN`** bayt sayar; `LEFT`/`MID`/`RIGHT` bir UTF-8 karakterinin ortasından kesmez | Yerel motorlarda `LEN` bayt, JS'te karakter sayar (G-TIP-4). **`BYTELEN` yoktur:** AST `unsupported call BYTELEN` (çıkış 5), MIR `RT_LIBRARY_CALL` bağlı değil (çıkış 13), x64 derlemez, JS yürütme anında durur (G-HEDEF-24) |
| Adres modeli | WASM adresi işletim sistemi adresi değildir; `VARPTR`, `PEEK`/`POKE`, `MEMCOPY`/`MEMFILL` doğrusal bellek sınırlarına uyar; dinamik metnin iç adresi yeniden ayırmada değişebileceğinden `VARPTR` ile alınan adresin ne kadar süre geçerli olduğu açıkça tanımlanır | WASM'da `VARPTR` ve geniş tipler reddedilir (G-WASM-14, G-WASM-15); sınır dışı erişim ham tuzakla durur (G-WASM-13) |
| Adres genişliği | Tek WASM32 doğrusal bellekle başlanır, WASM64 sonraya bırakılır; adres genişliği soyutlanır | Yalnız WASM32 |
| Dış arayüz | İleride WebAssembly **Component Model**: UTF-8 ve adres/uzunluk/ayırma sözleşmesi; iç tanımlayıcı doğrudan başka dillere açılmaz | Yok |
| Kabul ölçütü | Aynı kaynak AST, MIR, x64 ve WASM'da **aynı sonucu** verir; sınama kümesi: Türkçe karakter, boş metin, birleşik Unicode karakter, uzun metin, iç içe işlev, başarısız bellek ayırma ve metin dizileri | WASM, metin kullanan programı derlemede reddeder |

Belge şu uygulama sırasını önerir: (1) ortak metin sözleşmesini (UTF-8, uzunluk, alt metin, karşılaştırma, sahiplik, geçici sonuçlar) belirlemek; (2) MIR metin işlemlerini tamamlamak, ama mevcut kod görülmeden yeni işlem eklememek; (3) WASM çalışma zamanı kitaplığını yazmak; (4) WAT/WASM üretimini bu kitaplığa bağlamak; (5) motorlar arası karşılaştırma testlerini yapmak. **Programcı için sonuç:** bugün metin işleyen bir programı WASM'a taşımayın (21.10).

Web hedeflerinde gerçek `i64`/`f32`/`f64`, doğrusal bellekte metin ve koleksiyon çalışma zamanı, `WASI` ya da konak dosya sistemi, tarayıcıda sanal dosya sistemi, `SHELL` için sandbox hizmeti, `Canvas`/`WebAudio` ile grafik-ses-girdi, `BYREF` için ortak hücre
tasarımın parçalarıdır (G-HEDEF-18). `GOSUB` dönüş yığını ve etiketli `GOTO` ayrı bir web adayında (`bin/uxb_codex_web_w_20261007.exe`, 13/18 hücre) geçtikten sonra `20261014_0253` ile ana yayına girdi: JS'te ve WASM'da (metinsiz programlarda) çalışır (7.6).

## 21.10 Hedeflerle ilgili programlama kararları

* **Önce x64 ya da AST/MIR'de doğrulayın**, sonra JS/WASM'a taşıyın; JS/WASM çıktısını yerel çıktıyla karşılaştırmadan yayınlamayın (21.1'deki araç bunu tek komutla yapar).
* JS'e taşınacak programda `THROW`, `INTERFACE`, 2^53'ten büyük tamsayılar, `&H` sabitleri, `PRINT a, b` ve `DICT`/`SET` değerlerinin yazdırılması gibi **sessiz yanlış** kayıtlarını (G-JS-1 … G-JS-8) kullanmayın.
* WASM'a taşınacak programı **yalnız tamsayı** ile yazın; metin ve ondalık gerekiyorsa JS ya da x64 seçin.
* WASM, tamsayı programda bile **sessiz yanlış** verebilir: `/`, `**`, `NOT`, `SGN` ve karşılaştırma sonucunun değeri bunların başında gelir (yukarıdaki "yazmayın" tablosu). WASM çıktısını **her zaman** AST çıktısıyla karşılaştırın; "derlendi ve çalıştı" doğruluk kanıtı değildir.
* Tarayıcıda çıktıyı sayfaya göstermek istiyorsanız `setSink` (JS) ya da `globalThis.ux.print/println` (WASM) bağlayın; üretilen `<pre id="uxb-console">`'a güvenmeyin.
* Üretilen JS'in giriş noktasının asenkron olduğunu unutmayın: bitişi beklemeniz gerekiyorsa `uxb.autoRun = false` yapıp `uxbMain()` Promise'ini bekleyin.
* x64 programını başka bir bilgisayara götürürken `bld`'in yazdığı klasördeki **altı çalışma zamanı DLL'ini** (yoksa program iletisiz yükleyici hatasıyla başlamaz, G-HEDEF-22) ve kullandığı **kütüphane DLL'lerini** yanına koyun; eksik kütüphane DLL'i başlangıçta net bir hatayla durur.
* Bir özellik hedefte "sınanmadı" ya da "—" ise çalışıyormuş gibi davranmayın; her hedefte sessiz hata değil, açık ret beklenir ve bulduğunuz sessiz hatayı bildirin.
