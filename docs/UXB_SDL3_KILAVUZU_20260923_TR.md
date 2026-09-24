# uXBasic SDL3 kütüphanesi (`uxsdl3`) kılavuzu

**Durum:** tamamlandı ve doğrulandı (2026-09-23, Claude 1, S-052). Adaptör `runtime_ext/uxraylib/uxsdl3_adapter.c`
(319 dışa aktarılan işlev), uXBasic sarmalayıcısı `libsx/uxsdl3/uxsdl3.bas` (334 sarmalayıcı işlev), testler
`tests/libraries/uxsdl3/` (8 program × 4 motor). SDL sürümü: 3.4.10.

`uxsdl3`, raylib'in yanında duran ikinci çok ortamlı katmandır: pencere/ekran, 2B çizici ve dokular, klavye/fare/metin/pano,
gamepad/joystick (sanal aygıtlar dahil), ses, zamanlayıcılar, dosya sistemi ve sistem bilgisi. Her şey **başsız** (ekran ve
hoparlör olmadan) sınanabilir: SDL'in `dummy` video ve ses sürücüleri seçilir ve çizim, yazılım çizicisinden piksel piksel
geri okunarak doğrulanır.

## 1. Kurulum

```powershell
cmd /c .\runtime_ext\uxraylib\build_wrappers.bat      # uxsdl3.dll + SDL3.dll (dist\libraries\bin)
Copy-Item .\dist\libraries\bin\uxsdl3.dll .\bin\ -Force  # çalışma yerine kopyalanır
```

Programda:

```basic
INCLUDE "include/modules/uxsdl3.uxmh"
```

Native derlemede (`uxb bld`) `uxsdl3.dll` ve `SDL3.dll` çıktı klasörüne kendiliğinden kopyalanır (PE içe-aktarma tablosundan).

## 2. Kısa örnek

```basic
INCLUDE "include/modules/uxsdl3.uxmh"

MAIN
    DIM win AS I64
    DIM ren AS I64
    uxsdl3.Init(uxsdl3.INIT_VIDEO)
    win = uxsdl3.CreateWindow("Merhaba SDL3", 640, 360, uxsdl3.WINDOW_RESIZABLE)
    ren = uxsdl3.CreateRenderer(win, "")
    WHILE uxsdl3.ShouldQuit() = 0
        uxsdl3.PumpEvents()
        IF uxsdl3.KeyPressed(uxsdl3.SCANCODE_ESCAPE) = 1 THEN uxsdl3.PushQuit()
        uxsdl3.SetRenderDrawColor(ren, 24, 28, 40, 255)
        uxsdl3.RenderClear(ren)
        uxsdl3.SetRenderDrawColor(ren, 80, 180, 255, 255)
        uxsdl3.RenderFillRect(ren, uxsdl3.GetMouseX() - 20, uxsdl3.GetMouseY() - 20, 40, 40)
        uxsdl3.SetRenderDrawColor(ren, 255, 255, 255, 255)
        uxsdl3.RenderDebugText(ren, 8, 8, "ESC ile cik")
        uxsdl3.RenderPresent(ren)
        uxsdl3.Delay(16)
    WEND
    uxsdl3.DestroyRenderer(ren)
    uxsdl3.DestroyWindow(win)
    uxsdl3.Quit()
END MAIN
```

## 3. Kurallar (her işlevde geçerli)

- **Tutamaçlar.** Pencere, çizici ve doku tutamaçları ham SDL işaretçileridir (`I64`); `0` = yok/başarısız. Ses, gamepad
  ve joystick tutamaçları küçük tablo numaralarıdır (`I32`, ses için 1..127, gamepad/joystick için 1..15; `0` = başarısız).
  Geçersiz/kapatılmış bir tutamaç **hiçbir işlevi çökertmez**: `0`, boş metin veya "başarısız" değeri döner.
- **Başarı değerleri.** Sonuç `I32` ise `1` = başarılı, `0` = başarısız (nedeni `LastError()`); sorgu işlevleri değerin kendisini döner.
- **Renkler.** Paketli `U32`: `r | g<<8 | b<<16 | a<<24` (uxraylib ile aynı düzen). `PackRGBA`, `UnpackR/G/B/A`,
  `RenderReadPixel`, `TextureFill`, `TextureSetPixel`, `SetRenderDrawColorRGBA` bunu kullanır.
- **`which` seçicileri.** Bir grup değerden birini döndüren okuyucular seçici alır: `PART_X/Y/W/H` (dikdörtgen parçaları),
  `COMP_R/G/B/A` (renk bileşenleri); diğerleri işlevin açıklamasında yazar.
