# S-444 — JS yakalanmayan THROW/ASSERT sınırı

**Durum:** YAPILDI-DOGRULANDI (üst düzey yakalanmayan hata sınırı)
**Tarih:** 2026-10-13
**Kapsam:** JavaScript üretimi ve Node çalıştırması

## Sorun

JS üreticisi `RET` MIR komutunu normal bir yordam dönüşü gibi yazıyordu.
Kanonik MIR ise yakalanmayan `THROW` ve başarısız `ASSERT` için ortak durum
alanlarını kullanır:

```text
__mir_exc_active
__mir_exc_value
```

Bu nedenle üst düzey hata yolu JS'te normal promise tamamlanmasına dönüşebiliyor;
program sonraki kaynak satırlarını çalıştırmadan, hata metni ve başarısız çıkış
kodu olmadan tamamlanıyordu.

## Uygulanan düzeltme

`src/codegen/js/js_stmt_emit.fbs` içindeki `RET` üretimi, normal dönüşten önce
`__MIR_EXC_ACTIVE` değerini denetliyor. Etkin bir hata varsa JavaScript
`Error` fırlatılıyor ve mevcut runtime sarmalayıcısının hata metni ile sıfırdan
farklı çıkış davranışı korunuyor. Etkin değilse eski normal `return` yolu
çalışıyor.

## Doğrulama

`tests/diagnostics/run_s444_js_exception_tests.ps1` iki en küçük yeniden üretimi
JS + Node üzerinde çalıştırır:

| Kaynak | Beklenti | Sonuç |
|---|---|---|
| `s444_uncaught_throw.uxb` | `once` yazılır, `hata` iletisiyle nonzero çıkış, `sonra` yok | PASS |
| `s444_uncaught_assert.uxb` | `once` yazılır, `bozuk` iletisiyle nonzero çıkış, `sonra` yok | PASS |

Derleme ve yürütme kapısı toplam **4/4 PASS** verdi. Test `tests/run_all_model_tests.ps1`
paket listesine `js_exceptions` adıyla eklendi. Ana `build_64.ps1 -Force`
derlemesi de exit 0 verdi.

## Kapsam sınırı

Bu halka yalnız üst düzey, yakalanmayan JS `THROW`/`ASSERT` davranışını kapatır.
JS'te bir kullanıcı yordamının async `await` çağrısından fırlayan hatanın
çağırandaki `TRY/CATCH` tarafından yakalanması ayrı bir exception-propagation
işidir. `tests/exceptions_cross/catch_in_caller.uxb` bu sınırda hâlâ başarısızdır;
bu nedenle JS exception parity'si bütünüyle kapanmış sayılmaz.

## Kabul kararı

Üst düzey yakalanmayan `THROW` ve başarısız `ASSERT` için S-444 kapanmıştır.
Kullanıcı yordamı sınırından geçen JS `TRY/CATCH` ayrı açık sorun olarak
izlenecektir; bu belge onu çözülmüş göstermemektedir.
