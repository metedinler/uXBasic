# uXBasic Kod-Tasarım Uzlaştırma Denetimi

Tarih: 2026-09-24  
Kapsam: canlı `uxb` kaynak ağacı, `docs/tasarim`, `ai_koordinasyon` ve ortak
test/koordinasyon kayıtları.

Bu belge, tasarımda “yapılacak” yazan bir işin kodda gerçekten bulunup
bulunmadığını ayırır. Bir kaydın yalnız lexer anahtar sözcüğü, manifest alanı,
emit başarısı veya eski günlükteki iddiası bulunması tamamlanma kanıtı sayılmaz.

## Kanıt Ölçeği

| Etiket | Anlam |
|---|---|
| KOD | Kaynakta davranış yolu bulundu ve ilgili dosya/satır görüldü. |
| TEST | Gerçek derleme, çalıştırma veya beklenen kontrollü hata ile ölçüldü. |
| KAYIT | Koordinasyon defterinde başka bir ajanın uygulama kanıtı var; canlı kodla ayrıca karşılaştırılır. |
| KISMİ | Sözleşmenin yalnız bir bölümü uygulanmış; kalan hedef açıkça ayrıdır. |
| AÇIK | Tasarım veya kod yolu mevcut değil. |
| ÇELİŞKİ | İki güncel görünen belge farklı sözleşme söylüyor. |

## Yönetici Özeti

Birinci sınıf kütüphane tipi için çekirdek sözleşmenin önemli bir iskeleti
canlıdır: manifest kaydı, layout/operator/MAGIC/lifecycle/ABI/provider alanları,
erken `RATIONAL` görünürlüğü, RATIONAL'ın canonical-MIR yorumlayıcı sağlayıcısı
ve VALUE/BITCOPY/NONE yaşam profili vardır. Fakat bu henüz “RATIONAL bütün
hedeflerde çalışan birinci sınıf paket” değildir. JS, WASM ve native provider
alanları manifestte isim olarak bulunur; bunların her biri için gerçek runner
ve parity kanıtı yoktur. Genel CLONE/RETAIN/DROP lowering de tamamlanmamıştır.

İki yeni Claude bulgusu canlı kodla doğrulandı; S-148 bu turda düzeltildi ve
S-030 Faz 1B / S-149 canonical-MIR halkası aynı çalışma ağacında tamamlandı:

1. **S-148 gerçek bir hata olarak düzeltildi.** `DIM a AS T = ifade` MIR lowering yolu, normal
   atamanın `UXBStep3CheckAssignment` denetimini çağırmadan doğrudan
   `STORE_VAR` üretmektedir. Ortak `bin/uxb.exe` ile `I32` değişkene STRING,
   STRING değişkene I64 ilk değeri veren probe `sem` aşamasını hatasız geçti;
   MIR JSON'da iki uyumsuz STORE_VAR ve boş diagnostics görüldü.
2. **S-149 ve canonical-MIR ilk halkası doğrulanmıştır.** Claude'un canlı değişiklikleri
   `TASK OF T` parser/AST metadata, semantic kaynak-sonuç denetimi, `.RESULT`/
   `.JOIN()` tip çıkarımı ve AST/MIR yorumlayıcı dönüş yolunun ilk halkasını
   eklemiştir. Taze ikiliyle typed kabul, tipsiz kaynak reddi, yanlış tip reddi
   ve typed->tipsiz geriye dönük aktarım doğrulandı. Canonical MIR görev çağrı
   ailesi ve MIR yorumlayıcısı da uygulanmış, güncel `tests/task_model` koşusu
   108/108 geçmiştir. Native/legacy yolları K7 gereği açık red; gerçek native
   async, JS Worker ve WASM görev yürütmesi hâlâ ayrı açık hedeflerdir. Tipsiz
   `TASK` geriye dönük korunur; güvenli statik yol `TASK OF T`'dir.

## 1. Birinci Sınıf Kütüphane Tipi

### Tasarım hedefi

`UXB_BIRINCI_SINIF_KUTUPHANE_TIPI_TASARIM_PAKETI_20260920_TR.md` şu paketi
tanımlar: veri yerleşimi, operatorler, MAGIC davranışları, dönüşümler, yaşam
döngüsü, ABI, canonical MIR ve isteğe bağlı native hızlandırma. Amaç,
`RATIONAL`, `COMPLEX`, `MATRIX`, `TENSOR` gibi tipleri çekirdekte özel `IF`
bloklarıyla çoğaltmak değil, manifest/provider/MIR sözleşmesiyle doğal dil
tipi gibi davranır hale getirmektir.

