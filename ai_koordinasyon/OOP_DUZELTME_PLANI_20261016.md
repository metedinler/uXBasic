# OOP düzeltme planı (2026-10-16)

**Yazan:** Claude · **İsteyen:** Mete (2026-10-16: «ekteki yeni belgelere göre incelemelerini, analizlerini yap. Hedeflenen sistem tasarım ve kullanma kılavuzuna işle. Ardından bu belgeyi oluştururken bulduğun sorunları bir plan yaparak çözmeye başla.») · **Durum:** yürürlükte; bölüm 4 her tur güncellenir.

## 1. Girdiler ve yöntem

* İki yeni belge: `docs/tasarim/UXB OPP SISTEMI TASARIM VE TARTISMALARI.md` (Mete'nin OOP tasarım konuşması: çoklu kalıtım, `THIS`/`ME`/`SUPER[Taban]`, `MIXIN`, motorlara indirgeme, eksik ve deneysel özellikler) ve `docs/tasarim/uXBasic_OOP_Tam_Sistem_Denetimi_2026-10-16.md` (kaynak denetimi, K-01 … K-12, P0 … P3 iş sırası).
* **Her iddia gerçek derleyicide denendi** (`bin\uxb_kilavuz_20261014_0253.exe`, kaynakta o günden beri değişiklik yoktu; altı yol: AST, MIR, MIR-x64, eski AST-x64, JS, WAT/WASM). 170 küçük program (140 keşif + 30 düzeltme turu vakası): `tools/kitap/kilavuz_v2/yoklama/iddia_oop_20261016/` (açıklamasıyla), ham sonuçlar (düzeltme öncesi ve sonrası) `docs/kitaplar/_ortak/oop_partisi_20261016/`.
* Bulunan her kusur ayrı S-kaydı oldu (S-570 … S-599; ayrıca eski kayıtlara güncelleme notu). Düzeltme yapılan her kayıt, kabul testi `tests/oop_parity` içine eklenerek kapatıldı.
* Kural (Mete): testi gevşetmek çözüm değildir; altı yol aynı davranır; eski AST-x64 dondurulmaz; her kayıt kökünden çözülür.

## 2. Denetim bulgularının doğrulanması

| Bulgu | Denetimin iddiası | Gerçek yürütme sonucu (`0253`) | Kayıt |
|---|---|---|---|
| K-01 MIR `DELETE_OBJECT` yalnız kayıt | `active` sıfırlanmıyor | ✔ doğru, ama asıl durum daha derin: **lowering `MIR_DELETE_OBJECT`'i hiç üretmiyor** (`DELETE` = statik yıkıcı zinciri + `değişken = 0`) ve **boş başvuru (`0`) yığın yuvası 0'a, yani programın ilk nesnesine düşüyor**: boş değişkenden okuma başka nesnenin alanını verir, yazma onu bozar (yeni bulgu, sessiz bozulma) | S-570 (düzeltildi), S-431, S-574 |
| K-02 JS silinmiş nesne erişilebilir | `fieldLoad/fieldStore` canlılık denetlemiyor | ✔ doğru (`DELETE` sonrası okuma `undefined`); ayrıca `DELETE` hiç `ux.objectDelete` çağırmadığından `__uxbDeleted` hiç ayarlanmıyor | S-573 (düzeltildi), S-574 |
| K-03 `THIS`/`ME` ayrımı yok | MIR ikisini de sanal seçiyor | ✔ doğru ve daha kötüsü: **AST ikisini de doğrudan**, MIR/x64/JS/eski AST-x64 ikisini de sanal çağırır (`1010` ↔ `2020`; üç seviyede `100` ↔ `300`); tasarım `1020` | S-484 |
| K-04 sınıf metodunda aşırı yükleme yok | aynı ad üye reddi | ✔ doğru: `CLASS: duplicate member name: F`, altı yolda aynı açık ret | S-382, S-560 |
| K-05 WASM nesne modeli ayrı rejim | eksik özellikler açıkça reddediliyor | ◐ yarı doğru: metin ve ondalık **açıkça reddedilir**; ama nesne alanları **sessizce `0`** idi (`G-WASM-1`). Kök neden bulundu: üç yerde yanlış operand tabanı. **Düzeltildi** | S-575 (düzeltildi), S-250 |
| K-06 `MemoryRef` eksik izliyor | — | ✔ ölçüldü: 4096 canlı bölgeden sonra koruma **sessizce kapanır** (4200 dizide bayat işaretçi `11` okur, çıkış 0) | S-582 |
| K-07 parametreli taban kurucusu | `SUPER(...)` yok, otomatik çalışmıyor | ✔ doğru: beş ayrı davranış; `SUPER(5)` WASM ve eski AST-x64'te **sessizce yok sayılır** | S-485, S-487 |
| K-08 `UXClazz` profilleri yalnız üstveri | `CLAZZ ACTOR` → düz `CLASS` | ✔ (araç incelemesi; kaynakta da `ACTOR` yalnız metadata) | G-ARAC-3, S-591 |
| K-09 `MIXIN`/`DECORATOR` tek taban | en çok bir `MIXIN` | ✔ doğru: tek `MIXIN` çalışır; iki karışım ve `EXTENDS` ile birlikte açık ret | S-594 |
| K-10 JS kurucu argümanları / hata temizliği | tüm kurucular aynı argüman parçalarını alıyor | ✔ doğru ve ayrıca **metot argümanları JS'te tümden düşüyordu** (yeni bulgu) | S-571 (düzeltildi), S-485 |
| K-11 imza zenginleştirilmeli | — | statik; yöntem imzası kimliği ve sınıf aşırı yüklemesi planı P0.4'te | S-382 |
| K-12 yığıt ölçeklemesi | `ReDim Preserve` her ayırmada | ✔ ölçüldü: MIR'de 64 000 nesne 60 sn (aşırı doğrusal), AST doğrusal | S-583 |
| Denetim notu «`tests/oop_parity` yok» | paketlerde yok | bizde var: **126/126** geçiyor (`0253`); ama boş başvuru testleri hiç nesne yaratmadığından S-570'i yakalamıyordu | — |

**Tasarım konuşmasındaki örneklerin durumu (altı yol):** `Nokta`, `BankaHesabi` (F64), `Sekil/Kare/IYazdirilabilir` (F64), `Vektor2D` (`MAGIC ADD` ve `TOSTRING`) örneklerinin birebir hâli derlenmez ya da yanlış çalışır; nedenleri ayrı kayıtlar: `NOTHING` yok (S-564), `DIM x AS Sınıf = ifade` yalnız `NEW` kabul eder (S-584), Türkçe harfli tanımlayıcı (S-579), `PROPERTY` blok biçimi (G-HEDEF-3), x64 F64 alan aritmetiği (S-580), eski AST-x64 F64 kurucu (S-581). Ayrıntı: kitap 11.13.

## 3. İş paketleri ve sıra

Sıra denetimin P0 … P3 yapısına uyar; her paketin kabul ölçütü «altı yolda aynı çıktı + olumsuz tanı testi».

| Paket | İş | Kayıtlar | Durum |
|---|---|---|---|
| **F1** | Hızlı, yerel, yüksek etkili düzeltmeler (bu tur, dört dalga) | S-570 … S-573, S-575, S-577, S-580 … S-584, S-586, S-596 … S-599 | **YAPILDI** (bölüm 4) |
| **P0.1** | Nesne yaşam döngüsü: `MIR_OBJECT_DESTROY`, canlılık bayrağı, gerçek türe göre yıkıcı, boş/ölü hedefe `DELETE` etkisiz, `DELETE` → `NOTHING` | S-574, S-431, S-472, S-473, S-486, S-564 | sıradaki |
| **P0.2** | Taban kurucu: `SUPER(...)`, parametreli tabanda zorunluluk, kısmi kurulumda ters temizlik | S-485, S-487, S-483 | parametresiz zincir altı yolda çalışır (MIR'in kurucusuz türetilmiş sınıf kusuru **YAPILDI**); `SUPER(...)` ve parametreli taban açık: tasarım hazır (`UXB_S485_OOP_BASE_CONSTRUCTOR_CHAIN_20261013_TR.md`), uygulama sırada |
| **P0.3** | `THIS` doğrudan / `ME` sanal / niteliksiz sanal; kurucu ve yıkıcı kuralı | S-484, S-576, S-596 | **YAPILDI** (F1 dördüncü dalga, 2026-10-17); anlam Mete'nin kendi tasarım belgesindedir |
| **P0.4** | Yöntem imza kimliği, sınıf aşırı yüklemesi, kurucu aşırı yüklemesi | S-382, S-560 | tasarım |
| **P0.5** | `MemoryRef` dolunca açık ret, nesil; yığıt büyüme | S-582, S-583 | **YAPILDI** (F1 üçüncü dalga); nesil denetimli tutamaç P0.1 ile |
| **P0.6** | Native hatalar: x64 F64 iki alan, eski AST-x64 F64 kurucu | S-580, S-581, S-234 | **YAPILDI** (F1 ikinci dalga) |
| **P0.7** | Arayüzler: `IMPLEMENTS` denetimi, eski AST-x64 arayüz parametresi | S-577, S-578 | `IMPLEMENTS` denetimi **YAPILDI**; eski AST-x64 (S-578) ve MIR'de türemiş sınıf (S-336) açık |
| **P0.8** | WASM `ME`/`SUPER`, nesne modeli (doğrusal bellek ABI'si ya da açık host sınırı) | S-586, K-05 | `ME`/`SUPER` **YAPILDI**; doğrusal bellek ABI kararı açık |
| **P1** | Sıkı `DECLARE` (S-544), `NULL`/`NOTHING` (S-564), Türkçe tanımlayıcı (S-579), `FILE_HANDLE`/`FREEFILE`, veri sabitleri, `DATA/READ/RESTORE` (`DIM x = ifade`, S-584: **YAPILDI**) | S-544, S-564, S-579, S-548 … S-551 | tasarımlar hazır |
| **P2** | `IS`/`AS`, desen eşleme, `USING` kaynak kapsamı, jenerik sınıf | S-587, S-588, S-589, G-HEDEF-4 | tasarım |
| **P3** | Çoklu kalıtım (B) ve çakışma anahtar sözcükleri: M0 … M3 | S-555, S-595, S-594 | tasarım belgesi: `UXB_S555_COKLU_KALITIM_B_VE_CAKISMA_DENETIMI_20261016_TR.md` |
| **P4** | Deneysel: yapısal arayüz, `ACTOR CLASS`, `DATA_PARALLEL`, `OWNED/BORROWED` | S-590 … S-593 | Mete kararı bekler |
| **K** | Kılavuzun yeni ikiliyle yeniden ölçümü (197 örnek × altı yol + iddia vakaları) | — | F1 ve P0.1'den sonra |

## 4. Bu turda yapılanlar (F1)

Kendi ikililerim: `tools\claude\uxb_build.ps1 -Name oop1016` … `oop1024` → `bin\uxb_oop1016.exe` … `bin\uxb_oop1024.exe` (her derleme 1,4-2,4 dk; **nihai ikili `bin\uxb_oop1024.exe`**). Ana derleyici `bin\uxb.exe` ve ölçüm ikilisi `bin\uxb_kilavuz_20261014_0253.exe` değişmedi.

| Kayıt | Dosya | Değişiklik |
|---|---|---|
| S-570 | `src/interpreter/mir/mir_interp_array_object.fbs`, `src/interpreter/common/interp_value.fbs` | Boş başvuru `OBJECT` kimliği `-1`; `FIELD_LOAD/STORE` canlılık sınaması |
| S-571 | `src/codegen/js/js_stmt_emit.fbs` | Metot/sanal/statik çağrı argümanları `[...]` içinde |
| S-572 | `src/parser/parser/parser_stmt_registry.fbs`, `src/semantic/semantic_pass.fbs` | `ABSTRACT/FINAL/SEALED CLASS` dağıtımı; soyut türlü `DIM` reddi kaldırıldı |
| S-573 | `runtime/js/common/ux_runtime_core.js` (+ üretilen `js_runtime_embedded_generated.fbs`) | `fieldLoad` boş hedefte hata; ortak iletiler |
| S-575 | `src/codegen/wasm/wasm_emitter.fbs` | `OBJECT_NEW`, `FIELD_STORE`, sanal çağrı için doğru operand tabanı |
| S-580 | `src/semantic/mir.fbs` | `MIRInferExprFloatKind`e `FIELD_EXPR`: alanın bildirilen türü kayan noktaysa `FADD/FMUL…` seçilir |
| S-581 | `src/codegen/x64/helpers/x64_codegen_runtime_emit_helpers.fbs` | eski AST-x64 `NEW`: F32/F64 kurucu argümanları xmm yazmacına |
| S-584 | `src/semantic/semantic_pass.fbs`, `src/runtime/memory_exec.fbs` | `DIM x AS Sinif = ifade`: yalnız-`NEW` kuralı kaldırıldı; AST çalışma sınıfı nesne başlığından |
| S-586 | `src/codegen/wasm/wasm_instr_emit.fbs` | WASM'da `ME` ve `SUPER` alıcıyı (`THIS`) gösterir |
| S-577 | `src/semantic/semantic_step3_gate.fbs` | `IMPLEMENTS` yazmamış sınıf arayüz parametresine verilemez (`Step3ValidateInterfaceArguments`) |
| S-582 | `src/common/memory_ref.fbs` | `MemoryRef` tablosu 4096 → 65536 büyür; dolarsa bilinmeyen NATIVE adres reddedilir |
| S-583 | `src/interpreter/common/interp_heap.fbs` | yığıt yuva tablosu ikiye katlanır (her ayırmada tam kopya yok) |
| S-484 | `src/semantic/semantic_implicit_this.fbs`, `src/semantic/mir_lower_expr.fbs`, `src/codegen/x64/code_generator.fbs`, `src/runtime/exec/exec_call_dispatch_helpers.fbs` | niteliksiz metot çağrısı `ME.m()` olur; MIR üretimi `THIS` alıcısında sanal yuvaya bakmaz; eski AST-x64 `THIS`'te sanal yuva aramaz (`methodVirtualSlot = -2`); AST alıcı çözümleyici gerçek sınıfı nesne başlığından okur, `THIS` doğrudan bağlanır |
| S-576 | `src/semantic/semantic_pass.fbs` | kurucu ve yıkıcıda yalnız **sanal** hedefe giden `ME`/niteliksiz çağrı reddedilir (`SemFindCtorDtorVirtualMeCall`); `THIS.m()` ve sanal olmayan çağrı serbest |
| S-485 (kısmen) | `src/interpreter/mir/mir_interp.fbs` | `UXBMIRInterpExecObjectNewWithCtor`: türetilmiş sınıfın kendi kurucusu yoksa taban kurucularını yine çalıştırır |
| S-596 | `src/runtime/exec/exec_call_dispatch_helpers.fbs` | AST: sanal dağıtım nesne başlığındaki gerçek sınıfa, sanal olmayan bağlama bildirilen sınıfa göre (SUB parametresi, takma ad, `ME`) |
| S-597 | `src/runtime/exec/exec_call_dispatch_helpers.fbs`, `src/runtime/exec/exec_task_handle.fbs`, `src/semantic/mir_tail.fbs`, `src/codegen/x64/code_generator.fbs` | boş gövdeli rutin: `And` → `AndAlso` (AST çökmesi); MIR ve eski AST-x64 boş rutini üretir |
| S-598 | `runtime/js/common/ux_runtime_core.js` (+ üretilen kopya), `src/codegen/js/js_stmt_emit.fbs` | JS: `fieldLoad(nesne, ad, varsayılan)`; hiç yazılmamış alan türün sıfırını okur |
| S-599 | `src/semantic/mir_tail.fbs`, `src/codegen/x64/code_generator.fbs` | `FUNCTION`/`METHOD` sonuç değişkeni girişte türün sıfırıyla başlar (MIR); eski AST-x64 işlev adını taşıyan çerçeve yuvası, gövde sonuna düşünce `rax`/`xmm0` yüklemesi |
| test | `tests/oop_parity` (+31 program: ilk üç dalgada 16, dördüncüde 15; JS/WASM'ı isteğe bağlı motor yapan koşucu) | `null_*`, `delete_then_read_after_alloc`, `class_flag_*`, `method_args*`, `field_ctor_args`, `f64_field_arith`, `f64_ctor_param`, `dim_init_expr`, `neg_dim_init_type_mismatch`, `neg_interface_arg_no_implements`, `interface_arg_ok`, `interface_arg_derived`; dördüncü dalga: `this_direct_me_virtual`, `this_me_three_levels`, `bare_virtual_template`, `param_receiver_virtual`, `ctor_helper_this_me_bare`, `ctor_this_virtual_direct`, `neg_ctor_bare_virtual`, `neg_dtor_bare_virtual`, `ctor_chain_derived_without_ctor`, `empty_routine_bodies`, `field_default_zero`, `function_result_zero`, `float_function_result`, `private_bare_call`, `protected_bare_call`; `this_me_calls`, `super_call`, `super_assigned` artık JS ve WASM'da da koşar |

**Doğrulama:** sonuçlar bölüm 6'da.

## 5. Sonraki adımlar (sıra ve yöntem)

1. **P0.1 yaşam döngüsü** (en riskli, en etkili): (a) `MIR_OBJECT_DESTROY` adlı yeni bir MIR işlemi: işlenen nesne; boş ya da ölü ise etkisiz; değilse gerçek sınıfın yıkıcı zincirini (türetilmişten tabana) çağırır ve nesneyi ölü işaretler. Gerçek sınıfa göre çağrı için her sınıfa gizli bir sanal `__DESTROY` yuvası **üretilir** (kendi yıkıcı gövdesini çalıştırıp tabanın `__DESTROY`'unu doğrudan çağırır); `DELETE` bu yuvaya sanal çağrıdır, ardından ölü işareti ve değişken `NOTHING`. Böylece x64, JS, WASM ve her iki yorumlayıcı mevcut sanal çağrı düzeneğini kullanır; yeni çalışma zamanı işlemi yalnız «ölü işaretle» olur. (b) Ölü işareti: MIR yuva `active`, JS `__uxbDeleted`, WASM host nesne tablosu silinir, x64 nesne başlığında sürüm sözcüğü (`free` sonrası yeniden kullanım `MemoryRef` ile uyumlu). (c) Kabul: `delete_double`, `delete_alias`, `delete_base_typed`, `delete_null`, `delete_order` testleri altı yolda aynı.
2. ~~**P0.3 `THIS`/`ME`**~~ **YAPILDI** (2026-10-17): sonuç bölüm 4 ve 6.
3. **P0.2** tasarım belgesindeki kurucu planı: `SUPER(...)`, parametreli tabanda zorunluluk (`UXB_BASE_CTOR_REQUIRED`), AST ve eski AST-x64'te türetilmiş sınıfa verilen argümanın tabana iletilmesi (ölçüm: `p09` AST ve eski AST-x64 `0`, öbürleri `7`).
4. **P0.5/P0.6** ölçüm ve kök neden araştırması.
5. **K** yeni ikiliyle kılavuzun yeniden ölçümü (referans ikili değişir, kitapta «düzeltildi» notları kalkar).

## 6. Doğrulama kaydı

Bütün sayılar `bin\uxb_oop1024.exe` ile (aksi yazılmadıkça), altı yol:

| Denetim | Sonuç |
|---|---|
| `tests/oop_parity` | **309/309** kontrol geçti (221 önceki + 88 yeni; 64 test programı); önceki ikili `oop1020` 221/221 |
| Tam model paketleri, birinci tur ikilisi `oop1016` | **1657/1662** kontrol, 42/46 paket temiz. Taban `0253`: 1605/1610; fark tam olarak eklenen 52 OOP kontrolü; düşen beş kontrol tabandakilerle birebir aynı (`stable_cells_byref_pointer` AST, `ffi_empty_string_is_real` AST, `namespace_shared_vars` AST, bayat `neg_gosub_refused` WASM ve JS) |
| Tam model paketleri, nihai ikili `oop1024` | (koşu sürerken eklenir: aşağıdaki «Güncelleme» satırı) |
| Yoklama vakaları (170) | 140 vaka eski ve yeni ikiliyle karşılaştırıldı: 210 vaka×motor farkı, **hepsi beklenen iyileşme, gerileme yok**; yeni ikilide hâlâ ayrışan 57 vakanın çoğu WASM'ın bilinen ondalık/metin reddidir, gerçek ayrışmalar P0.1 / P0.2 / eski AST-x64 işleridir (`oop1_5_kalan_ayrisma_oop1024.txt`) |
| Külliyat anlamsal denetimi (`sem`) | 565 dosya (413 sınıflı/arayüzlü + 152 örnek) eski (`0253`) ve yeni ikiliyle karşılaştırıldı: **eskiden kabul edilip yeni reddedilen mevcut program yok** (3 reddedilen dosya benim yeni olumsuz testlerim) |
| Nesne ayırma hızı (S-583, boşta makine) | MIR 64 000 nesne 50,6 sn → 33,8 sn; nesne başına süre sabit (≈ 0,53 ms); AST aynı |
| Kitap | `uret.py --sert` çıkış 0 (26 bölüm, 16 561 satır, 197/197 örnek), `tablo_denetle.py` 0 sorunlu satır |

**Çalışma ortamı dersleri:** (1) `uxb` her koşuda **çalışma dizinine** `build/<tarih>/` klasörü yazar; çok dosyalı toplu koşuda çalışma dizini olarak dosyanın klasörünü seçmek 1000 klasör / 546 MB artık bıraktı (karantinaya taşındı, silinmedi). (2) FreeBASIC'te `And` kısa devre yapmaz; `x <> -1 And dizi(x)…` kalıbı `AndAlso` olmalıdır. (3) İki `oop_parity` koşucusu aynı anda çalıştırılmaz. (4) Yoklama programlarında sınıf ve değişken adı farklı olmalıdır (`DIM a AS A` reddedilir).

## 7. Karar gerektirenler (varsayılanlar uygulanır)

| No | Soru | Uygulanan varsayılan |
|---|---|---|
| Q1 | `THIS` doğrudan, `ME` sanal (belgelerde 15.09'dan beri) | **Uygulandı** (P0.3, 2026-10-17): anlam Mete'nin kendi tasarım belgesinde yazılı (`UXB OPP SISTEMI TASARIM VE TARTISMALARI.md` satır 110-113 ve 422-427). Mevcut programlarda `THIS.sanalMetot()` artık doğrudan çağırır; külliyat denetiminde yeni reddedilen program çıkmadı |
| Q2 | Tanımsız `DECLARE` derleme hatası | Önerim hata (sıkı DECLARE kararı S-544 ile tutarlı); Mete'nin yapıştırdığı analiz de evet diyor |
| Q3 | `DELETE x` sonrası `x = NOTHING` | Evet (Mete'nin tasarım belgesi); `NOTHING` gelince (S-564) |
| Q4 | Yapısal arayüz | Hayır (nominal kalsın) |
| Q5 | Türkçe harfli tanımlayıcı | Önerim evet (karar Mete'nin) |
| Q6 | Yaşam döngüsünde gizli sanal `__DESTROY` | Evet |
