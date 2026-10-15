# uXBasic motor mimarisi — ortak tartışma notu

**Durum:** karar-bekliyor. Bu dosya bir silme veya emeklilik planı değildir.
Mete, Codex ve Claude'un aynı kanıt tabanı üzerinden karar verebilmesi için
envanter ve seçenekleri ayırır.

## Değişmez kurallar

1. Kullanıcıya sunulan her çalıştırma/üretim yolu aynı gözlemlenebilir uXBasic
   semantiğini vermelidir. Fark varsa ya düzeltilecek ya da açıkça destek dışı
   bırakılması Mete tarafından kararlaştırılacaktır.
2. Bir kaynak kümesinin CLI'dan görünmemesi, kullanılmadığını kanıtlamaz.
   Test, araç API'si, derleme-yardımcısı ve gelecekteki platform kullanımı
   ayrı kanıttır.
3. Harita tamamlanmadan hiçbir motor dosyası silinmez, taşınmaz, yeniden
   adlandırılmaz veya "ölü" diye yorumlanmaz.
4. Bu notta karar sahibi Mete'dir. Codex öneri/kanıt sentezini, Claude ise
   bağımsız uygulama etkisi ve doğrulama planını yazar.

## Başlangıç envanteri — doğrulanacak hipotez

| No | Küme | Bilinen giriş/amaç | Henüz kanıtlanmayan nokta |
|---|---|---|---|
| 1 | AST yorumlayıcı (`src/runtime/exec/`) | `uxb run` | Destek sözleşmesindeki kalıcılığı |
| 2 | Kanonik MIR yorumlayıcı (`src/interpreter/mir/`) | `--interpreter-backend MIR` | Tüm ürün/test tüketicileri |
| 3 | MIR x64 (`src/codegen/x64/mir_x64_*`) | varsayılan x64 derleme | Hedef platform ve fallback sınırı |
| 4 | AST-direct x64 (`src/codegen/x64/code_generator.fbs`) | `--x64-mode AST` | Uyum katmanı mı, kalıcı ürün yolu mu |
| 5 | MIR evaluator (`src/semantic/mir_evaluator*.fbs`) | En az test/araç çağrıları araştırılacak; `MIRRunModule` test çağrıları bulundu | Son-kullanıcı CLI yolu ve canlı yardımcı semboller |
| 6 | AST interpreter API (`src/interpreter/ast/`) | `interpreter_public_api` ilişkisi araştırılacak | CLI, test, araç veya platform tüketicileri |

## Codex kaynak kanıtı — 2026-09-11 ilk geçiş

Bu bölüm yalnız kaynak taraması kanıtıdır; "dahil ediliyor" ile "son kullanıcı
çalıştırıyor" aynı anlama gelmez.

| Küme | Doğrulanan yol | Şimdiki sonuç |
|---|---|---|
| AST çalışma zamanı | `src/main_program_entry_part2.fbs:58` → `ExecRunMemoryProgram`; tanım `src/runtime/memory_exec.fbs:4079` | CLI AST yolu gerçek ana yürütme yoludur. |
| Kanonik MIR yorumlayıcı | `main_program_entry_part2.fbs` canonical köprüyü kurup `UXBMIRInterpRunInstructions` çağırır | `--interpreter-backend MIR` gerçek ayrı yürütme yoludur. |
| AST-direct x64 | `x64_build_pipeline.fbs:490` → `GenerateX64Code`; CLI `--x64-mode AST` kabul eder | Ayrı native üretim yoludur; S-001 dört-motor parity kapsamındadır. |
| MIR x64 | `x64_codegen.fbs` → `MIRX64EmitModule`; `bld` varsayılanı MIR'dir | Ayrı native üretim yoludur. |
| Eski MIR evaluator | `src/semantic/mir.fbs` evaluator'ı ana derleyiciye dahil eder; `MIRRunModule` doğrudan çok sayıda `tests/run_*_mir*` ve `tests/helpers/mir_test_common__dup1.fbs` tarafından çağrılır | Kullanıcı CLI yürütmesi olduğuna dair kanıt yok; fakat testlenen ve ana derlemeye dahil bir API bileşenidir. Silme/etiketleme için yeterli değildir. |
| AST interpreter API | `src/main.bas` → `main_interpreter_include_bundle.fbs` ile AST/MIR interpreter kaynaklarını ana derleyiciye dahil eder; `runtime/exec/ast_contract_interpreter_bridge.fbs` AST registry kararlarını kullanır | `UXBRunAstInterpreterPublic` için doğrudan ürün çağrısı henüz bulunmadı; ancak registry/contract bağı canlıdır. Kök-yürütücü ve sözleşme sağlayıcısı ayrıştırılmalıdır. |

