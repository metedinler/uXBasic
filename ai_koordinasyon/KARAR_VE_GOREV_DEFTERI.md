# Ortak Karar ve Görev Defteri

Bu dosya, Claude ve Codex'in ayrı oturum hafızalarının yerine geçen tek
paylaşılan teknik kaynak defteridir. Her yeni çalışma başlamadan önce bu dosya,
`DURUM.md` ve `SORULAR_CEVAPLAR.md` okunur. Bir karar değişirse eski madde
silinmez; tarihli yeni madde eklenir.

## 2026-09-11 — yürürlükteki mimari kararlar

1. **Dört motor aynı dil semantiğini taşır.** AST yorumlayıcı, canonical-MIR
   yorumlayıcı, MIR-native x64 ve AST-direct x64 uyumluluk emitter'ı için
   gözlemlenebilir sonuç ayrışması kabul edilmez. Yeni davranış önce canonical
   MIR'de tanımlanır; sonra diğer üç motora regresyon testiyle taşınır.
2. **Tip daraltma sözleşmesi tektir, uygulaması katmanlıdır.** Çalışma zamanı
   yorumlayıcıları ve assembly emitter'ı aynı kodu paylaşamaz; fakat aynı
   imzalı test vektörleri ve aynı kanonik tür/bit-genişliği tablosu kullanır.
   Geniş refactor öncesinde bu vektörler zorunlu kapıdır.
3. **Yerleşik tamsayı ölçüleri:** `BYTE=I8`, `SHORT=I16`, `INTEGER=I32`,
   `LONG=I32`, `LONGINT=I64`; unsigned karşılıkları aynı genişliktedir.
   `MIRCanonicalTypeName2` içindeki `LONG -> I64` eşlemesi hatadır.
4. **Tarihsel, yürürlükten kalkmış karar:** Event örtük ilk girdisi için
   `INPUTS` önerilmişti. Bu karar aşağıdaki daha yeni Mete yönlendirmesiyle
   yürürlükten kalkmıştır; güncel kanonik adlar `TASKIN` ve `TASKOUT`tur.
   `INPUT` klavye komutu olarak kalır ve görev bağlamı aliası değildir.
5. **MIR evaluator ve AST dosyaları topluca ölü kabul edilmez.**
   `mir_evaluator*.fbs` içinde canlı yardımcılar vardır; `src/interpreter/ast`
   AST referans motorudur. Taşıma/silme yok. Giriş noktası ve yardımcı sembol
   bazında yaşam haritası çıkarılmadan "legacy" başlığı eklenmez.

## 2026-09-20 — birinci sınıf kütüphane tipi ilkesi

Bu bölüm Mete'nin 2026-09-20 yönlendirmesiyle yürürlüğe girdi. Ayrıntılı
tasarım paketi: `docs/tasarim/UXB_BIRINCI_SINIF_KUTUPHANE_TIPI_TASARIM_PAKETI_20260920_TR.md`.

1. **Yeni veri tipi için varsayılan soru değişti.** İlk soru "bunu çekirdeğe
   nasıl ekleriz?" değildir. İlk soru "birinci sınıf kütüphane tipi sistemi
   bunu çekirdeği değiştirmeden ifade edebiliyor mu?" olacaktır.
2. **Cevap evetse tip kütüphaneye gider.** `RATIONAL`, `COMPLEX`,
   `POLYNOMIAL`, `MATRIX`, `TENSOR`, `DATAFRAME` gibi tipler varsayılan olarak
   çekirdeğe özel `IF type = ...` yığını ekletmez.
3. **Cevap hayırsa özel tip gömülmez; eksik genel yetenek bulunur.** Örneğin
   `POLYNOMIAL` yazılamıyorsa "POLYNOMIAL çekirdek tipi" değil, kullanıcı
   tanımlı tiplerin hangi genel operatör/yaşam döngüsü/ABI/MIR yeteneği eksik
   sorusu açılır.
4. **Birinci sınıf kütüphane tipi sıradan `TYPE` değildir.** Veri yerleşimi,
   operatörler, MAGIC, dönüşümler, yaşam döngüsü, ABI, MIR davranışı ve
   opsiyonel native/JS/WASM hızlandırma sözleşmesini birlikte taşır.
5. **Tip hedef işlemciye değil canonical MIR sözleşmesine bağlanır.** `a + b`
   kaynağı tip bağlama katmanında `TYPE_OP ADD` veya `CALL RATIONAL.ADD`
   biçimine indirilebilir; x64, JS ve WAT/WASM bu ortak sözleşmeden yürür.
6. **Raw `PTR` ve typed pointer ayrı kavramlardır.** Mevcut `PTR` byte
   tabanlı aritmetiğini korur. Gelecekteki `PTR TO T` eleman-stride semantiği
   taşıyabilir; bu, raw `PTR + n` davranışını değiştirmez.
7. **JS/WASM yan hedef değildir.** Bir kütüphane tipi yalnız Windows DLL'e
   bağlıysa dilin doğal parçası sayılmaz. Pure MIR, JS provider, WASM
   handle/linear-memory ve native hızlandırma politikası açık yazılmalıdır.

İzleme dosyası: `ai_koordinasyon/BIRINCI_SINIF_KUTUPHANE_TIPI_TAKIP_20260920.md`.
Sorun maddeleri: S-112, S-113, S-114, S-115.

## 2026-09-23 — 23.09 sistem tasarım sentezi ve yürürlükteki ek kararlar

Ana belge: `docs/tasarim/UXB_20260923_SISTEM_TASARIM_KARARLARI_MEVCUT_DURUM_VE_IS_PLANI_TR.md`.

1. **Birinci sınıf kütüphane tipi halkasında sıradaki eksik genel yetenek
   lifecycle/ownership sözleşmesidir.** `VALUE/HANDLE/REFERENCE`,
   `BITCOPY/CLONE/MOVE_ONLY/REFCOUNT/COW`, `DROP` ve `CLONE` davranışları
   manifestte açıklaşmadan `POLYNOMIAL`, `MATRIX`, `TENSOR` gibi dinamik
   payload taşıyan tipler güvenle eklenmez.
2. **`RATIONAL` için ilk güvenli constructor yolu açık olmalıdır.**
   `r = 1 / 3` ifadesi bugünkü sayısal kurallarla bilgi kaybettirebilir;
   ilk gerçek paket `RATIONAL(1,3)` veya `Rational.Create(1,3)` gibi açık
   oluşturma yolunu taşımalıdır. Hedef tipe duyarlı `1/3` çözümü ileri halka
   olarak kalır.
3. **`FOR EACH` değer listesi kaldırılmadı.** `FOR EACH x IN 10,20,30`
   skaler değer listesi olarak kalır. Yasaklanan davranış, `FOR EACH x IN a,b`
   biçiminde `a`/`b` dizi veya koleksiyon gibi iterable kaynak adları olduğunda
   belirsiz çok-kaynak dolaşımıdır.
4. **Çok kaynaklı iterator açık kütüphane yüzeyiyle geri gelir.**
   `CHAIN(a,b,c)` ve `ZIP(a,b)` gibi ifadeler gelecekte `MAGIC ITER` ve ortak
   `ITER_CREATE/NEXT/CLOSE` MIR sözleşmesine bağlanmalıdır.
5. **Meta/generator sistemi normal kaynak üretmelidir.** `%%DERIVE`,
   `%%GEN_BLOCK`, REST/host wrapper/test skeleton gibi üreticiler özel meta
   runtime yaratmaz; normal uXBasic kaynak, manifest ve ek artifact üretip
   standart lexer/parser/semantic/MIR kapılarından geçer.

## 2026-09-11 — sahiplik ve kabul ölçütleri

| Sahip | Alan | Kabul ölçütü |
|---|---|---|
| Claude | AST-direct x64 parametre daraltma; `INPUTS` geçişi; kaynak/cast alias yüzeyi | Dört motor aynı sonuç; `INPUTS` bütün producer/consumer noktalarında; `SHORT(x)` ve `AS SHORT`, ayrıca `LONG` ve diğer tüm aliaslar aynı canonical türe iner. |
| Codex | `LONG` canonical-layout çelişkisi; normal `FUNCTION` içindeki `PRINT param`; `CLNG`/`FIX` parity | Her düzeltme için AST, canonical-MIR, MIR-x64 ve AST-x64 çıktısı; `CLNG(2.9)=3`, `FIX(5.9)=5`. `AS LONG` kaynak kabulü Claude'un alias işi tamamlanana kadar bekler. |
| Ortak | Tip dönüşüm vektörleri ve execution-path haritası | Alias, signedness, genişlik, float-to-int, string-to-number ve hata vektörleri tek beklenen çıktı dosyasına bağlanır. |

## Paylaşılacak defterler

- Genel sahiplik: `ai_koordinasyon/DURUM.md`
- Soru/yanıt ve teknik kanıt: `ai_koordinasyon/SORULAR_CEVAPLAR.md`
- Kalıcı kararlar ve görevler: bu dosya
- Codex geçmişi/kod inceleme kanıtı: bu üç dosyaya özetlenir; yalnız sohbet
  hafızasında bırakılmaz.
- Claude özel karar notları: aktif iş başlamadan önce buraya özetlenir;
  yalnız özel çalışma alanında bırakılmaz.

## 2026-09-11 — Mete'nin yönlendirmesiyle düzeltme ve mimari tartışma usulü

Bu bölüm, yukarıdaki tarihli maddelerdeki çelişen ifade varsa daha yenidir;
eski kayıtlar tarihsel kanıt olarak korunur.

1. **Görev bağlamı adları `TASKIN` ve `TASKOUT`tur.** Önceki `INPUTS`
   önerisi yürürlükten kalktı. `INPUT`/`OUTPUT` komut ve bağlam adı çakışması
   giderilirken üretici, tüketici, x64 shell, test ve belge envanteri çıkarılır.
   Eski adların kaynak düzeyinde geçici kabulü, sessiz anlam değişikliği
   yaratmayacak açık bir geçiş kuralı olmadan eklenmez.
2. **Parantezli kısa tür adları dönüşümdür.** `I8(x)`, `I16(x)`, `I32(x)`,
   `I64(x)` gibi kısa adlar yalnız parantezli ifade konumunda cast işlevi görür.
   `SHORT`, `LONG` gibi uzun bildirim adlarının parantezli çağrı olmaması
   kasıtlı tasarımdır; S-008 bu nedenle sorun değildir. Bildirim konumunda
   kabul edilen uzun adların kapsamı ayrıca tür-sözdizimi testleriyle korunur.
3. **Hiçbir motor veya tarihsel küme bu tartışma sırasında silinmez,
   taşınmaz ya da "ölü" diye etiketlenmez.** Kullanıcıya açık CLI yolu,
   test/araç API yolu, derleyiciye dahil edilen yardımcılar ve hedef
   platformlar ayrı ayrı haritalanmadan erişilemezlik sonucu çıkarılmaz.
4. **Karar kaydı iki sahiplik taşır:** ürün/dil kararını Mete verir; Codex
   geçmiş kararlar ve kaynak kanıtıyla teknik öneriyi hazırlar; Claude
   bağımsız teknik kanıt ve uygulama planını verir. Uygulama sahibi her satırda
   ayrıca yazılır. Mete'nin uyurken verdiği yetkiyle Codex, belirsiz teknik
   sorulara bu kayıtlara ve kaynak kanıtına dayanarak ilk yanıtı verir;
   Claude'un alanını devralmaz.
5. **Her bulgu izlenir.** Yeni sorun `SORUN_TAKIP.md`ye durum, karar sahibi,
   uygulama sahibi ve doğrulama kanıtıyla girilir. "Yapıldı" ancak çalıştırılmış
   kabul testi kaydedilince `YAPILDI-DOGRULANDI` olur.

## 2026-09-11 — güncel sahiplik düzeltmesi

| Sahip | Alan | Kabul ölçütü |
|---|---|---|
| Claude | AST-direct x64 parametre daraltma; `TASKIN`/`TASKOUT` geçişinin producer/consumer envanteri ve uygulaması; UXCollections CLAIM alanı | Dört çalıştırılan ana motor aynı sonuç; `TASKIN`/`TASKOUT` tüm yürütme yollarında aynı bağlamı taşır; eski adlar için açık geçiş kararı ve regresyon kanıtı bulunur. |
| Codex | `LONG` canonical-layout çelişkisi; normal `FUNCTION` içindeki `PRINT param`; `CLNG`/`FIX` parity; motor mimarisi kanıt haritası | `LONG=I32` dört-motor vektörle doğrulanır; `CLNG(2.9)=3`, `FIX(5.9)=5`; mimari tartışma erişim/amaç/kanıt ayrımıyla sunulur. |
| Ortak | Tür dönüşüm vektörleri ve yürütme-yolu haritası | Kısa-cast, uzun-bildirim, signedness, genişlik, float-to-int, string-to-number ve hata vektörleri tek beklenen çıktı sözleşmesine bağlanır. |

