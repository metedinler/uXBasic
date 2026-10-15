# uXBasic açık işler — ortak tasarım ve uygulama planı

Tarih: 2026-09-15

Durum: Tasarım/planlama önerisi v1. Bu belge, `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` ile aynı disiplinle yazılmıştır (aynı biçim, aynı kabul-kanıtı standardı) ama OOP dışındaki tüm açık teknik borç kalemlerini kapsar. OOP konusunda karar sahibi ve güncel belge o dosyadır; burada tekrar edilmez, yalnız referans verilir. Bu belge de kod değiştirmez — 2026-09-06'dan 2026-09-15'e kadarki tüm konuşma geçmişinin (bkz. transkript denetimi) ve `ai_koordinasyon/SORUN_TAKIP.md`'nin güncel taranmasının ürünüdür.

## 1. Amaç ve ilkeler

Amaç: dokuz günlük çalışmada bulunmuş, bir kısmı numaralandırılmış bir kısmı numaralandırılmamış, bir kısmı "sonra döneceğiz" denip unutulmuş tüm açık kalemleri TEK bir yerde, TEK bir sözleşmeyle toplamak — Codex, Claude 2 ve gelecekteki herhangi bir oturumun "bu iş yapıldı mı, kim yapıyor, ne bekliyor" sorusunu bu belgeden ve `SORUN_TAKIP.md`'den cevaplayabilmesi.

İlkeler ([[uxb-fix-plan-decisions-2026-09]] ve `MOTOR_MIMARISI_TARTISMA_NOTU.md` ile aynı):

1. Her bulunan sorun bir S-numarası alır; numarasız "bir gün bakarız" kalemi kalmaz.
2. Bir konunun "durma noktası değil, dinlenme noktası" olması, onu takip defterinden düşürmez — aksine açıkça `ACIK` kalır ve tekrar hatırlanabilir olması için buraya yazılır.
3. Dört kullanıcı-seçilebilir yürütme yolu (AST/canonical-MIR/MIR-x64/AST-direct-x64) + JS/WASM hedefleri arasında gözlemlenebilir sonuç ayrışması kabul edilmez; ayrışma varsa ya düzeltilir ya açıkça "desteklenmiyor" diye işaretlenir — sessiz yanlış sonuç en kötü durumdur.
4. Bir işin CLAIM'i olmadan kimse başka bir oturumun aktif dosyasına girmez (bkz. `DURUM.md`).
5. "Tamamlandı" yalnız gerçek derleme + gerçek çalıştırma + karşı-örnekle doğrulanmışsa yazılır (bu projenin standing kuralı: [[feedback_no_placeholders_ever]]).

## 2. Mevcut durumun envanteri (2026-09-15 itibarıyla)

Bu tablo, 2026-09-06'dan bugüne kadar açılan/hâlâ açık olan TÜM konuları özetler. "Yeni S-No" sütunu bu turda verilen numaraları gösterir.

