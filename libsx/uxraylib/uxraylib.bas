' uXBasic raylib + raygui scalar C ABI wrapper.
' Struct-heavy upstream calls are flattened by uxraylib.dll.
NAMESPACE uxraylib

CONST KEY_ESCAPE = 256
CONST KEY_SPACE = 32
CONST KEY_RIGHT = 262
CONST KEY_LEFT = 263
CONST KEY_DOWN = 264
CONST KEY_UP = 265
CONST KEY_A = 65
CONST KEY_D = 68
CONST KEY_S = 83
CONST KEY_W = 87

FUNCTION AdapterVersion() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_adapter_version", I32, CDECL)
END FUNCTION
FUNCTION RaylibVersion() AS STRING
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_raylib_version", STRPTR, CDECL)
END FUNCTION
FUNCTION RayguiVersion() AS STRING
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_raygui_version", STRPTR, CDECL)
END FUNCTION
FUNCTION RectangleArea(width AS F64, height AS F64) AS F64
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_rectangle_area", F64, CDECL, "F64,F64", width, height)
END FUNCTION
FUNCTION ColorRGBA(r AS I32, g AS I32, b AS I32, a AS I32) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_rgba", U32, CDECL, "I32,I32,I32,I32", r, g, b, a)
END FUNCTION
SUB InitWindow(width AS I32, height AS I32, title AS STRING)
    CALL(DLL, "uxraylib.dll", "uxraylib_init_window", VOID, CDECL, "I32,I32,STRPTR", width, height, title)
