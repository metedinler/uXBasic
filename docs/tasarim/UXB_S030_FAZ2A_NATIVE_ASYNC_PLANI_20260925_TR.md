# S-030 Faz 2A — Native x64'te Gerçek Eşzamanlı Görevler: Bulgular ve Uygulama Planı

Tarih: 2026-09-25 · Hazırlayan: Claude 1 · Durum: **PLAN — uygulama sırası bu belgeye göre**
Ön koşullar tamam: S-030 Faz 1/1B (AST + canonical MIR senkron referans), S-149 `TASK OF T`, S-146 izolasyon
denetimi (R1–R6, geçişli etki analizi; `tests/task_model` 188/188).

Faz 2A'nın hedefi (Mete, S-146 kararı): **izole** görevler native x64'te gerçekten ayrı iş parçacıklarında çalışır.
Paylaşım (SHARED/ATOMIC/MUTEX/LOCK) Faz 2B'dir; bu fazda yoktur, çünkü izolasyon denetimi zaten her paylaşımı
derleme zamanında reddediyor.

## 1. Kodda bulunan durum (2026-09-25 incelemesi)

| Konu | Bulgu | Faz 2A'ya etkisi |
|---|---|---|
| Çalışma zamanı ABI v1 | `native/uxb_runtime`: `callback(slot, int girdi, int* çıktı)`; std/libuv/tbb arka uçları görevi **başlatıp hemen bekliyor** (`std::thread` + `join`) | Gerçek eşzamanlılık yok; yeni API (ABI v2) gerekiyor |
| Görev girdisi/çıktısı | Mevcut TRIGGER geri çağırma kabuğu (`mir_x64_task_shell.fbs`) girdiyi **global** `TASKIN`'e yazıp lane rutinini parametresiz çağırıyor | SPAWN'da kullanılamaz: iki görev aynı global'e yazar. SPAWN lane'leri parametreleri normal Win64 çağrı kuralıyla almalı |
| Lane dönüş değeri | Faz 1B'de THREAD/PARALEL `AS T` MIR fonksiyonunun dönüş tipi oldu; `RETURN x` → `rax`/`xmm0` | Thunk sonucu doğrudan registerdan alabilir |
| Yakalanmamış THROW | `RET __result__` yolunda istisna aktifse değer **ekrana basılıp** `rax=1` dönüyor (ana program çıkış kodu mantığı) | Görevde bu, "görev hatası" olarak görev kaydına yazılmalı (K6 / Mete: hata görev nesnesinde tutulur) |
| İstisna durumu | `__mir_exc_active/__mir_exc_value` fonksiyon çerçevesinde (yığın) | İş parçacığı açısından güvenli ✔ |
| Metin geçici tamponu | `uxb_runtime_mir.cpp` `thread_local` 32'lik halka | İş parçacığı içinde güvenli ✔; ama görev **sonucu** STRING ise halkadan görev kaydına kopyalanmalı |
| Kullanıcı global değişkenleri | `.data` bölümünde | İzolasyon denetimi görev gövdesinde kullanımı zaten reddediyor ✔ |
| LIST/DICT/SET deposu | `uxb_runtime_mir.cpp` `collections` vektörü `collections_mutex` ile korunuyor (19 erişim noktası, 20 kilit; doğrulandı) | Görev içinde yerel LIST güvenli ✔ |
| Dosya kanalları, RND | `file_mutex`, `random_mutex` zaten var | İzolasyon görevde kullanımı reddediyor; ek iş yok |
| PRINT | Her öğe ayrı çalışma zamanı çağrısı | K9 (tek PRINT atomik) için iş parçacığına özel satır tamponu + deyim sonu boşaltma gerekiyor |

## 2. Tasarım

