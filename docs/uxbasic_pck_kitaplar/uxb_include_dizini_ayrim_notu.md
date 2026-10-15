# uXBasic INCLUDE / %%INCLUDE Ayrım Notu

Bu not, `tests` klasöründeki gerçek çalışma sonucu ile `pck` belgelerinde tanımlanan include davranışını eşleştirir.

## Kural

- `INCLUDE`, BASIC kaynak yüzeyinin parçasıdır.
- `INCLUDE`, `*.bas`, `*.uxb`, `*.uxbh`, `*.uxmh` dosyalarını BASIC kaynağa dahil eder.
- `%%INCLUDE`, preprocessor komutudur.
- `%%INCLUDE`, BASIC kaynak dosyalarını dahil etmez; bu yüzey için ayrı ve daha dar bir politikaya sahiptir.

## Kod akışı

- `uxb/src/preprocessor/preprocess_engine.fbs` içinde düz `INCLUDE`, preprocessor katmanında açılır.
- `%%INCLUDE` aynı yardımcı yolu kullanır ama BASIC kaynak uzantıları için reddedilir.
- `UXB_PREPROCESS_PLAIN_INCLUDE_ENABLED = 1` ile düz `INCLUDE` yüzeyi aktif çalışır.
- `uxb/src/parser/parser/parser_stmt_decl_core.fbs` tarafı `INCLUDE_STMT` için yol doğrulaması yapar.

## Test sınıflandırması

- `tests/adim15/positive/adim15_include_safe.bas`: pozitif; düz `INCLUDE` ile çalışır.
- `tests/adim07/negative/adim07_include_cycle_a.bas`: negatif; include döngüsü üretir.
- `tests/adim07/negative/adim07_include_cycle_b.bas`: negatif; include döngüsü üretir.
- `tests/adim15/negative/adim15_include_unsafe.bas`: negatif; güvenli olmayan yol reddedilir.

## Çalışma sonucu

- `tests/adim07` ve `tests/adim15` hedefli koşuda tüm senaryolar temiz geçti.
- Döngü testleri `negative` altına taşındı ve runner artık onları `PASS_NEGATIVE` olarak sınıflıyor.
- `adim15_include_safe` için kalan sorun, yanlış include katmanı değil; artık gerçek davranış doğru katmanda doğrulanıyor.

## Not

- `pck` dokümanları `INCLUDE` için başlık/destek dosyası anlamını, `%%INCLUDE` için ise preprocessor anlamını ayırıyor.
- Bu ayrım korunmalıdır; testler buna göre yazılmalıdır.

Bu arama yeterli. Büyük belge klasöründe daha fazla grep yapma. Şu bulguyu rapora yaz: dokümana göre INCLUDE normal uXBasic başlık/kaynak ekleme komutudur; %%INCLUDE preprocessor direktifidir. Kodda src\preprocessor\preprocess_engine.fbs içinde UXB_PREPROCESS_PLAIN_INCLUDE_ENABLED = 0 görünüyor. Şimdi yalnızca ilgili kaynak dosyaları ve testleri incele:

1) src\preprocessor\preprocess_engine.fbs
2) parser/semantic tarafında INCLUDE_STMT veya STMT_HANDLER_INCLUDE geçen dosyalar
3) tests\adim36_full_surface\positive\13_include_header_math.uxb
4) tests\adim36_full_surface\positive\14_include_nested.uxb
5) tests\adim36_full_surface\positive\62_plain_include_visibility.uxb
6) tests\adim36_full_surface\positive\68_adim43_plain_include.uxb
7) tests\adim36_full_surface\negative\95_include_cycle_a.uxb

Hedef: plain INCLUDE gerçekten preprocessor’da mı genişlemeli, yoksa parser/semantic tarafında mı çözülüyor? Bunu kanıtla. Sonra reports\copilot_round\include_inceleme.md dosyasına kısa rapor yaz. Henüz yama yapma.