END SUB
FUNCTION WindowShouldClose() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_window_should_close", I32, CDECL)
END FUNCTION
FUNCTION WindowReady() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_window_ready", I32, CDECL)
END FUNCTION
SUB SetTargetFPS(fps AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_target_fps", VOID, CDECL, "I32", fps)
END SUB
FUNCTION FrameTime() AS F64
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_frame_time", F64, CDECL)
END FUNCTION
FUNCTION KeyDown(key AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_key_down", I32, CDECL, "I32", key)
END FUNCTION
FUNCTION KeyPressed(key AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_key_pressed", I32, CDECL, "I32", key)
END FUNCTION
SUB BeginDrawing()
    CALL(DLL, "uxraylib.dll", "uxraylib_begin_drawing", VOID, CDECL)
END SUB
SUB EndDrawing()
    CALL(DLL, "uxraylib.dll", "uxraylib_end_drawing", VOID, CDECL)
END SUB
SUB ClearBackground(r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_clear_background", VOID, CDECL, "I32,I32,I32,I32", r, g, b, a)
END SUB
SUB DrawText(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_text", VOID, CDECL, "STRPTR,I32,I32,I32,I32,I32,I32,I32", text, x, y, fontSize, r, g, b, a)
END SUB
SUB DrawCircle(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_circle", VOID, CDECL, "F64,F64,F64,I32,I32,I32,I32", x, y, radius, r, g, b, a)
END SUB
SUB DrawRectangle(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_rectangle", VOID, CDECL, "F64,F64,F64,F64,I32,I32,I32,I32", x, y, width, height, r, g, b, a)
END SUB
FUNCTION CircleCollision(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_circle_collision", I32, CDECL, "F64,F64,F64,F64,F64,F64", ax, ay, ar, bx, by, br)
END FUNCTION
FUNCTION LoadTexture(path AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_texture_load", I32, CDECL, "STRPTR", path)
END FUNCTION
FUNCTION TextureWidth(handle AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_texture_width", I32, CDECL, "I32", handle)
END FUNCTION
FUNCTION TextureHeight(handle AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_texture_height", I32, CDECL, "I32", handle)
END FUNCTION
SUB UnloadTexture(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_texture_unload", VOID, CDECL, "I32", handle)
END SUB
FUNCTION LoadFont(path AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_font_load", I32, CDECL, "STRPTR", path)
END FUNCTION
SUB DrawFont(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_font_draw", VOID, CDECL, "I32,STRPTR,F64,F64,F64,F64,I32,I32,I32,I32", handle, text, x, y, size, spacing, r, g, b, a)
END SUB
SUB UnloadFont(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_font_unload", VOID, CDECL, "I32", handle)
END SUB
SUB SetCameraScroll(x AS F64, y AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_camera_scroll", VOID, CDECL, "F64,F64", x, y)
END SUB
SUB DrawSprite(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_sprite", VOID, CDECL, "I32,F64,F64,F64,F64,F64,F64,F64,F64", handle, sourceX, sourceY, sourceWidth, sourceHeight, worldX, worldY, scale, rotation)
END SUB
FUNCTION RectCollision(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_rect_collision", I32, CDECL, "F64,F64,F64,F64,F64,F64,F64,F64", ax, ay, aw, ah, bx, by, bw, bh)
END FUNCTION
FUNCTION SpriteFrame(frame AS I32, frameCount AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_sprite_frame", I32, CDECL, "I32,I32", frame, frameCount)
END FUNCTION
FUNCTION GuiButton(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraygui_button", I32, CDECL, "F64,F64,F64,F64,STRPTR", x, y, width, height, text)
END FUNCTION
SUB InitAudio()
    CALL(DLL, "uxraylib.dll", "uxraylib_init_audio", VOID, CDECL)
END SUB
FUNCTION AudioReady() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_audio_ready", I32, CDECL)
END FUNCTION
SUB CloseAudio()
    CALL(DLL, "uxraylib.dll", "uxraylib_close_audio", VOID, CDECL)
END SUB
SUB CloseWindow()
    CALL(DLL, "uxraylib.dll", "uxraylib_close_window", VOID, CDECL)
END SUB

' ---- Window / app (extended) ----
FUNCTION IsWindowFullscreen() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_is_window_fullscreen", I32, CDECL)
END FUNCTION
FUNCTION IsWindowFocused() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_is_window_focused", I32, CDECL)
END FUNCTION
FUNCTION IsWindowResized() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_is_window_resized", I32, CDECL)
END FUNCTION
FUNCTION IsWindowMinimized() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_is_window_minimized", I32, CDECL)
END FUNCTION
FUNCTION IsWindowMaximized() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_is_window_maximized", I32, CDECL)
END FUNCTION
SUB ToggleFullscreen()
    CALL(DLL, "uxraylib.dll", "uxraylib_toggle_fullscreen", VOID, CDECL)
END SUB
SUB SetWindowTitle(title AS STRING)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_window_title", VOID, CDECL, "STRPTR", title)
END SUB
SUB SetWindowSize(width AS I32, height AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_window_size", VOID, CDECL, "I32,I32", width, height)
END SUB
SUB SetWindowPosition(x AS I32, y AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_window_position", VOID, CDECL, "I32,I32", x, y)
END SUB
SUB SetWindowMinSize(width AS I32, height AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_window_min_size", VOID, CDECL, "I32,I32", width, height)
END SUB
FUNCTION GetScreenWidth() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_screen_width", I32, CDECL)
END FUNCTION
FUNCTION GetScreenHeight() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_screen_height", I32, CDECL)
END FUNCTION
FUNCTION GetFPS() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_fps", I32, CDECL)
END FUNCTION
FUNCTION GetTime() AS F64
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_time", F64, CDECL)
END FUNCTION
SUB SetConfigFlags(flags AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_config_flags", VOID, CDECL, "U32", flags)
END SUB
SUB TakeScreenshot(fileName AS STRING)
    CALL(DLL, "uxraylib.dll", "uxraylib_take_screenshot", VOID, CDECL, "STRPTR", fileName)
END SUB
SUB WaitTime(seconds AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_wait_time", VOID, CDECL, "F64", seconds)
END SUB

' ---- Cursor ----
SUB ShowCursor()
    CALL(DLL, "uxraylib.dll", "uxraylib_show_cursor", VOID, CDECL)
END SUB
SUB HideCursor()
    CALL(DLL, "uxraylib.dll", "uxraylib_hide_cursor", VOID, CDECL)
END SUB
FUNCTION IsCursorHidden() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_is_cursor_hidden", I32, CDECL)
END FUNCTION
SUB EnableCursor()
    CALL(DLL, "uxraylib.dll", "uxraylib_enable_cursor", VOID, CDECL)
END SUB
SUB DisableCursor()
    CALL(DLL, "uxraylib.dll", "uxraylib_disable_cursor", VOID, CDECL)
END SUB

' ---- Random ----
SUB SetRandomSeed(seed AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_random_seed", VOID, CDECL, "U32", seed)
END SUB
FUNCTION GetRandomValue(minVal AS I32, maxVal AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_random_value", I32, CDECL, "I32,I32", minVal, maxVal)
END FUNCTION

' ---- Keyboard (extended) ----
FUNCTION KeyReleased(key AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_key_released", I32, CDECL, "I32", key)
END FUNCTION
FUNCTION KeyUp(key AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_key_up", I32, CDECL, "I32", key)
END FUNCTION
FUNCTION GetKeyPressed() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_key_pressed", I32, CDECL)
END FUNCTION
FUNCTION GetCharPressed() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_char_pressed", I32, CDECL)
END FUNCTION
SUB SetExitKey(key AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_exit_key", VOID, CDECL, "I32", key)
END SUB

' ---- Mouse ----
FUNCTION MouseButtonPressed(button AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_mouse_button_pressed", I32, CDECL, "I32", button)
END FUNCTION
FUNCTION MouseButtonDown(button AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_mouse_button_down", I32, CDECL, "I32", button)
END FUNCTION
FUNCTION MouseButtonReleased(button AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_mouse_button_released", I32, CDECL, "I32", button)
END FUNCTION
FUNCTION MouseButtonUp(button AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_mouse_button_up", I32, CDECL, "I32", button)
END FUNCTION
FUNCTION GetMouseX() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_mouse_x", I32, CDECL)
END FUNCTION
FUNCTION GetMouseY() AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_mouse_y", I32, CDECL)
END FUNCTION
SUB SetMousePosition(x AS I32, y AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_mouse_position", VOID, CDECL, "I32,I32", x, y)
END SUB
FUNCTION GetMouseWheelMove() AS F64
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_mouse_wheel_move", F64, CDECL)
END FUNCTION

' ---- Basic shapes drawing (extended) ----
SUB DrawPixel(x AS I32, y AS I32, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_pixel", VOID, CDECL, "I32,I32,I32,I32,I32,I32", x, y, r, g, b, a)
END SUB
SUB DrawLine(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_line", VOID, CDECL, "F64,F64,F64,F64,F64,I32,I32,I32,I32", x1, y1, x2, y2, thick, r, g, b, a)
END SUB
SUB DrawCircleLines(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_circle_lines", VOID, CDECL, "F64,F64,F64,I32,I32,I32,I32", x, y, radius, r, g, b, a)
END SUB
' color1/color2 are packed RGBA U32 values -- build one with ColorRGBA(r,g,b,a).
SUB DrawCircleGradient(x AS F64, y AS F64, radius AS F64, color1 AS U32, color2 AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_circle_gradient", VOID, CDECL, "F64,F64,F64,U32,U32", x, y, radius, color1, color2)
END SUB
SUB DrawEllipse(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_ellipse", VOID, CDECL, "F64,F64,F64,F64,I32,I32,I32,I32", x, y, radiusH, radiusV, r, g, b, a)
END SUB
SUB DrawEllipseLines(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_ellipse_lines", VOID, CDECL, "F64,F64,F64,F64,I32,I32,I32,I32", x, y, radiusH, radiusV, r, g, b, a)
END SUB
SUB DrawRectangleLines(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_rectangle_lines", VOID, CDECL, "F64,F64,F64,F64,I32,I32,I32,I32", x, y, width, height, r, g, b, a)
END SUB
SUB DrawRectangleRounded(x AS F64, y AS F64, width AS F64, height AS F64, roundness AS F64, segments AS I32, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_rectangle_rounded", VOID, CDECL, "F64,F64,F64,F64,F64,I32,I32,I32,I32,I32", x, y, width, height, roundness, segments, r, g, b, a)
END SUB
' color1/color2 are packed RGBA U32 values -- build one with ColorRGBA(r,g,b,a).
SUB DrawRectangleGradientV(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_rectangle_gradient_v", VOID, CDECL, "F64,F64,F64,F64,U32,U32", x, y, width, height, color1, color2)
END SUB
SUB DrawRectangleGradientH(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_rectangle_gradient_h", VOID, CDECL, "F64,F64,F64,F64,U32,U32", x, y, width, height, color1, color2)
END SUB
SUB DrawTriangle(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_triangle", VOID, CDECL, "F64,F64,F64,F64,F64,F64,I32,I32,I32,I32", x1, y1, x2, y2, x3, y3, r, g, b, a)
END SUB
SUB DrawTriangleLines(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_triangle_lines", VOID, CDECL, "F64,F64,F64,F64,F64,F64,I32,I32,I32,I32", x1, y1, x2, y2, x3, y3, r, g, b, a)
END SUB
SUB DrawPoly(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_poly", VOID, CDECL, "F64,F64,I32,F64,F64,I32,I32,I32,I32", x, y, sides, radius, rotation, r, g, b, a)
END SUB
SUB DrawPolyLines(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_poly_lines", VOID, CDECL, "F64,F64,I32,F64,F64,I32,I32,I32,I32", x, y, sides, radius, rotation, r, g, b, a)
END SUB

' ---- Collision (extended) ----
FUNCTION CollisionCircleRec(cx AS F64, cy AS F64, radius AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_collision_circle_rec", I32, CDECL, "F64,F64,F64,F64,F64,F64,F64", cx, cy, radius, rx, ry, rw, rh)
END FUNCTION
FUNCTION CollisionPointRec(px AS F64, py AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_collision_point_rec", I32, CDECL, "F64,F64,F64,F64,F64,F64", px, py, rx, ry, rw, rh)
END FUNCTION
FUNCTION CollisionPointCircle(px AS F64, py AS F64, cx AS F64, cy AS F64, radius AS F64) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_collision_point_circle", I32, CDECL, "F64,F64,F64,F64,F64", px, py, cx, cy, radius)
END FUNCTION
FUNCTION CollisionPointTriangle(px AS F64, py AS F64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_collision_point_triangle", I32, CDECL, "F64,F64,F64,F64,F64,F64,F64,F64", px, py, x1, y1, x2, y2, x3, y3)
END FUNCTION

' ---- Text ----
FUNCTION MeasureText(text AS STRING, fontSize AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_measure_text", I32, CDECL, "STRPTR,I32", text, fontSize)
END FUNCTION
SUB DrawFPS(x AS I32, y AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_fps", VOID, CDECL, "I32,I32", x, y)
END SUB

' ---- Textures (extended) ----
FUNCTION TextureValid(handle AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_texture_valid", I32, CDECL, "I32", handle)
END FUNCTION
SUB DrawTexture(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_texture", VOID, CDECL, "I32,F64,F64,I32,I32,I32,I32", handle, x, y, r, g, b, a)
END SUB
SUB DrawTextureEx(handle AS I32, x AS F64, y AS F64, rotation AS F64, scale AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_texture_ex", VOID, CDECL, "I32,F64,F64,F64,F64,I32,I32,I32,I32", handle, x, y, rotation, scale, r, g, b, a)
END SUB

' ---- Audio: Sound ----
FUNCTION LoadSound(path AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_sound_load", I32, CDECL, "STRPTR", path)
END FUNCTION
SUB PlaySound(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_play", VOID, CDECL, "I32", handle)
END SUB
SUB StopSound(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_stop", VOID, CDECL, "I32", handle)
END SUB
SUB PauseSound(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_pause", VOID, CDECL, "I32", handle)
END SUB
SUB ResumeSound(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_resume", VOID, CDECL, "I32", handle)
END SUB
FUNCTION SoundPlaying(handle AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_sound_playing", I32, CDECL, "I32", handle)
END FUNCTION
SUB SetSoundVolume(handle AS I32, volume AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_set_volume", VOID, CDECL, "I32,F64", handle, volume)
END SUB
SUB SetSoundPitch(handle AS I32, pitch AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_set_pitch", VOID, CDECL, "I32,F64", handle, pitch)
END SUB
SUB UnloadSound(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_sound_unload", VOID, CDECL, "I32", handle)
END SUB

' ---- Audio: Music stream ----
FUNCTION LoadMusicStream(path AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_music_load", I32, CDECL, "STRPTR", path)
END FUNCTION
SUB PlayMusicStream(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_play", VOID, CDECL, "I32", handle)
END SUB
SUB UpdateMusicStream(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_update", VOID, CDECL, "I32", handle)
END SUB
SUB StopMusicStream(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_stop", VOID, CDECL, "I32", handle)
END SUB
SUB PauseMusicStream(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_pause", VOID, CDECL, "I32", handle)
END SUB
SUB ResumeMusicStream(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_resume", VOID, CDECL, "I32", handle)
END SUB
FUNCTION MusicStreamPlaying(handle AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_music_playing", I32, CDECL, "I32", handle)
END FUNCTION
SUB SetMusicVolume(handle AS I32, volume AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_set_volume", VOID, CDECL, "I32,F64", handle, volume)
END SUB
FUNCTION GetMusicTimePlayed(handle AS I32) AS F64
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_music_time_played", F64, CDECL, "I32", handle)
END FUNCTION
FUNCTION GetMusicTimeLength(handle AS I32) AS F64
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_music_time_length", F64, CDECL, "I32", handle)
END FUNCTION
SUB UnloadMusicStream(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_music_unload", VOID, CDECL, "I32", handle)
END SUB
SUB SetMasterVolume(volume AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_master_volume", VOID, CDECL, "F64", volume)
END SUB

' ---- RenderTexture (offscreen / render-to-texture) ----
FUNCTION LoadRenderTexture(width AS I32, height AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_render_texture_load", I32, CDECL, "I32,I32", width, height)
END FUNCTION
FUNCTION RenderTextureValid(handle AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_render_texture_valid", I32, CDECL, "I32", handle)
END FUNCTION
SUB UnloadRenderTexture(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_render_texture_unload", VOID, CDECL, "I32", handle)
END SUB
SUB BeginTextureMode(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_begin_texture_mode", VOID, CDECL, "I32", handle)
END SUB
SUB EndTextureMode()
    CALL(DLL, "uxraylib.dll", "uxraylib_end_texture_mode", VOID, CDECL)
END SUB
SUB DrawRenderTexture(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_render_texture", VOID, CDECL, "I32,F64,F64,I32,I32,I32,I32", handle, x, y, r, g, b, a)
END SUB

' ---- Texture configuration ----
SUB TextureSetFilter(handle AS I32, filter AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_texture_set_filter", VOID, CDECL, "I32,I32", handle, filter)
END SUB
SUB TextureSetWrap(handle AS I32, wrap AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_texture_set_wrap", VOID, CDECL, "I32,I32", handle, wrap)
END SUB
SUB TextureGenMipmaps(handle AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_texture_gen_mipmaps", VOID, CDECL, "I32", handle)
END SUB
' rgba is a packed RGBA U32 value -- build one with ColorRGBA(r,g,b,a).
SUB DrawTextureRec(handle AS I32, srcX AS F64, srcY AS F64, srcW AS F64, srcH AS F64, x AS F64, y AS F64, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_texture_rec", VOID, CDECL, "I32,F64,F64,F64,F64,F64,F64,U32", handle, srcX, srcY, srcW, srcH, x, y, rgba)
END SUB
' dest size is srcW/srcH * scale (uniform scaling); use DrawTextureRec instead
' if you need an unscaled 1:1 sprite-sheet cutout.
SUB DrawTexturePro(handle AS I32, srcX AS F64, srcY AS F64, srcW AS F64, srcH AS F64, dstX AS F64, dstY AS F64, scale AS F64, rotation AS F64, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_texture_pro", VOID, CDECL, "I32,F64,F64,F64,F64,F64,F64,F64,F64,U32", handle, srcX, srcY, srcW, srcH, dstX, dstY, scale, rotation, rgba)
END SUB

' ---- Color utilities (all take/return packed RGBA U32 -- build one with ColorRGBA(r,g,b,a)) ----
FUNCTION ColorFade(rgba AS U32, alpha AS F64) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_fade", U32, CDECL, "U32,F64", rgba, alpha)
END FUNCTION
FUNCTION ColorAlpha(rgba AS U32, alpha AS F64) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_alpha", U32, CDECL, "U32,F64", rgba, alpha)
END FUNCTION
FUNCTION ColorBrightness(rgba AS U32, factor AS F64) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_brightness", U32, CDECL, "U32,F64", rgba, factor)
END FUNCTION
FUNCTION ColorContrast(rgba AS U32, contrast AS F64) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_contrast", U32, CDECL, "U32,F64", rgba, contrast)
END FUNCTION
FUNCTION ColorLerp(color1 AS U32, color2 AS U32, factor AS F64) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_lerp", U32, CDECL, "U32,U32,F64", color1, color2, factor)
END FUNCTION
FUNCTION ColorIsEqual(color1 AS U32, color2 AS U32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_color_is_equal", I32, CDECL, "U32,U32", color1, color2)
END FUNCTION
FUNCTION GetColor(hexValue AS U32) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_color", U32, CDECL, "U32", hexValue)
END FUNCTION

' ---- File system utilities ----
FUNCTION FileExists(fileName AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_file_exists", I32, CDECL, "STRPTR", fileName)
END FUNCTION
FUNCTION DirectoryExists(dirPath AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_directory_exists", I32, CDECL, "STRPTR", dirPath)
END FUNCTION
FUNCTION GetFileExtension(fileName AS STRING) AS STRING
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_file_extension", STRPTR, CDECL, "STRPTR", fileName)
END FUNCTION
FUNCTION GetFileNameOnly(filePath AS STRING) AS STRING
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_file_name_only", STRPTR, CDECL, "STRPTR", filePath)
END FUNCTION
FUNCTION GetWorkingDirectory() AS STRING
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_get_working_directory", STRPTR, CDECL)
END FUNCTION

' ---- Text (extended) ----
SUB SetTextLineSpacing(spacing AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_set_text_line_spacing", VOID, CDECL, "I32", spacing)
END SUB

' ---- Camera2D (scrolling/zooming view) ----
SUB BeginMode2D(offsetX AS F64, offsetY AS F64, targetX AS F64, targetY AS F64, rotation AS F64, zoom AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_begin_mode_2d", VOID, CDECL, "F64,F64,F64,F64,F64,F64", offsetX, offsetY, targetX, targetY, rotation, zoom)
END SUB
SUB EndMode2D()
    CALL(DLL, "uxraylib.dll", "uxraylib_end_mode_2d", VOID, CDECL)
END SUB

' ---- Basic shapes drawing (more) ----
' rgba is a packed RGBA U32 value -- build one with ColorRGBA(r,g,b,a).
SUB DrawRing(x AS F64, y AS F64, innerRadius AS F64, outerRadius AS F64, startAngle AS F64, endAngle AS F64, segments AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_ring", VOID, CDECL, "F64,F64,F64,F64,F64,F64,I32,U32", x, y, innerRadius, outerRadius, startAngle, endAngle, segments, rgba)
END SUB
SUB DrawLineBezier(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_draw_line_bezier", VOID, CDECL, "F64,F64,F64,F64,F64,U32", x1, y1, x2, y2, thick, rgba)
END SUB

' ---- Image manipulation (CPU-side; works without a window / GL context) ----
' An image is an opaque handle (I32, 0 = failure). Colors are packed like ColorRGBA(r,g,b,a).
FUNCTION ImageGenColor(width AS I32, height AS I32, rgba AS U32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_gen_color", I32, CDECL, "I32,I32,U32", width, height, rgba)
END FUNCTION
FUNCTION ImageGenChecked(width AS I32, height AS I32, checksX AS I32, checksY AS I32, color1 AS U32, color2 AS U32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_gen_checked", I32, CDECL, "I32,I32,I32,I32,U32,U32", width, height, checksX, checksY, color1, color2)
END FUNCTION
FUNCTION ImageGenGradientLinear(width AS I32, height AS I32, direction AS I32, startColor AS U32, endColor AS U32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_gen_gradient_linear", I32, CDECL, "I32,I32,I32,U32,U32", width, height, direction, startColor, endColor)
END FUNCTION
FUNCTION ImageLoad(path AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_load", I32, CDECL, "STRPTR", path)
END FUNCTION
FUNCTION ImageCopy(image AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_copy", I32, CDECL, "I32", image)
END FUNCTION
SUB ImageUnload(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_unload", VOID, CDECL, "I32", image)
END SUB
FUNCTION ImageValid(image AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_valid", I32, CDECL, "I32", image)
END FUNCTION
FUNCTION ImageWidth(image AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_width", I32, CDECL, "I32", image)
END FUNCTION
FUNCTION ImageHeight(image AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_height", I32, CDECL, "I32", image)
END FUNCTION
FUNCTION ImagePixelFormat(image AS I32) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_format_of", I32, CDECL, "I32", image)
END FUNCTION
FUNCTION ImageGetColor(image AS I32, x AS I32, y AS I32) AS U32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_get_color", U32, CDECL, "I32,I32,I32", image, x, y)
END FUNCTION
SUB ImageClearBackground(image AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_clear_background", VOID, CDECL, "I32,U32", image, rgba)
END SUB
SUB ImageDrawPixel(image AS I32, x AS I32, y AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_draw_pixel", VOID, CDECL, "I32,I32,I32,U32", image, x, y, rgba)
END SUB
SUB ImageDrawLine(image AS I32, x1 AS I32, y1 AS I32, x2 AS I32, y2 AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_draw_line", VOID, CDECL, "I32,I32,I32,I32,I32,U32", image, x1, y1, x2, y2, rgba)
END SUB
SUB ImageDrawCircle(image AS I32, centerX AS I32, centerY AS I32, radius AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_draw_circle", VOID, CDECL, "I32,I32,I32,I32,U32", image, centerX, centerY, radius, rgba)
END SUB
SUB ImageDrawRectangle(image AS I32, x AS I32, y AS I32, width AS I32, height AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_draw_rectangle", VOID, CDECL, "I32,I32,I32,I32,I32,U32", image, x, y, width, height, rgba)
END SUB
SUB ImageResize(image AS I32, width AS I32, height AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_resize", VOID, CDECL, "I32,I32,I32", image, width, height)
END SUB
SUB ImageResizeNN(image AS I32, width AS I32, height AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_resize_nn", VOID, CDECL, "I32,I32,I32", image, width, height)
END SUB
SUB ImageCrop(image AS I32, x AS I32, y AS I32, width AS I32, height AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_crop", VOID, CDECL, "I32,I32,I32,I32,I32", image, x, y, width, height)
END SUB
SUB ImageFlipVertical(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_flip_vertical", VOID, CDECL, "I32", image)
END SUB
SUB ImageFlipHorizontal(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_flip_horizontal", VOID, CDECL, "I32", image)
END SUB
SUB ImageRotateCW(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_rotate_cw", VOID, CDECL, "I32", image)
END SUB
SUB ImageRotateCCW(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_rotate_ccw", VOID, CDECL, "I32", image)
END SUB
SUB ImageColorInvert(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_color_invert", VOID, CDECL, "I32", image)
END SUB
SUB ImageColorGrayscale(image AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_color_grayscale", VOID, CDECL, "I32", image)
END SUB
SUB ImageColorContrast(image AS I32, contrast AS F64)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_color_contrast", VOID, CDECL, "I32,F64", image, contrast)
END SUB
SUB ImageColorBrightness(image AS I32, brightness AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_color_brightness", VOID, CDECL, "I32,I32", image, brightness)
END SUB
SUB ImageColorTint(image AS I32, rgba AS U32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_color_tint", VOID, CDECL, "I32,U32", image, rgba)
END SUB
SUB ImageConvertFormat(image AS I32, newFormat AS I32)
    CALL(DLL, "uxraylib.dll", "uxraylib_image_convert_format", VOID, CDECL, "I32,I32", image, newFormat)
END SUB
FUNCTION ImageExport(image AS I32, path AS STRING) AS I32
    RETURN CALL(DLL, "uxraylib.dll", "uxraylib_image_export", I32, CDECL, "I32,STRPTR", image, path)
END FUNCTION

' ---- raygui ----
SUB GuiLabel(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)
    CALL(DLL, "uxraylib.dll", "uxraygui_label", VOID, CDECL, "F64,F64,F64,F64,STRPTR", x, y, width, height, text)
END SUB

END NAMESPACE