## 2026-09-11 — Codex parity turu sonrası görev güncellemesi

| Sahip | Açık iş | Kabul ölçütü | Çakışma sınırı |
|---|---|---|---|
| Codex | S-011 AST `I32()`/daraltma parity'si | `I32(5000000000)` AST, canonical-MIR, MIR-x64 ve AST-x64'ta `705032704` üretir; imzalı/unsigned sınır vektörleri de aynı sözleşmeye bağlanır. | `src/runtime/exec/exec_state_value_utils.fbs` ve buna doğrudan bağlı Codex testleri; Claude önce ortak günlükten sorar. |
| Claude | S-003 `TASKIN`/`TASKOUT` bütüncül geçişi; S-010 uzun bildirim aliasları | Her producer/consumer/x64 shell noktası envanterlenir ve dört yol test edilir. `AS SHORT`/`AS LONG` kabul edilir; `SHORT(x)`/`LONG(x)` çağrı-cast olarak kabul edilmez. | Codex'in S-011 ve kapatılmış S-013 dosyalarına dokunulmaz; yalnız zorunlu kesişimde günlük üzerinden tasarım notu bırakılır. |
| Ortak | S-004 mimari karar dosyası | CLI, test/API, include-bağımlılığı ve kullanıcı sözleşmesi ayrı kanıtlanmadan hiçbir motor/küme taşınmaz, silinmez veya etiketi değiştirilmez. | `MOTOR_MIMARISI_TARTISMA_NOTU.md` karar öncesi tek kanıt kaynağıdır. |

**Kapanan Codex işleri (2026-09-11):** S-006 ve S-007 dört ana yolda gerçek
çıktı karşılaştırmasıyla kapandı. S-012 yalnız eksik ortak-header derleme
kapısı bakımından kapandı; bu S-003'ün tamamlandığı anlamına gelmez. S-013,
AST `PRINT`in kullanıcı FUNCTION'ını iki kez çağırması, dört-yol regression
testiyle kapandı.

## 2026-09-11 — Mete'nin yeni dil ve koleksiyon kararları

1. **`SBYTE` resmi tür aliasıdır: `SBYTE=I8`.** Parser, type binding,
   semantic doğrulama, dört yürütme yolu ve belgeler aynı eşlemeyi taşımalıdır.
   Bu, önceki kısa-cast kararını değiştirmez: parantezli cast yalnız kanonik
   kısa adlarla (`I8(x)` vb.) yazılır; `SBYTE(x)` yeni bir cast sözdizimi
   değildir. Kabul: `AS SBYTE` ve aliasın tüm bildirim/parametre/yerleşim
   noktaları `I8` ile aynı davranır; imzalı sınır vektörleri AST, canonical
   MIR, MIR-x64 ve AST-direct x64'te aynıdır.
2. **Yerleşik `LIST`/`DICT`/`SET` komutları dilin desteklenen yüzeyidir.**
   Native x64 desteği, `uxcollections`ın yerine geçmez; kullanıcı hem yerleşik
   komutları hem de açık UXCollections kütüphanesini seçebilir. Desteklenmeyen
   backend sessiz yanlış sonuç üretemez: geçici olarak açık tanı vermeli,
   tamamlandığında aynı sözleşmeyi yürütmelidir.
3. **Native uygulama sınırı:** Yerleşik native x64 koleksiyon yolu
   `native/uxb_runtime` içindeki dar, belgeli C ABI üzerinden çalışabilir.
   ABI dışına yalnız opaque handle ve değer geçer; STL nesnesi, ham sahiplik
   veya UXCollections'a gizli FFI bağlama geçmez. Dolaşım sırası, handle ömrü,
   hata durumları ve iterasyon sırasında mutasyon canonical MIR heap
   sözleşmesiyle uyumlu ve ortak test vektörleriyle kanıtlı olmalıdır.

## 2026-09-13 08:59:40 +03:00 — Denetim teslimi ve görev ayrımı

Mete'nin iş paylaşımı talimatıyla CLAUDE_DEVIR_20260913_TR.md güncel teknik devir kaydıdır. S-019 incelemesi yanıtlandı; uygulama sahibi Claude. Codex bu tur yalnız native build dizin/import-lib alt düzeltmesini üstlendi. Kullanıcı dil kararları değişmedi; gelecekte önerilen işler aktif CLAIM değildir.


## 2026-09-20 22:00 +03:00 — `build\` klasörü ve eski rapor dosyaları için silme yetkisi (Mete'nin açık talimatı)

Mete (2026-09-20) yazdı: "build klasörünü gerektiğinde çalışılan gün harici silebilirsin. Karar defterlerine bu bilgiyi yaz. Eski build bilgileri, eski rapor dosyaları gereksiz ise silinebilir. Bana sor, silmeden önce."

