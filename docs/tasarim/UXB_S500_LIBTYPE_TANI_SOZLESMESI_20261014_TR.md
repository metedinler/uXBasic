# uXBasic S-500: birinci sınıf kütüphane tipi tanı sözleşmesi

**Tarih:** 2026-10-14  
**Durum:** Uygulandı ve doğrulandı  
**Kapsam:** provider hedef kapısı ve provider çalışma zamanı hataları

## Sorun

Birinci sınıf kütüphane tipi provider hataları aynı kod ailesini taşımasına
rağmen iki farklı structured biçimde çıkıyordu. Hedef doğrulama reddi
`UNAVAILABLE` normalleştirilmiş alanlara sahipti; MIR çalışma zamanı
`MISSING` ve `TYPE_MISMATCH` ise ham canonical prefix'i hem İngilizce hem
Türkçe alana yazıyor, provider ayrıntısını ve yönlendirmeyi kaybediyordu.

Bu, provider ABI'sinin yalnız bir çağrı adı değil, tanı da dahil ortak bir
sözleşme olması ilkesine aykırıydı.

## Uygulanan sözleşme

Tüm provider tanıları:

- `code`: canonical `UXB_LIBTYPE_PROVIDER_*`
- `layer`: `library_type`
- `phase`: `target_validation` veya `provider_call`
- `message_en` ve `message_tr`: canonical prefix'siz, iki dilli kullanıcı iletisi
- `related_surface`: hedef/provider/tip/işlem ayrıntısı
- `hint_en` ve `hint_tr`: düzeltme yönü

`MISSING` ve `TYPE_MISMATCH` için ayrıntı, ham iletideki provider marker'ından
çıkarılır. `UNAVAILABLE` için mevcut hedef ve tip ayrıntısı korunur. Terminal
canonical hata satırı geriye dönük kalır; structured JSON artık ham satırı
alanlara kopyalamaz.

## Kod ve kanıt

- `src/main_output_contract_bridge.fbs`: provider ayrıntısı çıkarımı ve iki
  dilli structured push/legacy failure JSON normalizasyonu.
- `tests/diagnostics/run_s500_libtype_diagnostic_consistency_tests.ps1`:
  runtime `MISSING` ve target `UNAVAILABLE` vakalarını alan bazında doğrular.
- S-500 koşucusu **2/2 PASS**.

S-501 Türkçe karakter politikasına ait bir karar değildir; mevcut ASCII Türkçe
mesaj politikası bu halkada değiştirilmemiştir ve ayrı karar kaydı olarak açık
tutulmuştur.
