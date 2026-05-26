# uXBasic Browser/WASM Professional Toolchain and Runtime Layer

Bu paket, önceki JS/WASM matrix patch üzerine dört kapatma katmanı ekler:

1. **Windows terminal install aracı**  
   `tools/install_browser_wasm_toolchain.ps1` Node.js, WABT/wat2wasm ve Binaryen/wasm-opt varlığını kontrol eder; eksik WABT/Binaryen araçlarını `tools/browser_toolchain` altına indirir. Node.js eksikse winget ile `OpenJS.NodeJS.LTS` paketini kurmayı dener.

2. **localhost bridge**  
   Browser doğrudan Windows DLL/API çağıramaz. Bunun yerine `tools/uxb_localhost_bridge.py` yerel, token destekli, allowlist tabanlı servis açar. `runtime/browser/ux_localhost_bridge.js` bunu JS tarafına bağlar.

3. **CLASS/OOP handle sistemi**  
   WASM içinde bütün OOP modelini taşımak yerine JS tarafında `ux_oop_handles.js` ile class/instance/field/method handle store sağlanır. WASM integer handle ile çalışabilir; JS nesne modelini yönetir.

4. **F80/F128/BIGF/BIGD/BALL external runtime bridge**  
   Browser/WASM native F80/F128/BIGF üretmez. `ux_fp_bridge.js` önce localhost bridge decimal servisini kullanır, yoksa JS Number fallback uygular.

5. **WebGPU backend**  
   `ux_webgpu.js` WebGPU feature detection, device/context init, clear ve compute vector add sağlar. Canvas2D renderer ile güvenli fallback politikası korunur.

## Kurulum

```bat
cd C:\UXBc\uxb
compiler\scripts\run_browser_toolchain_install.bat
```

Yeni terminalde:

```powershell
. .\tools\env_browser_toolchain.ps1
```

## Localhost bridge

```bat
compiler\scripts\run_localhost_bridge.bat
```

Üretilecek tarayıcı paketlerinde:

```html
<script>
  window.uxLocalBridgeEndpoint = "http://127.0.0.1:8765";
  window.uxLocalBridgeToken = "change-this-token";
</script>
```

## Profesyonel hybrid build

```bat
python tools\uxb_browser_build_pro.py --uxb-root . --out-dir dist\browser\hybrid_pro --mode hybrid --mir-json tests\browser_json\sample_add.mir.json
```

## Güvenlik notu

`CALL DLL` asla tarayıcıdan doğrudan yapılmaz. Localhost bridge içinde `allow_ffi=true` yapılmadan ve fonksiyon allowlist'e eklenmeden DLL çağrısı çalışmaz.