### 2.1 ABI v2 (C++ çalışma zamanı, `native/uxb_runtime/uxb_runtime_task_v2.cpp`)
- **TaskRun kaydı:** id, durum (PENDING/RUNNING/DONE/ERROR/CANCELLED), sonuç (8 bayt ham değer + sonuç türü:
  I64/F64/STRING/VOID), sonuç metni (`std::string`, STRING ise kopya), hata metni, iptal-istendi bayrağı, bekleme
  için koşul değişkeni.
- **İş havuzu (K4):** varsayılan mantıksal CPU sayısı; `UXB_TASK_WORKERS` ortam değişkeni ve `--task-workers N`
  derleyici bayrağı (çalıştırılabilir dosyaya gömülür). Havuz ilk SPAWN'da açılır.
- **İç içe SPAWN kilitlenmesin:** JOIN/WAIT eden bir işçi, beklediği görev bitene kadar kuyruktan başka iş çalıştırır.
- **Fonksiyonlar (Win64, hepsi `int64`):**
  `__uxb_rt_task_spawn(thunk, argblock, bytes, name, resultKind)` → tutamaç ·
  `__uxb_rt_task_wait/join/cancel/status/result/error(h)` ·
  `__uxb_rt_task_group_create/add/join` ·
  görev içinden: `__uxb_rt_task_fail_cstr/i64(değer)` (yakalanmamış THROW), `__uxb_rt_task_cancel_point()`.
- **Hata yayılımı:** JOIN/RESULT/GROUP_JOIN hata ya da iptal görürse AST/MIR ile aynı metinle ölümcül çalışma zamanı
  hatası verir (`gorev hatasi (AD): ...` / `gorev iptal edildi (AD): CANCELLED`).
- **Kapanış (K5, tam metin):** normal kapanış sahip olunan görevlerin bitmesini BEKLER. Hatalı kapanışta kalan
  görevlere iptal isteği gider. **Okunmamış görev hatası sessiz kaybolmaz:** hata çıkışına yazılır, çıkış kodu
  başarısız olur. "Okundu" = hata JOIN/RESULT/TASKGROUP.JOIN ile yükseldi ya da STATUS/ERRORTEXT ile sorgulandı.
  **Eşdeğerlik açığı (AST/MIR):** Faz 1/1B senkron referansı bu K5 kuralını henüz uygulamıyor; hiç okunmamış hatalı
  görev sessiz kalıyor. Faz 2A adım 1 ile birlikte AST ve MIR yorumlayıcılarına da program sonu denetimi eklenecek.

### 2.2 Kod üretimi (`src/codegen/x64`)
- **Thunk:** SPAWN hedefi olan her lane için bir `__uxb_task_thunk_<lane>(argblock)` üretilir. Argümanları bloktan
  okuyup Win64 kuralıyla (ilk 4 register/xmm, kalanı yığın) lane'i çağırır. Sonucu `rax`/`xmm0`'dan bloğa yazar,
  STRING ise `__uxb_rt_task_set_result_str` ile görev kaydına kopyalar.
- **SPAWN noktası:** argümanlar yığında hazırlanan bloğa yazılır; `__uxb_rt_task_spawn` blok içeriğini görev kaydına
  kopyalar, böylece çağıranın yığını hemen serbest kalır.
- **Lane'de yakalanmamış THROW:** lane SPAWN hedefiyse `RET __result__` istisna yolu ekrana basmak yerine
  `__uxb_rt_task_fail_*` çağırır.
- **İptal noktaları (K6):** SPAWN hedefi olan lane'lerde ve onların çağırdığı rutinlerde döngü geri dönüşlerine ve
  WAIT/JOIN/SPAWN çağrılarına `__uxb_rt_task_cancel_point` eklenir.
- **TASK_* çağrıları:** Faz 1B'deki açık red, bu çalışma zamanı çağrılarıyla değiştirilir.
- **PRINT (K9):** öğe çağrıları iş parçacığına özel satır tamponuna yazar; her PRINT deyiminin sonunda üretilen
  `__uxb_rt_print_flush` tamponu tek kilit altında konsola yazar. INPUT'tan önce ve program sonunda da boşaltma
  yapılır. Tek iş parçacıklı programlarda çıktı sırası değişmez.

