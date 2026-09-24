#include <SDL3/SDL.h>

#if defined(_WIN32)
#define UX_EXPORT __declspec(dllexport)
#else
#define UX_EXPORT
#endif

#define UX_MAX_SOUNDS 128
typedef struct {
    SDL_AudioStream *stream;
    Uint8 *audioBuf;   /* the whole sound (SDL_LoadWAV or generated tone); freed with SDL_free */
    Uint32 audioLen;
    SDL_AudioSpec spec;
    float gain;        /* this sound's own volume; the stream gain is gain * master */
    int loop;
} UxSdl3Sound;
static UxSdl3Sound uxSdl3Sounds[UX_MAX_SOUNDS];
static unsigned char uxSdl3SoundUsed[UX_MAX_SOUNDS];
static float uxSdl3MasterGain = 1.0f;

UX_EXPORT int uxsdl3_adapter_version(void) { return 100; }
UX_EXPORT int uxsdl3_runtime_version(void) { return SDL_GetVersion(); }
UX_EXPORT const char *uxsdl3_revision(void) { return SDL_GetRevision(); }
UX_EXPORT int uxsdl3_init(unsigned int flags) { return SDL_Init(flags) ? 1 : 0; }
static void uxSdl3ReleaseResources(void); /* defined at the end of the file */
/* Releases everything the adapter opened (sounds, gamepads, joysticks, cursors, cached strings) and then shuts SDL down;
   after this Init can be called again. */
UX_EXPORT void uxsdl3_quit(void)
{
    uxSdl3ReleaseResources();
    SDL_Quit();
}
UX_EXPORT const char *uxsdl3_last_error(void) { return SDL_GetError(); }