### Kodda bulunanlar

| Alan | Canlı karşılık | Durum |
|---|---|---|
| Manifest sözleşmesi | `src/semantic/library_type_contract.fbs` layout, operator, MAGIC, conversion, lifecycle, ABI ve provider alanlarını taşır. | KOD/KISMİ |
| Registry | `UXBLibraryTypeRegistryInit/Find/Register` ve paket manifest okuma yolu vardır. | KOD |
| Erken tip görünürlüğü | `RATIONAL` için parser/type-binding kapısı ve `DIM AS RATIONAL` akışı vardır. Genel manifest adının parser'a erken ulaşması hâlâ bağımlılıktır. | KISMİ |
| Operator bağlama | RATIONAL işlemleri `RATIONAL.ADD/SUB/MUL/DIV/EQ/NE/LT/LE/GT/GE` sağlayıcı adına indirgenebilir. | KOD/TEST |
| Canonical MIR | MIR full JSON'da `CALL`, sonuç tipi `RATIONAL`, operand sağlayıcı adı görülebilir. | KOD/TEST |
| MIR yürütme | `mir_interp_library_type.fbs` içinde `RATIONAL_REFERENCE` somut yolu vardır. | KOD/TEST |
| Lifecycle metadata | `storage_model`, `copy_model`, `clone_model`, `drop_model`; RATIONAL VALUE/BITCOPY/NONE doğrulandı. | KOD/TEST |
| Genel sahiplik lowering | Dinamik provider profilleri metadata olarak okunur fakat program kapısında `library type lifecycle lowering unavailable` ile durur. | AÇIK |
| JS provider | Manifestte `jsProvider` ve RATIONAL adı vardır; gerçek JS provider/runner parity kanıtı bu denetimde bulunmadı. | KISMİ/AÇIK |
| WASM provider | Manifestte `wasmProvider` ve linear-memory adı vardır; gerçek WAT/WASM değer aktarımı ve provider yürütmesi tamamlanmış değildir. | KISMİ/AÇIK |
| Native provider | Manifestte `nativeProvider` adı vardır; gerçek x64 C ABI sağlayıcısı ve aynı kabul vektörü yoktur. | KISMİ/AÇIK |
| Paket standardı | Paket/versiyon/provider alanları tasarımda ve manifestlerde vardır; genel registry raporu ve sürüm politikası kapanmamıştır. | KISMİ |
| COMPLEX/POLYNOMIAL/MATRIX | Tasarım adayıdır; canlı çekirdek sağlayıcısı olarak bulunmadı. | AÇIK |

Sonuç: S-112/S-134 “çerçeve ve metadata” işi yapılmış, “tüm hedeflerde
çalışan genişletilebilir kütüphane tipi sistemi” yapılmamıştır. Bu nedenle
belgelerdeki “RATIONAL manifesti var” cümlesi doğrudur; “RATIONAL bütün
hedeflerde hazır” şeklinde okunamaz.

### Lifecycle kabul sınırı

`UXB_S134_LIBRARY_TYPE_LIFECYCLE_20260923_TR.md` içindeki 14/14 paket ve
41 lifecycle kontrolüne ek olarak güncel `tests/library_type_contract`
koşusu 30/30 geçmiştir. Bu mevcut B2 kabul paketi, managed value-copy ve
clone-limit yolunu da kapsar. Yine de `REFERENCE/RETAIN/PROVIDER`, alan/BYREF/
escape ömrü, genel CLONE/RETAIN/DROP lowering'i, geçici değerler, fonksiyon
dönüşü ve gerçek JS/WASM/native provider parity'si genel S-134 kapanışı için
ayrı kanıt ister. Bu ayrım korunmalıdır.

## 2. S-148: DIM İlk Değer Denetimi

### Kod kanıtı

`src/semantic/mir_lower_stmt_core_split.fbs:317` civarında `DIM_STMT` lowering
başlar. `:441-446` civarında `INIT_EXPR` bulununca ifade indirilir ve hemen
şu davranış izlenir:

```text
MIRLowerExprNode(...)
MIRAppendInstruction(... MIR_OP_STORE_VAR, varName, ..., initValueName)
```

Bu yol, `src/type_binding/type_check_assign.fbs:5` içindeki
`UXBStep3CheckAssignment(targetType, valueType, ...)` yardımcısını çağırmaz.
Normal `a = b` yolu bu yardımcının dönüşüm kurallarını kullanırken `DIM` ilk
değeri ayrı bir kapıdan geçmektedir.

