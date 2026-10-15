# S-445 — CALL(DLL) bilinmeyen argüman tip listesinin ortak reddi

**Durum:** YAPILDI-DOGRULANDI
**Tarih:** 2026-10-13
**Kapsam:** AST, canonical MIR, MIR-x64, JS ve WAT/WASM derleme girişleri

## Sorun

Typed CALL(DLL, ...) biçiminde dönüş tipi ve çağrı kuralından sonra gelen
STRING, argüman ABI tip listesi olarak kullanılabilir. Parser virgüllü listelerde
bilinmeyen simgeyi reddediyor, fakat tek öğeli bilinmeyen bir STRING'i belirsiz
biçimde çalışma zamanı argümanı sayıyordu. Böylece:

    result = CALL(DLL, "ucrtbase.dll", "abs", I32, CDECL, "BILINMEZ", -5)

AST ve MIR çalışma zamanında dururken x64 planlayıcısı "BILINMEZ" metnini
yanlışlıkla ilk ABI argümanı gibi geçirip çöp sonuç üretebiliyordu.

## Uygulanan sözleşme

UXB_FFI_ARGUMENT_TYPE_LIST ortak tanı kodu eklendi. Explicit typed FFI
biçiminde metadata konumundaki STRING'in ardından gerçek argüman varsa bu STRING
tip listesi kabul edilir; liste tek öğeli olsa bile bilinmeyen simge ortak parser
kapısında reddedilir. Böylece belirsiz metin ABI'ye sızmaz.

Ek savunma olarak src/codegen/x64/ffi_call_backend.fbs, parser dışı veya eski
AST girişlerinde aynı belirsizliği tekrar kontrol eder ve x64 FFI planını
oluşturmadan önce aynı tanıyla durur.

## Değişen katmanlar

- src/parser/parser/parser_stmt_dispatch.fbs: bilinmeyen tek öğeli liste için açık ret.
- src/parser/parser/parser_adim08_error_recovery.fbs: parser JSON kod köprüsü.
- src/common/error_system_adim45.fbs: ortak katalog ve tanı eşlemesi.
- src/codegen/x64/ffi_call_backend.fbs: backend savunma kapısı.

## Doğrulama

tests/diagnostics/run_s445_dll_type_list_tests.ps1, aynı kaynak programı AST,
MIR, MIR-x64, JS ve WAT girişlerinde derlemeye çalıştırır. Beş yüzeyin
beşinde de çıkış sıfır değildir ve çıktı hem UXB_FFI_ARGUMENT_TYPE_LIST hem
de BILINMEZ içerir:

**Toplam: 5 PASS, 0 FAIL.**

Ana build_64.ps1 -Force derlemesi exit 0 verdi.

## Kapsam sınırı

Bu halka bilinmeyen argüman tip listesinin ABI çağrısına ulaşmasını kapatır.
Geçerli I32, U32, I64, U64, F64, PTR ve STRPTR listelerinin gerçek DLL ABI
davranışı, mevcut FFI testleriyle ayrı izlenmeye devam eder.
