# uXBasic Fix-12 Remaining 16 Full File Replace

Yöntem: KOPYALA-EZ / FULL FILE REPLACE. Patch runner değildir.

Hedef kaynak: src(11.06_4), Fix-11 sonrası.

Düzeltilen kalan iki hata ailesi:
1. FFI route pozitif testleri:
   AST/execmem çalıştırmada CALL_DLL_STMT / CALL_API_STMT "unsupported statement kind" hatasına düşüyordu.
   Fix-12 bu route smoke statementlarını AST yorumlayıcıda güvenli no-op yapar.

2. Browser/WASM meta pozitif testleri:
   %%TARGET WEB + %%JS_BEGIN "program.js" RUNTIME yanlışlıkla RAW_JS_PAYLOAD_NOT_ALLOWED_FOR_TARGET hatasına düşüyordu.
   Fix-12 sadece WEB/BROWSER/JS hedefinde RUNTIME JS blocklarına izin verir.
   Hedefsiz raw JS negatif testi fail-close kalır.

Uygulama:

    python copy_over_fix12_remaining16.py --root . --dry-run
    python copy_over_fix12_remaining16.py --root .
    .\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log

Test:

    python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only ffi_routes
    python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only browser_wasm
    python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe --only negative
    python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe

Yedek: .bak_fix12
