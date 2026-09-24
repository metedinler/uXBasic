#define BUILD_LIBTYPE_SHARED
#define RAYGUI_IMPLEMENTATION
#include <raylib.h>
#include "vendor/raygui.h"
#include <string.h>

#if defined(_WIN32)
#define UX_EXPORT __declspec(dllexport)
#else
#define UX_EXPORT
#endif

#define UX_MAX_TEXTURES 1024
#define UX_MAX_FONTS 256
#define UX_MAX_SOUNDS 256
#define UX_MAX_MUSIC 64
#define UX_MAX_RENDER_TEXTURES 64
static Texture2D uxTextures[UX_MAX_TEXTURES];
static unsigned char uxTextureUsed[UX_MAX_TEXTURES];
static Font uxFonts[UX_MAX_FONTS];
static unsigned char uxFontUsed[UX_MAX_FONTS];
static Sound uxSounds[UX_MAX_SOUNDS];
static unsigned char uxSoundUsed[UX_MAX_SOUNDS];
static Music uxMusic[UX_MAX_MUSIC];
static unsigned char uxMusicUsed[UX_MAX_MUSIC];
static RenderTexture2D uxRenderTextures[UX_MAX_RENDER_TEXTURES];
static unsigned char uxRenderTextureUsed[UX_MAX_RENDER_TEXTURES];
static double uxCameraX = 0.0;
static double uxCameraY = 0.0;

UX_EXPORT int uxraylib_adapter_version(void) { return 100; }
UX_EXPORT const char *uxraylib_raylib_version(void) { return RAYLIB_VERSION; }
UX_EXPORT const char *uxraylib_raygui_version(void) { return RAYGUI_VERSION; }

UX_EXPORT unsigned int uxraylib_color_rgba(int r, int g, int b, int a)
{
    return ((unsigned int)(r & 255)) |
           ((unsigned int)(g & 255) << 8) |
           ((unsigned int)(b & 255) << 16) |
           ((unsigned int)(a & 255) << 24);
}

UX_EXPORT double uxraylib_rectangle_area(double width, double height)
{
    return (double)width * (double)height;
}

UX_EXPORT void uxraylib_init_window(int width, int height, const char *title)
{
    InitWindow(width, height, title);
}

UX_EXPORT int uxraylib_window_should_close(void) { return WindowShouldClose(); }
UX_EXPORT int uxraylib_window_ready(void) { return IsWindowReady(); }
UX_EXPORT void uxraylib_close_window(void) { CloseWindow(); }
UX_EXPORT void uxraylib_set_target_fps(int fps) { SetTargetFPS(fps); }
UX_EXPORT double uxraylib_frame_time(void) { return (double)GetFrameTime(); }
UX_EXPORT int uxraylib_key_down(int key) { return IsKeyDown(key); }
UX_EXPORT int uxraylib_key_pressed(int key) { return IsKeyPressed(key); }

UX_EXPORT void uxraylib_begin_drawing(void) { BeginDrawing(); }
UX_EXPORT void uxraylib_end_drawing(void) { EndDrawing(); }

UX_EXPORT void uxraylib_clear_background(int r, int g, int b, int a)
{
    ClearBackground((Color){ (unsigned char)r, (unsigned char)g,
                             (unsigned char)b, (unsigned char)a });
}

UX_EXPORT void uxraylib_draw_text(const char *text, int x, int y, int fontSize,
                                  int r, int g, int b, int a)
{
    DrawText(text, x, y, fontSize,
             (Color){ (unsigned char)r, (unsigned char)g,
                      (unsigned char)b, (unsigned char)a });
}

UX_EXPORT void uxraylib_draw_circle(double x, double y, double radius,
                                    int r, int g, int b, int a)
{
    DrawCircleV((Vector2){ (float)x, (float)y }, (float)radius,
                (Color){ (unsigned char)r, (unsigned char)g,
                         (unsigned char)b, (unsigned char)a });
}

UX_EXPORT void uxraylib_draw_rectangle(double x, double y, double width, double height,
                                       int r, int g, int b, int a)
{
    DrawRectangleRec((Rectangle){ (float)(x - uxCameraX), (float)(y - uxCameraY),
                                  (float)width, (float)height },
                     (Color){ (unsigned char)r, (unsigned char)g,
                              (unsigned char)b, (unsigned char)a });
}

UX_EXPORT int uxraylib_circle_collision(double ax, double ay, double ar,
                                        double bx, double by, double br)
{
    return CheckCollisionCircles((Vector2){ (float)ax, (float)ay }, (float)ar,
                                 (Vector2){ (float)bx, (float)by }, (float)br);
}

UX_EXPORT int uxraylib_texture_load(const char *path)
{
    Texture2D texture = LoadTexture(path);
    if (texture.id == 0) return 0;
    for (int i = 1; i < UX_MAX_TEXTURES; ++i) {
        if (!uxTextureUsed[i]) {
            uxTextures[i] = texture;
            uxTextureUsed[i] = 1;
            return i;
        }
    }
    UnloadTexture(texture);
    return 0;
}

