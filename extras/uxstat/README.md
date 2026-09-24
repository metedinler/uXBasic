# UXSTAT (Ilk Resmi uXBasic Istatistik DLL)

Bu klasor uXBasic icin planlanan ilk resmi istatistik DLL'i olan `uxstat.dll` icin UXSTAT-0 cekirdegini icerir.

## Icerik

- `include/uxstat.h`: C ABI header
- `src/uxstat.c`: Vector + temel istatistik implementasyonu
- `tests/uxstat_smoke.c`: Minimal smoke test
- `build_uxstat_mingw.bat`: MinGW ile DLL + smoke test derleme scripti

## API (MVP)

- Vector: `uxb_vec_create_f64`, `uxb_vec_destroy_f64`, `uxb_vec_set_f64`, `uxb_vec_get_f64`, `uxb_vec_set_missing`
- Stats: `uxb_stat_mean_f64`, `uxb_stat_var_f64`, `uxb_stat_std_f64`, `uxb_stat_sem_f64`, `uxb_stat_min_f64`, `uxb_stat_max_f64`
- Win wrapper: `*_stdcall` varyantlari

## Build

Windows + MinGW:

```bat
cd extras\uxstat
build_uxstat_mingw.bat
```

## uXBasic Entegrasyon Notu

uXBasic tarafinda `CALL(DLL, ...)` ile `uxstat.dll` sembolleri cagrilir. Bu dizin UXSTAT-0 fazini saglar; CSV/dataframe-lite ve ileri istatistikler UXSTAT-1+ fazlarindadir.
