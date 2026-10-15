# ADIM40 — history/latest inceleme raporu

## Dosya durumu

`history.zip` içinde 22 gate JSON bulundu.
`latest.zip` içinde 16 gate JSON bulundu.

`latest.zip` güvenilir son rapor paketi değil; aynı ADIM30/ADIM32B klasörlerini tekrarlı biçimde kopyalamış. ADIM36 son geniş test sonucu en güvenilir olarak `fail_count=139`, `missing_output_count=293`, `test_case_count=79` veren history/latest_two_jobs içeriğidir.

## En görünür kök hatalar

1. String builtins: UCASE/LEFT.
2. Array index lvalue: A(i)=... CALL_EXPR not writable.
3. Function recursion type inference.
4. Include sembol görünürlüğü: yaz/nested_value unknown.
5. File I/O: INPUT#, string suffix $, OPEN relative path/mode.
6. BIG number: BIGF(precision), BIGD, BALL, BIGI/BIGINT, BIGINIT.
7. Preprocessor: FOREACH/ENDFOREACH, SET/IFN/ELIF leak.
8. WASM host JS block sızması.
9. RND/TIMER builtin.
10. PTR/memory types.
11. Negative gate fail-close.

## Not

Bu yama kodu körlemesine ezmek için değil; Copilot'a ilgili kaynak dosyalara uygulanacak net görev/snippet haritası vermek içindir.