UX_EXPORT int uxraylib_texture_width(int handle)
{
    return (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle])
        ? uxTextures[handle].width : 0;
}

UX_EXPORT int uxraylib_texture_height(int handle)
{
    return (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle])
        ? uxTextures[handle].height : 0;
}

UX_EXPORT void uxraylib_texture_unload(int handle)
{
    if (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle]) {
        UnloadTexture(uxTextures[handle]);
        memset(&uxTextures[handle], 0, sizeof(uxTextures[handle]));
        uxTextureUsed[handle] = 0;
    }
}

UX_EXPORT int uxraylib_font_load(const char *path)
{
    Font font = LoadFont(path);
    if (font.texture.id == 0) return 0;
    for (int i = 1; i < UX_MAX_FONTS; ++i) {
        if (!uxFontUsed[i]) {
            uxFonts[i] = font;
            uxFontUsed[i] = 1;
            return i;
        }
    }
    UnloadFont(font);
    return 0;
}

UX_EXPORT void uxraylib_font_draw(int handle, const char *text, double x, double y,
                                  double size, double spacing,
                                  int r, int g, int b, int a)
{
    if (handle <= 0 || handle >= UX_MAX_FONTS || !uxFontUsed[handle]) return;
    DrawTextEx(uxFonts[handle], text,
               (Vector2){ (float)(x - uxCameraX), (float)(y - uxCameraY) },
               (float)size, (float)spacing,
               (Color){ (unsigned char)r, (unsigned char)g,
                        (unsigned char)b, (unsigned char)a });
}

UX_EXPORT void uxraylib_font_unload(int handle)
{
    if (handle > 0 && handle < UX_MAX_FONTS && uxFontUsed[handle]) {
        UnloadFont(uxFonts[handle]);
        memset(&uxFonts[handle], 0, sizeof(uxFonts[handle]));
        uxFontUsed[handle] = 0;
    }
}

UX_EXPORT void uxraylib_set_camera_scroll(double x, double y)
{
    uxCameraX = x;
    uxCameraY = y;
}

UX_EXPORT void uxraylib_draw_sprite(int handle,
                                    double sourceX, double sourceY,
                                    double sourceWidth, double sourceHeight,
                                    double worldX, double worldY,
                                    double scale, double rotation)
{
    if (handle <= 0 || handle >= UX_MAX_TEXTURES || !uxTextureUsed[handle]) return;
    Rectangle source = { (float)sourceX, (float)sourceY,
                         (float)sourceWidth, (float)sourceHeight };
    Rectangle target = { (float)(worldX - uxCameraX), (float)(worldY - uxCameraY),
                         (float)(sourceWidth * scale), (float)(sourceHeight * scale) };
    Vector2 origin = { 0.0f, 0.0f };
    DrawTexturePro(uxTextures[handle], source, target, origin, (float)rotation, WHITE);
}

UX_EXPORT int uxraylib_rect_collision(double ax, double ay, double aw, double ah,
                                      double bx, double by, double bw, double bh)
{
    return CheckCollisionRecs(
        (Rectangle){ (float)ax, (float)ay, (float)aw, (float)ah },
        (Rectangle){ (float)bx, (float)by, (float)bw, (float)bh });
}

UX_EXPORT int uxraylib_sprite_frame(int frame, int frameCount)
{
    if (frameCount <= 0) return 0;
    int normalized = frame % frameCount;
    return (normalized < 0) ? normalized + frameCount : normalized;
}

UX_EXPORT int uxraygui_button(double x, double y, double width, double height,
                              const char *text)
{
    return GuiButton((Rectangle){ (float)x, (float)y, (float)width, (float)height }, text);
}

UX_EXPORT void uxraygui_label(double x, double y, double width, double height,
                              const char *text)
{
    GuiLabel((Rectangle){ (float)x, (float)y, (float)width, (float)height }, text);
}

UX_EXPORT void uxraylib_init_audio(void) { InitAudioDevice(); }
UX_EXPORT int uxraylib_audio_ready(void) { return IsAudioDeviceReady(); }
UX_EXPORT void uxraylib_set_master_volume(double volume) { SetMasterVolume((float)volume); }
UX_EXPORT void uxraylib_close_audio(void) { CloseAudioDevice(); }

