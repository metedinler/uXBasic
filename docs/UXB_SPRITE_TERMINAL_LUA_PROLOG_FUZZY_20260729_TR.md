# Sprite, terminal GUI, Lua, Prolog ve fuzzy mantık

## Sprite ve kamera

```basic
INCLUDE "include/modules/uxraylib.uxmh"

DIM texture AS I32
texture = uxraylib.LoadTexture("assets/hero.png")
uxraylib.SetCameraScroll(cameraX, cameraY)

' Sprite sheet içinden 32x32 kareyi dünya koordinatında çiz.
uxraylib.DrawSprite(texture, frame * 32, 0, 32, 32, playerX, playerY, 2, 0)

IF uxraylib.RectCollision(playerX, playerY, 64, 64, enemyX, enemyY, 64, 64) THEN
    PRINT "Çarpışma"
END IF

uxraylib.UnloadTexture(texture)
```

`SetCameraScroll` dünya koordinatından çıkarılan kamera konumudur.
`SpriteFrame(sayaç, kareSayısı)` negatif değerleri de güvenli biçimde
`0..kareSayısı-1` aralığına getirir. Texture değeri ham pointer değil, adaptörün
yönettiği güvenli bir handle'dır; her `LoadTexture` için `UnloadTexture`
çağrılmalıdır.

## Terminal sprite ve kaydırma

```basic
INCLUDE "include/modules/uxterminal.uxmh"

uxterminal.EnableAnsi()
uxterminal.Clear()
uxterminal.HideCursor()
uxterminal.SetScroll(cameraX, cameraY)
uxterminal.DrawSprite(20, 10, 46, 16, " /\\_/\\\\n( o.o )")
uxterminal.DrawText(2, 1, 15, 0, "Skor: 100")
uxterminal.ShowCursor()
```

Renkler ANSI 256 renk numarasıdır. `SetScroll`, sonraki terminal çizimlerinde
dünya koordinatından çıkarılır. `RectCollision` hücre tabanlı AABB kontrolüdür.

## Lua: doğrudan DLL

```basic
INCLUDE "include/modules/uxlogic.uxmh"

DIM state AS U64
uxlogic.LuaLoad("lua54.dll")
state = uxlogic.LuaNew()
uxlogic.LuaSetNumber(state, "input_value", 21)
uxlogic.LuaDoFile(state, "tests/logic_bridges/sample.lua")
PRINT uxlogic.LuaGetNumber(state, "answer")
uxlogic.LuaClose(state)
```

Lua state bir handle'dır. Her `LuaNew` çağrısı `LuaClose` ile kapatılmalıdır.

Lua'yı ayrı süreç olarak çalıştırmak:

```powershell
pwsh .\tools\script_bridges\run_lua.ps1 -Script .\tests\logic_bridges\sample.lua
```

## Prolog ve fuzzy-Prolog

uXBasic içinden:

```basic
ok = uxlogic.PrologQuery("tests/logic_bridges/sample.pl", "print_ancestor,print_fuzzy")
PRINT uxlogic.LastText()
```

Ayrı süreç olarak:

```powershell
pwsh .\tools\script_bridges\run_prolog.ps1 `
  -Script .\tests\logic_bridges\sample.pl `
  -Goal "print_ancestor,print_fuzzy"
```

SWI-Prolog tam runtime ağacı ve `boot.prc` istediği için yalnız
`libswipl.dll` kopyalanmaz. Köprü kurulu SWI-Prolog 10.x sürecini kullanır.
Bu, eksik runtime dosyasıyla çalışanmış gibi görünen kırık dağıtımı engeller.

## Fuzzy mantık

| Fonksiyon | Giriş | Çıkış | Anlam |
|---|---|---|---|
| `Triangle(x,a,b,c)` | F64 x4 | F64 | Üçgen üyelik |
| `Trapezoid(x,a,b,c,d)` | F64 x5 | F64 | Yamuk üyelik |
| `FuzzyAnd(a,b)` | F64 x2 | F64 | minimum |
| `FuzzyOr(a,b)` | F64 x2 | F64 | maksimum |
| `FuzzyNot(x)` | F64 | F64 | `1-x` |
| `Weighted(v1,w1,v2,w2)` | F64 x4 | F64 | ağırlıklı sonuç |

## Testler

```powershell
cmd /c .\runtime_ext\uxraylib\build_wrappers.bat
cmd /c .\runtime_ext\uxterminal\build_uxterminal.bat
cmd /c .\runtime_ext\uxlogic\build_uxlogic.bat

$env:PATH = "$PWD\dist\libraries\bin;$env:PATH"
.\bin\uxb.exe run .\tests\multimedia_wrappers\sprite_terminal_smoke.uxb --quiet
.\bin\uxb.exe run .\tests\logic_bridges\logic_smoke.uxb --quiet
```
