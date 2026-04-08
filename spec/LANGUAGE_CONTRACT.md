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
- `INCLUDE` is resolved post-parse with include-once semantics.
- `INCLUDE` and `IMPORT` paths must stay within source root.
- `IMPORT` entries are emitted to build manifest/link artifacts for Win11 flow.

## Procedure Declarations
- `DECLARE SUB Name([param [AS TYPE], ...])`
- `DECLARE FUNCTION Name([param [AS TYPE], ...]) AS TYPE`
- `SUB Name([param [AS TYPE], ...]) ... END SUB`
- `FUNCTION Name([param [AS TYPE], ...]) AS TYPE ... END FUNCTION`

## Type and Constant Declarations
- `CONST Name = expr[, Name = expr ...]`
- `REDIM Name(bounds) AS TYPE[, Name(bounds) AS TYPE ...]`
- `TYPE Name ... END TYPE` with fields as `fieldName AS TYPE`

## Input Statements
- `INPUT target[, target ...]`
- `INPUT promptExpr; target[, target ...]`
- `INPUT #channelExpr, target[, target ...]`