Yürürlükteki kural (Claude 1 bu şekilde uygular; Codex, Claude 2 ve Antigravity da uyar):
1. **`build\<AA_GG_YYYY_SS_DD_SN>` ÇALIŞTIRMA klasörleri** (her `uxb` çağrısının oluşturduğu, adı tarih-saat olan klasörler): disk gerektiğinde **içinde bulunulan günün klasörleri hariç**, önceki günlerin klasörleri SİLİNEBİLİR; ayrıca sormaya gerek yok. Sildikten sonra ne kadar/ne silindiği defterlere yazılır.
2. **Aynı `build\` içindeki diğer her şey KORUNUR** (çalışma klasörü değildir): `build\manual\config\ffi_allowlist.txt` (FFI ilkesi buradan okunuyor), `build\compiler`, `build\deps`, `build\libraries`, `patch_backup_*`, `recovery_backup_*`, `quarantine_*`, `release_stage`, `source_release_stage`, `pdsx_*`, `uxclazz`, `abi_audit` … ve `build\` kökündeki tek tek dosyalar (`libgsl-28.dll`, `uxgsl.dll`, `manual_uxsqlite.dll` vb.). Bunlar yedek/yapılandırma/bağımlılık içerir; silinmeleri için Mete'ye SORULUR.
3. **Eski rapor dosyaları / eski build bilgileri** (`reports\`, `test_results\`, `build\` altındaki eski rapor JSON'ları, eski `.bak` dosyaları vb.): gereksizse silinebilir, ANCAK **silmeden önce Mete'ye sorulur** (ne olduğu, ne kadar yer tuttuğu, neden gereksiz olduğu listelenerek).
4. **Test koşucuları** artık çağrıların çıktı klasörünü `--out-root <geçici>` ile yönlendirip koşu bitince siliyor (`tests\run_all_model_tests.ps1`; `-KeepBuildFolders` ile kapatılır). Toplu deneylerde aynı yol izlenmeli. Ayrıntı: SORUN_TAKIP.md S-117.
## 2026-09-20 22:20 +03:00 — Mete'nin dokuz KARAR maddesine verdiği kararlar (S-101, S-104, S-105, S-107, S-108, S-088, S-110, S-029, S-030)

Kaynak: Mete, çapraz inceleme metnini (uxb(20.09).zip kaynak + uxb(dokuman).zip belge/koordinasyon kayıtları) sohbete aktardı ve "Claude'a aktarılacak kısa karar metni" olarak bildirdi. Aşağıdakiler yürürlüktedir; eski KARAR-BEKLIYOR kayıtları SORUN_TAKIP.md'de "KARAR VERİLDİ" olarak işaretlenir, silinmez.

1. **S-101 `LBOUND/UBOUND` EKLENECEK.** `LBOUND(a)`, `UBOUND(a)`, `LBOUND(a, boyut)`, `UBOUND(a, boyut)`; boyut varsayılanı 1; çok boyutlu dizide boyut başına. Henüz ayrılmamış dinamik dizi: `LBOUND = 0`, `UBOUND = -1` (eleman sayısı `UBOUND-LBOUND+1 = 0`). MIR'e `ARRAY_LBOUND` / `ARRAY_UBOUND` işlemleri eklenir (x64, JS, WASM aynı tanımlayıcıyı kullanır).
2. **S-104 açık `MAIN ... END MAIN` varsa** MAIN dışında ÇALIŞTIRILABİLİR üst düzey deyim DERLEME HATASI. MAIN dışında serbest olanlar: `TYPE`, `CLASS`, `INTERFACE`, `SUB`, `FUNCTION`, `DECLARE`, `MODULE/NAMESPACE`, `CONST` ve gerekli global bildirimler. `MAIN` hiç yoksa mevcut örtük üst düzey program modeli sürer. İki temiz model: (A) MAIN yok → üst düzey deyimler program gövdesi; (B) MAIN var → MAIN tek program gövdesi. Hata metni örneği: `MAIN: executable top-level statement outside explicit MAIN block`.
3. **S-105 sınıf üyesi varsayılan erişimi PUBLIC**; açık `PRIVATE/PROTECTED/RESTRICTED` değişmez; `INTERFACE` üyeleri her zaman PUBLIC.
4. **S-107 `STRING`/`WSTRING` üzerinde `FOR EACH` DESTEKLENECEK**; birim = **Unicode kod noktası** (byte veya UTF-16 birimi DEĞİL; JS/WASM ile aynı olmalı); `FOR EACH c, i IN s` → `i` 0 tabanlı KARAKTER sırası. `FOR EACH x IN 10, 20, 30` (değer listesi) kalır; `FOR EACH x IN a, b` (a/b dizi/koleksiyon) DERLEME HATASI (ileride `CHAIN(a,b)` / `ZIP(a,b)` kütüphane iteratörleri). Genel iteratör sırası: ARRAY, STRING/WSTRING, LIST, DICT, SET, kütüphane tipi `MAGIC ITER`, CLASS/OBJECT; hepsi ortak `ITER_CREATE / ITER_NEXT / ITER_CLOSE` MIR sözleşmesine iner.
5. **S-108 `DIM a AS Animal` (CLASS) NULL referans** oluşturur; nesne yalnız `NEW` ile doğar; `a.Speak()` null iken `method call on null object reference` hatası. `TYPE/STRUCT` değer tipi kalır (DIM gerçek depolama açar). AST ve legacy'deki "DIM class default allocation" kaldırılacak.
6. **S-088 `U32 op U32 → U32`, her işlem sonucu modulo 2^32** (yalnız atamada değil), karşılaştırma işaretsiz. `U8 op U8`/`U16 op U16` → `I32` (C terfisi), `U64 op U64` → `U64`. JS/WASM/x64/AST/MIR aynı sonucu verir (`1-2` U32'de `4294967295`).
7. **S-110 normal çalışmada adım sınırı YOK** (`stepLimit = 0` = sınırsız); isteğe bağlı `--max-steps N` (test/güvenilmeyen program bütçesi, dil semantiği değil). `pc takıldı` (aynı komutta 10 000 tekrar) gibi sonsuz-döngü korumaları da yalnız bu denetim modunda etkin olur.
8. **S-029 `uxb_parallel_run` C ABI sembolü KALIR**; yüzey doğrulayıcısı `PARALEL → UXB_RT_SYMBOL_PARALLEL_RUN → uxb_parallel_run` eşlemesini manifestten görür, sembol adını dil anahtar sözcüğüyle aynı olmaya zorlamaz.
9. **S-030 `THREAD` ve `PARALEL` GERÇEK eşzamanlı/asenkron olacak** (EVENT ve PIPE senkron/deterministik kalır). Asenkron sonuç global `TASKOUT` ile DEĞİL, birinci sınıf `TASK` tutamacıyla (id, durum, sonuç, hata, iptal, sağlayıcı tutamağı) taşınır; `WAIT/JOIN/CANCEL/STATUS/RESULT` anlamı şimdiden kilitli (yazım parser tasarımında seçilir). `PARALEL` sonuçları BAŞLATMA sırasına göre döner (tamamlanma sırasına değil). Yakalanmamış asenkron hata görev nesnesinde tutulur, `WAIT/JOIN/RESULT`'ta çağırana aktarılır. Her tek `PRINT` çağrısı ATOMİK; görevler arası satır sırası garantisiz. Asenkron görev parametrelerinde `BYREF` sahiplik/MemoryRef modeli tamamlanana kadar YASAK. Canonical MIR: `TASK_SPAWN/WAIT/JOIN/CANCEL/STATUS/RESULT`, `EVENT_EMIT`, `PIPE_CALL`, `TASK_GROUP_CREATE/JOIN`. Native ilk uygulama: uXBasic'in kendi çalışma zamanı iş parçacığı havuzu (oneTBB dil semantiğine gömülmez); JS: Worker / Worker havuzu; WASM: paylaşımlı bellek iş parçacıkları veya host worker sağlayıcı.

Uygulama sırası (Claude 1): S-110 → S-105 → S-104 → S-029 → S-088 → S-108 → S-101 → S-107 → S-030 (çok oturumluk: önce sözleşme/MIR, sonra sağlayıcılar). Her madde dört motorda test edilir, SORUN_TAKIP.md'de durumu yazılır.

**Durum (2026-09-22, Claude 1):** S-110/105/104/029/088/108/101/107 KAPANDI (kanıt SORUN_TAKIP.md'de ilgili S-numaralarında). Sırada tek kalan: **S-030** (çok oturumluk asenkron TASK tasarımı) — henüz başlanmadı. S-107 çalışması sırasında bağımsız, kritik bir bulgu (S-133: AST'de `IF dize = "metin" THEN` her zaman doğru sanılıyordu + `<`/`>`/`<=`/`>=` dize dalı hiçbir motorda yoktu) bulunup dört ayrı kök nedende kapatıldı; ayrıca S-119 (çıplak alan/metot adı) ve S-130/131/132 (sınıf alanı bileşik atama/genişlik/F32) da bu aralıkta kapandı. Tam regresyon (`run_all_model_tests.ps1`, tüm paketler) her değişiklik grubundan sonra ayrı ayrı koşuldu; sonuçlar DURUM.md'de.

**Durum (2026-09-23, Claude 1, güncelleme) — S-030 Faz 1 (AST motoru) TAMAMLANDI ve gerçek çalıştırmayla doğrulandı.** Tam kanıt SORUN_TAKIP.md'nin sonunda ("UYGULAMA SONUCU" bölümü). `SPAWN`, `TASK`, `TASKGROUP`, `.STATUS/.WAIT()/.RESULT/.JOIN()/.CANCEL()/.ERRORTEXT`, `TASKGROUP.ADD/.JOIN` (`.JOINALL` Faz 1'de bilinçli olarak reddediliyor) — hepsi `run` (AST) motorunda gerçekten çalışıyor: senkron başarı, senkron hata yakalama (THROW → `.ERRORTEXT`'te durur, `.RESULT`/`.JOIN()` okununca cağırana fırlar), `TRIGGER` geriye dönük tam uyumlu (dokunulmadı). Canonical-MIR/native x64/legacy x64 üçü de TEMİZ reddediyor (placeholder yok, kod eklenmedi). JS kod üretimi hatasız ama üretilen kod `node` ile çalıştırılınca her zaman başarısız oluyor — tek sebep S-030 değil: çıplak bir `THREAD...END THREAD` bildirimi bile (hiç SPAWN/TRIGGER olmadan) zaten önceden var olan "SLOT_DEF host binding missing" boşluğuna çarpıyor (bu satırın hemen üstündeki eski S-030 kaydı bunu zaten belgeliyordu). Faz 2 (native gerçek iş parçacığı), Faz 3 (JS Worker), Faz 4 (WASM) — üçü de ayrı, dedike oturumlar; bu oturumda başlanmadı.

**Durum (2026-09-23, Claude 1) — S-030 sözleşme/MIR tasarımı tamamlandı, Faz 1 uygulamaya başlanıyor.** Tam tasarım metni SORUN_TAKIP.md'nin sonunda ("## S-030" başlığı). Özet: Mete'nin kararı "WAIT/JOIN/CANCEL/STATUS/RESULT anlamı yazım tasarımında seçilir" dediği için somut yüzey burada kilitlendi — yeni tip `TASK` (opak tutamaç, CLASS referansı gibi NULL doğar), yeni anahtar sözcük `SPAWN` (ifade konumu, `DIM t AS TASK = SPAWN Worker(x)`), TASK üyeleri `.STATUS/.WAIT()/.RESULT/.JOIN()/.CANCEL()/.ERRORTEXT`, `TASK_GROUP` (`.ADD/.JOIN/.JOINALL`, sonuçlar EKLENME sırasına göre). Mevcut `TRIGGER Worker(...)` (THREAD/PARALEL hedefi) davranışı DEĞİŞMİYOR — `SPAWN`+`.JOIN()`'in eşdeğeri olarak tanımlandı, geriye dönük uyumlu. Canonical MIR: Mete'nin verdiği `TASK_SPAWN/WAIT/JOIN/CANCEL/STATUS/RESULT`, `EVENT_EMIT`, `PIPE_CALL`, `TASK_GROUP_CREATE/JOIN` + şeffaf eklenen zorunlu yardımcı `TASK_GROUP_ADD`. Uygulama fazlara bölündü: **Faz 1** (bu oturum) — dil yüzeyi + MIR + dört motorda SENKRON referans uygulama (bugünkü TRIGGER'ın yaptığı gibi görev anında/aynı çağrı yığınında biter; `.STATUS` hiç PENDING/RUNNING görmez — bu sınır açıkça belgelendi, placeholder değil, uçtan uca gerçekten çalışır/test edilir). **Faz 2/3/4** (ayrı, dedike oturumlar): native gerçek iş parçacığı havuzu + PRINT kilidi, JS Worker havuzu, WASM paylaşımlı-bellek/host-worker — Mete'nin kendi "çok oturumluk" notuyla uyumlu, bu oturumda başlanmayacak. Mevcut çalışma zamanı incelendi: `native\uxb_runtime\backends\libuv_backend.cpp` bugün `uv_run(UV_RUN_DEFAULT)` ile ÇAĞIRANI bloke ediyor (gerçek eşzamanlılık yok), `ExecSlotTrigger`/`ExecSlotRunBlockBody` sonucu yasaklanan "global TASKOUT" deseniyle (`UXB_TASK_RESULT_NAME`) taşıyor — yeni TASK tutamacı bunu YENİDEN KULLANMAYACAK.

Not (sürüm farkı): çapraz inceleme, `uxb(dokuman).zip` kayıtlarının `uxb(20.09).zip` kaynağından daha yeni olduğunu (S-112 `src/semantic/library_type_contract.fbs` + RATIONAL testleri ZIP'te yok) bildirdi. **Canlı ağaçta bu dosya ve `tests/library_type_contract/` MEVCUT** (Codex'in çalışması, 2026-09-20 21:34); kaynak birleştirmelerinde Codex'in kaydına güvenip ikinci bir uygulama yazılmaz, önce canlı ağaç kontrol edilir.

## 2026-09-23 08:02 — Codex: S-134 B1 uygulanmis alt sozlesme

RATIONAL icin `storage_model=value`, `copy_model=bitcopy`,
`clone_model=bitcopy`, `drop_model=none` secildi ve manifest/registry'ye islendi.
BITCOPY burada bagimsiz mantiksal deger kopyasidir; yorumlayicinin yonetilen
payload'ina ham memcpy yapilmaz. Genel model VALUE/REFERENCE;
BITCOPY/CLONE/RETAIN/FORBIDDEN; BITCOPY/PROVIDER/UNSUPPORTED clone;
NONE/PROVIDER drop alanlarini dogrular. MOVE_ONLY/COW ve otomatik drop kapsam
disindadir. Desteklenmeyen profillerin programda kullanimi acik taniyla durur.

Genel library type icin ADD/TOSTRING zorunlu degildir; bildirilen yetenekler
ayri cozulur. Lifecycle DROP sonucu VOID, diger bildirilen aktarim uyeleri tipin
kendisidir. Bu metadata cozumlemesi tek basina runtime hook uygulamasi degildir.

Kanit: 14/14 kutuphane tipi testi (icinde 41 lifecycle unit kontrolu), 63/63
dizi parametre regresyonu. S-134 tum-motor kabul olcutu acik kalir. Yeni belge:
`docs/tasarim/UXB_S134_LIBRARY_TYPE_LIFECYCLE_20260923_TR.md`.
Bu satir tarihsel ara durumdur. 2026-09-25 taze `bin/uxb.exe` ile
`DYNAMIC_PAYLOAD` adi parser'da tanindi; semantic kapida
`library type lifecycle lowering unavailable` olarak kontrollu reddedildi.
Guncel sonraki gorev genel B3 CLONE/RETAIN/DROP lowering ve kaynak sahibi
provider testleridir.

## 2026-09-24 09:18 — Mete'nin kararları (Claude 1 kaydı): S-142b, S-145, S-128 + açıkları kapatma yönergesi
1. **S-142b (float basımı):** her motor, ondalık sayıyı **tipin izin verdiği hane sayısı kadar** basar (F64: en çok 15-17 anlamlı hane, F32: en çok 7-9); sayının haneleri o kadar dolu değilse **ilave sıfır eklenmez** (en kısa geri-okunabilir gösterim: `2.75`, `0.1`, `1.6583123951777`). Uygulama: native `PRINT <F64/F32>` ve legacy, AST/MIR/`STR` ile birebir aynı çıktıyı verecek.
2. **S-145 (FFI boş metin):** boş uXBasic metni (`""`) her motorda **gerçek boş C metni**dir; NULL **ayrı** bir değerdir (`PTR 0`). Yorumlayıcılardaki "boş metin → NULL" davranışı düzeltilecek.
3. **S-128 (anahtar sözcük adları):** uXBasic anahtar sözcükleri değişken/parametre/alan/SUB adı **olamaz**; dört motorda aynı net derleme hatası; mevcut kaynaklar (libsx, testler, örnekler) taranıp yeniden adlandırılacak.
4. **Yönerge:** açık kalanlar (raylib Models/3D + Shaders, GSL genişletme, legacy STRING/F64/namespace sabitleri, diğer açıklar) kapatma yolunda ilerlenecek; her adım deftere yazılacak.

## 2026-09-24 — Mete'nin S-030 kararları K1–K8 (Claude 1 kaydı)

Kaynak: Claude 1'in S-030 kalan işler planındaki K1–K8 soruları; Mete cevapları sohbette verdi. Yürürlüktedir. Ayrıntı ve bulgular: SORUN_TAKIP.md "S-030" kaydının sonundaki "KARARLAR K1–K8" bölümü; yeni izleme maddeleri S-146, S-147.

1. **K1 `TASKGROUP.JOINALL()`** ileride sonuçları **`LIST`** olarak döndürecek. LIST'in heterojen/tipli sonuç sözleşmesi AST/MIR/native/JS/WASM'da kesinleşene kadar bilinçli olarak ERTELENDİ (S-147). Genel "fonksiyon dizi döndürür" özelliği bu iş için açılmayacak. Şimdilik `g.JOIN()` + tek tek `t.RESULT`.
2. **K2 kullanıcı dilinde ad `TASKGROUP`**; takma ad YOK. uXBasic anahtar sözcüklerinde `_` kullanılmaz. `TASK_GROUP` kullanıcı programında sıradan değişken adı olabilir. MIR iç adları `TASK_GROUP_CREATE/ADD/JOIN` olabilir.
3. **K3 SPAWN sınırında varsayılan izolasyon (Faz 2'de semantik denetimle zorlanır):** skaler BYVAL → izinli; değiştirilemez/kopyası güvenli değer → izinli; CONST → okunabilir; değiştirilebilir global → YASAK; BYREF → YASAK; CLASS/LIST/DICT → sahiplik/paylaşım modeli gelene kadar YASAK; PTR → açık güvenli/paylaşılan bellek sözleşmesi gelene kadar YASAK. Açık paylaşım modeli (`SHARED/ATOMIC/MUTEX/LOCK` + S-056 MemoryRef ile paylaşılan native bellek, açık işaretçi paylaşımı, sahiplik/ömür) ayrı tasarlanır (S-146) ve **Faz 2 başlamadan önce** küçük bir tasarım oturumunda kilitlenir. Eski `TRIGGER` semantiği bu karardan ETKİLENMEZ.
4. **K4** Native çalışma zamanı dinamik TASK sayısını sınırlı worker üzerinde yürütür; varsayılan worker sayısı mantıksal CPU sayısına göre AUTO, `--task-workers N` ile değişir. İç içe SPAWN desteklenir; bekleyen worker mümkünse kuyruktaki başka işi çalıştırır.
5. **K5** Normal kapanış sahip olunan görevlerin bitmesini bekler. Hatalı kapanışta kalan görevlere iptal isteği gider, runtime güvenli boşaltılır. Okunmamış görev hatası sessiz kaybolmaz: hata çıkışına yazılır, çıkış kodu başarısız olur. İleride gerekirse ayrı `DETACH` semantiği tasarlanır.
6. **K6** `CANCEL()` işbirlikçi. Güvenli iptal noktaları: döngü turları, WAIT/JOIN, SPAWN ve uygun runtime çağrıları. Sonuç: `STATUS = CANCELLED`, `ERRORTEXT = "CANCELLED"`; `RESULT/JOIN` iptal hatasını çağırana aktarır. Tekrar CANCEL zararsız.
7. **K7** AST Faz 1 referans olarak kalır. Canonical MIR'e aynı senkron referans semantiği MUTLAKA eklenir (Faz 1B). Native x64'e geçici senkron sürüm YAZILMAZ, doğrudan gerçek asenkron Faz 2. Legacy x64 SPAWN/TASK için açık "desteklenmiyor" hatası verir.
8. **K8** JS Faz 3 Antigravity'nin sorumluluğunda. Çakışan JS dosyalarına başka ajan eşzamanlı dokunmaz. Faz 3 öncesi JS'nin sessiz `ux.callMethod(...)` üretimi temiz "henüz desteklenmiyor" hatasına çevrilir; `SLOT_DEF` açığı aynı JS paketinde kapanır. Görev devri SORULAR_CEVAPLAR.md'ye yazıldı.

**Kesin sıra:** Faz 1 kapanışı (`tests/task_model/`, `g(i).JOIN()` genel alıcı çözümü, TASK/TASKGROUP yüzey matrisi, JS fail-fast [Antigravity]) → Faz 1B canonical MIR (`TASK_SPAWN/WAIT/JOIN/CANCEL/STATUS/RESULT/ERROR`, `TASK_GROUP_CREATE/ADD/JOIN`) → AST↔MIR eşdeğerlik testleri → S-146 tasarım oturumu → Faz 2 native x64 (ABI v2, TaskRun tablosu, gerçek worker havuzu, result/error, CANCEL, shutdown, PRINT kilidi, stres testleri) → Faz 3 JS Worker (Antigravity) → Faz 4 WASM. `JOINALL`, `BYREF`, `PAUSE/RESUME/KILL`, ortak değiştirilebilir bellek ve kilitler S-030 çekirdek kapanışını GECİKTİRMEZ; ayrı genişletmelerdir (S-146, S-147).

**Not (`TRIGGER TASK` sorusu):** Kullanıcı `TRIGGER TASK` yazmaz. `TRIGGER Hedef` kısa biçiminde parser, düğüme iç etiket olarak `"TASK"` koyar (anlamı: tür henüz belli değil, SLOT tablosundan çözülecek; `parser_stmt_event_pipe.fbs::ParseTriggerStmt`). Dil yüzeyinde görünmez; `TASK` tipiyle kullanıcı düzeyinde çakışma yaratmaz.

mete dekledi, tarih saat ve duzenleme bilgisini lutfen biriniz duzeltin 24.09.26 sabak 9.35
hakinda planlamalar.

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

## 2026-09-25 — S-149 onayı ve S-030 Faz 1B uygulama kararları (Claude 1 kaydı)

Mete S-149 önerisini onayladı: **`DIM t AS TASK OF I32`** tipli görev tutamacı; düz `TASK` tipsiz kalır (sonucu OBJECT, tipli hedefe açık cast). Uygulamada kilitlenen ayrıntılar (itiraz olursa değişir):
1. `OF` yeni anahtar sözcük değildir; yalnız `TASK`'tan hemen sonra bağlamsal tanınır (S-128'e göre `of` adlı değişkenler bozulmaz). `TASK OF` DIM/REDIM, parametre ve FUNCTION/DECLARE FUNCTION dönüşünde geçerlidir; `TASK OF TASK/TASKGROUP` yasak.
2. THREAD/PARALEL isteğe bağlı `AS <tip>` sonuç tipi alır (`THREAD Worker(x AS I32) AS I32`); `TASK OF T`'ye yalnız bu tipi bildiren hedefin SPAWN'ı, aynı tipte TASK OF değişken/parametre/dizi elemanı ya da `AS TASK OF T` döndüren FUNCTION bağlanabilir. Tipsiz TASK → TASK OF reddedilir; TASK OF → TASK serbesttir. EVENT senkron ve sonuçsuz kalır.
3. Canonical MIR görev sözlüğü (K7) ayrı opcode değil, LIST_NEW/LISTADD kalıbında adlandırılmış kanonik `MIR_CALL`: `TASK_SPAWN/WAIT/JOIN/CANCEL/STATUS/RESULT/ERROR`, `TASK_GROUP_CREATE/ADD/JOIN`. Native x64 Faz 2'de bu adları C ABI'ye bağlayacak; o zamana kadar açık red. Legacy AST-x64 kalıcı açık red.
Ayrıntı ve kanıt: SORUN_TAKIP.md "S-030 FAZ 1B UYGULAMA SONUCU + S-149".

## 2026-09-25 — S-146 görevler arası paylaşılan veri: Mete kararları D1–D6 (Claude 1 kabul etti)

Kaynak ve ayrıntılı gerekçe: `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` (Mete'nin cevabı + §8 Claude değerlendirmesi).

- **D1 EVET:** SPAWN hedefinin bütün geçişli çağrı grafiği görev güvenliği açısından denetlenir. Rutin başına etki özeti çıkarılır (READS/WRITES_GLOBAL_MUTABLE, USES_RAW_PTR, USES_SHARED, USES_ATOMIC, USES_UNSAFE_FFI, USES_INPUT, BLOCKS, SPAWNS). Özyineleme sabit nokta ile çözülür. Bilinmeyen FFI ya da dinamik etki fail-closed reddedilir. CONST ancak değer tipiyse güvenlidir.
- **D2 DEĞİŞTİRİLEREK EVET:** `SHARED + ATOMIC + MUTEX + LOCK` birlikte. `GUARDED BY` yok: her `DIM SHARED` verisi kendi `lockId`'sini taşır, `LOCK veri ... END LOCK` statik olarak doğrulanır. `MUTEX` veri dışı kaynaklar (DLL vb.) ve çoklu kritik bölge içindir. `ATOMIC` zaten paylaşımlıdır; kanonik biçim `DIM ATOMIC x AS I64`. `x = a` → LOAD, `a = 10` → STORE, `a += 1` → ADD. Kayıp güncelleme kalıbı hata verir. Bellek sırası SEQ_CST. Açık üyeler: `.LOAD/.STORE/.ADD/.SUB/.EXCHANGE/.CAS`.
- **D3 İKİSİ:** `CLONE` bağımsız kopya, `MOVE` sahiplik devridir. Görevlere özel ayrı yaşam döngüsü kurulmaz; S-134 `copy/clone/drop` modelleri ve sağlayıcılarıyla bağlanır. Kütüphane tipi tanımına `taskTransfer`, `threadSafety` ve `sharedPolicy` alanları eklenecek. Faz 2A'da CLASS/LIST/DICT ve kütüphane tipleri görev sınırından geçmez.
- **D4 HATA:** MUTEX yeniden girişli değildir. Aynı TASK aynı kilidi tekrar alırsa `SELF_DEADLOCK` oluşur. Kilidin sahibi TASK kimliğidir. Çoklu `LOCK a, b` platformdan bağımsız `lockOrderId` sırasıyla alınır ve ters sırayla bırakılır. LOCK transaction değildir. LOCK içinde CANCEL bölüm sonuna ertelenir. LOCK içinde WAIT/JOIN/RESULT/TASKGROUP.JOIN yasaktır.
- **D5 AÇIK RED:** JS/WASM'da paylaşılan bellek ya da atomik yeteneği yoksa ATOMIC/MUTEX/SHARED kullanan program hedef adını içeren bir hatayla reddedilir; sessizce tek iş parçacığına düşülmez. Paylaşım kullanmayan SPAWN mesajlaşmayla çalışabilir. TASK OF T için sağlayıcı yoksa hedef adını içeren red verilir. Canonical MIR senkron referans uygulaması bir doğrulama motorudur, üretim yedeği değildir.
- **D6 EVET:** R1–R6 ve geçişli etki kuralları native Faz 2'den önce AST/MIR semantik kapısına eklenir. Yalnız SPAWN yolu etkilenir; TRIGGER korunur. Bir gövde hem TRIGGER hem SPAWN hedefiyse SPAWN kuralları uygulanır.
- **Sıra:** S-146 izolasyon analizi → Faz 2A (gerçek native async, izole) → Faz 2B (SHARED/ATOMIC/MUTEX/LOCK + MemoryRef paylaşımlı bölge + kütüphane iş parçacığı güvenliği sözleşmesi) → S-134 ile MOVE/CLONE → BYSHARED/PIN. JOINALL ve gelişmiş paylaşım, çekirdek native async'in kapanmasını geciktirmez.

**Claude'un açık itirazları (Mete onayı bekleniyor, belge §8.2):** İ1 SHARED'a kilitsiz erişim ana program dahil her yerde hata olsun; İ2 ATOMIC kayıp güncelleme kuralı genel olsun, tek adımda yapılamayan bileşik atamalar hata versin; İ3 yerleşik ortak durumlar (konsol, dosya kanalları, RND, SHELL, ham bellek, STATIC alanlar, FFI) 2A'da görev gövdesinde reddedilsin (**şimdiden uygulanıyor**, sonradan gevşetilebilir); İ4 LOCK altında bloklama yasağı geçişli olsun; İ5 TASK tutamaçları 2A'da görev sınırından geçmesin.

## 2026-09-26 — S-146 NİHAİ SÖZLEŞME (Mete) — önceki D1–D6 uygulamasının yasak kuralları iptal

Mete, 2026-09-25 tarihli S-146 izolasyon kurallarını (R1–R6, İ1–İ5, "Faz 2A'da şimdilik yasak") nihai dil tasarımı olarak iptal etti. Yerine 15 maddelik nihai sözleşme: normal global/STATIC değişkenler görevlerde serbest ve deyim düzeyinde otomatik senkronize; LOCK yalnız çok-deyimli bölünmezlik; SHARED = yerel veriye görevler arası ömür; ATOMIC = performans depolama sınıfı (x=x+1 dahil CAS'a iner); tüm yaşam döngülü tipler COPY/CLONE/MOVE/RETAIN/SHARE ile sınırdan geçer; BYREF yalnız ömür garantisizse reddedilir; TASK tutamaçları görevler arası geçer + bekleme çevrimi tespiti; RND/dosya/konsol/SHELL/PTR/FFI görevlerde serbest (çalışma zamanı güvenli hale getirir, FFI üst veriyle); tek yasak: görevde END. Tam metin: `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` §9. Claude kabul etti; §9.1'deki üç teknik soru Mete'de.

## 2026-09-26 — S-146 Model D (Mete kesin kararı; §9'u tamamlar)

A/B/C reddedildi, **Model D**: normal global/STATIC değişkenler görevlerde doğal kullanılır ve dil garantisi olarak otomatik senkronize edilir (depo başına kilit, tek küresel kilit yok); LOCK çok-deyimli bölüm, otomatik kilitle sahiplik paylaşır (iç içe açık LOCK = SELF_DEADLOCK); ATOMIC performans depolama sınıfı (x=x*2+5 dahil CAS); MUTEX dış kaynak için; UNSAFE seçili güvenceleri kaldıran kaçış kapısı; motorlar arası veri semantiği aynı, zamanlama sırası değil; etki analizi kod üretim bilgisi; tek yasak görevde END. Uygulama sırası 7 adım (belge §10). Claude uygulama kuralı §10.1: deyim içi kullanıcı çağrıları kilitten önce hesaplanır, kilit çağrı boyunca tutulmaz (deadlock yok). Kaynak: `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` §10.

## 2026-09-26 — S-146 Model D 1. adım UYGULANDI (Claude 1) + Claude'un ayrıntı seçimleri (Mete onayına açık)
Otomatik senkron + LOCK + ATOMIC + MUTEX + UNSAFE üç motorda (AST, MIR, native x64) uygulandı; legacy AST-x64 açık red.
Ayrıntı: `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` §11. Testler `tests/task_sync` (72/72),
`tests/task_model` Model D'ye taşındı (eski "global yasak" negatifleri olumlu teste döndü; 192/192).
Belgede açık bırakılmış ayrıntılar için Claude'un seçimi (değişebilir):
- `ADD(n)`/`SUB(n)` **yeni** değeri, `EXCHANGE(v)` **eski** değeri, `STORE(v)` yazılan değeri döndürür; `CAS(e, n)` TRUE = -1 / FALSE = 0 (karşılaştırma sonucu gibi).
- ATOMIC tipi: I8..U64, BOOLEAN, F32, F64 (STRING/UDT için "LOCK kullanın" tanısı). BOOLEAN'da ADD/SUB yok.
- SELF_DEADLOCK / LOCK_DEADLOCK ölümcül (program durur, TRY yakalamaz, görev hatası olarak tutulmaz) — native'de alt rutin çerçevelerini geri saramadığımız için üç motorda aynı davranış bu.
- LIST/DICT/SET globalleri görevlerde serbest (koleksiyon tablosu zaten kilitli + deyim kilidi).

metenin karari 28.09.2026
Evet. **23.09 tarihli kaynak ZIP'ini esas alarak baktığımda A/B ayrımını artık kaldırmak daha doğru.** Çünkü kaynakta A ve B gerçekte iki bağımsız önişlemci değil. B seçildiğinde önce B'ye özgü web/manifest işleyicisi deneniyor, ardından ortak komut işleyicisi yine çalışıyor. Yani bugünkü durumda **B ≈ ortak önişlemci + birkaç ek komut**.

Bu yüzden senin verdiğin örneğin cevabı da net: **`%%PP B` aktifken `%%FOREACH` zaten çalışıyor.** `FOREACH`, `FOR`, `IF`, `DEFINE`, `SET` gibi yapılar A/B denetiminin dışında ortak ana tarayıcıda işleniyor. Buna karşılık `API_ENDPOINT`, `GEN_FILE`, `HOST_IMPORT`, `BUNDLE_NAME` gibi komutların A'da yapay olarak engellenmesi giderek anlamsızlaşıyor.

## Yeni temel kural

Sistemi iki ayrı komut kümesi olarak değil, iki ayrı **aşama** olarak kurardım:

```text
%%...       = kaynak oluşmadan önce çalışan ÖNİŞLEMCİ
REM %%...   = oluşmuş program hakkında çalışan META SİSTEMİ
```

Aradaki ayrım bu kadar temiz olmalı.

Ham `%%` tarafı bugün yaptığı işleri yapmaya devam eder:

```basic
%%DEFINE
%%SET
%%IF
%%FOREACH
%%INCLUDE
%%TEMPLATE
%%GEN_BLOCK
%%HTML_BEGIN
%%JS_BEGIN
%%WAT_BEGIN
%%API_ENDPOINT
%%HOST_IMPORT
%%ASSET_IMAGE
...
```

Artık bunların hiçbiri A veya B'ye ait değildir. Hepsi **uXBasic Birleşik Önişlemci Komutlarıdır**.

`%%PP A` ve `%%PP B` ise eski programları kırmamak için bir süre kabul edilir ama işlevsel etkileri kalmaz:

```basic
%%PP A
%%PP B
```

ikisi de aynı birleşik önişlemciye gider. Derleyici isterse:

```text
PREPROCESSOR_PP_DEPRECATED_NO_EFFECT
```

uyarısı verir.

---

## `%%FOREACH` ile eski B komutları artık doğal biçimde birleşir

Örneğin bu yasal olmalı:

```basic
%%FOREACH API IN "fish,water,feed"

