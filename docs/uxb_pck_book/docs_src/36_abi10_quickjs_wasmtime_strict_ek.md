# ABI10, QuickJS, Wasmtime ve Strict Üretim Eki

Bu ek eski bölümleri yeniden yazmaz; güncel üretim sözleşmesini tamamlar.

| Bileşen | Sözleşme |
|---|---|
| `uxffi.dll` | API 131, ABI10 |
| `uxjsrt.dll` | API 110 |
| `uxwasmrt.dll` | API 100, Wasmtime core-i32 |
| Wasmtime | Dış çalışma zamanı; QuickJS sağlayıcısının parçası değildir |

Olumlu üretim koşusunda yalnız izin verilen ve doğrulanmış çağrılar bulunur. Negatif güvenlik testlerindeki `WARN` kayıtları beklenen reddetme kanıtıdır ve üretim programının uyarısı sayılmaz. Dağıtım kapısı olumlu smoke günlüklerinde beklenmeyen `WARN` veya `ERROR` bulunursa paketlemeyi durdurur.

Authenticode imzası bir sertifika ve özel anahtar gerektirir. SHA-256 manifesti dosya bütünlüğünü kanıtlar; Authenticode yerine geçmez. İmzalı üretim için güvenilir kod imzalama sertifikası sağlanmalı ve EXE/DLL dosyaları paket kapısından önce imzalanmalıdır.
