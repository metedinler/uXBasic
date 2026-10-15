# S-050 Codex doğrulaması

S-050 düzeltmesi Claude 1 tarafından zaten uygulanmış durumdaydı. Codex aynı çalışma ağacındaki güncel `bin/uxb.exe` ile bağımsız bir değişken indeksli struct-array testi çalıştırdı:

`TYPE POINT`, `DIM pts(0 TO 2) AS POINT`, döngü içinde `pts(i).X = ...`, ardından `pts(i - 1).X` okuması.

AST ve canonical-MIR çıktıları birebir `10, 20, 30, 30`, her iki çalıştırma exit 0. Böylece `pts(i).X` indeksinin metin olarak değil gerçek çalışma zamanı değeri olarak kullanıldığı doğrulandı. Kanıt çıktısı `reports/coordination_20260914/s050_verify/` altındadır.

Native x64 struct-array desteği bu S-050 düzeltmesinin kapsamı dışında hâlâ kontrollü olarak reddediliyor; sessiz yanlış sonuç üretilmiyor.