%%API_ENDPOINT {{API}} GET "/api/{{API}}"
%%FEATURE API_{{API}}

%%ENDFOREACH
```

Mevcut `FOREACH` kodu açısından bunun güzel bir tarafı var: genişlettiği gövdede yeniden `%%` bulursa üretilen metni kaynak akışına geri sokuyor. Yani ikinci turda üretilmiş `API_ENDPOINT` komutları zaten işlenebiliyor.

Dolayısıyla A/B duvarını kaldırmak mevcut mekanizmaya karşı değil, **mevcut mekanizmanın gerçekte yaptığı şeyi resmileştirmek** oluyor.

---

# `REM %%` için önceki tasarımımızı biraz değiştirdim

Burada önemli bir mimari sonucu kaynak kod ortaya çıkardı.

`REM %%` meta satırlarını **mevcut önişlemcinin içinde işlememek** daha doğru.

Şu sıra çok daha temiz:

```text
Kaynak
  │
  ▼
Birleşik %% Önişlemci
  │
  ▼
expandedSource
  │
  ├────► REM %% Meta Tarayıcı
  │
  ▼
Lexer
  ▼
Parser
  ▼
AST
  │
  ◄──── Meta → AST bağlama
  ▼
Semantic / tip / layout / kütüphane
  ▼
