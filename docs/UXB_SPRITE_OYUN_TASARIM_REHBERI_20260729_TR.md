# uXBasic Sprite ve Oyun Tasarım Rehberi

Bir 2B oyun döngüsü beş parçadan oluşur:

1. Klavye/girdi oku.
2. Karakter konumunu `FrameTime()` ile güncelle.
3. Çarpışmaları dünya koordinatlarında denetle.
4. Kamerayı oyuncuya göre ayarla.
5. Arka plan, sprite, yazı ve GUI’yi çiz.

## Temel API

| Fonksiyon | Giriş | Çıkış | Görev |
|---|---|---|---|
| `SetTargetFPS` | I32 | VOID | Hedef kare hızını belirler |
| `FrameTime` | yok | F64 | Son karenin saniye süresi |
| `KeyDown` | tuş I32 | I32 | Tuş basılı kaldığı sürece 1 |
| `KeyPressed` | tuş I32 | I32 | İlk basıldığı karede 1 |
| `LoadTexture` | STRING | I32 handle | Sprite/arka plan resmi yükler |
| `DrawSprite` | handle + kaynak/dünya dikdörtgeni | VOID | Sprite-sheet karesi çizer |
| `SetCameraScroll` | F64 x,y | VOID | Dünya koordinatlarını ekrana kaydırır |
| `RectCollision` | iki AABB | I32 | Dikdörtgen çarpışması |
| `CircleCollision` | iki merkez/yarıçap | I32 | Daire çarpışması |
| `DrawRectangle` | konum, boyut, RGBA | VOID | Platform veya yedek karakter çizer |
| `LoadFont` | STRING | I32 handle | TTF/OTF font yükler |
| `DrawFont` | font, metin, konum, boyut, renk | VOID | Özel fontla metin çizer |
| `UnloadFont` | I32 handle | VOID | Font kaynağını kapatır |

## Çarpışma ilkesi

Fizik ve çarpışma hesabı kamera uygulanmadan önce dünya koordinatında yapılır.
Kamera yalnız çizim sırasında kullanılır. Böylece ekran kaydırıldığında
çarpışma kutuları yerinden oynamaz.

```basic
hit = uxraylib.RectCollision(playerX, playerY, 64, 64, enemyX, enemyY, 64, 64)
IF hit THEN PRINT "collision"
```

## Sprite sheet

32×32 boyutunda dört kare yatay dizilmişse:

```basic
frame = uxraylib.SpriteFrame(frame + 1, 4)
uxraylib.DrawSprite(texture, frame * 32, 0, 32, 32, x, y, 2, 0)
```

`SpriteFrame` negatif ve taşmış kareleri güvenli aralığa getirir.

## Kaynak ömrü

Her başarılı `LoadTexture` çağrısı `UnloadTexture`, her `LoadFont` çağrısı
`UnloadFont` ile eşleşmelidir. Handle `0` ise yükleme başarısızdır ve çizim
yerine renkli dikdörtgen gibi bir yedek kullanılabilir.

Tam örnek:
`examples/games/sprite_collision_game.uxb`.

Pencere açmadan matematik/ABI testi:

```powershell
$env:PATH = "$PWD\dist\libraries\bin;$env:PATH"
.\bin\uxb.exe run .\tests\multimedia_wrappers\game_math_smoke.uxb `
  --interpreter-backend AST
```
