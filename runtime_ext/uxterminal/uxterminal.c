#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>

#define UX_EXPORT __declspec(dllexport)

static int ux_scroll_x = 0;
static int ux_scroll_y = 0;

static void ux_write(const char *text)
{
    DWORD written = 0;
    HANDLE out = GetStdHandle(STD_OUTPUT_HANDLE);
    WriteFile(out, text, (DWORD)strlen(text), &written, NULL);
}

UX_EXPORT int uxterminal_version(void) { return 100; }

UX_EXPORT int uxterminal_enable_ansi(void)
{
    HANDLE out = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD mode = 0;
    if (!GetConsoleMode(out, &mode)) return 0;
    return SetConsoleMode(out, mode | ENABLE_VIRTUAL_TERMINAL_PROCESSING) ? 1 : 0;
}

UX_EXPORT void uxterminal_clear(void) { ux_write("\x1b[2J\x1b[H"); }
UX_EXPORT void uxterminal_hide_cursor(void) { ux_write("\x1b[?25l"); }
UX_EXPORT void uxterminal_show_cursor(void) { ux_write("\x1b[?25h"); }

UX_EXPORT void uxterminal_set_scroll(int x, int y)
{
    ux_scroll_x = x;
    ux_scroll_y = y;
}

UX_EXPORT void uxterminal_draw_text(int worldX, int worldY, int fg, int bg,
                                    const char *text)
{
    char prefix[96];
    int x = worldX - ux_scroll_x;
    int y = worldY - ux_scroll_y;
    if (x < 0 || y < 0 || !text) return;
    snprintf(prefix, sizeof(prefix), "\x1b[%d;%dH\x1b[38;5;%dm\x1b[48;5;%dm",
             y + 1, x + 1, fg & 255, bg & 255);
    ux_write(prefix);
    ux_write(text);
    ux_write("\x1b[0m");
}

UX_EXPORT void uxterminal_draw_sprite(int worldX, int worldY, int fg, int bg,
                                      const char *sprite)
{
    if (!sprite) return;
    int row = 0;
    const char *line = sprite;
    const char *p = sprite;
    char buffer[2048];
    while (1) {
        if (*p == '\n' || *p == '\0') {
            size_t length = (size_t)(p - line);
            if (length >= sizeof(buffer)) length = sizeof(buffer) - 1;
            memcpy(buffer, line, length);
            buffer[length] = '\0';
            uxterminal_draw_text(worldX, worldY + row, fg, bg, buffer);
            if (*p == '\0') break;
            line = p + 1;
            ++row;
        }
        ++p;
    }
}

UX_EXPORT int uxterminal_rect_collision(int ax, int ay, int aw, int ah,
                                        int bx, int by, int bw, int bh)
{
    return (ax < bx + bw && ax + aw > bx && ay < by + bh && ay + ah > by) ? 1 : 0;
}

UX_EXPORT int uxterminal_get_width(void)
{
    CONSOLE_SCREEN_BUFFER_INFO info;
    HANDLE out = GetStdHandle(STD_OUTPUT_HANDLE);
    if (!GetConsoleScreenBufferInfo(out, &info)) return 0;
    return info.srWindow.Right - info.srWindow.Left + 1;
}

UX_EXPORT int uxterminal_get_height(void)
{
    CONSOLE_SCREEN_BUFFER_INFO info;
    HANDLE out = GetStdHandle(STD_OUTPUT_HANDLE);
    if (!GetConsoleScreenBufferInfo(out, &info)) return 0;
    return info.srWindow.Bottom - info.srWindow.Top + 1;
}

UX_EXPORT int uxterminal_key_hit(void)
{
    return _kbhit() ? 1 : 0;
}

UX_EXPORT int uxterminal_get_key(void)
{
    int c = _getch();
    if (c == 0 || c == 224) {
        int c2 = _getch();
        return 1000 + c2;
    }
    return c;
}

UX_EXPORT void uxterminal_draw_cell(int worldX, int worldY, int fg, int bg, int ch)
{
    char buf[2];
    buf[0] = (char)ch;
    buf[1] = '\0';
    uxterminal_draw_text(worldX, worldY, fg, bg, buf);
}

UX_EXPORT void uxterminal_draw_hline(int worldX, int worldY, int length, int ch, int fg, int bg)
{
    char buffer[4096];
    int i;
    if (length <= 0) return;
    if (length >= (int)sizeof(buffer)) length = (int)sizeof(buffer) - 1;
    for (i = 0; i < length; ++i) buffer[i] = (char)ch;
    buffer[length] = '\0';
    uxterminal_draw_text(worldX, worldY, fg, bg, buffer);
}

UX_EXPORT void uxterminal_draw_vline(int worldX, int worldY, int length, int ch, int fg, int bg)
{
    int i;
    for (i = 0; i < length; ++i) {
        uxterminal_draw_cell(worldX, worldY + i, fg, bg, ch);
    }
}

UX_EXPORT void uxterminal_draw_box(int worldX, int worldY, int w, int h, int fg, int bg)
{
    if (w < 2 || h < 2) return;
    uxterminal_draw_hline(worldX + 1, worldY, w - 2, '-', fg, bg);
    uxterminal_draw_hline(worldX + 1, worldY + h - 1, w - 2, '-', fg, bg);
    uxterminal_draw_vline(worldX, worldY + 1, h - 2, '|', fg, bg);
    uxterminal_draw_vline(worldX + w - 1, worldY + 1, h - 2, '|', fg, bg);
    uxterminal_draw_cell(worldX, worldY, fg, bg, '+');
    uxterminal_draw_cell(worldX + w - 1, worldY, fg, bg, '+');
    uxterminal_draw_cell(worldX, worldY + h - 1, fg, bg, '+');
    uxterminal_draw_cell(worldX + w - 1, worldY + h - 1, fg, bg, '+');
}
