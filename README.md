# uXBasic

uXBasic, klasik BASIC hissini korurken Windows odakli modern bir compiler ve deneysel programlama ortami olusturmayi hedefleyen acik kaynak bir projedir.

Bu depo ana gelistirme deposudur. Burada:

- compiler kaynak kodu
- parser, semantic, runtime ve x64 codegen calismalari
- testler
- teknik planlar
- deneysel FFI ve native build lane'leri

birlikte yasiyor.

## Proje ne yapiyor

uXBasic ile su tip programlar yazilabilir:

- konsol programlari
- klasik BASIC egitim ornekleri
- dosya islemleri
- tipler, diziler ve veri yapilari ile calisma
- deneysel native x64 derleme
- gelecekte Windows API, dis DLL ve daha guclu kutuphane entegrasyonlari

## Bugun calisan kisimlar

Bugun pratikte kullanilabilen alanlar:

- lexer + parser
- semantic analiz
- AST tabanli runtime
- MIR tabanli interpreter
- x64 asm/object/exe build lane
- bircok temel komut ve intrinsic
- test suite ve JSON rapor ciktilari

Detayli mimari:

- [uxbasic_mimari.md](uxbasic_mimari.md)

Detayli dil yuzeyi ve syntax:

- [PCK5.md](PCK5.md)

## Su anda ne eksik

Projenin durumu acikca soyle:

- native x64 lane artik gercek exe uretiyor
- fakat `CALL(DLL)` icin native lane henuz tam resolver asamasina gelmedi
- yani bazi DLL cagrilari derlenebilir hale geldi, ama hepsi henuz gercek API invocation yapmiyor
- GUI ve ileri seviye Windows API kullanimi henuz gelistirme asamasinda

Bu proje "tamamlanmis urun" degil; hizla buyuyen, ciddi bir teknik taban kazanan bir compiler projesidir.

## Ilk deneme

Yeni baslayan biri icin en kolay giris:

1. [START_HERE.md](C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/START_HERE.md) dosyasini ac
2. `tests/basicCodeTests/42_uxb_native_console_codegen_smoke.bas` dosyasina bak
3. compiler'i derle
4. ornek programi calistir

## Hazir belgeler

- Baslangic rehberi: [START_HERE.md](START_HERE.md)
- Mimari: [uxbasic_mimari.md](uxbasic_mimari.md)
- Dil yuzeyi: [PCK5.md](PCK5.md)
- Sponsor ve vizyon notu: [SPONSORING.md](SPONSORING.md)
- Test ve sonuc raporu: [tests/basicCodeTests/RESULTS.md](tests/basicCodeTests/RESULTS.md)

## Hazir test dosyalari

Ozellikle bakilabilecek dosyalar:

- [42_uxb_native_console_codegen_smoke.bas](tests/basicCodeTests/42_uxb_native_console_codegen_smoke.bas)
- [43_uxb_native_flow_math_codegen_smoke.bas](tests/basicCodeTests/43_uxb_native_flow_math_codegen_smoke.bas)
- [31_uxb_windows_kernel_sleep_tick.bas](tests/basicCodeTests/31_uxb_windows_kernel_sleep_tick.bas)
- [32_uxb_windows_user32_metrics.bas](tests/basicCodeTests/32_uxb_windows_user32_metrics.bas)

## Windows'ta nasil denenir

Kisa cevap:

- Evet, bu compiler Windows ortaminda gelistiriliyor ve test ediliyor.
- Native x64 console lane calisiyor.
- Windows DLL/API syntax ve build lane mevcut.
- Ama tum API cagrilari bugun icin tam runtime parity seviyesinde degil.

Acik deneme adimlari:

1. FreeBASIC kur
2. NASM ve MinGW toolchain kur
3. `src/main.bas` dosyasini derle
4. `--build-x64` ile ornek `.bas` dosyasini exe'ye cevir

Detayli adimlar:

- [START_HERE.md](START_HERE.md)

## Neden onemli

uXBasic yalnizca nostaljik bir BASIC projesi degil.
Hedefi:

- yeni baslayanlara kolay bir dil sunmak
- eski BASIC dusuncesini modern native derleme ile birlestirmek
- Windows tarafinda egitim, oyun, otomasyon ve arac gelistirme icin anlasilir bir compiler ekosistemi kurmak

## Sponsor ve destek

Bu proje sponsor bulmaya uygun cunku:

- egitim odakli
- yerli gelistirici hikayesi tasiyor
- compiler, dil ve tooling boyutu olan zor bir problem uzerinde ilerliyor
- somut artefact ureten bir teknik tabana sahip

Sponsor anlatimi icin:

- [SPONSORING.md](SPONSORING.md)
