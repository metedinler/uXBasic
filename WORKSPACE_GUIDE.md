# Workspace Guide

## Tek aktif kaynak depo

Bu calismada degisiklik yapilacak tek depo [uXBasic_repo](.).

## Girdi noktalar

- `build_64.bat`: tek dosya veya modül derleme
- `build_32.bat`: tek dosya veya modül 32-bit derleme
- `build_compiler_64.bat`: ana compiler derleme girisi
- `uxb\compiler\scripts\build_uxb_main_64.bat`: compiler derlemesini iceriden yoneten script

## Kopya / snapshot klasorler

- `UXBc_Clean`: temizlenmis snapshot, ana gelistirme alani degil
- `1\UXMv33`: farkli/deneysel alan, bu oturumda degisiklik hedefi degil

## Kural

Kod degisikligi yapilacaksa once bu kok kullanilir. Test klasorleri ve artefact klasorleri yeni kaynak deposu gibi kullanilmaz.