## 3. Uygulama adımları (her adım kendi testiyle kapanır)

1. **Çalışma zamanı ABI v2 + havuz** (C++). Kanıt: C++ stres testi (1000 görev, iç içe SPAWN, JOIN sırası, iptal,
   hata). DLL yeniden derlenmeden önce tam regresyonun çalışmıyor olması gerekir, çünkü x64 testleri DLL'e bağlı.
2. **PRINT satır tamponu + flush.** Kanıt: mevcut bütün x64 testleri aynı çıktı; 8 görev × 1000 PRINT satırında
   bölünmüş satır yok.
3. **Thunk + TASK_SPAWN/JOIN/RESULT/STATUS/ERROR/WAIT** üretimi. Kanıt: `tests/task_model` x64 = run (şu an red);
   çıktılar AST/MIR ile birebir.
4. **Yakalanmamış THROW → görev hatası**, TASKGROUP, CANCEL + iptal noktaları. Kanıt: hata/iptal testleri x64'te.
5. **Kapanış + `--task-workers`**, stres ve zamanlama testleri (sıra bağımsız çıktı, `TASKGROUP` ile toplama).
6. `_engines.txt` içinde `x64=run`; legacy AST-x64 kalıcı red (K7) olarak kalır. Belgeler ve kılavuz güncellenir.

## 4. Riskler

- **Yığın boyutu:** işçi iş parçacıklarının yığını ana iş parçacığından küçük olabilir; derin özyineleme için
  işçi yığını açıkça 8 MB verilecek.
- **Çalışma zamanının diğer ortak durumu:** dosya kanalları, RND, konsol renk/konum. İzolasyon denetimi görev
  içinde bunları reddettiği için 2A'da dokunulmaz; gevşetme kararları Mete'de (S-146 §8.2 İ3).
- **DLL sürümü:** eski DLL ile derlenmiş programlar ABI v2 fonksiyonlarını bulamaz; çalıştırılabilir dosya
  başlangıçta sürüm denetimi yapıp açık hata vermeli.

## 5. Uygulama durumu (2026-09-25 sonu)

| Adım | Durum | Kanıt |
|---|---|---|
| 1. Çalışma zamanı ABI v2 + havuz | ✅ | `tests/native_runtime/task_v2` 108/108 (12 senaryo × işçi 1/2/AUTO × 3) |
| 2. PRINT satır tamponu (K9) | ✅ | `task_v2 print_atomic` + `tests/task_native/native_print_lines` (8 görev × 60 satır) |
| 3. Thunk + TASK_* kod üretimi | ✅ | `tests/task_model` x64 = run, 192/192 |
| 4. THROW → görev hatası, TASKGROUP, CANCEL + iptal noktası | ✅ (sınırlı) | `native_cancel_running`; sınır: yardımcı rutin döngüsünde iptal gözlenmez |
| 5. Kapanış (K5) + işçi sayısı | ✅ | `main` sonu kapanışı + okunmamış hata; rutin içindeki `END` de kapanıştan geçer (`__uxb_rt_program_end`, S-156); `--task-workers N` programa gömülür (`UXB_TASK_WORKERS` çalışma anında önceliklidir); işçi yığını 8 MB (`_beginthreadex`). Kanıt: `tests/cli_flags` 25/25, `tests/program_end`, `task_v2 embedded_workers/deep_recursion` |
| 6. Belgeler / kılavuz | ⏳ | kılavuz bölümü yazılacak |

**Açık kalanlar:** yardımcı rutin döngülerinde iptal (native'de çağrılar arası erken dönüş mekanizması gerekir);
kılavuz bölümü; JS (Faz 3, Antigravity) ve WASM (Faz 4); Faz 2B paylaşım modeli (SHARED/ATOMIC/MUTEX/LOCK — Mete'nin
S-146 §8.2 İ1/İ2/İ4/İ6 onayı bekleniyor).
