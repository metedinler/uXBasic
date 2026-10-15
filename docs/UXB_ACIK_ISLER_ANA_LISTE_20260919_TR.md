# uXBasic — Açık İşler Ana Listesi (2026-09-19)

Kaynak: Mete'nin 2026-09-19 tüm-sistem incelemesi + Claude 1'in aynı gün güncel `bin/uxb.exe` (SHA256 `64A01B72…E1316`) ile YAPTIĞI doğrulama. Ölçüt: "eski raporda açık görünüyordu" ile "bugün gerçekten açık" ayrıldı; her satır çalıştırılarak veya koddan okunarak sınandı. **Mete'nin talimatı (2026-09-19): tüm ertelemeler kaldırıldı — S-052/S-053/S-056/S-067 dahil hiçbir madde "ertelendi" durumunda bırakılmaz; sıra aşağıdaki gibidir.** Ayrıntılar `ai_koordinasyon/SORUN_TAKIP.md` S-numaralarında.

## A. İncelemedeki iddialardan bugün ESKİ/YANLIŞ çıkanlar (yeniden yapılacaklar listesine ALINMAZ)

| İddia | Gerçek durum (2026-09-19) |
|---|---|
| "AUTO tasarım tamam, kodlanmadı" | **Kodlandı ve doğrulandı** (S-069): pointer-tipli adres → NATIVE, düz sayı → VIRTUAL, açık mod kazanır; `tests/memory_model/` 28/28. |
| "Skaler VARPTR canonical-MIR'de sorunlu" | **Düzeltildi, dört motorda** (S-071 ek): tipli ham hücre; AST/MIR/x64/legacy birebir. |
| "MEMFILLW/D/Q parser eşliği eksik" | **Düzeltildi** (S-069): üçü de `ParseMemoryStmtOptionalMode`. |
| "PEEK*/POKE*/MEMCOPY*/MEMFILL* öneksiz nihai davranış yok" | **Uygulandı** (S-069). |
| "uxstats2.uxmh var olmayan yola bakıyor" | **Eski**: başlık zaten `libsx/uxstats/uxstats2.bas`'ı gösteriyor ve dosya var. |
| "MIR PRINT hata olunca öncekileri kaybediyor" | **Kısmen düzeldi** (S-074): hata öncesi çıktı artık gösteriliyor; DLL çıktısıyla sıra farkı açık. |
| "uxterminal temel eksik" | Zaten kapalı (S-053). |

## B. Bugün GERÇEKTEN açık olanlar — ÇALIŞMA SIRASI

Mete'nin onayladığı sıra: **1) F80 sözleşmesi (yük 10 / adım 16) → 2) U64 → 3) MemoryRef →** ardından aşağıdakiler.

