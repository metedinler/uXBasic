# uxb_runtime.dll

Kanonik 0..255 SLOT tablosunun native backendidir. Dil sözdizimi burada tanımlanmaz.
FreeBASIC AST/MIR katmanları aynı EVENT/PIPE/THREAD/PARALEL/SLOT/TRIGGER yüzeyini kullanır.

Backend seçimi:

- `UXB_RT_BACKEND=auto` — EVENT/PIPE/THREAD için libuv, PARALEL için oneTBB; yoksa std fallback.
- `UXB_RT_BACKEND=std`
- `UXB_RT_BACKEND=libuv`
- `UXB_RT_BACKEND=tbb`
- `UXB_TBB_THREADS=4`
- `UXB_NATIVE_INTERP_CALLBACKS=0` — interpreter callbacklerini kapatıp senkron fallback kullanır.

Derleme:

```powershell
.\native\uxb_runtime\build_runtime_dll.bat
```

Çıktıların çalışma kopyası `bin\uxb_runtime.dll`, dağıtım kopyası
`dist\libraries\bin\uxb_runtime.dll` olur.
