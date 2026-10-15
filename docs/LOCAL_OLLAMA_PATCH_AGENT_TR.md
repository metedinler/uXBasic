# Yerel Ollama yama agenti

Bu araç API anahtarı istemez. Yerel Ollama modelinden yalnız unified diff alır.
Varsayılan davranış dry-run'dır; yama kendiliğinden uygulanmaz.

```bat
LOCAL_PATCH_AGENT.bat "parserdaki INPUT tip hatasini duzelt"
```

Çıktıdaki `PATCH_CHECK_OK` yamayı `git apply --check` ile doğruladığını gösterir.
İnceledikten sonra uygulamak için:

```bat
LOCAL_PATCH_AGENT.bat "parserdaki INPUT tip hatasini duzelt" --apply
```

Python dosyaları `py_compile`, FreeBASIC girişleri `fbc64 -c`, C/C++ girişleri
`gcc -fsyntax-only` ile kontrol edilir. Değişen mevcut dosyaların yedekleri
`.patch_backup\local_agent_TARIH_SAAT` altında tutulur.

Hazır bir yamayı modelsiz denetlemek:

```bat
LOCAL_PATCH_AGENT.bat --patch-file duzeltme.patch
```

Yalnız `.py`, `.bas`, `.bi`, `.fbs`, `.fb`, `.c`, `.h`, `.cc`, `.cpp` ve
`.hpp` dosyalarına izin verilir; workspace dışındaki yollar reddedilir.