/* ---- Window ---- */
UX_EXPORT long long uxsdl3_create_window(const char *title, int w, int h, unsigned long long flags)
{
    return (long long)(intptr_t)SDL_CreateWindow(title, w, h, (SDL_WindowFlags)flags);
}
UX_EXPORT void uxsdl3_destroy_window(long long handle)
{
    if (handle != 0) SDL_DestroyWindow((SDL_Window *)(intptr_t)handle);
}
UX_EXPORT int uxsdl3_set_window_title(long long handle, const char *title)
{
    return (handle != 0) ? (SDL_SetWindowTitle((SDL_Window *)(intptr_t)handle, title) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_set_window_size(long long handle, int w, int h)
{
    return (handle != 0) ? (SDL_SetWindowSize((SDL_Window *)(intptr_t)handle, w, h) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_get_window_width(long long handle)
{
    int w = 0, h = 0;
    if (handle != 0) SDL_GetWindowSize((SDL_Window *)(intptr_t)handle, &w, &h);
    return w;
}
UX_EXPORT int uxsdl3_get_window_height(long long handle)
{
    int w = 0, h = 0;
    if (handle != 0) SDL_GetWindowSize((SDL_Window *)(intptr_t)handle, &w, &h);
    return h;
}
UX_EXPORT int uxsdl3_show_window(long long handle)
{
    return (handle != 0) ? (SDL_ShowWindow((SDL_Window *)(intptr_t)handle) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_hide_window(long long handle)
{
    return (handle != 0) ? (SDL_HideWindow((SDL_Window *)(intptr_t)handle) ? 1 : 0) : 0;
}

/* ---- Renderer ---- */
UX_EXPORT long long uxsdl3_create_renderer(long long windowHandle, const char *name)
{
    if (windowHandle == 0) return 0;
    /* an empty name means "the best available renderer" (SDL takes NULL for that) */
    return (long long)(intptr_t)SDL_CreateRenderer((SDL_Window *)(intptr_t)windowHandle, (name && name[0]) ? name : NULL);
}
UX_EXPORT void uxsdl3_destroy_renderer(long long handle)
{
    if (handle != 0) SDL_DestroyRenderer((SDL_Renderer *)(intptr_t)handle);
}
UX_EXPORT int uxsdl3_set_render_draw_color(long long handle, int r, int g, int b, int a)
{
    if (handle == 0) return 0;
    return SDL_SetRenderDrawColor((SDL_Renderer *)(intptr_t)handle,
                                  (Uint8)r, (Uint8)g, (Uint8)b, (Uint8)a) ? 1 : 0;
}
UX_EXPORT int uxsdl3_render_clear(long long handle)
{
    return (handle != 0) ? (SDL_RenderClear((SDL_Renderer *)(intptr_t)handle) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_render_present(long long handle)
{
    return (handle != 0) ? (SDL_RenderPresent((SDL_Renderer *)(intptr_t)handle) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_render_fill_rect(long long handle, double x, double y, double w, double h)
{
    if (handle == 0) return 0;
    SDL_FRect rect = { (float)x, (float)y, (float)w, (float)h };
    return SDL_RenderFillRect((SDL_Renderer *)(intptr_t)handle, &rect) ? 1 : 0;
}
UX_EXPORT int uxsdl3_render_rect(long long handle, double x, double y, double w, double h)
{
    if (handle == 0) return 0;
    SDL_FRect rect = { (float)x, (float)y, (float)w, (float)h };
    return SDL_RenderRect((SDL_Renderer *)(intptr_t)handle, &rect) ? 1 : 0;
}
UX_EXPORT int uxsdl3_render_line(long long handle, double x1, double y1, double x2, double y2)
{
    if (handle == 0) return 0;
    return SDL_RenderLine((SDL_Renderer *)(intptr_t)handle, (float)x1, (float)y1, (float)x2, (float)y2) ? 1 : 0;
}
UX_EXPORT int uxsdl3_render_point(long long handle, double x, double y)
{
    if (handle == 0) return 0;
    return SDL_RenderPoint((SDL_Renderer *)(intptr_t)handle, (float)x, (float)y) ? 1 : 0;
}

/* ---- Events / input ----
   uxsdl3_pump_events drains the SDL queue once per frame and folds it into plain state the program can poll:
   held/pressed/released keys and mouse buttons, mouse position and motion, wheel, window-event bits, typed text,
   dropped files, device hot-plug counters and the quit flag. "Pressed/released", the window-event bits and the
   relative mouse motion describe the LAST pump only (they are reset at the start of the next one).
   Every uxsdl3_push_* function injects input through the same path a real device would use. */
#define UX_MAX_KEYS 512
#define UX_MAX_MOUSE_BUTTONS 8
#define UX_TEXT_BUF 1024
#define UX_DROP_MAX 16

static int uxSdl3QuitRequested = 0;
static int uxSdl3WindowResized = 0;
static float uxSdl3WheelX = 0.0f;
static float uxSdl3WheelY = 0.0f;
static float uxSdl3MouseRelX = 0.0f;
static float uxSdl3MouseRelY = 0.0f;
static int uxSdl3MouseTracked = 0;
static float uxSdl3MouseX = 0.0f;
static float uxSdl3MouseY = 0.0f;
static unsigned char uxSdl3KeyHeld[UX_MAX_KEYS];
static unsigned char uxSdl3KeyPressed[UX_MAX_KEYS];
static unsigned char uxSdl3KeyReleased[UX_MAX_KEYS];
static unsigned char uxSdl3MouseHeld[UX_MAX_MOUSE_BUTTONS];
static unsigned char uxSdl3MousePressed[UX_MAX_MOUSE_BUTTONS];
static unsigned char uxSdl3MouseReleased[UX_MAX_MOUSE_BUTTONS];
static int uxSdl3WindowEventBits = 0;
static int uxSdl3DeviceEvents[4]; /* joystick added, joystick removed, gamepad added, gamepad removed (read-and-clear) */
static int uxSdl3LastScancode = 0;

/* Typed text (SDL_EVENT_TEXT_INPUT) collected between two uxsdl3_take_text_input() calls.
   A chunk that does not fit whole is dropped rather than cut (cutting could split a UTF-8 sequence). */
static char uxSdl3TextIn[UX_TEXT_BUF];
static char uxSdl3TextOut[UX_TEXT_BUF];
static char uxSdl3TextPending[UX_TEXT_BUF]; /* injected by uxsdl3_push_text_input, folded in by the next pump */

static char uxSdl3Drops[UX_DROP_MAX][UX_TEXT_BUF]; /* dropped file paths / dropped text, oldest first */
static int uxSdl3DropCount = 0;
static char uxSdl3DropOut[UX_TEXT_BUF];

static int uxSdl3AppendText(char *buf, const char *text)
{
    size_t have = SDL_strlen(buf);
    size_t add = SDL_strlen(text);
    if (add == 0 || have + add >= UX_TEXT_BUF) return 0;
    SDL_memcpy(buf + have, text, add + 1);
    return 1;
}
static int uxSdl3AddDrop(const char *text)
{
    size_t len;
    if (!text) return 0;
    len = SDL_strlen(text);
    if (len == 0 || len >= UX_TEXT_BUF || uxSdl3DropCount >= UX_DROP_MAX) return 0;
    SDL_memcpy(uxSdl3Drops[uxSdl3DropCount], text, len + 1);
    uxSdl3DropCount++;
    return 1;
}
static int uxSdl3WindowEventBit(Uint32 type)
{
    switch (type) {
    case SDL_EVENT_WINDOW_FOCUS_GAINED: return 1;
    case SDL_EVENT_WINDOW_FOCUS_LOST: return 2;
    case SDL_EVENT_WINDOW_MINIMIZED: return 4;
    case SDL_EVENT_WINDOW_MAXIMIZED: return 8;
    case SDL_EVENT_WINDOW_RESTORED: return 16;
    case SDL_EVENT_WINDOW_MOVED: return 32;
    case SDL_EVENT_WINDOW_CLOSE_REQUESTED: return 64;
    case SDL_EVENT_WINDOW_EXPOSED: return 128;
    case SDL_EVENT_WINDOW_MOUSE_ENTER: return 256;
    case SDL_EVENT_WINDOW_MOUSE_LEAVE: return 512;
    case SDL_EVENT_WINDOW_SHOWN: return 1024;
    case SDL_EVENT_WINDOW_HIDDEN: return 2048;
    case SDL_EVENT_WINDOW_RESIZED: return 4096;
    default: return 0;
    }
}
static void uxSdl3SoundLoopTick(void); /* defined with the audio section */

UX_EXPORT void uxsdl3_pump_events(void)
{
    SDL_Event ev;
    SDL_memset(uxSdl3KeyPressed, 0, sizeof(uxSdl3KeyPressed));
    SDL_memset(uxSdl3KeyReleased, 0, sizeof(uxSdl3KeyReleased));
    SDL_memset(uxSdl3MousePressed, 0, sizeof(uxSdl3MousePressed));
    SDL_memset(uxSdl3MouseReleased, 0, sizeof(uxSdl3MouseReleased));
    uxSdl3MouseRelX = 0.0f;
    uxSdl3MouseRelY = 0.0f;
    uxSdl3WindowEventBits = 0;
    while (SDL_PollEvent(&ev)) {
        Uint32 type = ev.type;
        if (type == SDL_EVENT_QUIT) {
            uxSdl3QuitRequested = 1;
        } else if (type == SDL_EVENT_KEY_DOWN || type == SDL_EVENT_KEY_UP) {
            int sc = (int)ev.key.scancode;
            if (sc > 0 && sc < UX_MAX_KEYS) {
                if (ev.key.down) {
                    if (!ev.key.repeat) uxSdl3KeyPressed[sc] = 1;
                    uxSdl3KeyHeld[sc] = 1;
                    uxSdl3LastScancode = sc;
                } else {
                    uxSdl3KeyReleased[sc] = 1;
                    uxSdl3KeyHeld[sc] = 0;
                }
            }
        } else if (type == SDL_EVENT_MOUSE_BUTTON_DOWN || type == SDL_EVENT_MOUSE_BUTTON_UP) {
            int button = (int)ev.button.button;
            if (button > 0 && button < UX_MAX_MOUSE_BUTTONS) {
                if (ev.button.down) {
                    uxSdl3MousePressed[button] = 1;
                    uxSdl3MouseHeld[button] = 1;
                } else {
                    uxSdl3MouseReleased[button] = 1;
                    uxSdl3MouseHeld[button] = 0;
                }
            }
            uxSdl3MouseTracked = 1;
            uxSdl3MouseX = ev.button.x;
            uxSdl3MouseY = ev.button.y;
        } else if (type == SDL_EVENT_MOUSE_MOTION) {
            uxSdl3MouseRelX += ev.motion.xrel;
            uxSdl3MouseRelY += ev.motion.yrel;
            uxSdl3MouseTracked = 1;
            uxSdl3MouseX = ev.motion.x;
            uxSdl3MouseY = ev.motion.y;
        } else if (type == SDL_EVENT_MOUSE_WHEEL) {
            uxSdl3WheelX += ev.wheel.x;
            uxSdl3WheelY += ev.wheel.y;
        } else if (type == SDL_EVENT_TEXT_INPUT) {
            if (ev.text.text) uxSdl3AppendText(uxSdl3TextIn, ev.text.text);
        } else if (type == SDL_EVENT_DROP_FILE || type == SDL_EVENT_DROP_TEXT) {
            uxSdl3AddDrop(ev.drop.data);
        } else if (type == SDL_EVENT_JOYSTICK_ADDED) {
            uxSdl3DeviceEvents[0]++;
        } else if (type == SDL_EVENT_JOYSTICK_REMOVED) {
            uxSdl3DeviceEvents[1]++;
        } else if (type == SDL_EVENT_GAMEPAD_ADDED) {
            uxSdl3DeviceEvents[2]++;
        } else if (type == SDL_EVENT_GAMEPAD_REMOVED) {
            uxSdl3DeviceEvents[3]++;
        } else {
            int bit = uxSdl3WindowEventBit(type);
            if (bit) {
                uxSdl3WindowEventBits |= bit;
                if (bit == 4096) uxSdl3WindowResized = 1;
            }
        }
    }
    if (uxSdl3TextPending[0]) {
        uxSdl3AppendText(uxSdl3TextIn, uxSdl3TextPending);
        uxSdl3TextPending[0] = '\0';
    }
    uxSdl3SoundLoopTick();
}
UX_EXPORT int uxsdl3_should_quit(void) { return uxSdl3QuitRequested; }
UX_EXPORT void uxsdl3_clear_quit(void) { uxSdl3QuitRequested = 0; }
UX_EXPORT int uxsdl3_window_resized(void)
{
    int result = uxSdl3WindowResized;
    uxSdl3WindowResized = 0;
    return result;
}
/* Bit set of window events seen by the last pump: 1 focus gained, 2 focus lost, 4 minimized, 8 maximized,
   16 restored, 32 moved, 64 close requested, 128 exposed, 256 mouse enter, 512 mouse leave, 1024 shown,
   2048 hidden, 4096 resized. */
UX_EXPORT int uxsdl3_window_events(void) { return uxSdl3WindowEventBits; }
UX_EXPORT double uxsdl3_get_mouse_wheel_x(void)
{
    float result = uxSdl3WheelX;
    uxSdl3WheelX = 0.0f;
    return (double)result;
}
UX_EXPORT double uxsdl3_get_mouse_wheel_y(void)
{
    float result = uxSdl3WheelY;
    uxSdl3WheelY = 0.0f;
    return (double)result;
}
UX_EXPORT int uxsdl3_key_down(int scancode)
{
    int numKeys = 0;
    const bool *state = SDL_GetKeyboardState(&numKeys);
    if (scancode < 0 || scancode >= UX_MAX_KEYS) return 0;
    if (uxSdl3KeyHeld[scancode]) return 1;
    if (!state || scancode >= numKeys) return 0;
    return state[scancode] ? 1 : 0;
}
UX_EXPORT int uxsdl3_key_pressed(int scancode)
{
    return (scancode > 0 && scancode < UX_MAX_KEYS && uxSdl3KeyPressed[scancode]) ? 1 : 0;
}
UX_EXPORT int uxsdl3_key_released(int scancode)
{
    return (scancode > 0 && scancode < UX_MAX_KEYS && uxSdl3KeyReleased[scancode]) ? 1 : 0;
}
UX_EXPORT int uxsdl3_last_key(void) { return uxSdl3LastScancode; }
UX_EXPORT int uxsdl3_get_mouse_x(void)
{
    float x = 0.0f, y = 0.0f;
    if (uxSdl3MouseTracked) return (int)uxSdl3MouseX;
    SDL_GetMouseState(&x, &y);
    return (int)x;
}
UX_EXPORT int uxsdl3_get_mouse_y(void)
{
    float x = 0.0f, y = 0.0f;
    if (uxSdl3MouseTracked) return (int)uxSdl3MouseY;
    SDL_GetMouseState(&x, &y);
    return (int)y;
}
UX_EXPORT int uxsdl3_mouse_button_down(int button)
{
    float x = 0.0f, y = 0.0f;
    Uint32 buttons;
    if (button > 0 && button < UX_MAX_MOUSE_BUTTONS && uxSdl3MouseHeld[button]) return 1;
    buttons = SDL_GetMouseState(&x, &y);
    return (button > 0 && button <= 32 && (buttons & SDL_BUTTON_MASK(button))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_mouse_button_pressed(int button)
{
    return (button > 0 && button < UX_MAX_MOUSE_BUTTONS && uxSdl3MousePressed[button]) ? 1 : 0;
}
UX_EXPORT int uxsdl3_mouse_button_released(int button)
{
    return (button > 0 && button < UX_MAX_MOUSE_BUTTONS && uxSdl3MouseReleased[button]) ? 1 : 0;
}
UX_EXPORT double uxsdl3_mouse_rel_x(void) { return (double)uxSdl3MouseRelX; }
UX_EXPORT double uxsdl3_mouse_rel_y(void) { return (double)uxSdl3MouseRelY; }

/* Device hot-plug: how many were added/removed since the last read (which: 0 joystick added, 1 joystick removed,
   2 gamepad added, 3 gamepad removed). Reading clears the counter. */
UX_EXPORT int uxsdl3_take_device_events(int which)
{
    int result;
    if (which < 0 || which > 3) return 0;
    result = uxSdl3DeviceEvents[which];
    uxSdl3DeviceEvents[which] = 0;
    return result;
}

/* Dropped files / text, oldest first. */
UX_EXPORT int uxsdl3_drop_count(void) { return uxSdl3DropCount; }
UX_EXPORT const char *uxsdl3_take_drop(void)
{
    int i;
    uxSdl3DropOut[0] = '\0';
    if (uxSdl3DropCount <= 0) return uxSdl3DropOut;
    SDL_memcpy(uxSdl3DropOut, uxSdl3Drops[0], sizeof(uxSdl3DropOut));
    for (i = 1; i < uxSdl3DropCount; ++i) SDL_memcpy(uxSdl3Drops[i - 1], uxSdl3Drops[i], sizeof(uxSdl3Drops[i]));
    uxSdl3DropCount--;
    uxSdl3Drops[uxSdl3DropCount][0] = '\0';
    return uxSdl3DropOut;
}
/* Injects a dropped file path (input injection / tests); it is queued directly (SDL would keep the caller's pointer). */
UX_EXPORT int uxsdl3_push_drop(const char *text) { return uxSdl3AddDrop(text); }

/* ---- Input injection: the events go through the real SDL queue and are delivered by the next pump ---- */
UX_EXPORT int uxsdl3_push_quit(void)
{
    SDL_Event ev;
    SDL_zero(ev);
    ev.type = SDL_EVENT_QUIT;
    return SDL_PushEvent(&ev) ? 1 : 0;
}
UX_EXPORT int uxsdl3_push_key(int scancode, int down)
{
    SDL_Event ev;
    if (scancode <= 0 || scancode >= UX_MAX_KEYS) return 0;
    SDL_zero(ev);
    ev.type = down ? SDL_EVENT_KEY_DOWN : SDL_EVENT_KEY_UP;
    ev.key.scancode = (SDL_Scancode)scancode;
    ev.key.key = SDL_GetKeyFromScancode((SDL_Scancode)scancode, SDL_KMOD_NONE, false);
    ev.key.down = (down != 0);
    ev.key.repeat = false;
    return SDL_PushEvent(&ev) ? 1 : 0;
}
UX_EXPORT int uxsdl3_push_mouse_button(int button, int down, double x, double y)
{
    SDL_Event ev;
    if (button <= 0 || button >= UX_MAX_MOUSE_BUTTONS) return 0;
    SDL_zero(ev);
    ev.type = down ? SDL_EVENT_MOUSE_BUTTON_DOWN : SDL_EVENT_MOUSE_BUTTON_UP;
    ev.button.button = (Uint8)button;
    ev.button.down = (down != 0);
    ev.button.clicks = 1;
    ev.button.x = (float)x;
    ev.button.y = (float)y;
    return SDL_PushEvent(&ev) ? 1 : 0;
}
UX_EXPORT int uxsdl3_push_mouse_motion(double x, double y, double xrel, double yrel)
{
    SDL_Event ev;
    SDL_zero(ev);
    ev.type = SDL_EVENT_MOUSE_MOTION;
    ev.motion.x = (float)x;
    ev.motion.y = (float)y;
    ev.motion.xrel = (float)xrel;
    ev.motion.yrel = (float)yrel;
    return SDL_PushEvent(&ev) ? 1 : 0;
}
UX_EXPORT int uxsdl3_push_mouse_wheel(double x, double y)
{
    SDL_Event ev;
    SDL_zero(ev);
    ev.type = SDL_EVENT_MOUSE_WHEEL;
    ev.wheel.x = (float)x;
    ev.wheel.y = (float)y;
    ev.wheel.direction = SDL_MOUSEWHEEL_NORMAL;
    return SDL_PushEvent(&ev) ? 1 : 0;
}
UX_EXPORT void uxsdl3_flush_events(void)
{
    SDL_FlushEvents(SDL_EVENT_FIRST, SDL_EVENT_LAST);
}
/* ---- Timing ---- */
UX_EXPORT long long uxsdl3_get_ticks(void) { return (long long)SDL_GetTicks(); }
UX_EXPORT void uxsdl3_delay(int ms) { SDL_Delay((Uint32)((ms > 0) ? ms : 0)); }

/* ---- Texture (BMP-backed; SDL3 core ships no PNG/JPEG decoder) ---- */
UX_EXPORT long long uxsdl3_load_texture(long long rendererHandle, const char *bmpPath)
{
    if (rendererHandle == 0) return 0;
    SDL_Surface *surface = SDL_LoadBMP(bmpPath);
    if (!surface) return 0;
    SDL_Texture *texture = SDL_CreateTextureFromSurface((SDL_Renderer *)(intptr_t)rendererHandle, surface);
    SDL_DestroySurface(surface);
    return (long long)(intptr_t)texture;
}
UX_EXPORT void uxsdl3_destroy_texture(long long handle)
{
    if (handle != 0) SDL_DestroyTexture((SDL_Texture *)(intptr_t)handle);
}
UX_EXPORT int uxsdl3_get_texture_width(long long handle)
{
    float w = 0.0f, h = 0.0f;
    if (handle != 0) SDL_GetTextureSize((SDL_Texture *)(intptr_t)handle, &w, &h);
    return (int)w;
}
UX_EXPORT int uxsdl3_get_texture_height(long long handle)
{
    float w = 0.0f, h = 0.0f;
    if (handle != 0) SDL_GetTextureSize((SDL_Texture *)(intptr_t)handle, &w, &h);
    return (int)h;
}
UX_EXPORT int uxsdl3_render_texture(long long rendererHandle, long long textureHandle,
                                    double x, double y, double w, double h)
{
    if (rendererHandle == 0 || textureHandle == 0) return 0;
    SDL_FRect dst = { (float)x, (float)y, (float)w, (float)h };
    return SDL_RenderTexture((SDL_Renderer *)(intptr_t)rendererHandle,
                             (SDL_Texture *)(intptr_t)textureHandle, NULL, &dst) ? 1 : 0;
}

/* ---- Audio: sounds ----
   Each sound owns its own playback stream bound to the default output device, sized to the sound's own
   format (SDL3 has no single simple "PlaySound"; SDL_OpenAudioDeviceStream + a per-sound stream is the
   documented minimal path). A sound comes from a WAV file or is generated (sine tone). Replaying clears and
   refeeds that stream. A looping sound is kept fed by uxsdl3_pump_events, so pump at least once per loop length. */
static int uxSdl3SoundValid(int handle)
{
    return handle > 0 && handle < UX_MAX_SOUNDS && uxSdl3SoundUsed[handle];
}
static void uxSdl3SoundApplyGain(int handle)
{
    SDL_SetAudioStreamGain(uxSdl3Sounds[handle].stream, uxSdl3Sounds[handle].gain * uxSdl3MasterGain);
}
static int uxSdl3SoundAdd(SDL_AudioStream *stream, Uint8 *buf, Uint32 len, const SDL_AudioSpec *spec)
{
    for (int i = 1; i < UX_MAX_SOUNDS; ++i) {
        if (!uxSdl3SoundUsed[i]) {
            uxSdl3Sounds[i].stream = stream;
            uxSdl3Sounds[i].audioBuf = buf;
            uxSdl3Sounds[i].audioLen = len;
            uxSdl3Sounds[i].spec = *spec;
            uxSdl3Sounds[i].gain = 1.0f;
            uxSdl3Sounds[i].loop = 0;
            uxSdl3SoundUsed[i] = 1;
            uxSdl3SoundApplyGain(i);
            return i;
        }
    }
    return 0;
}
static int uxSdl3SoundFrameSize(int handle)
{
    int size = SDL_AUDIO_FRAMESIZE(uxSdl3Sounds[handle].spec);
    return size > 0 ? size : 1;
}
static void uxSdl3SoundLoopTick(void)
{
    for (int i = 1; i < UX_MAX_SOUNDS; ++i) {
        if (uxSdl3SoundUsed[i] && uxSdl3Sounds[i].loop && !SDL_AudioStreamDevicePaused(uxSdl3Sounds[i].stream)) {
            if (SDL_GetAudioStreamQueued(uxSdl3Sounds[i].stream) < (int)uxSdl3Sounds[i].audioLen)
                SDL_PutAudioStreamData(uxSdl3Sounds[i].stream, uxSdl3Sounds[i].audioBuf, (int)uxSdl3Sounds[i].audioLen);
        }
    }
}
UX_EXPORT int uxsdl3_sound_load(const char *wavPath)
{
    SDL_AudioSpec spec;
    Uint8 *buf = NULL;
    Uint32 len = 0;
    SDL_AudioStream *stream;
    int handle;
    if (!wavPath || !SDL_LoadWAV(wavPath, &spec, &buf, &len)) return 0;

    stream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec, NULL, NULL);
    if (!stream) {
        SDL_free(buf);
        return 0;
    }
    handle = uxSdl3SoundAdd(stream, buf, len, &spec);
    if (!handle) {
        SDL_DestroyAudioStream(stream);
        SDL_free(buf);
    }
    return handle;
}
/* A generated sine tone (16-bit mono, 44.1 kHz) with a 5 ms fade in/out so it does not click.
   freqHz 20..20000, ms 1..60000, volume 0.0..1.0 (baked into the samples). */
UX_EXPORT int uxsdl3_sound_create_tone(int freqHz, int ms, double volume)
{
    SDL_AudioSpec spec;
    SDL_AudioStream *stream;
    Sint16 *samples;
    int frames, fade, handle;
    if (freqHz < 20 || freqHz > 20000 || ms < 1 || ms > 60000) return 0;
    if (volume < 0.0) volume = 0.0;
    if (volume > 1.0) volume = 1.0;
    SDL_zero(spec);
    spec.format = SDL_AUDIO_S16;
    spec.channels = 1;
    spec.freq = 44100;
    frames = (int)((long long)spec.freq * ms / 1000);
    if (frames < 1) frames = 1;
    fade = spec.freq / 200; /* 5 ms */
    if (fade * 2 > frames) fade = frames / 2;
    samples = (Sint16 *)SDL_malloc((size_t)frames * sizeof(Sint16));
    if (!samples) return 0;
    for (int i = 0; i < frames; ++i) {
        double env = 1.0;
        double phase = 2.0 * 3.14159265358979323846 * (double)freqHz * (double)i / (double)spec.freq;
        if (fade > 0 && i < fade) env = (double)i / (double)fade;
        else if (fade > 0 && i >= frames - fade) env = (double)(frames - 1 - i) / (double)fade;
        samples[i] = (Sint16)(32767.0 * volume * env * SDL_sin(phase));
    }
    stream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec, NULL, NULL);
    if (!stream) {
        SDL_free(samples);
        return 0;
    }
    handle = uxSdl3SoundAdd(stream, (Uint8 *)samples, (Uint32)((size_t)frames * sizeof(Sint16)), &spec);
    if (!handle) {
        SDL_DestroyAudioStream(stream);
        SDL_free(samples);
    }
    return handle;
}
UX_EXPORT void uxsdl3_sound_play(int handle)
{
    if (!uxSdl3SoundValid(handle)) return;
    SDL_ClearAudioStream(uxSdl3Sounds[handle].stream);
    SDL_PutAudioStreamData(uxSdl3Sounds[handle].stream, uxSdl3Sounds[handle].audioBuf, (int)uxSdl3Sounds[handle].audioLen);
    SDL_ResumeAudioStreamDevice(uxSdl3Sounds[handle].stream);
}
UX_EXPORT void uxsdl3_sound_stop(int handle)
{
    if (!uxSdl3SoundValid(handle)) return;
    uxSdl3Sounds[handle].loop = 0;
    SDL_PauseAudioStreamDevice(uxSdl3Sounds[handle].stream);
    SDL_ClearAudioStream(uxSdl3Sounds[handle].stream);
}
UX_EXPORT void uxsdl3_sound_pause(int handle)
{
    if (uxSdl3SoundValid(handle)) SDL_PauseAudioStreamDevice(uxSdl3Sounds[handle].stream);
}
UX_EXPORT void uxsdl3_sound_resume(int handle)
{
    if (uxSdl3SoundValid(handle)) SDL_ResumeAudioStreamDevice(uxSdl3Sounds[handle].stream);
}
UX_EXPORT int uxsdl3_sound_is_playing(int handle)
{
    if (!uxSdl3SoundValid(handle)) return 0;
    if (SDL_AudioStreamDevicePaused(uxSdl3Sounds[handle].stream)) return 0;
    return SDL_GetAudioStreamQueued(uxSdl3Sounds[handle].stream) > 0 ? 1 : 0;
}
UX_EXPORT int uxsdl3_sound_is_paused(int handle)
{
    return (uxSdl3SoundValid(handle) && SDL_AudioStreamDevicePaused(uxSdl3Sounds[handle].stream)) ? 1 : 0;
}
UX_EXPORT void uxsdl3_sound_set_loop(int handle, int loop)
{
    if (uxSdl3SoundValid(handle)) uxSdl3Sounds[handle].loop = (loop != 0);
}
UX_EXPORT int uxsdl3_sound_get_loop(int handle)
{
    return uxSdl3SoundValid(handle) ? uxSdl3Sounds[handle].loop : 0;
}
/* Volume 0.0 .. 4.0 (1.0 = as recorded), multiplied by the master volume. */
UX_EXPORT void uxsdl3_sound_set_volume(int handle, double volume)
{
    if (!uxSdl3SoundValid(handle)) return;
    if (volume < 0.0) volume = 0.0;
    if (volume > 4.0) volume = 4.0;
    uxSdl3Sounds[handle].gain = (float)volume;
    uxSdl3SoundApplyGain(handle);
}
UX_EXPORT double uxsdl3_sound_get_volume(int handle)
{
    return uxSdl3SoundValid(handle) ? (double)uxSdl3Sounds[handle].gain : 0.0;
}
UX_EXPORT void uxsdl3_set_master_volume(double volume)
{
    if (volume < 0.0) volume = 0.0;
    if (volume > 4.0) volume = 4.0;
    uxSdl3MasterGain = (float)volume;
    for (int i = 1; i < UX_MAX_SOUNDS; ++i) {
        if (uxSdl3SoundUsed[i]) uxSdl3SoundApplyGain(i);
    }
}
UX_EXPORT double uxsdl3_get_master_volume(void) { return (double)uxSdl3MasterGain; }
UX_EXPORT int uxsdl3_sound_length_ms(int handle)
{
    if (!uxSdl3SoundValid(handle) || uxSdl3Sounds[handle].spec.freq <= 0) return 0;
    return (int)((long long)(uxSdl3Sounds[handle].audioLen / (Uint32)uxSdl3SoundFrameSize(handle)) * 1000 / uxSdl3Sounds[handle].spec.freq);
}
UX_EXPORT int uxsdl3_sound_remaining_ms(int handle)
{
    int queued;
    if (!uxSdl3SoundValid(handle) || uxSdl3Sounds[handle].spec.freq <= 0) return 0;
    queued = SDL_GetAudioStreamQueued(uxSdl3Sounds[handle].stream);
    if (queued < 0) queued = 0;
    return (int)((long long)(queued / uxSdl3SoundFrameSize(handle)) * 1000 / uxSdl3Sounds[handle].spec.freq);
}
UX_EXPORT int uxsdl3_sound_frequency(int handle)
{
    return uxSdl3SoundValid(handle) ? uxSdl3Sounds[handle].spec.freq : 0;
}
UX_EXPORT int uxsdl3_sound_channels(int handle)
{
    return uxSdl3SoundValid(handle) ? uxSdl3Sounds[handle].spec.channels : 0;
}
UX_EXPORT void uxsdl3_sound_unload(int handle)
{
    if (!uxSdl3SoundValid(handle)) return;
    SDL_DestroyAudioStream(uxSdl3Sounds[handle].stream);
    SDL_free(uxSdl3Sounds[handle].audioBuf);
    uxSdl3Sounds[handle].stream = NULL;
    uxSdl3Sounds[handle].audioBuf = NULL;
    uxSdl3Sounds[handle].audioLen = 0;
    uxSdl3Sounds[handle].loop = 0;
    uxSdl3SoundUsed[handle] = 0;
}

/* Writes a sound (a loaded WAV or a generated tone) as a PCM/float WAV file; returns 1 on success.
   Only little-endian sample formats are written (everything SDL_LoadWAV returns on this platform). */
UX_EXPORT int uxsdl3_sound_save_wav(int handle, const char *path)
{
    SDL_IOStream *io;
    Uint32 dataLen;
    Uint16 bits, channels, blockAlign, formatTag;
    Uint32 byteRate;
    int ok = 1;
    if (!uxSdl3SoundValid(handle) || !path) return 0;
    if (SDL_AUDIO_ISBIGENDIAN(uxSdl3Sounds[handle].spec.format)) return 0;
    bits = (Uint16)SDL_AUDIO_BITSIZE(uxSdl3Sounds[handle].spec.format);
    channels = (Uint16)uxSdl3Sounds[handle].spec.channels;
    blockAlign = (Uint16)(channels * (bits / 8));
    byteRate = (Uint32)uxSdl3Sounds[handle].spec.freq * blockAlign;
    formatTag = SDL_AUDIO_ISFLOAT(uxSdl3Sounds[handle].spec.format) ? 3 : 1;
    dataLen = uxSdl3Sounds[handle].audioLen;
    io = SDL_IOFromFile(path, "wb");
    if (!io) return 0;
    ok &= SDL_WriteIO(io, "RIFF", 4) == 4;
    ok &= SDL_WriteU32LE(io, 36u + dataLen);
    ok &= SDL_WriteIO(io, "WAVEfmt ", 8) == 8;
    ok &= SDL_WriteU32LE(io, 16u);
    ok &= SDL_WriteU16LE(io, formatTag);
    ok &= SDL_WriteU16LE(io, channels);
    ok &= SDL_WriteU32LE(io, (Uint32)uxSdl3Sounds[handle].spec.freq);
    ok &= SDL_WriteU32LE(io, byteRate);
    ok &= SDL_WriteU16LE(io, blockAlign);
    ok &= SDL_WriteU16LE(io, bits);
    ok &= SDL_WriteIO(io, "data", 4) == 4;
    ok &= SDL_WriteU32LE(io, dataLen);
    ok &= SDL_WriteIO(io, uxSdl3Sounds[handle].audioBuf, dataLen) == dataLen;
    if (!SDL_CloseIO(io)) ok = 0;
    return ok ? 1 : 0;
}
/* Audio devices and drivers (names are owned by SDL / cached here). */
static char uxSdl3AudioNameOut[256];
static SDL_AudioDeviceID uxSdl3AudioDeviceAt(int recording, int index)
{
    int count = 0;
    SDL_AudioDeviceID id = 0;
    SDL_AudioDeviceID *ids = recording ? SDL_GetAudioRecordingDevices(&count) : SDL_GetAudioPlaybackDevices(&count);
    if (ids) {
        if (index >= 0 && index < count) id = ids[index];
        SDL_free(ids);
    }
    return id;
}
UX_EXPORT int uxsdl3_audio_device_count(int recording)
{
    int count = 0;
    SDL_AudioDeviceID *ids = recording ? SDL_GetAudioRecordingDevices(&count) : SDL_GetAudioPlaybackDevices(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}
UX_EXPORT const char *uxsdl3_audio_device_name(int recording, int index)
{
    SDL_AudioDeviceID id = uxSdl3AudioDeviceAt(recording, index);
    const char *name = id ? SDL_GetAudioDeviceName(id) : NULL;
    if (!name) name = "";
    SDL_strlcpy(uxSdl3AudioNameOut, name, sizeof(uxSdl3AudioNameOut));
    return uxSdl3AudioNameOut;
}
UX_EXPORT int uxsdl3_audio_driver_count(void) { return SDL_GetNumAudioDrivers(); }
UX_EXPORT const char *uxsdl3_audio_driver_name(int index)
{
    const char *name = SDL_GetAudioDriver(index);
    return name ? name : "";
}
UX_EXPORT const char *uxsdl3_current_audio_driver(void)
{
    const char *name = SDL_GetCurrentAudioDriver();
    return name ? name : "";
}
/* ---- Clipboard (needs SDL_INIT_VIDEO) ---- */
static char *uxSdl3ClipboardCache = NULL;
UX_EXPORT int uxsdl3_set_clipboard_text(const char *text)
{
    return SDL_SetClipboardText(text ? text : "") ? 1 : 0;
}
UX_EXPORT const char *uxsdl3_get_clipboard_text(void)
{
    if (uxSdl3ClipboardCache) {
        SDL_free(uxSdl3ClipboardCache);
        uxSdl3ClipboardCache = NULL;
    }
    uxSdl3ClipboardCache = SDL_GetClipboardText();
    return uxSdl3ClipboardCache ? uxSdl3ClipboardCache : "";
}
UX_EXPORT int uxsdl3_has_clipboard_text(void) { return SDL_HasClipboardText() ? 1 : 0; }

/* ---- Text input (needs a window; typed text arrives through uxsdl3_pump_events) ---- */
UX_EXPORT int uxsdl3_start_text_input(long long window)
{
    return (window != 0) ? (SDL_StartTextInput((SDL_Window *)(intptr_t)window) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_stop_text_input(long long window)
{
    return (window != 0) ? (SDL_StopTextInput((SDL_Window *)(intptr_t)window) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_text_input_active(long long window)
{
    return (window != 0) ? (SDL_TextInputActive((SDL_Window *)(intptr_t)window) ? 1 : 0) : 0;
}
UX_EXPORT int uxsdl3_set_text_input_area(long long window, int x, int y, int w, int h, int cursor)
{
    SDL_Rect rect = { x, y, w, h };
    return (window != 0) ? (SDL_SetTextInputArea((SDL_Window *)(intptr_t)window, &rect, cursor) ? 1 : 0) : 0;
}
/* Text typed since the previous call (UTF-8); the internal buffer is emptied. */
UX_EXPORT const char *uxsdl3_take_text_input(void)
{
    SDL_memcpy(uxSdl3TextOut, uxSdl3TextIn, sizeof(uxSdl3TextOut));
    uxSdl3TextIn[0] = '\0';
    return uxSdl3TextOut;
}
/* Injects typed text (input injection / tests): the text is COPIED here and joins the typed-text buffer at the
   next uxsdl3_pump_events, exactly where real SDL_EVENT_TEXT_INPUT text lands. (SDL_PushEvent would keep the
   caller's pointer, which dies when the FFI call returns.) Returns 0 for empty text or a full buffer. */
UX_EXPORT int uxsdl3_push_text_input(const char *text)
{
    return text ? uxSdl3AppendText(uxSdl3TextPending, text) : 0;
}
UX_EXPORT const char *uxsdl3_get_scancode_name(int scancode)
{
    const char *name = SDL_GetScancodeName((SDL_Scancode)scancode);
    return name ? name : "";
}
UX_EXPORT int uxsdl3_get_mod_state(void) { return (int)SDL_GetModState(); }

/* ---- Joystick / gamepad ----
   Handles are small table indexes (1..UX_MAX_PADS-1, 0 = failure). Enumeration returns SDL instance IDs
   (never 0); an instance ID is what the open functions take. Device state is refreshed by
   uxsdl3_pump_events. Needs SDL_INIT_JOYSTICK (raw joysticks) or SDL_INIT_GAMEPAD (gamepads, includes joysticks). */
#define UX_MAX_PADS 16
static SDL_Joystick *uxSdl3Joysticks[UX_MAX_PADS];
static SDL_Gamepad *uxSdl3Gamepads[UX_MAX_PADS];

_Static_assert(SDL_GAMEPAD_BUTTON_SOUTH == 0 && SDL_GAMEPAD_BUTTON_EAST == 1 && SDL_GAMEPAD_BUTTON_WEST == 2 &&
               SDL_GAMEPAD_BUTTON_NORTH == 3 && SDL_GAMEPAD_BUTTON_BACK == 4 && SDL_GAMEPAD_BUTTON_GUIDE == 5 &&
               SDL_GAMEPAD_BUTTON_START == 6 && SDL_GAMEPAD_BUTTON_LEFT_STICK == 7 && SDL_GAMEPAD_BUTTON_RIGHT_STICK == 8 &&
               SDL_GAMEPAD_BUTTON_LEFT_SHOULDER == 9 && SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER == 10 &&
               SDL_GAMEPAD_BUTTON_DPAD_UP == 11 && SDL_GAMEPAD_BUTTON_DPAD_DOWN == 12 &&
               SDL_GAMEPAD_BUTTON_DPAD_LEFT == 13 && SDL_GAMEPAD_BUTTON_DPAD_RIGHT == 14,
               "uxsdl3.bas GAMEPAD_BUTTON_* constants must match SDL_GamepadButton");
_Static_assert(SDL_GAMEPAD_AXIS_LEFTX == 0 && SDL_GAMEPAD_AXIS_LEFTY == 1 && SDL_GAMEPAD_AXIS_RIGHTX == 2 &&
               SDL_GAMEPAD_AXIS_RIGHTY == 3 && SDL_GAMEPAD_AXIS_LEFT_TRIGGER == 4 && SDL_GAMEPAD_AXIS_RIGHT_TRIGGER == 5,
               "uxsdl3.bas GAMEPAD_AXIS_* constants must match SDL_GamepadAxis");

static SDL_Joystick *uxSdl3JoystickOf(int handle)
{
    return (handle > 0 && handle < UX_MAX_PADS) ? uxSdl3Joysticks[handle] : NULL;
}
static SDL_Gamepad *uxSdl3GamepadOf(int handle)
{
    return (handle > 0 && handle < UX_MAX_PADS) ? uxSdl3Gamepads[handle] : NULL;
}
static int uxSdl3IdAt(SDL_JoystickID *ids, int count, int index)
{
    int result = 0;
    if (ids) {
        if (index >= 0 && index < count) result = (int)ids[index];
        SDL_free(ids);
    }
    return result;
}

UX_EXPORT int uxsdl3_joystick_count(void)
{
    int count = 0;
    SDL_JoystickID *ids = SDL_GetJoysticks(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}
UX_EXPORT int uxsdl3_joystick_id_at(int index)
{
    int count = 0;
    SDL_JoystickID *ids = SDL_GetJoysticks(&count);
    return uxSdl3IdAt(ids, count, index);
}
UX_EXPORT int uxsdl3_joystick_open(int instanceId)
{
    if (instanceId <= 0) return 0;
    for (int i = 1; i < UX_MAX_PADS; ++i) {
        if (!uxSdl3Joysticks[i]) {
            uxSdl3Joysticks[i] = SDL_OpenJoystick((SDL_JoystickID)instanceId);
            return uxSdl3Joysticks[i] ? i : 0;
        }
    }
    return 0;
}
UX_EXPORT void uxsdl3_joystick_close(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    if (!joystick) return;
    SDL_CloseJoystick(joystick);
    uxSdl3Joysticks[handle] = NULL;
}
UX_EXPORT int uxsdl3_joystick_connected(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return (joystick && SDL_JoystickConnected(joystick)) ? 1 : 0;
}
UX_EXPORT const char *uxsdl3_joystick_name(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    const char *name = joystick ? SDL_GetJoystickName(joystick) : NULL;
    return name ? name : "";
}
UX_EXPORT int uxsdl3_joystick_num_axes(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? SDL_GetNumJoystickAxes(joystick) : 0;
}
UX_EXPORT int uxsdl3_joystick_num_buttons(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? SDL_GetNumJoystickButtons(joystick) : 0;
}
UX_EXPORT int uxsdl3_joystick_num_hats(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? SDL_GetNumJoystickHats(joystick) : 0;
}
UX_EXPORT int uxsdl3_joystick_axis(int handle, int axis)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? (int)SDL_GetJoystickAxis(joystick, axis) : 0;
}
UX_EXPORT int uxsdl3_joystick_button(int handle, int button)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return (joystick && SDL_GetJoystickButton(joystick, button)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_joystick_hat(int handle, int hat)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? (int)SDL_GetJoystickHat(joystick, hat) : 0;
}

UX_EXPORT int uxsdl3_gamepad_count(void)
{
    int count = 0;
    SDL_JoystickID *ids = SDL_GetGamepads(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}
UX_EXPORT int uxsdl3_gamepad_id_at(int index)
{
    int count = 0;
    SDL_JoystickID *ids = SDL_GetGamepads(&count);
    return uxSdl3IdAt(ids, count, index);
}
UX_EXPORT int uxsdl3_is_gamepad(int instanceId)
{
    return (instanceId > 0 && SDL_IsGamepad((SDL_JoystickID)instanceId)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_open(int instanceId)
{
    if (instanceId <= 0) return 0;
    for (int i = 1; i < UX_MAX_PADS; ++i) {
        if (!uxSdl3Gamepads[i]) {
            uxSdl3Gamepads[i] = SDL_OpenGamepad((SDL_JoystickID)instanceId);
            return uxSdl3Gamepads[i] ? i : 0;
        }
    }
    return 0;
}
UX_EXPORT void uxsdl3_gamepad_close(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    if (!gamepad) return;
    SDL_CloseGamepad(gamepad);
    uxSdl3Gamepads[handle] = NULL;
}
UX_EXPORT int uxsdl3_gamepad_connected(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_GamepadConnected(gamepad)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_instance_id(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? (int)SDL_GetGamepadID(gamepad) : 0;
}
UX_EXPORT const char *uxsdl3_gamepad_name(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    const char *name = gamepad ? SDL_GetGamepadName(gamepad) : NULL;
    return name ? name : "";
}
UX_EXPORT int uxsdl3_gamepad_vendor(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? (int)SDL_GetGamepadVendor(gamepad) : 0;
}
UX_EXPORT int uxsdl3_gamepad_product(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? (int)SDL_GetGamepadProduct(gamepad) : 0;
}
UX_EXPORT int uxsdl3_gamepad_button(int handle, int button)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_GetGamepadButton(gamepad, (SDL_GamepadButton)button)) ? 1 : 0;
}
/* Raw axis value, -32768..32767 (triggers 0..32767). */
UX_EXPORT int uxsdl3_gamepad_axis(int handle, int axis)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? (int)SDL_GetGamepadAxis(gamepad, (SDL_GamepadAxis)axis) : 0;
}
/* Axis normalized to -1.0 .. 1.0 (triggers 0.0 .. 1.0). */
UX_EXPORT double uxsdl3_gamepad_axis_norm(int handle, int axis)
{
    double v = (double)uxsdl3_gamepad_axis(handle, axis) / 32767.0;
    return (v < -1.0) ? -1.0 : v;
}
UX_EXPORT int uxsdl3_gamepad_rumble(int handle, int low, int high, int ms)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    if (!gamepad) return 0;
    if (low < 0) low = 0;
    if (low > 65535) low = 65535;
    if (high < 0) high = 0;
    if (high > 65535) high = 65535;
    return SDL_RumbleGamepad(gamepad, (Uint16)low, (Uint16)high, (Uint32)((ms > 0) ? ms : 0)) ? 1 : 0;
}

/* ---- Virtual joystick / gamepad: devices with program-supplied inputs (input injection, replay, tests) ---- */
UX_EXPORT int uxsdl3_virtual_joystick_attach(int axes, int buttons, int hats)
{
    SDL_VirtualJoystickDesc desc;
    if (axes < 0 || buttons < 0 || hats < 0 || axes > 65535 || buttons > 65535 || hats > 65535) return 0;
    SDL_INIT_INTERFACE(&desc);
    desc.type = SDL_JOYSTICK_TYPE_UNKNOWN;
    desc.naxes = (Uint16)axes;
    desc.nbuttons = (Uint16)buttons;
    desc.nhats = (Uint16)hats;
    desc.name = "uxsdl3 virtual joystick";
    return (int)SDL_AttachVirtualJoystick(&desc);
}
UX_EXPORT int uxsdl3_virtual_gamepad_attach(void)
{
    SDL_VirtualJoystickDesc desc;
    SDL_INIT_INTERFACE(&desc);
    desc.type = SDL_JOYSTICK_TYPE_GAMEPAD;
    desc.naxes = SDL_GAMEPAD_AXIS_COUNT;
    desc.nbuttons = SDL_GAMEPAD_BUTTON_COUNT;
    desc.name = "uxsdl3 virtual gamepad";
    return (int)SDL_AttachVirtualJoystick(&desc);
}
UX_EXPORT int uxsdl3_virtual_detach(int instanceId)
{
    return (instanceId > 0 && SDL_DetachVirtualJoystick((SDL_JoystickID)instanceId)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_joystick_set_virtual_axis(int handle, int axis, int value)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    if (!joystick) return 0;
    if (value < -32768) value = -32768;
    if (value > 32767) value = 32767;
    return SDL_SetJoystickVirtualAxis(joystick, axis, (Sint16)value) ? 1 : 0;
}
UX_EXPORT int uxsdl3_joystick_set_virtual_button(int handle, int button, int down)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return (joystick && SDL_SetJoystickVirtualButton(joystick, button, down != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_joystick_set_virtual_hat(int handle, int hat, int value)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return (joystick && SDL_SetJoystickVirtualHat(joystick, hat, (Uint8)value)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_set_virtual_axis(int handle, int axis, int value)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    if (!gamepad) return 0;
    if (value < -32768) value = -32768;
    if (value > 32767) value = 32767;
    return SDL_SetJoystickVirtualAxis(SDL_GetGamepadJoystick(gamepad), axis, (Sint16)value) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_set_virtual_button(int handle, int button, int down)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_SetJoystickVirtualButton(SDL_GetGamepadJoystick(gamepad), button, down != 0)) ? 1 : 0;
}

/* ================================================================================================
   Core, video (displays), window, mouse/cursor and keyboard details
   Handles are raw SDL pointers carried as long long (0 = none); "which" selectors return one component
   of a small group (documented on each function) so the wrapper can expose plain scalar getters.
   ================================================================================================ */
#define UX_WIN(h) ((SDL_Window *)(intptr_t)(h))
#define UX_REN(h) ((SDL_Renderer *)(intptr_t)(h))
#define UX_TEX(h) ((SDL_Texture *)(intptr_t)(h))

_Static_assert(SDL_INIT_AUDIO == 0x10u && SDL_INIT_VIDEO == 0x20u && SDL_INIT_JOYSTICK == 0x200u &&
               SDL_INIT_HAPTIC == 0x1000u && SDL_INIT_GAMEPAD == 0x2000u && SDL_INIT_EVENTS == 0x4000u &&
               SDL_INIT_SENSOR == 0x8000u && SDL_INIT_CAMERA == 0x10000u,
               "uxsdl3.bas INIT_* constants must match SDL_INIT_*");
_Static_assert(SDL_WINDOW_FULLSCREEN == 0x1u && SDL_WINDOW_HIDDEN == 0x8u && SDL_WINDOW_BORDERLESS == 0x10u &&
               SDL_WINDOW_RESIZABLE == 0x20u && SDL_WINDOW_MINIMIZED == 0x40u && SDL_WINDOW_MAXIMIZED == 0x80u &&
               SDL_WINDOW_MOUSE_GRABBED == 0x100u && SDL_WINDOW_INPUT_FOCUS == 0x200u && SDL_WINDOW_MOUSE_FOCUS == 0x400u &&
               SDL_WINDOW_HIGH_PIXEL_DENSITY == 0x2000u && SDL_WINDOW_MOUSE_CAPTURE == 0x4000u &&
               SDL_WINDOW_MOUSE_RELATIVE_MODE == 0x8000u && SDL_WINDOW_ALWAYS_ON_TOP == 0x10000u &&
               SDL_WINDOW_UTILITY == 0x20000u && SDL_WINDOW_KEYBOARD_GRABBED == 0x100000u &&
               SDL_WINDOW_TRANSPARENT == 0x40000000u && SDL_WINDOW_NOT_FOCUSABLE == 0x80000000u,
               "uxsdl3.bas WINDOW_* constants must match SDL_WINDOW_*");

/* ---- Core ---- */
UX_EXPORT int uxsdl3_init_subsystem(unsigned int flags) { return SDL_InitSubSystem(flags) ? 1 : 0; }
UX_EXPORT void uxsdl3_quit_subsystem(unsigned int flags) { SDL_QuitSubSystem(flags); }
UX_EXPORT int uxsdl3_was_init(unsigned int flags) { return (int)SDL_WasInit(flags); }
UX_EXPORT void uxsdl3_clear_error(void) { SDL_ClearError(); }
UX_EXPORT const char *uxsdl3_get_platform(void)
{
    const char *name = SDL_GetPlatform();
    return name ? name : "";
}
UX_EXPORT int uxsdl3_set_app_metadata(const char *name, const char *version, const char *identifier)
{
    return SDL_SetAppMetadata(name, version, identifier) ? 1 : 0;
}
/* which: 0 name, 1 version, 2 identifier */
UX_EXPORT const char *uxsdl3_get_app_metadata(int which)
{
    const char *key = (which == 0) ? SDL_PROP_APP_METADATA_NAME_STRING
                    : (which == 1) ? SDL_PROP_APP_METADATA_VERSION_STRING
                    : SDL_PROP_APP_METADATA_IDENTIFIER_STRING;
    const char *value = SDL_GetAppMetadataProperty(key);
    return value ? value : "";
}
UX_EXPORT int uxsdl3_set_hint(const char *name, const char *value)
{
    return (name && SDL_SetHint(name, value)) ? 1 : 0;
}
UX_EXPORT const char *uxsdl3_get_hint(const char *name)
{
    const char *value = name ? SDL_GetHint(name) : NULL;
    return value ? value : "";
}

/* ---- Video: displays ---- */
static SDL_DisplayID uxSdl3DisplayAt(int index)
{
    int count = 0;
    SDL_DisplayID id = 0;
    SDL_DisplayID *ids = SDL_GetDisplays(&count);
    if (ids) {
        if (index >= 0 && index < count) id = ids[index];
        SDL_free(ids);
    }
    return id;
}
static int uxSdl3RectPart(const SDL_Rect *rect, int which)
{
    switch (which) {
    case 0: return rect->x;
    case 1: return rect->y;
    case 2: return rect->w;
    default: return rect->h;
    }
}
UX_EXPORT int uxsdl3_display_count(void)
{
    int count = 0;
    SDL_DisplayID *ids = SDL_GetDisplays(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}
UX_EXPORT int uxsdl3_display_id_at(int index) { return (int)uxSdl3DisplayAt(index); }
UX_EXPORT int uxsdl3_primary_display(void) { return (int)SDL_GetPrimaryDisplay(); }
UX_EXPORT const char *uxsdl3_display_name(int displayId)
{
    const char *name = (displayId > 0) ? SDL_GetDisplayName((SDL_DisplayID)displayId) : NULL;
    return name ? name : "";
}
/* which: 0 x, 1 y, 2 width, 3 height (0 when the display is unknown) */
UX_EXPORT int uxsdl3_display_bounds(int displayId, int which)
{
    SDL_Rect rect = { 0, 0, 0, 0 };
    if (displayId <= 0 || !SDL_GetDisplayBounds((SDL_DisplayID)displayId, &rect)) return 0;
    return uxSdl3RectPart(&rect, which);
}
UX_EXPORT int uxsdl3_display_usable_bounds(int displayId, int which)
{
    SDL_Rect rect = { 0, 0, 0, 0 };
    if (displayId <= 0 || !SDL_GetDisplayUsableBounds((SDL_DisplayID)displayId, &rect)) return 0;
    return uxSdl3RectPart(&rect, which);
}
/* Desktop display mode. which: 0 width, 1 height, 2 refresh rate x100 (Hz), 3 pixel density x100 */
UX_EXPORT int uxsdl3_display_mode(int displayId, int which)
{
    const SDL_DisplayMode *mode = (displayId > 0) ? SDL_GetDesktopDisplayMode((SDL_DisplayID)displayId) : NULL;
    if (!mode) return 0;
    switch (which) {
    case 0: return mode->w;
    case 1: return mode->h;
    case 2: return (int)(mode->refresh_rate * 100.0f + 0.5f);
    default: return (int)(mode->pixel_density * 100.0f + 0.5f);
    }
}
UX_EXPORT double uxsdl3_display_content_scale(int displayId)
{
    return (displayId > 0) ? (double)SDL_GetDisplayContentScale((SDL_DisplayID)displayId) : 0.0;
}
UX_EXPORT int uxsdl3_display_orientation(int displayId)
{
    return (displayId > 0) ? (int)SDL_GetCurrentDisplayOrientation((SDL_DisplayID)displayId) : 0;
}
UX_EXPORT int uxsdl3_video_driver_count(void) { return SDL_GetNumVideoDrivers(); }
UX_EXPORT const char *uxsdl3_video_driver_name(int index)
{
    const char *name = SDL_GetVideoDriver(index);
    return name ? name : "";
}
UX_EXPORT const char *uxsdl3_current_video_driver(void)
{
    const char *name = SDL_GetCurrentVideoDriver();
    return name ? name : "";
}
UX_EXPORT int uxsdl3_screensaver_enabled(void) { return SDL_ScreenSaverEnabled() ? 1 : 0; }
UX_EXPORT int uxsdl3_set_screensaver(int enabled)
{
    return (enabled ? SDL_EnableScreenSaver() : SDL_DisableScreenSaver()) ? 1 : 0;
}
UX_EXPORT int uxsdl3_system_theme(void) { return (int)SDL_GetSystemTheme(); }

/* ---- Window (more) ---- */
UX_EXPORT const char *uxsdl3_get_window_title(long long handle)
{
    const char *title = handle ? SDL_GetWindowTitle(UX_WIN(handle)) : NULL;
    return title ? title : "";
}
/* which: 0 width, 1 height in real pixels (differs from the window size on high-DPI displays) */
UX_EXPORT int uxsdl3_get_window_pixel_size(long long handle, int which)
{
    int w = 0, h = 0;
    if (handle) SDL_GetWindowSizeInPixels(UX_WIN(handle), &w, &h);
    return which == 0 ? w : h;
}
UX_EXPORT int uxsdl3_set_window_position(long long handle, int x, int y)
{
    return (handle && SDL_SetWindowPosition(UX_WIN(handle), x, y)) ? 1 : 0;
}
/* which: 0 x, 1 y */
UX_EXPORT int uxsdl3_get_window_position(long long handle, int which)
{
    int x = 0, y = 0;
    if (handle) SDL_GetWindowPosition(UX_WIN(handle), &x, &y);
    return which == 0 ? x : y;
}
UX_EXPORT int uxsdl3_set_window_min_size(long long handle, int w, int h)
{
    return (handle && SDL_SetWindowMinimumSize(UX_WIN(handle), w, h)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_max_size(long long handle, int w, int h)
{
    return (handle && SDL_SetWindowMaximumSize(UX_WIN(handle), w, h)) ? 1 : 0;
}
/* which: 0 width, 1 height (0 = no limit) */
UX_EXPORT int uxsdl3_get_window_min_size(long long handle, int which)
{
    int w = 0, h = 0;
    if (handle) SDL_GetWindowMinimumSize(UX_WIN(handle), &w, &h);
    return which == 0 ? w : h;
}
UX_EXPORT int uxsdl3_get_window_max_size(long long handle, int which)
{
    int w = 0, h = 0;
    if (handle) SDL_GetWindowMaximumSize(UX_WIN(handle), &w, &h);
    return which == 0 ? w : h;
}
UX_EXPORT int uxsdl3_set_window_fullscreen(long long handle, int fullscreen)
{
    return (handle && SDL_SetWindowFullscreen(UX_WIN(handle), fullscreen != 0)) ? 1 : 0;
}
UX_EXPORT long long uxsdl3_get_window_flags(long long handle)
{
    return handle ? (long long)SDL_GetWindowFlags(UX_WIN(handle)) : 0;
}
UX_EXPORT int uxsdl3_set_window_bordered(long long handle, int bordered)
{
    return (handle && SDL_SetWindowBordered(UX_WIN(handle), bordered != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_resizable(long long handle, int resizable)
{
    return (handle && SDL_SetWindowResizable(UX_WIN(handle), resizable != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_always_on_top(long long handle, int onTop)
{
    return (handle && SDL_SetWindowAlwaysOnTop(UX_WIN(handle), onTop != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_focusable(long long handle, int focusable)
{
    return (handle && SDL_SetWindowFocusable(UX_WIN(handle), focusable != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_minimize_window(long long handle)
{
    return (handle && SDL_MinimizeWindow(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_maximize_window(long long handle)
{
    return (handle && SDL_MaximizeWindow(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_restore_window(long long handle)
{
    return (handle && SDL_RestoreWindow(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_raise_window(long long handle)
{
    return (handle && SDL_RaiseWindow(UX_WIN(handle))) ? 1 : 0;
}
/* Waits until pending window changes (position, size, state) have been applied; returns 1 when they were. */
UX_EXPORT int uxsdl3_sync_window(long long handle)
{
    return (handle && SDL_SyncWindow(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_opacity(long long handle, double opacity)
{
    return (handle && SDL_SetWindowOpacity(UX_WIN(handle), (float)opacity)) ? 1 : 0;
}
UX_EXPORT double uxsdl3_get_window_opacity(long long handle)
{
    return handle ? (double)SDL_GetWindowOpacity(UX_WIN(handle)) : -1.0;
}
UX_EXPORT int uxsdl3_window_id(long long handle) { return handle ? (int)SDL_GetWindowID(UX_WIN(handle)) : 0; }
UX_EXPORT long long uxsdl3_window_from_id(int id)
{
    return (id > 0) ? (long long)(intptr_t)SDL_GetWindowFromID((SDL_WindowID)id) : 0;
}
UX_EXPORT int uxsdl3_window_display(long long handle)
{
    return handle ? (int)SDL_GetDisplayForWindow(UX_WIN(handle)) : 0;
}
UX_EXPORT double uxsdl3_window_display_scale(long long handle)
{
    return handle ? (double)SDL_GetWindowDisplayScale(UX_WIN(handle)) : 0.0;
}
UX_EXPORT double uxsdl3_window_pixel_density(long long handle)
{
    return handle ? (double)SDL_GetWindowPixelDensity(UX_WIN(handle)) : 0.0;
}
UX_EXPORT int uxsdl3_set_window_mouse_grab(long long handle, int grabbed)
{
    return (handle && SDL_SetWindowMouseGrab(UX_WIN(handle), grabbed != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_get_window_mouse_grab(long long handle)
{
    return (handle && SDL_GetWindowMouseGrab(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_keyboard_grab(long long handle, int grabbed)
{
    return (handle && SDL_SetWindowKeyboardGrab(UX_WIN(handle), grabbed != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_get_window_keyboard_grab(long long handle)
{
    return (handle && SDL_GetWindowKeyboardGrab(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_relative_mouse(long long handle, int enabled)
{
    return (handle && SDL_SetWindowRelativeMouseMode(UX_WIN(handle), enabled != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_get_window_relative_mouse(long long handle)
{
    return (handle && SDL_GetWindowRelativeMouseMode(UX_WIN(handle))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_set_window_icon_bmp(long long handle, const char *bmpPath)
{
    SDL_Surface *surface;
    int ok;
    if (!handle || !bmpPath) return 0;
    surface = SDL_LoadBMP(bmpPath);
    if (!surface) return 0;
    ok = SDL_SetWindowIcon(UX_WIN(handle), surface) ? 1 : 0;
    SDL_DestroySurface(surface);
    return ok;
}
/* operation: 0 cancel, 1 briefly, 2 until focused */
UX_EXPORT int uxsdl3_flash_window(long long handle, int operation)
{
    return (handle && SDL_FlashWindow(UX_WIN(handle), (SDL_FlashOperation)operation)) ? 1 : 0;
}

/* ---- Mouse / cursor ---- */
_Static_assert(SDL_SYSTEM_CURSOR_DEFAULT == 0 && SDL_SYSTEM_CURSOR_TEXT == 1 && SDL_SYSTEM_CURSOR_WAIT == 2 &&
               SDL_SYSTEM_CURSOR_CROSSHAIR == 3 && SDL_SYSTEM_CURSOR_PROGRESS == 4 && SDL_SYSTEM_CURSOR_NWSE_RESIZE == 5 &&
               SDL_SYSTEM_CURSOR_NESW_RESIZE == 6 && SDL_SYSTEM_CURSOR_EW_RESIZE == 7 && SDL_SYSTEM_CURSOR_NS_RESIZE == 8 &&
               SDL_SYSTEM_CURSOR_MOVE == 9 && SDL_SYSTEM_CURSOR_NOT_ALLOWED == 10 && SDL_SYSTEM_CURSOR_POINTER == 11,
               "uxsdl3.bas CURSOR_* constants must match SDL_SystemCursor");
static SDL_Cursor *uxSdl3Cursors[SDL_SYSTEM_CURSOR_COUNT];
UX_EXPORT int uxsdl3_show_cursor(void) { return SDL_ShowCursor() ? 1 : 0; }
UX_EXPORT int uxsdl3_hide_cursor(void) { return SDL_HideCursor() ? 1 : 0; }
UX_EXPORT int uxsdl3_cursor_visible(void) { return SDL_CursorVisible() ? 1 : 0; }
/* Switches to a system cursor (created once, reused). id: see CURSOR_* in uxsdl3.bas. */
UX_EXPORT int uxsdl3_set_system_cursor(int id)
{
    if (id < 0 || id >= SDL_SYSTEM_CURSOR_COUNT) return 0;
    if (!uxSdl3Cursors[id]) uxSdl3Cursors[id] = SDL_CreateSystemCursor((SDL_SystemCursor)id);
    return (uxSdl3Cursors[id] && SDL_SetCursor(uxSdl3Cursors[id])) ? 1 : 0;
}
UX_EXPORT int uxsdl3_warp_mouse_in_window(long long handle, double x, double y)
{
    if (!handle) return 0;
    SDL_WarpMouseInWindow(UX_WIN(handle), (float)x, (float)y);
    return 1;
}
UX_EXPORT int uxsdl3_warp_mouse_global(double x, double y)
{
    return SDL_WarpMouseGlobal((float)x, (float)y) ? 1 : 0;
}
UX_EXPORT int uxsdl3_capture_mouse(int enabled) { return SDL_CaptureMouse(enabled != 0) ? 1 : 0; }
/* which: 0 x, 1 y (desktop coordinates) */
UX_EXPORT int uxsdl3_global_mouse(int which)
{
    float x = 0.0f, y = 0.0f;
    SDL_GetGlobalMouseState(&x, &y);
    return (int)(which == 0 ? x : y);
}
UX_EXPORT int uxsdl3_has_mouse(void) { return SDL_HasMouse() ? 1 : 0; }
UX_EXPORT int uxsdl3_has_keyboard(void) { return SDL_HasKeyboard() ? 1 : 0; }
UX_EXPORT int uxsdl3_mouse_count(void)
{
    int count = 0;
    SDL_MouseID *ids = SDL_GetMice(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}
UX_EXPORT int uxsdl3_keyboard_count(void)
{
    int count = 0;
    SDL_KeyboardID *ids = SDL_GetKeyboards(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}

/* ---- Keyboard: names and codes ---- */
UX_EXPORT int uxsdl3_scancode_from_name(const char *name)
{
    return name ? (int)SDL_GetScancodeFromName(name) : 0;
}
UX_EXPORT int uxsdl3_key_from_scancode(int scancode)
{
    return (int)SDL_GetKeyFromScancode((SDL_Scancode)scancode, SDL_KMOD_NONE, false);
}
UX_EXPORT int uxsdl3_scancode_from_key(int keycode)
{
    return (int)SDL_GetScancodeFromKey((SDL_Keycode)keycode, NULL);
}
UX_EXPORT const char *uxsdl3_key_name(int keycode)
{
    const char *name = SDL_GetKeyName((SDL_Keycode)keycode);
    return name ? name : "";
}
UX_EXPORT int uxsdl3_has_screen_keyboard(void) { return SDL_HasScreenKeyboardSupport() ? 1 : 0; }
UX_EXPORT void uxsdl3_set_mod_state(int mods) { SDL_SetModState((SDL_Keymod)mods); }
/* ================================================================================================
   Renderer (more) and textures. Colors are packed RGBA in one unsigned int (r | g<<8 | b<<16 | a<<24),
   the same packing uxraylib uses. Everything works with the software renderer, so it also runs
   headless (SDL_VIDEODRIVER=dummy).
   ================================================================================================ */
_Static_assert(SDL_BLENDMODE_NONE == 0 && SDL_BLENDMODE_BLEND == 1 && SDL_BLENDMODE_ADD == 2 && SDL_BLENDMODE_MOD == 4 &&
               SDL_BLENDMODE_MUL == 8 && SDL_BLENDMODE_BLEND_PREMULTIPLIED == 0x10 && SDL_BLENDMODE_ADD_PREMULTIPLIED == 0x20,
               "uxsdl3.bas BLEND_* constants must match SDL_BLENDMODE_*");
_Static_assert(SDL_TEXTUREACCESS_STATIC == 0 && SDL_TEXTUREACCESS_STREAMING == 1 && SDL_TEXTUREACCESS_TARGET == 2,
               "uxsdl3.bas TEXTUREACCESS_* constants must match SDL_TextureAccess");
_Static_assert(SDL_SCALEMODE_NEAREST == 0 && SDL_SCALEMODE_LINEAR == 1,
               "uxsdl3.bas SCALEMODE_* constants must match SDL_ScaleMode");
_Static_assert(SDL_LOGICAL_PRESENTATION_DISABLED == 0 && SDL_LOGICAL_PRESENTATION_STRETCH == 1 &&
               SDL_LOGICAL_PRESENTATION_LETTERBOX == 2 && SDL_LOGICAL_PRESENTATION_OVERSCAN == 3 &&
               SDL_LOGICAL_PRESENTATION_INTEGER_SCALE == 4,
               "uxsdl3.bas LOGICAL_* constants must match SDL_RendererLogicalPresentation");
_Static_assert(SDL_FLIP_NONE == 0 && SDL_FLIP_HORIZONTAL == 1 && SDL_FLIP_VERTICAL == 2,
               "uxsdl3.bas FLIP_* constants must match SDL_FlipMode");

static unsigned int uxSdl3PackRgba(Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{
    return (unsigned int)r | ((unsigned int)g << 8) | ((unsigned int)b << 16) | ((unsigned int)a << 24);
}
static int uxSdl3RectValue(int which, int x, int y, int w, int h)
{
    switch (which) {
    case 0: return x;
    case 1: return y;
    case 2: return w;
    default: return h;
    }
}

UX_EXPORT const char *uxsdl3_renderer_name(long long handle)
{
    const char *name = handle ? SDL_GetRendererName(UX_REN(handle)) : NULL;
    return name ? name : "";
}
/* which: 0 width, 1 height of the current render output (or target texture) in pixels */
UX_EXPORT int uxsdl3_render_output_size(long long handle, int which)
{
    int w = 0, h = 0;
    if (handle) SDL_GetRenderOutputSize(UX_REN(handle), &w, &h);
    return which == 0 ? w : h;
}
/* which: 0 red, 1 green, 2 blue, 3 alpha of the current draw color */
UX_EXPORT int uxsdl3_get_render_draw_color(long long handle, int which)
{
    Uint8 r = 0, g = 0, b = 0, a = 0;
    if (handle) SDL_GetRenderDrawColor(UX_REN(handle), &r, &g, &b, &a);
    return which == 0 ? r : which == 1 ? g : which == 2 ? b : a;
}
UX_EXPORT int uxsdl3_set_render_draw_blend_mode(long long handle, int mode)
{
    return (handle && SDL_SetRenderDrawBlendMode(UX_REN(handle), (SDL_BlendMode)mode)) ? 1 : 0;
}
/* Returns the blend mode, or -1 for an invalid renderer. */
UX_EXPORT int uxsdl3_get_render_draw_blend_mode(long long handle)
{
    SDL_BlendMode mode = SDL_BLENDMODE_NONE;
    if (!handle || !SDL_GetRenderDrawBlendMode(UX_REN(handle), &mode)) return -1;
    return (int)mode;
}
UX_EXPORT int uxsdl3_set_render_viewport(long long handle, int x, int y, int w, int h)
{
    SDL_Rect rect = { x, y, w, h };
    return (handle && SDL_SetRenderViewport(UX_REN(handle), &rect)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_reset_render_viewport(long long handle)
{
    return (handle && SDL_SetRenderViewport(UX_REN(handle), NULL)) ? 1 : 0;
}
/* which: 0 x, 1 y, 2 width, 3 height */
UX_EXPORT int uxsdl3_get_render_viewport(long long handle, int which)
{
    SDL_Rect rect = { 0, 0, 0, 0 };
    if (handle) SDL_GetRenderViewport(UX_REN(handle), &rect);
    return uxSdl3RectValue(which, rect.x, rect.y, rect.w, rect.h);
}
UX_EXPORT int uxsdl3_set_render_clip_rect(long long handle, int x, int y, int w, int h)
{
    SDL_Rect rect = { x, y, w, h };
    return (handle && SDL_SetRenderClipRect(UX_REN(handle), &rect)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_disable_render_clip(long long handle)
{
    return (handle && SDL_SetRenderClipRect(UX_REN(handle), NULL)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_render_clip_enabled(long long handle)
{
    return (handle && SDL_RenderClipEnabled(UX_REN(handle))) ? 1 : 0;
}
/* which: 0 x, 1 y, 2 width, 3 height */
UX_EXPORT int uxsdl3_get_render_clip_rect(long long handle, int which)
{
    SDL_Rect rect = { 0, 0, 0, 0 };
    if (handle) SDL_GetRenderClipRect(UX_REN(handle), &rect);
    return uxSdl3RectValue(which, rect.x, rect.y, rect.w, rect.h);
}
UX_EXPORT int uxsdl3_set_render_scale(long long handle, double sx, double sy)
{
    return (handle && SDL_SetRenderScale(UX_REN(handle), (float)sx, (float)sy)) ? 1 : 0;
}
/* which: 0 x scale, 1 y scale */
UX_EXPORT double uxsdl3_get_render_scale(long long handle, int which)
{
    float sx = 0.0f, sy = 0.0f;
    if (handle) SDL_GetRenderScale(UX_REN(handle), &sx, &sy);
    return (double)(which == 0 ? sx : sy);
}
/* Renders at a fixed logical size and lets SDL scale it to the output. mode: see LOGICAL_* in uxsdl3.bas. */
UX_EXPORT int uxsdl3_set_render_logical_presentation(long long handle, int w, int h, int mode)
{
    return (handle && SDL_SetRenderLogicalPresentation(UX_REN(handle), w, h, (SDL_RendererLogicalPresentation)mode)) ? 1 : 0;
}
/* Returns the logical width (which 0) or height (which 1); 0 when no logical size is set. */
UX_EXPORT int uxsdl3_get_render_logical_size(long long handle, int which)
{
    int w = 0, h = 0;
    SDL_RendererLogicalPresentation mode = SDL_LOGICAL_PRESENTATION_DISABLED;
    if (handle) SDL_GetRenderLogicalPresentation(UX_REN(handle), &w, &h, &mode);
    return which == 0 ? w : h;
}
UX_EXPORT int uxsdl3_get_render_logical_mode(long long handle)
{
    int w = 0, h = 0;
    SDL_RendererLogicalPresentation mode = SDL_LOGICAL_PRESENTATION_DISABLED;
    if (handle) SDL_GetRenderLogicalPresentation(UX_REN(handle), &w, &h, &mode);
    return (int)mode;
}
UX_EXPORT int uxsdl3_set_render_vsync(long long handle, int vsync)
{
    return (handle && SDL_SetRenderVSync(UX_REN(handle), vsync)) ? 1 : 0;
}
/* Returns the vsync interval, or -2 when it cannot be read. */
UX_EXPORT int uxsdl3_get_render_vsync(long long handle)
{
    int vsync = 0;
    if (!handle || !SDL_GetRenderVSync(UX_REN(handle), &vsync)) return -2;
    return vsync;
}
/* Window pixel position -> render (logical) coordinates and back. which: 0 x, 1 y. */
UX_EXPORT double uxsdl3_render_coords_from_window(long long handle, double wx, double wy, int which)
{
    float x = 0.0f, y = 0.0f;
    if (handle) SDL_RenderCoordinatesFromWindow(UX_REN(handle), (float)wx, (float)wy, &x, &y);
    return (double)(which == 0 ? x : y);
}
UX_EXPORT double uxsdl3_render_coords_to_window(long long handle, double x, double y, int which)
{
    float wx = 0.0f, wy = 0.0f;
    if (handle) SDL_RenderCoordinatesToWindow(UX_REN(handle), (float)x, (float)y, &wx, &wy);
    return (double)(which == 0 ? wx : wy);
}
/* The pixel at (x, y) of the current render target, packed RGBA; 0 when outside or on error. */
UX_EXPORT unsigned int uxsdl3_render_read_pixel(long long handle, int x, int y)
{
    SDL_Rect rect = { x, y, 1, 1 };
    SDL_Surface *surface;
    Uint8 r = 0, g = 0, b = 0, a = 0;
    unsigned int packed = 0;
    if (!handle) return 0;
    surface = SDL_RenderReadPixels(UX_REN(handle), &rect);
    if (!surface) return 0;
    if (SDL_ReadSurfacePixel(surface, 0, 0, &r, &g, &b, &a)) packed = uxSdl3PackRgba(r, g, b, a);
    SDL_DestroySurface(surface);
    return packed;
}
/* Saves the whole current render target as a BMP file (a screenshot). */
UX_EXPORT int uxsdl3_render_save_bmp(long long handle, const char *path)
{
    SDL_Surface *surface;
    int ok;
    if (!handle || !path) return 0;
    surface = SDL_RenderReadPixels(UX_REN(handle), NULL);
    if (!surface) return 0;
    ok = SDL_SaveBMP(surface, path) ? 1 : 0;
    SDL_DestroySurface(surface);
    return ok;
}
/* Built-in 8x8 debug font (ASCII); scale with uxsdl3_set_render_scale. */
UX_EXPORT int uxsdl3_render_debug_text(long long handle, double x, double y, const char *text)
{
    return (handle && text && SDL_RenderDebugText(UX_REN(handle), (float)x, (float)y, text)) ? 1 : 0;
}
/* Renders into a texture created with TEXTUREACCESS_TARGET; texture 0 goes back to the window. */
UX_EXPORT int uxsdl3_set_render_target(long long handle, long long texture)
{
    return (handle && SDL_SetRenderTarget(UX_REN(handle), texture ? UX_TEX(texture) : NULL)) ? 1 : 0;
}

/* ---- Textures ---- */
/* A blank RGBA texture. access: 0 static, 1 streaming, 2 render target. */
UX_EXPORT long long uxsdl3_create_texture(long long rendererHandle, int w, int h, int access)
{
    if (!rendererHandle || w <= 0 || h <= 0) return 0;
    return (long long)(intptr_t)SDL_CreateTexture(UX_REN(rendererHandle), SDL_PIXELFORMAT_RGBA32,
                                                  (SDL_TextureAccess)access, w, h);
}
/* Fills every pixel with one packed RGBA color (static or streaming textures). */
UX_EXPORT int uxsdl3_texture_fill(long long handle, unsigned int rgba)
{
    float fw = 0.0f, fh = 0.0f;
    int w, h;
    Uint32 *pixels;
    int ok;
    if (!handle || !SDL_GetTextureSize(UX_TEX(handle), &fw, &fh)) return 0;
    w = (int)fw;
    h = (int)fh;
    if (w <= 0 || h <= 0) return 0;
    pixels = (Uint32 *)SDL_malloc((size_t)w * (size_t)h * sizeof(Uint32));
    if (!pixels) return 0;
    for (int i = 0; i < w * h; ++i) pixels[i] = rgba;
    ok = SDL_UpdateTexture(UX_TEX(handle), NULL, pixels, w * (int)sizeof(Uint32)) ? 1 : 0;
    SDL_free(pixels);
    return ok;
}
/* Writes one pixel (static or streaming textures). */
UX_EXPORT int uxsdl3_texture_set_pixel(long long handle, int x, int y, unsigned int rgba)
{
    SDL_Rect rect = { x, y, 1, 1 };
    Uint32 pixel = rgba;
    return (handle && SDL_UpdateTexture(UX_TEX(handle), &rect, &pixel, (int)sizeof(pixel))) ? 1 : 0;
}
UX_EXPORT int uxsdl3_texture_set_color_mod(long long handle, int r, int g, int b)
{
    return (handle && SDL_SetTextureColorMod(UX_TEX(handle), (Uint8)r, (Uint8)g, (Uint8)b)) ? 1 : 0;
}
/* which: 0 red, 1 green, 2 blue */
UX_EXPORT int uxsdl3_texture_get_color_mod(long long handle, int which)
{
    Uint8 r = 0, g = 0, b = 0;
    if (handle) SDL_GetTextureColorMod(UX_TEX(handle), &r, &g, &b);
    return which == 0 ? r : which == 1 ? g : b;
}
UX_EXPORT int uxsdl3_texture_set_alpha_mod(long long handle, int a)
{
    return (handle && SDL_SetTextureAlphaMod(UX_TEX(handle), (Uint8)a)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_texture_get_alpha_mod(long long handle)
{
    Uint8 a = 0;
    if (handle) SDL_GetTextureAlphaMod(UX_TEX(handle), &a);
    return a;
}
UX_EXPORT int uxsdl3_texture_set_blend_mode(long long handle, int mode)
{
    return (handle && SDL_SetTextureBlendMode(UX_TEX(handle), (SDL_BlendMode)mode)) ? 1 : 0;
}
/* Returns the blend mode, or -1 for an invalid texture. */
UX_EXPORT int uxsdl3_texture_get_blend_mode(long long handle)
{
    SDL_BlendMode mode = SDL_BLENDMODE_NONE;
    if (!handle || !SDL_GetTextureBlendMode(UX_TEX(handle), &mode)) return -1;
    return (int)mode;
}
UX_EXPORT int uxsdl3_texture_set_scale_mode(long long handle, int mode)
{
    return (handle && SDL_SetTextureScaleMode(UX_TEX(handle), (SDL_ScaleMode)mode)) ? 1 : 0;
}
/* Returns the scale mode, or -1 for an invalid texture. */
UX_EXPORT int uxsdl3_texture_get_scale_mode(long long handle)
{
    SDL_ScaleMode mode = SDL_SCALEMODE_NEAREST;
    if (!handle || !SDL_GetTextureScaleMode(UX_TEX(handle), &mode)) return -1;
    return (int)mode;
}
/* A part of the texture (source rectangle) drawn into a destination rectangle. */
UX_EXPORT int uxsdl3_render_texture_rect(long long rendererHandle, long long textureHandle,
                                         double sx, double sy, double sw, double sh,
                                         double dx, double dy, double dw, double dh)
{
    SDL_FRect src = { (float)sx, (float)sy, (float)sw, (float)sh };
    SDL_FRect dst = { (float)dx, (float)dy, (float)dw, (float)dh };
    if (!rendererHandle || !textureHandle) return 0;
    return SDL_RenderTexture(UX_REN(rendererHandle), UX_TEX(textureHandle), &src, &dst) ? 1 : 0;
}
/* Whole texture, rotated by angle degrees (clockwise) and optionally flipped.
   flipAndCenter: bits 0-1 = flip (0 none, 1 horizontal, 2 vertical); bit 2 (4) = rotate around (cx, cy)
   relative to the destination rectangle's top-left corner instead of around its center. */
UX_EXPORT int uxsdl3_render_texture_rotated(long long rendererHandle, long long textureHandle,
                                            double dx, double dy, double dw, double dh,
                                            double angle, double cx, double cy, int flipAndCenter)
{
    SDL_FRect dst = { (float)dx, (float)dy, (float)dw, (float)dh };
    SDL_FPoint center = { (float)cx, (float)cy };
    if (!rendererHandle || !textureHandle) return 0;
    return SDL_RenderTextureRotated(UX_REN(rendererHandle), UX_TEX(textureHandle), NULL, &dst, angle,
                                    (flipAndCenter & 4) ? &center : NULL, (SDL_FlipMode)(flipAndCenter & 3)) ? 1 : 0;
}
/* Sprite sheet: frame number frameIndex (left to right, top to bottom) of frameW x frameH cells. */
UX_EXPORT int uxsdl3_render_texture_frame(long long rendererHandle, long long textureHandle,
                                          int frameW, int frameH, int frameIndex,
                                          double dx, double dy, double dw, double dh)
{
    float fw = 0.0f, fh = 0.0f;
    int columns;
    SDL_FRect src;
    SDL_FRect dst = { (float)dx, (float)dy, (float)dw, (float)dh };
    if (!rendererHandle || !textureHandle || frameW <= 0 || frameH <= 0 || frameIndex < 0) return 0;
    if (!SDL_GetTextureSize(UX_TEX(textureHandle), &fw, &fh)) return 0;
    columns = (int)fw / frameW;
    if (columns <= 0 || (frameIndex / columns + 1) * frameH > (int)fh) return 0;
    src.x = (float)((frameIndex % columns) * frameW);
    src.y = (float)((frameIndex / columns) * frameH);
    src.w = (float)frameW;
    src.h = (float)frameH;
    return SDL_RenderTexture(UX_REN(rendererHandle), UX_TEX(textureHandle), &src, &dst) ? 1 : 0;
}
/* ================================================================================================
   Timing (high resolution), wall clock, filesystem, system information, power, locale and touch
   ================================================================================================ */
UX_EXPORT long long uxsdl3_get_ticks_ns(void) { return (long long)SDL_GetTicksNS(); }
UX_EXPORT long long uxsdl3_perf_counter(void) { return (long long)SDL_GetPerformanceCounter(); }
UX_EXPORT long long uxsdl3_perf_frequency(void) { return (long long)SDL_GetPerformanceFrequency(); }
UX_EXPORT void uxsdl3_delay_ns(long long ns) { SDL_DelayNS((Uint64)((ns > 0) ? ns : 0)); }
UX_EXPORT void uxsdl3_delay_precise_ns(long long ns) { SDL_DelayPrecise((Uint64)((ns > 0) ? ns : 0)); }

/* Wall clock: nanoseconds since 1970-01-01 UTC, and its calendar parts.
   which: 0 year, 1 month, 2 day, 3 hour, 4 minute, 5 second, 6 nanosecond, 7 day of week (0 = Sunday),
   8 offset from UTC in seconds (localTime <> 0 converts to the local time zone). */
UX_EXPORT long long uxsdl3_current_time_ns(void)
{
    SDL_Time ticks = 0;
    if (!SDL_GetCurrentTime(&ticks)) return 0;
    return (long long)ticks;
}
UX_EXPORT int uxsdl3_date_part(long long ns, int localTime, int which)
{
    SDL_DateTime dt;
    if (!SDL_TimeToDateTime((SDL_Time)ns, &dt, localTime != 0)) return -1;
    switch (which) {
    case 0: return dt.year;
    case 1: return dt.month;
    case 2: return dt.day;
    case 3: return dt.hour;
    case 4: return dt.minute;
    case 5: return dt.second;
    case 6: return dt.nanosecond;
    case 7: return dt.day_of_week;
    default: return dt.utc_offset;
    }
}
/* Days in a month (1-12) of a year, leap years included; -1 for an invalid month. */
UX_EXPORT int uxsdl3_days_in_month(int year, int month) { return SDL_GetDaysInMonth(year, month); }
UX_EXPORT int uxsdl3_day_of_year(int year, int month, int day) { return SDL_GetDayOfYear(year, month, day); }

/* ---- Filesystem ---- */
static char *uxSdl3PathCache = NULL;
static char **uxSdl3ListCache = NULL;
static int uxSdl3ListCount = 0;
static const char *uxSdl3CacheString(char *owned)
{
    if (uxSdl3PathCache) SDL_free(uxSdl3PathCache);
    uxSdl3PathCache = owned;
    return uxSdl3PathCache ? uxSdl3PathCache : "";
}
UX_EXPORT const char *uxsdl3_base_path(void)
{
    const char *path = SDL_GetBasePath();
    return path ? path : "";
}
/* Per-user writable folder for an application (created when missing), ending in a path separator. */
UX_EXPORT const char *uxsdl3_pref_path(const char *org, const char *app)
{
    if (!org || !app) return "";
    return uxSdl3CacheString(SDL_GetPrefPath(org, app));
}
UX_EXPORT const char *uxsdl3_current_directory(void)
{
    return uxSdl3CacheString(SDL_GetCurrentDirectory());
}
UX_EXPORT int uxsdl3_create_directory(const char *path)
{
    return (path && SDL_CreateDirectory(path)) ? 1 : 0;
}
/* 0 = does not exist, 1 = file, 2 = directory, 3 = other */
UX_EXPORT int uxsdl3_path_type(const char *path)
{
    SDL_PathInfo info;
    if (!path || !SDL_GetPathInfo(path, &info)) return 0;
    return (int)info.type;
}
UX_EXPORT long long uxsdl3_path_size(const char *path)
{
    SDL_PathInfo info;
    if (!path || !SDL_GetPathInfo(path, &info)) return -1;
    return (long long)info.size;
}
/* Last modification time (nanoseconds since 1970, see uxsdl3_date_part); 0 when unknown. */
UX_EXPORT long long uxsdl3_path_modify_time(const char *path)
{
    SDL_PathInfo info;
    if (!path || !SDL_GetPathInfo(path, &info)) return 0;
    return (long long)info.modify_time;
}
/* Removes a file or an EMPTY directory (1 also when the path does not exist; 0 for a directory that still has entries). */
UX_EXPORT int uxsdl3_remove_path(const char *path) { return (path && SDL_RemovePath(path)) ? 1 : 0; }
UX_EXPORT int uxsdl3_rename_path(const char *oldPath, const char *newPath)
{
    return (oldPath && newPath && SDL_RenamePath(oldPath, newPath)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_copy_file(const char *oldPath, const char *newPath)
{
    return (oldPath && newPath && SDL_CopyFile(oldPath, newPath)) ? 1 : 0;
}
/* Entries of a directory whose names match a pattern ('*' and '?'), in the folder itself; an EMPTY pattern lists everything\n   below the folder, recursively (sub-folder entries come as "sub\name"). The count is returned; read the names with\n   uxsdl3_list_item. A new call replaces the previous list; -1 on error (for example a missing folder). */
UX_EXPORT int uxsdl3_list_directory(const char *path, const char *pattern)
{
    int count = 0;
    char **list;
    if (uxSdl3ListCache) {
        SDL_free(uxSdl3ListCache);
        uxSdl3ListCache = NULL;
    }
    uxSdl3ListCount = 0;
    if (!path) return -1;
    list = SDL_GlobDirectory(path, (pattern && pattern[0]) ? pattern : NULL, 0, &count);
    if (!list) return -1;
    uxSdl3ListCache = list;
    uxSdl3ListCount = count;
    return count;
}
UX_EXPORT const char *uxsdl3_list_item(int index)
{
    if (!uxSdl3ListCache || index < 0 || index >= uxSdl3ListCount) return "";
    return uxSdl3ListCache[index] ? uxSdl3ListCache[index] : "";
}

/* ---- System ---- */
UX_EXPORT int uxsdl3_cpu_count(void) { return SDL_GetNumLogicalCPUCores(); }
UX_EXPORT int uxsdl3_system_ram_mb(void) { return SDL_GetSystemRAM(); }
UX_EXPORT int uxsdl3_cpu_cache_line_size(void) { return SDL_GetCPUCacheLineSize(); }
/* which: 0 MMX, 1 SSE, 2 SSE2, 3 SSE3, 4 SSE4.1, 5 SSE4.2, 6 AVX, 7 AVX2, 8 AVX-512F, 9 NEON, 10 AltiVec, 11 LSX, 12 LASX */
UX_EXPORT int uxsdl3_cpu_feature(int which)
{
    switch (which) {
    case 0: return SDL_HasMMX() ? 1 : 0;
    case 1: return SDL_HasSSE() ? 1 : 0;
    case 2: return SDL_HasSSE2() ? 1 : 0;
    case 3: return SDL_HasSSE3() ? 1 : 0;
    case 4: return SDL_HasSSE41() ? 1 : 0;
    case 5: return SDL_HasSSE42() ? 1 : 0;
    case 6: return SDL_HasAVX() ? 1 : 0;
    case 7: return SDL_HasAVX2() ? 1 : 0;
    case 8: return SDL_HasAVX512F() ? 1 : 0;
    case 9: return SDL_HasNEON() ? 1 : 0;
    case 10: return SDL_HasAltiVec() ? 1 : 0;
    case 11: return SDL_HasLSX() ? 1 : 0;
    case 12: return SDL_HasLASX() ? 1 : 0;
    default: return 0;
    }
}
UX_EXPORT int uxsdl3_is_tablet(void) { return SDL_IsTablet() ? 1 : 0; }
UX_EXPORT int uxsdl3_is_tv(void) { return SDL_IsTV() ? 1 : 0; }
/* Power state: 0 unknown/error(-1), see POWER_* in uxsdl3.bas; seconds/percent are -1 when unknown. */
UX_EXPORT int uxsdl3_power_state(void)
{
    int seconds = -1, percent = -1;
    return (int)SDL_GetPowerInfo(&seconds, &percent);
}
UX_EXPORT int uxsdl3_power_seconds(void)
{
    int seconds = -1, percent = -1;
    SDL_GetPowerInfo(&seconds, &percent);
    return seconds;
}
UX_EXPORT int uxsdl3_power_percent(void)
{
    int seconds = -1, percent = -1;
    SDL_GetPowerInfo(&seconds, &percent);
    return percent;
}
/* Preferred locales, most preferred first (language such as "tr", country such as "TR" or ""). */
static SDL_Locale **uxSdl3LocaleCache = NULL;
static int uxSdl3LocaleCount = 0;
UX_EXPORT int uxsdl3_locale_count(void)
{
    int count = 0;
    SDL_Locale **list = SDL_GetPreferredLocales(&count);
    if (uxSdl3LocaleCache) SDL_free(uxSdl3LocaleCache);
    uxSdl3LocaleCache = list;
    uxSdl3LocaleCount = list ? count : 0;
    return uxSdl3LocaleCount;
}
UX_EXPORT const char *uxsdl3_locale_language(int index)
{
    if (!uxSdl3LocaleCache || index < 0 || index >= uxSdl3LocaleCount || !uxSdl3LocaleCache[index]) return "";
    return uxSdl3LocaleCache[index]->language ? uxSdl3LocaleCache[index]->language : "";
}
UX_EXPORT const char *uxsdl3_locale_country(int index)
{
    if (!uxSdl3LocaleCache || index < 0 || index >= uxSdl3LocaleCount || !uxSdl3LocaleCache[index]) return "";
    return uxSdl3LocaleCache[index]->country ? uxSdl3LocaleCache[index]->country : "";
}

/* ---- Touch (state comes from real touch devices; without one the counts are 0) ---- */
UX_EXPORT int uxsdl3_touch_device_count(void)
{
    int count = 0;
    SDL_TouchID *ids = SDL_GetTouchDevices(&count);
    if (!ids) return 0;
    SDL_free(ids);
    return count;
}
UX_EXPORT long long uxsdl3_touch_device_id_at(int index)
{
    int count = 0;
    long long id = 0;
    SDL_TouchID *ids = SDL_GetTouchDevices(&count);
    if (ids) {
        if (index >= 0 && index < count) id = (long long)ids[index];
        SDL_free(ids);
    }
    return id;
}
UX_EXPORT const char *uxsdl3_touch_device_name(long long id)
{
    const char *name = id ? SDL_GetTouchDeviceName((SDL_TouchID)id) : NULL;
    return name ? name : "";
}
/* -1 invalid, 0 touch screen (direct), 1 trackpad (absolute), 2 trackpad (relative) */
UX_EXPORT int uxsdl3_touch_device_type(long long id)
{
    return id ? (int)SDL_GetTouchDeviceType((SDL_TouchID)id) : -1;
}
UX_EXPORT int uxsdl3_touch_finger_count(long long id)
{
    int count = 0;
    SDL_Finger **fingers = id ? SDL_GetTouchFingers((SDL_TouchID)id, &count) : NULL;
    if (!fingers) return 0;
    SDL_free(fingers);
    return count;
}
/* which: 0 x, 1 y (both 0..1 across the device), 2 pressure 0..1 */
UX_EXPORT double uxsdl3_touch_finger(long long id, int index, int which)
{
    int count = 0;
    double result = 0.0;
    SDL_Finger **fingers = id ? SDL_GetTouchFingers((SDL_TouchID)id, &count) : NULL;
    if (fingers) {
        if (index >= 0 && index < count && fingers[index])
            result = (double)(which == 0 ? fingers[index]->x : which == 1 ? fingers[index]->y : fingers[index]->pressure);
        SDL_free(fingers);
    }
    return result;
}
/* ================================================================================================
   Joystick / gamepad (more): identity, player index, LED, battery, sensors, mappings, dead zone
   ================================================================================================ */
_Static_assert(SDL_SENSOR_ACCEL == 1 && SDL_SENSOR_GYRO == 2, "uxsdl3.bas SENSOR_* constants must match SDL_SensorType");
static char *uxSdl3MappingCache = NULL;
static char uxSdl3GuidText[64];

UX_EXPORT const char *uxsdl3_joystick_name_for_id(int instanceId)
{
    const char *name = (instanceId > 0) ? SDL_GetJoystickNameForID((SDL_JoystickID)instanceId) : NULL;
    return name ? name : "";
}
UX_EXPORT const char *uxsdl3_gamepad_name_for_id(int instanceId)
{
    const char *name = (instanceId > 0) ? SDL_GetGamepadNameForID((SDL_JoystickID)instanceId) : NULL;
    return name ? name : "";
}
UX_EXPORT int uxsdl3_joystick_vendor_for_id(int instanceId)
{
    return (instanceId > 0) ? (int)SDL_GetJoystickVendorForID((SDL_JoystickID)instanceId) : 0;
}
UX_EXPORT int uxsdl3_joystick_product_for_id(int instanceId)
{
    return (instanceId > 0) ? (int)SDL_GetJoystickProductForID((SDL_JoystickID)instanceId) : 0;
}
/* 0 unknown, 1 gamepad, 2 wheel, 3 arcade stick, 4 flight stick, 5 dance pad, 6 guitar, 7 drum kit, 8 arcade pad, 9 throttle */
UX_EXPORT int uxsdl3_joystick_type_for_id(int instanceId)
{
    return (instanceId > 0) ? (int)SDL_GetJoystickTypeForID((SDL_JoystickID)instanceId) : 0;
}

UX_EXPORT int uxsdl3_joystick_instance_id(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? (int)SDL_GetJoystickID(joystick) : 0;
}
UX_EXPORT int uxsdl3_joystick_vendor(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? (int)SDL_GetJoystickVendor(joystick) : 0;
}
UX_EXPORT int uxsdl3_joystick_product(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? (int)SDL_GetJoystickProduct(joystick) : 0;
}
UX_EXPORT int uxsdl3_joystick_type(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? (int)SDL_GetJoystickType(joystick) : 0;
}
/* The device GUID as 32 hexadecimal characters. */
UX_EXPORT const char *uxsdl3_joystick_guid(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    uxSdl3GuidText[0] = '\0';
    if (joystick) SDL_GUIDToString(SDL_GetJoystickGUID(joystick), uxSdl3GuidText, (int)sizeof(uxSdl3GuidText));
    return uxSdl3GuidText;
}
UX_EXPORT int uxsdl3_joystick_player_index(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? SDL_GetJoystickPlayerIndex(joystick) : -1;
}
UX_EXPORT int uxsdl3_joystick_set_player_index(int handle, int index)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return (joystick && SDL_SetJoystickPlayerIndex(joystick, index)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_joystick_rumble(int handle, int low, int high, int ms)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    if (!joystick) return 0;
    if (low < 0) low = 0;
    if (low > 65535) low = 65535;
    if (high < 0) high = 0;
    if (high > 65535) high = 65535;
    return SDL_RumbleJoystick(joystick, (Uint16)low, (Uint16)high, (Uint32)((ms > 0) ? ms : 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_joystick_num_balls(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    return joystick ? SDL_GetNumJoystickBalls(joystick) : 0;
}
/* Relative motion of a trackball since the last read. which: 0 dx, 1 dy */
UX_EXPORT int uxsdl3_joystick_ball(int handle, int ball, int which)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    int dx = 0, dy = 0;
    if (joystick) SDL_GetJoystickBall(joystick, ball, &dx, &dy);
    return which == 0 ? dx : dy;
}
/* Battery: state (see POWER_* in uxsdl3.bas) and percent (-1 unknown). */
UX_EXPORT int uxsdl3_joystick_power_state(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    int percent = -1;
    return joystick ? (int)SDL_GetJoystickPowerInfo(joystick, &percent) : (int)SDL_POWERSTATE_ERROR;
}
UX_EXPORT int uxsdl3_joystick_power_percent(int handle)
{
    SDL_Joystick *joystick = uxSdl3JoystickOf(handle);
    int percent = -1;
    if (joystick) SDL_GetJoystickPowerInfo(joystick, &percent);
    return percent;
}

/* 0 unknown, 1 standard, 2 Xbox 360, 3 Xbox One, 4 PS3, 5 PS4, 6 PS5, 7 Switch Pro, ... (SDL_GamepadType) */
UX_EXPORT int uxsdl3_gamepad_type(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? (int)SDL_GetGamepadType(gamepad) : 0;
}
UX_EXPORT const char *uxsdl3_gamepad_type_name(int type)
{
    const char *name = SDL_GetGamepadStringForType((SDL_GamepadType)type);
    return name ? name : "";
}
UX_EXPORT int uxsdl3_gamepad_player_index(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? SDL_GetGamepadPlayerIndex(gamepad) : -1;
}
UX_EXPORT int uxsdl3_gamepad_set_player_index(int handle, int index)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_SetGamepadPlayerIndex(gamepad, index)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_set_led(int handle, int r, int g, int b)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_SetGamepadLED(gamepad, (Uint8)r, (Uint8)g, (Uint8)b)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_power_state(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    int percent = -1;
    return gamepad ? (int)SDL_GetGamepadPowerInfo(gamepad, &percent) : (int)SDL_POWERSTATE_ERROR;
}
UX_EXPORT int uxsdl3_gamepad_power_percent(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    int percent = -1;
    if (gamepad) SDL_GetGamepadPowerInfo(gamepad, &percent);
    return percent;
}
UX_EXPORT int uxsdl3_gamepad_rumble_triggers(int handle, int left, int right, int ms)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    if (!gamepad) return 0;
    if (left < 0) left = 0;
    if (left > 65535) left = 65535;
    if (right < 0) right = 0;
    if (right > 65535) right = 65535;
    return SDL_RumbleGamepadTriggers(gamepad, (Uint16)left, (Uint16)right, (Uint32)((ms > 0) ? ms : 0)) ? 1 : 0;
}
/* Motion sensors: type 1 accelerometer (m/s^2), 2 gyroscope (rad/s). */
UX_EXPORT int uxsdl3_gamepad_has_sensor(int handle, int type)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_GamepadHasSensor(gamepad, (SDL_SensorType)type)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_set_sensor_enabled(int handle, int type, int enabled)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_SetGamepadSensorEnabled(gamepad, (SDL_SensorType)type, enabled != 0)) ? 1 : 0;
}
UX_EXPORT int uxsdl3_gamepad_sensor_enabled(int handle, int type)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return (gamepad && SDL_GamepadSensorEnabled(gamepad, (SDL_SensorType)type)) ? 1 : 0;
}
/* Axis of the last sensor reading. index: 0 x, 1 y, 2 z */
UX_EXPORT double uxsdl3_gamepad_sensor(int handle, int type, int index)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    float data[3] = { 0.0f, 0.0f, 0.0f };
    if (!gamepad || index < 0 || index > 2) return 0.0;
    if (!SDL_GetGamepadSensorData(gamepad, (SDL_SensorType)type, data, 3)) return 0.0;
    return (double)data[index];
}
UX_EXPORT const char *uxsdl3_gamepad_mapping(int handle)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    if (uxSdl3MappingCache) {
        SDL_free(uxSdl3MappingCache);
        uxSdl3MappingCache = NULL;
    }
    if (gamepad) uxSdl3MappingCache = SDL_GetGamepadMapping(gamepad);
    return uxSdl3MappingCache ? uxSdl3MappingCache : "";
}
/* Adds or updates a mapping line (SDL_GameControllerDB format): 1 added, 0 updated, -1 invalid. */
UX_EXPORT int uxsdl3_add_gamepad_mapping(const char *mapping)
{
    return mapping ? SDL_AddGamepadMapping(mapping) : -1;
}
UX_EXPORT const char *uxsdl3_gamepad_button_name(int button)
{
    const char *name = SDL_GetGamepadStringForButton((SDL_GamepadButton)button);
    return name ? name : "";
}
UX_EXPORT const char *uxsdl3_gamepad_axis_name(int axis)
{
    const char *name = SDL_GetGamepadStringForAxis((SDL_GamepadAxis)axis);
    return name ? name : "";
}
/* -1 when the name is unknown */
UX_EXPORT int uxsdl3_gamepad_button_from_name(const char *name)
{
    return name ? (int)SDL_GetGamepadButtonFromString(name) : -1;
}
UX_EXPORT int uxsdl3_gamepad_axis_from_name(const char *name)
{
    return name ? (int)SDL_GetGamepadAxisFromString(name) : -1;
}
/* Face-button label of this pad (1 A, 2 B, 3 X, 4 Y, 5 Cross, 6 Circle, 7 Square, 8 Triangle; 0 unknown). */
UX_EXPORT int uxsdl3_gamepad_button_label(int handle, int button)
{
    SDL_Gamepad *gamepad = uxSdl3GamepadOf(handle);
    return gamepad ? (int)SDL_GetGamepadButtonLabel(gamepad, (SDL_GamepadButton)button) : 0;
}
/* Axis normalized to -1.0 .. 1.0 with a dead zone: |value| below the dead zone reads 0.0, the rest is rescaled
   so the output still reaches +-1.0. deadZone 0.0 .. 0.99 (typical 0.15 for sticks). */
UX_EXPORT double uxsdl3_gamepad_axis_dead_zone(int handle, int axis, double deadZone)
{
    double v = uxsdl3_gamepad_axis_norm(handle, axis);
    double magnitude = (v < 0.0) ? -v : v;
    if (deadZone < 0.0) deadZone = 0.0;
    if (deadZone > 0.99) deadZone = 0.99;
    if (magnitude <= deadZone) return 0.0;
    magnitude = (magnitude - deadZone) / (1.0 - deadZone);
    return (v < 0.0) ? -magnitude : magnitude;
}
/* ---- Shutdown: give back everything the adapter itself opened ---- */
static void uxSdl3ReleaseResources(void)
{
    for (int i = 1; i < UX_MAX_SOUNDS; ++i) {
        if (uxSdl3SoundUsed[i]) uxsdl3_sound_unload(i);
    }
    for (int i = 1; i < UX_MAX_PADS; ++i) {
        if (uxSdl3Gamepads[i]) {
            SDL_CloseGamepad(uxSdl3Gamepads[i]);
            uxSdl3Gamepads[i] = NULL;
        }
        if (uxSdl3Joysticks[i]) {
            SDL_CloseJoystick(uxSdl3Joysticks[i]);
            uxSdl3Joysticks[i] = NULL;
        }
    }
    for (int i = 0; i < SDL_SYSTEM_CURSOR_COUNT; ++i) {
        if (uxSdl3Cursors[i]) {
            SDL_DestroyCursor(uxSdl3Cursors[i]);
            uxSdl3Cursors[i] = NULL;
        }
    }
    if (uxSdl3ClipboardCache) { SDL_free(uxSdl3ClipboardCache); uxSdl3ClipboardCache = NULL; }
    if (uxSdl3PathCache) { SDL_free(uxSdl3PathCache); uxSdl3PathCache = NULL; }
    if (uxSdl3ListCache) { SDL_free(uxSdl3ListCache); uxSdl3ListCache = NULL; uxSdl3ListCount = 0; }
    if (uxSdl3LocaleCache) { SDL_free(uxSdl3LocaleCache); uxSdl3LocaleCache = NULL; uxSdl3LocaleCount = 0; }
    if (uxSdl3MappingCache) { SDL_free(uxSdl3MappingCache); uxSdl3MappingCache = NULL; }
    /* input state starts clean for the next Init */
    SDL_memset(uxSdl3KeyHeld, 0, sizeof(uxSdl3KeyHeld));
    SDL_memset(uxSdl3KeyPressed, 0, sizeof(uxSdl3KeyPressed));
    SDL_memset(uxSdl3KeyReleased, 0, sizeof(uxSdl3KeyReleased));
    SDL_memset(uxSdl3MouseHeld, 0, sizeof(uxSdl3MouseHeld));
    SDL_memset(uxSdl3MousePressed, 0, sizeof(uxSdl3MousePressed));
    SDL_memset(uxSdl3MouseReleased, 0, sizeof(uxSdl3MouseReleased));
    SDL_memset(uxSdl3DeviceEvents, 0, sizeof(uxSdl3DeviceEvents));
    uxSdl3MouseTracked = 0;
    uxSdl3QuitRequested = 0;
    uxSdl3WindowEventBits = 0;
    uxSdl3DropCount = 0;
    uxSdl3TextIn[0] = '\0';
    uxSdl3TextPending[0] = '\0';
    uxSdl3MasterGain = 1.0f;
}