# S-028 günlük ve adım5 çıktı izolasyonu

Tarih: 2026-09-14 12:38 +03:00

`src/runtime/diagnostics.fbs` içindeki erken `UxbInit`, CLI çıktı sözleşmesi okunmadan `build/manual/logs/uxbasic.log` açıyordu. Bu yan etki kaldırıldı; `UxbConfigure` gerçek yolu aldıktan sonra günlük klasörünü oluşturuyor. `src/semantic/semantic_step3_gate.fbs` adım5 raporlarını sabit `build/manual/logs` yerine output contract'ın `build/<run_id>/logs` köküne yönlendiriyor. Yazım `UXBReportWriteText` üzerinden ebeveyn klasörünü güvenli biçimde oluşturuyor ve hata dönüşü artık dikkate alınıyor.

Kanıt: `reports/coordination_20260913/s028_log_20260914_123842_443045/acceptance.json`, 7/7 PASS. AST ve canonical-MIR temiz çalışma klasöründe `PREPROCESS_OUTPUT_PASS` ve `42` üretti; eski `build/manual` veya CWD altında günlük oluşmadı. Dört adım5 raporu seçilen çıktı kökünde oluştu. Engellenmiş hedef dosyası testlerinde derleyici kontrollü rapor yazma hatası döndürdü; süreç çalışma zamanı abort'u vermedi. Bağımsız lifecycle testi iki farklı output kökünde günlüklerin birer oturum başlığıyla yazıldığını doğruladı.

Bağımsız doğrulama derleyicisi: `bin/uxb_codex_s028_reports.exe` (kaynak değişikliklerini içeren izole host). Ortak `bin/uxb.exe` üzerine yazılmadı.