**İlk çıkarım:** "altı motor" ifadesi kullanıcı açısından yararlı bir alarmdır,
ama teknik sınıflandırma henüz kesin değildir. Şu anda dört kullanıcı seçilebilir
yol, bir doğrudan test API'si ve bir derleyiciye dahil edilmiş AST sözleşme/API
katmanı kanıtlandı. Bu üç farklı rol azaltma kararından önce ayrılmalıdır.

## Önce kanıtlanacak sorular

1. Her kümenin public fonksiyonlarını, çağıranlarını ve build include zincirini
   listele. "Sıfır çağıran" sonucu testler, wrapper'lar ve üretilmiş dosyalar
   hariç/dahil belirtilmeden geçerli değildir.
2. Hangi CLI bayrakları ve hangi desteklenen hedefler her yolu seçer? Varsayılan
   olmayan bir yolun kullanıcı/sürüm uyumluluğu sorumluluğu var mı?
3. Dört canlı yol için bugün fark üreten semantik tabloları belirle ve ortak
   çıktı vektörlerine bağla. Öncelik: parametre daraltma, `LONG`, sayı castleri,
   hata/yakalama, koleksiyon dolaşımı, PEEK/POKE ve callback/FFI sınırı.
4. Her yolun benzersiz kabiliyeti, bakım maliyeti, test kapsaması ve fallback
   gerekçesi nedir? Bu bilgi olmadan motor sayısı hakkında azaltma kararı
   verilemez.

## Tartışılacak mimari seçenekleri

| Seçenek | Olası yarar | Ön koşul ve risk |
|---|---|---|
| A — Tüm mevcut yolları koru | En yüksek geriye uyumluluk ve çapraz doğrulama | Ortak semantik vektörleri, sahiplik ve sürüm maliyeti gerekir |
| B — Canlı yolları koru, erişilmeyen API'leri belgele | Kullanıcı davranışını değiştirmeden görünürlük sağlar | API/test/yardımcı kullanımlarının tam haritası gerekir |
| C — Yol azaltma için geçiş planı | Uzun vadede daha az tekrar eden kod | Mete onayı, kullanım telemetrisi/kanıtı, yedekli sürüm, çıkış ölçütü ve geri dönüş planı gerekir |

Şu aşamada A/B araştırma seçenekleridir; C için karar veya uygulama yetkisi
yoktur.

## İlk görevler

| İş | Uygulama sahibi | Çıktı |
|---|---|---|
| Çağrı/build/CLI haritasını kaynak kanıtıyla çıkarma | Codex | Bu nota kaynak-yol tablosu ve açık boşluklar |
| Her kümenin uygulama etkisi ve mevcut testleri | Claude | Aynı nota ek kanıt ve çakışma riski |
| Ürün hedefi, destek süresi ve azaltma eşiği | Mete | Karar kaydı |

## Claude'a güncel ileti

Mete'nin son kararları: `TASKIN`/`TASKOUT` resmi adlardır; önceki `INPUTS`
önerisini kullanma. `I16(x)` gibi kısa türler parantezli casttir; `SHORT(x)`
ve `LONG(x)` uzun bildirim adları kasıtlı olarak çağrı değildir. Motor 5/6 için
silme, taşıma veya "ölü" etiketi yok. `MIRRunModule` test çağrıları bulunduğu
için yalnız CLI'da görünmeme, kullanım yokluğu kanıtı değildir.

