# UXBc WASM Yayin Deposu Notlari

Bu dokuman, yayin adresi olarak `https://github.com/metedinler/UxBasiC_Wasm` kullanimini tanimlar.

## Depo rolu

- Uretim/imalat deposu: `origin` (`https://github.com/metedinler/uXBasic.git`)
- Yayin deposu: `wasm-publish` (`https://github.com/metedinler/UxBasiC_Wasm.git`)

## Release kapsami

Yayin paketi asagidaki alanlari icerir:

- `uxb/src`
- `uxb/tests`
- `uxb/docs`
- `uxb/vscode-extension`
- `uxb/compiler/scripts`
- `uxb/include`
- `libs`
- `UXBc_KULLANIM_KILAVUZU.md`
- `UXBc_VSCODE_KULLANIM.md`

## Release uretim komutu

Calistirilacak komut:

```bat
uxb\compiler\scripts\create_wasm_publish_release.bat
```

Uretilen ciktilar:

- `uxb/_release/wasm_publish_YYYYMMDD_HHMMSS/`
- `uxb/_release/UXBc_Wasm_publish_YYYYMMDD_HHMMSS.zip`

## Not

Bu yayin akisi, uretim hattindaki ana depoyu degistirmez.