| S-No | Konu | Durum | Track (bkz. §3) |
|---|---|---|---|
| S-004 | Motor sayısı/mimarisi | **KARAR-VERILDI-POLITIKA-BELGELENDI** (bu turda kapatıldı, §3.A) | A |
| S-021 | MIR memory width lowering | YAPILDI-DOGRULANDI | B |
| S-028 | Preprocessor `--out-root` izolasyonu | ACIK (alt parçalar kısmen düzeldi) | H |
| S-029 | Native ABI'de PARALLEL kalıntısı | ACIK | C |
| S-030 | Typed görevler gerçek asenkron değil | ACIK | C |
| S-031 | PATCH-5 kanonik iterator ABI'si yok | ACIK (LIST/DICT/SET için kısmen kapandı) | D |
| S-033 | `MIR_MEMORY_REF` imza/lowering çelişkisi | ACIK | B |
| S-034 | Step-4 MIR verifier bağlı değil | ACIK | B |
| S-035 | `REDIM PRESERVE` canonical-MIR/x64'te kırık | ACIK | B |
| S-036/S-049 | Bellek mimarisi + VIRTUAL deyimi | KISMEN-YAPILDI (AST+CLI tamam; canonical-MIR + native-x64 açık) | B |
| S-037 | OOP rota-eşdeğerliği | ACIK — **ayrı belge**: `OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` | I |
| S-050 | Native x64 struct-dizisi alan erişimi | YAPILDI-DOGRULANDI (Codex) | B |
| **S-057** (yeni, Codex'in 23:44 incelemesi) | Native x64 VIRTUAL sınır-dışı erişim sessizce `0` dönüyor | ACIK | B |
| **S-058** (yeni, Codex) | AST NATIVE bellek adresleri 32-bit, canonical-MIR 64-bit | ACIK | B |
| **S-059** (yeni, Codex) | NATIVE POKES/PEEKS 3 backend'de 3 farklı davranış | ACIK | B |
| **S-060** (yeni, Codex) | MIR verifier width=8 kabul ediyor, x64 sadece 1/2/4 | ACIK | B |
| **S-051** (yeni) | JS backend'de BYREF sessiz yanlış sonuç | ACIK | E |
| **S-052** (yeni) | uxraylib/uxsdl3 "dinlenme noktası" bitmedi | ACIK | F |
| **S-053** (yeni) | uxterminal aşırı dar yüzey | ACIK | F |
| **S-054** (yeni) | 2 arka-plan görevi hiç raporlanmadı | ACIK | G |
| **S-055** (yeni) | Q ailesi (PEEKQ/POKEQ/MEMCOPYQ/MEMFILLQ) yok | ONAYLI-YAPILACAK | B |
| **S-056** (yeni) | `MemoryRef` birleşik soyutlaması başlanmadı | ONAYLI-BEKLIYOR | B |

## 3. Track bazlı tasarım

### 3.A — Motor mimarisi politikası (S-004) — KAPALI, sadece uygulanacak

Karar `MOTOR_MIMARISI_TARTISMA_NOTU.md`'de kayıtlı ve bu turda `SORUN_TAKIP.md`'de resmileştirildi: **ölü kod yok**, 4 kullanıcı yolu + 2 test/referans kümesi (`mir_evaluator*.fbs`, `src/interpreter/ast/*`) hepsi korunuyor. Codex/Claude 2 için tek görev: yeni bir dil özelliği yazarken bunu ÖNCE canonical-MIR sözleşmesine eklemek, 5. kümeye (`mir_evaluator*`) yeni özellik EKLEMEMEK. Bu track'te başka iş paketi yok — sadece disiplin.

### 3.B — Bellek modeli, VIRTUAL deyimi ve MIR doğrulama borcu

Bu, S-036'dan başlayıp S-049/S-050'ye uzayan, hâlâ en büyük açık teknik borç yığını. Codex'in bağımsız incelemesi (`MEMORY_VIRTUAL_MIR_X64_INCELEME_20260914.md`, 2026-09-14 23:44) benim bulduklarımla birebir örtüşüyor ve 4 yeni somut bulgu ekliyor (S-057 – S-060, aşağıda). Alt kalemler:

1. **VIRTUAL deyiminin canonical-MIR ve native x64 tarafı** (S-049 madde 3'ün kalanı) — AST yorumlayıcı + CLI bayrağı tamam (2026-09-14, gerçek çalıştırmayla doğrulandı); `runtime_memory.fbs`'teki `gUXBRuntimeVirtualMemory` hâlâ sabit `(0 To 1048575)` statik dizi, `VIRTUAL_STMT` için hiçbir MIR lowering/interpreter Case'i yok; native x64'ün `__uxb_mem_space`'i hâlâ sabit 1MiB.
2. **S-055 — Q ailesi**: `PEEKQ`/`POKEQ`/`MEMCOPYQ`/`MEMFILLQ`, B/W/D'nin yanına dördüncü genişlik olarak. Kilitli tasarımın parçası, hiç yazılmadı.
3. **S-033 — `MIR_MEMORY_REF` imza çelişkisi**: `mir_opcode_signature.fbs` ikinci operandı `MIR_OPR_VAR` diyor, `memory_ref_lowering.fbs` literal `"ARRAY"` + dizi adı üretiyor. Verifier/consumer sözleşmesini kıran doğrudan bir uyumsuzluk — düzeltme ya imzayı ya lowering'i değiştirmeli, ikisi de bugünkü haliyle "doğru" olamaz.
4. **S-034 — Step-4 MIR verifier'ları bağlı değil**: `UXBMIRStep4VerifyTypes`/`TargetSupport`/`Operands`/`NoUnknown`/`Memory`/`ControlFlow`/`Calls`/`Blocks` derleniyor ama orkestrasyon çağrısı yok; `--mir-verify` bu yüzden gerçek hataları (örn. temporary-width operandları) görmüyor. Önce temporary-değer sözleşmesini destekleyecek şekilde birleştirilmeli, SONRA gate'e bağlanmalı (sırayı tersine çevirmek regresyon riski taşır).
5. **S-035 — `REDIM PRESERVE` canonical-MIR/MIR-x64'te kırık**: AST'de doğru (`22,27,27,33,44`), canonical-MIR "array index cannot be written", MIR-x64 "unsupported array element type ARRAY" veriyor.
6. **S-036'nın AST'te kalan kısımları**: dizi eleman-arası byte aritmetiği canonical-MIR/native-x64'te hâlâ "tek gerçek depo" değil; struct/class alanları AST'de hâlâ eski VM-senkron-dışı yolda (satır ~592-681, `memory_exec.fbs`).
7. **S-056 — `MemoryRef` birleşik soyutlaması**: Codex'in önerisi kabul edildi, "önce motor-motor doğru yap sonra topla" sırası seçildi. Motorlar artık büyük ölçüde doğru olduğuna göre bu soyutlamaya geçme kararı gündeme alınmalı — YAPILACAKSA S-033/034/035 ile aynı anda ele alınmalı, çünkü hepsi aynı `MIR_MEMORY*` opcode ailesine dokunuyor. Codex'in kendi önerisi (bkz. §kaynaklar) de bağımsız olarak aynı sonuca varıyor: "Tek canonical `MemoryRegion/MemoryRef` sözleşmesi tanımla" onun 6 adımlı düzeltme sırasının 1. maddesi.
8. **S-057 — Native x64 VIRTUAL sınır-dışı erişim sessizce `0` dönüyor.** `mir_x64_context.fbs:354-369` sınır aşımında `xor eax,eax` ile "başarısız" dönüyor ama bu hiçbir hata kanalına raporlanmıyor — store sessizce yutuluyor, load sessizce `0` yazıyor, program exit 0 ile "başarılı" görünüyor. AST/canonical-MIR aynı durumda düzgün hata veriyor. **Bu, S-057-060 içindeki en ciddi olan — S-036/S-049'un "fail-closed, asla sessiz yanlış değil" standardını doğrudan ihlal ediyor, öncelik G1'den bile önce gelmeli.**
9. **S-058 — AST'nin NATIVE bellek adres/uzunluk tipleri 32-bit (`UInteger`/`CUInt`), canonical-MIR 64-bit (`ULongInt`).** 4 GiB üstü adresler AST tarafında sessizce kesilebilir.
10. **S-059 — NATIVE `POKES`/`PEEKS` üç backend'de üç farklı davranış.** AST ve canonical-MIR reddediyor, MIR-x64 native adres çözümlemeye çalışıyor — üçü de aynı olmalı.
11. **S-060 — MIR verifier width=8'i (Q) geçerli sayıyor ama x64 emitter'lar yalnız 1/2/4 destekliyor.** S-034 (verifier bağlı değil) ile birlikte ele alınmalı; S-055 (Q ailesi) yazılırsa bu uyumsuzluk hemen su yüzüne çıkar.

**Önerilen sıralama (bağımlılık gözetilerek):** S-057 (en ciddi, sessiz yanlış sonuç — önce) → S-033 → S-034+S-060 (birlikte, ikisi de verifier/genişlik sözleşmesi) → S-035 → S-058/S-059 (adres tipi + POKES/PEEKS tutarlılığı) → (S-036 kalan + VIRTUAL'in canonical-MIR/x64 tarafı) → S-055 (Q ailesi, bağımsız küçük kazanç) → S-056 (hepsi bittikten sonra, refactor — Codex'in önerdiği gibi en başa da alınabilir, tartışılmalı).

### 3.C — Eşzamanlılık (S-029, S-030)

6 Eylül 2026'daki ilk hedef ("PARALEL varsayılan gerçek eşzamanlılık olsun") hâlâ karşılanmadı; 7 Eylül'de kendi ayrı oturumuna bırakıldı, o oturum hiç açılmadı.

- **S-029**: dil yüzeyi `PARALEL` (tek L), native ABI hâlâ `uxb_parallel_run` ihraç ediyor (iki L). Küçük, bağımsız, önce yapılabilir bir isim-tutarlılığı düzeltmesi.
- **S-030**: typed `TRIGGER_STMT` doğrudan `__SLOTLANE_*` çağrısına iniyor, native trigger/oneTBB ABI'den geçmiyor — yani `PARALEL` sözdizimi var ama gerçek thread/pipe/parallel semantiği yok, sıradan senkron çağrı gibi çalışıyor. Mete'nin kendi uyarısı hâlâ geçerli: **yarım/kestirme düzeltme yapılmayacak** — bu, "senkron çalışıyor" dürüst sınırını "sessiz veri yarışı" haline getirme riski taşıyor. Gerçek iş: `native/uxb_runtime/backends/`e libuv veya oneTBB tabanlı gerçek bir arka uç eklemek ve `PARALEL`/`THREAD`'i varsayılan olarak ona yönlendirmek — kendi başına, büyük, ayrı bir tasarım gerektirir (ayrı bir alt-belge önerilir, bu plan sadece varlığını kayda geçiriyor).

### 3.D — Iterator/Collection ABI kalanları (S-031)

LIST/DICT/SET için özel MIR lowering (`MIRLowerListEachLoop` vb.) yazıldı ve doğrulandı (S-038 ile kapandı). Ama PATCH-5'in genel `MIR_ITER_CREATE`/`MIR_ITER_NEXT`/`MIR_ITER_CLOSE` sözleşmesi hiç canlı kaynağa girmedi — yani dinamik dizi, STRING ve class/interface için "kullanıcı-tanımlı iterator" hâlâ yok. Şu an gerçek ihtiyaç doğana kadar (örn. kullanıcı tanımlı bir CLASS'ı `FOR EACH` ile gezmek istediğinde) ertelenebilir — S-030 gibi acil değil, ama kapsam dışı bırakıldığı açıkça not edilmeli.

### 3.E — Cross-target (JS/WASM) parity — S-051 ve benzer riskler

**S-051 (yeni bulgu, bu turda gerçek testle doğrulandı): JS backend'de BYREF çalışmıyor.** AST/canonical-MIR/native-x64 3'ü de doğru sonuç verirken (`11`), JS/Node `10` basıyor — parametre değer olarak geçiyor, referans değil. Kök neden: `src/codegen/js/`'de `paramByRef` kavramı hiç yok. Çözüm önerisi (Codex'in 7 Eylül önerisiyle uyumlu): JS tarafında BYREF parametreler için tek-alanlı bir "box" nesnesi (`{value: ...}`) üretip çağrı yerinde `{value: vars["N"]}` gibi paslamak, fonksiyon içinde `x.value` üzerinden okuma/yazma yapmak, dönüşte çağıranın değişkenine `vars["N"] = box.value` ile geri yazmak.

