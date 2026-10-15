# Claude'a teknik yanıt ve onarım devri — 2026-09-13

Mete bu turda önceki denetimin ortak alana teslimini, soruların yanıtlanmasını ve iş paylaşarak onarımı istedi. Dil kararları değişmedi. Bu belge uygulama talimatı ve teknik incelemedir; bütün derleyicinin tamamlandığı iddiası değildir.

## Teslim edilen rapor

`UXB_ENGINE_AUDIT_2026-09-12_TR.md` önceki çalışma alanından byte değiştirilmeden bu klasöre kopyalandı. SHA256: `DDA13E61621EBA1090D7372995D12CC920831A168AECF1BC2A4E5F5350119E0E`.

Asıl konum: `C:/Users/mete/Documents/Codex/2026-09-06/u/UXB_ENGINE_AUDIT_2026-09-12_TR.md`. Test girdileri ve ham çıktılar aynı çalışma alanında `audit_inputs`, `audit_runs`, `engine_audit`, `both_*`, `motor_*` klasörlerindedir. Raporun sonundaki önceki yazma engeli tarihsel kayıttır; bu turda ortak klasöre teslim başarıyla yapıldı. Eski testler bugünün yeniden çalıştırılmış testi olarak etiketlenmez.

## 2026-09-11 09:05 tarihli üç soruna cevap

1. **Kullanıcı hatasında DLL içinden fatal+exit kullanma.** Mevcut `native/uxb_runtime/uxb_runtime.h` zaten `UXB_RT_SUCCESS/FAILURE` ve `uxb_last_error()` sunuyor; `uxb_runtime.cpp` exception'ları yakalayıp `RuntimeState::set_error` kullanıyor. `uxb_runtime_mir.cpp` host hatasında tanı ve hata dönüşü içeriyor; bu süreç sonlandırma mekanizması değildir. Yeni koleksiyon C ABI'si status + out-value dönsün. Emitter her status'u kontrol edip dilin kontrollü hata yoluna dalsın; yakalanmamış hatada CLI/native program nonzero dönmeli, sonraki kullanıcı ifadesi çalışmamalı. DLL kullanıcı programını key/index hatası yüzünden doğrudan kapatmasın. İç invariant bozulması için fatal ayrı olabilir; normal dil hata sözleşmesinin yerine geçmez. C++ exception ABI dışına kaçmamalı. Mevcut last_error global/mutex modeli thread-local sanılmamalı; eşzamanlılık için mesajın güvenli kopyalanması ayrıca tasarlanmalı.

2. **Üçlü sayısal taşıyıcı yalnız numerik değerler için yeterli.** STRING/ANY için açık kind sabitleri, ayrı pointer+byte-length ve kopyalama/ömür sözleşmesi gerekir. Girdi metni çağrı sırasında runtime-owned alana kopyalansın; çıktı caller-owned buffer+capacity+written/required length veya ömrü belgelenmiş immutable value handle üzerinden dönsün. Yalnız `const char*` embedded NUL ve geçici metin ömrünü tanımlamaz. `get_kind/get_i64/get_f64` şeklinde üç bağımsız çağrı mutasyon arasında farklı değer okuyabilir: tek status-returning get, scalar out-pointer'larla tutarlı snapshot üretsin. Bu struct-by-value gerektirmez. Native emitter'da Win64 register/stack, shadow space ve out-pointer yerleşimi gerçek DLL testiyle doğrulansın. BOOL, I64, F64, STRING ve desteklenen diğer kind'lar açık eşlensin; desteklenmeyen ANY kind sessizce 0 olmasın. Key dönüşümü `UXBInterpValueToString` ile aynı olmalı; sadece STRING kabul ederek dili daraltma.

3. **Native `0=invalid`, pozitif `slot+1` uygundur.** Canonical-MIR'nin iç 0-based id'siyle sayısal eşitlik gerekmiyor; handle opaque'dır. ABI adaptöründe dönüşüm açık olsun, kind/active/range denetimi her erişimde yapılsın. Native ham adres kullanıcı handle'ı değildir. Yeniden slot kullanımı eklenirse stale-handle/generation sözleşmesi gerekir. Program ömrü modeli şimdilik korunur; kullanıcıya yeni FREE eklenmez.

## Plandaki önemli ek düzeltmeler

- `mir_interp_collections.fbs` temel operasyonlar için referanstır; FOR EACH snapshot / DO EACH JIT davranışının bütün motorlarda uygulandığı kanıtı değildir. S-038, LIST'in MIR'de array sanıldığını kanıtlıyor. Önce collection/array discovery ayrımı ve iterator sözleşmesi; sonra native bağlama.
- Mevcut SET, anahtarı `UXBInterpValueToString` ile metne çevirip saklıyor. Eksik SETREMOVE başarılı/no-op; LISTREMOVE sınır dışı ve DICTGET eksik anahtar hata. DICT overwrite yerini değiştirmiyor. Bunlar ortak testte korunmalı.
- AST-direct x64 güvenli tanı açığı kapanmadan destek iddiası yok. MIR whitelist ancak emitter + runtime + link + gerçek EXE testi hazır olan operasyonlar için genişletilir.
- UXCollections ayrı açık kütüphane kalır. FFI çözücüsüne gizli eşleme, eski motor silme/taşıma, eski TASK INPUT/OUTPUT aliası yok. `SBYTE=I8`, `LONG=I32`, yalnız kısa parantezli cast kararı geçerli.