### Canlı probe

Denetim sırasında şu özel probe oluşturuldu:

`tests/coordination_20260924/s148_dim_initializer_type_probe.uxb`

```basic
DIM bad AS I32 = "text"
DIM ok AS STRING = 42
PRINT bad
PRINT ok
```

Ortak `bin/uxb.exe` ile `sem` çıkışı 0, diagnostics boş, yani iki uyumsuz
başlatma kabul edildi. MIR full JSON'da:

| Hedef | Kaynak değer | Üretilen STORE_VAR tipi |
|---|---|---|
| `bad AS I32` | STRING | I32 |
| `ok AS STRING` | I64 | STRING |

Bu, yalnız “test eksik” değil, tip güvenliği hatasıdır. Düzeltme yeri
`semantic_step3_gate.fbs` ile `mir_lower_stmt_core_split.fbs` arasındaki ortak
semantic/lowering sözleşmesidir. Codex'in LIBTYPE alanıyla kesiştiği için
Claude'un aktif claim dosyası değiştirilmeden dar kapsam koordinasyon gerekir.

**Son durum:** S-148 için yeni dil kararı gerekmez. Normal atamayla aynı implicit
assignment kontrolü `DIM INIT_EXPR` yoluna bağlanacak; geçerli library type
copy/lifecycle yolları yanlışlıkla atlanmayacak. Bu turdaki düzeltme sonrası
AST semantic kapısı,
canonical-MIR ve ilgili native/JS/WASM kapılarında hem kabul hem red vektörü
üzerinden semantic olarak doğrulandı; tam hedef koşusu sonraki regression
halkasına bağlandı.

## 3. S-149: TASK Sonucunun Statik Tipi

### Canlı type system

`src/type_binding/type_kinds.fbs:38-39` yalnız `TYPE_TASK` ve
`TYPE_TASKGROUP` tanımlar. `src/type_binding/type_rules.fbs:51-52,93` yalnız
`TASK` ve `TASKGROUP` kanonik türlerini tanır. `src/semantic/type_binding.fbs:205`
civarında da bunlar pointer-sized opaque handle olarak ele alınır.

`src/type_binding/type_infer_expr.fbs:718` civarındaki
`UXBStep3InferTaskAliasType` özelinde `TASK_RESULT`/`.RESULT` ancak özel PIPE
return metadata'sı varsa daha belirli tür taşır; normal TASK sonucunda
`TYPE_OBJECT` fallback'i vardır. Bu nedenle:

```basic
DIM n AS I32
n = t.JOIN()
```

tipsiz görev sonucunda explicit cast olmadan reddedilir. `TASK OF T` parser,
AST metadata, `SPAWN` sonucu bağlama, `.RESULT/.JOIN()` çıkarımı, canonical
MIR çağrı ailesi ve MIR yorumlayıcısı vardır. Güncel TASK paketi AST/MIR/native/
legacy için 108/108 geçmiştir; native/legacy sonuçları bilinçli temiz red,
gerçek async değildir. JS/WASM görev yürütmesi ayrı açık hedeftir.

### Yürürlükte tutulacak öneri

| Biçim | Anlam |
|---|---|
| `TASK` | Mevcut uyumluluk; sonuç statik olarak `OBJECT`, explicit cast veya OBJECT kullanımı gerekir. |
| `TASK OF T` | Sonucun statik türü `T`; `.RESULT/.JOIN()` güvenli atama ve dönüş bağlamında `T` üretir. |
| `TASK OF T` ile uyumsuz provider sonucu | Derleme veya açık provider hatası; sessiz OBJECT->T dönüşümü yok. |

Bu karar kaynak koduna uygulanmış ve canonical-MIR yorumlayıcı halkasıyla
doğrulanmıştır; S-149'ün gerçek async/JS/WASM parity kapsamı açık tutulur.

## 4. Diğer Tasarım Alanlarının Kod Karşılığı

### Raw PTR, typed pointer ve 6502

Raw `PTR` byte arithmetic, `VARPTR`, `PEEK/POKE` ve MemoryRef parçaları
canlıdır. `PTR + n` byte offset olarak kalmalıdır. 6502 adresleme modlarının
ayrı opcode veya özel sözdizimi olarak eklenmesi gerekmiyor; `PTR`, `PEEK/POKE`,
`PTR(PEEKQ(...))` ve offset zincirleriyle ifade edilebiliyor.

