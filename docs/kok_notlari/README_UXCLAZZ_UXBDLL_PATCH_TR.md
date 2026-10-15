# UXClazz + uxbdll + uxclz.dll yaması

Bu paket yalnız yeni dosyalar ekler; compiler çekirdeğini değiştirmez.

Hızlı doğrulama:

```powershell
python .\tools\tests\verify_uxclazz_uxbdll_patch.py
```

C++ runtime build:

```powershell
.\runtime_ext\uxclz\build_uxclz.bat
```

UXClazz örneği:

```powershell
python .\tools\uxclazz\uxclazz.py .\examples\uxclazz\fish_sample.uxclz -o .\build\fish_sample_generated.uxb
```

uXBasic DLL ürün dosyalarını üretme:

```powershell
python .\tools\uxbdll\uxbdll.py --manifest .\examples\uxbdll\uxoop_module.uxdll.json --force
```

Tam açıklama: `docs/UXCLAZZ_UXBDLL_MIMARI_VE_KULLANIM_KILAVUZU_TR.md`