**Doğrulanması gereken benzer riskler (bu turda test edilmedi, ayrı S-numarası bekliyor):** WASM backend'de BYREF durumu bilinmiyor (muhtemelen aynı hastalık, adres/heap-handle gerektirir — Codex'in önerisinde de "WASM sonra" diye ayrılmıştı). Bu iki hedef parity tamamlanmadan "BYREF tüm biçimlerde çalışıyor" iddiası eksik kalır.

### 3.F — Kütüphane tamamlama (S-052, S-053)

6 Eylül'deki "5 eksik DLL" bulgusu DLL-varlığı anlamında kapandı (hepsi `bin/`'de), ama kapsam tamamlanmadı:

- **S-052**: uxraylib (~126 fn) ve uxsdl3 (~39 fn) — Models/3D, Shaders, Image manipulation (raylib); joystick/gamepad, clipboard, text-input events (SDL3) hâlâ eksik. "Dinlenme noktası" kararı hâlâ geçerli sayılabilir ama artık AÇIKÇA bir S-numarasıyla takip ediliyor.
- **S-053**: uxterminal'in 9 fonksiyonluk yüzeyi manifestteki "terminal-ui" tier'i için yetersiz — klavye girişi, renk paleti, kutu çizimi yok.
- **Not (S-numarasız, sadece bilgi):** uxlogic (19 fn) ve uxclz (43 fn) çalışıyor (gerçek smoke testleriyle bu turda doğrulandı: `logic_smoke.uxb`, `uxclz_host_parity.uxb` PASS) — bunlar için ek eksik iddiası yok, sadece hiç kimse bu oturumda doğrulamamıştı.