MIR
  │
  ◄──── Meta → MIR bağlama
  ▼
MIR doğrulama / optimizasyon
  ▼
x64 / JS / WAT-WASM / MIR yürütme
  │
  ▼
HTML / CSS / JS / manifest / bridge / test / reflection
```

Bu küçük görünen değişiklik aslında çok önemli.

Çünkü:

```basic
%%FOREACH T IN "I32,F64"

REM %%ATTR TEST
FUNCTION Test_{{T}}() AS BOOLEAN
    RETURN TRUE
END FUNCTION

%%ENDFOREACH
```

önce `FOREACH` tarafından iki kez üretilir.

Sonra meta tarayıcı şunu görür:

```basic
REM %%ATTR TEST
FUNCTION Test_I32() AS BOOLEAN
...

REM %%ATTR TEST
FUNCTION Test_F64() AS BOOLEAN
...
```

Böylece meta motoruna tekrar `FOREACH`, `IF`, `INCLUDE`, makro genişletme sistemi yazmamız gerekmiyor.

**Önişlemci üretir, meta sistemi üretilmiş programı inceler.**

Bu ciddi biçimde daha sade.

---

# `REM %%` için onlarca yeni komut da istemiyorum

Önceki tasarımımızdaki:

```text
REM @[...]
REM @{...}
```

ayrımının fikrini koruyabiliriz ama sözdizimini senin istediğin tek biçime indirebiliriz:

```basic
REM %%ATTR ...
REM %%MIR ...
```

Bence başlangıç için **iki ana meta ailesi yeterli**.

`ATTR`, sembolün ne olduğunu söyler:

```basic
REM %%ATTR TEST
REM %%ATTR DEPRECATED "YeniHesapla kullan"
REM %%ATTR REFLECT
REM %%ATTR SERIALIZABLE
REM %%ATTR EXPORT JS
REM %%ATTR EXPORT WASM
REM %%ATTR ROUTE GET "/api/fish/{id}"
REM %%ATTR AUTHOR "Mete"
```

Örneğin:

```basic
REM %%ATTR EXPORT JS
REM %%ATTR EXPORT WASM

FUNCTION Calculate(x AS F64) AS F64
    RETURN x * x
END FUNCTION
```

AST'de `Calculate` bulunur, semantic aşamada gerçek imzası belirlenir ve MIR tarafında kabaca:

```text
FUNCTION Calculate(F64) -> F64

META
    EXPORT.JS   = TRUE
    EXPORT.WASM = TRUE
```

haline gelir.

Programcı artık ayrıca:

```basic
%%EXPORT_BASIC Calculate AS "F64(F64)"
```

diye imzayı ikinci kez yazmak zorunda kalmaz.

Eski `%%EXPORT_BASIC` çalışmaya devam eder. Yeni sistem ise gerçek imzayı derleyiciden çıkarır. Bu daha güvenilir.

---

## `REM %%MIR` farklıdır

Bu:

```basic
REM %%MIR ...
```

"bu sembol nedir?" demez.

**MIR bunu nasıl ele alsın?** der.

Fakat burada biraz fren yapmak gerekiyor.

Örneğin daha önce:

```basic
REM %%MIR INLINE AUTO
REM %%MIR OPTIMIZE SPEED
```

gibi örnekler verdik.

23.09 kaynakta MIR optimizasyon geçişlerine baktım. Şu anda açık biçimde:

```text
constant folding
dead block elimination
```

var.

Gerçek bir fonksiyon satır içi genişletme geçişi görmedim.

Dolayısıyla bugün:

```basic
REM %%MIR INLINE
```

yazıp "çalışıyor" demek süslü bir yalan olur.

Yeni sistemin kuralı şu olmalı:

> `REM %%MIR` politikası ancak onu gerçekten kullanan MIR/arka uç kodu varsa kabul edilir.

Yoksa:

```text
META_MIR_POLICY_NOT_IMPLEMENTED
```

ile reddedilir.

Bu, uXBasic'te kağıt üzerinde özellik birikmesini önler.

---

# MIR konusunda kaynakta bulduğum kritik ayrıntı

Burada önceki tasarımımızı daha da düzeltiyorum.

23.09 kaynakta pratikte **iki MIR gösterimi** var.

Birincisi:

```text
src/semantic/mir_model.fbs

MIRModule
MIRFunction
MIRIRInstruction
```

Bu yapı doğrudan:

```text
x64
JavaScript
WAT/WASM
```

üreticileri tarafından kullanılıyor.

İkincisi ise `src/mir/...` altındaki kanonik MIR kayıtları. Semantic MIR buraya:

```text
semantic_to_canonical_mir_bridge.fbs
```

ile çevriliyor.

Dolayısıyla meta veriyi yalnız kanonik MIR'e koyarsak **x64/JS/WASM görmez**.

Bunun yerine meta verinin gerçek sahibi ortak semantic `MIRModule` olmalı.

Örneğin:

```freebasic
Type MIRMetaRecord
    targetKind As Integer
    targetIndex As Integer

    keyText As String
    valueText As String

    sourceFile As String
    sourceLine As Integer
End Type
```

ve mevcut:

```freebasic
Type MIRModule
```

sonuna yalnız:

```freebasic
metaRecords(Any) As MIRMetaRecord
metaCount As Integer
```

eklenir.

Bu yeter.

Her meta özellik için yeni opcode üretmek gerekmez.

Şöyle bir felaket istemiyoruz:

```text
MIR_TEST
MIR_AUTHOR
MIR_DEPRECATED
MIR_SERIALIZABLE
MIR_ROUTE
MIR_EXPORT
...
```

Bunlar işlem değildir, **veridir**.

---

# AST'yi de şişirmemek gerekiyor

Mevcut `ASTNode` zaten:

```text
kind
value
lineNo
colNo
family
flags
typeName
symbolName
sourceFile
sourceOffset
sourceLength
...
```

taşıyor.

Bunlar `REM %%ATTR` satırını sonraki sınıfa, tipe, metoda veya fonksiyona bağlamak için yeterli.

Bu yüzden önceki:

```text
ASTNode.metaFirst
ASTNode.metaCount
```

önerim bile zorunlu değil.

Daha az müdahaleci çözüm:

```text
MetaRegistry
   directive
   sourceLine
   targetAstNode
   targetMirIndex
```

şeklinde dış registry.

AST'nin temel sözleşmesine dokunmadan ilerliyoruz.

---

# `PreprocessResult` ile `MetaRegistry` kesinlikle ayrılmalı

Bu konuda önceki kararımız doğruymuş.

Mevcut kaynak `preprocess_meta_model.fbs` içinde açıkça:

> önişlemci modelinin parser/AST/MIR'den bağımsız olması gerektiğini

söylüyor.

Bunu bozmayalım.

Dolayısıyla:

```text
PreprocessResult
```

şunların dünyasıdır:

```text
expandedSource
blocks
assets
watImports
manifest
jsonEntries
sourceMap
target
outDir
...
```

Yeni:

```text
MetaRegistry
```

ise:

```text
ATTR
MIR policy
AST hedefi
semantic sembol
MIR hedefi
çözümlenmiş tür/imza
```

dünyasıdır.

Son aşamada ikisi yalnızca **artifact üretirken buluşur**.

---

# Eski B sistemi çöpe gitmiyor

Bu da önemli.

`PreproesssorB` içindeki:

```text
BUNDLE_NAME
API_ENDPOINT
ROUTE
HOST_IMPORT
GEN_FILE
CAPABILITY
...
```

mantığı gayet kullanışlı.

Sorun komutlar değil, "B diye ayrı bir preprocessor varmış" izlenimi.

Örneğin yeni:

```basic
REM %%ATTR EXPORT JS
```

MIR'e kadar gider.

Sonra meta artifact üreticisi bunu mevcut browser manifest biçimine dönüştürür.

Mevcut browser çalışma zamanı ve artifact üreticileri zaten `PreprocessResult` bloklarını/manifestini okuyor.

Dolayısıyla:

```text
REM %%ATTR EXPORT JS
         ↓
AST
         ↓
Semantic
         ↓
MIR gerçek imza
         ↓
MetaEmit
         ↓
mevcut browser manifest
         ↓
mevcut JS runtime
```

olur.

İkinci bir web sistemi yazmaya hiç gerek yok.

---

# EXE ↔ Browser konusunda da mevcut sistemi kullanalım

Kaynakta zaten:

```text
runtime/browser/ux_localhost_bridge.js
```

var.

Ve bu:

```text
http://127.0.0.1:8765
```

üzerinden localhost köprüsü kuruyor.

Dolayısıyla ilk meta sürümünde gidip bir de WebSocket sunucusu yazmanın anlamı yok.

Native hedef:

```text
uXBasic EXE
    ↕