/* ---- Window / app (core, extended) ---- */
UX_EXPORT int uxraylib_is_window_fullscreen(void) { return IsWindowFullscreen(); }
UX_EXPORT int uxraylib_is_window_focused(void) { return IsWindowFocused(); }
UX_EXPORT int uxraylib_is_window_resized(void) { return IsWindowResized(); }
UX_EXPORT int uxraylib_is_window_minimized(void) { return IsWindowMinimized(); }
UX_EXPORT int uxraylib_is_window_maximized(void) { return IsWindowMaximized(); }
UX_EXPORT void uxraylib_toggle_fullscreen(void) { ToggleFullscreen(); }
UX_EXPORT void uxraylib_set_window_title(const char *title) { SetWindowTitle(title); }
UX_EXPORT void uxraylib_set_window_size(int width, int height) { SetWindowSize(width, height); }
UX_EXPORT void uxraylib_set_window_position(int x, int y) { SetWindowPosition(x, y); }
UX_EXPORT void uxraylib_set_window_min_size(int width, int height) { SetWindowMinSize(width, height); }
UX_EXPORT int uxraylib_get_screen_width(void) { return GetScreenWidth(); }
UX_EXPORT int uxraylib_get_screen_height(void) { return GetScreenHeight(); }
UX_EXPORT int uxraylib_get_fps(void) { return GetFPS(); }
UX_EXPORT double uxraylib_get_time(void) { return GetTime(); }
UX_EXPORT void uxraylib_set_config_flags(unsigned int flags) { SetConfigFlags(flags); }
UX_EXPORT void uxraylib_take_screenshot(const char *fileName) { TakeScreenshot(fileName); }
UX_EXPORT void uxraylib_wait_time(double seconds) { WaitTime(seconds); }

/* ---- Cursor ---- */
UX_EXPORT void uxraylib_show_cursor(void) { ShowCursor(); }
UX_EXPORT void uxraylib_hide_cursor(void) { HideCursor(); }
UX_EXPORT int uxraylib_is_cursor_hidden(void) { return IsCursorHidden(); }
UX_EXPORT void uxraylib_enable_cursor(void) { EnableCursor(); }
UX_EXPORT void uxraylib_disable_cursor(void) { DisableCursor(); }

/* ---- Random ---- */
UX_EXPORT void uxraylib_set_random_seed(unsigned int seed) { SetRandomSeed(seed); }
UX_EXPORT int uxraylib_get_random_value(int minVal, int maxVal) { return GetRandomValue(minVal, maxVal); }

/* ---- Keyboard (extended) ---- */
UX_EXPORT int uxraylib_key_released(int key) { return IsKeyReleased(key); }
UX_EXPORT int uxraylib_key_up(int key) { return IsKeyUp(key); }
UX_EXPORT int uxraylib_get_key_pressed(void) { return GetKeyPressed(); }
UX_EXPORT int uxraylib_get_char_pressed(void) { return GetCharPressed(); }
UX_EXPORT void uxraylib_set_exit_key(int key) { SetExitKey(key); }

/* ---- Mouse ---- */
UX_EXPORT int uxraylib_mouse_button_pressed(int button) { return IsMouseButtonPressed(button); }
UX_EXPORT int uxraylib_mouse_button_down(int button) { return IsMouseButtonDown(button); }
UX_EXPORT int uxraylib_mouse_button_released(int button) { return IsMouseButtonReleased(button); }
UX_EXPORT int uxraylib_mouse_button_up(int button) { return IsMouseButtonUp(button); }
UX_EXPORT int uxraylib_get_mouse_x(void) { return GetMouseX(); }
UX_EXPORT int uxraylib_get_mouse_y(void) { return GetMouseY(); }
UX_EXPORT void uxraylib_set_mouse_position(int x, int y) { SetMousePosition(x, y); }
UX_EXPORT double uxraylib_get_mouse_wheel_move(void) { return (double)GetMouseWheelMove(); }