### 3.G — Süreç disiplini: arka-plan görev takibi (S-054)

7 Eylül'de başlatılan iki arka-plan görevinin (`task_31b2c2fe`, `task_c195d4d6`) sonucu hiçbir koordinasyon dosyasına yazılmadı. Bu bir kod hatası değil, bir SÜREÇ hatası — kural: bundan sonra bir arka-plan görevi başlatıldığında, sonucu (başarı/başarısızlık, hangi S-numarasına bağlı olduğu) `SORUN_TAKIP.md`'ye veya `DURUM.md`'ye mutlaka yazılacak, aksi halde S-054 gibi "kayıp" görevler birikir.

### 3.H — Preprocessor/build çıktı izolasyonu (S-028)

Alt parçaları (log/adim5 yazımı) düzeldi (2026-09-14), ama üst kayıt hâlâ `ACIK` — kalan slot-kilit/native-CWD alt işi ayrıca ele alınmalı, kapanış için tam bir yeniden-doğrulama turu gerekli.

### 3.I — OOP (S-037)

Bu track'in TAM tasarımı zaten var: `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md`. Burada tekrar edilmiyor; bu plan onunla birlikte okunmalı. Tek bağlantı noktası: OOP planının P5 paketi ("bütün motorlarda çekirdek OOP parity") ile bu belgenin 3.A/3.B track'leri aynı "4 motor + JS/WASM parity" disiplinini paylaşıyor.