mevcut localhost bridge
    ↕
JavaScript
    ↕
Browser
```

WASM hedef:

```text
uXBasic MIR
    ↓
WASM
    ↕
mevcut ux_wasm_bridge.js
    ↕
Browser
```

olur.

Gerçek zamanlı akış ihtiyacı çıktığında WebSocket ayrıca eklenir.

Bu tam "yeterli ama şişmemiş" yaklaşım.

---

# Kütüphaneler için de yeni sistem kurmuyoruz

Bu da kaynak incelemesinde önemli çıktı.

`library_type_contract.fbs` zaten kütüphane tipleri için:

```text
layout
size
alignment
fields

mirPolicy
jsPolicy
wasmPolicy
nativePolicy
```

tutuyor.

Dolayısıyla:

```basic
REM %%ATTR REFLECT
REM %%ATTR SERIALIZABLE
```

bir kütüphane tipine uygulanıyorsa meta motoru tekrar tip bilgisi icat etmeyecek.

Mevcut kütüphane sözleşmesini okuyacak.

Örneğin tip:

```text
layout = opaque
nativePolicy = native_x64
wasmPolicy = fail_closed
```

ise:

```basic
REM %%ATTR EXPORT WASM
```

yazmak bu yasağı sihirli şekilde aşamaz.

Hata verir.

Meta sistemi mevcut kütüphane sözleşmelerinin **üstünde**, onları geçersiz kılan ayrı bir dünya olmamalı.

---

# Birleşik sistemin son hali

```text
                         uXBasic kaynak
                              │
             ┌────────────────┴────────────────┐
             │                                 │
           %%...                           REM %%...
             │                                 │
             ▼                                 │
   BİRLEŞİK ÖNİŞLEMCİ                          │
   kaynak üretimi                              │
   dosya/blok/asset                           │
   template/web                                │
             │                                 │
             ▼                                 │
       expandedSource                          │
             │                                 ▼
             │                         META SCANNER
             │                                 │
             ▼                                 │
           LEXER                               │
             ▼                                 │
           PARSER                              │
             ▼                                 │
            AST ◄──────────────── MetaBindAST ─┘
             │
             ▼
  SEMANTIC / TYPE / LAYOUT / LIBRARY
             │
             ▼
        ╔═══════════╗
        ║    MIR    ║ ◄──── MetaBindMIR
        ╠═══════════╣
        ║ kod       ║
        ║ tipler    ║
        ║ semboller ║
        ║ metadata  ║
        ╚═════╤═════╝
              │
       ┌──────┼───────┬─────────┐
       ▼      ▼       ▼         ▼
     MIR     x64      JS      WAT/WASM
   yürütme
       └──────┬───────┴─────────┘
              ▼
        MetaEmitArtifacts
              │
      HTML / CSS / JS
      manifest / bridge
      reflection / tests
      documentation
