# S-499 Birinci Sınıf Kütüphane Tipi Hedef Provider Kapısı

Tarih: 2026-10-13
Durum: Uygulandı ve doğrulandı

## Sorun

`RATIONAL` manifesti `copy_model=bitcopy` olduğu için önceki hedef kapısı yalnız
managed lifecycle provider'larını kontrol ediyordu. `RATIONAL` bu kontrolden
geçiyor, ancak AST-x64 ve WAT/WASM lowering'inde gerçek provider bulunmadığı
halde program hedefe taşınıyordu. Sonuç, hata vermeden yanlış değer üretmekti.

Bu davranış birinci sınıf kütüphane tipi ilkesine aykırıdır: manifestte bir
provider adının bulunması, o hedefte provider implementasyonu bulunduğu anlamına
gelmez. Her hedef için provider ABI'si ayrı doğrulanmalıdır.

## Uygulanan sözleşme

`UXBLibraryTypeValidateExecutionTarget` artık kayıtlı her tip için iki kapıyı
sırayla uygular:

1. `CLONE` veya `RETAIN` isteyen tiplerde mevcut lifecycle provider kapısı
   korunur.
2. Değer/BITCOPY tipleri dahil her tipte hedefe ait provider seçilir:
   `NATIVE -> native_provider`, `JS -> js_provider`, `WAT/WASM ->
   wasm_provider`, `MIR -> mir_provider`.
3. Provider adı `UXBLibraryTypeProviderIsRegistered` ile hedefe özgü registry'de
   kayıtlı ve `UXBLibraryTypeProviderSupportsType` ile tipe uygun değilse derleme
   durur.

Manifestte yazan `RATIONAL_X64_REFERENCE`,
`RATIONAL_LINEAR_MEMORY_REFERENCE` veya `RATIONAL_REFERENCE` adları tek başına
uygulama sayılmaz. Bu adlar gerçek backend provider'ları bağlandığında ilgili
hedef registry'sine eklenebilir. Şu an referans provider yalnız MIR'de kayıtlı
olduğundan `RATIONAL` yalnız MIR yorumlayıcı yolunda çalışır.

Kapı kayıt defterindeki her referans tipi körlemesine denetlemez. `RATIONAL`
gibi yerleşik referans sözleşmeleri her derlemede lookup için yüklenebilir; ret
yalnız kaynak programda gerçekten kullanılan kütüphane tipleri için üretilir.
Kullanım, gerçek tip bağlama/yerleşim, çözümlenmiş kütüphane çağrısı veya
çözümlenmiş tip işleci sırasında işaretlenir. Böylece sıradan bir `F64` programı
RATIONAL provider'ı yok diye reddedilmez; `TEXT_REF` programı da yalnız
`TEXT_REF` provider'ının durumunu görür.

## Tanı sözleşmesi

Desteklenmeyen tüm hedeflerde ortak kod ve aşama kullanılır:

```text
UXB_LIBTYPE_PROVIDER_UNAVAILABLE
phase = target_validation
```

Örnek:

```text
UXB_LIBTYPE_PROVIDER_UNAVAILABLE: library type provider unavailable for NATIVE: RATIONAL
```

Tanı `all_diagnostics.json` içine de yazılır. Böylece yanlış native/WAT sonucu
yerine açık ret verilir; hedef provider'ı tamamlanmadan bir kütüphane tipi sahte
scalar lowering'e düşemez.

## Doğrulama

Koşucu: `tests/diagnostics/run_s499_libtype_target_gate_tests.ps1`

`rational_mir_ops_value.uxb` ile aynı binary üzerinde:

```text
MIR      PASS: 2/1, 24/1, 3/2
AST      PASS: ortak açık ret
AST-x64  PASS: ortak açık ret, hedef NATIVE
MIR-x64  PASS: ortak açık ret, hedef NATIVE
native   PASS: ortak açık ret, hedef NATIVE
JS       PASS: ortak açık ret, hedef JS
WAT      PASS: ortak açık ret, hedef WAT
WASM     PASS: ortak açık ret, hedef WAT
Toplam: 8 PASS: 8 FAIL: 0
```

Bu kapanış, gerçek native/JS/WASM `RATIONAL` provider'larının uygulandığını
iddia etmez. O provider'lar eklendiğinde registry ve her hedef için gerçek
çalıştırma testleri ayrıca tamamlanmalıdır.
