# 19. Kütüphane tipleri: dile yeni tip eklemek

Bazı tipler tek bir işlemci yazmacına sığmaz: kesin kesir (`1/3`), karmaşık sayı, polinom, matris, birimli ölçü. Bunları derleyicinin çekirdeğine gömmek derleyiciyi şişirir; uXBasic'in tasarım kararı bunun yerine **tip eklemeyi öğretmektir**.
Bu bölüm bu "kütüphane tipi" mekanizmasını, bugün **gerçekten** çalışan tek örneği (`RATIONAL`) ve bugün işe yarayan yolu (sınıf + `MAGIC`) anlatır.

> **Dürüst özet.** Kütüphane tipi mekanizması (manifest, sözleşme, yaşam döngüsü kuralları) yazılmış ve sınanmıştır, ama **yalnız MIR yorumlayıcısında** çalışır.
> `RATIONAL` kullanan program öteki beş yolda (AST, MIR-x64, eski AST-x64, JS, WASM) **derleme aşamasında** `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile açıkça reddedilir (çıkış 1; EXE, JS ya da WASM dosyası üretilmez). Sessiz yanlış sonuç kalmamıştır, ama tasarım hedefi (aynı kaynak altı yolda da çalışsın) hâlâ ◇ HEDEF'tir (G-KTIP-1). Kendi matematik tipinizi bugün **sınıf + `MAGIC`** ile yazın (19.5).

## 19.1 Üç katmanlı tip modeli

| Katman | İçerik | Derleyici ne bilir? | Örnek |
|---|---|---|---|
| 1. Fiziksel çekirdek tipleri | `BOOLEAN`, `I8 … U64`, `F32 … F128`, `PTR`, `STRING` | Boyut, hizalama, yazmaç, bellek gösterimi | `DIM x AS I32` |
| 2. Geniş sayısal çekirdek | `BIGINT`, `BIGF`, `BIGD`, `BALL` | Çalışma zamanı yordamları (`__ux_bigint_mul` gibi çağrılar normaldir) | `DIM g AS BIGINT` |
| 3. Matematiksel tip kütüphaneleri | `RATIONAL`, `COMPLEX`, `POLYNOMIAL`, `MATRIX`, `VECTOR`, `QUATERNION`, `INTERVAL`, `MODINT`, `MODPOLY` … | Yalnız **sözleşmeyi** (yerleşim, işleçler, yaşam döngüsü) | `DIM r AS RATIONAL` |

Tasarımın temel fikri: bir kütüphane tipini kullanmak "assembly üretilemez" demek değildir. `c = a + b` önce `RATIONAL.ADD(a, b)` çağrısına indirgenir, oradan MIR'e, MIR'den x64'e gider. Yani program yine **yerel kod**dur; yalnız toplama yordamı kütüphanededir.
Yarın biri `MATRIX`, `TENSOR`, `QUATERNION`, `DECIMAL128`, `UNIT<METER>` eklemek isterse **derleyici kaynağı değişmez**.

## 19.2 Bugünkü durum: `RATIONAL`

`RATIONAL`, iki `I64` olarak (pay ve payda) saklanan kesin bir kesirdir. Toplama, çıkarma, çarpma, bölme yuvarlama yapmaz; sonuç en sade kesre indirgenir.

Altı yolun hepsi `yoklama/yol_matrisi.py` ile ölçüldü (ikili `20261014_0253`; `20261013_2224` ile birebir aynı sonuç; 17 program × 6 yol). Beş yolun sonucu aynıdır, bu yüzden tabloda tek sütundadır:

| Konu | MIR | AST, MIR-x64, eski AST-x64, JS, WASM |
|---|---|---|
| Atama, işleçler, karşılaştırma | ✔ kesin (`-1 \| 0`) | ✖ derlemede reddedilir: `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` (çıkış 1) |
| Yazdırma (`3/2`) | `3/2` | — |
| `RATIONAL.CLONE(c)`, `RATIONAL.TOSTRING(c)`, `d = RATIONAL.COPY(c)` (tek işlenen) | ✔ (`3/2`). `c.TOSTRING()` çalışmaz: `method call on a null object reference` (çıkış 13) | ✖ aynı ret |
| Dizi elemanı | ✔ (boş eleman `0/1`) | ✖ aynı ret |
| `TYPE` alanı: atama ve okuma | ✔ | ✖ aynı ret |
| `TYPE` alanı: bölme sonucu | ✔ (`1/3`) | ✖ aynı ret |
| `BYVAL` parametre | ✔ (`6/1`, `3/1`) | ✖ aynı ret |
| Sıfıra bölme | `RATIONAL.DIV divide by zero` (durur, çıkış 13) | ✖ aynı ret |
| `r = 1 / 3` (ondalık değeri `RATIONAL`'a atama) | ✖ anlam çözümlemede reddedilir: `assignment cannot convert TYPE_F64 to RATIONAL` (G-KTIP-3); **altı yolda aynı** | ✖ aynı ret |

Reddeden yol iletide hedef adını yazar, ama ad üç gruba indirgenir: AST `AST`, MIR-x64 ve eski AST-x64 `NATIVE`, JS `JS`, WASM `WAT` (✖ G-HATA-13); hangi yolun reddettiği iletiden ayırt edilemez.

**Önceki derlemelerde durum çok daha kötüydü (Ek K.4).** `20261007` ikilisinde AST `RATIONAL`'ı ondalık sayı gibi hesaplardı (`3/2` → `1.5`; G-KTIP-2, G-KTIP-6) ve öteki dört yol kapanış kapısı iletisiyle (`ADIM25/26/27 close gate failed … BINARY`) reddederdi. `20261013_1341` ile `2052` arasında kapı gevşeyince MIR-x64 ham yayıcı iletisiyle (çıkış 14), JS çalışırken ("UXB host binding missing") düşerek reddetti; eski AST-x64 ve WASM ise hiç reddetmeyip **yanlış sonuç yazdı** (`3/2` için `1` ve `0`) ve AST-x64'te sıfıra bölme EXE'yi iletisiz çökertti (G-KTIP-7, G-KTIP-8). `20261013_2052`'den beri hepsi ortak kodla reddedilir (S-499).

Aşağıdaki örnek MIR yorumlayıcısı ile çalıştırılmak üzere yazılmıştır (örnek üstbilgisinde `MOTORLAR: MIR`). Kesin kesir ile `F64`'ün farkı çıktıda görünür; AST sonucu ise aynı değeri ondalık yazar:

```bash
uxb run harmonik.uxb --interpreter-backend MIR
```

{{ORNEK:63_kv_kutuphane_tipi/rational_harmonik|baslik=Kesin kesir: harmonik toplam H(5) = 137/60}}

| Benzer tipler | Fark |
|---|---|
| `RATIONAL` ve `F64` | `F64` yaklaşık değer tutar (`0.1 + 0.2 ≠ 0.3`); `RATIONAL` kesin kesir tutar ama yavaştır ve yalnız MIR'de çalışır |
| `RATIONAL` ve `BIGINT` | `BIGINT` yalnız büyük **tamsayı**; `RATIONAL` pay ve paydası `I64` sınırlı kesir |
| `RATIONAL` ve `I32 / I32` | `1 / 3` tamsayı bölmesi değil ondalık bölmedir ve `RATIONAL`'a **atanamaz** (G-KTIP-3); kesir iki `RATIONAL` değişkeni bölerek elde edilir |

## 19.3 Sözleşme: kütüphane tipi manifesti

Bir kütüphane tipi bir **JSON sözleşmesiyle** tanıtılır ve programda `LIBTYPE "dosya.library_type.json"` ile yüklenir. Sözleşme tipin bellekte nasıl durduğunu, hangi işleçleri/yaşam döngüsü işlemlerini sunduğunu ve **her hedef için** hangi sağlayıcıyı kullanacağını yazar. Gerçek bir örnek (sınama paketindeki dış `RATIONAL` manifesti):

```json
{
  "schema": "uxb.library_type.contract.v1",
  "type": "RATIONAL",
  "layout": "record",  "size_bytes": 16,  "align_bytes": 8,
  "fields": "NUM:I64,DEN:I64",
  "operators": "ADD,SUB,MUL,DIV,EQ,NE,LT,LE,GT,GE,CMP",
  "magic": "TOSTRING,CLONE,HASH",
  "lifecycle": "CONSTRUCT,NORMALIZE,COPY,CLONE",
  "storage_model": "value",  "copy_model": "bitcopy",  "clone_model": "bitcopy",  "drop_model": "none",
  "mir_policy": "call_lowering",   "mir_provider": "RATIONAL_REFERENCE",
  "js_policy": "pure_mir",         "js_provider": "RATIONAL_REFERENCE",
  "wasm_policy": "wasm_linear_memory",
  "native_policy": "native_x64",   "native_provider": "RATIONAL_X64_REFERENCE"
}
```

| Alan grubu | Alanlar | Ne anlatır? |
|---|---|---|
| Kimlik | `schema`, `type`, `package` | Sözleşme sürümü ve tipin adı |
| Yerleşim | `layout` (`record`/`opaque`), `size_bytes`, `align_bytes`, `fields` | Bellek gösterimi; `opaque` ise alanlar gizlidir |
| Yetenek | `operators`, `magic`, `conversions`, `lifecycle` | Tipin sunduğu işleçler ve yaşam döngüsü işlemleri |
| Sahiplik | `storage_model`, `copy_model`, `clone_model`, `drop_model` | Değer mi referans mı; atamada ne olur; nasıl temizlenir (19.4) |
| Hedef politikası | `abi_policy`, `mir_*`, `js_*`, `wasm_*`, `native_*` | Her arka ucun hangi sağlayıcıyı kullanacağı |

Kurallar (hepsi kapalı başarısızlık ilkesine uyar):

* Bilinmeyen, eksik, yanlış tipte ya da birbiriyle çelişen alan **reddedilir**; geçersiz kayıt var olan kaydın üzerine yazılmaz.
* Tip bir `LIBTYPE` ile tanıtılmadıysa `DIM a AS YOKTIP` ayrıştırma hatasıdır (`unknown type`). Manifest bulunamazsa `LIBTYPE: library type manifest not found`.
* Bir hedefin sağlayıcısı yoksa derleyici **sahte bir değer üretmez**, o hedefte açıkça durur (`library type lifecycle provider unavailable for NATIVE`).
* Tip, sağlayıcının desteklediği statik tipe bağlanır; uyumsuz bağ `library type provider type mismatch` ile reddedilir. MIR sağlayıcı kayıt defteri yalnız sağlayıcı **adını** değil desteklediği tip bağını da denetler: `OWNED_TEXT_REFERENCE` sağlayıcısı `TEXT_VALUE` ve `TEXT_REF` tiplerini, `RATIONAL_REFERENCE` sağlayıcısı `RATIONAL` tipini kabul eder. Kayıt defteri bugün yalnız MIR sağlayıcılarını tutar; JS, WASM ve native hedefleri sağlayıcı yokluğunu kontrollü reddeder.
* Bir işlemin kullanılabilirliği tipin kendi `operators`/`magic`/`lifecycle` bildirimiyle belirlenir; her tipe `ADD` ve `TOSTRING` zorunlu değildir (örn. aritmetiği olmayan bir veri tutamacı tanımlanabilir).

## 19.4 Yaşam döngüsü modelleri

Sahiplik dört alanla anlatılır. Bunlar tasarımdaki `MOVE_ONLY`/`COW` gibi daha ileri politikaların tamamı değildir; ilk uygulanan alt kümedir.

| Alan | Değerler | Anlamı |
|---|---|---|
| `storage_model` | `value`, `reference` | Bağımsız değer mi, paylaşılan referans mı |
| `copy_model` | `bitcopy`, `clone`, `retain`, `forbidden` | Atama ve `BYVAL` parametrede ne olur (bit kopyası / sağlayıcı kopyası / sayaç artırma / yasak) |
| `clone_model` | `bitcopy`, `provider`, `unsupported` | Açık `CLONE` isteğinin sözleşmesi |
| `drop_model` | `none`, `provider` | Ömür bitince gereken temizlik |

Tutarlılık kuralları: `copy_model=bitcopy` yalnız `value` + `drop_model=none` ile geçerlidir; `copy_model=clone`, `clone_model=provider` ve `lifecycle` listesinde `CLONE` ister; `retain`, `storage_model=reference` + sağlayıcılı `drop` + `RETAIN` ister; sağlayıcılı `drop` için `lifecycle` içinde `DROP` bulunmalıdır.

Bugün otomatik aktarımı uygulanmış tek profil `value/bitcopy/none`'dur (RATIONAL). MIR yorumlayıcısında şu davranışlar sınanmıştır:

* `b = a` bağımsız bir kopyadır; sonradan `a`'ya yazmak `b`'yi değiştirmez.
* `BYVAL` parametrenin yeniden atanması çağıranın değerini değiştirmez; `RETURN` yerel değerin yükünü çağırana taşır.
* Dizi elemanına yazılan değer, kaynağı sonradan değişse de değişmez; boş eleman `0/1`'dir; `REDIM PRESERVE` eskileri korur, yenileri `0/1` yapar.
* Kapsam çıkışında, `RETURN` ve `THROW` ile erken çıkışta yönetilen yerel değer **tam bir kez** bırakılır (çift `DROP` ve sızıntı yoktur).

Genel `CLONE`/`RETAIN`/`DROP` indirgemesi, JS/WASM/native sağlayıcıları ve iç içe yönetilen alanlar **yazılmamıştır** ve açıkça reddedilir (G-KTIP-5).

## 19.5 Bugün işe yarayan yol: sınıf + `MAGIC`

Kütüphane tipi mekanizması olgunlaşana kadar kendi matematik tipinizi **sınıf ve `MAGIC` işleçleriyle** yazabilirsiniz. Aşağıdaki Gauss tamsayıları (`a + bi`) örneği toplama, çarpma, metne çevirme ve kurucu içerir; AST, MIR, x64 ve JS'te aynı sonucu verir:

{{ORNEK:63_kv_kutuphane_tipi/gauss_tamsayisi_magic|baslik=Üst düzey: Gauss tamsayıları, MAGIC işleçleriyle}}

Bu yolun sınırları:

* Her işleç sonucu yeni bir nesnedir; AST'de bir işleç sonucunu zincirlemek ya da kendine atamak yanlış çalışır (G-NESNE-9). Sonucu hemen kullanın.
* Ondalıklı alanlarda x64'te sanal metot ve sabit atama tuzakları vardır (G-NESNE-8); tamsayı alanlı tipler (kesir, Gauss, modüler tamsayı) daha güvenlidir.
* WASM metin yazdıran programları reddeder (Bölüm 21).

## 19.6 Tasarlanan yön

| Konu | Karar |
|---|---|
| Tip çıkarımı | `r = 1 / 3` yazımı `RATIONAL` hedefini görüp kesir bölmesine dönüşecek; bu **çekirdek desteği** ister (bugün hata verir, G-KTIP-3) |
| Optimizasyon | Küçük, yan etkisiz sağlayıcı işlevleri MIR eniyileyicisi satır içine açacak; böylece kütüphane tipi performans cezası olmayacak |
| `INLINE` | Çok kritik yordamlarda doğrudan NASM gövdesi **son çare**dir (taşınabilirliği bozar); bugün çalışmaz (G-DIS-6) |
| JS ve WASM | Sağlayıcı sözleşmesi hedefe özel (`pure_mir`, `wasm_linear_memory`); JS nesnesini ya da WASM adresini kopyalamak değer semantiğini tek başına kanıtlamaz, aynı kesir aktarım sınamaları hedeflerde de geçmelidir |
| Güvenlik | Sağlayıcısı olmayan hedef **açıkça reddeder**; meta komutları bu reddi aşamaz (Bölüm 18) |
| Kütüphane tipi ve sınıf | Tip kütüphanesi `TYPE/CLASS + MAGIC/OPERATOR + MODULE` üzerinde gerçek dil tipi gibi görünür |

### Tasarımda olup bugün olmayanlar (◇ HEDEF)

| Konu | Tasarım | Bugün | Kayıt |
|---|---|---|---|
| Referans tip paketleri | `RATIONAL → COMPLEX → POLYNOMIAL`, sonra `MATRIX`, `TENSOR`, `VECTOR`, `QUATERNION`, `UNIT`, `IMAGE`, `COLOR`, `MODEL`; aday listesi daha da geniştir: `VECTOR2`, `VECTOR3`, `MATRIX4`, `EMBEDDING`, `DISTRIBUTION`, `DATAFRAME`, `SERIES`, `INTERVAL`, `FRACTION`, `MODINT`, `MODPOLY`, `DECIMAL128`, `DUAL`, `AUTODIFF`, `UNIT<METER>`; `COMPLEX(2, 3)` kurucusu; hedef tipe duyarlı `r = 1 / 3`; hesap duyarlığı denetimi (UBASIC'ten alınan fikir). `POLYNOMIAL`, sistemin gerçekten genel olduğunun kanıtı sayılır: değişken boyutlu, işaretçili bir tip derleyici çekirdeğine gömülmeden çalışmalıdır | Yalnız `RATIONAL` referans tipi vardır, yalnız MIR'de çalışır | G-HEDEF-13, G-KTIP-1, G-KTIP-3 |
| Hedef politikası | Her tip için dört seçenekten hangisinin uygulandığı **açık** olmalıdır: saf BASIC / kanonik MIR gerçeklemesi; JS gerçeklemesi ya da konak sağlayıcı sözleşmesi; WASM gerçeklemesi ya da doğrusal bellek/tutamaç sözleşmesi; yerel x64 hızlandırma ya da C ABI bağlantı katmanı. Yalnız bir Windows DLL'ine bağlı tip dilin doğal parçası olamaz | Manifestte `js_policy`, `wasm_policy`, `native_policy` alanları vardır (19.3); gerçek sağlayıcı yalnız MIR için vardır (G-KTIP-1) | G-HEDEF-14 |
| MIR biçimi | Operatör çözümü hedef bağımsız `TYPE_OP ADD, RATIONAL, a, b` gibi genel bir MIR düğümüne inebilir | Bugün `CALL RATIONAL.ADD(a, b)` biçimindedir (Bölüm 19.2) | G-KTIP-1 |
| Mimari kabul ölçütü | `DIM a, b, c AS RATIONAL` / `c = a + b` / `PRINT c` aynı kaynak koddan Windows x64'te (NASM, yerel), tarayıcıda (JS) ve WASM'da aynı sonucu vermelidir; üç gerçekleme tek uXBasic anlamının fiziksel biçimleridir, üç ayrı derleyici değildir. Ancak bundan sonra "birinci sınıf kütüphane tipi çalışıyor" denir | Bugün yalnız MIR çalıştırır | G-KTIP-1, G-HEDEF-14 |
| Paket standardı | `manifests/library_types/<paket>/<tip>.library_type.json`; paket sürümü, bağımlılık ve hedef politikası alanları; `LIBTYPE` ile yüklenen manifestlerin derleme raporunda JSON registry olarak yazılması | ◐ Kısmen (2026-10-11, S-404; `20261013_1704` ile ölçüldü): `package`, `version`, `dependencies`, `capabilities` alanlı bir manifest kabul edilir ve program MIR'de çalışır; string olmayan değer ayrıştırmada reddedilir (`LIBTYPE: library type manifest: version must be a string`), eksik alan eski manifesti bozmaz. Ama bu alan değerleri `run`, `sem` ve `bld` çıktılarının hiçbirinde görünmez: kayıt JSON'unu üreten işlev yalnız birim testlerinden çağrılır, derleme raporunda JSON registry **yoktur**. Bağımlılık denetimi, derleme raporuna bağlama ve hedef politikası da yoktur; alan, yeteneğin kanıtı değil yalnız bildirimdir | G-HEDEF-14 |
| Sağlayıcılar | JS, WASM ve native sağlayıcıların gerçek gövdesi ve aynı kabul vektörleri | Manifestte yalnız ad olarak durur. Sağlayıcı yoksa, tipi ya da işlemi desteklemiyorsa ortak tanı kodları vardır (2026-10-11, S-410; `20261014_0253` ile ölçüldü, Bölüm 12.4, Ek F): yaşam döngülü tip (`TEXT_REF`) ve `RATIONAL` AST, AST-x64, MIR-x64, yerel x64, JS, WAT ve WASM'da çıkış 1 ve `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile reddedilir; `UXB_LIBTYPE_PROVIDER_MISSING`, `UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH` ve `UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE` MIR çalışma anında (çıkış 13) çıkar ve yapılandırılmış tanı dosyasına yazılır (`phase = provider_call`). **Ölçüm:** `tests\library_type_contract` paketi `20261013_2224` ikilisinde 38 denetimin 38'ini geçer; `20261007` ikilisi 30'unu geçer (düşen sekizi yeni kod ön ekli iletiyi bekler, ikili eski iletiyi verir). Sağlayıcı gövdesi hâlâ yalnız MIR için vardır | G-KTIP-1, G-HEDEF-14, G-HEDEF-20 |
| Yaşam döngüsü | Genel `CLONE`/`RETAIN`/`DROP` indirgemesi; alan, `BYREF` ve kaçış ömrü; geçici değer ve işlev dönüşü | Yalnız değer tipleri (`value/bitcopy/none`) çalışır | G-KTIP-5 |
| Birleşik tip sözleşmesi | Her tip (primitive, kayıt, dizi, koleksiyon, sınıf, kütüphane) tek bir `TypeDescriptor v2` + `StorageDescriptor`/`LayoutId` sözleşmesinden geçer; canonical MIR `typeId`, `layoutId` ve sahiplik üstverisi taşır; tipli `MemoryRef` ham `PTR`den ayrıdır; `TASK OF T`; sürüm/bağımlılık çözücüsü; altı motorda aynı çıktı ve tanı matrisi (`docs/tasarim/UXB_GENEL_VERI_TIPI_…_20261014_TR.md`) | Yok. Kütüphane manifesti, sağlayıcı kayıt defteri, işlem ve yaşam döngüsü kapıları vardır; birleşik tanımlayıcı ve MIR tip üstverisi yoktur. Belge de kendisini "uygulama iddiası değil" diye tanımlar | G-HEDEF-30, G-HEDEF-14 |
| Görev güvenliği | Tip tanımında `taskTransfer = FORBID \| COPY \| MOVE \| RETAIN \| SHARE`, `threadSafety = NONE \| IMMUTABLE \| INTERNAL \| EXTERNAL_LOCK \| THREAD_AFFINE`, `sharedPolicy`. `RATIONAL` (değer tipi): `COPY` + `IMMUTABLE`; GPU bağlamı: `FORBID` + `THREAD_AFFINE`; değişebilir veri çerçevesi: `SHARE` + `EXTERNAL_LOCK` | Alanlar manifestte yoktur; kütüphane tipi görev sınırından geçemez | G-GOREV-12, G-HEDEF-9 |

