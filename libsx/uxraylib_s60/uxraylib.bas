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
END NAMESPACE
