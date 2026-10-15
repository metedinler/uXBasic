# QuickJS indirme ve klasör düzeni

```text
runtime_ext/uxjsruntime/
  quickjs.lock.json
  fetch_quickjs.ps1
  build_uxjsrt.ps1
  uxjsrt.c
  uxjsrt.h
  uxjsrt.def
  downloads/
    quickjs-2026-06-04.tar.xz
  vendor/
    quickjs/
      VERSION
      LICENSE
      quickjs.c
      quickjs.h
      dtoa.c
      dtoa.h
      libregexp.c
      libregexp.h
      libunicode.c
      libunicode.h
      cutils.c
      cutils.h
  build/
    obj/
    uxjsrt.dll
    libuxjsrt.dll.a

bin/
  uxjsrt.dll
```

Kaynak arşivi resmi Bellard URL'sinden alınır ve SHA-256 doğrulanmadan açılmaz.

QuickJS kaynakları yama ZIP'ine gömülmemiştir. Böylece üçüncü taraf kaynak ile uXBasic'e ait kod ayrı kalır ve sürüm güncellemesi denetlenebilir olur.
