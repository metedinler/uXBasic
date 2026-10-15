# uXBasic oyun, GUI, grafik ve ses katmanı

## Seçim

Ana katman `raylib 5.5 + raygui 5.0` olarak kuruldu. Raylib tek çalışma
kütüphanesiyle pencere, klavye/fare/gamepad, 2B/3B çizim ve miniaudio tabanlı
ses sağlar. Raygui tek başlık dosyalı anlık GUI katmanıdır. `SDL3 3.4.10`,
raylib kullanılamadığında veya daha düşük seviyeli platform denetimi
gerektiğinde yedek olarak kuruldu.

uXBasic'in doğrudan C struct ABI'sine bağımlı kalmaması için
`runtime_ext/uxraylib/uxraylib_adapter.c`, `Vector2`, `Rectangle` ve `Color`
gibi kayıtları dış sınırda skaler değerlere çevirir. Daha geniş, doğrudan
struct-by-value bağlamaları yeni UXCAPI kayıt tanımlayıcılarıyla üretilebilir.

## Derleme

Komut İstemi:

```bat
cd /d C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb
runtime_ext\uxraylib\build_wrappers.bat
```

PowerShell:

```powershell
Set-Location C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb
cmd /c .\runtime_ext\uxraylib\build_wrappers.bat
```

Betik şunları üretir ve `dist\libraries\bin` dizinine koyar:

- `uxraylib.dll`: uXBasic için raylib/raygui adaptörü
- `libraylib.dll`, `glfw3.dll`: ana çalışma bağımlılıkları
- `uxsdl3.dll`, `SDL3.dll`: yedek SDL3 katmanı

## Sağlık testi

Pencere açmadan ABI testi:

```powershell
$env:PATH = "$PWD\dist\libraries\bin;$env:PATH"
.\bin\uxb.exe run .\tests\multimedia_wrappers\wrapper_smoke.uxb --quiet
```

Gerçek pencere, OpenGL, raygui ve ses testi:

```powershell
$env:PATH = "$PWD\dist\libraries\bin;$env:PATH"
.\bin\uxb.exe run .\tests\multimedia_wrappers\window_audio_smoke.uxb --quiet
```

Beklenen ana satırlar:

```text
RAY_ADAPTER=100
AREA=60
SDL_ADAPTER=100
WINDOW_READY=1
AUDIO_READY=1
WINDOW_CLOSED=1
```

## uXBasic programında kullanım

```basic
INCLUDE "include/modules/uxraylib.uxmh"

uxraylib.InitWindow(800, 450, "İlk uXBasic oyunum")

WHILE uxraylib.WindowShouldClose() = 0
    uxraylib.BeginDrawing()
    uxraylib.ClearBackground(24, 28, 40, 255)
    uxraylib.DrawText("Merhaba uXBasic", 40, 40, 28, 255, 255, 255, 255)
    uxraylib.DrawCircle(400, 225, 50, 80, 180, 255, 255)
    uxraylib.EndDrawing()
WEND

uxraylib.CloseWindow()
```

GUI düğmesi çizim döngüsünün `BeginDrawing` ve `EndDrawing` çağrıları arasında
çalıştırılır:

```basic
IF uxraylib.GuiButton(20, 90, 160, 36, "Tıkla") <> 0 THEN
    PRINT "Düğmeye basıldı"
END IF
```

## Kaynak ve lisanslar

Raylib MSYS2 UCRT64 paketiyle kurulur. Raygui 5.0 başlığı sabit sürüm etiketi
üzerinden `runtime_ext/uxraylib/vendor/raygui.h` altında tutulur. Raylib ve
raygui lisansları aynı vendor dizinindedir. Böylece derleme bir sonraki ağ
erişiminde değişen `master` dalına bağlı değildir.
