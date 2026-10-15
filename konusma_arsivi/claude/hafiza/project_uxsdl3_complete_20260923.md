---
name: uxsdl3-complete-2026-09-23
description: "uxsdl3 (SDL3 wrapper) was finished 2026-09-23 at Mete's request (\"dort basi mamur\") — where things live, how tests run headless, what is deliberately out of scope"
metadata:
  node_type: memory
  type: project
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-23T20:04:39.034Z
---

Mete (2026-09-23): "sdl3 icin 4 basi mamur, hic eksigi olmadan hizmet verecek sekilde isi tamamla" (finish SDL3 completely). Done in S-052:

- Adapter `runtime_ext/uxraylib/uxsdl3_adapter.c` (319 exports, gcc -Wall -Wextra -Werror, `_Static_assert` locks every constant the .bas mirrors), wrapper `libsx/uxsdl3/uxsdl3.bas` (~334 functions), guide `docs/UXB_SDL3_KILAVUZU_20260923_TR.md`.
- Generator for new wrappers: `tools/library_tools/gen_uxsdl3_wrappers.ps1`; signature audit: `python tools/library_tools/uxb_library_abi.py --root .` (also regenerates `build/manual/config/ffi_allowlist.txt` — additive, I did it once).
- Tests `tests/libraries/uxsdl3/` (8 programs) + `run_uxsdl3_smoke_tests.ps1` (4 engines, per-run timeout). Headless: programs call `SetHint("SDL_VIDEO_DRIVER","dummy")` / `SDL_AUDIO_DRIVER` themselves; software renderer + `RenderReadPixel` verify drawing; virtual joystick/gamepad and `Push*` injection replace hardware. Adapter version stays 100 (`wrapper_smoke.c` asserts it).
- Deliberately out of scope (documented): GPU/Vulkan/GL contexts, camera, HID, haptic, tray, threads, message box/OpenURL/dialogs, general surface API, real touch data.
- Dummy driver does not apply borderless/resizable/always-on-top/maximize flags, opacity, cursors, window icon — tests only assert what it really does.

**Why:** S-052 had been a "rest point" since 2026-09-07; this closes the SDL3 half (raylib Image slice done earlier; raylib Models/3D + Shaders still open).
**How to apply:** add new SDL3 functions to the .c file, regenerate wrappers, extend the matching test; do not bump adapter version without updating `wrapper_smoke.c`.
Finding trail this produced (language bugs found while testing): [[uxb-fix-plan-decisions-2026-09]] entries S-137..S-142 in ai_koordinasyon/SORUN_TAKIP.md.