`PTR TO T` ise belgelerde ayrı bir gelecek yüzeyidir (S-113). Parser/type
binding/type kind içinde bu tip ailesinin canlı uygulaması yoktur. Dolayısıyla
“6502 adresleme var” denebilir; “typed pointer var” denemez.

### FOR EACH / DO EACH

`FOR EACH` için mevcut özel yollar ARRAY/STRING/WSTRING/LIST/DICT/SET ve
scalar değer listeleridir. S-107 ile STRING Unicode kod noktası ve
`FOR EACH x IN a, b` biçiminde iki iterable kaynağın doğrudan virgülle
birleştirilmemesi kararı uygulanmıştır. Bu nedenle eski `IN a,b` davranışının
kaldırılması bir gerileme değil, anlam belirsizliğini önleyen bilinçli karardır:

- `FOR EACH x IN 10, 20, 30` değer listesi olarak kalır.
- `FOR EACH x IN a, b` dizi/koleksiyon kaynakları için reddedilir.
- Çoklu kaynak ileride `CHAIN(a,b)` veya `ZIP(a,b)` gibi açık iterator
  kütüphane işlemleriyle ifade edilir.

S-135 hâlâ açıktır: ortak `ITER_CREATE/NEXT/CLOSE` MIR sözleşmesi, `MAGIC ITER`,
cleanup/erken çıkış, `CHAIN` ve `ZIP` canlı genel sistem olarak tamamlanmamıştır.

### OOP

Temel CLASS/NEW/null referans, field erişimi, sanal çağrı, upcast, SUPER,
erişim denetimi ve sınıf alanı bileşik atamalarında önemli kapanışlar vardır;
OOP parity kaydı 114/114'e ulaşmıştır. Bu, hedeflenen bütün OOP sistemi değildir.
Constructor/destructor zinciri, interface/virtual genişletmeleri, generics,
trait/mixin/decorator, transitif immutable, weak/cycle ve sürüm/migration
politikaları kısmi veya açıktır. Lexer'da anahtar sözcüğün bulunması bunların
uygulandığı anlamına gelmez.

### JS / WAT / WASM

WASM/WAT tarafında bazı dizi, bounds, SIZEOF, kullanıcı işlevi ve kontrollü
red yolları doğrulanmıştır; BYREF gerçek desteği, GOSUB/RETURN ve library
provider/worker/managed ABI açık kalır. JS tarafında bazı OOP/array/runtime
yolları vardır; TASK için sessiz `ux.callMethod(...)` üretimi ve `SLOT_DEF`
host binding açığı temiz fail-fast/gerçek worker kabulüne ulaşmamıştır.

S-153 yüzey matrisi şu anda testlerden türeyen bir ölçüm değildir: sabit liste
ve hardcoded PASS/owner değerleri vardır; eksik yüzeyleri otomatik bulamaz,
`--out-dir` de gerçek çıktı kapısı değildir. Bu nedenle yüzey matrisindeki PASS
tek başına parity kanıtı sayılamaz. Antigravity'nin alanı JS/WAT/WASM olarak
korunmalı; provider, fail-fast, SLOT_DEF ve gerçek runner ayrı kabul adımları
olmalıdır.

## 5. Ajan ve Belge Uzlaştırması

### Claude

Claude'un canlı kaydı S-030 Faz 1B canonical MIR ve S-149 ilk halkasını
uygulanmış gösteriyor; güncel `tests/task_model` 108/108 doğrulaması bunu
destekliyor. Native/legacy gerçek async değil, K7'nin bilinçli temiz red
yoludur. Claude'un aktif claim'i `TASK` dosyalarıdır;
Codex LIBTYPE dosyalarına ve Antigravity JS/WAT/WASM dosyalarına girilmemelidir.

Claude'un yeni S-148 kaydı canlı probe ile doğrulandı. S-149 kararı kabul
edilmiş, parser/semantic/AST-MIR ve canonical-MIR yorumlayıcı halkası taze
ikiliyle ölçülmüştür; gerçek async/JS/WASM hedef kabulü bundan ayrı tutulur.

### Antigravity

Antigravity başlangıç notu JS/WAT/WASM, provider parity, gerçek runner ve
fail-fast alanını verir. Canlı koordinasyonda bu alan için tamamlanmış bir
RATIONAL provider veya TASK Worker/WASM kabul vektörü bulunmadı. S-153'ün
hardcoded matrix olması, “yüzey tamam” iddialarının ölçüm kabul edilmemesini
gerektirir.