- **Olay modeli.** `PumpEvents()` her kare bir kez çağrılır ve SDL kuyruğunu düz duruma çevirir: `KeyDown/MouseButtonDown`
  (basılı), `KeyPressed/KeyReleased/MouseButtonPressed/MouseButtonReleased` (yalnız SON `PumpEvents` içinde olanlar),
  `MouseRelX/Y` (son turdaki hareket), `WindowEvents()` (son turdaki pencere olayları, `WINDOWEVT_*` bitleri),
  `GetMouseWheelX/Y` ve `TakeDeviceEvents` (okununca silinir), `TakeTextInput`, `TakeDrop`, `ShouldQuit`.
  Joystick/gamepad durumu da `PumpEvents` ile tazelenir.
- **Metinler** UTF-8'dir; sarmalayıcı metin döndüren işlevlerde dahili tamponu kopyalar (bir sonraki çağrıya kadar geçerli).
- **Sınırlı tamponlar.** Yazılan metin 1023 bayt (`TakeTextInput`), bırakılan dosya kuyruğu 16 kayıt; sığmayan parça
  bölünmeden reddedilir (UTF-8 dizisi ortadan kesilmez).

## 4. Girdi enjeksiyonu ve sanal aygıtlar (test/otomasyon için)

Gerçek donanım gerekmeden uygulamanın girdi yolunu sınamak için:

| İşlev | Ne yapar |
|---|---|
| `PushKey(scancode, down)` | SDL kuyruğuna gerçek bir klavye olayı koyar |
| `PushMouseButton(button, down, x, y)`, `PushMouseMotion(x, y, xrel, yrel)`, `PushMouseWheel(x, y)` | fare olayları |
| `PushQuit()` | çıkış isteği |
| `PushTextInput(txt)` | yazı tamponuna metin ekler (`PumpEvents` teslim eder) |
| `PushDrop(path)` | bırakılan dosya kuyruğuna ekler |
| `AttachVirtualJoystick(axes, buttons, hats)` / `AttachVirtualGamepad()` | program tarafından beslenen sanal aygıt; gerçek bir aygıt gibi numaralandırılır, açılır, `OpenJoystick/OpenGamepad` ile okunur |
| `SetVirtualJoystickAxis/Button/Hat`, `SetVirtualGamepadAxis/Button` | sanal aygıtın girişleri (`PumpEvents` sonrası okunur) |
| `DetachVirtual(instanceId)` | sanal aygıtı çıkarır (`DEVICE_*_REMOVED` sayaçları artar) |

## 5. Ses

Her ses kendi çalma akışını taşır (varsayılan çıkış aygıtına bağlı). Kaynak: WAV dosyası (`LoadSound`) ya da üretilen sinüs tonu
(`CreateTone(frekansHz, ms, genlik)`, 20..20000 Hz, en çok 60 s). `SaveSoundWAV` her sesi WAV olarak yazar. Ses seviyesi:
ses başına `SetSoundVolume` (0..4) × ana seviye `SetMasterVolume`. `SetSoundLoop` ile döngü: `PumpEvents` akışı beslemeyi sürdürür, bu
yüzden döngü uzunluğundan sık `PumpEvents` çağırın. `IsSoundPlaying/IsSoundPaused/SoundRemainingMs/SoundLengthMs` durumu verir.

## 6. Kapsam dışı (bilinçli)

Aşağıdakiler bu sarmalayıcıya alınmadı; nedenleriyle birlikte:

- **GPU API (`SDL_gpu`), Vulkan/Metal/OpenGL/EGL bağlamları, kamera, HID, sensör aygıtları, dokunma-kalem (pen), haptic
  (kuvvet geri bildirimi), tepsi (tray), süreç/thread/mutex/atomic, özel IO akışları, asyncio, depolama (storage), özellik
  kümeleri (properties):** işaretçi/yapı/geri-çağrı ağırlıklıdır ya da platforma özgüdür; uXBasic'te ayrı sürücü/kütüphane
  kararı gerektirir. (Gamepad titreşimi ve gamepad hareket sensörü **vardır**.)
- **`SDL_ShowSimpleMessageBox`, `SDL_OpenURL`, dosya iletişim kutuları:** yan etkili ve otomatik sınanamaz.
- **Yüzey (surface) API'si:** yalnız BMP yükleme/kaydetme ve piksel geri okuma sunulur (SDL3 çekirdeği PNG/JPEG çözmez).
- **Dokunmatik:** aygıt/parmak sorguları var, ancak gerçek donanım olmadan durum üretilemediğinden yalnız "aygıt yok" davranışı sınanır.

## 7. Sürücüye bağlı davranışlar