## İş paylaşımı ve sıra

| Sahip | İş | Kabul |
|---|---|---|
| Codex, bu tur | Rapor/yanıt teslimi; `src/build/x64_build_pipeline.fbs` native dizin/import-lib alt işi | Taze compiler + iç içe çıktı dizininde gerçek AST/MIR EXE; kapsam dışı CWD kusurları açık kalır |
| Claude, mevcut S-019 sahibi | S-019 + S-031/S-038 iterator/yerleşik koleksiyon; mevcut BYREF/DIM CLAIM alanları | Önce MIR discovery, sonra C ABI ve iki x64 emitter; dört yolda aynı çıktı ve kontrollü hata |
| Claude'a önerilen sonraki sıra | S-021/S-032/S-033/S-035/S-036 array-memory bütünlüğü | MEMCOPYD sessiz yanlış sonuç önce; local/global, bounds, resize, SIZEOF, copy vektörleri |
| Codex, sonraki ayrı tur | S-020/S-025 kabul karşılaştırması; S-022/S-023/S-026/S-027/S-042 web doğrulama | Kaynak sahipliği yeniden kaydedilerek yürütme bazlı karşılaştırma ve gerçek Node/WASM testi |
| Ortak, henüz başlanmadı | S-024/S-034 verifier; S-037 OOP; S-029/S-030 görev/ABI; S-039–S-043 release/araç kayıtları | Rapordaki her iddia ayrı yeniden üretimle kapatılır |

S-028'in preprocessor sabit output yolu ve diğer CWD bağımlılıkları native alt düzeltmeyle otomatik kapanmaz. Claude, önişlemci CLAIM'in hâlâ aktif olup olmadığını günlükte bildir; Codex bu tur o dosyaya girmiyor. Önerilen gelecek işler yeni aktif CLAIM değildir. Uygulama başlamadan dosyalar DURUM'a yazılır.

Her kapanış: kaynak/ikili hash, tam komut, CWD, stdout/stderr, exit code, sonuç türü (`taze çalıştırılmış`, `statik`, `emit-only`, `tarihsel`, `bloklu`). Emit/NASM PASS tek başına native çalışma değildir. S-019 plan incelemesi bu yanıtla tamamlandı; uygulama ve bağımsız kabul henüz tamamlanmadı. Claude'un okuduğu/başladığı ancak onun günlük yanıtıyla doğrulanabilir.

## Native build alt işi sonucu — 2026-09-13

`src/build/x64_build_pipeline.fbs` düzeltildi: mevcut report_writer recursive parent-directory yardımcısı kullanılıyor; runtime import-lib compiler konumundan da aranıyor; runtime DLL/dependency yolları bulunan import-lib ve compiler dizinine dayanıyor; linker response-file yolu boşluklar için tırnaklanıyor.

Taze host build: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/build_uxb_main_64.ps1 -Root . -Force -SkipX86`; FreeBASIC 1.10.1, exit 0, 60.664 saniye. Log: `reports/coordination_20260913_build.log`. Compiler SHA256: `f726a55f2a94ea742d55f05dbddcc032cc4bef9599592b46d20a6225d34d37cd`.

Kabul komutları (CWD uxb):

- `python tests/coordination_20260913/run_native_build_probe.py`
- `python tests/coordination_20260913/run_native_build_probe.py --cwd ..`

Sonuç: iki CWD x iki native rota = **4/4 gerçek EXE PASS**. Her biri `NATIVE_BUILD_PATH_PASS` ve `42`, exit 0. Yeni, iç içe ve boşluk içeren çıktı yolları kullanıldı. Manifestler tam komut, CWD ve ikili hash taşır:

- `reports/coordination_20260913/20260913_090204/acceptance.json`
- `reports/coordination_20260913/20260913_090226/acceptance.json`

Kapsam sınırı: S-028 TAMAMEN KAPANMADI. Test CWD'lerinde önceden mevcut build ağaçları vardı; boş yeni CWD, preprocessor sabit çıktı yolu, FFI allowlist ve bütün artifact izolasyonu kabul edilmedi. Standalone dağıtım/BigFP/FFI dependency matrisi bu dar scalar native testle doğrulanmış değildir. Tam dil regresyonu veya S-019 uygulanmış sayılmaz. Codex bu build alt işini bıraktı; kaynak dosyası üzerinde aktif değişiklik kalmadı. Claude kendi S-019 uygulamasını yukarıdaki düzeltilmiş sözleşmeye göre ilerletebilir ve ortak günlükte aldığı alanları bildirmelidir.
