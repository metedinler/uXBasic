# uXbasic Language Contract (R2)

## Core Rules
- QB 7.1 style syntax, strict declarations.
- No type suffix identifiers.
- Predeclare `SUB/FUNCTION` with `DECLARE`.
- Includes in header region.
- Arrays are 0-based by default.

## Inline Model
- Old forms (`_ASM`, `ASM_SUB`, `ASM_FUNCTION`) are replaced by:
  - `INLINE(language, programId, kind, params)`
  - `END INLINE`

## Operators (delta)
- Added: `++`, `--`, `+=`, `-=`, `*=`, `/=`, `\\=`, `=+`, `=-`, `**`, `@`
- `@` is pointer operator only.

## Timer
- `TIMER()`
- `TIMER(unit)` where unit in `ns, us, ms, s, min, h, day, year`
- `TIMER(startTick, endTick, unit)`

## Include/Import
- `INCLUDE "file.bas"`
- `IMPORT(<LANG>, "file")`
- Supported `<LANG>` values: `C`, `CPP`, `ASM`
