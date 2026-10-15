# uXBasic hata merkezi ve raporlama politikası

Bu belge test/release-candidate aşamasında geçerli çıktı politikasını özetler.

## 1. Dosya silme yoktur

Yapay zekâ veya araçlar kullanıcı adına kaynak dosya silmez. Gereksiz görülen dosyalar yalnız raporlanır veya kullanıcı onayıyla emekli zipine kopyalanır.

## 2. uXBasic compiler resmi çıktı kökü

Compiler tarafından üretilen resmi çıktılar çalışma kökündeki `build/<run_id>/<dosya_tipi>/` yapısına yazılır.

- JSON: `build/<run_id>/json/`
- ASM: `build/<run_id>/asm/`
- OBJ: `build/<run_id>/obj/`
- EXE: `build/<run_id>/exe/`
- DLL: `build/<run_id>/dll/`
- WEB/JS/WAT/WASM/HTML: `build/<run_id>/web/`
- LOG ve klasik compiler logları: `build/<run_id>/logs/`

`--artifact-root <kok>` verilirse aynı düzen `<kok>/<run_id>/<dosya_tipi>/` altında kurulur.

## 3. Hata merkezi

Merkezi hata sistemi `src/common/error_system_adim45.fbs` dosyasındadır. `runtime/diagnostics.fbs` bu merkezi include eder.

Aşağıdaki çağrılar hata merkezine yansıtılır:

- `UxbError`
- `DiagHata`
- `UxbWarn`
- `UXBDiagnosticPush` ile eklenen structured diagnostic kayıtları

Var olan log/JSON/CSV/MD raporları korunur. Hata merkezi bu raporların yerine geçmez; yalnız ek merkezi log hattıdır.

Varsayılan merkezi hata logu:

`build/manual/logs/uxbasic.hata.log`

Normal çalışmada `main_program_entry.fbs`, run-id oluştuğunda hata logunu `build/<run_id>/logs/uxbasic.hata.log` yoluna yönlendirir.

## 4. Python araçları

Python araçları uXBasic compiler’ın FreeBASIC kaynak koduna veya compiler’ın resmi çıktısına müdahale etmez. Kendi raporlarını `reports/current/` altına yazar.

Bir Python rapor aracı yeni rapor üretmeden önce mevcut `reports/current/` içeriği `reports/history/` altına zaman damgalı zip olarak arşivlenebilir. Bunun için ortak araç:

`tools/report_current_archive.py`

Varsayılan davranış eski raporları silmez; yalnız zip arşivi oluşturur. `--clear-current` verilirse sadece rapor klasörü temizlenir, kaynak kodlara dokunulmaz.

## 5. dist ve reports/control/current politikası

- `dist/` dağıtım amacı için ayrıdır; aktif compiler çıktısı için kullanılmaz.
- `reports/control/current/` yerine Python araçları `reports/current/` kullanır.
- Eski scriptlerde kalan legacy yollar raporlanır; aktif release runnerlar yeni politikaya geçirilir.
