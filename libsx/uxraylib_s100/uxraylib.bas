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
END NAMESPACE
