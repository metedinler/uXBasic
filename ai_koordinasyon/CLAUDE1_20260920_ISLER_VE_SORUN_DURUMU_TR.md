# Claude 1 — 20 Eylül 2026 iş kaydı ve sorun durumu

Bu defter, Mete'nin talimatıyla (“defterlere ne yaptığını yaz, karşılaştığın sorunların kapanıp kapanmadığını yaz”)
yazıldı. Her satır çalıştırılarak doğrulanmıştır; ayrıntı ve kanıt `SORUN_TAKIP.md` içindeki S-numaralı
bölümlerdedir. Durum kelimeleri:

- **KAPANDI** — kök neden bulundu, dört motorda (AST, canonical-MIR, native MIR-x64, legacy AST-x64) doğrulandı.
- **KISMEN** — asıl kusur kapandı; kalan parça açıkça yazılı.
- **AÇIK** — bulundu ve kayda geçti, henüz düzeltilmedi.
- **KARAR** — kod değil tasarım kararı gerekiyor (Mete'nin cevabı bekleniyor).

## 1. Bu turda tamamlanan işler

| İş | S-no | Durum | Test / kanıt |
|---|---|---|---|
| `VARPTR(a(i))` = `VARPTR(a) + (i-LBOUND)*adım`; her bağlamda VARPTR argüman doğrulaması | S-081 | KAPANDI | `tests/abi_model/varptr_array_element` (dört motor) |
| Dizi parametreleri `arr AS T[]` (native x64 tanımlayıcı + legacy eğimli taban + derleme zamanı doğrulaması) | S-068, S-096 | KAPANDI | `tests/array_params` 59/59, `tests/array_param_model` |
| `SADD` gerçek adres; `CODEPTR/LPTR` legacy'de gerçek, AST'de uydurma adres kaldırıldı | S-076 | KISMEN | `tests/sadd_model` 36/36 |
| `SUB/FUNCTION MAIN` çakışması → `MAIN` rezerve ad | S-067 | KAPANDI | `tests/language_guards` |
| ADIM25 kapısı `MIR_MEMORY_STORE` ↔ `MEMORY_STORE` | S-075 (2) | KAPANDI | `tests/language_guards/memory_statements_alone` |
| OOP eşitliği (sanal dağıtım, SUPER, THIS/ME, miras, açık PRIVATE/PROTECTED, null alıcı) | S-037 | KISMEN | `tests/oop_parity` 73/73 |
| Iteratör sözleşmesi (LIST/SET/DICT/dizi FOR EACH) | S-038 | KISMEN | `tests/iterators` 38/38 |
| canonical-MIR `PRINT` çıktısı canlı akıyor (DLL/API doğrudan yazımıyla doğru sıra; hata öncesi çıktı korunuyor) | S-074 | KAPANDI | `tests/language_guards/print_order_direct_write` (dört motor; eski ikilide MIR düşüyor) |
| canonical-MIR yorumlayıcı performansı (opcode kayıt not-defteri, iz kapalı, değişken anahtarı, PRINT O(n²)) | S-109 | KAPANDI | `FOR 1..5000` 118,6 → 2,56 sn CPU; `tests/language_guards/mir_loop_scale`; birleşik koşucu 1762 → 425 sn |
| Tek güvenilir model-paketi koşucusu (`tests\run_all_model_tests.ps1`) — ilk parça; çıktı klasörlerini geçici `--out-root`a yönlendirip siler | S-072 | KISMEN | 10 paket, 342/342 GEÇTİ (545 sn); ~45 "adim" kapısı henüz bağlı değil |
| Ön uç (lexer/semantik/MIR/AST-yürütücü) ölçek performansı: token JSON `&=` O(n²), sahip-düğüm taraması, ad-indeksi, AST-sözleşme yüklemleri not-defteri | S-111 | KISMEN | 1000 deyimlik program CPU sn: `sem` 11→3,2 · `mir` 23→3,8 · `run` (AST) 18→3,2 · `run` (MIR) 34→6,1 |
| `uxb help` / `version` (ve `yardim`, `?`, `surum`) çalışıyor | S-116 | KAPANDI | gerçek çalıştırma: `--help` ile aynı 318 satır |
| WASM/WAT gerçek doğrulama: kullanıcı işlev çağrıları `call` üretmiyordu (S-121), modül değişkenleri fonksiyon başına yerel (S-120/S-100), PRINTLN `\n` metni; BYREF (S-122) ve GOSUB (S-123) net reddediliyor | S-120, S-121, S-100, S-102 | KAPANDI / KISMEN | `tests/wasm_model` 15 program × AST+WASM = 30 kontrol (node ile gerçek çalıştırma) |
| uxgsl native çalışıyor: `bld` FFI DLL bağımlılıklarını PE içe-aktarma tablosundan bulup kopyalıyor (sistem DLL'leri kopyalanmıyor) | S-075, S-117a | KAPANDI | `tests/libraries/uxgsl/run_uxgsl_smoke_tests.ps1`: 8 program × 4 motor = 32 kontrol (callback testleri yorumlayıcıda bilerek net red) |
| TYPE elemanlı dizi parametresi, AST sessiz-yanlış (hep 0, çağırana yazmıyordu) | S-103 | KISMEN | `tests/array_params/type_elem_param` (AST=MIR=7,10,11); native/legacy net red |

## 2. Yolda bulunan ve KAPANAN kök nedenler

| Kök neden | S-no | Durum |
|---|---|---|
| AST `ExecTryResolveArrayAccess` `-1`'i (hata) başarı sayan 6 çağıran → sınır dışı yazma başka elemana gidiyordu | S-097 | KAPANDI (AST, MIR, native); legacy AÇIK |
| Legacy rutin çerçeve boyutu gövdeden ÖNCE hesaplanıyordu; `FOR` geçicileri rsp altında kalıyor, I32 sayaçlı döngü fonksiyonda tek tur dönüyordu | S-098 | KAPANDI |
| Dar dizi elemanı işaret genişletmesi (native I32 -5 → 4294967291; legacy U8 250 → -6) ve float dizi aritmetiği (native `nan`) | S-099 | KAPANDI |
| canonical-MIR `MIR_OBJECT_NEW` sonucu hiç saklanmıyordu (ilk nesne kimliği 0 olduğu için tek nesneli programlar kazara çalışıyordu) | S-037 | KAPANDI |
| AST: `a = d` çalışma zamanı sınıfı; miras alınan virtual olmayan yöntem reddi | S-037 | KAPANDI |
| `SUPER.m()`: MIR hedefi `OBJECT_*`, legacy `super.speak` sembolü + vtable özyinelemesi | S-037 | KAPANDI |
| Anlamsal tip: `THIS/ME/SUPER` alıcısı OBJECT → `r = SUPER.Speak()` reddi | S-037 | KAPANDI |
| Null alıcı: native çöküş / sessiz değer / legacy sessiz 0 → her motorda anlamlı hata | S-037 | KAPANDI |
| Native SET FOR EACH sayısal değişkene string işaretçisi yazıyordu; AST'de string kalıyordu | S-038 | KAPANDI |
| Açık PRIVATE/PROTECTED yalnız AST çalışma zamanında denetleniyordu → derleme zamanı, dört motor | S-037 | KAPANDI |

## 3. AÇIK kalanlar (kayıtlı, düzeltilmedi)

| S-no | Konu |
|---|---|
| S-097 | Legacy AST-x64'te çalışma zamanı dizi sınır denetimi yok |
| S-122 | WASM: BYREF parametre gerçek desteği (şimdilik net red) — doğrusal bellek hücresi tasarımı |
| S-123 | WASM: GOSUB/RETURN gerçek desteği (şimdilik net red) — dönüş adresi yığını |
| S-102 (kalan) | `dist/wasm` eski kopyası hâlâ bayat (artık kullanılmıyor; `tests/wasm_model` taze köprüyle çalışıyor) |
| S-103 (kalan) | TYPE elemanlı dizi parametresi native x64/legacy'de net red (eleman adımı MIR'de taşınmıyor); callee'de `REDIM` anlamı (karar) |
| S-106 | ~~Değişken adı sınıf adıyla çakışınca yöntem çağrısı sınıf çağrısı sanılıyor~~ KAPANDI 2026-09-21: dört motorda aynı derleme hatası (Mete onayladı); 510 dosyalık korpus taraması temiz |
| S-128 | Anahtar sözcük / yerleşik işlev adlı değişkenler (`eof`, `len`, `abs`, `color`...) motorlar arasında tutarsız; AST `1`, MIR `EOF1` (sessiz yanlış) — KARAR olarak aşağıda |
| S-075 (1) | ~~uxgsl native çalıştırma~~ KAPANDI (bkz. tamamlananlar); GSL yüzeyini GENİŞLETME işi (madde 10 ikinci yarı) başlanmadı |
| S-076 (kalan) | `STRPTR(s)` işlev biçimi, `WSTRPTR`, `SETNEWOFFSET` anlamı, SADD için MemoryRef |
| S-083..S-092, S-094 | Önceki turlarda kaydedilenler (tek satır IF..ELSE, tür adlı değişken, JS/WASM 64-bit, legacy `/`, `STR(U64)`, AST hızı, F80 parçaları, MemoryRef boşlukları) |
| S-111 (kalan) | Ön uç: 1000 deyimde sem hâlâ 3,2 sn; başka For i=0 To ps.ast.count-1 taramaları ve j &= JSON kalıpları ölçülerek çözülecek |
| S-117 (kalan) | FFI'li yerel derleme ≥53 MB DLL kopyalıyor; salt `run` için klasör açmama bayrağı; eski rapor dosyaları (Mete'ye SORULACAK, aşağıda) |
| S-109 (kalan) | MIR adım başına ~45 µs (AST'den yavaş; opcode metin → komut yüklenirken `opId`) |
| S-052 (kalan) | uxraylib **Models/3D + Shaders** (raylib Image ve **SDL3 TAMAMLANDI**, bkz. DURUM 2026-09-24); GSL yüzeyini genişletme (madde 10 ikinci yarı) başlanmadı |
| S-140 (legacy) | legacy AST-x64 STRING/F64/namespace sabitleri rutin içinde (yalnız tamsayı modül sabiti çözülüyor); iki namespace'te aynı sabit adı MIR'de tek düz global |
| S-144 (legacy) | `f() <> "" OR g() = ""` (iki FFI dize çağrısı) çöküyor; satır-içi `sub rsp,40` çağrı yerleri hizalama riski taşıyor (yalnız `X64EmitCall0` sağlamlaştırıldı) |

## 4. KARAR bekleyenler (Mete)

| S-no | Soru | Öneri |
|---|---|---|
| S-101 | `LBOUND/UBOUND` dile eklensin mi? (dizi parametresi sınırını öğrenemiyor) | Ekle (FreeBASIC uyumu) |
| S-104 | `MAIN ... END MAIN` bloğundan sonraki üst düzey deyim: yasak mı, çalışsın mı? | Derleme hatası |
| S-105 | İşaretsiz sınıf üyesinin erişim VARSAYILANI (AST: PRIVATE, diğerleri serbest) | PUBLIC (FreeBASIC) veya açık karar |
| S-107 | `FOR EACH c IN s` (string) ve `IN a, b` (iki dizi) | String için karakter dolaşımı; dizi adı listede derleme hatası |
| S-108 | `DIM a AS Animal` null mı bırakır, varsayılan nesne mi ayırır? | Null (referans modeli) |
| S-088 | `U32 - U32` geçici sonuç 32 bite sarılsın mı? | C uyumu için evet |
| S-110 | canonical-MIR yorumlayıcısı 250 000. adımda "step limit exceeded" ile kesiyor (AST/native'de yok; `FOR 1..40000` MIR'de düşüyor). Varsayılan sınır kalksın mı, `--max-steps N` bayrağı eklensin mi? | Varsayılan çok yüksek (~2 milyar) + `--max-steps` bayrağı |
| S-128 | Ayrılmış sözcükler (yerleşik işlev/deyim/anahtar sözcük) değişken/parametre/alan/SUB adı olabilsin mi? Bugün 69 adın yalnız 27'si doğru; 15 ad iki motorda ayrıştırma hatası, 24 ad AST `1` / MIR `EOF1` diye SESSİZ yanlış | Ayrılmış sözcük ad olamaz: dört motorda aynı net derleme hatası (S-106 ile aynı çizgi) |
| S-142b | Native `PRINT <F64>` 6 anlamlı hane (`%g`: `1.65831`), AST/MIR/`STR` 15 hane (`1.6583123951777`): native yazdırma FreeBASIC `Str()` biçimine hizalansın mı? (çalışma zamanı DLL'i değişir) | Evet (motorlar arası çıktı eşitliği) |
| S-145 | FFI'de BOŞ metin argümanı: yorumlayıcılar NULL geçiriyor, native/legacy gerçek boş C metni. Boş metin her motorda gerçek `""` olsun, NULL ayrı (`PTR 0`) mi? | Evet |
| S-117 | Silinecek/taşınacak eski dosyalar (Mete'nin `build\` kuralına göre önceki günler silindi; ŞUNLAR SORULUR): `reports\` ≥3,1 GB, `_retired\` 2,1 GB, `dist\` 1,8 GB, `bin\` içinde 48 eski deneme ikilisi 433 MB, `Snapshoots\` 87 MB | Sen söyle: hangileri silinsin (kök dizindeki zip yedeklerine dokunulmaz) |
| S-029 | Native ABI'de `uxb_parallel_run` (iki L) C sembolü: DLL uyumluluğu için kalsın mı, yeniden mi adlandırılsın? | Kalsın; doğrulayıcı ABI sembollerini muaf tutsun |
| S-030 | Typed görevler gerçek eşzamanlı olsun mu? (bekleme/birleştirme yapısı, PRINT sırası, hata yayılımı tasarımı) | Ayrı tasarım oturumu; bugünkü senkron davranış belgeli ve tutarlı |

## 5. Regresyon durumu (bu turun sonunda)

**SON DURUM (2026-09-20 23:50): 13 paket, 463 / 463 kontrol GEÇTİ, 1423 sn** (uxgsl 32 · wasm_model 45 [15 program × AST+WASM+JS] · cli_flags 20 · numeric_model 20 · language_guards 32 · oop_parity 77 … — cli_flags/numeric/language_guards/oop artışları karar kuyruğunu yürüten diğer oturumdan). Önceki ara koşu: Tek koşucu `tests\run_all_model_tests.ps1` (2026-09-20 21:57, ön uç hızlandırmasından ve `help` takma adından sonra, tek iş olarak yeniden koşuldu): **10 paket, 342 / 342 kontrol GEÇTİ, 545 sn** (S-103 testi sonrası `array_params` 63; 5 paketlik ek koşu 225/225). Önceki koşu (20:10): 334/334, 425 sn.
(`numeric_model` 16 · `abi_model` 23 · `memoryref_model` 16 · `memory_model` 28 · `array_params` 59 · `sadd_model` 36 ·
`language_guards` 12 (+8 yeni test = 20) · `oop_parity` 73 · `iterators` 38 · `typed_task` 33). `operators_codex2` 24/24 önceki turda.
A/B (eski↔yeni ikili, ~372 dosya × AST+MIR, önceki tur): fark yalnız gürültü (VARPTR adres yazdırma, yük altında DLL/zaman aşımı) ve
bilinçli düzeltmeler. Bu tur ek A/B (eski↔yeni ikili, 473 dosya, tokens/AST/semantic/MIR/HIR/sembol/tip/yerleşim özetleri + metin + çıkış kodu): TAMAMLANDI — fark yalnız 3 dosya, üçü de Codex'in yeni `library_type_contract/rational_*` testleri (yeni özellik); başka fark yok.

## 5b. 2026-09-21 turu (Claude 1) — Mete'nin 9 kararı uygulanıyor

| Karar | Durum | Kanıt |
|---|---|---|
| S-110 varsayılan adım sınırı yok, `--max-steps N` | KAPANDI | `cli_flags` 20/20 |
| S-105 işaretsiz sınıf üyesi PUBLIC | KAPANDI | `oop_parity/default_public_access` |
| S-104 `MAIN…END MAIN` dışı çalıştırılabilir deyim = hata | KAPANDI | `language_guards` 32/32 (124 MAIN'li dosya taraması) |
| S-029 `uxb_parallel_run` sembolü + yüzey→ABI eşleme | KAPANDI | `manifests/abi_symbol_surface_map.csv`, surface runner "consistent" |
| S-088 `U32 op U32 → U32` | KAPANDI (AST/MIR/native/legacy/JS) | `numeric_model` 20/20; WASM değer doğrulaması ayrı |
| S-108 `DIM a AS Sınıf` = NULL | KAPANDI | `oop_parity` 102/102; 7 eski program düzeltildi |
| S-101 `LBOUND/UBOUND` | KISMEN (çekirdek 6 motorda) | `array_bounds` 34/34, `wasm_model` 54/54; açık: `DIM d()` sözdizimi (Mete'ye soru) |
| S-107 `FOR EACH` string/`IN a,b` | KAPANDI | `iterators` 44/44 (`string_each`, `neg_each_two_arrays`) |
| S-030 THREAD/PARALEL gerçek eşzamanlılık + TASK | SIRADA (çok oturumluk) | — |

Yolda bulunup kapatılan gizli hatalar: S-124 (AST `PRINT nesne.Metot()` iki kez çalıştırıyor), S-125 (native/legacy metot STRING sonucu sayı yazıyor; legacy tek argümanlı metot çağrısı derlenmiyor), S-126 (MIR yazılmamış alan boş basıyor), S-129 (WASM `SIZEOF(dizi)` 0), S-119 (çıplak alan/metot adı `THIS.` olmadan — dört motorda kapandı, `implicit_this` testi), S-130/131 (sınıf alanına bileşik atama/`++`/`--` canonical-MIR ve native'de sessizce yazmıyordu; native alan erişimi her alanı 8 bayt sayıyordu), S-132 (F32'ye sıfır-dışı değer atanamıyor — `CSNG` yanlış `TYPE_F64` kayıtlı, KARAR gerekmez). **S-133 (KRİTİK, 2026-09-22):** AST'de `IF dize = "metin" THEN` HER ZAMAN doğru sanılıyordu (dar tamsayı değerlendirici dizeleri `ValInt()` ile karşılaştırıyordu); ayrıca `<`/`>`/`<=`/`>=` hiçbir motorda (AST geniş değerlendirici, canonical-MIR) dize dalı yoktu; legacy x64'te de ayrı bir 32/64 bit işaret genişletme hatası aynı sıralama operatörlerini bozuyordu. Dört ayrı kök neden dört dosyada düzeltildi — bu, bugüne kadarki en geniş "sessiz yanlış" bulgusu (her `IF dize = ...` etkileniyordu). Açık kalanlar: S-118 (özyineleme derinliği), S-106 (Mete kararı — KAPANDI aslında, bkz. madde 3), S-111/S-117 kalanları.

## 6. Nasıl çalıştırılır

Her test klasöründe `run_*_tests.ps1` var (ör. `.\tests\oop_parity\run_oop_parity_tests.ps1`); AST, MIR, native x64
ve legacy AST-x64'te çalıştırıp `expected/` ile karşılaştırır. Hepsini tek komutla koşmak için: `.\tests\run_all_model_tests.ps1` (S-072 ilk parça; `-Only oop_parity,iterators` ile seçili paketler).