## 4. Uygulama paketleri (genel, OOP dışı)

| Paket | İş | Bağımlılık | Sahip (önerilen) | Çıkış ölçütü |
|---|---|---|---|---|
| G-1 | **S-057 native x64 VIRTUAL sınır-dışı sessiz `0`** — en yüksek öncelik, sessiz yanlış sonuç | Yok | Boş — hemen atanmalı | Sınır-dışı erişim native x64'te de gerçek hata veriyor, exit 0 ile `0` basmıyor |
| G0 | S-033/034/060/035 (MIR_MEMORY_REF imza + verifier bağlama + genişlik sözleşmesi + REDIM PRESERVE) | S-057 | Claude 1 (bellek CLAIM'i sahibi) | 4'ü de gerçek derleme+çalıştırmayla kapanır, 33/33 regresyon yeşil |
| G1 | VIRTUAL deyiminin canonical-MIR + native x64 tarafı + S-058/S-059 (adres tipi, POKES/PEEKS tutarlılığı) | G0 (aynı opcode ailesi) | Claude 1 veya Codex (CLAIM'e göre) | `VIRTUAL 2M,16G` üç motorda da aynı sonucu verir; adresler 64-bit; POKES/PEEKS 3 motorda aynı |
| G2 | S-055 Q ailesi (PEEKQ/POKEQ/MEMCOPYQ/MEMFILLQ) | Yok (bağımsız) | Boş — atanacak | 4 motorda B/W/D ile aynı desende PASS |
| G3 | S-056 MemoryRef birleşik soyutlaması | G0-G2 | Boş — Mete'nin önceliklendirmesi bekleniyor | Refactor sonrası 33/33 + tüm bellek testleri regresyonsuz |
| G4 | S-051 JS BYREF box/getter-setter + WASM BYREF doğrulama | Yok | Boş — atanacak | `BumpVal` testi JS/Node'da da `11` verir |
| G5 | S-029 isim tutarlılığı (PARALEL/PARALLEL) | Yok | Boş — küçük, hızlı | native ABI ve dil yüzeyi aynı adı kullanır |
| G6 | S-030 gerçek eşzamanlılık (libuv/oneTBB arka uç) | G5 (öneri) | Boş — ayrı tasarım oturumu gerektirir | Ayrı alt-belge + gerçek concurrent çalıştırma kanıtı |
| G7 | S-052 uxraylib/uxsdl3 kapsam tamamlama | Yok | Boş — Mete'nin "devam" onayı bekliyor | Models/3D veya Shaders'tan en az biri gerçek pencereyle çalışır |
| G8 | S-053 uxterminal genişletme | Yok | Boş | Klavye + renk paleti + kutu çizimi eklenir |
| G9 | S-028 kalan slot-kilit/native-CWD izolasyonu | Yok | Boş | Temiz CWD'de native build tam yeniden doğrulanır |

Her paket başlatılmadan önce `DURUM.md`'ye bir CLAIM satırı eklenmeli — bu, dokuz gündür tekrar eden çakışma-önleme protokolünün aynısı.

## 5. Kabul standardı (tüm paketler için ortak)

- Gerçek derleme + gerçek çalıştırma (`.exe` üretimi ve çalıştırılması dahil, sadece `.asm`/NASM emit-only kanıt yeterli DEĞİL — S-039'un uyardığı hata bu).
- İlgili tüm motorlarda (bağlı olduğu track hangi motorları kapsıyorsa) birebir aynı gözlemlenebilir sonuç, veya açık "desteklenmiyor" hatası — sessiz farklılık asla.
- `tests/typed_task_routines/run_typed_task_tests.ps1` 33/33 (veya güncel toplam) regresyonsuz.
- `bin/uxb.exe` SHA256 kaydı, kanıt olarak `SORUN_TAKIP.md`'ye yazılır.
- Kapsam dışı bırakılan her şey AÇIKÇA yazılır (sessizce atlanmaz) — bu belgenin kendisi de bu kuralın bir örneğidir.

## 6. Kaynak dayanakları

- `ai_koordinasyon/SORUN_TAKIP.md` — S-004, S-021, S-028 – S-056 kayıtları.
- `ai_koordinasyon/MOTOR_MIMARISI_TARTISMA_NOTU.md` — motor mimarisi kanıtı ve nihai politika.
- `ai_koordinasyon/DURUM.md`, `SORULAR_CEVAPLAR.md` — CLAIM protokolü ve Codex/Claude 2 ile ortak günlük.
- `C:\Users\mete\.claude\projects\...\memory\uxb_memory_architecture_2026_09.md` — kilitli bellek tasarımının 11 maddesi (Q ailesi ve MemoryRef buradan alındı).
- `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` — OOP track'inin tam tasarımı (bu belgenin §3.I'i sadece ona işaret eder).
- `ai_koordinasyon/MEMORY_VIRTUAL_MIR_X64_INCELEME_20260914.md` — Codex'in bağımsız bellek/VIRTUAL incelemesi; S-057/S-058/S-059/S-060'ın kaynağı, ayrıca 6 adımlı kendi düzeltme sırası önerisini içeriyor (bu belgenin §3.B önerisiyle büyük ölçüde örtüşüyor).
- Bu belgenin S-051/052/053/054 bulguları — 2026-09-15 tarihli, bu oturumda gerçek `uxb.exe run`/`jsw --emit-js`/`node` çalıştırmalarıyla doğrulandı (`byref_gap_check.uxb`, `sprite_terminal_smoke.uxb`, `logic_smoke.uxb`, `uxclz_host_parity.uxb`).
