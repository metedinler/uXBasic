NAMESPACE uxterminal
FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_version", I32, CDECL)
END FUNCTION
FUNCTION EnableAnsi() AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_enable_ansi", I32, CDECL)
END FUNCTION
SUB Clear()
    CALL(DLL, "uxterminal.dll", "uxterminal_clear", VOID, CDECL)
END SUB
SUB HideCursor()
    CALL(DLL, "uxterminal.dll", "uxterminal_hide_cursor", VOID, CDECL)
END SUB
SUB ShowCursor()
    CALL(DLL, "uxterminal.dll", "uxterminal_show_cursor", VOID, CDECL)
END SUB
SUB SetScroll(x AS I32, y AS I32)
    CALL(DLL, "uxterminal.dll", "uxterminal_set_scroll", VOID, CDECL, "I32,I32", x, y)
END SUB
SUB DrawText(x AS I32, y AS I32, fg AS I32, bg AS I32, text AS STRING)
    CALL(DLL, "uxterminal.dll", "uxterminal_draw_text", VOID, CDECL, "I32,I32,I32,I32,STRPTR", x, y, fg, bg, text)
END SUB
SUB DrawSprite(x AS I32, y AS I32, fg AS I32, bg AS I32, sprite AS STRING)
    CALL(DLL, "uxterminal.dll", "uxterminal_draw_sprite", VOID, CDECL, "I32,I32,I32,I32,STRPTR", x, y, fg, bg, sprite)
END SUB
FUNCTION RectCollision(ax AS I32, ay AS I32, aw AS I32, ah AS I32, bx AS I32, by AS I32, bw AS I32, bh AS I32) AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_rect_collision", I32, CDECL, "I32,I32,I32,I32,I32,I32,I32,I32", ax, ay, aw, ah, bx, by, bw, bh)
END FUNCTION
FUNCTION GetWidth() AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_get_width", I32, CDECL)
END FUNCTION
FUNCTION GetHeight() AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_get_height", I32, CDECL)
END FUNCTION
FUNCTION KeyHit() AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_key_hit", I32, CDECL)
END FUNCTION
FUNCTION GetKey() AS I32
    RETURN CALL(DLL, "uxterminal.dll", "uxterminal_get_key", I32, CDECL)
END FUNCTION
SUB DrawCell(x AS I32, y AS I32, fg AS I32, bg AS I32, ch AS I32)
    CALL(DLL, "uxterminal.dll", "uxterminal_draw_cell", VOID, CDECL, "I32,I32,I32,I32,I32", x, y, fg, bg, ch)
END SUB
SUB DrawHLine(x AS I32, y AS I32, length AS I32, ch AS I32, fg AS I32, bg AS I32)
    CALL(DLL, "uxterminal.dll", "uxterminal_draw_hline", VOID, CDECL, "I32,I32,I32,I32,I32,I32", x, y, length, ch, fg, bg)
END SUB
SUB DrawVLine(x AS I32, y AS I32, length AS I32, ch AS I32, fg AS I32, bg AS I32)
    CALL(DLL, "uxterminal.dll", "uxterminal_draw_vline", VOID, CDECL, "I32,I32,I32,I32,I32,I32", x, y, length, ch, fg, bg)
END SUB
SUB DrawBox(x AS I32, y AS I32, w AS I32, h AS I32, fg AS I32, bg AS I32)
    CALL(DLL, "uxterminal.dll", "uxterminal_draw_box", VOID, CDECL, "I32,I32,I32,I32,I32,I32", x, y, w, h, fg, bg)
END SUB
END NAMESPACE