Lütfen aktif dosyalarını, `TASKIN`/`TASKOUT` producer/consumer haritanı ve
AST-direct x64 S-001 test sonucunu `DURUM.md` ile `SORULAR_CEVAPLAR.md`ye
ekle. UXCollections ve preprocessor CLAIM alanına Codex girmeyecektir.

## 2026-09-11 — Codex ikinci kanıt turu: fayda ve bakım yükü ayrımı

Mete'nin itirazı kabul edilmiştir: bir CLI denemesi yalnız o komut satırı
rotasını kanıtlar. Test, public API, derleyici include zinciri ve tarihsel
uyumluluk tüketicisi ayrıca sayılmadan "erişilemiyor" veya "ölü" denemez.

| Küme | Yeni kaynak kanıtı | Fayda hükmü | Bakım hükmü |
|---|---|---|---|
| 1–4, dört kullanıcı yolu | CLI ve sürüm betikleri AST/MIR yorumlayıcılarını; varsayılan MIR-x64 ve seçilebilir AST-x64 üretimini gerçekten çağırıyor. Mevcut parity vektörleri bu yolların ayrışabildiğini de kanıtlıyor. | **Gerekli.** Birbirini doğrulayan kullanıcı yolları ve geriye uyumluluk yüzeyidir. | **Yüksek.** Aynı semantiğin dört uygulaması vardır; ortak çıktı vektörü zorunludur. |
| 5, semantic `MIRRunModule` evaluator | `src/semantic/mir.fbs` ana compiler include zincirine evaluator'ı alır. Kaynak/test taramasında `MIRRunModule(` için 19 eşleşme bulundu; helper, CALL/DLL/API, hata ve CFG testleri bunu doğrudan çağırır. PEEK/POKE/VARPTR için kendine özgü tarihsel bellek yolu da vardır. | **Yararlı fakat ürün-CLI motoru olduğu kanıtlanmış değil.** Bugün test/reference executor ve eski davranışın kanıt kaynağıdır. | **Orta-yüksek.** Canonical MIR ile ikinci semantik oluşmaması için yeni dil özelliği buraya önce eklenmemeli; davranış matrisiyle sınırlandırılmalıdır. |
| 6, `src/interpreter/ast` + public API | `main_interpreter_include_bundle.fbs` tüm AST interpreter parçalarını ana derleyiciye dahil eder. `interpreter_public_api.fbs`, AST/MIR public wrapper'larını sağlar. `runtime/exec/ast_contract_interpreter_bridge.fbs`, AST registry kararlarını canlı runtime contract'a bağlar. Statik taramada public AST-run wrapper'ının tanımı dışında doğrudan ürün/test çağrısı bulunmadı. | **Yararlı altyapı/reference API; ürün-CLI yürütücüsü olduğu kanıtlanmış değil.** Contract doğrulama ve dış/gelecek araç çağrısı için korunmalıdır. | **Orta.** Çalıştırma semantiği `runtime/exec` ile tekrarlandığı için feature-parity maliyeti oluşur; çağıran envanteri ve ayrı smoke olmadan kaldırma kararı verilemez. |

### Teknik sonuç ve öneri

Bugün teknik sınıflandırma "altı eşit ürün motoru" değildir: dört kullanıcı
seçilebilir yürütme/üretim yolu, bir test/reference semantic-MIR executor ve
bir AST reference/public API vardır. Bu ayrım, beşinci ve altıncının yük
olmadığı anlamına gelmez: kod boyutu, derleme süresi ve özellikle semantik
parity maliyeti gerçektir. Fakat bugünkü kanıt, onları silmenin veya
erişilmez etiketi vermenin riskini maliyetten daha büyük gösterir.

Önerilen geçici politika: dört kullanıcı yolunda aynı sonuç zorunlu; yeni dil
özelliği önce canonical MIR sözleşmesi ve ortak vektörle tanımlansın; küme 5
ancak test/reference gereksinimi olduğunda, küme 6 ancak contract/public API
smoke'ı ile güncellensin. Ölçülmüş çağıran envanteri, ayrı smoke kapsamı,
desteklenen hedef listesi ve geri dönüş planı olmadan azaltma konusu Mete'nin
kararına sunulmasın. Bu bir silme veya emeklilik kararı değildir.
