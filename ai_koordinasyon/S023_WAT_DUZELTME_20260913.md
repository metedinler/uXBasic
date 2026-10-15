# S-023 — WAT bellek yardımcıları düzeltmesi

2026-09-13, Codex. Mete'nin silme/formatlama yasağı geçerlidir. Claude'un BYREF, iterator ve koleksiyon dosyaları değiştirilmedi.

`src/codegen/wasm/wat/wat_memory.fbs` içinde load/store/fill'in iç içe if/else ifadelerindeki eksik iki kapanış parantezi tamamlandı. Fill'in yerel değişken bildirimi ilk yürütülebilir komuttan önceye alındı. Dil veya ABI yüzeyi genişletilmedi.

Kabul komutu (CWD: uxb): `python tests/coordination_20260913/run_wat_memory_probe.py`.

- Önce: `reports/coordination_20260913/wat_20260913_130030_691081/acceptance.json`; gerçek FreeBASIC emitter çıktısı wat2wasm aşamasında `unexpected token (, expected )`, exit 1.
- Sonra: `reports/coordination_20260913/wat_20260913_130110_578937/acceptance.json`; FreeBASIC emitter, wat2wasm, wasm-validate ve Node gerçek WASM çalıştırma exit 0; `WAT_MEMORY_RUNTIME_PASS`.

Testler: 1/2/4 byte load/store/fill/copy; boş fill; örtüşen copy; embedded NUL içeren sequence read/write; desteklenmeyen genişlik, sınır dışı adres, uzun sequence ve mode=2 hata yolları. Kaynağın gerçek fonksiyonu include edilerek çalıştırılır; metinden tahmini WAT üretimi değildir. Kaynak hash ve tam komutlar manifestlerdedir.

Kapanış kapsamı yalnız S-023 helper sentaksı ve yukarıdaki runtime vektörleridir. Tam BASIC->web/host/JS/WASM dil eşdeğerliği, S-026/S-027 ve diğer açık maddeler bu sonuçla kapanmaz. Dosya sahipliği test ve ana derleme tamamlanınca DURUM'da serbest bırakılacaktır.

Ana derleyici build tamamlandı: 2026-09-13 13:03 +03:00, 99.419 saniye, exit 0. bin/uxb.exe SHA256: EBBD8598333999EBDEF16E70F77D5D2E05B28152D0E2AB9B2621B82AE7DC4079. Log: reports/libraries/logs/compiler_x64_fbc.log. Kaynak alanı serbest bırakıldı. git diff --check bu değişiklikler için PASS.