/* ---- Basic shapes drawing (extended) ---- */
UX_EXPORT void uxraylib_draw_pixel(int x, int y, int r, int g, int b, int a)
{
    DrawPixel(x, y, (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_line(double x1, double y1, double x2, double y2,
                                  double thick, int r, int g, int b, int a)
{
    DrawLineEx((Vector2){ (float)x1, (float)y1 }, (Vector2){ (float)x2, (float)y2 },
               (float)thick, (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_circle_lines(double x, double y, double radius,
                                          int r, int g, int b, int a)
{
    DrawCircleLinesV((Vector2){ (float)x, (float)y }, (float)radius,
                     (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
static Color uxColorFromRGBA(unsigned int packed)
{
    return (Color){ (unsigned char)(packed & 255), (unsigned char)((packed >> 8) & 255),
                    (unsigned char)((packed >> 16) & 255), (unsigned char)((packed >> 24) & 255) };
}

/* Inverse of uxColorFromRGBA / uxraylib_color_rgba -- NOT the same byte order
   as raylib's own ColorToInt() (0xRRGGBBAA), so every uXBasic-facing color
   utility must round-trip through this pair, not ColorToInt/GetColor. */
static unsigned int uxColorToRGBA(Color c)
{
    return ((unsigned int)c.r) | ((unsigned int)c.g << 8) |
           ((unsigned int)c.b << 16) | ((unsigned int)c.a << 24);
}

UX_EXPORT void uxraylib_draw_circle_gradient(double x, double y, double radius,
                                             unsigned int color1, unsigned int color2)
{
    DrawCircleGradient((int)x, (int)y, (float)radius, uxColorFromRGBA(color1), uxColorFromRGBA(color2));
}
UX_EXPORT void uxraylib_draw_ellipse(double x, double y, double radiusH, double radiusV,
                                     int r, int g, int b, int a)
{
    DrawEllipse((int)x, (int)y, (float)radiusH, (float)radiusV,
               (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_ellipse_lines(double x, double y, double radiusH, double radiusV,
                                           int r, int g, int b, int a)
{
    DrawEllipseLines((int)x, (int)y, (float)radiusH, (float)radiusV,
                     (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_rectangle_lines(double x, double y, double width, double height,
                                             int r, int g, int b, int a)
{
    DrawRectangleLines((int)x, (int)y, (int)width, (int)height,
                       (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_rectangle_rounded(double x, double y, double width, double height,
                                               double roundness, int segments,
                                               int r, int g, int b, int a)
{
    DrawRectangleRounded((Rectangle){ (float)x, (float)y, (float)width, (float)height },
                         (float)roundness, segments,
                         (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_rectangle_gradient_v(double x, double y, double width, double height,
                                                  unsigned int color1, unsigned int color2)
{
    DrawRectangleGradientV((int)x, (int)y, (int)width, (int)height, uxColorFromRGBA(color1), uxColorFromRGBA(color2));
}
UX_EXPORT void uxraylib_draw_rectangle_gradient_h(double x, double y, double width, double height,
                                                  unsigned int color1, unsigned int color2)
{
    DrawRectangleGradientH((int)x, (int)y, (int)width, (int)height, uxColorFromRGBA(color1), uxColorFromRGBA(color2));
}
UX_EXPORT void uxraylib_draw_triangle(double x1, double y1, double x2, double y2, double x3, double y3,
                                      int r, int g, int b, int a)
{
    DrawTriangle((Vector2){ (float)x1, (float)y1 }, (Vector2){ (float)x2, (float)y2 }, (Vector2){ (float)x3, (float)y3 },
                (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_triangle_lines(double x1, double y1, double x2, double y2, double x3, double y3,
                                            int r, int g, int b, int a)
{
    DrawTriangleLines((Vector2){ (float)x1, (float)y1 }, (Vector2){ (float)x2, (float)y2 }, (Vector2){ (float)x3, (float)y3 },
                      (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_poly(double x, double y, int sides, double radius, double rotation,
                                  int r, int g, int b, int a)
{
    DrawPoly((Vector2){ (float)x, (float)y }, sides, (float)radius, (float)rotation,
            (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_poly_lines(double x, double y, int sides, double radius, double rotation,
                                        int r, int g, int b, int a)
{
    DrawPolyLines((Vector2){ (float)x, (float)y }, sides, (float)radius, (float)rotation,
                 (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}

/* ---- Collision (extended) ---- */
UX_EXPORT int uxraylib_collision_circle_rec(double cx, double cy, double radius,
                                            double rx, double ry, double rw, double rh)
{
    return CheckCollisionCircleRec((Vector2){ (float)cx, (float)cy }, (float)radius,
                                   (Rectangle){ (float)rx, (float)ry, (float)rw, (float)rh });
}
UX_EXPORT int uxraylib_collision_point_rec(double px, double py, double rx, double ry, double rw, double rh)
{
    return CheckCollisionPointRec((Vector2){ (float)px, (float)py }, (Rectangle){ (float)rx, (float)ry, (float)rw, (float)rh });
}
UX_EXPORT int uxraylib_collision_point_circle(double px, double py, double cx, double cy, double radius)
{
    return CheckCollisionPointCircle((Vector2){ (float)px, (float)py }, (Vector2){ (float)cx, (float)cy }, (float)radius);
}
UX_EXPORT int uxraylib_collision_point_triangle(double px, double py,
                                                double x1, double y1, double x2, double y2, double x3, double y3)
{
    return CheckCollisionPointTriangle((Vector2){ (float)px, (float)py },
                                       (Vector2){ (float)x1, (float)y1 }, (Vector2){ (float)x2, (float)y2 }, (Vector2){ (float)x3, (float)y3 });
}

/* ---- Text ---- */
UX_EXPORT int uxraylib_measure_text(const char *text, int fontSize) { return MeasureText(text, fontSize); }
UX_EXPORT void uxraylib_draw_fps(int x, int y) { DrawFPS(x, y); }

/* ---- Textures (extended) ---- */
UX_EXPORT int uxraylib_texture_valid(int handle)
{
    return (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle]) ? IsTextureValid(uxTextures[handle]) : 0;
}
UX_EXPORT void uxraylib_draw_texture(int handle, double x, double y, int r, int g, int b, int a)
{
    if (handle <= 0 || handle >= UX_MAX_TEXTURES || !uxTextureUsed[handle]) return;
    DrawTextureV(uxTextures[handle], (Vector2){ (float)x, (float)y },
                (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}
UX_EXPORT void uxraylib_draw_texture_ex(int handle, double x, double y, double rotation, double scale,
                                        int r, int g, int b, int a)
{
    if (handle <= 0 || handle >= UX_MAX_TEXTURES || !uxTextureUsed[handle]) return;
    DrawTextureEx(uxTextures[handle], (Vector2){ (float)x, (float)y }, (float)rotation, (float)scale,
                 (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}

/* ---- Audio: Sound ---- */
UX_EXPORT int uxraylib_sound_load(const char *path)
{
    Sound sound = LoadSound(path);
    if (sound.frameCount == 0 && sound.stream.buffer == NULL) return 0;
    for (int i = 1; i < UX_MAX_SOUNDS; ++i) {
        if (!uxSoundUsed[i]) {
            uxSounds[i] = sound;
            uxSoundUsed[i] = 1;
            return i;
        }
    }
    UnloadSound(sound);
    return 0;
}
UX_EXPORT void uxraylib_sound_play(int handle)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) PlaySound(uxSounds[handle]);
}
UX_EXPORT void uxraylib_sound_stop(int handle)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) StopSound(uxSounds[handle]);
}
UX_EXPORT void uxraylib_sound_pause(int handle)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) PauseSound(uxSounds[handle]);
}
UX_EXPORT void uxraylib_sound_resume(int handle)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) ResumeSound(uxSounds[handle]);
}
UX_EXPORT int uxraylib_sound_playing(int handle)
{
    return (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) ? IsSoundPlaying(uxSounds[handle]) : 0;
}
UX_EXPORT void uxraylib_sound_set_volume(int handle, double volume)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) SetSoundVolume(uxSounds[handle], (float)volume);
}
UX_EXPORT void uxraylib_sound_set_pitch(int handle, double pitch)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) SetSoundPitch(uxSounds[handle], (float)pitch);
}
UX_EXPORT void uxraylib_sound_unload(int handle)
{
    if (handle > 0 && handle < UX_MAX_SOUNDS && uxSoundUsed[handle]) {
        UnloadSound(uxSounds[handle]);
        memset(&uxSounds[handle], 0, sizeof(uxSounds[handle]));
        uxSoundUsed[handle] = 0;
    }
}

/* ---- Audio: Music stream ---- */
UX_EXPORT int uxraylib_music_load(const char *path)
{
    Music music = LoadMusicStream(path);
    if (music.frameCount == 0 && music.stream.buffer == NULL) return 0;
    for (int i = 1; i < UX_MAX_MUSIC; ++i) {
        if (!uxMusicUsed[i]) {
            uxMusic[i] = music;
            uxMusicUsed[i] = 1;
            return i;
        }
    }
    UnloadMusicStream(music);
    return 0;
}
UX_EXPORT void uxraylib_music_play(int handle)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) PlayMusicStream(uxMusic[handle]);
}
UX_EXPORT void uxraylib_music_update(int handle)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) UpdateMusicStream(uxMusic[handle]);
}
UX_EXPORT void uxraylib_music_stop(int handle)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) StopMusicStream(uxMusic[handle]);
}
UX_EXPORT void uxraylib_music_pause(int handle)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) PauseMusicStream(uxMusic[handle]);
}
UX_EXPORT void uxraylib_music_resume(int handle)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) ResumeMusicStream(uxMusic[handle]);
}
UX_EXPORT int uxraylib_music_playing(int handle)
{
    return (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) ? IsMusicStreamPlaying(uxMusic[handle]) : 0;
}
UX_EXPORT void uxraylib_music_set_volume(int handle, double volume)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) SetMusicVolume(uxMusic[handle], (float)volume);
}
UX_EXPORT double uxraylib_music_time_played(int handle)
{
    return (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) ? (double)GetMusicTimePlayed(uxMusic[handle]) : 0.0;
}
UX_EXPORT double uxraylib_music_time_length(int handle)
{
    return (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) ? (double)GetMusicTimeLength(uxMusic[handle]) : 0.0;
}
UX_EXPORT void uxraylib_music_unload(int handle)
{
    if (handle > 0 && handle < UX_MAX_MUSIC && uxMusicUsed[handle]) {
        UnloadMusicStream(uxMusic[handle]);
        memset(&uxMusic[handle], 0, sizeof(uxMusic[handle]));
        uxMusicUsed[handle] = 0;
    }
}

/* ---- RenderTexture (offscreen / render-to-texture) ---- */
UX_EXPORT int uxraylib_render_texture_load(int width, int height)
{
    RenderTexture2D target = LoadRenderTexture(width, height);
    if (target.id == 0) return 0;
    for (int i = 1; i < UX_MAX_RENDER_TEXTURES; ++i) {
        if (!uxRenderTextureUsed[i]) {
            uxRenderTextures[i] = target;
            uxRenderTextureUsed[i] = 1;
            return i;
        }
    }
    UnloadRenderTexture(target);
    return 0;
}
UX_EXPORT int uxraylib_render_texture_valid(int handle)
{
    return (handle > 0 && handle < UX_MAX_RENDER_TEXTURES && uxRenderTextureUsed[handle])
        ? IsRenderTextureValid(uxRenderTextures[handle]) : 0;
}
UX_EXPORT void uxraylib_render_texture_unload(int handle)
{
    if (handle > 0 && handle < UX_MAX_RENDER_TEXTURES && uxRenderTextureUsed[handle]) {
        UnloadRenderTexture(uxRenderTextures[handle]);
        memset(&uxRenderTextures[handle], 0, sizeof(uxRenderTextures[handle]));
        uxRenderTextureUsed[handle] = 0;
    }
}
UX_EXPORT void uxraylib_begin_texture_mode(int handle)
{
    if (handle > 0 && handle < UX_MAX_RENDER_TEXTURES && uxRenderTextureUsed[handle])
        BeginTextureMode(uxRenderTextures[handle]);
}
UX_EXPORT void uxraylib_end_texture_mode(void) { EndTextureMode(); }
UX_EXPORT void uxraylib_draw_render_texture(int handle, double x, double y, int r, int g, int b, int a)
{
    if (handle <= 0 || handle >= UX_MAX_RENDER_TEXTURES || !uxRenderTextureUsed[handle]) return;
    Texture2D tex = uxRenderTextures[handle].texture;
    /* Render textures are stored bottom-up on the GPU; flip the source rect
       vertically so the drawn result matches what was rendered on screen. */
    Rectangle source = { 0.0f, 0.0f, (float)tex.width, -(float)tex.height };
    DrawTextureRec(tex, source, (Vector2){ (float)x, (float)y },
                   (Color){ (unsigned char)r, (unsigned char)g, (unsigned char)b, (unsigned char)a });
}

/* ---- Texture configuration ---- */
UX_EXPORT void uxraylib_texture_set_filter(int handle, int filter)
{
    if (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle]) SetTextureFilter(uxTextures[handle], filter);
}
UX_EXPORT void uxraylib_texture_set_wrap(int handle, int wrap)
{
    if (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle]) SetTextureWrap(uxTextures[handle], wrap);
}
UX_EXPORT void uxraylib_texture_gen_mipmaps(int handle)
{
    if (handle > 0 && handle < UX_MAX_TEXTURES && uxTextureUsed[handle]) GenTextureMipmaps(&uxTextures[handle]);
}
UX_EXPORT void uxraylib_draw_texture_rec(int handle, double srcX, double srcY, double srcW, double srcH,
                                         double x, double y, unsigned int color)
{
    if (handle <= 0 || handle >= UX_MAX_TEXTURES || !uxTextureUsed[handle]) return;
    Rectangle source = { (float)srcX, (float)srcY, (float)srcW, (float)srcH };
    DrawTextureRec(uxTextures[handle], source, (Vector2){ (float)x, (float)y }, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_texture_pro(int handle, double srcX, double srcY, double srcW, double srcH,
                                         double dstX, double dstY, double scale,
                                         double rotation, unsigned int color)
{
    if (handle <= 0 || handle >= UX_MAX_TEXTURES || !uxTextureUsed[handle]) return;
    Rectangle source = { (float)srcX, (float)srcY, (float)srcW, (float)srcH };
    Rectangle dest = { (float)dstX, (float)dstY, (float)(srcW * scale), (float)(srcH * scale) };
    DrawTexturePro(uxTextures[handle], source, dest, (Vector2){ 0.0f, 0.0f }, (float)rotation, uxColorFromRGBA(color));
}

/* ---- Color utilities (pure math -- packed RGBA U32 in/out) ---- */
UX_EXPORT unsigned int uxraylib_color_fade(unsigned int color, double alpha)
{
    return uxColorToRGBA(Fade(uxColorFromRGBA(color), (float)alpha));
}
UX_EXPORT unsigned int uxraylib_color_alpha(unsigned int color, double alpha)
{
    return uxColorToRGBA(ColorAlpha(uxColorFromRGBA(color), (float)alpha));
}
UX_EXPORT unsigned int uxraylib_color_brightness(unsigned int color, double factor)
{
    return uxColorToRGBA(ColorBrightness(uxColorFromRGBA(color), (float)factor));
}
UX_EXPORT unsigned int uxraylib_color_contrast(unsigned int color, double contrast)
{
    return uxColorToRGBA(ColorContrast(uxColorFromRGBA(color), (float)contrast));
}
UX_EXPORT unsigned int uxraylib_color_lerp(unsigned int color1, unsigned int color2, double factor)
{
    return uxColorToRGBA(ColorLerp(uxColorFromRGBA(color1), uxColorFromRGBA(color2), (float)factor));
}
UX_EXPORT int uxraylib_color_is_equal(unsigned int color1, unsigned int color2)
{
    return ColorIsEqual(uxColorFromRGBA(color1), uxColorFromRGBA(color2)) ? 1 : 0;
}
UX_EXPORT unsigned int uxraylib_get_color(unsigned int hexValue)
{
    /* hexValue is a real 0xRRGGBBAA value (raylib's own convention, e.g. from a
       color constant or literal) -- GetColor() decodes that format directly,
       so the result must go back out through our own RGBA packing. */
    return uxColorToRGBA(GetColor(hexValue));
}

/* ---- File system utilities ---- */
UX_EXPORT int uxraylib_file_exists(const char *fileName) { return FileExists(fileName) ? 1 : 0; }
UX_EXPORT int uxraylib_directory_exists(const char *dirPath) { return DirectoryExists(dirPath) ? 1 : 0; }
UX_EXPORT const char *uxraylib_get_file_extension(const char *fileName) { return GetFileExtension(fileName); }
UX_EXPORT const char *uxraylib_get_file_name_only(const char *filePath) { return GetFileName(filePath); }
UX_EXPORT const char *uxraylib_get_working_directory(void) { return GetWorkingDirectory(); }

/* ---- Text (extended) ---- */
UX_EXPORT void uxraylib_set_text_line_spacing(int spacing) { SetTextLineSpacing(spacing); }

/* ---- Camera2D (scalar Camera2D -- offset/target/rotation/zoom) ---- */
UX_EXPORT void uxraylib_begin_mode_2d(double offsetX, double offsetY, double targetX, double targetY,
                                      double rotation, double zoom)
{
    Camera2D camera;
    camera.offset = (Vector2){ (float)offsetX, (float)offsetY };
    camera.target = (Vector2){ (float)targetX, (float)targetY };
    camera.rotation = (float)rotation;
    camera.zoom = (float)zoom;
    BeginMode2D(camera);
}
UX_EXPORT void uxraylib_end_mode_2d(void) { EndMode2D(); }

/* ---- Basic shapes drawing (more) ---- */
UX_EXPORT void uxraylib_draw_ring(double x, double y, double innerRadius, double outerRadius,
                                  double startAngle, double endAngle, int segments,
                                  unsigned int color)
{
    DrawRing((Vector2){ (float)x, (float)y }, (float)innerRadius, (float)outerRadius,
            (float)startAngle, (float)endAngle, segments, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_line_bezier(double x1, double y1, double x2, double y2, double thick,
                                         unsigned int color)
{
    DrawLineBezier((Vector2){ (float)x1, (float)y1 }, (Vector2){ (float)x2, (float)y2 },
                   (float)thick, uxColorFromRGBA(color));
}


/* ---- Image manipulation (CPU-side: needs NO window and NO GL context) ---- */
#define UX_MAX_IMAGES 256
static Image uxImages[UX_MAX_IMAGES];
static unsigned char uxImageUsed[UX_MAX_IMAGES];

static int uxImageOk(int handle)
{
    return handle > 0 && handle < UX_MAX_IMAGES && uxImageUsed[handle];
}

static int uxImageStore(Image image)
{
    if (image.data == NULL) return 0;
    for (int i = 1; i < UX_MAX_IMAGES; ++i) {
        if (!uxImageUsed[i]) {
            uxImages[i] = image;
            uxImageUsed[i] = 1;
            return i;
        }
    }
    UnloadImage(image);
    return 0;
}

UX_EXPORT int uxraylib_image_gen_color(int width, int height, unsigned int color)
{
    if (width <= 0 || height <= 0) return 0;
    return uxImageStore(GenImageColor(width, height, uxColorFromRGBA(color)));
}
UX_EXPORT int uxraylib_image_gen_checked(int width, int height, int checksX, int checksY,
                                         unsigned int color1, unsigned int color2)
{
    if (width <= 0 || height <= 0 || checksX <= 0 || checksY <= 0) return 0;
    return uxImageStore(GenImageChecked(width, height, checksX, checksY,
                                        uxColorFromRGBA(color1), uxColorFromRGBA(color2)));
}
UX_EXPORT int uxraylib_image_gen_gradient_linear(int width, int height, int direction,
                                                 unsigned int start, unsigned int end)
{
    if (width <= 0 || height <= 0) return 0;
    return uxImageStore(GenImageGradientLinear(width, height, direction,
                                               uxColorFromRGBA(start), uxColorFromRGBA(end)));
}
UX_EXPORT int uxraylib_image_load(const char *path)
{
    if (path == NULL) return 0;
    return uxImageStore(LoadImage(path));
}
UX_EXPORT int uxraylib_image_copy(int handle)
{
    if (!uxImageOk(handle)) return 0;
    return uxImageStore(ImageCopy(uxImages[handle]));
}
UX_EXPORT void uxraylib_image_unload(int handle)
{
    if (!uxImageOk(handle)) return;
    UnloadImage(uxImages[handle]);
    memset(&uxImages[handle], 0, sizeof(uxImages[handle]));
    uxImageUsed[handle] = 0;
}
UX_EXPORT int uxraylib_image_valid(int handle) { return uxImageOk(handle); }
UX_EXPORT int uxraylib_image_width(int handle) { return uxImageOk(handle) ? uxImages[handle].width : 0; }
UX_EXPORT int uxraylib_image_height(int handle) { return uxImageOk(handle) ? uxImages[handle].height : 0; }
UX_EXPORT int uxraylib_image_format_of(int handle) { return uxImageOk(handle) ? uxImages[handle].format : 0; }

UX_EXPORT unsigned int uxraylib_image_get_color(int handle, int x, int y)
{
    if (!uxImageOk(handle)) return 0;
    if (x < 0 || y < 0 || x >= uxImages[handle].width || y >= uxImages[handle].height) return 0;
    Color c = GetImageColor(uxImages[handle], x, y);
    return uxraylib_color_rgba(c.r, c.g, c.b, c.a);
}

UX_EXPORT void uxraylib_image_clear_background(int handle, unsigned int color)
{
    if (uxImageOk(handle)) ImageClearBackground(&uxImages[handle], uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_image_draw_pixel(int handle, int x, int y, unsigned int color)
{
    if (uxImageOk(handle)) ImageDrawPixel(&uxImages[handle], x, y, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_image_draw_line(int handle, int x1, int y1, int x2, int y2, unsigned int color)
{
    if (uxImageOk(handle)) ImageDrawLine(&uxImages[handle], x1, y1, x2, y2, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_image_draw_circle(int handle, int centerX, int centerY, int radius, unsigned int color)
{
    if (uxImageOk(handle) && radius > 0) ImageDrawCircle(&uxImages[handle], centerX, centerY, radius, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_image_draw_rectangle(int handle, int x, int y, int width, int height, unsigned int color)
{
    if (uxImageOk(handle) && width > 0 && height > 0) ImageDrawRectangle(&uxImages[handle], x, y, width, height, uxColorFromRGBA(color));
}

UX_EXPORT void uxraylib_image_resize(int handle, int width, int height)
{
    if (uxImageOk(handle) && width > 0 && height > 0) ImageResize(&uxImages[handle], width, height);
}
UX_EXPORT void uxraylib_image_resize_nn(int handle, int width, int height)
{
    if (uxImageOk(handle) && width > 0 && height > 0) ImageResizeNN(&uxImages[handle], width, height);
}
UX_EXPORT void uxraylib_image_crop(int handle, int x, int y, int width, int height)
{
    if (uxImageOk(handle) && width > 0 && height > 0)
        ImageCrop(&uxImages[handle], (Rectangle){ (float)x, (float)y, (float)width, (float)height });
}
UX_EXPORT void uxraylib_image_flip_vertical(int handle) { if (uxImageOk(handle)) ImageFlipVertical(&uxImages[handle]); }
UX_EXPORT void uxraylib_image_flip_horizontal(int handle) { if (uxImageOk(handle)) ImageFlipHorizontal(&uxImages[handle]); }
UX_EXPORT void uxraylib_image_rotate_cw(int handle) { if (uxImageOk(handle)) ImageRotateCW(&uxImages[handle]); }
UX_EXPORT void uxraylib_image_rotate_ccw(int handle) { if (uxImageOk(handle)) ImageRotateCCW(&uxImages[handle]); }
UX_EXPORT void uxraylib_image_color_invert(int handle) { if (uxImageOk(handle)) ImageColorInvert(&uxImages[handle]); }
UX_EXPORT void uxraylib_image_color_grayscale(int handle) { if (uxImageOk(handle)) ImageColorGrayscale(&uxImages[handle]); }
UX_EXPORT void uxraylib_image_color_contrast(int handle, double contrast)
{
    if (uxImageOk(handle)) ImageColorContrast(&uxImages[handle], (float)contrast);
}
UX_EXPORT void uxraylib_image_color_brightness(int handle, int brightness)
{
    if (uxImageOk(handle)) ImageColorBrightness(&uxImages[handle], brightness);
}
UX_EXPORT void uxraylib_image_color_tint(int handle, unsigned int color)
{
    if (uxImageOk(handle)) ImageColorTint(&uxImages[handle], uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_image_convert_format(int handle, int newFormat)
{
    if (uxImageOk(handle)) ImageFormat(&uxImages[handle], newFormat);
}
UX_EXPORT int uxraylib_image_export(int handle, const char *path)
{
    if (!uxImageOk(handle) || path == NULL) return 0;
    return ExportImage(uxImages[handle], path) ? 1 : 0;
}
/* ---- raygui (fixes a pre-existing gap: uxraygui_label had no BASIC binding) ---- */

/* raylib Models/3D dilimi 1 (S-052): raymath (CPU-only) -- see uxraylib_math_core.inc */
#include "uxraylib_math_core.inc"
#include "uxraylib_3d_cpu.inc"