### Gemini

Güncel aktif claim veya 24.09 kabul kaydı bulunmadı. Gemini adı yalnız tarihsel
2026-09-16 çalışmasında recursive DIM duplicate düzeltmesi, JS collections
ve AST-x64 collection eksikleri bağlamında geçiyor. Bu işlerin bir bölümü
sonraki test kayıtlarıyla kapanmış olsa da Gemini'nin bugün devam eden işi veya
tamamladığı güncel S-112/S-134/S-149 halkası şeklinde varsayım yapılamaz.

## 6. Tasarım Çelişkileri

1. **TASK yüzeyi:** Eski uzun 24.09 metinlerinde `WAIT t`, `TASKOUT(t)` ve
   “RESULT eklemeyelim” önerisi bulunuyor. Yürürlükteki K1–K8 ve kullanıcı
   kılavuzu ise `.WAIT()`, `.JOIN()`, `.RESULT`, `.ERRORTEXT` üyelerini ve
   `TASKGROUP` adını kullanıyor. K1–K8 sonraki ve bağlayıcı karar kabul edilmeli;
   eski metin tarihçe/alternatif olarak işaretlenmeli.
2. **`TASKGROUP` / `TASK_GROUP`:** Kullanıcı yüzeyinde `TASKGROUP`, alt çizgisiz
   tek ad; `TASK_GROUP` yalnız iç MIR adlarında kullanılabilir veya sıradan
   değişken olarak kalabilir. Eski metinlerdeki karışık kullanım düzeltilmeli.
3. **S-030 kapanışı:** “Faz 1B tamamlandı” ifadesi canonical-MIR senkron
   referans yolu için doğrudur; native/legacy temiz red ve gerçek async JS/WASM
   hedefleri genel görev kapanışı değildir.
4. **Library provider:** Manifestte JS/WASM/native provider adı bulunması,
   provider gövdesi ve runner parity'si bulunması değildir. S-134 belgesi bu
   ayrımı doğru yapıyor; üst hedef kılavuzu bunu “hedef hazır” diye okumamalı.
5. **Typed pointer:** Raw PTR/6502 adresleme örnekleri uygulanmıştır; `PTR TO T`
   hâlâ S-113'tür. Bu iki ifade tek “pointer tamamlandı” maddesinde birleşmemeli.
6. **FOR EACH:** Değer listesi ve iterable kaynak listesi aynı virgül söz dizimi
   değildir. `IN a,b` kaldırma kararı ile `CHAIN/ZIP` genel iterator hedefi
   birlikte yazılmalı; aksi halde belgede “çoklu sistem kaldırıldı” gibi yanlış
   bir anlam oluşur.
7. **Yüzey matrisi:** S-153'ün hardcoded PASS değerleri, dört motor/runner
   kabul ölçütüyle çelişmektedir.
8. **S-148/S-149:** S-148 hata düzeltmesi için yeni tasarım oylaması gerekmez.
   S-149 için `TASK OF T` kararı kabul edilmiştir; fakat ilk parser/semantic/
   AST-MIR uygulaması canonical MIR ve hedef yürütmesiyle aynı “TASK işi
   tamamlandı” satırında birleştirilmemelidir.

## 7. Uygulama Sırası

1. S-149 ve S-030 Faz 1B canonical-MIR senkron halkası uygulandı ve
   `tests/task_model` ile 108/108 doğrulandı. Tipsiz `TASK` için OBJECT ve
   explicit cast davranışı korunur. Kalan kabul gerçek native async, JS/WASM
   görev yürütmesi, shutdown/cancel/stres ve parity'dir.
2. S-134 kalan kapsamı: genel CLONE/RETAIN/DROP, field/BYREF/escape ömrü,
   temporary/return/error cleanup ve gerçek provider parity'si.
4. S-112/S-114: paket registry raporu ve RATIONAL provider'larını önce MIR,
   sonra JS/WASM/native için aynı değer aktarımı vektörleriyle tamamla.
5. S-153: sabit matrix yerine gerçek test/runner kanıtı üreten yüzey ölçümü.
6. Sonra S-113 typed pointer, S-135 genel iterator, ileri OOP ve yeni
   COMPLEX/POLYNOMIAL/MATRIX paketleri.

Bu sıra, kütüphane tiplerini çekirdeğe tek tek gömmek yerine genel yeteneği
tamamlama ilkesini korur.