```

## En önemli sınır

Burada "AST ve MIR'den bilgi alıp verebilir" cümlesini de gerçekçi tanımlamak gerekiyor.

`REM %%`:

**AST/MIR'e meta bilgi verebilir.**  
**AST/MIR'den çözümlenmiş bilgi okuyabilir.**  
**Bu bilgiden belge, test listesi, serializer, bridge, manifest, JS/WASM bağlantısı gibi ürünler üretebilir.**

Ama MIR oluştuktan sonra:

> "Şimdi AST'yi geçmişe dönüp değiştireyim, tekrar kaynak oluşturayım, sonra tekrar MIR oluşturayım"

gibi sınırsız döngü ilk sürümde olmamalı.

Bu ikinci derleme geçişi ve sabit nokta problemi yaratır. Derleyiciyi akıllandırmaya çalışırken Ouroboros yazmaya gerek yok.

Kaynak üretimi için zaten güçlü:

```text
%%
```

sistemimiz var.

Yeni sınır çok temiz:

```text
%%          → programı oluşturur.
REM %%ATTR  → oluşan programın ne olduğunu açıklar.
REM %%MIR   → MIR/arka uca politika verir.
MIR meta    → oluşmuş programı inceleyip dış ürünlerini üretir.
```

Bu sistem **kendini geliştirebilen uXBasic** fikrine de yeterli temel sağlar. Çünkü önişlemci uXBasic kaynak üretebilir; meta sistemi derlenmiş programın yapısını okuyabilir; MIR bütün hedeflere ortak bilgi sağlar; artifact sistemi bu bilgiden JS/WASM/browser/native bağlantılarını ve yardımcı kaynakları üretebilir. Ama bunların hiçbiri birbirinin görevini çalmıyor.

Kaynak incelemesine dayalı ayrıntılı teknik yeniden yapılandırma belgesini de oluşturdum:

:chatgpt-content-reference{index="0"}[**uXBasic Birleşik Önişlemci + REM Meta + MIR Yeniden Yapılandırma Belgesi**](sandbox:/mnt/data/UXB_META_PREPROCESSOR_MIR_YENIDEN_YAPILANDIRMA_20260924.md)

Bir sonraki kodlama aşamasında önce **A/B ayrımını kaldıran ama bütün eski `%%` testlerini koruyan küçük yama**, ardından `MetaScanExpandedSource → MetaBindAST → MetaBindMIR` zinciri gelmeli. Bu sırayla yapılırsa sistemi bir kerede parçalayıp sonra parçaları yerden toplamamız gerekmez.

kisaca preprpcessor birlesecek %% preprocessor, rem %% meta komut  yapilacak gerekli planlama yapin. sorun defterlerinde ilgili maddeleri guncelleyin.
tasarim belgesi doc\tasarim klasorunde.


## 2026-10-07 — Mete'nin önerilen çözümlerle devam talimatı (Codex)

Mete'nin "sorunlari cozmeye onerilenlerle devam et" yönlendirmesi,
`docs/tasarim/UXB_INCELEME_KARAR_ONERILERI_20261006_TR.md` içindeki önerilen
uygulama yönünü yetkilendirir. Alternatifler seçilmiş sayılmaz. Yeni talimat,
eski KARAR-BEKLIYOR kayıtlarından önce gelir; Codex tek sorumludur.

B01 sabit adresli sayfalı hücreler; H01-H03 uyumlulukla yapılandırılmış hata
merkezi; D01 aralığa sığan sabit tamsayı istisnası; D02 RETURN'de atama kuralı;
D07 yalnız seçilen dalı çalışan IFF uygulanmaya başlandı. D03-D06 ve önceki
T01-T14 tasarımları aynı yetki kapsamında açık işlerdir. İlgili kodun çalışır
olduğu ayrıca kanıtlanmadan hiçbir madde tamamlanmış sayılmaz.

Uygulama kaydı: `docs/tasarim/UXB_ONERILER_UYGULAMA_20261007_TR.md`.


### 2026-10-07 Codex — kalan öneriler uygulaması sürüyor

Mete kalan işlerin önerilere göre tamamlanmasını açıkça istedi. D03-D06 ve D01
uygulaması kaynakta ilerletildi; ana binary önceki doğrulanmış yayın olarak korunuyor.
Yeni kayıt: `docs/tasarim/UXB_KALAN_ISLER_UYGULAMA_20261007_TR.md`.
`reports/remediation_20261007_remaining/book_h.json`: 98/98 beklentili kitap örneği
AST/MIR/native; 32 beklentisiz dosya kabul sayılmadı. `language_i.json`: 199/199;
`diagnostics_i.json`: 27/27. Sonrasında eklenen sınıf STATIC, koşul ve FINALLY
kapsam testleri ayrı adaylarla tamamlanıyor. Yeni kaynak ana yayına aktarılmadı.
Başka AI ortamı çağrılmadı; dosya silinmedi. Yönetilen sağlayıcı yaşam döngüsü,
web genişliği, yüzey matrisi, büyük kaynak performansı ve S-194 halen açık.

### 2026-10-07 Codex — çalışma sahipliği uygulanması

Tam workspace yolu ile ilişkilendirilen mevcut Claude Code PID 26052 ve
alt süreçleri, Mete'nin tek AI/Codex talimatı doğrultusunda durduruldu.
Masaüstü uygulamalarının genel kapanışı yapılmadı; dosya silinmedi.
Süreç argümanlarının ham metni/gizli bilgiler rapora yazılmadı.

## 2026-10-07 Codex — Mete'nin son görev ayrımı ve kabul hedefi

Son kullanıcı talimatı önceki tek-ortam kısıtına açık istisnadır: mevcut Claude
Code görevi tasarım/belge/özellik taraması ve kendi derlenmiş binary testlerini
yürütebilir. Codex o görevi durdurmaz, yeniden başlatmaz veya yönlendirmez;
kendi kalan kaynak işleri, koordinasyon kayıtları ve gerçek motor kabulüne
odaklanır. Önceki PID 26052 durdurma kaydı tarihsel olarak korunur; yeni görev
ayrımında geçerli çalışma yöntemi değildir. AGENTS ve politika buna göre güncellendi.

Altı motor (AST, MIR, MIR-x64, AST-x64, JS, WAT/WASM) aynı dil davranışını
sağlamalıdır. Açık ret güvenli bir ara durumdur; çalışan özellik/parite kapanışı
sayılmaz. Pseudo/TODO/sessiz başarı kabul edilmez. Tasarımdaki yeni kararlar eski
planlardan önce gelir. Codex kendi aday çıktısı ve ayrı build scratch kullanır;
Claude'un belge/eğitim çıktıları veya compiler/test süreçleri değiştirilmez.
GitNexus MCP bağlantısı doğrulandı; başlangıçta yalnız başka bir repo indeksli.
Aktif uxb kaynak kapsamı ayrıca kurulup ölçülecek; var olan tekdosyaklsoru
analizleri canlı kaynakla doğrulanarak kullanılacak.

## 2026-10-11 Mete - altıncı madde için bağlayıcı karar

Motor sadelestirme onerisi icin henuz onay verilmedi; onceki karar gecerlidir.
Tum uretim kurallari tum motorlara uygulanacak. AST, MIR, MIR-x64, AST-x64, JS
ve WAT/WASM bir komutun tasarlanan davranisini kendi katmaninda saglamali.
Tasarim disi calisma veya hedef destegi yoksa katmana gore degisen sessiz
basari yerine ayni canonical diagnostic code, mesaj semantigi, cikis durumu ve
structured output sozlesmesi kullanilacak.

Codex bu karari S-410 library type provider tanilarinda uygulamaya aldi.
S-409/T09 halen oneridir ve koddan kaldirilmayacak veya motorlar birlestirilerek
yonlendirilmeyecek.

## 2026-10-12 Mete - parantezsiz cagri icin baglayici karar (sohbetten; Claude kaydetti)

Mete, Kilavuz V2 oturumunda su karari verdi: parantezsiz `Selam "Ayse"` gibi bir
fonksiyon calismamali, derleyici parantez istemeli. Anlami: `SUB`, `FUNCTION` ve
metot cagrisi parantezle yazilir; parantezsiz bicim (`Selam`, `Selam "Ayse"`,
`Yaz k`, `Artir n`, `o.Selam`, `o.Yaz 5`) bir dil ozelligi DEGILDIR ve sessizce
yok sayilmayacaktir, acik derleme hatasi verecektir. `CALL Ad` zaten
"CALL: missing (" ile reddediliyor.

Bugunku davranis (bin/uxb_kilavuz_20261007.exe, AST/MIR/x64/JS): parantezsiz cagri
cikis kodu 0 ile hicbir sey yapmadan geciyor; BYREF degisken degismiyor. Bu karara
aykiri bir sessiz kusurdur: SORUN_TAKIP S-440 (durum ACIK-TASARIM-KARARI-KAYITLI).
Kabul olcutu: kayittaki programlar altı yolun hepsinde ayni canonical diagnostic
code ve ayni mesaj semantigiyle derlenmez (2026-10-11 ortak tani kodu karari);
parantezli bicim degismeden calisir; yeni model testi eklenir. Kod degisikligi
Codex'tedir; Claude yalniz kilavuz (Bolum 8.1, 23.3, 23.6) ve kayitlari guncelledi.

## 2026-10-13 Codex uygulama notu - S-440 / S-479

S-440 karari uygulandi: `IDENT` veya `FIELD_EXPR` olarak kalan callable-shaped
statement'lar ortak parser sinirinda `UXB_CALL_PAREN_REQUIRED` ile reddediliyor.
Tanı katalog, parser bridge, parser JSON ve ortak failure JSON yollarinda ayni
kodu tasiyor. Iki negatif ornek yedi hedef fiilinde 14/14, parantezli pozitif
ornek 1/1 gecti. `run_all_model_tests.ps1` icinde `diagnostics` paketi olarak
kalici regresyon testi bulunuyor.

S-479 icin runtime execution sozlesmesi geri baglandi ve `build_64.ps1 -Force`
exit 0 verdi. Secili model regresyonu 138/138 PASS'tir. Kilavuz V2'nin tum
yeniden olcumu ayri belge/olcum gorevi olarak acik tutulur.

## 2026-10-13 Codex uygulama notu - S-441

Mete'nin tum uretim yollarinda ayni tasarim disi davranis icin ortak ret ve
canonical tani kodu karari uygulanmistir. `CONST` salt okunur kabul edilir;
`A = 4`, `A += 1`, yordam ici yazma ve bilinen `BYREF` parametresine `A`
aktarimi `UXB_CONST_ASSIGNMENT` ile reddedilir.

Parser kapisi AST yolunu da kapsar; semantic Step3 ayni kontrolu koruyucu
olarak tekrarlar. Lexical scope owner AST parent zincirinden bulunur. Yerel
`DIM`/parametre ust kapsam `CONST` adini golgeler; bu nedenle genel string
aramasi kullanilmaz.

Kanit: S-441 matrisi 35/35 PASS, S-440 + numeric/library/iterator/routine/
exception secili regresyonu toplam 188/188 ve 7/7 paket PASS. Ayrintili
uygulama belgesi: `docs/tasarim/UXB_S441_CONST_YAZMA_TANI_DIKEYI_20261013_TR.md`.

## 2026-10-13 Codex uygulama notu - S-442 UNION ortak MIR

UNION alanlari sinif `FIELD_LOAD/STORE` veya `U.B` pseudo-variable degildir.
Baglayici canonical sozlesme `MIR_UNION_FIELD_LOAD/STORE(root, field, offset,
width, type)` olarak kilitlendi. Bilesik atama, `INCDEC_STMT` ve
`INCDEC_EXPR` bu sozlesmeye iner; hedef backend'ler kendi storage modeline
uygular. WAT ilk halkada her UNION kokunu 256 byte'lik linear-memory lane'e
baglar ve 1/2/4-byte integer alanlarin layout offset'lerini uygular. 8-byte,
F32/F64 typed storage ve UNION dizi/index semantigi sonraki gorevdir.

Kanit: `run_union_overlay_tests.ps1` 6/6; secili regresyon 174/174, 7/7;
`build_64.ps1 -Force` exit 0. Ayrinti:
`docs/tasarim/UXB_S442_UNION_ORTAK_BELLEK_MIR_20261013_TR.md`.

## 2026-10-13 Codex uygulama notu - S-443 MAGIC bitwise coverage

Overloaded `MAGIC AND`, `MAGIC OR` ve `MAGIC XOR` ifadeleri primitive opkod
degil canonical `CALL` olarak lower edilir. ADIM25 `BINARY` beklenen opcode
ailesine `CALL` eklendi; primitive opkod delilleri korunuyor. Iki fixture,
AST/MIR/MIR-x64/JS yuzeylerinde toplam **8/8 PASS**. `MAGIC CALL/GET/SET`
bu karar tarafindan kapanmis sayilmaz. Ayrinti:
`docs/tasarim/UXB_S443_MAGIC_BITWISE_OPERATOR_MIR_COVERAGE_20261013_TR.md`.

## 2026-10-13 Codex uygulama notu - S-444 JS uncaught exception

S-444 için bağlayıcı sınır: üst düzey yakalanmayan `THROW` ve başarısız
`ASSERT` tüm üretim kuralları gereği JS'te sessiz başarı olamaz. JS `RET`
üreticisi ortak MIR exception durumunu denetleyip `Error` fırlatacak şekilde
güncellendi. İki fixture JS/Node'da **4/4 PASS** verdi.

Kullanıcı yordamı async `await` çağrısından çıkan hatanın çağıranın
`TRY/CATCH`'ine aktarılması ayrıca planlanacaktır; bu kayıt tam JS exception
parity'si iddiası taşımaz.

## 2026-10-13 Codex uygulama notu - S-445 DLL argüman tip listesi

Typed `CALL(DLL)` metadata konumunda bilinmeyen tek öğeli argüman tipi, gerçek
çalışma zamanı STRING argümanı gibi ABI'ye sızamaz. Ortak parser tanısı
`UXB_FFI_ARGUMENT_TYPE_LIST` olarak bağlandı; x64 planlayıcısında da bağımsız
savunma kapısı bulunuyor. Beş hedef yüzeyli negatif test **5/5 PASS** verdi.
Geçerli tip listelerinin ABI davranışı mevcut FFI testleriyle korunur.

## 2026-10-13 Codex — S-446 F32 parity kararı

F32 saklama sınırı ve yedi anlamlı hane metin çıktısı AST, canonical MIR,
MIR-x64 ve JS yollarında aynıdır. F32 aritmetik sonucu MIR `resultType` ile
korunur; JS `Math.fround`/`ux.formatF32` kullanır. Kabul kanıtı
`run_s446_f32_tests.ps1`: **4/4 PASS**; çıktı
`1.677722e+07 | 1 | 0.1 | 1.25`. WASM aynı karara dahil edilecek ayrı test
halkasıdır ve bu kayıtta kapanmış sayılmaz.

## 2026-10-13 Codex — S-480 geri bağlama kararı

S-480'de eski çalışma zamanı davranışı geri bağlandı, fakat kapasite ve hata
bildirimi sessiz taşma bırakmayacak şekilde açık kurala bağlandı: AST dizi
indisleri başarısızlıkta başarı gibi kullanılamaz, çok boyutlu diziler ortak
düz indis hesabına iner, `I32` ondalığı sıfıra doğru keser, `CONTINUE` eşleşen
döngüde gövde sonrasına gider, 1024 sıradan değişken kapasitesi aşılırsa
canonical çalışma zamanı tanısı verilir ve DLL PTR/I64/U64 temsilleri ABI'ye
uygun biçimde geri geçirilebilir. Kanıt: S-480 **8/8**, array params
**63/63**, AST/MIR continue ve değişken/PTR probları. Tam külliyat ve WASM
paritesi bu kararla kapanmış sayılmaz.

## 2026-10-13 Codex — S-483 OOP sessiz davranış kapıları

Alan gizleme varsayılan olarak hatadır: türetilmiş sınıf aynı adlı taban alanı
veya özelliği yeniden bildiremez. Kurucu gövdesindeki `ME.Metot()` sanal çağrısı
da kurulmamış/yarı kurulmuş nesne üzerinde dispatch belirsizliği yaratmaması
için reddedilir; `ME.alan` erişimi serbesttir. Kanıt: iki yeni negatif vaka ile
OOP parity **122/122**. Parametreli taban kurucusu ve `SUPER(...)` lowering'i
henüz bu kararla uygulanmış sayılmaz; S-485/S-487 devam eder.

## 2026-10-13 Codex — S-485 ve S-497 uygulama kararları

`NEW Child()` için parametresiz taban kurucuları örtük olarak tabandan
türetilmişe doğru çağrılır. Parametreli taban kurucusu argümansız çağrılmaz;
çağrı sözleşmesi `SUPER(...)` lowering'i ile ayrıca tanımlanacaktır. Kanıt:
OOP parity 126/126 ve `constructor_inheritance_chain` dört OOP yüzeyinde
geçti; JS/Node da doğru sırayı verdi.

Parser, alan atamasında gömülü `=` ile en üst düzey `AND`/`OR`/`XOR` ağacını
yanlış ilişkilendiremez. Atama sağ tarafa kaldırılır ve `ASSIGN_STMT` olarak
korunur. S-497 koşucusu AST, MIR, MIR-x64, AST-x64, JS ve WAT/WASM artifact
yüzeylerinde 6/6 PASS verdi.

## 2026-10-13 Codex — S-504 karşılaştırma sonuç türü

Ondalık operandlar yalnız kıyaslama domain'ini belirler; `EQ/NE/LT/LE/GT/GE`
sonuçları her zaman canonical `BOOLEAN`'dır. Bu sözleşme, x64'te Boolean'ın
`-1/0` bit deseninin F64 slotuna yazılmasını engeller. Kanıt:
`run_s504_f64_compare_tests.ps1` dört yüzeyde 4/4 PASS.

## 2026-10-13 Codex — S-498/S-499 tanı ve provider kapıları

Çalışma anı AST/MIR hataları compiler'ın ortak tanı listesine eklenir ve hem
`all_diagnostics.json` hem `vscode_diagnostics.json` yazılır. Ayrı native/JS/WASM
süreçlerinin tanıları compiler dosyasına ait sayılmaz; bunlar hedef koşucusunun
kanalıdır. S-498 koşucusu **4/4 PASS** verdi.

Birinci sınıf kütüphane tipi manifestindeki `*_provider` alanları yalnız ABI
iddiasıdır. Her hedef için provider registry'si ve type capability kontrolü
zorunludur. `RATIONAL` için kayıtlı provider yalnız MIR olduğundan AST, native,
JS ve WAT/WASM hedefleri yanlış scalar lowering'e düşmeden
`UXB_LIBTYPE_PROVIDER_UNAVAILABLE` / `target_validation` ile reddedilir. S-499
koşucusu MIR başarı yolu ve yedi açık ret yolu dahil **8/8 PASS** verdi. Kapı,
otomatik yüklenen ama kaynakta kullanılmayan referans tipleri denetlemez; aksi
halde sıradan `F64` ve diğer ilkel programlar gereksiz yere bloke olur.

## 2026-10-13 Codex — S-505/S-506 kanonik sonuç ve dönüşüm kararı

Karşılaştırma sonuçları `BOOLEAN` olarak üretilir; fakat bu değere uygulanan
tekli `-` aritmetik `NEG` işlemidir ve sonucu `I64` olmalıdır. MIR modülünün
sonlandırma kapısı, semantik metadata sızıntısından bağımsız olarak
`BOOL/BOOLEAN` işaretli `NEG` sonuçlarını `I64`'e normalize eder. Böylece
MIR yorumlayıcı, MIR-x64 ve diğer tüketiciler aynı kanonik değeri kullanır.

AST çalışma zamanında FLOAT'tan `I8/I16/I64/U8/U16/U32/U64` dönüşümünün ortak
yardımcıları `Fix` kullanır; genişlik maskesi ve signed yorumu sonradan
uygulanır. Bu, FreeBASIC `CInt/CLngInt` yuvarlamasını dilin sıfıra doğru kesme
sözleşmesinden ayırır. Kanıt: S-505 **7/7**, S-506 **5/5**, seçili model turu
**20/20**.

## 2026-10-14 Codex — güncel uygulama kanıtı

S-502, S-503, S-508 ve S-509 kapanışları sonraki uygulama halkasına işlendi.
F32 dizi yükleri fiziksel F64 çalışma yuvasında mantıksal F32 türünü korur;
`FIX` artık builtin registry ve legacy AST-x64 dönüş yolu tarafından I32
olarak tanınır. Beş yüzeyli koşucular S-502/S-503/S-508 için **5/5 PASS**;
seçili merkezî model turu **27/27** ve **5/5 paket**; tam derleme başarılıdır.
S-509, S-503 ile ilişkili tarihsel bir MIR-x64 gerilemesiydi ve güncel
`isFloatWide` sözleşmesiyle kapatıldı. Sıradaki aktif kaynak işi S-219
ROL/ROR genişlik semantiğidir; kabul ölçütü bütün üretim yollarında aynı
sonuç veya aynı açık ret olacaktır.

## 2026-10-14 Codex — S-219 uygulama kararı ve kapanış

`ROL/ROR` genişliği hedef backend'e bırakılmayacak; canonical tür sonucu tüm
üretim yollarının bağlayıcı girdisi olacaktır. AST runtime, semantik MIR,
MIR-x64 yüzey emitter'ı, JS ve WAT aynı genişlik/signedness sözleşmesini
uygular. `ROL=`/`ROR=` de bu kapsamdadır. Kanıt koşucusu **6/6 PASS** verdi.
S-219 artık `YAPILDI-DOGRULANDI`; sonraki açık halka sorun listesindeki bir
sonraki kaynak düzeltmesidir.

## 2026-10-14 Codex — S-510/S-511/S-512 F32 değeri kanonikleştirme kararı

`F32`, çıktı biçimi değil saklama türüdür. Bildirim, açık dönüşüm, alan veya
dizi saklama sınırında IEEE tek duyarlık yuvarlaması yapılır; sonraki aritmetik
aynı yuvarlanmış değeri görür. Bu karar tüm gerçek üretim yollarının ortak
MIR sözleşmesine bağlandı.

- MIR interpreter: `UXBInterpApplyDeclaredType` F32 değerini `CSng` ile
  yuvarlar.
- Semantic MIR: `F32(...)` çıkarımı F32 arithmetic opcode seçimini korur.
- Legacy AST-x64: DIM initializer store gerçek `initFloatKind` ile seçilir;
  F32 `MOVSS`, F64 `MOVSD` kullanır.
- Kanıt: S-510 runner **5/5**, merkezi seçilmiş tur **46/46, 8/8**, build exit 0.

S-510, S-511 ve S-512 `YAPILDI-DOGRULANDI` kabul edilir. WAT/WASM F32
runtime yürütmesi bu halkadan ayrı açık görevdir. Tasarım belgesi:
`docs/tasarim/UXB_S510_S511_S512_F32_DEGER_PARITESI_20261014_TR.md`.

## 2026-10-14 Codex — S-459/S-460 örtük STRING-sayı dönüşümünü kapatma

`STRING`/`WSTRING` ile numeric operand aynı ikili ifadede örtükçe karışmaz.
Sayıya metin, metne sayı dönüşümü kaynakta açıkça `STR`/`VAL` ile yazılmalıdır.
Registry/provider tarafından çözülen birinci sınıf kütüphane operator'ü bu
genel primitive kuraldan önce gelir; çekirdek özel tip yığını büyütmez.

Canonical hata `UXB_MIXED_STRING_NUMERIC` hem terminal hem structured
diagnostics kaydında aynıdır. Kanıt **29/29 PASS**: AST, MIR, MIR-x64, AST-x64,
JS ve WAT negatifleri ile AST/MIR/native/JS pozitif açık dönüşüm yolu.
S-459 ve S-460 `YAPILDI-DOGRULANDI` kabul edilir. Tasarım belgesi:
`docs/tasarim/UXB_S459_S460_KARISIK_STRING_SAYI_TIP_KAPISI_20261014_TR.md`.

## 2026-10-14 — S-464 kararı: BOTH sonucu süreç kapısıdır

`--interpreter-backend BOTH` karşılaştırma raporu yalnız gözlem dosyası değildir;
AST ve MIR'in gözlenebilir program çıktısı eşleşmiyorsa çalıştırma başarılı
kabul edilmez. Satır sonları normalize edilir, wrapper metadata'sı
(`result_type`, `return_value`) tek başına mismatch sayılmaz. Gerçek ayrışma
`UXB_INTERPRETER_COMPARE_MISMATCH` ile ortak tanı sözleşmesine, layer event'e,
structured diagnostics'e ve çıkış 25'e yazılır. S-464 kanıtı 3/3 PASS'tir;
güncel pozitif külliyatta eşzamanlı gerçek mismatch fixture bulunmamaktadır.

## 2026-10-14 — S-500 kararı: provider tanısı da ABI sözleşmesidir

Birinci sınıf kütüphane tipi provider sözleşmesi yalnız provider adını ve çağrı
ABI'sini değil, hedef kapısı ve çalışma zamanı hatalarının structured tanı
alanlarını da kapsar. `MISSING`, `TYPE_MISMATCH` ve `UNAVAILABLE` aynı
`library_type` alan ailesinde, doğru aşama ve iki dilli mesaj/ayrıntı/hint ile
üretilir. Kanıt **2/2 PASS**. S-501'in gerçek Türkçe harf politikası ayrı karar
olarak açık kalır.

## 2026-10-14 — S-134 B3 bağlayıcı lifecycle lowering kararı

Birinci sınıf kütüphane tipi için implicit sahiplik aktarımı canonical MIR'de
manifest `copy_model` değerinden türetilir: `clone -> TYPE.CLONE`,
`retain -> TYPE.RETAIN`. `TYPE.COPY` yalnızca kaynakta açıkça çağrılan
provider hook'udur.

Managed scalar local ve BYVAL parametreler lifetime sınırında `TYPE.DROP` alır.
Temizleme ters bildirim sırasındadır. BYREF parametre caller storage alias'ıdır;
callee DROP üretmez. Explicit DROP sonrası tekrar gelen cleanup provider
değeri boşalttığı için güvenli no-op olmalıdır.

Bu kararın uygulama kanıtı: `build_64.ps1 -Force` exit 0 ve library type
koşucusu **43/43 PASS**. JSON MIR kontrolleri `CLONE`, `RETAIN`, `DROP` ve
exception propagation sentetik RET yolunu doğrudan doğrular. Tasarım belgesi:
`docs/tasarim/UXB_S134_B3_LIFECYCLE_LOWERING_20261014_TR.md`.

Takip işi B4'tür: provider ABI kaydı manifest provider adını gerçek target
registry, sürüm, paket, capability ve lifecycle operation tablosuyla
eşleştirecek. Native/JS/WASM runtime provider'i bulunmayan hedefte başarı
değil, hedef-adlı structured red bağlayıcıdır.

## 2026-10-14 — B4.1 provider operation ABI kararı

Provider ABI'nin minimum bağlayıcı sırası: hedef/provider kaydı, statik tip
eşleşmesi ve operation eşleşmesidir. Provider adı kayıtlı diye manifestin
ilan ettiği her `TYPE.OPERATION` çalışıyor kabul edilmeyecek. MIR provider
dispatch'inden önce operation registry kontrolü yapılacak; yoksa
`UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE` canonical kodu, `library_type`
katmanı, `provider_call` aşaması ve iki dilli structured ayrıntıyla verilecek.

B4.1 uygulama kanıtı: `RATIONAL.CMP` negatif fikstürü; library suite
**44/44**, S-500 tanı koşucusu **3/3**. B4.2 görevi manifest sürüm/
dependency/capability alanlarını target provider registry ile bağlamaktır.
Gerçek native/JS/WASM provider parity'si ancak bu metadata kapısı ve runtime
oracle'i kapandıktan sonra kabul edilecektir.

## 2026-10-14 — B4.2 capability metadata kararı

Manifest `capabilities` alani doluysa hedef provider ABI'sinin zorunlu
iddiasidir. MIR hedefi icin `MIR_PROVIDER` token'i bulunacak ve registry bunu
secilen provider icin tanıyacak; aksi halde `UXB_LIBTYPE_PROVIDER_UNAVAILABLE`
ile ortak hedef reddi verilecek. Capability alani boş olan eski manifestler
geriye uyumlu kalacak.

Kanıt: capability eksik negatif manifestiyle library **45/45**, S-499 **8/8**,
S-500 **3/3**. B4.3 version/dependency solver'i ve B5 gerçek hedef provider
runtime parity'si bu kararın sonraki görevleridir.

## 2026-10-14 — Genel veri tipi ve birinci sinif kutuphane tipi tasarim karari

Yeni baglayici tasarim belgesi:
`docs/tasarim/UXB_GENEL_VERI_TIPI_VERI_YAPISI_VE_BIRINCI_SINIF_KUTUPHANE_TIPI_SISTEMI_20261014_TR.md`.

Karar: primitive, TYPE/STRUCT/UNION, CLASS/INTERFACE, ARRAY, collection,
handle, TASK ve library tipleri ortak TypeDescriptor + StorageDescriptor +
ownership/lifecycle + operation/conversion + ABI/provider sozlesmesinden
gececek. Semantic type identity ile native/JS/WASM fiziksel storage'i
ayrilacak. `PTR` raw byte pointer olarak kalacak; typed pointer/MemRef ayri
provenance ve bounds metadata tasiyacak. `RATIONAL`, `COMPLEX`, `MATRIX`,
`TENSOR`, `POLYNOMIAL` gibi tipler cekirdege ozel TypeKind yiginina
eklenmeyecek; provider ve canonical MIR operation olarak eklenecek.

Mevcut parser/AST ve MIR opcode'lari additive adapter ile korunacak. Tasarim
geregi tum degerler zorunlu 16-byte descriptor'a cevrilmeyecek; POD direct,
managed/opaque tipler descriptor veya handle kullanacak. `STRING` canonical
UTF-8, `LEN` code point, `BYTELEN` byte sayisi olacak; WSTRING ayri wide-text
ABI'si olarak kalacak. Managed raw MEMCOPY yasak; clone/retain/move/drop
descriptor-driven olacak. Alti hedefte feature destegi veya ayni canonical
diagnostic zorunlu.

Durum: belge hazir, kod uygulamasi baslamadi. Siradaki uygulama gorevi
TypeDescriptor v2 + StorageDescriptor metadata'sini mevcut type registry,
layout ve MIR modeline additive baglamak; sonra string descriptor/WASM POD
linear-memory ve provider parity halkalarina gecmektir. B4.3 version/dependency
solver, B5 gercek native/JS/WASM provider parity'si ve TASK OF T hala aciktir.


## 2026-10-14 Mete kararı — eski AST-x64 dondurulmaz
Eski AST-x64 (`bld --build-x64 --x64-mode AST`) dondurulmayacak; tüm motorlar gibi aynı dil davranışını verecek şekilde çalışacak ("açık ret" kalıcı çözüm değil, ara durumdur). Önceki bekleyen soru: S-157-L. Uygulama sahibi: Codex (kaynak), doğrulama: Claude (değer düzeyinde, altı yolda). Ayrıntı: `ai_koordinasyon/DURUM.md` 2026-10-14 17:04.

## 2026-10-15 Mete kararları — temizlik, yayın ve tasarım istekleri
Kaynak: Mete'nin sohbet mesajı (2026-10-15). Uygulama ve kanıt: `ai_koordinasyon/DURUM.md` 2026-10-15 14:46, `TEMIZLIK_GUNLUGU_20261015.md`, `DOSYA_ENVANTERI_VE_TEMIZLIK_ONERISI_20261014.md` bölüm 11, `TASARIM_SORULARI_CEVAPLAR_20261015.md`.

**Verilen kararlar.**
1. 14 Ekim envanterindeki öneriler aynen uygulanır; **zip dosyaları silinmez**, "sor" satırları kalır, "temizle" kararı olanlar kaldırılır. Uygulandı (≈ 35,5 GB).
2. Kaynak, kütüphaneler, **tasarım belgeleri ve tüm dokümantasyon** GitHub'a gönderilir. Bu, 14 Ekim önerisindeki "tasarım belgeleri özel kalsın" maddesini ve `.gitignore`'daki `/ai_koordinasyon/`, `/docs/tasarim/`, `/spec/` dışlamalarını geçersiz kılar. Uygulandı: `yayin/20261015` dalı.
3. Claude, Codex ve ChatGPT konuşma/hafıza dosyaları da gönderilir; dosya başına GitHub sınırı 100 MB. Uygulandı (`konusma_arsivi/`; gizli anahtarlar yayın kopyalarında silindi).
4. **OOP çok güçlü olacak**: uXBasic nesne yönelimli paradigmayla doğdu; çoklu kalıtım, çoklu miras ve karışım (`MIXIN`) dahil zengin bir nesne sistemi hedeflenir. 15 Eylül önerisindeki "çoklu durum kalıtımı yoktur" maddesi geçersizdir. Seçenek A/B/C kararı bekliyor (S-555).
5. `SUB` ve `FUNCTION` önden `DECLARE` ile bildirilmelidir (S-544; sıkı kural mı, uyarı mı: bekliyor).
6. İstenen yeni özellikler ◇ HEDEF ve ayrı kayıt olarak girdi: dosya kanalı için değişken/`TYPE` tutamacı (S-548, S-549), Python tarzı `{}`/`[]`/`()` veri sabitleri ve `LIST`/`DICT`/`SET`/`TUPLE`/`DATAFRAME` (S-551, S-552), `DATA`/`READ`/`RESTORE` (S-550), `NONE`/`NODE`/`NAN` tipleri (S-553, S-554, S-564).

**Bekleyen kararlar (Mete).** S-544 (öneri: sıkı kural), S-555 (öneri: seçenek C), S-554/S-564 (öneri: `NONE`/`NODE` eklenmesin, `NULL`/`NOTHING` çalışsın), S-549 ve S-551 tasarım onayı, eski `DATA`/`READ`/`RESTORE` kaynağının yeri, konuşma kayıtlarında görünen hizmet anahtarlarının yenilenmesi, `yayin/20261015` dalının `main`'e birleştirilmesi, DLL paketlerinin GitHub Release olarak yüklenmesi (önce üçüncü taraf lisans kontrolü).

**Görev sahipleri.** Kaynak düzeltmeleri: Codex. Altı yolda değer düzeyinde doğrulama ve kitabın yeniden üretimi: Claude. Yerel `main` (07550bb) gerçek e-postalı bir commit taşır ve olduğu gibi gönderilmemelidir; yayın `yayin/20261015` dalındadır.
