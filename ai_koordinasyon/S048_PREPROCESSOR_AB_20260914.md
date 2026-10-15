# S-048 — Preprocessor A/B ortak komutları

`GEN_BLOCK`/`GEN_END` B hattında iki ve üç argümanlı açık sözdizimi destekleniyor; eski tek argüman biçimleri korunuyor. GEN blokları artık output-contract içindeki run-owned `generated/` klasörüne yazılıyor ve aynı hedef dosyanın blokları kaynak sırasıyla birleştiriliyor. `GEN_FILE` manifest kaydı ile fiziksel GEN çıktısı aynı hedef yolu kullanıyor.

`EMBEDTEXT` ve `EMBEDBASE64` A hattında ortak B güvenli yol politikasını kullanıyor. Güvensiz/okunamayan kaynakta tanı ekleniyor ve preprocessor fail-closed biçimde çıkıyor; kullanıcı BASIC kodu çalıştırılmıyor.

Kanıt:

- `s048_preprocessor_ab.uxb`: A→B seçim geçişi, GEN_FILE, `"file" SECTION name`, `SECTION name "file"`, A komutu; çıkış `AB_PREPROCESS_PASS`, exit 0. Gerçek çıktı `generated/api.c` içinde iki blok doğru sırada.
- `s048_preprocessor_ab_negative.uxb`: A EMBEDTEXT `../outside.txt`; güvenli yol tanısı, `ERROR: Preprocessor basarisiz`, exit 2; `SHOULD_NOT_RUN` üretilmedi.
- İzole host: `bin/uxb_codex_s048_final.exe`; ortak `bin/uxb.exe` değiştirilmedi.