| # | İş | S-no | Doğrulama (2026-09-19) |
|---|---|---|---|
| 1 | ~~**F80 fiziksel sözleşmesi**~~ — **KISMEN YAPILDI-DOGRULANDI (2026-09-20)**: tek ABI tablosu (`type_abi.fbs`), `SIZEOF` dört motorda, native x64 F80 dizisi gerçek x87, `MIR_ARRAY_SIZEOF`; `tests/abi_model` 7/7. Kalan: S-091 (legacy F80 PRINT bağlama), S-092 (AST F80 ham depo biçimi). | S-079, S-082 | `SIZEOF(F80)`=10 her motorda; F80 dizi hücresi 16. |
| 2 | ~~**U64 işaretsiz anlambilimi**~~ — **YAPILDI-DOGRULANDI (2026-09-20)**: dil kuralı (U64 baskın), yeni MIR opcode'ları `UIDIV/UMOD/ULT/ULE/UGT/UGE`, dört motor + JS/WASM opcode desteği; `tests/numeric_model` 16/16. Kalanlar: S-085 (JS/WASM 64-bit modeli), S-086, S-087, S-088. | S-077 | `u=0-1` → `18446744073709551615`; `u>5` doğru (dört motor). |
| 3 | ~~**MemoryRef**~~ — **KISMEN YAPILDI-DOGRULANDI (2026-09-20)**: v1 = NATIVE adresler için bölge kaydı + tek çözümleyici (AST, canonical-MIR, native x64; dizi sınırı + REDIM sonrası bayat işaretçi); `tests/memoryref_model` 16/16. Kalanlar S-094 (legacy, skaler VARPTR, FFI, ilk-sınıf MemoryRef değeri). | S-056, S-094 | `PEEKD(p+16)` bir-ötesi ve `REDIM` sonrası eski işaretçi artık temiz hata. |
| 4 | ~~**Dizi parametresi** `arr AS I32[]`~~ — **YAPILDI-DOGRULANDI (2026-09-20)**: gerçek alt sınırla indekslenir, çağıranın dizisine referanstır; dört motor + JS (`tests/array_params` 59 kontrol; WAT geçerli 5/7). Native x64 dizi tanımlayıcısı (işaretçi + alt + üst sınır) + sınır denetimi, legacy "eğimli taban", derleme zamanı argüman doğrulaması. Yolda bulunup kapatılanlar: S-097 (sınır denetimi paritesi; legacy açık), S-098 (legacy çerçeve boyutu — fonksiyon içinde I32 `FOR` tek tur dönüyordu), S-099 (dar dizi elemanı işaret genişletmesi + float dizi aritmetiği). Kalan: S-103 (TYPE elemanlı dizi parametresi, callee'de REDIM), S-100 (WASM'da global dizi), S-101 (LBOUND/UBOUND kararı). | S-068, S-096..S-103 | `SumArr(a,4)` `10`, alt sınırı 1 dizide `arr(1)` ilk eleman. |
| 5 | ~~**Array adres yüzeyi**: `VARPTR(a(i))`; `SIZEOF(array)`~~ — **YAPILDI-DOGRULANDI (2026-09-20)**: anlamsal geçişte `VARPTR(a(i))` → `VARPTR(a) + (i-LBOUND)*adım` (dört motor), `MIR_ARRAY_SIZEOF` yürütülüyor; ek olarak `VARPTR` argüman doğrulaması her ifade bağlamında. `tests/abi_model/varptr_array_element` 4/4. Kalan: çok boyutlu / dinamik sınırlı / TYPE dizisi eleman adresi (net hata veriyor). | S-081 / S-082 | `VARPTR(a(2))` → `PEEKD` `12` dört motor. |
| 6 | ~~**STRUCT-array bileşik atama** `pts(i).X += v`~~ — **YAPILDI-DOGRULANDI (2026-09-20)**; test sırasında bulunan TYPE-alan hataları (F64/F32/I64/U64/I8; dört motor) da S-095 ile kapandı. `tests/abi_model` 19/19. | S-080, S-095 | dört motor `8`. |
| 7 | ~~**SADD/LPTR/CODEPTR** gerçek adres~~ — **YAPILDI-DOGRULANDI (2026-09-20)** dört motorda: `PEEKB(SADD(s))` gerçek NUL sonlu veri (yorumlayıcılarda sabit havuz, native'de string zaten işaretçi), `CODEPTR/LPTR` native'de gerçek adres (legacy artık derleniyor), yorumlayıcılarda net "requires native x64" (uydurma adres kaldırıldı); `tests/sadd_model` 36/36. Kalan: `STRPTR(s)` işlev/tür kararı, `WSTRPTR`, `SETNEWOFFSET` anlamı, SADD için MemoryRef. | S-076 | `PEEKB(SADD("Hi"))` `72` dört motor. |
| 8 | **Büyük literaller**: 2^53 üstü AST/MIR'de `Double`'dan geçiyor; MIR-x64 `&h` >32-bit. | S-078 | `9223372036854775807 + 10` motorlar farklı. |
| 9 | **OOP parity** — **KISMEN YAPILDI-DOGRULANDI (2026-09-20)**: 13 senaryo dört motorda birebir (kalıtım, sanal dağıtım, SUPER, THIS/ME, arayüz [legacy hariç], yıkıcı zinciri, açık PRIVATE/PROTECTED); `tests/oop_parity` 67/67. Ölçümle 8 gerçek hata bulundu ve kapandı (canonical-MIR `NEW` sonucu hiç saklanmıyordu; SUPER; THIS/ME tip çıkarımı; AST `a = d` çalışma zamanı sınıfı; AST'de miras alınan virtual olmayan yöntem reddi...). Kalan: S-105 (legacy arayüz dağıtımı; üye erişim VARSAYILANI kararı), S-106 (değişken/sınıf adı çakışması). | S-037, S-105, S-106 | `a = NEW Dog() : a.Speak()` dört motorda `2`. |
| 10 | **Genel iterator sözleşmesi** — **KISMEN YAPILDI-DOGRULANDI (2026-09-20)**: LIST/SET/DICT/dizi `FOR EACH`/`DO EACH` AST, canonical-MIR ve native x64'te aynı (`tests/iterators` 38/38); ölçümle native SET'te sessiz yanlış değer ve AST'de sayısal değişkene string bağlama bulunup kapandı. Kalan: STRING/çok kaynaklı/kullanıcı tanımlı yinelenebilir (S-107, KARAR), legacy koleksiyon iteratörü (S-019). | S-038, S-107 | `FOR EACH x IN s` (SET) dört değil üç motorda `7|9`; legacy temiz reddediyor. |
| 11 | **Gerçek typed paralellik** (thread/oneTBB). | S-030 | (önceki denetim) |
| 12 | **uxgsl** callback/root smoke — **KISMEN (2026-09-20)**: "stale or invalid pointer handle token" nedeni S-076'ydı (AST'nin uydurma `CODEPTR` adresi); AST artık net "requires native x64" veriyor. Native çalıştırma için `bin\uxgsl.dll` üretilmemiş (msys2 GSL bağımlılıkları + `build_uxgsl_dll.bat`) — ortam işi açık. | S-075 | AST net hata; native: DLL yok. |
| 13 | **Gate altyapısı**: tek koşucu, kırık girdiler (adim41 CSV yok, adim08 rapor/exit uyuşmazlığı…). | S-072 | 5 geçti / 5 düştü / 1 fırlattı. |
| 14 | **FFI ölçekleme**: 400→1600 `CALL(DLL)`'de derleme süresi doğrusaldan kötü (23 sn → 250+ sn). | S-054 | Ölçüldü. |
| 15 | ~~**SUB MAIN çakışması**~~ — **YAPILDI-DOGRULANDI (2026-09-20)**: `MAIN` rezerve ad; `SUB/FUNCTION MAIN` dört motorda net anlamsal hata (`tests/language_guards` 8/8). Yeni açık karar: `MAIN ... END MAIN` bloğundan sonraki üst düzey deyimlerin anlamı motorlar arasında farklı (S-104). | S-067, S-104 | `SUB MAIN()` artık dört motorda aynı hata. |
| 16 | **WASM `BYREF`** (`paramByRef`). | S-051 ek | (önceki denetim) |
| 17 | ~~**POKED-only** programda ADIM25/26/27 kapısı~~ — **YAPILDI-DOGRULANDI (2026-09-20)**: kapı `MIR_MEMORY_STORE` yerine `MEMORY_STORE` arıyordu (öneksiz), yalnız başka bir opcode varsa kazara geçiyordu; MIR opcode kümesi artık iki yazımı da içeriyor. `tests/language_guards/memory_statements_alone`. | S-075 | `POKED 100,777` tek başına dört motorda derleniyor/çalışıyor. |
| 18 | **uxraylib / uxsdl3** ertelenmiş yüzeyler (Models/3D, Shaders, Image; joystick, clipboard, text-input). **Ertelenme Mete tarafından kaldırıldı.** | S-052 | — |
| 19 | **Native x64 geçersiz NATIVE adreste erişim ihlali** → SEH ile temiz hata. | S-069 sınır | `POKED PTR(1000),7` çöker. |
| 20 | **MIR PRINT ↔ doğrudan DLL çıktısı sıralaması.** | S-074 | uxterminal testi. |

## B2. 2026-09-20'de S-077 sırasında bulunan YENİ işler

| # | İş | S-no | Durum |
|---|---|---|---|
| 21 | Tek satır `IF … THEN a ELSE b` iki dalı da çalıştırıyor (tüm motorlar) | S-083 | ACIK |
| 22 | Değişken adı tür adıyla çakışınca (`i64`) yanlış çıktı | S-084 | ACIK |
| 23 | JS/WASM 64-bit tamsayı modeli (BigInt / i64 hattı) | S-085 | KISMEN (U-opcode'lar tamam) |
| 24 | Legacy AST-x64 tamsayı `/`, `CDBL/CSNG`, U64→F64 | S-086 | ACIK |
| 25 | native x64 `STR(U64≥2^63)` işaretli; AST `HEX` yok | S-087 | ACIK |
| 26 | `U32-U32` geçici sonuç sarma kararı (C uyumu) | S-088 | KARAR-BEKLIYOR |
| 27 | AST'de kalan 32-bit kırpan tüketicilerin taraması | S-089 | KISMEN |
| 28 | AST yorumlayıcı çok yavaş (300 bin döngü ≈ 2 dk) | S-090 | ACIK |
| 29 | Sabit katlayıcı `Double` taşıyıcı (2^53 üstü kesin değil) | S-078 (kalan) | ACIK |
| 30 | Legacy F80/F128 PRINT: `uxb_f80_to_str` bağlanmıyor | S-091 | ACIK |
| 31 | AST F80 dizi deposu Double (x87 baytları değil) | S-092 | ACIK |
| 32 | Legacy AST-x64 `DIM a(N)` N+1 eleman ayırmıyordu (a(N) komşu değişkenle çakışıyordu) | S-093 | YAPILDI-DOGRULANDI |
| 33 | MemoryRef v1'in kapsamadıkları (legacy, skaler VARPTR, FFI, ilk-sınıf değer) | S-094 | ACIK |

## C. Kural
Yeni her bulgu `SORUN_TAKIP.md`'ye numarayla işlenir; bu liste her iş kapandığında güncellenir (durum sütunu yerine ilgili S-numarası `YAPILDI-DOGRULANDI` olur).