## 19.7 Bilinen sınırlar

{{SINIRLAR:KTIP}}

## 19.8 Kütüphane tipleriyle ilgili programlama kararları

* Kesin kesir gerekiyorsa `RATIONAL` kullanın ve programı **MIR yorumlayıcısıyla** çalıştırın; öteki beş yol programı derlemede `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile reddeder (eski ikililerde AST ondalık hesaplardı, bu artık yoktur).
* Kesri iki `RATIONAL` değişkeni bölerek kurun; `1 / 3` yazmayın.
* Üretim programında (x64/JS) `RATIONAL` yerine sınıf + `MAGIC` ile yazılmış kendi tipinizi kullanın.
* Kendi tipinizin alanlarını tamsayı tutun; sonucu hemen kullanın, işleç sonuçlarını zincirlemeyin.
* Yeni bir kütüphane tipi tanımlıyorsanız önce sözleşmeyi (yerleşim, işleçler, sahiplik) yazın; sahiplik alanlarının tutarlılık kurallarını denetleyen hata iletilerini okuyun.
* Hedef sağlayıcısı olmayan bir tipin başka bir hedefte "çalışıyormuş gibi" davranmasını beklemeyin; derleyici bunu bilerek reddeder. Reddi ileti metninden değil **tanı kodundan** okuyun (`UXB_LIBTYPE_PROVIDER_*` ailesi dört koddur, Ek F; ileti metni hedef adını üç gruba indirger ve metin satırı ile JSON iletisi aynı cümle değildir, G-HATA-13).