`dummy` video sürücüsü pencere kenarlığı/yeniden boyutlanabilirlik/üste sabitleme/büyütme bayraklarını, saydamlık, imleç ve
simge ayarlamayı uygulamaz; bu işlevler `1`/`0` döner ama pencere bayrağı değişmeyebilir. Gerçek sürücüde (Windows) hepsi çalışır.
Testler yalnız her iki ortamda da değişmeyen davranışı denetler.

**Boş metin argümanı (S-145).** Bir FFI çağrısında boş metin ("") AST/canonical-MIR yorumlayıcılarında NULL işaretçi, native x64 ve legacy'de gerçek boş C metni olarak geçer; NULL ile boş metni ayıran işlevlerde (PrefPath, SetHint) sonuç motora göre değişir. Boş metne dayanmayın.

## 8. Testler

```powershell
.\tests\libraries\uxsdl3\run_uxsdl3_smoke_tests.ps1          # 8 program x 4 motor (AST, canonical-MIR, native x64, legacy)
.\tests\run_all_model_tests.ps1 -Only uxsdl3                 # birleşik koşucu içinde
```

Testler ekran/hoparlör açmaz (`SDL_VIDEO_DRIVER`/`SDL_AUDIO_DRIVER` programın içinde `SetHint` ile `dummy` seçilir) ve
geçici dosyaları `out\` altına yazıp siler. Program grupları: `core` (başlatma, ipuçları, zaman, takvim, dosya sistemi, sistem),
`window` (ekranlar, pencere, imleç), `render` (çizim/doku/ekran görüntüsü, piksel geri okuma), `input` (klavye/fare/tekerlek/bırakma/çıkış),
`text_input`, `clipboard`, `gamepad` (sanal joystick + gamepad), `audio` (ton, WAV, döngü, ses seviyesi, aygıt listeleri).

ABI denetimi: `python tools\library_tools\uxb_library_abi.py --root .` (her sarmalayıcı C imzasıyla karşılaştırılır; 0 uyuşmazlık).
FFI izin listesi `build\manual\config\ffi_allowlist.txt` bu araçla üretilir.

## 9. İşlev dizini

Aşağıdaki liste `libsx/uxsdl3/uxsdl3.bas` dosyasından üretilmiştir (sabitler: `INIT_*`, `WINDOW_*`, `WINDOWEVT_*`, `SCANCODE_*`,
`MOUSE_*`, `CURSOR_*`, `BLEND_*`, `TEXTUREACCESS_*`, `SCALEMODE_*`, `LOGICAL_*`, `FLIP_*`, `PATH_*`, `POWER_*`, `SENSOR_*`,
`JOYSTICK_TYPE_*`, `GAMEPAD_BUTTON_*`, `GAMEPAD_AXIS_*`, `HAT_*`, `DEVICE_*`, `FLASH_*`, `PART_*`, `COMP_*`).
Ayrıntılı açıklamalar `uxsdl3.bas` içinde her işlevin üstündeki yorumlardadır.

### Çekirdek ve bilgi

```basic
FUNCTION AdapterVersion() AS I32
FUNCTION GetAppMetadata(which AS I32) AS STRING
FUNCTION GetHint(name AS STRING) AS STRING
FUNCTION GetPlatform() AS STRING
FUNCTION Init(flags AS U32) AS I32
FUNCTION InitSubSystem(flags AS U32) AS I32
FUNCTION LastError() AS STRING
FUNCTION Revision() AS STRING
FUNCTION RuntimeVersion() AS I32
FUNCTION SetAppMetadata(name AS STRING, version AS STRING, identifier AS STRING) AS I32
FUNCTION SetHint(name AS STRING, value AS STRING) AS I32
FUNCTION WasInit(flags AS U32) AS I32
SUB ClearError()
SUB Quit()
SUB QuitSubSystem(flags AS U32)
```

### Ekranlar (display) ve video sürücüsü

```basic
FUNCTION CurrentVideoDriver() AS STRING
FUNCTION DisplayBounds(displayId AS I32, which AS I32) AS I32
FUNCTION DisplayContentScale(displayId AS I32) AS F64
FUNCTION DisplayCount() AS I32
FUNCTION DisplayIdAt(index AS I32) AS I32
FUNCTION DisplayMode(displayId AS I32, which AS I32) AS I32
FUNCTION DisplayName(displayId AS I32) AS STRING
FUNCTION DisplayOrientation(displayId AS I32) AS I32
FUNCTION DisplayUsableBounds(displayId AS I32, which AS I32) AS I32
FUNCTION GetDisplayHeight(displayId AS I32) AS I32
FUNCTION GetDisplayWidth(displayId AS I32) AS I32
FUNCTION PrimaryDisplay() AS I32
FUNCTION ScreensaverEnabled() AS I32
FUNCTION SetScreensaver(enabled AS I32) AS I32
FUNCTION SystemTheme() AS I32
FUNCTION VideoDriverCount() AS I32
FUNCTION VideoDriverName(index AS I32) AS STRING
```

### Metin girişi ve pano

```basic
FUNCTION GetClipboardText() AS STRING
FUNCTION HasClipboardText() AS I32
FUNCTION PushTextInput(txt AS STRING) AS I32
FUNCTION SetClipboardText(txt AS STRING) AS I32
FUNCTION SetTextInputArea(winHandle AS I64, x AS I32, y AS I32, w AS I32, h AS I32, cursor AS I32) AS I32
FUNCTION StartTextInput(winHandle AS I64) AS I32
FUNCTION StopTextInput(winHandle AS I64) AS I32
FUNCTION TakeTextInput() AS STRING
FUNCTION TextInputActive(winHandle AS I64) AS I32
```

### Pencere

```basic
FUNCTION CreateWindow(title AS STRING, w AS I32, h AS I32, flags AS U64) AS I64
FUNCTION FlashWindow(handle AS I64, operation AS I32) AS I32
FUNCTION GetWindowFlags(handle AS I64) AS I64
FUNCTION GetWindowHeight(handle AS I64) AS I32
FUNCTION GetWindowKeyboardGrab(handle AS I64) AS I32
FUNCTION GetWindowMaxSize(handle AS I64, which AS I32) AS I32
FUNCTION GetWindowMinSize(handle AS I64, which AS I32) AS I32
FUNCTION GetWindowMouseGrab(handle AS I64) AS I32
FUNCTION GetWindowOpacity(handle AS I64) AS F64
FUNCTION GetWindowPixelHeight(winHandle AS I64) AS I32
FUNCTION GetWindowPixelSize(handle AS I64, which AS I32) AS I32
FUNCTION GetWindowPixelWidth(winHandle AS I64) AS I32
FUNCTION GetWindowPosition(handle AS I64, which AS I32) AS I32
FUNCTION GetWindowRelativeMouse(handle AS I64) AS I32
FUNCTION GetWindowTitle(handle AS I64) AS STRING
FUNCTION GetWindowWidth(handle AS I64) AS I32
FUNCTION GetWindowX(winHandle AS I64) AS I32
FUNCTION GetWindowY(winHandle AS I64) AS I32
FUNCTION HasWindowFlag(winHandle AS I64, flag AS I64) AS I32
FUNCTION HideWindow(handle AS I64) AS I32
FUNCTION MaximizeWindow(handle AS I64) AS I32
FUNCTION MinimizeWindow(handle AS I64) AS I32
FUNCTION RaiseWindow(handle AS I64) AS I32
FUNCTION RenderCoordsFromWindow(handle AS I64, wx AS F64, wy AS F64, which AS I32) AS F64
FUNCTION RenderCoordsToWindow(handle AS I64, x AS F64, y AS F64, which AS I32) AS F64
FUNCTION RestoreWindow(handle AS I64) AS I32
FUNCTION SetWindowAlwaysOnTop(handle AS I64, onTop AS I32) AS I32
FUNCTION SetWindowBordered(handle AS I64, bordered AS I32) AS I32
FUNCTION SetWindowFocusable(handle AS I64, focusable AS I32) AS I32
FUNCTION SetWindowFullscreen(handle AS I64, fullscreen AS I32) AS I32
FUNCTION SetWindowIconBMP(handle AS I64, bmpPath AS STRING) AS I32
FUNCTION SetWindowKeyboardGrab(handle AS I64, grabbed AS I32) AS I32
FUNCTION SetWindowMaxSize(handle AS I64, w AS I32, h AS I32) AS I32
FUNCTION SetWindowMinSize(handle AS I64, w AS I32, h AS I32) AS I32
FUNCTION SetWindowMouseGrab(handle AS I64, grabbed AS I32) AS I32
FUNCTION SetWindowOpacity(handle AS I64, opacity AS F64) AS I32
FUNCTION SetWindowPosition(handle AS I64, x AS I32, y AS I32) AS I32
FUNCTION SetWindowRelativeMouse(handle AS I64, enabled AS I32) AS I32
FUNCTION SetWindowResizable(handle AS I64, resizable AS I32) AS I32
FUNCTION SetWindowSize(handle AS I64, w AS I32, h AS I32) AS I32
FUNCTION SetWindowTitle(handle AS I64, title AS STRING) AS I32
FUNCTION ShowWindow(handle AS I64) AS I32
FUNCTION SyncWindow(handle AS I64) AS I32
FUNCTION WarpMouseInWindow(handle AS I64, x AS F64, y AS F64) AS I32
FUNCTION WindowDisplay(handle AS I64) AS I32
FUNCTION WindowDisplayScale(handle AS I64) AS F64
FUNCTION WindowEvents() AS I32
FUNCTION WindowFromId(id AS I32) AS I64
FUNCTION WindowId(handle AS I64) AS I32
FUNCTION WindowPixelDensity(handle AS I64) AS F64
FUNCTION WindowResized() AS I32
SUB DestroyWindow(handle AS I64)
```

### Ses (sound, ton, aygıt)

```basic
FUNCTION AudioDeviceCount(recording AS I32) AS I32
FUNCTION AudioDeviceName(recording AS I32, index AS I32) AS STRING
FUNCTION AudioDriverCount() AS I32
FUNCTION AudioDriverName(index AS I32) AS STRING
FUNCTION CreateTone(freqHz AS I32, ms AS I32, volume AS F64) AS I32
FUNCTION CurrentAudioDriver() AS STRING
FUNCTION GetMasterVolume() AS F64
FUNCTION GetSoundLoop(handle AS I32) AS I32
FUNCTION GetSoundVolume(handle AS I32) AS F64
FUNCTION IsSoundPaused(handle AS I32) AS I32
FUNCTION IsSoundPlaying(handle AS I32) AS I32
FUNCTION LoadSound(wavPath AS STRING) AS I32
FUNCTION SaveSoundWAV(handle AS I32, path AS STRING) AS I32
FUNCTION SoundChannels(handle AS I32) AS I32
FUNCTION SoundFrequency(handle AS I32) AS I32
FUNCTION SoundLengthMs(handle AS I32) AS I32
FUNCTION SoundRemainingMs(handle AS I32) AS I32
SUB PauseSound(handle AS I32)
SUB PlaySound(handle AS I32)
SUB ResumeSound(handle AS I32)
SUB SetMasterVolume(volume AS F64)
SUB SetSoundLoop(handle AS I32, looping AS I32)
SUB SetSoundVolume(handle AS I32, volume AS F64)
SUB StopSound(handle AS I32)
SUB UnloadSound(handle AS I32)
```

### Doku (texture)

```basic
FUNCTION CreateTexture(rendererHandle AS I64, w AS I32, h AS I32, access AS I32) AS I64
FUNCTION GetTextureHeight(handle AS I64) AS I32
FUNCTION GetTextureWidth(handle AS I64) AS I32
FUNCTION LoadTexture(rendererHandle AS I64, bmpPath AS STRING) AS I64
FUNCTION RenderTexture(rendererHandle AS I64, textureHandle AS I64, x AS F64, y AS F64, w AS F64, h AS F64) AS I32
FUNCTION RenderTextureFrame(rendererHandle AS I64, textureHandle AS I64, frameW AS I32, frameH AS I32, frameIndex AS I32, dx AS F64, dy AS F64, dw AS F64, dh AS F64) AS I32
FUNCTION RenderTextureRect(rendererHandle AS I64, textureHandle AS I64, sx AS F64, sy AS F64, sw AS F64, sh AS F64, dx AS F64, dy AS F64, dw AS F64, dh AS F64) AS I32
FUNCTION RenderTextureRotated(rendererHandle AS I64, textureHandle AS I64, dx AS F64, dy AS F64, dw AS F64, dh AS F64, angle AS F64, cx AS F64, cy AS F64, flipAndCenter AS I32) AS I32
FUNCTION TextureFill(handle AS I64, rgba AS U32) AS I32
FUNCTION TextureGetAlphaMod(handle AS I64) AS I32
FUNCTION TextureGetBlendMode(handle AS I64) AS I32
FUNCTION TextureGetColorMod(handle AS I64, which AS I32) AS I32
FUNCTION TextureGetScaleMode(handle AS I64) AS I32
FUNCTION TextureSetAlphaMod(handle AS I64, a AS I32) AS I32
FUNCTION TextureSetBlendMode(handle AS I64, mode AS I32) AS I32
FUNCTION TextureSetColorMod(handle AS I64, r AS I32, g AS I32, b AS I32) AS I32
FUNCTION TextureSetPixel(handle AS I64, x AS I32, y AS I32, rgba AS U32) AS I32
FUNCTION TextureSetScaleMode(handle AS I64, mode AS I32) AS I32
SUB DestroyTexture(handle AS I64)
```

### Çizici (renderer)

```basic
FUNCTION CreateRenderer(windowHandle AS I64, name AS STRING) AS I64
FUNCTION DisableRenderClip(handle AS I64) AS I32
FUNCTION GetRenderClipRect(handle AS I64, which AS I32) AS I32
FUNCTION GetRenderDrawBlendMode(handle AS I64) AS I32
FUNCTION GetRenderDrawColor(handle AS I64, which AS I32) AS I32
FUNCTION GetRenderLogicalMode(handle AS I64) AS I32
FUNCTION GetRenderLogicalSize(handle AS I64, which AS I32) AS I32
FUNCTION GetRenderScale(handle AS I64, which AS I32) AS F64
FUNCTION GetRenderViewport(handle AS I64, which AS I32) AS I32
FUNCTION GetRenderVSync(handle AS I64) AS I32
FUNCTION PackRGBA(r AS I32, g AS I32, b AS I32, a AS I32) AS U32
FUNCTION RenderClear(handle AS I64) AS I32
FUNCTION RenderClipEnabled(handle AS I64) AS I32
FUNCTION RenderDebugText(handle AS I64, x AS F64, y AS F64, text AS STRING) AS I32
FUNCTION RendererName(handle AS I64) AS STRING
FUNCTION RenderFillRect(handle AS I64, x AS F64, y AS F64, w AS F64, h AS F64) AS I32
FUNCTION RenderLine(handle AS I64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64) AS I32
FUNCTION RenderOutputHeight(rendererHandle AS I64) AS I32
FUNCTION RenderOutputSize(handle AS I64, which AS I32) AS I32
FUNCTION RenderOutputWidth(rendererHandle AS I64) AS I32
FUNCTION RenderPoint(handle AS I64, x AS F64, y AS F64) AS I32
FUNCTION RenderPresent(handle AS I64) AS I32
FUNCTION RenderReadPixel(handle AS I64, x AS I32, y AS I32) AS U32
FUNCTION RenderRect(handle AS I64, x AS F64, y AS F64, w AS F64, h AS F64) AS I32
FUNCTION RenderSaveBMP(handle AS I64, path AS STRING) AS I32
FUNCTION ResetRenderViewport(handle AS I64) AS I32
FUNCTION SetRenderClipRect(handle AS I64, x AS I32, y AS I32, w AS I32, h AS I32) AS I32
FUNCTION SetRenderDrawBlendMode(handle AS I64, mode AS I32) AS I32
FUNCTION SetRenderDrawColor(handle AS I64, r AS I32, g AS I32, b AS I32, a AS I32) AS I32
FUNCTION SetRenderDrawColorRGBA(rendererHandle AS I64, rgba AS U32) AS I32
FUNCTION SetRenderLogicalPresentation(handle AS I64, w AS I32, h AS I32, mode AS I32) AS I32
FUNCTION SetRenderScale(handle AS I64, sx AS F64, sy AS F64) AS I32
FUNCTION SetRenderTarget(handle AS I64, texture AS I64) AS I32
FUNCTION SetRenderViewport(handle AS I64, x AS I32, y AS I32, w AS I32, h AS I32) AS I32
FUNCTION SetRenderVSync(handle AS I64, vsync AS I32) AS I32
FUNCTION UnpackA(rgba AS U32) AS I32
FUNCTION UnpackB(rgba AS U32) AS I32
FUNCTION UnpackG(rgba AS U32) AS I32
FUNCTION UnpackR(rgba AS U32) AS I32
SUB DestroyRenderer(handle AS I64)
```

### Joystick / gamepad / sanal aygıt

```basic
FUNCTION AddGamepadMapping(mapping AS STRING) AS I32
FUNCTION AttachVirtualGamepad() AS I32
FUNCTION AttachVirtualJoystick(axes AS I32, buttons AS I32, hats AS I32) AS I32
FUNCTION DetachVirtual(instanceId AS I32) AS I32
FUNCTION GamepadAxis(handle AS I32, axis AS I32) AS I32
FUNCTION GamepadAxisDeadZone(handle AS I32, axis AS I32, deadZone AS F64) AS F64
FUNCTION GamepadAxisFromName(name AS STRING) AS I32
FUNCTION GamepadAxisName(axis AS I32) AS STRING
FUNCTION GamepadAxisNorm(handle AS I32, axis AS I32) AS F64
FUNCTION GamepadButton(handle AS I32, button AS I32) AS I32
FUNCTION GamepadButtonFromName(name AS STRING) AS I32
FUNCTION GamepadButtonLabel(handle AS I32, button AS I32) AS I32
FUNCTION GamepadButtonName(button AS I32) AS STRING
FUNCTION GamepadConnected(handle AS I32) AS I32
FUNCTION GamepadCount() AS I32
FUNCTION GamepadHasSensor(handle AS I32, kind AS I32) AS I32
FUNCTION GamepadIdAt(idx AS I32) AS I32
FUNCTION GamepadInstanceId(handle AS I32) AS I32
FUNCTION GamepadMapping(handle AS I32) AS STRING
FUNCTION GamepadName(handle AS I32) AS STRING
FUNCTION GamepadNameForId(instanceId AS I32) AS STRING
FUNCTION GamepadPlayerIndex(handle AS I32) AS I32
FUNCTION GamepadPowerPercent(handle AS I32) AS I32
FUNCTION GamepadPowerState(handle AS I32) AS I32
FUNCTION GamepadProduct(handle AS I32) AS I32
FUNCTION GamepadRumble(handle AS I32, low AS I32, high AS I32, ms AS I32) AS I32
FUNCTION GamepadRumbleTriggers(handle AS I32, left AS I32, right AS I32, ms AS I32) AS I32
FUNCTION GamepadSensor(handle AS I32, kind AS I32, index AS I32) AS F64
FUNCTION GamepadSensorEnabled(handle AS I32, kind AS I32) AS I32
FUNCTION GamepadSetLED(handle AS I32, r AS I32, g AS I32, b AS I32) AS I32
FUNCTION GamepadSetPlayerIndex(handle AS I32, index AS I32) AS I32
FUNCTION GamepadSetSensorEnabled(handle AS I32, kind AS I32, enabled AS I32) AS I32
FUNCTION GamepadType(handle AS I32) AS I32
FUNCTION GamepadTypeName(kind AS I32) AS STRING
FUNCTION GamepadVendor(handle AS I32) AS I32
FUNCTION IsGamepad(instanceId AS I32) AS I32
FUNCTION JoystickAxis(handle AS I32, axis AS I32) AS I32
FUNCTION JoystickBall(handle AS I32, ballIndex AS I32, which AS I32) AS I32
FUNCTION JoystickButton(handle AS I32, button AS I32) AS I32
FUNCTION JoystickConnected(handle AS I32) AS I32
FUNCTION JoystickCount() AS I32
FUNCTION JoystickGuid(handle AS I32) AS STRING
FUNCTION JoystickHat(handle AS I32, hat AS I32) AS I32
FUNCTION JoystickIdAt(idx AS I32) AS I32
FUNCTION JoystickInstanceId(handle AS I32) AS I32
FUNCTION JoystickName(handle AS I32) AS STRING
FUNCTION JoystickNameForId(instanceId AS I32) AS STRING
FUNCTION JoystickNumAxes(handle AS I32) AS I32
FUNCTION JoystickNumBalls(handle AS I32) AS I32
FUNCTION JoystickNumButtons(handle AS I32) AS I32
FUNCTION JoystickNumHats(handle AS I32) AS I32
FUNCTION JoystickPlayerIndex(handle AS I32) AS I32
FUNCTION JoystickPowerPercent(handle AS I32) AS I32
FUNCTION JoystickPowerState(handle AS I32) AS I32
FUNCTION JoystickProduct(handle AS I32) AS I32
FUNCTION JoystickProductForId(instanceId AS I32) AS I32
FUNCTION JoystickRumble(handle AS I32, low AS I32, high AS I32, ms AS I32) AS I32
FUNCTION JoystickSetPlayerIndex(handle AS I32, index AS I32) AS I32
FUNCTION JoystickType(handle AS I32) AS I32
FUNCTION JoystickTypeForId(instanceId AS I32) AS I32
FUNCTION JoystickVendor(handle AS I32) AS I32
FUNCTION JoystickVendorForId(instanceId AS I32) AS I32
FUNCTION OpenGamepad(instanceId AS I32) AS I32
FUNCTION OpenJoystick(instanceId AS I32) AS I32
FUNCTION SetVirtualGamepadAxis(handle AS I32, axis AS I32, value AS I32) AS I32
FUNCTION SetVirtualGamepadButton(handle AS I32, button AS I32, down AS I32) AS I32
FUNCTION SetVirtualJoystickAxis(handle AS I32, axis AS I32, value AS I32) AS I32
FUNCTION SetVirtualJoystickButton(handle AS I32, button AS I32, down AS I32) AS I32
FUNCTION SetVirtualJoystickHat(handle AS I32, hat AS I32, value AS I32) AS I32
SUB CloseGamepad(handle AS I32)
SUB CloseJoystick(handle AS I32)
```

### Klavye, fare, imleç ve olaylar

```basic
FUNCTION CaptureMouse(enabled AS I32) AS I32
FUNCTION CursorVisible() AS I32
FUNCTION DropCount() AS I32
FUNCTION GetModState() AS I32
FUNCTION GetMouseWheelX() AS F64
FUNCTION GetMouseWheelY() AS F64
FUNCTION GetMouseX() AS I32
FUNCTION GetMouseY() AS I32
FUNCTION GetScancodeName(scancode AS I32) AS STRING
FUNCTION GlobalMouse(which AS I32) AS I32
FUNCTION HasKeyboard() AS I32
FUNCTION HasMouse() AS I32
FUNCTION HasScreenKeyboard() AS I32
FUNCTION HideCursor() AS I32
FUNCTION KeyboardCount() AS I32
FUNCTION KeyDown(scancode AS I32) AS I32
FUNCTION KeyFromScancode(scancode AS I32) AS I32
FUNCTION KeyName(keycode AS I32) AS STRING
FUNCTION KeyPressed(scancode AS I32) AS I32
FUNCTION KeyReleased(scancode AS I32) AS I32
FUNCTION LastKey() AS I32
FUNCTION MouseButtonDown(button AS I32) AS I32
FUNCTION MouseButtonPressed(button AS I32) AS I32
FUNCTION MouseButtonReleased(button AS I32) AS I32
FUNCTION MouseCount() AS I32
FUNCTION MouseRelX() AS F64
FUNCTION MouseRelY() AS F64
FUNCTION PushDrop(text AS STRING) AS I32
FUNCTION PushKey(scancode AS I32, down AS I32) AS I32
FUNCTION PushMouseButton(button AS I32, down AS I32, x AS F64, y AS F64) AS I32
FUNCTION PushMouseMotion(x AS F64, y AS F64, xrel AS F64, yrel AS F64) AS I32
FUNCTION PushMouseWheel(x AS F64, y AS F64) AS I32
FUNCTION PushQuit() AS I32
FUNCTION ScancodeFromKey(keycode AS I32) AS I32
FUNCTION ScancodeFromName(name AS STRING) AS I32
FUNCTION SetSystemCursor(id AS I32) AS I32
FUNCTION ShouldQuit() AS I32
FUNCTION ShowCursor() AS I32
FUNCTION TakeDeviceEvents(which AS I32) AS I32
FUNCTION TakeDrop() AS STRING
FUNCTION TouchDeviceCount() AS I32
FUNCTION TouchDeviceIdAt(index AS I32) AS I64
FUNCTION TouchDeviceName(id AS I64) AS STRING
FUNCTION TouchDeviceType(id AS I64) AS I32
FUNCTION TouchFinger(id AS I64, index AS I32, which AS I32) AS F64
FUNCTION TouchFingerCount(id AS I64) AS I32
FUNCTION WarpMouseGlobal(x AS F64, y AS F64) AS I32
SUB ClearQuit()
SUB FlushEvents()
SUB PumpEvents()
SUB SetModState(mods AS I32)
```

### Zaman ve takvim

```basic
FUNCTION CurrentTimeNS() AS I64
FUNCTION DatePart(ns AS I64, localTime AS I32, which AS I32) AS I32
FUNCTION DayOfYear(year AS I32, month AS I32, day AS I32) AS I32
FUNCTION DaysInMonth(year AS I32, month AS I32) AS I32
FUNCTION GetTicks() AS I64
FUNCTION GetTicksNS() AS I64
FUNCTION PerfCounter() AS I64
FUNCTION PerfFrequency() AS I64
SUB Delay(ms AS I32)
SUB DelayNS(ns AS I64)
SUB DelayPreciseNS(ns AS I64)
```

### Dosya sistemi

```basic
FUNCTION BasePath() AS STRING
FUNCTION CopyFile(oldPath AS STRING, newPath AS STRING) AS I32
FUNCTION CreateDirectory(path AS STRING) AS I32
FUNCTION CurrentDirectory() AS STRING
FUNCTION ListDirectory(path AS STRING, pattern AS STRING) AS I32
FUNCTION ListItem(index AS I32) AS STRING
FUNCTION PathModifyTime(path AS STRING) AS I64
FUNCTION PathSize(path AS STRING) AS I64
FUNCTION PathType(path AS STRING) AS I32
FUNCTION PrefPath(org AS STRING, app AS STRING) AS STRING
FUNCTION RemovePath(path AS STRING) AS I32
FUNCTION RenamePath(oldPath AS STRING, newPath AS STRING) AS I32
```

### Sistem, güç, yerel ayar

```basic
FUNCTION CPUCacheLineSize() AS I32
FUNCTION CPUCount() AS I32
FUNCTION CPUFeature(which AS I32) AS I32
FUNCTION IsTablet() AS I32
FUNCTION IsTV() AS I32
FUNCTION LocaleCount() AS I32
FUNCTION LocaleCountry(index AS I32) AS STRING
FUNCTION LocaleLanguage(index AS I32) AS STRING
FUNCTION PowerPercent() AS I32
FUNCTION PowerSeconds() AS I32
FUNCTION PowerState() AS I32
FUNCTION SystemRAMMB() AS I32
```

